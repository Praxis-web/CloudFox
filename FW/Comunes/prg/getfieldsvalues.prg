*!* ///////////////////////////////////////////////////////
*!* Procedure.....: GetFieldsValues
*!* Description...: Devuelve un objeto con los valores del registro actual
*!* Date..........: Lunes 12 de Febrero de 2007 (14:40:06)
*!* Author........: Ricardo Aidelman
*!* Project.......: CMSI
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Lparameters cCursorAlias As String

Local lcAlias As String,;
	loFieldsValues As Object

Try

	loFieldsValues = Null

	If Empty( cCursorAlias )
		cCursorAlias = Alias()
	Endif

	lcAlias = Alias()

	Select Alias( cCursorAlias )
	Scatter Memo Name loFieldsValues

Catch To oErr
	*Throw oErr
	Local loError As ErrorHandler Of "ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )

Finally
	If Used( lcAlias )
		Select Alias( lcAlias )
	Endif

Endtry

Return loFieldsValues

Endproc
*!*
*!* END PROCEDURE GetFieldsValues
*!*
*!* ///////////////////////////////////////////////////////