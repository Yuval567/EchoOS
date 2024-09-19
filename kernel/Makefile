ENTRYPOINT=main

all: $(KERNEL_BIN)

$(BUILD_DIR)/kernel_entry.o: $(KERNEL_SRC_DIR)/kernel_entry.asm
	$(ASM) $< -f elf -o $@

$(BUILD_DIR)/kernel.o: $(KERNEL_SRC_DIR)/kernel.c
	$(GCC) -m32 -ffreestanding -std=gnu99 -O2 -Wall -Wextra -c $< -o $@

$(KERNEL_BIN): $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/kernel.o
	$(LD) -m elf_i386 -o $(BUILD_DIR)/$@ -Ttext 0x1000 $^ --oformat binary --entry $(ENTRYPOINT)