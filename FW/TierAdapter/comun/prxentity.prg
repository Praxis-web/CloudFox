*!* ///////////////////////////////////////////////////////
*!* Class.........: Entity
*!* ParentClass...: PrxSession Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....: Session
*!* Description...: Encapsula las funciones básicas
*!* Date..........: Sábado 13 de Octubre de 2012 (09:40:32)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#INCLUDE "FW\TierAdapter\Include\TA.h"
#INCLUDE "FW\Comunes\Include\Praxis.h"

*!*	Define Class PrxEntity As PrxSession Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"
Define Class PrxEntity As SessionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"


	#If .F.
		Local This As PrxEntity Of "Fw\TierAdapter\Comun\prxEntity.prg"
	#Endif


	* Nombre del cursor virtual asociado a la entidad
	cMainCursorName = ""

	* Nombre de la tabla asociada a la entidad
	cMainTableName = ""

	* Si se utilizan Joins, lleva el alias de la tabla principal
	cMainTableNameAlias = ""



	* Id de la Entidad
	nEntidadId = 0

	* Nombre del Campo que es la PK
	cPKField = ""

	* Coleccion de Tablas de la Entidad
	oColTables = Null

	*
	lOnDestroy = .F.

	* Id de la transaccion que se está grabando
	TransactionId = 0

	* Tipo de Transaccion
	nAction = 0

	* Indica si la entidad es hija de otra
	lIsChild = .F.

	* Nombre de la Entidad Padre
	cParent = ""

	* Referencia al objeto Padre
	oParent = Null

	* Guarda los parametros de la última consulta
	oRequery = Null

	* Indica si la entidad se puede Crear
	lCanCreate = .T.

	* Indica si la entidad se puede Consultar
	lCanRead = .T.

	* Indica si la entidad se puede Modificar
	lCanUpdate = .T.

	* Indica si la entidad se puede Borrar
	lCanDelete = .T.

	* Indica si edita en Browse o en Edit
	lEditInBrowse = .T.

	* Criterio de busqueda por defecto
	cFilterCriteria = "( 1 > 0 )"

	*
	lUseNameSpaces = .T.


	*###################################################
	* RA 2013-10-06(10:07:49)
	* DataTier

	*	Flag de estado
	lIsOk = .T.

	* Referencia al objeto Conection
	oConnection = Null

	* Referencia al objeto que sabe como comunicarse con el Motor de Base de datos
	oBackEnd = Null


	* Indica si serializa los cursores para pasarlos entre capas
	lSerialize = .F.

	*
	cAccessType = "NATIVE"

	*
	cBackEndEngine = "FOX"

	cBackEndCfgFileName = ""

	cDataBaseName = ''
	cStringConnection = ''

	*!* Clave de búsqueda del objeto en los archivos de configuración
	cDataConfigurationKey = ""

	DataSession = 1

	* Valor del buffering por default de los cursores generados por BuilCursor
	nBuffering = 5

	* Indica si son tablas libres o utiliza una DBC
	lUseDBC = .T.

	* Indica si se utilizan transacciones
	lUseTransactions = .T.

	* Modo Debug
	lDebugMode = .F.

	* Comando que se ejecuta si existe
	cSQLCommand = ""

	* RA 2013-06-29(12:25:45)
	* Usado por AfterCursorFill() de CursorAdapterBase
	* Si trabajo conectado, no puedo cerrar las tablas
	* Solo vale para Clipper2Fox y Bases Nativas

	lCloseNativeTables = .T.

	* RA 2013-06-29(13:00:57)
	* Con bases nativas, el Triguer se dispara en el ApplyDiffgram
	lTriggerFailed = .F.

	* Se utiliza como filtro adicional
	cMasterFilter = "And ( 1 > 0 )"

	* Indica que ejecuta el comando Select standard
	lSelectCMD = .T.

	* Metodo alternativo a ejecutar en lugar del comando Select
	cNotSelectMethod = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="guardarvarios" type="method" display="GuardarVarios" />] + ;
		[<memberdata name="obtenerpermisos" type="method" display="ObtenerPermisos" />] + ;
		[<memberdata name="leerparametros" type="method" display="LeerParametros" />] + ;
		[<memberdata name="leditinbrowse" type="property" display="lEditInBrowse" />] + ;
		[<memberdata name="lischild" type="property" display="lIsChild" />] + ;
		[<memberdata name="lcancreate" type="property" display="lCanCreate" />] + ;
		[<memberdata name="lcanread" type="property" display="lCanRead" />] + ;
		[<memberdata name="lcanupdate" type="property" display="lCanUpdate" />] + ;
		[<memberdata name="lcandelete" type="property" display="lCanDelete" />] + ;
		[<memberdata name="cparent" type="property" display="cParent" />] + ;
		[<memberdata name="naction" type="property" display="nAction" />] + ;
		[<memberdata name="cpkfield" type="property" display="cPKField" />] + ;
		[<memberdata name="cpkfield_access" type="method" display="cPKField_Access" />] + ;
		[<memberdata name="cfiltercriteria" type="property" display="cFilterCriteria" />] + ;
		[<memberdata name="getone" type="method" display="GetOne" />] + ;
		[<memberdata name="getall" type="method" display="GetAll" />] + ;
		[<memberdata name="getbywhere" type="method" display="GetByWhere" />] + ;
		[<memberdata name="getdefault" type="method" display="GetDefault" />] + ;
		[<memberdata name="getwherecondition" type="method" display="GetWhereCondition" />] + ;
		[<memberdata name="nentidadid" type="property" display="nEntidadId" />] + ;
		[<memberdata name="nentidadid_access" type="method" display="nEntidadId_Access" />] + ;
		[<memberdata name="transactionid" type="property" display="TransactionId" />] + ;
		[<memberdata name="cmaincursorname" type="property" display="cMainCursorName" />] + ;
		[<memberdata name="cmaincursorname_access" type="method" display="cMainCursorName_Access" />] + ;
		[<memberdata name="cmaintablename" type="property" display="cMainTableName" />] + ;
		[<memberdata name="cmaintablename_access" type="method" display="cMainTableName_Access" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="crear" type="method" display="Crear" />] + ;
		[<memberdata name="guardar" type="method" display="Guardar" />] + ;
		[<memberdata name="exist" type="method" display="Exist" />] + ;
		[<memberdata name="initialize" type="method" display="Initialize" />] + ;
		[<memberdata name="validar" type="method" display="Validar" />] + ;
		[<memberdata name="validarregistro" type="method" display="ValidarRegistro" />] + ;
		[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
		[<memberdata name="ocoltables_access" type="method" display="oColTables_Access" />] + ;
		[<memberdata name="londestroy" type="property" display="lOnDestroy" />] + ;
		[<memberdata name="update" type="method" display="Update" />] + ;
		[<memberdata name="delete" type="method" display="Delete" />] + ;
		[<memberdata name="getdescripcion" type="method" display="GetDescripcion" />] + ;
		[<memberdata name="getentity" type="method" display="GetEntity" />] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[<memberdata name="oparent_access" type="method" display="oParent_Access" />] + ;
		[<memberdata name="oparent_assign" type="method" display="oParent_Assign" />] + ;
		[<memberdata name="getentityid" type="method" display="GetEntityId" />] + ;
		[<memberdata name="orequery" type="property" display="oRequery" />] + ;
		[<memberdata name="requery" type="method" display="Requery" />] + ;
		[<memberdata name="launcheditform" type="method" display="LaunchEditForm" />] + ;
		[<memberdata name="ltriggerfailed" type="property" display="lTriggerFailed" />] + ;
		[<memberdata name="cstringconnection" type="property" display="cStringConnection" />] + ;
		[<memberdata name="cdatabasename" type="property" display="cDataBaseName" />] + ;
		[<memberdata name="cbackendcfgfilename" type="property" display="cBackEndCfgFileName" />] + ;
		[<memberdata name="nbuffering" type="property" display="nBuffering" />] + ;
		[<memberdata name="cbackendengine" type="property" display="cBackEndEngine" />] + ;
		[<memberdata name="caccesstype" type="property" display="cAccessType" />] + ;
		[<memberdata name="obackend" type="property" display="oBackEnd" />] + ;
		[<memberdata name="obackend_access" type="method" display="oBackEnd_Access" />] + ;
		[<memberdata name="oconnection" type="property" display="oConnection" />] + ;
		[<memberdata name="serialize" type="method" display="Serialize" />] + ;
		[<memberdata name="lserialize" type="property" display="lSerialize" />] + ;
		[<memberdata name="buildcursor" type="method" display="BuildCursor" />] + ;
		[<memberdata name="sqlexecute" type="method" display="SQLExecute" />] + ;
		[<memberdata name="executenonquery" type="method" display="ExecuteNonQuery" />] + ;
		[<memberdata name="put" type="method" display="Put" />] + ;
		[<memberdata name="transactionbegin" type="method" display="TransactionBegin" />] + ;
		[<memberdata name="transactionend" type="method" display="TransactionEnd" />] + ;
		[<memberdata name="transactionrollback" type="method" display="TransactionRollBack" />] + ;
		[<memberdata name="gettablesfromsql" type="method" display="GetTablesFromSQL" />] + ;
		[<memberdata name="concatenarsinoexiste" type="method" display="ConcatenarSiNoExiste" />] + ;
		[<memberdata name="extractalias" type="method" display="ExtractAlias" />] + ;
		[<memberdata name="getupdatablefieldlist" type="method" display="GetUpdatableFieldList" />] + ;
		[<memberdata name="getupdatablefieldlistfromtable" type="method" display="GetUpdatableFieldListFromTable" />] + ;
		[<memberdata name="getupdatenamelist" type="method" display="GetUpdateNameList" />] + ;
		[<memberdata name="getupdatenamelistfromtable" type="method" display="GetUpdateNameListFromTable" />] + ;
		[<memberdata name="cdatabasename_access" type="method" display="cDataBaseName_Access" />] + ;
		[<memberdata name="readinifile" type="method" display="ReadIniFile" />] + ;
		[<memberdata name="csqlcommand" type="property" display="cSQLCommand" />] + ;
		[<memberdata name="actualizartimestamp" type="method" display="ActualizarTimeStamp" />] + ;
		[<memberdata name="generardiffgram" type="method" display="GenerarDiffgram" />] + ;
		[<memberdata name="crearcursoradapters" type="method" display="CrearCursorAdapters" />] + ;
		[<memberdata name="connecttobackend" type="method" display="ConnectToBackend" />] + ;
		[<memberdata name="disconnectfrombackend" type="method" display="DisconnectFromBackend" />] + ;
		[<memberdata name="getmaxid" type="method" display="GetMaxId" />] + ;
		[<memberdata name="updatechildren" type="method" display="UpdateChildren" />] + ;
		[<memberdata name="lclosenativetables" type="property" display="lCloseNativeTables" />] + ;
		[<memberdata name="killcursoradapters" type="method" display="KillCursorAdapters" />] + ;
		[<memberdata name="getinsertfieldsvalues" type="method" display="GetInsertFieldsValues" />] + ;
		[<memberdata name="getinsertfieldlist" type="method" display="GetInsertFieldList" />] + ;
		[<memberdata name="getupdatefieldsvalues" type="method" display="GetUpdateFieldsValues" />] + ;
		[<memberdata name="lusenamespaces" type="property" display="lUseNameSpaces" />] + ;
		[<memberdata name="cmaintablenamealias" type="property" display="cMainTableNameAlias" />] + ;
		[<memberdata name="cmasterfilter" type="property" display="cMasterFilter" />] + ;
		[<memberdata name="lselectcmd" type="property" display="lSelectCMD" />] + ;
		[<memberdata name="cnotselectmethod" type="property" display="cNotSelectMethod" />] + ;
		[</VFPData>]



	*!* ///////////////////////////////////////////////////////
	*!* Function......: Initialize
	*!* Description...:
	*!* Date..........: Domingo 30 de Septiembre de 2012 (10:47:21)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Clipper2Fox
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Initialize( uParam As Variant ) As Boolean

		Local lcCommand As String

		Try

			lcCommand = ""
			This.ObtenerPermisos()
			This.LeerParametros()

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry


	Endfunc
	*!*
	*!* END FUNCTION Initialize
	*!*
	*!* ///////////////////////////////////////////////////////


	*
	* Trae un elemento
	Procedure GetOne( nId As Integer, oParam As Object ) As Integer ;
			HELPSTRING "Trae un elemento"
		Local lcCommand As String,;
			lcFilterCriteria As String

		Local lnTally As Integer
		Local loParam As Object

		Try

			lcCommand = ""

			TEXT To lcCommand NoShow TextMerge Pretext 15
			cFilterCriteria = "<<This.cPKField>> = <<nId>>"
			ENDTEXT

			loParam = ObjParam( lcCommand, oParam )

			lnTally = This.GetByWhere( loParam )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			oParam = Null
			loParam = Null

		Endtry

		Return lnTally

	Endproc && GetOne



	*
	* Trae todos los elementos
	* oParam.cFilterCriteria = Criterio de Filtro
	* oParam.cOrderBy = Clausula de Ordenamiento
	* oParam.cFieldList = Lista de Campos
	* oParam.cJoins = Joins
	* oParam.nLevel = Nivel de profundidad que trae
	* oParam.cAlias = Alias alternativo a This.cMainCursorName
	Procedure GetAll( oParam As Object ) As Integer ;
			HELPSTRING "Trae todos los elementos"
		Local lcCommand As String,;
			lcParametros As String
		Local lnTally As Integer

		Try

			lcCommand = ""
			lnTally = 0

			lnTally = This.GetByWhere( oParam )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			oParam = Null

		Endtry

		Return lnTally

	Endproc && GetAll

	*
	* Trae los elementos filttrados por alguna condicion
	* oParam.cFilterCriteria = Criterio de Filtro
	* oParam.cOrderBy = Clausula de Ordenamiento
	* oParam.cFieldList = Lista de Campos
	* oParam.cExcludedFieldList = Lista de Campos Excluidos
	* oParam.cJoins = Joins
	* oParam.nLevel = Nivel de profundidad que trae
	* oParam.cAlias = Alias alternativo a This.cMainCursorName
	* oParam.lSilence = No muestra mensajes
	* oParam.nBuffering = Buffering del cursor devuelto
	* oParam.lDontDetach = Indica si permanece o no atacheado al CursorAdapter
	* oParam.lLogSelectCmd As Boolean ) = Loguea el comando ejecutado (para Debugging)

	Procedure GetByWhere( oParam As Object ) As Integer;
			HELPSTRING "Trae los elementos filttrados por alguna condicion"

		Local lcCommand As String,;
			lcAlias As String,;
			lcFilterCriteria As String,;
			lcParentFilter As String,;
			lcOrderBy As String,;
			lcFieldList As String,;
			lcExcludedFieldList As String,;
			lcJoins As String,;
			lcMasterFilter As String,;
			lcNotSelectMethod As String

		Local lnLevel As Integer

		Local llSilence As Boolean

		Local loParent As PrxEntity Of "Fw\TierAdapter\Comun\prxEntity.prg"
		Local lnTally As Integer

		Try

			lcCommand = ""


			* Valores por defecto
			lcParentFilter 		= ""
			lcAlias 			= This.cMainCursorName
			lnNivel 			= 1
			lcOrderBy			= ""
			lcFieldList			= " * "
			lcExcludedFieldList = ""
			lcJoins				= ""
			lcFilterCriteria 	= This.cFilterCriteria
			llSilence 			= .T.
			lcMasterFilter 		= This.cMasterFilter

			If Vartype( oParam ) = "C"
				lcFilterCriteria = oParam
				oParam = Createobject( "Empty" )
				AddProperty( oParam, "cFilterCriteria", lcFilterCriteria )
			Endif

			If Vartype( oParam ) # "O"
				oParam = Createobject( "Empty" )
			Endif

			If Pemstatus( oParam, "cFilterCriteria", 5 )
				lcFilterCriteria = oParam.cFilterCriteria

			Else
				AddProperty( oParam, "cFilterCriteria", lcFilterCriteria )

			Endif

			If Pemstatus( oParam, "cAlias", 5 )
				lcAlias = oParam.cAlias

			Else
				AddProperty( oParam, "cAlias", lcAlias )

			Endif

			If Pemstatus( oParam, "nLevel", 5 )
				lnLevel = oParam.nLevel

			Else
				AddProperty( oParam, "nLevel", lnLevel )

			Endif

			If Pemstatus( oParam, "cOrderBy", 5 )
				lcOrderBy = oParam.cOrderBy

				If !Empty( lcOrderBy )
					If !Upper( Substr( lcOrderBy, 1, Len( "Order By" ))) = "ORDER BY"
						lcOrderBy = "ORDER BY " + lcOrderBy
					Endif
				Endif

			Else
				AddProperty( oParam, "cOrderBy", lcOrderBy )

			Endif


			If Pemstatus( oParam, "cFieldList", 5 )
				lcFieldList = oParam.cFieldList

			Else
				AddProperty( oParam, "cFieldList", lcFieldList )

			Endif

			If Pemstatus( oParam, "cJoins", 5 )
				lcJoins = oParam.cJoins

			Else
				AddProperty( oParam, "cJoins", lcJoins )

			Endif

			If Pemstatus( oParam, "cExcludedFieldList", 5 )
				lcExcludedFieldList = oParam.cExcludedFieldList

			Else
				AddProperty( oParam, "cExcludedFieldList", lcExcludedFieldList )

			Endif

			If !Empty( lcExcludedFieldList ) Or ( lcFieldList = " * " )
				lcFieldList = This.GetFieldList( This.cMainTableName, lcExcludedFieldList )

				If !Pemstatus( oParam, "cFieldList", 5 )
					AddProperty( oParam, "cFieldList", "" )
				Endif
				oParam.cFieldList = lcFieldList

			Endif

			If !Pemstatus( oParam, "nBuffering", 5 )
				AddProperty( oParam, "nBuffering", 5 )
			Endif

			If !Pemstatus( oParam, "lDontDetach", 5 )
				AddProperty( oParam, "lDontDetach", .F. )
			Endif

			If !Pemstatus( oParam, "lLogSelectCmd", 5 )
				AddProperty( oParam, "lLogSelectCmd", .F. )
			Endif

			If This.lIsChild

				loParent = This.oParent

				TEXT To lcParentFilter NoShow TextMerge Pretext 15
				And ( <<loParent.cPKField>> = <<loParent.nEntidadId>> )
				ENDTEXT

			Endif

			If Pemstatus( oParam, "lSilence", 5 )
				llSilence = oParam.lSilence

			Else
				AddProperty( oParam, "lSilence", llSilence )

			Endif


			* Borrar

			*!*				Dimension aLocalStackinfo[1]
			*!*				lnLen = Astackinfo ( aLocalStackinfo )

			*!*				lcMsg = ""

			*!*				For i = lnLen To 1 Step -1

			*!*					TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
			*!*					<<aLocalStackinfo[ i, 1 ]>> <<Proper( aLocalStackinfo[ i, 3 ] )>> <<aLocalStackinfo[ i, 5 ]>>

			*!*					ENDTEXT

			*!*				Endfor

			*!*				TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
			*!*				***************************************************

			*!*				ENDTEXT


			*!*				TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
			*!*				oParam.cFilterCriteria = <<oParam.cFilterCriteria>>
			*!*				oParam.cOrderBy = <<oParam.cOrderBy>>
			*!*				oParam.cFieldList = <<oParam.cFieldList>>
			*!*				oParam.cExcludedFieldList = <<oParam.cExcludedFieldList>>
			*!*				oParam.cJoins = <<oParam.cJoins>>
			*!*				oParam.nLevel = <<oParam.nLevel>>
			*!*				oParam.cAlias = <<oParam.cAlias>>
			*!*				oParam.lSilence = <<oParam.lSilence>>
			*!*				oParam.nBuffering = <<oParam.nBuffering>>
			*!*				oParam.lDontDetach = <<oParam.lDontDetach>>
			*!*				oParam.lLogSelectCmd = <<oParam.lLogSelectCmd>>

			*!*				------------------------------------------------------------------------------
			*!*				ENDTEXT

			*!*				*Inform( lcMsg, "Traer Articulos", -1 )

			*!*				Strtofile( lcMsg + CRLF + CRLF, "GetByWhere.txt", 1 )
			*!*
			*!*				* Borrar hasta aca ----------------------------------------

			If This.lSelectCMD

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Select 	<<lcFieldList>> ,
						" " as r7Mov,
						Cast( 0 as I ) as ABM,
						Cast( 0 as I ) as _RecordOrder
					From <<This.cMainTableName>> <<This.cMainTableNameAlias>>
					<<lcJoins>>
					Where <<lcFilterCriteria>>
						<<lcParentFilter>>
						<<lcMasterFilter>>
					<<lcOrderBy>>
				ENDTEXT

				This.oRequery = oParam

				This.SQLExecute( lcCommand,;
					lcAlias,;
					oParam.nBuffering,;
					oParam.lDontDetach ,;
					oParam.lLogSelectCmd )

				lnTally = _Tally

			Else
				lcNotSelectMethod = This.cNotSelectMethod

				TEXT To lcCommand NoShow TextMerge Pretext 15
				lnTally = This.<<lcNotSelectMethod>>( oParam )
				ENDTEXT

				&lcCommand
				lcCommand = ""

			Endif

			If !Empty( lnTally )
				Select Alias( lcAlias )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update <<lcAlias>> Set _RecordOrder = Recno()
				ENDTEXT

				&lcCommand

				Locate

			Else
				If !llSilence
					Warning( "No se han encontrado registros", This.Name, 2 )
				Endif

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			oParam = Null

		Endtry

		Return lnTally

	Endproc && GetByWhere


	*
	* Repite la última consulta
	Procedure Requery(  ) As Void;
			HELPSTRING "Repite la última consulta"
		Local lcCommand As String

		Local lnTally As Integer

		Try

			lcCommand = ""
			lnTally = This.GetByWhere( This.oRequery )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lnTally

	Endproc && Requery


	*
	* Devuelve la condición de búsqueda
	Procedure GetWhereCondition( cField As String,;
			cCondicion As String,;
			cFilterCriteria As String,;
			cDataType As String ) As String;
			HELPSTRING "Devuelve la condición de búsqueda"

		Local lcCommand As String
		Local lcFilterCriteria As String
		Local ldFilterCriteria As Date
		Local lnFilterCriteria As Number
		Local llFilterCriteria As Boolean


		Local lnDecimal As Integer

		Try

			lcCommand = "( 1 = 0 )"
			lnDecimal = Set("Decimals")
			Set Decimals To 6

			*!*		C	Character, Memo, Varchar, Varchar (Binary)
			*!*		D	Date, DateTime
			*!*		L 	Logical
			*!*		N	Numeric, Float, Double, Integer, Currency


			If Inlist( cDataType, "C", "D", "L", "N" )

				If cCondicion # "E"
					Do Case
						Case cDataType = "C"
							lcFilterCriteria = Alltrim( Upper( cFilterCriteria ))

						Case cDataType = "D"
							ldFilterCriteria = Ctod( Alltrim( cFilterCriteria ))

						Case cDataType = "N"
							lnFilterCriteria = Val( Alltrim( cFilterCriteria ))

						Otherwise

					Endcase

				Endif

				Do Case
					Case cCondicion = "*"		&& Todos
						TEXT To lcCommand NoShow TextMerge Pretext 15
						( 1 > 0 )
						ENDTEXT

					Case cCondicion = "like"	&& Comienza Con
						If Inlist( cDataType, "C" )
							TEXT To lcCommand NoShow TextMerge Pretext 15
							Upper( <<cField>> ) Like '<<lcFilterCriteria>>%'
							ENDTEXT
						Endif

					Case cCondicion = "%"		&& Contiene El Texto
						If Inlist( cDataType, "C" )
							TEXT To lcCommand NoShow TextMerge Pretext 15
							Upper( <<cField>> ) Like '%<<lcFilterCriteria>>%'
							ENDTEXT
						Endif

					Case cCondicion = "!#"		&& Es Igual A
						Do Case
							Case cDataType = "C"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								Upper( <<cField>> ) = '<<cFilterCriteria>>'
								ENDTEXT

							Case cDataType = "D"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> = <<Fecha2Sql( ldFilterCriteria )>>
								ENDTEXT

							Case cDataType = "L"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> = <<True>>
								ENDTEXT

							Case cDataType = "N"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> = <<lnFilterCriteria>>
								ENDTEXT

						Endcase

					Case cCondicion = "#"		&& Es Diferente A
						Do Case
							Case cDataType = "C"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								Upper( <<cField>> ) <> '<<lcFilterCriteria>>'
								ENDTEXT

							Case cDataType = "D"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> <> <<Fecha2Sql( ldFilterCriteria )>>
								ENDTEXT

							Case cDataType = "L"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> = <<False>>
								ENDTEXT

							Case cDataType = "N"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> <> <<lnFilterCriteria>>
								ENDTEXT

						Endcase

					Case cCondicion = "<"		&& Es Menor Que
						Do Case
							Case cDataType = "C"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								Upper( <<cField>> ) < '<<lcFilterCriteria>>'
								ENDTEXT

							Case cDataType = "D"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> < <<Fecha2Sql( ldFilterCriteria )>>
								ENDTEXT

							Case cDataType = "N"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> < <<lnFilterCriteria>>
								ENDTEXT

						Endcase

					Case cCondicion = "<="		&& Es Menor O Igual A
						Do Case
							Case cDataType = "C"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								Upper( <<cField>> ) <= '<<lcFilterCriteria>>'
								ENDTEXT

							Case cDataType = "D"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> <= <<Fecha2Sql( ldFilterCriteria )>>
								ENDTEXT

							Case cDataType = "N"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> <= <<lnFilterCriteria>>
								ENDTEXT

						Endcase

					Case cCondicion = ">"		&& Es Mayor Que
						Do Case
							Case cDataType = "C"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								Upper( <<cField>> ) > '<<lcFilterCriteria>>'
								ENDTEXT

							Case cDataType = "D"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> > <<Fecha2Sql( ldFilterCriteria )>>
								ENDTEXT

							Case cDataType = "N"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> > <<lnFilterCriteria>>
								ENDTEXT

						Endcase

					Case cCondicion = ">="		&& Es Mayor O Igual A
						Do Case
							Case cDataType = "C"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								Upper( <<cField>> ) >= '<<lcFilterCriteria>>'
								ENDTEXT

							Case cDataType = "D"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> >= <<Fecha2Sql( ldFilterCriteria )>>
								ENDTEXT

							Case cDataType = "N"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> >= <<lnFilterCriteria>>
								ENDTEXT

						Endcase

					Case cCondicion = "E"		&& Se Encuentra Entre
						Local lcPrimerMiembro As String,;
							lcSegundoMienbro As String

						lcPrimerMiembro 	= Getwordnum( cFilterCriteria, 1, ";" )
						lcSegundoMienbro 	= Getwordnum( cFilterCriteria, 2, ";" )

						Do Case
							Case cDataType = "C"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								Upper( <<cField>> ) Between '<<lcPrimerMiembro>>' And '<<lcSegundoMienbro>>'
								ENDTEXT

							Case cDataType = "D"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> Between  <<Fecha2Sql( Ctod( lcPrimerMiembro ))>> And << Fecha2Sql( Ctod( lcSegundoMienbro ))>>
								ENDTEXT

							Case cDataType = "N"
								TEXT To lcCommand NoShow TextMerge Pretext 15
								<<cField>> Between  <<Val( lcPrimerMiembro )>> And <<Val( lcSegundoMienbro )>>
								ENDTEXT

						Endcase


					Otherwise

				Endcase

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Set Decimals To lnDecimal

		Endtry

		Return lcCommand

	Endproc && GetWhereCondition



	*
	* Devuelve el registro marcado como Predeterminado
	Procedure GetDefault(  ) As Void
		Local lcCommand As String,;
			lcFilterCriteria As String

		Try

			lcCommand = ""

			TEXT To lcCommand NoShow TextMerge Pretext 15
			<<This.cMainTableName>>.Default = <<TRUE>>
			ENDTEXT

			loParam = ObjParam( lcCommand )

			This.GetByWhere( loParam )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && GetDefault



	*
	* Obtiene los permisos que tiene sobre la entidad el Usuario activo
	Procedure ObtenerPermisos(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			*!*				This.lCanCreate = .T.
			*!*				This.lCanDelete = .T.
			*!*				This.lCanRead 	= .T.
			*!*				This.lCanUpdate = .T.


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && ObtenerPermisos



	*
	* Lee los parámetros asociados a la entidad
	Procedure LeerParametros(  ) As Void;
			HELPSTRING "Lee los parámetros asociados a la entidad"
		Local lcCommand As String

		Try

			lcCommand = ""
			*!*				This.lEditInBrowse = .F.


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && LeerParametros




	*
	* cMainCursorName_Access
	Protected Procedure cMainCursorName_Access()

		Return This.cMainCursorName

	Endproc && cMainCursorName_Access

	*
	* cTableName_Access
	Protected Procedure cMainTableName_Access()

		Return This.cMainTableName

	Endproc && cTableName_Access




	*
	* Trae un registro nuevo
	Procedure New(  ) As Void;
			HELPSTRING "Trae un registro nuevo"
		Local lcCommand As String

		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
		Local loColFields As ColFields Of 'Tools\DataDictionary\prg\ColFields.prg'
		Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'


		Try

			lcCommand = ""

			TEXT To lcCommand NoShow TextMerge Pretext 15
			cFilterCriteria = "( 1 = 0 )"
			ENDTEXT

			loParam = ObjParam( lcCommand )

			This.GetByWhere( loParam )

			Select Alias( This.cMainCursorName )
			*!*				If CursorGetProp("Buffering", This.cMainCursorName ) # 5
			*!*					CursorSetProp( "Buffering", 5, This.cMainCursorName )
			*!*				Endif

			If CursorGetProp("Buffering", This.cMainCursorName ) # This.nBuffering
				CursorSetProp( "Buffering", This.nBuffering, This.cMainCursorName )
			Endif

			Append Blank

			loColTables = This.oColTables
			loTable 	= loColTables.GetItem( This.cMainTableName )

			* Poner valores por default

			For Each loField In loTable.oColFields
				If !IsEmpty( loField.Default )
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Replace <<loField.Name>>
						With loField.Default
						In <<This.cMainCursorName>>
					ENDTEXT

					&lcCommand

				Endif
			Endfor


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && New

	*
	* Crea y guarda una nueva entidad
	Procedure Crear( oParam As Object ) As Void;
			HELPSTRING "Crea y guarda una nueva entidad"
		Local lcCommand As String

		Try

			lcCommand = ""
			This.nAction = TR_NEW
			This.Guardar( oParam )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Crear




	*
	* Modifica una Entidad
	Procedure Update( oParam As Object ) As Void;
			HELPSTRING "Modifica una Entidad"
		Local lcCommand As String

		Try

			lcCommand = ""
			This.nAction = TR_UPDATE
			This.Guardar( oParam )


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Update



	*
	* Elimina una Entidad
	Procedure Delete( oParam As Object ) As Void;
			HELPSTRING "Elimina una Entidad"
		Local lcCommand As String

		Try

			lcCommand = ""
			This.nAction = TR_DELETE
			This.Guardar( oParam )


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Delete


	*
	* Validación antes de guardar
	Procedure Validar( cAlias As String ) As Boolean ;
			HELPSTRING "Validación antes de guardar"

		Local lcCommand As String
		Local llValid As Boolean

		Try

			lcCommand = ""
			llValid = .T.

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llValid

	Endproc && Validar

	*
	* Valida el registro actual
	Procedure ValidarRegistro( cAlias As String ) As Boolean;
			HELPSTRING "Valida el registro actual"
		Local lcCommand As String,;
			lcErrMsg As String,;
			lcAlias As String

		Local llValid As Boolean

		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
		Local loColFields As ColFields Of 'Tools\DataDictionary\prg\ColFields.prg'
		Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'

		Local loColErrorMessages As Collection


		Try

			lcCommand = ""
			lcAlias = Alias()

			llValid = .T.
			loColErrorMessages = Createobject( "Collection" )

			If Empty( cAlias )
				cAlias = This.cMainCursorName
			Endif

			Select Alias( cAlias )

			If !Bof() And !Eof()

				loColTables = This.oColTables
				loTable 	= loColTables.GetItem( This.cMainTableName )

				* Poner valores por default

				For Each loField In loTable.oColFields
					Try

						If !Empty( loField.cCheck ) And !Evaluate( loField.cCheck )
							llValid = .F.

							TEXT To lcErrMsg NoShow TextMerge Pretext 03
							<<loField.cCaption>>: <<loField.cErrorMessage>>

							ENDTEXT

							loColErrorMessages.Add( lcErrMsg )

						Endif

					Catch To oErr
						If !Empty( Field( loField.Name )) 
							Throw oErr
						EndIf

					Finally

					Endtry

				Endfor

				If !llValid
					lcErrMsg = ""

					For Each oMsg In loColErrorMessages
						lcErrMsg = lcErrMsg + oMsg + CRLF
					Endfor

					Stop( lcErrMsg, "Error de Validación del Registro" )

				Endif
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loColErrorMessages = Null
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

		Return llValid

	Endproc && ValidarRegistro


	* Validación en el Browse
	*
	Procedure BeforeRowColChange( oColumn As PrxColumnBase Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg", ;
			oColErrorMessages As Collection,;
			lPerdiendoElFoco As Boolean ) As Boolean

		Local lcCommand As String,;
			lcFieldName As String,;
			lcAlias As String,;
			lcOldAlias As String

		Local llValid As Boolean,;
			llDataHasChange As Boolean

		Local lnAccion As Integer
		Local luValue As Variant

		Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'



		* RA 2013-06-14(11:05:44)
		* (TO DO) Indicar el tipo de actualizacion que se está ejecutando

		Local llUpdate As Boolean,;
			llCreate As Boolean,;
			llDelete As Boolean

		Try


			llCreate = .F.
			llDelete = .F.
			llUpdate = .F.

			lcCommand 		= ""
			llValid 		= .T.
			llDataHasChange = .F.
			lcOldAlias 		= Alias()

			lcAlias 		= Lower( Getwordnum( oColumn.ControlSource, 1, "." ))
			lcFieldName 	= Lower( Getwordnum( oColumn.ControlSource, 2, "." ))

			Select Alias( lcAlias )

			If oColumn.oField.lCanUpdate
				* Ver si el Value del control es diferente al del campo

				luValue = oColumn.Value

				If luValue # Evaluate( oColumn.ControlSource )
					llDataHasChange = .T.
				Endif

				If !llDataHasChange
					llDataHasChange = DataHasChanges( lcAlias )

					* RA 2014-08-31(11:24:14)
					* Si el browse utiliza la funcionalidad de ordenar
					* por columna, no puede tener Buffering = 5, y
					* DataHasChanges no puede evaluar los cambios.
					* Si en un registro se modifica algun campo, y se
					* aplica inmediatamente, el campo ABM no se actualiza
					* Para evitar ese bug, si se da aceptar (lPerdiendoElFoco = .T.)
					* y Buffering # 5, por las dudas modifico el campo ABM
					If !llDataHasChange	;
							And lPerdiendoElFoco ;
							And CursorGetProp( "Buffering", lcAlias ) # 5

						llDataHasChange = .T.
					Endif
				Endif

				If llDataHasChange

					If Evaluate( lcAlias + ".ABM" ) = 0
						* Si hubo un Alta, una Baja o una Recuperación, ya
						* viene marcado el campo
						* Si está vacío, es que solo hubo modificación
						Replace ABM With ABM_MODIFICACION
					Endif

				Endif

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )


		Finally
			If Used( lcOldAlias )
				Select Alias( lcOldAlias )
			Endif

		Endtry

		Return llValid

	Endproc && BeforeRowColChange

	*
	* Guarda varios registros, editados en un browse
	Procedure GuardarVarios( oParam As Object ) As Void;
			HELPSTRING "Guarda varios registros, editados en un browse"
		Local lcCommand As String
		Local llOk As Boolean
		Local lnId As Integer


		Try

			lcCommand = ""
			llOk = .F.


			If Empty( This.nAction )
				This.nAction = TR_UPDATE
			Endif

			If IsEmpty( oParam )
				oParam = This.oRequery
			Endif

			If This.Validar()

				TEXT To lcCommand NoShow TextMerge Pretext 15
				nEntidadId = <<This.nEntidadId>>
				ENDTEXT

				oParam = ObjParam( lcCommand, oParam )

				llOk = This.Put( oParam )

				This.nAction = 0

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			This.nAction = 0

		Endtry

		Return llOk

	Endproc && GuardarVarios

	*
	* Guarda las modificaciones realizadas a una entidad
	Procedure Guardar( oParam As Object ) As Boolean ;
			HELPSTRING "Guarda las modificaciones realizadas a una entidad"
		Local lcCommand As String
		Local llOk As Boolean


		Try

			lcCommand = ""
			llOk = .F.

			If Empty( This.nAction )
				This.nAction = TR_UPDATE
			Endif

			If IsEmpty( oParam )
				oParam = This.oRequery
			Endif

			If This.Validar()

				TEXT To lcCommand NoShow TextMerge Pretext 15
				nEntidadId = <<This.nEntidadId>>
				ENDTEXT

				oParam = ObjParam( lcCommand, oParam )

				llOk = This.Put( oParam )

				This.nAction = 0

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			This.nAction = 0

		Endtry

		Return llOk

	Endproc && Guardar




	*
	* Llama al formulario para editar la entidad
	Procedure LaunchEditForm( cCursorDeTrabajo As String, nDataSessionId As Integer ) As Void;
			HELPSTRING "Llama al formulario para editar la entidad"
		Local lcCommand As String

		Try

			lcCommand = ""


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && LaunchEditForm

	*
	* Devuelve un valor booleano indecando si hay algún registro que cumple con la condición
	Procedure Exist( tcFilterCriteria As String ) As Boolean;
			HELPSTRING "Devuelve un valor booleano indecando si hay algún registro que cumple con la condición"

		Local llExist As Boolean
		Local lcAlias As String

		Local lcCommand As String

		Try

			lcCommand = ""

			If Empty( tcFilterCriteria )
				tcFilterCriteria = "( 1 > 0 )"
			Endif

			lcAlias = Sys( 2015 )
			llExist = .F.

			TEXT To lcCommand NoShow TextMerge Pretext 15
				 Select Count( * ) as Cant
				 From <<This.cMainTableName>>
				 Where <<tcFilterCriteria>>
			ENDTEXT

			This.SQLExecute( lcCommand, lcAlias )
			If Used( lcAlias )
				llExist = ! Empty( Evaluate( lcAlias + ".Cant" ) )
			Endif

			lcCommand = ""

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Use In Select( lcAlias )

		Endtry

		Return llExist

	Endproc && Exist



	*
	* cPKField_Access
	Protected Procedure cPKField_Access()

		If Empty( This.cPKField )
			Local lcFieldName As String

			lcFieldName = Strtran( This.cMainTableName, "sys_", "", -1, -1, 1 )
			lcFieldName = Substr( lcFieldName, 1, Len( lcFieldName ) - 1 )

			This.cPKField = Proper( lcFieldName ) + "Id"

		Endif

		Return This.cPKField

	Endproc && cPKField_Access


	*
	* oColTables_Access
	Protected Procedure oColTables_Access()
		Local lcCommand As String
		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

		Try

			lcCommand = ""
			If !This.lOnDestroy

				If Vartype( This.oColTables ) # "O"

					* RA 2013-10-05(14:53:40)
					* Es una colección acotada, que contiene solo las tablas
					* asociadas a la entidad

					This.oColTables = _Newobject( "oColTables", 'Tools\DataDictionary\prg\oColTables.prg' )
					loColTables = NewColTables()

					If !Empty( This.cMainTableName )
						loTable = loColTables.GetItem( This.cMainTableName )
						loTable.cCursorName = This.cMainCursorName

						This.oColTables.nNivelJerarquiaTablas = loTable.nNivelJerarquiaTablas
						This.oColTables.AddItem( loTable, Lower( This.cMainTableName ))
					Endif

				Endif
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry

		Return This.oColTables

	Endproc && oColTables_Access


	*
	*
	Procedure Destroy(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			DoDefault()

			This.oRequery = Null
			This.oColTables = Null


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Destroy

	*
	*
	Procedure GetDescripcion( nId As Integer ) As String;
			HELPSTRING "Obtiene la descripción de un registro en particular"

		Local lcCommand As String
		Local lcDescripcion As String,;
			lcAlias As String
		Local lcPK As String
		Local lcEntityCursor As String

		Try

			lcCommand = ""

			lcPK = This.cMainCursorPK
			lcEntityCursor = This.cMainCursorName

			lcDescripcion = ""
			lcAlias = Sys( 2015 )

			If Used( lcEntityCursor )

				Select Alias( lcEntityCursor )
				If Evaluate( lcEntityCursor + "." + lcPK ) = nId
					lcDescripcion = Evaluate( lcEntityCursor + ".Descripcion" )
				Endif

			Endif

			If Empty( lcDescripcion )

				This.GetOne( nId, 1, lcAlias )
				If Used( lcAlias )
					lcDescripcion = Alltrim( Evaluate( lcAlias + ".Descripcion" ) )
				Endif

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "fw\Actual\ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally
			If Used( lcAlias )
				Use In Alias(lcAlias)
			Endif
		Endtry
		Return lcDescripcion

	Endproc && GetDescripcion

	*
	* Devuelve una instancia de una entidad
	* Esta pensado para que la clase maneje la devolucion de su decendencia
	* Debe ser sobreescrito por el programador
	Procedure GetEntity( cKeyName As String ) As Object;
			HELPSTRING "Devuelve una instancia de una entidad"
		Local lcCommand As String
		Local loEntity As Object

		Try

			lcCommand = ""
			loEntity = GetEntity( cKeyName )


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loEntity

	Endproc && GetEntity


	*
	* Devuelve el Id de la Entidad
	Procedure GetEntityId(  ) As Integer;
			HELPSTRING "Devuelve el Id de la Entidad"
		Local lcCommand As String
		Local lnEntidadId As Integer

		Try

			lcCommand = ""
			lnEntidadId = 0

			If Used( This.cMainCursorName )
				If !Bof( This.cMainCursorName ) And !Eof( This.cMainCursorName )
					lnEntidadId = Evaluate( This.cMainCursorName + "." + This.cPKField  )
				Endif
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lnEntidadId

	Endproc && GetEntityId


	*
	* oParent_Access
	Protected Procedure oParent_Access()

		If This.lIsChild ;
				And Vartype( This.oParent ) # "O" ;
				And !Empty( This.cParent )

			This.oParent = GetEntity( This.cParent )

		Endif

		Return This.oParent

	Endproc && oParent_Access


	* oParent_Assign

	Protected Procedure oParent_Assign( uNewValue )

		If Vartype( uNewValue ) # "O"
			uNewValue = Null
		Endif

		This.oParent = uNewValue

	Endproc && oParent_Assign

	*
	* nEntidadId_Access
	Protected Procedure nEntidadId_Access()

		This.nEntidadId = This.GetEntityId()

		Return This.nEntidadId

	Endproc && nEntidadId_Access



	*
	* Devuelve la lista de campos para la entidad
	Procedure GetFieldList( cTableName As String, cExcludedFields As String ) As String;
			HELPSTRING "Devuelve la lista de campos para la entidad"

		Local lcCommand As String,;
			lcFieldList As String

		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
		Local loColFields As ColFields Of 'Tools\DataDictionary\prg\ColFields.prg'
		Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'

		Try

			lcCommand 	= ""
			lcFieldList = ""

			If Empty( cExcludedFields )
				cExcludedFields = "Borrado, Ir, Usuario, WinUser, Equipo, UserId, Pasaje, Web_Id"
			Endif

			If Empty( cTableName )
				cTableName = This.cMainTableName
			Endif

			lcFieldList = This.GetUpdatableFieldList( cTableName, cExcludedFields, .T. )

			Try


				If Empty( Field( "Pasaje", cTableName ))
					* RA 24/04/2019(11:55:01)
					* No todals las tablas lo tienen y no es fundamental
					* Se utiliza solo en los pasajes
					lcFieldList = Strtran( lcFieldList, "pasaje,", "" )
				Endif


			Catch To oErr

			Finally

			Endtry

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcFieldList

	Endproc && GetFieldList

	*#######################################################################################
	* RA 2013-10-06(10:06:55)
	* DataTier

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SQLExecute
	*!* Description...: Ejecuta un comando SQL y devuelve un objeto
	*!* Date..........: Jueves 19 de Enero de 2006 (11:22:52)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure SQLExecute( tcSQLCommand As String,;
			tcAlias As String,;
			tnBuffering As Integer,;
			tlDontDetach As Boolean,;
			tlLogSelectCmd As Boolean ) As Object;
			HELPSTRING "Ejecuta un comando SQL y devuelve un objeto"

		Local lllAlreadyConnected As Boolean
		Local loReturn As Object

		Try


			If Empty( tcAlias )
				tcAlias = Sys( 2015 )
			Endif

			lllAlreadyConnected = This.ConnectToBackend() = 0

			loReturn = This.BuildCursor( tcAlias, tcSQLCommand, tnBuffering, tlDontDetach, tlLogSelectCmd )

			If Vartype( loReturn ) == "O"
				AddProperty( loReturn, "cXML", This.Serialize( tcAlias ))
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

		Return loReturn

	Endproc
	*!*
	*!* END PROCEDURE SQLExecute
	*!*
	*!* ///////////////////////////////////////////////////////


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

		Local lllAlreadyConnected As Boolean
		Local loMyCA As CursorAdapterBase Of 'Tools\NameSpaces\Prg\CursorAdapterBase.prg'
		Local lcCommand As String
		Local lcDate As String,;
			lcCentury As String

		Try

			lcCommand = ""

			lcDate = Set("Date")
			lcCentury = Set("Century")

			Set Date YMD
			Set Century On

			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk

				loMyCA = _Newobject("CursorAdapterBase",;
					"Tools\NameSpaces\Prg\CursorAdapterBase.prg",;
					"",;
					This.cAccessType,;
					This.oConnection,;
					This.cBackEndEngine )

				lcCommand = loMyCA.ValidateSqlStatement( tcSQLCommand )

				This.lIsOk = This.oBackEnd.ExecuteNonQuery( lcCommand )

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loMyCA = Null
			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

			Set Date (lcDate)
			Set Century &lcCentury

		Endtry

		Return This.lIsOk

	Endproc && ExecuteNonQuery


	*
	*
	Procedure Put( oParam As Object ) As Boolean
		Local lcCommand As String,;
			lcDiffgram As String,;
			lcDeleted As String

		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'


		Local loTransaction As Transaction Of "ERP\Comunes\Sistema\Prg\Transaction.prg"

		Local lnTransactionId As Integer

		Local llOk As Boolean
		Local lllAlreadyConnected As Boolean

		Private pcXMLError As String

		Try

			lcCommand = ""
			pcXMLError = ""
			lcDeleted = Set("Deleted")

			llOk = .T.
			This.lTriggerFailed = .F.

			If Vartype( oParam ) = "O"
				If Pemstatus( oParam, "nEntidadId", 5 )
					This.nEntidadId = oParam.nEntidadId
				Endif
			Endif

			If This.lUseTransactions
				* RA 2013-08-16(17:45:56)
				* Por sugerencia de Dado, decidimos
				* no grabar la transaccion, sino implementar un
				* sistema de loggeo

				*!*					loTransaction = GetEntity( "Transaction" )
				*!*					loTransaction.OpenTransaction()

				*!*					loTransaction.nAction = This.nAction
			Endif

			Set Deleted Off

			* Proceso de actualizacion

			* Llegan los cursores actualizados en la coleccion colTables
			* Recorrer la coleccion generando los CursorAdapter por cada tabla
			* Abrir la transaccion
			* Recorrer la coleccion ejecutando TableUpdate() para cada tabla

			This.CrearCursorAdapters( oParam )

			If !This.lTriggerFailed

				* Ahora si, abro la transacción y ejecuto TableUpdate

				lllAlreadyConnected = This.ConnectToBackend() = 0
				This.TransactionBegin()

				loColTables = This.oColTables

				llOk = .T.

				For Each loTable In loColTables
					If llOk


						If This.lUseTransactions
							* RA 2013-08-16(17:45:56)
							* Por sugerencia de Dado, decidimos
							* no grabar la transaccion, sino implementar un
							* sistema de loggeo


							*!*								TEXT To lcCommand NoShow TextMerge Pretext 15
							*!*								Update <<loTable.cCursorName>> Set
							*!*									Transaction_ID = <<loTransaction.TransactionID>>
							*!*									Where !Empty( ABM )
							*!*								ENDTEXT

							*!*								&lcCommand
						Endif

						If loTable.nNivel > 1
							This.UpdateChildren( loTable, This.nEntidadId )
						Endif

						Select Alias( loTable.cCursorName )

						Locate
						Scan For Evaluate( loTable.cCursorName + ".ABM" ) = ABM_BAJA While llOk

							If !Tableupdate( .F., .T., loTable.cCursorName )
								llOk = .F.
							Endif

						Endscan


						Locate
						Scan For Evaluate( loTable.cCursorName + ".ABM" ) = ABM_MODIFICACION While llOk

							If !Tableupdate( .F., .T., loTable.cCursorName )
								llOk = .F.
							Endif

						Endscan

						Locate
						Scan For Evaluate( loTable.cCursorName + ".ABM" ) = ABM_ALTA While llOk

							If !Tableupdate( .F., .T., loTable.cCursorName )
								llOk = .F.

							Else
								If loTable.nNivel = 1
									* Es un alta, Guardo el Id para pasarlo a los hijos

									If !loTable.lPKUpdatable
										* Es autoincremental
										This.nEntidadId = This.GetMaxId( loTable.Name, loTable.cPKName ) + 1
									Endif

								Endif
							Endif

						Endscan

					Endif
				Endfor

				If llOk
					This.TransactionEnd()

					If This.lUseTransactions
						* RA 2013-08-16(17:45:56)
						* Por sugerencia de Dado, decidimos
						* no grabar la transaccion, sino implementar un
						* sistema de loggeo

						*loTransaction.CloseTransaction()
					Endif

				Else
					Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
					loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					loError.Cremark = "Tableupdate Falló"
					loError.Process()

				Endif

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			llOk = .F.

			Try
				Do While !Empty( Txnlevel())
					This.TransactionRollBack()
				Enddo

			Catch

			Finally


			Endtry


			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

			This.KillCursorAdapters()

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

			loTable = Null
			loColTables = Null

			Set Deleted &lcDeleted

		Endtry

		Return llOk

	Endproc && Put



	*
	* Libera todos los CursorsAdapters asociados a las tablas
	Procedure KillCursorAdapters(  ) As Void;
			HELPSTRING "Libera todos los CursorsAdapters asociados a las tablas"
		Local lcCommand As String
		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'


		Try

			lcCommand = ""
			loColTables = This.oColTables

			For Each loTable In loColTables
				If Vartype( loTable.oCursorAdapter ) == "O"
					If Lower( loTable.oCursorAdapter.BaseClass ) = Lower( "CursorAdapter" )
						loTable.oCursorAdapter.CursorDetach()
					Endif

					loTable.oCursorAdapter = Null
				Endif

			Endfor


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTable = Null
			loColTables = Null

		Endtry

	Endproc && KillCursorAdapters


	*
	* Actualiza el ParentId de los hijos en un insert
	Procedure UpdateChildren( oTable As Object,;
			nEntidadId As Integer ) As Void;
			HELPSTRING "Actualiza el ParentId de los hijos en un insert"

		Local lcCommand As String

		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

		Local llOk As Boolean

		Try

			lcCommand 	= ""
			llOk 		= .T.

			loTable = oTable

			Select Alias( loTable.cCursorName )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Replace All
				<<loTable.cForeignKey>> With <<nEntidadId>>
				In <<loTable.cCursorName>>
			ENDTEXT

			&lcCommand


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTable = Null

		Endtry

	Endproc && UpdateChildren


	*
	*
	Procedure GetMaxId( tcTable As String, tcPKName As String ) As Integer
		Local lcCommand As String
		Local lnMaxId As Integer

		Try

			lcCommand 	= ""
			lnMaxId 	= 0

			lnMaxId = This.oBackEnd.GetMaxId( tcTable, tcPKName  )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry

		Return lnMaxId

	Endproc && GetMaxId


	*
	* Genera el diffgram
	Procedure GenerarDiffgram(  ) As Void;
			HELPSTRING "Genera el diffgram"
		Local lcCommand As String,;
			lcDiffgram As String
		Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'

		Try

			lcCommand 	= ""
			m.loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

			loXA.AddTableSchema( This.cMainCursorName )

			lcDiffgram 	= loXA.GetDiffGram()

			Use In Select( This.cMainCursorName )

			*!*				TEXT To lcLogDiffgramFile NoShow TextMerge Pretext 15
			*!*				Diffgram_<<This.cMainCursorName>>_<<Seconds()>>.txt
			*!*				ENDTEXT

			*!*				Strtofile( lcDiffgram, lcLogDiffgramFile )



		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loXA = Null

		Endtry

		Return lcDiffgram

	Endproc && GenerarDiffgram




	*
	* Crea los Cursor Adapters para cada tabla
	Procedure CrearCursorAdapters( oParam As Object ) As Void;
			HELPSTRING "Crea los Cursor Adapters para cada tabla"
		Local lcCommand As String,;
			lcDiffgram As String,;
			lcFieldList As String,;
			lcWhereCondition As String

		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
		Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'
		Local loMyCA As CursorAdapterBase Of 'Tools\NameSpaces\Prg\CursorAdapterBase.prg'
		Local llOk As Boolean

		Private pcXMLError As String


		Try

			lcCommand = ""
			pcXMLError = ""

			loColTables = This.oColTables

			lllAlreadyConnected = This.ConnectToBackend() = 0

			For Each loTable In loColTables

				If Vartype( oParam ) = "O"
					If Pemstatus( oParam, "cFilterCriteria", 5 )
						lcWhereCondition = oParam.cFilterCriteria

					Else
						TEXT To lcWhereCondition NoShow TextMerge Pretext 15
						<<loTable.cPKName>> = <<This.nEntidadId>>
						ENDTEXT

					Endif

					If Pemstatus( oParam, "cFieldList", 5 )
						lcFieldList = oParam.cFieldList

					Else
						lcFieldList = " * "

					Endif


				Else
					lcFieldList = " * "
					TEXT To lcWhereCondition NoShow TextMerge Pretext 15
					<<loTable.cPKName>> = <<This.nEntidadId>>
					ENDTEXT

				Endif

				This.ActualizarTimeStamp( loTable.cCursorName )

				lcDiffgram = This.GenerarDiffgram()

				loMyCA = _Newobject("CursorAdapterBase", "Tools\NameSpaces\Prg\CursorAdapterBase.prg",;
					"",;
					This.cAccessType,;
					This.oConnection,;
					This.cBackEndEngine )

				loMyCA.lCloseNativeTables = This.lCloseNativeTables

				If Vartype( loTable.oCursorAdapter ) == "O"
					If Lower( loTable.oCursorAdapter.BaseClass ) = Lower( loMyCA.BaseClass )
						loTable.oCursorAdapter.CursorDetach()
					Endif

					loTable.oCursorAdapter = Null
				Endif

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Select 	<<lcFieldList>> ,
						" " as r7Mov,
						Cast( 0 as I ) as ABM,
						Cast( 0 as I ) as _RecordOrder
					From <<loTable.cTabla>>
					Where <<lcWhereCondition>>
				EndTex

				loMyCA.Alias 				= loTable.cCursorName
				loMyCA.SelectCmd  			= lcCommand
				loMyCA.Tables 				= loTable.cTabla
				loMyCA.UpdatableFieldList 	= loTable.UpdatableFieldList
				loMyCA.UpdateNameList 		= loTable.UpdateNameList
				loMyCA.KeyFieldList 		= loTable.cPKName

				loMyCA.CursorAttach( loTable.cCursorName, .T. )

				llOk = loMyCA.CursorFill()

				If llOk

					* Aplicar Diffgram
					m.loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

					loXA.AddTableSchema( loTable.cCursorName )
					loXA.LoadXML( lcDiffgram )

					Try

						Select Alias( loTable.cCursorName )

						loXA.Tables( 1 ).ApplyDiffgram()

						loTable.oCursorAdapter = loMyCA

					Catch To oErr
						Do Case
						Case oErr.ErrorNo = 1539	&& Trigger failed in "cursor".
							This.lTriggerFailed = .T.

							If Vartype( pcXMLError ) = "C"
								Stop( pcXMLError, "Error de Integridad Referencial" )
							EndIf

						Otherwise
							Throw oErr

						EndCase

					Finally

					EndTry

				Else
					Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

					loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					loError.Cremark = "Falló CursorFill()"
					loError.Process()

				EndIf

			Endfor

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

			loXA	= Null
			loMyCA 	= Null

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

	Endproc && CrearCursorAdapters



	*
	* ConnectToBackend
	*!*		Protected Function ConnectToBackend() As Boolean
	Function ConnectToBackend() As Boolean
		Local lnReturn As Integer


		Try

			lnReturn = This.oBackEnd.Connect()
			This.oConnection = This.oBackEnd.oConnection

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lnReturn

	Endfunc && ConnectToBackend


	*-----------------------------------
	* Se desconecta de la base de datos.
	*-----------------------------------
	*!*		Protected Function DisconnectFromBackend() As Boolean
	Function DisconnectFromBackend() As Boolean

		Local llOk As Boolean
		Try

			llOk = This.oBackEnd.DisConnect()

			This.oConnection = This.oBackEnd.oConnection

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return This.lIsOk

	Endfunc && DisconnectFromBackend

	*
	* Serializes a series of cursors to XML
	Protected Procedure Serialize( tcCommaSeparatedCursorList As String ) As String;
			HELPSTRING "Serializes a series of cursors to XML"


		Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'
		Local lcRetVal As String
		Local i As Integer

		Try

			lcRetVal = ""

			If This.lSerialize
				m.loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

				For i = 1 To Getwordcount( tcCommaSeparatedCursorList, [,] )
					loXA.AddTableSchema( Alltrim( Getwordnum( tcCommaSeparatedCursorList, i, [,] ) ) )

				Endfor

				loXA.PreserveWhiteSpace = .T.
				loXA.ToXML( "lcRetVal" )
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loXA = Null

		Endtry

		Return lcRetVal

	Endproc && Serialize

	*
	* BuildCursor
	Procedure BuildCursor( tcCursorName As String, ;
			tcSelectCmd As String,;
			tnBuffering As Integer,;
			tlDontDetach As Boolean,;
			tlLogSelectCmd As Boolean ) As Object

		Local loMyCA As CursorAdapterBase Of 'Tools\NameSpaces\Prg\CursorAdapterBase.prg'
		Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'
		Local llOk As Boolean
		Local lcAlias As String,;
			lcTableName As String,;
			lcDebugSQL as String

		Local loReturn As Object

		Try

			llOk = .T.
			lcAlias = Sys(2015)
			loReturn = Createobject( "Empty" )
			AddProperty( loReturn, "lOk", llOk )
			AddProperty( loReturn, "oMyCA", Null )
			AddProperty( loReturn, "oXA", Null )

			If Empty( tnBuffering )
				tnBuffering = This.nBuffering
			Endif

			loMyCA = _NewObject("CursorAdapterBase",;
						"Tools\NameSpaces\Prg\CursorAdapterBase.prg",;
						"",;
						This.cAccessType,;
						This.oConnection,;
						This.cBackEndEngine )


			loMyCA.lCloseNativeTables = This.lCloseNativeTables

			loMyCA.cOldSetCentury 	= Set( "Century" )
			loMyCA.cOldSetDate 		= Set( "Date" )

			With loMyCA As CursorAdapter
				.Alias = tcCursorName
				.SelectCmd = tcSelectCmd
				llOk = .CursorFill()

				If !tlDontDetach
					.CursorDetach()

				Else
					* RA 2012-06-17(11:39:02)
					* Devuelve el cursor adapter listo para la actualizacion
					* contra la base de datos


					lcTableName = Getwordnum( This.GetTablesFromSQL( .SelectCmd ), 1, "," )

					*!*						loMyCA.UpdatableFieldList 	= This.GetUpdatableFieldList( lcTableName )
					*!*						loMyCA.UpdateNameList 		= This.GetUpdateNameList( .Alias, "", lcTableName )

					loReturn.oMyCA = loMyCA

					m.loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )
					loXA.AddTableSchema( .Alias )

					loReturn.oXA = loXA

				Endif

				If tlLogSelectCmd Or FileExist( "lDebug.tag" )
					i = AStackInfo( laStack ) - 2

					Text To lcMsg NoShow TextMerge Pretext 03
					*<<Replicate( "-", 30 )>>

					*Programa: <<laStack[ i, 4 ]>>
					*Método:   <<laStack[ i, 3 ]>>
					*Linea:    <<laStack[ i, 5 ]>>

					*<<Replicate( "-", 30 )>>
				ENDTEXT


				lcDebugSQL = Strtran( .SelectCmd, ",", ",;" + CRLF )
				lcDebugSQL = Strtran( lcDebugSQL, " From ",  ";" + CRLF + "From ")
				lcDebugSQL = Strtran( lcDebugSQL, " Left ",  ";" + CRLF + "Left ")
				lcDebugSQL = Strtran( lcDebugSQL, " Right ", ";" + CRLF + "Right ")
				lcDebugSQL = Strtran( lcDebugSQL, " Inner ", ";" + CRLF + "Inner ")
				lcDebugSQL = Strtran( lcDebugSQL, " Where ", ";" + CRLF + "Where ")
				lcDebugSQL = Strtran( lcDebugSQL, " Order ", ";" + CRLF + "Order ")


				Strtofile( lcMsg + CRLF + lcDebugSQL + CRLF, "SelectCommand.prg", 1 )
				Strtofile( "*"+Replicate( "/", 60 ) + CRLF, "SelectCommand.prg", 1 )

			Endif


		Endwith

		If loMyCA.lHasError
			Throw loMyCA.oError

		Else
			If Empty( Txnlevel())
				If CursorGetProp("Buffering", tcCursorName ) # tnBuffering
					CursorSetProp( "Buffering", tnBuffering, tcCursorName )
				Endif
			Endif
		Endif



	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		llOk = .F.
		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loMyCA = Null

	Endtry

	Return loReturn

Endproc && BuildCursor


*
* oBackEnd_Access
	Protected Procedure oBackEnd_Access()

		If Vartype( This.oBackEnd ) # "O"
			Do Case
				Case Upper(This.cAccessType)="NATIVE"
					This.oBackEnd = Newobject( "NativeBackEnd",;
						"fw\tieradapter\datatier\BackEndNative.prg" )

					This.oBackEnd.lUseDBC 			= This.lUseDBC
					This.oBackEnd.lUseTransactions 	= This.lUseTransactions

				Case Upper(This.cAccessType)="ODBC"
					This.oBackEnd = Newobject( "ODBCBackEnd",;
						"BackEndODBC.prg" )

					This.lUseDBC 			= .T.
					This.lUseTransactions 	= .T.

				Case Upper(This.cAccessType)="ADO"
					This.oBackEnd = Newobject( "ADOBackEnd",;
						"BackEndADO.prg" )

					This.lUseDBC 			= .T.
					This.lUseTransactions 	= .T.

				Otherwise
					Error "Data Access Type Not Recognized"

			Endcase

			If This.lUseDBC
				With This.oBackEnd As BackEnd Of "TierAdapter\DataTier\BackEnd.prg"
					.cDataBaseName 		= This.cDataBaseName
					.cStringConnection 	= This.cStringConnection
					.cBackEndEngine 	= This.cBackEndEngine
				Endwith
			Endif
		Endif

		Return This.oBackEnd

	Endproc && oBackEnd_Access



	*
	*
	Procedure TransactionBegin(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			This.lIsOk = This.oBackEnd.BeginTransaction()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && TransactionBegin



	*
	*
	Procedure TransactionEnd(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			This.lIsOk = This.oBackEnd.EndTransaction()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && TransactionEnd


	*
	*
	Procedure TransactionRollBack(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			This.oBackEnd.Rollback()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && TransactionRollBack



	*
	* Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla
	Procedure GetUpdatableFieldListFromTable( tcTableName As String,;
			tcExcludeFieldList As String,;
			tcAlias as Character ) As Void;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String,;
			lcExact As String,;
			lcAlias as String 

		Local Array laFields[ 1 ]

		Local lnLen As Integer,;
			i As Integer

		Local llInList As Boolean

		Try

			lcCommand = ""
			lcFieldList = ""

			lcExact = Set("Exact")
			Set Exact On
			
			If Empty( tcAlias )
				lcAlias = "" 
				
			Else
				lcAlias = Alltrim( tcAlias ) + "."	
			EndIf

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_-_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			lnLen = Afields( laFields, tcTableName )

			For i = 1 To lnLen
				lcField = laFields[ i, 1 ]

				TEXT To lcCommand NoShow TextMerge Pretext 15
					InList( '<<Lower( lcField )>>', <<tcExcludeFieldList>> )
				ENDTEXT

				&lcCommand


				llInList = &lcCommand

				If !llInList
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
							,<<lcAlias>><<lcField>>
					ENDTEXT
				Endif

			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Set Exact &lcExact

		Endtry

		Return lcFieldList

	Endproc && GetUpdatableFieldListFromTable

	*
	* Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla
	Procedure GetUpdateNameListFromTable( tcCursorName As String,;
			tcExcludeFieldList As String,;
			tcTableName As String ) As Void;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String,;
			lcExact As String

		Local Array laFields[ 1 ]

		Local lnLen As Integer,;
			i As Integer

		Try

			lcCommand = ""
			lcFieldList = ""

			lcExact = Set("Exact")
			Set Exact On

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_-_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			lnLen = Afields( laFields, tcTableName )

			For i = 1 To lnLen
				lcField = laFields[ i, 1 ]

				TEXT To lcCommand NoShow TextMerge Pretext 15
				InList( '<<Lower( lcField )>>', <<tcExcludeFieldList>> )
				ENDTEXT

				llInList = &lcCommand

				If !llInList
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
					,<<lcField>> <<tcTableName>>.<<lcField>>
					ENDTEXT

				Endif
			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Set Exact &lcExact

		Endtry

		Return lcFieldList

	Endproc && GetUpdateNameListFromTable



	*
	* Devuelve la lista de campos que se actualizan a partir del Diccionario de Datos
	Procedure GetUpdatableFieldList( tcTableName As String,;
			tcExcludeFieldList As String,;
			lIncludeVirtualCommand As Boolean ) As String ;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String,;
			lcExact As String

		Local llInList As Boolean

		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
		Local loColFields As ColFields Of 'Tools\DataDictionary\prg\ColFields.prg'
		Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'


		Try

			lcCommand = ""
			lcFieldList = ""

			lcExact = Set("Exact")
			Set Exact On

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_/-\_"]

			Else
				tcExcludeFieldList = Strtran( tcExcludeFieldList, " ", "" )
				tcExcludeFieldList = Strtran( tcExcludeFieldList, "'", "" )
				tcExcludeFieldList = Strtran( tcExcludeFieldList, "[", "" )
				tcExcludeFieldList = Strtran( tcExcludeFieldList, "]", "" )
				tcExcludeFieldList = Strtran( tcExcludeFieldList, ["], "" )
				tcExcludeFieldList = Strtran( tcExcludeFieldList, [,], [","] )
				tcExcludeFieldList = ["] + tcExcludeFieldList + ["]

			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			loColTables = NewColTables()
			loTable = loColTables.GetItem( tcTableName )
			loColFields = loTable.oColFields
			lcFieldList = ""

			For Each loField In loColFields
				lcField = Lower( loField.Name )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				InList( '<<lcField>>', <<tcExcludeFieldList>> )
				ENDTEXT

				llInList = &lcCommand

				If !llInList

					If loField.lIsVirtual
						If lIncludeVirtualCommand
							If !Empty( loField.cVirtualCommand )
								TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
								,<<loField.cVirtualCommand>>
								ENDTEXT

							Else
								* RA 2013-10-21(16:45:24)
								* Armar el comando en funcion del tipo

								*!*									Text To lcCommand NoShow TextMerge Pretext 15
								*!*									( Cast "" as <<loField.nFieldWidth>> ) as <<lcField>>
								*!*									EndText
								*!*
								*!*									loField.nFieldWidth
								*!*									loField.nFieldPrecision

							Endif
						Endif



					Else
						TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
							,<<lcField>>
						ENDTEXT

					Endif




				Endif
			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Set Exact &lcExact

		Endtry

		Return lcFieldList

	Endproc && GetUpdatableFieldList

	*
	* Devuelve la lista de campos que se actualizan a partir del Diccionario de Datos
	Procedure GetUpdateNameList( tcCursorName As String,;
			tcExcludeFieldList As String,;
			tcTableName As String ) As Void;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String,;
			lcExact As String

		Local llInList As Boolean

		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
		Local loColFields As ColFields Of 'Tools\DataDictionary\prg\ColFields.prg'
		Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'


		Try

			lcCommand = ""
			lcFieldList = ""

			lcExact = Set("Exact")
			Set Exact On

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_/-\_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			loColTables = NewColTables()
			loTable = loColTables.GetItem( tcTableName )
			loColFields = loTable.oColFields
			lcFieldList = ""

			For Each loField In loColFields
				lcField = Lower( loField.Name )


				TEXT To lcCommand NoShow TextMerge Pretext 15
					InList( '<<lcField>>', <<tcExcludeFieldList>> )
				ENDTEXT

				llInList = &lcCommand

				If !llInList
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
					,<<lcField>> <<tcTableName>>.<<lcField>>
					ENDTEXT


				Endif

			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Set Exact &lcExact

		Endtry

		Return lcFieldList

	Endproc && GetUpdateNameList

	*
	* Devuelve la lista de campos que se utilizan en el comando Insert Into
	Procedure GetInsertFieldList( tcTableName As String,;
			tcExcludeFieldList As String ) As String ;
			HELPSTRING "Devuelve la lista de campos que se utilizan en el comando Insert Into"
		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String,;
			lcExact As String

		Local llInList As Boolean

		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
		Local loColFields As ColFields Of 'Tools\DataDictionary\prg\ColFields.prg'
		Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'


		Try

			lcCommand = ""
			lcFieldList = ""

			lcExact = Set("Exact")
			Set Exact On

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_/-\_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			loColTables = NewColTables()
			loTable = loColTables.GetItem( tcTableName )
			loColFields = loTable.oColFields
			lcFieldList = ""

			For Each loField In loColFields

				If !Empty( loField.Default )

					lcField = Lower( loField.Name )

					TEXT To lcCommand NoShow TextMerge Pretext 15
					InList( '<<lcField>>', <<tcExcludeFieldList>> )
					ENDTEXT

					llInList = &lcCommand

					If !llInList

						TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
						,<<lcField>>
						ENDTEXT

					Endif

				Endif

			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Set Exact &lcExact

		Endtry

		Return lcFieldList

	Endproc && GetInsertFieldList

	*
	* Devuelve la lista de valores por default que se utiliza en el comando Insert Into
	Procedure GetInsertFieldsValues( tcTableName As String,;
			tcExcludeFieldList As String ) As String ;
			HELPSTRING "Devuelve la lista de valores por default que se utiliza en el comando Insert Into"
		Local lcCommand As String,;
			lcValueList As String,;
			lcField As String,;
			lcValue As String,;
			lcVartType As String,;
			lcExact As String

		Local llInList As Boolean

		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
		Local loColFields As ColFields Of 'Tools\DataDictionary\prg\ColFields.prg'
		Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'


		Try

			lcCommand = ""
			lcValueList = ""

			lcExact = Set("Exact")
			Set Exact On

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_/-\_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			loColTables = NewColTables()
			loTable = loColTables.GetItem( tcTableName )
			loColFields = loTable.oColFields
			lcValueList = ""

			For Each loField In loColFields

				If !Empty( loField.Default )

					lcField = Lower( loField.Name )

					TEXT To lcCommand NoShow TextMerge Pretext 15
					InList( '<<lcField>>', <<tcExcludeFieldList>> )
					ENDTEXT

					llInList = &lcCommand

					If !llInList

						lcVartType = Vartype( loField.Default )

						Do Case
							Case Inlist( lcVartType, "C", "Q" )
								lcValue = ['] + loField.Default + [']

							Otherwise
								lcValue = Transform( loField.Default )

						Endcase

						TEXT To lcValueList NoShow TextMerge Pretext 15 ADDITIVE
						,<<lcValue>>
						ENDTEXT

					Endif

				Endif

			Endfor

			lcValueList = Substr( lcValueList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Set Exact &lcExact

		Endtry

		Return lcValueList

	Endproc && GetInsertFieldsValues



	*
	* Devuelve una lista de tuplas para utilizar en el comando Update
	Procedure GetUpdateFieldsValues( tcTableName As String,;
			tcFromAlias As String,;
			tcExcludeFieldList As String ) As String ;
			HELPSTRING "Devuelve una lista de tuplas para utilizar en el comando Update"
		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String,;
			lcExact As String

		Local llInList As Boolean

		Local loColTables As ColTables Of 'Tools\DataDictionary\prg\ColTables.prg'
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
		Local loColFields As ColFields Of 'Tools\DataDictionary\prg\ColFields.prg'
		Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'


		Try

			lcCommand = ""
			lcFieldList = ""

			lcExact = Set("Exact")
			Set Exact On

			If Empty( tcFromAlias )
				Error "Falta definir el alias en " + Program()
			Endif

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_/-\_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			loColTables = NewColTables()
			loTable = loColTables.GetItem( tcTableName )
			loColFields = loTable.oColFields
			lcFieldList = ""

			For Each loField In loColFields

				If !loField.lIsVirtual
					* Actualiza solo los campos reales

					lcField = Lower( loField.Name )

					TEXT To lcCommand NoShow TextMerge Pretext 15
					InList( '<<lcField>>', <<tcExcludeFieldList>> )
					ENDTEXT

					llInList = &lcCommand
					lcCommand = ""

					If !llInList
						If !Empty( Field( lcField, tcFromAlias ))

							TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
							,<<lcField>> = <<tcFromAlias>>.<<lcField>>
							ENDTEXT

						EndIf
					Endif
				Endif

			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Set Exact &lcExact

		Endtry

		Return lcFieldList

	Endproc && GetUpdateFieldsValues


	*
	* GetTablesFromSQL
	* DAE 2009-10-21(13:42:12)
	Protected Function GetTablesFromSQL( tcSQL As String ) As String
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
		Local lcCommand As String
		Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'


		Try

			lcCommand = ""

			If Empty( This.cDataBaseName )

				m.loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

				loXA.LoadXML( This.cBackEndCfgFileName, .T. )
				loXA.Tables(1).ToCursor()
				loXA = Null

				Locate For Alltrim( Lower( objName )) = Alltrim( Lower( This.cDataConfigurationKey ))
				If Eof()
					Locate For Alltrim( Lower(objName)) = "default"
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
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry

		Return This.lIsOk

	Endproc && ReadIniFile



	*
	*
	Procedure ActualizarTimeStamp( cCursorName As String ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If !Empty( Field( "TS", cCursorName ) )

				Select Alias( cCursorName )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update <<cCursorName>> Set
					TS = Datetime()
				ENDTEXT

				&lcCommand

				Locate

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && ActualizarTimeStamp

	*
	* cDataBaseName_Access
	Protected Procedure cDataBaseName_Access()

		If Empty( This.cDataBaseName )
			This.ReadIniFile()
		Endif
		Return This.cDataBaseName

	Endproc && cDataBaseName_Access

	*
	* cDataBaseName_Access
	Protected Procedure cBackEndCfgFileName_Access()

		If Empty( This.cBackEndCfgFileName )
			This.cBackEndCfgFileName = Addbs( This.cRootFolder ) + "DataTier.xml"
		Endif
		Return This.cBackEndCfgFileName

	Endproc && cBackEndCfgFileName _Access


	*
	*
	Procedure Destroy(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			DoDefault()

			This.oColTables = Null

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Destroy



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Entity
*!*
*!* ///////////////////////////////////////////////////////