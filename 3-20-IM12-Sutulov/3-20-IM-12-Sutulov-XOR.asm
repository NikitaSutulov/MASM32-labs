.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc
includelib \masm32\lib\msvcrt.lib

DialogHandler	PROTO :DWORD, :DWORD, :DWORD, :DWORD

.data
	SutulovPassword					db "/+9(<.>", 0
	SutulovProtectedWindowTitle	db "This window is protected with password!", 0
	SutulovProtectedData		db "Full name: Sutulov Nikita Olehovych", 13, 10,
									"Gradebook number: IM-1229", 13, 10,
									"Date of birth: 12.06.2004", 0
	SutulovDeniedWindowTitle	db "Wrong password!", 0
	SutulovDeniedWindowText		db "The password you entered is wrong.", 0
	SutulovKey				db "aBRAham", 0

.data?
	SutulovReceivedPassword		db 16 dup (?)
	SutulovPasswordLength		dw ?

.code	
main:    
	
	Dialog "Assembly lab3 Nikita Sutulov IM-12 Group, variant 20",	\
		"Verdana", 11,												\            							    
        WS_OVERLAPPED or											\ 
		WS_SYSMENU or DS_CENTER,									\   							
        4,															\
		10, 10,														\
		160, 100,													\
		1024

		DlgStatic "Please enter the password:", SS_CENTER, 30,  12, 100,  10, 228	
		DlgEdit   WS_BORDER, 10,  25, 140, 15, 1337		
		DlgButton "See the data", WS_TABSTOP, 10,  55, 50,  15, IDOK 				
		DlgButton "Cancel", WS_TABSTOP, 100, 55, 50,  15, IDCANCEL 	

	CallModalDialog 0, 0, DialogHandler, NULL


    ValidateReceivedPassword proc

		invoke StrLen, offset SutulovPassword
		mov SutulovPasswordLength, ax
 		mov edi, offset SutulovReceivedPassword
		
		; Initialize registers
		xor bx, bx
		xor cx, cx
		cld

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
			mov dl, byte ptr [SutulovReceivedPassword + bx]
			mov dh, byte ptr [SutulovPassword + bx]
			xor dl, byte ptr [SutulovKey + bx]
			cmp dl, dh
			jne handleInvalidPassword
			inc bx
			jmp loopToComparePasswords
		
		; Handle invalid password
		handleInvalidPassword:                          
			invoke MessageBox, 0, offset SutulovDeniedWindowText, offset SutulovDeniedWindowTitle, 0
			invoke ExitProcess, 0
		return 0
		
		; Handle valid password
		handleValidPassword:                            
			invoke MessageBox, 0, offset SutulovProtectedData, offset SutulovProtectedWindowTitle, 0
			invoke ExitProcess, 0
		return 0

		; End of program
		xor eax, eax
		return 0
	ValidateReceivedPassword endp


	DialogHandler proc hWnd:DWORD, userMsg:DWORD, wParam:DWORD, lParam:DWORD
		cmp userMsg, WM_INITDIALOG
		je initDialog
		
		cmp userMsg, WM_COMMAND
		je handleCommand

		cmp userMsg, WM_CLOSE
		je closeProgram

		initDialog:
			invoke GetWindowLong, hWnd, GWL_USERDATA
			return 0

		handleCommand:
			cmp wParam, IDOK
			je handleOk
			cmp wParam, IDCANCEL
			je closeProgram
			return 0

		handleOk:
			invoke GetDlgItemText, hWnd, 1337, offset SutulovReceivedPassword, 512
			call ValidateReceivedPassword
			return 0

		closeProgram:
			invoke ExitProcess, 0

	DialogHandler endp

end main