#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure MercadoLibre( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loMercadoLibre As oMercadoLibre Of "Clientes\MercadoLibre\prg\MercadoLibre.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loMercadoLibre = GetEntity( "MercadoLibre" )
		loMercadoLibre.Initialize( loParam )

		AddProperty( loParam, "oBiz", loMercadoLibre )

		Do Form (loMercadoLibre.cGrilla) ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loMercadoLibre = Null

	Endtry

Endproc && MercadoLibre

*!* ///////////////////////////////////////////////////////
*!* Class.........: oMercadoLibre
*!* Description...:
*!* Date..........: Lunes 29 de Noviembre de 2021 (09:45:06)
*!*
*!*

Define Class oMercadoLibre As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oMercadoLibre Of "Clientes\MercadoLibre\prg\MercadoLibre.prg"
	#Endif

	lEditInBrowse 	= .F.
	cModelo 		= "MercadoLibre"
	cTabla 			= "ML_Settings"

	cFormIndividual = "Clientes\MercadoLibre\Scx\MercadoLibre.scx"
	cGrilla 		= "Clientes\MercadoLibre\Scx\MercadoLibre_Grilla.scx"

	cTituloEnForm 	= "Seteos Mercado Libre"
	cTituloEnGrilla = "Seteos Mercado Libre"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="registrarse" type="method" display="Registrarse" />] + ;
		[</VFPData>]




	*
	*
	Procedure Registrarse( loRegistro as Object ) as Boolean 
		Local lcCommand As String
		Local loMeLi As oMeLi Of "Clientes\MercadoLibre\Prg\M_Libre.prg"
		Local llOk as Boolean 

		Try

			lcCommand = ""
			*Inform( Program() )
			
			loMeLi = NewObject( "oMeLi", "Clientes\MercadoLibre\Prg\M_Libre.prg" )
			loMeLi.oMlUser = loRegistro  
			llOk = loMeLi.Registrarse()   


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

			This.cURL = "meli/apis/MeLi/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oMercadoLibre
*!*
*!* ///////////////////////////////////////////////////////

