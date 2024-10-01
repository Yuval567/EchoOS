all: $(BOOTLOADER_BIN)

$(BOOTLOADER_BIN): $(BOOTLOADER_DIR)/bootloader.asm
	$(ASM) $< -f bin -o $(BUILD_DIR)/$@