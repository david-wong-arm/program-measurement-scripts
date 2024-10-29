	.section .text
.LNDBG_TX:
# mark_description "Intel(R) Fortran Intel(R) 64 Compiler XE for applications running on Intel(R) 64, Version 15.0.0.090 Build 2";
# mark_description "0140723";
# mark_description "-o codelet.s -S -g -O3 -xcore-avx2 -align array64byte";
	.file "codelet.f90"
	.text
..TXTST0:
L__routine_start_codelet__0:
# -- Begin  codelet_
	.text
# mark_begin;
       .align    16,0x90
	.globl codelet_
codelet_:
# parameter 1(n): %rdi
# parameter 2(m): %rsi
# parameter 3(a): %rdx
# parameter 4(y): %rcx
# parameter 5(m1): %r8
# parameter 6(m2): %r9
..B1.1:                         # Preds ..B1.0
..___tag_value_codelet_.2:                                      #
..LN0:
  .file   1 "codelet.f90"
   .loc    1  1  is_stmt 1
        pushq     %r14                                          #1.12
..___tag_value_codelet_.4:                                      #
..LN1:
        pushq     %r15                                          #1.12
..___tag_value_codelet_.6:                                      #
..LN2:
   .loc    1  1  prologue_end  is_stmt 1
        movq      %rcx, %r10                                    #1.12
..LN3:
        movslq    (%rdi), %rcx                                  #1.12
..LN4:
        movq      %r8, %r11                                     #1.12
..LN5:
        movslq    (%rsi), %rax                                  #1.12
..LN6:
        movq      %rdx, %r8                                     #1.12
..LN7:
        movq      %rcx, -24(%rsp)                               #1.12
..LN8:
        movq      %rax, -16(%rsp)                               #1.12
..LN9:
   .loc    1  6  is_stmt 1
        movl      (%rdi), %eax                                  #6.2
..LN10:
        testl     %eax, %eax                                    #6.2
..LN11:
        jle       ..B1.23       # Prob 0%                       #6.2
..LN12:
                                # LOE rcx rbx rbp r8 r9 r10 r11 r12 r13 eax
..B1.2:                         # Preds ..B1.1
..LN13:
   .loc    1  7  is_stmt 1
        movslq    (%r11), %rdx                                  #7.3
..LN14:
        vmovsd    (%r10), %xmm0                                 #7.15
..LN15:
        movslq    (%r9), %r14                                   #7.15
..LN16:
   .loc    1  6  is_stmt 1
        cmpl      $16, %eax                                     #6.2
..LN17:
        jl        ..B1.25       # Prob 10%                      #6.2
..LN18:
                                # LOE rdx rcx rbx rbp r8 r12 r13 r14 eax xmm0
..B1.3:                         # Preds ..B1.2
..LN19:
   .loc    1  7  is_stmt 1
        movq      %rdx, %r11                                    #7.15
..LN20:
        lea       (,%rcx,8), %rdi                               #7.15
..LN21:
        imulq     %rdi, %r11                                    #7.15
..LN22:
        movq      %r8, %r10                                     #7.15
..LN23:
        subq      %rdi, %r10                                    #7.15
..LN24:
        lea       (%r10,%r11), %r15                             #7.15
..LN25:
   .loc    1  6  is_stmt 1
        andq      $31, %r15                                     #6.2
..LN26:
        movl      %r15d, %r15d                                  #6.2
..LN27:
        testl     %r15d, %r15d                                  #6.2
..LN28:
        je        ..B1.6        # Prob 50%                      #6.2
..LN29:
                                # LOE rdx rcx rbx rbp rdi r8 r10 r11 r12 r13 r14 r15 eax xmm0
..B1.4:                         # Preds ..B1.3
..LN30:
        testl     $7, %r15d                                     #6.2
..LN31:
        jne       ..B1.25       # Prob 10%                      #6.2
..LN32:
                                # LOE rdx rcx rbx rbp rdi r8 r10 r11 r12 r13 r14 r15 eax xmm0
..B1.5:                         # Preds ..B1.4
..LN33:
        negl      %r15d                                         #6.2
..LN34:
        addl      $32, %r15d                                    #6.2
..LN35:
        shrl      $3, %r15d                                     #6.2
..LN36:
                                # LOE rdx rcx rbx rbp rdi r8 r10 r11 r12 r13 r14 r15 eax xmm0
..B1.6:                         # Preds ..B1.5 ..B1.3
..LN37:
        lea       16(%r15), %esi                                #6.2
..LN38:
        cmpl      %esi, %eax                                    #6.2
..LN39:
        jl        ..B1.25       # Prob 10%                      #6.2
..LN40:
                                # LOE rdx rcx rbx rbp rdi r8 r10 r11 r12 r13 r14 r15 eax xmm0
..B1.7:                         # Preds ..B1.6
..LN41:
   .loc    1  7  is_stmt 1
        imulq     %r14, %rdi                                    #7.15
..LN42:
   .loc    1  6  is_stmt 1
        movl      %eax, %esi                                    #6.2
..LN43:
   .loc    1  7  is_stmt 1
        addq      %r10, %r11                                    #7.15
..LN44:
   .loc    1  6  is_stmt 1
        subl      %r15d, %esi                                   #6.2
..LN45:
   .loc    1  7  is_stmt 1
        addq      %rdi, %r10                                    #7.31
..LN46:
   .loc    1  6  is_stmt 1
        andl      $15, %esi                                     #6.2
..LN47:
        xorl      %r9d, %r9d                                    #6.2
..LN48:
        negl      %esi                                          #6.2
..LN49:
        addl      %eax, %esi                                    #6.2
..LN50:
        testq     %r15, %r15                                    #6.2
..LN51:
        jbe       ..B1.11       # Prob 2%                       #6.2
..LN52:
                                # LOE rdx rcx rbx rbp r8 r9 r10 r11 r12 r13 r14 r15 eax esi xmm0
..B1.9:                         # Preds ..B1.7 ..B1.9
..L9:           # optimization report
                # PEELED LOOP FOR VECTORIZATION
..LN53:
   .loc    1  7  is_stmt 1
        vmovsd    (%r10,%r9,8), %xmm1                           #7.31
..LN54:
        vfmadd213sd (%r11,%r9,8), %xmm0, %xmm1                  #7.3
..LN55:
        vmovsd    %xmm1, (%r11,%r9,8)                           #7.3
..LN56:
   .loc    1  6  is_stmt 1
        incq      %r9                                           #6.2
..LN57:
        cmpq      %r15, %r9                                     #6.2
..LN58:
        jb        ..B1.9        # Prob 82%                      #6.2
..LN59:
                                # LOE rdx rcx rbx rbp r8 r9 r10 r11 r12 r13 r14 r15 eax esi xmm0
..B1.11:                        # Preds ..B1.9 ..B1.7
..LN60:
   .loc    1  7  is_stmt 1
        vbroadcastsd %xmm0, %ymm1                               #7.15
..LN61:
   .loc    1  6  is_stmt 1
        movslq    %esi, %rdi                                    #6.2
        .align    16,0x90
..LN62:
                                # LOE rdx rcx rbx rbp rdi r8 r10 r11 r12 r13 r14 r15 eax esi xmm0 ymm1
push %r14
movq %r15, %r14
..B1.12:                        # Preds ..B1.12 ..B1.11
..L10:          # optimization report
                # LOOP WAS VECTORIZED
                # VECTORIZATION HAS UNALIGNED MEMORY REFERENCES
                # VECTORIZATION SPEEDUP COEFFECIENT 3.500000
..LN63:
   .loc    1  7  is_stmt 1
        vmovupd   (%r10,%r14,8), %ymm2                          #7.31
..LN64:
        vfmadd213pd (%r11,%r14,8), %ymm1, %ymm2                 #7.3
..LN65:
        vmovupd   %ymm2, (%r11,%r14,8)                          #7.3
..LN66:
        vmovupd   32(%r10,%r14,8), %ymm3                        #7.31
..LN67:
        vfmadd213pd 32(%r11,%r14,8), %ymm1, %ymm3               #7.3
..LN68:
        vmovupd   %ymm3, 32(%r11,%r14,8)                        #7.3
..LN69:
        vmovupd   64(%r10,%r14,8), %ymm4                        #7.31
..LN70:
        vfmadd213pd 64(%r11,%r14,8), %ymm1, %ymm4               #7.3
..LN71:
        vmovupd   %ymm4, 64(%r11,%r14,8)                        #7.3
..LN72:
        vmovupd   96(%r10,%r14,8), %ymm5                        #7.31
..LN73:
        vfmadd213pd 96(%r11,%r14,8), %ymm1, %ymm5               #7.3
..LN74:
        vmovupd   %ymm5, 96(%r11,%r14,8)                        #7.3
..LN75:
   .loc    1  6  is_stmt 1
        addq      $16, %r15                                     #6.2
..LN76:
        cmpq      %rdi, %r15                                    #6.2
..LN77:
        jb        ..B1.12       # Prob 82%                      #6.2
pop %r14
..LN78:
                                # LOE rdx rcx rbx rbp rdi r8 r10 r11 r12 r13 r14 r15 eax esi xmm0 ymm1
..B1.14:                        # Preds ..B1.12 ..B1.25
..LN79:
        lea       1(%rsi), %edi                                 #6.2
..LN80:
        cmpl      %edi, %eax                                    #6.2
..LN81:
        jb        ..B1.23       # Prob 50%                      #6.2
..LN82:
                                # LOE rdx rcx rbx rbp r8 r12 r13 r14 eax esi xmm0
..B1.15:                        # Preds ..B1.14
..LN83:
        movslq    %esi, %rsi                                    #6.2
..LN84:
        movslq    %eax, %rax                                    #6.2
..LN85:
        subq      %rsi, %rax                                    #6.2
..LN86:
        cmpq      $4, %rax                                      #6.2
..LN87:
        jl        ..B1.24       # Prob 10%                      #6.2
..LN88:
                                # LOE rax rdx rcx rbx rbp rsi r8 r12 r13 r14 xmm0
..B1.16:                        # Preds ..B1.15
..LN89:
   .loc    1  7  is_stmt 1
        movq      %r8, %r9                                      #7.15
..LN90:
        lea       (,%rcx,8), %rdi                               #7.15
..LN91:
        movq      %r14, %r10                                    #7.15
..LN92:
        subq      %rdi, %r9                                     #7.15
..LN93:
        imulq     %rdi, %r10                                    #7.15
..LN94:
        imulq     %rdx, %rdi                                    #7.15
..LN95:
        vbroadcastsd %xmm0, %ymm1                               #7.15
..LN96:
        addq      %r9, %r10                                     #7.31
..LN97:
        addq      %rdi, %r9                                     #7.15
..LN98:
   .loc    1  6  is_stmt 1
        movl      %eax, %r15d                                   #6.2
..LN99:
        xorl      %r11d, %r11d                                  #6.2
..LN100:
        andl      $-4, %r15d                                    #6.2
..LN101:
        movslq    %r15d, %r15                                   #6.2
..LN102:
   .loc    1  7  is_stmt 1
        lea       (%r10,%rsi,8), %r10                           #7.31
..LN103:
        lea       (%r9,%rsi,8), %rdi                            #7.15
..LN104:
                                # LOE rax rdx rcx rbx rbp rsi rdi r8 r10 r11 r12 r13 r14 r15 xmm0 ymm1
..B1.17:                        # Preds ..B1.17 ..B1.16
..L11:          # optimization report
                # LOOP WAS VECTORIZED
                # REMAINDER LOOP FOR VECTORIATION
                # VECTORIZATION SPEEDUP COEFFECIENT 1.558594
..LN105:
   .loc    1  6  is_stmt 1
..LN106:
   .loc    1  7  is_stmt 1
        vmovupd   (%r10,%r11,8), %ymm2                          #7.31
..LN107:
        vfmadd213pd (%rdi,%r11,8), %ymm1, %ymm2                 #7.3
..LN108:
        vmovupd   %ymm2, (%rdi,%r11,8)                          #7.3
..LN109:
   .loc    1  6  is_stmt 1
        addq      $4, %r11                                      #6.2
..LN110:
        cmpq      %r15, %r11                                    #6.2
..LN111:
        jb        ..B1.17       # Prob 82%                      #6.2
..LN112:
                                # LOE rax rdx rcx rbx rbp rsi rdi r8 r10 r11 r12 r13 r14 r15 xmm0 ymm1
..B1.19:                        # Preds ..B1.17 ..B1.24
..LN113:
        cmpq      %rax, %r15                                    #6.2
..LN114:
        jae       ..B1.23       # Prob 2%                       #6.2
..LN115:
                                # LOE rax rdx rcx rbx rbp rsi r8 r12 r13 r14 r15 xmm0
..B1.20:                        # Preds ..B1.19
..LN116:
   .loc    1  7  is_stmt 1
        shlq      $3, %rcx                                      #7.15
..LN117:
        imulq     %rcx, %r14                                    #7.15
..LN118:
        subq      %rcx, %r8                                     #7.31
..LN119:
        imulq     %rdx, %rcx                                    #7.15
..LN120:
        addq      %r8, %r14                                     #7.31
..LN121:
        addq      %rcx, %r8                                     #7.15
..LN122:
        lea       (%r14,%rsi,8), %rdi                           #7.31
..LN123:
        lea       (%r8,%rsi,8), %rdx                            #7.15
..LN124:
                                # LOE rax rdx rbx rbp rdi r12 r13 r15 xmm0
..B1.21:                        # Preds ..B1.21 ..B1.20
..L12:          # optimization report
                # REMAINDER LOOP FOR VECTORIATION
..LN125:
   .loc    1  6  is_stmt 1
..LN126:
   .loc    1  7  is_stmt 1
        vmovsd    (%rdi,%r15,8), %xmm1                          #7.31
..LN127:
        vfmadd213sd (%rdx,%r15,8), %xmm0, %xmm1                 #7.3
..LN128:
        vmovsd    %xmm1, (%rdx,%r15,8)                          #7.3
..LN129:
   .loc    1  6  is_stmt 1
        incq      %r15                                          #6.2
..LN130:
        cmpq      %rax, %r15                                    #6.2
..LN131:
        jb        ..B1.21       # Prob 82%                      #6.2
..LN132:
                                # LOE rax rdx rbx rbp rdi r12 r13 r15 xmm0
..B1.23:                        # Preds ..B1.21 ..B1.14 ..B1.19 ..B1.1
..LN133:
   .loc    1  10  is_stmt 1
        vzeroupper                                              #10.1
..___tag_value_codelet_.14:                                     #10.1
..LN134:
   .loc    1  10  epilogue_begin  is_stmt 1
        popq      %r15                                          #10.1
..___tag_value_codelet_.15:                                     #
..LN135:
        popq      %r14                                          #10.1
..___tag_value_codelet_.17:                                     #
..LN136:
        ret                                                     #10.1
..___tag_value_codelet_.18:                                     #
..LN137:
                                # LOE
..B1.24:                        # Preds ..B1.15                 # Infreq
..LN138:
   .loc    1  6  is_stmt 1
        xorl      %r15d, %r15d                                  #6.2
..LN139:
        jmp       ..B1.19       # Prob 100%                     #6.2
..LN140:
                                # LOE rax rdx rcx rbx rbp rsi r8 r12 r13 r14 r15 xmm0
..B1.25:                        # Preds ..B1.2 ..B1.4 ..B1.6    # Infreq
..LN141:
        xorl      %esi, %esi                                    #6.2
..LN142:
        jmp       ..B1.14       # Prob 100%                     #6.2
        .align    16,0x90
..___tag_value_codelet_.22:                                     #
..LN143:
                                # LOE rdx rcx rbx rbp r8 r12 r13 r14 eax esi xmm0
..LN144:
# mark_end;
	.type	codelet_,@function
	.size	codelet_,.-codelet_
..LNcodelet_.145:
.LNcodelet_:
	.data
# -- End  codelet_
	.data
	.section .debug_opt_report, "a"
..L23:
	.ascii ".itt_notify_tab\0"
	.word	258
	.word	48
	.long	5
	.long	..L24 - ..L23
	.long	48
	.long	..L25 - ..L23
	.long	60
	.long	0x00000008,0x00000000
	.long	0
	.long	0
	.long	0
	.long	0
	.quad	..L9
	.long	28
	.long	4
	.quad	..L10
	.long	28
	.long	16
	.quad	..L11
	.long	28
	.long	32
	.quad	..L12
	.long	28
	.long	48
..L24:
	.long	1769238639
	.long	1635412333
	.long	1852795252
	.long	1885696607
	.long	1601466991
	.long	1936876918
	.long	7237481
	.long	1769238639
	.long	1635412333
	.long	1852795252
	.long	1885696607
	.long	7631471
..L25:
	.long	41947139
	.long	-2139090933
	.long	-2139062144
	.long	75530368
	.long	-2139090929
	.long	-2139062144
	.long	-2105507712
	.long	145784962
	.long	-2139090929
	.long	-2139062144
	.long	-1971289984
	.long	132374656
	.long	-2139090933
	.long	-2139062144
	.long	142639232
	.section .note.GNU-stack, ""
// -- Begin DWARF2 SEGMENT .debug_info
	.section .debug_info
.debug_info_seg:
	.align 1
	.4byte 0x000000b8
	.2byte 0x0003
	.4byte .debug_abbrev_seg
	.byte 0x08
//	DW_TAG_compile_unit:
	.byte 0x01
//	DW_AT_comp_dir:
	.4byte .debug_str
//	DW_AT_language:
	.byte 0x0e
//	DW_AT_name:
	.4byte .debug_str+0x54
//	DW_AT_producer:
	.4byte .debug_str+0x60
//	DW_AT_use_UTF8:
	.byte 0x01
//	DW_AT_low_pc:
	.8byte ..LN0
//	DW_AT_high_pc:
	.8byte ..LNcodelet_.145
//	DW_AT_stmt_list:
	.4byte .debug_line_seg
//	DW_TAG_subprogram:
	.byte 0x02
//	DW_AT_decl_line:
	.byte 0x01
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.4byte .debug_str+0xd5
//	DW_AT_low_pc:
	.8byte L__routine_start_codelet__0
//	DW_AT_high_pc:
	.8byte ..LNcodelet_.145
//	DW_AT_external:
	.byte 0x01
//	DW_TAG_formal_parameter:
	.byte 0x03
//	DW_AT_decl_line:
	.byte 0x01
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_type:
	.4byte 0x0000009a
//	DW_AT_name:
	.2byte 0x006e
//	DW_AT_location:
	.2byte 0x7502
	.byte 0x00
//	DW_TAG_formal_parameter:
	.byte 0x03
//	DW_AT_decl_line:
	.byte 0x01
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_type:
	.4byte 0x0000009a
//	DW_AT_name:
	.2byte 0x006d
//	DW_AT_location:
	.2byte 0x7402
	.byte 0x00
//	DW_TAG_formal_parameter:
	.byte 0x03
//	DW_AT_decl_line:
	.byte 0x01
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_type:
	.4byte 0x000000a1
//	DW_AT_name:
	.2byte 0x0061
//	DW_AT_location:
	.2byte 0x7102
	.byte 0x00
//	DW_TAG_formal_parameter:
	.byte 0x03
//	DW_AT_decl_line:
	.byte 0x01
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_type:
	.4byte 0x000000b4
//	DW_AT_name:
	.2byte 0x0079
//	DW_AT_location:
	.2byte 0x7202
	.byte 0x00
//	DW_TAG_formal_parameter:
	.byte 0x03
//	DW_AT_decl_line:
	.byte 0x01
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_type:
	.4byte 0x0000009a
//	DW_AT_name:
	.2byte 0x316d
	.byte 0x00
//	DW_AT_location:
	.2byte 0x7802
	.byte 0x00
//	DW_TAG_formal_parameter:
	.byte 0x03
//	DW_AT_decl_line:
	.byte 0x01
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_type:
	.4byte 0x0000009a
//	DW_AT_name:
	.2byte 0x326d
	.byte 0x00
//	DW_AT_location:
	.2byte 0x7902
	.byte 0x00
//	DW_TAG_variable:
	.byte 0x04
//	DW_AT_decl_line:
	.byte 0x03
//	DW_AT_decl_file:
	.byte 0x01
//	DW_AT_name:
	.2byte 0x006a
//	DW_AT_type:
	.4byte 0x0000009a
	.byte 0x00
//	DW_TAG_base_type:
	.byte 0x05
//	DW_AT_byte_size:
	.byte 0x04
//	DW_AT_encoding:
	.byte 0x05
//	DW_AT_name:
	.4byte .debug_str+0xdd
//	DW_TAG_array_type:
	.byte 0x06
//	DW_AT_ordering:
	.byte 0x01
//	DW_AT_type:
	.4byte 0x000000b4
//	DW_TAG_subrange_type:
	.byte 0x07
//	DW_AT_lower_bound:
	.byte 0x01
//	DW_AT_upper_bound:
	.4byte 0x06587603
//	DW_TAG_subrange_type:
	.byte 0x07
//	DW_AT_lower_bound:
	.byte 0x01
//	DW_AT_upper_bound:
	.4byte 0x06587603
	.byte 0x00
//	DW_TAG_base_type:
	.byte 0x05
//	DW_AT_byte_size:
	.byte 0x08
//	DW_AT_encoding:
	.byte 0x04
//	DW_AT_name:
	.4byte .debug_str+0xe8
	.byte 0x00
// -- Begin DWARF2 SEGMENT .debug_line
	.section .debug_line
.debug_line_seg:
	.align 1
// -- Begin DWARF2 SEGMENT .debug_abbrev
	.section .debug_abbrev
.debug_abbrev_seg:
	.align 1
	.byte 0x01
	.byte 0x11
	.byte 0x01
	.byte 0x1b
	.byte 0x0e
	.byte 0x13
	.byte 0x0b
	.byte 0x03
	.byte 0x0e
	.byte 0x25
	.byte 0x0e
	.byte 0x53
	.byte 0x0c
	.byte 0x11
	.byte 0x01
	.byte 0x12
	.byte 0x01
	.byte 0x10
	.byte 0x06
	.2byte 0x0000
	.byte 0x02
	.byte 0x2e
	.byte 0x01
	.byte 0x3b
	.byte 0x0b
	.byte 0x3a
	.byte 0x0b
	.byte 0x03
	.byte 0x0e
	.byte 0x11
	.byte 0x01
	.byte 0x12
	.byte 0x01
	.byte 0x3f
	.byte 0x0c
	.2byte 0x0000
	.byte 0x03
	.byte 0x05
	.byte 0x00
	.byte 0x3b
	.byte 0x0b
	.byte 0x3a
	.byte 0x0b
	.byte 0x49
	.byte 0x13
	.byte 0x03
	.byte 0x08
	.byte 0x02
	.byte 0x0a
	.2byte 0x0000
	.byte 0x04
	.byte 0x34
	.byte 0x00
	.byte 0x3b
	.byte 0x0b
	.byte 0x3a
	.byte 0x0b
	.byte 0x03
	.byte 0x08
	.byte 0x49
	.byte 0x13
	.2byte 0x0000
	.byte 0x05
	.byte 0x24
	.byte 0x00
	.byte 0x0b
	.byte 0x0b
	.byte 0x3e
	.byte 0x0b
	.byte 0x03
	.byte 0x0e
	.2byte 0x0000
	.byte 0x06
	.byte 0x01
	.byte 0x01
	.byte 0x09
	.byte 0x0b
	.byte 0x49
	.byte 0x13
	.2byte 0x0000
	.byte 0x07
	.byte 0x21
	.byte 0x00
	.byte 0x22
	.byte 0x0d
	.byte 0x2f
	.byte 0x0a
	.2byte 0x0000
	.byte 0x00
// -- Begin DWARF2 SEGMENT .debug_frame
	.section .debug_frame
.debug_frame_seg:
	.align 1
	.4byte 0x00000014
	.8byte 0x78010003ffffffff
	.8byte 0x0000019008070c10
	.4byte 0x00000000
	.4byte 0x0000004c
	.4byte .debug_frame_seg
	.8byte ..___tag_value_codelet_.2
	.8byte ..___tag_value_codelet_.22-..___tag_value_codelet_.2
	.byte 0x04
	.4byte ..___tag_value_codelet_.4-..___tag_value_codelet_.2
	.4byte 0x028e100e
	.byte 0x04
	.4byte ..___tag_value_codelet_.6-..___tag_value_codelet_.4
	.4byte 0x038f180e
	.byte 0x04
	.4byte ..___tag_value_codelet_.14-..___tag_value_codelet_.6
	.2byte 0x04cf
	.4byte ..___tag_value_codelet_.15-..___tag_value_codelet_.14
	.4byte 0x04ce100e
	.4byte ..___tag_value_codelet_.17-..___tag_value_codelet_.15
	.2byte 0x080e
	.byte 0x04
	.4byte ..___tag_value_codelet_.18-..___tag_value_codelet_.17
	.8byte 0x0000038f028e180e
	.4byte 0x00000000
// -- Begin DWARF2 SEGMENT .debug_str
	.section .debug_str,"MS",@progbits,1
.debug_str_seg:
	.align 1
	.8byte 0x2f78662f73666e2f
	.8byte 0x78662f736b736964
	.8byte 0x69645f656d6f685f
	.8byte 0x7a616d612f316b73
	.8byte 0x455041432f7a756f
	.8byte 0x657262752f524e2f
	.8byte 0x736b6d62752f6f70
	.8byte 0x6d62755f6d656d2f
	.8byte 0x65686d6c652f736b
	.8byte 0x5f72735f30315f73
	.4byte 0x00327864
	.8byte 0x2e74656c65646f63
	.4byte 0x00303966
	.8byte 0x2952286c65746e49
	.8byte 0x6e617274726f4620
	.8byte 0x52286c65746e4920
	.8byte 0x6d6f432034362029
	.8byte 0x45582072656c6970
	.8byte 0x70706120726f6620
	.8byte 0x6e6f69746163696c
	.8byte 0x6e696e6e75722073
	.8byte 0x746e49206e6f2067
	.8byte 0x3436202952286c65
	.8byte 0x6f6973726556202c
	.8byte 0x302e302e3531206e
	.8byte 0x697542203039302e
	.8byte 0x303431303220646c
	.4byte 0x0a333237
	.byte 0x00
	.8byte 0x0074656c65646f63
	.8byte 0x2852454745544e49
	.2byte 0x2934
	.byte 0x00
	.8byte 0x002938284c414552
// -- Begin DWARF2 SEGMENT .eh_frame
	.section .eh_frame,"a",@progbits
.eh_frame_seg:
	.align 8
	.4byte 0x00000014
	.8byte 0x7801000100000000
	.8byte 0x0000019008070c10
	.4byte 0x00000000
	.4byte 0x0000004c
	.4byte 0x0000001c
	.8byte ..___tag_value_codelet_.2
	.8byte ..___tag_value_codelet_.22-..___tag_value_codelet_.2
	.byte 0x04
	.4byte ..___tag_value_codelet_.4-..___tag_value_codelet_.2
	.4byte 0x028e100e
	.byte 0x04
	.4byte ..___tag_value_codelet_.6-..___tag_value_codelet_.4
	.4byte 0x038f180e
	.byte 0x04
	.4byte ..___tag_value_codelet_.14-..___tag_value_codelet_.6
	.2byte 0x04cf
	.4byte ..___tag_value_codelet_.15-..___tag_value_codelet_.14
	.4byte 0x04ce100e
	.4byte ..___tag_value_codelet_.17-..___tag_value_codelet_.15
	.2byte 0x080e
	.byte 0x04
	.4byte ..___tag_value_codelet_.18-..___tag_value_codelet_.17
	.8byte 0x0000038f028e180e
	.4byte 0x00000000
	.section .text
.LNDBG_TXe:
# End
