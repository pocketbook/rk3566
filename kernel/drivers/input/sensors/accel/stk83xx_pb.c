#include <linux/module.h>
#include <linux/input.h>
#include <linux/interrupt.h>
#include <linux/platform_device.h>
#include <linux/async.h>
#include <linux/hrtimer.h>
#include <linux/init.h>
#include <linux/ioport.h>
#include <asm/irq.h>
#include <asm/io.h>
#include <asm/uaccess.h>
#include <linux/kthread.h>

#include <linux/i2c.h>
#include <linux/delay.h>
#include <linux/device.h>
#include <linux/jiffies.h>
#include <linux/miscdevice.h>
#include <linux/sensor-dev.h>

#include <linux/cdev.h>
#include <linux/slab.h>
#include <linux/uaccess.h>
#include <asm/ioctl.h>

#include <linux/gpio.h>
#include <linux/of_gpio.h>

#include <linux/suspend.h>

#define INF(s...) printk("[STK83xx] " s)
#define ERR(s...) printk("[STK83xx] " s)

#define STK83_NAME "stk83xx"

#define STK83_I2C_BUS  1
#define STK83_I2C_ADDR 0x0f

#define STK83XX_REG_CHIPID            0x00
#define STK83XX_REG_XOUT1             0x02
#define STK83XX_REG_XOUT2             0x03
#define STK83XX_REG_YOUT1             0x04
#define STK83XX_REG_YOUT2             0x05
#define STK83XX_REG_ZOUT1             0x06
#define STK83XX_REG_ZOUT2             0x07
#define STK83XX_REG_INTSTS1           0x09
#define STK83XX_REG_INTSTS2           0x0A
#define STK83XX_REG_FIFOSTS           0x0C
#define STK83XX_REG_RANGESEL          0x0F
#define STK83XX_REG_BWSEL             0x10
#define STK83XX_REG_PWRMODE           0x11
#define STK83XX_REG_ODRMODE           0x12
#define STK83XX_REG_DATASETUP         0x13
#define STK83XX_REG_SWRST             0x14
#define STK83XX_REG_INTEN1            0x16
#define STK83XX_REG_INTEN2            0x17
#define STK83XX_REG_INTMAP3           0x18
#define STK83XX_REG_INTMAP1           0x19
#define STK83XX_REG_INTMAP2           0x1A
#define STK83XX_REG_6DCFG             0x1B
#define STK83XX_REG_6DTHD             0x1C
#define STK83XX_REG_6DSTS             0x1D
#define STK83XX_REG_6DDLY             0x1E
#define STK83XX_REG_INTCFG1           0x20
#define STK83XX_REG_INTCFG2           0x21
#define STK83XX_REG_TILTTHD           0x23
#define STK83XX_REG_TILT___           0x24
#define STK83XX_REG_TILTCFG           0x25
#define STK83XX_REG_SLOPEDLY          0x27
#define STK83XX_REG_SLOPETHD          0x28
#define STK83XX_REG_SIGMOT1           0x29
#define STK83XX_REG_SIGMOT2           0x2A
#define STK83XX_REG_SIGMOT3           0x2B
#define STK83XX_REG_INTFCFG           0x34
#define STK83XX_REG_LPFCFG            0x35
#define STK83XX_REG_OFSTCOMP1         0x36
#define STK83XX_REG_OFSTX             0x38
#define STK83XX_REG_OFSTY             0x39
#define STK83XX_REG_OFSTZ             0x3A
#define STK83XX_REG_FIFOCFG1          0x3D
#define STK83XX_REG_FIFOCFG2          0x3E
#define STK83XX_REG_FIFODATA          0x3F

#define STK83XX_RANGE_2G              0x3
#define STK83XX_RANGE_4G              0x5
#define STK83XX_RANGE_8G              0x8

#define STK83XX_BW_7_81               0x08    /* ODR = BW x 2 = 15.62Hz */
#define STK83XX_BW_15_63              0x09    /* ODR = BW x 2 = 31.26Hz */
#define STK83XX_BW_31_25              0x0A    /* ODR = BW x 2 = 62.5Hz */
#define STK83XX_BW_62_5               0x0B    /* ODR = BW x 2 = 125Hz */
#define STK83XX_BW_125                0x0C    /* ODR = BW x 2 = 250Hz */
#define STK83XX_BW_250                0x0D    /* ODR = BW x 2 = 500Hz */
#define STK83XX_BW_500                0x0E    /* ODR = BW x 2 = 1000Hz */
#define STK83XX_BW_1000               0x0F    /* ODR = BW x 2 = 2000Hz */

#define STK83XX_PWRMODE_NORMAL        0x00
#define STK83XX_PWRMODE_LOWPOWER      0x40
#define STK83XX_PWRMODE_SUSPEND       0x80
#define STK83XX_PWRMODE_SLEEP_1       0x1E
#define STK83XX_PWRMODE_SLEEP_2       0x1C
#define STK83XX_PWRMODE_SLEEP_10      0x1A
#define STK83XX_PWRMODE_SLEEP_20      0x18
#define STK83XX_PWRMODE_SLEEP_25      0x16
#define STK83XX_PWRMODE_SLEEP_50      0x14
#define STK83XX_PWRMODE_SLEEP_100     0x12
#define STK83XX_PWRMODE_SLEEP_163     0x10
#define STK83XX_PWRMODE_SLEEP_200     0x0E
#define STK83XX_PWRMODE_SLEEP_300     0x0C
#define STK83XX_PWRMODE_SLEEP_MASK    0x7E
#define STK83XX_PWRMODE_SLEEP_TIMER   0x20

#define STK83XX_ODR_NORMAL            0x00
#define STK83XX_ODR_ESM               0x08

#define STK83XX_SWRST_VAL             0xB6

#define STK83XX_INTEN1_SLP_EN_X       0x01
#define STK83XX_INTEN1_SLP_EN_Y       0x02
#define STK83XX_INTEN1_SLP_EN_Z       0x04

#define STK83XX_INTEN2_DATA_EN        0x10
#define STK83XX_INTEN2_FWM_EN         0x40

#define STK83XX_INTMAP1_SIGMOT2INT1   0x01
#define STK83XX_INTMAP1_ANYMOT2INT1   0x04

#define STK83XX_INTMAP2_DATA2INT1     0x01
#define STK83XX_INTMAP2_FWM2INT1      0x02
#define STK83XX_INTMAP2_FWM2INT2      0x40

#define STK83XX_INTMAP3_6D_LATCH_MODE 0x01
#define STK83XX_INTMAP3_TILT_2INT1    0x10
#define STK83XX_INTMAP3_6D_2INT1      0x20
#define STK83XX_INTMAP3_TILT_2INT2    0x40
#define STK83XX_INTMAP3_6D_2INT2      0x80

#define STK83XX_INTCFG2_NOLATCHED     0x00
#define STK83XX_INTCFG2_LATCHED       0x0F
#define STK83XX_INTCFG2_INT_RST       0x80

#define STK83XX_TILTCFG_EN            0x10
#define STK83XX_TILTCFG_STS_MASK      0x80
#define STK83XX_TILTCFG_DEB_0S        0x00
#define STK83XX_TILTCFG_DEB_0_5S      0x20
#define STK83XX_TILTCFG_DEB_1S        0x40
#define STK83XX_TILTCFG_DEB_6S        0x60

#define STK83XX_6DCFG_X_NEG          (1 << 0)
#define STK83XX_6DCFG_X_POS          (1 << 1)
#define STK83XX_6DCFG_Y_NEG          (1 << 2)
#define STK83XX_6DCFG_Y_POS          (1 << 3)
#define STK83XX_6DCFG_Z_NEG          (1 << 4)
#define STK83XX_6DCFG_Z_POS          (1 << 5)
#define STK83XX_6DCFG_XYZ            (0x3f)
#define STK83XX_6DCFG_HIGHG          (0 << 6)
#define STK83XX_6DCFG_MOVEMENT       (1 << 6)
#define STK83XX_6DCFG_LOWG           (2 << 6)
#define STK83XX_6DCFG_POSITION       (3 << 6)

#define STK83XX_6DTHD_2G_DEF          0x2B //0x33 // 0x33 = 800mg
#define STK83XX_6DTHD_4G_DEF          0x19 // 0x19 = 800mg
#define STK83XX_6DTHD_8G_DEF          0x0C // 0x0C = 800mg

#define STK83XX_6DSTS_X_L_MASK        0x01 
#define STK83XX_6DSTS_X_H_MASK        0x02
#define STK83XX_6DSTS_Y_L_MASK        0x04
#define STK83XX_6DSTS_Y_H_MASK        0x08
#define STK83XX_6DSTS_Z_L_MASK        0x10
#define STK83XX_6DSTS_Z_H_MASK        0x20

#define STK83XX_SIXDDLY_DEF           0x30

//#define STK83_SWAP_XY

#define STK83_RANGE                   STK83XX_RANGE_2G
#define STK83_INT_LATCH_MODE          STK83XX_INTCFG2_LATCHED
#define STK83_TILT_CONFIG             (STK83XX_TILTCFG_EN | STK83XX_TILTCFG_DEB_0S)

#define STK83_DEFAULT_RATE            15                 // samples/sec
#define STK83_DEFAULT_DELAY           2                  // num. of samples to match before interrupt
#define STK83_DEFAULT_SOFT_THRESHOLD  680                // orientation change threshold (1/1024 g unit)
#define STK83_DEFAULT_HYST            80                 // hysteresis
/* 6DTHD steps by 1/64 g, the soft thresholds by 1/1024 g. The chip's gate must
 * stay <= the software one, or a tilt band rotates awake but never wakes us. */
#define STK83_DEFAULT_HARD_THRESHOLD  ((STK83_DEFAULT_SOFT_THRESHOLD - STK83_DEFAULT_HYST) / 16)

//static int suspend_state_partial = 1;

extern int enable_gpio_wakeup_src(int para);

struct stk83_data
{
	struct i2c_client *client;
	struct input_dev *input_dev;
	struct workqueue_struct *wq;
	struct delayed_work work;
	int x;
	int y;
	int z;
	int enable;
	int irq_enabled;
	int irq_pending;
	int button;
	int orientation;
	int intmask;
	int rate;
	int delay;
	int hard_threshold;
	int soft_threshold;
	int soft_hyst;
	int irq_gpio;
	u32 irq_gpio_flags;
	int32_t irq_num;

};

static struct stk83_data *stk;

static uint32_t btn_xm;
static uint32_t btn_xp;
static uint32_t btn_ym;
static uint32_t btn_yp;

static const unsigned short stk83_i2c_addr[] = { STK83_I2C_ADDR,I2C_CLIENT_END };

static int stk83_write_reg(uint8_t addr, uint8_t data)
{
	return i2c_smbus_write_byte_data(stk->client, addr, data);
}

static int stk83_read_reg(uint8_t addr)
{
	return i2c_smbus_read_byte_data(stk->client, addr);
}

static int stk83_read_regs(uint8_t addr, uint8_t *data, int len)
{
	struct i2c_client *client = stk->client;
        struct i2c_msg msgs[] = {
                {
                        .addr = client->addr,
                        .flags = client->flags,
                        .len = 1,
                        .buf = &addr,
                },
                {
                        .addr = client->addr,
                        .flags = client->flags | I2C_M_RD,
                        .len = len,
                        .buf = data,
                },
        };
        return i2c_transfer(client->adapter, msgs, 2);
}

static int stk83_read_position(bool after_irq)
{
	int absx, absy;
	int btn = stk->button;
	uint8_t data[6] = { 0,0,0,0,0,0 };
	stk83_read_regs(STK83XX_REG_XOUT1, data, 6);
	stk->x = (data[0] + (data[1] << 8)) >> 4; if (stk->x & 0x800) stk->x |= ~0xfff;
	stk->y = (data[2] + (data[3] << 8)) >> 4; if (stk->y & 0x800) stk->y |= ~0xfff;
	stk->z = (data[4] + (data[5] << 8)) >> 4; if (stk->z & 0x800) stk->z |= ~0xfff;

	absx = abs(stk->x);
	absy = abs(stk->y);

	if (btn == btn_xm || btn == btn_xp) {
		if (absy >= stk->soft_threshold &&(absy >= absx + stk->soft_hyst || after_irq)) {
			btn = (stk->y > 0) ? btn_yp : btn_ym;
		} else if (absx >= stk->soft_threshold - stk->soft_hyst) {
			btn = (stk->x > 0) ? btn_xp : btn_xm;
		} else {
			btn = BTN_Z;
		}
	} else if (btn == btn_ym || btn == btn_yp) {
		if (absx >= stk->soft_threshold && (absx >= absy + stk->soft_hyst || after_irq)) {
			btn = (stk->x > 0) ? btn_xp : btn_xm;
		} else if (absy >= stk->soft_threshold - stk->soft_hyst) {
			btn = (stk->y > 0) ? btn_yp : btn_ym;
		} else {
			btn = BTN_Z;
		}
	} else {
		if (absx > absy && absx >= stk->soft_threshold - stk->soft_hyst) {
			btn = (stk->x > 0) ? btn_xp : btn_xm;
		} else if (absy > absx && absy >= stk->soft_threshold - stk->soft_hyst) {
			btn = (stk->y > 0) ? btn_yp : btn_ym;
		} else {
			btn = BTN_Z;
		}
	}
	return btn;
}

static int button_to_orientation(int btn)
{
	switch (btn) {
		default:        return 0;
		case BTN_NORTH: return 3;
		case BTN_WEST:  return 1;
		case BTN_EAST:  return 2;
		case BTN_Z:     return -1;
	}
}

int stk83_detect(struct i2c_client *client, struct i2c_board_info *info)
{
	struct i2c_adapter *adapter = client->adapter;
	int chipid;

	DBG("detect @%d\n", adapter->nr);

	if (STK83_I2C_BUS != adapter->nr) return -ENODEV;

	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
		ERR("i2c check functionality error\n");
		return -ENODEV;
	}

	chipid = i2c_smbus_read_byte_data(client, STK83XX_REG_CHIPID);
	if (chipid != 0x26) {
		ERR("unknown chip id %x\n", chipid);
		return -ENODEV;
	}

	INF("Detected chip %02x at adapter %d, address 0x%02x\n",
		 chipid, i2c_adapter_id(adapter), client->addr);

	strlcpy(info->type, STK83_NAME, I2C_NAME_SIZE);
	return 0;
}

static void stk83_disable(void)
{
	stk83_write_reg(STK83XX_REG_PWRMODE, STK83XX_PWRMODE_SUSPEND);
	stk->x = stk->y = stk->z = 0;
}

static void stk83_setup(void)
{
	uint8_t dr;

	stk83_disable();
	if (! stk->enable) return;

	if (stk->rate <= 15) {
		stk->rate = 15; dr = 8;
	} else if (stk->rate <= 31) {
		stk->rate = 31; dr = 9;
	} else if (stk->rate <= 62) {
		stk->rate = 62; dr = 10;
	} else if (stk->rate <= 125) {
		stk->rate = 125; dr = 11;
	} else if (stk->rate <= 250) {
		stk->rate = 250; dr = 12;
	} else if (stk->rate <= 500) {
		stk->rate = 500; dr = 13;
	} else if (stk->rate <= 1000) {
		stk->rate = 1000; dr = 14;
	} else {
		stk->rate = 2000; dr = 15;
	}

	if (stk->hard_threshold > 127) stk->hard_threshold = 127;
	if (stk->delay > 255) stk->delay = 255;

	stk83_write_reg(STK83XX_REG_RANGESEL, STK83_RANGE);
	stk83_write_reg(STK83XX_REG_BWSEL, dr);
	stk83_write_reg(STK83XX_REG_ODRMODE, STK83XX_ODR_NORMAL);
	stk83_write_reg(STK83XX_REG_DATASETUP, 0);
	stk83_write_reg(STK83XX_REG_INTEN1, 0);
	stk83_write_reg(STK83XX_REG_INTEN2, 0);
	stk83_write_reg(STK83XX_REG_INTMAP3, STK83XX_INTMAP3_6D_2INT1);
	stk83_write_reg(STK83XX_REG_INTMAP1, 0);
	stk83_write_reg(STK83XX_REG_INTMAP2, 0);
	stk83_write_reg(STK83XX_REG_INTCFG1, 0); // active low, push-pull
	stk83_write_reg(STK83XX_REG_INTCFG2, STK83XX_INTCFG2_INT_RST | STK83_INT_LATCH_MODE);
	stk83_write_reg(STK83XX_REG_6DCFG, STK83XX_6DCFG_MOVEMENT | STK83XX_6DCFG_XYZ);
	stk83_write_reg(STK83XX_REG_6DTHD, stk->hard_threshold);
	stk83_write_reg(STK83XX_REG_6DDLY, stk->delay);
	/*	
	stk83_write_reg(STK83XX_REG_TILTTHD, stk->tilt_threshold);
	stk83_write_reg(STK83XX_REG_TILT___, 0x8c); //step 0.0625 bit0~3 C*0.0625+100%=175%  bit4~7 8*0.0625=50%
	stk83_write_reg(STK83XX_REG_TILTCFG, STK83XX_TILT_CONFIG);
	*/
	stk83_write_reg(STK83XX_REG_PWRMODE, STK83XX_PWRMODE_NORMAL);
}

static ssize_t stk83_vendor_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	return sprintf(buf, "%s\n", "Sensortek");
}

static ssize_t stk83_enable_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	return sprintf(buf, "%d\n", stk->enable);
}

static ssize_t stk83_enable_store(struct device *dev,struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned long value;

	if (kstrtoul(buf, 10, &value))
		return -EINVAL;

	stk->enable = value ? 1 : 0;
	stk83_setup();
	return count;
}

static ssize_t stk83_position_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	stk83_read_position(false);
	#ifndef STK83_SWAP_XY
	return sprintf(buf, "%d %d %d\n", stk->x, stk->y, -stk->z);
	#else
	return sprintf(buf, "%d %d %d\n", stk->y, stk->x, -stk->z);
	#endif
}

static ssize_t stk83_orientation_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	int btn = stk83_read_position(false);
	return sprintf(buf, "%d\n", button_to_orientation(btn));
}

static ssize_t stk83_rate_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	return sprintf(buf, "%d\n", stk->rate);
}

static ssize_t stk83_rate_store(struct device *dev,struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned long value;

	if (kstrtoul(buf, 10, &value))
		return -EINVAL;

	stk->rate = value;
	stk83_setup();
	return count;
}

static ssize_t stk83_delay_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	return sprintf(buf, "%d\n", stk->delay);
}

static ssize_t stk83_delay_store(struct device *dev,struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned long value;

	if (kstrtoul(buf, 10, &value))
		return -EINVAL;

	stk->delay = value;
	stk83_setup();
	return count;
}

static ssize_t stk83_hard_threshold_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	return sprintf(buf, "%d\n", stk->hard_threshold);
}

static ssize_t stk83_hard_threshold_store(struct device *dev,struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned long value;

	if (kstrtoul(buf, 10, &value))
		return -EINVAL;

	stk->hard_threshold = value;
	stk83_setup();
	return count;
}

static ssize_t stk83_soft_threshold_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	return sprintf(buf, "%d\n", stk->soft_threshold);
}

static ssize_t stk83_soft_threshold_store(struct device *dev,struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned long value;

	if (kstrtoul(buf, 10, &value))
		return -EINVAL;

	stk->soft_threshold = value;
	return count;
}

static ssize_t stk83_soft_hyst_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	return sprintf(buf, "%d\n", stk->soft_hyst);
}

static ssize_t stk83_soft_hyst_store(struct device *dev,struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned long value;

	if (kstrtoul(buf, 10, &value))
		return -EINVAL;

	stk->soft_hyst = value;
	return count;
}
static ssize_t stk83_reg_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	uint8_t data[0x40];
	int reg, len=0;

	stk83_read_regs(0, data, sizeof(data));
	for (reg=0; reg<0x40; reg++) {
		len += snprintf(buf+len, 4096-len, "%02x: %02x\n", reg, data[reg]);
	}
	return len;
}

static ssize_t stk83_reg_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	int reg, val;
	int ret;

 	if (sscanf(buf, "%x %x", &reg, &val) < 2) return -EINVAL;
	ret = stk83_write_reg(reg, val);
	return (ret == 0) ? count : ret;
}

static DEVICE_ATTR(vendor, S_IRUGO, stk83_vendor_show, NULL);
static DEVICE_ATTR(enable, S_IRUGO|S_IWUSR, stk83_enable_show, stk83_enable_store);
static DEVICE_ATTR(position, S_IRUGO, stk83_position_show, NULL);
static DEVICE_ATTR(orientation, S_IRUGO, stk83_orientation_show, NULL);
static DEVICE_ATTR(rate, S_IRUGO|S_IWUSR, stk83_rate_show, stk83_rate_store);
static DEVICE_ATTR(delay, S_IRUGO|S_IWUSR, stk83_delay_show, stk83_delay_store);
static DEVICE_ATTR(hard_threshold, S_IRUGO|S_IWUSR, stk83_hard_threshold_show, stk83_hard_threshold_store);
static DEVICE_ATTR(soft_threshold, S_IRUGO|S_IWUSR, stk83_soft_threshold_show, stk83_soft_threshold_store);
static DEVICE_ATTR(soft_hyst, S_IRUGO|S_IWUSR, stk83_soft_hyst_show, stk83_soft_hyst_store);
static DEVICE_ATTR(reg, S_IRUGO|S_IWUSR, stk83_reg_show, stk83_reg_store);

static struct attribute *stk83_attrs[] = {

	&dev_attr_vendor.attr,
	&dev_attr_enable.attr,
	&dev_attr_position.attr,
	&dev_attr_orientation.attr,
	&dev_attr_rate.attr,
	&dev_attr_delay.attr,
	&dev_attr_hard_threshold.attr,
	&dev_attr_soft_threshold.attr,
	&dev_attr_soft_hyst.attr,
	&dev_attr_reg.attr,
	NULL

};

static struct attribute_group gsensor_sysfs_group = { .attrs = stk83_attrs };

static struct kobject *gsensor_kobj;

static int stk83_sysfs_init(void)
{
	gsensor_kobj = kobject_create_and_add("gsensor", NULL) ;
	if (gsensor_kobj == NULL) {
		ERR("%s: subsystem_register failed\n", __func__);
		return -ENOMEM;
	}

	if (sysfs_create_group(gsensor_kobj, &gsensor_sysfs_group)) {
		ERR("%s: sysfs_create_file failed\n", __func__);
	}

	return 0;
}

static void stk83_sysfs_deinit(void)
{
	sysfs_remove_group(gsensor_kobj, &gsensor_sysfs_group);
	kobject_del(gsensor_kobj);
}	

static void stk83_report(int key)
{
	DBG("report key %d\n", key);
	input_report_key(stk->input_dev, key, 1);
	input_sync(stk->input_dev);
	input_report_key(stk->input_dev, key, 0);
	input_sync(stk->input_dev);
}


static void stk83_set_irq_enable(bool en)
{
	if (en != stk->irq_enabled) {
		if (en) {
			enable_irq(stk->client->irq);
		} else {
			disable_irq_nosync(stk->client->irq);
		}
		stk->irq_enabled = en;
	}
}

static void stk83_work_func(struct work_struct *work)
{
	int sts = stk83_read_reg(STK83XX_REG_6DSTS);
	int button = stk83_read_position(!!stk->irq_pending);

	/*
	stk83_write_reg(STK83XX_REG_TILTCFG, 0); // reset TILT_EN
	stk83_write_reg(STK83XX_REG_TILTCFG, STK83_TILT_CONFIG);
	*/
	if (stk->irq_pending) {
		stk83_write_reg(STK83XX_REG_6DCFG, STK83XX_6DCFG_POSITION | (STK83XX_6DCFG_XYZ & ~sts));
		stk83_write_reg(STK83XX_REG_INTCFG2, STK83XX_INTCFG2_INT_RST | STK83_INT_LATCH_MODE);
	}

	if (button != stk->button) {
		stk->button = button;
		stk83_report(button);
	}

	DBG("%c 6DSTS=%02x CFG=%02x x=%d y=%d z=%d button %d orientation %d\n",
		stk->irq_pending?'*':' ',
		sts, STK83XX_6DCFG_MOVEMENT | (STK83XX_6DCFG_XYZ & ~sts),
		stk->x, stk->y, stk->z, button, button_to_orientation(button));

	queue_delayed_work(stk->wq, &stk->work, HZ/4);
	stk->irq_pending = 0;
	stk83_set_irq_enable(1);
	return;
}

irqreturn_t stk83_irq_handler(int irq, void *dev_id)
{
	DBG("*GS.IRQ*\n");
	stk83_set_irq_enable(0);
	stk->irq_pending = 1;
	queue_delayed_work(stk->wq, &stk->work, HZ/20);
	return IRQ_HANDLED;
}

static int stk83_probe(struct i2c_client *client, const struct i2c_device_id *id)
{
	struct device_node *np = client->dev.of_node;
	int err = 0;

	INF("probe\n");	

	stk = kzalloc(sizeof(struct stk83_data), GFP_KERNEL);
	if (stk == NULL) {
		ERR("allocate data failed\n");
		err = -ENOMEM;
		goto err_alloc_data_failed;
	}

	stk->wq = create_singlethread_workqueue("stk83_wq");
	if (!stk->wq) {
		ERR("create workqueue failed\n");
		err = -ENOMEM;
		goto err_create_wq_failed;
	}

	INIT_DELAYED_WORK(&stk->work, stk83_work_func);
	stk->client = client;
	i2c_set_clientdata(client, stk);

	stk->input_dev = input_allocate_device();
	if (stk->input_dev == NULL) {
		err = -ENOMEM;
		ERR("Failed to allocate input device\n");
		goto err_input_dev_alloc_failed;
	}
	stk->input_dev->name = STK83_NAME;
	stk->input_dev->id.bustype = BUS_I2C;
	stk->input_dev->dev.parent = &client->dev;
	input_set_drvdata(stk->input_dev, stk);

	set_bit(EV_KEY, stk->input_dev->evbit);
	stk->input_dev->keybit[BIT_WORD(BTN_NORTH)] |= BIT_MASK(BTN_NORTH);
	stk->input_dev->keybit[BIT_WORD(BTN_SOUTH)] |= BIT_MASK(BTN_SOUTH);
	stk->input_dev->keybit[BIT_WORD(BTN_EAST)] |= BIT_MASK(BTN_EAST);
	stk->input_dev->keybit[BIT_WORD(BTN_WEST)] |= BIT_MASK(BTN_WEST);
	stk->input_dev->keybit[BIT_WORD(BTN_Z)] |= BIT_MASK(BTN_Z);

#ifdef CONFIG_PB_DEVICE
	if (!strcmp(CONFIG_PB_DEVICE,"743c")) {
		btn_xm = BTN_WEST;   // -x
		btn_xp = BTN_EAST;   // +x
		btn_ym = BTN_NORTH;  // -y
		btn_yp = BTN_SOUTH;  // +y
	} else {
		//default configuration
		btn_xm = BTN_WEST;   // -x
		btn_xp = BTN_EAST;   // +x
		btn_ym = BTN_NORTH;  // -y
		btn_yp = BTN_SOUTH;  // +y
	}
#else
	//#error STK83xx orientation not defined for this device
	btn_xm = BTN_WEST;   // -x
	btn_xp = BTN_EAST;   // +x
	btn_ym = BTN_NORTH;  // -y
	btn_yp = BTN_SOUTH;  // +y
#endif

	/* Per-board mount correction: some panels have the sensor rotated so one
	 * axis reads inverted. These flip a single axis (a reflection that the
	 * userspace 'placement' rotation cannot express). Set in the DTS node. */
	if (of_property_read_bool(np, "stk83xx,revert-x")) {
		uint32_t t = btn_xm; btn_xm = btn_xp; btn_xp = t;
	}
	if (of_property_read_bool(np, "stk83xx,revert-y")) {
		uint32_t t = btn_ym; btn_ym = btn_yp; btn_yp = t;
	}

	err = input_register_device(stk->input_dev);
	if (err) {
		ERR("unable to register input device\n");
		goto err_input_register_device_failed;
	}

	//gsensor_info.dev = &stk->input_dev->dev;

	stk->irq_gpio = 0;
	if (np) {
		stk->irq_gpio = of_get_named_gpio_flags(np, "stk83xx,irq-gpio", 0, &stk->irq_gpio_flags);
		if (stk->irq_gpio < 0) {
			ERR("Unable to get irq-gpio!");
		}
	} else {
		ERR("cannot find device node!");
	}

	if (stk->irq_gpio > 0) {
		stk->irq_num = gpio_to_irq(stk->irq_gpio);
		err = request_threaded_irq(stk->irq_num, NULL, stk83_irq_handler,
			IRQF_TRIGGER_FALLING | IRQF_ONESHOT, "stkxxx_wake_irq", stk);
		if (err == 0) {
			INF("registered interrupt %d at gpio %d", stk->irq_num, stk->irq_gpio);
		} else {
			ERR("cannot register interrupt %d at gpio %d!", stk->irq_num, stk->irq_gpio);
			goto err_input_register_device_failed;
		}
		err = device_init_wakeup(&(client->dev), 1);
		if (err < 0) ERR("Error, device_init_wakeup rc:%d", err);
		enable_irq_wake(stk->irq_num);
	}

	stk83_sysfs_init();

	stk->enable = 1;
	stk->irq_enabled = 1;
	stk->rate = STK83_DEFAULT_RATE;
	stk->delay = STK83_DEFAULT_DELAY;
	stk->hard_threshold = STK83_DEFAULT_HARD_THRESHOLD;
	stk->soft_threshold = STK83_DEFAULT_SOFT_THRESHOLD;
	stk->soft_hyst = STK83_DEFAULT_HYST;
	stk83_setup();

	INF("Start g-sensor in interrupt mode\n");

	queue_delayed_work(stk->wq, &stk->work, HZ/10);
	return 0;

err_input_register_device_failed:
err_input_dev_alloc_failed:
	if (stk->input_dev)
		input_free_device(stk->input_dev);

err_create_wq_failed:
	if (stk->wq)
		destroy_workqueue(stk->wq);

err_alloc_data_failed:
	kfree(stk);

	return err ? err : -ENODEV;
}

static int stk83_remove(struct i2c_client *client)
{
	stk83_sysfs_deinit();
	//input_free_int(&(gsensor_info.input_type), stk);
	if (stk->wq) destroy_workqueue(stk->wq);
	input_unregister_device(stk->input_dev);
	kfree(stk);
	//input_sensor_free(&(gsensor_info.input_type));
	return 0;
}

static int stk83_suspend(struct device *dev)
{
	INF("suspend: %s\n", (mem_sleep_current == PM_SUSPEND_MEM_ULTRA) ? "ultra" : "normal");
	if (stk->irq_pending) return -EBUSY;
	cancel_delayed_work_sync(&stk->work);
	if (mem_sleep_current == PM_SUSPEND_MEM_ULTRA) {
		stk83_disable();
	}
	return 0;
}

static int stk83_resume(struct device *dev)
{
	INF("wakeup\n");
	if (mem_sleep_current == PM_SUSPEND_MEM_ULTRA) {
		stk83_setup();
	}
	queue_delayed_work(stk->wq, &stk->work, HZ/5);
	return 0;
}

static const struct i2c_device_id stk83_id[] = {
	{ "stk83xx",  ACCEL_ID_STK83XX },
	{ }
};

MODULE_DEVICE_TABLE(i2c, stk83xx_id);

static const struct of_device_id stk83_of_match[] = {
	{.compatible = "sensortek,stk83xx",},
	{ },
};

MODULE_DEVICE_TABLE(of, stk83xx_of_match);

static SIMPLE_DEV_PM_OPS(stk83_pm_ops, stk83_suspend, stk83_resume);

static struct i2c_driver stk83_driver = {
	.probe          = stk83_probe,
	.remove         = stk83_remove,
	.id_table       = stk83_id,
	.detect         = stk83_detect,
	.driver		= {
		.name   = "stk83xx",
	        .of_match_table = stk83_of_match,
#ifdef CONFIG_PM
		.pm = &stk83_pm_ops,
#endif
	},
	.address_list   = stk83_i2c_addr,
};

module_i2c_driver(stk83_driver);

MODULE_DESCRIPTION("STK83xx g-sensor driver");
MODULE_LICENSE("GPL");
