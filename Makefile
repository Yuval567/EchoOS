# Global Variables
export ASM=nasm
export GCC=i686-elf-gcc
export LD=ld

export KERNEL_BIN=kernel.bin
export BOOTLOADER_BIN=bootloader.bin
export LOADER_BIN=loader.bin

export BUILD_DIR=$(PWD)/build
export OBJ_DIR=$(BUILD_DIR)/obj
export KERNEL_DIR=$(PWD)/kernel
export BOOTLOADER_DIR=$(PWD)/bootloader

# Internal Variables
OS_FLOPPY=os_floppy.img
EMULATOR=qemu-system-i386 -fda 
MAKEFLAGS += --silent # Suppress Make logs

.PHONY: all init bootloader kernel os_image run clear

all: init bootloader kernel os_image
	
init:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(OBJ_DIR)

bootloader: init
	$(MAKE) -C $(BOOTLOADER_DIR)/stage_1
	echo "Bootloader: Stage 1 has been built successfully!"

	$(MAKE) -C $(BOOTLOADER_DIR)/stage_2
	echo "Bootloader: Stage 2 has been built successfully!"

kernel: init
	$(MAKE) -C $(KERNEL_DIR)
	echo "Kernel has been built successfully!"

os_image: bootloader kernel
	cp $(BUILD_DIR)/$(BOOTLOADER_BIN) $(BUILD_DIR)/$(OS_FLOPPY)
	cat $(BUILD_DIR)/$(LOADER_BIN) >> $(BUILD_DIR)/$(OS_FLOPPY)
	cat $(BUILD_DIR)/$(KERNEL_BIN) >> $(BUILD_DIR)/$(OS_FLOPPY)
	
	# Truncate file size to 1440kb (floppy disk size standard)
	truncate -s 1440k $(BUILD_DIR)/$(OS_FLOPPY) 
	echo "OS floppy disk image has been built successfully!"

run: os_image
	echo "Running os floppy disk image..."
	$(EMULATOR) $(BUILD_DIR)/$(OS_FLOPPY)

clear:
	rm -rf $(BUILD_DIR)
	echo "Removed build directory."