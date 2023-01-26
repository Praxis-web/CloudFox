#INCLUDE "FW\Comunes\Include\Praxis.h"

External File "v:\CloudFox\Fw\Comunes\Image\Modulos\Deudores.jpg",;
	"v:\CloudFox\Fw\Comunes\Image\Modulos\Deudores.ico"

*!* ///////////////////////////////////////////////////////
*!* PROCEDURE.....: Ctta_Ctte
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

Local loMain As oCtta_Ctte Of Clientes\Ctta_Ctte\Prg\Main_Ctta_Ctte.Prg

Try
	Close Databases All

	If Empty( tcAppName )
		tcAppName = "Cuentas_Corrientes"
	Endif

	If Empty( tcVersion )
		tcVersion = "1.0"
	Endif

	If Empty( tcUser )
		tcUser = ""
	Endif

	loMain = Createobject( "oCtta_Ctte", ;
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

Define Class oCtta_Ctte As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

	#If .F.
		Local This As oCtta_Ctte Of Clientes\Ctta_Ctte\Prg\Main_Ctta_Ctte.Prg
	#Endif

	* Nombre del archivo donde se guardan las variables DRVx
	cParameFileName = "Clientes\Ctta_Ctte\ArParame"
	cRootWorkFolder = "Clientes\Ctta_Ctte\"
	cDBFMenu 		= "Clientes\Ctta_Ctte\Ctta_Ctte\Ctta_Ctte"
	cScreenIcon 	= "v:\CloudFox\fw\Comunes\Image\Modulos\Deudores.ico"
	cAppLogoSource 	= "v:\CloudFox\Fw\Comunes\Image\Modulos\Deudores.jpg"

	nModuloId 		= MDL_DEUDORES


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
					This.cDBFMenu = "Datos\Ctta_Ctte"
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