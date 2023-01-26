
*
*
Procedure NewStock(  ) As Object
	Local lcCommand As String

	Local loStock As oStock Of "Clientes\Stock\prg\stRutina.prg"
	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

	* Singleton del objeto Articulo

	Try

		lcCommand = ""
		loGlobalSettings 	= NewGlobalSettings()
		loStock  			= loGlobalSettings.oStock

		If Vartype( loStock ) # "O"
			* RA 2014-02-09(11:17:08)
			* Si se necesita subclasear Stock, debe inicializarse loGlobalSettings.oStock en xxGlobales()
			* que es llamada desde SetEnvironment(), o directamente en SetEnvironment()

			loStock = Newobject( "oStock", "Clientes\Stock\prg\stRutina.prg" )
			loStock.lCodigoDeStock 	= ( GetValue( "CodStock", "ar0Art", "N" ) == "S" )
			loGlobalSettings.oStock = loStock
			

		Endif

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally
		loGlobalSettings 	= Null

	Endtry

	Return loStock

Endproc && NewStock