*
* Devuelve un string compuesto solo por digitos
Procedure DigitsOnly( cExpression As String,;
		nWidth As Integer,;
		cAllowed As String,;
		nDecimals As Integer ) As String;
		HELPSTRING "Devuelve un string compuesto solo por digitos"

	Local lcCommand As String,;
		lcReturn As String,;
		lcAllowed As String

	Local lcChar As Character

	Local i As Integer,;
		lnLen As Integer

	External Procedure IsEmpty.prg,;
		StrZero.prg

	Try

		lcCommand = ""
		lcReturn = ""

		If IsEmpty( nWidth )
			nWidth = 0
		Endif

		If IsEmpty( cAllowed )
			cAllowed = ""
		Endif

		If IsEmpty( cExpression )
			cExpression = ""
		Endif

		If IsEmpty( nDecimals )
			nDecimals = 0
		Endif

		If Vartype( cExpression ) # "C"
			If Vartype( cExpression ) = "N"
				cExpression = StrZero( cExpression, nWidth, nDecimals )

			Else
				cExpression = Transform( cExpression )
				
			EndIf
			
		Endif

		cExpression = Alltrim( cExpression )

		lcAllowed = "0123456789" + Upper( cAllowed )

		lnLen = Len( cExpression )

		For i = 1 To lnLen
			lcChar = Substr( cExpression, i, 1 )

			If !Empty( At( Upper( lcChar ), lcAllowed ))
				lcReturn = lcReturn + lcChar
			Endif
		Endfor

		If !Empty( nWidth )
			lcReturn = Padl( lcReturn, nWidth, "0" )
		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcReturn

Endproc && DigitsOnly
