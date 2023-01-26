Local lcCommand As String
Local loArticulo As Articulo Of "Clientes\Archivos\Prg\Articulo.prg",;
	loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
	loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
	loColDataBases As oColDataBases Of 'Tools\DataDictionary\prg\oColDataBases.prg',;
	loColTables As oColTables Of "Tools\DataDictionary\prg\oColTables.prg"



* Singleton del objeto Articulo

Try

	lcCommand = ""
	loGlobalSettings 	= NewGlobalSettings()
	loArticulo 			= loGlobalSettings.oArticulo

	If Vartype( loArticulo ) # "O"

		* RA 2014-02-09(11:17:08)
		* Si se necesita Subclasear Articulo,
		* debe inicializarse loGlobalSettings.oArticulo en xxGlobales()
		* que es llamada desde SetEnvironment()

		loArticulo = Newobject( "Articulo", "Clientes\Archivos\Prg\Articulo.prg" )
		loGlobalSettings.oArticulo = loArticulo
		
		loColTables   				= NewColTables()
		loTable 					= loColTables.GetItem( "ar1Art" )

		If Vartype( loTable ) # "O"
			loTable 					= loColTables.GetItem( "Productos" )
		EndIf
		
		If Vartype( loTable ) = "O"
			loArticulo.lIntegracionWeb	= loTable.lIntegracionWeb
		EndIf
		

	Endif

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Cremark = lcCommand
	loError.Process( oErr )
	Throw loError

Finally
	loTable 			= Null
	loColDataBases 		= Null
	loGlobalSettings	= Null

Endtry

Return loArticulo