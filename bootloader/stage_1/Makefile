ASM=nasm

SRC_DIR=./
BUILD_DIR=build
KERNEL_BIN=myos.bin

$(BUILD_DIR)/main_floppy.img: $(BUILD_DIR)/main.bin $(BUILD_DIR)/$(KERNEL_BIN)
	cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/main_floppy.img
	cat $(BUILD_DIR)/$(KERNEL_BIN) >> $(BUILD_DIR)/main_floppy.img
	truncate -s 1440k $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main.bin: $(SRC_DIR)/bootloader.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) $(SRC_DIR)/bootloader.asm -f bin -o $(BUILD_DIR)/main.bin

$(BUILD_DIR)/$(KERNEL_BIN): $(SRC_DIR)/$(KERNEL_BIN)
	cp $(SRC_DIR)/$(KERNEL_BIN) $(BUILD_DIR)/$(KERNEL_BIN)
run:
	qemu-system-i386 -fda ./build/main_floppy.img

clean:
	rm -rf ./build
