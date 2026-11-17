// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

#define LOG_TAG  "EBC pmic "

#include <linux/device.h>
#include <linux/module.h>
#include <linux/string.h>
#include <linux/soc/rockchip/rk_vendor_storage.h>
#include <linux/i2c.h>

#include "../ebc_log.h"

#include "pmic.h"

int ebc_temp_override = -1;
u32 ebc_tcor_start = 0;
u32 ebc_tcor_percent = 0;

#define EINK_VCOM_MAX 64
static int vcom = 0;
static int vcom_dts = 0;
static int get_vcom(void);

int pmic_mfd_init(void);
void pmic_mfd_deinit(void);
int tps65185_init(void);
void tps65185_deinit(void);
int sy7636a_regulator_init(void);
void sy7636a_regulator_deinit(void);
int sy7636a_thermal_init(void);
void sy7636a_thermal_deinit(void);
int sy7673a_init(void);
void sy7673a_deinit(void);
int fp9931_regulator_init(void);
void fp9931_regulator_deinit(void);
int fp9931_thermal_init(void);
void fp9931_thermal_deinit(void);

int ebc_pmic_set_vcom(struct ebc_pmic *pmic, int value)
{
	int ret;
	char data[EINK_VCOM_MAX] = { 0 };

	/* check vcom value */
	if (value <= VCOM_MIN_MV || value > VCOM_MAX_MV) {
		dev_err(pmic->dev, "vcom value should be %d~%d\n", VCOM_MIN_MV, VCOM_MAX_MV);
		return -1;
	}
	dev_info(pmic->dev, "set chip vcom to: %dmV\n", value);

	/* set pmic vcom */
	pmic->pmic_set_vcom(pmic, value);

	/* store vendor storage */
	snprintf(data, sizeof(data), "%d", value);
	dev_info(pmic->dev, "store vcom %d to vendor storage\n", value);

	ret = rk_vendor_write(EINK_VCOM_ID, (void *)data, EINK_VCOM_MAX);
	if (ret < 0) {
		dev_err(pmic->dev, "%s failed to write vendor storage\n", __func__);
		return ret;
	}

	return 0;
}

void ebc_pmic_verity_vcom(struct ebc_pmic *pmic)
{
	int ret;
	int value_chip;
	int value_vendor;

	//check vcom value
	value_vendor = get_vcom();
	if (value_vendor <= VCOM_MIN_MV || value_vendor > VCOM_MAX_MV) {
		dev_err(pmic->dev, "invaild vcom value %d from vendor storage\n", value_vendor);
		return;
	}
	value_chip = pmic->pmic_get_vcom(pmic);
	if (value_chip != value_vendor) {
		dev_info(pmic->dev, "chip_vcom %d != vendor_vcom %d, set vcom from vendor\n", value_chip, value_vendor);
		ret = pmic->pmic_set_vcom(pmic, value_vendor);
		if (ret) {
			dev_err(pmic->dev, "set vcom value failed\n");
		}
	}

	return;
}

int ebc_regulator_set_vcom(struct regulator *r, int value)
{
	int ret;
	char data[EINK_VCOM_MAX] = { 0 };

	/* check vcom value */
	if (value <= VCOM_MIN_MV || value > VCOM_MAX_MV) {
		pr_err("vcom value should be %d~%d\n", VCOM_MIN_MV, VCOM_MAX_MV);
		return -1;
	}

	pr_info("set chip vcom to: %dmV\n", value);

	ret = regulator_set_voltage(r, value * 1000, VCOM_MAX_MV * 1000);
	if (ret) {
		pr_err("Failed to set vcom:%d\n", ret);
		return ret;
	}

	/* store vendor storage */
	snprintf(data, sizeof(data), "%d", value);
	pr_info("store vcom %d to vendor storage\n", value);

	ret = rk_vendor_write(EINK_VCOM_ID, (void *)data, EINK_VCOM_MAX);
	if (ret < 0) {
		pr_err("%s failed to write vendor storage\n", __func__);
		return ret;
	}

	return 0;
}

void ebc_regulator_verity_vcom(struct regulator *r)
{
	int ret;
	int value_chip;
	int value_vendor;

	value_vendor = get_vcom();
	if (value_vendor <= VCOM_MIN_MV || value_vendor > VCOM_MAX_MV) {
		pr_err("invaild vcom value %d from vendor storage\n", value_vendor);
		return;
	}

	value_chip = regulator_get_voltage(r) / 1000;
	if (value_chip != value_vendor) {
		pr_info("chip_vcom %d != vendor_vcom %d, set vcom from vendor\n", value_chip,
			value_vendor);
		ret = regulator_set_voltage(r, value_vendor * 1000, VCOM_MAX_MV * 1000);
		if (ret)
			pr_err("set vcom value failed\n");
	}
}

module_param(vcom, int, 0644);

/**
 * If the vendor vcom value is valid, return vendor vcom.
 * Otherwise, if the dts vcom value is valid, return dts vcom.
 * Otherwise, return the default vcom.
 */
static int get_vcom(void)
{
	#define VCOM_DEFAULT_VALUE	1650
	int vcom_value = 0;

	if (vcom == 0) {
		// vcom=0 indicates that the vcom value has not been read from vendor storage.
		// In this case, it should be read from vendor storage once first.
		char data[EINK_VCOM_MAX+1] = { 0 };
		if (rk_vendor_read(EINK_VCOM_ID, (void *)data, EINK_VCOM_MAX) > 0) {
			pr_info("Read vendor vcom: %smV\n", data);
			if (kstrtoint(data, 10, &vcom) != 0 || vcom == 0) {
				vcom = -1; // The value stored by vendor vcom is not a number, or it may be 0.
			}
		} else {
			pr_info("Read vendor vcom failed\n");
			vcom = -1;
		}
	}

	if (vcom > VCOM_MIN_MV && vcom <= VCOM_MAX_MV) {
		vcom_value = vcom;
		pr_info("use vendor vcom %d\n", vcom_value);
	} else if (vcom_dts > VCOM_MIN_MV && vcom_dts <= VCOM_MAX_MV) {
		vcom_value = vcom_dts;
		pr_info("use dts vcom %d\n", vcom_value);
	} else {
		vcom_value = VCOM_DEFAULT_VALUE;
		pr_info("use default vcom %d\n", vcom_value);
	}

	return vcom_value;
}

int pmic_setup_device(struct device *dev, struct pmic_dev_t *pmic, u32 vcom)
{
	int ret;
	struct device_node *pmic_node;
	struct i2c_client *pmic_client;
	const char *tz_name;

	vcom_dts = vcom;

	pmic_node = of_parse_phandle(dev->of_node, "pmic", 0);
	if (!pmic_node) {
		ERR("cannot find pmic node\n");
		return -ENODEV;
	}

	pmic_client = of_find_i2c_device_by_node(pmic_node);
	of_node_put(pmic_node);
	if (!pmic_client) {
		ERR("cannot find pmic i2c client\n");
		return -ENODEV;
	}
	device_link_add(dev, &pmic_client->dev, DL_FLAG_STATELESS);

	pmic->pmic = i2c_get_clientdata(pmic_client);
	if (pmic->pmic == NULL) {
		ERR("Not found pmic legacy driver, try new driver\n");

		/* try to use regulator framework */
		pmic->vcom = devm_regulator_get(&pmic_client->dev, "vcom");
		if (IS_ERR(pmic->vcom)) {
			ERR("Failed to get vcom regulator\n");
			return -ENODEV;
		}

		ret = device_property_read_string(&pmic_client->dev, "thermal-zone", &tz_name);
		if (ret) {
			ERR("Failed to get thermal zone name\n");
			return -ENODEV;
		} else {
			pmic->tz = thermal_zone_get_zone_by_name(tz_name);
			if (IS_ERR(pmic->tz)) {
				ERR("Failed to get thermal device %s\n", tz_name);
				return -ENODEV;
			}
		}
	}

	return 0;
}

int pmic_init(void)
{
	int ret = 0;
#ifdef CONFIG_EBC_TPS65185_SENSOR
	if (ret == 0) ret = tps65185_init();
#endif
#ifdef CONFIG_EBC_SY7636A_PMIC
	if (ret == 0) ret = sy7636a_regulator_init();
	if (ret == 0) ret = sy7636a_thermal_init();
#endif
#ifdef CONFIG_EBC_SY7673A_PMIC
	if (ret == 0) ret = sy7673a_init();
#endif
#ifdef CONFIG_EPD_FP9931_PMIC
	if (ret == 0) ret = fp9931_regulator_init();
	if (ret == 0) ret = fp9931_thermal_init();
#endif
	if (ret == 0) ret = pmic_mfd_init();
	return ret;
}

void pmic_deinit(void)
{
	pmic_mfd_deinit();
#ifdef CONFIG_EBC_TPS65185_SENSOR
	tps65185_deinit();
#endif
#ifdef CONFIG_EBC_SY7636A_PMIC
	sy7636a_regulator_deinit();
	sy7636a_thermal_deinit();
#endif
#ifdef CONFIG_EBC_SY7673A_PMIC
	sy7673a_deinit();
#endif
#ifdef CONFIG_EPD_FP9931_PMIC
	fp9931_regulator_deinit();
	fp9931_thermal_deinit();
#endif
}

