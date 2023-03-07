#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Rubro_Proveedor( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loRubro As oRubroProveedor Of "Clientes\Archivos\prg\Rubro_Proveedor.prg.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loRubro = GetEntity( "Rubro_Proveedor" )
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
*!* Class.........: oRubroProveedor
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oRubroProveedor As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oRubroProveedor Of "Clientes\Archivos\prg\Rubro_Proveedor.prg.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 			= "Rubro_Proveedor"

	cFormIndividual = "Clientes\Archivos\Scx\Rubro_Proveedor.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Rubros_Proveedor.scx"

	cTituloEnForm 	= "Rubro"
	cTituloEnGrilla = "Rubros"
	
	cURL 			= "archivos/apis/RubroProveedor/"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oRubroProveedor
*!*
*!* ///////////////////////////////////////////////////////
