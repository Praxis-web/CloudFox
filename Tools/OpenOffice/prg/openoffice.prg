
*!* ///////////////////////////////////////////////////////
*!* Class.........: OpenOffice
*!* ParentClass...: prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....: Custom
*!* Description...: Wrapper para el manejo de OpenOffice por Automation
*!* Date..........: Miércoles 29 de Diciembre de 2010 (15:55:02)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class OpenOffice As prxCustom Of 'V:\CloudFox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'

	#If .F.
		Local This As OpenOffice Of "V:\CloudFox\Tools\Openoffice\Prg\OpenOffice.prg"
	#Endif

	* Reference to OpenOffice.org desktop object
	oDesktop = Null

	* Reference to OpenOffice.org service manager object
	oServiceManager = Null

	*
	oCoreReflection = Null

	*
	oDispatcher = Null

	* Indica si los parámetros par operaciones con vectores consideran base cero
	lCeroBase = .F.


	* Referencia al documento activo
	oDocument = Null


	*
	oLocalSettings = Null




	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="olocalsettings" type="property" display="oLocalSettings" />] + ;
		[<memberdata name="olocalsettings_access" type="method" display="oLocalSettings_Access" />] + ;
		[<memberdata name="odocument" type="property" display="oDocument" />] + ;
		[<memberdata name="lcerobase" type="property" display="lCeroBase" />] + ;
		[<memberdata name="odispatcher" type="property" display="oDispatcher" />] + ;
		[<memberdata name="odispatcher_access" type="method" display="oDispatcher_Access" />] + ;
		[<memberdata name="odesktop" type="property" display="oDesktop" />] + ;
		[<memberdata name="odesktop_access" type="method" display="oDesktop_Access" />] + ;
		[<memberdata name="oservicemanager" type="property" display="oServiceManager" />] + ;
		[<memberdata name="oservicemanager_access" type="method" display="oServiceManager_Access" />] + ;
		[<memberdata name="createinstance" type="method" display="CreateInstance" />] + ;
		[<memberdata name="ocorereflection" type="property" display="oCoreReflection" />] + ;
		[<memberdata name="ocorereflection_access" type="method" display="oCoreReflection_Access" />] + ;
		[<memberdata name="releasecachedvars" type="method" display="ReleaseCachedVars" />] + ;
		[<memberdata name="openurl" type="method" display="OpenURL" />] + ;
		[<memberdata name="makepropertyvalue" type="method" display="MakePropertyValue" />] + ;
		[<memberdata name="createstruct" type="method" display="CreateStruct" />] + ;
		[<memberdata name="converttourl" type="method" display="ConvertToURL" />] + ;
		[<memberdata name="newcalc" type="method" display="NewCalc" />] + ;
		[<memberdata name="newwriter" type="method" display="NewWriter" />] + ;
		[</VFPData>]


	*
	* Crea una nueva hoja de cálculo
	Procedure NewCalc(  ) As Object;
			HELPSTRING "Crea una nueva hoja de cálculo"

		Return This.OpenURL( "private:factory/scalc" )

	Endproc && NewCalc


	*
	* Crea un nuevo documento de texto
	Procedure NewWriter(  ) As Object;
			HELPSTRING "Crea un nuevo documento de texto"

		Return This.OpenURL( "private:factory/swriter" )

	Endproc && NewWriter


	* Creates an instance of some other OpenOffice.org UNO (Universal Network Objects) object.
	*
	Procedure CreateInstance( tcServiceName As String ) As Object

		Local loInstance As Object

		Try

			loInstance = .Null.

			Try

				loInstance = This.oServiceManager.CreateInstance( tcServiceName )

			Catch To oErr

			Finally

			Endtry

			If Isnull( loInstance )
				This.ReleaseCachedVars()
				loInstance = This.oServiceManager.CreateInstance( tcServiceName )
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loInstance

	Endproc && CreateInstance




	* Open or Create a document from it's URL.
	* New documents are created by URL's such as:
	*   "private:factory/sdraw"
	*   "private:factory/swriter"
	*   "private:factory/scalc"
	*   "private:factory/simpress"
	*
	*
	Procedure OpenURL( tcURL As String ) As Object

		Local Array laArgs[1]
		Local loDesktop As Object
		Local loDocument As Object

		Try

			laArgs[1] = This.MakePropertyValue( "Hidden", .F. )
			loDesktop = This.oDesktop

			loDocument = loDesktop.LoadComponentFromUrl( tcURL, "_blank", 0, @ laArgs )

			* Make sure that arrays passed to this document are passed zero based.
			Comarray( loDocument, 10 )

			This.oDocument = loDocument

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loDocument

	Endproc && OpenURL


	*
	* Libera las variables guardadas en cache
	Procedure ReleaseCachedVars(  ) As Void;
			HELPSTRING "Libera las variables guardadas en cache"
		Try
			This.oCoreReflection 	= Null
			This.oDesktop 			= Null
			This.oServiceManager 	= Null
			This.oDispatcher 		= Null
			This.oLocalSettings 	= Null

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && ReleaseCachedVars




	*
	* Create a com.sun.star.beans.PropertyValue struct and return it.
	*
	Procedure MakePropertyValue(  tcName As String,;
			tuValue As Variant,;
			tnHandle As Integer,;
			tnState As Integer,;
			tlIsArray as Boolean ) As Object

		Local loPropertyValue

		Try

			loPropertyValue = This.CreateStruct( "com.sun.star.beans.PropertyValue" )

			loPropertyValue.Name	= tcName
			
			If tlIsArray
				Acopy( tuValue, loPropertyValue.Value )
				
			Else 
				loPropertyValue.Value 	= tuValue
				
			EndIf

			If Vartype( tnHandle ) = "N"
				loPropertyValue.Handle = tnHandle
			Endif

			If Vartype( tnState ) = "N"
				loPropertyValue.State = tnState
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loPropertyValue

	Endproc && MakePropertyValue




	* Convert a local filename to an OOo URL.
	*
	Procedure ConvertToURL( tcFilename As String ) As String

		Local lcURL

		Try

			* Ensure leading slash.
			If Left( tcFilename, 1 ) # "/"
				tcFilename = "/" + tcFilename
			Endif

			lcURL = Chrtran( tcFilename, "\", "/" )   && change backslashes to forward slashes.
			lcURL = "file://" + lcURL

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcURL

	Endproc && ConvertToURL



	* Sugar coated routine to create any UNO struct.
	* Use the Bridge_GetStruct() feature of the OLE-UNO bridge.
	*
	Procedure CreateStruct( tcTypeName ) As Object
		Local loServiceManager
		Local loStruct

		Try

			loServiceManager = This.oServiceManager
			loStruct = .Null.

			Try

				loStruct = loServiceManager.Bridge_GetStruct( tcTypeName )

			Catch To oErr

			Finally

			Endtry

			If Isnull( loStruct )
				This.ReleaseCachedVars()

				loServiceManager = This.oServiceManager
				loStruct = loServiceManager.Bridge_GetStruct( tcTypeName )
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loStruct

	Endproc && CreateStruct


	*
	* oDesktop_Access
	Protected Procedure oDesktop_Access()

		If Vartype( This.oDesktop ) # "O"
			This.oDesktop = This.CreateInstance( "com.sun.star.frame.Desktop" )
			Comarray( This.oDesktop, 10 )
		Endif

		Return This.oDesktop

	Endproc && oDesktop_Access

	*
	* oDispatcher_Access
	Protected Procedure oDispatcher_Access()
		If Vartype( This.oDispatcher ) # "O"
			This.oDispatcher = This.CreateInstance( "com.sun.star.frame.DispatchHelper" )
			Comarray( This.oDispatcher, 10 )
		Endif

		Return This.oDispatcher

	Endproc && oDispatcher_Access


	*
	* oServiceManager_Access
	Protected Procedure oServiceManager_Access()

		If Vartype( This.oServiceManager ) # "O"
			This.oServiceManager = Createobject( "com.sun.star.ServiceManager" )
		Endif

		Return This.oServiceManager

	Endproc && oServiceManager_Access


	*
	* oCoreReflection_Access
	Protected Procedure oCoreReflection_Access()

		Return This.oCoreReflection

	Endproc && oCoreReflection_Access

	*
	* oLocalSettings_Access
	Protected Procedure oLocalSettings_Access()
	Local loLocalSettings as Object 

		If Vartype( This.oLocalSettings ) # "O"
			This.oLocalSettings = This.CreateStruct( "com.sun.star.lang.Locale" )
			loLocalSettings = This.oLocalSettings 
			loLocalSettings.Language = "en"
			loLocalSettings.Country = "us"		
				
		EndIf
	
		Return This.oLocalSettings
		

	Endproc && oLocalSettings_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: OpenOffice
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: Calc
*!* ParentClass...: OpenOffice Of 'V:\CloudFox\Tools\Openoffice\Prg\Openoffice.prg'
*!* BaseClass.....: Custom
*!* Description...: Interfaz para el manejo de Hoja de Calculo
*!* Date..........: Jueves 30 de Diciembre de 2010 (12:20:03)
*!* Author........: Ricardo Aidelman
*!* Project.......: CloudFox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class Calc As OpenOffice Of 'V:\CloudFox\Tools\Openoffice\Prg\Openoffice.prg'

	#If .F.
		Local This As Calc Of "V:\CloudFox\Tools\Openoffice\Prg\Openoffice.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cellsselect" type="method" display="CellsSelect" />] + ;
		[</VFPData>]



	*
	* Selecciona un rango de celdas
	Procedure CellsSelect( tnFromCol As Integer,;
			tnFromRow As Integer,;
			tnToCol As Integer,;
			tnToRow As Integer ) As Void;
			HELPSTRING "Selecciona un rango de celdas"

		Local llSingleCell As Boolean
		Local loDispatcher As Object
		Local loDocument As Object
		Local lcName As String,;
			lcValue As String

		Local Array laArgs[1]

		Try
			llSingleCell 	= Vartype( tnToRow ) == "L"
			loDispatcher 	= This.oDispatcher
			loDocument 		= This.oDocument
			lcName 			= "ToPoint"

			If This.lCeroBase
				tnFromRow = tnFromRow + 1
				tnFromCol = tnFromCol + 1
			Endif


			lcValue = "$" + xlsColumn( tnFromCol ) + "$" + Transform( tnFromRow )

			If !llSingleCell
				If This.lCeroBase
					tnToRow = tnToRow + 1
					tnToCol = tnToCol + 1
				Endif

				lcValue = lcValue + ":$" + xlsColumn( tnToCol ) + "$" + Transform( tnToRow )
			Endif

			laArgs[ 1 ] = This.MakePropertyValue( lcName, lcValue )

			loDispatcher.executeDispatch( loDocument, ".uno:GoToCell", "", 0, @ laArgs )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loDispatcher 	= Null
			loDocument 		= Null

		Endtry

	Endproc && CellsSelect

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Calc
*!*
*!* ///////////////////////////////////////////////////////
