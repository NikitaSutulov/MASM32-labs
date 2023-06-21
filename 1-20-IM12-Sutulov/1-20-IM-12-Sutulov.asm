.386
.model flat,stdcall
option casemap:none
include \masm32\include\masm32rt.inc

.data

    ; Date of birth character string
    SutulovDateOfBirthCharacterString db "12062004", 0

    ; Byte format
    SutulovAPositiveByte db 12
    SutulovANegativeByte db -12

    ; Word format
    SutulovAPositiveWord dw 12
    SutulovANegativeWord dw -12

    SutulovBPositiveWord dw 1206
    SutulovBNegativeWord dw -1206

    ; ShortInt format
    SutulovAPositiveShortInt dd 12
    SutulovANegativeShortInt dd -12

    SutulovBPositiveShortInt dd 1206
    SutulovBNegativeShortInt dd -1206

    SutulovCPositiveShortInt dd 12062004
    SutulovCNegativeShortInt dd -12062004

    ; LongInt format
    SutulovAPositiveLongInt dq 12
    SutulovANegativeLongInt dq -12

    SutulovBPositiveLongInt dq 1206
    SutulovBNegativeLongInt dq -1206

    SutulovCPositiveLongInt dq 12062004
    SutulovCNegativeLongInt dq -12062004

    ; Single (float) format
    SutulovDPositiveSingle dd 0.010
    SutulovDNegativeSingle dd -0.010

    ; Double (double) format
    SutulovDPositiveDouble dq 0.010
    SutulovDNegativeDouble dq -0.010
    SutulovEPositiveDouble dq 0.981
    SutulovENegativeDouble dq -0.981
    SutulovFPositiveDouble dq 9814.487
    SutulovFNegativeDouble dq -9814.487

    ; Extended (long double) format
    SutulovFPositiveExtended dt 9814.487
    SutulovFNegativeExtended dt -9814.487

    ; Window Caption
    SutulovWindowCaption db "Assembly lab1 Nikita Sutulov IM-12 Group, variant 20", 0

    ; Forms
    SutulovDateOfBirthForm db "Date of birth: %s", 0

    SutulovAForm db "A = %d", 9, 9, "-A = %d", 0
    SutulovBForm db "B = %d", 9, 9, "-B = %d", 0
    SutulovCForm db "C = %d", 9, "-C = %d", 0

    SutulovDForm db "D = %s", 9, 9, "-D = %s", 0
    SutulovEForm db "E = %s", 9, 9, "-E = %s", 0
    SutulovFForm db "F = %s", 9, "-F = %s", 0

    SutulovFinalForm db "%s", 10, 10, 
        "A numbers (day of birth):", 10, "%s", 10, 10,
        "B numbers (day and month of birth):", 10, "%s", 10, 10,
        "C numbers (full date of birth):", 10, "%s", 10, 10,
        "D numbers (A divided by the gradebook number):", 10, "%s", 10, 10,
        "E numbers (B divided by the gradebook number):", 10, "%s", 10, 10,
        "F numbers (C divided by the gradebook number):", 10, "%s", 10, 0

.data?
    SutulovDateOfBirthBuffer db 128 dup (?)
    SutulovABuffer db 64 dup (?)
    SutulovBBuffer db 64 dup (?)
    SutulovCBuffer db 64 dup (?)
    SutulovDBuffer db 64 dup (?)
    SutulovEBuffer db 64 dup (?)
    SutulovFBuffer db 64 dup (?)

    SutulovDPositiveStringBuffer db 32 dup (?)
    SutulovDNegativeStringBuffer db 32 dup (?)
    SutulovEPositiveStringBuffer db 32 dup (?)
    SutulovENegativeStringBuffer db 128 dup (?)
    SutulovFPositiveStringBuffer db 128 dup (?)
    SutulovFNegativeStringBuffer db 128 dup (?)

    SutulovFinalBuffer db 1024 dup (?)
.code
start:

    invoke FloatToStr2, SutulovDPositiveDouble, offset SutulovDPositiveStringBuffer
    invoke FloatToStr2, SutulovDNegativeDouble, offset SutulovDNegativeStringBuffer
    invoke FloatToStr2, SutulovEPositiveDouble, offset SutulovEPositiveStringBuffer
    invoke FloatToStr2, SutulovENegativeDouble, offset SutulovENegativeStringBuffer
    invoke FloatToStr2, SutulovFPositiveDouble, offset SutulovFPositiveStringBuffer
    invoke FloatToStr2, SutulovFNegativeDouble, offset SutulovFNegativeStringBuffer

    invoke wsprintf, offset SutulovDateOfBirthBuffer, offset SutulovDateOfBirthForm, offset SutulovDateOfBirthCharacterString
    invoke wsprintf, offset SutulovABuffer, offset SutulovAForm, SutulovAPositiveShortInt, SutulovANegativeShortInt
    invoke wsprintf, offset SutulovBBuffer, offset SutulovBForm, SutulovBPositiveShortInt, SutulovBNegativeShortInt
    invoke wsprintf, offset SutulovCBuffer, offset SutulovCForm, SutulovCPositiveShortInt, SutulovCNegativeShortInt
    invoke wsprintf, offset SutulovDBuffer, offset SutulovDForm, offset SutulovDPositiveStringBuffer, offset SutulovDNegativeStringBuffer
    invoke wsprintf, offset SutulovEBuffer, offset SutulovEForm, offset SutulovEPositiveStringBuffer, offset SutulovENegativeStringBuffer
    invoke wsprintf, offset SutulovFBuffer, offset SutulovFForm, offset SutulovFPositiveStringBuffer, offset SutulovFNegativeStringBuffer

    invoke wsprintf, offset SutulovFinalBuffer, offset SutulovFinalForm, 
        offset SutulovDateOfBirthBuffer,
        offset SutulovABuffer,
        offset SutulovBBuffer,
        offset SutulovCBuffer,
        offset SutulovDBuffer,
        offset SutulovEBuffer,
        offset SutulovFBuffer
    
    invoke MessageBox, 0, offset SutulovFinalBuffer, offset SutulovWindowCaption, 0

    invoke ExitProcess, 0

end start