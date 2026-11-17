#include <common.h>
#include <dm.h>
#include <stdio.h>
#include <errno.h>
#include <mapmem.h>
#include <stdlib.h>
#include <asm/arch/vendor.h>
#include <dm/device-internal.h>
#include <dm/of_access.h>
#include <dm/uclass.h>
#include <dm/uclass-id.h>
#include <boot_rkimg.h>
#include <rk_eink.h>
#include <backlight.h>
#include <power/regulator.h>
#include <thermal.h>
#include "rk_ebc.h"
#include "epdlut/epd_lut.h"

#include "rk_ebc.h"

#define WAVEFORM_PARTITION		"waveform"
#define LOGO_PARTITION			"logo"

#define EINK_VCOM_ID		17
#define EINK_VCOM_MAX		64
#define VCOM_DEFAULT_VALUE	1650

#define ELOGO_MAGIC         "RKEL"

enum {
    LOGO_UBOOT = 0,
    LOGO_KERNEL,
    LOGO_CHARGE,
    LOGO_LOW_BATTERY,
    LOGO_POWEROFF,
    LOGO_RESET,
    LOGO_MAX,
};

struct logo_entry_t {
    int offset; // the offset of the first iamge in the file
    int count; // how much logo images
    int interval; // logo display interval in ms;
    int compress; // 0 - none, 1 - lz4
    int epd_mode;
} __attribute__ ((packed));

struct logo_t {
    char magic[4];
    unsigned int size;
    unsigned int version;
    int width;
    int height;
    int cfa;
    struct logo_entry_t entry[LOGO_MAX];
} __attribute__ ((packed));

struct rk_eink_plat {
	struct udevice *dev;
	struct udevice *ebc_tcon_dev;
	struct udevice *ebc_pwr_dev;
	struct udevice *regulator_dev;
	struct udevice *thermal_dev;
	struct udevice *backlight;
	struct ebc_panel panel;
	int vcom;

	u8 *waveform_base;
	u32 waveform_size;
	u8 *logo_base;
	u32 logo_size;
};

// save last show logo address
static u8* rk_last_logo_addr = NULL;

// 判断是否初始化过
static int rk_eink_is_initialized = 0;
static struct udevice *rk_eink_dev = NULL;

#if !CONFIG_IS_ENABLED(DM_THERMAL)
inline int thermal_get_temp(struct udevice *dev, int *temp)
{
	return 0;
}
#endif

static int ebc_power_set(struct rk_eink_plat *plat, int is_on)
{
	int ret;
	struct ebc_panel *panel = &plat->panel;
	struct udevice *ebc_tcon_dev = plat->ebc_tcon_dev;
	struct rk_ebc_tcon_ops *ebc_tcon_ops = ebc_tcon_get_ops(ebc_tcon_dev);
	struct udevice *ebc_pwr_dev = plat->ebc_pwr_dev;
	struct rk_ebc_pwr_ops *pwr_ops = NULL;

	if (ebc_pwr_dev)
		pwr_ops = ebc_pwr_get_ops(ebc_pwr_dev);

	if (is_on) {
		if (pwr_ops)
			ret = pwr_ops->power_on(ebc_pwr_dev);
		else
			ret  = regulator_set_enable(plat->regulator_dev, true);
		if (ret) {
			printf("%s, power on failed\n", __func__);
			return -1;
		}
		ret = ebc_tcon_ops->enable(ebc_tcon_dev, panel);
		if (ret) {
			printf("%s, ebc tcon enabled failed\n", __func__);
			return -1;
		}
	} else {
		ret = ebc_tcon_ops->disable(ebc_tcon_dev);
		if (ret) {
			printf("%s, ebc tcon disable failed\n", __func__);
			return -1;
		}

		if (pwr_ops)
			ret = pwr_ops->power_down(ebc_pwr_dev);
		else
			ret  = regulator_set_enable(plat->regulator_dev, false);
		if (ret) {
			printf("%s, power_down failed\n", __func__);
			return -1;
		}
	}
	return 0;
}

static int ebc_power_on(struct rk_eink_plat *plat)
{
	return ebc_power_set(plat, 1);
}

static int ebc_power_off(struct rk_eink_plat *plat)
{
	return ebc_power_set(plat, 0);
}

static int read_temperature(struct rk_eink_plat *plat)
{
	struct udevice *ebc_pwr_dev = plat->ebc_pwr_dev;
	struct rk_ebc_pwr_ops *pwr_ops = NULL;
	int temperature;

	if (ebc_pwr_dev)
		pwr_ops = ebc_pwr_get_ops(ebc_pwr_dev);

	if (pwr_ops)
		pwr_ops->temp_get(ebc_pwr_dev, (u32*)&temperature);
	else
		thermal_get_temp(plat->thermal_dev, &temperature);

	if (temperature <= 0 || temperature > 50) {
		printf("temperature = %d, out of range 0~50 ,use 25\n",
		       temperature);
		temperature = 25;
	}

	return temperature;
}

static int rk_eink_scanout(struct rk_eink_plat *plat, void *old_img_addr,
			void *new_img_addr, u32 lut_type, int update_mode)
{
	int temperature;
	u32 frame_num;

	struct ebc_panel *panel = &plat->panel;
	struct udevice *ebc_tcon_dev = plat->ebc_tcon_dev;
	struct rk_ebc_tcon_ops *ebc_tcon_ops = ebc_tcon_get_ops(ebc_tcon_dev);

	// read temperature
	temperature = read_temperature(plat);

	// get LUT by temperature and type
	panel->lut_ops.lut_get(&panel->lut_data, lut_type, temperature);
	frame_num = panel->lut_data.frame_num;

	printf("scan out: lut_type=%d, frame num=%d, temp=%d, update_mode=%d\n",
			lut_type, frame_num, temperature, update_mode);

	// waiting last frame done
	ebc_tcon_ops->wait_for_last_frame_complete(ebc_tcon_dev);

	// scan-out
	ebc_tcon_ops->lut_data_set(ebc_tcon_dev, panel->lut_data.data,
				   frame_num, 0);
	ebc_tcon_ops->dsp_mode_set(ebc_tcon_dev, update_mode,
				   LUT_MODE, !THREE_WIN_MODE, !EINK_MODE);
	ebc_tcon_ops->image_addr_set(ebc_tcon_dev, (u32)(u64)old_img_addr, (u32)(u64)new_img_addr);
	ebc_tcon_ops->frame_start(ebc_tcon_dev, frame_num);

	return 0;
}

int rk_eink_blank(struct rk_eink_plat *plat)
{
	struct logo_t *logo = (struct logo_t*)plat->logo_base;
	int size = (plat->panel.width * plat->panel.height) >> 1;
	u8 *img_addr = (u8*)logo + logo->entry[LOGO_RESET].offset;

	debug("reset logo addr: %p\n", img_addr);

	if (img_addr == NULL) {
		return -1;
	}

	flush_dcache_range((ulong)img_addr,
				ALIGN((ulong)img_addr + size, CONFIG_SYS_CACHELINE_SIZE));

	rk_eink_scanout(plat, img_addr, img_addr, WF_TYPE_RESET, EINK_LOGO_RESET);

	// save last logo address
	rk_last_logo_addr = img_addr;

	return 0;
}

static int read_vcom_from_vendor(void)
{
	int ret = 0;
	char vcom_str[EINK_VCOM_MAX] = {0};
	char vcom_args[EINK_VCOM_MAX] = {0};

	/* Read vcom value from vendor storage part */
	ret = vendor_storage_read(EINK_VCOM_ID, vcom_str, (EINK_VCOM_MAX - 1));
	if (ret > 0) {
		snprintf(vcom_args, strlen(vcom_str) + 15, "ebc_pmic.vcom=%s", vcom_str);
		printf("eink update bootargs: %s\n", vcom_args);
		env_update("bootargs", vcom_args);
	} else {
		return ret;
	}

	return atoi(vcom_str);
}

// read data from partition to memory
static int rk_eink_load_image(struct blk_desc *dev_desc, const char* part_name, void *addr, u32 size)
{
	disk_partition_t part_info;
	u32 blk_count;
	int ret;

	if (part_get_info_by_name(dev_desc, part_name, &part_info) < 0) {
		printf("Could not find %s partition\n", part_name);
		return -ENODEV;
	}

	blk_count = DIV_ROUND_UP(size, part_info.blksz);
	if (blk_count > part_info.size)
		blk_count = part_info.size;

	ret = blk_dread(dev_desc, part_info.start, blk_count, addr);
	printf("Load partition[%s] from BLK[0x%lX] to MEM[0x%p] SIZE[%ld], ret=%d\n",
			part_name, part_info.start, addr, blk_count*part_info.blksz, ret);
	if (ret < 0) {
		printf("read %s failed\n", part_name);
		return ret;
	}

	return 0;
}

static int check_logo(struct rk_eink_plat *plat)
{
	struct ebc_panel *panel = &plat->panel;
	struct logo_t *logo = (struct logo_t*)plat->logo_base;

	// ensure the logo is valid
	if (memcmp(logo->magic, ELOGO_MAGIC, strlen(ELOGO_MAGIC)) != 0) {
		printf("invalid logo image\n");
		return -1;
	}

	if (plat->logo_size < logo->size) {
		printf("logo memory size is %d but expect %d\n", plat->logo_size, logo->size);
		return -1;
	}

	if (logo->width != panel->width || logo->height != panel->height) {
		printf("invalid image size: %dx%d, screen is: %dx%d\n",
				logo->width, logo->height,
				panel->width, panel->height);
		return -1;
	}

	if (logo->entry[LOGO_RESET].count <= 0) {
		printf("cannot find reset logo!\n");
		return -1;
	}

	if (logo->entry[LOGO_UBOOT].count <= 0) {
		printf("cannot find uboot logo!\n");
		return -1;
	}

	return 0;
}

static int rk_ebc_probe(struct udevice *dev)
{
	struct blk_desc *dev_desc = rockchip_get_bootdev();
	struct rk_eink_plat *plat = dev_get_platdata(dev);
	struct ebc_panel *panel = &plat->panel;

	struct rk_ebc_pwr_ops *pwr_ops = NULL;
	struct udevice *child, *pmic_dev;
	int ret, vcom, size, i, uclass_id;
	bool find_pmic = false;
	const fdt32_t *list;
	uint32_t phandle;

	/* Before relocation we don't need to do anything */
	if (!(gd->flags & GD_FLG_RELOC))
		return 0;

	// 至此已说明eink driver初始化了，不论成功与否，此后不必再重复初始化
	if (rk_eink_is_initialized) {
		printf("rk eink already init, skip probe\n");
		return 0;
	}
	rk_eink_is_initialized = 1;

	if (!dev_desc) {
		printf("%s: Could not find device\n", __func__);
		return -ENODEV;
	}

	debug("load waveform and logo partition\n");

	// load waveform partition to memory
	ret = rk_eink_load_image(dev_desc, WAVEFORM_PARTITION, plat->waveform_base, plat->waveform_size);
	if (ret < 0) {
		printf("No waveform image!!!\n");
		return ret;
	}

	// load logo partition to memory
	ret = rk_eink_load_image(dev_desc, LOGO_PARTITION, plat->logo_base, plat->logo_size);
	if (ret < 0) {
		printf("No logo image!!!\n");
		return ret;
	}

	// setup waveform
	debug("setup waveform\n");
	flush_dcache_range((ulong)plat->waveform_base,
			   ALIGN((ulong)plat->waveform_base + plat->waveform_size,
				 CONFIG_SYS_CACHELINE_SIZE));
	ret = epd_lut_from_mem_init(plat->waveform_base, &panel->lut_ops);
	if (ret < 0 || panel->lut_ops.lut_get == NULL) {
		printf("lut init failed\n");
		return -EINVAL;
	}

	// check logo is valid
	debug("check logo\n");
	ret = check_logo(plat);
	if (ret < 0) {
		return -EINVAL;
	}

	// get TCON
	debug("get TCON\n");
	ret = uclass_get_device_by_phandle(UCLASS_EBC, dev,
					   "ebc_tcon",
					   &plat->ebc_tcon_dev);
	if (ret) {
		printf("Cannot get ebc_tcon: %d\n", ret);
		// maybe is soft tcon
		return ret;
	}

	// get PMIC
	debug("get PMIC\n");
	list = dev_read_prop(dev, "pmic", &size);
	if (!list) {
		dev_err(dev, "Cannot get pmic prop\n");
		return -EINVAL;
	}

	size /= sizeof(*list);
	for (i = 0; i < size; i++) {
		phandle = fdt32_to_cpu(*list++);
		/* TODO: migrate to pmic */
		ret = uclass_get_device_by_phandle_id(UCLASS_I2C_GENERIC,
						      phandle,
						      &plat->ebc_pwr_dev);
		if (!ret) {
			find_pmic = true;
			break;
		}

		ret = uclass_get_device_by_phandle_id(UCLASS_PMIC, phandle, &pmic_dev);
		if (!ret) {
			for (device_find_first_child(pmic_dev, &child); child;
			     device_find_next_child(&child)) {
				uclass_id = device_get_uclass_id(child);
				ret = device_probe(child);
				if (ret) {
					dev_warn(dev, "Failed to probe pmic %s\n", child->name);
					continue;
				}

				if (uclass_id == UCLASS_REGULATOR)
					plat->regulator_dev = child;
				else if (uclass_id == UCLASS_THERMAL)
					plat->thermal_dev = child;
			}

			find_pmic = true;
			break;
		}
	}
	if (!find_pmic) {
		dev_err(dev, "Cannot get pmic: %d\n", ret);
		return ret;
	}

	// get BackLight
	debug("get BackLight\n");
	ret = uclass_get_device_by_phandle(UCLASS_PANEL_BACKLIGHT, dev,
					   "backlight", &plat->backlight);
	if (ret && ret != -ENOENT) {
		printf("%s: Cannot get backlight: %d\n", __func__, ret);
	}

	// set VCOM
	debug("set VCOM\n");
	vcom = read_vcom_from_vendor();
	if (vcom <= 0) {
		printf("read vcom from vendor failed, use default vcom\n");
		plat->vcom = VCOM_DEFAULT_VALUE;
	} else {
		plat->vcom = vcom;
	}

	if (plat->ebc_pwr_dev)
		pwr_ops = ebc_pwr_get_ops(plat->ebc_pwr_dev);

	if (pwr_ops)
		ret = pwr_ops->vcom_set(plat->ebc_pwr_dev, plat->vcom);
	else
		ret = regulator_set_value(plat->regulator_dev, plat->vcom * 1000);
	if (ret) {
		printf("%s, vcom_set failed\n", __func__);
		return -EIO;
	}

	// power on
	debug("Power on\n");
	ret = ebc_power_on(plat);
	if (ret) {
		printf("Eink power on failed\n");
		return -1;
	}

	debug("blank\n");
	ret = rk_eink_blank(plat);
	if (ret < 0) {
		printf("eink blank failure!\n");
		ebc_power_off(plat);
		return -1;
	}

	rk_eink_dev = dev;

	printf("rk eink probe successful\n");

	return 0;
}

static int rk_ebc_ofdata_to_platdata(struct udevice *dev)
{
	fdt_size_t size;
	fdt_addr_t addr;
	struct device_node *waveform_node;
	struct device_node *logo_node;
	struct rk_eink_plat *plat = dev_get_platdata(dev);
	struct ebc_panel *panel = &plat->panel;

	if (rk_eink_is_initialized) {
		printf("rk eink already init, skip ofdata_to_platdata\n");
		return 0;
	}

	// get panel parameter
	panel->width = dev_read_u32_default(dev, "panel,width", 0);
	panel->height = dev_read_u32_default(dev, "panel,height", 0);
	panel->vir_width = dev_read_u32_default(dev, "panel,vir_width", panel->width);
	panel->vir_height = dev_read_u32_default(dev, "panel,vir_height", panel->height);
	panel->sdck = dev_read_u32_default(dev, "panel,sdck", 0);
	panel->lsl = dev_read_u32_default(dev, "panel,lsl", 0);
	panel->lbl = dev_read_u32_default(dev, "panel,lbl", 0);
	panel->ldl = dev_read_u32_default(dev, "panel,ldl", 0);
	panel->lel = dev_read_u32_default(dev, "panel,lel", 0);
	panel->gdck_sta = dev_read_u32_default(dev, "panel,gdck-sta", 0);
	panel->lgonl = dev_read_u32_default(dev, "panel,lgonl", 0);
	panel->fsl = dev_read_u32_default(dev, "panel,fsl", 0);
	panel->fbl = dev_read_u32_default(dev, "panel,fbl", 0);
	panel->fdl = dev_read_u32_default(dev, "panel,fdl", 0);
	panel->fel = dev_read_u32_default(dev, "panel,fel", 0);
	panel->panel_16bit = dev_read_u32_default(dev, "panel,panel_16bit", 0);
	panel->panel_color = dev_read_u32_default(dev, "panel,panel_color", 0);
	panel->mirror = dev_read_u32_default(dev, "panel,mirror", 0);
	panel->rearrange = dev_read_u32_default(dev, "panel,rearrange", 0);
	panel->width_mm = dev_read_u32_default(dev, "panel,width-mm", 0);
	panel->height_mm = dev_read_u32_default(dev, "panel,height-mm", 0);
	panel->sdce_width = dev_read_u32_default(dev, "panel,sdce_width", 0);
	panel->sdoe_mode = dev_read_u32_default(dev, "panel,sdoe_mode", 0);

	// get waveform memory
	waveform_node = of_parse_phandle(ofnode_to_np(dev_ofnode(dev)),
					"waveform-region", 0);
	if (!waveform_node) {
		printf("Cannot get waveform-region from dts\n");
		return -ENODEV;
	}
	addr = ofnode_get_addr_size(np_to_ofnode(waveform_node), "reg", &size);
	if (addr == FDT_ADDR_T_NONE) {
		printf("get waveform memory address failed\n");
		return -ENODEV;
	}

	plat->waveform_base = map_sysmem(addr, 0);
	plat->waveform_size = size;
	debug("waveform mem=0x%p, size=%x\n", plat->waveform_base, plat->waveform_size);

	// get logo memory
	logo_node = of_parse_phandle(ofnode_to_np(dev_ofnode(dev)),
					"logo-region", 0);
	if (!logo_node) {
		printf("Cannot get logo-region from dts, skip it\n");
		return 0;
	}
	addr = ofnode_get_addr_size(np_to_ofnode(logo_node), "reg", &size);
	if (addr == FDT_ADDR_T_NONE) {
		printf("get logo memory address failed, skip it\n");
		return 0;
	}

	plat->logo_base = map_sysmem(addr, 0);
	plat->logo_size = size;
	debug("logo mem=0x%p, size=%x\n", plat->logo_base, plat->logo_size);

	return 0;
}

static int rk_eink_setup(void)
{
	int ret;
	struct uclass *uc;
	struct udevice *dev;

	if (rk_eink_is_initialized) {
		printf("rk eink already init, skip setup\n");
		return 0;
	}

	printf("setup rk eink\n");

	ret = uclass_get(UCLASS_EINK_DISPLAY, &uc);
	if (ret) {
		printf("can't find uclass eink\n");
		return -ENODEV;
	}

	// 此处会遍历UCLASS_EINK_DISPLAY这种类型的驱动并执行其probe函数
	for (uclass_first_device(UCLASS_EINK_DISPLAY, &dev);
	     dev; uclass_next_device(&dev))
		;

	return 0;
}

static int rk_eink_show_logo(struct udevice *dev, int logo_type, int idx)
{
	struct rk_eink_plat *plat = dev_get_platdata(dev);
	int size = plat->panel.width * plat->panel.height / 2;
	struct logo_t *logo = (struct logo_t*)plat->logo_base;
	struct logo_entry_t *entry = &logo->entry[logo_type];
	u8 *img_addr = (u8*)logo + entry->offset + idx * size;

	debug("show logo: type=%d, index=%d\n", logo_type, idx);

	if (entry->count <= 0) {
		printf("No logo for type %d!\n", logo_type);
		return -1;
	}

	if (idx >= entry->count) {
		printf("out of image range: [%d, %d]\n", 0, entry->count-1);
		return -1;
	}

	if (entry->compress > 0) {
		printf("unsupport compressed logo under uboot!\n");
		return -1;
	}

	rk_eink_scanout(plat, rk_last_logo_addr, img_addr, WF_TYPE_GC16, EINK_UPDATE_DIFF);

	rk_last_logo_addr = img_addr;

	return 0;
}

int rk_eink_show_uboot_logo(void)
{
	if (!rk_eink_is_initialized) {
		// 若未初始化则先执行一次初始化
		rk_eink_setup();
	}

	if (!rk_eink_is_initialized || !rk_eink_dev) {
		// 没有初始化成功，直接返回
		return -1;
	}

	// 设备初始化成功，可以往下执行

	// 显示uboot logo
	rk_eink_show_logo(rk_eink_dev, LOGO_UBOOT, 0);

	// update uboot logo addr to boot args
	char logo_args[64] = {0};
	sprintf(logo_args, "ulogo_addr=0x%llx", (u64)rk_last_logo_addr);
	env_update("bootargs", logo_args);

	return 0;
}

/*
 * 根据charge图片数量，把电量分成相应等级
 * 若charge图片6张： 0, 1, 2, 3, 4, 5
 * 则电量分成5级: 0-20, 20-40, 40-60, 60-80, 80-100
 * 当电量<20时候，显示图片 0->1
 * 当电量<40时候，显示图片 1->2
 * ...
 * 当电量>=100时候，显示图片 5
 */

/**
 * soc: range [0,100], -1 mean low battery
 */
int rk_eink_show_charge_logo(int soc, int animation)
{
	if (!rk_eink_is_initialized) {
		// 若未初始化则先执行一次初始化
		rk_eink_setup();
	}

	if (!rk_eink_is_initialized || !rk_eink_dev) {
		// 没有初始化成功，直接返回
		return -1;
	}

	struct rk_eink_plat *plat = dev_get_platdata(rk_eink_dev);
	struct logo_t *logo = (struct logo_t*)plat->logo_base;
	struct logo_entry_t *entry = &logo->entry[LOGO_CHARGE];
	static int prev_level = -1;
	static ulong prev_tm = 0;
	int level = 0;

	if (entry->count <= 1) {
		// not enough logo
		return 0;
	}

	level = soc / (100 / (entry->count - 1));

	debug("charge soc=%d, level=%d\n", soc, level);

	if (soc < 0) {
		// 显示低电画面
		if (prev_level != -1) {
			rk_eink_show_logo(rk_eink_dev, LOGO_LOW_BATTERY, 0);
			prev_level = -1;
			prev_tm = get_timer(0);
		}
	} else if (!animation || soc >= 100) {
		// 非动画，则显示当前电量等级的图片
		printf("show fixed level %d\n", level);
		if (level != prev_level) {
			rk_eink_show_logo(rk_eink_dev, LOGO_CHARGE, level);
			prev_level = level;
			prev_tm = get_timer(0);
		}
	} else if (get_timer(prev_tm) > entry->interval) { // 动画，判断刷新间隔，若达到则等待并刷帧
		// 显示 level -> level+1 的图片
		printf("show animation level %d -> %d\n", level, level+1);
		if (level == prev_level) {
			rk_eink_show_logo(rk_eink_dev, LOGO_CHARGE, level+1);
			prev_level = level + 1;
		} else {
			rk_eink_show_logo(rk_eink_dev, LOGO_CHARGE, level);
			prev_level = level;
		}
		prev_tm = get_timer(0);
	}

	return 0;
}

int rk_eink_poweroff(void)
{
	struct rk_eink_plat *plat;
	struct udevice *ebc_tcon_dev;
	struct rk_ebc_tcon_ops *ebc_tcon_ops;

	if (!rk_eink_is_initialized || !rk_eink_dev) {
		// rk eink not init or init not finish
		return -1;
	}

	// show poweroff logo
	rk_eink_show_logo(rk_eink_dev, LOGO_POWEROFF, 0);

	plat = dev_get_platdata(rk_eink_dev);
	ebc_tcon_dev = plat->ebc_tcon_dev;

	// wait all frame done
	ebc_tcon_ops = ebc_tcon_get_ops(ebc_tcon_dev);
	ebc_tcon_ops->wait_for_last_frame_complete(ebc_tcon_dev);

	// shutdown ebc
	if (ebc_power_off(plat) < 0)
		printf("Eink power down failed\n");

	return 0;
}

static const struct udevice_id rk_ebc_ids[] = {
	{ .compatible = "rockchip,ebc" },
	{ .compatible = "rockchip,ebc-linux" },
	{ }
};

U_BOOT_DRIVER(rk_ebc) = {
	.name	= "rk_ebc",
	.id	= UCLASS_EINK_DISPLAY,
	.of_match = rk_ebc_ids,
	.ofdata_to_platdata = rk_ebc_ofdata_to_platdata,
	.probe	= rk_ebc_probe,
	.platdata_auto_alloc_size = sizeof(struct rk_eink_plat),
};

UCLASS_DRIVER(rk_eink) = {
	.id	= UCLASS_EINK_DISPLAY,
	.name	= "rk_eink",
};