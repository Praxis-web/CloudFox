*!*	Procedure Execute( tcCommand As String, tcFormName As String )
Lparameters tcCommand As String, tlDoPrg As Boolean, nFormType As Integer, lIsChildProcess As Boolean

Local lcCommand As String
Local loExecute As oExecute Of "v:\CloudFox\Rutinas\Execute.prg"
Local loForm As Form
Local i As Integer

Local lcMenu As String,;
	lcPad As String,;
	lcPopUp As String,;
	lcPromp As String,;
	lcScreenCaption As String

Local lnBar As Integer
Local loApp As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

Try

	lcCommand = ""

	If Empty( nFormType )
		nFormType = 0
	Endif

	For i = 1 To _Screen.FormCount
		loForm = _Screen.Forms( i )
		If Inlist( Upper( loForm.Name ), "FRMMENU" )
			Exit
		Endif
	Endfor

	If Vartype( loForm) = "O"
		If Inlist( Upper( loForm.Name ), "FRMMENU" )
			loForm.Hide()
		Endif
	Endif

	lcScreenCaption = _Screen.Caption

	lcMenu 	= Menu()
	lcPad 	= Pad()
	lcPopUp = Popup()
	lcPromp = Prompt()
	lnBar 	= Bar()

	If !lIsChildProcess
		Set Sysmenu Off
		Close Databases All
	EndIf
	
	Do Case
		Case tlDoPrg
			Do &tcCommand

		Case nFormType = 1
			*!*			Do Form "Rutinas\Scx\DisplayWF_Solapas" With tcCommand
			* RA 2013-12-19(15:40:57)
			* Todavía no implementado

		Otherwise
			Do Form "Rutinas\Scx\DisplayWindowForm" With tcCommand, lIsChildProcess 

	Endcase

	DoEvents

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )

Finally

	Try

		loApp = NewApp()
		If loApp.lExit
			*Messagebox( Program())
			If Vartype( loError ) = "O"
				Throw loError

			Else
				Error "El Sistema se Cerro por Inactividad Prolongada"

			Endif

		Else

			If !lIsChildProcess


				_Screen.Caption = lcScreenCaption

				Close Databases All
				Set Sysmenu Automatic

				If Vartype( loForm) = "O"
					If Inlist( Upper( loForm.Name ), "FRMMENU" )
						loForm.Show()
					Endif
				Endif

				loForm = Null
				DoEvents

				Try

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Activate PopUp <<lcPopUp>> Bar <<lnBar>>
					ENDTEXT

					&lcCommand


				Catch To oErr

				Finally

				Endtry
			Endif

		Endif


	Catch To oErr
		Throw oErr

	Finally
		loApp = Null

	Endtry

Endtry


Define Class oExecute As Session

	#If .F.
		Local This As oExecute Of "v:\CloudFox\Rutinas\Execute.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="launchform" type="method" display="LaunchForm" />] + ;
		[</VFPData>]


	*
	* Lanza un formulario en una sesion privada de datos
	Procedure LaunchForm( tcCommand As String ) As Void;
			HELPSTRING "Lanza un formulario en una sesion privada de datos"

		Try

			Set Sysmenu Off
			Close Databases All
			Do Form "Rutinas\Scx\DisplayWindowForm" With tcCommand

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Close Databases All
			Set Sysmenu Automatic

		Endtry
	Endproc && LaunchForm

Enddefine