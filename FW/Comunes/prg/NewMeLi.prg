Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
Local loMeli As oMeLi Of "Clientes\Mercado Libre\Prg\M_Libre.prg"

* Singleton de la clase Mercado Libre

Try
	
	loGlobalSettings 	= NewGlobalSettings()
	loMeli   			= loGlobalSettings.oMeLi 

	If Vartype( loMeli ) # "O"
	
		loMeli = NewObject( "oMeLi", "Clientes\Mercado Libre\Prg\M_Libre.prg" ) 	

		loGlobalSettings.oMeLi = loMeli  

	Endif


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError

Finally
	loGlobalSettings 	= Null

Endtry

Return loMeli  
