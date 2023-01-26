#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Talle( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loTalle As oTalle Of "Clientes\Archivos\prg\Talle.prg",;
		loParam As Object


	Try

		lcCommand = ""
		
		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )

		loTalle = GetEntity( "Talle" )
		loTalle.Initialize( loParam )

		AddProperty( loParam, "oBiz", loTalle )

		Do Form (loTalle.cGrilla) ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loTalle = Null

	Endtry

Endproc && Talle

*!* ///////////////////////////////////////////////////////
*!* Class.........: oTalle
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oTalle As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oTalle Of "Clientes\Archivos\prg\Talle.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 			= "Talle"

	cFormIndividual = "Clientes\Archivos\Scx\Talle.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Talles.scx"

	cTituloEnForm 	= "Talle"
	cTituloEnGrilla = "Talles"
	
	cURL 			= "archivos/apis/Talle/"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oTalle
*!*
*!* ///////////////////////////////////////////////////////
