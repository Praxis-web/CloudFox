#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure DocumentoAfip( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local oDocumentoAfip As oDocumentoAfip Of "Clientes\Archivos\prg\DocumentoAfip.prg"
	Local loDocumento_Afip As oDocumento_Afip Of "Clientes\Archivos\prg\DocumentoAfip.prg",;
		loParam As Object


	Try

		lcCommand = ""
		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loDocumento_Afip = GetEntity( "Afip_Documento" )
		loDocumento_Afip.Initialize( loParam )

		AddProperty( loParam, "oBiz", loDocumento_Afip )

		Do Form ( loDocumento_Afip.cGrilla ) ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loDocumentoAfip = Null

	Endtry

Endproc && DocumentoAfip

*!* ///////////////////////////////////////////////////////
*!* Class.........: oDocumento_Afip
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oDocumento_Afip As oModelo_Afip Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oDocumento_Afip Of "Clientes\Archivos\prg\DocumentoAfip.prg"
	#Endif

	cModelo 	= "Afip_Documento"
	cTablaAfip 	= "Documentos"
	cTabla 		= "Afip_Documento"
	*cPKField 	= "Codigo"

	cTituloEnForm = "Tipo de Documento"
	cTituloEnGrilla = "Tipo de Documentos"

	cFormIndividual = "Clientes\Archivos\Scx\DocumentoAfip.scx"
	cGrilla 		= "Clientes\Archivos\Scx\DocumentosAfip.scx"

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

			This.cURL = "sistema/apis/Afip_Documento/"


		Endif

		Return This.cURL

	Endproc && cUrl_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oDocumento_Afip
*!*
*!* ///////////////////////////////////////////////////////

