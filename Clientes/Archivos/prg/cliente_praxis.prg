#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Cliente_Praxis( nPermisos As Integer,;
        nParam2 As Integer,;
        nParam3 As Integer,;
        nParam4 As Integer,;
        nParam5 As Integer,;
        cURL As String,;
        lDoPrg ) As Void

    Local lcCommand As String
    Local loPraxis As oPraxis Of "Clientes\Archivos\prg\Cliente_Praxis.prg",;
        loParam As Object,;
        loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
        loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"


    Try

        lcCommand = ""

        loParam = Createobject( "Empty" )

        AddProperty( loParam, "nPermisos", nPermisos )
        AddProperty( loParam, "cURL", cURL  )

        loPraxis = GetEntity( "Cliente_Praxis" )
        loPraxis.Initialize( loParam )

        AddProperty( loParam, "oBiz", loPraxis )

        loUser = NewUser()

        If Inlist( .T., loUser.lIsSuperuser, loUser.lIsStaff )
            Do Form (loPraxis.cGrilla) ;
                With loParam To loReturn

        Else
            loGlobalSettings = NewGlobalSettings()

            loReturn = loPraxis.GetByPK( loGlobalSettings.nClientePraxis )

            If loReturn.lOk
                loPraxis.LaunchEditForm( loReturn.oRegistro )
            Endif
        Endif


    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally
        loPraxis = Null

    Endtry

Endproc && Cliente_Praxis

*!* ///////////////////////////////////////////////////////
*!* Class.........: oPraxis
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oPraxis As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oPraxis Of "Clientes\Archivos\prg\Cliente_Praxis.prg"
    #Endif

    lEditInBrowse 		= .F.
    cModelo 		= "Cliente_Praxis"

    cFormIndividual = "Clientes\Archivos\Scx\Cliente_Praxis.scx"
    cGrilla 		= "Clientes\Archivos\Scx\Clientes_Praxis.scx"

    cTituloEnForm 	= "Cliente Abonado"
    cTituloEnGrilla = "Clientes Abonados"

    lFiltrarPorClientePraxis = .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="cambiarclienteactivo" type="method" display="CambiarClienteActivo" />] + ;
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
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( Alltrim( This.cURL ))
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

            This.cURL = "comunes/apis/Praxis/"

        Endif

        Return This.cURL

    Endproc && cUrl_Access




    *
    *
    Procedure CambiarClienteActivo( nNewId As Integer ) As Void
        Local lcCommand As String,;
            lcAlias As String,;
            lcNombre As String
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
            loEmpresa As oEmpresa Of "Clientes\Archivos\prg\Empresa.prg",;
            loSucursal As oSucursal Of "Clientes\Archivos\prg\Sucursal.prg",;
            loReturn As Object,;
            loSetup As Object,;
            loFiltro As Object,;
            loApp As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

        Local loMenu As oMenu Of "FrontEnd\Prg\DescargarMenu.prg"

        Local lnSelected As Integer,;
            lnTally As Integer
        Local llFound As Boolean,;
            llPregunta As Boolean

        Try

            lcCommand 	= ""
            lcNombre 	= ""
            llFound 	= .F.
            llPregunta 	= .T.

            loGlobalSettings = NewGlobalSettings()
            loReturn = This.GetByPK( nNewId )

            If loReturn.lOk
                llPregunta 	= loReturn.oRegistro.Es_Praxis
                lcNombre 	= loReturn.oRegistro.Nombre
                loGlobalSettings.nClientePraxis = nNewId

            Else
                llPregunta = .T.

            Endif

            If llPregunta

                * Pregunta con qué Cliente Praxis va a trabajar


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
					Where Id # nNewId
					Order By Orden, Nombre
					Into Cursor <<lcAlias>> ReadWrite
                ENDTEXT

                &lcCommand
                lcCommand = ""

                *lcAlias = Alias()

                *Browse

                lnTally = _Tally

                If !Empty( lnTally )

                    Dimension aClientesNombre[ lnTally ],aClientesId[ lnTally ]

                    Locate
                    lnSelected = 0
                    Scan

                        aClientesNombre[ Recno()  ] = Alltrim( Nombre )
                        aClientesId[ Recno()  ] 	= Id

                    Endscan

                    lnSelected = S_Opcion( -1,-1,0,0,"aClientesNombre", 1, .F., "Clientes" )

                    If !Empty( lnSelected )
                        loGlobalSettings.nClientePraxis = aClientesId[ lnSelected ]
                        lcNombre = aClientesNombre[ lnSelected ]

                        loGlobalSettings.nEmpresaActiva = 0
                        loGlobalSettings.cDescripcionEmpresaActiva = ""

                        loGlobalSettings.nEmpresaSucursalActiva = 0
                        loGlobalSettings.cDescripcionSucursalActiva = ""

                        loEmpresa = GetEntity( "Empresa" )
                        loReturn = loEmpresa.GetByWhere()

                        If loReturn.lOk
                            lcAlias = loReturn.cAlias
                            Select Alias( lcAlias )
                            Locate

                            loGlobalSettings.nEmpresaActiva = Id
                            loGlobalSettings.cDescripcionEmpresaActiva = Alltrim( Nombre )

                            loSucursal = GetEntity( "Sucursal" )
                            loSucursal.oParent.nId = Id
                            loReturn = loSucursal.GetByWhere()

                            If loReturn.lOk
                                lcAlias = loReturn.cAlias
                                Select Alias( lcAlias )
                                Locate

                                loGlobalSettings.nEmpresaSucursalActiva = Id
                                loGlobalSettings.cDescripcionSucursalActiva = Alltrim( Nombre )

                            Endif

                        Endif

                    Endif

                    _Screen.oApp.SetApplicationMainCaption()

                Endif

            Else
                loGlobalSettings.nClientePraxis = nNewId
                lcNombre = loReturn.oRegistro.Nombre

            Endif


            If  FileExist( "SetUp.cfg" )
                loSetup = XmlToObject( Filetostr( "SetUp.cfg" ))

            Else
                loSetup = Createobject( "Empty" )

            Endif

            If Vartype( loSetup ) == "O"
                If !Pemstatus( loSetup, "nClientePraxis", 5 )
                    AddProperty( loSetup, "nClientePraxis", 0 )
                Endif

                loSetup.nClientePraxis = loGlobalSettings.nClientePraxis

                Strtofile( ObjectToXml( loSetup, .T. ), "SetUp.cfg" )

            EndIf
            
            loApp = loGlobalSettings.oApp 
            loApp.ObtenerPermisos()   

*!*	            loMenu = GetEntity( "Menu" )
*!*	            loMenu.MenuLoader()

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loMenu = Null
            loApp = Null 

        Endtry

    Endproc && CambiarClienteActivo

    *
    *
    Procedure xxxCambiarClienteActivo( nNewId As Integer ) As Void
        Local lcCommand As String,;
            lcAlias As String,;
            lcNombre As String
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
            loReturn As Object,;
            loSetup As Object

        Local lnSelected As Integer
        Local llFound As Boolean

        Try

            lcCommand = ""
            lcNombre = ""
            llFound = .F.

            loGlobalSettings = NewGlobalSettings()

            loReturn = This.GetByWhere()
            lcAlias = loReturn.cAlias
            *lcAlias = Alias()

            *Browse

            Dimension aClientesNombre[ loReturn.nTally ],aClientesId[ loReturn.nTally ]


            Locate
            lnSelected = 0
            Scan

                aClientesNombre[ Recno()  ] = Alltrim( Nombre )
                aClientesId[ Recno()  ] 	= Id

                If Id = loGlobalSettings.nClientePraxis
                    lnSelected = Recno()
                Endif

            Endscan

            If !Empty( nNewId )
                Locate For Id = nNewId
                If Found()
                    loGlobalSettings.nClientePraxis = nNewId
                    lcNombre = Alltrim( Nombre )
                    llFound = .T.
                Endif
            Endif

            If !llFound
                lnSelected = S_Opcion( -1,-1,0,0,"aClientesNombre", lnSelected, .F., "Clientes" )
                loGlobalSettings.nClientePraxis = aClientesId[ lnSelected ]
                lcNombre = aClientesNombre[ lnSelected ]
            Endif

            _Screen.oApp.cEmpresa = lcNombre
            _Screen.oScreenLog.lblEmpresa.Caption = lcNombre

            _Screen.Caption = _Screen.oApp.cScreenCaption + " - " + lcNombre
            *_Screen.Icon = "v:\CloudFox\FW\Comunes\image\Modulos\Mercado Libre.ico"

            If  FileExist( "SetUp.cfg" )
                loSetup = XmlToObject( Filetostr( "SetUp.cfg" ))

            Else
                loSetup = Createobject( "Empty" )

            Endif

            If Vartype( loSetup ) == "O"
                If !Pemstatus( loSetup, "nClientePraxis", 5 )
                    AddProperty( loSetup, "nClientePraxis", 0 )
                Endif

                loSetup.nClientePraxis = loGlobalSettings.nClientePraxis

                Strtofile( ObjectToXml( loSetup, .T. ), "SetUp.cfg" )

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && xxxCambiarClienteActivo

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oPraxis
*!*
*!* ///////////////////////////////////////////////////////
