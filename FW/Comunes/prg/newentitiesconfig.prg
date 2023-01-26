
Local loEntitiesConfig As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg
Local loEntityConfig As Object
Local loColDataBases As oColDataBases Of 'Tools\DataDictionary\prg\oColDataBases.prg'
Local loTier As oTier Of "Tools\Sincronizador\ColDataBases.prg"
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
Local loDataBase As oDataBase Of 'Tools\DataDictionary\prg\oDataBase.prg'
Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
Local lcName As String
Local lcKeyName As String

* Singleton de la colección Forms

Try

	loGlobalSettings = NewGlobalSettings()
	loEntitiesConfig = loGlobalSettings.oEntitiesConfig

	If Vartype( loEntitiesConfig ) # "O"


		loEntitiesConfig = _Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.Prg" )
		loColDataBases = NewColDataBases()

		For Each loDataBase In loColDataBases

			If !loDataBase.lExcludeFromDataDictionary

				For Each loTable In loDataBase.oColTables
					If !Empty( loTable.cBaseClass )

						loEntityConfig = Createobject( "Empty" )

						AddProperty( loEntityConfig, "cBaseClass", loTable.cBaseClass )
						AddProperty( loEntityConfig, "cBaseClassLib", loTable.cBaseClassLib )

						loObj = loEntitiesConfig.GetItem( loTable.cBaseClass )

						If Vartype( loEntitiesConfig.GetItem( loTable.cBaseClass ) ) # "O"
							loEntitiesConfig.AddItem( loEntityConfig, loTable.cBaseClass )
						Endif

					Endif

				Endfor

			Endif && !loDataBase.lExcludeFromDataDictionary

		Endfor

		loGlobalSettings.oEntitiesConfig = loEntitiesConfig

	Endif

Catch To oErr
	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loTier = Null
	loTable = Null
	loDataBase = Null
	loColDataBases = Null
	loGlobalSettings = Null

Endtry

Return loEntitiesConfig





*!*	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
*!*	Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
*!*	Local loEntitiesConfig As prxCollection Of "Fw\Comun\Prg\prxBaseLibrary.prg"
*!*	Local loECFG As TierConfig Of "Fw\TierAdapter\Comun\TierConfig.prg"
*!*	Local loEntity As TierConfig Of "Fw\TierAdapter\Comun\TierConfig.prg"
*!*	Local loTier As Object
*!*	Local loApp As AbstractApplication Of "FW\TierAdapter\Comun\AbstractApplication.prg"

*!*	* Singleton de la colección DataDictionary

*!*	Try

*!*		loGlobalSettings = NewGlobalSettings()
*!*		loEntitiesConfig = loGlobalSettings.oEntitiesConfig

*!*		If Vartype( loEntitiesConfig ) # "O"

*!*			loApp = loGlobalSettings.oApp

*!*			loECFG = Newobject( loApp.cApplicationName, ;
*!*				Addbs( loApp.cRootFolder ) + "Prg\Ecfg_" + loApp.cApplicationName + ".prg" )

*!*			loEntitiesConfig = Newobject( "TierConfig", "TierConfig.prg" )

*!*			For Each loEntity In loECFG

*!*				Assert Pemstatus( loEntity, 'oColTiers', 5 ) Message 'No tiene oColTiers'
*!*
*!*				For Each loTier In loEntity.oColTiers

*!*					loTier.ObjectName  = Lower( loTier.ObjectName )
*!*					loTier.TierLevel = Lower( loTier.TierLevel )

*!*					loEntitiesConfig.AddItem( loTier, loTier.ObjectName + "_" + loTier.TierLevel )

*!*				Endfor
*!*			Endfor

*!*			loGlobalSettings.oEntitiesConfig = loEntitiesConfig

*!*		Endif

*!*	Catch To oErr
*!*		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
*!*		loError.Process( oErr )
*!*		Throw loError

*!*	Finally
*!*		loApp = Null
*!*		loECFG = Null
*!*		loTier = Null
*!*		loEntity = Null
*!*		loGlobalSettings = Null

*!*	Endtry

*!*	Return loEntitiesConfig
