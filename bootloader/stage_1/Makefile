ASM=nasm 
GCC=i686-elf-gcc
LD=ld

SRC_DIR=./
BUILD_DIR=build
OS_BIN=myos.bin
KERNEL_BIN=kernel.bin
BOOTLOADER_BIN=bootloader.bin
FLOPPY_IMAGE=main_floppy.img

.PHONY: all clean run

all: $(BUILD_DIR)/$(FLOPPY_IMAGE)

$(BUILD_DIR)/$(BOOTLOADER_BIN): $(SRC_DIR)/bootloader.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) $< -f bin -o $@

$(BUILD_DIR)/kernel_entry.o: $(SRC_DIR)/kernel_entry.asm
	$(ASM) $< -f elf -o $@

$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel.c
	$(GCC) -m32 -ffreestanding -std=gnu99 -O2 -Wall -Wextra -c $< -o $@

$(BUILD_DIR)/$(KERNEL_BIN): $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/kernel.o
	$(LD) -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary --entry main

$(BUILD_DIR)/$(FLOPPY_IMAGE): $(BUILD_DIR)/$(BOOTLOADER_BIN) $(BUILD_DIR)/$(KERNEL_BIN)
	cp $< $@
	cat $(word 2,$^) >> $@
	truncate -s 1440k $@

run: $(BUILD_DIR)/$(FLOPPY_IMAGE)
	qemu-system-i386 -fda $<

clear:
	rm -rf ./$(BUILD_DIR)
