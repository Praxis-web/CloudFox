*
* Devuelve el valor del parametro solicitado
Procedure GetValue( tcField As String,;
		tcTable As String,;
		tuDefault As Variant,;
		tcFolder As String ) As Variant;
		HELPSTRING "Devuelve el valor del parametro solicitado"

	Local luReturn As Variant
	Local lcAlias As String,;
		lcCommand As String
	Local llDone As Boolean,;
		llCloseBeforeLeaving As Boolean

	Local lnIntentos As Integer

	Try

		llDone 		= .F.
		lcCommand 	= ""
		lnIntentos 	= 25
		llCloseBeforeLeaving = .F.

		lcAlias = Alias()

		If Empty( tcTable )
			tcTable = "ar0Setup"
		Endif

		If !Used( tcTable )

			Do While !llDone And ( lnIntentos > 0 )
			
				Try

					If Empty( tcFolder )
						If Vartype( DRVA ) # "C"
							DRVA = ""

						Endif
						tcFolder = DRVA

					Endif


					TEXT To lcCommand NoShow TextMerge Pretext 15
					Use "<<Trim( tcFolder )>><<tcTable>>" In 0 Shared
					ENDTEXT

					&lcCommand
					lcCommand = ""

					llCloseBeforeLeaving = .T.
					lnIntentos = -1 

				Catch To oErr
					Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
					
					Do Case
					Case Inlist( oErr.ErrorNo, 1, 1002 )
						luReturn = tuDefault
						llDone = .T.
					
					Case lnIntentos > 5
						lnIntentos = lnIntentos - 1 
						
					Otherwise
						llDone = .T.
						
						loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
						loError.cRemark = lcCommand
						loError.Process( oErr )
						Throw loError

					EndCase

				Finally

				Endtry
			Enddo

		Endif

		If !llDone
			lcCommand = ""

			Try

				luReturn = Evaluate( tcTable + "." + tcField )

			Catch To oErr
				If Vartype( tuDefault ) # "U"
					luReturn = tuDefault
					llDone = .T.

				Else
					Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

					loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					loError.Process( oErr )
					Throw loError

				Endif


			Finally

			Endtry
		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally
		If Used( lcAlias )
			Select Alias( lcAlias )
		Endif

		If llCloseBeforeLeaving
			Use In Select( tcTable )
		Endif

	Endtry

	Return luReturn

Endproc && GetValue