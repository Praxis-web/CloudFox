#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Transporte( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loTransporte As oTransporte Of "Clientes\Archivos\prg\Transporte.prg",;
		loParam As Object


	Try

		lcCommand = ""
		
		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )

		loTransporte = GetEntity( "Transporte" )
		loTransporte.Initialize( loParam )

		AddProperty( loParam, "oBiz", loTransporte )

		Do Form (loTransporte.cGrilla) ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loTransporte = Null

	Endtry

Endproc && Transporte

*!* ///////////////////////////////////////////////////////
*!* Class.........: oTransporte
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oTransporte As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oTransporte Of "Clientes\Archivos\prg\Transporte.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 			= "Transporte"

	cFormIndividual = "Clientes\Archivos\Scx\Transporte.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Transportes.scx"

	cTituloEnForm 	= "Transporte"
	cTituloEnGrilla = "Transportes"
	
	cURL 			= "archivos/apis/Transporte/"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oTransporte
*!*
*!* ///////////////////////////////////////////////////////
