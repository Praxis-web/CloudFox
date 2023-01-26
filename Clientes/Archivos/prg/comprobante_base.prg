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

			This.cURL = "comunes/apis/Comprobante_Base/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oComprobante_Base
*!*
*!* ///////////////////////////////////////////////////////

