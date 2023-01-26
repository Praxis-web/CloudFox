Lparameters tcCursorName As String
Local lcTempCursor As String

Try

	If Empty( tcCursorName )
		tcCursorName = Alias()
	Endif

	lcTempCursor = Sys( 2015 )

	TEXT To lcCommand NoShow TextMerge Pretext 15
	Select * From <<tcCursorName>> With (Buffering=.T.) Where !Deleted() Into Cursor <<lcTempCursor>>
	ENDTEXT

	&lcCommand

	Use In Select( tcCursorName )

	TEXT To lcCommand NoShow TextMerge Pretext 15
	Select * From <<lcTempCursor>> With (Buffering=.T.) Into Cursor <<tcCursorName>> readwrite
	ENDTEXT

	&lcCommand

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	Use In Select( lcTempCursor )
	Select Alias( tcCursorName )

Endtry