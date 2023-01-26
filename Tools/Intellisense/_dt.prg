Local lcCode As String
TEXT To lcCode NoShow
	LPARAMETERS oFoxcode

	IF oFoxcode.Location #1
	   RETURN "_DT"
	ENDIF

	#DEFINE CRLF Chr(13)+Chr(10)
	#DEFINE TAB Chr(9)

	oFoxcode.valuetype = "V"

	Set Path To "v:\SistemasPraxisV2\Comunes\prg\" Additive
	Set Path To "v:\SistemasPraxisV2\Tools\IntelliSense\" Additive

	Local lcReturn as String 
	Local myVar as String 

	MyVar = ""

	Do form "Tools\Generador\Scx\defTabla.scx" to lcReturn

	If !Empty( lcReturn ) 
		MyVar = lcReturn  
	EndIf

	RETURN myvar
ENDTEXT
Use In Select( 'UdpFoxCode' )
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And ABBREV = '_DT'
insert into UdpFoxCode ( Type, ABBREV, cmd, Data )  Values ( 'U', '_DT', '{}', lcCode )
Use In Select( 'UdpFoxCode' )

