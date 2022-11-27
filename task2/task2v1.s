  ; Task 2 - Data processing calculations on a Cortex - M3
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
  MOV r0,#(1+sampled_end-sampled)-8  ; number of calculations needed
  LDR r9,=sampled      ; start of the ADC sampled data area
  LDR r11,=filtered    ; location to store results
   
filter_loop
    LDR r4,[r9],#4			; get next 4 bytes from the sampled data area
	UBFX r5, r4, #0, #8 	; filter out data value
	LSL r3,r5,#5			; mutiply data value by filter value 32
	
	UBFX r5, r4, #8, #8 	; filter out data value
	LSL r5,r5,#5			; mutiply data value by filter value 32
	ADD r3,r3,r5			; accumulate result
	
	UBFX r5, r4, #16, #8 	; filter out data value
	LSL r5,r5,#6			; mutiply data value by filter value 64
	ADD r3,r3,r5			; accumulate result

	UBFX r5, r4, #24, #8	; filter out data value
	LSL r5,r5,#7			; mutiply data value by filter value 128
	ADD r3,r3,r5			; accumulate result

	LDR r4,[r9],#4    		; get next 4 bytes from the sampled data area

	UBFX r5, r4, #0, #8		; filter out data value
	LSL r5,r5,#7			; mutiply data value by filter value 128
	ADD r3,r3,r5			; accumulate result
	
	UBFX r5, r4, #8, #8		; filter out data value
	LSL r5,r5,#6			; mutiply data value by filter value 64
	ADD r3,r3,r5			; accumulate result
	
	UBFX r5, r4, #16, #8	; filter out data value
	LSL r5,r5,#5			; mutiply data value by filter value 32
	ADD r3,r3,r5			; accumulate result
	
	UBFX r5, r4, #24, #8	; filter out data value
	LSL r5,r5,#5			; mutiply data value by filter value 32
	ADD r3,r3,r5			; accumulate result

    LSR r3,r3,#9      		; scale the filtered value by 512
    STR r3,[r11],#4    		; store filtered value in read/write area
	SUB r9,r9,#7			; change to next data value for filtering
    SUBS r0,r0,#1      		; decrement counter for num of calculations
    BNE filter_loop   		; next filtered value  

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