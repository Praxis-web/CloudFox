*!*	* Devuelve un string que permite configurar la propiedad InputMask
*!*	PROCEDURE ConvertInputMask(  ) AS String;
*!*	        HELPSTRING "Devuelve un string que permite configurar la propiedad InputMask"

Lparameters tnFieldWidth As Integer,;
	tnFieldPrecision As Integer,;
	tcMaskChar As Character,;
	tlShowSeparator As Boolean

Local i As Integer,;
lnLen as Integer 
Local lcReturnMask As String

Try

	lcReturnMask = ""

	If Vartype( tnFieldWidth ) # "N"
		tnFieldWidth = 12
	Endif

	If Vartype( tnFieldPrecision ) # "N"
		tnFieldPrecision = 2
	Endif

	If Empty( tcMaskChar ) Or Vartype( tcMaskChar ) # "C"
		tcMaskChar = "#"
	Endif

	tcMaskChar = Substr( tcMaskChar, 1, 1 )

	If Vartype( tlShowSeparator ) # "L"
		tlShowSeparator = .F.
	EndIf
	
	lnLen = tnFieldWidth 
	
	For i = 1 To lnLen 
		If i = ( tnFieldPrecision + 1 ) And tnFieldPrecision # 0
			lcReturnMask = "." + lcReturnMask

		Else
			lcReturnMask = tcMaskChar + lcReturnMask

		Endif

		If i > ( tnFieldPrecision + 1 ) And i < tnFieldWidth
			If tlShowSeparator
				If Empty( tnFieldPrecision )
					If Empty( Mod( i , 3 ))
						lcReturnMask = "," + lcReturnMask
					Endif

				Else
					If Empty( Mod( i - ( tnFieldPrecision + 1 ), 3 ))
						lcReturnMask = "," + lcReturnMask
					Endif

				Endif

			Endif
		Endif
	Endfor

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return lcReturnMask