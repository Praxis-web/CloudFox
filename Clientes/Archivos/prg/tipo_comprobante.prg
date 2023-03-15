#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Tipo_Comprobante( nPermisos As Integer,;
        nParam2 As Integer,;
        nParam3 As Integer,;
        nParam4 As Integer,;
        nParam5 As Integer,;
        cURL As String,;
        lDoPrg ) As Void

    Local lcCommand As String
    Local loTipo_Comprobante As oTipo_Comprobante Of "Clientes\Archivos\prg\Tipo_Comprobante.prg",;
        loParam As Object


    Try

        lcCommand = ""
        loParam = Createobject( "Empty" )

        AddProperty( loParam, "nPermisos", nPermisos )
        AddProperty( loParam, "cURL", cURL  )

        loTipo_Comprobante = GetEntity( "Tipo_Comprobante" )
        loTipo_Comprobante.Initialize( loParam )

        AddProperty( loParam, "oBiz", loTipo_Comprobante )

        *loTipo_Comprobante.BulkCreate()

        Do Form (loTipo_Comprobante.cGrilla) ;
            With loParam To loReturn

    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally
        loTipo_Comprobante = Null

    Endtry

Endproc && Tipo_Comprobante

*!* ///////////////////////////////////////////////////////
*!* Class.........: oTipo_Comprobante
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oTipo_Comprobante As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oTipo_Comprobante Of "Clientes\Archivos\prg\Tipo_Comprobante.prg"
    #Endif

    *lEditInBrowse 	= .T.
    cModelo 		= "Tipo_Comprobante"

    cFormIndividual = "Clientes\Archivos\Scx\Tipo_Comprobante.scx"
    cGrilla 		= "Clientes\Archivos\Scx\Tipos_Comprobante.scx"

    cURL 			= "comunes/apis/Tipo_Comprobante/"

    cTituloEnForm 	= "Tipo de Comprobante"
    cTituloEnGrilla = "Tipos de Comprobantes"

    lIsChild 		= .T.
    cParent 		= "Comprobante_Base"

    lFiltraPorComprobante = .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="lfiltraporcomprobante" type="property" display="lFiltraPorComprobante" />] + ;
        [</VFPData>]


    *
    *
    Procedure HookFilterCriteria( oFilterCriteria As Collection ) As Collection
        Local lcCommand As String

        Try

            lcCommand = ""

            If Isnull( oFilterCriteria )
                oFilterCriteria = Createobject( "Collection" )
            EndIf
            
            If !This.lFiltraPorComprobante
                oFilterCriteria.RemoveItem( "empty" )
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
*!* Class.........: oTipo_Comprobante
*!*
*!* ///////////////////////////////////////////////////////

