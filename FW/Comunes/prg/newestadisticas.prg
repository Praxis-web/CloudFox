Local lcCommand As String
Local loEstadisticas As oEstadisticas Of "Clientes\Estadisticas\prg\esRutina.prg",;
	loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

* Singleton del objeto Estadisticas

Try

	lcCommand = ""

	loGlobalSettings 	= NewGlobalSettings()
	loEstadisticas 		= loGlobalSettings.oEstadisticas

	If Vartype( loEstadisticas ) # "O"

		* RA 2014-02-09(11:17:08)
		* Si se necesita Subclasear Estadisticas, debe inicializarse loGlobalSettings.oEstadisticas en xxGlobales()
		* que es llamada desde SetEnvironment()

		loEstadisticas = Newobject( "oEstadisticas", "Clientes\Estadisticas\prg\esRutina.prg" )
		loGlobalSettings.oEstadisticas  = loEstadisticas

	Endif

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.cRemark = lcCommand
	loError.Process( oErr )
	Throw loError

Finally
	loGlobalSettings 	= Null

Endtry

Return loEstadisticas