*
* Devuelve un valor booleano
PROCEDURE IsFalse( uValue as Variant ) AS Boolean;
        HELPSTRING "Devuelve un valor booleano"
	Local lcCommand as String
	Local llFalse as Boolean 
	
	Try
	
		lcCommand = ""
		
		llFalse = !IsTrue( uValue ) 

	Catch To oErr
		Local loError as Errorhandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = NewObject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally

	EndTry
	
	Return llFalse

EndProc && IsFalse