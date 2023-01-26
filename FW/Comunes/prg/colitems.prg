* Tengo 3 cursores
* - La tabla de detalle que está definida en la dt del comprobante, referenciada
*	en la grilla como cmpCuerpo.ChildCursorName.
* - La tabla asociada al RecordSource de la grilla, necesaria porque ChildCursorName
*	está con buffering, y tenía problemas con ciertas operaciones.
* - La tabla cmpCuerpo.EditingCursorName, que contiene un único registro, que es
*	el que se edita.


#INCLUDE "FW\Tieradapter\Include\TA.h"

*/ ----------------------------------
*/ Begin Test

Set Step On
Set Safety Off

Try

	Local oItems As colItems Of "FW\Comunes\Prg\colItems.prg"
	Local oItem As oItem Of "FW\Comunes\Prg\colItems.prg"

	Local item1 As String,;
		Item2 As String

	oItems = Createobject( "colItems", Set("Datasession") )

	oItem = oItems.New()
	Edit

	If oItems.Save( oItem )
		item1 = oItem.UniqueKey
	Endif

	oItem = oItems.New()
	Edit

	If oItems.Save( oItem )
		Item2 = oItem.UniqueKey
	Endif

	Close Databases All

	If !Empty( item1 )
		oItems.Open( item1 )
		Edit

	Endif

	If !Empty( Item2 )
		oItems.Open( Item2 )
		Edit

	Endif


Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )


Finally
	oItem = Null
	oItems = Null
	Close Databases All

Endtry





*/ End Test
*/ ---------------------------------


*!* ///////////////////////////////////////////////////////
*!* Class.........: colItems
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Colección de Items de la clase Comprobante
*!* Date..........: Viernes 21 de Marzo de 2008 (22:55:31)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class colItems As Collection

	#If .F.
		Local This As colItems Of "FW\Comunes\Prg\colItems.prg"
	#Endif


	*!*
	DataSessionId = 0

	*!* Referencia a la colección GridLayout
	oColGridLayout = Null


	*!* Nombre del cursor que contiene el registro sobre el que se edita el item
	EditingCursorName = "EditingCursorName" + Sys(2015)

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="delete" type="method" display="Delete" />] + ;
		[<memberdata name="datasessionid" type="property" display="DataSessionId" />] + ;
		[<memberdata name="save" type="method" display="Save" />] + ;
		[<memberdata name="open" type="method" display="Open" />] + ;
		[<memberdata name="setgridlayout" type="method" display="SetGridLayout" />] + ;
		[<memberdata name="ocolgridlayout" type="property" display="oColGridLayout" />] + ;
		[<memberdata name="ocolgridlayout_access" type="method" display="oColGridLayout_Access" />] + ;
		[<memberdata name="editingcursorname" type="property" display="EditingCursorName" />] + ;
		[<memberdata name="clone" type="method" display="Clone" />] + ;
		[<memberdata name="initialize" type="method" display="Initialize" />] + ;
		[<memberdata name="getcolgridlayout" type="method" display="GetColGridLayout" />] + ;
		[<memberdata name="getnewitem" type="method" display="GetNewItem" />] + ;
		[<memberdata name="obtenereditingcursorname" type="method" display="ObtenerEditingCursorName" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Initialize
	*!* Description...:
	*!* Date..........: Domingo 23 de Marzo de 2008 (13:48:10)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Initialize( nDataSessionId As Integer ) As Void


		Try
			Local llOk As Boolean

			llOk = Vartype( nDataSessionId ) == "N"

			Assert llOk Message "Error de Tipo al pasar el DataSessionId a la colección Items"

			This.DataSessionId = nDataSessionId


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry


	Endproc
	*!*
	*!* END PROCEDURE Initialize
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ObtenerEditingCursorName
	*!* Description...:
	*!* Date..........: Jueves 27 de Marzo de 2008 (14:59:04)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure ObtenerEditingCursorName(  ) As String

		Return This.EditingCursorName 

	Endproc
	*!*
	*!* END PROCEDURE ObtenerEditingCursorName
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Clone
	*!* Description...: Devuelve una copia de un elemento
	*!* Date..........: Sábado 22 de Marzo de 2008 (12:24:12)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Clone( nIndex As Integer ) As Object;
			HELPSTRING "Devuelve una copia de un elemento"


		Try
			Local loSource As oItem Of "FW\Comunes\Prg\colItems.prg",;
				loClone As oItem Of "FW\Comunes\Prg\colItems.prg"

			Local lcProperty As String

			loSource = This.Item( nIndex )

			loClone = This.New()

			loClone.UniqueKey = loSource.UniqueKey

			Amembers( laProperties, loSource.oRecord )

			For Each lcProperty In laProperties
				loClone.oRecord.&lcProperty = loSource.oRecord.&lcProperty

			Endfor


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally
			loSource = Null

		Endtry

		Return loClone

	Endproc
	*!*
	*!* END PROCEDURE Clone
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetColGridLayout
	*!* Description...: Devuelve una referencia a la colección GridLayout
	*!* Date..........: Lunes 24 de Marzo de 2008 (20:52:51)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetColGridLayout() As Object;
			HELPSTRING "Devuelve una referencia a la colección GridLayout"


		Try

			If IsEmpty( This.oColGridLayout )
				This.oColGridLayout = Newobject( "colGridLayout",  ;
					"colGridLayout.prg" )

				This.SetGridLayout()
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return This.oColGridLayout

	Endproc
	*!*
	*!* END PROCEDURE GetColGridLayout
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SetGridLayout
	*!* Description...: Setea el layout de la grilla donde se mostraran lo items
	*!* Date..........: Sábado 22 de Marzo de 2008 (10:49:31)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure SetGridLayout(  ) As Void;
			HELPSTRING "Setea el layout de la grilla donde se mostraran lo items"


		Try



		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry


	Endproc
	*!*
	*!* END PROCEDURE SetGridLayout
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Open
	*!* Description...: Devuelve una referencia al item seleccionado
	*!* Date..........: Sábado 22 de Marzo de 2008 (09:40:47)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Open( cUniqueKey As String ) As Object;
			HELPSTRING "Devuelve una referencia al item seleccionado"


		Try

			Local loItem As oItem Of "FW\Comunes\Prg\colItems.prg"
			Local i As Integer

			Assert Vartype( cUniqueKey ) == "C" Message "Error de Tipo al pasar el cUniqueKey del Item"

			i = This.GetKey( Lower( cUniqueKey ))

			If Empty( i )
				Error [El item ] + cUniqueKey + [ no existe en la colección]
			Endif


			* En realidad, devuelve una copia, para no modificar el item
			* hasta que se confirme con Save()
			loItem = This.Clone( i )

			Select Alias( loItem.EditingCursorName )
			Zap
			Append Blank

			Gather Name loItem.oRecord Memo

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return loItem

	Endproc
	*!*
	*!* END PROCEDURE Open
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Save
	*!* Description...: Guarda el item en la colección
	*!* Date..........: Sábado 22 de Marzo de 2008 (09:17:13)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Save( oItem As Object ) As Boolean;
			HELPSTRING "Guarda el item en la colección"

		Try

			Local i As Integer
			Local llOk As Boolean

			llOk = .F.

			If oItem.Validate()
				i = This.GetKey( oItem.UniqueKey )

				If !Empty( i )
					This.Remove( i )
				Endif

				This.Add( oItem, oItem.UniqueKey )
				llOk = .T.


			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE Save
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Delete
	*!* Description...: Elimina un Item de la colección
	*!* Date..........: Viernes 21 de Marzo de 2008 (23:05:39)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Delete( oItem As Object ) As Void;
			HELPSTRING "Elimina un Item de la colección"


		Try

			This.Remove( oItem.UniqueKey )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally
			Release oItem
			oItem = Null

		Endtry


	Endproc
	*!*
	*!* END PROCEDURE Delete
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Devuelve una referencia a un nuevo item
	*!* Date..........: Viernes 21 de Marzo de 2008 (23:00:56)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure New( uParam As Variant ) As Object;
			HELPSTRING "Devuelve una referencia a un nuevo item"


		Try

			Local loItem As oItem Of "FW\Comunes\Prg\colItems.prg"

			loItem = This.GetNewItem( uParam )

			Do While !Empty( This.GetKey( loItem.UniqueKey ))
				loItem.UniqueKey = Lower( Sys( 2015 ))
			Enddo

			loItem.DataSessionId = This.DataSessionId
			loItem.EditingCursorName = This.EditingCursorName

			Select Alias( loItem.EditingCursorName )
			Zap
			Append Blank


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return loItem

	Endproc
	*!*
	*!* END PROCEDURE New
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetNewItem
	*!* Description...: Devuelve una nueva instancia de Item
	*!* Date..........: Lunes 24 de Marzo de 2008 (14:35:30)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure GetNewItem( uParam As Variant ) As Object;
			HELPSTRING "Devuelve una nueva instancia de Item"


		Try

			Local loItem As oItem Of "FW\Comunes\Prg\colItems.prg"

			loItem = Createobject("oItem" )


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return loItem

	Endproc
	*!*
	*!* END PROCEDURE GetNewItem
	*!*
	*!* ///////////////////////////////////////////////////////


	*!*		*!* ///////////////////////////////////////////////////////
	*!*		*!* Procedure.....: oColGridLayout_Access
	*!*		*!* Date..........: Sábado 22 de Marzo de 2008 (10:50:58)
	*!*		*!* Author........: Ricardo Aidelman
	*!*		*!* Project.......: Sistemas Praxis
	*!*		*!* -------------------------------------------------------
	*!*		*!* Modification Summary
	*!*		*!* R/0001  -
	*!*		*!*
	*!*		*!*

	*!*		Procedure oColGridLayout_Access()

	*!*			If Vartype( This.oColGridLayout ) <> "O"
	*!*				This.oColGridLayout = Newobject( "colGridLayout",  ;
	*!*					"colGridLayout.prg" )

	*!*				This.SetGridLayout()
	*!*			Endif

	*!*			Return This.oColGridLayout

	*!*		Endproc
	*!*		*!*
	*!*		*!* END PROCEDURE oColGridLayout_Access
	*!*		*!*
	*!*		*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: colItems
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oItem
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Clase item
*!* Date..........: Viernes 21 de Marzo de 2008 (23:14:08)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class oItem As Session

	#If .F.
		Local This As oItem Of "FW\Comunes\Prg\colItems.prg"
	#Endif

	*!* Use Default data session
	DataSession = SET_DEFAULT

	*!* Indica si el ítem está validado
	lValid = .F.

	*!* Indica si el ítem está marcado para borrar
	lDeleted = .T.

	*!* Referencia al objeto donde se mapea el item
	oRecord = Null

	*!* Nombre único del ítem
	UniqueKey = Lower( Sys( 2015 ))

	*!* Nombre del cursor que contiene el registro sobre el que se edita el item
	EditingCursorName = ""




	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="editingcursorname" type="property" display="EditingCursorName" />] + ;
		[<memberdata name="editingcursorname_access" type="method" display="EditingCursorName_Access" />] + ;
		[<memberdata name="uniquekey" type="property" display="UniqueKey" />] + ;
		[<memberdata name="orecord" type="property" display="oRecord" />] + ;
		[<memberdata name="orecord_access" type="method" display="oRecord_Access" />] + ;
		[<memberdata name="ldeleted" type="property" display="lDeleted" />] + ;
		[<memberdata name="lvalid" type="property" display="lValid" />] + ;
		[<memberdata name="validate" type="method" display="Validate" />] + ;
		[<memberdata name="validateitem" type="method" display="ValidateItem" />] + ;
		[<memberdata name="delete" type="method" display="Delete" />] + ;
		[<memberdata name="recover" type="method" display="Recover" />] + ;
		[<memberdata name="calcularimportebruto" type="method" display="CalcularImporteBruto" />] + ;
		[<memberdata name="createrecordstructure" type="method" display="CreateRecordStructure" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CalcularImporteBruto
	*!* Description...: Devuelve le importe bruto del item
	*!* Date..........: Viernes 21 de Marzo de 2008 (23:41:30)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure CalcularImporteBruto(  ) As Number;
			HELPSTRING "Devuelve le importe bruto del item"


		Try
			Local lnImporte As Number

			lnImporte = 0


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return lnImporte

	Endproc
	*!*
	*!* END PROCEDURE CalcularImporteBruto
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Recover
	*!* Description...: Recupera un Item marcado para borrar
	*!* Date..........: Viernes 21 de Marzo de 2008 (23:39:20)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Recover(  ) As Boolean;
			HELPSTRING "Recupera un Item marcado para borrar"


		Try
			Local llOk As Boolean

			llOk = .T.
			This.lDeleted = .F.



		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE Recover
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Delete
	*!* Description...: Marca el ítem para borrar
	*!* Date..........: Viernes 21 de Marzo de 2008 (23:37:41)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Delete(  ) As Boolean;
			HELPSTRING "Marca el ítem para borrar"


		Try
			Local llOk As Boolean

			llOk = .T.
			This.lDeleted = .T.

		Catch To oErr
			llOk = .F.
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE Delete
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Validate
	*!* Description...: Valida el item
	*!* Date..........: Viernes 21 de Marzo de 2008 (23:29:11)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Validate( ) As Boolean;
			HELPSTRING "Valida el item"


		Local llValid As Boolean

		Try

			Select Alias( This.EditingCursorName )
			Scatter Memo Name This.oRecord

			llValid = This.ValidateItem( This.oRecord )


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return llValid

	Endproc
	*!*
	*!* END PROCEDURE Validate
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ValidateItem
	*!* Description...: Valida el item en forma protegida
	*!* Date..........: Sábado 22 de Marzo de 2008 (13:04:32)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure ValidateItem( oRecord As Object ) As Boolean;
			HELPSTRING "Valida el item en forma protegida"


		Local llValid As Boolean

		Try

			llValid = .T.

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return llValid

	Endproc
	*!*
	*!* END PROCEDURE ValidateItem
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oRecord_Access
	*!* Date..........: Sábado 22 de Marzo de 2008 (12:51:44)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure oRecord_Access()

		Try

			If IsEmpty( This.oRecord )

				Select Alias( This.EditingCursorName )

				Scatter Memo Name This.oRecord

			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return This.oRecord

	Endproc
	*!*
	*!* END PROCEDURE oRecord_Access
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateRecordStructure
	*!* Description...: Crea el cursor con la estructura que va a tener el objeto Item
	*!* Date..........: Sábado 22 de Marzo de 2008 (11:57:50)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure CreateRecordStructure(  ) As Void;
			HELPSTRING "Crea el cursor con la estructura que va a tener el objeto Item"


		Try

			Create Cursor (This.EditingCursorName) (;
				Cantidad N(8,2),;
				Codigo C(10),;
				Descripcion C(30),;
				PrecioUnitario N(12,2),;
				AlicuotaIva N(5,2),;
				AlicuotaDescuento N(5,2),;
				ImporteDescuento N(12,2),;
				ImporteIva N(12,2),;
				ImporteTotal N(12,2),;
				UniqueKey C(10) )


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry


	Endproc
	*!*
	*!* END PROCEDURE CreateRecordStructure
	*!*
	*!* ///////////////////////////////////////////////////////




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: EditingCursorName_Access
	*!* Date..........: Sábado 22 de Marzo de 2008 (13:23:29)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure EditingCursorName_Access()

		If !Used( This.EditingCursorName )
			This.CreateRecordStructure()
		Endif
		Return This.EditingCursorName

	Endproc
	*!*
	*!* END PROCEDURE EditingCursorName_Access
	*!*
	*!* ///////////////////////////////////////////////////////



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oItem
*!*
*!* ///////////////////////////////////////////////////////