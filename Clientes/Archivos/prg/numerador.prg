#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Numerador( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loNumerador As oNumerador Of "Clientes\Archivos\prg\Numerador.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loNumerador = GetEntity( "Numerador" )
		loNumerador.Initialize( loParam )

		AddProperty( loParam, "oBiz", loNumerador )

		Do Form (loNumerador.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loNumerador = Null

	Endtry

Endproc && Numerador

*!* ///////////////////////////////////////////////////////
*!* Class.........: oNumerador
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oNumerador As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oNumerador Of "Clientes\Archivos\prg\Numerador.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 		= "Numerador"

	cFormIndividual = "Clientes\Archivos\Scx\Numerador.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Numeradores.scx"

	cTituloEnForm 	= "Numerador"
	cTituloEnGrilla = "Numeradores"
	
	cURL = "comunes/apis/Numerador/"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oNumerador
*!*
*!* ///////////////////////////////////////////////////////
