#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure ConceptoAfip( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local oConceptoAfip As oConceptoAfip Of "Clientes\Archivos\prg\ConceptoAfip.prg"
	Local loConcepto_Afip As oConcepto_Afip Of "Clientes\Archivos\prg\ConceptoAfip.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loConcepto_Afip = GetEntity( "Afip_Concepto" )
		loConcepto_Afip.Initialize( loParam )

		AddProperty( loParam, "oBiz", loConcepto_Afip )

		Do Form 'Clientes\Archivos\Scx\ConceptosAfip.scx' ;
			With loParam To loReturn


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loConceptoAfip = Null

	Endtry

Endproc && ConceptoAfip

*!* ///////////////////////////////////////////////////////
*!* Class.........: oConcepto_Afip
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oConcepto_Afip As oModelo_Afip Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oConcepto_Afip Of "Clientes\Archivos\prg\ConceptoAfip.prg"
	#Endif

	cTablaAfip = "Conceptos"
	cTabla = "Afip_Concepto"

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

			This.cURL = "sistema/apis/Afip_Concepto/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oConcepto_Afip
*!*
*!* ///////////////////////////////////////////////////////

