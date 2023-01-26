#INCLUDE "FW\Comunes\Include\Praxis.h"

Define Pad _23e0sx5dx Of _Msysmenu Prompt "\<Sistema" Color Scheme 3 ;
	KEY Alt+S, "ALT+S"

On Pad _23e0sx5dx Of _Msysmenu Activate Popup sistema

Define Popup sistema Margin Relative Shadow Color Scheme 4

Define Bar 101 Of sistema Prompt "\<Registrarse" ;
	KEY Alt+R, "R" ;
	SKIP For _Screen.oApp.lLogin = .T. Or _Screen.oApp.lIsGuest = .T. ;
	PICTURE "FW\Comunes\Image\Ico\User.ico" ;
	MESSAGE "Ingresar al sistema con un nombre de usuario válido"

On Selection Bar 101 Of sistema _Screen.oApp.Login( .T. )

Define Bar 102 Of sistema Prompt "\<Cerrar Usuario" ;
	KEY Alt+C, "C" ;
	SKIP For _Screen.oApp.lLogin = .F. Or _Screen.oApp.lIsGuest = .T. ;
	PICTURE "FW\Comunes\Image\Ico\Llave.ico" ;
	MESSAGE "Cierra el Usuario activo"

On Selection Bar 102 Of sistema _Screen.oApp.Logout()

Define Bar 199 Of sistema Prompt "\-"

If _Screen.oApp.nModuloId = MDL_CONTABLE
	Define Bar 310 Of sistema Prompt "Cambio De E\<jercicio" ;
		KEY Alt+J, "J" ;
		SKIP For _Screen.oApp.lLogin = .F. ;
		PICTURE "FW\Comunes\Image\Ico\Refresh.ico" ;
		MESSAGE "Cambiar el Ejercicio Activo"

	On Selection Bar 310 Of sistema Do Execute With "Clientes\Contabilidad\Prg\CambioDeEjercicio"

Endif

Define Bar 320 Of sistema Prompt "Cambio De \<Empresa" ;
	KEY Alt+E, "E" ;
	SKIP For _Screen.oApp.lLogin = .F. ;
	PICTURE "FW\Comunes\Image\Ico\Refresh.ico" ;
	MESSAGE "Cambiar la Empresa Activa"

On Selection Bar 320 Of sistema Do Execute With "Rutinas\Prg\CambioDeEmpresa"

Define Bar 299 Of sistema Prompt "\-"

Define Bar 420 Of sistema Prompt "Parámetros de \<Impresoras " ;
	KEY Alt+I, "I" ;
	SKIP For _Screen.oApp.lLogin = .F. ;
	PICTURE "FW\Comunes\Image\Bmp\Print.bmp" ;
	MESSAGE "Definir Impresoras en la Red"

On Selection Bar 420 Of sistema Do Execute With "Fw\Comunes\prg\Impresora", .T.

Define Bar 499 Of sistema Prompt "\-"

If GetValue( "SendMail", "ar0Var", "N" ) = "S"

	If _Screen.oApp.oUser.IsAdmin && Or .T.

		Define Bar 510 Of sistema Prompt "Cuentas de C\<orreo Electrónico" ;
			KEY Alt+O, "O" ;
			SKIP For _Screen.oApp.lLogin = .F. ;
			PICTURE "Fw\Comunes\Image\ico\eMail2.ico" ;
			MESSAGE "Definir Cuentas de Correo Electrónico"

		On Selection Bar 510 Of sistema Do Execute With "Fw\Comunes\prg\MailAccount", .T.

		Define Bar 599 Of sistema Prompt "\-"
	Endif

EndIf


Define Bar 999 Of sistema Prompt "Salir del Sistema" ;
	KEY Alt+F4, "ALT+F4" ;
	PICTURE "FW\Comunes\Image\Bmp\Close.bmp"

On Selection Bar 999 Of sistema _Screen.oApp.Exit()

