#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Rubro( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loRubro As oRubro Of "Clientes\Archivos\prg\Rubro.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loRubro = GetEntity( "Rubro" )
		loRubro.Initialize( loParam )

		AddProperty( loParam, "oBiz", loRubro )

		Do Form (loRubro.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loRubro = Null

	Endtry

Endproc && Rubro

*!* ///////////////////////////////////////////////////////
*!* Class.........: oRubro
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oRubro As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oRubro Of "Clientes\Archivos\prg\Rubro.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 			= "Rubro"

	cFormIndividual = "Clientes\Archivos\Scx\Rubro.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Rubros.scx"

	cTituloEnForm 	= "Rubro"
	cTituloEnGrilla = "Rubros"

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

			This.cURL = "archivos/apis/Rubro/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oRubro
*!*
*!* ///////////////////////////////////////////////////////
