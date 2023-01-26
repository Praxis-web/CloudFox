#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure OrganizacionCliente( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loCliente As oCliente Of "Clientes\Archivos\prg\OrganizacionCliente.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loCliente = GetEntity( "Organizacion_Cliente" )
		loCliente.Initialize( loParam )

		AddProperty( loParam, "oBiz", loCliente )

		Do Form (loCliente.cGrilla) ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loCliente = Null

	Endtry

Endproc && Organizacion

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCliente
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oCliente As oOrganizacion Of "Clientes\Archivos\prg\Organizacion.prg"

	#If .F.
		Local This As oCliente Of "Clientes\Archivos\prg\OrganizacionCliente.prg"
	#Endif

	lEditInBrowse 	= .F.
	cModelo 		= "Organizacion_Cliente"

	cFormIndividual = "Clientes\Archivos\Scx\Cliente.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Clientes.scx"

	cTituloEnForm 	= "Cliente"
	cTituloEnGrilla = "Clientes"
	

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

			This.cURL = "archivos/apis/Cliente/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


    *
    *
    Procedure xxxListar( cURL As String,;
            oFilterCriteria As Collection,;
            cAlias As String ) As Object

        Local lcCommand As String,;
        lcURL as String 

        Try

            lcCommand = ""
            
            lcURL = "archivos/apis/ClienteList/"
            
            loReturn = DoDefault( lcURL, oFilterCriteria, cAlias )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return loReturn

    Endproc && Listar

    *
    *
    Procedure xxx___CrearCursor( cAlias As String, lStr As Boolean ) As Void
        Local lcCommand As String
        
        Try

            lcCommand = ""
            
            If This.lOrganizacion 
            	This.cTabla = "Organizacion"
            	
            Else
            	This.cTabla = "Organizacion_Cliente"

            EndIf
            
            DoDefault( cAlias, lStr )
           
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
    * Llama al formulario para editar la entidad
    Procedure LaunchEditForm( oRegistro As Object ) As Boolean ;
            HELPSTRING "Llama al formulario para editar la entidad"
        Local lcCommand As String

        Local loStatus As Object,;
            loParam As Object

        Local llReturn As Boolean

        Try

            lcCommand = ""
            loStatus = Null
            llReturn = .F.
            
            Inkey()

            This.oRegistro = oRegistro

            loParam = Createobject( "Empty" )
            AddProperty( loParam, "cModelo", This.cModelo )
            AddProperty( loParam, "oRegistro", oRegistro )
            AddProperty( loParam, "cABM", oRegistro.ABM )
            AddProperty( loParam, "uPK", Evaluate( "oRegistro." + "Cliente_Id" ))

            AddProperty( loParam, "oBiz", This )
            
            Do Form (This.cFormIndividual) With loParam To loStatus
            llReturn = ( loStatus.lCancelar = .F. )


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

        Endtry

        Return llReturn

    Endproc && LaunchEditForm


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCliente
*!*
*!* ///////////////////////////////////////////////////////
