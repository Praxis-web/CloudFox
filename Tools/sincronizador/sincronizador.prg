#INCLUDE "FW\Comunes\Include\Praxis.h"

#Define Field_name_validation_rule_is_violated 	1582

Local lcSyncFile As String,;
	lcMemFile As String ,;
	lcMemVar As String,;
	lcCommand As String

Local i As Integer

Local loColTables As ColTables Of "Tools\Sincronizador\ColDataBases.prg"
Local loTable As oTable Of "Tools\Sincronizador\ColDataBases.prg"
Local loSynchronize As oSynchronize Of 'Tools\Sincronizador\Sincronizador.prg'

Try

	lcCommand  = ""
	Set Procedure To "Rutinas\Rutina.prg"
	Set Safety Off

	Do LoadNamespace In Tools\Namespaces\prg\LoadNamespace.prg

	lcSyncFile = Getfile( "prg", "", "", 0, "Seleccione el archivo de sincronización" )

	If !Empty( lcSyncFile )

		lcMemFile = Getfile( "mem", "", "", 0, "Seleccione el archivo de Variables de Memoria" )

		If !Empty( lcMemFile )
			Restore From ( lcMemFile ) Additive
		Endif

		If Vartype( drComun ) # "C"
			drComun = DRVA
		Endif

		TEXT To lcCommand NoShow TextMerge Pretext 15
		loColTables = ExecScript( FileToStr( '<<lcSyncFile>>' ))
		ENDTEXT

		&lcCommand

		lcCommand = ""
		loSynchronize = Createobject( "oSynchronize" )

		*!*			For Each loTable In loColTables
		For i = 1 To loColTables.Count
			loTable = loColTables.Item( i )

			If ! loTable.lIsVirtual
				*!* Creo las tablas y las Clave Primarias
				Wait Window "Sincronizando " + loTable.Name + "...." Nowait

				If Empty( loTable.cFolder )
					loTable.cFolder = Iif( loTable.lShared, "DrComun", "Drva" )

				Endif && Empty( loTable.cFolder )

				lcMemFile = loTable.cFolder

				If Vartype( Evaluate( "lcMemFile" ) ) # "C"
					Error [Falta definir la variable "] + lcMemFile + ["]
				Endif

				loTable.cFolder = Addbs( Alltrim( Evaluate( "&lcMemFile." ) ))

				loSynchronize.CreateTable( loTable )

				*loTable.CreateIndexes( 0 )

			Endif && ! loTable.lIsVirtual

		Endfor

	Endif

	Wait Clear
	Inform( "Proceso Terminado" )

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )

Finally
	loColTables = Null
	loSynchronize = Null
	Wait Clear

Endtry

Return



Define Class oSynchronize As oSync Of 'Tools\DataDictionary\prg\osync.prg'
	* Flag que indica que guarda y reastaura para lograr mejor performance
	lSaveAndRestore = .F.

	#If .F.
		Local This As oSynchronize Of 'Tools\Sincronizador\Sincronizador.prg'
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="savetable" type="method" display="SaveTable" />] + ;
		[<memberdata name="restoretable" type="method" display="RestoreTable" />] + ;
		[<memberdata name="lsaveandrestore" type="property" display="lSaveAndRestore" />] + ;
		[<memberdata name="structureok" type="method" display="StructureOK" />] + ;
		[</VFPData>]


	Procedure AlterTable ( toTable As Object ) As Void
		Local lcCommand As String
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'
		Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
		Local loIndex As oIndex Of 'Tools\DataDictionary\prg\oIndex.prg'


		Try

			lcCommand = ""
			loTable = toTable
			lcFile = ""
			This.lSaveAndRestore = .F.

			llOk = .T.
			If ! loTable.lIsVirtual
				lcCommand = ""

				If ! Used( loTable.cLongTableName )
					Try

						If loTable.lIsFree
							*!*								lcFolder = loTable.cFolder
							*!*								lcFile = Addbs( &lcFolder ) + loTable.Name + "." + loTable.cExt

							lcFile = Addbs( loTable.cFolder ) + loTable.Name + "." + loTable.cExt

							Try

								Use ( lcFile ) Exclusive

							Catch To loErr When loErr.ErrorNo = 1707 && No se encuentra el archivo .CDX estructural.
								Use ( lcFile ) Exclusive

							Catch To loErr
								Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
								loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
								loError.cRemark = lcCommand
								loError.Process ( m.loErr )
								Throw loError

							Finally

							Endtry


						Else
							Use ( loTable.cLongTableName ) Exclusive

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
						loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
						loError.cRemark = lcCommand
						loError.Process ( m.loErr )
						Throw loError

					Finally


					Endtry

				Endif

				Select Alias( loTable.cLongTableName )

				Delete Tag All

				* lnLen = Afields( laFields )
				lnLen = Afields( laFields, loTable.cLongTableName )
				* @TODO Damian Eiff 2009-09-15 (13:49:13)
				* Detectar si la tabla tiene registros para iniciar los campos
				* antes de aplicar las reglas de campo.
				lnRecCount = Reccount( loTable.cLongTableName )

				* Use In Alias( loTable.cLongTableName )
				* Use In Select( loTable.cLongTableName )

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
					If ! loField.lIsVirtual
						llDone = .F.

						Do While ! llDone
							llLoop = .F.
							lcCommand = "Alter Table " + loTable.cLongTableName

							i = Ascan( laFields, loField.Name, 1, lnLen, 1, ASCAN_CASE_INSENSITIVE__EXACT_ON )

							If ! Empty( i )
								lcCommand = lcCommand + " Alter "

								* Si es autoincremental, hay que conservar los datos

								If loField.lAutoinc
									loField.nNextvalue = laFields[ i, 17 ]
									loField.nStepValue = laFields[ i, 18 ]

								Endif && loField.lAutoinc

							Else
								lcCommand = lcCommand + " Add "

							Endif && ! Empty( i )

							lcCommand = lcCommand + "Column " + loField.Name + " " + loField.cFieldType

							If ! Empty( loField.nFieldWidth )
								* lcCommand = lcCommand + "(" + Any2Char( loField.nFieldWidth )
								lcCommand = lcCommand + "(" + Transform( loField.nFieldWidth )
								If ! Empty( loField.nFieldPrecision )
									* lcCommand = lcCommand + "," + Any2Char( loField.nFieldPrecision )
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
									* lcCommand = lcCommand + " CHECK " + Any2Char( loField.cCheck )
									lcCommand = lcCommand + " CHECK " + Transform( loField.cCheck )
									If ! Empty( loField.cErrorMessage )
										loField.cErrorMessage = loTable.cLongTableName + ": " + loField.cErrorMessage
										lcCommand = lcCommand + " ERROR [" + loField.cErrorMessage + "]"

									Endif && ! Empty( loField.cErrorMessage )

								Endif && ! Empty( loField.cCheck )

								If loField.lAutoinc
									lcCommand = lcCommand + " AUTOINC "
									If !Empty( loField.nNextvalue )
										* lcCommand = lcCommand + " NEXTVALUE " + Any2Char( loField.Nextvalue )
										lcCommand = lcCommand + " NEXTVALUE " + Transform( loField.nNextvalue )

										If ! Empty( loField.nStepValue )
											* lcCommand = lcCommand + " STEP " + Any2Char( loField.nStepValue )
											lcCommand = lcCommand + " STEP " + Transform( loField.nStepValue )

										Endif

									Endif
								Endif

								If ! IsEmpty( loField.Default )
									* lcCommand = lcCommand + " DEFAULT " + Any2Char( loField.Default )
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

									Endif && Empty( loField.TagName )

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

							Catch To loErr
								lcErrMesg = loErr.Message + CR + CR

								Do Case
									Case loErr.ErrorNo = Field_name_validation_rule_is_violated
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
											Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
											loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
											loError.cRemark = lcCommand
											loError.Process ( m.loErr )
											Throw loError

										Endif

									Otherwise
										Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
										loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
										loError.cRemark = lcCommand
										loError.Process ( m.loErr )
										Throw loError


								Endcase

							Finally

							Endtry

							If llLoop
								Loop

							Endif && llLoop

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

				If !loTable.lIsFree
					loTable.CreateIndexes( IK_PRIMARY_KEY )
					DBSetProp( loTable.cLongTableName, "TABLE", "Comment", loTable.Comment )
				Endif

				If This.lSaveAndRestore
					This.RestoreTable( lcFile )
				Endif


			Endif && ! loTable.lIsVirtual


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			Use In Select( loTable.cLongTableName )
			loColFields = Null
			loColIndexes = Null


		Endtry

	Endproc && AlterTable

	*
	* CreateTable
	Procedure CreateTable( toTable As oTable ) As Void
		Local lcCommand As String
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

		Try

			lcCommand = ""
			loTable = toTable

			llOk = .T.
			lcCommand = ""
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

				lcCommand = lcCommand + " (TS DateTime NOT NULL) "

				&lcCommand

			Endif && ! File( lcFile )

			This.AlterTable( loTable )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
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

		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally


		Endtry

	Endproc  && CreateIndexes

	*
	* Genera la Coleccion Indices
	Procedure GenerateIndexes( toTable As oTable ) As Void;
			HELPSTRING "Genera la Coleccion Indices"

		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally


		Endtry

	Endproc && GenerateIndexes


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
			lcFolder = GetEnv("TEMP")
			lcBackFolder = Addbs( lcFolder ) + "Bak_Fenix"
			lcFileName = Alias()

			Try

				Md ( lcBackFolder )

			Catch To oErr

			Finally

			Endtry

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
			lcFolder = GetEnv("TEMP")
			lcBackFolder = Addbs( lcFolder ) + "Bak_Fenix"
			lcFileName = Alias()

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




	*
	* Verifica si la estructura precisa modificación
	Procedure StructureOK( toTable As Object,;
			lcAlias As String ) As Boolean ;
			HELPSTRING "Verifica si la estructura precisa modificación"
		Local lcCommand As String
		Local llOk As Boolean,;
			llSameType As Boolean

		Local loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
		Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'

		Local i As Integer,;
			lnLen As Integer


		Try

			lcCommand = ""
			llOk = .T.
			loTable = toTable

			Select Alias( lcAlias )
			lnLen = Afields( laFields, lcAlias )
			loColFields = loTable.oColFields
			loColIndexes = loTable.oColIndexes
			
			* Verificar la Estructura de Datos
			For Each loField In loColFields

				If ! loField.lIsVirtual
					llSameType = .T.

					i = Ascan( laFields, loField.Name, 1, lnLen, 1, ASCAN_CASE_INSENSITIVE__EXACT_ON + ASCAN_RETURN_ROW_NUMBER )
					
					If Empty( i )
						llOk = .F.

					Else
						* Verificar si el tipo de datos es igual

						llSameType = ( laFields[ i, 2 ] = loField.cFieldType )

						If !llSameType
							Do Case
								Case laFields[ i, 2 ] = "I"
									If loField.cFieldType = "N"
										If loField.nFieldPrecision = 0
											llSameType = .T.
										Endif

									Endif

								Case laFields[ i, 2 ] = "N"
									If loField.cFieldType = "I"
										If laFields[ i, 4 ] # 0
											* RA 09/05/2019(14:34:18)
											* Si el campo original tiene decimales, transformaro
											* en entero podria truncar información sencible
											llSameType = .T.
										Endif

									Endif

								Case laFields[ i, 2 ] = "M"
									If loField.cFieldType = "C"
										llSameType = .T.
									Endif

								Otherwise

							Endcase

						Endif

						llOk = llSameType
						
						If llSameType 
						
							If loField.nFieldWidth > laFields[ i, 3 ]  
								llOk = .F.
							
							Else 
								loField.nFieldWidth = laFields[ i, 3 ]  
								
							EndIf

							If loField.nFieldPrecision > laFields[ i, 4 ]  
								llOk = .F.
							
							Else 
								loField.nFieldPrecision = laFields[ i, 4 ]  
								
							EndIf

						EndIf

					Endif && ! Empty( i )

				Endif && ! loField.lIsVirtual

				If !llOk
					*!*						Set Step On
					*!*						Error basta
					Exit
				Endif

			Endfor


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && StructureOK


Enddefine
