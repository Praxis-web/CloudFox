*!* ///////////////////////////////////////////////////////
*!* Class.........: TierConfig
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Crea un XML de configuración
*!* Date..........: Martes 4 de Marzo de 2008 (11:29:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class TierConfig As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"

	#If .F.
		Local This As TierConfig Of "Fw\TierAdapter\Comun\TierConfig.prg"
	#Endif

	* Indica si se realiza el procesamiento de la Coleccion de Entidades
	lProcess = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lprocess" type="property" display="lProcess" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="createxml" type="method" display="CreateXML" />] + ;
		[<memberdata name="createcursor" type="method" display="CreateCursor" />] + ;
		[<memberdata name="process" type="method" display="Process" />] + ;
		[<memberdata name="processcollection" type="method" display="ProcessCollection" />] + ;
		[<memberdata name="removeentity" type="method" display="RemoveEntity" />] + ;
		[<memberdata name="getentity" type="method" display="GetEntity" />] + ;
		[<memberdata name="loadentities" type="method" display="LoadEntities" />] + ;
		[</VFPData>]


	Procedure Init( tuProcess As Variant ) As Boolean

		Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
		Local llOk As Boolean

		Try

			llOk = .F.
			loGlobalSettings = NewGlobalSettings()

			If Empty( Atc( "#" + This.Name + "#", loGlobalSettings.cEntitiesConfig ) )
				llOk = .T.

				loGlobalSettings.cEntitiesConfig = loGlobalSettings.cEntitiesConfig + "#" + This.Name + "#,"

				This.lProcess = Empty( tuProcess )
				This.Initialize()

*!*					If This.lProcess
*!*						This.ClassAfterInit()
*!*					Endif
			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally
			loGlobalSettings = Null

		Endtry

		Return llOk

	Endproc && Init

	Procedure Initialize( uParam As Variant ) As Void


	Endproc && Initialize


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: LoadEntities
	*!* Description...:
	*!* Date..........: Miércoles 22 de Abril de 2009 (11:03:27)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure LoadEntities(  ) As Void


		Try


		Catch To oErr

		Finally

		Endtry

	Endproc && LoadEntities

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetEntity
	*!* Description...: Devuelve una entidad de la coleccion
	*!* Date..........: Martes 29 de Abril de 2008 (09:17:18)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetEntity( tcObjectName As String,;
			tcTierLevel As String ) As Object;
			HELPSTRING "Devuelve una entidad de la coleccion"

		Local loEntity As Object
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try

			loEntity = This.GetItem( Lower( tcObjectName + "_" + tcTierLevel ) )

			If Vartype( loEntity ) # "O"
				Error tcObjectName + "_" + tcTierLevel + ": Referencia no encontrada en EntitiesConfig"

			Endif

		Catch To oErr
			* DAE 2009-09-02(15:50:26)
			loError = This.oError
			* loError = Newobject( "prxErrorHandler", "prxErrorHandler.prg" )
			loError.Remark = "Entidad: " + Proper( tcObjectName ) + Chr(13) + "Tier: " + Proper( tcTierLevel )
			loError.Process( oErr )
			Throw loError

		Finally
			This.ResetError()

		Endtry

		Return loEntity

	Endproc && GetEntity

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: RemoveEntity
	*!* Description...: Elimina una Entidad de la coleccion
	*!* Date..........: Martes 29 de Abril de 2008 (09:16:49)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure RemoveEntity( cObjectName As String,;
			cTierLevel As String ) As Void;
			HELPSTRING "Elimina una Entidad de la coleccion"


		Local i As Integer
		Local loCollection As Collection
		Local loEntity As Object

		Try

			loCollection = Null
			loEntity = Null

			i = This.GetKey( Lower( cObjectName ) )

			If !Empty( i )
				loCollection = This.Item( i )

				If !Empty( cTierLevel )
					i = loCollection.GetKey( Lower( cObjectName ) + "_" + Lower( cTierLevel ) )

					If !Empty( i )
						loCollection.Remove( i )
					Endif

				Else
					This.Remove( i )

				Endif

			Else
				i = This.GetKey( Lower( cObjectName ) + "_" + Lower( cTierLevel ) )

				If !Empty( i )
					This.Remove( i )
				Endif

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError
		Finally
		Endtry

	Endproc && RemoveEntity

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Process
	*!* Description...:
	*!* Date..........: Martes 4 de Marzo de 2008 (13:09:43)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Process(  ) As Void
		Local lcFileName As String
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Try
			lcFileName = Putfile( "", "ObjectFactoryCfg", "xml" )
			If !Empty( lcFileName )
				This.CreateXML( lcFileName )
			Endif

		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError
		Finally
		Endtry
	Endproc && Process

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateCursor
	*!* Description...: Crea el cursor
	*!* Date..........: Martes 4 de Marzo de 2008 (11:56:03)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure CreateCursor( cCursorName As String ) As Boolean;
			HELPSTRING "Crea el cursor"


		Try

			Local lcCommand As String
			Local loTierRecord As Object
			Local llOk As Boolean

			llOk = .F.

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Cursor <<cCursorName>> (
				ObjectName C(128),
				TierLevel C(128),
				cObjClass C(128),
				cObjClassLibrary C(128),
				cObjClassLibraryFolder C(128),
				cObjComponent C(128),
				lObjInComComponent L )
			ENDTEXT

			&lcCommand

			This.ProcessCollection( This, cCursorName )

			llOk = .T.

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			llOk = .F.
			Throw loError


		Finally

		Endtry

		Return llOk

	Endproc && CreateCursor

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ProcessCollection
	*!* Description...: Recorre las colecciones,
	*!* Date..........: Lunes 14 de Abril de 2008 (13:40:54)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure ProcessCollection( oCol As Collection,;
			cCursorName As String ) As Void;
			HELPSTRING "Recorre las colecciones"


		Try

			For Each loTierRecord In oCol

				If Pemstatus( loTierRecord, "BaseClass", 5 ) ;
						And Lower( loTierRecord.BaseClass ) = "collection" ;
						And Pemstatus( loTierRecord, "oColTiers", 5 )

					This.ProcessCollection( loTierRecord.oColTiers, cCursorName )

				Else

					If Empty( loTierRecord.cObjClass )
						Error loTierRecord.cObjectName + " - " + loTierRecord.TierLevel + ;
							" Falta indicar cObjClass "

					Endif

					If Empty( loTierRecord.cObjClassLibraryFolder )
						Error loTierRecord.cObjectName + " - " + loTierRecord.TierLevel + ;
							" Falta indicar cObjClassLibraryFolder "

					Endif

					If loTierRecord.lObjInComComponent And ;
							Empty( loTierRecord.cObjComponent )
						Error loTierRecord.cObjectName + " - " + loTierRecord.TierLevel + ;
							" Falta indicar cObjComponent  "

					Endif

					If Empty( loTierRecord.cObjClassLibrary )
						loTierRecord.cObjClassLibrary = loTierRecord.cObjClass + ".prg"
					Endif

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Insert into <<cCursorName>> (
					ObjectName,
					TierLevel,
					cObjClass,
					cObjClassLibrary,
					cObjClassLibraryFolder,
					cObjComponent,
					lObjInComComponent ) values (
					'<<loTierRecord.ObjectName>>',
					'<<loTierRecord.TierLevel>>',
					'<<loTierRecord.cObjClass>>',
					'<<loTierRecord.cObjClassLibrary>>',
					'<<loTierRecord.cObjClassLibraryFolder>>',
					'<<loTierRecord.cObjComponent>>',
					<<loTierRecord.lObjInComComponent>> )
					ENDTEXT

					&lcCommand
				Endif

			Endfor

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

	Endproc && ProcessCollection

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateXML
	*!* Description...: Genera el XML
	*!* Date..........: Martes 4 de Marzo de 2008 (11:52:40)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure CreateXML( cFileName As String ) As Boolean;
			HELPSTRING "Genera el XML"


		Try
			Local llOk As Boolean
			Local loXA As Xmladapter
			Local lcAlias As String

			llOk = .F.
			lcAlias = Juststem( cFileName )

			If This.CreateCursor( lcAlias )
				If Lower( Justext( cFileName )) <> "xml"
					cFileName = Addbs( Justpath( cFileName )) + Juststem( cFileName ) + ".xml"
				Endif

				loXA = Createobject( "XMLAdapter" )
				loXA.AddTableSchema( lcAlias  )
				loXA.PreserveWhiteSpace = .T.
				loXA.ToXML( cFileName,"", .T. )
			Endif

			llOk = .T.

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally
			If Used( lcAlias )
				Use In Alias( lcAlias )
			Endif
			loXA = Null

		Endtry

		Return llOk

	Endproc && CreateXML

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Devuelve un objeto TierConfg
	*!* Date..........: Martes 4 de Marzo de 2008 (11:34:00)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure New( cObjectName As String,;
			cTierLevel As String ) As Object;
			HELPSTRING "Devuelve un objeto TierConfg"


		Try
			Local loTierLevel As Object
			Local loReturn As Object

			If Empty( cObjectName )
				Error "cObjectName No puede estar vacía"
			Endif

			If Empty( cTierLevel )
				Error "cTierLevel No puede estar vacía"
			Endif

			loTierLevel = Createobject( "Empty" )
			AddProperty( loTierLevel, "ObjectName", cObjectName )
			AddProperty( loTierLevel, "TierLevel", cTierLevel )
			AddProperty( loTierLevel, "cObjClass", "" )
			AddProperty( loTierLevel, "cObjClassLibrary", "" )
			AddProperty( loTierLevel, "cObjClassLibraryFolder", "" )
			AddProperty( loTierLevel, "cObjComponent", "" )
			AddProperty( loTierLevel, "lObjInComComponent", .F. )

			This.AddItem( loTierLevel, Lower( cObjectName ) + "_" + Lower( cTierLevel ) )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError


		Finally

		Endtry

		Return loTierLevel

	Endproc && New

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Merge
	*!* Description...: Combina 1 un objeto TierConfig con el actual
	*!* Date..........: Lunes 29 de Junio de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Merge( toTierConfig As TierConfig ) As Boolean;
			HELPSTRING "Combina 1 un objeto TierConfig con el actual"
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		Local lcKey As String
		Local lnIndex As Number
		Local loObj As Object
		Try
			If Vartype( toTierConfig ) = 'O'
				* Copio las Objetos
				For i = 1 To toTierConfig.Count
					lcKey = Lower( toTierConfig.GetKey( i ) )
					lnIndex = This.GetKey( lcKey )
					If Empty( lnIndex )
						loObj = toTierConfig.Item( i )
						This.AddItem( loObj, lcKey )
					Endif
				Endfor
			Endif
		Catch To oErr
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError
		Finally
			loError = Null
		Endtry
	Endproc && Merge

Enddefine && TierConfig


Define Class dummy As utArchivo
Enddefine

Define Class dummy As stArchivo
Enddefine

Define Class dummy As bizTierAdapter
Enddefine