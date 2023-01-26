#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure IvaAfip( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loIva_Afip As oIva_Afip Of "Clientes\Archivos\prg\IvaAfip.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loIva_Afip = GetEntity( "Afip_Alicuota_Iva" )
		loIva_Afip.Initialize( loParam )

		AddProperty( loParam, "oBiz", loIva_Afip )

		Do Form 'Clientes\Archivos\Scx\IvasAfip.scx' ;
			With loParam To loReturn


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loIvaAfip = Null

	Endtry

Endproc && IvaAfip

*!* ///////////////////////////////////////////////////////
*!* Class.........: oIva_Afip
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oIva_Afip As oModelo_Afip Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oIva_Afip Of "Clientes\Archivos\prg\IvaAfip.prg"
	#Endif

	cTablaAfip = "Ivas"
	cTabla = "Afip_Alicuota_Iva"

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

			This.cURL = "sistema/apis/Afip_Alicuota_Iva/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oIva_Afip
*!*
*!* ///////////////////////////////////////////////////////

