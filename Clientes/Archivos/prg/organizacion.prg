#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Organizacion( nPermisos As Integer,;
        nParam2 As Integer,;
        nParam3 As Integer,;
        nParam4 As Integer,;
        nParam5 As Integer,;
        cURL As String,;
        lDoPrg ) As Void

    Local lcCommand As String
    Local loOrganizacion As oOrganizacion Of "Clientes\Archivos\prg\Organizacion.prg",;
        loParam As Object


    Try

        lcCommand = ""

        loParam = Createobject( "Empty" )

        AddProperty( loParam, "nPermisos", nPermisos )
        AddProperty( loParam, "cURL", cURL  )

        loOrganizacion = GetEntity( "Organizacion" )
        loOrganizacion.Initialize( loParam )

        AddProperty( loParam, "oBiz", loOrganizacion )

        Do Form (loOrganizacion.cGrilla) ;
            With loParam To loReturn



    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally
        loOrganizacion = Null

    Endtry

Endproc && Organizacion

*!* ///////////////////////////////////////////////////////
*!* Class.........: oOrganizacion
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oOrganizacion As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oOrganizacion Of "Clientes\Archivos\prg\Organizacion.prg"
    #Endif

    lEditInBrowse 	= .F.
    cModelo 		= "Organizacion"
    lValidate 		= .T.

    cFormIndividual = "Clientes\Archivos\Scx\Organizacion.scx"
    cGrilla 		= "Clientes\Archivos\Scx\Organizaciones.scx"

    cTituloEnForm 	= "Presentación"
    cTituloEnGrilla = "Organizaciones"

    * Indica si obtiene los datos de Organización, o de las FK (Cliente / Proveedor )
    lOrganizacion = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="lorganizacion" type="property" display="lOrganizacion" />] + ;
        [</VFPData>]

    *
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( Alltrim( This.cURL ))
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

            This.cURL = "archivos/apis/Organizacion/"

        Endif

        Return This.cURL

    Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oOrganizacion
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oContacto
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oContacto As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oContacto Of "Clientes\Archivos\prg\Organizacion.prg"
    #Endif

    lEditInBrowse 	= .F.
    cModelo 		= "Organizacion_Contacto"

    cFormIndividual = "Clientes\Archivos\Scx\Contacto.scx"
    cGrilla 		= ""

    cURL 			= "archivos/apis/Organizacion_Contacto/"

    cTituloEnForm 	= "Contacto"
    cTituloEnGrilla = "Contactos"

    lIsChild 		= .T.
    cParent 		= "Organizacion"

    lFiltrarPorClientePraxis = .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


    *
    *
    Procedure HookAfterGetByPk( oReturn As Object ) As Object
        Local lcCommand As String
        Local loReturn As Object,;
        loOrganizacion As oOrganizacion Of "Clientes\Archivos\prg\Organizacion.prg"
        
        Local lnOrganizacion_Id as Integer 

        Try

            lcCommand = ""
            loReturn = oReturn
            
            lnOrganizacion_Id = loReturn.oRegistro.Organizacion  
            loOrganizacion = GetEntity( "Organizacion" )
            loRespuesta = loOrganizacion.GetByPK( lnOrganizacion_Id )

    		If !Isnull( loRespuesta.oRegistro )
    			loReturn.oRegistro.str_Organizacion = loRespuesta.oRegistro.Nombre
    		EndIf 

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            oReturn = Null
            loOrganizacion = Null
            loRespuesta = Null

        Endtry

        Return loReturn

    Endproc && HookAfterGetByPk

    *
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( Alltrim( This.cURL ))
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

            This.cURL = "archivos/apis/Organizacion_Contacto/"

        Endif

        Return This.cURL
    Endproc

    *
    *
    Procedure xxx___HookFilterCriteria( oFilterCriteria As Collection ) As Collection
        Local lcCommand As String
        Local loFiltro As Object
        Local lnId As Integer

        Try

            lcCommand = ""

            If Isnull( oFilterCriteria )
                oFilterCriteria = Createobject( "Collection" )
            Endif

            lnId = oFilterCriteria.GetKey( Lower( "Organizacion_Cliente" ))

            If !Empty( lnId )
                loFiltro = oFilterCriteria.Item( lnId )
                loFiltro.FieldName = Lower( "Organizacion" )

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


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oContacto
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oContacto_Telefono
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oContacto_Telefono As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oContacto_Telefono Of "Clientes\Archivos\prg\Organizacion.prg"
    #Endif

    lEditInBrowse 	= .F.
    cModelo 		= "Organizacion_Contacto_Telefono"

    cFormIndividual = "Clientes\Archivos\Scx\Contacto_Telefono.scx"
    cGrilla 		= ""

    cURL 			= "archivos/apis/Organizacion_Contacto_Telefono/"

    cTituloEnForm 	= "Contacto_Telefono"
    cTituloEnGrilla = "Contacto_Telefonos"

    lIsChild 		= .T.
    cParent 		= "Organizacion"

    lFiltrarPorClientePraxis = .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( Alltrim( This.cURL ))
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

            This.cURL = "archivos/apis/Organizacion_Contacto_Telefono/"

        Endif

        Return This.cURL
    Endproc

    *
    *
    Procedure HookFilterCriteria( oFilterCriteria As Collection ) As Collection
        Local lcCommand As String
        Local loFiltro As Object
        Local lnId As Integer

        Try

            lcCommand = ""

            If Isnull( oFilterCriteria )
                oFilterCriteria = Createobject( "Collection" )
            Endif

            lnId = oFilterCriteria.GetKey( Lower( "Organizacion_Cliente" ))

            If !Empty( lnId )
                loFiltro = oFilterCriteria.Item( lnId )
                loFiltro.FieldName = Lower( "Organizacion" )

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


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oContacto_Telefono
*!*
*!* ///////////////////////////////////////////////////////
*!* ///////////////////////////////////////////////////////
*!* Class.........: cboTelefono
*!* Description...:
*!* Date..........: Martes 7 de Junio de 2022 (16:29:02)
*!*
*!*

Define Class cboTelefono_Contacto As cboTelefono Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As cboTelefono_Contacto Of "Clientes\Archivos\prg\Organizacion.prg"
    #Endif


    cTable 	= "Organizacion_Contacto_Telefono"
    cModelo = "Organizacion_Contacto_Telefono"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Filtrar(  ) As Void
        Local lcCommand As String
        Local loFiltro As Object,;
            loGrid As GridInForm Of "fw\comunes\vcx\prxbrowse.vcx",;
            loOrganizacion As oOrganizacion Of "Clientes\Archivos\prg\Organizacion.prg"

        Try

            lcCommand = ""

            DoDefault()

            loGrid 			= This.Parent.Parent
            loOrganizacion 	= loGrid.oBiz.oParent

            loFiltro = Createobject( "Empty" )
            AddProperty( loFiltro, "Nombre", "Organizacion" )
            AddProperty( loFiltro, "FieldName", "organizacion" )
            AddProperty( loFiltro, "FieldRelation", "==" )
            AddProperty( loFiltro, "FieldValue", Transform( loOrganizacion.nId ) )

            This.AddFilter( loFiltro )

            *!*	            loFiltro = Createobject( "Empty" )
            *!*	            AddProperty( loFiltro, "Nombre", "Contacto" )
            *!*	            AddProperty( loFiltro, "FieldName", "contacto" )
            *!*	            AddProperty( loFiltro, "FieldRelation", "==" )
            *!*	            AddProperty( loFiltro, "FieldValue", 1 )

            This.AddFilter( loFiltro )


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loFiltro 		= Null
            loGrid 			= Null
            loOrganizacion 	= Null

        Endtry

    Endproc && Filtrar

Enddefine
*!*
*!* END DEFINE
*!* Class.........: cboTelefono
*!*
*!* ///////////////////////////////////////////////////////

