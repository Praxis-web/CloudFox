#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Tipo_Articulo( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loTipo_Articulo As oTipo_Articulo Of "Clientes\Archivos\prg\Tipo_Articulo.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loTipo_Articulo = GetEntity( "Tipo_Articulo" )
		loTipo_Articulo.Initialize( loParam )

		AddProperty( loParam, "oBiz", loTipo_Articulo )

		Do Form (loTipo_Articulo.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loTipo_Articulo = Null

	Endtry

Endproc && Tipo_Articulo

*!* ///////////////////////////////////////////////////////
*!* Class.........: oTipo_Articulo
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oTipo_Articulo As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oTipo_Articulo Of "Clientes\Archivos\prg\Tipo_Articulo.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 		= "Tipo_Articulo"

	cFormIndividual = "Clientes\Archivos\Scx\Tipo_Articulo.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Tipo_Articulos.scx"

	cTituloEnForm 	= "Tipo de Artículo"
	cTituloEnGrilla = "Tipos de Artículos"

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

			This.cURL = "archivos/apis/Tipo_Articulo/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oTipo_Articulo
*!*
*!* ///////////////////////////////////////////////////////
