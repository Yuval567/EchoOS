# EchoOS 

## Bootloading (BIOS)
- First stage bootloader
	- [x] Setup stack & data segments.
	- [x] Load the 2nd stage bootloader using disk bios interrupts.
	- [x] Handoff control to 2nd stage bootloader

- Second stage bootloader
	- [x] Enable A20 Gate
	- [x] Enter unreal mode.
	- [x] Setup GDT
	- [x] Load kernel to an high memory address.
	- [x] Switch to protected mode
	- [ ] Video mode setup
	- [ ] Switch to long mode
	- [x] Handoff execution to kernel

## Kernel
- [ ] Implement video mode driver
- [x] Implement printf
- [ ] Implement keyboard driver
- [ ] Basic shell (Without special commands)
- [ ] etc...