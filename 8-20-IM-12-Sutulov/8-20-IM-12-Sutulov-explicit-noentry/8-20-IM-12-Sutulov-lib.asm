.386
.model flat, stdcall
option casemap :none

.data
    SutulovConstZero dq 0.0
    SutulovConstOne dq 1.0
    SutulovConstTwo dq 2.0

.data?
    SutulovDenominator dt ?
    SutulovNumerator dt ?
    SutulovArctanResult dt ?
    SutulovArctanArgument dt ?

.code
    
SutulovPerformCalculation proc SutulovCurrentA:ptr qword, SutulovCurrentB:ptr qword, SutulovCurrentC:ptr qword, SutulovCurrentD:ptr qword, SutulovFinalResultPointer:ptr qword
    
    xor eax, eax ; setting eax to zero
    
    finit
    
    ; calculating denominator: b - a - 1
    mov ebx, SutulovCurrentB
    fld qword ptr[ebx]
    mov ebx, SutulovCurrentA
    fld qword ptr[ebx]
    fsub
    fld SutulovConstOne
    fsub

    ; checking denominator for zero: 
    fcom SutulovConstZero
    fstsw ax
    sahf
    je wrongDenominatorValue
    
    ; saving denominator to 10-bytes buffer
    fstp SutulovDenominator

    ; calculating arctan argument: 2 * c
    fld SutulovConstTwo
    mov ebx, SutulovCurrentC
    fld qword ptr[ebx]
    fmul

    ; saving arctan argument to 10-bytes buffer
    fstp SutulovArctanArgument

    ; calculating arctg(2 * c)
    fld SutulovArctanArgument
    fld SutulovConstOne
    fpatan
    ; saving arctan calculation result to 10-bytes buffer
    fstp SutulovArctanResult

    ; calculating numerator: (arctg(2 * c) / d + 2)
    fld SutulovArctanResult
    mov ebx, SutulovCurrentD
    fld qword ptr[ebx]
    fdiv ; d can't be 0 according to the task, so no zero checks needed here
    fld SutulovConstTwo
    fadd
    
    ; saving numerator to 10-bytes buffer
    fstp SutulovNumerator

    ; dividing numerator by denominator
    fld SutulovNumerator
    fld SutulovDenominator
    fdiv

    jmp exitFromProcedure

    wrongDenominatorValue:
        mov eax, 1
        jmp exitFromProcedure
    
    exitFromProcedure:
        ; saving the final result to 8-bytes variable
        mov ebx, SutulovFinalResultPointer
        fstp qword ptr [ebx]
        ret
SutulovPerformCalculation endp

end