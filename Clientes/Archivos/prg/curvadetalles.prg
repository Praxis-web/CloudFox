*
* 
PROCEDURE CurvaDeTalles( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) AS Void
	
	Local lcCommand As String
	
	Local loCurvaDeTalles As oCurvaDeTalles Of "Clientes\Archivos\prg\CurvaDeTalles.prg",;
		loParam As Object


	Try

		lcCommand = ""
		
		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )

		loCurvaDeTalles = GetEntity( "Curva_Talle_Cab" )
		loCurvaDeTalles.Initialize( loParam )

		AddProperty( loParam, "oBiz", loCurvaDeTalles )

		Do Form (loCurvaDeTalles.cGrilla) ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loCurvaDeTalles = Null

	Endtry

EndProc && CurvaDeTalles

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCurvaDeTalles_Cab
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oCurvaDeTalles_Cab As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oCurvaDeTalles_Cab Of "Clientes\Archivos\prg\CurvaDeTalles.prg"
	#Endif

	lEditInBrowse 		= .T.
	lShowEditInBrowse 	= .T.
	cModelo 			= "Curva_Talle_Cab"

	cFormIndividual = "Clientes\Archivos\Scx\CurvaDeTalles.scx"
	cGrilla 		= "Clientes\Archivos\Scx\CurvasDeTalles.scx"

	cTituloEnForm 	= "Curva de Talles"
	cTituloEnGrilla = "Curvas de Talles"
	
	cURL 			= "archivos/apis/CurvaDeTallesCab/"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCurvaDeTalles_Cab
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCurvaDeTalles_Det
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oCurvaDeTalles_Det As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oCurvaDeTalles_Det Of "Clientes\Archivos\prg\CurvaDeTalles.prg"
	#Endif

	cModelo 		= "Curva_Talle_Det"

	cFormIndividual = "Clientes\Archivos\Scx\CurvaDeTallesDet.scx"
	cGrilla 		= ""

	cTituloEnForm 	= "Talle"
	cTituloEnGrilla = "Talles"
	
	cURL 			= "archivos/apis/CurvaDeTallesDet/"
	
	lIsChild 		= .T.
	cParent 		= "Curva_Talle_Cab"
	
	lFiltrarPorClientePraxis = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCurvaDeTalles_Det
*!*
*!* ///////////////////////////////////////////////////////
