# Automatically generate lists of sources using wildcards. 
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

# TODO: Make sources dep on all header files.

# Convert the *.c filenames to *.o to give a list of object files to build

OBJ = ${C_SOURCES:.c=.o}

# Defaul build target
all: os-image
  
# Run bochs to simulate booting of our code.
run: all 
	qemu-system-i386 -drive file=os-image,index=0,if=floppy

# This is the actual disk image that the computer loads
# which is the combination of our compiled bootsector and kernel 
os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os-image

# This builds the binary of our kenel from two object files:
#	- the kernel_entry, which jumps to main() in our kenel
#	- the compiled C kernel
kernel.bin: kernel/kernel_entry.o ${OBJ}
	x86_64-elf-ld -m elf_i386 -s -o $@ -Ttext 0x1000 $^ --oformat binary

# Generic rule for compiling C code to an object file
# For simplicity, we C files depend on all header files.

%.o : %.c ${HEADERS}
	x86_64-elf-gcc -m32 -ffreestanding -c $< -o $@

# Assemble the kernel_entry.
%.o : %.asm
	nasm $< -f elf -o $@

%.bin : %.asm
	nasm $< -f bin -o $@

clean:
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin drivers/*.o