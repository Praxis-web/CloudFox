#Include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'
#Include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
	Do 'ErrorHandler\Prg\ErrorHandler.prg'
	Do 'Tools\Namespaces\Prg\CollectionBase.prg'
	Do 'Tools\DataDictionary\prg\oBase.prg'
	Do 'Tools\DataDictionary\prg\oColTables.prg'
	Do 'Tools\DataDictionary\prg\oField.prg'
	Do 'Tools\DataDictionary\prg\oColStoreProcedures.prg'
	Do 'Tools\DataDictionary\prg\oStoreProcedure.prg'

Endif

* oDataBase
* Clase base de datos.
Define Class oDataBase As oBase Of 'Tools\DataDictionary\prg\oBase.prg'

	#If .F.
		Local This As oDataBase Of 'Tools\DataDictionary\prg\oDataBase.prg'
	#Endif

	#If .F.
		TEXT
			 *:Help Documentation
			 *:Description:
			 Clase base de datos.
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damián Eiff
			 *:Date:
			 Martes 29 de Mayo de 2007 (11:00:34)
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

	Dimension m.oColTables_COMATTRIB[ 4 ]
	oColTables_COMATTRIB[ 1 ] = 0
	oColTables_COMATTRIB[ 2 ] = 'Colección de tablas.'
	oColTables_COMATTRIB[ 3 ] = 'oColTables'
	oColTables_COMATTRIB[ 4 ] = 'ColTables'

	* Colección Tables
	oColTables = Null

	Dimension m.cFolder_COMATTRIB[ 4 ]
	cFolder_COMATTRIB[ 1 ] = 0
	cFolder_COMATTRIB[ 2 ] = 'Carpeta donde se encuentra la base de datos.'
	cFolder_COMATTRIB[ 3 ] = 'cFolder'
	cFolder_COMATTRIB[ 4 ] = 'String'

	* Carpeta donde se encuentra la base de datos.
	cFolder = ''

	Dimension m.cExt_COMATTRIB[ 4 ]
	cExt_COMATTRIB[ 1 ] = 0
	cExt_COMATTRIB[ 2 ] = 'Extensión del archivo de la base de datos.'
	cExt_COMATTRIB[ 3 ] = 'cExt'
	cExt_COMATTRIB[ 4 ] = 'String'

	* Extensión del archivo de la base de datos.
	cExt = 'DBC'

	Dimension m.cDataConfigurationKey_COMATTRIB[ 4 ]
	cDataConfigurationKey_COMATTRIB[ 1 ] = 0
	cDataConfigurationKey_COMATTRIB[ 2 ] = 'Nombre de la base de datos en el archivo de configuración.'
	cDataConfigurationKey_COMATTRIB[ 3 ] = 'cDataConfigurationKey'
	cDataConfigurationKey_COMATTRIB[ 4 ] = 'String'

	* Nombre de la base de datos en el archivo de configuración.
	cDataConfigurationKey = ''

	Dimension m.cIniFileName_COMATTRIB[ 4 ]
	cIniFileName_COMATTRIB[ 1 ] = 0
	cIniFileName_COMATTRIB[ 2 ] = 'Nombre del archivo de inicialización.'
	cIniFileName_COMATTRIB[ 3 ] = 'cIniFileName'
	cIniFileName_COMATTRIB[ 4 ] = 'String'

	* Nombre del archivo de inicialización.
	cIniFileName = ''

	DataSession = SET_DEFAULT

	Dimension m.cProjectPath_COMATTRIB[ 4 ]
	cProjectPath_COMATTRIB[ 1 ] = 0
	cProjectPath_COMATTRIB[ 2 ] = 'Ruta del proyecto.  '
	cProjectPath_COMATTRIB[ 3 ] = 'cProjectPath'
	cProjectPath_COMATTRIB[ 4 ] = 'String'

	* Ruta del proyecto.
	cProjectPath = ''

	Dimension m.cProjectName_COMATTRIB[ 4 ]
	cProjectName_COMATTRIB[ 1 ] = 0
	cProjectName_COMATTRIB[ 2 ] = 'Nombre del proyecto.'
	cProjectName_COMATTRIB[ 3 ] = 'cProjectName'
	cProjectName_COMATTRIB[ 4 ] = 'String'

	* Nombre del proyecto.
	cProjectName = ''

	Dimension m.oColStoreProcedures_COMATTRIB[ 4 ]
	oColStoreProcedures_COMATTRIB[ 1 ] = 0
	oColStoreProcedures_COMATTRIB[ 2 ] = 'Colección de store procedures.'
	oColStoreProcedures_COMATTRIB[ 3 ] = 'oColStoreProcedures'
	oColStoreProcedures_COMATTRIB[ 4 ] = 'ColStoreProcedures'

	* Colección de store procedures.
	oColStoreProcedures = Null

	Dimension m.lExcludeFromDataDictionary_COMATTRIB[ 4 ]
	lExcludeFromDataDictionary_COMATTRIB[ 1 ] = 0
	lExcludeFromDataDictionary_COMATTRIB[ 2 ] = 'Indica si la base de datos será excluída del diccionario de datos.'
	lExcludeFromDataDictionary_COMATTRIB[ 3 ] = 'lExcludeFromDataDictionary'
	lExcludeFromDataDictionary_COMATTRIB[ 4 ] = 'Boolean'

	* Indica si la base de datos será excluída del diccionario de datos.
	lExcludeFromDataDictionary = .F.

	Dimension m.lProcess_COMATTRIB[ 4 ]
	lProcess_COMATTRIB[ 1 ] = 0
	lProcess_COMATTRIB[ 2 ] = 'Indica si se realiza el procesamiento de la base de datos.'
	lProcess_COMATTRIB[ 3 ] = 'lProcess'
	lProcess_COMATTRIB[ 4 ] = 'Boolean'

	* Indica si se realiza el procesamiento de la base de datos.
	lProcess = .T.

	oConnection = Null
	oBackEnd = Null
	cAccessType = "NATIVE"
	cBackEndEngine = "FOX"
	cBackEndCfgFileName = ""
	cDataBaseName = ''
	cStringConnection = ''
	cDataConfigurationKey = ""


	Protected m._MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="lprocess" type="property" display="lProcess" />] ;
		+ [<memberdata name="lexcludefromdatadictionary" type="property" display="lExcludeFromDataDictionary" />] ;
		+ [<memberdata name="cfolder" type="property" display="cFolder" />] ;
		+ [<memberdata name="cext" type="property" display="cExt" />] ;
		+ [<memberdata name="ocolstoreprocedures" type="property" display="oColStoreProcedures" />] ;
		+ [<memberdata name="cDataConfigurationKey" type="property" display="cDataConfigurationKey" />] ;
		+ [<memberdata name="cinifilename" type="property" display="cIniFileName" />] ;
		+ [<memberdata name="ocoltables" type="property" display="oColTables" />] ;
		+ [<memberdata name="ocoltables_access" type="property" display="oColTables_Access" />] ;
		+ [<memberdata name="cprojectpath" type="propertie" display="cProjectPath" />] ;
		+ [<memberdata name="cprojectname" type="property" display="cProjectName" />] ;
		+ [<memberdata name="initialize" type="method" display="Initialize" />] ;
		+ [<memberdata name="merge" type="method" display="Merge" />] ;
		+ [<memberdata name="classafterinit" type="method" display="ClassAfterInit" />] ;
		+ [<memberdata name="cbackendengine" type="property" display="cBackEndEngine" />] ;
		+ [<memberdata name="caccesstype" type="property" display="cAccessType" />] ;
		+ [<memberdata name="obackend" type="property" display="oBackEnd" />] ;
		+ [<memberdata name="obackend_access" type="method" display="oBackEnd_Access" />] ;
		+ [<memberdata name="oconnection" type="property" display="oConnection" />] ;
		+ [<memberdata name="cbackendcfgfilename" type="property" display="cBackEndCfgFileName" />] ;
		+ [<memberdata name="cbackendcfgfilename_access" type="method" display="cBackEndCfgFileName_Access" />] ;
		+ [<memberdata name="cstringconnection" type="property" display="cStringConnection" />] ;
		+ [<memberdata name="cdatabasename" type="property" display="cDataBaseName" />] ;
		+ [<memberdata name="cdataconfigurationkey" type="property" display="cDataConfigurationKey" />] ;
		+ [<memberdata name="connecttobackend" type="method" display="ConnectToBackend" />] ;
		+ [<memberdata name="disconnectfrombackend" type="method" display="DisconnectFromBackend" />] ;
		+ [</VFPData>]

	* ClassAfterInit
	* Valida que las tablas en la base de datos esten correctamente configuradas, calcula y asigna el nivel de jerarquia de las tablas.
	Protected Procedure ClassAfterInit() As Void HelpString 'Valida que las tablas en la base de datos esten correctamente configuradas, calcula y asigna el nivel de jerarquia de las tablas.'

		Local lcExp As String, ;
			lcPadre As String, ;
			liIdx As Integer, ;
			lijQ As Integer, ;
			liq As Integer, ;
			llOk As Boolean, ;
			loColData As CollectionBase Of 'Tools\Namespaces\Prg\CollectionBase.prg', ;
			loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
			loFldFK As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
			loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg', ;
			loTablePadre As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

		#If .F.
			TEXT
				*:Help Documentation
				*:Topic:
				*:Description:
				Valida que las tablas en la base de datos esten correctamente configuradas, calcula y asigna el nivel de jerarquia de las tablas
				*:Project:
				Sistemas Praxis
				*:Autor:
				Damian Eiff
				*:Date:
				Jueves 23 de Julio de 2009 (18:29:19)
				*:ModiSummary:
				*:Syntax:
				*:Example:
				*:Events:
				*:NameSpace:
				praxis.com
				*:Keywords:
				*:Implements:
				*:Inherits:
				*:Parameters:
				*:Remarks:
				*:Returns:
				Void
				*:Exceptions:
				*:SeeAlso:
				*:EndHelp
			ENDTEXT
		#Endif

		Try
			loColTables = This.oColTables
			For liq = 1 To m.loColTables.Count
				loTable = m.loColTables.Item[ m.liq ]
				lcPadre = Alltrim ( Lower ( m.loTable.cPadre ) )
				If ! Empty ( m.lcPadre )
					loColData = Null
					* Obtengo las FK a la tabla padre
					lcExp     = ' Lower( Alltrim( cReferences ) ) == "' + m.lcPadre + '" '
					loColData = loTable.oColFields.Where ( m.lcExp )
					Assert m.loColData.Count # 0 Message 'No existe la referencia.'

					If m.loColData.Count > 0
						For lijQ = 1 To m.loColData.Count
							loFldFK             = m.loColData.Item[ m.lijQ ]
							loFldFK.nComboOrder = Iif ( Empty ( m.loFldFK.nComboOrder ), -1, m.loFldFK.nComboOrder )

						Endfor

						llOk = .F.

						* Obtengo la referencia del padre
						loTablePadre = m.loColTables.GetItem ( m.lcPadre )

						If Vartype ( m.loTablePadre ) # 'O'
							For liIdx = 1 To m.loColData.Count
								loField = m.loColData.Item[ m.liIdx ]

								If m.lcPadre == Lower ( m.loField.cReferences )
									If ! Empty ( m.loField.cParentKeyName )
										loTablePadre = m.loColTables.GetItem ( m.loField.cParentKeyName )

									Endif && ! Empty( m.loField.cParentKeyName )

									llOk = ( Vartype ( m.loTablePadre ) == 'O' )
									Exit

								Endif && m.lcPadre = Lower( m.loField.References )

							Endfor

						Else && Vartype( m.loTablePadre ) # "O"
							llOk = .T.

						Endif && Vartype( m.loTablePadre ) # "O"

						If ! m.llOk
							Error 'No existe en la tabla ' + m.loTable.Name + ' ningun campo que haga referencia a la tabla ' + m.lcPadre

						Endif && ! llOk

						* Agrego la referencia de la tabla a la colección de tablas del padre
						m.loTablePadre.oColTables.AddTable ( m.loTable, .T. )

						* Obtengo la clave primaria del padre
						loField             = m.loTablePadre.GetPrimaryKey()
						loTable.cForeignKey = m.loField.Name

					Else
						Error 'No existe en la tabla ' + m.loTable.Name + ' ningun campo que haga referencia a la tabla ' + m.lcPadre

					Endif && m.loColData.Count > 0

				Endif && ! Empty( m.loTable.Padre )

			Endfor

			For liq = 1 To m.loColTables.Count
				loTable = m.loColTables.Item[ m.liq ]
				If Empty ( m.loTable.cPadre )
					* Calculo la Jerarquia de tablas
					* nNivelJerarquiaTablas indica la cantidad máxima de niveles que cuelgan de una tabla dada, incluyéndose a si misma.
					* En Padre-Hijo-Nieto, nNivelJerarquiaTablas para:
					* 	Padre = 3
					*	Hijo = 2
					* 	Nieto = 1
					* El Nivel indica el lugar que ocupa dentro de la jeraquía:
					* 	Padre = 1
					* 	Hijo  = 2
					* 	Nieto = 3

					loTable.nNivel                = 1
					loTable.nNivelJerarquiaTablas = m.loTable.oColTables.AssignLevel ( m.loTable.oColTables, 2, 1 )

					* Assigno el nivel de jerarquia a las tablas hijas
					m.loTable.oColTables.AssignNivelJerarquiaTablas ( m.loTable.oColTables, m.loTable.nNivelJerarquiaTablas - 1 )

					* Asigno la referencia al Main
					m.loTable.oColTables.AssignMain ( m.loTable.oColTables, m.loTable )

				Endif && Empty( m.loTable.Padre )

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError      = Null
			loTable      = Null
			loTablePadre = Null
			loColData    = Null
			loField      = Null
			loColTables  = Null
			loFldFK      = Null

		Endtry

	Endproc && ClassAfterInit

	* oColTables_Access
	* Devuelve la colección de tablas, propiedad implementada como carga perezosa (lazy load).
	Protected Function oColTables_Access() As oColTables Of 'DataDictionary\prg\oColTables.prg' ;
			HelpString 'Devuelve la colección de tablas, propiedad implementada como carga perezosa (lazy load).'

		If Vartype ( This.oColTables ) # 'O'
			This.oColTables         = _NewObject ( 'oColTables', 'DataDictionary\prg\oColTables.prg' )
			This.oColTables.oParent = This

		Endif && Vartype( This.oColTables ) # 'O'

		Return This.oColTables

	Endfunc && oColTables_Access

	*
	* oColStoreProcedures_Access
	* Devuelve la colección de stored procedures, propiedad implementada como carga perezosa (lazy load).
	Protected Function oColStoreProcedures_Access() As oColStoreProcedures Of 'Tools\DataDictionary\prg\oColStoreProcedures.prg' HelpString 'Devuelve la colección de stored procedures, propiedad implementada como carga perezosa (lazy load).'

		If Vartype ( This.oColStoreProcedures ) # 'O'
			* This.oColStoreProcedures         = Newobject ( 'ColStoreProcedures', 'DataDictionary\prg\ColStoreProcedures.prg' )
			This.oColStoreProcedures         = _NewObject ( 'oColStoreProcedures', 'Tools\DataDictionary\prg\oColStoreProcedures.prg' )
			This.oColStoreProcedures.oParent = This

		Endif && Vartype( This .oColStoreProcedures ) # 'O'

		Return This.oColStoreProcedures

	Endfunc && oColStoreProcedures_Access

	* Init
	* Constructor de la base de datos.
	Protected Procedure Init ( tuProcess As Variant ) As Boolean HelpString 'Constructor de la base de datos.'

		Local lcDBId As String, ;
			lcDataBases As String, ;
			llOk As Boolean, ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

		#If .F.
			TEXT
				*:Help Documentation
				*:Topic:
				*:Description:
				Constructor de la base de datos.
				*:Project:
				Sistemas Praxis
				*:Autor:
				Damián Eiff
				*:Date:
				Jueves 17 de Abril de 2008 (10:05:18)
				*:ModiSummary:
				*:Syntax:
				*:Example:
				*:Events:
				*:NameSpace:
				praxis.com
				*:Keywords:
				*:Implements:
				*:Inherits:
				*:Parameters:
				tuProcess As Variant
				*:Remarks:
				*:Returns:
				Boolean
				*:Exceptions:
				*:SeeAlso:
				*:EndHelp
			ENDTEXT
		#Endif

		Try

			llOk        = .F.
			lcDataBases = m.CacheManager.Get ( 'cDataBases' )
			If Isnull ( m.lcDataBases ) Or Empty ( m.lcDataBases )
				lcDataBases = ''
				If ! m.CacheManager.Exists ( 'cDataBases' )
					m.CacheManager.Add ( '', 'cDataBases' )

				Endif

			Endif && Isnull ( m.lcDataBases ) Or Empty ( m.lcDataBases )

			TEXT To m.lcDBId Textmerge Noshow Pretext 15
					#<<This.Name>>#,
			ENDTEXT

			If Empty ( Atc ( m.lcDBId, m.lcDataBases ) )

				* This.oColTables         = Newobject ( 'ColTables', 'DataDictionary\prg\ColTables.prg' )
				This.oColTables         = _NewObject ( 'oColTables', 'Tools\DataDictionary\prg\oColTables.prg' )
				This.oColTables.oParent = This

				llOk = .T.
				lcDataBases = m.lcDataBases + m.lcDBId

				This.lProcess = Empty ( m.tuProcess )
				* This.ReadIniFile()
				This.Initialize()

				If This.lProcess
					This.ClassAfterInit()

				Endif && this.lProcess

				m.CacheManager.Update ( m.lcDataBases, 'cDataBases' )

			Endif && Empty( Atc( m.lcDBId, m.lcDataBases ) )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tuProcess
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError = Null

		Endtry

		Return m.llOk

	Endproc && Init



	* Initialize
	* Template Method
	Procedure Initialize( uParam As Variant ) As Void HelpString 'Template method.'

		#If .F.
			TEXT
				*:Help Documentation
				*:Topic:
				*:Description:
				Template Method
				*:Project:
				Sistemas Praxis
				*:Autor:
				Damián Eiff
				*:Date:
				Jueves 17 de Abril de 2008 (10:05:18)
				*:ModiSummary:
				*:Syntax:
				*:Example:
				*:Events:
				*:NameSpace:
				praxis.com
				*:Keywords:
				*:Implements:
				*:Inherits:
				*:Parameters:
				*:Remarks:
				*:Returns:
				Void
				*:Exceptions:
				*:SeeAlso:
				*:EndHelp
			ENDTEXT
		#Endif

	Endproc && Initialize

	Dimension Merge_COMATTRIB[ 5 ]
	Merge_COMATTRIB[ 1 ] = 0
	Merge_COMATTRIB[ 2 ] = 'Devuelve .T. si la base de datos actual se combino correctamente con la base de datos dada.'
	Merge_COMATTRIB[ 3 ] = 'Merge'
	Merge_COMATTRIB[ 4 ] = 'Boolean'
	* Merge_COMATTRIB[ 5 ] = 0

	* Merge
	* Devuelve .T. si la base de datos actual se combino correctamente con la base de datos dada.
	Function Merge ( toDataBase As Object ) As Boolean HelpString 'Devuelve .T. si la base de datos actual se combino correctamente con la base de datos dada.'

		Local lcKey As String, ;
			liIdx As Integer, ;
			lnIndex As Number, ;
			loColStoreProcedures As oStoreProcedure Of 'Tools\DataDictionary\prg\oColStoreProcedures.prg', ;
			loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loOtherColStoreProcedures As oStoreProcedure Of 'Tools\DataDictionary\prg\oColStoreProcedures.prg', ;
			loOtherColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
			loStoreProcedure As oStoreProcedure Of 'Tools\DataDictionary\prg\oStoreProcedure.prg', ;
			loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

		#If .F.
			TEXT
				*:Help Documentation
				*:Topic:
				*:Description:
				Devuelve .T. si la base de datos actual se combino correctamente con la base de datos dada.
				*:Project:
				Sistemas Praxis
				*:Autor:
				Damian Eiff
				*:Date:
				Viernes 26 de Junio de 2009 (10:30:13)
				*:ModiSummary:
				*:Syntax:
				*:Example:
				*:Events:
				*:NameSpace:
				praxis.com
				*:Keywords:
				*:Implements:
				*:Inherits:
				*:Parameters:
				toDataBase As oDataBase
				*:Remarks:
				*:Returns:
				Boolean
				*:Exceptions:
				*:SeeAlso:
				*:EndHelp
			ENDTEXT
		#Endif

		Try

			If Vartype ( m.toDataBase ) == 'O'
				* Copio las tablas
				loColTables      = This.oColTables
				loOtherColTables = m.toDataBase.oColTables
				For liIdx = 1 To loOtherColTables.Count
					lcKey   = loOtherColTables.GetKey ( m.liIdx )
					lnIndex = loColTables.GetKey ( m.lcKey )
					If Empty ( m.lnIndex )
						loTable = loOtherColTables.Item[ m.liIdx ]
						loColTables.AddTable ( m.loTable )

					Else
						loTable = loOtherColTables .Item [ i ]
						If loTable.lForce
							loColTables.Remove ( lcKey )
							loColTables.AddTable ( loTable )

						Endif && loTable.lForce

					Endif && Empty( m.lnIndex )

				Endfor

				* Copio los Store Procedures
				loColStoreProcedures      = This.oColStoreProcedures
				loOtherColStoreProcedures = m.toDataBase.oColStoreProcedures
				For liIdx = 1 To loOtherColStoreProcedures.Count
					lcKey   = loOtherColStoreProcedures.GetKey ( m.liIdx )
					lnIndex = loColStoreProcedures.GetKey ( m.lcKey )
					If Empty ( m.lnIndex )
						loStoreProcedure = loOtherColStoreProcedures.Item[ m.liIdx ]
						loColStoreProcedures.New ( m.loStoreProcedure.cFileName, m.loStoreProcedure.cCodigo )

					Endif && Empty( m.lnIndex )

				Endfor

			Endif && Vartype( m.toDataBase ) == 'O'

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError          = Null
			loTable          = Null
			loStoreProcedure = Null

		Endtry

		Return .T.

	Endfunc && Merge

	*
	* ConnectToBackend
	*!*		Protected Function ConnectToBackend() As Boolean
	Function ConnectToBackend() As Boolean
		Local lnReturn As Integer


		Try

			lnReturn = This.oBackEnd.Connect()
			This.oConnection = This.oBackEnd.oConnection

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError


		Finally

		Endtry

		Return lnReturn

	Endfunc && ConnectToBackend


	*-----------------------------------
	* Se desconecta de la base de datos.
	*-----------------------------------
	*!*		Protected Function DisconnectFromBackend() As Boolean
	Function DisconnectFromBackend() As Boolean

		Local llOk As Boolean
		Try

			llOk = This.oBackEnd.DisConnect()

			This.oConnection = This.oBackEnd.oConnection

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return This.lIsOk

	Endfunc && DisconnectFromBackend

	*
	* oBackEnd_Access
	Protected Procedure oBackEnd_Access()

		If Vartype( This.oBackEnd ) # "O"
			Do Case
				Case Upper(This.cAccessType)="NATIVE"
					This.oBackEnd = Newobject( "NativeBackEnd",;
						"fw\tieradapter\datatier\BackEndNative.prg" )

					This.oBackEnd.lUseDBC = .T.
					This.oBackEnd.lUseTransactions = .T.

				Case Upper(This.cAccessType)="ODBC"
					This.oBackEnd = Newobject( "ODBCBackEnd",;
						"BackEndODBC.prg" )

				Case Upper(This.cAccessType)="ADO"
					This.oBackEnd = Newobject( "ADOBackEnd",;
						"BackEndADO.prg" )

				Otherwise
					Error "Data Access Type Not Recognized"

			Endcase

			With This.oBackEnd As BackEnd Of "TierAdapter\DataTier\BackEnd.prg"
				.cDataBaseName 		= This.cDataBaseName
				.cStringConnection 	= This.cStringConnection
				.cBackEndEngine 	= This.cBackEndEngine
			Endwith

		Endif

		Return This.oBackEnd

	Endproc && oBackEnd_Access

	*
	* cDataBaseName_Access
	Protected Procedure cBackEndCfgFileName_Access()

		If Empty( This.cBackEndCfgFileName )
			This.cBackEndCfgFileName = Addbs( This.cRootFolder ) + "DataTier.xml"
		Endif
		Return This.cBackEndCfgFileName

	Endproc && cBackEndCfgFileName _Access


	Procedure ReadIniFile(  ) As Boolean;
			HELPSTRING "Leer el archivo de inicialización"

		Local loConfigData As Object
		Local lcCommand As String
		Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'


		Try

			lcCommand = ""

			If Empty( This.cDataBaseName )

				m.loXA = _NewObject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

				loXA.LoadXML( This.cBackEndCfgFileName, .T. )
				loXA.Tables(1).ToCursor()
				loXA = Null

				Locate For Alltrim( Lower( objName )) = Alltrim( Lower( This.cDataConfigurationKey ))
				If Eof()
					Locate For Alltrim( Lower(objName)) = "default"
				Endif

				This.cAccessType       = Alltrim(AccessType)
				This.cDataBaseName     = Alltrim(dbName)
				This.cStringConnection = Alltrim(StrConn)
				This.cBackEndEngine    = Iif(Empty(Alltrim(BkEngine)),"FOX",Alltrim(BkEngine))
				*!*					This.lDebugMode 	   = DebugComponent

				Use In Alias()

				*!*					Local loConfigData As Object
				*!*					loConfigData = Createobject( "Empty" )
				*!*					AddProperty( loConfigData, "cAccessType", This.cAccessType )
				*!*					AddProperty( loConfigData, "cDataBaseName", This.cDataBaseName )
				*!*					AddProperty( loConfigData, "cStringConnection", This.cStringConnection )
				*!*					AddProperty( loConfigData, "cBackEndEngine", This.cBackEndEngine )

				*!*					This.PopulateConfigData( loConfigData )

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return This.lIsOk

	Endproc && ReadIniFile





Enddefine && oDataBase
