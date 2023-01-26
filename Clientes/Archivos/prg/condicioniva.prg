#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure CondicionIva( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void
	Local lcCommand As String
	Local loCrudSimple As oCrudSimple Of "FrontEnd\Prg\CrudSimple.prg"
	Local loCondicion_Iva As oCondicion_Iva Of "Clientes\Archivos\prg\CondicionIva.prg",;
		loParam As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )
		
		loCondicion_Iva = GetEntity( "Condicion_Iva" )
		loCondicion_Iva.Initialize( loParam )

		AddProperty( loParam, "oBiz", loCondicion_Iva )

		Do Form ( loCondicion_Iva.cGrilla ) ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loCrudSimple 	= Null
		loCondicion_Iva = Null
		loParam 		= Null

	Endtry

Endproc && CondicionIva

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCondicion_Iva
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oCondicion_Iva As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oCondicion_Iva Of "Clientes\Archivos\prg\CondicionIva.prg"
	#Endif
	
	cModelo = "Condicion_Iva"

	cFormIndividual = "Clientes\Archivos\Scx\CondicionIva.scx"
	cGrilla 		= "Clientes\Archivos\Scx\CondicionesIva.scx"

	cTituloEnGrilla = "Condiciones Frente al Iva"
	cTituloEnForm = "Condición Frente al Iva"

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

			This.cURL = "sistema/apis/Condicion_Iva/"


		Endif

		Return This.cURL

	Endproc && cUrl_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCondicion_Iva
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oSistema_Condicion_Iva_Documentos
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oSistema_Condicion_Iva_Documentos As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oSistema_Condicion_Iva_Documentos Of "Clientes\Archivos\prg\CondicionIva.prg"
	#Endif
	
	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo = "oSistema_Condicion_Iva_Documentos"
	This.lIsChild = .T.
	This.cParent = "Condicion_Iva"


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

			This.cURL = "sistema/apis/Condicion_Iva/"


		Endif

		Return This.cURL

	Endproc && cUrl_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oSistema_Condicion_Iva_Documentos
*!*
*!* ///////////////////////////////////////////////////////

