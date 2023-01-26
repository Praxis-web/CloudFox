*!* ///////////////////////////////////////////////////////
*!* Class.........: ServiceTier
*!* ParentClass...: TierAdapter Of 'V:\Sistemaspraxisv2\Fw\Tieradapter\Comun\Tieradapter.prg'
*!* BaseClass.....: prxSession
*!* Description...: Componente de Servicios
*!* Date..........: Viernes 24 de Abril de 2009 (08:27:02)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#INCLUDE "FW\Tieradapter\Include\TA.h"
#INCLUDE "FW\ErrorHandler\EH.h"
#INCLUDE "FW\Comunes\Include\Praxis.h"


Define Class ServiceTier As tieradapter Of 'Fw\Tieradapter\Comun\Tieradapter.prg'

	#If .F.
		Local This As ServiceTier Of "Fw\Tieradapter\Servicetier\Servicetier.prg"
	#Endif

	Protected cSelectorFormName,;
		cSelectorFormCaption,;
		cFormName,;
		cPaginationRoutineName

	DataSession = SET_DEFAULT

	cTierLevel = "Service"

	lAutoDestroy = .F.

	lMakeTransactable = .T.

	lSerialize = .F.

	*!* Nombre del cursor que contendrá la información sobre las validaciones
	cValidationCursorName = ""

	*!*	Nombre de la clase para crear la colección table
	cColTablesClass = "ColTables"

	*!*	Nombre de la librería donde se encuentra la	definición de la colección tables
	cColTablesClassLibrary = "ColTables.prg"

	* Archivo de Configuración
	cBackEndCfgFileName = ""

	*!*		cObjectFactoryFileName = "ObjectFactoryCfg.xml"

	lSerialize = .F.

	* Referencia al objeto Report
	oReport = Null


	* Contiene el nombre del formulario selector
	cSelectorFormName = ""

	* Contiene el Caption del formulario Selector
	cSelectorFormCaption = ""

	* Nombre del form donde se mostrarán los datos de la entidad
	cFormName = ""

	* Colección de elementos oGridLayout, que permiten personalizar la prxASctionGrid
	oColGridLayout = Null

	* Diccionario de Datos
	oDataDictionary = Null

	* Librería del sincronizador
	cSincronizador = ""

	* Nombre de la rutina de paginacion
	cPaginationRoutineName  = "GetAllPaginated"

	* Indica la cantidad de niveles de la entidad
	*nNivelJerarquiaTablas = 0
	* Si es 0, la lee de This.oColTables 
	nNivelJerarquiaTablas = 1

	* Indica si la Entidad valida los datos antes de grabar
	lValidateBeforePut = .F.

	*!* Indica que la entidad se comporta como Child
	lIsChild = .F.

	* Referencia a la Tier de la entidad
	oEntity = Null

	*!* Colección de elementos oGridSelectorLayout, que permiten personalizar la prxActionGrid para el Selector
	oColGridSelectorLayout = Null

	*!* Expresion para representar a la entidad
	cLabelExpression = 'Alltrim( Codigo ) + " - " + Alltrim( Descripcion )'

	*!* Colección de imagenes
	oColImages = Null

	*!* Colección de elementos oColNavigator, que permiten personalizar el Navegador
	oColNavigator = Null

	*!* Filtro para navegar por las entidades
	cNavigatorFilterCriteria = ''

	* Colección de controles que van el el control KeyFinder
	oColKeyFinderControls = Null

	oColKeyFinderFastSearch = Null

	* Nombre de la tabla asociada a la entidad
	cTableName = ""

	* Indica si el codigo es Numerio o AlfaNumerico
	lCodigoIsNumeric = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ocolkeyfindercontrols" type="property" display="oColKeyFinderControls" />] + ;
		[<memberdata name="oentity" type="property" display="oEntity" />] + ;
		[<memberdata name="lvalidatebeforeput" type="property" display="lValidateBeforePut" />] + ;
		[<memberdata name="nniveljerarquiatablas" type="property" display="nNivelJerarquiaTablas" />] + ;
		[<memberdata name="csincronizador" type="property" display="cSincronizador" />] + ;
		[<memberdata name="cformname" type="property" display="cFormName" />] + ;
		[<memberdata name="cselectorformname" type="property" display="cSelectorFormName" />] + ;
		[<memberdata name="cselectorformcaption" type="property" display="cSelectorFormCaption" />] + ;
		[<memberdata name="cselectorformcaption" type="property" display="cSelectorFormCaption" />] + ;
		[<memberdata name="oreport" type="property" display="oReport" />] + ;
		[<memberdata name="oreport_access" type="method" display="oReport_Access" />] + ;
		[<memberdata name="ccoltablesclasslibrary" type="property" display="cColTablesClassLibrary" />] + ;
		[<memberdata name="ccoltablesclass" type="property" display="cColTablesClass" />] + ;
		[<memberdata name="classbeforevalidateput" type="method" display="ClassBeforeValidatePut" />] + ;
		[<memberdata name="hookbeforevalidateput" type="method" display="HookBeforeValidatePut" />] + ;
		[<memberdata name="validateput" type="method" display="ValidatePut" />] + ;
		[<memberdata name="hookaftervalidateput" type="method" display="HookAfterValidatePut" />] + ;
		[<memberdata name="classaftervalidateput" type="method" display="ClassAfterValidatePut" />] + ;
		[<memberdata name="cValidationCursorName" type="property" display="cValidationCursorName" />] + ;
		[<memberdata name="addvalidationreport" type="method" display="AddValidationReport" />] + ;
		[<memberdata name="generatevalidationreport" type="method" display="GenerateValidationReport" />] + ;
		[<memberdata name="dovalidate" type="method" display="DoValidate" />] + ;
		[<memberdata name="getcoltables" type="method" display="GetColTables" />] + ;
		[<memberdata name="createcoltables" type="method" display="CreateColTables" />] + ;
		[<memberdata name="classbeforecreatecoltables" type="method" display="ClassBeforeCreateColTables" />] + ;
		[<memberdata name="hookbeforecreatecoltables" type="method" display="HookBeforeCreateColTables" />] + ;
		[<memberdata name="hookaftercreatecoltables" type="method" display="HookAfterCreateColTables" />] + ;
		[<memberdata name="classaftercreatecoltables" type="method" display="ClassAfterCreateColTables" />] + ;
		[<memberdata name="cbackendcfgfilename" type="property" display="cBackEndCfgFileName" />] + ;
		[<memberdata name="getselectorformname" type="method" display="GetSelectorFormName" />] + ;
		[<memberdata name="getselectorformcaption" type="method" display="GetSelectorFormCaption" />] + ;
		[<memberdata name="getformname" type="method" display="GetFormName" />] + ;
		[<memberdata name="ocolgridlayout" type="property" display="oColGridLayout" />] + ;
		[<memberdata name="hookbeforesetgridlayout" type="method" display="HookBeforeSetGridLayout" />] + ;
		[<memberdata name="setgridlayout" type="method" display="SetGridLayout" />] + ;
		[<memberdata name="hookaftersetgridlayout" type="method" display="HookAfterSetGridLayout" />] + ;
		[<memberdata name="getfieldsize" type="method" display="GetFieldSize" />] + ;
		[<memberdata name="odatadictionary" type="property" display="oDataDictionary" />] + ;
		[<memberdata name="cpaginationroutinename" type="property" display="cPaginationRoutineName " />] + ;
		[<memberdata name="hookbeforegetformname" type="method" display="HookBeforeGetFormName" />] + ;
		[<memberdata name="hookaftergetformname" type="method" display="HookAfterGetFormName" />] + ;
		[<memberdata name="classbeforegetformname" type="method" display="ClassBeforeGetFormName" />] + ;
		[<memberdata name="classaftergetformname" type="method" display="ClassAfterGetFormName" />] + ;
		[<memberdata name="lischild" type="property" display="lIsChild" />] + ;
		[<memberdata name="lischild_access" type="method" display="lIsChild_Access" />] + ;
		[<memberdata name="loadchildtables" type="method" display="LoadChildTables" />] + ;
		[<memberdata name="getall" type="method" display="GetAll" />] + ;
		[<memberdata name="ocolgridselectorlayout" type="property" display="oColGridSelectorLayout" />] + ;
		[<memberdata name="ocolgridselectorlayout_access" type="method" display="oColGridSelectorLayout_Access" />] + ;
		[<memberdata name="setgridselectorlayout" type="method" display="SetGridSelectorLayout" />] + ;
		[<memberdata name="classbeforesetgridselectorlayout" type="method" display="ClassBeforeSetGridSelectorLayout" />] + ;
		[<memberdata name="hookbeforesetgridselectorlayout" type="method" display="HookBeforeSetGridSelectorLayout" />] + ;
		[<memberdata name="hookaftersetgridselectorlayout" type="method" display="HookAfterSetGridSelectorLayout" />] + ;
		[<memberdata name="classaftersetgridselectorlayout" type="method" display="ClassAfterSetGridSelectorLayout" />] + ;
		[<memberdata name="lusecodigo" type="property" display="lUseCodigo" />] + ;
		[<memberdata name="lusecodigo_access" type="method" display="lUseCodigo_Access" />] + ;
		[<memberdata name="clabelexpression" type="property" display="cLabelExpression" />] + ;
		[<memberdata name="ocolimages" type="property" display="oColImages" />] + ;
		[<memberdata name="ocolimages_access" type="method" display="oColImages_Access" />] + ;
		[<memberdata name="ocolnavigator" type="property" display="oColNavigator" />] + ;
		[<memberdata name="ocolnavigator_access" type="method" display="oColNavigator_Access" />] + ;
		[<memberdata name="cnavigatorfiltercriteria" type="property" display="cNavigatorFilterCriteria" />] + ;
		[<memberdata name="fillcolnavigator" type="method" display="FillColNavigator" />] + ;
		[<memberdata name="fillcollimages" type="method" display="FillCollImages" />] + ;
		[<memberdata name="fillcolentities" type="method" display="FillColEntities" />] + ;
		[<memberdata name="cdataconfigurationkey_access" type="method" display="cDataConfigurationKey_Access" />] + ;
		[<memberdata name="lhasdefault" type="property" display="lHasDefault" />] + ;
		[<memberdata name="lhasdescripcion" type="property" display="lHasDescripcion" />] + ;
		[<memberdata name="lhascodigo" type="property" display="lHasCodigo" />] + ;
		[<memberdata name="lusecodigo" type="property" display="lUseCodigo" />] + ;
		[<memberdata name="getallpaginatedorderby" type="method" display="GetAllPaginatedOrderBy" />] + ;
		[<memberdata name="getalljoins" type="method" display="GetAllJoins" />] + ;
		[<memberdata name="getallfields" type="method" display="GetAllFields" />] + ;
		[<memberdata name="ctablename" type="property" display="cTableName" />] + ;
		[</VFPData>]


	Procedure ClassAfterInitialize()
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\colDataBases.prg"

		Try
			* DAE 2009-11-09(18:35:45)
			*!*	loError = This.oError
			*!*	loError.Remark = ''
			*!*	loError.TraceLogin = ''

			This.cBackEndCfgFileName = Addbs( This.cRootFolder ) + "DataTier.xml"

			loColTables = NewColTables()
			loTable = loColTables.GetItem( This.cTableName )

			If Vartype( loTable ) # "O"
				Error "No se encuentra la tabla " + This.cTableName + " en la coleccion de tablas"
			Endif

			This.lHasCodigo = loTable.lHasCodigo
			This.lHasDefault = loTable.lHasDefault
			This.lHasDescripcion = loTable.lHasDescripcion
			This.lCodigoIsNumeric = loTable.lCodigoIsNumeric

			If This.lHasCodigo
				This.lUseCodigo = loTable.lUseCodigo

			Else
				This.lUseCodigo = .F.

			Endif

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			*!*	loError = This.oError
			*!*	loError.Remark = ''
			*!*	loError.TraceLogin = ''
			loError = Null

		Endtry



	Endproc


	*
	* Devuelve el nombre del formulario selector
	Procedure GetSelectorFormName( oParam As Object ) As String;
			HELPSTRING "Devuelve el nombre del formulario selector"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve el nombre del formulario selector
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Sábado 30 de Mayo de 2009 (13:31:51)
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
			oParam AS Object
			*:Remarks:
			*:Returns:
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			* Inicializar This.cSelectorFormName en funcion de oParam

			If Empty( This.cSelectorFormName )
				This.cSelectorFormName = Addbs(FL_SCX)+"Generic Selector.scx"
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

		Return This.cSelectorFormName

	Endproc && GetSelectorFormName


	*
	* Devuelve el nombre de la rutina de paginacion
	Procedure GetPaginationRoutineName( oParam As Object ) As String;
			HELPSTRING "Devuelve el nombre de la rutina de paginacion"

		If Empty( This.cPaginationRoutineName )
			This.cPaginationRoutineName = Addbs(FL_SCX)+"Generic Selector.scx"
		Endif

		Return This.cPaginationRoutineName

	Endproc && GetPaginationRoutineName



	*
	* Devuelve el Caption del formulario Selector
	Procedure GetSelectorFormCaption( oParam As Object ) As String;
			HELPSTRING "Devuelve el Caption del formulario Selector"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve el Caption del formulario Selector
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Sábado 30 de Mayo de 2009 (13:57:46)
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
			oparam AS Object
			*:Remarks:
			*:Returns:
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			If Empty( This.cSelectorFormCaption )
				This.cSelectorFormCaption = "Selector de " + Proper( This.cDataConfigurationKey ) + "s"
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

		Return This.cSelectorFormCaption

	Endproc && GetSelectorFormCaption


	*
	* Devuelve el nombre del formulario asociado a la entidad
	Procedure GetFormName( toParam As Object ) As String;
			HELPSTRING "Devuelve el nombre del formulario asociado a la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve el nombre del formulario asociado a la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Sábado 30 de Mayo de 2009 (13:31:51)
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
			oParam AS Object
			*:Remarks:
			*:Returns:
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcFormName As String

		Try

			With This As ServiceTier Of fw\tieradapter\ServiceTier\ServiceTier.prg

				If .ClassBeforeGetFormName( toParam )

					If .HookBeforeGetFormName( toParam )
						* Inicializar This.cFormName en funcion de oParam
						If Empty( .cFormName )

							.cFormName = .cDataConfigurationKey

						Endif

						If Pemstatus( toParam, 'cFormName', 5 )
							lcFormName = toParam.cFormName

						Else
							lcFormName = .cFormName

						Endif

						lcFormName = .HookAfterGetFormName( toParam, lcFormName )

						lcFormName = .ClassAfterGetFormName( toParam, lcFormName )

					Endif && This.HookBeforegetformname( toParam )

				Endif && This.ClassBeforegetformname( toParam )

			Endwith

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif && This.lIsOk

		Finally
			If !This.lIsOk
				Throw This.oError

			Endif && !This.lIsOk

		Endtry

		Return lcFormName

	Endproc && GetFormName

	Procedure HookBeforeGetFormName( toParam As Object ) As Boolean

		Return .T.

	Endproc && HookBeforeGetFormName


	Procedure HookAfterGetFormName( toParam As Object, tcFormName As String @ ) As String

		Return tcFormName

	Endproc && HookAfterGetFormName


	Protected Procedure ClassBeforeGetFormName( toParam As Object ) As Boolean

		Return .T.

	Endproc && ClassBeforeGetFormName


	Protected Procedure ClassAfterGetFormName( toParam As Object, tcFormName As String @ ) As String

		Return tcFormName

	Endproc && ClassAfterGetFormName



	*
	* ClassBefore Event
	* Validar antes de grabar
	Protected Procedure ClassBeforeValidatePut() As Boolean


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
			Miércoles 27 de Mayo de 2009 (12:59:37)
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
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteValidatePut As Boolean
		Local lcAlias As String
		Local lcEntityCursor As String
		Local loColTables As ColTables Of "Tools\Sincronizador\colDataBases.prg"
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loColData As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local lcErrorMessage As String
		Local lcExp As String

		Try

			lcAlias = Alias()
			lcEntityCursor = This.cEntityCursor
			Select Alias( lcEntityCursor )
			This.LocatePK()

			llExecuteValidatePut = .T.
			loColTables = NewColTables()
			loTable = loColTables.GetItem( This.cMainTableName )
			loColData = loTable.oColFields.Where ( ' lRequired = .T. ' )

			For i = 1 To loColData.Count
				loField = loColData.Item( i )
				lcExp = lcEntityCursor + '.' + loField.Name
				If IsEmpty( Evaluate( lcExp ) )
					lcErrorMessage = loField.ErrorMessage
					If Empty( lcErrorMessage )
						lcErrorMessage = "El Campo " + loField.Caption + " es obligatorio" && " no puede estar vacío"

					Endif && Empty( lcErrorMessage )

					This.AddValidationReport( lcErrorMessage, ;
						This.cMainTableName, ;
						loField.Name )

				Endif && IsEmpty( This.GetValue( loField.Name ) )

			Endfor

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif && This.lIsOk

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )

			Endif && Used( lcAlias )

			If ! This.lIsOk
				Throw This.oError

			Endif && ! This.lIsOk

		Endtry

		Return llExecuteValidatePut

	Endproc && ClassBeforeValidatePut
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Validar antes de grabar
	Procedure HookBeforeValidatePut() As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 27 de Mayo de 2009 (12:59:37)
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
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteValidatePut As Boolean

		Try

			llExecuteValidatePut = .T.

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

		Return llExecuteValidatePut

	Endproc && HookBeforeValidatePut
	*
	* Validar antes de grabar
	Protected Procedure ValidatePut() As Void;
			HELPSTRING "Validar antes de grabar"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Validar antes de grabar
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 27 de Mayo de 2009 (12:59:37)
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

	Endproc && ValidatePut
	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Validar antes de grabar
	Procedure HookAfterValidatePut() As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 27 de Mayo de 2009 (12:59:37)
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

	Endproc && HookAfterValidatePut
	*
	* ClassAfter Event
	* Validar antes de grabar
	Protected Procedure ClassAfterValidatePut() As Void


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
			Miércoles 27 de Mayo de 2009 (12:59:37)
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

	Endproc && ClassAfterValidatePut

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: DoValidate
	*!* Description...: Llama a la rutina de validación personalizada de cada clase
	*!* Date..........: Viernes 24 de Abril de 2009 (10:24:02)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure DoValidate( tlCallFromBiz As Boolean ) As String;
			HELPSTRING "Llama a la rutina de validación personalizada de cada clase"


		Local lcRetVal As String
		Local lcIdentifier As String
		Local lcEntityCursor As String
		Local lcAlias As String
		Local lcCommand As String
		Local lcMainCursorPK As String
		Local lnEntidadId As Integer
		Local lcRecno As Integer
		Try
			lcAlias = Alias()
			loError = This.oError
			loError.TraceLogin = ""
			loError.Remark = ""

			This.cValidationCursorName = ""

			lcRetVal = ""

			If This.lIsOk And This.ClassBeforeValidatePut()

				If This.lIsOk And This.HookBeforeValidatePut()

					This.ValidatePut()

					If This.lIsOk
						This.HookAfterValidatePut()

					Endif && This.lIsOk

				Endif && This.lIsOk And This.HookBeforeValidatePut()

				If This.lIsOk
					This.ClassAfterValidatePut()

				Endif && This.lIsOk

			Endif && This.lIsOk And This.ClassBeforeValidatePut()

			If This.lIsOk And !tlCallFromBiz
				lcRetVal = This.GenerateValidationReport()

			Endif && This.lIsOk And !tlCallFromBiz

			If This.lIsChild

				If ! ( This.lIsOk And Empty( lcRetVal ) )

					lcIdentifier = ParseXML( lcRetVal, 1 )

					If Empty( lcIdentifier )
						lcRetVal = WARNING_TAG + lcRetVal

					Endif && Empty( lcIdentifier )

				Else
					***If This.lHasDefault
					* Se Resuelve en ClassAfterPut()
					If .F.
						lcEntityCursor = This.cEntityCursor

						Select Alias( lcEntityCursor )
						lcFilter = Set( "Filter" )

						Select Alias( lcEntityCursor )
						This.LocatePK()
						If Evaluate( lcEntityCursor + ".Default" ) = TRUE
							If ! Empty( lcFilter )
								Update( lcEntityCursor ) ;
									set Default = FALSE Where &lcFilter

							Else
								* DA 2009-08-26(10:43:08)
								lcMainCursorPK = This.cMainCursorPK
								lnEntidadId = This.nEntidadId
								Select Alias( lcEntityCursor )
								TEXT To lcCommand NoShow TextMerge Pretext 15
								Replace Default With FALSE For <<lcMainCursorPK>> # <<lnEntidadId>>
								ENDTEXT

								&lcCommand

							Endif && ! Empty( lcFilter )
							This.LocatePK()

						Else
							Select Alias( lcEntityCursor )
							TEXT To lcCommand NoShow TextMerge Pretext 15
								Locate For Selected = True
							ENDTEXT

							&lcCommand

							* DA 2009-09-08(12:09:53)
							If !Found( lcEntityCursor )
								Select Alias( lcEntityCursor )
								This.LocatePK()
								Replace Default With TRUE, Selected With TRUE In (lcEntityCursor)

							Endif && lnRecno <= 0

							*!*								If Eof( lcEntityCursor )
							*!*									Select Alias( lcEntityCursor )
							*!*									Locate
							*!*									Replace Default With TRUE In (lcEntityCursor)

							*!*								Endif && Eof( lcEntityCursor )

						Endif && Evaluate( lcEntityCursor + ".Default" ) = TRUE

					Endif && This.lHasDefault

				Endif && ! ( This.lIsOk And Empty( lcRetVal ) )

			Endif && This.lIsChild

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif && This.lIsOk

		Finally

			If Used( lcAlias )
				Select Alias( lcAlias )

			Endif && Used( lcAlias )

			loError = This.oError
			loError.TraceLogin = ""
			loError.Remark = ""
			loError = Null

			If ! This.lIsOk
				Throw This.oError

			Endif && ! This.lIsOk

		Endtry

		Return lcRetVal

	Endproc && DoValidate


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: DoBizValidation
	*!* Description...: Llama a la rutina de validación personalizada de cada clase
	*!* Date..........: Viernes 24 de Abril de 2009 (10:24:02)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure DoBizValidation() As String;
			HELPSTRING "Llama a la rutina de validación personalizada de cada clase"


		Local lcRetVal As String

		Try
			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			This.cValidationCursorName = ""

			lcRetVal = ""

			This.DoValidate( .T. )

			If This.lIsOk And This.ClassBeforeBizValidation()

				If This.lIsOk And This.HookBeforeBizValidation()

					This.BizValidation()

					If This.lIsOk
						This.HookAfterBizValidation()

					Endif && This.lIsOk

				Endif

				If This.lIsOk
					This.ClassAfterBizValidation()

				Endif && This.lIsOk

			Endif

			If This.lIsOk
				lcRetVal = This.GenerateValidationReport()
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


		Return lcRetVal



	Endproc
	*!*
	*!* END PROCEDURE DoBizValidation
	*!*
	*!* ///////////////////////////////////////////////////////


	*
	* ClassBefore Event
	* Validar antes de grabar
	Protected Procedure ClassBeforeBizValidation() As Boolean


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
			Miércoles 27 de Mayo de 2009 (12:59:37)
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
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteValidatePut As Boolean

		Try

			llExecuteValidatePut = .T.

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

		Return llExecuteValidatePut

	Endproc && ClassBeforeBizValidation
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Validar antes de grabar
	Procedure HookBeforeBizValidation() As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 27 de Mayo de 2009 (12:59:37)
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
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteValidatePut As Boolean

		Try

			llExecuteValidatePut = .T.

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

		Return llExecuteValidatePut

	Endproc && HookBeforeBizValidation
	*
	* Validar antes de grabar
	Protected Procedure BizValidation() As Void;
			HELPSTRING "Validar antes de grabar"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Validar antes de grabar
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 27 de Mayo de 2009 (12:59:37)
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

	Endproc && ValidatePut
	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Validar antes de grabar
	Procedure HookAfterBizValidation() As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 27 de Mayo de 2009 (12:59:37)
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

	Endproc && HookAfterBizValidation
	*
	* ClassAfter Event
	* Validar antes de grabar
	Protected Procedure ClassAfterBizValidation() As Void


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
			Miércoles 27 de Mayo de 2009 (12:59:37)
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

	Endproc && ClassAfterBizValidation


	* Carga la coleccion Tables
	Protected Procedure GetColTables() As Collection;
			HELPSTRING "Carga la coleccion Tables"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Carga la coleccion Tables
			*:Project:Sistemas Praxis
			*:Autor:Ricardo Aidelman
			*:Date:Lunes 4 de Mayo de 2009 (13:56:06)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local loColTables As ColTables Of "FW\TierAdapter\Comun\colTables.prg"
		Local loEntityTable As oTable Of "FW\TierAdapter\Comun\colTables.prg"
		Local loTable As oTable Of "FW\TierAdapter\Comun\colTables.prg"
		Local loMain As utArchivo Of "FW\Tieradapter\UserTier\utArchivo.prg"

		Try

			If This.lIsChild
				loMain 				= This.GetMain()

				*!*	                If Lower( loMain.cTierLevel ) # Lower( "User" )
				*!*	                    loMain = This.InstanciateEntity( This.cMainEntity, "Service" )
				*!*	                EndIf
				* DA 2009-07-21(12:42:38)
				If Lower( loMain.cDataConfigurationKey ) = Lower( This.cDataConfigurationKey )
					loMain = This.InstanciateEntity( This.cMainEntity, "Service" )
				Endif

				loEntityTable 		= loMain.oColTables.GetTable( This.cTableName )

				* Crear la colección tables
				This.oColTables = Newobject( This.cColTablesClass, This.cColTablesClassLibrary )

				* Agregarse como tabla principal a su propia colección tables
				loTable 			= This.oColTables.New( loEntityTable.CursorName )
				loTable.Tabla 		= loEntityTable.Tabla
				loTable.PKName 		= loEntityTable.PKName
				loTable.Padre 		= ""
				loTable.ForeignKey 	= ""
				loTable.MainID 		= ""
				loTable.OrderBy 	= loEntityTable.OrderBy
				loTable.SQLStat 	= loEntityTable.SQLStat

				* Cargar las tablas hijas
				This.LookOverColTables( loEntityTable.oColTables, ;
					"LoadChildTables",;
					loTable.PKName )

				* Validar la colección
				If This.lIsOk .And. !Empty( This.oColTables.Count )
					This.lIsOk = This.oColTables.Validate()
				Endif

			Else
				This.oColTables = Newobject( This.cColTablesClass, This.cColTablesClassLibrary )
				If This.ClassBeforeCreateColTables() And This.lIsOk
					If This.HookBeforeCreateColTables() And This.lIsOk

						This.CreateColTables()

						If This.lIsOk
							This.HookAfterCreateColTables()
						Endif

						If This.lIsOk
							This.ClassAfterCreateColTables()
						Endif

						If This.lIsOk .And. !Empty( This.oColTables.Count )
							This.lIsOk = This.oColTables.Validate()
						Endif

					Endif
				Endif
			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			loEntityTable = Null
			loMain = Null
			loTable = Null
			loColTables = Null
			If !This.lIsOk
				Throw This.oError
			Endif
		Endtry

		Return This.oColTables

	Endproc




	* Crea la colección Tables
	Procedure CreateColTables() As Collection;
			HELPSTRING "Crea la colección Tables"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Crea la colección Tables
			*:Project:Sistemas Praxis
			*:Autor:Ricardo Aidelman
			*:Date:Lunes 4 de Mayo de 2009 (14:26:45)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local loTable As oTable Of "FW\TierAdapter\Comun\colTables.prg"
		Local loDDTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		*!*			Local loColTables as

		Try

			loColTables = NewColTables()
			loDDTable = loColTables.GetItem( This.cTableName )

			loTable = This.oColTables.New( loDDTable.CursorName )
			*!* Nombre de la tabla
			loTable.Tabla = loDDTable.Tabla

			*!* En la tabla hija va el nombre de la tabla padre
			loTable.Padre = loDDTable.Padre

			*!* en la tabla hija va el nombre del campo con el que se relaciona ;
			con la tabla padre (Foreign Key)
			loTable.ForeignKey = loDDTable.ForeignKey

			*!* Referencia al nombre del campo que contiene el ID de la tabla de ;
			nivel 1 con la que está relacionada.
			loTable.MainID = loDDTable.MainID

			*!* Para NEW y GETONE, se puede definir una sentencia SQL
			loTable.SQLStat = loDDTable.SQLStat

			*!* Nombre de la Primary Key de la tabla/nivel de la entidad
			loTable.PKName = loDDTable.PKName

			*!* Indica si la PK es Updatable para incluirla o no en la ;
			UpdatableFieldList
			loTable.PKUpdatable = loDDTable.PKUpdatable

			*!* Guarda la última sentencia SQL utilzada para consulta
			loTable.LastSQL = loDDTable.LastSQL

			*!* Colección de tablas hijas
			loTable.oColTables = loDDTable.oColTables

			*!* Nivel de profundidad de la tabla
			loTable.Nivel = loDDTable.Nivel

			*!*
			loTable.UpdatableFieldList = loDDTable.UpdatableFieldList

			*!*
			loTable.UpdateNameList = loDDTable.UpdateNameList

			*!* Obtiene la propiedad UpdateNameList de la sentencia SQL
			loTable.GetFieldListFromSQLStat = loDDTable.GetFieldListFromSQLStat

			*!*
			loTable.oCursorAdapter = loDDTable.oCursorAdapter

			* Numero de Registro Actual de la tabla
			loTable.CurReg = loDDTable.CurReg

			* Indica si la tabla es una tabla auxiliar
			loTable.Auxiliary = loDDTable.Auxiliary

			*!* Indica la clausula ORDER BY para el GetAll(), en caso de Nivel 1, o las tablas Hijas, para los demás niveles
			loTable.OrderBy = loDDTable.OrderBy

			*!* Utiliza SELECT * para generar la UpdatableFieldList. Si es .F., utiliza SQLStat
			loTable.lGenericUpdatableFieldList = loDDTable.lGenericUpdatableFieldList

			*!* Clausula WHERE para la tabla
			loTable.WhereStatement = loDDTable.WhereStatement

			* Nombre unico de la entidad en el archivo de configuracion
			loTable.cDataConfigurationKey = loDDTable.cDataConfigurationKey

			* Indica si la tabla implementa una extructura jerárquica
			loTable.lIsHierarchical = loDDTable.lIsHierarchical


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



	*
	Protected Procedure ClassBeforeCreateColTables() As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:Sistemas Praxis
			*:Autor:Ricardo Aidelman
			*:Date:Lunes 4 de Mayo de 2009 (14:41:35)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llReturn As Boolean

		Try

			llReturn = .T.

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

		Return llReturn

	Endproc


	*
	Procedure HookBeforeCreateColTables() As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:Sistemas Praxis
			*:Autor:Ricardo Aidelman
			*:Date:Lunes 4 de Mayo de 2009 (14:42:26)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llReturn As Boolean


		Try
			llReturn = .T.

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

		Return llReturn

	Endproc



	*
	Procedure HookAfterCreateColTables() As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:Sistemas Praxis
			*:Autor:Ricardo Aidelman
			*:Date:Lunes 4 de Mayo de 2009 (14:43:23)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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



	*
	Protected Procedure ClassAfterCreateColTables() As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:Sistemas Praxis
			*:Autor:Ricardo Aidelman
			*:Date:Lunes 4 de Mayo de 2009 (14:43:55)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	*
	* lSerialize_Access
	Protected Procedure lSerialize_Access()

		Return This.lSerialize

	Endproc && lSerialize_Access

	*
	* lMakeTransactable_Access
	Procedure lMakeTransactable_Access()

		Return This.lMakeTransactable

	Endproc && lMakeTransactable_Access



	*
	* oReport_Access
	Protected Procedure oReport_Access()

		If Vartype( This.oReport ) # "O"
			* <TODO>: Utilizar un FACTORY
			*!*				This.oReport = Newobject( "frxErpBaseReport","Erp\Actual\Comun\Frx\frxErpBaseReport.prg" )
		Endif
		Return This.oReport

		* <TODO>: Estudiar la version anterior

		*!*			Try

		*!*				Local lcAlias As String

		*!*				lcAlias = Alias()

		*!*				If IsEmpty( This.oReport )
		*!*					Local lcClass As String,;
		*!*						lcClassLibrary As String

		*!*					lcClass = This.cReportClass

		*!*					If Empty( This.cReportClassLibraryFolder )
		*!*						lcClassLibrary = This.cReportClassLibrary

		*!*					Else
		*!*						lcClassLibrary = Addbs( This.cReportClassLibraryFolder ) + This.cReportClassLibrary

		*!*					Endif

		*!*					This.GetAll( "1=0", "MyCursor" )

		*!*					This.oReport = Newobject( lcClass,;
		*!*						lcClassLibrary,;
		*!*						"",;
		*!*						Set("Datasession") )

		*!*				Endif


		*!*			Catch To oErr
		*!*				This.lIsOk = .F.
		*!*				This.cXMLoError=This.oError.Process( oErr )

		*!*			Finally
		*!*				If Used( lcAlias )
		*!*					Select Alias( lcAlias )
		*!*				Endif

		*!*			Endtry

		*!*			Return This.oReport

	Endproc && oReport_Access

	* ///////////////////////////////////////////////////////
	* Procedure.....: oColTables_Access
	* Date..........: Sábado 18 de Abril de 2009 (20:07:14)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure oColTables_Access()
		Local lcXML As String
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"


		Try
			If !This.lOnDestroy
				If Vartype( This.oColTables ) <> "O"
					*!*						This.oColTables = This.GetColTables()
					This.oColTables = Newobject( "ColTables", "colTables.prg" )
					loColTables = NewColTables()
					* RA 2009-11-04(18:18:12)
					*!*						loTable = loColTables.GetItem( This.cDataConfigurationKey )
					loTable = loColTables.GetItem( This.cTableName )
					This.oColTables.nNivelJerarquiaTablas = loTable.nNivelJerarquiaTablas
					This.oColTables.AddItem( loTable, Lower( This.cTableName ))

				Endif
			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif

		Finally
			loColTables = Null
			loTable = Null

			If ! This.lIsOk
				Throw This.oError

			Endif

		Endtry

		Return This.oColTables

	Endproc && oColTables_Access

	Procedure oServiceTier_Access()

		This.oServiceTier = Null

		Return This.oServiceTier

	Endproc

	Procedure oNextTier_Access()

		This.oNextTier = Null

		Return This.oNextTier

	Endproc

	*
	* Devuelve el valor de una propiedad del campo solicitado
	Procedure GetFieldProperty( tcFieldName As String, tcPropertyName As String ) As Variant;
			HELPSTRING "Decodifica el valor recibido en un nombre de campo válido"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve el valor de una propiedad del campo solicitado
			tcFieldName puede ser el nombre del campo o un nombre fantasía
			definido en el Diccionario de datos
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Jueves 28 de Mayo de 2009 (18:27:17)
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
			tcAtributo AS String
			*:Remarks:
			*:Returns:
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcPropertyValue As Variant
		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
		Local i As Integer


		Try

			lcPropertyValue = Null

			i = This.oDataDictionary.GetKey( Lower( This.cMainTableName + "." + tcFieldName ))

			If Empty( i )
				*!*					Error "No existe " + tcFieldName + " en el Diccionario de Datos"
				lcPropertyValue = tcFieldName

			Else
				loField = This.oDataDictionary.Item( i )
				lcPropertyValue = loField.&tcPropertyName

			Endif


		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			loField = Null
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return lcPropertyValue

	Endproc && GetFieldProperty

	*
	* Devuelve la longitud del campo desde la Base de Datos
	Procedure GetFieldSize( tcFieldName As String ) As Integer;
			HELPSTRING "Devuelve la longitud del campo desde la Base de Datos"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve la longitud del campo desde la Base de Datos
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Jueves 28 de Mayo de 2009 (17:29:36)
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
			tcfieldname AS Integer
			*:Remarks:
			*:Returns:
			Integer
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			Local lnLen As Integer

			lnLen = This.oEntity.GetFieldSize( tcFieldName )

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

		Return lnLen

	Endproc && GetFieldSize


	*
	* Devuelve el valor del campo pedido
	Procedure GetValue( tcFieldName As String, tcEntityCursor As String ) As Variant;
			HELPSTRING "Devuelve el valor del atributo pedido"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve el valor del campo pedido.
			Puede ser el nombre de un campo o un alias del mismo, que es el que se expone.
			Esto es, yo puedo pedir oEntity.GetValue( "Cotizacion de Venta" ),
			y que internamente la entidad resuelva que debe hacer
				Evaluate( This.EntityCursor + ".CotVentas" )
			Actúa como un Getter, evaluando los permisos antes de devolver el valor
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Jueves 28 de Mayo de 2009 (18:10:57)
			*:ModiSummary:
			DAE 2009-09-14(13:28:00)
			Agregue el parametro tcEntityCursor para poder utilizar
			otro Alias y no el cEntityCursor de la entidad
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			tcAtributo AS String
			tcEntityCursor As String
			*:Remarks:
			*:Returns:
			Variant
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif


		Local luValue As Variant
		Local lcFieldName As String
		Local lcEntityCursor As String
		Try
			With This As ServiceTier Of fw\tieradapter\ServiceTier\ServiceTier.prg

				luValue = Null

				lcFieldName = .GetFieldProperty( tcFieldName, "Name" )
				* DAE 2009-09-14(13:30:07)
				If Empty( tcEntityCursor )
					lcEntityCursor = .cEntityCursor

				Else
					lcEntityCursor = tcEntityCursor

				Endif


				Try

					*!*	If Eof( lcEntityCursor ) Or Bof( lcEntityCursor )
					*!*	    Goto Top In ( lcEntityCursor )

					*!*	Endif
					Select Alias( lcEntityCursor )

					TEXT To lcCommand NoShow TextMerge Pretext 15
						Locate For <<.cMainCursorPK>> = <<.nEntidadId>>
					ENDTEXT

					&lcCommand

					luValue = Evaluate( lcEntityCursor + "." + lcFieldName )

				Catch To oErr
					luValue = Null

				Finally

				Endtry

				If ! .UserCanRead( lcFieldName )
					* Si no tiene permiso para leer
					* Devolver el equivalente al Empty() del tipo de dato
					Do Case
						Case Vartype( luValue ) = "C"
							luValue = ""

						Case Vartype( luValue ) = "D"
							luValue = {}

						Case Vartype( luValue ) = "L"
							luValue = .F.

						Case Vartype( luValue ) = "N"
							luValue = 0

						Case Vartype( luValue ) = "Q"
							luValue = ""

						Case Vartype( luValue ) = "T"
							luValue = Ctot( "" )

						Case Vartype( luValue ) = "Y"
							luValue = 0

						Otherwise

							luValue = Null

					Endcase

				Endif

			Endwith

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

		Return luValue

	Endproc && GetValue


	*
	* Graba el valor en el campo
	Procedure SetValue( tcFieldName As String,;
			tuValue As Variant, tcEntityCursor As String ) As Boolean;
			HELPSTRING "Graba el valor en el campo asociado al atributo"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Graba el valor en el campo
			Actúa como un Setter, evaluando los permisos antes de establecer el valor
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Jueves 28 de Mayo de 2009 (18:13:47)
			*:ModiSummary:
			DAE 2009-09-14(13:28:00)
			Agregue el parametro tcEntityCursor para poder utilizar
			otro Alias y no el cEntityCursor de la entidad
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			tcAtributo AS String
			tuValue As Variant
			tcEntityCursor As String
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcFieldName As String
		Local lcEntityCursor  As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try
			With This As ServiceTier Of fw\tieradapter\ServiceTier\ServiceTier.prg
				lcFieldName = .GetFieldProperty( tcFieldName, "Name" )

				If .UserCanUpdate( lcFieldName )
					* DAE 2009-09-14(13:29:47)
					If Empty( tcEntityCursor )
						lcEntityCursor = .cEntityCursor

					Else
						lcEntityCursor = tcEntityCursor

					Endif && Empty( tcEntityCursor )

					Select Alias( lcEntityCursor )
					TEXT To lcCommand NoShow TextMerge Pretext 15
						Locate For <<.cMainCursorPK>> = <<.nEntidadId>>
					ENDTEXT

					&lcCommand

					Replace &lcFieldName With tuValue In ( lcEntityCursor )

				Endif

			Endwith

		Catch To oErr
			* DAE 2009-11-09(18:12:27)
			*!*	If This.lIsOk
			*!*		This.lIsOk = .F.
			*!*		This.cXMLoError=This.oError.Process( oErr )
			*!*	Endif
			This.lIsOk = .F.
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.TraceLogin = 'SetValue: ' + Transform( lcFieldName ) + ' = ' + Transform( tuValue )
			This.cXMLoError = loError.Process( oErr )

			Throw loError

		Finally
			*!*	If !This.lIsOk
			*!*		Throw This.oError
			*!*	Endif

		Endtry

	Endproc && SetValue

	*
	* Indica si el usuario puede leer el campo
	Protected Procedure UserCanRead( tcFieldName As String ) As Boolean;
			HELPSTRING "Indica si el usuario puede leer el campo"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Indica si el usuario puede leer el campo
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Jueves 28 de Mayo de 2009 (19:10:07)
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
			tcFieldName AS String
			*:Remarks:
			*:Returns:
			Bollean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llCanRead As Boolean

		Try

			llCanRead = .T.

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

		Return llCanRead

	Endproc && UserCanRead

	*
	* Indica si el usuario puede modificar el campo
	Protected Procedure UserCanUpdate( tcFieldName As String ) As Boolean;
			HELPSTRING "Indica si el usuario puede modificar el campo"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Indica si el usuario puede modificar el campo
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Jueves 28 de Mayo de 2009 (19:10:07)
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
			tcFieldName AS String
			*:Remarks:
			*:Returns:
			Bollean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llCanUpdate As Boolean

		Try

			llCanUpdate = .T.

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

		Return llCanUpdate

	Endproc && UserCanUpdate

	Procedure oColGridLayout_Access

		If Vartype( This.oColGridLayout ) <> "O"
			This.oColGridLayout = Newobject( "colGridLayout",  ;
				"Fw\Actual\Comun\Prg\colGridLayout.prg" )

			This.SetGridLayout()

		Endif

		Return This.oColGridLayout

	Endproc

	*
	* oColKeyFinderControls_Access
	Protected Procedure oColKeyFinderControls_Access()

		If Vartype( This.oColKeyFinderControls ) # "O"
			This.oColKeyFinderControls = Newobject( "ColFields", "Tools\Sincronizador\colDataBases.prg" )
			This.SetKeyFinderControls()
		Endif

		Return This.oColKeyFinderControls

	Endproc && oColKeyFinderControls_Access


	*
	* oColKeyFinderFastSearch_Access
	Protected Procedure oColKeyFinderFastSearch_Access()

		If Vartype( This.oColKeyFinderFastSearch ) # "O"
			This.oColKeyFinderFastSearch = Newobject( "ColFields", "Tools\Sincronizador\colDataBases.prg" )
			This.SetFastSearchControls()
		Endif

		Return This.oColKeyFinderFastSearch

	Endproc && oColKeyFinderFastSearch_Access


	*
	* ClassBefore Event
	* Define los campos de la grilla asociada a la entidad
	Protected Procedure ClassBeforeSetGridLayout() As Boolean


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
			Martes 23 de Junio de 2009 (11:50:36)
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
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteSetGridLayout As Boolean

		Try

			llExecuteSetGridLayout = .T.

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

		Return llExecuteSetGridLayout

	Endproc && ClassBeforeSetGridLayout
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Define los campos de la grilla asociada a la entidad
	Procedure HookBeforeSetGridLayout() As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Martes 23 de Junio de 2009 (11:50:36)
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
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteSetGridLayout As Boolean

		Try

			llExecuteSetGridLayout = .T.

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

		Return llExecuteSetGridLayout

	Endproc && HookBeforeSetGridLayout

	*
	* ResetError
	Procedure ResetError() As Void
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			This.lIsOk = .T.
			This.cXMLoError = ''

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr, .F. )

		Finally
			loError = Null

		Endtry

	Endproc && ResetError

	*
	* Define los campos de la grilla asociada a la entidad
	Protected Procedure SetGridLayout() As Void;
			HELPSTRING "Define los campos de la grilla asociada a la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Define los campos de la grilla asociada a la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Martes 23 de Junio de 2009 (11:50:36)
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
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loFieldAux As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local loGridLayout As oGridLayout Of "Fw\Comunes\Prg\colGridLayout.prg"
		Local loColData As PrxCollection Of fw\tieradapter\comun\prxbaselibrary.prg
		Local loColFields As ColFields Of "Tools\Sincronizador\colDataBases.prg"
		*
		Local lcName As String
		Local lcWhere As String
		*
		Local lnCnt As Integer
		Local i As Integer
		Local j As Integer
		Local lnIndex As Integer

		Try
			With This As ServiceTier Of fw\tieradapter\ServiceTier\ServiceTier.prg

				If .lIsOk And .ClassBeforeSetGridLayout()

					If .lIsOk And .HookBeforeSetGridLayout()

						lnCnt = 0
						loError = This.oError

						* Obtengo la coleccion Tables
						loColTables = NewColTables()

						* Obtengo la tabla
						loTable = loColTables.GetItem( This.cMainTableName )

						* Obtengo los campos que van en la colección
						loError.TraceLogin = 'Filtro oColFields'

						*!*	lcWhere = 'lShowInGrid = .T. '
						lcWhere = ' nGridOrder # 0 '
						*!*	loColData =  loTable.oColFields.Where( lcWhere )

						*!*	loError.TraceLogin = 'Indexo los resultados'
						*!*	loColData.IndexOn( 'nGridOrder' )

						loColData =  loTable.oColFields.Query( "", 0, .F., "", lcWhere, .F., 'nGridOrder' )

						For i = 1 To loColData.Count
							loField = loColData.Item[ i ]
							lnCnt = lnCnt + 1 && Contador para ver cuantos Objetos se han procesado

							If ! Empty( loField.References )
								loTable = loColTables.GetItem( loField.References )
								loColFields = loTable.oColFields.Query( '', 0, .F., '', ' nDefaultReference # 0 ', .F., 'nDefaultReference' )
								For j = 1 To loColFields.Count
									loFieldAux = loColFields.Item[ j ]
									* DA 2009-07-15(11:55:58)
									* Tomo la configuración del campo original sin importar si se reemplazó
									= loFieldAux.Caption
									lcName = Lower( loField.References + loFieldAux.Name )
									lnIndex = .oColGridLayout.GetKey( lcName )
									If Empty( lnIndex )
										loGridLayout = .oColGridLayout.NewFromField( loFieldAux, lcName )

										If .lHasDefault
											loGridLayout.ColumnDynamicFontBold = 'Iif( Default = 1, .T., .F. )'

										Endif && .lHasDefault

										* DA 2009-07-15(11:55:58)
										* Tomo la configuración del campo original sin importar si se reemplazó
										loGridLayout.lFitColumn = loFieldAux.lFitColumn
										loGridLayout.Width = Iif( loField.nGridOrder > 0, loGridLayout.Width, 0 )
										loGridLayout.ColumnWidth = Iif( loField.nGridOrder > 0, loGridLayout.ColumnWidth, 0 )

									Endif && Empty( lnIndex )

								Endfor

							Else && ! Empty( loField.References )
								loFieldAux = loField
								lcName = Lower( loFieldAux.Name )
								lnIndex = .oColGridLayout.GetKey( lcName )
								If Empty( lnIndex )
									* DA 2009-07-15(11:55:58)
									* Tomo la configuración del campo original sin importar si se reemplazó
									= loFieldAux.Caption
									loGridLayout = .oColGridLayout.NewFromField( loFieldAux, lcName )

									If .lHasDefault
										loGridLayout.ColumnDynamicFontBold = 'Iif( Default = 1, .T., .F. )'

									Endif && .lHasDefault

									* DA 2009-07-15(11:55:58)
									* Tomo la configuración del campo original sin importar si se reemplazó
									loGridLayout.lFitColumn = loFieldAux.lFitColumn
									loGridLayout.Width = Iif( loFieldAux.nGridOrder > 0, loGridLayout.Width, 0 )
									loGridLayout.ColumnWidth = Iif( loFieldAux.nGridOrder > 0, loGridLayout.ColumnWidth, 0 )

								Endif && Empty( lnIndex )

							Endif && ! Empty( loField.References )

						Endfor

						*!*	* For Each loField In loColData
						*!*	For i = 1 To loColData.Count
						*!*		loField = loColData.Item[ i ]
						*!*		lnCnt = lnCnt + 1 && Contador para ver cuantos Objetos se han procesado

						*!*		If ! Empty( loField.References )
						*!*			loTable = loColTables.GetItem( loField.References )
						*!*			loFieldAux = loTable.oColFields.GetItem( 'Descripcion' )
						*!*			lcName = loTable.Name + loFieldAux.Name
						*!*			lnIndex2 = This.oColGridLayout.GetKey( Lower( lcName ) )

						*!*		Else && Empty( loField.References )
						*!*			lnIndex2 = 0

						*!*		Endif && Empty( loField.References )

						*!*		lnIndex = This.oColGridLayout.GetKey( Lower( loField.cKeyName ) )

						*!*		If Empty( lnIndex ) And Empty( lnIndex2 )
						*!*			loFieldAux = loField
						*!*			If Empty( loFieldAux.References )
						*!*				lcName = loFieldAux.Name

						*!*			Else
						*!*				loTable = loColTables.GetItem( loField.References )
						*!*				loFieldAux = loTable.oColFields.GetItem( 'Descripcion' )

						*!*				lcName = loTable.Name + loFieldAux.Name
						*!*				* DA 2009-08-25(10:31:51)
						*!*				loFieldAux.Caption = loField.Caption
						*!*
						*!*			Endif && ! Empty( loFieldAux.References )

						*!*			loGridLayout = This.oColGridLayout.NewFromField( loFieldAux, Lower( lcName ) )


						*!*			If .lHasDefault
						*!*				loGridLayout.ColumnDynamicFontBold = 'Iif( Default = 1, .T., .F. )'

						*!*			Endif && .lHasDefault

						*!*			* DA 2009-07-15(11:55:58)
						*!*			* Tomo la configuración del campo original sin importar si se reemplazó
						*!*			loGridLayout.lFitColumn = loField.lFitColumn

						*!*		Endif
						*!*	Endfor


						If .lIsOk
							.HookAfterSetGridLayout()

						Endif && .lIsOky

					Endif

					If .lIsOk
						.ClassAfterSetGridLayout()

					Endif && .lIsOk

				Endif

			Endwith
		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif && This.lIsOk

		Finally
			loError = Null
			loField = Null
			loFieldAux = Null
			loTable = Null
			loGridLayout = Null
			loColData = Null
			loColTables = Null

			If ! This.lIsOk
				Throw This.oError

			Endif && ! This.lIsOk

		Endtry

	Endproc && SetGridLayout




	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Define los campos de la grilla asociada a la entidad
	Procedure HookAfterSetGridLayout() As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Martes 23 de Junio de 2009 (11:50:36)
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

	Endproc && HookAfterSetGridLayout
	*
	* ClassAfter Event
	* Define los campos de la grilla asociada a la entidad
	Protected Procedure ClassAfterSetGridLayout() As Void


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
			Martes 23 de Junio de 2009 (11:50:36)
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

	Endproc && ClassAfterSetGridLayout




	*
	* Permite realizar modificaciones a la entidad
	Procedure ProcessEntity() As String;
			HELPSTRING "Permite realizar modificaciones a la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Permite realizar modificaciones a la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 17 de Julio de 2009 (10:16:10)
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
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcXML As String

		Try

			lcXML = ""

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

		Return lcXML

	Endproc && ProcessEntity


	* ///////////////////////////////////////////////////////
	* Procedure.....: ProcessLinkedEntities
	* Description...: Procesa otras entidades asociadas
	* Date..........: Viernes 13 de Julio de 2007 (17:59:33)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure ProcessLinkedEntities() As String;
			HELPSTRING "Procesa otras entidades asociadas"

		Local lcProcedureName As String
		Local loEntity As Object
		Local lcXML As String

		Try

			* Ejecuta el método definido en la propiedad ProcedureName
			* (si no se definió un metodo explicitamente, se trata de ejecutar
			* un metodo llamado ProcessXXX, donde XXX es el contenido de la propiedad
			* Name.

			lcXML = ""

			*!*				For Each loEntity In This.oColEntities
			*!*					If Pemstatus( This, loEntity.ProcedureName, 5 )
			*!*						lcProcedureName = loEntity.ProcedureName
			*!*						lcXML = This.&lcProcedureName()

			*!*					Else
			*!*						This.oError.TraceLogin = "Procesando la colección Entities"
			*!*						This.oError.Remark = "Ejecutando el metodo definido en loEntity.ProcedureName"
			*!*						Error "No existe el método " + loEntity.ProcedureName

			*!*					Endif

			*!*					If !This.lIsOk
			*!*						Exit
			*!*					Endif
			*!*				Endfor

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError=This.oError.Process( oErr )

		Finally
			loEntity = Null

		Endtry

		Return lcXML

	Endproc
	*
	* END PROCEDURE ProcessLinkedEntities
	*
	* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: nEntidadId_Access
	*!* Date..........: Jueves 16 de Julio de 2009 (15:05:47)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure nEntidadId_Access() As Integer

		Return This.nEntidadId

	Endproc && nEntidadId_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: nEntidadId_Assign
	*!* Date..........: Jueves 16 de Julio de 2009 (15:05:47)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure nEntidadId_Assign( uNewValue  As Integer )

		This.nEntidadId = uNewValue

	Endproc && nEntidadId_Assign


	*
	* Devuelve una instancia del objeto
	Procedure InstanciateEntity( tcEntityName As String,;
			tcTierLevel As String,;
			tcObjectFactoryFileName As String ) As Object;
			HELPSTRING "Devuelve una instancia del objeto"

		Return DoDefault( tcEntityName, "User", tcObjectFactoryFileName )

	Endproc && InstanciateEntity



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetEntity
	*!* Description...: Devuelve un Objeto de la colección Entities
	*!* Date..........: Miércoles 14 de Mayo de 2008 (18:41:10)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetEntity( tcEntityName As String,;
			tcTierLevel As String ) As Object;
			HELPSTRING "Devuelve un Objeto de la colección Entities"


		Return This.oEntity.GetEntity( tcEntityName, tcTierLevel )

	Endproc

	*
	* nNivelJerarquiaTablas_Access
	Protected Procedure nNivelJerarquiaTablas_Access()
		If Empty( This.nNivelJerarquiaTablas )
			This.nNivelJerarquiaTablas = This.oColTables.nNivelJerarquiaTablas
		Endif

		Return This.nNivelJerarquiaTablas

	Endproc && nNivelJerarquiaTablas_Access


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: lIsChild_Access
	*!* Date..........: Martes 21 de Julio de 2009 (11:28:07)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure lIsChild_Access()

		This.lIsChild = This.oEntity.lIsChild
		Return This.lIsChild

	Endproc
	*!*
	*!* END PROCEDURE lIsChild_Access
	*!*
	*!* ///////////////////////////////////////////////////////

	*
	* Carga las tablas hijas
	Procedure LoadChildTables( toTable As Object,;
			tcMainID As String ) As Void;
			HELPSTRING "Carga las tablas hijas"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Carga las tablas hijas
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Martes 2 de Junio de 2009 (09:46:59)
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
			toColTables AS Object
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			loTable 			= This.oColTables.New( toTable.CursorName )
			loTable.Tabla 		= toTable.Tabla
			loTable.PKName 		= toTable.PKName
			loTable.Padre 		= toTable.Padre
			loTable.ForeignKey 	= toTable.ForeignKey
			loTable.MainID 		= tcMainID
			loTable.OrderBy 	= toTable.OrderBy
			loTable.SQLStat 	= toTable.SQLStat

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

	Endproc && LoadChildTables

	*
	* lIsChild_Assign
	Protected Procedure lIsChild_Assign( uNewValue )

		This.lIsChild = uNewValue

	Endproc && lIsChild_Assign


	*
	*
	Protected Procedure GetAll( tcFilterCriteria As String,;
			tcCursorAlias As String,;
			tcOrderBy As String ) As String


		Return This.oEntity.GetAll( tcFilterCriteria, tcCursorAlias, tcOrderBy )

	Endproc && GetAll


	*
	* Recibe un XML y lo convierte en cursores
	Protected Procedure GetData( tcData As String ) As String;
			HELPSTRING "Recibe un XML y lo convierte en cursores"


		Return This.oEntity.GetData( tcData )


	Endproc



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oColGridSelectorLayout_Access
	*!* Date..........: Martes 28 de Julio de 2009 (09:27:02)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oColGridSelectorLayout_Access()

		If Vartype( This.oColGridSelectorLayout ) # "O"
			This.oColGridSelectorLayout = Newobject( "colGridLayout",  ;
				"Fw\Actual\Comun\Prg\colGridLayout.prg" )

			This.SetGridSelectorLayout()

		Endif

		Return This.oColGridSelectorLayout

	Endproc && oColGridSelectorLayout_Access

	*
	* ClassBefore Event
	* Define los campos de la grilla del selector asociada a la entidad
	Protected Procedure ClassBeforeSetGridSelectorLayout() As Boolean;
			HELPSTRING "Define los campos de la grilla del selector asociada a la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Define los campos de la grilla del selector asociada a la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 28 de Julio de 2009 (09:39:34)
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
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteSetGridSelectorLayout As Boolean

		Try

			llExecuteSetGridSelectorLayout = .T.

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

		Return llExecuteSetGridSelectorLayout

	Endproc && ClassBeforeSetGridSelectorLayout



	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Define los campos de la grilla del selector asociada a la entidad
	Procedure HookBeforeSetGridSelectorLayout() As Boolean;
			HELPSTRING "Define los campos de la grilla del selector asociada a la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Define los campos de la grilla del selector asociada a la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 28 de Julio de 2009 (09:41:26)
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
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteSetGridSelectorLayout As Boolean

		Try

			llExecuteSetGridSelectorLayout = .T.

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

		Return llExecuteSetGridSelectorLayout

	Endproc && HookBeforeSetGridSelectorLayout


	*
	* Define los campos del selector asociado a la entidad
	Protected Procedure SetGridSelectorLayout() As Void;
			HELPSTRING "Define los campos del selector asociado a la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Define los campos de la grilla asociada a la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Martes 23 de Junio de 2009 (11:50:36)
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
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loFieldAux As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local loGridLayout As oGridLayout Of "Fw\Comunes\Prg\colGridLayout.prg"
		Local loColData As PrxCollection Of fw\tieradapter\comun\prxbaselibrary.prg
		Local lnIndex As Boolean
		Local lcName As String
		Local lnCnt As Integer
		Local i As Integer
		Local j As Integer

		*Set Step On
		Try
			With This As ServiceTier Of fw\tieradapter\ServiceTier\ServiceTier.prg

				If .lIsOk And .ClassBeforeSetGridSelectorLayout()

					If .lIsOk And .HookBeforeSetGridSelectorLayout()

						lnCnt = 0
						loError = This.oError

						* Obtengo la coleccion Tables
						loColTables = NewColTables()

						* Obtengo la tabla
						loTable = loColTables.GetItem( This.cMainTableName )

						* Obtengo los campos que van en la colección
						loError.TraceLogin = 'Filtro oColFields'

						* lcWhere = 'lShowInSelector = .T. '
						*!*	loColData =  loTable.oColFields.Where( lcWhere )

						*!*	loError.TraceLogin = 'Indexo los resultados'
						*!*	loColData.IndexOn( 'nGridOrder' )
						lcWhere = 'nSelectorOrder # 0'

						loColData =  loTable.oColFields.Query( "", 0, .F., "", lcWhere, .F., 'nSelectorOrder' )

						For i = 1 To loColData.Count
							loField = loColData.Item[ i ]
							loField.nSelectorOrder
							lnCnt = lnCnt + 1 && Contador para ver cuantos Objetos se han procesado

							If ! Empty( loField.References )
								loTable = loColTables.GetItem( loField.References )
								loColFields = loTable.oColFields.Query( '', 0, .F., '', ' nDefaultReference # 0 ', .F., 'nDefaultReference' )
								For j = 1 To loColFields.Count
									loFieldAux = loColFields.Item[ j ]
									* DA 2009-07-15(11:55:58)
									* Tomo la configuración del campo original sin importar si se reemplazó
									= loFieldAux.Caption
									lcName = Lower( loField.References + loFieldAux.Name )
									lnIndex = .oColGridSelectorLayout.GetKey( lcName )
									If Empty( lnIndex )
										loGridLayout = .oColGridSelectorLayout.NewFromField( loFieldAux, lcName, "", .T. )

										If .lHasDefault
											loGridLayout.ColumnDynamicFontBold = 'Iif( Default = 1, .T., .F. )'

										Endif && .lHasDefault

										* DA 2009-07-15(11:55:58)
										* Tomo la configuración del campo original sin importar si se reemplazó
										loGridLayout.lFitColumn = loFieldAux.lFitColumn
										loGridLayout.nlength = Min( 25, loGridLayout.nlength )
										loGridLayout.Width = Iif( loField.nSelectorOrder > 0, loGridLayout.Width, 0 )
										loGridLayout.ColumnWidth = Iif( loField.nSelectorOrder > 0, loGridLayout.ColumnWidth, 0 )

									Endif && Empty( lnIndex )

								Endfor

							Else && ! Empty( loField.References )
								loFieldAux = loField
								lcName = Lower( loFieldAux.Name )
								lnIndex = .oColGridSelectorLayout.GetKey( lcName )
								If Empty( lnIndex )
									* DA 2009-07-15(11:55:58)
									* Tomo la configuración del campo original sin importar si se reemplazó
									= loFieldAux.Caption
									loGridLayout = .oColGridSelectorLayout.NewFromField( loFieldAux, lcName )

									If .lHasDefault
										loGridLayout.ColumnDynamicFontBold = 'Iif( Default = 1, .T., .F. )'

									Endif && .lHasDefault

									* DA 2009-07-15(11:55:58)
									* Tomo la configuración del campo original sin importar si se reemplazó
									loGridLayout.lFitColumn = loField.lFitColumn
									loGridLayout.nlength = Min( 25, loGridLayout.nlength )
									loGridLayout.Width = Iif( loFieldAux.nSelectorOrder > 0, loGridLayout.Width, 0 )
									loGridLayout.ColumnWidth = Iif( loFieldAux.nSelectorOrder > 0, loGridLayout.ColumnWidth, 0 )

								Endif && Empty( lnIndex )

							Endif && ! Empty( loField.References )

						Endfor

						*!*							For Each loField In loColData
						*!*								lnCnt = lnCnt + 1 && Contador para ver cuantos Objetos se han procesado

						*!*								If ! Empty( loField.References )
						*!*									loTable = loColTables.GetItem( loField.References )
						*!*									loFieldAux = loTable.oColFields.GetItem( 'Descripcion' )
						*!*									lcName = loTable.Name + loFieldAux.Name
						*!*									lnIndex2 = This.oColGridSelectorLayout.GetKey( Lower( lcName ) )

						*!*								Else && Empty( loField.References )
						*!*									lnIndex2 = 0

						*!*								Endif && Empty( loField.References )

						*!*								lnIndex = This.oColGridSelectorLayout.GetKey( Lower( loField.cKeyName ) )

						*!*								If Empty( lnIndex ) And Empty( lnIndex2 )
						*!*									loFieldAux = loField
						*!*									If Empty( loFieldAux.References )
						*!*										lcName = loFieldAux.Name

						*!*									Else
						*!*										loTable = loColTables.GetItem( loField.References )
						*!*										loFieldAux = loTable.oColFields.GetItem( 'Descripcion' )

						*!*										lcName = loTable.Name + loFieldAux.Name

						*!*									Endif && ! Empty( loFieldAux.References )

						*!*									* DA 2009-08-14(09:19:10)
						*!*									* Se asigna al campo auxiliar el caption que se utilizó para la Foreign Key
						*!*									loFieldAux.Caption = loField.Caption

						*!*									loGridLayout = This.oColGridSelectorLayout.NewFromField( loFieldAux, Lower( lcName ) )

						*!*									If loGridLayout.nlength  > 25
						*!*										loGridLayout.nlength = 25
						*!*									Endif


						*!*									If .lHasDefault
						*!*										loGridLayout.ColumnDynamicFontBold = 'Iif( Default = 1, .T., .F. )'

						*!*									Endif && .lHasDefault

						*!*									* DA 2009-07-15(11:55:58)
						*!*									* Tomo la configuración del campo original sin importar si se reemplazó
						*!*									loGridLayout.lFitColumn = loField.lFitColumn

						*!*								Endif
						*!*							Endfor


						If .lIsOk
							.HookAfterSetGridSelectorLayout()

						Endif && .lIsOk

					Endif

					If .lIsOk
						.ClassAfterSetGridSelectorLayout()

					Endif && .lIsOk

				Endif

			Endwith
		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif && This.lIsOk

		Finally
			loError = Null
			loField = Null
			loFieldAux = Null
			loTable = Null
			loGridLayout = Null
			loColData = Null
			loColTables = Null

			If ! This.lIsOk
				Throw This.oError

			Endif && ! This.lIsOk

		Endtry

	Endproc && SetGridSelectorLayout


	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Define los campos de la grilla del selector asociada a la entidad
	Procedure HookAfterSetGridSelectorLayout() As Void;
			HELPSTRING "Define los campos de la grilla del selector asociada a la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Define los campos de la grilla del selector asociada a la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 28 de Julio de 2009 (09:44:17)
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

	Endproc && HookAfterSetGridSelectorLayout



	* ClassAfter Event
	* Define los campos de la grilla del selector asociada a la entidad
	Protected Procedure ClassAfterSetGridSelectorLayout() As Void;
			HELPSTRING "Define los campos de la grilla del selector asociada a la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Define los campos de la grilla del selector asociada a la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 28 de Julio de 2009 (09:42:55)
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

	Endproc && ClassAfterSetGridSelectorLayout



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: lHasDescripcion_Access
	*!* Date..........: Miércoles 29 de Julio de 2009 (12:24:03)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure lHasDescripcion_Access()

		Return This.lHasDescripcion

	Endproc && lHasDescripcion_Access



	Procedure lHasCodigo_Access()

		Return This.lHasCodigo

	Endproc

	Procedure lHasDefault_Access()

		Return This.lHasDefault

	Endproc

	Procedure lUseCodigo_Access()

		Return This.lUseCodigo

	Endproc

	Procedure nTransactionID_Access()
		This.nTransactionID = This.oEntity.nTransactionID
		Return This.nTransactionID

	Endproc




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oColImages_Access
	*!* Date..........: Viernes 6 de Febrero de 2009 (12:00:000)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Protected Procedure oColImages_Access() As PrxCollection Of fw\actual\comun\prg\prxbaselibrary.prg

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try
			loError = This.oError
			loError.Remark = ''
			loError.TraceLogin = ''
			With This As ServiceTier Of fw\tieradapter\ServiceTier\ServiceTier.prg

				If Vartype( .oColImages ) # 'O'

					.oColImages = Newobject( 'PrxCollection', 'fw\TierAdapter\comun\prxbaselibrary.prg' )
					.oColImages.cClassName = 'oImage'
					.oColImages.cClassLibrary = 'servicetier.prg'
					.oColImages.cClassLibraryFolder = 'fw\tieradapter\servicetier'

					.FillCollImages()

				Endif && Vartype( .oColImages ) # 'O'

			Endwith

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.Remark = ''
			loError.TraceLogin = ''
			loError = Null

		Endtry

		Return This.oColImages

	Endproc && oColImages_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: FillCollImages
	*!* Date..........: Viernes 6 de Febrero de 2009 (12:00:000)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Protected Procedure FillCollImages() As Void

	Endproc && FillCollImages




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oColNavigator_Access
	*!* Date..........: Viernes 31 de Julio de 2009 (12:01:49)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oColNavigator_Access()

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local lcWhere As String
		
		Local loColFields As ColFields Of "Tools\Sincronizador\ColDataBases.prg"
		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
		
		Try
			loError = This.oError
			loError.Remark = ''
			loError.TraceLogin = ''
			With This As ServiceTier Of fw\tieradapter\ServiceTier\ServiceTier.prg

				If Vartype( .oColNavigator ) # 'O'

*!*						* Obtengo la coleccion Tables
*!*						loColTables = NewColTables()

*!*						* Obtengo la tabla
*!*						loTable = loColTables.GetItem( This.cMainTableName )

*!*						* Obtengo los campos que van en la colección
*!*						loError.TraceLogin = 'Filtro oColFields'

*!*						lcWhere = 'lShowInNavigator = .T. '
*!*						.oColNavigator = loTable.oColFields.Where( lcWhere )
					
					loColFields = NewObject( "ColFields", "Tools\Sincronizador\ColDataBases.prg" )
					
					loField = loColFields.NewRegular( "Codigo", "I" )  
					 
					loColFields.NewRegular( "Descripcion", "C", 30 )
					
					.oColNavigator = loColFields  

					.FillColNavigator()

				Endif && Vartype( .oColNavigator ) # 'O'

			Endwith

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.Remark = ''
			loError.TraceLogin = ''
			loError = Null
			loTable = Null
			loColTables = Null
		Endtry

		Return This.oColNavigator

	Endproc && oColNavigator_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: FillColNavigator
	*!* Description...:
	*!* Date..........: Viernes 31 de Julio de 2009 (16:12:50)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure FillColNavigator() As Void

	Endproc && FillColNavigator




	*
	* Define los campos del control KeyFinder asociado a la entidad
	Protected Procedure SetKeyFinderControls() As Void;
			HELPSTRING "Define los campos del control KeyFinder asociado a la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Define los campos del control KeyFinder asociado a la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Martes 23 de Junio de 2009 (11:50:36)
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
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColData As PrxCollection Of fw\tieradapter\comun\prxbaselibrary.prg
		Local lnIndex As Boolean
		Local lcName As String
		Local i As Integer

		Try
			With This As ServiceTier Of fw\tieradapter\ServiceTier\ServiceTier.prg

				If .lIsOk And .ClassBeforeSetKeyFinderControls()

					If .lIsOk And .HookBeforeSetKeyFinderControls()

						loError = This.oError

						* Obtengo la coleccion Tables
						loColTables = NewColTables()

						* Obtengo la tabla
						loTable = loColTables.GetItem( This.cMainTableName )

						* Obtengo los campos que van en la colección
						loError.TraceLogin = 'Filtro oColFields'

						lcWhere = 'nShowInKeyFinder > 0 '
						*!* loColData =  loTable.oColFields.Where( lcWhere )
						loColData =  loTable.oColFields.Query( "", 0, .F., "", lcWhere, .F., 'nShowInKeyFinder' )

						*!* loError.TraceLogin = 'Indexo los resultados'
						*!* loColData.IndexOn( 'nShowInKeyFinder' )

						For i = 1 To loColData.Count

							loField = loColData.Item( i )

							lnIndex = This.oColKeyFinderControls.GetKey( Lower( loField.cKeyName ) )

							If Empty( lnIndex )
								lcName = loField.Name
								This.oColKeyFinderControls.AddItem( loField, Lower( lcName ) )

							Endif
						Endfor

						lcWhere = 'nShowInKeyFinder # 0 '
						loColData =  loTable.oColFields.Query( "", 0, .F., "", lcWhere, .F., 'nShowInKeyFinder' )

						This.oColKeyFinderFastSearch = loColData

						If .lIsOk
							.HookAfterSetKeyFinderControls()

						Endif && .lIsOk

					Endif

					If .lIsOk
						.ClassAfterSetKeyFinderControls()

					Endif && .lIsOk

				Endif

			Endwith
		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif && This.lIsOk

		Finally
			loError = Null
			loField = Null
			loTable = Null
			loColData = Null
			loColTables = Null

			If ! This.lIsOk
				Throw This.oError

			Endif && ! This.lIsOk

		Endtry

	Endproc && SetKeyFinderControls

	*
	* ClassBefore Event
	Protected Procedure ClassBeforeSetKeyFinderControls() As Boolean
		Return .T.

	Endproc && ClassBeforeSetKeyFinderControls

	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	Procedure HookBeforeSetKeyFinderControls() As Boolean

		Return .T.

	Endproc && HookBeforeSetKeyFinderControls

	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	Procedure HookAfterSetKeyFinderControls() As Void

	Endproc && HookAfterSetKeyFinderControls

	*
	* ClassAfter Event
	Protected Procedure ClassAfterSetKeyFinderControls() As Void

	Endproc && ClassAfterSetKeyFinderControls


	*
	* Define los campos para la búsqueda rápida
	Protected Procedure SetFastSearchControls() As Void;
			HELPSTRING "Define los campos para la búsqueda rápida"

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColData As PrxCollection Of fw\tieradapter\comun\prxbaselibrary.prg
		Local lnIndex As Boolean
		Local lcName As String

		Try
			With This As ServiceTier Of fw\tieradapter\ServiceTier\ServiceTier.prg

				If .lIsOk And .ClassBeforeSetFastSearchControls()

					If .lIsOk And .HookBeforeSetFastSearchControls()

						loError = This.oError

						* Obtengo la coleccion Tables
						loColTables = NewColTables()

						* Obtengo la tabla
						loTable = loColTables.GetItem( This.cMainTableName )

						* Obtengo los campos que van en la colección
						loError.TraceLogin = 'Filtro oColFields'

						lcWhere = 'lFastSearch = .T. '
						loColData =  loTable.oColFields.Where( lcWhere )

						This.oColKeyFinderFastSearch = loColData

						If .lIsOk
							.HookAfterSetFastSearchControls()

						Endif && .lIsOk

					Endif

					If .lIsOk
						.ClassAfterSetFastSearchControls()

					Endif && .lIsOk

				Endif

			Endwith
		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif && This.lIsOk

		Finally
			loError = Null
			loField = Null
			loTable = Null
			loColData = Null
			loColTables = Null

			If ! This.lIsOk
				Throw This.oError

			Endif && ! This.lIsOk

		Endtry

	Endproc && SetFastSearchControls

	*
	* ClassBefore Event
	Protected Procedure ClassBeforeSetFastSearchControls() As Boolean
		Return .T.

	Endproc && ClassBeforeSetFastSearchControls

	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	Procedure HookBeforeSetFastSearchControls() As Boolean

		Return .T.

	Endproc && HookBeforeSetFastSearchControls

	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	Procedure HookAfterSetFastSearchControls() As Void

	Endproc && HookAfterSetFastSearchControls

	*
	* ClassAfter Event
	Protected Procedure ClassAfterSetFastSearchControls() As Void

	Endproc && ClassAfterSetFastSearchControls



	Procedure HookAfterPut( tnIDEntidad As Integer,;
			tnLevel As Integer,;
			tnProcessType As Integer,;
			tcUniqueName As String ) As Void
	Endproc

	Procedure HookBeforePut( tnIDEntidad As Integer,;
			tnProcessType As Integer,;
			tcUniqueName As String ) As Boolean
		Return .T.
	Endproc

	Procedure HookBeforeTransactionBegin() As Boolean
		Return .T.
	Endproc

	Procedure HookAfterTransactionBegin() As Void
	Endproc

	Procedure GetAllFields()
		Local lcGetAllFields As String
		lcGetAllFields = ""
		Return lcGetAllFields
	Endproc


	Procedure GetAllJoins()
		Local lcGetAllJoins As String
		lcGetAllJoins = ""
		Return lcGetAllJoins
	Endproc

	Procedure GetAllPaginatedOrderBy()
		Local lcGetAllPaginatedOrderBy As String
		lcGetAllPaginatedOrderBy = ""
		Return lcGetAllPaginatedOrderBy
	Endproc

	*
	* cTableName_Access
	Protected Procedure cTableName_Access()

		If Empty( This.cTableName )
			This.cTableName = This.cDataConfigurationKey
		Endif

		Return This.cTableName

	Endproc && cTableName_Access


Enddefine && ServiceTier

*!* ///////////////////////////////////////////////////////
*!* Class.........: oImage
*!* ParentClass...: PrxSession
*!* Date..........: Jueves 30 de Julio de 2009
*!* Author........: Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

* Define Class oImage As PrxSession Of fw\tieradapter\comun\prxbaselibrary.prg
Define Class oImage As PrxCustom Of fw\tieradapter\comun\prxbaselibrary.prg
	#If .F.
		Local This As oImage Of fw\tieradapter\ServiceTier\ServiceTier.prg
	#Endif

	*!* Clave para identificar la imagen en el imagelist
	cKey = ''
	*!* Nombre del archivo
	cFileName = ''
	*!* Carpeta donde buscar el archivo
	cFolder = ''

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ckey" type="property" display="cKey" />] + ;
		[<memberdata name="cfilename" type="property" display="cFileName" />] + ;
		[<memberdata name="cfolder" type="property" display="cFolder" />] + ;
		[</VFPData>]

Enddefine && oImage