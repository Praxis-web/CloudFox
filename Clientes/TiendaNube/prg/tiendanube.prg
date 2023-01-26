#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure TiendaNube( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loTiendaNube As oTiendaNube Of "Clientes\TiendaNube\prg\TiendaNube.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loTiendaNube = GetEntity( "TiendaNube" )
		loTiendaNube.Initialize( loParam )

		AddProperty( loParam, "oBiz", loTiendaNube )

		Do Form (loTiendaNube.cGrilla) ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loTiendaNube = Null

	Endtry

Endproc && TiendaNube

*!* ///////////////////////////////////////////////////////
*!* Class.........: oTiendaNube
*!* Description...:
*!* Date..........: Lunes 29 de Noviembre de 2021 (09:45:06)
*!*
*!*

Define Class oTiendaNube As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oTiendaNube Of "Clientes\TiendaNube\prg\TiendaNube.prg"
	#Endif

	lEditInBrowse 	= .F.
	cModelo 		= "TiendaNube"
	cTabla 			= "TN_Settings"

	cFormIndividual = "Clientes\TiendaNube\Scx\TiendaNube.scx"
	cGrilla 		= "Clientes\TiendaNube\Scx\TiendaNube_Grilla.scx"

	cTituloEnForm 	= "Seteos Tienda Nube"
	cTituloEnGrilla = "Seteos Tienda Nube"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="registrarse" type="method" display="Registrarse" />] + ;
		[</VFPData>]


	*
	*
	Procedure Registrarse( loRegistro as Object ) as Boolean 
		Local lcCommand As String
		Local loTienda As oTienda Of "Clientes\TiendaNube\Prg\Main_TiendaNube.prg"
		Local llOk as Boolean 

		Try

			lcCommand = ""
			*Inform( Program() )
			
			loTienda = NewObject( "oTienda", "Clientes\TiendaNube\Prg\Main_TiendaNube.prg" )
			loTienda.oTiendaUser = loRegistro  
			llOk = loTienda.Registrarse()   


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		EndTry
		
		Return llOk  

	Endproc && Registrarse


	*
	* cUrl_Access
	Procedure cUrl_Access()

		If Empty( Alltrim( This.cURL ))
			* Inicializar la URL
			* Puede ponerse duro para cada modelo,
			* o leerse de un archivo de configuración local
			* para una personalización especial

			This.cURL = "tienda_nube/apis/TiendaNube/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oTiendaNube
*!*
*!* ///////////////////////////////////////////////////////

