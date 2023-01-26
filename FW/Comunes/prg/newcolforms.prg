
Local loColForms As ColForms Of "Tools\Sincronizador\ColDataBases.prg"
Local loColDataBases As ColDataBases Of "Tools\Sincronizador\ColDataBases.prg"
Local loForm As oForm Of "Tools\Sincronizador\ColDataBases.prg"
Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
Local loDataBase As oDataBase Of "Tools\Sincronizador\ColDataBases.prg"
Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
Local lcName As String
Local lcKeyName As String

* Singleton de la colección Forms

Try
	
	loGlobalSettings = NewGlobalSettings()
	loColForms = loGlobalSettings.oForms

	If Vartype( loColForms ) # "O"

		loColForms = Newobject( "prxCollection", "prxBaseLibrary.prg" )
		loColDataBases = NewColDataBases()

		For Each loDataBase In loColDataBases

			If !loDataBase.lExcludeFromDataDictionary

				For Each loForm In loDataBase.oColForms
					lcKeyName = ""
					lcName = ""

					loForm.Name = Lower( loForm.Name )
					lcKeyName = Lower( loForm.cKeyName )

					loColForms.AddItem( loForm, lcKeyName )

					* Permitir el acceso a la coleccion Forms tanto por loForm.cKeyName
					* como por loForm.Name
					If Lower( loForm.Name ) # Lower( loForm.cKeyName )
						loColForms.AddItem( loForm, loForm.Name )
					Endif

				Endfor


				For Each loTable In loDataBase.oColTables

					For Each loForm In loTable.oColForms
						lcKeyName = ""
						lcName = ""

						loForm.Name = Lower( loForm.Name )
						lcKeyName = Lower( loForm.cKeyName )

						loColForms.AddItem( loForm, lcKeyName )

						* Permitir el acceso a la coleccion Forms tanto por loForm.cKeyName
						* como por loForm.Name
						If Lower( loForm.Name ) # Lower( loForm.cKeyName )
							loColForms.AddItem( loForm, loForm.Name )
						Endif

					Endfor

				EndFor
				
			Endif && !loDataBase.lExcludeFromDataDictionary
			
		EndFor
		
		loGlobalSettings.oForms = loColForms

	Endif

Catch To oErr
	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loForm = Null
	loTable = Null
	loDataBase = Null
	loColDataBases = Null
	loGlobalSettings = Null
	
Endtry

Return loColForms