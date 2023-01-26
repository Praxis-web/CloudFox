#INCLUDE "FW\TierAdapter\Include\TA.h"

Local lcCommand As String

Try

	lcCommand = ""

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Remark = lcCommand
	loError.Process( oErr )


Finally


Endtry

*!* ///////////////////////////////////////////////////////
*!* Class.........: Transaction
*!* ParentClass...: prxEntity Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxentity.prg'
*!* BaseClass.....: Session
*!* Description...:
*!* Date..........: Sábado 13 de Octubre de 2012 (13:37:30)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class Transaction As prxEntity Of 'Fw\Tieradapter\Comun\Prxentity.prg'

	#If .F.
		Local This As Transaction Of "ERP\Comunes\Sistema\Prg\Transaction.prg"
	#Endif

	cMainTableName 	= "sys_Transactions"
	cMainCursorName = "cTransaction"

	* Tipo de Transaccion
	nAction = 0

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="naction" type="property" display="nAction" />] + ;
		[<memberdata name="opentransaction" type="method" display="OpenTransaction" />] + ;
		[<memberdata name="closetransaction" type="method" display="CloseTransaction" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Function......: Initialize
	*!* Description...: Verifica que exista al menos una Transaction
	*!* Date..........: Domingo 30 de Septiembre de 2012 (10:47:21)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Clipper2Fox
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Initialize( uParam As Variant ) As Boolean

		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Remark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry


	Endfunc
	*!*
	*!* END FUNCTION Initialize
	*!*
	*!* ///////////////////////////////////////////////////////



	*
	* Abre una transacción
	Procedure OpenTransaction(  ) As Void;
			HELPSTRING "Abre una transacción"
		Local lcCommand As String,;
			lcNetInfo As String,;
			lcWinUser As String,;
			lcTerminal As String

		Local lnUserId As Integer

		Try

			lcCommand 	= ""
			lnUserId 	= 0

			If Pemstatus( _Screen, "oApp", 5 )
				lnUserId = _Screen.oApp.Userid
			Endif

			This.New()

			lcWinUser 	= Proper( Getenv("USERNAME") )
			lcTerminal 	= Proper( Getenv("COMPUTERNAME") )

			If Empty( lcWinUser ) Or Empty( lcTerminal )
				lcNetInfo 	= Sys( 0 )
				lcTerminal 	= Proper( Substr( lcNetInfo, 1, At( "#", lcNetInfo ) - 1 ) )
				lcWinUser 	= Proper( Substr( lcNetInfo, At( "#", lcNetInfo ) + 1 ) )
			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Replace All
				Status				With -1,
				Terminal			With lcTerminal,
				WinUser				With lcWinUser,
				TransactionBegin 	With Datetime(),
				TransactionEnd 		With Datetime(),
				UserId 				With lnUserId
			In <<This.cMainCursorName>>
			ENDTEXT

			&lcCommand

			This.Crear()
			This.TransactionId = This.nEntidadId

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Remark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Use In Select( This.cMainCursorName )

		Endtry

	Endproc && OpenTransaction



	*
	* Cierra la transacción
	Procedure CloseTransaction(  ) As Void;
			HELPSTRING "Cierra la transacción"
		Local lcCommand As String

		Try

			lcCommand = ""

			This.GetOne( This.TransactionId )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Replace 
				Status				With <<This.nAction>>,
				TransactionEnd 		With Datetime()
			In <<This.cMainCursorName>>
			ENDTEXT

			&lcCommand
			
			This.Guardar()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Remark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && CloseTransaction

	*
	* oDataTier_Access
	Protected Procedure oDataTier_Access()
		Local lcCommand As String
		Local loDT As PrxDataTier Of "V:\Clipper2fox\Fw\Tieradapter\Comun\Prxdatatier.prg"

		Try

			lcCommand = ""

			loDT = Newobject( "dtTransaction", "Erp\Comunes\Sistema\Prg\Transaction.prg" )

			* Pasar parámetros
			loDT.nEntidadId 		= This.nEntidadId
			loDT.cPKField 			= This.cPKField
			loDT.cMainCursorName 	= This.cMainCursorName
			loDT.cMainTableName 	= This.cMainTableName
			loDT.oColTables 		= This.oColTables

			This.oDataTier = loDT

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Remark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loDT = Null

		Endtry

		Return This.oDataTier

	Endproc && oDataTier_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Transaction
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: dtTransaction
*!* ParentClass...: PrxDataTier Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxdatatier.prg'
*!* BaseClass.....: Session
*!* Description...: Capa de Acceso a Datos
*!* Date..........: Jueves 25 de Octubre de 2012 (18:43:49)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class dtTransaction As PrxDataTier Of 'Fw\Tieradapter\Comun\Prxdatatier.prg'

	#If .F.
		Local This As dtTransaction Of "Erp\Comunes\Sistema\Prg\Transaction.prg"
	#Endif

	lUseDBC = .T.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*
	*
	Procedure Put( nEntidadId As Integer ) As Void
		Local lcCommand As String,;
			lcDiffgram As String

		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .T.


			This.CrearCursorAdapters()

			* Ahora si, abro la transacción y ejecuto TableUpdate
			This.ConnectToBackend()
			This.TransactionBegin()

			loColTables = This.oColTables

			llOk = .T.

			For Each loTable In loColTables
				If llOk
					Select Alias( loTable.CursorName )

					If !Tableupdate( .T., .T. )
						llOk = .F.

					Else
						If loTable.Nivel = 1
							This.nEntidadId = This.GetNewId( loTable.Name, loTable.PKName )
						Endif
					Endif
				Endif
			Endfor

			If llOk
				This.TransactionEnd()

			Else
				Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
				loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Remark = "Tableupdate Falló"
				loError.Process()
				Throw loError

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			Try
				Do While !Empty( Txnlevel())
					This.TransactionRollBack()
				Enddo

			Catch

			Finally


			Endtry


			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Remark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			This.DisconnectFromBackend()
			loTable = Null
			loColTables = Null

		Endtry

	Endproc && Put

Enddefine
*!*
*!* END DEFINE
*!* Class.........: dtTransaction
*!*
*!* ///////////////////////////////////////////////////////