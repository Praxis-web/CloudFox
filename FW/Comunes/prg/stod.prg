Lparameters lcDate as String 
Local lcDD as String
Local lcMM as String 
Local lcYY as String 
Local ldDate as Date 

Try

	lcYY = Substr( lcDate, 1, 4 ) 	
	lcMM = Substr( lcDate, 5, 2 )
	lcDD = Substr( lcDate, 7, 2 ) 
	
	Do Case
	Case InList( Set("Date"), "AMERICAN", "USA", "MDY" )
		ldDate = Ctod( lcMM + "/" + lcDD + "/" + lcYY ) 

	Case InList( Set("Date"), "ANSI", "JAPAN", "TAIWAN", "YMD" )
		ldDate = Ctod( lcYY + "/" + lcMM + "/" + lcDD ) 
		
	Otherwise
		ldDate = Ctod( lcDD + "/" + lcMM + "/" + lcYY ) 
		
	EndCase

Catch To oErr
	Local loError as Errorhandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = NewObject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

EndTry

Return ldDate  