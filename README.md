# EchoOS 

## Bootloading (BIOS)
- First stage bootloader
	- [x] Setup stack & data segments.
	- [x] Load the 2nd stage bootloader using disk bios interrupts.
	- [ ] Handoff control to 2nd stage bootloader

- Second stage bootloader
	- [x] Setup GDT
	- [ ] Video mode setup
	- [x] Switch to protected mode
	- [ ] Switch to long mode
	- [x] Handoff execution to kernel

## Kernel
- [ ] Implement video mode driver
- [x] Implement printf
- [ ] Implement keyboard driver
- [ ] Basic shell (Without special commands)
- [ ] etc...