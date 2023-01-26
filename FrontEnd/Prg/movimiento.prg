#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Movimiento(  ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""
		External Class Informes.vcx


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && Movimiento


*!* ///////////////////////////////////////////////////////
*!* Class.........: oMovimiento
*!* Description...:
*!* Date..........: Viernes 31 de Diciembre de 2021 (10:07:35)
*!*
*!*

Define Class oMovimiento As oModelo Of "FrontEnd\Prg\Modelo.prg"

	#If .F.
		Local This As oMovimiento Of "FrontEnd\Prg\Movimiento.prg"
	#Endif


	* Informes

	* Nombre del Formulario de Informes
	cFormularioInformes = ""

	* Coleccion con los Tipos de Informe
	oTiposDeInforme = Null

	* Colección con los Campos a Filtrar
	oCamposAFiltrar = Null

	* Colección de los tipos de Realaciones a Comparar para los filtros
	oFieldLookups = Null

	* Primer Fecha Válida
	dPrimerFechaValida 	= {}
	dFechaInicial 		= {}
	dFechaFinal 		= {}

	* URL del EndPoint, sin parámetros fijos
	cUrlBase = ""

	nInformeId = 0

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ninformeid" type="property" display="nInformeId" />] + ;
		[<memberdata name="cformularioinformes" type="property" display="cFormularioInformes" />] + ;
		[<memberdata name="otiposdeinforme" type="property" display="oTiposDeInforme" />] + ;
		[<memberdata name="otiposdeinforme_access" type="method" display="oTiposDeInforme_Access" />] + ;
		[<memberdata name="ofieldlookups" type="property" display="oFieldLookups" />] + ;
		[<memberdata name="ofieldlookups_access" type="method" display="oFieldLookups_Access" />] + ;
		[<memberdata name="ocamposafiltrar" type="property" display="oCamposAFiltrar" />] + ;
		[<memberdata name="ocamposafiltrar_access" type="method" display="oCamposAFiltrar_Access" />] + ;
		[<memberdata name="orelacionesacomparar" type="property" display="oRelacionesAComparar" />] + ;
		[<memberdata name="orelacionesacomparar_access" type="method" display="oRelacionesAComparar_Access" />] + ;
		[<memberdata name="dprimerfechavalida" type="property" display="dPrimerFechaValida" />] + ;
		[<memberdata name="dfechainicial" type="property" display="dFechaInicial" />] + ;
		[<memberdata name="dfechafinal" type="property" display="dFechaFinal" />] + ;
		[<memberdata name="ejecutarconsulta" type="method" display="EjecutarConsulta" />] + ;
		[<memberdata name="obtenerendpoint" type="method" display="ObtenerEndPoint" />] + ;
		[<memberdata name="parametrosfijos" type="method" display="ParametrosFijos" />] + ;
		[<memberdata name="parametrosvariables" type="method" display="ParametrosVariables" />] + ;
		[<memberdata name="getbywhere" type="method" display="GetByWhere" />] + ;
		[<memberdata name="consultar" type="method" display="Consultar" />] + ;
		[<memberdata name="armarcursores" type="method" display="ArmarCursores" />] + ;
		[<memberdata name="mostrarconsulta" type="method" display="MostrarConsulta" />] + ;
		[<memberdata name="curlbase" type="property" display="cUrlBase" />] + ;
		[<memberdata name="agregarparametro" type="method" display="AgregarParametro" />] + ;
		[</VFPData>]


	*
	*
	Procedure Initialize( oParam As Object ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			DoDefault( oParam )

			This.dPrimerFechaValida = {^2018/01/01}
			This.dFechaInicial 		= This.dPrimerFechaValida
			This.dFechaFinal 		= Date()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Initialize



	*
	*
	Procedure ObtenerEndPoint( oParametros As Object ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			This.cUrlBase = oParametros.oInforme.cEndPoint
			This.cURL = This.cUrlBase

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && ObtenerEndPoint

	*
	*
	Procedure AgregarParametro( cParametro As String ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			If This.cUrlBase == This.cURL
				This.cURL = This.cURL + "?"

			Else
				This.cURL = This.cURL + "&"

			Endif

			This.cURL = This.cURL + cParametro


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && AgregarParametro

	*
	*
	Procedure ParametrosFijos( ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			This.cReturnType = "Csv"

			If ( This.cSalida == S_PANTALLA )
				This.lGetAll = .F.

			Else
				This.AgregarParametro( "current_size=100000" )
				This.lGetAll = .T.

			EndIf



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && ParametrosFijos


	*
	*
	Procedure EjecutarConsulta( oParametros As Object ) As Void
		Local lcCommand As String
		Local loRespuesta as Object,;
			loReturn as Object

		Try

			lcCommand = ""
			
			This.cTitulo	= oParametros.cTitulo
			This.cSalida 	= oParametros.cSalida
			This.nInformeId = Val( Transform( oParametros.oInforme.nId ))
			This.ObtenerEndPoint( oParametros )
			This.ParametrosFijos( )

			This.oFilterCriteria = This.ParametrosVariables( oParametros )

			If ( oParametros.cSalida == S_PANTALLA )

				AddProperty( oParametros, "oBiz", This )

				Do Form ( This.cGrilla ) ;
					With oParametros To loReturn

			Else
				loRespuesta = This.Consultar()

				If loRespuesta.lOk
					*This.ArmarCursores( loRespuesta.oData )
					This.MostrarConsulta()
				EndIf

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && EjecutarConsulta

	*
	*
	Procedure Consultar() As Object
		Local lcCommand As String
		Local loRespuesta As Object

		Try

			lcCommand = ""
			loRespuesta = This.GetByWhere()


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loRespuesta

	Endproc && Consultar



	*
	*
	Procedure xxxArmarCursores( oColReg As Collection ) As Void
		Local lcCommand As String,;
			lcDate as String,;
			lcCentury as String
		Local loReg As Object
		Local i As Integer

		Try

			lcCommand = ""
			lcDate = Set("Date")
			lcCentury = Set("Century")

			Set Date YMD
			Set Century On

			Select Alias( This.cMainCursorName )

			For i = 1 To oColReg.Count
				loReg = oColReg.Item( i )
				Append Blank
				Gather Name loReg
			EndFor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Set Date &lcDate
			Set Century &lcCentury


		Endtry

	Endproc && xxxArmarCursores

	*
	*
	Procedure MostrarConsulta() As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			*Inform( Program())

			Select Alias( This.cMainCursorName )
			Locate
			Browse


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && MostrarConsulta



	*
	*
	Procedure ParametrosVariables( oParametros As Object ) As Collection
		Local loFilterCriteria As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
			loFiltros As Collection,;
			loFiltro As Object,;
			loFilter As Object,;
			loParam As Object,;
			loReturn As Object
		Local lnI As Integer

		Try

			lcCommand = ""

			loFiltros = oParametros.oFiltros

			loFilterCriteria = Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.Prg" )

			lnI = 0
			For Each loFiltro In loFiltros

				TEXT To lcMsg NoShow TextMerge Pretext 03
				lCaseSensitive: <<loFiltro.lCaseSensitive>>
				cLookUpCommand: <<loFiltro.cLookUpCommand>>
				Desde: <<loFiltro.uValue>>
				Hasta: <<loFiltro.uValueHasta>>
				cFieldName: <<loFiltro.cFieldName>>
				ENDTEXT

				*Inform( lcMsg )

				lnI = lnI + 1
				loFilter = Createobject( "Empty" )
				AddProperty( loFilter, "Nombre", Lower( loFiltro.cFieldName ) + "_" + StrZero( lnI ))

				If loFiltro.cLookUpCommand = "exact"
					AddProperty( loFilter, "FieldName", Lower( loFiltro.cFieldName ) )

				Else
					AddProperty( loFilter, "FieldName", Lower( loFiltro.cFieldName ) + "__" + loFiltro.cLookUpCommand )

				Endif

				AddProperty( loFilter, "FieldRelation", "==" )
				AddProperty( loFilter, "FieldValue", Any2String( loFiltro.uValue ))

				If loFiltro.cLookUpCommand == "range"
					loFilter.FieldValue = loFilter.FieldValue + "," + Any2String( loFiltro.uValueHasta )
				Endif

				loFilterCriteria.Add( loFilter, Lower( loFilter.Nombre ))

			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loFilterCriteria

	Endproc && ParametrosVariables


	*
	*
	Procedure xxxCrearCursores( oColReg As Collection,;
			cTabla As String,;
			cAlias As String,;
			lListar As Boolean ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			Inform( Program())


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && CrearCursores

	*
	*
	PROCEDURE Listar( cURL as String,;
			oFilterCriteria as Collection,;
			cAlias as String,;
            oBody as Object ) as Object
            
		Local lcCommand as String,;
			lcTitulo as String
		Local loTiposDeInforme As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg',;
			loInforme As Object

		Try

			lcCommand = ""

			lcTitulo = This.cTituloDelInforme

			loTiposDeInforme = This.oTiposDeInforme
			loInforme = loTiposDeInforme.GetItem( Transform( This.nInformeId ) )
			This.cTituloDelInforme = loInforme.Caption

			loReturn = DoDefault( cURL, oFilterCriteria, cAlias, oBody )

			If loReturn.lOk
				Select Alias( loReturn.cAlias )
				Locate
				*Browse
			EndIf

			This.cTituloDelInforme 	= lcTitulo

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loInforme = Null
			loTiposDeInforme = Null

		EndTry

		Return loReturn

	EndProc && Listar


	*
	* oTiposDeInforme_Access
	Protected Procedure oTiposDeInforme_Access()
		If Isnull( This.oTiposDeInforme )
			This.oTiposDeInforme = Newobject( "oColBase", 'Tools\DataDictionary\prg\oColBase.prg' )
		Endif

		Return This.oTiposDeInforme

	Endproc && oTiposDeInforme_Access

	*
	* oCamposAFiltrar_Access
	Protected Procedure oCamposAFiltrar_Access()
		Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
			loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
			loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
			loCamposAFiltrar As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'


		Local lcCommand As String
		Local i As Integer

		Try

			lcCommand = ""
			
			If Isnull( This.oCamposAFiltrar )
				Create Cursor cFields ( Id I, Orden I, Nombre C(30) )

				loCamposAFiltrar = Newobject( "oColBase", 'Tools\DataDictionary\prg\oColBase.prg' )
				loArchivo = This.GetTable()

				loColFields = loArchivo.oColFields
				For i = 1 To loColFields.Count
					loField = loColFields.Item( i )

					If !Empty( loField.nShowInFilter )
						Insert Into cFields ;
							( Id, Orden, Nombre ) Values ;
							( i, loField.nShowInFilter, loField.cCaption )
					Endif
				Endfor

				Select cFields
				Index On Str( Orden, 10 ) + Nombre Tag Orden

				Set Order To Orden

				Locate
				
				Scan
					loField = loColFields.Item( cFields.Id )
					loCamposAFiltrar.AddItem( loField, loField.Name )

				Endscan

				This.oCamposAFiltrar = loCamposAFiltrar

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loField = Null
			loColFields = Null
			loArchivo = Null
			loCamposAFiltrar = Null

		Endtry


		Return This.oCamposAFiltrar

	Endproc && oCamposAFiltrar_Access

	*
	* oFieldLookups_Access
	Protected Procedure oFieldLookups_Access()
		Local loFieldLookups As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg',;
			loFieldLookup As Object
		Local i As Integer

		If Isnull( This.oFieldLookups )
			Local Array aFieldLookups[ 16, 04]
			loFieldLookups = Newobject( "oColBase", 'Tools\DataDictionary\prg\oColBase.prg' )

			* FieldTypeList
			* ['C','V','T','D','N','I','M','L']

			aFieldLookups[ 01, 01 ] = "Igual a"
			aFieldLookups[ 01, 02 ] = "exact"
			aFieldLookups[ 01, 03 ] = "iexact"
			aFieldLookups[ 01, 04 ] = ['C','V','T','D','N','I','M','L']


			aFieldLookups[ 02, 01 ] = "Contiene"
			aFieldLookups[ 02, 02 ] = "contains"
			aFieldLookups[ 02, 03 ] = "icontains"
			aFieldLookups[ 02, 04 ] = ['C','V','M']

			aFieldLookups[ 03, 01 ] = "Comienza con"
			aFieldLookups[ 03, 02 ] = "startswith"
			aFieldLookups[ 03, 03 ] = "istartswith"
			aFieldLookups[ 03, 04 ] = ['C','V','M']

			aFieldLookups[ 04, 01 ] = "Termina con"
			aFieldLookups[ 04, 02 ] = "endswith"
			aFieldLookups[ 04, 03 ] = "iendswith"
			aFieldLookups[ 04, 04 ] = ['C','V','M']

			aFieldLookups[ 05, 01 ] = "Mayor que"
			aFieldLookups[ 05, 02 ] = "gt"
			aFieldLookups[ 05, 03 ] = "gt"
			aFieldLookups[ 05, 04 ] = ['C','V','T','D','N','I']

			aFieldLookups[ 06, 01 ] = "Mayor o Igual que"
			aFieldLookups[ 06, 02 ] = "gte"
			aFieldLookups[ 06, 03 ] = "gte"
			aFieldLookups[ 06, 04 ] = ['C','V','T','D','N','I']

			aFieldLookups[ 07, 01 ] = "Menor que"
			aFieldLookups[ 07, 02 ] = "lt"
			aFieldLookups[ 07, 03 ] = "lt"
			aFieldLookups[ 07, 04 ] = ['C','V','T','D','N','I']

			aFieldLookups[ 08, 01 ] = "Menor o Igual que"
			aFieldLookups[ 08, 02 ] = "lte"
			aFieldLookups[ 08, 03 ] = "lte"
			aFieldLookups[ 08, 04 ] = ['C','V','T','D','N','I']

			aFieldLookups[ 09, 01 ] = "Varios"
			aFieldLookups[ 09, 02 ] = "in"
			aFieldLookups[ 09, 03 ] = "in"
			aFieldLookups[ 09, 04 ] = ['I']

			aFieldLookups[ 10, 01 ] = "Rango"
			aFieldLookups[ 10, 02 ] = "range"
			aFieldLookups[ 10, 03 ] = "range"
			aFieldLookups[ 10, 04 ] = ['C','V','D','N','I']

			aFieldLookups[ 11, 01 ] = "Año"
			aFieldLookups[ 11, 02 ] = "year"
			aFieldLookups[ 11, 03 ] = "year"
			aFieldLookups[ 11, 04 ] = ['D']

			aFieldLookups[ 12, 01 ] = "Mes"
			aFieldLookups[ 12, 02 ] = "month"
			aFieldLookups[ 12, 03 ] = "month"
			aFieldLookups[ 12, 04 ] = ['D']

			aFieldLookups[ 13, 01 ] = "Día del Mes"
			aFieldLookups[ 13, 02 ] = "day"
			aFieldLookups[ 13, 03 ] = "day"
			aFieldLookups[ 13, 04 ] = ['D']

			aFieldLookups[ 14, 01 ] = "Día de la Semana"
			aFieldLookups[ 14, 02 ] = "week_day"
			aFieldLookups[ 14, 03 ] = "week_day"
			aFieldLookups[ 14, 04 ] = ['D']

			aFieldLookups[ 15, 01 ] = "Semana del Año"
			aFieldLookups[ 15, 02 ] = "week"
			aFieldLookups[ 15, 03 ] = "week"
			aFieldLookups[ 15, 04 ] = ['D']

			aFieldLookups[ 16, 01 ] = "Trimestre"
			aFieldLookups[ 16, 02 ] = "quarter"
			aFieldLookups[ 16, 03 ] = "quarter"
			aFieldLookups[ 16, 04 ] = ['D']

			For i = 1 To 16
				loFieldLookup = Createobject( "Empty" )
				AddProperty( loFieldLookup, "Caption", 	aFieldLookups[ i, 01 ] )
				AddProperty( loFieldLookup, "Command", 	aFieldLookups[ i, 02 ] )
				AddProperty( loFieldLookup, "iCommand", aFieldLookups[ i, 03 ] )
				AddProperty( loFieldLookup, "FieldTypeList", aFieldLookups[ i, 04 ] )

				loFieldLookups.AddItem( loFieldLookup, loFieldLookup.Command )

			Endfor

			This.oFieldLookups = loFieldLookups

		Endif

		Return This.oFieldLookups

	Endproc && oFieldLookups_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oMovimiento
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Columna_Informe
*!* Description...:
*!* Date..........: Miércoles 16 de Marzo de 2022 (19:00:56)
*!*
*!*

Define Class Columna_Informe As PrxColumn Of "Fw\TierAdapter\Comun\prxBaseLibrary.prg"

	#If .F.
		Local This As Columna_Informe Of "FrontEnd\Prg\Movimiento.prg"
	#Endif
	
	cTextControlName 	= "prxText"
	cTextControlLibrary = "FrontEnd\Prg\Movimiento.prg"
	cCurrentControlName = "prxText1"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Columna_Informe
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: prxText
*!* Description...:
*!* Date..........: Miércoles 16 de Marzo de 2022 (19:08:50)
*!*
*!*

Define Class prxText As TextBox

	#If .F.
		Local This As prxText Of "FrontEnd\Prg\Movimiento.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*
	*
	Procedure MouseDown( nButton, nShift, nXCoord, nYCoord ) As Void
		Local lcCommand As String

		Local lnOpcion As Integer

		Try

			lcCommand = ""

			lnOpcion 	= 0

			Do Case
				Case nButton = 2 And nShift = 0 && Right Click

					Define Popup emergente SHORTCUT Relative From Mrow(),Mcol()

					Define Bar 1 Of emergente Prompt "Primera \<Opción"
					Define Bar 2 Of emergente Prompt "\<Segunda Opciín"
					Define Bar 3 Of emergente Prompt "Tercera Opción \<Posible"

					On Selection Bar 1 Of emergente lnOpcion 	= 1
					On Selection Bar 2 Of emergente lnOpcion 	= 2
					On Selection Bar 3 Of emergente lnOpcion 	= 3

					Activate Popup emergente

					Inform( lnOpcion )

			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && MouseDown

Enddefine
*!*
*!* END DEFINE
*!* Class.........: prxText
*!*
*!* ///////////////////////////////////////////////////////



