#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Tipo_Comprobante( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loTipo_Comprobante As oTipo_Comprobante Of "Clientes\Archivos\prg\Tipo_Comprobante.prg",;
		loParam As Object


	Try

		lcCommand = ""
		loParam = Createobject( "Empty" )
		
		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loTipo_Comprobante = GetEntity( "Tipo_Comprobante" )
		loTipo_Comprobante.Initialize( loParam )

		AddProperty( loParam, "oBiz", loTipo_Comprobante )

		*loTipo_Comprobante.BulkCreate()

		Do Form (loTipo_Comprobante.cGrilla) ;
			With loParam To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loTipo_Comprobante = Null

	Endtry

Endproc && Tipo_Comprobante

*!* ///////////////////////////////////////////////////////
*!* Class.........: oTipo_Comprobante
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oTipo_Comprobante As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oTipo_Comprobante Of "Clientes\Archivos\prg\Tipo_Comprobante.prg"
	#Endif

	*lEditInBrowse 	= .T.
	cModelo 		= "Tipo_Comprobante"

	cFormIndividual = "Clientes\Archivos\Scx\Tipo_Comprobante.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Tipos_Comprobante.scx"

	cURL 			= "comunes/apis/Tipo_Comprobante/"

	cTituloEnForm 	= "Tipo de Comprobante"
	cTituloEnGrilla = "Tipos de Comprobantes"

	lIsChild 		= .T.
	cParent 		= "Comprobante_Base"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*
	*
	Procedure HookBeforeGetByWhere( oParam As Object ) As Object
		Local lcCommand As String
		Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
			loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
			loField As oField Of 'Tools\DataDictionary\prg\oField.prg'

		Try

			lcCommand = ""
			loArchivo = This.GetTable( This.cTabla )
			loColFields = loArchivo.oColFields

			loField = loColFields.New( "Comprobante_Base_nombre", "C", 100 )
			loField.lShowInGrid = !This.lIsChild

			loField = loColFields.New( "orden", "N", 6, 0 )
			loField.lShowInGrid = This.lIsChild

			If !This.lIsChild
				If Pemstatus( oParam, "oFilterCriteria", 5 )
					loFilterCriteria = oParam.oFilterCriteria

				Else
					loFilterCriteria = This.oFilterCriteria
					AddProperty( oParam, "oFilterCriteria", loFilterCriteria )

				Endif

				loFiltro = Createobject( "Empty" )
				AddProperty( loFiltro, "Nombre", "showField_Comprobante_Base"  )
				AddProperty( loFiltro, "FieldName", "showField" )
				AddProperty( loFiltro, "FieldRelation", "==" )
				AddProperty( loFiltro, "FieldValue", "Comprobante_Base__nombre" )

				loFilterCriteria.RemoveItem( Lower( loFiltro.Nombre ) )
				loFilterCriteria.Add( loFiltro, Lower( loFiltro.Nombre ))

				loFiltro = Createobject( "Empty" )
				AddProperty( loFiltro, "Nombre", "OrderBy"  )
				AddProperty( loFiltro, "FieldName", "ordering" )
				AddProperty( loFiltro, "FieldRelation", "=" )
				AddProperty( loFiltro, "FieldValue", "nombre" )

				loFilterCriteria.RemoveItem( Lower( loFiltro.Nombre ) )
				loFilterCriteria.Add( loFiltro, Lower( loFiltro.Nombre ))

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loField 	= Null
			loColFields = Null
			loArchivo 	= Null

		Endtry

		Return oParam

	Endproc && HookBeforeGetByWhere

	*
	* cUrl_Access
	Procedure cUrl_Access()

		If Empty( Alltrim( This.cURL ))
			* Inicializar la URL
			* Puede ponerse duro para cada modelo,
			* o leerse de un archivo de configuración local
			* para una personalización especial

			This.cURL = "comunes/apis/Tipo_Comprobante/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oTipo_Comprobante
*!*
*!* ///////////////////////////////////////////////////////

