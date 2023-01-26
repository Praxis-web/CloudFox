Local loColFreeTables As oColTables Of "Tools\DataDictionary\prg\oColTables.prg"
Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

* Singleton de la colección FreeTables

Try

	loGlobalSettings = NewGlobalSettings()
	loColFreeTables = loGlobalSettings.oTables

	If Vartype( loColFreeTables ) # "O"

		loColFreeTables = _Newobject( "oColTables", "Tools\DataDictionary\prg\oColTables.prg" )
		loColFreeTables.lIsFree = .T.
		loGlobalSettings.oTables = loColFreeTables

	Endif

Catch To oErr
	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loGlobalSettings = Null

Endtry

Return loColFreeTables