Local loColTables As oColTables Of "Tools\DataDictionary\prg\oColTables.prg"
Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg"
Local loField As oField Of "Tools\DataDictionary\prg\oField.prg"
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
Local lcName As String
Local lcKeyName As String
Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Local loDataDictionary As CollectionBase Of "Tools\Namespaces\prg\CollectionBase.prg" )

* Singleton de la colección DataDictionary

Try

	loGlobalSettings = NewGlobalSettings()
	loDataDictionary = loGlobalSettings.oDataDictionary

	If Vartype( loDataDictionary ) # "O"

*!*			loDataDictionary = Newobject( "prxCollection", "prxBaseLibrary.prg" )
		loDataDictionary = Newobject( "CollectionBase", "Tools\Namespaces\prg\CollectionBase.prg" )

		lcKeyName = ""
		lcName = ""

		loColTables = NewColTables()

		For Each loTable In loColTables
			For Each loField In loTable.oColFields

				lcKeyName = ""
				lcName = ""

				* DAE 2009-09-01(13:00:01)
				* DA 2009-07-13: Para siempre evaluar estos campos en minúscula
				*!*	loTable.Name 		= Lower( loTable.Name )
				*!*	loField.Name 		= Lower( loField.Name )
				*!*	loField.cKeyName 	= Lower( loField.cKeyName )

				lcKeyName = loTable.Name + "." + loField.cKeyName
				
				loDataDictionary.AddItem( loField, Lower( lcKeyName ) )

				* Permitir el acceso al Diccionario de Datos tanto por loField.cKeyName
				* como por loField.Name
				* If loField.Name # loField.cKeyName
				If Lower( loField.Name ) # Lower( loField.cKeyName )

					lcName = loTable.Name + "." + loField.Name
					* loDataDictionary.AddItem( loField, lcName )
					loDataDictionary.AddItem( loField, Lower( lcName ) )

				Endif

			Endfor

		Endfor

		loGlobalSettings.oDataDictionary = loDataDictionary

	Endif

Catch To oErr
	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loTable = Null
	loColTables = Null
	loField = Null
	loGlobalSettings = Null

Endtry

Return loDataDictionary