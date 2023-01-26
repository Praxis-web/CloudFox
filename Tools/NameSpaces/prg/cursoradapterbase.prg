#Include 'Tools\namespaces\Include\FoxPro.h'
#Include 'Tools\namespaces\Include\System.h'
#INCLUDE "Tools\ErrorHandler\include\eh.h"

If .F.
	Do 'Tools\namespaces\prg\LogicalNamespace.prg'
Endif

* CursorAdapterBase
* Personalized CursorAdapter
Define Class CursorAdapterBase As CursorAdapter

	#If .F.
		Local This As CursorAdapterBase Of 'Tools\NameSpaces\Prg\CursorAdapterBase.prg'

		TEXT
			 *:Help Documentation
			 *:Description:
			 Personalized CursorAdapter
			 *:Project:
			 Tier Adapter
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Viernes 13 de Enero de 2006 (17:48:55)
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

	BreakOnError   = .F.

	DataSourceType = ''

	oADOCommand    = Null

	oADORecordset  = Null

	* Motor de Base de Datos
	cBackEndEngine = 'FOX'

	* Backup de la configuración de la propiedad century de entorno.
	cOldSetCentury = Set ('Century')

	* Backup de la configuración de la propiedad Date de entorno.
	cOldSetDate    = Set ('Date')

	* Si trabajo conectado, no puedo cerrar las tablas
	* Solo vale para Clipper2Fox
	* RA 2010-05-23(13:59:57)
	lCloseNativeTables = .T.

	lHasError = .F.
	* Referencia al objeto Error
	oError = Null


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cBackEndEngine" type="property" display="cBackEndEngine"/>] + ;
		[<memberdata name="breakonerror" type="property" display="BreakOnError"/>] + ;
		[<memberdata name="coldsetcentury" type="property" display="cOldSetCentury"/>] + ;
		[<memberdata name="coldsetdate" type="property" display="cOldSetDate"/>] + ;
		[<memberdata name="datasourcetype" type="property" display="DataSourceType"/>] + ;
		[<memberdata name="oadocommand" type="property" display="oADOCommand"/>] + ;
		[<memberdata name="oadorecordset" type="property" display="oADORecordset"/>] + ;
		[<memberdata name="selectcmd_assign" type="method" display="SelectCmd_Assign"/>] + ;
		[<memberdata name="validatesqlstatement" type="method" display="ValidateSqlStatement"/>] + ;
		[<memberdata name="lclosenativetables" type="property" display="lCloseNativeTables" />] + ;
		[<memberdata name="lhaserror" type="property" display="lHasError" />] + ;
		[<memberdata name="oerror" type="property" display="oError" />] + ;
		[</VFPData>]

	* AfterCursorFill
	Protected Procedure AfterCursorFill ( lUseCursorSchema As Boolean, ;
			lNoDataOnLoad As Boolean, ;
			cSelectCmd As String, ;
			lResult As Boolean )

		Local lcCommand As String, ;
			lcMsg As String, ;
			lcTable As String, ;
			lcTables As String, ;
			lcTablesAux As String, ;
			liIdx As Integer, ;
			loErr As Exception

		Try

			lcCommand = ""
			
			If Upper ( This.DataSourceType ) == 'NATIVE'
				* CursorFill by default leaves local tables open so we need to close
				* it manually. Because of this you need to watch out; with NATIVE you
				* need to name your CursorAdapter Aliases DIFFERENT than the base
				* table name.

				If This.lCloseNativeTables && Si trabajo conectado, no puedo cerrar las tablas
					* Solo vale para Clipper2Fox
					* RA 2010-05-23(13:59:57)

					lcTablesAux = This.GetTablesFromSQL ( This.SelectCmd )
					lcTables    = Alltrim ( This.Tables ) + ',' + lcTablesAux + ','
					If ! Empty ( m.lcTables )
						For liIdx = 1 To Getwordcount ( m.lcTables,  ',' )
							lcTable = Getwordnum ( m.lcTables, m.liIdx, ',' )
							Use In Select ( m.lcTable )

						Endfor

					Endif && ! Empty( m.lcTables )

					Use In Select ( This.Tables )
				Endif

			Endif && Upper ( This.DataSourceType ) == 'NATIVE'

			*!*	--------------------------------------------------------------------
			*!*	Unique Table, Unique Schema, Unique Catalog Properties—Dynamic (ADO)
			*!*	--------------------------------------------------------------------
			* Enables you to closely control modifications to a particular base table in a Recordset that was formed by a JOIN operation on multiple base tables.

			* - Unique Table: specifies the name of the base table upon which updates, insertions, and deletions are allowed.
			* - Unique Schema: specifies the schema, or name of the owner of the table.
			* - Unique Catalog: specifies the catalog, or name of the database containing the table.

			*!*	Remarks

			*!*	The desired base table is uniquely identified by its catalog, schema, and table names.
			*!*	When the Unique Table property is set, the values of the Unique Schema  or Unique Catalog properties are used to find the base table.
			*!*	It is intended, but not required, that either or both the Unique Schema and Unique Catalog properties be set before the Unique Table property is set.

			*!*	The primary key of the Unique Table is treated as the primary key of the entire Recordset.
			*!*	This is the key that is used for any method requiring a primary key.

			*!*	While Unique Table is set, the Delete method affects only the named table.
			*!*	The AddNew, Resync, Update, and UpdateBatch methods affect any appropriate underlying base tables of the Recordset.

			*!*	Unique Table must be specified before doing any custom resynchronizations.
			*!*	If Unique Table has not been specified, the Resync Command property will have no effect.

			*!*	A run-time error results if a unique base table cannot be found.
			*!*	These dynamic properties are all appended to the Recordset object Properties collection when the CursorLocation property is set to adUseClient.

			If Upper ( This.DataSourceType ) == 'ADO'  And ! Empty ( This.Tables ) And Occurs ( [,], This.Tables ) == 0

				* RR, 03/10/2004: por lo indicado en el comentario anterior y si:
				* - Not Empty(This.Tables)      --->   no está vacía la propiedad (sería el caso si se ejecuta una Stored Procedure)
				* - Occurs([,],This.Tables)=0   --->   se refiere a una tabla (no es una lista de tablas)

				* Esto lo hago ya que es posible que en la DataTier se contruya el GetOne con un Select resultante de un JOIN de múltiples tablas.

				This.Datasource.Properties ('Unique Table') = This.Tables

			Endif && Upper ( This.DataSourceType ) == 'ADO'  And ! Empty ( This.Tables ) And Occurs ( [,], This.Tables ) == 0

			If lResult
				* Todo OK!
			Else
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )

				TEXT To lcCommand NoShow TextMerge Pretext 03
				<<This.SelectCmd>>

				Alias: <<This.Alias>>
				Tables: <<This.Tables>>
				UpdatableFieldList: <<This.UpdatableFieldList>>
				UpdateNameList: <<This.UpdateNameList>>
				KeyFieldList: <<This.KeyFieldList>>
				ENDTEXT

				loError.cTraceLogin = "prxCursorAdapter.AfterCursorFill()"
				loError.cRemark = lcCommand
				*!*					loError.TierBehavior = EH_LOGERROR
				*!*					loError.cTierLevel = "Data"

				loError.Process()
				* RA 2013-10-19(13:19:28)
				* El Throw no funciona desde dentro del cursor adapter
				* Hay que prender un flag y guardar la exepción, para analizarla afuera
				*!*					Throw loError

				This.oError = loError
				This.lHasError = .T.


			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process( loErr )
			Throw loError

		Finally
			TEXT To m.lcCommand Textmerge Noshow Pretext 15
				Set Century <<This.cOldSetCentury>>
			ENDTEXT
			&lcCommand

			TEXT To m.lcCommand Textmerge Noshow Pretext 15
				Set Date TO <<This.cOldSetDate>>
			ENDTEXT
			&lcCommand

		Endtry

	Endproc && AfterCursorFill

	* AfterDelete
	Protected Procedure AfterDelete ( tcFldState As String, tlForce As Boolean, tcDeleteCmd As String, tlResult As Boolean ) As VOID
		* This procedure was added according to Aleksey's answer to the error
		* below Row handle referred to a deleted row or a row marked for deletion"

		Try
			With This As CursorAdapter
				If Upper ( .DataSourceType ) == 'ADO'
					.Datasource.MoveFirst()

				Endif && Upper( .DataSourceType ) == 'ADO'

			Endwith

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFldState, tlForce, tcDeleteCmd, tlResult
			THROW_EXCEPTION

		Endtry

	Endproc && AfterDelete

	* BeforeCursorFill
	* Si el origen de datos es ADO, CursorFill intentará abrir el Recordset al menos que este sea pasado como 4to parámetro, para lo cual ya debe estar abierto.
	* Dado que hay ocasiones, en el Put() por ejemplo, en que se hacen 2 CursorFill seguidos para el mismo CursorAdapter, la segunda vez generaba un error dado que el ADORecorset ya estaba abierto.
	Protected Procedure BeforeCursorFill ( tlUseCursorSchema As Boolean, tlNoDataOnLoad As Boolean, tcSelectCmd As String ) As VOID

		Set Century On
		Set Date To YMD

		* Si el origen de datos es ADO, CursorFill intentará abrir el Recordset
		* al menos que este sea pasado como 4to parámetro, para lo cual ya debe estar abierto.
		* Dado que hay ocasiones, en el Put() por ejemplo, en que se hacen 2 CursorFill seguidos
		* para el mismo CursorAdapter, la segunda vez generaba un error dado que el ADORecorset ya estaba abierto.
		Try
			With This As CursorAdapter
				If Upper (.DataSourceType) == 'ADO'
					If .oADORecordset.State = 1 && adStateOpen
						.oADORecordset.Close()

					Endif && .oADORecordset.State = 1 && adStateOpen

				Endif && Upper(.DataSourceType) == "ADO"

				* Si el cursor a generar ya existe, lo cierro.
				Use In Select ( .Alias )

			Endwith
		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tlUseCursorSchema, tlNoDataOnLoad, tcSelectCmd
			THROW_EXCEPTION

		Endtry

	Endproc && BeforeCursorFill

	*
	* ConcatenarSiNoExiste
	* DAE 2009-10-21(13:42:04)
	Protected Function ConcatenarSiNoExiste ( tcCadena As String, tcValor As String ) As String

		Local loErr As Exception

		Try

			If ! ( m.tcValor $ m.tcCadena )
				If ! Empty ( m.tcCadena )
					tcCadena = m.tcCadena + ',' + m.tcValor

				Else
					tcCadena = m.tcValor

				Endif && ! Empty( m.tcCadena )

			Endif && ! ( m.tcValor $ m.tcCadena )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCadena, tcValor
			THROW_EXCEPTION

		Endtry

		Return m.tcCadena

	Endfunc && ConcatenarSiNoExiste

	* Destroy
	Function Destroy()
		With This As CursorAdapter
			.oADORecordset = Null
			.oADOCommand   = Null

		Endwith

		Unbindevents( This )
		DoDefault()

	Endfunc && Destroy

	Dimension DumpProperties_COMATTRIB[ 5 ]
	DumpProperties_COMATTRIB[ 1 ] = 0
	DumpProperties_COMATTRIB[ 2 ] = 'Graba en un archivo el valor las propiedades del CursorAdapter.'
	DumpProperties_COMATTRIB[ 3 ] = 'DumpProperties'
	DumpProperties_COMATTRIB[ 4 ] = 'Void'
	* DumpProperties_COMATTRIB[ 5 ] = 1

	* DumpProperties
	* Graba en un archivo el valor las propiedades del CursorAdapter.
	Procedure DumpProperties ( tcFileName As String ) As VOID HelpString 'Graba en un archivo el valor las propiedades del CursorAdapter.'

		Local laMember[1], ;
			lcDump As String, ;
			lcFileName As String, ;
			lcProp As String, ;
			liIdx As Integer, ;
			loErr As Exception

		Try

			If Empty ( tcFileName )
				lcFileName = This.Alias + '.dump'

			Else && Empty ( tcFileName )
				lcFileName = tcFileName

			Endif && Empty ( tcFileName )

			lcDump = This.Alias + CR

			For liIdx = 1 To Amembers ( laMember, This )
				lcProp = laMember[ m.liIdx ]
				Try
					lcDump = lcDump + m.lcProp + ': ' + Transform ( Getpem ( This, m.lcProp ) ) + CR

				Catch To loErr
				Endtry

			Endfor

			Strtofile ( m.lcDump, m.lcFileName )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFileName
			THROW_EXCEPTION

		Endtry

	Endproc && DumpProperties

	* ExtractAlias
	Protected Function ExtractAlias ( tcTablesNames As String ) As String

		Local lcAux As String, ;
			loErr As Exception

		Try

			lcAux = Getwordnum ( m.tcTablesNames, 1 )

			Do Case

				Case Empty ( m.lcAux ) Or Inlist ( Upper ( m.lcAux ), 'LEFT', 'RIGHT', 'INNER' )
					Error 'No existe el nombre de la tabla'

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcTablesNames
			THROW_EXCEPTION

		Endtry

		Return m.lcAux

	Endfunc && ExtractAlias

	*
	* GetTablesFromSQL
	* Devuelve la lista de tablas unicas incluidas en la consulta SQL.
	* DAE 2009-10-21(13:42:12)
	Protected Function GetTablesFromSQL ( tcSQL As String ) As String HelpString 'Devuelve la lista de tablas unicas incluidas en la consulta SQL.'

		Local lcAliasAux As String, ;
			lcAux As String, ;
			lcStr As String, ;
			lcTablesNameAux As String, ;
			lcTablesNames As String, ;
			lnCntFrom As Integer, ;
			lnCntJoin As Integer, ;
			lnFromIndex As Integer, ;
			lnJoinIndex As Integer, ;
			loErr As Exception

		Try

			lcStr           = ''
			lcAux           = ''
			lcTablesNames   = ''
			tcSQL           = Upper ( m.tcSQL )
			lcTablesNames   = ''
			lcTablesNameAux = ''

			lnCntFrom = Occurs ( 'FROM', m.tcSQL )
			For lnFromIndex = 1 To m.lnCntFrom
				lcStr = Strextract ( m.tcSQL, 'FROM', 'WHERE', m.lnFromIndex, 3 ) &&, 0, 3 )

				If Empty ( m.lcStr )
					lcStr = Strextract ( m.tcSQL, 'FROM', '', m.lnFromIndex, 3 )

				Endif && Empty( m.lcStr )

				lcStr = Strextract ( m.lcStr, '', 'ORDER BY', 0, 3 )

				lcTablesNameAux = Strextract ( m.lcStr, '', 'JOIN', 0, 3 )

				lcAliasAux = This.ExtractAlias ( m.lcTablesNameAux )
				If ! Inlist ( m.lcAliasAux, '(', ')' )
					lcTablesNames = This.ConcatenarSiNoExiste ( m.lcTablesNames, m.lcAliasAux )

				Endif && ! Inlist( m.lcAliasAux , '(', ')' )

			Endfor

			lnCntJoin = Occurs ( 'JOIN', m.tcSQL )
			For lnJoinIndex = 1 To m.lnCntJoin
				lcAux = Strextract ( m.tcSQL, 'JOIN ', ' ON', m.lnJoinIndex, 3 )
				If ! Empty ( m.lcAux )
					lcAliasAux = This.ExtractAlias ( m.lcAux )
					If ! Inlist ( m.lcAliasAux, '(', ')' )
						lcTablesNames = This.ConcatenarSiNoExiste ( m.lcTablesNames, m.lcAliasAux )

					Endif && ! Inlist( m.lcAliasAux , '(', ')' )

				Endif && ! Empty( m.lcAux )

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcSQL
			THROW_EXCEPTION

		Endtry

		Return m.lcTablesNames

	Endfunc && GetTablesFromSQL

	* Init
	* Constructor
	Function Init ( tcDataSourceType As String, ;
			tuConnection As Variant, ;
			tcBackEndEngine As String ) As VOID

		Try
			With This As CursorAdapter
				.DataSourceType = m.Logical.IfEmpty ( tcDataSourceType, 'NATIVE' )
				.cBackEndEngine = m.Logical.IfEmpty ( tcBackEndEngine, 'FOX' )

				Do Case
					Case Upper (.DataSourceType) == 'ADO'
						*!*	Once detached, the cursor is independent from the CursorAdapter object, but not from its data source. ;
						*!*	You can use CURSORGETPROP("ADORecordset") to get the Recordset associated with the cursor even if it is detached from the  CursorAdapter object.
						*!*	If you close the connection when the cursor is not fetched completely and then try to fetch more records an error is reported.
						*!*	To avoid this problem, execute GO BOTTOM before closing connection or use oCA.FetchSize = -1 when you call CursorFill.

						.FetchSize = -1  && retrieves the complete result set.

						If Vartype (.oADOCommand) # 'O'
							.oADOCommand                  = Createobject ('ADODB.Command')
							.oADOCommand.ActiveConnection = tuConnection

						Endif && Vartype (.oADOCommand) # 'O'

						If Vartype (.oADORecordset) # 'O'
							.oADORecordset = Createobject ('ADODB.Recordset')

							With .oADORecordset
								.CursorLocation   = 3 && adUseClient
								.LockType         = 3 && adLockOptimistic
								.ActiveConnection = tuConnection

							Endwith

							.Datasource = .oADORecordset

						Endif && Vartype (.oADORecordset) # 'O'

					Case Upper (.DataSourceType) = 'ODBC'
						.Datasource = tuConnection

					Otherwise

				Endcase

			Endwith

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcDataSourceType, tuConnection, tcBackEndEngine
			THROW_EXCEPTION

		Endtry

	Endfunc && Init

	* SelectCmd_Assign
	Protected Procedure SelectCmd_Assign ( tcSelectCmd As String ) As VOID

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Project:
				 Tier Adapter
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Viernes 13 de Enero de 2006 (17:58:29)
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

			With This As CursorAdapter
				m.lcSelectCmd = m.String.CleanString ( m.tcSelectCmd )
				.SelectCmd = .ValidateSqlStatement ( m.lcSelectCmd )

			Endwith

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, m.tcSelectCmd
			THROW_EXCEPTION

		Endtry

	Endproc && SelectCmd_Assign

	Dimension ValidateSqlStatement_COMATTRIB[ 5 ]
	ValidateSqlStatement_COMATTRIB[ 1 ] = 0
	ValidateSqlStatement_COMATTRIB[ 2 ] = 'Valida una instruccón SQL de acuerdo al motor de base de datos que se este utilizando.'
	ValidateSqlStatement_COMATTRIB[ 3 ] = 'ValidateSqlStatement'
	ValidateSqlStatement_COMATTRIB[ 4 ] = 'String'
	* ValidateSqlStatement_COMATTRIB[ 5 ] = 0

	* ValidateSqlStatement
	* Valida una instruccón SQL de acuerdo al motor de base de datos que se este utilizando.
	Function ValidateSqlStatement ( tcSQL As String ) As String HelpString 'Valida una instruccón SQL de acuerdo al motor de base de datos que se este utilizando.'

		Local lcBackEndEngine As String, ;
			lcValidSQL As String, ;
			loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Autor:
			Ricardo Aidelman / Damián Eiff
			 *:Parameters:
			 *:Remarks:
			Valida una instruccón SQL de acuerdo al motor de base de datos que se este utilizando.
			 Jueves 27 de Abril de 2006 (12:55:05)
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

		* TODO: Separar los FIX de cada motor en distintas clases y delegar esa responsabilidad a SQLNameSpace.
		Try

			lcValidSQL      = Alltrim ( m.tcSQL )
			lcBackEndEngine = Upper ( This.cBackEndEngine )

			*!* Set some words to upper
			lcValidSQL = Strtran ( m.lcValidSQL, ' and ', ' AND ' )
			lcValidSQL = Strtran ( m.lcValidSQL, ' And ', ' AND ' )
			lcValidSQL = Strtran ( m.lcValidSQL, ' or ', ' OR ' )
			lcValidSQL = Strtran ( m.lcValidSQL, ' Or ', ' OR ' )

			Do Case
				Case m.lcBackEndEngine == 'FOX'
					lcValidSQL = Strtran ( m.lcValidSQL, '<#', " ctod( '" )
					lcValidSQL = Strtran ( m.lcValidSQL, '#>', "' ) " )
					lcValidSQL = Strtran ( m.lcValidSQL, '<$', " ctot( '" )
					lcValidSQL = Strtran ( m.lcValidSQL, '$>', "' ) " )

				Case Inlist ( m.lcBackEndEngine, 'SQL', 'ORA', 'INF' )
					*!* Convert the empty dates in null values
					lcValidSQL = Strtran ( m.lcValidSQL, '<##>', 'NULL' )
					lcValidSQL = Strtran ( m.lcValidSQL, '<$$>', 'NULL' )

					*!* convert the non empty dates
					lcValidSQL = Strtran ( m.lcValidSQL, '<#', " '" )
					lcValidSQL = Strtran ( m.lcValidSQL, '#>', "' " )
					lcValidSQL = Strtran ( m.lcValidSQL, '<$', " '" )
					lcValidSQL = Strtran ( m.lcValidSQL, '$>', "' " )

					lcValidSQL = Strtran ( m.lcValidSQL, '.t.', '1' )
					lcValidSQL = Strtran ( m.lcValidSQL, '.f.', '0' )
					lcValidSQL = Strtran ( m.lcValidSQL, '==', '=' )

					*!* convert some functions to SQL compatible
					lcValidSQL = Strtran ( m.lcValidSQL, ' alltrim(', ' rtrim(' )
					lcValidSQL = Strtran ( m.lcValidSQL, ',alltrim(', ',rtrim(' )
					lcValidSQL = Strtran ( m.lcValidSQL, ' trim(', ' rtrim(' )
					lcValidSQL = Strtran ( m.lcValidSQL, ',trim(', ',rtrim(' )
					lcValidSQL = Strtran ( m.lcValidSQL, ' substr(', ' substring(' )
					lcValidSQL = Strtran ( m.lcValidSQL, ',substr(', ',substring(' )

					If m.lcBackEndEngine == 'SQL' And ( ' NULL' $ m.lcValidSQL )
						lcValidSQL = Strtran ( m.lcValidSQL, '<> NULL', 'Is Not NULL' )
						lcValidSQL = Strtran ( m.lcValidSQL, '> NULL', 'Is Not NULL' )

						lcValidSQL = Strtran ( m.lcValidSQL, '>= NULL AND', 'Is NULL Or' )
						lcValidSQL = Strtran ( m.lcValidSQL, '<= NULL', 'Is NULL' )
						lcValidSQL = Strtran ( m.lcValidSQL, '>= NULL', 'Is Not NULL' )
						lcValidSQL = Strtran ( m.lcValidSQL, '= NULL', 'Is NULL' )

					Endif && m.lcBackEndEngine = "SQL" And ( " NULL" $ m.lcValidSQL )

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcSQL
			THROW_EXCEPTION

		Endtry

		Return m.lcValidSQL

	Endfunc && ValidateSqlStatement

Enddefine && CursorAdapterBase
