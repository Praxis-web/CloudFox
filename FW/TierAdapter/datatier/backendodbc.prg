*!* ///////////////////////////////////////////////////////
*!* Class.........: ODBCBackEnd
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Conección a Base de Datos SQL as través de ODBC
*!* Date..........: Martes 13 de Diciembre de 2005 (18:24:22)
*!* Author........: Ricardo Aidelman
*!* Project.......: Visual Praxis Beta v. 1.1
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ODBCBackEnd As BackEnd Of "TierAdapter\DataTier\BackEnd.prg" 

	#If .F.
		Local This As ODBCBackEnd Of "TierAdapter\DataTier\ODBCBackEnd.prg"
	#Endif


	Function Connect(  ) As Integer;
			HELPSTRING "Se conecta con la base de datos"

		* Added to force the setting under COM+
		Set Deleted On

		Local lnRetVal As Integer

		Try
			If IsEmpty(This.oConnection)
				This.oConnection = Sqlstringconnect(This.cStringConnection, .T. )
				If This.oConnection > 0
					lnRetVal = 1
				Else
					lnRetVal = -1
				Endif

			Else
				lnRetVal = 0
			Endif

			If This.oConnection > 0
				SQLSetprop( This.oConnection , 'DispLogin', 3)
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
		Local i As Integer
		Local oErr As Exception
		
		llRetVal = .T.

		For i = 1 To 10


			Try
				llRetVal = SQLDisconnect( This.oConnection ) = 1
				This.oConnection = 0
				Exit 

			Catch To oErr When oErr.ErrorNo = 1541
				*!*	Connection "name" is busy
				*!*	This remote connection is in use by another executing statement.
				*!*	Wait until it completes or cancel it before retrying this operation.
				Inkey(1)

			Catch To oErr
				llRetVal = .F.
				Exit


			Finally

			Endtry
		Endfor

		Return llRetVal

	Endfunc
	*!*
	*!* END FUNCTION Disconnect
	*!*
	*!* ///////////////////////////////////////////////////////



	Procedure GetNewID( tcTable As String ) As Integer
		Local lnRetVal As Integer
		Local lcAlias As String

		* SQL-Server devuelve un RecordSet con el dato del nuevo ID

		lcAlias = Sys(2015)
		SQLExec( This.oConnection,;
			"SELECT IDENT_CURRENT( '" + tcTable + "' )",;
			lcAlias )

		If Used(lcAlias)
			Select Alias(lcAlias)
			= Afields( laField, tcAlias )
			lnRetVal = Evaluate(laField[1])
			Use In Alias(lcAlias)
		Endif

		Return lnRetVal

	Endproc
	*!*
	*!* END PROCEDURE GetNewId
	*!*
	*!* ///////////////////////////////////////////////////////

	Procedure BeginTransaction(  ) As Boolean;
			HELPSTRING "Comienza una Transacción"

		Local lnResult As Integer

		Try

			lnResult = SQLSetprop( This.oConnection, "Transactions", 2 )

		Catch To oErr
			lnResult = -1

		Finally

		Endtry

		Return lnResult = 1
	Endproc
	*!*
	*!* END PROCEDURE BeginTransaction
	*!*
	*!* ///////////////////////////////////////////////////////

	Procedure EndTransaction(  ) As Void;
			HELPSTRING "Finaliza una Transacción"

		Local lnResult As Integer

		Try

			lnResult = Sqlcommit(This.oConnection)
			If lnResult = 1
				lnResult = SQLSetprop( This.oConnection, "Transactions", 1 )
			Endif

		Catch To oErr
			lnResult = -1

		Finally

		Endtry

		Return lnResult = 1

	Endproc
	*!*
	*!* END PROCEDURE EndTransaction
	*!*
	*!* ///////////////////////////////////////////////////////

	Procedure Rollback(  ) As Boolean;
			HELPSTRING "Hace un RollBack"

		Local lnResult As Integer

		Try
			lnResult = Sqlrollback(This.oConnection)
			If lnResult = 1
				lnResult = SQLSetprop( This.oConnection, "Transactions", 1 )
			Endif

		Catch To oErr
			lnResult = -1

		Finally

		Endtry

		Return lnResult = 1

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

		Local llOk As Boolean

		Try

			llOk = SQLExec( This.oConnection, cSQLCommand ) > 0

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
*!* Class.........: ODBCBackEnd
*!*
*!* ///////////////////////////////////////////////////////