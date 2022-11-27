  ; Task 1 - Trigonometric approximations Cortex-M4
  ; This program estimates the value of sin(x)
  ; using the first 3 terms of the Taylor series
  ; result is stored in register s10
  
  THUMB
  AREA RESET, CODE, READONLY
  EXPORT  __Vectors
  EXPORT Reset_Handler
__Vectors 
  DCD 0x20001000     ; top of the stack 
  DCD Reset_Handler  ; reset vector - where the program starts

  AREA Task1a_Code, CODE, READONLY 
  ENTRY
Reset_Handler
copro_setup
  LDR.W r0, = 0xE000ED88 ; address of co-processor register
  LDR r1, [r0]  ; Read CPACR - the co-processor register
  ORR r1, r1, #(0xF << 20)  ; bits 20-23 to enable CP10 and CP11 coprocessors
  STR r1, [r0]  ; write back updated value to CPACR
  DSB   ; wait for transfer to complete
  
  LDR r2,=0x40490fd0 ;store value of pi in literal pool
  VMOV.F s0,r2 ;store value of pi in s0
  

  VMOV.F s2,#2 ;store value of 2
  VDIV.F s1,s0,s2; store pi/2 in s1
  
  ;Find second term
  VMUL.F s2,s1,s1
  VMUL.F s3,s2,s1 ;Stores x^3
  VMOV.F s4,#6 ; 3! = 6
  VDIV.F s5,s3,s4 ;Stores x^3/3!
  
  ;Find third term
  VMUL.F s6,s3,s1
  VMUL.F s7,s6,s1 ;Stores x^5
  MOV r3,#120; 5! = 120
  VMOV.F s9,r3
  VCVT.F32.S32 s9,s9
  VDIV.F s8,s7,s9 ;Stores x^5/5!
  
  VSUB.F s10,s1,s5  ; Calculate value of first 2 terms
  VADD.F s10,s10,s8  ; Add first 2 terms to last term
  
terminate  ; sit in an endless loop
  B terminate
  END