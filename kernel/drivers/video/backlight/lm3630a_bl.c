/*
* Simple driver for Texas Instruments LM3630 Backlight driver chip
* Copyright (C) 2012 Texas Instruments
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License version 2 as
* published by the Free Software Foundation.
*
*/

#include <linux/module.h>
#include <linux/slab.h>
#include <linux/i2c.h>
#include <linux/backlight.h>
#include <linux/err.h>
#include <linux/delay.h>
#include <linux/uaccess.h>
#include <linux/interrupt.h>
#include <linux/regmap.h>
#include <linux/platform_data/lm3630a_bl.h>
#include <linux/of_gpio.h>
#include <linux/suspend.h>

#define REG_CTRL	0x00
#define REG_CONFIG	0x01
#define REG_BOOST	0x02
#define REG_BRT_A	0x03
#define REG_BRT_B	0x04
#define REG_I_A		0x05
#define REG_I_B		0x06
#define REG_ONOFF_RAMP 0x07
#define REG_RUN_RAMP 0x08
#define REG_INT_STATUS	0x09
#define REG_INT_EN	0x0A
#define REG_FAULT	0x0B
#define REG_PWM_OUTLOW	0x12
#define REG_PWM_OUTHIGH	0x13
#define REG_REV		0x1F
#define REG_MAX		0x1F
#define REG_FILTER_STENGTH	0x50

#define INT_DEBOUNCE_MSEC	10
//#define DEBUG 1

#define INF(x...) { printk("[%s] ", __func__); printk(x); printk("\n"); }
#define ERR(x...) { printk("[%s] ", __func__); printk(x); printk("\n"); }
#ifdef DEBUG
	#define DBG(x...) { printk("[%s] ", __func__); printk(x); printk("\n"); }
#else
	#define DBG(x...) {}
#endif

enum lm3630_leds {
	BLED_ALL = 0,
	BLED_1,
	BLED_2
};

static const char * const bled_name[] = {
	[BLED_ALL] = "lm3630_bled",	/*Bank1 controls all string */
	[BLED_1] = "lm3630_bled1",	/*Bank1 controls bled1 */
	[BLED_2] = "lm3630_bled2",	/*Bank1 or 2 controls bled2 */
};

struct lm3630_chip_data {
	struct device *dev;
	struct delayed_work work;
	int irq;
	struct workqueue_struct *irqthread;
	struct lm3630_platform_data *pdata;
	struct backlight_device *bled1;
	struct backlight_device *bled2;
	struct regmap *regmap;
	struct gpio_desc *enable_gpio;
	struct gpio_desc *led_enable_gpio;
};

/* initialize chip */
static int lm3630_chip_init(struct lm3630_chip_data *pchip)
{
	int ret;
	unsigned int reg_val, v;
	struct lm3630_platform_data *pdata = pchip->pdata;
	DBG("lm3630_chip_init\n");
//	ret = regmap_write(pchip->regmap, REG_FILTER_STENGTH, 0x03);
//	if (ret < 0)
//		goto out;

	ret = regmap_write(pchip->regmap, REG_ONOFF_RAMP, 0x24 /*0x1b*/);
	if (ret < 0)
		goto out;

	ret = regmap_write(pchip->regmap, REG_RUN_RAMP, 0x12 /*0x09*/);
	if (ret < 0)
		goto out;

	/*pwm control */
	reg_val = ((pdata->pwm_active & 0x01) << 2) | (pdata->pwm_ctrl & 0x03);
	ret = regmap_update_bits(pchip->regmap, REG_CONFIG, 0x07, reg_val);
	if (ret < 0)
		goto out;

	ret = regmap_write(pchip->regmap, REG_BOOST, 0x63);
	if (ret < 0)
		goto out;

	//set max led current
	ret = regmap_write(pchip->regmap, REG_I_A, (0x1f & pdata->max_current_led1));
	if (ret < 0)
		goto out;

	ret = regmap_write(pchip->regmap, REG_I_B, (0x1f & pdata->max_current_led2));
	if (ret < 0)
		goto out;

	/* bank control */
	reg_val = (pdata->bank_b_ctrl & BANK_B_CTRL_MASK) | (pdata->bank_a_ctrl & BANK_A_CTRL_MASK);
	DBG("set REG_CTRL to %x; bank_b_ctrl = %x; bank_a_ctrl = %x\n",reg_val,pdata->bank_b_ctrl,pdata->bank_a_ctrl);
	ret = regmap_update_bits(pchip->regmap, REG_CTRL, BANK_B_CTRL_MASK | BANK_A_CTRL_MASK, reg_val);
	if (ret < 0)
		goto out;

	ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
	if (ret < 0)
		goto out;

	/* set initial brightness */
	if (pdata->bank_a_ctrl != BANK_A_CTRL_DISABLE) {
		ret = regmap_write(pchip->regmap,
				   REG_BRT_A, pdata->init_brt_led1);
		if (ret < 0)
			goto out;
	}

	if (pdata->bank_b_ctrl != BANK_B_CTRL_DISABLE) {
		ret = regmap_write(pchip->regmap,
				   REG_BRT_B, pdata->init_brt_led2);
		if (ret < 0)
			goto out;
	}

	//put chip into sleep mode if fl off
	regmap_read(pchip->regmap, REG_CTRL, &v);
	DBG("get REG_CTRL %x\n",v);
	if (!(v & (BANK_A_CTRL_LED1 | BANK_B_CTRL_LED2))) {
		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x80);
		if (ret < 0)
			goto out;
	}

	return ret;

out:
	dev_err(pchip->dev, "i2c failed to access register\n");
	return ret;
}

/* interrupt handling */
static void lm3630_delayed_func(struct work_struct *work)
{
	int ret;
	unsigned int reg_val;
	struct lm3630_chip_data *pchip;

	pchip = container_of(work, struct lm3630_chip_data, work.work);

	ret = regmap_read(pchip->regmap, REG_INT_STATUS, &reg_val);
	if (ret < 0) {
		dev_err(pchip->dev,
			"i2c failed to access REG_INT_STATUS Register\n");
		return;
	}

	dev_info(pchip->dev, "REG_INT_STATUS Register is 0x%x\n", reg_val);
}

static irqreturn_t lm3630_isr_func(int irq, void *chip)
{
	int ret;
	struct lm3630_chip_data *pchip = chip;
	unsigned long delay = msecs_to_jiffies(INT_DEBOUNCE_MSEC);

	queue_delayed_work(pchip->irqthread, &pchip->work, delay);

	ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
	if (ret < 0)
		goto out;

	return IRQ_HANDLED;
out:
	dev_err(pchip->dev, "i2c failed to access register\n");
	return IRQ_HANDLED;
}

static int lm3630_intr_config(struct lm3630_chip_data *pchip)
{
	INIT_DELAYED_WORK(&pchip->work, lm3630_delayed_func);
	pchip->irqthread = create_singlethread_workqueue("lm3630-irqthd");
	if (!pchip->irqthread) {
		dev_err(pchip->dev, "create irq thread fail...\n");
		return -1;
	}
	if (request_threaded_irq
	    (pchip->irq, NULL, lm3630_isr_func,
	     IRQF_TRIGGER_FALLING | IRQF_ONESHOT, "lm3630_irq", pchip)) {
		dev_err(pchip->dev, "request threaded irq fail..\n");
		return -1;
	}
	return 0;
}

static bool
set_intensity(struct backlight_device *bl, struct lm3630_chip_data *pchip)
{
	if (!pchip->pdata->pwm_set_intensity)
		return false;
	pchip->pdata->pwm_set_intensity(bl->props.brightness - 1,
					pchip->pdata->pwm_period);
	return true;
}

/* update and get brightness */
static int lm3630_bank_a_update_status(struct backlight_device *bl)
{
	int ret;
	unsigned int v = 0;
	struct lm3630_chip_data *pchip = bl_get_data(bl);
	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;

	DBG("br = %i, p = %i", bl->props.brightness, bl->props.power);

//	/* brightness 0 means disable */
//	if (!bl->props.brightness) {
//		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x04, 0x00);
//		if (ret < 0)
//			goto out;
//		return bl->props.brightness;
//	}

	/* pwm control */
	if (pwm_ctrl == PWM_CTRL_BANK_A || pwm_ctrl == PWM_CTRL_BANK_ALL) {
		if (!set_intensity(bl, pchip))
			dev_err(pchip->dev, "No pwm control func. in plat-data\n");
	} else {

		/* resume from sleep mode i2c control */
		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
		if (ret < 0)
			goto out;
		mdelay(1);

		ret = regmap_update_bits(pchip->regmap, REG_I_A, 0x1f, bl->props.power);
		if (ret < 0)
			goto out;

		if (bl->props.brightness < 4) {
			ret = regmap_update_bits(pchip->regmap, REG_CTRL, BANK_A_CTRL_LED1, 0x00);
		} else  {
			ret = regmap_update_bits(pchip->regmap, REG_CTRL, BANK_A_CTRL_LED1, BANK_A_CTRL_LED1);
		}
		if (ret < 0)
			goto out;

		ret = regmap_write(pchip->regmap,
				   REG_BRT_A, bl->props.brightness);
		if (ret < 0)
			goto out;

		//put chip into sleep mode if fl off
		regmap_read(pchip->regmap, REG_CTRL, &v);
		DBG("get REG_CTRL %x\n",v);
		if (!(v & (BANK_A_CTRL_LED1 | BANK_B_CTRL_LED2))) {
			ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x80);
			if (ret < 0)
				goto out;
		}

	}
	return 0;
out:
	dev_err(pchip->dev, "i2c failed to access REG_CTRL\n");
	return ret;
}

static int lm3630_bank_a_get_brightness(struct backlight_device *bl)
{
	unsigned int reg_val,v;
	int brightness, ret;
	struct lm3630_chip_data *pchip = bl_get_data(bl);
	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;

	if (pwm_ctrl == PWM_CTRL_BANK_A || pwm_ctrl == PWM_CTRL_BANK_ALL) {
		ret = regmap_read(pchip->regmap, REG_PWM_OUTHIGH, &reg_val);
		if (ret < 0)
			goto out;
		brightness = reg_val & 0x01;
		ret = regmap_read(pchip->regmap, REG_PWM_OUTLOW, &reg_val);
		if (ret < 0)
			goto out;
		brightness = ((brightness << 8) | reg_val) + 1;
	} else {
		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
		if (ret < 0)
			goto out;
		mdelay(1);
		ret = regmap_read(pchip->regmap, REG_BRT_A, &reg_val);
		if (ret < 0)
			goto out;

		//put chip into sleep mode if fl off
		regmap_read(pchip->regmap, REG_CTRL, &v);
		if (!(v & (BANK_A_CTRL_LED1 | BANK_B_CTRL_LED2))) {
			ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x80);
			if (ret < 0)
				goto out;
		}
		brightness = reg_val;
	}
	bl->props.brightness = brightness;
	return bl->props.brightness;
out:
	dev_err(pchip->dev, "i2c failed to access register\n");
	return 0;
}

static const struct backlight_ops lm3630_bank_a_ops = {
	.options = BL_CORE_SUSPENDRESUME,
	.update_status = lm3630_bank_a_update_status,
	.get_brightness = lm3630_bank_a_get_brightness,
};

static int lm3630_bank_b_update_status(struct backlight_device *bl)
{
	int ret;
	unsigned int v;
	struct lm3630_chip_data *pchip = bl_get_data(bl);
	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;

	DBG("br = %i, p = %i", bl->props.brightness, bl->props.power);

	if (pwm_ctrl == PWM_CTRL_BANK_B || pwm_ctrl == PWM_CTRL_BANK_ALL) {
		if (!set_intensity(bl, pchip))
			dev_err(pchip->dev,
				"no pwm control func. in plat-data\n");
	} else {
		//resume from sleep mode
		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
		if (ret < 0)
			goto out;
		mdelay(1);

		ret = regmap_update_bits(pchip->regmap, REG_I_B, 0x1f, bl->props.power);
		if (ret < 0)
			goto out;
//
//		if (bl->props.brightness < 4) {
//			ret = regmap_update_bits(pchip->regmap, REG_CTRL, (BANK_B_CTRL_LED2 << 1), 0x00);
//		} else  {
//			ret = regmap_update_bits(pchip->regmap, REG_CTRL, (BANK_B_CTRL_LED2 << 1), (BANK_B_CTRL_LED2 << 1));
//		}

		if (bl->props.brightness < 4) {
			ret = regmap_update_bits(pchip->regmap, REG_CTRL, BANK_B_CTRL_LED2, 0x00);
		} else  {
			ret = regmap_update_bits(pchip->regmap, REG_CTRL, BANK_B_CTRL_LED2, BANK_B_CTRL_LED2);
		}
		if (ret < 0)
			goto out;

		ret = regmap_write(pchip->regmap,
				   REG_BRT_B, bl->props.brightness);

		//put chip into sleep mode if fl off
		regmap_read(pchip->regmap, REG_CTRL, &v);
		DBG("get REG_CTRL %x\n",v);
		if (!(v & (BANK_A_CTRL_LED1 | BANK_B_CTRL_LED2))) {
			ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x80);
			if (ret < 0)
				goto out;
		}
	}
	return 0;
out:
	dev_err(pchip->dev, "i2c failed to access register\n");
	return ret;
}

static int lm3630_bank_b_get_brightness(struct backlight_device *bl)
{
	unsigned int reg_val, v;
	int brightness, ret;
	struct lm3630_chip_data *pchip = bl_get_data(bl);
	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;

	if (pwm_ctrl == PWM_CTRL_BANK_B || pwm_ctrl == PWM_CTRL_BANK_ALL) {
		ret = regmap_read(pchip->regmap, REG_PWM_OUTHIGH, &reg_val);
		if (ret < 0)
			goto out;
		brightness = reg_val & 0x01;
		ret = regmap_read(pchip->regmap, REG_PWM_OUTLOW, &reg_val);
		if (ret < 0)
			goto out;
		brightness = ((brightness << 8) | reg_val) + 1;
	} else {
		ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x00);
		if (ret < 0)
			goto out;
		mdelay(1);
		ret = regmap_read(pchip->regmap, REG_BRT_B, &reg_val);
		if (ret < 0)
			goto out;

		//put chip into sleep mode if fl off
		regmap_read(pchip->regmap, REG_CTRL, &v);
		if (!(v & (BANK_A_CTRL_LED1 | BANK_B_CTRL_LED2))) {
			ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x80, 0x80);
			if (ret < 0)
				goto out;
		}

		brightness = reg_val;
	}
	bl->props.brightness = brightness;

	return bl->props.brightness;
out:
	dev_err(pchip->dev, "i2c failed to access register\n");
	return bl->props.brightness;
}

static const struct backlight_ops lm3630_bank_b_ops = {
	.options = BL_CORE_SUSPENDRESUME,
	.update_status = lm3630_bank_b_update_status,
	.get_brightness = lm3630_bank_b_get_brightness,
};

static int lm3630_backlight_register(struct lm3630_chip_data *pchip,
				     enum lm3630_leds ledno)
{
	const char *name = bled_name[ledno];
	struct backlight_properties props;
	struct lm3630_platform_data *pdata = pchip->pdata;

	props.type = BACKLIGHT_RAW;
	switch (ledno) {
	case BLED_1:
	case BLED_ALL:
		props.brightness = pdata->init_brt_led1;
		props.max_brightness = pdata->max_brt_led1;
		props.power = pdata->max_current_led1;
		pchip->bled1 = backlight_device_register(name, pchip->dev, pchip,
					      &lm3630_bank_a_ops, &props);
		if (IS_ERR(pchip->bled1))
			return PTR_ERR(pchip->bled1);
		break;
	case BLED_2:
		props.brightness = pdata->init_brt_led2;
		props.max_brightness = pdata->max_brt_led2;
		props.power = pdata->max_current_led2;
		pchip->bled2 = backlight_device_register(name, pchip->dev, pchip,
					      &lm3630_bank_b_ops, &props);
		if (IS_ERR(pchip->bled2))
			return PTR_ERR(pchip->bled2);
		break;
	}
	return 0;
}

static void lm3630_backlight_unregister(struct lm3630_chip_data *pchip)
{
	if (pchip->bled1)
		backlight_device_unregister(pchip->bled1);
	if (pchip->bled2)
		backlight_device_unregister(pchip->bled2);
}

static const struct regmap_config lm3630_regmap = {
	.reg_bits = 8,
	.val_bits = 8,
	.max_register = REG_MAX,
};

static int lm3630a_probe(struct i2c_client *client,
				  const struct i2c_device_id *id)
{
	struct lm3630_platform_data *pdata = client->dev.platform_data;
	struct lm3630_chip_data *pchip;
	struct device_node *np = client->dev.of_node;
	int ret;

	int max_current_led1 = 0;
	int max_current_led2 = 0;
	unsigned int mode = BANK_A_CTRL_LED1 | BANK_B_CTRL_LED2;

	DBG("+++++ pdata = %p; client = %p", pdata, client);
	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
		dev_err(&client->dev, "fail : i2c functionality check...\n");
		return -EOPNOTSUPP;
	}

	if (!np) {
		dev_err(&client->dev, "no device-tree node\n");
		return -EINVAL;
	}

	//allocate pdata 
	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
	if (!pdata)
		return -ENOMEM;

	//read DT properties
	ret = of_property_read_u32(np, "mode", &mode);
	if (ret) {
		dev_err(&client->dev, "missing DT property: mode\n");
		return ret;
	}

	ret = of_property_read_u32(np, "max_i_ch1", &max_current_led1);
	if (ret) {
		dev_err(&client->dev, "missing DT property: max_i_ch1\n");
		return ret;
	}

	ret = of_property_read_u32(np, "max_i_ch2", &max_current_led2);
	if (ret) {
		dev_err(&client->dev, "missing DT property: max_i_ch2\n");
		return ret;
	}
	//init br
	ret = of_property_read_u32(np, "init_brt_led1", &pdata->init_brt_led1);
	if (ret) {
		pdata->init_brt_led1 = 0;
		dev_err(&client->dev, "missing DT property: init_brt_led1, set default = %i\n", pdata->init_brt_led1);
	}
	ret = of_property_read_u32(np, "max_brt_led1", &pdata->max_brt_led1);
	if (ret) {
		pdata->max_brt_led1 = 255;
		dev_err(&client->dev, "missing DT property: max_brt_led1, set default = %i\n", pdata->max_brt_led1);
	}

	ret = of_property_read_u32(np, "init_brt_led2", &pdata->init_brt_led2);
	if (ret) {
		pdata->init_brt_led2 = 0;
		dev_err(&client->dev, "missing DT property: init_brt_led2, set default = %i\n", pdata->init_brt_led2);
	}
	ret = of_property_read_u32(np, "max_brt_led2", &pdata->max_brt_led2);
	if (ret) {
		pdata->max_brt_led2 = 255;
		dev_err(&client->dev, "missing DT property: max_brt_led2, set default = %i\n", pdata->max_brt_led2);
	}


	dev_info(&client->dev,
		 "DT: mode=0x%x max_i_ch1=%u max_i_ch2=%u\n",
		 mode, max_current_led1, max_current_led2);

	//pdata->init_brt_led1 = 0;
	//pdata->max_brt_led1 = 255;
	pdata->max_current_led1 = max_current_led1;
	pdata->bank_a_ctrl = mode & BANK_A_CTRL_MASK;

	//pdata->init_brt_led2 = 0;
	//pdata->max_brt_led2 = 255;
	pdata->max_current_led2 = max_current_led2;
	pdata->bank_b_ctrl = mode & BANK_B_CTRL_MASK;

	pdata->pwm_active = PWM_CTRL_DISABLE;

	// allocate pchip
	pchip = devm_kzalloc(&client->dev, sizeof(*pchip), GFP_KERNEL);
	if (!pchip)
		return -ENOMEM;

	pchip->dev = &client->dev;
	pchip->pdata = pdata;


	//regmap
	pchip->regmap = devm_regmap_init_i2c(client, &lm3630_regmap);
	if (IS_ERR(pchip->regmap)) {
		ret = PTR_ERR(pchip->regmap);
		dev_err(&client->dev, "regmap init failed: %d\n", ret);
		return ret;
	}

	//gpio
	pchip->enable_gpio =
		devm_gpiod_get_optional(&client->dev, "enable", GPIOD_OUT_HIGH);
	if (IS_ERR(pchip->enable_gpio)) {
		dev_err(&client->dev, "failed to get enable-gpio\n");
		return PTR_ERR(pchip->enable_gpio);
	}

	pchip->led_enable_gpio =
		devm_gpiod_get_optional(&client->dev, "led-enable", GPIOD_OUT_HIGH);
	if (IS_ERR(pchip->led_enable_gpio)) {
		dev_err(&client->dev, "failed to get led-enable-gpio\n");
		return PTR_ERR(pchip->led_enable_gpio);
	}

	if (pchip->enable_gpio)
		gpiod_set_value_cansleep(pchip->enable_gpio, 1);

	if (pchip->led_enable_gpio)
		gpiod_set_value_cansleep(pchip->led_enable_gpio, 1);

	//sleep
	usleep_range(1000, 2000);


	i2c_set_clientdata(client, pchip);

	ret = lm3630_chip_init(pchip);
	if (ret < 0) {
		dev_err(&client->dev, "fail : init chip\n");
		goto err_chip_init;
	}


	switch (pdata->bank_a_ctrl & 0x7) {
	case BANK_A_CTRL_ALL:
		ret = lm3630_backlight_register(pchip, BLED_ALL);
		pdata->bank_b_ctrl = BANK_B_CTRL_DISABLE;
		break;
	case BANK_A_CTRL_LED1:
		ret = lm3630_backlight_register(pchip, BLED_1);
		break;
	case BANK_A_CTRL_LED2:
		ret = lm3630_backlight_register(pchip, BLED_2);
		pdata->bank_b_ctrl = BANK_B_CTRL_DISABLE;
		break;
	default:
		break;
	}
	if (ret < 0) {
		dev_err(&client->dev, "backlight register failed\n");
		goto err_bl_reg;
	}


	if (pdata->bank_b_ctrl && pchip->bled2 == NULL) {
		ret = lm3630_backlight_register(pchip, BLED_2);
		if (ret < 0) {
			dev_err(&client->dev, "backlight register failed 2\n");
			goto err_bl_reg;
		}
	}

	// interrupt enable  : irq 0 is not allowed for lm3630
	pchip->irq = client->irq;
	if (pchip->irq)
		lm3630_intr_config(pchip);

	dev_info(&client->dev, "LM3630 backlight register OK.\n");
	return 0;

err_bl_reg:
	dev_err(&client->dev, "fail : backlight register.\n");
	lm3630_backlight_unregister(pchip);
err_chip_init:
	return ret;

}

static int lm3630a_remove(struct i2c_client *client)
{
	int ret;
	struct lm3630_chip_data *pchip = i2c_get_clientdata(client);

	ret = regmap_write(pchip->regmap, REG_BRT_A, 0);
	if (ret < 0)
		dev_err(pchip->dev, "i2c failed to access register\n");

	ret = regmap_write(pchip->regmap, REG_BRT_B, 0);
	if (ret < 0)
		dev_err(pchip->dev, "i2c failed to access register\n");

	lm3630_backlight_unregister(pchip);
	if (pchip->irq) {
		free_irq(pchip->irq, pchip);
		flush_workqueue(pchip->irqthread);
		destroy_workqueue(pchip->irqthread);
	}
	return 0;
}

#ifdef CONFIG_PM_SLEEP
int lm3630a_suspend(struct device *dev) {
	DBG("in\n");
	return 0;
}

int lm3630a_resume(struct device *dev) {

	struct lm3630_chip_data *pchip = dev_get_drvdata(dev); //i2c_get_clientdata()(dev);
	int ret;
	DBG("in\n");

	if (mem_sleep_current != PM_SUSPEND_MEM_ULTRA)
		return 0;

	ret = lm3630_chip_init(pchip);
	if (ret < 0) {
		dev_err(dev, "fail : init chip\n");
		return ret;
	}

	return 0;
}

static const struct dev_pm_ops lm3630a_pm_ops = {
	.suspend = lm3630a_suspend,
	.resume = lm3630a_resume,
};
#endif

static const struct i2c_device_id lm3630a_id[] = {
	{LM3630_NAME, 0},
	{}
};

MODULE_DEVICE_TABLE(i2c, lm3630a_id);

static const struct of_device_id lm3630a_match_table[] = {
	{ .compatible = "ti,lm3630a", },
	{ },
};

MODULE_DEVICE_TABLE(of, lm3630a_match_table);

static struct i2c_driver lm3630a_i2c_driver = {
	.driver = {
			.name = LM3630_NAME,
			.of_match_table = lm3630a_match_table,
			#ifdef CONFIG_PM_SLEEP
			.pm = &lm3630a_pm_ops,
			#endif
		},
	.probe = lm3630a_probe,
	.remove = lm3630a_remove,
	.id_table = lm3630a_id,
};


module_i2c_driver(lm3630a_i2c_driver);

MODULE_DESCRIPTION("Texas Instruments Backlight driver for LM3630");
MODULE_AUTHOR("G.Shark Jeong <gshark.jeong@gmail.com>");
MODULE_AUTHOR("Daniel Jeong <daniel.jeong@ti.com>");
MODULE_LICENSE("GPL v2");
