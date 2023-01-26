#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Grupo( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loGrupo As oGrupo Of "Clientes\Archivos\prg\Grupo.prg",;
		loParam As Object


	Try

		lcCommand = ""
		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loGrupo = GetEntity( "Grupo" )
		loGrupo.Initialize( loParam )

		AddProperty( loParam, "oBiz", loGrupo )

		*loGrupo.BulkCreate()

		Do Form (loGrupo.cGrilla) ;
			With loParam To loReturn


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loGrupo = Null

	Endtry

Endproc && Grupo

*!* ///////////////////////////////////////////////////////
*!* Class.........: oGrupo
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oGrupo As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oGrupo Of "Clientes\Archivos\prg\Grupo.prg"
	#Endif

	*lEditInBrowse 	= .T.
	cModelo 		= "Grupo"

	cFormIndividual = "Clientes\Archivos\Scx\Grupo.scx"
	cGrilla 		= "Clientes\Archivos\Scx\Grupos.scx"

	cTituloEnForm 	= "Grupo"
	cTituloEnGrilla = "Grupos"
	
	*lBulkUpdate 	= .T.

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
	*
	Procedure BulkCreate(  ) As Void
		Local lcCommand As String
		Local llOk As Boolean
		Local loReg As Object,;
		loData as Collection,;
		loCol as Collection 
		Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
			loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg"
		Local lnABM As Integer,;
			i As Integer


		Try

			lcCommand = ""

			*Inform( Program())
			This.oColErrors = Null
			llOk = .F.
			lnABM = ABM_ALTA

			loArchivo = This.GetTable( This.cTabla )
			loArchivo.CrearCursor( "cGrupos" )
			
			loCol = CreateObject( "Collection" ) 
			
			For i = 1 To 10

				loReg = ScatterReg( .T., "cGrupos" )
				loReg.nombre = "GRUPO " + StrZero( 300 + i, 3 )
				loReg.activo = .T.
				loReg.orden = 7
				loReg.codigo = StrZero( 300 + i, 3 )
				loReg.cliente_praxis = 1
				loReg.empresa = 1
				Append Blank
				Gather Name loReg
				
				loCol.Add( loReg ) 

			Endfor

			Browse

			Do Case
				Case lnABM = ABM_ALTA
					*Removeproperty( loReg, "Id" )

					loConsumirAPI 	= NewConsumirAPI()
					loRespuesta 	= loConsumirAPI.Crear( This.cURL, loCol )

					If loRespuesta.lOk
						Inform( "Ok" )

					Else
						This.ManejarErrores( loRespuesta.Data )
						This.nId = 0

					Endif
			EndCase
			
			If Isnull( This.oColErrors )
				llOk = .T.

			Else
				This.MostrarErrores()

			Endif
			


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && BulkCreate


	*
	* cUrl_Access
	Procedure cUrl_Access()

		If Empty( Alltrim( This.cURL ))
			* Inicializar la URL
			* Puede ponerse duro para cada modelo,
			* o leerse de un archivo de configuración local
			* para una personalización especial

			This.cURL = "archivos/apis/Grupo/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oGrupo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oSubGrupo
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oSubGrupo As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oSubGrupo Of "Clientes\Archivos\prg\Grupo.prg"
	#Endif

	*lEditInBrowse 	= .T.
	cModelo 		= "SubGrupo"

	cFormIndividual = "Clientes\Archivos\Scx\SubGrupo.scx"
	cGrilla 		= "Clientes\Archivos\Scx\SubGrupos.scx"

	cURL 			= "archivos/apis/SubGrupo/"

	cTituloEnForm 	= "Sub Grupo"
	cTituloEnGrilla = "Sub Grupos"

	lIsChild 		= .T.
	cParent 		= "Grupo"

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

			loField = loColFields.New( "grupo_nombre", "C", 100 )
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
				AddProperty( loFiltro, "Nombre", "showField_Grupo"  )
				AddProperty( loFiltro, "FieldName", "showField" )
				AddProperty( loFiltro, "FieldRelation", "==" )
				AddProperty( loFiltro, "FieldValue", "grupo__nombre" )

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

			This.cURL = "archivos/apis/SubGrupo/"

		Endif

		Return This.cURL

	Endproc && cUrl_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oSubGrupo
*!*
*!* ///////////////////////////////////////////////////////

