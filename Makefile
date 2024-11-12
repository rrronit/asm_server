# Makefile for an assembly project using NASM and LD

# Define assembler and linker
ASM = nasm
LD = ld

# Compiler flags
ASMFLAGS = -f elf64        # Assemble for 64-bit Linux
LDFLAGS = -m elf_x86_64    # Link for 64-bit Linux

# Source and target files
SRC = server.asm
OBJ = server.o
TARGET = server

# Default target
all: $(TARGET)

# Compile source file to object file
$(OBJ): $(SRC)
	$(ASM) $(ASMFLAGS) -o $@ $<

# Link object file to create the executable
$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

# Clean up generated files
clean:
	rm -f $(OBJ) $(TARGET)

# Run the program
run: $(TARGET)
	./$(TARGET)
