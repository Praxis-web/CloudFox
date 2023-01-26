*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxQuery
*!* ParentClass...: prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....:
*!* Description...:
*!* Date..........: Lunes 24 de Mayo de 2010 (11:31:32)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxQuery As prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'

	#If .F.
		Local This As PrxQuery Of "V:\Clipper2fox\Fw\Tieradapter\Comun\Prxquery.prg"
	#Endif

	* Indica si serializa los cursores para pasarlos entre capas
	lSerialize = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lserialize" type="property" display="lSerialize" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="doquery" type="method" display="DoQuery" />] + ;
		[<memberdata name="createquery" type="method" display="CreateQuery" />] + ;
		[</VFPData>]

	*
	* Ejecuta una consulta
	Procedure DoQuery( toQuery As Object ) As Boolean;
			HELPSTRING "Ejecuta una consulta"

		Local llOk As Boolean
		Local loDataTier As PrxDataTier Of "Fw\Tieradapter\Comun\Prxdatatier.prg"
		Local lcSQLCommand As String
		Local lcXML As String
		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"
		Local loTable As Xmltable

		Try
			llOk = .T.
			lcSQLCommand = This.CreateQuery( toQuery )
			loDataTier = Newobject( "PrxDataTier", "Prxdatatier.prg" )

			*			StrToFile( lcSQLCommand, "SQLCommand.prg" )

			Wait "Ejecutando Consulta ..." Window Nowait
			lcXML = loDataTier.SQLExecute( lcSQLCommand, toQuery.cCursorName )

			If !Empty( _Tally )
				Wait Transform( _Tally ) + " Registros Encontrados ..." Window Nowait

			Else
				Wait "No se encontraron registros coincidentes ..." Window Nowait
				llOk = .F.

			Endif

			If This.lSerialize
				loXA = Newobject("prxXMLAdapter","prxXMLAdapter.prg")
				loXA.LoadXML( lcXML, .F. )

				For Each loTable In loXA.Tables
					Use In Select( loTable.Alias )
					loTable.ToCursor( .F. )
				Endfor
			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			llOk = .F.
			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loDataTier = Null
			loXA = Null
			loTable = Null

		Endtry

		Return llOk

	Endproc && DoQuery


	*
	* Devuelve el comando para ejecutar la consulta
	Procedure CreateQuery( toQuery As Object ) As String;
			HELPSTRING "Devuelve el comando para ejecutar la consulta"

		Local lcSQLCommand As String
		Local lcDistinct As String
		Local lcTop As String
		Local lcForce As String
		Local lcJoin As String
		Local lcBuffering As String
		Local lcWhereConditions As String
		Local lcGroupBy As String
		Local lcHaving As String
		Local lcUnion As String
		Local lcOrderBy As String

		Local loQuery As oQuery Of "V:\Clipper2fox\Fw\Tieradapter\Comun\Prxquery.prg"

		Try

			lcDistinct 			= Iif( toQuery.lDistinct, "DISTINCT", "" )
			lcTop 				= Iif( !Empty( toQuery.nTop ), "TOP " + Transform( toQuery.nTop ), "" )
			lcForce 			= Iif( toQuery.lForce, "FORCE", "" )
			lcJoin 				= Iif( !Empty( toQuery.cJoin ), toQuery.cJoin, "" )
			lcBuffering 		= Iif( toQuery.lBuffering, "WITH ( BUFFERING = .T. )", "" )
			lcWhereConditions 	= Iif( !Empty( toQuery.cWhereConditions ), "WHERE " + toQuery.cWhereConditions, "" )
			lcGroupBy 			= Iif( !Empty( toQuery.cGroupBy ), "GROUP BY " + toQuery.cGroupBy, "" )
			lcHaving 			= Iif( !Empty( toQuery.cHaving ), "HAVING " + toQuery.cHaving, "" )
			lcOrderBy 			= Iif( !Empty( toQuery.cOrderBy ), "ORDER BY " + toQuery.cOrderBy, "" )
			lcUnion 			= ""

			For Each loQuery In toQuery.oUnion
				*!*					lcUnion = "UNION ALL ( " + This.CreateQuery( loQuery ) + " )"
				
				loQuery.cOrderBy = ""
				lcUnion = "UNION " + This.CreateQuery( loQuery )
			Endfor

			TEXT To lcSQLCommand NoShow TextMerge Pretext 15
			SELECT <<lcDistinct>> <<lcTop>> <<toQuery.cSelectListItem>>
			   FROM <<lcForce>> <<toQuery.cFromTableList>> <<lcJoin>>
			   <<lcBuffering>>
			   WHERE <<toQuery.cWhereConditions>>
			   <<lcGroupBy>>
			   <<lcHaving>>
			   <<lcUnion>>
			   <<lcOrderBy>>
			ENDTEXT

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loQuery = Null
			toQuery = Null

		Endtry

		Return lcSQLCommand

	Endproc && CreateQuery

	*
	* Devuelve un objeto oQuery
	Procedure New(  ) As Object;
			HELPSTRING "Devuelve un objeto oQuery"

		Local loQuery As oQuery Of "V:\Clipper2fox\Fw\Tieradapter\Comun\Prxquery.prg"

		Try

			loQuery = Newobject( "oQuery", "Prxquery.prg" )


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loQuery

	Endproc && New


Enddefine
*!*
*!* END DEFINE
*!* Class.........: PrxQuery
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oQuery
*!* ParentClass...: Custom
*!* BaseClass.....: Custom
*!* Description...:
*!* Date..........: Lunes 24 de Mayo de 2010 (12:59:55)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class oQuery As Custom

	#If .F.
		Local This As oQuery Of "V:\Clipper2fox\Fw\Tieradapter\Comun\Prxquery.prg"
	#Endif

	* Exclude duplicates of any rows from the query results. You can use DISTINCT only once per SELECT clause.
	lDistinct = .F.

	* Specifies that the query result contain a specific number of rows. For nExpr, you can specify 1 to 32,767 rows. Visual FoxPro sorts records first and then extracts the TOP nExpr records.
	nTop = 0

	* Specifies one or more items to match and include in the query results.
	cSelectListItem = "*"

	* Specifies one or more tables containing the data that the query retrieves from.
	cFromTableList = ""

	* Specifies that the tables in the table list are joined in the order they appear in the FROM clause.
	lForce = .F.

	* Specifies a JOIN clause for retrieving data from more than one table.
	cJoin = ""

	* If you set BUFFERING to True (.T.), you can query data from a local buffered cursor, which may include records that have been updated but not committed. Otherwise, your results include only records committed to disk.
	lBuffering = .F.

	* Specifies criteria that records must meet to be included in the query results.
	cWhereConditions = "1 > 0"

	* Specifies one or more columns used to group rows returned by the query. Columns referenced in the SQL SELECT statement list, except for aggregate expressions, must be included in the GROUP BY clause. You cannot group by Memo, General, or Blob fields.
	cGroupBy = ""

	* The UNION clause combines the results from two or more SQL SELECT statements into a single result set containing rows from all the queries in the UNION operation.
	oUnion = Null

	*
	cHaving = ""

	* Specifies one or more items used to sort the final query result set and the order for sorting the results.
	cOrderBy = ""

	* Nombre del cursor que contiene la consulta
	cCursorName = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ccursorname" type="property" display="cCursorName" />] + ;
		[<memberdata name="corderby" type="property" display="cOrderBy" />] + ;
		[<memberdata name="chaving" type="property" display="cHaving" />] + ;
		[<memberdata name="ounion" type="property" display="oUnion" />] + ;
		[<memberdata name="ounion_access" type="method" display="oUnion_Access" />] + ;
		[<memberdata name="cgroupby" type="property" display="cGroupBy" />] + ;
		[<memberdata name="cwhereconditions" type="property" display="cWhereConditions" />] + ;
		[<memberdata name="lbuffering" type="property" display="lBuffering" />] + ;
		[<memberdata name="cjoin" type="property" display="cJoin" />] + ;
		[<memberdata name="lforce" type="property" display="lForce" />] + ;
		[<memberdata name="cfromtablelist" type="property" display="cFromTableList" />] + ;
		[<memberdata name="cselectlistitem" type="property" display="cSelectListItem" />] + ;
		[<memberdata name="ntop" type="property" display="nTop" />] + ;
		[<memberdata name="ldistinct" type="property" display="lDistinct" />] + ;
		[</VFPData>]



	*
	* oUnion_Access
	Protected Procedure oUnion_Access()
		If Vartype( This.oUnion ) # "O"
			This.oUnion = Createobject( "Collection" )
		Endif

		Return This.oUnion

	Endproc && oUnion_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oQuery
*!*
*!* ///////////////////////////////////////////////////////