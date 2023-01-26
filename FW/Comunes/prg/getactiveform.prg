Local lcCommand As String
Local loFormAux As Form,;
	loForm As Form

Local i As Integer
Local loApp As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

Try

	lcCommand = ""

	If _Screen.FormCount > 0
		Try

			Try

				loFormAux 	= _Screen.ActiveForm	

			Catch To oErr
				loFormAux 	= loFormAux = _Screen.Forms( 1 )
				
			Finally

			EndTry
			
			loForm 		= _Screen

			If !Inlist( Upper( loFormAux.Name ), "DISPLAYWINDOW","DISPLAYFORM", "FRMSAVESCREEN" )
				For i = 1 To _Screen.FormCount
					loFormAux = _Screen.Forms( i )
					If Inlist( Upper( loFormAux.Name ), "DISPLAYWINDOW","DISPLAYFORM", "FRMSAVESCREEN" )
						loForm = loFormAux
						Exit
					Endif
				Endfor

			Else
				loForm = loFormAux

			Endif

*!*				Try

*!*					* RA 27/11/2016(14:06:59)
*!*					* Resetaea el Auto Shut Off
*!*					*loForm.Reset()
*!*					loApp = NewApp()
*!*					loApp.oShutOffTimer.Reset()

*!*				Catch To oErr

*!*				Finally
*!*					loApp = Null

*!*				Endtry



		Catch To oErr
			loForm = _Screen

		Finally

		Endtry


	Else
		loForm = _Screen

	Endif


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally
	loFormAux = Null


Endtry

Return loForm
