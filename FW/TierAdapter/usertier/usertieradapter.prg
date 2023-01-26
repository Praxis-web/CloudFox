#INCLUDE "FW\Tieradapter\Include\TA.h"
#INCLUDE "FW\ErrorHandler\EH.h"
*#INCLUDE "ERP\Comunes\Include\Erp.h"

*!*	Todas las rutinas de la capa de usuario devuelven un XML con el
*!*	conjunto de datos solicitado.
*!*	Si el XML está precedido por el prefijo <#ERR#>, lo que contiene
*!*	es la información del error producido en alguna de las capas
*!*	inferiores.
*!*	La propiedad lIsOk es un Flag que se pone en .F. si se produjo un
*!*	error, y la propiedad cXMLoError contiene tambien la información
*!*	del error producido, para los casos que no se devuelva un string.
*!*	El método ValidateXML() recibe el XML y crea el conjunto de datos
*!*	correspondiente, o llama al manejador de errores para que informe
*!*	del mismo

Define Class UserTierAdapter As tieradapter Of "FW\Tieradapter\Comun\TierAdapter.prg"

    #If .F.
        Local This As UserTierAdapter Of "FW\Tieradapter\UserTier\UserTierAdapter.prg"
    #Endif

    Protected nNivelJerarquiaTablas

    * Indica si se muestran mensajes por la pantalla
    lShowMessages = .T.

    * Default Datasession (in this tier, to join its client's datasession)
    DataSession = SET_DEFAULT

    * Indica el nivel de la capa dentro del modelo.
    cTierLevel = "User"

    * Mantiene el nivel de jerarquia de tablas del último New(),
    * GetOne() o GetAll() para usar en el Put().
    nNivelJerarquiaTablas = 0

    * Colección de elementos oGridLayout, que permiten personalizar la prxASctionGrid
    oColGridLayout = Null

    *!* Colección de elementos oGridSelectorLayout, que permiten personalizar la prxActionGrid para el Selector
    oColGridSelectorLayout = Null

    * Numero de registros (filas) por pagina (metodo GetAllPaginated)
    nRowsPerPage = 13

    *!* Coleccion de imagenes
    oColImages = Null

    *!* Colección de elementos oColNavigator, que permiten personalizar el Navegador
    oColNavigator = Null

    *!* Filtro para navegar por las entidades
    cNavigatorFilterCriteria = ''

    * Colección de controles que van el el control KeyFinder
    oColKeyFinderControls = Null

    * Colección de controles que van en la búsqueda rápida del KeyFinder
    oColKeyFinderFastSearch = Null

    * Contiene el nombre del formulario selector
    cSelectorFormName = ""

    * Nombre que se muestra de la Entidad
    cDisplayValue = ""


    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="ocolkeyfindercontrols" type="property" display="oColKeyFinderControls" />] + ;
        [<memberdata name="nniveljerarquiatablas" type="property" display="nNivelJerarquiaTablas" />] + ;
        [<memberdata name="nrowsperpage" type="property" display="nRowsPerPage" />] + ;
        [<memberdata name="validatexml" type="method" display="ValidateXML" />] + ;
        [<memberdata name="lshowmessages" type="property" display="lShowMessages" />] + ;
        [<memberdata name="hookaftergetone" type="method" display="HookAfterGetOne" />] + ;
        [<memberdata name="hookbeforegetone" type="method" display="HookBeforeGetOne" />] + ;
        [<memberdata name="hookafterput" type="method" display="HookAfterPut" />] + ;
        [<memberdata name="hookbeforeput" type="method" display="HookBeforePut" />] + ;
        [<memberdata name="hookbeforenew" type="method" display="HookBeforeNew" />] + ;
        [<memberdata name="hookafternew" type="method" display="HookAfterNew" />] + ;
        [<memberdata name="ocolgridlayout" type="property" display="oColGridLayout" />] + ;
        [<memberdata name="ocolgridlayout_access" type="method" display="oColGridLayout_Access" />] + ;
        [<memberdata name="doreport" type="method" display="DoReport" />] + ;
        [<memberdata name="genericquery" type="method" display="GenericQuery" />] + ;
        [<memberdata name="genericquery_getorderbyfields" type="method" display="GenericQuery_GetOrderByFields" />] + ;
        [<memberdata name="genericquery_getfilters" type="method" display="GenericQuery_GetFilters" />] + ;
        [<memberdata name="reportsetup" type="method" display="ReportSetUp" />] + ;
        [<memberdata name="oreport" type="property" display="oReport" />] + ;
        [<memberdata name="getreccount" type="property" display="GetRecCount" />] + ;
        [<memberdata name="identidad_assign" type="method" display="idEntidad_Assign" />] + ;
        [<memberdata name="ouser_access" type="method" display="oUser_Access" />] + ;
        [<memberdata name="getselectorformcaption" type="method" display="GetSelectorFormCaption" />] + ;
        [<memberdata name="getselectorformname" type="method" display="GetSelectorFormName" />] + ;
        [<memberdata name="getformname" type="method" display="GetFormName" />] + ;
        [<memberdata name="transactionbegin" type="method" display="TransactionBegin" />] + ;
        [<memberdata name="transactionend" type="method" display="TransactionEnd" />] + ;
        [<memberdata name="transactionrollback" type="method" display="TransactionRollBack" />] + ;
        [<memberdata name="getvalue" type="method" display="GetValue" />] + ;
        [<memberdata name="setvalue" type="method" display="SetValue" />] + ;
        [<memberdata name="setdefaults" type="method" display="SetDefaults" />] + ;
        [<memberdata name="lischild" type="property" display="lIsChild" />] + ;
        [<memberdata name="getpaginationroutinename" type="method" display="GetPaginationRoutineName" />] + ;
        [<memberdata name="interactivechange" type="method" display="InteractiveChange" />] + ;
        [<memberdata name="hookonparentchange" type="method" display="HookOnParentChange" />] + ;
        [<memberdata name="onchange" type="method" display="OnChange" />] + ;
        [<memberdata name="cmainentity_access" type="method" display="cMainEntity_Access" />] + ;
        [<memberdata name="onparentchange" type="method" display="OnParentChange" />] + ;
        [<memberdata name="internalgetrecno" type="method" display="InternalGetRecno" />] + ;
        [<memberdata name="getrecno" type="method" display="GetRecno" />] + ;
        [<memberdata name="onclear" type="method" display="OnClear" />] + ;
        [<memberdata name="hookonclear" type="method" display="HookOnClear" />] + ;
        [<memberdata name="onparentclear" type="method" display="OnParentClear" />] + ;
        [<memberdata name="ocolgridselectorlayout" type="property" display="oColGridSelectorLayout" />] + ;
        [<memberdata name="getlabel" type="method" display="GetLabel" />] + ;
        [<memberdata name="ocolimages" type="property" display="oColImages" />] + ;
        [<memberdata name="ocolimages_access" type="method" display="oColImages_Access" />] + ;
        [<memberdata name="ocolnavigator" type="property" display="oColNavigator" />] + ;
        [<memberdata name="ocolnavigator_access" type="method" display="oColNavigator_Access" />] + ;
        [<memberdata name="cnavigatorfiltercriteria" type="property" display="cNavigatorFilterCriteria" />] + ;
        [<memberdata name="cnavigatorfiltercriteria_access" type="method" display="cNavigatorFilterCriteria_Access" />] + ;
        [<memberdata name="sqlexecute" type="method" display="SQLExecute" />] + ;
        [<memberdata name="classbeforesqlexecute" type="method" display="ClassBeforeSQLExecute" />] + ;
        [<memberdata name="hookbeforesqlexecute" type="method" display="HookBeforeSQLExecute" />] + ;
        [<memberdata name="hookaftersqlexecute" type="method" display="HookAfterSQLExecute" />] + ;
        [<memberdata name="classaftersqlexecute" type="method" display="ClassAfterSQLExecute" />] + ;
        [<memberdata name="cselectorformname" type="property" display="cSelectorFormName" />] + ;
        [<memberdata name="creportname" type="property" display="cReportName" />] + ;
        [</VFPData>]

    * <TODO>: Encapsular en un objeto todas las propiedades asociadas al reporte
    cReportFormCaption = ""
    cReportFormName = ""
    cReportFormFolder = ""

    *!* Coleccion de filtros para usarse en el reporte
    oColReportFilters = Null

    *!* Coleccion de campos para usarse en el reporte
    oColReportFields = Null

    *!* Coleccion de campos que conforman la clausula ORDER BY
    oColReportOrderBy = Null

    *!* Nombre de la consulta que se ejecutará en el generador de reportes
    cReportQueryName = ""

    *!* Nombre del reporte que se va a lanzar
    cReportName = "Generic Report"

    *!* Carpeta del reporte
    cReportClassLibraryFolder = ""

    *!* Librería del reporte
    cReportClassLibrary = ""

    *!* Clase del reporte
    cReportClass = ""

    *!* Referencia al objeto Report
    oReport = Null

    * End <TODO>:


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: GenericQuery
    *!* Description...: Rutina genérica de consulta
    *!* Date..........: Viernes 24 de Agosto de 2007 (16:29:50)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure GenericQuery( tcFilterCriteria As String,;
            tcOrderBy As String ) As String;
            HELPSTRING "Rutina genérica de consulta"

        Return This.GetAll( tcFilterCriteria, "", tcOrderBy )

    Endproc
    *!*
    *!* END PROCEDURE GenericQuery
    *!*
    *!* ///////////////////////////////////////////////////////

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: GenericQuery_GetFilters
    *!* Description...: Devuelve una colección de objetos FILTRO
    *!* Date..........: Viernes 24 de Agosto de 2007 (16:31:20)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure GenericQuery_GetFilters(  ) As Object;
            HELPSTRING "Devuelve una colección de objetos FILTRO "



    Endproc
    *!*
    *!* END PROCEDURE GenericQuery_GetFilters
    *!*
    *!* ///////////////////////////////////////////////////////

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: GenericQuery_GetOrderByFields
    *!* Description...: Devuelve una colección de objetos ORDERBY
    *!* Date..........: Viernes 24 de Agosto de 2007 (16:32:39)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure GenericQuery_GetOrderByFields(  ) As Object;
            HELPSTRING "Devuelve una colección de objetos ORDERBY"



    Endproc
    *!*
    *!* END PROCEDURE GenericQuery_GetOrderByFields
    *!*
    *!* ///////////////////////////////////////////////////////

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: ReportSetUp
    *!* Description...: Devuelve una colección de objetos FIELDS
    *!* Date..........: Viernes 24 de Agosto de 2007 (16:32:39)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure ReportSetUp( tnId As Integer ) As Object;
            HELPSTRING "Devuelve una colección de objetos FIELDS"



    Endproc
    *!*
    *!* END PROCEDURE ReportSetUp
    *!*
    *!* ///////////////////////////////////////////////////////


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
        Local lcEntityCursor As String
        Local lcMainCursorPK As String
        Local lcCommand As String
        Local lnEntidadId As Number
        Local lnNivelJerarquiaTablas As Integer
        Local lcAlias As String

        Try

            lcAlias = Alias()

            lcXML = ""
            With This As UserTierAdapter Of fw\tieradapter\usertier\UserTierAdapter.prg

                lnNivelJerarquiaTablas = IfEmpty( tnLevel, .nNivelJerarquiaTablas )

                If .lIsOk And .ClassBeforeNew( lnNivelJerarquiaTablas, tcAlias )

                    If .lIsOk And .HookBeforeNew( lnNivelJerarquiaTablas, tcAlias )
                        * DAE 2009-07-14
                        lcEntityCursor = .cEntityCursor
                        lcMainCursorPK = .cMainCursorPK

                        If .lIsChild
                            * @TODO Damian Eiff 2009-07-28 (15:59:57)
                            * Encapsular en un procedimiento
                            Assert Used( lcEntityCursor ) Message 'No existe el cursor ' + lcEntityCursor
                            Append Blank In ( lcEntityCursor )
                            lnEntidadId = Recno( lcEntityCursor )
                            * DA 2009-07-23(09:35:39)
                            * No se iban generando bien los nuevos registros
                            TEXT To lcCommand NoShow TextMerge Pretext 15
                               Replace <<lcMainCursorPK>> with <<lnEntidadId>> In ( lcEntityCursor )

                            ENDTEXT
                            &lcCommand
                            *!* .SetValue( .cMainCursorPK, lnEntidadId )
                            .oServiceTier.nEntidadId = lnEntidadId

                            Select Alias( lcEntityCursor )
                            TEXT To lcCommand NoShow TextMerge Pretext 15
								Locate For <<lcMainCursorPK>> = <<lnEntidadId>>

                            ENDTEXT

                            &lcCommand

                        Else
                            lcXML = .oNextTier.New( lnNivelJerarquiaTablas, tcAlias )

                            If ! .lIsOk Or Empty( lcXML )
                                If Empty( lcXML )
                                    lcXML = This.cXMLoError

                                Endif &&  Empty( lcXML )

                            Endif && ! .lIsOk Or Empty( lcXML )

                            If .ValidateXML( lcXML )
                                Assert Used( lcEntityCursor ) Message 'No existe el cursor ' + lcEntityCursor
                                Append Blank In ( lcEntityCursor )
                                lnEntidadId = Recno( lcEntityCursor )
                                TEXT To lcCommand NoShow TextMerge Pretext 15
                               		Replace <<lcMainCursorPK>> with <<lnEntidadId>> In ( lcEntityCursor )

                                ENDTEXT
                                &lcCommand
                                *!* .SetValue( .cMainCursorPK, lnEntidadId )
                                .oServiceTier.nEntidadId = lnEntidadId

                                Select Alias( lcEntityCursor )
                                TEXT To lcCommand NoShow TextMerge Pretext 15
									Locate For <<lcMainCursorPK>> = <<lnEntidadId>>

                                ENDTEXT

                                &lcCommand

                            Endif && .ValidateXML( lcXML )

                        Endif && ! .lIsChild

                        .SetDefaults()

                        If .lIsOk
                            .HookAfterNew( lnNivelJerarquiaTablas, tcAlias )

                        Endif && .lIsOk

                        If .lIsOk
                            .ClassAfterNew( lnNivelJerarquiaTablas, tcAlias )

                        Endif && .lIsOk

                    Endif && .lIsOk And .HookBeforeNew( lnNivelJerarquiaTablas, tcAlias )

                Endif && .lIsOk And .ClassBeforeNew( lnNivelJerarquiaTablas, tcAlias )

            Endwith

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError = This.oError.Process( oErr )

            Endif && This.lIsOk

        Finally

            If Used( lcAlias )
                Select Alias( lcAlias )

            Endif && Used( lcAlias )

        Endtry

        Return lcXML

    Endproc && New

    *
    Procedure SetDefaults() As Void


        Local lcEntityCursor As String
        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
        Local loParentEntity As UserTierAdapter Of "FW\TierAdapter\UserTier\UserTierAdapter.prg"
        Local loMainEntity As UserTierAdapter Of "FW\TierAdapter\UserTier\UserTierAdapter.prg"
        Local lcMainCursorPK As String

        Local lnParentPK As Integer
        Local lnMainPK As Integer
        Local lcParentEntityCursor As String
        Local loDD As Object
        Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"
        Local lnEmpresaId As Integer
        Local lnEmpresaSucursalId As Integer

        Try
            loError = This.oError
            loError.Remark = ''
            loError.TraceLogin = ''

            With This As UserTierAdapter Of "fw\tieradapter\comun\tieradapter.prg"
                lcEntityCursor = .cEntityCursor

                * DAE 2009-07-17(19:12:24)
                * Inicio la FK del padre en las entidades Child
                If .lIsChild

                    * Parent
                    loParentEntity = .oParent
                    lcParentEntityCursor = loParentEntity.cEntityCursor
                    lcParentCursorPK = loParentEntity.cMainCursorPK
                    lnParentPK = Evaluate( lcParentEntityCursor + '.' + lcParentCursorPK )

                    * Main
                    loMainEntity = This.GetMain()
                    lcMainEntityCursor = loMainEntity.cEntityCursor
                    lcMainCursorPK = loMainEntity.cMainCursorPK
                    lnMainPK = Evaluate( lcMainEntityCursor + '.' + lcMainCursorPK )

                    If Lower( lcMainEntityCursor ) # Lower( lcParentEntityCursor )
                        TEXT To lcCommand NoShow TextMerge Pretext 15
							Replace <<lcParentCursorPK>> With <<lnParentPK>>,
									<<lcMainCursorPK>> With <<lnMainPK>>
							In <<lcEntityCursor>>

                        ENDTEXT

                    Else
                        TEXT To lcCommand NoShow TextMerge Pretext 15
							Replace <<lcParentCursorPK>> With <<lnParentPK>>
							In <<lcEntityCursor>>

                        ENDTEXT

                    Endif && lcMainEntityCursor # lcParentEntityCursor
                    &lcCommand

                Endif && .lIsChild

                * DAE 2009-09-08(18:47:19)
                If ! ( 'empresa' $ Lower( This.cDataConfigurationKey ) )
                    lcCommand = ''
                    loDD = NewDataDictionary()
                    loField = loDD.GetItem( .cMainTableName + '.EmpresaId' )
                    If Vartype( loField ) = 'O'
                        lnEmpresaId = This.oGlobalSettings.nEmpresaActiva
                        TEXT To lcCommand NoShow TextMerge Pretext 15 ADDITIVE
						EmpresaId With <<lnEmpresaId>>,
                        ENDTEXT
                    Endif && Vartype( loField ) = 'O'

                    loField = loDD.GetItem( .cMainTableName + '.EmpresaSucursalId' )
                    If Vartype( loField ) = 'O'
                        lnEmpresaSucursalId = This.oGlobalSettings.nEmpresaSucursalActiva
                        TEXT To lcCommand NoShow TextMerge Pretext 15 ADDITIVE
						EmpresaSucursalId With <<lnEmpresaSucursalId>>,
                        ENDTEXT
                    Endif && Vartype( loField ) = 'O'

                    If ! Empty( lcCommand )
                        lcCommand = 'Replace ' ;
                            + Left( lcCommand, Len( lcCommand ) - 1 ) ;
                            + ' In ' + lcEntityCursor
                        &lcCommand

                    Endif && ! Empty( lcCommand )

                Endif && ! ( 'empresa' $ Lower( this.cDataConfigurationKey ) )

                .oServiceTier.SetDefaults()

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

            loParentEntity = Null
            loMainEntity = Null

            loDD = Null
            loField = Null

        Endtry

    Endproc && SetDefaults


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: InternalNew
    *!* Description...: Agrega un registro a la tabla vacía
    *!* Date..........: Martes 10 de Octubre de 2006 (20:49:20)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure InternalNew( toTable As Object,;
            loParam As Object ) As Boolean;
            HELPSTRING "Agrega un registro a la tabla vacía"

        Local lcAlias As String
        Local loError As Object
        Local lcCursorName As String
        Local lnEntidadId As Integer

        Try

            lcAlias = Alias()

            loError = This.oError
            loError.TraceLogin = ""
            loError.Remark = ""

            lcCursorName = ''


            If toTable.Nivel - toParam.nOffSet <= loParam.nLevel And !toTable.Auxiliary
                lcCursorName = toTable.CursorName
                If toTable.Nivel - toParam.nOffSet = 1 And ! Empty( loParam.cAlias )
                    lcCursorName = loParam.cAlias

                Endif && toTable.Nivel = 1 And ! Empty( loParam.cAlias )

                Select ( lcCursorName )
                Append Blank In ( lcCursorName )
                lnEntidadId = Recno( lcCursorName )
                TEXT To lcCommand NoShow TextMerge Pretext 15
					Replace <<toTable.PKName>> With lnEntidadId
					In <<lcCursorName>>

                ENDTEXT

                &lcCommand

                If loParam.nLevel = 1
                    This.nEntidadId = lnEntidadId

                Endif && loParam.nLevel = 1

            Endif

            This.HookAfterNew( toTable, loParam.nLevel, lcCursorName )

        Catch To oErr
            This.lIsOk = .F.
            This.cXMLoError = This.oError.Process( oErr )

        Finally
            loError = This.oError
            loError.TraceLogin = ""
            loError.Remark = ""
            loError = Null

            If Used( lcAlias )
                Select Alias( lcAlias )

            Endif && Used( lcAlias )

        Endtry

        Return This.lIsOk

    Endproc && InternalNew

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: GetOne
    *!* Description...: Devuelve un registro de acuerdo al ID pasado
    *!* Date..........: Lunes 9 de Enero de 2006 (17:52:20)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Tier Adapter
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure GetOne( tnEntidad As Variant, nLevel As Number, cAlias As String,;
            cXMLFilter As String, ;
            tnSQLOption As Integer ) As String;
            HELPSTRING "Devuelve un registro de acuerdo al ID pasado"

        Local lcXML As String
        Local lnNivelJerarquiaTablas As Integer

        Local loError As Object
        Try
            loError = This.oError
            loError.TraceLogin = ""
            loError.Remark = ""
            This.lIsOk = .T.

            *This.nNivelJerarquiaTablas = Iif( Empty( nLevel ), 1, nLevel )

            * lnNivelJerarquiaTablas = This.nNivelJerarquiaTablas
            * DA 2009-07-27(09:58:13)
            lnNivelJerarquiaTablas = Iif( Empty( nLevel ), This.nNivelJerarquiaTablas, nLevel )

            This.HookBeforeGetOne( tnEntidad, lnNivelJerarquiaTablas, tnSQLOption )

            *!* lcXML = This.oNextTier.GetOne( tnEntidad, This.nNivelJerarquiaTablas, cAlias, cXMLFilter )

            lcXML = This.oNextTier.GetOne( tnEntidad, lnNivelJerarquiaTablas, cAlias, tnSQLOption )

            *			DoDefault()

            This.ValidateXML( lcXML )

            If This.lIsOk
                This.nEntidadId = tnEntidad
                This.HookAfterGetOne( tnEntidad, lnNivelJerarquiaTablas, tnSQLOption )
            Endif

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )
            Endif

        Finally
            loError = Null

        Endtry

        Return lcXML

    Endproc && GetOne

    Procedure GetChildren( nMainId As Integer,;
            cChildrenList As String,;
            nLevel As Integer,;
            nFillLevel As Integer,;
            cFieldName As String   ) As String;
            HELPSTRING "Trae la entidad principal, y algunos hijos, hasta el nivel indicado"

        Local lcXML As String

        Try

            lcXML = This.oNextTier.GetChildren( nMainId,;
                cChildrenList,;
                nLevel,;
                nFillLevel,;
                cFieldName )

            DoDefault()

            This.ValidateXML( lcXML )

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )
            Endif

        Finally

        Endtry

        Return lcXML
    Endproc


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: AfterGetOne
    *!* Description...: Template Method
    *!* Date..........: Viernes 15 de Junio de 2007 (18:27:50)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure HookAfterGetOne( tnEntidad As Integer, ;
            nNivelJerarquiaTablas  As Integer, ;
            tnSQLOption As Integer ) As Void;
            HELPSTRING "Template Method"

        *!* Codigo que se ejecuta si GetOne() es exitoso

    Endproc && AfterGetOne

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

        Local lnId As Integer

        Try

            If Empty( tnLevel )
                tnLevel = This.nNivelJerarquiaTablas
            Endif

            lnId = This.oNextTier.GetFirst( tcFieldName,;
                tcFilterCriteria,;
                tnLevel )
            DoDefault()

            If Vartype( lnId  ) # "N"
                This.ValidateXML( lnId  )
                lnId = 0
            Endif

            *!* If This.lIsOk
            *!*		This.nEntidadId = Evaluate( This.cEntityCursor + "." + This.cMainCursorPK )
            *!*	EndIf


        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )
            Endif

        Finally

        Endtry

        Return lnId

    Endproc && GetFirst

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

        Local lnId As Integer
        Try


            If Empty( tnLevel )
                tnLevel = This.nNivelJerarquiaTablas
            Endif

            lnId = This.oNextTier.GetLast( tcFieldName,;
                tcFilterCriteria,;
                tnLevel )
            DoDefault()

            If Vartype( lnId  ) # "N"
                This.ValidateXML( lnId  )
                lnId = 0
            Endif

            *!*				If This.lIsOk
            *!*					This.nEntidadId = Evaluate( This.cEntityCursor + "." + This.cMainCursorPK )
            *!*				EndIf


        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )
            Endif

        Finally

        Endtry

        Return lnId

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

        Local lnId As Integer

        Try

            If Empty( tnLevel )
                tnLevel = This.nNivelJerarquiaTablas
            Endif

            lnId  = This.oNextTier.Getnext( tcFieldName,;
                tuCurrentValue,;
                tcFilterCriteria,;
                tnLevel )
            DoDefault()

            If Vartype( lnId  ) # "N"
                This.ValidateXML( lnId  )
                lnId = 0
            Endif


            *!*				If This.lIsOk
            *!*					This.nEntidadId = Evaluate( This.cEntityCursor + "." + This.cMainCursorPK )
            *!*				EndIf

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )
            Endif

        Finally

        Endtry

        Return lnId

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

        Local lnId  As Integer

        Try

            If Empty( tnLevel )
                tnLevel = This.nNivelJerarquiaTablas
            Endif

            lnId = This.oNextTier.GetPrior( tcFieldName,;
                tuCurrentValue,;
                tcFilterCriteria,;
                tnLevel )
            DoDefault()

            If Vartype( lnId  ) # "N"
                This.ValidateXML( lnId  )
                lnId = 0
            Endif

            *!*				If This.lIsOk
            *!*					This.nEntidadId = Evaluate( This.cEntityCursor + "." + This.cMainCursorPK )
            *!*				EndIf


        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )
            Endif

        Finally

        Endtry

        Return lnId

    Endproc
    *!*
    *!* END PROCEDURE GetPrior
    *!*
    *!* ///////////////////////////////////////////////////////

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: GetAll
    *!* Description...: Trae un conjunto de registros en función de un criterio de filtro
    *!* Date..........: Lunes 9 de Enero de 2006 (17:54:48)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Tier Adapter
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure GetAll( tcFilterCriteria As String,;
            tcCursorAlias As String,;
            tcOrderBy As String, ;
            tnSQLOption As Integer ) As String;
            HELPSTRING "Trae un conjunto de registros en función de un criterio de filtro"

        Local lcXML As String
        Local lcFilterCriteria As String
        Local lcCursorAlias As String
        Local loError As Object

        Try
            loError = This.oError
            loError.TraceLogin = ""
            loError.Remark = ""
            This.lIsOk = .T.

            lcFilterCriteria = IfEmpty( tcFilterCriteria, "" )
            lcOrderBy = IfEmpty( tcOrderBy, "" )

            If This.lIsOk And This.ClassBeforeGetAll( lcFilterCriteria, tcCursorAlias, lcOrderBy, tnSQLOption )

                If This.lIsOk And This.HookBeforeGetAll( lcFilterCriteria, tcCursorAlias, lcOrderBy, tnSQLOption )

                    lcXML = This.oNextTier.GetAll( lcFilterCriteria, tcCursorAlias, lcOrderBy, tnSQLOption )
                    This.ValidateXML( lcXML )

                    This.HookAfterGetAll( lcFilterCriteria, tcCursorAlias, lcOrderBy, tnSQLOption )

                    This.ClassAfterGetAll( lcFilterCriteria, tcCursorAlias, lcOrderBy, tnSQLOption )

                Endif && This.lIsOk And This.HookBeforeGetAll( lcFilterCriteria, tcCursorAlias, lcOrderBy, tnSQLOption )

            Endif && This.lIsOk And This.ClassBeforeGetAll( lcFilterCriteria, tcCursorAlias, lcOrderBy, tnSQLOption )

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )

            Endif

        Finally
            loError = Null

        Endtry

        Return lcXML

    Endproc && GetAll

    *
    * Trae un conjunto de registros en función de un criterio de filtro
    Procedure GetAllCombo( tcFilterCriteria As String,;
            tcCursorAlias As String,;
            tcOrderBy As String ) As String;
            HELPSTRING "Trae un conjunto de registros en función de un criterio de filtro"

        #If .F.
            TEXT
                *:Help Documentation
                *:Topic:
                *:Description:
                Trae un conjunto de registros en función de un criterio de filtro
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

        Local lcXML As String
        Local lcFilterCriteria As String
        Local lcCursorAlias As String

        Try
            loError = This.oError
            loError.TraceLogin = ""
            loError.Remark = ""
            This.lIsOk = .T.

            lcFilterCriteria = IfEmpty( tcFilterCriteria, "" )
            lcOrderBy = IfEmpty( tcOrderBy, "" )

            If This.lIsOk And This.ClassBeforeGetAllCombo( lcFilterCriteria, tcCursorAlias, lcOrderBy )

                If This.lIsOk And This.HookBeforeGetAllCombo( lcFilterCriteria, tcCursorAlias, lcOrderBy )

                    lcXML = This.oNextTier.GetAllCombo( lcFilterCriteria, tcCursorAlias, lcOrderBy )
                    This.ValidateXML( lcXML )

                    This.HookAfterGetAllCombo( lcFilterCriteria, tcCursorAlias, lcOrderBy )

                    This.ClassAfterGetAllCombo( lcFilterCriteria, tcCursorAlias, lcOrderBy )

                Endif && This.lIsOk And This.HookBeforeGetAllCombo( lcFilterCriteria, tcCursorAlias, lcOrderBy )

            Endif && This.lIsOk And This.ClassBeforeGetAllCombo( lcFilterCriteria, tcCursorAlias, lcOrderBy )

        Catch To oErr
            This.lIsOk = .F.
            This.cXMLoError = This.oError.Process( oErr )

        Finally

        Endtry

        Return lcXML

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
            tcAlias As String, ;
            tnSQLOption As Integer ) As String

        Local lcXML As String

        Try

            lcXML = ""

            If This.lIsOk And This.ClassBeforeGetByWhere( tcFilterCriteria,;
                    tnLevel,;
                    tcAlias, ;
                    tnSQLOption )

                If This.lIsOk And This.HookBeforeGetByWhere( tcFilterCriteria,;
                        tnLevel,;
                        tcAlias, ;
                        tnSQLOption )

                    This.oError.TraceLogin = ""
                    This.oError.Remark = ""
                    This.lIsOk = .T.

                    If Empty( tnLevel )
                        tnLevel = 1
                    Endif

                    If Empty( tcAlias )
                        tcAlias = ""
                    Endif

                    lcXML = This.oNextTier.GetByWhere( tcFilterCriteria, ;
                        tnLevel,;
                        tcAlias, ;
                        tnSQLOption )

                    This.RetrieveNextTierData()

                    * Si el XML contiene un error, lo muestra
                    * Si el XML contiene la entidad buscada, crea los cursores
                    * Si el XML contiene un USER_TAG, no hace nada
                    This.ValidateXML( lcXML )

                    If This.nResultStatus = RESULT_OK
                        If Used( This.cMainCursorName )
                            This.nEntidadId = Evaluate( This.cMainCursorName + "." + This.cMainCursorPK )
                        Endif
                    Endif

                    If This.lIsOk
                        This.HookAfterGetByWhere( tcFilterCriteria,;
                            tnLevel,;
                            tcAlias, ;
                            tnSQLOption )
                    Endif

                Endif

                If This.lIsOk
                    This.ClassAfterGetByWhere( tcFilterCriteria,;
                        tnLevel,;
                        tcAlias, ;
                        tnSQLOption )
                Endif

            Endif

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError = This.oError.Process( oErr )
            Endif

        Finally

        Endtry

        Return lcXML

    Endproc

    *!*
    *!* END PROCEDURE GetByWhere
    *!*
    *!* ///////////////////////////////////////////////////////

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: GetAllPaginated
    *!* Description...: Trae una página del conjunto de datos
    *!* Date..........: Lunes 9 de Enero de 2006 (18:01:26)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Tier Adapter
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure GetAllPaginated( nPageNro As Number,;
            cFilterCriteria As String,;
            tcXMLParams As String, ;
            tnSQLOption As Integer ) As String;
            HELPSTRING "Trae una página del conjunto de datos"

        Local lcXML As String

        Try

            This.oError.TraceLogin = ""
            This.oError.Remark = ""

            lcXML = This.oNextTier.GetAllPaginated( cFilterCriteria, nPageNro, This.nRowsPerPage, tcXMLParams, tnSQLOption )
            DoDefault()

            This.ValidateXML( lcXML )

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )
            Endif

        Finally

        Endtry

        Return This.lIsOk

    Endproc && GetAllPaginated

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: GetAllPaginatedCount
    *!* Description...: Devuelve un cursor con la cantidad de páginas que tiene la consulta
    *!* Date..........: Lunes 9 de Enero de 2006 (18:03:58)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Tier Adapter
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure GetAllPaginatedCount( tcFilterCriteria As String, tnSQLOption As Integer ) As String;
            HELPSTRING "Devuelve un cursor con la cantidad de páginas que tiene la consulta"

        Local lcXML As String

        Try

            This.oError.TraceLogin = ""
            This.oError.Remark = ""
            This.lIsOk = .T.
            lnReturnValue = -1

            lcXML = This.oNextTier.GetAllPaginatedCount( tcFilterCriteria, tnSQLOption )
            DoDefault()

            If This.lIsOk
                loParam = XmlToObject( lcXML )
                lnReturnValue = loParam.nRowsQuantity

            Endif

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )
            Endif

        Finally

        Endtry

        Return lnReturnValue

    Endproc && GetAllPaginatedCount

    *
    * ClassBefore Event
    * Graba las novedades en la Base de Datos
    Protected Procedure ClassBeforePut( tnIDEntidad As Integer,;
            tnProcessType As Integer,;
            tcUniqueName As String ) As Boolean

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
			Miércoles 13 de Mayo de 2009 (11:12:59)
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
			tnIDEntidad AS Integer
			tcDiffGram AS String
			tnLevel AS Integer
			tcUniqueName AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

        Local llExecutePut As Boolean

        Try

            llExecutePut = .T.
            * DAE 2009-08-24
            This.SetRelation( .F. )

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError = This.oError.Process( oErr )

            Endif

        Finally
            If !This.lIsOk
                Throw This.oError

            Endif

        Endtry

        Return llExecutePut

    Endproc

    *
    * HookBefore Event
    * Para ser utilizado por el desarrollador
    * Graba las novedades en la Base de Datos
    Procedure HookBeforePut( tnIDEntidad As Integer,;
            tnProcessType As Integer,;
            tcUniqueName As String ) As Boolean

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
			Miércoles 13 de Mayo de 2009 (11:12:59)
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
			tnIDEntidad AS Integer
			tnProcessType As Integer
			tcUniqueName AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

        Local llExecutePut As Boolean

        Try

            llExecutePut = .T.

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

        Return llExecutePut

    Endproc


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: Put
    *!* Description...: Graba las modificaciones en la tabla de origen
    *!* Date..........: Lunes 9 de Enero de 2006 (18:07:35)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Tier Adapter
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure Put( tnIDEntidad As Integer,;
            tnProcessType As Integer,;
            tcUniqueFormName As String ) As String;
            HELPSTRING "Graba las modificaciones en la tabla de origen"


        Local loParam As Object
        Local lcDiffGram As String
        Local lcRetVal As String
        Local loXA As prxXMLAdapter Of "Comun\Prg\prxXMLAdapter.prg"
        Local lcXML As String
        Local lcIdentifier As String
        Local lnNivelJerarquiaTablas As Integer
        Local lnOffSet As Integer

        Try
            With This As UserTierAdapter Of fw\tieradapter\usertier\UserTierAdapter.prg
                .oError.TraceLogin = ""
                .oError.Remark = ""
                .lIsOk = .T.
                .nProcessType = tnProcessType

                lnOffSet = 0

                lcXML = ""
                lnNivelJerarquiaTablas = This.nNivelJerarquiaTablas

                If .lIsOk And .ClassBeforePut( tnIDEntidad, tnProcessType, tcUniqueFormName )

                    If .lIsOk And .HookBeforePut( tnIDEntidad, tnProcessType, tcUniqueFormName )

                        lcDiffGram = ""

                        * Validación del lado del cliente
                        If .lIsOk And tnProcessType # TR_DELETE
                            lcRetVal = .oServiceTier.DoValidate()

                        Endif && .lIsOk And tnProcessType # TR_DELETE

                        If .lIsChild

                            If Empty( lcRetVal )
                                .nResultStatus = RESULT_OK

                                If .lIsOk
                                    .nEntidadId = .GetValue( .cMainCursorPK )

                                Endif && .lIsOk
                            Else
                                .nResultStatus = RESULT_WARNINGS

                            Endif && Empty( lcRetVal )

                        Else  && .lIsChild

                            If .lIsOk And Empty( lcRetVal )

                                If .lSerialize
                                    .oError.TraceLogin = "Creando Diffgram"
                                    .oError.Remark = ""

                                    loXA = Newobject( "prxXMLAdapter","prxXMLAdapter.prg" )

                                    loParam = Createobject( "Empty" )
                                    AddProperty( loParam, "oXA", loXA )
                                    AddProperty( loParam, "nLevel", lnNivelJerarquiaTablas )

                                    If This.oColTables.Count > 0
                                        loTable = This.oColTables.Item( 1 )
                                        lnOffSet = loTable.Nivel - 1

                                    Endif && This.oColTables.Count > 0

                                    AddProperty(loParam, "nOffSet", lnOffSet )

                                    If .LookOverColTables( .oColTables, "AddTable", loParam)
                                        lcDiffGram = loXA.GetDiffGram()
                                        * Código de DEBUG
                                        If .F.
                                            Strtofile( lcDiffGram, "Diffgram Valid" + .Name + ".Xml" )

                                        Endif && .F.

                                    Endif && .LookOverColTables( .oColTables, "AddTable", loParam)

                                Endif && .lSerialize

                                If .lIsOk

                                    * Asegurarse que se ejecute NextTierSetup()
                                    .oNextTier = Null

                                    lcRetVal = .oNextTier.Put( tnIDEntidad,;
                                        lcDiffGram,;
                                        lnNivelJerarquiaTablas,;
                                        tnProcessType,;
                                        tcUniqueFormName )

                                Endif && .lIsOk

                            Else && .lIsOk And Empty( lcRetVal )
                                lcIdentifier = ParseXML( lcRetVal, 1 )

                                If Empty( lcIdentifier )
                                    lcRetVal = WARNING_TAG + lcRetVal

                                Endif && Empty( lcIdentifier )

                            Endif && .lIsOk And Empty( lcRetVal )

                            .lIsOk = .ValidateXML( lcRetVal )

                            If .lIsOk
                                * DAE 2009-10-13(17:10:02)
                                * .nEntidadId = .GetValue( .cMainCursorPK )

                                Select Alias( .cEntityCursor )
                                Locate
                                .nEntidadId = Evaluate( .cEntityCursor + '.' + .cMainCursorPK )


                            Endif && .lIsOk

                        Endif && .lIsChild

                        If .lIsOk
                            .HookAfterPut( tnIDEntidad, lnNivelJerarquiaTablas, tnProcessType, tcUniqueFormName )

                        Endif && .lIsOk


                        If .lIsOk
                            .ClassAfterPut( tnIDEntidad, lnNivelJerarquiaTablas, tnProcessType, tcUniqueFormName )

                        Endif && .lIsOk

                        If .lShowMessages And ! .lIsChild
                            Do Case
                                Case .nResultStatus == RESULT_WARNINGS

                                Case .nResultStatus == RESULT_BIZ_ERROR

                                Case .nResultStatus == RESULT_OK
                                    .Inform( S_TRANSACTION_OK, "", 1 )
                                    lcRetVal = ""

                                Case .nResultStatus == RESULT_ERROR
                                    .Warning( S_TRANSACTION_NOT_OK )

                                Otherwise

                            Endcase

                        Endif && .lShowMessages

                    Endif && .HookBeforePut()

                Endif && .ClassBeforePut()

            Endwith

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError = This.oError.Process( oErr )

            Endif && This.lIsOk
            lcRetVal = This.cXMLoError

        Finally
            loXA = .F.
            Release loXA

        Endtry

        Return lcRetVal

    Endproc && Put

    *
    * HookAfter Event
    * Para ser utilizado por el desarrollador
    * Graba las novedades en la Base de Datos
    Procedure HookAfterPut( tnIDEntidad As Integer,;
            tnLevel As Integer,;
            tnProcessType As Integer,;
            tcUniqueName As String ) As Void

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
			Miércoles 13 de Mayo de 2009 (11:12:59)
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
			tnIDEntidad AS Integer
			tcDiffGram AS String
			tnLevel AS Integer
			tcUniqueName AS String
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
    * ClassAfter Event
    * Graba las novedades en la Base de Datos
    Protected Procedure ClassAfterPut( tnIDEntidad As Integer,;
            tnLevel As Integer,;
            tnProcessType As Integer,;
            tcUniqueName As String ) As Void

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
			Miércoles 13 de Mayo de 2009 (11:12:59)
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
			tnIDEntidad AS Integer
			tcDiffGram AS String
			tnLevel AS Integer
			tcUniqueName AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

        Try

            If ! This.lIsChild
                This.RetrieveNextTierData()

            Else
                This.UpdateDefault()

            Endif && ! this.lIsChild

            * DAE 2009-08-24
            This.SetRelation( .T. )

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError = This.oError.Process( oErr )
            Endif

        Finally
            If ! This.lIsOk
                Throw This.oError
            Endif

        Endtry

    Endproc


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: Destroy
    *!* Description...:
    *!* Date..........: Lunes 9 de Enero de 2006 (17:10:40)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Tier Adapter
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure Destroy(  ) As Void

        DoDefault()
        If Vartype( _Screen.oColTablesCache ) == "O"
            _Screen.RemoveObject( "oColTablesCache" )
        Endif

    Endproc && Destroy

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: ExecuteNonQuery
    *!* Description...: Ejecuta un comando SQL que no devuelve un resultado
    *!* Date..........: Jueves 19 de Enero de 2006 (11:22:52)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Tier Adapter
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure ExecuteNonQuery( cSQLCommand As String ) As Boolean;
            HELPSTRING "Ejecuta una consulta SQL"

        Local lcXML As String

        Try

            This.oError.TraceLogin = ""
            This.oError.Remark = ""

            * DA 2009-09-09(12:49:02)
            lcXML = DoDefault( cSQLCommand ) && This.oNextTier.ExecuteNonQuery( cSQLCommand )
            *DoDefault()

            If !Empty(lcXML)
                This.ValidateXML( lcXML )
            Endif

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )
            Endif

        Finally

        Endtry

        Return lcXML

    Endproc && ExecuteNonQuery

    *
    * RetrieveComConfig
    Function RetrieveComConfig(  ) As Boolean;
            HELPSTRING "Lee la configuración de componentes desde un archivo XML"

        * No se utiliza en esta capa
        Return This.lIsOk

    Endfunc

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: ShowWarnings
    *!* Description...: Muestra las advertencias devueltas por la capa de validacion
    *!* Date..........: Lunes 16 de Octubre de 2006 (15:38:04)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure ShowWarnings( tcXML As String ) As Boolean;
            HELPSTRING "Muestra las advertencias devueltas por la capa de validacion"

        Try

            This.oError.TraceLogin = ""
            This.oError.Remark = ""

            Local lcSTR As String,;
                lcAlias As String


            lcSTR=""
            lcAlias=""

            This.GetData( ParseXML( tcXML) )
            lcAlias = Alias()
            Scan
                lcSTR = lcSTR + Alltrim( ErrorDescription ) + CR
            Endscan

            If !Empty( lcSTR )
                * Warning( lcSTR )
                This.Warning( lcSTR )
            Endif

        Catch To oErr
            This.lIsOk = .F.
            This.cXMLoError = This.oError.Process( oErr )

        Finally
            If Used( lcAlias )
                Use In Alias( lcAlias )
            Endif

        Endtry

        Return This.lIsOk

    Endproc && ShowWarnings

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: GetFormId
    *!* Description...: Obtiene el Id del Formulario
    *!* Date..........: Miércoles 7 de Junio de 2006 (15:58:31)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: SYS Admin
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure GetFormId( tcFormName As String ) As Integer;
            HELPSTRING "Obtiene el Id del Formulario"
        Local lnFormId As Integer

        lnFormId = This.oNextTier.GetFormId( tcFormName )
        This.RetrieveNextTierData()

        If !This.lIsOk
            This.oError.Process( This.cXMLoError )
        Endif

        Return lnFormId

    Endproc && GetFormId

    *
    * oColGridLayout_Access
    Procedure oColGridLayout_Access

        If Vartype( This.oColGridLayout ) # "O" And !This.lOnDestroy

            This.oColGridLayout = This.oServiceTier.oColGridLayout

        Endif

        Return This.oColGridLayout

    Endproc && oColGridLayout_Access


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: DoReport
    *!* Description...: Ejecuta el formulario de reportes
    *!* Date..........: Jueves 23 de Agosto de 2007 (19:47:24)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure DoReport( tnFormStatus As Integer ) As Boolean;
            HELPSTRING "Ejecuta el formulario de reportes"

        Local llOk As Boolean
        Local loParam As Object
        Local lcCommand As String
        Local lcAlias As String
        Local lcTitulo As String
        Local lcOldAlias As String
        Local lcOrderBy As String
        Try

            lcOldAlias = Alias()
            llOk = .T.
            lcAlias = "cGenericReport"
            If This.lHasDescripcion

                lcTitulo = "Listado de " + Alltrim( This.cMainTableName )
                Create Cursor cTitulo (Titulo Character(40))
                Insert Into cTitulo (Titulo) Values ( lcTitulo )
				
				lcOrderBy = This.cMainTableName + ".Descripcion"
                This.GetAll( "1 = 1", lcAlias, lcOrderBy )

                If This.lIsOk And !Empty( Reccount( lcAlias ) )

                    Select Alias( lcAlias )
                    Locate

                    Report Form ( Addbs(ERP_FRX) + This.cReportName ) To Printer Prompt Nodialog Preview
                Else

                    This.Stop( "No se encontraron registros." )

                Endif && This.lIsOk And !Empty( Reccount( lcAlias ) )

            Endif && This.lHasDescripcion

            *!*				TEXT To lcCommand NoShow TextMerge Pretext 15
            *!*				This.<<This.cReportQueryName>>_GetFilters()
            *!*				ENDTEXT

            *!*				&lcCommand

            *!*				loParam = Createobject( "Empty" )
            *!*				AddProperty( loParam, "oUserTier", This )

            *!*				TEXT To lcCommand NoShow TextMerge Pretext 15
            *!*				Do Form '<<Addbs( This.cReportFormFolder )>><<This.cReportFormName>>'
            *!*				With loParam to llOk
            *!*				ENDTEXT

            *!*				&lcCommand

        Catch To oErr
            llOk = .F.
            This.oError.Process( oErr )

        Finally
            loParam = Null
            If Used( lcAlias )
                Use In Alias( lcAlias )
            Endif
			If Used( "cTitulo" )
	            Use In "cTitulo"
			EndIf
			If Used( lcOldAlias )
				Select Alias ( lcOldAlias )
			EndIf
        Endtry

        Return llOk

    Endproc
    *!*
    *!* END PROCEDURE DoReport
    *!*
    *!* ///////////////////////////////////////////////////////

    *
    * oReport_Access
    Procedure oReport_Access()

        This.oReport = This.oServiceTier.oReport

        Return This.oReport

    Endproc && oReport_Access


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: oColReportFilters_Access
    *!* Description...:
    *!* Date..........: Viernes 24 de Agosto de 2007 (17:04:57)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure oColReportFilters_Access(  ) As Collection

        If IsEmpty( This.oColReportFilters ) And !This.lOnDestroy
            This.oColReportFilters = Newobject( "colFiltros","colFiltros.Prg" )
        Endif

        Return This.oColReportFilters

    Endproc && OColReportFilters_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: oColReportFields_Access
    *!* Description...:
    *!* Date..........: Viernes 24 de Agosto de 2007 (17:04:57)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure oColReportFields_Access(  ) As Collection

        If IsEmpty( This.oColReportFields ) And !This.lOnDestroy
*!*	            This.oColReportFields = Newobject( "colFields","colFields.Prg" )
        Endif

        Return This.oColReportFields

    Endproc && oColReportFields_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: oColReportOrderBy_Access
    *!* Description...:
    *!* Date..........: Viernes 24 de Agosto de 2007 (17:04:57)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure oColReportOrderBy_Access(  ) As Collection

        If IsEmpty( This.oColReportOrderBy ) And !This.lOnDestroy
            This.oColReportOrderBy = Newobject( "ColReportOrderBy","ColReportOrderBy.Prg" )
        Endif

        Return This.oColReportOrderBy

    Endproc && oColReportFields_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: HookAfterReadIniFile
    *!* Description...: Template Method
    *!* Date..........: Domingo 2 de Marzo de 2008 (19:05:31)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure HookAfterReadIniFile(  ) As Void;
            HELPSTRING "Template Method"

        Try

            If Empty( This.cNextTierClass )
                This.cNextTierClass = "vt" + Substr( This.Name, 3 )

            Endif

            If Empty( This.cNextTierClassLibrary )
                This.cNextTierClassLibrary = Addbs(This.cNextTierClassLibraryFolder) + This.cNextTierClass + ".prg"

            Endif


        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError


        Finally

        Endtry

    Endproc && HookAfterReadIniFile

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

        Local lnRetVal As Number
        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

        Try
            loError = This.oError
            loError.TraceLogin = ""
            loError.Remark = ""

            lnRetVal = 0
            lnRetVal = This.oNextTier.GetRecCount( tcFilterCriteria )
            This.RetrieveNextTierData()

        Catch To oErr
            This.lIsOk = .F.
            This.cXMLoError = This.oError.Process( oErr )

        Finally
            loError = Null

        Endtry

        Return ( lnRetVal )

    Endproc && GetRecCount

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: oError_Access
    *!* Date..........: Sábado 18 de Abril de 2009 (20:18:12)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure oError_Access()

        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

        Try

            If Vartype( This.oError ) # "O" And !This.lOnDestroy
                loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

                * Por defecto, todas las capas tiene habilitada la posibilidad de loguear el error
                * El objeto ErrorHandler loguea el error en el proceso en el que se produce, y luego
                * bloquea los logueos subsiguientes.
                * Solo en la UserTier se muestra el error al usuario
                loError.TierBehavior = EH_SHOWERROR + EH_LOGERROR
                loError.cTierLevel = This.cTierLevel
                This.oError = loError

            Endif

        Catch To oErr
            This.lIsOk = .F.
            Throw oErr

        Finally
            loError = Null

        Endtry

        Return This.oError

    Endproc && oError_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: oUser_Access
    *!* Date..........: Lunes 27 de Abril de 2009 (14:08:51)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure oUser_Access()
        Local loUser As Object
        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

        Try
            loError = This.oError
            loError.TraceLogin = "Creando referencia al objeto usuario"
            loError.Remark = ""

            If Vartype( This.oUser ) # "O" And ! This.lOnDestroy
                * <TODO>: Encapsular la obtencion de oUser
                * Puede ser a traves de oGlobalSettings
                *!*	loUser = Createobject( "Empty" )
                *!*	AddProperty( loUser, "nEntidadId", 1 )
                *!*	AddProperty( loUser, "cTerminal", "User cTerminal" )
                loUser = createobjparam( "nEntidadId", 1, "cTerminal", "User cTerminal" )

                This.oUser = loUser

            Endif

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )
            Endif

        Finally
            loError = Null
            loUser = Null
            If !This.lIsOk
                Throw This.oError

            Endif

        Endtry

        Return This.oUser

    Endproc && oUser_Access

    *
    * Creación del objeto On Demmand
    Procedure oNextTier_Access(  ) As Object;
            HELPSTRING "Creación del objeto On Demmand"

        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Creación del objeto On Demmand
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:27:22)
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
			Object
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif
        Local llAlreadyExist As Boolean

        Try
            This.oError.TraceLogin = ""
            This.oError.Remark = ""

            If !This.lOnDestroy

                llAlreadyExist = .F.

                If Vartype(This.oNextTier)#"O"

                    This.oNextTier = This.InstanciateEntity( This.cDataConfigurationKey, This.cNextTierLevel )

                Else
                    llAlreadyExist = .T.

                Endif

                This.lNextTierAlreadyExist = llAlreadyExist

                If This.lIsOk And ! llAlreadyExist
                    This.NextTierSetup( This.oNextTier )

                Endif
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

        Return This.oNextTier

    Endproc && oNextTier_Access

    *
    * ClassBefore Event
    * Setea propiedades en la siguiente capa
    Protected Procedure xxxClassBeforeNextTierSetup( oTier As Object ) As Boolean


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
			Miércoles 13 de Mayo de 2009 (17:18:55)
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
			oTier AS Object
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

        Local llExecuteNextTierSetup As Boolean

        Try

            llExecuteNextTierSetup = .T.

            If Empty( This.cMainEntity )
                oTier.cMainEntity = This.cDataConfigurationKey

            Else
                oTier.cMainEntity = This.cMainEntity

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

        Return llExecuteNextTierSetup

    Endproc && ClassBeforeNextTierSetup


    *
    * Devuelve el nombre del formulario selector
    Procedure GetSelectorFormName( oParam As Object ) As String;
            HELPSTRING "Devuelve el nombre del formulario selector"
        Local lcSelectorFormName As String

        If !Empty( This.cSelectorFormName )
            lcSelectorFormName = This.cSelectorFormName
        Else
            lcSelectorFormName = This.oServiceTier.GetSelectorFormName( oParam )

        Endif && !Empty( This.cSelectorFormName )


        Return lcSelectorFormName

    Endproc && GetSelectorFormName

    *
    * Devuelve el Caption del formulario selector
    Procedure GetSelectorFormCaption( oParam As Object ) As String;
            HELPSTRING "Devuelve el Caption del formulario selector"

        Return This.oServiceTier.GetSelectorFormCaption( oParam )

    Endproc && GetSelectorFormCaption


    *
    * Devuelve el nombre de la rutina de paginacion
    Procedure GetPaginationRoutineName( oParam As Object ) As String;
            HELPSTRING "Devuelve el nombre de la rutina de paginacion"

        Return This.oServiceTier.GetPaginationRoutineName( oParam )

    Endproc && GetPaginationRoutineName

    *
    * Devuelve el nombre del formulario asociado a la entidad
    Procedure GetFormName( oParam As Object ) As String;
            HELPSTRING "Devuelve el nombre del formulario asociado a la entidad"

        Return This.oServiceTier.GetFormName( oParam )

    Endproc && GetFormName

    * Abre la transacción
    Procedure TransactionBegin() As Boolean ;
            HELPSTRING "Abre la transacción"

        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Abre la transacción
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Martes 2 de Junio de 2009
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

        Try

            Begin Transaction

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError = This.oError.Process( oErr )
            Endif
        Finally
            If !This.lIsOk
                Throw This.oError
            Endif
        Endtry

    Endproc && TransactionBegin

    * Termina (commit) la transacción
    Procedure TransactionEnd() As Boolean ;
            HELPSTRING "Termina (commit) la transacción"

        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Termina (commit) la transacción
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Martes 2 de Junio de 2009
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

        Try

            End Transaction

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError = This.oError.Process( oErr )
            Endif
        Finally
            If !This.lIsOk
                Throw This.oError
            Endif
        Endtry

    Endproc && TransactionEnd

    * Deshace la transacción
    Procedure TransactionRollBack( tlRollBackAll As Boolean ) As Boolean ;
            HELPSTRING "Deshace la transacción"

        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Deshace la transacción
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Martes 2 de Junio de 2009
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
        Local lcEntityCursor As String
        Try
            * DAE 2009-09-23(16:13:05)
            lcEntityCursor = This.cEntityCursor

            If Used( lcEntityCursor )

                If CursorGetProp( "Buffering", lcEntityCursor ) # 1
                    Tableupdate( 0, .F., lcEntityCursor )

                Endif && CursorGetProp( "Buffering", lcEntityCursor ) # 1

                *   Este error se producía si no había ningún registro cargado en la tabla,
                *   y se ejecutaba el Rollback
                *   Se solucionó ejecutando el Tableupdate()
                *!*	Index does not match the table. Delete the index file and re-create the index.
                *!*	[ Error N° ] 114
                *!*	[ Message ] Index does not match the table. Delete the index file and re-create the index.
                *!*	[ Procedure ] transactionrollback
                *!*	[ Line N° ] 2378
                *!*	[ Line Contents ] Rollback
                *!*	[ OLE 2.0 Exception N° ] 0
                *!*	[ ODBC Error N° ] 0
                *!*	[ ODBC Connection Handle ] 0


                If tlRollBackAll
                    Do While !Empty( Txnlevel() )
                        Rollback

                    Enddo

                Else
                    Rollback

                Endif
            Endif

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError = This.oError.Process( oErr )

            Endif && This.lIsOk

        Finally

            If ! This.lIsOk
                Throw This.oError

            Endif && ! This.lIsOk

        Endtry

    Endproc && TransactionRollBack

    *
    * nNivelJerarquiaTablas_Access
    Protected Procedure nNivelJerarquiaTablas_Access()
        This.nNivelJerarquiaTablas = This.oServiceTier.nNivelJerarquiaTablas

        Return This.nNivelJerarquiaTablas

    Endproc && nNivelJerarquiaTablas_Access



    *
    * Se ejecuta cuando cambia el valor de la entidad
    Procedure InteractiveChange( tnEntidadId As Integer ) As Void;
            HELPSTRING "Se ejecuta cuando cambia el valor de la entidad"


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Se ejecuta cuando cambia el valor de la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 21 de Julio de 2009 (10:30:36)
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
			tnEntidadId AS Integer
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

        Try
            * DA 2009-08-07(12:05:50)
            * Asigno a la entidad la nueva PK
            This.nEntidadId = tnEntidadId
            Raiseevent( This, "OnChange", tnEntidadId, This.cMainCursorPK )

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

    Endproc && InteractiveChange


    *
    *
    Procedure OnChange( tnEntidadId As Integer, tcParentCursorPK As String ) As Void


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 21 de Julio de 2009 (11:00:27)
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

    Endproc && OnChange

    *
    * Se dispara cuando la entidad padre cambia su valor
    Procedure HookOnParentChange( tnEntidadId As Integer,;
            tcParentCursorPK ) As Void;
            HELPSTRING "Se dispara cuando la entidad padre cambia su valor"

        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Se dispara cuando la entidad padre cambia su valor
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 21 de Julio de 2009 (10:39:12)
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
			tnEntidadId AS Integer
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

        Try
            Local lcFilterCriteria As String

            *Messagebox( "Se cambio a la entidad " + Transform( tnEntidadId ))

            tnEntidadId = Transform( tnEntidadId )
            TEXT To lcFilterCriteria NoShow TextMerge Pretext 15
               <<This.cMainTableName>>.<<tcParentCursorPK>> = <<tnEntidadId>>
            ENDTEXT

            Raiseevent( This, "OnParentChange", lcFilterCriteria )
            Raiseevent( This, "OnClear" )


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

    Endproc && HookOnParentChange

    *
    *
    Procedure OnParentChange( tcFilterCriteria As String ) As Void


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Miércoles 22 de Julio de 2009 (09:12:43)
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
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

    Endproc && OnParentChange

    *
    *
    Procedure cMainEntity_Access(  ) As String


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 21 de Julio de 2009 (12:19:10)
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

        Try
            If Empty( This.cMainEntity ) And !This.lOnDestroy
                This.cMainEntity = This.oServiceTier.cMainEntity
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
        Return This.cMainEntity
    Endproc && cMainEntity_Access

    *
    *
    Procedure InternalGetRecno( toTable As Object, tlGet As Boolean ) As Void

        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Viernes 24 de Julio de 2009 (11:24:30)
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
			toTable As oTable Of "Comun\Prg\ColTables.prg"
			tlGet As Boolean
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif
        Local lcAlias As String
        Try

            lcAlias = Alias()
            If Used( toTable.CursorName )
                Select ( toTable.CursorName )
                If tlGet
                    toTable.CurReg = SaveRecNo( toTable.CursorName )

                Else
                    RestRecNo( toTable.CurReg, toTable.CursorName )

                Endif && tlGet

            Endif && Used( toTable.CursorName )

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError = This.oError.Process( oErr )
            Endif

        Finally
            If Used( lcAlias )
                Select Alias( lcAlias )

            Endif && Used( lcAlias )

            If ! This.lIsOk
                Throw This.oError

            Endif && ! This.lIsOk

        Endtry

    Endproc && InternalGetRecno

    *
    *
    Procedure GetRecno( tlGet As Boolean ) As Void


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Viernes 24 de Julio de 2009 (11:30:50)
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
			tlGet AS Boolean
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

        Try

            This.LookOverColTables( This.oColTables, "InternalGetRecno", tlGet )

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

    Endproc && GetRecno

    *
    * Evento invocado cuando se recibe el método OnParentChange
    Procedure OnClear(  ) As Void;
            HELPSTRING "Evento invocado cuando se recibe el método OnParentChange"


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Evento invocado cuando se recibe el método OnParentChange
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Viernes 24 de Julio de 2009 (12:35:12)
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

    Endproc && OnClear

    *
    *
    Procedure HookOnClear(  ) As Void


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Viernes 24 de Julio de 2009 (12:36:30)
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

        Raiseevent( This, "OnClear" )
        Raiseevent( This, "OnParentClear" )

    Endproc && HookOnClear

    *
    *
    Procedure OnParentClear(  ) As Void


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Viernes 24 de Julio de 2009 (12:44:15)
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


    Endproc && OnParentClear

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: GetLabel
    *!* Description...:
    *!* Date..........: Miércoles 29 de Julio de 2009 (18:24:12)
    *!* Author........: Damian Eiff
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure GetLabel( tnEntidadId As Integer ) As String

        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
        Local lcAlias As String
        Local lcExp As String
        Local lcRet As String
        Local lcEntityCursor As String
        Local loColData As Collection
        Try
            lcAlias = Alias()
            loError = This.oError
            loError.Remark = ''
            loError.TraceLogin = ''
            If Empty( tnEntidadId )
                tnEntidadId = This.oServiceTier.nEntidadId

            Endif && Empty( tnEntidadId )

            lcEntityCursor = This.cEntityCursor
            lcExp = This.oServiceTier.cLabelExpression

            Select Alias( lcEntityCursor )

            TEXT To lcCommand NoShow TextMerge Pretext 15
				Locate For <<This.cMainCursorPK>> = <<tnEntidadId>>

            ENDTEXT

            loError.TraceLogin = 'Evaluando cCommand: ' + lcCommand
            &lcCommand

            lcExp = This.ProcessClause( lcExp, lcEntityCursor )

            loError.TraceLogin = 'Evaluando cExp: ' + lcExp
            lcRet = Evaluate( lcExp )

        Catch To oErr
            loError = This.oError
            This.cXMLoError = loError.Process( oErr )
            Throw loError

        Finally
            loError = This.oError
            loError.Remark = ''
            loError.TraceLogin = ''
            loError = Null

            If Used( lcAlias )
                Select Alias( lcAlias )

            Endif && Used( lcAlias )

        Endtry

        Return lcRet

    Endproc && GetLabel

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: oColImages_Access
    *!* Date..........: Jueves 30 de Julio de 2009 (16:00:10)
    *!* Author........: Damian Eiff
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure oColImages_Access()

        This.oColImages = This.oServiceTier.oColImages
        Return This.oColImages

    Endproc && oColImages_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: oColGridSelectorLayout_Access
    *!* Date..........: Martes 28 de Julio de 2009 (09:52:02)
    *!* Author........: Danny Amerikaner
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure oColGridSelectorLayout_Access()

        If Vartype( This.oColGridSelectorLayout ) # "O" And !This.lOnDestroy

            This.oColGridSelectorLayout = This.oServiceTier.oColGridSelectorLayout

        Endif

        Return This.oColGridSelectorLayout

    Endproc && oColGridSelectorLayout_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: oColNavigator_Access
    *!* Date..........: Viernes 31 de Julio de 2009 (12:14:16)
    *!* Author........: Danny Amerikaner
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure oColNavigator_Access()

        If Vartype( This.oColNavigator ) # "O" And !This.lOnDestroy

            This.oColNavigator = This.oServiceTier.oColNavigator

        Endif

        Return This.oColNavigator

    Endproc && oColNavigator_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: cNavigatorFilterCriteria_Access
    *!* Date..........: Viernes 31 de Julio de 2009 (16:14:22)
    *!* Author........: Damian Eiff
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure cNavigatorFilterCriteria_Access()

        This.cNavigatorFilterCriteria = This.oServiceTier.cNavigatorFilterCriteria
        Return This.cNavigatorFilterCriteria

    Endproc && cNavigatorFilterCriteria_Access


    * Class Event
    *
    Protected Procedure ClassBeforeSQLExecute( tcSQLCommand As String,;
            tcAlias As String ) As Boolean


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 4 de Agosto de 2009 (11:10:43)
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
			tcSQLCommand AS String
			tcAlias AS String
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

        Local llExecuteSQLExecute As Boolean
        Try

            llExecuteSQLExecute = .T.

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
        Return llExecuteSQLExecute
    Endproc && ClassBeforeSQLExecute

    * Hook Event
    *
    Procedure HookBeforeSQLExecute( tcSQLCommand As String,;
            tcAlias As String ) As Boolean


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 4 de Agosto de 2009 (11:12:00)
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
			tcSQLCommand AS String
			tcAlias AS String
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

        Local llExecuteSQLExecute As Boolean
        Try

            llExecuteSQLExecute = .T.

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
        Return llExecuteSQLExecute

    Endproc && HookBeforeSQLExecute

    *
    * Ejecuta un comando SQL y devuelve un XML
    Procedure SQLExecute( tcSQLCommand As String,;
            tcAlias As String ) As String;
            HELPSTRING "Ejecuta un comando SQL y devuelve un XML"


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Ejecuta un comando SQL y devuelve un XML
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 4 de Agosto de 2009 (11:05:08)
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
			tcSQLCommand AS String
			tcAlias AS String
			*:Remarks:
			*:Returns:
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

        Try

            This.oError.TraceLogin = ""
            This.oError.Remark = ""
            This.lIsOk = .T.

            If This.lIsOk And This.ClassBeforeSQLExecute( tcSQLCommand,;
                    tcAlias )

                If This.lIsOk And This.HookBeforeSQLExecute( tcSQLCommand,;
                        tcAlias )

                    lcXML = This.oNextTier.SQLExecute( tcSQLCommand, tcAlias )

                    This.ValidateXML( lcXML )

                    If This.lIsOk
                        This.HookAfterSQLExecute( tcSQLCommand,;
                            tcAlias )
                    Endif

                Endif

                If This.lIsOk
                    This.ClassAfterSQLExecute( tcSQLCommand,;
                        tcAlias )
                Endif

            Endif

        Catch To oErr
            If This.lIsOk
                This.lIsOk = .F.
                This.cXMLoError=This.oError.Process( oErr )
            Endif

        Finally

        Endtry

        Return lcXML

    Endproc && SQLExecute



    * Hook Event
    *
    Procedure HookAfterSQLExecute( tcSQLCommand As String,;
            tcAlias As String ) As Void


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 4 de Agosto de 2009 (11:13:23)
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
			tcSQLCommand AS String
			tcAlias AS String
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

    Endproc && HookAfterSQLExecute

    * Class Event
    *
    Protected Procedure ClassAfterSQLExecute( tcSQLCommand As String,;
            tcAlias As String ) As Void


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Martes 4 de Agosto de 2009 (11:14:07)
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
			tcSQLCommand AS String
			tcAlias AS String
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
            ENDTEXT
        #Endif

        Try

            This.RetrieveNextTierData()

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

    Endproc && ClassAfterSQLExecute


    *
    * oColKeyFinderControls_Access
    Protected Procedure oColKeyFinderControls_Access()

        If Vartype( This.oColKeyFinderControls ) # "O" And !This.lOnDestroy
            This.oColKeyFinderControls = This.oServiceTier.oColKeyFinderControls
        Endif

        Return This.oColKeyFinderControls

    Endproc && oColKeyFinderControls_Access

    *
    * oColKeyFinderFastSearch_Access
    Protected Procedure oColKeyFinderFastSearch_Access()

        If Vartype( This.oColKeyFinderFastSearch ) # "O" And !This.lOnDestroy
            This.oColKeyFinderFastSearch = This.oServiceTier.oColKeyFinderFastSearch
        Endif

        Return This.oColKeyFinderFastSearch

    Endproc && oColKeyFinderFastSearch_Access

    *
    * Actualiza el campo Default
    Procedure UpdateDefault(  ) As Void;
            HELPSTRING "Actualiza el campo Default"


        #If .F.
            TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Actualiza el campo Default
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Jueves 24 de Septiembre de 2009 (17:06:12)
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

        Local loParent As utArchivo Of "FW\TierAdapter\UserTier\utArchivo.prg"
        Try


            If This.lHasDefault And This.lIsChild

                If This.GetValue( "Default" ) = TRUE

                    loParent = This.oParent


                    TEXT To lcCommand NoShow TextMerge Pretext 15
					Replace In <<This.cEntityCursor>>
					Default With <<FALSE>>
					For Default = <<TRUE>>
					And <<This.cMainCursorPK>> <> <<This.nEntidadId>>
					And <<loParent.cMainCursorPK>> = <<loParent.nEntidadId>>
                    ENDTEXT

                    &lcCommand

                    This.LocatePK()
                    Replace Selected With TRUE

                Endif

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

    Endproc && UpdateDefault

    *
    * cDisplayValue_Access
    Protected Procedure cDisplayValue_Access()

        If Empty( This.cDisplayValue )
            This.cDisplayValue = This.cDataConfigurationKey
        Endif

        Return This.cDisplayValue

    Endproc && cDisplayValue_Access

Enddefine && UserTierAdapter