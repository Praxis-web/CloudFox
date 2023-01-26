#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'

* oReportOrder
* Criterio de orden para un reporte.
Define Class oReportOrder As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

	#If .F.
		Local This As oReportOrder Of 'Tools\DataDictionary\prg\oReportOrder.prg'
	#Endif

	oField = Null

	* Número de orden del elemento
	nTabIndex = 0

	* Indica si el criterio esta visible
	lVisible = .T.

	* Indica si el objeto ha sido seleccionado
	lSelected = .F.

	* Contiene el nombre que se mostrará al usuario
	cDisplayValue = ''

	* Nombre del campo en la tabla de origen
	cFieldName = ''

	* Nombre de la tabla en el origen de datos
	cTableName = ''

	Protected m._MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lselected" type="property" display="lSelected" />] + ;
		[<memberdata name="lvisible" type="property" display="lVisible" />] + ;
		[<memberdata name="ntabindex" type="property" display="nTabIndex" />] + ;
		[<memberdata name="ntabindex_assign" type="method" display="nTabIndex_Assign" />] + ;
		[<memberdata name="cdisplayvalue" type="property" display="cDisplayValue" />] + ;
		[<memberdata name="cdisplayvalue_access" type="method" display="cDisplayValue_Access" />] + ;
		[<memberdata name="ctablename" type="property" display="cTableName" />] + ;
		[<memberdata name="cfieldname" type="property" display="cFieldName" />] + ;
		[<memberdata name="ofield" type="property" display="oField" />] + ;
		[</VFPData>]

	* This_Access
	Protected Function This_Access ( tcMemberName As String ) As Object
		Local loRet As Object

		loRet = This

		If ! Pemstatus ( This, m.tcMemberName, 5 )
			loField = This.oField
			If Vartype ( loField ) == 'O' And Pemstatus ( loField, m.tcMemberName, 5 )
				loRet = loField

			Endif && Vartype( .oField ) = 'O' And Pemstatus( .oField, m.tcMemberName, 5 )

		Endif && ! Pemstatus( This, m.tcMemberName, 5 )

		Return loRet

	Endfunc && This_Access

	* cDisplayValue_Access
	Protected Function cDisplayValue_Access() As String

		If Empty ( This.cDisplayValue )
			This.cDisplayValue = This.oField.Caption

		Endif && Empty( This.cDisplayValue )

		Return This.cDisplayValue

	Endfunc && cDisplayValue_Access

	* cTableName_Access
	Protected Function cTableName_Access() As String

		If Empty ( This.cTableName )
			This.cTableName = This.oField.oParent.Name

		Endif && Empty( This.cTableName )

		Return This.cTableName

	Endfunc && cTableName_Access

	* cFieldName_Access
	Protected Function cFieldName_Access() As String

		If Empty ( This.cFieldName )
			This.cFieldName = This.oField.Name

		Endif && Empty( This.cFieldName )

		Return This.cFieldName

	Endfunc && cFieldName_Access

	* nTabIndex_Assign
	Protected Procedure nTabIndex_Assign ( tnNewValue As Integer ) As Void

		Local loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

		Try
			If Vartype ( m.tnNewValue ) # 'N'
				Error 'Tipo de dato no válido en la propiedad nTabIndex de ' + This.Name

			Endif && Vartype( uNewValue ) # 'N'

			If m.tnNewValue <= 0
				Error 'Valor no válido en la propiedad nTabIndex de ' + This.Name

			Endif && uNewValue <= 0

			This.nTabIndex = m.tnNewValue

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError = Null

		Endtry

	Endproc && nTabIndex_Assign

Enddefine && oReportOrder