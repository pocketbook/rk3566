// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020 Rockchip Electronics Co. Ltd.
 *
 * Author: Bin Yang <yangbin@rock-chips.com>
 */


#include <linux/platform_device.h>
#include <linux/interrupt.h>
#include <linux/i2c.h>
#include <linux/slab.h>
#include <linux/irq.h>
#include <linux/miscdevice.h>
#include <linux/gpio.h>
#include <linux/uaccess.h>
#include <linux/atomic.h>
#include <linux/delay.h>
#include <linux/input.h>
#include <linux/workqueue.h>
#include <linux/freezer.h>
#include <linux/of_gpio.h>
#include <linux/sensor-dev.h>
#include <linux/fb.h>
#include <linux/notifier.h>
#include <linux/rk_keys.h>
#include <linux/input.h>

bool is_hall_sensor_suspend=false;
bool is_hall_sensor_wakeup=false;
bool is_cover_close=false;

struct mh248_para {
	struct device *dev;
	struct mutex ops_lock;
	struct input_dev *hall_input;
	struct workqueue_struct *workqueue;
	struct work_struct work;
	int gpio_pin;
	int irq;
	int active_value;
	int keycode_active;
	int keycode_wakeup;
};

static void hallsensor_irq_work(struct work_struct *work){

	struct mh248_para *mh248 = container_of(work, struct mh248_para, work);
	int status;
	status = gpio_get_value(mh248->gpio_pin);

	dev_info(mh248->dev, "%s : status = %i\n",__func__,status);
	dev_info(mh248->dev, "%s : active_value = %i\n",__func__,mh248->active_value);

	if(status == mh248->active_value){
		if (!mh248->hall_input)
		return;
		dev_info(mh248->dev, "%s : cover up\n",__func__);
		input_report_key(mh248->hall_input, mh248->keycode_wakeup, 1); //
		input_sync(mh248->hall_input);
		input_report_key(mh248->hall_input, mh248->keycode_wakeup, 0);
		input_sync(mh248->hall_input);
		is_cover_close = false;

	}
	if(status != mh248->active_value){
		if (!mh248->hall_input)
		return; 
		dev_info(mh248->dev, "%s : cover down\n",__func__);
		input_report_key(mh248->hall_input, mh248->keycode_active, 1); //
		input_sync(mh248->hall_input);
		input_report_key(mh248->hall_input, mh248->keycode_active, 0);
		input_sync(mh248->hall_input);
		is_cover_close = true;
	}
}


static irqreturn_t hall_mh248_interrupt(int irq, void *dev_id)
{
	struct mh248_para *mh248 = (struct mh248_para *)dev_id;

	dev_info(mh248->dev, "%s : is_hall_sensor_suspend = %i\n",__func__, is_hall_sensor_suspend);
    if(is_hall_sensor_suspend){
          is_hall_sensor_wakeup=true;
	}else{
		dev_info(mh248->dev, "%s : queue_work\n",__func__);
        queue_work(mh248->workqueue, &mh248->work);
	}

	return IRQ_HANDLED;
}

static int hall_mh248_probe(struct platform_device *pdev)
{
	struct device_node *np = pdev->dev.of_node;
	struct mh248_para *mh248;
	enum of_gpio_flags irq_flags;
	int hallactive = 0;
	int ret = 0;

	mh248 = devm_kzalloc(&pdev->dev, sizeof(*mh248), GFP_KERNEL);
	if (!mh248)
		return -ENOMEM;

	mh248->dev = &pdev->dev;

	mh248->gpio_pin = of_get_named_gpio_flags(np, "irq-gpio",
						  0, &irq_flags);
	if (!gpio_is_valid(mh248->gpio_pin)) {
		dev_err(mh248->dev, "Can not read property irq-gpio\n");
		return mh248->gpio_pin;
	}
	mh248->irq = gpio_to_irq(mh248->gpio_pin);

	of_property_read_u32(np, "hall-active", &hallactive);
	mh248->active_value = hallactive;
	mutex_init(&mh248->ops_lock);

	/* Read keycodes from DT, with defaults */
	if (of_property_read_u32(np, "hall-keycode-active", &mh248->keycode_active))
		mh248->keycode_active = KEY_HALL_SENSOR_NEAR;
	if (of_property_read_u32(np, "hall-keycode-wakeup", &mh248->keycode_wakeup))
		mh248->keycode_wakeup = KEY_HALL_SENSOR_LEAVE;

	dev_info(&pdev->dev, "hall active keycode: %d\n", mh248->keycode_active);
	dev_info(&pdev->dev, "hall suspend keycode: %d\n", mh248->keycode_wakeup);

	ret = devm_gpio_request_one(mh248->dev, mh248->gpio_pin,
				    GPIOF_DIR_IN, "hall_mh248");
	if (ret < 0) {
		dev_err(mh248->dev, "fail to request gpio:%d\n", mh248->gpio_pin);
		return ret;
	}

	ret = devm_request_irq(mh248->dev, mh248->irq, hall_mh248_interrupt,
					irq_flags | IRQF_NO_SUSPEND | IRQF_ONESHOT,
					"hall_mh248", mh248);

	if (ret < 0) {
		dev_err(mh248->dev, "request irq(%d) failed, ret=%d\n",
			mh248->irq, ret);
		return ret;
	}

	mh248->hall_input = devm_input_allocate_device(&pdev->dev);
	if (!mh248->hall_input) {
		dev_err(&pdev->dev, "Can't allocate hall input dev\n");
		return -ENOMEM;
	}


	mh248->hall_input->name = "hall wake key";
	input_set_capability(mh248->hall_input, EV_KEY, KEY_HALL_SENSOR_NEAR); 
	input_set_capability(mh248->hall_input, EV_KEY, KEY_HALL_SENSOR_LEAVE);

	ret = input_register_device(mh248->hall_input);
	if (ret) {
		dev_err(&pdev->dev, "Unable to register input device, error: %d\n", ret);
		return ret;
	}

	enable_irq_wake(mh248->irq);

	mh248->workqueue = create_singlethread_workqueue("hallsensor_key");
	INIT_WORK(&mh248->work, hallsensor_irq_work);
	dev_set_drvdata(&pdev->dev, mh248);

	dev_info(mh248->dev, "hall_mh248_probe success.\n");

	return 0;
}

#ifdef CONFIG_PM
static int hall_mh248_suspend(struct device *dev)
{
	struct mh248_para *mh248 = dev_get_drvdata(dev);

	dev_info(mh248->dev, "%s\n",__func__);
	is_hall_sensor_suspend=true;
	cancel_work_sync(&mh248->work);
	flush_workqueue(mh248->workqueue);

	return 0;
}

static int hall_mh248_resume(struct device *dev)
{

	struct mh248_para *mh248 = dev_get_drvdata(dev);

	dev_info(mh248->dev, "%s\n",__func__);
	dev_info(mh248->dev, "%s : is_hall_sensor_suspend = %i\n",__func__, is_hall_sensor_suspend);
	dev_info(mh248->dev, "%s : is_hall_sensor_wakeup = %i\n",__func__, is_hall_sensor_wakeup);
	is_hall_sensor_suspend=false;
	if(is_hall_sensor_wakeup || is_cover_close){
        is_hall_sensor_wakeup=false;
		dev_info(mh248->dev, "%s : queue_work\n",__func__);
	  	queue_work(mh248->workqueue, &mh248->work);
	}

	return 0;
}

static const struct dev_pm_ops hall_mh248_pm_ops = {
	.suspend	= hall_mh248_suspend,
	.resume	= hall_mh248_resume,
};
#endif

static const struct of_device_id hall_mh248_match[] = {
	{ .compatible = "hall-mh248" },
	{ /* Sentinel */ }
};

static struct platform_driver hall_mh248_driver = {
	.probe = hall_mh248_probe,
	.driver = {
		.name = "mh248",
		.owner = THIS_MODULE,
		.of_match_table	= hall_mh248_match,
#ifdef CONFIG_PM
 		.pm	= &hall_mh248_pm_ops,
#endif
	},
};

module_platform_driver(hall_mh248_driver);

MODULE_ALIAS("platform:mh248");
MODULE_AUTHOR("Bin Yang <yangbin@rock-chips.com>");
MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("Hall Sensor MH248 driver");
