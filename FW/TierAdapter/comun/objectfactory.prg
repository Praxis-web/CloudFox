*!* ///////////////////////////////////////////////////////
*!* Class.........: ObjectFactory
*!* ParentClass...: PrxCustom
*!* BaseClass.....: Custom
*!* Description...: Construye y devuelve un objeto
*!* Date..........: Viernes 7 de Marzo de 2008 (10:22:19)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#INCLUDE "FW\Tieradapter\Include\TA.h"

* Define Class ObjectFactory As PrxCustom Of "FW\TierAdapter\Comun\prxBaseLibrary.prg"
Define Class ObjectFactory As PrxSession Of "Fw\TierAdaptre\Comun\Prxbaselibrary.prg"

	#If .F.
		Local This As ObjectFactory Of "Fw\TierAdapter\Comun\ObjectFactory.prg"
	#Endif

	*!*	Name of the COM component
	cObjComponent = ""

	*!*	Name of the class
	cObjClass  = ""

	*!*	Name of the class library
	cObjClassLibrary = ""

	*!*	Name of the class library folder
	cObjClassLibraryFolder = ""

	*!* Indica si la clase se encuentra en COM+
	lObjInComComponent = .F.

	*!* Para debbuging, permite forzar a trabajar sin COM+
	lForceNeverUseComComponent = .F.

	*!* Nombre Unico de la Entidad en el archivo de configuración
	cObjectName = ""

	*!* Indica el nivel de la capa
	cTierLevel = "User"

	*!* Nombre del archivo de configuración
	*!*		cObjectFactoryFileName  = "ObjectFactoryCfg.xml"

	*!* Parametro que se pasa al Constructor del objeto
	uParameter  = .F.

	*!* Se utiliza para debuggear objetos COM
	lDebugMode = .F.

	*!* ClassId del componente ComPlusInfo
	cCPIClassId = ""

	*!* Direccion IP del servidor donde se encuentra publicado ComPlusInfo
	cCPIServerIP = ""

	*!* Nombre del archivo de configuración del componente ComPlusInfo
	cComServersConfig = "ComServersSetUp.xml"

	*!* Nombre del Servidor en el DNS
	cCPIServerName  = ""

	*!* Nombre del archivo de configuración
	cConfigFileName = "SysConfig.xml"

	DataSession = SET_DEFAULT


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cconfigfilename" type="property" display="cConfigFileName" />] + ;
		[<memberdata name="ccpiservername" type="property" display="cCPIServerName " />] + ;
		[<memberdata name="ccomserversconfig" type="property" display="cComServersConfig" />] + ;
		[<memberdata name="ccpiserverip" type="property" display="cCPIServerIP" />] + ;
		[<memberdata name="ccpiclassid" type="property" display="cCPIClassId" />] + ;
		[<memberdata name="ldebugmode" type="property" display="lDebugMode" />] + ;
		[<memberdata name="uparameter" type="property" display="uParameter " />] + ;
		[<memberdata name="cobjectfactoryfilename" type="property" display="cObjectFactoryFileName " />] + ;
		[<memberdata name="cobjectname" type="property" display="cObjectName" />] + ;
		[<memberdata name="ctierlevel" type="property" display="cTierLevel" />] + ;
		[<memberdata name="lforceneverusecomcomponent" type="property" display="lForceNeverUseComComponent" />] + ;
		[<memberdata name="lobjincomcomponent" type="property" display="lObjInComComponent" />] + ;
		[<memberdata name="cobjclasslibraryfolder" type="property" display="cObjClassLibraryFolder " />] + ;
		[<memberdata name="cobjclasslibrary" type="property" display="cObjClassLibrary " />] + ;
		[<memberdata name="cobjclass" type="property" display="cObjClass  " />] + ;
		[<memberdata name="cobjcomponent" type="property" display="cObjComponent" />] + ;
		[<memberdata name="getnewobject" type="method" display="GetNewObject" />] + ;
		[<memberdata name="getentityconfig" type="method" display="GetEntityConfig" />] + ;
		[<memberdata name="lforceneverusecomcomponent_access" type="method" display="lForceNeverUseComComponent_Access" />] + ;
		[<memberdata name="hookafterreadini" type="method" display="HookAfterReadIni" />] + ;
		[<memberdata name="hookaftergetnewobject" type="method" display="HookAfterGetNewObject" />] + ;
		[<memberdata name="getnewobject" type="method" display="GetNewObject" />] + ;
		[<memberdata name="getcomobject" type="method" display="GetComObject" />] + ;
		[<memberdata name="getcomplusinfo" type="method" display="GetComPlusInfo" />] + ;
		[<memberdata name="retrievecomconfig" type="method" display="RetrieveComConfig" />] + ;
		[<memberdata name="getmachinename" type="method" display="GetMachineName" />] + ;
		[</VFPData>]




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Init
	*!* Description...: Constructor
	*!* Date..........: Viernes 7 de Marzo de 2008 (12:50:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Init( oParam As Object ) As Boolean;
			HELPSTRING "Constructor"

		Local lcPropertyName As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local llShowError As Boolean
		Local llLogError As Boolean
		Local loApp As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

		Try

			If ! Pemstatus( _Screen, "oObjectFactory", 5 )
				AddProperty( _Screen, "oObjectFactory", This )

			Endif

			* RA 2014-08-29(17:37:45)
			* Fuerzo a utilizar la nueva version
			* Si algo falla, volver para atras
			loApp = NewApp()

			If !IsEmpty( oParam )

				* Permite pasar en un objeto Empty las propiedades que se desea inicializar
				Amembers( laProperties, oParam )

				For Each lcPropertyName In laProperties
					Try

						This.&lcPropertyName = oParam.&lcPropertyName

					Catch To oErr

					Finally

					Endtry

				Endfor
			Endif


		Catch To oErr

			llShowError = .T.
			llLogError 	= .T.

			* loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr, llShowError, llLogError )

			Throw loError

		Finally
			oParam = Null
			loApp = Null

		Endtry

		Return This.lIsOk

	Endproc
	*!*
	*!* END PROCEDURE Init
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetNewObject
	*!* Description...: Devuelve el objeto
	*!* Date..........: Viernes 7 de Marzo de 2008 (10:42:41)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetNewObject( tcObjectName As String,;
			tcTierLevel As String,;
			tnDataSessionId As Integer  ) As Object;
			HELPSTRING "Devuelve la siguiente capa"

		Local loObject As Object
		Local llShowError As Boolean
		Local llLogError As Boolean
		Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"


		Try
			loObject = Null


			If Vartype( tcObjectName ) == "C"
				This.cObjectName = tcObjectName

			Endif && Vartype( tcObjectName ) == "C"

			loArchivo = GetTable( tcObjectName )
			loObject = NewObject( loArchivo.cBaseClass, loArchivo.cBaseClassLib )   

			* DAE 2009-10-26(14:43:42)
			If Vartype( tnDataSessionId ) == "N" And ! Empty( tnDataSessionId )
				loObject.DataSessionId = tnDataSessionId

			Endif && Vartype( tnDataSessionId ) == "N"

			If ! IsEmpty( loObject )
				This.HookAfterGetNewObject( loObject )

			Endif && ! IsEmpty( loObject )


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

			llShowError = .T.
			llLogError 	= .T.
			loError.Process( oErr, llShowError, llLogError )
			Throw loError

		Finally
			 loArchivo = Null 

		Endtry

		Return loObject

	Endproc  && GetNewObject


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: _GetNewObject
	*!* Description...: Crea un objeto local o remoto
	*!* Date..........: Viernes 7 de Marzo de 2008 (12:33:56)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Hidden Procedure _BORRAR_GetNewObject() As Object;
			HELPSTRING "Crea un objeto local o remoto"

		Local loObj As Object
		Local lcClassLibrary As String

		Local llComComponent As Boolean
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local llShowError As Boolean
		Local llLogError As Boolean

		Try

			llComComponent = This.lObjInComComponent ;
				And !This.lForceNeverUseComComponent

			If llComComponent
				loObj = This.GetComObject( This.cObjClass, This.cObjComponent )

			Else
				lcClassLibrary = Addbs( Alltrim( This.cObjClassLibraryFolder )) + ;
					Alltrim( This.cObjClassLibrary )

				loObj = Newobject( Alltrim( This.cObjClass ),;
					lcClassLibrary )

			Endif

		Catch To oErr
			llShowError = .T.
			llLogError 	= .T.

			* loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr, llShowError, llLogError )

			Local lcCommand As String
			TEXT To lcCommand NoShow TextMerge pretext 3
				<<Datetime()>>

				loObj = Newobject( Alltrim( <<This.cObjClass>> ),<<lcClassLibrary>> )

				This.cObjClass = '<<This.cObjClass>>'
				lcClassLibrary = '<<lcClassLibrary>>'

				This.cObjectName = '<<This.cObjectName>>'
				This.cTierLevel  = '<<This.cTierLevel>>'


				This.cObjClass 				= <<This.cObjClass>>
				This.cObjClassLibrary 		= <<This.cObjClassLibrary>>
				This.cObjClassLibraryFolder = <<This.cObjClassLibraryFolder>>
				This.cObjComponent 			= <<This.cObjComponent>>
				llComComponent 			 	= <<Any2Char( llComComponent )>>

			ENDTEXT

			Strtofile( lcCommand + Chr(13),"ERROR_GetNewObject.prg", 1 )
			Throw loError

		Finally
			loError = Null

		Endtry

		Return loObj

	Endproc && _GetNewObject

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ReadIniFile
	*!* Description...: Lee el archivo de configuración para poder instanciar el objeto
	*!* Date..........: Domingo 2 de Marzo de 2008 (18:47:50)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure yyyy___BORRAR___xReadIniFile( ) As Boolean;
			HELPSTRING "Lee el archivo de configuración para poder instanciar el objeto"

		Local loXA As prxXMLAdapter Of "FW\Comunes\Prg\prxXMLAdapter.prg"
		Local lcAlias As String
		Local lcXML As String
		Local lcCommand As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local llShowError As Boolean
		Local llLogError As Boolean

		Try

			lcAlias = ""

			If  FileExist( This.cObjectFactoryFileName )

				loXA = Newobject("prxXMLAdapter","FW\Comunes\Prg\prxXMLAdapter.prg")

				lcXML = Filetostr( This.cObjectFactoryFileName )

				loXA.LoadXML( lcXML )
				loXA.Tables(1).ToCursor()
				loXA = Null

				lcAlias= Alias()

				Locate For Alltrim( Lower( ObjectName )) == Alltrim( Lower( This.cObjectName )) And ;
					Alltrim( Lower( TierLevel)) = Alltrim(Lower( This.cTierLevel ))

				If !Eof()
					This.cObjClass 				= Alltrim( cObjClass )
					This.cObjClassLibrary 		= Alltrim( cObjClassLibrary )
					This.cObjClassLibraryFolder = Alltrim( cObjClassLibraryFolder )
					This.cObjComponent 			= Alltrim( cObjComponent )
					This.lObjInComComponent 	= lObjInComComponent

				Else

					TEXT To lcCommand NoShow TextMerge pretext 3
					<<Datetime()>>

					Locate For Alltrim( Lower( ObjectName )) == Alltrim( Lower( <<This.cObjectName>> )) And ;
					Alltrim( Lower( TierLevel)) = Alltrim(Lower( <<This.cTierLevel>> ))
					ENDTEXT

					Strtofile( lcCommand + Chr(13),"ERROR_ReadIniFile.prg", 1 )

				Endif
			Else
				Assert .F. Message "No existe el archivo " + This.cObjectFactoryFileName

			Endif


		Catch To oErr
			llShowError = .T.
			llLogError 	= .T.

			* loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr, llShowError, llLogError )
			Throw loError


		Finally
			*!*	If Used( lcAlias )
			*!*		Use In Alias( lcAlias )
			*!*	Endif
			Use In Select( lcAlias )

			loXA = Null

		Endtry

	Endproc && ReadIniFile

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: lForceNeverUseComComponent_Access
	*!* Date..........: Lunes 3 de Marzo de 2008 (14:15:02)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure lForceNeverUseComComponent_Access()

		This.lForceNeverUseComComponent =  FileExist( Addbs( This.cRootFolder ) + "ForceNeverUseComComponent.cfg" )

		Return This.lForceNeverUseComComponent

	Endproc && lForceNeverUseComComponent_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: HookAfterReadIni
	*!* Description...: Template Method
	*!* Date..........: Viernes 7 de Marzo de 2008 (12:27:09)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure HookAfterReadIni() As Void;
			HELPSTRING "Template Method"


	Endproc &&  HookAfterReadIni

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: HookAfterGetNewObject
	*!* Description...: Template Method
	*!* Date..........: Viernes 7 de Marzo de 2008 (12:30:00)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure HookAfterGetNewObject( toObject As Object ) As Void;
			HELPSTRING "Template Method"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local llShowError As Boolean
		Local llLogError As Boolean


		Try



		Catch To oErr
			llShowError = .T.
			llLogError 	= .T.

			* loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr, llShowError, llLogError )
			Throw loError

		Finally
			loError = Null

		Endtry

	Endproc && HookAfterGetNewObject

	*!*	///////////////////////////////////////////////////////
	*!*	Function......: GetComObject
	*!*	Description...:
	*!*	Date..........: Jueves 24 de Marzo de 2005 (19:38:31)
	*!*	Author........: Ricardo Aidelman
	*!*	Project.......: Visual Praxis Beta 1.0
	*!*	-------------------------------------------------------
	*!*	Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Hidden Function GetComObject( tcObjClass As String,;
			tcObjComponent As String ) As Object

		Local loObj As Object
		Local loComPlusInfo As COMPlusInfo Of "FW\COMPlusInfo\COMPlusInfo.prg"
		Local lcClassId As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local llShowError As Boolean
		Local llLogError As Boolean

		Try

			* Obtengo una instancia de ComPlusInfo
			loComPlusInfo = This.GetComPlusInfo()

			* Obtengo el ClassId del objeto que necesito instanciar
			If This.lDebugMode
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcClassId = loComPlusInfo.GetClassID( <<tcObjComponent>> + "." + <<tcObjClass>> )
				ENDTEXT

				Strtofile(lcCommand, This.cTierLevel + "_GetComObject 1.prg" )
			Endif

			lcClassId = loComPlusInfo.GetClassID( tcObjComponent + "." + tcObjClass )

			* Instacio el objeto remoto
			If This.lDebugMode
				TEXT To lcCommand NoShow TextMerge Pretext 15
				loObj = Createobjectex( <<lcClassId>>, <<This.cCPIServerIP>> )
				ENDTEXT

				Strtofile(lcCommand, This.cTierLevel + "_GetComObject 2.prg" )

			Endif && This.lDebugMode

			loObj = Createobjectex( lcClassId, This.cCPIServerIP )

			* Todo Salio Bien
			If This.lDebugMode
				Strtofile( " Todo Salio Bien", This.cTierLevel + "_GetComObject 2.prg", 1 )

			Endif && This.lDebugMode

		Catch To oErr

			llShowError = .F.
			llLogError 	= .F.

			* loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr, llShowError, llLogError )


			* Hubo Un Error
			If This.lDebugMode
				Strtofile( " Hubo un Error al Instanciar", "ERROR_GetComObject.prg", 1 )

			Endif && This.lDebugMode

			Throw loError

		Finally
			loComPlusInfo = Null
			loError = Null

		Endtry

		Return loObj

	Endfunc && GetComObject

	*!*	///////////////////////////////////////////////////////
	*!*	Function......: GetComPlusInfo
	*!*	Description...: Devuelve el componente ComPlusInfo
	*!*	Date..........: Jueves 24 de Marzo de 2005 (19:38:31)
	*!*	Author........: Ricardo Aidelman
	*!*	Project.......: Visual Praxis Beta 1.0
	*!*	-------------------------------------------------------
	*!*	Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Hidden Function GetComPlusInfo() As Object

		Local loComPlusInfo As Object
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local llShowError As Boolean
		Local llLogError As Boolean
		Local lcCommand As String

		Try

			If This.lDebugMode
				TEXT To lcCommand NoShow TextMerge Pretext 15
					loComPlusInfo = Createobjectex( <<This.cCPIClassId>>, <<This.cCPIServerIP>> )
				ENDTEXT

				Strtofile(lcCommand, "GetComPlusInfo 1.prg" )

			Endif && This.lDebugMode

			If Empty( This.cCPIClassId ) Or Empty( This.cCPIServerIP )
				This.RetrieveComConfig()

			Endif && Empty( This.cCPIClassId ) Or Empty( This.cCPIServerIP )

			loComPlusInfo = Createobjectex( This.cCPIClassId, This.cCPIServerIP )

		Catch To oErr

			llShowError = .F.
			llLogError 	= .F.

			* loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr, llShowError, llLogError )

			TEXT To lcCommand NoShow TextMerge pretext 3
				loComPlusInfo = Createobjectex( This.cCPIClassId, This.cCPIServerIP )
				loComPlusInfo = Createobjectex( '<<This.cCPIClassId>>', '<<This.cCPIServerIP>>' )

			ENDTEXT

			Strtofile( lcCommand + Chr(13),"ERROR_GetComPlusInfo.prg", 1 )

			Throw loError

		Finally
			loError = Null

		Endtry

		Return loComPlusInfo

	Endfunc && GetComObject

	*!* ///////////////////////////////////////////////////////
	*!* Function......: RetrieveComConfig
	*!* Description...: Lee la configuración de componentes desde un archivo XML
	*!* Date..........: Domingo 30 de Julio de 2006 (11:53:26)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: CMSI
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Function RetrieveComConfig(  ) As Boolean;
			HELPSTRING "Lee la configuración de componentes desde un archivo XML"

		Local loXA As Xmladapter
		Local lnServerId As Integer
		Local lcAlias As String
		Local llOk As Boolean

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local llShowError As Boolean
		Local llLogError As Boolean

		Try

			llOk = .T.

			lnServerId = 0
			lcAlias = ""

			If Empty( This.cCPIClassId )

				loXA = Newobject("prxXMLAdapter",;
					"prxXMLAdapter.prg")

				loXA.LoadXML( This.cConfigFileName, .T. )
				loXA.Tables(1).ToCursor()
				loXA = Null

				lcAlias= Alias()

				Locate For Lower(objName) = Alltrim(Lower(This.cObjectName))
				If Eof( Alias() )
					Locate For Lower(objName) = "default"

				Endif && Eof()

				If ! Eof( Alias() )
					lnServerId = ServerId
					This.lDebugMode = DebugComponent

				Else && ! Eof( Alias() )
					llOk = .F.

				Endif && ! Eof( Alias() )

				Use In Alias()

				If llOk And !Empty( lnServerId )

					loXA = Newobject("prxXMLAdapter",;
						"prxXMLAdapter.prg")

					If This.lDebugMode
						TEXT To lcCommand NoShow TextMerge Pretext 15
							loXA.LoadXML( <<This.cComServersConfig>>, .T. )
						ENDTEXT

						Strtofile(lcCommand, "RetrieveComConfig.prg" )

					Endif

					loXA.LoadXML( This.cComServersConfig, .T. )
					loXA.Tables(1).ToCursor()
					loXA = Null

					lcAlias = Alias()

					Locate For Id = lnServerId
					If ! Eof( Alias() )
						This.cCPIServerIP = Alltrim(ServerIp)
						This.cCPIClassId = Alltrim(ComClassId)
						This.cCPIServerName = Lower( Alltrim(ServerName) )


						* If you are running the aplication right on the server ...
						*!*							If This.cCPIServerIP = This.GetLocalIP()
						If This.cCPIServerName = Lower( This.GetMachineName() )

							* ... you must leave server's IP empty
							This.cCPIServerIP = ""
						Endif

					Else
						llOk = .F.

					Endif

					Use In Alias()

				Endif

			Endif

		Catch To oErr
			llShowError = .F.
			llLogError 	= .F.

			* loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr, llShowError, llLogError )
			Throw loError

		Finally
			loXA = .F.

			*!*	If Used( lcAlias )
			*!*		Use In Alias( lcAlias )
			*!*	Endif
			Use In Select( lcAlias )

		Endtry

		Return llOk

	Endfunc && RetrieveComConfig
	Function GetMachineName As String
		*!*	Returns the local Machine Name

		Local lcRetVal As String
		Local lcMaq As String
		Try
			lcMaq = Sys(0)
			lcRetVal = Alltrim( Substr( lcMaq, 1, At( "#", lcMaq ) - 1 ))

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError = This.oError.Process( oErr )

		Finally

		Endtry

		Return lcRetVal

	Endfunc && GetMachineName

	*
	* Obtiene los datos de configuración de la entidad
	Procedure _BORRAR_GetEntityConfig(  ) As Boolean;
			HELPSTRING "Obtiene los datos de configuración de la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Obtiene los datos de configuración de la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 3 de Julio de 2009 (18:24:40)
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

		Local lcKeyName As String,;
			lcObjectName As String
		Local lcCommand As String

		Local loEntitiesConfig As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
			loEntityConfig As Object


		Try

			lcCommand = ""

			loEntitiesConfig = NewEntitiesConfig()
			loEntityConfig = loEntitiesConfig.GetItem( This.cObjectName )

			This.cObjClass 			= loEntityConfig.cBaseClass
			This.cObjClassLibrary 	= loEntityConfig.cBaseClassLib


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

			If oErr.ErrorNo = 1924 && "name" is not an object
				If Vartype( loTable ) # "O"

					TEXT To lcCommand NoShow TextMerge Pretext 15
					loTable = loColTables.GetItem( '<<This.cObjectName>>' )
					ENDTEXT

				Endif

			Else

			Endif

			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry


	Endproc && GetEntityConfig

	*
	* Obtiene los datos de configuración de la entidad
	Procedure OldGetEntityConfig(  ) As Boolean;
			HELPSTRING "Obtiene los datos de configuración de la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Obtiene los datos de configuración de la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 3 de Julio de 2009 (18:24:40)
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

		Local loEntityConfig As TierConfig Of "Fw\TierAdapter\Comun\Prg\TierConfig.prg"
		Local lcKeyName As String

		Try

			*!*				loEntityConfig = This.oEntitiesConfig.GetEntity( This.cObjectName,;
			*!*					This.cTierLevel )

			lcKeyName =  This.cObjectName + "_" + This.cTierLevel
			loEntityConfig = This.oEntitiesConfig.GetItem( lcKeyName )

			If Vartype( loEntityConfig ) = "O"

				If Empty( loEntityConfig.cObjClass )
					Error loEntityConfig.cObjectName + " - " + loEntityConfig.TierLevel + ;
						" Falta indicar cObjClass "

				Endif

				If Empty( loEntityConfig.cObjClassLibraryFolder )
					Error loEntityConfig.cObjectName + " - " + loEntityConfig.TierLevel + ;
						" Falta indicar cObjClassLibraryFolder "

				Endif

				If loEntityConfig.lObjInComComponent And ;
						Empty( loEntityConfig.cObjComponent )
					Error loEntityConfig.cObjectName + " - " + loEntityConfig.TierLevel + ;
						" Falta indicar cObjComponent  "

				Endif

				If Empty( loEntityConfig.cObjClassLibrary )
					loEntityConfig.cObjClassLibrary = loEntityConfig.cObjClass + ".prg"
				Endif


				This.cObjClass 				= loEntityConfig.cObjClass
				This.cObjClassLibrary 		= loEntityConfig.cObjClassLibrary
				This.cObjClassLibraryFolder = loEntityConfig.cObjClassLibraryFolder
				This.cObjComponent 			= loEntityConfig.cObjComponent
				This.lObjInComComponent 	= loEntityConfig.lObjInComComponent

			Else
				TEXT To lcErrorText NoShow TextMerge Pretext 15
				No se creo la entidad '<<This.cObjectName>>' nivel '<<This.cTierLevel>>'
				ENDTEXT

				Error lcErrorText

			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

	Endproc && OldGetEntityConfig

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

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			If Pemstatus( _Screen, "oObjectFactory", 5 )
				_Screen.oObjectFactory = Null
				Removeproperty( _Screen, "oObjectFactory" )

			Endif && Pemstatus( _Screen, "oObjectFactory", 5 )

			DoDefault()

		Catch To oErr
			* loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
			loError = This.oError
			loError.Process( oErr )
			Throw loError

		Finally
			loError = Null

		Endtry

	Endproc && Destroy

Enddefine && ObjectFactory
