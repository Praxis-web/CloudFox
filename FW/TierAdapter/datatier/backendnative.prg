*!* ///////////////////////////////////////////////////////
*!* Class.........: NativeBackEnd
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Conección a Base de Datos Nativa
*!* Date..........: Martes 13 de Diciembre de 2005 (18:24:22)
*!* Author........: Ricardo Aidelman
*!* Project.......: Visual Praxis Beta v. 1.1
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#INCLUDE "Fw\comunes\Include\Praxis.h"
#INCLUDE "Tools\DataDictionary\Include\DataDictionary.h"

External Procedure ;
	'ErrorHandler\Prg\ErrorHandler.prg',;
	'Tools\DataDictionary\prg\oField.prg',;
	'Tools\Namespaces\Prg\ObjectNamespace.prg',;
	'Tools\DataDictionary\prg\oDataBase.prg',;
	'Tools\DataDictionary\prg\CollectionBase.prg',;
	'Tools\DataDictionary\prg\oSync.prg'

Define Class NativeBackEnd As BackEnd Of "FW\TierAdapter\DataTier\BackEnd.prg"


	#If .F.
		Local This As NativeBackEnd Of "FW\TierAdapter\DataTier\BackEndNative.prg"
	#Endif

	* Indica si son tablas libres o utiliza una DBC
	lUseDBC = .F.

	* Indica si se utilizan transacciones
	lUseTransactions = .T.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lusedbc" type="property" display="lUseDBC" />] + ;
		[<memberdata name="lusetransactions" type="property" display="lUseTransactions" />] + ;
		[<memberdata name="create" type="method" display="Create" />] + ;
		[</VFPData>]

	Function Connect(  ) As Integer;
			HELPSTRING "Se conecta con la base de datos"

		Local lnRetVal As Integer

		Local lcCommand As String,;
			lcOldDeleted As String

		Local loErr As Exception

		Try

			lcCommand = ""

			lcOldDeleted = Set("Deleted")
			lnRetVal = 0

			If This.lUseDBC

				* Added to force the setting under COM+
				Set Deleted On

				If Not Dbused(Juststem(This.cDataBaseName))
					Open Database (This.cDataBaseName) Shared
					lnRetVal = 1

				Else
					Set Database To Juststem(This.cDataBaseName)

				Endif
			Endif


		Catch To loErr
			lnRetVal = -1

			If loErr.ErrorNo = 1
				lnRetVal = This.Create()

			Else
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				DEBUG_CLASS_EXCEPTION
				*!* DEBUG_EXCEPTION
				loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = lcCommand
				m.loError.Process ( m.loErr )
				THROW_EXCEPTION
			Endif

		Finally



			* No se si esto afecta COM+ si lcOldDeleted = OFF
			* Se usa en el caso de agregar un código en forma correlativa
			* Si el último codigo está deletado, debo considerarlo igualmente
			Set Deleted &lcOldDeleted

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

		Try

			llRetVal = .T.

			If This.lUseDBC
				If Dbused(Juststem(This.cDataBaseName))
					Set Database To Juststem(This.cDataBaseName)
					Close Database
				Endif
			Endif

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

		Local lnRetVal As Integer,;
			i As Integer,;
			lnLen As Integer

		Local llAlreadyOpen As Boolean,;
			llAlreadyConnected As Boolean

		Try

			If Used( tcTable )
				llAlreadyOpen = .T.

			Else
				llAlreadyOpen = .F.
				llAlreadyConnected = This.Connect() = 0

				Use ( tcTable ) Shared In 0

			Endif

			lnLen = Afields( laField, tcTable )
			i = Ascan( laField, tcPKName, 1, lnLen, 1, 15 )
			lnRetVal = laField[ i, 17 ] - 1

			If !llAlreadyOpen
				Use In Select( tcTable )

				If !llAlreadyConnected
					This.Disconnect()
				Endif

			Endif

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

		Finally

		Endtry

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
			If This.lUseTransactions
				Begin Transaction
				*TransactionBegin()
			Endif

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

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
			If This.lUseTransactions
				If !Empty( Txnlevel() )
					End Transaction
				Endif
			Endif

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

		Finally

		Endtry


		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE EndTransaction
	*!*
	*!* ///////////////////////////////////////////////////////

	Procedure Rollback(  ) As Boolean;
			HELPSTRING "Hace un RollBack"

		Local llOk As Boolean

		Try

			llOk = .T.
			If This.lUseTransactions
				If !Empty( Txnlevel() )
					Rollback
				Endif
			Endif

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

		Finally

		Endtry

		Return llOk


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

			lcCommand = ""
			llOk = .F.

			If This.BeginTransaction()
				&cSQLCommand

				If This.EndTransaction()
					llOk = .T.

				Else
					This.Rollback()

				Endif

			Endif


		Catch To oErr

			llOk = .F.

			Try

				This.Rollback()

			Catch

			Finally

			Endtry

			loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Cremark = cSQLCommand

			If Vartype( pcXMLError ) = "C" And !Empty( pcXMLError )
				loError.Process( oErr, .F., .T. )

			Else
				loError.Process( oErr )

			Endif

			*!*				Throw loError

		Finally

		Endtry

		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE ExecuteNonQuery
	*!*
	*!* ///////////////////////////////////////////////////////


	*
	*
	Procedure Create(  ) As Void
		Local lcCommand As String
		Local lnRetVal As Integer
		Local loGlobalSettings As GlobalSettings2 Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loColDataBases As oColDataBases2 Of "Fw\Sysadmin\Setup\Prg\Setup_Main.prg",;
			loSync As oSync Of 'Tools\DataDictionary\prg\osync.prg'


		Try

			lcCommand = ""
			lnRetVal = 0

			Try
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Md <<JustPath( This.cDataBaseName )>>
				ENDTEXT

				&lcCommand

			Catch To oErr

			Finally

			Endtry

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Database <<This.cDataBaseName>>
			ENDTEXT

			&lcCommand

			loGlobalSettings 	= NewGlobalSettings( 2 )
			loColDataBases 		= loGlobalSettings.oDataBases

			loSync = _NewObject( "oSync", "Tools\DataDictionary\Prg\oSync.prg" )
			loSync.Process( loColDataBases )

			lnRetVal = 1


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			*!* DEBUG_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			Wait Clear

			loSync 				= Null
			loColDataBases 		= Null
			loGlobalSettings 	= Null


		Endtry

		Return lnRetVal

	Endproc && Create

	*
	* oSync_Access
	Protected Procedure oSync_Access()
		If Vartype( This.oSync ) # "O"
			This.oSync = Createobject( "oSyncNative" )
			This.oSync.oDataEngine = This
		Endif
		Return This.oSync

	Endproc && oSync_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: NativeBackEnd
*!*
*!* ///////////////////////////////////////////////////////

*
* oSync
Define Class oSyncNative As oSync Of 'Tools\DataDictionary\prg\oSync.prg'

	#If .F.
		Local This As oSyncNative Of "FW\TierAdapter\DataTier\BackEndNative.prg"
	#Endif

	*!* Objeto para acceder a la base de datos
	oDataEngine = Null

	* Flag que indica que guarda y reastaura para lograr mejor performance
	lSaveAndRestore = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="createindexesinfreetable" type="method" display="CreateIndexesInFreeTable" />] + ;
		[<memberdata name="odataengine" type="property" display="oDataEngine" />] + ;
		[<memberdata name="savetable" type="method" display="SaveTable" />] + ;
		[<memberdata name="restoretable" type="method" display="RestoreTable" />] + ;
		[<memberdata name="lsaveandrestore" type="property" display="lSaveAndRestore" />] + ;
		[</VFPData>]


	*
	* Sincroniza la Tabla con la definición de la misma
	Procedure Synchronize( toTable As Object ) As Boolean ;
			HELPSTRING "Sincroniza la Tabla con la definición de la misma"

		Local lcCommand As String,;
			lcFile As String,;
			lcFullTableName As String,;
			lcFieldType As String

		Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg",;
			loField As oField Of "Tools\DataDictionary\prg\oField.prg"

		Local Array laFields[ 1 ]
		Local llOk As Boolean,;
			llClose As Boolean
		Local i As Integer

		Try

			lcCommand 	= ""
			llOk 		= .T.
			llClose 	= .F.
			loTable		= toTable

			TEXT To lcFullTableName NoShow TextMerge Pretext 15
			<<Addbs( loTable.cFolder )>><<loTable.Name>>.<<loTable.cExt>>
			EndText
			

			If ! Used( loTable.cLongTableName )
				llClose = .T.

				Try

					If loTable.lIsFree
						lcFile = Addbs( loTable.cFolder ) + loTable.Name + "." + loTable.cExt

						Use ( lcFile ) Shared

					Else
						Use ( loTable.cLongTableName ) Shared

					Endif

				Catch To loErr When loErr.ErrorNo = 1

					If ! Indbc( loTable.cLongTableName, 'TABLE' )
						TEXT To lcCommand NoShow TextMerge Pretext 15
                       	Add Table '<<Addbs( loTable.cFolder ) + loTable.Name + "." + loTable.cExt>>' Name '<<loTable.cLongTableName>>'

						ENDTEXT

						&lcCommand

					Endif

				Catch To loErr
					Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
					DEBUG_CLASS_EXCEPTION
					*!* DEBUG_EXCEPTION
					loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
					loError.cRemark = lcCommand
					m.loError.Process ( m.loErr )
					THROW_EXCEPTION


				Finally

				Endtry
			Endif

			Select Alias( loTable.cLongTableName )

			lnLen = Afields( laFields, loTable.cLongTableName )
			loColFields = loTable.oColFields

			* Chequear los campos existentes
			For Each loField In loColFields

				If .T. && !loField.lIsSystem

					i = Ascan( laFields, loField.Name, 1, lnLen, 1, 9 )

					If Empty( i )
						llOk = .F.
					Endif

					If llOk

						lcFieldType = Lower( loField.cFieldType )

						Do Case
							Case Inlist( Lower( loField.cFieldType ), "w", "blob" )
								loField.cFieldType = "W"
								loField.nFieldWidth = 4

							Case Inlist( Lower( loField.cFieldType ), "c", "char", "character" )
								loField.cFieldType = "C"

							Case Inlist( Lower( loField.cFieldType ), "y", "currency", "money" )
								loField.cFieldType = "Y"
								loField.nFieldWidth = 8

							Case Inlist( Lower( loField.cFieldType ), "t", "datetime" )
								loField.cFieldType = "T"
								loField.nFieldWidth = 8

							Case Inlist( Lower( loField.cFieldType ), "d", "date" )
								loField.cFieldType = "D"
								loField.nFieldWidth = 8

							Case Inlist( Lower( loField.cFieldType ), "g", "general" )
								loField.cFieldType = "G"
								loField.nFieldWidth = 4

							Case Inlist( Lower( loField.cFieldType ), "i", "int", "integer", "long" )
								loField.cFieldType = "I"
								loField.nFieldWidth = 4

							Case Inlist( Lower( loField.cFieldType ), "l", "logical", "boolean", "bit" )
								loField.cFieldType = "L"
								loField.nFieldWidth = 1

							Case Inlist( Lower( loField.cFieldType ), "m", "memo" )
								loField.cFieldType = "M"
								loField.nFieldWidth = 4

							Case Inlist( Lower( loField.cFieldType ), "n", "num", "numeric" )
								loField.cFieldType = "N"

							Case Inlist( Lower( loField.cFieldType ), "f", "float" )
								* Included for compatibility, the Float data type is functionally equivalent to Numeric.
								* Same as Numeric
								loField.cFieldType = "F"

							Case Inlist( Lower( loField.cFieldType ), "q", "varbinary" )
								loField.cFieldType = "Q"

							Case Inlist( Lower( loField.cFieldType ), "v", "varchar" )
								loField.cFieldType = "V"

							Case Inlist( Lower( loField.cFieldType ), "b", "double" )
								loField.cFieldType = "B"

							Otherwise

						Endcase

						llOk = ( loField.cFieldType 	= laFields[ i, 2 ] ) And llOk
						llOk = ( loField.nFieldWidth 	= laFields[ i, 3 ] ) And llOk
						llOk = ( loField.nFieldPrecision = laFields[ i, 4 ] ) And llOk

					Endif

					If !llOk
						Exit
					Endif

				Endif

			Endfor
		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loField = Null
			loTable = Null

			If llClose
				*!*					Use In Select( loTable.cLongTableName )
			Endif


		Endtry

		Return llOk

	Endproc && Synchronize


	Procedure AlterTable ( toTable As Object ) As Void


		Local llDone As Boolean,;
			llLoop As Boolean,;
			llClose As Boolean,;
			llAdd As Boolean

		Local laFields[1]

		Local lnLen As Integer,;
			i As Integer,;
			lnIndex As Integer,;
			lnRecCount As Integer

		Local lnSize As Number

		Local lcCommand As String,;
			lcErrMesg As String,;
			lcFolder As String,;
			lcFile As String

		Local luValue As Variant

		Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg",;
			loField As oField Of "Tools\DataDictionary\prg\oField.prg",;
			loIndex As oIndex Of "Tools\DataDictionary\prg\oIndex.prg",;
			loColFields As oColFields Of "Tools\DataDictionary\prg\oColFields.prg",;
			loColIndexes As oColIndexes Of "Tools\DataDictionary\prg\oColIndexes.prg",;
			loErr As Exception

		Try

			lcCommand = ""
			llClose = .F.
			llAdd = .F.
			lcFile = ""
			This.lSaveAndRestore = .F.

			If Vartype ( m.toTable ) = 'O'

				If ! toTable.lIsVirtual

					loTable = toTable

					If ! Used( loTable.cLongTableName ) Or !Isexclusive( loTable.cLongTableName )

						llClose = .T.

						Try

							If loTable.lIsFree
								lcFile = Addbs( loTable.cFolder ) + loTable.Name + "." + loTable.cExt

								Try
									Use ( lcFile ) Exclusive

								Catch To oErr When oErr.ErrorNo = 1707 && No se encuentra el archivo .CDX estructural.
									Use ( lcFile ) Exclusive

								Catch To oErr
									Throw oErr

								Finally

								Endtry

							Else
								Use ( loTable.cLongTableName ) Exclusive

							Endif

						Catch To oErr When oErr.ErrorNo = 1

							If ! Indbc( loTable.cLongTableName, 'TABLE' )
								TEXT To lcCommand NoShow TextMerge Pretext 15
                       			Add Table '<<Addbs( loTable.cFolder ) + loTable.Name + "." + loTable.cExt>>' Name '<<loTable.cLongTableName>>'

								ENDTEXT

								&lcCommand

							Endif

						Catch To oErr
							Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
							DEBUG_CLASS_EXCEPTION
							*!* DEBUG_EXCEPTION
							loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
							loError.cRemark = lcCommand
							m.loError.Process ( m.loErr )
							THROW_EXCEPTION

						Finally

						Endtry
					Endif

					Select Alias( loTable.cLongTableName )

					Delete Tag All

					lnLen = Afields( laFields, loTable.cLongTableName )
					* @TODO Damian Eiff 2009-09-15 (13:49:13)
					* Detectar si la tabla tiene registros para iniciar los campos
					* antes de aplicar las reglas de campo.
					lnRecCount = Reccount( loTable.cLongTableName )

					If !Empty( lcFile )
						lnSize = FileSize( lcFile, "M" )
						If lnSize > 10
							This.lSaveAndRestore = .T.

							This.lSaveAndRestore = This.SaveTable( lcFile )
						Endif
					Endif

					If This.lSaveAndRestore
						Zap In ( loTable.cLongTableName )
					Endif

					loColFields = loTable.oColFields
					loColIndexes = loTable.oColIndexes

					* Agregar/modificar los campos existentes
					For Each loField In loColFields

						llAdd = .F.

						If ! loField.lIsVirtual
							llDone = .F.

							Do While ! llDone
								llLoop = .F.
								lcCommand = "Alter Table " + loTable.cLongTableName

								i = Ascan( laFields, loField.Name, 1, lnLen, 1, 9 )

								If ! Empty( i )
									lcCommand = lcCommand + " Alter "

									* Si es autoincremental, hay que conservar los datos

									If loField.lAutoinc
										loField.nNextvalue = laFields[ i, 17 ]
										loField.nStepValue = laFields[ i, 18 ]

									Endif && loField.Autoinc

								Else
									lcCommand = lcCommand + " Add "
									llAdd = .T.

								Endif && ! Empty( i )

								lcCommand = lcCommand + "Column " + loField.Name + " " + loField.cFieldType

								If ! Empty( loField.nFieldWidth )
									lcCommand = lcCommand + "(" + Transform( loField.nFieldWidth )
									If ! Empty( loField.nFieldPrecision )
										lcCommand = lcCommand + "," + Transform( loField.nFieldPrecision )

									Endif

									lcCommand = lcCommand + ")"

								Endif && ! Empty( loField.nFieldWidth )

								If loField.lNull
									lcCommand = lcCommand + " NULL "

								Else
									lcCommand = lcCommand + " NOT NULL "

								Endif

								If !loTable.lIsFree
									If ! Empty( loField.cCheck )
										lcCommand = lcCommand + " CHECK " + Transform( loField.cCheck )
										If ! Empty( loField.cErrorMessage )
											loField.cErrorMessage = loTable.cLongTableName + ": " + loField.cErrorMessage
											lcCommand = lcCommand + " ERROR [" + loField.cErrorMessage + "]"

										Endif && ! Empty( loField.ErrorMessage )

									Endif && ! Empty( loField.Check )

									If loField.lAutoinc
										lcCommand = lcCommand + " AUTOINC "
										If !Empty( loField.nNextvalue )
											lcCommand = lcCommand + " NEXTVALUE " + Transform( loField.nNextvalue )

											If ! Empty( loField.nStepValue )
												lcCommand = lcCommand + " STEP " + Transform( loField.nStepValue )

											Endif

										Endif
									Endif

									If ! IsEmpty( loField.Default )
										lcCommand = lcCommand + " DEFAULT " + Transform( loField.Default )

									Endif && ! IsEmpty( loField.Default )

									If loField.nIndexKey # IK_NOKEY
										loIndex = loColIndexes.New()
										loIndex.nKeyType = loField.nIndexKey
										If loField.lCaseSensitive
											loIndex.cKeyExpression = loField.Name

										Else
											loIndex.cKeyExpression = "Lower( " + loField.Name + " )"

										Endif

										If Empty( loField.cTagName )
											loField.cTagName = Substr( loField.Name, 1, 10 )

										Endif && Empty( loField.cTagName )

										loIndex.cTagName = loField.cTagName
										loIndex.cCollate = loField.cCollate
										loIndex.Name = loField.Name
										loIndex.cReferences = loField.cReferences
										loIndex.cParentTagName = loField.cParentTagName
										loIndex.cTriggerConditionForDelete = loField.cTriggerConditionForDelete
										loIndex.cTriggerConditionForInsert = loField.cTriggerConditionForInsert
										loIndex.cTriggerConditionForUpdate = loField.cTriggerConditionForUpdate
										* Modificado 2009-03-10 - Eiff Damián
										loIndex.cParentPk = loField.cParentPk

										loColIndexes.AddIndex( loIndex )
										loIndex = Null

									Endif

									If loField.lNoCPTrans
										lcCommand = lcCommand + " NOCPTRANS "

									Endif && loField.NoCPTrans

									If loField.lNovalidate
										lcCommand = lcCommand + " NOVALIDATE "

									Endif && loField.Novalidate
								Endif

								Try

									&lcCommand

								Catch To oErr
									lcErrMesg = oErr.Message + CR + CR

									Do Case
										Case oErr.ErrorNo = Field_name_validation_rule_is_violated
											lcErrMesg = lcErrMesg + "¿Desea cancelar la regla de validación?"

											If Messagebox( lcErrMesg,;
													MB_YESNO + MB_ICONEXCLAMATION,;
													"Error en Alter Table" ) = IDYES

												loField.cCheck = ""
												loField.cErrorMessage = ""

												i = loColIndexes.GetKey( Lower( loField.Name ) )

												If ! Empty( i )
													loColIndexes.Remove( i )

												Endif && ! Empty( i )

												Warning( "No olvide ejecutar nuevamente" + CR +;
													"el SINCRONIZADOR una vez corregida" + CR +;
													"la REGLA DE VALIDACION" )

												llLoop = .T.

											Else
												Throw oErr

											Endif

										Otherwise
											Strtofile( lcCommand, "_ERROR_AlterTable.prg", 0 )
											Throw oErr

									Endcase

								Finally

								Endtry

								If llLoop
									Loop

								Endif && llLoop

								If llAdd  And ! IsEmpty( loField.Default )

									If Vartype( loField.Default ) = "C" ;
											And !Inlist( loField.cFieldType, 'C', 'V', 'M', 'Q' )

										luValue = Evaluate( loField.Default )

									Else
										luValue = loField.Default

									Endif

									TEXT To lcCommand NoShow TextMerge Pretext 15
									Update <<loTable.Name>> Set
										<<loField.Name>> = luValue
									ENDTEXT

									&lcCommand

								Endif

								If !loTable.lIsFree
									If .T. && ! IsRuntime()
										DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "DisplayClassLibrary" , loField.cDisplayClassLibrary )
										DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "DisplayClass", loField.cDisplayClass )
										DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "Comment", loField.Comment )
										DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "Format", loField.cFormat )
										DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "InputMask", loField.cInputMask )

									Endif && ! IsRuntime()

									DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "Caption", loField.cCaption )

									*!* DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "RuleExpression", loField.cCheck )
									*!* DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "RuleText", loField.cErrorMessage )
								Endif

								llDone = .T.

							Enddo

						Endif && ! loField.lIsVirtual

					Endfor

					If !loTable.lAdditive

						* Eliminar los campos dados de baja
						For i = 1 To lnLen
							lnIndex = loColFields.GetKey( Lower( laFields[ i, 1 ] ))
							If Empty( lnIndex )
								lcCommand = "Alter Table " + loTable.cLongTableName
								lcCommand = lcCommand + " DROP COLUMN " + Lower( laFields[ i, 1 ] )
								&lcCommand

							Endif
						Endfor

					Endif

					If !Empty( Field( "Dummy", loTable.Name ) )
						lcCommand = "Alter Table " + loTable.cLongTableName
						lcCommand = lcCommand + " DROP COLUMN Dummy "
						&lcCommand
					Endif

					If !loTable.lIsFree
						This.CreateIndexes( IK_PRIMARY_KEY, loTable )
						DBSetProp( loTable.cLongTableName, "TABLE", "Comment", loTable.Comment )
					Endif

					This.GenerateIndexes( loTable )

					If This.lSaveAndRestore
						This.RestoreTable( lcFile )
					Endif

				Endif && ! loTable.lIsVirtual

			Else
				Error 'Argumento invalido loTable. Se esperaba un objeto '

			Endif && Vartype( loTable ) = 'O'

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			If llClose
				*!*					Use In Select( loTable.cLongTableName )
			Endif


		Endtry

	Endproc && AlterTable

	Procedure xxxxAlterTable ( toTable As Object ) As Void


		Local llDone As Boolean,;
			llLoop As Boolean,;
			llClose As Boolean,;
			llAdd As Boolean

		Local laFields[1]

		Local lnLen As Integer,;
			i As Integer,;
			lnIndex As Integer,;
			lnRecCount As Integer

		Local lcCommand As String,;
			lcErrMesg As String,;
			lcFolder As String,;
			lcFile As String

		Local luValue As Variant

		Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg",;
			loField As oField Of "Tools\DataDictionary\prg\oField.prg",;
			loIndex As oIndex Of "Tools\DataDictionary\prg\oIndex.prg",;
			loColFields As oColFields Of "Tools\DataDictionary\prg\oColFields.prg",;
			loColIndexes As oColIndexes Of "Tools\DataDictionary\prg\oColIndexes.prg",;
			loErr As Exception

		Try

			lcCommand = ""
			llClose = .F.
			llAdd = .F.

			If Vartype ( m.toTable ) = 'O'

				If ! toTable.lIsVirtual

					loTable = toTable

					If ! Used( loTable.cLongTableName ) Or !Isexclusive( loTable.cLongTableName )

						llClose = .T.

						Try

							If loTable.lIsFree
								lcFile = Addbs( loTable.cFolder ) + loTable.Name + "." + loTable.cExt

								Try
									Use ( lcFile ) Exclusive

								Catch To oErr When oErr.ErrorNo = 1707 && No se encuentra el archivo .CDX estructural.
									Use ( lcFile ) Exclusive

								Catch To oErr
									Throw oErr

								Finally

								Endtry

							Else
								Use ( loTable.cLongTableName ) Exclusive

							Endif

						Catch To oErr When oErr.ErrorNo = 1

							If ! Indbc( loTable.cLongTableName, 'TABLE' )
								TEXT To lcCommand NoShow TextMerge Pretext 15
                       			Add Table '<<Addbs( loTable.cFolder ) + loTable.Name + "." + loTable.cExt>>' Name '<<loTable.cLongTableName>>'

								ENDTEXT

								&lcCommand

							Endif

						Catch To oErr
							Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
							DEBUG_CLASS_EXCEPTION
							*!* DEBUG_EXCEPTION
							loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
							loError.cRemark = lcCommand
							m.loError.Process ( m.loErr )
							THROW_EXCEPTION

						Finally

						Endtry
					Endif

					Select Alias( loTable.cLongTableName )

					Delete Tag All

					lnLen = Afields( laFields, loTable.cLongTableName )
					* @TODO Damian Eiff 2009-09-15 (13:49:13)
					* Detectar si la tabla tiene registros para iniciar los campos
					* antes de aplicar las reglas de campo.
					lnRecCount = Reccount( loTable.cLongTableName )

					loColFields = loTable.oColFields
					loColIndexes = loTable.oColIndexes

					* Agregar/modificar los campos existentes
					For Each loField In loColFields

						llAdd = .F.

						If ! loField.lIsVirtual
							llDone = .F.

							Do While ! llDone
								llLoop = .F.
								lcCommand = "Alter Table " + loTable.cLongTableName

								i = Ascan( laFields, loField.Name, 1, lnLen, 1, 9 )

								If ! Empty( i )
									lcCommand = lcCommand + " Alter "

									* Si es autoincremental, hay que conservar los datos

									If loField.lAutoinc
										loField.nNextvalue = laFields[ i, 17 ]
										loField.nStepValue = laFields[ i, 18 ]

									Endif && loField.Autoinc

								Else
									lcCommand = lcCommand + " Add "
									llAdd = .T.

								Endif && ! Empty( i )

								lcCommand = lcCommand + "Column " + loField.Name + " " + loField.cFieldType

								If ! Empty( loField.nFieldWidth )
									lcCommand = lcCommand + "(" + Transform( loField.nFieldWidth )
									If ! Empty( loField.nFieldPrecision )
										lcCommand = lcCommand + "," + Transform( loField.nFieldPrecision )

									Endif

									lcCommand = lcCommand + ")"

								Endif && ! Empty( loField.nFieldWidth )

								If loField.lNull
									lcCommand = lcCommand + " NULL "

								Else
									lcCommand = lcCommand + " NOT NULL "

								Endif

								If !loTable.lIsFree
									If ! Empty( loField.cCheck )
										lcCommand = lcCommand + " CHECK " + Transform( loField.cCheck )
										If ! Empty( loField.cErrorMessage )
											loField.cErrorMessage = loTable.cLongTableName + ": " + loField.cErrorMessage
											lcCommand = lcCommand + " ERROR [" + loField.cErrorMessage + "]"

										Endif && ! Empty( loField.ErrorMessage )

									Endif && ! Empty( loField.Check )

									If loField.lAutoinc
										lcCommand = lcCommand + " AUTOINC "
										If !Empty( loField.nNextvalue )
											lcCommand = lcCommand + " NEXTVALUE " + Transform( loField.nNextvalue )

											If ! Empty( loField.nStepValue )
												lcCommand = lcCommand + " STEP " + Transform( loField.nStepValue )

											Endif

										Endif
									Endif

									If ! IsEmpty( loField.Default )
										lcCommand = lcCommand + " DEFAULT " + Transform( loField.Default )

									Endif && ! IsEmpty( loField.Default )

									If loField.nIndexKey # IK_NOKEY
										loIndex = loColIndexes.New()
										loIndex.nKeyType = loField.nIndexKey
										If loField.lCaseSensitive
											loIndex.cKeyExpression = loField.Name

										Else
											loIndex.cKeyExpression = "Lower( " + loField.Name + " )"

										Endif

										If Empty( loField.cTagName )
											loField.cTagName = Substr( loField.Name, 1, 10 )

										Endif && Empty( loField.cTagName )

										loIndex.cTagName = loField.cTagName
										loIndex.cCollate = loField.cCollate
										loIndex.Name = loField.Name
										loIndex.cReferences = loField.cReferences
										loIndex.cParentTagName = loField.cParentTagName
										loIndex.cTriggerConditionForDelete = loField.cTriggerConditionForDelete
										loIndex.cTriggerConditionForInsert = loField.cTriggerConditionForInsert
										loIndex.cTriggerConditionForUpdate = loField.cTriggerConditionForUpdate
										* Modificado 2009-03-10 - Eiff Damián
										loIndex.cParentPk = loField.cParentPk

										loColIndexes.AddIndex( loIndex )
										loIndex = Null

									Endif

									If loField.lNoCPTrans
										lcCommand = lcCommand + " NOCPTRANS "

									Endif && loField.NoCPTrans

									If loField.lNovalidate
										lcCommand = lcCommand + " NOVALIDATE "

									Endif && loField.Novalidate
								Endif

								Try

									&lcCommand

								Catch To oErr
									lcErrMesg = oErr.Message + CR + CR

									Do Case
										Case oErr.ErrorNo = Field_name_validation_rule_is_violated
											lcErrMesg = lcErrMesg + "¿Desea cancelar la regla de validación?"

											If Messagebox( lcErrMesg,;
													MB_YESNO + MB_ICONEXCLAMATION,;
													"Error en Alter Table" ) = IDYES

												loField.cCheck = ""
												loField.cErrorMessage = ""

												i = loColIndexes.GetKey( Lower( loField.Name ) )

												If ! Empty( i )
													loColIndexes.Remove( i )

												Endif && ! Empty( i )

												Warning( "No olvide ejecutar nuevamente" + CR +;
													"el SINCRONIZADOR una vez corregida" + CR +;
													"la REGLA DE VALIDACION" )

												llLoop = .T.

											Else
												Throw oErr

											Endif

										Otherwise
											Strtofile( lcCommand, "_ERROR_AlterTable.prg", 0 )
											Throw oErr

									Endcase

								Finally

								Endtry

								If llLoop
									Loop

								Endif && llLoop

								If llAdd  And ! IsEmpty( loField.Default )

									If Vartype( loField.Default ) = "C" ;
											And !Inlist( loField.cFieldType, 'C', 'V', 'M', 'Q' )

										luValue = Evaluate( loField.Default )

									Else
										luValue = loField.Default

									Endif

									TEXT To lcCommand NoShow TextMerge Pretext 15
									Update <<loTable.Name>> Set
										<<loField.Name>> = luValue
									ENDTEXT

									&lcCommand

								Endif

								If !loTable.lIsFree
									If .T. && ! IsRuntime()
										DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "DisplayClassLibrary" , loField.cDisplayClassLibrary )
										DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "DisplayClass", loField.cDisplayClass )
										DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "Comment", loField.Comment )
										DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "Format", loField.cFormat )
										DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "InputMask", loField.cInputMask )

									Endif && ! IsRuntime()

									DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "Caption", loField.cCaption )

									*!* DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "RuleExpression", loField.cCheck )
									*!* DBSetProp( loTable.cLongTableName + "." + loField.Name, "FIELD", "RuleText", loField.cErrorMessage )
								Endif

								llDone = .T.

							Enddo

						Endif && ! loField.lIsVirtual

					Endfor

					If !loTable.lAdditive

						* Eliminar los campos dados de baja
						For i = 1 To lnLen
							lnIndex = loColFields.GetKey( Lower( laFields[ i, 1 ] ))
							If Empty( lnIndex )
								lcCommand = "Alter Table " + loTable.cLongTableName
								lcCommand = lcCommand + " DROP COLUMN " + Lower( laFields[ i, 1 ] )
								&lcCommand

							Endif
						Endfor

					Endif

					If !Empty( Field( "Dummy", loTable.Name ) )
						lcCommand = "Alter Table " + loTable.cLongTableName
						lcCommand = lcCommand + " DROP COLUMN Dummy "
						&lcCommand
					Endif

					If !loTable.lIsFree
						This.CreateIndexes( IK_PRIMARY_KEY, loTable )
						DBSetProp( loTable.cLongTableName, "TABLE", "Comment", loTable.Comment )
					Endif

					This.GenerateIndexes( loTable )

				Endif && ! loTable.lIsVirtual

			Else
				Error 'Argumento invalido loTable. Se esperaba un objeto '

			Endif && Vartype( loTable ) = 'O'

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			If llClose
				*!*					Use In Select( loTable.cLongTableName )
			Endif


		Endtry

	Endproc && AlterTable

	*
	* CreateTable
	Procedure CreateTable( toTable As oTable ) As Void

		Local lcCommand As String

		Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg"

		Try

			lcCommand = ""

			If Vartype ( m.toTable ) = 'O'

				loTable = toTable

				lcFolder = loTable.cFolder
				lcFile = Addbs( lcFolder ) + loTable.Name + "." + loTable.cExt

				If ! FileExist( lcFile )

					lcCommand = "Create Table [" + lcFile + "] "

					If loTable.lIsFree
						lcCommand = lcCommand + " Free "

					Else
						If ! Empty( loTable.cLongTableName )
							lcCommand = lcCommand + " Name [" + loTable.cLongTableName + "] "

						Endif && ! Empty( loTable.cLongTableName )
					Endif

					If ! Empty( loTable.nCodepage )
						lcCommand = lcCommand + " Codepage = " + Any2Char( loTable.nCodepage )

					Endif && ! Empty( loTable.nCodepage )

					lcCommand = lcCommand + " ( Dummy Logical ) "
					&lcCommand

				Endif && ! File( lcFile )

				This.AlterTable( m.toTable )

			Else
				Error 'Argumento invalido toTable. Se esperaba un objeto '

			Endif && Vartype( toTable ) = 'O'


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			*!* DEBUG_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally


		Endtry

	Endproc && CreateTable


	* RA 2014-09-01(18:42:22)
	Procedure CreateIndexes( tnIndexKey As Integer,;
			toTable As oTable ) As Void;
			HELPSTRING "Genera los indices asociados a la tabla"

		Local loIndex As oIndex Of 'Tools\DataDictionary\prg\oIndex.prg',;
			loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg',;
			oTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg',;
			loTrigger As oTrigger Of 'Tools\DataDictionary\prg\oTrigger.prg',;
			loColInsertTriggers As oColInsertTriggers Of 'Tools\DataDictionary\prg\oColInsertTriggers.prg',;
			loColUpdateTriggers As oColUpdateTriggers Of 'Tools\DataDictionary\prg\oColUpdateTriggers.prg',;
			loColDeleteTriggers As oColDeleteTriggers Of 'Tools\DataDictionary\prg\oColDeleteTriggers.prg',;
			loColTables As oColTables2 Of "Fw\Sysadmin\Setup\Prg\Setup_Main.prg"

		Local lcCommand As String,;
			lcCmd As String,;
			lcDropCommand As String,;
			lcDBF As String

		Local lnRI As Integer,;
			lnPK As Integer,;
			lnFK As Integer,;
			lnUN As Integer,;
			lnRG As Integer

		Local llUse As Boolean

		Try

			loTable = toTable
			llUse = .F.

			If ! loTable.lIsVirtual

				loColInsertTriggers = loTable.oColInsertTriggers
				loColUpdateTriggers = loTable.oColUpdateTriggers
				loColDeleteTriggers = loTable.oColDeleteTriggers

				lcCommand = ''

				lnFK = 0
				lnPK = 0
				lnRG = 0
				lnUN = 0

				If loTable.lIsFree
					lcDBF = Addbs( loTable.cFolder ) + loTable.Name + "." + loTable.cExt

				Else
					lcDBF = loTable.cLongTableName

				Endif

				If Used( loTable.cLongTableName )
					llUse = .T.
					Use In Select( loTable.cLongTableName )
				Endif

				TEXT To lcCmd NoShow TextMerge Pretext 15
            	Use '<<lcDBF>>' Exclusive In 0
				ENDTEXT

				loTable.ReTryCommand( lcCmd, 10, 1705 )

				Select Alias( loTable.cLongTableName )

				lnRI = 0

				For Each loIndex In loTable.oColIndexes

					Do Case
						Case loIndex.nKeyType = IK_PRIMARY_KEY And tnIndexKey = IK_PRIMARY_KEY

							lcCommand = "Alter Table " + loTable.cLongTableName

							lcCommand = lcCommand + " ADD PRIMARY KEY " + loIndex.cKeyExpression

							If !Empty( loIndex.cForExpression )
								lcCommand = lcCommand + " FOR " + loIndex.cForExpression

							Else
								lcCommand = lcCommand + " FOR !Deleted()"

							Endif

							lcCommand = lcCommand + " TAG [" + loIndex.cTagName + "]"

							lcCommand = lcCommand + " Collate [" + loIndex.cCollate + "]"


							Try

								&lcCommand

							Catch To oErr

								Do Case
									Case oErr.ErrorNo = 1883
										*!* Primary key already exists.

										lcDropCommand = "Alter Table " + loTable.cLongTableName
										lcDropCommand = lcDropCommand + " DROP PRIMARY KEY "

										&lcDropCommand

										&lcCommand

									Case oErr.ErrorNo = 1879
										*!* No primary key.

									Case oErr.ErrorNo = 1880
										*!* Related table is not found in current database.

									Otherwise
										Throw oErr

								Endcase

							Finally

							Endtry

						Case loIndex.nKeyType # IK_PRIMARY_KEY And tnIndexKey # IK_PRIMARY_KEY

							lcCommand = "Alter Table " + loTable.cLongTableName

							Do Case
								Case loIndex.nKeyType = IK_NOKEY

								Case loIndex.nKeyType = IK_UNIQUE_KEY

									lcCommand = lcCommand + " ADD UNIQUE " + loIndex.cKeyExpression

									If ! Empty( loIndex.cForExpression )
										lcCommand = lcCommand + " FOR " + loIndex.cForExpression

									Else
										lcCommand = lcCommand + " FOR !Deleted()"

									Endif && ! Empty( loIndex.cForExpression )

									lnUN = lnUN + 1

									If ! Empty( loIndex.cTagName )
										*loIndex.cTagName = "UN" + Alltrim( Str( lnUN )) + loIndex.cTagName

									Else
										*loIndex.cTagName = "UN" + Alltrim( Str( lnUN )) + loIndex.Name
										loIndex.cTagName = loIndex.Name

									Endif && ! Empty( loIndex.cTagName )

									loIndex.cTagName = Substr( loIndex.cTagName, 1, 10 )
									lcCommand = lcCommand + " TAG [" + loIndex.cTagName + "]"

									lcCommand = lcCommand + " Collate [" + loIndex.cCollate + "]"

								Case loIndex.nKeyType = IK_FOREIGN_KEY

									lcCommand = lcCommand + " ADD FOREIGN KEY " + loIndex.cKeyExpression

									If ! Empty( loIndex.cForExpression )
										lcCommand = lcCommand + " FOR " + loIndex.cForExpression

									Else
										lcCommand = lcCommand + " FOR !Deleted()"

									Endif && ! Empty( loIndex.cForExpression )

									lnFK = lnFK + 1

									If ! Empty( loIndex.cTagName )
										*loIndex.cTagName = "FK" + Alltrim( Str( lnFK ) ) + loIndex.cTagName

									Else
										*loIndex.cTagName = "FK" + Alltrim( Str( lnFK ) ) + loIndex.Name
										loIndex.cTagName = loIndex.Name

									Endif && ! Empty( loIndex.cTagName )

									loIndex.cTagName = Substr( loIndex.cTagName, 1, 10 )
									lcCommand = lcCommand + " TAG [" + loIndex.cTagName + "]"

									lcCommand = lcCommand + " Collate [" + loIndex.cCollate + "]"

									lcCommand = lcCommand + " References " + loIndex.cReferences

									If ! Empty( loIndex.cParentTagName )
										lcCommand = lcCommand + " TAG [" + loIndex.cParentTagName + "]"

									Endif && ! Empty( loIndex.cParentTagName )

									lnRI = lnRI + 1

									*!* Genera un Trigger de Insert
									* loTrigger = loTable.oColInsertTriggers.New()
									loTrigger = loColInsertTriggers.New()
									loTrigger.cChildForeignKey = loIndex.Name
									loTrigger.cChildTagName = loIndex.cTagName
									loTrigger.cParentTagName = loIndex.cParentTagName
									loTrigger.cParentTable = loIndex.cReferences
									loTrigger.cChildTable = loTable.cLongTableName
									loTrigger.Name = "_ir_Insert_" + Transform( lnRI ) + "_" + loTable.cLongTableName + "_" + loIndex.cReferences
									loTrigger.cChildKeyExpression = loIndex.cKeyExpression
									loTrigger.cTriggerConditionForInsert = loIndex.cTriggerConditionForInsert
									* Modificado 2009-03-10 - Eiff Damián
									loTrigger.cParentPk = loIndex.cParentPk
									* loTable.oColInsertTriggers.AddTrigger( loTrigger )
									loColInsertTriggers.AddTrigger( loTrigger )
									loTrigger = Null

									*!* Genera un Trigger de Update
									* loTrigger = loTable.oColUpdateTriggers.New()
									loTrigger = loColUpdateTriggers.New()
									loTrigger.cChildForeignKey = loIndex.Name
									loTrigger.cChildTagName = loIndex.cTagName
									loTrigger.cParentTagName = loIndex.cParentTagName
									loTrigger.cParentTable = loIndex.cReferences
									loTrigger.cChildTable = loTable.cLongTableName
									loTrigger.Name = "_ir_Update_" + Transform( lnRI ) + "_" + loTable.cLongTableName + "_" + loIndex.cReferences
									loTrigger.cChildKeyExpression = loIndex.cKeyExpression
									loTrigger.cTriggerConditionForUpdate = loIndex.cTriggerConditionForUpdate
									* Modificado 2009-03-10 - Eiff Damián
									loTrigger.cParentPk = loIndex.cParentPk
									* loTable.oColUpdateTriggers.AddTrigger( loTrigger )
									loColUpdateTriggers.AddTrigger( loTrigger )
									loTrigger = Null

									*!* Genera un Trigger de Delete
									* Debo generarlo en el objeto table correspondiente
									* a la tabla a la que hace referencia loIndex.cReferences

									loData  = loTable.oParent
									Assert Vartype ( loData ) = 'O' Message 'loData no es un objeto'

									loColTables = loData.oColTables

									For Each oTable In loColTables

										If Lower( oTable.cLongTableName ) == Lower( loIndex.cReferences )

											loTrigger = oTable.oColDeleteTriggers.New()
											loTrigger.cChildForeignKey = loIndex.Name
											loTrigger.cChildTagName = loIndex.cTagName
											loTrigger.cParentTagName = loIndex.cParentTagName
											loTrigger.cParentTable = oTable.cLongTableName
											loTrigger.cChildTable = loTable.cLongTableName
											loTrigger.Name = "_ir_Delete_"+Transform(lnRI)+"_"+oTable.cLongTableName+"_"+loTable.cLongTableName
											loTrigger.cChildKeyExpression = loIndex.cKeyExpression
											loTrigger.cTriggerConditionForDelete = loIndex.cTriggerConditionForDelete
											* Modificado 2009-03-10 - Eiff Damián
											loTrigger.cParentPk = loIndex.cParentPk
											oTable.oColDeleteTriggers.AddTrigger( loTrigger )
											loTrigger = Null

										Endif

									Endfor

									loColTables = Null
									oTable = Null


								Case loIndex.nKeyType = IK_REGULAR

									lcCommand = "INDEX ON " + loIndex.cKeyExpression

									If ! Empty( loIndex.cForExpression )
										lcCommand = lcCommand + " FOR " + loIndex.cForExpression

									Else
										lcCommand = lcCommand + " FOR !Deleted()"

									Endif && ! Empty( loIndex.cForExpression )

									lnRG = lnRG + 1

									If !Empty( loIndex.cTagName )
										*loIndex.cTagName = "RG" + Alltrim( Str( lnRG )) + loIndex.cTagName

									Else
										*loIndex.cTagName = "RG" + Alltrim( Str( lnRG )) + loIndex.Name
										loIndex.cTagName = loIndex.Name

									Endif

									loIndex.cTagName = Substr( loIndex.cTagName, 1, 10 )
									lcCommand = lcCommand + " TAG [" + loIndex.cTagName + "]"

									lcCommand = lcCommand + " Collate [" + loIndex.cCollate + "]"

								Otherwise

							Endcase

							Try

								&lcCommand

							Catch To oErr

								Do Case
									Case oErr.ErrorNo = 1883
										*!* Primary key already exists.

										lcDropCommand = "Alter Table " + loTable.cLongTableName
										lcDropCommand = lcDropCommand + " DROP PRIMARY KEY "

										&lcDropCommand

										&lcCommand

									Case oErr.ErrorNo = 1879
										*!* No primary key.

									Case oErr.ErrorNo = 1880
										*!* Related table is not found in current database.

									Otherwise
										oErr.Message = oErr.Message + Chr(13) + lcCommand
										Throw oErr

								Endcase

							Finally

							Endtry

						Otherwise

					Endcase

				Endfor

			Endif && ! loTable.lIsVirtual

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			*!*				Use In Select( loTable.cLongTableName )

			*!*				If llUse
			*!*					TEXT To lcCommand NoShow TextMerge Pretext 15
			*!*					Use '<<lcDBF>>' Shared In 0
			*!*					ENDTEXT

			*!*					&lcCommand


			*!*				Endif

			loColInsertTriggers = Null
			loColUpdateTriggers = Null
			loColDeleteTriggers = Null

			loTable = Null
			oTable = Null


		Endtry


	Endproc  && CreateIndexes

	*
	* Genera la Coleccion Indices
	Procedure GenerateIndexes( toTable As oTable ) As Void;
			HELPSTRING "Genera la Coleccion Indices"

		Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg',;
			loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg',;
			loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
			loColIndexes As oColIndexes Of 'Tools\DataDictionary\prg\oColIndexes.prg',;
			loIndex As oIndex Of 'Tools\DataDictionary\prg\oIndex.prg'

		Local lnIndex As Integer,;
			lcPrefijo As String,;
			lcCommand As String,;
			lcKeyType As String

		Try

			loTable = toTable

			loColFields = loTable.oColFields
			loColIndexes = loTable.oColIndexes

			For Each loField In loColFields
				If loField.nIndexKey # IK_NOKEY
					loIndex = loColIndexes.New()
					loIndex.nKeyType = loField.nIndexKey
					If loField.lCaseSensitive
						loIndex.cKeyExpression = loField.Name

					Else
						loIndex.cKeyExpression = "Upper( " + loField.Name + " )"

					Endif

					If !Empty( loField.cForExpression )
						loIndex.cForExpression = loField.cForExpression
					Endif

					If Empty( loField.cTagName )
						loField.cTagName = Substr( loField.Name, 1, 10 )
					Endif

					loIndex.cTagName = loField.cTagName
					loIndex.cCollate = loField.cCollate
					loIndex.Name = loField.Name

					loColIndexes.AddIndex( loIndex )
					loIndex = Null

				Endif

			Endfor

			lnIndex = 0

			For Each loIndex In loColIndexes
				If Inlist( loIndex.nKeyType, IK_REGULAR, IK_CANDIDATE_KEY, IK_UNIQUE_KEY, IK_PRIMARY_KEY )

					lcCommand = "INDEX ON " + loIndex.cKeyExpression

					If ! Empty( loIndex.cForExpression )
						lcCommand = lcCommand + " FOR " + loIndex.cForExpression

					Else
						lcCommand = lcCommand + " FOR !Deleted()"

					Endif && ! Empty( loIndex.cForExpression )

					lnIndex = lnIndex + 1
					Do Case
						Case loIndex.nKeyType = IK_REGULAR
							lcPrefijo = "RG"
							lcKeyType = ""

						Case loIndex.nKeyType = IK_CANDIDATE_KEY
							lcPrefijo = "CN"
							lcKeyType = " CANDIDATE "

						Case loIndex.nKeyType = IK_UNIQUE_KEY
							lcPrefijo = "UN"
							lcKeyType = " UNIQUE "

						Case loIndex.nKeyType = IK_PRIMARY_KEY
							lcPrefijo = "PK"
							lcKeyType = " CANDIDATE "

						Otherwise
							lcPrefijo = ""
							lcKeyType = ""

					Endcase

					If Empty( loIndex.cTagName )
						loIndex.cTagName = loIndex.Name
					Endif

					loIndex.cTagName = Substr( loIndex.cTagName, 1, 10 )
					lcCommand = lcCommand + " TAG [" + loIndex.cTagName + "]"

					lcCommand = lcCommand + " Collate [" + loIndex.cCollate + "]"

					loIndex.cCommand = lcCommand + lcKeyType

				Else
					loIndex.cCommand = ""

				Endif

			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			*!* DEBUG_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loField 	= Null
			loIndex 	= Null
			loColFields = Null
			loColIndexes = Null
			loTable 	= Null

		Endtry

	Endproc && GenerateIndexes


	*
	* Crea los indices para una tabla libre
	Procedure CreateIndexesInFreeTable( toTable As oTable ) As Void;
			HELPSTRING "Crea los indices para una tabla libre"

		Local lcCommand As String
		Local loIndex As oIndex Of 'Tools\DataDictionary\prg\oIndex.prg',;
			loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg',;
			loColIndexes As oColIndexes Of 'Tools\DataDictionary\prg\oColIndexes.prg'



		Try

			lcCommand = ""
			loTable = toTable

			llClose = .F.

			If Vartype ( m.toTable ) = 'O'

				If ! toTable.lIsVirtual

					loTable = toTable

					If ! Used( loTable.cLongTableName ) Or !Isexclusive( loTable.cLongTableName )

						llClose = .T.

						Try

							If loTable.lIsFree
								lcFile = Addbs( loTable.cFolder ) + loTable.Name + "." + loTable.cExt

								Try
									Use ( lcFile ) Exclusive

								Catch To oErr When oErr.ErrorNo = 1707 && No se encuentra el archivo .CDX estructural.
									Use ( lcFile ) Exclusive

								Catch To oErr
									Throw oErr

								Finally

								Endtry

							Else
								Use ( loTable.cLongTableName ) Exclusive

							Endif

						Catch To oErr When oErr.ErrorNo = 1

							If ! Indbc( loTable.cLongTableName, 'TABLE' )
								TEXT To lcCommand NoShow TextMerge Pretext 15
                       			Add Table '<<Addbs( loTable.cFolder ) + loTable.Name + "." + loTable.cExt>>' Name '<<loTable.cLongTableName>>'

								ENDTEXT

								&lcCommand

							Endif

						Catch To oErr
							Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
							DEBUG_CLASS_EXCEPTION
							*!* DEBUG_EXCEPTION
							loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
							loError.cRemark = lcCommand
							m.loError.Process ( m.loErr )
							THROW_EXCEPTION

						Finally

						Endtry

					Endif

					Select Alias( loTable.cLongTableName )

					loColIndexes = loTable.oColIndexes

					For Each loIndex In loColIndexes
						Execscript( loIndex.cCommand )
					Endfor

				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loIndex 		= Null
			loColIndexes 	= Null
			loTable 		= Null

		Endtry

	Endproc && CreateIndexesInFreeTable



	*
	* Comprime la tabla
	Procedure PackTable( toTable As Object ) As Void;
			HELPSTRING "Comprime la tabla"
		Local lcCommand As String
		Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg"


		Try

			lcCommand = ""
			loTable = toTable

			If Vartype ( loTable ) == 'O'
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Pack in <<loTable.cLongTableName>>
				ENDTEXT

				&lcCommand


			Else
				Error 'Argumento invalido toTable. Se esperaba un objeto '

			Endif && Vartype( toTable ) = 'O'


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			*!* DEBUG_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally

		Endtry

	Endproc && PackTable



	*
	* ProcessTable
	Procedure ProcessTable ( toTable As oTable,;
			lPackTable As Boolean,;
			lSilence As Boolean ) As Void

		Local lcCommand As String,;
			lcMsg As String
		Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg"

		Try

			lcCommand = ""
			loTable = toTable


			If Vartype ( loTable ) == 'O'

				TEXT To lcMsg NoShow TextMerge Pretext 03
				Sincronizando <<loTable.cLongTableName>> . . .
				ENDTEXT

				lcCommand = lcMsg

				If !lSilence
					Wait Window Nowait Noclear lcMsg
				Endif


				This.CreateTable ( loTable )
				This.InitializeData ( loTable )
				This.AddTableConstraints ( loTable )
				This.AddTableForeignKey ( loTable )

				If lPackTable
					This.PackTable( loTable )
				Endif

				If loTable.lIsFree
					This.CreateIndexesInFreeTable( loTable )

				Else
					This.CreateIndexes( 0, loTable )

				Endif

			Else
				Error 'Argumento invalido toTable. Se esperaba un objeto '

			Endif && Vartype( toTable ) = 'O'

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally

		Endtry

	Endproc && ProcessTable



	*
	* Guardar la tabla
	Procedure SaveTable( cTable As String ) As Void;
			HELPSTRING "Guardar la tabla"
		Local lcCommand As String,;
			lcFolder As String,;
			lcFileName As String,;
			lcBackFolder As String

		Local llOk As Boolean


		Try

			lcCommand = ""
			llOk = .F.
			lcFolder = Justpath( cTable )
			lcBackFolder = Addbs( lcFolder ) + "Bak"
			lcFileName = Alias()

			Try

				Md ( lcBackFolder )

			Catch To oErr

			Finally

			EndTry
			
			Wait Window NOWAIT "BackUp " + lcFileName

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Copy To <<Addbs(lcBackFolder)>><<lcFileName>>
			ENDTEXT

			&lcCommand

			llOk = .T.

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && SaveTable




	*
	* Restaurar la tabla
	Procedure RestoreTable( cTable As String ) As Void;
			HELPSTRING "Restaurar la tabla"

		Local lcCommand As String,;
			lcFolder As String,;
			lcFileName As String,;
			lcBackFolder As String

		Local llOk As Boolean


		Try

			lcCommand = ""
			llOk = .F.
			lcFolder = Justpath( cTable )
			lcBackFolder = Addbs( lcFolder ) + "Bak"
			lcFileName = Alias()
			
			Wait Window NOWAIT "Restaurando " + lcFileName

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Append From <<Addbs(lcBackFolder)>><<lcFileName>>
			ENDTEXT

			&lcCommand

			llOk = .T.

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && RestoreTable

Enddefine && oSync
