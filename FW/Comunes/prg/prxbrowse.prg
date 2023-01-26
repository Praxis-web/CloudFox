#INCLUDE "FW\Comunes\Include\Praxis.h"


Local lcCommand As String,;
	lcHeader As String
Local loDT As prxDataTier Of "fw\tieradapter\comun\prxdatatier.prg"
Local loBrowse As PrxBrowse Of "Fw\Comunes\Prg\Prxbrowse.prg"
		Local loHeader As oHeader Of "Fw\Comunes\Prg\prxBrowse.prg"
		Local loColumn As oColumn Of "Fw\Comunes\Prg\prxBrowse.prg"
Local loColColumns As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg

Local loColFields As Collection
Local loColPictures As Collection
Local loColHeaders As Collection

Local loParam As Object

Try

	lcCommand = ""
	WCODI = 11
	Close Databases All

	Set Procedure To "Rutinas\Rutina.prg"

	*Use "s:\Fenix\dbf\Srl\Dbf\AR12RetIB.DBF" Shared In 0
	Use "s:\Fenix Luque\dbf\Srl\Dbf\AR12RetIB.DBF" Shared In 0

	TEXT To lcCommand NoShow TextMerge Pretext 15
	Select 	Nume12,
			Base12,
			ICase( Juri12=901, Padr( "Capital", 15 ), Juri12=902, Padr( "Buenos Aires", 15 )) as Juri12
		From AR12RetIB
		Where Codi12 = <<WCODI>>
			And Numh12 = 0
	ENDTEXT
	loDT = NewDT()
	loDT.SQLExecute( lcCommand, "cCertificados" )

	loBrowse = Newobject( "PrxBrowse", "Fw\Comunes\Prg\Prxbrowse.prg" )
	loColColumns = loBrowse.oColColumns

	For Each loColumn In loColColumns
		Do Case
			Case Upper( loColumn.Name ) = "NUME12"
				loColumn.Header.Caption = "Certificado"

			Case Upper( loColumn.Name ) = "BASE12"
				loColumn.Header.Caption = "Base Imponible"

			Case Upper( loColumn.Name ) = "JURI12"
				loColumn.Header.Caption = "Jurisdicción"

			Otherwise

		Endcase

	Endfor

	*!*		For i = 1 To loColHeaders.Count
	*!*			Messagebox( loColHeaders.Item( i ).Value )
	*!*		Endfor

	*!*		loColFields = loBrowse.oColFields

	*!*		For i = 1 To loColFields.Count
	*!*			Messagebox( loColFields.Item( i ).Value )
	*!*		Endfor


	*!*		loColPictures = loBrowse.oColPictures

	*!*		For i = 1 To loColPictures.Count
	*!*			Messagebox( loColPictures.Item( i ).Value )
	*!*		Endfor


	loParam = Createobject( "Empty" )
	AddProperty( loParam, "Autocenter", .T. )
	AddProperty( loParam, "Caption", "Certificados de IIBB" )
	AddProperty( loParam, "Registros", _Tally )


	lnCert = loBrowse.Browse( "cCertificados.Nume12", loParam )

	Inkey()
	Messagebox( lnCert )

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.cRemark = lcCommand
	loError.Process( oErr )


Finally
	Close Databases All
	Set Procedure To
	loBrowse = Null
	loDT = Null

Endtry

*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxBrowse
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Despliega una tabla y devuelve el registro seleccionado
*!* Date..........: Martes 20 de Noviembre de 2012 (10:02:39)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxBrowse As Custom

	#If .F.
		Local This As PrxBrowse Of "V:\Clipper2fox\Fw\Comunes\Prg\Prxbrowse.prg"
	#Endif

	* Alias de la tabla
	Alias = ""

	* Colección de Columnas
	oColColumns = Null

	* Parametros que se pasan al Form Selector
	oParametros = Null


	* RA 2014-03-26(16:57:34)
	* Estos campos se mantienen por compatibilidad con la versión anterior

	* Coleccion de Campos
	oColFields = Null

	* Coleccion de Headers
	oColHeaders = Null

	* Coleccion de Pictures
	oColPictures = Null


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="browse" type="method" display="Browse" />] + ;
		[<memberdata name="ocolfields" type="property" display="oColFields" />] + ;
		[<memberdata name="alias" type="property" display="Alias" />] + ;
		[<memberdata name="alias_access" type="method" display="Alias_Access" />] + ;
		[<memberdata name="ocolfields_access" type="method" display="oColFields_Access" />] + ;
		[<memberdata name="ocolheaders" type="property" display="oColHeaders" />] + ;
		[<memberdata name="ocolheaders_access" type="method" display="oColHeaders_Access" />] + ;
		[<memberdata name="ocolpictures" type="property" display="oColPictures" />] + ;
		[<memberdata name="ocolpictures_access" type="method" display="oColPictures_Access" />] + ;
		[<memberdata name="oparametros" type="property" display="oParametros" />] + ;
		[<memberdata name="oparametros_access" type="method" display="oParametros_Access" />] + ;
		[<memberdata name="ocolcolumns" type="property" display="oColColumns" />] + ;
		[<memberdata name="ocolcolumns_access" type="method" display="oColColumns_Access" />] + ;
		[</VFPData>]

	*
	* Despliega la tabla y devuelve la clave seleccionada
	Procedure Browse( cKey As String,;
			oParam As Object ) As Void;
			HELPSTRING "Despliega la tabla y devuelve la clave seleccionada"

		Local lcCommand As String,;
			lcAlias As String
		Local loColFields As Collection,;
			loColPictures As Collection,;
			loColHeaders As Collection
		Local loObj As Object
		Local luKey As Variant
		Local Array laFields[ 1 ]

		Local loColColumns As Collection
		Local loColumn As Column
		Local loHeader As Header
		Local lnLen As Integer


		Try

			lcCommand = ""
			lcAlias = Alias()

			If IsEmpty( oParam )
				oParam = This.oParametros
			Endif

			loColFields 	= Createobject( "Collection" )
			loColPictures 	= Createobject( "Collection" )
			loColHeaders 	= Createobject( "Collection" )

			loColColumns 	= This.oColColumns

			lnLen = 0

			For Each loColumn In loColColumns

				If loColumn.Visible = .T.
					lnLen = lnLen + 1

					loColFields.Add( loColumn.Name )
					loColPictures.Add( loColumn.InputMask )
					loColHeaders.Add( Proper( Strtran( loColumn.Header.Caption, "_", " " )) )
				Endif

			Endfor

			loColColumns.nLen = lnLen

			If Empty( cKey )
				cKey = This.Alias + "." + loColFields.Item( 1 )
			Endif

			Select Alias( This.Alias )

			Do Case
				Case Inlist( Vartype( Evaluate( cKey ) ), "I", "N" )
					luKey = 0

				Case Inlist( Vartype( Evaluate( cKey ) ), "C" )
					luKey = ""

				Case Inlist( Vartype( Evaluate( cKey ) ), "D", "T" )
					luKey = Ctod( "" )

			Endcase

			If Vartype( oParam ) # "O"
				oParam = Createobject( "Empty" )
			Endif

			If !Pemstatus( oParam, "oColColumns", 5 )
				AddProperty( oParam, "oColColumns", Null )
			Endif

			oParam.oColColumns = loColColumns


			If CallSelector( loColFields,;
					loColPictures,;
					loColHeaders,;
					oParam )

				luKey = Evaluate( cKey )
				Keyboard '{ENTER}'
				prxSetLastKey( KEY_ENTER )

			Else
				prxSetLastKey( 0 )

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

		Return luKey

	Endproc && Browse

	*
	* Despliega la tabla y devuelve la clave seleccionada
	* RA 2014-03-26(17:24:54) Version vieja
	Procedure xxxBrowse( cKey As String,;
			oParam As Object ) As Void;
			HELPSTRING "Despliega la tabla y devuelve la clave seleccionada"

		Local lcCommand As String,;
			lcAlias As String
		Local loColFields As Collection,;
			loColPictures As Collection,;
			loColHeaders As Collection
		Local loObj As Object
		Local luKey As Variant
		Local Array laFields[ 1 ]

		Try

			lcCommand = ""
			lcAlias = Alias()

			If IsEmpty( oParam )
				oParam = This.oParametros
			Endif

			loColFields = Createobject( "Collection" )
			For Each loObj In This.oColFields
				loColFields.Add( loObj.Value )
			Endfor

			loColPictures = Createobject( "Collection" )
			For Each loObj In This.oColPictures
				loColPictures.Add( loObj.Value )
			Endfor

			loColHeaders = Createobject( "Collection" )
			For Each loObj In This.oColHeaders
				loColHeaders.Add( Proper( Strtran( loObj.Value, "_", " " )) )
			Endfor

			If Empty( cKey )
				cKey = This.Alias + "." + loColFields.Item( 1 )
			Endif

			Select Alias( This.Alias )
			*Locate

			Do Case
				Case Inlist( Vartype( Evaluate( cKey ) ), "I", "N" )
					luKey = 0

				Case Inlist( Vartype( Evaluate( cKey ) ), "C" )
					luKey = ""

				Case Inlist( Vartype( Evaluate( cKey ) ), "D", "T" )
					luKey = Ctod( "" )

			Endcase

			If CallSelector( loColFields,;
					loColPictures,;
					loColHeaders,;
					oParam )

				luKey = Evaluate( cKey )
				Keyboard '{ENTER}'
				prxSetLastKey( KEY_ENTER )

			Else
				prxSetLastKey( 0 )

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

		Return luKey

	Endproc && xxxBrowse

	*
	* Alias_Access
	Protected Procedure Alias_Access()
		If Empty( This.Alias )
			This.Alias = Alias()
		Endif
		Return This.Alias

	Endproc && Alias_Access

	*
	* oColColumns_Access
	Protected Procedure oColColumns_Access()

		Local loColColumns As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
			loHeader As oHeader Of "Fw\Comunes\Prg\prxBrowse.prg",;
			loColumn As oColumn Of "Fw\Comunes\Prg\prxBrowse.prg"

		Local lcCommand As String,;
			lcAlias As String,;
			lcColumnName As String,;
			lcPicture As String,;
			lcFieldName As String

		Local Array laFields[ 1 ]

		Local lnLen As Integer,;
			i As Integer,;
			lnFieldWidth As Integer,;
			lnFieldPrecision As Integer

		Try

			lcCommand = ""
			If Vartype( This.oColColumns ) # "O"

				loColColumns = Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.Prg" )
				This.oColColumns = loColColumns

				lcAlias = This.Alias

				lnLen = Afields( laFields, lcAlias )

				AddProperty( loColColumns, "nLen", lnLen )

				For i = 1 To lnLen
					lcColumnName = Lower( laFields[ i, AFIELDS_NAME ] )

					loColumn = Createobject( "oColumn" )
					loHeader = Createobject( "oHeader" )

					loColumn.Name = lcColumnName

					loColumn.ControlSource 	= lcColumnName
					loHeader.Caption 		= lcColumnName

					lnFieldWidth 		= laFields[ i, AFIELDS_WIDTH ]
					lnFieldPrecision 	= laFields[ i, AFIELDS_PRECISION ]

					Do Case
						Case laFields[ i, AFIELDS_TYPE ] = "D"
							lnFieldWidth = lnFieldWidth + 2

						Case laFields[ i, AFIELDS_TYPE ] = "I"
							lnFieldWidth = 8

					Endcase

					loColumn.Alignment = 0

					Do Case
						Case Inlist( laFields[ i, AFIELDS_TYPE ], "N", "I" )
							loColumn.Alignment = 1

						Case Inlist( laFields[ i, AFIELDS_TYPE ], "D" )
							lnFieldWidth = lnFieldWidth + 2

					Endcase

					lcPicture = ConvertInputMask( lnFieldWidth,;
						lnFieldPrecision  )

					loColumn.InputMask = lcPicture

					AddProperty( loColumn, "Header", loHeader )

					loColColumns.AddItem( loColumn, lcColumnName )

				Endfor

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loColColumns = Null

		Endtry

		Return This.oColColumns

	Endproc && oColColumns_Access

	*
	* oColFields_Access
	Protected Procedure oColFields_Access()
		Local lcCommand As String
		Local loColFields As Collection
		Local loField As Object
		Local lcAlias As String,;
			lcFieldName As String
		Local Array laFields[ 1 ]
		Local lnLen As Integer,;
			i As Integer

		Try

			lcCommand = ""
			If Vartype( This.oColFields ) # "O"
				loColFields = Createobject( "Collection" )
				This.oColFields = loColFields

				lcAlias = This.Alias

				lnLen = Afields( laFields, lcAlias )

				For i = 1 To lnLen
					lcFieldName = Lower( laFields[ i, AFIELDS_NAME ] )

					loField = Createobject( "Empty" )
					AddProperty( loField, "Value", lcFieldName )

					loColFields.Add( loField, lcFieldName )

				Endfor

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loColFields = Null

		Endtry

		Return This.oColFields

	Endproc && oColFields_Access

	*
	* oColPictures_Access
	Protected Procedure oColPictures_Access()
		Local lcCommand As String
		Local loColPictures As Collection
		Local loPicture As Object
		Local lcAlias As String,;
			lcPicture As String,;
			lcFieldName As String
		Local Array laPictures[ 1 ]
		Local lnLen As Integer,;
			i As Integer,;
			lnFieldWidth As Integer,;
			lnFieldPrecision As Integer


		Try

			lcCommand = ""
			If Vartype( This.oColPictures ) # "O"
				loColPictures = Createobject( "Collection" )
				This.oColPictures = loColPictures

				lcAlias = This.Alias

				lnLen = Afields( laPictures, lcAlias )

				For i = 1 To lnLen

					lnFieldWidth = laPictures[ i, AFIELDS_WIDTH ]
					lnFieldPrecision = laPictures[ i, AFIELDS_PRECISION ]
					lcFieldName = Lower( laPictures[ i, AFIELDS_NAME ] )

					If laPictures[ i, AFIELDS_TYPE ] = "D"
						*						If Set("Century") = "ON"
						lnFieldWidth = lnFieldWidth + 2
						*						EndIf
					Endif

					lcPicture = ConvertInputMask( lnFieldWidth,;
						lnFieldPrecision  )

					loPicture = Createobject( "Empty" )
					AddProperty( loPicture, "Value", lcPicture )

					loColPictures.Add( loPicture, lcFieldName )

				Endfor

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loColPictures = Null

		Endtry

		Return This.oColPictures

	Endproc && oColPictures_Access

	*
	* oColHeaders_Access
	Protected Procedure oColHeaders_Access()
		Local lcCommand As String
		Local loColHeaders As Collection
		Local loHeader As Object
		Local lcAlias As String,;
			lcHeader As String,;
			lcFieldName As String
		Local Array laHeaders[ 1 ]
		Local lnLen As Integer,;
			i As Integer

		Try

			lcCommand = ""
			If Vartype( This.oColHeaders ) # "O"
				loColHeaders = Createobject( "Collection" )
				This.oColHeaders = loColHeaders

				lcAlias = This.Alias

				lnLen = Afields( laHeaders, lcAlias )

				For i = 1 To lnLen
					lcFieldName = Lower( laHeaders[ i, AFIELDS_NAME ] )
					lcHeader = Proper( lcFieldName )

					loHeader = Createobject( "Empty" )
					AddProperty( loHeader, "Value", lcHeader )

					loColHeaders.Add( loHeader, lcFieldName )

				Endfor

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loColHeaders = Null

		Endtry

		Return This.oColHeaders

	Endproc && oColHeaders_Access

	Procedure Destroy
		This.oColFields = Null
		This.oColHeaders = Null
		This.oColPictures = Null
	Endproc

	*!*		*
	*!*		* oParametros_Access
	*!*		* Permite personalizar las propiedades de las columnas y los headers
	*!*		* Se precesa en Selector.scx
	*!*		Protected Procedure oParametros_Access()
	*!*			Local lcCommand As String
	*!*			Local loColColumns As Collection,;
	*!*				loColColumnsProperties As Collection,;
	*!*				loColHeaders As Collection,;
	*!*				loColHeadersProperties As Collection

	*!*			Local loParametros As Object

	*!*			Try

	*!*				lcCommand = ""

	*!*				If Vartype( This.oParametros ) # "O"
	*!*					loColColumnsProperties = Createobject( "Collection" )
	*!*					loColHeadersProperties = Createobject( "Collection" )

	*!*					loColColumns = Createobject( "Collection" )
	*!*					loColHeaders = Createobject( "Collection" )

	*!*					AddProperty( loColColumns, "oColColumnsProperties", loColColumnsProperties )
	*!*					AddProperty( loColHeaders, "oColHeadersProperties", loColHeadersProperties )

	*!*					loParametros = Createobject( "Empty" )
	*!*					AddProperty( loParametros, "oColColumns", loColColumns )
	*!*					AddProperty( loParametros, "oColHeaders", loColHeaders )

	*!*					This.oParametros = loParametros
	*!*				Endif

	*!*			Catch To oErr
	*!*				Local loError As prxErrorHandler Of "FW\ErrorHandler\prxErrorHandler.prg"
	*!*				loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
	*!*				loError.Remark = lcCommand
	*!*				loError.Process( oErr )
	*!*				Throw loError

	*!*			Finally
	*!*				loColColumnsProperties = Null
	*!*				loColHeadersProperties = Null
	*!*				loColColumns = Null
	*!*				loColHeaders = Null
	*!*				loParametros = Null

	*!*			Endtry


	*!*			Return This.oParametros

	*!*		Endproc && oParametros_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: PrxBrowse
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oColumn
*!* ParentClass...: Empty
*!* BaseClass.....: Empty
*!* Description...: Contiene las propiedades de la clase Column
*!* Date..........: Jueves 27 de Marzo de 2014 (10:57:49)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class oColumn As Custom

	#If .F.
		Local This As oColumn Of "Fw\Comunes\Prg\prxBrowse.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	Alignment = .F.
	BackColor = .F.
	Bound = .T.
	ColumnOrder = .F.
	ControlSource = .F.
	CurrentControl = .F.
	DynamicAlignment = .F.
	DynamicBackColor = .F.
	DynamicCurrentControl = .F.
	DynamicFontBold = .F.
	DynamicFontItalic = .F.
	DynamicFontName = .F.
	DynamicFontOutline = .F.
	DynamicFontShadow = .F.
	DynamicFontSize = .F.
	DynamicFontStrikethru = .F.
	DynamicFontUnderline = .F.
	DynamicForeColor = .F.
	DynamicInputMask = .F.
	Enabled = .F.
	FontBold = .F.
	FontCharSet = .F.
	FontCondense = .F.
	FontExtend = .F.
	FontItalic = .F.
	FontName = .F.
	FontOutline = .F.
	FontShadow = .F.
	FontSize = .F.
	FontStrikethru = .F.
	FontUnderline = .F.
	ForeColor = .F.
	Format = .F.
	HeaderClass = .F.
	HeaderClassLibrary = .F.
	InputMask = .F.
	MouseIcon = .F.
	MousePointer = .F.
	Movable = .F.
	ReadOnly = .F.
	Resizable = .F.
	SelectOnEntry = .F.
	Sparse = .F.
	StatusBarText = .F.
	ToolTipText = .F.
	Visible = .F.

	*
	*
	Procedure Init(  ) As Boolean
		Local lcCommand As String
		Local llOk As Boolean
		Local loGrid As Grid
		Local loSourceObject As Column

		Try

			lcCommand = ""
			llOk = .F.

			loGrid = Createobject( "Grid" )

			loGrid.ColumnCount 	= 1
			loSourceObject 		= loGrid.Columns[ 1 ]

			PopulateProperties( This, loSourceObject )

			llOk = .T.

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loSourceObject = Null
			loGrid = Null

		Endtry

		Return llOk

	Endproc && Init


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oColumn
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oHeader
*!* ParentClass...: Empty
*!* BaseClass.....: Empty
*!* Description...: Contiene las propiedades de la clase Header
*!* Date..........: Jueves 27 de Marzo de 2014 (10:57:49)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class oHeader As Custom

	#If .F.
		Local This As oHeader Of "V:\Clipper2fox\Fw\Comunes\Prg\prxBrowse.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	Alignment = .F.
	BackColor = .F.
	Caption = .F.
	FontBold = .F.
	FontCharSet = .F.
	FontCondense = .F.
	FontExtend = .F.
	FontItalic = .F.
	FontName = .F.
	FontOutline = .F.
	FontShadow = .F.
	FontSize = .F.
	FontStrikethru = .F.
	FontUnderline = .F.
	ForeColor = .F.
	MouseIcon = .F.
	MousePointer = .F.
	StatusBarText = .F.
	ToolTipText = .F.
	WordWrap = .F.

	*
	*
	Procedure Init(  ) As Boolean
		Local lcCommand As String
		Local llOk As Boolean
		Local loGrid As Grid
		Local loColumn As Column
		Local loSourceObject As Header

		Try

			lcCommand = ""
			llOk = .F.

			loGrid = Createobject( "Grid" )
			loGrid.ColumnCount 	= 1

			loColumn = loGrid.Columns[ 1 ]

			loSourceObject = loColumn.Controls[ 1 ]

			PopulateProperties( This, loSourceObject )

			llOk = .T.

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loSourceObject = Null
			loGrid = Null

		Endtry

		Return llOk

	Endproc && Init


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oHeader
*!*
*!* ///////////////////////////////////////////////////////