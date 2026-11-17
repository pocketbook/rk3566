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

static int rk_eink_is_initialized = 0;

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

static void read_vcom_from_vendor(void)
{
	char vcom_str[32] = {0};
	char vcom_args[32] = {0};

	/* Read vcom value from vendor storage part */
	if (vendor_storage_read(EINK_VCOM_ID, vcom_str, (32 - 1)) > 0) {
		snprintf(vcom_args, (32 - 1), "ebc_pmic.vcom=%s", vcom_str);
		printf("eink update bootargs: %s\n", vcom_args);
		env_update("bootargs", vcom_args);
	}
}

// read data from partition to memory
static int rk_eink_load_image(struct blk_desc *dev_desc, const char* part_name, u32 offset, void *addr, u32 size)
{
	disk_partition_t part_info;
	u32 blk_start, blk_count;
	int ret;

	if (part_get_info_by_name(dev_desc, part_name, &part_info) < 0) {
		printf("Could not find %s partition\n", part_name);
		return -ENODEV;
	}

	blk_start = part_info.start + offset / part_info.blksz;
	blk_count = DIV_ROUND_UP(size, part_info.blksz);
	ret = blk_dread(dev_desc, blk_start, blk_count, addr);
	printf("Load part '%s' offset %u: BLK %X to MEM %p SIZE %u, ret=%d\n",
			part_name, offset, blk_start, addr, size, ret);

	flush_dcache_range((ulong)addr, ALIGN((ulong)addr + size, CONFIG_SYS_CACHELINE_SIZE));
	return ret;
}

int rk_eink_setup(void)
{
	int ret;
	struct uclass *uc;
	struct udevice *dev;

	if (rk_eink_is_initialized) {
		printf("rk eink already init, skip setup\n");
		return 0;
	}

	ret = uclass_get(UCLASS_EINK_DISPLAY, &uc);
	if (ret) {
		printf("can't find uclass eink\n");
		return -ENODEV;
	}

	// Here, drivers of type UCLASS_EINK_DISPLAY are traversed and their probe functions are executed
	for (uclass_first_device(UCLASS_EINK_DISPLAY, &dev);
	     dev; uclass_next_device(&dev))
	;
	return 0;
}

static int rk_ebc_probe(struct udevice *dev)
{
	struct blk_desc *dev_desc = rockchip_get_bootdev();
	struct rk_eink_plat *plat = dev_get_platdata(dev);
	int ret;

	/* Before relocation we don't need to do anything */
	if (!(gd->flags & GD_FLG_RELOC)) {
		return 0;
	}

	if (!dev_desc) {
		printf("%s: Could not find device\n", __func__);
		return -ENODEV;
	}

	// load waveform partition to memory
	ret = rk_eink_load_image(dev_desc, CONFIG_PB_WAVEFORM_PARTITION, CONFIG_PB_WAVEFORM_OFFSET,
			plat->waveform_base, plat->waveform_size);
	if (ret < 0) {
		printf("No waveform image!!!\n");
		return ret;
	}

	// load logo partition to memory
	ret = rk_eink_load_image(dev_desc, CONFIG_PB_LOGO_PARTITION, CONFIG_PB_LOGO_OFFSET,
			plat->logo_base, plat->logo_size);
	if (ret < 0) {
		printf("No logo image!!!\n");
		return ret;
	}

	flush_dcache_range((ulong)plat->waveform_base, ALIGN((ulong)plat->waveform_base + plat->waveform_size,
				 CONFIG_SYS_CACHELINE_SIZE));
	flush_dcache_range((ulong)plat->logo_base, ALIGN((ulong)plat->logo_base + plat->logo_size,
				 CONFIG_SYS_CACHELINE_SIZE));

	// read VCOM
	read_vcom_from_vendor();

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

/**
 * soc: range [0,100], -1 mean low battery
 */
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
