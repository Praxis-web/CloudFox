#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Usuario( nPermisos As Integer,;
        nParam2 As Integer,;
        nParam3 As Integer,;
        nParam4 As Integer,;
        nParam5 As Integer,;
        cURL As String,;
        lDoPrg ) As Void

    Local lcCommand As String
    Local loUsuario As oUsuario Of "Clientes\Archivos\prg\Usuario.prg",;
        loParam As Object

    Try

        lcCommand = ""

        loParam = Createobject( "Empty" )

        AddProperty( loParam, "nPermisos", nPermisos )
        AddProperty( loParam, "cURL", cURL  )

        loUsuario = GetEntity( "Usuario" )
        loUsuario.Initialize( loParam )

        AddProperty( loParam, "oBiz", loUsuario )

        Do Form (loUsuario.cGrilla) ;
            With loParam To loReturn

    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally
        loUsuario = Null

    Endtry

Endproc && Usuario

*!* ///////////////////////////////////////////////////////
*!* Class.........: oUsuario
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oUsuario As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oUsuario Of "Clientes\Archivos\prg\Usuario.prg"
    #Endif

    lEditInBrowse 	= .F.
    cModelo 		= "Usuario"

    cFormIndividual = "Clientes\Archivos\Scx\Usuario.scx"
    cGrilla 		= "Clientes\Archivos\Scx\Usuarios.scx"

    cTituloEnForm 	= "Usuario"
    cTituloEnGrilla = "Usuarios"

    cURL 			= "usuario/apis/Usuario/"

    lFiltrarPorClientePraxis = .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oUsuario
*!*
*!* ///////////////////////////////////////////////////////
