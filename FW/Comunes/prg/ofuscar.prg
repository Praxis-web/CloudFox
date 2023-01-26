*!*	Local lcCommand As String

*!*	Try

*!*		lcCommand = ""

*!*		If .F. && Ofuscar
*!*			UserName = "praxis.computacion@gmail.com"
*!*			Clave = "Fenix_Praxis-1959"
*!*			Mascara = Sys(2015)

*!*			loClave1 = Ofuscar( Mascara, UserName, .T. )
*!*			Strtofile( Mascara, "Mascara.txt" )
*!*			
*!*			loClave2 = Ofuscar( Clave, loClave1.Texto, .T. )
*!*			Strtofile( loClave2.Texto, "Texto.txt" )
*!*			
*!*			
*!*		Else	&& Desofuscar
*!*			Clave = FileToStr( "Texto.txt" )
*!*			Mascara = FileToStr( "Mascara.txt" )
*!*			UserName = "praxis.computacion@gmail.com"


*!*			loClave1 = Ofuscar( Mascara, UserName, .T. )
*!*			
*!*			loClave2 = Ofuscar( Clave, loClave1.Texto, .F. )

*!*			Text To lcCommand NoShow TextMerge Pretext 03
*!*			Clave: <<loClave2.Texto>>
*!*			UserName: <<loClave1.Mascara>>
*!*			EndText

*!*			MessageBox( lcCommand  )
*!*			
*!*		Endif


*!*	Catch To oErr
*!*		Local loError As prxErrorHandler Of "FW\ErrorHandler\prxErrorHandler.prg"
*!*		loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
*!*		loError.Remark = lcCommand
*!*		loError.Process( oErr )


*!*	Finally
*!*		MessageBox( "Terminado" )

*!*	Endtry

*
* Ofusca / desofusca un string
Procedure Ofuscar( cTexto As String,;
	cMascara As String,;
	lOfusca as Boolean ) As Void;
		HELPSTRING "Ofusca / desofusca un string"
	Local lcCommand As String,;
		lcReturn As String

	Local loReturn As Object

	Local i As Integer,;
		m As Integer,;
		lnLenTexto As Integer,;
		lnLenMask As Integer

	Local llOfusca As Boolean

	Try

		lcCommand = ""
		loReturn = Createobject( "Empty" )

		If Empty( cMascara )
			cMascara = Sys( 2015 )
			llOfusca = .T.

		Else
			llOfusca = lOfusca 

		Endif

		lnLenTexto = Len( cTexto )
		lnLenMask = Len( cMascara )

		lcReturn = ""

		If llOfusca

			m = 0
			For i = 1 To lnLenTexto
				m = m + 1

				If m > lnLenMask
					m = 1
				Endif

				j = Asc( Substr( cTexto, i, 1 )) + Asc( Substr( cMascara, m, 1 ))

				If !Between( j, 32, 222 )
					j = Abs( j - 222 )
					
					If j < 32
						j = j + 222
					EndIf
				EndIf 

				lcReturn = lcReturn + Chr( j )
			Endfor

			AddProperty( loReturn, "Texto", lcReturn )
			AddProperty( loReturn, "Mascara", cMascara )

		Else
			m = 0
			For i = 1 To lnLenTexto
				m = m + 1

				If m > lnLenMask
					m = 1
				Endif

				j = Asc( Substr( cTexto, i, 1 )) - Asc( Substr( cMascara, m, 1 ))

*!*					If j < 0
*!*						j = 255 - Abs( j )
*!*					Endif

				If !Between( j, 32, 222 )
					j = Abs( 222 - Abs( j ))

					If j < 32
						j = j + 222
					EndIf

				EndIf 

				lcReturn = lcReturn + Chr( j )
				
			Endfor

			AddProperty( loReturn, "Texto", lcReturn )
			AddProperty( loReturn, "Mascara", cMascara )

		Endif

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return loReturn

Endproc && Ofuscar