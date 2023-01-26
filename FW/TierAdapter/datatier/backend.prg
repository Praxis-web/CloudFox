#INCLUDE "FW\Comunes\Include\Praxis.h"

*!* ///////////////////////////////////////////////////////
*!* Class.........: BackEnd
*!* ParentClass...: SessionBase
*!* BaseClass.....: Session
*!* Description...: Clase especializada en la comunicación con el Motor de base de datos
*!* Date..........: Martes 13 de Diciembre de 2005 (18:24:22)
*!* Author........: Ricardo Aidelman
*!* Project.......: Visual Praxis Beta v. 1.1
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class BackEnd As SessionBase Of 'Tools\Namespaces\Prg\ObjectNamespace.prg'

	#If .F.
		Local This As BackEnd Of "FW\TierAdapter\DataTier\BackEnd.prg"
	#Endif

	*!* Nombre de la base de Datos
	cDataBaseName = ""

	*!* String de conección
	cStringConnection = ""

	*!* Motor de base de datos
	cBackEndEngine = ""

	*!* Referencia al objeto ADO
	oConnection = Null

	DataSession = 1

	*!* Indica si el motor acepta valores de fecha vacíos, o se deben convertir a Null
	lAcceptEmptyDate = .T.

	* Clase especializada en la creación y sincronización
	* de la base de datos 
	oSync = Null

	Dimension cDataBaseName_COMATTRIB[4]

	cDataBaseName_COMATTRIB[1] = COMATTRIB_WRITEONLY
	cDataBaseName_COMATTRIB[2] = "Nombre de la Base de Datos"
	cDataBaseName_COMATTRIB[3] = "cDataBaseName"
	cDataBaseName_COMATTRIB[4] = "String"


	Dimension cStringConnection_COMATTRIB[4]

	cStringConnection_COMATTRIB[1] = COMATTRIB_WRITEONLY
	cStringConnection_COMATTRIB[2] = "String de Conección"
	cStringConnection_COMATTRIB[3] = "cStringConnection"
	cStringConnection_COMATTRIB[4] = "String"


	Dimension cBackEndEngine_COMATTRIB[4]

	cBackEndEngine_COMATTRIB[1] = COMATTRIB_WRITEONLY
	cBackEndEngine_COMATTRIB[2] = "Motor de la Base de Datos"
	cBackEndEngine_COMATTRIB[3] = "cBackEndEngine"
	cBackEndEngine_COMATTRIB[4] = "String"





	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="oconnection" type="property" display="oConnection" />] + ;
		[<memberdata name="cbackendengine" type="property" display="cBackEndEngine" />] + ;
		[<memberdata name="cStringConnection" type="property" display="cStringConnection" />] + ;
		[<memberdata name="cdatabasename" type="property" display="cDataBaseName" />] + ;
		[<memberdata name="connect" type="method" display="Connect" />] + ;
		[<memberdata name="disconnect" type="method" display="Disconnect" />] + ;
		[<memberdata name="getnewid" type="method" display="GetNewID" />] + ;
		[<memberdata name="begintransaction" type="method" display="BeginTransaction" />] + ;
		[<memberdata name="endtransaction" type="method" display="EndTransaction" />] + ;
		[<memberdata name="rollback" type="method" display="RollBack" />] + ;
		[<memberdata name="executenonquery" type="method" display="ExecuteNonQuery" />] + ;
		[<memberdata name="validatesqlstatement" type="method" display="ValidateSqlStatement" />] + ;
		[<memberdata name="lacceptemptydate" type="property" display="lAcceptEmptyDate" />] + ;
		[<memberdata name="osync" type="property" display="oSync" />] + ;
		[<memberdata name="osync_access" type="method" display="oSync_Access" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Function......: Connect
	*!* Description...: Se conecta con la base de datos
	*!* Date..........: Martes 13 de Diciembre de 2005 (17:03:08)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta v. 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Connect(  ) As Integer;
			HELPSTRING "Se conecta con la base de datos"


	Endfunc
	*!*
	*!* END FUNCION Connect
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Function......: Disconnect
	*!* Description...: Se desconecta de la base de datos
	*!* Date..........: Martes 13 de Diciembre de 2005 (17:24:52)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta v. 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Disconnect(  ) As Boolean;
			HELPSTRING "Se desconecta de la base de datos"

	Endfunc
	*!*
	*!* END FUNCTION Disconnect
	*!*
	*!* ///////////////////////////////////////////////////////



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetNewId
	*!* Description...:
	*!* Date..........: Martes 13 de Diciembre de 2005 (17:26:48)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta v. 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*
	*--------------------------------------------------------------------------------------------
	* SOLO SE UTILIZA SI LOS ID SON AUTOINCREMENTALES
	* Cuando se hace un alta (New+Put) en una estructura cabecera-detalle,
	* al grabar el registro en la tabla "cabecera", a este se le asigna un
	* nuevo ID (autoincremental) el cual es necesario recuperar para luego
	* volcarlo a la tabla "detalle" a modo de Foreign Key.
	*--------------------------------------------------------------------------------------------

	Procedure GetNewID( tcTable As String ) As Integer

	Endproc
	*!*
	*!* END PROCEDURE GetNewId
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: BeginTransaction
	*!* Description...: Comienza una Transacción
	*!* Date..........: Martes 13 de Diciembre de 2005 (17:29:06)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta v. 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure BeginTransaction(  ) As Boolean;
			HELPSTRING "Comienza una Transacción"

	Endproc
	*!*
	*!* END PROCEDURE BeginTransaction
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: EndTransaction
	*!* Description...: Finaliza una Transacción
	*!* Date..........: Martes 13 de Diciembre de 2005 (17:29:06)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta v. 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure EndTransaction(  ) As Boolean;
			HELPSTRING "Finaliza una Transacción"

	Endproc
	*!*
	*!* END PROCEDURE EndTransaction
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: RollBack
	*!* Description...: Hace un RollBack
	*!* Date..........: Martes 13 de Diciembre de 2005 (17:29:06)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta v. 1.1
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Rollback(  ) As Boolean;
			HELPSTRING "Hace un RollBack"

	Endproc
	*!*
	*!* END PROCEDURE RollBack
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ExecuteNonQuery
	*!* Description...: Ejecuta un comando SQL que no devuelve un resultado
	*!* Date..........: Jueves 19 de Enero de 2006 (11:22:52)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ExecuteNonQuery( cSQLCommand As String ) As Boolean;
			HELPSTRING "Ejecuta una consulta SQL"



	Endproc
	*!*
	*!* END PROCEDURE ExecuteNonQuery
	*!*
	*!* ///////////////////////////////////////////////////////

	*
	* oSync_Access
	Protected Procedure oSync_Access()

		Return This.oSync

	Endproc && oSync_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: BackEnd
*!*
*!* ///////////////////////////////////////////////////////
