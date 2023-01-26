#INCLUDE "Fw\Tieradapter\Include\Ta.h"
#INCLUDE "FW\Comunes\Include\Praxis.h"

#Define COM_TA 		"TierAdapter"
#Define COM_STOCK 	"Stock"
#Define COM_COMPRAS "Compras"

#Define Field_name_validation_rule_is_violated 	1582
#Define FK_CLASS_LIBRARY	"Combos Tablas Comunes.vcx"

#Define CT_ARCHIVOS     0
#Define CT_CHILD        1
#Define CT_CHILDTREE    2

* Identificador de las Tier
#Define USER_TIER       1
#Define VALID_TIER      2
#Define BUSSINESS_TIER  3
#Define DATA_TIER       4
#Define CLIENTWS_TIER   5
#Define SERVERWS_TIER   6

Local loColDataBases As ColDataBases Of "Tools\Sincronizador\ColDataBases.prg"
Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

Try

	loColDataBases = Createobject( 'ColDataBases' )
	loColDataBases.Generate()

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	* Throw loError

Finally
	loColDataBases = Null
	loError = Null

Endtry

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColBase
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Colección de Bases de Datos
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColBase As PrxCollection Of "FW\Comun\Prg\PrxBaseLibrary.prg"

	#If .F.
		Local This As ColBase Of "Tools\Sincronizador\colDataBases.prg"
	#Endif

	*!* Nombre de la librería de clases
	cClassLibrary = "ColDataBases.prg"

	*!* Carpeta donde se encuentra la librería de clases
	cClassLibraryFolder = "Tools\Sincronizador"

	*!* Nombre de la Base de datos en el archivo de configuración
	cDataConfigurationKey = ''

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="populateproperties" type="method" display="PopulateProperties" />] + ;
		[<memberdata name="createdirifnotexists" type="method" display="CreateDirIfNotExists" />] + ;
		[<memberdata name="cdataconfigurationkey" type="property" display="cDataConfigurationKey" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: PopulateProperties
	*!* Description...: Carga las propiedades del objeto desde un Objeto pasado como parametro
	*!* Date..........: Miércoles 11 de Marzo de 2009 (11:50:29)
	*!* Author........: Damian Eiff
	*!* Project.......:
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure PopulateProperties( toParam As Object ) As Boolean;
			HELPSTRING "Carga las propiedades del objeto desde un Objeto pasado como parametro"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lRet As Boolean
		Local loItem As Object
		Local loParam As Object
		lRet = .F.
		Try

			PopulateProperties( This, toParam )

			For Each loParam In toParam
				loItem = This.New( loParam.Name )
				PopulateProperties( loItem, loParam )

			Endfor

			lRet = .T.

		Catch To oErr
			* DAE 2009-11-06(17:17:15)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loItem = Null
			loParam = Null
			loError = Null

		Endtry

		Return lRet

	Endproc && PopulateProperties

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateDirIfNotExists
	*!* Description...:
	*!* Date..........: Viernes 20 de Marzo de 2009 (16:03:46)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure CreateDirIfNotExists( cDir As String ) As Boolean

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			If !Empty( cDir ) And ! Directory( cDir , 1 )
				Wait Window "Creando directorio " + cDir + "...." Nowait
				TEXT To lcCommand NoShow TextMerge Pretext 15
					Mkdir '<<cDir>>'
				ENDTEXT
				&lcCommand

			Endif && ! Directory( cDir , 1 )

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			* DAE 2009-11-06(17:16:59)
			* loError = This.oError
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && CreateDirIfNotExists

	Procedure GetClon( eIndex As Variant ) As Object;
			HELPSTRING "Devuelve una copia de un elemento de la colección"

		Local loItem As Object
		Local loClon As Object

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try
			loItem = This.GetItem( eIndex )
			loClon = XmlToObject( ObjectToXml( loItem ))


		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			* DAE 2009-11-06(17:16:45)
			* loError = This.oError
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loClon
	Endproc

Enddefine && ColBase

*!* ///////////////////////////////////////////////////////
*!* Class.........: SessionBase
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Colección de Bases de Datos
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

*Define Class SessionBase As PrxSession Of "Fw\Comun\Prg\Prxbaselibrary.prg"
Define Class SessionBase As PrxCustom Of "FW\TierAdapter\Comun\prxBaseLibrary.prg"
	*!*	Define Class SessionBase As PrxSession Of "FW\TierAdapter\Comun\prxBaseLibrary.prg"

	#If .F.
		Local This As SessionBase Of "Tools\Sincronizador\colDataBases.prg"
	#Endif

	DataSession = SET_DEFAULT

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="populateproperties" type="method" display="PopulateProperties" />] + ;
		[<memberdata name="createdirifnotexists" type="method" display="CreateDirIfNotExists" />] + ;
		[<memberdata name="retrycommand" type="method" display="ReTryCommand" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: PopulateProperties
	*!* Description...: Carga las propiedades del objeto desde un Objeto pasado como parametro
	*!* Date..........: Miércoles 11 de Marzo de 2009 (11:50:29)
	*!* Author........: Damian Eiff
	*!* Project.......:
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure PopulateProperties( oParam As Object ) As Boolean;
			HELPSTRING "Carga las propiedades del objeto desde un Objeto pasado como parametro"

		Local lRet As Boolean
		Local laMembers[1] As String
		Local cProperty As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		lRet = .F.
		Try

			PopulateProperties( This, oParam )

			lRet = .T.
		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			* DAE 2009-11-06(17:16:25)
			* loError = This.oError
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lRet

	Endproc && PopulateProperties

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateDirIfNotExists
	*!* Description...:
	*!* Date..........: Viernes 20 de Marzo de 2009 (16:03:46)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure CreateDirIfNotExists( cDir As String ) As Boolean

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			If !Empty( cDir ) And ! Directory( cDir , 1 )
				Wait Window "Creando directorio " + cDir + "...." Nowait
				TEXT To lcCommand NoShow TextMerge Pretext 15
					Mkdir '<<cDir>>'
				ENDTEXT
				&lcCommand
			Endif

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			* DAE 2009-11-06(17:16:12)
			* loError = This.oError
			loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

	Endproc && CreateDirIfNotExists

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ReTryCommand
	*!* Description...: Executa un comando y si falla reintenta n veces
	*!* Date..........: Lunes 6 de Abril de 2009 (18:05:31)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ReTryCommand( tcCommand As String, tnMaxIntentos As Integer, ;
			tnErrorNo As Integer,;
			tlDoevents As Boolean ) As Void;
			HELPSTRING "Executa un comando y si falla reintenta n veces"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lnIntentos As Integer

		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

		If Empty( tnMaxIntentos )
			tnMaxIntentos = 10
		Endif

		If Empty( tnErrorNo )
			tnErrorNo = 0
		Endif

		lnIntentos = 0
		Do While lnIntentos < tnMaxIntentos
			Try

				lnIntentos = tnMaxIntentos + 1
				&tcCommand

			Catch To oErr

				Wait Window "Reintentando ( " + Transform( lnIntentos ) + " ) " + tcCommand + "...." Nowait

				Do Case
					Case oErr.ErrorNo = tnErrorNo
						lnIntentos = lnIntentos + 1
						TEXT To lcCommand NoShow TextMerge Pretext 15
		                    		<<lnIntentos>>: <<tcCommand>>
						ENDTEXT
						loError.Cremark = "Reintento Nº " + lcCommand
						loError.Process( oErr, .F. )
						If tlDoevents
							DoEvents
						Endif

					Otherwise
						If tlDoevents
							DoEvents
						Endif

						*!*							loError.Process( oErr, .F. )
						*!*							Throw loError

				Endcase
			Finally
			Endtry
		Enddo

		Try
			If lnIntentos # tnMaxIntentos + 1
				Error 'Se alcanzo el maximo de intentos sin poder ejecutar satifactoriamente el comando ' + lcCommand
			Endif

		Catch To oErr
			loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

	Endproc && ReTryCommand

Enddefine && SessionBase

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColDataBases
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Bases de Datos
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColDataBases As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	#If .F.
		Local This As ColDataBases Of "Tools\Sincronizador\ColDataBases.prg"

	#Endif

	cProjectPath = ''

	*!* Nombre del Projecto
	cProjectName = ''

	*!* Objeto Projecto
	oProject = Null

	* Coleccion de Formularios
	oColForms = Null


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="adddatabase" type="event" display="AddDataBase" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="load" type="method" display="Load" />] + ;
		[<memberdata name="populateproperties" type="method" display="PopulateProperties" />] + ;
		[<memberdata name="generate" type="method" display="Generate" />] + ;
		[<memberdata name="cprojectpath" type="propertie" display="cProjectPath" />] + ;
		[<memberdata name="getproject" type="method" display="GetProject" />] + ;
		[<memberdata name="createentityconfig" type="method" display="CreateEntityConfig" />] + ;
		[<memberdata name="defineclass" type="method" display="DefineClass" />] + ;
		[<memberdata name="cprojectname" type="property" display="cProjectName" />] + ;
		[<memberdata name="cprojectname_access" type="method" display="cProjectName_Access" />] + ;
		[<memberdata name="oproject" type="property" display="oProject" />] + ;
		[<memberdata name="oproject_access" type="method" display="oProject_Access" />] + ;
		[<memberdata name="defineprocess" type="method" display="DefineProcess" />] + ;
		[<memberdata name="synchronize" type="method" display="Synchronize" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddDataBase
	*!* Description...: Agrega una Base de Datos a la colección ColDataBases
	*!* Date..........: Martes 29 de Mayo de 2007 (11:04:54)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure AddDataBase( toDataBase As Object ) As Void;
			HELPSTRING "Agrega una Base de Datos a la colección ColDataBases"

		Local i As Integer
		Local lcKey As String

		If Vartype( toDataBase ) = 'O'
			toDataBase.oParent = This
			lcKey = Lower( toDataBase.Name )
			i = This.GetKey( lcKey )

			If Empty( i )
				This.AddItem( toDataBase, lcKey )

			Endif && Empty( i )

		Endif && Vartype( toDataBase ) = 'O'


	Endproc && AddDataBase

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oDataBase vacío
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure New( tcName As String ) As oDataBase Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oDataBase vacío"

		Local loDataBase As oDataBase Of "Tools\Sincronizador\ColDataBases.prg";

		loDataBase = Createobject( "oDataBase" )
		If ! Empty( tcName )
			loDataBase.Name = Alltrim( tcName )

			This.AddDataBase( loDataBase )

		Endif && ! Empty( tcName )

		Return loDataBase

	Endproc && New



	*
	* Sincroniza las Bases de Datos con la definición de las mismas
	Procedure Synchronize(  ) As Void;
			HELPSTRING "Sincroniza las Bases de Datos con la definición de las mismas"

		Local lcCommand As String
		Local loDataBase As oDataBase Of "Tools\Sincronizador\ColDataBases.prg"

		Try

			lcCommand = ""

			For Each loDataBase In This
				loDataBase.Synchronize()
			Endfor


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Synchronize

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: Load
	*!*	*!* Description...: Carga el objeto desde un XML
	*!*	*!* Date..........: Miércoles 11 de Marzo de 2009 (11:40:32)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001 -
	*!*	*!*
	*!*	*!*

	*!*	Procedure Load( cFile As String ) As Boolean;
	*!*			HELPSTRING "Carga el objeto desde un XML"
	*!*		Local lRet As Boolean
	*!*		Local loprxXMLAdapter As prxXMLAdapter Of "fw\Comun\Prg\PrxXmlAdapter.prg"
	*!*		Local loCollDB As ColDataBases Of "Tools\Sincronizador\colDataBases.prg"
	*!*		lRet = .F.
	*!*		Try

	*!*			If File( cFile )
	*!*				loprxXMLAdapter = Newobject( 'prxXMLAdapter', 'fw\Comun\Prg\PrxXmlAdapter.prg' )
	*!*				loprxXMLAdapter.LoadXML( cFile, .T., .T. )
	*!*				loCollDB = loprxXMLAdapter.ToObject()
	*!*				lRet = .T.
	*!*			Endif

	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally

	*!*		Endtry
	*!*		Return lRet
	*!*	Endproc && Load

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: Generate
	*!*	*!* Description...: Genera los archivos del proyecto
	*!*	*!* Date..........: Miércoles 11 de Marzo de 2009 (12:44:23)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......:
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001 -
	*!*	*!*
	*!*	*!*

	*!*	Procedure Generate( cProjectName As String, lAddToProject As Boolean, ;
	*!*			lOverWrite As Boolean ) As Void;
	*!*			HELPSTRING "Genera los archivos del proyecto"

	*!*		Local loProject As VisualFoxpro.IFoxProject
	*!*		Local lcEntityConfigProcess As String
	*!*		Local lcEntityConfig As String
	*!*		Local lcFileName As String
	*!*		Local loFile As VisualFoxpro.IFoxPrjFile
	*!*		Local lcDefineProcess As String
	*!*		Local lcDefineClass As String
	*!*		Local lcDir As String

	*!*		Try
	*!*			lcEntityConfig = ''
	*!*			lcEntityConfigProcess = ''
	*!*			lcDefineProcess = ''
	*!*			lcDefineClass = ''

	*!*			If ! Empty( cProjectName )
	*!*				loProject = This.GetProject( cProjectName )
	*!*			Endif
	*!*			For Each loDataBase As oDataBase Of "Tools\Sincronizador\colDataBases.prg" In This
	*!*				loDataBase.cProjectPath = This.cProjectPath
	*!*				loDataBase.Generate( loProject, lAddToProject, lOverWrite )

	*!*				For Each loTable As oTable Of "Tools\Sincronizador\colDataBases.prg" In loDataBase.oColTables
	*!*					lcDefineProcess = This.DefineProcess( loTable )
	*!*					TEXT To lcEntityConfigProcess NoShow TextMerge ADDITIVE
	*!*						<< lcDefineProcess + CR + CR >>
	*!*					ENDTEXT

	*!*					lcDefineClass = This.DefineClass( loTable )
	*!*					TEXT To lcEntityConfig NoShow TextMerge ADDITIVE
	*!*						<<lcDefineClass + CR + CR >>
	*!*					ENDTEXT

	*!*				Endfor
	*!*			Endfor

	*!*			* lcDir =  Addbs( lcDir )
	*!*			lcFileName = Addbs( This.cProjectPath ) + 'EntityConfig.prg'
	*!*			If ! File( lcFileName ) Or lOverWrite
	*!*				Strtofile( lcEntityConfigProcess, lcFileName, 0 )
	*!*				Strtofile( lcEntityConfig, lcFileName, 1 )
	*!*			Endif

	*!*			If Vartype( loProject ) = 'O' And lAddToProject
	*!*				loFile = loProject.Files.Item( lcFileName )
	*!*				If Vartype( loFile ) # 'O'
	*!*					loProject.Files.Add( lcFileName )
	*!*					loFile = loProject.Files.Item( lcFileName )
	*!*				Endif
	*!*				loFile.Exclude = .T.
	*!*				* loFile.Run()
	*!*			Endif

	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally
	*!*			loProject = Null
	*!*			loFile = Null
	*!*		Endtry

	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE Generate
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: GetProject
	*!*	*!* Description...: Devuelve la referencia del objeto proyecto
	*!*	*!* Date..........: Miércoles 11 de Marzo de 2009 (15:34:52)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001 -
	*!*	*!*
	*!*	*!*

	*!*	Procedure GetProject( cProjectName As String ) As VisualFoxpro.IFoxProject;
	*!*			HELPSTRING "Devuelve la referencia del objeto proyecto"

	*!*		Local loProject As VisualFoxpro.IFoxProject

	*!*		Try
	*!*			cProjectName = Lower( Alltrim( cProjectName ) )
	*!*			If File( cProjectName )
	*!*				TEXT To lcCommand NoShow TextMerge Pretext 15
	*!*		 			Modify Project [<<cProjectName>>] Nowait Noshow
	*!*				ENDTEXT
	*!*				&lcCommand
	*!*			Endif

	*!*			For Each loProject In _vfp.Projects
	*!*				If Lower( loProject.Name ) == cProjectName
	*!*					Exit
	*!*				Endif
	*!*			Endfor

	*!*			If Lower( loProject.Name ) # cProjectName
	*!*				loProject = Null
	*!*			Endif

	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally

	*!*		Endtry
	*!*		Return loProject
	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE GetProject
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*		*!* ///////////////////////////////////////////////////////
	*!*		*!* Procedure.....: cProjectName_Access
	*!*		*!* Date..........: Viernes 13 de Marzo de 2009 (19:59:50)
	*!*		*!* Author........: Damian Eiff
	*!*		*!* Project.......: Sistemas Praxis
	*!*		*!* -------------------------------------------------------
	*!*		*!* Modification Summary
	*!*		*!* R/0001  -
	*!*		*!*
	*!*		*!*

	*!*		Procedure cProjectName_Access()

	*!*			If Vartype( This.cProjectName ) # 'C' ;
	*!*					OR Empty( This.cProjectName )

	*!*				This.cProjectName = ''
	*!*			Endif
	*!*			Return This.cProjectName

	*!*		Endproc
	*!*		*!*
	*!*		*!* END PROCEDURE cProjectName_Access
	*!*		*!*
	*!*		*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: oProject_Access
	*!*	*!* Date..........: Viernes 13 de Marzo de 2009 (20:01:00)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001  -
	*!*	*!*
	*!*	*!*

	*!*	Procedure oProject_Access()

	*!*		If Vartype( This.oProject ) # 'O'
	*!*			This.oProject = This
	*!*		Endif
	*!*		Return This.oProject

	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE oProject_Access
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: DefineProcess
	*!*	*!* Description...:
	*!*	*!* Date..........: Sábado 14 de Marzo de 2009 (18:17:45)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001  -
	*!*	*!*
	*!*	*!*

	*!*	Procedure DefineProcess( oTable As Object ) As String
	*!*		Local lcRet As String
	*!*		Local lcClassName

	*!*		#If .F.
	*!*			Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*		#Endif
	*!*		Try
	*!*			lcRet = ''
	*!*			lcClassName = Alltrim( oTable.cDataConfigurationKey )
	*!*			TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*				lcEntity = '<lcClassName>>'
	*!*	            loEntity = CreateObject( lcEntity )
	*!*		        This.AddItem( loEntity, Lower( lcEntity ))
	*!*		        If .F.
	*!*			ENDTEXT

	*!*			If oTable.lHasDataTier
	*!*				TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*	        	    Do dt<<lcClassName>>.prg
	*!*				ENDTEXT
	*!*			Endif

	*!*			If oTable.lHasBussinessTier
	*!*				TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*	        	    Do bt<<lcClassName>>.prg
	*!*				ENDTEXT
	*!*			Endif

	*!*			If oTable.lHasWrapperTier
	*!*				TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*	        	    Do wt<<lcClassName>>.prg
	*!*				ENDTEXT
	*!*			Endif

	*!*			If oTable.lHasValidTier
	*!*				TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*	        	    Do vt<<lcClassName>>.prg
	*!*				ENDTEXT
	*!*			Endif

	*!*			If oTable.lHasUserTier
	*!*				TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*	        	    Do ut<<lcClassName>>.prg
	*!*				ENDTEXT
	*!*			Endif

	*!*			If oTable.lHasClientWsTier
	*!*				TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*	        	    Do ct<<lcClassName>>.prg
	*!*				ENDTEXT
	*!*			Endif

	*!*			If oTable.lHasServerWsTier
	*!*				TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*	        	    Do st<<lcClassName>>.prg
	*!*				ENDTEXT
	*!*			Endif

	*!*			TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*			     EndIf
	*!*			ENDTEXT

	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally

	*!*		Endtry

	*!*		Return lcRet

	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE DefineProcess
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Function......: DefineClass
	*!*	*!* Description...: Crea la definición de la clase
	*!*	*!* Date..........: Viernes 13 de Marzo de 2009 (17:18:42)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001  -
	*!*	*!*
	*!*	*!*

	*!*	Procedure DefineClass( oTable As Object  ) As String;
	*!*			HELPSTRING "Crea la definición de la clase"

	*!*		#If .F.
	*!*			Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*		#Endif

	*!*		Local lcText As String

	*!*		Private pcClassName As String
	*!*		Private pcUser As String
	*!*		Private pcProject As String
	*!*		Private pcFileName As String
	*!*		Private luReturnValue As String
	*!*		Private pcSafeProjectName As String
	*!*		Private poTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*		Private pcFolder As String
	*!*		Try

	*!*			pcFolder = Addbs( This.cProjectPath ) + 'Prg'

	*!*			This.CreateDirIfNotExists( pcFolder )
	*!*			poTable = oTable
	*!*			pcClassName = Alltrim( oTable.cDataConfigurationKey )
	*!*			pcUser = Iif( Vartype( _user ) # 'U', Alltrim( _user ), 'Developer Praxis' )
	*!*			pcProject = 'Sistemas Praxis'
	*!*			pcFileName = Forceext( Addbs( pcFolder ) + "Entitiesconfig " + This.cProjectName, "prg" )
	*!*			pcSafeProjectName = Chrtran( Chrtran( ProperCase( This.cProjectName ), '_', '' ), Space( 1 ), '' )

	*!*			Do wwScripting
	*!*			Local loScript As wwScripting
	*!*			loScript = Createobject( "wwScripting" )

	*!*			* lcText = loScript.Mergetext( 'Templates\EntityCfg.tpl.prg' , .T. )
	*!*			If ! ( 'entitycfgtpl' $ Lower( Set( "Procedure" ) ) )
	*!*				Set Procedure To 'Templates\EntityCfgtpl.prg' Additive
	*!*			Endif
	*!*			lcText = EntityCfgTpl()

	*!*			*!*	        TEXT To luReturnValue NoShow TextMerge ADDITIVE
	*!*			*!*	     *!* ///////////////////////////////////////////////////////
	*!*			*!*	     *!* Class.........: <<lcClassName>>
	*!*			*!*	     *!* ParentClass...: Collection
	*!*			*!*	     *!* Date..........: <<DateMask(date())>> (<<time()>>)
	*!*			*!*	     *!* Author........: <<lcUser>>
	*!*			*!*	     *!* Project.......: <<lcProject>>
	*!*			*!*	     *!* -------------------------------------------------------
	*!*			*!*	     *!* Modification Summary
	*!*			*!*	     *!* R/0001 -

	*!*			*!*	    	Define Class <<lcClassName>> As Collection

	*!*			*!*	    	    #If .F.
	*!*			*!*	    	        Local This As <<lcClassName>> Of "<<lcFileName>>"
	*!*			*!*	    	    #Endif

	*!*			*!*	     		*!* Referencia a la colección TierConfig
	*!*			*!*	    	    oColTiers = Null

	*!*			*!*	    	    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
	*!*			*!*	    	        [<VFPData>] + ;
	*!*			*!*	    	        [<memberdata name="ocoltiers" type="property" display="oColTiers" />] + ;
	*!*			*!*	    	        [</VFPData>]
	*!*			*!*	        ENDTEXT

	*!*			*!*	        TEXT To luReturnValue NoShow TextMerge ADDITIVE
	*!*			*!*	    *!* ///////////////////////////////////////////////////////
	*!*			*!*	    *!* Function......: Init
	*!*			*!*	    *!* Description...: Constructor
	*!*			*!*	    *!* Date..........: <<DateMask(date())>> (<<time()>>)
	*!*			*!*	    *!* Author........: <<lcUser>>
	*!*			*!*	    *!* Project.......: <<lcProject>>
	*!*			*!*	    *!* -------------------------------------------------------
	*!*			*!*	    *!* Modification Summary
	*!*			*!*	    *!* R/0001 -
	*!*			*!*	    *!*
	*!*			*!*	    *!*

	*!*			*!*	    	    Function Init() As Boolean

	*!*			*!*	    	        Try

	*!*			*!*	    	            Local loColTierConfig As TierConfig Of "Fw\Actual\Comun\prg\TierConfig.prg"
	*!*			*!*	    	            Local loTierObj As Object

	*!*			*!*	    	            loColTierConfig = Newobject("TierConfig","FW\Actual\Comun\Prg\TierConfig.prg")
	*!*			*!*	        ENDTEXT

	*!*			*!*	        * UserTier
	*!*			*!*	        If oTable.lHasUserTier
	*!*			*!*	            TEXT To luReturnValue NoShow TextMerge ADDITIVE
	*!*			*!*	    	            loTierObj = loColTierConfig.New( "<<lcClassName>>", "User" )
	*!*			*!*	    	            loTierObj.cObjClass = "ut<<lcClassName>>"
	*!*			*!*	    	            loTierObj.cObjClassLibraryFolder = BT_CLIENT
	*!*			*!*	            ENDTEXT
	*!*			*!*	        Endif

	*!*			*!*	        * ValidTier
	*!*			*!*	        If oTable.lHasValidTier
	*!*			*!*	            TEXT To luReturnValue NoShow TextMerge ADDITIVE
	*!*			*!*	    	            loTierObj = loColTierConfig.New( "<<lcClassName>>", "Valid" )
	*!*			*!*	    	            loTierObj.cObjClass = "vt<<lcClassName>>"
	*!*			*!*	    	            loTierObj.cObjClassLibraryFolder = BT_CLIENT
	*!*			*!*	            ENDTEXT
	*!*			*!*	        Endif

	*!*			*!*	        * ClientWsTier
	*!*			*!*	        If oTable.lHasClientWsTier
	*!*			*!*	            TEXT To luReturnValue NoShow TextMerge ADDITIVE
	*!*			*!*	    	            loTierObj = loColTierConfig.New( "<<lcClassName>>", "ClientWs" )
	*!*			*!*	    	            loTierObj.cObjClass = "ct<<lcClassName>>"
	*!*			*!*	    	            loTierObj.cObjClassLibraryFolder = BT_CLIENT
	*!*			*!*	            ENDTEXT
	*!*			*!*	        Endif

	*!*			*!*	        * ServerWsTier
	*!*			*!*	        If oTable.lHasServerWsTier
	*!*			*!*	            TEXT To luReturnValue NoShow TextMerge ADDITIVE
	*!*			*!*	    	            loTierObj = loColTierConfig.New( "<<lcClassName>>", "ServerWs" )
	*!*			*!*	    	            loTierObj.cObjClass = "st<<lcClassName>>"
	*!*			*!*	    	            loTierObj.cObjClassLibraryFolder = BT_SERVER
	*!*			*!*	    	            loTierObj.cObjComponent = COM_<<Upper( lcSafeProjectName )>>
	*!*			*!*	    	            loTierObj.lObjInComComponent = .T.
	*!*			*!*	            ENDTEXT
	*!*			*!*	        Endif

	*!*			*!*	        * BussinessTier
	*!*			*!*	        If oTable.lHasBussinessTier
	*!*			*!*	            TEXT To luReturnValue NoShow TextMerge ADDITIVE
	*!*			*!*	    	            loTierObj = loColTierConfig.New( "<<lcClassName>>", "Business" )
	*!*			*!*	    	            loTierObj.cObjClass = "bt<<lcClassName>>"
	*!*			*!*	    	            loTierObj.cObjClassLibraryFolder = BT_SERVER
	*!*			*!*	    	            loTierObj.cObjComponent = COM_<<Upper( lcSafeProjectName )>>
	*!*			*!*	    	            loTierObj.lObjInComComponent = .T.
	*!*			*!*	            ENDTEXT
	*!*			*!*	        Endif

	*!*			*!*	        * DataTier
	*!*			*!*	        If oTable.lHasDataTier
	*!*			*!*	            TEXT To luReturnValue NoShow TextMerge ADDITIVE
	*!*			*!*	    	            loTierObj = loColTierConfig.New( "<<lcClassName>>", "Data" )
	*!*			*!*	    	            loTierObj.cObjClass = "dt<<lcClassName>>"
	*!*			*!*	    	            loTierObj.cObjClassLibraryFolder = BT_SERVER
	*!*			*!*	    	            loTierObj.cObjComponent = COM_<<Upper( lcSafeProjectName )>>
	*!*			*!*	    	            loTierObj.lObjInComComponent = .T.
	*!*			*!*	            ENDTEXT
	*!*			*!*	        Endif

	*!*			*!*	        TEXT To luReturnValue NoShow TextMerge ADDITIVE

	*!*			*!*	    	        This.oColTiers = loColTierConfig

	*!*			*!*	    	    Catch To oErr
	*!*			*!*	    	        Local loError As DataTierError Of "fw\Actual\ErrorHandler\DataTierError.prg"
	*!*			*!*	    	        loError = Newobject( "DataTierError", "DataTierError.prg" )
	*!*			*!*	    	        loError.Process( oErr )
	*!*			*!*	    	        Throw loError

	*!*			*!*	    	    Finally
	*!*			*!*	    	        loColTierConfig = Null
	*!*			*!*	    	        loTierObj = Null

	*!*			*!*	    	    Endtry

	*!*			*!*	    	Endfunc
	*!*			*!*	    *!*
	*!*			*!*	    *!* END FUNCTION Init
	*!*			*!*	    *!*
	*!*			*!*	    *!* ///////////////////////////////////////////////////////

	*!*			*!*	    *!*
	*!*			*!*	    *!* END DEFINE
	*!*			*!*	    *!* Class.........: <<lcClassName>>
	*!*			*!*	    *!*
	*!*			*!*	    *!* ///////////////////////////////////////////////////////

	*!*			*!*	        ENDTEXT


	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally
	*!*			poTable = Null
	*!*		Endtry
	*!*		Return lcText
	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROC DefineClass
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////


Enddefine && ColDataBases

*!* ///////////////////////////////////////////////////////
*!* Class.........: oDataBase
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Base de Datos
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oDataBase As SessionBase

	#If .F.
		Local This As oDataBase Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!* Colección Tables
	oColTables = Null

	*!* Carpeta donde se encuentra la Base de datos
	Folder = ""

	*!* Extensión del archivo de la Base de Datos
	Ext = "DBC"

	*!* Nombre de la Base de datos en el archivo de configuración
	cDataConfigurationKey = ''

	*!* Nombre del archivo de inicialización
	IniFileName = ''

	DataSession = SET_DEFAULT

	cProjectPath = ''

	*!* Nombre del proyecto
	cProjectName = ''

	*!* Colección de Store Procedures
	oColStoreProcedures = Null

	* Coleccion de Formularios
	oColForms = Null

	* Indica si la Base de datos será excluída del Diccionario de Datos
	lExcludeFromDataDictionary = .F.

	* Indica si se realiza el procesamiento de la Base de Datos
	lProcess = .T.

	*!* Colección Entities
	oColTiers = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="getselectsql" type="method" display="GetSelectSQL" />] + ;
		[<memberdata name="lprocess" type="property" display="lProcess" />] + ;
		[<memberdata name="lexcludefromdatadictionary" type="property" display="lExcludeFromDataDictionary" />] + ;
		[<memberdata name="ocolforms" type="property" display="oColForms" />] + ;
		[<memberdata name="ocolstoreprocedures" type="property" display="oColStoreProcedures" />] + ;
		[<memberdata name="ocolstoreprocedures_access" type="method" display="oColStoreProcedures_Access" />] + ;
		[<memberdata name="cDataConfigurationKey" type="property" display="cDataConfigurationKey" />] + ;
		[<memberdata name="inifilename" type="property" display="IniFileName" />] + ;
		[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
		[<memberdata name="folder" type="property" display="Folder" />] + ;
		[<memberdata name="ext" type="property" display="Ext" />] + ;
		[<memberdata name="open" type="method" display="Open" />] + ;
		[<memberdata name="close" type="method" display="Close" />] + ;
		[<memberdata name="set" type="method" display="Set" />] + ;
		[<memberdata name="delete" type="method" display="Delete" />] + ;
		[<memberdata name="create" type="method" display="Create" />] + ;
		[<memberdata name="update" type="method" display="Update" />] + ;
		[<memberdata name="print" type="method" display="Print" />] + ;
		[<memberdata name="readinifile" type="method" display="ReadIniFile" />] + ;
		[<memberdata name="initialize" type="method" display="Initialize" />] + ;
		[<memberdata name="pack" type="method" display="Pack" />] + ;
		[<memberdata name="generate" type="method" display="Generate" />] + ;
		[<memberdata name="createform" type="method" display="CreateForm" />] + ;
		[<memberdata name="createclass" type="method" display="CreateClass" />] + ;
		[<memberdata name="getform" type="method" display="GetForm" />] + ;
		[<memberdata name="cprojectpath" type="propertie" display="cProjectPath" />] + ;
		[<memberdata name="addentityproperty" type="method" display="AddEntityProperty" />] + ;
		[<memberdata name="cprojectname" type="property" display="cProjectName" />] + ;
		[<memberdata name="GetSetGridLayout" type="method" display="GetSetGridLayout" />] + ;
		[<memberdata name="gethookafternew" type="method" display="GetHookAfterNew" />] + ;
		[<memberdata name="getpopulatetable" type="method" display="GetPopulateTable" />] + ;
		[<memberdata name="appendprocedures" type="method" display="AppendProcedures" />] + ;
		[<memberdata name="merge" type="method" display="Merge" />] + ;
		[<memberdata name="classafterinit" type="method" display="ClassAfterInit" />] + ;
		[<memberdata name="ocoltiers" type="property" display="oColTiers" />] + ;
		[<memberdata name="synchronize" type="method" display="Synchronize" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Init
	*!* Description...:
	*!* Date..........: Jueves 17 de Abril de 2008 (10:05:18)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Init( tuProcess As Variant ) As Boolean

		Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
		Local llOk As Boolean
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			llOk = .F.
			loGlobalSettings = NewGlobalSettings()

			If Empty( Atc( "#" + This.Name + "#", loGlobalSettings.cDataBases ) )
				llOk = .T.

				loGlobalSettings.cDataBases = loGlobalSettings.cDataBases + "#" + This.Name + "#,"

				This.lProcess = Empty( tuProcess )
				This.ReadIniFile()
				This.Initialize()

				If This.lProcess
					This.ClassAfterInit()
				Endif && This.lProcess




			Endif

		Catch To oErr
			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			* loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loGlobalSettings = Null
			loError = Null

		Endtry

		Return llOk

	Endproc && Init

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Initialize
	*!* Description...:
	*!* Date..........: Jueves 17 de Abril de 2008 (10:13:15)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Initialize( uParam As Variant ) As Void
	Endproc && Initialize

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ClassAfterInit
	*!* Description...:
	*!* Date..........: Jueves 23 de Julio de 2009 (18:29:19)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ClassAfterInit(  ) As Void

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loTablePadre As oTable Of "Tools\Sincronizador\colDataBases.prg"
		* Local loColFilter As ColFilters Of "fw\tieradapter\comun\prxbaselibrary.prg"
		* Local loFilter As oFilter Of "fw\tieradapter\comun\prxbaselibrary.prg"
		Local loColData As PrxCollection Of fw\tieradapter\comun\prxbaselibrary.prg
		Local loColTables As ColTables Of "Tools\Sincronizador\colDataBases.prg"
		Local loField As oField Of Of "Tools\Sincronizador\colDataBases.prg"
		Local loFldFK As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\colDataBases.prg"
		* Local lcFieldsToSQL As String
		* Local lcCampos As String
		* Local lcSQLStat As String

		Try

			* DAE 2009-10-23(14:01:34)
			* se Paso al proceso GetSelectSQL
			*!*	TEXT To lcFieldsToSQL NoShow TextMerge Pretext 15
			*!*		Iif( Empty( cDefaultSqlExp ),
			*!*			Iif( lIsVirtual, [ Cast( ] + Iif( InList( Left( Lower( FieldType ) , 3 ), 'log', 'gen', 'cur', 'blo', 'dat', 'cha', 'var', 'mem' ), "''", '0' ) + [ As ] + FieldType
			*!*				+ Iif( ! InList( Left( Lower( FieldType ) , 3 ), 'int', 'dat', 'mem' ), [( ] + Transform( FieldWidth )
			*!*			    + Iif( ! InList( Left( Lower( FieldType ) , 3 ), 'var', 'int', 'dat', 'cha', 'mem', 'dat' ),
			*!*					', ' + Transform( FieldPrecision ),
			*!*					'' ) + [ ) ],
			*!*				'' ) + [ ) As ] + Name, Name ), cDefaultSqlExp )

			*!*	ENDTEXT

			loColTables = This.oColTables
			*!*	loColFilter = Newobject( 'ColFilters', 'fw\tieradapter\comun\prxbaselibrary.prg' )

			*!*	loFilter = loColFilter.New ( 'FiltroReferences' )
			*!*	loFilter.cField = 'References'
			*!*	loFilter.cOperator = '='
			*!*	loFilter.cFieldExp = 'Alltrim(Lower( <#FIELD#> ))'


			* For Each loTable In This.oColTables
			For iq = 1 To loColTables.Count
				loTable = loColTables.Item[ iq ]
				lcPadre = Alltrim( Lower( loTable.Padre ) )
				* If ! Empty( loTable.Padre )
				If ! Empty( lcPadre )

					* loFilter.cExpr = Any2Char( Alltrim(Lower( loTable.Padre )), .T. )
					loColData = Null
					* loColData = loTable.oColFields.Where( loColFilter )

					* Obtengo las FK a la tabla padre
					lcExp = ' Lower( Alltrim( References ) ) == "' + lcPadre + '" '
					loColData = loTable.oColFields.Where( lcExp )

					Assert loColData.Count # 0 Message 'No existe la referencia'

					If loColData.Count > 0
						For jQ = 1 To loColData.Count
							loFldFK = loColData.Item[ jQ ]
							loFldFK.nComboOrder = Iif( Empty( loFldFK.nComboOrder ), -1, loFldFK.nComboOrder )

						Endfor
						llOk = .F.

						* Obtengo la referencia del padre
						loTablePadre = loColTables.GetItem( lcPadre )

						If Vartype( loTablePadre ) # "O"
							For i = 1 To loColData.Count
								loField = loColData.Item( i )

								* If Lower( loTable.Padre ) = Lower( loField.References )
								If lcPadre = Lower( loField.References )
									If ! Empty( loField.cParentKeyName )
										loTablePadre = loColTables.GetItem( loField.cParentKeyName )

									Endif && ! Empty( loField.cParentKeyName )
									llOk = ( Vartype( loTablePadre ) = "O" )
									*!*	If llOk
									*!*		If Empty( loField.nComboOrder )
									*!*			loField.nComboOrder = -1
									*!*		Endif && Empty( loField.nComboOrder )
									*!*	Endif && llOk
									Exit

								Endif

							Endfor

						Else
							llOk = .T.

						Endif

						If ! llOk
							Error 'No existe en la tabla ' + loTable.Name + ' ningun campo que haga referencia a la tabla ' + loTable.Padre

						Endif && ! llOk

						* Agrego la referencia de la tabla a la colección de tablas del padre
						loTablePadre.oColTables.AddTable( loTable, .T. )
						* Obtengo la clave primaria del padre
						loField = loTablePadre.GetPrimaryKey()
						loTable.ForeignKey = loField.Name

					Else
						Error 'No existe en la tabla ' + loTable.Name + ' ningun campo que haga referencia a la tabla ' + loTable.Padre

					Endif && loColData.Count > 0

				Endif && ! Empty( loTable.Padre )

				* DAE 2009-09-24(13:46:33)
				*!*	* If loTable.lIsVirtual And Empty( loTable.SQLStat )
				*!*	If Empty( loTable.SQLStat )
				*!*		*!*	lcCampos = loTable.oColFields.ToString( lcFieldsToSQL )

				*!*		*!*	TEXT To lcSQLStat NoShow TextMerge Pretext 15
				*!*		*!*		Select <<lcCampos>>
				*!*		*!*		From <<Iif( loTable.lIsVirtual, 'dual', loTable.Name )>>

				*!*		*!*	ENDTEXT

				*!*		*!*	loTable.SQLStat = lcSQLStat
				*!*		loTable.SQLStat = This.GetSelectSQL( loTable, '', .T. )

				*!*	Endif && Empty( loTable.SQLStat )

				*!*	If Empty( loTable.SQLStatCombo )
				*!*		*!*	lcCampos = loTable.oColFields.ToString( lcFieldsToSQL, '',  'nComboOrder <> 0 Or AutoInc' )
				*!*		*!*	TEXT To lcSQLStat NoShow TextMerge Pretext 15
				*!*		*!*		Select <<lcCampos>>
				*!*		*!*		From <<Iif( loTable.lIsVirtual, 'dual', loTable.Name )>>

				*!*		*!*	ENDTEXT

				*!*		*!*	loTable.SQLStatCombo = lcSQLStat
				*!*		loTable.SQLStatCombo = This.GetSelectSQL( loTable, 'nComboOrder <> 0 Or AutoInc', .T. )

				*!*	Endif && EMPTY( loTable.SQLStatCombo )

				*!*	If Empty( loTable.SQLStatKeyFinder )
				*!*		*!*	lcCampos = loTable.oColFields.ToString( lcFieldsToSQL, '', 'nKeyFinderOrder <> 0 Or AutoInc' )
				*!*		*!*	TEXT To lcSQLStat NoShow TextMerge Pretext 15
				*!*		*!*		Select <<lcCampos>>
				*!*		*!*		From <<Iif( loTable.lIsVirtual, 'dual', loTable.Name )>>

				*!*		*!*	ENDTEXT

				*!*		*!*	loTable.SQLStatKeyFinder = lcSQLStat
				*!*		loTable.SQLStatKeyFinder = This.GetSelectSQL( loTable, 'nKeyFinderOrder <> 0 Or AutoInc' , .T. )

				*!*	Endif && EMPTY( loTable.SQLStatKeyFinder )

				*!*	If Empty( loTable.SQLStatSelector )
				*!*		*!*	lcCampos = loTable.oColFields.ToString( lcFieldsToSQL, '', 'lShowInSelector Or nSelectorOrder <> 0 Or AutoInc' )
				*!*		*!*	TEXT To lcSQLStat NoShow TextMerge Pretext 15
				*!*		*!*		Select <<lcCampos>>
				*!*		*!*		From <<Iif( loTable.lIsVirtual, 'dual', loTable.Name )>>

				*!*		*!*	ENDTEXT

				*!*		*!*	loTable.SQLStatSelector = lcSQLStat
				*!*		loTable.SQLStatSelector = This.GetSelectSQL( loTable, 'lShowInSelector Or nSelectorOrder <> 0 Or AutoInc', .T. )

				*!*	Endif && EMPTY( loTable.SQLStatSelector )

			Endfor

			* For Each loTable In This.oColTables
			For iq = 1 To loColTables.Count
				loTable = loColTables.Item[ iq ]
				If Empty( loTable.Padre )
					* Calculo la Jerarquia de tablas
					* nNivelJerarquiaTablas indica la cantidad máxima de niveles que cuelgan de una tabla
					* dada, incluyéndose a si misma.
					* En Padre-Hijo-Nieto, nNivelJerarquiaTablas para Padre = 3, Hijo = 2 y Nieto = 1
					* El Nivel indica el lugar que ocupa dentro de la jeraquía: Padre = 1,
					* Hijo = 2 y Nieto = 3
					*
					loTable.Nivel = 1
					loTable.nNivelJerarquiaTablas = loTable.oColTables.AssignLevel( loTable.oColTables, 2, 1 )

					* Assigno el nivel de jerarquia a las tablas hijas
					loTable.oColTables.AssignNivelJerarquiaTablas( loTable.oColTables, loTable.nNivelJerarquiaTablas - 1 )

					* Asigno la referencia al Main
					loTable.oColTables.AssignMain( loTable.oColTables, loTable )

				Endif && Empty( loTable.Padre )

			Endfor

		Catch To oErr
			* DAE 2009-11-06(17:15:51)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

			Throw loError

		Finally
			loError = Null
			loTable = Null
			loTablePadre = Null
			* loColFilter = Null
			* loFilter = Null
			loColData = Null
			loField = Null
			loColTables = Null
			loFldFK = Null

		Endtry

	Endproc && ClassAfterInit

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ReadIniFile
	*!* Description...: Leer el archivo de inicialización
	*!* Date..........: Jueves 5 de Enero de 2006 (09:28:41)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Menus
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure ReadIniFile( ) As Void;
			HELPSTRING "Leer el archivo de inicialización"

		Local lcName As String,;
			lcFolder As String,;
			lcAlias As String

		Local loXA As Xmladapter

		Try

			lcAlias = ""

			*!* Nombre del archivo de inicialización
			This.IniFileName = Addbs( This.cRootFolder ) + "DataTier.xml"


			Try

				loXA = Newobject("prxXMLAdapter",;
					"prxXMLAdapter.prg" )

				loXA.LoadXML( This.IniFileName, .T. )
				loXA.Tables(1).ToCursor()
				loXA = Null

				lcAlias = Alias()

				Locate For Alltrim( Lower( objName )) = Alltrim( Lower( This.cDataConfigurationKey ))
				If Eof()
					Locate For Alltrim( Lower( objName )) = "default"

				Endif

				lcFolder = Justpath( Alltrim( dbName ) )
				lcName 	 = Juststem( Alltrim( dbName ) )

				This.Folder = Justpath( Alltrim( dbName ) )
				This.Name = Juststem( Alltrim( dbName ) )
				This.Ext = Justext( Alltrim( dbName ) )

			Catch To oErr

			Finally

			Endtry


		Catch To oErr
			Throw oErr

		Finally
			loXA = Null
			*!*	If Used( lcAlias )
			*!*		Use In Alias( lcAlias )
			*!*
			*!*	Endif
			Use In Select( lcAlias )

		Endtry

	Endproc && ReadIniFile

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Print
	*!* Description...: Imprime la definición de la Base de Datos
	*!* Date..........: Viernes 11 de Abril de 2008 (14:15:13)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Print( cFileName As String ) As Void;
			HELPSTRING "Imprime la definición de la Base de Datos"

		Local loTable As oTable Of 'V:\SistemasPraxisV2\TOOLS\Sincronizador\COLDATABASES.PRG'
		Local lcFileName As String

		Try
			If ! Empty( cFileName )
				lcFileName = cFileName

			Else
				lcFileName = Addbs( This.Folder ) + This.Name + "." + This.Ext + ".txt"

			Endif && ! Empty( cFileName )

			Strtofile( Addbs( This.Folder ) + This.Name + "." + This.Ext + CRLF, lcFileName, 0 )

			For Each loTable In This.oColTables
				loTable.Print( lcFileName )

			Endfor

		Catch To oErr
			Throw oErr

		Finally
			loTable = Null

		Endtry

		Return lcFileName

	Endproc && Print

	*
	* oColTables_Access
	Procedure oColTables_Access
		If Vartype( This.oColTables ) # "O"
			This.oColTables = Createobject( "ColTables" )
			This.oColTables.oParent = This
			This.oColTables.cDataConfigurationKey = This.Name


		Endif && Vartype( This.oColTables ) # "O"

		Return This.oColTables

	Endproc && oColTables_Access



	*
	* Sincroniza la Base de Datos con la definición de la misma
	Procedure Synchronize(  ) As Void;
			HELPSTRING "Sincroniza la Base de Datos con la definición de la misma"

		Local lcCommand As String
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg")
		Local loColTables As ColTables Of "Tools\Sincronizador\colDataBases.prg"
		Local llDone As Boolean

		Try

			lcCommand = ""
			llDone = .F.

			This.Open()

			loColTables = This.oColTables

			For Each loTable In loColTables
				If ! loTable.lIsVirtual

					Wait Window "Verificando " + loTable.Name + "...." Nowait

					If Empty( loTable.Folder )
						loTable.Folder = This.Folder

					Endif && Empty( loTable.Folder )

					If !FileExist( Addbs( loTable.Folder ) + loTable.Name + "." + loTable.Ext )
						llDone = .T.
						This.Update()
					Endif

					If !llDone
						If !loTable.Synchronize()
							llDone = .T.
							This.Update()
						Endif
					Endif

				Endif && ! loTable.lIsVirtual

				If llDone
					Exit
				Endif

			Endfor


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Wait Clear
			This.Close()

		Endtry

	Endproc && Synchronize


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Update
	*!* Description...: Actualiza la base de Datos
	*!* Date..........: Martes 29 de Mayo de 2007 (18:07:19)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Update( ) As Void;
			HELPSTRING "Actualiza la base de Datos"

		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg")
		Local loStoreProcedure As oStoreProcedure Of "Tools\Sincronizador\ColDataBases.prg"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\colDataBases.prg"
		Local lcProcir_log As String
		Local lcTriggerFile As String
		Local lcFileName As String

		Try

			This.Open()
			This.Set()

			* Eliminar Store procedures
			Strtofile( "", "Dummy.txt" )

			Append Procedures From "Dummy.txt" Overwrite

			Erase "Dummy.txt"

			loColTables = This.oColTables
			For Each loTable In loColTables
				If ! loTable.lIsVirtual
					*!* Creo las tablas y las Clave Primarias
					Wait Window "Creando " + loTable.Name + "...." Nowait

					If Empty( loTable.Folder )
						loTable.Folder = This.Folder

					Endif && Empty( loTable.Folder )

					loTable.CreateTable()

				Endif && ! loTable.lIsVirtual

			Endfor

			If Pemstatus( _Screen, "oColTables", 5 )
				_Screen.oColTables = Null

			Else
				AddProperty( _Screen, "oColTables" )

			Endif

			_Screen.oColTables = loColTables

			*!*	Creo el resto de los indices
			For Each loTable In loColTables
				If ! loTable.lIsVirtual
					Wait Window "Creando Indices de " + loTable.Name + "...." Nowait
					loTable.CreateIndexes( 0 )

				Endif && ! loTable.lIsVirtual

			Endfor

			_Screen.oColTables = Null
			Removeproperty( _Screen, "oColTables" )

			TEXT To lcProcir_log NoShow


*!* ///////////////////////////////////////////////////////
*!* Procedure.....: _ir_log
*!* Description...: Activity Log
*!* -------------------------------------------------------
*!*
*!*

Procedure _ir_log( tcTable As String, tcOperation As String ) As Boolean

	Local loData As Object
	Local lcTableLog as String

	If Used( tcTable )
		Select Alias( tcTable )
		Scatter Name loData

		AddProperty( loData, 'Operation', tcOperation )
		AddProperty( loData, 'LogTS', Datetime() )
		lcTableLog = tcTable + 'Log'

		Insert into (lcTableLog) from Name loData


	Endif && Used( tcTable )

	Return .T.

Endproc && _ir_log

*
* GetTableAlias
Procedure GetTableAlias( tcTalbeName As String )
	Local lcRet As String
	Local i As Integer
	Local Array laUsed[ 1 ]
	Local lnCnt As Integer
	Local llOk As Boolean
	Local lcCommand As String

	lcRet = tcTalbeName
	Do Case
		Case Used( tcTalbeName )
			lcRet = tcTalbeName

		Case Used( 'temp_' + tcTalbeName )
			lcRet = 'temp_' + tcTalbeName

		Otherwise
			lnCnt = Aused( laUsed )
			i = 1
			Do While i < lnCnt And ! llOk
				llOk = ( Lower( CursorGetProp( "SourceName", laUsed[ i ] ) ) == Lower( tcTalbeName ) )
				lcRet = laUsed[ i ]
				i = i + 1

			Enddo
			If ! llOk
				lcRet = 'temp_' + tcTalbeName
				Use ( tcTalbeName ) In 0 Shared Again Alias ( lcRet )

			Endif  && ! llOk

	Endcase

	Return lcRet

Endproc && GetTableAlias

			ENDTEXT

			*!*	Strtofile( lcProcir_log, "_ir_log.txt" )

			*!*	Append Procedures From "_ir_log.txt" OVERWRITE

			*!*	Erase "_ir_log.txt"

			*!*	Genero los Triggers

			* lcTriggerFile = Sys(2015) + ".trf"
			lcTriggerFile = Forceext( Sys(2015), "trf" )

			* Strtofile( "", lcTriggerFile, 0 )
			Strtofile( lcProcir_log + CR, lcTriggerFile, 0 )

			For Each loTable In loColTables
				If ! loTable.lIsVirtual
					Wait Window "Generando Triggers de " + loTable.Name + "...." Nowait
					loTable.CreateTriggers( lcTriggerFile )

				Endif && ! loTable.lIsVirtual

			Endfor

			Strtofile( CR + CR + CR + CR, lcTriggerFile, 1 )

			Append Procedures From &lcTriggerFile Overwrite

			*!*	Agregar Store Procedures
			For Each loStoreProcedure In This.oColStoreProcedures

				Wait Window "Generando Store Procedures desde " + Justfname( loStoreProcedure.cFileName ) + "...." Nowait

				Append Procedures From ( loStoreProcedure.cFileName )

			Endfor

			Erase &lcTriggerFile

			This.Close()

			*This.Pack()

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			* loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = Null
			loColTables = Null

		Endtry

	Endproc && Update

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Create
	*!* Description...: Crea la base de datos
	*!* Date..........: Martes 29 de Mayo de 2007 (11:52:03)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Create( ) As Boolean;
			HELPSTRING "Crea la base de datos"

		Local llOk As Boolean
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			llOk = .T.

			Create Database Addbs( This.Folder ) + This.Name + "." + This.Ext

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			llOk = .F.

			TEXT To lcCommand NoShow TextMerge Pretext 15
				Create Database <<Addbs( This.Folder )>><<This.Name>>.<<This.Ext>>
			ENDTEXT

			Strtofile( lcCommand, "ERROR_" + Program() + ".prg" )

			Throw loError

		Finally
			loError = Null

		Endtry

		Return llOk

	Endproc && Create

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Open
	*!* Description...: Abre la base de datos
	*!* Date..........: Martes 29 de Mayo de 2007 (11:52:03)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Open( ) As Boolean;
			HELPSTRING "Abre la base de datos"

		Local llOk As Boolean
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			llOk = .T.

			If File( Addbs( This.Folder ) + This.Name + "." + This.Ext )

				If Not Dbused(Juststem( This.Name ))
					Open Database Addbs( This.Folder ) + This.Name + "." + This.Ext

				Else
					Set Database To Juststem( This.Name )

				Endif

				*!*					Open Database Addbs( This.Folder ) + This.Name + "." + This.Ext

			Else
				This.Create()

			Endif


		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			* loError = This.oError
			loError.Process( oErr )
			llOk = .F.
			Throw loError

		Finally
			loError = Null

		Endtry

		Return llOk

	Endproc && Open

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Close
	*!* Description...: Cierra la Base de Datos
	*!* Date..........: Martes 29 de Mayo de 2007 (11:52:38)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Close( ) As Boolean;
			HELPSTRING "Cierra la Base de Datos"

		Local llOk As Boolean
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			llOk = .T.

			Close Databases

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			* loError = This.oError
			loError.Process( oErr )
			llOk = .F.
			Throw loError

		Finally
			loError = Null

		Endtry

		Return llOk

	Endproc && Close

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Set
	*!* Description...: Setea la Base de datos como la base activa
	*!* Date..........: Martes 29 de Mayo de 2007 (11:53:55)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Set( ) As Boolean;
			HELPSTRING "Setea la Base de datos como la base activa"

		Local llOk As Boolean
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			llOk = .T.

			Set Database To (This.Name)

		Catch To oErr
			* DAE 2009-11-06(17:15:01)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			llOk = .F.
			Throw loError

		Finally
			loError = Null

		Endtry

		Return llOk

	Endproc && Set

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Delete
	*!* Description...: Elimina fisicamente la Base de datos
	*!* Date..........: Martes 29 de Mayo de 2007 (11:54:28)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Delete( lDeleteTables As Boolean ) As Boolean;
			HELPSTRING "Elimina fisicamente la Base de datos"

		Local llOk As Boolean
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			llOk = .T.

			If lDeleteTables
				Delete Database Addbs( This.Folder ) + This.Name + "." + This.Ext Deletetables

			Else
				Delete Database Addbs( This.Folder ) + This.Name + "." + This.Ext

			Endif

		Catch To oErr
			* DAE 2009-11-06(17:14:49)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			llOk = .F.
			Throw loError

		Finally
			loError = Null

		Endtry

		Return llOk

	Endproc && Delete

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Pack
	*!* Description...: Comprime la base de datos
	*!* Date..........: Martes 29 de Mayo de 2007 (11:52:03)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Pack( ) As Boolean;
			HELPSTRING "Abre la base de datos"

		Local llOk As Boolean
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			llOk = .T.

			If File( Addbs( This.Folder ) + This.Name + "." + This.Ext )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Open Database "<<Addbs( This.Folder )>><<This.Name>>.<<This.Ext>>" Exclusive
				ENDTEXT
				&lcCommand

				TEXT To lcCommand NoShow TextMerge Pretext 15
       			Pack Database
				ENDTEXT
				This.ReTryCommand( lcCommand, 15,  1557, .T. )

			Endif


		Catch To oErr
			* DAE 2009-11-06(17:14:20)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			llOk = .F.
			Throw loError

		Finally
			loError = Null
			This.Close()

		Endtry

		Return llOk

	Endproc && Pack

	* Agrega store procedures
	Procedure AppendProcedures(  ) As Boolean;
			HELPSTRING "Agrega store procedures"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Agrega store procedures
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 27 de Mayo de 2009 (09:05:31)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		*!*	Try

		*!*	Catch To oErr
		*!*		If This.lIsOk
		*!*			This.lIsOk = .F.
		*!*			* DAE 2009-11-06(17:13:41)
		*!*			* This.cXMLoError = This.oError.Process( oErr )
		*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
		*!*			This.cXMLoError = loError.Process( oErr )
		*!*			Throw loError
		*!*		Endif

		*!*	Finally
		*!*		* DAE 2009-11-06(17:13:47)
		*!*		*!*	If !This.lIsOk
		*!*		*!*		Throw This.oError
		*!*		*!*	Endif

		*!*	Endtry

	Endproc && AppendProcedures

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: Generate
	*!*	*!* Description...: Genera las Tier para la tabla, la configuración de las Tiers y el Formulario.
	*!*	*!* Date..........: Miércoles 11 de Marzo de 2009 (13:57:33)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001 -
	*!*	*!*
	*!*	*!*

	*!*	Procedure Generate( oProject As VisualFoxpro.IFoxProject, lAddToProject As Boolean, lOverWrite As Boolean ) As Boolean;
	*!*			HELPSTRING "Genera las Tier para la tabla, la configuración de las Tiers y el Formulario."

	*!*		Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*		Try

	*!*			For Each loTable As oTable Of "Tools\Sincronizador\colDataBases.prg" In This.oColTables
	*!*				This.CreateForm( oProject, loTable, lAddToProject, lOverWrite )
	*!*				This.CreateClass( oProject, loTable, lAddToProject, lOverWrite )

	*!*			Endfor

	*!*		Catch To oErr
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally
	*!*			loTable = Null
	*!*			loError = Null

	*!*		Endtry

	*!*	Endproc && Generate

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: CreateForm
	*!*	*!* Description...: Crea el formulario para representar la tabla
	*!*	*!* Date..........: Miércoles 11 de Marzo de 2009 (13:59:42)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001 -
	*!*	*!*
	*!*	*!*

	*!*	Procedure CreateForm( oProject As VisualFoxpro.IFoxProject, oTable As Object, ;
	*!*			lAddToProject As Boolean, lOverWrite As Boolean ) As Void;
	*!*			HELPSTRING "Crea el formulario para representar la tabla"

	*!*		Local lcCommand As String
	*!*		Local loCnt As Object
	*!*		Local loForm As Object
	*!*		Local loElem As Object
	*!*		Local lnTop As Number
	*!*		Local lcFile As String
	*!*		Local iq As Number
	*!*		Local lcSafety As String
	*!*		Local lcTableName As String
	*!*		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"
	*!*		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*		Local i As Integer
	*!*		Local l As Integer
	*!*		Local m As Integer
	*!*		Local lNew As Boolean
	*!*		Local lNewControl As Boolean
	*!*		Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*		Local lcPath As String

	*!*		#If .F.
	*!*			Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*		#Endif

	*!*		Try

	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			lcSafety = Set( "Safety" )
	*!*			Set Safety Off
	*!*			lcTableName = Alltrim( oTable.Name )
	*!*			lcFormName = CamelProperCase( Alltrim( oTable.cFormName ) )
	*!*			lcFormName = Iif( Lower( Left( lcFormName, 3 ) ) = 'abm', 'ABM' + Space( 1 ) + Alltrim( Substr( lcFormName, 4 ) ), lcFormName )
	*!*			lcFile = Forceext( Alltrim( Addbs( This.cProjectPath ) + Addbs( 'scx' ) + lcFormName ), 'scx' )
	*!*			* lcFile = ProperFileName( lcFile )

	*!*			If ! File( lcFile ) Or lOverWrite

	*!*				If File( lcFile ) And lOverWrite
	*!*					Wait Window "Borrando el formulario " + Justfname( lcFile ) + "...." Nowait
	*!*					Delete File lcFile
	*!*					Delete File Forceext( lcFile, 'sct' )

	*!*				Endif && File( lcFile ) And lOverWrite
	*!*				lNew = ! File( lcFile )
	*!*				If lNew

	*!*					lcPath = Justpath( lcFile )

	*!*					This.CreateDirIfNotExists( lcPath )

	*!*					loError.TraceLogin = 'Table: ' + oTable.Name + CR ;
	*!*						+ "Create Form " + lcFile + CR
	*!*					Wait Window "Creando el formulario " + Justfname( lcFile ) + "...." Nowait
	*!*					TEXT To lcCommand NoShow TextMerge Pretext 15
	*!*						Create Form '<<lcFile>>' As <<Alltrim( oTable.cFormClass )>>
	*!*						From "<<Addbs( Alltrim( oTable.cFormClassLibFolder ) )>><<Alltrim( oTable.cFormClassLib )>>"
	*!*						Nowait
	*!*					ENDTEXT
	*!*					loError.TraceLogin = 'Table: ' + oTable.Name + CR ;
	*!*						+ "Create Form " + lcFile
	*!*					loError.Remark = lcCommand

	*!*				Else
	*!*					Wait Window "Modificando el formulario " + Justfname( lcFile ) + "...." Nowait
	*!*					TEXT To lcCommand NoShow TextMerge Pretext 15
	*!*						Modify Form '<<lcFile>>' Nowait
	*!*					ENDTEXT

	*!*				Endif && lNew

	*!*				&lcCommand

	*!*				* Agrego la propiedad cFormName
	*!*				This.AddEntityProperty( oTable, 'cFormName', USER_TIER, 'Addbs( TABLAS_SCX ) + ' + '"' + Justfname( lcFile ) + '"', .F. )

	*!*				* Chequeo si hay que agregar la propiedad ChildList
	*!*				lcChildList = Alltrim( oTable.cChildList )
	*!*				If ! Empty( lcChildList )
	*!*					This.AddEntityProperty( oTable, 'ChildEntity', USER_TIER, lcChildList, .T. )

	*!*				Endif && ! Empty( lcChildList )

	*!*				loError.TraceLogin = ""
	*!*				loError.Remark = ""

	*!*				Aselobj( laobj, 1 )
	*!*				loElem = laobj[ 1 ]
	*!*				loForm = This.GetForm( loElem )
	*!*				lnTop = 0
	*!*				If ! Isnull( loForm )
	*!*					If Pemstatus( loForm, 'DatosEntidad', 5 )
	*!*						loCnt = loForm.DatosEntidad
	*!*						If Pemstatus( loForm.DatosEntidad, 'cntDefault', 5 )
	*!*							lnTop = loForm.DatosEntidad.cntDefault.Top ;
	*!*								+ loForm.DatosEntidad.cntDefault.Height
	*!*						Endif
	*!*					Else
	*!*						loCnt = loForm
	*!*					Endif
	*!*					lcTableName = CamelProperCase( Alltrim( oTable.Name ) )

	*!*					If lNew Or lOverWrite
	*!*						* lcFormCaption = CamelProperCase( Alltrim( oTable.cFormName ) )
	*!*						* lcFormCaption = Iif( Lower( Left( lcFormCaption, 3 ) ) = 'abm', 'ABM' + Space( 1 ) + Alltrim( Substr( lcFormCaption, 3 ) ), lcFormCaption )

	*!*						loForm.Caption = lcFormName
	*!*						lcFormName = Chrtran( Chrtran( loForm.Caption, ' ', '' ), '-', '_' )
	*!*						loForm.Name = lcFormName
	*!*						loForm.cDataConfigurationKey = oTable.cDataConfigurationKey
	*!*						loCnt.lblTitulo.Visible = .F.

	*!*					Endif && lNew Or lOverWrite

	*!*					For Each loField In oTable.oColFields
	*!*						* Agruego los controles al formulario
	*!*						* en el contenedor DatosEntidad
	*!*						If ! Inlist( Lower( loField.Name ), 'ts', 'transactionid', 'codigo', 'descripcion', 'default' ) ;
	*!*								And loField.IndexKey # IK_PRIMARY_KEY
	*!*							lcFieldName = CamelProperCase( Alltrim( loField.Name ) )
	*!*							lcSafeFieldName = Chrtran( Chrtran( lcFieldName, ' ', '' ), '-', '_' )
	*!*							lcObjName = 'cnt' + lcSafeFieldName
	*!*							* Determino si ya existe el control
	*!*							lNewControl = ! Pemstatus( loCnt, lcObjName, 5 )
	*!*							If lNewControl
	*!*								* Debug
	*!*								loError.TraceLogin = 'Table: ' + oTable.Name + CR ;
	*!*									+ 'Field: ' + loField.Name + CR ;
	*!*									+ "Newobject " + lcObjName
	*!*								loError.Remark = 'ObjName: ' + lcObjName + CR ;
	*!*									+ 'DisplayClass: ' + loField.DisplayClass + CR ;
	*!*									+ 'DisplayClassLibrary: ' + loField.DisplayClassLibrary
	*!*								* Creo el Nuevo Control
	*!*								loCnt.Newobject( lcObjName, loField.DisplayClass, loField.DisplayClassLibrary )

	*!*							Endif && lNewControl
	*!*							loError.TraceLogin = ""
	*!*							loError.Remark = ""

	*!*							* Si es Nuevo o hay que sobreescribirlo
	*!*							If lNewControl Or lOverWrite
	*!*								loCnt.&lcObjName..Top = lnTop
	*!*								lnTop = loCnt.&lcObjName..Top + loCnt.&lcObjName..Height
	*!*								loCnt.&lcObjName..Label.Caption = lcFieldName
	*!*								loCnt.&lcObjName..CursorName = ''
	*!*								loCnt.&lcObjName..FieldName = loField.Name
	*!*								loCnt.&lcObjName..Length = Iif( Inlist( Lower( loField.FieldType ), 'character', 'varchar' ), loField.FieldWidth, loField.FieldWidth + loField.FieldPrecision + 1 )
	*!*								loCnt.&lcObjName..cField = lcTableName + '.' + loField.Name
	*!*								loCnt.&lcObjName..ControlSource = oTable.cCursorName + '.' + loField.Name
	*!*								loCnt.&lcObjName..Dato.ControlSource = loCnt.&lcObjName..ControlSource

	*!*							Endif && lNewControl Or lOverWrite

	*!*						Endif

	*!*					Endfor

	*!*					Do Case
	*!*						Case Inlist( Lower( oTable.cFormClass ), 'abmparentfamilyform', 'abmparentchildform' )
	*!*							lcChildList = Alltrim( oTable.cChildList )
	*!*							If ! Empty( lcChildList )
	*!*								If Right( lcChildList, 1 ) # ','
	*!*									lcChildList = lcChildList + ','
	*!*								Endif && Right( lcChildList, 1 ) # ','
	*!*								lnCnt = Occurs( ',', lcChildList )
	*!*								If lNew Or lOverWrite
	*!*									If loForm.FamilyPageFrame.Tabs And lnCnt > 2
	*!*										loForm.FamilyPageFrame.PageCount = Iif( lnCnt > 0, lnCnt, loForm.FamilyPageFrame.PageCount )
	*!*									Endif && loForm.FamilyPageFrame.Tabs And lnCnt > 2
	*!*								Endif && lNew Or lOverWrite
	*!*								iq = 1
	*!*								For i = 1 To lnCnt
	*!*									lcChildName = Lower( Alltrim( Getwordnum( lcChildList, i, ',' ) ) )
	*!*									j = This.oColTables.GetKey( lcChildName )
	*!*									If ! Empty( j )
	*!*										loTable = This.oColTables.Item( j )
	*!*										lcPage = 'Page' + Transform( iq )
	*!*										lcChildName = CamelProperCase( lcChildName )
	*!*										lcSafeChildName = Chrtran( Chrtran( lcChildName, ' ', '' ), '-', '_' )
	*!*										lcObjName = 'cnt' + lcSafeChildName
	*!*										* Determino si ya existe el control
	*!*										lNewControl = ! Pemstatus( loForm.FamilyPageFrame.&lcPage, lcObjName, 5 )
	*!*										If lNewControl
	*!*											* Verifico si la tabla tiene los campos UniqueCode y ParentUniqueCode
	*!*											* que me indican que la entidad se muestra como un árbol
	*!*											l = loTable.oColFields.GetKey( 'uniquecode' )
	*!*											m = loTable.oColFields.GetKey( 'parentuniquecode' )

	*!*											If ! Empty( l ) And ! Empty( m )
	*!*												loForm.FamilyPageFrame.&lcPage..Newobject( lcObjName, 'ABMChildTree', 'fw\comun\vcx\prxmainform.vcx' )
	*!*											Else
	*!*												loForm.FamilyPageFrame.&lcPage..Newobject( lcObjName, 'ABMChildGrid', 'fw\comun\vcx\prxmainform.vcx' )
	*!*											Endif && ! Empty( l ) And ! Empty( m )
	*!*										Endif && lNewControl
	*!*										If lNewControl Or lOverWrite
	*!*											loForm.FamilyPageFrame.&lcPage..Caption = lcChildName
	*!*											loForm.FamilyPageFrame.&lcPage..&lcObjName..cDataConfigurationKey = lcSafeChildName
	*!*											loForm.FamilyPageFrame.&lcPage..&lcObjName..ParentConfigurationKey = oTable.cDataConfigurationKey
	*!*										Endif && lNewControl Or lOverWrite
	*!*										iq = iq + 1
	*!*									Else
	*!*										loError.TraceLogin = 'Table: ' + oTable.Name + CR ;
	*!*											+ "ChildName:" + lcChildName
	*!*										loError.Remark = ""
	*!*										Error 'No se encontro la tabla'
	*!*									Endif && ! Empty( j )
	*!*								Endfor
	*!*							Endif
	*!*					Endcase

	*!*					TEXT To lcCommand NoShow TextMerge Pretext 15
	*!*					Modify Form '<<lcFile>>' Nowait Save
	*!*					ENDTEXT
	*!*					&lcCommand
	*!*					DoEvents

	*!*					* Grabo el archivo
	*!*					* Asi evito que me pregunte al cerrar el formulario si lo quiero grabar
	*!*					Sys( 1500, '_MFI_SAVE', '_MFILE' )
	*!*					DoEvents

	*!*					* Cierro el archivo
	*!*					Sys( 1500, '_MFI_CLOSE', '_MFILE' )

	*!*					If ! Isnull( oProject ) And lAddToProject
	*!*						oProject.Files.Add( lcFile )
	*!*					Endif && ! Isnull( oProject ) And lAddToProject

	*!*				Endif

	*!*			Endif
	*!*		Catch To oErr
	*!*			If Vartype( loError ) # 'O'
	*!*				loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			Endif
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally
	*!*			loCnt = Null
	*!*			loForm = Null
	*!*			loElem = Null
	*!*			loField = Null
	*!*			loTable = Null
	*!*			loError = Null
	*!*			loProperty = Null

	*!*			Set Safety &lcSafety
	*!*		Endtry

	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE CreateForm
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Function......: GetForm
	*!*	*!* Description...: Devuelve la referencia al formulario nuevo
	*!*	*!* Date..........: Miércoles 11 de Marzo de 2009 (14:11:41)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001 -
	*!*	*!*
	*!*	*!*

	*!*	Function GetForm( oElem As Object ) As Form ;
	*!*			HELPSTRING "Devuelve la referencia al formulario nuevo"

	*!*		Try
	*!*			Do While ! Isnull( oElem ) And Lower( oElem.BaseClass ) # 'form'
	*!*				oElem = oElem.Parent
	*!*			Enddo


	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally

	*!*		Endtry

	*!*		Return oElem

	*!*	Endfunc
	*!*	*!*
	*!*	*!* END FUNCTION GetForm
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: CreateClass
	*!*	*!* Description...: Crea las Tier que representan a la tabla
	*!*	*!* Date..........: Miércoles 11 de Marzo de 2009 (13:59:42)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001 -
	*!*	*!*
	*!*	*!*

	*!*	Procedure CreateClass( oProject As VisualFoxpro.IFoxProject, oTable As Object, ;
	*!*			lAddToProject As Boolean, lOverWrite As Boolean ) As Void;
	*!*			HELPSTRING "Crea el formulario para representar la tabla"

	*!*		Local lcPrefijo As String
	*!*		Local lcSafety As String
	*!*		Local lcClassName As String
	*!*		Local lcProperties As String
	*!*		Local lcMethods As String
	*!*		Local lcPath As String
	*!*		Local i As Integer
	*!*		Local loProperty As oProperty Of "Tools\Sincronizador\colDataBases.prg" In oColProperties
	*!*		Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*		#If .F.
	*!*			Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*		#Endif
	*!*		Try

	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )

	*!*			lcSafety = Set( "Safety" )
	*!*			Set Safety Off
	*!*			* Verifico si existen las propiedades
	*!*			* para cada uno de los tipos de entidades

	*!*			Do Case
	*!*				Case oTable.nClassType = CT_ARCHIVOS

	*!*					This.AddEntityProperty( oTable, 'cSelectorFormCaption', USER_TIER, CamelProperCase( oTable.Name ), .T. )

	*!*				Case Inlist( oTable.nClassType, CT_CHILD, CT_CHILDTREE )

	*!*					This.AddEntityProperty( oTable, 'cMainCursorName', USER_TIER, oTable.cCursorName, .T., 'Nombre del cursor principal' )

	*!*					loField = oTable.GetPrimaryKey()
	*!*					If ! Isnull( loField )
	*!*						This.AddEntityProperty( oTable, 'cMainCursorPK', USER_TIER, loField.Name, .T., 'Valor de la PK del cursor principal' )
	*!*					Endif

	*!*					If oTable.nClassType = CT_CHILDTREE
	*!*						This.AddEntityProperty( oTable, 'cTreePKField', USER_TIER, 'UniqueCode', .T., 'Nombre del campo clave para armar el arbol', .T. )
	*!*						This.AddEntityProperty( oTable, 'cTreeParentPKField', USER_TIER, 'ParentUniqueCode', .T., 'Nombre del campo clave-padre para armar el arbol', .T. )
	*!*						This.AddEntityProperty( oTable, 'cTreeDescField', USER_TIER, 'Descripcion', .T., 'Nombre del campo con el texto a mostrar en el arbol', .T. )
	*!*						This.AddEntityProperty( oTable, 'cTreeCodigoField', USER_TIER, 'Codigo', .T., 'Nombre del campo que representa el codigo', .T. )
	*!*						This.AddEntityProperty( oTable, 'nTreeNodeLabelCfg', USER_TIER, 'tvw_label_desc', .F., 'Configuracón del texto que muestran los nodos', .T. )
	*!*						This.AddEntityProperty( oTable, 'lExpandNodeOnInit', USER_TIER, '.T.', .F., 'Indica si los nodos con hijos aparecen expandidos al momento de que se crean en el arbol', .T. )
	*!*					Endif

	*!*				Otherwise
	*!*			Endcase

	*!*			lcPath = Addbs( oTable.cBaseClassLib )
	*!*			If ! Directory( lcPath )
	*!*				lcPath = Addbs( Set( "Default" ) ) + Addbs( oTable.cBaseClassLib )
	*!*				If ! Directory( lcPath )
	*!*					loError.TraceLogin = 'No se puede encontrar el directorio de las clases ' + oTable.cBaseClassLib
	*!*					Error 'No se encuentra el path de las clases ' + CR + oTable.Name
	*!*				Endif
	*!*			Endif
	*!*			loError.TraceLogin = ''

	*!*			lcClassName = oTable.cDataConfigurationKey
	*!*			Wait Window "Creando las Tier para la entidad " + lcClassName + "...." Nowait
	*!*			lcDir = 'Client'

	*!*			If oTable.lHasUserTier
	*!*				* User
	*!*				lcPrefijo = 'ut'
	*!*				If ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*					lcProperties = This.GetProperties( oTable.oColProperties, USER_TIER )
	*!*					lcMethods = This.GetSetGridLayout( oTable ) + CR ;
	*!*						+ This.GetHookAfterNew()
	*!*					This.WriteClass( lcPrefijo + lcClassName, lcPrefijo + oTable.cBaseClass, ;
	*!*						lcPath + lcDir, Addbs( This.cProjectPath ) + lcDir, ;
	*!*						lcProperties, lcMethods, lOverWrite )
	*!*				Endif && ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*			Endif && oTable.lHasUserTier

	*!*			If oTable.lHasValidTier
	*!*				* Valid
	*!*				lcPrefijo = 'vt'
	*!*				If ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*					lcProperties = This.GetProperties( oTable.oColProperties, VALID_TIER )
	*!*					lcMethods = ''
	*!*					This.WriteClass( lcPrefijo + lcClassName, lcPrefijo + oTable.cBaseClass, ;
	*!*						lcPath + lcDir, Addbs( This.cProjectPath ) + lcDir, ;
	*!*						lcProperties, lcMethods, lOverWrite )
	*!*				Endif && ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*			Endif && oTable.lHasValidTier

	*!*			If oTable.lHasClientWsTier
	*!*				* ClientWs
	*!*				lcPrefijo = 'ct'
	*!*				If ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*					lcProperties = This.GetProperties( oTable.oColProperties, CLIENTWS_TIER )
	*!*					lcMethods = ''
	*!*					This.WriteClass( lcPrefijo + lcClassName, lcPrefijo + oTable.cBaseClass, ;
	*!*						lcPath + lcDir, Addbs( This.cProjectPath ) + lcDir, ;
	*!*						lcProperties, lcMethods, lOverWrite )
	*!*				Endif && ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*			Endif && oTable.lHasClientWsTier

	*!*			lcDir = 'Server'
	*!*			* If oTable.nClassType = CT_ARCHIVOS
	*!*			If oTable.lHasServerWsTier
	*!*				* ServerWs
	*!*				lcPrefijo = 'st'
	*!*				If ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*					lcProperties = This.GetProperties( oTable.oColProperties, SERVER_TIER )
	*!*					lcMethods = ''
	*!*					This.WriteClass( lcPrefijo + lcClassName, lcPrefijo + oTable.cBaseClass, ;
	*!*						lcPath + lcDir, Addbs( This.cProjectPath ) + lcDir, ;
	*!*						lcProperties, lcMethods, lOverWrite )
	*!*				Endif && ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*			Endif && oTable.lHasServerWsTier

	*!*			If oTable.lHasBussinessTier
	*!*				* Business
	*!*				lcPrefijo = 'bt'
	*!*				If ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*					lcProperties = This.GetProperties( oTable.oColProperties, BUSSINESS_TIER )
	*!*					lcMethods = ''
	*!*					This.WriteClass( lcPrefijo + lcClassName, lcPrefijo + oTable.cBaseClass, ;
	*!*						lcPath + lcDir, Addbs( This.cProjectPath ) + lcDir, ;
	*!*						lcProperties, lcMethods, lOverWrite )
	*!*				Endif && ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*			Endif && oTable.lHasBussinessTier

	*!*			If oTable.lHasDataTier
	*!*				*Data
	*!*				lcPrefijo = 'dt'
	*!*				If ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*					lcProperties = This.GetProperties( oTable.oColProperties, DATA_TIER)
	*!*					lcMethods = ''
	*!*					This.WriteClass( lcPrefijo + lcClassName, lcPrefijo + oTable.cBaseClass, ;
	*!*						lcPath + lcDir, Addbs( This.cProjectPath ) + lcDir, ;
	*!*						lcProperties, lcMethods, lOverWrite )
	*!*				Endif && ! File( Forceext( Addbs( lcPath + lcDir ) + lcPrefijo + lcClassName, 'prg' ) ) Or lOverWrite
	*!*			Endif && oTable.lHasDataTier

	*!*		Catch To oErr
	*!*			If Vartype( loError ) # 'O'
	*!*				loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			Endif
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally
	*!*			loProperty = Null
	*!*			loField = Null
	*!*			Set Safety &lcSafety
	*!*		Endtry

	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE CreateClass
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Function......: GetProperties
	*!*	*!* Description...: Devuelve las propiedades definidas para una Tier
	*!*	*!* Date..........: Jueves 12 de Marzo de 2009 (01:19:00)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001 -
	*!*	*!*
	*!*	*!*

	*!*	Function GetProperties( oColProperties As Collection, nTierLevel As Integer ) As String;
	*!*			HELPSTRING "Devuelve las propiedades definidas para una Tier"

	*!*		Local luReturnValue As String
	*!*		luReturnValue = ''
	*!*		For Each loProperty As oProperty Of "Tools\Sincronizador\colDataBases.prg" In oColProperties
	*!*			If loProperty.nTierLevel = nTierLevel
	*!*				luReturnValue = luReturnValue + Tab + Strtran( loProperty.ToString(), CR, CR + Tab ) + CR
	*!*			Endif
	*!*		Endfor

	*!*		Return luReturnValue
	*!*	Endfunc
	*!*	*!*
	*!*	*!* END FUNCTION GetProperties
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////


	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: AddEntityProperty
	*!*	*!* Description...:
	*!*	*!* Date..........: Viernes 13 de Marzo de 2009 (16:01:00)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001 -
	*!*	*!*
	*!*	*!*

	*!*	Function AddEntityProperty( oTable As Object, cProperty As String, ;
	*!*			nTierLevel As Integer, cValue As String,;
	*!*			lAddQuotes As Boolean, cComment As String,;
	*!*			lAddComment As Boolean, lCarriageReturn As Boolean ) As Boolean

	*!*		#If .F.
	*!*			Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*		#Endif
	*!*		Local i As Integer
	*!*		Local lRet As Boolean
	*!*		Try

	*!*			i = oTable.oColProperties.GetKey ( Lower( cProperty ) )
	*!*			If Empty( i )
	*!*				loProperty = oTable.oColProperties.New( cProperty )
	*!*				With loProperty As oProperty Of "Tools\Sincronizador\colDataBases.prg"
	*!*					.nTierLevel = nTierLevel
	*!*					.Value = cValue
	*!*					.lAddQuotes = lAddQuotes
	*!*					.Comment = IfEmpty( cComment, '' )
	*!*					.lAddComment = lAddComment
	*!*					If Pcount() >= 8
	*!*						.lCarriageReturn = lCarriageReturn
	*!*					Endif
	*!*				Endwith
	*!*				lRet = .T.
	*!*			Endif

	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally
	*!*			loProperty = Null
	*!*		Endtry
	*!*		Return lRet
	*!*	Endfunc
	*!*	*!*
	*!*	*!* END PROCEDURE AddEntityProperty
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: GetSetGridLayout
	*!*	*!* Description...: Devuelve el codigo del metodo SetGridLayout para UserTier
	*!*	*!* Date..........: Sábado 21 de Marzo de 2009 (13:06:46)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001  -
	*!*	*!*
	*!*	*!*

	*!*	Procedure GetSetGridLayout( oTable As Object ) As String;
	*!*			HELPSTRING "Devuelve el codigo del metodo SetGridLayout para UserTier"

	*!*		Local lcText As String
	*!*		* Local loField As oField Of "Tools\Actual\Sincronizador\colDataBases.prg"
	*!*		Private pcUser As String
	*!*		Private pcProject As String
	*!*		Private poTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*		Try
	*!*			lcText = ''
	*!*			pcUser = Iif( Vartype( _user ) # 'U', Alltrim( _user ), 'Developer Praxis' )
	*!*			pcProject = 'Sistemas Praxis'
	*!*			poTable = oTable

	*!*			Do wwScripting
	*!*			Local loScript As wwScripting
	*!*			loScript = Createobject( "wwScripting" )

	*!*			* lcText = loScript.Mergetext( 'Templates\Proc.SetGridLayout.tpl.prg' , .T. )
	*!*			If ! ( 'procsetgridlayouttpl.prg' $ Lower( Set( "Procedure" ) ) )
	*!*				Set Procedure To 'Templates\ProcSetGridLayoutTpl.prg' Additive
	*!*			Endif
	*!*			lcText = ProcSetGridLayoutTpl()

	*!*			*!*	            TEXT To lcRet NoShow TextMerge ADDITIVE

	*!*			*!*		*!* ///////////////////////////////////////////////////////
	*!*			*!*		*!* Procedure.....: SetGridLayaout
	*!*			*!*		*!* Date..........: <<DateMask(date())>> (<<time()>>)
	*!*			*!*		*!* Author........: <<lcUser>>
	*!*			*!*		*!* Project.......: <<lcProject>>
	*!*			*!*		*!* -------------------------------------------------------
	*!*			*!*		*!* Modification Summary
	*!*			*!*		*!* R/0001 -
	*!*			*!*		*!*

	*!*			*!*		Procedure SetGridLayout

	*!*			*!*	    	Local loGridLayaut As oGridLayout Of "Fw\Actual\Comun\Prg\colGridLayout.prg"

	*!*			*!*		    Try

	*!*			*!*	            ENDTEXT

	*!*			*!*	            For Each loField In oTable.oColFields

	*!*			*!*	                If loField.lShowInGrid

	*!*			*!*	                    TEXT To lcRet NoShow TextMerge ADDITIVE

	*!*			*!*	    	    loGridLayaut = This.oColGridLayout.New( "<<loField.Name>>" )
	*!*			*!*	        	With loGridLayaut As oGridLayout Of "Fw\Actual\Comun\Prg\colGridLayout.prg"
	*!*			*!*	                .HeaderCaption = "<<loField.Caption>>"
	*!*			*!*	                .ColumnControlSource = "<<loField.Name>>"
	*!*			*!*	                .Length = This.GetLen( "<<loField.Name>>" )
	*!*			*!*	                .IsNumeric = <<Iif( InList( Lower( loField.FieldType ), "currency", "integer", "numeric", "float", "double" ), .T., .F. )>>
	*!*			*!*	                If .IsNumeric
	*!*			*!*	                    .ColumnInputMask = Replicate( "9", .Length )
	*!*			*!*	                    .ColumnAlignment = ALIGN_RIGHT
	*!*			*!*	                EndIf
	*!*			*!*					* .lFitColumn = .T.
	*!*			*!*					* .lOrderByThis = .T.
	*!*			*!*	            EndWith

	*!*			*!*	                    ENDTEXT

	*!*			*!*	                Endif

	*!*			*!*	            Next

	*!*			*!*	            TEXT To lcRet NoShow TextMerge ADDITIVE

	*!*			*!*	    	Catch To oErr
	*!*			*!*	        	If This.IsOk
	*!*			*!*	           		This.IsOk = .F.
	*!*			*!*	            	This.XMLoError = This.oError.Process( oErr )
	*!*			*!*		        Endif
	*!*			*!*	    	    Throw This.oError
	*!*			*!*		    Finally
	*!*			*!*				loGridLayaut = Null
	*!*			*!*			Endtry
	*!*			*!*		EndProc

	*!*			*!*		*!*
	*!*			*!*		*!* END PROCEDURE SetGridLayout
	*!*			*!*		*!*
	*!*			*!*		*!* ///////////////////////////////////////////////////////

	*!*			*!*	            ENDTEXT

	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally
	*!*			* loField = Null
	*!*			poTable = Null
	*!*		Endtry

	*!*		Return lcText
	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE GetSetGridLayout
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: GetHookAfterNew
	*!*	*!* Description...: Devuelve el template del metodo  HookAfterNew
	*!*	*!* Date..........: Lunes 23 de Marzo de 2009 (18:30:40)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001  -
	*!*	*!*
	*!*	*!*

	*!*	Procedure GetHookAfterNew(  ) As String;
	*!*			HELPSTRING "Devuelve el template del metodo  HookAfterNew"

	*!*		Local lcRet As String
	*!*		* Local loField As oField Of "Tools\Actual\Sincronizador\colDataBases.prg"
	*!*		Private pcUser As String
	*!*		Private pcProject As String

	*!*		Try
	*!*			lcRet = ''
	*!*			pcUser = Iif( Vartype( _user ) # 'U', Alltrim( _user ), 'Developer Praxis' )
	*!*			pcProject = 'Sistemas Praxis'

	*!*			*!*	            Do wwScripting
	*!*			*!*	            Local loScript As wwScripting
	*!*			*!*	            loScript = Createobject( "wwScripting" )

	*!*			* lcText = loScript.Mergetext( 'Templates\Proc.HookAfterNew.tpl.prg' , .T. )
	*!*			If ! ( 'prochookafternewtpl' $ Lower( Set( "Procedure" ) ) )
	*!*				Set Procedure To 'Templates\ProcHookAfterNewTpl.prg' Additive
	*!*			Endif
	*!*			lcText = ProcHookAfterNewTpl()

	*!*			*!*	                TEXT To lcRet NoShow TextMerge ADDITIVE

	*!*			*!*		*!* ///////////////////////////////////////////////////////
	*!*			*!*		*!* Procedure.....: HookAfterNew
	*!*			*!*		*!* Date..........: <<DateMask(date())>> (<<time()>>)
	*!*			*!*		*!* Author........: <<lcUser>>
	*!*			*!*		*!* Project.......: <<lcProject>>
	*!*			*!*		*!* -------------------------------------------------------
	*!*			*!*		*!* Modification Summary
	*!*			*!*		*!* R/0001 -
	*!*			*!*		*!*

	*!*			*!*		Procedure HookAfterNew( toTable As Object,;
	*!*			*!*	            nLevel As Integer, cAlias As String ) As Void

	*!*			*!*	            Dodefault( toTable, nLevel, cAlias )

	*!*			*!*	    EndProc

	*!*			*!*	    *!*
	*!*			*!*	    *!* END PROCEDURE HookAfterNew
	*!*			*!*	    *!*
	*!*			*!*	    *!* ///////////////////////////////////////////////////////


	*!*			*!*	                ENDTEXT

	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError
	*!*		Finally
	*!*			loScript = Null
	*!*		Endtry
	*!*		Return lcRet

	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE GetHookAfterNew
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: GetPopulateTablesByUser
	*!*	*!* Description...: Devuelve el codigo del metodo PopulateTablesByUser para DataTier
	*!*	*!* Date..........: Sábado 21 de Marzo de 2009 (13:06:46)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001  -
	*!*	*!*
	*!*	*!*

	*!*	Procedure GetPopulateTablesByUser( oTable As Object ) As String;
	*!*			HELPSTRING "Devuelve el codigo del metodo PopulateTablesByUser para DataTier"

	*!*		Local lcText As String
	*!*		* Local loField As oField Of "Tools\Actual\Sincronizador\colDataBases.prg"
	*!*		* Private lctables As String
	*!*		Private poTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*		Private poColTables As ColTables Of "Tools\Sincronizador\colDataBases.prg"
	*!*		poTable = oTable
	*!*		poColTables = This.oColTables
	*!*		lcText = ''
	*!*		* lctables = ''
	*!*		Try

	*!*			*!*	            Do wwScripting
	*!*			*!*	            Local loScript As wwScripting
	*!*			*!*	            loScript = Createobject( "wwScripting" )

	*!*			* Set Step On
	*!*			* lcText = loScript.Mergetext( 'Templates\Proc.PopulateTablesByUser.tpl.prg' , .T. )
	*!*			If ! ( 'procpopulatetablesbyusertpl' $ Lower( Set("Procedure") ) )
	*!*				Set Procedure To 'Templates\ProcPopulateTablesByUserTpl.prg' Additive
	*!*			Endif
	*!*			lcText = ProcPopulateTablesByUserTpl()


	*!*			*!*	            TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*			*!*					*!* ///////////////////////////////////////////////////////
	*!*			*!*					*!* Procedure.....: PopulateTablesByUser
	*!*			*!*					*!* Date..........: <<DateMask(date())>> (<<time()>>)
	*!*			*!*					*!* Author........: <<lcUser>>
	*!*			*!*					*!* Project.......: <<lcProject>>
	*!*			*!*					*!* -------------------------------------------------------
	*!*			*!*					*!* Modification Summary
	*!*			*!*					*!* R/0001 -
	*!*			*!*					*!*

	*!*			*!*					 Procedure PopulateTablesByUser( ) As Void;
	*!*			*!*	            		HELPSTRING "Define las tablas asociadas a la entidad"

	*!*			*!*						Local loTable As oTable Of "FW\Actual\Comun\Prg\colTables.prg"

	*!*			*!*				        Try
	*!*			*!*	            			This.oError.TraceLogin = "Definiendo las tablas asociadas a la entidad"
	*!*			*!*				            This.oError.Remark = "Definiendo Nombre de la Tabla"

	*!*			*!*	            ENDTEXT

	*!*			*!*	            lctables = This.GetPopulateTable( oTable, "", "" )

	*!*			*!*	            TEXT To lcRet NoShow TextMerge ADDITIVE

	*!*			*!*	                			<<lctables>>
	*!*			*!*	        Catch To oErr
	*!*			*!*	            If This.IsOk
	*!*			*!*	                This.IsOk = .F.
	*!*			*!*	                This.XMLoError=This.oError.Process( oErr )
	*!*			*!*	            Endif

	*!*			*!*	        Finally
	*!*			*!*	            This.oError.TraceLogin = ""
	*!*			*!*	            This.oError.Remark = ""

	*!*			*!*	        Endtry
	*!*			*!*		EndProc

	*!*			*!*		*!*
	*!*			*!*		*!* END PROCEDURE PopulateTablesByUser
	*!*			*!*		*!*
	*!*			*!*		*!* ///////////////////////////////////////////////////////

	*!*			*!*	            ENDTEXT

	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError
	*!*		Finally
	*!*			* loField = Null
	*!*			poTable = Null
	*!*			poColTables = Null
	*!*		Endtry
	*!*		Return lcText
	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE GetPopulateTablesByUser
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: GetPopulateTable
	*!*	*!* Description...: Devuelde la configuración de la tabla y sus tablas hijas
	*!*	*!* Date..........: Lunes 23 de Marzo de 2009 (18:45:50)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001  -
	*!*	*!*
	*!*	*!*

	*!*	* Procedure GetPopulateTable( oTable As Object, cMainID As String, cPadre String ) As String
	*!*	Procedure GetPopulateTable( oTable As Object, cMainID As String, cPadre As String ) As String ;
	*!*			Helpstring "Devuelde la configuración de la tabla y sus tablas hijas"
	*!*		Local lcRet As String
	*!*		Local lcForeignKey As String
	*!*		Try
	*!*			lcRet = ''

	*!*			TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*	        	loTable = This.oColTables.New( "<<oTalbe.cCursorName>>" )
	*!*	            With loTable As oTable Of "FW\Comun\Prg\colTables.prg"
	*!*		            *!* Nombre de la tabla
	*!*	    	        .Tabla = "<<oTalbe.Name>>"
	*!*			ENDTEXT
	*!*			loField = oTable.GetPrimaryKey()
	*!*			TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*	            	*!* Nombre de la Primary Key de la tabla/nivel de la entidad
	*!*	                .PKName = "<<loField.Name>>"
	*!*		            .MainID = "<<cMainID>>"
	*!*			ENDTEXT


	*!*			lcForeignKey = ''
	*!*			If ! Empty( cPadre )

	*!*				i = This.oColTables.Key( cPadre )
	*!*				If ! Empty( i )
	*!*				Endif
	*!*			Endif

	*!*			TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*	    	        .ForeignKey = "<<lcForeignKey>>"
	*!*	        	    .Padre = "<<cPadre>>"
	*!*			ENDTEXT

	*!*			lcDefaultSort = "Descripcion"
	*!*			loField = oTable.GetDefaultSort()
	*!*			If ! Isnull( loField )
	*!*				lcDefaultSort = loField.Name
	*!*			Endif

	*!*			TEXT To lcRet NoShow TextMerge ADDITIVE
	*!*	                *!* Indica la clausula ORDER BY para el GetAll(), en caso de Nivel 1, o las tablas Hijas, para los demás niveles
	*!*	            	.OrderBy = "<<lcDefaultSort>>"
	*!*		        Endwith
	*!*			ENDTEXT


	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally

	*!*		Endtry
	*!*		Return lcRet
	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE GetPopulateTable
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////


	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: WriteClass
	*!*	*!* Description...: Crea las Tier que representan a la tabla
	*!*	*!* Date..........: Miércoles 11 de Marzo de 2009 (13:59:42)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001 -
	*!*	*!*
	*!*	*!*

	*!*	Procedure WriteClass( cClassName As String, ;
	*!*			cParentClass As String, cParentClassLibrary As String, ;
	*!*			cFolder As String, cProperties As String, cMethods As String, ;
	*!*			lOverWrite As Boolean )

	*!*		Local lcText As String
	*!*		Public pcFileName As String
	*!*		Public pcUser As String
	*!*		Public pcProject As String
	*!*		Public pcProperties As String
	*!*		Public pcMethods As String
	*!*		Public pcParentClass As String
	*!*		Public pcParentClassLibrary As String
	*!*		Public pcPath As String
	*!*		Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

	*!*		Try

	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			cFolder = Alltrim( cFolder )
	*!*			pcFileName = Forceext( Addbs( cFolder ) + cClassName, 'prg' )
	*!*			If ! File( pcFileName ) Or lOverWrite
	*!*				pcClassName = Alltrim( cClassName )
	*!*				pcParentClass = Alltrim( cParentClass )
	*!*				pcParentClassLibrary = Forceext( Addbs( cParentClassLibrary ) + pcParentClass, 'prg' )
	*!*				pcUser = Iif( Vartype( _user ) # 'U', Alltrim( _user ), 'Developer Praxis' )
	*!*				pcProject = 'Sistemas Praxis'

	*!*				pcProperties = Iif( Vartype( cProperties ) # 'C', '', Alltrim( cProperties ) )
	*!*				pcMethods = Iif( Vartype( cMethods ) # 'C', '', Alltrim( cMethods ) )
	*!*				pcProject = Addbs( Justpath( This.cProjectPath ) ) + 'Include'
	*!*				pcProjectName = ProperCase( This.cProjectName )
	*!*				lcText = ''
	*!*				This.CreateDirIfNotExists( pcProject )

	*!*				* Do wwScripting
	*!*				* Local loScript As wwScripting
	*!*				* loScript = Createobject( "wwScripting" )
	*!*				* Set Step On
	*!*				* lcText = loScript.Mergetext( 'Templates\Class.tpl.prg' , .T. )
	*!*				* lcText = loScript.RenderAspScript( 'Templates\Class.tpl.prg' )
	*!*				If ! ( 'classtpl' $ Lower( Set( "Procedure" ) ) )
	*!*					Set Procedure To 'Templates\ClassTpl.prg' Additive
	*!*				Endif
	*!*				lcText = ClassTpl()
	*!*				pcPath = Justpath( pcFileName )
	*!*				This.CreateDirIfNotExists( pcPath )
	*!*				Strtofile( lcText, pcFileName, 0 )
	*!*			Endif && ! File( pcFileName ) Or lOverWrite
	*!*		Catch To oErr
	*!*			loError.Process( oErr )
	*!*			Throw loError
	*!*		Finally
	*!*			loError = Null
	*!*			loScript = Null

	*!*			Release pcFileName
	*!*			Release pcUser
	*!*			Release pcProject
	*!*			Release pcProperties
	*!*			Release pcMethods
	*!*			Release pcParentClass
	*!*			Release pcParentClassLibrary
	*!*			Release pcPath
	*!*		Endtry
	*!*	Endproc

	*!*	*!*
	*!*	*!* END FUNCTION WriteClass
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////


	*
	* oColStoreProcedures_Access
	Protected Procedure oColStoreProcedures_Access()

		If Vartype( This.oColStoreProcedures ) # "O"
			This.oColStoreProcedures = Createobject( "ColStoreProcedures" )
		Endif

		Return This.oColStoreProcedures

	Endproc && oColStoreProcedures_Access


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Merge
	*!* Description...: Combina 1 un objeto oDatabase con el actual
	*!* Date..........: Viernes 26 de Junio de 2009 (10:30:13)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Merge( toDataBase As oDataBase ) As Boolean;
			HELPSTRING "Combina 1 un objeto oDatabase con el actual"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lcKey As String
		Local lnIndex As Number
		Local loTable As oTable Of "FW\Actual\Comun\Prg\ColTables.prg"
		Local loStoreProcedure As oStoreProcedure Of "FW\Actual\Comun\Prg\ColTables.prg"
		Try
			If Vartype( toDataBase ) = 'O'

				* Copio las tablas
				For i = 1 To toDataBase.oColTables.Count
					lcKey = toDataBase.oColTables.GetKey( i )
					lnIndex = This.oColTables.GetKey( lcKey )
					If Empty( lnIndex )
						loTable = toDataBase.oColTables.Item( i )
						This.oColTables.AddTable( loTable )

					Else
						loTable = toDataBase.oColTables.Item( i )
						If loTable.lForce
							This.oColTables.Remove( lcKey )
							This.oColTables.AddTable( loTable )
						Endif

					Endif
				Endfor

				* Copio los Store Procedures
				For i = 1 To toDataBase.oColStoreProcedures.Count
					lcKey = toDataBase.oColStoreProcedures.GetKey( i )
					lnIndex = This.oColStoreProcedures.GetKey( lcKey )
					If Empty( lnIndex )
						loStoreProcedure = toDataBase.oColStoreProcedures.Item( i )
						This.oColStoreProcedures.New( loStoreProcedure.cFileName, loStoreProcedure.cCodigo )
					Endif
				Endfor

				* Copio los Formularios
				For i = 1 To toDataBase.oColForms.Count
					lcKey = toDataBase.oColForms.GetKey( i )
					lnIndex = This.oColForms.GetKey( lcKey )
					If Empty( lnIndex )
						loForm = toDataBase.oColForms.Item( i )
						This.oColForms.AddItem( loForm, lcKey )
					Endif
				Endfor


				* Copio las Tiers
				For i = 1 To toDataBase.oColTiers.Count
					lcKey = toDataBase.oColTiers.GetKey( i )
					lnIndex = This.oColTiers.GetKey( lcKey )
					If Empty( lnIndex )
						loTiers = toDataBase.oColTiers.Item( i )
						This.oColTiers.AddItem( loTiers, lcKey )
					Endif
				Endfor


			Endif
		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError
		Finally
			loError = Null
		Endtry

	Endproc && Merge

	Procedure oColForms_Access
		If Vartype( This.oColForms ) # "O"
			This.oColForms = Createobject( "ColForms" )
			This.oColForms.oParent = This
		Endif
		Return This.oColForms

	Endproc &&  oColForms_Access

	Procedure oColTiers_Access
		If Vartype( This.oColTiers ) # "O"
			This.oColTiers = Createobject( "colBase" )
			This.oColTiers.oParent = This

		Endif

		Return This.oColTiers

	Endproc && oColForms_Access

	*
	* GetSelectSQL
	Function GetSelectSQL( toTable As Object,;
			tcWhere As String, tlIncludeRelationships As Boolean ) As String

		Local lcFieldsToSQL As String
		Local lcCampos As String
		Local lcSQLStat As String
		Local lcReferencesFieldsToSQL As String
		Local lcJoins As String
		*
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColRef As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loTblRef As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loFldPk As oField Of "Tools\Sincronizador\colDataBases.prg"
		*
		Local i As Integer

		Try

			TEXT To lcFieldsToSQL NoShow TextMerge Pretext 15
				Iif( Empty( cDefaultSqlExp ),
					Iif( lIsVirtual, [ Cast( ] + Iif( InList( Left( Lower( FieldType ) , 3 ), 'log', 'gen', 'cur', 'blo', 'dat', 'cha', 'var', 'mem' ), "''", '0' ) + [ As ] + FieldType
						+ Iif( ! InList( Left( Lower( FieldType ) , 3 ), 'int', 'dat', 'mem' ), [( ] + Transform( FieldWidth )
					    + Iif( ! InList( Left( Lower( FieldType ) , 3 ), 'var', 'int', 'dat', 'cha', 'mem', 'dat' ),
							', ' + Transform( FieldPrecision ),
							'' ) + [ ) ],
						'' ) + [ ) As ] + Name, oParent.Name + [.] + Name ), cDefaultSqlExp )

			ENDTEXT

			TEXT To lcReferencesFieldsToSQL NoShow TextMerge Pretext 15
					Iif( lIsVirtual, [ Cast( ] + Iif( InList( Left( Lower( FieldType ) , 3 ), 'log', 'gen', 'cur', 'blo', 'dat', 'cha', 'var', 'mem' ), "''", '0' ) + [ As ] + FieldType
						+ Iif( ! InList( Left( Lower( FieldType ) , 3 ), 'int', 'dat', 'mem' ), [( ] + Transform( FieldWidth )
					    + Iif( ! InList( Left( Lower( FieldType ) , 3 ), 'var', 'int', 'dat', 'cha', 'mem', 'dat' ),
							', ' + Transform( FieldPrecision ),
							'' ) + [ ) ],
						'' ) + [ ) As ] + oParent.Name + Name, oParent.Name + [.] + Name + [ ] + oParent.Name + Name )

			ENDTEXT

			If ! Empty( tcWhere )
				lcCampos = toTable.oColFields.ToString( lcFieldsToSQL, '', tcWhere )

			Else
				lcCampos = toTable.oColFields.ToString( lcFieldsToSQL )
				tcWhere = ' 1 = 1 '

			Endif &&  ! Empty( tcWhere )

			If tlIncludeRelationships
				loColRef = toTable.oColFields.Where( ' ( ' + tcWhere + ' ) And ! Empty( References ) ' )
				lcJoins = ''
				* Incluir las relaciones con otras tablas
				* Set Step On
				For i = 1 To loColRef.Count

					loField = loColRef.Item[ i ]

					* DAE 2009-10-27(16:27:05)
					* Si la tabla tiene una referencia ella misma no la agrego en los Join's
					If Lower( Alltrim( toTable.Name ) ) # Lower( Alltrim( loField.References ) )

						loTblRef = This.oColTables.GetItem( loField.References )
						Assert Vartype( loTblRef ) = 'O' Message 'No se encontro la tabla'

						lcCamposAux = loTblRef.oColFields.ToString( lcReferencesFieldsToSQL, '', ' nDefaultReference <> 0 ' )
						If ! Empty( lcCamposAux )
							lcCampos = lcCampos + ',' + lcCamposAux

						Endif && ! Empty( lcCamposAux )

						loFldPk = loTblRef.GetPrimaryKey()

						lcJoins = lcJoins + ' Left Outer Join ' + loTblRef.Name ;
							+ ' On ' + loTblRef.Name + '.' + loFldPk.Name + ' = ' + toTable.Name + '.' + loField.Name

					Endif && Lower( toTable.References ) # Lower( loField.References )

				Endfor

				TEXT To lcSQLStat NoShow TextMerge Pretext 15
					Select <<lcCampos>>
					From <<Iif( toTable.lIsVirtual, 'dual', toTable.Name )>>
					<<lcJoins>>

				ENDTEXT

			Else
				TEXT To lcSQLStat NoShow TextMerge Pretext 15
					Select <<lcCampos>>
					From <<Iif( toTable.lIsVirtual, 'dual', toTable.Name )>>

				ENDTEXT

			Endif &&  tlIncludeRelationships

		Catch To oErr
			* DAE 2009-11-06(17:13:11)
			*!*	loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )

			Throw loError

		Finally
			*!*	loError = This.oError
			*!*	loError.Remark = ''
			*!*	loError.TraceLogin = ''
			loError = Null
			loColRef = Null
			loField = Null
			loTblRef = Null
			loFldPk = Null

		Endtry

		Return lcSQLStat

	Endfunc && GetSelectSQL

Enddefine && oDataBase

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColTables
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Bases de Datos
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColTables As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	Name = 'ColTables'
	nNivelJerarquiaTablas = 0

	#If .F.
		Local This As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!* Nombre de la clase de los elementos que forman la coleccion
	cClassName = "oTable"

	* Indica si la coleccion es de tablas libres
	*lIsFree = .T.
	lIsFree = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lisfree" type="property" display="lIsFree" />] + ;
		[<memberdata name="addtable" type="event" display="AddTable" />] + ;
		[<memberdata name="assignlevel" type="method" display="AssignLevel" />] + ;
		[<memberdata name="assignmain" type="method" display="AssignMain" />] + ;
		[<memberdata name="gettable" type="method" display="GetTable" />] + ;
		[<memberdata name="nniveljerarquiatablas" type="property" display="nNivelJerarquiaTablas" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AssignMain
	*!* Description...: Asigna el nivel a cada objeto oTable
	*!* Date..........: Lunes 6 de Febrero de 2006 (21:52:47)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure AssignMain( toCol As collecton, toMain As Object ) As Void;
			HELPSTRING "Asigna el principal a cada objeto oTable"

		Local loTable As oTable Of "Tools\Sincronizador\coldatabases.prg"
		Local loField As oField Of "Tools\Sincronizador\coldatabases.prg"
		Local loRefFieldMain As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			If toCol.Count > 0
				loField = toMain.GetPrimaryKey()
				loRefFieldMain = This.oParent.oColFields.GetItem( loField.Name )
				If Vartype( loRefFieldMain ) = 'O'
					loRefFieldMain.nComboOrder = Iif( Empty( loRefFieldMain.nComboOrder ), -1, loRefFieldMain.nComboOrder )
					loRefFieldMain.nShowInKeyFinder = Iif( Empty( loRefFieldMain.nShowInKeyFinder ), -1, loRefFieldMain.nShowInKeyFinder )

				Endif && Vartype( loRefFieldMain ) = 'O'

				For Each loTable In toCol
					loTable.MainID = loField.Name
					This.AssignMain( loTable.oColTables, toMain )

				Endfor

			Endif && toCol.Count > 0

		Catch To oErr
			* DAE 2009-11-06(17:12:42)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			*!*	loError = This.oError
			*!*	loError.Remark = ''
			*!*	loError.TraceLogin = ''
			loError = Null
			loRefFieldMain = Null
			loTable = Null
			loField = Null

		Endtry

	Endproc && AssignMain

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AssignLevel
	*!* Description...: Asigna el nivel a cada objeto oTable
	*!* Date..........: Lunes 6 de Febrero de 2006 (21:52:47)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure AssignLevel( toCol As collecton,;
			tnNivel As Integer,;
			tnNivelJerarquiaTablas As Integer ) As Void;
			HELPSTRING "Asigna el nivel a cada objeto oTable"

		Local loTable As oTable Of "Tools\Sincronizador\coldatabases.prg"
		Local i As Integer

		For i = 1 To toCol.Count
			loTable = toCol.Item( i )
			loTable.Nivel = tnNivel
			tnNivelJerarquiaTablas = This.AssignLevel( loTable.oColTables, tnNivel + 1, tnNivelJerarquiaTablas + 1 )

		Endfor

		Return tnNivelJerarquiaTablas

	Endproc && AssignLevel

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AssignNivelJerarquiaTablas
	*!* Description...: Asigna el nivel de jerarquia a cada objeto oTable
	*!* Date..........: Lunes 6 de Febrero de 2006 (21:52:47)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure AssignNivelJerarquiaTablas( toCol As collecton,;
			tnNivelJerarquiaTablas As Integer ) As Void;
			HELPSTRING "Asigna el nivel de jerarquia a cada objeto oTable"

		Local loTable As oTable Of "Tools\Sincronizador\coldatabases.prg"
		Local i As Integer

		For i = 1 To toCol.Count
			loTable = toCol.Item( i )
			loTable.nNivelJerarquiaTablas = tnNivelJerarquiaTablas
			This.AssignNivelJerarquiaTablas( loTable.oColTables, tnNivelJerarquiaTablas - 1 )
		Endfor

	Endproc && AssignNivelJerarquiaTablas

	* Devuelve una referencia a la tabla buscada
	Procedure GetTable( tcTableName As String ) As Object;
			HELPSTRING "Devuelve una referencia a la tabla buscada"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve una referencia a la tabla buscada
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 1 de Junio de 2009 (11:51:36)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			tcTableName AS String
			*:Remarks:
			*:Returns:
			Object
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local loTable As oTable Of "tools\sincronizador\coldatabases.prg"
		Local loObj As oTable Of "tools\sincronizador\coldatabases.prg"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			* Pido la tabla con el nombre requerido
			loTable = This.GetItem( tcTableName )

			If Isnull( loTable )

				* Si no existe recorro la colección
				For Each loObj In This

					* Por cada tabla pido a su colección tables por la tabla buscada
					loTable = loObj.oColTables.GetTable( tcTableName )

					If ! Isnull( loTable )
						* Si la encontré, salgo
						Exit

					Endif && ! Isnull( loTable )

				Endfor

			Endif && Isnull( loTable )

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				* DAE 2009-11-06(17:12:00)
				* This.cXMLoError = This.oError.Process( oErr )
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				This.cXMLoError = loError.Process( oErr )
				Throw loError

			Endif && This.lIsOk

		Finally
			* DAE 2009-11-06(17:12:09)
			*!*	If ! This.lIsOk
			*!*		Throw This.oError

			*!*	Endif && ! This.lIsOk

			loError = Null

		Endtry

		Return loTable

	Endproc && GetTable

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddTable
	*!* Description...: Agrega una Tabla a la colección ColTables
	*!* Date..........: Martes 29 de Mayo de 2007 (11:04:54)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure AddTable( toTable As oTable, ;
			tlNoSetParent As Boolean ) As Void;
			HELPSTRING "Agrega una Tabla a la colección ColTables"

		Local i As Integer
		Local lcKey As String,;
			lcTableName As String

*!*			toTable.lIsFree = This.lIsFree

		If Empty( toTable.LongTableName )
			toTable.LongTableName = toTable.Name

		Endif && Empty( toTable.LongTableName )

		If ! tlNoSetParent
			toTable.oParent = This.oParent

		Endif && ! tlNoSetParent

		lcKey = Lower( toTable.cKeyName )
		i = This.GetKey( lcKey )

		If Empty( i )
			* Guardarla con el nombre clave
			This.AddItem( toTable, lcKey )

			* Guardarla con el nombre real
			lcTableName = Strtran( toTable.Name, "sys_", "", -1, -1, 1 )
			i = This.GetKey( Lower( lcTableName ) )

			If Empty( i )
				This.AddItem( toTable, Lower( lcTableName ) )
			Endif
		Endif


	Endproc && AddTable

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oTable vacío
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure New( tcName As String ) As oTable Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oTable vacío"

		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"

		loTable = Createobject( "oTable", This.lIsFree )

		If ! Empty( tcName )
			loTable.Name = Alltrim( tcName )
			loTable.lIsFree = This.lIsFree

			This.AddTable( loTable )

		Endif && ! Empty( tcName )

		Return loTable

	Endproc && New



Enddefine && ColTables


*!* ///////////////////////////////////////////////////////
*!* Class.........: oTable
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Table
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oTable As SessionBase

	#If .F.
		Local This As oTable Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!* Colección Fields
	oColFields = Null

	*!* Colección Forms
	oColForms = Null

	*!* Colección Entities
	oColTiers = Null

	*!* Colección Indices
	oColIndexes = Null

	*!* Colección de triggers para Update
	oColUpdateTriggers = Null

	*!* Colección de triggers para Delete
	oColDeleteTriggers = Null

	*!* Colección de triggers para Insert
	oColInsertTriggers = Null


	*!* Carpeta donde se encuentra la Tabla
	Folder = ""

	*!* Nombre largo de la tabla
	LongTableName = ""
	cLongTableName = ""

	*!* Código de Página
	Codepage = 1252

	*!* Specifies the table validation rule.
	*!* Must evaluate to a logical expression and can be a user-defined function
	*!* or a stored procedure.
	Check = ""

	*!* Mensaje de error que se muestra si Check evalua a .F.
	ErrorMessage = ""

	*!* Extensión de la tabla
	Ext = "Dbf"

	DataSession = SET_DEFAULT

	* Indica si la entidad utiliza el campo Codigo, independientemente si lo tiene o no
	lUseCodigo = .F.

	* Indica si la entidad utiliza el campo CODIGO
	lHasCodigo = .F.

	* Indica si el campo CODIGO es numérico o alfanumérico
	lCodigoIsNumeric = .F.

	* Indica si la entidad utiliza el campo DESCRIPCION
	lHasDescripcion = .F.

	* Indica si la entidad utiliza el campo DEFAULT
	lHasDefault = .F.

	* Indica si la tabla implementa una extructura jerárquica
	lIsHierarchical = .F.

	cSetFirstFocus = ""

	* Nombre de fantasía por el que se accede a la coleccion oDataDictionary
	cKeyName = ""

	*!* Tipo de clase CT_ARCHIVOS, CT_CHILD, CT_CHILDTREE
	nClassType = CT_ARCHIVOS
	Hidden nClassTypeDefault
	nClassTypeDefault = CT_ARCHIVOS

	*!* Clase de la cual hereda
	cBaseClass = 'prxEntity'
	Hidden cBaseClassDefault
	cBaseClassDefault = 'prxEntity'

	*!* Libreria de Clases de la cual hereda
	cBaseClassLib = 'Fw\Tieradapter\Comun\'
	Hidden cBaseClassLibDefault
	cBaseClassLibDefault = 'Fw\Tieradapter\Comun\'

	*!* Coleccion de propiedades
	oColProperties = Null && As Collection

	*!* Clase de la cual hereda el formulario
	cFormClass = 'ABMGenericForm'
	Hidden cFormClassDefault
	cFormClassDefault = 'ABMGenericForm'

	*!* Libreria de Clases del formulario
	cFormClassLib = 'prxmainform.vcx'
	Hidden cFormClassLibDefault
	cFormClassLibDefault = 'prxmainform.vcx'

	*!* Directorio de Libreria de Clases del formulario
	cFormClassLibFolder = 'FW\Comun\vcx'
	Hidden cFormClassLibFolderDefault
	cFormClassLibFolderDefault = 'FW\Comun\vcx'

	*!* Lista de Entidades asociadas
	cChildList = ''

	*!* Nombre del Formulario
	cFormName = ''

	*!* Directorio del Proyecto
	cProjectPath = ''

	*!* Las entidades y los formularios estan definidos en el Proyecto X
	cIncludedInTheProject = ''

	*!* Indica si se genera el metodo SetGridLayout
	lGenerateSetGridLayaout = .T.


	*!* Clave para identificar a la entidad
	cDataConfigurationKey = ''

	*!* Nombre del Cursor que representa a la tabla en las Tier
	cCursorName = ''

	*!* Colección de tablas
	oColTables = Null

	* Indica la cantidad de niveles de la entidad
	nNivelJerarquiaTablas = 0

	*!* Nombre de la tabla
	Tabla = ""

	*!* Nombre del cursor a generar.
	*   Es la PK de la colección. No puede haber 2 elementos con la misma
	*   propiedad CursorName
	CursorName = ""

	*!* En la tabla hija va el nombre de la tabla padre
	Padre = ""
	cPadre = ""

	*!* en la tabla hija va el nombre del campo con el que se relaciona
	*!* con la tabla padre (Foreign Key)
	ForeignKey = ""

	*!* Referencia al nombre del campo que contiene el ID
	*!* de la tabla de nivel 1 con la que está relacionada.
	MainID = ""
	cMainID = ""


	*!* Para NEW y GETONE, se puede definir una sentencia SQL
	SQLStat = ""

	*!* SQL para los selectores
	SQLStatSelector = ""

	*!* Indica la clausula ORDER BY para el combo
	cOrderBySelector = ''

	*!* SQL para los combo
	SQLStatCombo = ""

	*!* Indica la clausula ORDER BY para el combo
	cOrderByCombo = ''

	*!* SQL para los KeyFinder
	SQLStatKeyFinder = ""

	*!* Nombre de la Primary Key de la tabla/nivel de la entidad
	* RA 2012-10-13(11:59:37)
	* Dejar vacio si el nombre de la entidad es igual a la tabla sin la "s" final
	* Ej: Clientes
	* Si no es regular, inicializar con el nombre en singular
	* Ej: Proveedores -> PKName = "Proveedor"
	PKName = ""

	*!* Indica si la PK es Updatable para incluirla o no en la UpdatableFieldList
	PKUpdatable = .F.

	*!* Guarda la última sentencia SQL utilzada para consulta
	LastSQL = ""

	*!* Nivel de profundidad de la tabla
	Nivel = 0

	*!*
	UpdatableFieldList = ""

	*!*
	UpdateNameList = ""

	*!* Obtiene la propiedad UpdateNameList de la sentencia SQL
	GetFieldListFromSQLStat = .F.

	*!*
	oCursorAdapter = ""

	* Numero de Registro Actual de la tabla
	CurReg = 0

	* Indica si la tabla es una tabla auxiliar
	Auxiliary = .F.

	*!* Indica la clausula ORDER BY para el GetAll(), en caso de Nivel 1, o las tablas Hijas, para los demás niveles
	OrderBy = ""

	*!* Utiliza SELECT * para generar la UpdatableFieldList. Si es .F., utiliza SQLStat
	lGenericUpdatableFieldList = .T.

	*!* Clausula WHERE para la tabla
	WhereStatement = ""

	* Nombre unico de la entidad en el archivo de configuracion
	cDataConfigurationKey = ""

	* Indica si la tabla implementa una extructura jerárquica
	lIsHierarchical = .F.

	*!* Colección de Reportes
	oColReport = Null

	*!* Clase base que utiliza la entidad
	cBaseClass = "prxEntity"

	*!* Indica si la entida tiene UT
	lHasUserTier = .F.

	*!* Indica si la entida tiene ST
	lHasServiceTier = .F.

	*!* Indica si la entida tiene BT
	lHasBizTier = .F.

	*!* Indica si la entida tiene DT
	lHasDataTier = .F.

	*!*
	cClassLibFldUserTier = TA_COMUN

	*!*
	cClassLibFldServiceTier = TA_SERVICETIER

	*!*
	cClassLibFldBizTier = TA_BIZTIER

	*!*
	cClassLibFldDataTier = TA_DATATIER

	* Indica si la tabla implementa el modelo de relaciones
	lSetRelations = .T.

	*!* Indica si la tabla es _VIRTUAL y _NO pertenece a la base de datos
	*!* Se genera un cursor en base a un SELECT SQL
	lIsVirtual = .F.

	*!* Indica si la tabla tiene una tabla donde se registren las modificaciones realizadas
	lHasActivityLog = .F.

	lCreateIfNotExist = .T.

	* Fuerza a permanecer en la colección cuando al hacer un Merge() se encuentra que ya existe otra definición
	lForce = .F.

	* Genera automáticamente la PK
	lGeneratePK = .T.

	* Prefijo de la tabla
	cPrefijo = ""

	* Indica si la tabla es compartida (DRCOMUN) o exclusiva (DRVA)
	lShared = .F.

	* Indica si es una tabla libre
	lIsFree = .F.

	* Si es True, NO elimina los campos que existen en la tabla y no existen en la definición
	lAdditive = .T.


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="classafterinitialize" type="method" display="ClassAfterInitialize" />] + ;
		[<memberdata name="lisfree" type="property" display="lIsFree" />] + ;
		[<memberdata name="generateindexes" type="method" display="GenerateIndexes" />] + ;
		[<memberdata name="lshared" type="property" display="lShared" />] + ;
		[<memberdata name="lforce" type="property" display="lForce" />] + ;
		[<memberdata name="corderbyselector" type="property" display="cOrderBySelector" />] + ;
		[<memberdata name="corderbycombo" type="property" display="cOrderByCombo" />] + ;
		[<memberdata name="sqlstatselector" type="property" display="SQLStatSelector" />] + ;
		[<memberdata name="sqlstatcombo" type="property" display="SQLStatCombo" />] + ;
		[<memberdata name="sqlstatkeyfinder" type="property" display="SQLStatKeyFinder" />] + ;
		[<memberdata name="lisvirtual" type="property" display="lIsVirtual" />] + ;
		[<memberdata name="lsetrelations" type="property" display="lSetRelations" />] + ;
		[<memberdata name="cclasslibfldusertier" type="property" display="cClassLibFldUserTier" />] + ;
		[<memberdata name="cclasslibflddatatier" type="property" display="cClassLibFldDataTier" />] + ;
		[<memberdata name="cclasslibfldbiztier" type="property" display="cClassLibFldBizTier" />] + ;
		[<memberdata name="cclasslibfldservicetier" type="property" display="cClassLibFldServiceTier" />] + ;
		[<memberdata name="lhasdatatier" type="property" display="lHasDataTier" />] + ;
		[<memberdata name="lhasbiztier" type="property" display="lHasBizTier" />] + ;
		[<memberdata name="lhasservicetier" type="property" display="lHasServiceTier" />] + ;
		[<memberdata name="lhasusertier" type="property" display="lHasUserTier" />] + ;
		[<memberdata name="cbaseclass" type="property" display="cBaseClass" />] + ;
		[<memberdata name="ocolreport" type="property" display="oColReport" />] + ;
		[<memberdata name="lusecodigo" type="property" display="lUseCodigo" />] + ;
		[<memberdata name="ckeyname" type="property" display="cKeyName" />] + ;
		[<memberdata name="nniveljerarquiatablas" type="property" display="nNivelJerarquiaTablas" />] + ;
		[<memberdata name="ocolinserttriggers" type="property" display="oColInsertTriggers" />] + ;
		[<memberdata name="ocoldeletetriggers" type="property" display="oColDeleteTriggers" />] + ;
		[<memberdata name="ocolupdatetriggers" type="property" display="oColUpdateTriggers" />] + ;
		[<memberdata name="ext" type="property" display="Ext" />] + ;
		[<memberdata name="errormessage" type="property" display="ErrorMessage" />] + ;
		[<memberdata name="check" type="property" display="Check" />] + ;
		[<memberdata name="codepage" type="property" display="CodePage" />] + ;
		[<memberdata name="longtablename" type="property" display="LongTableName" />] + ;
		[<memberdata name="ocolfields" type="property" display="oColFields" />] + ;
		[<memberdata name="folder" type="property" display="Folder" />] + ;
		[<memberdata name="ocolindexes" type="property" display="oColIndexes" />] + ;
		[<memberdata name="createtable" type="method" display="CreateTable" />] + ;
		[<memberdata name="altertable" type="method" display="AlterTable" />] + ;
		[<memberdata name="createindexes" type="method" display="CreateIndexes" />] + ;
		[<memberdata name="createtriggers" type="method" display="CreateTriggers" />] + ;
		[<memberdata name="print" type="method" display="Print" />] + ;
		[<memberdata name="initialize" type="method" display="Initialize" />] + ;
		[<memberdata name="classbeforeinitialize" type="method" display="ClassBeforeInitialize" />] + ;
		[<memberdata name="addtreehierarchicalfields" type="method" display="AddTreeHierarchicalFields" />] + ;
		[<memberdata name="addhierarchicalfields" type="method" display="AddHierarchicalFields" />] + ;
		[<memberdata name="addcodigoydescripcion" type="method" display="AddCodigoYDescripcion" />] + ;
		[<memberdata name="nclasstype" type="property" display="nClassType" />] + ;
		[<memberdata name="cbaseclass" type="property" display="cBaseClass" />] + ;
		[<memberdata name="cbaseclasslib" type="property" display="cBaseClassLib" />] + ;
		[<memberdata name="ocolproperties" type="property" display="oColProperties" />] + ;
		[<memberdata name="cformclass" type="property" display="cFormClass" />] + ;
		[<memberdata name="cformclasslib" type="property" display="cFormClassLib" />] + ;
		[<memberdata name="cformclasslibfolder" type="property" display="cFormClassLibFolder" />] + ;
		[<memberdata name="cchildlist" type="property" display="cChildList" />] + ;
		[<memberdata name="hookpopulateproperties" type="method" display="HookPopulateProperties" />] + ;
		[<memberdata name="cformname" type="property" display="cFormName" />] + ;
		[<memberdata name="cprojectpath" type="property" display="cProjectPath" />] + ;
		[<memberdata name="cincludedintheproject" type="property" display="cIncludedInTheProject" />] + ;
		[<memberdata name="getprimarykey" type="method" display="GetPrimaryKey" />] + ;
		[<memberdata name="lgeneratesetgridlayaout" type="property" display="lGenerateSetGridLayaout" />] + ;
		[<memberdata name="cdataconfigurationkey" type="property" display="cDataConfigurationKey" />] + ;
		[<memberdata name="setasarchivo" type="method" display="SetAsArchivo" />] + ;
		[<memberdata name="setaschild" type="method" display="SetAsChild" />] + ;
		[<memberdata name="setaschildtree" type="method" display="SetAsChildTree" />] + ;
		[<memberdata name="ccursorname" type="property" display="cCursorName" />] + ;
		[<memberdata name="getprimarytagname" type="method" display="GetPrimaryTagName" />] + ;
		[<memberdata name="lhasdefault" type="property" display="lHasDefault" />] + ;
		[<memberdata name="lhasdescripcion" type="property" display="lHasDescripcion" />] + ;
		[<memberdata name="lhascodigo" type="property" display="lHasCodigo" />] + ;
		[<memberdata name="csetfirstfocus" type="property" display="cSetFirstFocus" />] + ;
		[<memberdata name="ocolforms" type="property" display="oColForms" />] + ;
		[<memberdata name="ocoltiers" type="property" display="oColTiers" />] + ;
		[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
		[<memberdata name="lishierarchical" type="property" display="lIsHierarchical" />] + ;
		[<memberdata name="getfieldlistfromsqlstat" type="property" display="GetFieldListFromSQLStat" />] + ;
		[<memberdata name="nivel" type="property" display="Nivel" />] + ;
		[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
		[<memberdata name="lastsql" type="property" display="LastSQL" />] + ;
		[<memberdata name="pkupdatable" type="property" display="PKUpdatable" />] + ;
		[<memberdata name="pkname" type="property" display="PKName" />] + ;
		[<memberdata name="sqlstat" type="property" display="SQLStat" />] + ;
		[<memberdata name="mainid" type="property" display="MainID" />] + ;
		[<memberdata name="foreignkey" type="property" display="ForeignKey" />] + ;
		[<memberdata name="padre" type="property" display="Padre" />] + ;
		[<memberdata name="cursorname" type="property" display="CursorName" />] + ;
		[<memberdata name="tabla" type="property" display="Tabla" />] + ;
		[<memberdata name="updatablefieldlist" type="property" display="UpdatableFieldList" />] + ;
		[<memberdata name="updatenamelist" type="property" display="UpdateNameList" />] + ;
		[<memberdata name="ocursoradapter" type="property" display="oCursorAdapter" />] + ;
		[<memberdata name="curreg" type="property" display="CurReg" />] + ;
		[<memberdata name="auxiliary" type="property" display="Auxiliary" />] + ;
		[<memberdata name="orderby" type="property" display="OrderBy" />] + ;
		[<memberdata name="lgenericupdatablefieldlist" type="property" display="lGenericUpdatableFieldList" />] + ;
		[<memberdata name="wherestatement" type="property" display="WhereStatement" />] + ;
		[<memberdata name="lcodigoisnumeric" type="property" display="lCodigoIsNumeric" />] + ;
		[<memberdata name="lgeneratepk" type="property" display="lGeneratePK" />] + ;
		[<memberdata name="ladditive" type="property" display="lAdditive" />] + ;
		[<memberdata name="synchronize" type="method" display="Synchronize" />] + ;
		[</VFPData>]


*!*			[<memberdata name="comparetable" type="method" display="CompareTable" />] + ;
*!*			[<memberdata name="clongtablename" type="property" display="cLongTableName" />] + ;
*


	* UpdatableFieldList_Access
	Protected Procedure UpdatableFieldList_Access()

		If Empty( This.UpdatableFieldList )
			This.UpdatableFieldList = This.oColFields.ToString( "Name", "," , "Autoinc = .F. And lIsVirtual = .F.")

		Endif

		Return This.UpdatableFieldList

	Endproc && UpdatableFieldList_Access

	* UpdateNameList_Access
	Protected Procedure UpdateNameList_Access()

		If Empty( This.UpdateNameList )
			This.UpdateNameList = This.oColFields.ToString( "Name + ' " + This.Name + ".' + Name", ",", "lIsVirtual = .F." )

		Endif && Empty( This.CursorName )

		Return This.UpdateNameList

	Endproc && UpdateNameList_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oColReport_Access
	*!* Date..........: Jueves 6 de Agosto de 2009 (12:27:57)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oColReport_Access()

		If Vartype( This.oColReport ) # "O"
			This.oColReport = Createobject( "ColReports" )

		Endif && Vartype( This.oColReport ) # "O"

		Return This.oColReport

	Endproc && oColReport_Access

	* CursorName_Access
	Protected Procedure CursorName_Access()

		If Empty( This.CursorName )
			This.CursorName = 'c' + This.Name

		Endif && Empty( This.CursorName )

		Return This.CursorName

	Endproc && CursorName_Access

	* Tabla_Access
	Protected Procedure Tabla_Access()

		If Empty( This.Tabla )
			This.Tabla = This.Name

		Endif && Empty( This.Tabla )

		Return This.Tabla

	Endproc && CursorName_Access


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Init
	*!* Description...:
	*!* Date..........: Martes 15 de Abril de 2008 (10:51:28)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Init( lIsFree As Boolean ) As Void
		With This As oTable Of "Tools\Sincronizador\ColDatabases.prg"
		
			
			If !Empty( Pcount())
				.lIsFree = lIsFree
			EndIf
			
			.oColTables = Createobject( 'ColTables' )
			.oColTables.oParent = This
			
			.ClassBeforeInitialize()
			.Initialize()
			.ClassAfterInitialize()
		Endwith

	Endproc && Init

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ClassBeforeInitialize
	*!* Description...:
	*!* Date..........: Martes 15 de Abril de 2008 (10:51:09)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure ClassBeforeInitialize() As Void

		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lcField As String
		Local loColFields As ColFields Of "Tools\Sincronizador\colDataBases.prg"
		Local lcName As String

		Try

			*If .F. && !This.lIsFree

			If !This.lIsFree

				* RA 2012-10-13(11:56:35)
				* El Nombre de la Tabla es en plural
				* El Nombre de la PK es en singular

				If Empty( This.PKName )
					If Empty( This.cBaseClass )
						lcName = Strtran( This.Name, "sys_", "", -1, -1, 1 )

						* Le saco la "s" final - RA 2012-10-13(11:57:35)
						lcName = Substr( lcName, 1, Len( lcName ) - 1 )

					Else
						lcName = This.cBaseClass

					Endif

				Else
					lcName = This.PKName

				Endif

				loColFields = This.oColFields

				If This.lGeneratePK
					* PrimaryKey

					loField = loColFields.NewPK( lcName + "Id" )
					This.PKName = loField.Name

					loField.nGridOrder = -1
					loField.nComboOrder = -1
					loField.nSelectorOrder = -1
					loField.nShowInKeyFinder = -1
					loField.TagName = "Id"

				Endif

				If This.lIsHierarchical
					* ParentPK
					lcField = "Parent" + lcName + "Id"
					loField = loColFields.NewFK( lcField )
					With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
						.References = This.Name
						.lIsSystem = .T.
						.TriggerConditionForInsert = "! Empty( " + This.Name + '.' + lcField + " )"
						.TriggerConditionForUpdate = .TriggerConditionForInsert
						.Check = ''
						.ErrorMessage = ''

					Endwith

					* tvwNivel
					loField = loColFields.New( "tvwNivel", "I" )
					With loField As oField Of "Tools\Sincronizador\colDataBases.prg"
						.lIsSystem = .T.

					Endwith

					* tvwSecuencia
					loField = loColFields.NewRegular( "tvwSecuencia" , "V", 20 )
					With loField As oField Of "Tools\Sincronizador\colDataBases.prg"
						.lIsSystem = .T.

					Endwith

					* ParentUniqueCode
					loField = loColFields.New( "ParentUniqueCode", "character", 20 )
					With loField As oField Of "Tools\Sincronizador\colDataBases.prg"
						.lIsSystem = .T.

					Endwith

				Endif && This.lIsHierarchical

				If This.lHasCodigo

					* Codigo

					If This.lCodigoIsNumeric

						loField = loColFields.NewCandidate( "Codigo", "Integer" )

						With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
							.cSearchCondition = "!#"
							.cDefaultCondition = "!#"

						Endwith

					Else && This.lCodigoIsNumeric

						loField = loColFields.NewCandidate( "Codigo", "Character", 10)

						With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
							.cSearchCondition = "like"
							.cDefaultCondition = "like"

						Endwith

					Endif && This.lCodigoIsNumeric
					With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
						.Caption = "Código"
						.cReferenceCaption = .oParent.Name + " Código"
						.lRequired = .T.
						.lShowInGrid = .T.
						.lShowInNavigator = .T.
						.nShowInKeyFinder = 1
						.lFastSearch = .T.
						.nGridOrder = 1
						.nComboOrder = 1
						.nSelectorOrder = 1
						.lIndexOnClient = .T.
						.nDefaultReference = 1

					Endwith

				Else
					This.lUseCodigo = .F.

				Endif && This.lHasCodigo

				If This.lHasDescripcion
					* Descripcion
					loField = loColFields.NewRegular( "Descripcion", "Character", 30 )

					With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
						.CaseSensitive = .F.
						.Caption = "Descripción"
						.Check = "!Empty( Descripcion )"
						.ErrorMessage = "El Campo DESCRIPCION no puede estar vacío"
						.lRequired = .T.
						.lShowInGrid = .T.
						.lShowInNavigator = .T.
						.lFastSearch = .T.
						.cSearchCondition = "%"
						.lFitColumn = .T.
						.cReferenceCaption = .oParent.Name

						.nGridOrder = 2
						.nComboOrder = 2


						If ! This.lHasCodigo
							.nShowInKeyFinder = 1
							.nDefaultReference = 1
							.nSelectorOrder = 1

						Else
							.nShowInKeyFinder = 2
							.nDefaultReference = 2
							.nSelectorOrder = 2

						Endif && ! This.lHasCodigo
						.lIndexOnClient = .T.

					Endwith

				Endif && This.lHasDescripcion

				If This.lHasDefault
					* Default
					loField = loColFields.New( "Default", "logical" )


					With loField As oField Of "Tools\Sincronizador\colDataBases.prg"
						.Caption = "Predeterminada"
						.nGridOrder = -1
						.nComboOrder = -1
						.nSelectorOrder = -1
						.nShowInKeyFinder = -1

					Endwith

				Endif && This.lHasDefault

				* Time Stamp
				loField = loColFields.New( "TS", "DateTime" )
				With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
					.Check = "!Empty( TS )"
					.ErrorMessage = "El Campo TS no puede estar vacío"
					.Caption = "Time Stamp"
					* DAE 2009-09-22(15:54:38)
					.Default = "DateTime()"
					.lIsSystem = .T.

				Endwith

				* TransactionId
				loField = loColFields.New( "Transaction_Id", "Integer" )
				With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
					.Check = "!Empty( Transaction_Id )"
					.ErrorMessage = "El Campo Transaction_Id no puede estar vacío"
					.Caption = "Transacción"
					.lIsSystem = .T.

				Endwith

				loColTiers = This.oColTiers

				* User
				loeEcfg = loColTiers.New( "User" )

				If This.lHasUserTier
					loeEcfg.cObjClass = lcName

				Else
					loeEcfg.cObjClass = This.cBaseClass

				Endif && This.lHasUserTier

				*!*					If This.lHasUserTier
				*!*						loeEcfg.cObjClass = "ut" + lcName

				*!*					Else
				*!*						loeEcfg.cObjClass = "ut" + This.cBaseClass

				*!*					Endif && This.lHasUserTier


				loeEcfg.cObjClassLibraryFolder = This.cClassLibFldUserTier
				loeEcfg.cObjComponent = COM_TA

				* Service
				loeEcfg = loColTiers.New( "Service" )
				If This.lHasServiceTier
					loeEcfg.cObjClass = "st" + lcName

				Else
					loeEcfg.cObjClass = "st" + This.cBaseClass

				Endif && This.lHasServiceTier
				loeEcfg.cObjClassLibraryFolder = This.cClassLibFldServiceTier
				loeEcfg.cObjComponent = COM_TA

				*!*	* Wrapper
				*!*	loeEcfg = loColTiers.New( "Wrapper" )
				*!* If This.lHasWrapperTier
				*!*		loeEcfg.cObjClass = "bt" + lcName + "Wrapper"
				*!* Else
				*!* 	loeEcfg.cObjClass = "bt" + This.cBaseClass + "Wrapper"
				*!* Endif && This.lHasWrapperTier
				*!* loeEcfg.cObjClassLibraryFolder = This.cClassLibFldWrapperTier
				*!* loeEcfg.cObjComponent = COM_TA
				*!* loeEcfg.lObjInComComponent = .T.

				* Business
				loeEcfg = loColTiers.New( "Business" )
				If This.lHasBizTier
					loeEcfg.cObjClass = "bt" + lcName
				Else
					loeEcfg.cObjClass = "bt" + This.cBaseClass
				Endif && This.lHasBizTier
				loeEcfg.cObjClassLibraryFolder = This.cClassLibFldBizTier
				loeEcfg.cObjComponent = COM_TA
				loeEcfg.lObjInComComponent = .T.

				* Data
				loeEcfg = loColTiers.New( "Data" )
				If This.lHasDataTier
					loeEcfg.cObjClass = "dt" + lcName

				Else
					loeEcfg.cObjClass = "dt" + This.cBaseClass

				Endif && This.lHasDataTier
				loeEcfg.cObjClassLibraryFolder = This.cClassLibFldDataTier
				loeEcfg.cObjComponent = COM_TA
				loeEcfg.lObjInComComponent = .T.
			Endif

		Catch To oErr
			* DAE 2009-11-06(17:11:34)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = Null
			loColTiers = Null
			loEcfg = Null
			loField = Null
			loColFields = Null

		Endtry

	Endproc && ClassBeforeInitialize

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Initialize
	*!* Description...:
	*!* Date..........: Martes 15 de Abril de 2008 (10:49:20)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Initialize( uParam As Variant ) As Void

	Endproc && Initialize

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ClassAfterInitialize
	*!* Description...:
	*!* Date..........: Martes 15 de Abril de 2008 (10:51:09)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure ClassAfterInitialize( ) As Void

		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColFields As ColFields Of "Tools\Sincronizador\colDataBases.prg"
		Local i As Integer
		Try


		Catch To oErr
			* DAE 2009-11-06(17:11:15)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loField = Null
			loError = Null
			loColFields = Null

		Endtry

	Endproc && ClassAfterInitialize

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Print
	*!* Description...: Imprime la definición de la Tabla
	*!* Date..........: Viernes 11 de Abril de 2008 (14:15:13)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Print( cFileName As String ) As Void;
			HELPSTRING "Imprime la definición de la Base de Datos"

		Try

			Local loField As oField Of 'Tools\Sincronizador\COLDATABASES.PRG'
			Local lcFileName As String

			If !Empty( cFileName )
				lcFileName = cFileName

			Else
				lcFileName = Addbs( This.Folder ) + This.Name + "." + This.Ext + ".txt"

			Endif

			Strtofile( CRLF + CRLF + Replicate( "/", 60 ), lcFileName, 1 )
			Strtofile( CRLF + "/", lcFileName, 1 )

			Strtofile( CRLF + "/ "+ Addbs( This.Folder ) + This.Name + "." + This.Ext, lcFileName, 1 )
			Strtofile( CRLF + "/" + CRLF + CRLF, lcFileName, 1 )


			For Each loField In This.oColFields
				loField.Print( lcFileName )

			Endfor

			Strtofile( CRLF + "/", lcFileName, 1 )
			Strtofile( CRLF + Replicate( "/", 30 ) + " ( " + This.Name + "." + This.Ext + " )", lcFileName, 1 )

		Catch To oErr
			Throw oErr

		Finally
			loTable = Null
			loField = Null

		Endtry

		Return lcFileName

	Endproc && Print

	Procedure oColFields_Access
		If Vartype( This.oColFields ) # "O"
			This.oColFields = Createobject( "ColFields" )
			This.oColFields.oParent = This

		Endif && Vartype( This.oColFields ) # "O"

		Return This.oColFields

	Endproc && oColFields_Access

	Procedure oColForms_Access
		If Vartype( This.oColForms ) # "O"
			This.oColForms = Createobject( "ColForms" )
			This.oColForms.oParent = This

		Endif && Vartype( This.oColForms ) # "O"

		Return This.oColForms

	Endproc && oColForms_Access

	Procedure oColTiers_Access
		If Vartype( This.oColTiers ) # "O"
			This.oColTiers = Createobject( "ColTiers" )
			This.oColTiers.oParent = This

		Endif

		Return This.oColTiers

	Endproc && oColForms_Access

	Procedure oColIndexes_Access

		If Vartype( This.oColIndexes ) # "O"
			This.oColIndexes = Createobject( "ColIndexes" )
			This.oColIndexes.oParent = This

		Endif && Vartype( This.oColIndexes ) # "O"

		Return This.oColIndexes

	Endproc && oColIndexes_Access

	Procedure oColDeleteTriggers_Access
		If Vartype( This.oColDeleteTriggers ) # "O"
			This.oColDeleteTriggers = Createobject( "ColDeleteTriggers" )
			This.oColDeleteTriggers.oParent = This

		Endif && Vartype( This.oColDeleteTriggers ) # "O"

		Return This.oColDeleteTriggers

	Endproc && oColDeleteTriggers_Access

	Procedure oColInsertTriggers_Access
		If Vartype( This.oColInsertTriggers ) # "O"
			This.oColInsertTriggers = Createobject( "ColInsertTriggers" )
			This.oColInsertTriggers.oParent = This

		Endif && Vartype( This.oColInsertTriggers ) # "O"

		Return This.oColInsertTriggers

	Endproc && oColInsertTriggers_Access

	Procedure oColUpdateTriggers_Access
		If Vartype( This.oColUpdateTriggers ) # "O"
			This.oColUpdateTriggers = Createobject( "ColUpdateTriggers" )
			This.oColUpdateTriggers.oParent = This

		Endif && Vartype( This.oColUpdateTriggers ) # "O"

		Return This.oColUpdateTriggers

	Endproc && oColUpdateTriggers_Access


	*
	* Sincroniza la Tabla con la definición de la misma
	Procedure Synchronize(  ) As Void;
			HELPSTRING "Sincroniza la Tabla con la definición de la misma"

		Local lcCommand As String
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg")
		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
		Local Array laFields[ 1 ]
		Local llOk As Boolean
		Local i As Integer

		Try

			lcCommand 	= ""
			llOk 		= .T.

			If ! Used( This.LongTableName )
				Try

					If This.lIsFree
						lcFile = Addbs( This.Folder ) + This.Name + "." + This.Ext

						Use ( lcFile ) Shared

					Else
						Use ( This.LongTableName ) Shared

					Endif

				Catch To oErr When oErr.ErrorNo = 1

					If ! Indbc( This.LongTableName, 'TABLE' )
						TEXT To lcCommand NoShow TextMerge Pretext 15
                       	Add Table '<<Addbs( This.Folder ) + This.Name + "." + This.Ext>>' Name '<<This.LongTableName>>'

						ENDTEXT

						&lcCommand

					Endif

				Catch To oErr
					* loError = This.oError
					loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					This.cXMLoError = loError.Process( oErr )
					Throw loError

				Finally
					loError = Null

				Endtry
			Endif

			Select Alias( This.LongTableName )

			lnLen = Afields( laFields, This.LongTableName )
			loColFields = This.oColFields

			* Chequear los campos existentes
			For Each loField In loColFields

				If !loField.lIsSystem

					i = Ascan( laFields, loField.Name, 1, lnLen, 1, 9 )

					If Empty( i )
						llOk = .F.
					Endif

					If llOk

						Do Case
							Case Inlist( Lower( loField.FieldType ), "w", "blob" )
								loField.FieldType = "W"
								loField.FieldWidth = 4

							Case Inlist( Lower( loField.FieldType ), "c", "char", "character" )
								loField.FieldType = "C"

							Case Inlist( Lower( loField.FieldType ), "y", "currency", "money" )
								loField.FieldType = "Y"
								loField.FieldWidth = 8

							Case Inlist( Lower( loField.FieldType ), "t", "datetime" )
								loField.FieldType = "T"
								loField.FieldWidth = 8

							Case Inlist( Lower( loField.FieldType ), "d", "date" )
								loField.FieldType = "D"
								loField.FieldWidth = 8

							Case Inlist( Lower( loField.FieldType ), "g", "general" )
								loField.FieldType = "G"
								loField.FieldWidth = 4

							Case Inlist( Lower( loField.FieldType ), "i", "int", "integer", "long" )
								loField.FieldType = "I"
								loField.FieldWidth = 4

							Case Inlist( Lower( loField.FieldType ), "l", "logical", "boolean", "bit" )
								***loField.FieldType = "Logical"

								* Para futura escalabilidad a SQL Server, no se utilizan
								* campos booleanos.
								* En ta.h está definido
								* #DEFINE TRUE			1
								* #DEFINE FALSE			0
								*loField.FieldType = "I"
								
								loField.FieldType = "L"
								loField.FieldWidth = 1

							Case Inlist( Lower( loField.FieldType ), "m", "memo" )
								loField.FieldType = "M"
								loField.FieldWidth = 4

							Case Inlist( Lower( loField.FieldType ), "n", "num", "numeric" )
								loField.FieldType = "N"

							Case Inlist( Lower( loField.FieldType ), "f", "float" )
								* Included for compatibility, the Float data type is functionally equivalent to Numeric.
								* Same as Numeric
								loField.FieldType = "F"

							Case Inlist( Lower( loField.FieldType ), "q", "varbinary" )
								loField.FieldType = "Q"

							Case Inlist( Lower( loField.FieldType ), "v", "varchar" )
								loField.FieldType = "V"

							Case Inlist( Lower( loField.FieldType ), "b", "double" )
								loField.FieldType = "B"

							Otherwise

						Endcase

						llOk = ( loField.FieldType 		= laFields[ i, 2 ] ) And llOk
						llOk = ( loField.FieldWidth 	= laFields[ i, 3 ] ) And llOk
						llOk = ( loField.FieldPrecision = laFields[ i, 4 ] ) And llOk

					Endif

					If !llOk
						Exit
					Endif

				Endif

			Endfor

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loField = Null
			loTable = Null

			Use In Select( This.LongTableName )

		Endtry

		Return llOk

	Endproc && Synchronize


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateTable
	*!* Description...: Crea una tabla nueva
	*!* Date..........: Martes 29 de Mayo de 2007 (12:35:44)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure CreateTable( ) As Boolean;
			HELPSTRING "Crea una tabla nueva"

		Local llOk As Boolean
		Local lcCommand As String,;
			lcFolder As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lcFile As String
		Try

			llOk = .T.
			lcCommand = ""
			lcFolder = This.Folder
			lcFile = Addbs( lcFolder ) + This.Name + "." + This.Ext

			If ! FileExist( lcFile )

				lcCommand = "Create Table [" + lcFile + "] "

				If This.lIsFree
					lcCommand = lcCommand + " Free "

				Else
					If ! Empty( This.LongTableName )
						lcCommand = lcCommand + " Name [" + This.LongTableName + "] "

					Endif && ! Empty( This.LongTableName )
				Endif

				If ! Empty( This.Codepage )
					lcCommand = lcCommand + " Codepage = " + Any2Char( This.Codepage )

				Endif && ! Empty( This.Codepage )

				lcCommand = lcCommand + " (TS DateTime NOT NULL) "
				&lcCommand

			Endif && ! File( lcFile )

			This.AlterTable()

		Catch To oErr
			* DAE 2009-11-06(17:10:56)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			oErr.Message = oErr.Message + Chr(13) + lcCommand
			This.cXMLoError = loError.Process( oErr )
			llOk = .F.
			Throw loError

		Finally
			loError = Null

		Endtry

		Return llOk

	Endproc && CreateTable

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AlterTable
	*!* Description...: Modifica una tabla existente
	*!* Date..........: Martes 29 de Mayo de 2007 (12:36:32)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure AlterTable( ) As Boolean;
			HELPSTRING "Modifica una tabla existente"

		Local llOk As Boolean
		Local llDone As Boolean
		Local llLoop As Boolean
		Local laFields[1]
		Local lnLen As Integer
		Local i As Integer
		Local lnIndex As Integer
		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
		Local loIndex As oIndex Of "Tools\Sincronizador\ColDataBases.prg"
		Local lcCommand As String
		Local lcErrMesg As String,;
			lcFolder As String,;
			lcFile As String

		Local oErr As Exception
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColFields As ColFields Of "Tools\Sincronizador\colDataBases.prg"
		Local loColIndexes As ColIndexes Of "Tools\Sincronizador\colDataBases.prg"
		Local lnRecCount As Integer

		Try

			llOk = .T.
			If ! This.lIsVirtual
				lcCommand = ""

				If ! Used( This.LongTableName )
					Try

						If This.lIsFree
							*!*								lcFolder = This.Folder
							*!*								lcFile = Addbs( &lcFolder ) + This.Name + "." + This.Ext

							lcFile = Addbs( This.Folder ) + This.Name + "." + This.Ext

							Try

								Use ( lcFile ) Exclusive

							Catch To oErr When oErr.ErrorNo = 1707 && No se encuentra el archivo .CDX estructural.
								Use ( lcFile ) Exclusive

							Catch To oErr
								Throw oErr

							Finally

							Endtry


						Else
							Use ( This.LongTableName ) Exclusive

						Endif

					Catch To oErr When oErr.ErrorNo = 1

						If ! Indbc( This.LongTableName, 'TABLE' )
							TEXT To lcCommand NoShow TextMerge Pretext 15
                       			Add Table '<<Addbs( This.Folder ) + This.Name + "." + This.Ext>>' Name '<<This.LongTableName>>'

							ENDTEXT

							&lcCommand

						Endif

					Catch To oErr
						* loError = This.oError
						loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
						This.cXMLoError = loError.Process( oErr )
						Throw loError

					Finally
						loError = Null

					Endtry
				Endif

				Select Alias( This.LongTableName )

				Delete Tag All

				* lnLen = Afields( laFields )
				lnLen = Afields( laFields, This.LongTableName )
				* @TODO Damian Eiff 2009-09-15 (13:49:13)
				* Detectar si la tabla tiene registros para iniciar los campos
				* antes de aplicar las reglas de campo.
				lnRecCount = Reccount( This.LongTableName )

				* Use In Alias( This.LongTableName )
				* Use In Select( This.LongTableName )

				loColFields = This.oColFields
				loColIndexes = This.oColIndexes

				* Agregar/modificar los campos existentes
				For Each loField In loColFields
					If ! loField.lIsVirtual
						llDone = .F.

						Do While ! llDone
							llLoop = .F.
							lcCommand = "Alter Table " + This.LongTableName

							i = Ascan( laFields, loField.Name, 1, lnLen, 1, 9 )

							If ! Empty( i )
								lcCommand = lcCommand + " Alter "

								* Si es autoincremental, hay que conservar los datos

								If loField.Autoinc
									loField.Nextvalue = laFields[ i, 17 ]
									loField.StepValue = laFields[ i, 18 ]

								Endif && loField.Autoinc

							Else
								lcCommand = lcCommand + " Add "

							Endif && ! Empty( i )

							lcCommand = lcCommand + "Column " + loField.Name + " " + loField.FieldType

							If ! Empty( loField.FieldWidth )
								* lcCommand = lcCommand + "(" + Any2Char( loField.FieldWidth )
								lcCommand = lcCommand + "(" + Transform( loField.FieldWidth )
								If ! Empty( loField.FieldPrecision )
									* lcCommand = lcCommand + "," + Any2Char( loField.FieldPrecision )
									lcCommand = lcCommand + "," + Transform( loField.FieldPrecision )

								Endif

								lcCommand = lcCommand + ")"

							Endif && ! Empty( loField.FieldWidth )

							If loField.Null
								lcCommand = lcCommand + " NULL "

							Else
								lcCommand = lcCommand + " NOT NULL "

							Endif

							If !This.lIsFree
								If ! Empty( loField.Check )
									* lcCommand = lcCommand + " CHECK " + Any2Char( loField.Check )
									lcCommand = lcCommand + " CHECK " + Transform( loField.Check )
									If ! Empty( loField.ErrorMessage )
										loField.ErrorMessage = This.LongTableName + ": " + loField.ErrorMessage
										lcCommand = lcCommand + " ERROR [" + loField.ErrorMessage + "]"

									Endif && ! Empty( loField.ErrorMessage )

								Endif && ! Empty( loField.Check )

								If loField.Autoinc
									lcCommand = lcCommand + " AUTOINC "
									If !Empty( loField.Nextvalue )
										* lcCommand = lcCommand + " NEXTVALUE " + Any2Char( loField.Nextvalue )
										lcCommand = lcCommand + " NEXTVALUE " + Transform( loField.Nextvalue )

										If ! Empty( loField.StepValue )
											* lcCommand = lcCommand + " STEP " + Any2Char( loField.StepValue )
											lcCommand = lcCommand + " STEP " + Transform( loField.StepValue )

										Endif

									Endif
								Endif

								If ! IsEmpty( loField.Default )
									* lcCommand = lcCommand + " DEFAULT " + Any2Char( loField.Default )
									lcCommand = lcCommand + " DEFAULT " + Transform( loField.Default )

								Endif && ! IsEmpty( loField.Default )

								If loField.IndexKey # IK_NOKEY
									loIndex = loColIndexes.New()
									loIndex.KeyType = loField.IndexKey
									If loField.CaseSensitive
										loIndex.KeyExpression = loField.Name

									Else
										loIndex.KeyExpression = "Lower( " + loField.Name + " )"

									Endif

									If Empty( loField.TagName )
										loField.TagName = Substr( loField.Name, 1, 10 )

									Endif && Empty( loField.TagName )

									loIndex.TagName = loField.TagName
									loIndex.Collate = loField.Collate
									loIndex.Name = loField.Name
									loIndex.References = loField.References
									loIndex.ParentTagName = loField.ParentTagName
									loIndex.TriggerConditionForDelete = loField.TriggerConditionForDelete
									loIndex.TriggerConditionForInsert = loField.TriggerConditionForInsert
									loIndex.TriggerConditionForUpdate = loField.TriggerConditionForUpdate
									* Modificado 2009-03-10 - Eiff Damián
									loIndex.ParentPk = loField.ParentPk

									loColIndexes.AddIndex( loIndex )
									loIndex = Null

								Endif

								If loField.NoCPTrans
									lcCommand = lcCommand + " NOCPTRANS "

								Endif && loField.NoCPTrans

								If loField.Novalidate
									lcCommand = lcCommand + " NOVALIDATE "

								Endif && loField.Novalidate
							Endif

							Try

								&lcCommand

							Catch To oErr
								lcErrMesg = oErr.Message + CR + CR

								Do Case
									Case oErr.ErrorNo = Field_name_validation_rule_is_violated
										lcErrMesg = lcErrMesg + "¿Desea cancelar la regla de validación?"

										If Messagebox( lcErrMesg,;
												MB_YESNO + MB_ICONEXCLAMATION,;
												"Error en Alter Table" ) = IDYES

											loField.Check = ""
											loField.ErrorMessage = ""

											i = loColIndexes.GetKey( Lower( loField.Name ) )

											If ! Empty( i )
												loColIndexes.Remove( i )

											Endif && ! Empty( i )

											Warning( "No olvide ejecutar nuevamente" + CR +;
												"el SINCRONIZADOR una vez corregida" + CR +;
												"la REGLA DE VALIDACION" )

											llLoop = .T.

										Else
											Throw oErr

										Endif

									Otherwise
										Strtofile( lcCommand, "_ERROR_AlterTable.prg", 0 )
										Throw oErr

								Endcase

							Finally

							Endtry

							If llLoop
								Loop

							Endif && llLoop

							If !This.lIsFree
								If .T. && ! IsRuntime()
									DBSetProp( This.LongTableName + "." + loField.Name, "FIELD", "DisplayClassLibrary" , loField.DisplayClassLibrary )
									DBSetProp( This.LongTableName + "." + loField.Name, "FIELD", "DisplayClass", loField.DisplayClass )
									DBSetProp( This.LongTableName + "." + loField.Name, "FIELD", "Comment", loField.Comment )
									DBSetProp( This.LongTableName + "." + loField.Name, "FIELD", "Format", loField.Format )
									DBSetProp( This.LongTableName + "." + loField.Name, "FIELD", "InputMask", loField.InputMask )

								Endif && ! IsRuntime()

								DBSetProp( This.LongTableName + "." + loField.Name, "FIELD", "Caption", loField.Caption )

								*!* DBSetProp( This.LongTableName + "." + loField.Name, "FIELD", "RuleExpression", loField.Check )
								*!* DBSetProp( This.LongTableName + "." + loField.Name, "FIELD", "RuleText", loField.ErrorMessage )
							Endif

							llDone = .T.

						Enddo

					Endif && ! loField.lIsVirtual

				Endfor

				If !This.lAdditive

					* Eliminar los campos dados de baja
					For i = 1 To lnLen
						lnIndex = loColFields.GetKey( Lower( laFields[ i, 1 ] ))
						If Empty( lnIndex )
							lcCommand = "Alter Table " + This.LongTableName
							lcCommand = lcCommand + " DROP COLUMN " + Lower( laFields[ i, 1 ] )
							&lcCommand

						Endif
					Endfor

				Endif

				If !This.lIsFree
					This.CreateIndexes( IK_PRIMARY_KEY )
					DBSetProp( This.LongTableName, "TABLE", "Comment", This.Comment )
				Endif

			Endif && ! this.lIsVirtual

		Catch To oErr
			* DAE 2009-11-06(17:08:13)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			oErr.Message = oErr.Message + Chr(13) + lcCommand
			This.cXMLoError = loError.Process( oErr )
			llOk = .F.
			Throw loError

		Finally
			*!*	If Used( This.LongTableName )
			*!*		Use In Alias( This.LongTableName )
			*!*	Endif
			Use In Select( This.LongTableName )
			loColFields = Null
			loColIndexes = Null
			loError = Null

		Endtry

		Return llOk

	Endproc && AlterTable

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AlterTable
	*!* Description...: Compara una tabla existente con el diccionario de datos
	*!* Date..........: Viernes 5 de Abril de 2013 (12:03:46)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!* Compara una tabla existente con el diccionario de datos y emite un informe

	Procedure CompareTable( ) As Boolean;
			HELPSTRING "Compara una tabla existente con el diccionario de datos"

		Local llOk As Boolean
		Local llDone As Boolean
		Local llLoop As Boolean
		Local laFields[1]
		Local lnLen As Integer
		Local i As Integer
		Local lnIndex As Integer
		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
		Local loIndex As oIndex Of "Tools\Sincronizador\ColDataBases.prg"
		Local lcCommand As String
		Local lcErrMesg As String,;
			lcFolder As String,;
			lcFile As String

		Local oErr As Exception
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColFields As ColFields Of "Tools\Sincronizador\colDataBases.prg"
		Local loColIndexes As ColIndexes Of "Tools\Sincronizador\colDataBases.prg"
		Local lnRecCount As Integer

		Local llTableExist As Boolean,;
			llFieldExist As Boolean,;
			llFieldIsDifferent As Boolean

		Local lcFieldLog As String,;
			lcFieldName As String

		Try

			llOk = .T.
			llTableExist = .T.
			llFieldExist = .T.
			llFieldIsDifferent = .F.

			lcFieldLog = ""


			lcFolder = This.Folder
			lcFile = Addbs( lcFolder ) + This.Name + "." + This.Ext

			If ! This.lIsVirtual
				lcCommand = ""

				If ! File( lcFile )

					* Informar que no Existe
					llTableExist = .F.

					lcCommand = CRLF + lcFile + "  *** No Existe ***"

				Else

					If ! Used( This.LongTableName )
						Try

							If This.lIsFree
								*!*								lcFolder = This.Folder
								*!*								lcFile = Addbs( &lcFolder ) + This.Name + "." + This.Ext

								lcFile = Addbs( This.Folder ) + This.Name + "." + This.Ext

								Use ( lcFile ) Shared

							Else
								Use ( This.LongTableName ) Shared

							Endif

						Catch To oErr
							loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
							This.cXMLoError = loError.Process( oErr )
							Throw loError

						Finally
							loError = Null

						Endtry
					Endif

					Select Alias( This.LongTableName )

					* Informar Nombre de Tabla
					lcCommand = CRLF + lcFile

					lnLen = Afields( laFields, This.LongTableName )

					loColFields = This.oColFields

					* Detectar las diferencias en los campos
					For Each loField In loColFields

						llFieldExist = .T.
						llFieldIsDifferent = .F.

						lcFieldLog = ""

						If ! loField.lIsVirtual

							i = Ascan( laFields, loField.Name, 1, lnLen, 1, 9 )

							lcFieldLog = ""

							If ! Empty( i )
								llFieldExist = .T.

								*!*	If InList( laFields[ i, 2 ], "I", "N" ) And Empty( laFields[ i, 4 ] )
								*!*	Set Step On
								*!*	EndIf
								If !loField.IsType( laFields[ i, 2 ] )
									llFieldIsDifferent = .T.
								Endif


								If !llFieldIsDifferent
									If Inlist( laFields[ i, 2 ], "C", "B", "F", "N", "Q", "V" )
										If loField.FieldWidth # laFields[ i, 3 ]
											llFieldIsDifferent = .T.
										Endif

										If Inlist( laFields[ i, 2 ], "B", "F", "N" )
											If loField.FieldPrecision # laFields[ i, 4 ]
												llFieldIsDifferent = .T.
											Endif
										Endif

									Else
										If laFields[ i, 2 ] = "I"
											If loField.FieldType = "numeric" And  loField.FieldPrecision = 0
												llFieldIsDifferent = .F.
											Endif
										Endif
									Endif

								Else
									If laFields[ i, 2 ] = "I"
										If loField.FieldType = "numeric" And  loField.FieldPrecision = 0
											llFieldIsDifferent = .F.
										Endif
									Endif

									If laFields[ i, 2 ] = "N" And Empty( laFields[ i, 4 ] )
										If loField.FieldType = "integer"
											llFieldIsDifferent = .F.
										Endif
									Endif

								Endif

							Else
								* Campo No existe
								llFieldExist = .F.


							Endif && ! Empty( i )

							If llFieldExist = .T. And llFieldIsDifferent
								TEXT To lcFieldLog NoShow TextMerge Pretext 15
									<<loField.Name>> <<laFields[ i, 2 ]>>( <<laFields[ i, 3 ]>>, <<laFields[ i, 4 ]>> )
								ENDTEXT

								lcFieldLog = lcFieldLog + "  -> "

								TEXT To lcFieldLog NoShow TextMerge Pretext 15 ADDITIVE
									<<loField.Name>> <<loField.FieldType>>( <<loField.FieldWidth>>, <<loField.FieldPrecision>> )
								ENDTEXT

							Endif

							If llFieldExist = .F.

								TEXT To lcFieldLog NoShow TextMerge Pretext 15
								<<loField.Name>> <<loField.FieldType>>
								ENDTEXT

								If Inlist( loField.FieldType, "character", "double", "float", "numeric", "varbinary", "varchar" )

									TEXT To lcFieldLog NoShow TextMerge Pretext 15 ADDITIVE
									( <<loField.FieldWidth>>
									ENDTEXT

									If Inlist( loField.FieldType, "double", "float", "numeric" )
										TEXT To lcFieldLog NoShow TextMerge Pretext 15 ADDITIVE
										, <<loField.FieldPrecision>> )
										ENDTEXT

									Else
										lcFieldLog = lcFieldLog + " )"
									Endif
								Endif

								lcFieldLog = lcFieldLog + "  -> No Existe"

							Endif

							If !Empty( lcFieldLog )
								* Informar Datos del Campo

								lcCommand = lcCommand + CRLF + Space( 20 ) + lcFieldLog

							Endif

						Endif && ! loField.lIsVirtual

					Endfor

					For i = 1 To lnLen
						lcFieldName = laFields[ i, 1 ]

						loField = loColFields.GetItem( lcFieldName )

						If Vartype( loField ) # "O"

							TEXT To lcFieldLog NoShow TextMerge Pretext 15
							<<laFields[ i, 1 ]>> <<laFields[ i, 2 ]>>
							ENDTEXT

							If Inlist( laFields[ i, 2 ], "C", "B", "F", "N", "Q", "V" )

								TEXT To lcFieldLog NoShow TextMerge Pretext 15 ADDITIVE
								( <<laFields[ i, 3 ]>>
								ENDTEXT

								If Inlist( laFields[ i, 2 ], "B", "F", "N" )
									TEXT To lcFieldLog NoShow TextMerge Pretext 15 ADDITIVE
									, <<laFields[ i, 4 ]>> )
									ENDTEXT

								Else
									lcFieldLog = lcFieldLog + " )"

								Endif
							Endif

							lcFieldLog = "No Existe  -> " + lcFieldLog

							lcCommand = lcCommand + CRLF + Space( 20 ) + lcFieldLog

						Endif

					Endfor

					lcCommand = lcCommand + CRLF + CRLF + CRLF

				Endif && ! this.lIsVirtual
			Endif && ! File( lcFile )

		Catch To oErr
			* DAE 2009-11-06(17:08:13)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			oErr.Message = oErr.Message + Chr(13) + lcCommand
			This.cXMLoError = loError.Process( oErr )
			llOk = .F.
			Throw loError

		Finally
			*!*	If Used( This.LongTableName )
			*!*		Use In Alias( This.LongTableName )
			*!*	Endif
			Use In Select( This.LongTableName )
			loColFields = Null
			loColIndexes = Null
			loError = Null

		Endtry

		Return lcCommand

	Endproc && CompareTable


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateIndexes
	*!* Description...: Genera los indices asociados a la tabla
	*!* Date..........: Miércoles 30 de Mayo de 2007 (18:36:29)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure CreateIndexes( tnIndexKey As Integer ) As Void;
			HELPSTRING "Genera los indices asociados a la tabla"

		Local loIndex As oIndex Of "Tools\Sincronizador\ColDataBases.prg"
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loTrigger As oTrigger Of "Tools\Sincronizador\ColDataBases.prg"
		Local lcCommand As String
		Local lcCmd As String
		Local lcDropCommand As String
		Local lcDBF As String
		Local lnRI As Integer
		Local lnPK As Integer
		Local lnFK As Integer
		Local lnUN As Integer
		Local lnRG As Integer
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColInsertTriggers As ColInsertTriggers Of "Tools\Sincronizador\colDataBases.prg"
		Local loColUpdateTriggers As ColUpdateTriggers Of "Tools\Sincronizador\colDataBases.prg"
		* Local loColDeleteTriggers As ColDeleteTriggers Of "Tools\Sincronizador\colDataBases.prg"
		Try
			If ! This.lIsVirtual

				loColInsertTriggers = This.oColInsertTriggers
				loColUpdateTriggers = This.oColUpdateTriggers
				* loColDeleteTriggers = This.oColDeleteTriggers

				lcCommand = ''

				lnFK = 0
				lnPK = 0
				lnRG = 0
				lnUN = 0

				* Abrir la tabla padre
				* Use In Select( Alias( This.LongTableName ) )
				*!*	If Used( This.LongTableName )
				*!*		Use In Alias( This.LongTableName )
				*!*	EndIf

				If This.lIsFree
					*!*						lcFolder = This.Folder
					*!*						lcDBF = Addbs( lcFolder ) + This.Name + "." + This.Ext

					lcDBF = Addbs( This.Folder ) + This.Name + "." + This.Ext

				Else
					lcDBF = This.LongTableName

				Endif

				If Used( This.LongTableName )

					Use In Select( This.LongTableName )

				Endif

				TEXT To lcCmd NoShow TextMerge Pretext 15
            	Use '<<lcDBF>>' Exclusive In 0
				ENDTEXT

				This.ReTryCommand( lcCmd, 10, 1705 )

				Select Alias( This.LongTableName )

				lnRI = 0

				*!*	* Crear primero las PK, porque deben existir antes que las FK hagan referencia

				*!*	For Each loIndex In This.oColIndexes
				*!*		If loIndex.KeyType = IK_PRIMARY_KEY And tnIndexKey = IK_PRIMARY_KEY
				*!*				lcCommand = "Alter Table " + This.LongTableName
				*!*				lcCommand = lcCommand + " ADD PRIMARY KEY " + loIndex.KeyExpression
				*!*				If ! Empty( loIndex.ForExpression )
				*!*					lcCommand = lcCommand + " FOR " + loIndex.ForExpression
				*!*				Else
				*!*					lcCommand = lcCommand + " FOR !Deleted()"
				*!*				Endif && ! Empty( loIndex.ForExpression )
				*!*				If !Empty( loIndex.TagName )
				*!*					loIndex.TagName = "PK" + loIndex.TagName
				*!*				Else
				*!*					loIndex.TagName = "PK" + loIndex.Name
				*!*				Endif
				*!*				loIndex.TagName = Substr( loIndex.TagName, 1, 10 )
				*!*				lcCommand = lcCommand + " TAG [" + loIndex.TagName + "]"
				*!*				lcCommand = lcCommand + " COLLATE [" + loIndex.Collate + "]"
				*!*				Try
				*!*					&lcCommand
				*!*				Catch To oErr
				*!*					Do Case
				*!*						Case oErr.ErrorNo = 1883
				*!*							*!* Primary key already exists.
				*!*							lcDropCommand = "Alter Table " + This.LongTableName
				*!*							lcDropCommand = lcDropCommand + " DROP PRIMARY KEY "
				*!*							&lcDropCommand
				*!*							&lcCommand
				*!*						Case oErr.ErrorNo = 1879
				*!*							*!* No primary key.
				*!*						Case oErr.ErrorNo = 1880
				*!*							*!* Related table is not found in current database.
				*!*						Otherwise
				*!*							Throw oErr
				*!*					Endcase
				*!*				Finally
				*!*				Endtry
				*!*		EndIf
				*!*	EndFor


				For Each loIndex In This.oColIndexes

					Do Case
						Case loIndex.KeyType = IK_PRIMARY_KEY And tnIndexKey = IK_PRIMARY_KEY

							lcCommand = "Alter Table " + This.LongTableName

							lcCommand = lcCommand + " ADD PRIMARY KEY " + loIndex.KeyExpression

							If !Empty( loIndex.ForExpression )
								lcCommand = lcCommand + " FOR " + loIndex.ForExpression

							Else
								lcCommand = lcCommand + " FOR !Deleted()"

							Endif

							*!*	If !Empty( loIndex.TagName )
							*!*		loIndex.TagName = "PK" + loIndex.TagName

							*!*	Else
							*!*		loIndex.TagName = "PK" + loIndex.Name

							*!*	Endif

							*!*	loIndex.TagName = Substr( loIndex.TagName, 1, 10 )

							lcCommand = lcCommand + " TAG [" + loIndex.TagName + "]"

							lcCommand = lcCommand + " COLLATE [" + loIndex.Collate + "]"


							Try

								&lcCommand

							Catch To oErr

								Do Case
									Case oErr.ErrorNo = 1883
										*!* Primary key already exists.

										lcDropCommand = "Alter Table " + This.LongTableName
										lcDropCommand = lcDropCommand + " DROP PRIMARY KEY "

										&lcDropCommand

										&lcCommand

									Case oErr.ErrorNo = 1879
										*!* No primary key.

									Case oErr.ErrorNo = 1880
										*!* Related table is not found in current database.

									Otherwise
										Throw oErr

								Endcase

							Finally

							Endtry

						Case loIndex.KeyType # IK_PRIMARY_KEY And tnIndexKey # IK_PRIMARY_KEY

							lcCommand = "Alter Table " + This.LongTableName

							*!*	If "Serie" $ This.LongTableName
							*!*		* Set Step On
							*!*	EndIf

							Do Case
								Case loIndex.KeyType = IK_NOKEY

								Case loIndex.KeyType = IK_UNIQUE_KEY

									lcCommand = lcCommand + " ADD UNIQUE " + loIndex.KeyExpression

									If ! Empty( loIndex.ForExpression )
										lcCommand = lcCommand + " FOR " + loIndex.ForExpression

									Else
										lcCommand = lcCommand + " FOR !Deleted()"

									Endif && ! Empty( loIndex.ForExpression )

									lnUN = lnUN + 1

									If ! Empty( loIndex.TagName )
										*loIndex.TagName = "UN" + Alltrim( Str( lnUN )) + loIndex.TagName

									Else
										*loIndex.TagName = "UN" + Alltrim( Str( lnUN )) + loIndex.Name
										loIndex.TagName = loIndex.Name

									Endif && ! Empty( loIndex.TagName )

									loIndex.TagName = Substr( loIndex.TagName, 1, 10 )
									lcCommand = lcCommand + " TAG [" + loIndex.TagName + "]"

									lcCommand = lcCommand + " COLLATE [" + loIndex.Collate + "]"

								Case loIndex.KeyType = IK_FOREIGN_KEY

									lcCommand = lcCommand + " ADD FOREIGN KEY " + loIndex.KeyExpression

									If ! Empty( loIndex.ForExpression )
										lcCommand = lcCommand + " FOR " + loIndex.ForExpression

									Else
										lcCommand = lcCommand + " FOR !Deleted()"

									Endif && ! Empty( loIndex.ForExpression )

									lnFK = lnFK + 1

									If ! Empty( loIndex.TagName )
										*loIndex.TagName = "FK" + Alltrim( Str( lnFK ) ) + loIndex.TagName

									Else
										*loIndex.TagName = "FK" + Alltrim( Str( lnFK ) ) + loIndex.Name
										loIndex.TagName = loIndex.Name

									Endif && ! Empty( loIndex.TagName )

									loIndex.TagName = Substr( loIndex.TagName, 1, 10 )
									lcCommand = lcCommand + " TAG [" + loIndex.TagName + "]"

									lcCommand = lcCommand + " COLLATE [" + loIndex.Collate + "]"

									lcCommand = lcCommand + " REFERENCES " + loIndex.References

									If ! Empty( loIndex.ParentTagName )
										lcCommand = lcCommand + " TAG [" + loIndex.ParentTagName + "]"

									Endif && ! Empty( loIndex.ParentTagName )

									lnRI = lnRI + 1

									*!* Genera un Trigger de Insert
									* loTrigger = This.oColInsertTriggers.New()
									loTrigger = loColInsertTriggers.New()
									loTrigger.ChildForeignKey = loIndex.Name
									loTrigger.ChildTagName = loIndex.TagName
									loTrigger.ParentTagName = loIndex.ParentTagName
									loTrigger.ParentTable = loIndex.References
									loTrigger.ChildTable = This.LongTableName
									loTrigger.Name = "_ir_Insert_" + Transform( lnRI ) + "_" + This.LongTableName + "_" + loIndex.References
									loTrigger.ChildKeyExpression = loIndex.KeyExpression
									loTrigger.TriggerConditionForInsert = loIndex.TriggerConditionForInsert
									* Modificado 2009-03-10 - Eiff Damián
									loTrigger.ParentPk = loIndex.ParentPk
									* This.oColInsertTriggers.AddTrigger( loTrigger )
									loColInsertTriggers.AddTrigger( loTrigger )
									loTrigger = Null

									*!* Genera un Trigger de Update
									* loTrigger = This.oColUpdateTriggers.New()
									loTrigger = loColUpdateTriggers.New()
									loTrigger.ChildForeignKey = loIndex.Name
									loTrigger.ChildTagName = loIndex.TagName
									loTrigger.ParentTagName = loIndex.ParentTagName
									loTrigger.ParentTable = loIndex.References
									loTrigger.ChildTable = This.LongTableName
									loTrigger.Name = "_ir_Update_" + Transform( lnRI ) + "_" + This.LongTableName + "_" + loIndex.References
									loTrigger.ChildKeyExpression = loIndex.KeyExpression
									loTrigger.TriggerConditionForUpdate = loIndex.TriggerConditionForUpdate
									* Modificado 2009-03-10 - Eiff Damián
									loTrigger.ParentPk = loIndex.ParentPk
									* This.oColUpdateTriggers.AddTrigger( loTrigger )
									loColUpdateTriggers.AddTrigger( loTrigger )
									loTrigger = Null

									*!* Genera un Trigger de Delete
									* Debo generarlo en el objeto table correspondiente
									* a la tabla a la que hace referencia loIndex.References

									For Each loTable In _Screen.oColTables

										If Lower( loTable.LongTableName ) == Lower( loIndex.References )
											loTrigger = loTable.oColDeleteTriggers.New()
											loTrigger.ChildForeignKey = loIndex.Name
											loTrigger.ChildTagName = loIndex.TagName
											loTrigger.ParentTagName = loIndex.ParentTagName
											loTrigger.ParentTable = loTable.LongTableName
											loTrigger.ChildTable = This.LongTableName
											loTrigger.Name = "_ir_Delete_"+Transform(lnRI)+"_"+loTable.LongTableName+"_"+This.LongTableName
											loTrigger.ChildKeyExpression = loIndex.KeyExpression
											loTrigger.TriggerConditionForDelete = loIndex.TriggerConditionForDelete
											* Modificado 2009-03-10 - Eiff Damián
											loTrigger.ParentPk = loIndex.ParentPk
											loTable.oColDeleteTriggers.AddTrigger( loTrigger )
											loTrigger = Null

										Endif

									Endfor

									loTable = Null

								Case loIndex.KeyType = IK_REGULAR

									lcCommand = "INDEX ON " + loIndex.KeyExpression

									If ! Empty( loIndex.ForExpression )
										lcCommand = lcCommand + " FOR " + loIndex.ForExpression

									Else
										lcCommand = lcCommand + " FOR !Deleted()"

									Endif && ! Empty( loIndex.ForExpression )

									lnRG = lnRG + 1

									If !Empty( loIndex.TagName )
										*loIndex.TagName = "RG" + Alltrim( Str( lnRG )) + loIndex.TagName

									Else
										*loIndex.TagName = "RG" + Alltrim( Str( lnRG )) + loIndex.Name
										loIndex.TagName = loIndex.Name

									Endif

									loIndex.TagName = Substr( loIndex.TagName, 1, 10 )
									lcCommand = lcCommand + " TAG [" + loIndex.TagName + "]"

									lcCommand = lcCommand + " COLLATE [" + loIndex.Collate + "]"

								Otherwise

							Endcase

							Try

								&lcCommand

							Catch To oErr

								Do Case
									Case oErr.ErrorNo = 1883
										*!* Primary key already exists.

										lcDropCommand = "Alter Table " + This.LongTableName
										lcDropCommand = lcDropCommand + " DROP PRIMARY KEY "

										&lcDropCommand

										&lcCommand

									Case oErr.ErrorNo = 1879
										*!* No primary key.

									Case oErr.ErrorNo = 1880
										*!* Related table is not found in current database.

									Otherwise
										oErr.Message = oErr.Message + Chr(13) + lcCommand
										Throw oErr

								Endcase

							Finally

							Endtry

						Otherwise

					Endcase

				Endfor

			Endif && ! This.lIsVirtual

		Catch To oErr
			* DAE 2009-11-06(17:07:49)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			oErr.Message = oErr.Message + Chr(13) + lcCommand
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			*!*	If Used( This.LongTableName )
			*!*		Use In Alias( This.LongTableName )
			*!*	Endif
			Use In Select( This.LongTableName )

			loTable = Null
			loColInsertTriggers = Null
			loColUpdateTriggers = Null
			* loColDeleteTriggers = Null
			loError = Null

		Endtry

	Endproc  && CreateIndexes

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateTriggers
	*!* Description...: Genera los indices asociados a la tabla
	*!* Date..........: Miércoles 30 de Mayo de 2007 (18:36:29)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure CreateTriggers( tcTriggerFile As String ) As Void;
			HELPSTRING "Genera los Triggers asociados a la tabla"

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loTrigger As oTrigger Of "Tools\Sincronizador\ColDataBases.prg"
		Local lcTrigger As String
		Local lcSP As String
		Local lcTriggerFile As String
		Local lcSPFile As String
		Local lcCmd As String

		Try

			If ! This.lIsVirtual
				* Abrir la tabla padre
				* Use In Select( Alias( This.LongTableName ) )
				*!*	If Used( This.LongTableName )
				*!*		Use In Alias( This.LongTableName )
				*!*	Endif
				Use In Select( This.LongTableName )

				TEXT To lccmd NoShow TextMerge Pretext 15
	            	Use '<<Alltrim( This.LongTableName )>>' Exclusive In 0

				ENDTEXT
				This.ReTryCommand( lcCmd, 10, 1705 )

				Select Alias( This.LongTableName )

				lcTrigger = ""
				lcSP = ""

				*!*					* Delete trigger

				*!*					lcSPFile = Sys(2015)+".spf"
				*!*					lcTriggerFile = Sys(2015)+".trf"

				*!*					Strtofile( "", lcSPFile, 0 )
				*!*					Strtofile( "", lcTriggerFile, 0 )

				TEXT To lcTrigger NoShow TextMerge

*!* ///////////////////////////////////////////////////////
*!* Procedure.....: _ir_Delete_<<This.LongTableName>>
*!* Description...: Delete Trigger for <<This.LongTableName>>
*!* -------------------------------------------------------
*!*
*!*

Procedure _ir_Delete_<<This.LongTableName>>

				ENDTEXT

				For Each loTrigger In This.oColDeleteTriggers

					loTrigger.Create( tcTriggerFile )
					lcSP = lcSP + loTrigger.Name + "() And "

				Endfor
				lcSP = lcSP + " .T. "

				TEXT To lcTrigger NoShow TextMerge additive

	Return <<lcSP>>

EndProc && _ir_Delete_<<This.LongTableName>>

*!*
*!* ///////////////////////////////////////////////////////
				ENDTEXT

				Strtofile( lcTrigger, tcTriggerFile, 1 )

				*!*					Append Procedures From (lcSPFile)
				*!*					Append Procedures From (lcTriggerFile)

				TEXT To lccmd NoShow TextMerge Pretext 15
					Create Trigger On <<This.LongTableName>>
					For Delete As _ir_Delete_<<This.LongTableName>>()

				ENDTEXT

				This.ReTryCommand( lcCmd, 10, 1705 )

				*!*					Erase (lcSPFile)
				*!*					Erase (lcTriggerFile)

				* Insert trigger

				*!*					lcSPFile = Sys(2015)+".spf"
				*!*					lcTriggerFile = Sys(2015)+".trf"

				*!*					Strtofile( "", lcSPFile, 0 )
				*!*					Strtofile( "", lcTriggerFile, 0 )

				TEXT To lcTrigger NoShow TextMerge


*!* ///////////////////////////////////////////////////////
*!* Procedure.....: _ir_Insert_<<This.LongTableName>>
*!* Description...: Insert Trigger for <<This.LongTableName>>
*!* -------------------------------------------------------
*!*
*!*

Procedure _ir_Insert_<<This.LongTableName>>

				ENDTEXT

				lcSP = ""

				For Each loTrigger In This.oColInsertTriggers

					loTrigger.Create( tcTriggerFile )
					lcSP = lcSP + loTrigger.Name + "() And "

				Endfor
				lcSP = lcSP + " .T. "

				TEXT To lcTrigger NoShow TextMerge additive

	Return <<lcSP>>

EndProc  && _ir_Insert_<<This.LongTableName>>

*!*
*!* ///////////////////////////////////////////////////////
				ENDTEXT

				Strtofile( lcTrigger, tcTriggerFile, 1 )

				*!*					Append Procedures From (lcSPFile)
				*!*					Append Procedures From ( lcTriggerFile )

				TEXT To lccmd NoShow TextMerge Pretext 15
					Create Trigger On <<This.LongTableName>>
					For Insert As _ir_Insert_<<This.LongTableName>>()

				ENDTEXT

				This.ReTryCommand( lcCmd, 10, 1705 )

				*!*					Erase (lcSPFile)
				*!*					Erase (lcTriggerFile)

				*!*					* Update trigger

				*!*					lcSPFile = Sys(2015)+".spf"
				*!*					lcTriggerFile = Sys(2015)+".trf"

				*!*					Strtofile( "", lcSPFile, 0 )
				*!*					Strtofile( "", lcTriggerFile, 0 )

				TEXT To lcTrigger NoShow TextMerge

*!* ///////////////////////////////////////////////////////
*!* Procedure.....: _ir_Update_<<This.LongTableName>>
*!* Description...: Update Trigger for <<This.LongTableName>>
*!* -------------------------------------------------------
*!*
*!*

Procedure _ir_Update_<<This.LongTableName>>

				ENDTEXT

				lcSP = ""

				For Each loTrigger In This.oColUpdateTriggers

					loTrigger.Create( tcTriggerFile )
					lcSP = lcSP + loTrigger.Name + "() And "

				Endfor
				lcSP = lcSP + " .T. "

				TEXT To lcTrigger NoShow TextMerge additive

	Return <<lcSP>>

EndProc  && _ir_Update_<<This.LongTableName>>

*!*
*!* ///////////////////////////////////////////////////////
				ENDTEXT

				Strtofile( lcTrigger, tcTriggerFile, 1 )

				*!*					Append Procedures From (lcSPFile)
				*!*					Append Procedures From ( lcTriggerFile )

				TEXT To lccmd NoShow TextMerge Pretext 15
					Create Trigger On <<This.LongTableName>>
					For Update As _ir_Update_<<This.LongTableName>>()

				ENDTEXT

				This.ReTryCommand( lcCmd, 10, 1705 )

				*!*					Erase (lcSPFile)
				*!*					Erase (lcTriggerFile)

			Endif && ! This.lIsVirtual

		Catch To oErr
			* DAE 2009-11-06(17:07:19)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			*!*	If Used( This.LongTableName )
			*!*		Use In Alias( This.LongTableName )
			*!*	Endif
			Use In Select( This.LongTableName )
			loError = Null
		Endtry

	Endproc && CreateTriggers

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Comment_Assign
	*!* Description...:
	*!* Date..........: Jueves 10 de Abril de 2008 (13:31:54)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Comment_Assign( cNewVal ) As String

		Local lcStr As String

		If Len( cNewVal ) > 253
			lcStr = "La Propiedad " + This.LongTableName + ".Comment es demasiado largo(" + Any2Char( Len( cNewVal ) ) + ")" + CR + CR
			lcStr = lcStr + cNewVal
			Error lcStr

		Else
			This.Comment = cNewVal

		Endif

		Return This.Comment

	Endproc && Comment_Assign

	*!*		*!* ///////////////////////////////////////////////////////
	*!*		*!* Procedure.....: AddCodigoYDescripcion
	*!*		*!* Description...: Agrega los campos Codigo y Descripcion para las tablas auxiliares
	*!*		*!* Date..........: Lunes 5 de Noviembre de 2007 (11:41:12)
	*!*		*!* Author........: Ricardo Aidelman
	*!*		*!* Project.......: Sistemas Praxis
	*!*		*!* -------------------------------------------------------
	*!*		*!* Modification Summary
	*!*		*!* R/0001 -
	*!*		*!*
	*!*		*!*

	*!*		Procedure AddCodigoYDescripcion( tnGetFocus As Integer ) As Void;
	*!*				HELPSTRING "Agrega los campos Codigo y Descripcion para las tablas auxiliares"

	*!*			Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"

	*!*			Try

	*!*				If Empty( tnGetFocus )
	*!*					tnGetFocus = 0
	*!*				Endif

	*!*				* Codigo
	*!*				loField = This.oColFields.NewCandidate( "Codigo", "Character", 10)

	*!*				With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
	*!*					.Caption = "Código"
	*!*					.lShowInGrid = .T.
	*!*					.lGetFirstFocus = ( tnGetFocus = 1 )
	*!*				Endwith

	*!*				* Descripcion
	*!*				loField = This.oColFields.NewRegular( "Descripcion",;
	*!*					"Character", 30 )
	*!*				With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
	*!*					.CaseSensitive = .F.
	*!*					.Caption = "Descripción"
	*!*					.Check = "!Empty( Descripcion )"
	*!*					.ErrorMessage = "El Campo DESCRIPCION no puede estar vacío"
	*!*					.lShowInGrid = .T.
	*!*					.lGetFirstFocus = ( tnGetFocus = 2 )
	*!*				Endwith

	*!*			Catch To oErr
	*!*				Throw oErr

	*!*			Finally
	*!*				loField = Null

	*!*			Endtry

	*!*		Endproc
	*!*		*!*
	*!*		*!* END PROCEDURE AddCodigoYDescripcion
	*!*		*!*
	*!*		*!* ///////////////////////////////////////////////////////


	*!*		*!* ///////////////////////////////////////////////////////
	*!*		*!* Procedure.....: AddTreeHierarchicalFields
	*!*		*!* Description...: Agrega los campos UniqueCode y ParentUniqueCode para las tablas auxiliares
	*!*		*!* Date..........: Martes 10 de Febrero de 2009 (16:10:00)
	*!*		*!* Author........: Damian Eiffn
	*!*		*!* Project.......: Sistemas Praxis
	*!*		*!* -------------------------------------------------------
	*!*		*!* Modification Summary
	*!*		*!* R/0001 -
	*!*		*!*
	*!*		*!*

	*!*		Procedure AddTreeHierarchicalFields() As Void;
	*!*				HELPSTRING "Agrega los campos Codigo y Descripcion para las tablas auxiliares"

	*!*			Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"

	*!*			Try

	*!*				* UniqueCode
	*!*				loField = This.oColFields.NewCandidate( "UniqueCode", "character", 20 )
	*!*				With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
	*!*					.Caption = "Código unico"
	*!*					.CaseSensitive = .F.
	*!*					.Check = '! Empty( UniqueCode )'
	*!*					.ErrorMessage = "El Campo UniqueCode no puede estar vacío"
	*!*				Endwith

	*!*				* ParentUniqueCode
	*!*				loField = This.oColFields.NewFK( "ParentUniqueCode", "character", 20 )
	*!*				With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
	*!*					.Caption = "Código unico del Padre"
	*!*					.References = This.Name
	*!*					.CaseSensitive = .F.
	*!*					.TriggerConditionForInsert = ' ! Empty( ' + This.Name + '.ParentUniqueCode ) '
	*!*					.TriggerConditionForUpdate = .TriggerConditionForInsert
	*!*					.ParentPk = 'UniqueCode'
	*!*					.Check = ''
	*!*					.ErrorMessage = ''
	*!*				Endwith

	*!*			Catch To oErr
	*!*				Throw oErr

	*!*			Finally
	*!*				loField = Null

	*!*			Endtry

	*!*		Endproc
	*!*		*!*
	*!*		*!* END PROCEDURE AddTreeHierarchicalFields
	*!*		*!*
	*!*		*!* ///////////////////////////////////////////////////////


	*!*		*!* ///////////////////////////////////////////////////////
	*!*		*!* Procedure.....: AddHierarchicalField
	*!*		*!* Description...: Agrega el campo Parent Id para la tabla
	*!*		*!* Date..........: Martes 10 de Febrero de 2009 (16:10:00)
	*!*		*!* Author........: Damian Eiffn
	*!*		*!* Project.......: Sistemas Praxis
	*!*		*!* -------------------------------------------------------
	*!*		*!* Modification Summary
	*!*		*!* R/0001 -
	*!*		*!*
	*!*		*!*

	*!*		Procedure AddHierarchicalField() As Void;
	*!*				HELPSTRING "Agrega el campo ParentId para la tabla"

	*!*			Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"

	*!*			Try

	*!*				* ParentId
	*!*				loField = This.oColFields.New( 'Parent' + This.Name + 'Id', 'Int' )
	*!*				With loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
	*!*					.Caption = "Id del Padre"
	*!*					.References = This.Name
	*!*					.TriggerConditionForInsert = This.Name + '.Parent' + This.Name + 'Id > 0 '
	*!*					.TriggerConditionForUpdate = .TriggerConditionForInsert
	*!*				Endwith

	*!*			Catch To oErr
	*!*				Throw oErr

	*!*			Finally
	*!*				loField = Null

	*!*			Endtry

	*!*		Endproc
	*!*		*!*
	*!*		*!* END PROCEDURE AddHierarchicalField
	*!*		*!*
	*!*		*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oColProperties_Access
	*!* Date..........: Martes 10 de Marzo de 2009 (19:28:52)
	*!* Author........: Damian Eiff
	*!* Project.......:
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure oColProperties_Access()
		If Vartype( This.oColProperties ) # 'O'
			This.oColProperties = Createobject( 'ColProperties' )
			This.HookPopulateProperties()

		Endif

		Return This.oColProperties

	Endproc && oColProperties_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: HookPopulateProperties
	*!* Description...:
	*!* Date..........: Martes 10 de Marzo de 2009 (19:41:59)
	*!* Author........: Damian Eiff
	*!* Project.......:
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure HookPopulateProperties( ) As Void;
			HELPSTRING "Carga las popiedades iniciales que se definen para las Tier o los Form"

	Endproc && HookPopulateProperties

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: cFormName_Access
	*!* Date..........: Miércoles 11 de Marzo de 2009 (14:21:49)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure cFormName_Access()
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			If Vartype( This.cFormName ) # 'C' ;
					or Empty( This.cFormName )

				This.cFormName = 'ABM' + Space( 1 ) + This.Name

			Endif

		Catch To oErr
			* DAE 2009-11-06(17:07:10)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

		Return This.cFormName

	Endproc  && cFormName_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetPrimaryKey
	*!* Description...: Devuelve el campo que representa a la clave primaria
	*!* Date..........: Viernes 13 de Marzo de 2009 (15:14:26)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure GetPrimaryKey( ) As oField Of "Tools\Sincronizador\colDataBases.prg";
			HELPSTRING "Devuelve el campo que representa a la clave primaria"

		Local loFieldRet As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			For Each loField As oField Of "Tools\Sincronizador\colDataBases.prg" In This.oColFields
				If loField.IndexKey = IK_PRIMARY_KEY
					loFieldRet = loField
					Exit

				Endif && loField.IndexKey = IK_PRIMARY_KEY

			Endfor
			If Vartype( loFieldRet ) = 'O' And loFieldRet.IndexKey # IK_PRIMARY_KEY
				loFieldRet = Null

			Endif

		Catch To oErr
			* DAE 2009-11-06(17:06:49)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

		Return loFieldRet

	Endproc && GetPrimaryKey

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetPrimaryTagName
	*!* Description...: Devuelve el TAG de la clave primaria
	*!* Date..........: Viernes 13 de Marzo de 2009 (15:14:26)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure GetPrimaryTagName( ) As oField Of "Tools\Sincronizador\colDataBases.prg";
			HELPSTRING "Devuelve el TAG de la clave primaria"

		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local lcTagName As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			lcTagName = ""
			loField = This.GetPrimaryKey()
			If ! Empty( loField.TagName )
				lcTagName = loField.TagName

			Endif && ! Empty( loField.TagName )

		Catch To oErr
			* DAE 2009-11-06(17:06:29)
			* loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loField = Null
			loError = Null

		Endtry

		Return lcTagName

	Endproc  && GetPrimaryTagName

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: cDataConfigurationKey_Access
	*!* Date..........: Viernes 13 de Marzo de 2009 (17:22:26)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure cDataConfigurationKey_Access()

		Local lcTableName As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			If Vartype( This.cDataConfigurationKey ) # 'C' ;
					Or Empty( This.cDataConfigurationKey )

				lcTableName = CamelProperCase( Alltrim( This.Name ) )
				This.cDataConfigurationKey = Chrtran( Chrtran( lcTableName, ' ', '' ), '-', '_' )

			Endif

		Catch To oErr
			* DAE 2009-11-06(17:05:26)
			*!*	loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry
		Return This.cDataConfigurationKey

	Endproc  && cDataConfigurationKey_Access

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: SetAsArchivo
	*!*	*!* Description...: Configura la Entidad para que herede de la Clase Archivo
	*!*	*!* Date..........: Viernes 13 de Marzo de 2009 (17:59:52)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001  -
	*!*	*!*
	*!*	*!*

	*!*	Procedure SetAsArchivo(  ) As Void;
	*!*			HELPSTRING "Configura la Entidad para que herede de la Clase Archivo"

	*!*		Try
	*!*			With This As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*				.cBaseClass = .cBaseClassDefault
	*!*				.cBaseClassLib = .cBaseClassLibDefault
	*!*				.cFormClass = .cFormClassDefault
	*!*				.cFormClassLib = .cFormClassLibDefault
	*!*				.nClassType = .nClassTypeDefault
	*!*				*
	*!*				.lHasBussinessTier = .T.
	*!*				.lHasDataTier = .T.
	*!*				.lHasWrapperTier = .F.
	*!*				.lHasUserTier = .T.
	*!*				.lHasValidTier = .T.
	*!*				.lHasClientWsTier = .F.
	*!*				.lHasServerWsTier = .F.
	*!*			Endwith

	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally

	*!*		Endtry

	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE SetAsArchivo
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: SetAsChild
	*!*	*!* Description...: Configura la Entidad para que herede de la Clase ChildEntity
	*!*	*!* Date..........: Viernes 13 de Marzo de 2009 (18:02:24)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001  -
	*!*	*!*
	*!*	*!*

	*!*	Procedure SetAsChild(  ) As Void;
	*!*			HELPSTRING "Configura la Entidad para que herede de la Clase ChildEntity"


	*!*		Try
	*!*			With This As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*				.cBaseClass = 'ChildEntity'
	*!*				.cBaseClassLib = .cBaseClassLibDefault
	*!*				.cFormClass = 'ABMChildForm'
	*!*				.cFormClassLib = .cFormClassLibDefault
	*!*				.nClassType = CT_CHILD
	*!*				.lHasBussinessTier = .F.
	*!*				.lHasDataTier = .F.
	*!*				.lHasWrapperTier = .F.
	*!*				.lHasClientWsTier = .F.
	*!*				.lHasServerWsTier = .F.
	*!*				.lHasUserTier = .T.
	*!*				.lHasValidTier = .T.
	*!*			Endwith
	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally

	*!*		Endtry

	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE SetAsChild
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: SetAsChildTree
	*!*	*!* Description...: Configura la Entidad para que herede de la Clase ChildTreeEntity
	*!*	*!* Date..........: Viernes 13 de Marzo de 2009 (18:03:11)
	*!*	*!* Author........: Damian Eiff
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001  -
	*!*	*!*
	*!*	*!*

	*!*	Procedure SetAsChildTree(  ) As Void;
	*!*			HELPSTRING "Configura la Entidad para que herede de la Clase ChildTreeEntity"

	*!*		Try
	*!*			With This As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*				.cBaseClass = 'ChildTreeEntity'
	*!*				.cBaseClassLib = .cBaseClassLibDefault
	*!*				.cFormClass = 'ABMTreeChildForm'
	*!*				.cFormClassLib = .cFormClassLibDefault
	*!*				.nClassType = CT_CHILDTREE
	*!*				.lHasBussinessTier = .F.
	*!*				.lHasDataTier = .F.
	*!*				.lHasWrapperTier = .F.
	*!*				.lHasUserTier = .T.
	*!*				.lHasValidTier = .T.
	*!*				.lHasClientWsTier = .F.
	*!*				.lHasServerWsTier = .F.
	*!*			Endwith
	*!*		Catch To oErr
	*!*			Local loError As prxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"
	*!*			loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*			loError.Process( oErr )
	*!*			Throw loError

	*!*		Finally

	*!*		Endtry

	*!*	Endproc
	*!*	*!*
	*!*	*!* END PROCEDURE SetAsChildTree
	*!*	*!*
	*!*	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: cCursorName_Access
	*!* Date..........: Sábado 21 de Marzo de 2009 (13:01:14)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure cCursorName_Access()

		If Vartype( This.cCursorName ) # 'C' ;
				Or Empty( This.cCursorName )
			This.cCursorName = 'c' + This.Name

		Endif
		Return This.cCursorName

	Endproc && cCursorName_Access

	*
	* cKeyName_Access
	Protected Procedure cKeyName_Access()

		If Empty( This.cKeyName )
			*!*				This.cKeyName = Strtran( Lower( This.Name ), "sys_", "" )
			* RA 2013-06-02(12:21:16)
			* Para que GetEntity() devuelva en funcion de la Clase
			This.cKeyName = Lower( This.cBaseClass )

		Endif

		Return This.cKeyName

	Endproc && cKeyName_Access

	*
	* SQLStat_Access
	Protected Procedure SQLStat_Access() As String

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			*!* Assert ! Empty( This.SQLStat ) Message 'SQLStat'
			If Empty( This.SQLStat ) Or Vartype( This.SQLStat ) # 'C'

				This.SQLStat = This.oParent.GetSelectSQL( This, '', .T. )

			Endif && Empty( This.SQLStat )

		Catch To oErr
			* DAE 2009-11-06(17:05:09)
			*!*	loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

		Return This.SQLStat

	Endproc && SQLStat_Access

	*
	* SQLStatCombo_Access
	Protected Procedure SQLStatCombo_Access() As String

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			*!* Assert ! Empty( This.SQLStatCombo ) Message 'SQLStatCombo'
			If Empty( This.SQLStatCombo ) Or Vartype( This.SQLStatSelector ) # 'C'
				* This.SQLStatCombo = This.oParent.GetSelectSQL( This, 'nComboOrder <> 0 Or AutoInc', .T. )
				* This.SQLStatCombo = This.oParent.GetSelectSQL( This, 'nComboOrder # 0', .T. )
				This.SQLStatCombo = This.oParent.GetSelectSQL( This, 'nComboOrder # 0' )

			Endif && Empty( This.SQLStatCombo )

		Catch To oErr
			* DAE 2009-11-06(17:04:53)
			*!*	loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

		Return This.SQLStatCombo

	Endproc && SQLStatCombo_Access

	*
	* SQLStatKeyFinder_Access
	Protected Procedure SQLStatKeyFinder_Access() As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			*!* Assert ! Empty( This.SQLStatKeyFinder ) Message 'SQLStatKeyFinder'
			If Empty( This.SQLStatKeyFinder ) Or Vartype( This.SQLStatSelector ) # 'C'
				* This.SQLStatKeyFinder = This.oParent.GetSelectSQL( This, 'nKeyFinderOrder <> 0 Or AutoInc' , .T. )
				This.SQLStatKeyFinder = This.oParent.GetSelectSQL( This, 'nShowInKeyFinder # 0' , .T. )

			Endif && Empty( This.SQLStatKeyFinder )

		Catch To oErr
			* DAE 2009-11-06(17:04:41)
			*!*	loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry


		Return This.SQLStatKeyFinder

	Endproc && SQLStatKeyFinder_Access

	*
	* SQLStatSelector_Access
	Protected Procedure SQLStatSelector_Access() As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			*!* Assert ! Empty( This.SQLStatSelector ) Message 'SQLStatSelector'
			If Empty( This.SQLStatSelector ) Or Vartype( This.SQLStatSelector ) # 'C'
				* This.SQLStatSelector = This.oParent.GetSelectSQL( This, 'lShowInSelector Or nSelectorOrder <> 0 Or AutoInc', .T. )
				This.SQLStatSelector = This.oParent.GetSelectSQL( This, 'nSelectorOrder # 0', .T. )

			Endif && Empty( This.SQLStatSelector )

		Catch To oErr
			* DAE 2009-11-06(17:05:43)
			*!*	loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

		Return This.SQLStatSelector

	Endproc && SQLStatSelector_Access


	*!*		*
	*!*		* Name_Access
	*!*		Protected Procedure Name_Access()

	*!*			Return Alltrim( This.cPrefijo ) + This.Name

	*!*		Endproc && Name_Access


	*
	* Genera la Coleccion Indices
	Procedure GenerateIndexes(  ) As Void;
			HELPSTRING "Genera la Coleccion Indices"

		Local loColFields As ColFields Of "Tools\Sincronizador\ColDataBases.prg"
		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColIndexes As ColIndexes Of "Tools\Sincronizador\ColDataBases.prg"
		Local loIndex As oIndex Of "Tools\Sincronizador\ColDataBases.prg"
		Local lnIndex As Integer
		Local lcPrefijo As String
		Local lcCommand As String
		Local lcKeyType As String

		Try

			loColFields = This.oColFields
			loColIndexes = This.oColIndexes

			For Each loField In loColFields
				If loField.IndexKey # IK_NOKEY
					loIndex = loColIndexes.New()
					loIndex.KeyType = loField.IndexKey
					If loField.CaseSensitive
						loIndex.KeyExpression = loField.Name

					Else
						loIndex.KeyExpression = "Upper( " + loField.Name + " )"

					Endif

					If !Empty( loField.ForExpression )
						loIndex.ForExpression = loField.ForExpression
					Endif

					If Empty( loField.TagName )
						loField.TagName = Substr( loField.Name, 1, 10 )

					Endif

					loIndex.TagName = loField.TagName
					loIndex.Collate = loField.Collate
					loIndex.Name = loField.Name

					loColIndexes.AddIndex( loIndex )
					loIndex = Null

				Endif

			Endfor

			lnIndex = 0

			For Each loIndex In loColIndexes
				If Inlist( loIndex.KeyType, IK_REGULAR, IK_CANDIDATE_KEY, IK_UNIQUE_KEY, IK_PRIMARY_KEY )

					lcCommand = "INDEX ON " + loIndex.KeyExpression

					If ! Empty( loIndex.ForExpression )
						lcCommand = lcCommand + " FOR " + loIndex.ForExpression

					Else
						lcCommand = lcCommand + " FOR !Deleted()"

					Endif && ! Empty( loIndex.ForExpression )

					lnIndex = lnIndex + 1
					Do Case
						Case loIndex.KeyType = IK_REGULAR
							lcPrefijo = "RG"
							lcKeyType = ""

						Case loIndex.KeyType = IK_CANDIDATE_KEY
							lcPrefijo = "CN"
							lcKeyType = " CANDIDATE "

						Case loIndex.KeyType = IK_UNIQUE_KEY
							lcPrefijo = "UN"
							lcKeyType = " UNIQUE "

						Case loIndex.KeyType = IK_PRIMARY_KEY
							lcPrefijo = "PK"
							lcKeyType = " CANDIDATE "

						Otherwise
							lcPrefijo = ""
							lcKeyType = ""

					Endcase

					If Empty( loIndex.TagName )
						loIndex.TagName = loIndex.Name
					Endif

					loIndex.TagName = Substr( loIndex.TagName, 1, 10 )
					lcCommand = lcCommand + " TAG [" + loIndex.TagName + "]"

					lcCommand = lcCommand + " COLLATE [" + loIndex.Collate + "]"

					loIndex.cCommand = lcCommand + lcKeyType

				Else
					loIndex.cCommand = ""

				Endif

			Endfor


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loColFields = Null
			loField = Null
			loColIndexes = Null
			loIndex = Null

		Endtry

	Endproc && GenerateIndexes



	*
	*
	Procedure Destroy(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			This.oCursorAdapter 	= Null
			This.oColFields 		= Null
			This.oColForms 			= Null
			This.oColTiers 			= Null
			This.oColIndexes 		= Null
			This.oColUpdateTriggers = Null
			This.oColDeleteTriggers = Null
			This.oColInsertTriggers = Null

			DoDefault()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Destroy

	*
	* MainID_Access
	Protected Procedure MainID_Access()

		Return This.cMainID

	Endproc && MainID_Access

	* MainID_Assign

	Protected Procedure MainID_Assign( uNewValue )

		This.MainID = uNewValue
		This.cMainID = uNewValue

	Endproc && MainID_Assign


	*
	* Padre_Access
	Protected Procedure Padre_Access()

		Return This.cPadre

	Endproc && Padre_Access

	* Padre_Assign

	Protected Procedure Padre_Assign( uNewValue )

		This.Padre = uNewValue
		This.cPadre = uNewValue

	Endproc && Padre_Assign

	*
	* cLongTableName_Access
	Protected Procedure cLongTableName_Access()

		Return This.LongTableName

	Endproc && cLongTableName_Access

	* cLongTableName_Assign

	Protected Procedure cLongTableName_Assign( uNewValue )

		This.LongTableName = uNewValue

	Endproc && cLongTableName_Assign

Enddefine && oTable

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColFields
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Bases de Datos
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColFields As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	#If .F.
		Local This As ColFields Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="addfield" type="event" display="AddField" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="newpk" type="method" display="NewPK" />] + ;
		[<memberdata name="newfk" type="method" display="NewFK" />] + ;
		[<memberdata name="newcandidate" type="method" display="NewCandidate" />] + ;
		[<memberdata name="newregular" type="method" display="NewRegular" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddField
	*!* Description...: Agrega un Campo a la colección ColFields
	*!* Date..........: Martes 29 de Mayo de 2007 (11:04:54)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure AddField( toField As oField Of "Tools\Sincronizador\ColDataBases.prg") As Void;
			HELPSTRING "Agrega un Campo a la colección ColFields"

		Local i As Integer
		Local lcKey As String

		Try

			toField.oParent = This.oParent
			lcKey = Lower( toField.Name )
			i = This.GetKey( lcKey )

			If Empty( i )
				This.AddItem( toField, lcKey )
				* @TODO Damian Eiff 2009-10-22 (17:37:39)
				* Borrar
				* toField.nGridOrder = This.Count
				* toField.nShowInKeyFinder = This.Count



			Endif

		Catch To oErr
			oErr.Message = oErr.Message + toField.Name
			Throw oErr

		Finally
		Endtry

	Endproc && AddField

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Comment_Assign
	*!* Description...:
	*!* Date..........: Jueves 10 de Abril de 2008 (13:31:54)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Comment_Assign( cNewVal ) As String

		If Len( cNewVal ) > 253
			Local lcStr As String
			lcStr = "La Propiedad " + This.Name + ".Comment es demasiado largo(" + Any2Char(Len( cNewVal )) + ")"+ CR + CR
			lcStr = lcStr + cNewVal
			Error lcStr

		Else
			This.Comment = cNewVal

		Endif

		Return This.Comment

	Endproc
	*!*
	*!* END PROCEDURE Comment_Assign
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oField vacío
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure New( tcName As String,;
			tcFieldType As String,;
			tnFieldWidth As Integer,;
			tnFieldPrecision As Integer ) As oField ;
			HELPSTRING "Obtiene un elemento oField vacío"

		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"

		loField = This.GetItem( tcName )

		If Vartype( loField ) = "O"
			tcFieldType 		= loField.FieldType
			tnFieldWidth 		= loField.FieldWidth
			tnFieldPrecision 	= loField.FieldPrecision

		Else
			loField = Createobject("oField")
			If Vartype( tcName ) == "C"
				loField.Name = tcName
			Endif
			If Vartype( tnFieldWidth ) == "N"
				loField.FieldWidth = tnFieldWidth
			Endif
			If Vartype( tnFieldPrecision ) == "N"
				loField.FieldPrecision = tnFieldPrecision
			Endif

		Endif

		loField.DisplayClassLibrary = IB_DISPLAYCLASSLIBRARY

		If Vartype( tcFieldType ) == "C"
			Do Case
				Case Inlist( Lower( tcFieldType ), "w", "blob" )
					loField.FieldType = "blob"
					loField.DisplayClass = ""
					loField.DisplayClassLibrary = ""
					loField.nLength = 50

				Case Inlist( Lower( tcFieldType ), "c", "char", "character" )
					loField.FieldType = "character"
					loField.DisplayClass = IB_STRING
					loField.InputMask = Replicate("X", loField.FieldWidth )
					loField.Format = "RK"

				Case Inlist( Lower( tcFieldType ), "y", "currency", "money" )
					loField.FieldType = "currency"
					loField.DisplayClass = IB_NUMERIC
					loField.Format = "$Z"
					*!* loField.InputMask = Replicate("9", loField.FieldWidth - loField.FieldPrecision - 1)
					*!* loField.InputMask = loField.InputMask + "." + Replicate("9", loField.FieldPrecision )
					loField.InputMask = ConvertInputMask( loField.FieldWidth, loField.FieldPrecision, "#", .T. )
					loField.Format = "RK"

				Case Inlist( Lower( tcFieldType ), "t", "datetime" )
					loField.FieldType = "datetime"
					loField.DisplayClass = IB_DATE

				Case Inlist( Lower( tcFieldType ), "d", "date" )
					loField.FieldType = "date"
					loField.DisplayClass = IB_DATE
					loField.nLength = 10

				Case Inlist( Lower( tcFieldType ), "g", "general" )
					loField.FieldType = "general"
					loField.DisplayClass = ""
					loField.DisplayClassLibrary = ""

				Case Inlist( Lower( tcFieldType ), "i", "int", "integer", "long" )
					loField.FieldType = "integer"
					loField.DisplayClass = IB_NUMERIC
					loField.nLength = 6
					loField.InputMask = ConvertInputMask( loField.nLength, 0, "#", .F. )
					loField.Format = "K"

				Case Inlist( Lower( tcFieldType ), "l", "logical", "boolean", "bit" )
					loField.FieldType = "logical"

					loField.lIsLogical = .T.
					loField.Default = .F.
					loField.DisplayClass = IB_CHECKBOX
					loField.nLength = 1
					*loField.InputMask = ConvertInputMask( loField.nLength, 0, "9", .F. )

				Case Inlist( Lower( tcFieldType ), "m", "memo" )
					loField.FieldType = "memo"
					loField.DisplayClass = IB_EDITBOX
					loField.nLength = 50

				Case Inlist( Lower( tcFieldType ), "n", "num", "numeric" )
					loField.FieldType = "numeric"
					loField.DisplayClass = IB_NUMERIC
					*!* loField.InputMask = Replicate("9", loField.FieldWidth - loField.FieldPrecision - 1)
					*!* loField.InputMask = loField.InputMask + "." + Replicate("9", loField.FieldPrecision )
					loField.InputMask = ConvertInputMask( loField.FieldWidth, loField.FieldPrecision, "#", .T. )
					loField.Format = "RK"

				Case Inlist( Lower( tcFieldType ), "f", "float" )
					* Included for compatibility, the Float data type is functionally equivalent to Numeric.
					* Same as Numeric
					loField.FieldType = "float"
					* loField.DisplayClass = ""
					* loField.DisplayClassLibrary = ""
					loField.DisplayClass = IB_NUMERIC
					*!* loField.InputMask = Replicate("9", loField.FieldWidth - loField.FieldPrecision - 1)
					*!* loField.InputMask = loField.InputMask + "." + Replicate("9", loField.FieldPrecision )
					loField.InputMask = ConvertInputMask( loField.FieldWidth, loField.FieldPrecision, "#", .T. )
					loField.Format = "RK"


				Case Inlist( Lower( tcFieldType ), "q", "varbinary" )
					loField.FieldType = "varbinary"
					loField.DisplayClass = ""
					loField.DisplayClassLibrary = ""

				Case Inlist( Lower( tcFieldType ), "v", "varchar" )
					loField.FieldType = "varchar"
					loField.DisplayClass = IB_STRING

				Case Inlist( Lower( tcFieldType ), "b", "double" )
					loField.FieldType = "double"
					* loField.DisplayClass = ""
					* loField.DisplayClassLibrary = ""
					loField.DisplayClass = IB_NUMERIC
					*!* loField.InputMask = Replicate("9", loField.FieldWidth - loField.FieldPrecision - 1)
					*!* loField.InputMask = loField.InputMask + "." + Replicate("9", loField.FieldPrecision )
					loField.InputMask = ConvertInputMask( loField.FieldWidth, loField.FieldPrecision, "#", .T. )
					loField.Format = "RK"


				Otherwise

			Endcase
		Endif

		This.AddField( loField )

		Return loField

	Endproc && New

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: NewPK
	*!* Description...: Devuelve un campo integer autoinc
	*!* Date..........: Viernes 1 de Junio de 2007 (09:46:10)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	*!*		Procedure NewPK( tcName As String ) As oField Of "Tools\Sincronizador\ColDataBases.prg";
	*!*				HELPSTRING "Devuelve un campo integer autoinc"

	Procedure NewPK( tcName As String,;
			tcFieldType As String,;
			tnFieldWidth As Integer,;
			tnFieldPrecision As Integer ) As oField Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oField vacío configurado como PK"


		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"


		If Empty( tcFieldType )
			tcFieldType = "I"
		Endif

		tcFieldType = Upper( tcFieldType )

		If This.oParent.lIsFree
			If Empty( tcFieldType )
				tcFieldType = "I"
			Endif
			loField = This.NewCandidate( tcName,;
				tcFieldType,;
				tnFieldWidth,;
				tnFieldPrecision )

		Else

			If tcFieldType # "C"
				loField = This.New( tcName, "I" )
				loField.Autoinc = .T.

			Else
				loField = This.New( tcName,;
					tcFieldType,;
					tnFieldWidth,;
					tnFieldPrecision )

			Endif

			loField.IndexKey = IK_PRIMARY_KEY
			loField.lIsSystem = .T.
			loField.lIsPrimaryKey = .T.

			If !Empty( tcName )
				*loField.Check = "!Empty( " + tcName + " )"
				loField.ErrorMessage = "El Campo " + tcName + " Es Obligatorio"

				TEXT To loField.Check NoShow TextMerge Pretext 15
				!Empty( <<tcName>> ) And !IsNull( <<tcName>> )
				ENDTEXT


				If Lower( Right( tcName, 2 )) = "id"
					loField.Caption = Substr( tcName, 1, Len( tcName ) - 2 )
				Endif
			Endif

		Endif

		Return loField

	Endproc
	*!*
	*!* END PROCEDURE NewPK
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: NewFK
	*!* Description...: Obtiene un elemento oField configurado como ForeignKey
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure NewFK( tcName As String,;
			tcFieldType As String,;
			tnFieldWidth As Integer,;
			tnFieldPrecision As Integer ) As oField Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oField vacío"

		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"

		If Vartype( tcFieldType ) # "C"
			tcFieldType = "Integer"

		Endif

		loField = This.New( tcName,;
			tcFieldType,;
			tnFieldWidth,;
			tnFieldPrecision )

		loField.IndexKey = IK_FOREIGN_KEY
		loField.DisplayClass = IB_COMBO

		If ! Empty( tcName )
			loField.Check = "! Empty( " + tcName + " )"
			loField.ErrorMessage = "El Campo " + tcName + " Es Obligatorio"

		Endif

		loField.nLength = 25

		Return loField

	Endproc && NewFK

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: NewCandidate
	*!* Description...: Obtiene un elemento oField configurado como Candidate
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure NewCandidate( tcName As String,;
			tcFieldType As String,;
			tnFieldWidth As Integer,;
			tnFieldPrecision As Integer ) As oField Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oField vacío configurado como Candidate"

		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"

		loField = This.New( tcName,;
			tcFieldType,;
			tnFieldWidth,;
			tnFieldPrecision )

		loField.IndexKey = IK_CANDIDATE_KEY
		If !Empty( tcName )
			loField.Check = "!Empty( " + tcName + " )"
			loField.ErrorMessage = "El Campo " + tcName + " Es Obligatorio"

			If Inlist( Lower( loField.FieldType ), "c", "char", "character", "v", "varchar" )
				loField.CaseSensitive = .F.
			Endif

		Endif

		Return loField

	Endproc
	*!*
	*!* END PROCEDURE NewCandidate
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: NewRegular
	*!* Description...: Obtiene un elemento oField configurado como Regular
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure NewRegular( tcName As String,;
			tcFieldType As String,;
			tnFieldWidth As Integer,;
			tnFieldPrecision As Integer ) As oField Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oField vacío configurado como Regular"

		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"

		loField = This.New( tcName,;
			tcFieldType,;
			tnFieldWidth,;
			tnFieldPrecision )

		loField.IndexKey = IK_REGULAR

		Return loField

	Endproc && NewRegular

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: NewVirtual
	*!* Description...: Obtiene un elemento oField vacío
	*!* Date..........: Lunes 17 de Agosto de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure NewVirtual( tcName As String,;
			tcFieldType As String,;
			tnFieldWidth As Integer,;
			tnFieldPrecision As Integer ) As oField Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oField vacío"

		Local loField As oField Of "Tools\Sincronizador\ColDataBases.prg"

		loField = This.New( tcName,;
			tcFieldType,;
			tnFieldWidth,;
			tnFieldPrecision )

		loField.lIsVirtual = .T.
		loField.lSaveInDataBase = .F.

		Return loField

	Endproc && NewVirtual


Enddefine && ColFields

*!* ///////////////////////////////////////////////////////
*!* Class.........: oField
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Base de Datos
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oField As SessionBase

	#If .F.
		Local This As oField Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!* Tipo de Dato
	FieldType = ""
	*!* Ancho del Campo
	FieldWidth = 0
	*!* Presición del Campo
	FieldPrecision = 0
	*!* Indica si permite valores nulos
	Null = .F.
	*!* Specifies the table validation rule for the field.
	*!* Must evaluate to a logical expression and can be a user-defined function
	*!* or a stored procedure.
	Check = ""

	*!* Mensaje de error que se muestra si Check evalua a .F.
	ErrorMessage = ""
	*!* Indica si el campo es autoincremental
	Autoinc = .F.
	*!* Si es mayor que 0, indica el siguiente número automático
	Nextvalue = 0
	*!*
	StepValue = 1
	*!* Valor por defecto
	Default = Null
	*!* Indica si incluye la clausula NOCPTRANS
	NoCPTrans = .F.
	*!* Indica si incluye la cláusula NOVALIDATE
	Novalidate = .F.

	DataSession = SET_DEFAULT

	*!* Tipo de indice generado para este campo. (Constantes definidas en ta.h)
	IndexKey = IK_NOKEY

	*!* Condicion de filtro para el indice ( Default: "!Deleted()" )
	ForExpression = ""


	*!*
	Collate = "SPANISH"

	*!* Specifies the parent table to which a persistent relationship is established
	References = ""
	cReferences = ""

	*!* Indica si la expresión de indice diferencia mayusculas de minusculas
	CaseSensitive = .T.

	*!* Specifies an index tag name for the parent table.
	*!*	Index tag names can contain up to 10 characters.
	*!*	If you omit the TAG clause, the relationship is established using the
	*!*	primary index key of the parent table
	TagName = ""

	*!* Etiqueta de indices correspondiente a la tabla padre
	ParentTagName = ""

	*!* Contiene el valor de la propiedad Caption del control Label que mostrará el campo
	Caption = ""
	cCaption = ""

	*!* Comentario que documenta el objeto
	Comment = ""

	*!* Name of the class used for field mapping.
	DisplayClass = ""

	*!* Path to the class library specified with the DisplayClass property
	DisplayClassLibrary = ""

	*!* The field display format
	Format = ""

	*!* The field input format
	InputMask = ""

	*!* Condición a cumplir para que se dispare el trigger
	TriggerConditionForInsert = ".T."
	*!* Condición a cumplir para que se dispare el trigger
	TriggerConditionForUpdate = ".T."
	*!* Condición a cumplir para que se dispare el trigger
	TriggerConditionForDelete = ".T."

	*!* Nombre de la clave de la tabla padre
	ParentPk = ''

	*!* Indica si el campo se muestra en la Grilla
	lShowInGrid = .F.

	* Referencia al objeto que toma el control en una grilla
	oCurrentControl = Null


	* Posición dentro de la grilla
	* nGridOrder = 0 Indica que no se utiliza el campo
	* nGridOrder > 0 Posicion que ocupa en la grilla
	* nGridOrder < 0 Es una columna que no se muestra
	nGridOrder = 0

	* Posición dentro de la grilla del Selector
	* nSelectorOrder = 0 Indica que no se utiliza el campo
	* nSelectorOrder > 0 Posicion que ocupa en la grilla
	* nSelectorOrder < 0 Es una columna que no se muestra
	nSelectorOrder = 0

	*!* Indica si el campo se muestra en el navegador
	lShowInNavigator = .F.


	* Posición dentro del KeyFinder
	* nShowInKeyFinder = 0 Indica que no se utiliza el campo en el KeyFinder
	* nShowInKeyFinder > 0 Posicion que ocupa en el KeyFinder
	* nShowInKeyFinder < 0 Es una columna que no se muestra en el KeyFinder pero se utiliza para las busquedas
	nShowInKeyFinder = 0

	* Posición dentro del Combo
	* nComboOrder = 0 Indica que no se utiliza el campo en el Combo
	* nComboOrder > 0 Posicion que ocupa en el Combo
	* nComboOrder < 0 Es una columna que no se muestra en el Combo
	nComboOrder = 0

	* Indica si el campo está incluido en la búsqueda rápida del KeyFinder
	lFastSearch = .F.

	* Condición de Búsqueda
	cSearchCondition = "!#"

	*!* Indica si el campo es requerido
	lRequired = .F.

	* Nombre de fantasía por el que se accede a la coleccion oDataDictionary
	cKeyName = ""

	* Mensaje a mostrar cuando se pase el cursor sobre el control
	cToolTipText = ""

	* Mensaje a mostrar en la barra de estado
	cStatusBarText = ""

	* Longitud del control que muestra el campo. Prevalece sobre FieldWidth. (para los combos de las FK)

	nLength = 0

	lFitColumn = .F.
	lOrderByThis = .F.

	* Indica si el campo es logico
	lIsLogical = .F.

	* Indica si el control asociado al campo es el que toma el foco
	lGetFirstFocus = .F.

	* Expresión que se ejecuta para asignarle un valor al campo
	cDefaultValueExpression = ""

	* Clave de acceso a la tabla externa de una FK
	cParentKeyName = ""

	*!* Indica si el campo es de sistema
	lIsSystem = .F.

	* Indica si es clave primaria
	lIsPrimaryKey = .F.

	* Condicion de búsqueda predeterminada
	* Valores posibles:
	* 					"E" 	->	Entre
	* 					"like" 	->	Comienza con
	* 					"%" 	->	Contiene
	* 					"!#" 	->	Igual
	* 					"#" 	->	Distinto
	cDefaultCondition = "%"

	*!* Indica si el campo es virtual
	lIsVirtual = .F.

	*!* Indica que el campo se graba en la base de datos
	lSaveInDataBase = .T.

	*!* Indica que la columna se indexa en el cliente
	lIndexOnClient = .F.

	*!* Nombre del Tag actual para el campo
	CurrentTagName = ''

	*!* Expresion para utilizar de forma predeterminada en las consultas SQL
	cDefaultSqlExp = ''

	*!* Indica que el campo se muestra como parte de otra tabla caundo existe un FK a la tabla
	nDefaultReference = 0

	* Caption de la columna que hace referencia a la FK
	cReferenceCaption = ""


	* Se usa en las vistas, para indicar si el campo puede modificarse
	lCanUpdate = .T.

	* Indica si el campo se ve en Browse y Edit
	* (Clipper2Fox)
	lVisible = .T.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lvisible" type="property" display="lVisible" />] + ;
		[<memberdata name="lcanupdate" type="property" display="lCanUpdate" />] + ;
		[<memberdata name="istype" type="method" display="IsType" />] + ;
		[<memberdata name="creferencecaption" type="property" display="cReferenceCaption" />] + ;
		[<memberdata name="ndefaultreference" type="property" display="nDefaultReference" />] + ;
		[<memberdata name="nselectororder" type="property" display="nSelectorOrder" />] + ;
		[<memberdata name="ncomboorder" type="property" display="nComboOrder" />] + ;
		[<memberdata name="cdefaultsqlexp" type="property" display="cDefaultSqlExp" />] + ;
		[<memberdata name="currenttagname" type="property" display="CurrentTagName" />] + ;
		[<memberdata name="currenttagname_access" type="method" display="CurrentTagName_Access" />] + ;
		[<memberdata name="lindexonclient" type="property" display="lIndexOnClient" />] + ;
		[<memberdata name="lsaveindatabase" type="property" display="lSaveInDataBase" />] + ;
		[<memberdata name="lisvirtual" type="property" display="lIsVirtual" />] + ;
		[<memberdata name="cdefaultcondition" type="property" display="cDefaultCondition" />] + ;
		[<memberdata name="nshowinkeyfinder" type="property" display="nShowInKeyFinder" />] + ;
		[<memberdata name="lfastsearch" type="property" display="lFastSearch" />] + ;
		[<memberdata name="lisprimarykey" type="property" display="lIsPrimaryKey" />] + ;
		[<memberdata name="cparentkeyname" type="property" display="cParentKeyName" />] + ;
		[<memberdata name="cdefaultvalueexpression" type="property" display="cDefaultValueExpression" />] + ;
		[<memberdata name="lgetfirstfocus" type="property" display="lGetFirstFocus" />] + ;
		[<memberdata name="nlength" type="property" display="nLength" />] + ;
		[<memberdata name="cstatusbartext" type="property" display="cStatusBarText" />] + ;
		[<memberdata name="cstatusbartext_access" type="method" display="cStatusBarText_Access" />] + ;
		[<memberdata name="ctooltiptext" type="property" display="cToolTipText" />] + ;
		[<memberdata name="parenttagname" type="property" display="ParentTagName" />] + ;
		[<memberdata name="casesensitive" type="property" display="CaseSensitive" />] + ;
		[<memberdata name="indexkey" type="property" display="IndexKey" />] + ;
		[<memberdata name="forexpression" type="property" display="ForExpression" />] + ;
		[<memberdata name="tagname" type="property" display="TagName" />] + ;
		[<memberdata name="references" type="property" display="References" />] + ;
		[<memberdata name="collate" type="property" display="Collate" />] + ;
		[<memberdata name="novalidate" type="property" display="Novalidate" />] + ;
		[<memberdata name="nocptrans" type="property" display="Nocptrans" />] + ;
		[<memberdata name="default" type="property" display="Default" />] + ;
		[<memberdata name="stepvalue" type="property" display="StepValue" />] + ;
		[<memberdata name="nextvalue" type="property" display="NextValue " />] + ;
		[<memberdata name="autoinc" type="property" display="Autoinc" />] + ;
		[<memberdata name="errormessage" type="property" display="ErrorMessage" />] + ;
		[<memberdata name="check" type="property" display="Check" />] + ;
		[<memberdata name="null" type="property" display="Null" />] + ;
		[<memberdata name="fieldprecision" type="property" display="FieldPrecision" />] + ;
		[<memberdata name="fieldwidth" type="property" display="FieldWidth" />] + ;
		[<memberdata name="fieldtype" type="property" display="FieldType" />] + ;
		[<memberdata name="ruleexpression" type="property" display="RuleExpression" />] + ;
		[<memberdata name="inputmask" type="property" display="InputMask" />] + ;
		[<memberdata name="format" type="property" display="Format" />] + ;
		[<memberdata name="displayclasslibrary" type="property" display="DisplayClassLibrary" />] + ;
		[<memberdata name="displayclass" type="property" display="DisplayClass" />] + ;
		[<memberdata name="comment" type="property" display="Comment" />] + ;
		[<memberdata name="caption" type="property" display="Caption" />] + ;
		[<memberdata name="triggerconditionforinsert" type="property" display="TriggerConditionForInsert" />] + ;
		[<memberdata name="triggerconditionforupdate" type="property" display="TriggerConditionForUpdate" />] + ;
		[<memberdata name="triggerconditionfordelete" type="property" display="TriggerConditionForDelete" />] + ;
		[<memberdata name="print" type="method" display="Print" />] + ;
		[<memberdata name="displayclasslibrary_assign" type="method" display="DisplayClassLibrary_Assign" />] + ;
		[<memberdata name="parentpk" type="property" display="ParentPk" />] + ;
		[<memberdata name="lshowingrid" type="property" display="lShowInGrid" />] + ;
		[<memberdata name="lrequired" type="property" display="lRequired" />] + ;
		[<memberdata name="ckeyname" type="property" display="cKeyName" />] + ;
		[<memberdata name="ckeyname_access" type="method" display="cKeyName_Access" />] + ;
		[<memberdata name="ngridorder" type="property" display="nGridOrder" />] + ;
		[<memberdata name="lfitcolumn" type="property" display="lFitColumn" />] + ;
		[<memberdata name="lorderbythis" type="property" display="lOrderByThis" />] + ;
		[<memberdata name="lislogical" type="property" display="lIsLogical" />] + ;
		[<memberdata name="lissystem" type="property" display="lIsSystem" />] + ;
		[<memberdata name="lshowinnavigator" type="property" display="lShowInNavigator" />] + ;
		[<memberdata name="ocurrentcontrol" type="property" display="oCurrentControl" />] + ;
		[<memberdata name="ocurrentcontrol_assign" type="method" display="oCurrentControl_Assign" />] + ;
		[</VFPData>]


	*
	* Devuelve si es del mismo tipo de datos
	Procedure IsType( tcFieldType As Character ) As Boolean;
			HELPSTRING "Devuelve si es del mismo tipo de datos"
		Local lcCommand As String
		Local llReturn As Boolean

		Try

			lcCommand = ""

			Do Case
				Case Inlist( Lower( tcFieldType ), "w", "blob" )
					llReturn = ( This.FieldType = "blob" )

				Case Inlist( Lower( tcFieldType ), "c", "char", "character" )
					llReturn = ( This.FieldType = "character" )

				Case Inlist( Lower( tcFieldType ), "y", "currency", "money" )
					llReturn = ( This.FieldType = "currency" )

				Case Inlist( Lower( tcFieldType ), "t", "datetime" )
					llReturn = ( This.FieldType = "datetime" )

				Case Inlist( Lower( tcFieldType ), "d", "date" )
					llReturn = ( This.FieldType = "date" )

				Case Inlist( Lower( tcFieldType ), "g", "general" )
					llReturn = ( This.FieldType = "general" )

				Case Inlist( Lower( tcFieldType ), "i", "int", "integer", "long" )
					llReturn = ( This.FieldType = "integer" )
					If !llReturn And This.FieldType = "numeric" And This.FieldPrecision = 0
						llReturn = .T.
					Endif

				Case Inlist( Lower( tcFieldType ), "l", "logical", "boolean", "bit" )
					llReturn = ( This.FieldType = "integer" Or This.FieldType = "logical" )

				Case Inlist( Lower( tcFieldType ), "m", "memo" )
					llReturn = ( This.FieldType = "memo" )

				Case Inlist( Lower( tcFieldType ), "n", "num", "numeric" )
					llReturn = ( This.FieldType = "numeric" )

				Case Inlist( Lower( tcFieldType ), "f", "float" )
					llReturn = ( This.FieldType = "float" )

				Case Inlist( Lower( tcFieldType ), "q", "varbinary" )
					llReturn = ( This.FieldType = "varbinary" )

				Case Inlist( Lower( tcFieldType ), "v", "varchar" )
					llReturn = ( This.FieldType = "varchar" )

				Case Inlist( Lower( tcFieldType ), "b", "double" )
					llReturn = ( This.FieldType = "double" )

				Otherwise
					llReturn = .F.

			Endcase

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llReturn

	Endproc && IsType




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CurrentTagName_Access
	*!* Date..........: Jueves 20 de Agosto de 2009 (17:11:01)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure CurrentTagName_Access()
		If Empty( This.CurrentTagName )
			This.CurrentTagName = Sys( 2015 )

		Endif && Empty( This.CurrentTagName )

		Return This.CurrentTagName

	Endproc && CurrentTagName_Access

	*
	* cStatusBarText_Access
	Protected Procedure cStatusBarText_Access()

		If Empty( This.cStatusBarText )
			This.cStatusBarText = This.cToolTipText
		Endif
		Return This.cStatusBarText

	Endproc && cStatusBarText_Access


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: DisplayClassLibrary_Assign
	*!* Date..........: Sábado 19 de Julio de 2008 (11:48:25)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure DisplayClassLibrary_Assign( uNewValue )

		If IsRuntime()
			uNewValue = ""

		Else
			If !Empty( uNewValue )
				If Upper( Justext( uNewValue )) <> "VCX"
					uNewValue = uNewValue + ".vcx"
				Endif

			Endif

		Endif

		This.DisplayClassLibrary = uNewValue

	Endproc
	*!*
	*!* END PROCEDURE DisplayClassLibrary_Assign
	*!*
	*!* ///////////////////////////////////////////////////////

	*
	* cKeyName_Access
	Protected Procedure cKeyName_Access()

		If Empty( This.cKeyName )
			This.cKeyName = This.Caption
		Endif

		Return This.cKeyName

	Endproc && cKeyName_Access


	*
	* Caption_Access
	Protected Procedure Caption_Access()

		If Empty( This.cCaption )
			This.cCaption = This.Name
		Endif

		Return This.cCaption

	Endproc && Caption_Access


	* Caption_Assign

	Protected Procedure Caption_Assign( uNewValue )

		This.Caption = uNewValue
		This.cCaption = uNewValue

	Endproc && Caption_Assign

	*
	* cReferenceCaption_Access
	Protected Procedure cReferenceCaption_Access()

		If Empty( This.cReferenceCaption )
			This.cReferenceCaption = This.cCaption
		Endif

		Return This.cReferenceCaption

	Endproc && cReferenceCaption_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Print
	*!* Description...: Imprime la definición del campo
	*!* Date..........: Viernes 11 de Abril de 2008 (14:15:13)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Print( cFileName As String ) As Void;
			HELPSTRING "Imprime la definición del campo"

		Local llTag As Boolean

		Try

			llTag = .F.

			Strtofile( CR + Padr( This.Name, 40, " "), cFileName, 1 )

			Strtofile( Tab + This.FieldType, cFileName, 1 )

			If !Empty( This.FieldWidth )
				Strtofile( " (" + Any2Char( This.FieldWidth ), cFileName, 1 )

				If !Empty( This.FieldPrecision )
					Strtofile( ", " + Any2Char( This.FieldPrecision ) + ")", cFileName, 1 )

				Else
					Strtofile( ")" , cFileName, 1 )

				Endif

			Endif

			If Lower( This.Caption ) # Lower( This.Name )
				Strtofile( Tab + "[" + This.Caption + "]", cFileName, 1 )
			Endif

			If This.Autoinc
				Strtofile( Tab + "Autoinc", cFileName, 1 )
			Endif

			If !Empty( This.Check )
				Strtofile( CR + Tab + "Check: " + This.Check, cFileName, 1 )
				llTag = .T.
			Endif


			If !Empty( This.Format ) Or !Empty( This.InputMask )
				Strtofile( CR + Tab, cFileName, 1 )
				If !Empty( This.Format )
					Strtofile( "Format: " + This.Format + " ", cFileName, 1 )
				Endif

				If !Empty( This.InputMask )
					Strtofile( "InputMask: " + This.InputMask, cFileName, 1 )
				Endif

				llTag = .T.
			Endif

			If ! Empty( This.References )
				Strtofile( CR + Tab + "References: " + This.References, cFileName, 1 )
				llTag = .T.

			Endif && ! Empty( This.References )

			If This.TriggerConditionForDelete # ".T."
				Strtofile( CR + Tab + "Trigger Condition For Delete: '" + This.TriggerConditionForDelete + "'", cFileName, 1 )
				llTag = .T.

			Endif && This.TriggerConditionForDelete # ".T."

			If This.TriggerConditionForInsert # ".T."
				Strtofile( CR + Tab + "Trigger Condition For Insert: '" + This.TriggerConditionForInsert + "'", cFileName, 1 )
				llTag = .T.

			Endif && This.TriggerConditionForInsert # ".T."

			If This.TriggerConditionForUpdate # ".T."
				Strtofile( CR + Tab + "Trigger Condition For Update: '" + This.TriggerConditionForUpdate + "'", cFileName, 1 )
				llTag = .T.

			Endif && This.TriggerConditionForUpdate # ".T."

			If ! Empty( This.Comment )
				Strtofile( CR + Tab + "Comment: " + This.Comment, cFileName, 1 )
				llTag = .T.

			Endif && ! Empty( This.Comment )

			Strtofile( CR, cFileName, 1 )

		Catch To oErr
			Throw oErr

		Finally
			loTable = Null
			loField = Null

		Endtry

	Endproc && Print

	*
	* References_Access
	Protected Procedure References_Access()

		Local lcCommand As String

		Try

			lcCommand = ""

			If Empty( This.cReferences )
				If !Empty( This.cParentKeyName )
					Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"

					loTable = This.oParent.oParent.oColTables.GetItem( This.cParentKeyName )
					This.cReferences = loTable.Name

				Endif
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTable = Null

		Endtry

		Return This.cReferences

	Endproc && cParentKeyName_Access

	* References_Assign

	Protected Procedure References_Assign( uNewValue )

		This.References = uNewValue
		This.cReferences = uNewValue

	Endproc && References_Assign

	*
	* GetWhereStatement
	* Devuelve la condición de búsqueda asociada al controls
	Procedure GetWhereStatement( tcValue As String )

		Local lcWhere As String
		Local llOk As Boolean
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			llOk = .T.
			lcWhere = ""

			If llOk
				If ! Inlist( This.FieldType, "Character", "Integer", "Memo", "Numeric", "Float", "VarChar", "Double" )
					Assert .F. Message "No se reconoce el tipo " + This.FieldType + " para la búsqueda rápida"
					llOk = .F.

				Endif &&  ! Inlist( This.FieldType, "Character", "Integer", "Memo", "Numeric", "Float", "VarChar", "Double" )

				If ! Inlist( This.cSearchCondition, "like", "%", "!#" )
					Assert .F. Message "No se reconoce la condicion de búsqueda " + This.cSearchCondition + " para la búsqueda rápida"
					llOk = .F.

				Endif && ! Inlist( This.cSearchCondition, "like", "%", "!#" )

			Endif && llOk

			If llOk
				tcValue = Alltrim( tcValue )
				If Isalpha( tcValue ) And  Inlist( This.FieldType, "Integer", "Numeric", "Float", "Double" )
					lcWhere = ' Or 1 = 0 '

				Else
					lcTableName = This.oParent.Name

					If Inlist( This.FieldType, "Character", "Memo", "VarChar" )
						lcFieldName = " lower(" + lcTableName + "." + This.Name + ")"
						tcValue = ['] + Lower( tcValue ) + [']

					Else
						lcFieldName = lcTableName + "."  + This.Name

					Endif && Inlist( This.FieldType, "Character", "Memo", "VarChar" )

					lcWhere = " Or (" + lcFieldName

					Do Case
						Case This.cSearchCondition = "like"
							lcWhere = lcWhere + " like '" + Strtran( tcValue, "'", "" ) + "%'"

						Case This.cSearchCondition = "%"
							lcWhere = lcWhere + " like '%" + Strtran( tcValue, "'", "" ) + "%'"

						Case This.cSearchCondition = "!#"
							lcWhere = lcWhere + " = " + tcValue

					Endcase

					lcWhere = lcWhere + ")"

				Endif && Isalpha( tcValue ) And  Inlist( This.FieldType, "Integer", "Numeric", "Float", "Double" )

			Endif && llOk

		Catch To oErr
			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

		Return lcWhere

	Endproc && GetWhereStatement


	Protected Procedure oCurrentControl_Access

		Local lcCommand As String

		Try

			lcCommand = ""

			If Isnull( This.oCurrentControl )
				Local loCurrentControl As Object
				loCurrentControl = Createobject( "Empty" )
				AddProperty( loCurrentControl, "Name" )
				AddProperty( loCurrentControl, "Class" )

				This.oCurrentControl = loCurrentControl
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loCurrentControl = Null

		Endtry

		Return This.oCurrentControl

	Endproc && oCurrentControl_Access


Enddefine && oField

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColIndexes
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Indices
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColIndexes As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	#If .F.
		Local This As ColIndexes Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="addindex" type="event" display="AddIndex" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddIndex
	*!* Description...: Agrega un Campo a la colección ColFields
	*!* Date..........: Martes 29 de Mayo de 2007 (11:04:54)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure AddIndex( toIndex As oField Of "Tools\Sincronizador\ColDataBases.prg") As Void;
			HELPSTRING "Agrega un Indice a la colección ColIndexes"

		Local i As Integer
		Local lcKey As String

		toIndex.oParent = This.oParent

		lcKey = Lower( toIndex.Name )
		i = This.GetKey( lcKey )

		If Empty( i )
			This.AddItem( toIndex, lcKey )

		Endif


	Endproc && AddIndex

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oIndex vacío
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure New( cName As String ) As oIndex Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oIndex vacío"

		Local loIndex As Object

		loIndex = Createobject("oIndex")
		If !Empty( cName )
			loIndex.TagName = Alltrim( cName )
			This.AddIndex( loIndex )
		Endif

		Return loIndex


	Endproc && New

Enddefine && ColIndexes

*!* ///////////////////////////////////////////////////////
*!* Class.........: oIndex
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Indice
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oIndex As SessionBase

	#If .F.
		Local This As oIndex Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	DataSession = SET_DEFAULT

	*!* Indica el tipo de Indice. (Definido en ta.h)
	KeyType = IK_NOKEY

	*!* Expresion para generar el indice
	KeyExpression = ""

	*!* Condicion de filtro
	ForExpression = ""

	*!* Nombre de la etiqueta de indice
	TagName = ""

	*!*
	Collate = "SPANISH"

	*!* Referencia a la tabla padre
	References = ""

	*!* Etiqueta de indices correspondiente a la tabla padre
	ParentTagName = ""

	*!* Condición a cumplir para que se dispare el trigger
	TriggerConditionForInsert = ".T."
	*!* Condición a cumplir para que se dispare el trigger
	TriggerConditionForUpdate = ".T."
	*!* Condición a cumplir para que se dispare el trigger
	TriggerConditionForDelete = ".T."

	*!* Nombre de la clave de la tabla padre
	ParentPk = ''

	* Clave de acceso a la tabla externa de una FK
	cParentKeyName = ""

	* Comando a ejecutar para crear el índice
	cCommand = ""


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ccommand" type="property" display="cCommand" />] + ;
		[<memberdata name="cparentkeyname" type="property" display="cParentKeyName" />] + ;
		[<memberdata name="parenttagname" type="property" display="ParentTagName" />] + ;
		[<memberdata name="references" type="property" display="References" />] + ;
		[<memberdata name="collate" type="property" display="Collate" />] + ;
		[<memberdata name="tagname" type="property" display="TagName" />] + ;
		[<memberdata name="forexpression" type="property" display="ForExpression" />] + ;
		[<memberdata name="keyexpression" type="property" display="KeyExpression" />] + ;
		[<memberdata name="keytype" type="property" display="KeyType" />] + ;
		[<memberdata name="triggerconditionforinsert" type="property" display="TriggerConditionForInsert" />] + ;
		[<memberdata name="triggerconditionforupdate" type="property" display="TriggerConditionForUpdate" />] + ;
		[<memberdata name="triggerconditionfordelete" type="property" display="TriggerConditionForDelete" />] + ;
		[<memberdata name="parentpk" type="property" display="ParentPk" />] + ;
		[</VFPData>]

	*
	* ParentTagName_Access
	Procedure ParentTagName_Access()

		Local loParentTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		*!*	Local loColTables As colTables Of "Tools\Sincronizador\ColDataBases.prg"
		*!*	Local loColFields As ColFields Of "Tools\Sincronizador\ColDataBases.prg"
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loData As oDataBase Of "Tools\Sincronizador\ColDataBases.prg"

		Local lcCommand As String

		Try


			lcCommand = ""

			If Empty( This.ParentTagName )

				If !Empty( This.References )
					*!* loColFields = This.oParent
					*!* loColTables = loColFields.oParent.oParent
					*!* loParentTable = loColTables.GetItem( This.References )

					lcCommand = "This.References : " + This.References

					loTable = This.oParent
					loData = loTable.oParent
					Assert Vartype( loData ) = 'O' Message 'loData no es un objeto'

					loParentTable = loData.oColTables.GetItem( This.References )
					*loParentTable = loData.oColTables.GetItem( This.cParentKeyName )

					Assert Vartype( loParentTable ) = 'O' Message 'loParentTable no es un objeto'

					This.ParentTagName = loParentTable.GetPrimaryTagName()

					*!*						If Upper( Substr( This.ParentTagName, 1, 2 ) ) # "PK"
					*!*							This.ParentTagName = ""
					*!*						Endif

				Endif

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError


		Finally


		Endtry

		Return This.ParentTagName

	Endproc && ParentTagName_Access

	*
	* cParentKeyName_Access
	Protected Procedure cParentKeyName_Access()
		If Empty( This.cParentKeyName )
			This.cParentKeyName = Strtran( Lower( This.References ), "sys_", "" )
		Endif

		Return This.cParentKeyName

	Endproc && cParentKeyName_Access


Enddefine && oIndex
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColTriggers
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Indices
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColTriggers As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	#If .F.
		Local This As ColTriggers Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!* Nombre de la tabla
	tablename = ""

	*!* Nombre del SP de Integridad Referencial que se creará
	IRName = ""

	*!* Tipo de Trigger
	TriggerType = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="triggertype" type="property" display="TriggerType" />] + ;
		[<memberdata name="irname" type="property" display="IRName" />] + ;
		[<memberdata name="tablename" type="property" display="TableName" />] + ;
		[<memberdata name="delete" type="method" display="Delete" />] + ;
		[<memberdata name="create" type="method" display="Create" />] + ;
		[<memberdata name="addtrigger" type="event" display="AddTrigger" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddTrigger
	*!* Description...: Agrega un Campo a la colección ColFields
	*!* Date..........: Martes 29 de Mayo de 2007 (11:04:54)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure AddTrigger( toTrigger As oTrigger Of "Tools\Sincronizador\ColDataBases.prg") As Void;
			HELPSTRING "Agrega un Trigger a la colección ColTriggers"


		Local i As Integer
		Local lcKey As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			toTrigger.oParent = This.oParent
			lcKey = Lower( toTrigger.Name )
			i = This.GetKey( lcKey )

			If Empty( i )
				This.AddItem( toTrigger, lcKey )

			Endif

		Catch To oErr

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			oErr.Message = oErr.Message + Chr(13) + Lower(toTrigger.Name)
			loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry
	Endproc && AddTrigger

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oTrigger vacío
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure New( ) As oTrigger Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oTrigger vacío"

	Endproc && New

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Create
	*!* Description...: Crea un Trigger
	*!* Date..........: Jueves 31 de Mayo de 2007 (11:36:43)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Create( ) As Void;
			HELPSTRING "Crea un Trigger"

		Local lcCommand As String
		Try

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Trigger On <<This.TableName>>
			For <<This.TriggerType>> As
			<<This.IRName>>
			ENDTEXT

			&lcCommand

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			oErr.Message = oErr.Message + Chr(13) + lcCommand
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE Create
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Delete
	*!* Description...: Borra un Trigger
	*!* Date..........: Jueves 31 de Mayo de 2007 (11:37:08)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Delete( ) As Void;
			HELPSTRING "Borra un Trigger"

		Local lcCommand As String
		Try

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Delete Trigger On <<This.TableName>>
			For <<This.TriggerType>>
			ENDTEXT

			&lcCommand

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			oErr.Message = oErr.Message + Chr(13) + lcCommand
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry


	Endproc
	*!*
	*!* END PROCEDURE Delete
	*!*
	*!* ///////////////////////////////////////////////////////


Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColTriggers
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColUpdateTriggers
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Colección de Indices
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColUpdateTriggers As ColTriggers Of "Tools\Sincronizador\ColDataBases.prg"

	#If .F.
		Local This As ColUpdateTriggers Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	TriggerType = "Update"

	Procedure New( cName As String ) As oTrigger Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oTrigger vacío"

		Local loTrigger As Object

		loTrigger = Createobject("oUpdateTrigger")

		If !Empty( cName )
			loTrigger.Name = Alltrim( cName )
			This.AddTrigger( loTrigger )
		Endif

		Return loTrigger

	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColUpdateTriggers
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColInsertTriggers
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Colección de Indices
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColInsertTriggers As ColTriggers Of "Tools\Sincronizador\ColDataBases.prg"

	#If .F.
		Local This As ColInsertTriggers Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	TriggerType = "Insert"

	Procedure New( cName As String ) As oTrigger Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oTrigger vacío"

		Local loTrigger As Object

		loTrigger = Createobject("oInsertTrigger")
		If !Empty( cName )
			loTrigger.Name = Alltrim( cName )
			This.AddTrigger( loTrigger )
		Endif

		Return loTrigger

	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColInsertTriggers
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColDeleteTriggers
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Colección de Indices
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColDeleteTriggers As ColTriggers Of "Tools\Sincronizador\ColDataBases.prg"

	#If .F.
		Local This As ColDeleteTriggers Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	TriggerType = "Delete"

	Procedure New( cName As String ) As oTrigger Of "Tools\Sincronizador\ColDataBases.prg";
			HELPSTRING "Obtiene un elemento oTrigger vacío"

		Local loTrigger As Object

		loTrigger = Createobject("oDeleteTrigger")
		If !Empty( cName )
			loTrigger.Name = Alltrim( cName )
			This.AddTrigger( loTrigger )
		Endif

		Return loTrigger

	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColDeleteTriggers
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oTrigger
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Trigger
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oTrigger As SessionBase

	#If .F.
		Local This As oTrigger Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	DataSession = SET_DEFAULT

	*!* Nombre de la Tabla Padre
	ParentTable = ""

	*!* Nombre de tabla Hija
	ChildTable = ""

	*!* Referencia a la tabla padre
	References = ""

	*!* Expresion a cumplir
	ChildKeyExpression = ""

	*!* Nombre de la Primary Key de la tabla hija
	ChildPK = ""
	*!* Nombre de la Primary Key de la tabla Padre
	ParentPk = ""

	*!*
	ChildForeignKey = ""

	*!* Nombre de la etiqueta de indices de la tabla hija
	ChildTagName = ""
	*!* Nombre de la etiqueta de indices de la tabla padre
	ParentTagName = ""

	*!* Condición a cumplir para que se dispare el trigger
	TriggerConditionForInsert = ".T."
	*!* Condición a cumplir para que se dispare el trigger
	TriggerConditionForUpdate = ".T."
	*!* Condición a cumplir para que se dispare el trigger
	TriggerConditionForDelete = ".T."

	* Clave de acceso a la tabla externa de una FK
	cParentKeyName = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cparentkeyname" type="property" display="cParentKeyName" />] + ;
		[<memberdata name="parenttagname" type="property" display="ParentTagName" />] + ;
		[<memberdata name="childtagname" type="property" display="ChildTagName" />] + ;
		[<memberdata name="childforeignkey" type="property" display="ChildForeignKey" />] + ;
		[<memberdata name="parenttable" type="property" display="ParentTable" />] + ;
		[<memberdata name="childkeyexpression" type="property" display="ChildKeyExpression" />] + ;
		[<memberdata name="childtable" type="property" display="ChildTable" />] + ;
		[<memberdata name="create" type="method" display="Create" />] + ;
		[<memberdata name="parentpk" type="property" display="ParentPK" />] + ;
		[<memberdata name="childpk" type="property" display="ChildPK" />] + ;
		[<memberdata name="triggerconditionforinsert" type="property" display="TriggerConditionForInsert" />] + ;
		[<memberdata name="triggerconditionforupdate" type="property" display="TriggerConditionForUpdate" />] + ;
		[<memberdata name="triggerconditionfordelete" type="property" display="TriggerConditionForDelete" />] + ;
		[</VFPData>]


	Procedure Create()
	Endproc

	*
	* ParentTagName_Access
	Procedure ParentTagName_Access()

		Local loParentTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		*!*	Local loColTables As colTables Of "Tools\Sincronizador\ColDataBases.prg"
		*!*	Local loColFields As ColFields Of "Tools\Sincronizador\ColDataBases.prg"
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loData As oDataBase Of "Tools\Sincronizador\ColDataBases.prg"
		Local lcCommand As String

		Try

			lcCommand = ""


			If Empty( This.ParentTagName )

				If !Empty( This.References )

					*!*	loColFields = This.oParent
					*!*	loColTables = loColFields.oParent.oParent
					*!*	loParentTable = loColTables.GetItem( This.References )

					loTable = This.oParent
					loData = loTable.oParent
					Assert Vartype( loData ) = 'O' Message 'loData no es un objeto'

					*!*					loParentTable = loData.oColTables.GetItem( This.References )
					loParentTable = loData.oColTables.GetItem( This.cParentKeyName )

					This.ParentTagName = loParentTable.GetPrimaryTagName()

					If Upper( Substr( This.ParentTagName, 1, 2 ) ) # "PK"
						This.ParentTagName = ""
					Endif

				Endif

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry
		Return This.ParentTagName

	Endproc && ParentTagName_Access


	*
	* cParentKeyName_Access
	Protected Procedure cParentKeyName_Access()
		If Empty( This.cParentKeyName )
			This.cParentKeyName = Strtran( Lower( This.References ), "sys_", "" )
		Endif

		Return This.cParentKeyName

	Endproc && cParentKeyName_Access

Enddefine && oTrigger

*!* ///////////////////////////////////////////////////////
*!* Class.........: oUpdateTrigger
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Clase Trigger
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oUpdateTrigger As oTrigger Of "Tools\Sincronizador\ColDataBases.prg"

	#If .F.
		Local This As oUpdateTrigger Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Create
	*!* Description...: Crea un trigger para Update
	*!* Date..........: Jueves 31 de Mayo de 2007 (13:15:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Create( tcTriggerFile As String ) As Void;
			HELPSTRING "Crea un trigger para Update"

		Local lcCommand As String
		Local laTagInfo[1]
		Local i As Integer,;
			lnLen As Integer
		Local lcCmd As String
		Try

			* Abrir la tabla padre
			* Use In Select( Alias( This.ParentTable ) )
			If Used( This.ParentTable )
				Use In Alias( This.ParentTable )
			Endif
			TEXT To lccmd NoShow TextMerge Pretext 15
	            Use '<<Alltrim(This.ParentTable)>>' Exclusive In 0
			ENDTEXT
			This.ReTryCommand( lcCmd, 10, 1705 )

			If Empty( This.ParentPk )
				lnLen = Ataginfo( laTagInfo, This.ParentTable, This.ParentTable )

				For i = 1 To lnLen

					If Lower( laTagInfo[ i, 2 ] ) = Lower( "Primary" ) Or ;
							Lower( laTagInfo[ i, 2 ] ) = Lower( "Principal" )
						This.ParentPk = Proper( laTagInfo[ i, 3 ] )
					Endif
				Endfor
			Endif

			TEXT To lcCommand NoShow TextMerge


*!* ///////////////////////////////////////////////////////
*!* Procedure.....: <<This.Name>>
*!* Description...: Update Trigger for <<This.ChildTable>>
*!* -------------------------------------------------------
*!*
*!*

Procedure <<This.Name>>
	Local llOk As Boolean
	Local lcAlias As String
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	Local Array lAFields[ 1 ]
	Local i as Integer
	Local luForeignKey as Variant
	LOCAL lcTblAlias as String

	Try

		If <<This.TriggerConditionForUpdate>>

			luForeignKey = <<This.ChildForeignKey>>

			If Oldval( '<<This.ChildForeignKey>>' ) # luForeignKey
				lcTblAlias = GetTableAlias( "<<This.ParentTable>>" )
				llOk = Indexseek( luForeignKey, .F., lcTblAlias, "<<This.ParentTagName>>" )

			Else
				llOk = .T.

			EndIf

		Else
			llOk = .T.

		EndIf

		If ! llOk
			If IsRuntime()
				Error "No es posible actualizar el registro" + Chr( 13 ) + ;
					"Proceso Cancelado"

			Else
				Error "Error al Actualizar en Tabla <<This.ChildTable>> " +;
				"No existe la referencia en la tabla <<This.ParentTable>>"

			EndIf

		EndIf

	Catch To oErr
		llOk = .F.
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		If ! IsRuntime()

			If Used( '<<This.ChildTable>>' )
				loError.Ctracelogin = '<<This.ChildTable>>' + Chr( 13 )
				For i = 1 To AFields( lAFields, '<<This.ChildTable>>' )
					loError.Ctracelogin = loError.Ctracelogin + lAFields[ i, 1 ] + '(' + lAFields[ i, 2 ] + ')'
					Try
						loError.Ctracelogin = loError.Ctracelogin + Transform( Evaluate( '<<This.ChildTable>>.' + lAFields[ i, 1 ] ) )
					Catch To oErr
					EndTry
					loError.Ctracelogin = loError.Ctracelogin + Chr( 13 )

				EndFor
			EndIf
		EndIf

		pcXMLError = loError.Process( oErr )


	Finally

	EndTry

	Return llOk

EndProc && <<This.Name>>

			ENDTEXT

			Strtofile( lcCommand + CR, tcTriggerFile, 1 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally
			If Used( This.ChildTable )
				Use In Alias( This.ChildTable )
			Endif


			If Used( This.ParentTable )
				Use In Alias( This.ParentTable )
			Endif

		Endtry


	Endproc && Create

Enddefine && oUpdateTrigger

*!* ///////////////////////////////////////////////////////
*!* Class.........: oInsertTrigger
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Clase Trigger
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oInsertTrigger As oTrigger Of "Tools\Sincronizador\ColDataBases.prg"

	#If .F.
		Local This As oInsertTrigger Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Create
	*!* Description...: Crea un trigger para Insert
	*!* Date..........: Jueves 31 de Mayo de 2007 (13:15:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Create( tcTriggerFile As String ) As Void;
			HELPSTRING "Crea un trigger para Insert"

		Local lcCommand As String
		Local laTagInfo[1]
		Local i As Integer,;
			lnLen As Integer
		Local lcCmd As String
		Try
			* Abrir la tabla padre
			* Use In Select( Alias( This.ParentTable ) )
			If Used( This.ParentTable )
				Use In Alias( This.ParentTable )
			Endif
			TEXT To lccmd NoShow TextMerge Pretext 15
	            Use '<<Alltrim(This.ParentTable)>>' Exclusive In 0
			ENDTEXT
			This.ReTryCommand( lcCmd, 10, 1705 )

			If Empty( This.ParentPk )
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lnLen = Ataginfo( laTagInfo, '<<This.ParentTable>>', '<<This.ParentTable>>' )
				ENDTEXT



				lnLen = Ataginfo( laTagInfo, This.ParentTable, This.ParentTable )

				For i = 1 To lnLen
					If Lower( laTagInfo[ i, 2 ] ) = Lower( "Primary" ) Or ;
							Lower( laTagInfo[ i, 2 ] ) = Lower( "Principal" )

						This.ParentPk = Proper( laTagInfo[ i, 3 ])
					Endif
				Endfor
			Endif

			TEXT To lcCommand NoShow TextMerge


*!* ///////////////////////////////////////////////////////
*!* Procedure.....: <<This.Name>>
*!* Description...: Insert Trigger for <<This.ChildTable>>
*!* -------------------------------------------------------
*!*
*!*

Procedure <<This.Name>>
	Local llOk As Boolean
	Local lcAlias As String
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	Local Array lAFields[ 1 ]
	Local i as Integer
	Local luForeignKey as Variant
	Local lcTblAlias as String

	Try

		If <<This.TriggerConditionForInsert>>
			luForeignKey = <<This.ChildForeignKey>>
			lcTblAlias = GetTableAlias( "<<This.ParentTable>>" )
			llOk = Indexseek( luForeignKey, .F., lcTblAlias, "<<This.ParentTagName>>" )

		Else
			llOk = .T.

		EndIf

		If ! llOk
			If IsRuntime()
				Error "No es posible agregar el registro" + Chr( 13 ) + ;
					"Proceso Cancelado"

			Else
				Error "Error al Insertar en Tabla <<This.ChildTable>> " +;
				"No existe la referencia en la tabla <<This.ParentTable>>"

			EndIf

		EndIf

	Catch To oErr
		llOk = .F.
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		If ! IsRuntime()
			If Used( '<<This.ChildTable>>' )
				loError.Ctracelogin = '<<This.ChildTable>>' + Chr( 13 )
				For i = 1 To AFields( lAFields, '<<This.ChildTable>>' )
					loError.Ctracelogin = loError.Ctracelogin + lAFields[ i, 1 ] + '(' + lAFields[ i, 2 ] + ')'
					Try
						loError.Ctracelogin = loError.Ctracelogin + Transform( Evaluate( '<<This.ChildTable>>.' + lAFields[ i, 1 ] ) )
					Catch To oErr
					EndTry
					loError.Ctracelogin = loError.Ctracelogin + Chr( 13 )

				EndFor
			EndIf

   		EndIf
		pcXMLError = loError.Process( oErr )

	Finally

	EndTry

	Return llOk

EndProc && <<This.Name>>

			ENDTEXT

			Strtofile( lcCommand + CR , tcTriggerFile, 1 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError


		Finally
			If Used( This.ChildTable )
				Use In Alias( This.ChildTable )
			Endif


			If Used( This.ParentTable )
				Use In Alias( This.ParentTable )
			Endif

		Endtry


	Endproc && Create


Enddefine && oInsertTrigger

*!* ///////////////////////////////////////////////////////
*!* Class.........: oDeleteTrigger
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Clase Trigger
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oDeleteTrigger As oTrigger Of "Tools\Sincronizador\ColDataBases.prg"

	#If .F.
		Local This As oDeleteTrigger Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Create
	*!* Description...: Crea un trigger para delete
	*!* Date..........: Jueves 31 de Mayo de 2007 (13:15:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure Create( tcTriggerFile As String ) As Void;
			HELPSTRING "Crea un trigger para delete"

		Local lcCommand As String
		Local laTagInfo[1]
		Local i As Integer,;
			lnLen As Integer
		Local lcCmd As String
		Try

			* Abrir la tabla padre
			* Use In Select( Alias( This.ParentTable ) )
			If Used( This.ParentTable )
				Use In Alias( This.ParentTable )
			Endif
			TEXT To lccmd NoShow TextMerge Pretext 15
	            Use '<<Alltrim(This.ParentTable)>>' Exclusive In 0
			ENDTEXT
			This.ReTryCommand( lcCmd, 10, 1705 )

			If Empty( This.ParentPk )
				lnLen = Ataginfo( laTagInfo, This.ParentTable, This.ParentTable )

				For i = 1 To lnLen
					If Lower( laTagInfo[ i, 2 ] ) = Lower( "Primary" ) Or ;
							Lower( laTagInfo[ i, 2 ] ) = Lower( "Principal" )

						This.ParentPk = Proper( laTagInfo[ i, 3 ] )
					Endif
				Endfor
			Endif

			TEXT To lcCommand NoShow TextMerge


*!* ///////////////////////////////////////////////////////
*!* Procedure.....: <<This.Name>>
*!* Description...: Delete Trigger for <<This.ParentTable>>
*!* -------------------------------------------------------
*!*
*!*

Procedure <<This.Name>>
	Local llOk As Boolean
	Local lcAlias As String
	Local lcOldDeleted as String
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	Local Array lAFields[ 1 ]
	Local i as Integer
	Local luParentKey as Variant
	Local lcTblAlias as String

	Try

		lcOldDeleted = Set("Deleted")

		If <<This.TriggerConditionForDelete>>

			Set Deleted ON

			*!*	luParentKey = <<This.ParentTable>>.<<This.ParentPK>>
			luParentKey = <<This.ParentPK>>

			*!*	If !Used( "Temp_<<This.ChildTable>>" )
			*!*		Use <<This.ChildTable>> In 0 Shared Again Alias Temp_<<This.ChildTable>>
			*!*	EndIf

			*!*	llOk = ! Indexseek( luParentKey, .F., "Temp_<<This.ChildTable>>", "<<This.ChildTagName>>" )
			lcTblAlias = GetTableAlias( "<<This.ChildTable>>" )
			llOk = ! Indexseek( luParentKey, .F., lcTblAlias, "<<This.ChildTagName>>" )

		Else
			llOk = .T.

		EndIf

		If ! llOk
			If IsRuntime()
				Error "No es posible eliminar el registro" + Chr( 13 ) + ;
					"Proceso Cancelado"

			Else
				Error "No se permite Eliminar en Tabla <<This.ParentTable>> " +;
				"Existe una referencia en la tabla <<This.ChildTable>>"

			EndIf
		EndIf

	Catch To oErr
		llOk = .F.
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		If ! IsRuntime()
			If Used( '<<This.ParentTable>>' )
				loError.Ctracelogin = '<<This.ParentTable>>' + Chr( 13 )
				For i = 1 To AFields( lAFields, '<<This.ParentTable>>' )
					loError.Ctracelogin = loError.Ctracelogin + lAFields[ i, 1 ] + '(' + lAFields[ i, 2 ] + ')'
					Try
						loError.Ctracelogin = loError.Ctracelogin + Transform( Evaluate( '<<This.ParentTable>>.' + lAFields[ i, 1 ] ) )
					Catch To oErr
					EndTry
					loError.Ctracelogin = loError.Ctracelogin + Chr( 13 )

				EndFor
			EndIf
    	EndIf
		pcXMLError = loError.Process( oErr )


	Finally
		Set Deleted &lcOldDeleted

	EndTry

	Return llOk

EndProc && <<This.Name>>

			ENDTEXT

			Strtofile( lcCommand + CR, tcTriggerFile, 1 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally
			If Used( This.ChildTable )
				Use In Alias( This.ChildTable )
			Endif


			If Used( This.ParentTable )
				Use In Alias( This.ParentTable )
			Endif

		Endtry


	Endproc
	*!*
	*!* END PROCEDURE Create
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oDeleteTrigger
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColProperties
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Indices
*!* Date..........: Martes 10 de Febrero de 2009 (11:00:34)
*!* Author........: Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColProperties As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	#If .F.
		Local This As ColProperties Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oTrigger vacío
	*!* Date..........: Martes 10 de Febrero de 2009 (11:13:53)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure New( cName As String ) As Object ;
			HelpString "Obtiene un elemento Object vacío"

		Local loObj As oProperty Of Tools\Sincronizador\ColDataBases.prg
		Local i As Integer

		Try
			i = This.GetKey( cName )
			If Empty( i )
				loObj = Newobject( 'oProperty', 'Tools\Sincronizador\coldatabases.prg' )
				* AddProperty( loObj, 'Name', cName )
				loObj.Name = cName
				* AddProperty( loObj, 'Value' )
				* AddProperty( loObj, 'TierLevel', )
				This.AddItem( loObj, cName )
			Endif
		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError
		Finally
		Endtry

		Return loObj
	Endproc
	*!*
	*!* END PROCEDURE New
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColProperties
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oProperty
*!* ParentClass...: SessionBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Indices
*!* Date..........: Martes 10 de Febrero de 2009 (11:00:34)
*!* Author........: Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oProperty As SessionBase Of "Tools\Sincronizador\colDataBases.prg"

	#If .F.
		Local This As oProperty Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!* Valor de la propiedad
	Value = ''
	*!*
	nTierLevel = 1

	*!* Indica si hay que agregar comillas al valor de la propedad
	lAddQuotes = .F.

	*!* Indica si la propiedad se agrega como un comentario ( plantilla para el desarrollador)
	lAddComment = .F.

	*!* Agrega un retorno de carro al final de la definición de la propiedad @see ToString
	lCarriageReturn = .T.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="value" type="property" display="Value" />] + ;
		[<memberdata name="ntierlevel" type="property" display="nTierLevel" />] + ;
		[<memberdata name="laddquotes" type="property" display="lAddQuotes" />] + ;
		[<memberdata name="laddcomment" type="property" display="lAddComment" />] + ;
		[<memberdata name="tostring" type="method" display="ToString" />] + ;
		[<memberdata name="lcarriagereturn" type="property" display="lCarriageReturn" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Function......: ToString
	*!* Description...: Genera el codigo de la propiedad
	*!* Date..........: Viernes 13 de Marzo de 2009 (15:41:31)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Function ToString( ) As String;
			HELPSTRING "Genera el codigo de la propiedad"

		Local luReturnValue As String
		luReturnValue = ''
		With This As oProperty Of "Tools\Sincronizador\colDataBases.prg"
			If ! Empty( .Comment )
				luReturnValue = luReturnValue + '*!* ' + Alltrim( .Comment ) + CR
			Endif
			If .lAddComment
				luReturnValue = luReturnValue + '*!* '
			Endif
			luReturnValue = luReturnValue + Alltrim( .Name ) + ' = '
			If .lAddQuotes
				luReturnValue = luReturnValue + '"'
			Endif
			luReturnValue = luReturnValue + Alltrim( .Value )
			If .lAddQuotes
				luReturnValue = luReturnValue + '"'
			Endif
			If .lCarriageReturn
				luReturnValue = luReturnValue + CR
			Endif
		Endwith
		Return luReturnValue
	Endfunc
	*!*
	*!* END FUNCTION ToString
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oProperty
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColStoreProcedures
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Bases de Datos
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColStoreProcedures As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	#If .F.
		Local This As ColStoreProcedures Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oIndex vacío
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure New( tcName As String, tcCodigo As String ) ;
			As oStoreProcedure Of "Tools\Sincronizador\ColDataBases.prg" ;
			HELPSTRING "Obtiene un elemento oIndex vacío"

		Local loStoreProcedure As oStoreProcedure Of "Tools\Sincronizador\ColDataBases.prg"
		Local i As Number
		Local lcKey As String

		loStoreProcedure = Createobject( "oStoreProcedure" )
		loStoreProcedure.oParent = This

		If ! Empty( tcName )
			lcKey = Lower( Justfname( tcName ) )
			i = This.GetKey( lcKey )
			If Empty( i )
				This.AddItem( loStoreProcedure, lcKey )
				loStoreProcedure.cFileName = tcName
				loStoreProcedure.cCodigo = IfEmpty( tcCodigo, '' )
			Endif
		Endif

		Return loStoreProcedure

	Endproc && New

Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColStoreProcedures
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oStoreProcedure
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Base de Datos
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oStoreProcedure As SessionBase

	#If .F.
		Local This As oStoreProcedure Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!* Nombre del archivo que contiene el Store procedure
	cFileName = ''
	cCodigo = ''

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cfilename" type="property" display="cFileName" />] + ;
		[<memberdata name="ccodigo" type="property" display="cCodigo" />] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oStoreProcedure
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: ColForms
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Formularios
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColForms As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	#If .F.
		Local This As ColForms Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oForm vacío
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure New( tcName As String,;
			tcKeyName As String ) ;
			As oForm Of "Tools\Sincronizador\ColDataBases.prg" ;
			HELPSTRING "Obtiene un elemento oForm vacío"

		Local loForm As oForm Of "Tools\Sincronizador\ColDataBases.prg"
		Local i As Number
		Local lcKey As String

		loForm = Createobject( "oForm" )
		loForm.oParent = This.oParent

		If ! Empty( tcName )
			lcKey = Lower( Justfname( tcName ) )
			i = This.GetKey( lcKey )

			If Empty( i )
				This.AddItem( loForm, lcKey )
				If Empty( tcKeyName )
					tcKeyName = tcName
				Endif
				loForm.Name = tcName
				loForm.cKeyName = tcKeyName

			Else
				Error "Ya existe el Formulario " + tcName

			Endif

		Else
			Error "Falta definir el nombre del Formulario"

		Endif

		Return loForm

	Endproc && New

Enddefine && ColForms

*!* ///////////////////////////////////////////////////////
*!* Class.........: oForm
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Base de Datos
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oForm As SessionBase

	#If .F.
		Local This As oForm Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	* Nombre unico de fantasía del formulario
	cKeyName = ""

	* Carpeta donde se encuentra el formulario
	cFolder = ""

	* Extension del formulario
	cExt = "scx"

	* Identificación del formulario
	nFormId = -1

	* @TODO: Agregar los permisos

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ckeyname" type="property" display="cKeyName" />] + ;
		[<memberdata name="cext" type="property" display="cExt" />] + ;
		[<memberdata name="cfolder" type="property" display="cFolder" />] + ;
		[<memberdata name="nformid" type="property" display="nFormId" />] + ;
		[</VFPData>]

Enddefine && oForm


*!* ///////////////////////////////////////////////////////
*!* Class.........: ColTiers
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Formularios
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColTiers As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	#If .F.
		Local This As ColTiers Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oECFG vacío
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Procedure New( tcTierLevel As String ) ;
			As oECFG Of "Tools\Sincronizador\ColDataBases.prg" ;
			HELPSTRING "Obtiene un elemento oECFG vacío"

		Local loEcfg As oECFG Of "Tools\Sincronizador\ColDataBases.prg"
		Local i As Number
		Local lcKey As String

		loEcfg = Createobject( "oECFG" )
		loEcfg.oParent = This.oParent

		If !Empty( tcTierLevel )
			lcKey = Lower( tcTierLevel )
			i = This.GetKey( lcKey )

			If Empty( i )
				loEcfg.cTierLevel = tcTierLevel
				This.AddItem( loEcfg, lcKey )

			Else
				Error "Ya existe la Tier " + tcTierLevel

			Endif

		Else
			Error "Falta definir el nombre de la Tier"

		Endif

		Return loEcfg

	Endproc && New

Enddefine && ColTiers

*!* ///////////////////////////////////////////////////////
*!* Class.........: oECFG
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Base de Datos
*!* Date..........: Martes 29 de Mayo de 2007 (11:00:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oECFG As SessionBase

	#If .F.
		Local This As oECFG Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	cObjectName = ""
	cTierLevel = ""
	cObjClass = ""
	cObjClassLibrary = ""
	cObjClassLibraryFolder = ""
	cObjComponent = ""
	lObjInComComponent = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cobjectname" type="property" display="cObjectName" />] + ;
		[<memberdata name="ctierlevel" type="property" display="cTierLevel" />] + ;
		[<memberdata name="cobjclass" type="property" display="cObjClass" />] + ;
		[<memberdata name="cobjclasslibrary" type="property" display="cObjClassLibrary" />] + ;
		[<memberdata name="cobjclasslibraryfolder" type="property" display="cObjClassLibraryFolder" />] + ;
		[<memberdata name="cobjcomponent" type="property" display="cObjComponent" />] + ;
		[<memberdata name="lobjincomcomponent" type="property" display="lObjInComComponent" />] + ;
		[</VFPData>]

Enddefine && oECFG



*!* ///////////////////////////////////////////////////////
*!* Class.........: ColValidations
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Formularios
*!* Date..........: Martes 4 de Agosto de 2009
*!* Author........: Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class ColValidations As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	cClassLibrary = 'coldatabases.prg'

	cClassLibraryFolder = 'Tools\Sincronizador'

	cClassName = 'oValidationBase'

	#If .F.
		Local This As ColValidations Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine && ColValidations

*!* ///////////////////////////////////////////////////////
*!* Class.........: oValidationBase
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Base de Datos
*!* Date..........: Martes 4 de Agosto de 2009
*!* Author........: Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oValidationBase As SessionBase

	#If .F.
		Local This As oValidationBase Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!*
	oField = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="execute" type="method" display="Execute" />] + ;
		[<memberdata name="ofield" type="property" display="oField" />] + ;
		[<memberdata name="this_access" type="method" display="This_Access" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: This_Access
	*!* Date..........: Lunes 17 de Agosto de 2009 (20:36:43)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure This_Access( tcMemberName As String ) As Object
		If ! Pemstatus( This, tcMemberName, 5 )
			If Vartype( This.oField ) = 'O' And Pemstatus( This.oField, tcMemberName, 5 )

				Return This.oField

			Endif && Vartype( This.oField ) = 'O' And Pemstatus( This.oField, tcMemberName, 5 )

		Endif && ! Pemstatus( This, tcMemberName, 5 )

		Return This

	Endproc && This_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Execute
	*!* Description...:
	*!* Date..........: Martes 4 de Agosto de 2009 (01:00:38)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Execute( tcCursorName As String ) As Boolean

		Return .T.

	Endproc && Execute

Enddefine && oValidationBase

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColReports
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Reportes
*!* Date..........: Jueves 6 de Agosto de 2009 (12:06:41)
*!* Author........: Danny Amerikaner
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ColReports As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	cClassLibrary = 'coldatabases.prg'

	cClassLibraryFolder = 'Tools\Sincronizador'

	cClassName = 'oReport'

	Name = 'ColReports'


	#If .F.
		Local This As ColReports Of "Tools\Sincronizador\Coldatabases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Initialize
	*!* Description...:
	*!* Date..........: Jueves 6 de Agosto de 2009 (12:06:41)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Initialize( uParam As Variant ) As Boolean

	Endfunc && Initialize

Enddefine && ColReports

*!* ///////////////////////////////////////////////////////
*!* Class.........: oReport
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Base de Datos
*!* Date..........: Jueves 6 de Agosto de 2009
*!* Author........: Danny Amerikaner, Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oReport As SessionBase

	#If .F.
		Local This As oReport Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	*!* Colección de filtros
	oColFilter = Null

	*!* Colección de orden
	oColOrder = Null

	*!* Referencia al formulario
	oForm = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ocolfilter" type="property" display="oColFilter" />] + ;
		[<memberdata name="ocolfilter_access" type="method" display="oColFilter_Access" />] + ;
		[<memberdata name="ocolorder" type="property" display="oColOrder" />] + ;
		[<memberdata name="ocolorder_access" type="method" display="oColOrder_Access" />] + ;
		[<memberdata name="oform" type="property" display="oForm" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oColFilter_Access
	*!* Date..........: Jueves 6 de Agosto de 2009 (12:14:23)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oColFilter_Access()

		If Vartype( This.oColFilter ) # "O"
			This.oColFilter = Newobject( "ColReportFilter", "Coldatabases.prg" )

		Endif && Vartype( This.oColFilter ) # "O"

		Return This.oColFilter

	Endproc && oColFilter_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oColOrder_Access
	*!* Date..........: Jueves 6 de Agosto de 2009 (12:16:39)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oColOrder_Access()

		If Vartype( This.oColOrder ) # "O"
			This.oColOrder = Newobject( "ColReportOrder", "tools\sincronizador\coldatabases.prg" )

		Endif && Vartype( This.oColOrder ) # "O"

		Return This.oColOrder

	Endproc && oColOrder_Access

Enddefine && oReport

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColReportOrder
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Reportes
*!* Date..........: Jueves 6 de Agosto de 2009 (12:06:41)
*!* Author........: Danny Amerikaner
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ColReportOrder As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	cClassLibrary = 'coldatabases.prg'

	cClassLibraryFolder = 'Tools\Sincronizador'

	cClassName = 'oReportOrder'

	Name = 'ColReportOrder'


	#If .F.
		Local This As ColReportOrder Of "Tools\Sincronizador\Coldatabases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColReportOrder
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oReportOrder
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Base de Datos
*!* Date..........: Jueves 6 de Agosto de 2009
*!* Author........: Danny Amerikaner, Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oReportOrder As SessionBase

	oField = Null

	*!* Número de orden del elemento
	nTabIndex = 0

	lVisible = .T.

	*!* Indica si el objeto ha sido seleccionado
	lSelected = .F.

	*!* Contiene el nombre que se mostrará al usuario
	cDisplayValue = ""

	*!* Nombre del campo en la tabla de origen
	cFieldName = ""

	*!* Nombre de la tabla en el origen de datos
	cTableName = ""

	#If .F.
		Local This As oReportOrder Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lselected" type="property" display="lSelected" />] + ;
		[<memberdata name="lvisible" type="property" display="lVisible" />] + ;
		[<memberdata name="ntabindex" type="property" display="nTabIndex" />] + ;
		[<memberdata name="ntabindex_assign" type="method" display="nTabIndex_Assign" />] + ;
		[<memberdata name="cdisplayvalue" type="property" display="cDisplayValue" />] + ;
		[<memberdata name="cdisplayvalue_access" type="method" display="cDisplayValue_Access" />] + ;
		[<memberdata name="ctablename" type="property" display="cTableName" />] + ;
		[<memberdata name="cfieldname" type="property" display="cFieldName" />] + ;
		[<memberdata name="ofield" type="property" display="oField" />] + ;
		[<memberdata name="this_access" type="method" display="This_Access" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: This_Access
	*!* Date..........: Lunes 17 de Agosto de 2009 (20:36:43)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure This_Access( tcMemberName As String ) As Object
		If ! Pemstatus( This, tcMemberName, 5 )
			If Vartype( This.oField ) = 'O' And Pemstatus( This.oField, tcMemberName, 5 )

				Return This.oField

			Endif && Vartype( This.oField ) = 'O' And Pemstatus( This.oField, tcMemberName, 5 )

		Endif && ! Pemstatus( This, tcMemberName, 5 )

		Return This

	Endproc && This_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: cDisplayValue_Access
	*!* Date..........: Jueves 6 de Agosto de 2009 (12:16:39)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure cDisplayValue_Access()

		If Empty( This.cDisplayValue )
			This.cDisplayValue = This.oField.Caption

		Endif && Empty( This.cDisplayValue )

		Return This.cDisplayValue

	Endproc && cDisplayValue_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: cTableName_Access
	*!* Date..........: Jueves 6 de Agosto de 2009 (12:16:39)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure cTableName_Access()

		If Empty( This.cTableName )
			This.cTableName = This.oField.oParent.Name

		Endif && Empty( This.cTableName )

		Return This.cTableName

	Endproc && cTableName_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: cFieldName_Access
	*!* Date..........: Jueves 6 de Agosto de 2009 (12:16:39)
	*!* Author........: Danny Amerikaner
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure cFieldName_Access()

		If Empty( This.cFieldName )
			This.cFieldName = This.oField.Name
		Endif
		Return This.cFieldName

	Endproc && cFieldName_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: nTabIndex_Assign
	*!* Date..........: Lunes 10 de Diciembre de 2007 (13:30:50)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure nTabIndex_Assign( uNewValue As Integer )

		If uNewValue <= 0
			Error "Valor no válido en la propiedad nTabIndex de " + This.Name
		Endif

		This.nTabIndex = uNewValue

	Endproc && nTabIndex_Assign


Enddefine && oReportOrder

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColReportFilter
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Reportes
*!* Date..........: Jueves 6 de Agosto de 2009 (12:06:41)
*!* Author........: Danny Amerikaner
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ColReportFilter As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	cClassLibrary = 'coldatabases.prg'

	cClassLibraryFolder = 'Tools\Sincronizador'

	cClassName = 'oReportFilter'

	Name = 'ColReportFilter'


	#If .F.
		Local This As ColReportFilter Of "Tools\Sincronizador\Coldatabases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColReportFilter
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oReportFilter
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Base de Datos
*!* Date..........: Jueves 6 de Agosto de 2009
*!* Author........: Danny Amerikaner, Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oReportFilter As SessionBase

	oField = Null

	#If .F.
		Local This As oReportFilter Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="this_access" type="method" display="This_Access" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: This_Access
	*!* Date..........: Lunes 17 de Agosto de 2009 (20:36:43)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure This_Access( tcMemberName As String ) As Object
		If ! Pemstatus( This, tcMemberName, 5 )
			If Vartype( This.oField ) = 'O' And Pemstatus( This.oField, tcMemberName, 5 )

				Return This.oField

			Endif && Vartype( This.oField ) = 'O' And Pemstatus( This.oField, tcMemberName, 5 )

		Endif && ! Pemstatus( This, tcMemberName, 5 )

		Return This

	Endproc && This_Access


Enddefine && oReportFilter

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColContainer
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Reportes
*!* Date..........: Jueves 6 de Agosto de 2009 (12:06:41)
*!* Author........: Danny Amerikaner
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ColContainer As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	cClassLibrary = 'coldatabases.prg'

	cClassLibraryFolder = 'Tools\Sincronizador'

	cClassName = 'oContainer'

	Name = 'ColContainer'


	#If .F.
		Local This As ColContainer Of "Tools\Sincronizador\Coldatabases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine && ColContainer


*!* ///////////////////////////////////////////////////////
*!* Class.........: oContainer
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Base de Datos
*!* Date..........: Lunes 17 de Agosto de 2009
*!* Author........: Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oContainer As SessionBase

	#If .F.
		Local This As oContainer Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	Name = 'oContainer'

	*!* Colección de Controles
	oColControls = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ocolcontrols" type="property" display="oColControls" />] + ;
		[<memberdata name="ocolcontrols_access" type="method" display="oColControls_Access" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oColControls_Access
	*!* Date..........: Lunes 17 de Agosto de 2009 (20:27:36)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oColControls_Access()
		With This As oContainer Of Tools\Sincronizador\ColDataBases.prg
			If Vartype( .oColControls ) # 'O'
				.oColControls = Createobject( 'ColControls' )

			Endif && Vartype( .oColControls ) # 'O'

		Endwith

		Return This.oColControls

	Endproc && oColControls_Access

Enddefine && oContainer

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColControls
*!* ParentClass...: ColBase
*!* BaseClass.....: Collection
*!* Description...: Colección de Controles
*!* Date..........: Lunes 17 de Agosto de 2009
*!* Author........: Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ColControls As ColBase Of "Tools\Sincronizador\colDataBases.prg"

	cClassLibrary = 'coldatabases.prg'

	cClassLibraryFolder = 'Tools\Sincronizador'

	cClassName = 'oControl'

	Name = 'ColControls'


	#If .F.
		Local This As ColControls Of "Tools\Sincronizador\Coldatabases.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine && ColControls


*!* ///////////////////////////////////////////////////////
*!* Class.........: oControl
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase Base de Datos
*!* Date..........: Lunes 17 de Agosto de 2009
*!* Author........: Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class oControl As SessionBase

	#If .F.
		Local This As oControl Of "Tools\Sincronizador\ColDataBases.prg"
	#Endif

	oField = Null

	oTable = Null

	Name = 'oControl'

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ofield" type="property" display="oField" />] + ;
		[<memberdata name="otable" type="property" display="oTable" />] + ;
		[<memberdata name="this_access" type="method" display="This_Access" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: This_Access
	*!* Date..........: Lunes 17 de Agosto de 2009 (20:36:43)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure This_Access( tcMemberName As String ) As Object
		If ! Pemstatus( This, tcMemberName, 5 )
			If Vartype( This.oField ) = 'O' And Pemstatus( This.oField, tcMemberName, 5 )

				Return This.oField

			Endif && Vartype( This.oField ) = 'O' And Pemstatus( This.oField, tcMemberName, 5 )

			If Vartype( This.oTable ) = 'O' And Pemstatus( This.oTable, tcMemberName, 5 )

				Return This.oTable

			Endif && Vartype( This.oTable ) = 'O' And Pemstatus( This.oTable, tcMemberName, 5 )

		Endif && ! Pemstatus( This, tcMemberName, 5 )

		Return This

	Endproc && This_Access

Enddefine && oControl