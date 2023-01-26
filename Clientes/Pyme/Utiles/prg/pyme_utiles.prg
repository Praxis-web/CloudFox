#INCLUDE "FW\Comunes\Include\Praxis.h"

*!* ///////////////////////////////////////////////////////
*!* PROCEDURE.....: Pyme_Utiles
*!* DESCRIPTION...: programa principal del proyecto
*!* DATE..........: martes 7 de noviembre de 2006 (11:38:36)
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

Local loMain As Pyme_Utiles Of Clientes\Pyme\Utiles\prg\Pyme_Utiles.prg

Try
	Close Databases All

	If !isRuntime()
		Set DataSession To 1
	Endif

	If Empty( tcAppName )
		tcAppName = "Utiles"
	Endif

	If Empty( tcVersion )
		tcVersion = "1.0"
	Endif

	If Empty( tcUser )
		tcUser = ""
	EndIf
	
	loMain = Createobject( "Pyme_Utiles", ;
		tcAppName,;
		tcVersion,;
		tcUser )

	loMain.Start()

Catch To loErr

	Try

		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )

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
Define Class Pyme_Utiles As oUtiles Of Clientes\Utiles\prg\Utiles.prg

	#If .F.
		Local This As Pyme_Utiles Of Clientes\Pyme\Utiles\prg\Pyme_Utiles.prg
	#Endif


	* Nombre del archivo donde se guardan las variables DRVx
	cParameFileName = "Clientes\Pyme\ArParame"
	cRootWorkFolder = "Clientes\Pyme\"
	cDBFMenu 		= "Clientes\Pyme\Utiles\Utiles"

	cDataDictionaryClass 	= "oDataDictionary"
	cDataDictionaryLib 		= "Clientes\Utiles\prg\utDataDictionary.prg"

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

				If isRuntime()
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


Enddefine



