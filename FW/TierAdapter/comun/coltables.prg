#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\Tieradapter\Include\TA.h"


*!* ///////////////////////////////////////////////////////
*!* Class.........: ColTables
*!* ParentClass...: collection
*!* BaseClass.....: collection
*!* Description...:
*!* Date..........: Sábado 28 de Enero de 2006 (12:01:13)
*!* Author........: Ricardo Aidelman
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ColTables As PrxCollection Of "Fw\TierAdaptre\Comun\PrxBaseLibrary.prg"

	#If .F.
		Local This As ColTables Of "FW\TierAdapter\Comun\colTables.prg"
	#Endif

	* Indica la cantidad de niveles de la entidad
	nNivelJerarquiaTablas = 0

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="nniveljerarquiatablas" type="property" display="nNivelJerarquiaTablas" />] + ;
		[<memberdata name="addtable" type="event" display="AddTable" />] + ;
		[<memberdata name="validate" type="event" display="Validate" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="movetolevel" type="method" display="MoveToLevel" />] + ;
		[<memberdata name="assignlevel" type="method" display="AssignLevel" />] + ;
		[<memberdata name="gettable" type="method" display="GetTable" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddTable
	*!* Description...:
	*!* Date..........: Sábado 28 de Enero de 2006 (11:37:41)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure AddTable(  toTable As oTable Of "FW\TierAdapter\Comun\ColTables.Prg" ) ;
			As Boolean
		Local i As Integer

		i = This.GetKey( Lower( toTable.cDataConfigurationKey ) )

		If Empty( i )
			This.AddItem( toTable, Lower( toTable.cDataConfigurationKey ) )
		Endif

	Endproc
	*!*
	*!* END PROCEDURE AddTable
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Validate
	*!* Description...: Valida la colección y le asigna el nivel ;
	correspondiente a cada objeto table
	*!* Date..........: Lunes 6 de Febrero de 2006 (21:37:14)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Validate(  ) As Boolean;
			HELPSTRING "Valida la colección y le asigna el nivel correspondiente a cada objeto table"

		Local oCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
		Local loTable As oTable Of "FW\TierAdapter\Comun\ColTables.Prg"
		Local i As Integer
		Local llOk As Boolean,;
			llSetTable As Boolean

		oCol = Newobject( "PrxCollection", "PrxBaseLibrary.prg" )
		llOk = .T.

		*!* Recorre la colección, reubicando cada elemento ;
		El objeto oTable debe formar parte de la colección oColTables ;
		del  Padre
		Do While !Empty( This.Count ) .And. llOk
			llSetTable = .F.
			loTable = This.Item( 1 )

			If Empty( loTable.Padre )
				* Padre vacío: Nivel 1
				loTable.Nivel = 1
				oCol.AddItem( loTable, Lower( loTable.cDataConfigurationKey ) )
				This.Remove( 1 )
				llSetTable = .T.
			Endif

			If !llSetTable
				i = This.GetKey( Lower( loTable.Padre ))
				If !Empty( i )
					* El padre forma parte de la coleccion This
					loPadre = This.Item( i )
					loPadre.oColTables.AddItem( loTable, Lower( loTable.cDataConfigurationKey ) )
					This.Remove( 1 )
					llSetTable = .T.
				Endif
			Endif

			If !llSetTable
				If !Empty(loTable.oColTables.Count)
					i = loTable.oColTables.GetKey( Lower( loTable.Padre ))
					If !Empty( i )
						* El Padre forma parte de la colección loTable.oColTables
						loPadre = loTable.oColTables.Item( i )
						loPadre.oColTables.AddItem( loTable, Lower( loTable.cDataConfigurationKey ) )
						This.Remove( 1 )
						llSetTable = .T.
					Endif
				Endif
			Endif

			If !llSetTable
				* Busca al padre en los niveles internos de This
				If This.MoveToLevel( This, loTable )
					This.Remove( 1 )

				Else
					* Busca al padre en la colección auxiliar oCol
					If This.MoveToLevel( oCol, loTable )
						This.Remove( 1 )

					Else
						* La colección no está validada
						llOk = .F.

					Endif
				Endif
			Endif
		Enddo

		If llOk
			This.Remove( -1 )

			* Copiar la colección auxiliar
			For i = 1 To oCol.Count
				oTable = oCol.Item( i )
				This.AddTable( oTable )
			Endfor

			* Asignar el nivel a cada elemento oTable
			This.nNivelJerarquiaTablas = This.AssignLevel( This, 1, 0 )

		Else
			Try

				Error "La colección Tables no fue Validada" + CR +;
					"Entidad: " + loTable.cDataConfigurationKey + CR +;
					"Tabla: " + loTable.Tabla + CR +;
					"CursorName: " + loTable.CursorName + CR +;
					"Padre: " + loTable.Padre

			Catch To oErr
				Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
				loError = Newobject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

				loError.Process( oErr )
				Throw loError

			Finally

			Endtry

		Endif
		oCol=Null
		Return llOk
	Endproc
	*!*
	*!* END PROCEDURE Validate
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: MoveToLevel
	*!* Description...: Reubica cada elemento de la colección
	*!* Date..........: Lunes 6 de Febrero de 2006 (21:50:22)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Hidden Procedure MoveToLevel( toCol As Collection,;
			toTable As Object ) As Boolean;
			HELPSTRING "Reubica cada elemento de la colección"

		Local llO As Boolean
		Local i As Integer

		llOk = .F.

		For i = 1 To toCol.Count
			oTable = toCol.Item( i )
			If Lower( oTable.cDataConfigurationKey ) == Lower( toTable.Padre )
				oTable.oColTables.AddItem( toTable, Lower( toTable.cDataConfigurationKey ))
				llOk = .T.
				Exit

			Else
				llOk = This.MoveToLevel( oTable.oColTables, toTable )

			Endif
		Endfor

		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE MoveToLevel
	*!*
	*!* ///////////////////////////////////////////////////////

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

		Local loTable As oTable Of "FW\TierAdapter\Comun\ColTables.Prg"
		Local i As Integer

		For i = 1 To toCol.Count
			loTable = toCol.Item( i )
			loTable.Nivel = tnNivel
			tnNivelJerarquiaTablas = This.AssignLevel( loTable.oColTables, tnNivel + 1, tnNivelJerarquiaTablas + 1 )
		Endfor

		Return tnNivelJerarquiaTablas

	Endproc
	*!*
	*!* END PROCEDURE AssignLevel
	*!*
	*!* ///////////////////////////////////////////////////////

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

	Endproc && AssignMain

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


	*!* ///////////////////////////////////////////////////////
	*!* Function......: New
	*!* Description...: Obtiene un elemento oTabla vacío
	*!* Date..........: Jueves 5 de Enero de 2006 (18:35:05)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Menus
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure New( tcCursorName As String,;
			tcBefore As String ) As Object;
			HELPSTRING "Obtiene un elemento oTabla vacío"

		Local loTable As oTable Of "FW\TierAdapter\Comun\colTables.prg"
		Local lcKey As String

		Try
			If Empty( tcCursorName ) Or Vartype( tcCursorName ) # "C"
				Error "Error de tipo en el parámetro tcCursorName"
			Endif

			loTable = Createobject("oTable")
			loTable.CursorName = tcCursorName
			lcKey = Lower( loTable.cDataConfigurationKey )

			If Empty( tcBefore )
				This.AddItem( loTable, lcKey )

			Else
				This.AddItem( loTable, lcKey, Lower( tcBefore ) )

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loTable

	Endproc


	*
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

		Local loTable As oTable Of "FW\TierAdapter\Comun\colTables.prg"
		Local loObj As oTable Of "FW\TierAdapter\Comun\colTables.prg"

		Try

			* Pido la tabla con el nombre requerido
			loTable = This.GetItem( tcTableName )

			If Isnull( loTable )

				* Si no existe recorro la colección
				For Each loObj In This

					* Por cada tabla pido a su colección tables por la tabla buscada
					loTable = loObj.oColTables.GetTable( tcTableName )

					If !Isnull( loTable )
						* Si la encontré, salgo
						Exit
					Endif
				Endfor
			Endif


		Catch To oErr
			* DAE 2009-11-06(20:02:43)
			*!*	If This.lIsOk
			*!*		This.lIsOk = .F.
			*!*		This.cXMLoError=This.oError.Process( oErr )
			*!*	Endif
			This.lIsOk = .F.
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			* DAE 2009-11-06(20:02:45)
			*!*	If !This.lIsOk
			*!*		Throw This.oError
			*!*	Endif

		Endtry

		Return loTable

	Endproc && GetTable



Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColTables
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oTable
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Elemento Table de la colección Tables
*!* Date..........: Sábado 28 de Enero de 2006 (11:41:29)
*!* Author........: Ricardo Aidelman
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

* Elemento oTable de la colección de tablas utilizada en la capa de datos
*
* Detalle del uso de las propiedades del objeto

* Tabla	- Nombre de la tabla - No dejar en Blanco

* CursorName - Nombre del cursor a generar - No dejar en Blanco

* Padre	- Se usa solo en caso de 2 o más tablas con relaciones padre/hijo, ;
caso contrario se debe dejar en blanco. En la tabla padre queda en blanco, ;
en la tabla hija va el nombre de la tabla padre.

* ForeignKey - Se usa solo en caso de 2 o más tablas con relaciones padre/hijo, ;
caso contrario se debe dejar en blanco. En la tabla padre queda en blanco, ;
en la tabla hija va el nombre del campo con el que se relaciona con la ;
tabla padre (Foreign Key)

* MainID - Se usa solo en caso de tablas de nivel 3 o superior, es decir, ;
con relaciones padre/hijo/nieto/etc, y referencia al nombre del campo que ;
contiene el ID de la tabla de nivel 1 con la que está relacionada.

* SQLStat - Para NEW y GETONE, se puede definir una sentencia SQL ;
especializada. Si se deja en blanco, se utilizará "SELECT * FROM ...".	;
La idea es, por ejemplo, en un Cabecera/Detalle con 2 tablas Orders y ;
Orders Detail (Northwind), especializar  el SELECT para el detalle, ;
incluyendo el campo ProductName mediante un INNER JOIN con la tabla ;
Products, evitando asi por cada ítem del detalle hacer un Hit contra la ;
base de datos en búsqueda del nombre del producto. ;
NOTA: aqui no se puede utilizar una vista dado que ; sobre este mismo ;
cursor se pueden hacer actualizaciones por medio del método PUT.

* PKName - Nombre de la Primary Key de la tabla/nivel de la entidad.

* PKUpdatable - Indica si la PK es Updatable para incluirla o no en la ;
UpdatableFieldList.

* LastSQL - Guarda la última sentencia SQL utilzada para consulta.


* Define Class oTable As PrxSession Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
Define Class oTable As PrxCustom Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"


	#If .F.
		Local This As oTable Of "FW\TierAdapter\Comun\colTables.prg"
	#Endif

	DataSession = SET_DEFAULT

	*!* Nombre de la tabla
	Tabla = ""

	*!* Nombre del cursor a generar.
	*   Es la PK de la colección. No puede haber 2 elementos con la misma
	*   propiedad CursorName
	CursorName = ""

	*!* En la tabla hija va el nombre de la tabla padre
	Padre = ""

	*!* en la tabla hija va el nombre del campo con el que se relaciona ;
	con la tabla padre (Foreign Key)
	ForeignKey = ""

	*!* Referencia al nombre del campo que contiene el ID de la tabla de ;
	nivel 1 con la que está relacionada.
	MainID = ""

	*!* Para NEW y GETONE, se puede definir una sentencia SQL
	SQLStat = ""

	*!* Nombre de la Primary Key de la tabla/nivel de la entidad
	PKName = ""

	*!* Indica si la PK es Updatable para incluirla o no en la ;
	UpdatableFieldList
	PKUpdatable = .F.

	*!* Guarda la última sentencia SQL utilzada para consulta
	LastSQL = ""

	*!* Colección de tablas hijas
	oColTables = Null

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

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
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
		[<memberdata name="cdataconfigurationkey" type="property" display="cDataConfigurationKey" />] + ;
		[<memberdata name="cdataconfigurationkey_access" type="method" display="cDataConfigurationKey_Access" />] + ;
		[</VFPData>]

	Function Init
		This.oColTables = Newobject( "ColTables", "FW\TierAdapter\Comun\colTables.prg" )
		Return .T.
	Endfunc

	*
	* cDataConfigurationKey_Access
	Protected Procedure cDataConfigurationKey_Access()

		If Empty( This.cDataConfigurationKey )
			This.cDataConfigurationKey = Substr( This.CursorName, 2 )
		Endif

		Return This.cDataConfigurationKey

	Endproc && cDataConfigurationKey_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oTable
*!*
*!* ///////////////////////////////////////////////////////