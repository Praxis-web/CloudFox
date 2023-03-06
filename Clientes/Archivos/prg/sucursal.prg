#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Sucursal( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loSucursal As oSucursal Of "Clientes\Archivos\prg\Sucursal.prg",;
		loParam As Object


	Try

		lcCommand = ""

			loParam = Createobject( "Empty" )

			AddProperty( loParam, "nPermisos", nPermisos )
			AddProperty( loParam, "cURL", cURL  )

			loSucursal = GetEntity( "Sucursal" )
			loSucursal.Initialize( loParam )

			AddProperty( loParam, "oBiz", loSucursal )

			Do Form (loSucursal.cGrilla) ;
				With loParam To loReturn


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loSucursal = Null

	Endtry

Endproc && Sucursal

*!* ///////////////////////////////////////////////////////
*!* Class.........: oSucursal
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oSucursal As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oSucursal Of "Clientes\Archivos\prg\Sucursal.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.

	cModelo 		= "Sucursal"

	cFormIndividual = "Clientes\Archivos\Scx\Sucursal.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Sucursales.scx"

	cTituloEnForm 	= "Sucursal"
	cTituloEnGrilla = "Sucursales"
	
	lIsChild 		= .T.
	cParent 		= "Empresa"
	
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


    *
    *
    Procedure CambiarSucursalActiva() As Void
        Local lcCommand As String,;
            lcAlias As String
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
            loSucursal As oSucursal Of "Clientes\Archivos\prg\Sucursal.prg",;
            loReturn As Object,;
            loFiltro As Object

        Local lnSucursalActiva As Integer

        Try

            lcCommand = ""
            
            loGlobalSettings 	= NewGlobalSettings()
            lnSucursalActiva 	= loGlobalSettings.nEmpresaSucursalActiva

            loFiltro = Createobject( "Empty" )
            AddProperty( loFiltro, "Nombre", "Activos" )
            AddProperty( loFiltro, "FieldName", "activo" )
            AddProperty( loFiltro, "FieldRelation", "==" )
            AddProperty( loFiltro, "FieldValue", "True" )

            This.AddFilter( loFiltro )

			This.oParent.nId = loGlobalSettings.nEmpresaActiva 
			
            loReturn = This.GetByWhere()
            lcAlias = loReturn.cAlias

            TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From <<lcAlias>>
				Order By Orden,Nombre
				Into Cursor <<lcAlias>> ReadWrite
            ENDTEXT

            &lcCommand
            lcCommand = ""

            lnTally = _Tally

            If lnTally > 1

                Dimension aSucursalesNombre[ lnTally ],aSucursalesId[ lnTally ]

                Locate
                lnSelected = 0
                Scan

                    aSucursalesNombre[ Recno()  ] = Alltrim( Nombre )
                    aSucursalesId[ Recno()  ] 	= Id

                    If Id = loGlobalSettings.nEmpresaSucursalActiva
                        lnSelected = Recno()
                    Endif

                Endscan

                lnSelected = S_Opcion( -1,-1,0,0,"aSucursalesNombre", lnSelected, .F., "Sucursales" )

                If !Empty( lnSelected )
                    loGlobalSettings.nEmpresaSucursalActiva = aSucursalesId[ lnSelected ]
                    loGlobalSettings.cDescripcionSucursalActiva = Alltrim( aSucursalesNombre[ lnSelected ] )
                Endif

            Else
                If lnTally = 1
                    Locate
                    loGlobalSettings.nEmpresaSucursalActiva = Id
                    loGlobalSettings.cDescripcionSucursalActiva = Alltrim( Nombre )
                Endif

            Endif

            If lnSucursalActiva # loGlobalSettings.nEmpresaSucursalActiva 

                _Screen.oApp.SetApplicationMainCaption()

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loSucursal = Null

        Endtry

    Endproc && CambiarSucursalActiva

	*
	* cUrl_Access
	Procedure cUrl_Access()

		If Empty( Alltrim( This.cURL ))
			* Inicializar la URL
			* Puede ponerse duro para cada modelo,
			* o leerse de un archivo de configuración local
			* para una personalización especial
			
			This.cURL = "comunes/apis/Sucursal/"


		EndIf

		Return This.cURL 

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oSucursal
*!*
*!* ///////////////////////////////////////////////////////