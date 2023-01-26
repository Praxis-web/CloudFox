*
* Convierte Horas:Minutos:Segundos a Decimal
Procedure Hms2Dec( uHMS As Variant ) As Void;
		HELPSTRING "Convierte Horas:Minutos:Segundos a Decimal"
	Local lcCommand As String
	Local lnSeconds As Integer,;
		lnHours As Integer,;
		lnMinutes As Integer,;
		lnReturn As Integer

	Try

		lcCommand = ""

		If !Inlist( Vartype( uHMS ), "N", "C" )
			Error 107
		Endif

		If Vartype( uHMS ) = "N"
			uHMS = Transform( Padl( uHMS, 12, "0" ), "@R 99999999:99:99" )
		Endif

		If Getwordcount( uHMS, ":" ) = 1
			Error "El formato debe ser hhhh:mm:ss"

		Else
			lnHours 	= Val( Getwordnum( uHMS, 1, ":" ))
			lnMinutes 	= Val( Getwordnum( uHMS, 2, ":" ))
			lnSeconds 	= Val( Getwordnum( uHMS, 3, ":" ))

			If lnMinutes > 59 Or lnSeconds > 59
				Error "Minutos o Segundos: Valor no permitido"
			Endif

			lnReturn = lnSeconds + ( lnMinutes * 60 ) + ( lnHours * 60 * 60 )

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	EndTry
	
	Return lnReturn  

Endproc && Hms2Dec
