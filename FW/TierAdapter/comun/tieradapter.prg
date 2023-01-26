#INCLUDE "FW\TierAdapter\Include\TA.h"
#INCLUDE "FW\ErrorHandler\EH.h"


* Asegurarse que las siguientes clase van a incluirse en el proyecto
Define Class oDummy1 As prxXMLAdapter Of "FW\Comunes\Prg\PrxXmlAdapter.prg"
Enddefine

Define Class oDummy2 As prxCursorAdapter Of "FW\Comunes\Prg\prxCursorAdapter.prg"
Enddefine

Define Class oDummy3 As colEntities Of "FW\Comunes\Prg\colEntities.prg"
Enddefine

*
* Clase principal
Define Class TierAdapter As PrxSession Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"

	#If .F.
		TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Abstract Class
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (09:09:50)
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
			*:Exceptions:
			*:SeeAlso:
			UserTierAdapter
			BizTierAdapter
			DataTierAdapter
			ServiceTierAdapter
			*:EndHelp
		ENDTEXT
	#Endif

	#If .F.
		Local This As TierAdapter Of "FW\TierAdapter\Comun\TierAdapter.prg"
	#Endif

	cUniqueKey = ""

	*	Indica el nivel de la capa dentro del modelo, se especifica en la especialización de cada capa.
	cTierLevel = ""

	*	Indica si el componente se encuentra en una .dll externa
	lComComponent = .F.

	*	Referencia a la siguiente capa
	oNextTier = Null

	* Nombre del archivo de configuración ("SysConfig.xml")
	*		<objname>Default</objname>				Nombre del Objeto
	*		<serverid>1</serverid>					Id del servidor donde debe conectarse
	*		<DebugComponent>False</DebugComponent>	Si es TRUE, loguea los comandos que está ejecutando
	cConfigFileName = ""

	* Nombre del archivo de configuración del componente ComPlusInfo
	*	( Por default es "ComServersSetUp.xml" )
	*	El valor del campo "id" se corresponde con el definido en el campo"ObjectName"
	*	del archivo de configuracion indicado en This.cConfigFileName

	*	<ComServersSetUp>
	*		<id>1</id>
	*		<name>BizServer</name>
	*		<serverip>192.168.1.50</serverip>
	*		<comclassid>{559DA7D7-CCB4-4EA0-9C59-72078467E5F7}</comclassid>
	*		<servername>Maq-Ricardo</servername>
	*	</ComServersSetUp>
	*	<ComServersSetUp>
	*		<id>2</id>
	*		<name>DataServer</name>
	*		<serverip>192.168.1.50</serverip>
	*		<comclassid>{559DA7D7-CCB4-4EA0-9C59-72078467E5F7}</comclassid>
	*		<servername>Maq-Ricardo</servername>
	*	</ComServersSetUp>
	cComServersConfig = ""

	*	Nombre del archivo externo que contiene	la metadata para contruir los objetos
	*!*		cObjectFactoryFileName = "ObjectFactoryCfg.xml"

	* Nombre del archivo que contiene la carpeta por default para la capa
	*	Del lado del cliente, la carpeta plr default es la carpeta donde se
	*	instala el ejecutable.
	*	Del lado del servidor, COM+ define como carpeta por default la
	*	carpeta %SystemRoot%\system32\
	*	Si se quiere que la carpeta por default sea otra, se define este archivo.
	*	Los mensajes de error se loguean en la carpeta por default

	*	<defaultfolder>C:\Archivos de programa\Praxis\Server</defaultfolder>
	cSystemDefaultFileName = ""

	*	Referencia a la colección Tables de la entidad
	oColTables = Null

	*	Flag para loguear informacion de debug
	lDebugMode	= .F.

	* Flag que indica si la clase se destruye automáticamente al devolver información
	lAutoDestroy = .T.

	* Nombre del cursor principal
	cMainCursorName = ""

	* Valor de la PK del cursor principal
	cMainCursorPK = ""

	* Nombre de la Tabla asociada al cursor principal
	cMainTableName = ""

	* Indica el estado de la siguiente capa antes de crearla,
	* para restaurarlo luego del proceso
	lNextTierAlreadyExist = .F.

	* Indica si se está procesando un ALTA, una MODIFICACION o una BAJA
	nProcessType = 0

	* Indica el resultado de la ultima consulta
	nResultStatus = RESULT_OK

	* Contiene la IP del server donde está publicado el componente
	* ComPlusinfo correspondiente a la siguiente capa
	cCPIServerIP = ""

	* Contiene el Nombre del server donde está publicado el componente
	cCPIServerName = ""

	* Contiene el ClassId del componente ComPlusInfo
	cCPIClassId = ""

	* Clave de búsqueda del objeto en los archivos de configuración
	cDataConfigurationKey = ""

	* Indica la carpeta por default
	cDefaultFolder = ""

	* Nombre de la siguiente capa
	cNextTierLevel = ""

	* Colección de objetos de negocio que intervendran en la transaccion
	oColEntities = Null

	* Permite almacenar el id de la entidad
	nEntidadId = 0

	* Referencia al Objeto Padre
	oParent = Null

	* Referencia al usuario actual
	oUser = Null

	* Flag
	lOnDestroy = .F.

	* Referencia al componente de servicios
	oServiceTier = Null

	* Indica si los cursores generados por GetData() soportan transacciones
	lMakeTransactable = .T.

	*!* Se utiliza para almacenar el ID de la Transacción
	nTransactionID = -1

	*!* Indica si serializa los cursores para pasarlos entre capas
	lSerialize = .F.

	* Nombre del Cursor Activi asociado a la Entidad
	cEntityCursor = ""

	* Referencia a la colección hijos
	oColChildren = Null

	* Nombre de la entidad principal
	cMainEntity = ""

	* Diccionario de Datos
	oDataDictionary = Null

	*!* Indica si la entidad setea el buffer del cursor en 5
	lNeedBuffering = .T.

	*!* Indica que la entidad se comporta como Child
	lIsChild = .F.

	*!* Indica que el codigo que se esta ejecuntado se disparo desde un access de una propiedad
	Protected lIsInAccess
	lIsInAccess = .F.

	*!* Indica que el codigo que se esta ejecuntado se disparo desde un asign de una propiedad
	Protected lIsInAssign

	lIsInAssign = .F.


	* Indica si la entidad utiliza el campo Codigo, independientemente si lo tiene o no
	lUseCodigo = .T.

	* Indica si la entidad utiliza el campo CODIGO
	lHasCodigo = .F.

	* Indica si la entidad utiliza el campo DESCRIPCION
	lHasDescripcion = .F.

	* Indica si la entidad utiliza el campo DEFAULT
	lHasDefault = .F.

	* Indica si es la entidad principal
	lIsMainEntity = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="getallcombo" type="method" display="GetAllCombo" />] + ;
		[<memberdata name="hookbeforegetallcombo" type="method" display="HookBeforeGetAllCombo" />] + ;
		[<memberdata name="hookaftergetallcombo" type="method" display="HookAfterGetAllCombo" />] + ;
		[<memberdata name="deserialize" type="property" display="DeSerialize" />] + ;
		[<memberdata name="lismainentity" type="property" display="lIsMainEntity" />] + ;
		[<memberdata name="getentityid" type="method" display="GetEntityId" />] + ;
		[<memberdata name="setrelation" type="method" display="SetRelation" />] + ;
		[<memberdata name="internalsetrelation" type="method" display="InternalSetRelation" />] + ;
		[<memberdata name="lserialize" type="property" display="lSerialize" />] + ;
		[<memberdata name="centitycursor" type="property" display="cEntityCursor" />] + ;
		[<memberdata name="lmaketransactable" type="property" display="lMakeTransactable" />] + ;
		[<memberdata name="londestroy" type="property" display="lOnDestroy" />] + ;
		[<memberdata name="ocolentities" type="property" display="oColEntities" />] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[<memberdata name="nentidadid" type="property" display="nEntidadId" />] + ;
		[<memberdata name="getentity" type="method" display="GetEntity" />] + ;
		[<memberdata name="cdataconfigurationkey" type="property" display="cDataConfigurationKey " />] + ;
		[<memberdata name="nresultstatus" type="property" display="nResultStatus" />] + ;
		[<memberdata name="nprocesstype" type="property" display="nProcessType" />] + ;
		[<memberdata name="lnexttieralreadyexist" type="property" display="lNextTierAlreadyExist" />] + ;
		[<memberdata name="cmaincursorname" type="property" display="cMainCursorName" />] + ;
		[<memberdata name="cmaincursorpk" type="property" display="cMainCursorPK" />] + ;
		[<memberdata name="cmaintablename" type="property" display="cMainTableName" />] + ;
		[<memberdata name="ctierlevel" type="property" display="cTierLevel" />] + ;
		[<memberdata name="onexttier" type="property" display="oNextTier" />] + ;
		[<memberdata name="lcomcomponent" type="property" display="lComComponent" />] + ;
		[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
		[<memberdata name="lautodestroy" type="property" display="lAutoDestroy" />] + ;
		[<memberdata name="copytables" type="method" display="CopyTables" />] + ;
		[<memberdata name="hookbeforegetall" type="method" display="HookBeforeGetAll" />] + ;
		[<memberdata name="getall" type="method" display="GetAll" />] + ;
		[<memberdata name="hookaftergetall" type="method" display="HookAfterGetAll" />] + ;
		[<memberdata name="hookbeforegetdata" type="method" display="HookBeforeGetData" />] + ;
		[<memberdata name="getdata" type="method" display="GetData" />] + ;
		[<memberdata name="hookaftergetdata" type="method" display="HookAfterGetData" />] + ;
		[<memberdata name="hookbeforegetone" type="method" display="HookBeforeGetOne" />] + ;
		[<memberdata name="getone" type="method" display="GetOne" />] + ;
		[<memberdata name="hookaftergetone" type="method" display="HookAfterGetOne" />] + ;
		[<memberdata name="gettables" type="method" display="GetTables" />] + ;
		[<memberdata name="hookbeforenew" type="method" display="HookBeforeNew" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="hookafternew" type="method" display="HookAfterNew" />] + ;
		[<memberdata name="senddata" type="method" display="SendData" />] + ;
		[<memberdata name="serialize" type="method" display="Serialize" />] + ;
		[<memberdata name="setenvironment" type="method" display="SetEnvironment" />] + ;
		[<memberdata name="ldebugmode" type="property" display="lDebugMode" />] + ;
		[<memberdata name="hookbeforeexecutenonquery" type="method" display="HookBeforeExecuteNonQuery" />] + ;
		[<memberdata name="executenonquery" type="method" display="ExecuteNonQuery" />] + ;
		[<memberdata name="hookafterexecutenonquery" type="method" display="HookAfterExecuteNonQuery" />] + ;
		[<memberdata name="retrievenexttierdata" type="method" display="RetrieveNextTierData" />] + ;
		[<memberdata name="lookovercoltables" type="method" display="LookOverColTables" />] + ;
		[<memberdata name="addtable" type="method" display="AddTable" />] + ;
		[<memberdata name="getmaincursorname" type="method" display="GetMainCursorName" />] + ;
		[<memberdata name="getmaincursorpk" type="method" display="GetMainCursorPK" />] + ;
		[<memberdata name="getmaintablename" type="method" display="GetMainTableName" />] + ;
		[<memberdata name="getformid" type="method" display="GetFormId" />] + ;
		[<memberdata name="getprior" type="method" display="GetPrior" />] + ;
		[<memberdata name="getnext" type="method" display="GetNext" />] + ;
		[<memberdata name="getlast" type="method" display="GetLast" />] + ;
		[<memberdata name="getfirst" type="method" display="GetFirst" />] + ;
		[<memberdata name="hookbeforegetbywhere" type="method" display="HookBeforeGetByWhere" />] + ;
		[<memberdata name="getbywhere" type="method" display="GetByWhere" />] + ;
		[<memberdata name="hookaftergetbywhere" type="method" display="HookAfterGetByWhere" />] + ;
		[<memberdata name="generatevalidationreport" type="method" display="GenerateValidationReport" />] + ;
		[<memberdata name="validatexml" type="method" display="ValidateXml" />] + ;
		[<memberdata name="setsystemdefault" type="method" display="SetSystemDefault" />] + ;
		[<memberdata name="hookbeforeput" type="method" display="HookBeforePut" />] + ;
		[<memberdata name="hookbeforeclosecursors" type="method" display="HookBeforeCloseCursors" />] + ;
		[<memberdata name="closecursors" type="method" display="CloseCursors" />] + ;
		[<memberdata name="hookafterclosecursors" type="method" display="HookAfterCloseCursors" />] + ;
		[<memberdata name="closetable" type="method" display="CloseTable" />] + ;
		[<memberdata name="getback" type="method" display="GetBack" />] + ;
		[<memberdata name="addvalidationreport" type="method" display="AddValidationReport" />] + ;
		[<memberdata name="internalapplydiffgram" type="method" display="InternalApplyDiffgram" />] + ;
		[<memberdata name="getallpaginated" type="method" display="GetAllPaginated" />] + ;
		[<memberdata name="getallpaginatedcount" type="method" display="GetAllPaginatedCount" />] + ;
		[<memberdata name="ccomserversconfig" type="property" display="cComServersConfig " />] + ;
		[<memberdata name="hookbeforeinitialize" type="method" display="HookBeforeInitialize" />] + ;
		[<memberdata name="initialize" type="method" display="Initialize" />] + ;
		[<memberdata name="hookafterinitialize" type="method" display="HookAfterInitialize" />] + ;
		[<memberdata name="cnexttierlevel" type="property" display="cNextTierLevel" />] + ;
		[<memberdata name="instanciateentity" type="method" display="InstanciateEntity" />] + ;
		[<memberdata name="ccpiserverip" type="property" display="cCPIServerIP " />] + ;
		[<memberdata name="cdefaultfolder" type="property" display="cDefaultFolder" />] + ;
		[<memberdata name="cobjectfactoryfilename" type="property" display="cObjectFactoryFileName" />] + ;
		[<memberdata name="ouser" type="property" display="oUser" />] + ;
		[<memberdata name="datahaschanges" type="method" display="DataHasChanges" />] + ;
		[<memberdata name="getreccount" type="method" display="GetRecCount" />] + ;
		[<memberdata name="ntransactionid" type="property" display="nTransactionID" />] + ;
		[<memberdata name="ocolchildren" type="property" display="oColChildren" />] + ;
		[<memberdata name="cmainentity" type="property" display="cMainEntity" />] + ;
		[<memberdata name="odatadictionary" type="property" display="oDataDictionary" />] + ;
		[<memberdata name="GetFieldProperty" type="method" display="GetFieldProperty" />] + ;
		[<memberdata name="setdefaults" type="method" display="SetDefaults" />] + ;
		[</VFPData>]

	*!*			[<memberdata name="lneedbuffering" type="property" display="lNeedBuffering" />] + ;
	*!*			[<memberdata name="lisinaccess" type="property" display="lIsInAccess" />] + ;
	*!*			[<memberdata name="lisinassign" type="property" display="lIsInAssign" />] + ;
	*!*			[<memberdata name="locatepk" type="method" display="LocatePK" />] + ;



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: nEntidadId_Access
	*!* Date..........: Jueves 16 de Julio de 2009 (15:05:47)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure nEntidadId_Access() As Integer
		* DAE 2009-07-21 (16:32:59).
		With This As TierAdapter Of fw\TierAdapter\comun\TierAdapter.prg
			.lIsInAccess = .T.
			.nEntidadId = .oServiceTier.nEntidadId
			.lIsInAccess = .F.

		Endwith
		Return This.nEntidadId

	Endproc && nEntidadId_Access

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: nEntidadId_Assign
	*!* Date..........: Jueves 16 de Julio de 2009 (15:05:47)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure nEntidadId_Assign( uNewValue As Integer )

		With This As TierAdapter Of fw\TierAdapter\comun\TierAdapter.prg
			.lIsInAssign = .T.
			.nEntidadId = uNewValue
			If ! .lIsInAccess
				.oServiceTier.nEntidadId = uNewValue

			Endif && ! This.lIsInAccess
			.lIsInAssign = .F.
		Endwith

	Endproc && nEntidadId_Assign

	*
	* ClassBefore Event
	* Inicializa al objeto
	Protected Procedure ClassBeforeInitialize(  ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 15 de Mayo de 2009 (10:42:51)
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

		Local llExecuteInitialize As Boolean

		Try

			llExecuteInitialize = .T.

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

		Return llExecuteInitialize

	Endproc && ClassBeforeInitialize
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Inicializa al objeto
	Procedure HookBeforeInitialize(  ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 15 de Mayo de 2009 (10:42:51)
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

		Local llExecuteInitialize As Boolean

		Try

			llExecuteInitialize = .T.

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

		Return llExecuteInitialize

	Endproc && HookBeforeInitialize
	*
	* Inicializa al objeto
	Procedure Initialize( uParam As Variant ) As Boolean;
			HELPSTRING "Inicializa al objeto"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Inicializa al objeto
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 15 de Mayo de 2009 (10:42:51)
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

		Try

			If This.ClassBeforeInitialize(  ) And This.lIsOk

				If This.HookBeforeInitialize(  ) And This.lIsOk

					If This.lIsOk
						This.SetEnvironment()
					Endif

					If Empty(This.cDataConfigurationKey)
						* Fuerza _Access
					Endif

					If This.lIsOk
						This.SetSystemDefault()
					Endif

					If This.lIsOk
						This.HookAfterInitialize(  )
					Endif

					This.cUniqueKey = Sys(2015)+This.Name+Sys(2015)

				Endif

				If This.lIsOk
					This.ClassAfterInitialize(  )
				Endif

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

	Endproc && Initialize
	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Inicializa al objeto
	Procedure HookAfterInitialize(  ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 15 de Mayo de 2009 (10:42:51)
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
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	Endproc && HookAfterInitialize
	*
	* ClassAfter Event
	* Inicializa al objeto
	Protected Procedure ClassAfterInitialize(  ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 15 de Mayo de 2009 (10:42:51)
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
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	Endproc && ClassAfterInitialize


	*
	* ClassBefore Event
	* Setea el Entorno de Datos
	Protected Procedure ClassBeforeSetEnvironment(  ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:08:52)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteSetEnvironment As Boolean

		Try

			llExecuteSetEnvironment = .T.

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

		Return llExecuteSetEnvironment

	Endproc
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Setea el Entorno de Datos
	Procedure HookBeforeSetEnvironment(  ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:08:52)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteSetEnvironment As Boolean

		Try

			llExecuteSetEnvironment = .T.

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

		Return llExecuteSetEnvironment

	Endproc
	* Setea el Entorno de Datos
	Protected Procedure SetEnvironment(  ) As Void;
			HELPSTRING "Setea el Entorno de Datos"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Setea el Entorno de Datos
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:08:52)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			If This.ClassBeforeSetEnvironment(  ) And This.lIsOk

				If This.HookBeforeSetEnvironment(  ) And This.lIsOk

					Set Century On
					Set Date Dmy
					Set Deleted On
					Set Multilocks On
					Set Cpdialog Off
					Set TablePrompt Off
					Set ReportBehavior 90
					Set Exact On

					If This.lIsOk
						This.HookAfterSetEnvironment(  )
					Endif

				Endif

				If This.lIsOk
					This.ClassAfterSetEnvironment(  )
				Endif

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

	Endproc
	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Setea el Entorno de Datos
	Procedure HookAfterSetEnvironment(  ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:08:52)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	Endproc
	*
	* ClassAfter Event
	* Setea el Entorno de Datos
	Protected Procedure ClassAfterSetEnvironment(  ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:08:52)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	Endproc

	*
	* Devuelve un XML con los cursores de la coleccion tables
	Protected Procedure SendData( tnLevel As Integer,;
			tcAlias As String ) As String;
			HELPSTRING "Devuelve un XML con los cursores de la coleccion tables"


		#If .F.
			TEXT
		        *:Help Documentation
		        *:Topic:
		        *:Description:
		        Devuelve un XML con los cursores de la coleccion tables
		        *:Project:
		        Sistemas Praxis
		        *:Autor:
		        Ricardo Aidelman
		        *:Date:
		        Lunes 27 de Abril de 2009 (18:00:02)
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
		        tnLevel AS Integer
				tcAlias AS String
		        *:Remarks:
		        *:Returns:
		        *:Exceptions:
		        *:SeeAlso:
				*:EndHelp
			ENDTEXT
		#Endif

		Local loXA As prxXMLAdapter Of "FW\Comunes\Prg\prxXMLAdapter.prg"
		Local lcRetVal As String
		Local loParam As Object

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			lcRetVal = ""

			If This.lSerialize
				If This.lIsOk
					* Creates an XmlAdapter

					loXA = Newobject("prxXMLAdapter",;
						"prxXMLAdapter.prg" )

					loParam = Createobject("Empty")
					AddProperty(loParam, "oXA", loXA )
					AddProperty(loParam, "nLevel", tnLevel )
					AddProperty(loParam, "cAlias", tcAlias )

					If This.LookOverColTables( This.oColTables, "AddTable", loParam)
						* Sets XmlAdapter properties
						loXA.PreserveWhiteSpace = .T.
						loXA.ToXML( "lcRetVal" )
						This.lIsOk = loXA.lIsOk
						This.cXMLoError = loXA.cXMLoError

					Endif

					If This.lIsOk
						This.LookOverColTables( This.oColTables, "CloseTable", loParam )
					Endif

				Else
					lcRetVal = This.cXMLoError

				Endif
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

		Return( lcRetVal )

	Endproc


	*
	* Agrega la tabla al XMLAdapter
	Protected Procedure AddTable( toTable As oTable Of "FW\Comunes\Prg\ColTables.prg",;
			toParam As Object  ) As Boolean;
			HELPSTRING "Agrega la tabla al XMLAdapter"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Agrega la tabla al XMLAdapter
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:24:35)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcAlias As String

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			If !Pemstatus( toParam, "cAlias", 5 )
				AddProperty( toParam, "cAlias", "" )
			Endif

			If toTable.Nivel - toParam.nOffSet <= toParam.nLevel
				lcAlias = toTable.CursorName

				If toTable.Nivel - toParam.nOffSet = 1 And !Empty( toParam.cAlias )
					lcAlias = toParam.cAlias
				Endif

				If Used( lcAlias )
					toParam.oXA.AddTableSchema( lcAlias )
				Endif
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

		Return This.lIsOk

	Endproc


	*
	* Cierra la tabla del XMLAdapter
	Protected Procedure CloseTable( toTable As oTable Of "FW\Comunes\Prg\ColTables.prg",;
			toParam As Object ) As Boolean;
			HELPSTRING "Cierra la tabla del XMLAdapter"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Cierra la tabla del XMLAdapter
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:44:59)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			Local lnLevel As Integer
			Local lcAlias As String

			lcAlias = toTable.CursorName

			If Vartype( toParam ) = "N"
				lnLevel= toParam

			Else
				lnLevel = toParam.nLevel

				If toTable.Nivel - toParam.nOffSet = 1 And !Empty( toParam.cAlias )
					lcAlias = toParam.cAlias
				Endif

			Endif

			If toTable.Nivel - toParam.nOffSet <= lnLevel
				If Used( lcAlias )
					Use In ( lcAlias )
				Endif
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

		Return This.lIsOk

	Endproc

	*
	* ClassBefore Event
	* Cierra todos los cursores abiertos en la sesion actual
	Protected Procedure ClassBeforeCloseCursors(  ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:49:54)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteCloseCursors As Boolean

		Try

			llExecuteCloseCursors = .T.

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

		Return llExecuteCloseCursors

	Endproc
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Cierra todos los cursores abiertos en la sesion actual
	Procedure HookBeforeCloseCursors(  ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:49:54)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteCloseCursors As Boolean

		Try

			llExecuteCloseCursors = .T.

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

		Return llExecuteCloseCursors

	Endproc
	*
	* Cierra todos los cursores abiertos en la sesion actual
	Protected Procedure CloseCursors(  ) As Void;
			HELPSTRING "Cierra todos los cursores abiertos en la sesion actual"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Cierra todos los cursores abiertos en la sesion actual
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:49:54)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lnTotal As Integer	,;
			lnCount As Integer		,;
			lcTable As String

		Local Array laTables[1]

		Try

			If This.ClassBeforeCloseCursors(  ) And This.lIsOk

				If This.HookBeforeCloseCursors(  ) And This.lIsOk

					lnTotal = Aused( laTables )
					For lnCount = 1 To lnTotal
						lcTable = laTables[ lnCount, 1 ]
						If Used( lcTable )
							Use In ( lcTable )
						Endif
					Next

					If This.lIsOk
						This.HookAfterCloseCursors(  )
					Endif

				Endif

				If This.lIsOk
					This.ClassAfterCloseCursors(  )
				Endif

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

	Endproc
	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Cierra todos los cursores abiertos en la sesion actual
	Procedure HookAfterCloseCursors(  ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:49:54)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	Endproc
	*
	* ClassAfter Event
	* Cierra todos los cursores abiertos en la sesion actual
	Protected Procedure ClassAfterCloseCursors(  ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 8 de Mayo de 2009 (12:49:54)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	Endproc




	*
	* ClassBefore Event
	* Recibe un XML y lo convierte en cursores
	Protected Procedure ClassBeforeGetData( tcData As String ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (09:32:13)
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
			tcData AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteGetData As Boolean

		Try

			llExecuteGetData = .T.

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

		Return llExecuteGetData

	Endproc
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Recibe un XML y lo convierte en cursores
	Procedure HookBeforeGetData( tcData As String ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (09:32:13)
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
			tcData AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteGetData As Boolean

		Try

			llExecuteGetData = .T.

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

		Return llExecuteGetData

	Endproc
	*
	* Recibe un XML y lo convierte en cursores
	Procedure GetData( tcData As String ) As String;
			HELPSTRING "Recibe un XML y lo convierte en cursores"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Recibe un XML y lo convierte en cursores
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (09:32:13)
			*:ModiSummary:
			Se agrego la verificación de la propiedad lNeedBuffering
			*:Syntax:
			*:Example:
			*:Events:

			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			tcData AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif


		Local lcIdentifier As String
		Local lcReturn As String
		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"
		Local loTable As Object
		Local lnOffSet As Integer
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			lcReturn = ""
			lnOffSet = 0

			If Empty( tcData )
				tcData = ""
			Endif


			If This.lIsOk And This.ClassBeforeGetData( tcData )
				If This.lIsOk And This.HookBeforeGetData( tcData )
					* DAE 2009-09-11(12:45:06)
					loError = This.oError
					loError.TraceLogin = ""
					loError.Remark = ""

					lcReturn = ""
					lcIdentifier = ParseXML( tcData, 1 )

					Do Case
						Case lcIdentifier = ERROR_TAG
							This.lIsOk = .F.
							lcReturn = tcData
							loError.Process( lcReturn )

						Case lcIdentifier = WARNING_TAG
							This.lIsOk = .F.
							lcReturn = tcData
							loError.Process( lcReturn )

						Case ! This.lSerialize
							* Si no se serializan los cursores,
							* no es necesario hacer nada

							This.LookOverColTables( This.oColTables, "InternalGetData" )

							*!* This.LookOverColTables( This.oColTables,;
							*!*			"InternalGetData",;
							*!*			This.nNivelJerarquiaTablas )

						Otherwise

							* Creates an XmlAdapter

							loXA = Newobject( "prxXMLAdapter", "prxXMLAdapter.prg" )

							* Loads the XML
							loXA.LoadXML( tcData, .F. )
							For Each loTable In loXA.Tables
								* Extract each of the tables' cursor
								Use In Select( loTable.Alias )
								loTable.ToCursor( .F. )

								If This.lMakeTransactable
									*OJO: Esto es nuevo.
									* verificar codigo
									* ver en New()
									MakeTransactable( loTable.Alias )
								Endif

								If This.lNeedBuffering
									* Turns table buffering on
									CursorSetProp( "Buffering", 5, loTable.Alias )

								Endif
							Endfor

					Endcase

					If This.lIsOk
						This.HookAfterGetData( loXA )

					Endif

				Endif

				If This.lIsOk
					This.ClassAfterGetData( loXA )

				Endif

			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				loError = This.oError
				This.cXMLoError = loError.Process( oErr )
				lcReturn = This.cXMLoError

			Endif

		Finally
			loXA = Null
			loTable = Null
			loError = Null

			*!* If !This.lIsOk
			*!*		Throw This.oError
			*!* Endif

		Endtry

		Return lcReturn

	Endproc && GetData

	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Recibe un XML y lo convierte en cursores
	Procedure HookAfterGetData( toXA As Xmladapter ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (09:32:13)
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
			tcData AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	Endproc
	*
	* ClassAfter Event
	* Recibe un XML y lo convierte en cursores
	Protected Procedure ClassAfterGetData( toXA As Xmladapter ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (09:32:13)
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
			tcData AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	Endproc


	*
	* Setup de los cursores
	* Procedure InternalGetData( toTable As Object, tnLevel ) As Boolean HELPSTRING "Setup de los cursores"
	Procedure InternalGetData( toTable As oTable Of "Tools\Sincronizador\colDataBases.prg", ;
			tnLevel ) As Boolean ;
			HelpString "Setup de los cursores"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Setup de los cursores
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 22 de Mayo de 2009 (13:15:34)
			*:ModiSummary:
			Se agrego la verificación de la propiedad lNeedBuffering
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

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lcExp As String
		Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loColTables As colTables Of "Tools\Sincronizador\colDataBases.prg"
		Local loColField As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loPadrePk As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local loPadreTbl As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local lcAlias As String
		Try
			lcAlias = Alias()
			loError = This.oError

			* @TODO Damian Eiff 2009-08-20 (21:29:17)
			* Investigar los indices compuestos para manejar las relaciones
			* Set Exact Off
			* Set Ansi Off

			*!* If toTable.Nivel <= tnLevel

			If Used( toTable.CursorName )

				Select ( toTable.CursorName )

				If This.lMakeTransactable
					*OJO: Esto es nuevo.
					* verificar codigo
					* ver en New()
					MakeTransactable( toTable.CursorName )
				Endif

				* @TODO Damian Eiff 2009-08-20 (21:31:06)
				* Ver si las condiciones son correctas
				If Lower( This.cTierLevel ) = 'user' ;
						And  Empty( Txnlevel() ) ;
						And CursorGetProp( "Buffering", toTable.CursorName ) # 5

					If This.lDebugMode
						Strtofile( toTable.CursorName + " Bf:" + Transform( CursorGetProp( "Buffering", toTable.CursorName ) ) + CR, 'DumpCmd.log', 1 )

					Endif

					* DAE 2009-08-24(14:24:17)
					If .F. && Evito indexar por mas campos que la clave forenea
						lcExp = ' lIndexOnClient = .T. '

						loColField = toTable.oColFields.Where( lcExp )
						Assert Vartype( loColField ) = 'O' Message 'Se esperaba un objeto'

					Endif

					If ! Empty( toTable.Padre )

						If toTable.lSetRelations
							* DAE 2009-09-11(14:16:53)
							* Encapsule la creacion de los indices, se llama desde InternalSetRelation

							*!*	loColTables = NewColTables()
							*!*	loPadreTbl = loColTables.GetItem( toTable.Padre )
							*!*	loPadrePk = loPadreTbl.GetPrimaryKey()
							*!*	*!* lcPadrePk = ' Padl( ' + loPadrePk.Name + ', 10, "0" )'
							*!*	lcPadrePk = loPadrePk.Name

							*!*	*!* If Lower( loPadrePk.Name ) # Lower( toTable.MainID )
							*!*	*!*		lcPadrePk = 'Padl( ' + toTable.MainID + ', 10, "0" ) + ' + lcPadrePk

							*!*	*!* Endif && Lower( loPadrePk.Name ) # Lower( toTable.MainID )

							*!*	lcPadreCsr = 'c' + loPadreTbl.Name

							*!*	Select Alias( toTable.CursorName )
							*!*	TEXT To lcCommand NoShow TextMerge Pretext 15
							*!*	Index On <<lcPadrePk>> Tag <<loPadrePk.CurrentTagName>> Compact

							*!*	ENDTEXT

							*!*	loError.TraceLogin = toTable.CursorName + ' Ejecutando el comando ' + lcCommand
							*!*	If This.lDebugMode
							*!*		Strtofile( Tab + lcCommand + CR, 'DumpCmd.log', 1 )

							*!*	Endif
							*!*	&lcCommand

							*!*	* Locate

							This.InternalSetRelation( toTable, .T. )

						Endif


					Else
						loPadrePk = toTable.GetPrimaryKey()
						lcPadrePk = ' Padl( ' + loPadrePk.Name + ', 10, "0" ) '

					Endif && ! Empty( loTable.Padre )

					* @TODO Damian Eiff 2009-08-20 (22:03:08) Resolver
					If .F. && Evito indexar por mas campos que la clave forenea

						For i = 1 To loColField.Count
							loField = loColField.Item( i )
							lcFieldType = Lower( loField.FieldType )
							Do Case
								Case Inlist( lcFieldType, "currency", "integer", "numeric", "float", "double" )
									lcIndexExp = 'Padl( ' + loField.Name + ', 10, "0" ) ) '

								Case Inlist( lcFieldType, "character", "varchar")
									lcIndexExp = 'Alltrim( ' + loField.Name + ' ) '

								Case Inlist( lcFieldType, "datetime" )
									lcIndexExp = 'Padl( ' + loField.Name + ', 10, "0" ) '

								Case Inlist( lcFieldType, "date" )
									lcIndexExp = 'Padl( ' + loField.Name + ', 10, "0" ) '

								Otherwise
									Error 'Tipo de dato no soportado (' + lcFieldType + ') para indexar'

							Endcase

							If ! Empty( lcPadrePk )
								lcIndexExp = lcPadrePk + ' + ' + lcIndexExp

							Endif && ! Empty( lcPadrePk )

							Select Alias( toTable.CursorName )
							TEXT To lcCommand NoShow TextMerge Pretext 15
							Index On <<lcIndexExp>> Tag <<loField.CurrentTagName>> Compact

							ENDTEXT

							loError.TraceLogin = toTable.CursorName + ' Ejecutando el comando ' + lcCommand
							If This.lDebugMode
								Strtofile( Tab + lcCommand + CR, 'DumpCmd.log', 1 )

							Endif

							&lcCommand

							* Locate

						Endfor

					Endif && .f.

				Endif && Lower( this.cTierLevel ) = 'user'

				If This.lNeedBuffering And Empty( Txnlevel() )
					* DA 2009-07-14 &&;
					&& And CursorGetProp( "Buffering", toTable.CursorName ) # 5 ;
					&& And Txnlevel() = 0

					* Turns table buffering on
					CursorSetProp( "Buffering", 5, toTable.CursorName )

				Endif && This.lNeedBuffering And Empty( Txnlevel() )

			Endif

			*!* Endif

		Catch To oErr
			This.lIsOk = .F.
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = Null
			toTable = Null
			This.oError.Remark = ''
			This.oError.TraceLogin = ' '

			loColTables = Null
			loTable = Null
			loColField = Null
			loPadreTbl = Null
			loPadrePk = Null
			loField = Null

			If Used( lcAlias )
				Select Alias( lcAlias )

			Endif && Used( lcAlias )

		Endtry

		Return This.lIsOk

	Endproc && InternalGetData

	Procedure SetRelation( tlActivate As Boolean ) As Void
		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Ejecuta el comando set relation sobre todos los cursores
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Lunes 24 de Agosto de 2009
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
			tlActivate
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			If Lower( This.cTierLevel ) = 'user'
				This.LookOverColTables( This.oColTables, "InternalSetRelation", tlActivate )

			Endif

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.Remark = ''
			loError.TraceLogin = ''
			loError = Null

		Endtry

	Endproc && SetRelation

	Procedure InternalSetRelation( toTable As oTable Of "Tools\Sincronizador\colDataBases.prg", ;
			tlActivate As Boolean ) As Boolean;
			HELPSTRING "Ejecuta el comando set relation"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Ejecuta el comando set relation
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Lunes 24 de Agosto de 2009 (14:08:04)
			*:ModiSummary:
			2009-09-11 DAE
			Me aseguro que el indice exista con el metodo InternalIndexCursor()
			Si estoy sacando la relación desactivo el indice del cursor
			2009-09-14 DAE
			Valido que exista el index antes de selecionarlo
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

		Local lcTag As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColTables As colTables Of "Tools\Sincronizador\colDataBases.prg"
		Local loPadreTbl As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loPadrePk As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local lcPadrePk As String
		Local lcPadreCsr As String
		Local i As Integer
		Local lcTarget As String
		Local llOk As Boolean

		Try

			loError = This.oError

			If ! Empty( toTable.Padre )
				loColTables = NewColTables()
				loPadreTbl = loColTables.GetItem( toTable.Padre )
				loPadrePk = loPadreTbl.GetPrimaryKey()
				lcPadrePk = loPadrePk.Name
				lcPadreCsr = 'c' + loPadreTbl.Name

				If Used( toTable.CursorName ) And Used( lcPadreCsr )
					* DAE 2009-09-14(17:20:37)
					* Si necesito activar el indice me aseguro que exista
					This.InternalIndexCursor( toTable )

					If tlActivate And ! Empty( Tagcount( "", toTable.CursorName ) )
						* DAE 2009-10-05(14:43:22)
						* Valido que la relacion no este establecida
						llOk = .T.
						i = 1
						lcTarget = 'ZZZZZZZZ'
						Do While ! Empty( lcTarget ) And llOk
							lcTarget = Lower( Target( i, lcPadreCsr ) )
							llOk = ( lcTarget # Lower( toTable.CursorName ) )
							i = i + 1

						Enddo

						lcTag = loPadrePk.CurrentTagName

						* DAE 2009-10-05(14:43:35)
						If llOk
							TEXT To lcRelationCmd NoShow TextMerge Pretext 15
								Set Relation To <<lcPadrePk>>
								Into <<toTable.CursorName>> In <<lcPadreCsr>>
								Additive

							ENDTEXT
						Else
							TEXT To lcRelationCmd NoShow TextMerge Pretext 15
								= .T.
							ENDTEXT

						Endif && llOk

						TEXT To lcCommand NoShow TextMerge Pretext 15
							Set Order To '<<lcTag>>' In Alias( '<<toTable.CursorName>>' )

						ENDTEXT

					Else
						lcTag = ''
						TEXT To lcRelationCmd NoShow TextMerge Pretext 15
							Set Relation Off Into <<toTable.CursorName>>

						ENDTEXT

						TEXT To lcCommand NoShow TextMerge Pretext 15
							Set Order To '' In Alias( '<<toTable.CursorName>>' )

						ENDTEXT

					Endif && tlActivate

					loError.TraceLogin = 'Ejecutando el comando ' + lcCommand

					&lcCommand

					Select Alias( lcPadreCsr )

					loError.TraceLogin = 'Ejecutando el comando ' + lcRelationCmd
					&lcRelationCmd

				Endif

			Endif

		Catch To oErr
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.Remark = ''
			loError.TraceLogin = ''
			loError = Null

			loColTables = Null
			loPadreTbl = Null
			loPadrePk = Null

		Endtry

		Return This.lIsOk

	Endproc && InternalSetRelation


	*
	* InternalIndexCursor
	Protected Procedure InternalIndexCursor( toTable As oTable Of "Tools\Sincronizador\colDataBases.prg" ) As Boolean
		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Busca el indice en el cursor o lo crea si este no existe
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Viernes 11 de Septiembre de 2009
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

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local loColTables As colTables Of "Tools\Sincronizador\colDataBases.prg"
		Local loPadreTbl As oTable Of "Tools\Sincronizador\colDataBases.prg"
		Local loPadrePk  As oField Of "Tools\Sincronizador\colDataBases.prg"
		Local lCurrentTagName As String
		Local llRet As Boolean
		Local llOk As Boolean
		Local Array laTagInfo[ 1 ]
		Try
			loError = This.oError

			llRet = .T.
			If Empty( Txnlevel() ) And CursorGetProp( "Buffering", toTable.CursorName ) # 5
				loColTables = NewColTables()
				loPadreTbl = loColTables.GetItem( toTable.Padre )
				loPadrePk = loPadreTbl.GetPrimaryKey()
				lCurrentTagName = Alltrim( loPadrePk.CurrentTagName )
				* Busco el indice

				If Tagcount( "", toTable.CursorName ) > 0
					Ataginfo( laTagInfo, "", toTable.CursorName )
					llOk = ( Ascan( laTagInfo, lCurrentTagName, 1, 1, 1, 1 ) # 0 )

				Endif && TAGCOUNT( toTable.CursorName ) > 0

				If ! llOk
					lcPadrePk = loPadrePk.Name
					lcPadreCsr = 'c' + loPadreTbl.Name

					Select Alias( toTable.CursorName )
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Index On <<lcPadrePk>> Tag <<lCurrentTagName>> Compact

					ENDTEXT

					loError.TraceLogin = toTable.CursorName + ' Ejecutando el comando ' + lcCommand
					If This.lDebugMode
						Strtofile( Tab + lcCommand + CR, 'DumpCmd.log', 1 )

					Endif
					&lcCommand


				Endif && ! llOk

			Endif && Txnlevel() = 0 And CursorGetProp("Buffering", toTable.CursorName ) = 0

		Catch To oErr
			llRet = .F.
			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			loError.Remark = ''
			loError.TraceLogin = ''
			loError = Null

			loColTables = Null
			loPadreTbl = Null
			loPadrePk  = Null

		Endtry

		Return llRet

	Endproc && InternalIndexCursor

	*!*		*  VERSION DEL 21/08/2009 por DA
	*!*		* Setup de los cursores
	*!*		* Procedure InternalGetData( toTable As Object, tnLevel ) As Boolean HELPSTRING "Setup de los cursores"
	*!*		Procedure InternalGetData( toTable As oTable Of "Tools\Sincronizador\colDataBases.prg", ;
	*!*				tnLevel ) As Boolean ;
	*!*				HelpString "Setup de los cursores"

	*!*			#If .F.
	*!*				TEXT
	*!*				*:Help Documentation
	*!*				*:Topic:
	*!*				*:Description:
	*!*				Setup de los cursores
	*!*				*:Project:
	*!*				Sistemas Praxis
	*!*				*:Autor:
	*!*				Ricardo Aidelman
	*!*				*:Date:
	*!*				Viernes 22 de Mayo de 2009 (13:15:34)
	*!*				*:ModiSummary:
	*!*				Se agrego la verificación de la propiedad lNeedBuffering
	*!*				*:Syntax:
	*!*				*:Example:
	*!*				*:Events:
	*!*				*:NameSpace:
	*!*				praxis.com
	*!*				*:Keywords:
	*!*				*:Implements:
	*!*				*:Inherits:
	*!*				*:Parameters:
	*!*				*:Remarks:
	*!*				*:Returns:
	*!*				Boolean
	*!*				*:Exceptions:
	*!*				*:SeeAlso:
	*!*				*:EndHelp
	*!*				ENDTEXT
	*!*			#Endif

	*!*			Local loError As prxErrorHandler Of "FW\ErrorHandler\prxErrorHandler.prg"
	*!*			Local lcExp As String
	*!*			Local loTable As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*			Local loColTables As colTables Of "Tools\Sincronizador\colDataBases.prg"
	*!*			Local loColField As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
	*!*			Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"
	*!*			Local loPadrePk As oField Of "Tools\Sincronizador\colDataBases.prg"
	*!*			Local loPadreTbl As oTable Of "Tools\Sincronizador\colDataBases.prg"
	*!*			Local lcAlias As String
	*!*			Try
	*!*				lcAlias = Alias()
	*!*				loError = This.oError

	*!*				* @TODO Damian Eiff 2009-08-20 (21:29:17)
	*!*				* Investigar los indices compuestos para manejar las relaciones
	*!*				* Set Exact Off
	*!*				* Set Ansi Off

	*!*				*!* If toTable.Nivel <= tnLevel

	*!*				If Used( toTable.CursorName )

	*!*					Select ( toTable.CursorName )

	*!*					If This.lMakeTransactable
	*!*						*OJO: Esto es nuevo.
	*!*						* verificar codigo
	*!*						* ver en New()
	*!*						MakeTransactable( toTable.CursorName )
	*!*					Endif

	*!*					* @TODO Damian Eiff 2009-08-20 (21:31:06) Ver si las condiciones son correctas
	*!*					If Lower( This.cTierLevel ) = 'user' ;
	*!*							And  Empty( Txnlevel() ) ;
	*!*							And CursorGetProp( "Buffering", toTable.CursorName ) # 5

	*!*						If This.lDebugMode
	*!*							Strtofile( toTable.CursorName + " Bf:" + Transform( CursorGetProp( "Buffering", toTable.CursorName ) ) + CR, 'DumpCmd.log', 1 )
	*!*
	*!*						Endif
	*!*						lcExp = ' lIndexOnClient = .T. '

	*!*						loColField = toTable.oColFields.Where( lcExp )
	*!*						Assert Vartype( loColField ) = 'O' Message 'Se esperaba un objeto'

	*!*						If ! Empty( toTable.Padre )
	*!*
	*!*							loColTables = NewColTables()
	*!*							loPadreTbl = loColTables.GetItem( toTable.Padre )
	*!*							loPadrePk = loPadreTbl.GetPrimaryKey()
	*!*							lcPadrePk = ' Padl( ' + loPadrePk.Name + ', 10, "0" )'

	*!*							If Lower( loPadrePk.Name ) # Lower( toTable.MainID )
	*!*								lcPadrePk = 'Padl( ' + toTable.MainID + ', 10, "0" ) + ' + lcPadrePk

	*!*							Endif && Lower( loPadrePk.Name ) # Lower( toTable.MainID )

	*!*							lcPadreCsr = 'c' + loPadreTbl.Name

	*!*							Select Alias( toTable.CursorName )
	*!*							TEXT To lcCommand NoShow TextMerge Pretext 15
	*!*								Index On <<lcPadrePk>> Tag <<loPadrePk.CurrentTagName>> Compact

	*!*							ENDTEXT

	*!*							loError.TraceLogin = toTable.CursorName + ' Ejecutando el comando ' + lcCommand
	*!*							If This.lDebugMode
	*!*								Strtofile( Tab + lcCommand + CR, 'DumpCmd.log', 1 )
	*!*							Endif
	*!*							&lcCommand

	*!*							* Locate

	*!*							Assert Used( lcPadreCsr ) Message 'No esta el cursor del padre'

	*!*							If Used( lcPadreCsr )
	*!*								TEXT To lcCommand NoShow TextMerge Pretext 15
	*!*									Set Relation To <<lcPadrePk>>
	*!*									Into <<toTable.CursorName>> In <<lcPadreCsr>>

	*!*								ENDTEXT

	*!*								loError.TraceLogin = toTable.CursorName + ' Ejecutando el comando ' + lcCommand
	*!*								If This.lDebugMode
	*!*									Strtofile( Tab + lcCommand + CR, 'DumpCm.d.log', 1 )
	*!*								Endif

	*!*								&lcCommand
	*!*
	*!*							Endif && lcPadreCsr

	*!*						Else
	*!*							loPadrePk = toTable.GetPrimaryKey()
	*!*							lcPadrePk = ' Padl( ' + loPadrePk.Name + ', 10, "0" ) '

	*!*						Endif && ! Empty( loTable.Padre )

	*!*						* @TODO Damian Eiff 2009-08-20 (22:03:08) Resolver
	*!*						If .F. && Evito indexar por mas campos que la clave forenea

	*!*							For i = 1 To loColField.Count
	*!*								loField = loColField.Item( i )
	*!*								lcFieldType = Lower( loField.FieldType )
	*!*								Do Case
	*!*									Case Inlist( lcFieldType, "currency", "integer", "numeric", "float", "double" )
	*!*										lcIndexExp = 'Padl( ' + loField.Name + ', 10, "0" ) ) '

	*!*									Case Inlist( lcFieldType, "character", "varchar")
	*!*										lcIndexExp = 'Alltrim( ' + loField.Name + ' ) '

	*!*									Case Inlist( lcFieldType, "datetime" )
	*!*										lcIndexExp = 'Padl( ' + loField.Name + ', 10, "0" ) '

	*!*									Case Inlist( lcFieldType, "date" )
	*!*										lcIndexExp = 'Padl( ' + loField.Name + ', 10, "0" ) '

	*!*									Otherwise
	*!*										Error 'Tipo de dato no soportado (' + lcFieldType + ') para indexar'

	*!*								Endcase

	*!*								If ! Empty( lcPadrePk )
	*!*									lcIndexExp = lcPadrePk + ' + ' + lcIndexExp

	*!*								Endif && ! Empty( lcPadrePk )

	*!*								Select Alias( toTable.CursorName )
	*!*								TEXT To lcCommand NoShow TextMerge Pretext 15
	*!*								Index On <<lcIndexExp>> Tag <<loField.CurrentTagName>> Compact

	*!*								ENDTEXT

	*!*								loError.TraceLogin = toTable.CursorName + ' Ejecutando el comando ' + lcCommand
	*!*								If This.lDebugMode
	*!*									Strtofile( Tab + lcCommand + CR, 'DumpCmd.log', 1 )
	*!*								Endif

	*!*								&lcCommand

	*!*								* Locate

	*!*							Endfor

	*!*						Endif && .f.

	*!*					Endif && Lower( this.cTierLevel ) = 'user'

	*!*					If This.lNeedBuffering And Empty( Txnlevel() )
	*!*						* DA 2009-07-14 &&;
	*!*						&& And CursorGetProp( "Buffering", toTable.CursorName ) # 5 ;
	*!*						&& And Txnlevel() = 0

	*!*						* Turns table buffering on
	*!*						CursorSetProp( "Buffering", 5, toTable.CursorName )

	*!*					Endif && This.lNeedBuffering And Empty( Txnlevel() )

	*!*				Endif

	*!*				*!* Endif

	*!*			Catch To oErr
	*!*				This.lIsOk = .F.
	*!*				loError = This.oError
	*!*				This.cXMLoError = loError.Process( oErr )
	*!*				Throw loError

	*!*			Finally
	*!*				loError = Null
	*!*				toTable = Null
	*!*				This.oError.Remark = ''
	*!*				This.oError.TraceLogin = ' '

	*!*				loColTables = Null
	*!*				loTable = Null
	*!*				loColField = Null
	*!*				loPadreTbl = Null
	*!*				loPadrePk = Null
	*!*				loField = Null

	*!*				If Used( lcAlias )
	*!*					Select Alias( lcAlias )

	*!*				Endif && Used( lcAlias )

	*!*			Endtry

	*!*			Return This.lIsOk

	*!*		Endproc && InternalGetData

	*
	* ClassBefore Event
	* Devuelve un registro según una PK hasta determinado nivel de jerarquía
	Protected Procedure ClassBeforeGetOne( tnEntidad As Integer,;
			tnLevel As Integer,;
			tcAlias As String, ;
			tnSQLOption As Integer ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:04:03)
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
			tnEntidad AS Integer
			tnLevel AS Integer
			tcAlias AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteGetOne As Boolean

		Try

			llExecuteGetOne = .T.

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

		Return llExecuteGetOne

	Endproc
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Devuelve un registro según una PK hasta determinado nivel de jerarquía
	Procedure HookBeforeGetOne( tnEntidad As Integer,;
			tnLevel As Integer,;
			tcAlias As String, ;
			tnSQLOption As Integer ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:04:03)
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
			tnEntidad AS Integer
			tnLevel AS Integer
			tcAlias AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteGetOne As Boolean

		Try

			llExecuteGetOne = .T.

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return llExecuteGetOne

	Endproc
	*
	* Devuelve un registro según una PK hasta determinado nivel de jerarquía
	Procedure GetOne( tnEntidad As Integer,;
			tnLevel As Integer,;
			tcAlias As String, ;
			tnSQLOption As Integer ) As String;
			HELPSTRING "Devuelve un registro según una PK hasta determinado nivel de jerarquía"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve un registro según una PK hasta determinado nivel de jerarquía
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:04:03)
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
			tnEntidad AS Integer
			tnLevel AS Integer
			tcAlias AS String
			tnSQLOption AS Integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcXML As String

		Try

			lcXML = ""

			If This.lIsOk And This.ClassBeforeGetOne( tnEntidad, tnLevel, tcAlias, tnSQLOption )
				If This.lIsOk And This.HookBeforeGetOne( tnEntidad, tnLevel, tcAlias, tnSQLOption )

					lcXML = This.oNextTier.GetOne( tnEntidad, tnLevel, tcAlias, tnSQLOption )

					This.HookAfterGetOne( tnEntidad, tnLevel, tcAlias, tnSQLOption )
					This.ClassAfterGetOne( tnEntidad, tnLevel, tcAlias, tnSQLOption )

				Endif && This.lIsOk And This.HookBeforeGetOne( tnEntidad, tnLevel, tcAlias, tnSQLOption )

			Endif && This.lIsOk And This.ClassBeforeGetOne( tnEntidad, tnLevel, tcAlias, tnSQLOption )

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally

		Endtry

		Return lcXML

	Endproc && GetOne

	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Devuelve un registro según una PK hasta determinado nivel de jerarquía
	Procedure HookAfterGetOne( tnEntidad As Integer,;
			tnLevel As Integer,;
			tcAlias As String, ;
			tnSQLOption As Integer ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:04:03)
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
			tnEntidad AS Integer
			tnLevel AS Integer
			tcAlias AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	Endproc
	*
	* ClassAfter Event
	* Devuelve un registro según una PK hasta determinado nivel de jerarquía
	Protected Procedure ClassAfterGetOne( tnEntidad As Integer,;
			tnLevel As Integer,;
			tcAlias As String, ;
			tnSQLOption As Integer ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:04:03)
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
			tnEntidad AS Integer
			tnLevel AS Integer
			tcAlias AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			This.RetrieveNextTierData()

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

	Endproc

	* ///////////////////////////////////////////////////////
	* Procedure.....: GetFirst
	* Description...: Obtiene el primer registro
	* Date..........: Miércoles 3 de Enero de 2007 (17:58:00)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure GetFirst( tcFieldName As String,;
			tcFilterCriteria As String,;
			tnLevel As Integer ) As String;
			HELPSTRING "Obtiene el primer registro"

		* Especializado en cada subclase.
		This.RetrieveNextTierData()
		Return ""

	Endproc && GetFirst

	* ///////////////////////////////////////////////////////
	* Procedure.....: GetLast
	* Description...: Obtiene el último registro
	* Date..........: Miércoles 3 de Enero de 2007 (17:58:00)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure GetLast( tcFieldName As String,;
			tcFilterCriteria As String,;
			tnLevel As Integer ) As String;
			HELPSTRING "Obtiene el último registro"

		* Especializado en cada subclase.
		This.RetrieveNextTierData()
		Return ""

	Endproc && GetLast

	* ///////////////////////////////////////////////////////
	* Procedure.....: GetNext
	* Description...: Obtiene el siguiente registro
	* Date..........: Miércoles 3 de Enero de 2007 (17:58:00)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure Getnext( tcFieldName As String,;
			tuCurrentValue As Variant,;
			tcFilterCriteria As String,;
			tnLevel As Integer ) As String;
			HELPSTRING "Obtiene el siguiente registro"

		* Especializado en cada subclase.
		This.RetrieveNextTierData()
		Return ""

	Endproc && GetNext

	* ///////////////////////////////////////////////////////
	* Procedure.....: GetPrior
	* Description...: Obtiene el registro anterior
	* Date..........: Miércoles 3 de Enero de 2007 (17:58:00)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure GetPrior( tcFieldName As String,;
			tuCurrentValue As Variant,;
			tcFilterCriteria As String,;
			tnLevel As Integer ) As String;
			HELPSTRING "Obtiene el siguiente registro"

		* Especializado en cada subclase.
		This.RetrieveNextTierData()
		Return ""

	Endproc && GetPrior

	*
	* ClassBefore Event
	* Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
	Protected Procedure ClassBeforeGetAll( tcFilterCriteria As String,;
			tcAlias As String,;
			tcOrderBy As String, ;
			tnSQLOption As Integer ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:13:45)
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
			tcFilterCriteria AS String
			tcAlias AS String
			tcOrderBy AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return .T.

	Endproc

	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
	Procedure HookBeforeGetAll( tcFilterCriteria As String,;
			tcAlias As String,;
			tcOrderBy As String, ;
			tnSQLOption As Integer ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:13:45)
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
			tcFilterCriteria AS String
			tcAlias AS String
			tcOrderBy AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif


		Return .T.

	Endproc && HookBeforeGetAll

	*
	* Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
	Procedure GetAll( tcFilterCriteria As String,;
			tcAlias As String,;
			tcOrderBy As String, ;
			tnSQLOption As Integer ) As String;
			HELPSTRING "Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro."


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:13:45)
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
			tcFilterCriteria AS String
			tcAlias AS String
			tcOrderBy AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcXML As String

		Try

			lcXML = ""

			If This.lIsOk And This.ClassBeforeGetAll( tcFilterCriteria, tcAlias, tcOrderBy, tnSQLOption )

				If This.lIsOk And This.HookBeforeGetAll( tcFilterCriteria, tcAlias, tcOrderBy, tnSQLOption )

					lcXML = This.oNextTier.GetAll( tcFilterCriteria, tcAlias, tcOrderBy, tnSQLOption )

					This.HookAfterGetAll( tcFilterCriteria, tcAlias, tcOrderBy, tnSQLOption )

					This.ClassAfterGetAll( tcFilterCriteria, tcAlias, tcOrderBy, tnSQLOption )

				Endif && This.lIsOk And This.HookBeforeGetAll( tcFilterCriteria, tcAlias, tcOrderBy, tnSQLOption )

			Endif && This.lIsOk And This.ClassBeforeGetAll( tcFilterCriteria, tcAlias, tcOrderBy, tnSQLOption )

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally

		Endtry

		Return lcXML

	Endproc && GetAll

	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
	Procedure HookAfterGetAll( tcFilterCriteria As String,;
			tcAlias As String,;
			tcOrderBy As String, ;
			tnSQLOption As Integer ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:13:45)
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
			tcFilterCriteria AS String
			tcAlias AS String
			tcOrderBy AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

	Endproc && HookAfterGetAll

	*
	* ClassAfter Event
	* Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
	Protected Procedure ClassAfterGetAll( tcFilterCriteria As String,;
			tcAlias As String,;
			tcOrderBy As String,;
			tnSQLOption As Integer ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:13:45)
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
			tcFilterCriteria AS String
			tcAlias AS String
			tcOrderBy AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			This.RetrieveNextTierData()

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

	Endproc && ClassAfterGetAll

	*
	* Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
	Procedure GetAllCombo( tcFilterCriteria As String,;
			tcAlias As String,;
			tcOrderBy As String ) As String;
			HELPSTRING "Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro."

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Jueves 29 de Octubre de 2009
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
			tcFilterCriteria AS String
			tcAlias AS String
			tcOrderBy AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcXML As String

		Try

			lcXML = ""

			If This.lIsOk And This.ClassBeforeGetAllCombo( tcFilterCriteria, tcAlias, tcOrderBy )

				If This.lIsOk And This.HookBeforeGetAllCombo( tcFilterCriteria, tcAlias, tcOrderBy )

					lcXML = This.oNextTier.GetAllCombo( tcFilterCriteria, tcAlias )

					This.HookAfterGetAllCombo( tcFilterCriteria, tcAlias, tcOrderBy )

					This.ClassAfterGetAllCombo( tcFilterCriteria, tcAlias, tcOrderBy )

				Endif && This.lIsOk And This.HookBeforeGetAllCombo( tcFilterCriteria, tcAlias, tcOrderBy )

			Endif && This.lIsOk And This.ClassBeforeGetAllCombo( tcFilterCriteria, tcAlias, tcOrderBy )

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif

		Finally

		Endtry

		Return lcXML

	Endproc && GetAllCombo

	*
	* ClassBefore Event
	* Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
	Protected Procedure ClassBeforeGetAllCombo( tcFilterCriteria As String,;
			tcAlias As String,;
			tcOrderBy As String ) As Boolean

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Jueves 29 de Octubre de 2009
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
			tcFilterCriteria AS String
			tcAlias AS String
			tcOrderBy AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return .T.

	Endproc && ClassBeforeGetAllCombo

	*
	* ClassAfter Event
	* Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
	Protected Procedure ClassAfterGetAllCombo( tcFilterCriteria As String,;
			tcAlias As String,;
			tcOrderBy As String ) As Void

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Jueves 29 de Octubre de 2009
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
			tcFilterCriteria AS String
			tcAlias AS String
			tcOrderBy AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			This.RetrieveNextTierData()

		Catch To oErr
			This.cXMLoError = This.oError.Process( oErr )
			Throw This.oError

		Finally

		Endtry

	Endproc && ClassAfterGetAllCombo

	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
	Procedure HookBeforeGetAllCombo( tcFilterCriteria As String,;
			tcAlias As String,;
			tcOrderBy As String ) As Boolean

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Jueves 29 de Octubre de 2009
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
			tcFilterCriteria AS String
			tcAlias AS String
			tcOrderBy AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return .T.

	Endproc && HookBeforeGetAllCombo

	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Devuelve todos los registros del nivel 1 que cumplan con el criterio de filtro recibido como parámetro.
	Procedure HookAfterGetAllCombo( tcFilterCriteria As String,;
			tcAlias As String,;
			tcOrderBy As String ) As Void

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Jueves 29 de Octubre de 2009
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
			tcFilterCriteria AS String
			tcAlias AS String
			tcOrderBy AS String
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

	Endproc && HookAfterGetAllCombo

	*
	* ClassBefore Event
	Protected Procedure ClassBeforeGetByWhere( tcFilterCriteria As String,;
			tnLevel As Integer,;
			tcAlias As String, ;
			tnSQLOption As Integer ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:21:32)
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
			tcFilterCriteria AS String
			tnLevel AS Integer
			tcAlias AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return .T.

	Endproc && ClassBeforeGetByWhere

	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	*
	Procedure HookBeforeGetByWhere( tcFilterCriteria As String,;
			tnLevel As Integer,;
			tcAlias As String, ;
			tnSQLOption As Integer ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:21:32)
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
			tcFilterCriteria AS String
			tnLevel AS Integer
			tcAlias AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return .T.

	Endproc && HookBeforeGetByWhere

	*
	* Devuelve el registro, hasta determinado nivel de jerarquía,
	* que cumple con el criterio de filtro recibido como parámetro.
	* Si existe más de un registro, devuelve un tag especial que contiene
	* la cantidad de registros que cumplen con el criterio
	Procedure GetByWhere( tcFilterCriteria As String,;
			tnLevel As Integer,;
			tcAlias As String, ;
			tnSQLOption As Integer ) As String


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve el registro, hasta determinado nivel de jerarquía,
			que cumple con el criterio de filtro recibido como parámetro.
			Si existe más de un registro, devuelve un tag especial que contiene
			la cantidad de registros que cumplen con el criterio
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:21:32)
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
			tcFilterCriteria AS String
			tnLevel AS Integer
			tcAlias AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcXML As String

		Try

			lcXML = ""

			If This.lIsOk And This.ClassBeforeGetByWhere( tcFilterCriteria, tnLevel, tcAlias, tnSQLOption )

				If This.lIsOk And This.HookBeforeGetByWhere( tcFilterCriteria, tnLevel, tcAlias, tnSQLOption )

					lcXML = This.oNextTier.GetByWhere( tcFilterCriteria, tnLevel, tcAlias, tnSQLOption )

					This.HookAfterGetByWhere( tcFilterCriteria, tnLevel, tcAlias, tnSQLOption )

					This.ClassAfterGetByWhere( tcFilterCriteria, tnLevel, tcAlias, tnSQLOption )

				Endif && This.lIsOk And This.HookBeforeGetByWhere( tcFilterCriteria, tnLevel, tcAlias, tnSQLOption )

			Endif && This.lIsOk And This.ClassBeforeGetByWhere( tcFilterCriteria, tnLevel, tcAlias, tnSQLOption )

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif && This.lIsOk

		Finally

		Endtry

		Return lcXML

	Endproc && GetByWhere

	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	*
	Procedure HookAfterGetByWhere( tcFilterCriteria As String,;
			tnLevel As Integer,;
			tcAlias As String, ;
			tnSQLOption As Integer ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:21:32)
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
			tcFilterCriteria AS String
			tnLevel AS Integer
			tcAlias AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

	Endproc && HookAfterGetByWhere

	*
	* ClassAfter Event
	*
	Protected Procedure ClassAfterGetByWhere( tcFilterCriteria As String,;
			tnLevel As Integer,;
			tcAlias As String, ;
			tnSQLOption As Integer ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:21:32)
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
			tcFilterCriteria AS String
			tnLevel AS Integer
			tcAlias AS String
			tnSQLOption As integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try
			This.RetrieveNextTierData()

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

	Endproc && ClassAfterGetByWhere

	*
	* ClassBefore Event
	* Crea un nuevo elemento para la entidad.
	* Basicamente, llama el metodo PUT sin un ID. Incluido para hacer "amigable" al codigo.
	Protected Procedure ClassBeforeNew( tnLevel As Integer,;
			tcAlias As String ) As Boolean

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:33:08)
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
			tnLevel AS Integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return  .T.

	Endproc && ClassBeforeNew

	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Crea un nuevo elemento para la entidad.
	* Basicamente, llama el metodo PUT sin un ID. Incluido para hacer "amigable" al codigo.
	Procedure HookBeforeNew( tnLevel As Integer,;
			tcAlias As String ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:33:08)
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
			tnLevel AS Integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return .T.

	Endproc && HookBeforeNew

	*
	* Crea un nuevo elemento para la entidad.
	* Basicamente, llama el metodo PUT sin un ID.
	* Incluido para hacer "amigable" al codigo.
	Procedure New( tnLevel As Integer,;
			tcAlias As String ) As String;
			HELPSTRING "Crea un nuevo elemento para la entidad. Basicamente, llama el metodo PUT sin un ID. Incluido para hacer 'amigable' al codigo."


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Crea un nuevo elemento para la entidad.
			Basicamente, llama el metodo PUT sin un ID.
			Incluido para hacer "amigable" al codigo.
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:33:08)
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
			tnLevel AS Integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcXML As String

		Try

			lcXML = ""

			If This.lIsOk And This.ClassBeforeNew( tnLevel, tcAlias )

				If This.lIsOk And This.HookBeforeNew(tnLevel, tcAlias )

					lcXML = This.oNextTier.New(tnLevel, tcAlias )

					This.HookAfterNew(tnLevel, tcAlias )
					This.ClassAfterNew(tnLevel, tcAlias )

				Endif && This.lIsOk And This.HookBeforeNew(tnLevel, tcAlias )

			Endif && This.lIsOk And This.ClassBeforeNew( tnLevel, tcAlias )

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )

			Endif

		Finally

		Endtry

		Return lcXML

	Endproc && New

	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Crea un nuevo elemento para la entidad. Basicamente, llama el metodo PUT sin un ID.
	* Incluido para hacer "amigable" al codigo.
	Procedure HookAfterNew( tnLevel As Integer, tcAlias As String ) As Void

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:33:08)
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
			tnLevel AS Integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

	Endproc && HookAfterNew

	*
	* ClassAfter Event
	* Crea un nuevo elemento para la entidad. Basicamente, llama el metodo PUT sin un ID.
	* Incluido para hacer "amigable" al codigo.
	Protected Procedure ClassAfterNew( tnLevel As Integer,;
			tcAlias As String ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (10:33:08)
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
			tnLevel AS Integer
			*:Remarks:
			*:Returns:
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			This.RetrieveNextTierData()

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )
			Endif

		Finally
			If ! This.lIsOk
				Throw This.oError
			Endif

		Endtry

	Endproc

	*
	* Devuelve la colección oColTables serializada como XML
	Protected Procedure GetTables() As String;
			HELPSTRING "Devuelve la colección oColTables serializada como XML"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve la colección oColTables serializada como XML
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (15:38:59)
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
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcRetVal As String
		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"
		Local loError As Object

		Try

			loError = This.oError
			loError.TraceLogin = ""
			loError.Remark = ""

			lcRetVal = ""

			If This.lSerialize
				loXA = Newobject( "prxXMLAdapter", "prxXMLAdapter.prg" )

				loXA.LoadObj( This.oColTables, "U" )
				loXA.ToXML( "lcRetVal" )
				This.lIsOk = loXA.lIsOk
				This.cXMLoError = loXA.cXMLoError

			Endif


		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif && This.lIsOk

		Finally
			loXA = Null

			If ! This.lIsOk
				lcRetVal = This.cXMLoError
				Throw This.oError

			Endif && ! This.lIsOk

		Endtry

		* Retorno la coleccion serializada
		Return (lcRetVal)

	Endproc  && GetTables()

	*
	* Devuelve la colección loColTables con datos recibidos como XML
	Protected Procedure CopyTables( tcXML As String ) As Collection;
			HELPSTRING "Devuelve la colección loColTables con datos recibidos como XML"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve la colección loColTables con datos recibidos como XML
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (16:44:36)
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
			tcXML AS String
			*:Remarks:
			*:Returns:
			Collection
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcOldArea As String
		Local lcAlias As String
		Local loColTables As colTables Of "FW\TierAdapter\Comun\coltables.prg"
		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"


		Try

			This.oError.TraceLogin = This.cTierLevel
			This.oError.Remark = ""

			loColTables = Null

			* Preserves workarea
			lcOldArea = Select()

			If This.lSerialize
				* Create and XmlAdapter to retrieve the cursor from the XML

				loXA = Newobject("prxXMLAdapter",;
					"prxXMLAdapter.prg")

				loXA.LoadXML( tcXML, .F. )

				loColTables = loXA.ToObject()
			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
				loColTables = Null
			Endif

		Finally
			loXA = Null
			If Not Empty(lcOldArea)
				Select (lcOldArea)
			Endif

			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return loColTables

	Endproc && CopyTables

	*
	* Serializes a series of cursors to XML
	Protected Procedure Serialize( tcCommaSeparatedCursorList As String ) As String;
			HELPSTRING "Serializes a series of cursors to XML"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Serializes a series of cursors to XML
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:12:35)
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
			tcCommaSeparatedCursorList AS String
			*:Remarks:
			*:Returns:
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"
		Local lcRetVal As String
		Local i As Integer

		Try

			lcRetVal = ""

			If This.lSerialize
				loXA = Newobject( "prxXMLAdapter", "prxXMLAdapter.prg" )

				For i = 1 To Getwordcount( tcCommaSeparatedCursorList, [,] )
					loXA.AddTableSchema( Alltrim( Getwordnum( tcCommaSeparatedCursorList, i, [,] ) ) )

				Endfor

				loXA.PreserveWhiteSpace = .T.
				loXA.ToXML( "lcRetVal" )
			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
				lcRetVal = This.cXMLoError
			Endif

		Finally
			loXA = Null
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return lcRetVal

	Endproc && Serialize

	*
	* ClassBefore Event
	* Setea propiedades en la siguiente capa
	Protected Procedure ClassBeforeNextTierSetup( toTier As Object ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:18:55)
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
			toTier AS Object
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteNextTierSetup As Boolean

		Try

			llExecuteNextTierSetup = .T.

			toTier.nTransactionID = This.nTransactionID

			If Empty( This.cMainEntity )
				toTier.cMainEntity = This.cDataConfigurationKey

			Else
				toTier.cMainEntity = This.cMainEntity

			Endif


		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If ! This.lIsOk
				Throw This.oError

			Endif && ! This.lIsOk

		Endtry

		Return llExecuteNextTierSetup

	Endproc && ClassBeforeNextTierSetup
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Setea propiedades en la siguiente capa
	Procedure HookBeforeNextTierSetup( toTier As Object ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:18:55)
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
			toTier AS Object
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return .T.

	Endproc && HookBeforeNextTierSetup
	*
	* Setea propiedades en la siguiente capa
	Protected Procedure NextTierSetup( toTier As Object ) As Void;
			HELPSTRING "Setea propiedades en la siguiente capa"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Setea propiedades en la siguiente capa
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:18:55)
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
			toTier AS Object
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			If This.lIsOk And This.ClassBeforeNextTierSetup( toTier )

				If This.lIsOk And This.HookBeforeNextTierSetup( toTier )
					*!*						* Setear el nombre del archivo con la metadata
					*!*						If Empty( oTier.cObjectFactoryFileName )
					*!*							oTier.cObjectFactoryFileName = This.cObjectFactoryFileName
					*!*						Endif

					* Usuario Actual
					toTier.oUser = This.oUser
					toTier.lIsChild = This.lIsChild
					toTier.cMainEntity = This.cMainEntity
					toTier.nTransactionID  = This.nTransactionID
					toTier.lIsMainEntity = This.lIsMainEntity

					If ! This.lSerialize
						toTier.DataSessionId = This.DataSessionId
						toTier.lAutoDestroy = .F.
					Endif

					If This.lIsOk
						This.HookAfterNextTierSetup( toTier )
					Endif

				Endif

				If This.lIsOk
					This.ClassAfterNextTierSetup( toTier )
				Endif

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

	Endproc && NextTierSetup
	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Setea propiedades en la siguiente capa
	Procedure HookAfterNextTierSetup( toTier As Object ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:18:55)
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
			toTier AS Object
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

	Endproc && HookAfterNextTierSetup
	*
	* ClassAfter Event
	* Setea propiedades en la siguiente capa
	Protected Procedure ClassAfterNextTierSetup( toTier As Object ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:18:55)
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
			oTier AS Object
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

	Endproc && ClassAfterNextTierSetup

	*
	* DeSerialize a XML to cursors
	Protected Procedure DeSerialize( tcData As String ) As Boolean;
			HELPSTRING "DeSerializes a series of cursors to XML"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			DeSerializes a XML to cursors
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Martes 6 de Octubre de 2009
			*:ModiSummary:
			*:Syntax:
			*:Example:
			This.DeSerialize( lcXML )
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			tcData AS String
			*:Remarks:
			Boolean
			*:Returns:
			String
			*:Exceptions:
			*:SeeAlso:
			DeSerialize
			*:EndHelp
			ENDTEXT
		#Endif

		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"

		Try
			* Creates an XmlAdapter
			loXA = Newobject( "prxXMLAdapter", "prxXMLAdapter.prg" )
			* Loads the XML
			loXA.LoadXML( tcData, .F. )
			For Each loTable In loXA.Tables
				* Extract each of the tables' cursor
				Use In Select( loTable.Alias )
				loTable.ToCursor( .F. )

				If This.lMakeTransactable
					MakeTransactable( loTable.Alias )

				Endif

				If This.lNeedBuffering
					* Turns table buffering on
					CursorSetProp( "Buffering", 5, loTable.Alias )

				Endif
			Endfor

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )

			Endif

		Finally
			loXA = Null
			If ! This.lIsOk
				Throw This.oError

			Endif

		Endtry

		Return This.lIsOk

	Endproc && DeSerialize

	*
	* Destroy
	Procedure Destroy() As Void

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:30:20)
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
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			If !This.lOnDestroy

				This.lOnDestroy = .T.

				If Vartype( This.oNextTier ) == "O"
					*!*						This.oNextTier.Destroy()
				Endif
				This.oNextTier 		= Null

				If Vartype( This.oServiceTier ) == "O"
					*!* This.oServiceTier.Destroy()
				Endif
				This.oServiceTier 	= Null

				If Vartype( This.oError ) == "O"
					*!* This.oError.Destroy()
				Endif
				This.oError 		= Null

				If Vartype( This.oParent ) == "O"
					*!* This.oParent.Destroy()
				Endif
				This.oParent 		= Null

				If Vartype( This.oUser ) == "O"
					*!* This.oUser.Destroy()
				Endif
				This.oUser = Null


				If Vartype( This.oColEntities ) == "O"
					This.oColEntities.Remove( -1 )
					This.oColEntities = Null
				Endif

				If Vartype( This.oColTables ) == "O"
					This.oColTables.Remove( -1 )
					This.oColTables = Null
				Endif

				If Vartype( This.oColChildren ) == "O"
					This.oColChildren.Remove( -1 )
					This.oColChildren = Null
				Endif

				DoDefault()
			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			*!* If !This.lIsOk
			*!*		Throw This.oError
			*!* Endif

		Endtry

	Endproc && Destroy


	*
	* ClassBefore Event
	* Ejecuta un comando contra la base de datos
	Protected Procedure ClassBeforeExecuteNonQuery( tcSQLCommand As String ) As Boolean

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:35:39)
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
			tcSQLCommand AS String
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteExecuteNonQuery As Boolean

		Try

			llExecuteExecuteNonQuery = .T.

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

		Return llExecuteExecuteNonQuery

	Endproc && ClassBeforeExecuteNonQuery
	*
	* HookBefore Event
	* Para ser utilizado por el desarrollador
	* Ejecuta un comando contra la base de datos
	Procedure HookBeforeExecuteNonQuery( tcSQLCommand As String ) As Boolean


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookBefore Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:35:39)
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
			tcSQLCommand AS String
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llExecuteExecuteNonQuery As Boolean

		Try

			llExecuteExecuteNonQuery = .T.

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

		Return llExecuteExecuteNonQuery

	Endproc && HookBeforeExecuteNonQuery
	*
	* Ejecuta un comando contra la base de datos
	Procedure ExecuteNonQuery( tcSQLCommand As String ) As String;
			HELPSTRING "Ejecuta un comando contra la base de datos"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Ejecuta un comando contra la base de datos
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:35:39)
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
			tcSQLCommand AS String
			*:Remarks:
			*:Returns:
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcXML As String

		Try

			lcXML = ""

			If This.ClassBeforeExecuteNonQuery( tcSQLCommand ) And This.lIsOk

				If This.HookBeforeExecuteNonQuery( tcSQLCommand ) And This.lIsOk

					lcXML = This.oNextTier.ExecuteNonQuery( tcSQLCommand )

					If This.lIsOk
						This.HookAfterExecuteNonQuery( lcXML )
					Endif

				Endif

				If This.lIsOk
					This.ClassAfterExecuteNonQuery( lcXML )
				Endif

			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally

		Endtry

		Return lcXML

	Endproc && ExecuteNonQuery
	*
	* HookAfter Event
	* Para ser utilizado por el desarrollador
	* Ejecuta un comando contra la base de datos
	Procedure HookAfterExecuteNonQuery( tcSQLCommand As String ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			HookAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:35:39)
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
			tcSQLCommand AS String
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	Endproc && HookAfterExecuteNonQuery
	*
	* ClassAfter Event
	* Ejecuta un comando contra la base de datos
	Protected Procedure ClassAfterExecuteNonQuery( tcSQLCommand As String ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			ClassAfter Event
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:35:39)
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
			tcSQLCommand AS String
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			This.RetrieveNextTierData()

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

	Endproc && ClassAfterExecuteNonQuery


	*
	* Obtiene información complementaria de la capa siguiente, antes de matarla
	Protected Procedure RetrieveNextTierData(  ) As Void;
			HELPSTRING "Obtiene información complementaria de la capa siguiente, antes de matarla"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Obtiene información complementaria de la capa siguiente, antes de matarla
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (17:42:59)
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
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try
			Local llOk As Boolean

			If This.lIsOk
				llOk = This.oNextTier.lIsOk

				If !Empty(This.oNextTier.cXMLoError)
					This.cXMLoError = This.oNextTier.cXMLoError
				Endif

				If This.oNextTier.lAutoDestroy
					This.oNextTier = Null
				Endif

				If !llOk
					This.lIsOk = .F.
					This.oError.Process( This.cXMLoError )
				Endif
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

	Endproc && RetrieveNextTierData


	*
	* Recorre la colección ejecutando un comando para cada elemento
	Procedure LookOverColTables( toCol As Collection,;
			tcMethod As String,;
			txParam As Variant,;
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
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (18:01:09)
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
			toCol AS Collection
			tcMethod AS String
			txParam AS Variant
			tlDescending AS Boolean
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif


		Local loTable As oTable Of "FW\Comunes\Prg\ColTables.prg"
		Local i As Integer

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			If Vartype( toCol ) = "O"

				For i = 1 To toCol.Count

					loTable = toCol.Item( i )

					If tlDescending
						If This.lIsOk
							This.LookOverColTables( loTable.oColTables, ;
								tcMethod, ;
								txParam, ;
								tlDescending )
						Endif
					Endif

					If This.lIsOk
						This.&tcMethod.(loTable, txParam)
					Endif

					If !tlDescending
						If This.lIsOk
							This.LookOverColTables( loTable.oColTables, ;
								tcMethod,;
								txParam,;
								tlDescending )
						Endif
					Endif

				Endfor
			Endif


		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError = This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return This.lIsOk

	Endproc && LookOverCollection

	*
	* Devuelve el nombre del cursor principal desde la colección tables
	Protected Procedure GetMainCursorName(  ) As String;
			HELPSTRING "Devuelve el nombre del cursor principal desde la colección tables"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve el nombre del cursor principal desde la colección tables
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (18:12:12)
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
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcCursorName As String
		Local llNextTierAlreadyExist As Boolean
		Local lcAlias As String
		Local loTable As oTable Of "FW\TierAdapter\Comun\ColTables.prg"


		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			lcAlias = Alias()
			lcCursorName = ""
			llNextTierAlreadyExist = This.lNextTierAlreadyExist

			If !Empty( This.oColTables.Count )
				loTable = This.oColTables.Item( 1 )
				lcCursorName = loTable.CursorName
			Endif


			If !llNextTierAlreadyExist
				This.oNextTier = .F.
			Endif


		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return lcCursorName

	Endproc && GetMainCursorName


	*
	* Devuelve el nombre de la tabla asociada al cursor principal desde la colección tables
	Protected Procedure GetMainTableName(  ) As String;
			HELPSTRING "Devuelve el nombre de la tabla asociada al cursor principal desde la colección tables"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve el nombre de la tabla asociada al cursor principal desde la colección tables
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (18:12:12)
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
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcTableName As String
		Local loTable As oTable Of "FW\TierAdapter\Comun\ColTables.prg"
		Local llNextTierAlreadyExist As Boolean
		Local lcAlias As String

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			lcAlias = Alias()
			lcTableName = ""
			llNextTierAlreadyExist = This.lNextTierAlreadyExist

			If !Empty( This.oColTables.Count )
				loTable = This.oColTables.Item( 1 )
				lcTableName = loTable.Tabla
			Endif

			If !llNextTierAlreadyExist
				This.oNextTier = .F.
			Endif


		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return lcTableName

	Endproc && GetMainTableName


	*
	* Devuelve el nombre de la PK del cursor principal desde la colección tables
	Protected Procedure GetMainCursorPK(  ) As String;
			HELPSTRING "Devuelve el nombre de la PK del cursor principal desde la colección tables"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve el nombre de la PK del cursor principal desde la colección tables
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (18:12:12)
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
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif


		Local lcCursorName As String
		Local loTable As oTable Of "FW\TierAdapter\Comun\ColTables.prg"
		Local llNextTierAlreadyExist As Boolean
		Local lcAlias As String

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			lcAlias = Alias()
			lcCursorPK = ""
			llNextTierAlreadyExist = This.lNextTierAlreadyExist

			If !Empty( This.oColTables.Count )
				loTable = This.oColTables.Item( 1 )
				lcCursorPK = loTable.PKName
			Endif

			If !llNextTierAlreadyExist
				This.oNextTier = .F.
			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return lcCursorPK

	Endproc && GetMainCursorPK

	*
	* Nombre del Cursor Principal
	Procedure cMainCursorName_Access(  ) As String;
			HELPSTRING "Nombre del Cursor Principal"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Nombre del Cursor Principal
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (19:35:03)
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
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


			If !This.lOnDestroy
				This.oError.TraceLogin = ""
				This.oError.Remark = ""

				If Empty ( This.cMainCursorName )
					This.cMainCursorName = This.GetMainCursorName()
				Endif
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

		Return This.cMainCursorName

	Endproc && cMainCursorName_Access


	*
	* Nombre de la tabla asociada al cursor principal
	Procedure cMainTableName_Access(  ) As String;
			HELPSTRING "Nombre de la tabla asociada al cursor principal"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Nombre de la tabla asociada al cursor principal
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (19:37:10)
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
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			If !This.lOnDestroy
				This.oError.TraceLogin = ""
				This.oError.Remark = ""

				If Empty ( This.cMainTableName )
					This.cMainTableName = This.GetMainTableName()
				Endif
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

		Return This.cMainTableName

	Endproc && cMainTableName_Access


	*
	* Nombre de la PK del cursor principal
	Procedure cMainCursorPK_Access(  ) As String;
			HELPSTRING "Nombre de la PK del cursor principal"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Nombre de la PK del cursor principal
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Miércoles 13 de Mayo de 2009 (19:39:22)
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
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			If !This.lOnDestroy
				This.oError.TraceLogin = ""
				This.oError.Remark = ""

				If Empty ( This.cMainCursorPK )
					This.cMainCursorPK = This.GetMainCursorPK()
				Endif
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

		Return This.cMainCursorPK

	Endproc && MainCursorPK_Access


	* ///////////////////////////////////////////////////////
	* Procedure.....: AddValidationReport
	* Description...: Va creando un cursor con informació sobre fallas en la validación
	* Date..........: Lunes 16 de Octubre de 2006 (14:42:10)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure AddValidationReport( tcErrorDescription As String,;
			tcAlias As String,;
			tcFieldName As String ) As Boolean;
			HELPSTRING "Va creando un cursor con informació sobre fallas en la validación"

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			* Va creando un cursor con la Descripcion del Error, y el alias y campo
			* Donde se produjo.
			* Con estos datos, el formulario puede recorrer la colección oColIB
			* e ir buscando a traves de la propiedad ControlSource el control
			* donde se produjo el error.

			If !Empty( tcErrorDescription )

				If Empty( tcAlias )
					tcAlias = ""
				Endif

				If Empty( tcFieldName )
					tcFieldName = ""
				Endif

				tcErrorDescription = Alltrim( tcErrorDescription ) + CR

				If Empty( This.cValidationCursorName )
					This.cValidationCursorName = Sys(2015)+Sys(2015)
					Do While Used( This.cValidationCursorName )
						This.cValidationCursorName = Sys(2015)+Sys(2015)
					Enddo
					Create Cursor (This.cValidationCursorName) ;
						(ErrorDescription C (200),;
						cAlias C (128),;
						cFieldName C (128))
				Endif

				Insert Into (This.cValidationCursorName) ;
					(ErrorDescription,;
					cAlias,;
					cFieldName) ;
					VALUES ;
					(tcErrorDescription,;
					tcAlias,;
					tcFieldName)
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

	Endproc
	*
	* END PROCEDURE AddValidationReport
	*
	* ///////////////////////////////////////////////////////

	* ///////////////////////////////////////////////////////
	* Procedure.....: GenerateValidationReport
	* Description...: Arma un XML con la información contenida en el cursor de validación
	* Date..........: Lunes 16 de Octubre de 2006 (14:43:26)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure GenerateValidationReport(  ) As String;
			HELPSTRING "Arma un XML con la información contenida en el cursor de validación"

		Local lcRetVal As String
		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			lcRetVal = ""

			If Used( This.cValidationCursorName )

				Local loXA As prxXMLAdapter Of "FW\Comunes\Prg\prxXMLAdapter.prg"

				loXA = Newobject("prxXMLAdapter",;
					"prxXMLAdapter.prg")

				loXA.AddTableSchema( This.cValidationCursorName )
				loXA.PreserveWhiteSpace = .T.
				loXA.ToXML( "lcRetVal" )
				This.lIsOk = loXA.lIsOk
				This.cXMLoError = loXA.cXMLoError

			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			loXA = Null
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return lcRetVal

	Endproc
	*
	* END PROCEDURE GenerateValidationReport
	*
	* ///////////////////////////////////////////////////////

	* ///////////////////////////////////////////////////////
	* Procedure.....: GetAllPaginated
	* Description...: Trae una página del conjunto de datos
	* Date..........: Lunes 9 de Enero de 2006 (18:01:26)
	* Author........: Ricardo Aidelman
	* Project.......: Tier Adapter
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure GetAllPaginated( nPageNro As Number, cFilterCriteria As String ) As Boolean ;
			HELPSTRING "Trae una página del conjunto de datos"

		* Especializado en cada subclase.
		This.RetrieveNextTierData()
		Return This.lIsOk

	Endproc
	*
	* END PROCEDURE GetAllPaginated
	*
	* ///////////////////////////////////////////////////////

	* ///////////////////////////////////////////////////////
	* Procedure.....: GetAllPaginatedCount
	* Description...: Devuelve un cursor con la cantidad de páginas que tiene la consulta
	* Date..........: Lunes 9 de Enero de 2006 (18:03:58)
	* Author........: Ricardo Aidelman
	* Project.......: Tier Adapter
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure GetAllPaginatedCount( tcFilterCriteria As String ) As Boolean ;
			HELPSTRING "Devuelve un cursor con la cantidad de páginas que tiene la consulta"

		* Especializado en cada subclase.
		This.RetrieveNextTierData()
		Return This.lIsOk

	Endproc && GetAllPaginatedCount

	* ///////////////////////////////////////////////////////
	* Procedure.....: HookBeforeGetBack
	* Description...:
	* Date..........: Martes 14 de Agosto de 2007 (19:10:11)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure HookBeforeGetBack( tnIDEntidad As Variant, ;
			tcDiffGram As String, ;
			tnLevel As Integer, ;
			toXA As prxXMLAdapter ) As Boolean



	Endproc
	*
	* END PROCEDURE HookBeforeGetBack
	*
	* ///////////////////////////////////////////////////////


	* RR, 31/12/2003 (Hic...)
	*
	* Al hacer un Put, si las reglas de negocio creaban la necesidad
	* de modificar y/o agregar algunos datos
	* a los cursores que se iban a grabar, se presentaba el problema que
	* al obtener el nuevo DiffGram, este
	* solo contenía las modificaciones efectuadas en la capa de negocios y
	* no aquellas hechas en la capa de
	* usarios. Para incluir ambas es necesario bajar a la capa de datos,
	* traer los cursores en su estado
	* original (podemos utilizar el metodo GetOne) y aplicarles el diffgram
	* con las modificaciones hechas
	* en la capa de usuario. Luego si estaremos en condiciones de modificar
	* dichos cursores según lo indiquen
	* las reglas de negocio para despues obtener un diffgram con
	* la totalidad de las modificaciones.
	*
	* Este metodo de la capa de negocios tiene como objetivo,
	* dados los datos originales junto a las modificaciones
	* efectuadas en la capa de usuario y un XMLAdapter
	* (para contener las modificaciones, aplicar y obtener el nuevo
	* DiffGram), obtener los cursores "marcados" como modificados.
	*
	* Parámetros recibidos:
	*
	* tcOriginalData	Los datos originales, en el estado previo a la
	*  					modificaciones efectuadas en la capa de usuario
	*  					(sin tener en cuenta la concurrencia de usuarios)
	* tcDiffGram		Las modificaciones efectuadas en la capa de usuarios
	* tnLevel			El nivel de detalle
	* toXA			El objeto XMLAdapter que mantendrá el control de los
	*   				cambios y del que luego extraeremos el nuevo DiffGram
	*

	Protected Procedure GetBack( tnIDEntidad As Variant, ;
			tcDiffGram As String, ;
			tnLevel As Integer, ;
			toXA As prxXMLAdapter,;
			cXMLFilter As String ) As Boolean

		Local loParam As Object
		Local loCol As Collection
		Local i As Integer
		Local lnOffSet As Integer

		Try

			lnOffSet = 0

			This.GetData( This.oNextTier.GetOne( tnIDEntidad,;
				tnLevel,;
				cXMLFilter ) )


			If This.lSerialize

				If This.lIsOk
					This.oError.TraceLogin = ""
					This.oError.Remark = ""

					loParam = Createobject("Empty")
					AddProperty(loParam, "oXA", toXA )
					AddProperty(loParam, "nLevel", tnLevel )

					If This.oColTables.Count > 0
						loTable = This.oColTables.Item( 1 )
						lnOffSet = loTable.Nivel - 1
					Endif

					AddProperty(loParam, "nOffSet", lnOffSet )


					If This.LookOverColTables( This.oColTables,;
							"AddTable", loParam)


						toXA.LoadXML( tcDiffGram )
						loCol = Newobject( "PrxCollection", "PrxBaseLibrary.prg" )

						For i = 1 To toXA.Tables.Count
							loCol.AddItem( i, Lower( toXA.Tables( i ).Alias ))
						Endfor

						loParam = Createobject("Empty")
						AddProperty(loParam, "oXA", toXA )
						AddProperty(loParam, "nLevel", tnLevel )
						AddProperty(loParam, "oCol", loCol )
						AddProperty(loParam, "nOffSet", lnOffSet )

						This.LookOverColTables( This.oColTables, ;
							"InternalApplyDiffgram",;
							loParam)

					Endif
				Endif
			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			loParam = Null
			loCol = Null

			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return This.lIsOk

	Endproc

	* ///////////////////////////////////////////////////////
	* Procedure.....: InternalApplyDiffgram
	* Description...: Recorre la colección aplicando los Diffgram
	* Date..........: Martes 10 de Enero de 2006 (12:26:04)
	* Author........: Ricardo Aidelman
	* Project.......: Tier Adapter
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure InternalApplyDiffgram( toTable As Object,;
			toParam As Object ) As Boolean;
			HELPSTRING "Es llamado por el método LookOverColTables, una vez para cada tabla"

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			If toTable.Nivel - toParam.nOffSet <= toParam.nLevel

				If Used( toTable.CursorName )

					* Seteo los campos clave del cursor para evitar el
					* error Nº 18 - Line too long al hacer el AppyDiffGram con
					* cursores de más de 50 campos.

					For Each oField In toParam.oXA.Tables( toParam.oCol.Item( Lower( toTable.CursorName ) )).Fields
						If IsIn( Upper( Alltrim( oField.Alias ) ), Upper( Alltrim( toTable.PKName ) ) ) > 0
							oField.KeyField = .T.
						Endif
					Endfor

					Select ( toTable.CursorName )
					toParam.oXA.Tables( toParam.oCol.Item( Lower( toTable.CursorName ) )).ApplyDiffgram()
				Endif
			Endif


		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			toTables = Null
			toParam = Null
			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return This.lIsOk

	Endproc
	*
	* END PROCEDURE InternalApplyDiffgram
	*
	* ///////////////////////////////////////////////////////


	* ///////////////////////////////////////////////////////
	* Procedure.....: SetSystemDefault
	* Description...: Setea la Carpeta por default para la capa
	* Date..........: Miércoles 23 de Agosto de 2006 (17:20:31)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Tango
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure SetSystemDefault(  ) As Boolean;
			HELPSTRING "Setea la Carpeta por default para la capa"

		Local loXA As prxXMLAdapter Of "FW\Comunes\Prg\prxXMLAdapter.prg"
		Local lcDefault As String,;
			lcAlias As String

		Try

			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			lcDefault = ""
			lcAlias = ""

			If This.lComComponent
				If Empty( This.cDefaultFolder )

					* Nombre del archivo que contiene la carpeta por default para la capa
					This.cSystemDefaultFileName = Addbs( This.cRootFolder ) + "PrxConfig.xml"

					* Nombre del archivo de configuración del componente ComPlusInfo
					This.cComServersConfig = Addbs( This.cRootFolder ) + "ComServersSetUp.xml"

					loXA = Newobject("prxXMLAdapter",;
						"prxXMLAdapter.prg")

					If This.lDebugMode
						TEXT To lcCommand NoShow TextMerge
						loXA.LoadXML( '<<This.cSystemDefaultFileName>>', .T. )
						ENDTEXT

						Strtofile( lcCommand, "SetSystemDefaultMsg.prg" )

					Endif

					loXA.LoadXML( This.cSystemDefaultFileName, .T. )

					loXA.Tables(1).ToCursor()

					loXA = Null

					lcAlias= Alias()
					lcDefault = Alltrim( cDefaultFolder )

					This.cDefaultFolder = lcDefault

				Endif

				If !Empty( This.cDefaultFolder )

					Set Default To (lcDefault)

					This.oError.LogFolder = This.cDefaultFolder

				Endif

			Endif


		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If Used( lcAlias )
				Use In Alias( lcAlias )
			Endif

			loXA = Null

			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

		Return This.lIsOk

	Endproc
	*
	* END PROCEDURE SetSystemDefault
	*
	* ///////////////////////////////////////////////////////

	* ///////////////////////////////////////////////////////
	* Procedure.....: ValidateXml
	* Description...: Verifica si el XML trae un mensaje de EROR o los datos solicitados
	* Date..........: Domingo 8 de Enero de 2006 (13:45:41)
	* Author........: Ricardo Aidelman
	* Project.......: Tier Adapter
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure ValidateXML( tcXML As String ) As Boolean;
			HELPSTRING "Verifica si el XML trae un mensaje de ERROR o los datos solicitados"


		Local lcIdentifier As String

		Try
			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			If Empty( tcXML )
				This.nResultStatus = RESULT_OK

				If ! This.lSerialize
					This.GetData()

				Endif && ! This.lSerialize

			Else && Empty( tcXML )
				lcIdentifier = ParseXML( tcXML, 1 )

				Do Case

					Case 	lcIdentifier = WARNING_TAG
						This.nResultStatus = RESULT_WARNINGS
						This.cXMLoError = tcXML

					Case 	lcIdentifier = BIZ_TAG
						This.nResultStatus = RESULT_BIZ_ERROR
						This.cXMLoError = tcXML

						*!*	Case 	Empty( tcXML )
						*!*	    This.nResultStatus = RESULT_OK

						*!*	    If !This.lSerialize
						*!*	        This.GetData()
						*!*	    Endif

					Case This.lIsOk

						If lcIdentifier = USER_TAG
							* No hacer nada
							This.nResultStatus = RESULT_USER_TAG

						Else

							tcXML = This.GetData( tcXML )

							If This.lIsOk
								This.nResultStatus = RESULT_OK

							Else
								This.cXMLoError = This.oError.Process( tcXML  )
								This.nResultStatus = RESULT_ERROR

							Endif
						Endif

					Otherwise
						This.cXMLoError = This.oError.Process( This.cXMLoError )
						This.nResultStatus = RESULT_ERROR

				Endcase

			Endif && Empty( tcXML )

			If This.oNextTier.lAutoDestroy
				This.oNextTier = Null

			Endif && This.oNextTier.lAutoDestroy

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			If !This.lIsOk
				*!*					Throw This.oError
			Endif

		Endtry

		Return This.lIsOk

	Endproc
	*
	* END PROCEDURE ValidateXml
	*
	* ///////////////////////////////////////////////////////




	* ///////////////////////////////////////////////////////
	* Procedure.....: cNextTierLevel_Access
	* Date..........: Miércoles 12 de Marzo de 2008 (16:22:22)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure cNextTierLevel_Access()
		Try
			This.oError.TraceLogin = ""
			This.oError.Remark = ""


			If Empty( This.cNextTierLevel ) And !This.lOnDestroy

				Do Case
					Case Lower( This.cTierLevel ) = "user"
						This.cNextTierLevel = "Business"

					Case Lower( This.cTierLevel ) = "business"
						This.cNextTierLevel = "Data"

					Case Lower( This.cTierLevel ) = "data"
						This.cNextTierLevel = Sys(2015)

					Otherwise
						This.cNextTierLevel = Sys(2015)

				Endcase
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

		Return This.cNextTierLevel

	Endproc
	*
	* END PROCEDURE cNextTierLevel_Access
	*
	* ///////////////////////////////////////////////////////

	* ///////////////////////////////////////////////////////
	* Procedure.....: lComComponent_Access
	* Date..........: Lunes 3 de Marzo de 2008 (14:15:02)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Protected Procedure xlComComponent_Access()

		This.lComComponent = This.lComComponent And !File( "ForceNeverUseComComponent.cfg" )

		Return This.lComComponent

	Endproc
	*
	* END PROCEDURE lComComponent_Access
	*
	* ///////////////////////////////////////////////////////


	* ///////////////////////////////////////////////////////
	* Procedure.....: FillColEntities
	* Description...: Llena la colecci{on Entities con informaci{on para poder instanciar los objetos de negocio asociados
	* Date..........: Lunes 13 de Agosto de 2007 (11:56:05)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Protected Procedure FillColEntities(  ) As Boolean;
			HELPSTRING "Llena la colecci{on Entities con informaci{on para poder instanciar los objetos de negocio asociados"


		*	Se personaliza en cada entidad

		Return This.lIsOk

	Endproc
	*
	* END PROCEDURE FillColEntities
	*
	* ///////////////////////////////////////////////////////


	Protected Procedure oColEntities_Access

		Try
			This.oError.TraceLogin = ""
			This.oError.Remark = ""

			If !This.lOnDestroy And Vartype( This.oColEntities ) <> "O"

				*!*					This.oColEntities = Newobject( "colEntities", "colEntities.prg" )

				*!*					This.oColEntities.cTierLevel 	= This.cTierLevel
				*!*					This.oColEntities.DataSessionId	= This.DataSessionId
				*!*					This.oColEntities.oParent 		= This

				This.oColEntities = Newobject( "prxCollection", "prxBaseLibrary.prg" )

				This.FillColEntities()

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

		Return This.oColEntities
	Endproc




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetEntity
	*!* Description...: Devuelve un Objeto de la colección Entities
	*!* Date..........: Miércoles 14 de Mayo de 2008 (18:41:10)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*



	Procedure GetEntity( tcEntityName As String,;
			tcTierLevel As String,;
			tcDataConfigurationKey As String ) As Object;
			HELPSTRING "Devuelve un Objeto de la colección Entities"

		Local loEntity As utArchivo Of "FW\Tieradapter\UserTier\utArchivo.prg"
		Local i As Integer
		Local loMain As utArchivo Of "FW\TierAdapter\UserTier\utArchivo.prg"

		Try

			loEntity = Null

			If Empty( tcTierLevel )
				tcTierLevel = This.cTierLevel
			Endif

			* RA 2009-11-10(18:32:40)
			* Se puede crear más de una instacia de una clase
			* pasando en tcEntityName el alias de la instancia y en
			* tcDataConfigurationKey la clave única de la clase
			If Empty( tcDataConfigurationKey )
				tcDataConfigurationKey = tcEntityName
			Endif

			* RA 2009-11-10(09:45:56)
			* La encargada de devolver la entidad es siempre la entidad principal
			* Me fijo si existe en la coleccion Entities
			loMain = This.GetMain()

			loEntity = loMain.oColEntities.GetItem( Lower( tcEntityName + "_" + tcTierLevel ))

			If Vartype( loEntity ) # "O"
				* La busco en la Colección Children
				loEntity = This.GetChild( tcEntityName, tcTierLevel )

				If Vartype( loEntity ) # "O"
					* Si no la encuentro, la crea la entidad principal

					loEntity = loMain.InstanciateEntity( tcDataConfigurationKey, tcTierLevel )
					*loEntity.DataSessionId = This.DataSessionId

					loMain.oColEntities.AddItem( loEntity, Lower( tcEntityName + "_" + tcTierLevel ))

				Endif

			Endif

			*!*				loEntity = Null

			*!*				If Empty( tcTierLevel )
			*!*					tcTierLevel = This.cTierLevel
			*!*				Endif

			*!*				* Me fijo si existe en la coleccion Entities

			*!*				loEntity = This.oColEntities.GetItem( Lower( tcEntityName + "_" + tcTierLevel ))

			*!*				If Vartype( loEntity ) # "O"
			*!*					* La busco en la Colección Children
			*!*					loEntity = This.GetChild( tcEntityName,	tcTierLevel )

			*!*					If Vartype( loEntity ) # "O" And !This.lIsChild And Vartype( This.oParent ) # "O"
			*!*						* Si no la encuentro, la creo
			*!*						loEntity = This.InstanciateEntity( tcEntityName, tcTierLevel )
			*!*						*loEntity.DataSessionId = This.DataSessionId

			*!*						This.oColEntities.AddItem( loEntity, Lower( tcEntityName + "_" + tcTierLevel ))

			*!*					Endif


			*!*				Endif

		Catch To oErr
			Local loError As ErrorHandler Of "fw\Actual\ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loEntity

	Endproc
	*!*
	*!* END PROCEDURE GetEntity
	*!*
	*!* ///////////////////////////////////////////////////////



	*
	* Devuelve el Id de la entidad desde el registro donde se encuentra
	Procedure GetEntityId(  ) As Integer;
			HELPSTRING "Devuelve el Id de la entidad desde el registro donde se encuentra"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve el Id de la entidad desde el registro donde se encuentra
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Lunes 28 de Septiembre de 2009 (11:31:43)
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
			Integer
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lnEntidadId As Integer

		Try

			lnEntidadId = Evaluate( This.cEntityCursor + "." + This.cMainCursorPK )

			If !Empty( lnEntidadId )
				This.nEntidadId = lnEntidadId

			Else
				This.LocatePK()

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

		Return lnEntidadId

	Endproc && GetEntityId


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetChild
	*!* Description...: Devuelve un Objeto de la colección Children
	*!* Date..........: Miércoles 14 de Mayo de 2008 (18:41:10)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*



	Procedure GetChild( tcEntityName As String,;
			tcTierLevel As String ) As Object;
			HELPSTRING "Devuelve un Objeto de la colección Children"

		Try
			Local loEntity As utArchivo Of "FW\Tieradapter\UserTier\utArchivo.prg"
			Local loChildEntity As utChildEntity Of "FW\Tieradapter\UserTier\utChildEntity.prg"
			Local loObj As utChildEntity Of "FW\Tieradapter\UserTier\utChildEntity.prg"
			Local lcKey As String
			Local i As Integer

			loEntity = Null

			If Empty( tcTierLevel )
				tcTierLevel = This.cTierLevel
			Endif

			lcKey = Alltrim( Lower( tcEntityName ) ) + "_" + Alltrim( Lower( tcTierLevel ) )

			Do Case
				Case Lower( tcEntityName ) == Lower( This.cDataConfigurationKey ) ;
						And Lower( tcTierLevel ) == Lower( This.cTierLevel )
					loEntity = This

				Case !Empty( This.oColChildren.GetKey( lcKey ))
					* Verifico si tcEntityName se encuentra en la colección hijos

					loObj = This.oColChildren.GetItem( lcKey )
					loEntity = loObj.oEntity

				Otherwise

					For i = 1 To This.oColChildren.Count
						loChildEntity 	= This.oColChildren.GetEntity( This.oColChildren.GetKey( i ) )
						*!*							loChildEntity 	= This.oColChildren.Item( i )
						loEntity 		= loChildEntity.GetEntity( tcEntityName, tcTierLevel )

						If !Isnull( loEntity )
							Exit
						Endif
					Endfor

			Endcase

			If Vartype( loEntity ) = "O" And ! This.lIsChild
				loEntity.cMainEntity = This.cDataConfigurationKey
				loEntity.SetProperty( "lIsChild", .T. )

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "fw\Actual\ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loChildEntity = Null

		Endtry

		Return loEntity

	Endproc
	*!*
	*!* END PROCEDURE GetChild
	*!*
	*!* ///////////////////////////////////////////////////////


	* ///////////////////////////////////////////////////////
	* Procedure.....: oColTables_Access
	* Date..........: Sábado 18 de Abril de 2009 (20:07:14)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure oColTables_Access()
		Local lcXML As String

		Try

			If !This.lOnDestroy
				If Vartype( This.oColTables ) <> "O"
					This.oColTables = This.oServiceTier.oColTables
				Endif
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

		Return This.oColTables

	Endproc
	*
	* END PROCEDURE oColTables_Access
	*
	* ///////////////////////////////////////////////////////

	* ///////////////////////////////////////////////////////
	* Procedure.....: cDataConfigurationKey_Access
	* Description...: Devuelve el valor de DataConfigurationKey
	* Date..........: Sábado 18 de Abril de 2009 (20:22:15)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure cDataConfigurationKey_Access(  )

		Try

			If Empty(This.cDataConfigurationKey)

				Do Case
					Case Inlist( Substr( Lower( This.Name ), 1, 2 ), "ut", "st", "bt", "dt" )
						This.cDataConfigurationKey = Substr( This.Name, 3 )

					Case Substr( Lower( This.Name ), 1, 5 ) = "user_"
						This.cDataConfigurationKey = Substr( This.Name, 6 )

					Case Substr( Lower( This.Name ), 1, 8 ) = "service_"
						This.cDataConfigurationKey = Substr( This.Name, 9 )

					Case Substr( Lower( This.Name ), 1, 9 ) = "business_"
						This.cDataConfigurationKey = Substr( This.Name, 10 )

					Otherwise
						This.cDataConfigurationKey = This.Name

				Endcase

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

		Return This.cDataConfigurationKey

	Endproc
	*
	* END PROCEDURE cDataConfigurationKey_Access
	*
	* ///////////////////////////////////////////////////////

	* ///////////////////////////////////////////////////////
	* Procedure.....: oServiceTier_Access
	* Date..........: Jueves 23 de Abril de 2009 (18:57:04)
	* Author........: Ricardo Aidelman
	* Project.......: Sistemas Praxis
	* -------------------------------------------------------
	* Modification Summary
	* R/0001  -
	*
	*

	Procedure oServiceTier_Access()

		If !This.lOnDestroy

			If Vartype( This.oServiceTier ) <> "O"

*!*					This.oServiceTier = This.InstanciateEntity( This.cDataConfigurationKey,;
*!*						"Service" )

				* Devuelve la service tier generica
				This.oServiceTier = NewObject( "ServiceTier", "Fw\Tieradapter\Servicetier\Servicetier.prg" )
				This.oServiceTier.oEntity = This
				This.oServiceTier.oParent = This.oParent

			Endif

			If Empty( This.cMainEntity )
				This.oServiceTier.cMainEntity = This.cDataConfigurationKey

			Else
				This.oServiceTier.cMainEntity = This.cMainEntity

			Endif

		Endif

		Return This.oServiceTier

	Endproc && oServiceTier_Access

	*
	* ProcessResults
	* Se utiliza para validar las operqaciones con otras entidades
	Protected Procedure ProcessResults( tnResult As Integer, tcRetVal As String ) As Void


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Se utiliza para validar las operqaciones con otras entidades
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Miércoles 16 de Septiembre de 2009 (13:51:57)
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
			tnResult As Integer
			tcRetVal As String
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lcRetVal As String

		* lcRetVal = ParseXML( tcRetVal )

		Do Case
			Case tnResult = RESULT_OK

			Case tnResult = RESULT_WARNINGS

			Case Inlist( tnResult, RESULT_BIZ_ERROR )
				loError = This.oError
				This.cXMLoError = loError.Process( tcRetVal )
				Throw loError

			Otherwise
				loError = This.oError
				This.cXMLoError = loError.Process( tcRetVal )
				Throw loError

		Endcase

	Endproc && ProcessResults

	* Indica si la entidad ha sido modificada
	Procedure DataHasChanges() As Boolean;
			HELPSTRING "Indica si la entidad ha sido modificada"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Indica si la entidad ha sido modificada
			*:Project:Sistemas Praxis
			*:Autor:Ricardo Aidelman
			*:Date:Jueves 7 de Mayo de 2009 (16:54:39)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local llDataHasChanges As Boolean
		Local lcGetfldstate As String
		Local loEntity As TierAdapter Of "FW\TierAdapter\Comun\TierAdapter.prg"
		Local lnRecno As Integer
		Local llDone As Boolean
		Dimension laCampos[ 2 ]

		* @TODO Ricardo Aidelman 2009-09-24 (12:16:26) Arreglar un poquito el código, que está horrible
		Try
			llDataHasChanges = .F.
			If This.ClassBeforeDataHasChanges()
				If This.HookBeforeDataHasChanges()
					If Used( This.cEntityCursor )


						Select Alias( This.cEntityCursor )
						lnRecno = Recno()
						Locate

						If CursorGetProp( "Buffering", This.cEntityCursor ) = 5

							laCampos[ 1 ] = "_RecordOrder"
							laCampos[ 2 ] = "Selected"

							lnLen = Afields( laFields )

							i = 0
							For Each loC In laCampos
								If !Empty( Ascan( laFields, loC, 1, lnLen, 1, 1 ))
									i = i + 1
								Endif
							Endfor

							If !Empty( i )
								Scan
									For Each loC In laCampos
										If !Empty( Ascan( laFields, loC, 1, lnLen, 1, 1 ))
											If Recno() > 0
												Setfldstate( loC, 1 )
											Endif
										Endif
									Endfor

								Endscan

							Endif

							Locate

							If Getnextmodified( 0, This.cEntityCursor ) # 0
								lcGetfldstate = Getfldstate( -1, This.cEntityCursor )
								If ! Empty( At( Any2Char( GFS_MODIFIED ), lcGetfldstate ) ) ;
										Or ! Empty( At( Any2Char( GFS_APPENDED_MODIFIED ), lcGetfldstate ) )
									llDataHasChanges = .T.
								Endif
							Endif
						Endif

						If !Empty( lnRecno )
							Try
								Goto lnRecno

							Catch To oErr

							Finally

							Endtry

						Endif

					Endif

					If !llDataHasChanges
						For Each loObj In This.oColChildren
							loEntity = loObj.oEntity
							If llDataHasChanges
								Exit
							Else
								llDataHasChanges = loEntity.DataHasChanges()
							Endif
						Endfor
					Endif

					If !llDataHasChanges
						For Each loEntity In This.oColEntities
							If llDataHasChanges
								Exit
							Else
								llDataHasChanges = loEntity.DataHasChanges()
							Endif
						Endfor
					Endif

					This.HookAfterDataHasChanges( llDataHasChanges )

				Endif

				This.ClassAfterDataHasChanges( llDataHasChanges )

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
		Return llDataHasChanges

	Endproc

	* ClassBeforeDataHasChanges
	Procedure ClassBeforeDataHasChanges() As Boolean
		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Template Method
			*:Project: Sistemas Praxis
			*:Autor: Damien Eiff
			*:Date: Jueves 26 de Mayo de 2009
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return .T.

	Endproc

	* HookBeforeDataHasChanges
	Procedure HookBeforeDataHasChanges() As Boolean
		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Template Method
			*:Project: Sistemas Praxis
			*:Autor: Damien Eiff
			*:Date: Jueves 26 de Mayo de 2009
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return .T.

	Endproc

	* HookAfterDataHasChanges
	Procedure HookAfterDataHasChanges( tlDataHasChanges As Boolean  ) As Boolean
		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Template Method
			*:Project:Sistemas Praxis
			*:Autor:Ricardo Aidelman
			*:Date:Jueves 7 de Mayo de 2009 (16:54:39)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return .F.

	Endproc

	* ClassAfterDataHasChanges
	Procedure ClassAfterDataHasChanges( tlDataHasChanges As Boolean  ) As Boolean
		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Template Method
			*:Project:Sistemas Praxis
			*:Autor:Ricardo Aidelman
			*:Date:Jueves 7 de Mayo de 2009 (16:54:39)
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
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Return .F.

	Endproc


	*
	* cObjectFactoryFileName_Access
	Protected Procedure xcObjectFactoryFileName_Access()

		If Empty( This.cObjectFactoryFileName ) And !This.lOnDestroy
			This.cObjectFactoryFileName = This.oServiceTier.cObjectFactoryFileName

		Endif

		Return This.cObjectFactoryFileName

	Endproc && cObjectFactoryFileName_Access

	*
	* lSerialize_Access
	Protected Procedure lSerialize_Access()
		If !This.lOnDestroy
			This.lSerialize = This.oServiceTier.lSerialize
		Endif

		Return This.lSerialize

	Endproc && lSerialize_Access

	*
	* lMakeTransactable_Access
	Procedure lMakeTransactable_Access()
		If !This.lOnDestroy
			This.lMakeTransactable = This.oServiceTier.lMakeTransactable
		Endif

		Return This.lMakeTransactable

	Endproc && lMakeTransactable_Access

	*
	* oColChildren_Access
	Protected Procedure oColChildren_Access()

		If Vartype( This.oColChildren ) # "O" And !This.lOnDestroy
			This.oColChildren = This.oServiceTier.oColChildren
			*!*				This.oColChildren.cTierLevel = This.cTierLevel
			*!*				This.oColChildren.oParent = This

		Endif

		Return This.oColChildren

	Endproc && oColChildren_Access

	*
	* cEntityCursor_Access
	Protected Procedure cEntityCursor_Access()

		If Empty( This.cEntityCursor ) And !This.lOnDestroy
			This.cEntityCursor = This.cMainCursorName
		Endif

		Return This.cEntityCursor

	Endproc && cEntityCursor_Access

	*
	* Devuelve el valor del atributo pedido
	Procedure GetValue( tcAtributo As String, tcEntityCursor As String ) As Variant;
			HELPSTRING "Devuelve el valor del atributo pedido"

		Return This.oServiceTier.GetValue( tcAtributo, tcEntityCursor )

	Endproc && GetValue


	*
	* Decodifica el valor recibido en un nombre de campo válido
	Procedure GetFieldProperty( tcFieldName As String, tcPropertyName As String ) As Variant;
			HELPSTRING "Decodifica el valor recibido en un nombre de campo válido"

		Return This.oServiceTier.GetFieldProperty( tcFieldName, tcPropertyName )

	Endproc && GetFieldProperty


	*
	* Graba el valor en el campo asociado al atributo
	Procedure SetValue( tcAtributo As String,;
			tuValue As Variant, tcEntityCursor As String  ) As Boolean;
			HELPSTRING "Graba el valor en el campo asociado al atributo"

		Return This.oServiceTier.SetValue( tcAtributo, tuValue, tcEntityCursor )

	Endproc && SetValue


	*
	* Permite inicializar los valores por default de la entidad. Es llamado por New()
	Procedure SetDefaults(  ) As Void;
			HELPSTRING "Permite inicializar los valores por default de la entidad. Es llamado por New()"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Permite inicializar los valores por default de la entidad. Es llamado por New()
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Martes 30 de Junio de 2009 (08:31:08)
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
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try


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

	Endproc && SetDefaults

	*
	* lIsChild_Access
	Protected Procedure lIsChild_Access()

		If This.lIsChild = .F.
			This.lIsChild = This.oServiceTier.lIsChild
		Endif

		Return This.lIsChild

	Endproc && lIsChild_Access

	* lIsChild_Assign

	Protected Procedure lIsChild_Assign( uNewValue )

		This.lIsChild = uNewValue
		This.oServiceTier.lIsChild = uNewValue

	Endproc && lIsChild_Assign



	Procedure lHasDescripcion_Access()

		This.lHasDescripcion = This.oServiceTier.lHasDescripcion
		Return This.lHasDescripcion

	Endproc && lHasDescripcion_Access



	Procedure lHasCodigo_Access()

		This.lHasCodigo = This.oServiceTier.lHasCodigo
		Return This.lHasCodigo

	Endproc

	Procedure lHasDefault_Access()

		This.lHasDefault = This.oServiceTier.lHasDefault
		Return This.lHasDefault

	Endproc

	Procedure lUseCodigo_Access()

		This.lUseCodigo = This.oServiceTier.lUseCodigo
		Return This.lUseCodigo

	Endproc



	*
	* Ejecuta un método de la capa de servicio
	Procedure Execute( tcProcedureName As String,;
			toParam As Object ) As Variant;
			HELPSTRING "Ejecuta un método de la capa de servicio"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Ejecuta un método de la capa de servicio
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Jueves 30 de Julio de 2009 (11:23:37)
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
			tcProcedure AS String
			*:Remarks:
			*:Returns:
			Variant
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif
		Local lvReturn As Variant
		Try

			lvReturn = This.oServiceTier.&tcProcedureName.( toParam )

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
		Return lvReturn
	Endproc && Execute



	*
	* Asigna un valor a una propiedad de la capa de servicio
	Procedure SetProperty( tcPropertyName As String,;
			tvValue As Variant ) As Void;
			HELPSTRING "Asigna un valor a una propiedad de la capa de servicio"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Asigna un valor a una propiedad de la capa de servicio
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Jueves 30 de Julio de 2009 (11:29:18)
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
			tcPropertyName AS String
			tvValue AS Variant
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try

			Try

				This.oServiceTier.&tcPropertyName = tvValue

			Catch To oErr

			Finally

			Endtry



			Try
				This.&tcPropertyName = tvValue

			Catch To oErr

			Finally

			Endtry


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

	Endproc && SetProperty


	*
	* Obtiene el valor de una propiedad de la capa de servicio
	Procedure GetProperty( tcPropertyName As String ) As Variant;
			HELPSTRING "Obtiene el valor de una propiedad de la capa de servicio"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Obtiene el valor de una propiedad de la capa de servicio
			*:Project:
			Sistemas Praxis
			*:Autor:
			Danny Amerikaner
			*:Date:
			Jueves 30 de Julio de 2009 (11:33:32)
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
			tcPropertyName AS String
			*:Remarks:
			*:Returns:
			Variant
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif
		Local lvReturn As Variant
		Try

			lvReturn = This.oServiceTier.&tcPropertyName

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
		Return lvReturn
	Endproc && GetProperty


	*
	* Se posiciona en el registro que contiene la PK igual a la de la entidad
	Procedure LocatePK( tnEntityId As Integer,;
			tlKeepArea As Boolean,;
			tlRecursive As Boolean ) As Void;
			HELPSTRING "Se posiciona en el registro que contiene la PK igual a la de la entidad"


		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Se posiciona en el registro que contiene la PK igual a la de la entidad
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 14 de Agosto de 2009 (08:28:26)
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
			tnEntityId AS Integer
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local lcAlias As String
		Local lcPK As String
		Local loEntity As utArchivo Of "FW\TierAdapter\UserTier\utArchivo.prg"
		Local i As Integer

		Try

			lcAlias = Alias()

			If Used( This.cEntityCursor )
				If Empty( tnEntityId )
					tnEntityId = This.nEntidadId
				Endif

				lcPK = This.cMainCursorPK

				Select Alias( This.cEntityCursor )

				Locate For &lcPK = tnEntityId

				If tlRecursive
					For i = 1 To This.oColChildren.Count
						loObj = This.oColChildren.Item( i )
						loEntity = loObj.oEntity
						loEntity.LocatePK( 0, .T., .T. )
					Endfor
				Endif

			Endif

		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			loEntity = Null
			loObj = Null
			If Used( lcAlias ) And !tlKeepArea
				Select Alias( lcAlias )
			Endif

			If !This.lIsOk
				Throw This.oError
			Endif

		Endtry

	Endproc && LocatePK


	*
	* ResetError
	Procedure ResetError() As Void
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			This.oNextTier.ResetError()
			This.oServiceTier.ResetError()
			This.lIsOk = .T.
			This.cXMLoError = ''
			DoDefault()

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr, .F. )

		Finally
			loError = Null

		Endtry

	Endproc && ResetError

Enddefine



Procedure dummy
	If .F.
		Do appendfromcursor.prg
		Do createfromcursor.prg
		Do getcursorstructure.prg
		Do getfieldsvalues.prg
		Do insertfromcursor.prg
		Do updatefromcursor.prg

		Do Confirm.prg
		Do Inform.prg
		Do stop.prg
		Do warning.prg
	Endif
Endproc