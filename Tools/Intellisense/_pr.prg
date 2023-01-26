Lparameters oFoxcode

If oFoxcode.Location #1
	Return "_PR"
Endif

#Define CRLF Chr(13)+Chr(10)
#Define Tab Chr(9)

oFoxcode.valuetype = "V"

Set Path To "v:\SistemasPraxisV2\Comunes\prg\" Additive
Set Path To "v:\SistemasPraxisV2\Tools\IntelliSense\" Additive

Local lcProcName 	As String		,;
	lcParamList 	As String		,;
	lnParamCount 	As String 		,;
	lcReturnType 	As String 		,;
	lcCommandLine As String		,;
	lcDescription As String		,;
	lcTopic       As String

Local lnI As Integer, lcPrm As String, lcType As String
Local lcSpaces  As String

lcSpaces = Tab + Tab + Tab


lcTopic    = ""

lcProcName = Inputbox( "Nombre del Procedimiento", "PROCEDURE" )
lcProcName = Proper( lcProcName )

If Len( Getwordnum( lcProcName, 1 )) = 1
	lcProcName = Substr( Lower( lcProcName ), 1, 1 ) + Substr( lcProcName, 2 )
Endif

lcProcName = Strtran( lcProcName, " ", "" )

lcProcName = Inputbox( "Display", "PROCEDURE", lcProcName )

lcDescription	= Inputbox( "Descripción", "PROCEDURE "+lcProcName )
lnParamCount 	= Val(Inputbox( "Cantidad de Parámetros", "PROCEDURE "+lcProcName ))
lcParamList = ""

For lnI = 1 To lnParamCount
	lcPrm = ""
	lcType = ""
	Do While Empty(lcPrm)
		lcPrm = Inputbox( "Parámetro N° " + Alltrim(Str(lnI)), "PROCEDURE " + lcProcName )
	Enddo
	lcPrm = Strtran( lcPrm, " ", "" )
	Do While Empty(lcType)
		lcType = Inputbox( "Especifique el Tipo de Dato de &lcPrm.", "PROCEDURE "+lcProcName)
	Enddo
	lcType = Proper( lcType )
	lcPrm = Alltrim( lcPrm ) + " AS " + Alltrim( lcType )

	lcParamList = lcParamList + lcPrm + ",; " + CRLF + lcSpaces
Endfor

lcParamList = Substr( lcParamList, 1, Len( lcParamList ) - 8 )

lcReturnType = Inputbox( "Especifique el Tipo de Dato de Retorno", "PROCEDURE "+lcProcName )
If Empty(lcReturnType)
	lcReturnType = "void"
Endif

lcReturnType = Proper( lcReturnType )

TEXT To lcCommandLine NoShow TextMerge
PROCEDURE <<lcProcName>>( <<lcParamList>> ) AS <<lcReturnType>>
ENDTEXT


If !Empty( lcDescription )
	lcCommandLine = lcCommandLine + ";" + CRLF + [        HELPSTRING "&lcDescription."]
Endif

TEXT TO myvar TEXTMERGE NOSHOW
[<memberdata name="<<Lower(lcProcName)>>" type="method" display="<<lcProcName>>" />] + ;~

*
* <<lcDescription>>
<<lcCommandLine>>

ENDTEXT

*!*	myvar = myvar  + CRLF + CRLF + Doc( lcTopic, lcDescription, lcParamList, lcReturnType ) + CRLF + CRLF

TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE

	Local lcCommand as String
	
	Try
	
		lcCommand = ""
		
		
	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	EndTry

EndProc && <<lcProcName>>

ENDTEXT

Return myvar