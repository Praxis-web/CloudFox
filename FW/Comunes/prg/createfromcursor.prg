*!* ///////////////////////////////////////////////////////
*!* Procedure.....: CreateFromCursor
*!* Description...: Crea una estructura vacía de un cursor a partir de otro
*!* Date..........: Lunes 12 de Febrero de 2007 (11:44:27)
*!* Author........: Ricardo Aidelman
*!* Project.......: CMSI
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Lparameters cNewCursorName As String,;
	cFromCursorAlias As String,;
	nEmptyRows As Integer,;
	cExtraFields As String

Local lnNewRows As Integer
Local lcAlias As String,;
lcCursorStructure as String 

Try
	lnNewRows = -1
	
	lcAlias = Alias()

	If Empty( cNewCursorName )
		Error "Debe indicar el nombre del cursor a crear"
	Endif

	cNewCursorName = Strtran( JustStem( cNewCursorName ), " ", "_" )
	
	If Empty( cFromCursorAlias )
		cFromCursorAlias = Alias()
	Endif

	If Empty( nEmptyRows )
		nEmptyRows = 0
	Endif

	If Empty( cExtraFields )
		cExtraFields = ""
	EndIf
	
	lcCursorStructure = GetCursorStructure( cFromCursorAlias, cExtraFields )

	TEXT To lcCommand NoShow TextMerge Pretext 15
	Create Cursor [<<cNewCursorName>>] (<<lcCursorStructure>>)
	ENDTEXT

	&lcCommand

	Local i As Integer
	For i = 1 To nEmptyRows
		Append Blank
	Endfor

	lnNewRows = Reccount()

Catch To oErr
	Local loError As ErrorHandler Of "ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"

	Try
		Strtofile( lcCommand, "lcCommand.prg" )

	Catch

	Finally

	Endtry

	If .f.
		* Asegurarse que el compilador lo incluya en el proyecto
		Do GetCursorStructure.prg
	EndIf


	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError


Finally
	If Used( lcAlias )
		Select Alias( lcAlias )
	Endif

Endtry

Return lnNewRows

*!*
*!* END PROCEDURE CreateFromCursor
*!*
*!* ///////////////////////////////////////////////////////