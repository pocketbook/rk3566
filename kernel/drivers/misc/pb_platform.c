#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/mm.h>
#include <asm/io.h>
#include <linux/proc_fs.h>
#include <linux/slab.h>
#include <linux/regulator/consumer.h>
#include <linux/delay.h>
#include <linux/uaccess.h>
#include <linux/fs.h>
#include <asm/system_info.h>
#include <linux/pb_platform.h>

#define DEBUG

#ifdef DEBUG
#define DBG(msg, ...) do { \
	printk("[%s] "msg"\n",__func__, ## __VA_ARGS__); \
} while (0)
#else
#define DBG(msg, ...) {}
#endif

#define INF(msg, ...) do { \
		printk("[%s] "msg"\n",__func__, ## __VA_ARGS__); \
} while (0)

#define ERR(msg, ...) do { \
		printk("[%s] ERROR "msg"\n",__func__, ## __VA_ARGS__); \
} while (0)

#define SARADC_PATH "/sys/devices/platform/fe720000.saradc/iio:device0"

enum {
	ADC_CH_RECOVERY = 0,
	ADC_CH_PCBVER = 1,
	ADC_CH_BATTERYID = 2,
};

static const char *adc_channel_nodes[] = {
	[ADC_CH_RECOVERY]  = SARADC_PATH "/in_voltage0_raw",
	[ADC_CH_PCBVER]    = SARADC_PATH "/in_voltage1_raw",
	[ADC_CH_BATTERYID] = SARADC_PATH "/in_voltage2_raw",
};

static const struct {
	const char *ver;
	int vmin;
	int vmax;
} PCB_versions[] = {
	{ "1.0",    0, 150 },
	{ "1.1",  200, 300 },
	{ "1.2",  350, 450 },
	{ "1.3",  500, 600 },
	{ "1.4",  650, 750 },
	{ "1.5",  800, 900 },
	{ "1.6",  950,1050 },
	{ "1.7", 1100,1200 },
	{ "1.8", 1250,1350 },
	{ "1.9", 1400,1500 },
	{ "1.8", 1550,1650 },
	{ "2.1", 1700,1800 },
	{ NULL }
};

static const struct {
	const char *mfg;
	int vmin;
	int vmax;
} Battery_IDs[] = {
	{ "0.0",     0, 100 },
	{ "1.0",   150, 250 },
	{ "2.0",   350, 450 },
	{ "3.0",   550, 650 },
	{ "4.0",   750, 850 },
	{ "5.0",   950,1050 },
	{ "6.0",  1150,1250 },
	{ "none", 1300,9999 },
	{ NULL }
};

static int read_adc_channel(int ch)
{
	struct file *f;
	long val = -1;
	char buf[16];

	//mm_segment_t oldfs = get_fs();
	//set_fs(get_ds());

	f = filp_open(adc_channel_nodes[ch], O_RDONLY, 0);
	if (! IS_ERR(f)) {
		int bytes_read = kernel_read(f, buf, sizeof(buf) - 1, &f->f_pos);
		if (bytes_read >= 0) {
			buf[bytes_read] = 0;
			if (kstrtol(buf, 10, &val) < 0) val = -1;
		} else {
			ERR("cannot read adc channel %d", ch);
		}
	} else {
		ERR("cannot open adc channel %d", ch);
	}

	//set_fs(oldfs);
	if (! IS_ERR(f)) filp_close(f, NULL);
	// return value in mV
	return (val * 1800) / 1024;
}

/*
 * Detects PCB version by GPADC value
 */
const char *GetPCBVersion(void)
{
	const char *ret = "unknown";
	int v = read_adc_channel(ADC_CH_PCBVER);
	int i;
	for (i=0; PCB_versions[i].ver; i++) {
		if (v >= PCB_versions[i].vmin && v <= PCB_versions[i].vmax) {
			ret = PCB_versions[i].ver;
			break;
		}
	}
	DBG("ADC.%d = %d mV PCB version = %s", ADC_CH_PCBVER, v, ret);
	return ret;
}
EXPORT_SYMBOL(GetPCBVersion);

/*
 * Detects Battery ID by LRADC value
 */
const char *GetBatteryID(void)
{
	const char *ret = "unknown";
	int v = read_adc_channel(ADC_CH_BATTERYID);
	int i;
	for (i=0; Battery_IDs[i].mfg; i++) {
		if (v >= Battery_IDs[i].vmin && v <= Battery_IDs[i].vmax) {
			ret = Battery_IDs[i].mfg;
			break;
		}
	}
	DBG("ADC.%d = %d mV PCB version = %s", ADC_CH_BATTERYID, v, ret);
	return ret;
}
EXPORT_SYMBOL(GetBatteryID);

static ssize_t proc_pcb_read(struct file *filp, char *buf, size_t count, loff_t *offp)
{
	const char *ver = GetPCBVersion();
	int len = strlen(ver);

	if ((int)*offp > 0) return 0;
	if (count < len) return 0;
	if (copy_to_user(buf, ver, len))  return -EFAULT;
	*offp = len;
	return len;
}

static ssize_t proc_battery_read(struct file *filp, char *buf, size_t count, loff_t *offp)
{
	const char *ver = GetBatteryID();
	int len = strlen(ver);

	if ((int)*offp > 0) return 0;
	if (count < len) return 0;
	if (copy_to_user(buf, ver, len))  return -EFAULT;
	*offp = len;
	return len;
}

static ssize_t proc_cpu_id_read(struct file *filp, char *buf, size_t count, loff_t *offp)
{

	char cpu_id[32];
    int len;

    len = snprintf(cpu_id, sizeof(cpu_id), "%08x%08x\n",
                   system_serial_high, system_serial_low);

	if ((int)*offp > 0) return 0;
	if (count < len) return 0;
	if (copy_to_user(buf, cpu_id, len))  return -EFAULT;
	*offp = len;
	return len;
}

static struct proc_ops proc_pcb_fops = {
    .proc_read = proc_pcb_read,
};

static struct proc_ops proc_battery_fops = {
    .proc_read = proc_battery_read,
};

static struct proc_ops proc_cpu_id_fops = {
    .proc_read = proc_cpu_id_read,
};
/*
 * touch screen power (enable\disable) api
 */
struct hwpower_s {
	struct mutex mut;
	struct proc_dir_entry *file;
	struct proc_ops proc_fops;
	void *data_cb; //context
	int (*state)(void *data_cb); //read power state
	int (*enable)(void *data_cb, bool onOff); //set power state
};
static struct hwpower_s *touch;

static ssize_t proc_touch_write(struct file *filp, const char __user * buffer, size_t count, loff_t *pos)
{
	char buf[16];
	int current_state = -1;
	int ret = 0;

	struct hwpower_s *d = PDE_DATA(file_inode(filp));

	if (count > sizeof(buf) -1)
		return -EINVAL;

	if (!count)
		return 0;

	if (copy_from_user(buf, buffer, count))
		return -EFAULT;

	buf[count] = '\0';

	mutex_lock(&d->mut);
	if(d->state)
		current_state = (d->state)(d->data_cb);

	if (!d->enable && (buf[0] == '0' || buf[0] == '1'))
		ERR("no touch driver registered, write ignored");

	switch (buf[0]) {
	case '0':
		if (current_state != 0 && (d->enable))
			ret = (d->enable)(d->data_cb,false);
		//touch_irq_late_detect = 0;
		break;
	case '1':
		if (current_state != 1 && (d->enable))
			ret = (d->enable)(d->data_cb,true);
		//touch_irq_late_detect = 1;
		break;
	default:
		ERR("wrong input");
		break;
	}
	mutex_unlock(&d->mut);
	/* let the driver refuse, e.g. -EBUSY while its firmware is updating */
	return ret ? ret : count;
}

static ssize_t proc_touch_read(struct file *filp, char *buf, size_t count, loff_t *offp)
{
	int err;
	int state = -1;
	char tbuf[16];
	int len;
	struct hwpower_s *d;

	//exit if buffer is not empty
	if ((int)*offp > 0)
		return 0;

	d = PDE_DATA(file_inode(filp));

	mutex_lock(&d->mut);
	if(d->state)
		state = (d->state)(d->data_cb);

	len = snprintf(tbuf, sizeof(tbuf), "%i\n", state);
	mutex_unlock(&d->mut);

	if (count < len)
		return 0;

	err = copy_to_user(buf, tbuf, len);
	if (err)
		return -EFAULT;

	*offp = len;
	return len;
}

/*
 * register touch screen callbacks set power state and get power state
 * unregister callbacks make call register_keylock_callback(NULL,NULL,NULL)
 */
int register_touchpower_callback(int (*touch_enable_cb)(void *data, bool onOff), int (*touch_state_cb)(void *data), void *touch_context)
{
	if (touch == NULL)
		return -ENOENT;

	mutex_lock(&touch->mut);
	touch->data_cb = touch_context;
	touch->enable = touch_enable_cb;
	touch->state = touch_state_cb;
	mutex_unlock(&touch->mut);
	return 0;
}
EXPORT_SYMBOL(register_touchpower_callback);

static int pb_platform_init(void)
{
	struct proc_dir_entry *dir, *file;

	dir = proc_mkdir("power", NULL);
	if (!dir) {
		ERR("could not create /proc/power");
		return -1;
	}

	touch = kmalloc(sizeof(struct hwpower_s), __GFP_ZERO);
	if (!touch) {
		remove_proc_entry("power",NULL);
		return -2;
	}
	touch->proc_fops.proc_read = proc_touch_read;
	touch->proc_fops.proc_write = proc_touch_write;

	/* before the node is published, which makes it writable - and an
	   all-zero mutex from kmalloc(__GFP_ZERO) is not a mutex */
	mutex_init(&(touch->mut));

	file = proc_create_data("touch", 0666, dir, &(touch->proc_fops), touch);
	if (!file) {
		ERR("could not create /proc/power/touch\n");
		remove_proc_entry("touch",dir);
		remove_proc_entry("power",NULL);
		return -3;
	}

	touch->file = file;

	file = proc_create_data("pcb_version", 0444, NULL, &proc_pcb_fops, NULL);
	if (!file) {
		ERR("could not create /proc/pcb_version\n");
		return -1;
	}
	file = proc_create_data("battery_id", 0444, NULL, &proc_battery_fops, NULL);
	if (!file) {
		ERR("could not create /proc/battery_id\n");
		return -1;
	}
	file = proc_create_data("cpu_id", 0444, NULL, &proc_cpu_id_fops, NULL);
	if (!file) {
		ERR("could not create /proc/cpu_id\n");
		return -1;
	}

	pr_debug("[%s] registered\n",__func__);
	return 0;
}

/*
 * Early enough that a touch driver can register its power callbacks from probe.
 * Those run at device_initcall (level 6) and register_touchpower_callback()
 * returns -ENOENT while "touch" is still NULL, so this has to come first; it
 * only creates proc nodes, and the ADC is read from the handlers, not here.
 */
subsys_initcall(pb_platform_init);
