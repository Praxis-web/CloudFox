Lparameters nMoneda_Id as Integer 

Local loMonedas As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
Local loMoneda as Object 

* Singleton de la coleccion Monedas

Try
	
	If Empty( nMoneda_Id ) 
		nMoneda_Id = 1 
	EndIf
	
	loGlobalSettings 	= NewGlobalSettings()
	
	loMonedas	= loGlobalSettings.oMonedas 
	loMoneda 	= loMonedas.GetItem( Transform( nMoneda_Id )) 

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loMonedas			= Null
	loGlobalSettings 	= Null

Endtry

Return loMoneda