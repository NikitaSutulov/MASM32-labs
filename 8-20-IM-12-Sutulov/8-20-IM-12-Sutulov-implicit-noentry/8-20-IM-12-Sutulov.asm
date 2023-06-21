.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\dialogs.inc
include \masm32\include\masm32.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\masm32.lib   ;  FloatToStr
includelib \masm32\lib\user32.lib   ;  MessageBox, wsprintf
includelib \masm32\lib\kernel32.lib ;  ExitProcess

includelib 8-20-IM-12-Sutulov-lib.lib

SutulovPerformCalculation proto :ptr qword, :ptr qword, :ptr qword, :ptr qword, :ptr qword

.data
    ; arrays
    SutulovAArray dq 4.1, -5.9, 19.6, 3.9, 2.8
    SutulovBArray dq 5.4, -7.4, 20.6, 4.3, 7.9
    SutulovCArray dq 3.3, 4.3, -40.5, -5.4, -8.8
    SutulovDArray dq 1.5, -0.2, 19.2, -2.5, 0.1

    ; window caption
    SutulovWindowCaption db "Assembly lab8 Nikita Sutulov IM-12 Group, variant 20", 0

    ; window text template
    SutulovExampleForm db "This is the example #%d", 0
    SutulovFormula db "The formula is: (arctg(2 * c) / d + 2) / (b - a - 1)", 0
    SutulovCurrentValuesForm db "a = %s, b = %s, c = %s, d = %s", 0
    SutulovExpressionForm db "The expression is: (arctg(2 * %s) / %s + 2) / (%s - %s - 1)", 0
    SutulovFinalResultForm db "Final result: %s", 0
    SutulovErrorMessage db "There is an error because the denominator is equal to zero!", 0

    SutulovFinalForm db "%s", 10 ,13,
                        "%s", 10, 13,
                        "%s", 10, 13,
                        "%s", 10, 13,
                        "%s", 0

    SutulovErrorForm db "%s", 10, 13,
                        "%s", 10, 13,
                        "%s", 10, 13,
                        "%s", 0

    SutulovErrorMessageForm db "%s", 0


.data?
    ; buffers
    SutulovExampleBuffer db 64 dup (?)
    SutulovCurrentValuesBuffer db 64 dup (?)
    SutulovExpressionBuffer db 128 dup (?)
    SutulovFinalResultBuffer db 64 dup (?)
    SutulovFinalBuffer db 256 dup (?)

    SutulovFinalResult dq ?
    SutulovFinalResultPointer dd ?

    SutulovCurrentAString db 16 dup (?)
    SutulovCurrentBString db 16 dup (?)
    SutulovCurrentCString db 16 dup (?)
    SutulovCurrentDString db 16 dup (?)
    SutulovFinalResultString db 16 dup (?)

.code
main:

    lea ecx, SutulovFinalResult
    mov SutulovFinalResultPointer, ecx
    
    mov edi, 0 ; counter for indexes
    mov esi, 1 ; counter for example numbers
    loopToIterateThroughArrays:
        cmp edi, 5
        je exitLoop

        invoke SutulovPerformCalculation, addr SutulovAArray[edi*8], addr SutulovBArray[edi*8], 
        addr SutulovCArray[edi*8], addr SutulovDArray[edi*8], SutulovFinalResultPointer

        cmp eax, 1
        je denominatorZero

    normalWindow:
        
        ; converting float numbers to strings for them to be shown correctly
        invoke FloatToStr, SutulovAArray[edi * 8], offset SutulovCurrentAString
        invoke FloatToStr, SutulovBArray[edi * 8], offset SutulovCurrentBString
        invoke FloatToStr, SutulovCArray[edi * 8], offset SutulovCurrentCString
        invoke FloatToStr, SutulovDArray[edi * 8], offset SutulovCurrentDString
        invoke FloatToStr, SutulovFinalResult, offset SutulovFinalResultString
        
        ; making the window text
        invoke wsprintf, offset SutulovExampleBuffer, 
            offset SutulovExampleForm, esi
        invoke wsprintf, offset SutulovCurrentValuesBuffer, 
            offset SutulovCurrentValuesForm, 
            offset SutulovCurrentAString, offset SutulovCurrentBString, 
            offset SutulovCurrentCString, offset SutulovCurrentDString
        invoke wsprintf, offset SutulovExpressionBuffer, 
            offset SutulovExpressionForm, 
            offset SutulovCurrentCString, offset SutulovCurrentDString, 
            offset SutulovCurrentBString, offset SutulovCurrentAString
        invoke wsprintf, offset SutulovFinalResultBuffer, 
            offset SutulovFinalResultForm, offset SutulovFinalResultString
        
        invoke wsprintf, offset SutulovFinalBuffer, offset SutulovFinalForm, 
            offset SutulovExampleBuffer, offset SutulovFormula, 
            offset SutulovCurrentValuesBuffer, offset SutulovExpressionBuffer,
            offset SutulovFinalResultBuffer

        invoke MessageBox, 0, offset SutulovFinalBuffer, offset SutulovWindowCaption, 0

        inc edi
        inc esi
        jmp loopToIterateThroughArrays

    denominatorZero:
        
        ; converting float numbers to strings for them to be shown correctly
        invoke FloatToStr, SutulovAArray[edi * 8], offset SutulovCurrentAString
        invoke FloatToStr, SutulovBArray[edi * 8], offset SutulovCurrentBString
        invoke FloatToStr, SutulovCArray[edi * 8], offset SutulovCurrentCString
        invoke FloatToStr, SutulovDArray[edi * 8], offset SutulovCurrentDString
        
        invoke wsprintf, offset SutulovExampleBuffer, 
            offset SutulovExampleForm, esi
        invoke wsprintf, offset SutulovCurrentValuesBuffer, 
            offset SutulovCurrentValuesForm, 
            offset SutulovCurrentAString, offset SutulovCurrentBString, 
            offset SutulovCurrentCString, offset SutulovCurrentDString
        invoke wsprintf, offset SutulovExpressionBuffer, 
            offset SutulovExpressionForm, 
            offset SutulovCurrentCString, offset SutulovCurrentDString, 
            offset SutulovCurrentBString, offset SutulovCurrentAString
        invoke wsprintf, offset SutulovFinalResultBuffer, 
            offset SutulovErrorMessageForm, offset SutulovErrorMessage

        invoke wsprintf, offset SutulovFinalBuffer, offset SutulovErrorForm,
            offset SutulovExampleBuffer,
            offset SutulovCurrentValuesBuffer,
            offset SutulovExpressionBuffer,
            offset SutulovFinalResultBuffer

        invoke MessageBox, 0, offset SutulovFinalBuffer, offset SutulovWindowCaption, 0
        inc edi
        inc esi
        jmp loopToIterateThroughArrays

    exitLoop:
        invoke ExitProcess, 0

end main