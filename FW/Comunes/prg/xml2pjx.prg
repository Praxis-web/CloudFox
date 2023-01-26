Local lcProjectFile As String
Local lcXML As String
Local lcCommand As String
Local lcAlias As String
Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"
Local lcXMLFile As String
Local loTable As Xmltable

Try


	Close Databases All

	lcAlias = Sys( 2015 )
	lcXMLFile = Getfile( "xml" )


	If !Empty( lcXMLFile )

		lcProjectFile = Putfile( "Guardar Como", "", "pjx" )

		loXA = Newobject("prxXMLAdapter","prxXMLAdapter.prg")

		loXA.RespectCursorCP = .T.
		loXA.PreserveWhiteSpace = .T.

		loXA.LoadXML( lcXMLFile, .T. )

		loXA.Tables.Item(1).ToCursor()

		Copy To ( lcProjectFile )


	Endif


Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )

Finally
	Close Databases All

Endtry