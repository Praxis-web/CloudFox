Lparameters oFoxcode

If oFoxcode.Location #1
	Return "_PREM"
Endif

#Define CRLF Chr(13)+Chr(10)
#Define Tab Chr(9)


oFoxcode.valuetype = "V"

Set Path To "v:\SistemasPraxisV2\Comunes\prg\" Additive
Set Path To "v:\SistemasPraxisV2\Tools\IntelliSense\" Additive

Local lcProcName 	As String		,;
	lcParamList 	As String		,;
	lcSendingList 	As String		,;
	lnParamCount 	As String 		,;
	lcReturnType 	As String 		,;
	lcCommandLine 	As String		,;
	lcDescription 	As String		,;
	lcTopic       	As String

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

*!*	lcTopic = lcTopic + "::" + lcProcName

lcDescription	= Inputbox( "Descripción", "PROCEDURE "+lcProcName )
lnParamCount 	= Val(Inputbox( "Cantidad de Parámetros", "PROCEDURE "+lcProcName ))
lcParamList = ""
lcSendingList = ""

For lnI = 1 To lnParamCount
	lcPrm = ""
	lcType = ""
	Do While Empty(lcPrm)
		lcPrm = Inputbox( "Parámetro N° "+Alltrim(Str(lnI)), "PROCEDURE "+lcProcName)
	Enddo
	lcPrm = Strtran( lcPrm, " ", "" )
	lcSendingList = lcSendingList + lcPrm + ",; " + CRLF + lcSpaces

	Do While Empty(lcType)
		lcType = Inputbox( "Especifique el Tipo de Dato de &lcPrm.", "PROCEDURE "+lcProcName)
	Enddo
	lcType = Proper( lcType )
	lcPrm = Alltrim( lcPrm ) + " AS " + Alltrim( lcType )

	lcParamList = lcParamList + lcPrm + ",; " + CRLF + lcSpaces

Endfor

lcParamList = Substr( lcParamList, 1, Len( lcParamList ) - 8 )
lcSendingList = Substr( lcSendingList, 1, Len( lcSendingList ) - 8 )

lcReturnType = Inputbox( "Especifique el Tipo de Dato de Retorno", "PROCEDURE "+lcProcName )
If Empty(lcReturnType)
	lcReturnType = "void"
Endif


* ClassBefore
TEXT To lcCommandLine NoShow TextMerge
Protected PROCEDURE ClassBefore<<lcProcName>>( <<lcParamList>> ) AS Boolean
ENDTEXT

TEXT TO myvar TEXTMERGE NOSHOW
[<memberdata name="<<Lower("ClassBefore" + lcProcName)>>" type="method" display="ClassBefore<<lcProcName>>" />] + ;
[<memberdata name="<<Lower("HookBefore" + lcProcName)>>" type="method" display="HookBefore<<lcProcName>>" />] + ;
[<memberdata name="<<Lower(lcProcName)>>" type="method" display="<<lcProcName>>" />] + ;
[<memberdata name="<<Lower("HookAfter" + lcProcName)>>" type="method" display="HookAfter<<lcProcName>>" />] + ;
[<memberdata name="<<Lower("ClassAfter" + lcProcName)>>" type="method" display="ClassAfter<<lcProcName>>" />] + ;

*
* ClassBefore Event
* <<lcDescription>>
<<lcCommandLine>>

ENDTEXT

myvar = myvar  + CRLF + CRLF + Doc( lcTopic, "ClassBefore Event", lcParamList, "Boolean" ) + CRLF + CRLF

TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE
	Local llExecute<<lcProcName>> as Boolean

	Try

		llExecute<<lcProcName>> = .T.

	Catch To oErr
		If This.lIsOk
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )
		Endif

	Finally
		If !This.lIsOk
			Throw This.oError
		Endif

	EndTry

	Return llExecute<<lcProcName>>

EndProc && ClassBefore<<lcProcName>>

ENDTEXT


* HookBefore

TEXT To lcCommandLine NoShow TextMerge
PROCEDURE HookBefore<<lcProcName>>( <<lcParamList>> ) AS Boolean
ENDTEXT

TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE
*
* HookBefore Event
* Para ser utilizado por el desarrollador
* <<lcDescription>>
<<lcCommandLine>>

ENDTEXT

myvar = myvar  + CRLF + CRLF + Doc( lcTopic, "HookBefore Event", lcParamList, "Boolean" ) + CRLF + CRLF

TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE
	Local llExecute<<lcProcName>> as Boolean

	Try

		llExecute<<lcProcName>> = .T.

	Catch To oErr
		If This.lIsOk
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )
		Endif

	Finally
		If !This.lIsOk
			Throw This.oError
		Endif

	EndTry

	Return llExecute<<lcProcName>>

EndProc && HookBefore<<lcProcName>>

ENDTEXT

* Metodo

lcReturnType = Proper( lcReturnType )

TEXT To lcCommandLine NoShow TextMerge
Protected PROCEDURE <<lcProcName>>( <<lcParamList>> ) AS <<lcReturnType>>
ENDTEXT


If !Empty( lcDescription )
	lcCommandLine = lcCommandLine + ";" + CRLF + [        HELPSTRING "&lcDescription."]
Endif

TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE
*
* <<lcDescription>>
<<lcCommandLine>>

ENDTEXT

myvar = myvar  + CRLF + CRLF + Doc( lcTopic, lcDescription, lcParamList, lcReturnType ) + CRLF + CRLF

TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE

	Try

		If This.lIsOk And This.ClassBefore<<lcProcName>>( <<lcSendingList>> ) 

			If This.lIsOk And This.HookBefore<<lcProcName>>( <<lcSendingList>> ) 

		~

				If This.lIsOk
					This.HookAfter<<lcProcName>>( <<lcSendingList>> )
				EndIf

			EndIf

			If This.lIsOk
				This.ClassAfter<<lcProcName>>( <<lcSendingList>> )
			EndIf

		EndIf

	Catch To oErr
		If This.lIsOk
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )
		Endif

	Finally
		If !This.lIsOk
			Throw This.oError
		Endif

	Endtry

EndProc && <<lcProcName>>

ENDTEXT

* HookAfter
TEXT To lcCommandLine NoShow TextMerge
PROCEDURE HookAfter<<lcProcName>>( <<lcParamList>> ) AS Void
ENDTEXT

TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE
*
* HookAfter Event
* Para ser utilizado por el desarrollador
* <<lcDescription>>
<<lcCommandLine>>

ENDTEXT

myvar = myvar  + CRLF + CRLF + Doc( lcTopic, "HookAfter Event", lcParamList, "Void" ) + CRLF + CRLF

TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE

	Try


	Catch To oErr
		If This.lIsOk
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )
		Endif

	Finally
		If !This.lIsOk
			Throw This.oError
		Endif

	EndTry

EndProc && HookAfter<<lcProcName>>

ENDTEXT

* ClassAfter
TEXT To lcCommandLine NoShow TextMerge
Protected PROCEDURE ClassAfter<<lcProcName>>( <<lcParamList>> ) AS Void
ENDTEXT

TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE
*
* ClassAfter Event
* <<lcDescription>>
<<lcCommandLine>>

ENDTEXT

myvar = myvar  + CRLF + CRLF + Doc( lcTopic, "ClassAfter Event", lcParamList, "Void" ) + CRLF + CRLF

TEXT TO myvar TEXTMERGE NOSHOW ADDITIVE

	Try


	Catch To oErr
		If This.lIsOk
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )
		Endif

	Finally
		If !This.lIsOk
			Throw This.oError
		Endif

	EndTry

EndProc && ClassAfter<<lcProcName>>

ENDTEXT

Return myvar
