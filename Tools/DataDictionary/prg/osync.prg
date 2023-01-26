#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\DataDictionary\Include\DataDictionary.h"

External Procedure ;
	'ErrorHandler\Prg\ErrorHandler.prg',;
	'Tools\DataDictionary\prg\oField.prg',;
	'Tools\Namespaces\Prg\ObjectNamespace.prg',;
	'Tools\DataDictionary\prg\oDataBase.prg',;
	'Tools\DataDictionary\prg\CollectionBase.prg'

*
* oSync
Define Class oSync As SessionBase Of 'Tools\Namespaces\Prg\ObjectNamespace.prg'

	#If .F.
		Local This As oSync Of 'Tools\DataDictionary\prg\osync.prg'
	#Endif

	*!* Objeto para acceder a la base de datos
	oDataEngine = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="odataengine" type="property" display="oDataEngine" />] ;
		+ [<memberdata name="addtableconstraints" type="method" display="AddTableConstraints" />] ;
		+ [<memberdata name="addtableforeignkey" type="method" display="AddTableForeignKey" />] ;
		+ [<memberdata name="altertable" type="method" display="AlterTable" />] ;
		+ [<memberdata name="createtable" type="method" display="CreateTable" />] ;
		+ [<memberdata name="createindexes" type="method" display="CreateIndexes" />] ;
		+ [<memberdata name="generateindexes" type="method" display="GenerateIndexes" />] ;
		+ [<memberdata name="open" type="method" display="Open" />] ;
		+ [<memberdata name="process" type="method" display="Process" />] ;
		+ [<memberdata name="processdatabase" type="method" display="ProcessDataBase" />] ;
		+ [<memberdata name="processtable" type="method" display="ProcessTable" />] ;
		+ [<memberdata name="set" type="method" display="Set" />] ;
		+ [<memberdata name="initializedata" type="method" display="InitializeData" />] ;
		+ [<memberdata name="getdatatype" type="method" display="GetDataType" />] ;
		+ [<memberdata name="synchronize" type="method" display="Synchronize" />] ;
		+ [<memberdata name="packtable" type="method" display="PackTable" />] ;
		+ [</VFPData>]

	*
	* AddTableForeignKey
	Protected Procedure AddTableForeignKey ( toTable As oTable ) As Void

		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally


		EndTry
		
	Endproc && AddTableForeignKey

	*
	* AddTableConstraints
	Protected Procedure AddTableConstraints ( toTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg' ) As Void


		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally


		Endtry

	Endproc && AddTableConstraints

	*
	* Sincroniza la Tabla con la definición de la misma
	Procedure Synchronize( toTable As Object ) As Boolean ;
			HELPSTRING "Sincroniza la Tabla con la definición de la misma"


		Local llOk as Boolean 
		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally


		Endtry

		Return llOk

	Endproc && Synchronize

	Procedure AlterTable ( toTable As Object ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally


		Endtry

	Endproc && AlterTable

	*
	* CreateTable
	Procedure CreateTable( toTable As oTable ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally


		Endtry

	Endproc && CreateTable


	* RA 2014-09-01(18:42:22)
	Procedure CreateIndexes( tnIndexKey As Integer,;
			toTable As oTable ) As Void;
			HELPSTRING "Genera los indices asociados a la tabla"

		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally


		Endtry

	Endproc  && CreateIndexes

	*
	* Genera la Coleccion Indicesº
	Procedure GenerateIndexes( toTable As oTable ) As Void;
			HELPSTRING "Genera la Coleccion Indices"

		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally


		Endtry

	Endproc && GenerateIndexes


	*
	* Comprime la tabla
	Procedure PackTable( toTable As Object ) As Void;
			HELPSTRING "Comprime la tabla"
			
		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally


		Endtry

	Endproc && PackTable

	* GetDataType
	* Devuelve el tipo de dato correspondiente al motor de la base de datos
	Protected Procedure GetDataType () As String HelpString 'Devuelve el tipo de dato correspondiente al motor de la base de datos'

		Local lcRet As String, ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

		#If .F.

			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve el tipo de dato correspondiente al motor de la base de datos
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Jueves 17 de Septiembre de 2009 (14:10:04)
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
			String
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Try



		Catch To loErr
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			Throw m.loError

		Finally
			loError = Null

		Endtry

		Return m.lcRet

	Endproc && GetDataType

	*
	* InitializeData
	Procedure InitializeData ( uParam As Variant ) As Void

	Endproc && Initializedata

	*
	* Open
	* Abre la conexión a la base de datos.
	Protected Procedure Open( toDataBase As oDataBase ) As Integer ;
		HelpString 'Abre la conexión a la base de datos.'

		Return = This.oDataEngine.Connect()

	Endproc && Open

	*
	* Process
	Procedure Process ( toColDataBases As ColDataBases,;
			lSilence As Boolean  ) As Void HelpString 'Procesa la colección de base de datos.'

		Local lnColDataBasesCount As Number,;
			lnIdx As Number

		Local loDataBase As oDataBase Of 'Tools\DataDictionary\prg\oDataBase.prg'

		Local lcCommand As String

		Try

			lcCommand = ""

			If Vartype ( m.toColDataBases ) = 'O'
				lnColDataBasesCount = m.toColDataBases.Count
				For lnIdx = 1 To m.lnColDataBasesCount
					loDataBase = m.toColDataBases.Item[ m.lnIdx ]
					This.ProcessDataBase ( m.loDataBase,;
						m.lSilence )

				Next

			Else
				Error 'Argumento invalido toColDataBases. Se esperaba un objeto '


			Endif && Vartype( m.toColDataBases ) = 'O'


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loDataBase = Null

		Endtry

	Endproc && Process

	* ProcessDataBase
	* Procesa la base de datos. Crea o actualiza todas las tablas.
	Procedure ProcessDataBase ( toDataBase As oDataBase,;
			lSilence As Boolean ) HelpString 'Procesa la base de datos. Crea o actualiza todas las tablas.'

		Local lnColTablesCount As Integer
		Local lnIdx As Number
		Local loColTables As CollectionBase Of 'Tools\Namespaces\Prg\CollectionBase.prg', ;
			loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

		Local lcCommand As String

		Try

			lcCommand = ""

			If Vartype ( m.toDataBase ) = 'O'

				m.toDataBase.ReadIniFile()
				m.toDataBase.CreateDirIfNotExists( m.toDataBase.cFolder )
				m.toDataBase.CargarTablas()

				m.toDataBase.ConnectToBackend()

				loColTables      = m.toDataBase.oColTables
				lnColTablesCount = m.loColTables.Count
				For lnIdx = 1 To m.lnColTablesCount
					loTable = loColTables.Item( m.lnIdx )
					This.ProcessTable ( m.loTable,;
						m.lSilence )

				Next

				toDataBase.FillTables()

			Else
				Error 'Argumento invalido toDataBase. Se esperaba un objeto.'

			Endif && Vartype( toDataBase ) = 'O'

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loTable = Null

		Endtry


	Endproc && ProcessDataBase


	*
	* ProcessTable
	Procedure ProcessTable ( toTable As oTable,;
			lPackTable As Boolean,;
			lSilence As Boolean ) As Void

		Local lcCommand As String,;
			lcMsg As String
		Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg"

		Try

			lcCommand = ""
			loTable = toTable

			If Vartype ( loTable ) == 'O'

				TEXT To lcMsg NoShow TextMerge Pretext 03
				Sincronizando <<loTable.cLongTableName>> . . .
				ENDTEXT

				lcCommand = lcMsg

				If !lSilence
					Wait Window Nowait Noclear lcMsg
				Endif


				This.CreateTable ( loTable )
				This.InitializeData ( loTable )
				This.AddTableConstraints ( loTable )
				This.AddTableForeignKey ( loTable )

				If lPackTable
					This.PackTable( loTable )
				Endif

				This.CreateIndexes( 0, loTable )

			Else
				Error 'Argumento invalido toTable. Se esperaba un objeto '

			Endif && Vartype( toTable ) = 'O'

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally

		Endtry

	Endproc && ProcessTable

	Protected Procedure Set() As Void

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Jueves 17 de Septiembre de 2009
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

	Endproc && Set

Enddefine && oSync
