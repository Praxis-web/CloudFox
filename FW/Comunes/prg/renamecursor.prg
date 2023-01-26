*!* ///////////////////////////////////////////////////////
*!* Class.........: GeneralStuff
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Devuelve un XML con las tablas renombradas
*!* Date..........: Domingo 20 de Abril de 2008 (13:20:54)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class GeneralStuff As Session

	#If .F.
		Local This As GeneralStuff Of "V:\SistemasPraxisV2\Fw\comunes\Prg\GeneralStuff.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="renamecursors" type="method" display="RenameCursors" />] + ;
		[</VFPData>]




*!* ///////////////////////////////////////////////////////
*!* Procedure.....: RenameCursors
*!* Description...: Devuelve un XML con los cursores renombrados
*!* Date..........: Domingo 20 de Abril de 2008 (13:34:22)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

	Procedure RenameCursors( cXML as String,;
	cNewTablesNames as String ) As String;
		HELPSTRING "Devuelve un XML con los cursores renombrados"


	Try

	Catch To oErr
		Local loError as ErrorHandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = NewObject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process()
		Throw loError

	Finally

	Endtry

	Endproc
*!*
*!* END PROCEDURE RenameCursors
*!*
*!* ///////////////////////////////////////////////////////


Enddefine
*!*
*!* END DEFINE
*!* Class.........: GeneralStuff
*!*
*!* ///////////////////////////////////////////////////////