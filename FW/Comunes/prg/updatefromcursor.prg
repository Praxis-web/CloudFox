*!* ///////////////////////////////////////////////////////
*!* Procedure.....: UpdateFromCursor
*!* Description...: Actualiza un registro desde otro cursor
*!* Date..........: Lunes 12 de Febrero de 2007 (16:14:24)
*!* Author........: Ricardo Aidelman
*!* Project.......: CMSI
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Lparameters cFromCursor As String,;
	cToCursor As String

Local lcAlias As String,;
	lcField As String

Local luValue As Variant

Local lnLen As Integer,;
	i As Integer


Try

	If Empty( cFromCursor )
		Error "Debe indicar el nombre del cursor origen"
	Endif

	If Empty( cToCursor )
		cToCursor = Alias()
	Endif

	lcAlias = Alias()

	Select( Alias( cToCursor ) )

	lnLen = Afields( laFields )

	For i = 1 To lnLen


		Try
			lcField = laFields[ i, 1 ]
			luValue = Evaluate( cFromCursor + "." + lcField )

			Replace ( lcField ) With  luValue

		Catch To oErr
			*!*				Local loError As UserTierError Of "fw\Actual\ErrorHandler\UserTierError.prg"
			*!*				loError = Newobject( "UserTierError", "UserTierError.prg" )
			*!*				loError.Process( oErr )

*!*				TEXT To lcCommand NoShow TextMerge
*!*				<<oErr.Message>>
*!*				
*!*				lcField = laFields[ <<i>>, 1 ]
*!*				luValue = Evaluate( <<cFromCursor>> + "." + <<lcField>> )

*!*				Replace <<lcField>> with  <<luValue>>
*!*				-----------------------------------------------------------
*!*				ENDTEXT

*!*				Strtofile( Chr(13) + lcCommand, "_UpdateFromCursor.prg", 1 )


		Finally

		Endtry


	Endfor




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

Endproc
*!*
*!* END PROCEDURE UpdateFromCursor
*!*
*!* ///////////////////////////////////////////////////////