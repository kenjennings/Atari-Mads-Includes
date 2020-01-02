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
;
; mByte_Add
; 
;===============================================================================
; 8-BIT MATH - SUBTRACTION
;===============================================================================
; mByte_V_Sub_V
; mByte_M_Sub_V
; mByte_V_Sub_M
; mByte_M_Sub_M
;
; mByte_Sub
;
;===============================================================================
; 8-BIT MATH - OTHER TRICKS
;===============================================================================
; mByte_Abs_M
; mByte_Abs_V
;
; mByte_Abs
;
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


;===============================================================================


;===============================================================================
; 8-BIT MATH - ADDITION
;===============================================================================
; mByte_V_Add_V
; mByte_M_Add_V
; mByte_V_Add_M
; mByte_M_Add_M
;
; mByte_Add
; 
;===============================================================================

;-------------------------------------------------------------------------------
;                                                        BYTE_V_ADD_V   A
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
;                                                        BYTE_M_ADD_V   A
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
;                                                        BYTE_V_ADD_M   A
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
;                                                        BYTE_M_ADD_M   A
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
; mByte_V_Sub_V
; mByte_M_Sub_V
; mByte_V_Sub_M
; mByte_M_Sub_M
;
; mByte_Sub
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
;
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
		bpl bAbs_plus ; positive
		eor #$FF      ; negative.  Exclusive OR bits
		sta :result   ; save result
		inc :result   ; Two's complement is +1
		jmp bAbs_done ; no branch can be reliable after the inc.
bAbs_plus
		sta :result   ; save result
bAbs_done
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
		bpl bAbs_plus  ; positive
		eor #$FF       ; negative.  Exclusive OR bits
		sta :result    ; save result
		inc :result    ; Two's complement is +1
		jmp bAbs_done  ; no branch can be reliable after the inc.
bAbs_plus
		sta :result    ; save result
bAbs_done
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

;-------------------------------------------------------------------------------
;                                                        WORD_V_ADD_V   A
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
;                                                        WORD_M_ADD_V   A
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
;                                                        WORD_V_ADD_M   A
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
;                                                        WORD_M_ADD_M   A
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
		.if [:argument1>255] .OR [:result=:argument1] ; arg1 = M and allowing for X = X + Y
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
; mWord_V_Sub_V
; mWord_M_Sub_V
; mWord_V_Sub_M
; mWord_M_Sub_M
;
; mWord_Sub
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
; is a V parameter for explicit value.  If it is greater then 256 it
; will assume it is an address.
; 
; This is correct in most cases.  However, if page zero addresses are 
; intended for arguments then the programmer must explicitly
; invoke the M_Sub_M macro.  
;
; This macro will treat argument1 as an address if it equals the 
; result address assuming common use of X=X-Y.  And, it is possible this 
; choice may be wrong.  
; Example of the unexpected: Result is Page 0 address $80, arg1 is value $80.
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


