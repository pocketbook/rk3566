obj-$(CONFIG_TOUCHSCREEN_ILITEK) += ilitek_i2c.o

ccflags-y += -DILITEK_BOOT_UPDATE

ifneq (,$(findstring -DILITEK_BOOT_UPDATE,$(ccflags-y)))
ccflags-y += -DILITEK_READ_FW_FROM_FS
endif

ilitek_i2c-y := ilitek_def.o \
							ilitek_main.o \
							ilitek_platform_init.o \
							ilitek_update.o \
							ilitek_tool.o \
							ilitek_protocol.o \
							ilitek_crypto.o \
							ilitek_report.o
