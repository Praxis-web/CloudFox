***************************************************************************************
Note: Devuelve un Nombre de archivo valido
* tcPATH: Ruta del archivo
* tcPREF: Prefijo del Archivo
* tnLEN : Longitud del Nombre
* tcEXT : Extension

Parameter tcEXT,tcPATH,tnLEN,tcPREF
Local lcFILE,lcChar,lnI

tcPATH	=	DefaultValue( "tcPATH", " "   )
tcPREF	=	DefaultValue( "tcPREF", "_"  )
tnLEN 	=	DefaultValue( "tnLEN" , 8     )
tcEXT 	=	Alltrim(DefaultValue( "tcEXT" , "" ))
If !Empty(tcEXT)
	tcEXT = "."+tcEXT
Endif


If !Empty(tcPATH)
	If Right(tcPATH,1) <> "\" .And. Right(tcPATH,1) <> ":"
		tcPATH	=	tcPATH + "\"
	Endif
Endif

tcPREF	=	Alltrim(Substr(tcPREF,1,2))
tcPATH	=	Alltrim(tcPATH)
tcEXT	=	Alltrim(tcEXT)

Do While .T.
	lcFILE	=	Substr(tcPREF + Sys(2015),1,tnLEN)

	If !File(tcPATH+lcFILE+tcEXT)
		Exit
	Endif
Enddo

Retu tcPATH+lcFILE+tcEXT
