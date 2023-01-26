
Define Pad _23e0sx5dx Of _Msysmenu Prompt "\<Sistema" Color Scheme 3 ;
	KEY Alt+S, "ALT+S"

On Pad _23e0sx5dx Of _Msysmenu Activate Popup sistema

Define Popup sistema Margin Relative Shadow Color Scheme 4

Define Bar 101 Of sistema Prompt "\<Registrarse" ;
	KEY Alt+R, "[R]" ;
	SKIP For _Screen.oApp.lLogin = .T. Or _Screen.oApp.lIsGuest = .T. ;
	PICTURE "FW\Comunes\Image\Ico\User.ico" ;
	MESSAGE "Ingresar al sistema con un nombre de usuario válido"

On Selection Bar 101 Of sistema _Screen.oApp.Login( .T. )

Define Bar 102 Of sistema Prompt "\<Cerrar Usuario" ;
	KEY Alt+C, "[C]" ;
	SKIP For _Screen.oApp.lLogin = .F. Or _Screen.oApp.lIsGuest = .T. ;
	PICTURE "FW\Comunes\Image\Ico\Llave.ico" ;
	MESSAGE "Cierra el Usuario activo"

On Selection Bar 102 Of sistema _Screen.oApp.Logout()

Define Bar 110 Of sistema Prompt "\<Administrar Claves" ;
	KEY Alt+A, "[A]" ;
	SKIP For _Screen.oApp.lLogin = .F. Or _Screen.oApp.lIsGuest = .T. ;
	PICTURE "FW\Comunes\Image\Ico\Llave.ico" ;
	MESSAGE "Administra los Permisos de los Usuarios"

On Selection Bar 110 Of sistema Do Form "Fw\Comunes\Scx\ABMLogin"


Try

	If  _Screen.oApp.oUser.IsAdmin

		Define Bar 115 Of sistema Prompt "Administrar \<Módulos" ;
			KEY Alt+M, "[M]" ;
			SKIP For _Screen.oApp.lLogin = .F. ;
			PICTURE "FW\Comunes\Image\Ico\Llave.ico" ;
			MESSAGE "Administra los Niveles de los Módulos"

		On Selection Bar 115 Of sistema Do Form "Fw\Comunes\Scx\frmModulos"


		If .F.
			Define Bar 120 Of sistema Prompt "Administrar M\<enues" ;
				KEY Alt+E, "[E]" ;
				SKIP For _Screen.oApp.lLogin = .F. ;
				PICTURE "FW\Comunes\Image\Ico\Llave.ico" ;
				MESSAGE "Administra los Menues de los Módulos"
		Endif
	Endif


Catch To oErr

Finally

Endtry

Define Bar 199 Of sistema Prompt "\-"

Define Bar 201 Of sistema Prompt "\<Personalizar" ;
	KEY Alt+P, "[P]" ;
	SKIP For _Screen.oApp.lLogin = .F. ;
	PICTURE "FW\Comunes\Image\Ico\Herramientas.ico" ;
	MESSAGE "Personaliza el Tamaño y Tipos de Letra"

On Selection Bar 201 Of sistema Do Form "Rutinas\Scx\frmLayoutSetup.Scx"

If _Screen.oApp.lMultiEmpresa
	If Upper( _Screen.oApp.cApplicationName ) = Upper( "Contabilidad" )
		Define Bar 310 Of sistema Prompt "Cambio De E\<jercicio" ;
			KEY Alt+J, "[J]" ;
			SKIP For _Screen.oApp.lLogin = .F. ;
			PICTURE "FW\Comunes\Image\Ico\Refresh.ico" ;
			MESSAGE "Cambiar el Ejercicio Activo"

		On Selection Bar 310 Of sistema Do Execute With "Clientes\Contabilidad\Prg\CambioDeEjercicio"

	Endif

	Define Bar 320 Of sistema Prompt "Cambio De \<Empresa" ;
		KEY Alt+E, "[E]" ;
		SKIP For _Screen.oApp.lLogin = .F. ;
		PICTURE "FW\Comunes\Image\Ico\Refresh.ico" ;
		MESSAGE "Cambiar la Empresa Activa"

	On Selection Bar 320 Of sistema Do Execute With "Rutinas\Prg\CambioDeEmpresa"

	Define Bar 299 Of sistema Prompt "\-"


Else

	Do Case
		Case Upper( _Screen.oApp.cApplicationName ) = Upper( "Contable" ) Or ;
				Upper( _Screen.oApp.cApplicationName ) = Upper( "Contabilidad" )

			If  FileExist( Addbs( _Screen.oApp.cRootWorkFolder ) + "Empresas.Dbf" )
				Define Bar 310 Of sistema Prompt "Cambio De \<Ejercicio" ;
					KEY Alt+E, "[E]" ;
					SKIP For _Screen.oApp.lLogin = .F. ;
					PICTURE "FW\Comunes\Image\Ico\Refresh.ico" ;
					MESSAGE "Cambiar el Ejercicio Activo"

				On Selection Bar 310 Of sistema Do Execute With "Clientes\Contable\Prg\CoCambio"

			Endif

		Case Upper( _Screen.oApp.cApplicationName ) = Upper( "Caja" )

			Define Bar 310 Of sistema Prompt "Cambio De \<Ejercicio" ;
				KEY Alt+E, "[E]" ;
				SKIP For _Screen.oApp.lLogin = .F. ;
				PICTURE "FW\Comunes\Image\Ico\Refresh.ico" ;
				MESSAGE "Cambiar el Ejercicio Activo"

			* RA 06/07/2017(10:42:59)
			* Para que no trate de incluir Cj_Cambio en todos los proyectos
			TEXT To lcCommand NoShow TextMerge Pretext 15
			On Selection Bar 310 Of Sistema Do Cj_Cambio
			ENDTEXT

			&lcCommand
			lcCommand = ""



		Otherwise
			If  FileExist( Addbs( _Screen.oApp.cRootWorkFolder ) + "Sucursal.Dbf" )
				Define Bar 320 Of sistema Prompt "Cambio De \<Sucursal" ;
					KEY Alt+S, "[S]" ;
					SKIP For _Screen.oApp.lLogin = .F. ;
					PICTURE "FW\Comunes\Image\Ico\Refresh.ico" ;
					MESSAGE "Cambiar de Sucursal Activa"

				On Selection Bar 320 Of sistema Do Execute With "Rutinas\arChgDrv", .T.

			Endif


	Endcase

Endif


If GetValue( "PrintDOS", "ar0Var", "S" ) = "S"
	Define Bar 410 Of sistema Prompt "Parámetros de \<Impresoras DOS" ;
		KEY Alt+I, "[I]" ;
		SKIP For _Screen.oApp.lLogin = .F. ;
		PICTURE "FW\Comunes\Image\Bmp\Print.bmp" ;
		MESSAGE "Definir Impresoras en Puertos Paralelos"

	On Selection Bar 410 Of sistema Do Execute With "Rutinas\arParPrn"

Endif

If GetValue( "PrintWin", "ar0Var", "S" ) = "S"
	Define Bar 420 Of sistema Prompt "Parámetros de Impresoras \<WINDOWS" ;
		KEY Alt+W, "[W]" ;
		SKIP For _Screen.oApp.lLogin = .F. ;
		PICTURE "FW\Comunes\Image\Bmp\Print.bmp" ;
		MESSAGE "Definir Impresoras en la Red de Windows"

	On Selection Bar 420 Of sistema Do Execute With "Fw\Comunes\prg\Impresora", .T.

Endif

Define Bar 499 Of sistema Prompt "\-"

If GetValue( "SendMail", "ar0Mai", "N" ) = "S"

	If _Screen.oApp.oUser.IsAdmin && Or .T.

		Define Bar 510 Of sistema Prompt "Cuentas de C\<orreo Electrónico" ;
			KEY Alt+O, "[O]" ;
			SKIP For _Screen.oApp.lLogin = .F. ;
			PICTURE "Fw\Comunes\Image\ico\eMail2.ico" ;
			MESSAGE "Definir Cuentas de Correo Electrónico"

		On Selection Bar 510 Of sistema Do Execute With "Fw\Comunes\prg\MailAccount", .T.

		Define Bar 599 Of sistema Prompt "\-"
	Endif

Endif


Define Bar 990 Of sistema Prompt "Acerca de ésta \<Versión ..." ;
	KEY Alt+V, "[V]" ;
	PICTURE "v:\Clipper2Fox\FW\Comunes\image\ico\fenix.ico"

On Selection Bar 990 Of sistema Do Form "Fw\Comunes\Scx\About"

Define Bar 991 Of sistema Prompt "\-"

Define Bar 999 Of sistema Prompt "Salir del Sistema" ;
	KEY Alt+F4, "[ALT+F4]" ;
	PICTURE "FW\Comunes\Image\Bmp\Close.bmp"

On Selection Bar 999 Of sistema _Screen.oApp.Exit()

If .F.
	*!*	    Do CoCambio.Prg
	Do arChgDrv.Prg
	Do ArParPrn.Prg
	Do Impresora.Prg
	Do MailAccount.Prg
	Do Form "Rutinas\Scx\frmLayoutSetup.Scx"
	Do Form "Fw\Comunes\Scx\ABMLogin"
	Do Form "FW\Comunes\scx\About.scx"
Endif
