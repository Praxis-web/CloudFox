#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure ComprobanteVenta( nPermisos As Integer,;
        nAcciones As Integer,;
        nParam3 As Integer,;
        nParam4 As Integer,;
        nParam5 As Integer,;
        cURL As String,;
        lDoPrg ) As Void

    Local lcCommand As String
    Local loVentas As oComprobanteVenta Of "Clientes\Ventas\Prg\ComprobanteVenta.prg",;
    loParam as Object,;
    loRegistro as Object 

    Try

        lcCommand = ""
        
        loParam = Createobject( "Empty" )
        
        AddProperty( loParam, "nPermisos", nPermisos )
        AddProperty( loParam, "nAcciones", nAcciones )
        AddProperty( loParam, "cURL", cURL  )

        loVentas = GetEntity( "Ventas_Header" )
        loVentas.Initialize( loParam )

        AddProperty( loParam, "oBiz", loVentas )
		
		Do Case
		Case nAcciones = DO_READ		
	        Do Form ( loVentas.cGrilla ) ;
	            With loParam To loReturn
	            
	    Case nAcciones = DO_CREATE
	        loRegistro = Createobject( "Empty" )
    		AddProperty( loRegistro, "ABM", ABM_ALTA )
    		AddProperty( loRegistro, loVentas.cPKField, 0 )
    		loVentas.LaunchEditForm( loRegistro )  

		Otherwise

		EndCase
		 
    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally
    	loParam 	= Null
    	loRegistro 	= Null
    	loVentas 	= Null   

    Endtry

Endproc && ComprobanteVenta

*!* ///////////////////////////////////////////////////////
*!* Class.........: oComprobanteVenta
*!* Description...:
*!* Date..........: Viernes 3 de Marzo de 2023 (14:11:09)
*!*
*!*

Define Class oComprobanteVenta As oComprobante Of "FrontEnd\Prg\Comprobante.prg"

    #If .F.
        Local This As oComprobanteVenta Of "Clientes\Ventas\Prg\ComprobanteVenta.prg"
    #Endif

    cModelo 		= "Ventas_Header"

    cFormIndividual = "Clientes\Ventas\Scx\Comprobante_Venta.scx"
    cGrilla 		= "Clientes\Ventas\Scx\Comprobantes_Venta.scx"

    cTituloEnForm 	= "Comprobante de Venta"
    cTituloEnGrilla = "Comprobantes de Venta"

    cURL 			= "ventas/apis/Comprobantes/"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oComprobanteVenta
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oComprobanteVenta_Detail
*!* Description...:
*!* Date..........: Viernes 3 de Marzo de 2023 (14:11:09)
*!*
*!*

Define Class oComprobanteVenta_Detail As oComprobante_Detail Of "FrontEnd\Prg\Comprobante.prg"

    #If .F.
        Local This As oComprobanteVenta_Detail Of "Clientes\Ventas\Prg\ComprobanteVenta.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oComprobanteVenta
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oComprobanteVenta_Footer
*!* Description...:
*!* Date..........: Viernes 3 de Marzo de 2023 (14:11:09)
*!*
*!*

Define Class oComprobanteVenta_Footer As oComprobante_Footer Of "FrontEnd\Prg\Comprobante.prg"

    #If .F.
        Local This As oComprobanteVenta_Footer Of "Clientes\Ventas\Prg\ComprobanteVenta.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oComprobanteVenta_Footer
*!*
*!* ///////////////////////////////////////////////////////


