CLANG_INC = -I/usr/local/include/libclc -include /usr/local/include/clc/clc.h
CLANG_PAR = -S -emit-llvm -Xclang -mlink-bitcode-file -Xclang /usr/local/lib/clc/verde-amdgcn--.bc
CLANG_PAR += -Dcl_clang_storage_class_specifiers -target amdgcn-unknown-m2s-unknown -mcpu=verde
LLC_PAR = -march=amdgcn -mcpu=verde

all: MatrixTranspose ir asm bin

MatrixTranspose:
	@-g++ *.cpp -I/root/part4/include -I/root/part4/include/SDKUtil -m32 -static -lm -lrt -pthread -l:libm2s-opencl.a -ldl -o MatrixTranspose

ir: MatrixTranspose_Kernels.cl
	@-echo "Frontend: OpenCL source code (.cl) to LLVM IR file (.ll)"
	@-clang $(CLANG_INC) $(CLANG_PAR) $<

asm: MatrixTranspose_Kernels.ll
	@-echo "Backend: LLVM IR file (.ll) to Assembly (.s)"
	@-llc $(LLC_PAR) $< 

bin: MatrixTranspose_Kernels.s
	@-echo "Assembler: Assembly file (.s) to kernel binary (.bin)"
	@-pretobin.sh $<
	@-m2c --si2bin $<

disasm:
	@-m2s --si-disasm MatrixTranspose_Kernels.bin

run:
	@-m2s --si-sim functional ./MatrixTranspose --load MatrixTranspose_Kernels.bin

sim:
	@-m2s --si-sim detailed ./MatrixTranspose --load MatrixTranspose_Kernels.bin

	
clean:
	rm -f MatrixTranspose *.ll *.s *.bin 
