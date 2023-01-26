*
* Valida que el dato corresponda a una hora válida
Procedure ValidarHora( cHora As String, lSilence As boolSilence ) As Boolean;
		HELPSTRING "Valida que el dato corresponda a una hora válida"
	Local lcCommand As String,;
		lcDigitos As String

	Local lnHora As Integer,;
		lnMinutos As Integer,;
		lnSegundos As Integer,;
		i As Integer

	Local llValid As Boolean

	Try

		lcCommand 	= ""
		cHora 		= Alltrim( cHora )
		llValid 	= Len( cHora ) = 8

		If llValid
			llValid = ( Substr( cHora, 3, 1 ) == ":" )
		Endif

		If llValid
			llValid = ( Substr( cHora, 6, 1 ) == ":" )
		Endif

		If llValid
			cHora = Strtran( cHora, " ", "0" )
			lcDigitos = Strtran( cHora, ":", "" )

			For i = 1 To 6

				llValid = Isdigit( Substr( lcDigitos, i, 1 ))

				If !llValid
					Exit
				Endif

			Endfor
		Endif

		If llValid
			lnHora 		= Val( Substr( cHora, 1, 2 ))
			lnMinutos 	= Val( Substr( cHora, 4, 2 ))
			lnSegundos	= Val( Substr( cHora, 7, 2 ))

			llValid = Between( lnHora, 0, 23 )
			llValid = llValid And Between( lnMinutos , 0, 59 )
			llValid = llValid And Between( lnSegundos, 0, 59 )

		Endif

		If !llValid And !lSilence
			TEXT To lcMsg NoShow TextMerge Pretext 03
			[<<cHora>>]

			Formato de Hora NO VALIDO
			[hh:mm:ss]
			ENDTEXT

			*Warning( lcMsg, "Validar Hora" )

			=I_Valida( .F., lcMsg )

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return llValid

Endproc && ValidarHora

*!*	Local lcCommand as String, lcMsg as String

*!*	Try

*!*		lcCommand = ""
*!*		Close Databases All
*!*
*!*		lcHora = "23:59:59"
*!*
*!*		If ValidarHora( lcHora )
*!*			MessageBox( lcHora )
*!*		EndIf
*!*

*!*	Catch To loErr

*!*		Do While Vartype( loErr.UserValue ) == "O"
*!*			loErr = loErr.UserValue
*!*		Enddo

*!*		lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  METODO   ] " + loErr.Procedure + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  LINEA Nº ] " + Transform(loErr.Lineno) + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  COMANDO  ] " + loErr.LineContents + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  ERROR    ] " + Transform(loErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  MENSAJE  ] " + loErr.Message + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  DETALLE  ] " + loErr.Details + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
*!*		lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )

*!*		StrToFile( lcMsg, "ErrorLog9.txt" )

*!*		Messagebox( lcMsg, 16, "Error", -1 )


*!*	Finally
*!*		Close Databases All


*!*	EndTry



