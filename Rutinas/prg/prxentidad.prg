*!* ///////////////////////////////////////////////////////
*!* Class.........: Entidad
*!* ParentClass...: prxEntity Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\prxEntity.prg'
*!* BaseClass.....: Session
*!* Description...: Abstract Entity para Clipper2Fox
*!* Date..........: Viernes 5 de Julio de 2013 (15:16:34)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\TierAdapter\Include\TA.h"

Define Class Entidad As prxEntity Of 'v:\CloudFox\Fw\Tieradapter\Comun\prxEntity.prg'

	#If .F.
		Local This As Entidad Of "Rutinas\Prg\prxEntidad.prg"
	#Endif

	* Valor de la clave del último alta
	nNewId = -1

	* Carpeta donde se encuentra la tabla
	cTableFolder = ""

	* Nombre real de la tabla
	cRealTableName = ""

	* Cantidad de indices IDX
	nIndices = 0

	* Nombre de la maquina actual
	cTerminal = ""

	* Nombre del Usuario loggeado en Windows
	cWinUser = ""

	* Indica si son tablas libres o utiliza una DBC
	lUseDBC = .F.

	* Contiene el valor de la variable WCLAV
	WCLAV = "A"

	* Nombre del campo que contiene la descripcion
	cDescriptionField = "Nombre"

	* Parametros especiales para consulta con WCLAV = "A"
	oQuery_A = Null
	oQuery_B = Null
	oQuery_M = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="getfieldlist" type="method" display="GetFieldList" />] + ;
		[<memberdata name="nnewid" type="property" display="nNewId" />] + ;
		[<memberdata name="abrirtabla" type="method" display="AbrirTabla" />] + ;
		[<memberdata name="creartabla" type="method" display="CrearTabla" />] + ;
		[<memberdata name="cerrartabla" type="method" display="CerrarTabla" />] + ;
		[<memberdata name="ctablefolder" type="property" display="cTableFolder" />] + ;
		[<memberdata name="crealtablename" type="property" display="cRealTableName" />] + ;
		[<memberdata name="nindices" type="property" display="nIndices" />] + ;
		[<memberdata name="abririndices" type="method" display="AbrirIndices" />] + ;
		[<memberdata name="cterminal" type="property" display="cTerminal" />] + ;
		[<memberdata name="cterminal_access" type="method" display="cTerminal_Access" />] + ;
		[<memberdata name="cwinuser" type="property" display="cWinUser" />] + ;
		[<memberdata name="cwinuser_access" type="method" display="cWinUser_Access" />] + ;
		[<memberdata name="lusedbc" type="property" display="lUseDBC" />] + ;
		[<memberdata name="wclav" type="property" display="WCLAV" />] + ;
		[<memberdata name="wclav_assign" type="method" display="WCLAV_Assign" />] + ;
		[<memberdata name="selectfromlist" type="method" display="SelectFromList" />] + ;
		[<memberdata name="cdescriptionfield" type="property" display="cDescriptionField" />] + ;
		[<memberdata name="validartabla" type="method" display="ValidarTabla" />] + ;
		[<memberdata name="reindex" type="method" display="Reindex" />] + ;
		[<memberdata name="oquery_a" type="property" display="oQuery_A" />] + ;
		[<memberdata name="oquery_b" type="property" display="oQuery_B" />] + ;
		[<memberdata name="oquery_m" type="property" display="oQuery_M" />] + ;
		[</VFPData>]

	* WCLAV_Assign

	Protected Procedure WCLAV_Assign( uNewValue )

		This.WCLAV = uNewValue

	Endproc && WCLAV_Assign

	*
	*
	Procedure Init(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			DoDefault()
			This.Initialize()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Init


	Procedure ClassBeforeInitialize( uParam )
		Return .T.
	Endproc


	Procedure HookBeforeInitialize( uParam )
		Return .T.
	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Initialize
	*!* Description...:
	*!* Date..........: Domingo 7 de Julio de 2013 (16:34:20)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Clipper2Fox
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Initialize( uParam As Variant ) As Boolean

		Try


			If This.ClassBeforeInitialize()
				If This.HookBeforeInitialize()

					DoDefault()

					This.HookAfterInitialize()
					This.ClassAfterInitialize()

				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry


	Endfunc
	*!*
	*!* END FUNCTION Initialize
	*!*
	*!* ///////////////////////////////////////////////////////

	Procedure HookAfterInitialize( uParam )
	Endproc

	Procedure ClassAfterInitialize( uParam )
		This.AbrirTabla()
	Endproc


	*
	* Abre las tablas necesarias
	Procedure AbrirTabla(  ) As Integer ;
			HELPSTRING "Abre las tablas necesarias"
		Local lcCommand As String,;
			lcFullTableName As String
		Local lnReturn As Integer

		Local loTable As FreeTable Of "Clientes\Pyme\SYNC_PYME.prg",;
			loColTables As oColTables Of "Tools\DataDictionary\prg\oColTables.prg",;
			loSync As oSync Of 'Tools\DataDictionary\Prg\oSync.prg'

		Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loFiltro As Object,;
			loColFiltros As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg


		Local llAbre As Boolean

		Try

			lcCommand = ""
			lnReturn = 0

			*loSync = _NewObject( 'oSync', 'Tools\DataDictionary\Prg\oSync.prg' )
			loSync = This.oBackEnd.oSync
			loColTables = This.oColTables

			For Each loTable In loColTables

				llAbre = ( CLAVE > 0 Or loTable.WCLAV = "A" )

				If llAbre

					If Empty( loTable.cRealTableName )
						loTable.cRealTableName = loTable.Name
					Endif

					TEXT To lcFullTableName NoShow TextMerge Pretext 15
					<<Addbs( loTable.cFolder )>><<loTable.cRealTableName>>.<<loTable.cExt>>
					ENDTEXT

					If !FileExist( Defaultext( lcFullTableName, "dbf" ) )
						loSync.ProcessTable( loTable )
						Use In Select( loTable.cLongTableName )
					Endif

					If !Used( loTable.cLongTableName )
						lnReturn = 1

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Use '<<lcFullTableName >>' Again Shared In 0 Alias <<loTable.cLongTableName>>
						ENDTEXT

						&lcCommand

						This.AbrirIndices( loTable )

					Endif

					If Used( loTable.cLongTableName )
						loGlobalSettings = NewGlobalSettings()
						loColFiltros = loGlobalSettings.oColFilters
						loFiltro = loColFiltros.GetItem( loTable.cLongTableName )
						If Vartype( loFiltro ) = "O"
							TEXT To lcCommand NoShow TextMerge Pretext 15
							Set Filter To
							<<loFiltro.cFiltro>>
							In <<loFiltro.cTabla>>
							ENDTEXT

							&lcCommand

						Endif
					Endif


				Endif
			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			*!* DEBUG_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loFiltro = Null
			loColFiltros = Null
			loGlobalSettings = Null

		Endtry


		Return lnReturn

	Endproc && AbrirTabla

	*
	*
	Procedure CerrarTabla(  ) As Void
		Local lcCommand As String
		Local loTable As FreeTable Of "Clientes\Pyme\SYNC_PYME.prg",;
			loColTables As oColTables Of "Tools\DataDictionary\prg\oColTables.prg"

		Try

			lcCommand = ""

			loColTables = This.oColTables

			For Each loTable In loColTables
				Use In Select( loTable.cLongTableName )
			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && CerrarTablas


	*
	* Crea la tabla
	Procedure CrearTabla(  ) As Void;
			HELPSTRING "Crea la tabla"

		Local lcCommand As String,;
			lcFullTableName As String

		Local loColTables As oColTables Of "Tools\DataDictionary\Prg\oColTables.prg"
		Local loTable As FreeTable Of "Clientes\Pyme\SYNC_PYME.prg"

		Local loSync As oSync Of 'Tools\DataDictionary\Prg\oSync.prg'

		Try

			lcCommand = ""

			loSync = This.oBackEnd.oSync

			loColTables = This.oColTables
			loTable = loColTables.GetItem( This.cMainTableName )

			loSync.CreateTable( loTable )
			loSync.CreateIndexesInFreeTable( loTable )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loTable 	= Null
			loColTables = Null
			loSync 		= Null

		Endtry

	Endproc && CrearTabla




	*
	* Valida la estructura de la tabla
	Procedure ValidarTabla(  ) As Void;
			HELPSTRING "Valida la estructura de la tabla"
		Local lcCommand As String
		Local loTable As FreeTable Of "Clientes\Pyme\SYNC_PYME.prg",;
			loColTables As oColTables Of "Tools\DataDictionary\prg\oColTables.prg",;
			loSync As oSync Of 'Tools\DataDictionary\Prg\oSync.prg'

		Try

			lcCommand = ""
			loSync = This.oBackEnd.oSync
			loColTables = This.oColTables

			For Each loTable In loColTables
				If !loSync.Synchronize( loTable )
					loSync.ProcessTable( loTable )
				Endif
			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			*!* DEBUG_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loSync = Null
			loTable = Null
			loColTables = Null

		Endtry

	Endproc && ValidarTabla


	*
	* Abre los Indices IDX
	Procedure AbrirIndices( toTable As oTable ) As Void;
			HELPSTRING "Abre los Indices IDX"
		Local lcCommand As String,;
			lcFullTableName As String
		Local i As Integer,;
			lnLen As Integer
		Local loTable As FreeTable Of "Clientes\Pyme\SYNC_PYME.prg"

		Try

			lcCommand = ""

			loTable = toTable

			If Used( loTable.cLongTableName )

				Select Alias( loTable.cLongTableName )

				Set Index To

				TEXT To lcFullTableName NoShow TextMerge Pretext 15
				<<Addbs( loTable.cFolder )>><<loTable.cRealTableName>>
				ENDTEXT

				If This.nIndices = -1

					lnLen = Adir( laDir, lcFullTableName + "*.Idx" )

					For i = 1 To lnLen
						TEXT To lcCommand NoShow TextMerge Pretext 15
						Set Index To '<<Addbs( loTable.cFolder )>><<laDir[ i, 1 ]>>' Additive
						ENDTEXT

						&lcCommand
					Endfor

				Else
					For i = 1 To This.nIndices
						If i > 9
							k = Chr( Asc( "A" ) - 10 + i )

						Else
							k = i

						Endif

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Set Index To '<<lcFullTableName>><<k>>' Additive
						ENDTEXT

						&lcCommand
					Endfor


				Endif



				Set Order To

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && AbrirIndices




	*
	* Regenera los indices
	Procedure Reindex(  ) As Void;
			HELPSTRING "Regenera los indices"
		Local lcCommand As String

		Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
			loColIndexes As oColIndexes Of 'Tools\DataDictionary\prg\oColIndexes.prg', ;
			loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
			loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
			loIndex As oIndice Of "Clientes\Utiles\Prg\utRutina.prg"

		Local loTable As FreeTable Of "Clientes\Pyme\SYNC_PYME.prg"
		Local loSync As oSync Of 'Tools\DataDictionary\Prg\oSync.prg'

		Try

			lcCommand = ""

			loSync = This.oBackEnd.oSync

			loColTables = This.oColTables
			loTable = loColTables.GetItem( This.cMainTableName )

			loSync.GenerateIndexes( loTable )
			loSync.CreateIndexesInFreeTable( loTable )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loTable 	= Null
			loColTables = Null
			loSync 		= Null

		Endtry

	Endproc && Reindex



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

			If This.Validar( )

				*!*					This.AbrirIndices()

				TEXT To lcCommand NoShow TextMerge Pretext 15
				nEntidadId = <<This.nEntidadId>>
				ENDTEXT

				oParam = ObjParam( lcCommand, oParam )

				llOk = This.Put( oParam )

				This.nAction = 0

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			This.nAction = 0

		Endtry

		Return llOk

	Endproc && Guardar

	Procedure GetByWhere( oParam As Object ) As Integer

		Local lcCommand As String
		Local lnTally As Integer

		Try

			lcCommand = ""
			lnTally = DoDefault( oParam )
			Do Case
				Case This.WCLAV = "A"
					This.oQuery_A = This.oRequery

				Case This.WCLAV = "B"
					This.oQuery_B = This.oRequery

				Case This.WCLAV = "M"
					This.oQuery_M = This.oRequery

			Endcase

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return lnTally

	Endproc && GetByWhere

	*
	*
	Procedure GuardarVarios( oParam As Object ) As Void
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

				llOk = This.GrabarCambios( oParam )

				This.nAction = 0

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry
		Return llOk

	Endproc && GuardarVarios


	*
	*
	Procedure GrabarCambios( oParam As Object ) As Void
		Local lcCommand As String,;
			lcAlias As String,;
			lcMessage As String,;
			lcDeleted As String,;
			lcUpdateFieldsList As String,;
			lcExcludeFieldList As String

		Local lnAltas As Integer,;
			lnBajas As Integer,;
			lnModificaciones As Integer,;
			lnId As Integer,;
			lnLen As Integer,;
			i As Integer

		Local llDone As Boolean

		Try

			lcCommand = ""
			lcMessage = ""
			lcDeleted = Set("Deleted")
			Set Deleted Off

			Wait Window Nowait Noclear "Actualizando Datos ....."

			lcAlias = This.cMainCursorName

			If !Empty( Field( "TS", lcAlias ) )
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update <<lcAlias>> Set
					TS = Datetime()
				ENDTEXT

				&lcCommand
			Endif

			*!*				Select Alias( lcAlias )
			*!*				Browse

			This.AbrirTabla()

			Use In Select( "cAltas" )
			Use In Select( "cBajas" )
			Use In Select( "cModificaciones" )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From <<lcAlias>>
				With ( Buffering = .T. )
				Where ABM = <<ABM_ALTA>>
				Into Cursor cAltas ReadWrite
			ENDTEXT

			&lcCommand
			lnAltas = _Tally

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From <<lcAlias>>
				With ( Buffering = .T. )
				Where ABM = <<ABM_BAJA>>
				Into Cursor cBajas ReadWrite
			ENDTEXT

			&lcCommand
			lnBajas = _Tally
			Recall All In cBajas

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From <<lcAlias>>
				With ( Buffering = .T. )
				Where ABM = <<ABM_MODIFICACION>>
				Into Cursor cModificaciones ReadWrite
			ENDTEXT

			&lcCommand

			lnModificaciones = _Tally

			Set Deleted &lcDeleted

			If !Empty( lnModificaciones )

				TEXT To lcExcludeFieldList NoShow TextMerge Pretext 15
				"<<This.cPKField>>"
				ENDTEXT

				lcUpdateFieldsList = This.GetUpdateFieldsValues( This.cMainTableName,;
					"cModificaciones",;
					lcExcludeFieldList )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update <<This.cMainTableName>> Set
							<<lcUpdateFieldsList>>
						From cModificaciones
						Where <<This.cMainTableName>>.<<This.cPKField>> = cModificaciones.<<This.cPKField>>

				ENDTEXT

				LogSelectCommand( lcCommand )

				If This.ExecuteNonQuery( lcCommand )
					llDone = .T.

					TEXT To lcMessage NoShow TextMerge Pretext 03 ADDITIVE
					<<_Tally>> registros modificados

					ENDTEXT

				Else
					llDone = .F.

				Endif

			Endif

			* Bajas
			If !Empty( lnBajas )
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Delete <<This.cMainTableName>>
					From cBajas
					Where <<This.cMainTableName>>.<<This.cPKField>> = cBajas.<<This.cPKField>>
				ENDTEXT

				If This.ExecuteNonQuery( lcCommand )
					llDone = .T.

					TEXT To lcMessage NoShow TextMerge Pretext 03 ADDITIVE
					<<_Tally>> registros eliminados

					ENDTEXT

				Else
					llDone = .F.

				Endif

			Endif

			* Altas
			If !Empty( lnAltas )

				Flock( This.cMainTableName )

				lnId = This.GetMaxId( This.cMainTableName, This.cPKField )

				Select cAltas
				Locate
				Scan
					lnId = lnId + 1

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Replace <<This.cPKField>> With lnId
					ENDTEXT

					&lcCommand

					If !( Upper( This.cPKField ) == "ID" )
						If !Empty( Field( "ID", This.cMainTableName ))
							Replace Id With lnId
						Endif
					Endif

				Endscan

				lcExcludeFieldList = ""
				lnLen = Afields( paFields, This.cMainTableName )

				For i = 1 To lnLen
					If Empty( Field( paFields[ i, 1 ], "cAltas" ))

						lcExcludeFieldList = lcExcludeFieldList + ",[" + paFields[ i, 1 ] + "]"

					Endif

				Endfor

				lcUpdateFieldsList = This.GetUpdatableFieldList( This.cMainTableName, lcExcludeFieldList )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Insert Into <<This.cMainTableName>> (
							<<lcUpdateFieldsList>> )
						Select
							<<lcUpdateFieldsList>>
					From cAltas
				ENDTEXT

				If This.ExecuteNonQuery( lcCommand )
					llDone = .T.

					TEXT To lcMessage NoShow TextMerge Pretext 03 ADDITIVE
					<<_Tally>> registros agregados

					ENDTEXT

				Else
					llDone = .F.

				Endif

				Unlock In ( This.cMainTableName )

			Endif

			Wait Clear

			If !Empty( lcMessage )
				Inform( lcMessage, "Actualización de " + This.cRealTableName, 2 )
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Wait Clear
			Use In Select( "cAltas" )
			Use In Select( "cBajas" )
			Use In Select( "cModificaciones" )
			Set Deleted &lcDeleted

			If Used( This.cMainTableName )
				Unlock In ( This.cMainTableName )
			Endif

			This.CerrarTabla()

		Endtry

	Endproc && GrabarCambios

	*
	* cTerminal_Access
	Protected Procedure cTerminal_Access()

		If Empty( This.cTerminal )
			This.cTerminal = Alltrim( Substr( Sys(0), 1, At( "#", Sys(0) ) - 1 ) )
		Endif

		Return This.cTerminal

	Endproc && cTerminal_Access

	*
	* cWinUser_Access
	Protected Procedure cWinUser_Access()

		If Empty( This.cWinUser )
			This.cWinUser = Alltrim( Substr( Sys(0), At( "#", Sys(0)) + 1 ) )
		Endif
		Return This.cWinUser

	Endproc && cWinUser_Access


	* Permite personalizar la obtención del nuevo Id
	* Si devuelve -1, se considera que es autonumérico y lo resuelve la clase BackEnd
	* Si la clave no es numerica, debe personalizarse en cada entidad
	Procedure GetMaxId( tcTable As String, tcPKName As String ) As Integer

		Local lcCommand As String
		Local lnNewId As Integer

		Try

			lcCommand 	= ""

			If This.lUseDBC
				lnNewId = This.nNewId

			Else
				lnNewId = GetMaxId( tcTable,;
					tcPKName )

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lnNewId

	Endproc && GetMaxId


	*
	* ConnectToBackend
	Function ConnectToBackend() As Boolean
		Local lnReturn As Integer


		Try

			If This.lUseDBC
				lnReturn = DoDefault()

			Else
				lnReturn = This.AbrirTabla()

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lnReturn

	Endfunc && ConnectToBackend


	*-----------------------------------
	* Se desconecta de la base de datos.
	*-----------------------------------

	Function DisconnectFromBackend() As Boolean

		Local llOk As Boolean
		Try

			This.oConnection = This.oBackEnd.oConnection

			If This.lUseDBC
				llOk = DoDefault()

			Else
				llOk = This.CerrarTabla()

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endfunc && DisconnectFromBackend



	*
	* Muestra un listbox que permite seleccionar la entidad
	Procedure SelectFromList( nRow As Integer,;
			nCol As Integer,;
			nSelected As Integer,;
			lShow As Boolean,;
			cFilterCriteria As String,;
			cCaption As String ) As Integer ;
			HELPSTRING "Muestra un listbox que permite seleccionar la entidad"

		Local lcCommand As String,;
			lcAlias As String

		Local lnEntidadId As Integer,;
			i As Integer,;
			lnSelected  As Integer

		Local loCollection As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg
		Local loItem As Object,;
			loParam As Object

		Try

			lcCommand = ""
			lnEntidadId = 0
			lcAlias = Alias()

			If Empty( cCaption )
				cCaption = This.Name
			Endif
			i = 0

			If Empty( nSelected )
				nSelected = 0
			Endif

			lnSelected  = nSelected

			If !Empty( cFilterCriteria )
				This.cFilterCriteria = cFilterCriteria
			Endif

			If !Empty( This.GetAll() )

				loCollection = Newobject( "CollectionBase", "Tools\namespaces\prg\CollectionBase.prg" )

				Select Alias( This.cMainCursorName )
				Locate

				Scan

					i = i + 1
					loItem = Createobject( "Empty" )
					AddProperty( loItem, "Caption", Alltrim( Evaluate( This.cDescriptionField )))
					AddProperty( loItem, "Id", Int( Evaluate( This.cPKField )))
					AddProperty( loItem, "Visible", .T. )
					AddProperty( loItem, "Order", Int( i ))

					If Empty( nSelected )
						lnSelected = i
					Endif

					If Int( Evaluate( This.cPKField )) = lnSelected
						lnSelected = i
					Endif

					loCollection.Add( loItem, Transform( loItem.Id ) )

				Endscan

				If !Empty( i )
					loParam = Createobject( "Empty" )
					AddProperty( loParam, "oColItems", loCollection )

					lnEntidadId = S_Opcion( nRow,;
						nCol,;
						0,;
						0,;
						"",;
						lnSelected,;
						lShow,;
						cCaption,;
						loParam )

				Else
					lnEntidadId = 0

				Endif
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			*!* DEBUG_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif


		Endtry

		Return lnEntidadId

	Endproc && SelectFromList

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Entidad
*!*
*!* ///////////////////////////////////////////////////////