@echo off
ml /c /coff "7-20-IM-12-Sutulov-publicextern.asm"
ml /c /coff "7-20-IM-12-Sutulov.asm"
link /subsystem:windows "7-20-IM-12-Sutulov.obj" "7-20-IM-12-Sutulov-publicextern.obj"
7-20-IM-12-Sutulov.exe