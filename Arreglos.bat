rem set fecha=m-d-y
set fecha=12-01-2020


V:
cd "\CloudFox"

RD /S /Q V:\Arreglos
MD V:\Arreglos\Temp

xCopy v:\CloudFox "V:\Arreglos\Temp" /S /D:%fecha%

CD "\Arreglos"
del *.pj?  /s /f
del *.bak *.fxp *.app *.exe *.dll *.vbr *.tlb *.tbk *.err *_ref.* *.idx *.txt *.bat *.cfg *.Dbf *.Fpt /s /f

xCopy "V:\Arreglos\Temp" /S 

RD /S /Q V:\Arreglos\Temp

cd \
"c:\Program Files (x86)\WinRAR\WinRAR.exe" a -r "Arreglos desde el %fecha%" "Arreglos\*"

set fecha = 