  ; Task 3 - Data processing calculations on a Cortex - M4
  ; This program implements a filter operating on a sampled data,
  ; achieved by peforming a series of correlations
  ; The samples are stored at read only memory location sampled, 
  ; there must be a minimum of 8 samples and a maximum of 64 samples
  ; Values of filter data are fixed and number of values are also fixed.
  
  ; Set up the exception addresses
  THUMB
  AREA RESET, CODE, READONLY
  EXPORT  __Vectors
  EXPORT Reset_Handler
__Vectors 
  DCD 0x20001000     ; top of the stack 
  DCD Reset_Handler  ; reset vector - where the program starts

  AREA c02t02_Code, CODE, READONLY 
  ENTRY
Reset_Handler	
  MOV r0,#(1+sampled_end-sampled)-8		; number of calculations needed
  LDR r1,=sampled      					; start of the ADC sampled data area
  LDR r2,=filtered    					; location to store results
  MOV r3,#32							; store filter constant
  MOV r4,#64							; store filter constant
  MOV r5,#128							; store filter constant

filter_loop
    LDR r6,[r1],#4    		; get next 4 bytes from the sampled data area
	
	UBFX r7, r6, #0, #8		; filter data value
	MUL r8,r7,r3			; Mutiply data value with filter value 32
	
	UBFX r7, r6, #8, #8		; filter data value
	SMLAD r8,r7,r3,r8		; Mutiply data value with filter value 32 and accmulate result
	
	UBFX r7, r6, #16, #8	; filter data value
	SMLAD r8,r7,r4,r8		; Mutiply data value with filter value 64 and accmulate result
    
	UBFX r7, r6, #24, #8	; filter data value
	SMLAD r8,r7,r5,r8		; Mutiply data value with filter value 128 and accmulate result

	LDR r6,[r1],#4			; get next 4 bytes from the sampled data area

	UBFX r7, r6, #0, #8		; filter data value
    SMLAD r8,r7,r5,r8		; Mutiply data value with filter value 128 and accmulate result
	
	UBFX r7, r6, #8, #8		; filter data value
    SMLAD r8,r7,r4,r8		; Mutiply data value with filter value 64 and accmulate result
	
	UBFX r7, r6, #16, #8	; filter data value
    SMLAD r8,r7,r3,r8		; Mutiply data value with filter value 32 and accmulate result
	
	UBFX r7, r6, #24, #8	; filter data value
    SMLAD r8,r7,r3,r8		; Mutiply data value with filter value 32 and accmulate result

    LSR r8,r8,#9      ; scale the filtered value by 512
    STR r8,[r2],#4    ; store filtered value in read/write area
	SUB r1,r1,#7	  ; calculate address of next data value
    SUBS r0,r0,#1     ; decrement num of calculations
    BNE filter_loop   ; next filtered value  

terminate  ; finish in an endless loop
  B terminate

  ; provide the initial sampled and filter values 
  ALIGN 4
sampled   ; 8-bit unsigned sampled values obtained from an ADC
  DCB 102,24,127,128,239,120,89,23,0,15,123,252,45,193,156,103
sampled_end

  ; region to hold the filtered data values
  AREA c02t02_Data, DATA, READWRITE
filtered
  FILL (1+sampled_end-sampled)-8
  END