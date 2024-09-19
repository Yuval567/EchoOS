# EchoOS 

## Bootloading (BIOS)
- First stage bootloader
	- [x] Setup GDT
	- [x] Load the 2nd stage bootloader using FAT
	- [ ] Handoff control to 2nd stage bootloader
- Second stage bootloader
	- [ ] Implement printf (for debugging)
	- [ ] Video mode setup
	- [x] Switch to protected mode
	- [ ] Switch to long mode
	- [x] Handoff execution to kernel

## Kernel
- [ ] Implement video mode driver
- [ ] Implement printf
- [ ] Implement keyboard driver
- [ ] Basic shell (Without special commands)
- [ ] etc...