*!* ///////////////////////////////////////////////////////
*!* Class.........: ADOBackEnd
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Conección a Base de Datos SQL as través de ADO-OLEDB
*!* Date..........: Martes 13 de Diciembre de 2005 (18:24:22)
*!* Author........: Ricardo Aidelman
*!* Project.......: Visual Praxis Beta v. 1.1
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ADOBackEnd As BackEnd Of "TierAdapter\DataTier\BackEnd.prg"

	#If .F.
		Local This As ADOBackEnd Of "TierAdapter\DataTier\BackEndADO.prg"
	#Endif


	lAcceptEmptyDate = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="executesql" type="method" display="ExecuteSQL" />] + ;
		[</VFPData>]

	Function Connect(  ) As Integer;
			HELPSTRING "Se conecta con la base de datos"

		* Added to force the setting under COM+
		Set Deleted On

		Local lnRetVal As Integer

		Try
			If Vartype(This.oConnection) <> "O"
				This.oConnection= Createobject("ADODB.Connection")
			Endif
			If This.oConnection.State = 0 &&adStateClosed
				This.oConnection.ConnectionString = This.cStringConnection
				This.oConnection.Open()
				lnRetVal = 1
			Else
				lnRetVal = 0
			Endif

		Catch To oErr
			lnRetVal = -1

		Finally

		Endtry

		Return lnRetVal

	Endfunc
	*!*
	*!* END FUNCION Connect
	*!*
	*!* ///////////////////////////////////////////////////////



	Function Disconnect(  ) As Boolean;
			HELPSTRING "Se desconecta de la base de datos"

		Local llRetVal As Boolean
		llRetVal = .T.

		Try
			If Vartype(This.oConnection) = "O" And This.oConnection.State = 1 &&adStateOpen
				This.oConnection.Close()
			Endif
			This.oConnection = Null

		Catch To oErr
			llRetVal = .F.

		Finally

		Endtry

		Return llRetVal
	Endfunc
	*!*
	*!* END FUNCTION Disconnect
	*!*
	*!* ///////////////////////////////////////////////////////



	Procedure GetNewID( tcTable As String, tcPKName As String  ) As Integer

		Local lnRetVal As Integer

		* SQL-Server devuelve un RecordSet con el dato del nuevo ID
		Local oRS As ADODB.RecordSet
		oRS = This.oConnection.Execute( "SELECT IDENT_CURRENT( '" + tcTable + "' )" )
		lnRetVal = oRS.Fields(0).Value

		Return lnRetVal

	Endproc
	*!*
	*!* END PROCEDURE GetNewId
	*!*
	*!* ///////////////////////////////////////////////////////

	Procedure BeginTransaction(  ) As Boolean;
			HELPSTRING "Comienza una Transacción"

		Local llOk As Boolean

		Try

			llOk = .T.
			This.oConnection.Execute( "BEGIN TRANSACTION" )

		Catch To oErr
			llOk = .F.

		Finally

		Endtry

		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE BeginTransaction
	*!*
	*!* ///////////////////////////////////////////////////////

	Procedure EndTransaction(  ) As Boolean;
			HELPSTRING "Finaliza una Transacción"

		Local llOk As Boolean

		Try
			llOk = .T.
			This.oConnection.Execute( "COMMIT TRANSACTION" )

		Catch To oErr
			llOk = .F.

		Finally

		Endtry

		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE EndTransaction
	*!*
	*!* ///////////////////////////////////////////////////////

	Procedure Rollback(  ) As Void;
			HELPSTRING "Hace un RollBack"

		Local llOk As Boolean

		Try
			llOk = .T.
			* -----------------------------------------
			* De los "Books On-Line" de SQL-SERVER 2000
			* -----------------------------------------
			* When nesting transactions, ROLLBACK TRANSACTION rolls back all
			* inner transactions to the outermost BEGIN TRANSACTION statement.
			* ROLLBACK TRANSACTION decrements the @@TRANCOUNT system function to 0.
			* -----------------------------------------
			If This.ExecuteSQL( "SELECT @@TRANCOUNT" ) > 0
				This.oConnection.Execute( "ROLLBACK TRANSACTION" )
			Endif


		Catch To oErr
			llOk = .F.

		Finally

		Endtry


		Return llOk


	Endproc
	*!*
	*!* END PROCEDURE RollBack
	*!*
	*!* ///////////////////////////////////////////////////////

	Procedure ExecuteSQL( tcSQLStat As String ) As String
		Local llAlreadyConnected As Boolean
		llAlreadyConnected = This.Connect() = 0
		Local oRS As ADODB.RecordSet, lcRetVal As String
		oRS = This.oConnection.Execute( tcSQLStat )
		lcRetVal = oRS.Fields(0).Value
		If Not llAlreadyConnected
			This.Disconnect()
		Endif
		Return lcRetVal
	Endproc

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

		Local llOk As Boolean
		Local oRS As ADODB.RecordSet

		Try

			llOk = .T.
			oRS = This.oConnection.Execute( cSQLCommand )

		Catch To oErr
			llOk = .F.
			Throw oErr

		Finally

		Endtry

		Return llOk
	Endproc
	*!*
	*!* END PROCEDURE ExecuteNonQuery
	*!*
	*!* ///////////////////////////////////////////////////////



Enddefine
*!*
*!* END DEFINE
*!* Class.........: ADOBackEnd
*!*
*!* ///////////////////////////////////////////////////////