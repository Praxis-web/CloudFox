#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\Comunes\Include\Excel.h"

Local lcCommand As String, lcMsg As String
Local loXls2Dbf As oXls2Dbf Of "FW\Comunes\prg\Xls2Dbf.prg",;
	loColumns As oColumns Of "FW\Comunes\prg\Xls2Dbf.prg",;
	loField As Object,;
	loExcel As "Excel.Application",;
	loSheet As "Excel.WorkSheet"


Try

	lcCommand = ""
	loXls2Dbf = Newobject( "oXls2Dbf", "FW\Comunes\prg\Xls2Dbf.prg" )

	loXls2Dbf.cFolder = "v:\Clipper2Fox\Clientes\Blunki\"
	loXls2Dbf.cXlsName = "Lista Otoño 2017.Xlsx"
	loXls2Dbf.lVisible = .T.
	loXls2Dbf.nSheetNumber = 1

	If loXls2Dbf.Abrir()
		loColumns 	= loXls2Dbf.oColumns
		loField 	= loColumns.New( "Codigo", "A", "N", 6, 0, .T. )
		loField 	= loColumns.New( "Talle", "B", "C", 6 )
		loField 	= loColumns.New( "Descripcion", "C", "C", 40 )
		loField 	= loColumns.New( "Precio", "D", "N", 12, 2 )




		loXls2Dbf.SetActveSheet( 3 )

		loXls2Dbf.Importar()

		Browse

	Else
		Messagebox( "No Abrio" )

	Endif


Catch To loErr

	Do While Vartype( loErr.UserValue ) == "O"
		loErr = loErr.UserValue
	Enddo

	lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  METODO   ] " + loErr.Procedure + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  LINEA Nº ] " + Transform(loErr.Lineno) + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  COMANDO  ] " + loErr.LineContents + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  ERROR    ] " + Transform(loErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  MENSAJE  ] " + loErr.Message + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  DETALLE  ] " + loErr.Details + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )

	Messagebox( lcMsg, 16, "Error" )


Finally
	loXls2Dbf = Null


Endtry

*!* ///////////////////////////////////////////////////////
*!* Class.........: oXls2Dbf
*!* Description...:
*!* Date..........: Martes 3 de Octubre de 2017 (17:47:17)
*!*
*!*

Define Class oXls2Dbf As CustomBase Of Tools\namespaces\prg\CustomBase.prg

	#If .F.
		Local This As oXls2Dbf Of "FW\Comunes\prg\Xls2Dbf.prg"
	#Endif

	* Carpeta donde se encuentrra la Planilla
	cFolder = ""

	* Nombre de la planilla
	cXlsName = ""

	* Extensión por defecto
	cXlsExt = "Xlsx"

	* Nombre de la Hoja
	cSheetName = ""

	* Numero de la Hoja
	nSheetNumber = 1

	* Referencia al Objeto Excel.Aplication
	oExcel = Null

	* Si no existe, lo busca
	lBrowseIfNotExist = .T.

	* Abre Visible
	lVisible = .F.

	* Cierra la Hoja de Calculo al salir
	lQuitOnDestroy = .T.

	* Primer Fila a Importar
	* 0 = Total
	nFirstRow = 0

	* Ultima Fila a Importar
	* 0 = Total
	nLastRow = 0

	* Cantidad de filas sin información antes de cerrar, cuando nLastRow = 0
	nVoidRows = 50

	* Collección de Columnas
	oColumns = Null

	* Nombre del cursor que se crea
	cAlias = "cCursorXLS"

	* nStatus = 0: Ok
	* nStatus < 0: Error
	nStatus = 0

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cfolder" type="property" display="cFolder" />] + ;
		[<memberdata name="cxlsname" type="property" display="cXlsName" />] + ;
		[<memberdata name="cxlsext" type="property" display="cXlsExt" />] + ;
		[<memberdata name="csheetname" type="property" display="cSheetName" />] + ;
		[<memberdata name="nsheetnumber" type="property" display="nSheetNumber" />] + ;
		[<memberdata name="calias" type="property" display="cAlias" />] + ;
		[<memberdata name="oexcel" type="property" display="oExcel" />] + ;
		[<memberdata name="nstatus" type="property" display="nStatus" />] + ;
		[<memberdata name="oexcel_access" type="method" display="oExcel_Access" />] + ;
		[<memberdata name="abrir" type="method" display="Abrir" />] + ;
		[<memberdata name="cerrar" type="method" display="Cerrar" />] + ;
		[<memberdata name="setactvesheet" type="method" display="SetActveSheet" />] + ;
		[<memberdata name="importar" type="method" display="Importar" />] + ;
		[<memberdata name="validatevalue" type="method" display="ValidateValue" />] + ;
		[<memberdata name="crearcursor" type="method" display="CrearCursor" />] + ;
		[<memberdata name="definircursor" type="method" display="DefinirCursor" />] + ;
		[<memberdata name="lvisible" type="property" display="lVisible" />] + ;
		[<memberdata name="lbrowseifnotexist" type="property" display="lBrowseIfNotExist" />] + ;
		[<memberdata name="lquitondestroy" type="property" display="lQuitOnDestroy" />] + ;
		[<memberdata name="nfirstrow" type="property" display="nFirstRow" />] + ;
		[<memberdata name="nlastrow" type="property" display="nLastRow" />] + ;
		[<memberdata name="nvoidrows" type="property" display="nVoidRows" />] + ;
		[<memberdata name="ocolumns" type="property" display="oColumns" />] + ;
		[<memberdata name="ocolumns_access" type="method" display="oColumns_Access" />] + ;
		[<memberdata name="int2date" type="method" display="Int2Date" />] + ;
		[</VFPData>]

	*
	*
	Procedure Abrir( cFileName As String, uSheet As Variant ) As Void
		Local lcCommand As String,;
			lcFileName As String,;
			lcFolder As String

		Local luSheet As Variant
		Local llOk As Boolean

		Local loExcel As "Excel.Application",;
			loSheet As "Excel.WorkSheet"

		Try

			lcCommand = ""
			lcFolder = Set("Default") + Curdir()
			llOk = .F.

			If Empty( cFileName )
				lcFileName = Addbs( Alltrim( This.cFolder )) + Alltrim( This.cXlsName )

			Else
				lcFileName = cFileName

			Endif

			lcFileName = Defaultext( lcFileName, This.cXlsExt )

			If !FileExist( lcFileName )

				If This.lBrowseIfNotExist
					Try

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Cd "<<This.cFolder>>"
						ENDTEXT

						&lcCommand
						lcCommand = ""

					Catch To oErr

					Finally

					Endtry

					lcFileName = Getfile( "Excel:xls,xlsx", "","",0, "Seleccione la Hoja de Calculo" )

					Try

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Cd "<<lcFolder>>"
						ENDTEXT

						&lcCommand
						lcCommand = ""

					Catch To oErr

					Finally

					Endtry

				Else
					TEXT To lcMsg NoShow TextMerge Pretext 03
					El archivo "<<lcFileName>>" No Existe ...
					ENDTEXT

					Warning( lcMsg, _Screen.Caption )

					lcFileName = ""

				Endif

			Endif

			If !Empty( lcFileName )
				If !Empty( uSheet )
					luSheet = uSheet

				Else
					luSheet = This.cSheetName

					If Empty( luSheet )
						luSheet = This.nSheetNumber
					Endif

				Endif

				loExcel = This.oExcel

				If Vartype( loExcel ) = "O"
					loExcel.Visible = This.lVisible

					TEXT To lcCommand NoShow TextMerge Pretext 15
					loSheet = loExcel.Workbooks.Open( '<<lcFileName>>' ).Sheets.Item( <<luSheet>> )
					ENDTEXT

					loSheet = loExcel.Workbooks.Open( lcFileName ).Sheets.Item( luSheet )
					loSheet.Activate()

					llOk = .T.

				Endif

			Endif


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
	Procedure Cerrar(  ) As Void
		Local lcCommand As String
		Local loExcel As "Excel.Application"

		Try

			lcCommand = ""
			If !Isnull( This.oExcel )
				loExcel = This.oExcel
				loExcel.Quit()
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loExcel = Null

		Endtry

	Endproc && Cerrar

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
	Procedure Importar(  ) As Void
		Local lcCommand As String,;
			lcLetra As String,;
			lcCast As String

		Local loExcel As "Excel.Application",;
			loSheet As "Excel.WorkSheet",;
			loReg As Object

		Local lnVoid As Integer,;
			lnRow As Integer,;
			lnLastRow As Integer

		Local loColumns As oColumns Of "FW\Comunes\prg\Xls2Dbf.prg",;
			loField As Object

		Local luValue As Variant

		Local llImport As Boolean,;
			llInvalidValue As Boolean,;
			llVisible As Boolean

		Try

			lcCommand 	= ""
			This.nStatus 	= xls_Todo_Ok
			lnVoid 		= 0
			lnRow 		= Max( This.nFirstRow - 1, 0 )
			lnLastRow 	= This.nLastRow

			If Empty( lnLastRow )
				lnLastRow = 99999999
			Endif

			loColumns 	= This.oColumns
			loExcel 	= This.oExcel
			loSheet 	= loExcel.ActiveSheet

			llVisible 	= loExcel.Visible
			loExcel.Visible = .F.

			This.CrearCursor()
			Select Alias( This.cAlias )

			Scatter Memo Name loReg

			Do While lnRow < lnLastRow

				lnRow = lnRow + 1
				llImport = .T.
				llInvalidValue = .F.

				loSheet.Rows( Transform( lnRow ) + ":" + Transform( lnRow ) ).Select

				If !loExcel.Selection.EntireRow.Hidden

					Wait Window Noclear Nowait "Importando Fila " + Transform( lnRow ) + "..."

					loReg.n_xls_row = lnRow

					For Each loField In loColumns

						lcLetra = Alltrim( loField.Letra )

						If !Empty( lcLetra )


							* The only difference between this property and the Value property
							* is that the Value2 property doesn't use the Currency and Date data types.
							* You can return values formatted with these data types as
							* floating-point numbers by using the Double data type.
							* Con Value retornaba el signo de la moneda y los separadores de miles
							* por lo que $ 1.102,58 lo mostraba como 0.00
							* Y a 1.102,58 lo mostraba como 2.10
							TEXT To lcCommand NoShow TextMerge Pretext 15
							luValue = loSheet.Range( '<<lcLetra>><<Transform( lnRow )>>' ).Value2
							ENDTEXT

							loSheet.Range( lcLetra + Transform( lnRow ) ).Select
							loExcel.Selection.FormulaHidden

							Try



								luValue = loSheet.Range( lcLetra + Transform( lnRow ) ).Value2

								luValue = This.ValidateValue( luValue, loField, lcLetra, lnRow )

								lcCast  = loField.FieldType

								If loField.FieldType = "D"
									luValue = This.Int2Date( luValue ) 
								Endif

								If !Empty( loField.FieldWidth )
									lcCast = lcCast + "(" + Transform( loField.FieldWidth )

									If !Empty( loField.FieldDec )
										lcCast = lcCast + "," + Transform( loField.FieldDec )
									Endif

									lcCast = lcCast + ")"

								Endif

								If Isnull( luValue )
									luValue = ""
								Endif

								TEXT To lcCommand NoShow TextMerge Pretext 15
								luValue = Cast( luValue as <<lcCast>> )
								ENDTEXT

								Try

									&lcCommand
									lcCommand = ""

									TEXT To lcCommand NoShow TextMerge Pretext 15
									loReg.<<loField.FieldName>> = luValue
									ENDTEXT

									&lcCommand
									lcCommand = ""

									If loField.lRequerido
										llImport = llImport And !IsEmpty( luValue )
									Endif

								Catch To oErr
									If oErr.ErrorNo = 1532 && La conversión de tipo no es compatible.
										llImport = .F.

									Else
										Throw oErr

									Endif

								Finally

								Endtry


							Catch To loErr
								Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
								loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
								loError.cRemark = lcCommand
								loError.Process ( m.loErr )
								*Throw loError

							Finally


							Endtry

						Else
							If loField.lRequerido
								llImport 		= .F.
								This.nVoidRows 	= -1
								This.nStatus 	= xls_Campo_Requerido_No_Definido

								TEXT To lcMsg NoShow TextMerge Pretext 03
								El campo <<loField.FieldName>> es obligatorio
								y no se ha definido la Columna
								ENDTEXT

								Stop( lcMsg, "Importar Hoja de Cálculo" )

							Endif

						Endif

						If !llImport
							Exit
						Endif

					Endfor

					If llImport

						Append Blank
						Gather Name loReg

						lnVoid = 0

					Else
						lnVoid = lnVoid + 1

					Endif

					If lnVoid > This.nVoidRows
						Exit
					Endif
				Endif

			Enddo

			Select Alias( This.cAlias )
			loExcel.Range("A1").Select

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Wait Clear
			If Vartype( loExcel ) = "O"
				loExcel.Visible = llVisible
			Endif

			loSheet 	= Null
			loExcel 	= Null
			loReg 		= Null
			loColumns 	= Null
			loField 	= Null


		Endtry

	Endproc && Importar

	*
	* Permite al programador personalizar el valor
	* No se debe editar este metodo directamente.
	* Hay que crear una instancia privada de la clase y allí si editar el metodo
	Procedure ValidateValue( uValue As Variant,;
			oField As Object,;
			cLetra As String,;
			lnRow As Integer ) As Void;
			HELPSTRING "Permite al programador personalizar el valor"

		Local lcCommand As String
		Local luValue As String

		Try

			lcCommand = ""
			luValue = Transform( uValue )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return luValue

	Endproc && ValidateValue


	*
	*
	Procedure CrearCursor(  ) As Void
		Local lcCommand As String,;
			lcField As String

		Local loColumns As oColumns Of "FW\Comunes\prg\Xls2Dbf.prg",;
			loField As Object


		Try

			lcCommand = ""
			loColumns = This.oColumns

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Cursor <<This.cAlias>> ( n_xls_row I,
			ENDTEXT

			lcField = ""

			For Each loField In loColumns

				lcField = lcField + ", " + loField.FieldName + " "
				lcField = lcField + loField.FieldType

				If !Empty( loField.FieldWidth )
					lcField = lcField + "(" + Transform( loField.FieldWidth )

					If !Empty( loField.FieldDec )
						lcField = lcField + "," + Transform( loField.FieldDec )
					Endif

					lcField = lcField + ")"

				Endif

			Endfor

			lcCommand = lcCommand + Substr( lcField, 2 ) + " )"

			&lcCommand
			lcCommand = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loField = Null
			loColumns = Null

		Endtry

	Endproc && CrearCursor


	*
	*
	Procedure DefinirCursor(  ) As Void
		Local lcCommand As String
		Local loColumns As oColumns Of "FW\Comunes\prg\Xls2Dbf.prg",;
			loField As Object

		Try

			lcCommand = ""
			*!*				This.oColumns = Null
			*!*				loColumns = This.oColumns
			*!*				loField 	= loColumns.New( "Codigo", "A", "N", 6, 0, .T. )
			*!*				loField 	= loColumns.New( "Talle", "D", "C", 6 )
			*!*				loField 	= loColumns.New( "Descripcion", "B", "C", 40 )
			*!*				loField 	= loColumns.New( "Precio", "E", "N", 12, 2 )




		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && DefinirCursor

	*
	* oExcel_Access
	Protected Procedure oExcel_Access()

		If Isnull( This.oExcel )
			Try

				This.oExcel = Createobject("Excel.Application")

			Catch To oErr
				TEXT To lcMsg NoShow TextMerge Pretext 03
				Microsoft Excel no se encuentra instalado...
				ENDTEXT

				Warning( lcMsg, _Screen.Caption )

			Finally

			Endtry

		Endif

		Return This.oExcel

	Endproc && oExcel_Access



	*
	*
	Procedure Destroy(  ) As Void
		Local lcCommand As String
		Local loExcel As "Excel.Application"

		Try

			lcCommand = ""
			If This.lQuitOnDestroy
				If !Isnull( This.oExcel )
					loExcel = This.oExcel
					loExcel.Quit()
				Endif
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loExcel = Null
			This.oExcel = Null

		Endtry

	Endproc && Destroy


	*
	* oColumns_Access
	Protected Procedure oColumns_Access()

		Local lcCommand As String

		Try

			lcCommand = ""
			If Vartype( This.oColumns ) # "O"
				This.oColumns = Newobject( "oColumns", "FW\Comunes\prg\Xls2Dbf.prg" )
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return This.oColumns

	Endproc && oColumns_Access


	*
	* Pasar de Entero a Fecha
	Procedure Int2Date( nInt as Integer ) As Date;
			HELPSTRING "Pasar de Entero a Fecha"
		Local lcCommand As String
		Local ldDate as Date 

		Try

			lcCommand = ""
			
			nInt = Cast( nInt as I )
		
			ldDate = {^1900/01/01} + nInt - 02 

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		EndTry
		
		Return ldDate  

	Endproc && Int2Date



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oXls2Dbf
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oColumns
*!* Description...:
*!* Date..........: Martes 3 de Octubre de 2017 (20:36:51)
*!*
*!*

Define Class oColumns As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg

	#If .F.
		Local This As oColumns Of "FW\Comunes\prg\Xls2Dbf.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*
	*
	Procedure New( cFieldName As String,;
			cLetra As String,;
			cFieldType As Character,;
			nFieldWidth As Integer,;
			nFieldDec As Integer,;
			lRequerido As Boolean ) As Object
		Local lcCommand As String
		Local loColumn As Object

		Try

			lcCommand = ""
			loColumn = Createobject( "Empty" )

			If Empty( cFieldType )
				cFieldType = " "
			Endif

			If Empty( cFieldName )
				cFieldName = "_" + cLetra
			Endif

			If Empty( nFieldWidth )
				nFieldWidth = 0
			Endif

			If Empty( nFieldDec )
				nFieldDec = 0
			Endif

			AddProperty( loColumn, "Letra", 		cLetra )
			AddProperty( loColumn, "FieldName", 	cFieldName )
			AddProperty( loColumn, "FieldType", 	cFieldType )
			AddProperty( loColumn, "FieldWidth", 	nFieldWidth )
			AddProperty( loColumn, "FieldDec", 		nFieldDec )
			AddProperty( loColumn, "lRequerido", 	lRequerido )

			This.AddItem ( loColumn, cFieldName )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loColumn

	Endproc && New


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oColumns
*!*
*!* ///////////////////////////////////////////////////////

