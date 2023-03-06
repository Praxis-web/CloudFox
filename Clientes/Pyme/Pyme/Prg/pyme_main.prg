#INCLUDE "FW\Comunes\Include\Praxis.h"

*!* ///////////////////////////////////////////////////////
*!* PROCEDURE.....: Pyme_Main
*!* DESCRIPTION...: programa principal del proyecto
*!* DATE..........: Miércoles 6 de Abril de 2022 (10:02:41)
*!* AUTHOR........: RICARDO AIDELMAN
*!* PROJECT.......: SISTEMAS PRAXIS
*!* -------------------------------------------------------
*!* MODIFICATION SUMMARY
*!* R/0001  -
*!*
*!*

Lparameters tcAppName As String, ;
    tcVersion As String,;
    tcUser As String

Local loMain As Pyme_Main Of Clientes\Pyme\Pyme\prg\Pyme_Main.prg

Try
    Close Databases All

    If Empty( tcAppName )
        tcAppName = "Gestión Comercial"
    Endif

    If Empty( tcVersion )
        tcVersion = "1.0"
    Endif

    If Empty( tcUser )
        tcUser = ""
    Endif

    loMain = Createobject( "oPyme", ;
        tcAppName,;
        tcVersion,;
        tcUser )

    loMain.Start()

Catch To oErr

    Try
        Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

        loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
        loError.Process( oErr )

    Catch To oErr
        ShowError( oErr )

    Finally

    Endtry


Finally
    _Screen.Picture = ""

    Try

        If Vartype(loMain)=="O"
            loMain.Destroy()
        Endif

    Catch To oErr

    Finally
        loMain = Null

    Endtry

Endtry

*/ ---------------------------------------------------------------------------

Define Class oPyme As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

    #If .F.
        Local This As oPyme Of Clientes\Pyme\Pyme\Prg\Pyme_Main.Prg
    #Endif

    * Nombre del archivo donde se guardan las variables DRVx
    *cParameFileName = "Clientes\Pyme\ArParame"
    cRootWorkFolder = "Clientes\Pyme\"
    *cDBFMenu 		= "Clientes\Pyme\Pyme\Pyme"
    cScreenIcon 	= "v:\CloudFox\FW\Comunes\image\ico\PraxisComputacion.ico"
    cAppLogoSource 	= "v:\CloudFox\FW\Comunes\image\jpg\LogoPraxis.jpg"

    nModuloId 		= 0

    nWindowState	= 2

    *
    *
    Procedure yyy___BuildMainMenu(  ) As Void
        Local lcCommand As String
        Local loMenu As oMenu Of "FrontEnd\Prg\DescargarMenu.prg"

        Try

            lcCommand = ""
            loMenu = GetEntity( "Menu" )
            loMenu.MenuLoader()

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loMenu = Null

        Endtry

    Endproc && BuildMainMenu

    *!* ///////////////////////////////////////////////////////
    *!* PROCEDURE.....: BuildMainMenu
    *!* DESCRIPTION...:
    *!* DATE..........: Sábado 21 de Mayo de 2011 (16:35:54)
    *!* AUTHOR........: RICARDO AIDELMAN
    *!* PROJECT.......:
    *!* -------------------------------------------------------
    *!* MODIFICATION SUMMARY
    *!* R/0001  -
    *!*
    *!*

    Procedure xxx___BuildMainMenu( tcMenu As String ) As VOID

        With This As prxApplication Of "fw\sysAdmin\prg\saMain.prg"

            Try

                If IsRuntime()
                    This.cDBFMenu = "Datos\Pyme"
                Endif

                MenuLoader( This.cDBFMenu, This.oUser.Clave )

            Catch To oErr
                Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

                loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
                loError.Process( oErr )
                Throw loError

            Finally

            Endtry

        Endwith

    Endproc &&    xxx___BuildMainMenu


Enddefine
