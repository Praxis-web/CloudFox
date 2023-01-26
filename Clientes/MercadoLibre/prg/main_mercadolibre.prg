#INCLUDE "FW\Comunes\Include\Praxis.h"

Lparameters tcAppName As String, ;
	tcVersion As String,;
	tcUser As String

Local loMain As oMercadoLibre Of Clientes\MercadoLibre\Prg\MercadoLibre.Prg

Try
	Close Databases All

	If Empty( tcAppName )
		tcAppName = "Mercado_Libre"
	Endif

	If Empty( tcVersion )
		tcVersion = "1.0"
	Endif

	If Empty( tcUser )
		tcUser = ""
	Endif

	loMain = Createobject( "oMercadoLibre", ;
		tcAppName,;
		tcVersion,;
		tcUser )

	loMain.Start()

Catch To loErr

	Try
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError


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

Define Class oMercadoLibre As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

	#If .F.
		Local This As oMercadoLibre Of Clientes\MercadoLibre\Prg\Main_MercadoLibre.Prg
	#Endif

	cParameFileName = "Clientes\MercadoLibre\ArParame"
	cRootWorkFolder = "Clientes\MercadoLibre\"
	cDBFMenu 		= "Clientes\MercadoLibre\MercadoLibre"
	cScreenIcon 	= "v:\CloudFox\fw\Comunes\Image\Modulos\Mercado Libre.ico"
	cAppLogoSource 	= "v:\CloudFox\Fw\Comunes\Image\Modulos\Mercado Libre.bmp"

	nModuloId 		= MDL_MELI


	Procedure BuildMainMenu( tcMenu As String ) As VOID

		With This As prxApplication Of "fw\sysAdmin\prg\saMain.prg"

			Try

				If IsRuntime()
					This.cDBFMenu = "Datos\MercadoLibre"
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

	Endproc &&    BuildMainMenu


Enddefine


*
*
Procedure Dummy(  ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""
		External File "v:\CloudFox\FW\Comunes\image\Modulos\Mercado Libre.bmp",;
			"v:\CloudFox\FW\Comunes\image\Modulos\Mercado Libre.ico"


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && Dummy




******************************************************************************************************************************
