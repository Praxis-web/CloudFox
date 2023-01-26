*!* Program: Warning
*!* Author: M.Salías
*!* Date: 05/28/03 10:49:22 AM
*!* Copyright:
*!* Description: Encapsulates a warning messagebox
*!* Revision Information:

#INCLUDE "Fw\comunes\Include\Praxis.h"

Lparameters tcText As String, ;
	tcCaption As String, ;
	tnSeconds As Integer, ;
	nButtons as Integer 
	
Local lcCaption As String

Local lcCommand As String
Local llOk as Integer

Try

	lcCommand = ""
	
	If Vartype( nButtons ) # "N"
		nButtons = 0
	EndIf

	If Empty( tcCaption )
		If Type( "_Screen.oApp.cAppName" ) = "C"
			lcCaption = _Screen.oApp.cAppName

		Else
			lcCaption = "Advertencia"

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

	If Vartype( DRVA ) = "C"
		If FileExist( Addbs( Drva ) + "Wav\Warning.Wav" )
			Set Bell To Addbs( Drva ) + "Wav\Warning.Wav"
			?? Chr( 7 )
		EndIf
	EndIf

	llOk = ( Messagebox( tcText, MB_ICONEXCLAMATION + nButtons, lcCaption, tnSeconds * 1000 ) = IDYES )
	
Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally


EndTry

Return llOk  
