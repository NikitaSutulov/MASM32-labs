.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

public SutulovCurrentB, SutulovCurrentA, SutulovConstOne
extern SutulovGetDenominator:PROTO

.data
    ; arrays
    SutulovAArray dq 4.1, -5.9, 19.6, 3.9, 2.8
    SutulovBArray dq 5.4, -7.4, 20.6, 4.3, 7.9
    SutulovCArray dq 3.3, 4.3, -40.5, -5.4, -8.8
    SutulovDArray dq 1.5, -0.2, 19.2, -2.5, 0.1

    ; window caption
    SutulovWindowCaption db "Assembly lab7 Nikita Sutulov IM-12 Group, variant 20", 0

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

    SutulovConstZero dq 0.0
    SutulovConstOne dq 1.0
    SutulovConstTwo dq 2.0

    SUTULOV_EIGHT_BYTES_OFFSET equ 8

.data?
    ; buffers
    SutulovExampleBuffer db 64 dup (?)
    SutulovCurrentValuesBuffer db 64 dup (?)
    SutulovExpressionBuffer db 128 dup (?)
    SutulovFinalResultBuffer db 64 dup (?)
    SutulovFinalBuffer db 256 dup (?)

    SutulovDenominator dt ?
    SutulovNumerator dt ?
    SutulovArctanResult dt ?
    SutulovArctanArgument dt ?

    SutulovCurrentA dq 1 dup (?)
    SutulovCurrentB dq 1 dup (?)
    SutulovFinalResult dq ?

    SutulovCurrentAString db 16 dup (?)
    SutulovCurrentBString db 16 dup (?)
    SutulovCurrentCString db 16 dup (?)
    SutulovCurrentDString db 16 dup (?)
    SutulovFinalResultString db 16 dup (?)

.code

SutulovGetNumeratorFirstTerm proc
    fld qword ptr [ecx]
    fld qword ptr [eax]
    fmul
    fstp SutulovArctanArgument
    ; calculating arctg(2 * c)
    fld SutulovArctanArgument
    fld qword ptr [edx]
    fpatan
    ; saving arctan calculation result to 10-bytes buffer
    fstp SutulovArctanResult

    ; calculating numerator: (arctg(2 * c) / d + 2)
    fld SutulovArctanResult
    fld qword ptr [ebx]
    fdiv ; d can't be 0 according to the task, so no zero checks needed here
    ret ; stack state 4
SutulovGetNumeratorFirstTerm endp

SutulovGetNumeratorSecondTerm proc
    push ebp ; stack state 7
    mov ebp, esp
    
    mov eax, [ebp+SUTULOV_EIGHT_BYTES_OFFSET]
    fld qword ptr [eax]

    pop ebp ; stack state 8
    ret 4 ; stack state 9
SutulovGetNumeratorSecondTerm endp


main:

    mov edi, 0 ; counter for indexes
    mov esi, 1 ; counter for example numbers
    loopToIterateThroughArrays:
        cmp edi, 5
        je exitLoop

        finit

        fld SutulovBArray[edi*SUTULOV_EIGHT_BYTES_OFFSET]
        fld SutulovAArray[edi*SUTULOV_EIGHT_BYTES_OFFSET]
        fstp SutulovCurrentA
        fstp SutulovCurrentB

        call SutulovGetDenominator ; stack state 1

        ; checking denominator for zero: 
        fcom SutulovConstZero
        fstsw ax
        sahf
        je denominatorZero
        
        ; saving denominator to 10-bytes buffer
        fstp SutulovDenominator
        
        lea eax, SutulovCArray[edi * SUTULOV_EIGHT_BYTES_OFFSET]
        lea ebx, SutulovDArray[edi * SUTULOV_EIGHT_BYTES_OFFSET]
        lea ecx, SutulovConstTwo
        lea edx, SutulovConstOne
        call SutulovGetNumeratorFirstTerm ; stack state 3
        push ecx ; stack state 5
        call SutulovGetNumeratorSecondTerm ; stack state 6

        fadd
        
        ; saving numerator to 10-bytes buffer
        fstp SutulovNumerator

        ; dividing numerator by denominator
        fld SutulovNumerator
        fld SutulovDenominator
        fdiv

        ; saving the final result to 8-bytes variable
        fstp SutulovFinalResult


    normalWindow:
        
        ; converting float numbers to strings for them to be shown correctly
        invoke FloatToStr, SutulovAArray[edi * SUTULOV_EIGHT_BYTES_OFFSET], offset SutulovCurrentAString
        invoke FloatToStr, SutulovBArray[edi * SUTULOV_EIGHT_BYTES_OFFSET], offset SutulovCurrentBString
        invoke FloatToStr, SutulovCArray[edi * SUTULOV_EIGHT_BYTES_OFFSET], offset SutulovCurrentCString
        invoke FloatToStr, SutulovDArray[edi * SUTULOV_EIGHT_BYTES_OFFSET], offset SutulovCurrentDString
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
        invoke FloatToStr, SutulovAArray[edi * SUTULOV_EIGHT_BYTES_OFFSET], offset SutulovCurrentAString
        invoke FloatToStr, SutulovBArray[edi * SUTULOV_EIGHT_BYTES_OFFSET], offset SutulovCurrentBString
        invoke FloatToStr, SutulovCArray[edi * SUTULOV_EIGHT_BYTES_OFFSET], offset SutulovCurrentCString
        invoke FloatToStr, SutulovDArray[edi * SUTULOV_EIGHT_BYTES_OFFSET], offset SutulovCurrentDString
        
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