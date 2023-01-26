#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Presentacion( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loPresentacion As oPresentacion Of "Clientes\Archivos\prg\Presentacion.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loPresentacion = GetEntity( "Presentacion" )
		loPresentacion.Initialize( loParam )

		AddProperty( loParam, "oBiz", loPresentacion )

		Do Form (loPresentacion.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loPresentacion = Null

	Endtry

Endproc && Presentacion

*!* ///////////////////////////////////////////////////////
*!* Class.........: oPresentacion
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oPresentacion As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oPresentacion Of "Clientes\Archivos\prg\Presentacion.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 		= "Presentacion"

	cFormIndividual = "Clientes\Archivos\Scx\Presentacion.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Presentaciones.scx"

	cTituloEnForm 	= "Presentación"
	cTituloEnGrilla = "Presentaciones"

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

			This.cURL = "archivos/apis/Presentacion/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oPresentacion
*!*
*!* ///////////////////////////////////////////////////////
