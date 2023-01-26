*!*///////////////////////////////////////////////////////
*!* Class.........: prxCursorAdapter
*!* ParentClass...: CursorAdapter
*!* BaseClass.....: CursorAdapter
*!* Description...: Personalized CursorAdapter
*!* Date..........: Viernes 13 de Enero de 2006 (17:48:55)
*!* Author........: Ricardo Aidelman
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#INCLUDE "Tools\ErrorHandler\include\eh.h"

#Define DEBUGMODE .F.

Define Class prxCursorAdapter As CursorAdapter

	#If .F.
		Local This As prxCursorAdapter Of "fw\tieradapter\comun\prxCursorAdapter.prg"
	#Endif

	*!* Propiedades del objeto error en formato XML
	cXMLoError = ""

	BreakOnError   = .F.
	DataSourceType = ""
	oADOCommand    = Null
	oADORecordset  = Null
	cXMLoError = ""
	*!* Motor de Base de Datos
	cBackEndEngine = "FOX"

	cOldSetCentury = Set("Century")
	cOldSetDate = Set("Date")

	* Referencia al objeto Error
	oError = Null
	*
	lHasError = .F.

	* Si trabajo conectado, no puedo cerrar las tablas
	* Solo vale para Clipper2Fox
	* RA 2010-05-23(13:59:57)
	lCloseNativeTables = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cBackEndEngine" type="property" display="cBackEndEngine" />] + ;
		[<memberdata name="cXMLoError" type="property" display="cXMLoError" />] + ;
		[<memberdata name="breakonerror" type="property" display="BreakOnError" />] + ;
		[<memberdata name="datasourcetype" type="property" display="DataSourceType" />] + ;
		[<memberdata name="oadocommand" type="property" display="oADOCommand" />] + ;
		[<memberdata name="oadorecordset" type="property" display="oADORecordset" />] + ;
		[<memberdata name="selectcmd_assign" type="method" display="SelectCmd_Assign" />] + ;
		[<memberdata name="validatesqlstatement" type="method" display="ValidateSqlStatement" />] + ;
		[<memberdata name="oerror" type="property" display="oError" />] + ;
		[<memberdata name="lhaserror" type="property" display="lHasError" />] + ;
		[<memberdata name="gettablesfromsql" type="method" display="GetTablesFromSQL" />] + ;
		[<memberdata name="lclosenativetables" type="property" display="lCloseNativeTables" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SelectCmd_Assign
	*!* Description...:
	*!* Date..........: Viernes 13 de Enero de 2006 (17:58:29)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure SelectCmd_Assign

		Lparameters vNewVal
		This.SelectCmd = This.ValidateSqlStatement( CleanString( m.vNewVal ) )

	Endproc
	*!*
	*!* END PROCEDURE SelectCmd_Assign
	*!*
	*!* ///////////////////////////////////////////////////////


	Procedure AfterDelete
		* This procedure was added according to Aleksey's answer to the error ;
		below Row handle referred to a deleted row or a row marked for deletion"
		Lparameters cFldState, lForce, cDeleteCmd, lResult
		If Upper(This.DataSourceType)="ADO"
			This.Datasource.MoveFirst()
		Endif
	Endproc

	*-----------------------------------------------------------------------------------------
	Function Init(tcDataSourceType As String, ;
			tuConnection As Variant,;
			tcBackEndEngine As String )
		*-----------------------------------------------------------------------------------------
		This.DataSourceType = IfEmpty( tcDataSourceType, "NATIVE" )
		This.cBackEndEngine = IfEmpty( tcBackEndEngine, "FOX" )

		Do Case
			Case Upper(This.DataSourceType)="ADO"
				* Once detached, the cursor is independent from the CursorAdapter ;
				object, but not from its data source. ;
				You can use CURSORGETPROP("ADORecordset") to get the Recordset ;
				associated with the cursor even if it is detached from the ;
				CursorAdapter object. ;
				If you close the connection when the cursor is not fetched completely ;
				and then try to fetch more records an error is reported. ;
				To avoid this problem, execute ;
				GO BOTTOM before closing connection or use ;
				oCA.FetchSize = -1 when you call CursorFill.

				This.FetchSize = -1  && retrieves the complete result set.

				If Vartype(This.oADOCommand) <> "O"
					This.oADOCommand = Createobject("ADODB.Command")
					This.oADOCommand.ActiveConnection = tuConnection
				Endif

				If Vartype(This.oADORecordset) <> "O"
					This.oADORecordset = Createobject("ADODB.Recordset")

					With This.oADORecordset
						.CursorLocation 	= 3 &&adUseClient
						.LockType 			= 3 &&adLockOptimistic
						.ActiveConnection 	= tuConnection
					Endwith

					This.Datasource = This.oADORecordset
				Endif

			Case Upper(This.DataSourceType)="ODBC"
				This.Datasource = tuConnection

			Otherwise

		Endcase


	Endfunc

	*-----------------------------------------------------------------------------------------
	Function Destroy()
		*-----------------------------------------------------------------------------------------
		This.oADORecordset = Null
		This.oADOCommand = Null
		This.oError = Null

	Endfunc

	*-----------------------------------------------------------------------------------------
	Function BeforeCursorFill( lUseCursorSchema As Boolean ,;
			lNoDataOnLoad As Boolean,;
			cSelectCmd As String )
		*-----------------------------------------------------------------------------------------

		Set Century On
		Set Date To YMD

		* Si el origen de datos es ADO, CursorFill intentará abrir el Recordset ;
		al menos que este sea pasado como 4to parámetro, para lo cual ya debe ;
		estar abierto. Dado que hay ocasiones, en el Put() por ejemplo, en que ;
		se hacen 2 CursorFill seguidos para el mismo CursorAdapter, la segunda ;
		vez generaba un error dado que el ADORecorset ya estaba abierto.

		If Upper(This.DataSourceType)="ADO"
			If This.oADORecordset.State = 1 &&adStateOpen
				This.oADORecordset.Close()
			Endif
		Endif

		* Si el cursor a generar ya existe, lo cierro.
		Use In Select( This.Alias )

	Endfunc


	*!*	Procedure CursorFill()
	*!*	Set Step On
	*!*	DoDefault()
	*!*	EndProc

	*-----------------------------------------------------------------------------------------
	Protected Procedure AfterCursorFill( lUseCursorSchema As Boolean,;
			lNoDataOnLoad As Boolean,;
			cSelectCmd As String,;
			lResult As Boolean)
		*-----------------------------------------------------------------------------------------
		Local lcTables As String
		Local lcTable As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			If Upper( This.DataSourceType ) = "NATIVE"
				* CursorFill by default leaves local tables open so we need to close
				* it manually. Because of this you need to watch out; with NATIVE you
				* need to name your CursorAdapter Aliases DIFFERENT than the base
				* table name.

				If This.lCloseNativeTables && Si trabajo conectado, no puedo cerrar las tablas
					* Solo vale para Clipper2Fox
					* RA 2010-05-23(13:59:57)

					lcTables = Alltrim( This.Tables ) + ',' + This.GetTablesFromSQL( This.SelectCmd ) + ','
					If ! Empty( lcTables )
						For i = 1 To Getwordcount( lcTables,  ',' )
							lcTable = Getwordnum( lcTables, i, ',' )
							Use In Select( lcTable )

						Endfor

					Endif && ! Empty( lcTables )

					Use In Select( This.Tables )
				Endif

			Endif && Upper(This.DataSourceType) = "NATIVE"

			*!*	--------------------------------------------------------------------
			*!*	Unique Table, Unique Schema, Unique Catalog Properties—Dynamic (ADO)
			*!*	--------------------------------------------------------------------
			* Enables you to closely control modifications to a particular base table ;
			in a Recordset that was formed by a JOIN operation on multiple base ;
			tables.

			* - Unique Table: specifies the name of the base table upon which updates, ;
			insertions, and deletions are allowed.
			* - Unique Schema: specifies the schema, or name of the owner of the table.
			* - Unique Catalog: specifies the catalog, or name of the database ;
			containing the table.

			*!*	Remarks

			* The desired base table is uniquely identified by its catalog, schema, ;
			and table names. ;
			When the Unique Table property is set, the values of the Unique Schema ;
			or Unique Catalog properties are used to find the base table. ;
			It is intended, but not required, that either or both the Unique Schema ;
			and Unique Catalog properties be set before the Unique Table property is ;
			set.

			* The primary key of the Unique Table is treated as the primary key of ;
			the entire Recordset.
			* This is the key that is used for any method requiring a primary key.

			* While Unique Table is set, the Delete method affects only the named table.
			* The AddNew, Resync, Update, and UpdateBatch methods affect any ;
			appropriate underlying base tables of the Recordset.

			* Unique Table must be specified before doing any custom resynchronizations.
			* If Unique Table has not been specified, the Resync Command property ;
			will have no effect.

			* A run-time error results if a unique base table cannot be found.

			* These dynamic properties are all appended to the Recordset object ;
			Properties collection when the CursorLocation property is set to ;
			adUseClient.

			If Upper( This.DataSourceType ) = "ADO" ;
					And Not Empty( This.Tables ) ;
					And Occurs( [,], This.Tables ) = 0

				* RR, 03/10/2004: por lo indicado en el comentario anterior y si: ;
				- Not Empty(This.Tables)      --->   no está vacía la propiedad ;
				(sería el caso si se ejecuta una Stored Procedure) ;
				- Occurs([,],This.Tables)=0   --->   se refiere a una tabla ;
				(no es una lista de tablas)

				* Esto lo hago ya que es posible que en la DataTier se contruya el ;
				GetOne con un Select resultante de un JOIN de múltiples tablas.

				This.Datasource.Properties("Unique Table") = This.Tables
			Endif

			If lResult
				* Todo OK!
			Else
				*!*					Strtofile( Ttoc( Datetime()) + Chr(13) + This.SelectCmd + Chr(13) + Chr(13), "__ERROR__SelectCmd.prg", 1 )
				Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

				TEXT To lcCommand NoShow TextMerge Pretext 03
				<<This.SelectCmd>>

				Alias: <<This.Alias>>
				Tables: <<This.Tables>>
				UpdatableFieldList: <<This.UpdatableFieldList>>
				UpdateNameList: <<This.UpdateNameList>>
				KeyFieldList: <<This.KeyFieldList>>
				ENDTEXT

				*Strtofile( lcCommand, "Error.txt" )

				loError.Ctracelogin = "prxCursorAdapter.AfterCursorFill()"
				loError.Cremark = lcCommand
				loError.TierBehavior = EH_LOGERROR
				loError.cTierLevel = "Data"

				loError.Process()
				*!*					This.cXMLoError = loError.ErrorToXml()
				This.oError = loError
				This.lHasError = .T.

			Endif


		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			Local lcOldSetDate As String,;
				lcOldSetCentury As String

			lcOldSetCentury = This.cOldSetCentury
			lcOldSetDate = This.cOldSetDate

			Set Century &lcOldSetCentury
			Set Date To &lcOldSetDate

			#If DEBUGMODE
				lcMsg = Transform( Datetime() ) + Chr( 13 ) ;
					+ This.Alias + Chr( 13 ) ;
					+ Strtran( Strtran( This.SelectCmd, ',' ,', ' ), Space( 2 ), Space( 1 ) ) + Chr( 13 )
				Strtofile( lcMsg, 'SQLDump.dump', 1 )

			#Endif

		Endtry

	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Function......: ValidateSqlStatement
	*!* Description...: Valida una instruccón T-SQL de acuerdo al Motor de BD
	*!* Date..........: Jueves 27 de Abril de 2006 (12:55:05)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function ValidateSqlStatement( tcSQL As String ) As String;
			HELPSTRING "Valida una instruccón T-SQL de acuerdo al Motor de BD"

		Local lcValidSQL As String

		lcValidSQL	= Alltrim( tcSQL )

		*!*				Set some words to upper
		lcValidSQL	= Strtran( lcValidSQL, " and ", " AND "	)
		lcValidSQL	= Strtran( lcValidSQL, " And ", " AND "	)
		lcValidSQL	= Strtran( lcValidSQL, " or ", " OR "	)
		lcValidSQL	= Strtran( lcValidSQL, " Or ", " OR "	)

		Do Case
			Case This.cBackEndEngine = "FOX"
				lcValidSQL	= Strtran( lcValidSQL, "<#", " ctod( '"	)
				lcValidSQL	= Strtran( lcValidSQL, "#>", "' ) "		)
				lcValidSQL	= Strtran( lcValidSQL, "<$", " ctot( '"	)
				lcValidSQL	= Strtran( lcValidSQL, "$>", "' ) "		)

			Case Inlist( This.cBackEndEngine, "SQL", "ORA", "INF" )
				*!*						Convert the empty dates in null values
				lcValidSQL	= Strtran( lcValidSQL, "<##>", "NULL" )
				lcValidSQL	= Strtran( lcValidSQL, "<$$>", "NULL" )

				*!*						convert the non empty dates
				lcValidSQL	= Strtran( lcValidSQL, "<#", " '" )
				lcValidSQL	= Strtran( lcValidSQL, "#>", "' " )
				lcValidSQL	= Strtran( lcValidSQL, "<$", " '" )
				lcValidSQL	= Strtran( lcValidSQL, "$>", "' " )

				lcValidSQL	= Strtran( lcValidSQL, ".t.", "1" )
				lcValidSQL	= Strtran( lcValidSQL, ".f.", "0" )
				lcValidSQL	= Strtran( lcValidSQL, "==", "=" )

				*!*						convert some functions to SQL compatible
				lcValidSQL	= Strtran( lcValidSQL, " alltrim("	, " rtrim("		)
				lcValidSQL	= Strtran( lcValidSQL, ",alltrim("	, ",rtrim("		)
				lcValidSQL	= Strtran( lcValidSQL, " trim("	, " rtrim("		)
				lcValidSQL	= Strtran( lcValidSQL, ",trim("	, ",rtrim("		)
				lcValidSQL	= Strtran( lcValidSQL, " substr("	, " substring("	)
				lcValidSQL	= Strtran( lcValidSQL, ",substr("	, ",substring("	)

				If This.cBackEndEngine = "SQL" And ( " NULL" $ lcValidSQL )
					lcValidSQL	= Strtran( lcValidSQL, "<> NULL", "Is Not NULL" )
					lcValidSQL	= Strtran( lcValidSQL, "> NULL", "Is Not NULL" )

					lcValidSQL	= Strtran( lcValidSQL, ">= NULL AND", "Is NULL Or" )
					lcValidSQL	= Strtran( lcValidSQL, "<= NULL", "Is NULL" )
					lcValidSQL	= Strtran( lcValidSQL, ">= NULL", "Is Not NULL" )
					lcValidSQL	= Strtran( lcValidSQL, "= NULL", "Is NULL" )

				Endif && This.cBackEndEngine = "SQL" And ( " NULL" $ lcValidSQL )

		Endcase

		Return lcValidSQL

	Endfunc && ValidateSqlStatement

	*!*	* GetTablesFromSQL
	*!*	Protected Function GetTablesFromSQL( tcSQL As String ) As String
	*!*		Local lcStr As String
	*!*		Local lcTablesNames As String
	*!*		Local lcAux As String
	*!*		Local lnOccurs As Integer

	*!*		lcStr = ""
	*!*		lcAux = ""
	*!*		lcTablesNames = ""
	*!*		tcSQL = Upper( tcSQL )
	*!*		lcStr = Strextract( tcSQL, "FROM", "WHERE" ) &&, 0, 3 )

	*!*		If Empty( lcStr )
	*!*			lcStr = Strextract( tcSQL, "FROM" )

	*!*		Endif

	*!*		lcStr = Strextract( lcStr, "", "ORDER BY", 0, 3 )

	*!*		lcTablesNames = Strextract( lcStr, "", "JOIN", 0, 3 )

	*!*		lcTablesNames = This.ExtractAlias( lcTablesNames )

	*!*		lnOccurs = Occurs( "JOIN", Upper( lcStr ) )

	*!*		For i = 1 To lnOccurs
	*!*			lcAux = Strextract( lcStr, "JOIN", "ON", i, 3 )

	*!*			lcTablesNames = lcTablesNames + "," + This.ExtractAlias( lcAux )

	*!*		Endfor

	*!*		Return lcTablesNames

	*!*	Endfunc && GetTablesFromSQL

	*
	* GetTablesFromSQL
	* DAE 2009-10-21(13:42:12)
	Function GetTablesFromSQL( tcSQL As String ) As String
		*Protected Function GetTablesFromSQL( tcSQL As String ) As String
		Local lcStr As String
		Local lcTablesNames As String
		Local lcTablesNameAux As String
		Local lcAux As String
		*
		Local lnCntFrom As Integer
		Local lnFromIndex As Integer
		Local lnCntJoin As Integer
		Local lnJoinIndex As Integer

		lcStr = ""
		lcAux = ""
		lcTablesNames = ""
		tcSQL = Upper( tcSQL )

		lcTablesNames = ''
		lcTablesNameAux = ''

		lnCntFrom = Occurs( "FROM", tcSQL )
		For lnFromIndex = 1 To lnCntFrom
			lcStr = Strextract( tcSQL, "FROM", "WHERE", lnFromIndex, 3 ) &&, 0, 3 )

			If Empty( lcStr )
				lcStr = Strextract( tcSQL, "FROM", '', lnFromIndex, 3 )

			Endif && Empty( lcStr )

			lcStr = Strextract( lcStr, "", "ORDER BY", 0, 3 )

			lcTablesNameAux = Strextract( lcStr, "", "JOIN", 0, 3 )

			lcAliasAux = This.ExtractAlias( lcTablesNameAux )
			If ! Inlist( lcAliasAux , '(', ')' )
				lcTablesNames = This.ConcatenarSiNoExiste( lcTablesNames, lcAliasAux )

			Endif && ! Inlist( lcAliasAux , '(', ')' )

		Endfor

		lnCntJoin = Occurs( "JOIN", tcSQL )
		For lnJoinIndex = 1 To lnCntJoin
			lcAux = Strextract( tcSQL, "JOIN ", " ON", lnJoinIndex, 3 )
			If ! Empty( lcAux )
				lcAliasAux = This.ExtractAlias( lcAux )
				If ! Inlist( lcAliasAux , '(', ')' )
					lcTablesNames = This.ConcatenarSiNoExiste( lcTablesNames, lcAliasAux )

				Endif && ! Inlist( lcAliasAux , '(', ')' )

			Endif && ! Empty( lcAux )

		Endfor

		Return lcTablesNames

	Endfunc && GetTablesFromSQL

	*
	* ConcatenarSiNoExiste
	* DAE 2009-10-21(13:42:04)
	Protected Function ConcatenarSiNoExiste( tcCadena As String, tcValor As String ) As String
		If ! ( tcValor $ tcCadena )
			If ! Empty( tcCadena )
				tcCadena = tcCadena + "," + tcValor

			Else
				tcCadena = tcValor

			Endif && ! Empty( tcCadena )

		Endif && ! ( tcValor $ tcCadena )

		Return tcCadena

	Endfunc && ConcatenarSiNoExiste

	* ExtractAlias
	Protected Function ExtractAlias( tcTablesNames As String ) As String

		Local lcAux As String
		lcAux = ""

		lcAux = Getwordnum( tcTablesNames, 1 )

		Do Case

			Case Empty( lcAux ) Or Inlist( Upper( lcAux ), "LEFT", "RIGHT", "INNER" )
				* lcAux  = Getwordnum( tcTablesNames, 1 )
				Error 'No existe el nombre de la tabla'

		Endcase

		Return lcAux

	Endfunc && ExtractAlias

	*
	* Hace un volcado del contenido de las propiedades
	Procedure DumpProperties(  ) As Void;
			HELPSTRING "Hace un volcado del contenido de las propiedades"

		Try

			lnLen = Amembers( laMember, This )
			lcFileName = This.Alias + ".txt"

			Strtofile( This.Alias + Chr(13), lcFileName )

			For i = 1 To lnLen
				lcProp = laMember[ i ]

				Try
					Strtofile(	lcProp + ": " + Transform( This.&lcProp ) + Chr(13), lcFileName, 1 )

				Catch To oErr

				Finally

				Endtry


			Endfor


		Catch To oErr
			Throw oErr

		Finally

		Endtry

	Endproc && DumpProperties

	*
	* BeforeInsert
	Proc BeforeInsert ( p1, p2, p3 )

		#If DEBUGMODE
			lcMsg = Transform( Datetime() ) +  Trans( Program() ) + Chr( 13 )
			For i = 1 To Pcount()
				lcMsg = + lcMsg + Chr( 9 ) + Transform( Eval( 'p' + Trans( i ) ) ) + Chr( 13 )

			Endfor

			Strtofile( lcMsg, 'SQLDump.dump', 1 )

		#Endif

	Endproc && BeforeInsert

	*
	* AfterInsert
	Procedure AfterInsert ( p1, p2, p3, p4 )
		#If DEBUGMODE
			lcMsg = Transform( Datetime() ) +  Trans( Program() ) + Chr( 13 )
			For i = 1 To Pcount()
				lcMsg = + lcMsg + Chr( 9 ) + Transform( Eval( 'p' + Trans( i ) ) ) + Chr( 13 )

			Endfor

			Strtofile( lcMsg, 'SQLDump.dump', 1 )

		#Endif

	Endproc && AfterInsert


	*
	* BeforeDelete
	Proc BeforeDelete ( p1, p2, p3 )

		#If DEBUGMODE
			lcMsg = Transform( Datetime() ) +  Trans( Program() ) + Chr( 13 )
			For i = 1 To Pcount()
				lcMsg = + lcMsg + Chr( 9 ) + Transform( Eval( 'p' + Trans( i ) ) ) + Chr( 13 )

			Endfor

			Strtofile( lcMsg, 'SQLDump.dump', 1 )

		#Endif

	Endproc && BeforeDelete

	*
	* AfterDelete
	Proc AfterDelete ( p1, p2, p3, p )

		#If DEBUGMODE
			lcMsg = Transform( Datetime() ) +  Trans( Program() ) + Chr( 13 )
			For i = 1 To Pcount()
				lcMsg = + lcMsg + Chr( 9 ) + Transform( Eval( 'p' + Trans( i ) ) ) + Chr( 13 )

			Endfor

			Strtofile( lcMsg, 'SQLDump.dump', 1 )

		#Endif

	Endproc && AfterDelete

	*
	* BeforeUpdate
	Proc BeforeUpdate ( p1, p2, p3, p4, p5 )

		#If DEBUGMODE

			lcMsg = Transform( Datetime() ) +  Trans( Program() ) + Chr( 13 )

			For i = 1 To Pcount()
				lcMsg = + lcMsg + Chr( 9 ) + Transform( Eval( 'p' + Trans( i ) ) ) + Chr( 13 )

			Endfor

			Strtofile( lcMsg, 'SQLDump.dump', 1 )

		#Endif


	Endproc && BeforeUpdate

	*
	* AfterUpdate
	Proc AfterUpdate ( p1, p2, p3, p4, p5, p6  )

		#If DEBUGMODE

			lcMsg = Transform( Datetime() ) +  Trans( Program() ) + Chr( 13 )

			For i = 1 To Pcount()
				lcMsg = + lcMsg + Chr( 9 ) + Transform( Eval( 'p' + Trans( i ) ) ) + Chr( 13 )

			Endfor

			Strtofile( lcMsg, 'SQLDump.dump', 1 )

		#Endif


	Endproc && AfterUpdate

Enddefine && prxCursorAdapter