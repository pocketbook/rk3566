# SPDX-License-Identifier: GPL-2.0
#
# Makefile for the Linux Bluetooth HCI device drivers.
#

obj-$(CONFIG_BT_HCIVHCI)	+= hci_vhci.o
obj-$(CONFIG_BT_HCIUART)	+= hci_uart.o
obj-$(CONFIG_BT_HCIBCM203X)	+= bcm203x.o
obj-$(CONFIG_BT_HCIBPA10X)	+= bpa10x.o
obj-$(CONFIG_BT_HCIBFUSB)	+= bfusb.o
obj-$(CONFIG_BT_HCIDTL1)	+= dtl1_cs.o
obj-$(CONFIG_BT_HCIBT3C)	+= bt3c_cs.o
obj-$(CONFIG_BT_HCIBLUECARD)	+= bluecard_cs.o

obj-$(CONFIG_BT_HCIBTUSB)	+= btusb.o
obj-$(CONFIG_BT_HCIBTSDIO)	+= btsdio.o

obj-$(CONFIG_BT_INTEL)		+= btintel.o
obj-$(CONFIG_BT_ATH3K)		+= ath3k.o
obj-$(CONFIG_BT_MRVL)		+= btmrvl.o
obj-$(CONFIG_BT_MRVL_SDIO)	+= btmrvl_sdio.o
obj-$(CONFIG_BT_MTKSDIO)	+= btmtksdio.o
obj-$(CONFIG_BT_MTKUART)	+= btmtkuart.o
obj-$(CONFIG_BT_QCOMSMD)	+= btqcomsmd.o
obj-$(CONFIG_BT_BCM)		+= btbcm.o
obj-$(CONFIG_BT_RTL)		+= btrtl.o
obj-$(CONFIG_BT_QCA)		+= btqca.o

obj-$(CONFIG_BT_HCIUART_NOKIA)	+= hci_nokia.o

obj-$(CONFIG_BT_HCIRSI)		+= btrsi.o

btmrvl-y			:= btmrvl_main.o
btmrvl-$(CONFIG_DEBUG_FS)	+= btmrvl_debugfs.o

hci_uart-y				:= hci_ldisc.o
hci_uart-$(CONFIG_BT_HCIUART_SERDEV)	+= hci_serdev.o
hci_uart-$(CONFIG_BT_HCIUART_H4)	+= hci_h4.o
hci_uart-$(CONFIG_BT_HCIUART_BCSP)	+= hci_bcsp.o
hci_uart-$(CONFIG_BT_HCIUART_LL)	+= hci_ll.o
hci_uart-$(CONFIG_BT_HCIUART_ATH3K)	+= hci_ath.o
hci_uart-$(CONFIG_BT_HCIUART_3WIRE)	+= hci_h5.o
hci_uart-$(CONFIG_BT_HCIUART_INTEL)	+= hci_intel.o
hci_uart-$(CONFIG_BT_HCIUART_BCM)	+= hci_bcm.o
hci_uart-$(CONFIG_BT_HCIUART_QCA)	+= hci_qca.o
hci_uart-$(CONFIG_BT_HCIUART_AG6XX)	+= hci_ag6xx.o
hci_uart-$(CONFIG_BT_HCIUART_MRVL)	+= hci_mrvl.o
hci_uart-objs				:= $(hci_uart-y)

ccflags-y += -I$(srctree)/include/linux/platform_data/

ifneq ($(skw_extra_flags),)
ccflags-y += $(skw_extra_flags)
endif

ifneq ($(skw_extra_symbols),)
KBUILD_EXTRA_SYMBOLS += $(skw_extra_symbols)
endif

ifeq ($(CONFIG_SEEKWAVE_PLD_RELEASE),y)
    ccflags-y += -DCONFIG_SEEKWAVE_PLD_RELEASE
endif

ifeq ($(CONFIG_SEEKWAVE_BSP_DRIVERS_V20),y)
    ccflags-y += -DINCLUDE_NEW_VERSION=1
endif

obj-$(CONFIG_SKW_BT)        += skwbt.o
skwbt-y                     := skw_btdriver.o
skwbt-y                     += skw_btsnoop.o
skwbt-y                     += skw_log.o
skwbt-y                     += skw_common.o
skwbt-y                     += skw_btlog.o