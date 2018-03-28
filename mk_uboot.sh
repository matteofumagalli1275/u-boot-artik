make ARCH=arm CROSS_COMPILE=aarch64-linux-gnu-
cp `find . -name "env_common.o"` copy_env_common.o

aarch64-linux-gnu-objcopy -O binary --only-section=.rodata.default_environment `find . -name "copy_env_common.o"`
tr '\0' '\n' < copy_env_common.o | grep '=' > default_envs.txt
cp default_envs.txt default_envs.txt.orig
tools/mkenvimage -s 16384 -o params.bin default_envs.txt

tools/fip_create/fip_create \
		--dump --bl33 u-boot.bin \
			fip-nonsecure.bin

tools/nexell/SECURE_BINGEN \
		-c S5P6818 -t 3rdboot \
			-n tools/nexell/nsih/raptor-64.txt \
				-i fip-nonsecure.bin \
					-o fip-nonsecure.img \
						-l 0x7df00000 -e 0x00000000

