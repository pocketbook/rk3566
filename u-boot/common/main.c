/*
 * (C) Copyright 2000
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

/* #define	DEBUG	*/

#include <common.h>
#include <autoboot.h>
#include <cli.h>
#include <console.h>
#include <version.h>
#include <dm/uclass.h>
#include <dm/device.h>
#include <led.h>
#include <asm/arch/boot_mode.h>
#include <asm/io.h>
#include <power/pmic.h>
#include <power/rk8xx_pmic.h>

DECLARE_GLOBAL_DATA_PTR;

extern int battery_voltage_mV, vbus_voltage_mV;
extern int rk_poweron_source;

static struct udevice *pmic_dev = NULL;

/*
 * Board-specific Platform code can reimplement show_boot_progress () if needed
 */
__weak void show_boot_progress(int val) {}

static void run_preboot_environment_command(void)
{
#ifdef CONFIG_PREBOOT
	char *p;

	p = env_get("preboot");
	if (p != NULL) {
# ifdef CONFIG_AUTOBOOT_KEYED
		int prev = disable_ctrlc(1);	/* disable Control C checking */
# endif

		run_command_list(p, -1, 0);

# ifdef CONFIG_AUTOBOOT_KEYED
		disable_ctrlc(prev);	/* restore Control C checking */
# endif
	}
#endif /* CONFIG_PREBOOT */
}

void led_switch(bool on)
{
	struct udevice *dev;
	if (led_get_by_label("white_led", &dev) != 0) return;
	led_set_state(dev, on ? LEDST_ON : LEDST_OFF);
}

static bool check_power_key(void)
{
	uint8_t value;

	if (! pmic_dev) return false;
	if (pmic_read(pmic_dev, 0xf0, &value, 1) != 0) return false;
	return (value & 0x80) != 0;
}


/* We come here after U-Boot is initialised and ready to process commands */
void main_loop(void)
{
	const char *s;
	struct udevice *dev = NULL;

	bootstage_mark_name(BOOTSTAGE_ID_MAIN_LOOP, "main_loop");

#ifdef CONFIG_VERSION_VARIABLE
	env_set("ver", version_string);  /* set version variable */
#endif /* CONFIG_VERSION_VARIABLE */

	cli_init();

	run_preboot_environment_command();

#if defined(CONFIG_UPDATE_TFTP)
	update_tftp(0UL, NULL, NULL);
#endif /* CONFIG_UPDATE_TFTP */

	// run probe for fusb302
	uclass_get_device(UCLASS_PD, 0, &dev);
	// run probe for fuel gauge device, read voltages
	uclass_get_device_by_name(UCLASS_FG, "battery", &dev);
	printf("Battery voltage: %d\n", battery_voltage_mV);
	printf("VBUS voltage: %d\n", vbus_voltage_mV);

	// if not charging and battery is too low, power off immediately
	if (vbus_voltage_mV < 4000 && battery_voltage_mV < CONFIG_PB_VBAT_CRITICAL_LEVEL) {
		printf("Battery critical low, shutting down\n");
		for (int i=0; i<2; i++) {
			mdelay(200);
			led_switch(false);
			mdelay(200);
			led_switch(true);
		}
		psci_system_off();
	}

	// if usb is connected, wait for PWRKEY_DNL_TRIGGER_NUM clicks then go bootrom
	#if defined(CONFIG_PWRKEY_DNL_TRIGGER_NUM) && (CONFIG_PWRKEY_DNL_TRIGGER_NUM > 0)
	if (pmic_get("pmic@20", &pmic_dev) != 0) {
		printf("Cannot get PMIC\n");
		pmic_dev = NULL;
	}

        if (rk_poweron_source & (RK817_PWRON_USB | RK817_PWRON_LONGPRESS)) {
		printf("waiting for key...\n");
		bool pressed = check_power_key();
		int waitkey_timeout = 20;
		int cnt = 0;
		while (waitkey_timeout-- > 0) {
			if (check_power_key() != pressed) {
				pressed = !pressed;
				printf("POWERKEY: %d\n", pressed);
				waitkey_timeout = 10;
				if (++cnt >= CONFIG_PWRKEY_DNL_TRIGGER_NUM * 2) {
					printf("Entering MASKROM...\n");
					mdelay(100);
					flushc();
					writel(BOOT_BROM_DOWNLOAD, CONFIG_ROCKCHIP_BOOT_MODE_REG);
					do_reset(NULL, 0, 0, NULL);
				}
			}
			mdelay(100);
		}
	}
	#endif

	s = bootdelay_process();
	if (cli_process_fdt(&s))
		cli_secure_boot_cmd(s);

	autoboot_command(s);

	cli_loop();
	panic("No CLI available");
}
