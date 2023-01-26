Lparameters tcString as String 
Local lcStr as String 

Try

	If Vartype( tcString ) <> "C"
		tcString = ""
	EndIf
	
	lcStr = tcString 
	  
	If InList( Substr( tcString, 1, 1 ), "'", '"', "[" ) 
		If Left( tcString, 1 ) = Right( tcString, 1 )  
			lcStr = Substr( tcString, 2, Len( tcString ) - 2 )   
		EndIf
	EndIf
	

Catch To oErr
	Local loError as Errorhandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = NewObject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

EndTry

Return lcStr