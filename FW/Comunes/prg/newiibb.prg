
Local loIIBB As oIIBB Of "Clientes\Iibb\Prg\Arrutibr.prg"
Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

* Singleton de la clase IIBB

Try
	
	loGlobalSettings 	= NewGlobalSettings()
	loIIBB 				= loGlobalSettings.oIIBB

	If Vartype( loIIBB ) # "O"

		loIIBB = Newobject( "oIIBB", "Clientes\Iibb\Prg\Arrutibr.prg" )
		loIIBB.nProvinciaEntrega = GetValue( "Prov0", "ar0Est", 1 ) 
		loGlobalSettings.oIIBB = loIIBB
		*loIIBB.SincronizarAr4IIBB() 

	Endif

Catch To oErr
	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loGlobalSettings 	= Null

Endtry

Return loIIBB 