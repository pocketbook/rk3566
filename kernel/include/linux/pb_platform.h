#ifndef _PB_PLATFORM_H_
#define _PB_PLATFORM_H_

#include <linux/types.h>

const char *GetPCBVersion(void);

/*
 * Touch panel power control, backing /proc/power/touch.
 *
 * A touch driver registers a pair of callbacks at the end of probe; writing
 * 0 or 1 to the proc node then calls @touch_enable_cb, and reading it returns
 * @touch_state_cb. A locked device quiets its panel this way, without the
 * writer having to know which panel is fitted.
 *
 * Pass (NULL, NULL, NULL) to unregister.
 */
int register_touchpower_callback(int (*touch_enable_cb)(void *data, bool onOff),
				 int (*touch_state_cb)(void *data),
				 void *touch_context);

#endif
