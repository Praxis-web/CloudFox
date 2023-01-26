* RA 2014-08-29(17:38:58)
* No se usa mas
* Usar en su lugar
*	Tools\DataDictionary\prg\
*

#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\Tieradapter\Include\TA.h"
#INCLUDE "Tools\ErrorHandler\include\eh.h"

#Define KEYASCENDING 2
#Define KEYDESCENDING 3

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxSession
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...:
*!* Date..........: Martes 3 de Febrero de 2009 (11:48:53)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxSession As Session

	#If .F.
		Local This As PrxSession Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"
	#Endif

	DataSession = SET_DEFAULT

	*!* Referencia al objeto Parent
	oParent = Null

	*!* Clave de búsqueda del objeto en los archivos de configuración
	cDataConfigurationKey = ""

	* Clase de manejo de errores
	oError = Null

	* Objeto error en XML
	cXMLoError = ""

	*	Flag de estado
	lIsOk = .T.

	* Ruta a la carpeta raiz del proyecto, donde se encuentran los archivos de configuración
	cRootFolder = ""

	* Nombre del archivo xml con la configuracion de las entidades
	cObjectFactoryFileName = ""

	* Referencia al diccionario de datos
	oDataDictionary = Null

	* Metadata de configuración
	oEntitiesConfig = Null

	* Referencia a la coleccion de formularios
	oForms = Null

	* Referencia a la coleccion de Tables
	oTables = Null

	* Nombre de la aplicación que se está corriendo
	cApplicationName = ""

	* Referencia a la configuración general
	oGlobalSettings = Null

	cTierLevel = 'USER'
	* Referencia a la colección DataBases
	oDataBases = Null

	_instanceId = Sys( 2015 )

	* Flag
	lOnDestroy = .F.

	* Valor de la DataSessionId original
	nOldDataSessionId = 0

	lUseNameSpaces = .F.

	* Indica si son tablas libres o utiliza una DBC
	lUseDBC = .T.

	* Indica si se utilizan transacciones
	lUseTransactions = .T.

	* Modo Debug
	lDebugMode = .F.

	* RA 2013-06-29(12:25:45)
	* Usado por AfterCursorFill() de CursorAdapterBase
	* Si trabajo conectado, no puedo cerrar las tablas
	* Solo vale para Clipper2Fox y Bases Nativas

	lCloseNativeTables = .T.



	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lusenamespaces" type="property" display="lUseNameSpaces" />] + ;
		[<memberdata name="lusedbc" type="property" display="lUseDBC" />] + ;
		[<memberdata name="lusetransactions" type="property" display="lUseTransactions" />] + ;
		[<memberdata name="ldebugmode" type="property" display="lDebugMode" />] + ;
		[<memberdata name="lclosenativetables" type="property" display="lCloseNativeTables" />] + ;
		[<memberdata name="reseterror" type="method" display="ResetError" />] + ;
		[<memberdata name="odatabases" type="property" display="oDataBases" />] + ;
		[<memberdata name="otables" type="property" display="oTables" />] + ;
		[<memberdata name="oforms" type="property" display="oForms" />] + ;
		[<memberdata name="oglobalsettings" type="property" display="oGlobalSettings" />] + ;
		[<memberdata name="capplicationname" type="property" display="cApplicationName" />] + ;
		[<memberdata name="cobjectfactoryfilename" type="property" display="cObjectFactoryFileName" />] + ;
		[<memberdata name="crootfolder" type="property" display="cRootFolder" />] + ;
		[<memberdata name="lisok" type="property" display="lIsOk" />] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[<memberdata name="oparent_assign" type="method" display="oParent_Assign" />] + ;
		[<memberdata name="getmain" type="method" display="GetMain" />] + ;
		[<memberdata name="cdataconfigurationkey" type="property" display="cDataConfigurationKey" />] + ;
		[<memberdata name="cxmloerror" type="property" display="cXMLoError" />] + ;
		[<memberdata name="oerror" type="property" display="oError" />] + ;
		[<memberdata name="onwarning" type="method" display="OnWarning" />] + ;
		[<memberdata name="onstop" type="method" display="OnStop" />] + ;
		[<memberdata name="oninform" type="method" display="OnInform" />] + ;
		[<memberdata name="onconfirm" type="method" display="OnConfirm" />] + ;
		[<memberdata name="warning" type="method" display="Warning" />] + ;
		[<memberdata name="stop" type="method" display="Stop" />] + ;
		[<memberdata name="inform" type="method" display="Inform" />] + ;
		[<memberdata name="confirm" type="method" display="Confirm" />] + ;
		[<memberdata name="odatadictionary" type="property" display="oDataDictionary" />] + ;
		[<memberdata name="oentitiesconfig" type="property" display="oEntitiesConfig" />] + ;
		[<memberdata name="processclause" type="method" display="ProcessClause" />] + ;
		[<memberdata name="members" type="method" display="AMembers" />] + ;
		[<memberdata name="pemstatus" type="method" display="PemStatus" />] + ;
		[<memberdata name="londestroy" type="property" display="lOnDestroy" />] + ;
		[<memberdata name="nolddatasessionid" type="property" display="nOldDataSessionId" />] + ;
		[<memberdata name="initialize" type="method" display="Initialize" />] + ;
		[</VFPData>]


	Procedure Init()
		Local lcCommand As String

		Try

			lcCommand = ""
			This.nOldDataSessionId 	= This.DataSessionId
			loApp 					= NewApp()
			This.lUseNameSpaces 	= loApp.lUseNameSpaces
			This.lCloseNativeTables = loApp.lCloseNativeTables
			This.lDebugMode 		= loApp.lDebugMode
			This.lUseDBC 			= loApp.lUseDBC
			This.lUseTransactions 	= loApp.lUseTransactions

			If !IsRuntime()
				Set DataSession To
				This.DataSessionId = 1
			Endif


		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loApp = Null

		Endtry


		Return .T.
	Endproc



	*!* ///////////////////////////////////////////////////////
	*!* Function......: Initialize
	*!* Description...:
	*!* Date..........: Martes 3 de Febrero de 2009 (11:48:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Initialize( uParam As Variant ) As Boolean

		Try


		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry


	Endfunc
	*!*
	*!* END FUNCTION Initialize
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oParent_Assign
	*!* Date..........: Martes 3 de Febrero de 2009 (11:52:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oParent_Assign( uNewValue )

		If Vartype( uNewValue ) # "O"
			uNewValue = Null
		Endif

		This.oParent = uNewValue

	Endproc && oParent_Assign


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetMain
	*!* Description...: Devuelve el objeto principal en la jerarquía de clases
	*!* Date..........: Martes 3 de Febrero de 2009 (11:57:16)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetMain(  ) As Object;
			HELPSTRING "Devuelve el objeto principal en la jerarquía de clases"


		Local loMain As Object
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			If Vartype( This.oParent ) == "O"
				loMain = This.oParent.GetMain()

			Else
				loMain = This

			Endif

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loMain

	Endproc
	*!*
	*!* END PROCEDURE GetMain
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Martes 3 de Febrero de 2009 (13:22:51)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy(  ) As Void

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try


			If !Empty( This.nOldDataSessionId )
				If This.DataSessionId # This.nOldDataSessionId
					*!*						Set Step On
				Endif
				This.DataSessionId = This.nOldDataSessionId
			Endif

			This.oDataBases = Null
			This.oDataDictionary = Null
			This.oEntitiesConfig = Null
			This.oForms = Null
			This.oGlobalSettings = Null
			This.oParent = Null
			This.oError = Null
			This.oTables = Null

			Unbindevents( This )

			DoDefault()

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

	Endproc && Destroy

	* ///////////////////////////////////////////////////////
	* Procedure.....: oError_Access
	* Date..........: Sábado 18 de Abril de 2009 (20:18:12)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure oError_Access()
		Try

			If Vartype( This.oError ) <> "O"
				This.oError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

				* Por defecto, todas las capas tiene habilitada la posibilidad de loguear el error
				* El objeto ErrorHandler loguea el error en el proceso en el que se produce, y luego
				* bloquea los logueos subsiguientes.
				* Solo en la UserTier se muestra el error al usuario
				This.oError.TierBehavior = EH_LOGERROR
				This.oError.cTierLevel = This.cTierLevel
			Endif

		Catch To oErr
			This.lIsOk = .F.
			Throw oErr

		Finally

		Endtry

		Return This.oError

	Endproc
	*
	* END PROCEDURE oError_Access
	*
	* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: OnWarning
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:44:26)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure OnWarning( tcText As String, tcCaption As String, tnSeconds As Integer ) As Void

	Endproc && OnWarning

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: OnStop
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:46:00)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure OnStop( tcText As String, tcCaption As String ) As Void

	Endproc && OnStop

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: OnInform
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:47:07)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure OnInform( tcText As String, tcCaption As String, tnSeconds As Integer ) As Void

	Endproc && OnInform

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: OnConfirm
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:48:21)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure OnConfirm( tcText As String, tcCaption As String, tcWavFile As String, tnReturn As Number @ ) As Void

	Endproc && OnConfirm




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Warning
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:44:26)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Warning( tcText As String, tcCaption As String, tnSeconds As Integer ) As Void
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			Raiseevent( This, 'OnWarning', tcText, tcCaption, tnSeconds )
		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )

			Throw loError
		Finally
			loError = Null
		Endtry
	Endproc && Warning

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Stop
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:46:00)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Stop( tcText As String, tcCaption As String ) As Void
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			Raiseevent( This, 'OnStop', tcText, tcCaption )
		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError
		Finally
			loError = Null
		Endtry
	Endproc && Stop

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Inform
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:47:07)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Inform( tcText As String, tcCaption As String, tnSeconds As Integer ) As Void
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			Raiseevent( This, 'OnInform', tcText, tcCaption, tnSeconds )
		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError
		Finally
			loError = Null
		Endtry
	Endproc && Inform

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Confirm
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:48:21)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Confirm( tcText As String, tcCaption As String, tcWavFile As String ) As Number
		Local lnReturn As Number
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			lnReturn = 0 && inicio la variable
			Raiseevent( This, 'OnConfirm', tcText, tcCaption, tcWavFile, lnReturn )
		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError
		Finally
			loError = Null
		Endtry
		Return lnReturn
	Endproc && Confirm


	*
	* cRootFolder_Access
	Protected Procedure cRootFolder_Access()

		Local lcCommand As String

		Try

			lcCommand = ""

			If Empty( This.cRootFolder )
				If !IsRuntime()
					Local lcCurdir As String

					lcCurdir = Set('DEFAULT') + Sys(2003)

					If FileExist( Addbs( lcCurdir ) + "WorkingFolder.Cfg" )
						loXA = Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

						loXA.LoadXML( Addbs( lcCurdir ) + "WorkingFolder.Cfg", .T. )
						loXA.Tables(1).ToCursor()
						loXA = Null

						This.cRootFolder = Alltrim( WorkingFolder )

						Use In Alias()

					Else
						Local loProject As PjHook Of "Tools\ProjectHook\Vcx\ProjectHookVss.vcx"
						Local lcProjectPath As String

						lcProjectPath = ""
						loProject = _vfp.ActiveProject

						lcProjectPath = Justpath( loProject.Name )

						This.cRootFolder = Addbs( lcProjectPath )
						loProject = Null

					Endif

				Endif

			Endif


		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loXA = Null

		Endtry

		Return This.cRootFolder

	Endproc && cRootFolder_Access

	*
	* cObjectFactoryFileName_Access
	Protected Procedure cObjectFactoryFileName_Access()

		If Empty( This.cObjectFactoryFileName )
			This.cObjectFactoryFileName = Addbs( This.cRootFolder ) + "ObjectFactoryCfg.xml"
		Endif

		Return This.cObjectFactoryFileName

	Endproc && cObjectFactoryFileName_Access

	*
	* Devuelve una instancia del objeto
	Procedure InstanciateEntity( tcEntityName As String,;
			tcTierLevel As String,;
			tnDataSessionId As Integer ) As Object;
			HELPSTRING "Devuelve una instancia del objeto"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve una instancia del objeto
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 15 de Mayo de 2009 (08:47:03)
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
			tcEntityName AS String
			tcTierLevel AS String
			tcObjectFactoryFileName AS String
			*:Remarks:
			Factory Method
			*:Returns:
			Object
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loObjectFactory As ObjectFactory Of "FW\Comunes\Prg\ObjectFactory.prg"
		Local loEntity As TierAdapter Of "FW\TierAdapter\Comun\TierAdapter.prg"

		Try
			If Empty( tcTierLevel )
				If Pemstatus( This, "cTierLevel", 5 )
					tcTierLevel = This.cTierLevel

				Else
					tcTierLevel = "User"

				Endif
			Endif

			If Empty( tnDataSessionId )
				tnDataSessionId = This.DataSessionId
			Endif

			loObjectFactory = NewObjectFactory()

			loEntity = loObjectFactory.GetNewObject( tcEntityName, tcTierLevel, tnDataSessionId )


			If Lower( loEntity.cTierLevel ) <> Lower( "Service" )
				If Pemstatus( This, "lSerialize", 5 ) And This.lSerialize
					loEntity.lSerialize = This.lSerialize
					loEntity.DataSessionId = tnDataSessionId

				Endif

			Endif

		Catch To oErr
			*!*	If This.lIsOk
			*!*		This.lIsOk = .F.
			*!*		This.cXMLoError=This.oError.Process( oErr )
			*!*	Endif
			This.lIsOk = .F.
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loObjectFactory = Null
			loError = Null
			* DAE 2009-11-11(12:44:30)
			*!*	If !This.lIsOk
			*!*		Throw This.oError
			*!*	Endif

		Endtry

		Return loEntity

	Endproc && InstanciateEntity


	*
	* oEntitiesConfig_Access
	Protected Procedure oEntitiesConfig_Access()

		If Vartype( This.oEntitiesConfig ) # "O"
			*!*				This.oEntitiesConfig = Newobject( This.cApplicationName, ;
			*!*					Addbs( This.cRootFolder ) + "Prg\Ecfg_" + This.cApplicationName + ".prg" )

			This.oEntitiesConfig = NewEntitiesConfig()

		Endif

		Return This.oEntitiesConfig

	Endproc && oEntitiesConfig_Access



	*
	* oDataDictionary_Access
	Protected Procedure oDataDictionary_Access()

		If Vartype( This.oDataDictionary ) # "O"
			This.oDataDictionary = NewDataDictionary()
		Endif

		Return This.oDataDictionary

	Endproc && oDataDictionary_Access


	*
	* oForms_Access
	Protected Procedure oForms_Access()

		If Vartype( This.oForms ) # "O"
			This.oForms = NewColForms()

		Endif

		Return This.oForms

	Endproc && oForms

	*
	* oDataBases_Access
	Procedure oDataBases_Access()

		If Vartype( This.oDataBases ) # "O"
			This.oDataBases = NewColDataBases()

		Endif

		Return This.oDataBases

	Endproc && oDataBases_Access

	*
	* cApplicationName_Access
	Protected Procedure cApplicationName_Access()

		Local loProject As ProjectHook
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			If Empty( This.cApplicationName )
				If !IsRuntime()
					loProject = _vfp.ActiveProject
					This.cApplicationName = Juststem( loProject.Name )

				Else
					This.cApplicationName = This.oGlobalSettings.cApplicationName

				Endif

			Endif

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

			loProject = Null

		Endtry

		Return This.cApplicationName

	Endproc && cApplicationName_Access


	*
	* oGlobalSettings_Access
	Protected Procedure oGlobalSettings_Access()
		If Vartype( This.oGlobalSettings ) # "O"
			*!*				This.oGlobalSettings = Newobject( 'GlobalSettings', 'FW\Comunes\PRG\GlobalSettings.prg' )
			This.oGlobalSettings = NewGlobalSettings()
		Endif
		Return This.oGlobalSettings

	Endproc && oGlobalSettings_Access

	Procedure ProcessClause ( tcClause As String, tvOrigen, tcReplace As String  ) As String
		Local i As Integer
		Local lcRet As String
		Local lcMember As String
		Local Array lAmembers[ 1 ]
		Local Array lAFields[ 1 ]
		Local lnMax As Number

		Local lcType As String

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = 'ProcessClause: ' + Transform( tcClause )

			lcRet = Space( 1 ) + tcClause + Space( 1 )
			lcType = Vartype( tvOrigen )
			If Inlist( lcType, 'C', 'O' )

				Do Case
					Case lcType = 'C' And Used( tvOrigen )
						If Empty( tcReplace )
							tcReplace = tvOrigen + '.'

						Endif && Empty( tcReplace )

						lnMax = Afields( lAFields, tvOrigen )
						Asort( lAFields, 1, -1, 1, 1 )
						For i = 1 To lnMax
							lcField = Alltrim( lAFields[ i, 1 ] )
							lcRet = Strtran( lcRet, Space( 1 ) + lcField, Space( 1 ) + tcReplace + lcField, -1, -1, 1 )
							lcRet = Strtran( lcRet, "(" + lcField, "(" + tcReplace + lcField, -1, -1, 1 )

						Endfor

					Case lcType = 'O'
						If Empty( tcReplace )
							tcReplace = 'loItem.'

						Endif && Empty( tcReplace )

						lnMax = Amembers( lAmembers, tvOrigen )
						Asort( lAmembers, 1, -1, 1, 1 )
						For i = 1 To lnMax
							lcMember = Alltrim( lAmembers[ i ] )
							lcRet = Strtran( lcRet, Space( 1 ) + lcMember, Space( 1 ) + tcReplace + lcMember, -1, -1, 1 )
							lcRet = Strtran( lcRet, "(" + lcMember, "(" + tcReplace + lcMember, -1, -1, 1 )

						Endfor

						If Pemstatus( tvOrigen, 'Class', 5 )
							lnMax = Amembers( lAmembers, tvOrigen.Class )
							Asort( lAmembers, 1, -1, 1, 1 )
							For i = 1 To lnMax
								lcMember = Alltrim( lAmembers[ i ] )
								lcRet = Strtran( lcRet, Space( 1 ) + lcMember, Space( 1 ) + tcReplace + lcMember, -1, -1, 1 )
								lcRet = Strtran( lcRet, "(" + lcMember, "(" + tcReplace + lcMember, -1, -1, 1 )

							Endfor

						Endif

				Endcase

			Endif

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null
			loItem = Null

		Endtry

		Return Alltrim( lcRet )

	Endproc && ProcessClause

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AMembers
	*!* Description...:
	*!* Date..........: Jueves 30 de Julio de 2009 (00:41:25)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Amembers( tvAmembers As Variant @, tnArrayContentsId As Integer ) As Variant

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lnMax As Integer

		Try
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''

			If Empty( tnArrayContentsId )
				tnArrayContentsId = 0

			Endif && Empty( tnArrayContentsId )

			lnMax = Amembers( tvAmembers, This, tnArrayContentsId )


		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

		Endtry

		Return lnMax

	Endproc && AMembers

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: PemStatus
	*!* Description...:
	*!* Date..........: Jueves 30 de Julio de 2009 (00:47:07)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Pemstatus( tcProperty As String, tnAttribute As Integer ) As Variant
		Local lvRet As Variant

		If ! Empty( tcProperty )
			If Empty( tnAttribute )
				tnAttribute = 5

			Endif && Empty( tnAttribute )
			lvRet = Pemstatus( This, tcProperty, tnAttribute )

		Endif && ! Empty( tcProperty )

		Return lvRet

	Endproc && PemStatus

	* ToString
	Procedure ToString( tcTemplate As String ) As String

		Local lcString As String
		Local lcExpresion As String
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			lcString = ""

			If Empty( tcTemplate )
				lcString = This.Name

			Else
				lcExpresion = This.ProcessClause( tcTemplate, This, "This." )
				lcString = Evaluate( lcExpresion )

			Endif && Empty( tcTemplate )

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			Try

				This.ResetError()

			Catch To oErr
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Process( oErr )
			Finally
				loError = Null
			Endtry

			*!*	loError = This.oError
			*!*	loError.cRemark = ''
			*!*	loError.cTraceLogin = ''
			loError = Null

		Endtry

		Return lcString

	Endproc && ToString

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ResetError
	*!* Description...: Reinicia la propiedades del objeto error
	*!* Date..........: Viernes 21 de Agosto de 2009 (13:56:21)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ResetError() As Void;
			HELPSTRING "Reinicia la propiedades del objeto error"

		This.oError.Reset()

	Endproc && ResetError

Enddefine && PrxSession

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxCustom
*!* ParentClass...: Custom
*!* BaseClass.....: Custom
*!* Description...:
*!* Date..........: Lunes 26 de OCtubre de 2009
*!* Author........: Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class PrxCustom As Custom

	#If .F.
		Local This As PrxCustom Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"
	#Endif

	DataSession = SET_DEFAULT

	DataSessionId = Set("Datasession")

	*!* Referencia al objeto Parent
	oParent = Null

	*!* Clave de búsqueda del objeto en los archivos de configuración
	cDataConfigurationKey = ""

	* Clase de manejo de errores
	oError = Null

	* Objeto error en XML
	cXMLoError = ""

	*	Flag de estado
	lIsOk = .T.

	* Ruta a la carpeta raiz del proyecto, donde se encuentran los archivos de configuración
	cRootFolder = ""

	* Nombre del archivo xml con la configuracion de las entidades
	cObjectFactoryFileName = ""

	* Referencia al diccionario de datos
	oDataDictionary = Null

	* Metadata de configuración
	oEntitiesConfig = Null

	* Referencia a la coleccion de formularios
	oForms = Null

	* Referencia a la coleccion de Tables
	oTables = Null

	* Nombre de la aplicación que se está corriendo
	cApplicationName = ""

	* Referencia a la configuración general
	oGlobalSettings = Null

	cTierLevel = 'USER'
	* Referencia a la colección DataBases
	oDataBases = Null

	_instanceId = Sys( 2015 )

	* Flag
	lOnDestroy = .F.

	* Valor de la DataSessionId original
	nOldDataSessionId = 0

	lUseNameSpaces = .F.

	* Indica si son tablas libres o utiliza una DBC
	lUseDBC = .T.

	* Indica si se utilizan transacciones
	lUseTransactions = .T.

	* Modo Debug
	lDebugMode = .F.

	* RA 2013-06-29(12:25:45)
	* Usado por AfterCursorFill() de CursorAdapterBase
	* Si trabajo conectado, no puedo cerrar las tablas
	* Solo vale para Clipper2Fox y Bases Nativas

	lCloseNativeTables = .T.


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lusenamespaces" type="property" display="lUseNameSpaces" />] + ;
		[<memberdata name="lusedbc" type="property" display="lUseDBC" />] + ;
		[<memberdata name="lusetransactions" type="property" display="lUseTransactions" />] + ;
		[<memberdata name="ldebugmode" type="property" display="lDebugMode" />] + ;
		[<memberdata name="lclosenativetables" type="property" display="lCloseNativeTables" />] + ;
		[<memberdata name="reseterror" type="method" display="ResetError" />] + ;
		[<memberdata name="odatabases" type="property" display="oDataBases" />] + ;
		[<memberdata name="otables" type="property" display="oTables" />] + ;
		[<memberdata name="oforms" type="property" display="oForms" />] + ;
		[<memberdata name="oglobalsettings" type="property" display="oGlobalSettings" />] + ;
		[<memberdata name="capplicationname" type="property" display="cApplicationName" />] + ;
		[<memberdata name="cobjectfactoryfilename" type="property" display="cObjectFactoryFileName" />] + ;
		[<memberdata name="crootfolder" type="property" display="cRootFolder" />] + ;
		[<memberdata name="lisok" type="property" display="lIsOk" />] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[<memberdata name="oparent_assign" type="method" display="oParent_Assign" />] + ;
		[<memberdata name="getmain" type="method" display="GetMain" />] + ;
		[<memberdata name="cdataconfigurationkey" type="property" display="cDataConfigurationKey" />] + ;
		[<memberdata name="cxmloerror" type="property" display="cXMLoError" />] + ;
		[<memberdata name="oerror" type="property" display="oError" />] + ;
		[<memberdata name="onwarning" type="method" display="OnWarning" />] + ;
		[<memberdata name="onstop" type="method" display="OnStop" />] + ;
		[<memberdata name="oninform" type="method" display="OnInform" />] + ;
		[<memberdata name="onconfirm" type="method" display="OnConfirm" />] + ;
		[<memberdata name="warning" type="method" display="Warning" />] + ;
		[<memberdata name="stop" type="method" display="Stop" />] + ;
		[<memberdata name="inform" type="method" display="Inform" />] + ;
		[<memberdata name="confirm" type="method" display="Confirm" />] + ;
		[<memberdata name="odatadictionary" type="property" display="oDataDictionary" />] + ;
		[<memberdata name="oentitiesconfig" type="property" display="oEntitiesConfig" />] + ;
		[<memberdata name="processclause" type="method" display="ProcessClause" />] + ;
		[<memberdata name="members" type="method" display="AMembers" />] + ;
		[<memberdata name="pemstatus" type="method" display="PemStatus" />] + ;
		[<memberdata name="londestroy" type="property" display="lOnDestroy" />] + ;
		[<memberdata name="nolddatasessionid" type="property" display="nOldDataSessionId" />] + ;
		[<memberdata name="initialize" type="method" display="Initialize" />] + ;
		[<memberdata name="hookbeforeinitialize" type="method" display="HookBeforeInitialize" />] + ;
		[</VFPData>]


	Procedure Init( uParam )
		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .F.

			If !IsRuntime()
				Set DataSession To
			Endif

			If This.ClassBeforeInitialize( uParam )
				If This.HookBeforeInitialize( uParam )

					llOk = .T.

					This.Initialize( uParam )

					This.HookAfterInitialize( uParam )
					This.ClassAfterInitialize( uParam )

				Endif
			Endif


		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry


		Return llOk
	Endproc

	Procedure ClassBeforeInitialize( uParam )
		Return .T.
	Endproc


	Procedure HookBeforeInitialize( uParam )
		Return .T.
	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Initialize
	*!* Description...:
	*!* Date..........: Martes 3 de Febrero de 2009 (11:48:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Initialize( uParam As Variant ) As Boolean

		Try

			This.nOldDataSessionId = This.DataSessionId
			loApp 					= NewApp()
			This.lUseNameSpaces 	= loApp.lUseNameSpaces
			This.lCloseNativeTables = loApp.lCloseNativeTables
			This.lDebugMode 		= loApp.lDebugMode
			This.lUseDBC 			= loApp.lUseDBC
			This.lUseNameSpaces 	= loApp.lUseNameSpaces
			This.lUseTransactions 	= loApp.lUseTransactions

		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loApp = Null

		Endtry


	Endfunc
	*!*
	*!* END FUNCTION Initialize
	*!*
	*!* ///////////////////////////////////////////////////////


	Procedure HookAfterInitialize( uParam )
	Endproc

	Procedure ClassAfterInitialize( uParam )
	Endproc


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oParent_Assign
	*!* Date..........: Martes 3 de Febrero de 2009 (11:52:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oParent_Assign( uNewValue )

		If Vartype( uNewValue ) # "O"
			uNewValue = Null
		Endif

		This.oParent = uNewValue

	Endproc && oParent_Assign


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetMain
	*!* Description...: Devuelve el objeto principal en la jerarquía de clases
	*!* Date..........: Martes 3 de Febrero de 2009 (11:57:16)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetMain(  ) As Object;
			HELPSTRING "Devuelve el objeto principal en la jerarquía de clases"


		Local loMain As Object
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			If Vartype( This.oParent ) == "O"
				loMain = This.oParent.GetMain()

			Else
				loMain = This

			Endif

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loMain

	Endproc
	*!*
	*!* END PROCEDURE GetMain
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Martes 3 de Febrero de 2009 (13:22:51)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy(  ) As Void

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try


			If !Empty( This.nOldDataSessionId )
				If This.DataSessionId # This.nOldDataSessionId
					*!*						Set Step On
				Endif
				This.DataSessionId = This.nOldDataSessionId
			Endif

			This.oDataBases = Null
			This.oDataDictionary = Null
			This.oEntitiesConfig = Null
			This.oForms = Null
			This.oGlobalSettings = Null
			This.oParent = Null
			This.oError = Null
			This.oTables = Null

			Unbindevents( This )

			DoDefault()

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

	Endproc && Destroy

	* ///////////////////////////////////////////////////////
	* Procedure.....: oError_Access
	* Date..........: Sábado 18 de Abril de 2009 (20:18:12)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure oError_Access()
		Try

			If Vartype( This.oError ) <> "O"
				This.oError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

				* Por defecto, todas las capas tiene habilitada la posibilidad de loguear el error
				* El objeto ErrorHandler loguea el error en el proceso en el que se produce, y luego
				* bloquea los logueos subsiguientes.
				* Solo en la UserTier se muestra el error al usuario
				This.oError.TierBehavior = EH_LOGERROR
				This.oError.cTierLevel = This.cTierLevel
			Endif

		Catch To oErr
			This.lIsOk = .F.
			Throw oErr

		Finally

		Endtry

		Return This.oError

	Endproc
	*
	* END PROCEDURE oError_Access
	*
	* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: OnWarning
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:44:26)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure OnWarning( tcText As String, tcCaption As String, tnSeconds As Integer ) As Void

	Endproc && OnWarning

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: OnStop
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:46:00)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure OnStop( tcText As String, tcCaption As String ) As Void

	Endproc && OnStop

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: OnInform
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:47:07)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure OnInform( tcText As String, tcCaption As String, tnSeconds As Integer ) As Void

	Endproc && OnInform

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: OnConfirm
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:48:21)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure OnConfirm( tcText As String, tcCaption As String, tcWavFile As String, tnReturn As Number @ ) As Void

	Endproc && OnConfirm




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Warning
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:44:26)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Warning( tcText As String, tcCaption As String, tnSeconds As Integer ) As Void
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			Raiseevent( This, 'OnWarning', tcText, tcCaption, tnSeconds )
		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )

			Throw loError
		Finally
			loError = Null
		Endtry
	Endproc && Warning

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Stop
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:46:00)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Stop( tcText As String, tcCaption As String ) As Void
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			Raiseevent( This, 'OnStop', tcText, tcCaption )
		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError
		Finally
			loError = Null
		Endtry
	Endproc && Stop

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Inform
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:47:07)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Inform( tcText As String, tcCaption As String, tnSeconds As Integer ) As Void
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			Raiseevent( This, 'OnInform', tcText, tcCaption, tnSeconds )
		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError
		Finally
			loError = Null
		Endtry
	Endproc && Inform

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Confirm
	*!* Description...:
	*!* Date..........: Martes 23 de Junio de 2009 (18:48:21)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Confirm( tcText As String, tcCaption As String, tcWavFile As String ) As Number
		Local lnReturn As Number
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			lnReturn = 0 && inicio la variable
			Raiseevent( This, 'OnConfirm', tcText, tcCaption, tcWavFile, lnReturn )
		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError
		Finally
			loError = Null
		Endtry
		Return lnReturn
	Endproc && Confirm


	*
	* cRootFolder_Access
	Protected Procedure cRootFolder_Access()

		Local lcCommand As String

		Try

			lcCommand = ""

			If Empty( This.cRootFolder )
				If !IsRuntime()
					Local lcCurdir As String

					lcCurdir = Set('DEFAULT') + Sys(2003)

					If FileExist( Addbs( lcCurdir ) + "WorkingFolder.Cfg" )
						loXA = Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

						loXA.LoadXML( Addbs( lcCurdir ) + "WorkingFolder.Cfg", .T. )
						loXA.Tables(1).ToCursor()
						loXA = Null

						This.cRootFolder = Alltrim( WorkingFolder )

						Use In Alias()

					Else
						Local loProject As PjHook Of "Tools\ProjectHook\Vcx\ProjectHookVss.vcx"
						Local lcProjectPath As String

						lcProjectPath = ""
						loProject = _vfp.ActiveProject

						lcProjectPath = Justpath( loProject.Name )

						This.cRootFolder = Addbs( lcProjectPath )
						loProject = Null

					Endif

				Endif

			Endif


		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loXA = Null

		Endtry

		Return This.cRootFolder

	Endproc && cRootFolder_Access

	*
	* cObjectFactoryFileName_Access
	Protected Procedure cObjectFactoryFileName_Access()

		If Empty( This.cObjectFactoryFileName )
			This.cObjectFactoryFileName = Addbs( This.cRootFolder ) + "ObjectFactoryCfg.xml"
		Endif

		Return This.cObjectFactoryFileName

	Endproc && cObjectFactoryFileName_Access







	*
	* Devuelve una instancia del objeto
	Procedure InstanciateEntity( tcEntityName As String,;
			tcTierLevel As String,;
			tnDataSessionId As Integer ) As Object;
			HELPSTRING "Devuelve una instancia del objeto"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve una instancia del objeto
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 15 de Mayo de 2009 (08:47:03)
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
			tcEntityName AS String
			tcTierLevel AS String
			tcObjectFactoryFileName AS String
			*:Remarks:
			Factory Method
			*:Returns:
			Object
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			Local loObjectFactory As ObjectFactory Of "FW\Comunes\Prg\ObjectFactory.prg"
			Local loEntity As TierAdapter Of "FW\TierAdapter\Comun\TierAdapter.prg"

			If Empty( tcTierLevel )
				If Pemstatus( This, "cTierLevel", 5 )
					tcTierLevel = This.cTierLevel

				Else
					tcTierLevel = "User"

				Endif
			Endif

			If Empty( tnDataSessionId )
				tnDataSessionId = Set( "Datasession" )
			Endif

			loObjectFactory = NewObjectFactory()

			loEntity = loObjectFactory.GetNewObject( tcEntityName, tcTierLevel, tnDataSessionId )

			If Lower( loEntity.cTierLevel ) <> Lower( "Service" )
				If Pemstatus( This, "lSerialize", 5 ) And This.lSerialize
					loEntity.lSerialize = This.lSerialize
					loEntity.DataSessionId = tnDataSessionId
				Endif
			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			loObjectFactory = Null

			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return loEntity

	Endproc && InstanciateEntity


	*
	* oEntitiesConfig_Access
	Protected Procedure oEntitiesConfig_Access()

		If Vartype( This.oEntitiesConfig ) # "O"
			*!*				This.oEntitiesConfig = Newobject( This.cApplicationName, ;
			*!*					Addbs( This.cRootFolder ) + "Prg\Ecfg_" + This.cApplicationName + ".prg" )

			This.oEntitiesConfig = NewEntitiesConfig()

		Endif

		Return This.oEntitiesConfig

	Endproc && oEntitiesConfig_Access



	*
	* oDataDictionary_Access
	Protected Procedure oDataDictionary_Access()

		If Vartype( This.oDataDictionary ) # "O"
			This.oDataDictionary = NewDataDictionary()
		Endif

		Return This.oDataDictionary

	Endproc && oDataDictionary_Access


	*
	* oForms_Access
	Protected Procedure oForms_Access()

		If Vartype( This.oForms ) # "O"
			This.oForms = NewColForms()

		Endif

		Return This.oForms

	Endproc && oForms

	*
	* oDataBases_Access
	Procedure oDataBases_Access()

		If Vartype( This.oDataBases ) # "O"
			This.oDataBases = NewColDataBases()

		Endif

		Return This.oDataBases

	Endproc && oDataBases_Access

	*
	* cApplicationName_Access
	Protected Procedure cApplicationName_Access()

		Local loProject As ProjectHook
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			If Empty( This.cApplicationName )
				If !IsRuntime()
					loProject = _vfp.ActiveProject
					This.cApplicationName = Juststem( loProject.Name )

				Else
					This.cApplicationName = This.oGlobalSettings.cApplicationName

				Endif

			Endif

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

			loProject = Null

		Endtry

		Return This.cApplicationName

	Endproc && cApplicationName_Access


	*
	* oGlobalSettings_Access
	Protected Procedure oGlobalSettings_Access()
		If Vartype( This.oGlobalSettings ) # "O"
			*!*				This.oGlobalSettings = Newobject( 'GlobalSettings', 'FW\Comunes\PRG\GlobalSettings.prg' )
			This.oGlobalSettings = NewGlobalSettings()
		Endif
		Return This.oGlobalSettings

	Endproc && oGlobalSettings_Access

	Procedure ProcessClause ( tcClause As String, tvOrigen, tcReplace As String  ) As String
		Local i As Integer
		Local lcRet As String
		Local lcMember As String
		Local Array lAmembers[ 1 ]
		Local Array lAFields[ 1 ]
		Local lnMax As Number

		Local lcType As String

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = 'ProcessClause: ' + Transform( tcClause )

			lcRet = Space( 1 ) + tcClause + Space( 1 )
			lcType = Vartype( tvOrigen )
			If Inlist( lcType, 'C', 'O' )

				Do Case
					Case lcType = 'C' And Used( tvOrigen )
						If Empty( tcReplace )
							tcReplace = tvOrigen + '.'

						Endif && Empty( tcReplace )

						lnMax = Afields( lAFields, tvOrigen )
						Asort( lAFields, 1, -1, 1, 1 )
						For i = 1 To lnMax
							lcField = Alltrim( lAFields[ i, 1 ] )
							lcRet = Strtran( lcRet, Space( 1 ) + lcField, Space( 1 ) + tcReplace + lcField, -1, -1, 1 )
							lcRet = Strtran( lcRet, "(" + lcField, "(" + tcReplace + lcField, -1, -1, 1 )

						Endfor

					Case lcType = 'O'
						If Empty( tcReplace )
							tcReplace = 'loItem.'

						Endif && Empty( tcReplace )

						lnMax = Amembers( lAmembers, tvOrigen )
						Asort( lAmembers, 1, -1, 1, 1 )
						For i = 1 To lnMax
							lcMember = Alltrim( lAmembers[ i ] )
							If !Inlist( Lower( lcMember ), "left", "height", "top", "width" )
								lcRet = Strtran( lcRet, Space( 1 ) + lcMember, Space( 1 ) + tcReplace + lcMember, -1, -1, 1 )
								lcRet = Strtran( lcRet, "(" + lcMember, "(" + tcReplace + lcMember, -1, -1, 1 )
							Endif

						Endfor

						If Pemstatus( tvOrigen, 'Class', 5 )
							lnMax = Amembers( lAmembers, tvOrigen.Class )
							Asort( lAmembers, 1, -1, 1, 1 )
							For i = 1 To lnMax
								lcMember = Alltrim( lAmembers[ i ] )

								If !Inlist( Lower( lcMember ), "left", "height", "top", "width" )
									lcRet = Strtran( lcRet, Space( 1 ) + lcMember, Space( 1 ) + tcReplace + lcMember, -1, -1, 1 )
									lcRet = Strtran( lcRet, "(" + lcMember, "(" + tcReplace + lcMember, -1, -1, 1 )
								Endif

							Endfor

						Endif

				Endcase

			Endif

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null
			loItem = Null

		Endtry

		Return Alltrim( lcRet )

	Endproc && ProcessClause

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AMembers
	*!* Description...:
	*!* Date..........: Jueves 30 de Julio de 2009 (00:41:25)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Amembers( tvAmembers As Variant @, tnArrayContentsId As Integer ) As Variant

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lnMax As Integer

		Try
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''

			If Empty( tnArrayContentsId )
				tnArrayContentsId = 0

			Endif && Empty( tnArrayContentsId )

			lnMax = Amembers( tvAmembers, This, tnArrayContentsId )


		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

		Endtry

		Return lnMax

	Endproc && AMembers

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: PemStatus
	*!* Description...:
	*!* Date..........: Jueves 30 de Julio de 2009 (00:47:07)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Pemstatus( tcProperty As String, tnAttribute As Integer ) As Variant
		Local lvRet As Variant

		If ! Empty( tcProperty )
			If Empty( tnAttribute )
				tnAttribute = 5

			Endif && Empty( tnAttribute )
			lvRet = Pemstatus( This, tcProperty, tnAttribute )

		Endif && ! Empty( tcProperty )

		Return lvRet

	Endproc && PemStatus

	* ToString
	Procedure ToString( tcTemplate As String ) As String

		Local lcString As String
		Local lcExpresion As String
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			*!*				Assert ( Lower( This.Name ) # '_recordorder' ) Message 'Es _recordorder'

			lcString = ""

			If Empty( tcTemplate )
				lcString = This.Name

			Else
				lcExpresion = This.ProcessClause( tcTemplate, This, "This." )
				lcString = Evaluate( lcExpresion )

			Endif && Empty( tcTemplate )

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			Try

				This.ResetError()

			Catch To oErr
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Process( oErr )
			Finally
				loError = Null
			Endtry

			*!*	loError = This.oError
			*!*	loError.cRemark = ''
			*!*	loError.cTraceLogin = ''
			loError = Null

		Endtry

		Return lcString

	Endproc && ToString

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ResetError
	*!* Description...: Reinicia la propiedades del objeto error
	*!* Date..........: Viernes 21 de Agosto de 2009 (13:56:21)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ResetError() As Void;
			HELPSTRING "Reinicia la propiedades del objeto error"

		This.oError.Reset()

	Endproc && ResetError

Enddefine && PrxCustom

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxCollection
*!* ParentClass...: collection
*!* BaseClass.....: collection
*!* Description...:
*!* Date..........: Domingo 16 de Abril de 2006 (20:55:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

*!*	Define Class PrxCollection As PrxSession Of "V:\Sistemas Praxis\Fw\Actual\Comun\Prg\Prxbaselibrary.prg"
Define Class PrxCollection As Collection

	#If .F.
		Local This As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
	#Endif

	*!* Nombre de la clase de los elementos que forman la coleccion
	cClassName = ""

	*!* Nombre de la librería de clases
	cClassLibrary = ""

	*!* Carpeta donde se encuentra la librería de clases
	cClassLibraryFolder = ""

	*!* Referencia al objeto principal
	oMainObject = Null

	*!* Referencia al Parent
	oParent = Null

	* Clase de manejo de errores
	oError = Null

	* Objeto error en XML
	cXMLoError = ""

	*	Flag de estado
	lIsOk = .T.

	DataSession = 0

	DataSessionId = 0

	cTierLevel = 'USER'

	lUseNameSpaces = .F.



	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lusenamespaces" type="property" display="lUseNameSpaces" />] + ;
		[<memberdata name="reseterror" type="method" display="ResetError" />] + ;
		[<memberdata name="cxmloerror" type="property" display="cXMLoError" />] + ;
		[<memberdata name="ctierlevel" type="property" display="cTierLevel" />] + ;
		[<memberdata name="cclasslibraryfolder" type="property" display="cClassLibraryFolder" />] + ;
		[<memberdata name="cclasslibrary" type="property" display="cClassLibrary" />] + ;
		[<memberdata name="cclassname" type="property" display="cClassName" />] + ;
		[<memberdata name="lisok" type="property" display="lIsOk" />] + ;
		[<memberdata name="oerror" type="property" display="oError" />] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[<memberdata name="omainobject" type="property" display="oMainObject" />] + ;
		[<memberdata name="omainobject_access" type="method" display="oMainObject_Access" />] + ;
		[<memberdata name="clear" type="method" display="Clear" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="getitem" type="method" display="GetItem" />] + ;
		[<memberdata name="removeitem" type="method" display="RemoveItem" />] + ;
		[<memberdata name="indexon" type="method" display="IndexOn" />] + ;
		[<memberdata name="getmin" type="method" display="GetMin" />] + ;
		[<memberdata name="getmain" type="method" display="GetMain" />] + ;
		[<memberdata name="instanciateentity" type="method" display="InstanciateEntity" />] + ;
		[<memberdata name="where" type="method" display="Where" />] + ;
		[<memberdata name="distinct" type="method" display="Distinct" />] + ;
		[<memberdata name="copyto" type="method" display="CopyTo" />] + ;
		[<memberdata name="moveto" type="method" display="MoveTo" />] + ;
		[<memberdata name="topquery" type="method" display="TopQuery" />] + ;
		[<memberdata name="sortby" type="method" display="SortBy" />] + ;
		[<memberdata name="select" type="method" display="Select" />] + ;
		[<memberdata name="getmax" type="method" display="GetMax" />] + ;
		[<memberdata name="bottomquery" type="method" display="BottomQuery" />] + ;
		[<memberdata name="processclause" type="method" display="ProcessClause" />] + ;
		[<memberdata name="recursive" type="method" display="Recursive" />] + ;
		[<memberdata name="tostring" type="method" display="ToString" />] + ;
		[<memberdata name="reverse" type="method" display="Reverse" />] + ;
		[<memberdata name="exist" type="method" display="Exist" />] + ;
		[</VFPData>]

	*!*		Procedure Init()
	*!*			Local lcCommand As String

	*!*			Try

	*!*				lcCommand = ""
	*!*				loApp 					= NewApp()
	*!*				This.lUseNameSpaces 	= loApp.lUseNameSpaces

	*!*			Catch To oErr
	*!*				Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	*!*				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	*!*				loError.cRemark = lcCommand
	*!*				loError.Process( oErr )
	*!*				Throw loError

	*!*			Finally
	*!*				loApp = Null

	*!*			Endtry


	*!*			Return .T.
	*!*		Endproc

	Procedure AddItem( teItem As Variant, tcKey As String, ;
			teBefore As Variant, teAfter As Variant )

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			Do Case
				Case Pcount() = 1
					This.Add( teItem )

				Case Pcount() = 2
					This.Add( teItem, Lower( tcKey ))

				Case Pcount() = 3
					This.Add( teItem, Lower( tcKey ), teBefore )

				Case Pcount() = 4
					This.Add( teItem, Lower( tcKey ), teBefore, teAfter )

				Otherwise
					This.Add( teItem, Lower( tcKey ), teBefore, teAfter )

			Endcase

		Catch To oErr
			* DAE 2009-11-11(12:53:25)
			*!*	loError = This.oError
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			Do Case
				Case Inlist( oErr.ErrorNo, 2062, 2064 )
					loError.cTraceLogin = "Key: " + Transform( tcKey )
					loError.cRemark = ""
				Otherwise

			Endcase

			loError.Process( oErr )
			Throw loError

		Finally
			* DAE 2009-11-11(12:53:58)
			*!*	loError = This.oError
			*!*	loError.cTraceLogin = ""
			*!*	loError.cRemark = ""
			loError = Null

		Endtry

	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetMain
	*!* Description...: Devuelve el objeto principal en la jerarquía de clases
	*!* Date..........: Martes 3 de Febrero de 2009 (11:57:16)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetMain(  ) As Object;
			HELPSTRING "Devuelve el objeto principal en la jerarquía de clases"

		Return This.oMainObject.GetMain()

	Endproc && GetMain

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oMainObject_Access
	*!* Date..........: Viernes 6 de Febrero de 2009 (13:32:47)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oMainObject_Access()

		If Vartype( This.oMainObject ) # "O"
			This.oMainObject = Createobject( "PrxSession" )

		Endif

		Return This.oMainObject

	Endproc && oMainObject_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetItem
	*!* Description...: Devuelve un elemento de la colección
	*!* Date..........: Martes 3 de Febrero de 2009 (12:57:58)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetItem( eIndex As Variant ) As Object;
			HELPSTRING "Devuelve un elemento de la colección"

		Local loItem As Object
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lcKey As String
		Local i As Integer
		Try

			loItem = Null

			Do Case
				Case Vartype( eIndex ) == "C"
					* DAE 2009-09-22(15:30:33)
					* Cambie StrTran para realizar la busqueda case-insensitive
					* no contemplaba Sys_ o SYS_
					* eIndex = Strtran( eIndex, "sys_", "" )
					eIndex = Strtran( eIndex, "sys_", "", -1, -1, 1 )

					i = This.GetKey( Lower( eIndex ) )

					*Assert !Empty( i ) Message "No se encontró el miembro de la colección"

					If ! Empty( i )
						loItem = This.Item( i )

					Endif && ! Empty( i )

				Case Vartype( eIndex ) == "N"
					*!*	                    lcKey =  This.GetKey( eIndex )

					*!*	                    If ! Empty( lcKey )
					*!*	                        loItem = This.Item( eIndex )

					*!*	                    Endif && ! Empty( lcKey )

					loItem = This.Item( eIndex )

				Otherwise
					Error "Error de tipo de datos"

			Endcase

		Catch To oErr
			* loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loItem

	Endproc && GetItem


	*
	*
	Procedure Exist( eIndex As Variant ) As Boolean
		Local lcCommand As String
		Local llExist As Boolean

		Try

			lcCommand = ""
			llExist = !Isnull( This.GetItem( eIndex ))

		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llExist

	Endproc && Exist

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: RemoveItem
	*!* Description...: Elimina un elemento de la colección
	*!* Date..........: Martes 3 de Febrero de 2009 (12:57:58)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure RemoveItem( eIndex As Variant ) As Object;
			HELPSTRING "Devuelve un elemento de la colección"

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loItem As Object
		Local i As Integer
		Local lcKey As String

		Try

			loItem = Null

			Do Case
				Case Vartype( eIndex ) == "C"
					i = This.GetKey( Lower( eIndex ) )

					If ! Empty( i )
						loItem = This.Remove( i )

					Endif && ! Empty( i )

				Case Vartype( eIndex ) == "N"
					lcKey =  This.GetKey( eIndex )

					If ! Empty( lcKey )
						loItem = This.Remove( eIndex )

					Endif && ! Empty( lcKey )

				Otherwise
					Error "Error de tipo de datos"

			Endcase

		Catch To oErr
			* loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loItem

	Endproc && RemoveItem

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Crea un elemento y lo agrega a la coleccion
	*!* Date..........: Martes 3 de Febrero de 2009 (12:39:44)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure New( tcName As String,;
			tcBefore As String,;
			tcKey As String ) As Object;
			HELPSTRING "Crea un elemento y lo agrega a la coleccion"

		Local loItem As Object
		Local lcKey As String
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try
			loError = This.oError
			loError.cRemark = ''

			loError.cTraceLogin = 'Validando el nombre del objeto'
			If Empty( tcName ) Or Vartype( tcName ) # "C"
				Error "Error de tipo en el parámetro cName"

			Endif && Empty( tcName ) Or Vartype( tcName ) # "C"

			tcName = Alltrim( tcName )

			loError.cTraceLogin = 'Creando el nuevo objeto'
			loItem = Newobject( This.cClassName,;
				Addbs( This.cClassLibraryFolder ) + This.cClassLibrary )

			loItem.Name = Proper( tcName )
			loItem.oParent = This

			If Empty( tcKey )
				tcKey = tcName
			Endif

			lcKey = Lower( tcKey )

			If Empty( tcBefore )
				loError.cTraceLogin = 'Agregando la clave ' + lcKey
				This.AddItem( loItem, lcKey )

			Else && Empty( tcBefore )
				loError.cTraceLogin = 'Agregando la clave ' + lcKey + ' antes de la clave ' + tcBefore
				This.AddItem( loItem, lcKey, Lower( tcBefore ) )

			Endif && Empty( tcBefore )

		Catch To oErr
			* loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError = This.oError
			* oErr.Message = lcKey + Chr( 13 ) + oErr.Message
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

		Endtry

		Return loItem

	Endproc && New

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Clear
	*!* Description...: Vacía la colección
	*!* Date..........: Martes 3 de Febrero de 2009 (13:11:14)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Clear(  ) As Void;
			HELPSTRING "Vacía la colección"

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			This.Remove( -1 )

		Catch To oErr
			* loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Clear

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Martes 3 de Febrero de 2009 (13:22:51)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy(  ) As Void

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			* This.Clear()
			This.Remove( - 1 )


			This.oMainObject = Null
			This.oParent = Null

			Unbindevents( This )

			DoDefault()

		Catch To oErr
			loError = This.oError
			loError.Process( oErr )
			Throw loError

		Finally
			loError = Null
			This.oError = Null

		Endtry

	Endproc && Destroy

	*!*	*!* ///////////////////////////////////////////////////////
	*!*	*!* Procedure.....: IndexOn
	*!*	*!* Description...: Ordena la colección
	*!*	*!* Date..........: Martes 3 de Febrero de 2009 (16:48:09)
	*!*	*!* Author........: Ricardo Aidelman
	*!*	*!* Project.......: Sistemas Praxis
	*!*	*!* -------------------------------------------------------
	*!*	*!* Modification Summary
	*!*	*!* R/0001  -
	*!*	*!*
	*!*	*!*
	*!*	Procedure IndexOn( tcIndexProperty As String, tlSortDesc As Boolean ) As Void;
	*!*			HELPSTRING "Ordena la colección"
	*!*		Local loCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
	*!*		Local loBkUpCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
	*!*		Local loObj As Object
	*!*		Local i As Integer
	*!*		Local llOk As Boolean
	*!*		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	*!*		Local lcKey As String
	*!*		Local llAdd As Boolean
	*!*		Try
	*!*			loError = This.oError
	*!*			loError.cTraceLogin = 'Inicio variables locales y objetos'
	*!*			If Empty( tcIndexProperty )
	*!*				tcIndexProperty = "IndexTab"
	*!*			Endif && Empty( tcIndexProperty )
	*!*			llOk = .T.
	*!*			loCol = Newobject( This.Class, This.ClassLibrary )

	*!*			loBkUpCol = Newobject( This.Class, This.ClassLibrary )
	*!*			* BackUp
	*!*			loError.cTraceLogin = 'Realizo el BackUp de la colección'
	*!*			This.CopyTo( loBkUpCol )
	*!*			i = -1
	*!*			loError.cRemark = 'Proceso todos los elementos de la colección'
	*!*			Do While i # 0
	*!*				If tlSortDesc
	*!*					loError.cTraceLogin = 'Busco el maximo para ordenar en forma descendente'
	*!*					i = This.GetMax( tcIndexProperty )
	*!*				Else
	*!*					loError.cTraceLogin = 'Busco el minimo para ordenar en forma ascendente'
	*!*					i = This.GetMin( tcIndexProperty )
	*!*				Endif && tlSortDesc
	*!*				If ! Empty( i )
	*!*					loObj = This.Item( i )
	*!*					lcKey = This.GetKey( i )
	*!*					If Pemstatus( loObj, 'Visible', 5 )
	*!*						llAdd = loObj.Visible
	*!*					Else && Pemstatus( loObj, 'Visible', 5 )
	*!*						llAdd = .T.
	*!*					Endif && Pemstatus( loObj, 'Visible', 5 )
	*!*					If llAdd
	*!*						If Empty( lcKey ) And Pemstatus( loObj, 'Name', 5 )
	*!*							lcKey = Lower( loObj.Name )
	*!*						Endif && Empty( lcKey ) And Pemstatus( loObj, 'Name', 5 )
	*!*						loCol.AddItem( loObj, lcKey )
	*!*					Endif && llAdd
	*!*					This.RemoveItem( i )
	*!*				Endif && ! Empty( i )
	*!*			Enddo
	*!*			loError.cRemark = 'Proceso todos los elementos restantes de la colección'

	*!*			This.MoveTo( loCol )

	*!*			loError.cRemark = 'Agrego los elementos ordenados en la colección'
	*!*			loCol.MoveTo( This, .T. )
	*!*		Catch To oErr
	*!*			loError = This.oError
	*!*			This.cXMLoError = loError.Process( oErr )
	*!*			loBkUpCol.MoveTo( This, .T. )
	*!*			Throw loError

	*!*		Finally
	*!*			loError = This.oError
	*!*			loError.cRemark = ''
	*!*			loError.cTraceLogin = ''
	*!*			loError = Null
	*!*			loBkUpCol.Remove( -1 )
	*!*			loBkUpCol = Null
	*!*			loCol.Remove( -1 )
	*!*			loCol = Null
	*!*			loObj = Null

	*!*		Endtry
	*!*	Endproc && IndexOn

	*
	* IndexOn
	Procedure IndexOn( tcIndexProperty As String, tlSortDesc As Boolean ) As Void ;
			HELPSTRING "Ordena la colección"

		Local loColToSort As Collection
		Local loColWrapper As Collection
		Local loBkUpCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loObjWrapper As Object
		Local loItem As Object
		*
		Local i As Integer
		Local lnIndex As Integer
		*
		Local lcKey As String
		*
		Local llOk As Boolean
		Local llAdd As Boolean

		Try
			loError = This.oError
			loError.cTraceLogin = 'Inicio variables locales y objetos'
			If Empty( tcIndexProperty )
				tcIndexProperty = "IndexTab"

			Endif && Empty( tcIndexProperty )

			llOk = .T.

			loColToSort = Newobject( 'Collection' )
			loBkUpCol = Newobject( This.Class, This.ClassLibrary )

			* BackUp
			loError.cTraceLogin = 'Realizo el BackUp de la colección'
			This.CopyTo( loBkUpCol )

			loError.cRemark = 'Proceso todos los elementos de la colección'
			For i = 1 To This.Count
				loItem = This.Item[ i ]
				lcKey = This.GetKey( i )

				If Vartype( loItem.&tcIndexProperty ) == "N"
					lcKeyOrder = StrZero( loItem.&tcIndexProperty, 6 )

				Else
					lcKeyOrder = Lower( Transform( loItem.&tcIndexProperty ) )

				Endif

				loObjWrapper = CreateObjParam( 'oItem', loItem, 'cKey', lcKey, 'nIndex', i )

				* Busco la colección Wrapper
				lnIndex = loColToSort.GetKey( lcKeyOrder )
				If Empty( lnIndex )
					loColWrapper = Newobject( 'Collection' )

					* Agrego el elemento a la colección
					loColWrapper.Add( loObjWrapper )

					* Agrego la colección wrapper en la colección
					loColToSort.Add( loColWrapper, lcKeyOrder )

				Else
					loColWrapper = loColToSort.Item[ lnIndex ]

					* Agrego el elemento a la colección
					loColWrapper.Add( loObjWrapper )

				Endif

			Endfor

			loColToSort.KeySort = Iif( tlSortDesc, KEYDESCENDING, KEYASCENDING )
			This.Clear()
			For Each loColWrapper In loColToSort
				For i = 1 To loColWrapper.Count
					loObjWrapper = loColWrapper.Item[ i ]
					This.Add( loObjWrapper.oItem, loObjWrapper.cKey )

				Endfor

			Endfor

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			loBkUpCol.MoveTo( This, .T. )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''

			loError = Null
			loObjWrapper = Null
			loItem = Null

			Try
				loBkUpCol.Remove( -1 )
			Catch To oErr
			Endtry
			Try
				loColToSort.Remove( -1 )
			Catch To oErr
			Endtry
			Try
				loColWrapper.Remove( -1 )
			Catch To oErr
			Endtry

			loColToSort = Null
			loColWrapper= Null
			loBkUpCol = Null

		Endtry

	Endproc && IndexOn

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetMax
	*!* Description...: Devuelve el objeto cuyo valor de indice alternativo es el mayor
	*!* Date..........: Lunes 6 de Julio de 2009
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure GetMax( tcIndexProperty As String ) As Integer;
			HELPSTRING "Devuelve el objeto cuyo valor de indice alternativo es el menor"

		Local lnIndex As Integer
		Local lvMaxValue As Variant
		Local lvValue As Variant
		Local i As Integer
		Local loObj As Object
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			If Empty( tcIndexProperty )
				tcIndexProperty = "IndexTab"

			Endif && Empty( tcIndexProperty )

			lnIndex = 0

			If This.Count > 1
				loObj = This.Item( 1 )
				lnIndex = 1
				If Pemstatus( loObj, tcIndexProperty, 5 )
					lvMaxValue = Evaluate( "loObj." + tcIndexProperty )

				Endif && Pemstatus( loObj, tcIndexProperty, 5 )

				For i = 1 To This.Count
					loObj = This.Item( i )

					If Pemstatus( loObj, tcIndexProperty, 5 )
						lvValue = Evaluate( "loObj." + tcIndexProperty )

						If lvValue > lvMaxValue
							lvMaxValue = lvValue
							lnIndex = i

						Endif && lvValue < lvMaxValue

					Endif && Pemstatus( loObj, tcIndexProperty, 5 )

				Endfor

			Endif && This.Count > 1

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loObj = Null

		Endtry

		Return lnIndex

	Endproc && GetMax

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetMin
	*!* Description...: Devuelve el objeto cuyo valor de indice alternativo es el mayor
	*!* Date..........: Lunes 6 de Julio de 2009
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure GetMin( tcIndexProperty As String ) As Integer;
			HELPSTRING "Devuelve el objeto cuyo valor de indice alternativo es el menor"

		Local lnIndex As Integer
		Local lvMinValue As Variant
		Local lvValue As Variant
		Local i As Integer
		Local loObj As Object
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			If Empty( tcIndexProperty )
				tcIndexProperty = "IndexTab"

			Endif && Empty( tcIndexProperty )

			lnIndex = 0

			If This.Count > 1
				loObj = This.Item( 1 )
				lnIndex = 1
				If Pemstatus( loObj, tcIndexProperty, 5 )
					lvMinValue = Evaluate( "loObj." + tcIndexProperty )

				Endif && Pemstatus( loObj, tcIndexProperty, 5 )

				For i = 1 To This.Count
					loObj = This.Item( i )

					If Pemstatus( loObj, tcIndexProperty, 5 )
						lvValue = Evaluate( "loObj." + tcIndexProperty )

						If lvValue < lvMinValue
							lvMinValue = lvValue
							lnIndex = i

						Endif && lvValue < lvMinValue

					Endif && Pemstatus( loObj, tcIndexProperty, 5 )

				Endfor

			Endif && This.Count > 1

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loObj = Null

		Endtry

		Return lnIndex

	Endproc && GetMin

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oParent_Assign
	*!* Date..........: Martes 3 de Febrero de 2009 (11:52:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oParent_Assign( uNewValue )

		If Vartype( uNewValue ) # "O"
			uNewValue = Null

		Endif && Vartype( uNewValue ) # "O"

		This.oParent = uNewValue

	Endproc && oParent_Assign

	* ///////////////////////////////////////////////////////
	* Procedure.....: oError_Access
	* Date..........: Sábado 18 de Abril de 2009 (20:18:12)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure oError_Access()
		Try

			If Vartype( This.oError ) # "O"
				This.oError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

				* Por defecto, todas las capas tiene habilitada la posibilidad de loguear el error
				* El objeto ErrorHandler loguea el error en el proceso en el que se produce, y luego
				* bloquea los logueos subsiguientes.
				* Solo en la UserTier se muestra el error al usuario
				This.oError.TierBehavior = EH_LOGERROR
				This.oError.cTierLevel = This.cTierLevel
			Endif

		Catch To oErr
			This.lIsOk = .F.
			Throw oErr

		Finally

		Endtry

		Return This.oError

	Endproc && oError_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Where
	*!* Description...: Devuelve un sub conjunto de la colección
	*!* Date..........: Lunes 6 de Julio de 2009 (18:54:49)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Where( tvColFilters As Variant,;
			tlSetExact As Boolean ) As PrxCollection Of FW\TierAdapter\Comun\prxbaselibrary.prg ;
			HELPSTRING "Devuelve un sub conjunto de la colección"

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loRet As Object
		Local loItem As Object
		Local llOk As Boolean
		Local loFilter As oFilter Of
		Local lcKey As String
		Local lcField As String
		Local lcOperator As String
		Local lcExpr As String
		Local lcSetExact As String
		Local llIsString As Boolean
		Local lcClassAnt As String
		Local loMainObject As PrxSession Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"

		Try
			lcSetExact = Set( "Exact" )
			If tlSetExact
				Set Exact On

			Else
				Set Exact Off

			Endif && tlSetExact

			* Tomo el objeto de error para agregar guardar las expresiones que voy a evaluar
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loMainObject = This.oMainObject
			loRet = Newobject( This.Class, This.ClassLibrary )

			llIsString = ( Vartype( tvColFilters ) = 'C' )
			If llIsString And ( This.Count > 0 )
				loItem = This.Item( 1 )
				lcKey = This.GetKey( 1 )
				lcExpr =  loMainObject.ProcessClause( tvColFilters, loItem, 'loItem.' )
				lcClassAnt = Lower( loItem.Class )
				If .F. && DAE 2009-10-22
					loError.cTraceLogin = 'Evaluando ' + lcKey + Chr( 13 ) ;
						+ printf( 'item: %s class: %s exp: %s', loItem.Name, loItem.Class, lcExpr )
				Endif && .F. && DAE 2009-10-22
			Endif && llIsString and This.Count > 0
			For i = 1 To This.Count
				loItem = This.Item( i )
				lcKey = This.GetKey( i )
				loError.cTraceLogin = 'Evaluando ' + lcKey
				llOk = .T.
				If llIsString
					If .F. && DAE 2009-10-22
						If lcClassAnt # Lower( loItem.Class )
							lcExpr = loMainObject.ProcessClause( tvColFilters, loItem, 'loItem.' )
							lcClassAnt = Lower( loItem.Class )
							loError.cTraceLogin = loError.cTraceLogin + Chr( 13 ) ;
								+ printf( 'item: %s class: %s exp: %s', loItem.Name, loItem.Class, lcExpr )

						Endif && lcClassAnt # Lower( loItem.Class )
					Endif && .F. && DAE 2009-10-22
					llOk = llOk And Evaluate( lcExpr )

				Else
					For Each loFilter In tvColFilters
						* lcExpr = [loItem.] + loFilter.cField + loFilter.cOperator + loFilter.cExpr
						lcExpr = Strtran( loFilter.cFieldExp, '<#FIELD#>', 'loItem.' + loFilter.cField )  + loFilter.cOperator + loFilter.cExpr
						loError.cTraceLogin = loError.cTraceLogin + Chr( 13 ) + lcExpr
						llOk = llOk And Evaluate( lcExpr )

					Endfor

				Endif && llIsString
				If llOk
					If Empty( lcKey ) And Vartype( loItem ) = 'O' And Pemstatus( loItem, 'Name', 5 )
						lcKey = Lower( loItem.Name )

					Endif && Empty( lcKey ) And Pemstatus( loObj, 'Name', 5 )

					loRet.AddItem( loItem, lcKey )

				Endif && llOk

			Endfor

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

			loMainObject = Null
			loItem = Null

			Set Exact &lcSetExact

		Endtry

		Return loRet
	Endproc && Where

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Distinct
	*!* Description...:
	*!* Date..........: Viernes 17 de Julio de 2009 (16:36:26)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Distinct( tcProperty As String ) As Void

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loBkUpCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loColDuplicates As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loItem As Object

		Try

			If Empty( tcProperty )
				tcProperty = 'Name'

			Endif && Empty( tcProperty )

			loColDuplicates = Newobject( "PrxCollection", "PrxBaseLibrary.prg" )
			loCol = Newobject( "PrxCollection", "PrxBaseLibrary.prg" )
			loBkUpCol = Newobject( This.Class, This.ClassLibrary )

			With This As PrxCollection Of FW\TierAdapter\Comun\prxbaselibrary.prg
				.CopyTo( loBkUpCol )

				For i = 1 To .Count
					loItem = .Item( i )
					Try
						If Vartype( loItem ) = 'O' And Pemstatus( loItem, tcProperty, 5 )
							loCol.AddItem( loItem.&tcProperty., loItem.&tcProperty. )

						Endif && Vartype( loItem ) = 'O' And Pemstatus( loItem, tcProperty, 5 )

					Catch To oErr
						loColDuplicates.AddItem( i )

					Endtry

				Endfor

				For i = loColDuplicates.Count To 1 Step - 1
					.Remove( loColDuplicates.Item ( i ) )

				Endfor

			Endwith

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Try
				loBkUpCol.MoveTo( This, .T. )
			Catch To oErr
			Endtry

			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

			loBkUpCol.Remove( - 1 )
			loBkUpCol = Null

			loColDuplicates.Remove( - 1 )
			loColDuplicates = Null

			loCol.Remove( - 1 )
			loCol = Null

			loItem = Null

		Endtry

	Endproc && Distinct

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CopyTo
	*!* Description...: Copia la colección a la colección destino
	*!* Date..........: Domingo 2 de Agosto de 2009 (16:24:30)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure CopyTo( toCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg", ;
			tlCLearDest As Boolean, ;
			tlCLearOrig As Boolean ) As Void;
			HELPSTRING "Copia la colección a la colección destino"


		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''

			If tlCLearDest
				toCol.Remove( - 1 )

			Endif && tlCLear

			For i = 1 To This.Count
				loObj = This.Item( i )
				lcKey = This.GetKey( i )
				If Empty( lcKey ) And Vartype( loObj ) = 'O' And Pemstatus( loObj, 'Name', 5 )
					lcKey = Lower( loObj.Name )

				Endif && Empty( lcKey ) And Pemstatus( loObj, 'Name', 5 )

				toCol.AddItem( loObj, lcKey )

			Endfor

			If tlCLearOrig
				This.Remove( - 1 )

			Endif

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

		Endtry

	Endproc && CopyTo

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: MoveTo
	*!* Description...: Mueve los datos de la colección a la colección destino
	*!* Date..........: Domingo 2 de Agosto de 2009 (16:24:30)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure MoveTo( toCol As Collection, tlCLearDest As Boolean ) As Void;
			HELPSTRING "Copia la colección a la colección destino"

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''

			This.CopyTo( toCol, tlCLearDest, .T. )

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

		Endtry

	Endproc && MoveTo

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: TopQuery
	*!* Description...:
	*!* Date..........: Domingo 2 de Agosto de 2009 (16:58:40)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function TopQuery( tnTop As Number, tlPercent As Boolean ) As PrxCollection Of FW\TierAdapter\Comun\prxbaselibrary.prg
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColRet As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loObj As Object
		Local lcKey As String
		Local lnTop As Number

		Try
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			Do Case
				Case Vartype( tnTop ) # 'N'
					Error 9 && Data type mismatch

				Case tnTop < 1
					* tnTop = This.Count
					Error 'Zero or negative used as argument.'

				Otherwise
					If tlPercent And tnTop > 100
						Error 'Invalid TOP specification'

					Endif && tlPercent And tnTop > 100

			Endcase

			loColRet = Newobject( This.Class, This.ClassLibrary )
			If tlPercent
				lnTop = tnTop * This.Count / 100

			Else
				lnTop = tnTop

			Endif && tlPercent
			lnTop = Min( lnTop, This.Count )

			For i = 1 To lnTop
				loObj = This.Item( i )
				lcKey = This.GetKey( i )
				If Empty( lcKey ) And Vartype( loObj ) = 'O' And Pemstatus( loObj, 'Name', 5 )
					lcKey = Lower( loObj.Name )

				Endif && Empty( lcKey ) And Pemstatus( loObj, 'Name', 5 )

				loColRet.AddItem( loObj, lcKey )

			Endfor

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null
			loObj = Null

		Endtry

		Return loColRet

	Endproc && TopQuery

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Top
	*!* Description...:
	*!* Date..........: Domingo 12 de Agosto de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function BottomQuery( tnTop As Number, tlPercent As Boolean, tlInvert As Boolean ) As PrxCollection Of FW\TierAdapter\Comun\prxbaselibrary.prg
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColRet As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loObj As Object
		Local lcKey As String
		Local lnTop As Number

		Try
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			Do Case
				Case Vartype( tnTop ) # 'N'
					Error 9 && Data type mismatch

				Case tnTop < 1
					* tnTop = This.Count
					Error 'Zero or negative used as argument.'

				Otherwise
					If tlPercent And tnTop > 100
						Error 'Invalid TOP specification'

					Endif && tlPercent And tnTop > 100

			Endcase

			loColRet = Newobject( This.Class, This.ClassLibrary )

			If tlPercent
				lnTop = tnTop * This.Count / 100

			Else
				lnTop = tnTop

			Endif && tlPercent
			lnTop = Max( Min( lnTop, This.Count ), 1 )

			For i = lnTop To This.Count
				loObj = This.Item( i )
				lcKey = This.GetKey( i )
				If Empty( lcKey ) And Vartype( loObj ) = 'O' And Pemstatus( loObj, 'Name', 5 )
					lcKey = Lower( loObj.Name )

				Endif && Empty( lcKey ) And Pemstatus( loObj, 'Name', 5 )

				loColRet.AddItem( loObj, lcKey )

			Endfor

			If tlInvert
				loColRet = loColRet.Reverse()

			Endif && tlInvert

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null
			loObj = Null

		Endtry

		Return loColRet

	Endproc && BottomQuery


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SortBy
	*!* Description...:
	*!* Date..........: Domingo 2 de Agosto de 2009 (17:26:38)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function SortBy( tvSortBy As Variant ) As PrxCollection Of FW\TierAdapter\Comun\prxbaselibrary.prg;
			HELPSTRING "Devuelve una colección ordenada según los parametros"

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local llIsString As Boolean
		Local lcExp As String
		Local lcExp2 As String
		Local lnOccurs As Integer
		Local llSortDesc As Boolean
		Local loColRet As PrxCollection Of FW\TierAdapter\Comun\prxbaselibrary.prg
		Local i As Integer

		Try
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			llIsString = ( Vartype( tvSortBy ) = 'C' )
			loColRet = Newobject( This.Class, This.ClassLibrary )
			This.CopyTo( loColRet )

			If llIsString
				* tvSortBy = Alltrim( tvSortBy )
				lnOccurs = Getwordcount( tvSortBy, ',' )
				For i = lnOccurs To 1 Step -1
					llSortDesc = .F.
					lcExp = Getwordnum( tvSortBy, i, ',' )
					If Getwordcount( lcExp ) > 1
						lcExp2 = Alltrim( Getwordnum( lcExp, 2) )
						lcExp2 = Left( Lower( lcExp2 ), 3 )
						llSortDesc = (  lcExp2 == 'des' )

					Endif && Getwordcount( lcExp ) > 1

					loColRet.IndexOn( Getwordnum( lcExp, 1 ), llSortDesc )

				Endfor
			Else
				Error 'No implementado'

			Endif && llIsString

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

		Endtry

		Return loColRet

	Endproc && SortBy

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Select
	*!* Description...: Devuelve una colección de objetos nuevos con propiedades
	*!* 				selecionadas de los elementos de la colección
	*!* Date..........: Domingo 2 de Agosto de 2009 (17:46:25)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Select( tvSelect As Variant  ) As PrxCollection Of FW\TierAdapter\Comun\prxbaselibrary.prg;
			HELPSTRING "Devuelve una colección de objetos nuevos con propiedades selecionadas de los elementos de la colección"

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local llIsString As Boolean
		Local loColRet As PrxCollection Of FW\TierAdapter\Comun\prxbaselibrary.prg
		Local loObj As Object
		Local lcKey As String
		Local loNewObj As Object
		Local lcExp As String

		Try
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''

			loColRet = Newobject( This.Class, This.ClassLibrary )
			* Assert tvSelect Message 'No se recibio ningún parametro'
			llIsString = ( Vartype( tvSelect ) = 'C' ) Or Pcount() = 0

			If llIsString
				If Empty( tvSelect )
					tvSelect = '*'

				Endif
				tvSelect = Alltrim( tvSelect )
				If tvSelect = '*'
					This.CopyTo( loColRet )

				Else

					For i = 1 To This.Count
						loObj = This.Item( i )
						lcKey = This.GetKey( i )
						loNewObj = Createobject( 'Empty' )
						For j = 1 To Getwordcount( tvSelect, ',' )
							lcExp = Getwordnum( tvSelect, j, ',' )
							lcExp = Strtran( lcExp, Space( 2 ), Space( 1 ) )
							lcExp = Strtran( lcExp, '(' + Space( 1 ), '(' )
							lcExp = Strtran( lcExp, Space( 1 ) + ')', ')' )
							lcProp = Getwordnum( lcExp, 1 )
							lcExpProp = This.oMainObject.ProcessClause( lcProp, @loObj, 'loObj.' )

							If Getwordcount( lcExp ) > 1
								lcPropAlias = Alltrim( Getwordnum( lcExp, 2 )  )

							Else
								lcPropAlias = Alltrim( lcProp )

							Endif && GetWordCount( lcExp ) > 1

							AddProperty( loNewObj, lcPropAlias,	&lcExpProp. )

						Endfor
						If Empty( lcKey ) And Vartype( loObj ) = 'O' And Pemstatus( loObj, 'Name', 5 )
							lcKey = Lower( loObj.Name )

						Endif && Empty( lcKey ) And Pemstatus( loObj, 'Name', 5 )
						loColRet.AddItem( loNewObj, lcKey )

					Endfor

				Endif && tvSelect = '*'

			Else
				Error 'No implementado'

			Endif && llIsString

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

			loObj = Null
			loNewObj = Null

		Endtry

		Return loColRet

	Endfunc && Select

	* @TODO Damian Eiff 2009-08-01 (01:30:17) Proc Query

	*
	* Query
	Procedure Query( tcDistinct As String,  ;
			tnTop As Number, ;
			tlPercent As Boolean, ;
			tcSelect As String, ;
			tcWhere As String, ;
			tlSetExact As Boolean, ;
			tcSortBy As String ) As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"

		Local loColRet As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			If ! Empty( tcWhere )
				loColRet = This.Where( tcWhere, tlSetExact )

			Else
				loColRet = This

			Endif && ! Empty( tcWhere )

			If ! Empty( tcDistinct )
				loColRet = loColRet.Distinct( tcDistinct )

			Endif && ! Empty( tcDistinct )

			If ! Empty( tcSortBy )
				loColRet = loColRet.SortBy( tcSortBy )

			Endif && ! Empty( tcSortBy )

			If ! Empty( tnTop )
				loColRet = loColRet.TopQuery( tnTop, tlPercen )

			Endif && ! Empty( tnTop )

			If ! Empty( tcSelect )
				loColRet = loColRet.Select( tcSelect )

			Endif &&  ! Empty( tcSelect )

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null

		Endtry

		Return loColRet

	Endproc && Query

	Procedure ToString( tcTemplate As String,;
			tcSeparador As String,;
			tcWhere As String ) As String

		Local i As Integer
		Local lnCount As Integer
		*
		Local lcString As String
		Local lcExpresion As String
		Local lcExp As String
		*
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loItem As Object

		Try

			lcString = ""

			If Empty( tcSeparador ) Or Vartype( tcSeparador ) # "C"
				tcSeparador = ","

			Endif

			If Empty( tcTemplate ) Or Vartype( tcTemplate ) # "C"
				tcTemplate = ""
			Endif

			If Empty( tcWhere )
				loCol = This

			Else
				loCol = This.Where( tcWhere )

			Endif && tcWhere

			lnCount = loCol.Count

			For i = 1 To lnCount
				* loItem = loCol.Item( i )
				loItem = loCol.Item[ i ]
				If Vartype( loItem ) = 'O'
					If Pemstatus( loItem, 'ToString', 5 )
						lcString = lcString + loItem.ToString( tcTemplate )

					Else && Pemstatus( loItem, 'ToString', 5 )
						lcExp = This.ProcessClause( tcTemplate, loItem, 'loItem.' )
						loItem = loCol.Item[ i ]
						* lcString = lcString + Evaluate( lcExp )
						TEXT To lcString NoShow TextMerge Additive
						<<Evaluate( lcExp )>>
						ENDTEXT

					Endif && Pemstatus( loItem, 'ToString', 5 )

					If i # lnCount
						lcString = lcString + tcSeparador

					Endif && i # lnCount

				Endif &&  Vartype( loItem ) = 'O'

			Endfor

		Catch To oErr
			* loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr )
			Throw loError

		Finally
			loCol = Null
			loItem = Null

			loError = This.oError
			loError.cTraceLogin = ""
			loError.cRemark = ""
			loError = Null

		Endtry

		Return lcString

	Endproc && ToString

	* ProcessClause
	Procedure ProcessClause ( tcClause As String, tvOrigen, tcReplace As String  ) As String

		Return This.oMainObject.ProcessClause ( tcClause, tvOrigen, tcReplace )

	Endproc && ProcessClause

	*
	* Recorre la colección ejecutando un comando para cada elemento
	Procedure Recursive( toCol As Collection, ;
			tcPropertieOrMethod As String, ;
			tcMethodToCall As String, ;
			tvParam As Variant, ;
			tcEndCondition As String, ;
			tcItemEndCondition As String, ;
			tlDescending As Boolean ) As Boolean;
			HELPSTRING "Recorre la colección ejecutando un comando para cada elemento"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Recorre la colección ejecutando un comando para cada elemento
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Miércoles 12 de Agosto de 2009
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
			toCol As Collection
			tcPropertieOrMethod As String
			tcMethodToCall As String
			tvParam As Variant
			tcEndCondition As String
			tcItemEndCondition As String
			tlDescending As Boolean
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local loItem As Object
		Local i As Integer
		Local lcEndCondition As String
		Local lcItemEndCondition As String
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			loError = This.oError
			loError.cTraceLogin = ""
			loError.cRemark = ""

			If Vartype( toCol ) # "O"
				toCol = This

			Endif && Vartype( toCol ) = "O"

			If Empty( tcEndCondition )
				tcEndCondition = '.F.'

			Endif && Empty( tcEndCondition )


			If Empty( tcItemEndCondition )
				tcItemEndCondition = '.F.'

			Endif && Empty( tcEndCondition )


			If ! Empty( tcPropertieOrMethod )

				lcEndCondition = This.ProcessClause( tcEndCondition, This, 'This.' )

				If ! Evaluate( lcEndCondition )

					If toCol.Count > 0
						i = 1

						loItem = toCol.Item( 1 )
						lcItemEndCondition = This.ProcessClause( tcItemEndCondition, loItem, 'loItem.' )
						Do While i <= toCol.Count And ! Evaluate( lcItemEndCondition )
							loItem = toCol.Item( i )
							lcItemEndCondition = This.ProcessClause( tcItemEndCondition, loItem, 'loItem.' )

							If Vartype( loItem ) = 'O'

								If tlDescending
									If This.lIsOk And Pemstatus( loItem, tcPropertieOrMethod, 5 )
										This.Recursive( loItem.&tcPropertieOrMethod., ;
											tcPropertieOrMethod, ;
											tcMethodToCall, ;
											tvParam, ;
											tcEndCondition, ;
											tcItemEndCondition, ;
											tlDescending )
									Endif && This.lIsOk
								Endif

								If This.lIsOk
									This.&tcMethodToCall.( loItem, tvParam )

								Endif && This.lIsOk

								If ! tlDescending
									If This.lIsOk And Pemstatus( loItem, tcPropertieOrMethod, 5 )
										This.Recursive( loItem.&tcPropertieOrMethod., ;
											tcPropertieOrMethod, ;
											tcMethodToCall, ;
											tvParam, ;
											tcEndCondition, ;
											tcItemEndCondition, ;
											tlDescending )

									Endif && This.lIsOk

								Endif && ! tlDescending

							Endif && Vartype( loItem ) = 'O'

							i = i + 1

						Enddo

					Endif && toCol.Count > 0

				Endif && ! Evaluate( lcEndCondition )

			Endif && ! Empty( tcPropertieOrMethod )

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif

		Finally
			If ! This.lIsOk
				Throw This.oError

			Endif && ! This.lIsOk

		Endtry

		Return This.lIsOk

	Endproc && Recursive

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Reverse
	*!* Description...:
	*!* Date..........: Miercoles 12 de Agosto de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Reverse() As PrxCollection Of FW\TierAdapter\Comun\prxbaselibrary.prg
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColRet As Collection
		Local loObj As Object
		Local lcKey As String

		Try
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''

			loColRet = Newobject( This.Class, This.ClassLibrary )

			For i = This.Count To 1 Step - 1
				loObj = This.Item( i )
				lcKey = This.GetKey( i )
				If Empty( lcKey ) And Vartype( loObj ) = 'O' And Pemstatus( loObj, 'Name', 5 )
					lcKey = Lower( loObj.Name )

				Endif && Empty( lcKey ) And Pemstatus( loObj, 'Name', 5 )

				loColRet.AddItem( loObj, lcKey )

			Endfor

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.cRemark = ''
			loError.cTraceLogin = ''
			loError = Null
			loObj = Null

		Endtry

		Return loColRet

	Endproc && Reverse

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ResetError
	*!* Description...: Reinicia la propiedades del objeto error
	*!* Date..........: Viernes 21 de Agosto de 2009 (13:56:21)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ResetError() As Void;
			HELPSTRING "Reinicia la propiedades del objeto error"

		This.oError.Reset()

	Endproc && ResetError

Enddefine && PrxCollection

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxColumnBase
*!* ParentClass...: Column
*!* BaseClass.....: Column
*!* Description...:
*!* Date..........: Miercoles 1 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxColumnBase As Column

	#If .F.
		Local This As PrxColumnBase Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
	#Endif

	FontSize = Iif( Vartype( _Screen.oApp ) == "O", 9 + _Screen.oApp.nUpdateFontSize, 9 )

	DynamicBackColor = TA_DynamicBackColor
	ColumnControlSource = ""

	*!* Referencia al objeto principal
	oMainObject = Null

	*!* Referencia al Parent
	oParent = Null

	*!* Referencia al Control Header
	oHeader = Null

	*!* Referencia al Indice del Vector de controles de la grilla que contiene a la columna
	nIndex = 0

	*!* Identificador unico de la columna
	Id = Sys( 2015 )

	Resizable = .T.


	* Contiene el valor del Value de control activo
	Value = 0

	* Expresión de indice por el que se ordena la columna
	cIndexExpression = ""

	cTextControlName 	= "prxText"
	cTextControlLibrary = "Fw\Tieradapter\Comun\prxBaseLibrary.prg"
	cCurrentControlName = "prxText1"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="columncontrolsource" type="property" display="ColumnControlSource" />] + ;
		[<memberdata name="columncontrolsource_access" type="method" display="ColumnControlSource_Access" />] + ;
		[<memberdata name="getmain" type="method" display="GetMain" />] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[<memberdata name="omainobject" type="property" display="oMainObject" />] + ;
		[<memberdata name="omainobject_access" type="method" display="oMainObject_Access" />] + ;
		[<memberdata name="oheader" type="method" display="oHeader" />] + ;
		[<memberdata name="oheader_access" type="method" display="oHeader_Access" />] + ;
		[<memberdata name="nindex" type="method" display="nIndex" />] + ;
		[<memberdata name="nindex_access" type="method" display="nIndex_Access" />] + ;
		[<memberdata name="id" type="method" display="Id" />] + ;
		[<memberdata name="keypress" type="method" display="KeyPress" />] + ;
		[<memberdata name="value" type="property" display="Value" />] + ;
		[<memberdata name="value_access" type="method" display="Value_Access" />] + ;
		[<memberdata name="value_assign" type="method" display="Value_Assign" />] + ;
		[<memberdata name="cindexexpression" type="property" display="cIndexExpression" />] + ;
		[<memberdata name="ctextcontrolname" type="property" display="cTextControlName" />] + ;
		[<memberdata name="ctextcontrollibrary" type="property" display="cTextControlLibrary" />] + ;
		[<memberdata name="ccurrentcontrolname" type="property" display="cCurrentControlName" />] + ; 
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oMainObject_Access
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oMainObject_Access()

		If Vartype( This.oMainObject ) # "O"
			This.oMainObject = Createobject( "PrxSession" )
		Endif

		Return This.oMainObject

	Endproc
	*!*
	*!* END PROCEDURE oMainObject_Access
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetMain
	*!* Description...: Devuelve el objeto principal en la jerarquía de clases
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetMain(  ) As Object;
			HELPSTRING "Devuelve el objeto principal en la jerarquía de clases"

		Return This.oMainObject.GetMain()

	Endproc
	*!*
	*!* END PROCEDURE GetMain
	*!*
	*!* ///////////////////////////////////////////////////////



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ColumnControlSource_Access
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ColumnControlSource_Access()

		If Empty( This.ColumnControlSource )
			This.ColumnControlSource = Substr( This.ControlSource, At( ".", This.ControlSource ) + 1 )
		Endif

		Return This.ColumnControlSource

	Endproc
	*!*
	*!* END PROCEDURE ColumnControlSource_Access
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Init
	*!* Description...:
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Init(  ) As Boolean
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			For Each loControl As Control In This.Controls
				loControl.FontSize = This.FontSize
			Next
			* Propago los eventos del teclado al Header
			If Vartype( This.oHeader ) = 'O' And Pemstatus( This.oHeader, 'KeyPress', 5 )
				Bindevent( This, 'KeyPress', This.oHeader, 'KeyPress' )
			Endif
		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )

		Finally
			loControl = Null

		Endtry
	Endfunc
	*!*
	*!* END FUNCTION Init
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oParent_Assign
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oParent_Assign( uNewValue )
		If Vartype( uNewValue ) # "O"
			uNewValue = Null
		Endif
		This.oParent = uNewValue
	Endproc && oParent_Assign

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy(  ) As Void

		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try
			Unbindevents( This )
			With This As PrxColumnBase Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
				.oHeader = Null
				.oMainObject = Null
				.oParent = Null
			Endwith

			DoDefault()

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Destroy

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oHeader_Access
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oHeader_Access(  ) As Header

		If Vartype( This.oHeader ) # "O"
			For Each loControl As Control In This.Controls
				If Lower( loControl.BaseClass ) = 'header'
					This.oHeader = loControl
					Exit
				Endif
			Next
			loControl = Null
		Endif
		Return This.oHeader

	Endproc && oHeader_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: nIndex_Access
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure nIndex_Access(  ) As Integer

		If Empty( This.nIndex )
			If Vartype( This.Parent ) = 'O' ;
					And Lower( This.Parent.BaseClass ) = 'grid'
				For i = 1 To This.Parent.ColumnCount
					loControl = This.Parent.Columns( i )
					If Pemstatus( loControl, 'Id', 5 ) ;
							And loControl.Id = This.Id
						This.nIndex = i
						Exit
					Endif
				Next
				loControl = Null
			Endif
		Endif
		Return This.nIndex

	Endproc && nIndex_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: KeyPress
	*!* Description...: Evento KeyPress
	*!* Date..........: Miércoles 1 de Abril de 2009 (18:43:53)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure KeyPress( nKeyCode As Integer, nShiftAltCtrl As Integer ) As Void;
			HELPSTRING "Evento KeyPress"

		This.Parent.KeyPress( nKeyCode, nShiftAltCtrl )

	Endproc && KeyPress


	*
	* Value_Access
	Protected Procedure Value_Access()
		Local lcCommand As String,;
			lcCurrentControl As String

		Try

			lcCommand = ""
			lcCurrentControl = This.CurrentControl

			* RA 2013-06-14(12:21:14)
			* No utilizar TextMerge para evitar
			* [ Error N° ] 2044
			* [ Message ] Textmerge is recursive.
			* [ Procedure ] value_access

			*!*				Text To lcCommand NoShow TextMerge Pretext 15
			*!*				This.Value = This.<<lcCurrentControl>>.Value
			*!*				EndText

			*!*				&lcCommand

			This.Value = This.&lcCurrentControl..Value

		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry

		Return This.Value

	Endproc && Value_Access

	* Value_Assign

	Protected Procedure xxxValue_Assign( uNewValue )
		Local lcCommand As String,;
			lcCurrentControl As String

		Try

			lcCommand 	= ""
			This.Value 	= uNewValue

			lcCurrentControl = This.CurrentControl

			TEXT To lcCommand NoShow TextMerge Pretext 15
			This.<<lcCurrentControl>>.Value = uNewValue
			ENDTEXT

			&lcCommand

		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Value_Assign


	*
	*
	Procedure xxxMouseWheel( nDirection, nShift, nXCoord, nYCoord ) As Void
		Local lcCommand As String
		Local loGrid As Grid

		Try

			lcCommand = ""
			loGrid = This.Parent

			loGrid.RowHeight = loGrid.RowHeight + Iif( nDirection > 0, 1, -1 )
			*!*				loGrid.DoScroll( Iif( nDirection > 0, 0, 1 ) )
			loGrid.Refresh()



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			*			Throw loError

		Finally
			loGrid = Null
			loColumn = Null

		Endtry

	Endproc && MouseWheel

	*
	*
	Procedure Resize(  ) As Void
		Local lcCommand As String

		Local loLbl As Label,;
			loHeader As Header,;
			loGrid As Grid,;
			loForm As Form

		Try

			lcCommand = ""
			loHeader = This.oHeader

			*!*				If Lower( This.Name ) = "pulc1"
			*!*					Set Step On
			*!*				EndIf

			If Getwordcount( loHeader.Caption ) > 1
				loForm = Createobject( "Form" )
				loForm.Top 		= -1000
				loForm.Visible 	= .T.
				loForm.AddObject( "Label", "Label" )

				loLbl = loForm.Label
				loLbl.Visible 		= .T.
				loLbl.FontBold 		= .T.
				loLbl.FontItalic 	= loHeader.FontItalic
				loLbl.FontName 		= loHeader.FontName
				loLbl.FontSize 		= loHeader.FontSize
				loLbl.Caption 		= loHeader.Caption
				loLbl.AutoSize 		= .T.

				If loLbl.Width > This.Width
					loHeader.WordWrap = .T.
					loGrid = This.Parent

					loLbl.WordWrap 	= .T.
					loLbl.Width 	= This.Width

					If loLbl.Height > loGrid.HeaderHeight
						loGrid.HeaderHeight = loLbl.Height
					Endif

				Else
					loHeader.WordWrap = .F.

				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			*Throw loError

		Finally
			loTP = Null
			loLbl = Null
			loHeader = Null
			loGrid = Null
			loForm = Null

		Endtry

	Endproc && Resize



Enddefine && PrxColumnBase

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxColumn
*!* ParentClass...: PrxColumnBase
*!* BaseClass.....: Column
*!* Description...:
*!* Date..........: Domingo 16 de Abril de 2006 (21:00:27)
*!* Author........: Ricardo Aidelman
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!* 2009-04-01 - Damian Eiff
*!* Cambio la base de la clase a PrxColumnBase
*!*

Define Class PrxColumn As PrxColumnBase

	#If .F.
		Local This As PrxColumn Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
	#Endif

	* FontSize = Iif( Vartype( _Screen.oApp ) == "O", 9 + _Screen.oApp.nUpdateFontSize, 9 )

	HeaderClass = "prxHeader"
	HeaderClassLibrary = "v:\Clipper2Fox\Fw\TierAdapter\Comun\prxBaseLibrary.prg"
	DynamicBackColor = TA_DynamicBackColor
	ColumnControlSource = ""

	*!* Referencia al objeto principal
	* oMainObject = Null

	*!* Referencia al Parent
	* oParent = Null

	*!* Tamaño original de la columna
	nOriginalWidth = 0


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="noriginalwidth" type="property" display="nOriginalWidth" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Init
	*!* Description...:
	*!* Date..........: Domingo 16 de Abril de 2006 (21:00:27)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Init(  ) As Boolean
		*Inform(Program())
		
		DoDefault()
		If This.ControlCount >= 2
			This.RemoveObject( This.CurrentControl )
			This.Newobject( This.cCurrentControlName,;
				This.cTextControlName,;
				This.cTextControlLibrary )
			This.CurrentControl = This.cCurrentControlName
			This.prxText1.Visible = .T.
			This.prxText1.FontSize = This.FontSize
			
			*Inform( This.CurrentControl + " - " + Program() )

			* Setea el FontSize del TextBox asociado con la columna.
			* Atención: ControlCount es cero si los TextBox de cada una
			* de las columnas de la grilla se definen explicitamente ( Grid.ColumnCount # –1 )
			* This.Controls[2].FontSize = This.FontSize
		Endif

	Endfunc && Init


Enddefine && PrxColumn

*!* ///////////////////////////////////////////////////////
*!* Class.........: prxText
*!* ParentClass...: TextBox
*!* BaseClass.....: TextBox
*!* Description...: Current Control por default de la columna
*!* Date..........: Miércoles 12 de Junio de 2013 (17:14:10)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class prxText As TextBox

	#If .F.
		Local This As prxText Of "V:\Clipper2fox\Fw\Tieradapter\Comun\prxBaseLibrary.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]
	*
	*
	Procedure KeyPress( nKeyCode As Integer, nShiftAltCtrl As Integer ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If Vartype( This.Value ) = "N" ;
					And "." $ This.InputMask ;
					And nShiftAltCtrl = 0 ;
					And Set( "point" ) = "," ;
					And nKeyCode = Asc( "." )
				Nodefault
				Keyboard ","

			Else
				This.Parent.KeyPress( nKeyCode, nShiftAltCtrl )

			Endif


		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )

		Finally

		Endtry

	Endproc && KeyPress


	*
	*
	Procedure MouseDown( nButton, nShift, nXCoord, nYCoord ) As Void
		Local lcCommand As String,;
			lcFontName As String,;
			lcFontStyle As String

		Local lnOpcion As Integer,;
			lnFuente As Integer,;
			lnBackColor As Integer

		Try

			lcCommand = ""

			lnOpcion 	= 0
			lnFuente 	= 1
			lnBackColor = 2


			*!*	#DEFINE FS_BOLD 			"B"
			*!*	#DEFINE FS_ITALIC			"I"
			*!*	#DEFINE FS_NORMAL			"N"
			*!*	#DEFINE FS_OUTLINE		    "O"
			*!*	#DEFINE FS_OPAQUE			"Q"
			*!*	#DEFINE FS_SHADOW			"S"
			*!*	#DEFINE FS_STRIKEOUT		"-"
			*!*	#DEFINE FS_UNDERLINE		"U"
			*!*	#DEFINE FS_TRANSPARENT	    "T"
			
			*Inform( This.Name + " - " + Program() )

			Do Case
				Case nButton = 2 And nShift = 0 && Right Click

					Local lcTipo, lnSuma, ldFecha_de_Menu
					*!*	luValor = this.value
					*!*	lcTipo  = type( "luValor" )

					lcTipo = Vartype( This.Value )
					lnSuma = 0
					ldFecha_de_Menu = {}

					Define Popup emergente SHORTCUT Relative From Mrow(),Mcol()

					*!*	Si es una fecha, se muestra la opcion de Calendario.
					If Inlist( lcTipo, "D", "T" ) Then
						lnSuma = 2
						Define Bar 1 Of emergente Prompt "\<Opciones de fecha"
						On Bar 1 Of emergente Activate Popup fechas
						Define Bar 2  Of emergente Prompt "\-"
					Endif



					*!*						Define Bar 30 Of emergente Prompt "Opciones de \<Celda"
					*!*						On Bar 30 Of emergente Activate Popup Celda
					*!*						Define Bar 40 Of emergente Prompt "Opciones de \<Fila"
					*!*						On Bar 40 Of emergente Activate Popup Fila

					*!*						Define Bar 50  Of emergente Prompt "\-"


					*!*	Definir el menu.
					Define Bar _Med_undo Of emergente Prompt "\<Deshacer" Key CTRL+Z, "" ;
						message "Deshace el último comando o acción."
					Define Bar _Med_redo Of emergente Prompt "Re\<hacer" Key CTRL+R, "" ;
						message "Repite el último comando o acción."
					Define Bar 3 + lnSuma Of emergente Prompt "\-"
					Define Bar _Med_cut Of emergente Prompt "Cor\<tar" Key CTRL+X, "" ;
						message "Quita la selección y la coloca en el Portapapeles."
					Define Bar _Med_copy Of emergente Prompt "\<Copiar" Key CTRL+C, "" ;
						message "Copia la selección al Portapapeles."
					Define Bar _Med_paste Of emergente Prompt "Peg\<ar"	Key CTRL+V, "" ;
						message "Pega el contenido del Portapapeles."
					Define Bar 7 + lnSuma Of emergente Prompt "\-"
					Define Bar _Med_slcta Of emergente Prompt "\<Seleccionar todo" Key CTRL+A, "" ;
						message "Selecciona todos los elementos o texto de la ventana actual."


					*!*	Definir el menu de la fecha.
					If Inlist( lcTipo, "D", "T" ) Then
						Define Popup fechas SHORTCUT Relative
						Define Bar 1 Of fechas Prompt "Pri\<mer día del año"
						Define Bar 2 Of fechas Prompt "\<Primer día del mes"
						Define Bar 3 Of fechas Prompt "\<Primer día de la semana"
						Define Bar 4 Of fechas Prompt "Día de \<hoy"
						Define Bar 5 Of fechas Prompt "\<Ultimo día de la semana"
						Define Bar 6 Of fechas Prompt "\<Ultimo día del mes"
						Define Bar 7 Of fechas Prompt "U\<ltimo día del año"
						*	Define Bar 6 Of fechas Prompt "\-"
						*	Define Bar 7 Of fechas Prompt "\<Calendario"
						On Selection Bar 1 Of fechas ldFecha_de_Menu = Ctod( "01/01/" + Alltrim( Str( Year( Date() ) ) ) )
						On Selection Bar 2 Of fechas ldFecha_de_Menu = ( Date() - Day( Date() ) + 1 )
						On Selection Bar 3 Of fechas ldFecha_de_Menu = ( Date() - Dow( Date(), 2 ) + 1 )
						On Selection Bar 4 Of fechas ldFecha_de_Menu = Date()
						On Selection Bar 5 Of fechas ldFecha_de_Menu = ( Date() - Dow( Date(), 2 ) + 7 )
						On Selection Bar 6 Of fechas ldFecha_de_Menu = Gomont( Date(), 1 ) - Day( Gomont( Date(), 1 ) )
						On Selection Bar 7 Of fechas ldFecha_de_Menu = Ctod( "31/12/" + Alltrim( Str( Year( Date() ) ) ) )
						*	On Selection Bar 7 Of fechas Do Form Forms\SYS_Calendario With lxValor To ldFecha_de_Menu
					Endif

					* Celda
					Define Popup Celda SHORTCUT Relative
					Define Bar 1 Of Celda Prompt "Fuente" Picture "Fw\Comunes\Image\ico\font2.ico"
					Define Bar 2 Of Celda Prompt "Color de Fondo" Picture "Fw\Comunes\Image\ico\getcolor.ico"

					On Selection Bar 1 Of Celda lnOpcion = lnFuente
					On Selection Bar 2 Of Celda lnOpcion = lnBackColor


					* Fila
					Define Popup Fila SHORTCUT Relative
					Define Bar 1 Of Fila Prompt "Fuente" Picture "Fw\Comunes\Image\ico\font2.ico"
					Define Bar 2 Of Fila Prompt "Color de Fondo" Picture "Fw\Comunes\Image\ico\getcolor.ico"

					On Selection Bar 1 Of Fila lnOpcion = lnFuente * 10
					On Selection Bar 2 Of Fila lnOpcion = lnBackColor * 10

					Activate Popup emergente

					If ! Empty( ldFecha_de_Menu )
						This.Value = ldFecha_de_Menu
					Endif
			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && MouseDown



Enddefine
*!*
*!* END DEFINE
*!* Class.........: prxText
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxHeaderBase
*!* ParentClass...: Header
*!* BaseClass.....: Header
*!* Description...:
*!* Date..........: Domingo 16 de Abril de 2006 (21:04:02)
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxHeaderBase As Header

	#If .F.
		Local This As PrxHeaderBase Of "Fw\TierAdapter\Comun\prxbaselibrary.prg""
	#Endif

	*!* Referencia al objeto principal
	oMainObject = Null

	*!* Referencia al Parent
	oParent = Null

	Alignment = 2 && Middle Center
	FontSize = 9 + Iif( Pemstatus( _Screen, "oApp", 5 ), _Screen.oApp.nUpdateFontSize, 0 )
	BackColor = TA_HeaderBackColor
	WordWrap = .T.

	*!* Indica si la columna esta activa
	lIsActive = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[<memberdata name="omainobject" type="property" display="oMainObject" />] + ;
		[<memberdata name="omainobject_access" type="method" display="oMainObject_Access" />] + ;
		[<memberdata name="lisactive" type="property" display="lIsActive" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oMainObject_Access
	*!* Date..........: Lunes 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oMainObject_Access()

		If Vartype( This.oMainObject ) # "O"
			This.oMainObject = Createobject( "PrxSession" )
		Endif

		Return This.oMainObject

	Endproc &&  oMainObject_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oParent_Assign
	*!* Date..........: Lunes 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oParent_Assign( uNewValue )

		If Vartype( uNewValue ) # "O"
			uNewValue = Null
		Endif

		This.oParent = uNewValue

	Endproc && oParent_Assign

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Lunes 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy(  ) As Void
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			This.oMainObject = Null
			This.oParent = Null

			DoDefault()

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

			Local lcCommand As String

			Try

				lcCommand = ""

			Catch To loErr
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = lcCommand
				loError.Process ( m.loErr )
				Throw loError

			Finally


			Endtry

		Finally
			loError = Null
		Endtry

	Endproc && Destroy

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: KeyPress
	*!* Description...: Evento KeyPress
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure KeyPress( nKeyCode As Integer, nShiftAltCtrl As Integer ) As Void;
			HELPSTRING "Evento KeyPress"

		If Pemstatus( Thisform, "HeaderKeyPress", 5 )
			Thisform.HeaderKeyPress( nKeyCode, nShiftAltCtrl, This )
		Endif

	Endproc && KeyPress

	Procedure MouseEnter( tnButton As Number, tnShift As Number, ;
			tnXCoord As Number, tnYCoord As Number ) As Void

	Endproc && MouseEnter

	Procedure MouseLeave( tnButton As Number, tnShift As Number, ;
			tnXCoord As Number, tnYCoord As Number ) As Void

	Endproc && MouseLeave

	Procedure MouseDown( nButton As Integer,;
			nShift As Integer,;
			nXCoord As Integer,;
			nYCoord As Integer )

		If nButton = 2
			If Pemstatus( Thisform, "HeaderMouseDown", 5 )
				Thisform.HeaderMouseDown( nButton,;
					nShift,;
					nXCoord,;
					nYCoord,;
					This )

				*MessageBox( Program() + ": " + Evaluate( Thisform.cMainCursorName + ".Desc1" ))

			Else
				DoDefault( nButton,;
					nShift,;
					nXCoord,;
					nYCoord )
			Endif

		Else
			DoDefault( nButton,;
				nShift,;
				nXCoord,;
				nYCoord )

		Endif


	Endproc

	*
	*
	Procedure xxxMouseWheel( nDirection, nShift, nXCoord, nYCoord ) As Void
		Local lcCommand As String
		Local loColumn As Column
		Local loGrid As Grid

		Try

			lcCommand = ""
			loColumn = This.Parent
			loGrid = loColumn.Parent

			loGrid.HeaderHeight = loGrid.HeaderHeight + Iif( nDirection > 0, 1, -1 )
			loGrid.Refresh()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			*			Throw loError

		Finally
			loGrid = Null
			loColumn = Null

		Endtry

	Endproc && MouseWheel



Enddefine && PrxHeaderBase

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxHeader
*!* ParentClass...: PrxHeaderBase
*!* BaseClass.....: Header
*!* Description...:
*!* Date..........: Domingo 16 de Abril de 2006 (21:04:02)
*!* Author........: Ricardo Aidelman
*!* Project.......: Tier Adapter / Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!* 2009-04-01 - Damian Eiff
*!* Cambio la base de la clase a PrxHeaderBase
*!*

Define Class PrxHeader As PrxHeaderBase

	#If .F.
		Local This As PrxHeader Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif

	*!*
	CurrentOrder = ""

	*!*
	NextOrder = ""

	CurrentOrder = ""   && ASCENDING / DESCENDING
	NextOrder = ""

	MousePointer = 15

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="currentorder" type="property" display="CurrentOrder" />] + ;
		[<memberdata name="nextorder" type="property" display="NextOrder" />] + ;
		[<memberdata name="globalorderbythis" type="method" display="GlobalOrderByThis" />] + ;
		[</VFPData>]


	Procedure DblClick()
		Local lcNextOrder As String
		Local lcThisColumnName As String
		Local loColumn As Column
		Local loBiz As oModelo Of "FrontEnd\Prg\Modelo.prg"


		This.CurrentOrder = This.NextOrder

		*... switch the FontBold, FontUnderline and Picture properties
		lcThisColumnName = This.Parent.Name
		For Each loColumn In This.Parent.Parent.Columns

			If loColumn.Name = lcThisColumnName
				* Set Bold and Picture for this header, normal for any others.
				loColumn.Controls[1].FontBold = .T.

				If This.CurrentOrder = [ASCENDING]
					loColumn.Controls[1].Picture = "v:\CloudFox\FW\Comunes\image\bmp\uparrow.bmp"

				Else
					loColumn.Controls[1].Picture = "v:\CloudFox\FW\Comunes\image\bmp\dnarrow.bmp"

				Endif

				loColumn.FontBold = .T.

			Else
				loColumn.Controls[1].FontBold = .F.
				loColumn.Controls[1].Picture = ''
				loColumn.FontBold = .F.

			Endif
		Next

		This.Parent.Parent.Refresh()

		Try
			loBiz = This.Parent.Parent.oBiz
			loBiz.cOrderBy = lcThisColumnName
			loBiz.cOrderPrefix = Iif( Upper( This.CurrentOrder ) = [ASCENDING], "", "-" )

			Thisform.IrPagina( loBiz.nCurrentPage, loBiz.nPageSize )

		Catch To oErr

		Finally
			loBiz = Null

		Endtry


	Endproc

	Procedure xxxDblClick()
		Local lcNextOrder As String
		Local lcThisColumnName As String
		Local loColumn As Column

		#If .T.

			If This.OrderIt()

				This.CurrentOrder = This.NextOrder

				*... switch the FontBold, FontUnderline and Picture properties
				lcThisColumnName = This.Parent.Name
				For Each loColumn In This.Parent.Parent.Columns

					If loColumn.Name = lcThisColumnName
						* Set Bold and Picture for this header, normal for any others.
						loColumn.Controls[1].FontBold = .T.

						If This.CurrentOrder = [ASCENDING]
							loColumn.Controls[1].Picture = Addbs(FL_IMAGE)+"Bmp\UPARROW.BMP"

						Else
							loColumn.Controls[1].Picture = Addbs(FL_IMAGE)+"Bmp\DNARROW.BMP"

						Endif

						loColumn.FontBold = .T.

					Else
						loColumn.Controls[1].FontBold = .F.
						loColumn.Controls[1].Picture = ''
						loColumn.FontBold = .F.

					Endif
				Next

				*!*					* If succesfully reordered, restores the record pointer
				*!*					Locate
				This.Parent.Parent.Refresh()
			Endif
		#Endif

	Endproc && xxxDblClick()

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GlobalOrderByThis
	*!* Description...: Ordena toda la consulta por ésta columna
	*!* Date..........: Lunes 29 de Septiembre de 2008 (15:20:52)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure xxxGlobalOrderByThis(  ) As Void;
			HELPSTRING "Ordena toda la consulta por ésta columna"

		Local lcOrder As String
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try

			lcOrder = Iif( This.NextOrder # [ASCENDING], [DESC], [ASC] )
			****lcOrder = Iif( This.NextOrder # [ASCENDING], [ASC], [DESC] )

			Thisform.SwitchOrder( This.Parent.ColumnControlSource,;
				This.Parent.ColumnControlSource,;
				Evaluate( This.Parent.ControlSource ),;
				( lcOrder = "ASC" ))

		Catch To oErr

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loParam = Null

		Endtry

		Return
	Endproc
	*!*
	*!* END PROCEDURE GlobalOrderByThis
	*!*
	*!* ///////////////////////////////////////////////////////

	Procedure NextOrder_access

		This.NextOrder = Iif( Upper( This.CurrentOrder ) # [ASCENDING], [ASCENDING], [DESCENDING] )

		Return This.NextOrder
	Endproc && NextOrder_access

	Procedure xxxOrderIt() As Boolean
		Local lcNextOrder As String
		Local llSuccess As Boolean
		Local lcExpression As String
		Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lcAlias As String
		Local lcAliasGrid As String
		Local i As Integer,;
			lnRecno As Integer


		Local lcCommand As String
		Local loColumn As PrxColumn Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"

		Try

			lcCommand = ""
			lcAlias = Alias()

			llSuccess = .F.
			If Pemstatus( Thisform, "lGlobalIndexing", 5 ) ;
					And Thisform.lGlobalIndexing = .T.
				llSuccess = .T.
				This.GlobalOrderByThis()

			Else
				lcAliasGrid = Alias( This.Parent.Parent.RecordSource )

				If Used( lcAliasGrid  )

					lnRecno = Recno( lcAliasGrid )

					loColumn = This.Parent

					If !Empty( loColumn.cIndexExpression )
						lcExpression = loColumn.cIndexExpression + " Tag SelOrder " + This.NextOrder

					Else
						lcExpression = This.Parent.ControlSource
						* Always index strings on uppercase
						If Type( lcExpression ) = "C"
							lcExpression = "Upper(" + lcExpression + ")"
						Endif

						lcExpression = "Index On " + lcExpression + " Tag SelOrder " + This.NextOrder

					Endif


					lcCommand = lcExpression

					Try
						&lcExpression

					Catch To oErr

					Finally


					Endtry


					Select Alias( lcAliasGrid )
					Locate

					i = 1
					Scan For ! Deleted()
						Replace _RecordOrder With i In Alias( lcAliasGrid )
						i = i + 1
					Endscan
					llSuccess = .T.

					Try

						Locate && for Recno() = lnRecno

					Catch To oErr

					Finally

					Endtry

				Endif
			Endif


		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif


		Endtry

		Return llSuccess

	Endproc && OrderIt

Enddefine && PrxHeader
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: prxHeaderPermisos
*!* ParentClass...: prxHeaderBase
*!* BaseClass.....: Header
*!* Description...:
*!* Date..........: Viernes 3 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*

Define Class prxHeaderPermisos As PrxHeaderBase

	#If .F.
		Local This As prxHeaderPermisos Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif
	*!* Indica si la columna esta presionada
	lIsClicked = .F.


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lisclicked" type="property" display="lIsClicked" />] + ;
		[</VFPData>]

	Procedure MouseDown( nButton As Integer, nShift As Integer, nXCoord As Integer, nYCoord As Integer ) As Void
		If nButton = 1
			With This As prxHeaderPermisos Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
				.FontUnderline = .T.
				.FontBold = .T.
				.lIsClicked = .T.
			Endwith
		Endif
	Endproc && MouseDown

	Procedure MouseUp( nButton As Integer, nShift As Integer, nXCoord As Integer, nYCoord As Integer ) As Void
		With This As prxHeaderPermisos Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
			.FontUnderline = .T.
			.FontBold = .F.
			.lIsClicked = .F.
		Endwith
	Endproc && MouseUp

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: KeyPress
	*!* Description...: Evento KeyPress
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure KeyPress( nKeyCode As Integer, nShiftAltCtrl As Integer ) As Void;
			HELPSTRING "Evento KeyPress"

	Endproc && KeyPress


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Click
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Click()

	Endproc && Click

Enddefine && prxHeaderPermisos

*!* ///////////////////////////////////////////////////////
*!* Class.........: prxPage
*!* ParentClass...: Page
*!* BaseClass.....: Page
*!* Description...:
*!* Date..........: Domingo 16 de Abril de 2006 (21:10:50)
*!* Author........: Ricardo Aidelman
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class prxPage As Page

	#If .F.
		Local This As prxPage Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
	#Endif

	Name = "prxPage"
	*!* Indica si se ejecuta el metodo AutoSetUp() automáticamente
	PerformAutoSetUp = .F.

	*!* Margen superior
	TopMargin = 10

	*!* Margen izquierdo
	LeftMargin = 10

	*!* Margen derecho
	RightMargin = 10

	*!* Margen inferior
	BottomMargin = 10

	*!* Separación entre controles
	Gap = 0

	*!* Coleccion de Objetos ordenada por TabIndex
	oColObjects = .F.

	Width = 0
	Height = 0

	*!* Referencia al objeto principal
	oMainObject = Null

	*!* Referencia al Parent
	oParent = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="performautosetup" type="property" display="PerformAutoSetUp" />] + ;
		[<memberdata name="performAutoSetUp" type="property" display="PerformAutoSetUp" />] + ;
		[<memberdata name="gap" type="property" display="Gap" />] + ;
		[<memberdata name="bottommargin" type="property" display="BottomMargin" />] + ;
		[<memberdata name="rightmargin" type="property" display="RightMargin" />] + ;
		[<memberdata name="leftmargin" type="property" display="LeftMargin" />] + ;
		[<memberdata name="topmargin" type="property" display="TopMargin" />] + ;
		[<memberdata name="autosetup" type="method" display="AutoSetUp" />] + ;
		[<memberdata name="ocolobjects" type="property" display="oColObjects" />] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[<memberdata name="omainobject" type="property" display="oMainObject" />] + ;
		[<memberdata name="omainobject_access" type="method" display="oMainObject_Access" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oMainObject_Access
	*!* Date..........: Viernes 6 de Febrero de 2009 (13:32:47)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oMainObject_Access()

		If Vartype( This.oMainObject ) # "O"
			This.oMainObject = Createobject( "PrxSession" )
		Endif

		Return This.oMainObject

	Endproc
	*!*
	*!* END PROCEDURE oMainObject_Access
	*!*
	*!* ///////////////////////////////////////////////////////



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AutoSetUp
	*!* Description...:
	*!* Date..........: Miércoles 24 de Mayo de 2006 (17:13:54)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure AutoSetUp(  ) As Void

		Local loAutoSetup As AutoSetUp Of "FW\Comunes\Prg\AutoSetUp.prg"

		Try

			This.oColObjects = OrderControlsByKey( This )

			loAutoSetup = Newobject("AutoSetUp", "AutoSetUp.prg")

			If !loAutoSetup.Process( This,;
					This.TopMargin,;
					This.LeftMargin,;
					This.RightMargin,;
					This.BottomMargin,;
					This.Gap )

				Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"

				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Process( loAutoSetup.oError )

			Endif

			This.Parent.MaxWidth = Max( This.Parent.MaxWidth, This.Width )
			This.Parent.MaxHeight = Max( This.Parent.MaxHeight, This.Height )

		Catch To oErr

		Finally
			loAutoSetup = .F.

		Endtry
	Endproc
	*!*
	*!* END PROCEDURE AutoSetUp
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Miércoles 18 de Octubre de 2006 (18:19:17)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy(  ) As Void

		Try
			For Each oObj In This.Objects
				If Pemstatus( oObj, "Destroy", 5 )
					oObj.Destroy()
				Endif
			Endfor

			This.oColObjects = .F.

			This.oMainObject = Null
			This.oParent = Null

		Catch To oErr

		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE Destroy
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oParent_Assign
	*!* Date..........: Martes 3 de Febrero de 2009 (11:52:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oParent_Assign( uNewValue )

		If Vartype( uNewValue ) # "O"
			uNewValue = Null
		Endif

		This.oParent = uNewValue

	Endproc
	*!*
	*!* END PROCEDURE oParent_Assign
	*!*
	*!* ///////////////////////////////////////////////////////


Enddefine
*!*
*!* END DEFINE
*!* Class.........: prxPage
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxColumnPermisos
*!* ParentClass...: PrxColumnPermisosBase
*!* BaseClass.....: Column
*!* Description...:
*!* Date..........: Miercoles 1 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxColumnPermisos As PrxColumnBase

	#If .F.
		Local This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
	#Endif

	*!* Indica si la columna es actualizable
	lUpdateable = .F.

	HeaderClass = "prxHeaderPermisos"
	HeaderClassLibrary = "prxBaseLibrary.prg"

	DynamicCurrentControl = ''
	DynamicBackColor = 'Rgb( 255, 255, 255 )'
	Sparse = .F.

	*!*
	lIsActive = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lupdateable" type="property" display="lUpdateable" />] + ;
		[<memberdata name="getrange" type="method" display="GetRange" />] + ;
		[<memberdata name="lisactive" type="property" display="lIsActive" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Init
	*!* Description...:
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Init(  ) As Boolean
		Adlls( lAdlls )
		If Ascan( lAdlls, 'GetKeyState' ) = 0 && Si no esta declarada la funcion del API
			Declare Short GetKeyState In Win32Api Integer KeyCode
		Endif
		Release lAdlls
		DoDefault()
		If Pemstatus( This, 'Text1', 5 )
			This.RemoveObject( 'Text1' )
		Endif
	Endfunc && Init

	*!* ///////////////////////////////////////////////////////
	*!* Function......: UpdateData
	*!* Description...:
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*
	Procedure UpdateData( nValue As Integer, nRange As Integer )
		Local lnRecno As Integer
		Local loColumn As Column
		Try

			With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
				If .lUpdateable
					TEXT To lcCommand NoShow TextMerge Pretext 15
						Replace <<.ColumnControlSource>> with <<nValue>> in <<.Parent.RecordSource>>
					ENDTEXT
					Do Case
						Case nRange = 0 And .lUpdateable && Actualiza la celda activa
							&lcCommand
						Case nRange = 1 && Actualiza la fila activa
							For Each loColumn In .Parent.Columns
								If Pemstatus( loColumn, 'UpdateData', 5 )
									loColumn.UpdateData( nValue, 0 )
								Endif
							Endfor
						Case nRange = 2 And .lUpdateable && Actualiza la columna activa, si esta presionado Ctrl o el Header
							Select Alias( .Parent.RecordSource )
							lnRecno = Recno( loGrid.RecordSource )
							Locate
							Scan
								&lcCommand
							Endscan
							TEXT To lcCommand NoShow TextMerge Pretext 15
                    			Goto RECORD <<lnRecno>>
							ENDTEXT
							&lcCommand
						Case nRange = 3 && Actualiza todas las filas y las columnas
							For Each loColumn In .Parent.Columns
								If Pemstatus( loColumn, 'UpdateData', 5 )
									loColumn.UpdateData( nValue, 2 )
								Endif
							Endfor
					Endcase
				Endif && .lUpdateable
			Endwith
		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError
		Finally
			loColumn = Null
		Endtry
	Endproc && UpdateData

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Click
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Click()
		Local lnValue As Integer
		Local lnNewValue As Integer
		Local lnRange As Integer

		With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
			Try
				If ! Empty( .ControlSource )
					lnValue = Evaluate( .ControlSource )
					Do Case
						Case lnValue = 0
							lnNewValue = 2
						Case lnValue = 1
							lnNewValue = 0
						Case lnValue = 2
							lnNewValue = 1
					Endcase
					lnRange = .GetRange()
					.UpdateData( lnNewValue, lnRange )
				Endif
			Catch To oErr
				Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Process( oErr )
			Finally
				loError = Null
			Endtry
		Endwith

	Endproc && Click

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: KeyPress
	*!* Description...: Evento KeyPress
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure KeyPress( nKeyCode As Integer, nShiftAltCtrl As Integer ) As Void;
			HELPSTRING "Evento KeyPress"

		Local lcLetter As String
		Local loGrid  As Grid
		Local lnRange As Integer
		Try
			lcLetter = Lower( Chr( nKeyCode ) )
			With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"

				Do Case
					Case ! Empty( .ControlSource ) And Inlist( lcLetter, 'h', 'n', 'y', '0', '1', '2' )
						Do Case
							Case Inlist( lcLetter, 'h', '2' )
								lnNewValue = 2
							Case Inlist( lcLetter, 'n', '0' )
								lnNewValue = 0
							Case Inlist( lcLetter, 'y', '1' )
								lnNewValue = 1
						Endcase
						lnRange = .GetRange()
						.UpdateData( lnNewValue, lnRange )

					Case nKeyCode = 13
						Nodefault
						Clear Typeahead
						loGrid = .Parent
						If loGrid.ActiveColumn < loGrid.ColumnCount
							Keyboard '{RIGHTARROW}'
						Else
							Keyboard '{DNARROW}'
							DoEvents
							loGrid.ActivateCell( loGrid.ActiveRow, 1 )
						Endif

				Endcase
			Endwith

		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
		Finally
			loGrid = Null
		Endtry


	Endproc && KeyPress


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetRange
	*!* Description...: Devuelve el valor numerico del rango a actualizar
	*!* Date..........: Viernes 3 de Abril de 2009 (15:55:41)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetRange(  ) As Integer;
			HELPSTRING "Devuelve el valor numerico del rango a actualizar"
		Local lnRange As Integer

		Try

			Do Case
					* Evalua si esta presionada la tecla Shift
				Case ( GetKeyState( 16 ) < 0 ) ;
						And ! ( ( GetKeyState( 17 ) < 0 ) Or This.oHeader.lIsClicked )
					lnRange = 1
					* Evalua si esta presionada la tecla CONTROL (CTRL)
				Case ! ( GetKeyState( 16 ) < 0 ) ;
						And ( ( GetKeyState( 17 ) < 0 ) Or This.oHeader.lIsClicked )
					lnRange = 2
					* Evalua si esta presionada la tecla ALT
				Case ( GetKeyState( 18 ) < 0 )
					lnRange = 0
				Otherwise
					lnRange = 0
			Endcase
		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError
		Finally
		Endtry
		Return lnRange
	Endproc && GetRange

Enddefine && PrxColumnPermisos

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxColumnPermisoAll
*!* ParentClass...: PrxColumnPermisos
*!* BaseClass.....: Column
*!* Description...:
*!* Date..........: Viernes 3 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxColumnPermisoAll As PrxColumnPermisos
	#If .F.
		Local This As PrxColumnPermisoAll Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
	#Endif
	Name = 'PrxColumnPermisoAll'

	Add Object cmdOn As cmdCheckBoxOn

	Add Object cmdOff As cmdCheckBoxOff

	Add Object cmdOnDisabled As cmdCheckBoxOnDisabled

	Add Object cmdOffDisabled As cmdCheckBoxOffDisabled

	CurrentControl = 'cmdOn'

Enddefine && PrxColumnPermisoAll

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxColumnPermisoOn
*!* ParentClass...: PrxColumnPermisos
*!* BaseClass.....: Column
*!* Description...:
*!* Date..........: Viernes 3 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxColumnPermisoOn As PrxColumnPermisos
	#If .F.
		Local This As PrxColumnPermisoOn Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
	#Endif
	Name = 'PrxColumnPermisoOn'
	HeaderClass = ''
	HeaderClassLibrary = ''
	DynamicCurrentControl = ''
	Add Object cmdOn As cmdCheckBoxOn

	CurrentControl = 'cmdOn'

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Click
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Click()
		Local loColumn As Column
		With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
			Try
				For Each loColumn In .Parent.Columns
					If Pemstatus( loColumn, 'UpdateData', 5 )
						loColumn.UpdateData( 1, 0 )
					Endif
				Endfor
			Catch To oErr
				Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Process( oErr )
				Throw loError
			Finally
				loColumn = Null
			Endtry
		Endwith
	Endproc && Click


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: KeyPress
	*!* Description...: Evento KeyPress
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure KeyPress( nKeyCode As Integer, nShiftAltCtrl As Integer ) As Void;
			HELPSTRING "Evento KeyPress"

		Local loGrid  As Grid
		Try
			With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"

				If nKeyCode = 13
					Nodefault
					Clear Typeahead
					loGrid = .Parent
					If loGrid.ActiveColumn < loGrid.ColumnCount
						Keyboard '{RIGHTARROW}'
					Else
						Keyboard '{DNARROW}'
						DoEvents
						loGrid.ActivateCell( loGrid.ActiveRow, 1 )
					Endif

				Endif
			Endwith

		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
		Finally
			loGrid = Null
		Endtry

	Endproc && KeyPress

Enddefine && PrxColumnPermisoOn

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxColumnPermisoOnDisabled
*!* ParentClass...: PrxColumnPermisos
*!* BaseClass.....: Column
*!* Description...:
*!* Date..........: Viernes 3 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxColumnPermisoOnDisabled As PrxColumnPermisos
	#If .F.
		Local This As PrxColumnPermisoOnDisabled Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
	#Endif
	Name = 'PrxColumnPermisoOnDisabled'
	HeaderClass = ''
	HeaderClassLibrary = ''
	DynamicCurrentControl = ''
	Add Object cmdOnDisabled As cmdCheckBoxOnDisabled

	CurrentControl = 'cmdOnDisabled'

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Click
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Click()
		Nodefault
	Endproc && Click


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: KeyPress
	*!* Description...: Evento KeyPress
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure KeyPress( nKeyCode As Integer, nShiftAltCtrl As Integer ) As Void;
			HELPSTRING "Evento KeyPress"

		Local loGrid  As Grid
		Try
			With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"

				If nKeyCode = 13
					Nodefault
					Clear Typeahead
					loGrid = .Parent
					If loGrid.ActiveColumn < loGrid.ColumnCount
						Keyboard '{RIGHTARROW}'
					Else
						Keyboard '{DNARROW}'
						DoEvents
						loGrid.ActivateCell( loGrid.ActiveRow, 1 )
					Endif

				Endif
			Endwith

		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
		Finally
			loGrid = Null
		Endtry

	Endproc && KeyPress

Enddefine && PrxColumnPermisoOnDisabled

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxColumnPermisoOff
*!* ParentClass...: PrxColumnPermisos
*!* BaseClass.....: Column
*!* Description...:
*!* Date..........: Viernes 3 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxColumnPermisoOff As PrxColumnPermisos
	#If .F.
		Local This As PrxColumnPermisoOff Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
	#Endif
	Name = 'PrxColumnPermisoOff'
	HeaderClass = ''
	HeaderClassLibrary = ''
	DynamicCurrentControl = ''
	Add Object cmdOff As cmdCheckBoxOff

	CurrentControl = 'cmdOff'

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Click
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Click()
		Local loColumn As Column
		With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
			Try
				For Each loColumn In .Parent.Columns
					If Pemstatus( loColumn, 'UpdateData', 5 )
						loColumn.UpdateData( 0, 0 )
					Endif
				Endfor
			Catch To oErr
				Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Process( oErr )
				Throw loError
			Finally
				loColumn = Null
			Endtry
		Endwith
	Endproc && Click


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: KeyPress
	*!* Description...: Evento KeyPress
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure KeyPress( nKeyCode As Integer, nShiftAltCtrl As Integer ) As Void;
			HELPSTRING "Evento KeyPress"

		Local loGrid  As Grid
		Try
			With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"

				If nKeyCode = 13
					Nodefault
					Clear Typeahead
					loGrid = .Parent
					If loGrid.ActiveColumn < loGrid.ColumnCount
						Keyboard '{RIGHTARROW}'
					Else
						Keyboard '{DNARROW}'
						DoEvents
						loGrid.ActivateCell( loGrid.ActiveRow, 1 )
					Endif

				Endif
			Endwith

		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
		Finally
			loGrid = Null
		Endtry

	Endproc && KeyPress

Enddefine && PrxColumnPermisoOff

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxColumnPermisoOffDisabled
*!* ParentClass...: PrxColumnPermisos
*!* BaseClass.....: Column
*!* Description...:
*!* Date..........: Viernes 3 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxColumnPermisoOffDisabled As PrxColumnPermisos
	#If .F.
		Local This As PrxColumnPermisoOffDisabled Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
	#Endif
	Name = 'PrxColumnPermisoOffDisabled'
	HeaderClass = ''
	HeaderClassLibrary = ''
	DynamicCurrentControl = ''
	Add Object cmdOffDisabled As cmdCheckBoxOffDisabled

	CurrentControl = 'cmdOffDisabled'

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Click
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Click()
		Nodefault
	Endproc && Click


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: KeyPress
	*!* Description...: Evento KeyPress
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure KeyPress( nKeyCode As Integer, nShiftAltCtrl As Integer ) As Void;
			HELPSTRING "Evento KeyPress"

		Local loGrid  As Grid
		Try
			With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"

				If nKeyCode = 13
					Nodefault
					Clear Typeahead
					loGrid = .Parent
					If loGrid.ActiveColumn < loGrid.ColumnCount
						Keyboard '{RIGHTARROW}'
					Else
						Keyboard '{DNARROW}'
						DoEvents
						loGrid.ActivateCell( loGrid.ActiveRow, 1 )
					Endif

				Endif
			Endwith

		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
		Finally
			loGrid = Null
		Endtry

	Endproc && KeyPress

Enddefine && PrxColumnPermisoOffDisabled

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxColumnPermisoNull
*!* ParentClass...: PrxColumnPermisos
*!* BaseClass.....: Column
*!* Description...:
*!* Date..........: Viernes 3 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxColumnPermisoNull As PrxColumnPermisos
	#If .F.
		Local This As PrxColumnPermisoNull Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
	#Endif
	Name = 'PrxColumnPermisoNull'
	HeaderClass = ''
	HeaderClassLibrary = ''
	DynamicCurrentControl = ''
	Add Object cmdNull As cmdCheckBoxNull

	CurrentControl = 'cmdNull'

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Click
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Click()
		Local loColumn As Column
		With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
			Try
				For Each loColumn In .Parent.Columns
					If Pemstatus( loColumn, 'UpdateData', 5 )
						loColumn.UpdateData( 2, 0 )
					Endif
				Endfor
			Catch To oErr
				Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
				loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Process( oErr )
				Throw loError
			Finally
				loColumn = Null
			Endtry
		Endwith
	Endproc && Click


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: KeyPress
	*!* Description...: Evento KeyPress
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure KeyPress( nKeyCode As Integer, nShiftAltCtrl As Integer ) As Void;
			HELPSTRING "Evento KeyPress"

		Local loGrid  As Grid
		Try
			With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"

				If nKeyCode = 13
					Nodefault
					Clear Typeahead
					loGrid = .Parent
					If loGrid.ActiveColumn < loGrid.ColumnCount
						Keyboard '{RIGHTARROW}'
					Else
						Keyboard '{DNARROW}'
						DoEvents
						loGrid.ActivateCell( loGrid.ActiveRow, 1 )
					Endif

				Endif
			Endwith

		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
		Finally
			loGrid = Null
		Endtry

	Endproc && KeyPress

Enddefine && PrxColumnPermisoNull

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxColumnPermisoNullDisabled
*!* ParentClass...: PrxColumnPermisos
*!* BaseClass.....: Column
*!* Description...:
*!* Date..........: Viernes 3 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxColumnPermisoNullDisabled As PrxColumnPermisos
	#If .F.
		Local This As PrxColumnPermisoNullDisabled Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"
	#Endif
	Name = 'PrxColumnPermisoNullDisabled'
	HeaderClass = ''
	HeaderClassLibrary = ''
	DynamicCurrentControl = ''
	Add Object cmdNullDisabled As cmdCheckBoxNullDisabled

	CurrentControl = 'cmdNullDisabled'

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Click
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Click()
		Nodefault
	Endproc && Click

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: KeyPress
	*!* Description...: Evento KeyPress
	*!* Date..........: Viernes 3 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure KeyPress( nKeyCode As Integer, nShiftAltCtrl As Integer ) As Void;
			HELPSTRING "Evento KeyPress"

		Local loGrid  As Grid
		Try
			With This As PrxColumnPermisos Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"

				If nKeyCode = 13
					Nodefault
					Clear Typeahead
					loGrid = .Parent
					If loGrid.ActiveColumn < loGrid.ColumnCount
						Keyboard '{RIGHTARROW}'
					Else
						Keyboard '{DNARROW}'
						DoEvents
						loGrid.ActivateCell( loGrid.ActiveRow, 1 )
					Endif

				Endif
			Endwith

		Catch To oErr
			Local loError As ErrorHandler "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
		Finally
			loGrid = Null
		Endtry

	Endproc && KeyPress

Enddefine && PrxColumnPermisoNullDisabled

*!* ///////////////////////////////////////////////////////
*!* Class.........: cmdCheckBox
*!* ParentClass...: CommandButton
*!* BaseClass.....: CommandButton
*!* Description...:
*!* Date..........: Miercoles 1 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*
Define Class cmdcheckbox As CommandButton
	#If .F.
		Local This As cmdcheckbox Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif
	Name = 'cmdCheckBox'
	Height = 24
	Width = 24
	Caption = ""
	SpecialEffect = 1
	PicturePosition = 14
	BackColor = Rgb(250,250,255)
	*-- Specifies the source of data to which an object is bound.
	ControlSource = ""
	lMouseOver = .F.
	nRow = 0
	*-- Specifies the current state of a control.
	Value = (2)
	*-- XML Metadata for customizable properties
	_MemberData = [<VFPData>] ;
		+ [<memberdata name="value" type="property" display="Value"/>] ;
		+ [<memberdata name="value_assign" type="property" display="Value_Assign"/>] ;
		+ [<memberdata name="controlsource" type="property" display="ControlSource"/>] ;
		+ [<memberdata name="controlsource_access" type="property" display="ControlSource_Access"/>] ;
		+ [<memberdata name="value_access" type="method" display="Value_Access"/>] ;
		+ [<memberdata name="lmouseover" type="property" display="lMouseOver"/>] ;
		+ [<memberdata name="nrow" type="property" display="nRow"/>] ;
		+ [</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Value_Assign
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Value_Assign
		Lparameters tuNewValue
		This.Value = tuNewValue
	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Controlsource_Access
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ControlSource_Access

		If Empty( This.ControlSource ) ;
				And Vartype( This.Parent ) = 'O' ;
				And Lower( This.Parent.BaseClass ) == 'column'
			This.ControlSource = This.Parent.ControlSource
		Endif
		Return This.ControlSource
	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Value_Access
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Value_Access
		Return This.Value
	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: KeyPress
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure KeyPress
		Lparameters nKeyCode, nShiftAltCtrl

		Raiseevent( This.Parent, 'KeyPress', nKeyCode, nShiftAltCtrl )

	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: LostFocus
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure LostFocus()
		This.nRow = 0
		This.lMouseOver = .F.
		This.Parent.lIsActive = .F.
	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GotFocus
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GotFocus()
		This.nRow = This.Parent.Parent.ActiveRow
		This.lMouseOver = .T.
		This.Parent.lIsActive = .T.
	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Click
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Click()
		If Pemstatus( This.Parent, 'Click', 5 )
			Raiseevent( This.Parent, 'Click' )
		Endif
	Endproc && Click

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: MouseEnter
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure MouseEnter
		Lparameters nButton, nShift, nXCoord, nYCoord

		This.MousePointer = 15
		This.lMouseOver = .T.
		Debugout Datetime(), 'MouseEnter'
	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: MouseLeave
	*!* Date..........: Miercoles 1 de Abril de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure MouseLeave
		Lparameters nButton, nShift, nXCoord, nYCoord

		This.MousePointer = 0
		This.lMouseOver = .F.
	Endproc

Enddefine

*!* ///////////////////////////////////////////////////////
*!* Class.........: cmdCheckBoxNull
*!* ParentClass...: cmdCheckBox
*!* BaseClass.....: CommandButton
*!* Description...:
*!* Date..........: Miercoles 1 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class cmdCheckBoxNull As cmdcheckbox
	#If .F.
		Local This As cmdCheckBoxNull Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif
	Name = "cmdCheckBoxNull"
	Picture = Addbs( FL_IMAGE ) + "bmp\radio_off.bmp"
	DisabledPicture = Addbs( FL_IMAGE ) + "bmp\radio_off_disabled.bmp"
	_MemberData = [<VFPData>] + ;
		[</VFPData>]
Enddefine

*!* ///////////////////////////////////////////////////////
*!* Class.........: cmdCheckBoxNullDisabled
*!* ParentClass...: cmdCheckBox
*!* BaseClass.....: CommandButton
*!* Description...:
*!* Date..........: Miercoles 1 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class cmdCheckBoxNullDisabled As cmdcheckbox
	#If .F.
		Local This As cmdCheckBoxNullDisabled Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif
	Name = "cmdCheckBoxNullDisabled"
	Picture = Addbs( FL_IMAGE ) + "bmp\radio_off_disabled.bmp"
	DisabledPicture = Addbs( FL_IMAGE ) + "bmp\radio_off_disabled.bmp"
	_MemberData = [<VFPData>] + ;
		[</VFPData>]
Enddefine

*!* ///////////////////////////////////////////////////////
*!* Class.........: cmdCheckBoxOff
*!* ParentClass...: cmdCheckBox
*!* BaseClass.....: CommandButton
*!* Description...:
*!* Date..........: Miercoles 1 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class cmdCheckBoxOff As cmdcheckbox
	#If .F.
		Local This As cmdCheckBoxOff Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif
	Name = "cmdCheckBoxOff"
	Picture = Addbs( FL_IMAGE ) + "bmp\check_off.bmp"
	DisabledPicture = Addbs( FL_IMAGE ) + "bmp\check_off_disabled.bmp"
	_MemberData = [<VFPData>] + ;
		[</VFPData>]
Enddefine

*!* ///////////////////////////////////////////////////////
*!* Class.........: cmdCheckBoxOffDisabled
*!* ParentClass...: cmdCheckBox
*!* BaseClass.....: CommandButton
*!* Description...:
*!* Date..........: Miercoles 1 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class cmdCheckBoxOffDisabled As cmdcheckbox
	#If .F.
		Local This As cmdCheckBoxOffDisabled Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif
	Name = "cmdCheckBoxOffDisabled"
	Picture = Addbs( FL_IMAGE ) + "bmp\check_off_disabled.bmp"
	DisabledPicture = Addbs( FL_IMAGE ) + "bmp\check_off_disabled.bmp"
	_MemberData = [<VFPData>] + ;
		[</VFPData>]
Enddefine

*!* ///////////////////////////////////////////////////////
*!* Class.........: cmdCheckBoxOnDisabled
*!* ParentClass...: cmdCheckBox
*!* BaseClass.....: CommandButton
*!* Description...:
*!* Date..........: Miercoles 1 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class cmdCheckBoxOnDisabled As cmdcheckbox
	#If .F.
		Local This As cmdCheckBoxOnDisabled Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif
	Name = "cmdCheckBoxOnDisabled"
	Picture = Addbs( FL_IMAGE ) + "bmp\check_on_disabled.bmp"
	DisabledPicture = Addbs( FL_IMAGE ) + "bmp\check_off_disabled.bmp"
	_MemberData = [<VFPData>] + ;
		[</VFPData>]
Enddefine

*!* ///////////////////////////////////////////////////////
*!* Class.........: cmdCheckBoxOn
*!* ParentClass...: cmdCheckBox
*!* BaseClass.....: CommandButton
*!* Description...:
*!* Date..........: Miercoles 1 de Abril de 2009
*!* Author........: Damian Eiff
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*l
*!*

Define Class cmdCheckBoxOn As cmdcheckbox
	#If .F.
		Local This As cmdCheckBoxOn Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif
	Name = "cmdCheckBoxOn"
	Picture = Addbs( FL_IMAGE ) + "bmp\check_on.bmp"
	DisabledPicture = Addbs( FL_IMAGE ) + "bmp\check_on_disabled.bmp"
	_MemberData = [<VFPData>] + ;
		[</VFPData>]
Enddefine


Define Class oFilter As PrxSession Of "fw\tieradapter\comun\prxbaselibrary.prg"

	#If .F.
		Local This As oFilter Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif

	*!* Nombre del campo a evaluar
	cField = ''

	*!* Operador para evaluar la expresion
	cOperator = '='

	*!* Expresion a evaluar
	cExpr = ''

	cFieldExp = '<#FIELD#>'

	_MemberData = [<VFPData>] + ;
		[<memberdata name="cfield" type="property" display="cField" />] + ;
		[<memberdata name="cexpr" type="property" display="cExpr" />] + ;
		[<memberdata name="coperator" type="property" display="cOperator" />] + ;
		[<memberdata name="cfieldexp" type="property" display="cFieldExp" />] + ;
		[</VFPData>]

Enddefine && oFilter

Define Class ColFilters As PrxCollection Of "fw\tieradapter\comun\prxbaselibrary.prg"

	#If .F.
		Local This As ColFilters Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif

	*!* Nombre de la clase de los elementos que forman la coleccion
	cClassName = 'oFilter'

	*!* Nombre de la librería de clases
	cClassLibrary = 'prxbaselibrary.prg'


	_MemberData = [<VFPData>] + ;
		[</VFPData>]


Enddefine && ColFilters



Define Class prxInTopLevelForm As Form

	#If .F.
		Local This As prxInTopLevelForm Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif

	ShowWindow = 1

	_MemberData = [<VFPData>] + ;
		[</VFPData>]

Enddefine && prxInTopLevelForm


Define Class prxAsTopLevelForm As Form

	#If .F.
		Local This As prxAsTopLevelForm Of "Fw\TierAdapter\Comun\prxbaselibrary.prg"
	#Endif

	ShowWindow = 1

	_MemberData = [<VFPData>] + ;
		[</VFPData>]

Enddefine && prxAsTopLevelForm




