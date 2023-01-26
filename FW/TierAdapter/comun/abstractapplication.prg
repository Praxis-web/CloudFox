#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\TierAdapter\Include\TA.h"



* Declarar los programas y clases que son necfesarios que el Builder
* incluya en el proyecto

*!*	If .F.
*!*		Launch()

*!*		Do Form "ErrorForm"
*!*		Do Form "ErrorMessage"
*!*	Endif

*!*	Define Class SplashScreen As SplashScreen Of SplashScreen.vcx
*!*	Enddefine

*!*	Define Class Mainform As Mainform Of prxMainForm.vcx
*!*	Enddefine

*!*	Define Class Selector As Selector Of prxSelector.vcx
*!*	Enddefine

*!*	Define Class Toolb As prxToolbar Of prxToolbar.vcx
*!*	Enddefine

*!*	Define Class ApLogo As AppLogo Of AppLogo.prg
*!*	Enddefine

* Fin de declaracion de programas y clases



*!* ///////////////////////////////////////////////////////
*!* Class.........: AbstractApplication
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Clase Abstracta
*!* Date..........: Jueves 2 de Marzo de 2006 (17:42:06)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

* Define Class AbstractApplication As PrxSession Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"
Define Class AbstractApplication As prxCustom Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"

	#If .F.
		Local This As AbstractApplication Of "FW\TierAdapter\Comun\AbstractApplication.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cappicon" type="property" display="cAppIcon" />] + ;
		[<memberdata name="cversion" type="property" display="cVersion" />] + ;
		[<memberdata name="cappname" type="property" display="cAppName" />] + ;
		[<memberdata name="lIsOk" type="property" display="lIsOk" />] + ;
		[<memberdata name="oerror" type="property" display="oError" />] + ;
		[<memberdata name="clearglobalapplicationpointer" type="method" display="ClearGlobalApplicationPointer" />] + ;
		[<memberdata name="restoresenvironment" type="method" display="RestoresEnvironment" />] + ;
		[<memberdata name="saveenvironment" type="method" display="SaveEnvironment" />] + ;
		[<memberdata name="setglobalapplicationpointer" type="method" display="SetGlobalApplicationPointer" />] + ;
		[<memberdata name="setenvironment" type="method" display="SetEnvironment" />] + ;
		[<memberdata name="ldebugmode" type="property" display="lDebugMode" />] + ;
		[<memberdata name="oentorno" type="property" display="oEntorno" />] + ;
		[<memberdata name="cXMLoError" type="property" display="cXMLoError" />] + ;
		[<memberdata name="cdevelopermenu" type="property" display="cDeveloperMenu" />] + ;
		[<memberdata name="ctrailermenu" type="property" display="cTrailerMenu" />] + ;
		[<memberdata name="ctoolsmenu" type="property" display="cToolsMenu" />] + ;
		[<memberdata name="lforcedexit" type="property" display="lForcedExit" />] + ;
		[<memberdata name="ouser" type="property" display="oUser" />] + ;
		[<memberdata name="execute" type="method" display="Execute" />] + ;
		[<memberdata name="oapplogo" type="property" display="oAppLogo" />] + ;
		[<memberdata name="ocolconfigdata" type="property" display="oColConfigData" />] + ;
		[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
		[<memberdata name="cdefaultfolder" type="property" display="cDefaultFolder" />] + ;
		[<memberdata name="ocolforms" type="property" display="oColForms" />] + ;
		[<memberdata name="oactiveform" type="property" display="oActiveForm" />] + ;
		[<memberdata name="nupdatefontsize" type="property" display="nUpdateFontSize" />] + ;
		[<memberdata name="llcanrecall" type="property" display="llCanRecall" />] + ;
		[<memberdata name="llidle" type="property" display="llIdle" />] + ;
		[<memberdata name="llediting" type="property" display="llEditing" />] + ;
		[<memberdata name="llogin" type="property" display="lLogin" />] + ;
		[<memberdata name="obuttons" type="property" display="oButtons" />] + ;
		[<memberdata name="obuttons_access" type="method" display="oButtons_Access" />] + ;
		[<memberdata name="omaintoolbar" type="property" display="oMainToolBar" />] + ;
		[<memberdata name="cuser" type="property" display="cUser" />] + ;
		[<memberdata name="csplashclass" type="property" display="cSplashClass" />] + ;
		[<memberdata name="csplashclasslibrary" type="property" display="cSplashClassLibrary" />] + ;
		[<memberdata name="ctoolbarclasslibrary" type="property" display="cToolbarClassLibrary" />] + ;
		[<memberdata name="ctoolbarclass" type="property" display="cToolbarClass" />] + ;
		[<memberdata name="cscreenicon" type="property" display="cScreenIcon" />] + ;
		[<memberdata name="capplogoclass" type="property" display="cAppLogoClass" />] + ;
		[<memberdata name="capplogoclasslibrary" type="property" display="cAppLogoClassLibrary" />] + ;
		[<memberdata name="capplogosource" type="property" display="cAppLogoSource" />] + ;
		[<memberdata name="lapplogo" type="property" display="lAppLogo" />] + ;
		[<memberdata name="oshutofftimer" type="property" display="oShutOffTimer" />] + ;
		[<memberdata name="oshutofftimer_access" type="method" display="oShutOffTimer_Access" />] + ;
		[<memberdata name="lshutofftimer" type="property" display="lShutOffTimer" />] + ;
		[</VFPData>]

	lIsOk 		= .T.
	oError 		= Null
	cXMLoError 	= ""

	lDebugMode	= .T.	&& Esta corriendo en modo de desarrollo
	lSplash		= .T.	&& If there is a splash screen
	lDesktop	= .T.	&& If there is a desktop (with a main menu)
	lForcedExit = .F.   && Forces to exit the application - See method Exit() of This
	lLogin 		= .F. && Indica si se encuentra algún usuario logueado al sistema

	cAppName	= "Application"
	cVersion	= "alpha"
	cAppIcon	= "Praxis.ico"

	lAppLogo				= .T.	&& Hay un Logo de la Aplicacion
	cAppLogoSource 			= ""
	cAppLogoClass 			= ""
	cAppLogoClassLibrary 	= ""
	oAppLogo 				= Null

	oUser        = Null
	oMainToolbar = Null
	oMenuBuilder = Null

	*!* Colección de Datos de Configuración
	oColConfigData = Null

	*!* Coleccion de objetos Table
	oColTables = Null

	cSplashClass 			= ""
	cSplashClassLibrary 	= ""
	cScreenIcon 			= ""
	cToolbarClass 			= ""
	cToolbarClassLibrary 	= ""

	cToolsMenu 		= ""
	cDeveloperMenu = ""
	cTrailerMenu 	= ""

	oEntorno			= Null
	cOldDir      	 	= ""
	cOldCaption		 	= ""
	cOldWindowState 	= ""
	cOldIcon 		 	= ""

	*!* Carpeta de default
	cDefaultFolder = ""

	*!* Colección de objetos Forms instanciados
	oColForms = .F.

	*!* Referencia al Formulario Activo
	oActiveForm = .F.

	*!* Indica la variacion en más o en menos del FontSize por default.
	*Es una propiedad Global que se inicializa al instanciar cada usuario
	nUpdateFontSize = 0

	*!* Indica si el formulario activo se está editando
	llEditing = .F.

	*!* Indica si el formulario activo está en estado IDLE
	llIdle = .F.

	*!* Indica si el formulario activo permite ejecutar FastEdition()
	llCanRecall = .F.

	*!* Estado de los botones de la aplicación
	oButtons = Null

	* Objeto User serializado
	cUser = ""


	* Timer que cierra la aplicación
	oShutOffTimer = Null
	lShutOffTimer = .F.


	*!* ///////////////////////////////////////////////////////
	*!* Function......: Init
	*!* Description...:
	*!* Date..........: Lunes 4 de Abril de 2005 (17:27:39)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.0
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Init( tcAppName As String, ;
			tcVersion As String,;
			tcUser As String ) As Boolean

		Local lcText As String

		With This As AbstractApplication Of "FW\TierAdapter\Comun\AbstractApplication.prg"
			Try


				*!*					Declare Integer ShellExecute In shell32.Dll ;
				*!*						INTEGER hndWin, ;
				*!*						STRING cAction, ;
				*!*						STRING cFileName, ;
				*!*						STRING cParams, ;
				*!*						STRING cDir, ;
				*!*						INTEGER nShowWin


				*!*	hndWin		The handle of the program's parent window. In VFP, you will usually set this to 0.
				*!*	cAction		The action which is to be performed.
				*!*	cfileName	The file (or other 'object') on which the action is to be performed.
				*!*	cParams		If the file is an executable program, these are the parameters (if any) which are passed to it in the command line.
				*!*	cDir		If the file is an executable program, this is the program's default or start-up directory.
				*!*	nShowWindow	The program's initial window state (1 = normal, 2 = minimised, 3 = maximised).


				If Vartype( tcAppName ) # "C"
					tcAppName = ""
				Endif

				If Vartype( tcVersion ) # "C"
					tcVersion = ""
				Endif

				If Vartype( tcUser ) # "C"
					tcUser = ""
				Endif

				.cAppName	= NoDelimiters( Alltrim( tcAppName ))
				.cVersion	= NoDelimiters( Alltrim( tcVersion ))
				.cUser      = NoDelimiters( Alltrim( tcUser ))

				.cApplicationName = Alltrim( Getwordnum( .cAppName, 1 ))

				.SaveEnvironment()


				If .lIsOk
					.SetGlobalApplicationPointer()
				Endif

				If .lIsOk
					.SetEnvironment()
				Endif

				If .lIsOk
					This.oColForms = Createobject( "ColForms" )
				Endif


			Catch To loErr
				This.lIsOk = .F.
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.Process ( m.loErr )
				Throw loError

			Finally

			Endtry


		Endwith

		Return This.lIsOk

	Endfunc && Init

	*
	* oError_Access
	Protected Procedure oError_Access()
		If Vartype( This.oError ) # "O"
			This.oError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )

		Endif

		Return This.oError

	Endproc && oError_Access



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SetGlobalApplicationPointer
	*!* Description...:
	*!* Date..........: Lunes 4 de Abril de 2005 (17:05:01)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.0
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure SetGlobalApplicationPointer(  ) As Void

		Local lcCommand As String

		Try

			lcCommand = ""
			This.ClearGlobalApplicationPointer()
			_Screen.AddProperty( "oApp" )
			_Screen.oApp = This
			
		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

	Endproc && SetGlobalApplicationPointer

	*!* ///////////////////////////////////////////////////////
	*!* Function......: SaveEnvironment
	*!* Description...:
	*!* Date..........: Martes 29 de Marzo de 2005 (18:27:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.0
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function SaveEnvironment(  ) As Void

		Try

			With This As AbstractApplication Of "FW\TierAdapter\Comun\AbstractApplication.prg"

				.cOldCaption	  	= _Screen.Caption
				.cOldWindowState  	= _Screen.WindowState
				.cOldIcon 		  	= _Screen.Icon

				.oEntorno 			= Newobject("Environment")
				.oEntorno.oMaster 	= This
				.oEntorno.Save()

			Endwith


		Catch To loErr
			.lIsOk = .F.
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endfunc
	*!*
	*!* END FUNCTION SaveEnvironment
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Function......: SetEnvironment
	*!* Description...:
	*!* Date..........: Martes 29 de Marzo de 2005 (19:20:05)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.0
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function SetEnvironment(  ) As Void

		Local loXA As prxXMLAdapter Of "Comun\Prg\prxXMLAdapter.prg"
		Local lcAlias As String

		Try

			Close Databases All
			Clear
			Set Talk Off
			Set Asserts On
			Set Escape Off
			Set Status Bar On
			Set Status Off

			This.cDefaultFolder = Set( "Default" ) + Curdir()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return This.lIsOk


	Endfunc
	*!*
	*!* END FUNCTION SetEnvironment
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Lunes 4 de Abril de 2005 (17:24:44)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.0
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy(  ) As Void
		With This As AbstractApplication Of "Comun\Prg\AbstractApplication.prg"

			If !This.lOnDestroy
				This.lOnDestroy = .T.

				.oActiveForm 	= Null
				.oAppLogo 		= Null
				.oButtons 		= Null
				.oColConfigData	= Null
				.oColForms 		= .F.
				.oColTables 	= Null
				.oMainToolbar 	= Null
				.oMenuBuilder 	= Null
				.oUser 			= Null
				.oShutOffTimer 	= Null

				.RestoreEnvironment()
				.oEntorno 		= Null


				*!*					.ClearGlobalApplicationPointer()
			Endif

		Endwith

		DoDefault()

	Endproc && Destroy

	*!* ///////////////////////////////////////////////////////
	*!* Function......: RestoreEnvironment
	*!* Description...:
	*!* Date..........: Martes 29 de Marzo de 2005 (18:28:19)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.0
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function RestoreEnvironment(  ) As Void


		Try

			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cTraceLogin = "Restaurando Entorno Original"

			Set Sysmenu To Default
			_Screen.Caption = This.cOldCaption
			_Screen.Icon = This.cOldIcon
			_Screen.WindowState = This.cOldWindowState

			If Vartype( This.oEntorno ) == "O"
				This.oEntorno.Restore()
				This.oEntorno = Null
			Endif

			Set Help On

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:51:08)
			*!*	This.cXMLoError=This.oError.Process( oErr )
			If Vartype( loError ) # 'O'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			Endif
			This.cXMLoError = loError.Process( oErr )

		Finally

		Endtry

	Endfunc && RestoreEnvironment

	*!*	///////////////////////////////////////////////////////
	*!*	Procedure.....: ClearGlobalApplicationPointer
	*!*	Description...:
	*!*	Date..........: Lunes 4 de Abril de 2005 (17:26:17)
	*!*	Author........: Ricardo Aidelman
	*!*	Project.......: Visual Praxis Beta 1.0
	*!*	-------------------------------------------------------
	*!*	Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ClearGlobalApplicationPointer(  ) As Void

		Local lcToolbarClass As String
		Local lcCommand As String

		Try

			lcCommand = ""

			lcToolbarClass = This.cToolbarClass
			If Pemstatus( _Screen, lcToolbarClass, 5 )
				_Screen.&lcToolbarClass. = Null
				Try
					Removeproperty( _Screen, lcToolbarClass )

				Catch To oErr
				Endtry

			Endif


			If Pemstatus( _Screen, "oGlobalSettings", 5 )
				_Screen.oGlobalSettings = Null

				Try

					Removeproperty( _Screen, "oGlobalSettings")

				Catch To oErr

				Finally

				Endtry
			Endif

			If Pemstatus( _Screen, "oObjectFactory", 5 )
				_Screen.oObjectFactory = Null
			Endif

			If Pemstatus( _Screen, "oApp", 5 )
				Try
					_Screen.oApp.Destroy()
					*!*						_Screen.oApp = Null
					Removeproperty( _Screen, "oApp")

				Catch To oErr

				Finally

				Endtry

			Endif

			This.oGlobalSettings = Null

			If Pemstatus( _Screen, "oScreenLog", 5 )
				_Screen.RemoveObject( "oScreenLog" )
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry


	Endproc && ClearGlobalApplicationPointer

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Execute
	*!* Description...: Ejecuta un método
	*!* Date..........: Jueves 2 de Marzo de 2006 (17:50:57)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: TimeSheet
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Execute( tcMethod As String,;
			tuParam As Variant ) As Boolean;
			HELPSTRING "Ejecuta un método"
		Local lcCommand As String

		Try

			*!*	This.oError.cTraceLogin = ""
			*!*	This.oError.cRemark = ""

			lcCommand = "This."+Alltrim(tcMethod)
			If Pcount()=1
				lcCommand = lcCommand + "()"
			Else
				lcCommand = lcCommand + "("+tuParam+")"
			Endif

			&lcCommand


		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:48:36)
			* This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			This.cXMLoError = loError.Process( oErr )

		Finally

		Endtry


		Return This.lIsOk
	Endproc && Execute

	Procedure SynchronizeButtons() As Void


		*!*	Por default, el metodo Mainform.SynchronizeButtons() setea las propiedades del
		*!*	objeto This.oButtons (_Screen.oApp.oButtons ), poniendolas en .T. o .F., y
		*!*	finaliza haciendo un llamado a éste metodo (_Screen.oApp.SynchronizeButtons() )
		*!*	por lo que en realidad se comporta como un Evento, del cual pueden
		*!*	acoplarse mediante BindEvent() todos los métodos que controlen el estado
		*!*	de los botones (por ejemplo, Mainform.SetButtons() y prxToolbar.SetButtons())
		*!*	El menú Sistema.prg y Mainform.ContextualMenu() hacen referencia a las
		*!*	propiedades de _Screen.oApp.oButtons para la clausula SKIP FOR.
		*!*	También el metodo Mainform.KeyPress() está afectado por éstas propiedades.
		*!*	El objeto principal se crea en _Screen.oApp.oButtons, pero algunas clases hacen
		*!*	referencia a This.oButtons, a fin de evitar acoplamiento. El evento
		*!*	oButtons_Access es el que, por default, crea una referencia al objeto principal
		*!*	(en oApp).
		*!*	Cualquier metodo, de cualquier clase, que desee modificar la propiedad
		*!*	Enabled de algún/algunos botones de opción, y que ello se refleje en
		*!*	todos lados, solo debe poner en .T. o .F. la propiedad correspondiente, y
		*!*	luego llamar a _Screen.oApp.SynchronizeButtons()
		*!*	La forma predeterminada de hacerlo es mediante código en el metodo
		*!*	Mainform.SynchronizeButtonsHook().


	Endproc && SynchronizeButtons

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oButtons_Access
	*!* Description...:
	*!* Date..........: Miércoles 25 de Julio de 2007 (11:13:29)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oButtons_Access(  ) As Object

		If IsEmpty( This.oButtons )
			This.oButtons = Createobject( "Empty" )
			AddProperty( This.oButtons, "Close", .F. )
			AddProperty( This.oButtons, "Delete", .F. )
			AddProperty( This.oButtons, "Edit", .F. )
			AddProperty( This.oButtons, "New", .F. )
			AddProperty( This.oButtons, "Open", .F. )
			AddProperty( This.oButtons, "Report", .F. )
			AddProperty( This.oButtons, "Save", .F. )

		Endif
		Return This.oButtons

	Endproc && oButtons_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oMainToolbar_Access
	*!* Date..........: Lunes 13 de Abril de 2009 (17:17:07)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!* Si se cierra la Toolbar se producia un error
	*!*

	Procedure oMainToolbar_Access()

		Local lcToolbarClass As String

		If Vartype( This.oMainToolbar ) # "O"
			lcToolbarClass = This.cToolbarClass
			If ! Pemstatus( _Screen, lcToolbarClass, 5 )
				AddProperty( _Screen, lcToolbarClass )

			Endif
			If Vartype( _Screen.&lcToolbarClass. ) # 'O'
				_Screen.&lcToolbarClass. = Newobject( lcToolbarClass, This.cToolbarClassLibrary )

			Endif && Vartype( _Screen.&lcToolbarClass. ) # 'O'

			* DAE 2009-08-04(15:29:34)
			* This.oMainToolbar = Newobject( This.cToolbarClass, This.cToolbarClassLibrary )
			This.oMainToolbar = _Screen.&lcToolbarClass.

			This.oMainToolbar.Dock(0)

		Endif

		Return This.oMainToolbar

	Endproc && oMainToolbar_Access

	*
	* oGlobalSettings_Access
	Protected Procedure oGlobalSettings_Access()
		If Vartype( This.oGlobalSettings ) # "O"
			This.oGlobalSettings = NewGlobalSettings()

		Endif && Vartype( This.oGlobalSettings ) # "O"

		Return This.oGlobalSettings

	Endproc && oGlobalSettings_Access


	*
	* oShutOffTimer_Access
	Protected Procedure oShutOffTimer_Access()

		If Vartype( This.oShutOffTimer ) # "O"
			If This.lShutOffTimer
				This.oShutOffTimer = Newobject( "oShutOffTimer", "FW\TierAdapter\Comun\AbstractApplication.prg" )

			Else
				This.oShutOffTimer = Newobject( "oDummyShutOffTimer", "FW\TierAdapter\Comun\AbstractApplication.prg" )

			Endif


		Endif && Vartype( This.oGlobalSettings ) # "O"

		Return This.oShutOffTimer

	Endproc && oShutOffTimer_Access


Enddefine && AbstractApplication

*!* ///////////////////////////////////////////////////////
*!* Class.........: oShutOffTimer
*!* Description...:
*!* Date..........: Jueves 8 de Diciembre de 2016 (13:10:51)
*!*
*!*

Define Class oShutOffTimer As Timer

	#If .F.
		Local This As oShutOffTimer Of "FW\TierAdapter\Comun\AbstractApplication.prg"
	#Endif

	Enabled = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]
	*
	*
	Procedure Timer(  ) As Void
		#INCLUDE "FW\Comunes\Include\Praxis.h"

		Local lcMsg As String,;
			lcComienzaExclusion As String,;
			lcFinalizaExclicion As String
		Local lnTimeOut As Integer
		Local loApp As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

		Try

			Try

				loApp = _Screen.oApp

			Catch To oErr
				loApp = NewApp()

			Finally

			Endtry

			* RA 04/07/2019(15:52:08)
			* Parametrizado en arParImp.Globales
			lcComienzaExclusion = GetValue( "InitTime", "ar0Sys", "08:00:00" )
			lcFinalizaExclicion = GetValue( "EndTime",  "ar0Sys", "18:00:00" )

			If Between( Time(), lcComienzaExclusion, lcFinalizaExclicion )
				* RA 04/07/2019(15:50:57)
				* No cerrar la aplicación durante el horario de
				* exclusión del control (Generalmente es el Horario de Trabajo)
				This.Reset()
				This.Enabled = .T.

			Else
				lnTimeOut = GetValue( "ShutOff", "ar0Sys", 300 ) * 1000	&& 5 minutos
				This.Enabled = .F.

				TEXT To lcMsg NoShow TextMerge Pretext 03
				El Sistema a estado inactivo por
				un período prolongado de tiempo
				y ahora se cerrará.


				¿Desea que continúe abierto?
				ENDTEXT

				If !loApp.lExit ;
						And Confirm( lcMsg, _Screen.Caption, .T., MB_ICONEXCLAMATION, "", lnTimeOut )

					This.Reset()
					This.Enabled = .T.

				Else
					* RA 28/11/2016(12:48:08)
					* Crea un posible loop de 2 segundos de intervalo
					* para que vaya cerrando los formularios anidados
					loApp.lExit = .T.
					This.Interval = 2000

					lcMsg = ""

					lcMaq = Sys ( 0 )
					lcUsu = lcMaq
					lcMaq = Alltrim( Proper ( Substr ( m.lcMaq, 1, At ( '#', m.lcMaq ) - 1 ) ))
					lcUsu = Alltrim( Proper ( Substr ( m.lcUsu, At ( '#', m.lcUsu ) + 1 ) ))

					loUser	= loApp.oUser

					TEXT To lcMsg NoShow TextMerge Pretext 03
				------------------------------------------------------

				<<Transform( Datetime() )>>
				Módulo.........: <<_Screen.Caption>>
				Usuario Fenix..: <<loUser.Nombre>>
				Usuario Windows: <<lcUsu>>
				Terminal.......: <<lcMaq>>
					ENDTEXT

					Wait Window Nowait Noclear "El Sistema se está Cerrando por Inactividad Prolongada"

					Strtofile( lcMsg + CRLF, "AutoShutOff_Log.txt", 1 )
					Strtofile( lcMsg + CRLF, Alltrim( DRVA ) + "AutoShutOff_Log_" + Dtoc( Datetime(), 1 ) + ".txt", 1 )

					Error lcMsg

				Endif
			Endif

		Catch To oErr
			Throw oErr

		Finally
			This.Enabled = .T.

		Endtry

	Endproc && Timer

	*
	*
	Procedure xxxTimer(  ) As Void
		#INCLUDE "FW\Comunes\Include\Praxis.h"

		Local lcMsg As String
		Local lnTimeOut As Integer
		Local loApp As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

		Try

			Try

				loApp = _Screen.oApp

			Catch To oErr
				loApp = NewApp()

			Finally

			Endtry

			lnTimeOut = GetValue( "ShutOff", "ar0Sys", 300 ) * 1000	&& 5 minutos
			This.Enabled = .F.

			TEXT To lcMsg NoShow TextMerge Pretext 03
			El Sistema a estado inactivo por
			un período prolongado de tiempo
			y ahora se cerrará.


			¿Desea que continúe abierto?
			ENDTEXT

			If !loApp.lExit ;
					And Confirm( lcMsg, _Screen.Caption, .T., MB_ICONEXCLAMATION, "", lnTimeOut )

				This.Reset()
				This.Enabled = .T.

			Else
				* RA 28/11/2016(12:48:08)
				* Crea un posible loop de 2 segundos de intervalo
				* para que vaya cerrando los formularios anidados
				loApp.lExit = .T.
				This.Interval = 2000

				lcMsg = ""

				lcMaq = Sys ( 0 )
				lcUsu = lcMaq
				lcMaq = Alltrim( Proper ( Substr ( m.lcMaq, 1, At ( '#', m.lcMaq ) - 1 ) ))
				lcUsu = Alltrim( Proper ( Substr ( m.lcUsu, At ( '#', m.lcUsu ) + 1 ) ))

				loUser	= loApp.oUser

				TEXT To lcMsg NoShow TextMerge Pretext 03
				------------------------------------------------------

				<<Transform( Datetime() )>>
				Módulo.........: <<_Screen.Caption>>
				Usuario Fenix..: <<loUser.Nombre>>
				Usuario Windows: <<lcUsu>>
				Terminal.......: <<lcMaq>>
				ENDTEXT

				Wait Window Nowait Noclear "El Sistema se está Cerrando por Inactividad Prolongada"

				Strtofile( lcMsg + CRLF, "AutoShutOff_Log.txt", 1 )
				Strtofile( lcMsg + CRLF, Alltrim( DRVA ) + "AutoShutOff_Log_" + Dtoc( Datetime(), 1 ) + ".txt", 1 )

				Error lcMsg

			Endif

		Catch To oErr
			Throw oErr

		Finally
			This.Enabled = .T.

		Endtry


	Endproc && xxxTimer

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oShutOffTimer
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oDummyShutOffTimer
*!* Description...:
*!* Date..........: Miércoles 28 de Diciembre de 2016 (13:21:21)
*!*
*!*

Define Class oDummyShutOffTimer As oShutOffTimer Of "FW\TierAdapter\Comun\AbstractApplication.prg"

	#If .F.
		Local This As oDummyShutOffTimer Of ""
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*
	*
	Procedure Timer(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			Nodefault


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Timer



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oDummyShutOffTimer
*!*
*!* ///////////////////////////////////////////////////////



*!* ///////////////////////////////////////////////////////
*!* Class.........: Environment
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Guarda y Restaura las variables de entorno
*!* Date..........: Viernes 30 de Septiembre de 2005 (15:57:07)
*!* Author........: Ricardo Aidelman
*!* Project.......: Gestor de Reportes
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class Environment As Session
	#If .F.
		Local This As Environment Of "fw\tieradapter\comun\abstractapplication.prg"
	#Endif


	*!* Colección de Variables
	Variables = Null
	oMaster = Null


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="variables" type="property" display="Variables" />] + ;
		[<memberdata name="omaster" type="property" display="oMaster" />] + ;
		[<memberdata name="save" type="method" display="Save" />] + ;
		[<memberdata name="restore" type="method" display="Restore" />] + ;
		[<memberdata name="agregar" type="method" display="Agregar" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Init
	*!* Description...:
	*!* Date..........: Viernes 30 de Septiembre de 2005 (15:58:11)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Gestor de Reportes
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Init(  ) As Boolean
		Try

			This.Variables = Newobject( "prxCollection", "prxBaseLibrary.prg" )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return .T.
	Endfunc && Init

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Save
	*!* Description...: Guarda las variables de entorno
	*!* Date..........: Viernes 30 de Septiembre de 2005 (16:07:03)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Gestor de Reportes
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Save(  ) As Void;
			HELPSTRING "Guarda las variables de entorno"

		Try


			This.Agregar("Alternate", Set("Alternate"), "Alternate")
			This.Agregar("Ansi", Set("Ansi"), "Ansi")
			This.Agregar("Asserts", Set("Asserts"), "Asserts")
			This.Agregar("AutoIncError", Set("AutoIncError"), "AutoIncError")
			This.Agregar("Autosave", Set("Autosave"), "Autosave")
			This.Agregar("Bell", Set("Bell"), "Bell")
			This.Agregar("Blocksize", Set("Blocksize"), "Blocksize To")
			This.Agregar("Browseime", Set("Browseime"), "Browseime")
			This.Agregar("Carry", Set("Carry"), "Carry")
			This.Agregar("Century", Set("Century"), "Century")
			This.Agregar("Classlib", Set("Classlib"), "Classlib To")
			This.Agregar("Clock", Set("Clock"), "Clock")
			This.Agregar("Collate",["]+Set("Collate")+["], "Collate To")
			This.Agregar("Color", Set("Color"), "Color To")
			This.Agregar("Compatible", Set("Compatible"), "Compatible")
			This.Agregar("Confirm", Set("Confirm"), "Confirm")
			This.Agregar("Console", Set("Console"), "Console")
			This.Agregar("Coverage", Set("Coverage"), "Coverage To")
			This.Agregar("Cpcompile", Set("Cpcompile"), "Cpcompile To")
			This.Agregar("Cpdialog", Set("Cpdialog"), "Cpdialog")
			This.Agregar("Currency", Set("Currency"), "Currency")
			This.Agregar("Cursor", Set("Cursor"), "Cursor")
			This.Agregar("Database", Set("Database"), "Database To")
			This.Agregar("Datasession", Set("Datasession"), "Datasession To")
			This.Agregar("Date", Set("Date"), "Date")
			This.Agregar("Debug", Set("Debug"), "Debug")
			This.Agregar("Debugout", Set("Debugout"), "Debugout To")
			This.Agregar("Decimals", Set("Decimals"), "Decimals To")
			This.Agregar("Default", Set("Default"), "Default To")
			This.Agregar("Deleted", Set("Deleted"), "Deleted")
			This.Agregar("Development", Set("Development"), "Development")
			This.Agregar("Device", Set("Device"), "Device To")
			This.Agregar("Display", Set("Display"), "Display To")
			This.Agregar("Echo", Set("Echo"), "Echo")
			This.Agregar("EngineBehavior", Set("EngineBehavior"), "EngineBehavior")
			This.Agregar("Escape", Set("Escape"), "Escape")
			This.Agregar("Eventlist", Set("Eventlist"), "Eventlist To")
			This.Agregar("Eventtracking", Set("Eventtracking"), "Eventtracking")
			This.Agregar("Exact", Set("Exact"), "Exact")
			This.Agregar("Exclusive", Set("Exclusive"), "Exclusive")
			This.Agregar("Fdow", Set("Fdow"), "Fdow To")
			This.Agregar("Fields", Set("Fields"), "Fields")
			*!*		This.Agregar("Filter", Set("Filter"), "Filter To")
			This.Agregar("Fixed", Set("Fixed"), "Fixed")
			This.Agregar("Fullpath", Set("Fullpath"), "Fullpath")
			*!*		This.Agregar("Function", Set("Function"), "Function")
			This.Agregar("Fweek", Set("Fweek"), "Fweek To")
			This.Agregar("Headings", Set("Headings"), "Headings")
			This.Agregar("Help", Set("Help"), "Help")
			*!*		This.Agregar("Helpfilter", Set("Helpfilter"), "Helpfilter")
			This.Agregar("Hours", Set("Hours"), "Hours To")
			*!*		This.Agregar("Index", Set("Index"), "Index To")
			*!*		This.Agregar("Key", Set("Key"), "Key To")
			This.Agregar("Keycomp", Set("Keycomp"), "Keycomp To")
			This.Agregar("Library", Set("Library"), "Library To")
			This.Agregar("Lock", Set("Lock"), "Lock")
			This.Agregar("Logerrors", Set("Logerrors"), "Logerrors")
			This.Agregar("Mackey", Set("Mackey"), "Mackey To")
			This.Agregar("Margin", Set("Margin"), "Margin To")
			This.Agregar("Mark", ["]+Set("Mark")+["], "Mark To")
			This.Agregar("Memowidth", Set("Memowidth"), "Memowidth To")
			This.Agregar("Message", Set("Message"), "Message To")
			This.Agregar("Multilocks", Set("Multilocks"), "Multilocks")
			This.Agregar("Near", Set("Near"), "Near")
			*!*		This.Agregar("Nocptrans", Set("Nocptrans"), "Nocptrans To")
			This.Agregar("Notify", Set("Notify"), "Notify")
			This.Agregar("Null", Set("Null"), "Null")
			This.Agregar("Nulldisplay", ["]+Set("Nulldisplay")+["], "Nulldisplay To")
			This.Agregar("Odometer", Set("Odometer"), "Odometer To")
			This.Agregar("Oleobject", Set("Oleobject"), "Oleobject")
			This.Agregar("Optimize", Set("Optimize"), "Optimize")
			This.Agregar("Order", Set("Order"), "Order To")
			This.Agregar("Palette", Set("Palette"), "Palette")
			This.Agregar("Path", Set("Path"), "Path To")
			This.Agregar("Pdsetup", Set("Pdsetup"), "Pdsetup To")
			This.Agregar("Point", Set("Point"), "Point To")
			This.Agregar("Printer", Set("Printer"), "Printer")
			This.Agregar("Procedure", Set("Procedure"), "Procedure To")
			This.Agregar("Readborder", Set("Readborder"), "Readborder")
			This.Agregar("Refresh", Set("Refresh"), "Refresh To")
			*!*		This.Agregar("Relation", Set("Relation"), "Relation")
			This.Agregar("ReportBehavior", Set("ReportBehavior"), "ReportBehavior")
			This.Agregar("Reprocess", Set("Reprocess"), "Reprocess To")
			This.Agregar("Resource", Set("Resource"), "Resource")
			This.Agregar("SQLBuffering", Set("SQLBuffering"), "SQLBuffering")
			This.Agregar("Safety", Set("Safety"), "Safety")
			This.Agregar("Seconds", Set("Seconds"), "Seconds")
			*!*		This.Agregar("Skip", Set("Skip"), "Skip")
			This.Agregar("Space", Set("Space"), "Space")
			This.Agregar("Status", Set("Status"), "Status")
			This.Agregar("Status Bar", Set("Status Bar"), "Status Bar")
			This.Agregar("Step", Set("Step"), "Step")
			This.Agregar("Strictdate", Set("Strictdate"), "Strictdate To")
			This.Agregar("Sysformats", Set("Sysformats"), "Sysformats")
			This.Agregar("Sysmenu", Set("Sysmenu"), "Sysmenu")
			This.Agregar("TableValidate", Set("TableValidate"), "TableValidate To")
			This.Agregar("Talk", Set("Talk"), "Talk")
			This.Agregar("Textmerge", Set("Textmerge"), "Textmerge")
			This.Agregar("Topic", Set("Topic"), "Topic To")
			This.Agregar("Trbetween", Set("Trbetween"), "Trbetween")
			This.Agregar("Typeahead", Set("Typeahead"), "Typeahead To")
			This.Agregar("Udfparms", Set("Udfparms"), "Udfparms To")
			This.Agregar("Unique", Set("Unique"), "Unique")
			This.Agregar("TablePrompt", Set("TablePrompt"), "TablePrompt")

			*!*		This.Agregar("View", Set("_View"), "View")

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE Save
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Restore
	*!* Description...: Restaura las variables de entorno
	*!* Date..........: Viernes 30 de Septiembre de 2005 (16:07:34)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Gestor de Reportes
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Restore(  ) As Void;
			HELPSTRING "Restaura las variables de entorno"

		Local loVar As Object
		Local lcCommand As String


		Try

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )

			lcCommand = ""
			Set TablePrompt Off

			*!*				Strtofile( "", "RestoreEnv.prg" )
			For Each loVar In This.Variables


				If Set( loVar.Nombre ) # loVar.Valor

					lcCommand = [SET ] + loVar.Comando + [ ] + Any2Char( loVar.Valor )

					Try
						*!*							Strtofile( lcCommand + Chr(13), "RestoreEnv.prg", 1 )
						&lcCommand

					Catch To oErr
						loError.cRemark = loError.cRemark + ;
							"Comando: " + lcCommand + CR

					Finally

					Endtry

				Endif
			Endfor
		Catch To loErr
			loError.Process( loErr )
			Throw loError

		Finally

		Endtry


	Endproc
	*!*
	*!* END PROCEDURE Restores
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Agregar
	*!* Description...: Agrega una variable a la colección Variables
	*!* Date..........: Viernes 30 de Septiembre de 2005 (16:19:38)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Gestor de Reportes
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Agregar( Nombre As String,;
			Valor As Variant,;
			Comando As String ) As Void;
			HELPSTRING "Agrega una variable a la colección Variables"

		Try


			loVar = Createobject( "Empty" )
			AddProperty( loVar, "Nombre", Nombre )
			AddProperty( loVar, "Valor", Valor )
			AddProperty( loVar, "Comando", Comando )
			This.Variables.AddItem( loVar, Nombre )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE Agregar
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Viernes 30 de Septiembre de 2005 (16:16:17)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Gestor de Reportes
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy(  ) As Void

		Try


			If Vartype(This.Variables)=="O"
				This.Variables.Remove(-1)
			Endif

			This.Variables = Null

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE Destroy
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Environment
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColForms
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Colección de las instancias de los formularios del sistema
*!* Date..........: Viernes 10 de Noviembre de 2006 (11:17:21)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ColForms As PrxCollection Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="addform" type="method" display="AddForm" />] + ;
		[<memberdata name="addformtowindowmenu" type="method" display="AddFormToWindowMenu" />] + ;
		[<memberdata name="removeformfromwindowmenu" type="method" display="RemoveFormFromWindowMenu" />] + ;
		[<memberdata name="removeform" type="method" display="RemoveForm" />] + ;
		[<memberdata name="clear" type="method" display="Clear" />] + ;
		[<memberdata name="refreshmenu" type="method" display="RefreshMenu" />] + ;
		[<memberdata name="createwindowmenu" type="method" display="CreateWindowMenu" />] + ;
		[<memberdata name="cascadewindow" type="method" display="CascadeWindow" />] + ;
		[</VFPData>]


	#If .F.
		Local This As ColForms Of "FW\TierAdapter\Comun\AbstractApplication.prg"
	#Endif

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddForm
	*!* Description...: Agrega un formulario a la colección
	*!* Date..........: Viernes 10 de Noviembre de 2006 (11:20:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure AddForm( oForm As Form ) As Void;
			HELPSTRING "Agrega un formulario a la colección"

		Try

			This.AddItem( oForm, oForm.cKeyName )
			This.AddFormToWindowMenu( oForm )
			_Screen.oApp.oMainToolbar.Show()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally
			loError = .F.
			oForm = .F.

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE AddForm
	*!*
	*!* ///////////////////////////////////////////////////////



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: RemoveFormFromWindowMenu
	*!* Description...: Remueve al formulario del menú "Ventana"
	*!* Date..........: Viernes 10 de Noviembre de 2006 (11:29:56)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure RemoveFormFromWindowMenu( oForm As Form ) As Void

		Try


			***Release Bar Getbar("Window", tnBar) Of Window
			***Release Bar tnBar Of Window

			Local lnBar As Integer

			If Popup("Window")
				For lnBar = Cntbar("Window") To 1 Step -1
					If Prmbar("Window", Getbar("Window", lnBar)) = oForm.Caption
						Release Bar Getbar("Window", lnBar) Of Window
						Exit
					Endif
				Endfor

				If This.Count = 0
					*- now menu is empty so remove it
					Release Popup Window Extended
					Release Pad Window Of _Msysmenu
				Endif
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally
			loError = .F.
			oForm = .F.

		Endtry



	Endproc
	*!*
	*!* END PROCEDURE RemoveFormFromWindowMenu
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: RemoveForm
	*!* Description...: Remueve al formulario de la colección
	*!* Date..........: Viernes 10 de Noviembre de 2006 (12:40:58)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	*!*		Procedure RemoveForm( ccKeyName As String,;
	*!*				nBar As Integer ) As Void;
	*!*				HELPSTRING "Remueve al formulario de la colección"

	Procedure RemoveForm( oForm As Form ) As Void;
			HELPSTRING "Remueve al formulario de la colección"

		Try

			If !Empty( This.GetKey( oForm.cKeyName ))
				This.Remove( oForm.cKeyName )
			Endif

			This.RemoveFormFromWindowMenu( oForm )
			If This.Count = 0
				_Screen.oApp.oMainToolbar.Hide()

				_Screen.oApp.oButtons.Close 	= .F.
				_Screen.oApp.oButtons.Delete 	= .F.
				_Screen.oApp.oButtons.Edit 		= .F.
				_Screen.oApp.oButtons.New 		= .F.
				_Screen.oApp.oButtons.Open 		= .F.
				_Screen.oApp.oButtons.Report 	= .F.
				_Screen.oApp.oButtons.Save 		= .F.
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally
			loError = .F.
			oForm = .F.

		Endtry


	Endproc
	*!*
	*!* END PROCEDURE RemoveForm
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: RefreshMenu
	*!* Description...: Refresca el menú por si cambio el Caption
	*!* Date..........: Viernes 10 de Noviembre de 2006 (17:00:24)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure RefreshMenu( oForm As Form ) As Void;
			HELPSTRING "Refresca el menú por si cambio el Caption"
		Local lcFormName As String

		Try

			This.RemoveFormFromWindowMenu( oForm )
			This.AddFormToWindowMenu( oForm )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally

		Endtry



	Endproc
	*!*
	*!* END PROCEDURE RefreshMenu
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Clear
	*!* Description...: Vacía la colección
	*!* Date..........: Viernes 10 de Noviembre de 2006 (12:41:45)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Clear(  ) As Void;
			HELPSTRING "Vacía la colección"

		This.Remove( -1 )

	Endproc
	*!*
	*!* END PROCEDURE Clear
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CascadeWindow
	*!* Description...: Acomoda todas las ventanas en forma de cascada
	*!* Date..........: Sábado 11 de Noviembre de 2006 (11:42:27)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure CascadeWindow(  ) As Void;
			HELPSTRING "Acomoda todas las ventanas en forma de cascada"
		Try

			Local lnLeft As Integer,;
				lnTop As Integer

			lnTop = 0
			lnLeft = 0

			Local oForm As Form
			Local lnAlwaysOnTop As Boolean

			For Each oForm In _Screen.oApp.oColForms
				lnAlwaysOnTop = oForm.AlwaysOnTop
				oForm.AlwaysOnTop = .T.
				oForm.Top = lnTop
				oForm.Left = lnLeft
				lnTop = lnTop + 30
				lnLeft = lnLeft + 30
				oForm.AlwaysOnTop = lnAlwaysOnTop
			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally
			oForm = .F.

		Endtry



	Endproc
	*!*
	*!* END PROCEDURE CascadeWindow
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateWindowMenu
	*!* Description...: Crea el menú "Ventana"
	*!* Date..........: Viernes 10 de Noviembre de 2006 (18:26:59)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure CreateWindowMenu(  ) As Void;
			HELPSTRING "Crea el menú 'Ventana'"

		Define Pad Window Of _Msysmenu Prompt "\<Ventana" Color Scheme 3 ;
			KEY Alt+V, "ALT+V" ;
			MESSAGE "Selección de ventana"
		On Pad Window Of _Msysmenu Activate Popup Window

		Define Popup Window Margin Relative Shadow Color Scheme 4

		Define Bar 1 Of Window Prompt "Ca\<scada" ;
			PICTRES _mwi_cascade ;
			MESSAGE "Acomoda las ventanas en forma de cascada"

		Define Bar 2 Of Window Prompt "Cerrar \<Todos" ;
			PICTURE "fw\comunes\image\bmp\Close.bmp" ;
			MESSAGE "Cierra todas las ventanas abiertas"

		On Selection Bar 1 Of Window _Screen.oApp.oColForms.CascadeWindow()
		On Selection Bar 2 Of Window _Screen.oApp.CloseAll()

		Define Bar 3 Of Window Prompt "\-"


		On Selection Menu _Msysmenu



	Endproc
	*!*
	*!* END PROCEDURE CreateWindowMenu
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddFormToWindowMenu
	*!* Description...: Agrega el fromulario al menú "Ventana"
	*!* Date..........: Viernes 10 de Noviembre de 2006 (11:28:03)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure AddFormToWindowMenu( oForm As Form ) As Void

		Try


			Local lnBar As Integer
			Local lcFormName As String


			If !Popup("Window")
				*- need to define Windows menu
				This.CreateWindowMenu()
			Endif

			lnBar = oForm.nBar
			If Empty( lnBar )

				*-- Find the next available bar number
				If Cntbar("Window") = 0 Or ;
						GETBAR("Window", Cntbar("Window")) < 0     && At a Fox system BAR
					lnBar = Cntbar("Window") + 1
				Else
					lnBar = Getbar("Window", Cntbar("Window")) + 1
				Endif
			Endif

			Local lcCaption As String
			If Empty( oForm.Caption )
				lcCaption = oForm.OldCaption

			Else
				lcCaption = oForm.Caption

			Endif



			Define Bar lnBar Of Window Prompt Alltrim( lcCaption ) ;
				PICTURE oForm.Icon

			lcFormName = oForm.Name
			On Selection Bar lnBar Of Window Activate Window &lcFormName

			oForm.nBar = lnBar

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally
			loError = .F.
			oForm = .F.

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE AddFormToWindowMenu
	*!*
	*!* ///////////////////////////////////////////////////////



Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColForms
*!*
*!* ///////////////////////////////////////////////////////
