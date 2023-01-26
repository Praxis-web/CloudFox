Local loColTables As oColTables Of "Tools\DataDictionary\prg\oColTables.prg"
Local loColDataBases As oColDataBases Of "Tools\DataDictionary\prg\oColDataBases.prg"
Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
Local loDataBase As oDataBase Of "Tools\DataDictionary\prg\oDataBase.prg"
Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg"
Local loApp As prxApplication Of "FW\SysAdmin\Prg\saMain.prg"

Local lcName As String
Local lcKeyName As String

* Singleton de la colección Tables

Try

	loGlobalSettings = NewGlobalSettings()
	loColTables = loGlobalSettings.oTables

	If Vartype( loColTables ) # "O"

		loApp = loGlobalSettings.oApp
		
		If .T. && loApp.lUseNameSpaces
			loColTables = _NewObject( "oColTables", 'Tools\DataDictionary\prg\oColTables.prg' )
			loColDataBases = NewColDataBases()

			For Each loDataBase In loColDataBases

				If !loDataBase.lExcludeFromDataDictionary

					For Each loTable In loDataBase.oColTables
						loColTables.AddTable( loTable )
					Endfor

				Endif && !loDataBase.lExcludeFromDataDictionary

			Endfor

			loGlobalSettings.oTables = loColTables

		Else


			loColTables = Newobject( "ColTables", "Tools\Sincronizador\ColDataBases.prg" )
			loColDataBases = NewColDataBases()

			For Each loDataBase In loColDataBases

				If !loDataBase.lExcludeFromDataDictionary

					For Each loTable In loDataBase.oColTables
						loColTables.AddTable( loTable )
					Endfor

				Endif && !loDataBase.lExcludeFromDataDictionary

			Endfor

			loGlobalSettings.oTables = loColTables

		Endif


	Endif

Catch To oErr
	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loTable = Null
	loTable = Null
	loDataBase = Null
	loColDataBases = Null
	loGlobalSettings = Null

Endtry

Return loColTables