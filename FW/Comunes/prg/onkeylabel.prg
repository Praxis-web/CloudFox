#INCLUDE "FW\Comunes\Include\Praxis.h"

Lparameters lnKeyStroke As Integer,;
	loForm as Form 

Local loOnKeyLabel As OnKeyLabel Of "fw\Comunes\prg\OnKeyLabel.prg"
lnKeyStroke = KEY_CTRL_F10

Try

	Push Key Clear

	loOnKeyLabel = Newobject( "OnKeyLabel", "fw\Comunes\prg\OnKeyLabel.prg" )

	Do Case
		Case lnKeyStroke = KEY_CTRL_F10
			loOnKeyLabel.Ctrl_F10()

		Otherwise
			Messagebox( "On Key Label OTRO" )

	Endcase


Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	Pop Key
	loOnKeyLabel = Null

Endtry

*/ ---------------------------------------------------
*!* ///////////////////////////////////////////////////////
*!* Class.........: OnKeyLabel
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Clase de Manejo de OnKeyLabel
*!* Date..........: Domingo 2 de Octubre de 2011 (14:48:51)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class OnKeyLabel As Session

	#If .F.
		Local This As OnKeyLabel Of "fw\Comunes\prg\OnKeyLabel.prg"
	#Endif

	DataSession = 1 && Default Data Session

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ctrl_f10" type="method" display="Ctrl_F10" />] + ;
		[</VFPData>]



	*
	* Manejo de Ctrl+F10
	Procedure Ctrl_F10(  ) As Void;
			HELPSTRING "Manejo de Ctrl+F10"
		Try

			Define Popup Emergente SHORTCUT Relative From Wrows()/2, Wcols()/2

			*!*	Definir el menu.
			Define Bar 1 Of Emergente Prompt "Cancelar \<Proceso" Key P, "" ;
				message "Cancela el proceso en ejecución."

*!*				Define Bar 2 Of Emergente Prompt "Cerrar \<Módulo" Key M, "" ;
*!*					message "Cierra el Módulo actual."

*!*				Define Bar 3 Of Emergente Prompt "\-"

*!*				Define Bar 4 Of Emergente Prompt "Entorno de \<Datos" Key D, "" ;
*!*					message "Abrir el Entorno de Datos."

			On Selection Bar 1 Of Emergente Error "Proceso cancelado por el usuario"
*!*				On Selection Bar 2 Of Emergente Quit
*!*				On Selection Bar 4 Of Emergente Set

			Activate Popup Emergente


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			Deactivate Popup Emergente
			Release POPUPS Emergente EXTENDED 

		Endtry

	Endproc && Ctrl_F10



Enddefine
*!*
*!* END DEFINE
*!* Class.........: OnKeyLabel
*!*
*!* ///////////////////////////////////////////////////////