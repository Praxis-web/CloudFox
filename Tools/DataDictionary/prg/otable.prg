#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include "Tools\DataDictionary\Include\datadictionary.h"

If .F.
	Do 'Tools\DataDictionary\prg\oBase.prg'
	Do 'ErrorHandler\Prg\ErrorHandler.prg'
	Do 'Tools\DataDictionary\prg\oColFields.prg'
	Do 'Tools\DataDictionary\prg\oField.prg'
	Do 'Tools\DataDictionary\prg\oColIndexes.prg'
	Do 'Tools\DataDictionary\prg\oColProperties.prg'
	Do 'Tools\DataDictionary\prg\oColInsertTriggers.prg'
	Do 'Tools\DataDictionary\prg\oColUpdateTriggers.prg'
	Do 'Tools\DataDictionary\prg\oColDeleteTriggers.prg'

Endif

* oTable
* Clase table.
Define Class oTable As oBase Of 'Tools\DataDictionary\prg\oBase.prg'

	#If .F.
		Local This As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
	#Endif

	* Colección Fields
	oColFields = Null

	* Colección Indices
	oColIndexes = Null

	* Colección de triggers para Update
	oColUpdateTriggers = Null

	* Colección de triggers para Delete
	oColDeleteTriggers = Null

	* Colección de triggers para Insert
	oColInsertTriggers = Null

	* Carpeta donde se encuentra la Tabla
	cFolder = ''

	* Nombre largo de la tabla
	cLongTableName = ''

	* Código de Página
	nCodepage = 1252

	* Specifies the table validation rule.
	* Must evaluate to a logical expression and can be a user-defined function
	* or a stored procedure.
	cCheck = ''

	* Mensaje de error que se muestra si Check evalua a .F.
	cErrorMessage = ''

	* Extensión de la tabla
	cExt = 'Dbf'

	DataSession = SET_DEFAULT

	* Indica si la entidad utiliza el campo Codigo, independientemente si lo tiene o no
	lUseCodigo = .T.

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

	cSetFirstFocus = ''

	* Nombre de fantasía por el que se accede a la coleccion oDataDictionary
	cKeyName = ''

	* Coleccion de propiedades
	oColProperties = Null && As Collection

	* Lista de Entidades asociadas
	cChildList = ''

	* Directorio del Proyecto
	cProjectPath = ''

	* Las entidades y los formularios estan definidos en el Proyecto X
	cIncludedInTheProject = ''

	* Indica si se genera el metodo SetGridLayout
	lGenerateSetGridLayaout = .T.

	* Clave para identificar a la entidad.
	* Nombre unico de la entidad en el archivo de configuracion.
	cDataConfigurationKey = ''

	* Nombre del Cursor que representa a la tabla en las Tier
	cCursorName = ''

	* Colección de tablas
	oColTables = Null

	* Indica la cantidad de niveles de la entidad
	nNivelJerarquiaTablas = 0

	* Nombre de la tabla
	cTabla = ''

	* Nombre del cursor a generar.
	*   Es la PK de la colección. No puede haber 2 elementos con la misma
	*   propiedad CursorName
	cCursorName = ''

	* En la tabla hija va el nombre de la tabla padre
	cPadre = ''

	* en la tabla hija va el nombre del campo con el que se relaciona
	* con la tabla padre (Foreign Key)
	cForeignKey = ''

	* Referencia al nombre del campo que contiene el ID
	* de la tabla de nivel 1 con la que está relacionada.
	cMainId = ''

	* Nombre de la Primary Key de la tabla/nivel de la entidad
	cPkName = ''

	* Indica si la PK es Updatable para incluirla o no en la UpdatableFieldList
	lPkUpdatable = .F.

	* Nivel de profundidad de la tabla
	nNivel = 0

	*
	oCursorAdapter = ''

	* Numero de Registro Actual de la tabla
	nCurReg = 0

	* Indica si la tabla es una tabla auxiliar
	lAuxiliary = .F.

	* Indica la clausula ORDER BY para el GetAll(), en caso de Nivel 1, o las tablas Hijas, para los demás niveles
	cOrderBy = ''

	* Clausula WHERE para la tabla
	cWhereStatement = ''

	* Indica si la tabla implementa una extructura jerárquica
	lIsHierarchical = .F.

	* Indica si la tabla implementa el modelo de relaciones
	lSetRelations = .T.

	* Indica si la tabla es _VIRTUAL y _NO pertenece a la base de datos
	* Se genera un cursor en base a un SELECT SQL
	lIsVirtual = .F.

	* Indica si la tabla tiene una tabla donde se registren las modificaciones realizadas.
	lHasActivityLog = .F.

	lCreateIfNotExist = .T.

	* Fuerza a permanecer en la colección cuando al hacer un Merge() se encuentra que ya existe otra definición.
	lForce = .F.

	* Genera automáticamente la PK.
	lGeneratePK = .T.

	* Prefijo de la tabla.
	cPrefijo = ''

	* Indica si la tabla es compartida (DRCOMUN) o exclusiva (DRVA).
	lShared = .F.

	* Indica si es una tabla libre.
	lIsFree = .F.

	* Si es True, NO elimina los campos que existen en la tabla y no existen en la definición.
	lAdditive = .T.

	cBaseClass = ""
	cBaseClassLib = ""

	*!*
	cUpdatableFieldList = ""

	*!*
	cUpdateNameList = ""

	* Nombre del campo por el que se relaciona en la nube
	cLookupField = 'Id'




	Protected m._MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="clookupfield" type="property" display="cLookupField" />] ;
		+ [<memberdata name="lisfree" type="property" display="lIsFree" />] ;
		+ [<memberdata name="lcreateifnotexist" type="property" display="lCreateIfNotExist" />] ;
		+ [<memberdata name="generateindexes" type="method" display="GenerateIndexes" />] ;
		+ [<memberdata name="lshared" type="property" display="lShared" />] ;
		+ [<memberdata name="lforce" type="property" display="lForce" />] ;
		+ [<memberdata name="corderbyselector" type="property" display="cOrderBySelector" />] ;
		+ [<memberdata name="corderbycombo" type="property" display="cOrderByCombo" />] ;
		+ [<memberdata name="sqlstatselector" type="property" display="SQLStatSelector" />] ;
		+ [<memberdata name="sqlstatcombo" type="property" display="SQLStatCombo" />] ;
		+ [<memberdata name="sqlstatkeyfinder" type="property" display="SQLStatKeyFinder" />] ;
		+ [<memberdata name="lhasactivitylog" type="property" display="lHasActivityLog" />] ;
		+ [<memberdata name="lisvirtual" type="property" display="lIsVirtual" />] ;
		+ [<memberdata name="lsetrelations" type="property" display="lSetRelations" />] ;
		+ [<memberdata name="ocolreport" type="property" display="oColReport" />] ;
		+ [<memberdata name="lusecodigo" type="property" display="lUseCodigo" />] ;
		+ [<memberdata name="ckeyname" type="property" display="cKeyName" />] ;
		+ [<memberdata name="nniveljerarquiatablas" type="property" display="nNivelJerarquiaTablas" />] ;
		+ [<memberdata name="ocolinserttriggers" type="property" display="oColInsertTriggers" />] ;
		+ [<memberdata name="ocoldeletetriggers" type="property" display="oColDeleteTriggers" />] ;
		+ [<memberdata name="ocolupdatetriggers" type="property" display="oColUpdateTriggers" />] ;
		+ [<memberdata name="cext" type="property" display="cExt" />] ;
		+ [<memberdata name="cerrormessage" type="property" display="cErrorMessage" />] ;
		+ [<memberdata name="ccheck" type="property" display="cCheck" />] ;
		+ [<memberdata name="ncodepage" type="property" display="nCodePage" />] ;
		+ [<memberdata name="clongtablename" type="property" display="cLongTableName" />] ;
		+ [<memberdata name="ocolfields" type="property" display="oColFields" />] ;
		+ [<memberdata name="cfolder" type="property" display="cFolder" />] ;
		+ [<memberdata name="ocolindexes" type="property" display="oColIndexes" />] ;
		+ [<memberdata name="initialize" type="method" display="Initialize" />] ;
		+ [<memberdata name="classbeforeinitialize" type="method" display="ClassBeforeInitialize" />] ;
		+ [<memberdata name="addtreehierarchicalfields" type="method" display="AddTreeHierarchicalFields" />] ;
		+ [<memberdata name="addhierarchicalfields" type="method" display="AddHierarchicalFields" />] ;
		+ [<memberdata name="addcodigoydescripcion" type="method" display="AddCodigoYDescripcion" />] ;
		+ [<memberdata name="nclasstype" type="property" display="nClassType" />] ;
		+ [<memberdata name="cbaseclass" type="property" display="cBaseClass" />] ;
		+ [<memberdata name="cbaseclasslib" type="property" display="cBaseClassLib" />] ;
		+ [<memberdata name="ocolproperties" type="property" display="oColProperties" />] ;
		+ [<memberdata name="cformclass" type="property" display="cFormClass" />] ;
		+ [<memberdata name="cformclasslib" type="property" display="cFormClassLib" />] ;
		+ [<memberdata name="cformclasslibfolder" type="property" display="cFormClassLibFolder" />] ;
		+ [<memberdata name="cchildlist" type="property" display="cChildList" />] ;
		+ [<memberdata name="hookpopulateproperties" type="method" display="HookPopulateProperties" />] ;
		+ [<memberdata name="cformname" type="property" display="cFormName" />] ;
		+ [<memberdata name="cprojectpath" type="property" display="cProjectPath" />] ;
		+ [<memberdata name="cincludedintheproject" type="property" display="cIncludedInTheProject" />] ;
		+ [<memberdata name="getprimarykey" type="method" display="GetPrimaryKey" />] ;
		+ [<memberdata name="lgeneratesetgridlayaout" type="property" display="lGenerateSetGridLayaout" />] ;
		+ [<memberdata name="cdataconfigurationkey" type="property" display="cDataConfigurationKey" />] ;
		+ [<memberdata name="setasarchivo" type="method" display="SetAsArchivo" />] ;
		+ [<memberdata name="setaschild" type="method" display="SetAsChild" />] ;
		+ [<memberdata name="setaschildtree" type="method" display="SetAsChildTree" />] ;
		+ [<memberdata name="ccursorname" type="property" display="cCursorName" />] ;
		+ [<memberdata name="getprimarytagname" type="method" display="GetPrimaryTagName" />] ;
		+ [<memberdata name="lhasdefault" type="property" display="lHasDefault" />] ;
		+ [<memberdata name="lhasdescripcion" type="property" display="lHasDescripcion" />] ;
		+ [<memberdata name="lhascodigo" type="property" display="lHasCodigo" />] ;
		+ [<memberdata name="csetfirstfocus" type="property" display="cSetFirstFocus" />] ;
		+ [<memberdata name="ocolforms" type="property" display="oColForms" />] ;
		+ [<memberdata name="ocoltiers" type="property" display="oColTiers" />] ;
		+ [<memberdata name="ocoltables" type="property" display="oColTables" />] ;
		+ [<memberdata name="lishierarchical" type="property" display="lIsHierarchical" />] ;
		+ [<memberdata name="getfieldlistfromsqlstat" type="property" display="GetFieldListFromSQLStat" />] ;
		+ [<memberdata name="nivel" type="property" display="Nivel" />] ;
		+ [<memberdata name="ocoltables" type="property" display="oColTables" />] ;
		+ [<memberdata name="lastsql" type="property" display="LastSQL" />] ;
		+ [<memberdata name="pkupdatable" type="property" display="PKUpdatable" />] ;
		+ [<memberdata name="cpkname" type="property" display="cPkName" />] ;
		+ [<memberdata name="sqlstat" type="property" display="SQLStat" />] ;
		+ [<memberdata name="mainid" type="property" display="MainID" />] ;
		+ [<memberdata name="foreignkey" type="property" display="ForeignKey" />] ;
		+ [<memberdata name="padre" type="property" display="Padre" />] ;
		+ [<memberdata name="cursorname" type="property" display="CursorName" />] ;
		+ [<memberdata name="tabla" type="property" display="Tabla" />] ;
		+ [<memberdata name="cupdatablefieldlist" type="property" display="cUpdatableFieldList" />] ;
		+ [<memberdata name="cupdatenamelist" type="property" display="cUpdateNameList" />] ;
		+ [<memberdata name="ocursoradapter" type="property" display="oCursorAdapter" />] ;
		+ [<memberdata name="curreg" type="property" display="CurReg" />] ;
		+ [<memberdata name="auxiliary" type="property" display="Auxiliary" />] ;
		+ [<memberdata name="orderby" type="property" display="OrderBy" />] ;
		+ [<memberdata name="wherestatement" type="property" display="WhereStatement" />] ;
		+ [<memberdata name="cdataconfigurationkey" type="property" display="cDataConfigurationKey" />] ;
		+ [<memberdata name="lcodigoisnumeric" type="property" display="lCodigoIsNumeric" />] ;
		+ [<memberdata name="lgeneratepk" type="property" display="lGeneratePK" />] ;
		+ [<memberdata name="ladditive" type="property" display="lAdditive" />] ;
		+ [<memberdata name="synchronize" type="method" display="Synchronize" />] ;
		+ [<memberdata name="cformfolder" type="property" display="cFormFolder" />] ;
		+ [<memberdata name="hookbeforeinitialize" type="method" display="HookBeforeInitialize" />];
		+ [<memberdata name="getfield" type="method" display="GetField" />] ;
		+ [<memberdata name="hookafterinitialize" type="method" display="HookAfterInitialize" />] ;
		+ [</VFPData>]

	* cDataConfigurationKey_Access
	Protected Function cDataConfigurationKey_Access()

		Local lcTableName As String, ;
			loErr As Object, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damian Eiff
			 *:Date:
			 Viernes 13 de Marzo de 2009 (17:22:26)
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try

			*!*	If Empty ( This.cDataConfigurationKey )
			*!*		This.cDataConfigurationKey = This.Name  && Substr( This.CursorName, 2 )

			*!*	Endif && Empty( This.cDataConfigurationKey )

			If Vartype ( This.cDataConfigurationKey ) # 'C' Or Empty ( This.cDataConfigurationKey )
				lcTableName                = m.String.CamelProperCase ( Alltrim ( This.Name ) )
				This.cDataConfigurationKey = Chrtran ( Chrtran ( lcTableName, ' ', '' ), '-', '_' )

			Endif && Vartype ( This.cDataConfigurationKey ) # 'C' Or Empty ( This.cDataConfigurationKey )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError = Null

		Endtry
		Return This.cDataConfigurationKey

	Endfunc && cDataConfigurationKey_Access

	* cTabla_Access
	Protected Function cTabla_Access()

		If Empty ( This.cTabla )
			This.cTabla = This.Name

		Endif && Empty( This.cTabla )

		Return This.cTabla

	Endfunc  && cTabla_Access

	* Init
	Protected Procedure Init ( tlIsFree As Boolean ) As Void

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damián Eiff
			 *:Date:
			 Martes 15 de Abril de 2008 (10:51:28)
			 *:Parameters:
			 tlIsFree As Boolean
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Local loError As ErrorHandler Of "FW\ErrorHandler\ErrorHandler.prg"
		Local loErr As Exception

		Try

			DoDefault()

			This.oColFields         = _NewObject( 'oColFields', 'Tools\DataDictionary\prg\oColFields.prg' )
			This.oColFields.oParent = This
			This.lIsFree = m.tlIsFree
			This.oColTables = _NewObject( 'oColTables', 'Tools\DataDictionary\prg\oColTables.prg' )
			This.oColTables.oParent = This
			This.ClassBeforeInitialize()
			This.HookBeforeInitialize()
			This.Initialize()
			This.HookAfterInitialize()
			This.ClassAfterInitialize()

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			m.loError = Null

		Endtry

	Endproc && Init

	* ClassBeforeInitialize
	Protected Procedure ClassBeforeInitialize () As Void

		Local lcField As String, ;
			lcName As String, ;
			loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
			loeEcfg As Object

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damián Eiff
			 *:Date:
			 Martes 15 de Abril de 2008 (10:51:09)
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif


		Try


		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError     = Null
			loField     = Null
			loColFields = Null

		Endtry

	Endproc && ClassBeforeInitialize



	*
	*
	Procedure HookBeforeInitialize(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && HookBeforeInitialize


	* Initialize
	Procedure Initialize ( uParam As Variant ) As Void
		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damián Eiff
			 *:Date:
			 Martes 15 de Abril de 2008 (10:49:20)
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

	Endproc && Initialize


	*
	*
	Procedure HookAfterInitialize(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && HookAfterInitialize


	* ClassAfterInitialize
	Procedure ClassAfterInitialize() As Void

		Local liIdx As Integer, ;
			loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loField As oField Of 'Tools\DataDictionary\prg\oField.prg'

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damián Eiff
			 *:Date:
			 Martes 15 de Abril de 2008 (10:51:09)
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loField     = Null
			loError     = Null
			loColFields = Null

		Endtry

	Endproc && ClassAfterInitialize

	*!*	Procedure oColFields_Access
	*!*	    If Vartype ( This.oColFields ) # 'O'
	*!*	        This.oColFields         = Newobject( 'ColFields', 'DataDictionary\prg\ColFields.prg' )
	*!*	        This.oColFields.oParent = This

	*!*	    Endif && Vartype( This.oColFields ) # "O"

	*!*	    Return This.oColFields

	*!*	Endproc && oColFields_Access




	Procedure oColIndexes_Access

		If Vartype ( This.oColIndexes ) # 'O'
			This.oColIndexes         = _NewObject( 'oColIndexes', 'Tools\DataDictionary\prg\oColIndexes.prg' )
			This.oColIndexes.oParent = This

		Endif && Vartype( This.oColIndexes ) # "O"

		Return This.oColIndexes

	Endproc && oColIndexes_Access

	Procedure oColDeleteTriggers_Access
		If Vartype ( This.oColDeleteTriggers ) # 'O'
			This.oColDeleteTriggers         = _NewObject( 'oColDeleteTriggers', 'Tools\DataDictionary\prg\oColDeleteTriggers.prg' )
			This.oColDeleteTriggers.oParent = This

		Endif && Vartype( This.oColDeleteTriggers ) # "O"

		Return This.oColDeleteTriggers

	Endproc && oColDeleteTriggers_Access

	Procedure oColInsertTriggers_Access
		If Vartype ( This.oColInsertTriggers ) # 'O'
			This.oColInsertTriggers         = _NewObject( 'oColInsertTriggers', 'Tools\DataDictionary\prg\oColInsertTriggers.prg' )
			This.oColInsertTriggers.oParent = This

		Endif && Vartype( This.oColInsertTriggers ) # "O"

		Return This.oColInsertTriggers

	Endproc && oColInsertTriggers_Access

	Procedure oColUpdateTriggers_Access
		If Vartype ( This.oColUpdateTriggers ) # 'O'
			This.oColUpdateTriggers         = _NewObject( 'oColUpdateTriggers', 'Tools\DataDictionary\prg\oColUpdateTriggers.prg' )
			This.oColUpdateTriggers.oParent = This

		Endif && Vartype( This.oColUpdateTriggers ) # "O"

		Return This.oColUpdateTriggers

	Endproc && oColUpdateTriggers_Access


	* Comment_Assign
	Procedure Comment_Assign ( tcComment As String ) As String

		Local lcStr As String

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damián Eiff
				 *:Date:
				 Jueves 10 de Abril de 2008 (13:31:54)
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif


		If Len ( tcComment ) > 253
			lcStr = 'La Propiedad ' + This.cLongTableName + '.Comment es demasiado largo(' + m.String.Any2Char ( Len ( tcComment ) ) + ')' + CR + CR
			lcStr = lcStr + tcComment
			Error lcStr

		Else
			This.Comment = tcComment

		Endif

		Return This.Comment

	Endproc && Comment_Assign


	* oColProperties_Access
	Procedure oColProperties_Access()

		#If .F.
			TEXT
		 *:Help Documentation
		 *:Autor:
		 Damian Eiff

		 *:Date:
		 Martes 10 de Marzo de 2009 (19:28:52)

		 *:Parameters:
		 *:Remarks:
		 *:Returns:
		 *:Example:
		 *:SeeAlso:
		 *:Events:
		 *:KeyWords:
		 *:Inherits:
		 *:Exceptions:
		 *:NameSpace:
		 digitalizarte.com
		 *:EndHelp
			ENDTEXT
		#Endif

		If Vartype ( This.oColProperties ) # 'O'
			* This.oColProperties = Newobject( 'ColProperties', 'DataDictionary\prg\ColProperties.prg' )
			This.oColProperties = _NewObject( 'oColProperties', 'Tools\DataDictionary\prg\oColProperties.prg' )
			This.HookPopulateProperties()

		Endif

		Return This.oColProperties

	Endproc && oColProperties_Access

	* HookPopulateProperties
	Procedure HookPopulateProperties () As Void HelpString 'Carga las popiedades iniciales que se definen para las Tier o los Form'

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Autor:
			 Damian Eiff
			 *:Date:
			 Martes 10 de Marzo de 2009 (19:41:59)
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

	Endproc && HookPopulateProperties



	*
	*
	Procedure GetField( cFieldName as String ) as Object 
		Local lcCommand As String
		Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
			loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
		

		Try

			lcCommand = ""
			loColFields = This.oColFields 
			loField = loColFields.GetItem( cFieldName )   

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loColFields = Null

		EndTry
		
		Return loField  

	Endproc && GetField


	* GetPrimaryKey
	* Devuelve el campo que representa a la clave primaria 
	Procedure GetPrimaryKey() As oField Of 'Tools\DataDictionary\prg\oField.prg' HelpString 'Devuelve el campo que representa a la clave primaria.'

		Local loColData As Object, ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loFieldRet As oFielld Of 'Tools\DataDictionary\prg\oFielld.prg'

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve el campo que representa a la clave primaria
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damian Eiff
				 *:Date:
				 Viernes 13 de Marzo de 2009 (15:14:26)
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		Try

			loColData  = This.oColFields.Where ( 'nIndexKey == ' + Transform ( IK_PRIMARY_KEY ) )
			loFieldRet = m.loColData.Item[ 1 ]

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError   = Null
			loColData = Null

		Endtry

		Return loFieldRet

	Endproc && GetPrimaryKey

	* GetPrimaryTagName
	* Devuelve el TAG de la clave primaria.
	Procedure GetPrimaryTagName () As oField Of 'Tools\DataDictionary\prg\oField.prg' HelpString 'Devuelve el TAG de la clave primaria'

		Local lcTagName As String, ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loField As oField Of 'Tools\DataDictionary\prg\oField.prg'

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Devuelve el TAG de la clave primaria
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damian Eiff
			 *:Date:
			 Viernes 13 de Marzo de 2009 (15:14:26)
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try

			lcTagName = ''
			loField   = This.GetPrimaryKey()
			If ! Empty ( loField.cTagName )
				lcTagName = loField.cTagName

			Endif && ! Empty( loField.cTagName )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loField = Null
			loError = Null

		Endtry

		Return lcTagName

	Endproc  && GetPrimaryTagName

	*!*	* CursorName_Access
	*!*	Protected Function cCursorName_Access() As String

	*!*		If Empty ( This.cCursorName )
	*!*			This.cCursorName = 'c' + This.Name

	*!*		Endif && Empty( this.CursorName )

	*!*		Return This.cCursorName

	*!*	Endfunc && cCursorName_Access

	* cCursorName_Access
	Procedure cCursorName_Access()

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damian Eiff
			 *:Date:
			 Sábado 21 de Marzo de 2009 (13:01:14)
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		If Vartype ( This.cCursorName ) # 'C' Or Empty ( This.cCursorName )
			This.cCursorName = 'c' + This.Name

		Endif && Vartype( this.cCursorName ) # 'C' Or Empty( this.cCursorName )

		Return This.cCursorName

	Endproc && cCursorName_Access

	*
	* cKeyName_Access
	Protected Procedure cKeyName_Access()

		If Empty ( This.cKeyName )
			This.cKeyName = Strtran ( Lower ( This.Name ), 'sys_', '' )

		Endif && Empty ( This.cKeyName )

		Return This.cKeyName

	Endproc && cKeyName_Access

	* cUpdatableFieldList_Access
	Protected Procedure cUpdatableFieldList_Access()

		If Empty( This.cUpdatableFieldList )
			This.cUpdatableFieldList = This.oColFields.ToString( "Name", "," , "lAutoinc = .F. And lIsVirtual = .F.")

		Endif

		Return This.cUpdatableFieldList

	Endproc && UpdatableFieldList_Access

	* cUpdateNameList_Access
	Protected Procedure cUpdateNameList_Access()

		If Empty( This.cUpdateNameList )
			This.cUpdateNameList = This.oColFields.ToString( "Name + ' " + This.Name + ".' + Name", ",", "lIsVirtual = .F." )

		Endif && Empty( This.CursorName )

		Return This.cUpdateNameList

	Endproc && cUpdateNameList_Access


Enddefine && oTable
