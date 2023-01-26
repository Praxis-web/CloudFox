
*
* 
PROCEDURE Empresa_ML( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loEmpresa As oEmpresa_ML Of "Clientes\MercadoLibre\prg\Empresa_ML.prg",;
		loParam As Object


	Try

		lcCommand = ""

			loParam = Createobject( "Empty" )

			AddProperty( loParam, "nPermisos", nPermisos )
			AddProperty( loParam, "cURL", cURL  )

			loEmpresa = NewObject( "oEmpresa_ML", "Clientes\MercadoLibre\prg\Empresa_ML.prg" )
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

EndProc && Empresa_ML

*!* ///////////////////////////////////////////////////////
*!* Class.........: oEmpresa_ML
*!* Description...:
*!* Date..........: Martes 18 de Enero de 2022 (18:50:46)
*!*
*!*

Define Class oEmpresa_ML As oEmpresa Of "Clientes\Archivos\prg\Empresa.prg"
	
	#If .F.
		Local This As oEmpresa_ML Of "Clientes\MercadoLibre\prg\Empresa_ML.prg"
	#Endif

	cFormIndividual = "Clientes\MercadoLibre\Scx\Empresa_ML.scx"
	cGrilla 		= "Clientes\MercadoLibre\Scx\Empresas_ML.scx"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oEmpresa_ML
*!*
*!* ///////////////////////////////////////////////////////



