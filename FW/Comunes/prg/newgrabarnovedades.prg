*
*
Procedure NewGrabarNovedades(  ) As Object
	Local lcCommand As String

	Local loGrabarNovedades As oGrabarNovedades Of "Rutinas\GrabarNovedades.prg"
	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

	* Singleton del objeto oGrabarNovedades

	Try

		lcCommand = ""
		loGlobalSettings 	= NewGlobalSettings()
		loGrabarNovedades 	= loGlobalSettings.oGrabarNovedades

		If Vartype( loGrabarNovedades ) # "O"

			If GetValue( "GrabNov0", "ar0var", "S" ) = "N"
				* RA 17/01/2020(11:03:44)
				* Esta clase NO HACE NADA
				loGrabarNovedades = Newobject( "oDummy", "Rutinas\GrabarNovedades.prg" )
				loGlobalSettings.oGrabarNovedades = loGrabarNovedades

			Else
				* RA 17/01/2020(10:35:26)
				* Si se necesita subclasear oGrabarNovedades, debe inicializarse
				* loGlobalSettings.oGrabarNovedades en xxGlobales()
				* que es llamada desde SetEnvironment(), o directamente en SetEnvironment()

				loGrabarNovedades = Newobject( "oGrabarNovedades", "Rutinas\GrabarNovedades.prg" )
				loGlobalSettings.oGrabarNovedades = loGrabarNovedades

			Endif

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

	Return loGrabarNovedades

Endproc && NewGrabarNovedades


