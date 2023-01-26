Lparameters tcInterval As String, tnNumber As Integer, tdDateValue As Datetime
Local ldRet As Datetime


* DAE 2009-07-31(22:14:05)
Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Try
	tcInterval = Lower( Left( Alltrim( tcInterval ), 1 ) )

	If Inlist( tcInterval, 'd', 'm', 'y' )

		If Vartype( tnNumber ) = 'N'

			If Inlist( Vartype( tdDateValue ), 'D', 'T' )

				Do Case
					Case tcInterval = 'd'
						ldRet = tdDateValue + tnNumber

					Case tcInterval = 'm'
						ldRet = Gomonth( tdDateValue, tnNumber )

					Case tcInterval = 'y'
						ldRet = Gomonth( tdDateValue, 12 * tnNumber )

				EndCase
				
			Else
				Error 'tdDateValue no es convertible en Date o Datetime.'

			EndIf && Inlist( Vartype( tdDateValue ), 'D', 'T' )
			
		Else
			Error 'El intervalo no es válido'

		EndIf && Vartype( tnNumber ) = 'N'
		
	Else
		Error 'El intervalo no es válido'

	EndIf && Inlist( tcInterval, 'd', 'm', 'y' )

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.cTracelogin = 'tcInterval: ' + Transform( tcInterval ) + Chr( 13 ) ;
		+ 'tnNumber: ' + Transform( tnNumber )  + Chr( 13 ) ;
		+ 'tdDateValue: ' + Transform( tdDateValue )
	loError.Process( oErr )
	Throw loError

Finally
	loError = Null

EndTry

Return  ldRet