
*
* Devuelve un valor booleano
PROCEDURE IsTrue( uValue as Variant ) AS Boolean;
        HELPSTRING "Devuelve un valor booleano"
	Local lcCommand as String
	Local llTrue as Boolean 
	
	Try
	
		lcCommand = ""
		
		llTrue = Cast( uValue as Logical ) 

	Catch To oErr
		Local loError as Errorhandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = NewObject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally

	EndTry
	
	Return llTrue

EndProc && IsTrue