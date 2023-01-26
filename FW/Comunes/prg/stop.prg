*!* Program: Stop
*!* Author: R.Rovira
*!* Date: 06/22/03  6:06:22 PM
*!* Copyright:
*!* Description: Encapsulates a stop messagebox
*!* Revision Information:

#INCLUDE "Fw\comunes\Include\Praxis.h"

*
*
Procedure Stop( tcText As String,;
		tcCaption As String,;
		tnSeconds As Integer,;
		tlLaunchException As Boolean ) As Void

	Local lcCommand As String
	Local lcCaption As String, lnDelay As Integer

	Try

		lcCommand = ""


		If Empty( tcCaption )
			If Type( "_Screen.oApp.cAppName" ) = "C"
				lcCaption = _Screen.oApp.cAppName

			Else
				lcCaption = "Error grave"

			Endif

		Else
			lcCaption = tcCaption

		Endif

		If Empty( tnSeconds )
			tnSeconds = 0
		Endif

		Do Case
			Case tnSeconds < 0
				tnSeconds = 300

			Case tnSeconds = 0
				tnSeconds = 10

			Otherwise

		Endcase


		If Type( "_Screen.oApp.lDebugMode" ) = "L" And _Screen.oApp.lDebugMode
			lnDelay = 0

		Else
			lnDelay = tnSeconds * 1000

		Endif

		If Vartype( DRVA ) # "C"
			DRVA = ""
		EndIf

		If FileExist( Addbs( Drva ) + "Wav\Stop.Wav" )
			Set Bell To Addbs( Drva ) + "Wav\Stop.Wav" 
			?? Chr( 7 )
		Endif

		Messagebox( tcText, MB_ICONSTOP, lcCaption, lnDelay )

		If tlLaunchException
			Error tcText
		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr, .F. )
		Throw loError

	Finally
		Set Bell To

	Endtry

	Return

Endproc && Stop