// SPDX-License-Identifier: GPL-2.0-or-later
/*
 * Rockchip RK805 PMIC Power Key driver
 *
 * Copyright (c) 2017, Fuzhou Rockchip Electronics Co., Ltd
 *
 * Author: Joseph Chen <chenjh@rock-chips.com>
 */

#include <linux/errno.h>
#include <linux/init.h>
#include <linux/input.h>
#include <linux/interrupt.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>

static struct class *rk_class;
static struct device *pwrkey_dev;

static atomic_t pwrkey_state = ATOMIC_INIT(0);

static irqreturn_t pwrkey_fall_irq(int irq, void *_pwr)
{
	struct input_dev *pwr = _pwr;

	atomic_set(&pwrkey_state, 1);
	input_report_key(pwr, KEY_POWER, 1);
	input_sync(pwr);

	return IRQ_HANDLED;
}

static irqreturn_t pwrkey_rise_irq(int irq, void *_pwr)
{
	struct input_dev *pwr = _pwr;

	atomic_set(&pwrkey_state, 0);
	input_report_key(pwr, KEY_POWER, 0);
	input_sync(pwr);

	return IRQ_HANDLED;
}

static ssize_t state_show(struct device *dev,
                          struct device_attribute *attr,
                          char *buf)
{
    return sprintf(buf, "%d\n", atomic_read(&pwrkey_state));
}

static DEVICE_ATTR_RO(state);


static int rk805_pwrkey_probe(struct platform_device *pdev)
{
	struct input_dev *pwr;
	int fall_irq, rise_irq;
	struct device_node *np;
	int err;

	np = of_get_child_by_name(pdev->dev.parent->of_node, "pwrkey");
	if (np && !of_device_is_available(np)) {
		dev_info(&pdev->dev, "device is disabled\n");
		return -EINVAL;
	}

	pwr = devm_input_allocate_device(&pdev->dev);
	if (!pwr) {
		dev_err(&pdev->dev, "Can't allocate power button\n");
		return -ENOMEM;
	}

	pwr->name = "rk805 pwrkey";
	pwr->phys = "rk805_pwrkey/input0";
	pwr->id.bustype = BUS_HOST;
	input_set_capability(pwr, EV_KEY, KEY_POWER);

	fall_irq = platform_get_irq(pdev, 0);
	if (fall_irq < 0)
		return fall_irq;

	rise_irq = platform_get_irq(pdev, 1);
	if (rise_irq < 0)
		return rise_irq;

	err = devm_request_any_context_irq(&pwr->dev, fall_irq,
					   pwrkey_fall_irq,
					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
					   "rk805_pwrkey_fall", pwr);
	if (err < 0) {
		dev_err(&pdev->dev, "Can't register fall irq: %d\n", err);
		return err;
	}

	err = devm_request_any_context_irq(&pwr->dev, rise_irq,
					   pwrkey_rise_irq,
					   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
					   "rk805_pwrkey_rise", pwr);
	if (err < 0) {
		dev_err(&pdev->dev, "Can't register rise irq: %d\n", err);
		return err;
	}

	err = input_register_device(pwr);
	if (err) {
		dev_err(&pdev->dev, "Can't register power button: %d\n", err);
		return err;
	}

	rk_class = class_create(THIS_MODULE, "rk");
	if (IS_ERR(rk_class)) {
		dev_err(&pdev->dev, "failed to create rk class\n");
		return PTR_ERR(rk_class);
	}

	pwrkey_dev = device_create(rk_class, NULL, 0, NULL, "pwrkey");
	if (IS_ERR(pwrkey_dev)) {
		class_destroy(rk_class);
		dev_err(&pdev->dev, "failed to create pwrkey device\n");
		return PTR_ERR(pwrkey_dev);
	}

	err = device_create_file(pwrkey_dev, &dev_attr_state);
	if (err) {
		device_destroy(rk_class, 0);
		class_destroy(rk_class);
		dev_err(&pdev->dev, "failed to create state attribute\n");
		return err;
	}


	platform_set_drvdata(pdev, pwr);
	device_init_wakeup(&pdev->dev, true);

	return 0;
}

static int rk805_pwrkey_remove(struct platform_device *pdev)
{
    device_remove_file(pwrkey_dev, &dev_attr_state);
    device_destroy(rk_class, 0);
    class_destroy(rk_class);
    return 0;
}

static struct platform_driver rk805_pwrkey_driver = {
	.probe	= rk805_pwrkey_probe,
	.remove = rk805_pwrkey_remove,
	.driver	= {
		.name = "rk805-pwrkey",
	},
};
module_platform_driver(rk805_pwrkey_driver);

MODULE_ALIAS("platform:rk805-pwrkey");
MODULE_AUTHOR("Joseph Chen <chenjh@rock-chips.com>");
MODULE_DESCRIPTION("RK805 PMIC Power Key driver");
MODULE_LICENSE("GPL");
