*!* ///////////////////////////////////////////////////////
*!* Procedure.....: AddColumns
*!* Description...: Agrega campos a un cursor
*!* Date..........: Jueves 9 de Agosto de 2007 (11:23:08)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Lparameters cNewColumns As String,;
	cCursorAlias As String

Local lnNewRows As Integer
Local lcAlias As String
Local llDone As Boolean

Try
	llDone = .F.
	lnNewRows = 0
	lcAlias = ""

	If Empty( cNewColumns )
		llDone = .T.

	Else
		lcAlias = Sys( 2015 )

		If Empty( cCursorAlias )
			cCursorAlias = Alias()
		Endif

		CreateFromCursor( lcAlias, cCursorAlias, lnNewRows, cNewColumns )

		If Used( lcAlias )
			llDone = .T.
			Select Alias( lcAlias )
			Append From Dbf(cCursorAlias)
			Use in Alias( cCursorAlias ) 
			Select * from Alias( lcAlias ) into cursor &cCursorAlias readwrite

		Else
			llDone = .F.

		Endif

	Endif

Catch To oErr
	Local loError As ErrorHandler Of "ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	llDone = .F.
	Throw loError

Finally
	If Used( lcAlias )
		Use In Alias( lcAlias )
	Endif

Endtry

Return llDone

*!*
*!* END PROCEDURE AddColumns
*!*
*!* ///////////////////////////////////////////////////////