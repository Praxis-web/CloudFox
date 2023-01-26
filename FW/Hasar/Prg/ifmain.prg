#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\Hasar\Include\Hasar.h"



External File "v:\Clipper2Fox\Fw\Comunes\Image\Modulos\Hasar.jpg",;
	"v:\Clipper2Fox\Fw\Comunes\Image\Modulos\Hasar.ico"


*!* ///////////////////////////////////////////////////////
*!* Procedure.....: Main
*!* Description...: Programa principal del Proyecto
*!* Date..........: Martes 7 de Noviembre de 2006 (11:38:36)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*
Lparameters tcAppName As String, ;
	tcVersion As String,;
	tcUser As String

Local loMain As ArchivosApp Of Of Erp\Archivos\Prg\Main.Prg
Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

Try

	Close Databases All

	If !IsRuntime()
		Set DataSession To
	Endif

	If Empty( tcAppName )
		tcAppName = "Hasar"
	Endif

	If Empty( tcVersion )
		tcVersion = "1.0"
	Endif

	If Empty( tcUser )
		tcUser = ""
	Endif

	loMain = Createobject( "HasarApp", ;
		tcAppName,;
		tcVersion,;
		tcUser )

	loMain.Start()

Catch To oErr

	Try
		loError.Process( oErr )
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )

	Catch
		Do While Vartype( oErr.UserValue ) == "O"
			oErr = oErr.UserValue

		Enddo

		lcText = "No se pudo ejecutar la Aplicación" + CR + CR
		lcText = lcText + "[  Método   ] " + oErr.Procedure + CR + ;
			"[  Línea N° ] " + Transform(oErr.Lineno) + CR + ;
			"[  Comando  ] " + oErr.LineContents + CR  + ;
			"[  Error    ] " + Transform(oErr.ErrorNo) + CR + ;
			"[  Mensaje  ] " + oErr.Message  + CR + ;
			"[  Detalle  ] " + oErr.Details

		= Messagebox( lcText, 16, "Error Grave" )

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

Return


Define Class HasarApp As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"


	#If .F.
		Local This As HasarApp Of FW\Hasar\Prg\IFMain.Prg
	#Endif

	* Nombre del archivo donde se guardan las variables DRVx
	cParameFileName = "FW\Hasar\ArParame"

	cDBFMenu 		= "FW\Hasar\prHasar"
	cScreenIcon 	= "v:\Clipper2Fox\fw\Comunes\Image\Modulos\Hasar.ico"
	cAppLogoSource 	= "v:\Clipper2Fox\Fw\Comunes\Image\Modulos\Hasar.jpg"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="inicializarcontroladorfiscal" type="method" display="InicializarControladorFiscal" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: BuildMainMenu
	*!* Description...:
	*!* Date..........: Miércoles 30 de Marzo de 2005 (21:27:24)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.0
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure BuildMainMenu( tcMenu As String ) As Void

		With This As prxApplication Of "FW\Actual\Comun\Main.prg"

			Local lcDBFMenu As String

			Try

				This.oError.TraceLogin = "Build Main Menu"


				Do Case
					Case IsRuntime()
						This.cDBFMenu = "Datos\prHasar"

					Otherwise

				Endcase

				MenuLoader( This.cDBFMenu, This.oUser.Clave )

			Catch To oErr
				.lIsOk = .F.
				Throw


			Finally

			Endtry

		Endwith

	Endproc && BuildMainMenu


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

		Local loRestoreVars As oRestoreVars Of "V:\Clipper2fox\Fw\Sysadmin\Prg\Samain.prg"
		Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"	,;
			loFiltro As Object,;
			loColFiltros As CollectionBase Of Tools\Namespaces\prg\CollectionBase.prg

		Try

			DoDefault()
			Set Procedure To "FW\Hasar\Prg\Hasar.prg" Additive
			
			loGlobalSettings = NewGlobalSettings()
			loColFiltros = loGlobalSettings.oColFilters

			* Filtro por Articulos Activos

			TEXT To lcFilter NoShow TextMerge Pretext 15
			( Acti1 = "S" )
			ENDTEXT

			loFiltro = Createobject( "Empty" )
			AddProperty( loFiltro, "cTabla", "ar1Art" )
			AddProperty( loFiltro, "cFiltro", lcFilter )

			loColFiltros.AddItem( loFiltro, "ar1Art" )

			loFiltro = Createobject( "Empty" )
			AddProperty( loFiltro, "cTabla", "Articulos" )
			AddProperty( loFiltro, "cFiltro", lcFilter )

			loColFiltros.AddItem( loFiltro, "Articulos" )
			

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loDataDictionary 	= Null
			loEntitiesConfig 	= Null
			loRestoreVars = Null

			loFiltro 			= Null
			loColFiltros 		= Null
			loGlobalSettings 	= Null

		Endtry

	Endfunc && SetEnvironment


	Procedure HookAfterBuildMainMenu()
		Try
			This.InicializarControladorFiscal()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc


	Procedure InicializarControladorFiscal()

		Local loHasar As "Hasar.Fiscal.1"
		Local lcModelo As String
		Local lcMessageText As String, ;
			lnDialogBoxType As Integer, ;
			lcTitleBarText As String, ;
			lnTimeout As Integer, ;
			lcChar As Character

		Try

			Wait "Detectando Cotrolador Fiscal" Window Nowait

			If lHasar 
				loHasar = NewHasar()
			EndIf 

			If lHasar And loHasar.nPuntoDeVenta > 0

				TERMINAL = Transform( loHasar.nPuntoDeVenta )

				If !Empty( loHasar.cModelo )
*!*						lcMessageText = "Controlador Fiscal " + loHasar.cModelo + Chr(13) +;
*!*							"Detectado a " + Transform( loHasar.Baudios ) + " baudios en COM" + Transform( loHasar.Puerto )
						
					Text To lcMessageText NoShow TextMerge Pretext 03
					Controlador Fiscal <<CF_Modelo[ loHasar.nModelo ]>>
					Detectado a <<loHasar.Baudios>> baudios en COM <<loHasar.Puerto>>
					EndText

					Wait lcMessageText Window Nowait
					Inkey( 2 )

					Text To lcMessageText NoShow TextMerge Pretext 15
					<<Alltrim( _Screen.Caption )>> - Controlador Fiscal <<CF_Modelo[ loHasar.nModelo ]>>
					EndText
					
					_Screen.Caption = lcMessageText 

				Else
					Stop( "Controlador Fiscal NO DETECTADO" )

				Endif

			Else
				If lHasar
					Error "Controlador Fiscal NO CONECTADO"

				Else
					Inform( "Modo Desarrollo" + Chr( 13 ) + "No Hay Un Controlador Fiscal Activo" )
					_Screen.Caption = _Screen.Caption + " - *** MODO DESARROLLO ***"

				Endif

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			This.lExit = .T.

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loHasar = Null
			Wait Clear

		Endtry

		Return
	Endproc

	Procedure Destroy(  ) As Void
		Local loHasar As "Hasar.Fiscal.1"

		Try

			If !This.lOnDestroy And lHasar
				Wait "Cerrando Controlador Fiscal" Window Nowait

				loHasar = NewHasar( .T. )

				If lHasar && loHasar.nPuntoDeVenta > 0
					If Vartype( loHasar ) == "O"
						If Pemstatus( loHasar, "Comenzar", 5 )
							loHasar.Comenzar()
							loHasar.TratarDeCancelarTodo()
							loHasar.Finalizar()
						Endif
					Endif
				Endif
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )

		Finally
			Wait Clear
			loHasar = Null
			DoDefault()

		Endtry




	Endproc && Destroy

	*
	* Setea las variables públicas
	Procedure SetGlobales(  ) As Void;
			HELPSTRING "Setea las variables públicas"

		Local loRestoreVars As oRestoreVars Of "V:\Clipper2fox\Fw\Sysadmin\Prg\Samain.prg"
		Public FS

		Try

			DoDefault()

			Release FS
			Public FS

			FS=Chr(28)  && Field Separator  para HASAR

			If Vartype( CF_Model ) # "C"
				Release CF_Model
				Public CF_Model
				CF_Model=""
			Endif

			If Vartype( lHasar ) # "L"
				Release lHasar
				Public lHasar
				lHasar		= .T.
			Endif

			Public Array CF_Modelo[ 50 ]

			CF_Modelo = "NO DEFINIDO"

			CF_Modelo[ MODELO_614 ]			= "614"
			CF_Modelo[ MODELO_615 ]			= "615"
			CF_Modelo[ MODELO_PR4 ]			= "PR4"
			CF_Modelo[ MODELO_950 ]			= "950"
			CF_Modelo[ MODELO_951 ]			= "951"
			CF_Modelo[ MODELO_262 ]			= "262"
			CF_Modelo[ MODELO_PJ20 ]		= "PJ20"
			CF_Modelo[ MODELO_P320 ]		= "P320"
			CF_Modelo[ MODELO_715 ]			= "715"
			CF_Modelo[ MODELO_PR5 ]			= "PR5"
			CF_Modelo[ MODELO_272 ]			= "272"
			CF_Modelo[ MODELO_PPL8 ]		= "PPL8"
			CF_Modelo[ MODELO_P321 ]		= "9321"
			CF_Modelo[ MODELO_P322 ]		= "P322"
			CF_Modelo[ MODELO_P425 ]		= "P425"
			CF_Modelo[ MODELO_P425_201 ] 	= "P425/201"
			CF_Modelo[ MODELO_PPL8_201 ] 	= "PPL8/201"
			CF_Modelo[ MODELO_P322_201 ] 	= "P322/201"
			CF_Modelo[ MODELO_P330 ] 		= "P330"
			CF_Modelo[ MODELO_P435 ] 		= "P435"
			CF_Modelo[ MODELO_P330_201 ] 	= "P330/201"
			CF_Modelo[ MODELO_PPL9 ] 		= "PPL9"
			CF_Modelo[ MODELO_P330_202 ] 	= "P330/220"
			CF_Modelo[ MODELO_P435_101 ] 	= "P435/101"
			CF_Modelo[ MODELO_715_201 ] 	= "715/201"
			CF_Modelo[ MODELO_PR5_201 ] 	= "PR5/201"
			CF_Modelo[ MODELO_P435_102 ] 	= "P435/102"
			CF_Modelo[ MODELO_PPL23 ] 		= "PPL23"
			CF_Modelo[ MODELO_715_302 ] 	= "715/302"
			CF_Modelo[ MODELO_715_403 ] 	= "715/403"
			CF_Modelo[ MODELO_P330_203 ] 	= "P330/203"
			CF_Modelo[ MODELO_P441 ] 		= "P441"
			CF_Modelo[ MODELO_PPL23_101 ] 	= "PPL23/101"
			CF_Modelo[ MODELO_P435_203 ] 	= "P435/203"
			CF_Modelo[ MODELO_P1120 ] 		= "P1120"



		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loRestoreVars = Null

		Endtry


	Endproc && SetGlobales
Enddefine