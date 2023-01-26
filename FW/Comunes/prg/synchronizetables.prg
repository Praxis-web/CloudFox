#INCLUDE "FW\Comunes\Include\Praxis.h"

Lparameters tcTableName As String,;
	tcSource As String,;
	tcTarget As String,;
	tnAction As Integer,;
	tlSilence As Boolean


* tcTableName: Nombre Completo de la tabla que va a ser modificada
* tcSource: Alias de la tabla origen
* tcTarget: Alias transitorio de la tabla destino (No se usa)

* Valores para tnAction
* 1 	= Interactiva ( Muestra Mensajes, y espera confirmacion )
* 2 	= Solo Nuevos
* 4 	= Solo Modificados
* 8 	= Solo Bajas
* 16	= Siempre responde Si a las confirmaciones

*!*	#Define Sync_Interactiva	1
*!*	#Define Sync_Nuevos			2
*!*	#Define Sync_Modificados	4
*!*	#Define Sync_Bajas			8
*!*	#Define Sync_Confirma		16

Local loSincronizaTablas As SincronizaTablas Of "Fw\Comunes\Prg\Synchronizetables.prg"
Local lcOldDeleted As String

Try
	lcOldDeleted = Set("Deleted")

	Set Deleted Off

	If Empty( tnAction )
		tnAction = 15
	Endif

	If !tlSilence
		Wait Window Nowait "Sincronizando Tabla " + tcTableName
	Endif

	If Empty( tcSource )
		tcSource = 'cSource'
	Endif

	If Empty( tcTarget )
		tcTarget = 'fTarget'
	Endif

	loSincronizaTablas = Newobject( "SincronizaTablas", "Fw\Comunes\Prg\Synchronizetables.prg" )
	loSincronizaTablas.Process( tcTableName,;
		tcSource,;
		tcTarget,;
		tnAction )

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )


Finally
	Set Deleted &lcOldDeleted
	loSincronizaTablas = Null
	If !tlSilence
		Wait Clear
	Endif

Endtry



*!* ///////////////////////////////////////////////////////
*!* Class.........: SincronizaTablas
*!* ParentClass...: prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....: Custom
*!* Description...: Sincroniza dos tablas
*!* Date..........: Miércoles 10 de Noviembre de 2010 (12:08:42)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class SincronizaTablas As prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'

	#If .F.
		Local This As SincronizaTablas Of "V:\Clipper2fox\Fw\Comunes\Prg\Synchronizetables.prg"
	#Endif

	* Coleccion de campos de la tabla destino
	oColFields = Null


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="process" type="method" display="Process" />] + ;
		[<memberdata name="haydiferencias" type="method" display="HayDiferencias" />] + ;
		[<memberdata name="ocolfields" type="property" display="oColFields" />] + ;
		[<memberdata name="backuptable" type="method" display="BackUpTable" />] + ;
		[<memberdata name="creartabla" type="method" display="CrearTabla" />] + ;
		[<memberdata name="ejecutaaccion" type="method" display="EjecutaAccion" />] + ;
		[</VFPData>]



	*
	*
	Procedure Process( tcTableName As String,;
			tcSource As String,;
			tcTarget As String,;
			tnAction As Integer ) As Void

		Local lcBackupFile As String

		Try

			If Empty( Justext( tcTableName ))
				tcTableName = tcTableName + ".Dbf"
			Endif

			If Empty( tnAction )
				tnAction = Sync_Confirma
			Endif

			This.oColFields = Createobject( "Collection" )

			If This.HayDiferencias( tcSource,;
					tcTarget,;
					tcTableName,;
					tnAction )

				lcBackupFile = This.BackUpTable( tcTableName, tcTarget )
				This.CrearTabla( tcTableName, lcBackupFile, tcTarget )

			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			Use In Select( tcTarget )

		Endtry

	Endproc && Process



	*
	* Indica si se encontraron diferencias en la estructura
	Procedure HayDiferencias( tcSource As String,;
			tcTarget As String,;
			tcTableName As String,;
			tnAction As Integer  ) As Boolean;
			HELPSTRING "Indica si se encontraron diferencias en la estructura"

		Local llDiferente As Boolean
		Local lnLenSource As Integer,;
			lnLenTarget As Integer

		Local i As Integer,;
			j As Integer,;
			k As Integer

		Local loField As Object

		Local Array laSource[ 1 ], laTarget[ 1 ]

		Try
			llDiferente = .F.

			Try

				Use '&tcTableName.' Exclusive In 0 Alias &tcTarget

			Catch To oErr
				Do Case
					Case oErr.ErrorNo = 1
						llDiferente = .T.

					Case oErr.ErrorNo = 1707
						Use '&tcTableName.' Exclusive In 0 Alias &tcTarget

					Otherwise
						Throw oErr

				Endcase

			Finally

			Endtry

			lnLenSource = Afields( laSource, tcSource )

			If !llDiferente
				lnLenTarget = Afields( laTarget, tcTarget )

			Else
				lnLenTarget = 0

			Endif


			* Agregar o Modificar Campos
			For i = 1 To lnLenSource
				If !Empty( lnLenTarget )
					k = Ascan( laTarget, laSource[ i, 1 ], -1, -1, 1, 15 )

				Else
					k = 0

				Endif

				If Empty( k )

					If This.EjecutaAccion( Sync_Nuevos, tnAction )

						* ADD COLUMN
						llDiferente = .T.

						lnLenTarget = lnLenTarget + 1

						Dimension laTarget[ lnLenTarget, 18 ]

						For j = 1 To 18
							laTarget[ lnLenTarget, j ] = laSource[ i, j ]
						Endfor

					Endif

				Else

					* ALTER COLUMN
					If Inlist( laSource[ i, 2 ], "D", "T", "I", "L", "M" ) Or ;
							( laSource[ i, 2 ] = laTarget[ k, 2 ] ;
							And laSource[ i, 3 ] = laTarget[ k, 3 ] ;
							And laSource[ i, 4 ] = laTarget[ k, 4 ] )

						* Todo Ok
					Else


						If This.EjecutaAccion( Sync_Modificados, tnAction )
							Do Case
								Case Inlist( laSource[ i, 2 ], "D", "T", "I", "L", "M" )
									lcPrecision = ""

								Case Inlist( laSource[ i, 2 ], "C" )
									lcPrecision = "(" + Transform( laSource[ i, 3 ] ) + ")"

								Case Inlist( laSource[ i, 2 ], "N" )
									lcPrecision = "(" + Transform( laSource[ i, 3 ] ) + "," + Transform( laSource[ i, 4 ] ) + ")"

								Otherwise

									lcPrecision = "(" + Transform( laSource[ i, 3 ] )

									If Empty( laSource[ i, 4 ] )
										lcPrecision = lcPrecision + ")"

									Else
										lcPrecision = lcPrecision + "," + Transform( laSource[ i, 4 ] ) + ")"

									Endif

							Endcase

							llAlert = .F.

							If Inlist( laTarget[ k, 2 ], "N", "C" ) And laTarget[ k, 2 ] # laSource[ i, 2 ]
								llAlert = .T.
							Endif

							If !llAlert
								If Inlist( laTarget[ k, 2 ], "N", "C" )

									If laTarget[ k, 3 ] > laSource[ i, 3 ]
										llAlert = .T.
									Endif

									If laTarget[ k, 4 ] > laSource[ i, 4 ]
										llAlert = .T.
									Endif
								Endif

							Endif

							llConfirm = .T.

							If llAlert

								lcDatoNuevo = laSource[ i, 2 ] + lcPrecision

								Do Case
									Case Inlist( laTarget[ k, 2 ], "D", "T", "I", "L", "M" )
										lcDatoActual = ""

									Case Inlist( laTarget[ k, 2 ], "C" )
										lcDatoActual = "(" + Transform( laTarget[ k, 3 ] ) + ")"

									Case Inlist( laTarget[ k, 2 ], "N" )
										lcDatoActual = "(" + Transform( laTarget[ k, 3 ] ) + "," + Transform( laTarget[ k, 4 ] ) + ")"

									Otherwise

										lcDatoActual = "(" + Transform( laTarget[ k, 3 ] )

										If Empty( laTarget[ k, 4 ] )
											lcDatoActual = lcDatoActual + ")"

										Else
											lcDatoActual = lcDatoActual + "," + Transform( laTarget[ k, 4 ] ) + ")"

										Endif

								Endcase

								lcDatoActual = laTarget[ k, 2 ] + lcDatoActual


								TEXT To lcTexto NoShow TextMerge Pretext 03
								ATENCION
								TABLA: '<<tcTableName>>'
								CAMPO: <<laSource[ i, 1 ]>>
								TIPO ACTUAL: <<lcDatoActual>>
								TIPO NUEVO :  <<lcDatoNuevo>>

								EXISTE RIESGO DE PERDER INFORMACION

								¿CONFIRMA?
								ENDTEXT

								If This.EjecutaAccion( Sync_Interactiva, tnAction )
									llConfirm = Confirm( lcTexto, "Sincronizando Tablas", .F. )

								Else
									llConfirm = This.EjecutaAccion( Sync_Confirma, tnAction )

								Endif
							Endif

						Else
							lcDatoNuevo = laSource[ i, 2 ] + lcPrecision

						Endif



						If llConfirm

							llDiferente = .T.

							For j = 1 To 18
								laTarget[ k, j ] = laSource[ i, j ]
							Endfor

						Endif

					Endif

				Endif

			Endfor


			* Eliminar Campos
			If This.EjecutaAccion( Sync_Bajas, tnAction )
				For j = 1 To lnLenTarget

					k = Ascan( laSource, laTarget[ j, 1 ], -1, -1, 1, 15 )

					If Empty( k )

						* DROP COLUMN

						TEXT To lcTexto NoShow TextMerge Pretext 03
						¿Elimina el campo <<laTarget[ j, 1 ]>>
						de la tabla '<<tcTableName>>'?
						ENDTEXT

						If This.EjecutaAccion( Sync_Interactiva, tnAction )
							If Confirm( lcTexto, "Sincronizando Tablas", .F. )

								llDiferente = .T.

								laTarget[ j, 1 ] = ""

							Endif

						Else
							If This.EjecutaAccion( Sync_Confirma, tnAction )

								llDiferente = .T.

								laTarget[ j, 1 ] = ""

							Endif

						Endif

					Endif

				Endfor
			Endif

			If llDiferente
				For i = 1 To lnLenTarget
					If !Empty( laTarget[ i, 1 ] )
						loField = Createobject( "Empty" )
						AddProperty( loField, "FieldName", 		laTarget[ i, 1 ] )
						AddProperty( loField, "FieldType", 		laTarget[ i, 2 ] )
						AddProperty( loField, "FieldWidth", 	laTarget[ i, 3 ] )
						AddProperty( loField, "DecimalPlaces", 	laTarget[ i, 4 ] )

						Try

							This.oColFields.Add( loField, Lower( loField.FieldName ) )

						Catch To oErr

						Finally

						Endtry


					Endif
				Endfor
			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llDiferente

	Endproc && HayDiferencias



	*
	* Realiza el BackUp de la tabla
	Procedure BackUpTable( tcFileName As String, tcTarget As String ) As String;
			HELPSTRING "Realiza el BackUp de la tabla"

		Local lcBackUp As String,;
			lcFolder As String,;
			lcFileName As String,;
			lcCommand As String

		Try

			Wait Window Nowait "Haciendo Backup de " + Juststem( tcFileName )

			lcCommand = ""
			lcFolder = Addbs( Justpath( tcFileName ) )

			lcFileName = lcFolder + Proper( Juststem( tcFileName ))
			lcBackUp = lcFolder + "#" + Proper( Juststem( tcFileName ))

			Use In Select( Juststem( lcFileName ))
			Use In Select( Juststem( lcBackUp ))
			Use In Select( tcTarget )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Erase '<<lcBackUp>>.*'
			ENDTEXT

			&lcCommand

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Rename '<<lcFileName>>.*' To '<<lcBackUp>>.*'
			ENDTEXT


			Try

				&lcCommand

			Catch To oErr
				Do Case
					Case oErr.ErrorNo = 1
						* No hacer nada

					Otherwise
						Throw oErr

				Endcase

			Finally

			Endtry



		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			Wait Window Nowait "Sincronizando Tabla " + tcFileName

		Endtry

		Return lcBackUp + "." + Justext( tcFileName )

	Endproc && BackUpTable



	*
	* Crear la estructura de la nueva tabla
	Procedure CrearTabla( tcTableName As String, tcBackupFile As String, tcTarget As String ) As Void;
			HELPSTRING "Crear la estructura de la nueva tabla"

		Local lcCommand As String,;
			lcPrecision As String

		Local loField As Object

		Try

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Table '<<tcTableName>>' (
			ENDTEXT

			For Each loField In This.oColFields
				Do Case
					Case Inlist( loField.FieldType, "D", "T", "I", "L", "M" )
						lcPrecision = ""

					Case Inlist( loField.FieldType, "C" )
						lcPrecision = "(" + Transform( loField.FieldWidth ) + ")"

					Case Inlist( loField.FieldType, "N" )
						lcPrecision = "(" + Transform( loField.FieldWidth ) + "," + Transform( loField.DecimalPlaces ) + ")"

					Otherwise

						lcPrecision = "(" + Transform( loField.FieldWidth )

						If Empty( loField.DecimalPlaces )
							lcPrecision = lcPrecision + ")"

						Else
							lcPrecision = lcPrecision + "," + Transform( loField.DecimalPlaces ) + ")"

						Endif

				Endcase

				TEXT To lcCommand NoShow TextMerge Pretext 15 ADDITIVE
				<<loField.FieldName>> <<loField.FieldType>><<lcPrecision>>,
				ENDTEXT
			Endfor

			lcCommand = Substr( lcCommand, 1, Len( lcCommand ) - 1 ) + ")"

			&lcCommand

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Use '<<tcTableName>>' Exclusive Alias <<tcTarget>>
			ENDTEXT

			&lcCommand

			If File( tcBackupFile )
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Append From '<<tcBackupFile>>' For !Deleted()
				ENDTEXT

				&lcCommand

			Endif


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && CrearTabla



	*
	*
	Procedure EjecutaAccion( nAccionBuscada As Integer, nAcciones As Integer ) As Boolean
		Local lcCommand As String
		Local lnBitPosition As Integer
		Local llOk As Boolean

		Try

			lcCommand = ""

			Assert ( Vartype( nAccionBuscada ) = "N"  And Vartype( nAcciones ) = "N" )

			llOk = ( Bitand( nAccionBuscada, nAcciones ) = nAccionBuscada )

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && EjecutaAccion

Enddefine
*!*
*!* END DEFINE
*!* Class.........: SincronizaTablas
*!*
*!* ///////////////////////////////////////////////////////