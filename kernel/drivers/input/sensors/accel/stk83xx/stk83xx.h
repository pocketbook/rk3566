#ifndef __STK83XX_H__
#define __STK83XX_H__

#include "common_define.h"
#include "stk83xx_config.h"
#include "stk83xx_ver.h"
#define STK_POLLING_TIME                    100000//us

/*****************************************************************************
 * Global variable
 *****************************************************************************/
/* Any motion only works under either STK_INTERRUPT_MODE or STK_POLLING_MODE */
#ifdef STK_AMD
    #if !defined STK_INTERRUPT_MODE && !defined STK_POLLING_MODE
        #undef STK_AMD
    #endif /* !defined STK_INTERRUPT_MODE && !defined STK_POLLING_MODE*/
#endif /* STK_AMD */

#ifdef STK_AUTO_K
    #define STK_SPEC_X_OFFSEET       300             // ex: 600=600mg
    #define STK_SPEC_Y_OFFSEET       300             // ex: 600=600mg
    #define STK_SPEC_Z_OFFSEET       500             // ex: 600=600mg
    #define STK_SPEC_MAX_MIN_DEF     50              // ex: 50 = 50mg
#endif // STK_AUTO_K

#if defined(STK_FIR) || defined(STK_AUTO_K)
#define STK_DATA_LOG_LEN         5
#define STK_DATA_LOG_LEN_MAX     32
struct data_log
{
    int16_t xyz[3][STK_DATA_LOG_LEN_MAX];
    int32_t sum[3];
    uint32_t idx;
    uint16_t count;
};
#endif /* STK_FIR */

#if (defined STK_FIR && defined STK_ZG)
    #define ZG_FACTOR   0
#endif /* defined STK_FIR && defined STK_ZG */

#ifndef GRAVITY_EARTH_1000
    #define GRAVITY_EARTH_1000 9.876
#endif // !GRAVITY_EARTH_1000

#ifdef STK_AXES_SIM
typedef enum
{
    /* 12 bits per axis */
    STK_MAX_12BIT = 2047, //0x7FF
    STK_MIN_12BIT = -2048,//0x800
    STK_MAX_8G_12BIT = 1432, //70%
    STK_MIN_8G_12BIT = -1433, //70%
    /* 16 bits per axis */
    STK_MAX_16BIT = 32767,
    STK_MIN_16BIT = -32768,
    STK_MAX_8G_16BIT = 22936, //70%
    STK_MIN_8G_16BIT = -22937 //70%
} stk_bit_value;

typedef enum
{
    STK_NO_SIM = 0,
    STK_X_SIM = 0x1,
    STK_Y_SIM = 0x2,
    STK_Z_SIM = 0x4,
    STK_Z_SIM_ALWAYS = 0x8,
} stk_sim_state;

typedef enum
{
    STK_12BIT_DATA = 0,
    STK_16BIT_DATA = 1
} stk_bit_data;

//mapping register
typedef enum
{
    STK_SIM_RANGE_2G = 0x03,
    STK_SIM_RANGE_4G = 0x05,
    STK_SIM_RANGE_8G = 0x08,
    STK_SIM_RANGE_16G = 0x0C
} stk_sim_range;
#endif // STK_AXES_SIM

/*****************************************************************************
 * stk83xx register, start
 *****************************************************************************/
#define STK83XX_REG_CHIPID          0x00
#define STK83XX_REG_XOUT1           0x02
#define STK83XX_REG_XOUT2           0x03
#define STK83XX_REG_YOUT1           0x04
#define STK83XX_REG_YOUT2           0x05
#define STK83XX_REG_ZOUT1           0x06
#define STK83XX_REG_ZOUT2           0x07
#define STK83XX_REG_INTSTS1         0x09
#define STK83XX_REG_INTSTS2         0x0A
#define STK83XX_REG_FIFOSTS         0x0C
#define STK83XX_REG_STEPOUT1        0x0D
#define STK83XX_REG_STEPOUT2        0x0E
#define STK83XX_REG_RANGESEL        0x0F
#define STK83XX_REG_BWSEL           0x10
#define STK83XX_REG_POWMODE         0x11
#define STK83XX_REG_ODRMODE         0x12
#define STK83XX_REG_SWRST           0x14
#define STK83XX_REG_INTEN1          0x16
#define STK83XX_REG_INTEN2          0x17
#define STK83XX_REG_INTMAP3         0x18
#define STK83XX_REG_INTMAP1         0x19
#define STK83XX_REG_INTMAP2         0x1A
#define STK83XX_REG_SIXDCFG         0x1B
#define STK83XX_REG_SIXDTHD         0x1C
#define STK83XX_REG_SIXDSTS         0x1D
#define STK83XX_REG_SIXDDLY         0x1E
#define STK83XX_REG_INTCFG1         0x20
#define STK83XX_REG_INTCFG2         0x21
#define STK83XX_REG_TILTTHD         0x23
#define STK83XX_REG_TILTPOW         0x24
#define STK83XX_REG_TILTCFG         0x25
#define STK83XX_REG_SLOPEDLY        0x27
#define STK83XX_REG_SLOPETHD        0x28
#define STK83XX_REG_SIGMOT1         0x29
#define STK83XX_REG_SIGMOT2         0x2A
#define STK83XX_REG_SIGMOT3         0x2B
#define STK83XX_REG_STEPCNT1        0x2C
#define STK83XX_REG_STEPCNT2        0x2D
#define STK83XX_REG_STEPTHD         0x2E
#define STK83XX_REG_STEPDEB         0x2F
#define STK83XX_REG_STEPMAXTW       0x31
#define STK83XX_REG_INTFCFG         0x34
#define STK83XX_REG_LPFCFG          0x35
#define STK83XX_REG_OFSTCOMP1       0x36
#define STK83XX_REG_OFSTX           0x38
#define STK83XX_REG_OFSTY           0x39
#define STK83XX_REG_OFSTZ           0x3A
#define STK83XX_REG_CFG1            0x3D
#define STK83XX_REG_CFG2            0x3E
#define STK83XX_REG_FIFOOUT         0x3F

/* STK83XX_REG_CHIPID */
#define STK8BA50_R_ID                       0x86
#define STK8BA53_ID                         0x87
#define STK8323_ID                          0x23 /* include for STK8321 */
#define STK8327_ID                          0x26 /* include for STK8331 */
#define STK8329_ID                          0x25
static const uint8_t STK_ID[] = {STK8BA50_R_ID, STK8BA53_ID, STK8323_ID, STK8327_ID, STK8329_ID};

/* STK83XX_REG_INTSTS1 */
#define STK83XX_INTSTS1_SIG_MOT_STS         0x1
#define STK83XX_INTSTS1_ANY_MOT_STS         0x4

/* STK83XX_REG_INTSTS2 */
#define STK83XX_INTSTS2_FWM_STS_MASK        0x40

/* STK83XX_REG_FIFOSTS */
#define STK83XX_FIFOSTS_FIFOOVER            0x80
#define STK83XX_FIFOSTS_FIFO_FRAME_CNT_MASK 0x7F

/* STK83XX_REG_RANGESEL */
#define STK83XX_RANGESEL_2G                 0x3
#define STK83XX_RANGESEL_4G                 0x5
#define STK83XX_RANGESEL_8G                 0x8
#define STK83XX_RANGESEL_16G                0xc
#define STK83XX_RANGESEL_BW_MASK            0xF
#define STK83XX_RANGESEL_DEF                STK83XX_RANGESEL_2G
typedef enum
{
    STK_2G = STK83XX_RANGESEL_2G,
    STK_4G = STK83XX_RANGESEL_4G,
    STK_8G = STK83XX_RANGESEL_8G,
    STK_16G = STK83XX_RANGESEL_16G
} stk_rangesel;

/* STK83XX_REG_BWSEL */
#define STK83XX_BWSEL_BW_7_81               0x08    /* ODR = BW x 2 = 15.62Hz */
#define STK83XX_BWSEL_BW_15_63              0x09    /* ODR = BW x 2 = 31.26Hz */
#define STK83XX_BWSEL_BW_31_25              0x0A    /* ODR = BW x 2 = 62.5Hz */
#define STK83XX_BWSEL_BW_62_5               0x0B    /* ODR = BW x 2 = 125Hz */
#define STK83XX_BWSEL_BW_125                0x0C    /* ODR = BW x 2 = 250Hz */
#define STK83XX_BWSEL_BW_250                0x0D    /* ODR = BW x 2 = 500Hz */
#define STK83XX_BWSEL_BW_500                0x0E    /* ODR = BW x 2 = 1000Hz */

/* STK83XX_REG_POWMODE */
#define STK83XX_PWMD_SUSPEND                0x80
#define STK83XX_PWMD_LOWPOWER               0x40
#define STK83XX_PWMD_SLEEP_TIMER            0x20
#define STK83XX_PWMD_NORMAL                 0x00
/* STK83XX_REG_ODRMODE */
#define STK83XX_ODR_NORMODE                 0x00
#define STK83XX_ODR_ESMMODE                 0x08

/* STK83XX_SLEEP_DUR */
#define STK83XX_PWMD_1                      0x1E
#define STK83XX_PWMD_2                      0x1C
#define STK83XX_PWMD_10                     0x1A
#define STK83XX_PWMD_20                     0x18
#define STK83XX_PWMD_25                     0x16
#define STK83XX_PWMD_50                     0x14
#define STK83XX_PWMD_100                    0x12
#define STK83XX_PWMD_163                    0x10
#define STK83XX_PWMD_200                    0x0E
#define STK83XX_PWMD_300                    0x0C
#define STK83XX_PWMD_SLP_MASK               0x7E

/* STK83XX_REG_SWRST */
#define STK83XX_SWRST_VAL                   0xB6

/* STK83XX_REG_INTEN1 */
#define STK83XX_INTEN1_SLP_EN_XYZ           0x07

/* STK83XX_REG_INTEN2 */
#define STK83XX_INTEN2_DATA_EN              0x10
#define STK83XX_INTEN2_FWM_EN               0x40

/* STK83XX_REG_INTMAP1 */
#define STK83XX_INTMAP1_SIGMOT2INT1         0x01
#define STK83XX_INTMAP1_ANYMOT2INT1         0x04

/* STK83XX_REG_INTMAP2 */
#define STK83XX_INTMAP2_DATA2INT1           0x01
#define STK83XX_INTMAP2_FWM2INT1            0x02
#define STK83XX_INTMAP2_FWM2INT2            0x40

/* STK83XX_REG_INTMAP3 */
#define STK83XX_INTMAP3_6D_LATCH_MODE       0x01
#define STK83XX_INTMAP3_TILT_2INT1          0x10
#define STK83XX_INTMAP3_6D_2INT1            0x20
#define STK83XX_INTMAP3_TILT_2INT2          0x40
#define STK83XX_INTMAP3_6D_2INT2            0x80

/* STK83XX_REG_SIXDCFG */
#define STK83XX_SIXDCFG_6D_CTRL_LOW_X       0x01
#define STK83XX_SIXDCFG_6D_CTRL_HIGH_X      0x02
#define STK83XX_SIXDCFG_6D_CTRL_LOW_Y       0x04
#define STK83XX_SIXDCFG_6D_CTRL_HIGH_Y      0x08
#define STK83XX_SIXDCFG_6D_CTRL_LOW_Z       0x10
#define STK83XX_SIXDCFG_6D_CTRL_HIGH_Z      0x20

#define STK83XX_SIXDCFG_6D_STATE_MASK       0x3F
#define STK83XX_SIXDCFG_6D_MODE_MASK        0x40
#define STK83XX_SIXDCFG_6D_AO_MASK          0x80

/* STK83XX_REG_SIXDTHD */
#define STK83XX_SIXDTHD_2G_DEF              0x33 // 0x33 = 800mg
#define STK83XX_SIXDTHD_4G_DEF              0x19 // 0x19 = 800mg
#define STK83XX_SIXDTHD_8G_DEF              0x0C // 0x0C = 800mg

/* STK83XX_REG_SIXDSTS */
#define STK83XX_SIXDSTS_X_L_MASK            0x01
#define STK83XX_SIXDSTS_X_H_MASK            0x02
#define STK83XX_SIXDSTS_Y_L_MASK            0x04
#define STK83XX_SIXDSTS_Y_H_MASK            0x08
#define STK83XX_SIXDSTS_Z_L_MASK            0x10
#define STK83XX_SIXDSTS_Z_H_MASK            0x20


/* STK83XX_REG_SIXDDLY */
#define STK83XX_SIXDDLY_DEF                 0x30

/* STK83XX_REG_INTCFG1 */
#define STK83XX_INTCFG1_INT1_ACTIVE_H       0x01
#define STK83XX_INTCFG1_INT1_OD_PUSHPULL    0x00
#define STK83XX_INTCFG1_INT2_ACTIVE_H       0x04
#define STK83XX_INTCFG1_INT2_OD_PUSHPULL    0x00

/* STK83XX_REG_INTCFG2 */
#define STK83XX_INTCFG2_NOLATCHED           0x00
#define STK83XX_INTCFG2_LATCHED             0x0F
#define STK83XX_INTCFG2_INT_RST             0x80

/* STK83XX_REG_TILTTHD */
#define STK83XX_TILTTHD_25                  0x0B
#define STK83XX_TILTTHD_30                  0x11
#define STK83XX_TILTTHD_35                  0x17
#define STK83XX_TILTTHD_40                  0x1D
#define STK83XX_TILTTHD_45                  0x25
#define STK83XX_TILTTHD_50                  0x2D
#define STK83XX_TILTTHD_55                  0x36
#define STK83XX_TILTTHD_60                  0x3F
#define STK83XX_TILTTHD_65                  0x49
#define STK83XX_TILTTHD_70                  0x54
#define STK83XX_TILTTHD_75                  0x5E

/* STK83XX_REG_TILTPOW */
#define STK83XX_TILTPOW_VAL                 0x88 //0x88 = 50%~150%

/* STK83XX_REG_TILTCFG */
#define STK83XX_TILTCFG_EN                  0x10
#define STK83XX_TILTCFG_STS_MASK            0x80
#define STK83XX_TILTCFG_DEB_0S              0x00
#define STK83XX_TILTCFG_DEB_0_5S            0x20
#define STK83XX_TILTCFG_DEB_1S              0x40
#define STK83XX_TILTCFG_DEB_6S              0x60


/* STK83XX_REG_SLOPETHD */
#define STK83XX_SLOPETHD_DEF                0x14

/* STK83XX_REG_SIGMOT1 */
#define STK83XX_SIGMOT1_SKIP_TIME_3SEC      0x96    /* default value */

/* STK83XX_REG_SIGMOT2 */
#define STK83XX_SIGMOT2_SIG_MOT_EN          0x02
#define STK83XX_SIGMOT2_ANY_MOT_EN          0x04

/* STK83XX_REG_SIGMOT3 */
#define STK83XX_SIGMOT3_PROOF_TIME_1SEC     0x32    /* default value */

/* STK83XX_REG_STEPCNT2 */
#define STK83XX_STEPCNT2_RST_CNT            0x04
#define STK83XX_STEPCNT2_STEP_CNT_EN        0x08

/* STK83XX_REG_INTFCFG */
#define STK83XX_INTFCFG_I2C_WDT_EN          0x04

/* STK83XX_REG_OFSTCOMP1 */
#define STK83XX_OFSTCOMP1_OFST_RST          0x80

/* STK83XX_REG_CFG1 */
/* the maximum space for FIFO is 32*3 bytes */
#define STK83XX_CFG1_XYZ_FRAME_MAX          32

/* STK83XX_REG_CFG2 */
#define STK83XX_CFG2_FIFO_MODE_BYPASS       0x0
#define STK83XX_CFG2_FIFO_MODE_FIFO         0x1
#define STK83XX_CFG2_FIFO_MODE_SHIFT        5
#define STK83XX_CFG2_FIFO_DATA_SEL_XYZ      0x0
#define STK83XX_CFG2_FIFO_DATA_SEL_X        0x1
#define STK83XX_CFG2_FIFO_DATA_SEL_Y        0x2
#define STK83XX_CFG2_FIFO_DATA_SEL_Z        0x3
#define STK83XX_CFG2_FIFO_DATA_SEL_MASK     0x3

/* STK83XX_REG_OFSTx */
#define STK83XX_OFST_LSB                    128     /* 8 bits for +-1G */

/* STK83XX_REG_LPFCFG */
#define STK83XX_LPFCFG_EN                   0x1
#define STK83XX_LPFCFG_CTRL                 0x6
/*****************************************************************************
 * stk83xx register, end
 *****************************************************************************/

#define STK83XX_NAME    "stk83xx"

typedef struct stk_data stk_data;
typedef void (*STK_READ_DATA_CB)(struct stk_data *);
typedef void (*STK_REPORT_CB)(struct stk_data *);
typedef void (*STK_READ_FIFO_CB)(struct stk_data *);
typedef void (*STK_FIFO_REPORT_CB)(struct stk_data *, int16_t *, int32_t);
#ifdef STK_AMD
    typedef void (*STK_REPORTAMD_CB)(struct stk_data *, bool);
#endif

struct stk_data
{
    const struct stk_bus_ops        *bops;
    const struct stk_timer_ops      *tops;
    const struct stk_gpio_ops       *gops;
    STK_READ_DATA_CB                read_data_cb;
    STK_REPORT_CB                   accel_report_cb;
    STK_READ_FIFO_CB                read_fifo_cb;
    STK_FIFO_REPORT_CB              fifo_report_cb;
#ifdef STK_AMD
    STK_REPORTAMD_CB                reportamd_cb;
#endif
    bool                            enabled;            /* chip is enabled or not */
    uint32_t                        selftest;           /* selftest result */
    int32_t                         direction;
    int32_t                         sr_no;              /* Serial number of stkODRTable */
    int32_t                         sensitivity;        /* sensitivity, bit number per G */
    int32_t                         bus_idx;
    int16_t                         xyz[3];             /* The latest data of xyz */
    uint8_t                         power_mode;
    uint8_t                         pid;
    uint8_t                         data_shift;
    uint8_t                         odr_table_count;
    uint8_t                         recv;
    bool                            fifo;               /* Support FIFO or not */
    bool                            temp_enable;        /* record current power status. For Suspend/Resume used. */
    bool                            is_esm_mode;
    uint32_t                      slope_threshold;
#ifdef STK_CALI
    int16_t                         cali_sw[3];
    int32_t                         cali_status;        /* cali status */
#endif /* STK_CALI */
#ifdef STK_AUTO_K
    bool                            is_stationary;
    int16_t                         auto_cali_bias[3];
#endif // STK_AUTO_K
#ifdef STK_HW_STEP_COUNTER
    int32_t                         steps;              /* The latest step counter value */
#endif /* STK_HW_STEP_COUNTER */
#ifdef STK_INTERRUPT_MODE
    stk_gpio_info                   gpio_info;
#elif defined STK_POLLING_MODE
    #ifdef STK_WEAKEUP_SYSTEM_BY_IRQ
    int                                         isr_print_enable;
    stk_gpio_info                   gpio_info;
    #endif
    stk_timer_info                  stk_timer_info;
#endif /* STK_INTERRUPT_MODE, STK_POLLING_MODE */
#if defined (STK_FIR) || defined(STK_AUTO_K)
    struct data_log                 data_log;
    uint16_t                        data_log_len;
#endif /* STK_FIR */
#ifdef STK_CALI_FILE
    uint8_t                         offset[3];
#endif /* STK_CALI_FILE */
#ifdef STK_AXES_SIM
    uint8_t                         check_fail_count[3];
    uint8_t                         CHECK_COUNT;
    uint8_t                         sim_status;
    int16_t                         MAX_VAL;
    int16_t                         MIN_VAL;
    int32_t                         G_VAL;
    int                             init_success;
#endif // STK_AXES_SIM
};
struct stk83xx_platform_data
{
    uint8_t             direction;
    int32_t             interrupt_int1_pin;
    uint32_t           default_slope_threshold;
};

//#define STK_TAG                 "[stkAccel]"

#define STK83XX_READ_DATA_CB(stk_data)                      if ((stk_data)->read_data_cb)           ((stk_data)->read_data_cb(stk_data))
#ifdef STK_AMD
    #define STK83XX_AMD_REPORT(stk_data, flag)                  if ((stk_data)->reportamd_cb)           ((stk_data)->reportamd_cb(stk_data, flag))
#endif
#define STK83XX_ACCEL_REPORT(stk_data)                      if ((stk_data)->accel_report_cb)        ((stk_data)->accel_report_cb(stk_data))
#define STK83XX_READ_FIFO_CB(stk_data)                      if ((stk_data)->read_fifo_cb)           ((stk_data)->read_fifo_cb(stk_data))
#define STK83XX_FIFO_REPORT(stk_data, xyz, len)             if ((stk_data)->fifo_report_cb)         ((stk_data)->fifo_report_cb(stk_data, xyz, len))
#define STK83XX_REQUEST_REGISTRY(stk_data)                  if ((stk_data)->request_registry_cb)    ((stk_data)->request_registry_cb(stk_data))

typedef struct
{
    uint8_t     regBwsel;
    uint8_t     regPwsel;
    uint32_t    sample_rate_us;
    int32_t     drop;
} _stkOdrMap;

#define STK_MIN_DELAY_US 2000   /* stkODRTable[4].sample_rate_us */
#define STK_MAX_DELAY_US 32000  /* stkODRTable[0].sample_rate_us */

/* selftest usage */
#define STK_SELFTEST_SAMPLE_NUM             100
#define STK_SELFTEST_RESULT_NA              0
#define STK_SELFTEST_RESULT_RUNNING         (1 << 0)
#define STK_SELFTEST_RESULT_NO_ERROR        (1 << 1)
#define STK_SELFTEST_RESULT_DRIVER_ERROR    (1 << 2)
#define STK_SELFTEST_RESULT_FAIL_X          (1 << 3)
#define STK_SELFTEST_RESULT_FAIL_Y          (1 << 4)
#define STK_SELFTEST_RESULT_FAIL_Z          (1 << 5)
#define STK_SELFTEST_RESULT_NO_OUTPUT       (1 << 6)
static inline int32_t stk_selftest_offset_factor(int32_t sen)
{
    return sen * 3 / 10;
}
static inline int32_t stk_selftest_noise_factor(int32_t sen)
{
    return sen / 10;
}

#ifdef STK_AXES_SIM
    #define STK_AXES_SIM_CHECK_CNT          6
#endif // STK_AXES_SIM

#ifdef STK_CALI
    /* calibration parameters */
    #define STK_CALI_SAMPLE_NO          10
    #define STK_CALI_CHECK_THRESHOLD    40 //40LSB@1G_8bit = 312.5mg
    #ifdef STK_CALI_FILE
        #define STK_CALI_VER0               0x18
        #define STK_CALI_VER1               0x03
        #define STK_CALI_END                '\0'
        #define STK_CALI_FILE_SIZE          25
    #endif /* STK_CALI_FILE */
    /* parameter for cali_status and cali file */
    #define STK_K_SUCCESS_FILE          0x01
    /* parameter for cali_status */
    #define STK_K_FAIL_WRITE_OFST       0xF2
    #define STK_K_FAIL_I2C              0xF8
    #define STK_K_FAIL_W_FILE           0xFB
    #define STK_K_FAIL_VERIFY_CALI      0xFD
    #define STK_K_RUNNING               0xFE
    #define STK_K_NO_CALI               0xFF
#endif /* STK_CALI */

int stk83xx_set_slope_threshold(struct stk_data *stk, uint32_t val);
void  stk83xx_enable_anymotion(struct stk_data *stk, bool en);
uint32_t stk83xx_get_delay(struct stk_data *stk);
int32_t stk83xx_set_delay(struct stk_data *stk, uint32_t delay_us);
int32_t stk83xx_get_offset(struct stk_data *stk, uint8_t offset[3]);
int32_t stk83xx_set_offset(struct stk_data *stk, uint8_t offset[3]);
void stk83xx_set_enable(struct stk_data *stk, char en);
int32_t stk83xx_check_pid(struct stk_data *stk);
void stk83xx_data_initialize(struct stk_data *stk);
void stk83xx_register_queue(struct stk_data*stk);
int32_t stk83xx_range_selection(struct stk_data *stk, stk_rangesel range);
void stk83xx_fifo_reading(struct stk_data *stk, uint8_t fifo[], int32_t len);
int32_t stk83xx_change_fifo_status(struct stk_data *stk, uint8_t wm);
int32_t stk83xx_read_accel_rawdata(struct stk_data *stk);
int32_t stk83xx_reg_init(struct stk_data *stk, stk_rangesel range, int32_t sr_no);
void stk83xx_selftest(struct stk_data *stk);
void stk83xx_read_accel_data(struct stk_data *stk);
#if defined STK_INTERRUPT_MODE || defined STK_POLLING_MODE
    void stk83xx_read_then_report_fifo_data(struct stk_data *stk);
    #ifdef STK_INTERRUPT_MODE
        void stk83xx_work_queue(void *stkdata);
    #elif defined STK_POLLING_MODE
    #ifdef STK_WEAKEUP_SYSTEM_BY_IRQ
        void __maybe_unused stk83xx_register_wakeup_system(struct i2c_client *client, struct stk_data *stk);
    #endif
        void stk83xx_work_queue(void *stkdata);
    #endif
#endif /* defined STK_INTERRUPT_MODE || defined STK_POLLING_MODE */
#ifdef STK_CALI
    #ifdef STK_CALI_FILE
        void stk83xx_get_cali(struct stk_data *stk);
    #endif /* STK_CALI_FILE */
    void stk83xx_set_cali(struct stk_data *stk);
    void stk83xx_reset_cali(struct stk_data *stk);
#endif /* STK_CALI */
#ifdef STK_HW_STEP_COUNTER
    void stk83xx_read_step_data(struct stk_data *stk);
    void stk83xx_turn_step_counter(struct stk_data *stk, bool turn);
#endif /* STK_HW_STEP_COUNTER */
#if defined(STK_FIR) || defined(STK_AUTO_K)
    void stk83xx_data_log_process(struct stk_data* stk, int16_t* xyz);
#endif // STK_FIR or STK_AUTO_K
#ifdef STK_AUTO_K
    void stk83xx_auto_cali(struct stk_data* stk, int16_t* xyz);
#endif // STK_AUTO_K

extern const int16_t coordinate_trans[8][3][3];

#endif /* __STK83XX_H__ */