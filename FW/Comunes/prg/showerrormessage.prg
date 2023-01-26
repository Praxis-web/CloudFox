*
* Muestra un mensaje de error
PROCEDURE ShowErrorMessage( cErrorMsg as String ) AS Void;
        HELPSTRING "Muestra un mensaje de error"
	Local lcCommand as String
	
	Try
	
		lcCommand = ""
		
		Do form "v:\Clipper2Fox\Fw\Comunes\scx\ErrorMessage.scx" With cErrorMsg 
		
		
	Catch To oErr
		Local loError as Errorhandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = NewObject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally

	EndTry

EndProc && ErrorMessage