#INCLUDE "FW\Comunes\Include\Praxis.h"

Lparameters nVersion as Integer 

Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

Local lcClassName as String 

External Procedure GlobalSettings.prg

* Singleton del objeto _Screen.oGlobalSettings
Local lcCommand as String
Local llNew as Boolean 

Try

	lcCommand = ""
	llNew = .F. 


	loGlobalSettings = Null
	
	If Vartype( nVersion ) # "N"
		nVersion = 0
	EndIf
	
	Do Case
	Case nVersion = 2
		lcClassName = "GlobalSettings2"
		
	Otherwise
		lcClassName = "GlobalSettings"
		
	EndCase

	If Pemstatus( _Screen, "oGlobalSettings", 5 )

		Do Case
			Case Vartype( _Screen.oGlobalSettings ) = "O"
				loGlobalSettings = _Screen.oGlobalSettings
				
			Otherwise
				loGlobalSettings = Newobject( lcClassName, 'FW\Comunes\PRG\GlobalSettings.prg' ) 
				llNew = .T.

		Endcase

	Else
		loGlobalSettings = Newobject( lcClassName, 'FW\Comunes\PRG\GlobalSettings.prg' )
		llNew = .T.

	EndIf
	
Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	DEBUG_EXCEPTION
	loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	m.loError.Process ( m.loErr )
	THROW_EXCEPTION

Finally
	
	
EndTry

Return loGlobalSettings
