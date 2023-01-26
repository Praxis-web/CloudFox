#INCLUDE "FW\Comunes\Include\Praxis.h"

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCttaCtte
*!* Description...:
*!* Date..........: Viernes 31 de Diciembre de 2021 (10:54:32)
*!*
*!*

#Define inf__ResumenDeCuenta				1
#Define inf__ComposiciónDeSaldo				2
#Define inf__ResumenDeSaldo					3
#Define inf__ComposiciónDeSaldoAUnaFecha	4
#Define inf__MostrarComprobante				5

Define Class oCttaCtte As oMovimiento Of "FrontEnd\Prg\Movimiento.prg"

	#If .F.
		Local This As oCttaCtte Of "Clientes\Ctta_Ctte\prg\CttaCtte.prg"
	#Endif


	cFormularioInformes = "Clientes\Ctta_Ctte\Scx\Informe_Ctta_Ctte.scx"
	cTituloDelInforme 	= "Informes de Cuentas Corrientes"
	cGrilla = "Clientes\Ctta_Ctte\Scx\ctta_ctte_En_Grid.scx"

	cModelo 			= "CttaCtte"
	cTabla 				= "Deuda"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*
	*
	Procedure ParametrosFijos() As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			DoDefault()

			Do Case
				Case This.nInformeId = inf__ResumenDeCuenta
					This.cMainCursorName = "c_ResumenDeCuenta_" + Sys( 2015 )

				Case This.nInformeId = inf__ComposiciónDeSaldo
					This.cMainCursorName = "c_ComposiciónDeSaldo_" + Sys( 2015 )
					This.AgregarParametro( "con_saldo=true" )

				Case This.nInformeId = inf__ResumenDeSaldo
					This.cMainCursorName = "c_ResumenDeSaldo_" + Sys( 2015 )

				Case This.nInformeId = inf__ComposiciónDeSaldoAUnaFecha
					This.cMainCursorName = "c_ComposiciónDeSaldoAUnaFecha_" + Sys( 2015 )
					This.AgregarParametro( "con_saldo=true" )

				Otherwise

			Endcase


			*Inform( This.cURL )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && ParametrosFijos

	*
	*
	Procedure ParametrosVariables( oParametros As Object ) As Collection
		Local loFilterCriteria As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
			loFiltro As cntFiltro_Adicional Of "FrontEnd\Vcx\informes.vcx",;
			loFilter As Object

		Local llFiltra As Boolean

		Try

			lcCommand = ""

			loFilterCriteria = DoDefault( oParametros )

			For Each loFiltro In oParametros.oFiltrosAdicionales

				If loFiltro.Visible = .T. And loFiltro.chkActivo.Value = .T.
					loFilter = Createobject( "Empty" )
					AddProperty( loFilter, "Nombre", Lower( loFiltro.Name ))
					llFiltra = .T.

					Do Case
						Case loFiltro.Name = "FechaDeSaldo"
							AddProperty( loFilter, "FieldName", "fecha_de_saldo" )
							AddProperty( loFilter, "FieldRelation", "==" )
							AddProperty( loFilter, "FieldValue", Any2String( loFiltro.Fecha.Value ))

						Case loFiltro.Name = "Saldo"
							AddProperty( loFilter, "FieldName", "con_saldo" )
							AddProperty( loFilter, "FieldRelation", "==" )

							Do Case
								Case loFiltro.OptionGroup.Value = 1	&& Todos
									llFiltra = .F.

								Case loFiltro.OptionGroup.Value = 2	&& Con Saldo
									AddProperty( loFilter, "FieldValue", Any2String( .T. ))

								Case loFiltro.OptionGroup.Value = 3	&& Sin Saldo
									AddProperty( loFilter, "FieldValue", Any2String( .F. ))

							Endcase

						Case loFiltro.Name = "Ranking"
							AddProperty( loFilter, "FieldName", "ranking" )
							AddProperty( loFilter, "FieldRelation", "==" )

							Do Case
								Case loFiltro.OptionGroup.Value = 1	&& Alafabetico
									llFiltra = .F.

								Case loFiltro.OptionGroup.Value = 2	&& Saldo Descendente
									AddProperty( loFilter, "FieldValue", "desc" )

								Case loFiltro.OptionGroup.Value = 3	&& Saldo Ascendente
									AddProperty( loFilter, "FieldValue", "asc" )

							Endcase

					Endcase

					If llFiltra
						loFilterCriteria.Add( loFilter, Lower( loFilter.Nombre ))
					Endif

				Endif

			Endfor


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loFilterCriteria

	Endproc && ParametrosVariables


	*
	*
	Procedure CrearCursor( cAlias As String ) AS Object
		Local lcCommand As String
		Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg",;
			loColFields As oColFields Of "Tools\DataDictionary\prg\oColFields.prg",;
			loField As oField Of "Tools\DataDictionary\prg\oField.prg",;
			loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

		Try

			lcCommand = ""

			loTable 	= Newobject( "Archivo", "Clientes\Utiles\Prg\utRutina.prg" )
			loColFields = loTable.oColFields

			Do Case
				Case .F. && This.nInformeId = inf__ResumenDeCuenta
					TEXT To lcCommand NoShow TextMerge Pretext 15

					ENDTEXT

				Case .F. && This.nInformeId = inf__ComposiciónDeSaldo
					TEXT To lcCommand NoShow TextMerge Pretext 15

					ENDTEXT

				Case This.nInformeId = inf__ResumenDeSaldo
					loField = loColFields.NewPk( "id", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.nGridOrder = 0
						.lCanUpdate = .F.
						.cCaption = "Id"
					EndWith

					loField = loColFields.New( "razon_social", "C", 60 )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.lShowInGrid 	= .T.
						.nGridOrder 	= 1
						.lCanUpdate 	= .F.
						.cCaption 		= "Razón Social"
					EndWith

					loField = loColFields.New( "saldo_calculado", "N", 14, 2 )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.lShowInGrid 	= .T.
						.nGridOrder 	= 2
						.lCanUpdate 	= .F.
						.cCaption 		= "Saldo"
					EndWith

				Case .F. && This.nInformeId = inf__ComposiciónDeSaldoAUnaFecha
					TEXT To lcCommand NoShow TextMerge Pretext 15

					ENDTEXT

				Otherwise

					loField = loColFields.NewPk( "id", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.nGridOrder = 0
						.lCanUpdate = .F.
						.cCaption = "Id"
					EndWith

					loField = loColFields.New( "comprobante", "C", 40 )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.lShowInGrid 	= .T.
						.nGridOrder 	= 1
						.lCanUpdate 	= .F.
						.cCaption 		= "Comprobante"
					EndWith

					loField = loColFields.New( "letra", "C", 1 )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.lShowInGrid 	= .T.
						.nGridOrder 	= 2
						.lCanUpdate 	= .F.
						.cCaption 		= "Letra"
					EndWith


					loField = loColFields.New( "punto_de_venta", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.lShowInGrid 	= .T.
						.nGridOrder 	= 3
						.lCanUpdate 	= .F.
						.cCaption 		= "Punto de Venta"
					EndWith

					loField = loColFields.New( "numero", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.lShowInGrid 	= .T.
						.nGridOrder 	= 4
						.lCanUpdate 	= .F.
						.cCaption 		= "Número"
					EndWith

					loField = loColFields.New( "organizacion", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.nGridOrder = 0
						.lCanUpdate = .F.
						.cCaption = "Organización"
					EndWith

					loField = loColFields.New( "razon_social", "C", 60 )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.lShowInGrid 	= .T.
						.nGridOrder 	= 5
						.lCanUpdate 	= .F.
						.cCaption 		= "Razón Social"
					EndWith

					loField = loColFields.New( "fecha", "D" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.lShowInGrid 	= .T.
						.nGridOrder 	= 6
						.lCanUpdate 	= .F.
						.cCaption 		= "Fecha"
					EndWith

					loField = loColFields.New( "fecha_vencimiento", "D" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.lShowInGrid 	= .T.
						.nGridOrder 	= 7
						.lCanUpdate 	= .F.
						.cCaption 		= "Fecha de Vencimiento"
					EndWith

					loField = loColFields.New( "importe", "N", 14, 2 )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.lShowInGrid 	= .T.
						.nGridOrder 	= 8
						.lCanUpdate 	= .F.
						.cCaption 		= "Importe"
					EndWith

					loField = loColFields.New( "saldo_calculado", "N", 14, 2 )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.lShowInGrid 	= .T.
						.nGridOrder 	= 9
						.lCanUpdate 	= .F.
						.cCaption 		= "Saldo"
					EndWith

					loField = loColFields.New( "es_compra", "L" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.nGridOrder = 0
						.lCanUpdate = .F.
						.cCaption = "Es Compra"
					EndWith

					loField = loColFields.New( "signo", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.nGridOrder = 0
						.lCanUpdate = .F.
						.cCaption = "Signo"
					EndWith

					loField = loColFields.New( "empresa", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.nGridOrder = 0
						.lCanUpdate = .F.
						.cCaption = "Empresa"
					EndWith

					loField = loColFields.New( "provincia", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.nGridOrder = 0
						.lCanUpdate = .F.
						.cCaption = "Provincia"
					EndWith

					loField = loColFields.New( "sucursal", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.nGridOrder = 0
						.lCanUpdate = .F.
						.cCaption = "Sucursal"
					EndWith

					loField = loColFields.New( "tipo_comprobante", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.nGridOrder = 0
						.lCanUpdate = .F.
						.cCaption = "Tipo Comprobante"
					EndWith

					loField = loColFields.New( "vendedor", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.nGridOrder = 0
						.lCanUpdate = .F.
						.cCaption 	= "Vendedor"
						.lNull 		= .T.
					EndWith

					loField = loColFields.New( "comprobante_base", "I" )
					With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
						.nGridOrder = 0
						.lCanUpdate = .F.
						.cCaption = "Comprobante Base"
					EndWith

			EndCase


			loField = loColFields.New( "r7Mov", "C", 1 )
			With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
				.nGridOrder = 0
				.lCanUpdate = .F.
				.cCaption = "r7Mov"
			EndWith

			loField = loColFields.New( "ABM", "I" )
			With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
				.nGridOrder = 0
				.lCanUpdate = .F.
				.cCaption = "ABM"
			EndWith

			loField = loColFields.New( "_RecordOrder", "I" )
			With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
				.nGridOrder = 0
				.lCanUpdate = .F.
				.cCaption = "_RecordOrder"
			EndWith

			If !Empty( cAlias )
				loArchivo = NewObject( "Archivo", "Clientes\Utiles\Prg\utRutina.prg" )
				loArchivo.Name = This.cTabla
				loArchivo.oColFields = loColFields
				loArchivo.CrearCursor( cAlias )
			EndIf

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loArchivo = Null
			loField = Null
			loColFields = Null

		EndTry

		Return loTable

	Endproc && CrearCursores

	*
	*
	Procedure xxxCrearCursor( cAlias As String ) AS Object
		Local lcCommand As String
		Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg",;
			loColFields As oColFields Of "Tools\DataDictionary\prg\oColFields.prg",;
			loField As oField Of "Tools\DataDictionary\prg\oField.prg"


		Try

			lcCommand = ""

			Do Case
				Case .F. && This.nInformeId = inf__ResumenDeCuenta
					TEXT To lcCommand NoShow TextMerge Pretext 15

					ENDTEXT

				Case .F. && This.nInformeId = inf__ComposiciónDeSaldo
					TEXT To lcCommand NoShow TextMerge Pretext 15

					ENDTEXT

				Case This.nInformeId = inf__ResumenDeSaldo
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Create Cursor <<cAlias>> (
						id I,
      					razon_social C(100),
      					saldo_calculado N(14,2),
					ENDTEXT

				Case .F. && This.nInformeId = inf__ComposiciónDeSaldoAUnaFecha
					TEXT To lcCommand NoShow TextMerge Pretext 15

					ENDTEXT

				Otherwise
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Create Cursor <<cAlias>> (
						id I,
				      	comprobante C(40),
					    letra C(1),
					    punto_de_venta I,
					    numero I,
					    organizacion I,
					    razon_social C(100),
					    fecha D,
					    fecha_vencimiento D,
					    importe N(14,2),
					    saldo_calculado N(14,2),
					    es_compra L,
					    signo I,
					ENDTEXT

			EndCase

			TEXT To lcCommand NoShow TextMerge Pretext 15 ADDITIVE
				r7Mov C(1),
				ABM I,
				_RecordOrder I
				)
			ENDTEXT

			&lcCommand
			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && xxxCrearCursores



	*
	* oTiposDeInforme_Access
	Protected Procedure oTiposDeInforme_Access()
		Local lcCommand As String
		Local loTiposDeInforme As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg',;
			loInforme As Object


		Try

			lcCommand = ""
			If Isnull( This.oTiposDeInforme )
				loTiposDeInforme = Newobject( "oColBase", 'Tools\DataDictionary\prg\oColBase.prg' )

				loInforme = Createobject( "Empty" )

				AddProperty( loInforme, "Caption", "Resúmen de Cuentas" )
				AddProperty( loInforme, "Url", "ctta_ctte/apis/Deuda/" )
				AddProperty( loInforme, "Activo", .T. )
				AddProperty( loInforme, "Id", inf__ResumenDeCuenta )

				loTiposDeInforme.Add( loInforme, Transform( inf__ResumenDeCuenta ) )

				loInforme = Createobject( "Empty" )

				AddProperty( loInforme, "Caption", "Composición de Saldos" )
				AddProperty( loInforme, "Url", "ctta_ctte/apis/Deuda/" )
				AddProperty( loInforme, "Activo", .T. )
				AddProperty( loInforme, "Id", inf__ComposiciónDeSaldo )

				loTiposDeInforme.Add( loInforme, Transform( inf__ComposiciónDeSaldo ) )

				loInforme = Createobject( "Empty" )

				AddProperty( loInforme, "Caption", "Resúmen de Saldos" )
				AddProperty( loInforme, "Url", "ctta_ctte/apis/Saldos/" )
				AddProperty( loInforme, "Activo", .T. )
				AddProperty( loInforme, "Id", inf__ResumenDeSaldo )

				loTiposDeInforme.Add( loInforme, Transform( inf__ResumenDeSaldo ) )

				loInforme = Createobject( "Empty" )

				AddProperty( loInforme, "Caption", "Composición de Saldos a una Fecha" )
				AddProperty( loInforme, "Url", "ctta_ctte/apis/Deuda/" )
				AddProperty( loInforme, "Activo", .T. )
				AddProperty( loInforme, "Id", inf__ComposiciónDeSaldoAUnaFecha )

				loTiposDeInforme.Add( loInforme, Transform( inf__ComposiciónDeSaldoAUnaFecha ) )

				loInforme = Createobject( "Empty" )

				AddProperty( loInforme, "Caption", "Mostrar Comprobante" )
				AddProperty( loInforme, "Url", "ctta_ctte/apis/Deuda/" )
				AddProperty( loInforme, "Activo", .F. )
				AddProperty( loInforme, "Id", inf__MostrarComprobante )

				loTiposDeInforme.Add( loInforme, Transform( inf__MostrarComprobante ) )

				This.oTiposDeInforme = loTiposDeInforme
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry


		Return This.oTiposDeInforme

	Endproc && oTiposDeInforme_Access


Enddefine


*!*
*!* END DEFINE
*!* Class.........: oCttaCtte
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Columna_CttaCtte
*!* Description...:
*!* Date..........: Miércoles 16 de Marzo de 2022 (19:00:56)
*!*
*!*

Define Class Columna_CttaCtte As Columna_Informe Of "FrontEnd\Prg\Movimiento.prg"

	#If .F.
		Local This As Columna_CttaCtte Of "Clientes\Ctta_Ctte\prg\CttaCtte.prg"
	#Endif

	cTextControlName 	= "prxText"
	cTextControlLibrary = "Clientes\Ctta_Ctte\prg\CttaCtte.prg"
	cCurrentControlName = "prxText1"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Columna_CttaCtte
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: prxText
*!* Description...:
*!* Date..........: Miércoles 16 de Marzo de 2022 (19:08:50)
*!*
*!*

Define Class prxText As TextBox

	#If .F.
		Local This As prxText Of "Clientes\Ctta_Ctte\prg\CttaCtte.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="getcontextualoption" type="method" display="GetContextualOption" />] + ;
		[</VFPData>]

	*
	*
	Procedure MouseDown( nButton, nShift, nXCoord, nYCoord ) As Void
		Local lcCommand As String,;
			lcAlias as String,;
			lcCursor as String
		Local lnOpcion As Integer,;
			lnInformeId as Integer,;
			lnId as Integer
		Local loBiz As oCttaCtte Of "Clientes\Ctta_Ctte\prg\CttaCtte.prg",;
			loParametros as Object,;
			loInforme as Object,;
			loTiposDeInforme As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg',;
			loInforme As Object,;
			loColFiltrosAdicionales as Collection

		Try

			lcCommand = ""



			lnOpcion 			= 0
			lnId 				= 0
			lnOrganizacionId 	= 0

			*Inform( This.Name + " - " + Program() )

			Do Case
				Case nButton = 2 And nShift = 0 && Right Click

					lcAlias 	= Alias()
					lcCursor 	= This.Parent.Parent.RecordSource
					lnId 		= Evaluate( lcCursor + ".Id" )

					lnInformeId = Thisform.nInformeId
					lnOpcion = This.GetContextualOption( lnInformeId )

					*Inform( lnOpcion )

					If !Empty( lnOpcion )

						loBiz 			= NewObject( "oCttaCtte", "Clientes\Ctta_Ctte\prg\CttaCtte.prg" )
						loTiposDeInforme = loBiz.oTiposDeInforme
						loInforme = loTiposDeInforme.GetItem( lnOpcion )

						If lnOpcion = inf__MostrarComprobante
							*Set Step On
							loBiz.cURL = loInforme.Url
							loReturn = loBiz.GetByPK( lnId )

							*Set Step On

						Else
							loParametros 	= Createobject( "Empty" )

							AddProperty( loInforme, "cEndPoint", loInforme.Url )
							AddProperty( loInforme, "cTitulo", loInforme.Caption )
							AddProperty( loInforme, "nId", loInforme.Id )

							loColFiltrosAdicionales = Createobject( "Collection" )
							loFiltros = Createobject( "Collection" )
							loFiltro = Createobject( "Empty" )

							AddProperty( loFiltro, "lCaseSensitive", .T. )
							AddProperty( loFiltro, "cLookUpCommand", "exact" )
							AddProperty( loFiltro, "uValue", lnId )
							AddProperty( loFiltro, "uValueHasta", Null )
							AddProperty( loFiltro, "cFieldName", "organizacion__id" )

							loFiltros.Add( loFiltro )

							AddProperty( loParametros, "oInforme", loInforme )
							AddProperty( loParametros, "oFiltros", loFiltros )
							AddProperty( loParametros, "oFiltrosAdicionales", loColFiltrosAdicionales )
							AddProperty( loParametros, "cSalida", S_PANTALLA )
							AddProperty( loParametros, "cTitulo", "Titulo del Informe" )

							loBiz.EjecutarConsulta( loParametros )

						EndIf

						Thisform.Filtrar()

						Select Alias( lcCursor )
						Locate for Id = lnId

					EndIf


			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loBiz = Null
			loParametros = Null

			If !Empty( lcAlias )
				Select Alias( lcAlias )
			EndIf

		Endtry

	Endproc && MouseDown



	*
	*
	PROCEDURE GetContextualOption( nInformeId as Integer ) AS Integer
		Local lcCommand as String
		Local lnOpcion as Integer

		Try

			lcCommand 	= ""
			lnOpcion 	= 0

			Define Popup emergente SHORTCUT Relative From Mrow(),Mcol()

			Do Case
				Case InList( nInformeId, inf__ResumenDeCuenta, inf__ComposiciónDeSaldo, inf__ComposiciónDeSaldoAUnaFecha )
					Define Bar 1 Of emergente Prompt "Mostrar \<Comprobante"

					On Selection Bar 1 Of emergente lnOpcion 	= inf__MostrarComprobante

				Case nInformeId = inf__ResumenDeSaldo
					Define Bar 2 Of emergente Prompt "\<Resúmen de Cuenta"
					Define Bar 3 Of emergente Prompt "Composición de \<Saldo"

					On Selection Bar 2 Of emergente lnOpcion 	= inf__ResumenDeCuenta
					On Selection Bar 3 Of emergente lnOpcion 	= inf__ComposiciónDeSaldoAUnaFecha

				Otherwise

			EndCase

			Activate Popup emergente

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		EndTry

		Return lnOpcion

	EndProc && GetContextualOption



Enddefine
*!*
*!* END DEFINE
*!* Class.........: prxText
*!*
*!* ///////////////////////////////////////////////////////

*
*
Procedure Dummy(  ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""
		External Procedure tipo_comprobante.prg,;
			organizacion.prg,;
			Vendedor.prg,;
			Provincia.prg,;
			Sucursal.prg,;
			comprobante_base.prg,;
			Pais.prg,;
			Empresa.prg,;
			cliente_praxis.prg


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && Dummy


