
*!* ///////////////////////////////////////////////////////
*!* Class.........: TablesCollection
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Coleccion de TableObjects
*!* Date..........: Martes 28 de Noviembre de 2006 (13:35:54)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class TablesCollection As Collection

	#If .F.
		Local This As TablesCollection Of "TablesCollection.prg"
	#Endif


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Init
	*!* Description...:
	*!* Date..........: Martes 28 de Noviembre de 2006 (13:35:54)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Init(  ) As Boolean


	Endfunc
	*!*
	*!* END FUNCTION Init
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: TablesCollection
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: TableObject
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Contiene la definicion de cada tabla
*!* Date..........: Martes 28 de Noviembre de 2006 (13:37:33)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class TableObject As Session

	#If .F.
		Local This As TableObject Of "TablesCollection.prg"
	#Endif

	*!* Nombre de la Tabla
	TableName = ""

	*!* Colección de objetos Field
	oColFields = Null

	*!* Coleccion de objetos Index
	oColIndexes = Null

	*!* Colección de objetos Property
	oColProperties = Null

	*!* Expresion del Trigger por Updates
	UpdateTrigger = ""

	*!* Expresion del Trigger por Insert
	InsertTrigger = ""

	*!* Expresión del Trigger por Delete
	DeleteTrigger = ""

	*!* Expresión a validar
	SetCheck = ""

	*!* Mensaje de error a mostrar si falla el SET CHECK
	CheckErrorMessage = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="checkerrormessage" type="property" display="CheckErrorMessage" />] + ;
		[<memberdata name="setcheck" type="property" display="SetCheck" />] + ;
		[<memberdata name="deletetrigger" type="property" display="DeleteTrigger" />] + ;
		[<memberdata name="inserttrigger" type="property" display="InsertTrigger" />] + ;
		[<memberdata name="updatetrigger" type="property" display="UpdateTrigger" />] + ;
		[<memberdata name="ocolfields" type="property" display="oColFields" />] + ;
		[<memberdata name="tablename" type="property" display="TableName" />] + ;
		[<memberdata name="ocolindexes" type="property" display="oColIndexes" />] + ;
		[<memberdata name="ocolproperties" type="property" display="oColProperties" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Init
	*!* Description...:
	*!* Date..........: Martes 28 de Noviembre de 2006 (13:37:33)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Init(  ) As Boolean


	Endfunc
	*!*
	*!* END FUNCTION Init
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: TableObject
*!*
*!* ///////////////////////////////////////////////////////



*!* ///////////////////////////////////////////////////////
*!* Class.........: FieldsCollection
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

Define Class FieldsCollection As Collection

	#If .F.
		Local This As FieldsCollection Of "FW\Comunes\Prg\TablesCollection.prg"
	#Endif


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="addfield" type="event" display="AddField" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="validate" type="method" display="Validate" />] + ;
		[</VFPData>]


	Function Init

		Local loField As Object

		loField = Createobject("oField")

		************** TS ****************

		loField.FieldName = "TS"
		loField.FieldType = "DateTime"

		This.AddField( loField )

		************** Transaction_ID ****************

		loField = Createobject("oField")

		loField.FieldName = "TransactionId"
		loField.FieldType = "Integer"

		This.AddField( loField )
		Return .T.
	Endfunc


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AddField
	*!* Description...:
	*!* Date..........: Sábado 28 de Enero de 2006 (11:37:41)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure AddField(  toField As Object ) ;
			As Boolean

		This.Add( toField, Lower(toField.FieldName) )

	Endproc
	*!*
	*!* END PROCEDURE AddField
	*!*
	*!* ///////////////////////////////////////////////////////


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

	Function New(  ) As Object;
			HELPSTRING "Obtiene un elemento oTabla vacío"

		Return Createobject("oField")

	Endfunc
	*!*
	*!* END FUNCTION New
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Validate
	*!* Description...: Valida objeto Field
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

	Endproc
	*!*
	*!* END PROCEDURE Validate
	*!*
	*!* ///////////////////////////////////////////////////////


Enddefine
*!*
*!* END DEFINE
*!* Class.........: FieldsCollection
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: FieldObject
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Elemento Field de la colección Fields
*!* Date..........: Sábado 28 de Enero de 2006 (11:41:29)
*!* Author........: Ricardo Aidelman
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*


Define Class FieldObject As Session

	#If .F.
		Local This As FieldObject Of "FW\Comunes\Prg\TablesCollection.prg"
	#Endif


	*!* Nombre del Campo
	FieldName = ""

	*!* Tipo de Dato
	FieldType  = ""

	*!* Ancho del campo
	FieldWidth  = 0

	*!* Precisión del dato (parte decimal)
	Precision = 0

	*!* Permite valores nulos
	Null = .F.

	*!* Regla de validación a cumplir por el campo
	Check = ""

	*!* Mensaje de error cuando no se cumple la regla de validación
	ErrorMessage = ""

	*!* Indica si el campo es Integer (Autoinc)
	Autoinc = .F.

	*!* Indica el valor siguiente en el caso de ser AutoInc
	Nextvalue = 0

	*!* Indica el valor a sumar al valor actual para obtener el siguiente valor
	Step = 1

	*!* Indica el valor por Default del campo
	Default = .F.

	*!* Indica si el campo es la PK de la tabla
	PrimaryKey = .F.


	*!* Indica si el campo es una clave Única o Candidata
	Unique = .F.


	*!* Indica el tipo de ordenamiento
	Collate = ""

	*!* Indica si mantiene la Página de Código o guarda información binaria
	NoCPTrans = .F.


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="fieldname" type="property" display="FieldName" />] + ;
		[<memberdata name="fieldtype" type="property" display="FieldType " />] + ;
		[<memberdata name="fieldwidth" type="property" display="FieldWidth " />] + ;
		[<memberdata name="precision" type="property" display="Precision" />] + ;
		[<memberdata name="null" type="property" display="Null" />] + ;
		[<memberdata name="check" type="property" display="Check" />] + ;
		[<memberdata name="errormessage" type="property" display="ErrorMessage" />] + ;
		[<memberdata name="autoinc" type="property" display="Autoinc" />] + ;
		[<memberdata name="nextvalue" type="property" display="Nextvalue" />] + ;
		[<memberdata name="step" type="property" display="Step" />] + ;
		[<memberdata name="default" type="property" display="Default" />] + ;
		[<memberdata name="primarykey" type="property" display="PrimaryKey" />] + ;
		[<memberdata name="unique" type="property" display="Unique" />] + ;
		[<memberdata name="collate" type="property" display="Collate" />] + ;
		[<memberdata name="nocptrans" type="property" display="Nocptrans" />] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: FieldObject
*!*
*!* ///////////////////////////////////////////////////////