*
* Devuelve un objeto Table
PROCEDURE GetTable( cTable as String, lStateLess as Boolean ) as Object ;
        HELPSTRING "Devuelve un objeto Table"
	Local lcCommand as String
	
Local loColDataBases As oColDataBases Of "Tools\DataDictionary\prg\oColDataBases.prg"
Local loDataBase As oDataBase Of "Tools\DataDictionary\prg\oDataBase.prg"
Local loColTables As ColTables Of "FW\TierAdapter\Comun\colTables.prg"
Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

	
	
	Try
	
		lcCommand = ""
		If lStateLess
			* RA 11/06/2022(11:03:50)
			* Versión Clon
			loArchivo 		= NewObject( cTable, "Clientes\Utiles\prg\utDataDictionary.prg" )
			loArchivo.lStr 	= .F. 

		Else
			* RA 11/06/2022(11:03:31)
			* Varsión Singleton
			loColTables 	= NewColTables()
			loArchivo 		= loColTables.GetTable( cTable )
			loArchivo.lStr 	= .F. 
		
		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loColTables 	= Null
		loDataBase 		= Null
		loColDataBases 	= Null   

	EndTry
	
	Return loArchivo  

EndProc && GetTable


