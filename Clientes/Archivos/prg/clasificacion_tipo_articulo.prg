#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Clasificacion_Tipo_Articulo( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loClasificacion_Tipo_Articulo As oClasificacion_Tipo_Articulo Of "Clientes\Archivos\prg\Clasificacion_Tipo_Articulo.prg",;
		loParam As Object


	Try

		lcCommand = ""
		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )
		
		loClasificacion_Tipo_Articulo = GetEntity( "Clasificacion_Tipo_Articulo" )
		loClasificacion_Tipo_Articulo.Initialize( loParam )

		AddProperty( loParam, "oBiz", loClasificacion_Tipo_Articulo )

		Do Form (loClasificacion_Tipo_Articulo.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loClasificacion_Tipo_Articulo = Null

	Endtry

Endproc && Clasificacion_Tipo_Articulo

*!* ///////////////////////////////////////////////////////
*!* Class.........: oClasificacion_Tipo_Articulo
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oClasificacion_Tipo_Articulo As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oClasificacion_Tipo_Articulo Of "Clientes\Archivos\prg\Clasificacion_Tipo_Articulo.prg"
	#Endif

	lEditInBrowse 	= .F.
	cModelo 		= "Clasificacion_Tipo_Articulo"

	cFormIndividual = "Clientes\Archivos\Scx\Clasificacion_Tipo_Articulo.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Clasificacion_Tipo_Articulos.scx"

	cTituloEnForm 	= "Clasificación de Tipo de Artículo"
	cTituloEnGrilla = "Clasificaciones de Tipos de Artículos"

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

			This.cURL = "archivos/apis/Clasificacion_Tipo_Articulo/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oClasificacion_Tipo_Articulo
*!*
*!* ///////////////////////////////////////////////////////
