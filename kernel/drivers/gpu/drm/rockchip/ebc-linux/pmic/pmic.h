// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

#ifndef __PMIC_H__
#define __PMIC_H__

#include <linux/regulator/consumer.h>
#include <linux/thermal.h>

#define VCOM_MIN_MV		0
#define VCOM_MAX_MV		5110

extern int battery_ntc_temp;

struct ebc_pmic {
	struct device *dev;
	char pmic_name[16];
	void *drvpar;
	void (*pmic_power_req)(struct ebc_pmic *pmic, bool up);
	void (*pmic_pm_suspend)(struct ebc_pmic *pmic);
	void (*pmic_pm_resume)(struct ebc_pmic *pmic);
	int (*pmic_read_temperature)(struct ebc_pmic *pmic, int *t);
	int (*pmic_get_vcom)(struct ebc_pmic *pmic);
	int (*pmic_set_vcom)(struct ebc_pmic *pmic, int value);
};

struct pmic_dev_t {
	struct ebc_pmic *pmic;
	struct regulator *vcom;
	struct thermal_zone_device *tz;
};

extern int ebc_temp_override;
extern u32 ebc_tcor_start;
extern u32 ebc_tcor_percent;

int ebc_pmic_set_vcom(struct ebc_pmic *pmic, int value);
void ebc_pmic_verity_vcom(struct ebc_pmic *pmic);
int ebc_regulator_set_vcom(struct regulator *r, int value);
void ebc_regulator_verity_vcom(struct regulator *r);

static bool vcom_enabled = false;

static inline int pmic_power_on(struct pmic_dev_t *pmic)
{
	if (pmic->pmic) {
		DBG("PMIC power enable\n");
		pmic->pmic->pmic_power_req(pmic->pmic, 1);
		return 0;
	} else {
		if (! vcom_enabled) {
			DBG("VCOM enable\n");
			vcom_enabled = true;
			return regulator_enable(pmic->vcom);
		} else {
			return 0;
		}
	}
}

static inline int pmic_power_off(struct pmic_dev_t *pmic)
{
	if (pmic->pmic) {
		DBG("PMIC power disable\n");
		pmic->pmic->pmic_power_req(pmic->pmic, 0);
		return 0;
	} else {
		if (vcom_enabled) {
			DBG("VCOM disable\n");
			vcom_enabled = false;
			return regulator_disable(pmic->vcom);
		} else {
			return 0;
		}
	}
}

static inline int pmic_suspend(struct pmic_dev_t *pmic)
{
	if (pmic->pmic) {
		pmic->pmic->pmic_pm_suspend(pmic->pmic);
	}
	return 0;
}

static inline int pmic_resume(struct pmic_dev_t *pmic)
{
	if (pmic->pmic) {
		pmic->pmic->pmic_pm_resume(pmic->pmic);
	}

	return 0;
}

#define Ktemp 75

static inline int pmic_read_temp(struct pmic_dev_t *pmic, int *t)
{
	int temp_pmic = 0;
	int temp_bat = 0;
	int ret = 0;
	if (ebc_temp_override >= 0) {
		*t = ebc_temp_override;
		return 0;
	}

	else if (pmic->pmic) {
		ret = pmic->pmic->pmic_read_temperature(pmic->pmic, &temp_pmic);
	} else {
		ret = thermal_zone_get_temp(pmic->tz, &temp_pmic);
		temp_pmic /= 1000;
	}

	temp_bat = battery_ntc_temp / 10;
	if (temp_bat > 0 && temp_pmic > 0) {
		*t = (temp_bat * Ktemp + temp_pmic * (100 - Ktemp)) / 100;
	} else if (temp_bat > 0) {
		*t = temp_bat;
	} else if (temp_pmic > 0) {
		*t = temp_pmic;
	}

	DBG("T pmic: %dC battery: %dC avg: %dC\n", temp_pmic, temp_bat, *t);

	if (ebc_tcor_percent) {
		int tcor = (*t >= (int)ebc_tcor_start) ?
			*t - ((*t - (int)ebc_tcor_start) * ebc_tcor_percent) / 100 : *t;
		DBG("T pmic: correction %dC -> %dC", *t, tcor);
		*t = tcor;
	}
	return ret;
}

static inline int pmic_get_vcom(struct pmic_dev_t *pmic)
{
	if (pmic->pmic)
		return pmic->pmic->pmic_get_vcom(pmic->pmic);
	else
		return regulator_get_voltage(pmic->vcom) / 1000;
}

static inline int pmic_set_vcom(struct pmic_dev_t *pmic, int value)
{
	if (pmic->pmic)
		return ebc_pmic_set_vcom(pmic->pmic, value);
	else
		return ebc_regulator_set_vcom(pmic->vcom, value);
}

static inline void pmic_verity_vcom(struct pmic_dev_t *pmic)
{
	if (pmic->pmic)
		return ebc_pmic_verity_vcom(pmic->pmic);
	else
		return ebc_regulator_verity_vcom(pmic->vcom);
}

int pmic_init(void);
void pmic_deinit(void);

int pmic_setup_device(struct device *dev, struct pmic_dev_t *pmic, u32 vcom);

#endif
