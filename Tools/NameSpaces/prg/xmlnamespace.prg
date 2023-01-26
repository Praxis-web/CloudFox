#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
	Do 'Tools\namespaces\prg\XmlAdapterBase.prg'
Endif

* XMLNameSpace
Define Class XMLNamespace As Namespacebase Of 'Tools\namespaces\prg\objectnamespace.prg'

	#If .F.
		Local This As XMLNamespace Of 'Tools\namespaces\prg\XMLNameSpace.prg'
	#Endif

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="datasessiontofile" type="method" display="DataSessionToFile" />] ;
		+ [<memberdata name="datasessiontoxml" type="method" display="DataSessionToXML" />] ;
		+ [<memberdata name="getdiffgram" type="method" display="GetDiffGram" />] ;
		+ [<memberdata name="newxmladapter" type="method" display="NewXmlAdapter" />] ;
		+ [<memberdata name="parsexml" type="method" display="ParseXML" />] ;
		+ [<memberdata name="xmltoobject" type="method" display="XMLToObject" />] ;
		+ [</VFPData>]

	Dimension DataSessionToFile_COMATTRIB[ 5 ]
	DataSessionToFile_COMATTRIB[ 1 ] = 0
	DataSessionToFile_COMATTRIB[ 2 ] = 'Graba un archivo en formato xml con el contenido de todos los cursores de las session dada.'
	DataSessionToFile_COMATTRIB[ 3 ] = 'DataSessionToFile'
	DataSessionToFile_COMATTRIB[ 4 ] = 'Void'
	* DataSessionToFile_COMATTRIB[ 5 ] = 1

	* DataSessionToFile
	* Graba un archivo en formato xml con el contenido de todos los cursores de las session dada.
	Procedure DataSessionToFile ( tcFile As String, tnDataSessionId As Number, tlSafety As Boolean ) As void HelpString 'Graba un archivo en formato xml con el contenido de todos los cursores de las session dada.'

		Local laused[1], ;
			lcRet As String, ;
			lcTable As String, ;
			lnIdx As Number, ;
			lnLen As Number, ;
			loErr As Exception, ;
			loSetDataSession As Object, ;
			loSetSafety As Object, ;
			loXa As XmladapterBase Of 'Tools\namespaces\prg\XmladapterBase.prg'

		Try

			If Empty ( m.tnDataSessionId )
				tnDataSessionId = Set ( 'Datasession' )

			Endif && Empty ( m.tnDataSessionId )

			loSetDataSession = m.Environment.SetDatasession ( m.tnDataSessionId )
			Set DataSession To ( m.tnDataSessionId )
			Select 0

			If m.tlSafety
				loSetSafety = m.Environment.SetSafety ( 'OFF' )

			Endif && m.tlSafety

			lnLen = Aused ( laused, m.tnDataSessionId )
			If ! Empty ( m.lnLen )
				loXa = This.NewXmlAdapter()
				For lnIdx = 1 To m.lnLen

					lcTable = laused[ m.lnIdx, 1 ]
					Select ( laused[ m.lnIdx, 2 ] )
					If Used ( m.lcTable )
						m.loXa.AddTableSchema ( m.lcTable )

					Else && Used ( m.lcTable )
						Error 'No se pudo leer la tabla "' + m.lcTable + '"'

					Endif && Used( m.lcTable )

				Next

				loXa.ForceCloseTag      = .T.
				loXa.PreserveWhiteSpace = .T.
				loXa.UTF8Encoded        = .T.
				loXa.WrapCharInCDATA    = .T.
				loXa.WrapMemoInCDATA    = .T.
				m.loXa.ToXML ( tcFile, '', .T. )

			Endif && ! Empty( m.lnLen )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFile, tnDataSessionId, tlSafety
			THROW_EXCEPTION

		Finally
			Store .F. To laused
			loSetDataSession = Null
			loXa             = Null
			loSetSafety      = Null

		Endtry

	Endproc && DataSessionToFile

	Dimension DataSessionToXML_COMATTRIB[ 5 ]
	DataSessionToXML_COMATTRIB[ 1 ] = 0
	DataSessionToXML_COMATTRIB[ 2 ] = 'Devuelve una cadena con el contenido de todos los cursores de las session dada en formato xml.'
	DataSessionToXML_COMATTRIB[ 3 ] = 'DataSessionToXML'
	DataSessionToXML_COMATTRIB[ 4 ] = 'String'
	* DataSessionToXML_COMATTRIB[ 5 ] = 1

	* DataSessionToXML
	* Devuelve una cadena con el contenido de todos los cursores de las session dada en formato xml.
	Function DataSessionToXML ( tnDataSessionId As Number ) As String HelpString 'Devuelve una cadena con el contenido de todos los cursores de las session dada en formato xml.'

		Local laused[1], ;
			lcRet As String, ;
			lcTable As String, ;
			lnIdx As Number, ;
			lnLen As Number, ;
			loErr As Exception, ;
			loSetDataSession As Object, ;
			loXa As XmladapterBase Of 'Tools\namespaces\prg\XmladapterBase.prg'

		Try

			If Empty ( m.tnDataSessionId )
				tnDataSessionId = Set ( 'Datasession' )

			Endif && Empty ( m.tnDataSessionId )

			loSetDataSession = m.Environment.SetDatasession ( m.tnDataSessionId )
			Set DataSession To ( m.tnDataSessionId )
			Select 0

			lnLen = Aused ( laused, m.tnDataSessionId )
			If ! Empty ( m.lnLen )
				loXa = This.NewXmlAdapter()
				For lnIdx = 1 To m.lnLen

					lcTable = laused[ m.lnIdx, 1 ]
					Select ( laused[ m.lnIdx, 2 ] )
					If Used ( m.lcTable )
						m.loXa.AddTableSchema ( m.lcTable )

					Else && Used ( m.lcTable )
						Error 'No se pudo leer la tabla "' + m.lcTable + '"'

					Endif && Used( m.lcTable )

				Next

				loXa.ForceCloseTag      = .T.
				loXa.PreserveWhiteSpace = .T.
				* m.loXa.Unicode = .T.
				loXa.UTF8Encoded     = .T.
				loXa.WrapCharInCDATA = .T.
				loXa.WrapMemoInCDATA = .T.
				m.loXa.ToXML ( 'lcXML' )
				lcRet = M.lcXML

			Endif && ! Empty( m.lnLen )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnDataSessionId
			THROW_EXCEPTION

		Finally
			Store .F. To laused
			loSetDataSession = Null
			loXa             = Null

		Endtry

		Return m.lcRet

	Endfunc && DataSessionToXML

	Dimension GetDiffGram_COMATTRIB[ 5 ]
	GetDiffGram_COMATTRIB[ 1 ] = 0
	GetDiffGram_COMATTRIB[ 2 ] = 'Devuelve una cadena en formato XML que contiene la version actual y la original de los datos del cursor dado.'
	GetDiffGram_COMATTRIB[ 3 ] = 'GetDiffGram'
	GetDiffGram_COMATTRIB[ 4 ] = 'String'
	* GetDiffGram_COMATTRIB[ 5 ] = 0

	* GetDiffGram
	* Devuelve una cadena en formato XML que contiene la version actual y la original de los datos del cursor dado.
	Function GetDiffGram ( tcCursor As String ) As String HelpString 'Devuelve una cadena en formato XML que contiene la version actual y la original de los datos del cursor dado.'

		Local lcCursor As String, ;
			lcDiffGram As String, ;
			lnIdx As Number, ;
			loErr As Exception, ;
			loXa As Xmladapter Of 'Tools\namespaces\prg\XMLNameSpace.prg'

		Try
			lcDiffGram = ''

			If Vartype ( m.tcCursor ) == 'C' And ! Empty ( m.tcCursor )
				loXa = This.NewXmlAdapter()

				For lnIdx = 1 To Getwordcount ( m.tcCursor, ',' )
					lcCursor = Getwordnum ( m.tcCursor, m.lnIdx, ',' )
					If Used ( m.lcCursor )
						m.loXa.AddTableSchema ( m.lcCursor )

					Endif && Used( m.lcCursor )

				Endfor

				lcDiffGram = m.loXa.GetDiffGram()

			Endif && Vartype( m.tcCursor ) == 'C' And ! Empty( m.tcCursor )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCursor
			THROW_EXCEPTION

		Finally
			loXa = Null

		Endtry

		Return m.lcDiffGram

	Endfunc  && GetDiffGram

	Dimension NewXmlAdapter_COMATTRIB[ 5 ]
	NewXmlAdapter_COMATTRIB[ 1 ] = 0
	NewXmlAdapter_COMATTRIB[ 2 ] = 'Devuelve una instancia de la clase XmladapterBase en la session de datos dada.'
	NewXmlAdapter_COMATTRIB[ 3 ] = 'NewXmlAdapter'
	NewXmlAdapter_COMATTRIB[ 4 ] = 'Object'
	* NewXmlAdapter_COMATTRIB[ 5 ] = 1

	* NewXmlAdapter
	* Devuelve una instancia de la clase XmladapterBase en la session de datos dada.
	Function NewXmlAdapter ( tnDataSessionId As Integer ) As XmladapterBase Of 'Tools\namespaces\prg\XmladapterBase.prg' HelpString 'Devuelve una instancia de la clase XmladapterBase en la session de datos dada.'

		* Fix: Si el XmladapterBase no se instancia en la session que se va a utilizar
		*      no se puede acceder a los cursores de esa session de datos.
		If ! Empty ( m.tnDataSessionId )
			Set DataSession To ( m.tnDataSessionId )

		Endif && ! Empty ( m.tnDataSessionId )

		Return _Newobject ( 'XMLAdapterBase', 'Tools\namespaces\Prg\XMLAdapterBase.prg' )

	Endfunc && NewXmlAdapter

	Dimension ObjectToXML_COMATTRIB[ 5 ]
	ObjectToXML_COMATTRIB[ 1 ] = 0
	ObjectToXML_COMATTRIB[ 2 ] = 'Devuelve una cadena en formato XML con la serializacion del objeto dado. '
	ObjectToXML_COMATTRIB[ 3 ] = 'ObjectToXML'
	ObjectToXML_COMATTRIB[ 4 ] = 'String'
	* ObjectToXML_COMATTRIB[ 5 ] = 0

	* ObjectToXML
	* Devuelve una cadena en formato XML con la serializacion del objeto dado.
	Function ObjectToXML ( toObj As Object ) As String HelpString 'Devuelve una cadena en formato XML con la serializacion del objeto dado.'

		Local lcXML As String, ;
			loErr As Exception, ;
			loXa As XmladapterBase Of 'Tools\namespaces\prg\XmladapterBase.prg'

		Try
			If Vartype ( m.toObj ) == 'O'
				loXa = This.NewXmlAdapter()
				m.loXa.LoadObj ( m.toObj )
				m.loXa.ToXMLEx ( 'lcXML' )

			Endif && Vartype ( m.toObj ) == 'O'

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toObj
			THROW_EXCEPTION

		Finally
			loXa = Null

		Endtry

		Return m.lcXML

	Endfunc && ObjectToXML

	Dimension ParseXML_COMATTRIB[ 5 ]
	ParseXML_COMATTRIB[ 1 ] = 0
	ParseXML_COMATTRIB[ 2 ] = 'Devuelve una cadena con el resultado del parseo del XML dado para obtener el contenido lo solicitado.'
	ParseXML_COMATTRIB[ 3 ] = 'ParseXML'
	ParseXML_COMATTRIB[ 4 ] = 'String'
	* ParseXML_COMATTRIB[ 5 ] = 1

	* ParseXML
	* Devuelve una cadena con el resultado del parseo del XML dado para obtener el contenido lo solicitado.
	Function ParseXML ( tcXML As String, tnAction As Number ) As String HelpString 'Devuelve una cadena con el resultado del parseo del XML dado para obtener el contenido lo solicitado.'
		* Parsea un XML y devuelve un string de acuerdo al parámetro pasado
		* Parámetros....: 0 = Devuelve el XML
		* 						1 = Devuelve el identificador en la forma "#<IDENTIFICADOR>#"
		*						2 = Devuelve el comentario

		*!* La estructura tiene que ser #<ERR>#<Este es el Comentario>#<ERR>#

		Local lcAux As String, ;
			lcComment As String, ;
			lcIdentifier As String, ;
			lcReturn As String, ;
			lcXML As String, ;
			lnLen As Number, ;
			lnLen1 As Number

		Try
			lcIdentifier = ''
			lcComment    = ''
			lcXML        = ''

			If Vartype ( m.tcXML ) == 'C'
				If Empty ( m.tnAction )
					tnAction = 0

				Endif && Empty( m.tnAction )

				* Obtener identificador
				If Substr ( m.tcXML, 1, 2 ) == '#<'
					lnLen = At ( '>#', m.tcXML )
					If ! Empty ( m.lnLen )
						lcIdentifier = Substr ( m.tcXML, 1, m.lnLen + 1 )

					Endif && ! Empty( m.lnLen )

				Endif && Substr( m.tcXML, 1, 2 ) == "#<"

				* Obtener comentario
				If ! Empty ( m.lcIdentifier )
					lnLen = Len ( m.lcIdentifier )
					If Substr ( m.tcXML, 1, m.lnLen + 1) == m.lcIdentifier + '<'
						lnLen1 = At ( '>' + m.lcIdentifier, m.tcXML )
						If ! Empty ( lnLen1 )
							lcComment = Substr ( m.tcXML, m.lnLen + 2, m.lnLen1 - m.lnLen - 2)

						Endif && ! Empty( lnLen1 )

					Endif && Substr( m.tcXML, 1, m.lnLen + 1) == m.lcIdentifier + "<"

				Endif && ! Empty( m.lcIdentifier )

				* Obtener XML
				If Empty ( m.lcComment )
					lnLen = Len ( m.lcIdentifier )

				Else && Empty ( m.lcComment )
					lnLen = Len ( m.lcComment + m.lcIdentifier + m.lcIdentifier ) + 2

				Endif && Empty( m.lcComment )

				If Empty ( m.lnLen )
					lcXML = m.tcXML

				Else && Empty ( m.lnLen )
					lcXML = Substr ( m.tcXML, m.lnLen + 1 )

				Endif && Empty( m.lnLen )

				Do Case
					Case m.tnAction = 0
						lcReturn = m.lcXML

					Case m.tnAction = 1
						lcReturn = m.lcIdentifier

					Case m.tnAction = 2
						lcReturn = m.lcComment

					Otherwise

				Endcase

			Else
				lcReturn = ''

			Endif && Vartype( m.tcXML ) == "C"

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcXML, tnAction
			THROW_EXCEPTION

		Endtry

		Return m.lcReturn

	Endfunc  && ParseXML

	Dimension XMLToObject_COMATTRIB[ 5 ]
	XMLToObject_COMATTRIB[ 1 ] = 0
	XMLToObject_COMATTRIB[ 2 ] = 'Devuelve un objeto deserializando el XML dado.'
	XMLToObject_COMATTRIB[ 3 ] = 'XMLToObject'
	XMLToObject_COMATTRIB[ 4 ] = 'Object'
	* XMLToObject_COMATTRIB[ 5 ] = 0

	* XMLToObject
	* Devuelve un objeto deserializando el XML dado.
	Function XMLToObject ( tcXML As String ) As Object HelpString 'Devuelve un objeto deserializando el XML dado.'

		Local loErr As Exception, ;
			loObj As Object, ;
			loXa As XmladapterBase Of 'Tools\namespaces\prg\XmladapterBase.prg'

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Devuelve un objeto deserializando el XML dado.
			 Recibe un XML, previamente serializado por ObjectToXML(), y lo convierte en el objeto original
			 *:Project:
			 CMSI
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Viernes 20 de Octubre de 2006 (16:55:04)
			  *:ModiSummary:
			 R/0001 -
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 ObjectToXML
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try
			loXa = This.NewXmlAdapter()
			m.loXa.LoadXML ( m.tcXML )
			loObj = m.loXa.ToObject()

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Finally
			loXa = Null

		Endtry

		Return m.loObj

	Endfunc && XMLToObject

Enddefine && XMLNameSpace