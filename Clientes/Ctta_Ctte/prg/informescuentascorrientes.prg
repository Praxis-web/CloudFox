#INCLUDE "FW\Comunes\Include\Praxis.h"


*
* 
PROCEDURE InformesCuentasCorrientes( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) AS Void
		
	Local lcCommand as String
	Local loInforme As oInforme_Ctta_Ctte Of "Clientes\Ctta_Ctte\Prg\InformesCuentasCorrientes.prg"
	
	Try
	
		lcCommand = ""
		loInforme = ""
		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )

		loInforme = GetEntity( "CttaCtte" )
		loInforme.Initialize( loParam )

		AddProperty( loParam, "oBiz", loInforme )
		AddProperty( loParam, "cModelo", "CttaCtte" )

		Do Form ( loInforme.cFormularioInformes ) ;
			With loParam To loReturn
		
	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	EndTry

EndProc && InformesCuentasCorrientes

*!* ///////////////////////////////////////////////////////
*!* Class.........: oInforme_Ctta_Ctte
*!* Description...:
*!* Date..........: Viernes 31 de Diciembre de 2021 (10:20:33)
*!*
*!*

Define Class oInforme_Ctta_Ctte As oCttaCtte Of "Clientes\Ctta_Ctte\prg\CttaCtte.prg"
	
	#If .F.
		Local This As oInforme_Ctta_Ctte Of "Clientes\Ctta_Ctte\prg\InformesCuentasCorrientes.prg"
	#Endif 

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oInforme_Ctta_Ctte
*!*
*!* ///////////////////////////////////////////////////////




