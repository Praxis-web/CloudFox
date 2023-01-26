#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Color( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loColor As oColor Of "Clientes\Archivos\prg\Color.prg",;
		loParam As Object


	Try

		lcCommand = ""
		
		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )

		loColor = GetEntity( "Color" )
		loColor.Initialize( loParam )

		AddProperty( loParam, "oBiz", loColor )

		Do Form (loColor.cGrilla) ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loColor = Null

	Endtry

Endproc && Color

*!* ///////////////////////////////////////////////////////
*!* Class.........: oColor
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oColor As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oColor Of "Clientes\Archivos\prg\Color.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.

	cModelo 		= "Color"

	cFormIndividual = "Clientes\Archivos\Scx\Color.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Colors.scx"

	cTituloEnForm 	= "Color"
	cTituloEnGrilla = "Colors"
	
	cURL 			= "archivos/apis/Color/"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oColor
*!*
*!* ///////////////////////////////////////////////////////
