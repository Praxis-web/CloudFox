Local loColDataBases As oColDataBases Of "Tools\DataDictionary\prg\oColDataBases.prg"
Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
Local loDataBase As oDataBase Of "Tools\DataDictionary\prg\oDataBase.prg"
Local loApp As prxApplication Of "FW\SysAdmin\Prg\saMain.prg"

Local lcApplicationName As String,;
	lcRootFolder As String,;
	lcLibrary As String,;
	lcDD As String

External Procedure ;
	"Tools\DataDictionary\prg\oColDataBases.prg"

* Singleton de la colección DataBases

Try

	loGlobalSettings = NewGlobalSettings()
	loColDataBases = loGlobalSettings.oDataBases

	If Vartype( loColDataBases ) # "O"

		loApp = loGlobalSettings.oApp

		loColDataBases 	= Newobject( "oColDataBases", 'Tools\DataDictionary\prg\oColDataBases.prg' )

		lcDD = Juststem( loApp.cDataDictionaryClass )
		lcLibrary = Forceext( loApp.cDataDictionaryLib, "prg" )
		loDataBase = Newobject( lcDD, lcLibrary )

		loColDataBases.AddItem( loDataBase, Lower( Alltrim(loDataBase.cDataConfigurationKey )))
		loGlobalSettings.oDataBases = loColDataBases

	Endif

Catch To oErr
	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loForm = Null
	loGlobalSettings = Null
	loDataBase = Null
	loApp = Null

Endtry

Return loColDataBases
