#INCLUDE "FW\Comunes\Include\Praxis.h"

*
* Actualizacion de Cargos
Procedure Impresora(  ) As Void;
		HELPSTRING "Actualizacion de Impresoras"

	Local lcCommand As String,;
		lcTitulo As String

	Local loReturn As Object
	Local loParam As Object
	Local loImpresora As Impresora Of 'Fw\Comunes\Prg\Impresora.prg'

	External Procedure SelectPrinter.prg


	Try

		lcCommand = ""

		loImpresora = GetEntity( "Impresora" )
		loImpresora.GetAll( loParam )

		TEXT To lcTitulo NoShow TextMerge Pretext 15
		Terminal: [<<loImpresora.cTerminal>>] - Usuario Windows: [<<loImpresora.cWinUser>>]
		ENDTEXT

		loParam = Createobject( "Empty" )
		AddProperty( loParam, "cAlias", loImpresora.cMainCursorName )
		AddProperty( loParam, "cTitulo", lcTitulo )
		AddProperty( loParam, "oBiz", loImpresora )
		AddProperty( loParam, "cPKField", loImpresora.cPKField )

		Do Form 'Fw\Comunes\scx\Impresoras.scx' ;
			With loParam To loReturn

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally
		If Vartype( loParam ) = "O"
			loParam.oBiz	= Null
		Endif

		loParam 		= Null
		oParam 			= Null
		loReturn 		= Null
		loImpresora 	= Null

		Close Databases All

	Endtry

Endproc && Impresora



Define Class Impresora As Entidad Of "V:\Clipper2fox\Rutinas\Prg\prxEntidad.prg"

	#If .F.
		Local This As Impresora Of 'Fw\Comunes\Prg\Impresora.prg'
	#Endif


	* Nombre de la maquina actual
	cTerminal = ""

	* Nombre del Usuario loggeado en Windows
	cWinUser = ""


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="selectprinter" type="method" display="SelectPrinter" />] + ;
		[<memberdata name="cterminal" type="property" display="cTerminal" />] + ;
		[<memberdata name="cterminal_access" type="method" display="cTerminal_Access" />] + ;
		[<memberdata name="cwinuser" type="property" display="cWinUser" />] + ;
		[<memberdata name="cwinuser_access" type="method" display="cWinUser_Access" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: HookBeforeInitialize
	*!* Description...:
	*!* Date..........: Domingo 7 de Julio de 2013 (16:34:20)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Clipper2Fox
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure HookBeforeInitialize( ) As Boolean

		Local lcCommand As String

		Try

			lcCommand = ""

			* Alias de la Tabla
			This.cMainTableName 	= "Impresoras"

			* Alias del cursor transitorio
			This.cMainCursorName 	= "cImpresoras"

			* Campo clave
			This.cPKField			= "PrinterId"

			* Carpeta donde se encuentra la Tabla
			This.cTableFolder 		= drComun

			* Nombre real de la tabla
			This.cRealTableName 	= "Impresoras"

			* Cantidad de Indices IDX
			This.nIndices = 0



		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry


	Endproc
	*!*
	*!* END Procedure HookBeforeInitialize
	*!*
	*!* ///////////////////////////////////////////////////////

	*
	* Selecciona una Impresora de la Tabla de Impresoras
	Procedure SelectPrinter( cCodigo As String ) As String ;
			HELPSTRING "Selecciona una Impresora de la Tabla de Impresoras"
		Local lcCommand As String,;
			lcPrinter As String,;
			lcPropertiesList As String,;
			lcFilterCriteria As String,;
			lcFieldList As String

		Local loParam As Object
		Local llDefault As Boolean,;
			llFound As Boolean

		Try

			lcCommand 	= ""

*!*				If Empty( cPrinterName )
*!*					cPrinterName = ""
*!*				Endif

			If Empty( cCodigo )
				cCodigo = ""
			Endif

			llDefault 	= .F.
			lcPrinter 	= ""

			llFound = .F.

			Try

				llFound = Seek( cCodigo, This.cMainTableName, "Codigo" )

			Catch To oErr
				llFound = .F.

			Finally

			Endtry

			If !llFound
				TEXT To lcFilterCriteria NoShow TextMerge Pretext 15
				( Upper( Nombre ) == '<<Upper( cCodigo )>>' )
				ENDTEXT

				TEXT To lcFieldList NoShow TextMerge Pretext 15
				Puerto, Default
				ENDTEXT

				*!*				Text To lcPropertiesList NoShow TextMerge Pretext 15
				*!*				cPrinterName 	= '<<cPrinterName>>';
				*!*				cTerminal 		= '<<lcTerminal>>';
				*!*				cWinUser  		= '<<lcWinUser>>';
				*!*				cFieldList 		= 'Puerto, Default';
				*!*				cFilterCriteria = '<<lcFilterCriteria>>'
				*!*				EndText

				*!*				loParam = objParam( lcPropertiesList )

				loParam = Createobject( "Empty" )
				AddProperty( loParam, "cPrinterName", cCodigo )
				AddProperty( loParam, "cTerminal", This.cTerminal )
				AddProperty( loParam, "cWinUser", This.cWinUser )
				AddProperty( loParam, "cFieldList", lcFieldList )
				AddProperty( loParam, "cFilterCriteria", lcFilterCriteria )


				If This.GetByWhere( loParam ) = 1
					lcPrinter = Evaluate( This.cMainCursorName + ".Puerto" )
					llDefault = !Empty( Evaluate( This.cMainCursorName + ".Default" ))
				Endif

			Else
				lcPrinter = Evaluate( This.cMainTableName + ".Puerto" )
				llDefault = !Empty( Evaluate( This.cMainTableName + ".Default" ))

			Endif

			If llDefault
				lcPrinter = Set("Printer",2)

			Else
				If Empty( lcPrinter )
					lcPrinter = Getprinter()
				Endif

			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loImpresora = Null
			Use In Select( This.cMainCursorName )

		Endtry

		Return lcPrinter

	Endproc && SelectPrinter

	*
	* Trae los elementos filttrados por alguna condicion
	* oParam.cFilterCriteria = Criterio de Filtro
	* oParam.cOrderBy = Clausula de Ordenamiento
	* oParam.cFieldList = Lista de Campos
	* oParam.cJoins = Joins
	* oParam.nLevel = Nivel de profundidad que trae
	* oParam.cAlias = Alias alternativo a This.cMainCursorName

	Procedure GetByWhere( oParam As Object ) As Integer;
			HELPSTRING "Trae los elementos filttrados por alguna condicion"


		Local lcCommand As String,;
			lcAlias As String,;
			lcFilterCriteria As String,;
			lcParentFilter As String,;
			lcOrderBy As String,;
			lcFieldList As String,;
			lcJoins As String

		Local lnLevel As Integer

		Local loParent As PrxEntity Of "Fw\TierAdapter\Comun\prxEntity.prg"
		Local lnTally As Integer

		Try

			lcCommand = ""

			* Valores por defecto
			lcParentFilter 	= ""
			lcAlias 		= This.cMainCursorName
			lnNivel 		= 1
			lcOrderBy		= ""
			lcFieldList		= " * "
			lcJoins			= ""
			lcFilterCriteria = " 1 > 0 "

			If Vartype( oParam ) # "O"
				oParam = Createobject( "Empty" )
			Endif

			If Pemstatus( oParam, "cFilterCriteria", 5 )
				lcFilterCriteria = oParam.cFilterCriteria
			Endif

			If Pemstatus( oParam, "cAlias", 5 )
				lcAlias = oParam.cAlias
			Endif

			If Pemstatus( oParam, "nLevel", 5 )
				lnLevel = oParam.nLevel
			Endif

			If Pemstatus( oParam, "cOrderBy", 5 )
				lcOrderBy = oParam.cOrderBy

				If !Upper( Substr( lcOrderBy, 1, Len( "Order By" ))) = "ORDER BY"
					lcOrderBy = "ORDER BY " + lcOrderBy
				Endif
			Endif

			If Pemstatus( oParam, "cJoins", 5 )
				lcJoins = oParam.cJoins
			Endif

			If Pemstatus( oParam, "cFieldList", 5 )
				lcFieldList = oParam.cFieldList
			Endif

			If This.lIsChild

				loParent = This.oParent

				TEXT To lcParentFilter NoShow TextMerge Pretext 15
				And ( <<loParent.cPKField>> = <<loParent.nEntidadId>> )
				ENDTEXT

			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select 	<<lcFieldList>> ,
					" " as r7Mov,
					Cast( 0 as I ) as ABM,
					Cast( 0 as I ) as _RecordOrder
				From <<This.cMainTableName>>
				Where <<lcFilterCriteria>>
					<<lcParentFilter>>
				<<lcJoins>>
				<<lcOrderBy>>
			ENDTEXT

			This.oRequery = oParam

			This.SQLExecute( lcCommand, lcAlias )

			lnTally = _Tally

			If !Empty( lnTally )
				Select Alias( lcAlias )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update <<lcAlias>> Set _RecordOrder = Recno()
				ENDTEXT

				&lcCommand

				Locate

			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			oParam = Null

		Endtry

		Return lnTally

	Endproc && GetByWhere


	*
	* Abre las tablas necesarias
	Procedure xxxAbrirTabla(  ) As Void;
			HELPSTRING "Abre las tablas necesarias"
		Local lcCommand As String,;
			lcAlterTable As String

		Local oErr As Exception

		Try

			lcCommand = ""

			If !Used( This.cMainTableName )
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Use <<Addbs( This.cTableFolder )>><<This.cRealTableName>> Shared In 0 Alias <<This.cMainTableName>>
				ENDTEXT

				Try

					&lcCommand

				Catch To oErr
					If oErr.ErrorNo = 1 && File 's:\fenix\dbf\dbf\impresoras.dbf' does not exist.

						TEXT To lcAlterTable NoShow TextMerge Pretext 15
						Create Table <<Addbs( This.cTableFolder )>><<This.cRealTableName>> Free (
							PrinterId I,
							Codigo C(10),
							Nombre C(40),
							Puerto M,
							Terminal C(40),
							Default I,
							Exclusive I,
							System I )
						ENDTEXT

						&lcAlterTable

						TEXT To lcAlterTable NoShow TextMerge Pretext 15
						Insert Into <<This.cRealTableName>> (
							PrinterId,
							Codigo,
							Nombre,
							Puerto,
							Terminal,
							Default,
							Exclusive,
							System ) Values (
							1,
							Sys(2015),
							"Listados Generales",
							"",
							"",
							1,
							0,
							1 )
						ENDTEXT

						&lcAlterTable

						Use In Select( This.cRealTableName )

						&lcCommand

					Else
						Throw oErr

					Endif

				Finally

				Endtry


			Endif


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && AbrirTabla


	*
	* cTerminal_Access
	Protected Procedure cTerminal_Access()

		If Empty( This.cTerminal )
			This.cTerminal = Alltrim( Substr( Sys(0), 1, At( "#", Sys(0) ) - 1 ) )
		Endif

		Return This.cTerminal

	Endproc && cTerminal_Access

	*
	* cWinUser_Access
	Protected Procedure cWinUser_Access()

		If Empty( This.cWinUser )
			This.cWinUser = Alltrim( Substr( Sys(0), At( "#", Sys(0)) + 1 ) )
		Endif
		Return This.cWinUser

	Endproc && cWinUser_Access

Enddefine


*!* ///////////////////////////////////////////////////////
*!* Class.........: CboImpresoras
*!* ParentClass...: ComboBox
*!* BaseClass.....: ComboBox
*!* Description...: Impresoras
*!* Date..........: Domingo 15 de Abril de 2012 (12:19:45)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class CboImpresoras As ComboBox

	#If .F.
		Local This As CboImpresoras Of 'Fw\Comunes\Prg\Impresora.prg'
	#Endif

	BoundColumn 	= 2
	BoundTo 		= .T.
	ColumnCount 	= 1
	RowSourceType 	= 0
	RowSource 		= ""
	Style			= 2
	Sorted 			= .T.


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	Procedure Init()
		Local lcCommand As String

		Local loImpresora As Impresora Of 'Fw\Comunes\Prg\Impresora.prg'

		Try

			lcCommand = ""
			loImpresora = GetEntity( "Impresora" )
			loImpresora.GetAll()

			Select Alias( loImpresora.cMainCursorName )
			Locate

			Scan
				This.AddItem( Evaluate( loImpresora.cMainCursorName + ".Descripcion" ))
				This.List( This.NewIndex, 2 ) = Transform( Evaluate( loImpresora.cMainCursorName + ".PrinterId" ))
			Endscan

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loImpresora = Null

		Endtry

	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: CboImpresoras
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ChkDefault
*!* ParentClass...: CheckBox
*!* BaseClass.....: CheckBox
*!* Description...:
*!* Date..........: Viernes 16 de Agosto de 2013 (16:11:30)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ChkDefault As Checkbox

	#If .F.
		Local This As ChkDefault Of "V:\Clipper2fox\Fw\Comunes\Prg\Impresora.prg"
	#Endif

	Caption = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: ChkDefault
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ChkExclusive
*!* ParentClass...: CheckBox
*!* BaseClass.....: CheckBox
*!* Description...:
*!* Date..........: Viernes 16 de Agosto de 2013 (16:11:30)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ChkExclusive As Checkbox

	#If .F.
		Local This As ChkExclusive Of "V:\Clipper2fox\Fw\Comunes\Prg\Impresora.prg"
	#Endif

	Caption = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]
	*
	*
	Procedure InteractiveChange(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && InteractiveChange



Enddefine
*!*
*!* END DEFINE
*!* Class.........: ChkExclusive
*!*
*!* ///////////////////////////////////////////////////////