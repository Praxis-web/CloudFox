Lparameters tnAction as Integer 

#INCLUDE "FW\Comunes\Include\Praxis.h"

*/ Cerrar todos los programas e iniciar la sesión como
*/ un usuario distinto
*/ #Define EWX_LOGOFF 		0

*/ Apagar el equipo
*/ #Define EWX_SHUTDOWN 	1

*/ Reiniciar el equipo
*/ #Define EWX_REBOOT 		2

*/ Forzar el apagado. Los ficheros abiertos se pueden perder. Las
*/ aplicaciones no preguntarán si se quieren guardar las modificaciones
*/ #Define EWX_FORCE 		4

Local lnResult as Integer 

Try

	Declare Integer ExitWindowsEx in "user32.dll" Integer uFlags, Integer dwReserved 
	
	If Empty( tnAction ) 
		tnAction = EWX_LOGOFF
	EndIf
	
	lnResult = ExitWindowsEx( tnAction, 0 )

Catch To oErr
	Local loError as Errorhandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = NewObject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

EndTry

Return lnResult  