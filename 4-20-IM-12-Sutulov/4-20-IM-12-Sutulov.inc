SutulovShowOutput macro message, title
	;; hidden comment
	invoke MessageBox, 0, addr message, addr title, 0 ; invoking MessageBox with the arguments given to macro
endm

SutulovEncrypt macro
	;; hidden comment
	xor dl, byte ptr [SutulovKey + bx] ; doing the XOR operation
endm

SutulovCompare macro
	local loopToCountLength, exitLengthCountingLoop, loopToComparePasswords
	; Loop to count the length of the entered password
	loopToCountLength:
		cmp byte ptr [edi], 0
		je exitLengthCountingLoop
		inc cx
		inc edi
		jmp loopToCountLength
	
	; Compare the entered password length with the length of the true one
		exitLengthCountingLoop:
		cmp cx, SutulovPasswordLength
		jne handleInvalidPassword

	; Loop to compare the passwords by characters
	loopToComparePasswords:
		cmp bx, SutulovPasswordLength
		je handleValidPassword
		mov dl, byte ptr [SutulovReceivedPassword + bx] ;; hidden comment
		mov dh, byte ptr [SutulovPassword + bx]
		SutulovEncrypt ; calling the encryption macro
		cmp dl, dh
		jne handleInvalidPassword
		inc bx
		jmp loopToComparePasswords
endm