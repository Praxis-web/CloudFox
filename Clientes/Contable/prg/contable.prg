#INCLUDE "FW\Comunes\Include\Praxis.h"

External File "v:\CloudFox\Fw\Comunes\Image\Modulos\Contable.jpg",;
	"v:\CloudFox\Fw\Comunes\Image\Modulos\Contable.ico"


*!* ///////////////////////////////////////////////////////
*!* PROCEDURE.....: Contable
*!* DESCRIPTION...: Programa principal del proyecto
*!* DATE..........: Viernes 13 de Enero de 2023 (15:41:03)
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

Local loMain As oContable Of Clientes\Contable\Prg\Contable.Prg

Try
	Close Databases All

	If Empty( tcAppName )
		tcAppName = "Contable"
	Endif

	If Empty( tcVersion )
		tcVersion = "1.0"
	Endif

	If Empty( tcUser )
		tcUser = ""
	Endif

	loMain = Createobject( "oContable", ;
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

Define Class oContable As prxApplication Of "fw\sysAdmin\prg\saMain.prg"

	#If .F.
		Local This As oContable Of Of Clientes\Contable\Prg\Contable.Prg
	#Endif

	* Nombre del archivo donde se guardan las variables DRVx
	cParameFileName = "Clientes\Contable\ArParame"
	cRootWorkFolder = "Clientes\Contable\"
	cDBFMenu 		= "Clientes\Contable\Contable\Contable"
	cScreenIcon 	= "v:\CloudFox\fw\Comunes\Image\Modulos\Contable.ico"
	cAppLogoSource 	= "v:\CloudFox\Fw\Comunes\Image\Modulos\Contable.jpg"

	nModuloId		= MDL_Contable

	*!* ///////////////////////////////////////////////////////
	*!* PROCEDURE.....: BuildMainMenu
	*!* DESCRIPTION...:
	*!* DATE..........: S�bado 21 de Mayo de 2011 (16:35:54)
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
					This.cDBFMenu = "Datos\Contable"
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

