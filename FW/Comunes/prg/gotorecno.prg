*
* Moves the record pointer to the specified record number
* No da error si el registro no existe
PROCEDURE GotoRecno( m.nRecno as Integer,;
	cAlias as String ) as Boolean ;
        HELPSTRING "Moves the record pointer to the specified record number"
	Local lcCommand as String,;
	lcAlias as String 
	Local llOk as Boolean 
	
	Try
	
		lcCommand = ""
		llOk = .T. 
		lcAlias = Alias() 
		
		If Vartype( cAlias ) # "C" 
			cAlias = Alias() 
		EndIf
		
		If Empty( cAlias ) 
			cAlias = Alias() 
		EndIf
		
		Try

			Text To lcCommand NoShow TextMerge Pretext 15
			Goto Record <<m.nRecno>> In <<cAlias>> 
			EndText

			&lcCommand


		Catch To oErr
			Local o as Exception 
			Do Case
			Case oErr.ErrorNo = 5 && El registro está fuera del intervalo.
			
				llOk = .F. 
			
				Text To lcCommand NoShow TextMerge Pretext 15
				Go Top In <<cAlias>> 
				EndText

				&lcCommand
				
			Otherwise
				Throw oErr

			EndCase
		Finally

		EndTry
		
	Catch To oErr
		Local loError as Errorhandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = NewObject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally

	EndTry
	
	Return llOk  

EndProc && GetRecno