*
* Los campos Memo no se pueden levantar desde un archivo de texto
* La función transforma transitoriamente el Memo en un C(250) para el 
* Append From, y luego vuelve a transformarlo a Memo
PROCEDURE AppendFromTxt( cFileName as String, cCursor as String, cDelimiter as Character ) AS Void
	Local lcCommand as String,;
		lcAlias as String

	Local i as Integer,;
		lnLen as Integer

	Try

		lcCommand = ""
		lcAlias = Alias()

		If Empty( cCursor )
			cCursor = lcAlias
		EndIf

		If Empty( cFileName )
			cFileName = cCursor + ".txt"
		EndIf

		If Empty( cDelimiter )
			cDelimiter = "|"
		EndIf

		lnLen = AFields( laFields, cCursor )

		For i = 1 to lnLen
			If laFields[ i, 2 ] = "M"
				laFields[ i, 2 ] = "C"
				laFields[ i, 3 ] = 250
				laFields[ i, 4 ] = 0
			EndIf
		EndFor
		
		Text To lcCommand NoShow TextMerge Pretext 15
		Create Cursor <<cCursor>>_Aux From array laFields
		ENDTEXT

		&lcCommand
		lcCommand = ""
		
		Select Alias( cCursor + "_Aux" )

		Text To lcCommand NoShow TextMerge Pretext 15
		Append From <<cFileName>> DELIMITED WITH CHARACTER <<cDelimiter>>
		ENDTEXT

		&lcCommand
		lcCommand = ""
		
		Select Alias( cCursor )
		
		Text To lcCommand NoShow TextMerge Pretext 15
		Append From Dbf( "<<cCursor>>_Aux" )
		EndText

		&lcCommand
		lcCommand = ""


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Use in Select( cCursor + "_Aux" )
		If !Empty( lcAlias ) 
			Select Alias( lcAlias ) 
		EndIf

	EndTry

EndProc && AppendFromTxt

