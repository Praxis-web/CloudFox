#INCLUDE "FW\Comunes\Include\Praxis.h"

*!* ///////////////////////////////////////////////////////
*!* PROCEDURE.....: PymeArchivos 
*!* DESCRIPTION...: programa principal del proyecto
*!* DATE..........: Sábado 4 de Septiembre de 2021 (17:59:03)
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

Local loMain As PymeArchivos Of Clientes\Pyme\Archivos\prg\PymeArchivos.prg

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
	EndIf
	
	loMain = Createobject( "PymeArchivos", ;
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
Define Class PymeArchivos As oArchivos Of Clientes\Archivos\Prg\Main_Archivos.Prg

	#If .F.
		Local This As PymeArchivos Of v:\CloudFox\Clientes\Pyme\Archivos\prg\Pyme_Archivos.prg
	#Endif


	* Nombre del archivo donde se guardan las variables DRVx
	cParameFileName = "Clientes\Pyme\ArParame"
	cRootWorkFolder = "Clientes\Pyme\"
	cDBFMenu 		= "Clientes\Pyme\Archivos\Archivos"

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