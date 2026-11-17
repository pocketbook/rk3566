/*
 * Copyright (c) 2013 The Chromium OS Authors.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <initcall.h>
#include <efi.h>

DECLARE_GLOBAL_DATA_PTR;

#define TICKS_TO_US(ticks)	((ticks) / (gd->arch.timer_rate_hz / 1000000))
#define US_TO_MS(ticks)		((ticks) / 1000)
#define US_TO_US(ticks)		((ticks) % 1000)

#ifdef DEBUG
static inline void call_get_ticks(ulong *ticks) { *ticks = get_ticks(); }
#else
static inline void call_get_ticks(ulong *ticks) { }
#endif

int initcall_run_list(const init_fnc_struct init_sequence[])
{
	const init_fnc_struct *init_fnc_ptr;
	ulong start = 0, end = 0, sum = 0;

	if (!gd->sys_start_tick)
		gd->sys_start_tick = get_ticks();

	for (init_fnc_ptr = init_sequence; init_fnc_ptr->name; ++init_fnc_ptr) {
		int ret;

		//printf("%p %s\n", (void *)(*init_fnc_ptr->func), init_fnc_ptr->name);
		call_get_ticks(&start);
		ret = (*init_fnc_ptr->func)();
		call_get_ticks(&end);

		if (start != end) {
			sum = TICKS_TO_US(end - gd->sys_start_tick);
			debug("\t\t\t\t\t\t\t\t#%8ld us #%4ld.%3ld ms\n",
			      TICKS_TO_US(end - start), US_TO_MS(sum), US_TO_US(sum));
		}
		if (ret) {
			printf("initcall sequence %p failed at call %s (err=%d)\n",
			       init_sequence,
			       init_fnc_ptr->name, ret);
			return -1;
		}
	}
	return 0;
}
