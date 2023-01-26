#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Empresa( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loEmpresa As oEmpresa Of "Clientes\Archivos\prg\Empresa.prg",;
		loParam As Object


	Try

		lcCommand = ""

			loParam = Createobject( "Empty" )

			AddProperty( loParam, "nPermisos", nPermisos )
			AddProperty( loParam, "cURL", cURL  )

			loEmpresa = GetEntity( "Empresa" )
			loEmpresa.Initialize( loParam )

			AddProperty( loParam, "oBiz", loEmpresa )

			Do Form (loEmpresa.cGrilla) ;
				With loParam To loReturn


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loEmpresa = Null

	Endtry

Endproc && Empresa

*!* ///////////////////////////////////////////////////////
*!* Class.........: oEmpresa
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oEmpresa As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oEmpresa Of "Clientes\Archivos\prg\Empresa.prg"
	#Endif

	lEditInBrowse 		= .F.

	cModelo 		= "Empresa"

	cFormIndividual = "Clientes\Archivos\Scx\Empresa.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Empresas.scx"

	cTituloEnForm 	= "Empresa"
	cTituloEnGrilla = "Empresas"
	
	lIsChild 		= .T.
	cParent 		= "Cliente_Praxis"
	
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

    *
    *
    Procedure ObtenerPermisos( nPermisos As Integer ) As Void
        Local lcCommand As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"


        Try

            lcCommand = ""

            DoDefault( nPermisos )

            If This.lShowCamposEspeciales
                This.lEditInBrowse 		= .F.
                This.lShowEditInBrowse 	= .T.
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loUser = Null

        Endtry

    Endproc && ObtenerPermisos


	*
	* cUrl_Access
	Procedure cUrl_Access()

		If Empty( Alltrim( This.cURL ))
			* Inicializar la URL
			* Puede ponerse duro para cada modelo,
			* o leerse de un archivo de configuración local
			* para una personalización especial
			
			This.cURL = "comunes/apis/Empresa/"


		EndIf

		Return This.cURL 

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oEmpresa
*!*
*!* ///////////////////////////////////////////////////////