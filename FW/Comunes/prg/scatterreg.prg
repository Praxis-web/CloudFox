*
* Guarda el registro en un objeto
Procedure ScatterReg( lBlank As Boolean,;
		cAlias As String,;
		oRegistro as Object ) As Object;
		HELPSTRING "Guarda el registro en un objeto"
	Local lcCommand As String,;
	lcAlias as String 
	Local loRegistro As Object
	Local lAdditive as Boolean 

	Try

		lcCommand = ""
		lAdditive = .F. 
		lcAlias = Alias() 
		
		If Empty( cAlias )
			cAlias = Alias()
		EndIf
		
		If Vartype( oRegistro ) = "O"
			lAdditive = .T.
			loRegistro = oRegistro  
		EndIf
		
		Select Alias( cAlias )

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Scatter Memo Name loRegistro Fields Except
			TS, UTS, Borrado
		ENDTEXT

		If lBlank
			lcCommand = lcCommand + " Blank"
		EndIf
		
		If lAdditive 
			lcCommand = lcCommand + " Additive"
		EndIf

		&lcCommand
		lcCommand = ""
		

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		If !Empty( lcAlias )
			Select Alias( lcAlias ) 
		EndIf

	Endtry

	Return loRegistro

Endproc && ScatterReg

