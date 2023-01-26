#INCLUDE "FW\Comunes\Include\Praxis.h"

External File "v:\CloudFox\Fw\Comunes\Image\Modulos\Utiles.jpg",;
	"v:\CloudFox\Fw\Comunes\Image\Modulos\Utiles.ico"


External Procedure ;
	"v:\CloudFox\Clientes\Utiles\Prg\utDataDictionary.prg",;
	"v:\CloudFox\Clientes\Utiles\Prg\utIndexa.prg",;
	"v:\CloudFox\Clientes\Utiles\Prg\utRutina.prg"

*!* ///////////////////////////////////////////////////////
*!* PROCEDURE.....: Utiles
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

Local loMain As oUtiles Of Clientes\Utiles\Prg\Utiles.Prg

Try
	Close Databases All

	If Empty( tcAppName )
		tcAppName = "Utiles"
	Endif

	If Empty( tcVersion )
		tcVersion = "1.0"
	Endif

	If Empty( tcUser )
		tcUser = ""
	Endif

	loMain = Createobject( "oUtiles", ;
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

Define Class oUtiles As prxApplication Of "fw\sysAdmin\prg\saMain.prg"

	#If .F.
		Local This As oUtiles Of Of Clientes\Utiles\Prg\Utiles.Prg
	#Endif

	* Nombre del archivo donde se guardan las variables DRVx
	cParameFileName = "Clientes\Utiles\ArParame"
	cRootWorkFolder = "Clientes\Utiles\"
	cDBFMenu 		= "Clientes\Utiles\Utiles\Utiles"
	cScreenIcon 	= "v:\CloudFox\fw\Comunes\Image\Modulos\Utiles.ico"
	cAppLogoSource 	= "v:\CloudFox\Fw\Comunes\Image\Modulos\Utiles.jpg"

	nModuloId		= MDL_UTILES

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
					This.cDBFMenu = "Datos\Utiles"
				Endif

				MenuLoader( This.cDBFMenu, This.oUser.Clave )

			Catch To loErr
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.Process ( m.loErr )
				Throw loError

			Finally

			Endtry

		Endwith

	Endproc &&    BuildMainMenu


	*!* ///////////////////////////////////////////////////////
	*!* FUNCTION......: SetEnvironment
	*!* DESCRIPTION...:
	*!* DATE..........: MARTES 29 DE MARZO DE 2005 (19:50:09)
	*!* AUTHOR........: RICARDO AIDELMAN
	*!* PROJECT.......: VISUAL PRAXIS BETA 1.0
	*!* -------------------------------------------------------
	*!* MODIFICATION SUMMARY
	*!* R/0001  -
	*!*
	*!*
	Function SetEnvironment() As VOID

		Try

			DoDefault()
*!*				Set Procedure To "Clientes\Contable\Prg\CoRutina.prg" Additive
*!*				Set Procedure To "Clientes\Stock\prg\strutina.prg" Additive

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endfunc &&    SetEnvironment


Enddefine


******************************************************************************************************************************

