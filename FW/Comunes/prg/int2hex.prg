
Lparameters tnInt as Integer

Local lcHex as String 
Local lnInt as Integer,;
lnMod as Integer 

Try


	lcHex = ""
	 
	If tnInt < 16 
		If tnInt < 10
			lcHex = Chr( Asc( "0" ) + tnInt )
			 
		Else
			lcHex = Chr( Asc( "A" ) + ( tnInt - 10 ) )
			
		Endif
 
	Else 
		lnInt = Int( tnInt / 16 )
		lnMod = Mod( tnInt, 16 )
		
		If lnMod < 10
			lcHex = Chr( Asc( "0" ) + lnMod )
			 
		Else
			lcHex = Chr( Asc( "A" ) + ( lnMod - 10 ))
			
		EndIf
		
		lcHex = Int2Hex( lnInt ) + lcHex
			
	EndIf 


Catch To oErr
	Local loError as Errorhandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = NewObject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

EndTry

Return lcHex