#INCLUDE "FW\Comunes\Include\Praxis.h"

Define Class Talonario As Entidad Of "V:\Clipper2fox\Rutinas\Prg\prxEntidad.prg"

	#If .F.
		Local This As Talonario Of "Fw\Comunes\Prg\Talonario.prg"
	#Endif


	* Criterio de busqueda por defecto
	cFilterCriteria = "( 1 > 0 )"

	* Id del modulo al que pertenece el talonario
	nModuloId = 0

	cxMainTableName 	= ""
	cxMainCursorName 	= ""
	cxTableFolder 		= ""
	cxRealTableName 	= ""

	caMainTableName 	= ""
	caMainCursorName 	= ""
	caTableFolder 		= ""
	caRealTableName 	= ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="nmoduloid" type="property" display="nModuloId" />] + ;
		[<memberdata name="grabarsiguientenumero" type="method" display="GrabarSiguienteNumero" />] + ;
		[<memberdata name="obtenerultimonumero" type="method" display="ObtenerUltimoNumero" />] + ;
		[<memberdata name="obtenersiguientenumero" type="method" display="ObtenerSiguienteNumero" />] + ;
		[<memberdata name="obtenertalonario" type="method" display="ObtenerTalonario" />] + ;
		[<memberdata name="actualizarnumero" type="method" display="ActualizarNumero" />] + ;
		[<memberdata name="cxmaintablename" type="property" display="cxMainTableName" />] + ;
		[<memberdata name="cxmaincursorname" type="property" display="cxMainCursorName" />] + ;
		[<memberdata name="cxtablefolder" type="property" display="cxTableFolder" />] + ;
		[<memberdata name="cxrealtablename" type="property" display="cxRealTableName" />] + ;
		[<memberdata name="camaintablename" type="property" display="caMainTableName" />] + ;
		[<memberdata name="camaincursorname" type="property" display="caMainCursorName" />] + ;
		[<memberdata name="catablefolder" type="property" display="caTableFolder" />] + ;
		[<memberdata name="carealtablename" type="property" display="caRealTableName" />] + ;
		[</VFPData>]



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: HookBeforeInitialize
	*!* Description...:
	*!* Date..........: Domingo 7 de Julio de 2013 (16:34:20)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Clipper2Fox
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure HookBeforeInitialize( ) As Boolean

		Local lcCommand As String

		Try

			lcCommand = ""

			* Alias de la Tabla
			This.caMainTableName 	= "Talonarios"
			This.cxMainTableName 	= "xTalonarios"

			* Alias del cursor transitorio
			This.caMainCursorName 	= "cTalonarios"
			This.cxMainCursorName 	= "cxTalonarios"

			* Campo clave
			This.cPKField			= "Id"

			* Carpeta donde se encuentra la Tabla
			This.caTableFolder 		= drComun
			This.cxTableFolder 		= DRVD

			* Nombre real de la tabla
			This.caRealTableName 	= "Talonarios"
			This.cxRealTableName 	= "xTalonarios"

			This.WCLAV = "A"

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry


	Endproc
	*!*
	*!* END Procedure HookBeforeInitialize
	*!*
	*!* ///////////////////////////////////////////////////////

	*
	* Devuelve la lista de campos para la entidad
	Procedure GetFieldList( cTableName As String, cExcludedFields As String ) As Void;
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

			If Empty( cTableName )
				cTableName = This.cMainTableName
			Endif

			If !Used( cTableName )
				Text To lcCommand NoShow TextMerge Pretext 15
				M_Use( 0, '<<This.cTableFolder>><<This.cMainTableName>>' )				
				EndText

				&lcCommand
				lcCommand = ""

			Endif

			lcFieldList = DoDefault( cTableName, cExcludedFields )

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcFieldList

	Endproc && GetFieldList



	* WCLAV_Assign

	Protected Procedure WCLAV_Assign( uNewValue )

		This.WCLAV = uNewValue

		If This.WCLAV = "A"
			* Alias de la Tabla
			This.cMainTableName 	= This.caMainTableName

			* Alias del cursor transitorio
			This.cMainCursorName 	= This.caMainCursorName

			* Campo clave
			This.cPKField			= "Id"

			* Carpeta donde se encuentra la Tabla
			This.cTableFolder 		= This.caTableFolder

			* Nombre real de la tabla
			This.cRealTableName 	= This.caRealTableName

		Else
			* Alias de la Tabla
			This.cMainTableName 	= This.cxMainTableName

			* Alias del cursor transitorio
			This.cMainCursorName 	= This.cxMainCursorName

			* Campo clave
			This.cPKField			= "Id"

			* Carpeta donde se encuentra la Tabla
			This.cTableFolder 		= This.cxTableFolder

			* Nombre real de la tabla
			This.cRealTableName 	= This.cxRealTableName

		Endif

	Endproc && WCLAV_Assign


	*
	* Lee los parámetros asociados a la entidad
	Procedure LeerParametros(  ) As Void;
			HELPSTRING "Lee los parámetros asociados a la entidad"
		Local lcCommand As String

		Try

			lcCommand = ""
			This.lEditInBrowse = .T.


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && LeerParametros


	*
	* Actualiza el numero del talonario
	Procedure ActualizarNumero( nTalonarioId As Integer,;
			nNumero As Integer ) As Integer;
			HELPSTRING "Actualiza el numero del talonario"

		Local lcCommand As String
		Local loTalonario As Object
		Local lnNumero As Integer

		Try

			lcCommand = ""
			lnNumero = 0

			If nNumero >= 0
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update <<This.cMainTableName>> Set
						Numero = <<nNumero>>
					Where <<This.cMainTableName>>.<<This.cPKField>> = <<nTalonarioId>>
				ENDTEXT

			Else
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update <<This.cMainTableName>> Set
						Numero = Numero + 1
					Where <<This.cMainTableName>>.<<This.cPKField>> = <<nTalonarioId>>
				ENDTEXT

			Endif

			If This.ExecuteNonQuery( lcCommand )
				loTalonario = This.ObtenerTalonario( nTalonarioId )
				lnNumero = loTalonario.Numero
			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTalonario = Null

		Endtry

		Return lnNumero

	Endproc && ActualizarNumero

	*
	* Grabar el siguiente número para el comprobante y lo devuelve
	Procedure GrabarSiguienteNumero( nTalonarioId As Integer ) As Integer;
			HELPSTRING "Grabar el siguiente número para el comprobante y lo devuelve"

		Local lcCommand As String
		Local loTalonario As Object
		Local lnNumero As Integer

		Try

			lcCommand = ""
			lnNumero = 0

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Update <<This.cMainTableName>> Set
					Numero = Numero + 1
				Where <<This.cMainTableName>>.<<This.cPKField>> = <<nTalonarioId>>
			ENDTEXT

			If This.ExecuteNonQuery( lcCommand )
				loTalonario = This.ObtenerTalonario( nTalonarioId )
				lnNumero = loTalonario.Numero
			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTalonario = Null

		Endtry

		Return lnNumero

	Endproc && GrabarSiguienteNumero

	*
	* Devuelve el siguiente número para el comprobante
	Procedure ObtenerUltimoNumero( nTalonarioId As Integer ) As Integer;
			HELPSTRING "Devuelve el siguiente número para el comprobante "

		Local lcCommand As String
		Local loTalonario As Object
		Local lnNumero As Integer

		Try

			lcCommand = ""
			loTalonario = This.ObtenerTalonario( nTalonarioId )
			lnNumero = loTalonario.Numero

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTalonario = Null

		Endtry

		Return lnNumero

	Endproc && ObtenerUltimoNumero


	*
	* Devuelve el siguiente número para el comprobante
	Procedure ObtenerSiguienteNumero( nTalonarioId As Integer ) As Integer;
			HELPSTRING "Devuelve el siguiente número para el comprobante "

		Local lcCommand As String
		Local loTalonario As Object
		Local lnNumero As Integer

		Try

			lcCommand = ""
			lnNumero = This.ObtenerUltimoNumero( nTalonarioId ) + 1

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTalonario = Null

		Endtry

		Return lnNumero

	Endproc && ObtenerSiguienteNumero


	*
	* Devuelve un objeto con el registro del Talonario
	Procedure ObtenerTalonario( nTalonarioId As Integer ) As Object ;
			HELPSTRING "Devuelve el Último número para el comprobante "

		Local lcCommand As String,;
			lcFilterCriteria As String,;
			lcAlias As String

		Local loParam As Object,;
			loReturn As Object

		Try

			lcCommand = ""
			lcAlias = Alias()
			loParam = Createobject( "Empty" )

			TEXT To lcFilterCriteria NoShow TextMerge Pretext 15
			( <<This.cPKField>> = <<nTalonarioId>> )
			ENDTEXT

			AddProperty( loParam, "cFilterCriteria", lcFilterCriteria )

			If !Empty( This.GetByWhere( loParam ) )
				Scatter Memo Name loReturn

			Else
				Scatter Memo Blank Name loReturn

			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

			loParam = Null

		Endtry

		Return loReturn

	Endproc && ObtenerTalonario

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
			lnId As Integer

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

				If This.ExecuteNonQuery( lcCommand )
					llDone = .T.

					TEXT To lcMessage NoShow TextMerge Pretext 03 ADDITIVE
					<<_Tally>> registros modificados

					ENDTEXT

				Else
					llDone = .F.

				Endif

				If llDone ;
						And CLAVE > 0 ;
						And This.WCLAV = "A"

					TEXT To lcExcludeFieldList NoShow TextMerge Pretext 15
					"<<This.cPKField>>, Numero, Letra, pto_Venta"
					ENDTEXT

					lcUpdateFieldsList = This.GetUpdateFieldsValues( This.cMainTableName,;
						"cModificaciones",;
						lcExcludeFieldList )

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Update <<This.cxMainTableName>> Set
								<<lcUpdateFieldsList>>
							From cModificaciones
							Where <<This.cxMainTableName>>.<<This.cPKField>> = cModificaciones.<<This.cPKField>>

					ENDTEXT

					If This.ExecuteNonQuery( lcCommand )
						llDone = .T.

					Else
						llDone = .F.

					Endif


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

				If llDone ;
						And CLAVE > 0 ;
						And This.WCLAV = "A"

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Delete <<This.cxMainTableName>>
						From cBajas
						Where <<This.cxMainTableName>>.<<This.cPKField>> = cBajas.<<This.cPKField>>
					ENDTEXT

					If This.ExecuteNonQuery( lcCommand )
						llDone = .T.

					Else
						llDone = .F.

					Endif


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

				Endscan

				lcExcludeFieldList = ""
				lnLen = AFields( paFields, This.cMainTableName )
				
				For i = 1 to lnLen   
					If Empty( Field( paFields[ i, 1 ], "cAltas" ))
					
						lcExcludeFieldList = lcExcludeFieldList + ",[" + paFields[ i, 1 ] + "]" 

					EndIf

				EndFor

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

				If llDone ;
						And CLAVE > 0 ;
						And This.WCLAV = "A"

					Flock( This.cxMainTableName )

					TEXT To lcExcludeFieldList NoShow TextMerge Pretext 15
					"Numero", "Letra", "pto_Venta"
					ENDTEXT


					lnLen = AFields( paFields, This.cMainTableName )
					
					For i = 1 to lnLen   
						If Empty( Field( paFields[ i, 1 ], "cAltas" ))
						
							lcExcludeFieldList = lcExcludeFieldList + ",[" + paFields[ i, 1 ] + "]" 

						EndIf

					EndFor

					lcUpdateFieldsList = This.GetUpdatableFieldList( This.cxMainTableName,;
						lcExcludeFieldList )

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Insert Into <<This.cxMainTableName>> (
								<<lcUpdateFieldsList>> )
							Select
								<<lcUpdateFieldsList>>
						From cAltas
					ENDTEXT

					If This.ExecuteNonQuery( lcCommand )
						llDone = .T.

					Else
						llDone = .F.

					Endif

					Unlock In ( This.cxMainTableName )

				Endif

			Endif

			Wait Clear

			If !Empty( lcMessage )
				Inform( lcMessage, "Actualización de " + This.cRealTableName, 2 )
			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Wait Clear
			Use In Select( "cAltas" )
			Use In Select( "cBajas" )
			Use In Select( "cModificaciones" )
			Set Deleted &lcDeleted

			If Used( This.caMainTableName )
				Unlock In ( This.caMainTableName )
			Endif

			If Used( This.caMainTableName )
				Unlock In ( This.caMainTableName )
			Endif

			This.CerrarTabla()

		Endtry

	Endproc && GrabarCambios

	Procedure GetByWhere( oParam As Object ) As Integer

		Local lcCommand As String
		Local lnTally As Integer

		Try

			lcCommand = ""

			If Vartype( oParam ) # "O"
				oParam = Createobject( "Empty" )
			Endif

			If !Pemstatus( oParam, "cOrderBy", 5 )
				AddProperty( oParam, "cOrderBy", "Nombre" )
			Endif

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

					This.oColTables = _NewObject( "oColTables", 'Tools\DataDictionary\prg\oColTables.prg' )
					loColTables = NewColTables()

					loTable = loColTables.GetItem( This.caMainTableName )
					loTable.cCursorName = This.caMainCursorName

					This.oColTables.nNivelJerarquiaTablas = loTable.nNivelJerarquiaTablas
					This.oColTables.AddItem( loTable, Lower( This.caMainTableName ))

					If CLAVE > 0
						loTable = loColTables.GetItem( This.cxMainTableName )
						loTable.cCursorName = This.cxMainCursorName

						This.oColTables.nNivelJerarquiaTablas = loTable.nNivelJerarquiaTablas
						This.oColTables.AddItem( loTable, Lower( This.cxMainTableName ))
					Endif

				Endif
			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return This.oColTables

	Endproc && oColTables_Access





Enddefine


*!* ///////////////////////////////////////////////////////
*!* Class.........: CboTalonarios
*!* ParentClass...: ComboBox
*!* BaseClass.....: ComboBox
*!* Description...: Talonarios
*!* Date..........: Domingo 15 de Abril de 2012 (12:19:45)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class CboTalonarios As ComboBox

	#If .F.
		Local This As CboTalonarios Of "Fw\Comunes\Prg\Talonario.prg"
	#Endif

	BoundColumn 	= 2
	BoundTo 		= .T.
	ColumnCount 	= 1
	RowSourceType 	= 0
	RowSource 		= ""
	Style			= 2
	Sorted 			= .T.


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	Procedure Init()
		Local lcCommand As String

		Local loTalonario As Talonario Of "Fw\Comunes\Prg\Talonario.prg"

		Try

			lcCommand = ""
			loTalonario = GetEntity( "Talonario" )
			loTalonario.GetAll()

			Select Alias( loTalonario.cMainCursorName )
			Locate

			Scan
				This.AddItem( Evaluate( loTalonario.cMainCursorName + ".Nombre" ))
				This.List( This.NewIndex, 2 ) = Transform( Evaluate( loTalonario.cMainCursorName + "." + loTalonario.cPKField ))
			Endscan

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTalonario = Null

		Endtry

	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: CboTalonarios
*!*
*!* ///////////////////////////////////////////////////////