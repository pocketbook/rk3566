# PocketBook RK3566 e-readers: GPL source code

Source code of the open-source parts of the firmware of the PocketBook
e-readers built on the Rockchip RK3566 (BSP snapshot `d5201c15f7b4`).

| Directory | Contents |
|---|---|
| `kernel/` | Linux 5.10.226 |
| `u-boot/` | U-Boot 2017.09 |
| `rkbin/` | Rockchip loader binaries used by the U-Boot build |
| `buildroot/` | Buildroot of the Rockchip SDK (2021.11, packages updated to 2025.08.1) with the device configurations |
| `buildroot-external/` | PocketBook external tree for Buildroot: build scripts, root file system overlays |
| `userspace/` | Buildroot packages of the root file system and the recovery image |

Models (`MODEL`): `1030` (InkPad One), `5084`, `635`, `635k3`, `8020`.

## Setup

Arm GNU Toolchain 15.2.Rel1 for `aarch64-none-linux-gnu` from
<https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads>, plus make,
gcc, bc, bison, flex, libssl-dev, libelf-dev, python3 and python2.

```sh
export CROSS_COMPILE=/path/to/toolchain/bin/aarch64-none-linux-gnu-
export MODEL=1030
```

## Kernel

```sh
cd kernel
make ARCH=arm64 "${MODEL}_defconfig"
make ARCH=arm64 -j"$(nproc)" "${MODEL}.img"
```

Build inside the source tree, without `O=`. Output: `arch/arm64/boot/Image`,
`arch/arm64/boot/dts/rockchip/${MODEL}.dtb`, `resource.img` and the modules.
The E-Ink display driver `drivers/gpu/drm/rockchip/ebc-linux/` is provided as
assembler files (`*.S`).

## Boot image

From the repository root, after the kernel:

```sh
sed -e "s~@KERNEL_DTB@~$PWD/kernel/arch/arm64/boot/dts/rockchip/${MODEL}.dtb~" \
    -e "s~@KERNEL_IMG@~$PWD/kernel/arch/arm64/boot/Image~" \
    -e "s~@RESOURCE_IMG@~$PWD/kernel/resource.img~" \
    boot.its > boot-${MODEL}.its
rkbin/tools/mkimage -f boot-${MODEL}.its -E -p 0x800 boot.img
```

## U-Boot

```sh
cd u-boot
./make.sh CROSS_COMPILE="$CROSS_COMPILE" "pb${MODEL}"
```

Output: `uboot.img` and the loader `rk356x_spl_loader_v1.25.114.bin`.

## Flashing

Connect the device by USB, switch it on and press the power button five times
within two seconds: it enters the Rockchip MASKROM mode (USB `2207:350a`).
Then, with [rkdeveloptool](https://github.com/rockchip-linux/rkdeveloptool):

```sh
rkdeveloptool db u-boot/rk356x_spl_loader_v1.25.114.bin
rkdeveloptool wlx boot_a boot.img
rkdeveloptool wlx boot_b boot.img
rkdeveloptool wlx uboot u-boot/uboot.img
rkdeveloptool rd
```

To keep a copy of the original partitions, print the partition table with
`rkdeveloptool ppt` and read them with `rkdeveloptool rl <start> <sectors> <file>`
before writing.

## User space

`userspace/rootfs/` and `userspace/recovery/` are the `make legal-info` output
of Buildroot, the same for all models:

- `sources/<package>-<version>/`: the original source archive and the patches,
  applied in the order of the `series` file with `patch -p1`;
- `licenses/`: the licence texts;
- `manifest.csv`: package versions, licences and download sites;
- `buildroot.config`: the Buildroot configuration.

## Buildroot

`buildroot/` and `buildroot-external/` are the build scripts of the root file
system and the recovery image. Configurations:
`buildroot/configs/rockchip_${MODEL}_defconfig` (root file system) and
`buildroot/configs/rockchip_${MODEL}_recovery_defconfig` (recovery).

```sh
mkdir -p buildroot/dl/hunspell app/glmark2
cp userspace/rootfs/sources/hunspell-origin_master/*.tar.gz buildroot/dl/hunspell/
tar -xzf userspace/rootfs/sources/glmark2-custom/glmark2-custom.tar.gz \
    --strip-components=1 -C app/glmark2

cd buildroot
make O="$PWD/output/rockchip_${MODEL}" BR2_EXTERNAL="$PWD/../buildroot-external" \
    "rockchip_${MODEL}_defconfig"
make O="$PWD/output/rockchip_${MODEL}" busybox
```

The last command builds the toolchain and one package; any other open-source
package of the configuration is built the same way, by its name. The kernel
headers are taken from `kernel/`. The other packages are downloaded from the
sites in `manifest.csv`, or taken from `userspace/*/sources/`.

Not included, so a complete firmware image cannot be built from this
repository and `make legal-info` stops at the first missing package (its
output is `userspace/`):

- the PocketBook application software and its Buildroot packages (`ebrmain`,
  `xlog`), the waveform and logo images, the update signing tools;
- the Rockchip packages under licences that do not require publication:
  `recovery`, `rkebc`, `rkscript`, `rktoolkit`, `rockchip-mali`,
  `rockchip-mpp`, `rockchip-rga` (`external/` in the Rockchip SDK);
- the SSH host keys of the root file system overlays.

The options for these parts are removed from the device configurations; the
rest of each configuration is the one used for the firmware.
