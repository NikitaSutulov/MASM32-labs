.386
.model flat, stdcall
option casemap :none

public SutulovGetDenominator
extern SutulovCurrentB:qword, SutulovCurrentA:qword, SutulovConstOne:qword

.code
    SutulovGetDenominator proc
        ; calculating denominator: b - a - 1
        fld SutulovCurrentB
        fld SutulovCurrentA
        fsub
        fld SutulovConstOne
        fsub
        ret ; stack state 2
    SutulovGetDenominator endp
end