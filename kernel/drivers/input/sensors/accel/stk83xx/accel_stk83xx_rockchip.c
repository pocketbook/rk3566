#include "stk83xx.h"
#include "common_define.h"

typedef struct stk83xx_wrapper
{
    struct i2c_manager          i2c_mgr;
    struct stk_data             stk;
    bool                        is_update;
    struct input_dev*           input_dev_accel;   /* accel data */
#ifdef STK_AMD
    struct input_dev*           input_dev_amd;     /* any motion data */
#endif /* STK_AMD */
struct class* sensor_class;
} stk83xx_wrapper;

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

char driver_ver[20] = STR(STK83XX_MAJOR) "." STR(STK83XX_MINOR) "." STR(STK83XX_REV);

stk83xx_wrapper *stk_wrapper;

static struct stk83xx_platform_data stk_plat_data =
{
    .direction              = 1,
    .interrupt_int1_pin     = 117,
};

/****************************************************************************************************
* Accel control API
****************************************************************************************************/
void stk_report_accel_data(struct stk_data* stk)
{
    stk_wrapper->is_update = true;
}

/****************************************************************************************************
* System Init. API
****************************************************************************************************/

static int stk_parse_dt(struct device *dev,
                        struct stk83xx_platform_data *pdata)
{
    struct device_node *np = dev->of_node;
    const int32_t *p;
    uint32_t int_flags;
    p = of_get_property(np, "stk,direction", NULL);
            
    if (p)
        pdata->direction = be32_to_cpu(*p);

    pdata->interrupt_int1_pin = of_get_named_gpio_flags(np,
                                "stk83xx,irq-gpio", 0, &int_flags);
    if (pdata->interrupt_int1_pin < 0)
    {
        STK_ERR("Unable to read stk83xx,irq-gpio");
#ifdef STK_INTERRUPT_MODE
        return pdata->interrupt_int1_pin;
#else /* no STK_INTERRUPT_MODE */
        return 0;
#endif /* STK_INTERRUPT_MODE */
    }
    
    of_property_read_u32(np, "default_slope_threshold", &(pdata->default_slope_threshold));
    return 0; /* SUCCESS */
}

static int sensor_active(struct i2c_client *client, int enable, int rate)
{
    if (enable)
    {
        stk83xx_set_enable(&stk_wrapper->stk, 1);
    }
    else
    {
        stk83xx_set_enable(&stk_wrapper->stk, 0);
    }

    STK_LOG("stk83xx enable = %d", enable);
    return 0;
}

static int32_t get_platform_data(stk83xx_wrapper* stk_wrapper)
{
    int32_t err = 0;
    struct stk_data *stk = &stk_wrapper->stk;
    struct i2c_client *client = stk_wrapper->i2c_mgr.client;
    struct stk83xx_platform_data *stk_platdata;

    if (client->dev.of_node)
    {
        STK_FUN();
        stk_platdata = devm_kzalloc(&client->dev,
                                    sizeof(struct stk83xx_platform_data), GFP_KERNEL);

        if (!stk_platdata)
        {
            STK_ERR("Failed to allocate memory");
            return -ENOMEM;
        }

        err = stk_parse_dt(&client->dev, stk_platdata);

        if (err)
        {
            STK_ERR("stk_parse_dt err=%d", err);
            return err;
        }
    }
    else
    {
        if (NULL != client->dev.platform_data)
        {
            STK_ERR("probe with platform data");
            stk_platdata = client->dev.platform_data;
        }
        else
        {
            STK_ERR("probe with private platform data");
            stk_platdata = &stk_plat_data;
        }
    }

#ifdef STK_INTERRUPT_MODE
    stk->gpio_info.int_pin = stk_platdata->interrupt_int1_pin;
#endif /* STK_INTERRUPT_MODE */
    stk->direction = stk_platdata->direction;
    stk->slope_threshold = stk_platdata->default_slope_threshold>0xff?0xff:stk_platdata->default_slope_threshold;
    return 0;
}

static int32_t stk_input_setup(stk83xx_wrapper *stk_wrapper)
{
    int32_t err = 0;
    /* input device: setup for accel */
    stk_wrapper->input_dev_accel = input_allocate_device();

    if (!stk_wrapper->input_dev_accel)
    {
        STK_ERR("input_allocate_device for accel failed");
        return -ENOMEM;
    }

    stk_wrapper->input_dev_accel->name = "stk83xx";
    stk_wrapper->input_dev_accel->id.bustype = BUS_I2C;
    input_set_capability(stk_wrapper->input_dev_accel, EV_ABS, ABS_MISC);
    input_set_abs_params(stk_wrapper->input_dev_accel, ABS_X, 32767, -32768, 0, 0);
    input_set_abs_params(stk_wrapper->input_dev_accel, ABS_Y, 32767, -32768, 0, 0);
    input_set_abs_params(stk_wrapper->input_dev_accel, ABS_Z, 32767, -32768, 0, 0);
    stk_wrapper->input_dev_accel->dev.parent = &stk_wrapper->i2c_mgr.client->dev;
    input_set_drvdata(stk_wrapper->input_dev_accel, stk_wrapper);
    err = input_register_device(stk_wrapper->input_dev_accel);

    if (err)
    {
        STK_ERR("Unable to register input device: %s", stk_wrapper->input_dev_accel->name);
        input_free_device(stk_wrapper->input_dev_accel);
        return err;
    }

#ifdef STK_AMD
    /* input device: setup for any motion */
    stk_wrapper->input_dev_amd = input_allocate_device();

    if (!stk_wrapper->input_dev_amd)
    {
        STK_ERR("input_allocate_device for ANY MOTION failed");
        input_free_device(stk_wrapper->input_dev_accel);
        input_unregister_device(stk_wrapper->input_dev_accel);
        return -ENOMEM;
    }

    stk_wrapper->input_dev_amd->name = "any motion";
    stk_wrapper->input_dev_amd->id.bustype = BUS_I2C;
    input_set_capability(stk_wrapper->input_dev_amd, EV_ABS, ABS_MISC);
    stk_wrapper->input_dev_amd->dev.parent = &stk_wrapper->i2c_mgr->client->dev;
    input_set_drvdata(stk_wrapper->input_dev_amd, stk_wrapper);
    err = input_register_device(stk_wrapper->input_dev_amd);

    if (err)
    {
        STK_ERR("Unable to register input device: %s",
                stk_wrapper->input_dev_amd->name);
        input_free_device(stk_wrapper->input_dev_amd);
        input_free_device(stk_wrapper->input_dev_accel);
        input_unregister_device(stk_wrapper->input_dev_accel);
        return err;
    }

#endif /* STK_AMD */
    return 0;
}

static ssize_t slope_threshold_show(struct class *class,
        struct class_attribute *attr, char *buf)
{
    return sprintf(buf, "%u", stk_wrapper->stk.slope_threshold);
}

static ssize_t slope_threshold_store(struct class *class,
        struct class_attribute *attr, const char *buf, size_t count)
{
    int ret = 0, val = 0;
    ret = kstrtoint(buf, 10, &val);
    if (ret) {
        STK_ERR("%s: kstrtoint error return %d\n", __func__, ret);
        return -1;
    }
    val = val>255?255:val;
    if (val == stk_wrapper->stk.slope_threshold)
        return 0;
    ret = stk83xx_set_slope_threshold(&(stk_wrapper->stk), stk_wrapper->stk.slope_threshold);
    if (!ret)
        stk_wrapper->stk.slope_threshold = val;
    return ret?ret:count;
}

static ssize_t isr_print_enable_show(struct class *class,
        struct class_attribute *attr, char *buf)
{
    return sprintf(buf, "%u", stk_wrapper->stk.isr_print_enable);
}

static ssize_t isr_print_enable_store(struct class *class,
        struct class_attribute *attr, const char *buf, size_t count)
{
    int ret = 0, val = 0;
    ret = kstrtoint(buf, 10, &val);
    if (ret) {
        STK_ERR("%s: kstrtoint error return %d\n", __func__, ret);
        return -1;
    }
    stk_wrapper->stk.isr_print_enable = val==0?val:1;
    return ret?ret:count;
}

static CLASS_ATTR_RW(slope_threshold);
static CLASS_ATTR_RW(isr_print_enable);
static int sensor_class_init(struct stk83xx_wrapper *stk_wrapper)
{
    int ret = 0;
    stk_wrapper->sensor_class = class_create(THIS_MODULE, "acc_stk83xx");
    if (!stk_wrapper->sensor_class) {
        STK_ERR("failed to create stk_class");
        return -ENOMEM;
    }
    ret = class_create_file(stk_wrapper->sensor_class, &class_attr_slope_threshold);                                                                
    if (ret) {
        STK_ERR("%s:Fail to creat slope_threshold file\n", __func__);
        return ret;
    }

    ret = class_create_file(stk_wrapper->sensor_class, &class_attr_isr_print_enable);
    if (ret) {
        STK_ERR("%s:Fail to creat isr_print_enable file\n", __func__);
        return ret;
    }
    return ret;
}

static int sensor_init(struct i2c_client *client)
{
    int err = 0;
    stk_data *stk;
    struct sensor_private_data *sensor =
        (struct sensor_private_data *)i2c_get_clientdata(client);
    STK_LOG("STK83XX_VERSION : %d.%d.%d", STK83XX_MAJOR,
            STK83XX_MINOR,
            STK83XX_REV);
    stk_wrapper = kzalloc(sizeof(struct stk83xx_wrapper), GFP_KERNEL);
    if (!stk_wrapper)
    {
        STK_ERR("failed to allocate stk83xx_wrapper");
        return -ENOMEM;
    }
    stk = &stk_wrapper->stk;

    if (!stk)
    {
        STK_ERR("failed to allocate stk_data");
        return -ENOMEM;
    }
    err = sensor_class_init(stk_wrapper);
    if (err<0)
        goto err_free_mem;
    stk_wrapper->i2c_mgr.client = client;
    stk_wrapper->i2c_mgr.addr_type = ADDR_8BIT;
    stk->bops   = &stk_i2c_bops;
    stk->tops   = &stk_t_ops;
    stk->accel_report_cb = stk_report_accel_data;
    // i2c_set_clientdata(client, stk_wrapper);
    mutex_init(&stk_wrapper->i2c_mgr.lock);
    stk->bus_idx = stk->bops->init(&stk_wrapper->i2c_mgr);

    if (stk->bus_idx < 0)
    {
        goto err_free_mem;
    }

    if (get_platform_data(stk_wrapper))
        goto err_free_mem;

    err = stk83xx_check_pid(stk);

    if (err < 0)
        goto err_free_mem;

    STK_LOG("PID 0x%x", stk->pid);
    stk83xx_data_initialize(stk);
    stk83xx_register_queue(stk);
#if defined(STK_WEAKEUP_SYSTEM_BY_IRQ)
    stk83xx_register_wakeup_system(client, stk);
#endif
    if (stk83xx_reg_init(stk, STK83XX_RANGESEL_DEF, stk->sr_no))
    {
        STK_ERR("stk83xx initialization failed");
        goto err_exit;
    }
#if defined(STK_WEAKEUP_SYSTEM_BY_IRQ)
    stk83xx_enable_anymotion(stk, 1);
#endif
    sensor->status_cur = SENSOR_OFF;

    if (stk_input_setup(stk_wrapper))
    {
        goto err_exit;
    }

    STK_LOG("probe successfully");
    return 0;
err_exit:
#ifdef STK_INTERRUPT_MODE
    STK_GPIO_IRQ_REMOVE(stk, &stk->gpio_info);
#elif defined STK_POLLING_MODE
    STK_TIMER_REMOVE(stk, &stk->stk_timer_info);
#endif /* STK_BARO_DRI, STK_POLLING_MODE */
err_free_mem:
    stk->bops->remove(&stk_wrapper->i2c_mgr);
    mutex_destroy(&stk_wrapper->i2c_mgr.lock);
    kfree(stk_wrapper);
    return err;
}

static int gsensor_report_value(struct i2c_client *client, struct sensor_axis *axis)
{
    struct sensor_private_data *sensor =
        (struct sensor_private_data *)i2c_get_clientdata(client);

    if (stk_wrapper->is_update)
    {
        stk_wrapper->is_update = false;
        /* Report acceleration sensor information */
        input_report_abs(sensor->input_dev, ABS_X, axis->x);
        input_report_abs(sensor->input_dev, ABS_Y, axis->y);
        input_report_abs(sensor->input_dev, ABS_Z, axis->z);
        input_sync(sensor->input_dev);
        STK_DBG("stk83xx x=%d  y=%d z=%d\n", axis->x, axis->y, axis->z);
    }

    return 0;
}

static int sensor_report_value(struct i2c_client *client)
{
    struct sensor_private_data *sensor =
        (struct sensor_private_data *) i2c_get_clientdata(client);
    struct sensor_platform_data *pdata = sensor->pdata;
    int ret = 0;
    struct sensor_axis axis;
    stk83xx_work_queue(&stk_wrapper->stk);
    axis.x = (pdata->orientation[0]) * stk_wrapper->stk.xyz[0] + (pdata->orientation[1]) * stk_wrapper->stk.xyz[1] + (pdata->orientation[2]) * stk_wrapper->stk.xyz[2];
    axis.y = (pdata->orientation[3]) * stk_wrapper->stk.xyz[0] + (pdata->orientation[4]) * stk_wrapper->stk.xyz[1] + (pdata->orientation[5]) * stk_wrapper->stk.xyz[2];
    axis.z = (pdata->orientation[6]) * stk_wrapper->stk.xyz[0] + (pdata->orientation[7]) * stk_wrapper->stk.xyz[1] + (pdata->orientation[8]) * stk_wrapper->stk.xyz[2];
    gsensor_report_value(client, &axis);
    mutex_lock(&(sensor->data_mutex));
    sensor->axis = axis;
    mutex_unlock(&(sensor->data_mutex));
    return ret;
}
static int sensor_suspend(struct i2c_client *client)
{
    if (mem_sleep_current != PM_SUSPEND_MEM_ULTRA)
        return 0;

    return 0;
}

static int sensor_resume(struct i2c_client *client)
{
    stk_data *stk = &stk_wrapper->stk;
    if (mem_sleep_current != PM_SUSPEND_MEM_ULTRA)
        return 0;
    if (stk83xx_check_pid(stk) < 0) {
        STK_ERR("stk83xx check pid failed");
        return -1;
    }
    if (stk83xx_reg_init(stk, STK83XX_RANGESEL_DEF, stk->sr_no))
    {
        STK_ERR("stk83xx initialization failed");
        return -1;
    }
#if defined(STK_WEAKEUP_SYSTEM_BY_IRQ)
    stk83xx_enable_anymotion(stk, 1);
#endif
    sensor_active(client, 1, 0);
    return 0;
}
static struct sensor_operate gsensor_stk83xx_ops =
{
    .name			= "stk83xx",
    .type			= SENSOR_TYPE_ACCEL,
    .id_i2c			= ACCEL_ID_STK83XX,
    .read_reg		= STK83XX_REG_XOUT1,
    .read_len		= 6,
    .id_reg			= SENSOR_UNKNOW_DATA,
    .id_data		= SENSOR_UNKNOW_DATA,
    .precision		= 12,
    .ctrl_reg		= STK83XX_REG_POWMODE,
    .int_status_reg	= STK83XX_REG_INTSTS2,
    .range			= {-32768, 32768},
    .trig			= IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
    .active			= sensor_active,
    .init			= sensor_init,
    .report			= sensor_report_value,
    .suspend = sensor_suspend,
    .resume = sensor_resume,
};

static int gsensor_stk83xx_probe(struct i2c_client *client,
                                 const struct i2c_device_id *devid)
{
    return sensor_register_device(client, NULL, devid, &gsensor_stk83xx_ops);
}

static int gsensor_stk83xx_remove(struct i2c_client *client)
{
    return sensor_unregister_device(client, NULL, &gsensor_stk83xx_ops);
}

static const struct i2c_device_id gsensor_stk83xx_id[] =
{
    { "stk83xx",  ACCEL_ID_STK83XX},
    {}
};

MODULE_DEVICE_TABLE(i2c, gsensor_stk83xx_id);

static const struct of_device_id stk83xx_of_match[] = {
	{.compatible = "sensortek,stk83xx",},
	{ },
};

MODULE_DEVICE_TABLE(of, stk83xx_of_match);

static struct i2c_driver gsensor_stk83xx_driver =
{
    .probe = gsensor_stk83xx_probe,
    .remove = gsensor_stk83xx_remove,
    .shutdown = sensor_shutdown,
    .id_table = gsensor_stk83xx_id,
    .driver = {
        .name = "stk83xx",
        .of_match_table = stk83xx_of_match,
#ifdef CONFIG_PM
        .pm = &sensor_pm_ops,
#endif
    },
};

module_i2c_driver(gsensor_stk83xx_driver);

MODULE_AUTHOR("sensortek");
MODULE_DESCRIPTION("stk83xx 3-Axis accelerometer driver");
MODULE_LICENSE("GPL");
