*
*
Procedure NewConsumirAPI() As Object
	Local lcCommand As String

	Local loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg"
	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

	* Singleton del objeto oConsumirAPI

	Try

		lcCommand = ""
		loGlobalSettings 	= NewGlobalSettings()
		loConsumirAPI 		= loGlobalSettings.oConsumirAPI

		If .T. && Vartype( loConsumirAPI ) # "O"
			loConsumirAPI = Newobject( "ConsumirAPI", "FW\Comunes\prg\BackEndSettings.prg" )
			loGlobalSettings.oConsumirAPI = loConsumirAPI
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

	Return loConsumirAPI

Endproc && NewConsumirAPI


