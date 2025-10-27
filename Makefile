# ----------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------
NASM = nasm                        # NASM assembler command
QEMU = qemu-system-x86_64          # QEMU emulator command

BOOT = boot.asm                     # Bootloader source file
KERNEL = kernel.asm                 # Kernel source file
IMG = norOS.img                     # Output disk image

# ----------------------------------------------------------------------
# Default target
# ----------------------------------------------------------------------
all: $(IMG) run                     # Build the disk image and immediately run it in QEMU

# ----------------------------------------------------------------------
# Create the disk image by concatenating bootloader + kernel
# ----------------------------------------------------------------------
$(IMG): bin/boot.bin bin/kernel.bin
	cat bin/boot.bin bin/kernel.bin > $(IMG)

# ----------------------------------------------------------------------
# Assemble the bootloader
# ----------------------------------------------------------------------
bin/boot.bin: $(BOOT)
	mkdir -p bin                       # Create bin/ directory if it doesn't exist
	$(NASM) -f bin -o bin/boot.bin $(BOOT)

# ----------------------------------------------------------------------
# Assemble the kernel
# ----------------------------------------------------------------------
bin/kernel.bin: $(KERNEL)
	mkdir -p bin                       # Ensure bin/ exists
	$(NASM) -f bin -o bin/kernel.bin $(KERNEL)

# ----------------------------------------------------------------------
# Run the disk image in QEMU
# ----------------------------------------------------------------------
run: $(IMG)
	$(QEMU) -drive format=raw,file=$(IMG)

# ----------------------------------------------------------------------
# Mark targets as phony to prevent conflicts with files of the same name
# ----------------------------------------------------------------------
.PHONY: clean run

# ----------------------------------------------------------------------
# Clean generated files
# ----------------------------------------------------------------------
clean:
	rm -rf bin $(IMG)
