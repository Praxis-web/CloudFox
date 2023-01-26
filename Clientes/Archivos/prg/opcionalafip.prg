#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure OpcionalAfip( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local oOpcionalAfip As oOpcionalAfip Of "Clientes\Archivos\prg\OpcionalAfip.prg"
	Local loOpcionales_Afip As oOpcionales_Afip Of "Clientes\Archivos\prg\OpcionalAfip.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loOpcionales_Afip = GetEntity( "Afip_Opcional" )
		loOpcionales_Afip.Initialize( loParam )

		AddProperty( loParam, "oBiz", loOpcionales_Afip )

		Do Form 'Clientes\Archivos\Scx\OpcionalesAfip.scx' ;
			With loParam To loReturn


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loOpcionalAfip = Null

	Endtry

Endproc && OpcionalAfip

*!* ///////////////////////////////////////////////////////
*!* Class.........: oOpcionales_Afip
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oOpcionales_Afip As oModelo_Afip Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oOpcionales_Afip Of "Clientes\Archivos\prg\OpcionalAfip.prg"
	#Endif

	cTablaAfip = "Opcionales"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oOpcionales_Afip
*!*
*!* ///////////////////////////////////////////////////////

