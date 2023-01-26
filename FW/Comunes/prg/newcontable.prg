
*
*
Procedure NewContable(  ) As Object
	Local lcCommand As String

	Local loContable As oContable Of "Clientes\Contable\prg\coRutina.prg"
	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

	* Singleton del objeto Articulo

	Try

		lcCommand = ""
		loGlobalSettings 	= NewGlobalSettings()
		loContable  		= loGlobalSettings.oContable

		If Vartype( loContable ) # "O"

			* RA 09/06/2016(10:02:30)
			* Si se necesita subclasear Contable, debe inicializarse loGlobalSettings.oContable en xxGlobales()
			* que es llamada desde SetEnvironment(), o directamente en SetEnvironment()

			loContable = Newobject( "oContable", "Clientes\Contabilidad\prg\coRutina.prg" )
			loGlobalSettings.oContable = loContable

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

	Return loContable

Endproc && NewContable
