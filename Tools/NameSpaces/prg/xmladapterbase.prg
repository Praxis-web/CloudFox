#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
Endif

* XmladapterBase
Define Class xmlAdapterBase As Xmladapter

	#If .F.
		Local This As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'
	#Endif

	#If .F.
		TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
            	Personaliza XMLAdapter, agregándole funcionalidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Lunes 11 de Enero de 2010
			*:ModiSummary:
			*:Syntax:
			*:Example:
			Local loXA As xmlAdapterBase Of "Tools\Namespaces\Prg\xmlAdapterBase.prg"
			LOCAL lcXML as String
			m.loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )
			m.loXA.LoadObj( _Screen )
			m.lcXML = ''
			m.loXA.ToXML( "lcXML" )
			? m.lcXML
			m.loXA = Null
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
		ENDTEXT
	#Endif



	*!* Guarda una referencia al objeto que va a adaptar
	Protected oObj
	oObj = Null

	*!* Indica si se cargo un Objeto para adaptarlo
	lIsObjectLoaded = .F.

	*!* Contiene una clave provisoria del cursor MainCursor
	nCursorKey = 0

	*!* Error Flag
	lIsOk = .T.

	*!* Indica si la propiedad _memberdata es procesa o no
	lPreserveMemberData = .F.

	*!* Filtro para la funcion aMembers() en el metodo ObjectToCursor
	cLoadObjectFilter = ''

	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="cloadobjectfilter" type="property" display="cLoadObjectFilter" />] ;
		+ [<memberdata name="cursortoobject" type="method" display="CursorToObject" />] ;
		+ [<memberdata name="getdiffgram" type="method" display="GetDiffGram" />] ;
		+ [<memberdata name="getnotusedalias" type="method" display="GetNotUsedAlias" />] ;
		+ [<memberdata name="lisobjectloaded" type="property" display="lIsObjectLoaded" />] ;
		+ [<memberdata name="lisok" type="property" display="lIsOk" />] ;
		+ [<memberdata name="loadobj" type="method" display="LoadObj" />] ;
		+ [<memberdata name="loadtables" type="method" display="LoadTables" />] ;
		+ [<memberdata name="lpreservememberdata" type="property" display="lPreserveMemberData" />] ;
		+ [<memberdata name="ncursorkey" type="property" display="nCursorKey" />] ;
		+ [<memberdata name="objecttocursor" type="method" display="ObjectToCursor" />] ;
		+ [<memberdata name="oobj" type="property" display="oObj" />] ;
		+ [<memberdata name="toobject" type="method" display="ToObject" />] ;
		+ [<memberdata name="toxmlex" type="method" display="ToXMLEx" />] ;
		+ [</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CursorToObject
	*!* Description...: Crea un Objeto a partir de un cursor
	*!* Date..........: Lunes 12 de Diciembre de 2005 ( 19:51:14 )
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta v. 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Hidden Procedure CursorToObject ( tcAlias As String, tcMainAlias As String ) As Object HelpString 'Crea un Objeto a partir de un cursor'

		Local laFields[1], ;
			laObj[1], ;
			lcAlias As String, ;
			lcColAlias As String, ;
			lcKeyValue As String, ;
			lcPropertyName As String, ;
			lcValue As String, ;
			lnI As Integer, ;
			lnLen As Integer, ;
			loElement As Object, ;
			loErr As Exception, ;
			loObj As Object, ;
			lvValue

		* Las colecciones se manejan de un modo especial



		Try
			If Used ( m.tcAlias )

				Select Alias ( m.tcAlias )

				m.lnLen = Afields ( m.laFields, Alias ( m.tcAlias ) )

				* If ! Empty( Ascan( m.laFields, "baseclass", 1, lnLen, 1, 1 ) ) And Lower( &tcAlias..BaseClass ) == "collection"
				If ! Empty ( Ascan ( m.laFields, 'baseclass', 1, m.lnLen, 1, 1 ) ) And Lower ( Evaluate ( m.tcAlias + '.BaseClass' ) ) == 'collection'

					* m.loObj = Newobject ( 'Collectionbase', 'NameSpaces\prg\Collectionbase.prg' )
					m.loObj = _Newobject ( 'Collectionbase', 'Tools\namespaces\prg\Collectionbase.prg' )
					m.lcColAlias = Sys ( 2015 )

					* Se obtienen todos los elementos que conforman la ;
					coleccion
					Select * From ( m.tcMainAlias ) Where ParentAlias = m.tcAlias And Lower ( PropertyName ) = 'baseclass' Into Cursor ( m.lcColAlias )

					Select Alias ( m.lcColAlias )
					Locate

					Scan
						m.lcAlias = Alltrim ( Evaluate ( m.lcColAlias + '.ChildAlias' ) )
						m.loElement = This.CursorToObject ( m.lcAlias, m.tcMainAlias )

						* m.lcKeyValue = Alltrim( &m.lcColAlias..KeyValue )
						m.lcKeyValue = Alltrim ( Evaluate ( m.lcColAlias + '.KeyValue' ) )

						* Se agrega el objeto a la colección
						If Empty ( m.lcKeyValue )
							m.loObj.AddItem ( m.loElement )

						Else
							m.loObj.AddItem ( m.loElement, m.lcKeyValue )

						Endif && Empty( m.lcKeyValue )

					Endscan

					Use In Alias ( m.lcColAlias )

				Else
					* Se convierte el cursor en un objeto
					Scatter Memo Name m.loObj
					If Vartype ( m.loObj ) == 'O'

						Amembers ( m.laObj, m.loObj )
						For Each m.lcPropertyName In m.laObj

							* If Vartype( m.loObj.&m.lcPropertyName ) == "C"
							m.lvValue = Getpem ( m.loObj, m.lcPropertyName )
							If Vartype ( m.lvValue ) == 'C'
								* m.lcValue = Alltrim( m.loObj.&m.lcPropertyName )
								m.lcValue = Alltrim ( m.lvValue )

								m.loObj.&lcPropertyName. = m.lcValue
								If m.tcAlias # m.tcMainAlias
									If '( object )' == Lower ( m.lcValue ) Or '( objeto )' == Lower ( m.lcValue )

										* Actualizar la propiedad con el objeto ;
										correspondiente
										Select * From ( m.tcMainAlias ) Where ParentAlias = m.tcAlias And PropertyName = m.lcPropertyName Into Cursor 'cCursor'

										m.lcAlias = Alltrim ( cCursor.ChildAlias )
										Use In Alias ( 'cCursor' )

										* m.loObj.&m.lcPropertyName = This.CursorToObject( m.lcAlias, m.tcMainAlias )
										m.loObj.&lcPropertyName. = This.CursorToObject ( m.lcAlias, m.tcMainAlias )

									Endif && "( object )" == Lower( m.lcValue ) Or "( objeto )" == Lower( m.lcValue )

								Endif && m.tcAlias # m.tcMainAlias

							Endif && Vartype( m.loObj.&m.lcPropertyName ) == "C"

						Endfor

					Endif && Vartype( m.loObj ) == "O"

				Endif && ! Empty( Ascan( m.laFields, "baseclass", 1, lnLen, 1, 1 ) ) And Lower( &m.tcAlias..BaseClass ) == "collection"

			Endif && Used( m.tcAlias )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.loObj

	Endproc && CursorToObject

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Domingo 11 de Diciembre de 2005 ( 18:46:10 )
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Destroy() As void
		Local lnIdx As Number, ;
			loTable As Xmltable
		*:Global i as Integer
		With This As Xmladapter Of 'Tools\namespaces\prg\XMLNameSpace.prg'
			If .lIsObjectLoaded
				For m.lnIdx = 1 To .Tables.Count
					m.loTable = .Tables.Item[ m.lnIdx ]
					Use In Select ( m.loTable.Alias )

				Endfor

			Endif &&  .lIsObjectLoaded

		Endwith

		DoDefault()

	Endproc && Destroy

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetDiffGram
	*!* Description...: Crea un DiffGram y lo devuelve
	*!* Date..........: Domingo 11 de Diciembre de 2005 ( 11:08:31 )
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure GetDiffGram() As String HelpString 'Crea un DiffGram y lo devuelve'

		Local lcRetVal As String, ;
			lcSchemaLocation As String, ;
			llChangesOnly As Boolean, ;
			llFile As Boolean, ;
			llIncludeBefore As Boolean, ;
			loErr As Exception

		Try

			m.lcRetVal = ''
			m.lcSchemaLocation = ''
			m.llFile = .F.
			m.llIncludeBefore = .T.
			m.llChangesOnly = .T.

			With This As Xmladapter
				.ReleaseXML ( .F. )
				.IsDiffGram = .T.

				* Es muy importante preservar los espacios en blanco para
				* aplicar luego el DiffGram, si no los cambios no son efectuados.
				.PreserveWhiteSpace = .T.
				.WrapMemoInCDATA = .T.

				* RA 2013-10-22(14:10:05)
				*!*	[ Error N° ] 2179
				*!*	[ Message ] El formato XML anidado es incompatible con el modo 'Sólo cambios'.
				*!*	[ Procedure ] toxml

				*!*	This error is generated by the XMLAdapter Class ToXML Method if both the
				*!*	RespectNesting Property and the lChangesOnly parameter are set to true (.T.).


				*.RespectNesting = .T.

				.ToXML ( 'lcRetVal', m.lcSchemaLocation, m.llFile, m.llIncludeBefore, m.llChangesOnly )

			Endwith

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.lcRetVal

	Endproc && GetDiffGram

	* GetNotUsedAlias
	Hidden Function GetNotUsedAlias() As String
		Local lcRet As String
		m.lcRet = Sys ( 2015 )
		Do While Used ( m.lcRet )
			m.lcRet = Sys ( 2015 )

		Enddo

		Return m.lcRet

	Endfunc && GetNotUsedAlias

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Init
	*!* Description...:
	*!* Date..........: Domingo 11 de Diciembre de 2005 ( 18:40:46 )
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	*!* Procedure Init() As Boolean

	*!* *!* Set Path To Addbs( FL_SOURCE ) Additive

	*!* Return .T.
	*!* Endproc
	*!*
	*!* END PROCEDURE Init
	*!*
	*!* ///////////////////////////////////////////////////////




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: LoadObj
	*!* Description...: Carga un Objeto para ser adaptado
	*!* Date..........: Domingo 11 de Diciembre de 2005 ( 11:17:47 )
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!* tcFilter: Ver AMembers()

	Procedure LoadObj ( toObj As Object, tcFilter As String ) As Boolean HelpString 'Carga un Objeto para ser adaptado'

		With This  As Xmladapter Of 'Tools\namespaces\prg\XMLNameSpace.prg'
			If Vartype ( m.toObj ) # 'O' Or .IsLoaded
				.lIsObjectLoaded = .F.

			Else
				.oObj = m.toObj
				.lIsObjectLoaded = .T.
				If Vartype ( m.tcFilter ) # 'C'
					m.tcFilter = ''

				Endif && Vartype( tcFilter ) # "C"

				.cLoadObjectFilter = Upper ( m.tcFilter )

			Endif && Vartype( m.toObj ) # "O" Or .IsLoaded

		Endwith

		Return This.lIsObjectLoaded

	Endproc && LoadObj

	* LoadTables
	* Carga la colección Tables a partir de un Objeto
	Hidden Procedure LoadTables() As void HelpString 'Carga la colección Tables a partir de un Objeto'

		Local lcAlias As String, ;
			lcMainAlias As String, ;
			lnIdx As Number, ;
			loErr As Exception, ;
			loTable As Xmltable

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Carga la colección Tables a partir de un Objeto
				 *:Project:
				 Visual Praxis Beta 1.1
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Domingo 11 de Diciembre de 2005 ( 12:27:17 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
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
			With This As Xmladapter Of 'Tools\namespaces\prg\XMLNameSpace.prg'
				m.lcMainAlias = .GetNotUsedAlias()
				Create Cursor ( m.lcMainAlias ) ( CursorKey Integer, ParentAlias Varchar ( 10 ), PropertyName Varchar ( 254 ), ChildAlias Varchar ( 10 ), KeyValue Varchar ( 254 ) )

				For m.lnIdx = 1 To .Tables.Count
					m.loTable = .Tables.Item[ m.lnIdx ]
					Use In Select ( m.loTable.Alias )

				Endfor

				.AddTableSchema ( m.lcMainAlias )

				m.lcAlias = .ObjectToCursor ( .oObj, m.lcMainAlias )

				Insert Into ( m.lcMainAlias ) ( CursorKey, ParentAlias, PropertyName, ChildAlias ) Values ( 0, Space ( 0 ), Space ( 0 ), m.lcAlias )

			Endwith

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Finally
			m.loTable = Null

		Endtry

	Endproc && LoadTables

	* ObjectToCursor
	* Crea un Cursor a partir de las propiedades de un objeto.
	Hidden Procedure ObjectToCursor ( toObj As Object, tcMainAlias As String ) As String HelpString 'Crea un Cursor a partir de las propiedades de un objeto'

		Local laMember[1] As String, ;
			lcAlias As String, ;
			lcBaseClass As String, ;
			lcChildAlias As String, ;
			lcCommand As String, ;
			lcFieldNameList As String, ;
			lcFieldNameStr As String, ;
			lcFieldValues As String, ;
			lcFilter As String, ;
			lcKeyValue As String, ;
			lcLen As String, ;
			lcPropertyName As String, ;
			lcStr As String, ;
			lcType As Character, ;
			lcXML As String, ;
			lnCursorKey As Integer, ;
			lnI As Integer, ;
			lnIdx As Number, ;
			lnLen As Integer, ;
			lnLengh As Integer, ;
			loErr As Exception, ;
			loObj As Object, ;
			luValue[1] As Variant

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Crea un Cursor a partir de las propiedades de un objeto
				 *:Project:
				 Visual Praxis Beta 1.1
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Domingo 11 de Diciembre de 2005 ( 12:40:02 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
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
			With This As Xmladapter Of 'Tools\namespaces\prg\XMLNameSpace.prg'
				*!* Crear el cursor a partir del objeto
				m.lcFieldNameList = '' && Lista de nombres de Campo
				m.lcFieldNameStr = '' && Lista de nombres de Campo con estructura
				m.lcFieldValues = '' && Lista de valores de cada campo

				Try
					m.lcBaseClass = Lower ( m.toObj.BaseClass )

				Catch To loErr
					m.lcBaseClass = ''

				Endtry

				Do Case
					Case Inlist ( m.lcBaseClass, 'collection', 'exception' )
						m.lcFilter = ''

					Otherwise
						m.lcFilter = .cLoadObjectFilter

				Endcase

				m.lnLen = Amembers ( m.laMember, m.toObj, 0, m.lcFilter )

				If ! .lPreserveMemberData
					* DAE 2010-01-12(00:01:26)
					*!*	For m.lnIdx = 1 To m.lnLen
					*!*		m.laMember[ i ] = Upper( m.laMember[ i ] )

					*!*	Endfor
					m.lnIdx = Ascan ( m.laMember, '_MEMBERDATA' )
					If ! Empty ( m.lnIdx )
						Adel ( m.laMember, m.lnIdx )
						m.lnLen = m.lnLen - 1

					Endif && ! Empty( m.lnIdx )

				Endif && ! This.lPreserveMemberData

				Dimension m.luValue[ m.lnLen ]

				.nCursorKey = .nCursorKey + 1
				m.lnCursorKey = .nCursorKey

				For m.lnI = 1 To m.lnLen

					m.lcPropertyName = m.laMember[ m.lnI ]
					* Evito las propiedades con access que no se modificaron
					If Pemstatus ( This, m.lcPropertyName + '_Access', 5 ) And ! Pemstatus ( This, m.lcPropertyName, 0 )
						Loop

					Endif && PemStatus( This, laMember[ m.lnMember ] + "_Access", 5 )

					m.lcFieldNameList = m.lcFieldNameList + m.lcPropertyName + ', '

					Try
						m.luValue[ m.lnI ] = Getpem ( m.toObj, m.lcPropertyName )

					Catch To loErr
						m.luValue[ m.lnI ] = ''

					Endtry

					*!* Armar la estructura en función del tipo de campo
					m.lcType = Vartype ( m.luValue[ m.lnI ] )

					Do Case
						Case m.lcType == 'C'
							m.lnLengh = Len ( m.luValue[ m.lnI ] )
							If m.lnLengh > 254
								m.lcType = 'M NOCPTRANS, '

							Else
								m.lcLen = Transform ( Max ( m.lnLengh, 1 ) )
								* m.lcType = "V ( &m.lcLen. ) NOCPTRANS, "
								m.lcType = 'V ( ' + m.lcLen + ' ) NOCPTRANS, '

							Endif && m.lnLengh > 254

						Case m.lcType == 'N'
							m.lnLengh = m.Number.LenNum ( luValue[ m.lnI ] )
							m.lcLen = Transform ( m.lnLengh )
							m.lcType = 'N ( ' + m.lcLen
							m.lnLengh = m.Number.LenNum ( m.luValue[ m.lnI ], .T. )
							If ! Empty ( m.lnLengh )
								m.lcLen = Transform ( m.lnLengh )
								m.lcType = m.lcType + ', ' + m.lcLen + ' ), '

							Else
								m.lcType = m.lcType + ' ), '

							Endif && ! Empty( m.lnLengh )

							*!*	Case m.lcType == "L"
							*!*		m.lcType = "L, "

							*!*	Case m.lcType == "D"
							*!*		m.lcType = "D, "

							*!*	Case m.lcType == "T"
							*!*		m.lcType = "T, "

						Case m.lcType $ 'LDT'
							m.lcType = m.lcType + ', '

						Case m.lcType == 'X' && .Null.
							m.lcType = 'V ( 1 ), '
							m.luValue[ m.lnI ] = ''

						Case m.lcType == 'O'
							m.luValue[ m.lnI ] = Transform ( m.luValue[ m.lnI ] )
							m.lcType = 'V'
							m.lnLengh = Len ( m.luValue[ m.lnI ] )
							If m.lnLengh > 254
								m.lcType = 'M NOCPTRANS, '

							Else
								m.lcLen = Transform ( Max ( m.lnLengh, 1 ) )
								m.lcType = 'V ( ' + m.lcLen + ' ) NOCPTRANS, '

							Endif && m.lnLengh > 254

						Otherwise
							m.lcType = 'C , '
							m.luValue[ m.lnI ] = Transform ( m.luValue[ m.lnI ] )

					Endcase

					m.lcFieldNameStr = m.lcFieldNameStr + m.lcPropertyName + ' ' + m.lcType
					m.lcFieldValues = m.lcFieldValues + 'm.luValue[ ' + Transform ( m.lnI ) + ' ], '

					Try
						* m.loObj = m.toObj.&m.lcPropertyName
						m.loObj = Getpem ( m.toObj, m.lcPropertyName )

						If Vartype ( m.loObj ) == 'O' And ! Inlist ( Lower ( m.lcPropertyName ), 'objects', 'controls', 'parent', 'pages', 'buttons' )

							m.lcChildAlias = This.ObjectToCursor ( m.loObj, m.tcMainAlias )
							* Insert Into &tcMainAlias ( CursorKey, ParentAlias, PropertyName, ChildAlias ) Values ( m.lnCursorKey, Space( 10 ), m.lcPropertyName, m.lcChildAlias )
							Insert Into ( m.tcMainAlias ) ( CursorKey, ParentAlias, PropertyName, ChildAlias ) Values ( m.lnCursorKey, Space ( 10 ), m.lcPropertyName, m.lcChildAlias )

						Endif && Vartype( m.loObj ) == "O" And ! Inlist( Lower( m.lcPropertyName ), "objects" , "controls" , "parent" , "pages" , "buttons" )

						* If Lower( m.lcPropertyName ) == "baseclass" And Lower( m.toObj.&lcPropertyName ) == "collection"
						If Lower ( m.lcPropertyName ) == 'baseclass' And Lower ( Getpem ( m.toObj, m.lcPropertyName ) ) == 'collection'

							* m.loObj = Null
							For m.lnIdx = 1 To m.toObj.Count
								m.loObj = m.toObj.Item[ m.lnIdx ]
								m.lcKeyValue = m.toObj.GetKey ( m.lnIdx )
								m.lcChildAlias = .ObjectToCursor ( m.loObj, m.tcMainAlias )
								If ! Empty ( m.lcChildAlias )
									* Insert Into &tcMainAlias ( CursorKey, ParentAlias, PropertyName, ChildAlias, KeyValue ) Values ( lnCursorKey, Space( 10 ), lcPropertyName, lcChildAlias, lcKeyValue )
									Insert Into ( m.tcMainAlias ) ( CursorKey, ParentAlias, PropertyName, ChildAlias, KeyValue ) Values ( m.lnCursorKey, Space ( 10 ), m.lcPropertyName, m.lcChildAlias, m.lcKeyValue )

								Endif && ! Empty( m.lcChildAlias )

							Endfor

						Endif && Lower( m.lcPropertyName ) == "baseclass" And Lower( Getpem( m.toObj, m.lcPropertyName ) ) == "collection"

					Catch To loErr
					Endtry

				Endfor

				*!* Eliminar la última coma ( , ) y encerrar entre paréntesis
				m.lcFieldNameStr = '( ' + Alltrim ( m.lcFieldNameStr )
				m.lcFieldNameStr = Substr ( m.lcFieldNameStr, 1, Len ( m.lcFieldNameStr ) - 1 )
				m.lcFieldNameStr = m.lcFieldNameStr + ' )'

				m.lcFieldNameList = '( ' + Alltrim ( m.lcFieldNameList )
				m.lcFieldNameList = Substr ( m.lcFieldNameList, 1, Len ( m.lcFieldNameList ) - 1 )
				m.lcFieldNameList = m.lcFieldNameList + ' )'

				m.lcFieldValues = '( ' + Alltrim ( m.lcFieldValues )
				m.lcFieldValues = Substr ( m.lcFieldValues, 1, Len ( m.lcFieldValues ) - 1 )
				m.lcFieldValues = m.lcFieldValues + ' )'

				m.lcAlias = .GetNotUsedAlias()

				*!* Crear el cursor
				TEXT To m.lcCommand Textmerge Noshow
					 Create Cursor <<m.lcAlias>> <<m.lcFieldNameStr>>
				ENDTEXT

				m.lcCommand = m.String.CleanString ( m.lcCommand )
				&lcCommand

				*!* Insertar un registro con los valores del objeto
				TEXT To m.lcCommand Textmerge Noshow
					Insert Into <<m.lcAlias>> <<m.lcFieldNameList>> Values <<m.lcFieldValues>>
				ENDTEXT

				m.lcCommand = m.String.CleanString ( m.lcCommand )
				&lcCommand

				.AddTableSchema ( m.lcAlias )

				Update (m.tcMainAlias) Set ParentAlias = m.lcAlias Where CursorKey = m.lnCursorKey

			Endwith

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Finally
			m.loObj = Null

		Endtry

		Return m.lcAlias

	Endproc && ObjectToCursor

	* ToObject
	* Devuelve un objeto deserializando el Xml dado.
	Function ToObject ( tcXML As String, tlFile As Boolean ) As Object HelpString 'Devuelve un objeto deserializando el Xml dado.'

		Local lcAlias As String, ;
			lcMainAlias As String, ;
			lcXML As String, ;
			lnIdx As Number, ;
			loErr As Exception, ;
			loObj As Object, ;
			loTable As Xmltable

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Devuelve un objeto deserializando el Xml dado.
			 Transforma un XML en un Objecto
			 *:Project:
			 Visual Praxis Beta 1.1
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Domingo 11 de Diciembre de 2005 ( 12:03:24 )
			 *:ModiSummary:
			 R/0001 -
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
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

			With This As Xmladapter Of 'Tools\namespaces\prg\XMLNameSpace.prg'
				If ! Empty ( m.tcXML )
					.LoadXML ( m.tcXML, m.tlFile, .T. )

				Endif && ! Empty( m.tcXML )

				If .lIsOk
					If .IsLoaded
						For m.lnIdx = 1 To .Tables.Count
							m.loTable = .Tables.Item[ m.lnIdx ]
							Use In Select ( m.loTable.Alias )
							m.loTable.ToCursor()

						Endfor

						m.lcMainAlias = .Tables.Item[ 1 ].Alias
						* If Type( "&m.lcMainAlias..CursorKey" ) == "N"
						If Vartype ( Evaluate (  m.lcMainAlias + '.CursorKey' ) ) == 'N'
							* El XML fue creado con el metodo ToXML, y contiene una tabla principal en Item[ 1 ]
							* con información para recomponer el objeto original.
							Select * From ( m.lcMainAlias ) Where CursorKey = 0 Into Cursor 'cCursor'

							m.lcAlias = Alltrim ( cCursor.ChildAlias )
							Use In Select ( 'cCursor' )

						Else
							* Convierte el registro en un objeto "plano"
							m.lcAlias = m.lcMainAlias

						Endif && Type( "&m.lcMainAlias..CursorKey" ) == "N"

						If .lIsOk
							m.loObj = .CursorToObject ( m.lcAlias, m.lcMainAlias )

						Endif && .lIsOk

						For m.lnIdx = 1 To .Tables.Count
							loTable = .Tables.Item[ m.lnIdx ]
							Use In Select ( loTable.Alias )

						Endfor

					Else
						m.lcXML = ''
						.ToXML ( 'lcXML' )
						.LoadXML ( m.lcXML )

						If .lIsOk
							m.loObj = .ToObject()

						Endif && .lIsOk

					Endif && .IsLoaded

				Endif && This.lIsOk

			Endwith
		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Finally
			m.loTable = Null

		Endtry

		Return m.loObj

	Endproc && ToObject

	* ToXML
	* Devuelve un XML a partir de un objeto. 
	Procedure ToXML ( tcXMLDocument As String, tcSchemaLocation As String, tlFile As Boolean, tlIncludeBefore As Boolean, tlChangesOnly As Boolean ) As void HelpString 'Devuelve un XML a partir de un Objeto'

		Local lnPcount As Number, ;
			loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Devuelve un XML a partir de un Objeto
			 *:Project:
			 Visual Praxis Beta 1.1
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Domingo 11 de Diciembre de 2005 ( 12:17:07 )
			 *:ModiSummary:
			 R/0001 -
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
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
			m.lnPcount = Pcount()
			Do Case
				Case m.lnPcount == 1
					m.tcSchemaLocation = ''
					m.tlFile = .F.
					m.tlIncludeBefore = .F.
					m.tlChangesOnly = .F.

				Case m.lnPcount == 2
					m.tlFile = .F.
					m.tlIncludeBefore = .F.
					m.tlChangesOnly = .F.

				Case m.lnPcount == 3
					m.tlIncludeBefore = .F.
					m.tlChangesOnly = .F.

				Case m.lnPcount == 4
					m.tlChangesOnly = .F.

				Otherwise

			Endcase
			With This As Xmladapter Of 'Tools\namespaces\prg\XMLNameSpace.prg'
				If .lIsObjectLoaded And ! .IsLoaded
					.LoadTables()

				Endif && .lIsObjectLoaded And ! .IsLoaded

			Endwith

			DoDefault ( m.tcXMLDocument, m.tcSchemaLocation, m.tlFile, m.tlIncludeBefore, m.tlChangesOnly )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

	Endproc && ToXml

	* ToXmlEx
	*  Devuelve un XML a partir de un objeto .
	Procedure ToXMLEx ( tcXMLDocument As String, tcSchemaLocation As String, tlFile As Boolean, tlIncludeBefore As Boolean, tlChangesOnly As Boolean ) As Variant HelpString 'Devuelve un XML a partir de un Objeto'
		Local lcXML As String, ;
			llIsObject As Boolean, ;
			lnPcount As Number, ;
			loErr As Exception, ;
			lvRet As Variant

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve un XML a partir de un Objeto
				 *:Project:
				 Visual Praxis Beta 1.1
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Domingo 11 de Diciembre de 2005 ( 12:17:07 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
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
			m.lvRet = .T.
			m.lcXML = ''
			m.lnPcount = Pcount()
			Do Case
				Case m.lnPcount == 0
					m.tcXMLDocument = 'lcXML'
					m.tcSchemaLocation = ''
					m.tlFile = .F.
					m.tlIncludeBefore = .F.
					m.tlChangesOnly = .F.

				Case m.lnPcount == 1
					m.tcSchemaLocation = ''
					m.tlFile = .F.
					m.tlIncludeBefore = .F.
					m.tlChangesOnly = .F.

				Case m.lnPcount == 2
					m.tlFile = .F.
					m.tlIncludeBefore = .F.
					m.tlChangesOnly = .F.

				Case m.lnPcount == 3
					m.tlIncludeBefore = .F.
					m.tlChangesOnly = .F.

				Case m.lnPcount == 4
					m.tlChangesOnly = .F.

				Otherwise

			Endcase

			With This As XmladapterBase Of 'Tools\namespaces\prg\XMLNameSpace.prg'
				If Vartype ( m.tcXMLDocument ) == 'O'
					.LoadObj ( m.tcXMLDocument )
					m.llIsObject = .T.
					m.tcXMLDocument = 'lcXML'

				Endif && Vartype( m.tcXMLDocument ) == 'O'
				If Vartype ( m.tcSchemaLocation ) # 'C'
					m.tcSchemaLocation = ''

				Endif && Vartype( m.tcSchemaLocation ) # 'C'

				If Vartype ( m.tlFile ) # 'L'
					m.tlFile = .F.

				Endif && Vartype( m.tlFile ) # 'L'

				If Vartype ( m.tlIncludeBefore ) # 'L'
					m.tlIncludeBefore = .F.

				Endif && Vartype( m.tlIncludeBefore ) # 'L'

				If Vartype ( m.tlChangesOnly ) # 'L'
					m.tlChangesOnly = .F.

				Endif && Vartype( m.tlChangesOnly ) # 'L'

				If .lIsObjectLoaded And ! .IsLoaded
					.LoadTables()

				Endif && .lIsObjectLoaded And ! .IsLoaded

			Endwith

			This.ToXML ( m.tcXMLDocument, m.tcSchemaLocation, m.tlFile, m.tlIncludeBefore, m.tlChangesOnly )
			If m.lnPcount == 0 Or m.llIsObject
				m.lvRet = m.lcXML

			Endif && m.lnPcount == 0

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.lvRet

	Endproc && ToXmlEx

Enddefine && XmladapterBase
