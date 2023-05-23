# all: myfile

# myfile: myfile.o
# 	gcc -m32 -o myfile myfile.o
# myfile.o: myfile.asm
# 	nasm -f elf32 myfile.asm -o myfile.o
# .PHONY: clean

# clean:
# 	rm -f myfile.o myfile
all: print_multi

print_multi: print_multi.o
	gcc -m32 -o print_multi print_multi.o
print_multi.o: print_multi.asm
	nasm -f elf32 print_multi.asm -o print_multi.o
.PHONY: clean

clean:
	rm -f print_multi.o print_multi