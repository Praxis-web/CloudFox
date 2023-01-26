*!* ///////////////////////////////////////////////////////
*!* Class.........: ColReportOrderBy
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Coleccion de elementos Header/Detail que forman el reporte
*!* Date..........: Lunes 10 de Diciembre de 2007 (13:04:37)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#INCLUDE "Fw\comunes\Include\Praxis.h"
#INCLUDE "FW\Tieradapter\Include\TA.h"


Define Class ColReportOrderBy As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg" 

	#If .F.
		Local This As ColReportOrderBy Of "Fw\comunes\Prg\ColReportOrderBy.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="indexon" type="method" display="IndexOn" />] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Devuelve un objeto ColumnLayautObject
	*!* Date..........: Martes 18 de Diciembre de 2007 (11:21:08)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure New( cName As String ) As Collection;
			HELPSTRING "Devuelve un objeto ColumnLayautObject"


		Local loOrderByField As OrderByField Of "Fw\comunes\Prg\ColReportOrderBy.prg"

		Try

			loOrderByField = Createobject( "OrderByField" )
			If !Empty( cName )
				This.AddItem( loOrderByField, Lower( cName ) )
				loOrderByField.FieldName = cName 
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return loOrderByField

	Endproc
	*!*
	*!* END PROCEDURE New
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: IndexOn
	*!* Description...: Ordena la colección en base a una propiedad de sus elementos
	*!* Date..........: Lunes 22 de Octubre de 2007 (13:19:42)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: OOReport Builder
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure IndexOn( cIndexProperty As String ) As Boolean;
			HELPSTRING "Ordena la colección en base a una propiedad de sus elementos"


		Try

			If Empty( cIndexProperty )
				cIndexProperty = "IndexTab"
			Endif

			Local loCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg",;
				loBkUpCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg" 
			Local loObj As Object
			Local i As Integer
			Local llOk As Boolean

			llOk = .T.

			loCol = NewObject( "PrxCollection", "PrxBaseLibrary.prg" )
			loBkUpCol = NewObject( "PrxCollection", "PrxBaseLibrary.prg" )

			* BackUp
			For i = 1 To This.Count
				loObj = This.Item( i )
				loBkUpCol.AddItem( loObj, Lower( loObj.Name ) )
			Endfor

			i = -1

			Do While i <> 0
				i = This.GetMin()
				If !Empty( i )
					loObj = This.Item( i )
					loCol.AddItem( loObj, Lower( loObj.Name ) )
					This.Remove( i )
				Endif
			Enddo


			For i = 1 To This.Count
				loObj = This.Item( i )
				loCol.AddItem( loObj, Lower( loObj.Name ) )
			Endfor

			This.Remove( -1 )

			For i = 1 To loCol.Count
				loObj = loCol.Item( i )
				This.AddItem( loObj, Lower( loObj.Name ) )
			Endfor


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )

			Try

				This.Remove( -1 )
				For i = 1 To loBkUpCol.Count
					loObj = loBkUpCol.Item( i )
					This.AddItem( loObj, Lower( loObj.Name ) )
				Endfor


			Catch To oErr


			Finally

			Endtry


		Finally
			loBkUpCol.Remove( -1 )
			loBkUpCol = Null

			loCol.Remove( -1 )
			loCol = Null

			loObj = Null

		Endtry

		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE IndexOn
	*!*
	*!* ///////////////////////////////////////////////////////


Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColReportOrderBy
*!*
*!* ///////////////////////////////////////////////////////



*!* ///////////////////////////////////////////////////////
*!* Class.........: OrderByField
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Objeto que representa al campo por el que se va a ordenar la consulta
*!* Date..........: Lunes 10 de Diciembre de 2007 (15:31:53)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class OrderByField As Session

	#If .F.
		Local This As OrderByField Of "Fw\comunes\Prg\ColReportOrderBy.prg"
	#Endif

	*!* Número de orden del elemento
	TabIndex = 0

	Visible = .T.

	*!* Indica si el objeto ha sido seleccionado
	Selected = .F.

	DataSession = SET_DEFAULT

	*!* Contiene el nombre que se mostrará al usuario
	DisplayValue = ""

	*!* Nombre del campo en la tabla de origen
	FieldName = ""

	*!* Nombre de la tabla en el origen de datos
	TableName = ""


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="selected" type="property" display="Selected" />] + ;
		[<memberdata name="visible" type="property" display="Visible" />] + ;
		[<memberdata name="tabindex" type="property" display="TabIndex" />] + ;
		[<memberdata name="tabindex_assign" type="method" display="TabIndex_Assign" />] + ;
		[<memberdata name="displayvalue" type="property" display="DisplayValue" />] + ;
		[<memberdata name="displayvalue_access" type="method" display="DisplayValue_Access" />] + ;
		[<memberdata name="tablename" type="property" display="TableName" />] + ;
		[<memberdata name="fieldname" type="property" display="FieldName" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: TabIndex_Assign
	*!* Date..........: Lunes 10 de Diciembre de 2007 (13:30:50)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure TabIndex_Assign( uNewValue )

		If uNewValue <= 0
			Error "Valor no válido en la propiedad TabIndex de " + This.Name
		Endif

		This.TabIndex = uNewValue

	Endproc
	*!*
	*!* END PROCEDURE TabIndex_Assign
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: DisplayValue_Access
	*!* Date..........: Lunes 24 de Diciembre de 2007 (12:04:40)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure DisplayValue_Access()

		If Empty( This.DisplayValue )
			This.DisplayValue = This.Name
		Endif
		Return This.DisplayValue

	Endproc
	*!*
	*!* END PROCEDURE DisplayValue_Access
	*!*
	*!* ///////////////////////////////////////////////////////



Enddefine
*!*
*!* END DEFINE
*!* Class.........: OrderByField
*!*
*!* ///////////////////////////////////////////////////////