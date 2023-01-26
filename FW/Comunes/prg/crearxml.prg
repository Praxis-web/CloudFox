*
* Crea un XML para pruebas con ReportTest
Procedure CrearXML( cTableList As String,;
		cXmlName As String ) As Void;
		HELPSTRING "Crea un XML para pruebas con ReportTest"

	Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"
	Local lcFileName As String
	Local i As Integer,;
		lnLen As Integer

	Try

		If Empty( cTableList )
			cTableList = Alias()
		Else 
			cTableList = Strtran( cTableList, Chr( 9 ), "" )
		Endif

		If Empty( cXmlName )
			cXmlName = ""
		Endif

		If !Empty( cTableList )

			lcFileName = Putfile( "", cXmlName, "Xml" )

			If !Empty( lcFileName )

				loXA = Newobject("prxXMLAdapter","prxXMLAdapter.prg")

				lnLen = Getwordcount( cTableList, "," )

				For i = 1 To lnLen
					loXA.AddTableSchema( Alltrim( Getwordnum( cTableList, i, "," )))
				Endfor

				loXA.PreserveWhiteSpace = .T.
				loXA.ToXML( lcFileName, "", .T. )

			Endif

		Else
			Stop( "No hay ningun cursor abierto", "CrearXML" )

		Endif


	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loXA = Null

	Endtry

Endproc && CrearXML