all: $(BOOTLOADER_BIN)

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC_DIR)/bootloader.asm
	$(ASM) $< -f bin -o $(BUILD_DIR)/$@