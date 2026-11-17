
#define ILITEK_BOOT_UPDATE_ILI_VER	    0x00000001

#define ILITEK_BOOT_UPDATE_DEF_ID       0

struct ili_struct {
    unsigned char *buf;
    unsigned int size;
};

enum ili_select_type {
    ili_default = 0,
    ili_by_sensor_id,
};

static const int __ili_select_type__ = ili_default;

/*
 * Built-in panel firmware, selected per device from the defconfig.
 * See ILITEK_UPGRADE_FW_FILE in Kconfig - this must match the panel.
 */
#ifdef CONFIG_ILITEK_UPGRADE_FW_FILE
#define ILITEK_UPGRADE_FW_FILE      CONFIG_ILITEK_UPGRADE_FW_FILE
#else
#define ILITEK_UPGRADE_FW_FILE      "IL250120J4103E00_V07000004_00000000_0xA9C9_20251205.ili"
#endif

/* DO NOT remove CTPM_FW, it should be took as "default" fw */
static unsigned char CTPM_FW[] = {
    #include ILITEK_UPGRADE_FW_FILE
};

#ifdef ILITEK_READ_FW_FROM_FS
static struct ili_struct ili_arr[] = {
    /* this variable is used for non ili_default ili_select_type */
    [ILITEK_BOOT_UPDATE_DEF_ID] = { .buf = NULL, .size = 0 },
};
#else
static struct ili_struct ili_arr[] = {
    /* this variable is used for non ili_default ili_select_type */
    [ILITEK_BOOT_UPDATE_DEF_ID] = { .buf = CTPM_FW, .size = sizeof(CTPM_FW) },
};
#endif
