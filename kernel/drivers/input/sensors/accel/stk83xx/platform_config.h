#ifndef __PLATFORM_CONFIG_H__
#define __PLATFORM_CONFIG_H__

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
#ifdef CONFIG_HAS_EARLYSUSPEND
    #include <linux/earlysuspend.h>
#endif
#include <linux/suspend.h>
#include <linux/sensor-dev.h>

typedef enum
{
    ADDR_8BIT,
    ADDR_16BIT,
} I2C_REG_ADDR_TYPE;

typedef enum
{
    SPI_MODE0,
    SPI_MODE1,
    SPI_MODE2,
    SPI_MODE3,
} SPI_TRANSFER_MODE;

struct spi_manager
{
    struct spi_device *spi;
    struct mutex lock;
    SPI_TRANSFER_MODE trans_mode;
    void *any;
    u8 *spi_buffer;        /* SPI buffer, used for SPI transfer. */
} ;

struct i2c_manager
{
    struct i2c_client *client;
    struct mutex lock;
    I2C_REG_ADDR_TYPE addr_type;
    void *any;
} ;

#define kzalloc(size, mode) kzalloc(size, mode)
#define kfree(ptr) kfree(ptr)
#define strcpy(dest,src)  strncpy(dest, src,  (strlen(src) + 1))

extern const struct stk_bus_ops stk_spi_bops;
extern const struct stk_bus_ops stk_i2c_bops;
extern const struct stk_timer_ops stk_t_ops;
extern const struct stk_gpio_ops stk_g_ops;

#endif // __PLATFORM_CONFIG_H__
