#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\FE\Include\FE.h"

*
*
Procedure ComprobanteAfip( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local oComprobanteAfip As oComprobanteAfip Of "Clientes\Archivos\prg\ComprobanteAfip.prg"
	Local loComprobante_Afip As oComprobante_Afip Of "Clientes\Archivos\prg\ComprobanteAfip.prg",;
		loParam As Object


	Try

		lcCommand = ""

		*Inform( "Windows" )
		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loComprobante_Afip = GetEntity( "Afip_Comprobante" )
		loComprobante_Afip.Initialize( loParam )

		AddProperty( loParam, "oBiz", loComprobante_Afip )

		Do Form 'Clientes\Archivos\Scx\ComprobantesAfip.scx' ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loComprobanteAfip = Null

	Endtry

Endproc && ComprobanteAfip

*!* ///////////////////////////////////////////////////////
*!* Class.........: oComprobante_Afip
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oComprobante_Afip As oModelo_Afip Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oComprobante_Afip Of "Clientes\Archivos\prg\ComprobanteAfip.prg"
	#Endif

	cTablaAfip = "comprobantes"
	cTabla = "Afip_Comprobante"

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

			This.cURL = "sistema/apis/Afip_Comprobante/"


		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oComprobante_Afip
*!*
*!* ///////////////////////////////////////////////////////

