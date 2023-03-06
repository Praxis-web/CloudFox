#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Empresa( nPermisos As Integer,;
        nParam2 As Integer,;
        nParam3 As Integer,;
        nParam4 As Integer,;
        nParam5 As Integer,;
        cURL As String,;
        lDoPrg ) As Void

    Local lcCommand As String
    Local loEmpresa As oEmpresa Of "Clientes\Archivos\prg\Empresa.prg",;
        loParam As Object


    Try

        lcCommand = ""

        loParam = Createobject( "Empty" )

        AddProperty( loParam, "nPermisos", nPermisos )
        AddProperty( loParam, "cURL", cURL  )

        loEmpresa = GetEntity( "Empresa" )
        loEmpresa.Initialize( loParam )

        AddProperty( loParam, "oBiz", loEmpresa )

        Do Form (loEmpresa.cGrilla) ;
            With loParam To loReturn


    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally
        loEmpresa = Null

    Endtry

Endproc && Empresa

*!* ///////////////////////////////////////////////////////
*!* Class.........: oEmpresa
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oEmpresa As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oEmpresa Of "Clientes\Archivos\prg\Empresa.prg"
    #Endif

    lEditInBrowse 		= .F.

    cModelo 		= "Empresa"

    cFormIndividual = "Clientes\Archivos\Scx\Empresa.scx"
    cGrilla 		= "Clientes\Archivos\Scx\Empresas.scx"

    cTituloEnForm 	= "Empresa"
    cTituloEnGrilla = "Empresas"

    lIsChild 		= .T.
    cParent 		= "Cliente_Praxis"

    cURL 			= "comunes/apis/Empresa/"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="cambiarempresaactiva" type="method" display="CambiarEmpresaActiva" />] + ;
        [</VFPData>]


    *
    *
    Procedure ObtenerPermisos( nPermisos As Integer ) As Void
        Local lcCommand As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"


        Try

            lcCommand = ""

            DoDefault( nPermisos )

            If This.lShowCamposEspeciales
                This.lEditInBrowse 		= .F.
                This.lShowEditInBrowse 	= .T.
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
    Procedure CambiarEmpresaActiva() As Void
        Local lcCommand As String,;
            lcAlias As String
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
            loSucursal As oSucursal Of "Clientes\Archivos\prg\Sucursal.prg",;
            loReturn As Object,;
            loFiltro As Object

        Local lnEmpresaActiva As Integer

        Try

            lcCommand = ""

            loGlobalSettings 	= NewGlobalSettings()
            lnEmpresaActiva 	= loGlobalSettings.nEmpresaActiva

            loFiltro = Createobject( "Empty" )
            AddProperty( loFiltro, "Nombre", "Activos" )
            AddProperty( loFiltro, "FieldName", "activo" )
            AddProperty( loFiltro, "FieldRelation", "==" )
            AddProperty( loFiltro, "FieldValue", "True" )

            This.AddFilter( loFiltro )

            loReturn = This.GetByWhere()
            lcAlias = loReturn.cAlias

            TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From <<lcAlias>>
				Order By Orden, Nombre
				Into Cursor <<lcAlias>> ReadWrite
            ENDTEXT

            &lcCommand
            lcCommand = ""

            lnTally = _Tally

            If lnTally > 1

                Dimension aEmpresasNombre[ lnTally ],aEmpresasId[ lnTally ]

                Locate
                lnSelected = 0
                Scan

                    aEmpresasNombre[ Recno()  ] = Alltrim( Nombre )
                    aEmpresasId[ Recno()  ] 	= Id

                    If Id = loGlobalSettings.nEmpresaActiva
                        lnSelected = Recno()
                    Endif

                Endscan

                lnSelected = S_Opcion( -1,-1,0,0,"aEmpresasNombre", lnSelected, .F., "Empresas" )

                If !Empty( lnSelected )
                    loGlobalSettings.nEmpresaActiva = aEmpresasId[ lnSelected ]
                    loGlobalSettings.cDescripcionEmpresaActiva = Alltrim( aEmpresasNombre[ lnSelected ] )
                Endif

            Else
                If lnTally = 1
                    Locate
                    loGlobalSettings.nEmpresaActiva = Id
                    loGlobalSettings.cDescripcionEmpresaActiva = Alltrim( Nombre )
                Endif

            Endif

            If lnEmpresaActiva # loGlobalSettings.nEmpresaActiva

                loSucursal = GetEntity( "Sucursal" )
                loSucursal.oParent.nId = loGlobalSettings.nEmpresaActiva
                loReturn = loSucursal.GetByWhere()

                If loReturn.lOk
                    lcAlias = loReturn.cAlias
                    Select Alias( lcAlias )
                    Locate

                    loGlobalSettings.nEmpresaSucursalActiva = Id
                    loGlobalSettings.cDescripcionSucursalActiva = Alltrim( Nombre )

                Endif

                _Screen.oApp.SetApplicationMainCaption()

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loEmpresa = Null

        Endtry

    Endproc && CambiarEmpresaActiva

    *
    * oParent_Access
    Protected Procedure oParent_Access()

        If This.lIsChild ;
                And Vartype( This.oParent ) # "O" ;
                And !Empty( This.cParent )

            This.oParent = GetEntity( This.cParent, .T. )
            This.oParent.nId = This.nClientePraxis

        Endif

        Return This.oParent

    Endproc && oParent_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oEmpresa
*!*
*!* ///////////////////////////////////////////////////////
