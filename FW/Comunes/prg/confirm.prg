*!* Program: Confirm
*!* Author: M.Salías
*!* Date: 05/28/03 11:01:22 AM
*!* Copyright:
*!* Description: Encapsulates a confirmation messagebox
*!* Revision Information:

#INCLUDE "Fw\comunes\Include\Praxis.h"

Lparameters tcText As String,;
tcCaption As String,;
tlDefaultYes as Boolean,;
tnIcon as Integer,;
tcWavFile As String,;
tnTimeOut as Integer 

Local lcCaption As String, lnDesfault as Integer, lnIcon as Integer, lnTimeOut as Integer 

If Empty( tcCaption )
	If Type( "_Screen.oApp.cAppName" ) = "C"
		lcCaption = _Screen.oApp.cAppName

	Else
		lcCaption = "Confirme"

	EndIf

Else
	lcCaption = tcCaption

EndIf

If tlDefaultYes
	lnDefault = MB_DEFBUTTON1
	
Else
	lnDefault = MB_DEFBUTTON2
	
Endif

If Empty( tnIcon ) 
	lnIcon = MB_ICONQUESTION
	
Else
	lnIcon = tnIcon 
	  	
EndIf

If Empty( tnTimeOut )
	tnTimeOut = -1
EndIf

lnTimeOut = Iif( tnTimeOut < 0, 0, tnTimeOut )

Wait Clear
Return ( Messagebox( tcText, lnIcon + MB_YESNO + lnDefault, lcCaption, lnTimeOut ) = IDYES )
