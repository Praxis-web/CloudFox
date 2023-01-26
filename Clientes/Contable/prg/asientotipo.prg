#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure AsientoTipo( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loAsientoTipo As oAsientoTipo Of "Clientes\Contable\prg\AsientoTipo.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loAsientoTipo = GetEntity( "Asiento_Tipo" )
		loAsientoTipo.Initialize( loParam )

		AddProperty( loParam, "oBiz", loAsientoTipo )

		Do Form (loAsientoTipo.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loAsientoTipo = Null

	Endtry

Endproc && AsientoTipo

*!* ///////////////////////////////////////////////////////
*!* Class.........: oAsientoTipo
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oAsientoTipo As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oAsientoTipo Of "Clientes\Contable\prg\AsientoTipo.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 		= "Asiento_Tipo"

	cFormIndividual = "Clientes\Contable\Scx\AsientoTipo.scx"
	cGrilla 		= "Clientes\Contable\Scx\AsientosTipo.scx"

	cTituloEnForm 	= "Asiento Tipo"
	cTituloEnGrilla = "Asientos Tipos"

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

			This.cURL = "contable/apis/AsientoTipo/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oAsientoTipo
*!*
*!* ///////////////////////////////////////////////////////
