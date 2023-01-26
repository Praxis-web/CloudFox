*!* ///////////////////////////////////////////////////////
*!* Procedure.....: InsertFromCursor
*!* Description...: Inserta un registro desde otro cursor 
*!* Date..........: Lunes 12 de Febrero de 2007 (16:13:23)
*!* Author........: Ricardo Aidelman
*!* Project.......: CMSI
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -  
*!*
*!*	

Lparameters cFromCursor as String,;
cToCursor as String 

External Procedure ;
	CreateFromCursor.prg,;
	GetFieldsValues.prg


Local lcAlias as String

Try

	lcAlias = Alias()
	
	If Empty( cFromCursor )
		Error "Debe indicar el nombre del cursor origen"
	Endif

	If Empty( cToCursor )
		cToCursor = Alias()
	Endif

	* Si no existe el cursor destino, lo crea
	If !Used( cToCursor )
		CreateFromCursor( cToCursor, cFromCursor )
	EndIf
	
	
	Select Alias( cToCursor )
	
	oValues = GetFieldsValues( cFromCursor )
	
	Insert into &cToCursor From Name oValues


Catch To oErr
	Local loError As ErrorHandler Of "ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError


Finally
	If Used( lcAlias )
		Select Alias( lcAlias )
	Endif

Endtry

Return 

ENDPROC
*!* 
*!* END PROCEDURE InsertFromCursor
*!* 
*!* ///////////////////////////////////////////////////////