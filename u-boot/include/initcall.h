/*
 * Copyright (c) 2011 The Chromium OS Authors.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef __INITCALL_H
#define __INITCALL_H

typedef int (*init_fnc_t)(void);

typedef struct {
	const char *name;
	const init_fnc_t func;
}
init_fnc_struct;

//int initcall_run_list(const init_fnc_t init_sequence[]);
int initcall_run_list(const init_fnc_struct init_sequence[]);

#define IFUNC(s) { #s, s }

#endif
