#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Vendedor( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loVendedor As oVendedor Of "Clientes\Archivos\prg\Vendedor.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loVendedor = GetEntity( "Vendedor" )
		loVendedor.Initialize( loParam )

		AddProperty( loParam, "oBiz", loVendedor )

		Do Form (loVendedor.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loVendedor = Null

	Endtry

Endproc && Vendedor

*!* ///////////////////////////////////////////////////////
*!* Class.........: oVendedor
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oVendedor As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oVendedor Of "Clientes\Archivos\prg\Vendedor.prg"
	#Endif

	lEditInBrowse 	= .F.
	cModelo 		= "Vendedor"

	cFormIndividual = "Clientes\Archivos\Scx\Vendedor.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Vendedores.scx"

	cTituloEnForm 	= "Presentación"
	cTituloEnGrilla = "Vendedores"

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

			This.cURL = "archivos/apis/Vendedor/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oVendedor
*!*
*!* ///////////////////////////////////////////////////////
