Local lcProjectFile As String
Local lcXML As String
Local lcCommand As String
Local lcAlias As String
Local loXA as prxXMLAdapter of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"
Local lcXMLFile as String 

Try


	Close Databases All

	lcAlias = Sys( 2015 )
	lcProjectFile = Getfile( "pjx" )


	If !Empty( lcProjectFile )
	
		Alter Table ( lcProjectFile ) Alter Column SccData Memo NoCPTrans 
	
		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select *
			From <<lcProjectFile>>
			Into Cursor <<lcAlias>> 
		ENDTEXT

		&lcCommand

		lcXMLFile = Putfile( "Guardar Como", "", "xml" )
		
		loXA = Newobject("prxXMLAdapter","prxXMLAdapter.prg")
		loXA.AddTableSchema( lcAlias )
		loXA.RespectCursorCP = .T. 
		loXA.PreserveWhiteSpace = .T. 
		
		
		loXA.ToXML( lcXMLFile, "", .T. )


	Endif


Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )

Finally
	Close Databases All

Endtry