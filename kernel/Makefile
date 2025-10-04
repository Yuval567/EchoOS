ENTRYPOINT=main
CFLAGS=-m64 -ffreestanding -fno-pic -mcmodel=kernel -mno-red-zone -std=gnu99 -O2 -Wall -Wextra -I$(KERNEL_DIR)/include
OBJFILES=$(OBJ_DIR)/vga.o $(OBJ_DIR)/io_ports.o $(OBJ_DIR)/idt.o $(OBJ_DIR)/keyboard.o \
	$(OBJ_DIR)/isr_keyboard.o $(OBJ_DIR)/isr_stub.o $(OBJ_DIR)/terminal_logic.o 

all: $(KERNEL_BIN)

vpath %.c $(KERNEL_DIR)/src/drivers $(KERNEL_DIR)/src/terminal

$(OBJ_DIR)/%.o: %.c  
	$(GCC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(KERNEL_DIR)/interrupts/%.asm $(KERNEL_DIR)/kernel_entry.asm
	$(ASM) $< -f elf64 -o $@

$(OBJ_DIR)/kernel.o: $(KERNEL_DIR)/kernel.c $(OBJFILES)
	$(GCC) $(CFLAGS) -c $< -o $@

$(KERNEL_BIN): $(OBJ_DIR)/kernel.o $(OBJFILES)
	$(LD) -m elf_x86_64 -o $(BUILD_DIR)/$@ -Ttext $(KERNEL_LOAD_ADDRESS) $^ --oformat binary --entry $(ENTRYPOINT)