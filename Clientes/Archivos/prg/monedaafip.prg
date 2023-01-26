#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure MonedaAfip( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local oMonedaAfip As oMonedaAfip Of "Clientes\Archivos\prg\MonedaAfip.prg"
	Local loMoneda_Afip As oMoneda_Afip Of "Clientes\Archivos\prg\MonedaAfip.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loMoneda_Afip = GetEntity( "Afip_Moneda" )
		loMoneda_Afip.Initialize( loParam )

		AddProperty( loParam, "oBiz", loMoneda_Afip )

		Do Form (loMoneda_Afip.cGrilla) ;
			With loParam To loReturn


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loMonedaAfip = Null

	Endtry

Endproc && MonedaAfip

*!* ///////////////////////////////////////////////////////
*!* Class.........: oMoneda_Afip
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oMoneda_Afip As oModelo_Afip Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oMoneda_Afip Of "Clientes\Archivos\prg\MonedaAfip.prg"
	#Endif

	cTablaAfip 		= "Monedas"
	cTabla 			= "Afip_Moneda"
	cFormIndividual = ""
	cGrilla 		= "Clientes\Archivos\Scx\MonedasAfip.scx"
	
	lEditInBrowse 	= .F.


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

			This.cURL = "sistema/apis/Afip_Moneda/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oMoneda_Afip
*!*
*!* ///////////////////////////////////////////////////////

