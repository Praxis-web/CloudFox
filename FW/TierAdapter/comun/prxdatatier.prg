*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxDataTier
*!* ParentClass...: prxSession Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....:
*!* Description...:
*!* Date..........: Lunes 24 de Mayo de 2010 (11:35:19)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#INCLUDE "FW\Comunes\Include\Praxis.h"

Define Class PrxDataTier As prxSession Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'

	#If .F.
		Local This As PrxDataTier Of "V:\Clipper2fox\Fw\Tieradapter\Comun\Prxdatatier.prg"
	#Endif


	* Referencia al objeto Conection
	oConnection = Null

	* Referencia al objeto que sabe como comunicarse con el Motor de Base de datos
	oBackEnd = Null


	* Indica si serializa los cursores para pasarlos entre capas
	lSerialize = .F.

	*
	cAccessType = "NATIVE"

	*
	cBackEndEngine = "FOX"

	cBackEndCfgFileName = ""

	cDataBaseName = ''
	cStringConnection = ''

	DataSession = 1

	DataSessionId = 1

	* Valor del buffering por default de los cursores generados por BuilCursor
	nBuffering = 5

	* Indica si son tablas libres o utiliza una DBC
	lUseDBC = .F.

	* Indica si se utilizan transacciones
	lUseTransactions = .F.

	* Modo Debug
	lDebugMode = .F.

	*
	nEntidadId = 0

	* Comando que se ejecuta si existe
	cSQLCommand = ""

	* Nombre del Campo que es la PK
	cPKField = ""

	* Nombre del cursor virtual asociado a la entidad
	cMainCursorName = ""

	* Nombre de la tabla física asociada a la entidad
	cMainTableName = ""

	* Coleccion de Tablas de la Entidad
	oColTables = Null

	nAction = 0

	* RA 2013-06-29(12:25:45)
	* Usado por AfterCursorFill() de prxCursorAdapter
	* Si trabajo conectado, no puedo cerrar las tablas
	* Solo vale para Clipper2Fox y Bases Nativas

	lCloseNativeTables = .F.

	* RA 2013-06-29(13:00:57)
	* Con bases nativas, el Triguer se dispara en el ApplyDiffgram
	lTriggerFailed = .F.

	* Referencia a la clase de negocios
	oBiz = Null

	* No muestra Wait Windows
	lSilence = .F.


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="naction" type="property" display="nAction" />] + ;
		[<memberdata name="ltriggerfailed" type="property" display="lTriggerFailed" />] + ;
		[<memberdata name="cmaincursorname" type="property" display="cMainCursorName" />] + ;
		[<memberdata name="cmaintablename" type="property" display="cMainTableName" />] + ;
		[<memberdata name="cpkfield" type="property" display="cPKField" />] + ;
		[<memberdata name="lusedbc" type="property" display="lUseDBC" />] + ;
		[<memberdata name="cstringconnection" type="property" display="cStringConnection" />] + ;
		[<memberdata name="cdatabasename" type="property" display="cDataBaseName" />] + ;
		[<memberdata name="cbackendcfgfilename" type="property" display="cBackEndCfgFileName" />] + ;
		[<memberdata name="nbuffering" type="property" display="nBuffering" />] + ;
		[<memberdata name="cbackendengine" type="property" display="cBackEndEngine" />] + ;
		[<memberdata name="caccesstype" type="property" display="cAccessType" />] + ;
		[<memberdata name="obackend" type="property" display="oBackEnd" />] + ;
		[<memberdata name="obackend_access" type="method" display="oBackEnd_Access" />] + ;
		[<memberdata name="oconnection" type="property" display="oConnection" />] + ;
		[<memberdata name="serialize" type="method" display="Serialize" />] + ;
		[<memberdata name="lserialize" type="property" display="lSerialize" />] + ;
		[<memberdata name="buildcursor" type="method" display="BuildCursor" />] + ;
		[<memberdata name="sqlexecute" type="method" display="SQLExecute" />] + ;
		[<memberdata name="executenonquery" type="method" display="ExecuteNonQuery" />] + ;
		[<memberdata name="put" type="method" display="Put" />] + ;
		[<memberdata name="transactionbegin" type="method" display="TransactionBegin" />] + ;
		[<memberdata name="transactionend" type="method" display="TransactionEnd" />] + ;
		[<memberdata name="transactionrollback" type="method" display="TransactionRollBack" />] + ;
		[<memberdata name="gettablesfromsql" type="method" display="GetTablesFromSQL" />] + ;
		[<memberdata name="concatenarsinoexiste" type="method" display="ConcatenarSiNoExiste" />] + ;
		[<memberdata name="extractalias" type="method" display="ExtractAlias" />] + ;
		[<memberdata name="getupdatablefieldlist" type="method" display="GetUpdatableFieldList" />] + ;
		[<memberdata name="getupdatablefieldlistfromtable" type="method" display="GetUpdatableFieldListFromTable" />] + ;
		[<memberdata name="getupdatenamelist" type="method" display="GetUpdateNameList" />] + ;
		[<memberdata name="getupdatenamelistfromtable" type="method" display="GetUpdateNameListFromTable" />] + ;
		[<memberdata name="cdatabasename_access" type="method" display="cDataBaseName_Access" />] + ;
		[<memberdata name="readinifile" type="method" display="ReadIniFile" />] + ;
		[<memberdata name="ldebugmode" type="property" display="lDebugMode" />] + ;
		[<memberdata name="nentidadid" type="property" display="nEntidadId" />] + ;
		[<memberdata name="csqlcommand" type="property" display="cSQLCommand" />] + ;
		[<memberdata name="actualizartimestamp" type="method" display="ActualizarTimeStamp" />] + ;
		[<memberdata name="generardiffgram" type="method" display="GenerarDiffgram" />] + ;
		[<memberdata name="crearcursoradapters" type="method" display="CrearCursorAdapters" />] + ;
		[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
		[<memberdata name="connecttobackend" type="method" display="ConnectToBackend" />] + ;
		[<memberdata name="disconnectfrombackend" type="method" display="DisconnectFromBackend" />] + ;
		[<memberdata name="getnewid" type="method" display="GetNewId" />] + ;
		[<memberdata name="updatechildren" type="method" display="UpdateChildren" />] + ;
		[<memberdata name="lclosenativetables" type="property" display="lCloseNativeTables" />] + ;
		[<memberdata name="killcursoradapters" type="method" display="KillCursorAdapters" />] + ;
		[<memberdata name="lusetransactions" type="property" display="lUseTransactions" />] + ;
		[<memberdata name="obiz" type="property" display="oBiz" />] + ;
		[<memberdata name="obiz_access" type="method" display="oBiz_Access" />] + ;
		[<memberdata name="lsilence" type="property" display="lSilence" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SQLExecute
	*!* Description...: Ejecuta un comando SQL y devuelve un objeto
	*!* Date..........: Jueves 19 de Enero de 2006 (11:22:52)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure SQLExecute( tcSQLCommand As String,;
			tcAlias As String,;
			tnBuffering As Integer,;
			tlDontDetach As Boolean,;
			tlLogSelectCmd As Boolean ) As Object;
			HELPSTRING "Ejecuta un comando SQL y devuelve un objeto"

		Local lllAlreadyConnected As Boolean
		Local loReturn As Object

		Try


			If !This.lSilence 
				Wait Window Nowait "Ejecutando Consulta ..."
			EndIf 

			If Empty( tcAlias )
				tcAlias = Sys( 2015 )
			Endif

			lllAlreadyConnected = This.ConnectToBackend() = 0

			loReturn = This.BuildCursor( tcAlias, tcSQLCommand, tnBuffering, tlDontDetach, tlLogSelectCmd )

			If Vartype( loReturn ) == "O"
				AddProperty( loReturn, "cXML", This.Serialize( tcAlias ))
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

			Wait Clear

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

		Return loReturn

	Endproc
	*!*
	*!* END PROCEDURE SQLExecute
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
	*!* DAE 2009-09-30(11:20:50)
	*!* Agregue la deteccion de tipo de sentencia SQL para indicar
	*!* el tipo de proceso que se va a realizar.
	*!* Si no se incluyeron los campos TS y TransactionID
	*!* se agregan automaticamente en los insert
	*!*
	*!*
	*!*

	Procedure ExecuteNonQuery( tcSQLCommand As String ) As Boolean;
			HELPSTRING "Ejecuta una consulta SQL"

		Local lllAlreadyConnected As Boolean
		Local loMyCA As prxCursorAdapter Of "FW\TierAdapter\Comun\prxCursorAdapter.prg"
		Local lcCommand As String
		Local lcDate As String,;
			lcCentury As String

		Try

			lcCommand = ""

			lcDate = Set("Date")
			lcCentury = Set("Century")

			Set Date YMD
			Set Century On

			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk

				loMyCA = Newobject( "prxCursorAdapter",;
					"prxCursorAdapter.prg",;
					"",;
					This.cAccessType,;
					This.oConnection,;
					This.cBackEndEngine )

				lcCommand = loMyCA.ValidateSqlStatement( tcSQLCommand )

				This.lIsOk = This.oBackEnd.ExecuteNonQuery( lcCommand )

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loMyCA = Null
			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

			Set Date (lcDate)
			Set Century &lcCentury

		Endtry

		Return This.lIsOk

	Endproc && ExecuteNonQuery


	*
	*
	Procedure Put( oParam As Object ) As Boolean
		Local lcCommand As String,;
			lcDiffgram As String,;
			lcDeleted As String

		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local loTransaction As Transaction Of "ERP\Comunes\Sistema\Prg\Transaction.prg"

		Local lnTransactionId As Integer

		Local llOk As Boolean
		Local lllAlreadyConnected As Boolean

		Private pcXMLError As String

		Try

			lcCommand = ""
			pcXMLError = ""
			lcDeleted = Set("Deleted")

			llOk = .T.
			This.lTriggerFailed = .F.

			If Vartype( oParam ) = "O"
				If Pemstatus( oParam, "nEntidadId", 5 )
					This.nEntidadId = oParam.nEntidadId
				Endif
			Endif

			If This.lUseTransactions
				* RA 2013-08-16(17:45:56)
				* Por sugerencia de Dado, decidimos
				* no grabar la transaccion, sino implementar un
				* sistema de loggeo

				*!*					loTransaction = GetEntity( "Transaction" )
				*!*					loTransaction.OpenTransaction()

				*!*					loTransaction.nAction = This.nAction
			Endif

			Set Deleted Off

			* Proceso de actualizacion

			* Llegan los cursores actualizados en la coleccion colTables
			* Recorrer la coleccion generando los CursorAdapter por cada tabla
			* Abrir la transaccion
			* Recorrer la coleccion ejecutando TableUpdate() para cada tabla

			This.CrearCursorAdapters( oParam )

			If !This.lTriggerFailed

				* Ahora si, abro la transacción y ejecuto TableUpdate

				lllAlreadyConnected = This.ConnectToBackend() = 0
				This.TransactionBegin()

				loColTables = This.oColTables

				llOk = .T.

				For Each loTable In loColTables
					If llOk


						If This.lUseTransactions
							* RA 2013-08-16(17:45:56)
							* Por sugerencia de Dado, decidimos
							* no grabar la transaccion, sino implementar un
							* sistema de loggeo


							*!*								TEXT To lcCommand NoShow TextMerge Pretext 15
							*!*								Update <<loTable.CursorName>> Set
							*!*									Transaction_ID = <<loTransaction.TransactionID>>
							*!*									Where !Empty( ABM )
							*!*								ENDTEXT

							*!*								&lcCommand
						Endif

						If loTable.Nivel > 1
							This.UpdateChildren( loTable, This.nEntidadId )
						Endif

						Select Alias( loTable.CursorName )

						Locate
						Scan For Evaluate( loTable.CursorName + ".ABM" ) = ABM_BAJA While llOk

							If !Tableupdate( .F., .T., loTable.CursorName )
								llOk = .F.
							Endif

						Endscan


						Locate
						Scan For Evaluate( loTable.CursorName + ".ABM" ) = ABM_MODIFICACION While llOk

							If !Tableupdate( .F., .T., loTable.CursorName )
								llOk = .F.
							Endif

						Endscan

						Locate
						Scan For Evaluate( loTable.CursorName + ".ABM" ) = ABM_ALTA While llOk

							If !Tableupdate( .F., .T., loTable.CursorName )
								llOk = .F.

							Else
								If loTable.Nivel = 1
									* Es un alta, Guardo el Id para pasarlo a los hijos

									If !loTable.PKUpdatable
										* Es autoincremental
										This.nEntidadId = This.GetNewId( loTable.Name, loTable.PKName )
									Endif

								Endif
							Endif

						Endscan

					Endif
				Endfor

				If llOk
					This.TransactionEnd()

					If This.lUseTransactions
						* RA 2013-08-16(17:45:56)
						* Por sugerencia de Dado, decidimos
						* no grabar la transaccion, sino implementar un
						* sistema de loggeo

						*loTransaction.CloseTransaction()
					Endif

				Else
					Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
					loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					loError.Cremark = "Tableupdate Falló"
					loError.Process()

				Endif

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			llOk = .F.

			Try
				Do While !Empty( Txnlevel())
					This.TransactionRollBack()
				Enddo

			Catch

			Finally


			Endtry


			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

			This.KillCursorAdapters()

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

			loTable = Null
			loColTables = Null

			Set Deleted &lcDeleted

		Endtry

		Return llOk

	Endproc && Put



	*
	* Libera todos los CursorsAdapters asociados a las tablas
	Procedure KillCursorAdapters(  ) As Void;
			HELPSTRING "Libera todos los CursorsAdapters asociados a las tablas"
		Local lcCommand As String
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"


		Try

			lcCommand = ""
			loColTables = This.oColTables

			For Each loTable In loColTables
				If Vartype( loTable.oCursorAdapter ) == "O"
					If Lower( loTable.oCursorAdapter.BaseClass ) = Lower( "CursorAdapter" )
						loTable.oCursorAdapter.CursorDetach()
					Endif

					loTable.oCursorAdapter = Null
				Endif

			Endfor


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTable = Null
			loColTables = Null

		Endtry

	Endproc && KillCursorAdapters


	*
	* Actualiza el ParentId de los hijos en un insert
	Procedure UpdateChildren( oTable As Object,;
			nEntidadId As Integer ) As Void;
			HELPSTRING "Actualiza el ParentId de los hijos en un insert"

		Local lcCommand As String

		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local llOk As Boolean

		Try

			lcCommand 	= ""
			llOk 		= .T.

			loTable = oTable

			Select Alias( loTable.CursorName )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Replace All
				<<loTable.ForeignKey>> With <<nEntidadId>>
				In <<loTable.CursorName>>
			ENDTEXT

			&lcCommand


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTable = Null

		Endtry

	Endproc && UpdateChildren


	*
	*
	Procedure GetNewId( tcTable As String, tcPKName As String ) As Integer
		Local lcCommand As String
		Local lnNewId As Integer

		Try

			lcCommand 	= ""
			lnNewId 	= 1

			lnNewId = This.oBackEnd.GetNewId( tcTable, tcPKName  )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry

		Return lnNewId

	Endproc && GetNewId





	*
	* Genera el diffgram
	Procedure GenerarDiffgram(  ) As Void;
			HELPSTRING "Genera el diffgram"
		Local lcCommand As String,;
			lcDiffgram As String
		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"



		Try

			lcCommand 	= ""
			loXA 		= Newobject("prxXMLAdapter","prxXMLAdapter.prg")

			loXA.AddTableSchema( This.cMainCursorName )

			lcDiffgram 	= loXA.GetDiffGram()

			Use In Select( This.cMainCursorName )

			*!*				TEXT To lcLogDiffgramFile NoShow TextMerge Pretext 15
			*!*				Diffgram_<<This.cMainCursorName>>_<<Seconds()>>.txt
			*!*				ENDTEXT

			*!*				Strtofile( lcDiffgram, lcLogDiffgramFile )



		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loXA = Null

		Endtry

		Return lcDiffgram

	Endproc && GenerarDiffgram




	*
	* Crea los Cursor Adapters para cada tabla
	Procedure CrearCursorAdapters( oParam As Object ) As Void;
			HELPSTRING "Crea los Cursor Adapters para cada tabla"
		Local lcCommand As String,;
			lcDiffgram As String,;
			lcFieldList As String,;
			lcWhereCondition As String

		Local loMyCA As prxCursorAdapter Of "FW\TierAdapter\Comun\prxCursorAdapter.prg"
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"

		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"

		Local llOk As Boolean

		Private pcXMLError As String


		Try

			lcCommand = ""
			pcXMLError = ""

			loColTables = This.oColTables

			lllAlreadyConnected = This.ConnectToBackend() = 0

			For Each loTable In loColTables

				If Vartype( oParam ) = "O"
					If Pemstatus( oParam, "cFilterCriteria", 5 )
						lcWhereCondition = oParam.cFilterCriteria

					Else
						TEXT To lcWhereCondition NoShow TextMerge Pretext 15
						<<loTable.PKName>> = <<This.nEntidadId>>
						ENDTEXT

					Endif

					If Pemstatus( oParam, "cFieldList", 5 )
						lcFieldList = oParam.cFieldList

					Else
						lcFieldList = " * "

					Endif


				Else
					lcFieldList = " * "
					TEXT To lcWhereCondition NoShow TextMerge Pretext 15
					<<loTable.PKName>> = <<This.nEntidadId>>
					ENDTEXT

				Endif

				This.ActualizarTimeStamp( loTable.CursorName )

				lcDiffgram = This.GenerarDiffgram()

				loMyCA 	= Newobject("prxCursorAdapter", "prxCursorAdapter.prg" ,;
					"",;
					This.cAccessType,;
					This.oConnection,;
					This.cBackEndEngine )

				loMyCA.lCloseNativeTables = This.lCloseNativeTables

				If Vartype( loTable.oCursorAdapter ) == "O"
					If Lower( loTable.oCursorAdapter.BaseClass ) = Lower( loMyCA.BaseClass )
						loTable.oCursorAdapter.CursorDetach()
					Endif

					loTable.oCursorAdapter = Null
				Endif

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Select 	<<lcFieldList>> ,
						" " as r7Mov,
						Cast( 0 as I ) as ABM,
						Cast( 0 as I ) as _RecordOrder
					From <<loTable.Tabla>>
					Where <<lcWhereCondition>>
				EndTex

				loMyCA.Alias 				= loTable.CursorName
				loMyCA.SelectCmd  			= lcCommand
				loMyCA.Tables 				= loTable.Tabla
				loMyCA.UpdatableFieldList 	= loTable.UpdatableFieldList
				loMyCA.UpdateNameList 		= loTable.UpdateNameList
				loMyCA.KeyFieldList 		= loTable.PKName

				loMyCA.CursorAttach( loTable.CursorName, .T. )

				llOk = loMyCA.CursorFill()

				If llOk

					* Aplicar Diffgram
					loXA = NewObject("prxXMLAdapter","prxXMLAdapter.prg")

					loXA.AddTableSchema( loTable.CursorName )
					loXA.LoadXML( lcDiffgram )

					Try

						Select Alias( loTable.CursorName )

						loXA.Tables( 1 ).ApplyDiffgram()

						loTable.oCursorAdapter = loMyCA

					Catch To oErr
						Do Case
						Case oErr.ErrorNo = 1539	&& Trigger failed in "cursor".
							This.lTriggerFailed = .T.

							If Vartype( pcXMLError ) = "C"
								Stop( pcXMLError, "Error de Integridad Referencial" )
							EndIf

						Otherwise
							Throw oErr

						EndCase

					Finally

					EndTry

				Else
					Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

					loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					loError.Cremark = "Falló CursorFill()"
					loError.Process()

				EndIf

			Endfor

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

			loXA	= Null
			loMyCA 	= Null

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

	Endproc && CrearCursorAdapters


	*
	* Crea los Cursor Adapters para cada tabla
	Procedure xxxCrearCursorAdapters( oParam As Object ) As Void;
			HELPSTRING "Crea los Cursor Adapters para cada tabla"
		Local lcCommand As String,;
			lcDiffgram As String,;
			lcFieldList As String,;
			lcWhereCondition As String

		Local loMyCA As prxCursorAdapter Of "FW\TierAdapter\Comun\prxCursorAdapter.prg"
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"

		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"

		Local llOk As Boolean

		Private pcXMLError As String


		Try

			lcCommand = ""
			pcXMLError = ""

			loColTables = This.oColTables

			lllAlreadyConnected = This.ConnectToBackend() = 0

			For Each loTable In loColTables

				If Vartype( oParam ) = "O"
					If Pemstatus( oParam, "cFilterCriteria", 5 )
						lcWhereCondition = oParam.cFilterCriteria

					Else
						TEXT To lcWhereCondition NoShow TextMerge Pretext 15
						<<loTable.PKName>> = <<This.nEntidadId>>
				ENDTEXT

			Endif

			If Pemstatus( oParam, "cFieldList", 5 )
				lcFieldList = oParam.cFieldList

			Else
				lcFieldList = " * "

			Endif


		Else
			lcFieldList = " * "
			TEXT To lcWhereCondition NoShow TextMerge Pretext 15
					<<loTable.PKName>> = <<This.nEntidadId>>
			ENDTEXT

		Endif

		This.ActualizarTimeStamp( loTable.CursorName )

		*lcDiffgram = This.GenerarDiffgram()

		loMyCA 	= Newobject("prxCursorAdapter", "prxCursorAdapter.prg" ,;
			"",;
			This.cAccessType,;
			This.oConnection,;
			This.cBackEndEngine )

		loMyCA.lCloseNativeTables = This.lCloseNativeTables

		If Vartype( loTable.oCursorAdapter ) == "O"
			If Lower( loTable.oCursorAdapter.BaseClass ) = Lower( loMyCA.BaseClass )
				loTable.oCursorAdapter.CursorDetach()
			Endif

			loTable.oCursorAdapter = Null
		Endif

		TEXT To lcCommand NoShow TextMerge Pretext 15
				Select 	<<lcFieldList>> ,
						" " as r7Mov,
						Cast( 0 as I ) as ABM,
						Cast( 0 as I ) as _RecordOrder
					From <<loTable.Tabla>>
					Where <<lcWhereCondition>>
				EndTex

				loMyCA.Alias 				= loTable.CursorName
				loMyCA.SelectCmd  			= lcCommand
				loMyCA.Tables 				= loTable.Tabla
				loMyCA.UpdatableFieldList 	= loTable.UpdatableFieldList
				loMyCA.UpdateNameList 		= loTable.UpdateNameList
				loMyCA.KeyFieldList 		= loTable.PKName


				loMyCA.CursorAttach( loTable.CursorName, .T. )

				*llOk = loMyCA.CursorFill()
				llOk = .T.

				If llOk

					* Aplicar Diffgram
*!*						loXA = NewObject("prxXMLAdapter","prxXMLAdapter.prg")

*!*						loXA.AddTableSchema( loTable.CursorName )
*!*						loXA.LoadXML( lcDiffgram )

					Try

*!*							Select Alias( loTable.CursorName )

*!*							loXA.Tables( 1 ).ApplyDiffgram()

						loTable.oCursorAdapter = loMyCA

					Catch To oErr
						Do Case
						Case oErr.ErrorNo = 1539	&& Trigger failed in "cursor".
							This.lTriggerFailed = .T.

							If Vartype( pcXMLError ) = "C"
								Stop( pcXMLError, "Error de Integridad Referencial" )
							EndIf

						Otherwise
							Throw oErr

						EndCase

					Finally

					EndTry

				Else
					Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

					loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					loError.Cremark = "Falló CursorFill()"
					loError.Process()

				EndIf

			Endfor

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

			loXA	= Null
			loMyCA 	= Null

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

	Endproc && CrearCursorAdapters

	*
	* ConnectToBackend
	*!*		Protected Function ConnectToBackend() As Boolean
	Function ConnectToBackend() As Boolean
		Local lnReturn As Integer


		Try

			lnReturn = This.oBackEnd.Connect()
			This.oConnection = This.oBackEnd.oConnection

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lnReturn

	Endfunc && ConnectToBackend


	*-----------------------------------
	* Se desconecta de la base de datos.
	*-----------------------------------
	*!*		Protected Function DisconnectFromBackend() As Boolean
	Function DisconnectFromBackend() As Boolean

		Local llOk As Boolean
		Try

			llOk = This.oBackEnd.DisConnect()

			This.oConnection = This.oBackEnd.oConnection

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return This.lIsOk

	Endfunc && DisconnectFromBackend

	*
	* Serializes a series of cursors to XML
	Protected Procedure Serialize( tcCommaSeparatedCursorList As String ) As String;
			HELPSTRING "Serializes a series of cursors to XML"


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
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loXA = Null

		Endtry

		Return lcRetVal

	Endproc && Serialize

	*
	* BuildCursor
	Procedure BuildCursor( tcCursorName As String, ;
			tcSelectCmd As String,;
			tnBuffering As Integer,;
			tlDontDetach As Boolean,;
			tlLogSelectCmd As Boolean ) As Object

		Local loMyCA As prxCursorAdapter Of "FW\TierAdapter\Comun\prxCursorAdapter.prg"
		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"

		Local llOk As Boolean
		Local lcAlias As String,;
			lcTableName As String,;
			lcDebugSQL as String,;
			lcMsg as String,;
			lcConsole As String

		Local loReturn As Object
		Local array laStack[ 1 ]
		Local i as Integer

		Try

			llOk = .T.
			lcConsole = Set("Console")
			Set Console Off
			
			lcAlias = Sys(2015)
			loReturn = Createobject( "Empty" )
			AddProperty( loReturn, "lOk", llOk )
			AddProperty( loReturn, "oMyCA", Null )
			AddProperty( loReturn, "oXA", Null )

			If Empty( tnBuffering )
				tnBuffering = This.nBuffering
			Endif

			loMyCA = Newobject( "prxCursorAdapter", "prxCursorAdapter.prg", "", This.cAccessType, This.oConnection, This.cBackEndEngine )

			loMyCA.lCloseNativeTables = This.lCloseNativeTables

			loMyCA.cOldSetCentury 	= Set( "Century" )
			loMyCA.cOldSetDate 		= Set( "Date" )
			
			If This.lSilence 
				If Empty( At( "NOCONSOLE", tcSelectCmd ))
					tcSelectCmd = tcSelectCmd + " NOCONSOLE"
				EndIf
			EndIf

			With loMyCA As CursorAdapter
				.Alias = tcCursorName
				.SelectCmd = tcSelectCmd
				
				lnStart = Seconds()
				lcCommand = .SelectCmd 
				 
				llOk = .CursorFill()
				
				lnLapso = Seconds() - lnStart
				
*!*					If !Empty( Set("Coverage"))
*!*						Text To lcMsg NoShow TextMerge Pretext 03
*!*						---------------------------------------------
*!*						<<Datetime()>> BuilCursor
*!*						Lapso: <<lnLapso>>		
*!*						
*!*						<<lcCommand>>			
*!*						EndText

*!*						StrToFile( lcMsg + CRLF + CRLF, Alltrim( DRVA ) + "BuildCursor.Log", 1 )
*!*						
*!*					EndIf

				If !tlDontDetach
					.CursorDetach()

				Else
					* RA 2012-06-17(11:39:02)
					* Devuelve el cursor adapter listo para la actualizacion
					* contra la base de datos


					lcTableName = Getwordnum( This.GetTablesFromSQL( .SelectCmd ), 1, "," )

					*!*						loMyCA.UpdatableFieldList 	= This.GetUpdatableFieldList( lcTableName )
					*!*						loMyCA.UpdateNameList 		= This.GetUpdateNameList( .Alias, "", lcTableName )

					loReturn.oMyCA = loMyCA

					loXA = Newobject("prxXMLAdapter","prxXMLAdapter.prg")
					loXA.AddTableSchema( .Alias )

					loReturn.oXA = loXA

				EndIf

				If tlLogSelectCmd Or FileExist( "lDebug.tag" )
					i = AStackInfo( laStack ) - 2

					Text To lcMsg NoShow TextMerge Pretext 03
					*<<Replicate( "-", 30 )>>
					*<<Datetime()>>

					*Programa: <<laStack[ i, 4 ]>>
					*Método:   <<laStack[ i, 3 ]>>
					*Linea:    <<laStack[ i, 5 ]>>
					
					*Set Date <<Set("Date")>>
					*Set Century <<Set("Century")>>
					*Set Deleted <<Set("Deleted")>>
					*<<Replicate( "-", 30 )>>
					EndText 


					lcDebugSQL = Strtran( .SelectCmd, ",", ",;" + CRLF )
					lcDebugSQL = Strtran( lcDebugSQL, " From ",  ";" + CRLF + "From ")
					lcDebugSQL = Strtran( lcDebugSQL, " Left ",  ";" + CRLF + "Left ")
					lcDebugSQL = Strtran( lcDebugSQL, " Right ", ";" + CRLF + "Right ")
					lcDebugSQL = Strtran( lcDebugSQL, " Inner ", ";" + CRLF + "Inner ")
					lcDebugSQL = Strtran( lcDebugSQL, " Where ", ";" + CRLF + "Where ")
					lcDebugSQL = Strtran( lcDebugSQL, " Order ", ";" + CRLF + "Order ")


					Strtofile( lcMsg + CRLF + lcDebugSQL + CRLF, "SelectCommand.prg", 1 )
					Strtofile( "*"+Replicate( "/", 60 ) + CRLF, "SelectCommand.prg", 1 )

				Endif


			Endwith

			If loMyCA.lHasError
				Throw loMyCA.oError

			Else
				If Empty( Txnlevel())
					If CursorGetProp("Buffering", tcCursorName ) # tnBuffering
						CursorSetProp( "Buffering", tnBuffering, tcCursorName )
					Endif
				Endif
			Endif



Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	llOk = .F.
	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loMyCA = Null
	Set Console &lcConsole

Endtry

Return loReturn

Endproc && BuildCursor


*
* oBackEnd_Access
	Protected Procedure oBackEnd_Access()

		If Vartype( This.oBackEnd ) # "O"
			Do Case
				Case Upper(This.cAccessType)="NATIVE"
					This.oBackEnd = Newobject( "NativeBackEnd",;
						"fw\tieradapter\datatier\BackEndNative.prg" )

					This.oBackEnd.lUseDBC 			= This.lUseDBC
					This.oBackEnd.lUseTransactions 	= This.lUseTransactions

				Case Upper(This.cAccessType)="ODBC"
					This.oBackEnd = Newobject( "ODBCBackEnd",;
						"BackEndODBC.prg" )

					This.lUseDBC 			= .T.
					This.lUseTransactions 	= .T.

				Case Upper(This.cAccessType)="ADO"
					This.oBackEnd = Newobject( "ADOBackEnd",;
						"BackEndADO.prg" )

					This.lUseDBC 			= .T.
					This.lUseTransactions 	= .T.

				Otherwise
					Error "Data Access Type Not Recognized"

			Endcase

			If This.lUseDBC
				With This.oBackEnd As BackEnd Of "TierAdapter\DataTier\BackEnd.prg"
					.cDataBaseName 		= This.cDataBaseName
					.cStringConnection 	= This.cStringConnection
					.cBackEndEngine 	= This.cBackEndEngine
				Endwith
			Endif
		Endif

		Return This.oBackEnd

	Endproc && oBackEnd_Access



	*
	*
	Procedure TransactionBegin(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			This.lIsOk = This.oBackEnd.BeginTransaction()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && TransactionBegin



	*
	*
	Procedure TransactionEnd(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			This.lIsOk = This.oBackEnd.EndTransaction()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && TransactionEnd


	*
	*
	Procedure TransactionRollBack(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			This.oBackEnd.Rollback()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && TransactionRollBack



	*
	* Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla
	Procedure GetUpdatableFieldListFromTable( tcTableName As String,;
			tcExcludeFieldList As String ) As Void;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String

		Local Array laFields[ 1 ]

		Local lnLen As Integer,;
			i As Integer

		Local llInList As Boolean

		Try

			lcCommand = ""
			lcFieldList = ""

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_-_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			lnLen = Afields( laFields, tcTableName )

			For i = 1 To lnLen
				lcField = laFields[ i, 1 ]

				TEXT To lcCommand NoShow TextMerge Pretext 15
					InList( '<<Lower( lcField )>>', <<tcExcludeFieldList>> )
				ENDTEXT

				llInList = &lcCommand

				If !llInList
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
						,<<lcField>>
					ENDTEXT

				Endif
			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcFieldList

	Endproc && GetUpdatableFieldListFromTable

	*
	* Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla
	Procedure GetUpdateNameListFromTable( tcCursorName As String,;
			tcExcludeFieldList As String,;
			tcTableName As String ) As Void;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String

		Local Array laFields[ 1 ]

		Local lnLen As Integer,;
			i As Integer

		Try

			lcCommand = ""
			lcFieldList = ""

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_-_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			lnLen = Afields( laFields, tcTableName )

			For i = 1 To lnLen
				lcField = laFields[ i, 1 ]

				TEXT To lcCommand NoShow TextMerge Pretext 15
				InList( '<<Lower( lcField )>>', <<tcExcludeFieldList>> )
				ENDTEXT

				llInList = &lcCommand

				If !llInList
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
					,<<lcField>> <<tcTableName>>.<<lcField>>
					ENDTEXT

				Endif
			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcFieldList

	Endproc && GetUpdateNameListFromTable



	*
	* Devuelve la lista de campos que se actualizan a partir del Diccionario de Datos
	Procedure GetUpdatableFieldList( tcTableName As String,;
			tcExcludeFieldList As String ) As Void;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String

		Local llInList As Boolean

		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColFields As colFields Of "Tools\Sincronizador\colDataBases.prg"
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"


		Try

			lcCommand = ""
			lcFieldList = ""

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_/-\_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			loColTables = NewColTables()
			loTable = loColTables.GetItem( tcTableName )
			loColFields = loTable.oColFields
			lcFieldList = ""

			For Each loField In loColFields
				lcField = Lower( loField.Name )

				TEXT To lcCommand NoShow TextMerge Pretext 15
					InList( '<<lcField>>', <<tcExcludeFieldList>> )
				ENDTEXT

				llInList = &lcCommand

				If !llInList
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
						,<<lcField>>
					ENDTEXT

				Endif
			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcFieldList

	Endproc && GetUpdatableFieldList

	*
	* Devuelve la lista de campos que se actualizan a partir del Diccionario de Datos
	Procedure GetUpdateNameList( tcCursorName As String,;
			tcExcludeFieldList As String,;
			tcTableName As String ) As Void;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String

		Local llInList As Boolean

		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColFields As colFields Of "Tools\Sincronizador\colDataBases.prg"
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"


		Try

			lcCommand = ""
			lcFieldList = ""

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_/-\_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			loColTables = NewColTables()
			loTable = loColTables.GetItem( tcTableName )
			loColFields = loTable.oColFields
			lcFieldList = ""

			For Each loField In loColFields
				lcField = Lower( loField.Name )

				TEXT To lcCommand NoShow TextMerge Pretext 15
					InList( '<<lcField>>', <<tcExcludeFieldList>> )
				ENDTEXT

				llInList = &lcCommand

				If !llInList
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
					,<<lcField>> <<tcTableName>>.<<lcField>>
					ENDTEXT


				Endif
			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcFieldList

	Endproc && GetUpdateNameList

	*
	* GetTablesFromSQL
	* DAE 2009-10-21(13:42:12)
	Protected Function GetTablesFromSQL( tcSQL As String ) As String
		Local lcStr As String
		Local lcTablesNames As String
		Local lcTablesNameAux As String
		Local lcAux As String
		*
		Local lnCntFrom As Integer
		Local lnFromIndex As Integer
		Local lnCntJoin As Integer
		Local lnJoinIndex As Integer

		lcStr = ""
		lcAux = ""
		lcTablesNames = ""
		tcSQL = Upper( tcSQL )

		lcTablesNames = ''
		lcTablesNameAux = ''

		lnCntFrom = Occurs( "FROM", tcSQL )
		For lnFromIndex = 1 To lnCntFrom
			lcStr = Strextract( tcSQL, "FROM", "WHERE", lnFromIndex, 3 ) &&, 0, 3 )

			If Empty( lcStr )
				lcStr = Strextract( tcSQL, "FROM", '', lnFromIndex, 3 )

			Endif && Empty( lcStr )

			lcStr = Strextract( lcStr, "", "ORDER BY", 0, 3 )

			lcTablesNameAux = Strextract( lcStr, "", "JOIN", 0, 3 )

			lcAliasAux = This.ExtractAlias( lcTablesNameAux )
			If ! Inlist( lcAliasAux , '(', ')' )
				lcTablesNames = This.ConcatenarSiNoExiste( lcTablesNames, lcAliasAux )

			Endif && ! Inlist( lcAliasAux , '(', ')' )

		Endfor

		lnCntJoin = Occurs( "JOIN", tcSQL )
		For lnJoinIndex = 1 To lnCntJoin
			lcAux = Strextract( tcSQL, "JOIN ", " ON", lnJoinIndex, 3 )
			If ! Empty( lcAux )
				lcAliasAux = This.ExtractAlias( lcAux )
				If ! Inlist( lcAliasAux , '(', ')' )
					lcTablesNames = This.ConcatenarSiNoExiste( lcTablesNames, lcAliasAux )

				Endif && ! Inlist( lcAliasAux , '(', ')' )

			Endif && ! Empty( lcAux )

		Endfor

		Return lcTablesNames

	Endfunc && GetTablesFromSQL

	*
	* ConcatenarSiNoExiste
	* DAE 2009-10-21(13:42:04)
	Protected Function ConcatenarSiNoExiste( tcCadena As String, tcValor As String ) As String
		If ! ( tcValor $ tcCadena )
			If ! Empty( tcCadena )
				tcCadena = tcCadena + "," + tcValor

			Else
				tcCadena = tcValor

			Endif && ! Empty( tcCadena )

		Endif && ! ( tcValor $ tcCadena )

		Return tcCadena

	Endfunc && ConcatenarSiNoExiste

	* ExtractAlias
	Protected Function ExtractAlias( tcTablesNames As String ) As String

		Local lcAux As String
		lcAux = ""

		lcAux = Getwordnum( tcTablesNames, 1 )

		Do Case

			Case Empty( lcAux ) Or Inlist( Upper( lcAux ), "LEFT", "RIGHT", "INNER" )
				* lcAux  = Getwordnum( tcTablesNames, 1 )
				Error 'No existe el nombre de la tabla'

		Endcase

		Return lcAux

	Endfunc && ExtractAlias

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ReadIniFile
	*!* Description...: Leer el archivo de inicialización
	*!* Date..........: Jueves 5 de Enero de 2006 (09:28:41)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Menus
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ReadIniFile(  ) As Boolean;
			HELPSTRING "Leer el archivo de inicialización"

		Local loConfigData As Object
		Local lcCommand As String
		Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'


		Try

			lcCommand = ""

			If Empty( This.cDataBaseName )

				loXA = Newobject( "prxXMLAdapter", "prxXMLAdapter.prg" )

				loXA.LoadXML( This.cBackEndCfgFileName, .T. )
				loXA.Tables(1).ToCursor()
				loXA = Null

				Locate For Alltrim( Lower( objName )) = Alltrim( Lower( This.cDataConfigurationKey ))
				If Eof()
					Locate For Alltrim( Lower(objName)) = "default"
				Endif

				This.cAccessType       = Alltrim(AccessType)
				This.cDataBaseName     = Alltrim(dbName)
				This.cStringConnection = Alltrim(StrConn)
				This.cBackEndEngine    = Iif(Empty(Alltrim(BkEngine)),"FOX",Alltrim(BkEngine))
				This.lDebugMode 	   = DebugComponent

				Use In Alias()

				Local loConfigData As Object
				loConfigData = Createobject( "Empty" )
				AddProperty( loConfigData, "cAccessType", This.cAccessType )
				AddProperty( loConfigData, "cDataBaseName", This.cDataBaseName )
				AddProperty( loConfigData, "cStringConnection", This.cStringConnection )
				AddProperty( loConfigData, "cBackEndEngine", This.cBackEndEngine )

				*!*	                This.PopulateConfigData( loConfigData )

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry

		Return This.lIsOk

	Endproc && ReadIniFile



	*
	*
	Procedure ActualizarTimeStamp( cCursorName As String ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If !Empty( Field( "TS", cCursorName ) )

				Select Alias( cCursorName )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update <<cCursorName>> Set
					TS = Datetime()
				ENDTEXT

				&lcCommand

				Locate

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && ActualizarTimeStamp

	*
	* cDataBaseName_Access
	Protected Procedure cDataBaseName_Access()

		If Empty( This.cDataBaseName )
			This.ReadIniFile()
		Endif
		Return This.cDataBaseName

	Endproc && cDataBaseName_Access

	*
	* cDataBaseName_Access
	Protected Procedure cBackEndCfgFileName_Access()

		If Empty( This.cBackEndCfgFileName )
			This.cBackEndCfgFileName = Addbs( This.cRootFolder ) + "DataTier.xml"
		Endif
		Return This.cBackEndCfgFileName

	Endproc && cBackEndCfgFileName _Access


	*
	*
	Procedure Destroy(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			DoDefault()

			This.oColTables = Null

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Destroy


	*
	* oBiz_Access
	Protected Procedure oBiz_Access()
		Return This.oBiz

	Endproc && oBiz_Access

	Procedure Init()
		This.Initialize()
	Endproc

	*
	*
	Procedure Initialize(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			If This.DataSession = 1
				This.DataSessionId = 1
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: PrxDataTier
*!*
*!* ///////////////////////////////////////////////////////


Define Class oDataTier2 As PrxDataTier Of "V:\Clipper2fox\Fw\Tieradapter\Comun\Prxdatatier.prg"

	#If .F.
		Local This As oDataTier2 Of "V:\Clipper2fox\Fw\Tieradapter\Comun\Prxdatatier.prg"
	#Endif


	* Referencia al objeto Conection
	oConnection = Null

	* Referencia al objeto que sabe como comunicarse con el Motor de Base de datos
	oBackEnd = Null


	* Indica si serializa los cursores para pasarlos entre capas
	lSerialize = .F.

	*
	cAccessType = "NATIVE"

	*
	cBackEndEngine = "FOX"

	cBackEndCfgFileName = ""

	cDataBaseName = ''
	cStringConnection = ''

	DataSession = 1

	* Valor del buffering por default de los cursores generados por BuilCursor
	nBuffering = 5

	* Indica si son tablas libres o utiliza una DBC
	lUseDBC = .T.

	* Indica si se utilizan transacciones
	lUseTransactions = .T.

	* Modo Debug
	lDebugMode = .F.

	*
	nEntidadId = 0

	* Comando que se ejecuta si existe
	cSQLCommand = ""

	* Nombre del Campo que es la PK
	cPKField = ""

	* Nombre del cursor virtual asociado a la entidad
	cMainCursorName = ""

	* Nombre de la tabla física asociada a la entidad
	cMainTableName = ""

	* Coleccion de Tablas de la Entidad
	oColTables = Null

	nAction = 0

	* RA 2013-06-29(12:25:45)
	* Usado por AfterCursorFill() de prxCursorAdapter
	* Si trabajo conectado, no puedo cerrar las tablas
	* Solo vale para Clipper2Fox y Bases Nativas

	lCloseNativeTables = .F.

	* RA 2013-06-29(13:00:57)
	* Con bases nativas, el Triguer se dispara en el ApplyDiffgram
	lTriggerFailed = .F.

	* Referencia a la clase de negocios
	oBiz = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SQLExecute
	*!* Description...: Ejecuta un comando SQL y devuelve un objeto
	*!* Date..........: Jueves 19 de Enero de 2006 (11:22:52)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Tier Adapter
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure SQLExecute( tcSQLCommand As String,;
			tcAlias As String,;
			tnBuffering As Integer,;
			tlDontDetach As Boolean,;
			tlLogSelectCmd As Boolean ) As Object;
			HELPSTRING "Ejecuta un comando SQL y devuelve un objeto"

		Local lllAlreadyConnected As Boolean
		Local loReturn As Object

		Try


			If Empty( tcAlias )
				tcAlias = Sys( 2015 )
			Endif

			lllAlreadyConnected = This.ConnectToBackend() = 0

			loReturn = This.BuildCursor( tcAlias, tcSQLCommand, tnBuffering, tlDontDetach, tlLogSelectCmd )

			If Vartype( loReturn ) == "O"
				AddProperty( loReturn, "cXML", This.Serialize( tcAlias ))
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

		Return loReturn

	Endproc
	*!*
	*!* END PROCEDURE SQLExecute
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
	*!* DAE 2009-09-30(11:20:50)
	*!* Agregue la deteccion de tipo de sentencia SQL para indicar
	*!* el tipo de proceso que se va a realizar.
	*!* Si no se incluyeron los campos TS y TransactionID
	*!* se agregan automaticamente en los insert
	*!*
	*!*
	*!*

	Procedure ExecuteNonQuery( tcSQLCommand As String ) As Boolean;
			HELPSTRING "Ejecuta una consulta SQL"

		Local lllAlreadyConnected As Boolean
		Local loMyCA As prxCursorAdapter Of "FW\TierAdapter\Comun\prxCursorAdapter.prg"
		Local lcCommand As String
		Local lcDate As String,;
			lcCentury As String

		Try

			lcCommand = ""

			lcDate = Set("Date")
			lcCentury = Set("Century")

			Set Date YMD
			Set Century On

			lllAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk

				loMyCA = Newobject( "prxCursorAdapter",;
					"prxCursorAdapter.prg",;
					"",;
					This.cAccessType,;
					This.oConnection,;
					This.cBackEndEngine )

				lcCommand = loMyCA.ValidateSqlStatement( tcSQLCommand )

				This.lIsOk = This.oBackEnd.ExecuteNonQuery( lcCommand )

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loMyCA = Null
			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

			Set Date (lcDate)
			Set Century &lcCentury

		Endtry

		Return This.lIsOk

	Endproc && ExecuteNonQuery


	*
	*
	Procedure Put( oParam As Object ) As Boolean
		Local lcCommand As String,;
			lcDiffgram As String,;
			lcDeleted As String

		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local loTransaction As Transaction Of "ERP\Comunes\Sistema\Prg\Transaction.prg"

		Local lnTransactionId As Integer

		Local llOk As Boolean
		Local lllAlreadyConnected As Boolean

		Private pcXMLError As String

		Try

			lcCommand = ""
			pcXMLError = ""
			lcDeleted = Set("Deleted")

			llOk = .T.
			This.lTriggerFailed = .F.

			If Vartype( oParam ) = "O"
				If Pemstatus( oParam, "nEntidadId", 5 )
					This.nEntidadId = oParam.nEntidadId
				Endif
			Endif

			If This.lUseTransactions
				* RA 2013-08-16(17:45:56)
				* Por sugerencia de Dado, decidimos
				* no grabar la transaccion, sino implementar un
				* sistema de loggeo

				*!*					loTransaction = GetEntity( "Transaction" )
				*!*					loTransaction.OpenTransaction()

				*!*					loTransaction.nAction = This.nAction
			Endif

			Set Deleted Off

			* Proceso de actualizacion

			* Llegan los cursores actualizados en la coleccion colTables
			* Recorrer la coleccion generando los CursorAdapter por cada tabla
			* Abrir la transaccion
			* Recorrer la coleccion ejecutando TableUpdate() para cada tabla

			This.CrearCursorAdapters( oParam )

			If !This.lTriggerFailed

				* Ahora si, abro la transacción y ejecuto TableUpdate

				lllAlreadyConnected = This.ConnectToBackend() = 0
				This.TransactionBegin()

				loColTables = This.oColTables

				llOk = .T.

				For Each loTable In loColTables
					If llOk


						If This.lUseTransactions
							* RA 2013-08-16(17:45:56)
							* Por sugerencia de Dado, decidimos
							* no grabar la transaccion, sino implementar un
							* sistema de loggeo


							*!*								TEXT To lcCommand NoShow TextMerge Pretext 15
							*!*								Update <<loTable.CursorName>> Set
							*!*									Transaction_ID = <<loTransaction.TransactionID>>
							*!*									Where !Empty( ABM )
							*!*								ENDTEXT

							*!*								&lcCommand
						Endif

						If loTable.Nivel > 1
							This.UpdateChildren( loTable, This.nEntidadId )
						Endif

						Select Alias( loTable.CursorName )

						Locate
						Scan For Evaluate( loTable.CursorName + ".ABM" ) = ABM_BAJA While llOk

							If !Tableupdate( .F., .T., loTable.CursorName )
								llOk = .F.
							Endif

						Endscan


						Locate
						Scan For Evaluate( loTable.CursorName + ".ABM" ) = ABM_MODIFICACION While llOk

							If !Tableupdate( .F., .T., loTable.CursorName )
								llOk = .F.
							Endif

						Endscan

						Locate
						Scan For Evaluate( loTable.CursorName + ".ABM" ) = ABM_ALTA While llOk

							If !Tableupdate( .F., .T., loTable.CursorName )
								llOk = .F.

							Else
								If loTable.Nivel = 1
									* Es un alta, Guardo el Id para pasarlo a los hijos

									If !loTable.PKUpdatable
										* Es autoincremental
										This.nEntidadId = This.GetNewId( loTable.Name, loTable.PKName )
									Endif

								Endif
							Endif

						Endscan

					Endif
				Endfor

				If llOk
					This.TransactionEnd()

					If This.lUseTransactions
						* RA 2013-08-16(17:45:56)
						* Por sugerencia de Dado, decidimos
						* no grabar la transaccion, sino implementar un
						* sistema de loggeo

						*loTransaction.CloseTransaction()
					Endif

				Else
					Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
					loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					loError.Cremark = "Tableupdate Falló"
					loError.Process()

				Endif

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			llOk = .F.

			Try
				Do While !Empty( Txnlevel())
					This.TransactionRollBack()
				Enddo

			Catch

			Finally


			Endtry


			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

			This.KillCursorAdapters()

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

			loTable = Null
			loColTables = Null

			Set Deleted &lcDeleted

		Endtry

		Return llOk

	Endproc && Put



	*
	* Libera todos los CursorsAdapters asociados a las tablas
	Procedure KillCursorAdapters(  ) As Void;
			HELPSTRING "Libera todos los CursorsAdapters asociados a las tablas"
		Local lcCommand As String
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"


		Try

			lcCommand = ""
			loColTables = This.oColTables

			For Each loTable In loColTables
				If Vartype( loTable.oCursorAdapter ) == "O"
					If Lower( loTable.oCursorAdapter.BaseClass ) = Lower( "CursorAdapter" )
						loTable.oCursorAdapter.CursorDetach()
					Endif

					loTable.oCursorAdapter = Null
				Endif

			Endfor


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTable = Null
			loColTables = Null

		Endtry

	Endproc && KillCursorAdapters


	*
	* Actualiza el ParentId de los hijos en un insert
	Procedure UpdateChildren( oTable As Object,;
			nEntidadId As Integer ) As Void;
			HELPSTRING "Actualiza el ParentId de los hijos en un insert"

		Local lcCommand As String

		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local llOk As Boolean

		Try

			lcCommand 	= ""
			llOk 		= .T.

			loTable = oTable

			Select Alias( loTable.CursorName )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Replace All
				<<loTable.ForeignKey>> With <<nEntidadId>>
				In <<loTable.CursorName>>
			ENDTEXT

			&lcCommand


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loTable = Null

		Endtry

	Endproc && UpdateChildren


	*
	*
	Procedure GetNewId( tcTable As String, tcPKName As String ) As Integer
		Local lcCommand As String
		Local lnNewId As Integer

		Try

			lcCommand 	= ""
			lnNewId 	= 1

			lnNewId = This.oBackEnd.GetNewId( tcTable, tcPKName  )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry

		Return lnNewId

	Endproc && GetNewId

	*
	* Genera el diffgram
	Procedure GenerarDiffgram(  ) As Void;
			HELPSTRING "Genera el diffgram"
		Local lcCommand As String,;
			lcDiffgram As String

		Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'


		Try

			lcCommand 	= ""

			loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

			loXA.AddTableSchema( This.cMainCursorName )

			lcDiffgram 	= loXA.GetDiffGram()

			Use In Select( This.cMainCursorName )

			*!*				TEXT To lcLogDiffgramFile NoShow TextMerge Pretext 15
			*!*				Diffgram_<<This.cMainCursorName>>_<<Seconds()>>.txt
			*!*				ENDTEXT

			*!*				Strtofile( lcDiffgram, lcLogDiffgramFile )



		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loXA = Null

		Endtry

		Return lcDiffgram

	Endproc && GenerarDiffgram




	*
	* Crea los Cursor Adapters para cada tabla
	Procedure CrearCursorAdapters( oParam As Object ) As Void;
			HELPSTRING "Crea los Cursor Adapters para cada tabla"
		Local lcCommand As String,;
			lcDiffgram As String,;
			lcFieldList As String,;
			lcWhereCondition As String

		Local loMyCA As prxCursorAdapter Of "FW\TierAdapter\Comun\prxCursorAdapter.prg"
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"

		Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'


		Local llOk As Boolean

		Private pcXMLError As String


		Try

			lcCommand = ""
			pcXMLError = ""

			loColTables = This.oColTables

			lllAlreadyConnected = This.ConnectToBackend() = 0

			For Each loTable In loColTables

				If Vartype( oParam ) = "O"
					If Pemstatus( oParam, "cFilterCriteria", 5 )
						lcWhereCondition = oParam.cFilterCriteria

					Else
						TEXT To lcWhereCondition NoShow TextMerge Pretext 15
						<<loTable.PKName>> = <<This.nEntidadId>>
						ENDTEXT

					Endif

					If Pemstatus( oParam, "cFieldList", 5 )
						lcFieldList = oParam.cFieldList

					Else
						lcFieldList = " * "

					Endif


				Else
					lcFieldList = " * "
					TEXT To lcWhereCondition NoShow TextMerge Pretext 15
					<<loTable.PKName>> = <<This.nEntidadId>>
					ENDTEXT

				Endif

				This.ActualizarTimeStamp( loTable.CursorName )

				lcDiffgram = This.GenerarDiffgram()

				loMyCA 	= Newobject("prxCursorAdapter", "prxCursorAdapter.prg" ,;
					"",;
					This.cAccessType,;
					This.oConnection,;
					This.cBackEndEngine )

				loMyCA.lCloseNativeTables = This.lCloseNativeTables

				If Vartype( loTable.oCursorAdapter ) == "O"
					If Lower( loTable.oCursorAdapter.BaseClass ) = Lower( loMyCA.BaseClass )
						loTable.oCursorAdapter.CursorDetach()
					Endif

					loTable.oCursorAdapter = Null
				Endif

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Select 	<<lcFieldList>> ,
						" " as r7Mov,
						Cast( 0 as I ) as ABM,
						Cast( 0 as I ) as _RecordOrder
					From <<loTable.Tabla>>
					Where <<lcWhereCondition>>
				EndTex

				loMyCA.Alias 				= loTable.CursorName
				loMyCA.SelectCmd  			= lcCommand
				loMyCA.Tables 				= loTable.Tabla
				loMyCA.UpdatableFieldList 	= loTable.UpdatableFieldList
				loMyCA.UpdateNameList 		= loTable.UpdateNameList
				loMyCA.KeyFieldList 		= loTable.PKName

				loMyCA.CursorAttach( loTable.CursorName, .T. )

				llOk = loMyCA.CursorFill()

				If llOk

					* Aplicar Diffgram
					loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

					loXA.AddTableSchema( loTable.CursorName )
					loXA.LoadXML( lcDiffgram )

					Try

						Select Alias( loTable.CursorName )

						loXA.Tables( 1 ).ApplyDiffgram()

						loTable.oCursorAdapter = loMyCA

					Catch To oErr
						Do Case
						Case oErr.ErrorNo = 1539	&& Trigger failed in "cursor".
							This.lTriggerFailed = .T.

							If Vartype( pcXMLError ) = "C"
								Stop( pcXMLError, "Error de Integridad Referencial" )
							EndIf

						Otherwise
							Throw oErr

						EndCase

					Finally

					EndTry

				Else
					Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

					loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					loError.Cremark = "Falló CursorFill()"
					loError.Process()

				EndIf

			Endfor

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

			loXA	= Null
			loMyCA 	= Null

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

	Endproc && CrearCursorAdapters


	*
	* Crea los Cursor Adapters para cada tabla
	Procedure xxxCrearCursorAdapters( oParam As Object ) As Void;
			HELPSTRING "Crea los Cursor Adapters para cada tabla"
		Local lcCommand As String,;
			lcDiffgram As String,;
			lcFieldList As String,;
			lcWhereCondition As String

		Local loMyCA As prxCursorAdapter Of "FW\TierAdapter\Comun\prxCursorAdapter.prg"
		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'


		Local llOk As Boolean

		Private pcXMLError As String


		Try

			lcCommand = ""
			pcXMLError = ""

			loColTables = This.oColTables

			lllAlreadyConnected = This.ConnectToBackend() = 0

			For Each loTable In loColTables

				If Vartype( oParam ) = "O"
					If Pemstatus( oParam, "cFilterCriteria", 5 )
						lcWhereCondition = oParam.cFilterCriteria

					Else
						TEXT To lcWhereCondition NoShow TextMerge Pretext 15
						<<loTable.PKName>> = <<This.nEntidadId>>
				ENDTEXT

			Endif

			If Pemstatus( oParam, "cFieldList", 5 )
				lcFieldList = oParam.cFieldList

			Else
				lcFieldList = " * "

			Endif


		Else
			lcFieldList = " * "
			TEXT To lcWhereCondition NoShow TextMerge Pretext 15
					<<loTable.PKName>> = <<This.nEntidadId>>
			ENDTEXT

		Endif

		This.ActualizarTimeStamp( loTable.CursorName )

		*lcDiffgram = This.GenerarDiffgram()

		loMyCA 	= Newobject("prxCursorAdapter", "prxCursorAdapter.prg" ,;
			"",;
			This.cAccessType,;
			This.oConnection,;
			This.cBackEndEngine )

		loMyCA.lCloseNativeTables = This.lCloseNativeTables

		If Vartype( loTable.oCursorAdapter ) == "O"
			If Lower( loTable.oCursorAdapter.BaseClass ) = Lower( loMyCA.BaseClass )
				loTable.oCursorAdapter.CursorDetach()
			Endif

			loTable.oCursorAdapter = Null
		Endif

		TEXT To lcCommand NoShow TextMerge Pretext 15
				Select 	<<lcFieldList>> ,
						" " as r7Mov,
						Cast( 0 as I ) as ABM,
						Cast( 0 as I ) as _RecordOrder
					From <<loTable.Tabla>>
					Where <<lcWhereCondition>>
				EndTex

				loMyCA.Alias 				= loTable.CursorName
				loMyCA.SelectCmd  			= lcCommand
				loMyCA.Tables 				= loTable.Tabla
				loMyCA.UpdatableFieldList 	= loTable.UpdatableFieldList
				loMyCA.UpdateNameList 		= loTable.UpdateNameList
				loMyCA.KeyFieldList 		= loTable.PKName


				loMyCA.CursorAttach( loTable.CursorName, .T. )

				*llOk = loMyCA.CursorFill()
				llOk = .T.

				If llOk

					* Aplicar Diffgram
*!*						loXA = NewObject("prxXMLAdapter","prxXMLAdapter.prg")

*!*						loXA.AddTableSchema( loTable.CursorName )
*!*						loXA.LoadXML( lcDiffgram )

					Try

*!*							Select Alias( loTable.CursorName )

*!*							loXA.Tables( 1 ).ApplyDiffgram()

						loTable.oCursorAdapter = loMyCA

					Catch To oErr
						Do Case
						Case oErr.ErrorNo = 1539	&& Trigger failed in "cursor".
							This.lTriggerFailed = .T.

							If Vartype( pcXMLError ) = "C"
								Stop( pcXMLError, "Error de Integridad Referencial" )
							EndIf

						Otherwise
							Throw oErr

						EndCase

					Finally

					EndTry

				Else
					Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

					loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					loError.Cremark = "Falló CursorFill()"
					loError.Process()

				EndIf

			Endfor

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

			loXA	= Null
			loMyCA 	= Null

			If Not lllAlreadyConnected
				This.DisconnectFromBackend()
			Endif

		Endtry

	Endproc && CrearCursorAdapters

	*
	* ConnectToBackend
	*!*		Protected Function ConnectToBackend() As Boolean
	Function ConnectToBackend() As Boolean
		Local lnReturn As Integer


		Try

			lnReturn = This.oBackEnd.Connect()
			This.oConnection = This.oBackEnd.oConnection

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lnReturn

	Endfunc && ConnectToBackend


	*-----------------------------------
	* Se desconecta de la base de datos.
	*-----------------------------------
	*!*		Protected Function DisconnectFromBackend() As Boolean
	Function DisconnectFromBackend() As Boolean

		Local llOk As Boolean
		Try

			llOk = This.oBackEnd.DisConnect()

			This.oConnection = This.oBackEnd.oConnection

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return This.lIsOk

	Endfunc && DisconnectFromBackend

	*
	* Serializes a series of cursors to XML
	Protected Procedure Serialize( tcCommaSeparatedCursorList As String ) As String;
			HELPSTRING "Serializes a series of cursors to XML"


Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'
		Local lcRetVal As String
		Local i As Integer

		Try

			lcRetVal = ""

			If This.lSerialize

				loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

				For i = 1 To Getwordcount( tcCommaSeparatedCursorList, [,] )
					loXA.AddTableSchema( Alltrim( Getwordnum( tcCommaSeparatedCursorList, i, [,] ) ) )

				Endfor

				loXA.PreserveWhiteSpace = .T.
				loXA.ToXML( "lcRetVal" )
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loXA = Null

		Endtry

		Return lcRetVal

	Endproc && Serialize

	*
	* BuildCursor
	Procedure BuildCursor( tcCursorName As String, ;
			tcSelectCmd As String,;
			tnBuffering As Integer,;
			tlDontDetach As Boolean,;
			tlLogSelectCmd As Boolean ) As Object

		Local loMyCA As prxCursorAdapter Of "FW\TierAdapter\Comun\prxCursorAdapter.prg"
Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'


		Local llOk As Boolean
		Local lcAlias As String,;
			lcTableName As String

		Local loReturn As Object

		Try

			llOk = .T.
			lcAlias = Sys(2015)
			loReturn = Createobject( "Empty" )
			AddProperty( loReturn, "lOk", llOk )
			AddProperty( loReturn, "oMyCA", Null )
			AddProperty( loReturn, "oXA", Null )

			If Empty( tnBuffering )
				tnBuffering = This.nBuffering
			Endif

			loMyCA = Newobject( "prxCursorAdapter", "prxCursorAdapter.prg", "", This.cAccessType, This.oConnection, This.cBackEndEngine )

			loMyCA.lCloseNativeTables = This.lCloseNativeTables

			loMyCA.cOldSetCentury 	= Set( "Century" )
			loMyCA.cOldSetDate 		= Set( "Date" )
			
			If This.lSilence 
				If Empty( At( "NOCONSOLE", tcSelectCmd ))
					tcSelectCmd = tcSelectCmd + " NOCONSOLE"
				EndIf
			EndIf
			

			With loMyCA As CursorAdapter
				.Alias = tcCursorName
				.SelectCmd = tcSelectCmd
				llOk = .CursorFill()

				If !tlDontDetach
					.CursorDetach()

				Else
					* RA 2012-06-17(11:39:02)
					* Devuelve el cursor adapter listo para la actualizacion
					* contra la base de datos


					lcTableName = Getwordnum( This.GetTablesFromSQL( .SelectCmd ), 1, "," )

					*!*						loMyCA.UpdatableFieldList 	= This.GetUpdatableFieldList( lcTableName )
					*!*						loMyCA.UpdateNameList 		= This.GetUpdateNameList( .Alias, "", lcTableName )

					loReturn.oMyCA = loMyCA

					loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )
					loXA.AddTableSchema( .Alias )

					loReturn.oXA = loXA

				Endif

				If tlLogSelectCmd
					Strtofile( .SelectCmd + CRLF, "SelectCommand.prg", 1 )
				Endif


			Endwith

			If loMyCA.lHasError
				Throw loMyCA.oError

			Else
				If Empty( Txnlevel())
					If CursorGetProp("Buffering", tcCursorName ) # tnBuffering
						CursorSetProp( "Buffering", tnBuffering, tcCursorName )
					Endif
				Endif
			Endif



		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			llOk = .F.
			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loMyCA = Null

		Endtry

		Return loReturn

	Endproc && BuildCursor


	*
	* oBackEnd_Access
	Protected Procedure oBackEnd_Access()

		If Vartype( This.oBackEnd ) # "O"
			Do Case
				Case Upper(This.cAccessType)="NATIVE"
					This.oBackEnd = Newobject( "NativeBackEnd",;
						"fw\tieradapter\datatier\BackEndNative.prg" )

					This.oBackEnd.lUseDBC 			= This.lUseDBC
					This.oBackEnd.lUseTransactions 	= This.lUseTransactions

				Case Upper(This.cAccessType)="ODBC"
					This.oBackEnd = Newobject( "ODBCBackEnd",;
						"BackEndODBC.prg" )

					This.lUseDBC 			= .T.
					This.lUseTransactions 	= .T.

				Case Upper(This.cAccessType)="ADO"
					This.oBackEnd = Newobject( "ADOBackEnd",;
						"BackEndADO.prg" )

					This.lUseDBC 			= .T.
					This.lUseTransactions 	= .T.

				Otherwise
					Error "Data Access Type Not Recognized"

			Endcase

			If This.lUseDBC
				With This.oBackEnd As BackEnd Of "TierAdapter\DataTier\BackEnd.prg"
					.cDataBaseName 		= This.cDataBaseName
					.cStringConnection 	= This.cStringConnection
					.cBackEndEngine 	= This.cBackEndEngine
				Endwith
			Endif
		Endif

		Return This.oBackEnd

	Endproc && oBackEnd_Access



	*
	*
	Procedure TransactionBegin(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			This.lIsOk = This.oBackEnd.BeginTransaction()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && TransactionBegin



	*
	*
	Procedure TransactionEnd(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			This.lIsOk = This.oBackEnd.EndTransaction()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && TransactionEnd


	*
	*
	Procedure TransactionRollBack(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			This.oBackEnd.Rollback()


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && TransactionRollBack



	*
	* Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla
	Procedure GetUpdatableFieldListFromTable( tcTableName As String,;
			tcExcludeFieldList As String ) As Void;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String

		Local Array laFields[ 1 ]

		Local lnLen As Integer,;
			i As Integer

		Local llInList As Boolean

		Try

			lcCommand = ""
			lcFieldList = ""

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_-_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			lnLen = Afields( laFields, tcTableName )

			For i = 1 To lnLen
				lcField = laFields[ i, 1 ]

				TEXT To lcCommand NoShow TextMerge Pretext 15
					InList( '<<Lower( lcField )>>', <<tcExcludeFieldList>> )
		ENDTEXT

		llInList = &lcCommand

		If !llInList
			TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
						,<<lcField>>
			ENDTEXT

		Endif
	Endfor

	lcFieldList = Substr( lcFieldList, 2 )

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Cremark = lcCommand
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return lcFieldList

Endproc && GetUpdatableFieldListFromTable

*
* Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla
	Procedure GetUpdateNameListFromTable( tcCursorName As String,;
			tcExcludeFieldList As String,;
			tcTableName As String ) As Void;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String

		Local Array laFields[ 1 ]

		Local lnLen As Integer,;
			i As Integer

		Try

			lcCommand = ""
			lcFieldList = ""

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_-_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			lnLen = Afields( laFields, tcTableName )

			For i = 1 To lnLen
				lcField = laFields[ i, 1 ]

				TEXT To lcCommand NoShow TextMerge Pretext 15
				InList( '<<Lower( lcField )>>', <<tcExcludeFieldList>> )
				ENDTEXT

				llInList = &lcCommand

				If !llInList
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
					,<<lcField>> <<tcTableName>>.<<lcField>>
					ENDTEXT

				Endif
			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcFieldList

	Endproc && GetUpdateNameListFromTable



	*
	* Devuelve la lista de campos que se actualizan a partir del Diccionario de Datos
	Procedure GetUpdatableFieldList( tcTableName As String,;
			tcExcludeFieldList As String ) As Void;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String

		Local llInList As Boolean

		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColFields As colFields Of "Tools\Sincronizador\colDataBases.prg"
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"


		Try

			lcCommand = ""
			lcFieldList = ""

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_/-\_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			loColTables = NewColTables()
			loTable = loColTables.GetItem( tcTableName )
			loColFields = loTable.oColFields
			lcFieldList = ""

			For Each loField In loColFields
				lcField = Lower( loField.Name )

				TEXT To lcCommand NoShow TextMerge Pretext 15
					InList( '<<lcField>>', <<tcExcludeFieldList>> )
				ENDTEXT

				llInList = &lcCommand

				If !llInList
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
						,<<lcField>>
					ENDTEXT

				Endif
			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcFieldList

	Endproc && GetUpdatableFieldList

	*
	* Devuelve la lista de campos que se actualizan a partir del Diccionario de Datos
	Procedure GetUpdateNameList( tcCursorName As String,;
			tcExcludeFieldList As String,;
			tcTableName As String ) As Void;
			HELPSTRING "Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla"

		Local lcCommand As String,;
			lcFieldList As String,;
			lcField As String

		Local llInList As Boolean

		Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
		Local loColFields As colFields Of "Tools\Sincronizador\colDataBases.prg"
		Local loField As oField Of "Tools\Sincronizador\colDataBases.prg"


		Try

			lcCommand = ""
			lcFieldList = ""

			If Empty( tcExcludeFieldList )
				tcExcludeFieldList = ["_/-\_"]
			Endif

			tcExcludeFieldList = Lower( tcExcludeFieldList )

			loColTables = NewColTables()
			loTable = loColTables.GetItem( tcTableName )
			loColFields = loTable.oColFields
			lcFieldList = ""

			For Each loField In loColFields
				lcField = Lower( loField.Name )

				TEXT To lcCommand NoShow TextMerge Pretext 15
					InList( '<<lcField>>', <<tcExcludeFieldList>> )
				ENDTEXT

				llInList = &lcCommand

				If !llInList
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
					,<<lcField>> <<tcTableName>>.<<lcField>>
					ENDTEXT


				Endif
			Endfor

			lcFieldList = Substr( lcFieldList, 2 )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcFieldList

	Endproc && GetUpdateNameList

	*
	* GetTablesFromSQL
	* DAE 2009-10-21(13:42:12)
	Protected Function GetTablesFromSQL( tcSQL As String ) As String
		Local lcStr As String
		Local lcTablesNames As String
		Local lcTablesNameAux As String
		Local lcAux As String
		*
		Local lnCntFrom As Integer
		Local lnFromIndex As Integer
		Local lnCntJoin As Integer
		Local lnJoinIndex As Integer

		lcStr = ""
		lcAux = ""
		lcTablesNames = ""
		tcSQL = Upper( tcSQL )

		lcTablesNames = ''
		lcTablesNameAux = ''

		lnCntFrom = Occurs( "FROM", tcSQL )
		For lnFromIndex = 1 To lnCntFrom
			lcStr = Strextract( tcSQL, "FROM", "WHERE", lnFromIndex, 3 ) &&, 0, 3 )

			If Empty( lcStr )
				lcStr = Strextract( tcSQL, "FROM", '', lnFromIndex, 3 )

			Endif && Empty( lcStr )

			lcStr = Strextract( lcStr, "", "ORDER BY", 0, 3 )

			lcTablesNameAux = Strextract( lcStr, "", "JOIN", 0, 3 )

			lcAliasAux = This.ExtractAlias( lcTablesNameAux )
			If ! Inlist( lcAliasAux , '(', ')' )
				lcTablesNames = This.ConcatenarSiNoExiste( lcTablesNames, lcAliasAux )

			Endif && ! Inlist( lcAliasAux , '(', ')' )

		Endfor

		lnCntJoin = Occurs( "JOIN", tcSQL )
		For lnJoinIndex = 1 To lnCntJoin
			lcAux = Strextract( tcSQL, "JOIN ", " ON", lnJoinIndex, 3 )
			If ! Empty( lcAux )
				lcAliasAux = This.ExtractAlias( lcAux )
				If ! Inlist( lcAliasAux , '(', ')' )
					lcTablesNames = This.ConcatenarSiNoExiste( lcTablesNames, lcAliasAux )

				Endif && ! Inlist( lcAliasAux , '(', ')' )

			Endif && ! Empty( lcAux )

		Endfor

		Return lcTablesNames

	Endfunc && GetTablesFromSQL

	*
	* ConcatenarSiNoExiste
	* DAE 2009-10-21(13:42:04)
	Protected Function ConcatenarSiNoExiste( tcCadena As String, tcValor As String ) As String
		If ! ( tcValor $ tcCadena )
			If ! Empty( tcCadena )
				tcCadena = tcCadena + "," + tcValor

			Else
				tcCadena = tcValor

			Endif && ! Empty( tcCadena )

		Endif && ! ( tcValor $ tcCadena )

		Return tcCadena

	Endfunc && ConcatenarSiNoExiste

	* ExtractAlias
	Protected Function ExtractAlias( tcTablesNames As String ) As String

		Local lcAux As String
		lcAux = ""

		lcAux = Getwordnum( tcTablesNames, 1 )

		Do Case

			Case Empty( lcAux ) Or Inlist( Upper( lcAux ), "LEFT", "RIGHT", "INNER" )
				* lcAux  = Getwordnum( tcTablesNames, 1 )
				Error 'No existe el nombre de la tabla'

		Endcase

		Return lcAux

	Endfunc && ExtractAlias

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ReadIniFile
	*!* Description...: Leer el archivo de inicialización
	*!* Date..........: Jueves 5 de Enero de 2006 (09:28:41)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Menus
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ReadIniFile(  ) As Boolean;
			HELPSTRING "Leer el archivo de inicialización"

		Local loConfigData As Object
		Local lcCommand As String
		Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'


		Try

			lcCommand = ""

			If Empty( This.cDataBaseName )

				loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

				loXA.LoadXML( This.cBackEndCfgFileName, .T. )
				loXA.Tables(1).ToCursor()
				loXA = Null

				Locate For Alltrim( Lower( objName )) = Alltrim( Lower( This.cDataConfigurationKey ))
				If Eof()
					Locate For Alltrim( Lower(objName)) = "default"
				Endif

				This.cAccessType       = Alltrim(AccessType)
				This.cDataBaseName     = Alltrim(dbName)
				This.cStringConnection = Alltrim(StrConn)
				This.cBackEndEngine    = Iif(Empty(Alltrim(BkEngine)),"FOX",Alltrim(BkEngine))
				This.lDebugMode 	   = DebugComponent

				Use In Alias()

				Local loConfigData As Object
				loConfigData = Createobject( "Empty" )
				AddProperty( loConfigData, "cAccessType", This.cAccessType )
				AddProperty( loConfigData, "cDataBaseName", This.cDataBaseName )
				AddProperty( loConfigData, "cStringConnection", This.cStringConnection )
				AddProperty( loConfigData, "cBackEndEngine", This.cBackEndEngine )

				*!*	                This.PopulateConfigData( loConfigData )

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry

		Return This.lIsOk

	Endproc && ReadIniFile



	*
	*
	Procedure ActualizarTimeStamp( cCursorName As String ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If !Empty( Field( "TS", cCursorName ) )

				Select Alias( cCursorName )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update <<cCursorName>> Set
					TS = Datetime()
				ENDTEXT

				&lcCommand

				Locate

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && ActualizarTimeStamp

	*
	* cDataBaseName_Access
	Protected Procedure cDataBaseName_Access()

		If Empty( This.cDataBaseName )
			This.ReadIniFile()
		Endif
		Return This.cDataBaseName

	Endproc && cDataBaseName_Access

	*
	* cDataBaseName_Access
	Protected Procedure cBackEndCfgFileName_Access()

		If Empty( This.cBackEndCfgFileName )
			This.cBackEndCfgFileName = Addbs( This.cRootFolder ) + "DataTier.xml"
		Endif
		Return This.cBackEndCfgFileName

	Endproc && cBackEndCfgFileName _Access


	*
	*
	Procedure Destroy(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			DoDefault()

			This.oColTables = Null

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Cremark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Destroy


	*
	* oBiz_Access
	Protected Procedure oBiz_Access()
		Return This.oBiz

	Endproc && oBiz_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oDataTier2
*!*
*!* ///////////////////////////////////////////////////////