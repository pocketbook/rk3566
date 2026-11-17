// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

#define LOG_TAG  "EBC pmic "

#include <linux/gpio/consumer.h>
#include <linux/i2c.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/regulator/driver.h>
#include <linux/regulator/machine.h>
#include <linux/regulator/of_regulator.h>
#include <linux/regmap.h>
#include <linux/slab.h>
#include <linux/version.h>
#include "sy7636a.h"

#include "../ebc_log.h"

#define SY7636A_MAX_ENABLE_GPIO_NUM 4

#define PGOOD_TIMEOUT 250

struct sy7636a_data {
	struct platform_device *pdev;
	struct regmap *regmap;
	struct gpio_descs *enable_gpio;
	struct gpio_desc *pgood_gpio;
	int pgood_irq;
	/*
	 * When registering a new regulator, regulator core will try to
	 * call "set_suspend_disable" to check whether regulator device
	 * working well.
	 * Just skip this suspend to avoid reconfiguring pinctrl.
	 */
	bool initial_suspend;
	int vcom_uV;
};

int sy7636a_wait_pgood(struct regulator_dev *rdev)
{
	struct sy7636a_data *data = rdev->reg_data;
	u32 val;
	int i, ret;

	for (i=0; i<PGOOD_TIMEOUT; i++) {
		struct regmap *regmap = data->regmap;

		ret = regmap_read(regmap, SY7636A_REG_FAULT_FLAG, &val);
		if (ret) {
			ERR("sy7636a failed to read fault flag\n");
			return -EIO;
		}

		if ((val & SY7636A_FAULT_FLAG_PG) && !(val & SY7636A_FAULT_FLAG_FAULT)) {
			DBG("sy7636a power good (%d)\n", i);
			return 0;
		}
		usleep_range(1000, 1200);
	}

	ERR("sy7636a PWRGOOD TIMEOUT, POWER FLAG: %02x\n", val);
	return -ETIMEDOUT;
}

static int sy7636a_power_enable(struct regulator_dev *rdev)
{
	struct sy7636a_data *data = rdev->reg_data;
	int ret;

	DBG("sy7636a power enable\n");

	ret = (regulator_is_enabled_regmap(rdev) > 0) ? 0 : regulator_enable_regmap(rdev);
	if (ret) {
		ERR("sy7636a failed to enable\n");
		return -EIO;
	}
	enable_irq(data->pgood_irq);
	return sy7636a_wait_pgood(rdev);
}

static int sy7636a_power_disable(struct regulator_dev *rdev)
{
	struct sy7636a_data *data = rdev->reg_data;

	DBG("sy7636a power disable\n");
	disable_irq(data->pgood_irq);
	return (regulator_is_enabled_regmap(rdev) > 0) ? regulator_disable_regmap(rdev) : 0;
}

static int sy7636a_get_vcom_voltage_op(struct regulator_dev *rdev)
{
	int ret;
	unsigned int val, val_h;

	ret = regmap_read(rdev->regmap, SY7636A_REG_VCOM_ADJUST_CTRL_L, &val);
	if (ret)
		return ret;

	ret = regmap_read(rdev->regmap, SY7636A_REG_VCOM_ADJUST_CTRL_H, &val_h);
	if (ret)
		return ret;

	val |= (val_h & 0x80) << 1;

	return (val & VCOM_ADJUST_CTRL_MASK) * VCOM_ADJUST_CTRL_SCAL;
}

static int sy7636a_set_vcom_voltage_op(struct regulator_dev *rdev, int min_uV, int max_uV,
				       unsigned int *selector)
{
	struct sy7636a_data *data = rdev->reg_data;
	int min_mV = DIV_ROUND_UP(min_uV, 1000);
	int max_mV = max_uV / 1000;
	u32 val;
	int ret;

	if (max_mV < min_mV)
		return -EINVAL;

	val = min_mV / 10;

	ret = regmap_write(rdev->regmap, SY7636A_REG_VCOM_ADJUST_CTRL_L, val & 0xFF);
	if (ret)
		return ret;

	ret = regmap_write(rdev->regmap, SY7636A_REG_VCOM_ADJUST_CTRL_H, (val >> 1) & 0x80);
	if (ret)
		return ret;

	data->vcom_uV = min_uV;

	return 0;
}

static int sy7636a_get_status(struct regulator_dev *rdev)
{
	return 0;
}

#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 1, 0)
static int sy7636a_set_suspend_disable(struct regulator_dev *rdev)
{
	DECLARE_BITMAP(values, SY7636A_MAX_ENABLE_GPIO_NUM);
	struct sy7636a_data *data = rdev->reg_data;
	int ret;

	bitmap_zero(values, SY7636A_MAX_ENABLE_GPIO_NUM);

	/* Skip initial suspend */
	if (data->initial_suspend) {
		data->initial_suspend = false;
		return 0;
	}

	ret = regmap_write_bits(rdev->regmap, SY7636A_REG_OPERATION_MODE_CRL,
				SY7636A_OPERATION_MODE_CRL_VCOMCTL, 0);
	if (ret)
		return ret;

	if (data->enable_gpio) {
		ret = gpiod_set_array_value_cansleep(data->enable_gpio->ndescs,
						     data->enable_gpio->desc,
						     data->enable_gpio->info, values);
		if (ret)
			return ret;
	}

	return 0;
}
#else
static int sy7636a_set_suspend_disable(struct regulator_dev *rdev)
{
	struct sy7636a_data *data = rdev->reg_data;
	int ret;

	/* Skip initial suspend */
	if (data->initial_suspend) {
		data->initial_suspend = false;
		return 0;
	}

	ret = regmap_write_bits(rdev->regmap, SY7636A_REG_OPERATION_MODE_CRL,
				SY7636A_OPERATION_MODE_CRL_VCOMCTL, 0);
	if (ret)
		return ret;

	if (data->enable_gpio) {
		int i;
		int nvalues = data->enable_gpio->ndescs;
		int *values = kmalloc_array(nvalues, sizeof(int), GFP_KERNEL);
		if (!values)
			return -ENOMEM;
		for (i = 0; i < nvalues; i++)
			values[i] = 0;
		gpiod_set_array_value_cansleep(data->enable_gpio->ndescs,
						     data->enable_gpio->desc, values);
		kfree(values);
	}

	return 0;
}
#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 1, 0)
static int sy7636a_resume(struct regulator_dev *rdev)
{
	DECLARE_BITMAP(values, SY7636A_MAX_ENABLE_GPIO_NUM);
	struct sy7636a_data *data = rdev->reg_data;
	int ret, val;

	DBG("sy7636a resume\n");

	bitmap_fill(values, SY7636A_MAX_ENABLE_GPIO_NUM);

	if (data->enable_gpio) {
		ret = gpiod_set_array_value_cansleep(data->enable_gpio->ndescs,
						     data->enable_gpio->desc,
						     data->enable_gpio->info, values);
		if (ret)
			return ret;
	}

	/* After enable, sy7636a needs 2.5ms to enter active mode from sleep mode. */
	usleep_range(5000, 5200);

	/* VCOM setting resume */
	val = data->vcom_uV / VCOM_ADJUST_CTRL_SCAL;

	ret = regmap_write(rdev->regmap, SY7636A_REG_VCOM_ADJUST_CTRL_L, val & 0xFF);
	if (ret)
		return ret;

	ret = regmap_write(rdev->regmap, SY7636A_REG_VCOM_ADJUST_CTRL_H, (val >> 1) & 0x80);
	if (ret)
		return ret;

	ret = regmap_write(rdev->regmap, SY7636A_REG_POWER_ON_DELAY_TIME, 0x0);
	if (ret)
		return ret;

	ret = regmap_write_bits(rdev->regmap, SY7636A_REG_OPERATION_MODE_CRL,
				SY7636A_OPERATION_MODE_CRL_VCOMCTL, 1);
	if (ret)
		return ret;

	return 0;
}
#else
static int sy7636a_resume(struct regulator_dev *rdev)
{
	struct sy7636a_data *data = rdev->reg_data;
	int ret, val;

	DBG("sy7636a resume\n");

	if (data->enable_gpio) {
		int i;
		int nvalues = data->enable_gpio->ndescs;
		int *values = kmalloc_array(nvalues, sizeof(int), GFP_KERNEL);
		if (!values)
			return -ENOMEM;
		for (i = 0; i < nvalues; i++)
			values[i] = 1;
		gpiod_set_array_value_cansleep(data->enable_gpio->ndescs,
						     data->enable_gpio->desc, values);
		kfree(values);
	}

	/* After enable, sy7636a needs 2.5ms to enter active mode from sleep mode. */
	usleep_range(5000, 5200);

	/* VCOM setting resume */
	val = data->vcom_uV / VCOM_ADJUST_CTRL_SCAL;

	ret = regmap_write(rdev->regmap, SY7636A_REG_VCOM_ADJUST_CTRL_L, val & 0xFF);
	if (ret)
		return ret;

	ret = regmap_write(rdev->regmap, SY7636A_REG_VCOM_ADJUST_CTRL_H, (val >> 1) & 0x80);
	if (ret)
		return ret;

	ret = regmap_write(rdev->regmap, SY7636A_REG_POWER_ON_DELAY_TIME, 0x0);
	if (ret)
		return ret;

	ret = regmap_write_bits(rdev->regmap, SY7636A_REG_OPERATION_MODE_CRL,
				SY7636A_OPERATION_MODE_CRL_VCOMCTL, 1);
	if (ret)
		return ret;

	return 0;
}
#endif

static const struct regulator_ops sy7636a_vcom_volt_ops = {
	.set_voltage = sy7636a_set_vcom_voltage_op,
	.get_voltage = sy7636a_get_vcom_voltage_op,
	.enable = sy7636a_power_enable,
	.disable = sy7636a_power_disable,
	.is_enabled = regulator_is_enabled_regmap,
	.get_status = sy7636a_get_status,
	.set_suspend_disable = sy7636a_set_suspend_disable,
	.resume = sy7636a_resume,
};

static const struct regulator_desc desc = {
	.name = "vcom",
	.id = 0,
	.ops = &sy7636a_vcom_volt_ops,
	.type = REGULATOR_VOLTAGE,
	.owner = THIS_MODULE,
	.enable_reg = SY7636A_REG_OPERATION_MODE_CRL,
	.enable_mask = SY7636A_OPERATION_MODE_CRL_ONOFF,
	.regulators_node = of_match_ptr("regulators"),
	.of_match = of_match_ptr("vcom"),
};

static irqreturn_t sy7636a_power_good_irq_handler(int irq, void *dev_id)
{
	struct sy7636a_data *data = dev_id;
	struct regmap *regmap = data->regmap;
	u32 val;
	int ret;

	ret = regmap_read(regmap, SY7636A_REG_FAULT_FLAG, &val);
	if (ret) {
		ERR("IRQ: sy7636a failed to read fault flag\n");
		goto out;
	}

	if ((val & SY7636A_FAULT_FLAG_PG) && !(val & SY7636A_FAULT_FLAG_FAULT)) {
		DBG("IRQ: power good\n");
	} else {
		ERR("IRQ: sy7636a power fault flag:%d\n",
			val >> SY7636A_FAULT_FLAG_FAULT_SHIFT);
	}

out:
	return IRQ_HANDLED;
}

static int sy7636a_regulator_probe(struct platform_device *pdev)
{
	struct regmap *regmap = dev_get_regmap(pdev->dev.parent, NULL);
	struct regulator_config config = { };
	struct regulator_dev *rdev;
	struct sy7636a_data *data;
	int ret, val, val_h;

	INF("sy7636a probe\n");

	if (!regmap)
		return -EPROBE_DEFER;

	data = devm_kzalloc(&pdev->dev, sizeof(struct sy7636a_data), GFP_KERNEL);
	if (!data)
		return -ENOMEM;

	data->pdev = pdev;
	data->regmap = regmap;
	data->initial_suspend = true;

	data->enable_gpio = devm_gpiod_get_array_optional(pdev->dev.parent, "enable",
							  GPIOD_OUT_HIGH);
	if (IS_ERR(data->enable_gpio)) {
		ERR("Failed to get sy7636a enable gpio %ld\n",
			PTR_ERR(data->enable_gpio));
		return PTR_ERR(data->enable_gpio);
	}

	data->pgood_irq = -1;
	data->pgood_gpio = devm_gpiod_get(pdev->dev.parent, "pgood", GPIOD_IN);
	if (IS_ERR(data->pgood_gpio)) {
		ERR("Failed to get sy7636a pgood gpio %ld\n",
			 PTR_ERR(data->pgood_gpio));
	} else {
		data->pgood_irq = gpiod_to_irq(data->pgood_gpio);
		if (data->pgood_irq < 0) {
			ERR("Failed to get sy7636a power good int irq\n");
		} else {
			ret = devm_request_threaded_irq(pdev->dev.parent, data->pgood_irq, NULL,
							sy7636a_power_good_irq_handler,
							IRQF_TRIGGER_FALLING |
							IRQF_ONESHOT,
							"sy7636a", data);
			if (ret)
				ERR("Failed to request sy7636a irq\n");
			disable_irq(data->pgood_irq);
		}
		DBG("sy7636a registered pgood irq %d gpio %d\n", data->pgood_irq, desc_to_gpio(data->pgood_gpio));
	}

	/* sy7636a needs 2.5ms to enter active mode after enable */
	usleep_range(5000, 5200);

	ret = regmap_write(regmap, SY7636A_REG_POWER_ON_DELAY_TIME, 0x0);
	if (ret)
		goto fail;

	ret = regmap_read(regmap, SY7636A_REG_VCOM_ADJUST_CTRL_L, &val);
	if (ret)
		goto fail;

	ret = regmap_read(regmap, SY7636A_REG_VCOM_ADJUST_CTRL_H, &val_h);
	if (ret)
		goto fail;

	val |= (val_h << VCOM_ADJUST_CTRL_SHIFT);
	data->vcom_uV = (val & VCOM_ADJUST_CTRL_MASK) * VCOM_ADJUST_CTRL_SCAL;

	platform_set_drvdata(pdev, data);

	config.dev = &pdev->dev;
	config.dev->of_node = pdev->dev.parent->of_node;
	config.regmap = regmap;
	config.driver_data = data;

	rdev = devm_regulator_register(&pdev->dev, &desc, &config);
	if (IS_ERR(rdev)) {
		ERR("Failed to register %s regulator\n", pdev->name);
		return PTR_ERR(rdev);
	}

	DBG("sy7636a probe success\n");
	return 0;

fail:
	ERR("Failed to initialize regulator: %d\n", ret);
	return ret;
}

static const struct platform_device_id sy7636a_regulator_id_table[] = {
	{ "sy7636a-regulator", },
	{ }
};
MODULE_DEVICE_TABLE(platform, sy7636a_regulator_id_table);

static struct platform_driver sy7636a_regulator_driver = {
	.driver = {
		.name = "sy7636a-regulator",
	},
	.probe = sy7636a_regulator_probe,
	.id_table = sy7636a_regulator_id_table,
};

int sy7636a_regulator_init(void)
{
	return platform_driver_register(&sy7636a_regulator_driver);
}

void sy7636a_regulator_deinit(void)
{
	platform_driver_unregister(&sy7636a_regulator_driver);
}
