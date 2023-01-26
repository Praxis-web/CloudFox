#INCLUDE "FW\Comunes\Include\Praxis.h"

#Define FieldName		1
#Define FieldType		2
#Define FieldWidth		3
#Define FieldDecimal	4
#Define FieldNull		5
#Define FieldCPTrans	6
#Define FieldDefault	9

Local loTH As TransactionHandle Of "Fw\Tieradapter\Comun\prxTransactions.prg"

Try

	Close Databases All
	drcomun = "S:\Fenix\DatosFH\Comun"
	* loTH = Newobject( "TransactionHandle", "V:\Clipper2fox\Fw\Tieradapter\Comun\prxTransactions.prg" )

	*!*		loTH = NewTH()
	*!*		*loTH.cLoginTableFolder = "S:\Fenix\DatosFH\Comun"

	*!*		WNEXA = Int(Seconds())

	*!*		loTH.LogTransaction( WNEXA, "Ingreso de Cobranzas", "Recibo 0001-00036980" )
	*!*		loTH.ShowTransaction( WNEXA )

	Use "s:\Fenix\Dbf\Dbf\AR10VAL.DBF" Share In 0

	Select ar10val

	Messagebox( Vartype( Comp10 ) )
	Messagebox( Vartype( TranId ) )
	Messagebox( Vartype( Tipo10 ) )

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )


Finally
	Close Databases All

Endtry


*!* ///////////////////////////////////////////////////////
*!* Class.........: TransactionHandle
*!* ParentClass...: prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....: Custom
*!* Description...: Manejo de Transacciones
*!* Date..........: Jueves 12 de Enero de 2012 (17:05:36)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class TransactionHandle As prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'

	#If .F.
		Local This As TransactionHandle Of "Fw\Tieradapter\Comun\prxTransactions.prg"
	#Endif

	* Carpeta donde se encuentra la tabla de Login
	cLoginTableFolder = ""

	* Nombre de la tabla donde se guardan las transacciones
	cLoginTableName = "LogTransactions"

	*
	nTransactionId = 0

	* Indica si la operacion es Alta, Baja o Modificacion
	cABM = "A"

	* Indica la tabla principal, sobre la que debe leerse el campo TranId
	cMainTable = ""

	* Indica la Fecha Contable
	dContable = Date()

	nNexa 		= 0
	cEquipo 	= ""
	cWinUser 	= ""
	cUsuario 	= ""
	nUserId 	= 0
	tDateTime 	= Datetime()
	nParentId 	= 0
	nNivel 		= 0

	* Tablas que forman parte de la transaccion
	oColTables = Null

	* Indica si la transacción esta abierta y activa
	lIsOpen = .F.

	* Comienzo de la transacción
	nSeconds = 0

	* Indica si muestra o no mensajes
	lSilence = .F.

	*
	cProceso = ""
	*
	cReferencia = ""
	*
	cMetodo = ""

	* Loguea los tiempos de cada transacción para debugging
	cDebugLog = ""

	* Se inicializa con arParame -> lLogTH = .T.
	* Si no existe es .F.
	lDebugLog = .F.


	* Se inicializa con arParame -> nLogTH = 2
	* Si no existe es 5 Segundos
	nDebugLog = 5

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="creferencia" type="property" display="cReferencia" />] + ;
		[<memberdata name="cproceso" type="property" display="cProceso" />] + ;
		[<memberdata name="lsilence" type="property" display="lSilence" />] + ;
		[<memberdata name="nseconds" type="property" display="nSeconds" />] + ;
		[<memberdata name="nparentid" type="property" display="nParentId" />] + ;
		[<memberdata name="lisopen" type="property" display="lIsOpen" />] + ;
		[<memberdata name="dcontable" type="property" display="dContable" />] + ;
		[<memberdata name="cmaintable" type="property" display="cMainTable" />] + ;
		[<memberdata name="cabm" type="property" display="cABM" />] + ;
		[<memberdata name="tdatetime" type="property" display="tDateTime" />] + ;
		[<memberdata name="logtransaction" type="method" display="LogTransaction" />] + ;
		[<memberdata name="clogintablename" type="property" display="cLoginTableName" />] + ;
		[<memberdata name="clogintablefolder" type="property" display="cLoginTableFolder" />] + ;
		[<memberdata name="createlogintable" type="method" display="CreateLoginTable" />] + ;
		[<memberdata name="equipo" type="method" display="Equipo" />] + ;
		[<memberdata name="usuario" type="method" display="Usuario" />] + ;
		[<memberdata name="winuser" type="method" display="WinUser" />] + ;
		[<memberdata name="showtransaction" type="method" display="ShowTransaction" />] + ;
		[<memberdata name="savetransactionid" type="method" display="SaveTransactionId" />] + ;
		[<memberdata name="ntransactionid" type="property" display="nTransactionId" />] + ;
		[<memberdata name="readtransactionid" type="method" display="ReadTransactionId" />] + ;
		[<memberdata name="alterlogintable" type="method" display="AlterLoginTable" />] + ;
		[<memberdata name="setabm" type="method" display="SetABM" />] + ;
		[<memberdata name="nuserid" type="property" display="nUserId" />] + ;
		[<memberdata name="cusuario" type="property" display="cUsuario" />] + ;
		[<memberdata name="cwinuser" type="property" display="cWinUser" />] + ;
		[<memberdata name="cequipo" type="property" display="cEquipo" />] + ;
		[<memberdata name="nnivel" type="property" display="nNivel" />] + ;
		[<memberdata name="nnexa" type="property" display="nNexa" />] + ;
		[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
		[<memberdata name="opentransaction" type="method" display="OpenTransaction" />] + ;
		[<memberdata name="closetransaction" type="method" display="CloseTransaction" />] + ;
		[<memberdata name="savenewid" type="method" display="SaveNewId" />] + ;
		[<memberdata name="showmessage" type="method" display="ShowMessage" />] + ;
		[<memberdata name="updatetransaction" type="method" display="UpdateTransaction" />] + ;
		[<memberdata name="cmetodo" type="property" display="cMetodo" />] + ;
		[<memberdata name="cdebuglog" type="property" display="cDebugLog" />] + ;
		[<memberdata name="ldebuglog" type="property" display="lDebugLog" />] + ;
		[<memberdata name="ndebuglog" type="property" display="nDebugLog" />] + ;
		[<memberdata name="debuglog" type="method" display="DebugLog" />] + ;
		[</VFPData>]

	*
	* Muestra lo que está haciendo
	Procedure ShowMessage(  ) As Void;
			HELPSTRING "Muestra lo que está haciendo"
		Local lcCommand As String,;
			lcMsg As String

		Try

			lcCommand = ""
			If !This.lSilence
				TEXT To lcMsg NoShow TextMerge Pretext 03
				<<This.cProceso>>
				<<This.cReferencia>>

				Un momento, por favor ....
				ENDTEXT

				Wait Window Nowait Noclear lcMsg

			Else
				Wait Clear

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && ShowMessage


	*
	* Adjudica el siguiente Id a la tabla
	Procedure SaveNewId( cTableName As String,;
			cFieldName As String,;
			nStep As Integer,;
			cForClause As String ) As Integer;
			HELPSTRING "Adjudica el siguiente Id a la tabla"

		Local lcCommand As String
		Local lnId As Integer
		Local loTable As Object
		Local loTables As oTables Of "Fw\Tieradapter\Comun\prxTransactions.prg"

		Try

			lcCommand = ""

			If Empty( cTableName )
				cTableName = Alias()
			Endif

			If Empty( cFieldName )
				cFieldName = "Id"
			Endif

			If Empty( nStep ) Or Vartype( nStep ) # "N"
				nStep = 1
			Endif

			loTables = This.oColTables
			loTable = loTables.New( cTableName )

			If !Pemstatus( loTable, cFieldName, 5 )
				AddProperty( loTable, cFieldName, GetMaxId( cTableName, cFieldName, cForClause ) )
			Endif

			lnId = Evaluate( "loTable." + cFieldName ) + nStep

			Try

				Go Bottom In ( cTableName )

			Catch To oErr

			Finally

			Endtry



			Try

				If Seek( lnId, cTableName, cFieldName )
					lnId = GetMaxId( cTableName, cFieldName, cForClause ) + nStep
				Endif

			Catch To oErr

				If Inlist( oErr.ErrorNo, 26, 1683 ) && No se encuentra la etiqueta de índice

					lnId = GetMaxId( cTableName, cFieldName, cForClause ) + nStep

				Endif

			Finally

			Endtry

			loTable.&cFieldName = lnId

			If This.lDebugLog
				This.DebugLog( .F., cTableName, cFieldName, lnId )
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lnId

	Endproc && SaveNewId



	*
	* Abre una transacción nueva
	Procedure OpenTransaction( ) As Void;
			HELPSTRING "Abre una transacción nueva"
		Local lcCommand As String,;
			lcAlias As String,;
			lcMsg As String

		Try

			lcCommand = ""
			lcAlias = Alias()

			This.CloseTransaction( .T. )

			This.oColTables = Createobject( "oTables" )
			This.lIsOpen 	= .T.
			This.tDateTime 	= Datetime()
			This.dContable 	= Date()

			This.ShowMessage()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

	Endproc && OpenTransaction



	*
	* Cierra la transacción actual
	Procedure CloseTransaction( lBeforeOpen As Boolean ) As Void;
			HELPSTRING "Cierra la transacción actual"
		Local lcCommand As String,;
			lcAlias As String

		Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"

		Try


			lcCommand = ""
			lcAlias = Alias()

			If !lBeforeOpen  And !Empty( This.nSeconds )
				If !Used( This.cLoginTableName )
					M_Use( 0, Addbs( This.cLoginTableFolder ) + This.cLoginTableName )
				Endif

				Try
					If Seek( This.nTransactionId, This.cLoginTableName, "TranId" )

						Select Alias( This.cLoginTableName )
						M_IniAct( 52 )
						Replace Duracion With Seconds() - This.nSeconds
						Unlock

						If This.lDebugLog And Duracion > This.nDebugLog
							This.DebugLog( .T. )
						Endif

					Endif

				Catch To oErr
					If oErr.ErrorNo = 1683 && No se encuentra la etiqueta de índice
						Use In Select( This.cLoginTableName )
						M_Use( 0, Addbs( This.cLoginTableFolder ) + This.cLoginTableName, 0, .T. )

						Index On TranId Tag TranId Candidate For !Deleted()
						Index On Nexa Tag Nexa
						Index On ParentId Tag ParentId

						If Seek( This.nTransactionId, This.cLoginTableName, "TranId" )

							Select Alias( This.cLoginTableName )
							*M_IniAct( 52 )
							Replace Duracion With Seconds() - This.nSeconds
							*Unlock

							If This.lDebugLog And Duracion > This.nDebugLog
								This.DebugLog( .T. )
							Endif

						Endif

					Endif

				Finally

				Endtry

			Endif

			If !lBeforeOpen
				Use In Select( This.cLoginTableName )
			Endif

			This.nSeconds 		= 0
			This.nNexa 			= 0
			This.cEquipo 		= ""
			This.cWinUser 		= ""
			This.cUsuario 		= ""
			This.nUserId 		= 0
			This.nNivel 		= 0
			This.cABM 			= "A"
			This.nParentId 		= 0
			This.nTransactionId = 0
			This.cDebugLog  	= ""

			This.cProceso 		= ""
			This.cReferencia 	= ""

			This.oColTables 	= Null

			This.lIsOpen 		= .F.

			If !lBeforeOpen
				loUser =  NewUser()
				loUser.oAutorizador = Null
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Wait Clear
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif
			loUser = Null

		Endtry

	Endproc && CloseTransaction



	*
	* Muestra los datos de la transacción
	Procedure ShowTransaction( tnTranId As Integer,;
			tnNexa As Number ) As Void;
			HELPSTRING "Muestra los datos de la transacción"

		Local lnId As Integer
		Local lcCommand As String,;
			lcAlias As String,;
			lcProceso As String,;
			lcCentury As String,;
			lcWhere As String,;
			lcTranIdList As String

		Local lnNexa As Number
		Local lnTranId As Integer,;
			i As Integer

		Local loColFields As Collection
		Local loColPictures As Collection
		Local loColHeaders As Collection

		Local loParametros As Object
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'



		Try

			lcCentury = Set("Century")

			lcCommand = ""

			lcAlias = Alias()

			lcProceso = Program()

			If !Inlist( Vartype( tnNexa ), "N", "I" )
				tnNexa = 0
			Endif

			lnNexa = Cast( tnNexa As N(10) )

			If !Inlist( Vartype( tnTranId ), "N", "I" )
				tnTranId = 0
			Endif

			lnTranId = Cast( tnTranId As i )

			If Empty( lnTranId )

				Try

					* Obtener lista de TranId para traer varias transacciones relacionadas

					If Empty( This.cMainTable )
						This.cMainTable = lcAlias
					Endif

					lcTranIdList = ""
					For i = 1 To Getwordcount( This.cMainTable, "," )
						lnTranId = Evaluate( Alltrim( Getwordnum( This.cMainTable, i, "," )) + ".TranId" )

						If i > 1
							lcTranIdList = lcTranIdList + ","
						Endif

						lcTranIdList = lcTranIdList + Transform( lnTranId )

					Endfor


				Catch To oErr
					lnTranId = 0

					If i > 1
						lcTranIdList = lcTranIdList + ","
					Endif

					lcTranIdList = lcTranIdList + Transform( lnTranId )

				Finally

				Endtry

			Else
				lcTranIdList = Transform( lnTranId )

			Endif

			If !Used( This.cLoginTableName )

				Try

					*!*						TEXT To lcCommand NoShow TextMerge Pretext 15
					*!*						Use "<<Addbs( This.cLoginTableFolder )>><<This.cLoginTableName>>" Shared In 0
					*!*						ENDTEXT

					*!*						&lcCommand

					M_Use( 0, Addbs( This.cLoginTableFolder ) + This.cLoginTableName )


				Catch To oErr
					Do Case
						Case oErr.ErrorNo = 1
							Warning( "No existe la tabla de Transacciones" )

						Otherwise
							loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
							loError.Process( oErr )
							Throw loError

					Endcase



				Finally

				Endtry

			Endif

			If Used( This.cLoginTableName )

				* Armar la condicion Where

				If !Empty( lnNexa )
					TEXT To lcWhere NoShow TextMerge Pretext 15
					Nexa = <<lnNexa>>
					ENDTEXT

				Else
					TEXT To lcWhere NoShow TextMerge Pretext 15
					TranId In ( <<lcTranIdList>> )
					ENDTEXT

				Endif

				Select Alias( This.cLoginTableName )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Select *
					From <<This.cLoginTableName>>
					Where <<lcWhere>>
					Into Cursor cTransaccion
				ENDTEXT

				&lcCommand

				If !Empty( _Tally )
					loColFields 	= Createobject( "Collection" )
					loColPictures 	= Createobject( "Collection" )
					loColHeaders 	= Createobject( "Collection" )
					loParametros 	= Createobject( "Empty" )

					AddProperty( loParametros, "Caption", "Información de Usuario" )
					AddProperty( loParametros, "Icon", "fw\Comunes\Image\ico\User.ico" )

					loColFields.Add( 'Equipo' )
					loColPictures.Add( Repl('X',15) )
					loColHeaders.Add( 'Terminal' )

					loColFields.Add( 'WinUser' )
					loColPictures.Add( Repl('X',15) )
					loColHeaders.Add( 'Usuario Windows' )

					loColFields.Add( 'Usuario' )
					loColPictures.Add( Repl('X',15) )
					loColHeaders.Add( 'Usuario Fenix' )

					loColFields.Add( 'Proceso' )
					loColPictures.Add( Repl('X',30) )
					loColHeaders.Add( 'Proceso' )

					loColFields.Add( 'Referencia' )
					loColPictures.Add( Repl('X',50) )
					loColHeaders.Add( 'Referencia' )

					loColFields.Add( 'Transform( TS )' )
					loColPictures.Add( Repl('X',20) )
					loColHeaders.Add( 'Fecha y Hora' )


					Set Century On

					CallSelector( loColFields,;
						loColPictures,;
						loColHeaders,;
						loParametros )

				Else
					Inform( "No se encontro informacion", "Información de Usuario" )

				Endif


			Endif


		Catch To loErr
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			Set Century &lcCentury
			Use In Select( This.cLoginTableName )
			Use In Select( "cTransaccion" )

			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

	Endproc && ShowTransaction

	*
	* Nombre del Usuario de Windows
	Procedure WinUser(  ) As String;
			HELPSTRING "Nombre del Usuario de Windows"

		Return Alltrim( Getwordnum( Sys(0), 2, "#" ))

	Endproc && WinUser

	*
	* Nombre del Usuario de Fenix
	Procedure Usuario(  ) As String

		Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"

		Try

			loUser = NewUser()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loUser

	Endproc && Usuario

	*
	* Nombre del equipo de procesamiento
	Procedure Equipo(  ) As String;
			HELPSTRING "Nombre del equipo de procesamiento"

		Return Alltrim( Getwordnum( Sys(0), 1, "#" ))

	Endproc && Equipo


	*
	* Crea la tabla de Login
	Procedure CreateLoginTable(  ) As Void;
			HELPSTRING "Crea la tabla de Login"

		Local lcCommand As String

		Try

			lcCommand = ""

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Table "<<Addbs( This.cLoginTableFolder )>><<This.cLoginTableName>>" Free (
				TranId I,
				Nexa N(10,0),
				Equipo C(50),
				WinUser C(50),
				Usuario C(50),
				UserId I,
				Nivel I,
				Proceso C(200),
				Referencia C(200),
				Modulo C(30),
				Programa C(30),
				Metodo C(30),
				TS T,
				CONTABLE D,
				Abm C(1),
				ParentId I,
				Duracion N(12,3),
				Autorizado C(50),
				AutorizaId I )
			ENDTEXT

			&lcCommand

			Index On TranId Tag TranId Candidate For !Deleted()
			Index On Nexa Tag Nexa
			Index On ParentId Tag ParentId

			Use In ( This.cLoginTableName )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally

		Endtry

	Endproc && CreateLoginTable




	*
	* Modifica la estructura existente
	Procedure AlterLoginTable(  ) As Void;
			HELPSTRING "Modifica la estructura existente"
		Local lcCommand As String,;
			lcField  As String

		Local lnLen As Integer,;
			lnLenAux As Integer,;
			i As Integer,;
			j As Integer

		Local Array laFieldsAux[ 1 ]
		Local Array laFields[ 1 ]

		Try

			lcCommand = ""

			Select Alias( This.cLoginTableName )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Use "<<Addbs( This.cLoginTableFolder )>><<This.cLoginTableName>>" Exclusive
			ENDTEXT

			&lcCommand

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Cursor cLoginTable (
				TranId I,
				Nexa N(10,0),
				Equipo C(50),
				WinUser C(50),
				Usuario C(50),
				UserId I,
				Nivel I,
				Proceso C(200),
				Referencia C(200),
				Modulo C(30),
				Programa C(30),
				Metodo C(30),
				TS T,
				CONTABLE D,
				Abm C(1),
				ParentId I,
				Duracion N(12,3),
				Autorizado C(50),
				AutorizaId I )
			ENDTEXT

			&lcCommand


			lnLenAux = Afields( laFieldsAux, "cLoginTable" )
			lnLen = Afields( laFields, This.cLoginTableName )

			For j = 1 To lnLenAux
				i = Ascan( laFields, laFieldsAux[ j, 1 ], 1, lnLen, 1, 9 )

				If Empty( i )
					lcField = GetFieldStructure( ;
						laFieldsAux[ j, FieldName ],;
						laFieldsAux[ j, FieldType ],;
						laFieldsAux[ j, FieldWidth ],;
						laFieldsAux[ j, FieldDecimal ],;
						laFieldsAux[ j, FieldNull ],;
						laFieldsAux[ j, FieldCPTrans ],;
						laFieldsAux[ j, FieldDefault ] )

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Alter Table '<<This.cLoginTableName>>'
						Add Column <<lcField>>
					ENDTEXT

					&lcCommand

				Endif

			Endfor


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			Use In Select( "cLoginTable" )

		Endtry

	Endproc && AlterLoginTable



	*
	* Graba los datos de quien efectuó la transaction
	Procedure LogTransaction( tnNexa As Number,;
			tcProceso As String,;
			tcReferencia As String,;
			tcABM As Character,;
			tnParentId As Integer ) As Void;
			HELPSTRING "Graba los datos de quie efectuó la transaction"

		Local lnId As Integer,;
			lnAutorizaId As Integer

		Local lcCommand As String,;
			lcAlias As String,;
			lcProceso As String,;
			lcModulo As String,;
			lcPrograma As String,;
			lcMetodo As String,;
			lcAutorizado As String

		Local lnNexa As Number
		Local ldFechaContable As Date
		Local ltDateTime As Datetime

		Local loUsuario As User Of "Fw\TierAdapter\Comun\prxUser.prg"
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
		Local loErrAux As Exception

		Local llClose As Boolean

		Try

			lcCommand = ""
			llClose = .F.

			This.nSeconds = Seconds()

			loGlobalSettings = NewGlobalSettings()

			*!*				This.OpenTransaction()

			lcAlias = Alias()

			* Nombre del Modulo
			lcModulo 	= loGlobalSettings.oTransactionLog.Modulo

			* El programa ejecutado generalmente se encuentra en la posicion 6 del stack
			lcPrograma 	= Program( Iif( Program( -1 ) > 6, 6, 1 ))

			* Metodo desde el que se llamó a LogTransaction()
			lcMetodo 	= Program( Program( -1 ) - 1 )
			This.cMetodo = lcMetodo

			loUsuario = NewUser()

			lcAutorizado = ""
			lnAutorizaId = 0

			If !Isnull( loUsuario.oAutorizador )
				lcAutorizado = loUsuario.oAutorizador.Nombre
				lnAutorizaId = loUsuario.oAutorizador.Id
			Endif

			If Empty( tcProceso )
				tcProceso = This.cProceso
			Endif

			If Empty( tcReferencia )
				tcReferencia = This.cReferencia
			Endif

			This.cProceso 		= tcProceso
			This.cReferencia 	= tcReferencia

			If Empty( tcABM )
				tcABM = This.cABM
			Endif

			If !Inlist( Vartype( tnNexa ), "N", "I" )
				tnNexa = 0
			Endif

			If Empty( tnParentId )
				tnParentId = This.nParentId
			Endif

			ldFechaContable = This.dContable
			ltDateTime 		= This.tDateTime

			lnNexa = Cast( tnNexa As N(10) )

			If !Used( This.cLoginTableName )

				llClose = .T.

				Try

					M_Use( 0, Addbs( This.cLoginTableFolder ) + This.cLoginTableName )

				Catch To oErr

					loErrAux = oErr
					Do While Vartype( loErrAux.UserValue ) = "O"
						loErrAux = loErrAux.UserValue
					Enddo

					If Inlist( loErrAux.ErrorNo, 1, 1707 )
						oErr = loErrAux
					Endif

					Do Case
						Case oErr.ErrorNo = 1
							This.CreateLoginTable()

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Use "<<Addbs( This.cLoginTableFolder )>><<This.cLoginTableName>>" Shared In 0
							ENDTEXT

							&lcCommand

						Case oErr.ErrorNo = 1707 && The structural index file associated with a table file could not be found
							TEXT To lcCommand NoShow TextMerge Pretext 15
							Use "<<Addbs( This.cLoginTableFolder )>><<This.cLoginTableName>>" Exclusive In 0
							ENDTEXT

							&lcCommand
							Select Alias( This.cLoginTableName )

							Index On TranId Tag TranId Candidate For !Deleted()
							Index On Nexa Tag Nexa
							Index On ParentId Tag ParentId

							Use In ( This.cLoginTableName )

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Use "<<Addbs( This.cLoginTableFolder )>><<This.cLoginTableName>>" Shared In 0
							ENDTEXT

							&lcCommand


						Otherwise
							loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
							loError.Process ( m.oErr )
							Throw loError


					Endcase

				Finally

				Endtry

			Endif

			Select Alias( This.cLoginTableName )
			Set Order To Tag TranId
			M_IniAct( 3 )

			Go Bottom

			Do While !Bof() And Empty( Evaluate( This.cLoginTableName + ".TranId" ) )
				Try

					Delete
					Skip -1

				Catch To oErr
					Go Bottom

				Finally

				Endtry

			Enddo

			lnId = Evaluate( This.cLoginTableName + ".TranId" ) + 1

			This.nTransactionId = lnId

			This.nNexa 		= tnNexa
			This.cEquipo 	= loGlobalSettings.oTransactionLog.Equipo
			This.cWinUser 	= loGlobalSettings.oTransactionLog.WinUser
			This.cUsuario 	= loGlobalSettings.oTransactionLog.Usuario
			This.nUserId 	= loGlobalSettings.oTransactionLog.Userid
			This.nNivel 	= loGlobalSettings.oTransactionLog.Nivel

			Try

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Insert Into <<This.cLoginTableName>> (
					TranId,
					Nexa,
					Equipo,
					WinUser,
					Usuario,
					UserId,
					Nivel,
					Proceso,
					Referencia,
					Modulo,
					Programa,
					Metodo,
					TS,
					Contable,
					Abm,
					ParentId,
					Duracion,
					Autorizado,
					AutorizaId ) Values (
					lnId,
					tnNexa,
					This.cEquipo,
					This.cWinUser,
					This.cUsuario,
					This.nUserId,
					loUsuario.Clave,
					tcProceso,
					tcReferencia,
					lcModulo,
					lcPrograma,
					lcMetodo,
					ltDateTime,
					ldFechaContable,
					tcABM,
					tnParentId,
					0,
					lcAutorizado,
					lnAutorizaId  )
				ENDTEXT

				&lcCommand

			Catch To oErr
				Do Case
					Case oErr.ErrorNo = 12  && The specified variable or field name could not be found.
						This.AlterLoginTable()

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Insert Into <<This.cLoginTableName>> (
							TranId,
							Nexa,
							Equipo,
							WinUser,
							Usuario,
							UserId,
							Nivel,
							Proceso,
							Referencia,
							Modulo,
							Programa,
							Metodo,
							TS,
							Contable,
							Abm,
							ParentId,
							Duracion,
							Autorizado,
							AutorizaId  ) Values (
							lnId,
							tnNexa,
							This.cEquipo,
							This.cWinUser,
							This.cUsuario,
							This.nUserId,
							loUsuario.Clave,
							tcProceso,
							tcReferencia,
							lcModulo,
							lcPrograma,
							lcMetodo,
							ltDatetime,
							ldFechaContable,
							tcABM,
							tnParentId,
							0,
							lcAutorizado,
							lnAutorizaId  )
						ENDTEXT

						&lcCommand

					Otherwise
						loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
						loError.cRemark = lcCommand
						loError.Process ( m.oErr )
						Throw loError

				Endcase

			Finally

			Endtry

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			If llClose
				Use In Select( This.cLoginTableName )
			Endif

			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

		Return lnId

	Endproc && LogTransaction


	*
	* Graba los datos de quien efectuó la transaction
	Procedure xxxLogTransaction( tnNexa As Number,;
			tcProceso As String,;
			tcReferencia As String,;
			tcABM As Character,;
			tnParentId As Integer ) As Void;
			HELPSTRING "Graba los datos de quie efectuó la transaction"

		Local lnId As Integer,;
			lnAutorizaId As Integer

		Local lcCommand As String,;
			lcAlias As String,;
			lcProceso As String,;
			lcModulo As String,;
			lcPrograma As String,;
			lcMetodo As String,;
			lcAutorizado As String

		Local lnNexa As Number
		Local ldFechaContable As Date
		Local ltDateTime As Datetime

		Local loUsuario As User Of "Fw\TierAdapter\Comun\prxUser.prg"
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"


		Try

			lcCommand = ""
			This.nSeconds = Seconds()

			*!*				This.OpenTransaction()

			lcAlias = Alias()

			* Nombre del Modulo
			lcModulo 	= Program( 1 )

			* El programa ejecutado generalmente se encuentra en la posicion 6 del stack
			lcPrograma 	= Program( Iif( Program( -1 ) > 6, 6, 1 ))

			* Metodo desde el que se llamó a LogTransaction()
			lcMetodo 	= Program( Program( -1 ) - 1 )
			This.cMetodo = lcMetodo

			loUsuario = This.Usuario()

			lcAutorizado = ""
			lnAutorizaId = 0

			If !Isnull( loUsuario.oAutorizador )
				lcAutorizado = loUsuario.oAutorizador.Nombre
				lnAutorizaId = loUsuario.oAutorizador.Id
			Endif

			If Empty( tcProceso )
				tcProceso = This.cProceso
			Endif

			If Empty( tcReferencia )
				tcReferencia = This.cReferencia
			Endif

			This.cProceso 		= tcProceso
			This.cReferencia 	= tcReferencia

			If Empty( tcABM )
				tcABM = This.cABM
			Endif

			If !Inlist( Vartype( tnNexa ), "N", "I" )
				tnNexa = 0
			Endif

			If Empty( tnParentId )
				tnParentId = This.nParentId
			Endif

			ldFechaContable = This.dContable
			ltDateTime 		= This.tDateTime

			lnNexa = Cast( tnNexa As N(10) )


			If !Used( This.cLoginTableName )

				Try

					M_Use( 0, Addbs( This.cLoginTableFolder ) + This.cLoginTableName )

				Catch To oErr

					Do Case
						Case oErr.ErrorNo = 1
							This.CreateLoginTable()

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Use "<<Addbs( This.cLoginTableFolder )>><<This.cLoginTableName>>" Shared In 0
							ENDTEXT

							&lcCommand

						Case oErr.ErrorNo = 1707 && The structural index file associated with a table file could not be found
							TEXT To lcCommand NoShow TextMerge Pretext 15
							Use "<<Addbs( This.cLoginTableFolder )>><<This.cLoginTableName>>" Exclusive In 0
							ENDTEXT

							&lcCommand
							Select Alias( This.cLoginTableName )

							Index On TranId Tag TranId Candidate For !Deleted()
							Index On Nexa Tag Nexa
							Index On ParentId Tag ParentId

							Use In ( This.cLoginTableName )

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Use "<<Addbs( This.cLoginTableFolder )>><<This.cLoginTableName>>" Shared In 0
							ENDTEXT

							&lcCommand


						Otherwise
							loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
							loError.Process ( m.oErr )
							Throw loError


					Endcase

				Finally

				Endtry

			Endif

			Select Alias( This.cLoginTableName )
			M_IniAct( 3 )

			Go Bottom

			lnId = Evaluate( This.cLoginTableName + ".TranId" ) + 1

			This.nTransactionId = lnId

			This.nNexa 		= tnNexa
			This.cEquipo 	= This.Equipo()
			This.cWinUser 	= This.WinUser()
			This.cUsuario 	= loUsuario.Nombre
			This.nUserId 	= loUsuario.Id
			This.nNivel 	= loUsuario.Clave

			Try

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Insert Into <<This.cLoginTableName>> (
					TranId,
					Nexa,
					Equipo,
					WinUser,
					Usuario,
					UserId,
					Nivel,
					Proceso,
					Referencia,
					Modulo,
					Programa,
					Metodo,
					TS,
					Contable,
					Abm,
					ParentId,
					Duracion,
					Autorizado,
					AutorizaId ) Values (
					lnId,
					tnNexa,
					This.cEquipo,
					This.cWinUser,
					This.cUsuario,
					This.nUserId,
					loUsuario.Clave,
					tcProceso,
					tcReferencia,
					lcModulo,
					lcPrograma,
					lcMetodo,
					ltDateTime,
					ldFechaContable,
					tcABM,
					tnParentId,
					0,
					lcAutorizado,
					lnAutorizaId  )
				ENDTEXT

				&lcCommand

			Catch To oErr
				Do Case
					Case oErr.ErrorNo = 12  && The specified variable or field name could not be found.
						This.AlterLoginTable()

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Insert Into <<This.cLoginTableName>> (
							TranId,
							Nexa,
							Equipo,
							WinUser,
							Usuario,
							UserId,
							Nivel,
							Proceso,
							Referencia,
							Modulo,
							Programa,
							Metodo,
							TS,
							Contable,
							Abm,
							ParentId,
							Duracion,
							Autorizado,
							AutorizaId  ) Values (
							lnId,
							tnNexa,
							This.cEquipo,
							This.cWinUser,
							This.cUsuario,
							This.nUserId,
							loUsuario.Clave,
							tcProceso,
							tcReferencia,
							lcModulo,
							lcPrograma,
							lcMetodo,
							ltDatetime,
							ldFechaContable,
							tcABM,
							tnParentId,
							0,
							lcAutorizado,
							lnAutorizaId  )
						ENDTEXT

						&lcCommand

					Otherwise
						loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
						loError.cRemark = lcCommand
						loError.Process ( m.oErr )
						Throw loError

				Endcase

			Finally

			Endtry

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			*!*				Use In Select( This.cLoginTableName )

			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

		Return lnId

	Endproc && xxxLogTransaction



	*
	*
	Procedure UpdateTransaction( lForce As Boolean ) As Void
		Local lcCommand As String,;
			lcAlias As String
		Local loReg As Object
		Local llCloseTable as Boolean 

		Try

			lcCommand = ""
			llCloseTable = .F.
			 
			lcAlias = Alias()

			If !Used( This.cLoginTableName ) And lForce
				M_Use( 0, Addbs( This.cLoginTableFolder ) + This.cLoginTableName )
				llCloseTable = .T. 
				=Seek( This.nTransactionId, This.cLoginTableName, "TranId" )
			Endif

			If Used( This.cLoginTableName ) And !Empty( This.nSeconds )
				Select Alias( This.cLoginTableName )

				Scatter Fields Except TranId Memo Name loReg

				loReg.Nexa 			= This.nNexa
				loReg.Equipo 		= This.cEquipo
				loReg.WinUser 		= This.cWinUser
				loReg.Usuario 		= This.cUsuario
				loReg.Userid 		= This.nUserId
				loReg.Proceso 		= This.cProceso
				loReg.Referencia 	= This.cReferencia
				loReg.Metodo		= This.cMetodo
				loReg.Contable 		= This.dContable
				loReg.Abm 			= This.cABM
				loReg.ParentId 		= This.nParentId

				M_IniAct( 52 )
				Gather Name loReg Memo
				Unlock 

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			If llCloseTable  
				Use in Select( This.cLoginTableName ) 
			EndIf
			
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

			loReg = Null

		Endtry

	Endproc && UpdateTransaction


	*
	* Graba el Id de la transaccion en el campo TranId, si éste existe
	Procedure SaveTransactionId( tnId As Integer ) As Void;
			HELPSTRING "Graba el Id de la transaccion en el campo TranId, si éste existe"

		Local lnId As Integer

		Try

			If Empty( tnId )
				lnId = This.nTransactionId

			Else
				lnId = tnId

			Endif

			If Inlist( Vartype( TranId ), "N", "I" )
				Replace TranId With lnId

				Try

					Replace Equipo With This.cEquipo

				Catch To oErr

				Finally

				Endtry

				Try

					Replace WinUser With This.cWinUser

				Catch To oErr

				Finally

				Endtry

				Try

					Replace Usuario With This.cUsuario

				Catch To oErr

				Finally

				Endtry

				Try

					Replace Userid With This.nUserId

				Catch To oErr

				Finally

				Endtry

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError


		Finally

		Endtry

	Endproc && SaveTransactionId




	*
	*
	Procedure ReadTransactionId(  ) As Void
		Local lnId As Integer

		Try

			lnId = 0

			If Inlist( Vartype( TranId ), "N", "I" )
				lnId = TranId
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError


		Finally

		Endtry

		Return lnId

	Endproc && ReadTransactionId



	*
	* Setea el tipo de operacion
	Procedure SetABM( tcABM As Character,;
			tnTranId As Integer ) As Void;
			HELPSTRING "Setea el tipo de operacion"

		Local lcCommand As String

		Try

			If Empty( tnTranId )
				tnTranId = This.nTransactionId
			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Update '<<Addbs( This.cLoginTableFolder )>><<This.cLoginTableName>>'
				Set ABC = '<<tcABM>>'
				Where TranId = <<tnTranId>>
			ENDTEXT

			&lcCommand

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			*!*				Use In Select( This.cLoginTableName )

		Endtry

	Endproc && SetABM




	*
	*
	Procedure DebugLog( lLogFile As Boolean,;
			cTableName As String,;
			cFieldName As String,;
			nId As Integer ) As Void
		Local lcCommand As String,;
			lcMsg As String

		Local lnDuracion As Number

		Try

			lcCommand = ""

			If lLogFile
				lnDuracion = Seconds() - This.nSeconds

				TEXT To lcMsg NoShow TextMerge Pretext 03
				<<This.cProceso>>
				<<This.cReferencia>>
				Duracion: <<lnDuracion>>

				<<This.cDebugLog>>
				ENDTEXT

				Logerror( lcMsg )

			Else
				lnDuracion = Seconds() - This.nSeconds

				TEXT To lcMsg NoShow TextMerge Pretext 15
				<<cTableName>>.<<cFieldName>> = <<nId>>   (Duracion: <<lnDuracion>>)
				ENDTEXT

				This.cDebugLog = This.cDebugLog + lcMsg + CRLF

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && DebugLog


Enddefine
*!*
*!* END DEFINE
*!* Class.........: TransactionHandle
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oTables
*!* Description...:
*!* Date..........: Sábado 24 de Enero de 2015 (10:49:36)
*!*
*!*

Define Class oTables As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg

	#If .F.
		Local This As oTables Of "Fw\Tieradapter\Comun\prxTransactions.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	* New
	* Devuelve un elemento existente, o lo crea y lo agrega a la colección.
	Function New ( tcName As String,;
			tcBefore As String ) As Object ;
			HelpString 'Devuelve un elemento existente, o lo crea y lo agrega a la colección.'

		Local loTable As Object

		Local lcCommand As String,;
			lcKey As String

		Try

			lcCommand = ""

			m.tcName = Alltrim ( m.tcName )

			loTable = This.GetItem( m.tcName )

			If Isnull( loTable )
				loTable = Createobject( "Empty" )

				AddProperty( loTable, "cAlias", m.tcName )

				lcKey = Lower ( m.tcName )

				If Empty ( m.tcBefore )
					This.AddItem ( m.loTable, m.lcKey )

				Else && Empty( m.tcBefore )
					This.AddItem ( m.loTable, m.lcKey, Lower ( m.tcBefore ) )

				Endif && Empty( m.tcBefore )

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return m.loTable

	Endfunc && New


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oTables
*!*
*!* ///////////////////////////////////////////////////////

