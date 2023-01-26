#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Sucursal( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loSucursal As oSucursal Of "Clientes\Archivos\prg\Sucursal.prg",;
		loParam As Object


	Try

		lcCommand = ""

			loParam = Createobject( "Empty" )

			AddProperty( loParam, "nPermisos", nPermisos )
			AddProperty( loParam, "cURL", cURL  )

			loSucursal = GetEntity( "Sucursal" )
			loSucursal.Initialize( loParam )

			AddProperty( loParam, "oBiz", loSucursal )

			Do Form (loSucursal.cGrilla) ;
				With loParam To loReturn


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loSucursal = Null

	Endtry

Endproc && Sucursal

*!* ///////////////////////////////////////////////////////
*!* Class.........: oSucursal
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oSucursal As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oSucursal Of "Clientes\Archivos\prg\Sucursal.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.

	cModelo 		= "Sucursal"

	cFormIndividual = "Clientes\Archivos\Scx\Sucursal.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Sucursales.scx"

	cTituloEnForm 	= "Sucursal"
	cTituloEnGrilla = "Sucursales"
	
	lIsChild 		= .T.
	cParent 		= "Empresa"
	
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
			
			This.cURL = "comunes/apis/Sucursal/"


		EndIf

		Return This.cURL 

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oSucursal
*!*
*!* ///////////////////////////////////////////////////////