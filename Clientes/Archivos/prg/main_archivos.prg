#INCLUDE "FW\Comunes\Include\Praxis.h"

External File "v:\CloudFox\Fw\Comunes\Image\Modulos\Archivos.jpg",;
	"v:\CloudFox\Fw\Comunes\Image\Modulos\Archivos.ico"

*!* ///////////////////////////////////////////////////////
*!* PROCEDURE.....: Archivos
*!* DESCRIPTION...: Programa principal del proyecto
*!* DATE..........: martes 7 de noviembre de 2006 (11:38:36)
*!* AUTHOR........: Ricardo Aidelman
*!* PROJECT.......: SISTEMAS PRAXIS
*!* -------------------------------------------------------
*!* MODIFICATION SUMMARY
*!* R/0001  -
*!*
*!*
Lparameters tcAppName As String, ;
	tcVersion As String,;
	tcUser As String

Local loMain As oArchivos Of Clientes\Archivos\Prg\Archivos.Prg

Try
	Close Databases All

	If Empty( tcAppName )
		tcAppName = "Archivos"
	Endif

	If Empty( tcVersion )
		tcVersion = "1.0"
	Endif

	If Empty( tcUser )
		tcUser = ""
	Endif

	loMain = Createobject( "oArchivos", ;
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

Define Class oArchivos As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

	#If .F.
		Local This As oArchivos Of Clientes\Archivos\Prg\Main_Archivos.Prg
	#Endif

	* Nombre del archivo donde se guardan las variables DRVx
	cParameFileName = "Clientes\Archivos\ArParame"
	cRootWorkFolder = "Clientes\Archivos\"
	cDBFMenu 		= "Clientes\Archivos\Archivos\Archivos"
	cScreenIcon 	= "v:\CloudFox\fw\Comunes\Image\Modulos\Archivos.ico"
	cAppLogoSource 	= "v:\CloudFox\Fw\Comunes\Image\Modulos\Archivos.jpg"

	nModuloId 		= MDL_ARCHIVOS


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

	Procedure BuildMainMenu( tcMenu As String ) As VOID

		With This As prxApplication Of "fw\sysAdmin\prg\saMain.prg"

			Try

				If IsRuntime()
					This.cDBFMenu = "Datos\Archivos"
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


******************************************************************************************************************************