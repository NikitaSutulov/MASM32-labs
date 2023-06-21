@echo off
ml /c /coff 8-20-IM-12-Sutulov-lib.asm
link /out:8-20-IM-12-Sutulov-lib.dll /def:8-20-IM-12-Sutulov-lib.def /dll 8-20-IM-12-Sutulov-lib.obj /noentry
ml /c /coff 8-20-IM-12-Sutulov.asm
link /subsystem:windows 8-20-IM-12-Sutulov.obj
pause