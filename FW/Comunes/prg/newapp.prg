Lparameters nVersion as Integer 
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

* Singleton de la clase oApp

Try
	
	loGlobalSettings 	= NewGlobalSettings( nVersion )
	loApp 				= loGlobalSettings.oApp 

Catch To oErr
	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loGlobalSettings 	= Null

Endtry

Return loApp