#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Unidad_Medida( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loUnidad_Medida As oUnidad_Medida Of "Clientes\Archivos\prg\Unidad_Medida.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loUnidad_Medida = GetEntity( "Unidad_Medida" )
		loUnidad_Medida.Initialize( loParam )

		AddProperty( loParam, "oBiz", loUnidad_Medida )

		Do Form (loUnidad_Medida.cGrilla) ;
			With loParam To loReturn


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loUnidad_Medida = Null

	Endtry

Endproc && Unidad_Medida

*!* ///////////////////////////////////////////////////////
*!* Class.........: oUnidad_Medida
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oUnidad_Medida As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oUnidad_Medida Of "Clientes\Archivos\prg\Unidad_Medida.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 		= "Unidad_Medida"

	cFormIndividual = "Clientes\Archivos\Scx\Unidad_Medida.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Unidad_Medidas.scx"

	cTituloEnForm 	= "Unidad de Medida"
	cTituloEnGrilla = "Unidades de Medidas"

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

			This.cURL = "archivos/apis/Unidad_Medida/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oUnidad_Medida
*!*
*!* ///////////////////////////////////////////////////////
