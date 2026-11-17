#include <linux/input.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/types.h>
#include <linux/pm.h>
#include <linux/errno.h>
#include "common_define.h"

#ifdef STK_BUS_I2C
    #include <linux/i2c.h>
#endif

//Timer
#include <linux/delay.h>
#include <linux/pm_wakeup.h>

#ifdef STK_BUS_I2C
#define MAX_I2C_MANAGER_NUM     5

struct i2c_manager *pi2c_mgr[MAX_I2C_MANAGER_NUM] = {NULL};

int i2c_init(void* st)
{
    int i2c_idx = 0;

    if (!st)
    {
        return -1;
    }

    for (i2c_idx = 0; i2c_idx < MAX_I2C_MANAGER_NUM; i2c_idx ++)
    {
        if (pi2c_mgr[i2c_idx] == (struct i2c_manager*)st)
        {
            printk(KERN_INFO "%s: i2c is exist\n", __func__);
            return i2c_idx;
        }
        else if (pi2c_mgr[i2c_idx] == NULL)
        {
            pi2c_mgr[i2c_idx] = (struct i2c_manager*)st;
            return i2c_idx;
        }
    }

    return -1;
}

int i2c_reg_read(int i2c_idx, unsigned int reg, unsigned char *val)
{
    int error = 0;
    struct i2c_manager *_pi2c = pi2c_mgr[i2c_idx];
    I2C_REG_ADDR_TYPE addr_type = _pi2c->addr_type;
    mutex_lock(&_pi2c->lock);

    if (addr_type == ADDR_8BIT)
    {
        unsigned char reg_ = (unsigned char)(reg & 0xFF);
        error = i2c_smbus_read_byte_data(_pi2c->client, reg_);

        if (error < 0)
        {
            dev_err(&_pi2c->client->dev,
                    "%s: failed to read reg:0x%x\n",
                    __func__, reg);
        }
        else
        {
            *(unsigned char *)val = error & 0xFF;
        }
    }
    else if (addr_type == ADDR_16BIT)
    {
    }

    mutex_unlock(&_pi2c->lock);
    return error;
}

int i2c_reg_write(int i2c_idx, unsigned int reg, unsigned char val)
{
    int error = 0;
    struct i2c_manager *_pi2c = pi2c_mgr[i2c_idx];
    I2C_REG_ADDR_TYPE addr_type = _pi2c->addr_type;
    mutex_lock(&_pi2c->lock);

    if (addr_type == ADDR_8BIT)
    {
        unsigned char reg_ = (unsigned char)(reg & 0xFF);
        error = i2c_smbus_write_byte_data(_pi2c->client, reg_, val);
    }
    else if (addr_type == ADDR_16BIT)
    {
    }

    mutex_unlock(&_pi2c->lock);

    if (error < 0)
    {
        dev_err(&_pi2c->client->dev,
                "%s: failed to write reg:0x%x with val:0x%x\n",
                __func__, reg, val);
    }

    return error;
}

int i2c_reg_write_block(int i2c_idx, unsigned int reg, void *val, int length)
{
    int error = 0;
    struct i2c_manager *_pi2c = pi2c_mgr[i2c_idx];
    I2C_REG_ADDR_TYPE addr_type = _pi2c->addr_type;
    mutex_lock(&_pi2c->lock);

    if (addr_type == ADDR_8BIT)
    {
        unsigned char reg_ = (unsigned char)(reg & 0xFF);
        error = i2c_smbus_write_i2c_block_data(_pi2c->client, reg_, length, val);
    }
    else if (addr_type == ADDR_16BIT)
    {
        int i = 0;
        unsigned char *buffer_inverse;
        struct i2c_msg msgs;
        buffer_inverse = kzalloc((sizeof(unsigned char) * (length + 2)), GFP_KERNEL);
        buffer_inverse[0] = reg >> 8;
        buffer_inverse[1] = reg & 0xff;

        for (i = 0; i < length; i ++)
        {
            buffer_inverse[2 + i] = *(u8*)((u8*)val + ((length - 1) - i));
        }

        msgs.addr = _pi2c->client->addr;
        msgs.flags = _pi2c->client->flags & I2C_M_TEN;
        msgs.len = length + 2;
        msgs.buf = buffer_inverse;
#ifdef STK_RETRY_I2C
        i = 0;

        do
        {
            error = i2c_transfer(_pi2c->client->adapter, &msgs, 1);
        }
        while (error != 1 && ++i < 3);

#else
        error = i2c_transfer(_pi2c->client->adapter, &msgs, 1);
#endif //  STK_RETRY_I2C
        kfree(buffer_inverse);
    }

    mutex_unlock(&_pi2c->lock);

    if (error < 0)
    {
        dev_err(&_pi2c->client->dev,
                "%s: failed to write reg:0x%x\n",
                __func__, reg);
    }

    return error;
}

int i2c_reg_read_modify_write(int i2c_idx, unsigned int reg, unsigned char val, unsigned char mask)
{
    uint8_t rw_buffer = 0;
    int error = 0;
    struct i2c_manager *_pi2c = pi2c_mgr[i2c_idx];

    if ((mask == 0xFF) || (mask == 0x0))
    {
        error = i2c_reg_write(i2c_idx, reg, val);

        if (error < 0)
        {
            dev_err(&_pi2c->client->dev,
                    "%s: failed to write reg:0x%x with val:0x%x\n",
                    __func__, reg, val);
        }
    }
    else
    {
        error = (uint8_t)i2c_reg_read(i2c_idx, reg, &rw_buffer);

        if (error < 0)
        {
            dev_err(&_pi2c->client->dev,
                    "%s: failed to read reg:0x%x\n",
                    __func__, reg);
            return error;
        }
        else
        {
            rw_buffer = (rw_buffer & (~mask)) | (val & mask);
            error = i2c_reg_write(i2c_idx, reg, rw_buffer);

            if (error < 0)
            {
                dev_err(&_pi2c->client->dev,
                        "%s: failed to write reg(mask):0x%x with val:0x%x\n",
                        __func__, reg, val);
            }
        }
    }

    return error;
}

int i2c_reg_read_block(int i2c_idx, unsigned int reg, int count, void *buf)
{
    int ret = 0;
    // int loop_cnt = 0;
    struct i2c_manager *_pi2c = pi2c_mgr[i2c_idx];
    I2C_REG_ADDR_TYPE addr_type = _pi2c->addr_type;
    mutex_lock(&_pi2c->lock);

    if (addr_type == ADDR_8BIT)
    {
        struct i2c_msg msgs[2] =
        {
            {
                .addr = _pi2c->client->addr,
                .flags = 0,
                .len = 1,
                .buf = (u8*)&reg
            },
            {
                .addr = _pi2c->client->addr,
                .flags = I2C_M_RD,
                .len = count,
                .buf = buf
            }
        };
        ret = i2c_transfer(_pi2c->client->adapter, msgs, 2);

        if (2 == ret)
        {
            ret = 0;
        }

        // unsigned char reg_ = (unsigned char)(reg & 0xFF);
        // while (count)
        // {
        //     ret = i2c_smbus_read_i2c_block_data(_pi2c->client, reg_,
        //                                         (count > I2C_SMBUS_BLOCK_MAX) ? I2C_SMBUS_BLOCK_MAX : count,
        //                                         (buf + (loop_cnt * I2C_SMBUS_BLOCK_MAX))
        //                                        );
        //     (count > I2C_SMBUS_BLOCK_MAX) ? (count -= I2C_SMBUS_BLOCK_MAX) : (count -= count);
        //     loop_cnt ++;
        // }
    }
    else if (addr_type == ADDR_16BIT)
    {
        int i = 0;
        u16 reg_inverse = (reg & 0x00FF) << 8 | (reg & 0xFF00) >> 8;
        int read_length = count;
        u8 buffer_inverse[99] = { 0 };
        struct i2c_msg msgs[2] =
        {
            {
                .addr = _pi2c->client->addr,
                .flags = 0,
                .len = 2,
                .buf = (u8*)&reg_inverse
            },
            {
                .addr = _pi2c->client->addr,
                .flags = I2C_M_RD,
                .len = read_length,
                .buf = buffer_inverse
            }
        };
#ifdef STK_RETRY_I2C
        i = 0;

        do
        {
            ret = i2c_transfer(_pi2c->client->adapter, msgs, 2);
        }
        while (ret != 2 && ++i < 3);

#else
        ret = i2c_transfer(_pi2c->client->adapter, msgs, 2);
#endif //  STK_RETRY_I2C

        if (2 == ret)
        {
            ret = 0;

            for (i = 0; i < read_length; i ++)
            {
                *(u8*)((u8*)buf + i) = ((buffer_inverse[read_length - 1 - i]));
            }
        }
    }

    mutex_unlock(&_pi2c->lock);
    return ret;
}

int i2c_remove(void* st)
{
    int i2c_idx = 0;

    if (!st)
    {
        return -1;
    }

    for (i2c_idx = 0; i2c_idx < MAX_I2C_MANAGER_NUM; i2c_idx ++)
    {
        printk(KERN_INFO "%s: i2c_idx = %d\n", __func__, i2c_idx);

        if (pi2c_mgr[i2c_idx] == (struct i2c_manager*)st)
        {
            printk(KERN_INFO "%s: release i2c_idx = %d\n", __func__, i2c_idx);
            pi2c_mgr[i2c_idx] = NULL;
            break;
        }
    }

    return 0;
}

const struct stk_bus_ops stk_i2c_bops =
{
    .bustype            = BUS_I2C,
    .init               = i2c_init,
    .write              = i2c_reg_write,
    .write_block        = i2c_reg_write_block,
    .read               = i2c_reg_read,
    .read_block         = i2c_reg_read_block,
    .read_modify_write  = i2c_reg_read_modify_write,
    .remove             = i2c_remove,
};
#endif

#ifdef STK_BUS_SPI

#define MAX_SPI_MANAGER_NUM     5

struct spi_manager *pspi_mgr[MAX_SPI_MANAGER_NUM] = {NULL};

/*
 * stk8xxx register write
 * @brief: Register writing via SPI
 *
 * @param[in/out] stk: struct stk_data *
 * @param[in] reg: Register address
 * @param[in] val: Data, what you want to write.
 *
 * @return: Success or fail
 *          0: Success
 *          others: Fail
 */
static int stk_spi_write(struct spi_manager *stk)
{
    int err = 0;
    struct spi_message	m;
    struct spi_transfer	t =
    {
        .tx_buf = stk->spi_buffer,
        .rx_buf = stk->spi_buffer,
        .len = 2,
        .speed_hz = stk->spi->max_speed_hz,
        .delay_usecs = 5,
    };
    mutex_lock(&stk->lock);
    spi_message_init(&m);
    spi_message_add_tail(&t, &m);
    err = spi_sync(stk->spi, &m);
    mutex_unlock(&stk->lock);
    return err;
}

/*
 * stk8xxx register read
 * @brief: Register reading via SPI
 *
 * @param[in/out] stk: struct stk_data *
 * @param[in] reg: Register address
 * @param[in] len: 0, for normal usage. Others, read length (FIFO used).
 * @param[out] val: Data, the register what you want to read.
 *
 * @return: Success or fail
 *          0: Success
 *          others: Fail
 */
static int stk_spi_read(struct spi_manager *stk, int len, unsigned char*val)
{
    struct spi_message	m;
    struct spi_transfer	t =
    {
        .tx_buf = stk->spi_buffer,
        .rx_buf = stk->spi_buffer,
        .len = 1 + len,
        .speed_hz = stk->spi->max_speed_hz,
        .delay_usecs = 5,
    };
    mutex_lock(&stk->lock);
    spi_message_init(&m);
    spi_message_add_tail(&t, &m);
    spi_sync(stk->spi, &m);
    memcpy(val, stk->spi_buffer + 1, len);
    mutex_unlock(&stk->lock);
    return 0;
}

int spi_init(void* st)
{
    int spi_idx = 0;

    if (!st)
    {
        return -1;
    }

    for (spi_idx = 0; spi_idx < MAX_SPI_MANAGER_NUM; spi_idx ++)
    {
        if (pspi_mgr[spi_idx] == (struct spi_manager*)st)
        {
            printk(KERN_INFO "%s: spi is exist\n", __func__);
            return spi_idx;
        }
        else if (pspi_mgr[spi_idx] == NULL)
        {
            pspi_mgr[spi_idx] = (struct spi_manager*)st;
            return spi_idx;
        }
    }

    return -1;
}

int spi_reg_read(int spi_idx, unsigned int reg, unsigned char* val)
{
    int error = 0;
    struct spi_manager* _pspi = pspi_mgr[spi_idx];
    memset(_pspi->spi_buffer, 0, 2);
    *_pspi->spi_buffer = (u8)(reg & 0xFF) | 0x80;
    error = stk_spi_read(_pspi, 1, val);
    return error;
}

int spi_reg_write(int spi_idx, unsigned int reg, unsigned char val)
{
    int error = 0;
    struct spi_manager *_pspi = pspi_mgr[spi_idx];
    unsigned char reg_ = (unsigned char)(reg & 0xFF);
    memset(_pspi->spi_buffer, 0, 2);
    *_pspi->spi_buffer = reg_;
    *(_pspi->spi_buffer + 1) = val;
    error = stk_spi_write(_pspi);
    return error;
}

int spi_reg_write_block(int spi_idx, unsigned int reg, void *val, int length)
{
    int error = 0;
    return error;
}

int spi_reg_read_modify_write(int spi_idx, unsigned int reg, unsigned char val, unsigned char mask)
{
    uint8_t rw_buffer = 0;
    int error = 0;
    struct spi_manager *_pspi = pspi_mgr[spi_idx];

    if ((mask == 0xFF) || (mask == 0x0))
    {
        error = spi_reg_write(spi_idx, reg, val);

        if (error < 0)
        {
            dev_err(&_pspi->spi->dev,
                    "%s: failed to write reg:0x%x with val:0x%x\n",
                    __func__, reg, val);
        }
    }
    else
    {
        rw_buffer = (uint8_t)spi_reg_read(spi_idx, reg, &val);

        if (rw_buffer < 0)
        {
            dev_err(&_pspi->spi->dev,
                    "%s: failed to read reg:0x%x\n",
                    __func__, reg);
            return rw_buffer;
        }
        else
        {
            rw_buffer = (rw_buffer & (~mask)) | (val & mask);
            error = spi_reg_write(spi_idx, reg, rw_buffer);

            if (error < 0)
            {
                dev_err(&_pspi->spi->dev,
                        "%s: failed to write reg(mask):0x%x with val:0x%x\n",
                        __func__, reg, val);
            }
        }
    }

    return error;
}

int spi_reg_read_block(int spi_idx, unsigned int reg, int count, void *buf)
{
    int error = 0;
    struct spi_manager *_pspi = pspi_mgr[spi_idx];
    memset(_pspi->spi_buffer, 0, 1 + count);
    *_pspi->spi_buffer = (u8)(reg & 0xFF) | 0x80;
    error = stk_spi_read(_pspi, count, buf);
    return error;
}

int spi_remove(void* st)
{
    int spi_idx = 0;

    if (!st)
    {
        return -1;
    }

    for (spi_idx = 0; spi_idx < MAX_SPI_MANAGER_NUM; spi_idx ++)
    {
        printk(KERN_INFO "%s: spi_idx = %d\n", __func__, spi_idx);

        if (pspi_mgr[spi_idx] == (struct spi_manager*)st)
        {
            printk(KERN_INFO "%s: release spi_idx = %d\n", __func__, spi_idx);
            pspi_mgr[spi_idx] = NULL;
            break;
        }
    }

    return 0;
}

/* Bus operations */
const struct stk_bus_ops stk_spi_bops =
{
    .bustype            = BUS_SPI,
    .init               = spi_init,
    .write              = spi_reg_write,
    .write_block        = spi_reg_write_block,
    .read               = spi_reg_read,
    .read_block         = spi_reg_read_block,
    .read_modify_write  = spi_reg_read_modify_write,
    .remove             = spi_remove,
};
#endif

void busy_wait(unsigned long delay, BUSY_WAIT_TYPE mode)
{
    if ((!delay))
    {
        return;
    }

    if (mode == US_DELAY)
    {
        msleep(delay / 1000);
    }

    if (mode == MS_DELAY)
    {
        msleep(delay);
    }
}
const struct stk_timer_ops stk_t_ops =
{
    .register_timer         = NULL,
    .start_timer            = NULL,
    .stop_timer             = NULL,
    .remove                 = NULL,
    .busy_wait              = busy_wait,
};

int64_t stk_pow(int64_t base, int32_t exp)
{
    int64_t result = 1;

    while (exp)
    {
        if (exp & 1)
            result *= base;

        exp >>= 1;
        base *= base;
    }

    return result;
}

int stk_log_cal(uint8_t value, uint8_t base)
{
    int sqrtCounter = 0;

    if (value <= 1)
        return 0;

    while (value > 1)
    {
        value = value >> base;
        sqrtCounter++;
    }

    return sqrtCounter;
}