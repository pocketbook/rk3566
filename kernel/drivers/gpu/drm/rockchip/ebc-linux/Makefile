# SPDX-License-Identifier: GPL-2.0

ccflags-y += -I$(src)

obj-$(CONFIG_ROCKCHIP_EBC_LINUX) += ebc-linux.o

ebc-linux-objs	:= ebc_area.o ebc_drv.o ebc_mm.o ebc_logo.o ebc_session.o ebc_public.o ebc_transition.o
ebc-linux-objs	+= ebc_wffpu.o ebc_wffpu_index.o ebc_wffpu_frame.o ebc_wflut.o ebc_dump.o

ebc-linux-objs += tcon/tcon.o tcon/ebc_tcon.o

ebc-linux-objs += pmic/ebc_pmic.o pmic/ebc_pmic_mfd.o

CFLAGS_REMOVE_ebc_wffpu_frame.o := -mbranch-protection=none -fstack-protector-strong -mstack-protector-guard=sysreg -mstack-protector-guard-offset=1280 -fno-optimize-sibling-calls -fconserve-stack
CFLAGS_ebc_wffpu_frame.o := -O3

CFLAGS_REMOVE_ebc_wffpu_index.o := -mbranch-protection=none -fstack-protector-strong -mstack-protector-guard=sysreg -mstack-protector-guard-offset=1280 -fno-optimize-sibling-calls -fconserve-stack
CFLAGS_ebc_wffpu_index.o := -O3

ifeq ($(CONFIG_EBC_TPS65185_SENSOR),y)
ebc-linux-objs += pmic/tps65185.o
endif

ifeq ($(CONFIG_EBC_SY7636A_PMIC),y)
ebc-linux-objs += pmic/sy7636a-regulator.o pmic/sy7636a-thermal.o
endif

ifeq ($(CONFIG_EBC_SY7673A_PMIC),y)
ebc-linux-objs += pmic/sy7673a.o
endif

ifeq ($(CONFIG_EPD_FP9931_PMIC),y)
ebc-linux-objs += pmic/fp9931-regulator.o pmic/fp9931-thermal.o
endif
