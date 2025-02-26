*!*	///////////////////////////////////////////////////////
*!*	Procedure.....: Main
*!*	Description...: Programa principal del Proyecto
*!*	Date..........: Lunes 10 de Enero de 2005 (18:16:15)
*!*	Author........: Ricardo Aidelman
*!*	Project.......: Visual Praxis Beta 1.1
*!*	-------------------------------------------------------
*!*	Modification Summary
*!* R/0001  -
*!*
*!*


External Procedure GetValue.prg,;
    AppLogo.prg,;
    GetMain.prg,;
    GetCursorStructure.prg,;
    AppendFromCursor.prg,;
    GetFieldStructure.prg,;
    Convert2Any.prg,;
    prxCursorAdapter.prg,;
    Fecha2Sql.prg,;
    Date2CtoD.prg,;
    PedirCopias.prg,;
    DataHasChanges.prg,;
    GetEntity.prg,;
    prxEntity.prg,;
    LogError.prg,;
    prxSmtp.prg,;
    IsRuntime.prg,;
    IfEmpty.prg,;
    IsEmpty.prg,;
    PopulateProperties.prg,;
    Int2Hex.prg,;
    Hex2Int.prg,;
    Int2RGB.prg,;
    StrToI2of5.prg

External Procedure NoDelimiters.prg,;
    IsDebugMode.prg,;
    Any2Char.prg,;
    DateMask.prg,;
    ShowError.prg,;
    DefaultValue.prg,;
    CreateObjParam.prg,;
    GetDate.prg,;
    ParseXML.prg,;
    ConvertInputMask.prg,;
    SetProcedure.prg,;
    XmlToObject.prg,;
    CleanString.prg,;
    ProperCase.prg,;
    ObjectToXml.prg,;
    GetMaxId.prg,;
    SaveNewId.prg,;
    ZapCursor.prg,;
    PackCursor.prg,;
    GetChangedFields.prg,;
    GetOutputOptions.prg,;
    CrearXML.prg,;
    ForceType.prg,;
    Ansii2Ascii.prg,;
    GotoRecno.prg,;
    onKeyLabel.prg,;
    GlobalSettings.prg,;
    prx_Tabla.prg,;
    Output2Xls.prg

External Procedure CursorNameSpace.prg

External Procedure ;
    Fw\SysAdmin\mnx\sistema.prg,;
    GetUpdatableFieldList.prg

External File FenixLogo.JPG,LogoPraxis.jpg

External Procedure NewBackEnd.prg,;
    BackEndSettings.prg


#INCLUDE "FW\SysAdmin\Include\SA.h"
#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\TierAdapter\Include\TA.h"

Local loMain As prxApplication Of "FW\SysAdmin\Prg\saMain.prg"
Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

Try

    Close Databases All
    loMain = Createobject( "prxApplication", ;
        AD_APPNAME, ;
        AD_VERSION )

    *loMain.Start()

Catch To oErr

    Try
        loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
        loError.Process( oErr )
    Catch
        Do While Vartype( oErr.UserValue ) == "O"
            oErr = oErr.UserValue
        Enddo
        lcText = "No se pudo ejecutar la Aplicaci�n" + CR + CR
        lcText = lcText + "[  M�todo   ] " + oErr.Procedure + CR + ;
            "[  L�nea N� ] " + Transform(oErr.Lineno) + CR + ;
            "[  Comando  ] " + oErr.LineContents + CR  + ;
            "[  Error    ] " + Transform(oErr.ErrorNo) + CR + ;
            "[  Mensaje  ] " + oErr.Message  + CR + ;
            "[  Detalle  ] " + oErr.Details

        =Messagebox( lcText, 16, "Error Grave" )
    Finally
    Endtry
Finally
    Try

        Release loMain

        If Vartype(loMain)=="O"
            loMain.Destroy()
        Endif
    Catch To oErr
    Finally
        loMain = Null
    Endtry
Endtry

*!*	If .F.
*!*		Do FenixLogo.JPG
*!*		Do AppLogo.prg
*!*		Do GetMain.prg
*!*		Do GetCursorStructure.prg
*!*		Do GetFieldStructure.prg
*!*		Do Convert2Any.prg
*!*		Do prxCursorAdapter.prg
*!*		Do Fecha2Sql.prg
*!*		Do PedirCopias.prg
*!*		Do DataHasChanges.prg
*!*		Do GetEntity.prg
*!*		Do LogError.prg
*!*		Do Tools\eMail\Prg\prxSmtp.prg
*!*	EndIf


Return

* Declarar los programas y clases que son necesarios que el Builder
* incluya en el proyecto

If .F.

    *!*		Do 'jpg\PraxisGold.JPG'
    *!*		Do "AppLogo.prg"
    *!*		Do "Praxis.ico"
    *!*		Do "prxToolbar.vcx"
Endif


* Fin de declaracion de programas y clases



*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxApplication
*!* ParentClass...: AbstractApplication
*!* BaseClass.....: Session
*!* Description...: Clase pincipal de la aplicaci�n
*!* Date..........: Martes 18 de Abril de 2006 (11:37:42)
*!* Author........: Ricardo Aidelman
*!* Project.......: Visual Praxis Beta v. 1.1
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*


Define Class prxApplication As AbstractApplication Of "FW\TierAdapter\Comun\AbstractApplication.prg"

    #If .F.
        Local This As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"
    #Endif

    *!* Flag que indica si se est� corriendo dentro de un Test Unitario
    lTesting = .F.

    lDebugMode	= .F.	&& Esta corriendo en modo de desarrollo
    lSplash		= .F.	&& Existe una Splash Screen
    lDesktop	= .T.	&& If there is a desktop (with a main menu)

    lAppLogo				= .T.	&& Hay un Logo de la Aplicacion
    cAppLogoSource 			= Addbs(FL_IMAGE)+'jpg\FenixLogo.JPG'

    cAppLogoClass 			= "AppLogo"
    cAppLogoClassLibrary 	= "fw\comunes\prg\AppLogo.prg"

    lFenixLogo				= .T.	&& Hay un Logo de Fenix
    *cFenixLogoSource 		= Addbs(FL_IMAGE)+'jpg\FenixLogo.JPG'
    cFenixLogoSource 		= Addbs(FL_IMAGE)+'jpg\LogoPraxis.jpg'

    cApplicationName	= ""
    cVersion			= ""

    * Nombre del archivo que contiene la librer�a del Diccionario de Datos
    * ( Ver NewColDataBases.prg )
    cDataDictionaryLib 		= "Clientes\Utiles\prg\utDataDictionary.prg"
    cDataDictionaryClass 	= "oDataDictionary"

    oMainToolbar = Null
    oMenuBuilder = Null

    cSplashClass 			= "SplashScreen"
    cSplashClassLibrary		= "fw\comunes\vcx\SplashScreen"
    *cScreenIcon 			= "v:\CloudFox\fw\Comunes\Image\ico\Fenix.ico"
    cScreenIcon 			= "v:\CloudFox\fw\Comunes\Image\ico\Praxis.ico"
    cToolbarClass 			= "prxToolBar"
    cToolbarClassLibrary 	= "fw\comunes\vcx\prxToolbar.vcx"

    lExit = .F.
    * Cancela la ejecucion del proceso actual
    lCancelProcess = .F.

    MenuSistema 		= Addbs( SA_MNX ) + "Sistema"
    MenuWindow 			= ""
    MenuSYSAdmin 		= ""
    MenuArchivosYTablas = ""
    MenuCompras 		= ""
    MenuContable 		= ""
    MenuProduccion 		= ""
    MenuStock 			= ""
    MenuGeneral 		= ""
    MenuVentas 			= ""
    MenuEdit 			= ""
    MenuUtiles			= ""

    *!*
    * DAE 2009-08-04 {} = Fecha Null
    dPrimerFechaValida = {} && Ctod("")


    *!*
    * DAE 2009-08-04 {} = Fecha Null
    dUltimaFechaValida = {} && Ctod("")

    * Nombre del archivo donde se guardan las variables DRVx
    cParameFileName = ""

    cDBFMenu = ""

    * Ruta donde se encuentra la carpeta del cliente con la cual se trabaja
    cRootWorkFolder = ""

    * Nombre del font que utilaz los Forms
    FontName = 'Lucida Console'

    * Tama�o del Font
    FontSize = 11

    FontStyle = "N"
    FontCharSet = 0

    oColFonts = Null

    * Contiene la �ltima tecla presionada
    nKeyCode = 0

    * Contiene el valor de la tecja auxiliar presionada
    nShiftAltCtrl = 0

    * Indica si debe chequearse Lastkey()
    lCheckLastKey = .T.

    * Codigo InKey
    nKeyStroke = 0



    * Nombre de la Empresa Activa
    cEmpresa = ""

    * Id de la Empresa Activa
    nEmpresaId = 0

    * Nombre de la Sucursal Activa
    cSucursal = ""

    *
    cEjercicio = ""



    * Indica si pide que el usuario se Logu�e
    lDoLogin = .T.

    * Indica si el usuario logueado es invitado
    * Un usuario invitado es aquel que no se logueo porque lDoLogin est� en true
    lIsGuest = .T.


    * Ancho m�ximo del Selector
    nSelectorMaxWidth = 80

    *
    nWindowState = 0

    * Utilizado por el formulario frmMemoEdit como par�metro
    oMemoEdit = Null

    * Ajusta la pantalla al tama�o del formulario
    lFitToForm = .F.

    * Nivel de profundidad de la consulta Drill Down
    nDrillDownLevel = 0

    * Contiene un backup del _Screen.Caption, por si es modificado durante el programa
    cScreenCaption = ""


    * Contiene el titulo original del programa
    cTitPro = ""

    * Id del Usuario Logueado
    Userid = 0

    * Numero de version
    nVersion = 0

    * Indica si la versi�n utiliza NameSpaces
    * Determinadas funciones la utilizan para poder reutilizar c�digo
    * mientras se reescribe el nuevo
    lUseNameSpaces = .F.

    * Indica si son tablas libres o utiliza una DBC
    lUseDBC = .F.

    * Indica si se utilizan transacciones
    lUseTransactions = .F.

    * Modo Debug
    lDebugMode = .F.

    lCloseNativeTables = .F.

    * Identificaci�n de la aplicaci�n en el archivo de Accesos (Modulo.dbf)
    nModuloId = 0


    * Indica si es la nueva versi�n multiempresa en un �nico archivo
    lMultiEmpresa = .F.


    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="lusenamespaces" type="property" display="lUseNameSpaces" />] + ;
        [<memberdata name="ndrilldownlevel" type="property" display="nDrillDownLevel" />] + ;
        [<memberdata name="lfittoform" type="property" display="lFitToForm" />] + ;
        [<memberdata name="nwindowstate" type="property" display="nWindowState" />] + ;
        [<memberdata name="cempresa" type="property" display="cEmpresa" />] + ;
        [<memberdata name="cempresa_access" type="method" display="cEmpresa_Access" />] + ;
        [<memberdata name="cejercicio" type="property" display="cEjercicio" />] + ;
        [<memberdata name="cejercicio_access" type="method" display="cEjercicio_Access" />] + ;
        [<memberdata name="nempresaid" type="property" display="nEmpresaId" />] + ;
        [<memberdata name="lchecklastkey" type="property" display="lCheckLastKey" />] + ;
        [<memberdata name="nshiftaltctrl" type="property" display="nShiftAltCtrl" />] + ;
        [<memberdata name="nkeycode" type="property" display="nKeyCode" />] + ;
        [<memberdata name="fontsize" type="property" display="FontSize" />] + ;
        [<memberdata name="fontname" type="property" display="FontName" />] + ;
        [<memberdata name="cparamefilename" type="property" display="cParameFileName" />] + ;
        [<memberdata name="cobjectfactoryfilename" type="property" display="cObjectFactoryFileName" />] + ;
        [<memberdata name="dprimerfechavalida" type="property" display="dPrimerFechaValida" />] + ;
        [<memberdata name="dultimafechavalida" type="property" display="dUltimaFechaValida" />] + ;
        [<memberdata name="menuedit" type="property" display="MenuEdit" />] + ;
        [<memberdata name="menugeneral" type="property" display="MenuGeneral" />] + ;
        [<memberdata name="menustock" type="property" display="MenuStock" />] + ;
        [<memberdata name="menuarchivosytablas" type="property" display="MenuArchivosYTablas" />] + ;
        [<memberdata name="menusysadmin" type="property" display="MenuSYSAdmin" />] + ;
        [<memberdata name="menuwindow" type="property" display="MenuWindow" />] + ;
        [<memberdata name="menusistema" type="property" display="MenuSistema" />] + ;
        [<memberdata name="menucompras" type="property" display="MenuCompras" />] + ;
        [<memberdata name="menucontable" type="property" display="MenuContable" />] + ;
        [<memberdata name="menuproduccion" type="property" display="MenuProduccion" />] + ;
        [<memberdata name="menuventas" type="property" display="MenuVentas" />] + ;
        [<memberdata name="capplogoclass" type="property" display="cAppLogoClass" />] + ;
        [<memberdata name="capplogoclasslibrary" type="property" display="cAppLogoClassLibrary" />] + ;
        [<memberdata name="capplogosource" type="property" display="cAppLogoSource" />] + ;
        [<memberdata name="lapplogo" type="property" display="lAppLogo" />] + ;
        [<memberdata name="ctoolbarclasslibrary" type="property" display="cToolbarClassLibrary" />] + ;
        [<memberdata name="ctoolbarclass" type="property" display="cToolbarClass" />] + ;
        [<memberdata name="cscreenicon" type="property" display="cScreenIcon" />] + ;
        [<memberdata name="oapplogo" type="property" display="oAppLogo" />] + ;
        [<memberdata name="showsplashscreen" type="event" display="ShowSplashScreen" />] + ;
        [<memberdata name="omenubuilder" type="property" display="oMenuBuilder" />] + ;
        [<memberdata name="lsplash" type="property" display="lSplash" />] + ;
        [<memberdata name="ldesktop" type="property" display="lDesktop" />] + ;
        [<memberdata name="cversion" type="property" display="cVersion" />] + ;
        [<memberdata name="omaintoolbar" type="property" display="oMainToolBar" />] + ;
        [<memberdata name="csplashclass" type="property" display="cSplashClass" />] + ;
        [<memberdata name="csplashclasslibrary" type="property" display="cSplashClassLibrary" />] + ;
        [<memberdata name="setapplicationmaincaption" type="method" display="SetApplicationMainCaption" />] + ;
        [<memberdata name="showsplashscreen" type="method" display="ShowSplashScreen" />] + ;
        [<memberdata name="buildmaintoolbar" type="method" display="BuildMainToolbar" />] + ;
        [<memberdata name="buildmainmenu" type="method" display="BuildMainMenu" />] + ;
        [<memberdata name="showdesktoplogo" type="method" display="ShowDesktopLogo" />] + ;
        [<memberdata name="exit" type="method" display="Exit" />] + ;
        [<memberdata name="start" type="method" display="Start" />] + ;
        [<memberdata name="setsystemmenu" type="method" display="SetSystemMenu" />] + ;
        [<memberdata name="lexit" type="property" display="lExit" />] + ;
        [<memberdata name="closeall" type="method" display="CloseAll" />] + ;
        [<memberdata name="login" type="method" display="Login" />] + ;
        [<memberdata name="personalize" type="method" display="Personalize" />] + ;
        [<memberdata name="ltesting" type="property" display="lTesting" />] + ;
        [<memberdata name="clearinstances" type="method" display="ClearInstances" />] + ;
        [<memberdata name="setglobales" type="method" display="SetGlobales" />] + ;
        [<memberdata name="fontlayout" type="method" display="FontLayout" />] + ;
        [<memberdata name="lcancelprocess" type="property" display="lCancelProcess" />] + ;
        [<memberdata name="crootworkfolder" type="property" display="cRootWorkFolder" />] + ;
        [<memberdata name="omemoedit" type="property" display="oMemoEdit" />] + ;
        [<memberdata name="ldologin" type="property" display="lDoLogin" />] + ;
        [<memberdata name="setparamefilename" type="method" display="SetParameFileName" />] + ;
        [<memberdata name="launchformmenu" type="method" display="LaunchFormMenu" />] + ;
        [<memberdata name="nselectormaxwidth" type="property" display="nSelectorMaxWidth" />] + ;
        [<memberdata name="lisguest" type="property" display="lIsGuest" />] + ;
        [<memberdata name="cscreencaption" type="property" display="cScreenCaption" />] + ;
        [<memberdata name="ctitpro" type="property" display="cTitPro" />] + ;
        [<memberdata name="userid" type="property" display="UserId" />] + ;
        [<memberdata name="nversion" type="property" display="nVersion" />] + ;
        [<memberdata name="nmoduloid" type="property" display="nModuloId" />] + ;
        [<memberdata name="lmultiempresa" type="property" display="lMultiEmpresa" />] + ;
        [<memberdata name="hookafterbuildmainmenu" type="method" display="HookAfterBuildMainMenu" />] + ;
        [<memberdata name="setprocedures" type="method" display="SetProcedures" />] + ;
        [<memberdata name="setclasslibs" type="method" display="SetClassLibs" />] + ;
        [<memberdata name="cdatadictionarylib" type="property" display="cDataDictionaryLib" />] + ;
        [<memberdata name="cdatadictionaryclass" type="property" display="cDataDictionaryClass" />] + ;
        [<memberdata name="nkeystroke" type="property" display="nKeyStroke" />] + ;
        [<memberdata name="validarterminal" type="method" display="ValidarTerminal" />] + ;
        [<memberdata name="hookaftersetup" type="method" display="HookAfterSetup" />] + ;
        [<memberdata name="personalizar_modelos" type="method" display="Personalizar_Modelos" />] + ;
        [<memberdata name="obtenerpermisos" type="method" display="ObtenerPermisos" />] + ;
        [</VFPData>]


    Function Init( tcAppName As String, ;
            tcVersion As String,;
            tcUser As String,;
            tcWorkFolder As String ) As Boolean


        Local llOk As Boolean
        Local loMemoEdit As Object
        Local loAction As Object
        Local lcFrxFolder As String,;
            lcUser As String,;
            lcMachine As String


        Try

            loMemoEdit 	= Createobject( "Empty" )
            loAction	= Createobject( "Empty" )

            AddProperty( loAction, "Method", "" )
            AddProperty( loAction, "Parameters", "" )

            AddProperty( loMemoEdit, "cArch", "" )
            AddProperty( loMemoEdit, "lCanEdit", .F. )
            AddProperty( loMemoEdit, "lLaunchFrx", .T. )
            AddProperty( loMemoEdit, "cFrxName", "" )
            AddProperty( loMemoEdit, "cFrxFolder", "" )
            AddProperty( loMemoEdit, "oReport", Null )
            AddProperty( loMemoEdit, "oAction", loAction )

            This.oMemoEdit = loMemoEdit

            *!*				DoDefault( tcAppName, ;
            *!*					tcVersion,;
            *!*					tcUser )

            llOk = .T.

            If Empty( tcWorkFolder )
                tcWorkFolder = "\Fenix"
            Endif

            If Substr( tcWorkFolder, 1, 1 ) # "\"
                tcWorkFolder = "\" + tcWorkFolder
            Endif

            If IsRuntime()
                This.cParameFileName = "Datos\arParame"
                This.cRootWorkFolder = Getenv( "USERPROFILE" ) + tcWorkFolder

            Else
                Local lcCurdir As String

                lcCurdir = Set('DEFAULT') + Sys(2003)

                If FileExist( Addbs( lcCurdir ) + "WorkingFolder.Cfg" )
                    loXA = Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

                    loXA.LoadXML( Addbs( lcCurdir ) + "WorkingFolder.Cfg", .T. )
                    loXA.Tables(1).ToCursor()
                    loXA = Null


                    lcMachine 	= Sys(0)
                    lcUser 		= lcMachine
                    lcMachine	= Alltrim( Upper( Substr( lcMachine, 1, At( "#", lcMachine ) - 1 ) ))
                    lcUser 		= Alltrim( Upper( Substr( lcUser , At( "#", lcUser ) + 1 ) ) )

                    Locate For Alltrim( Upper( Machine ) ) = lcMachine ;
                        And  Alltrim( Upper( User ) ) = lcUser


                    This.cRootWorkFolder = Alltrim( WorkingFolder )

                    Use In Alias()
                Endif

            Endif

            This.SetParameFileName()

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            llOk = .F.
            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )

        Finally
            loMemoEdit = Null

        Endtry

        If llOk
            Return DoDefault(tcAppName, ;
                tcVersion,;
                tcUser )

        Else
            Return llOk

        Endif

    Endfunc && Init


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: Personalize
    *!* Description...: Carga los valores personalizados del usuario logueado
    *!* Date..........: Domingo 23 de Noviembre de 2008 (20:47:31)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure Personalize( toParam As Object, tnUserId As Integer ) As Void;
            HELPSTRING "Carga los valores personalizados del usuario logueado"

        Local loParam As Object,;
            loScreenColors As Object
        Local laMembers[ 1 ] As String
        Local lcProperty As String

        Try

            If  FileExist( "SetUp.cfg" )
                loParam = XmlToObject( Filetostr( "SetUp.cfg" ))

                If Vartype( loParam ) == "O"
                    Amembers( laMembers, loParam )
                    For Each lcProperty In laMembers
                        Try
                            This.&lcProperty = loParam.&lcProperty
                        Catch To oErr
                            * No hago nada
                        Finally
                        Endtry
                    Endfor

                    If Pemstatus( loParam, "oScreenColors", 5 )
                        loScreenColors 	= loParam.oScreenColors
                        gcForeColor 	= loScreenColors.cMainScreenForeColor
                        gcBackColor 	= loScreenColors.cMainScreenBackColor
                        gcGetBackColor 	= loScreenColors.cGetBackColor
                        gcGetForeColor 	= loScreenColors.cGetForeColor
                    Endif
                Endif
            Endif

            _Screen.WindowState = This.nWindowState

            If This.lFitToForm

            Endif


        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally
            loParam = Null

        Endtry
    Endproc && Personalize


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: Start
    *!* Description...: Inicia la aplicaci�n
    *!* Date..........: Martes 13 de Diciembre de 2005 (20:20:21)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Visual Praxis Beta v. 1.1
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure Start( toParam As Object ) As Void;
            HELPSTRING "Inicia la aplicaci�n"
        Local loSplash As Object

        Try

            _Screen.Visible = .F.

            _Screen.WindowState = 0 && Maximized on startup

            If IsRuntime()
                _Screen.AutoCenter = .T.
            Endif


            This.SetApplicationMainCaption()

            * Sets debug or production mode
            This.lDebugMode = IsDebugMode()
            _Screen.Visible = .T.

            If This.lIsOk
                loSplash = This.ShowSplashScreen( This.lSplash )

            Endif && This.lIsOk

            If This.lIsOk
                This.ShowDesktopLogo()

            Endif

            If This.lDebugMode
                Set Sysmenu To

            Else
                Set Sysmenu Off
                Set Sysmenu To

            Endif && This.lDebugMode

            * RA 04/07/2019(14:18:27)
            * Utiliza cShutOff en vez de lShutOff
            * Compatibilidad hacia atras
            *This.lShutOffTimer = GetValue( "lShutOff", "ar0Sys", .F. )
            lShutOff = GetValue( "lShutOff", "ar0Sys", .F. )

            This.lShutOffTimer = GetValue( "cShutOff", "ar0Sys", Iif( lShutOff, "S", "N" ) ) == "S"

            This.oShutOffTimer.Interval = GetValue( "Warning", "ar0Sys", 3600 ) * 1000
            This.oShutOffTimer.Enabled = This.lShutOffTimer

            Set Sysmenu Automatic
            This.oError.Ctracelogin = "Estableciendo Men� General"
            This.SetSystemMenu()
            This.oError.Ctracelogin = "Llamado al Formulario de Login"
            This.Login()
            If This.lDesktop
                This.BuildMainToolbar()
                ***.DesktopLogo()
                On Shutdown Clear Events
                Set Cursor On

            Else
                _Screen.Visible = .F.

            Endif && This.lDesktop

            If Vartype( loSplash ) == "O"
                loSplash = .F.

            Endif && Vartype( loSplash ) == "O"

            This.LaunchFormMenu()

            This.Personalizar_Modelos()

            This.HookAfterSetup()


            * Este DO WHILE esta porque no puedo llamar al oApp.Exit() desde el objeto Menu
            * ya que este metodo Exit() destruye a ese objeto Menu, por lo tanto, el menu se
            * limita a hacer un CLEAR READS y luego se ejecuta el metodo oApp.Exit()
            *!*				Local llExit As Boolean
            *!*				llExit = .F.
            Do While ! This.lExit And ! This.lTesting
                * Este try atrapa todo error no controlado en la aplicaci�n.
                Try
                    This.oError.Ctracelogin = ""
                    This.oError.cRemark = ""
                    Read Events

                    If Pemstatus( _Screen, "oApp", 5 ) .And. ! This.lExit
                        _Screen.oApp.Exit()

                    Endif && Pemstatus( _Screen, "oApp", 5 ) .And. !This.lExit

                Catch To oErr
                    If This.lExit
                        _Screen.oApp.Exit()

                    Else
                        This.lIsOk = .T.
                        This.oError.Process( oErr )

                    Endif

                Finally
                Endtry

            Enddo

            ***=Messagebox("Aca Paro")
        Catch To oErr
            This.lIsOk = .F.
            This.cXMLoError = This.oError.Process( oErr )

        Finally
            If ! This.lTesting
                This.ClearInstances()
                _Screen.Visible = .T.
                On Shutdown
                If Wexist( "standard" )
                    Show Window standard

                Endif

            Endif

        Endtry

    Endproc &&& Start

    *!* ///////////////////////////////////////////////////////
    *!* Function......: SetEnvironment
    *!* Description...:
    *!* Date..........: Martes 29 de Marzo de 2005 (19:50:09)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Visual Praxis Beta 1.0
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*
    Function SetEnvironment() As Void

        Try

            If DoDefault()
                Local lcCurFolder As String

                This.SetClassLibs()

                Set Console Off
                Set Confirm On
                Set Exclusive Off
                Set Reprocess To 5 Seconds
                Sys( 3051, 1000 )

                Set Century Off
                Set Century To 19 Rollover 80
                Set Date Dmy
                Set Hours To 24
                Set Deleted On
                Set Multilocks On
                Set Cpdialog Off
                Set TablePrompt Off
                Set ReportBehavior 90
                Set Exact Off
                Set Decimals To 5
                Set NullDisplay To "No Definido"
                Set Point To '.'
                Set Separator To '.'

                Set Help Off
                Set Safety Off

                Set Notify Cursor Off

                This.SetProcedures()

                This.SetGlobales()

            Endif

        Catch To oErr
            .lIsOk = .F.
            Throw

        Finally
            loDataDictionary 	= Null
            loEntitiesConfig 	= Null

        Endtry

    Endfunc && SetEnvironment



    *
    *
    Procedure SetClassLibs(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""

            TEXT To lcCommand NoShow TextMerge Pretext 15
				Set Classlib To "Fw\Comunes\Vcx\prxBase" Additive
            ENDTEXT

            &lcCommand


            TEXT To lcCommand NoShow TextMerge Pretext 15
				Set Classlib To "Rutinas\Vcx\clipper2fox.vcx" Additive
            ENDTEXT

            &lcCommand


        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cRemark = lcCommand
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

    Endproc && SetClassLibs


    *
    *
    Procedure SetProcedures(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""

            Set Procedure To Rutinas\Rutina.prg
            *!*				Set Procedure To Clientes\Valores\prg\Valores.prg Additive
            *!*				Set Procedure To Clientes\Valores\prg\vaRutina.prg Additive
            *!*				Set Procedure To Clientes\Archivos\prg\ArRutArc.prg Additive
            *Set Procedure To Clientes\Archivos\prg\Articulo.prg Additive
            *!*				Set Procedure To Clientes\Contable\prg\coRutina.prg Additive
            *!*				Set Procedure To Clientes\IIBB\prg\arrutibr.prg Additive

            External Procedure ;
                Rutinas\Rutina.prg

            **Clientes\Archivos\prg\Articulo.prg


            *!*				External Procedure ;
            *!*					Rutinas\Rutina.prg,;
            *!*					Clientes\Valores\prg\Valores.prg,;
            *!*					Clientes\Valores\prg\vaRutina.prg,;
            *!*					Clientes\Archivos\prg\ArRutArc.prg,;
            *!*					Clientes\Archivos\prg\Articulo.prg,;
            *!*					Clientes\Contable\prg\coRutina.prg,;
            *!*					Clientes\IIBB\prg\arrutibr.prg


        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cRemark = lcCommand
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

    Endproc && SetProcedures

    *
    * Setear Archivo de Parametros
    Procedure SetParameFileName(  ) As Void;
            HELPSTRING "Setear Archivo de Parametros"

        Try

            If  FileExist( Addbs( This.cRootWorkFolder ) + "SUCURSAL.DBF")
                Use Addbs(This.cRootWorkFolder) + "SUCURSAL" Shared In 0
                Loca For ACTIVO

                If !Eof()
                    This.cParameFileName = Addbs( Alltrim( RUTA )) + "arParame"
                Endif

            Endif

            If Empty( This.cParameFileName )
                This.cParameFileName = "Datos\arParame"
            Endif

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

    Endproc && SetParameFileName


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: SetApplicationMainCaption
    *!* Description...:
    *!* Date..........: Martes 29 de Marzo de 2005 (20:28:52)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Visual Praxis Beta 1.0
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure SetApplicationMainCaption( cCaption As String ) As Void

        Local lcCaption As String
        Local lcFilterCriteria As String
        Local lnId As Integer
        Local lnEmpresaActiva As Integer
        Local loGlobalSettings As Object
        Local loEmpresaSucursal As Object

        Try



            If Empty( cCaption )
                loGlobalSettings = NewGlobalSettings()
                cCaption = loGlobalSettings.cDescripcionEmpresaActiva + " - "
                cCaption = cCaption + loGlobalSettings.cDescripcionSucursalActiva

                If Pemstatus( _Screen, "oScreenLog", 5 )
                    _Screen.oScreenLog.lblEmpresa.Caption 	= loGlobalSettings.cDescripcionEmpresaActiva
                    _Screen.oScreenLog.lblSucursal.Caption 	= loGlobalSettings.cDescripcionSucursalActiva
                Endif

            Endif

            _Screen.Caption = cCaption
            _Screen.Icon = This.cScreenIcon
            This.cScreenCaption = _Screen.Caption

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally
            loGlobalSettings = Null
            loEmpresaSucursal = Null

        Endtry


    Endproc && SetApplicationMainCaption

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: ShowSplashScreen
    *!* Description...: Muestra la Pantalla de Bienvenida (Splash Screen)
    *!* Date..........: Martes 11 de Enero de 2005 (15:40:38)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Visual Praxis Beta 1.0
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure ShowSplashScreen( tlShow As Boolean ) As Object

        Local loReturnForm As Form,;
            lcText As String

        If tlShow
            This.oError.Ctracelogin = "Mostrando Pantalla de Bienvenida"

            Try
                loReturnForm = Newobject( This.cSplashClass, ;
                    This.cSplashClassLibrary, "",;
                    Strtran( This.cApplicationName, "_", " " ),;
                    This.cVersion )

            Catch To oErr
                lcText = "No es Posible Mostrar la Pantalla de Bienvenida" + CR + ;
                    "[  Error: ] " + Transform(oErr.ErrorNo) + CR + ;
                    "[  Mensaje: ] " + oErr.Message  + CR + ;
                    "[  Detalle: ] " + oErr.Details

                Warning( lcText )

            Finally

            Endtry


        Else
            loReturnForm = Null

        Endif

        Return loReturnForm



    Endproc && ShowSplashScreen

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: BuildMainToolbar
    *!* Description...:
    *!* Date..........: Mi�rcoles 30 de Marzo de 2005 (20:56:27)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Visual Praxis Beta 1.0
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure BuildMainToolbar(  ) As Void

        With This As prxApplication Of "FW\Actual\Comun\Main.prg"

            .oError.Ctracelogin = "Construyendo Barra de Herramientas Principal"

            Try

                *!* If .lDebugMode
                *!*		* Keeps the Standard Toolbar
                *!*	Else
                If Wexist( "standard" )
                    * Hide Window standard
                Endif
                *!* Endif

                *!* If Vartype( .oMainToolbar ) # "O"
                *!*		.oMainToolbar = Newobject( .cToolbarClass  , .cToolbarClassLibrary )
                *!*		.oMainToolbar.Dock(0)
                *!*	Endif
                .oMainToolbar.Dock( 0 )

            Catch To oErr
                .lIsOk = .F.
                Throw

            Finally

            Endtry

        Endwith

    Endproc && BuildMainToolbar

    *
    *
    Procedure BuildMainMenu( oMenu As Collection ) As Void
        Local lcCommand As String
        Local loMenu As oMenu Of "FrontEnd\Prg\DescargarMenu.prg"

        Try

            lcCommand = ""
            loMenu = GetEntity( "Menu" )
            loMenu.MenuLoader( oMenu )

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


    Procedure HookAfterBuildMainMenu()
        Try

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

    Endproc

    *----------------- Exit point ---------------
    Procedure Exit( tlForced As Boolean ) As Void

        * Exit forced or by user confirmation

        Try

            This.oError.Ctracelogin = ""
            This.oError.cRemark = ""

            This.Logout()

            This.lExit = .T.

            Local lnColCount As Integer
            Local oForm As Form

            If Pemstatus( This, "oColForms", 5 ) And Vartype( This.oColForms ) = "O"
                Do While .T.
                    lnColCount = This.oColForms.Count
                    For Each oForm In This.oColForms
                        If This.lExit
                            oForm.Close()
                        Endif
                    Endfor
                    If lnColCount = This.oColForms.Count
                        Exit
                    Endif
                Enddo
            Endif

            If This.lExit
                *!*					This.lExit = tlForced ;
                *!*						or Confirm( S_EXITAPPLICATION )
                This.lExit = .T.

            Endif

            If This.lExit
                Release Windows
                Clear Events
            Endif

        Catch To oErr
            This.lIsOk = .F.
            This.cXMLoError=This.oError.Process( oErr )

        Finally
            oForm = .F.

        Endtry

        Return


        *!* ///////////////////////////////////////////////////////
        *!* Procedure.....: CloseAll
        *!* Description...: Cierra todas las ventanas abiertas
        *!* Date..........: Jueves 16 de Noviembre de 2006 (15:07:36)
        *!* Author........: Ricardo Aidelman
        *!* Project.......: Sistemas Praxis
        *!* -------------------------------------------------------
        *!* Modification Summary
        *!* R/0001  -
        *!*
        *!*

    Procedure CloseAll(  ) As Void;
            HELPSTRING "Cierra todas las ventanas abiertas"

        Try
            Local lnColCount As Integer
            Local oForm As Form

            This.lExit = .T.
            Do While .T.
                lnColCount = This.oColForms.Count
                For Each oForm In This.oColForms
                    If This.lExit
                        ***oForm.Close()
                        oForm.Cerrar()
                    Endif
                Endfor
                If lnColCount = This.oColForms.Count
                    Exit
                Endif
            Enddo


        Catch To oErr
            This.lIsOk = .F.
            This.cXMLoError=This.oError.Process( oErr )

        Finally
            oForm = .F.

        Endtry


    Endproc
    *!*
    *!* END PROCEDURE CloseAll
    *!*
    *!* ///////////////////////////////////////////////////////



    Procedure ShowDesktopLogo()
        Local lnMiddle As Integer
        With This As prxApplication Of "FW\Actual\Comun\Main.prg"

            .oError.Ctracelogin = "Mostrando Logo en el Escritorio"
            Try

                If .lFenixLogo

                    If Pemstatus( _Screen, "oFenixLogo", 5 )
                        _Screen.RemoveObject( "oFenixLogo" )
                    Endif

                    With _Screen
                        _Screen.Newobject( "oFenixLogo", "FenixLogo", This.cAppLogoClassLibrary )

                        .oFenixLogo.Picture = This.cFenixLogoSource
                        .oFenixLogo.Visible = .T.

                        .MinHeight = Max( .MinHeight, .oFenixLogo.Height + 48 )
                        .MinWidth = Max( .MinWidth, .oFenixLogo.Width + 48 )

                    Endwith

                Endif

                If .lAppLogo

                    If Pemstatus( _Screen, "oAppLogo", 5 )
                        _Screen.RemoveObject( "oAppLogo" )
                    Endif

                    With _Screen
                        _Screen.Newobject( "oAppLogo", This.cAppLogoClass, This.cAppLogoClassLibrary )

                        .oAppLogo.Picture = This.cAppLogoSource

                        If _Screen.WindowState = 0
                            lnMiddle = Int( _Screen.Width / 2 )

                            If .oAppLogo.Left < lnMiddle
                                .oAppLogo.Anchor = 0
                                .oAppLogo.Left = lnMiddle + 12
                                .oAppLogo.Width = lnMiddle - 12 - 24
                                .oAppLogo.Anchor = ANCHOR_Bottom_Absolute + ANCHOR_Right_Absolute
                            Endif
                        Endif

                        .oAppLogo.ZOrder( 1 )
                        .oAppLogo.Visible = .T.

                        .MinHeight = Max( .MinHeight, .oAppLogo.Height + 48 )
                        .MinWidth = Max( .MinWidth, .oAppLogo.Width  + 48 )

                    Endwith

                Endif

            Catch To oErr
                Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

                loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

                loError.cRemark = "No es Posible Mostrar el Logo de la Aplicaci�n"
                loError.Process( oErr )
                Throw loError

            Finally

            Endtry

        Endwith

    Endproc

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: Destroy
    *!* Description...:
    *!* Date..........: Martes 12 de Septiembre de 2006 (20:33:31)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure Destroy(  ) As Void

        If Vartype( This.oMemoEdit ) = "O"
            If Vartype( This.oMemoEdit.oReport ) = "O"
                This.oMemoEdit.oReport.Destroy()
            Endif
            This.oMemoEdit.oReport = Null
            This.oMemoEdit = Null
        Endif

        Try
            If ! IsRuntime() And This.lOnDestroy
                Clear Memory
                FoxTabs()
                Do Tools\Varios\prg\SetPath.prg
                Do mnxPraxis.prg
                Do LiberarEntorno
            Endif && ! IsRuntime()

        Catch To oErr
            Do Tools\Varios\prg\SetPath.prg
            If ! IsRuntime() And This.lOnDestroy
                Clear Memory
                FoxTabs()
                Do mnxPraxis.prg
                Do LiberarEntorno
            Endif && ! IsRuntime()

        Finally

        Endtry

        DoDefault()

    Endproc && Destroy

    Procedure ClearInstances
        If Pemstatus( _Screen, "oAppLogo", 5 )
            _Screen.RemoveObject( "oAppLogo" )

        Endif && Pemstatus( _Screen, "oAppLogo", 5 )


        If Pemstatus( _Screen, "oFenixLogo", 5 )
            _Screen.RemoveObject( "oFenixLogo" )

        Endif && Pemstatus( _Screen, "oAppLogo", 5 )

        This.ClearGlobalApplicationPointer()


    Endproc


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: SetSystemMenu
    *!* Description...: Establece el menu del sistema
    *!* Date..........: Viernes 15 de Septiembre de 2006 (20:44:13)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure SetSystemMenu(  ) As Void;
            HELPSTRING "Establece el menu del sistema"

        Local lcCommand As String

        Try

            If !Empty( This.MenuSistema )
                This.oError.cRemark = "Menu Sistema"
                lcCommand = "DO " + Alltrim( This.MenuSistema )
                &lcCommand
            Endif

            If !Empty( This.MenuEdit )
                This.oError.cRemark = "Menu Edit"
                lcCommand = "DO " + Alltrim( This.MenuEdit )
                &lcCommand
            Endif


        Catch To oErr
            This.lIsOk = .F.
            This.cXMLoError=This.oError.Process( oErr )

        Finally

        Endtry


    Endproc
    *!*
    *!* END PROCEDURE SetSystemMenu
    *!*
    *!* ///////////////////////////////////////////////////////

    *
    *
    Procedure Login( lForce As Boolean ) As Boolean
        Local lcCommand As String
        Local llOk As Boolean
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg",;
            loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()

            TEXT To lcMsg NoShow TextMerge Pretext 03
            Visible: <<_Screen.Visible>>
            Top: <<_Screen.Top>>
            Left: <<_Screen.Left>>
            Height: <<_Screen.Height>>
            Width: <<_Screen.Width>>
            ENDTEXT

            *StrToFile( lcMsg, "Screen.txt" )

            _Screen.Left = 0
            _Screen.Top = 0
            _Screen.AutoCenter = .T.

            Do Form "FW\Comunes\Scx\frmLogin" To loUser
         
            If ( loUser.Cancela = .T. ) Or ( loUser.Id = 0 )
                loUser.lOk = .F.
            Endif

            loUser.lOk = loUser.lOk And This.ValidateModulo( loUser )

            This.oUser = loUser

            If loUser.lOk
                This.lLogin = .T.
                This.lDoLogin = !Empty( loUser.Nombre )
                This.lIsGuest = .F. && loUser.IsGuest

                If Vartype( Clave ) # "N"
                    Release Clave
                    Public Clave
                Endif

                Clave = This.oUser.Clave

                If Vartype( NivelDeAcceso ) # "N"
                    Release NivelDeAcceso
                    Public NivelDeAcceso
                Endif

                NivelDeAcceso = This.oUser.Nivel

                This.ObtenerPermisos()

                loGlobalSettings.cDescripcionEmpresaActiva 	= This.oUser.cDescripcionEmpresaActiva
                loGlobalSettings.cDescripcionSucursalActiva = This.oUser.cDescripcionSucursalActiva
                loGlobalSettings.nEmpresaActiva 		= This.oUser.nEmpresaActivaId
                loGlobalSettings.nEmpresaSucursalActiva = This.oUser.nSucursalActivaId


                Set Sysmenu Off
                Set Sysmenu To
                Set Sysmenu Automatic

                *!*	                This.Personalize()
                *!*	                This.SetApplicationMainCaption()
                *!*	                This.SetSystemMenu()
                *!*	                This.BuildMainMenu()
                *!*	                This.HookAfterBuildMainMenu()

                Try

                    _Screen.RemoveObject( "oScreenLog" )

                Catch To oErr

                Finally

                Endtry

                _Screen.AddObject( "oScreenLog", "cntScreenLog" )
                loScreenLog = _Screen.oScreenLog

                loScreenLog.AutoSize()

                loScreenLog.Top 	= _Screen.Height - loScreenLog.Height - 24
                loScreenLog.Left 	= 24
                loScreenLog.ZOrder( 0 )

                If _Screen.WindowState = 0
                    lnMiddle = Int( _Screen.Width / 2 )

                    If loScreenLog.Width > lnMiddle - 24 - 12
                        loScreenLog.Anchor 	= 0
                        loScreenLog.Width = lnMiddle - 12 - 24
                    Endif
                Endif

                loScreenLog.Anchor 	= ANCHOR_Left_Absolute + ANCHOR_Bottom_Absolute

                This.Personalize()
                This.SetApplicationMainCaption()
                This.SetSystemMenu()
                *This.BuildMainMenu()
                This.HookAfterBuildMainMenu()

                Do "FrontEnd\Prg\CambiarClienteActivo.prg" With loUser.nClientePraxis

                loScreenLog.Visible = .T.

                _Screen.MinHeight = Max( _Screen.MinHeight, loScreenLog.Height + 48 )
                _Screen.MinWidth = Max( _Screen.MinWidth, loScreenLog.Width + 48 )


            Else
                This.Logout()

            Endif



        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loUser = Null
            loGlobalSettings = Null

        Endtry

        Return llOk

    Endproc && Login


    *
    *
    Procedure ObtenerPermisos(  ) As Void
        Local lcCommand As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg",;
            loUsuario As oUsuario Of "Clientes\Archivos\prg\Usuario.prg"


        Try

            lcCommand = ""
            loUser = This.oUser
            loUsuario = GetEntity( "Usuario" )
            loRespuesta = loUsuario.GetByPK( loUser.Id )

            If loRespuesta.lOk

                loRegistro = loRespuesta.oRegistro

                loUser.lModificaActivo 		= loRegistro.Modifica_Activo
                loUser.lModificaOrden 		= loRegistro.Modifica_Orden
                loUser.lModificaEsSistema 	= loRegistro.Modifica_Es_Sistema
                loUser.lShowEditInBrowse 	= loRegistro.Muestra_Editar_En_Grilla

                This.BuildMainMenu( loRegistro.Menu )

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loUser = Null
            loUsuario = Null

        Endtry

    Endproc && ObtenerPermisos


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: Login
    *!* Description...: Loguea un usuario al sistema
    *!* Date..........: S�bado 26 de Mayo de 2007 (11:36:55)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure xxxLogin( tlForce As Boolean ) As Boolean;
            HELPSTRING "Loguea un usuario al sistema"

        Local lnClave As Integer
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
        Local loScreenLog As cntScreenLog Of Rutinas\vcx\clipper2fox.vcx
        Local llDoLogin As Boolean,;
            llVersion2 As Boolean

        Try

            This.oError.cRemark = ""

            *llDoLogin = .T.
            llDoLogin = .F.
            llVersion2 = .F.

            loGlobalSettings = NewGlobalSettings()

            Do Case
                Case Empty ( This.cUser ) Or tlForce

                    *!*				If Empty ( This.cUser ) Or tlForce

                    If  FileExist( "SetUp.cfg" )
                        loSetup = XmlToObject( Filetostr( "SetUp.cfg" ))

                        If Vartype( loSetup ) == "O"
                            If Pemstatus( loSetup, "lDoLogin", 5 )
                                llDoLogin = loSetup.lDoLogin
                            Endif
                            If !Pemstatus( loSetup, "nClientePraxis", 5 )
                                AddProperty( loSetup, "nClientePraxis", 0 )
                            Endif

                        Endif

                    Else
                        loSetup = Createobject( "Empty" )
                        AddProperty( loSetup, "nClientePraxis", 0 )
                        AddProperty( loSetup, "lDoLogin", llDoLogin )

                    Endif

                    This.lDoLogin = llDoLogin


                    If llDoLogin Or tlForce
                        This.lIsGuest = .F.

                        Do Form "FW\Comunes\Scx\frmLogin" To loUser

                        If ( loUser.Cancela = .T. ) Or ( loUser.Id = 0 )
                            loUser.lOk = .F.
                        Endif

                        loUser.lOk = loUser.lOk And This.ValidateModulo( loUser )

                    Else
                        *!*							This.oUser = Null
                        *!*							loUser = This.oUser
                        *!*							loUser.Usuario = "Guest"
                        *!*							loUser.GroupId = GRP_USUARIO
                        *!*							loUser.lOk = .T.

                        loUser = This.ValidarTerminal()
                        This.lIsGuest = ( loUser.GroupId = GRP_USUARIO )
                        loUser.lOk = loUser.lOk And This.ValidateModulo( loUser )

                        loGlobalSettings.nClientePraxis = loSetup.nClientePraxis


                        *Do "FrontEnd\Prg\CambiarClienteActivo.prg" With loSetup.nClientePraxis

                    Endif

                    *!*				Else

                Case Val( This.cUser ) < 0
                    *!*						This.lIsGuest = .T.

                    *!*						This.oUser = Null
                    *!*						loUser = This.oUser
                    *!*						loUser.Usuario = "Guest"
                    *!*						loUser.GroupId = GRP_USUARIO
                    *!*						loUser.lOk = .T.

                    loUser = This.ValidarTerminal()
                    This.lIsGuest = ( loUser.GroupId = GRP_USUARIO )
                    loUser.lOk = loUser.lOk And This.ValidateModulo( loUser )


                Case Val( This.cUser ) > 0
                    * RA 2014-03-29(14:49:24)
                    * Versi�n 2.0
                    * Recibe por parametro, en vez del nombre del archivo de configuracion
                    * el Id del usuario

                    llVersion2 = .T.

                    This.oUser = Null
                    loUser = This.oUser

                    loUser = loUser.GetById( Val( This.cUser ) )

                    loUser.lOk = loUser.lOk And This.ValidateModulo( loUser )

                Otherwise

                    Try
                        loUser = XmlToObject( Filetostr( This.cUser ))
                        If !Pemstatus( loUser, "IsGuest", 5 )
                            AddProperty( loUser, "IsGuest", .F. )

                            If Empty( loUser.Nombre )
                                loUser.IsGuest = .T.
                            Endif
                        Endif

                        If !Pemstatus( loUser, "Permiso", 5 )
                            AddProperty( loUser, "Permiso", loUser.Nivel )
                        Endif

                        If !Pemstatus( loUser, "GroupId", 5 )
                            AddProperty( loUser, "GroupId", Iif( loUser.Nivel = 5, GRP_ADMIN, GRP_USUARIO ) )
                        Endif

                        If !Pemstatus( loUser, "Grupo", 5 )
                            AddProperty( loUser, "Grupo", "" )
                        Endif

                        If !Pemstatus( loUser, "IsImplementador", 5 )
                            AddProperty( loUser, "IsImplementador", .F. )
                        Endif

                        If !Pemstatus( loUser, "IsAdmin", 5 )
                            AddProperty( loUser, "IsAdmin", .F. )
                        Endif

                        loUser.lOk = loUser.lOk And This.ValidateModulo( loUser )

                    Catch To oErr
                        This.lIsGuest = .F.

                        Do Form "FW\Comunes\Scx\frmLogin" To loUser

                        If loUser.Cancela = .T.
                            loUser.lOk = .F.
                        Endif

                        loUser.lOk = loUser.lOk And This.ValidateModulo( loUser )

                    Finally

                    Endtry

                    *!*				Endif
            Endcase

            If loUser.lOk = .T.


                Try

                    TEXT To lcCommand NoShow TextMerge Pretext 15
					Select *
						From <<DRCOMUN>>Grupos g
						Where g.Id = <<loUser.GroupId>>
						Into Cursor cGrupo
                    ENDTEXT

                    &lcCommand

                    If _Tally = 1
                        loUser.Grupo = cGrupo.Nombre

                    Else
                        loUser.Grupo = ""

                    Endif

                Catch To oErr
                    loUser.Grupo = ""

                    Logerror( oErr )

                Finally

                Endtry


                Try

                    TEXT To lcCommand NoShow TextMerge Pretext 15
					Select *
						From <<DRCOMUN>>Usuarios u
						Where u.Id = <<loUser.Id>>
						Into Cursor cUsuario
                    ENDTEXT

                    &lcCommand


                    If _Tally = 1
                        If !loUser.IsImplementador
                            If !Empty( Field( "Implementa", "cUsuario" ))
                                If cUsuario.Implementa = 1
                                    loUser.IsImplementador = .T.
                                Endif
                            Endif
                        Endif


                    Endif

                Catch To oErr
                    Logerror( oErr )

                Finally
                    Use In Select( "cGrupo" )
                    Use In Select( "Grupos" )
                    Use In Select( "cUsuario" )
                    Use In Select( "Usuarios" )

                Endtry


                * RA 2013-03-22(11:03:57)
                * A veces vienen FALSE y TRUE como 0 y 1 (lo cual es correcto para el framework)
                * pero en Clipper2Fox se utilizan booleanos

                If Vartype( loUser.IsActive ) = "N"
                    loUser.IsActive = Iif( loUser.IsActive = 0, .F., .T. )
                Endif

                If Vartype( loUser.IsAdmin ) = "N"
                    loUser.IsAdmin = Iif( loUser.IsAdmin = 0, .F., .T. )
                Endif

                If Vartype( loUser.IsGuest ) = "N"
                    loUser.IsGuest = Iif( loUser.IsGuest = 0, .F., .T. )
                Endif

                If Vartype( loUser.IsSystem ) = "N"
                    loUser.IsSystem = Iif( loUser.IsSystem = 0, .F., .T. )
                Endif

                If Vartype( loUser.lIsOk ) = "N"
                    loUser.lIsOk = Iif( loUser.lIsOk = 0, .F., .T. )
                Endif

                This.oUser.IsAdmin 			= loUser.IsAdmin
                This.oUser.IsGuest 			= loUser.IsGuest
                This.oUser.Descripcion 		= loUser.Usuario
                This.oUser.nEmpresaActivaId = loUser.nEmpresaActivaId
                This.oUser.Nivel 			= loUser.Nivel
                This.oUser.Clave 			= loUser.Permiso
                This.oUser.Permiso 			= loUser.Permiso
                This.oUser.GroupId 			= loUser.GroupId
                This.oUser.Grupo			= loUser.Grupo
                This.oUser.Nombre 			= loUser.Nombre
                This.oUser.Password 		= loUser.Password
                This.oUser.Id				= loUser.Id
                This.oUser.IsAdmin			= loUser.IsAdmin
                This.oUser.IsImplementador	= loUser.IsImplementador


                This.lLogin = .T.
                This.lDoLogin = !Empty( loUser.Nombre )
                This.lIsGuest = loUser.IsGuest

                If Vartype( Clave ) # "N"
                    Release Clave
                    Public Clave
                Endif

                Clave = This.oUser.Clave

                * RA 2014-03-30(12:12:14)
                * Este bloque se  reemplaza con This.ValidateModulo()
                If .F.
                    * RA 2012-06-12(19:09:10)
                    * Validar contra los permisos otorgados en Modulos.dbf

                    If FileExist( Addbs( Alltrim( DRCOMUN )) + "Modulos.dbf" )
                        TEXT To lcCommand NoShow TextMerge Pretext 15
					Select *
						From <<Addbs( Alltrim( DRCOMUN ))>>Modulos.dbf
						Where Upper( Alltrim( Nombre )) = "<<Upper( This.cApplicationName )>>"
						Into Cursor cModulo
                        ENDTEXT

                        &lcCommand

                        If !Empty( _Tally ) And Type( "cModulo.Permiso" ) == "N"
                            * RA 2012-06-12(19:31:28)
                            * Si CLAVE es menor que el umbral de Permiso, CLAVE = 0
                            If Clave < cModulo.Permiso
                                Clave = 0
                            Endif
                        Endif

                        Use In Select( "cModulo" )

                    Endif
                Endif

                If Vartype( NivelDeAcceso ) # "N"
                    Release NivelDeAcceso
                    Public NivelDeAcceso
                Endif

                NivelDeAcceso = This.oUser.Nivel

                If Clave > 0
                    * If Empty( Adir( laDir, Addbs( Alltrim( DRVD )) + "xx*.dbf" ))
                    If !FileExist( Addbs( Alltrim( DRVD )) + "*.dbf" )
                        Clave = 0
                    Endif
                Endif

                Set Sysmenu Off
                Set Sysmenu To
                Set Sysmenu Automatic

                This.Personalize()
                This.SetApplicationMainCaption()
                This.SetSystemMenu()
                This.BuildMainMenu()
                This.HookAfterBuildMainMenu()

                Try

                    _Screen.RemoveObject( "oScreenLog" )

                Catch To oErr

                Finally

                Endtry

                _Screen.AddObject( "oScreenLog", "cntScreenLog" )
                loScreenLog = _Screen.oScreenLog

                loScreenLog.AutoSize()

                *!*	                loScreenLog.lblEmpresa.Caption  = This.cEmpresa
                *!*	                loScreenLog.lblUsuario.Caption  = loUser.Nombre
                *!*	                loScreenLog.lblGrupo.Caption 	= loUser.Grupo

                *!*	                If Empty( loScreenLog.lblUsuario.Caption )
                *!*	                    loScreenLog.Collapse()

                *!*	                Else
                *!*	                    loScreenLog.Expand()

                *!*	                Endif

                loScreenLog.Top 	= _Screen.Height - loScreenLog.Height - 24
                loScreenLog.Left 	= 24
                loScreenLog.ZOrder( 0 )

                If _Screen.WindowState = 0
                    lnMiddle = Int( _Screen.Width / 2 )

                    If loScreenLog.Width > lnMiddle - 24 - 12
                        loScreenLog.Anchor 	= 0
                        loScreenLog.Width = lnMiddle - 12 - 24
                    Endif
                Endif

                loScreenLog.Anchor 	= ANCHOR_Left_Absolute + ANCHOR_Bottom_Absolute

                Do "FrontEnd\Prg\CambiarClienteActivo.prg" With loGlobalSettings.nClientePraxis

                loScreenLog.Visible = .T.

                _Screen.MinHeight = Max( _Screen.MinHeight, loScreenLog.Height + 48 )
                _Screen.MinWidth = Max( _Screen.MinWidth, loScreenLog.Width + 48 )


            Else
                This.Logout()

            Endif


        Catch To oErr
            This.lIsOk = .F.
            This.cXMLoError=This.oError.Process( oErr )

        Finally
            loScreenLog = Null

        Endtry


        Return This.lIsOk
    Endproc
    *!*
    *!* END PROCEDURE xxxLogin
    *!*
    *!* ///////////////////////////////////////////////////////


    Procedure ValidateModulo( oUser As Object )
        Local llValid As Boolean
        Local lcParameFileName As String
        Local lcRootWorkFolder As String
        Local lcCommand As String
        Local lnNivel As Integer
        Local lcAplicacion As String

        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"

        Local llActivo As Boolean

        Try

            lcCommand = ""

            llValid = .T.

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally
            Use In Select( "Modulos" )
            Use In Select( "cModulos" )
            loUser 	= Null
            oUser 	= Null

        Endtry

        Return llValid
    Endproc




    *
    * Permite definir la terminal como un usuario,
    * en caso que la opci�n de pedir login est� deshabilitada
    Procedure ValidarTerminal(  ) As Object ;
            HELPSTRING "Permite definir la terminal como un usuario, ;
        en caso que la opci�n de pedir login est� deshabilitada"

        Local lcCommand As String,;
            lcTerminal As String

        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"


        Try

            lcCommand = ""
            lcTerminal = Alltrim( Getwordnum( Sys(0), 1, "#" ))

            This.oUser = Null

            loUser 			= This.oUser
            loUser.Usuario 	= "Guest"
            loUser.GroupId 	= GRP_USUARIO
            loUser.lOk 		= .T.

            *!*				M_Use( 0, Alltrim( DRCOMUN ) + 'Usuarios' )
            *!*				Select Usuarios
            *!*				Locate For Upper( Padr( lcTerminal, 40 )) == Padr( Upper( Alltrim( Usuario )), 40 )

            *!*				If Found()
            *!*					loUser.Id		= Usuarios.Id
            *!*					loUser.Usuario 	= Usuarios.Usuario
            *!*					loUser.Nivel 	= Usuarios.Nivel
            *!*					loUser.Permiso 	= Usuarios.Permiso
            *!*					loUser.GroupId 	= Usuarios.GroupId
            *!*					loUser.Nombre 	= Alltrim( Usuarios.Nombre )
            *!*					loUser.IsAdmin 	= ( Usuarios.Nivel = 5 )
            *!*					loUser.IsGuest 	= .F.
            *!*					loUser.Password = Usuarios.Clave
            *!*					loUser.lOk 		= .T.

            *!*				Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            Use In Select( 'Usuarios' )

        Endtry

        Return loUser

    Endproc && ValidarTerminal


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: Logout
    *!* Description...: Loguea un usuario al sistema
    *!* Date..........: S�bado 26 de Mayo de 2007 (11:36:55)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure Logout(  ) As Boolean;
            HELPSTRING "Loguea un usuario al sistema"

        Try

            Try

                _Screen.RemoveObject( "oScreenLog" )

            Catch To oErr

            Finally

            Endtry

            This.oUser.lOk 			= .F.
            This.oUser.IsAdmin 		= .F.
            This.oUser.IsGuest 		= .F.
            This.oUser.IsImplementador = .F.
            This.oUser.Descripcion 	= "Ning�n Usuario Registrado"
            This.oUser.nEmpresaActivaId = 0
            This.lLogin 		= .F.
            This.oUser.Clave 	= 0
            This.oUser.Nivel 	= 0
            This.oUser.GroupId 	= 0
            This.cUser 			= ""

            Set Sysmenu Off
            Set Sysmenu To
            Set Sysmenu Automatic

            If This.lIsOk
                This.SetApplicationMainCaption()
                This.SetSystemMenu()
            Endif

            If !This.lDoLogin
                *This.Login()
            Endif


        Catch To oErr
            This.lIsOk = .F.
            This.cXMLoError=This.oError.Process( oErr )

        Finally

        Endtry


        Return This.lIsOk
    Endproc
    *!*
    *!* END PROCEDURE Login
    *!*
    *!* ///////////////////////////////////////////////////////




    *!*		*
    *!*		* Personaliza la fuente a utilizarse
    *!*		Procedure FontLayout(  ) As Void;
    *!*				HELPSTRING "Personaliza la fuente a utilizarse"

    *!*			Local loSetup As Object
    *!*			Local lcFontLayout As String
    *!*			Local lcFontName As String
    *!*			Local lnFontSize As Integer
    *!*			Local lcFontStyle As String
    *!*			Local lnFontCharSet As Integer

    *!*			Try

    *!*				This.oError.cRemark = ""

    *!*				lcFontName 		= This.FontName
    *!*				lnFontSize 		= This.FontSize
    *!*				lcFontStyle 	= This.FontStyle
    *!*				lnFontCharSet 	= This.FontCharSet

    *!*				If  FileExist( "SetUp.cfg" )
    *!*					loSetup = XmlToObject( Filetostr( "SetUp.cfg" ))

    *!*					If Vartype( loSetup ) == "O"
    *!*						If !Pemstatus( loSetup, "FontSize", 5 )
    *!*							AddProperty( loSetup, "FontName", lcFontName )
    *!*							AddProperty( loSetup, "FontSize", lnFontSize )
    *!*							AddProperty( loSetup, "FontStyle", lcFontStyle )
    *!*							AddProperty( loSetup, "FontCharSet", lnFontCharSet )

    *!*						Else
    *!*							lcFontName		= loSetup.FontName
    *!*							lnFontSize  	= loSetup.FontSize
    *!*							lcFontStyle  	= loSetup.FontStyle
    *!*							lnFontCharSet	= loSetup.FontCharSet

    *!*						Endif

    *!*					Endif

    *!*				Else
    *!*					loSetup = CreateObjParam( "FontName", lcFontName,;
    *!*						"FontSize", lnFontSize,;
    *!*						"FontStyle", lcFontStyle,;
    *!*						"FontCharSet", lnFontCharSet )

    *!*				Endif

    *!*				lcFontLayout = Getfont( lcFontName, lnFontSize, lcFontStyle, lnFontCharSet )

    *!*				If !Empty( lcFontLayout )
    *!*					lcFontName 		= Getwordnum( lcFontLayout, 1, "," )
    *!*					lnFontSize 		= Int( Val( Getwordnum( lcFontLayout, 2, "," )))
    *!*					lcFontStyle 	= Getwordnum( lcFontLayout, 3, "," )
    *!*					lnFontCharSet 	= Int( Val( Getwordnum( lcFontLayout, 1, "," )))

    *!*					loSetup.FontName 	= lcFontName
    *!*					loSetup.FontSize 	= lnFontSize
    *!*					loSetup.FontStyle 	= lcFontStyle
    *!*					loSetup.FontCharSet = lnFontCharSet

    *!*					Strtofile( ObjectToXml( loSetup ), "SetUp.cfg" )

    *!*					This.FontName 		= lcFontName
    *!*					This.FontSize 		= lnFontSize
    *!*					This.FontStyle 		= lcFontStyle
    *!*					This.FontCharSet 	= lnFontCharSet
    *!*				Endif

    *!*			Catch To oErr
    *!*				This.lIsOk = .F.
    *!*				This.cXMLoError=This.oError.Process( oErr )

    *!*			Finally

    *!*			Endtry


    *!*			Return This.lIsOk

    *!*		Endproc && FontLayout


    Procedure oUser_Access(  ) As Object;
            HELPSTRING "Creaci�n del objeto On Demmand"

        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"

        Try

            If Vartype(This.oUser)#"O"

                loUser = Newobject( "User", "Fw\TierAdapter\Comun\prxUser.prg" )

                loUser.Descripcion 			= ""
                loUser.Nombre 				= ""
                loUser.IsAdmin 				= .F.
                loUser.nEmpresaActivaId 	= 0
                loUser.nEjercicioActivoId 	= 0
                loUser.Password 			= ""
                loUser.Clave 				= 0
                loUser.Nivel 				= 0
                loUser.Permiso 				= 0
                loUser.GroupId 				= 0
                loUser.lOk 					= .F.
                loUser.Id 					= 0
                loUser.IsAdmin 				= .F.
                loUser.IsImplementador 		= .F.

                This.oUser = loUser

            Endif


        Catch To oErr
            This.lIsOk = .F.
            This.cXMLoError=This.oError.Process( oErr )
            Throw This.oError

        Finally
            loUser = Null

        Endtry

        Return This.oUser

    Endproc


    *
    *
    Procedure SetGlobales(  ) As Void
        Local lcCommand As String

        Try

            Clear Memory
            
            Public 	ASTERISCO
            ASTERISCO	= .T.

            Note: Asignacion de valores Ascii

            Public Cero,Uno,Dos,Tres,Cuatro,Mas,Menos,Enter,Escape,PgUp,PgDn,CtrlPgUp,;
                CtrlPgDn,Space,Back,Abajo,Arriba,Fin,Hogar,F2,F3,F4,F5,F6,F7,F8,F9,F10,;
                Izquierda,Cinco,F1,F11,F12,Derecha,ShiftTab,TabKey

            Cero		= 48
            Uno			= 49
            Dos			= 50
            Tres		= 51
            Cuatro		= 52
            Cinco		= 53

            Mas			= 43
            Menos		= 45

            Enter		= 13
            Escape		= 27
            PgUp		= 18
            PgDn		= 03
            CtrlPgUp	= 31
            CtrlPgDn	= 30
            Space		= 32
            Back		= 08
            Abajo		= 24
            Arriba		= 05
            Fin			= 06
            Hogar		= 01
            F1			= 28
            F2			=-01
            F3			=-02
            F4			=-03
            F5			=-04
            F6			=-05
            F7			=-06
            F8			=-07
            F9			=-08
            F10			=-09
            F11			=133
            F12			=134
            Izquierda	= 19
            Derecha		= 04
            TabKey		= 09
            ShiftTab	= 15

            *!*	* Colores
            Public CL_NORMAL, CL_BORDER, CL_CHOICE, CL_LINE00, CL_LINE01, CL_LINE21, CL_LINE22, CL_LINE23, CL_LINE24, CL_RESALT, CL_TITULO,;
                CL_SELECTED, CL_UNSELECTED, CL_USUARIO

            CL_NORMAL 		= "CL_NORMAL"
            CL_BORDER 		= "CL_BORDER"
            CL_CHOICE 		= "CL_CHOICE"
            CL_LINE00 		= "CL_LINE00"
            CL_LINE01 		= "CL_LINE01"
            CL_LINE21 		= "CL_LINE21"
            CL_LINE22 		= "CL_LINE22"
            CL_LINE23 		= "CL_LINE23"
            CL_LINE24 		= "CL_LINE24"
            CL_RESALT 		= "CL_RESALT"
            CL_TITULO 		= "CL_TITULO"
            CL_SELECTED 	= "CL_SELECTED"
            CL_UNSELECTED 	= "CL_UNSELECTED"
            CL_USUARIO		= "CL_USUARIO"

            Public gcBackColor, gcForeColor, gcGetBackColor, gcGetForeColor
            gcBackColor 	= CLR_BackColor
            gcForeColor 	= CLR_ForeColor
            gcGetBackColor 	= CLR_GetBackColor
            gcGetForeColor 	= CLR_GetForeColor


	        Note: Pasaje de numeros a letras

            Public Array Uni[19],Dec[9],Cen[9]
            Uni[01]	= 'un '
            Uni[02]	= 'dos '
            Uni[03]	= 'tres '
            Uni[04]	= 'cuatro '
            Uni[05]	= 'cinco '
            Uni[06]	= 'seis '
            Uni[07]	= 'siete '
            Uni[08]	= 'ocho '
            Uni[09]	= 'nueve '
            Uni[10]	= 'diez '
            Uni[11]	= 'once '
            Uni[12]	= 'doce '
            Uni[13]	= 'trece '
            Uni[14]	= 'catorce '
            Uni[15]	= 'quince '
            Uni[16]	= 'dieciseis '
            Uni[17]	= 'diecisiete '
            Uni[18]	= 'dieciocho '
            Uni[19]	= 'diecinueve '
            Dec[03]	= 'treinta '
            Dec[04]	= 'cuarenta '
            Dec[05]	= 'cincuenta '
            Dec[06]	= 'sesenta '
            Dec[07]	= 'setenta '
            Dec[08]	= 'ochenta '
            Dec[09]	= 'noventa '
            Cen[02]	= 'doscientos '
            Cen[03]	= 'trescientos '
            Cen[04]	= 'cuatrocientos '
            Cen[05]	= 'quinientos '
            Cen[06]	= 'seiscientos '
            Cen[07]	= 'setecientos '
            Cen[08]	= 'ochocientos '
            Cen[09]	= 'novecientos '


            Public Aborta,Confirma

            Aborta		= 'prxAborta()'
            Confirma	= 'prxConfirma()'


            Public FechaHoy,Lastdate
            FechaHoy 	= Date()
            Set Date French
            Lastdate={^2079/12/31}

            Do LoadNamespace In Tools\Namespaces\prg\LoadNamespace.prg
            


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
        Close Databases all 

        Endtry

    Endproc && SetGlobales



    *
    * Setea las variables p�blicas
    Procedure xxxSetGlobales(  ) As Void;
            HELPSTRING "Setea las variables p�blicas"



        Try

            Clear Memory

            Public False,True,Spaces,Page,Line,Null,Lastdate

            False	= .F.
            True	= .T.
            Spaces	= Space(80)
            Page	= 0
            Line	= 0
            Null	= ''

            Set Date French
            Lastdate={^2079/12/31}

            Public 	DEMO, ASTERISCO

            DEMO		= .F.
            ASTERISCO	= .T.


            Note: Asignacion de valores Ascii

            Public Cero,Uno,Dos,Tres,Cuatro,Mas,Menos,Enter,Escape,PgUp,PgDn,CtrlPgUp,;
                CtrlPgDn,Space,Back,Abajo,Arriba,Fin,Hogar,F2,F3,F4,F5,F6,F7,F8,F9,F10,;
                Izquierda,Cinco,F1,F11,F12,Derecha,ShiftTab,TabKey

            Cero		= 48
            Uno			= 49
            Dos			= 50
            Tres		= 51
            Cuatro		= 52
            Cinco		= 53

            Mas			= 43
            Menos		= 45

            Enter		= 13
            Escape		= 27
            PgUp		= 18
            PgDn		= 03
            CtrlPgUp	= 31
            CtrlPgDn	= 30
            Space		= 32
            Back		= 08
            Abajo		= 24
            Arriba		= 05
            Fin			= 06
            Hogar		= 01
            F1			= 28
            F2			=-01
            F3			=-02
            F4			=-03
            F5			=-04
            F6			=-05
            F7			=-06
            F8			=-07
            F9			=-08
            F10			=-09
            F11			=133
            F12			=134
            Izquierda	= 19
            Derecha		= 04
            TabKey		= 09
            ShiftTab	= 15

            Note: Generacion de mensajes de opciones

            Public Msg1,Msg2,Msg3,Msg4,Msg5,Msg6,Msg7,Msg8,Msg9,Msg10,Msg10,Msg11,Msg12,;
                Msg13,Msg14,Msg15,Msg16,Msg17,Msg18,Msg19,Msg20,Msg21,Msg21,Msg22,;
                Msg23,Msg24,Msg25,Msg26,Msg27,Msg28,Msg29,Msg30

            Msg1	='[1]:Elimina [2]:Modifica [Enter]:Clave [Arriba]:Cla Ant [Abajo]:Cla Sig [Esc]'
            Msg2	='[Enter]:Confirma               [Esc]:No confirma'
            Msg3	='[Abajo]:Sig [Arriba]:Ant [PgDn]:Pan.Sig [PgUp]:Pan.Ant [F9]:Inicio [F10]:Final'
            Msg4	='[Enter]:Siguiente dato    [Pg Up]:Anterior    [Pg Dn]:Ultimo    [Esc]:Opciones'
            Msg5	='[Enter]:Dato siguiente        [Arriba]:Dato anterior        [Esc]:Interrumpe'
            Msg6	='[Enter]:Confirma          [Esc]:No confirma          [2]:Modifica'
            Msg7	='[1]:Elimina [2]:Modifica [3]:Agrega [4]:Recupera [F3]:Cancelar'
            Msg8	='[Esc]:Menu'
            Msg9	='[1]:Por Clave                  [2]:Alfabetico'
            Msg10	='[Enter]:Confirma dato               [Esc]:Menu'
            Msg11	='[Abajo]: Item siguiente      [Arriba]: Item anterior      [Enter]: Item elegido'
            Msg12	='[Esc]:Interrumpe impresion'
            Msg13	='[Esc]:Fin'
            Msg14	='Procesando'
            Msg15	='[Enter]:Confirma dato'
            Msg16	='[Enter]:Sig [Retr]:Ant [PgDn]:Pan.Sig [PgUp]:Pan.Ant [^PgDn]:Fin [^PgUp]:Inicio'
            Msg17	='[Enter]:Dato siguiente   [Arriba]:Anterior   [Pg Dn]:Ultimo   [Esc]:Interrumpe'
            Msg18	='[Enter]:Confirma dato               [Esc]:Opciones'
            Msg19	='[Enter]:Confirma e imprime   [F10]:Confirma y no imprime   [Esc]:No confirma'
            Msg20	='Ingrese el codigo o blancos para busqueda alfabetica'
            Msg21	='Ingrese el nombre o blancos para busqueda por codigo'
            Msg22	='Ingrese la descripcion o blancos para busqueda por codigo'
            Msg23	='[+]:Siguiente        [-]:Anterior        [F9]:Inicio         [F10]:Final'
            Msg24	='[S]:Si               [N]:No'
            Msg25	='[Enter]:Clave         [-]:Cla Ant         [+]:Cla Sig         [Esc]:Fin'
            Msg26	='[Enter]:Dato siguiente        [Arriba]:Dato anterior        [Esc]:Interrumpe'
            Msg27	='[Enter]:Modifica [Flechas] [PgUp] [PgDn] [Home] [End] [^PgUp] [^PgDn] [Esc]:Fin'
            Msg28	='[1]:Elimina [2]:Modifica [0]:Est [Enter]:Clave [-]:C. Ant [+]:C. Sig [Esc]:Fin'
            Msg29	='[Enter]:Mod.[Flechas] [PgUp] [PgDn] [Home] [End] [^PgUp] [^PgDn] [0]:Est [Esc]'
            Msg30	='[Enter]:Ingresa comprobante                    [Esc]:Menu'


            Note: Generacion de mensajes aclaratorios

            Public Acl1,Acl2,Acl3,Acl4,Acl5,Acl6,Acl7,Acl8,Acl9,Acl10,Acl11,Acl12,Acl13

            Acl1	= 'Oprima la tecla correspondiente a su opcion'
            Acl2	= 'Verifique que la impresora se encuentre ENCENDIDA y ON LINE'
            Acl3	= 'Digite el numero correspondiente a su opcion o Esc para finalizar'
            Acl4	= 'Ingrese clave inicial o blancos para listar todo el archivo'
            Acl5	= 'Ingrese clave final o blancos para repetir clave inicial'
            Acl6	= 'Ingrese la fecha en formato DD/MM/AA'
            Acl7	= 'Ingrese clave inicial o cero para listar todo el archivo'
            Acl8	= 'Ingrese clave final o cero para repetir clave inicial'
            Acl9	= 'Digite su opcion o Esc para volver al Menu del sistema'
            Acl10	= 'Digite la letra correspondiente a su opcion o Esc para finalizar'
            Acl11	= '[1]:Inscripto    [2]:Consumidor Final    [3]:Exento    [4]:No Responsable'
            Acl12	= '[1]:Resp.Inscripto  [2]:Cons.Final  [3]:No Respons.  [4]:Respons. No Insc'
            Acl13	= '[1]:Resp.Inscr. [2]:Cons.Final  [3]:No Resp.  [4]:Resp. No Insc  [5]:Exento'

            Note: Generacion de mensajes de Error

            Public Err1,Err2,Err3,Err4,Err5,Err6

            Err1	= 'Codigo ya ingresado'
            Err2	= 'Dato invalido, ingreselo nuevamente'
            Err3	= 'Codigo inexistente, ingreselo nuevamente'
            Err4	= 'Codigo existente, ingreselo nuevamente'
            Err5	= 'Codigo dado de baja'

            TEXT To Err6 NoShow TextMerge Pretext 03
			No existen registros
			para el rango especificado
            ENDTEXT

            *!*	* Colores
            Public CL_NORMAL, CL_BORDER, CL_CHOICE, CL_LINE00, CL_LINE01, CL_LINE21, CL_LINE22, CL_LINE23, CL_LINE24, CL_RESALT, CL_TITULO,;
                CL_SELECTED, CL_UNSELECTED, CL_USUARIO

            CL_NORMAL 		= "CL_NORMAL"
            CL_BORDER 		= "CL_BORDER"
            CL_CHOICE 		= "CL_CHOICE"
            CL_LINE00 		= "CL_LINE00"
            CL_LINE01 		= "CL_LINE01"
            CL_LINE21 		= "CL_LINE21"
            CL_LINE22 		= "CL_LINE22"
            CL_LINE23 		= "CL_LINE23"
            CL_LINE24 		= "CL_LINE24"
            CL_RESALT 		= "CL_RESALT"
            CL_TITULO 		= "CL_TITULO"
            CL_SELECTED 	= "CL_SELECTED"
            CL_UNSELECTED 	= "CL_UNSELECTED"
            CL_USUARIO		= "CL_USUARIO"

            Public gcBackColor, gcForeColor, gcGetBackColor, gcGetForeColor
            gcBackColor 	= CLR_BackColor
            gcForeColor 	= CLR_ForeColor
            gcGetBackColor 	= CLR_GetBackColor
            gcGetForeColor 	= CLR_GetForeColor


            * RA 05/09/2021(18:27:19)
            * Provisorio

            * Meses

            Public Array Meses[12]
            Meses[01]	= 'Enero     '
            Meses[02]	= 'Febrero   '
            Meses[03]	= 'Marzo     '
            Meses[04]	= 'Abril     '
            Meses[05]	= 'Mayo      '
            Meses[06]	= 'Junio     '
            Meses[07]	= 'Julio     '
            Meses[08]	= 'Agosto    '
            Meses[09]	= 'Septiembre'
            Meses[10]	= 'Octubre   '
            Meses[11]	= 'Noviembre '
            Meses[12]	= 'Diciembre '

            * Dias

            Public Array Dias[7]
            Dias[01]	= 'Domingo  '
            Dias[02]	= 'Lunes    '
            Dias[03]	= 'Martes   '
            Dias[04]	= 'Mi�rcoles'
            Dias[05]	= 'Jueves   '
            Dias[06]	= 'Viernes  '
            Dias[07]	= 'S�bado   '

            Public Array Zonas[ 24 ]
            Zonas[01]	= 'Capital Federal    '
            Zonas[02]	= 'Buenos Aires       '
            Zonas[03]	= 'Catamarca          '
            Zonas[04]	= 'Cordoba            '
            Zonas[05]	= 'Corrientes         '
            Zonas[06]	= 'Chaco              '
            Zonas[07]	= 'Chubut             '
            Zonas[08]	= 'Entre Rios         '
            Zonas[09]	= 'Formosa            '
            Zonas[10]	= 'Jujuy              '
            Zonas[11]	= 'La Pampa           '
            Zonas[12]	= 'La Rioja           '
            Zonas[13]	= 'Mendoza            '
            Zonas[14]	= 'Misiones           '
            Zonas[15]	= 'Neuquen            '
            Zonas[16]	= 'Rio Negro          '
            Zonas[17]	= 'Salta              '
            Zonas[18]	= 'San Juan           '
            Zonas[19]	= 'San Luis           '
            Zonas[20]	= 'Santa Cruz         '
            Zonas[21]	= 'Santa Fe           '
            Zonas[22]	= 'Santiago del Estero'
            Zonas[23]	= 'Tierra del Fuego   '
            Zonas[24]	= 'Tucuman            '

            Public FechaHoy
            FechaHoy 	= Date()

            Public Array Ivas[9],Insc[9],Alicuotas[9]
            Ivas[1]	= 'Resp. inscrip.'
            Ivas[2]	= 'A Cons. Final '
            Ivas[3]	= 'No Informado'
            Ivas[4]	= 'Resp. no insc.'
            Ivas[5]	= 'Exento        '
            Ivas[6]	= 'No Ins. B. Uso'
            Ivas[7]	= 'Res. Monotrib.'
            Ivas[8]	= 'Res. No Categ.'
            Ivas[9]	= 'Otra          '

            Insc[1]	= 'RI'
            Insc[2]	= 'CF'
            *Insc[3]	= 'NA'
            Insc[3]	= 'Ni'
            Insc[4]	= 'NI'
            Insc[5]	= 'EX'
            Insc[6]	= "BU"
            Insc[7]	= 'RM'
            Insc[8]	= 'NC'
            Insc[9]	= '  '

            Alicuotas[1] = 00.00
            Alicuotas[2] = 00.00
            Alicuotas[3] = 00.00
            Alicuotas[4] = 10.50
            Alicuotas[5] = 21.00
            Alicuotas[6] = 27.00
            Alicuotas[7] = 00.00
            Alicuotas[8] = 05.00
            Alicuotas[9] = 02.50

            Public Array Provincias_Afip[ 25 ]
            * RA 06/08/2016(13:28:22)
            * Es lo que devuelve 'https://soa.afip.gob.ar/parametros/v1/provincias'
            * en idProvincia + 1 (Porque es base 0 )

            Provincias_Afip[01]	= 01
            Provincias_Afip[02]	= 02
            Provincias_Afip[03]	= 03
            Provincias_Afip[04]	= 04
            Provincias_Afip[05]	= 05
            Provincias_Afip[06]	= 08
            Provincias_Afip[07]	= 10
            Provincias_Afip[08]	= 13
            Provincias_Afip[09]	= 12
            Provincias_Afip[10]	= 17
            Provincias_Afip[11]	= 18
            Provincias_Afip[12]	= 19
            Provincias_Afip[13]	= 21
            Provincias_Afip[14]	= 22
            Provincias_Afip[15]	= 24
            Provincias_Afip[16]	= 00
            Provincias_Afip[17]	= 06
            Provincias_Afip[18]	= 07
            Provincias_Afip[19]	= 09
            Provincias_Afip[20]	= 14
            Provincias_Afip[21]	= 15
            Provincias_Afip[22]	= 11
            Provincias_Afip[23]	= 16
            Provincias_Afip[24]	= 20
            Provincias_Afip[25]	= 23


            Note: Pasaje de numeros a letras

            Public Array Uni[19],Dec[9],Cen[9]
            Uni[01]	= 'un '
            Uni[02]	= 'dos '
            Uni[03]	= 'tres '
            Uni[04]	= 'cuatro '
            Uni[05]	= 'cinco '
            Uni[06]	= 'seis '
            Uni[07]	= 'siete '
            Uni[08]	= 'ocho '
            Uni[09]	= 'nueve '
            Uni[10]	= 'diez '
            Uni[11]	= 'once '
            Uni[12]	= 'doce '
            Uni[13]	= 'trece '
            Uni[14]	= 'catorce '
            Uni[15]	= 'quince '
            Uni[16]	= 'dieciseis '
            Uni[17]	= 'diecisiete '
            Uni[18]	= 'dieciocho '
            Uni[19]	= 'diecinueve '
            Dec[03]	= 'treinta '
            Dec[04]	= 'cuarenta '
            Dec[05]	= 'cincuenta '
            Dec[06]	= 'sesenta '
            Dec[07]	= 'setenta '
            Dec[08]	= 'ochenta '
            Dec[09]	= 'noventa '
            Cen[02]	= 'doscientos '
            Cen[03]	= 'trescientos '
            Cen[04]	= 'cuatrocientos '
            Cen[05]	= 'quinientos '
            Cen[06]	= 'seiscientos '
            Cen[07]	= 'setecientos '
            Cen[08]	= 'ochocientos '
            Cen[09]	= 'novecientos '


            Public Aborta,Confirma

            Aborta		= 'prxAborta()'
            Confirma	= 'prxConfirma()'


            Public FechaHoy,Lastdate
            FechaHoy 	= Date()
            Set Date French
            Lastdate={^2079/12/31}

            Do LoadNamespace In Tools\Namespaces\prg\LoadNamespace.prg

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally
            Close Databases All

        Endtry


    Endproc && SetGlobales

    *
    * cEmpresa_Access
    Protected Procedure cEmpresa_Access()

        Local lcCommand As String,;
            lcUrl As String

        Local loBackEndSettings As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg"

        Try

            If Empty( This.cEmpresa )

                loBackEndSettings = NewBackEnd()
                lcUrl = loBackEndSettings.cBaseUrl

                If !Used( "Urls" )
                    Use Urls Shared In 0
                Endif

                Select Urls
                Locate For Alltrim( Url ) = lcUrl

                If Found()
                    This.cEmpresa = Alltrim( Urls.Alias ) + " - " + Alltrim( Urls.Url )
                Endif


                Try
                    _Screen.oScreenLog.lblEmpresa.Caption = This.cEmpresa

                Catch To oErr

                Finally

                Endtry

            Endif


        Catch To oErr
            *!*				Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

            *!*				loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
            *!*				loError.Process( oErr )

        Finally
            Use In Select( "Urls" )

        Endtry


        Return This.cEmpresa

    Endproc && cEmpresa_Access

    *
    * cEmpresa_Access
    Protected Procedure xxxxcEmpresa_Access()
        Local lcAlias As String
        Local lcCommand As String,;
            lcSucursal As Str
        Local loEmpresa As oEmpresa Of "Clientes\Archivos2\Prg\Empresas.prg"
        Local loRegistro As Object


        Try

            lcAlias = Sys(2015)

            If Empty( This.cEmpresa )

                If This.lMultiEmpresa
                    lcClassLib = "Clientes\Archivos2\Prg\Empresas.prg"
                    loEmpresa 		= Newobject( "oEmpresa", lcClassLib )
                    loRegistro 		= loEmpresa.GetDefault()
                    This.cEmpresa 	= loRegistro.Nomb0

                Else

                    TEXT To lcCommand NoShow TextMerge Pretext 15
					Use '<<Addbs(Alltrim(DRVA))>>AR0EST' Shared Again In 0 Alias <<lcAlias>>
                    ENDTEXT

                    &lcCommand

                    This.cEmpresa = Alltrim( Evaluate( lcAlias + ".Nomb0" ))

                    lcSucursal   = Addbs( Alltrim( _Screen.oApp.cRootWorkFolder )) + "SUCURSAL"

                    If FileExist( lcSucursal + ".Dbf" )

                        TEXT To lcCommand NoShow TextMerge Pretext 15
						Use <<lcSucursal>> Shared In 0
                        ENDTEXT

                        &lcCommand
                        lcCommand = ""

                        Select Sucursal
                        Locate For ACTIVO

                        If Found()
                            This.cEmpresa = This.cEmpresa + " (" + Alltrim( Nombre ) + " )"
                        Endif

                    Endif


                Endif


                Try
                    _Screen.oScreenLog.lblEmpresa.Caption = This.cEmpresa

                Catch To oErr

                Finally

                Endtry


            Endif


        Catch To oErr
            *!*				Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

            *!*				loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
            *!*				loError.Process( oErr )

        Finally
            Use In Select( lcAlias )

        Endtry


        Return This.cEmpresa

    Endproc && xxxcEmpresa_Access

    *
    * cEjercicio_Access
    Protected Procedure cEjercicio_Access()
        Local lcAlias As String
        Local lcCommand As String,;
            lcLibreria As String
        Local loEjercicio As oEjercicio Of "Clientes\Contabilidad\Prg\coActEje.prg"
        Local loRegistro As Object

        Try

            lcAlias = Sys(2015)

            If Empty( This.cEjercicio )
                lnEjercicioId 	= GetGlobal( "nEjercicioActivo" )

                * RA 2014-03-08(11:19:24)
                * Para que no sea llamado por el compilador en todos los modulos
                lcLibreria 		= "Clientes\Contabilidad\Prg\coActEje.prg"

                loEjercicio 	= Newobject( "oEjercicio", lcLibreria )
                loRegistro 		= loEjercicio.GetById( lnEjercicioId )

                This.cEjercicio = loRegistro.Nombre

                Try
                    _Screen.oScreenLog.lblEmpresa.Caption = This.cEmpresa

                Catch To oErr

                Finally

                Endtry


            Endif


        Catch To oErr
            *!*				Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

            *!*				loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
            *!*				loError.Process( oErr )

        Finally
            Use In Select( lcAlias )

        Endtry

        Return This.cEjercicio

    Endproc && cEjercicio_Access

    *
    * oColFonts_Access
    Protected Procedure oColFonts_Access()

        Try

            If Vartype( This.oColFonts ) # "O"
                Local loColFonts As Collection
                Local loFon As Object

                loColFonts = Createobject( "Collection" )

                loFont = Createobject( "Empty" )
                AddProperty( loFont, "FontName", _Screen.oApp.FontName )
                AddProperty( loFont, "FontSize", _Screen.oApp.FontSize )
                AddProperty( loFont, "FontStyle", _Screen.oApp.FontStyle )
                AddProperty( loFont, "FontCharSet", _Screen.oApp.FontCharSet )
                loColFonts.Add( loFont, "screen" )

                loFont = Createobject( "Empty" )
                AddProperty( loFont, "FontName", _Screen.oApp.FontName )
                AddProperty( loFont, "FontSize", _Screen.oApp.FontSize )
                AddProperty( loFont, "FontStyle", _Screen.oApp.FontStyle )
                AddProperty( loFont, "FontCharSet", _Screen.oApp.FontCharSet )
                loColFonts.Add( loFont, "selector" )

                This.oColFonts = loColFonts

            Endif

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally
            loColFonts = Null
            loFont = Null

        Endtry

        Return This.oColFonts

    Endproc && oColFonts_Access




    *
    * Dispara el men� definido en un Form con botones
    Procedure LaunchFormMenu(  ) As Void;
            HELPSTRING "Dispara el men� definido en un Form con botones"
        Try


        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

    Endproc && LaunchFormMenu




    *
    *
    Procedure HookAfterSetup(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && HookAfterSetup

    *
    *
    Procedure xxxCambiarClienteActivo() As Void
        Local lcCommand As String
        Local loPraxis As oPraxis Of "Clientes\Archivos\prg\Cliente_Praxis.prg"

        Try

            lcCommand = ""

            Do FrontEnd\Prg\CambiarClienteActivo

            This.nEmpresaId

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loPraxis = Null

        Endtry

    Endproc && xxxCambiarClienteActivo



    *
    *
    Procedure Personalizar_Modelos(  ) As Void
        Local lcCommand As String,;
            lcModelo As String,;
            lcTabla As String,;
            lcCampo As String,;
            lcPropiedad As String

        Local loModelo As oModelo Of "FrontEnd\Prg\Modelo.prg",;
            loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"


        Try

            lcCommand = ""

            If FileExist( "Personalizar_Front_End.DBF" )
                TEXT To lcCommand NoShow TextMerge Pretext 15
				Select 	Lower( Modelo ) as Modelo,
						Lower( Tabla ) as Tabla,
						Lower( Campo ) as Campo,
						Lower( Propiedad ) as Propiedad,
						Valor
					From Personalizar_Front_End
					Order By Modelo,Tabla,Campo,Propiedad
					Into Cursor cPFE ReadWrite
                ENDTEXT

                &lcCommand
                lcCommand = ""

                lcModelo 	= ""
                lcTabla 	= ""
                lcCampo 	= ""
                lcPropiedad = ""

                Locate
                Scan
                    If !( lcModelo == Alltrim( Modelo ))
                        lcModelo = Alltrim( Modelo )
                        If !Empty( Modelo )
                            loModelo = GetEntity( lcModelo )

                        Else
                            loModelo = Null

                        Endif

                    Endif

                    If !( lcTabla == Alltrim( Tabla ))
                        lcTabla = Alltrim( Tabla )
                        If !Empty( Tabla )
                            loTable = GetTable( lcTabla )

                        Else
                            loTable = Null

                        Endif

                    Endif

                    If !( lcCampo == Alltrim( Campo ))
                        lcCampo = Alltrim( Campo )
                        If !Empty( Campo )
                            loColFields = loTable.oColFields
                            loField = loColFields.GetItem( lcCampo )

                        Else
                            loField = Null

                        Endif

                    Endif

                    lcPropiedad = Alltrim( Propiedad )
                    lcValor 	= Alltrim( Valor )

                    If !Empty( Alltrim( Campo ))
                        TEXT To lcCommand NoShow TextMerge Pretext 15
						loField.<<lcPropiedad>> = '<<lcValor>>'
                        ENDTEXT

                        &lcCommand
                        lcCommand = ""

                    Else

                        If !Isnull( loModelo )
                            TEXT To lcCommand NoShow TextMerge Pretext 15
							loModelo.<<lcPropiedad>> = '<<lcValor>>'
                            ENDTEXT

                            &lcCommand
                            lcCommand = ""
                        Endif


                    Endif


                Endscan

            Endif


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField = Null
            loColFields = Null
            loTable = Null

        Endtry

    Endproc && Personalizar_Modelos



Enddefine
*!*
*!* END DEFINE
*!* Class.........: PrxApplication
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ORestoreVars
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Recupera las variables guardadas en un archivo .mem y las redefine como P�blicas
*!* Date..........: Mi�rcoles 2 de Diciembre de 2009 (19:28:42)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class oRestoreVars As Session

    #If .F.
        Local This As oRestoreVars Of "Fw\Sysadmin\Prg\Samain.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="restorefrom" type="method" display="RestoreFrom" />] + ;
        [<memberdata name="creararchivomem" type="method" display="CrearArchivoMem" />] + ;
        [</VFPData>]


    *
    *
    Procedure RestoreFrom( tcFileName As String ) As Void

        Local lcCommand As String,;
            lcFileName As String,;
            lcTextoDeAlerta As String,;
            lcMensajeAclaratorio As String,;
            lcKeyPressList As String,;
            lcPicture As String

        Local llShow As Boolean

        Local lcMemory As String,;
            lcStr As String
        Local lnLen As Integer
        Local i As Integer
        Local luDummy As Variant

        Try


            llShow = .T.

            TEXT To lcCommand NoShow TextMerge Pretext 15
			Restore From '<<(tcFileName)>>' Additive
            ENDTEXT

            If !FileExist( Forceext( tcFileName, "mem" ))

                TEXT To lcTextoDeAlerta NoShow TextMerge Pretext 03
				No Existe el archivo <<(tcFileName)>>
                ENDTEXT

                TEXT To lcMensajeAclaratorio NoShow TextMerge Pretext 03
				[ENTER]: CANCELA
                ENDTEXT

                TEXT To lcKeyPressList NoShow TextMerge Pretext 15
				<<KEY_F12>>, <<KEY_ENTER>>
                ENDTEXT

                lcPicture = "Fw\Comunes\Image\jpg\Stop.jpg"

                If UserKeyPress( lcTextoDeAlerta,;
                        lcMensajeAclaratorio,;
                        lcKeyPressList,;
                        lcPicture ) = KEY_F12

                    This.CrearArchivoMem( tcFileName )

                Else
                    llShow = .F.

                Endif

            Endif

            &lcCommand

            If  FileExist( "Terminal.Mem" )
                Restore From Terminal Additive

                If Vartype( lIntegracionWeb ) = "L"

                    lAux = lIntegracionWeb

                    Release lIntegracionWeb
                    Public lIntegracionWeb
                    lIntegracionWeb = lAux

                    Release lAux

                Endif

            Endif

            lcFileName = Sys(2015) + ".txt"

            i = 0
            Do While FileExist( lcFileName )
                i = i + 1
                lcFileName = "_" + Transform( i ) + Sys(2015) + ".txt"
            Enddo

            List Memory To File &lcFileName



            lnLen = Alines( laPublic, Filetostr( lcFileName ),1+4+8 )

            Erase &lcFileName

            For i = 1 To lnLen
                lcStr = Getwordnum( laPublic[i],2 )
                If Lower(lcStr) = "priv"
                    lcStr = Getwordnum( laPublic[i], 1 )
                    luDummy = &lcStr
                    Release &lcStr
                    Public &lcStr
                    &lcStr = luDummy
                Endif
            Endfor

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cRemark = lcCommand
            loError.Process( oErr, llShow )
            Throw loError

        Finally

        Endtry

    Endproc && RestoreFrom


    *
    * Permite al implementador crear el archivo
    Procedure CrearArchivoMem( tcFileName ) As Void;
            HELPSTRING "Permite al implementador crear el archivo "
        Local lcCommand As String,;
            lcVarList As String,;
            lcInputPromp As String,;
            lcDialog As String,;
            lcVarName As String,;
            lcRuta As String,;
            lcMsg As String,;
            lcCurdir As String


        Local i As Integer,;
            lnLen As Integer,;
            lnConfirm As Integer

        Local llDone As Boolean

        Local lcConsole As String

        Try

            lcCommand = ""

            lcConsole = Set("Console")

            Set Console Off

            lcCurdir 	= Set("Default") + Curdir()
            lcRuta 		= "S:\Fenix\"

            Wait Window Noclear Nowait tcFileName + " NO EXISTE...."

            TEXT To lcDialog NoShow TextMerge Pretext 15
			Crear <<JustFname( tcFileName )>>
            ENDTEXT

            lcInputPromp = "Ingrese la lista de variables separadas por coma"

            Do Case
                Case Like( "*coparame*", Lower(tcFileName) )
                    lcVarList = "drSub, drCue, DRVA"

                Case Like( "*arparame*", Lower(tcFileName) )
                    lcVarList = "DRVA, DRVD"

                Otherwise
                    lcVarList = ""

            Endcase

            lcVarList = Inputbox( lcInputPromp, lcDialog, lcVarList )

            If !Empty( lcVarList )

                llDone = .F.
                lnConfirm = 0

                Do While !llDone

                    TEXT To lcDialog NoShow TextMerge Pretext 15
					Indique la Carpeta para la Varaible P�blica
                    ENDTEXT

                    lnLen = Getwordcount( lcVarList, "," )

                    For i = 1 To lnLen
                        lcVarName = Getwordnum( lcVarList, i, "," )

                        If Empty( lnConfirm )
                            Release ( lcVarName )
                            Private ( lcVarName )

                        Else
                            lcRuta = &lcVarName.

                        Endif

                        *lcRuta = Getdir( lcRuta, lcVarName, lcDialog, 16+32+64 )
                        lcRuta = Getdir( lcRuta, lcVarName, lcDialog )

                        TEXT To lcCommand NoShow TextMerge Pretext 15
						<<lcVarName>> = "<<Addbs( lcRuta )>>"
                        ENDTEXT

                        &lcCommand

                        Cd &lcRuta.

                        *MessageBox( lcCommand )

                    Endfor

                    lcMsg = ""
                    For i = 1 To lnLen
                        lcVarName = Getwordnum( lcVarList, i, "," )

                        TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
						<<lcVarName>> = "
                        ENDTEXT

                        lcMsg = lcMsg + &lcVarName. + ["] + CRLF

                    Endfor

                    lnConfirm = Messagebox( lcMsg,;
                        MB_YESNOCANCEL + MB_ICONQUESTION,;
                        "�Confirma las Variables P�blicas?" )

                    Do Case
                        Case lnConfirm = IDCANCEL
                            llDone = .T.

                        Case lnConfirm = IDYES
                            llDone = .T.

                        Case lnConfirm = IDNO
                            llDone = .F.

                        Otherwise

                    Endcase


                Enddo

                If lnConfirm = IDYES
                    TEXT To lcCommand NoShow TextMerge Pretext 15
					Save to "<<tcFileName>>" All Like "dr*"
                    ENDTEXT

                    &lcCommand

                Endif

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            Wait Clear
            Cd &lcCurdir

        Endtry

    Endproc && CrearArchivoMem

Enddefine
*!*
*!* END DEFINE
*!* Class.........: ORestoreVars
*!*
*!* ///////////////////////////////////////////////////////
