#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Comprobante_Base( nPermisos As Integer,;
        nParam2 As Integer,;
        nParam3 As Integer,;
        nParam4 As Integer,;
        nParam5 As Integer,;
        cURL As String,;
        lDoPrg ) As Void

    Local lcCommand As String
    Local loComprobante_Base As oComprobante_Base Of "Clientes\Archivos\prg\Comprobante_Base.prg",;
        loParam As Object


    Try

        lcCommand = ""
        loParam = Createobject( "Empty" )

        AddProperty( loParam, "nPermisos", nPermisos )
        AddProperty( loParam, "cURL", cURL  )

        loComprobante_Base = GetEntity( "Comprobante_Base" )
        loComprobante_Base.Initialize( loParam )

        AddProperty( loParam, "oBiz", loComprobante_Base )

        *loComprobante_Base.BulkCreate()

        Do Form (loComprobante_Base.cGrilla) ;
            With loParam To loReturn

    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally
        loComprobante_Base = Null

    Endtry

Endproc && Comprobante_Base

*!* ///////////////////////////////////////////////////////
*!* Class.........: oComprobante_Base
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oComprobante_Base As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oComprobante_Base Of "Clientes\Archivos\prg\Comprobante_Base.prg"
    #Endif

    *lEditInBrowse 	= .T.
    cModelo 		= "Comprobante_Base"

    cFormIndividual = "Clientes\Archivos\Scx\Comprobante_Base.scx"
    cGrilla 		= "Clientes\Archivos\Scx\Comprobantes_Base.scx"

    cTituloEnForm 	= "Comprobante de Sistema"
    cTituloEnGrilla = "Comprobantes de Sistema"

    cURL 			= "comunes/apis/Comprobante_Base/"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

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

        Local loTipo_Comprobante As oTipo_Comprobante Of "Clientes\Archivos\prg\Tipo_Comprobante.prg",;
            loParam As Object

        Local lnTotalDeRegistros As Integer,;
            lnCurrentPage As Integer,;
            lnLastPage As Integer,;
            lnPermisos As Integer

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

            *!*	            loParam = Createobject( "Empty" )
            *!*	            AddProperty( loParam, "cModelo", This.cModelo )
            *!*	            AddProperty( loParam, "oRegistro", loRegistro )
            *!*	            AddProperty( loParam, "cABM", loRegistro.ABM )
            *!*	            AddProperty( loParam, "uPK", Evaluate( "loRegistro." + This.cPKField ))
            *!*	            AddProperty( loParam, "WCLAV", "A" )
            *!*	            AddProperty( loParam, "oBiz", This )

            *!*	            Do Form (This.cFormIndividual) With loParam To loStatus

            loParam = Createobject( "Empty" )
            lnPermisos = CAN_CREATE + CAN_READ + CAN_UPDATE + CAN_DELETE + CAN_LIST

            AddProperty( loParam, "nPermisos", lnPermisos )

            loTipo_Comprobante = GetEntity( "Tipo_Comprobante" )
            loTipo_Comprobante.Initialize( loParam )
            loTipo_Comprobante.oParent.nId = loRegistro.Id

            AddProperty( loParam, "oBiz", loTipo_Comprobante )

            *loTipo_Comprobante.BulkCreate()

            Do Form (loTipo_Comprobante.cGrilla) ;
                With loParam To loStatus


            *!*	            If Vartype( loStatus ) == "O"
            *!*	                llReturn = ( loStatus.lCancelar = .F. )
            *!*	            Endif

            *!*	            If !llReturn
            This.nTotalDeRegistros = lnTotalDeRegistros
            This.nCurrentPage = lnCurrentPage
            This.cUrlNext = lcUrlNext
            This.cUrlPrevious = lcUrlPrevious
            This.nLastPage = lnLastPage
            *!*	            Endif


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

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oComprobante_Base
*!*
*!* ///////////////////////////////////////////////////////

