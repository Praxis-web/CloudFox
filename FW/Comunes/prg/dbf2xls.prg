Lparameters tcAlias As String,;
	tcXlsName As String,;
	tcUDF As String,;
	toSetup As Object

#INCLUDE "FW\Comunes\Include\Excel.h"
#INCLUDE "FW\Comunes\Include\Praxis.h"


#Define TITLEFONT_COLOR	-8566497
#Define TITLEFONT_NAME	"Cambria"
#Define TITLEFONT_SIZE	18
#Define XLS_CHARSET	26


Local lcCommand As String,;
	lcFileName As String
Local loXls As oXls Of "FW\Comunes\prg\dbf2xls.prg"

Try

	lcCommand = ""
	loXls = Createobject( "oXls" )

	If Empty( tcUDF )
		tcUDF = ""
	Endif

	If Empty( tcXlsName )
		tcXlsName = ""
	Endif

	If Empty( tcAlias )
		tcAlias = Alias()
	Endif

	If IsEmpty( toSetup )
		toSetup = Createobject( "Empty" )
	Endif

	If !Pemstatus( toSetup, "cAlias", 5 )
		AddProperty( toSetup, "cAlias", tcAlias )
	Endif

	If !Pemstatus( toSetup, "cFileName", 5 )
		AddProperty( toSetup, "cFileName", tcXlsName )
	Endif

	If !Pemstatus( toSetup, "lForce", 5 )
		AddProperty( toSetup, "lForce", .F. )
	Endif

	If !Pemstatus( toSetup, "cUDF", 5 )
		AddProperty( toSetup, "cUDF", tcUDF )
	Endif

	loXls.oSetup 	= toSetup
	loXls.cAlias 	= toSetup.cAlias
	loXls.cFileName = toSetup.cFileName
	loXls.Process()
	lcFileName = loXls.cFileName

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally
	toSetup = Null
	loXls 	= Null

Endtry

Return lcFileName




*!* ///////////////////////////////////////////////////////
*!* Class.........: oExcel
*!* Description...:
*!* Date..........: Domingo 31 de Diciembre de 2017 (11:41:45)
*!*
*!*

Define Class oXls As Custom

	#If .F.
		Local This As oXls Of "FW\Comunes\prg\dbf2xls.prg"
	#Endif

	oExcel = Null
	oSetup = Null

	cFileName 	= ""
	cAlias 		= ""

	* Nombre de la Hoja
	cSheetName = ""

	* Numero de la Hoja
	nSheetNumber = 1

	* Extensión por defecto
	cXlsExt = "Xlsx"

	* Abre Visible
	lVisible = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="oexcel" type="property" display="oExcel" />] + ;
		[<memberdata name="oexcel_access" type="method" display="oExcel_Access" />] + ;
		[<memberdata name="osetup" type="property" display="oSetup" />] + ;
		[<memberdata name="cfilename" type="property" display="cFileName" />] + ;
		[<memberdata name="calias" type="property" display="cAlias" />] + ;
		[<memberdata name="csheetname" type="property" display="cSheetName" />] + ;
		[<memberdata name="nsheetnumber" type="property" display="nSheetNumber" />] + ;
		[<memberdata name="cxlsext" type="property" display="cXlsExt" />] + ;
		[<memberdata name="validarparametros" type="method" display="ValidarParametros" />] + ;
		[<memberdata name="abrir" type="method" display="Abrir" />] + ;
		[<memberdata name="process" type="method" display="Process" />] + ;
		[<memberdata name="crearxls" type="method" display="CrearXls" />] + ;
		[<memberdata name="formatearxls" type="method" display="FormatearXls" />] + ;
		[<memberdata name="addsheet" type="method" display="AddSheet" />] + ;
		[<memberdata name="setactvesheet" type="method" display="SetActveSheet" />] + ;
		[<memberdata name="fillfromcursor" type="method" display="FillFromCursor" />] + ;
		[<memberdata name="grabar" type="method" display="Grabar" />] + ;
		[<memberdata name="xlscols" type="method" display="xlsCols" />] + ;
		[<memberdata name="xlscolumn" type="method" display="xlsColumn" />] + ;
		[<memberdata name="xlscell" type="method" display="xlsCell" />] + ;
		[<memberdata name="lvisible" type="property" display="lVisible" />] + ;
		[</VFPData>]



	*
	*
	Procedure Process(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If Used( Alias( This.oSetup.cAlias ))

				If This.CrearXls()
					If This.Abrir( This.cFileName, This.nSheetNumber )
						This.FormatearXls()
						This.Grabar()
					Endif

				Endif

			Else
				Warning( "No Existe el Cursor " + This.oSetup.cAlias )

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			This.oExcel = Null

		Endtry

	Endproc && Process



	*
	*
	Procedure ValidarParametros(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If !Pemstatus( This, "oSetup", 5 )
				AddProperty( This, "oSetup", Createobject( "Empty" ) )
			Endif

			If Vartype( This.oSetup ) # "O"
				This.oSetup = Createobject( "Empty" )
			Endif

			If !Pemstatus( This.oSetup, "cAlias", 5 )
				AddProperty( This.oSetup, "cAlias", "" )
			Endif

			If !Pemstatus( This.oSetup, "cFileName", 5 )
				AddProperty( This.oSetup, "cFileName", "" )
			Endif

			If !Pemstatus( This.oSetup, "lForce", 5 )
				AddProperty( This.oSetup, "lForce", .F. )
			Endif

			If !Pemstatus( This.oSetup, "cUDF", 5 )
				AddProperty( This.oSetup, "cUDF", "" )
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && ValidarParametros


	*
	*
	Procedure CrearXls(  ) As Void
		Local lcCommand As String,;
			lcFileName As String,;
			lcDefault As String,;
			lcCurDir As String,;
			lcXLSDir As String


		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .F.

			This.ValidarParametros()

			If Empty( This.oSetup.cFileName )
				This.oSetup.cFileName = This.cFileName
			Endif

			If Empty( This.oSetup.cFileName )
				This.oSetup.cFileName = DateMask( " MM yyyy" )
			Endif

			lcFileName 	= This.oSetup.cFileName
			lcDefault 	= Set("Default")
			lcCurDir 	= Curdir()

			lcXLSDir = GetValue( "RutaXLS", "ar0Var", Space(0) )

			If Empty( lcXLSDir )
				lcXLSDir = GetValue( "Exel0", "ar0Est", Space(0) )
			Endif

			If Empty( lcXLSDir )
				lcXLSDir = Getenv("HOMEDRIVE") + Getenv("HOMEPATH")
			Endif

			lcXLSDir = Addbs( Alltrim( lcXLSDir ))

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Cd '<<lcXLSDir>>'
			ENDTEXT

			Try
				&lcCommand

			Catch To oErr

			Finally

			Endtry

			Wait Clear

			lcFileName = Putfile( "", This.oSetup.cFileName, "XLS" )
			This.oSetup.cFileName = lcFileName
			This.cFileName = lcFileName

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Cd '<<lcDefault>><<lcCurDir>>'
			ENDTEXT

			&lcCommand


			If !Empty( lcFileName )

				If Empty( This.cAlias )
					This.cAlias = This.oSetup.cAlias
				Endif

				If Empty( This.oSetup.cAlias )
					This.oSetup.cAlias = This.cAlias
				Endif

				Select Alias( This.cAlias )
				Copy To ( lcFileName ) Type Xl5
				Locate

				llOk = ( Vartype( This.oExcel ) = "O" )

			Endif


		Catch To loErr
			*Local loErr As Exception
			*Set Step On
			If loErr.ErrorNo = 1426 && OLE error code 0x"name"

				TEXT To lcMsg NoShow TextMerge Pretext 03
				No se puede crear:
				"<<lcFileName>>"

				Verifique que una planilla con el mismo nombre
				no se encuentre abierta

				El error es:
				<<loErr.Message>>
				ENDTEXT

				Stop( lcMsg, "Error al Crear Planilla de Cálculo" )

			Else
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = lcCommand
				loError.Process ( m.loErr )
				Throw loError

			Endif

		Finally

		Endtry

		Return llOk

	Endproc && CrearXls


	*
	*
	Procedure Abrir( cFileName As String, uSheet As Variant ) As Void
		Local lcCommand As String,;
			lcFileName As String

		Local luSheet As Variant
		Local llOk As Boolean

		Local loExcel As "Excel.Application",;
			loSheet As "Excel.WorkSheet"

		Try

			lcCommand = ""
			llOk = .F.

			lcFileName = cFileName
			lcFileName = Defaultext( lcFileName, This.cXlsExt )

			If !Empty( uSheet )
				luSheet = uSheet

			Else
				luSheet = This.cSheetName

				If Empty( luSheet )
					luSheet = This.nSheetNumber
				Endif

			Endif

			loExcel = This.oExcel


			loExcel.Visible = This.lVisible

			TEXT To lcCommand NoShow TextMerge Pretext 15
			loSheet = loExcel.Workbooks.Open( '<<lcFileName>>' ).Sheets.Item( <<luSheet>> )
			ENDTEXT

			loSheet = loExcel.Workbooks.Open( lcFileName ).Sheets.Item( luSheet )
			loSheet.Activate()

			llOk = .T.

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && Abrir

	*
	*
	Procedure FormatearXls( cAlias As String ) As Void
		Local lcCommand As String
		Local loParam As Object

		Local lnVersion As Integer,;
			lnColumns As Integer,;
			lnRows As Integer


		Local loExcel As "Excel.Application",;
			loSheet As "Excel.WorkSheet",;
			loFields As oXlsFieldsCollection Of "FW\Comunes\prg\dbf2xls.prg",;
			loField As oField Of "FW\Comunes\prg\dbf2xls.prg",;
			loHeader As oField Of "FW\Comunes\prg\dbf2xls.prg",;
			loAlignment As oAlignment Of "FW\Comunes\prg\dbf2xls.prg"

		Try

			lcCommand 	= ""
			lnVersion 	= 1
			loExcel 	= This.oExcel

			If Pemstatus( This.oSetup, "oFields", 5 )
				If Pemstatus( This.oSetup.oFields, "nVersion", 5 )
					lnVersion = This.oSetup.oFields.nVersion
				Endif
			Endif

			If Val( loExcel.Version ) < Val( OFFICE_2007 )
				lnVersion = 1
			Endif

			If lnVersion = 1
				This.FormatearXls_Old( cAlias )

			Else

				If !Empty( cAlias )
					This.oSetup.cAlias = cAlias
					This.cAlias = cAlias
				Endif

				cAlias = This.cAlias

				loParam = Createobject( "Empty" )

				AddProperty( loParam, "oExcel",    loExcel )
				AddProperty( loParam, "cFileName", This.oSetup.cFileName )
				AddProperty( loParam, "cAlias",    This.oSetup.cAlias )
				AddProperty( loParam, "oSetup",    This.oSetup )


				Try

					* Formatear Font

					loExcel.Cells.Select

					With loExcel.Selection.Font

						If Val( loExcel.Version ) >= Val( OFFICE_2007 )
							.TintAndShade = 0
						Endif

					Endwith

					lnColumns 	= Afields( laFields, cAlias )
					lnRows 		= Reccount( cAlias ) + 1

					AddProperty( loParam, "nColumns", lnColumns )
					AddProperty( loParam, "nRows", lnRows )

					loFields 	= Null
					loField 	= Null
					If Pemstatus( This.oSetup, "oFields", 5 )
						loFields = This.oSetup.oFields

						For i = 1 To lnColumns

							*loExcel.Columns( This.xlsCols( i, i ) ).Select

							loField = Null
							loField = loFields.GetItem( laFields[ i, 1 ] )

							If Vartype( loField ) = "O"
								loField.Inicializar()
								loExcel.Range( This.xlsCell( i, 2 ), This.xlsCell( i, lnRows )).Select

								If !Empty( loField.cFormulaDeCelda )
									loExcel.Selection.FormulaR1C1 = loField.cFormulaDeCelda
								Endif

								loExcel.Selection.NumberFormat = loField.cFormatoDeCelda

								loAlignment = loField.oAlignment
								With loExcel.Selection.Cells
									.HorizontalAlignment 	= loAlignment.nHorizontalAlignment
									.VerticalAlignment 		= loAlignment.nVerticalAlignment
									.WrapText 				= loAlignment.lWrapText
									.Orientation 			= loAlignment.nOrientation
									.AddIndent 				= loAlignment.lAddIndent
									.IndentLevel 			= loAlignment.nIndentLevel
									.ShrinkToFit 			= loAlignment.lShrinkToFit
									.ReadingOrder 			= loAlignment.nReadingOrder
									.MergeCells 			= loAlignment.lMergeCells
								Endwith

							Else
								loExcel.Columns( This.xlsCols( i, i ) ).Select

								Do Case
									Case Inlist( laFields[ i, 2 ], "D", "T" )
										loExcel.Selection.NumberFormat = "dd-mm-yyyy;@"
										loExcel.Selection.HorizontalAlignment = xlCenter

									Case Inlist( laFields[ i, 2 ], "Y", "I", "N" )
										If Empty( laFields[ i, 4 ] )
											loExcel.Selection.NumberFormat = "#0_ ;[Red]-#0 "

										Else
											lcDec = Replicate( "0", laFields[ i, 4 ] )

											TEXT To lcCommand NoShow TextMerge Pretext 15
											loExcel.Selection.NumberFormat = "#,##0.<<lcDec>>_ ;[Red]-#,##0.<<lcDec>> "
											ENDTEXT

											&lcCommand

										Endif

									Otherwise

								Endcase

							Endif

							* Header
							loExcel.Range( This.xlsColumn( i ) + "1").Select

							lcHeader = Proper( Strtran( laFields[ i, 1 ], "_", " " ))
							loExcel.ActiveCell.FormulaR1C1 = lcHeader

						Endfor

					Else

						For i = 1 To lnColumns

							loExcel.Columns( This.xlsCols( i, i ) ).Select

							Do Case
								Case Inlist( laFields[ i, 2 ], "D", "T" )
									loExcel.Selection.NumberFormat = "dd-mm-yyyy;@"

								Case Inlist( laFields[ i, 2 ], "Y", "I", "N" )
									If Empty( laFields[ i, 4 ] )
										loExcel.Selection.NumberFormat = "#0_ ;[Red]-#0 "

									Else
										lcDec = Replicate( "0", laFields[ i, 4 ] )

										TEXT To lcCommand NoShow TextMerge Pretext 15
									loExcel.Selection.NumberFormat = "#,##0.<<lcDec>>_ ;[Red]-#,##0.<<lcDec>> "
										ENDTEXT

										&lcCommand

									Endif

								Otherwise

							Endcase

							loExcel.Range( This.xlsColumn( i ) + "1").Select

							lcHeader = Proper( Strtran( laFields[ i, 1 ], "_", " " ))
							loExcel.ActiveCell.FormulaR1C1 = lcHeader

						Endfor

					Endif

					* Formatear Titulo
					Wait Window "Formatear Titulo" Nowait

					loExcel.Rows("1:1").Select
					loExcel.Selection.Font.Bold = .T.
					With loExcel.Selection.Font
						.Color 	= TITLEFONT_COLOR
						.Name 	= TITLEFONT_NAME
						.Size 	= TITLEFONT_SIZE

						If Val( loExcel.Version ) >= Val( OFFICE_2007 )
							.TintAndShade = 0
						Endif

					Endwith

					Try

						loExcel.Selection.AutoFilter

					Catch To oErr

					Finally

					Endtry



					* Seleccionar las columnas de la primer fila
					loExcel.Range( This.xlsColumn( 1 ) + "1:" + This.xlsColumn( lnColumns ) + "1").Select
					With loExcel.Selection.Interior
						.Pattern = xlSolid
						.PatternColorIndex = xlAutomatic


						If Val( loExcel.Version ) >= Val( OFFICE_2007 )
							.TintAndShade = -4.99893185216834E-02
							.ThemeColor = xlThemeColorDark1
							.PatternTintAndShade = 0
						Endif

					Endwith

					With loExcel.Selection.BorderS(xlEdgeBottom)
						.LineStyle = xlContinuous
						.ColorIndex = 0
						.Weight = xlThick

						If Val( loExcel.Version ) >= Val( OFFICE_2007 )
							.TintAndShade = 0
						Endif

					Endwith

					* Marcar las líneas verticales y la de abajo

					loExcel.Range( This.xlsColumn( 1 ) + "1:" + This.xlsColumn( lnColumns ) + Transform( lnRows ) ).Select

					Try

						With loExcel.Selection.BorderS(xlEdgeLeft)
							.LineStyle = xlContinuous
							.ColorIndex = xlAutomatic
							.Weight = xlThin

							If Val( loExcel.Version ) >= Val( OFFICE_2007 )
								.TintAndShade = 0
							Endif

						Endwith

					Catch To oErr

					Finally

					Endtry

					Try

						With loExcel.Selection.BorderS(xlEdgeRight)
							.LineStyle = xlContinuous
							.ColorIndex = xlAutomatic
							.Weight = xlThin

							If Val( loExcel.Version ) >= Val( OFFICE_2007 )
								.TintAndShade = 0
							Endif

						Endwith

					Catch To oErr

					Finally

					Endtry

					Try

						With loExcel.Selection.BorderS(xlInsideVertical)
							.LineStyle = xlContinuous
							.ColorIndex = xlAutomatic
							.Weight = xlThin

							If Val( loExcel.Version ) >= Val( OFFICE_2007 )
								.TintAndShade = 0
							Endif

						Endwith

					Catch To oErr

					Finally

					Endtry

					Try

						loExcel.Range( This.xlsColumn( 1 ) + Transform( lnRows ) + ":" + This.xlsColumn( lnColumns ) + Transform( lnRows ) ).Select

					Catch To oErr

					Finally

					Endtry

					Try

						With loExcel.Selection.BorderS(xlEdgeBottom)
							.LineStyle = xlContinuous
							.ColorIndex = xlAutomatic
							.Weight = xlThin

							If Val( loExcel.Version ) >= Val( OFFICE_2007 )
								.TintAndShade = 0
							Endif

						Endwith

					Catch To oErr

					Finally

					Endtry

					* Color de Fondo
					Try

						loExcel.Range( This.xlsColumn( 1 ) + "2:" + This.xlsColumn( lnColumns ) + Transform( lnRows ) ).Select
						With loExcel.Selection.Interior
							.Pattern = xlSolid
							.PatternColorIndex = xlAutomatic
							.Color = Int( Rgb( 235, 255, 255 ))

							If Val( loExcel.Version ) >= Val( OFFICE_2007 )
								.TintAndShade = 0
								.PatternTintAndShade = 0
							Endif

						Endwith

					Catch To oErr

					Finally

					Endtry

					Try

						With loExcel.ActiveWindow
							.SplitColumn = 0
							.SplitRow = 1
						Endwith
						loExcel.ActiveWindow.FreezePanes = .T.

					Catch To oErr

					Finally

					Endtry

					If Vartype( loFields ) = "O"

						* Header y Totales

						If loFields.nHeaderHeight > 0
							loHeader 	= loFields.oHeader
							loAlignment = loHeader.oAlignment

							loExcel.Rows("1:1").RowHeight = loFields.nHeaderHeight

							For i = 1 To lnColumns
								loExcel.Range( This.xlsCell( i, 1 )).Select
								
								loExcel.ActiveCell.HorizontalAlignment 	= xlCenter
								loExcel.ActiveCell.VerticalAlignment 	= xlCenter
								
								If GetWordCount( loExcel.ActiveCell.FormulaR1C1 ) = 1 
									loExcel.ActiveCell.WrapText = .F.
									
								Else
									loExcel.ActiveCell.WrapText = .T.
										
								EndIf
								
							Endfor

						Endif

						For Each loField In This.oSetup.oFields

							If loField.lTotaliza
								Do Case
									Case loField.lSuma

										lnColumn = Ascan( laFields, loField.cName, 1, lnColumns , 1, 9 )

										If !Empty( lnColumn )

											loExcel.Range( This.xlsCell( lnColumn, lnRows+1 )).Select
											
											Text To lcFormula NoShow TextMerge Pretext 15
											=SUM(<<This.xlsCell( lnColumn, 2 )>>:<<This.xlsCell( lnColumn, lnRows )>>)
											EndText
											
											loExcel.ActiveCell.Formula 		= lcFormula
											loExcel.ActiveCell.Font.Bold 	= .T.
											loExcel.ActiveCell.NumberFormat = loField.cFormatoDeCelda 

										Endif

									Case !Empty( loField.cFormulaDelTotal )

										lnColumn = Ascan( laFields, loField.cName, 1, lnColumns , 1, 9 )

										If !Empty( lnColumn )
											loExcel.Range( This.xlsCell( lnColumn, lnRows+1 )).Select
											
											loExcel.ActiveCell.FormulaR1C1 	= loField.cFormulaDelTotal
											loExcel.ActiveCell.Font.Bold 	= .T.
											loExcel.ActiveCell.NumberFormat = loField.cFormatoDeCelda 

										Endif



									Otherwise

								Endcase
							Endif

						EndFor
						
						loExcel.Range("A2").Select

					Endif


				Catch To loErr
					Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
					loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
					loError.cRemark = "Error al Formatear Excel"
					loError.lShowError = .F.
					loError.lLogError = .T.
					loError.Process( loErr )

				Finally

				Endtry

				* Auto Ajustar Columnas
				Wait Window "Auto Ajustar Columnas" Nowait

				loExcel.Cells.Select
				loExcel.Selection.Columns.AutoFit

				* Si existe algna UDF, llamarla pasando el objeto como parámetro

				Do Case
					Case Pemstatus( This.oSetup, "cUDF", 5 )

						lcUDF = This.oSetup.cUDF

						TEXT To lcCommand NoShow TextMerge Pretext 15
						<<lcUDF>>( loParam )
						ENDTEXT

						If Pemstatus( This.oSetup, "oMain", 5 )
							lcCommand = "This.oSetup.oMain." + lcCommand
						Endif

						Evaluate( lcCommand )

					Case !Empty( lcUDF )
						Try

							TEXT To lcCommand NoShow TextMerge Pretext 15
							<<lcUDF>>( loParam )
							ENDTEXT

							Evaluate( lcCommand )

						Catch To oErr
							Try

								* RA 2013-04-30(13:00:41)
								* Version anterior, pasando solo el objeto Excel
								TEXT To lcCommand NoShow TextMerge Pretext 15
							<<lcUDF>>( loExcel )
								ENDTEXT

								Evaluate( lcCommand )

							Catch To oErr

							Finally

							Endtry

						Finally

						Endtry

				Endcase

				loExcel.Range("A2").Select

			Endif


		Catch To loErr

			Try

				loExcel.Range("A2").Select
				loExcel.Visible = .T.
				loExcel.ActiveWorkbook.Save
				loExcel.Quit()

			Catch To oErr

			Finally

			Endtry

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Wait Clear
			loExcel = Null

		Endtry

	Endproc && FormatearXls

	*
	*
	Procedure FormatearXls_Old( cAlias As String ) As Void
		Local lcCommand As String
		Local loParam As Object

		Local loExcel As "Excel.Application",;
			loSheet As "Excel.WorkSheet"

		Try

			lcCommand = ""

			If !Empty( cAlias )
				This.oSetup.cAlias = cAlias
				This.cAlias = cAlias
			Endif

			cAlias = This.cAlias

			loExcel = This.oExcel

			loParam = Createobject( "Empty" )

			AddProperty( loParam, "oExcel",    loExcel )
			AddProperty( loParam, "cFileName", This.oSetup.cFileName )
			AddProperty( loParam, "cAlias",    This.oSetup.cAlias )
			AddProperty( loParam, "oSetup",    This.oSetup )


			Try

				* Formatear Font

				loExcel.Cells.Select

				With loExcel.Selection.Font

					If Val( loExcel.Version ) >= Val( OFFICE_2007 )
						.TintAndShade = 0
					Endif

				Endwith

				lnColumns 	= Afields( laFields, cAlias )
				lnRows 		= Reccount( cAlias ) + 1

				AddProperty( loParam, "nColumns", lnColumns )
				AddProperty( loParam, "nRows", lnRows )

				For i = 1 To lnColumns

					loExcel.Columns( This.xlsCols( i, i ) ).Select

					Do Case
						Case Inlist( laFields[ i, 2 ], "D", "T" )
							loExcel.Selection.NumberFormat = "dd-mm-yyyy;@"

						Case Inlist( laFields[ i, 2 ], "Y", "I", "N" )
							If Empty( laFields[ i, 4 ] )
								loExcel.Selection.NumberFormat = "#0_ ;[Red]-#0 "

							Else
								lcDec = Replicate( "0", laFields[ i, 4 ] )

								TEXT To lcCommand NoShow TextMerge Pretext 15
									loExcel.Selection.NumberFormat = "#,##0.<<lcDec>>_ ;[Red]-#,##0.<<lcDec>> "
								ENDTEXT

								&lcCommand

							Endif

						Otherwise

					Endcase

					loExcel.Range( This.xlsColumn( i ) + "1").Select

					lcHeader = Proper( Strtran( laFields[ i, 1 ], "_", " " ))
					loExcel.ActiveCell.FormulaR1C1 = lcHeader

				Endfor


				* Formatear Titulo
				Wait Window "Formatear Titulo" Nowait

				loExcel.Rows("1:1").Select
				loExcel.Selection.Font.Bold = .T.
				With loExcel.Selection.Font
					.Color = TITLEFONT_COLOR
					.Name = TITLEFONT_NAME
					.Size = TITLEFONT_SIZE

					If Val( loExcel.Version ) >= Val( OFFICE_2007 )
						.TintAndShade = 0
					Endif

				Endwith

				Try

					loExcel.Selection.AutoFilter

				Catch To oErr

				Finally

				Endtry



				* Seleccionar las columnas de la primer fila
				loExcel.Range( This.xlsColumn( 1 ) + "1:" + This.xlsColumn( lnColumns ) + "1").Select
				With loExcel.Selection.Interior
					.Pattern = xlSolid
					.PatternColorIndex = xlAutomatic


					If Val( loExcel.Version ) >= Val( OFFICE_2007 )
						.TintAndShade = -4.99893185216834E-02
						.ThemeColor = xlThemeColorDark1
						.PatternTintAndShade = 0
					Endif

				Endwith

				With loExcel.Selection.BorderS(xlEdgeBottom)
					.LineStyle = xlContinuous
					.ColorIndex = 0
					.Weight = xlThick

					If Val( loExcel.Version ) >= Val( OFFICE_2007 )
						.TintAndShade = 0
					Endif

				Endwith

				* Marcar las líneas verticales y la de abajo

				loExcel.Range( This.xlsColumn( 1 ) + "1:" + This.xlsColumn( lnColumns ) + Transform( lnRows ) ).Select

				Try

					With loExcel.Selection.BorderS(xlEdgeLeft)
						.LineStyle = xlContinuous
						.ColorIndex = xlAutomatic
						.Weight = xlThin

						If Val( loExcel.Version ) >= Val( OFFICE_2007 )
							.TintAndShade = 0
						Endif

					Endwith

				Catch To oErr

				Finally

				Endtry

				Try

					With loExcel.Selection.BorderS(xlEdgeRight)
						.LineStyle = xlContinuous
						.ColorIndex = xlAutomatic
						.Weight = xlThin

						If Val( loExcel.Version ) >= Val( OFFICE_2007 )
							.TintAndShade = 0
						Endif

					Endwith

				Catch To oErr

				Finally

				Endtry

				Try

					With loExcel.Selection.BorderS(xlInsideVertical)
						.LineStyle = xlContinuous
						.ColorIndex = xlAutomatic
						.Weight = xlThin

						If Val( loExcel.Version ) >= Val( OFFICE_2007 )
							.TintAndShade = 0
						Endif

					Endwith

				Catch To oErr

				Finally

				Endtry

				Try

					loExcel.Range( This.xlsColumn( 1 ) + Transform( lnRows ) + ":" + This.xlsColumn( lnColumns ) + Transform( lnRows ) ).Select

				Catch To oErr

				Finally

				Endtry

				Try

					With loExcel.Selection.BorderS(xlEdgeBottom)
						.LineStyle = xlContinuous
						.ColorIndex = xlAutomatic
						.Weight = xlThin

						If Val( loExcel.Version ) >= Val( OFFICE_2007 )
							.TintAndShade = 0
						Endif

					Endwith

				Catch To oErr

				Finally

				Endtry

				* Color de Fondo
				Try

					loExcel.Range( This.xlsColumn( 1 ) + "2:" + This.xlsColumn( lnColumns ) + Transform( lnRows ) ).Select
					With loExcel.Selection.Interior
						.Pattern = xlSolid
						.PatternColorIndex = xlAutomatic
						.Color = Int( Rgb( 235, 255, 255 ))

						If Val( loExcel.Version ) >= Val( OFFICE_2007 )
							.TintAndShade = 0
							.PatternTintAndShade = 0
						Endif

					Endwith

				Catch To oErr

				Finally

				Endtry

				Try

					With loExcel.ActiveWindow
						.SplitColumn = 0
						.SplitRow = 1
					Endwith
					loExcel.ActiveWindow.FreezePanes = .T.

				Catch To oErr

				Finally

				Endtry

				If Pemstatus( This.oSetup, "oFields", 5 )
					For Each oField In This.oSetup.oFields

						Do Case
							Case Pemstatus( oField, "lSuma", 5 )
								If oField.lSuma

									lnColumn = Ascan( laFields, oField.Name, 1, lnColumns , 1, 9 )

									If !Empty( lnColumn )
										TEXT To lcCommand NoShow TextMerge Pretext 15
										loExcel.ActiveSheet.Range( '<<This.xlsColumn( lnColumn )>><<lnRows+1>>' ).Formula =
										'=SUM(<<This.xlsColumn( lnColumn )>><<2>>:<<This.xlsColumn( lnColumn )>><<lnRows>>)'
										ENDTEXT

										&lcCommand

										TEXT To lcCommand NoShow TextMerge Pretext 15
										loExcel.ActiveSheet.Range( '<<This.xlsColumn( lnColumn )>><<lnRows+1>>' ).Font.Bold = .T.
										ENDTEXT

										&lcCommand

									Endif
								Endif

							Case Pemstatus( oField, "lExpresion", 5 )
								If oField.lExpresion And Pemstatus( oField, "cExpresion", 5 )
									*!*	Range("J4").Select
									*!*	ActiveCell.FormulaR1C1 = "=((+RC[-5]/RC[-4])-1)*100"
									*!*	ActiveCell.FormulaR1C1 = "=+R[-4]C[-4]*R[-2]C[-3]-R[-3]C[1]*R[-1]C[2]"
									*!*	ActiveCell.FormulaR1C1 = "=+RC[-4]+R[-2]C[-3]-R[-1]C[-2]+RC[-1]"

									lnColumn = Ascan( laFields, oField.Name, 1, lnColumns , 1, 9 )

									If !Empty( lnColumn )
										TEXT To lcCommand NoShow TextMerge Pretext 15
										loExcel.ActiveSheet.Range( '<<This.xlsColumn( lnColumn )>><<lnRows+1>>' ).FormulaR1C1 =
										'<<oField.cExpresion>>'
										ENDTEXT

										&lcCommand

										TEXT To lcCommand NoShow TextMerge Pretext 15
										loExcel.ActiveSheet.Range( '<<This.xlsColumn( lnColumn )>><<lnRows+1>>' ).Font.Bold = .T.
										ENDTEXT

										&lcCommand

									Endif

								Endif

							Otherwise

						Endcase


					Endfor
				Endif


			Catch To loErr
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = "Error al Formatear Excel"
				loError.lShowError = .F.
				loError.lLogError = .T.
				loError.Process( loErr )

			Finally

			Endtry

			* Auto Ajustar Columnas
			Wait Window "Auto Ajustar Columnas" Nowait

			loExcel.Cells.Select
			loExcel.Selection.Columns.AutoFit

			* Si existe algna UDF, llamarla pasando el objeto como parámetro

			Do Case
				Case Pemstatus( This.oSetup, "cUDF", 5 )

					lcUDF = This.oSetup.cUDF

					TEXT To lcCommand NoShow TextMerge Pretext 15
						<<lcUDF>>( loParam )
					ENDTEXT

					If Pemstatus( This.oSetup, "oMain", 5 )
						lcCommand = "This.oSetup.oMain." + lcCommand
					Endif

					Evaluate( lcCommand )

				Case !Empty( lcUDF )
					Try

						TEXT To lcCommand NoShow TextMerge Pretext 15
							<<lcUDF>>( loParam )
						ENDTEXT

						Evaluate( lcCommand )

					Catch To oErr
						Try

							* RA 2013-04-30(13:00:41)
							* Version anterior, pasando solo el objeto Excel
							TEXT To lcCommand NoShow TextMerge Pretext 15
							<<lcUDF>>( loExcel )
							ENDTEXT

							Evaluate( lcCommand )

						Catch To oErr

						Finally

						Endtry

					Finally

					Endtry

			Endcase

			loExcel.Range("A1").Select


		Catch To loErr

			Try

				loExcel.Range("A1").Select
				loExcel.Visible = .T.
				loExcel.ActiveWorkbook.Save
				loExcel.Quit()

			Catch To oErr

			Finally

			Endtry

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Wait Clear
			loExcel = Null

		Endtry

	Endproc && FormatearXls_Old

	*
	*
	Procedure SetActveSheet( uSheet As Variant ) As "Excel.WorkSheet"
		Local lcCommand As String

		Local loExcel As "Excel.Application",;
			loSheet As "Excel.WorkSheet"

		Try

			lcCommand = ""
			loExcel = This.oExcel
			loSheet = loExcel.ActiveSheet

			If !Empty( uSheet )

				Do Case
					Case Vartype( uSheet ) = "N"


						If Between( uSheet, 1, loExcel.Sheets.Count )
							loSheet = loExcel.Sheets.Item( uSheet )
							loSheet.Activate()

						Else
							loSheet = loExcel.ActiveSheet

							TEXT To lcMsg NoShow TextMerge Pretext 03
							El Número de Hoja ( <<uSheet>> ) es Invalido
							ENDTEXT

							Stop( lcMsg )

						Endif

					Case Vartype( uSheet ) = "C"
						Try

							loSheet_Aux = loExcel.Sheets.Item( uSheet )
							loSheet = loSheet_Aux
							loSheet.Activate()

						Catch To oErr
							TEXT To lcMsg NoShow TextMerge Pretext 03
							El Nombre de la Hoja ( <<uSheet>> ) es Invalido
							ENDTEXT

							Stop( lcMsg )

						Finally

						Endtry

				Endcase

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loSheet

	Endproc && SetActveSheet



	*
	*
	Procedure AddSheet( cName As String ) As Void
		Local lcCommand As String,;
			lcSheetName As String

		Local loExcel As "Excel.Application",;
			loActualSheet As "Excel.WorkSheet",;
			loNewSheet As "Excel.WorkSheet"

		Try

			lcCommand = ""
			loExcel = This.oExcel
			loActualSheet = loExcel.ActiveSheet

			loNewSheet = loExcel.Sheets.Add( Null, loActualSheet )

			If !Empty( cName )
				loNewSheet.Name = Alltrim( cName )
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loNewSheet

	Endproc && AddSheet




	*
	*
	Procedure FillFromCursor( cAlias As String, cSheetName As String ) As Void
		Local lcCommand As String,;
			lcHeader As String

		Local loExcel As "Excel.Application",;
			loSheet As "Excel.WorkSheet"

		Local Array laFields[ 1 ]

		Local lnLen As Integer,;
			lnCol As Integer,;
			lnRow As Integer,;
			lnRows As Integer

		Local luValue As Variant

		Local loTherm As _thermometer Of "fw\ffc\_therm.vcx"
		Local lnRegistros As Integer,;
			i As Integer,;
			lnPercent As Integer,;
			lnRecno As Integer


		Try

			lcCommand = ""

			loExcel = This.oExcel
			loSheet = loExcel.ActiveSheet

			loTherm = Newobject("_thermometer","fw\ffc\_therm.vcx" )
			loTherm.Show()

			If Empty( cSheetName )
				cSheetName = Juststem( This.cFileName )
			Endif

			Wait Clear
			lcProceso = "Generando " + cSheetName

			This.cAlias = cAlias

			lnLen = Afields( laFields, cAlias )
			lnRow = 1

			For lnCol = 1 To lnLen
				lcHeader = laFields[ lnCol, 1 ]
				loExcel.Range( This.xlsColumn( lnCol ) + Transform( lnRow )).Select
				loExcel.ActiveCell.FormulaR1C1 = lcHeader
			Endfor

			Select Alias( cAlias )
			lnRows = Reccount()
			Locate

			Scan
				lnRow = lnRow + 1


				lnPercent = lnRow / lnRows * 100

				loTherm.Update( lnPercent, lcProceso )

				For lnCol = 1 To lnLen
					luValue = Evaluate( Field( lnCol, cAlias ) )
					loExcel.Range( This.xlsColumn( lnCol ) + Transform( lnRow )).Select

					If Inlist( Vartype( luValue ), "D", "T" )

						If !Empty( luValue )
							TEXT To ldValue NoShow TextMerge Pretext 15
							=DATE(<<Year( luValue )>>,<<Month( luValue )>>,<<Day( luValue )>>)
							ENDTEXT

							loExcel.ActiveCell.FormulaR1C1 = ldValue
						Endif

					Else
						loExcel.ActiveCell.FormulaR1C1 = Transform( luValue )

					Endif

				Endfor

			Endscan

			loTherm.Hide()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			If Vartype( loTherm ) = "O"
				loTherm.Release()
			Endif

			loTherm = Null
			loSheet = Null
			loExcel = Null

		Endtry

	Endproc && FillFromCursor


	*
	*
	Procedure Grabar(  ) As Void
		Local lcCommand As String
		Local loExcel As "Excel.Application",;
			loSheet As "Excel.WorkSheet"

		Try

			lcCommand = ""

			loExcel = This.oExcel

			* Grabar y Mostrar
			loExcel.Range("A1").Select
			loExcel.Visible = .T.
			loExcel.ActiveWorkbook.Save


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loExcel = Null

		Endtry

	Endproc && Grabar



	*
	*
	Procedure xlsCell( nCol As Integer, nRow As Integer ) As Void
		Local lcCommand As String,;
			lcCell As String

		Try

			lcCommand = ""
			lcCell = This.xlsColumn( nCol ) + Transform( nRow )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lcCell

	Endproc && xlsCell


	*
	*
	Procedure xlsCols( nCol1 As Integer,;
			nCol2 As Integer ) As String

		Return This.xlsColumn( nCol1 ) + ":" + This.xlsColumn( nCol2 )

	Endproc && xlsCols




	*
	*
	Procedure xlsColumn( nColumnNro As Integer ) As String
		Local lcCommand As String

		Local lcColumn As String
		Local lnCol1 As Integer
		Local lnCol2 As Integer
		Local lnOffset As Integer

		Try

			lcCommand = ""

			* Devuelve el nombre de una columna de Excel, en funcion del numero de columna
			* Excel tiene los siguientes rangos:
			* A...Z			1 .... 26
			* AA....AZ		27 .... 52
			* BA....BZ		53 .... 78
			* CA....CZ		79 .... 104

			lnCol1 = Int( ( nColumnNro - 1 ) / XLS_CHARSET )
			lnCol2 = Mod( nColumnNro, XLS_CHARSET )
			lnOffset = Asc( "A" ) - 1
			lcColumn = ""

			If !Empty( lnCol1 )
				lcColumn = Chr( lnCol1 + lnOffset )
			Endif

			If !Empty( lnCol2 )
				lcColumn = lcColumn + Chr( lnCol2 + lnOffset )

			Else
				lcColumn = lcColumn + Chr( XLS_CHARSET + lnOffset )

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lcColumn

	Endproc && xlsColumn



	*
	* oExcel_Access
	Protected Procedure oExcel_Access()

		If Vartype( This.oExcel ) # "O"
			This.oExcel = Createobject("Excel.application")
		Endif

		If Vartype( This.oExcel ) # "O"
			TEXT To lcMsg NoShow TextMerge Pretext 03
			Debe instalarse Excel
			ENDTEXT

			Warning( lcMsg )

		Endif

		Return This.oExcel

	Endproc && oExcel_Access

	*
	*
	Procedure Destroy(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			This.oExcel = Null
			This.oSetup = Null

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Destroy

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oExcel
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oXlsFieldsCollection
*!* Description...:
*!* Date..........: Jueves 24 de Enero de 2019 (10:28:53)
*!*
*!*

Define Class oXlsFieldsCollection As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'

	#If .F.
		Local This As oXlsFieldsCollection Of "FW\Comunes\prg\dbf2xls.prg"
	#Endif

	nVersion 		= 2
	nHeaderHeight 	= 0
	oHeader 		= Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="nversion" type="property" display="nVersion" />] + ;
		[<memberdata name="nheaderheight" type="property" display="nHeaderHeight" />] + ;
		[<memberdata name="oheader" type="property" display="oHeader" />] + ;
		[</VFPData>]



	*
	*
	Procedure New( cName As String,;
			nFormatoDeCelda As Integer ) As Object

		Local lcCommand As String
		Local loField As oField Of "FW\Comunes\prg\dbf2xls.prg"


		Try

			lcCommand = ""
			If Empty( nFormatoDeCelda )
				nFormatoDeCelda = xls_General
			Endif

			loField = This.GetItem( cName )

			If Vartype( loField ) # "O"
				loField = Newobject( "oField", "FW\Comunes\prg\dbf2xls.prg" )
				loField.cName = cName

				This.AddItem( loField, Lower( cName ) )

			Endif

			loField.nFormatoDeCelda = nFormatoDeCelda


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loField

	Endproc && New


	*
	* oHeader_Access
	Protected Procedure oHeader_Access()

		If Isnull( This.oHeader )
			This.oHeader = Newobject( "oField", "FW\Comunes\prg\dbf2xls.prg" )
		Endif

		Return This.oHeader

	Endproc && oHeader_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oXlsFieldsCollection
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oField
*!* Description...:
*!* Date..........: Jueves 24 de Enero de 2019 (10:45:33)
*!*
*!*

Define Class oField As Custom

	#If .F.
		Local This As oField Of "FW\Comunes\prg\dbf2xls.prg"
	#Endif

	cName 			= ""
	nColumnWidth 	= 0
	lAligment 		= .F.


	*!*	#Define xls_General		0
	*!*	#Define xls_Numero		1
	*!*	#Define xls_Moneda		2
	*!*	#Define xls_Porcentaje	3
	*!*	#Define xls_Fecha		4
	*!*	#Define xls_Hora		5
	nFormatoDeCelda 	= 0
	cFormatoDeCelda 	= ""
	cFormulaDeCelda 	= ""

	nDecimales 			= 0
	lSeparadorDeMiles 	= .F.
	cMoneda 			= ""

	lTotaliza = .F.

	* Indica si el total es la suma de la columna
	lSuma = .F.

	* Indica la formula a mostrar en la celda que totaliza (cuando lSuma = .F.)
	cFormulaDelTotal = ""

	oAlignment = Null


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cname" type="property" display="cName" />] + ;
		[<memberdata name="ncolumnwidth" type="property" display="nColumnWidth" />] + ;
		[<memberdata name="laligment" type="property" display="lAligment" />] + ;
		[<memberdata name="nformatodecelda" type="property" display="nFormatoDeCelda" />] + ;
		[<memberdata name="cformatodecelda" type="property" display="cFormatoDeCelda" />] + ;
		[<memberdata name="cformuladecelda" type="property" display="cFormulaDeCelda" />] + ;
		[<memberdata name="inicializar" type="method" display="Inicializar" />] + ;
		[<memberdata name="ndecimales" type="property" display="nDecimales" />] + ;
		[<memberdata name="lseparadordemiles" type="property" display="lSeparadorDeMiles" />] + ;
		[<memberdata name="cmoneda" type="property" display="cMoneda" />] + ;
		[<memberdata name="ltotaliza" type="property" display="lTotaliza" />] + ;
		[<memberdata name="lsuma" type="property" display="lSuma" />] + ;
		[<memberdata name="cformuladeltotal" type="property" display="cFormulaDelTotal" />] + ;
		[<memberdata name="oalignment" type="property" display="oAlignment" />] + ;
		[<memberdata name="oalignment_access" type="method" display="oAlignment_Access" />] + ;
		[</VFPData>]

	*!*		General
	*!*		Selection.NumberFormat = "General"

	*!*		Numero
	*!*	    Selection.NumberFormat = "#,##0.00_ ;[Red]-#,##0.00 "
	*!*	    ActiveCell.FormulaR1C1 = "-123.45"
	*!*	    Range("F4").Select
	*!*		Separador de miles, 3 decimales
	*!*		Selection.NumberFormat = "#,##0.000_ ;[Red]-#,##0.000 "

	*!*		Moneda
	*!*	    Selection.NumberFormat = "$#,##0.00_);[Red]($#,##0.00)"
	*!*	    ActiveCell.FormulaR1C1 = "-32.56"
	*!*	    Range("G4").Select
	*!*	    ActiveCell.FormulaR1C1 = "Moneda"
	*!*	    Range("F5").Select

	*!*		Porcentaje
	*!*	    Selection.NumberFormat = "0.000%"
	*!*	    ActiveCell.FormulaR1C1 = "14.25%"
	*!*	    Range("G5").Select
	*!*	    ActiveCell.FormulaR1C1 = "Porcentaje"
	*!*	    Range("F6").Select

	*!*		Fecha
	*!*	    Selection.NumberFormat = "dd/mm/yyyy;@"
	*!*	    ActiveCell.FormulaR1C1 = "1/24/2019"
	*!*	    Range("G6").Select
	*!*	    ActiveCell.FormulaR1C1 = "Fecha"
	*!*	    Range("G7").Select
	*!*
	*!*	    Hora
	*!*	    ActiveCell.FormulaR1C1 = "Hora"
	*!*	    Range("F7").Select
	*!*	    Selection.NumberFormat = "h:mm:ss;@"
	*!*	    ActiveCell.FormulaR1C1 = "10:58:00 AM"

	*

	*
	*
	Procedure Inicializar(  ) As Void
		Local lcCommand As String,;
			lcMoneda As String,;
			lcFormatoDeCelda As String,;
			lcSeparador As String

		Local loAlignment As oAlignment Of "FW\Comunes\prg\dbf2xls.prg"

		Try

			lcCommand = ""

			If Empty( This.cFormatoDeCelda )
				Do Case
					Case Inlist( This.nFormatoDeCelda, xls_Numero, xls_Moneda )
						If This.nFormatoDeCelda = xls_Moneda
							lcMoneda = This.cMoneda

						Else
							lcMoneda = ""

						Endif

						If This.lSeparadorDeMiles
							If This.nDecimales > 0
								lcSeparador = "#,##"

							Else
								lcSeparador = "#"

							Endif

						Else
							lcSeparador = ""

						Endif

						If This.nDecimales > 0
							TEXT To This.cFormatoDeCelda NoShow TextMerge Pretext 15
							<<lcMoneda>><<lcSeparador>>0.<<Replicate( "0", This.nDecimales )>> ;[Red]-
							ENDTEXT


							TEXT To This.cFormatoDeCelda NoShow TextMerge Pretext 15 ADDITIVE
							<<lcMoneda>><<lcSeparador>>0.<<Replicate( "0", This.nDecimales )>>
							ENDTEXT

							This.cFormatoDeCelda = This.cFormatoDeCelda + " "

						Else
							TEXT To This.cFormatoDeCelda NoShow TextMerge Pretext 15
							<<lcMoneda>><<lcSeparador>>0_ ;[Red]-<<lcMoneda>><<lcSeparador>>0
							ENDTEXT

							This.cFormatoDeCelda = This.cFormatoDeCelda + " "

						Endif

						If !This.lAligment
							loAlignment = This.oAlignment
							loAlignment.nHorizontalAlignment = xlRight
						Endif

					Case This.nFormatoDeCelda = xls_Porcentaje
						If This.nDecimales > 0
							This.cFormatoDeCelda = "0." + Replicate( "0", This.nDecimales ) + "%"

						Else
							This.cFormatoDeCelda = "0%"

						Endif

						If !This.lAligment
							loAlignment = This.oAlignment
							loAlignment.nHorizontalAlignment = xlRight
						Endif


					Case This.nFormatoDeCelda = xls_Fecha
						This.cFormatoDeCelda = "dd/mm/yyyy;@"

						If !This.lAligment
							loAlignment = This.oAlignment
							loAlignment.nHorizontalAlignment = xlCenter
						Endif


					Case This.nFormatoDeCelda = xls_Hora
						This.cFormatoDeCelda = "h:mm:ss;@"
						If !This.lAligment
							loAlignment = This.oAlignment
							loAlignment.nHorizontalAlignment = xlCenter
						Endif

					Otherwise
						This.cFormatoDeCelda = "General"

				Endcase

			Endif

			If This.lSuma Or !Empty( This.cFormulaDelTotal )
				This.lTotaliza = .T.
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Inicializar

	*
	* oAlignment_Access
	Protected Procedure oAlignment_Access()

		If Isnull( This.oAlignment )
			This.oAlignment = Newobject( "oAlignment", "FW\Comunes\prg\dbf2xls.prg" )
			This.lAligment 	= .T.
		Endif

		Return This.oAlignment

	Endproc && oAlignment_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oField
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oAlignment
*!* Description...:
*!* Date..........: Viernes 25 de Enero de 2019 (11:03:35)
*!*
*!*

Define Class oAlignment As Custom

	#If .F.
		Local This As oAlignment Of "FW\Comunes\prg\dbf2xls.prg"
	#Endif

	nHorizontalAlignment 	= xlCenter
	nVerticalAlignment 		= xlCenter
	lWrapText 				= .T.
	nOrientation 			= 0
	lAddIndent 				= .F.
	nIndentLevel 			= 0
	lShrinkToFit 			= .F.
	nReadingOrder 			= xlContext
	lMergeCells 			= .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="nhorizontalalignment" type="property" display="nHorizontalAlignment" />] + ;
		[<memberdata name="nverticalalignment" type="property" display="nVerticalAlignment" />] + ;
		[<memberdata name="lwraptext" type="property" display="lWrapText" />] + ;
		[<memberdata name="norientation" type="property" display="nOrientation" />] + ;
		[<memberdata name="laddindent" type="property" display="lAddIndent" />] + ;
		[<memberdata name="nindentlevel" type="property" display="nIndentLevel" />] + ;
		[<memberdata name="lshrinktofit" type="property" display="lShrinkToFit" />] + ;
		[<memberdata name="nreadingorder" type="property" display="nReadingOrder" />] + ;
		[<memberdata name="lmergecells" type="property" display="lMergeCells" />] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oAlignment
*!*
*!* ///////////////////////////////////////////////////////







*---------------------------------------------------------------
* Alineacion
*!*	Rows("1:1").RowHeight = 62.25
*!*	Columns("L:L").ColumnWidth = 14
*!*	With Selection
*!*		.HorizontalAlignment = xlCenter
*!*		.VerticalAlignment = xlCenter
*!*		.WrapText = True
*!*		.Orientation = 0
*!*		.AddIndent = False
*!*		.IndentLevel = 0
*!*		.ShrinkToFit = False
*!*		.ReadingOrder = xlContext
*!*		.MergeCells = False
*!*		End With
*!*		Columns("L:L").ColumnWidth = 17.71
*!*		Range("L1").Select
*!*		With Selection
*!*			.HorizontalAlignment = xlGeneral
*!*			.VerticalAlignment = xlBottom
*!*			.WrapText = True
*!*			.Orientation = 0
*!*			.AddIndent = False
*!*			.IndentLevel = 0
*!*			.ShrinkToFit = False
*!*			.ReadingOrder = xlContext
*!*			.MergeCells = False
*!*			End With
*!*			Range("L1").Select
*!*			With Selection
*!*				.HorizontalAlignment = xlCenter
*!*				.VerticalAlignment = xlBottom
*!*				.WrapText = True
*!*				.Orientation = 0
*!*				.AddIndent = False
*!*				.IndentLevel = 0
*!*				.ShrinkToFit = False
*!*				.ReadingOrder = xlContext
*!*				.MergeCells = False
*!*				End With
*!*				Rows("1:1").RowHeight = 70.5
*!*				Columns("M:M").ColumnWidth = 13.57
*!*				Range("M1").Select
*!*				With Selection
*!*					.HorizontalAlignment = xlCenter
*!*					.VerticalAlignment = xlBottom
*!*					.WrapText = True
*!*					.Orientation = 0
*!*					.AddIndent = False
*!*					.IndentLevel = 0
*!*					.ShrinkToFit = False
*!*					.ReadingOrder = xlContext
*!*					.MergeCells = False
*!*					End With
*!*					Range("K1").Select
*!*					With Selection
*!*						.HorizontalAlignment = xlGeneral
*!*						.VerticalAlignment = xlCenter
*!*						.WrapText = False
*!*						.Orientation = 0
*!*						.AddIndent = False
*!*						.IndentLevel = 0
*!*						.ShrinkToFit = False
*!*						.ReadingOrder = xlContext
*!*						.MergeCells = False
*!*						End With
*!*						Columns("K:K").ColumnWidth = 12.57
*!*						Range("K1").Select
*!*						With Selection
*!*							.HorizontalAlignment = xlGeneral
*!*							.VerticalAlignment = xlCenter
*!*							.WrapText = True
*!*							.Orientation = 0
*!*							.AddIndent = False
*!*							.IndentLevel = 0
*!*							.ShrinkToFit = False
*!*							.ReadingOrder = xlContext
*!*							.MergeCells = False
*!*							End With
*!*							Columns("K:K").ColumnWidth = 14.71
*!*							Range("K1").Select
*!*							With Selection
*!*								.HorizontalAlignment = xlCenter
*!*								.VerticalAlignment = xlCenter
*!*								.WrapText = True
*!*								.Orientation = 0
*!*								.AddIndent = False
*!*								.IndentLevel = 0
*!*								.ShrinkToFit = False
*!*								.ReadingOrder = xlContext
*!*								.MergeCells = False
*!*								End With






*-----------------------------------------------------------------------




Procedure dummy

	Local lcFileName As String
	Local loExcel As "Excel.application"
	Local i As Integer
	Local lcDec As String
	Local lnColumns As Integer,lnColumn As Integer
	Local lnRows As Integer
	Local lcHeader As String
	Local lcDefault As String
	Local lcCurDir As String
	Local lcUDF As String
	Local lcXLSDir As String

	Local loParam As Object
	Local lcCommand As String

	Try

		lcCommand = ""

		If Empty( tcAlias )
			tcAlias = Alias()
		Endif

		If Empty( tcUDF )
			tcUDF = ""
		Endif

		lcUDF = tcUDF

		If IsEmpty( toSetup )
			toSetup = Createobject( "Empty" )
		Endif

		If !Pemstatus( toSetup, "cFileName", 5 )
			AddProperty( toSetup, "cFileName", "" )
		Endif

		If !Pemstatus( toSetup, "lForce", 5 )
			AddProperty( toSetup, "lForce", .F. )
		Endif

		If Used( Alias( tcAlias ))

			If toSetup.lForce
				lcFileName = tcXlsName

			Else

				If Empty( tcXlsName )
					tcXlsName = DateMask( " MM yyyy" )
				Endif


				lcDefault = Set("Default")
				lcCurDir = Curdir()

				lcXLSDir = GetValue( "RutaXLS", "ar0Var", Space(0) )

				If Empty( lcXLSDir )
					lcXLSDir = GetValue( "Exel0", "ar0Est", Space(0) )
				Endif

				If Empty( lcXLSDir )
					lcXLSDir = Getenv("HOMEDRIVE") + Getenv("HOMEPATH")
				Endif

				lcXLSDir = Addbs( Alltrim( lcXLSDir ))

				TEXT To lcCommand NoShow TextMerge Pretext 15
			Cd '<<lcXLSDir>>'
				ENDTEXT

				Try
					&lcCommand

				Catch To oErr

				Finally

				Endtry

				Wait Clear

				lcFileName = Putfile( "", tcXlsName, "XLS" )


				TEXT To lcCommand NoShow TextMerge Pretext 15
			Cd '<<lcDefault>><<lcCurDir>>'
				ENDTEXT

				&lcCommand
			Endif

			If !Empty( lcFileName )
				Select Alias( tcAlias )
				Copy To ( lcFileName ) Type Xl5
				Locate


				Wait Window "Abriendo Excel" Nowait
				loExcel = Createobject("Excel.application")

				If Vartype( loExcel ) = "O"

					loParam = Createobject( "Empty" )

					AddProperty( loParam, "oExcel",    loExcel )
					AddProperty( loParam, "cFileName", lcFileName )
					AddProperty( loParam, "cAlias",    tcAlias )
					AddProperty( loParam, "oSetup",    toSetup )

					loExcel.Visible = .F.

					Wait Window "Abriendo " + lcFileName  Nowait
					loExcel.Workbooks.Open( lcFileName )

					Try

						* Formatear Font

						loExcel.Cells.Select

						*!*						loExcel.Selection.Font.Bold = Thisform.Edit1.FontBold
						*!*						loExcel.Selection.Font.Italic = Thisform.Edit1.FontItalic

						With loExcel.Selection.Font
							*!*							.Color = Thisform.Edit1.ForeColor
							*!*							.Name = Thisform.Edit1.FontName
							*!*							.Size = Thisform.Edit1.FontSize

							If Val( loExcel.Version ) >= Val( OFFICE_2007 )
								.TintAndShade = 0
							Endif

						Endwith

						lnColumns = Afields( laFields, tcAlias )
						lnRows = Reccount( tcAlias ) + 1

						AddProperty( loParam, "nColumns", lnColumns )
						AddProperty( loParam, "nRows", lnRows )

						For i = 1 To lnColumns
							loExcel.Columns( xlsCols( i, i ) ).Select

							Do Case
								Case Inlist( laFields[ i, 2 ], "D", "T" )
									*loExcel.Selection.NumberFormat = "yyyy-mm-dd;@"
									loExcel.Selection.NumberFormat = "dd-mm-yyyy;@"

								Case Inlist( laFields[ i, 2 ], "Y", "I", "N" )
									If Empty( laFields[ i, 4 ] )
										*loExcel.Selection.NumberFormat = "#,##0_ ;[Red]-#,##0 "
										loExcel.Selection.NumberFormat = "#0_ ;[Red]-#0 "

									Else
										lcDec = Replicate( "0", laFields[ i, 4 ] )

										TEXT To lcCommand NoShow TextMerge Pretext 15
									loExcel.Selection.NumberFormat = "#,##0.<<lcDec>>_ ;[Red]-#,##0.<<lcDec>> "
										ENDTEXT

										&lcCommand

									Endif

								Otherwise

							Endcase

							loExcel.Range( xlsColumn( i ) + "1").Select

							lcHeader = Proper( Strtran( laFields[ i, 1 ], "_", " " ))
							loExcel.ActiveCell.FormulaR1C1 = lcHeader

						Endfor


						* Formatear Titulo
						Wait Window "Formatear Titulo" Nowait

						loExcel.Rows("1:1").Select
						loExcel.Selection.Font.Bold = .T.
						With loExcel.Selection.Font
							.Color = TITLEFONT_COLOR
							.Name = TITLEFONT_NAME
							.Size = TITLEFONT_SIZE

							If Val( loExcel.Version ) >= Val( OFFICE_2007 )
								.TintAndShade = 0
							Endif

						Endwith

						Try

							loExcel.Selection.AutoFilter

						Catch To oErr

						Finally

						Endtry



						* Seleccionar las columnas de la primer fila
						loExcel.Range( xlsColumn( 1 ) + "1:" + xlsColumn( lnColumns ) + "1").Select
						With loExcel.Selection.Interior
							.Pattern = xlSolid
							.PatternColorIndex = xlAutomatic


							If Val( loExcel.Version ) >= Val( OFFICE_2007 )
								.TintAndShade = -4.99893185216834E-02
								.ThemeColor = xlThemeColorDark1
								.PatternTintAndShade = 0
							Endif

						Endwith

						With loExcel.Selection.BorderS(xlEdgeBottom)
							.LineStyle = xlContinuous
							.ColorIndex = 0
							.Weight = xlThick

							If Val( loExcel.Version ) >= Val( OFFICE_2007 )
								.TintAndShade = 0
							Endif

						Endwith

						* Marcar las líneas verticales y la de abajo

						loExcel.Range( xlsColumn( 1 ) + "1:" + xlsColumn( lnColumns ) + Transform( lnRows ) ).Select

						Try

							With loExcel.Selection.BorderS(xlEdgeLeft)
								.LineStyle = xlContinuous
								.ColorIndex = xlAutomatic
								.Weight = xlThin

								If Val( loExcel.Version ) >= Val( OFFICE_2007 )
									.TintAndShade = 0
								Endif

							Endwith

						Catch To oErr

						Finally

						Endtry

						Try

							With loExcel.Selection.BorderS(xlEdgeRight)
								.LineStyle = xlContinuous
								.ColorIndex = xlAutomatic
								.Weight = xlThin

								If Val( loExcel.Version ) >= Val( OFFICE_2007 )
									.TintAndShade = 0
								Endif

							Endwith

						Catch To oErr

						Finally

						Endtry

						Try

							With loExcel.Selection.BorderS(xlInsideVertical)
								.LineStyle = xlContinuous
								.ColorIndex = xlAutomatic
								.Weight = xlThin

								If Val( loExcel.Version ) >= Val( OFFICE_2007 )
									.TintAndShade = 0
								Endif

							Endwith

						Catch To oErr

						Finally

						Endtry

						Try

							loExcel.Range( xlsColumn( 1 ) + Transform( lnRows ) + ":" + xlsColumn( lnColumns ) + Transform( lnRows ) ).Select

						Catch To oErr

						Finally

						Endtry

						Try

							With loExcel.Selection.BorderS(xlEdgeBottom)
								.LineStyle = xlContinuous
								.ColorIndex = xlAutomatic
								.Weight = xlThin

								If Val( loExcel.Version ) >= Val( OFFICE_2007 )
									.TintAndShade = 0
								Endif

							Endwith

						Catch To oErr

						Finally

						Endtry

						* Color de Fondo
						Try

							loExcel.Range( xlsColumn( 1 ) + "2:" + xlsColumn( lnColumns ) + Transform( lnRows ) ).Select
							With loExcel.Selection.Interior
								.Pattern = xlSolid
								.PatternColorIndex = xlAutomatic
								.Color = Int( Rgb( 235, 255, 255 ))

								If Val( loExcel.Version ) >= Val( OFFICE_2007 )
									.TintAndShade = 0
									.PatternTintAndShade = 0
								Endif

							Endwith

						Catch To oErr

						Finally

						Endtry

						Try

							With loExcel.ActiveWindow
								.SplitColumn = 0
								.SplitRow = 1
							Endwith
							loExcel.ActiveWindow.FreezePanes = .T.

						Catch To oErr

						Finally

						Endtry

						If Pemstatus( toSetup, "oFields", 5 )
							For Each oField In toSetup.oFields
								If Pemstatus( oField, "lSuma", 5 )
									If oField.lSuma
										lnColumn = Ascan( laFields, oField.Name, 1, lnColumns , 1, 9 )

										If !Empty( lnColumn )
											TEXT To lcCommand NoShow TextMerge Pretext 15
										loExcel.ActiveSheet.Range( '<<xlsColumn( lnColumn )>><<lnRows+1>>' ).Formula =
										'=SUM(<<xlsColumn( lnColumn )>><<2>>:<<xlsColumn( lnColumn )>><<lnRows>>)'
											ENDTEXT

											&lcCommand

											TEXT To lcCommand NoShow TextMerge Pretext 15
										loExcel.ActiveSheet.Range( '<<xlsColumn( lnColumn )>><<lnRows+1>>' ).Font.Bold = .T.
											ENDTEXT

											&lcCommand

										Endif
									Endif
								Endif
							Endfor
						Endif


					Catch To loErr
						Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
						loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
						loError.cRemark = "Error al Formatear Excel"
						loError.lShowError = .F.
						loError.lLogError = .T.
						loError.Process( oErr )


					Finally

					Endtry

					* Auto Ajustar Columnas
					Wait Window "Auto Ajustar Columnas" Nowait

					loExcel.Cells.Select
					loExcel.Selection.Columns.AutoFit

					* Si existe algna UDF, llamarla pasando el objeto como parámetro

					Do Case
						Case Pemstatus( toSetup, "cUDF", 5 )

							lcUDF = toSetup.cUDF

							TEXT To lcCommand NoShow TextMerge Pretext 15
							<<lcUDF>>( loParam )
							ENDTEXT

							If Pemstatus( toSetup, "oMain", 5 )
								lcCommand = "toSetup.oMain." + lcCommand
							Endif

							Evaluate( lcCommand )

						Case !Empty( lcUDF )
							Try

								TEXT To lcCommand NoShow TextMerge Pretext 15
							<<lcUDF>>( loParam )
								ENDTEXT

								Evaluate( lcCommand )

							Catch To oErr
								Try

									* RA 2013-04-30(13:00:41)
									* Version anterior, pasando solo el objeto Excel
									TEXT To lcCommand NoShow TextMerge Pretext 15
							<<lcUDF>>( loExcel )
									ENDTEXT

									Evaluate( lcCommand )

								Catch To oErr

								Finally

								Endtry

							Finally

							Endtry


					Endcase

					* Grabar y Mostrar
					loExcel.Range("A1").Select
					loExcel.Visible = .T.
					loExcel.ActiveWorkbook.Save

					Wait Clear

				Endif


			Endif

			toSetup.cFileName = lcFileName

		Else
			Warning( "No Existe el Cursor '&tcAlias.'" )

		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loExcel = Null

	Endtry

	Return lcFileName


	*//////////////////////////////////////////

	*
	* Importar una planilla en EXCEL 2007/2010 a una tabla de fox 9 tipo append from
Procedure ImportarLibro(  ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""

		* Crear el Cursor con los campos del EXCEL

		lcXLBook = "Nombre de Archivo"

		* Hace la cadena de conexion - invocando al driver

		lcConnstr = [Driver=] + ;
			[{Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};] + ;
			[DBQ=] + lcXLBook

		lnSQLHand = Sqlstringconnect( lcConnstr )

		If lnSQLHand < 1
			*Esto es error de conexión

		Else
			*Leer la hoja de excel

			lcSQLCmd = [Select * FROM "Hoja1$"]

			lnSuccess = SQLExec( lnSQLHand, lcSQLCmd, [xlResults] )
			*
			If lnSuccess < 0
				*Error

			Else
				Select Cursor
				Append From Dbf("xlResults")

			Endif

			SQLDisconnect( lnSQLHand )

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		DEBUG_EXCEPTION
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		m.loError.Process ( m.loErr )
		THROW_EXCEPTION

	Finally

	Endtry

Endproc && ImportarLibro
