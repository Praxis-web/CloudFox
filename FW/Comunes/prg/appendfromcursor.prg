*!* ///////////////////////////////////////////////////////
*!* Procedure.....: AppendFromCursor
*!* Description...: Inserta un grupo de registros desde otro cursor
*!* Date..........: Lunes 12 de Febrero de 2007 (16:13:23)
*!* Author........: Ricardo Aidelman
*!* Project.......: CMSI
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*


Lparameters cFromCursor As String,;
	cToCursor As String,;
	cFilterCriteria As String,;
	lScopeRest As Boolean

External Procedure ;
	InsertFromCursor.prg

Local lcAlias As String
Local lnTally as Integer 

Try

	lcAlias = Alias()
	lnTally = 0



	If Empty( cFromCursor )
		Error "Debe indicar el nombre del cursor origen"
	Endif

	If Empty( cToCursor )
		cToCursor = Alias()
	Endif

	If Empty( cFilterCriteria )
		cFilterCriteria = " !Deleted() "
	Endif

	Select Alias( cFromCursor )


	If lScopeRest
		Scan While Evaluate( cFilterCriteria )
			InsertFromCursor( cFromCursor, cToCursor )
		Endscan

	Else
		Scan For Evaluate( cFilterCriteria )
			InsertFromCursor( cFromCursor, cToCursor )
		Endscan

	Endif

	If !Used( cToCursor )
		* Si no se produce ninguna coincidencia con cFilterCriteria
		* y no existe el cursor destino,
		* se devuelve una estructura vacía
		Select * ;
			From ( cFromCursor ) ;
			Where 1 = 0 ;
			into Cursor ( cToCursor ) nofilter Readwrite
	EndIf
	
	If Used( cToCursor )
		Select Alias( cToCursor )
		lnTally = Reccount() 
		Locate
	EndIf 


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

Return lnTally  

Endproc
*!*
*!* END PROCEDURE AppendFromCursor
*!*
*!* ///////////////////////////////////////////////////////