
*
*
Procedure NewDeudores(  ) As Object
	Local lcCommand As String

	Local loDeudores As oDeudores Of "Clientes\Deudores\prg\deRutina.prg"
	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

	* Singleton del objeto Articulo

	Try

		lcCommand = ""
		loGlobalSettings 	= NewGlobalSettings()
		loDeudores  		= loGlobalSettings.oDeudores

		If Vartype( loDeudores ) # "O"

			* RA 09/06/2016(10:02:30)
			* Si se necesita subclasear Deudores, debe inicializarse loGlobalSettings.oDeudores en xxGlobales()
			* que es llamada desde SetEnvironment(), o directamente en SetEnvironment()

			loDeudores = Newobject( "oDeudores", "Clientes\Deudores\prg\deRutina.prg" )
			loGlobalSettings.oDeudores = loDeudores

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

	Return loDeudores

Endproc && NewDeudores
