Lparameters lcStr As String, llSwitchSignos As Boolean, lnDecimales As Integer

*!*	lnValorFinal = lnValorBase * Evaluate( ParseMargen( lcString, lnDecimales ))

Local lcReturn As String,;
	lcTemp As String,;
	lcValor As String

Local lcSigno As Character

Local lnValor As Number,;
	lnCoeficiente As Number

Try

	If Empty( lnDecimales )
		lnDecimales = 4
	Endif

	lcStr = Alltrim( lcStr )
	lcReturn = ""
	
	lcSigno = Substr( lcStr, 1, 1 )
	
	If IsDigit( lcSigno )
		lcSigno = "+"
		lcStr = lcSigno + lcStr
	EndIf
	
	If llSwitchSignos
		lcStr = Strtran(lcStr, '+', '#' )
		lcStr = Strtran(lcStr, '-', '+' )
		lcStr = Strtran(lcStr, '#', '-' )
	EndIf
	
	lcSigno = Substr( lcStr, 1, 1 )
	lcTemp = Alltrim( Substr( lcStr, 2 ))

	If !Empty( lcSigno )

		lcValor = Getwordnum( lcTemp, 1, "+-" )
		lnValor = Val( lcValor )

		Do Case
			Case lcSigno = "+"
				lnCoeficiente = 1 + ( lnValor / 100 )

			Case lcSigno = "-"
				lnCoeficiente = 1 - ( lnValor / 100 )

			Otherwise
				Error "Signo " + lcSigno + " No Reconocido"

		Endcase

		lcStr = Substr( lcTemp, Len( lcValor ) + 1 )
		lcReturn = Alltrim( Str( lnCoeficiente, 12, lnDecimales )) + "*" + ParseMargen( lcStr, llSwitchSignos, lnDecimales )  
		
	Else
		lcReturn = "1"
		
	Endif

	lcReturn = Strtran( lcReturn, ",", "." )  

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return lcReturn