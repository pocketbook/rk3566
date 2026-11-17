// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

#ifndef __EBC_UAPI_H__
#define __EBC_UAPI_H__

#define EBC_DRV_VERSION         "2.0.1-pb"

#define WF_MODE_MASK       (7 << 4)  // waveform mode: which pixels to update

#define WF_MODE_GC         (1 << 4)  // full mode - update all pixels
#define WF_MODE_GU         (2 << 4)  // partial mode - update only changed pixels
#define WF_MODE_GLD        (3 << 4)  // GL with regal enhancement (text, black-on-white)
#define WF_MODE_GLN        (4 << 4)  // GL with regal enhancement (text, white-on-black)
#define WF_MODE_IN         (6 << 4)  // waveform entry (used for A2IN)

#define WF_QUALITY_MASK    (3 << 0)  // waveform quality, affects update time and ghosting level

#define WF_QUALITY_DRAFT   (0 << 0)  // fastest black & white update, high ghosting
#define WF_QUALITY_UI      (1 << 0)  // fast update with at least 4 grey levels, low-to-medium ghosting
#define WF_QUALITY_TEXT    (2 << 0)  // normal update for text and bw images, low ghosting
#define WF_QUALITY_IMAGE   (3 << 0)  // slow high-quality update for color images (for bw devices, the same as 2)

#define WF_TRANSITION_MASK (1 << 7)  // not an update but a transition mask for next one

#define WF_QUALITY_COUNT   4

#define IS_FULL_MODE(mode)    (((mode) & WF_MODE_MASK) == WF_MODE_GC && ((mode) & WF_QUALITY_MASK) >= WF_QUALITY_TEXT)
#define IS_PARTIAL_MODE(mode) (((mode) & WF_MODE_MASK) == WF_MODE_GU)
#define IS_NORMAL_MODE(mode)  (((mode) & WF_MODE_MASK) == WF_MODE_GU || ((mode) & WF_MODE_MASK) == WF_MODE_GC)

struct ebc_area {
	int x;
	int y;
	int w;
	int h;
} __attribute__ ((packed));

struct ebc_user_buf_t {
	int index;
	int fd;
	int size;
	int mode;
	unsigned long long img_seq;
	int trans_type;
	int trans_dur_ms;
	struct ebc_area dirty_area;
} __attribute__ ((packed));

struct ebc_user_panel_t {
	int width;
	int height;
	int width_mm;
	int height_mm;
	int cfa; // reference to rkcfa_api.h rkcfa_platform
} __attribute__ ((packed));

#define EBC_IOC_MAGIC           'e'
#define EBC_IO(nr)              _IO(EBC_IOC_MAGIC, nr)
#define EBC_IOW(nr, type)       _IOW(EBC_IOC_MAGIC, nr, type)
#define EBC_IOR(nr, type)       _IOR(EBC_IOC_MAGIC, nr, type)
#define EBC_IOWR(nr, type)      _IOWR(EBC_IOC_MAGIC, nr, type)

// query the panel information
#define EBC_IOC_QUERY_PANEL         EBC_IOR(0x0, struct ebc_user_panel_t)
// dequeue an idle buffer for draw
#define EBC_IOC_DEQUEUE_BUF         EBC_IOR(0x1, struct ebc_user_buf_t)
// enquene this buffer to display queue and return the frame no
#define EBC_IOC_ENQUEUE_BUF         EBC_IOWR(0x2, struct ebc_user_buf_t)
// drop this buffer, don't display
#define EBC_IOC_DROP_BUF            EBC_IOW(0x3, struct ebc_user_buf_t)
// drain display queue
#define EBC_IOC_DRAIN_BUFS          EBC_IO(0x5)
// query driver state (0=idle,1=busy)
#define EBC_IOC_QUERY_STATE         EBC_IOR(0xA, int)
// query panel temperature
#define EBC_IOC_QUERY_TEMP          EBC_IOR(0xC, int)

// service API
#define EBC_IOC_QUERY_LUT_BUF       EBC_IO(0xc1)
#define EBC_IOC_SET_EXCLUSIVE       EBC_IO(0xc2)
#define EBC_IOC_CUSTOM_WAVEFORM     EBC_IO(0xc3)

#endif
