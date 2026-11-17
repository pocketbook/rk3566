// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

#ifndef __EBC_LOG_H__
#define __EBC_LOG_H__

#include <linux/types.h>

#define EBC_DEFAULT_LOGLEVEL 3

#ifndef LOG_TAG
#define LOG_TAG ""
#endif

extern int ebc_loglevel;
extern u32 active_spells;

#define TRC(fmt, args...) do { if (ebc_loglevel >= 4) pr_info(LOG_TAG " T " fmt, ##args); } while (0)
#define DBG(fmt, args...) do { if (ebc_loglevel >= 3) pr_info(LOG_TAG " D " fmt, ##args); } while (0)
#define INF(fmt, args...) do { if (ebc_loglevel >= 2) pr_info(LOG_TAG " I " fmt, ##args); } while (0)
#define ERR(fmt, args...) do { if (ebc_loglevel >= 1) pr_info(LOG_TAG " E " fmt, ##args); } while (0)

#define SPELL_NO_GU     (1 << 0)
#define SPELL_NO_A2IN   (1 << 1)

#define checkspell(s) (active_spells & (s))

#endif
