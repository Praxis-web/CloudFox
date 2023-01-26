#INCLUDE "FW\Comunes\Include\Praxis.h"

*!* ///////////////////////////////////////////////////////
*!* PROCEDURE.....: Pyme_Ctta_Ctte 
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

Local loMain As Pyme_Ctta_Ctte Of Clientes\Pyme\Ctta_Ctte\prg\Pyme_Ctta_Ctte.prg

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
	EndIf
	
	loMain = Createobject( "Pyme_Ctta_Ctte", ;
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
Define Class Pyme_Ctta_Ctte As oCtta_Ctte Of Clientes\Ctta_Ctte\Prg\Main_Ctta_Ctte.Prg

	#If .F.
		Local This As Pyme_Ctta_Ctte Of v:\CloudFox\Clientes\Pyme\Ctta_Ctte\prg\Pyme_Ctta_Ctte.prg
	#Endif


	* Nombre del archivo donde se guardan las variables DRVx
	cParameFileName = "Clientes\Pyme\ArParame"
	cRootWorkFolder = "Clientes\Pyme\"
	cDBFMenu 		= "Clientes\Pyme\Ctta_Ctte\Ctta_Ctte"

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