;===============================================================================
;	MATH MACROS - MADS syntax
;===============================================================================
; 8-bit and 16-bit math
; 
; Warning -- WORK IN PROGRESS, UNTESTED
;
; The destination address for the result value is always the first argument.
; The result argument is always assumed to be an address. (in case the 
; previous line was not clear enough).
;
; Macro naming conventions ...
; 
; mSIZE_...  Size is the size of the result. Byte or Word
; 
; M = Memory.  Address supplied to reference the value.
; 
; V = Value.   Literal value. Same size as the result.
;
; A = accumulator.
;
; X = X Register
;
; Y = Y register
;===============================================================================


;===============================================================================
; 8-BIT MATH - ADDITION
;===============================================================================
; mByte_V_Add_V
; mByte_M_Add_V
; mByte_V_Add_M
; mByte_M_Add_M
; mByte_Add
; 
;===============================================================================
; 8-BIT MATH - SUBTRACTION
;===============================================================================
; mByte_V_Sub_V
; mByte_M_Sub_V
; mByte_V_Sub_M
; mByte_M_Sub_M
; mByte_Sub
;
;===============================================================================
; 8-BIT MATH - OTHER TRICKS
;===============================================================================
; mByte_Abs_M
; mByte_Abs_V
; mByte_Abs
;
;===============================================================================
; 8-BIT MATH - MULTIPLICATION LIBRARY LOOKUP TABLES
;===============================================================================
;
; All mByte_MultX_M macros use arguments: result address, mulitplicand address.
;
; RESULT ADDRESS CANNOT BE THE SAME AS MULTIPLICAND ADDRESS.
;
; Multiplicand will not be modified.
;
; If Result does not fit in a Byte, use mWord_Mult instead.
;
;===============================================================================
; mByte_Mult2_M  ; *2
; mByte_Mult3_M  ; *2 + 1
; mByte_Mult4_M  ; *4
; mByte_Mult5_M  ; *4 + 1
; mByte_Mult6_M  ; (*2 + 1) * 2
; mByte_Mult7_M  ; *4 + *2 + 1
; mByte_Mult8_M  ; *8
; mByte_Mult9_M  ; *8 + 1
; mByte_Mult10_M ; (*4 + 1) * 2
;
; mByte_Mult ; Macro calling the mByte_MultX_M macros above.
;
;===============================================================================
; 8-BIT MATH - MULTIPLICATION LIBRARY LOOKUP TABLES
;===============================================================================
; mByte_MultL3_M 
; mByte_MultL4_M 
; mByte_MultL5_M 
;
; . . .
;
; mByte_MultL42_M 
;
; mByte_MultL ; Macro calling the mByte_MultLX_M above.
;
;===============================================================================


;===============================================================================
; 16-BIT MATH - ADDITION
;===============================================================================
; mWord_V_Add_V
; mWord_M_Add_V
; mWord_V_Add_M
; mWord_M_Add_M
;
; mWord_Add
; 
;===============================================================================
; 16-BIT MATH - SUBTRACTION
;===============================================================================
; mWord_V_Sub_V
; mWord_M_Sub_V
; mWord_V_Sub_M
; mWord_M_Sub_M
;
; mWord_Sub
;
;===============================================================================
; 16-BIT MATH - MULTIPLICATION
;===============================================================================
;
; All mWord_MultX_M macros use arguments: result address, mulitplicand address.
;
; RESULT ADDRESS CANNOT BE THE SAME AS MULTIPLICAND ADDRESS.
;
; Multiplicand will not be modified.
;
; Note that results can overflow the 16-bit result.
;
; mWord_Mult2_M ; ASL(M) = *2
; mWord_Mult3_M ; ASL(M) = *2 + M = *3
; mWord_Mult4_M ; ASL(ASL(M)) = *4
; mWord_Mult5_M ; ASL(ASL(M)) = *4 + M = *5
; mWord_Mult6_M ; ASL(M) = *2 + (ASL(ASL(M))) = *4) =*6
; mWord_Mult7_M ; Y=M; A = Lookup,Y
; mWord_Mult8_M ; ASL(ASL(ASL(M))) = *8
; mWord_Mult9_M ; ASL(ASL(ASL(M))) = *8 + M = *9
; mWord_Mult10_M ; ASL(M) = *2 + ASL(ASL(ASL(M))) = *8 = *10
; mWord_Mult16_M ; ASL(ASL(ASL(ASL(M)))) = *16
;
; mWord_Mult ; Macro calling the mWord_MultX_M macros above.
;
; mWord_Multiply ; Generic routine code performing iterative algorithm.
;
;===============================================================================



;===============================================================================
; 8-BIT MATH - ADDITION
;===============================================================================
; 
;===============================================================================

;-------------------------------------------------------------------------------
;                                                        BYTE_V_PLUS_V   A
;-------------------------------------------------------------------------------
; mByte_V_Add_V <result (address)>, <value1>, <value2>
;
; Add literal <Value2> plus literal <Value1>, store in <Result (address)>.
;
; or 
; result = Value1 + Value2
; 
; or (more exactly) 
; Poke result, Value1 + Value2
;-------------------------------------------------------------------------------
.macro mByte_V_Add_V result,value1,value2
	.if %%0<>3
		.error "mByte_V_Add_V: 3 arguments (result addr, value1, value2) required."
	.else
		clc           ; clear carry/borrow
		lda #<:value1 ; Low byte of Value1
		adc #<:value2 ; add low byte of Value2
		sta :result   ; save in Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_M_PLUS_V   A
;-------------------------------------------------------------------------------
; mByte_M_Add_V <result (address)>, <address>, <value>
;
; Add literal <Value> from value at <Address>, store in <Result (address)>.
;
; or 
; result = address + Value
; 
; or (more exactly) 
; Poke result, Peek(address) + Value 
;-------------------------------------------------------------------------------
.macro mByte_M_Add_V result,address,value
	.if %%0<>3
		.error "mByte_M_Add_V: 3 arguments (result addr, addr, value) required."
	.else
		clc          ; clear carry/borrow
		lda :address ; byte at Address
		adc #<:value ; add low byte of Value
		sta result   ; save in Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_V_PLUS_M   A
;-------------------------------------------------------------------------------
; mByte_V_Add_M <result (address)>, <value>, <address>
;
; Add value at <Address> from literal <Value>, store in <Result (address)>.
;
; or 
; result = Value + Address
; 
; or (more exactly) 
; Poke result, Value + Peek(address)
;-------------------------------------------------------------------------------
.macro mByte_V_Add_M result,value,address
	.if %%0<>3
		.error "mByte_V_Add_M: 3 arguments (result addr, value, addr) required."
	.else
		clc          ; clear carry/borrow
		lda #<:value ; Low byte of Value
		adc :address ; add low byte of Address
		sta :result  ; save in Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_M_PLUS_M   A
;-------------------------------------------------------------------------------
; mByte_M_Add_M <result (address)>, <address1>, <address2>
;
; Add value at <address2> from value at <Address1>, store in <Result (address)>.
;
; or 
; result = address1 + address2
; 
; or (more exactly) 
; Poke result, Peek(address1) + Peek(address2) 
;-------------------------------------------------------------------------------
.macro mByte_M_Add_M result,address1,address2
	.if %%0<>3
		.error "mByte_M_Add_M: 3 arguments (result addr, addr1, addr2) required."
	.else
		clc           ; clear carry/borrow
		lda :address1 ; Low byte of Address
		adc :address2 ; add low byte of Value
		sta :result   ; save in Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         BYTE_ADD   A
;-------------------------------------------------------------------------------
; mByte_Add <result (address)>, <argument1>, <argument2>
;
; Add value at <argument2> to value at/of <argument1>, 
; store in <Result (address)>.
;
; This provides a wrapper that figures out which math macro to call
; simplifying the choice of M and V.
;
; If argument2 is a value less than 256 it will assume that argument2
; is a V parameter for explicity value.  If it is greater then 256 it
; will assume it is an address.
; 
; This is correct in most cases.  However, if page zero addresses are 
; intended for arguments then the programmer must explicitly
; invoke the M_Sub_M macro.  
;
; This macro will treat argument1 as an address if it equals the 
; result address assuming common use of X=X+Y. 
; And, it is possible this choice may be wrong.  
; Example of the unexpected: Result is Page 0 addresss $80, arg1 is value $80.
;-------------------------------------------------------------------------------
.macro mByte_Add result,argument1,argument2
	.if %%0<>3
		.error "mByte_Add: 3 arguments (result addr, arg1, arg2) required."
	.else
		.if :argument1>255 .OR :result=:argument1 ; arg1 = M and allowing for X = X + Y
			.if :argument2>255 ; arg2 = M
				mByte_M_Add_M :result,:argument1,:argument2 ; M = M + M
			.else ; arg2 = V
				mByte_M_Add_V :result,:argument1,:argument2 ; M = M + V
			.endif
		.else     ; arg1 =  V
			.if :argument2>255 ; arg2 = M
				mByte_V_Add_M :result,:argument1,:argument2 ; M = V + M
			.else ; arg2 = V
				mByte_V_Add_V :result,:argument1,:argument2 ; M = V + V
			.endif
		.endif
	.endif
.endm



;===============================================================================
; 8-BIT MATH - SUBTRACTION
;===============================================================================
; 
;===============================================================================

;-------------------------------------------------------------------------------
;                                                         BYTE_V_SUB_V   A
;-------------------------------------------------------------------------------
; mByte_V_Sub_V <result (address)>, <value1>, <value2>
;
; Subtract literal <Value2> from literal <Value1>, store in <Result (address)>.
;
; or 
; result = Value1 - Value2
; 
; or (more exactly) 
; Poke result, Value1 - Value2
;-------------------------------------------------------------------------------
.macro mByte_V_Sub_V result,value1,value2
	.if %%0<>3
		.error "mByte_V_Sub_V: 3 arguments (result addr, value1, value2) required."
	.else
		sec           ; set carry/borrow
		lda #<:value1 ; Low byte of Value1
		sbc #<:value2 ; subtract low byte of Value2
		sta :result   ; save in Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         BYTE_M_SUB_V   A
;-------------------------------------------------------------------------------
; mByte_M_Sub_V <result (address)>, <address>, <value>
;
; Subtract literal <Value> from value at <Address>, store in <Result (address)>.
;
; or 
; result = address - Value
; 
; or (more exactly) 
; Poke result, Peek(address) - Value 
;-------------------------------------------------------------------------------
.macro mByte_M_Sub_V result,address,value
	.if %%0<>3
		.error "mByte_M_Sub_V: 3 arguments (result addr, addr, value) required."
	.else
		sec          ; set carry/borrow
		lda :address ; Low byte of Address
		sbc #<:value ; subtract low byte of Value
		sta :result  ; save in Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         BYTE_V_SUB_M   A
;-------------------------------------------------------------------------------
; mByte_V_Sub_M <result (address)>, <value>, <address>
;
; Subtract value at <Address> from literal <Value>, store in <Result (address)>.
;
; or 
; result = Value - Address
; 
; or (more exactly) 
; Poke result, Value - Peek(address)
;-------------------------------------------------------------------------------
.macro mByte_V_Sub_M result,value,address
	.if %%0<>3
		.error "mByte_V_Sub_M: 3 arguments (result addr, value, addr) required."
	.else
		sec          ; set carry/borrow
		lda #<:value ; Low byte of Value
		sbc :address ; subtract low byte of Address
		sta :result  ; save in Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         BYTE_M_SUB_M   A
;-------------------------------------------------------------------------------
; mByte_M_Sub_M <result (address)>, <address1>, <address2>
;
; Subtract value at <address2> from value at <Address1>, store in <Result (address)>.
;
; or 
; result = address1 - address2
; 
; or (more exactly) 
; Poke result, Peek(address1) - Peek(address2) 
;-------------------------------------------------------------------------------
.macro mByte_M_Sub_M result,address1,address2
	.if %%0<>3
		.error "mByte_M_Sub_M: 3 arguments (result addr, addr1, addr2) required."
	.else
		sec           ; set carry/borrow
		lda :address1 ; Low byte of Address
		sbc :address2 ; subtract low byte of Value
		sta :result   ; save in Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         BYTE_SUB   A
;-------------------------------------------------------------------------------
; mByte_Sub <result (address)>, <argument1>, <argument2>
;
; Subtract value at <argument2> from value at/of <argument1>, 
; store in <Result (address)>.
;
; This provides a wrapper that figures out which math macro to call
; simplifying the choice of M and V.
;
; If argument2 is a value less than 256 it will assume that argument2
; is a V parameter for explicity value.  If it is greater then 256 it
; will assume it is an address.
; 
; This is correct in most cases.  However, if page zero addresses are 
; intended for arguments then the programmer must explicitly
; invoke the M_Sub_M macro.  
;
; This macro will treat argument1 as an address if it equals the 
; result address assuming common use of X=X-Y. 
; And, it is possible this choice may be wrong.  
; Example of the unexpected: Result is Page 0 addresss $80, arg1 is value $80.
;-------------------------------------------------------------------------------
.macro mByte_Sub result,argument1,argument2
	.if %%0<>3
		.error "mByte_Sub: 3 arguments (result addr, arg1, arg2) required."
	.else
		.if :argument1>255 .OR :result=:argument1 ; arg1 = M and allowing for X = X - Y
			.if :argument2>255 ; arg2 = M
				mByte_M_Sub_M :result,:argument1,:argument2 ; M = M - M
			.else ; arg2 = V
				mByte_M_Sub_V :result,:argument1,:argument2 ; M = M - V
			.endif
		.else     ; arg1 =  V
			.if :argument2>255 ; arg2 = M
				mByte_V_Sub_M :result,:argument1,:argument2 ; M = V - M
			.else ; arg2 = V
				mByte_V_Sub_V :result,:argument1,:argument2 ; M = V - V
			.endif
		.endif
	.endif
.endm



;===============================================================================
; 8-BIT MATH - OTHER TRICKS
;===============================================================================
; mByte_Abs_M
; mByte_Abs_V
; mByte_Abs
;
;===============================================================================

;-------------------------------------------------------------------------------
;                                                         BYTE_ABS_M   A
;-------------------------------------------------------------------------------
; mByte_Abs_M <result (address)>, <argument>
;
; Store in result location the Absolute value of the byte at the 
; argument 1 address.
; 
; Like:
; RESULT = ABS(X)
; 
; Or:
; POKE RESULT, ABS(PEEK(X))
;-------------------------------------------------------------------------------
.macro mByte_Abs_M result,argument
	.if %%0<>2
		.error "mByte_Abs_M: 2 arguments (result addr, addr) required."
	.else
		lda :argument ; byte at address
		bpl @abs_plus ; positive
		eor #$FF      ; negative.  Exclusive OR bits
		sta :result   ; save result
		inc :result   ; Two's complement is +1
		jmp @abs_done ; no branch can be reliable after the inc.
@abs_plus
		sta :result   ; save result
@abs_done
.endm


;-------------------------------------------------------------------------------
;                                                         BYTE_ABS_V   A
;-------------------------------------------------------------------------------
; mByte_Abs_V <result (address)>, <argument>
;
; Store in result location the Absolute value of the argument 1 byte.
; 
; Like:
; RESULT = ABS(X)
; 
; Or:
; POKE RESULT, ABS(X)
;-------------------------------------------------------------------------------
.macro mByte_Abs_V result,argument
	.if %%0<>2
		.error "mByte_Abs_V: 2 arguments (result addr, byte) required."
	.else
		lda #:argument ; byte
		bpl @abs_plus  ; positive
		eor #$FF       ; negative.  Exclusive OR bits
		sta :result    ; save result
		inc :result    ; Two's complement is +1
		jmp @abs_done  ; no branch can be reliable after the inc.
@abs_plus
		sta :result    ; save result
@abs_done
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         BYTE_ABS   A
;-------------------------------------------------------------------------------
; mByte_Abs <result (address)>, <argument>
;
; Store in result location the Absolute value of the argument1.
;
; If the argument1 is the same value as the result it is treated as an address.
;
; If the argument1 is greater than 255 then it is treated as an address.
;
; Otherwise the argument is treated as an explicit byte value.
;
;-------------------------------------------------------------------------------

.macro mByte_Abs result,argument
	.if %%0<>2
		.error "mByte_Abs: 2 arguments (result addr, argument) required."
	.else
		.if :argument>255 .OR :result=:argument ; arg = M 
			mByte_Abs_M :result,:argument ; M = Abs(M)
		.else ; arg2 = V
			mByte_Abs_V :result,:argument ; M = Abs(V)
		.endif
	.endif
.endm


;===============================================================================
; 8-BIT MATH - MULTIPLICATION
;
; Remember, "Byte" means limited to 8-bit results.
;
; Result address and Multiplicand address cannot be the same.
;
; Multiplicand will not be modified.
;
;===============================================================================
; mByte_Mult2_M  ; *2
; mByte_Mult3_M  ; *2 + 1
; mByte_Mult4_M  ; *4
; mByte_Mult5_M  ; *4 + 1
; mByte_Mult6_M  ; (*2 + 1) * 2
; mByte_Mult7_M  ; *4 + *2 + 1
; mByte_Mult8_M  ; *8
; mByte_Mult9_M  ; *8 + 1
; mByte_Mult10_M ; (*4 + 1) * 2
;
; mByte_Mult ; One macro to check arguments and call the correct multiplier.
;===============================================================================

;-------------------------------------------------------------------------------
;                                                        BYTE_MULT2_M   A
;-------------------------------------------------------------------------------
; mByte_Mult2_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult2_M result,address
	.if %%0<>2
		.error "mByte_Mult2_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte of Address
		asl          ; Times 2
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT3_M   A
;-------------------------------------------------------------------------------
; mByte_Mult3_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*2 + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult3_M result,address
	.if %%0<>2
		.error "mByte_Mult3_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 3
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT4_M   A
;-------------------------------------------------------------------------------
; mByte_Mult4_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*4)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult4_M result,address
	.if %%0<>2
		.error "mByte_Mult4_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT5_M   A
;-------------------------------------------------------------------------------
; mByte_Mult5_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*4 + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult5_M result,address
	.if %%0<>2
		.error "mByte_Mult5_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 5
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT6_M   A
;-------------------------------------------------------------------------------
; mByte_Mult6_M <result (address)>, <address>
;
; Multiply value from address, store at result. ((*2 + 1) * 2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult6_M result,address
	.if %%0<>2
		.error "mByte_Mult6_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 3
		asl          ; Times 2 again.   Now Accumulator is * 6
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT7_M   A
;-------------------------------------------------------------------------------
; mByte_Mult7_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*4 + *2 + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult7_M result,address
	.if %%0<>2
		.error "mByte_Mult7_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 3
		asl          ; Times 2 again.  3 * 2 = 6
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 7
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT8_M   A
;-------------------------------------------------------------------------------
; mByte_Mult8_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*8)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult8_M result,address
	.if %%0<>2
		.error "mByte_Mult8_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		asl          ; Times 8
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT9_M   A
;-------------------------------------------------------------------------------
; mByte_Mult9_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*8 + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult9_M result,address
	.if %%0<>2
		.error "mByte_Mult9_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		asl          ; Times 8
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 9
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT10_M   A
;-------------------------------------------------------------------------------
; mByte_Mult10_M <result (address)>, <address>
;
; Multiply value from address, store at result. ((*4 + 1) * 2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult10_M result,address
	.if %%0<>2
		.error "mByte_Mult10_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 5
		asl          ; 5 * 2 is 10
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT11_M   A
;-------------------------------------------------------------------------------
; mByte_Mult11_M <result (address)>, <address>
;
; Multiply value from address, store at result. ((*4 + 1) * 2) + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult11_M result,address
	.if %%0<>2
		.error "mByte_Mult11_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 5
		asl          ; 5 * 2 is 10
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 11
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT12_M   A
;-------------------------------------------------------------------------------
; mByte_Mult12_M <result (address)>, <address>
;
; Multiply value from address, store at result. ((*2 + 1) * 4)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult12_M result,address
	.if %%0<>2
		.error "mByte_Mult12_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 3
		asl          ; Times 2. Now Accumulator is * 6
		asl          ; Times 4. Now Accumulator is * 12
		sta :result  ; save in low byte of Result
	.endif
.endm



;-------------------------------------------------------------------------------
;                                                        BYTE_MULT13_M   A
;-------------------------------------------------------------------------------
; mByte_Mult13_M <result (address)>, <address>
;
; Multiply value from address, store at result. (((*2 + 1) * 4) + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult13_M result,address
	.if %%0<>2
		.error "mByte_Mult13_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 3
		asl          ; Times 2 again.   Now Accumulator is * 6
		asl          ; Times 2 again.   Now Accumulator is * 12
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 13
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT14_M   A
;-------------------------------------------------------------------------------
; mByte_Mult14_M <result (address)>, <address>
;
; Multiply value from address, store at result. ((((*2 + 1) * 2 ) + 1) * 2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult14_M result,address
	.if %%0<>2
		.error "mByte_Mult14_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 3
		asl          ; Times 2 again.  3 * 2 = 6
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 7
		asl          ; Times 2. Now Accumulator is * 14
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT15_M   A
;-------------------------------------------------------------------------------
; mByte_Mult15_M <result (address)>, <address>
;
; Multiply value from address, store at result. (((*4 + 1) * 2) + 5)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult15_M result,address
	.if %%0<>2
		.error "mByte_Mult15_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 5
		sta :result  ; save in low byte of Result
		asl          ; Times 2.  Now Accumulator is * 10.
		clc          ; Clear carry/borrow
		adc :result  ; Add to *5 value.  Now Accumulator is * 15
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT16_M   A
;-------------------------------------------------------------------------------
; mByte_Mult16_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*16)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult16_M result,address
	.if %%0<>2
		.error "mByte_Mult16_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		asl          ; Times 8
		asl          ; Times 16
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT17_M   A
;-------------------------------------------------------------------------------
; mByte_Mult17_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*16 + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult17_M result,address
	.if %%0<>2
		.error "mByte_Mult17_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		asl          ; Times 8
		asl          ; Times 16
		clc          ; Clear carry/borrow
		adc :address ; Add to original value. Now Accumulator is * 17
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT18_M   A
;-------------------------------------------------------------------------------
; mByte_Mult18_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*16 + *2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult18_M result,address
	.if %%0<>2
		.error "mByte_Mult18_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		sta :result  ; Save in low byte for later.
		asl          ; Times 4
		asl          ; Times 8
		asl          ; Times 16
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *2. Now Accumulator is * 18
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT19_M   A
;-------------------------------------------------------------------------------
; mByte_Mult19_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*16 + *2 + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult19_M result,address
	.if %%0<>2
		.error "mByte_Mult19_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		sta :result  ; Save in low byte for later.
		asl          ; Times 4
		asl          ; Times 8
		asl          ; Times 16
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *2. Now Accumulator is * 18
		clc          ; Clear carry/borrow
		adc :address ; Add to original value. Now Accumulator is * 19
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT20_M   A
;-------------------------------------------------------------------------------
; mByte_Mult20_M <result (address)>, <address>
;
; Multiply value from address, store at result. ((*4 + 1) * 4)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult20_M result,address
	.if %%0<>2
		.error "mByte_Mult20_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 5
		asl          ; 5 * 2 is 10
		asl          ; 10 * 2 is 20
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT21_M   A
;-------------------------------------------------------------------------------
; mByte_Mult21_M <result (address)>, <address>
;
; Multiply value from address, store at result. ((*4 + 1) * 4 + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult21_M result,address
	.if %%0<>2
		.error "mByte_Mult21_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 5
		asl          ; 5 * 2 is 10
		asl          ; 10 * 2 is 20
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 21
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT22_M   A
;-------------------------------------------------------------------------------
; mByte_Mult22_M <result (address)>, <address>
;
; Multiply value from address, store at result. (((*4 + 1) * 2 + 1) * 2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult22_M result,address
	.if %%0<>2
		.error "mByte_Mult22_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 5
		asl          ; 5 * 2 is 10
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 11
		asl          ; 11 * 2 is 22
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT23_M   A
;-------------------------------------------------------------------------------
; mByte_Mult23_M <result (address)>, <address>
;
; Multiply value from address, store at result. ((*4 + 1) * 4 + *2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult23_M result,address
	.if %%0<>2
		.error "mByte_Mult23_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		sta :result  ; Save in low byte for later.
		asl          ; Times 4
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 5
		asl          ; 5 * 2 is 10
		asl          ; 10 * 2 is 20
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 21
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *2. Now Accumulator is * 23
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT24_M   A
;-------------------------------------------------------------------------------
; mByte_Mult24_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*2 + 1) * 8) 
;
;-------------------------------------------------------------------------------
.macro mByte_Mult24_M result,address
	.if %%0<>2
		.error "mByte_Mult24_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 3
		asl          ; Times 2 again.   Now Accumulator is * 6
		asl          ; Times 2 again.   Now Accumulator is * 12
		asl          ; Times 2 again.   Now Accumulator is * 24
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT25_M   A
;-------------------------------------------------------------------------------
; mByte_Mult25_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*2 + 1) * 8 + 1) 
;
;-------------------------------------------------------------------------------
.macro mByte_Mult25_M result,address
	.if %%0<>2
		.error "mByte_Mult25_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 3
		asl          ; Times 2 again.   Now Accumulator is * 6
		asl          ; Times 2 again.   Now Accumulator is * 12
		asl          ; Times 2 again.   Now Accumulator is * 24
		clc          ; Clear carry/borrow
		adc :address ; Add to original value. Now Accumulator is * 25
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT26_M   A
;-------------------------------------------------------------------------------
; mByte_Mult26_M <result (address)>, <address>
;
; Multiply value from address, store at result. (((*2 + 1) * 4 + 1) * 2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult26_M result,address
	.if %%0<>2
		.error "mByte_Mult26_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 3
		asl          ; Times 2 again.   Now Accumulator is * 6
		asl          ; Times 2 again.   Now Accumulator is * 12
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 13
		asl          ; Times 2 again.   Now Accumulator is * 26
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT27_M   A
;-------------------------------------------------------------------------------
; mByte_Mult27_M <result (address)>, <address>
;
; Multiply value from address, store at result. (((*2 + 1) * 4 + 1) * 2 + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult27_M result,address
	.if %%0<>2
		.error "mByte_Mult27_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 3
		asl          ; Times 2 again.   Now Accumulator is * 6
		asl          ; Times 2 again.   Now Accumulator is * 12
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 13
		asl          ; Times 2 again.   Now Accumulator is * 26
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 27
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT28_M   A
;-------------------------------------------------------------------------------
; mByte_Mult28_M <result (address)>, <address>
;
; Multiply value from address, store at result. (((*2 + 1) * 4 + 1) * 2 + *2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult28_M result,address
	.if %%0<>2
		.error "mByte_Mult28_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		sta :result  ; Save in low byte for later.
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 3
		asl          ; Times 2 again.   Now Accumulator is * 6
		asl          ; Times 2 again.   Now Accumulator is * 12
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 13
		asl          ; Times 2 again.   Now Accumulator is * 26
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *2. Now Accumulator is * 28
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT29_M   A
;-------------------------------------------------------------------------------
; mByte_Mult29_M <result (address)>, <address>
;
; Multiply value from address, store at result. (((*2 + 1) * 4 + 1) * 2 + *2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult29_M result,address
	.if %%0<>2
		.error "mByte_Mult29_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 3
		sta :result  ; Save in low byte for later.
		asl          ; Times 2 again.   Now Accumulator is * 6
		asl          ; Times 2 again.   Now Accumulator is * 12
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 13
		asl          ; Times 2 again.   Now Accumulator is * 26
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *3. Now Accumulator is * 29
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT30_M   A
;-------------------------------------------------------------------------------
; mByte_Mult30_M <result (address)>, <address>
;
; Multiply value from address, store at result. ((*4 + 1) * 4 + (*4 + 1)) 
;
;-------------------------------------------------------------------------------
.macro mByte_Mult30_M result,address
	.if %%0<>2
		.error "mByte_Mult30_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2.
		asl          ; Times 4.
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 5
		asl          ; 5 * 2 is 10
		sta :result  ; save in low byte of Result
		asl          ; Times 2. Now Accumulator is * 20
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *10. Now Accumulator is * 30
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT31_M   A
;-------------------------------------------------------------------------------
; mByte_Mult31_M <result (address)>, <address>
;
; Note that both 10 * 3 + 1 and 3 * 8 + 6 + 1 use the same number of 
; instructions and same number of bytes.
;
; Multiply value from address, store at result. (((*4 + 1) * 4 + (*4 + 1)) + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult31_M result,address
	.if %%0<>2
		.error "mByte_Mult31_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2.
		asl          ; Times 4.
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 5
		asl          ; 5 * 2 is 10
		sta :result  ; save in low byte of Result
		asl          ; Times 2. Now Accumulator is * 20
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *10. Now Accumulator is * 30
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 31
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT32_M   A
;-------------------------------------------------------------------------------
; mByte_Mult32_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*32)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult32_M result,address
	.if %%0<>2
		.error "mByte_Mult32_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		asl          ; Times 8
		asl          ; Times 16
		asl          ; Times 32
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT33_M   A
;-------------------------------------------------------------------------------
; mByte_Mult33_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*32 + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult33_M result,address
	.if %%0<>2
		.error "mByte_Mult33_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		asl          ; Times 8
		asl          ; Times 16
		asl          ; Times 32
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 33
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT34_M   A
;-------------------------------------------------------------------------------
; mByte_Mult34_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*32 + *2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult34_M result,address
	.if %%0<>2
		.error "mByte_Mult34_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		asl          ; Times 8
		asl          ; Times 16
		clc          ; Clear carry/borrow
		adc :address ; Add to original value. Now Accumulator is * 17
		asl          ; 17 * 2 is 34
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT35_M   A
;-------------------------------------------------------------------------------
; mByte_Mult35_M <result (address)>, <address>
;
; Multiply value from address, store at result.  ((*16 + 1) * 2 + 1)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult35_M result,address
	.if %%0<>2
		.error "mByte_Mul35_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		asl          ; Times 8
		asl          ; Times 16
		clc          ; Clear carry/borrow
		adc :address ; Add to original value. Now Accumulator is * 17
		asl          ; 17 * 2 is 34
		clc          ; Clear carry/borrow
		adc :address ; Add to original value. Now Accumulator is * 35
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT36_M   A
;-------------------------------------------------------------------------------
; mByte_Mult36_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*32 + *4)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult36_M result,address
	.if %%0<>2
		.error "mByte_Mult36_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		sta :result  ; Save in low byte for later.
		asl          ; Times 8
		asl          ; Times 16
		asl          ; Times 32
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *4. Now Accumulator is * 36
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT37_M   A
;-------------------------------------------------------------------------------
; mByte_Mult37_M <result (address)>, <address>
;
; Multiply value from address, store at result. (*32 + 1 + *4)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult37_M result,address
	.if %%0<>2
		.error "mByte_Mult37_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		sta :result  ; Save in low byte for later.
		asl          ; Times 8
		asl          ; Times 16
		asl          ; Times 32
		clc          ; Clear carry/borrow
		adc :address ; Add to original. Now Accumulator is * 33
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *4. Now Accumulator is * 37
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT38_M   A
;-------------------------------------------------------------------------------
; mByte_Mult38_M <result (address)>, <address>
;
; Multiply value from address, store at result. ((*16 + *2 + 1) * 2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult38_M result,address
	.if %%0<>2
		.error "mByte_Mult38_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		sta :result  ; Save in low byte for later.
		asl          ; Times 4
		asl          ; Times 8
		asl          ; Times 16
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *2. Now Accumulator is * 18
		clc          ; Clear carry/borrow
		adc :address ; Add to original value. Now Accumulator is * 19
		asl          ; Times 2.  Now Accumulator is * 38.
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT39_M   A
;-------------------------------------------------------------------------------
; mByte_Mult39_M <result (address)>, <address>
;
; Multiply value from address, store at result.  ((*16 + 1) * 2 + 1 + *4)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult39_M result,address
	.if %%0<>2
		.error "mByte_Mul39_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		sta :result  ; Save in low byte for later.
		asl          ; Times 8
		asl          ; Times 16
		clc          ; Clear carry/borrow
		adc :address ; Add to original value. Now Accumulator is * 17
		asl          ; 17 * 2 is 34
		clc          ; Clear carry/borrow
		adc :address ; Add to original value. Now Accumulator is * 35
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *4. Now Accumulator is * 39
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT40_M   A
;-------------------------------------------------------------------------------
; mByte_Mult40_M <result (address)>, <address>
;
; Multiply value from address, store at result.  (*32 + *8)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult40_M result,address
	.if %%0<>2
		.error "mByte_Mul40_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		asl          ; Times 8
		sta :result  ; Save in low byte for later.
		asl          ; Times 16
		asl          ; Times 32.
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *8. Now Accumulator is * 40
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT41_M   A
;-------------------------------------------------------------------------------
; mByte_Mult41_M <result (address)>, <address>
;
; Multiply value from address, store at result.  (*32 + *8 + 1
;
;-------------------------------------------------------------------------------
.macro mByte_Mult41_M result,address
	.if %%0<>2
		.error "mByte_Mul41_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		asl          ; Times 8
		sta :result  ; Save in low byte for later.
		asl          ; Times 16
		asl          ; Times 32.
		clc          ; Clear carry/borrow
		adc :result  ; Add to the saved *8. Now Accumulator is * 40
		clc          ; Clear carry/borrow
		adc :address ; Add to original value. Now Accumulator is * 41
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        BYTE_MULT42_M   A
;-------------------------------------------------------------------------------
; mByte_Mult42_M <result (address)>, <address>
;
; Multiply value from address, store at result. (((*4 + 1) * 4 + 1) * 2)
;
;-------------------------------------------------------------------------------
.macro mByte_Mult42_M result,address
	.if %%0<>2
		.error "mByte_Mult42_M: 2 arguments (result addr, address) required."
	.else
		lda :address ; Low byte at Address
		asl          ; Times 2
		asl          ; Times 4
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 5
		asl          ; 5 * 2 is 10
		asl          ; 10 * 2 is 20
		clc          ; Clear carry/borrow
		adc :address ; Add to original value.  Now Accumulator is * 21
		asl          ; 21 * 2 is 42
		sta :result  ; save in low byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         BYTE_MULT   A
;-------------------------------------------------------------------------------
; mByte_Mult <result (address)>, <Multiplicand (address)>, <Multiplier>
;
; Result = Multiplicand * Multiplier
;
; or   X = Y * Z.
;
; Multiply Multiplicand times the multiplier.  Store value in Result.
;
; RESULT ADDRESS CANNOT BE THE SAME AS MULTIPLICAND ADDRESS.
; 
; MULTIPLIER IS A CONSTANT VALUE, NOT AN ADDRESS!
;
; Multiplicand will not be modified.
;
; If Result does not fit in a Byte, too bad, so sad.  Use mWord_Mult instead.
;
; This provides a wrapper that figures out which math macro to call
; slightly simplifying the syntax for calling the right macro.
;
;-------------------------------------------------------------------------------
.macro mByte_Mult result,multiplicand,multiplier
	.if %%0<>3
		.error "mByte_Mult: 3 arguments (result addr, multiplicand addr,multiplier) required."
	.else
		.if :result=:multiplicand
			.error "mByte_Mult: result addr and multiplicand addr cannot be the same."
		.else
			.if :multiplier=0 ; Duh.
				lda #$00
				sta :result
			.endif
			.if :multiplier=1 ; Double Duh.
				lda multiplicand
				sta result
			.endif
			.if :multiplier=2
				mByte_Mult2_M :result,:multiplicand
			.endif
			.if :multiplier=3
				mByte_Mult3_M :result,:multiplicand
			.endif
			.if :multiplier=4
				mByte_Mult4_M :result,:multiplicand
			.endif
			.if :multiplier=5
				mByte_Mult5_M :result,:multiplicand
			.endif
			.if :multiplier=6
				mByte_Mult6_M :result,:multiplicand
			.endif
			.if :multiplier=7
				mByte_Mult7_M :result,:multiplicand
			.endif
			.if :multiplier=8
				mByte_Mult8_M :result,:multiplicand
			.endif
			.if :multiplier=9
				mByte_Mult9_M :result,:multiplicand
			.endif
			.if :multiplier=10
				mByte_Mult10_M :result,:multiplicand
			.endif
			.if :multiplier=11
				mByte_Mult11_M :result,:multiplicand
			.endif
			.if :multiplier=12
				mByte_Mult12_M :result,:multiplicand
			.endif
			.if :multiplier=13
				mByte_Mult13_M :result,:multiplicand
			.endif
			.if :multiplier=12
				mByte_Mult14_M :result,:multiplicand
			.endif
			.if :multiplier=15
				mByte_Mult15_M :result,:multiplicand
			.endif
			.if :multiplier=16
				mByte_Mult16_M :result,:multiplicand
			.endif
			.if :multiplier=17
				mByte_Mult17_M :result,:multiplicand
			.endif
			.if :multiplier=18
				mByte_Mult18_M :result,:multiplicand
			.endif
			.if :multiplier=19
				mByte_Mult19_M :result,:multiplicand
			.endif
			.if :multiplier=20
				mByte_Mult20_M :result,:multiplicand
			.endif
			.if :multiplier=21
				mByte_Mult21_M :result,:multiplicand
			.endif
			.if :multiplier=22
				mByte_Mult22_M :result,:multiplicand
			.endif
			.if :multiplier=23
				mByte_Mult23_M :result,:multiplicand
			.endif
			.if :multiplier=24
				mByte_Mult24_M :result,:multiplicand
			.endif
			.if :multiplier=25
				mByte_Mult25_M :result,:multiplicand
			.endif
			.if :multiplier=26
				mByte_Mult26_M :result,:multiplicand
			.endif
			.if :multiplier=27
				mByte_Mult27_M :result,:multiplicand
			.endif
			.if :multiplier=28
				mByte_Mult28_M :result,:multiplicand
			.endif
			.if :multiplier=29
				mByte_Mult29_M :result,:multiplicand
			.endif
			.if :multiplier=30
				mByte_Mult30_M :result,:multiplicand
			.endif
			.if :multiplier=31
				mByte_Mult31_M :result,:multiplicand
			.endif
			.if :multiplier=32
				mByte_Mult32_M :result,:multiplicand
			.endif
			.if :multiplier=33
				mByte_Mult33_M :result,:multiplicand
			.endif
			.if :multiplier=34
				mByte_Mult34_M :result,:multiplicand
			.endif
			.if :multiplier=35
				mByte_Mult35_M :result,:multiplicand
			.endif
			.if :multiplier=36
				mByte_Mult36_M :result,:multiplicand
			.endif
			.if :multiplier=37
				mByte_Mult37_M :result,:multiplicand
			.endif
			.if :multiplier=38
				mByte_Mult38_M :result,:multiplicand
			.endif
			.if :multiplier=39
				mByte_Mult39_M :result,:multiplicand
			.endif
			.if :multiplier=40
				mByte_Mult40_M :result,:multiplicand
			.endif
			.if :multiplier=41
				mByte_Mult41_M :result,:multiplicand
			.endif
			.if :multiplier=42
				mByte_Mult42_M :result,:multiplicand
			.endif

		.endif
	.endif
.endm

mByte_Mult











;===============================================================================
; 16-BIT MATH - ADDITION
;===============================================================================
; 
;===============================================================================

;-------------------------------------------------------------------------------
;                                                        WORD_V_PLUS_V   A
;-------------------------------------------------------------------------------
; mWord_V_Add_V <result (address)>, <value1>, <value2>
;
; Add literal <Value2> from literal <Value1>, store in <Result (address)>.
;
; or 
; result = Value1 + Value2
; 
; or (more exactly) 
; Dpoke result, Value1 + Value2
;-------------------------------------------------------------------------------
.macro mWord_V_Add_V result,value1,value2
	.if %%0<>3
		.error "mWord_V_Add_V: 3 arguments (result addr, value1, value2) required."
	.else
		clc           ; clear carry/borrow
		lda #<:value1 ; Low byte of Value1
		adc #<:value2 ; add low byte of Value2
		sta :result   ; save in low byte of Result
		lda #>:value1 ; high byte of Value1
		adc #>:value2 ; add high byte of Value2
		sta :result+1 ; save in high byte of Result
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        WORD_M_PLUS_V   A
;-------------------------------------------------------------------------------
; mWord_M_Add_V <result (address)>, <address>, <value>
;
; Add literal <Value> from value at <Address>, store in <Result (address)>.
;
; or 
; result = address + Value
; 
; or (more exactly) 
; Dpoke result, Dpeek(address) + Value 
;-------------------------------------------------------------------------------
.macro mWord_M_Add_V result,address,value
	.if %%0<>3
		.error "mWord_M_Add_V: 3 arguments (result addr, addr, value) required."
	.else
		clc            ; clear carry/borrow
		lda :address   ; Low byte of Address
		adc #<:value   ; add low byte of Value
		sta :result    ; save in low byte of Result
		lda :address+1 ; high byte of Address
		adc #>:value   ; add high byte of Value
		sta :result+1  ; save in high byte of Result 
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        WORD_V_PLUS_M   A
;-------------------------------------------------------------------------------
; mWord_V_Add_M <result (address)>, <value>, <address>
;
; Add value at <Address> from literal <Value>, store in <Result (address)>.
;
; or 
; result = Value + Address
; 
; or (more exactly) 
; Dpoke result, Value + Dpeek(address)
;-------------------------------------------------------------------------------
.macro mWord_V_Add_M result,value,address
	.if %%0<>3
		.error "mWord_V_Add_M: 3 arguments (result addr, value, addr) required."
	.else
		clc            ; clear carry/borrow
		lda #<:value   ; Low byte of Value
		adc :address   ; add low byte of Address
		sta :result    ; save in low byte of Result
		lda #>:value   ; high byte of Value
		adc :address+1 ; add high byte of Address
		sta :result+1  ; save in high byte of Result 
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                        WORD_M_PLUS_M   A
;-------------------------------------------------------------------------------
; mWord_M_Add_M <result (address)>, <address1>, <address2>
;
; Add value at <address2> from value at <Address1>, store in <Result (address)>.
;
; or 
; result = address1 + address2
; 
; or (more exactly) 
; Dpoke result, Dpeek(address1) + Dpeek(address2) 
;-------------------------------------------------------------------------------
.macro mWord_M_Add_M result,address1,address2
	.if %%0<>3
		.error "mWord_M_Add_M: 3 arguments (result addr, addr1, addr2) required."
	.else
		clc             ; clear carry/borrow
		lda :address1   ; Low byte of Address
		adc :address2   ; add low byte of Value
		sta :result     ; save in low byte of Result
		lda :address1+1 ; high byte of Address
		adc :address2+1 ; add high byte of Value
		sta :result+1   ; save in high byte of Result 
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         WORD_ADD   A
;-------------------------------------------------------------------------------
; mWord_Add <result (address)>, <argument1>, <argument2>
;
; Add value at <argument2> to value at/of <argument1>, 
; store in <Result (address)>.
;
; This provides a wrapper that figures out which math macro to call
; simplifying the choice of M and V.
;
; If argument2 is a value less than 256 it will assume that argument2
; is a V parameter for explicity value.  If it is greater then 256 it
; will assume it is an address.
; 
; This is correct in most cases.  However, if page zero addresses are 
; intended for arguments then the programmer must explicitly
; invoke the M_Sub_M macro.  
;
; This macro will only treat argument1 as an address if it equals the 
; result address assuming common use of X=X+Y.  And, it is possible 
; this choice may be wrong.  
; Example of the unexpected: Result is Page 0 addresss $80, arg1 is value $80.
;-------------------------------------------------------------------------------
.macro mWord_Add result,argument1,argument2
	.if %%0<>3
		.error "mWord_Add: 3 arguments (result addr, arg1, arg2) required."
	.else
		.if :argument1>255 .OR :result=:argument1 ; arg1 = M and allowing for X = X + Y
			.if :argument2>255 ; arg2 = M
				mWord_M_Add_M :result,:argument1,:argument2 ; M = M + M
			.else ; arg2 = V
				mWord_M_Add_V :result,:argument1,:argument2 ; M = M + V
			.endif
		.else     ; arg1 =  V
			.if :argument2>255 ; arg2 = M
				mWord_V_Add_M :result,:argument1,:argument2 ; M = V + M
			.else ; arg2 = V
				mWord_V_Add_V :result,:argument1,:argument2 ; M = V + V
			.endif
		.endif
	.endif
.endm



;===============================================================================
; 16-BIT MATH - SUBTRACTION
;===============================================================================
; 
;===============================================================================

;-------------------------------------------------------------------------------
;                                                         WORD_V_SUB_V   A
;-------------------------------------------------------------------------------
; mWord_V_Sub_V <result (address)>, <value1>, <value2>
;
; Subtract literal <Value2> from literal <Value1>, store in <Result (address)>.
;
; or 
; result = Value1 - Value2
; 
; or (more exactly) 
; Dpoke result, Value1 - Value2
;-------------------------------------------------------------------------------
.macro mWord_V_Sub_V result,value1,value2
	.if %%0<>3
		.error "mWord_V_Sub_V: 3 arguments (result addr, value1, value2) required."
	.else
		sec           ; set carry/borrow
		lda #<:value1 ; Low byte of Value1
		sbc #<:value2 ; subtract low byte of Value2
		sta :result   ; save in low byte of Result
		lda #>:value1 ; high byte of Value1
		sbc #>:value2 ; subtract high byte of Value2
		sta :result+1 ; save in high byte of Result 
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         WORD_M_SUB_V   A
;-------------------------------------------------------------------------------
; mWord_M_Sub_V <result (address)>, <address>, <value>
;
; Subtract literal <Value> from value at <Address>, store in <Result (address)>.
;
; or 
; result = address - Value
; 
; or (more exactly) 
; Dpoke result, Dpeek(address) - Value 
;-------------------------------------------------------------------------------
.macro mWord_M_Sub_V result,address,value
	.if %%0<>3
		.error "mWord_M_Sub_V: 3 arguments (result addr, addr, value) required."
	.else
		sec            ; set carry/borrow
		lda :address   ; Low byte of Address
		sbc #<:value   ; subtract low byte of Value
		sta :result    ; save in low byte of Result
		lda :address+1 ; high byte of Address
		sbc #>:value   ; subtract high byte of Value
		sta :result+1  ; save in high byte of Result 
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         WORD_V_SUB_M   A
;-------------------------------------------------------------------------------
; mWord_V_Sub_M <result (address)>, <value>, <address>
;
; Subtract value at <Address> from literal <Value>, store in <Result (address)>.
;
; or 
; result = Value - Address
; 
; or (more exactly) 
; Dpoke result, Value - Dpeek(address)
;-------------------------------------------------------------------------------
.macro mWord_V_Sub_M result,value,address
	.if %%0<>3
		.error "mWord_V_Sub_M: 3 arguments (result addr, value, addr) required."
	.else
		sec            ; set carry/borrow
		lda #<:value   ; Low byte of Value
		sbc :address   ; subtract low byte of Address
		sta :result    ; save in low byte of Result
		lda #>:value   ; high byte of Value
		sbc :address+1 ; subtract high byte of Address
		sta :result+1  ; save in high byte of Result 
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         WORD_M_SUB_M   A
;-------------------------------------------------------------------------------
; mWord_M_Sub_M <result (address)>, <address1>, <address2>
;
; Subtract value at <address2> from value at <Address1> and store 
; in <Result (address)>.
;
; or 
; result = address1 - address2
; 
; or (more exactly) 
; Dpoke result, Dpeek(address1) - Dpeek(address2) 
;-------------------------------------------------------------------------------
.macro mWord_M_Sub_M result,address1,address2
	.if %%0<>3
		.error "mWord_M_Sub_M: 3 arguments (result addr, addr1, addr2) required."
	.else
		sec        ; set carry/borrow
		lda :address1   ; Low byte of Address
		sbc :address2   ; subtract low byte of Value
		sta :result     ; save in low byte of Result
		lda :address1+1 ; high byte of Address
		sbc :address2+1 ; subtract high byte of Value
		sta :result+1   ; save in high byte of Result 
	.endif
.endm


;-------------------------------------------------------------------------------
;                                                         WORD_SUB   A
;-------------------------------------------------------------------------------
; mWord_Sub <result (address)>, <argument1>, <argument2>
;
; Subtract value at <argument2> from value at/of <argument1>, 
; store in <Result (address)>.
;
; This provides a wrapper that figures out which math macro to call
; simplifying the choice of M and V.
;
; If argument2 is a value less than 256 it will assume that argument2
; is a V parameter for explicity value.  If it is greater then 256 it
; will assume it is an address.
; 
; This is correct in most cases.  However, if page zero addresses are 
; intended for arguments then the programmer must explicitly
; invoke the M_Sub_M macro.  
;
; This macro will treat argument1 as an address if it equals the 
; result address assuming common use of X=X-Y.  And, it is possible this 
; choice may be wrong.  
; Example of the unexpected: Result is Page 0 addresss $80, arg1 is value $80.
;-------------------------------------------------------------------------------
.macro mWord_Sub result,argument1,argument2
	.if %%0<>3
		.error "mWord_Sub: 3 arguments (result addr, arg1, arg2) required."
	.else
		.if :argument1>255 .OR :result=:argument1 ; arg1 = M and allowing for X = X - Y
			.if :argument2>255 ; arg2 = M
				mWord_M_Sub_M :result,:argument1,:argument2 ; M = M - M
			.else ; arg2 = V
				mWord_M_Sub_V :result,:argument1,:argument2 ; M = M - V
			.endif
		.else     ; arg1 =  V
			.if :argument2>255 ; arg2 = M
				mWord_V_Sub_M :result,:argument1,:argument2 ; M = V - M
			.else ; arg2 = V
				mWord_V_Sub_V :result,:argument1,:argument2 ; M = V - V
			.endif
		.endif
	.endif
.endm



;===============================================================================
; 8-BIT MATH - MULTIPLICATION
;===============================================================================
; 
;===============================================================================
