#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Zona( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loZona As oZona Of "Clientes\Archivos\prg\Zona.prg",;
		loParam As Object


	Try

		lcCommand = ""
		
		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )

		loZona = GetEntity( "Zona" )
		loZona.Initialize( loParam )

		AddProperty( loParam, "oBiz", loZona )

		Do Form (loZona.cGrilla) ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loZona = Null

	Endtry

Endproc && Zona

*!* ///////////////////////////////////////////////////////
*!* Class.........: oZona
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oZona As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oZona Of "Clientes\Archivos\prg\Zona.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 			= "Zona"

	cFormIndividual = "Clientes\Archivos\Scx\Zona.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Zonas.scx"

	cTituloEnForm 	= "Zona"
	cTituloEnGrilla = "Zonas"
	
	cURL 			= "archivos/apis/Zona/"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oZona
*!*
*!* ///////////////////////////////////////////////////////
