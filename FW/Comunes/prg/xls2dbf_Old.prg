*
* Convierte una hoja de calculo a cursor
Procedure Xls2Dbf( cXLBook As String,;
		cCursor As String,;
		cBookName As String ) As Void;
		HELPSTRING "Convierte una hoja de calculo a cursor"

	Local lcCommand As String,;
		lcXLBook As String,;
		lcConnstr As String,;
		lcSQLCmd As String,;
		lcDataType As String,;
		lcFieldName As String

	Local lnSQLHand As Integer,;
		lnSuccess As Integer,;
		lnLen As Integer,;
		lnWidth As Integer,;
		lnPrecision As Integer


	Local llOk As Boolean
	Local Array laFields[ 1 ]

	Try

		lcCommand = ""
		llOk = .T.

		If Empty( cXLBook )
			cXLBook = Getfile( "XLS" )
		Endif

		If Empty( cCursor )
			cCursor = "cDummy"
		Endif

		lcXLBook = cXLBook

		* Hace la cadena de conexion - invocando al driver

		*!*			lcConnstr = [Driver=] + ;
		*!*				[{Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};] + ;
		*!*				[DBQ=] + lcXLBook

		*!*			TEXT To lcConnstr NoShow TextMerge Pretext 15
		*!*			Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};
		*!*			DBQ='<<lcXLBook>>'
		*!*			ENDTEXT

		TEXT To lcConnstr NoShow TextMerge Pretext 15
		Driver={Microsoft Excel Driver (*.xls)};
		DriverId=790;
		Dbq=<<lcXLBook>>;
		ReadOnly=0;
		ENDTEXT

		*!*			TEXT To lcConnstr NoShow TextMerge Pretext 15
		*!*			Driver={Microsoft Excel Driver (*.xls)};
		*!*			Dbq='<<lcXLBook>>';
		*!*			ReadOnly=1;
		*!*			ENDTEXT

		lnSQLHand = Sqlstringconnect( lcConnstr )

		If lnSQLHand < 1
			*Esto es error de conexión
			llOk = .F.
			lcCommand = lcConnstr

		Else
			*Leer la hoja de excel

			If Empty( cBookName )
				cBookName = Juststem( cXLBook )
			Endif

			TEXT To lcSQLCmd NoShow TextMerge Pretext 15
			Select * FROM "<<cBookName>>$"
			ENDTEXT

			lcCommand = lcSQLCmd

			lnSuccess = SQLExec( lnSQLHand, lcSQLCmd, [xlResults] )

			If lnSuccess < 0
				llOk = .F.

			Else
				llOk = .T.

				If Used( cCursor )
					Select Alias( cCursor )
					Scatter Memo Blank Name loReg
					lnLen = Afields( laFields, cCursor )

				Else

					lnLen = Afields( laFields, "xlResults" )

					lcFieldName = laFields[ 1, 1 ]
					lcDataType 	= laFields[ 1, 2 ]
					lnWidth 	= laFields[ 1, 3 ]
					lnPrecision	= laFields[ 1, 4 ]

					Do Case
						Case lcDataType = "B"
							lcDataType = "N"

						Case lcDataType = "M"
							lcDataType = "C"
							lnWidth = 30

							TEXT To lcCommand1 NoShow TextMerge Pretext 15
							Calculate Max( Len( Alltrim( <<lcFieldName>> ))) To lnWidth In xlResults
							ENDTEXT

							&lcCommand1
							lcCommand1 = ""

						Case lcDataType = "T"
							lcDataType = "D"

						Otherwise

					Endcase

					Do Case
						Case lnPrecision > 0
							TEXT To lcCommand NoShow TextMerge Pretext 15
							Create Cursor <<cCursor>> ( <<lcFieldName>> <<lcDataType>>( <<lnWidth>>, <<lnPrecision>> )
							ENDTEXT

						Otherwise
							TEXT To lcCommand NoShow TextMerge Pretext 15
							Create Cursor <<cCursor>> ( <<lcFieldName>> <<lcDataType>>( <<lnWidth>> )
							ENDTEXT

					Endcase

					For i = 2 To lnLen
						lcFieldName = laFields[ i, 1 ]
						lcDataType 	= laFields[ i, 2 ]
						lnWidth 	= laFields[ i, 3 ]
						lnPrecision	= laFields[ i, 4 ]

						Do Case
							Case lcDataType = "B"
								lcDataType = "N"

							Case lcDataType = "M"
								lcDataType = "C"
								lnWidth = 30

								TEXT To lcCommand1 NoShow TextMerge Pretext 15
								Calculate Max( Len( Alltrim( <<lcFieldName>> ))) To lnWidth In xlResults
								ENDTEXT

								&lcCommand1
								lcCommand1 = ""

							Case lcDataType = "T"
								lcDataType = "D"

							Otherwise

						Endcase

						Do Case
							Case lnPrecision > 0
								TEXT To lcCommand NoShow TextMerge Pretext 15 ADDITIVE
								, <<lcFieldName>> <<lcDataType>>( <<lnWidth>>, <<lnPrecision>> )
								ENDTEXT

							Otherwise
								TEXT To lcCommand NoShow TextMerge Pretext 15 ADDITIVE
								, <<lcFieldName>> <<lcDataType>>( <<lnWidth>> )
								ENDTEXT

						Endcase


					Endfor

					lcCommand = lcCommand + ")"

					&lcCommand
					lcCommand = ""

					Select Alias( cCursor )
					Scatter Memo Blank Name loReg

				Endif

				Select xlResults
				*Browse
				Locate
				Scan

					For i = 1 To lnLen

						pepe = Field( i, "xlResults" )

						If !Empty( Field( i, "xlResults" ))

							If Isnull( Evaluate( "xlResults." + Field( i, "xlResults" ) ))
								Do Case
									Case Inlist( laFields[ i, 2 ], "C", "M", "Q", "V", "W", "G" )
										TEXT To lcCommand NoShow TextMerge Pretext 15
										loReg.<<laFields[ i, 1 ]>> = ""
										ENDTEXT

									Case Inlist( laFields[ i, 2 ], "Y", "B", "F", "I", "N" )
										TEXT To lcCommand NoShow TextMerge Pretext 15
										loReg.<<laFields[ i, 1 ]>> = 0
										ENDTEXT

									Case Inlist( laFields[ i, 2 ], "D" )
										TEXT To lcCommand NoShow TextMerge Pretext 15
										loReg.<<laFields[ i, 1 ]>> = Ctod("")
										ENDTEXT

									Case Inlist( laFields[ i, 2 ], "T" )
										TEXT To lcCommand NoShow TextMerge Pretext 15
										loReg.<<laFields[ i, 1 ]>> = Ctot("")
										ENDTEXT

									Case Inlist( laFields[ i, 2 ], "L" )
										TEXT To lcCommand NoShow TextMerge Pretext 15
										loReg.<<laFields[ i, 1 ]>> = .F.
										ENDTEXT

									Otherwise
										TEXT To lcCommand NoShow TextMerge Pretext 15
										loReg.<<laFields[ i, 1 ]>> = .NUll.
										ENDTEXT

								Endcase

							Else

								lcDataType = laFields[ i, 2 ]
								lnWidth = laFields[ i, 3 ]
								lnPrecision = laFields[ i, 4 ]

								Do Case
									Case lcDataType = "B"
										lcDataType = "N"

									Case lcDataType = "M"
										lcDataType = "C"
										lnWidth = 30

									Otherwise

								Endcase

								TEXT To lcCommand NoShow TextMerge Pretext 15
								loReg.<<laFields[ i, 1 ]>> =
									Cast( xlResults.<<Field( i, "xlResults" )>>
											As <<lcDataType>>( <<lnWidth>>, <<lnPrecision>> ) )
								ENDTEXT

							Endif

							&lcCommand
						Endif

					Endfor

					Select Alias( cCursor )
					Append Blank
					Gather Name loReg Memo

					Select xlResults
				Endscan



				*!*					Select Alias( cCursor )
				*!*					Append From Dbf("xlResults")

			Endif

			SQLDisconnect( lnSQLHand )

		Endif

		If !llOk
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ()

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Use In Select( "xlResults" )

	Endtry

	Return llOk

Endproc && Xls2Dbf


*
*
Procedure Automation(  ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""

		*============================================================
		cFileName = Getfile("XLS")
		Thisform.txt_excel.Value = Justfname(cFileName)
		Thisform.cFile = cFileName

		If File(Thisform.cFile)

			#Define xlLandscape 2
			#Define xlDoNotSaveChanges 2

			Select crsListaIndice
			Zap

			loExcel = Createobject("Excel.application")
			With loExcel
				.Application.Workbooks.Open(Thisform.cFile)
				.Visible = .T. && Muestro Excel
				For i = 1 To loExcel.activeworkbook.sheets.Count
					cHoja = Alltrim(Upper(loExcel.activeworkbook.sheets[i].Name))

					loExcel.activeworkbook.sheets[i].Activate

					lnCol = .ActiveSheet.UsedRange.Columns.Count  && -- Cantidad de columnas
					lnFil = .ActiveSheet.UsedRange.Rows.Count     && -- Cantidad de filas
					*--------------------------------------------
					For fila=2 To lnFil

						Select crsListaIndice
						Append Blank
						Replace crsListaIndice.num_escritura With Thisform.vacio(loExcel.activeworkbook.ActiveSheet.Cells(fila, 1).Value, "N")
						Replace crsListaIndice.objeto With Thisform.vacio(loExcel.activeworkbook.ActiveSheet.Cells(fila, 2).Value, "C")
						Replace crsListaIndice.otorgantes With Thisform.vacio(loExcel.activeworkbook.ActiveSheet.Cells(fila, 3).Value, "C")
						Replace crsListaIndice.fecha With Thisform.vacio(loExcel.activeworkbook.ActiveSheet.Cells(fila, 4).Value, "DT")
						Replace crsListaIndice.afavor With Thisform.vacio(loExcel.activeworkbook.ActiveSheet.Cells(fila, 5).Value, "C")
						Replace crsListaIndice.folio With Thisform.vacio(loExcel.activeworkbook.ActiveSheet.Cells(fila, 6).Value, "C")

					Next fila

				Next i

				.ActiveWindow.Close(xlDoNotSaveChanges)
				.Quit()
			Endwith
			Clear Resources Thisform.cFile

			Select crsListaIndice
			Go Top
			Thisform.grid11.Refresh
		Endif
		*======================================================================

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && Automation



