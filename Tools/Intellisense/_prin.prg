Lparameters oFoxcode

If oFoxcode.Location #1
	Return "_PRIN"
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
lcParamList 	= ""
lcReturnType 	= "Void"

TEXT To lcCommandLine NoShow TextMerge
PROCEDURE <<lcProcName>>( <<lcParamList>> ) AS <<lcReturnType>>
ENDTEXT


If !Empty( lcDescription )
	lcCommandLine = lcCommandLine + ";" + CRLF + [        HELPSTRING "&lcDescription."]
Endif

TEXT TO myvar TEXTMERGE NOSHOW
*
*
* <<lcDescription>>
<<lcCommandLine>>

ENDTEXT

TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE

	Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"
	Local loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg"

	Try

		loColMetodos = This.oColMetodos
		loMetodo = loColMetodos.GetItem( "<<lcProcName>>" )

		=Evaluate( loMetodo.cLine24 )

		This.AskDato( ;
			loMetodo.cField,;
			loMetodo.nGRow,;
			loMetodo.nGCol,;
			loMetodo.cPicture,;
			"<<lcProcName>>_Validar",;
			loMetodo.nLenDato )

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError

	Finally
		loColMetodos = Null
		loMetodo = Null

	EndTry

EndProc && <<lcProcName>>



ENDTEXT


TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE

*
* Validación
Procedure <<lcProcName>>_Validar( uDato As Variant ) As Boolean

	Local llValid As Boolean

	Try

		llValid   = .T.


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError

	Finally

	EndTry

	Return llValid

EndProc && <<lcProcName>>_Validar

ENDTEXT



Return myvar
