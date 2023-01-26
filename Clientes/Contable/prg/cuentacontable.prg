#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure CuentaContable( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loCuentaContable As oCuentaContable Of "Clientes\Contable\prg\CuentaContable.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loCuentaContable = GetEntity( "Cuenta_Contable" )
		loCuentaContable.Initialize( loParam )

		AddProperty( loParam, "oBiz", loCuentaContable )

		Do Form (loCuentaContable.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loCuentaContable = Null

	Endtry

Endproc && CuentaContable

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCuentaContable
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oCuentaContable As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oCuentaContable Of "Clientes\Contable\prg\CuentaContable.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 		= "Cuenta_Contable"

	cFormIndividual = "Clientes\Contable\Scx\CuentaContable.scx"
	cGrilla 		= "Clientes\Contable\Scx\CuentasContables.scx"

	cTituloEnForm 	= "Cuenta Contable"
	cTituloEnGrilla = "Cuentas Contables"

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

			This.cURL = "contable/apis/Cuenta/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCuentaContable
*!*
*!* ///////////////////////////////////////////////////////
