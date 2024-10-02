all: $(BOOTLOADER_BIN)

$(BOOTLOADER_BIN): $(BOOTLOADER_DIR)/stage_1/mbr.asm
	$(ASM) -I$(BOOTLOADER_DIR) $< -f bin -o $(BUILD_DIR)/$@