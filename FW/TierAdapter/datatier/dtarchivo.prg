*!* ///////////////////////////////////////////////////////
*!* Class.........: dtGeneral
*!* ParentClass...: DataTierAdapter
*!* BaseClass.....: Session
*!* Description...: Template para las MainEntities
*!* Date..........: Martes 18 de Abril de 2006 (16:32:06)
*!* Author........: Ricardo Aidelman
*!* Project.......: Visual Praxis Beta v. 1.1
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*


Define Class dtArchivo As DataTierAdapter Of "FW\Actual\Tier Adapter\DataTier\DataTierAdapter.prg"

	#If .F.
		Local This As dtArchivo Of "ERP\Actual\Archivos\Server\dtArchivo.prg"
	#Endif

	cDataConfigurationKey = "Archivo"

	GetAllFields = ""
	GetAllPaginatedOrderBy = "Descripcion"


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: PopulateTablesByUser
	*!* Description...: Define las tablas asociadas a la entidad
	*!* Date..........: Lunes 14 de Abril de 2008 (10:17:02)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure PopulateTablesByUser(  ) As Void;
			HELPSTRING "Define las tablas asociadas a la entidad"


		Try
			This.oError.TraceLogin = "Definiendo las tablas asociadas a la entidad"
			This.oError.Remark = "Definiendo Nombre de la Tabla"

			loTable = This.oColTables.New( "NombreUnicoDelCursor" )

			*!* Nombre de la tabla
			loTable.Tabla = ""

			*!* Nombre de la Primary Key de la tabla/nivel de la entidad
			loTable.PKName = ""

			*!* En la tabla hija va el nombre de la tabla padre
			loTable.Padre = ""

			*!* en la tabla hija va el nombre del campo con el que se relaciona ;
			con la tabla padre (Foreign Key)
			loTable.ForeignKey = ""

			*!* Referencia al nombre del campo que contiene el ID de la tabla de ;
			nivel 1 con la que está relacionada.
			loTable.MainID = ""

			*!* Para NEW y GETONE, se puede definir una sentencia SQL
			loTable.SQLStat = ""

			*!* Indica la clausula ORDER BY para el GetAll(), en caso de Nivel 1, o las tablas Hijas, para los demás niveles
			loTable.OrderBy = ""


		Catch To oErr
			If This.lIsOk
				This.lIsOk = .F.
				This.cXMLoError=This.oError.Process( oErr )
			Endif

		Finally
			This.oError.TraceLogin = ""
			This.oError.Remark = ""

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE PopulateTablesByUser
	*!*
	*!* ///////////////////////////////////////////////////////

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: GetLastCodigo
*!*		*!* Description...: Devuelve el ÚLTIMO codigo ingresaDO
*!*		*!* Date..........: Lunes 25 de Agosto de 2008 (09:40:08)
*!*		*!* Author........: Danny Amerikaner
*!*		*!* Project.......: Sistemas praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure GetLastCodigo( cQuery As String ) As String;
*!*				HELPSTRING "Devuelve el proximo codigo a ingresar"


*!*			Try
*!*				Local lcNext As String
*!*				Local lcOldDeleted As String

*!*				lcNext = ""

*!*				lcOldDeleted = Set("Deleted")
*!*				Set Deleted Off
*!*				This.SQLExecute( cQuery, This.cMainCursorName )

*!*				Select Alias( This.cMainCursorName )
*!*				Locate

*!*				If !Eof()
*!*					lcNext =  Evaluate( This.cMainCursorName + ".Codigo" )

*!*				Endif


*!*			Catch To oErr
*!*				Local loError As prxErrorHandler Of "fw\Actual\ErrorHandler\prxErrorHandler.prg"
*!*				loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
*!*				loError.Process( oErr )
*!*				Throw loError

*!*			Finally
*!*				Set Deleted &lcOldDeleted

*!*			Endtry

*!*			Return lcNext

*!*		Endproc
*!*		*!*
*!*		*!* END PROCEDURE GetNextCodigo
*!*		*!*
*!*		*!* ///////////////////////////////////////////////////////


	*!*		Procedure Initialize( tXMLoConfigData As String ) As Void


	*!*			If DoDefault( tXMLoConfigData )
	*!*
	*!*				If This.lHasDefault
	*!*					If Empty( This.GetAllFields )
	*!*						This.GetAllFields = "*"
	*!*					Endif
	*!*					This.GetAllFields = This.GetAllFields + ",Default as Selected "
	*!*				Endif
	*!*			Endif

	*!*		Endproc
	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: BeforeGetAllFields
	*!* Description...: Hook Method
	*!* Date..........: Viernes 31 de Octubre de 2008 (18:35:43)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure BeforeGetAllFields(  ) As Void;
			HELPSTRING "Hook Method"

		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		Try
			With This As dtArchivo Of fw\tieradapter\datatier\dtArchivo.prg
				
				loError = .oError
				loError .Remark = ''
				loError .TraceLogin = ''
				If Empty( .GetAllFields )
					.GetAllFields = "*"

				Endif && Empty( loError .GetAllFields )

				If .lHasDefault

					.GetAllFields = .GetAllFields + ",Default as Selected"

				Endif && .lHasDefault

				.GetAllFields = .GetAllFields + ",99999 as _RecordOrder"

			Endwith

		Catch To oErr

			loError = This.oError
			This.cXMLoError = loError.Process( oErr )
			Throw loError

		Finally
			loError = This.oError
			This.oError.Remark = ''
			This.oError.TraceLogin = ''
			loError = Null

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE BeforeGetAllFields
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetLenDescripcion
	*!* Description...: Devuelve la longitud lógica del campo Descripcion
	*!* Date..........: Lunes 10 de Marzo de 2008 (11:46:37)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetLenDescripcion(  ) As Integer;
			HELPSTRING "Devuelve la longitud lógica del campo Descripcion"


		Try

			Local lnLen As Integer
			Local lcAlias As String,;
				lcSelectCmd As String
			Local llAlreadyConnected As Boolean

			lcAlias = Sys( 2015 )
			lnLen = -1

			llAlreadyConnected = This.ConnectToBackend() = 0

			If This.lIsOk
				TEXT To lcSelectCmd NoShow TextMerge Pretext 15
				Select Descripcion From <<This.cMainTableName>> Where 1=0
				ENDTEXT

				If This.BuildCursor( lcAlias, lcSelectCmd )
					lnLen = Fsize( "Descripcion", lcAlias )
				Endif

			Endif

		Catch To oErr
			This.lIsOk = .F.
			This.cXMLoError = This.oError.Process( oErr )

		Finally

			If Used( lcAlias )
				Use In Alias( lcAlias )
			Endif
			If Not llAlreadyConnected
				This.DisconnectFromBackend()
			Endif


		Endtry

		Return lnLen
	Endproc
	*!*
	*!* END PROCEDURE GetLenDescripcion
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: dtArchivos
*!*
*!* ///////////////////////////////////////////////////////