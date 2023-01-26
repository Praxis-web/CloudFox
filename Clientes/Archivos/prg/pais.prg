#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Pais( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loPais As oPais Of "Clientes\Archivos\prg\Pais.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loPais = GetEntity( "Pais" )
		loPais.Initialize( loParam )

		AddProperty( loParam, "oBiz", loPais )

		Do Form (loPais.cGrilla) ;
			With loParam To loReturn



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loPais = Null

	Endtry

Endproc && Pais

*!* ///////////////////////////////////////////////////////
*!* Class.........: oPais
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oPais As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oPais Of "Clientes\Archivos\prg\Pais.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 		= "Pais"

	cFormIndividual = "Clientes\Archivos\Scx\Pais.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Paises.scx"

	cTituloEnForm 	= "País"
	cTituloEnGrilla = "Paises"

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

			This.cURL = "sistema/apis/Pais/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oPais
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oProvincia
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oProvincia As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oProvincia Of "Clientes\Archivos\prg\Pais.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 		= "Provincia"

	cFormIndividual = "Clientes\Archivos\Scx\Provincia.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Pais.scx"

	cURL 			= "sistema/apis/Provincia/"

	cTituloEnForm 	= "Provincia"
	cTituloEnGrilla = "Provincias"

	lIsChild 		= .T.
	cParent 		= "Pais"

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

			This.cURL = "sistema/apis/Provincia/"

		Endif

		Return This.cURL

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oProvincia
*!*
*!* ///////////////////////////////////////////////////////

