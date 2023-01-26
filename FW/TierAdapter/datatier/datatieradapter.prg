#INCLUDE "FW\Tieradapter\Include\TA.h"
#INCLUDE "Fw\ErrorHandler\eh.h"

Define Class DataTierAdapter As TierAdapter Of "FW\Tieradapter\Comun\TierAdapter.prg"

	#If .F.
		Local This As DataTierAdapter Of "FW\Tieradapter\DataTier\DataTierAdapter.prg"
	#Endif

*!*		Protected cBackEndCfgFileName , ;
*!*			cAccessType , ;
*!*			cDataBaseName , ;
*!*			cStringConnection , ;
*!*			cBackEndEngine , ;
*!*			oConnection

	cBackEndCfgFileName = ""

	cAccessType = ''
	cDataBaseName = ''
	cStringConnection = ''
	cBackEndEngine = ''
	oConnection = Null

	* Indica el ordenamiento de los resultados para GetAllPaginated
	cGetAllPaginatedOrderBy = ""

	* ccGetAllFields acepta una lista (separada por comas) de campos
	* como alternativa a un "SELECT *" en los métodos GetAll y GetAllPaginated.
	* Se puede hacer referencia a campos de mas de una tabla, especificando
	* los JOINs en la propiedad cGetAllJoins.
	cGetAllFields = ""

	* Si cGetAllFields hace referencia a campos que no están en la tabla de
	* nivel 1 de la entidad, se debe indicar la relación que une a esta
	* última con la/las tablas que los contienen.
	cGetAllJoins = ""

	* ccGetAllView permite trabajar con una vista como "source" para
	* obtener los campos en los métodos GetAll y GetAllPaginated.
	cGetAllView = ""

	*!* Contiene la cláusula ORDER BY definida en la colección Tables
	cGetAllOrderBy = ""

	cTierLevel = "Data"		&& Indica el nivel de la capa dentro del modelo.

	*!* Referencia al objeto que sabe como comunicarse con el Motor de Base de datos
	oBackEnd = Null

	lAlreadyConnected = .F.

	lAutoDestroy = .F.

	*!* Nombre de la DAL para NATIVE
	NativeClass = "NativeBackEnd"

	*!* Librería de la DAL Native
	NativeClassLibrary = "BackEndNative.prg"

	*!* Nombre de la DAL para ODBC
	ODBCClass = "ODBCBackEnd"

	*!* Librería de la DAL ODBC
	ODBCClassLibrary = "BackEndODBC.prg"

	*!* Nombre de la DAL para ADO
	ADOClass = "ADOBackEnd"

	*!* Librería de la DAL para ADO
	ADOClassLibrary = "BackEndADO.prg"

	*!* Semáforo que indica si la entidad se encuentra dentro de una transacción global
	lOnTransaction = .F.

	* Permite almacenar el nivel de tablas de la entidad
	nLevel = 1

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="nlevel" type="property" display="nLevel" />] + ;
		[<memberdata name="lontransaction" type="property" display="lOnTransaction" />] + ;
		[<memberdata name="getorderby" type="method" display="GetOrderBy" />] + ;
		[<memberdata name="cgetallorderby_access" type="method" display="cGetAllOrderBy_Access" />] + ;
		[<memberdata name="cgetallpaginatedorderby_access" type="method" display="cGetAllPaginatedOrderBy_Access" />] + ;
		[<memberdata name="cgetallorderby" type="property" display="cGetAllOrderBy" />] + ;
		[<memberdata name="lalreadyconnected" type="property" display="lAlreadyConnected" />] + ;
		[<memberdata name="clastsql" type="property" display="LastSQL" />] + ;
		[<memberdata name="cbackendcfgfilename" type="property" display="cBackEndCfgFileName" />] + ;
		[<memberdata name="cinifilename_access" type="method" display="cIniFileName_Access" />] + ;
		[<memberdata name="caccesstype" type="property" display="cAccessType" />] + ;
		[<memberdata name="cdatabasename" type="property" display="cDataBaseName" />] + ;
		[<memberdata name="cstringconnection" type="property" display="cStringConnection" />] + ;
		[<memberdata name="cbackendengine" type="property" display="cBackEndEngine" />] + ;
		[<memberdata name="oconnection" type="property" display="oConnection" />] + ;
		[<memberdata name="cgetallpaginatedorderby" type="property" display="cGetAllPaginatedOrderBy" />] + ;
		[<memberdata name="cgetallfields" type="property" display="cGetAllFields" />] + ;
		[<memberdata name="cgetalljoins" type="property" display="cGetAllJoins" />] + ;
		[<memberdata name="cgetallview" type="property" display="cGetAllView" />] + ;
		[<memberdata name="setconnection" type="method" display="SetConnection" />] + ;
		[<memberdata name="getconnection" type="method" display="GetConnection" />] + ;
		[<memberdata name="connecttobackend" type="method" display="ConnectToBackend" />] + ;
		[<memberdata name="setconnection" type="method" display="SetConnection" />] + ;
		[<memberdata name="disconnectfrombackend" type="method" display="DisconnectFromBackend" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="getone" type="method" display="GetOne" />] + ;
		[<memberdata name="getall" type="method" display="GetAll" />] + ;
		[<memberdata name="getallfiltercriteria" type="method" display="GetAllFilterCriteria" />] + ;
		[<memberdata name="getallpaginated" type="method" display="GetAllPaginated" />] + ;
		[<memberdata name="getallpaginatedcount" type="method" display="GetAllPaginatedCount" />] + ;
		[<memberdata name="addupdatablefieldsdata" type="method" display="AddUpdatableFieldsData" />] + ;
		[<memberdata name="getnewid" type="method" display="GetNewId" />] + ;
		[<memberdata name="put" type="method" display="Put" />] + ;
		[<memberdata name="transactionend" type="method" display="TransactionEnd" />] + ;
		[<memberdata name="transactionbegin" type="method" display="TransactionBegin" />] + ;
		[<memberdata name="updatechildren" type="method" display="UpdateChildren" />] + ;
		[<memberdata name="updatefamily" type="method" display="UpdateFamily" />] + ;
		[<memberdata name="performupdate" type="method" display="PerformUpdate" />] + ;
		[<memberdata name="transactionrollback" type="method" display="TransactionRollBack" />] + ;
		[<memberdata name="globaltransactionrollback" type="method" display="GlobalTransactionRollback" />] + ;
		[<memberdata name="globaltransactionend" type="method" display="GlobalTransactionEnd" />] + ;
		[<memberdata name="globaltransactionbegin" type="method" display="GlobalTransactionBegin" />] + ;
		[<memberdata name="modified" type="method" display="Modified" />] + ;
		[<memberdata name="obackend" type="property" display="oBackEnd" />] + ;
		[<memberdata name="readinifile" type="method" display="ReadIniFile" />] + ;
		[<memberdata name="populatexmladapter" type="method" display="PopulateXMLAdapter" />] + ;
		[<memberdata name="applydiffgram" type="method" display="ApplyDiffgram" />] + ;
		[<memberdata name="tableupdate" type="method" display="TableUpdate" />] + ;
		[<memberdata name="getoriginalcursor" type="method" display="GetOriginalCursor" />] + ;
		[<memberdata name="buildcursor" type="method" display="BuildCursor" />] + ;
		[<memberdata name="populatetablesbyuser" type="method" display="PopulateTablesByUser" />] + ;
		[<memberdata name="sqlexecute" type="method" display="SQLExecute" />] + ;
		[<memberdata name="synchronizetables" type="method" display="SynchronizeTables" />] + ;
		[<memberdata name="packmaintable" type="method" display="PackMainTable" />] + ;
		[<memberdata name="createtable" type="method" display="CreateTable" />] + ;
		[<memberdata name="altertable" type="method" display="AlterTable" />] + ;
		[<memberdata name="getcolfields" type="method" display="GetColFields" />] + ;
		[<memberdata name="getcreatecommand" type="method" display="GetCreateCommand" />] + ;
		[<memberdata name="getnext" type="method" display="GetNext" />] + ;
		[<memberdata name="internalapplydiffgram" type="method" display="InternalApplyDiffgram" />] + ;
		[<memberdata name="internalgetone" type="method" display="InternalGetOne" />] + ;
		[<memberdata name="internalpopulatexmladapter" type="method" display="InternalPopulateXmlAdapter" />] + ;
		[<memberdata name="internaltabledelete" type="method" display="InternalTableDelete" />] + ;
		[<memberdata name="internaltableinsertandupdate" type="method" display="InternalTableInsertAndUpdate" />] + ;
		[<memberdata name="internalupdatechildren" type="method" display="InternalUpdateChildren" />] + ;
		[<memberdata name="internalupdatefamily" type="method" display="InternalUpdateFamily" />] + ;
		[<memberdata name="beforetransactionbegins" type="method" display="BeforeTransactionBegins" />] + ;
		[<memberdata name="begintransaction" type="method" display="BeginTransaction" />] + ;
		[<memberdata name="getchildren" type="method" display="GetChildren" />] + ;
		[<memberdata name="internalgetchildren" type="method" display="InternalGetChildren" />] + ;
		[<memberdata name="updatetree" type="method" display="UpdateTree" />] + ;
		[</VFPData>]


	*
	* Afert Event
	Protected Procedure ClassAfterInitialize(  ) As Void;
			HELPSTRING "Afert Event"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Afert Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 15 de Mayo de 2009 (10:47:10)
			*:ModiSummary:
			*:Syntax:
			*:Example:
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

		Try
			If This.lIsOk
				This.ReadIniFile()
			Endif

			If This.lIsOk
				Do Case
					Case Upper(This.cAccessType)="NATIVE"
						This.oBackEnd = Newobject( This.NativeClass,;
							THIS.NativeClassLibrary )

					Case Upper(This.cAccessType)="ODBC"
						This.oBackEnd = Newobject( This.ODBCClass,;
							THIS.ODBCClassLibrary )

					Case Upper(This.cAccessType)="ADO"
						This.oBackEnd = Newobject( This.ADOClass,;
							THIS.ADOClassLibrary )

					Otherwise
						Error "Data Access Type Not Recognized"

				Endcase

				With This.oBackEnd As BackEnd Of "TierAdapter\DataTier\BackEnd.prg"
					.cDataBaseName 		= This.cDataBaseName
					.cStringConnection 	= This.cStringConnection
					.cBackEndEngine 	= This.cBackEndEngine
				Endwith

			Endif

			If !This.lIsOk
				Throw This.oError
			Endif


		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

	Endproc && ClassAfterInitialize


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ReadIniFile
	*!* Description...: Leer el archivo de inicialización
	*!* Date..........: Jueves 5 de Enero de 2006 (09:28:41)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Menus
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ReadIniFile(  ) As Boolean;
			HELPSTRING "Leer el archivo de inicialización"

		Local loConfigData As Object
		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			If Empty( This.cAccessType )

				loXA = Newobject("prxXMLAdapter",;
					"prxXMLAdapter.prg" )

				loXA.LoadXML( This.cBackEndCfgFileName, .T. )
				loXA.Tables(1).ToCursor()
				loXA = Null

				Locate For Lower( objName ) = Lower( This.cDataConfigurationKey )
				If Eof()
					Locate For Lower(objName) = "default"
				Endif

				This.cAccessType       = Alltrim(AccessType)
				This.cDataBaseName     = Alltrim(dbName)
				This.cStringConnection = Alltrim(StrConn)
				This.cBackEndEngine    = Iif(Empty(Alltrim(BkEngine)),"FOX",Alltrim(BkEngine))
				This.lDebugMode 	   = DebugComponent

				Use In Alias()

				Local loConfigData As Object
				loConfigData = Createobject( "Empty" )
				AddProperty( loConfigData, "cAccessType", This.cAccessType )
				AddProperty( loConfigData, "cDataBaseName", This.cDataBaseName )
				AddProperty( loConfigData, "cStringConnection", This.cStringConnection )
				AddProperty( loConfigData, "cBackEndEngine", This.cBackEndEngine )

				*!*	                This.PopulateConfigData( loConfigData )

			Endif

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally

		Endtry

		Return This.lIsOk

	Endproc && ReadIniFile

	* Este método se utiliza para forzar la utilización de una conexión ya abierta y no abrir una nueva.
	* Puede ser útil para, por ejemplo, si se abrió una transacción en otra entidad, utilizar la misma
	* conexión y anidad transacciones.

	Function GetConnection() As Object
		Return This.oConnection
	Endfunc

	Function SetConnection(toConnection As Object) As Void
		* ToDo - Tener en cuenta si se trabaja con VFP databases, ;
		pasar la datasession ID
		This.oConnection = toConnection
	Endfunc

	*
	* ConnectToBackend
	Protected Function ConnectToBackend() As Boolean
		Local lnReturn As Integer
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		lnReturn = This.oBackEnd.Connect()

		This.lIsOk = lnReturn > -1

		If This.lIsOk
			This.oConnection = This.oBackEnd.oConnection

		Else
			*!*	This.cXMLoError = This.oError.Process()
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Endif

		*!*	If lnReturn > 0
		*!*		Local lcStr As String
		*!*		lcStr = This.Name + " - ConnectToBackend()" + Chr(13) + Chr(10)
		*!*		lcStr = lcStr + Chr(13) + Chr(10)

		*!*		Strtofile( lcStr, "Transacciones.txt", 1 )

		*!*	Endif

		Return lnReturn

	Endfunc && ConnectToBackend

	*-----------------------------------
	* Se desconecta de la base de datos.
	*-----------------------------------
	Protected Function DisconnectFromBackend() As Boolean

		Local llOk As Boolean
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		*!*	Si se produjo un error previamente, solamente intenta desconectarse
		*!*	de la base de datos, sin procesar los errores que ésto pudiera ocasionar

		llOk = This.oBackEnd.DisConnect()

		If llOk
			This.oConnection = This.oBackEnd.oConnection

			*!*	Local lcStr As String
			*!*	lcStr = This.Name + " - DisconnectFromBackend()" + Chr(13) + Chr(10)
			*!*	lcStr = lcStr + Chr(13) + Chr(10)

			*!*	Strtofile( lcStr, "Transacciones.txt", 1 )


		Else
			If This.lIsOk
				This.lIsOk = .F.
				* DAE 2009-11-06(17:41:10)
				* This.cXMLoError = This.oError.Process()
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				This.cXMLoError = loError.Process()

			Endif

		Endif

		Return This.lIsOk

	Endfunc && DisconnectFromBackend

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ExecuteNonQuery
	*!* Description...: Ejecuta un comando SQL que no devuelve un resultado
	*!* Date..........: Jueves 19 de Enero de 2006 (11:22:52)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!* DAE 2009-09-30(11:20:50)
	*!* Agregue la deteccion de tipo de sentencia SQL para indicar
	*!* el tipo de proceso que se va a realizar.
	*!* Si no se incluyeron los campos TS y TransactionID
	*!* se agregan automaticamente en los insert
	*!*
	*!*
	*!*

	Procedure ExecuteNonQuery( tcSQLCommand As String ) As Boolean;
			HELPSTRING "Ejecuta una consulta SQL"

		Local lcSQLType As String
		Local lcCampos As String
		Local lcValores As String

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lnProcessType As Integer
		Local lnTransactionID As Integer

		Local lllAlreadyConnected As Boolean

		Try

			*!*	loError = This.oError
			*!*	loError .TraceLogin = "ExecuteNonQuery"
			*!*	loError.Remark = ""

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError .TraceLogin = "ExecuteNonQuery"


			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk
				lnProcessType = This.nProcessType
				lnTransactionID = This.nTransactionID

				lcSQLType = Lower( Left( Alltrim( tcSQLCommand ), 6 ) )
				Do Case
					Case lcSQLType = 'insert' && C
						This.nProcessType =  TR_NEW
					Case lcSQLType = 'select' && R
						This.nProcessType =  TR_QUERY
					Case lcSQLType = 'update' && U
						This.nProcessType =  TR_UPDATE
					Case lcSQLType = 'delete' && D
						This.nProcessType =  TR_DELETE
					Otherwise
						loError.Remark = "Tipo de consulta no reconocido"
				Endcase

				This.TransactionBegin()

				Do Case
					Case This.nProcessType = TR_NEW
						If ! ( 'select' $ Lower( tcSQLCommand ) )
							lcCampos = Alltrim( Strextract( tcSQLCommand, '(', ')', 1, 1 ) )
							lcValores = Alltrim( Strextract( tcSQLCommand, '(', ')', 2, 1 ) )
							If ! ( 'ts' $ Lower( lcCampos ) )
								lcCampos = lcCampos + ',ts'
								lcValores = lcValores + ',' + Fecha2SQL( Datetime() )
							Endif

							If ! ( 'transactionid' $ Lower( lcCampos ) )
								lcCampos = lcCampos + ',transactionid'
								lcValores = lcValores + ',' + Transform( This.nTransactionID )

							Endif
							lctabla = Alltrim( Strextract( tcSQLCommand, 'into', '(', 1, 1 ) )

							TEXT To tcSQLCommand NoShow TextMerge Pretext 15
								Insert into <<lctabla>>
									( <<lcCampos>> )
									values ( <<lcValores>> )

							ENDTEXT

						Endif

					Case This.nProcessType = TR_QUERY

					Case This.nProcessType = TR_UPDATE
						* @TODO Damian Eiff 2009-09-30 (11:23:30)
						* Parsear tcSQLCommand y agregar los campos
						* TS y TransactionID si  es necesario

					Case This.nProcessType = TR_DELETE

				Endcase


				This.lIsOk = This.oBackEnd.ExecuteNonQuery( tcSQLCommand )

				If This.lIsOk
					This.TransactionEnd()

				Else
					This.TransactionRollBack()

				Endif

			Endif


		Catch To oErr
			This.lIsOk = .F.
			*!*	This.cXMLoError = This.oError.Process( oErr )
			If Vartype( loError ) # 'O'
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			Endif
			This.cXMLoError = loError.Process( oErr )

		Finally
			This.nProcessType = lnProcessType
			This.nTransactionID = lnTransactionID
			If ! lllAlreadyConnected
				This.DisconnectFromBackend()

			Endif
			loError = Null

		Endtry

		Return This.cXMLoError

	Endproc && ExecuteNonQuery

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SQLExecute
	*!* Description...: Ejecuta un comando SQL y devuelve un XML
	*!* Date..........: Jueves 19 de Enero de 2006 (11:22:52)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure SQLExecute( tcSQLCommand As String,;
			tcAlias As String  ) As String;
			HELPSTRING "Ejecuta un comando SQL y devuelve un XML"

		Local lllAlreadyConnected As Boolean
		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			If Empty( tcAlias )
				tcAlias = This.cMainCursorName
			Endif

			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk
				This.BuildCursor( tcAlias, tcSQLCommand )
			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

		Return ( This.Serialize( tcAlias ) )

	Endproc
	*!*
	*!* END PROCEDURE SQLExecute
	*!*
	*!* ///////////////////////////////////////////////////////


	*
	* ClassBefore Event
	* Crea un nuevo elemento para la entidad.
	* Basicamente, llama el metodo PUT sin un ID. Incluido para hacer "amigable" al codigo.
	Protected Procedure ClassBeforeNew( tnLevel As Integer,;
			tcAlias As String ) As Boolean

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:33:08)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			tnLevel AS Integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteNew As Boolean

		Try

			llExecuteNew = .T.
			This.lAlreadyConnected = This.ConnectToBackend() = 0

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return llExecuteNew

	Endproc


	*
	* Crea un nuevo elemento para la entidad.
	* Basicamente, llama el metodo PUT sin un ID.
	* Incluido para hacer "amigable" al codigo.
	Procedure New( tnLevel As Integer,;
			tcAlias As String ) As String;
			HELPSTRING "Crea un nuevo elemento para la entidad. Basicamente, llama el metodo PUT sin un ID. Incluido para hacer 'amigable' al codigo."


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Crea un nuevo elemento para la entidad.
			Basicamente, llama el metodo PUT sin un ID.
			Incluido para hacer "amigable" al codigo.
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:33:08)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			tnLevel AS Integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcXML As String
		Local lnOffSet As Integer

		Try

			lcXML = ""
			lnOffSet = 0

			If This.ClassBeforeNew( tnLevel,;
					tcAlias ) And This.lIsOk

				If This.HookBeforeNew(tnLevel,;
						tcAlias ) And This.lIsOk


					If This.oColTables.Count > 0
						loTable = This.oColTables.Item( 1 )
						lnOffSet = loTable.Nivel - 1
					Endif

					loParam = Createobject("Empty")
					AddProperty(loParam, "nLevel", tnLevel )
					AddProperty(loParam, "cAlias", tcAlias )
					AddProperty(loParam, "nOffSet", lnOffSet )

					If This.lIsOk
						This.lIsOk = This.LookOverColTables( This.oColTables,;
							"InternalNew", loParam )

					Endif

					If This.lIsOk
						This.HookAfterNew(tnLevel,;
							tcAlias )
					Endif

				Endif

				If This.lIsOk
					This.ClassAfterNew(tnLevel,;
						tcAlias )
				Endif

			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If Not This.lAlreadyConnected
				This.DisconnectFromBackend()
			Endif


		Endtry

		* Aquí, SenData() va a serializar ( convierte a XML ) todos los cursores, ;
		ya sean los cursores con datos o el cursor conteniendo la información ;
		del/los errores ocurridos durante el proceso.
		lcXML = This.SendData( tnLevel, tcAlias )

		Return lcXML

	Endproc
	*
	* ClassAfter Event
	* Crea un nuevo elemento para la entidad. Basicamente, llama el metodo PUT sin un ID. Incluido para hacer "amigable" al codigo.
	Protected Procedure ClassAfterNew( tnLevel As Integer,;
			tcAlias As String ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:33:08)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			tnLevel AS Integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			Nodefault

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

	Endproc



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: InternalNew
	*!* Description...: Es llamado por el método LookOverColTables, una vez para cada tabla
	*!* Date..........: Martes 7 de Febrero de 2006 (14:14:12)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure InternalNew( toTable As oTable Of "Comun\Prg\ColTables.prg",;
			toParam As Object ) As Boolean;
			HELPSTRING "Es llamado por el método LookOverColTables, una vez para cada tabla"

		Local lcAlias As String
		Local lcSelectCmd As String

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			If toTable.Nivel - toParam.nOffSet <= toParam.nLevel
				lcAlias = toTable.CursorName

				If !Empty( toParam.cAlias ) And toParam.nLevel = 1
					lcAlias = Alltrim( toParam.cAlias )
				Endif

				If Empty( toTable.SQLStat )
					* DAE 2009-07-14
					* lcSelectCmd = "SELECT * FROM " + toTable.Tabla
					If This.lHasDefault
						lcSelectCmd = "Select *, Default Selected, 99999 _RecordOrder " ;
							+ " From " + toTable.Tabla

					Else && This.lHasDefault
						lcSelectCmd = "Select *, 99999 _RecordOrder " ;
							+ " From " + toTable.Tabla

					Endif && This.lHasDefault

				Else
					lcSelectCmd = toTable.SQLStat
				Endif

				lcSelectCmd = lcSelectCmd + " WHERE 1 = 0"

				This.BuildCursor( lcAlias, lcSelectCmd )

				* Aquí sería el lugar indicado para hacerle un APPEND BLANK ;
				al cursor generado ya que estamos "agregando" un nuevo registro ;
				pero vamos a tener que hacerlo en UserTierAdapter ya que si no, ;
				el DiffGram toma como "Modified" lo que debería tomar como ;
				"Inserted".

				toTable.LastSQL = lcSelectCmd

			Endif


		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally

		Endtry

		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE InternalNew
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetOne
	*!* Description...: Devuelve un registro segun su Primary Key.
	*!* Date..........: Jueves 12 de Enero de 2006 (16:18:46)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetOne( txEntidad As Number,;
			nLevel As Number,;
			cAlias As String,;
			nFillLevel As Number,;
			cXMLFilter As String, ;
			tnSQLOption As Integer ) As String;
			HELPSTRING "Devuelve un registro segun su Primary Key."

		Local lcRetVal As String
		Local lllAlreadyConnected As Boolean
		Local loParam As Object
		Local lnOffSet As Integer
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try
			*!*	loError = This.oError
			*!*	loError.TraceLogin = ""
			*!*	loError.Remark = ""

			If Empty( cAlias )
				cAlias = ""
			Endif

			If Empty( nLevel )
				nLevel = 1
			Endif

			If Empty( nFillLevel )
				nFillLevel = nLevel
			Endif

			If Empty( cXMLFilter )
				cXMLFilter = ""
			Endif

			lnOffSet = 0

			If Vartype( tnSQLOption ) # 'N'
				tnSQLOption = SQL_STAT_DEFAULT

			Else
				If Empty( tnSQLOption ) Or  ! Between( tnSQLOption, 1, 4 )
					tnSQLOption = SQL_STAT_DEFAULT

				Endif && Empty( tnSQLOption ) Or  ! Between( tnSQLOption, 1, 4 )

			Endif && Vartype( tnSQLOption ) # 'N'


			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk

				If This.oColTables.Count > 0
					loTable = This.oColTables.Item( 1 )
					lnOffSet = loTable.Nivel - 1
				Endif

				loParam = Createobject( "Empty" )
				AddProperty( loParam, "nEntidadId", txEntidad )
				AddProperty( loParam, "nLevel", nLevel )
				AddProperty( loParam, "cAlias", cAlias )
				AddProperty( loParam, "nFillLevel", nFillLevel )
				AddProperty( loParam, "cXMLFilter", cXMLFilter )
				AddProperty( loParam, "nOffSet", lnOffSet )
				AddProperty( loParam, "nSQLOption", tnSQLOption )

				This.LookOverColTables( This.oColTables,  "InternalGetOne", loParam )

			Endif

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:38:59)
			*!*	loError = This.oError
			*!*	This.cXMLoError = loError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			loTable = Null
			loParam = Null
			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

		lcRetVal = This.SendData( nLevel, cAlias )

		*!*	loError = This.oError
		*!*	loError.TraceLogin = ""
		*!*	loError.Remark = ""
		loError = Null

		Return ( lcRetVal )

	Endproc && GetOne

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetChildren
	*!* Description...: Trae la entidad principal, y algunos hijos, hasta el nivel indicado
	*!* Date..........: Jueves 28 de Febrero de 2008 (11:27:33)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	*!*	nMainId = PK de la entidad padre
	*!*	cChildrenList = Un XML con un cursor con la lista de los hijos a traer.
	*!*					Si está vacía trae TODOS
	*!*	nLevel = Nivel hasta el que se traen las tablas
	*!*	nFillLevel = Nivel hasta el que se traen las tablas llenas, si es menor que
	*!*				 nLevel, el resto de las tablas son cursores vacíos
	*!*	cFieldName = Nombre del campo de la tabla hija que figura en cChildrenList.
	*!*				 Si está vacío, es el definido en oTable.ForeingKey

	Procedure GetChildren( nMainId As Integer,;
			cChildrenList As String,;
			nLevel As Integer,;
			nFillLevel As Integer,;
			cFieldName As String   ) As String;
			HELPSTRING "Trae la entidad principal, y algunos hijos, hasta el nivel indicado"

		Local lcRetVal As String
		Local lllAlreadyConnected As Boolean
		Local loParam As Object
		Local lnOffSet As Integer

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			lnOffSet = 0

			If Empty( nFillLevel )
				nFillLevel = nLevel
			Endif

			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk

				If This.oColTables.Count > 0
					loTable = This.oColTables.Item( 1 )
					lnOffSet = loTable.Nivel - 1
				Endif

				loParam = Createobject("Empty")
				AddProperty(loParam, "nMainId", nMainId )
				AddProperty(loParam, "nLevel", nLevel )
				AddProperty(loParam, "nFillLevel", nFillLevel )
				AddProperty(loParam, "cChildrenList", cChildrenList )
				AddProperty(loParam, "cFieldName", cFieldName )
				AddProperty(loParam, "nOffSet", lnOffSet )

				This.LookOverColTables( This.oColTables, ;
					"InternalGetChildren", loParam)

			Endif

		Catch To oErr
			This.lIsOk = .F.
			*!*	This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			loParam = Null

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

		lcRetVal = This.SendData( nLevel )

		Return ( lcRetVal )


	Endproc
	*!*
	*!* END PROCEDURE GetChildren
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetFirst
	*!* Description...: Obtiene el primer registro
	*!* Date..........: Miércoles 3 de Enero de 2007 (17:58:00)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetFirst( tcFieldName As String,;
			tcFilterCriteria As String,;
			tnLevel As Integer ) As String;
			HELPSTRING "Obtiene el primer registro"

		Local lcXML As String,;
			lcCommand As String,;
			lcAlias As String

		Local lnId As Integer

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			lcAlias = Sys( 2015 )

			If Empty( tcFilterCriteria )
				tcFilterCriteria = ' 1 > 0 '
			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
				SELECT TOP 1 <<This.cMainCursorPK>>
				FROM <<This.cMainTableName>>
				WHERE <<tcFilterCriteria>>
				ORDER BY <<tcFieldName>>
			ENDTEXT

			This.SQLExecute( lcCommand, lcAlias )

			If Used( lcAlias )
				Select Alias( lcAlias )
				Locate
				*!*					lcXML = This.GetOne( Evaluate( lcAlias + "." + This.cMainCursorPK ), tnLevel )
				lcXML = Evaluate( lcAlias + "." + This.cMainCursorPK )
			Endif

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )
			lcXML = This.cXMLoError

		Finally
			If Used( lcAlias )
				Use In Alias( lcAlias )
			Endif

		Endtry

		Return lcXML

	Endproc
	*!*
	*!* END PROCEDURE GetFirst
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetLast
	*!* Description...: Obtiene el último registro
	*!* Date..........: Miércoles 3 de Enero de 2007 (17:58:00)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetLast( tcFieldName As String,;
			tcFilterCriteria As String,;
			tnLevel As Integer ) As String;
			HELPSTRING "Obtiene el último registro"

		Local lcXML As String,;
			lcCommand As String,;
			lcAlias As String

		Local lnId As Integer

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			lcAlias = Sys( 2015 )

			If Empty( tcFilterCriteria )
				tcFilterCriteria = ' 1 > 0 '
			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
				SELECT TOP 1 <<This.cMainCursorPK>>
				FROM <<This.cMainTableName>>
				WHERE <<tcFilterCriteria>>
				ORDER BY <<tcFieldName>>
				DESC
			ENDTEXT

			This.SQLExecute( lcCommand, lcAlias )

			If Used( lcAlias )
				Select Alias( lcAlias )
				Locate
				*!*					lcXML = This.GetOne( Evaluate( lcAlias + "." + This.cMainCursorPK ), tnLevel )
				lcXML = Evaluate( lcAlias + "." + This.cMainCursorPK )
			Endif

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )
			lcXML = This.cXMLoError

		Finally
			If Used( lcAlias )
				Use In Alias( lcAlias )
			Endif

		Endtry

		Return lcXML

	Endproc
	*!*
	*!* END PROCEDURE GetLast
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetNext
	*!* Description...: Obtiene el siguiente registro
	*!* Date..........: Miércoles 3 de Enero de 2007 (17:58:00)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Getnext( tcFieldName As String,;
			tuCurrentValue As Variant,;
			tcFilterCriteria As String,;
			tnLevel As Integer ) As String;
			HELPSTRING "Obtiene el siguiente registro"

		Local lcXML As String,;
			lcCommand As String,;
			lcAlias As String,;
			luCurrentValue As String,;
			lcFieldName As String

		Local lnId As Integer
		Local loDD As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			loDD = NewDataDictionary()
			loField = loDD.GetItem( This.cMainTableName + "." +  tcFieldName )

			lcAlias = Sys( 2015 )

			If Empty( tcFilterCriteria )
				tcFilterCriteria = ' 1 > 0 '
			Endif


			Do Case
				Case Vartype( tuCurrentValue ) = "N"

					If Inlist( loField.FieldType,;
							"character",;
							"varchar" )

						lcFieldName = [Val( &tcFieldName. )]

					Else
						lcFieldName = tcFieldName

					Endif

					luCurrentValue = Any2Char( tuCurrentValue )

				Otherwise
					luCurrentValue = Any2Char( tuCurrentValue, "''" )
					lcFieldName = tcFieldName

			Endcase

			TEXT To lcCommand NoShow TextMerge Pretext 15
				SELECT TOP 1 <<This.cMainCursorPK>>
				FROM <<This.cMainTableName>>
				WHERE <<tcFilterCriteria>>
				AND <<lcFieldName>> > <<luCurrentValue>>
				ORDER BY <<tcFieldName>>
			ENDTEXT

			This.SQLExecute( lcCommand, lcAlias )

			If Used( lcAlias )
				Select Alias( lcAlias )
				Locate

				If Empty( Evaluate( lcAlias + "." + This.cMainCursorPK ) )
					lcXML = This.GetFirst( tcFieldName,;
						tcFilterCriteria,;
						tnLevel)

				Else
					*!*						lcXML = This.GetOne( Evaluate( lcAlias + "." + This.cMainCursorPK ),;
					*!*							tnLevel )

					lcXML = Evaluate( lcAlias + "." + This.cMainCursorPK )

				Endif



			Endif

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )
			lcXML = This.cXMLoError

		Finally
			If Used( lcAlias )
				Use In Alias( lcAlias )
			Endif

			If !This.lIsOk
				lcXML = This.cXMLoError
			Endif

		Endtry

		Return lcXML

	Endproc
	*!*
	*!* END PROCEDURE GetNext
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetPrior
	*!* Description...: Obtiene el registro anterior
	*!* Date..........: Miércoles 3 de Enero de 2007 (17:58:00)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetPrior( tcFieldName As String,;
			tuCurrentValue As Variant,;
			tcFilterCriteria As String,;
			tnLevel As Integer ) As String;
			HELPSTRING "Obtiene el siguiente registro"

		Local lcXML As String,;
			lcCommand As String,;
			lcAlias As String,;
			luCurrentValue As String,;
			lcFieldName As String

		Local lnId As Integer

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			loDD = NewDataDictionary()
			loField = loDD.GetItem( This.cMainTableName + "." +  tcFieldName )

			lcAlias = Sys( 2015 )

			If Empty( tcFilterCriteria )
				tcFilterCriteria = ' 1 > 0 '
			Endif

			Do Case
				Case Vartype( tuCurrentValue ) = "N"
					If Inlist( loField.FieldType,;
							"character",;
							"varchar" )

						lcFieldName = [Val( &tcFieldName. )]

					Else
						lcFieldName = tcFieldName

					Endif

					luCurrentValue = Any2Char( tuCurrentValue )


				Otherwise
					luCurrentValue = Any2Char( tuCurrentValue, "''" )
					lcFieldName = tcFieldName

			Endcase

			TEXT To lcCommand NoShow TextMerge Pretext 15
				SELECT TOP 1 <<This.cMainCursorPK>>
				FROM <<This.cMainTableName>>
				WHERE <<tcFilterCriteria>>
				AND <<lcFieldName>> < <<luCurrentValue>>
				ORDER BY <<tcFieldName>>
				DESC
			ENDTEXT

			This.SQLExecute( lcCommand, lcAlias )

			If Used( lcAlias )
				Select Alias( lcAlias )
				Locate

				If Empty( Evaluate( lcAlias + "." + This.cMainCursorPK ) )
					lcXML = This.GetLast( tcFieldName,;
						tcFilterCriteria,;
						tnLevel)

				Else
					*!*						lcXML = This.GetOne( Evaluate( lcAlias + "." + This.cMainCursorPK ),;
					*!*							tnLevel )

					lcXML = Evaluate( lcAlias + "." + This.cMainCursorPK )

				Endif


			Endif

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )
			lcXML = This.cXMLoError

		Finally
			If Used( lcAlias )
				Use In Alias( lcAlias )
			Endif

		Endtry

		Return lcXML

	Endproc
	*!*
	*!* END PROCEDURE GetPrior
	*!*
	*!* ///////////////////////////////////////////////////////

	Protected Procedure InternalGetOne( toTable As oTable Of "Comun\Prg\ColTables.prg",;
			toParam As Object ) As Boolean;
			HELPSTRING "Es llamado por el método LookOverColTables, una vez para cada tabla"

		Local lcIdEntidad As String, ;
			lcFieldName As String, ;
			lcAlias As String, ;
			lcSelectCmd As String,;
			lcXMLFilter As String,;
			lcTemp As String

		Local loXA As Xmladapter
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Local lnSQLOption As Integer

		Try
			*!*	loError = This.oError
			*!*	loError.TraceLogin = ""
			*!*	loError.Remark = ""

			lcTemp = ""

			If toTable.Nivel - toParam.nOffSet <= toParam.nLevel

				lcAlias = toTable.CursorName

				If !Empty( toParam.cAlias ) And toParam.nLevel = 1
					lcAlias = Alltrim( toParam.cAlias )

				Endif

				If Empty( lcXMLFilter )
					lcXMLFilter = toTable.WhereStatement

				Endif

				If !Empty( lcXMLFilter )
					loXA = Newobject("prxXMLAdapter","FW\Comunes\Prg\prxXMLAdapter.prg")

					loXA.LoadXML( lcXMLFilter )
					loXA.Tables(1).ToCursor()
					loXA = Null

					lcTemp= Alias()

					Locate For Alltrim( Lower( CursorName )) == Alltrim( Lower( loTable.CursorName ))

					If !Eof()
						loTable.WhereStatement = Evaluate( lcTemp + ".WhereStatement" )

					Endif

				Endif

				*!*	If Empty( toTable.SQLStat )
				*!*		* DAE 2009-07-14
				*!*		* lcSelectCmd = "SELECT * FROM " + toTable.Tabla
				*!*		If This.lHasDefault
				*!*			lcSelectCmd = "Select *, Default Selected, 99999 _RecordOrder " ;
				*!*				+ " From " + toTable.Tabla

				*!*		Else && This.lHasDefault
				*!*			* DAE 2009-09-08(14:53:36)
				*!*			* Siempre traido selected
				*!*			* lcSelectCmd = "Select *, 99999 _RecordOrder " ;
				*!*			+ " From " + toTable.Tabla
				*!*			lcSelectCmd = "Select *, 0 Selected, 99999 _RecordOrder " ;
				*!*				+ " From " + toTable.Tabla

				*!*		Endif && This.lHasDefault

				*!*	Else
				*!*		lcSelectCmd = toTable.SQLStat

				*!*	Endif


				* lcSelectCmd = toTable.SQLStat

				If Pemstatus( toParam, 'nSQLOption', 1 )
					lnSQLOption = toParam.nSQLOption
					If Vartype( lnSQLOption ) # 'N'
						lnSQLOption = SQLStat

					Else
						If Empty( lnSQLOption) Or  ! Between( lnSQLOption, 1, 4 )
							lnSQLOption = SQL_STAT_DEFAULT

						Endif

					Endif && Vartype( tnSQLOption ) # 'N'

				Else
					lnSQLOption = SQL_STAT_DEFAULT

				Endif && Pemstatus( toParam, 'nSQLOption' )

				Do Case
					Case  lnSQLOption = SQL_STAT_DEFAULT
						lcSelectCmd = toTable.SQLStat

					Case  lnSQLOption = SQL_STAT_SELECTOR
						lcSelectCmd = toTable.SQLStatSelector

					Case  lnSQLOption = SQL_STAT_COMBO
						lcSelectCmd = toTable.SQLStatCombo

					Case  lnSQLOption = SQL_STAT_KEYFINDER
						lcSelectCmd = toTable.SQLStatKeyFinder

				Endcase

				lcIdEntidad = Any2Char( toParam.nEntidadId, .T. )

				Do Case
					Case toParam.nOffSet > 0
						* La Entidad es una Entidad hija que se conecta directamente a la base
						Do Case
							Case toTable.Nivel - toParam.nOffSet = 1
								lcFieldName = toTable.PKName

							Case toTable.Nivel - toParam.nOffSet = 2
								lcFieldName = toTable.ForeignKey

							Otherwise
								lcFieldName = toTable.MainId
						Endcase

					Case toTable.Nivel = 1
						lcFieldName = toTable.PKName

					Case toTable.Nivel = 2
						lcFieldName = toTable.ForeignKey

					Otherwise
						lcFieldName = toTable.MainId

				Endcase

				Do Case
					Case ! Empty( toTable.WhereStatement )
						lcSelectCmd = lcSelectCmd + " WHERE " + toTable.WhereStatement

					Case toTable.Nivel > toParam.nFillLevel ;
							And !( Lower( This.cDataConfigurationKey )= Lower( toTable.cKeyName ))

						lcSelectCmd = lcSelectCmd + " WHERE 1 = 0"

					Otherwise
						lcSelectCmd = lcSelectCmd + " WHERE " + toTable.Tabla + "." + lcFieldName + " = " + lcIdEntidad

				Endcase


				If ! Empty( toTable.OrderBy )
					lcSelectCmd = lcSelectCmd + " ORDER BY " + toTable.OrderBy

				Endif

				This.BuildCursor( lcAlias, lcSelectCmd )

			Endif

		Catch To oErr
			This.lIsOk = .F.
			*!*	This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			* DAE 2009-09-08(14:52:28)
			*!*	If Used( lcTemp )
			*!*		Use In Alias( lcTemp )
			*!*	Endif
			Use In Select( lcTemp )
			toTable.WhereStatement = ""

			loError = Null

		Endtry

		Return This.lIsOk

	Endproc && InternalGetOne

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: InternalGetChildren
	*!* Description...:
	*!* Date..........: Jueves 28 de Febrero de 2008 (12:08:49)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure InternalGetChildren( toTable As oTable Of "Comun\Prg\ColTables.prg",;
			toParam As Object ) As Boolean;
			HELPSTRING "Es llamado por el método LookOverColTables, una vez para cada tabla"


		Local lcIdEntidad As String
		Local lcFieldName As String
		Local lcAlias As String
		Local lcSelectCmd As String
		Local lcChildrenList As String
		Local lcWhere As String

		Local lcTempFile1 As String
		Local lcTempFile2 As String

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			lcWhere = ""

			lcTempFile1 = ""
			lcTempFile2 = ""

			If toTable.Nivel - toParam.nOffSet <= toParam.nLevel

				lcIdEntidad = Any2Char( toParam.nMainId, "'")

				Do Case
					Case toTable.Nivel - toParam.nOffSet = 1
						* Obtener el registro normalmente
						lcSelectCmd = "SELECT * FROM " + toTable.Tabla
						lcFieldName = toTable.PKName
						lcWhere = " WHERE " + toTable.Tabla + "." + lcFieldName + " = " + lcIdEntidad

					Otherwise
						* Si cFieldName NO está vacío, transformar cChildrenList a una
						* lista de PK, y vaciar cFieldName
						*

						* Obtener el cursor con cChildrenList

						If Empty( toParam.cFieldName )
							toParam.cFieldName = toTable.PKName
						Endif

						If Lower( toParam.cFieldName ) <> Lower( toTable.PKName )

							This.GetData( toParam.cChildrenList )
							lcTempFile1 = Alias()

							lcChildrenList = ""
							Afields( laFields )

							Select Alias( lcTempFile1 )
							Locate
							Scan
								lcChildrenList = lcChildrenList + [,] +;
									Any2Char(Evaluate( lcTempFile1 + '.' + laFields[ 1, 1 ] ), ['])
							Endscan

							If Empty( lcChildrenList )
								lcWhere = " WHERE 1 > 0 "

							Else
								lcChildrenList = Substr( lcChildrenList, 2 )
								lcWhere = " WHERE " + toTable.Tabla + [.] + toParam.cFieldName + ;
									[ IN ( ] +  lcChildrenList + [ )]

							Endif

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Select <<toTable.PKName>>
							FROM <<toTable.Tabla>>
							<<lcWhere>>
							ENDTEXT

							lcTempFile2 = Sys(2015)
							This.BuildCursor( lcTempFile2, lcCommand )

							toParam.cChildrenList = This.Serialize( lcTempFile2 )
							toParam.cFieldName = toTable.PKName

							Use In Alias( lcTempFile1 )
							Use In Alias( lcTempFile2 )

						Endif

						This.GetData( toParam.cChildrenList )
						lcTempFile1 = Alias()

						lcChildrenList = ""

						Select Alias( lcTempFile1 )
						Locate
						Scan
							lcChildrenList = lcChildrenList + [,] +;
								Any2Char(Evaluate( lcTempFile1 + '.' + toTable.PKName ), ['])
						Endscan

						If Empty( lcChildrenList )
							If toTable.Nivel - toParam.nOffSet = 2
								lcFieldName = toTable.ForeignKey

							Else
								lcFieldName = toTable.MainId

							Endif

							lcWhere = " WHERE 1 > 0 And " +;
								toTable.Tabla + "." + lcFieldName + " = " + lcIdEntidad

						Else
							lcChildrenList = Substr( lcChildrenList, 2 )
							lcWhere = [ WHERE ] + toTable.Tabla + [.] + toParam.cFieldName + ;
								[ IN ( ] +  lcChildrenList + [ ) ]

						Endif

						TEXT To lcSelectCmd NoShow TextMerge Pretext 15
						Select *
							FROM <<toTable.Tabla>>
						ENDTEXT

				Endcase

				lcAlias = toTable.CursorName

				If toTable.Nivel - toParam.nOffSet > toParam.nFillLevel
					lcWhere = " WHERE 1 = 0"

				Endif

				lcSelectCmd = lcSelectCmd + lcWhere

				If !Empty( toTable.OrderBy )
					lcSelectCmd = lcSelectCmd + " ORDER BY " + toTable.OrderBy
				Endif

				This.BuildCursor( lcAlias, lcSelectCmd )

				toTable.LastSQL = lcSelectCmd

			Endif

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally
			If Used( lcTempFile1 )
				Use In Alias( lcTempFile1 )
			Endif

			If Used( lcTempFile2 )
				Use In Alias( lcTempFile2 )
			Endif

		Endtry

		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE InternalGetChildren
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetAll
	*!* Description...: Devuelve un conjunto de datos
	*!* Date..........: Jueves 12 de Enero de 2006 (16:27:28)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!* DAE 2009-08-27(17:49:19)
	*!* Si esta definido en la tabla la propiedad SQLStat
	*!* utilizo este select mas tcFilterCriteria y el Order by definido
	*!*
	*!*	 Obsoleto  *!* Devuelve los campos especificados en "cGetAllFields" (por defecto TODOS)
	*!*			   *!*de aquellos registros que cumplan con el filtro "cFilterCriteria"
	*!*			   *!* (por defecto TODOS)
	*!*  DAE 2009-10-27(17:32:32)
	*!* Siempre se utiliza SQLStat que se define o resuelve automaticamente en el sincronizador
	*!*

	Procedure GetAll( tcFilterCriteria As String, ;
			tcCursorAlias As String,;
			tcOrderBy As String, ;
			tnSQLOption As Integer ) As String;
			HELPSTRING "Devuelve un conjunto de datos"


		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		*
		Local lcFilter As String
		Local lcAlias As String
		Local lcSelectCmd As String
		Local lcOrderBy As String
		Local lcSQLStat As String
		*
		Local lllAlreadyConnected As Boolean

		Try

			*!*	loError = This.oError
			*!*	loError.TraceLogin = ""
			*!*	loError.Remark = ""

			* DAE 2009-10-29(15:32:13)
			* Utilizo el SQLStat
			* This.BeforeGetAllFields()

			loTable = This.oColTables.GetItem( This.cMainTableName )

			If Vartype( tnSQLOption ) # 'N'
				tnSQLOption = SQL_STAT_DEFAULT

			Else
				If Empty( tnSQLOption ) Or  ! Between( tnSQLOption, 1, 4 )
					tnSQLOption = SQL_STAT_DEFAULT

				Endif && Empty( tnSQLOption ) Or  ! Between( tnSQLOption, 1, 4 )

			Endif && Vartype( tnSQLOption ) # 'N'

			Do Case
				Case  tnSQLOption = SQL_STAT_DEFAULT
					lcSQLStat = loTable.SQLStat

				Case  tnSQLOption = SQL_STAT_SELECTOR
					lcSQLStat = loTable.SQLStatSelector

				Case  tnSQLOption = SQL_STAT_COMBO
					lcSQLStat = loTable.SQLStatCombo

				Case  tnSQLOption = SQL_STAT_KEYFINDER
					lcSQLStat = loTable.SQLStatKeyFinder

			Endcase

			lcFilter = Iif( Empty( tcFilterCriteria ), "", " WHERE " + tcFilterCriteria )

			If Empty( tcOrderBy )
				lcOrderBy = Iif( Empty( loTable.OrderBy ), "", " ORDER BY  " + loTable.OrderBy )

			Else
				lcOrderBy = " ORDER BY  " + tcOrderBy

			Endif && Empty( tcOrderBy )

			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk

				lcAlias = Iif( Empty( tcCursorAlias ), This.cMainCursorName, tcCursorAlias )
				* Armo el Select
				lcSelectCmd = lcSQLStat + lcFilter + lcOrderBy

				This.BuildCursor( lcAlias, lcSelectCmd )

			Endif && This.lIsOk

		Catch To oErr
			This.lIsOk = .F.
			* This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			If ! lllAlreadyConnected
				This.DisconnectFromBackend()

			Endif && ! lllAlreadyConnected

		Endtry

		Return ( This.Serialize( lcAlias ) )

	Endproc && GetAll

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: xxxGetAll
	*!* Description...: Devuelve un conjunto de datos
	*!* Date..........: Jueves 12 de Enero de 2006 (16:27:28)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!* DAE 2009-08-27(17:49:19)
	*!* Si esta definido en la tabla la propiedad SQLStat
	*!* utilizo este select mas tcFilterCriteria y el Order by definido
	*!*
	* Devuelve los campos especificados en "cGetAllFields" (por defecto TODOS) ;
	de aquellos registros que cumplan con el filtro "cFilterCriteria" ;
	(por defecto TODOS)

	Procedure xxxGetAll( tcFilterCriteria As String, ;
			tcCursorAlias As String,;
			tcOrderBy As String ) As String;
			HELPSTRING "Devuelve un conjunto de datos"

		Local lcFields As String,;
			lcFilter As String,;
			lcAlias As String,;
			lcSelectCmd As String,;
			lcOrderBy As String

		Local lllAlreadyConnected As Boolean
		Local loTable As oTable Of "Comun\Prg\ColTables.prg"

		Local lxIndex As Variant
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local lcSQLStat As String

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			This.BeforeGetAllFields()

			loTable = This.oColTables.GetItem( This.cMainTableName )
			lcSQLStat = loTable.SQLStat

			If Empty( lcSQLStat )
				lcFields = Iif( Empty( This.cGetAllFields ), "*", " " + Alltrim(This.cGetAllFields) + " " )
				lcJoins  = Iif( Empty( This.cGetAllJoins ), "", " " + Alltrim(This.cGetAllJoins) + " " )

			Endif

			lcFilter = Iif( Empty( tcFilterCriteria ), "", " WHERE " + tcFilterCriteria )

			If Empty( tcOrderBy )
				lcOrderBy = Iif( Empty( This.cGetAllOrderBy ), "", " ORDER BY  " + This.cGetAllOrderBy )
			Else
				lcOrderBy = " ORDER BY  " + tcOrderBy
			Endif

			lllAlreadyConnected = This.ConnectToBackend() = 0
			If This.lIsOk

				lcAlias = Iif( Empty( tcCursorAlias ), This.cMainCursorName, tcCursorAlias )
				If Empty( lcSQLStat )
					lcSelectCmd = "SELECT " + lcFields ;
						+ " FROM " + IfEmpty( This.cGetAllView, This.cMainTableName ) ;
						+ lcJoins ;
						+ lcFilter ;
						+ lcOrderBy
				Else
					lcSelectCmd = lcSQLStat ;
						+ lcFilter ;
						+ lcOrderBy

				Endif

				This.BuildCursor( lcAlias, lcSelectCmd )

				*!*	For Each loTable In This.oColTables
				*!*		* xxxGetAll solo procesará la tabla de nivel 1 (uno) dentro ;
				*!*		de la colección

				*!*		lcAlias = Iif( Empty( tcCursorAlias ), loTable.CursorName, tcCursorAlias )
				*!*		lcSelectCmd = "SELECT " + lcFields ;
				*!*			+ " FROM " + IfEmpty( This.cGetAllView, loTable.Tabla ) ;
				*!*			+ lcJoins ;
				*!*			+ lcFilter

				*!*		This.BuildCursor( lcAlias, lcSelectCmd )

				*!*		loTable.LastSQL = lcSelectCmd

				*!*	Endfor

			Endif


		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError = This.oError.Process( oErr )

		Finally

			If ! lllAlreadyConnected
				This.DisconnectFromBackend()

			Endif && ! lllAlreadyConnected

		Endtry

		Return ( This.Serialize( lcAlias ) )

	Endproc && xxxGetAll


	*
	* GetAllCombo
	* Devuelve todos los registros que cumplan con el criterio de filtro recibido como parámetro.
	Procedure GetAllCombo( tcFilterCriteria As String, ;
			tcCursorAlias As String,;
			tcOrderBy As String ) As String;
			HELPSTRING "Devuelve un conjunto de datos"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve todos los registros que cumplan con el criterio de filtro recibido como parámetro.
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Jueves 29 de Octubre de 2009
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			tcFilterCriteria AS String
			tcAlias AS String
			tcOrderBy AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif


		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		*
		Local lcFilter As String
		Local lcAlias As String
		Local lcSelectCmd As String
		Local lcOrderBy As String
		Local lcSQLStatCombo As String
		*
		Local lllAlreadyConnected As Boolean

		Try

			*!*	loError = This.oError
			*!*	loError.TraceLogin = ""
			*!*	loError.Remark = ""

			loTable = This.oColTables.GetItem( This.cMainTableName )
			lcSQLStatCombo = loTable.SQLStatCombo

			lcFilter = Iif( Empty( tcFilterCriteria ), "", " WHERE " + tcFilterCriteria )

			If Empty( tcOrderBy )
				lcOrderBy = Iif( Empty( loTable.OrderBy ), "", " ORDER BY  " + loTable.OrderBy )

			Else
				lcOrderBy = " ORDER BY  " + tcOrderBy

			Endif && Empty( tcOrderBy )

			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk

				lcAlias = Iif( Empty( tcCursorAlias ), This.cMainCursorName, tcCursorAlias )
				* Armo el Select
				lcSelectCmd = lcSQLStatCombo + lcFilter + lcOrderBy

				This.BuildCursor( lcAlias, lcSelectCmd )

			Endif && This.lIsOk

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:37:43)
			* This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			If ! lllAlreadyConnected
				This.DisconnectFromBackend()

			Endif && ! lllAlreadyConnected

		Endtry

		Return ( This.Serialize( lcAlias ) )

	Endproc && GetAllCombo


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetByWhere
	*!* Description...:
	*!* Date..........: Jueves 14 de Junio de 2007 (14:57:49)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	* Devuelve el registro, hasta determinado nivel de jerarquía,
	* que cumple con el criterio de filtro recibido como parámetro.
	* Si existe más de un registro, devuelve un tag especial que
	* contiene la cantidad de registros que cumplen con el criterio

	Procedure GetByWhere( tcFilterCriteria As String, ;
			tnLevel As Number,;
			tcCursorAlias As String, ;
			tnSQLOption As Integer ) As String

		Local lcXML As String
		Local lnReturnValue As Integer
		Local loParam As Object

		Try
			*!*	loError = This.oError
			*!*	loError.TraceLogin = ""
			*!*	loError.Remark = ""
			This.lIsOk = .T.
			lnReturnValue = -1

			lcXML = This.GetAllPaginatedCount( tcFilterCriteria, tnSQLOption )

			If This.lIsOk
				loParam = XmlToObject( lcXML )
				lnReturnValue = loParam.nRowsQuantity

			Endif

			If This.lIsOk
				If lnReturnValue <> 1
					* Devuelvo el objeto serializado, con la información
					* de la cantidad de registros
					lcXML = USER_TAG + lcXML

				Else
					* Devuelvo la entidad serializada
					lcXML = This.GetOne( loParam.EntityId, tnLevel, tcCursorAlias, tnSQLOption )

				Endif

			Endif

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:37:22)
			*!*	This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			lcXML = This.cXMLoError

		Finally
			loError = Null

		Endtry

		Return lcXML
	Endproc  && GetByWhere

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: BeforecGetAllFields
	*!* Description...: Hook Method
	*!* Date..........: Viernes 31 de Octubre de 2008 (18:35:43)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure BeforeGetAllFields(  ) As Void;
			HELPSTRING "Hook Method"


		Try

			If Empty( This.cGetAllFields )
				This.cGetAllFields = This.oServiceTier.GetAllFields()
			Endif

			If Empty( This.cGetAllJoins )
				This.cGetAllJoins = This.oServiceTier.GetAllJoins()
			Endif

			If Empty( This.cGetAllPaginatedOrderBy )
				This.cGetAllPaginatedOrderBy = This.oServiceTier.GetAllPaginatedOrderBy()
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && BeforecGetAllFields

	* Especializado en la DataTier de cada entidad
	Procedure GetAllFilterCriteria( tcFilterCriteria As String ) As String

		Return ''

	Endproc && GetAllFilterCriteria

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetAllPaginated
	*!* Description...: Devuelve la página n de un conjunto de datos mayor
	*!* Date..........: Jueves 12 de Enero de 2006 (16:35:29)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -

	*!* Devuelve los campos especificados en "cGetAllFields" (por defecto TODOS)
	*!* de aquellos registros que cumplan con el filtro "cFilterCriteria" (por defecto TODOS)

	*!* Parámetros adicionales para paginación de resultados:
	*!* 	tnPageNro			El número de la página a visualizar
	*!* 	tnRowsPerPage		La cantidad de filas por página

	Procedure GetAllPaginated( tcFilterCriteria As String,;
			tnPageNro As Number,;
			tnRowsPerPage As Number,;
			tcXMLParams As String, ;
			tnSQLOption As Integer ) As String;
			HELPSTRING "Devuelve la página n de un conjunto de datos mayor"

		Local lcRetVal As String
		*!*	Local lcFields As String
		Local lcFilter As String
		Local lcCommand As String
		Local lcPK As String
		Local lcOrderBy As String
		Local lcSQLStat As String
		*
		Local lnExcludedRows As Integer
		*
		Local lllAlreadyConnected As Boolean
		*
		Local loMyCA As prxCursorAdapter Of "Comun\Prg\prxCursorAdapter.prg"
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loParam As Object
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try
			*!*	loError = This.oError
			*!*	loError.TraceLogin = ""
			*!*	loError.Remark = ""

			loTable = This.oColTables.Item[ 1 ]
			lcPK = This.cMainTableName + '.' + This.cMainCursorPK

			lcFilter = tcFilterCriteria

			If Empty( lcFilter )
				lcFilter = " 1 = 1 "

			Endif && Empty( lcFilter )

			lcOrderBy = loTable.cOrderBySelector

			lnExcludedRows = ( tnPageNro - 1 ) * tnRowsPerPage

			loParam = Null

			If ! Empty( tcXMLParams )
				loParam = XmlToObject( tcXMLParams )

			Endif &&  ! Empty( tcXMLParams )

			If ! IsEmpty( loParam )
				If Pemstatus( loParam, "cOrderBy", 5 )
					lcOrderBy = loParam.cOrderBy

				Endif && Pemstatus( loParam, "cOrderBy", 5 )

			Endif && ! IsEmpty( loParam )

			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk
				loMyCA = Newobject( "prxCursorAdapter", "FW\TierAdapter\Comun\prxCursorAdapter.prg", "", This.cAccessType, This.oConnection, This.cBackEndEngine )

				With loMyCA As prxCursorAdapter Of "FW\TierAdapter\Comun\prxCursorAdapter.prg"

					.Alias = This.cMainCursorName

					If Vartype( tnSQLOption ) # 'N'
						tnSQLOption = SQL_STAT_SELECTOR

					Else
						If Empty( tnSQLOption ) Or  ! Between( tnSQLOption, 1, 4 )
							tnSQLOption = SQL_STAT_SELECTOR

						Endif && Empty( tnSQLOption ) Or  ! Between( tnSQLOption, 1, 4 )

					Endif && Vartype( tnSQLOption ) # 'N'

					Do Case
						Case  tnSQLOption = SQL_STAT_DEFAULT
							lcSQLStat = loTable.SQLStat

						Case  tnSQLOption = SQL_STAT_SELECTOR
							lcSQLStat = loTable.SQLStatSelector

						Case  tnSQLOption = SQL_STAT_COMBO
							lcSQLStat = loTable.SQLStatCombo

						Case  tnSQLOption = SQL_STAT_KEYFINDER
							lcSQLStat = loTable.SQLStatKeyFinder

					Endcase

					lcAux =  Strextract( lcSQLStat, "SELECT", "FROM", 1, 1 )

					lcWhere2 = ' 1 = 1 And ' + lcFilter
					If lnExcludedRows = 0
						lnExcludedRows = 1
						lcWhere2 = ' 1 = 0 '

					Endif && lnExcludedRows = 0

					If 'distinct' $ Lower( lcAux )
						lcFields1 = Strtran( lcAux, 'distinct', ' distinct Top ' +  Transform( tnRowsPerPage ) + ' ', 1, 1, 1 )
						lcFields2 = ' distinct top ' +  Transform( lnExcludedRows ) + ' ' + lcPK + ' '

					Else
						lcFields1 = ' top ' +  Transform( tnRowsPerPage ) + ' ' + lcAux + ' '
						lcFields2 = ' top ' +  Transform( lnExcludedRows ) + ' ' + lcPK + ' '

					Endif &&  'distinct' $ Lower( lcAux )

					* Armo la consulta SQL
					TEXT TO lcSQLStatSelector TEXTMERGE NOSHOW PRETEXT 15
						<<Strtran( lcSQLStat, lcAux, lcFields1, 1, 1, 1 ) >>
						Where Not <<lcPK>> In (
								<<Strtran( lcSQLStat, lcAux, lcFields2, 1, 1, 1 )>>
								<<Iif( Empty( lcWhere2 ), '', ' Where ' + lcWhere2 )>>
								Order By <<Iif( Empty( lcOrderBy ), lcPK,  lcOrderBy )>>
								)
							And <<lcFilter>>
						Order By <<Iif( Empty( lcOrderBy ), lcPK,  lcOrderBy )>>

					ENDTEXT

					.SelectCmd = lcSQLStatSelector
					This.lIsOk = .CursorFill()
					.CursorDetach()

				Endwith

				This.cXMLoError = loMyCA.cXMLoError

				This.lIsOk = Empty( This.cXMLoError )

			Endif

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:36:22)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			loMyCA = Null
			Release loMyCA

			loParam = Null
			loError = Null

			If ! lllAlreadyConnected
				This.DisconnectFromBackend()

			Endif && ! lllAlreadyConnected

			If ! Empty( This.cXMLoError )
				lcRetVal = This.cXMLoError

			Endif && ! Empty( This.cXMLoError )
			loError = Null

		Endtry

		lcRetVal = This.SendData( 1 )

		Return ( lcRetVal )

	Endproc && GetAllPaginated

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: xxxGetAllPaginated
	*!* Description...: Devuelve la página n de un conjunto de datos mayor
	*!* Date..........: Jueves 12 de Enero de 2006 (16:35:29)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -

	*!* Devuelve los campos especificados en "cGetAllFields" (por defecto TODOS);
	de aquellos registros que cumplan con el filtro "cFilterCriteria" ;
	(por defecto TODOS)

	*!* Parámetros adicionales para paginación de resultados:    	;
	tnPageNro			El número de la página a visualizar		;
	tnRowsPerPage		La cantidad de filas por página


	Procedure xxxGetAllPaginated( tcFilterCriteria As String,;
			tnPageNro As Number,;
			tnRowsPerPage As Number,;
			tcXMLParams As String ) As String;
			HELPSTRING "Devuelve la página n de un conjunto de datos mayor"

		Local lcRetVal As String,;
			lcFields As String,;
			lcFilter As String,;
			lcCommand As String,;
			lcPK As String,;
			lcOrderBy As String

		Local lnExcludedRows As Integer

		Local lllAlreadyConnected As Boolean

		Local loMyCA As prxCursorAdapter Of "Comun\Prg\prxCursorAdapter.prg"

		Local loTable As oTable Of "Comun\Prg\ColTables.prg"
		Local loParam As Object

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			lcPK      = IfEmpty( This.cGetAllView, This.cMainTableName + '.' + This.cMainCursorPK )

			This.BeforeGetAllFields()

			lcFields  = Iif( Empty( This.cGetAllFields ), "*",  Alltrim(This.cGetAllFields) + " " )
			lcJoins   = Iif( Empty( This.cGetAllJoins ), "", " " + Alltrim(This.cGetAllJoins) + " " )
			lcOrderBy = Iif( Empty( This.cGetAllPaginatedOrderBy ), lcPK, This.cGetAllPaginatedOrderBy )
			***lcFilter  = This.GetAllFilterCriteria( tcFilterCriteria )
			lcFilter  = tcFilterCriteria

			lnExcludedRows = (tnPageNro - 1) * tnRowsPerPage

			loParam = Null

			If !Empty( tcXMLParams )
				loParam = XmlToObject( tcXMLParams )
			Endif


			If !IsEmpty( loParam )
				If Pemstatus( loParam, "cFields", 5 )
					lcFields = loParam.cFields
				Endif

				If Pemstatus( loParam, "cJoins", 5 )
					lcJoins = loParam.cJoins
				Endif

				If Pemstatus( loParam, "cOrderBy", 5 )
					lcOrderBy = loParam.cOrderBy
				Endif
			Endif

			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk
				loMyCA = .F.
				loMyCA = Newobject( "prxCursorAdapter",;
					"Comun\Prg\prxCursorAdapter"+Iif(This.lComComponent,".prg",".prg"),;
					"",;
					THIS.cAccessType,;
					THIS.oConnection,;
					THIS.cBackEndEngine )

				With loMyCA

					* VFP no acepta una SubQuery con TOP y tampoco acepta TOP 0
					If Upper(This.cAccessType)="NATIVE" Or Upper(This.cBackEndEngine)="FOX"

						.Alias = 'cTemp'
						If lnExcludedRows = 0
							lcCommand = 'Select ' + lcPK ;
								+ ' From ' + IfEmpty( This.cGetAllView, This.cMainTableName ) ;
								+ ' Where .F.'

						Else
							lcCommand = 'Select Top ' + Alltrim(Str(lnExcludedRows)) + ' ' + lcPK ;
								+ ' From ' + IfEmpty( This.cGetAllView, This.cMainTableName ) ;
								+ Iif( Empty( lcFilter ), '', ' Where ' + lcFilter ) ;
								+ ' Order By ' + lcOrderBy

						Endif
						.SelectCmd = lcCommand
						This.lIsOk = .CursorFill()

						If This.lIsOk
							.CursorDetach()

							.Alias = This.cMainCursorName

							* El siguiente IF es para contemplar que el SELECT ;
							tenga un "DISTINCT"
							If Upper(Left(lcFields,8)) == 'DISTINCT'
								lcFields = Substr(lcFields,Atc(lcFields,'DISTINCT') + 9)
								lcCommand = 'Select Distinct Top '
							Else
								lcCommand = 'Select Top '
							Endif

							lcCommand = lcCommand + Alltrim(Str(tnRowsPerPage)) + ' ' + lcFields ;
								+ ' From ' + IfEmpty( This.cGetAllView, This.cMainTableName ) ;
								+ lcJoins ;
								+ ' Where ' + lcPK + ' Not In (Select Distinct ' + This.cMainCursorPK + ' From cTemp)' ;
								+ Iif( Empty( lcFilter ), '', ' And ' + lcFilter ) ;
								+ ' Order By ' + lcOrderBy


							.SelectCmd = lcCommand
							This.lIsOk = .CursorFill()
							If This.lIsOk
								.CursorDetach()
							Endif
							If Used('cTemp')
								Use In 'cTemp'
							Endif

							*loTable.LastSQL = .SelectCmd

						Endif
					Else

						.Alias = This.cMainCursorName

						* El siguiente IF es para contemplar que el SELECT ;
						tenga un "DISTINCT"
						If Upper(Left(lcFields,8)) == 'DISTINCT'
							lcFields = Substr(lcFields,Atc(lcFields,'DISTINCT') + 9)
							lcCommand = 'Select Distinct Top '
						Else
							lcCommand = 'Select Top '
						Endif
						lcCommand = lcCommand + Alltrim(Str(tnRowsPerPage)) + ' ' + lcFields ;
							+ ' From ' + IfEmpty( This.cGetAllView, This.cMainTableName ) ;
							+ lcJoins ;
							+ ' Where ' + lcPK ;
							+ ' Not In (Select Top ' + Alltrim(Str(lnExcludedRows)) + ' ' + lcPK ;
							+         ' From ' + IfEmpty( This.cGetAllView, This.cMainTableName ) ;
							+           lcJoins ;
							+         + Iif( Empty( lcFilter ), '', ' Where ' + lcFilter ) ;
							+         ' Order By ' + lcOrderBy + ')' ;
							+ Iif( Empty( lcFilter ), '', ' And ' + lcFilter ) ;
							+ ' Order By ' + lcOrderBy
						.SelectCmd = lcCommand
						This.lIsOk = .CursorFill()
						.CursorDetach()

					Endif
				Endwith

				This.cXMLoError = loMyCA.cXMLoError

				This.lIsOk = Empty( This.cXMLoError )

			Endif

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError = This.oError.Process( oErr )

		Finally
			loMyCA = .F.
			Release loMyCA

			loParam = Null

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

			If !Empty( This.cXMLoError )
				lcRetVal = This.cXMLoError
			Endif

		Endtry

		lcRetVal = This.SendData( 1 )

		Return ( lcRetVal )

	Endproc && xxxGetAllPaginated

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetAllPaginatedCount
	*!* Description...:
	*!* Date..........: Jueves 12 de Enero de 2006 (19:37:31)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*

	*!* Devuelve la cantidad de registros que cumplen con "tcFilterCriteria"
	*!* Se debe utilizar junto a GetAllPaginated para calcular la cantidad
	*!* de paginas a mostrar segun la cantidad de resultados a mostrar

	Procedure GetAllPaginatedCount( tcFilterCriteria As String, tnSQLOption As Integer ) As String

		Local lcRetVal As String
		Local lcFilter As String
		Local lcPK As String
		Local lcAux As String
		Local lcSelectCmd As String
		Local lcSQLStatSelector As String
		Local lcSQLStat As String
		*
		Local lllAlreadyConnected As Boolean
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		*
		Local loParam As Object
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColTables As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"

		Try
			* DAE 2009-11-06(17:35:50)
			*!*	loError = This.oError
			*!*	loError.TraceLogin = ""
			*!*	loError.Remark = ""
			loParam = CreateobjParam( "nRowsQuantity", 0, "EntityId", 0 )

			lllAlreadyConnected = .F.
			lcFilter = tcFilterCriteria

			lcFilter = Iif( Empty( lcFilter ), '', ' Where ' + lcFilter )

			lllAlreadyConnected = This.ConnectToBackend() = 0

			loColTables = This.oColTables
			If loColTables.Count > 0
				loTable = loColTables.Item[ 1 ]

				If Vartype( tnSQLOption ) # 'N'
					tnSQLOption = SQL_STAT_SELECTOR

				Else
					If Empty( tnSQLOption ) Or  ! Between( tnSQLOption, 1, 4 )
						tnSQLOption = SQL_STAT_SELECTOR

					Endif && Empty( tnSQLOption ) Or  ! Between( tnSQLOption, 1, 4 )

				Endif && Vartype( tnSQLOption ) # 'N'

				Do Case
					Case  tnSQLOption = SQL_STAT_DEFAULT
						lcSQLStat = loTable.SQLStat

					Case  tnSQLOption = SQL_STAT_SELECTOR
						lcSQLStat = loTable.SQLStatSelector

					Case  tnSQLOption = SQL_STAT_COMBO
						lcSQLStat = loTable.SQLStatCombo

					Case  tnSQLOption = SQL_STAT_KEYFINDER
						lcSQLStat = loTable.SQLStatKeyFinder

				Endcase

				lcPK = This.cMainCursorPK
				lcAux =  Strextract(  Upper(lcSQLStat ), "SELECT", "FROM", 1, 1  )
				lcSQLStatSelector = Strtran( lcSQLStat, lcAux, ' Count( * ) As Cnt ', 1, 1, 1 )

				* lcSelectCmd = lcSQLStatSelector + lcFilter
				lcSelectCmd = lcSQLStatSelector + ' ' + lcFilter

				This.BuildCursor( "cTemp", lcSelectCmd )

				loParam.nRowsQuantity = cTemp.Cnt

				If loParam.nRowsQuantity = 1
					* lcAux =  Strextract(  Upper( loTable.SQLStatSelector ), "SELECT", "FROM", 1, 1  )
					lcSQLStatSelector = Strtran( lcSQLStat, ' ' + lcAux + ' ',  ' ' + lcPK + ' ', 1, 1, 1 )
					lcSelectCmd = lcSQLStatSelector + ' ' + lcFilter

					This.BuildCursor( "cTemp", lcSelectCmd )
					Select Alias( "cTemp" )
					Locate
					loParam.EntityId = Evaluate( "cTemp." + This.cMainCursorPK )

				Endif && loParam.nRowsQuantity = 1

			Endif &&  loColTables.Count > 0

			lcRetVal = ObjectToXML( loParam )

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:35:24)
			*!*	loError = This.oError
			*!*	This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally

			If ! lllAlreadyConnected
				This.DisconnectFromBackend()

			Endif && ! lllAlreadyConnected

			If ! Empty( This.cXMLoError )
				lcRetVal = This.cXMLoError

			Endif && ! Empty( This.cXMLoError )

			* DAE 2009-10-22(12:26:36)
			* loParam = .F.
			loParam = Null

			loError = Null

			loColTables = Null

			Use In Select( "cTemp" )

		Endtry

		Return ( lcRetVal )

	Endproc && GetAllPaginatedCount

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: xxxGetAllPaginatedCount
	*!* Description...:
	*!* Date..........: Jueves 12 de Enero de 2006 (19:37:31)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*

	*!* Devuelve la cantidad de registros que cumplen con "tcFilterCriteria"
	*!* Se debe utilizar junto a GetAllPaginated para calcular la cantidad
	*!* de paginas a mostrar segun la cantidad de resultados a mostrar

	Procedure xxxGetAllPaginatedCount( tcFilterCriteria As String ) As String

		Local lcRetVal As String,;
			lcFilter As String,;
			lcSelectCmd As String,;
			lcPK As String,;
			lcOrderBy As String

		Local lllAlreadyConnected As Boolean
		Local loTable As oTable Of "ColTables.prg"

		Local loParam As Object
		Local loError As Object
		Try
			loError = This.oError
			loError.TraceLogin = ""
			loError.Remark = ""

			loParam = Createobject( "Empty" )
			AddProperty( loParam, "nRowsQuantity", 0 )
			AddProperty( loParam, "EntityId", 0 )

			lllAlreadyConnected = .F.
			lcFilter = tcFilterCriteria

			If This.lIsOk
				lcFilter = Iif( Empty( lcFilter ), '', ' Where ' + lcFilter )

				lcJoins = Iif( Empty( This.cGetAllJoins ), "", " " + Alltrim(This.cGetAllJoins) + " " )

				lllAlreadyConnected = This.ConnectToBackend() = 0

			Endif

			If This.lIsOk

				If This.oColTables.Count > 0
					loTable = This.oColTables.Item( 1 )

					lcPK      = IfEmpty( This.cGetAllView, loTable.Tabla) + '.' + loTable.PKName
					lcOrderBy = Iif( Empty( This.cGetAllPaginatedOrderBy ), " Order By " + lcPK, " Order By " + This.cGetAllPaginatedOrderBy )
					lcSelectCmd = 'Select ' + lcPK ;
						+ ' From ' + IfEmpty( This.cGetAllView, loTable.Tabla ) ;
						+ lcFilter ;
						+ lcOrderBy

					This.BuildCursor( "cTemp", lcSelectCmd )

					If This.lIsOk
						loParam.nRowsQuantity = Reccount( "cTemp" )

						If loParam.nRowsQuantity = 1
							Locate
							loParam.EntityId = Evaluate( "cTemp."+ This.cMainCursorPK )
						Endif

					Endif

				Endif

			Endif

			lcRetVal = ObjectToXML( loParam )

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError = This.oError.Process( oErr )

		Finally

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

			If !Empty( This.cXMLoError )
				lcRetVal = This.cXMLoError
			Endif

			* DAE 2009-10-22(12:26:36)
			* loParam = .F.
			loParam = Null

			loError = Null

		Endtry

		Return ( lcRetVal )

	Endproc && xxxGetAllPaginatedCount

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetRecCount
	*!* Description...:
	*!* Date..........: Lunes 2 de Febrero de 2009 (12:00:00)
	*!* Author........: Damian Eiff
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*

	*!* Devuelve la cantidad de registros que cumplen con "tcFilterCriteria"
	*!* de la tabla Principal de la entidad

	Procedure GetRecCount( tcFilterCriteria As String ) As Integer

		Local lcFilter As String
		Local lcSelectCmd As String
		Local lllAlreadyConnected As Boolean
		Local lnRetVal As Number
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try
			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			lnRetVal = 0
			lllAlreadyConnected = .F.
			lcFilter = tcFilterCriteria

			lcFilter = Iif( Empty( lcFilter ), '', ' Where ' + lcFilter )
			lllAlreadyConnected = This.ConnectToBackend() = 0

			lcSelectCmd = 'Select Count( * ) As cnt ' ;
				+ ' From ' + This.cMainTableName ;
				+ lcFilter

			This.BuildCursor( "cTemp", lcSelectCmd )
			lnRetVal = cTemp.Cnt


		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:34:18)
			* This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally

			If ! lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

			Use In Select( "cTemp" )

			loError = Null

		Endtry

		Return ( lnRetVal )


	Endproc
	*!*
	*!* END PROCEDURE GetRecCount
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddUpdatableFieldsData
	*!* Description...:
	*!* Date..........: Jueves 12 de Enero de 2006 (19:44:56)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -

	* Crea los datos para "UpdatableFieldList" y "UpdateNameList" ;
	en base al cursor del area actual o a una sentecia SELECT-SQL ;
	recibida como parámetro y lo guarda como un miembro más de la ;
	collección oColTables.

	Procedure AddUpdatableFieldsData( toTable As Object) As Boolean

		*!*			Local lcFields As String,;
		*!*				lcNames As String

		*!*			Local lnCurrentField As Integer

		*!*			Local laFields[1]

		*!*			Try

		*!*				This.oError.TraceLogin = ""
		*!*				This.oError.Remark = ""

		*!*				lcFields = ""
		*!*				lcNames = ""

		*!*				If Empty( toTable.SQLStat ) Or toTable.lGenericUpdatableFieldList
		*!*					* No se pasó un SELECT-SQL, se toma la estructura del cursor
		*!*					* del área actual

		*!*					For lnCurrentField = 1 To Afields( laFields )

		*!*						If IsIn( Upper( laFields[lnCurrentField,1] ), Upper( toTable.PKName) ) > 0 ;
		*!*								AND Not toTable.PKUpdatable
		*!*							* No incluyo la primary key en la lista de campos
		*!*							* actualizables
		*!*						Else
		*!*							lcFields = lcFields ;
		*!*								+ Iif( Empty( lcFields ), "", ", " ) ;
		*!*								+ laFields[lnCurrentField,1]
		*!*						Endif

		*!*						lcNames = lcNames ;
		*!*							+ Iif( Empty( lcNames ), "", ", " ) ;
		*!*							+ laFields[lnCurrentField,1] ;
		*!*							+ " " + toTable.Tabla ;
		*!*							+ "." + laFields[lnCurrentField,1]

		*!*					Next

		*!*				Else

		*!*					* Se pasó un SELECT-SQl, entonces "parseo" el string que contiene al
		*!*					* SELECT para obtener el nombre de los campos actualizables
		*!*					* (Todos menos la PrimaryKey)

		*!*					Local lnPosicSelect As Number,;
		*!*						lnPosicSelect As Number,;
		*!*						lnInicio As Number,;
		*!*						lnFin As Number

		*!*					Local lcCamposSQL As String, ;
		*!*						lcJustName As String,;
		*!*						lcCampo As String,;
		*!*						tcSQL As String

		*!*					tcSQL = toTable.SQLStat

		*!*					* Contemplo que el SELECT a parsear tenga DISTINCT al calcular
		*!*					* la posicion de inicio del parseo
		*!*					If 'DISTINCT' $ tcSQL
		*!*						lnPosicSelect = Atc( 'DISTINCT', tcSQL ) + 9
		*!*					Else
		*!*						lnPosicSelect = Atc( "SELECT", tcSQL ) + 7
		*!*					Endif

		*!*					* Contemplo que el SELECT a parsear tenga un CASE entre los
		*!*					* campos a extraer y allí detiene el parseo por lo que sería
		*!*					* necesario colocar los CASE (de ser necesarios) al final de
		*!*					* toda la lista de campos.

		*!*					lnPosicFrom = Iif(Atc("CASE", tcSQL ) = 0, Atc( "FROM", tcSQL ), Atc("CASE", tcSQL ))
		*!*					lcCamposSQL = Substr( tcSQL, lnPosicSelect, lnPosicFrom - lnPosicSelect )

		*!*					lnInicio = 1
		*!*					For lnCurrentField = 1 To Occurs( ",", lcCamposSQL ) + 1
		*!*						lnFin = Atc( ",", lcCamposSQL, lnCurrentField )
		*!*						* Hay n-1 cantidad de comas para n campos, entonces cuando
		*!*						* llego al ultimo campo el AT devuelve 0
		*!*						If lnFin = 0
		*!*							lnFin = Len( lcCamposSQL )
		*!*						Endif
		*!*						lcCampo = Alltrim( Substr( lcCamposSQL, lnInicio, lnFin - lnInicio ) )
		*!*						If tcTabla $ lcCampo And Atc( tcTabla, lcCampo ) < Atc( ".", lcCampo )
		*!*							lcJustName = Alltrim( Strtran( lcCampo, tcTabla + ".", "" ) )

		*!*							If IsIn( Upper( lcJustName ), Upper( toTable.PKName) ) > 0 ;
		*!*									AND Not toTable.PKUpdatable
		*!*								* No incluyo la primary key en la lista de campos
		*!*								* actualizables
		*!*							Else
		*!*								lcFields = lcFields ;
		*!*									+ Iif( Empty( lcFields ), "", ", " ) ;
		*!*									+ lcJustName
		*!*							Endif

		*!*							lcNames = lcNames ;
		*!*								+ Iif( Empty( lcNames ), "", ", " ) ;
		*!*								+ lcJustName + " " + lcCampo

		*!*						Endif
		*!*						lnInicio = lnFin + 1
		*!*					Endfor
		*!*				Endif

		*!*				toTable.UpdatableFieldList = lcFields

		*!*				toTable.UpdateNameList = lcNames

		*!*			Catch To oErr
		*!*				This.lIsOk = .F.
		*!*				This.cXMLoError=This.oError.Process( oErr )

		*!*			Finally

		*!*			Endtry

		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE AddUpdatableFieldsData
	*!*
	*!* ///////////////////////////////////////////////////////


	*--------------------------------------------------------------------------------------------
	* SOLO SE UTILIZA SI LOS ID SON AUTOINCREMENTALES
	* Cuando se hace un alta (New+Put) en una estructura cabecera-detalle, ;
	al grabar el registro en la tabla "cabecera", a este se le asigna un ;
	nuevo ID (autoincremental) el cual es necesario recuperar para luego ;
	volcarlo a la tabla "detalle" a modo de Foreign Key.
	*--------------------------------------------------------------------------------------------
	Protected Procedure GetNewID ( tcTable As String,;
			tcPKName As String ) As Integer

		Return This.oBackEnd.GetNewID( tcTable, tcPKName )

	Endproc


	*!*		*!* ///////////////////////////////////////////////////////
	*!*		*!* Procedure.....: BeforeTransactionBegins
	*!*		*!* Description...: Realiza todas las operaciones previas a la transacción
	*!*		*!* Date..........: Martes 25 de Abril de 2006 (13:09:18)
	*!*		*!* Author........: Ricardo Aidelman
	*!*		*!* Project.......: Visual Praxis Beta v. 1.1
	*!*		*!* -------------------------------------------------------
	*!*		*!* Modification Summary
	*!*		*!* R/0001  -
	*!*		*!*
	*!*		*!*

	*!*		Procedure BeforeTransactionBegins( txEntidad As Variant,;
	*!*				cDiffGram As String,;
	*!*				nLevel As Number,;
	*!*				lnProcessType As Integer,;
	*!*				lnFormId As Integer ) As Boolean;
	*!*				HELPSTRING "Realiza todas las operaciones previas a la transacción"

	*!*			Local lcIdEntidad As String,;
	*!*				lcFieldName As String,;
	*!*				lcRetVal As String

	*!*			Local loXA As prxXmlAdapter Of "Comun\Prg\prxXMLAdapter.prg"

	*!*			This.nEntidadId = txEntidad

	*!*			Try

	*!*				This.lAlreadyConnected = This.ConnectToBackend() = 0

	*!*				If This.lIsOk
	*!*					* Almacenará el ID de la IdEntidad contemplado la posibilidad ;
	*!*					* de que sea númerico o alfanumérico
	*!*					* This.IdEntidad = 0
	*!*					loXA = This.PopulateXMLAdapter( This.nEntidadId, nLevel )
	*!*				Endif

	*!*				If This.lIsOk
	*!*					loXA.LoadXML( cDiffGram )

	*!*					* Código de DEBUG
	*!*					If .F.
	*!*						Strtofile( cDiffGram, "C:\PutDiff.Xml" )
	*!*					Endif

	*!*					This.lIsOk = This.ApplyDiffgram( loXA, nLevel )
	*!*				Endif

	*!*			Catch To oErr
	*!*				This.lIsOk = .F.
	*!*				This.cXMLoError = This.oError.Process( oErr )

	*!*			Finally
	*!*				loXA = .F.

	*!*			Endtry

	*!*			Return This.lIsOk


	*!*		Endproc
	*!*		*!*
	*!*		*!* END PROCEDURE BeforeTransactionBegins
	*!*		*!*
	*!*		*!* ///////////////////////////////////////////////////////


	*!*		*!* ///////////////////////////////////////////////////////
	*!*		*!* Procedure.....: Put
	*!*		*!* Description...:
	*!*		*!* Date..........: Lunes 9 de Enero de 2006 (19:58:02)
	*!*		*!* Author........: Ricardo Aidelman
	*!*		*!* Project.......: Tier Adapter
	*!*		*!* -------------------------------------------------------
	*!*		*!* Modification Summary
	*!*		*!* R/0001  -
	*!*		*!*
	*!*		*!*
	*!*		* Hace persistentes los cambios efectuados por el usuario a
	*!*		* EL/LOS registros afectados en la entidad (Aplica un DiffGram)

	*!*		Procedure Put( txEntidad As Variant,;
	*!*				cDiffGram As String,;
	*!*				nLevel As Number ) As String



	*!*			Local lllAlreadyConnected As Boolean

	*!*			Local lcIdEntidad As String,;
	*!*				lcFieldName As String,;
	*!*				lcOldDeleted As String,;
	*!*				lcRetVal As String

	*!*			Local loXA As prxXmlAdapter Of "Comun\Prg\prxXMLAdapter.prg"

	*!*			This.nEntidadId = txEntidad

	*!*			Try

	*!*				lcOldDeleted = Set("Deleted")

	*!*				lllAlreadyConnected = This.ConnectToBackend() = 0

	*!*				If This.lIsOk
	*!*					* Almacenará el ID de la IdEntidad contemplado la posibilidad ;
	*!*					de que sea númerico o alfanumérico
	*!*					lcIdEntidad = ""
	*!*					lcFieldName = ""
	*!*					loXA = This.PopulateXMLAdapter( This.nEntidadId, nLevel )
	*!*				Endif

	*!*				If This.lIsOk
	*!*					loXA.LoadXML( cDiffGram )

	*!*					* Código de DEBUG
	*!*					If .F.
	*!*						Strtofile( cDiffGram, "C:\PutDiff.Xml" )
	*!*					Endif

	*!*					This.lIsOk = This.ApplyDiffgram( loXA, nLevel )
	*!*				Endif

	*!*				If This.lIsOk

	*!*					* Ahora si, abro la transacción y aplico, uno a uno, ;
	*!*					los TABLEUPDATE() correspondientes.
	*!*					This.TransactionBegin()

	*!*					This.lIsOk = This.Tableupdate( nLevel )

	*!*					If This.lIsOk
	*!*						This.TransactionEnd()
	*!*						llSuccess = .T.

	*!*					Else
	*!*						This.TransactionRollBack()

	*!*					Endif

	*!*				Endif

	*!*			Catch To oErr
	*!*				This.lIsOk = .F.
	*!*				This.cXMLoError = This.oError.Process( oErr )

	*!*			Finally

	*!*				loXA = .F.
	*!*				If Not lllAlreadyConnected
	*!*					This.DisconnectFromBackend()
	*!*				Endif

	*!*			Endtry

	*!*			Set Deleted &lcOldDeleted

	*!*			* Devuelve SIEMPRE los datos como han sido actualizados, ;
	*!*			con el/los nuevos IDs si fue un alta.

	*!*			If This.lIsOk
	*!*				* Ojo con los Bulk insert
	*!*				lcRetVal = This.GetOne( This.nEntidadId, nLevel )
	*!*			Else

	*!*				lcRetVal = This.SendData( nLevel )
	*!*			Endif

	*!*			Return ( lcRetVal )

	*!*		Endproc
	*!*		*!*
	*!*		*!* END PROCEDURE Put
	*!*		*!*
	*!*		*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: BeginTransaction
	*!* Description...: comienza la transacción
	*!* Date..........: Martes 25 de Abril de 2006 (13:54:39)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta v. 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure BeginTransaction( txEntidad As Variant,;
			cDiffGram As String,;
			nLevel As Number,;
			nTransactionID As Integer,;
			lnProcessType As Integer,;
			lnFormId As Integer ) As String;
			HELPSTRING "comienza la transacción"

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			This.nTransactionID = nTransactionID

			If This.lIsOk

				* Ahora si, abro la transacción y aplico, uno a uno, ;
				los TABLEUPDATE() correspondientes.
				This.TransactionBegin()

				This.lIsOk = This.Tableupdate( nLevel )

				If This.lIsOk
					This.TransactionEnd()
					llSuccess = .T.

				Else
					This.TransactionRollBack()

				Endif

			Endif

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:33:31)
			* This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally

			loXA = .F.
			If ! This.lAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry


		* Devuelve SIEMPRE los datos como han sido actualizados, ;
		con el/los nuevos IDs si fue un alta.

		If This.lIsOk
			* Ojo con los Bulk insert
			lcRetVal = This.GetOne( This.nEntidadId, nLevel )
		Else

			lcRetVal = This.SendData( nLevel )
		Endif

		Return ( lcRetVal )

	Endproc && BeginTransaction

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: PopulateXMLAdapter
	*!* Description...: Genera los Diffgrams
	*!* Date..........: Lunes 9 de Enero de 2006 (20:04:13)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	* Ahora recorro oColTables para generar los CursorAdapters
	* correspondientes para cada una de las tablas involucradas.
	* Lo hago fuera de la transacción porque necesito
	* CURSORSETPROP( "Buffering", 5 ) cuyo uso no está permitido dentro de
	* transacciones.
	* Acá podría invocar al método GetOne() pero este me da solo los cursores
	* y no los CursorAdapters correspondientes, los cuales necesito en la
	* actualización mediante sus propiedades UpdatableFieldList

	Procedure PopulateXMLAdapter( txIdEntidad As Variant,;
			tnLevel As Number ) As Boolean;
			HELPSTRING "Genera los Diffgrams "

		Local loXA As prxXmlAdapter Of "Comun\Prg\prxXMLAdapter.prg"
		Local loParam As Object
		Local lnOffSet As Integer
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			lnOffSet = 0

			loXA = Newobject( "prxXMLAdapter", "prxXMLAdapter.prg" )

			loParam = Createobject( "Empty" )
			AddProperty( loParam, "oXA", loXA )
			AddProperty( loParam, "nLevel", tnLevel )
			AddProperty( loParam, "nEntidadId", txIdEntidad )

			If This.oColTables.Count > 0
				loTable = This.oColTables.Item( 1 )
				lnOffSet = loTable.Nivel - 1
			Endif

			AddProperty(loParam, "nOffSet", lnOffSet )

			This.lIsOk = This.LookOverColTables( This.oColTables, ;
				"InternalPopulateXMLAdapter", loParam )

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:32:21)
			* This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			loParam = Null
			loError = Null

		Endtry

		Return loXA

	Endproc && PopulateXMLAdapter

	*
	* InternalPopulateXMLAdapter
	Protected Procedure InternalPopulateXMLAdapter( ;
			toTable As Object,;
			toParam As Object  ) As Boolean

		Local loMyCA As prxCursorAdapter Of "FW\Comunes\Prg\prxCursorAdapter.prg"


		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""



			If toTable.Nivel - toParam.nOffSet <= toParam.nLevel
				loMyCA = Newobject( "prxCursorAdapter",;
					"prxCursorAdapter.prg",;
					"",;
					THIS.cAccessType,;
					THIS.oConnection,;
					THIS.cBackEndEngine )

				With loMyCA
					.Tables = toTable.Tabla
					.Alias = toTable.CursorName
				Endwith

				If This.lSerialize

					* Inicio de la generación de la UpdatableFieldList y
					* UpdateNameList para cada uno de los cursores de la colección
					* oColTables. Los valores obtenido serán agregados a dicha
					* colección - Ver método AddUpdatableFieldsData()

					Do Case
							***Case !Empty(This.cGetAllFields)
							* cGetAllFields solo se utiliza para consultas, no para actualizaciones
						Case .F.
							With loMyCA
								.SelectCmd = "SELECT " + This.cGetAllFields + " FROM " + toTable.Tabla + " WHERE 1 = 0"
								This.lIsOk = .CursorFill()
								.CursorDetach()
							Endwith
							If This.lIsOk
								Select ( toTable.CursorName )
								This.AddUpdatableFieldsData( toTable )
								Use
							Endif

						Case Empty( toTable.SQLStat ) Or toTable.lGenericUpdatableFieldList

							With loMyCA As CursorAdapter
								* DAE 2009-07-15(12:28:24)
								.SelectCmd = "SELECT * FROM " + toTable.Tabla + " WHERE 1 = 0"
								.Tables = toTable.Tabla
								*!*	If This.lHasDefault
								*!*		.SelectCmd = "Select *, Default Selected, 99999 _RecordOrder " ;
								*!*			+ " From " + toTable.Tabla + " WHERE 1 = 0"

								*!*	Else && This.lHasDefault
								*!*		.SelectCmd = "Select *, 99999 _RecordOrder " ;
								*!*			+ " From " + toTable.Tabla + " WHERE 1 = 0"

								*!*	Endif && This.lHasDefault

								This.lIsOk = .CursorFill()
								.CursorDetach()
							Endwith
							If This.lIsOk
								Select ( toTable.CursorName )
								This.AddUpdatableFieldsData( toTable )
								Use

							Endif

						Otherwise
							This.AddUpdatableFieldsData( toTable )

					Endcase
				Endif
				* Fin de la generación de la UpdatableFieldList y UpdateNameList


				If This.lIsOk
					This.lIsOk = This.GetOriginalCursor( toParam,;
						loMyCA,;
						toParam.oXA,;
						toTable )

				Endif

			Endif


		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally
			loMyCA = Null
		Endtry

		Return This.lIsOk

	Endproc


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetOriginalCursor
	*!* Description...: Trae el cursor original, para poder alpicarle el Diffgram
	*!* Date..........: Martes 10 de Enero de 2006 (15:16:18)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetOriginalCursor( toParam As Object,;
			toMyCA As CursorAdapter,;
			toXA As Xmladapter,;
			toTable As oTable Of "Comun\Prg\ColTables.prg" ) As Boolean;
			HELPSTRING "Trae el cursor original, para poder alpicarle el Diffgram"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			*!*	Como los DiffGrams pueden ser generados en base a cursores
			*!*	resultantes de un JOIN de tablas, para que no de error el
			*!*	método ApplyDiffGram() debo regenerar los cursores
			*!*	exactamente igual a como los había generado el método
			*!*	GetOne() o GetAll(), que no puedo invocar desde aquí ya que debo
			*!*	utilizar las propiedades KeyFieldList, UpdatableFieldList y
			*!*	UpdateNameList.

			If This.lSerialize

				With toMyCA As prxCursorAdapter Of "Comun\Prg\prxCursorAdapter.prg"

					Do Case
						Case .F. && Empty(lxIdEntidad)
							.SelectCmd = toTable.LastSQL

						Otherwise
							If Empty( toTable.SQLStat )
								* .SelectCmd = "SELECT * FROM " + .Tables

								If This.lHasDefault
									.SelectCmd =  "Select *, Default Selected, 99999 _RecordOrder " ;
										+ " From " + .Tables

								Else && This.lHasDefault
									.SelectCmd = "Select *, 0 Selected, 99999 _RecordOrder " ;
										+ " From " + .Tables

								Endif && This.lHasDefault

							Else
								.SelectCmd = toTable.SQLStat

							Endif

							*!* lcIdEntidad = Iif( Type( 'lxIdEntidad' ) = 'C', "'", "" ) + Alltrim(Transform( lxIdEntidad )) + Iif( Type( 'lxIdEntidad' ) = 'C', "'", "" )
							lcIdEntidad = Any2Char( toParam.nEntidadId, "'" )

							Do Case
								Case toTable.Nivel - toParam.nOffSet = 1
									lcFieldName = toTable.PKName

								Case toTable.Nivel - toParam.nOffSet = 2
									lcFieldName = toTable.ForeignKey

								Otherwise
									lcFieldName = toTable.MainId

							Endcase

							.SelectCmd = .SelectCmd + " Where " + .Tables + "." + lcFieldName + " = " + lcIdEntidad

							If This.lHasDefault
								.SelectCmd = .SelectCmd + " Or " + .Tables + ".Default = 1"

							Endif && This.lHasDefault

					Endcase

					.KeyFieldList = toTable.PKName
					.UpdatableFieldList = toTable.UpdatableFieldList
					.UpdateNameList = toTable.UpdateNameList


					* Código de DEBUG
					If .F.
						Strtofile( Alltrim( toTable.CursorName + Chr( 13 ) + Chr( 10 ) ), "C:\Log.err", 1 )
						Strtofile( Alltrim( .KeyFieldList + Chr( 13 ) + Chr( 10 ) ), "C:\Log.err", 1 )
						Strtofile( Alltrim( .UpdatableFieldList + Chr( 13 ) + Chr( 10 ) ), "C:\Log.err", 1 )
						Strtofile( Alltrim( .UpdateNameList + Chr( 13 ) + Chr( 10 ) + Chr( 13 ) + Chr( 10 ) ), "C:\Log.err", 1 )

					Endif && .F.

					This.lIsOk = .CursorFill()
					***.CursorDetach()

				Endwith

				This.cXMLoError = toMyCA.cXMLoError

				If This.lIsOk
					toTable.oCursorAdapter = Null
					toTable.oCursorAdapter = toMyCA

					* Turn table buffering on and make some changes
					CursorSetProp( "Buffering", 5 )

					toXA.AddTableSchema( toTable.CursorName )

				Endif && This.lIsOk

			Else

				If Vartype( toTable.oCursorAdapter ) == "O"
					If Lower( toTable.oCursorAdapter.BaseClass ) = Lower( toMyCA.BaseClass )
						toTable.oCursorAdapter.CursorDetach()
					Endif

					toTable.oCursorAdapter = Null
				Endif

				toMyCA.KeyFieldList = toTable.PKName
				toMyCA.UpdatableFieldList = toTable.UpdatableFieldList
				toMyCA.UpdateNameList = toTable.UpdateNameList

				toMyCA.CursorAttach( toTable.CursorName, .T. )

				toTable.oCursorAdapter = toMyCA

				* DAE 2009-10-06(16:31:52)
				* toXA.AddTableSchema( toTable.CursorName )

			Endif


		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:31:06)
			* This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			loError = Null

		Endtry

		Return This.lIsOk

	Endproc && GetOriginalCursor

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ApplyDiffgram
	*!* Description...: Recorre la colección aplicando los Diffgram
	*!* Date..........: Martes 10 de Enero de 2006 (12:26:04)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ApplyDiffgram( loXA As prxXmlAdapter Of "Comun\Prg\prxXMLAdapter.prg",;
			nLevel As Number ) As Boolean;
			HELPSTRING "Recorre la colección aplicando los Diffgram"

		Local loParam As Object
		Local loCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local i As Integer
		Local lnOffSet As Integer
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			lnOffSet = 0

			loCol = Newobject( "PrxCollection", "PrxBaseLibrary.prg" )
			For i = 1 To loXA.Tables.Count
				loCol.AddItem( i, Lower( loXA.Tables( i ).Alias ))
			Endfor

			loParam = Createobject("Empty")
			AddProperty(loParam, "oXA", loXA )
			AddProperty(loParam, "nLevel", nLevel )
			AddProperty(loParam, "oCol", loCol )

			If This.oColTables.Count > 0
				loTable = This.oColTables.Item( 1 )
				lnOffSet = loTable.Nivel - 1
			Endif

			AddProperty(loParam, "nOffSet", lnOffSet )

			This.LookOverColTables( This.oColTables,  "InternalApplyDiffgram", loParam)

			*!*	loParam = Null
			*!*	loCol = Null

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(20:23:44)
			*!*	This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )


		Finally
			loError = Null
			loParam = Null
			loCol = Null
		Endtry

		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE ApplyDiffgram
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: InternalApplyDiffgram
	*!* Description...: Recorre la colección aplicando los Diffgram
	*!* Date..........: Martes 10 de Enero de 2006 (12:26:04)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure InternalApplyDiffgram( toTable As oTable Of "Comun\Prg\ColTables.prg",;
			toParam As Object ) As Boolean;
			HELPSTRING "Es llamado por el método LookOverColTables, una vez para cada tabla"

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			If toTable.Nivel - toParam.nOffSet <= toParam.nLevel


				* Seteo los campos clave del cursor para evitar el ;
				error Nº 18 - Line too long al hacer el AppyDiffGram con ;
				cursores de más de 50 campos.
				For Each oField As Xmlfield In toParam.oXA.Tables( toParam.oCol.Item( Lower( toTable.CursorName ) )).Fields
					If IsIn( Upper( Alltrim( oField.Alias ) ), Upper( Alltrim( toTable.PKName ) ) ) > 0
						oField.KeyField = .T.
					Endif
				Endfor

				Select ( toTable.CursorName )
				toParam.oXA.Tables( toParam.oCol.Item( Lower( toTable.CursorName ) )).ApplyDiffgram()
			Endif

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(20:16:42)
			*!*	This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally

			loError = Null

		Endtry

		Return This.lIsOk

	Endproc  && InternalApplyDiffgram

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: TableUpdate
	*!* Description...: Recorro la colección aplicando los TableUpdate()
	*!* Date..........: Martes 10 de Enero de 2006 (12:41:04)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Tableupdate() As Boolean;
			HELPSTRING "Recorro la colección aplicando los TableUpdate()"

		Local loParam As Object
		Local lnOffSet As Integer
		Local i As Integer
		Local lcTable As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try


			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			lnOffSet = 0

			* El orden de las tablas según nivel debe ser descendente para ;
			DELETE para cumplir posibles reglas de integridad ;
			referencial.

			If This.oColTables.Count > 0
				loTable = This.oColTables.Item( 1 )
				lnOffSet = loTable.Nivel - 1
			Endif

			loParam = Createobject("Empty")
			AddProperty(loParam, "nOffSet", lnOffSet )
			AddProperty(loParam, "nLevel", This.nLevel )

			If This.lIsOk
				This.LookOverColTables( This.oColTables, "InternalTableDelete", loParam, .T. )
			Endif

			* Lo contrario aplica para INSERT y UPDATE, por eso se procesan ;
			los registros deleteados por separado.

			This.lIsOk = This.LookOverColTables( This.oColTables, "InternalTableInsertAndUpdate", loParam )

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(20:15:21)
			*!*	This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			loParam = Null
			loError = Null

			* DAE 2009-10-02(13:48:06)
			*!*	Try
			*!*		For i = 1 To Aused( lAUsed )
			*!*			lcTable = Upper( lAUsed[ i, 1 ] )
			*!*			If Left( lcTable, 5 ) = 'TEMP_'
			*!*				Use In Select( lcTable )
			*!*			Endif && Left( lcTable ), 5 ) = 'TEMP_'
			*!*		Endfor
			*!*	Catch To oErr
			*!*	Finally
			*!*	Endtry

		Endtry

		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE TableUpdate
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: InternalTableInsertAndUpdate
	*!* Description...: Actualiza los INSERT y los UPDATE realizados a la tabla
	*!* Date..........: Jueves 9 de Febrero de 2006 (13:55:41)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure InternalTableInsertAndUpdate( ;
			toTable As Object,;
			toParam As Object ) As Boolean;
			HELPSTRING "Actualiza los INSERT y los UPDATE realizados a la tabla"

		Local lnUpperLevelID As Integer
		Local lnOldIdValue As Integer
		Local lnNewIdValue As Integer
		Local lcPKName As String
		Local lcOldDeleted As String
		Local llNewId As Boolean
		Local lcAlias As String
		Local loError As Object
		Local laFields[1]
		Local i As Integer
		Local lnLen As Integer
		Local lnRecno As Integer
		Local lcCommand As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			lcAlias = Alias()

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			*!*	loError = This.oError
			*!*	loError.TraceLogin = ""
			*!*	loError.Remark = ""

			* Hago invisible los registros deleteados, que serán procesados ;
			por separado.

			lcOldDeleted = Set("Deleted")

			Set Deleted On

			If toTable.Nivel - toParam.nOffSet <= toParam.nLevel
				Select ( toTable.CursorName )

				*!*	Update ( toTable.CursorName ) ;
				*!*		SET ;
				*!*		TS = Datetime(),;
				*!*		TransactionID = This.nTransactionID

				* DAE 2009-09-29(15:59:26)
				TEXT To lcCommand NoShow TextMerge Pretext 15
					Replace All
						TS With Datetime(),
						TransactionID With <<This.nTransactionID>>
						In <<toTable.CursorName>>

				ENDTEXT
				loError.TraceLogin = "Ejecutando el comando: " + lcCommand

				&lcCommand

				Locate

				If ! This.oBackEnd.lAcceptEmptyDate
					* SQL no acepta fechas vacias, sino Null

					lnLen = Afields( laFields, toTable.CursorName )
					* @TODO Damian Eiff 2009-07-28 (13:14:09)
					* Utilizar un Update  SQL para optimizar la performance
					Scan
						For i = 1 To lnLen
							Do Case
								Case laFields[ i, 2 ] = "D"
									If Empty( Evaluate( laFields[ i, 1 ] ))
										Replace ( laFields[ i, 1 ] ) With Null

									Endif && Empty( Evaluate( laFields[ i, 1 ] ) )

								Case laFields[ i, 2 ] = "T"
									If Empty( Evaluate( laFields[ i, 1 ]))
										Replace ( laFields[ i, 1 ] ) With Null

									Endif && Empty( Evaluate( laFields[ i, 1 ] ) )

							Endcase
						Endfor
					Endscan

					Locate

				Endif

				lcPKName = toTable.CursorName + "." + toTable.PKName
				If toTable.PKUpdatable
					* Si la PK es definida por el usuario (no utiliza IDs ;
					"AutoInc"), actualizo todos los registros de una sola ;
					vez.
					This.lIsOk = This.PerformUpdate( .T. )

				Else

					* DAE 2009-07-28(13:15:02)
					* lnRecCoun = Reccount()
					lnRecCoun = Reccount( toTable.CursorName )
					Locate

					Scan While This.lIsOk

						*!* Wait Window Alias() + " - Grabando Asiento " + Transform( Recno() ) + "/" + Transform( lnRecCoun ) + "...." Nowait

						llNewId = .F.

						If This.Modified()
							* Retengo el valor del ID que viene en el cursor.
							lnOldIdValue = Evaluate( lcPKName )
							* Actualizo el registro actual.

							This.lIsOk = This.PerformUpdate( .F. )
							If This.lIsOk
								* Si el viejo ID es <= 0 es un alta, entonces ;
								averiguo el nuevo ID, caso contrario es una ;
								modificación, no hay cambio de ID.

								lnNewIdValue = Iif( lnOldIdValue <= 0, ;
									THIS.GetNewID( toTable.Tabla, toTable.PKName ), ;
									lnOldIdValue )
								***If lnNewIdValue # lnOldIdValue	&& Es un nuevo ID
								* Lo reflejo en la tabla "actual".

								* Verifico siempre que los registros de la tablas hijas
								* tengan el mismo ID que la tabla padre
								* Antes, solo lo reflejaba cuando cuando era un INSERT
								* Ahora lo refleja cuando es un UPDATE

								If lnNewIdValue # lnOldIdValue	&& Es un nuevo ID
									Replace &lcPKName With lnNewIdValue
									llNewId = .T.

								Endif && lnNewIdValue # lnOldIdValue

								If llNewId

									If toTable.lIsHierarchical

										lnRecno = Recno()

										* Actualiza la tabla jerarquica
										This.UpdateTree( toTable, lnNewIdValue, lnOldIdValue )

										If ! Empty( lnRecno )
											Goto lnRecno

										Endif && ! Empty( lnRecno )

									Endif && toTable.lIsHierarchical

									If toTable.Nivel - toParam.nOffSet = 1

										This.nEntidadId = lnNewIdValue

										* Para nivel 1 actualizo toda la colección de tablas
										This.UpdateFamily( toTable.oColTables, lnNewIdValue, lnOldIdValue, toParam.nLevel )

									Else
										* Para nivel 2 o superior actualizo solo las tablas "hijas" (si las tuviere).
										This.UpdateChildren( toTable.oColTables, toTable.CursorName, lnNewIdValue, lnOldIdValue, toParam.nLevel )

									Endif && toTable.Nivel = 1

								Endif

							Endif

						Endif

					Endscan

				Endif

			Endif

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:29:54)
			* This.cXMLoError = This.oError.Process( oErr )
			If Vartype( loError ) # 'O'
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			Endif
			This.cXMLoError = loError.Process( oErr )

		Finally
			Set Deleted &lcOldDeleted

			* DAE 2009-11-06(17:28:40)
			*!*	loError = This.oError
			*!*	loError.TraceLogin = ""
			*!*	loError.Remark = ""
			loError = Null

			If Used( lcAlias )
				Select Alias( lcAlias )

			Endif && Used( lcAlias )

		Endtry

		Return This.lIsOk

	Endproc && InternalTableInsertAndUpdate

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: InternalTableDelete
	*!* Description...: Actualiza los DELETE realizados a la tabla
	*!* Date..........: Jueves 9 de Febrero de 2006 (13:55:41)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure InternalTableDelete( ;
			toTable As oTable Of "Comun\Prg\ColTables.prg",;
			toParam As Object  ) As Boolean;
			HELPSTRING "Actualiza los DELETE realizados a la tabla"

		Local lcOldDeleted As String
		Local lcAlias As String
		Local loError As Object
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	loError = This.oError
			*!*	loError.TraceLogin = ""
			*!*	loError.Remark = ""

			lcAlias = Alias()

			* Hago visible los registros deleteados para poder aplicarles el ;
			* TableUpdate( .F. )

			lcOldDeleted = Set( "Deleted" )

			Set Deleted Off

			If toTable.Nivel - toParam.nOffSet <= toParam.nLevel
				Select ( toTable.CursorName )
				Locate

				Scan For Deleted( toTable.CursorName ) While This.lIsOk
					This.lIsOk = This.PerformUpdate( .F. )

				Endscan

			Endif && toTable.Nivel <= nLevel

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:27:47)
			* This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			* DAE 2009-11-06(17:27:56)
			*!*	loError = This.oError
			*!*	loError.TraceLogin = ""
			*!*	loError.Remark = ""
			loError = Null
			Set Deleted &lcOldDeleted

			If Used( lcAlias )
				Select Alias( lcAlias )

			Endif && Used( lcAlias )

		Endtry

		Return This.lIsOk

	Endproc && InternalTableDelete

	*
	* PerformUpdate
	Protected Procedure PerformUpdate( tlAllRows As Boolean ) As Boolean
		Private pcXMLError As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			* Esta variable privada captura la información de los errores que se
			* puedan producir en los store procedures de una base NATIVA

			pcXMLError = ""

			If !Tableupdate( tlAllRows, .T. )
				This.lIsOk = .F.
				If Empty( pcXMLError )
					* DAE 2009-11-06(17:25:53)
					* This.cXMLoError = This.oError.Process()  && Procesa el último error producido
					loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					This.cXMLoError = loError.Process()


				Else
					This.cXMLoError = pcXMLError

				Endif
			Endif


		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:26:55)
			* This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally

		Endtry

		Return This.lIsOk

	Endproc && PerformUpdate

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: UpdateFamily
	*!* Description...:
	*!* Date..........: Jueves 9 de Febrero de 2006 (16:16:08)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!* Actualiza el nuevo ID de un registro de una tabla de nivel = 1 en ;
	toda su descendencia (hijos, nietos, etc.)


	Protected Procedure UpdateFamily( toTable As Object,;
			tnNewID As Integer, ;
			tnOldID As Integer, ;
			tnLevel As Integer ) As Boolean

		Local loParam As Object
		Local lnOffSet As Integer
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			lnOffSet = 0

			loParam = Createobject("Empty")
			AddProperty(loParam, "nNewID", tnNewID )
			AddProperty(loParam, "nOldID", tnOldID )
			AddProperty(loParam, "nLevel", tnLevel )

			If This.oColTables.Count > 0
				loTable = This.oColTables.Item( 1 )
				lnOffSet = loTable.Nivel - 1
			Endif

			AddProperty(loParam, "nOffSet", lnOffSet )

			This.LookOverColTables( toTable, "InternalUpdateFamily", loParam )

		Catch To oErr
			This.lIsOk = .F.
			*!*	This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			loError = Null
			loParam = Null

		Endtry

		Return This.lIsOk

	Endproc && UpdateFamily

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: InternalUpdateFamily
	*!* Description...:
	*!* Date..........: Jueves 9 de Febrero de 2006 (16:16:08)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!* Actualiza el nuevo ID de un registro de una tabla de nivel = 1 en ;
	toda su descendencia (hijos, nietos, etc.)


	Protected Procedure InternalUpdateFamily( ;
			toTable As Object,;
			toParam As Object  ) As Boolean

		Local lcCursor As String
		Local lcField As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			If Between( toTable.Nivel - toParam.nOffSet, 2, toParam.nLevel )
				lcCursor = toTable.CursorName
				If toTable.Nivel - toParam.nOffSet = 2
					* En el nivel 2 se puede referenciar al padre mediante ;
					"ForeignKey" o "MainId" ya que serían iguales.
					lcField = IfEmpty( toTable.MainId, toTable.ForeignKey )

				Else
					lcField = toTable.MainId

				Endif


				Text To lcCommand NoShow TextMerge Pretext 15
				Replace In <<lcCursor>>
					<<lcField>> With <<toParam.nNewID>>
					FOR <<lcCursor>>.<<lcField>> = <<toParam.nOldID>>
				EndText

				&lcCommand

*!*					Replace In &lcCursor ;
*!*						&lcField With toParam.nNewID ;
*!*						FOR &lcField = toParam.nOldID

			Endif

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(20:13:31)
			*!*	This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.TraceLogin = "Comando Ejecutado:" 
			loError.Remark = lcCommand
			This.cXMLoError = loError.Process( oErr )
			

		Finally
			loError = Null

		Endtry

		Return This.lIsOk

	Endproc  && InternalUpdateFamily

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: UpdateChildren
	*!* Description...:
	*!* Date..........: Jueves 9 de Febrero de 2006 (16:39:50)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!* Actualiza el nuevo ID de un registro de una tabla de nivel > 1 ;
	en sus tablas hijas.

	Protected Procedure UpdateChildren( toTable As Object,;
			tcTableName As String, ;
			tnNewID As Integer, ;
			tnOldID As Integer, ;
			tnLevel As Integer ) As Boolean

		Local loParam As Object
		Local lnOffSet As Integer
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			lnOffSet = 0

			loParam = Createobject("Empty")
			AddProperty(loParam, "nNewID", tnNewID )
			AddProperty(loParam, "nOldID", tnOldID )
			AddProperty(loParam, "nLevel", tnLevel )
			AddProperty(loParam, "cTableName", tcTableName )

			If This.oColTables.Count > 0
				loTable = This.oColTables.Item( 1 )
				lnOffSet = loTable.Nivel - 1

			Endif

			AddProperty(loParam, "nOffSet", lnOffSet )

			This.LookOverColTables( toTable,  "InternalUpdateChildren", loParam)



		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(20:12:10)
			*!*	This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			loError = Null
			loParam = Null

		Endtry

		Return This.lIsOk
	Endproc && UpdateChildren

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: InternalUpdateChildren
	*!* Description...:
	*!* Date..........: Jueves 9 de Febrero de 2006 (16:16:08)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!* Actualiza el nuevo ID de un registro de una tabla de nivel > 1 ;
	en sus tablas hijas.


	Protected Procedure InternalUpdateChildren( ;
			toTable As oTable Of "Comun\Prg\ColTables.prg",;
			toParam As Object  ) As Boolean

		Local lcCursor As String
		Local lcField As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			If toTable.Nivel - toParam.nOffSet <= toParam.nLevel

				*!* And Lower(toTable.Padre) == Lower(toParam.cTableName)

				lcCursor = toTable.CursorName
				lcField = toTable.ForeignKey

				Replace In &lcCursor ;
					&lcField With toParam.nNewID ;
					FOR &lcField = toParam.nOldID

			Endif

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(20:11:05)
			*!*	This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally

		Endtry

		Return This.lIsOk

	Endproc && InternalUpdateChildren

	*
	* Actualiza una tabla jerárquica
	Procedure UpdateTree( toTable,;
			tnNewIdValue,;
			tnOldIdValue  ) As Void;
			HELPSTRING "Actualiza una tabla jerárquica"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Actualiza una tabla jerárquica
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Jueves 23 de Julio de 2009 (11:21:39)
			*:ModiSummary:
			*:Syntax:
			*:Example:
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

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			lcCursor = toTable.CursorName
			lcField = "Parent" + toTable.PKName

			Replace In &lcCursor ;
				&lcField With tnNewIdValue ;
				FOR &lcField = tnOldIdValue

		Catch To oErr
			* DAE 2009-11-06(20:10:40)
			*!*	If This.lIsOk
			*!*		This.lIsOk = .F.
			*!*		This.cXMLoError=This.oError.Process( oErr )
			*!*	ENDIF

			This.lIsOk = .F.
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			* DAE 2009-11-06(20:10:38)
			*!*	If !This.lIsOk
			*!*		Throw This.oError
			*!*	Endif
			loError = Null
		Endtry

	Endproc && UpdateTree

	Procedure GlobalTransactionBegin
		If This.ConnectToBackend() = 0
			This.lAlreadyConnected = .T.
		Endif

		*!*			Local lcStr As String
		*!*			lcStr = This.Name + " - GlobalTransactionBegin()" + Chr(13) + Chr(10)

		*!*			Strtofile( lcStr, "Transacciones.txt", 1 )

		This.TransactionBegin()
	Endproc

	Procedure GlobalTransactionEnd
		*!*			Local lcStr As String
		*!*			lcStr = This.Name + " - GlobalTransactionEnd()" + Chr(13) + Chr(10)

		*!*			Strtofile( lcStr, "Transacciones.txt", 1 )

		This.TransactionEnd()
		If !This.lAlreadyConnected
			This.DisconnectFromBackend()
		Endif
	Endproc

	Procedure GlobalTransactionRollback
		*!*			Local lcStr As String
		*!*			lcStr = This.Name + " - GlobalTransactionRollBack()" + Chr(13) + Chr(10)

		*!*			Strtofile( lcStr, "Transacciones.txt", 1 )

		This.TransactionRollBack()
		If !This.lAlreadyConnected
			This.DisconnectFromBackend()
		Endif
	Endproc

	*---------------------------------------------------------------------------------------------

	Protected Procedure Modified
		Local lcModifCtrl As String, llRetVal As Boolean
		lcModifCtrl = Replicate( "1", Fcount() + 1 )
		Do Case
			Case Recno() < 0 And Deleted()  		&& Agregado y Borrado.
				llRetVal = .F.

			Case lcModifCtrl == Getfldstate( -1 )	&& No modificado.
				llRetVal = .F.

			Otherwise
				llRetVal = .T.

		Endcase
		Return llRetVal
	Endproc

	*---------------------------------------------------------------------------------------------

	*
	* BuildCursor
	Procedure BuildCursor( tcCursorName As String, ;
			tcSelectCmd As String ) As Boolean
		Local lcAlias As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loMyCA As prxCursorAdapter Of "Comunes\Prg\prxCursorAdapter.prg"

		Try
			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			lcAlias = Sys(2015)

			loMyCA = Newobject( "prxCursorAdapter", "prxCursorAdapter.prg", "", This.cAccessType, This.oConnection, This.cBackEndEngine )

			If This.lSerialize
				lcAlias = tcCursorName

			Endif

			With loMyCA As CursorAdapter
				.Alias = lcAlias
				.SelectCmd = tcSelectCmd
				This.lIsOk = .CursorFill()
				.CursorDetach()
			Endwith

			This.lIsOk = Empty( loMyCA.cXMLoError )

			If This.lIsOk And !This.lSerialize
				Select * From (lcAlias) Into Cursor (tcCursorName) Readwrite
				Use In Select( lcAlias )
			Endif


		Catch To oErr
			* DAE 2009-11-06(20:08:59)
			*!*	If This.lIsOk
			*!*		This.lIsOk = .F.
			*!*		This.cXMLoError=This.oError.Process( oErr )
			*!*
			*!*	ENDIF

			This.lIsOk = .F.
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			If ! This.lIsOk And Empty( This.cXMLoError )
				*!* StrToFile( loMyCA.SelectCmd, "__ERROR__CursorFill.prg", 1 )
				* DAE 2009-11-06(17:24:18)
				* This.cXMLoError = This.oError.Process( loMyCA.cXMLoError )
				If Vartype( loError ) # 'O'
					loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				Endif
				This.cXMLoError = loError.Process( loMyCA.cXMLoError )
				Throw loError

			Endif && ! This.lIsOk And Empty( This.cXMLoError )

			loMyCA = Null
			* DAE 2009-11-06(17:24:24)
			*!*	If !This.lIsOk
			*!*		Throw This.oError

			*!*	Endif
			loError = Null

		Endtry

		Return This.lIsOk

	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: PopulateTablesByUser
	*!* Description...: Permite al usuario llenar la colección Tables
	*!* Date..........: Viernes 27 de Enero de 2006 (12:53:23)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure PopulateTablesByUser(  ) As Boolean;
			HELPSTRING "Permite al usuario llenar la colección Tables"

		*!*	Local loError As prxErrorHandler Of "FW\ErrorHandler\prxErrorHandler.prg"
		*!*	Try

		*!*		*!*	This.oError.TraceLogin = ""
		*!*		*!*	This.oError.Remark = ""

		*!*		* Para ser llenado en cada implementación, terminando con el DoDefault()

		*!*		***This.lIsOk = This.oColTables.Validate()

		*!*	Catch To oErr
		*!*		This.lIsOk = .F.
		*!*		* DAE 2009-11-06(20:07:33)
		*!*		*!*	This.cXMLoError=This.oError.Process( oErr )
		*!*		loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
		*!*		This.cXMLoError = loError.Process( oErr )

		*!*	Finally

		*!*		loError = Null

		*!*	Endtry

		Return This.lIsOk
	Endproc  &&  PopulateTablesByUser

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: cGetAllOrderBy_Access
	*!* Description...: Nombre del cursor principal
	*!* Date..........: Lunes 24 de Abril de 2006 (16:21:23)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure cGetAllOrderBy_Access(  ) As Void;
			HELPSTRING "Clausula ORDER BY"

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			If Empty ( This.cGetAllOrderBy )
				This.cGetAllOrderBy = This.GetOrderBy()
			Endif

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(20:06:49)
			*!*	This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally

		Endtry

		Return This.cGetAllOrderBy

	Endproc && cGetAllOrderBy_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: cGetAllPaginatedOrderBy_access
	*!* Description...: Clausula Order By
	*!* Date..........: Jueves 8 de Enero de 2009 (12:17:41)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure cGetAllPaginatedOrderBy_Access(  ) As String;
			HELPSTRING "Clausula ORDER BY"

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			If Empty ( This.cGetAllPaginatedOrderBy )
				This.cGetAllPaginatedOrderBy = This.cGetAllOrderBy

			Endif

		Catch To oErr
			This.lIsOk = .F.
			*!*	This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally

		Endtry

		Return This.cGetAllPaginatedOrderBy

	Endproc && cGetAllPaginatedOrderBy_access



	*!* ///////////////////////////////////////////////////////
	*!* Function......: GetOrderBy
	*!* Description...: Devuelve la clausula ORDER BY desde la colección tables
	*!* Date..........: Lunes 24 de Abril de 2006 (16:01:37)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function GetOrderBy(  ) As String;
			HELPSTRING "Devuelve el nombre del cursor principal desde la colección tables"

		Local lcGetOrderBy As String
		Local loTable As oTable Of "v:\Praxis\Comun\Prg\ColTables.prg"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			lcGetOrderBy = ""

			For Each loTable In This.oColTables
				If !loTable.Auxiliary
					lcGetOrderBy = loTable.OrderBy
					Exit
				Endif
			Endfor

		Catch To oErr
			This.lIsOk = .F.
			*!*	This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally
			loError = Null

		Endtry

		Return lcGetOrderBy

	Endfunc &&  GetOrderBy

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: PackMainTable
	*!* Description...: Ejecuta un Pack sobre la tabla principal
	*!* Date..........: Lunes 27 de Noviembre de 2006 (14:24:44)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure PackMainTable() As String;
			HELPSTRING "Ejecuta un Pack sobre la tabla principal"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lcXML As String,;
			lcTableName As String

		Local lllAlreadyConnected As Boolean

		Try
			* DAE 2009-11-06(17:22:48)
			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			lcXML = ""
			lcTableName = ""

			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk
				lcTableName = This.cMainTableName
				Use ( lcTableName ) In 0 Exclusive

				Pack
				Pack Memo

			Endif

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(17:22:24)
			* This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			lcXML = This.cXMLoError

		Finally
			*!*	If Used( lcTableName )
			*!*		Use In Alias( lcTableName )
			*!*	Endif
			Use In Select( lcTableName )

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

		Return lcXML

	Endproc && PackMainTable

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SynchronizeTables
	*!* Description...: Sincroniza las tablas existentes con la definición en el componente
	*!* Date..........: Lunes 27 de Noviembre de 2006 (19:44:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure SynchronizeTables(  ) As String;
			HELPSTRING "Sincroniza las tablas existentes con la definición en el componente"

		Local lcXML As String,;
			lcTableName As String

		Local lllAlreadyConnected As Boolean,;
			llExist As Boolean

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			lcXML = ""
			lcTableName = ""

			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk
				Set Safety Off && Suppress verification message.
				lcTableName = This.cMainTableName
				llOk = .T.

				Try

					Use ( lcTableName ) In 0 Exclusive
					Use

				Catch To oErr
					llOk = .F.

				Finally

				Endtry
				llOk=.F.
				If llOk
					This.AlterTable( lcTableName )

				Else
					This.CreateTable( lcTableName )

				Endif

			Endif

		Catch To oErr
			This.lIsOk = .F.
			* This.cXMLoError = This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			lcXML = This.cXMLoError

		Finally
			* DAE 2009-11-06(17:20:27)
			*!*	If Used( lcTableName )
			*!*		Use In Alias( lcTableName )
			*!*	Endif
			Use In Select( lcTableName )

			If ! lllAlreadyConnected
				This.DisconnectFromBackend()

			Endif && ! lllAlreadyConnected

		Endtry

		Return lcXML

	Endproc && SynchronizeTables

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AlterTable
	*!* Description...: Modifica la estructura de la tabla
	*!* Date..........: Lunes 27 de Noviembre de 2006 (19:56:56)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure AlterTable( tcTableName As String ) As String;
			HELPSTRING "Modifica la estructura de la tabla"



	Endproc
	*!*
	*!* END PROCEDURE AlterTable
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateTable
	*!* Description...: Crea la estructura de una tabla inexistente
	*!* Date..........: Lunes 27 de Noviembre de 2006 (19:58:16)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure CreateTable( tcTableName As String ) As String;
			HELPSTRING "Crea la estructura de una tabla inexistente"

		Local loColFields As ColFields Of "FW\Comun\Prg\colFields.prg"
		Local oField As oField Of "FW\Comun\Prg\colFields.prg"
		Local lcCommand As String, lcFC As Character
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			* DAE 2009-11-06(20:04:58)
			*!*	This.oError.TraceLogin = ""
			*!*	This.oError.Remark = ""

			loColFields = This.GetColFields()

			lcCommand = "CREATE TABLE " + tcTableName + " ( "

			lcFC = ""
			For Each oField In loColFields
				lcCommand = lcCommand + This.GetCreateCommand( oField, lcFC )
				If Empty( lcFC )
					lcFC = ","
				Endif

			Endfor

			lcCommand = lcCommand + " ) "

			***Strtofile( lcCommand, "SynchronizeCommand.prg" )

			***			&lcCommand

		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(20:04:29)
			* This.cXMLoError=This.oError.Process( oErr )
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally

		Endtry


	Endproc && CreateTable

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetCreateCommand
	*!* Description...: Devuelve el comando para crear un campo
	*!* Date..........: Lunes 27 de Noviembre de 2006 (20:17:09)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetCreateCommand( oField As Object,;
			lcFC As Character ) As String;
			HELPSTRING "Devuelve el comando para crear un campo"

		Local lcCommand As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		#If .F.
			Local oField As oField Of "FW\Comun\Prg\colFields.prg"
		#Endif

		Try

			*!* This.oError.TraceLogin = ""
			*!* This.oError.Remark = ""


			lcCommand = lcFC + oField.FieldName + [ ]
			lcCommand = lcCommand + oField.FieldType + [ ]


			If !Empty( oField.FieldWidth )
				lcCommand = lcCommand + [ ( ] + Any2Char( oField.FieldWidth )

				If !Empty( oField.Precision )
					lcCommand = lcCommand + [, ] + Any2Char( oField.Precision )
				Endif
				lcCommand = lcCommand + [ ) ]
			Endif

			If !Empty( oField.Autoinc )
				lcCommand = lcCommand + [ AUTOINC ]
				If !Empty( oField.Nextvalue )
					lcCommand = lcCommand + [ NEXTVALUE ] + Any2Char( oField.Nextvalue )
					If !Empty( oField.Step )
						lcCommand = lcCommand + [ STEP ] + Any2Char( oField.Step )
					Endif
					lcCommand = lcCommand + [ ]
				Endif
			Endif

			If oField.NoCPTrans
				lcCommand = lcCommand + [ NOCPTRANS ]
			Endif



			*!*				If oField.PrimaryKey
			*!*					lcCommand = lcCommand + [ PRIMARY KEY ]
			*!*				Endif

			*!*				If oField.Unique
			*!*					lcCommand = lcCommand + [ UNIQUE ]
			*!*				Endif

			*!*				If !Empty( oField.Collate )
			*!*					lcCommand = lcCommand + [ COLLATE ] + oField.Collate
			*!*				Endif

			If oField.Null
				lcCommand = lcCommand + [ NULL ]
			Else
				lcCommand = lcCommand + [ NOT NULL ]
			Endif

			If !Empty( oField.Check )
				lcCommand = lcCommand + [ CHECK '] + oField.Check + [' ]

				If !Empty( oField.ErrorMessage )
					lcCommand = lcCommand + [ ERROR '] + oField.ErrorMessage + [' ]
				Endif
			Endif


			If !Empty( oField.Default )
				lcCommand = lcCommand + [ DEFAULT ] + Any2Char( oField.Default )
			Endif


		Catch To oErr
			This.lIsOk = .F.
			* DAE 2009-11-06(20:03:27)
			*!* This.cXMLoError=This.oError.Process( oErr )

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

		Finally

		Endtry

		Return lcCommand

	Endproc &&  GetCreateCommand

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetColFields
	*!* Description...: Obtiene la colección Fields
	*!* Date..........: Lunes 27 de Noviembre de 2006 (20:02:58)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetColFields(  ) As Object;
			HELPSTRING "Obtiene la colección Fields"

		*!* Se personaliza en cada entidad


	Endproc
	*!*
	*!* END PROCEDURE GetColFields
	*!*
	*!* ///////////////////////////////////////////////////////


	*
	* cIniFileName_Access

	Protected Procedure cBackEndCfgFileName_Access()

		If Empty( This.cBackEndCfgFileName )
			This.cBackEndCfgFileName = This.oServiceTier.cBackEndCfgFileName
		Endif

		Return This.cBackEndCfgFileName

	Endproc && cIniFileName_Access


	* DataSessionId_Assign

	Protected Procedure DataSessionId_Assign( uNewValue )

		This.DataSessionId = uNewValue

		If Vartype( This.oBackEnd ) = "O"
			This.oBackEnd.DataSessionId = uNewValue
		Endif


	Endproc && DataSessionId_Assign

	*
	* ResetError
	Procedure ResetError() As Void
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			This.oServiceTier.ResetError()
			This.lIsOk = .T.
			This.cXMLoError = ''
			DoDefault()

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr, .F. )

		Finally
			loError = Null

		Endtry

	Endproc && ResetError

Enddefine


Procedure Dummy
	If .F.
		*!* Librería de la DAL Native
		Do "BackEndNative.prg"

		*!* Librería de la DAL ODBC
		Do "BackEndODBC.prg"

		*!* Librería de la DAL para ADO
		Do "BackEndADO.prg"
	Endif
Endproc