#INCLUDE "FW\Comunes\Include\Praxis.h"

Local lcCommand as String
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
loBackEndSettings As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg"
External Procedure BackEndSettings.prg

Try

	lcCommand = ""
	loGlobalSettings = NewGlobalSettings()
	loBackEndSettings = loGlobalSettings.oBackEndSettings
	
	If Vartype( loBackEndSettings ) # "O" 
		loBackEndSettings = NewObject( "oBackEndSettings", "FW\Comunes\prg\BackEndSettings.prg" ) 
		loGlobalSettings.oBackEndSettings = loBackEndSettings 
	EndIf 

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally
	loGlobalSettings = Null

EndTry

Return loBackEndSettings 