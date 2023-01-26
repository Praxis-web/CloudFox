*
* Convierte un vector en un cursor
PROCEDURE ArrayToCursor( aArray, cCursorName as String ) AS Void;
        HELPSTRING "Convierte un vector en un cursor"
	Local lcCommand as String
	Local lnRows as Integer,;
	lnColumns as Integer,;
	i as Integer  
	
	Try
	
	Set Step On 
		lcCommand = ""
		lnRows = Alen( aArray, 1 )
		lnColumns = Alen( aArray, 2 )  
		
		Text To lcCommand NoShow TextMerge Pretext 15
		Create Cursor <<cCursorName>> (
			Id I,
		EndText
		
		For i = 1 to lnRows  
			
		EndFor

		
		&lcCommand

		
		
	Catch To oErr
		Local loError as Errorhandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = NewObject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally

	EndTry

EndProc && ArrayToCursor