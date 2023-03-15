#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\FE\Include\FE.h"
#INCLUDE "Tools\JSON\Include\http.h"

*
*
Procedure Modelo(  ) As Void
    Local lcCommand As String

    Try

        lcCommand = ""
        External Procedure GetTable.prg,;
            _controles_base.prg

        External Class Crud.vcx,;
            _controles_base.vcx

    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally

    Endtry

Endproc && Modelo

*!* ///////////////////////////////////////////////////////
*!* Class.........: oModelo
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:36:05)
*!*
*!*

Define Class oModelo As SessionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"

    #If .F.
        Local This As oModelo Of "FrontEnd\Prg\Modelo.prg"
    #Endif


    * Nombre del Modelo definido en el BackEnd
    cModelo = ""

    * Tabla asociada al modelo
    cTabla = ""

    * Indica si la entidad se puede Crear
    lCanCreate = .T.

    * Indica si la entidad se puede Consultar
    lCanRead = .T.

    * Indica si la entidad se puede Modificar
    lCanUpdate = .T.

    * Indica si la entidad se puede Borrar
    lCanDelete = .T.

    lCanList 	= .F.

    * URL de la API
    cURL = ""

    * Indica si edita en Browse o en Edit
    lEditInBrowse = .F.
    * Muestra el control
    lShowEditInBrowse = .F.
    * Muestra campos especiales
    lShowCamposEspeciales = .F.

    * Indica si las altas las ingresa en Browse, sin importar lEditInBrowse
    lCreateInBrowse = .F.

    *
    Wclav = "A"


    * Guarda los parametros de la última consulta
    oRequery = Null
    * Parametros especiales para consulta con WCLAV = "A"
    oQuery_A = Null
    oQuery_B = Null
    oQuery_M = Null

    * Nombre del cursor virtual asociado a la entidad
    cMainCursorName = ""

    * Criterio de busqueda por defecto
    * Es una coleccion
    * Cada item es un objeto
    * 	loFiltro = CreateObject( "Empty" )
    * 	Addproperty( loFiltro, "Activo", .T. )
    * 	oFilterCriteria.Add( loFiltro )

    * 	loFiltro = CreateObject( "Empty" )
    * 	Addproperty( loFiltro, "Activo", .T. )
    * 	oFilterCriteria.Add( loFiltro )
    oFilterCriteria = Null


    * Indica si la entidad es hija de otra
    lIsChild = .F.

    * Indica si el modelo filtra por Cliente_Praxis
    lFiltrarPorClientePraxis = .T.

    * Nombre de la Entidad Padre
    cParent = ""

    * Referencia al objeto Padre
    oParent = Null

    *!*		* Coleccion de Tablas que forman parte del proceso
    *!*		oColTables = Null

    * Coleccion de cursores auxiliares
    oCursores = Null

    * Nombre del Campo que es la PK
    cPKField = "Id"

    oColErrors = Null

    cTituloEnGrilla = ""
    cTituloEnForm	= ""

    cFormIndividual = ""
    cGrilla 		= ""

    * Título del Informe
    cTituloDelInforme 	= ""


    nId 			= 0
    oRegistro 		= Null

    nTotalDeRegistros 	= 0
    cUrlNext 			= ""
    cUrlPrevious 		= ""
    nCurrentPage 		= 0
    nLastPage 			= 0
    nPageSize			= 15

    * Lo maneja el DblClick del Header de la grilla, pero
    * puede usarse en cualquier tipo de consulta para sobreescribir el
    * prdenamiento dado en el Modelo.
    * Nombre del campo por el que se ordena
    cOrderBy 		= ""
    * Asc= "". Desc= "-"
    cOrderPrefix 	= ""

    * Id del Cliente Praxis activo
    nClientePraxis = 0

    * Colección de Salidas para Exportar
    oSalidas = Null

    *!*	* -------------- Tipo de Salida -------------------------
    *!*	#Define S_IMPRESORA					'0'
    *!*	#Define S_VISTA_PREVIA				'1'
    *!*	#Define S_HOJA_DE_CALCULO			'2'
    *!*	#Define S_PANTALLA					'3'
    *!*	#Define S_PDF						'4'
    *!*	#Define S_CSV						'5'
    *!*	#Define S_SDF						'6'
    *!*	#Define S_IMPRESORA_PREDETERMINADA	'7'
    *!*	#Define S_TXT						'8'
    *!*	#Define S_MAIL						'9'
    *!*	#Define S_LISTADO_DOS				'99'
    *
    * Salida actual
    cSalida = S_IMPRESORA

    * Titulo Actual
    cTitulo = ""

    * Indica si trae solo la pagina o todo el conjunto de datos
    lGetAll = .F.

    * Indica si el registro es validado al Importar/Exportar
    * Se utiliza principalmente para compatibilizar los campos
    * NULL de PosdtgreSQL con los Empty() de los cursores Vfp9
    lValidate = .F.

    * Indica si devuelve un objeto Vfp o un archivo Csv
    * Valores válidos: "Vfp","Csv"
    cReturnType = "Vfp"

    * Seguimiento de la llamada (Para debugging)
    cTrace = ""

    * Observaciones
    cRemark = ""

    * Cuando el campo contiene una FK, indica si muestra la FK, o el
    * nombre de la FK apuntada, al momento de Listar
    lStr = .T.

    * Utiliza Actualización Masiva
    lBulkUpdate = .F.

    * Campos que se actualizan en forma masiva
    cBulkFieldList = "id,Nombre,Activo,Orden,Es_Sistema"

    * Buffering del cursor generado
    nBuffering = 5


    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="ctituloengrilla" type="property" display="cTituloEnGrilla" />] + ;
        [<memberdata name="ctituloenform" type="property" display="cTituloEnForm" />] + ;
        [<memberdata name="ctitulodelinforme" type="property" display="cTituloDelInforme" />] + ;
        [<memberdata name="guardarvarios" type="method" display="GuardarVarios" />] + ;
        [<memberdata name="gettable" type="method" display="GetTable" />] + ;
        [<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
        [<memberdata name="ocursores" type="property" display="oCursores" />] + ;
        [<memberdata name="cmodelo" type="property" display="cModelo" />] + ;
        [<memberdata name="curl" type="property" display="cURL" />] + ;
        [<memberdata name="lcancreate" type="property" display="lCanCreate" />] + ;
        [<memberdata name="lcanread" type="property" display="lCanRead" />] + ;
        [<memberdata name="lcanupdate" type="property" display="lCanUpdate" />] + ;
        [<memberdata name="lcandelete" type="property" display="lCanDelete" />] + ;
        [<memberdata name="lcanlist" type="property" display="lCanList" />] + ;
        [<memberdata name="initialize" type="method" display="Initialize" />] + ;
        [<memberdata name="obtenerpermisos" type="method" display="ObtenerPermisos" />] + ;
        [<memberdata name="leditinbrowse" type="property" display="lEditInBrowse" />] + ;
        [<memberdata name="lcreateinbrowse" type="property" display="lCreateInBrowse" />] + ;
        [<memberdata name="wclav" type="property" display="Wclav" />] + ;
        [<memberdata name="wclav_assign" type="method" display="Wclav_Assign" />] + ;
        [<memberdata name="orequery" type="property" display="oRequery" />] + ;
        [<memberdata name="oquery_a" type="property" display="oQuery_A" />] + ;
        [<memberdata name="oquery_b" type="property" display="oQuery_B" />] + ;
        [<memberdata name="oquery_m" type="property" display="oQuery_M" />] + ;
        [<memberdata name="cmaincursorname" type="property" display="cMainCursorName" />] + ;
        [<memberdata name="cmaincursorname_access" type="method" display="cMainCursorName_Access" />] + ;
        [<memberdata name="requery" type="method" display="Requery" />] + ;
        [<memberdata name="getone" type="method" display="GetOne" />] + ;
        [<memberdata name="getall" type="method" display="GetAll" />] + ;
        [<memberdata name="getbywhere" type="method" display="GetByWhere" />] + ;
        [<memberdata name="consumirapi" type="method" display="ConsumirApi" />] + ;
        [<memberdata name="listar" type="method" display="Listar" />] + ;
        [<memberdata name="traer" type="method" display="Traer" />] + ;
        [<memberdata name="crearcursores" type="method" display="CrearCursores" />] + ;
        [<memberdata name="crearcursor" type="method" display="CrearCursor" />] + ;
        [<memberdata name="getbypk" type="method" display="GetByPK" />] + ;
        [<memberdata name="ofiltercriteria" type="property" display="oFilterCriteria" />] + ;
        [<memberdata name="lischild" type="property" display="lIsChild" />] + ;
        [<memberdata name="cparent" type="property" display="cParent" />] + ;
        [<memberdata name="oparent" type="property" display="oParent" />] + ;
        [<memberdata name="oparent_access" type="method" display="oParent_Access" />] + ;
        [<memberdata name="oparent_assign" type="method" display="oParent_Assign" />] + ;
        [<memberdata name="ocolerrors" type="property" display="oColErrors" />] + ;
        [<memberdata name="mostrarerrores" type="method" display="MostrarErrores" />] + ;
        [<memberdata name="manejarerrores" type="method" display="ManejarErrores" />] + ;
        [<memberdata name="baja" type="method" display="Baja" />] + ;
        [<memberdata name="modificacion" type="method" display="Modificacion" />] + ;
        [<memberdata name="alta" type="method" display="Alta" />] + ;
        [<memberdata name="launcheditform" type="method" display="LaunchEditForm" />] + ;
        [<memberdata name="hookbeforelaunch" type="method" display="HookBeforeLaunch" />] + ;
        [<memberdata name="cargarfiltrosiniciales" type="method" display="CargarFiltrosIniciales" />] + ;
        [<memberdata name="grabar" type="method" display="Grabar" />] + ;
        [<memberdata name="cformindividual" type="property" display="cFormIndividual" />] + ;
        [<memberdata name="cgrilla" type="property" display="cGrilla" />] + ;
        [<memberdata name="nid" type="property" display="nId" />] + ;
        [<memberdata name="cpkfield" type="property" display="cPKField" />] + ;
        [<memberdata name="oregistro" type="property" display="oRegistro" />] + ;
        [<memberdata name="curlprevious" type="property" display="cUrlPrevious" />] + ;
        [<memberdata name="curlnext" type="property" display="cUrlNext" />] + ;
        [<memberdata name="ntotalderegistros" type="property" display="nTotalDeRegistros" />] + ;
        [<memberdata name="ncurrentpage" type="property" display="nCurrentPage" />] + ;
        [<memberdata name="nlastpage" type="property" display="nLastPage" />] + ;
        [<memberdata name="npagesize" type="property" display="nPageSize" />] + ;
        [<memberdata name="corderby" type="property" display="cOrderBy" />] + ;
        [<memberdata name="corderprefix" type="property" display="cOrderPrefix" />] + ;
        [<memberdata name="hookbeforegetbywhere" type="method" display="HookBeforeGetByWhere" />] + ;
        [<memberdata name="ctabla" type="property" display="cTabla" />] + ;
        [<memberdata name="ctabla_access" type="method" display="cTabla_Access" />] + ;
        [<memberdata name="lfiltrarporclientepraxis" type="property" display="lFiltrarPorClientePraxis" />] + ;
        [<memberdata name="nclientepraxis" type="property" display="nClientePraxis" />] + ;
        [<memberdata name="nclientepraxis_access" type="method" display="nClientePraxis_Access" />] + ;
        [<memberdata name="osalidas" type="property" display="oSalidas" />] + ;
        [<memberdata name="osalidas_access" type="method" display="oSalidas_Access" />] + ;
        [<memberdata name="csalida" type="property" display="cSalida" />] + ;
        [<memberdata name="ctitulo" type="property" display="cTitulo" />] + ;
        [<memberdata name="lgetall" type="property" display="lGetAll" />] + ;
        [<memberdata name="creturntype" type="property" display="cReturnType" />] + ;
        [<memberdata name="lvalidate" type="property" display="lValidate" />] + ;
        [<memberdata name="hookfiltercriteria" type="method" display="HookFilterCriteria" />] + ;
        [<memberdata name="addfilter" type="method" display="AddFilter" />] + ;
        [<memberdata name="removefilter" type="method" display="RemoveFilter" />] + ;
        [<memberdata name="ctrace" type="property" display="cTrace" />] + ;
        [<memberdata name="cremark" type="property" display="cRemark" />] + ;
        [<memberdata name="lshoweditinbrowse" type="property" display="lShowEditInBrowse" />] + ;
        [<memberdata name="lshowcamposespeciales" type="property" display="lShowCamposEspeciales" />] + ;
        [<memberdata name="lbulkupdate" type="property" display="lBulkUpdate" />] + ;
        [<memberdata name="cbulkfieldlist" type="property" display="cBulkFieldList" />] + ;
        [<memberdata name="getbulkfieldlist" type="method" display="GetBulkFieldList" />] + ;
        [<memberdata name="nbuffering" type="property" display="nBuffering" />] + ;
        [<memberdata name="cleanreg" type="method" display="CleanReg" />] + ;
        [</VFPData>]


    Procedure Init()

        * If !IsRuntime()
        Set DataSession To
        * Endif

        This.nOldDataSessionId = This.DataSessionId
        This.oFilterCriteria = Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.Prg" )
        This.ObtenerPermisos()

        Return .T.

    Endproc && Init



    *
    *
    Procedure Initialize( oParam As Object ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""
            If IsEmpty( oParam )
                oParam = Createobject( "Empty" )
            Endif
            If Pemstatus( oParam, "cUrl", 5 )
                This.cURL = oParam.cURL
            Endif
            If Pemstatus( oParam, "nPermisos", 5 )
                This.ObtenerPermisos( oParam.nPermisos )
            Endif

            If Empty( This.cTituloEnGrilla )
                This.cTituloEnGrilla = Prompt()
            Endif

            If Empty( This.cTituloEnForm )
                This.cTituloEnForm = Prompt()
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

    *
    *
    Procedure ObtenerPermisos( nPermisos As Integer ) As Void
        Local lcCommand As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"


        Try

            lcCommand = ""
            If Empty( nPermisos )
            	* RA 27/02/2023(12:14:33)
            	* Por defecto, tiene todos los permisos
                nPermisos = CAN_CREATE + CAN_READ + CAN_UPDATE + CAN_DELETE + CAN_LIST
            Endif

            loUser = NewUser()

            If loUser.lIsSuperuser
                This.lCanCreate = .T.
                This.lCanRead  	= .T.
                This.lCanUpdate = .T.
                This.lCanDelete = .T.
                This.lCanList  	= .T.

                This.lShowCamposEspeciales = .T.

            Else
                This.lCanCreate = Bittest( nPermisos, 4 )	&&	CAN_CREATE	16
                This.lCanRead  	= Bittest( nPermisos, 3 )	&&	CAN_READ 	8
                This.lCanUpdate = Bittest( nPermisos, 2 )	&&	CAN_UPDATE 	4
                This.lCanDelete = Bittest( nPermisos, 1 )	&&	CAN_DELETE  2
                This.lCanList  	= Bittest( nPermisos, 0 )	&&  CAN_LIST 	1

                This.lShowCamposEspeciales = Inlist( .T.,;
                    loUser.lModificaActivo,;
                    loUser.lModificaOrden,;
                    loUser.lModificaEsSistema )

                This.lShowEditInBrowse = loUser.lShowEditInBrowse

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loUser = Null

        Endtry

    Endproc && ObtenerPermisos



    *
    *
    Procedure ObtenerPermisos_Old( nPermisos As Integer ) As Void
        Local lcCommand As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"


        Try

            lcCommand = ""

            loUser = NewUser()

            If loUser.lIsSuperuser
                This.lCanCreate = .T.
                This.lCanRead  	= .T.
                This.lCanUpdate = .T.
                This.lCanDelete = .T.
                This.lCanList  	= .T.

                This.lShowCamposEspeciales = .T.

            Else
                This.lCanCreate = Bittest( nPermisos, 4 )	&&	16
                This.lCanRead  	= Bittest( nPermisos, 3 )	&&	8
                This.lCanUpdate = Bittest( nPermisos, 2 )	&&	4
                This.lCanDelete = Bittest( nPermisos, 1 )	&&	2
                This.lCanList  	= Bittest( nPermisos, 0 )	&&  1

                This.lShowCamposEspeciales = Inlist( .T.,;
                    loUser.lModificaActivo,;
                    loUser.lModificaOrden,;
                    loUser.lModificaEsSistema )

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loUser = Null

        Endtry

    Endproc && ObtenerPermisos_Old



    *
    *
    Procedure HookBeforeGetByWhere( oParam As Object ) As Object
        Local lcCommand As String

        Try

            lcCommand = ""


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return oParam

    Endproc && HookBeforeGetByWhere

    *
    *
    *
    * Trae los elementos filtrados por alguna condicion
    * oParam.oFilterCriteria = Criterio de Filtro (Es una coleccion)
    * oParam.cAlias = Alias alternativo a This.cMainCursorName
    * oParam.lSilence = No muestra mensajes
    * Devuelve el nombre del cursor que contiene los datos

    Procedure GetByWhere( oParam As Object ) As Object
        Local lcCommand As String,;
            lcAlias As String
        Local loFilterCriteria As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg
        Local loFiltro As Object
        Local loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg"
        Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loParent As oModelo Of "FrontEnd\Prg\Modelo.prg"
        Local loRespuesta As Object,;
            loReg As Object,;
            loRegValid As Object,;
            loData As Object,;
            loColReg As Collection,;
            loReturn As Object
        Local lnTally As Integer,;
            i As Integer
        Local llListar As Boolean,;
            llDone As Boolean
        Local luValue As Variant


        Try

            lcCommand = ""
            This.oColErrors = Null

            oParam = This.HookBeforeGetByWhere( oParam )

            loReturn = Createobject( "Empty" )
            AddProperty( loReturn, "nTally", 0 )
            AddProperty( loReturn, "oRegistro", Null )
            AddProperty( loReturn, "oData", Null )
            AddProperty( loReturn, "cAlias", "" )
            AddProperty( loReturn, "lOk", .F. )

            * Valores por defecto
            lcParentFilter 		= ""
            lcAlias 			= This.cMainCursorName
            loFilterCriteria 	= This.oFilterCriteria

            If Vartype( oParam ) # "O"
                oParam = Createobject( "Empty" )
            Endif

            If Pemstatus( oParam, "oFilterCriteria", 5 )
                loFilterCriteria = oParam.oFilterCriteria

            Else
                AddProperty( oParam, "oFilterCriteria", loFilterCriteria )

            Endif

            If Pemstatus( oParam, "cAlias", 5 )
                lcAlias = oParam.cAlias

            Else
                AddProperty( oParam, "cAlias", lcAlias )

            Endif

            If This.lIsChild
            
                loParent = This.oParent

                llDone = .F.

                Do While !llDone

                    If !Isnull( loParent.oRegistro )
                        loParent.nId = Evaluate( "loParent.oRegistro." + loParent.cPKField )
                    Endif

                    If Empty( loParent.nId )
                        loParent.nId = 0
                    Endif

                    If !Empty( loParent.nId )
                        loFiltro = Createobject( "Empty" )
                        AddProperty( loFiltro, "Nombre", loParent.cModelo  )
                        AddProperty( loFiltro, "FieldName", Lower( loParent.cModelo ))
                        AddProperty( loFiltro, "FieldRelation", "==" )
                        AddProperty( loFiltro, "FieldValue", Transform( loParent.nId ))

                        loFilterCriteria.RemoveItem( Lower( loFiltro.Nombre ) )
                        loFilterCriteria.Add( loFiltro, Lower( loFiltro.Nombre ))

                    Else
                        * RA 06/08/2022(10:10:38)
                        * Por defecto, si el padre no existe
                        * no trae ningun registro.
                        * Cualquier comportamiento personalizado
                        * se realiza en This.HookFilterCriteria()

                        loFiltro = Createobject( "Empty" )
                        AddProperty( loFiltro, "Nombre", "Empty" )
                        AddProperty( loFiltro, "FieldName", "empty" )
                        AddProperty( loFiltro, "FieldRelation", "==" )
                        AddProperty( loFiltro, "FieldValue", "True" )

                        loFilterCriteria.RemoveItem( Lower( loFiltro.Nombre ) )
                        loFilterCriteria.Add( loFiltro, Lower( loFiltro.Nombre ))

                    Endif

                    If .F. && loParent.lIsChild And !Empty( loParent.nId )
                        * RA 06/08/2022(10:58:50)
                        * Por ahora, solo filtrar por el padre
                        * Si se presenta algun escenario para filtrar por
                        * los abuelos veremos como se resuelve
                        loParent = loParent.oParent

                    Else
                        llDone = .T.

                    Endif

                Enddo

            Endif

            If This.lFiltrarPorClientePraxis And !Empty( This.nClientePraxis )
                loFiltro = Createobject( "Empty" )
                AddProperty( loFiltro, "Nombre", "Cliente_Praxis"  )
                AddProperty( loFiltro, "FieldName", Lower( "Cliente_Praxis" ))
                AddProperty( loFiltro, "FieldRelation", "==" )
                AddProperty( loFiltro, "FieldValue", Transform( This.nClientePraxis ))

                loFilterCriteria.RemoveItem( Lower( loFiltro.Nombre ) )
                loFilterCriteria.Add( loFiltro, Lower( loFiltro.Nombre ))


            Endif

            If !Empty( This.cOrderBy )

                loFiltro = Createobject( "Empty" )
                AddProperty( loFiltro, "Nombre", "Order_By"  )
                AddProperty( loFiltro, "FieldName", "ordering" )
                AddProperty( loFiltro, "FieldRelation", "=" )
                AddProperty( loFiltro, "FieldValue", This.cOrderPrefix + Lower(This.cOrderBy) )

                loFilterCriteria.RemoveItem( Lower( loFiltro.Nombre ) )
                loFilterCriteria.Add( loFiltro, Lower( loFiltro.Nombre ))

            Endif

            llListar 	= .T.
            luValue 	= .F.

            loFilterCriteria = This.HookFilterCriteria( loFilterCriteria )

            For Each loFiltro In loFilterCriteria
                If Inlist( Lower( loFiltro.FieldName ), Lower( This.cPKField ), "pk" )
                    llListar 	= .F.
                    luValue 	=  loFiltro.FieldValue
                Endif
            Endfor

            This.nTotalDeRegistros 	= 0
            This.nCurrentPage 		= 0
            This.cUrlNext 			= ""
            This.cUrlPrevious 		= ""
            This.nLastPage 			= 0

            If llListar
                This.CrearCursor( lcAlias, This.lStr  )
                loReturn = This.Listar( This.cURL, loFilterCriteria, lcAlias )

            Else
                loReturn = This.Traer( This.cURL, luValue, lcAlias, loFilterCriteria )

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return loReturn

    Endproc && GetByWhere



    *
    *
    Procedure HookFilterCriteria( oFilterCriteria As Collection ) As Collection
        Local lcCommand As String

        Try

            lcCommand = ""

            If Isnull( oFilterCriteria )
                oFilterCriteria = Createobject( "Collection" )
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return oFilterCriteria

    Endproc && HookFilterCriteria



    *
    *
    Procedure AddFilter( loFilter As Object ) As Void
        Local lcCommand As String
        Local loFiltros As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg


        Try

            lcCommand = ""
            This.RemoveFilter( loFilter.Nombre )
            loFiltros = This.oFilterCriteria
            loFiltros.AddItem( loFilter, Lower( loFilter.Nombre ))

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loFilter 	= Null
            loFiltros 	= Null


        Endtry


    Endproc && AddFilter

    *
    *
    Procedure RemoveFilter( cFilterName As String ) As Void
        Local lcCommand As String
        Local loFiltros As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg

        Try

            lcCommand = ""
            loFiltros = This.oFilterCriteria
            loFiltros.RemoveItem( Lower( cFilterName ))

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loFiltros = Null


        Endtry


    Endproc && RemoveFilter




    *
    *
    Procedure xxx___ConsumirApi(  ) As Object
        Local lcCommand As String
        Local loReturn As Object


        Try

            lcCommand = ""

            loReturn = Createobject( "Empty" )
            AddProperty( loReturn, "nTally", 0 )
            AddProperty( loReturn, "oRegistro", Null )
            AddProperty( loReturn, "oData", Null )
            AddProperty( loReturn, "cAlias", "" )
            AddProperty( loReturn, "lOk", .F. )

            loConsumirAPI = NewConsumirAPI()
            loConsumirAPI.cTrace 		= This.cTrace
            loConsumirAPI.cRemark 		= This.cRemark


            If llListar
                loRespuesta = loConsumirAPI.Listar( This.cURL, loFilterCriteria )
                loReturn = This.Listar( This.cURL, loFilterCriteria )

            Else
                loRespuesta = loConsumirAPI.Traer( This.cURL, luValue )
                loReturn = This.Traer( This.cURL, luValue )

            Endif

            loReturn.lOk = loRespuesta.lOk

            If loRespuesta.lOk
                *!*	loRespuesta
                *!*		lOk
                *!*		nStatus
                *!*		cErrorMessage
                *!*		cResponseText
                *!*		Data
                *!*			Count
                *!*			next
                *!*			Previous
                *!*			Results (Vfp Collection)

                If llListar
                    loData 		= loRespuesta.Data
                    loColReg 	= loData.Results
                    lnTally 	= loData.Count

                    This.nTotalDeRegistros 	= loData.Count
                    This.nCurrentPage 		= loData.current_page
                    This.cUrlNext 			= loData.Next
                    This.cUrlPrevious 		= loData.Previous
                    This.nLastPage 			= loData.total_pages

                    loReturn.oData = loColReg

                Else
                    loData 		= loRespuesta.Data
                    loColReg 	= Createobject( "Collection" )
                    lnTally 	= 1

                    AddProperty( loData, "r7Mov", " " )
                    AddProperty( loData, "ABM", 0 )
                    AddProperty( loData, "_RecordOrder", 1 )

                    loColReg.Add( loData )
                    loReturn.oRegistro = loData

                Endif

                loReturn.nTally = lnTally
                loReturn.cAlias = lcAlias

                This.CrearCursores( loColReg, This.cTabla, lcAlias, llListar )
                Select Alias( lcAlias )

                If lnTally = 1
                    Scatter Name loReturn.oRegistro Memo

                Endif

                *!*					Select Alias( lcAlias )
                *!*					Browse


            Else

                llOk = .F.
                TEXT To lcMsg NoShow TextMerge Pretext 03
				Status: <<loRespuesta.nStatus>>

				<<loRespuesta.cErrorMessage>>
                ENDTEXT

                Stop( lcMsg, "Consulta" )

            Endif



        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return loReturn

    Endproc && ConsumirApi



    *
    *
    Procedure CrearCursor( cAlias As String, lStr As Boolean ) As Void
        Local lcCommand As String,;
            lcAlias As String

        Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""
            lcAlias = cAlias

            loArchivo = This.GetTable( This.cTabla )
            loArchivo.lStr = lStr

            If Empty( lcAlias )
                lcAlias = This.cMainCursorName
            Endif
            loArchivo.CrearCursor( lcAlias )

            Select Alias( lcAlias )

            TEXT To lcCommand NoShow TextMerge Pretext 15
				Select 	*,
						Space( 1 ) as r7Mov,
						Cast( 0 as I ) as ABM,
						Cast( Recno() as I ) as _RecordOrder
					From <<lcAlias>>
					Into Cursor <<lcAlias>> ReadWrite
            ENDTEXT

            &lcCommand
            lcCommand = ""

            Try

                This.oCursores.Add( lcAlias, Lower( This.Name ) )

            Catch To oErr

            Finally

            Endtry

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && CrearCursor




    *
    * Sirve para crear el cursor a partir de la colección de registros
    * Se usa en el caso de cursores adjuntos al registro principal
    * En la mayoría de los casos, se utiliza CrearCursor(), que crea
    * un cursor vacío que es llenado en el metodo Listar() de la
    * clase ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg"
    Procedure CrearCursores( oColReg As Collection,;
            cTabla As String,;
            cAlias As String,;
            lListar As Boolean ) As Void

        Local lcCommand As String,;
            lcAlias As String,;
            lcCursorName As String
        Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loReg As Object,;
            loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loModelo As oModelo Of "FrontEnd\Prg\Modelo.prg",;
            loColTables As Collection


        Try

            lcCommand = ""

            lcAlias = cAlias

            loArchivo = This.GetTable( cTabla )

            If Empty( lcAlias )
                lcAlias = This.cMainCursorName
            Endif
            loArchivo.lStr = This.lStr
            loArchivo.CrearCursor( lcAlias )

            Select Alias( lcAlias )

            For Each loReg In oColReg

                loArchivo.ValidateData( loReg, lcAlias )

            Endfor

            TEXT To lcCommand NoShow TextMerge Pretext 15
				Select 	*,
						Space( 1 ) as r7Mov,
						Cast( 0 as I ) as ABM,
						Cast( Recno() as I ) as _RecordOrder
					From <<lcAlias>>
					Into Cursor <<lcAlias>> ReadWrite
            ENDTEXT

            &lcCommand
            lcCommand = ""

            CursorSetProp( "Buffering", This.nBuffering, lcAlias )

            Try

                This.oCursores.Add( lcAlias, Lower( This.Name ) )

            Catch To oErr

            Finally

            Endtry

            If !lListar

                loReg = oColReg.Item(1)
                loColFields = loArchivo.oColFields

                For Each loField In loColFields
                    Try

                        lcField = loField.Name
                        luValue = Evaluate( "loReg." + lcField )

                        If Vartype( luValue ) = "O"

                            If Lower( luValue.BaseClass ) = "collection"
                                lcCursorName = This.CrearCursores( luValue, loField.cReferences, "", .T. )

                                Try

                                    This.oCursores.Add( lcCursorName, Lower( loField.cReferences ) )

                                Catch To oErr

                                Finally

                                Endtry

                            Endif
                        Endif

                    Catch To oErr

                    Finally

                    Endtry

                Endfor
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return lcAlias

    Endproc && CrearCursores

    *
    *
    Procedure Listar( cURL As String,;
            oFilterCriteria As Collection,;
            cAlias As String,;
            oBody As Object ) As Object

        Local lcCommand As String,;
            lcTitulo As String,;
            lcAlias As String
        Local loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg",;
            loReturn As Object,;
            loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loRespuesta As Object,;
            loReg As Object
        Try

            lcCommand = ""
            loReturn = Createobject( "Empty" )
            AddProperty( loReturn, "nTally", 0 )
            AddProperty( loReturn, "oRegistro", Null )
            AddProperty( loReturn, "oData", Null )
            AddProperty( loReturn, "cAlias", "" )
            AddProperty( loReturn, "lOk", .F. )
            AddProperty( loReturn, "nStatus", _HTTP_200_OK )

            lcTitulo = This.cTitulo
            If Empty( lcTitulo )
                lcTitulo = This.cTituloDelInforme
            Endif

            loConsumirAPI = NewConsumirAPI()

            loConsumirAPI.lGetAll 		= This.lGetAll
            loConsumirAPI.cReturnType 	= This.cReturnType
            loConsumirAPI.cTrace 		= This.cTrace
            loConsumirAPI.cRemark 		= This.cRemark

            loRespuesta = loConsumirAPI.Listar( cURL, oFilterCriteria, cAlias, lcTitulo, oBody )

            If loRespuesta.lOk
                This.nTotalDeRegistros 	= loRespuesta.Data.Count
                This.nCurrentPage 		= loRespuesta.Data.current_page
                This.cUrlNext 			= loRespuesta.Data.Next
                This.cUrlPrevious 		= loRespuesta.Data.Previous
                This.nLastPage 			= loRespuesta.Data.total_pages

                loReturn.oData 	= loRespuesta.Data.Results
                loReturn.nTally = loRespuesta.Data.Count
                loReturn.cAlias = cAlias
                loReturn.lOk 	= .T.
                
                If loReturn.nTally = 1
                	loReturn.oRegistro = loReturn.oData.Item( 1 ) 
                EndIf

                Select Alias( cAlias )
                *Browse

                If This.lValidate

                    loArchivo = This.GetTable()
                    loArchivo.lStr = .T.

                    TEXT To lcCommand NoShow TextMerge Pretext 15
                	Select *
                		From <<cAlias>>
                		Where .F.
                		Into Cursor "cDummy" ReadWrite
                    ENDTEXT

                    &lcCommand
                    lcCommand = ""

                    Select Alias( cAlias )

                    Locate
                    Scan

                        Scatter Memo Name loReg
                        loArchivo.ValidateData( loReg, "cDummy" )

                        Select Alias( cAlias )

                    Endscan

                    loReg = Null
                    loArchivo = Null

                    TEXT To lcCommand NoShow TextMerge Pretext 15
                	Select *
                		From "cDummy"
                		Into Cursor <<cAlias>> ReadWrite
                    ENDTEXT

                    &lcCommand
                    lcCommand = ""

                    Use In Select( "cDummy" )

                Endif

                Replace All _RecordOrder With Recno()
                CursorSetProp( "Buffering", This.nBuffering, cAlias )

            Else
                loReturn.lOk 	= .F.
                loReturn.nStatus 	= loRespuesta.nStatus

                This.ManejarErrores( loRespuesta )
                This.MostrarErrores()

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loRespuesta = Null

        Endtry

        Return loReturn

    Endproc && Listar

    *
    *
    Procedure Traer( cURL As String,;
            uValue As Variant,;
            cAlias As String,;
            oFilterCriteria As Collection ) As Object
        Local lcCommand As String
        Local loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg",;
            loReturn As Object,;
            loData As Object,;
            loColReg As Collection,;
            loRespuesta As Object

        Try

            lcCommand = ""

            loReturn = Createobject( "Empty" )
            AddProperty( loReturn, "nTally", 0 )
            AddProperty( loReturn, "oRegistro", Null )
            AddProperty( loReturn, "oData", Null )
            AddProperty( loReturn, "cAlias", "" )
            AddProperty( loReturn, "lOk", .F. )
            AddProperty( loReturn, "nStatus", _HTTP_200_OK )

            loConsumirAPI = NewConsumirAPI()

            loConsumirAPI.cTrace 		= This.cTrace
            loConsumirAPI.cRemark 		= This.cRemark

            loRespuesta = loConsumirAPI.Traer( cURL, uValue, oFilterCriteria )

            If loRespuesta.lOk
                loData 		= loRespuesta.Data
                loColReg 	= Createobject( "Collection" )

                AddProperty( loData, "r7Mov", " " )
                AddProperty( loData, "ABM", 0 )
                AddProperty( loData, "_RecordOrder", 1 )
                loColReg.Add( loData )
                loReturn.oRegistro = loData

                loReturn.nTally = 1
                loReturn.cAlias = cAlias
                loReturn.lOk 	= .T.

            Else
                loReturn.lOk 		= .F.
                loReturn.nStatus 	= loRespuesta.nStatus

                This.ManejarErrores( loRespuesta )
                This.MostrarErrores()

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loColReg = Null
            loData = Null
            loRespuesta = Null

        Endtry

        Return loReturn

    Endproc && Traer



    *
    * Trae una instancia del Modelo
    Procedure GetByPK( uId As Variant ) As Object
        Local lcCommand As String,;
            lcAlias As String
        Local loParam As Object,;
            loFiltro As Object,;
            loFiltros As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
            loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loReg As Object,;
            loRegValid As Object,;
            loReturn As Object

        Try

            lcCommand = ""

            loReturn = Createobject( "Empty" )
            AddProperty( loReturn, "nTally", 0 )
            AddProperty( loReturn, "oRegistro", Null )
            AddProperty( loReturn, "oData", Null )
            AddProperty( loReturn, "cAlias", "" )
            AddProperty( loReturn, "lOk", .F. )


            If Empty( uId )
                * Alta

                lcAlias = This.cMainCursorName
                loArchivo = This.GetTable()
                *loArchivo.lStr = This.lStr
                loArchivo.CrearCursor( lcAlias )

                Select Alias( lcAlias )

                TEXT To lcCommand NoShow TextMerge Pretext 15
				Select 	*,
						Space( 1 ) as r7Mov,
						Cast( ABM_ALTA as I ) as ABM,
						Cast( Recno() as I ) as _RecordOrder
					From <<lcAlias>>
					Into Cursor <<lcAlias>> ReadWrite
                ENDTEXT

                &lcCommand
                lcCommand = ""

                Scatter Memo Name loReg Blank

                loRegValid = loArchivo.SetDefaults( loReg, This )
                AddProperty( loRegValid, "r7Mov", " " )
                AddProperty( loRegValid, "ABM", ABM_ALTA )
                AddProperty( loRegValid, "_RecordOrder", 0 )

                Select Alias( lcAlias )
                Append Blank


                * RA 24/12/2021(11:06:42)
                *Gather Name loRegValid Memo && No Funiona :(

                lnLen = Afields( laFields, lcAlias )
                For i = 1 To lnLen

                    Try

                        lcField = laFields[ i, 1 ]

                        TEXT To lcCommand NoShow TextMerge Pretext 15
						Replace <<lcField>> With loRegValid.<<lcField>>
                        ENDTEXT

                        &lcCommand

                    Catch To oErr

                    Finally

                    Endtry

                    lcCommand = ""

                Endfor

                CursorSetProp( "Buffering", This.nBuffering, lcAlias )

                loReturn.nTally 	= 1
                loReturn.oRegistro 	= loRegValid
                loReturn.oData 		= Null
                loReturn.cAlias 	= lcAlias

            Else
                * Modificacion

                This.oCursores = Null
                This.oCursores = Createobject( "Collection" )


                loParam = Createobject( "Empty" )
                loFiltros = Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.Prg" )

                loFiltro = Createobject( "Empty" )
                AddProperty( loFiltro, "Nombre", "GetByPK" )
                AddProperty( loFiltro, "FieldName", Lower( This.cPKField ))
                AddProperty( loFiltro, "FieldRelation", "==" )
                AddProperty( loFiltro, "FieldValue", uId )

                loFiltros.AddItem( loFiltro, loFiltro.Nombre )

                AddProperty( loParam, "oFilterCriteria", loFiltros )

                loReturn = This.GetByWhere( loParam )

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return loReturn

    Endproc && GetByPK


    *
    * Repite la última consulta
    Procedure Requery( oParam As Object ) As Void;
            HELPSTRING "Repite la última consulta"
        Local lcCommand As String

        Local lnTally As Integer
        Local loReturn As Object

        Try

            lcCommand = ""
            If Vartype( oParam ) = "O"
                This.oRequery = oParam
            Endif

            loReturn 	= This.GetByWhere( This.oRequery )
            lnTally 	= loReturn.nTally

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry

        Return loReturn

    Endproc && Requery

    *
    * Devuelve un objeto Table
    Procedure GetTable( cTable As String ) As Object ;
            HELPSTRING "Devuelve un objeto Table"
        Local lcCommand As String

        Local loColDataBases As oColDataBases Of "Tools\DataDictionary\prg\oColDataBases.prg"
        Local loDataBase As oDataBase Of "Tools\DataDictionary\prg\oDataBase.prg"
        Local loColTables As ColTables Of "FW\TierAdapter\Comun\colTables.prg"
        Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            If Empty( cTable )
                cTable = This.cTabla
            Endif

            loArchivo = GetTable( cTable )


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loColTables 	= Null
            loDataBase 		= Null
            loColDataBases 	= Null

        Endtry

        Return loArchivo

    Endproc && GetTable

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
            loError.cRemark = lcCommand
            loError.Process( oErr )


        Finally
            If Used( lcOldAlias )
                Select Alias( lcOldAlias )
            Endif

        Endtry

        Return llValid

    Endproc && BeforeRowColChange


    *
    *
    Procedure Grabar( oRegistro As Object ) As Boolean
        Local lcCommand As String
        Local llOk As Boolean,;
            llBulk As Boolean
        Local loReg As Object
        Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg"
        Local lnABM As Integer

        *Private loReg As Object


        Try

            lcCommand = ""
            This.oColErrors = Null
            llOk = .F.
            lnABM = oRegistro.ABM
            This.nId = 0
            *Removeproperty( oRegistro, "ABM" )

            loReg = This.CleanReg( CloneObject( oRegistro ))

            loArchivo = This.GetTable()

            loArchivo.ExportData( loReg )
            oRegistro = Null

            This.nId = loReg.Id

            Do Case
                Case lnABM = ABM_ALTA
                    Removeproperty( loReg, "Id" )

                    If This.lFiltrarPorClientePraxis
                        If Empty( loReg.cliente_praxis )
                            loReg.cliente_praxis = This.nClientePraxis
                        Endif
                    Endif

                    loConsumirAPI 	= NewConsumirAPI()
                    loConsumirAPI.cTrace 		= This.cTrace
                    loConsumirAPI.cRemark 		= This.cRemark

                    loRespuesta 	= loConsumirAPI.Crear( This.cURL, loReg )

                    If loRespuesta.lOk
                        This.nId = loRespuesta.Data.Id

                    Else
                        This.ManejarErrores( loRespuesta )
                        This.nId = 0

                    Endif

                Case lnABM = ABM_MODIFICACION

                    luValue = Evaluate( "loReg." + loArchivo.cLookupField )

                    loConsumirAPI 	= NewConsumirAPI()
                    loConsumirAPI.cTrace 		= This.cTrace
                    loConsumirAPI.cRemark 		= This.cRemark

                    loRespuesta 	= loConsumirAPI.Modificar( This.cURL, luValue, loReg )

                    If loRespuesta.lOk

                    Else
                        This.ManejarErrores( loRespuesta )

                    Endif

                Case lnABM = ABM_BAJA

                    luValue = Evaluate( "loReg." + loArchivo.cLookupField )

                    loConsumirAPI 	= NewConsumirAPI()
                    loConsumirAPI.cTrace 		= This.cTrace
                    loConsumirAPI.cRemark 		= This.cRemark

                    loRespuesta 	= loConsumirAPI.Borrar( This.cURL, luValue )

                    If loRespuesta.lOk
                        This.nId = 0

                    Else
                        This.ManejarErrores( loRespuesta )

                    Endif

                Otherwise

            Endcase

            If Isnull( This.oColErrors )
                llOk = .T.

            Else
                This.MostrarErrores()

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loReg = Null
            loArchivo = Null
            oRegistro = Null

        Endtry

        Return llOk

    Endproc && Grabar



    *
    *
    Procedure CleanReg( oReg As Object ) As Object
        Local lcCommand As String,;
            lcPropertyName As String,;
            lcFieldName As String
        Local lnLen As Integer,;
            i As Integer
        Local loReg As Object
        Local llPasa As Boolean

        Try

            lcCommand = ""
            loReg = Createobject( "Empty" )

            Dimension laMember[1]
            lnLen = Amembers( laMember, oReg, 0 )

            For i = 1 To lnLen
                lcPropertyName = Lower( laMember[i] )
                llPasa = .F.

                Do Case
                    Case Inlist( lcPropertyName, "r7mov", "abm", "_recordorder" )
                        llPasa = .F.

                    Case Substr( lcPropertyName, 1, 4 ) = "str_"
                        llPasa = .F.

                    Otherwise
                        llPasa = .T.

                Endcase

                If llPasa

                    Try

                        If Lower( Substr( lcPropertyName, Len( lcPropertyName ) - Len( "_id" ) + 1 )) = "_id"
                            lcFieldName = Substr( lcPropertyName, 1, Len( lcPropertyName ) - Len( "_id" ))

                        Else
                            lcFieldName = lcPropertyName

                        Endif

                        AddProperty( loReg, lcFieldName, oReg.&lcPropertyName )

                    Catch To oErr

                    Finally

                    Endtry
                Endif

            Endfor

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            oReg = Null

        Endtry

        Return loReg

    Endproc && CleanReg


    *
    * Guarda varios registros, editados en un browse
    Procedure GuardarVarios( cTransitorio As String ) As Boolean ;
            HELPSTRING "Guarda varios registros, editados en un browse"
        Local lcCommand As String
        Local llOk As Boolean

        Try

            lcCommand = ""
            This.oColErrors = Null
            llOk = .F.

            This.Baja( cTransitorio )
            This.Modificacion( cTransitorio )
            This.Alta( cTransitorio )

            llOk = Isnull( This.oColErrors )

            If Isnull( This.oColErrors )
                llOk = .T.

            Else
                This.MostrarErrores()

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return llOk


    Endproc && GuardarVarios



    *
    *
    Procedure Baja( cTransitorio As String ) As Void
        Local lcCommand As String
        Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
        Local loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg"
        Local loRespuesta As Object
        Local luValue As Variant

        Try

            lcCommand = ""

            loArchivo = This.GetTable()

            Select Alias( cTransitorio )
            Locate

            Scan For !Empty( Id ) ;
                    And ( Evaluate( cTransitorio + ".ABM" ) = ABM_BAJA )

                luValue = Evaluate( cTransitorio + "." + loArchivo.cLookupField )

                loConsumirAPI 	= NewConsumirAPI()
                loConsumirAPI.cTrace 		= This.cTrace
                loConsumirAPI.cRemark 		= This.cRemark

                loRespuesta 	= loConsumirAPI.Borrar( This.cURL, luValue )

                If loRespuesta.lOk
                    Replace ABM With ABM_PROCESADO

                Else
                    This.ManejarErrores( loRespuesta, _RecordOrder )

                Endif

            Endscan


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loConsumirAPI 	= Null
            loArchivo 		= Null
            loRespuesta 	= Null
            loReg 			= Null

        Endtry

    Endproc && Baja



    *
    *
    Procedure Modificacion( cTransitorio As String ) As Void
        Local lcCommand As String,;
            lcUrl As String,;
            lcFieldList As String
        Local loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg"
        Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
        Local loRespuesta As Object,;
            loReg As Object,;
            loRegistros As Collection
        Local luValue As Variant
        Local llOk As Boolean

        Try

            lcCommand = ""
            llOk = .T.
            loArchivo = This.GetTable( )

            Select Alias( cTransitorio )
            Locate

            If This.lBulkUpdate

                loRegistros = Createobject( "Collection" )
                lcFieldList = This.GetBulkFieldList()

                Scan For !Empty( Id ) ;
                        And ( Evaluate( cTransitorio + ".ABM" ) = ABM_MODIFICACION )

                    *Scatter Memo Name loReg
                    TEXT To lcCommand NoShow TextMerge Pretext 15
                    Scatter Memo Name loReg Fields Like <<lcFieldList>>
                    ENDTEXT

                    &lcCommand
                    lcCommand = ""

                    *!*
                    *!*	                    *Removeproperty( loReg, "Id" )
                    *!*	                    Removeproperty( loReg, "r7Mov" )
                    *!*	                    Removeproperty( loReg, "ABM" )
                    *!*	                    Removeproperty( loReg, "_RecordOrder" )

                    loRegistros.Add( loReg )

                Endscan

                loConsumirAPI 	= NewConsumirAPI()
                loConsumirAPI.cTrace 		= This.cTrace
                loConsumirAPI.cRemark 		= This.cRemark

                *lcUrl = Left( This.cURL, Len( Alltrim( This.cURL )) - 1 ) + "Bulk/"
                lcUrl = This.cURL + "Bulk/"

                loRespuesta 	= loConsumirAPI.Bulk_Update( lcUrl, loRegistros )

                If !loRespuesta.lOk
                    This.ManejarErrores( loRespuesta, _RecordOrder )
                    llOk = .F.

                Endif


            Else
                Scan For !Empty( Id ) ;
                        And ( Evaluate( cTransitorio + ".ABM" ) = ABM_MODIFICACION )

                    Scatter Memo Name loReg
                    Removeproperty( loReg, "Id" )
                    Removeproperty( loReg, "r7Mov" )
                    Removeproperty( loReg, "ABM" )
                    Removeproperty( loReg, "_RecordOrder" )

                    luValue = Evaluate( cTransitorio + "." + loArchivo.cLookupField )

                    loConsumirAPI 	= NewConsumirAPI()
                    loConsumirAPI.cTrace 		= This.cTrace
                    loConsumirAPI.cRemark 		= This.cRemark

                    loRespuesta 	= loConsumirAPI.Modificar( This.cURL, luValue, loReg )

                    If loRespuesta.lOk
                        Replace ABM With ABM_PROCESADO

                    Else
                        This.ManejarErrores( loRespuesta, _RecordOrder )

                    Endif

                Endscan

            Endif


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loConsumirAPI 	= Null
            loArchivo 		= Null
            loRespuesta 	= Null
            loReg 			= Null

        Endtry

        Return llOk

    Endproc && Modificacion

    *
    * Devuelve la lista de campos a actualizar en actualizacion masiva
    Procedure GetBulkFieldList(  ) As String;
            HELPSTRING "Devuelve la lista de campos a actualizar en actualizacion masiva"
        Local lcCommand As String,;
            lcFieldList As String


        Try

            lcCommand = ""
            lcFieldList = This.cBulkFieldList


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return lcFieldList

    Endproc && GetBulkFieldList



    *
    *
    Procedure Alta( cTransitorio As String ) As Void
        Local lcCommand As String
        Local loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg"
        Local loRespuesta As Object,;
            loReg As Object

        Try

            lcCommand = ""

            Select Alias( cTransitorio )
            Locate

            Scan For Empty( Id ) ;
                    And !Inlist( Evaluate( cTransitorio + ".ABM" ), ABM_BAJA, ABM_PROCESADO )

                Scatter Memo Name loReg
                Removeproperty( loReg, "Id" )
                Removeproperty( loReg, "r7Mov" )
                Removeproperty( loReg, "ABM" )
                Removeproperty( loReg, "_RecordOrder" )

                loConsumirAPI 	= NewConsumirAPI()
                loConsumirAPI.cTrace 		= This.cTrace
                loConsumirAPI.cRemark 		= This.cRemark

                loRespuesta 	= loConsumirAPI.Crear( This.cURL, loReg )

                If loRespuesta.lOk
                    Replace ABM With ABM_PROCESADO

                Else
                    This.ManejarErrores( loRespuesta, _RecordOrder )

                Endif

            Endscan


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return .F. && llOk

    Endproc && Alta

    *
    *
    Procedure ManejarErrores( oErrores As Object, nItem As Integer ) As Void
        Local lcCommand As String,;
            lcPropertyName As String,;
            lcErrorMsg As String,;
            lcMsg As String
        Local lnLen As Integer,;
            i As Integer
        Local loColErrors As Collection,;
            loItem As Object,;
            loErrores As Object,;
            loRespuesta As Object,;
            loError as Object 

        Local llCollection As Boolean,;
            llDetail As Boolean,;
            llError As Boolean,;
            llType As Boolean,;
            llErrors As Boolean


        Dimension laErrores[1]

        Try

            lcCommand = ""

            loColErrors = This.oColErrors

            If Isnull( loColErrors )
                loColErrors = Createobject( "Collection" )
            Endif

            Do Case
                Case Pemstatus( oErrores, "Data", 5 )

                    llCollection = .F.
                    llDetail = Pemstatus( oErrores.Data, "Detail", 5 )
                    llError = Pemstatus( oErrores.Data, "Error", 5 )
                    llType  = Pemstatus( oErrores.Data, "Type", 5 )
                    llErrors = Pemstatus( oErrores.Data, "Errors", 5 )


                    If Pemstatus( oErrores.Data, "BaseClass", 5 )
                        llCollection = oErrores.Data.BaseClass = "Collection"
                    Endif

                    Do Case
                        Case llType And llErrors
                            * RA 25/02/2023(19:12:40)
                            * Version nueva de drf_standardized_errors.handler

                            * {
                            *     "type": "validation_error",
                            *     "errors": [
                            *         {
                            *             "code": "blank",
                            *             "detail": "Este campo no puede estar en blanco.",
                            *             "attr": "nombre"
                            *         },
                            *         {
                            *             "code": "required",
                            *             "detail": "Este campo es requerido.",
                            *             "attr": "cliente_praxis"
                            *         }
                            *     ]
                            * }

							loItem = Createobject( "Empty" )

							lcErrorMsg = oErrores.Data.Type
							 
                            TEXT To lcMsg NoShow TextMerge Pretext 03
							Tipo de Error: <<lcErrorMsg>>
                            ENDTEXT

                            AddProperty( loItem, "Msg", lcMsg )
                            loColErrors.Add( loItem )
                            
                            loItem = Createobject( "Empty" )
                            AddProperty( loItem, "Msg", "" )
                            loColErrors.Add( loItem )
                            
                            For Each loError in oErrores.Data.Errors
                            	If IsEmpty( loError.Attr )
		                            TEXT To lcMsg NoShow TextMerge Pretext 03
									<<loError.Detail>>
		                            ENDTEXT

                            	Else
		                            TEXT To lcMsg NoShow TextMerge Pretext 03
									<<loError.Attr>>: <<loError.Detail>>
		                            ENDTEXT

                            	Endif

								loItem = Createobject( "Empty" )
	                            AddProperty( loItem, "Msg", lcMsg )
	                            loColErrors.Add( loItem )
                            EndFor
                            
                            This.oColErrors = loColErrors

                        Case llCollection

                            * El campo Data es un objeto con los errores de validacion
                            * en los campos.
                            * El Nombre de la propiedad es el Nombre del Campo
                            * El contenido de la propiedad es el mensaje de error de validación

                            loRespuesta = oErrores.Data

                            For Each loCampo In loRespuesta

                                lnLen = Amembers( laErrores, loCampo )

                                For i = 1 To lnLen

                                    Try


                                        lcPropertyName = laErrores[ i ]
                                        loErrores = Evaluate( "loCampo." + lcPropertyName )

                                        loItem = Createobject( "Empty" )
                                        AddProperty( loItem, "Name", Lower( lcPropertyName ))

                                        Do Case
                                            Case Vartype( loErrores ) = "O"
                                                If loErrores.BaseClass = "Collection"

                                                    For Each lcErrorMsg In loErrores
                                                        If !Empty( nItem )
                                                            TEXT To lcMsg NoShow TextMerge Pretext 03
															<<nItem>>) <<lcPropertyName>>: <<lcErrorMsg>>
                                                            ENDTEXT

                                                        Else
                                                            TEXT To lcMsg NoShow TextMerge Pretext 03
															<<lcPropertyName>>: <<lcErrorMsg>>
                                                            ENDTEXT

                                                        Endif

                                                        AddProperty( loItem, "Msg", lcMsg )
                                                        loColErrors.Add( loItem, Lower( lcPropertyName ) )

                                                    Endfor
                                                Endif

                                            Case Vartype( loErrores ) = "C"
                                                lcErrorMsg = loErrores

                                                If !Empty( nItem )
                                                    TEXT To lcMsg NoShow TextMerge Pretext 03
												<<nItem>>) <<lcErrorMsg>>
                                                    ENDTEXT

                                                Else
                                                    TEXT To lcMsg NoShow TextMerge Pretext 03
												<<lcErrorMsg>>
                                                    ENDTEXT

                                                Endif

                                                AddProperty( loItem, "Msg", lcMsg )
                                                loColErrors.Add( loItem, Lower( lcPropertyName ) )

                                                *loColErrors.Add( lcMsg )

                                        Endcase


                                    Catch To oErr

                                    Finally

                                    Endtry


                                Endfor
                            Endfor

                            This.oColErrors = loColErrors

                        Case llDetail
                            * El error viene en el campo Detail
                            lcErrorMsg = oErrores.Data.Detail

                            If !Empty( nItem )
                                TEXT To lcMsg NoShow TextMerge Pretext 03
								<<nItem>>) <<lcErrorMsg>>
                                ENDTEXT

                            Else
                                TEXT To lcMsg NoShow TextMerge Pretext 03
								<<lcErrorMsg>>
                                ENDTEXT

                            Endif

                            loItem = Createobject( "Empty" )
                            AddProperty( loItem, "Msg", lcMsg )
                            loColErrors.Add( loItem )

                        Case llError
                            * Coleccion de errores en la Coleccion "Error"
                            loRespuesta = oErrores.Data.Error

                            For Each lcErrorMsg In loRespuesta
                                If Substr( lcErrorMsg, 1, 2 ) # "</"
                                    If !Empty( nItem )
                                        TEXT To lcMsg NoShow TextMerge Pretext 03
										<<nItem>>) <<lcErrorMsg>>
                                        ENDTEXT

                                    Else
                                        TEXT To lcMsg NoShow TextMerge Pretext 03
										<<lcErrorMsg>>
                                        ENDTEXT

                                    Endif

                                    loItem = Createobject( "Empty" )
                                    AddProperty( loItem, "Msg", lcMsg )
                                    loColErrors.Add( loItem )
                                Endif

                            Endfor


                        Otherwise
                            * El campo Data es un objeto con los errores de validacion
                            * en los campos.
                            * El Nombre de la propiedad es el Nombre del Campo
                            * El contenido de la propiedad es el mensaje de error de validación

                            loRespuesta = oErrores.Data

                            lnLen = Amembers( laErrores, loRespuesta )

                            For i = 1 To lnLen

                                Try


                                    lcPropertyName = laErrores[ i ]
                                    loErrores = Evaluate( "loRespuesta." + lcPropertyName )

                                    loItem = Createobject( "Empty" )
                                    AddProperty( loItem, "Name", Lower( lcPropertyName ))

                                    Do Case
                                        Case Vartype( loErrores ) = "O"
                                            If loErrores.BaseClass = "Collection"

                                                For Each lcErrorMsg In loErrores
                                                    If !Empty( nItem )
                                                        TEXT To lcMsg NoShow TextMerge Pretext 03
														<<nItem>>) <<lcPropertyName>>: <<lcErrorMsg>>
                                                        ENDTEXT

                                                    Else
                                                        TEXT To lcMsg NoShow TextMerge Pretext 03
														<<lcPropertyName>>: <<lcErrorMsg>>
                                                        ENDTEXT

                                                    Endif

                                                    AddProperty( loItem, "Msg", lcMsg )
                                                    loColErrors.Add( loItem, Lower( lcPropertyName ) )

                                                Endfor
                                            Endif

                                        Case Vartype( loErrores ) = "C"
                                            lcErrorMsg = loErrores

                                            If !Empty( nItem )
                                                TEXT To lcMsg NoShow TextMerge Pretext 03
												<<nItem>>) <<lcErrorMsg>>
                                                ENDTEXT

                                            Else
                                                TEXT To lcMsg NoShow TextMerge Pretext 03
												<<lcErrorMsg>>
                                                ENDTEXT

                                            Endif

                                            AddProperty( loItem, "Msg", lcMsg )
                                            loColErrors.Add( loItem, Lower( lcPropertyName ) )

                                            *loColErrors.Add( lcMsg )

                                    Endcase


                                Catch To oErr

                                Finally

                                Endtry


                            Endfor

                            This.oColErrors = loColErrors


                    Endcase

                    * Es un error devuelto por HTTPRequest
                Case Pemstatus( oErrores, "cErrorMessage", 5 )
                    loRespuesta = oErrores

                    TEXT To lcMsg NoShow TextMerge Pretext 03
					Status: <<loRespuesta.nStatus>>

					<<loRespuesta.cErrorMessage>>
                    ENDTEXT

                    loItem = Createobject( "Empty" )
                    AddProperty( loItem, "Msg", lcMsg )
                    loColErrors.Add( loItem )

                Otherwise
                    loRespuesta = oErrores

            Endcase

            This.oColErrors = loColErrors

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loColErrors = Null
            oErrores = Null
            vError = Null

        Endtry

    Endproc && ManejarErrores

    *
    *
    Procedure xxx___ManejarErrores( oErrores As Object, nItem As Integer ) As Void
        Local lcCommand As String,;
            lcPropertyName As String,;
            lcErrorMsg As String,;
            lcMsg As String
        Local lnLen As Integer,;
            i As Integer
        Local loColErrors As Collection,;
            loItem As Object,;
            loErrores As Object,;
            loRespuesta As Object

        Local llCollection As Boolean,;
            llDetail As Boolean,;
            llError As Boolean


        Dimension laErrores[1]

        Try

            lcCommand = ""

            loColErrors = This.oColErrors

            If Isnull( loColErrors )
                loColErrors = Createobject( "Collection" )
            Endif

            Do Case
                Case Pemstatus( oErrores, "Data", 5 )

                    llCollection = .F.
                    llDetail = Pemstatus( oErrores.Data, "Detail", 5 )
                    llError = Pemstatus( oErrores.Data, "Error", 5 )

                    If Pemstatus( oErrores.Data, "BaseClass", 5 )
                        llCollection = oErrores.Data.BaseClass = "Collection"
                    Endif

                    Do Case
                        Case llCollection

                            * El campo Data es un objeto con los errores de validacion
                            * en los campos.
                            * El Nombre de la propiedad es el Nombre del Campo
                            * El contenido de la propiedad es el mensaje de error de validación

                            loRespuesta = oErrores.Data

                            For Each loCampo In loRespuesta

                                lnLen = Amembers( laErrores, loCampo )

                                For i = 1 To lnLen

                                    Try


                                        lcPropertyName = laErrores[ i ]
                                        loErrores = Evaluate( "loCampo." + lcPropertyName )

                                        loItem = Createobject( "Empty" )
                                        AddProperty( loItem, "Name", Lower( lcPropertyName ))

                                        Do Case
                                            Case Vartype( loErrores ) = "O"
                                                If loErrores.BaseClass = "Collection"

                                                    For Each lcErrorMsg In loErrores
                                                        If !Empty( nItem )
                                                            TEXT To lcMsg NoShow TextMerge Pretext 03
														<<nItem>>) <<lcPropertyName>>: <<lcErrorMsg>>
                                                            ENDTEXT

                                                        Else
                                                            TEXT To lcMsg NoShow TextMerge Pretext 03
														<<lcPropertyName>>: <<lcErrorMsg>>
                                                            ENDTEXT

                                                        Endif

                                                        AddProperty( loItem, "Msg", lcMsg )
                                                        loColErrors.Add( loItem, Lower( lcPropertyName ) )

                                                    Endfor
                                                Endif

                                            Case Vartype( loErrores ) = "C"
                                                lcErrorMsg = loErrores

                                                If !Empty( nItem )
                                                    TEXT To lcMsg NoShow TextMerge Pretext 03
												<<nItem>>) <<lcErrorMsg>>
                                                    ENDTEXT

                                                Else
                                                    TEXT To lcMsg NoShow TextMerge Pretext 03
												<<lcErrorMsg>>
                                                    ENDTEXT

                                                Endif

                                                AddProperty( loItem, "Msg", lcMsg )
                                                loColErrors.Add( loItem, Lower( lcPropertyName ) )

                                                *loColErrors.Add( lcMsg )

                                        Endcase


                                    Catch To oErr

                                    Finally

                                    Endtry


                                Endfor
                            Endfor

                            This.oColErrors = loColErrors

                        Case llDetail
                            * El error viene en el campo Detail
                            lcErrorMsg = oErrores.Data.Detail

                            If !Empty( nItem )
                                TEXT To lcMsg NoShow TextMerge Pretext 03
								<<nItem>>) <<lcErrorMsg>>
                                ENDTEXT

                            Else
                                TEXT To lcMsg NoShow TextMerge Pretext 03
								<<lcErrorMsg>>
                                ENDTEXT

                            Endif

                            loItem = Createobject( "Empty" )
                            AddProperty( loItem, "Msg", lcMsg )
                            loColErrors.Add( loItem )

                        Case llError
                            * Coleccion de errores en la Coleccion "Error"
                            loRespuesta = oErrores.Data.Error

                            For Each lcErrorMsg In loRespuesta
                                If Substr( lcErrorMsg, 1, 2 ) # "</"
                                    If !Empty( nItem )
                                        TEXT To lcMsg NoShow TextMerge Pretext 03
										<<nItem>>) <<lcErrorMsg>>
                                        ENDTEXT

                                    Else
                                        TEXT To lcMsg NoShow TextMerge Pretext 03
										<<lcErrorMsg>>
                                        ENDTEXT

                                    Endif

                                    loItem = Createobject( "Empty" )
                                    AddProperty( loItem, "Msg", lcMsg )
                                    loColErrors.Add( loItem )
                                Endif

                            Endfor


                        Otherwise
                            * El campo Data es un objeto con los errores de validacion
                            * en los campos.
                            * El Nombre de la propiedad es el Nombre del Campo
                            * El contenido de la propiedad es el mensaje de error de validación

                            loRespuesta = oErrores.Data

                            lnLen = Amembers( laErrores, loRespuesta )

                            For i = 1 To lnLen

                                Try


                                    lcPropertyName = laErrores[ i ]
                                    loErrores = Evaluate( "loRespuesta." + lcPropertyName )

                                    loItem = Createobject( "Empty" )
                                    AddProperty( loItem, "Name", Lower( lcPropertyName ))

                                    Do Case
                                        Case Vartype( loErrores ) = "O"
                                            If loErrores.BaseClass = "Collection"

                                                For Each lcErrorMsg In loErrores
                                                    If !Empty( nItem )
                                                        TEXT To lcMsg NoShow TextMerge Pretext 03
														<<nItem>>) <<lcPropertyName>>: <<lcErrorMsg>>
                                                        ENDTEXT

                                                    Else
                                                        TEXT To lcMsg NoShow TextMerge Pretext 03
														<<lcPropertyName>>: <<lcErrorMsg>>
                                                        ENDTEXT

                                                    Endif

                                                    AddProperty( loItem, "Msg", lcMsg )
                                                    loColErrors.Add( loItem, Lower( lcPropertyName ) )

                                                Endfor
                                            Endif

                                        Case Vartype( loErrores ) = "C"
                                            lcErrorMsg = loErrores

                                            If !Empty( nItem )
                                                TEXT To lcMsg NoShow TextMerge Pretext 03
												<<nItem>>) <<lcErrorMsg>>
                                                ENDTEXT

                                            Else
                                                TEXT To lcMsg NoShow TextMerge Pretext 03
												<<lcErrorMsg>>
                                                ENDTEXT

                                            Endif

                                            AddProperty( loItem, "Msg", lcMsg )
                                            loColErrors.Add( loItem, Lower( lcPropertyName ) )

                                            *loColErrors.Add( lcMsg )

                                    Endcase


                                Catch To oErr

                                Finally

                                Endtry


                            Endfor

                            This.oColErrors = loColErrors


                    Endcase

                    * Es un error devuelto por HTTPRequest
                Case Pemstatus( oErrores, "cErrorMessage", 5 )
                    loRespuesta = oErrores

                    TEXT To lcMsg NoShow TextMerge Pretext 03
					Status: <<loRespuesta.nStatus>>

					<<loRespuesta.cErrorMessage>>
                    ENDTEXT

                    loItem = Createobject( "Empty" )
                    AddProperty( loItem, "Msg", lcMsg )
                    loColErrors.Add( loItem )

                Otherwise
                    loRespuesta = oErrores

            Endcase

            This.oColErrors = loColErrors

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loColErrors = Null
            oErrores = Null
            vError = Null

        Endtry

    Endproc && xxx___ManejarErrores

    *
    *
    Procedure MostrarErrores(  ) As Void
        Local lcCommand As String,;
            lcMsg As String,;
            lcMensajesDeError As String
        Local loColErrors As Collection,;
            loItem As Object,;
            loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
            loColHtmlErrors As oColHtmlErrors Of "Tools\ErrorHandler\prg\HtmlErrors.prg",;
            loError As Object

        Try

            lcCommand = ""
            lcMensajesDeError = ""
            loColErrors = This.oColErrors

            For Each loItem In loColErrors

                lcMensajesDeError = lcMensajesDeError + loItem.Msg + CRLF

            Endfor

            *lcMensajesDeError = Strtran( lcMensajesDeError, "&#x27;", ['] )

            loGlobalSettings = NewGlobalSettings()
            loColHtmlErrors = loGlobalSettings.oHtmlErrors
            For Each loError In loColHtmlErrors
                lcMensajesDeError = Strtran( lcMensajesDeError, loError.Html, loError.Char )
            Endfor

            Do Form ErrorMessage With lcMensajesDeError


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loError 			= Null
            loColHtmlErrors 	= Null
            loGlobalSettings 	= Null

        Endtry

    Endproc && MostrarErrores


    *
    * Valida el registro actual
    Procedure ValidarRegistro( cAlias As String ) As Boolean;
            HELPSTRING "Valida el registro actual"
        Local lcCommand As String,;
            lcErrMsg As String,;
            lcAlias As String

        Local llValid As Boolean

        Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
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

                loArchivo = This.GetTable()

                For Each loField In loArchivo.oColFields
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
                        Endif

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
            loError.cRemark = lcCommand

            Do While Vartype ( oErr.UserValue ) == 'O'
                oErr = oErr.UserValue
            Enddo

            loError.Process( oErr )
            Throw loError

        Finally
            loColErrorMessages = Null
            If Used( lcAlias )
                Select Alias( lcAlias )
            Endif

            loField = Null
            loArchivo = Null


        Endtry

        Return llValid

    Endproc && ValidarRegistro



    *
    *
    Procedure HookBeforeLaunch( oRegistro As Object ) As Object
        Local lcCommand As String

        Try

            lcCommand = ""


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return oRegistro

    Endproc && HookBeforeLaunch


    *
    * Llama al formulario para editar la entidad
    Procedure LaunchEditForm( oRegistro As Object ) As Boolean ;
            HELPSTRING "Llama al formulario para editar la entidad"
        Local lcCommand As String,;
            lcUrlNext As String,;
            lcUrlPrevious As String

        Local loStatus As Object,;
            loParam As Object,;
            loRegistro As Object

        Local lnTotalDeRegistros As Integer,;
            lnCurrentPage As Integer,;
            lnLastPage As Integer

        Local llReturn As Boolean

        Try

            lcCommand = ""
            loStatus = Null
            llReturn = .F.


            lnTotalDeRegistros = This.nTotalDeRegistros
            lnCurrentPage = This.nCurrentPage
            lcUrlNext = This.cUrlNext
            lcUrlPrevious = This.cUrlPrevious
            lnLastPage = This.nLastPage

            Inkey()

            loRegistro = This.HookBeforeLaunch( oRegistro )

            loParam = Createobject( "Empty" )
            AddProperty( loParam, "cModelo", This.cModelo )
            AddProperty( loParam, "oRegistro", loRegistro )
            AddProperty( loParam, "cABM", loRegistro.ABM )
            AddProperty( loParam, "uPK", Evaluate( "loRegistro." + This.cPKField ))
            AddProperty( loParam, "WCLAV", "A" )
            AddProperty( loParam, "oBiz", This )

            Do Form (This.cFormIndividual) With loParam To loStatus
            If Vartype( loStatus ) == "O"
                llReturn = ( loStatus.lCancelar = .F. )
            Endif

            If !llReturn
                This.nTotalDeRegistros = lnTotalDeRegistros
                This.nCurrentPage = lnCurrentPage
                This.cUrlNext = lcUrlNext
                This.cUrlPrevious = lcUrlPrevious
                This.nLastPage = lnLastPage
            Endif


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            If Vartype( loDF ) = "O"
                loDF.Release()
                loDF = Null
            Endif
            loRegistro = Null
            oRegistro = Null

        Endtry

        Return llReturn

    Endproc && LaunchEditForm

    *
    *
    * RA 09/10/2021(10:25:34)
    * Es llamada por GridInForm para agregar filtros iniciales.
    * Generalmente, el filtro por el padre de una tabla hija
    * Se sobreescribe en la clase para agregar filtros
    * Si no, la colección se devuelve vacía
    Procedure CargarFiltrosIniciales(  ) As Void
        Local lcCommand As String
        Local loFiltros As "CollectionBase" Of "Tools\Namespaces\Prg\CollectionBase.Prg"


        Try

            lcCommand = ""
            loFiltros = Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.Prg" )

            * Cada filtro debe tener la siguiente estructura

            *!*	loFilter = Createobject( "Empty" )
            *!*	AddProperty( loFilter, "Nombre", "Activos" )
            *!*	AddProperty( loFilter, "FieldName", "activo" )
            *!*	AddProperty( loFilter, "FieldRelation", "==" )
            *!*	AddProperty( loFilter, "FieldValue", "True" )


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return loFiltros

    Endproc && CargarFiltrosIniciales


    * Wclav_Assign
    Protected Procedure Wclav_Assign( uNewValue )

        This.Wclav = uNewValue

    Endproc && Wclav_Assign

    * oParent_Assign

    Protected Procedure cTrace_Assign( uNewValue )

        If Vartype( uNewValue ) # "C"
            uNewValue = ""
        Endif

        If !Empty( uNewValue )
            If !Empty( This.cTrace )
                uNewValue = "/" + CRLF + Space(25) + uNewValue
            Endif

        Endif

        This.cTrace = This.cTrace + uNewValue

    Endproc && oParent_Assign

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
    * cMainCursorName_Access
    Protected Procedure cMainCursorName_Access()

        If Empty( This.cMainCursorName )
            This.cMainCursorName = "c_" + This.Name + "_" + Sys( 2015 )
        Endif

        Return This.cMainCursorName

    Endproc && cMainCursorName_Access

    *
    * oParent_Access
    Protected Procedure oParent_Access()

        If This.lIsChild ;
                And Vartype( This.oParent ) # "O" ;
                And !Empty( This.cParent )

            This.oParent = GetEntity( This.cParent, .T. )

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
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( This.cURL )
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

        Endif

        Return This.cURL

    Endproc && cUrl_Access

    *
    * cModelo_Access
    Protected Procedure cModelo_Access()
        If Empty( This.cModelo )
            This.cModelo = This.Name
        Endif

        Return This.cModelo

    Endproc && cModelo_Access

    *
    * cTabla_Access
    Protected Procedure cTabla_Access()
        If Empty( This.cTabla )
            This.cTabla = This.cModelo
        Endif

        Return This.cTabla

    Endproc && cTabla_Access



    *
    * nClientePraxis_Access
    Protected Procedure nClientePraxis_Access()
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
            loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"
        Local lcCommand As String

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()

            If Empty( loGlobalSettings.nClientePraxis )
                loUser = NewUser()
                loGlobalSettings.nClientePraxis = loUser.nClientePraxis
            Endif

            This.nClientePraxis = loGlobalSettings.nClientePraxis

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loGlobalSettings = Null
            loUser = Null


        Endtry


        Return This.nClientePraxis

    Endproc && nClientePraxis_Access


    *
    * oSalidas_Access
    Protected Procedure oSalidas_Access()

        If Vartype( This.oSalidas ) # "O"
            Local loSalidas As Collection,;
                loSalida As Object

            loSalidas = Createobject( "Collection" )
            AddProperty( loSalidas, "Default", S_PANTALLA )

            loSalida = Createobject( "Empty" )
            AddProperty( loSalida, "Nombre", "Impresora" )
            AddProperty( loSalida, "Id", S_IMPRESORA )
            AddProperty( loSalida, "Activo", .T. )

            loSalidas.Add( loSalida, loSalida.Id )

            *!*	* -------------- Tipo de Salida -------------------------
            *!*	#Define S_IMPRESORA					'0'
            *!*	#Define S_VISTA_PREVIA				'1'
            *!*	#Define S_HOJA_DE_CALCULO			'2'
            *!*	#Define S_PANTALLA					'3'
            *!*	#Define S_PDF						'4'
            *!*	#Define S_CSV						'5'
            *!*	#Define S_SDF						'6'
            *!*	#Define S_IMPRESORA_PREDETERMINADA	'7'
            *!*	#Define S_TXT						'8'
            *!*	#Define S_MAIL						'9'
            *!*	#Define S_LISTADO_DOS				'99'

            loSalida = Createobject( "Empty" )
            AddProperty( loSalida, "Nombre", "Vista Previa" )
            AddProperty( loSalida, "Id", S_VISTA_PREVIA )
            AddProperty( loSalida, "Activo", .T. )

            loSalidas.Add( loSalida, loSalida.Id )

            loSalida = Createobject( "Empty" )
            AddProperty( loSalida, "Nombre", "Hoja de Cálculo" )
            AddProperty( loSalida, "Id", S_HOJA_DE_CALCULO )
            AddProperty( loSalida, "Activo", .T. )

            loSalidas.Add( loSalida, loSalida.Id )

            loSalida = Createobject( "Empty" )
            AddProperty( loSalida, "Nombre", "Pantalla" )
            AddProperty( loSalida, "Id", S_PANTALLA )
            AddProperty( loSalida, "Activo", .T. )

            loSalidas.Add( loSalida, loSalida.Id )

            loSalida = Createobject( "Empty" )
            AddProperty( loSalida, "Nombre", "Pdf" )
            AddProperty( loSalida, "Id", S_PDF )
            AddProperty( loSalida, "Activo", .T. )

            loSalidas.Add( loSalida, loSalida.Id )

            loSalida = Createobject( "Empty" )
            AddProperty( loSalida, "Nombre", "Archivo CSV" )
            AddProperty( loSalida, "Id", S_CSV )
            AddProperty( loSalida, "Activo", .F. )

            loSalidas.Add( loSalida, loSalida.Id )

            loSalida = Createobject( "Empty" )
            AddProperty( loSalida, "Nombre", "Archivo txt" )
            AddProperty( loSalida, "Id", S_TXT )
            AddProperty( loSalida, "Activo", .T. )

            loSalidas.Add( loSalida, loSalida.Id )

            loSalida = Createobject( "Empty" )
            AddProperty( loSalida, "Nombre", "Enviar por eMail" )
            AddProperty( loSalida, "Id", S_MAIL )
            AddProperty( loSalida, "Activo", .T. )

            loSalidas.Add( loSalida, loSalida.Id )

            *!*				loSalida = CreateObject( "Empty" )
            *!*				AddProperty( loSalida, "Nombre", "" )
            *!*				AddProperty( loSalida, "Id", "" )
            *!*				AddProperty( loSalida, "Activo", .T. )
            *!*
            *!*				loSalidas.Add( loSalida, loSalida.Id )

            *!*				loSalida = CreateObject( "Empty" )
            *!*				AddProperty( loSalida, "Nombre", "" )
            *!*				AddProperty( loSalida, "Id", "" )
            *!*				AddProperty( loSalida, "Activo", .T. )
            *!*
            *!*				loSalidas.Add( loSalida, loSalida.Id )

            This.oSalidas = loSalidas


        Endif

        Return This.oSalidas

    Endproc && oSalidas_Access



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oModelo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oModelo_Afip
*!* Description...:
*!* Date..........: Viernes 17 de Septiembre de 2021 (16:11:02)
*!*
*!*

Define Class oModelo_Afip As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oModelo_Afip Of "FrontEnd\Prg\Modelo.prg"
    #Endif

    *!*	loFE.ExportarTabla( "comprobantes" )
    *!*	loFE.ExportarTabla( "conceptos" )
    *!*	loFE.ExportarTabla( "documentos" )
    *!*	loFE.ExportarTabla( "ivas" )
    *!*	loFE.ExportarTabla( "monedas" )
    *!*	loFE.ExportarTabla( "opcionales" )
    *!*	loFE.ExportarTabla( "tributos" )
    cTablaAfip = ""

    lCreateInBrowse 	= .T.
    lEditInBrowse 		= .F.
    lShowEditInBrowse 	= .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="ctablaafip" type="property" display="cTablaAfip" />] + ;
        [<memberdata name="sincronizarconafip" type="method" display="SincronizarConAfip" />] + ;
        [</VFPData>]


    *
    *
    Procedure SincronizarConAfip(  ) As Void
        Local lcCommand As String,;
            lcAlias As String
        Local loFE As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg",;
            loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""
            loFE = Newobject( "prxWSFEv1", "Tools\FE\Prg\prxWSFEv1.prg" )

            This.GetByWhere()

            CursorSetProp( "Buffering", 1, This.cMainCursorName )


            * RA 17/09/2021(16:11:56)
            * Leer la configuración de ar0Fel.dbf
            loFE.nModo          = FE_PRUEBA 	&& FE_PRUEBA / FE_PRODUCCION
            loFE.cCuitEmisor 	= "20119883610"
            *!*	            loFE.cCertificado 	= "s:\Fe\praxis_2020.pfx"
            loFE.cCertificado 	= "s:\Fe\Fenix_2022.pfx"
            loFE.cLicencia 		= ""
            loFE.nPuntoDeVenta 	= 9

            If loFE.Preparada()
                lcAlias = loFE.GetTabla( This.cTablaAfip )
                loArchivo = This.GetTable( This.cTabla )

                Select Alias( lcAlias )

                Locate
                Scan

                    Select Alias( This.cMainCursorName )

                    Do Case
                        Case Vartype( codigo_afip ) = "N"
                            Locate For codigo_afip = Cast( Evaluate( lcAlias + ".Id" ) As i )

                        Otherwise
                            lcCodigo = Alltrim( Evaluate( lcAlias + ".Id" ))
                            Locate For codigo_afip == lcCodigo

                    Endcase

                    If !Found()
                        loRegAux = ScatterReg( .T., This.cMainCursorName )
                        loReg = loArchivo.SetDefaults( loRegAux, This )

                        If Vartype( loReg.codigo_afip ) = "N"
                            loReg.codigo_afip = Cast( Evaluate( lcAlias + ".Id" ) As i )

                        Else
                            loReg.codigo_afip = lcCodigo

                        Endif

                        loReg.Nombre = Evaluate( lcAlias + ".Descripcion" )


                        *!*	                        loReg.Orden = 500
                        *!*	                        loReg.Activo = .T.
                        *!*	                        loReg.cliente_praxis = This.nClientePraxis

                        *!*	                        loReg.Orden = loReg.Orden
                        *!*	                        loReg.Activo = loReg.Activo
                        *!*	                        loReg.cliente_praxis = loReg.cliente_praxis

                        Append Blank

                        *Gather Name loReg Memo
                        GatherRec( loReg )

                    Endif

                    Select Alias( lcAlias )

                Endscan

                Select Alias( This.cMainCursorName )

            Endif

            TEXT To lcCommand NoShow TextMerge Pretext 15
			Select 	*
				From (
					Select 	*
						From <<This.cMainCursorName>>
						Order By Orden,codigo_afip ) q
				Into Cursor <<This.cMainCursorName>> ReadWrite
            ENDTEXT

            &lcCommand
            lcCommand = ""

            lnTally = _Tally

            TEXT To lcCommand NoShow TextMerge Pretext 15
			Update <<This.cMainCursorName>> Set
				_RecordOrder = Recno(),
				ABM = Iif( Empty( Id ), 0, ABM_ALTA )
            ENDTEXT

            &lcCommand
            lcCommand = ""

            *Browse

            CursorSetProp( "Buffering", This.nBuffering, This.cMainCursorName )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return lnTally

    Endproc && SincronizarConAfip


    *
    * Repite la última consulta
    Procedure xxx___Requery( oParam As Object ) As Void;
            HELPSTRING "Repite la última consulta"
        Local lcCommand As String

        Local lnTally As Integer
        Local loReturn As Object,;
            loFiltros As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg

        Try

            lcCommand = ""
            If Vartype( oParam ) = "O"
                This.oRequery = oParam
            Endif

            * RA 02/02/2023(11:35:48)
            * Forzar que las tablas de Afip no se vean afectadas
            * por el page_size global

            loFiltro = Createobject( "Empty" )
            AddProperty( loFiltro, "Nombre", "SetPageSize" )
            AddProperty( loFiltro, "FieldName", "current_size" )
            AddProperty( loFiltro, "FieldRelation", "=" )
            AddProperty( loFiltro, "FieldValue", Transform( 1000 ) )

            This.AddFilter( loFiltro )

            If Vartype( This.oRequery ) == "O"
                If Pemstatus( This.oRequery, "oFilterCriteria", 5 )
                    loFiltros = This.oRequery.oFilterCriteria
                    loFiltros.RemoveItem( loFiltro.Nombre )
                    loFiltros.AddItem( loFiltro, Lower( loFiltro.Nombre ))

                Endif
            Endif

            loReturn 	= This.GetByWhere( This.oRequery )
            lnTally 	= loReturn.nTally

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loFiltro = Null


        Endtry

        Return loReturn

    Endproc && Requery

    *
    *
    Procedure HookFilterCriteria( oFilterCriteria As Collection ) As Collection
        Local lcCommand As String
        Local loFiltros As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
            loFiltro As Object

        Try

            lcCommand = ""

            * RA 02/02/2023(11:35:48)
            * Forzar que las tablas de Afip no se vean afectadas
            * por el page_size global


            If Isnull( oFilterCriteria )
                oFilterCriteria = Createobject( "Collection" )
            Endif

            loFiltro = Createobject( "Empty" )
            AddProperty( loFiltro, "Nombre", "SetPageSize" )
            AddProperty( loFiltro, "FieldName", "current_size" )
            AddProperty( loFiltro, "FieldRelation", "=" )
            AddProperty( loFiltro, "FieldValue", Transform( 1000 ) )

            *loFiltros = oFilterCriteria
            oFilterCriteria.RemoveItem( loFiltro.Nombre )
            oFilterCriteria.AddItem( loFiltro, Lower( loFiltro.Nombre ))


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loFiltro = Null

        Endtry

        Return oFilterCriteria

    Endproc && HookFilterCriteria


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oModelo_Afip
*!*
*!* ///////////////////////////////////////////////////////



