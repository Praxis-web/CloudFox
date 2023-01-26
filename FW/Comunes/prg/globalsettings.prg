*!* ///////////////////////////////////////////////////////
*!* Class.........: utGlobalSettings
*!* ParentClass...: utArchivos
*!* Date..........: Viernes 18 de Julio de 2008 (11:30:01)
*!* Author........: Danny Amerikaner
*!* Project.......: Sistemas praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#INCLUDE "FW\TierAdapter\Include\TA.h"
#INCLUDE "FW\Comunes\Include\Praxis.h"


* Define Class GlobalSettings As PrxSession Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"
Define Class GlobalSettings As PrxCustom Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"

    #If .F.
        Local This As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
    #Endif

    DataSession = SET_DEFAULT

    *!* Referencia al objeto BackEndSettings
    oBackEndSettings = Null

    *!* Referencia al objeto Application
    oApp = Null

    *!* Referencia al Usuario
    oUser = Null

    *!* Id de la Empresa Activa
    nEmpresaActiva = 0

    * Id del Ejercicio Activo para la Empresa Activa
    nEjercicioActivo = 0

    *!*
    dPrimerFechaValida = {}

    *!*
    dUltimaFechaValida = {}

    *!* Id de la Cuenta de Resultados
    nCuentaDeResultadosId = 0

    *!* Id del Asiento Tipo de Apertura
    nAsientoTipoApertura = 0

    *!* Id del Asiento Tipo de Cierre de Resultados
    nAsientoTipoCierreResultados = 0

    *!* Id del Asiento Tipo de Cierre Patrimonial
    nAsientoTipoCierrePatrimonial = 0

    *!* Nombre del archivo de configuración
    cObjectFactoryFileName = ""

    *!*
    nUpdateFontSize = 0

    *!* Descripción de la Empresa Activa
    cDescripcionEmpresaActiva = ""

    cApplicationName = ""

    * Lista de bases de datos instanciadas
    cDataBases = ""

    * Lista de las entidades instanciadas
    cEntitiesConfig = ""

    *!*
    nEmpresaSucursalActiva = 0

    *!*
    oHasar = Null

    * Puerto COM donde se conecta el controlador fiscal
    nHasarCOM = 1

    * Referencia a la clase Mercado Libre
    oMeLi = Null

    *!*
    oFE = Null

    *!*
    oWsPadron = Null

    *
    oFeX = Null

    * Referencia a la clase IIBB
    oIIBB = Null

    * Colección de monedas
    oMonedas = Null

    * Alícuota Iva Normal
    nIvaNormal  = 0

    * Alícuota Iva Reducido
    nIvaReducido = 0

    * Alícuota Iva Diferenciado
    nIvaDiferenciado = 0

    * Impresora Predeterminada
    cDefaultPrinter = ""

    * Referencia a la clase que maneja Artículo
    oArticulo = Null

    * Referencia a la clase que maneja Stock
    oStock = Null

    * Referencia a la clase que maneja Estadísticas
    oEstadisticas = Null

    * Referencia a la clase que maneja Pedidos
    oPedidos = Null

    * Referencia a la clase que maneja Pedidos de Proveedores
    oPedidosProveedores = Null

    * Referencia a la clase que maneja Presupuestos
    oPresupuestos = Null

    * Referencia a la clase que maneja Deudores
    oDeudores = Null

    * Referencia a la clase que maneja Contabilidad
    oContable = Null

    * Referencia a la clase que maneja Caja
    oCaja = Null

    * Referencia a la clase que maneja Grabar Novedades
    * (Utilizada para consumir las APIs)
    oGrabarNovedades = Null
    oConsumirAPI = Null
    oConsumirAPI_ML = Null

    * Coleccion de filtros a aplicar a cada tabla en M_File()
    oColFilters = Null

    * Contiene los Id de los impuestos de la AFIP relacionados con el IVA
    cImpuestosIVA = ""


    * Tipos de Documentos válidos por AFIP
    oColTiposDocumento = Null

    * Colección de Unidades para el Nomenclador del COT
    oColCOT_Unidades = Null

    * Momento en que modifica FECHAHOY
    * Sirve para actualizar FECHAHOY cada x tiempo.
    * Lo hace en M_File()
    tFechaHoyChange = Datetime()

    * Id del Cliente Praxis activo
    nClientePraxis = 0

    * Colección de Entidades
    oColEntities = Null

    * Coleccion de strings que devuelve un error en HTML y su traducción a ASCII
    oHtmlErrors = Null


    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="obackendsettings" type="property" display="oBackEndSettings" />] + ;
        [<memberdata name="nhasarcom" type="property" display="nHasarCOM" />] + ;
        [<memberdata name="ohasar" type="property" display="oHasar" />] + ;
        [<memberdata name="ofe" type="property" display="oFE" />] + ;
        [<memberdata name="owspadron" type="property" display="oWsPadron" />] + ;
        [<memberdata name="ofex" type="property" display="oFeX" />] + ;
        [<memberdata name="nempresasucursalactiva" type="property" display="nEmpresaSucursalActiva" />] + ;
        [<memberdata name="nempresasucursalactiva_access" type="method" display="nEmpresaSucursalActiva_Access" />] + ;
        [<memberdata name="cdatabases" type="property" display="cDataBases" />] + ;
        [<memberdata name="centitiesconfig" type="property" display="cEntitiesConfig" />] + ;
        [<memberdata name="ouser" type="property" display="oUser" />] + ;
        [<memberdata name="ouser_access" type="method" display="oUser_Access" />] + ;
        [<memberdata name="oapp" type="property" display="oApp" />] + ;
        [<memberdata name="cobjectfactoryfilename" type="property" display="cObjectFactoryFileName" />] + ;
        [<memberdata name="oapp_access" type="method" display="oApp_Access" />] + ;
        [<memberdata name="nempresaactiva" type="property" display="nEmpresaActiva" />] + ;
        [<memberdata name="nempresaactiva_access" type="method" display="nEmpresaActiva_Access" />] + ;
        [<memberdata name="nempresaactiva_assign" type="method" display="nEmpresaActiva_Assign" />] + ;
        [<memberdata name="ncuentaderesultadosid" type="property" display="nCuentaDeResultadosId" />] + ;
        [<memberdata name="ncuentaderesultadosid_access" type="method" display="nCuentaDeResultadosId_Access" />] + ;
        [<memberdata name="dprimerfechavalida" type="property" display="dPrimerFechaValida" />] + ;
        [<memberdata name="dultimafechavalida" type="property" display="dUltimaFechaValida" />] + ;
        [<memberdata name="nasientotipoapertura" type="property" display="nAsientoTipoApertura" />] + ;
        [<memberdata name="nasientotipoapertura_access" type="method" display="nAsientoTipoApertura_Access" />] + ;
        [<memberdata name="nasientotipocierreresultados" type="property" display="nAsientoTipoCierreResultados" />] + ;
        [<memberdata name="nasientotipocierreresultados_access" type="method" display="nAsientoTipoCierreResultados_Access" />] + ;
        [<memberdata name="nasientotipocierrepatrimonial" type="property" display="nAsientoTipoCierrePatrimonial" />] + ;
        [<memberdata name="nasientotipocierrepatrimonial_access" type="method" display="nAsientoTipoCierrePatrimonial_Access" />] + ;
        [<memberdata name="nupdatefontsize" type="property" display="nUpdateFontSize" />] + ;
        [<memberdata name="nupdatefontsize_access" type="method" display="nUpdateFontSize_Access" />] + ;
        [<memberdata name="nupdatefontsize_assign" type="method" display="nUpdateFontSize_Assign" />] + ;
        [<memberdata name="cdescripcionempresaactiva" type="property" display="cDescripcionEmpresaActiva" />] + ;
        [<memberdata name="cdescripcionempresaactiva_access" type="method" display="cDescripcionEmpresaActiva_Access" />] + ;
        [<memberdata name="omonedas" type="property" display="oMonedas" />] + ;
        [<memberdata name="omonedas_access" type="method" display="oMonedas_Access" />] + ;
        [<memberdata name="oarticulo" type="property" display="oArticulo" />] + ;
        [<memberdata name="ostock" type="property" display="oStock" />] + ;
        [<memberdata name="oestadisticas" type="property" display="oEstadisticas" />] + ;
        [<memberdata name="opedidos" type="property" display="oPedidos" />] + ;
        [<memberdata name="opedidosproveedores" type="property" display="oPedidosProveedores" />] + ;
        [<memberdata name="opresupuestos" type="property" display="oPresupuestos" />] + ;
        [<memberdata name="odeudores" type="property" display="oDeudores" />] + ;
        [<memberdata name="ocontable" type="property" display="oContable" />] + ;
        [<memberdata name="ocaja" type="property" display="oCaja" />] + ;
        [<memberdata name="ograbarnovedades" type="property" display="oGrabarNovedades" />] + ;
        [<memberdata name="oconsumirapi" type="property" display="oConsumirAPI" />] + ;
        [<memberdata name="nivanormal" type="property" display="nIvaNormal " />] + ;
        [<memberdata name="nivanormal_access" type="method" display="nIvaNormal _Access" />] + ;
        [<memberdata name="nivareducido" type="property" display="nIvaReducido" />] + ;
        [<memberdata name="nivareducido_access" type="method" display="nIvaReducido_Access" />] + ;
        [<memberdata name="nivadiferenciado" type="property" display="nIvaDiferenciado" />] + ;
        [<memberdata name="nivadiferenciado_access" type="method" display="nIvaDiferenciado_Access" />] + ;
        [<memberdata name="instanciateentity" type="method" display="InstanciateEntity" />] + ;
        [<memberdata name="cdefaultprinter" type="property" display="cDefaultPrinter" />] + ;
        [<memberdata name="cdefaultprinter_access" type="method" display="cDefaultPrinter_Access" />] + ;
        [<memberdata name="nejercicioactivo" type="property" display="nEjercicioActivo" />] + ;
        [<memberdata name="nejercicioactivo_access" type="method" display="nEjercicioActivo_Access" />] + ;
        [<memberdata name="ocolfilters" type="property" display="oColFilters" />] + ;
        [<memberdata name="ocolfilters_access" type="method" display="oColFilters_Access" />] + ;
        [<memberdata name="cimpuestosiva" type="property" display="cImpuestosIVA" />] + ;
        [<memberdata name="ocoltiposdocumento" type="property" display="oColTiposDocumento" />] + ;
        [<memberdata name="ocolcot_unidades" type="property" display="oColCOT_Unidades" />] + ;
        [<memberdata name="tfechahoychange" type="property" display="tFechaHoyChange" />] + ;
        [<memberdata name="omeli" type="property" display="oMeLi" />] + ;
        [<memberdata name="nclientepraxis" type="property" display="nClientePraxis" />] + ;
        [<memberdata name="nclientepraxis_access" type="method" display="nClientePraxis_Access" />] + ;
        [<memberdata name="ocolentities" type="property" display="oColEntities" />] + ;
        [<memberdata name="ohtmlerrors" type="property" display="oHtmlErrors" />] + ;
        [<memberdata name="ohtmlerrors_access" type="method" display="oHtmlErrors_Access" />] + ;
        [</VFPData>]


    Function Init()
        If ! Pemstatus( _Screen, "oGlobalSettings", 5 )
            AddProperty( _Screen, "oGlobalSettings", This )

        Endif
        Return This.lIsOk

    Endfunc && Init()



    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: nAsientoTipoApertura_Access
    *!* Date..........: Jueves 23 de Abril de 2009 (11:05:01)
    *!* Author........: Danny Amerikaner
    *!* Project.......: Sistemas praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure nAsientoTipoApertura_Access()
        Local loParametro As Object
        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
        Local lcSQLCommand As String
        Try

            If Empty( This.nAsientoTipoApertura )
                loParametro = This.InstanciateEntity("ParametroContable")
                TEXT To lcSQLCommand NoShow TextMerge Pretext 15
                   Select AsientoTipoAperturaId
                   From ParametroContable
                ENDTEXT
                loParametro.SQLExecute( lcSQLCommand, "cParametroContable" )
                This.nAsientoTipoApertura = cParametroContable.AsientoTipoAperturaId
            Endif

        Catch To oErr
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError
        Finally
            If Used( "cParametroContable" )
                Use In cParametroContable
            Endif
            loParametro = Null
            loError = Null
        Endtry

        Return This.nAsientoTipoApertura

    Endproc && nAsientoTipoApertura_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: nAsientoTipoCierreResultados_Access
    *!* Date..........: Jueves 23 de Abril de 2009 (11:07:55)
    *!* Author........: Danny Amerikaner
    *!* Project.......: Sistemas praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure nAsientoTipoCierreResultados_Access()
        Local loParametro As Object
        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
        Local lcSQLCommand As String
        Try

            If Empty( This.nAsientoTipoCierreResultados )
                loParametro = This.InstanciateEntity("ParametroContable")
                TEXT To lcSQLCommand NoShow TextMerge Pretext 15
                   Select AsientoTipoCierreResultadosId
                   From ParametroContable
                ENDTEXT
                loParametro.SQLExecute( lcSQLCommand, "cParametroContable" )
                This.nAsientoTipoCierreResultados = cParametroContable.AsientoTipoCierreResultadosId
            Endif

        Catch To oErr
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError
        Finally
            If Used( "cParametroContable" )
                Use In cParametroContable
            Endif
            loParametro = Null
            loError = Null
        Endtry

        Return This.nAsientoTipoCierreResultados

    Endproc && nAsientoTipoCierreResultados_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: nAsientoTipoCierrePatrimonial_Access
    *!* Date..........: Jueves 23 de Abril de 2009 (11:09:42)
    *!* Author........: Danny Amerikaner
    *!* Project.......: Sistemas praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure nAsientoTipoCierrePatrimonial_Access()
        Local loParametro As Object
        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
        Local lcSQLCommand As String
        Try

            If Empty( This.nAsientoTipoCierrePatrimonial )
                loParametro = This.InstanciateEntity("ParametroContable")
                TEXT To lcSQLCommand NoShow TextMerge Pretext 15
                   Select AsientoTipoCierrePatrimonialId
                   From ParametroContable
                ENDTEXT
                loParametro.SQLExecute( lcSQLCommand, "cParametroContable" )
                This.nAsientoTipoCierrePatrimonial = cParametroContable.AsientoTipoCierrePatrimonialId
            Endif

        Catch To oErr
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError
        Finally
            If Used( "cParametroContable" )
                Use In cParametroContable
            Endif
            loParametro = Null
            loError = Null
        Endtry


        Return This.nAsientoTipoCierrePatrimonial

    Endproc && nAsientoTipoCierrePatrimonial_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: nEmpresaActiva_Access
    *!* Date..........: Martes 17 de Marzo de 2009 (11:12:59)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure nEmpresaActiva_Access()
        Local loEmpresa As oEmpresa Of "Clientes\Archivos2\Prg\Empresas.prg"
        Local loRegistro As Object

        Local lcCommand As String

        Try

            lcCommand = ""


            If Empty( This.nEmpresaActiva )
                This.nEmpresaActiva = This.oApp.oUser.nEmpresaActivaId
            Endif

            *!*				If Empty( This.nEmpresaActiva )
            *!*					lcClassLib = "Clientes\Archivos2\Prg\Empresas.prg"
            *!*					loEmpresa 			= Newobject( "oEmpresa", lcClassLib )
            *!*					loRegistro 			= loEmpresa.GetDefault()
            *!*					This.nEmpresaActiva = loRegistro.Id
            *!*				Endif

            If Empty( This.nEmpresaActiva )
                This.nEmpresaActiva = 1
            Endif

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cRemark = lcCommand
            loError.Process( oErr )
            Throw loError

        Finally
            loEmpresa 	= Null
            loRegistro 	= Null

        Endtry

        Return This.nEmpresaActiva

    Endproc && nEmpresaActiva_Access


    * nEmpresaActiva_Assign

    Protected Procedure nEmpresaActiva_Assign( uNewValue )

        This.nEmpresaActiva 	= uNewValue

        This.nEjercicioActivo 	= 0
        =This.nEjercicioActivo

    Endproc && nEmpresaActiva_Assign

    *
    * nEjercicioActivo_Access
    Protected Procedure nEjercicioActivo_Access()
        Local loEjercicio As oEjercicio Of "Clientes\Contabilidad\Prg\Ejercicios.prg"
        Local loRegistro As Object

        Local lcCommand As String,;
            lcLibreria As String

        Try

            lcCommand = ""

            If Empty( This.nEjercicioActivo )
                If This.nEmpresaActiva = This.oApp.oUser.nEmpresaActivaId
                    This.nEjercicioActivo 	= This.oApp.oUser.nEjercicioActivoId
                Endif
            Endif

            *!*				If Empty( This.nEjercicioActivo )
            *!*					* RA 2014-03-08(11:19:24)
            *!*					* Para que no sea llamado por el compilador en todos los modulos
            *!*					lcLibreria 				= "Clientes\Contabilidad\Prg\Ejercicios.prg"

            *!*					loEjercicio 			= Newobject( "oEjercicio", lcLibreria )
            *!*					loRegistro 				= loEjercicio.GetDefault( This.nEmpresaActiva )
            *!*					This.nEjercicioActivo 	= loRegistro.Id
            *!*				Endif

            If Empty( This.nEjercicioActivo )
                This.nEjercicioActivo 	= 1
            Endif

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cRemark = lcCommand
            loError.Process( oErr )
            Throw loError

        Finally
            loEjercicio 	= Null
            loRegistro 	= Null

        Endtry

        Return This.nEjercicioActivo

    Endproc && nEjercicioActivo_Access



    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: nEmpresaSucursalActiva_Access
    *!* Date..........: Martes 8 de Septiembre de 2009 (18:39:29)
    *!* Author........: Damian Eiff
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure nEmpresaSucursalActiva_Access()

        This.nEmpresaSucursalActiva = This.oApp.oUser.nEmpresaSucursalActivaId

        Return This.nEmpresaSucursalActiva

    Endproc && nEmpresaSucursalActiva_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: nCuentaDeResultadosId_Access
    *!* Date..........: Martes 21 de Abril de 2009 (12:33:59)
    *!* Author........: Danny Amerikaner
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure nCuentaDeResultadosId_Access()
        Local loParametro As Object
        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
        Local lcSQLCommand As String
        Try

            If Empty( This.nCuentaDeResultadosId )
                loParametro = This.InstanciateEntity("ParametroContable")
                TEXT To lcSQLCommand NoShow TextMerge Pretext 15
                   Select CuentaImputableId
                   From ParametroContable
                ENDTEXT
                loParametro.SQLExecute( lcSQLCommand, "cParametroContable" )
                This.nCuentaDeResultadosId = cParametroContable.CuentaImputableId
            Endif

        Catch To oErr
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError
        Finally
            If Used( "cParametroContable" )
                Use In cParametroContable
            Endif
            loParametro = Null
            loError = Null
        Endtry
        Return This.nCuentaDeResultadosId

    Endproc && nCuentaDeResultadosId_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: dPrimerFechaValida_Access
    *!* Date..........: Martes 17 de Marzo de 2009 (11:12:59)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure dPrimerFechaValida_Access()

        If Empty( This.oApp.dPrimerFechaValida )
            This.oApp.dPrimerFechaValida = {^1900-01-01}
        Endif

        This.dPrimerFechaValida = This.oApp.dPrimerFechaValida

        Return This.dPrimerFechaValida

    Endproc && dPrimerFechaValida_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: dUltimaFechaValida_Access
    *!* Date..........: Martes 17 de Marzo de 2009 (11:12:59)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure dUltimaFechaValida_Access()

        If Empty( This.oApp.dUltimaFechaValida )
            This.oApp.dUltimaFechaValida = Date()
        Endif

        This.dUltimaFechaValida = This.oApp.dUltimaFechaValida

        Return This.dUltimaFechaValida

    Endproc && dUltimaFechaValida_Access

    *
    * oApp_Access
    Protected Procedure oApp_Access() As Object
        With This As GlobalSettings Of fw\comunes\prg\GlobalSettings.prg
            If Vartype( .oApp ) # "O"
                If Pemstatus( _Screen, "oApp", 5 ) And Vartype( _Screen.oApp ) == "O"
                    .oApp = _Screen.oApp

                Else
                    .oApp = Createobject( "oTestApp", "", "v.2" )

                Endif
            Endif
        Endwith
        Return This.oApp
    Endproc && oApp_Access


    *
    * oUser_Access
    Protected Procedure oUser_Access()
        This.oUser = This.oApp.oUser
        Return This.oUser
    Endproc && oUser_Access

    *
    * oEntitiesConfig_Access
    Protected Procedure oEntitiesConfig_Access()

        * Aquí se guarda el Singleton
        Return This.oEntitiesConfig

    Endproc && oEntitiesConfig_Access



    *
    * oDataDictionary_Access
    Protected Procedure oDataDictionary_Access()

        * Aquí se guarda el Singleton
        Return This.oDataDictionary

    Endproc && oDataDictionary_Access

    *
    * oForms_Access
    Protected Procedure oForms_Access()

        * Aquí se guarda el Singleton
        Return This.oForms

    Endproc && oForms_Access

    *
    * oDataBases_Access
    Procedure oDataBases_Access()

        * Aquí se guarda el Singleton
        Return This.oDataBases

    Endproc && oDataBases_Access

    *
    * oColEntities_Access
    Procedure oColEntities_Access()

        If Isnull( This.oColEntities )
            This.oColEntities = Newobject( "oColBase", 'Tools\DataDictionary\prg\oColBase.prg' )
        Endif

        * Aquí se guarda el Singleton
        Return This.oColEntities

    Endproc && oColEntities_Access

    *
    * oHtmlErrors_Access
    Protected Procedure oHtmlErrors_Access()

        If Isnull( This.oHtmlErrors )
            This.oHtmlErrors = Newobject( "oColHtmlErrors", "Tools\ErrorHandler\prg\HtmlErrors.prg" )
        Endif

        Return This.oHtmlErrors

    Endproc && oHtmlErrors_Access


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: nUpdateFontSize_Access
    *!* Date..........: Miércoles 8 de Julio de 2009 (13:01:42)
    *!* Author........: Damian Eiff
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure nUpdateFontSize_Access() As Number

        This.nUpdateFontSize = This.oApp.nUpdateFontSize

        Return This.nUpdateFontSize

    Endproc &&  nUpdateFontSize_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: nUpdateFontSize_Assign
    *!* Date..........: Miércoles 8 de Julio de 2009 (13:01:42)
    *!* Author........: Damian Eiff
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure nUpdateFontSize_Assign( uNewValue As Number )

        Assert Vartype( uNewValue ) = 'N' Message 'No es un número'

        This.oApp.nUpdateFontSize = uNewValue
        This.nUpdateFontSize = uNewValue

    Endproc && nUpdateFontSize_Assign





    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: cDescripcionEmpresaActiva_Access
    *!* Date..........: Lunes 27 de Julio de 2009 (09:15:06)
    *!* Author........: Danny Amerikaner
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure cDescripcionEmpresaActiva_Access()

        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
        Local loEmpresa As Object
        Try


            If This.oApp.nVersion >= 2013
                This.cDescripcionEmpresaActiva = This.oApp.oUser.cDescripcionEmpresaActiva

            Else
                loEmpresa = This.InstanciateEntity("Empresa")
                This.cDescripcionEmpresaActiva = Alltrim( loEmpresa.GetDescripcion( This.nEmpresaActiva ) )

            Endif

        Catch To oErr
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError
        Finally
            loError = Null
            loEmpresa = Null
        Endtry

        Return This.cDescripcionEmpresaActiva

    Endproc
    *!*
    *!* END PROCEDURE cDescripcionEmpresaActiva_Access
    *!*
    *!* ///////////////////////////////////////////////////////

    *
    * cApplicationName_Access
    Protected Procedure cApplicationName_Access()

        Local loProject As ProjectHook

        Try

            If Empty( This.cApplicationName )
                This.cApplicationName = This.oApp.cApplicationName
            Endif

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally
            loProject = Null

        Endtry

        Return This.cApplicationName

    Endproc && cApplicationName_Access


    *
    * oGlobalSettings_Access
    Protected Procedure oGlobalSettings_Access()
        This.oGlobalSettings = Null
        Return This.oGlobalSettings
    Endproc


    *
    * oColFilters_Access
    Protected Procedure oColFilters_Access()

        If Vartype( This.oColFilters ) # "O"
            This.oColFilters = Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.prg" )
        Endif

        Return This.oColFilters

    Endproc && oColFilters_Access


    *
    * oMonedas_Access
    Protected Procedure oMonedas_Access()

        Local lcCommand As String
        Local llExist As Boolean,;
            llUseMonedas As Boolean

        Local lcAlias As String,;
            lcFile As String,;
            lcFieldList As String

        Local lnCoti As Number
        Local i As Integer

        Local loMonedas As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
        Local loMoneda As Object
        Local loDataTier As PrxDataTier Of "V:\Clipper2fox\Fw\Tieradapter\Comun\Prxdatatier.prg"

        Try

            lcCommand = ""
            Set DataSession To 1
            lcAlias = Alias()

            llExist = Used( "ar4Var" )


            * RA 2012-08-17(17:57:21)
            * Si pasaron más de 60 segundos, refrescar la colección
            If Vartype( This.oMonedas ) == "O"
                loMonedas = This.oMonedas
                If Seconds() - loMonedas.nSeconds > 60
                    This.oMonedas = Null
                Endif
            Endif

            If Vartype( This.oMonedas ) # "O"

                If !llExist

                    M_Use( 0, Trim( DrComun ) + "ar4Var", -1 )

                Endif

                loMonedas 		= Newobject( "PrxCollection", "Fw\TierAdapter\Comun\PrxBaseLibrary.prg" )
                AddProperty( loMonedas, "nSeconds", Seconds() )

                llUseMonedas = !Empty( Field( "SIGN4", "ar4Var" ))
                llUseMonedas = llUseMonedas And !Empty( Field( "COTI4", "ar4Var" ))

                If llUseMonedas

                    TEXT To lcFieldList NoShow TextMerge Pretext 15
					Codi4 as Codigo,
					Nomb4 as Descripcion,
					Sign4 as Signo,
					Coti4 as Cotizacion
                    ENDTEXT

                    loDataTier = NewDT()

                    TEXT To lcCommand NoShow TextMerge Pretext 15
					Select 	<<lcFieldList>>
						From '<<Alltrim( DRCOMUN )>>AR4VAR'
						Where Tipo4 = 'M'
                    ENDTEXT

                    loDataTier.SQLExecute( lcCommand, "cMonedas" )

                    If _Tally < 2
                        * Verificar que al menos PESOS y DOLAR estén definidas

                        Select Ar4Var
                        Locate For Tipo4 = 'M' And Codi4 = 1

                        If !Found()
                            Insert Into Ar4Var (;
                                Tipo4,;
                                Codi4,;
                                Nomb4,;
                                Sign4,;
                                Coti4 ) Values (;
                                "M",;
                                PESOS_ID,;
                                "PESOS",;
                                "$",;
                                1 )
                        Endif

                        Locate For Tipo4 = 'M' And Codi4 = 2

                        If !Found()

                            lnCoti = GetValue( "Dola0", "Ar0Est", 1 )

                            Insert Into Ar4Var (;
                                Tipo4,;
                                Codi4,;
                                Nomb4,;
                                Sign4,;
                                Coti4 ) Values (;
                                "M",;
                                DOLAR_ID,;
                                "DOLAR",;
                                "U$S",;
                                lnCoti )
                        Endif

                        loDataTier.SQLExecute( lcCommand, "cMonedas" )

                    Endif

                    Select cMonedas
                    Locate

                    Scan
                        loMoneda = Createobject( "Empty" )

                        AddProperty( loMoneda, "Codigo", cMonedas.Codigo )
                        AddProperty( loMoneda, "Descripcion", Alltrim( cMonedas.Descripcion ))
                        AddProperty( loMoneda, "Signo", Alltrim( cMonedas.Signo ))
                        AddProperty( loMoneda, "Cotizacion", cMonedas.Cotizacion )

                        loMonedas.AddItem( loMoneda, Transform( loMoneda.Codigo ))
                    Endscan


                Else

                    lnCoti = GetValue( "Dola0", "Ar0Est", 1 )

                    For i = 1 To 2
                        loMoneda = Createobject( "Empty" )

                        Do Case
                            Case i = PESOS_ID
                                AddProperty( loMoneda, "Codigo", i )
                                AddProperty( loMoneda, "Descripcion", "PESO" )
                                AddProperty( loMoneda, "Signo", "$" )
                                AddProperty( loMoneda, "Cotizacion", 1 )

                                loMonedas.AddItem( loMoneda, Transform( loMoneda.Codigo ))

                            Case i = DOLAR_ID
                                AddProperty( loMoneda, "Codigo", i )
                                AddProperty( loMoneda, "Descripcion", "DOLAR" )
                                AddProperty( loMoneda, "Signo", "U$S" )
                                AddProperty( loMoneda, "Cotizacion", lnCoti  )

                                loMonedas.AddItem( loMoneda, Transform( loMoneda.Codigo ))

                        Endcase

                    Endfor

                Endif

                This.oMonedas = loMonedas

            Endif

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cRemark = lcCommand
            loError.Process( oErr )
            Throw loError

        Finally
            loMonedas = Null
            loMoneda = Null
            loDataTier = Null

            If !llExist
                Use In Select( "ar4Var" )
            Endif

            Use In Select( "cMonedas" )

            If Used( lcAlias )
                Select Alias( lcAlias )
            Endif

        Endtry

        Return This.oMonedas

    Endproc && oMonedas_Access



    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: Destroy
    *!* Description...:
    *!* Date..........: Martes 3 de Febrero de 2009 (13:22:51)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!* Cambie el orden en que se eliminan las cosas
    *!*

    Procedure Destroy(  ) As Void

        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
        Try

            This.oApp = Null
            This.oUser = Null
            This.oHasar = Null
            This.oFE = Null
            This.oWsPadron = Null
            This.oFeX = Null
            This.oIIBB = Null
            This.oArticulo = Null
            This.oEstadisticas = Null
            This.oMonedas = Null
            This.oPedidos = Null
            This.oPresupuestos = Null
            This.oStock = Null
            This.oCaja = Null
            This.oGrabarNovedades = Null
            This.oColTiposDocumento = Null

            If Pemstatus( _Screen, "oGlobalSettings", 5 )
                * DAE 2009-11-03(14:15:27)
                * Esta linea me da siempre error y por eso se cierra el fox
                * _Screen.oGlobalSettings = Null

                Removeproperty( _Screen, "oGlobalSettings" )
            Endif

            DoDefault()

        Catch To oErr

            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            * DAE 2009-11-03(14:14:55)
            * loError.Process( oErr )
            loError.Process( oErr, ! IsRunTime(), .T. )
            * DAE 2009-11-03(14:14:55)
            * Throw loError

        Finally
            loError = Null

        Endtry

    Endproc && Destroy


    *
    * nIvaNormal _Access
    Protected Procedure nIvaNormal_Access()
        If Empty( This.nIvaNormal )

            If This.oApp.nVersion >= 2013
                Local loIva As Iva Of "ERP\Comunes\Sistema\Prg\Iva.prg"

                loIva = This.InstanciateEntity( "Iva" )
                loIva.GetIvaNormalId()
                This.nIvaNormal = loIva.nAlicuota
                Use In Select( loIva.cMainCursorName )
                loIva = Null

            Else
                This.nIvaNormal = GetValue( "IvaNorm", "ar0Imp", 21.00 )

            Endif

        Endif

        Return This.nIvaNormal

    Endproc && nIvaNormal _Access

    *
    * nIvaReducido_Access
    Protected Procedure nIvaReducido_Access()

        If Empty( This.nIvaReducido )
            If This.oApp.nVersion >= 2013
                Local loIva As Iva Of "ERP\Comunes\Sistema\Prg\Iva.prg"

                loIva = This.InstanciateEntity( "Iva" )
                loIva.GetIvaReducidoId()
                This.nIvaReducido = loIva.nAlicuota
                Use In Select( loIva.cMainCursorName )
                loIva = Null

            Else
                This.nIvaReducido = GetValue( "IvaRedu", "ar0Imp", 10.50 )

            Endif

        Endif

        Return This.nIvaReducido

    Endproc && nIvaReducido_Access


    *
    * nIvaDiferenciado_Access
    Protected Procedure nIvaDiferenciado_Access()

        If Empty( This.nIvaDiferenciado )

            If This.oApp.nVersion >= 2013
                Local loIva As Iva Of "ERP\Comunes\Sistema\Prg\Iva.prg"

                loIva = This.InstanciateEntity( "Iva" )
                loIva.GetIvaDiferenciadoId()
                This.nIvaDiferenciado = loIva.nAlicuota
                Use In Select( loIva.cMainCursorName )
                loIva = Null

            Else
                This.nIvaDiferenciado = GetValue( "IvaDife", "ar0Imp", 27.00 )

            Endif

        Endif

        Return This.nIvaDiferenciado

    Endproc && nIvaDiferenciado_Access

    *
    * cDefaultPrinter_Access
    Protected Procedure cDefaultPrinter_Access()

        If Empty( This.cDefaultPrinter )
            This.cDefaultPrinter = Set("Printer",2)
        Endif

        Return This.cDefaultPrinter

    Endproc && cDefaultPrinter_Access

    *
    * cImpuestosIVA_Access
    Protected Procedure cImpuestosIVA_Access()
        Local loConsultasAFIP As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg",;
            loImpuestos As Object,;
            loImpuesto As Object

        Local lcImpuestosIVA As String


        If Empty( This.cImpuestosIVA )
            Try

                If !FileExist( Alltrim( DrComun ) + "Impuestos_Afip.dbf" )
                    loConsultasAFIP = Newobject( "oConsultasAFIP", "FW\Comunes\prg\ConsultasAFIP.prg" )
                    loConsultasAFIP.lSilence = .T.
                    loImpuestos = loConsultasAFIP.Impuestos()

                    If loImpuestos.lStatus = .T. And loImpuestos.Success
                        Create Cursor cImpuestos ( Id i, Nombre C(100) )

                        For Each loImpuesto In loImpuestos.Data

                            Insert Into cImpuestos (;
                                Id, Nombre ) Values (;
                                loImpuesto.idimpuesto,;
                                loImpuesto.Descimpuesto )

                        Endfor

                        Select * From cImpuestos ;
                            Order By Nombre ;
                            Into Table Impuestos

                        TEXT To lcCommand NoShow TextMerge Pretext 15
						Select *
							From cImpuestos
							Order By Nombre
							Into Table '<<Alltrim( DrComun ) + "Impuestos_Afip">>'
                        ENDTEXT

                        &lcCommand
                        lcCommand = ""


                    Else
                        Error "No se pudo conectar"

                    Endif

                    Use In Select( "Impuestos_Afip" )

                Endif

                TEXT To lcCommand NoShow TextMerge Pretext 15
					Select 	Id,
							Nombre
						From '<<Alltrim( DrComun + "Impuestos_Afip" )>>'
						Where Upper( Substr( Nombre, 1, 3 )) = "IVA"
							Or Upper( Substr( Nombre, 1, 6 )) = "MONOTR"
						Order By Id
						Into Table '<<Alltrim( DrComun ) + "Impuestos_Afip_IVA">>'
                ENDTEXT

                &lcCommand
                lcCommand = ""
                Index On Id Tag Id

                lcImpuestosIVA = ""

                Select Impuestos_Afip_IVA
                Locate
                Scan
                    lcImpuestosIVA = lcImpuestosIVA + "," + Transform( Id )
                Endscan

                This.cImpuestosIVA = Substr( lcImpuestosIVA, 2 )


            Catch To oErr
                This.cImpuestosIVA = "20, 21, 22, 23, 24, 30, 32, 33, 34 "

            Finally
                Use In Select( "Impuestos_Afip_IVA" )
                Use In Select( "Impuestos_Afip" )

            Endtry


        Endif

        Return This.cImpuestosIVA

    Endproc && cImpuestosIVA_Access

    *
    * nClientePraxis_Access
    Protected Procedure nClientePraxis_Access()

        If Empty( This.nClientePraxis )
            * RA 22/11/2021(10:43:54)
            * Inicializar con el Cliente_Praxis activo
            This.nClientePraxis = 0
        Endif

        Return This.nClientePraxis

    Endproc && nClientePraxis_Access


Enddefine && GlobalSettings




* RA 2013-01-20(12:36:10)
* Si por algun motivo no funcion desde saMain, indicar por qué se debe usar desde AbstractApplication.prg
Define Class oTestApp As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"
    #If .F.
        Local This As oTestApp Of "FW\Comunes\Prg\GlobalSettings.prg"
    #Endif

    * RA 2013-07-13(10:10:37)
    * No debe modificarse el entorno, solo traer el objeto

    Procedure Start( toParam As Object ) As Void
        Nodefault
    Endproc

    Function SetEnvironment(  ) As Void
        Nodefault
        Return This.lIsOk
    Endfunc

    Procedure SetParameFileName(  ) As Void
        Nodefault
    Endproc


    Procedure Destroy(  ) As Void
        With This As AbstractApplication Of "Comun\Prg\AbstractApplication.prg"
            .oActiveForm 		= Null
            .oAppLogo 			= Null
            .oButtons 			= Null
            .oColConfigData		= Null
            .oColForms 			= .F.
            .oColTables 		= Null
            .oMainToolbar 		= Null
            .oMenuBuilder 		= Null
            .oUser 				= Null
            .oEntorno 			= Null
            .oDataBases 		= Null
            .oDataDictionary 	= Null
            .oEntitiesConfig 	= Null
            .oForms 			= Null
            .oGlobalSettings 	= Null
            .oParent 			= Null
            .oError 			= Null
            .oTables 			= Null
        Endwith

    Endproc && Destroy
Enddefine



*!* ///////////////////////////////////////////////////////
*!* Class.........: GlobalSettings2
*!* ParentClass...: GlobalSettings Of 'Fw\Comunes\Prg\GlobalSettings.prg'
*!* BaseClass.....: Session
*!* Description...: Variables globales para Fenix v.2.0
*!* Date..........: Sábado 12 de Abril de 2014 (12:17:13)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class GlobalSettings2 As GlobalSettings Of 'Fw\Comunes\Prg\GlobalSettings.prg'

    #If .F.
        Local This As GlobalSettings2 Of "Fw\Comunes\Prg\GlobalSettings.prg"
    #Endif

    * 0 a 5, igual que en Clipper
    Clave = 0

    * Fecha activa en todo el sistema
    dFechaHoy = Date()


    * High Value para la fecha
    dLastDate = {^2499/12/31}

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="clave" type="property" display="Clave" />] + ;
        [<memberdata name="dfechahoy" type="property" display="dFechaHoy" />] + ;
        [<memberdata name="dlastdate" type="property" display="dLastDate" />] + ;
        [</VFPData>]


    Procedure nEmpresaActiva_Access()
        Local loEmpresa As oEmpresa Of "Clientes\Archivos2\Prg\Empresas.prg"
        Local loRegistro As Object

        Local lcCommand As String

        Try

            lcCommand = ""

            If Empty( This.nEmpresaActiva )
                lcClassLib = "Clientes\Archivos2\Prg\Empresas.prg"
                loEmpresa 			= Newobject( "oEmpresa", lcClassLib )
                loRegistro 			= loEmpresa.GetDefault()
                This.nEmpresaActiva = loRegistro.Id
                This.cDescripcionEmpresaActiva = Alltrim( loRegistro.Nombre )
            Endif

            If Empty( This.nEmpresaActiva )
                This.nEmpresaActiva = 1
            Endif

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cRemark = lcCommand
            loError.Process( oErr )
            Throw loError

        Finally
            loEmpresa 	= Null
            loRegistro 	= Null

        Endtry

        Return This.nEmpresaActiva

    Endproc && nEmpresaActiva_Access

    *
    * nEjercicioActivo_Access
    Protected Procedure nEjercicioActivo_Access()
        Local loEjercicio As oEjercicio Of "Clientes\Contabilidad\Prg\Ejercicios.prg"
        Local loRegistro As Object

        Local lcCommand As String,;
            lcLibreria As String

        Try

            lcCommand = ""

            If Empty( This.nEjercicioActivo )
                * RA 2014-03-08(11:19:24)
                * Para que no sea llamado por el compilador en todos los modulos
                lcLibreria 				= "Clientes\Contabilidad\Prg\Ejercicios.prg"

                loEjercicio 			= Newobject( "oEjercicio", lcLibreria )
                loRegistro 				= loEjercicio.GetDefault( This.nEmpresaActiva )
                This.nEjercicioActivo 	= loRegistro.Id
            Endif

            If Empty( This.nEjercicioActivo )
                This.nEjercicioActivo 	= 1
            Endif

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cRemark = lcCommand
            loError.Process( oErr )
            Throw loError

        Finally
            loEjercicio 	= Null
            loRegistro 	= Null

        Endtry

        Return This.nEjercicioActivo

    Endproc && nEjercicioActivo_Access



    Procedure cDescripcionEmpresaActiva_Access()

        Return This.cDescripcionEmpresaActiva

    Endproc
    *!*
    *!* END PROCEDURE cDescripcionEmpresaActiva_Access
    *!*
    *!* ///////////////////////////////////////////////////////

    *
    * oApp_Access
    Protected Procedure oApp_Access() As Object
        With This As GlobalSettings Of fw\comunes\prg\GlobalSettings.prg
            If Vartype( .oApp ) # "O"
                If Pemstatus( _Screen, "oApp", 5 ) And Vartype( _Screen.oApp ) == "O"
                    .oApp = _Screen.oApp

                Else
                    .oApp = Createobject( "oTestApp", "", "v.2" )

                Endif
            Endif
        Endwith
        Return This.oApp
    Endproc && oApp_Access

    *
    * oDataBases_Access
    Procedure oDataBases_Access()

        * Aquí se guarda el Singleton
        Return This.oDataBases

    Endproc && oDataBases_Access


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: dPrimerFechaValida_Access
    *!* Date..........: Martes 17 de Marzo de 2009 (11:12:59)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure dPrimerFechaValida_Access()

        If Empty( This.dPrimerFechaValida )
            This.dPrimerFechaValida = {^1900-01-01}
        Endif

        Return This.dPrimerFechaValida

    Endproc && dPrimerFechaValida_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: dUltimaFechaValida_Access
    *!* Date..........: Martes 17 de Marzo de 2009 (11:12:59)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure dUltimaFechaValida_Access()

        If Empty( dUltimaFechaValida )
            This.dUltimaFechaValida = Date()
        Endif

        Return This.dUltimaFechaValida

    Endproc && dUltimaFechaValida_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: GlobalSettings2
*!*
*!* ///////////////////////////////////////////////////////
