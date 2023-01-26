*!* ///////////////////////////////////////////////////////
*!* Class.........: ColReportLayout
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

Define Class ColReportLayout As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg" 

	#If .F.
		Local This As ColReportLayout Of "Fw\comunes\Prg\ColReportLayout.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Devuelve un objeto ColBandLayout
	*!* Date..........: Martes 18 de Diciembre de 2007 (11:21:08)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure New( cName As String ) As Collection;
			HELPSTRING "Devuelve un objeto ColBandLayout"


		Local loBandLayout As ColBandLayout Of "Fw\comunes\Prg\ColReportLayout.prg"

		Try

			loBandLayout = Createobject( "ColBandLayout" )
			If !Empty( cName )
				This.AddItem( loBandLayout, Lower( cName ) )
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return loBandLayout

	Endproc
	*!*
	*!* END PROCEDURE New
	*!*
	*!* ///////////////////////////////////////////////////////


Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColReportLayout
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: ColBandLayout
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

Define Class ColBandLayout As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg" 

	#If .F.
		Local This As ColBandLayout Of "Fw\comunes\Prg\ColReportLayout.prg"
	#Endif

	*!* Nombre del cursor asociado a la banda de detalle
	cDetailCursorName = ""

	*!* Nombre del cursor asociado al Header
	cHeaderCursorName = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cheadercursorname" type="property" display="cHeaderCursorName" />] + ;
		[<memberdata name="cdetailcursorname" type="property" display="cDetailCursorName" />] + ;
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


		Local loColumnLayout As ColumnLayautObject Of "Fw\comunes\Prg\ColReportLayout.prg"

		Try

			loColumnLayout = Createobject( "ColumnLayautObject" )
			If !Empty( cName )
				This.AddItem( loColumnLayout, Lower( cName ) )
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return loColumnLayout

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

			Local loCol As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg" ,;
				loBkUpCol as PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg" 
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
*!* Class.........: ColBandLayout
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ColumnLayautObject
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Objeto compuesto por el Header y el Detail de cada columna
*!* Date..........: Lunes 10 de Diciembre de 2007 (15:31:53)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ColumnLayautObject As Session

	#If .F.
		Local This As ColumnLayautObject Of "Fw\comunes\Prg\ColReportLayout.prg"
	#Endif

	*!* Nombre de la clase del elemento Header
	cHeaderClass = "lytField"
	*!* Nombre de la librería de clases del elemento Header
	cHeaderClassLibrary = "lytField.prg"
	*!* Carpeta donde se encuentra la librería
	cHeaderClassLibraryFolder = "Tools\report Builder\Source\Layout"


	*!* Nombre de la clase del elemento Detail
	cDetailClass = "lytField"
	*!* Nombre de la librería de clases del elemento Detail
	cDetailClassLibrary = "lytField.prg"
	*!* Carpeta donde se encuentra la librería
	cDetailClassLibraryFolder = "Tools\report Builder\Source\Layout"

	*!* Referencia al objeto Header
	oHeader = Null
	*!* Referencia al objeto Detail
	oDetail = Null

	*!* Número de orden de la columna
	TabOrder = 0

	Visible = .T.

	*!* Nombre del cursor asociado a la banda de detalle
	cDetailCursorName = ""
	*!* Nombre del campo asociado a la banda detalle
	cDetailFieldName = ""

	*!* Nombre del cursor asociado al Header
	cHeaderCursorName = ""
	*!* Nombre del campo asociado al Header
	cHeaderFieldName = ""

	*!* Indica si el objeto ha sido seleccionado
	Selected = .T.

	DataSession = SET_DEFAULT


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="selected" type="property" display="Selected" />] + ;
		[<memberdata name="cheaderfieldname" type="property" display="cHeaderFieldName" />] + ;
		[<memberdata name="cheadercursorname" type="property" display="cHeaderCursorName" />] + ;
		[<memberdata name="cdetailfieldname" type="property" display="cDetailFieldName" />] + ;
		[<memberdata name="cdetailcursorname" type="property" display="cDetailCursorName" />] + ;
		[<memberdata name="visible" type="property" display="Visible" />] + ;
		[<memberdata name="cheaderclasslibraryfolder" type="property" display="cHeaderClassLibraryFolder" />] + ;
		[<memberdata name="cheaderclasslibrary" type="property" display="cHeaderClassLibrary" />] + ;
		[<memberdata name="cheaderclass" type="property" display="cHeaderClass" />] + ;
		[<memberdata name="cdetailclasslibraryfolder" type="property" display="cDetailClassLibraryFolder" />] + ;
		[<memberdata name="cdetailclasslibrary" type="property" display="cDetailClassLibrary" />] + ;
		[<memberdata name="cdetailclass" type="property" display="cDetailClass" />] + ;
		[<memberdata name="oheader" type="property" display="oHeader" />] + ;
		[<memberdata name="oheader_access" type="method" display="oHeader_Access" />] + ;
		[<memberdata name="odetail" type="property" display="oDetail" />] + ;
		[<memberdata name="odetail_access" type="method" display="oDetail_Access" />] + ;
		[<memberdata name="taborder" type="property" display="TabOrder" />] + ;
		[<memberdata name="taborder_assign" type="method" display="TabOrder_Assign" />] + ;
		[<memberdata name="getnewobject" type="method" display="GetNewObject" />] + ;
		[<memberdata name="synchronizecolumns" type="method" display="SynchronizeColumns" />] + ;
		[</VFPData>]



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SynchronizeColumns
	*!* Description...: Sincroniza el ancho de los objetos Header y Detail
	*!* Date..........: Miércoles 9 de Enero de 2008 (12:06:07)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure SynchronizeColumns( nWidth As Integer ) As Void;
			HELPSTRING "Sincroniza el ancho de los objetos Header y Detail"


		Try

			Local lnParentWidth As Integer,;
				lnMaxWidth As Integer

			Local loGlobalSetup As Object

			If Empty( nWidth )
				nWidth = -1
			Endif

			* Reinicializar propiedades
			This.oHeader.Width = nWidth
			This.oDetail.Width = nWidth

			This.oHeader.Height = -1
			This.oDetail.Height = -1

			* Forzar que recalcule
			lnParentWidth = -1
			loGlobalSetup = Createobject( "Empty" )
			AddProperty( loGlobalSetup, "ReportWidth", -1 )


			This.oHeader.AutoSetup( loGlobalSetup, lnParentWidth )
			This.oDetail.AutoSetup( loGlobalSetup, lnParentWidth )

			lnMaxWidth = Max( This.oHeader.Width, This.oDetail.Width )

			This.oHeader.Width = lnMaxWidth
			This.oDetail.Width = lnMaxWidth

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally
			loGlobalSetup = Null

		Endtry


	Endproc
	*!*
	*!* END PROCEDURE SynchronizeColumns
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: TabOrder_Assign
	*!* Date..........: Lunes 10 de Diciembre de 2007 (13:30:50)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure TabOrder_Assign( uNewValue )

		If uNewValue <= 0
			Error "Valor no válido en la propiedad TabOrder de " + This.Name
		Endif

		This.TabOrder = uNewValue

	Endproc
	*!*
	*!* END PROCEDURE TabOrder_Assign
	*!*
	*!* ///////////////////////////////////////////////////////



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oDetail_Access
	*!* Date..........: Lunes 10 de Diciembre de 2007 (13:25:00)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oDetail_Access()
		If IsEmpty( This.oDetail )
			This.oDetail = This.GetNewObject( This.cDetailClass, ;
				This.cDetailClassLibrary,;
				This.cDetailClassLibraryFolder )

			This.oDetail.lSameRowAsPrevious = .T.

		Endif

		Return This.oDetail

	Endproc
	*!*
	*!* END PROCEDURE oDetail_Access
	*!*
	*!* ///////////////////////////////////////////////////////



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oHeader_Access
	*!* Date..........: Lunes 10 de Diciembre de 2007 (13:15:49)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oHeader_Access()

		If IsEmpty( This.oHeader )
			This.oHeader = This.GetNewObject( This.cHeaderClass,;
				This.cHeaderClassLibrary,;
				This.cHeaderClassLibraryFolder )
			This.oHeader.lSameRowAsPrevious = .T.

		Endif
		Return This.oHeader

	Endproc
	*!*
	*!* END PROCEDURE oHeader_Access
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetNewObject
	*!* Description...: Crea un objeto y devuelve una referencia al mismoa
	*!* Date..........: Viernes 7 de Septiembre de 2007 (10:31:02)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: OOReport Builder
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetNewObject( cClassName As String,;
			cClassLibrary As String,;
			cClassLibraryFolder As String ) As Object;
			HELPSTRING "Devuelve el objeto indicado"

		Local loObj As Object,;
			loParent As Object
		Try


			loParent = Createobject( "Empty" )
			AddProperty( loParent, "DataSessionId", Set("Datasession") )

			loObj = Newobject( cClassName,;
				Addbs( cClassLibraryFolder ) +;
				cClassLibrary,;
				"",;
				loParent )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loObj
	Endproc
	*!*
	*!* END PROCEDURE GetNewObject
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: ColumnLayautObject
*!*
*!* ///////////////////////////////////////////////////////