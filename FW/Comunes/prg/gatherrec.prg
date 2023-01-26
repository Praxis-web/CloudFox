*
* 
PROCEDURE GatherRec( oRec as Object, cAlias as String ) AS Void
	Local lcCommand as String,;
	lcAlias as String,;
	lcFieldName as String 
	
	Local lnLen as Integer,;
	i as Integer  
	
	Local loReg as Object 
	
	Try
	
		lcCommand = ""
		lcAlias = Alias() 
		If Empty( cAlias )
			cAlias = Alias() 
		EndIf
		
		Select Alias( cAlias )
		Scatter Memo Name loReg 

		lnLen = AFields( laFields, cAlias )
		
		For i = 1 to lnLen  
			lcFieldName = laFields[i,1]
			Try

				luValue = Evaluate( "oRec." + lcFieldName ) 
				
				Text To lcCommand NoShow TextMerge Pretext 15
				loReg.<<lcFieldName>> = luValue 
				EndText

				&lcCommand
				lcCommand = ""

			Catch To oErr

			Finally

			EndTry
			
		EndFor
		
		Gather Name loReg Memo
		
	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		If !Empty( lcAlias ) 
			Select Alias( lcAlias ) 
		EndIf

	EndTry

EndProc && GatherRec

