
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


Define Bar 199 Of sistema Prompt "\-"

If _Screen.oApp.oUser.IsImplementador
    Define Bar 320 Of sistema Prompt "Cambio De Cliente Pra\<xis" ;
        KEY Alt+X, "[X]" ;
        SKIP For _Screen.oApp.lLogin = .F. ;
        PICTURE "FW\Comunes\Image\Ico\Refresh.ico" ;
        MESSAGE "Cambiar de Cliente Praxis Activo"

    On Selection Bar 320 Of sistema Do "FrontEnd\Prg\CambiarClienteActivo.prg"

Endif

If _Screen.oApp.oUser.lIsActive
    Define Bar 330 Of sistema Prompt "Cambio De \<Empresa Activa" ;
        KEY Alt+E, "[E]" ;
        SKIP For _Screen.oApp.lLogin = .F. ;
        PICTURE "FW\Comunes\Image\Ico\Refresh.ico" ;
        MESSAGE "Cambiar de Empresa Activo"

    On Selection Bar 330 Of sistema Do "FrontEnd\Prg\CambiarEmpresaActiva.prg"

    Define Bar 340 Of sistema Prompt "Cambio De S\<ucursal Activa" ;
        KEY Alt+U, "[U]" ;
        SKIP For _Screen.oApp.lLogin = .F. ;
        PICTURE "FW\Comunes\Image\Ico\Refresh.ico" ;
        MESSAGE "Cambiar de Empresa Activo"

    On Selection Bar 340 Of sistema Do "FrontEnd\Prg\CambiarSucursalActiva.prg"
Endif

Define Bar 991 Of sistema Prompt "\-"

Define Bar 990 Of sistema Prompt "Acerca de ésta \<Versión ..." ;
    KEY Alt+V, "[V]" ;
    PICTURE "v:\CloudFox\FW\Comunes\image\ico\PraxisComputacion.ico"

On Selection Bar 990 Of sistema Do Form "Fw\Comunes\Scx\About"

Define Bar 999 Of sistema Prompt "Salir del Sistema" ;
    KEY Alt+F4, "[ALT+F4]" ;
    PICTURE "FW\Comunes\Image\Bmp\Close.bmp"

On Selection Bar 999 Of sistema _Screen.oApp.Exit()

If .F.
    Do arChgDrv.Prg
    Do Impresora.Prg
    Do MailAccount.Prg
    Do Form "Rutinas\Scx\frmLayoutSetup.Scx"
    Do Form "FW\Comunes\scx\About.scx"
Endif