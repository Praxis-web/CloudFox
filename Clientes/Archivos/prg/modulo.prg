#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Modulo( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loModulo As oModulo Of "Clientes\Archivos\prg\Modulo.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loModulo = GetEntity( "Modulo" )
		loModulo.Initialize( loParam )

		AddProperty( loParam, "oBiz", loModulo )

		Do Form (loModulo.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loModulo = Null

	Endtry

Endproc && Modulo

*!* ///////////////////////////////////////////////////////
*!* Class.........: oModulo
*!* Description...:
*!* Date..........: Viernes 13 de Enero de 2023 (14:39:44)
*!*
*!*

Define Class oModulo As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oModulo Of "Clientes\Archivos\prg\Modulo.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 		= "Modulo"

	cFormIndividual = "Clientes\Archivos\Scx\Modulo.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Modulos.scx"

	cTituloEnForm 	= "Modulo"
	cTituloEnGrilla = "Modulos"

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

			This.cURL = "comunes/apis/Modulo/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oModulo
*!*
*!* ///////////////////////////////////////////////////////
