*!* ///////////////////////////////////////////////////////
*!* Procedure.....: GetMain
*!* Description...: Devuelve una referencia al objeto principal
*!* Date..........: Viernes 23 de Enero de 2009 (12:06:58)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Lparameters oObj As Object

Local loMain As Object

Try

	If Vartype( oObj ) # "O"
		Error "GetMain() debe recibir un referencia a un objeto"
	Endif

	If Pemstatus( oObj, "oParent", 5 ) And Vartype( oObj.oParent ) = "O"
		loMain = GetMain( oObj.oParent )

	Else
		loMain = oObj

	Endif

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry
Return loMain
Endproc
*!*
*!* END PROCEDURE GetMain
*!*
*!* ///////////////////////////////////////////////////////