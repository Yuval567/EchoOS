all: $(LOADER_BIN)

$(LOADER_BIN): $(BOOTLOADER_DIR)/stage_2/loader.asm
	$(ASM) -I$(BOOTLOADER_DIR) $< -f bin -o $(BUILD_DIR)/$@
	truncate -s 17920 $(BUILD_DIR)/$@ 