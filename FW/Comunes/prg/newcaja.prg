*
*
Procedure NewCaja(  ) As Object
	Local lcCommand As String

	Local loCaja As oCaja Of "Clientes\Caja\Prg\cjRutina.prg"
	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

	* Singleton del objeto Articulo

	Try

		lcCommand = ""
		loGlobalSettings 	= NewGlobalSettings()
		loCaja  			= loGlobalSettings.oCaja

		If Vartype( loCaja ) # "O"

			* RA 09/06/2016(10:02:30)
			* Si se necesita subclasear Caja, debe inicializarse loGlobalSettings.oCaja en xxGlobales()
			* que es llamada desde SetEnvironment(), o directamente en SetEnvironment()

			loCaja = Newobject( "oCaja", "Clientes\Caja\Prg\cjRutina.prg" )
			loGlobalSettings.oCaja = loCaja

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loGlobalSettings 	= Null

	Endtry

	Return loCaja

Endproc && NewCaja


