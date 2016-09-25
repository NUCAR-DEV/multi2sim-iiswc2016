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
	@-pretobin.sh MatrixTranspose_Kernels.s 

asm_is_pre_ra: MatrixTranspose_Kernels.ll
	@-echo "Backend: LLVM IR file (.ll) to Assembly (.s), pre-RA fast instruction scheduler"
	@-llc $(LLC_PAR) $< --pre-RA-sched=fast -o MatrixTranspose_Kernels_pre_ra.s
	@-pretobin.sh MatrixTranspose_Kernels_pre_ra.s 

asm_is_post_ra: MatrixTranspose_Kernels.ll
	@-echo "Backend: LLVM IR file (.ll) to Assembly (.s), post-RA si instruction scheduler"
	@-llc $(LLC_PAR) $< --misched=si -o MatrixTranspose_Kernels_post_ra.s
	@-pretobin.sh MatrixTranspose_Kernels_post_ra.s 

diff_is:
	@-vim -O MatrixTranspose_Kernels.s MatrixTranspose_Kernels_pre_ra.s MatrixTranspose_Kernels_post_ra.s

asm_regalloc: MatrixTranspose_Kernels.ll
	@-echo "Backend: LLVM IR file (.ll) to Assembly (.s), fast register allocator"
	@-llc $(LLC_PAR) $< -regalloc=basic -o MatrixTranspose_Kernels_regalloc.s
	@-pretobin.sh MatrixTranspose_Kernels_regalloc.s 

diff_ra:
	@-vim -O MatrixTranspose_Kernels.s MatrixTranspose_Kernels_regalloc.s

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
