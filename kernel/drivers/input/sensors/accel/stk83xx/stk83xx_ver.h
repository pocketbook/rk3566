/**
 *  * @file stk83xx_ver.h
 *   *
 *    * Copyright (c) 2020, Sensortek.
 *     * All rights reserved.
 *      *
 *******************************************************************************/

/*==============================================================================
 *
 *     Change Log:
 *
 *         EDIT HISTORY FOR FILE
 *
 *                 Apr 06 2022 STK - 1.0.0
 *                       - first SSU architecture
 *                       - include spi/i2c 1.0 and 2.0
 *                 May 05 2022 STK - 1.0.1
 *                       - Add 6D tilt function, STK_6D_TILT only for stk8331 now
 *                 Mar 13 2023 STK - 1.1.0
 *                       - Edit some STK_SPREADTRUM define region
 *                 Mar 14 2023 STK - 1.2.0
 *                       - Add 6D status mask
 *                 Mar 16 2023 STK - 1.3.0
 *                       - Edit symbol int, u16, u32...etc to intxx_t
 *                 May 15 2023 STK - 1.4.0
 *                       - Add low pass filter setting
 *                 Jun 02 2023 STK - 1.5.0
 *                       - change strcpy and print args, remove STK_ABS define in driver
 *                 Jun 08 2023 STK - 1.6.0
 *                       - rename stk_ function head to stk83xx_
 *                       - moving print define to common_define
 *                       - add check pid
 *                 Jun 14 2023 STK - 1.7.0
 *                       - edit print function and remove print define
 *                 Jul 11 2023 STK - 1.8.0
 *                       - fix compile warning
 *                 Jul 12 2023 STK - 1.9.0
 *                       - fix compile warning with different build option
 *                 Aug 08 2023 STK - 1.10.0
 *                       - Move Common define to common_define.h
 *                 Aug 15 2023 STK - 1.11.0
 *                       - Add axes simulation function to driver
 *                       - Fine tune axes simulation flow
 *                 Aug 16 2023 STK - 1.12.0
 *                       - Update axes simulation flow
 *                 Aug 22 2023 STK - 1.13.0
 *                       - Fix build error for axes simulation in Linux
 *                 SEP 06 2023 STK - 1.14.0
 *                       - Fix softreset delay time
 *                 SEP 07 2023 STK - 1.15.0
 *                       - Fix different enum type for range setting
 *                 NOV 16 2023 STK - 1.16.0
 *                       - Update axes simulation mechanism
 *                 Jan 04 2024 STK - 1.17.0
 *                       - Update axes simulation
 *                 Jan  9 2024 STK - 1.18.0
 *                       - change callback argument
 *                 Mar  1 2024 STK - 1.19.0
 *                       - Add GPIO push pull type setting
 *                 Mar 14 2024 STK - 1.20.0
 *                       - Support z axes simulation always on
 *                       - Update axes simulation for absolute value
 *                 Jun 21 2024 STK - 1.21.0
 *                       - Fix check_pid err code handle issue
 *                       - Fix FIR data overflow issue
 *                       - Correct gsensor_get_data form driver data struct
 *                       - Disable fifo mode by default
 *                 Oct 04 2024 STK - 1.22.0
 *                       - Correct z value always positive issue for Z sim always on
 *============================================================================*/

#ifndef _STK83XX_VER_H
#define _STK83XX_VER_H

// 32-bit version number represented as major[31:16].minor[15:8].rev[7:0]
#define STK83XX_MAJOR        1
#define STK83XX_MINOR        22
#define STK83XX_REV          0
#define VERSION_STK83XX  ((STK83XX_MAJOR<<16) | (STK83XX_MINOR<<8) | STK83XX_REV)

#endif //_STK83XX_VER_H