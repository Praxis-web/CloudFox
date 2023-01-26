#Include "FW\Comunes\Include\Praxis.h"

*_ Begin Test

Close Databases All

Local loTable As oTable Of "Comun\Prg\coltables.prg",;
	lcErr As String
Try


	loMain = Createobject("Empty")

	AddProperty( loMain, "Primera", "Primera" )
	AddProperty( loMain, "Segunda", "Segunda" )

	loColTables = Newobject("colTables", "Comun\Prg\coltables.prg" )

	loTable = loColTables.New()

	loTable.Tabla 			= "Orders"
	loTable.Cursor 		= "cOrderHeader"
	loTable.SQLStat 		= "Select * From Orders"
	loTable.PKName 		= "OrderID"
	loTable.PKUpdatable 	= .T.

	loColTables.AddTable( loTable )

	loTable = loColTables.New()

	loTable.Tabla 		= "OrderDetails"
	loTable.Cursor 	= "cOrderDetails"
	loTable.Padre 		= "Orders"
	loTable.ForeignKey= "OrderID"
	loTable.SQLStat 	= "Select * From OrderDetails where OrderId = OrderId"
	loTable.PKName 	= "OrderID, ProductID"

	loTable1 = loColTables.New()

	loTable1.Tabla 		= "Products"
	loTable1.Cursor 		= "cProducts"
	loTable1.Padre 		= "Orderdetails"
	loTable1.ForeignKey	= "OrderID"
	loTable1.PKName 		= "ProductID"
	loTable.oColTables.AddItem( loTable1 )

	loColTables.AddTable( loTable )

	AddProperty( loMain, "oCol", loColTables )

	Local loXA As prxXMLAdapter Of "Comun\Prg\prxXMLAdapter.prg"
	loXA = Newobject("prxXMLAdapter","Comun\Prg\prxXMLAdapter.prg")

	loXA.LoadObj( loMain, "U" )

	loXA.ToXML( "lcXML" )
	If !loXA.lIsOk
		lcErr = loXA.cXMLoError
	Endif
	loXA=Null
	loColTables = Null
	loMain = Null

	If !Empty( lcErr )
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

		loError.Process( lcErr )
	Endif


	lcErr = ""


	loXA = Newobject("prxXMLAdapter","Comun\Prg\prxXMLAdapter.prg")
	loXA.LoadXML( lcXML )

	loNewMain = loXA.ToObject()
	If !loXA.lIsOk
		lcErr = loXA.cXMLoError
	Endif
	loXA=Null
	If !Empty( lcErr )
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

		loError.Process( lcErr )
	Else

		=Messagebox( loNewMain.Primera )
		=Messagebox( loNewMain.Segunda )
		For Each loCol In loNewMain.oCol
			=Messagebox( loCol.Tabla )
			For Each oTab In loCol.oColTables
				=Messagebox( oTab.Tabla )
			Endfor
			For i = 1 To loCol.oColTables.Count
				=Messagebox( "KeyValue: "+loCol.oColTables.GetKey( i))
			Endfor

		Endfor

		For i = 1 To loNewMain.oCol.Count
			=Messagebox( "loNewMain.oCol KeyValue: "+loNewMain.oCol.GetKey( i))
		Endfor

		oHeader = loNewMain.oCol.Item( "corderheader" )
		oDetail = loNewMain.oCol.Item( "corderdetails" )


	Endif

	loNewMain = Null

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

	loError.Process( oErr )

Finally

Endtry


*_ End Test


*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxXmlAdapter
*!* ParentClass...: XMLAdapter
*!* BaseClass.....: XMLAdapter
*!* Description...: Personaliza XMLAdapter, agregándole funcionalidad
*!* Date..........: Domingo 11 de Diciembre de 2005 (11:11:03)
*!* Author........: Ricardo Aidelman
*!* Project.......: Visual Praxis Beta 1.1
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class prxXMLAdapter As Xmladapter

	#If .F.
		Local This As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"
	#Endif

	*!* Guarda una referencia al objeto que va a adaptar
	oObj = Null

	*!* Indica si se cargo un Objeto para adaptarlo
	IsObjectLoaded = .F.

	*!* Contiene una clave provisoria del cursor MainCursor
	CursorKey = 0

	*!* Error Flag
	lIsOk = .T.

	*!* XML con  la reprentación del objeto ERROR
	cXMLoError = ""

	*!* Indica si la propiedad _memberdata es procesa o no
	PreserveMemberData = .F.


	*!* Filtro para la funcion aMembers() en el metodo ObjectToCursor
	LoadObjectFilter = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="oobj" type="property" display="oObj" />] + ;
		[<memberdata name="isobjectloaded" type="property" display="IsObjectLoaded" />] + ;
		[<memberdata name="cursorkey" type="property" display="CursorKey" />] + ;
		[<memberdata name="lIsOk" type="property" display="lIsOk" />] + ;
		[<memberdata name="cxmloerror" type="property" display="cXMLoError" />] + ;
		[<memberdata name="preservememberdata" type="property" display="PreserveMemberData" />] + ;
		[<memberdata name="loadobjectfilter" type="property" display="LoadObjectFilter" />] + ;
		[<memberdata name="getdiffgram" type="method" display="GetDiffGram" />] + ;
		[<memberdata name="loadobj" type="method" display="LoadObj" />] + ;
		[<memberdata name="toobject" type="method" display="ToObject" />] + ;
		[<memberdata name="loadtables" type="method" display="LoadTables" />] + ;
		[<memberdata name="objecttocursor" type="method" display="ObjectToCursor" />] + ;
		[<memberdata name="cursortoobject" type="method" display="CursorToObject" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Init
	*!* Description...:
	*!* Date..........: Domingo 11 de Diciembre de 2005 (18:40:46)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	*!*		Procedure Init(  ) As Boolean

	*!*	*!*			Set Path To Addbs(FL_SOURCE) Additive

	*!*			Set Step On
	*!*			Return .T.
	*!*		Endproc
	*!*
	*!* END PROCEDURE Init
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetDiffGram
	*!* Description...: Crea un DiffGram y lo devuelve
	*!* Date..........: Domingo 11 de Diciembre de 2005 (11:08:31)
	*!* Author........: Ricardo Aidelman
	*!* Project.......:  Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetDiffGram(  ) As String;
			HELPSTRING "Crea un DiffGram y lo devuelve"

		Local lcRetVal As String,;
			lcSchemaLocation As String

		Local llFile As Boolean,;
			llIncludeBefore As Boolean,;
			llChangesOnly  As Boolean

		lcRetVal 			= ""
		lcSchemaLocation 	= ""
		llFile 				= .F.
		llIncludeBefore 	= .T.
		llChangesOnly 		= .T.

		Try

			With This As Xmladapter

				.ReleaseXML( .F. )
				.IsDiffGram = .T.

				* Es muy importante preservar los espacios en blanco para ;
				aplicar luego el DiffGram, si no los cambios no son efectuados.
				.PreserveWhiteSpace = .T.

				.WrapMemoInCDATA = .T.

				.ToXML( "lcRetVal", ;
					lcSchemaLocation, ;
					llFile, ;
					llIncludeBefore, ;
					llChangesOnly )

			Endwith

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

			This.lIsOk = .F.
			This.cXMLoError = loError.Process()
			Throw loError

		Finally

		Endtry


		Return lcRetVal

	Endproc
	*!*
	*!* END PROCEDURE GetDiffGram
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: LoadObj
	*!* Description...: Carga un Objeto para ser adaptado
	*!* Date..........: Domingo 11 de Diciembre de 2005 (11:17:47)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!* tcFilter:	Ver AMembers()

	Procedure LoadObj( toObj As Object,;
			tcFilter As String ) As Boolean;
			HELPSTRING "Carga un Objeto para ser adaptado"

		If Vartype(toObj)<>"O" .Or. This.IsLoaded
			This.IsObjectLoaded = .F.

		Else
			This.oObj = toObj
			This.IsObjectLoaded = .T.
			If Vartype( tcFilter ) <> "C"
				tcFilter = ""
			Endif
			This.LoadObjectFilter = Upper( tcFilter )

		Endif

		Return This.IsObjectLoaded
	Endproc
	*!*
	*!* END PROCEDURE LoadObj
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ToObject
	*!* Description...: Transforma un XML en un Objecto
	*!* Date..........: Domingo 11 de Diciembre de 2005 (12:03:24)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ToObject(  ) As Object;
			HELPSTRING "Transforma un XML en un Objecto"

		Local loObj As Object
		Local	lcMainAlias As String,;
			lcAlias As String
		Local loTable As Xmltable

		If This.lIsOk
			If This.IsLoaded
				Try
					For Each loTable In This.Tables
						If Used( loTable.Alias )
							Use In Alias( loTable.Alias )
						Endif
						loTable.ToCursor()
					Endfor

					lcMainAlias = This.Tables.Item(1).Alias

					If Type("&lcMainAlias..CursorKey") == "N"
						* El XML fue creado con el metodo ToXML, y contiene una ;
						tabla principal en Item(1) con información para ;
						recomponer el objeto original

						Select * From &lcMainAlias ;
							Where CursorKey = 0 ;
							Into Cursor "cCursor"

						lcAlias = Alltrim(cCursor.ChildAlias)
						Use In Alias("cCursor")
					Else
						* Convierte el registro en un objeto "plano"
						lcAlias = lcMainAlias

					Endif

				Catch To oErr
					Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
					loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

					This.lIsOk = .F.
					This.cXMLoError = loError.Process()

				Finally

				Endtry

				If This.lIsOk
					loObj = This.CursorToObject( lcAlias, lcMainAlias )
				Endif

				Local oTable As Xmltable
				For Each oTable In This.Tables
					If Used(oTable.Alias)
						Use In Alias(oTable.Alias)
					Endif
				Endfor

				Return loObj

			Else
				Try
					Local lcXML As String
					This.ToXML( "lcXML" )
					This.LoadXML( lcXML )

				Catch To oErr
					Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
					loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

					This.lIsOk = .F.
					This.cXMLoError = loError.Process()

				Finally

				Endtry
				If This.lIsOk
					Return This.ToObject()
				Endif
			Endif
		Endif
	Endproc
	*!*
	*!* END PROCEDURE ToObject
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CursorToObject
	*!* Description...: Crea un Objeto a partir de un cursor
	*!* Date..........: Lunes 12 de Diciembre de 2005 (19:51:14)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta v. 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Hidden Procedure CursorToObject( tcAlias As String,;
			tcMainAlias As String ) As Object;
			HELPSTRING "Crea un Objeto a partir de un cursor"

		Local loObj As Object
		Local laFields(1)
		Local lnLen As Integer,;
			lnI As Integer

		Local lcPropertyName As String,;
			lcAlias As String,;
			lcValue As String,;
			lcKeyValue As String

		Local Array laObj[ 1 ]

		Try
			If Used(tcAlias)

				Select Alias( tcAlias )

				lnLen = Afields(laFields, Alias(tcAlias))

				If !Empty(Ascan(laFields,"baseclass",1,lnLen,1,1)) ;
						.And. Lower(&tcAlias..BaseClass)=="collection"

					* Las colecciones se manejan de un modo especial
					Local loElement As Object
					Local lcColAlias As String

					loObj = Newobject( "PrxCollection" ,"PrxBaseLibrary.prg" )
					lcColAlias = Sys(2015)


					* Se obtienen todos los elementos que conforman la ;
					coleccion
					Select * From &tcMainAlias ;
						Where ParentAlias = tcAlias .And. ;
						Lower(PropertyName) = "baseclass" ;
						Into Cursor &lcColAlias

					Select Alias( lcColAlias )
					Locate

					Scan
						lcAlias = Alltrim(&lcColAlias..ChildAlias)
						loElement=This.CursorToObject( lcAlias, ;
							tcMainAlias )

						lcKeyValue = Alltrim( &lcColAlias..KeyValue )

						* Se agrega el objeto a la colección
						If Empty( lcKeyValue )
							loObj.AddItem( loElement )
						Else
							loObj.AddItem( loElement, lcKeyValue )
						Endif


					Endscan

					Use In Alias(lcColAlias)

				Else

					* Se convierte el cursor en un objeto
					Scatter Memo Name loObj
					If Vartype( loObj ) == "O"

						Amembers(laObj, loObj)
						For Each lcPropertyName In laObj

							If Vartype( loObj.&lcPropertyName ) == "C"
								lcValue = Alltrim( loObj.&lcPropertyName )

								loObj.&lcPropertyName = lcValue
								If tcAlias <> tcMainAlias
									If "(object)"==Lower(lcValue) Or ;
											"(objeto)"==Lower(lcValue)

										* Actualizar la propiedad con el objeto ;
										correspondiente
										Select * From &tcMainAlias ;
											Where ParentAlias = tcAlias .And. ;
											PropertyName = lcPropertyName ;
											Into Cursor "cCursor"

										lcAlias = Alltrim(cCursor.ChildAlias)
										Use In Alias("cCursor")

										loObj.&lcPropertyName = This.CursorToObject( lcAlias, ;
											tcMainAlias )

									Endif
								Endif
							Endif
						Endfor
					Endif
				Endif
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

			This.lIsOk = .F.
			This.cXMLoError = loError.Process()

		Finally

		Endtry

		Return loObj
	Endproc
	*!*
	*!* END PROCEDURE CursorToObject
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ToXml
	*!* Description...: Devuelve un XML a partir de un Objeto
	*!* Date..........: Domingo 11 de Diciembre de 2005 (12:17:07)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ToXML( cXMLDocument As String, ;
			cSchemaLocation As String, ;
			lFile As Boolean, ;
			lIncludeBefore As Boolean, ;
			lChangesOnly As Boolean ) As Void;
			HELPSTRING "Devuelve un XML a partir de un Objeto"

		Do Case
			Case Pcount()=1
				cSchemaLocation = ""
				lFile = .F.
				lIncludeBefore = .F.
				lChangesOnly = .F.

			Case Pcount()=2
				lFile = .F.
				lIncludeBefore = .F.
				lChangesOnly = .F.

			Case Pcount()=3
				lIncludeBefore = .F.
				lChangesOnly = .F.

			Case Pcount()=4
				lChangesOnly = .F.

			Otherwise

		Endcase

		Try
			If This.IsObjectLoaded .And. !This.IsLoaded
				This.LoadTables()
			Endif

			DoDefault( cXMLDocument, ;
				cSchemaLocation, ;
				lFile, ;
				lIncludeBefore, ;
				lChangesOnly )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

			This.lIsOk = .F.
			This.cXMLoError = loError.Process()

		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE ToXml
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: LoadTables
	*!* Description...: Carga la colección Tables a partir de un Objeto
	*!* Date..........: Domingo 11 de Diciembre de 2005 (12:27:17)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Hidden Procedure LoadTables() As Void;
			HELPSTRING "Carga la colección Tables a partir de un Objeto"

		Local lcAlias As String,;
			lcMainAlias As String

		Local loTable As Xmltable

		Try

			lcMainAlias = Sys(2015)
			Do While Used(lcMainAlias)
				lcMainAlias = Sys(2015)
			Enddo

			Create Cursor &lcMainAlias ;
				( CursorKey Integer, ;
				ParentAlias Char(10), ;
				PropertyName Char(250),;
				ChildAlias Char(10),;
				KeyValue Char(250))

			For Each loTable In This.Tables
				If Used(loTable.Alias)
					Use In Alias(loTable.Alias)
				Endif
			Endfor

			This.AddTableSchema(lcMainAlias)

			lcAlias = This.ObjectToCursor( This.oObj, lcMainAlias )

			Insert Into &lcMainAlias ;
				(CursorKey, ParentAlias, PropertyName, ChildAlias) ;
				Values (0, Space(0), Space(0), lcAlias)

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

			This.lIsOk = .F.
			This.cXMLoError = loError.Process()

		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE LoadTables
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ObjectToCursor
	*!* Description...: Crea un Cursor a partir de las propiedades de un objeto
	*!* Date..........: Domingo 11 de Diciembre de 2005 (12:40:02)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Hidden Procedure ObjectToCursor( oObj As Object,;
			tcMainAlias As String ) As String;
			HELPSTRING "Crea un Cursor a partir de las propiedades de un objeto"

		Local lcFieldNameList 	As String,;
			lcFieldNameStr 		As String,;
			lcFieldValues 			As String,;
			lcPropertyName 		As String,;
			lcLen 					As String,;
			lcStr 					As String,;
			lcCommand 				As String,;
			lcXML						As String,;
			lcAlias 					As String,;
			lcChildAlias 			As String,;
			lcBaseClass				As String,;
			lcFilter					As String

		Local Array laMember[ 1 ]

		Local lnLen 	As Integer,;
			lnLengh 		As Integer,;
			lnI 			As Integer,;
			lnCursorKey As Integer

		Local lcType 	As Character

		Local loObj 	As Object

		*!* Crear el cursor a partir del objeto

		lcFieldNameList 	= ""	&& Lista de nombres de Campo
		lcFieldNameStr 	= ""  	&& Lista de nombres de Campo con estructura
		lcFieldValues 		= "" 	&& Lista de valores de cada campo

		Try

			Try
				lcBaseClass = Lower( oObj.BaseClass )

			Catch To oErr
				lcBaseClass = ""

			Finally

			Endtry

			Do Case
				Case lcBaseClass = "collection"
					lcFilter = ""

				Case lcBaseClass = "exception"
					lcFilter = ""

				Otherwise
					lcFilter = This.LoadObjectFilter

			Endcase

			lnLen	= Amembers( laMember, oObj, 0, lcFilter )

			If !This.PreserveMemberData
				Local i As Integer
				For i = 1 To lnLen
					laMember[ i ] = Upper( laMember[ i ] )
				Endfor
				i = Ascan( laMember, "_MEMBERDATA" )
				If !Empty( i )
					Adel( laMember, i )
					lnLen = lnLen - 1
				Endif
			Endif


			Local luValue[lnLen]

			This.CursorKey	= This.CursorKey + 1
			lnCursorKey 	= This.CursorKey

			For lnI = 1 To lnLen
				lcPropertyName = laMember[ lnI ]

				lcFieldNameList = lcFieldNameList + lcPropertyName + ", "


				Try
					luValue[ lnI ] = oObj.&lcPropertyName

				Catch To oErr
					luValue[ lnI ] = ""

				Finally

				Endtry


				*!* Armar la estructura en función del tipo de campo
				lcType = Vartype( luValue[ lnI ] )

				Do Case
					Case lcType == "C"
						lnLengh = Len( luValue[ lnI ] )
						If lnLengh>250
							lcType = "M NOCPTRANS, "

						Else
							lcLen=Any2Char(Max(lnLengh,1))
							lcType = "C (&lcLen.) NOCPTRANS, "

						Endif

					Case lcType == "N"
						lnLengh 	= LenNum( luValue[ lnI ] )
						lcLen 	= Any2Char( lnLengh )
						lcType 	= "N (&lcLen."
						lnLengh 	= LenNum( luValue[ lnI ], .T. )
						If !Empty( lnLengh )
							lcLen 	= Any2Char( lnLengh )
							lcType	= lcType + ",&lcLen.), "

						Else
							lcType 	= lcType + "), "

						Endif

					Case lcType == "L"
						lcType = "L ,"

					Case lcType == "D"
						lcType = "D ,"

					Case lcType == "T"
						lcType = "T ,"

					Case lcType == "X"	&& .Null.
						lcType = "C (1), "
						luValue[ lnI ] = ""

					Case lcType == "O"
						luValue[ lnI ] = Any2Char( luValue[ lnI ] )
						lcType="C"
						lnLengh = Len( luValue[ lnI ] )
						If lnLengh > 250
							lcType = "M NOCPTRANS, "

						Else
							lcLen = Any2Char( Max( lnLengh, 1 ) )
							lcType = "C (&lcLen.) NOCPTRANS, "

						Endif

					Otherwise
						lcType = "C ,"
						luValue[ lnI ] = Any2Char( luValue[ lnI ] )

				Endcase


				lcFieldNameStr = lcFieldNameStr +  lcPropertyName + " " + lcType
				lcFieldValues = lcFieldValues +  "luValue[" + Any2Char( lnI ) +"], "

				Try

					loObj = oObj.&lcPropertyName

					If Vartype( loObj ) == "O" .And. ;
							!Inlist( Lower( lcPropertyName ),;
							"objects"	,;
							"controls"	,;
							"parent"	,;
							"pages"		,;
							"buttons"	,;
							"omainobject",;
							"oparent"	,;
							"oerror"	)

						lcChildAlias = This.ObjectToCursor( loObj, tcMainAlias )
						Insert Into &tcMainAlias ;
							(CursorKey, ParentAlias, PropertyName, ChildAlias ) ;
							Values (lnCursorKey, Space(10), lcPropertyName, lcChildAlias)

					Endif
					If Lower( lcPropertyName ) == "baseclass" ;
							.And. Lower( oObj.&lcPropertyName ) == "collection"

						loObj = Null
						Local i As Integer
						Local lcKeyValue As String

						For i = 1 To oObj.Count
							loObj = oObj.Item( i )
							lcKeyValue = oObj.GetKey( i )
							lcChildAlias = This.ObjectToCursor( loObj, tcMainAlias )
							If !Empty( lcChildAlias )
								Insert Into &tcMainAlias ;
									(CursorKey, ParentAlias, PropertyName, ChildAlias, KeyValue ) ;
									Values (lnCursorKey, Space(10), lcPropertyName, lcChildAlias, lcKeyValue )
							Endif
						Endfor
					Endif


				Catch To oErr

				Finally

				Endtry

			Endfor

			*!* Eliminar la última coma (,) y encerrar entre paréntesis
			lcFieldNameStr = "(" + Alltrim(lcFieldNameStr)
			lcFieldNameStr = Substr(lcFieldNameStr, 1, Len(lcFieldNameStr) - 1 )
			lcFieldNameStr = lcFieldNameStr + ")"

			lcFieldNameList = "(" + Alltrim(lcFieldNameList)
			lcFieldNameList = Substr(lcFieldNameList, 1, Len(lcFieldNameList) - 1 )
			lcFieldNameList = lcFieldNameList + ")"

			lcFieldValues = "(" + Alltrim(lcFieldValues)
			lcFieldValues = Substr(lcFieldValues, 1, Len(lcFieldValues) - 1 )
			lcFieldValues = lcFieldValues + ")"

			lcAlias = Sys(2015)
			Do While Used(lcAlias)
				lcAlias = Sys(2015)
			Enddo

			*!* Crear el cursor
			TEXT TO lcCommand TEXTMERGE NOSHOW
			Create Cursor <<lcAlias>> <<lcFieldNameStr>>
			ENDTEXT

			lcCommand = CleanString( lcCommand )
			&lcCommand

			*!* Insertar un registro con los valores del objeto
			TEXT TO lcCommand TEXTMERGE NOSHOW
			Insert Into <<lcAlias>> <<lcFieldNameList>> Values <<lcFieldValues>>
			ENDTEXT

			lcCommand = CleanString( lcCommand )
			&lcCommand

			This.AddTableSchema( lcAlias )

			Update &tcMainAlias ;
				Set ParentAlias = lcAlias ;
				Where CursorKey = lnCursorKey

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

			This.lIsOk = .F.
			This.cXMLoError = loError.Process()

		Finally

		Endtry

		Return lcAlias

	Endproc
	*!*
	*!* END PROCEDURE ObjectToCursor
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Domingo 11 de Diciembre de 2005 (18:46:10)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy(  ) As Void

		If This.IsObjectLoaded
			Local oTable As Xmltable
			For Each oTable In This.Tables
				If Used(oTable.Alias)
					Use In Alias(oTable.Alias)
				Endif
			Endfor
		Endif

	Endproc
	*!*
	*!* END PROCEDURE Destroy
	*!*
	*!* ///////////////////////////////////////////////////////



Enddefine
*!*
*!* END DEFINE
*!* Class.........: PrxXmlAdapter
*!*
*!* ///////////////////////////////////////////////////////