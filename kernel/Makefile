ENTRYPOINT=main
CFLAGS=-m32 -ffreestanding -std=gnu99 -O2 -Wall -Wextra -I$(KERNEL_DIR)/include 
OBJFILES=$(OBJ_DIR)/kernel.o $(OBJ_DIR)/vga.o $(OBJ_DIR)/ports.o

all: $(KERNEL_BIN)

$(OBJ_DIR)/%.o: $(KERNEL_DIR)/src/drivers/%.c
	$(GCC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/kernel_entry.o: $(KERNEL_DIR)/kernel_entry.asm
	$(ASM) $< -f elf -o $@

$(OBJ_DIR)/kernel.o: $(KERNEL_DIR)/kernel.c $(OBJ_DIR)/vga.o $(OBJ_DIR)/ports.o
	$(GCC) $(CFLAGS) -c $< -o $@

$(KERNEL_BIN): $(OBJFILES)
	$(LD) -m elf_i386 -o $(BUILD_DIR)/$@ -Ttext 0x100000 $^ --oformat binary --entry $(ENTRYPOINT)