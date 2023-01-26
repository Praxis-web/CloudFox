*!* ///////////////////////////////////////////////////////
*!* Program.......: Inform
*!* Description...: Encapsula un mensaje
*!* Date..........: Jueves 20 de Abril de 2006 (13:42:01)
*!* Author........: Ricardo Aidelman
*!* Project.......: Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -  
*!*
*!*	

#INCLUDE "Fw\comunes\Include\Praxis.h" 

Lparameters tcText As String, tcCaption As String, tnSeconds as Integer 
Local lcCaption As String
If Empty( tcCaption )
  If Type( "_Screen.oApp.cAppName" ) = "C"
    lcCaption = _Screen.oApp.cAppName
    
  Else
    lcCaption = "Advertencia"
    
  EndIf
  
Else
  lcCaption = tcCaption
  
EndIf

If Empty( tnSeconds )
	tnSeconds = 0
EndIf

Do Case
Case tnSeconds < 0 
	tnSeconds = 0
	
Case tnSeconds = 0 
	tnSeconds = 10

Otherwise

EndCase

Messagebox( tcText, MB_ICONINFORMATION, lcCaption, tnSeconds * 1000 )

Return