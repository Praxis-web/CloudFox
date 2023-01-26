#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Marca( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loMarca As oMarca Of "Clientes\Archivos\prg\Marca.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loMarca = GetEntity( "Marca" )
		loMarca.Initialize( loParam )

		AddProperty( loParam, "oBiz", loMarca )

		Do Form (loMarca.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loMarca = Null

	Endtry

Endproc && Marca

*!* ///////////////////////////////////////////////////////
*!* Class.........: oMarca
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oMarca As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oMarca Of "Clientes\Archivos\prg\Marca.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 		= "Marca"

	cFormIndividual = "Clientes\Archivos\Scx\Marca.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Marcas.scx"

	cTituloEnForm 	= "Marca"
	cTituloEnGrilla = "Marcas"

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

			This.cURL = "archivos/apis/Marca/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oMarca
*!*
*!* ///////////////////////////////////////////////////////
