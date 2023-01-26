#Include 'Tools\namespaces\Include\FoxPro.h'
#Include 'Tools\namespaces\Include\System.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
	Do 'Tools\namespaces\prg\CursorAdapterBase.prg'
	Do 'Tools\namespaces\prg\EnvironmentNamespace.prg'
	Do 'Tools\namespaces\prg\LogicalNamespace.prg'
Endif


#Define FIELDNAME 1
#Define FIELDTYPE 2
#Define FIELDWIDTH 3
#Define FIELDDECIMAL 4
#Define FIELDNULL 5
#Define FIELDCPTRANS 6
#Define FIELDDEFAULT 9

*------ GetFieldState() returns

#Define GFS_NOT_MODIFIED			1
#Define GFS_MODIFIED				2
#Define GFS_APPENDED_NOT_MODIFIED	3
#Define GFS_APPENDED_MODIFIED		4

* CursorNameSpace
*
Define Class CursorNameSpace As NamespaceBase Of 'Tools\namespaces\prg\ObjectNamespace.prg' 

	#If .F.
		Local This As CursorNameSpace Of 'Tools\namespaces\prg\CursorNameSpace.prg'
	#Endif

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="addcolumns" type="method" display="AddColumns"/>] ;
		+ [<memberdata name="appendfromcursor" type="method" display="AppendFromCursor"/>] ;
		+ [<memberdata name="createfromcursor" type="method" display="CreateFromCursor"/>] ;
		+ [<memberdata name="datahaschanges" type="method" display="DataHasChanges"/>] ;
		+ [<memberdata name="getcursorstructure" type="method" display="GetCursorStructure"/>] ;
		+ [<memberdata name="getfieldsvalues" type="method" display="GetFieldsValues"/>] ;
		+ [<memberdata name="insertfromcursor" type="method" display="InsertFromCursor"/>] ;
		+ [<memberdata name="fieldupdated" type="method" display="FieldUpdated"/>] ;
		+ [<memberdata name="getfieldstructure" type="method" display="GetFieldStructure"/>] ;
		+ [<memberdata name="getprop" type="method" display="GetProp"/>] ;
		+ [<memberdata name="getupdatablefieldlist" type="method" display="GetUpdaTableFieldList"/>] ;
		+ [<memberdata name="getvalue" type="method" display="GetValue"/>] ;
		+ [<memberdata name="packcursor" type="method" display="PackCursor"/>] ;
		+ [<memberdata name="zapcursor" type="method" display="ZapCursor"/>] ;
		+ [</VFPData>]

	Dimension m.AddColumns_COMATTRIB[ 5 ]
	AddColumns_COMATTRIB[ 1 ] = 0
	AddColumns_COMATTRIB[ 2 ] = 'Agrega campos a un cursor.'
	AddColumns_COMATTRIB[ 3 ] = 'AddColumns'
	AddColumns_COMATTRIB[ 4 ] = 'Boolean'
	* AddColumns_COMATTRIB[ 5 ] = 0

	* AddColumns
	* Agrega campos a un cursor. 
	Function AddColumns ( tcNewColumns As String, tcCursorAlias As String ) As Boolean HelpString 'Agrega campos a un cursor.'

		Local lcAlias As String, ;
			lcNewAlias As String, ;
			llDone As Boolean, ;
			lnNewRows As Integer, ;
			loAlias As Object, ;
			loErr As Exception

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Agrega campos a un cursor
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Jueves 9 de Agosto de 2007 ( 11:23:08 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		Try

			loAlias = m.Environment.SaveArea()

			* lcAlias   = Alias()
			llDone    = .F.
			lnNewRows = 0
			lcAlias   = ''

			If Empty ( m.tcNewColumns )
				llDone = .T.

			Else
				lcNewAlias = 'csr' + Sys ( 2015 )

				If Empty ( m.tcCursorAlias )
					tcCursorAlias = Alias()

				Endif && Empty( m.tcCursorAlias )

				This.CreateFromCursor ( m.lcNewAlias, m.tcCursorAlias, m.lnNewRows, m.tcNewColumns )

				If Used ( m.lcNewAlias )
					llDone = .T.
					Select Alias ( m.lcNewAlias )
					Append From Dbf ( m.tcCursorAlias )
					Use In Select ( m.tcCursorAlias )
					Select * From Alias ( m.lcNewAlias ) Into Cursor ( m.tcCursorAlias ) Readwrite

				Else
					llDone = .F.

				Endif && Used( m.lcNewAlias )

			Endif && Empty( m.tcNewColumns )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcNewColumns, tcCursorAlias
			llDone = .F.
			THROW_EXCEPTION

		Finally
			Use In Select ( m.lcNewAlias )
			*!*	If Used ( m.lcAlias )
			*!*		Select Alias ( m.lcAlias )

			*!*	Endif && Used( m.lcAlias )
			loAlias = Null

		Endtry

		Return m.llDone

	Endfunc && AddColumns

	Dimension AppendFromCursor_COMATTRIB[ 5 ]
	AppendFromCursor_COMATTRIB[ 1 ] = 0
	AppendFromCursor_COMATTRIB[ 2 ] = 'Inserta un grupo de registros desde otro cursor.'
	AppendFromCursor_COMATTRIB[ 3 ] = 'AppendFromCursor'
	AppendFromCursor_COMATTRIB[ 4 ] = ''
	* AppendFromCursor_COMATTRIB[ 5 ] = 0

	* AppendFromCursor
	* Inserta un grupo de registros desde otro cursor.
	Procedure AppendFromCursor ( tcFromCursor As String, tcToCursor As String, tcFilterCriteria As String ) As Void HelpString 'Inserta un grupo de registros desde otro cursor.'

		Local lcAlias As String, ;
			loAlias As Object, ;
			loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Autor:
			 Ricardo Aidelman
			 *:Parameters:
			 *:Remarks:
			 Inserta un grupo de registros desde otro cursor
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try

			loAlias = m.Environment.SaveArea()
			* lcAlias = Alias()

			If Empty ( m.tcFromCursor )
				Error 'Debe indicar el nombre del cursor origen'

			Endif && Empty( m.tcFromCursor )

			If Empty ( m.tcToCursor )
				tcToCursor = Alias()

			Endif && Empty( m.tcToCursor )


			Select Alias ( m.tcFromCursor )
			Locate

			If Empty ( m.tcFilterCriteria )
				* m.tcFilterCriteria = " 1 > 0 "
				Scan
					* TODO: Verificar "InsertFromCursor"
					This.InsertFromCursor ( m.tcFromCursor, m.tcToCursor )

				Endscan

			Else
				Scan For Evaluate ( m.tcFilterCriteria )
					This.InsertFromCursor ( m.tcFromCursor, m.tcToCursor )

				Endscan

			Endif && Empty( m.tcFilterCriteria )

			If ! Used ( m.tcToCursor )
				* Si no se produce ninguna coincidencia con tcFilterCriteria
				* y no existe el cursor destino,
				* se devuelve una estructura vacía
				Select * From ( m.tcFromCursor ) Where 1 = 0 Into Cursor ( m.tcToCursor ) Nofilter Readwrite

			Endif && ! Used( m.tcToCursor )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFromCursor, tcToCursor, tcFilterCriteria
			THROW_EXCEPTION

		Finally
			*!*	If Used ( m.lcAlias )
			*!*		Select Alias ( m.lcAlias )

			*!*	Endif && Used( m.lcAlias )
			loAlias = Null

		Endtry

	Endproc && AppendFromCursor

	Dimension CreateFromCursor_COMATTRIB[ 5 ]
	CreateFromCursor_COMATTRIB[ 1 ] = 0
	CreateFromCursor_COMATTRIB[ 2 ] = 'Crea una estructura vacía de un cursor a partir de otro.'
	CreateFromCursor_COMATTRIB[ 3 ] = 'CreateFromCursor'
	CreateFromCursor_COMATTRIB[ 4 ] = 'Number'
	* CreateFromCursor_COMATTRIB[ 5 ] = 1

	* CreateFromCursor
	* Crea una estructura vacía de un cursor a partir de otro.
	Function CreateFromCursor ( tcNewCursorName As String, tcFromCursorAlias As String, tnEmptyRows As Integer, tcExtraFields As String ) As Number HelpString 'Crea una estructura vacía de un cursor a partir de otro.'

		Local lcAlias As String, ;
			lcCommand As String, ;
			lcCursorStructure As String, ;
			liIdx As Integer, ;
			lnNewRows As Integer, ;
			loAlias As Object, ;
			loErr As Exception

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Crea una estructura vacía de un cursor a partir de otro
				 *:Project:
				 CMSI
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Lunes 12 de Febrero de 2007 ( 11:44:27 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		Try

			lnNewRows = -1

			* lcAlias = Alias()
			loAlias = m.Environment.SaveArea()

			If Empty ( m.tcNewCursorName )
				Error 'Debe indicar el nombre del cursor a crear.'

			Endif && Empty( m.tcNewCursorName )

			tcNewCursorName = Strtran ( Juststem ( m.tcNewCursorName ), Space ( 1 ), '_', -1, -1, 1 )

			If Empty ( m.tcFromCursorAlias )
				tcFromCursorAlias = Alias()

			Endif && Empty( m.tcFromCursorAlias )

			If Empty ( m.tnEmptyRows )
				tnEmptyRows = 0

			Endif && Empty( m.tnEmptyRows )

			If Empty ( m.tcExtraFields )
				tcExtraFields = ''

			Endif && Empty( m.tcExtraFields )

			lcCursorStructure = This.GetCursorStructure ( m.tcFromCursorAlias, m.tcExtraFields )

			TEXT To m.lcCommand Noshow Textmerge Pretext 15
				Create Cursor [<<m.tcNewCursorName>>] ( <<m.lcCursorStructure>> )
			ENDTEXT

			Evaluate ( m.lcCommand )

			For liIdx = 1 To m.tnEmptyRows
				Append Blank In ( m.tcNewCursorName )

			Endfor

			lnNewRows = Reccount ( m.tcNewCursorName )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcNewCursorName, tcFromCursorAlias, tnEmptyRows, tcExtraFields
			THROW_EXCEPTION

		Finally
			*!*	If Used ( m.lcAlias )
			*!*		Select Alias ( m.lcAlias )

			*!*	Endif && Used( m.lcAlias )
			loAlias = Null

		Endtry

		Return m.lnNewRows

	Endfunc && CreateFromCursor

	Dimension DataHasChanges_COMATTRIB[ 5 ]
	DataHasChanges_COMATTRIB[ 1 ] = 0
	DataHasChanges_COMATTRIB[ 2 ] = 'Devuelve .T. si los datos en el cursor han sido modificados.'
	DataHasChanges_COMATTRIB[ 3 ] = 'DataHasChanges'
	DataHasChanges_COMATTRIB[ 4 ] = 'Boolean'
	* DataHasChanges_COMATTRIB[ 5 ] = 1

	*
	* DataHasChanges
	* Devuelve .T. si los datos en el cursor han sido modificados.
	Function DataHasChanges ( tcCursorName As String, tlCheckAllTable As Boolean ) As Boolean HelpString 'Devuelve .T. si los datos en el cursor han sido modificados.'

		Local lcGetfldstate As String, ;
			llDataHasChanges As Boolean, ;
			llDone As Boolean, ;
			lnRecno As Integer, ;
			loErr As Exception, ;
			loSaveRecno As Object, ;
			loSetSelect As Object

		Try

			llDataHasChanges = .F.

			If Used ( m.tcCursorName ) And CursorGetProp ( 'Buffering', m.tcCursorName ) == 5

				If m.tlCheckAllTable
					* Select Alias ( m.tcCursorName )
					loSetSelect = m.Environment.SetSelect ( m.tcCursorName )
					* m.lnRecno = Recno( m.tcCursorName )
					loSaveRecno =  m.Environment.SaveRecno ( m.tcCursorName )
					Locate

					If Getnextmodified ( 0, m.tcCursorName ) # 0
						lcGetfldstate = Getfldstate ( -1, m.tcCursorName )
						If ! Empty ( At ( Transform ( GFS_MODIFIED ), m.lcGetfldstate ) ) Or ! Empty ( At ( Transform ( GFS_APPENDED_MODIFIED ), m.lcGetfldstate ) )
							llDataHasChanges = .T.

						Endif && ! Empty ( At ( Transform ( GFS_MODIFIED ), m.lcGetfldstate ) ) Or ! Empty ( At ( Transform ( GFS_APPENDED_MODIFIED ), m.lcGetfldstate ) )

					Endif && Getnextmodified ( 0, m.tcCursorName ) # 0

					*!*	If !Empty ( m.lnRecno )
					*!*		Try
					*!*			Goto m.lnRecno

					*!*		Catch To loErr
					*!*		Endtry

					*!*	Endif

				Else && m.tlCheckAllTable
					lcGetfldstate = Getfldstate ( -1, m.tcCursorName )
					If ! Empty ( At ( Transform ( GFS_MODIFIED ), lcGetfldstate ) ) Or ! Empty ( At ( Transform ( GFS_APPENDED_MODIFIED ), m.lcGetfldstate ) )
						llDataHasChanges = .T.

					Endif && ! Empty ( At ( Transform ( GFS_MODIFIED ), lcGetfldstate ) ) Or ! Empty ( At ( Transform ( GFS_APPENDED_MODIFIED ), m.lcGetfldstate ) )

				Endif && m.tlCheckAllTable

			Endif && Used ( m.tcCursorName ) And CursorGetProp ( 'Buffering', m.tcCursorName ) == 5

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCursorName, tlCheckAllTable
			THROW_EXCEPTION

		Endtry

		Return m.llDataHasChanges

	Endfunc && DataHasChanges

	Dimension FieldUpdated_COMATTRIB[ 5 ]
	FieldUpdated_COMATTRIB[ 1 ] = 0
	FieldUpdated_COMATTRIB[ 2 ] = 'Devuelve .T. si el valor del campo del cursor ha sido modificado.'
	FieldUpdated_COMATTRIB[ 3 ] = 'FieldUpdated'
	FieldUpdated_COMATTRIB[ 4 ] = 'Boolean'
	* FieldUpdated_COMATTRIB[ 5 ] = 1

	* FieldUpdated
	* Devuelve .T. si el valor del campo del cursor ha sido modificado.
	Function FieldUpdated ( tcExpression As String, tcTableAlias As String ) As Boolean HelpString 'Devuelve .T. si el valor del campo del cursor ha sido modificado.'

		Local lcExp As String, ;
			llUpdated As Boolean, ;
			loErr As Exception, ;
			lvOldValue As Variant, ;
			lvValue As Variant

		Try
			lcExp      = m.tcTableAlias  + [.] + m.tcExpression
			lvValue    = Evaluate ( m.lcExp )
			lvOldValue = Oldval ( m.tcExpression, m.tcTableAlias )
			Do Case
				Case Isnull ( lvOldValue )
					llUpdated = ! Isnull ( m.lvValue )

				Case Isnull ( Curval ( m.tcExpression, m.tcTableAlias ) )
					llUpdated = ! Isnull ( m.lvValue )

				Otherwise
					* llUpdated = Oldval ( m.tcExpression, m.tcTableAlias ) # m.lvValue
					llUpdated = lvOldValue # m.lvValue

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcExpression, tcTableAlias
			THROW_EXCEPTION

		Endtry

		Return m.llUpdated

	Endfunc && FieldUpdated

	Dimension GetCursorStructure_COMATTRIB[ 5 ]
	GetCursorStructure_COMATTRIB[ 1 ] = 0
	GetCursorStructure_COMATTRIB[ 2 ] = 'Devuelve una cadena con la estructura del cursor.'
	GetCursorStructure_COMATTRIB[ 3 ] = 'GetCursorStructure'
	GetCursorStructure_COMATTRIB[ 4 ] = 'String'
	* GetCursorStructure_COMATTRIB[ 5 ] = 2

	* GetCursorStructure
	* Devuelve una cadena con la estructura del cursor.
	Function GetCursorStructure ( tcCursorAlias As String, tcExtraFields As String ) As String HelpString 'Devuelve una cadena con la estructura del cursor.'

		Local laFields[1], ;
			lcAlias As String, ;
			lcCursorStructure As String, ;
			lcFNames As String, ;
			lcField As String, ;
			liIdx As Integer, ;
			lnLen As Integer, ;
			loAlias As Object, ;
			loErr As Exception

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve un string con la estructura del cursor.
				 *:Project:
				 CMSI
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Lunes 12 de Febrero de 2007 ( 14:40:06 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		Try

			* lcAlias           = Alias()
			loAlias           = m.Environment.SaveArea()
			lcCursorStructure = ''
			If Empty ( m.tcExtraFields )
				tcExtraFields = ''

			Else
				tcExtraFields = ', ' + m.tcExtraFields

			Endif && Empty( m.tcExtraFields )

			If Empty ( m.tcCursorAlias )
				tcCursorAlias = Alias()

			Endif && Empty( m.tcCursorAlias )

			lnLen = Afields ( m.laFields, m.tcCursorAlias )

			lcFNames = ''

			For liIdx = 1 To m.lnLen
				lcField = '[' + m.laFields[ m.liIdx, FIELDNAME ] + '] ' + m.laFields[ m.liIdx, FIELDTYPE ]

				lcField = m.lcField + '( ' + Transform ( m.laFields[ m.liIdx, FIELDWIDTH ] )

				If Empty ( m.laFields[ m.liIdx, FIELDDECIMAL ] )
					lcField = m.lcField + ' )'

				Else
					lcField = m.lcField + ', ' + Transform ( m.laFields[ m.liIdx, FIELDDECIMAL ] ) + ' )'

				Endif && Empty( m.laFields[ m.liIdx, FIELDDECIMAL ] )

				If m.laFields[ m.liIdx, FIELDNULL ]
					lcField = m.lcField + ' NULL '

				Else
					lcField = m.lcField + ' NOT NULL '

				Endif && m.laFields[ m.liIdx, FIELDNULL ]

				If ! Empty ( m.laFields[ m.liIdx, FIELDDEFAULT ] )
					lcField = m.lcField + ' DEFAULT ' + Alltrim ( m.laFields[ m.liIdx, FIELDDEFAULT ] )

				Endif && ! Empty( m.laFields[ m.liIdx, FIELDDEFAULT ] )

				If m.laFields[ m.liIdx, FIELDCPTRANS ]
					lcField = m.lcField + ' NOCPTRANS '

				Endif && m.laFields[ m.liIdx, FIELDCPTRANS ]

				lcFNames = m.lcFNames + ', ' + m.lcField

			Endfor

			lcCursorStructure = Substr ( m.lcFNames, 2 ) + m.tcExtraFields

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCursorAlias, tcExtraFields
			THROW_EXCEPTION

		Finally
			*!*	If Used ( m.lcAlias )
			*!*		Select Alias ( m.lcAlias )

			*!*	Endif && Used( m.lcAlias )
			loAlias = Null

		Endtry

		Return m.lcCursorStructure

	Endfunc && GetCursorStructure

	Dimension GetFieldsValues_COMATTRIB[ 5 ]
	GetFieldsValues_COMATTRIB[ 1 ] = 0
	GetFieldsValues_COMATTRIB[ 2 ] = 'Devuelve un objeto con los valores del registro actual.'
	GetFieldsValues_COMATTRIB[ 3 ] = 'GetFieldsValues'
	GetFieldsValues_COMATTRIB[ 4 ] = 'Object'
	* GetFieldsValues_COMATTRIB[ 5 ] = 1

	* GetFieldsValues
	* Devuelve un objeto con los valores del registro actual.
	Function GetFieldsValues ( tcCursorAlias As String ) As Object HelpString 'Devuelve un objeto con los valores del registro actual.'

		Local lcAlias As String, ;
			loAlias As Object, ;
			loErr As Exception, ;
			loFieldsValues As Object

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve un objeto con los valores del registro actual
				 *:Project:
				 CMSI
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Lunes 12 de Febrero de 2007 ( 14:40:06 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		Try
			* lcAlias        = Alias()
			loAlias        = m.Environment.SaveArea()
			loFieldsValues = Null

			If Empty ( m.tcCursorAlias )
				tcCursorAlias = Alias()

			Endif && Empty( m.tcCursorAlias )

			Select Alias ( m.tcCursorAlias )
			Scatter Memo Name m.loFieldsValues

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCursorAlias
			THROW_EXCEPTION

		Finally
			*!*	If Used ( m.lcAlias )
			*!*		Select Alias ( m.lcAlias )

			*!*	Endif && Used( m.lcAlias )
			loAlias = Null

		Endtry

		Return m.loFieldsValues

	Endfunc && GetFieldsValues

	Dimension GetChangedFields_COMATTRIB[ 5 ]
	GetChangedFields_COMATTRIB[ 1 ] = 0
	GetChangedFields_COMATTRIB[ 2 ] = 'Devuelve un objeto con los campos modificados que puede ser usado con el comando Gather Name.'
	GetChangedFields_COMATTRIB[ 3 ] = 'GetChangedFields'
	GetChangedFields_COMATTRIB[ 4 ] = 'Variant'
	* GetChangedFields_COMATTRIB[ 5 ] = 1

	* GetChangedFields
	* Devuelve un objeto con los campos modificados que puede ser usado con el comando Gather Name.
	Function GetChangedFields ( tcCursorName As String, tlReturnValues As Boolean ) As Variant HelpString 'Devuelve un objeto con los campos modificados que puede ser usado con el comando Gather Name.'

		Local laFields[1], ;
			lcCommand As String, ;
			lcFieldName As String, ;
			lcGetfldstate As String, ;
			liIdx As Integer, ;
			llDone As Boolean, ;
			lnLen As Integer, ;
			lnRecno As Integer, ;
			loColFields As Collection, ;
			loErr As Exception, ;
			loField As Object, ;
			loFields As Object, ;
			luret As Variant

		Try

			lcCommand   = ''
			loFields    = Createobject ( 'Empty' )
			loColFields = Createobject ( 'Collection' )

			If Used ( m.tcCursorName ) And CursorGetProp ( 'Buffering', m.tcCursorName ) == 5

				lcGetfldstate = Getfldstate ( -1, m.tcCursorName )
				If ! Empty ( At ( Transform ( GFS_MODIFIED ), m.lcGetfldstate ) ) Or ! Empty ( At ( Transform ( GFS_APPENDED_MODIFIED ), m.lcGetfldstate ) )

					lnLen = Afields ( laFields, vtcCursorName )

					For liIdx = 1 To lnLen
						lcFieldName = laFields[ m.liIdx, 1 ]

						If Inlist ( Getfldstate ( m.liIdx, m.tcCursorName ), GFS_MODIFIED, GFS_APPENDED_MODIFIED )
							AddProperty ( m.loFields, m.lcFieldName, Evaluate ( m.tcCursorName + '.' + m.lcFieldName ) )
							loField = Createobject ( 'Empty' )
							AddProperty ( m.loField, 'TableName', m.tcCursorName )
							AddProperty ( m.loField, 'FieldName', m.lcFieldName )
							AddProperty ( m.loField, 'OldVal', Oldval ( m.lcFieldName, m.tcCursorName ) )
							AddProperty ( m.loField, 'CurVal', Curval ( m.lcFieldName, m.tcCursorName ) )

							m.loColFields.Add ( m.loField )

						Endif && Inlist( Getfldstate( m.liIdx, m.tcCursorName ), GFS_MODIFIED, GFS_APPENDED_MODIFIED )

					Endfor

				Endif && ! Empty( At( Transform( GFS_MODIFIED ), m.lcGetfldstate ) ) Or ! Empty( At( Transform( GFS_APPENDED_MODIFIED ), m.lcGetfldstate ) )

			Endif && Used( m.tcCursorName ) And CursorGetProp( "Buffering", m.tcCursorName ) == 5

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCursorName, tlReturnValues
			THROW_EXCEPTION

		Endtry

		If m.tlReturnValues
			luret = m.loColFields

		Else && m.tlReturnValues
			luret = m.loFields

		Endif && m.tlReturnValues

		Return m.luret

	Endfunc && GetChangedFields

	Dimension GetFieldStructure_COMATTRIB[ 5 ]
	GetFieldStructure_COMATTRIB[ 1 ] = 0
	GetFieldStructure_COMATTRIB[ 2 ] = 'Devuelve una cadena con la estructura del campo.'
	GetFieldStructure_COMATTRIB[ 3 ] = 'GetFieldStructure'
	GetFieldStructure_COMATTRIB[ 4 ] = 'String'
	* GetFieldStructure_COMATTRIB[ 5 ] = 2

	* GetFieldStructure
	* Devuelve una cadena con la estructura del campo.
	Function GetFieldStructure ( tcFieldName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldDecimal As Integer, tlFieldNull As Boolean, tlFieldCPTrans As Boolean, tuFieldDefault As Variant ) As String HelpString 'Devuelve una cadena con la estructura del campo.'

		Local lcFieldStructure As String, ;
			loErr As Exception

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
  				 Devuelve una cadena con la estructura del campo.
				 *:Project:
				 CMSI
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Lunes 12 de Febrero de 2007 (14:40:06)
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		Try

			lcFieldStructure = '[' + tcFieldName + '] ' + tcFieldType
			tcFieldType      = Upper ( m.tcFieldType )

			If ! Empty ( tnFieldWidth ) And ! ( m.tcFieldType $ 'IWYDTGLM' )
				lcFieldStructure = lcFieldStructure + '(' + Transform ( tnFieldWidth )

			Endif && ! Empty ( tnFieldWidth ) And ! ( m.tcFieldType $ 'IWYDTGLM' )

			If Empty ( tnFieldDecimal )
				If ! Empty ( tnFieldWidth )
					Do Case
						Case tcFieldType $ 'NF'
							lcFieldStructure = lcFieldStructure + ',' + Transform ( tnFieldDecimal ) + ')'

						Case  ! tcFieldType $ 'IWYDTGLM'
							lcFieldStructure = lcFieldStructure + ')'

						Otherwise

					Endcase

				Endif

			Else && Empty ( tnFieldDecimal )
				If tcFieldType == 'B'
					lcFieldStructure = lcFieldStructure + '(' + Transform ( tnFieldDecimal ) + ')'

				Else && tcFieldType == 'B'
					lcFieldStructure = lcFieldStructure + ',' + Transform ( tnFieldDecimal ) + ')'

				Endif && tcFieldType == 'B'

			Endif && && Empty ( tnFieldDecimal )

			If tlFieldNull
				lcFieldStructure = lcFieldStructure + ' NULL '


			Else && tlFieldNull
				lcFieldStructure = lcFieldStructure + ' NOT NULL '

			Endif && tlFieldNull

			If ! Empty ( tuFieldDefault )
				lcFieldStructure = lcFieldStructure + ' DEFAULT ' + Transform ( tuFieldDefault )

			Endif && ! Empty ( tuFieldDefault )

			If tlFieldCPTrans
				lcFieldStructure = lcFieldStructure + ' NOCPTRANS '

			Endif && tlFieldCPTrans

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFieldName, tcFieldType, tnFieldWidth, tnFieldDecimal, tlFieldNull, tlFieldCPTrans, tuFieldDefault
			THROW_EXCEPTION

		Endtry

		Return lcFieldStructure

	Endfunc && GetFieldStructure

	Dimension GetProp_COMATTRIB[ 5 ]
	GetProp_COMATTRIB[ 1 ] = 0
	GetProp_COMATTRIB[ 2 ] = 'Devuelve el valor de una propiedad de un cursor o el valor predeterminado.'
	GetProp_COMATTRIB[ 3 ] = 'GetProp'
	GetProp_COMATTRIB[ 4 ] = 'Variant'
	* GetProp_COMATTRIB[ 5 ] = 2

	* GetProp
	* Devuelve el valor de una propiedad de un cursor o el valor predeterminado.
	Function GetProp( tcProperty As String, tuAlias As Variant, tuDefault As Variant ) As Variant HelpString 'Devuelve el valor de una propiedad de un cursor o el valor predeterminado.'

		Local loErr As Object, ;
			luret As Variant
		Try
			luret = CursorGetProp( tcProperty, tuAlias )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcProperty, tuAlias, tuDefault
			luret  = tuDefault

		Endtry

		Return luret

	Endfunc && CursorGetProp

	Dimension GetUpdaTableFieldList_COMATTRIB[ 5 ]
	GetUpdaTableFieldList_COMATTRIB[ 1 ] = 0
	GetUpdaTableFieldList_COMATTRIB[ 2 ] = 'Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla.'
	GetUpdaTableFieldList_COMATTRIB[ 3 ] = 'GetUpdaTableFieldList'
	GetUpdaTableFieldList_COMATTRIB[ 4 ] = 'String'
	* GetUpdaTableFieldList_COMATTRIB[ 5 ] = 2

	* GetUpdaTableFieldList
	* Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla
	* Si tlAssign=.T., entonces genera la tupla "tcTableName.cFieldName = tcAlias.cFieldName"
	Function GetUpdaTableFieldList ( tcTableName As String, tcAlias As String, tcExcludeFieldList As String, tlAssign As Boolean ) As String HelpString 'Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla.'

		Local laFields[1], ;
			lcCommand As String, ;
			lcField As String, ;
			lcFieldList As String, ;
			liIdx As Integer, ;
			llInList As Boolean, ;
			lnLen As Integer, ;
			loErr As Exception

		Try

			lcCommand   = ''
			lcFieldList = ''

			If Empty ( tcAlias )
				tcAlias = ''

			Endif && Empty ( tcAlias )

			If ! Empty ( tcAlias )
				tcAlias = tcAlias + '.'

			Endif && ! Empty ( tcAlias )

			If Empty ( tcExcludeFieldList )
				tcExcludeFieldList = '_&$&_'

			Endif && Empty ( tcExcludeFieldList )

			tcExcludeFieldList = Lower ( tcExcludeFieldList )

			For liIdx = 1 To Afields ( laFields, tcTableName )
				lcField = laFields[ liIdx, 1 ]

				TEXT To lcCommand Noshow Textmerge Pretext 15
					InList( '<<Lower( lcField )>>', '<<tcExcludeFieldList>>' )
				ENDTEXT

				llInList = &lcCommand.

				If ! llInList
					If tlAssign
						TEXT To lcFieldList Noshow Textmerge Pretext 15 Additive
						,<<lcField>> = <<tcAlias>><<lcField>>
						ENDTEXT

					Else && tlAssign
						TEXT To lcFieldList Noshow Textmerge Pretext 15 Additive
						,<<tcAlias>><<lcField>>
						ENDTEXT

					Endif && tlAssign

				Endif && ! llInList

			Endfor

			lcFieldList = Substr ( lcFieldList, 2 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcTableName, tcAlias, tcExcludeFieldList, tlAssign
			THROW_EXCEPTION

		Endtry

		Return lcFieldList

	Endfunc && GetUpdaTableFieldList

	Dimension GetValue_COMATTRIB[ 5 ]
	GetValue_COMATTRIB[ 1 ] = 0
	GetValue_COMATTRIB[ 2 ] = 'Devuelve una cadena con la estructura del cursor.'
	GetValue_COMATTRIB[ 3 ] = 'GetValue'
	GetValue_COMATTRIB[ 4 ] = 'String'
	* GetValue_COMATTRIB[ 5 ] = 1

	*
	* GetValue
	* Devuelve el valor del parametro solicitado.
	Function GetValue ( tcField As String, tcTable As String, tuDefault As Variant, tcFolder As String ) As Variant HelpString 'Devuelve el valor del parametro solicitado'

		Local lcAlias As String, ;
			lcCommand As String, ;
			llCloseBeforeLeaving As Boolean, ;
			llDone As Boolean, ;
			loErr As Exception, ;
			luReturn As Variant
		*:Global DRVA

		External Array DRVA

		Try


			llDone               = .F.
			lcCommand            = ''
			llCloseBeforeLeaving = .F.

			lcAlias = Alias()

			If Empty ( tcTable )
				tcTable = 'ar0Setup'

			Endif && Empty( tcTable )

			If ! Used ( tcTable )
				Try

					If Empty ( tcFolder )
						If Vartype ( DRVA ) # 'C'
							DRVA = ''

						Endif && Vartype( DRVA ) # "C"

						tcFolder = DRVA

					Endif && Empty( tcFolder )


					TEXT To lcCommand Noshow Textmerge Pretext 15
						Use '<<Trim( tcFolder )>><<tcTable>>' In 0 Shared
					ENDTEXT

					&lcCommand.

					llCloseBeforeLeaving = .T.

				Catch To loErr
					DEBUG_CLASS_EXCEPTION

					If loErr.ErrorNo == 1
						luReturn = tuDefault
						llDone   = .T.

					Else
						THROW_EXCEPTION

					Endif && loErr.ErrorNo == 1

				Endtry

			Endif && ! Used( tcTable )

			If ! llDone
				lcCommand = ''

				Try

					luReturn = Evaluate ( tcTable + '.' + tcField )

				Catch To loErr
					If Vartype ( tuDefault ) # 'U'
						luReturn = tuDefault
						llDone   = .T.

					Else && Vartype( tuDefault ) # 'U'
						THROW_EXCEPTION

					Endif && Vartype( tuDefault ) # 'U'

				Endtry

			Endif && ! llDone

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcField, tcTable, tuDefault, tcFolder
			THROW_EXCEPTION

		Finally
			If Used ( lcAlias )
				Select Alias ( lcAlias )

			Endif

			If llCloseBeforeLeaving
				Use In Select ( tcTable )

			Endif

		Endtry

		Return luReturn

	Endproc && GetValue

	Dimension InsertFromCursor_COMATTRIB[ 5 ]
	InsertFromCursor_COMATTRIB[ 1 ] = 0
	InsertFromCursor_COMATTRIB[ 2 ] = 'Inserta un registro desde otro cursor.'
	InsertFromCursor_COMATTRIB[ 3 ] = 'InsertFromCursor'
	InsertFromCursor_COMATTRIB[ 4 ] = 'Void'
	* InsertFromCursor_COMATTRIB[ 5 ] = 1

	* InsertFromCursor
	* Inserta un registro desde otro cursor.
	Procedure InsertFromCursor ( tcFromCursor As String, tcToCursor As String ) As Void HelpString 'Inserta un registro desde otro cursor.'

		Local lcAlias As String, ;
			loAlias As Object, ;
			loErr As Exception, ;
			loValues As Object

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Inserta un registro desde otro cursor
			 *:Project:
			 CMSI
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Lunes 12 de Febrero de 2007 ( 16:13:23 )
			 *:ModiSummary:
			 R/0001 -
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try

			* lcAlias = Alias()
			loAlias = m.Environment.SaveArea()
			If Empty ( m.tcFromCursor )
				Error 'Debe indicar el nombre del cursor origen.'

			Endif && Empty( m.tcFromCursor )

			If Empty ( m.tcToCursor )
				tcToCursor = Alias()

			Endif && Empty( m.tcToCursor )

			* Si no existe el cursor destino, lo crea
			If ! Used ( m.tcToCursor )
				This.CreateFromCursor ( m.tcToCursor, m.tcFromCursor )

			Endif && ! Used( m.tcToCursor )

			* Select Alias( m.tcToCursor )

			loValues = This.GetFieldsValues ( m.tcFromCursor )

			Insert Into ( m.tcToCursor ) From Name m.loValues

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFromCursor, tcToCursor
			THROW_EXCEPTION

		Finally
			*!*	If Used ( m.lcAlias )
			*!*		Select Alias ( m.lcAlias )
			*!*	Endif && Used( m.lcAlias )
			loAlias  = Null
			loValues = Null

		Endtry

	Endproc && InsertFromCursor

	Dimension IsCursor_COMATTRIB[ 5 ]
	IsCursor_COMATTRIB[ 1 ] = 0
	IsCursor_COMATTRIB[ 2 ] = 'Devuleve .T. si el alias dado es un cursor y no una tabla.'
	IsCursor_COMATTRIB[ 3 ] = 'IsCursor'
	IsCursor_COMATTRIB[ 4 ] = 'Boolean'
	* IsCursor_COMATTRIB[ 5 ] = 0

	* IsCursor
	* Devuleve .T. si el alias dado es un cursor y no una tabla.
	Function IsCursor ( tcAlias As String ) As Boolean HelpString 'Devuleve .T. si el alias dado es un cursor y no una tabla.'

		Local llRet As Boolean, ;
			loErr As Exception
		Try

			llRet = Vartype ( m.tcAlias ) == 'C' And Used ( m.tcAlias ) And CursorGetProp ( 'SourceType', m.tcAlias ) == 3 And Upper ( Justext ( CursorGetProp ( 'SourceName', m.tcAlias ) ) ) == 'TMP'

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcAlias
			THROW_EXCEPTION

		Endtry

		Return llRet

	Endfunc && IsCursor

	Dimension PackCursor_COMATTRIB[ 5 ]
	PackCursor_COMATTRIB[ 1 ] = 0
	PackCursor_COMATTRIB[ 2 ] = 'Elimina los registros marcados como borrados de un cursor.'
	PackCursor_COMATTRIB[ 3 ] = 'PackCursor'
	PackCursor_COMATTRIB[ 4 ] = 'Void'
	* PackCursor_COMATTRIB[ 5 ] = 1

	* PackCursor
	* Elimina los registros marcados como borrados de un cursor.
	Procedure PackCursor ( tcCursorName As String ) As Void HelpString 'Elimina los registros marcados como borrados de un cursor.'

		Local lcCommand As String, ;
			lcTempCursor As String, ;
			loAlias As Object, ;
			loErr As Exception

		Try

			loAlias = m.Environment.SaveArea()

			If Empty ( tcCursorName )
				tcCursorName = Alias()

			Endif

			lcTempCursor = Sys ( 2015 )

			TEXT To lcCommand Noshow Textmerge Pretext 15
				Select  *
					From <<tcCursorName>> With (Buffering = .T.)
					Where ! Deleted()
					Into Cursor <<lcTempCursor>>

			ENDTEXT

			&lcCommand.

			Use In Select ( tcCursorName )

			TEXT To lcCommand Noshow Textmerge Pretext 15
				Select  *
					From <<lcTempCursor>> With (Buffering = .T.)
					Into Cursor <<tcCursorName>> Readwrite
			ENDTEXT

			&lcCommand.

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCursorName
			THROW_EXCEPTION

		Finally
			Use In Select ( lcTempCursor )
			* Select Alias ( tcCursorName )
			loAlias = Null

		Endtry

	Endproc && PackCursor

	Dimension RestRecNo_COMATTRIB[ 5 ]
	RestRecNo_COMATTRIB[ 1 ] = 0
	RestRecNo_COMATTRIB[ 2 ] = 'Posiciona el puntero del cursor en el registro dado.'
	RestRecNo_COMATTRIB[ 3 ] = 'RestRecNo'
	RestRecNo_COMATTRIB[ 4 ] = 'Void'
	* RestRecNo_COMATTRIB[ 5 ] = 1

	* RestRecNo
	* Posiciona el puntero del cursor en el registro dado.
	Procedure RestRecNo ( tnRecno As Number, tcAlias As String ) As Void HelpString 'Posiciona el puntero del cursor en el registro dado.'

		Local loAlias As Object, ;
			loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Posiciona el puntero del cursor en el registro dado.
			 Reemplazo seguro del GO ( en conjunto con SaveRecNo() )
			 *:Project:
			 *:Autor:
			 Martin Salias - Modificada por Ruben Rovira
			 *:Date:
			 Mayo 1997 / Marzo 2004
			 *:Parameters:
			 nRecno = Número de registro
			 tcAlias = Alias (opcional)
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 SaveRecNo()
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try

			loAlias = m.Environment.SaveArea()

			If Empty ( m.tcAlias )
				tcAlias = Alias()

			Endif && Empty( m.tcAlias )

			If m.tnRecno # Recno ( m.tcAlias )
				If m.tnRecno = 0
					Go Bottom In ( m.tcAlias )

				Else
					Try
						Go m.tnRecno In ( m.tcAlias )

					Catch To loErr
						Go Bottom In ( m.tcAlias )

					Endtry

				Endif && tnRecno = 0

			Endif && tnRecno # Recno( m.tcAlias )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnRecno, tcAlias
			THROW_EXCEPTION

		Finally
			loAlias = Null

		Endtry

	Endproc && RestRecNo

	Dimension SaveRecno_COMATTRIB[ 5 ]
	SaveRecno_COMATTRIB[ 1 ] = 0
	SaveRecno_COMATTRIB[ 2 ] = 'Devuelve el número de registro actual ( 0 si es Eof() ).'
	SaveRecno_COMATTRIB[ 3 ] = 'SaveRecno'
	SaveRecno_COMATTRIB[ 4 ] = 'String'
	* SaveRecno_COMATTRIB[ 5 ] = 1

	* SaveRecNo
	* Devuelve el número de registro actual ( 0 si es Eof() ).
	Function SaveRecno ( tcAlias As String ) As Number  HelpString 'Devuelve el número de registro actual ( 0 si es Eof() ).'

		Local lnRecno As Number, ;
			loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Devuelve el número de registro actual ( 0 si es Eof() ).
			 *:Project:
			 *:Autor:
			 Martin Salias - Modificada por Ruben Rovira
			 *:Date:
			 Mayo 1997 / Marzo 2004
			 *:Parameters:
			 tcAlias = Alias (opcional)
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 RestRecNo()
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try

			If Empty ( m.tcAlias )
				tcAlias = Alias()

			Endif && Empty( m.tcAlias )

			lnRecno = Iif ( Eof ( m.tcAlias ), 0, Recno ( m.tcAlias ) )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcAlias
			THROW_EXCEPTION

		Endtry

		Return m.lnRecno

	Endfunc && SaveRecNo

	Dimension SetRecordState_COMATTRIB[ 5 ]
	SetRecordState_COMATTRIB[ 1 ] = 0
	SetRecordState_COMATTRIB[ 2 ] = 'Setea todos los campos de un registro.'
	SetRecordState_COMATTRIB[ 3 ] = 'SetRecordState'
	SetRecordState_COMATTRIB[ 4 ] = 'Void'
	* SetRecordState_COMATTRIB[ 5 ] = 2

	* SetRecordState
	* Setea todos los campos de un registro.
	Procedure SetRecordState ( tnFieldState As Integer, tcTableAlias As String ) As Void HelpString 'Setea todos los campos de un registro.'

		Local laFields[1], ;
			lcAlias As String, ;
			liIdx As Integer, ;
			loAlias As Object, ;
			loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Setea todos los campos de un registro
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Viernes 10 de Abril de 2009 (10:58:57)
			 *:ModiSummary:
			 R/0001 -
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try

			* lcOldAlias = Alias()
			loAlias = m.Environment.SaveArea()
			If ! Empty ( tcTableAlias )
				lcAlias = Alias()

			Else && ! Empty ( tcTableAlias )
				lcAlias = tcTableAlias

			Endif && ! Empty( tcTableAlias )

			For liIdx = 1 To Afields ( laFields, lcAlias )
				Setfldstate ( liIdx, tnFieldState, lcAlias )

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnFieldState, tcTableAlias
			THROW_EXCEPTION

		Finally
			*!*	If Used ( lcOldAlias )
			*!*		Select Alias ( lcOldAlias )

			*!*	Endif && Used( lcOldAlias )
			loAlias = Null

		Endtry

	Endproc && SetRecordState

	Dimension UpdateFromCursor_COMATTRIB[ 5 ]
	UpdateFromCursor_COMATTRIB[ 1 ] = 0
	UpdateFromCursor_COMATTRIB[ 2 ] = 'Actualiza un registro de un cursor desde otro cursor.'
	UpdateFromCursor_COMATTRIB[ 3 ] = 'UpdateFromCursor'
	UpdateFromCursor_COMATTRIB[ 4 ] = 'Void'
	* UpdateFromCursor_COMATTRIB[ 5 ] = 1

	* UpdateFromCursor
	* Actualiza un registro de un cursor desde otro cursor.
	Procedure UpdateFromCursor ( tcFromCursor As String, tcToCursor As String ) As Void HelpString 'Actualiza un registro de un cursor desde otro cursor.'

		Local lcAlias As String, ;
			loAlias As Object, ;
			loErr As Object, ;
			loValues As Object

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Actualiza un registro desde otro cursor
			 *:Project:
			 CMSI
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Lunes 12 de Febrero de 2007 (16:14:24)
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try
			* lcAlias = Alias()
			loAlias = m.Environment.SaveArea()
			If Empty ( m.tcFromCursor )
				Error 'Debe indicar el nombre del cursor origen.'

			Endif && Empty( tcFromCursor )

			If Empty ( m.tcToCursor )
				tcToCursor = Alias()

			Endif && Empty( m.tcToCursor )

			Select ( Alias ( m.tcFromCursor ) )
			Scatter Memo Name loValues

			Select ( Alias ( m.tcToCursor ) )
			Gather Memo Name loValues

			*!*	lnLen = Afields( laFields )

			*!*	For i = 1 To lnLen
			*!*	    Try
			*!*	        lcField = laFields[ i, 1 ]
			*!*	        luValue = Evaluate( tcFromCursor + "." + lcField )
			*!*	        Replace ( lcField ) With  luValue

			*!*	    Catch To loErr
			*!*	        *!*				Local loError As UserTierError Of "fw\Actual\ErrorHandler\UserTierError.prg"
			*!*	        *!*				loError = Newobject( "UserTierError", "UserTierError.prg" )
			*!*	        *!*				loError.Process( loErr )
			*!*	        *!*				TEXT To lcCommand NoShow TextMerge
			*!*	        *!*				<<oErr.Message>>                    *!*
			*!*	        *!*				lcField = laFields[ <<i>>, 1 ]
			*!*	        *!*				luValue = Evaluate( <<tcFromCursor>> + "." + <<lcField>> )
			*!*	        *!*				Replace <<lcField>> with  <<luValue>>
			*!*	        *!*				-----------------------------------------------------------
			*!*	        *!*				ENDTEXT
			*!*	        *!*				Strtofile( Chr(13) + lcCommand, "_UpdateFromCursor.prg", 1 )

			*!*	    Endtry

			*!*	Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFromCursor, tcToCursor
			THROW_EXCEPTION

		Finally
			*!*	If Used ( m.lcAlias )
			*!*		Select Alias ( m.lcAlias )

			*!*	Endif
			loAlias  = Null
			loValues = Null

		Endtry

	Endproc && UpdateFromCursor

	Dimension ZapCursor_COMATTRIB[ 5 ]
	ZapCursor_COMATTRIB[ 1 ] = 0
	ZapCursor_COMATTRIB[ 2 ] = 'Elimina todos los registros de un cursor.'
	ZapCursor_COMATTRIB[ 3 ] = 'ZapCursor'
	ZapCursor_COMATTRIB[ 4 ] = 'Void'
	* ZapCursor_COMATTRIB[ 5 ] = 1

	* ZapCursor
	* Elimina todos los registros de un cursor.
	Procedure ZapCursor ( tcCursorName As String ) As Void HelpString 'Elimina todos los registros de un cursor.'

		Local lcCommand As String, ;
			loAlias As Object, ;
			loErr As Exception
		Try

			loAlias = m.Environment.SaveArea()

			If Empty ( tcCursorName )
				tcCursorName = Alias()

			Endif && Empty( tcCursorName )

			TEXT To lcCommand Noshow Textmerge Pretext 15
				Delete From <<tcCursorName>>
			ENDTEXT

			&lcCommand.

			This.PackCursor ( tcCursorName )


		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCursorName
			THROW_EXCEPTION

		Finally
			* Select Alias ( tcCursorName )
			loAlias = Null

		Endtry

	Endproc && ZapCursor

Enddefine && CursorNameSpace