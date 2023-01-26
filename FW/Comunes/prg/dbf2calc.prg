Lparameters tcAlias As String,;
	lcFName as String,;
	tcUDF as String,;
	toSetup as Object 

* Convierte un cursor a una hoja de calculo y la formatea con OpenOffice.Org Calc

*!*	#INCLUDE "FW\Comunes\Include\Excel.h"

#Define TITLEFONT_COLOR	2293980
#Define RANGE_BACKCOLOR	13434879
#Define TITLEFONT_NAME	"Cambria"
#Define TITLEFONT_SIZE	18



Local lcFileName As String
Local loOO As Calc Of "Tools\Openoffice\Prg\OpenOffice.prg"
Local i As Integer
Local lcDec As String
Local lnColumns As Integer
Local lnRows As Integer
Local lcHeader As String
Local lcDefault As String
Local lcCurDir As String
Local lcFName As String
Local loSheet As Object
Local loCalc As Object
Local loCell As Object


Local loNumberFormats As Object
Local lcNumberFormatString As String
Local lnNumberFormatId As Integer
Local loLocalSettings As Object

Try

	If Empty( tcAlias )
		tcAlias = Alias()
	Endif

	If Used( Alias( tcAlias ))

		If Empty( lcFName )
			lcFName = DateMask( " MM yyyy" ) 
		EndIf
		
		lcDefault = Set("Default")
		lcCurDir = Curdir()

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Cd '<<GetEnv("HOMEDRIVE")>><<GetEnv("HOMEPATH")>>'
		ENDTEXT

		&lcCommand
		
		Wait Clear

		lcFileName = Putfile( "", lcFName, "XLS" )

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Cd '<<lcDefault>><<lcCurDir>>'
		ENDTEXT

		&lcCommand

		If !Empty( lcFileName )
			Select Alias( tcAlias )
			Copy To ( lcFileName ) Type Xl5
			Locate


			Wait Window "Abriendo OpenOffice.Org Calc" Nowait

			loOO = Newobject( "Calc", "Tools\Openoffice\Prg\OpenOffice.prg" )

			If Vartype( loOO ) = "O"

				Wait Window "Abriendo " + lcFileName  Nowait

				loCalc = loOO.OpenURL( loOO.ConvertToURL( lcFileName ) )

				Try

					* Get first sheet
					loSheet = loCalc.getSheets().getByIndex( 0 )

					loCalc.getCurrentController().FreezeAtPosition( 0, 1 )


					* Formatear Font

					lnColumns = Afields( laFields, tcAlias )
					lnRows = Reccount( tcAlias ) + 1





					*!*						For i = 0 To lnColumns - 1
					*!*							loCalc.Columns( xlsCols( i, i ) ).Select
					*!*
					*!*							loCell = loSheet.getCellByPosition( , 0 )

					*!*							Do Case
					*!*							Case Inlist( laFields[ i, 2 ], "D", "T" )
					*!*								loCalc.Selection.NumberFormat = "dd-mm-yyyy;@"

					*!*							Case Inlist( laFields[ i, 2 ], "Y", "I", "N" )
					*!*								If Empty( laFields[ i, 4 ] )
					*!*									loCalc.Selection.NumberFormat = "#,##0_ ;[Red]-#,##0 "

					*!*								Else
					*!*									lcDec = Replicate( "0", laFields[ i, 4 ] )

					*!*									TEXT To lcCommand NoShow TextMerge Pretext 15
					*!*										loCalc.Selection.NumberFormat = "#,##0.<<lcDec>>_ ;[Red]-#,##0.<<lcDec>> "
					*!*									ENDTEXT

					*!*									&lcCommand

					*!*								Endif

					*!*							Otherwise

					*!*							Endcase

					*!*							loCalc.Range( xlsColumn( i ) + "1").Select
					*!*
					*!*							lcHeader = Proper( Strtran( laFields[ i, 1 ], "_", " " ))
					*!*							loCalc.ActiveCell.FormulaR1C1 = lcHeader

					*!*						Endfor

					* Titulo



					loRange = loSheet.getCellRangeByPosition( 0, 1, lnColumns - 1, lnRows - 1 )
					loCalc.CurrentController.Select( loRange )

					With loCalc.CurrentSelection
						.CellBackColor = RANGE_BACKCOLOR
					Endwith



					loRange = loSheet.getCellRangeByPosition( 0, 0, lnColumns - 1, 0 )
					loCalc.CurrentController.Select( loRange )

					With loCalc.CurrentSelection
						.CharColor = TITLEFONT_COLOR
						.CharHeight = TITLEFONT_SIZE
						.CharFontName = TITLEFONT_NAME

						.CharPosture = 0
						.CharShadowed = .F.
						* .FormulaLocal = lColName[i,1]
						.HoriJustify = 2
						.ParaAdjust = 3
						.ParaLastLineAdjust = 3
					Endwith


					loRow = loSheet.Rows( 0 )
					loRow.OptimalHeight = .T.


					Local loCol As Collection
					loCol = Createobject( "collection" )
					loFormat = Createobject( "Empty" )
					AddProperty( loFormat, "FormatString", "" )
					AddProperty( loFormat, "FormatId", 0 )

					For i = 0 To lnColumns - 1
						loCell = loSheet.getCellByPosition( i, 0 )
						lcHeader = Proper( Strtran( laFields[ i + 1, 1 ], "_", " " ))
						loCell.setString( lcHeader )

						loColumn = loSheet.Columns( i )
						loColumn.OptimalWidth = .T.

						loLocalSettings = loOO.oLocalSettings
						loDocument = loOO.oDocument

						loNumberFormats = loCalc.NumberFormats

						lcNumberFormatString = ""

						Do Case
							Case Inlist( laFields[ i + 1, 2 ], "D", "T" )
								lcNumberFormatString = "dd-mm-yyyy;@"

							Case Inlist( laFields[ i + 1, 2 ], "Y", "I", "N" )
								If Empty( laFields[ i + 1, 4 ] )
									lcNumberFormatString = "#;[RED]-#"

								Else
									lcDec = Replicate( "0", laFields[ i + 1, 4 ] )

									TEXT To lcCommand NoShow TextMerge Pretext 15
									lcNumberFormatString = "#,##0.<<lcDec>>_ ;[Red]-#,##0.<<lcDec>>"
									ENDTEXT

									&lcCommand

								Endif

							Otherwise

						Endcase

						If !Empty( lcNumberFormatString )


							lnIndex = loCol.GetKey( lcNumberFormatString )

							If Empty( lnIndex )


								lnNumberFormatId = loNumberFormats.queryKey( lcNumberFormatString, loLocalSettings, .T. )

								If lnNumberFormatId = -1
									lnNumberFormatId = loNumberFormats.addNew( lcNumberFormatString, loLocalSettings )
								Endif

								loCol.Add( lnNumberFormatId, lcNumberFormatString )


							Else
								lnNumberFormatId = loCol.Item( lnIndex )

							Endif

							loRange = loSheet.getCellRangeByPosition( i, 1, i, lnRows - 1 )
							loCalc.CurrentController.Select( loRange )

							With loCalc.CurrentSelection
								.NumberFormat = lnNumberFormatId
							Endwith

						Endif
					Endfor

					If .F.

						* Formatear Titulo
						Wait Window "Formatear Titulo" Nowait

						loCalc.Rows("1:1").Select
						loCalc.Selection.Font.Bold = .T.
						With loCalc.Selection.Font
							.Color = TITLEFONT_COLOR
							.Name = TITLEFONT_NAME
							.Size = TITLEFONT_SIZE

							If loCalc.Version = OFFICE_2007
								.TintAndShade = 0
							Endif

						Endwith


						* Seleccionar las columnas de la primer fila
						loCalc.Range( xlsColumn( 1 ) + "1:" + xlsColumn( lnColumns ) + "1").Select
						With loCalc.Selection.Interior
							.Pattern = xlSolid
							.PatternColorIndex = xlAutomatic


							If loCalc.Version = OFFICE_2007
								.TintAndShade = -4.99893185216834E-02
								.ThemeColor = xlThemeColorDark1
								.PatternTintAndShade = 0
							Endif

						Endwith

						With loCalc.Selection.BorderS(xlEdgeBottom)
							.LineStyle = xlContinuous
							.ColorIndex = 0
							.Weight = xlThick

							If loCalc.Version = OFFICE_2007
								.TintAndShade = 0
							Endif

						Endwith

						* Marcar las líneas verticales y la de abajo

						loCalc.Range( xlsColumn( 1 ) + "1:" + xlsColumn( lnColumns ) + Transform( lnRows ) ).Select

						With loCalc.Selection.BorderS(xlEdgeLeft)
							.LineStyle = xlContinuous
							.ColorIndex = xlAutomatic
							.Weight = xlThin

							If loCalc.Version = OFFICE_2007
								.TintAndShade = 0
							Endif

						Endwith
						With loCalc.Selection.BorderS(xlEdgeRight)
							.LineStyle = xlContinuous
							.ColorIndex = xlAutomatic
							.Weight = xlThin

							If loCalc.Version = OFFICE_2007
								.TintAndShade = 0
							Endif

						Endwith
						With loCalc.Selection.BorderS(xlInsideVertical)
							.LineStyle = xlContinuous
							.ColorIndex = xlAutomatic
							.Weight = xlThin

							If loCalc.Version = OFFICE_2007
								.TintAndShade = 0
							Endif

						Endwith


						loCalc.Range( xlsColumn( 1 ) + Transform( lnRows ) + ":" + xlsColumn( lnColumns ) + Transform( lnRows ) ).Select
						With loCalc.Selection.BorderS(xlEdgeBottom)
							.LineStyle = xlContinuous
							.ColorIndex = xlAutomatic
							.Weight = xlThin

							If loCalc.Version = OFFICE_2007
								.TintAndShade = 0
							Endif

						Endwith


						* Color de Fondo
						loCalc.Range( xlsColumn( 1 ) + "2:" + xlsColumn( lnColumns ) + Transform( lnRows ) ).Select
						With loCalc.Selection.Interior
							.Pattern = xlSolid
							.PatternColorIndex = xlAutomatic
							.Color = Int( Rgb( 235, 255, 255 ))

							If loCalc.Version = OFFICE_2007
								.TintAndShade = 0
								.PatternTintAndShade = 0
							Endif

						Endwith

						With loCalc.ActiveWindow
							.SplitColumn = 0
							.SplitRow = 1
						Endwith
						loCalc.ActiveWindow.FreezePanes = .T.

					Endif

				Catch To oErr
					Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

					loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
					loError.cRemark = "Error al Formatear Excel"
					loError.lShowError = .F.
					loError.lLogError = .T.
					loError.Process( oErr )

				Finally

				Endtry


				Local Array laArgs13[ 13 ], laArray_0020[ 4 ], laArray_0000[ 4 ]

				laArray_0020[ 1 ] = 0
				laArray_0020[ 2 ] = 0
				laArray_0020[ 3 ] = 2
				laArray_0020[ 4 ] = 0

				laArray_0000[ 1 ] = 0
				laArray_0000[ 2 ] = 0
				laArray_0000[ 3 ] = 0
				laArray_0000[ 4 ] = 0

				*!*					laArgs13[ 01 ] = loOO.MakePropertyValue( "OuterBorder.LeftBorder", @ laArray_0020, .F., .F., .T. )
				*!*					laArgs13[ 02 ] = loOO.MakePropertyValue( "OuterBorder.LeftDistance", 0 )
				*!*					laArgs13[ 03 ] = loOO.MakePropertyValue( "OuterBorder.RightBorder", @ laArray_0020, .F., .F., .T. )
				*!*					laArgs13[ 04 ] = loOO.MakePropertyValue( "OuterBorder.RightDistance", 0 )
				*!*					laArgs13[ 05 ] = loOO.MakePropertyValue( "OuterBorder.TopBorder", @ laArray_0020, .F., .F., .T. )
				*!*					laArgs13[ 06 ] = loOO.MakePropertyValue( "OuterBorder.TopDistance", 0 )
				*!*					laArgs13[ 07 ] = loOO.MakePropertyValue( "OuterBorder.BottomBorder", @ laArray_0020, .F., .F., .T. )
				*!*					laArgs13[ 08 ] = loOO.MakePropertyValue( "OuterBorder.BottomDistance", 0 )
				*!*					laArgs13[ 09 ] = loOO.MakePropertyValue( "InnerBorder.Horizontal", @ laArray_0000, .F., .F., .T. )
				*!*					laArgs13[ 10 ] = loOO.MakePropertyValue( "InnerBorder.Vertical", @ laArray_0020, .F., .F., .T. )
				*!*					laArgs13[ 11 ] = loOO.MakePropertyValue( "InnerBorder.Flags", 0 )
				*!*					laArgs13[ 12 ] = loOO.MakePropertyValue( "InnerBorder.ValidFlags", 111 )
				*!*					laArgs13[ 13 ] = loOO.MakePropertyValue( "InnerBorder.DefaultDistance", 0 )

				*!*
				*!*					loDispatcher = loOO.oDispatcher
				*!*					loDispatcher.ExecuteDispatch( loCalc, ".uno:SetBorderStyle", "", 0, @ laArgs )


				* Grabar y Mostrar
				*loCell = loSheet.getCellByPosition( 0, 0 )
				*loCalc.CurrentController.Select( loCell )
				
*				loCalc.getCurrentController().GoToCell( "$A$1" )
				
*!*	dim args4(0) as new com.sun.star.beans.PropertyValue
*!*	args4(0).Name = "ToPoint"
*!*	args4(0).Value = "$A$1"

*!*	dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args4())
				
				
				Dimension laArg[1]
				laArg[ 1 ] = loOO.MakePropertyValue( "ToPoint", "$A$1" )
				
				loDispatcher = loOO.oDispatcher  
				loDispatcher.ExecuteDispatch( loSheet, ".uno:GoToCell", "", 0, @ laArg )
				
				
				loCalc.Store()


				Wait Clear

			Endif


		Endif

	Else
		Warning( "No Existe el Cursor '&tcAlias.'" )

	Endif


Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loCalc = Null
	loSheet = Null
	loOO = Null

Endtry



*############################################################3
* Ejemplo encontrado en Portal Fox
* Enviado por churrucks en Martes, 25 Septiembre, 2007	
* Rutina de Hector Urrutia para exportar un cursor a OpenOffice Calc.

*-------------------------------------------------------------*
*!*- FUNCTION ExporToCalc([cCursor], [cDestino], [cFileSave])
*!*- cCursor:  Alias del cursor que se va a exportar.
*!*- cDestino:  Nombre de la carpeta donde se va a grabar.
*!*- cFileName:  Nombre del archivo con el que se va a grabar.
*-------------------------------------------------------------*
FUNCTION ExporToCalc(cCursor, cDestino, cFileSave)
  LOCAL oManager, oDesktop, oDoc, oSheet, oCell, oRow, FileURL
  LOCAL ARRAY laPropertyValue[1]

  cWarning = "Exportar a OpenOffice.org Calc"

  IF EMPTY(cCursor)
    cCursor = ALIAS()
  ENDIF

  IF TYPE('cCursor') # 'C' OR !USED(cCursor)
    MESSAGEBOX("Parametros Invalidos",16,cWarning)
    RETURN .F.
  ENDIF

  lColNum = AFIELDS(lColName,cCursor)

  EXPORT TO (cDestino + cFileSave + [.ods]) TYPE XL5

  oManager = CREATEOBJECT("com.sun.star.ServiceManager.1")

  IF VARTYPE(oManager, .T.) # "O"
    MESSAGEBOX("OpenOffice.org Calc no esta instalado en su computador.",64,cWarning)
    RETURN .F.
  ENDIF

  oDesktop = oManager.createInstance("com.sun.star.frame.Desktop")

  COMARRAY(oDesktop, 10)

  oReflection = oManager.createInstance("com.sun.star.reflection.CoreReflection")

  COMARRAY(oReflection, 10)

  laPropertyValue[1] = createStruct(@oReflection, "com.sun.star.beans.PropertyValue")
  laPropertyValue[1].NAME = "ReadOnly"
  laPropertyValue[1].VALUE= .F.

  FileURL = ConvertToURL(cDestino + cFileSave + [.ods])

  oDoc = oDesktop.loadComponentFromURL(FileURL , "_blank", 0, @laPropertyValue)

  oSheet = oDoc.getSheets.getByIndex(0)

  FOR i = 1 TO lColNum
    oColumn = oSheet.getColumns.getByIndex(i)
    oColumn.setPropertyValue("OptimalWidth", .T.)

    oCell = oSheet.getCellByPosition( i-1, 0 )
    oDoc.CurrentController.SELECT(oCell)

    WITH oDoc.CurrentSelection
      .CellBackColor = RGB(200,200,200)
      .Cell
      .CharColor = RGB(255,0,0)
      .CharHeight = 10
      .CharPosture = 0
      .CharShadowed = .F.
      .FormulaLocal = lColName[i,1]
      .HoriJustify = 2
      .ParaAdjust = 3
      .ParaLastLineAdjust = 3
    ENDWITH
  ENDFOR

  oCell = oSheet.getCellByPosition( 0, 0 )
  oDoc.CurrentController.SELECT(oCell)

  laPropertyValue[1] = createStruct(@oReflection, "com.sun.star.beans.PropertyValue")
  laPropertyValue[1].NAME = "Overwrite"
  laPropertyValue[1].VALUE = .T.

  oDoc.STORE()
ENDFUNC

FUNCTION createStruct(toReflection, tcTypeName)
  LOCAL loPropertyValue, loTemp
  loPropertyValue = CREATEOBJECT("relation")
  toReflection.forName(tcTypeName).CREATEOBJECT(@loPropertyValue)
  RETURN (loPropertyValue)
ENDFUNC

FUNCTION ConvertToURL(tcFile AS STRING)
  IF(TYPE( "tcFile" ) == "C") AND (!EMPTY( tcFile ))
    tcFile = [file:///] + CHRTRAN(tcFile, "\", "/" )
  ELSE
    tcFile = [file:///C:/] + ALIAS() + [.ods]
  ENDIF
  RETURN tcFile
ENDFUNC
*!*	AUTOR: Hector Urrutia

*!*	Saludos desde EL Salvador