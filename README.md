# U-boot for KITRA710C and KITRAGTI

## 1. Introduction
This is a fork of 'u-boot-artik', adding support for Kitra710C and KitraGTI.
For bootloader is the same for both board, and fix the following issues with standard artik bootloader:

- Random eth mac address in userspace
- in-boot ethernet support

## 2. Build guide
### 2.1 Install cross compiler

- You'll need an arm64 cross compiler
```
sudo apt-get install gcc-aarch64-linux-gnu device-tree-compiler
```
If you can't install the above toolchain, you can use linaro toolchain.
```
wget https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/aarch64-linux-gnu/gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
tar xf gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
export PATH=~/gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu/bin:$PATH
```

### 2.2 Build u-boot

```
make ARCH=arm kitragti_kitra710C_defconfig
./mk_uboot.sh
```

## 3. Update Guide
You can update the u-boot through fastboot or micro sd card(ext4 partition)

### 3.1 Fastboot
You should prepare a micro USB cable to connect between the board and host PC

- Install android-tools-fastboot
```
sudo apt-get install android-tools-fastboot
wget -S -O - http://source.android.com/source/51-android.rules | sed "s/<username>/$USER/" | sudo tee >/dev/null /etc/udev/rules.d/51-android.rules; sudo udevadm control --reload-rules
```

- Insert the USB cable(not MicroUSB Cable) into your board. Enter u-boot shell mode during boot countdown:
```
Net:   No ethernet found.
Hit any key to stop autoboot:  0
ARTIK710 #
ARTIK710 #
ARTIK710 # fastboot 0
```

- You'll need to upload the partmap_emmc.txt prior than uploading the binaries. It can be downloaded from boot-firmwares-artik710. On your Host PC(Linux), flash the u-boot using below command
```
sudo fastboot flash partmap partmap_emmc.txt
sudo fastboot flash fip-nonsecure fip-nonsecure.img
sudo fastboot flash env params.bin
sudo fastboot reboot
```


### 3.2 microSD Card
Prepare a micro SD card and format to ext4 file system.
```
sudo mkfs.ext4 /dev/sd[X]1
sudo mount /dev/sd[X]1 /mnt
```

- Copy compiled binaries(fip-nonsecure.img, params.bin) into a micro sd card.
```
sudo cp fip-nonsecure.img params.bin partmap_emmc.txt /mnt
sudo umount /mnt
```
- Insert the microSD card into your board and enter u-boot shell during boot countdown
```
sd_recovery mmc 1:1 48000000 partmap_emmc.txt
```

