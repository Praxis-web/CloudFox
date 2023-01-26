#INCLUDE "FW\Tieradapter\Include\TA.h"

*!*	OJO. Falta cerrar la instanciación de clases en COM+

*!* ///////////////////////////////////////////////////////
*!* Class.........: colEntities
*!* ParentClass...: collection
*!* BaseClass.....: collection
*!* Description...:
*!* Date..........: Lunes 2 de Julio de 2007 (16:08:28)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class colEntities As PrxCollection Of "FW\TierAdapter\Comun\PrxBaseLibrary.prg"

	#If .F.
		Local This As colEntities Of "FW\TierAdapter\Comun\colEntities.prg"
	#Endif

	*!* No utiliza COM+
	lForceNeverUseComComponent  = .F.

	*!* Nombre del archivo de configuración para instanciar la siguiente capa
	cObjectFactoryFileName = "Reemplazar en colEntities cObjectFactoryFileName"

	*!* Nivel de la capa
	cTierLevel = "User"


	cClassName = "oEntity"
	cClassLibrary = "colEntities.prg"
	cClassLibraryFolder = TA_COMUN

	* Nombre de la entidad principal
	cMainEntity = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ctierlevel" type="property" display="cTierLevel" />] + ;
		[<memberdata name="cobjectfactoryfilename" type="property" display="cObjectFactoryFileName" />] + ;
		[<memberdata name="getentity" type="method" display="GetEntity" />] + ;
		[<memberdata name="cmainentity" type="property" display="cMainEntity" />] + ; 
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetEntity
	*!* Description...: Obtiene una referencia a la entidad
	*!* Date..........: Lunes 2 de Julio de 2007 (17:21:21)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetEntity( tcEntityName As String ) As Object;
			HELPSTRING "Obtiene una referencia a la entidad "

		Try

			Local loEntity As oEntity Of "FW\TierAdapter\Comun\colEntities.prg"
			Local loObj As Object

			loObj = This.GetItem( tcEntityName )
			loEntity = Null

			If Vartype( loObj ) == "O"
				loEntity = loObj.oEntity
				loEntity.cMainEntity = This.cMainEntity 
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr, .F. )
			Throw loError

		Finally

		Endtry

		Return loEntity

	Endproc
	*!*
	*!* END PROCEDURE GetEntity
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Function......: New
	*!* Description...: Obtiene un elemento oEntity vacío
	*!* Date..........: Lunes 2 de Julio de 2007 (16:13:14)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Menus
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function New( tcName As String, tcTierLevel As String ) As Object;
			HELPSTRING "Obtiene un elemento oEntity vacío"
		Try
			Local loEntity As oEntity Of "FW\TierAdapter\Comun\colEntities.prg"
			Local lcKey as String 

*!*				loEntity = DoDefault( tcName )
			loEntity = CreateObject( "oEntity" )

			If Empty( tcTierLevel )
				tcTierLevel = This.cTierLevel
			Endif

			*!* Si el parametro tcTierLevel es igual a This.TierLevel
			*!* a la entidad le asigno el oParent
			If tcTierLevel = This.cTierLevel
				loEntity.oParent = This.oParent
			Endif

			loEntity.Name = tcName
			loEntity.cTierLevel = tcTierLevel

*!*				If Empty( loEntity.cObjectFactoryFileName )
*!*					loEntity.cObjectFactoryFileName = This.cObjectFactoryFileName
*!*				EndIf
			
						
			lcKey = Alltrim( tcName ) + "_" + Alltrim( tcTierLevel )  			
			
			This.AddItem( loEntity, lcKey )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loEntity
	Endfunc
	*!*
	*!* END FUNCTION New
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: colEntities
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oEntity
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Elemento Entity de la colección Entities
*!* Date..........: Lunes 2 de Julio de 2007 (16:14:25)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class oEntity As Session

	#If .F.
		Local This As oEntity Of "FW\TierAdapter\Comun\colEntities.prg"
	#Endif

	*!*
	cObjectFactoryFileName = ""


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="oentity" type="property" display="oEntity" />] + ;
		[<memberdata name="oentity_access" type="method" display="oEntity_Access" />] + ;
		[<memberdata name="getnewobject" type="method" display="GetNewObject" />] + ;
		[<memberdata name="ccomponent" type="property" display="cComponent" />] + ;
		[<memberdata name="lcomcomponent" type="property" display="lComComponent " />] + ;
		[<memberdata name="validationname" type="property" display="ValidationName" />] + ;
		[<memberdata name="procedurename" type="property" display="ProcedureName" />] + ;
		[<memberdata name="validationname_access" type="method" display="ValidationName_Access" />] + ;
		[<memberdata name="procedurename_access" type="method" display="ProcedureName_Access" />] + ;
		[<memberdata name="cdiffgram" type="property" display="cDiffgram" />] + ;
		[<memberdata name="nlevel" type="property" display="nLevel" />] + ;
		[<memberdata name="nentidadid" type="property" display="nEntidadId" />] + ;
		[<memberdata name="nentidadid_access" type="method" display="nEntidadId_Access" />] + ;
		[<memberdata name="cobjectfactoryfilename" type="property" display="cObjectFactoryFileName" />] + ;
		[<memberdata name="lforceneverusecomcomponent" type="property" display="lForceNeverUseComComponent " />] + ;
		[<memberdata name="cTierLevel" type="property" display="cTierLevel" />] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[</VFPData>]

	*!* Nivel de la capa
	cTierLevel = "User"

	*!*
	nEntidadId = 0

	*!* Nivel de profundiad del manejo de tablas
	nLevel = 1

	*!*
	cDiffgram = ""

	*!* Nombre del método que procesa la información
	ProcedureName = ""

	*!* Nombre de método de validación
	ValidationName = ""

	*!* Referencia a la capa de usuario del objeto
	oEntity = Null

	*!* Nombre del componente a instanciar
	cComponent = ""

	*!* Semáforo que indica si la clase se encuentra en un componente
	lComComponent  = .F.

	*!* Use Default data session
	DataSession = SET_DEFAULT

	*!* No utiliza COM+
	lForceNeverUseComComponent  = .F.

	*!* Nombre del archivo de configuración para instanciar la siguiente capa
	cObjectFactoryFileName = ""

	oParent = Null


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Init
	*!* Description...:
	*!* Date..........: Lunes 2 de Julio de 2007 (16:53:52)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Init( tnDataSessionId As Integer ) As Boolean

		Local llOk As Boolean

		Try
			llOk = .T.

			If !Empty( tnDataSessionId ) And Vartype( tnDataSessionId ) = "N"
				This.DataSessionId = tnDataSessionId
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			llOk = .F.
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE Init
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oEntity_Access
	*!* Description...: Access Method
	*!* Date..........: Lunes 2 de Julio de 2007 (16:26:32)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oEntity_Access(  ) As Object;
			HELPSTRING "Access Method"
		Try

			If Vartype( This.oEntity ) <> "O"

				Local loParam As Object
				Local loObjectFactory As ObjectFactory Of "Fw\comunes\Prg\ObjectFactory.prg"

*!*					loParam = Createobject( "Empty" )
*!*					AddProperty( loParam, "lObjInComComponent", This.lComComponent )
*!*					AddProperty( loParam, "cObjComponent", This.cComponent )
*!*					AddProperty( loParam, "cObjectName", This.Name )
*!*					AddProperty( loParam, "cTierLevel", This.cTierLevel )
*!*					AddProperty( loParam, "cObjectFactoryFileName", This.cObjectFactoryFileName )

*!*					loObjectFactory = Newobject( "ObjectFactory",;
*!*						"ObjectFactory.prg",;
*!*						"",;
*!*						loParam )

*!*					This.oEntity = loObjectFactory.GetNewObject()

				loObjectFactory = NewObjectFactory()

				This.oEntity = loObjectFactory.GetNewObject( This.Name, This.cTierLevel )


				This.oEntity.oParent = This.oParent

				If !Empty( This.DataSessionId )
					This.oEntity.DataSessionId = This.DataSessionId
				EndIf
				
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr, .F. )
			Throw loError

		Finally
			loParam = Null
			loObjectFactory = Null

		Endtry

		Return This.oEntity

	Endproc
	*!*
	*!* END PROCEDURE oEntity_Access
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ValidationName_Access
	*!* Description...:
	*!* Date..........: Miércoles 15 de Agosto de 2007 (14:51:32)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ValidationName_Access(  ) As String

		If Empty( This.ValidationName )
			This.ValidationName = "ValidatePut"
		Endif

		Return This.ValidationName

	Endproc
	*!*
	*!* END PROCEDURE ValidationName_Access
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ProcedureName_Access
	*!* Description...:
	*!* Date..........: Miércoles 15 de Agosto de 2007 (14:52:00)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ProcedureName_Access(  ) As String

		If Empty( This.ProcedureName )
			This.ProcedureName = "Process" + This.Name
		Endif

		Return This.ProcedureName

	Endproc
	*!*
	*!* END PROCEDURE ProcedureName_Access
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: nEntidadId_Access
	*!* Description...:
	*!* Date..........: Lunes 20 de Agosto de 2007 (14:45:47)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure nEntidadId_Access(  ) As Integer

		If Empty( This.nEntidadId )
			This.nEntidadId = This.oEntity.nEntidadId
		Endif

		Return This.nEntidadId

	Endproc
	*!*
	*!* END PROCEDURE nEntidadId_Access
	*!*
	*!* ///////////////////////////////////////////////////////


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oEntity
*!*
*!* ///////////////////////////////////////////////////////