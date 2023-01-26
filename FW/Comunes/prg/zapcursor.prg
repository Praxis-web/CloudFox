Lparameters tcCursorName as String

Try

	If Empty( tcCursorName )
		tcCursorName = Alias()
	EndIf

	Text To lcCommand NoShow TextMerge Pretext 15
	Delete From <<tcCursorName>> 
	EndText

	&lcCommand

	PackCursor( tcCursorName )
	

Catch To oErr
	Local loError as Errorhandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = NewObject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	Select Alias( tcCursorName )

EndTry