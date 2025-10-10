# Disk Routines & Floppy Disk Usage

## Overview

EchoOS currently uses a floppy disk image (`os_floppy.img`) as its boot and storage medium. All disk routines in the bootloader are designed to work with the standard 1.44MB floppy disk geometry, which is compatible with BIOS disk services.

## Floppy Disk Geometry

- **Heads:** 2
- **Sectors per Track:** 18
- **Sector Size:** 512 bytes
- **Total Size:** 1,474,560 bytes (1.44MB)

These values are defined in the Makefile and used throughout the bootloader for disk operations.

## CHS vs. LBA Addressing

### CHS (Cylinder-Head-Sector)

CHS is the traditional way BIOS and early hardware addressed sectors on a disk. Each sector is identified by three numbers:
- **Cylinder:** The track number on the disk.
- **Head:** The read/write head (for double-sided disks).
- **Sector:** The sector number within the track (starts at 1).

For a 1.44MB floppy:
- Cylinders: 80 (tracks per side)
- Heads: 2 (sides)
- Sectors per Track: 18

### LBA (Logical Block Addressing)

LBA is a linear addressing scheme where each sector is given a unique number, starting from 0. Modern software prefers LBA because it simplifies addressing, but BIOS disk services still require CHS.

**Conversion Example:**
To convert an LBA value to CHS:
- `Cylinder = LBA / (Heads × Sectors per Track)`
- `Head = (LBA / Sectors per Track) % Heads`
- `Sector = (LBA % Sectors per Track) + 1`

The bootloader includes routines to perform this conversion before calling BIOS interrupts.

## Disk Layout and Boot Stages

- **Stage 1 Bootloader:**  
  The first 512 bytes of the floppy disk (LBA 0, CHS 0/0/1) contain the Stage 1 bootloader. This is the Master Boot Record (MBR) and is loaded automatically by the BIOS at boot.

- **Stage 2 Bootloader:**  
  Immediately follows Stage 1 on the disk. The number of sectors to load for Stage 2 is defined in the Makefile as `LOADER_NUM_SECTORS`. This value is calculated based on the size of the Stage 2 binary, rounded up to the nearest sector.

- **Kernel:**  
  The kernel binary is placed after the Stage 2 loader. Its size in sectors is defined as `KERNEL_NUM_SECTORS` in the Makefile, also calculated by rounding up the kernel size to the nearest sector.


## Disk Access in the Bootloader

The bootloader uses BIOS interrupt `0x13` to read sectors from the floppy disk. Since BIOS expects addresses in CHS format, the bootloader includes routines to convert LBA to CHS.

### Key Routines

- **LBA to CHS Conversion:**  
  Converts a logical sector number (LBA) into cylinder, head, and sector values for BIOS calls.

- **BIOS Disk Read:**  
  Uses `int 0x13` with function `0x02` to read sectors from the disk into memory.  
  - Inputs: drive number, CHS address, number of sectors, memory address  
  - Returns: success or error code

- **Error Handling:**  
  If a disk read fails, the bootloader prints an error message and halts.


## Floppy Disk Image in the Build System

- The Makefile creates a 1.44MB floppy disk image (`os_floppy.img`) by concatenating the bootloader and kernel binaries.
- The image is padded or truncated to exactly 1,474,560 bytes to match the standard floppy size.
- The image can be run in QEMU or written to a real floppy disk for testing.

## Summary

- EchoOS bootloader routines are tailored for BIOS-based floppy disk access.
- All disk reads are performed using BIOS interrupts and CHS addressing, with LBA-to-CHS conversion handled in assembly.
- The system assumes a standard 1.44MB floppy disk geometry for all disk operations.
- Stage 1 is always stored in the first sector (LBA 0), and subsequent stages are loaded based on their calculated sector counts.
