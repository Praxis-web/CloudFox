#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
	Do 'ErrorHandler\Prg\ErrorHandler.prg'
	Do 'Tools\DataDictionary\prg\oColBase.prg'
	Do 'Tools\DataDictionary\prg\oDataBase.prg'

Endif

* oColDataBases
* Colección de bases de datos.
Define Class oColDataBases As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'

	#If .F.
		Local This As oColDataBases Of 'Tools\DataDictionary\prg\oColDataBases.prg'
	#Endif

	#If .F.
		TEXT
		 *:Help Documentation
		 *:Description:
		 Colección de bases de datos
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

	cProjectPath = ''

	*Nombre del projecto.
	cProjectName = ''

	* Objeto projecto.
	oProject = Null

	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="adddatabase" type="event" display="AddDatabase" />] ;
		+ [<memberdata name="new" type="method" display="New" />] ;
		+ [<memberdata name="gettable" type="method" display="GetTable" />] ;
		+ [<memberdata name="cprojectpath" type="propertie" display="cProjectPath" />] ;
		+ [<memberdata name="cprojectname" type="property" display="cProjectName" />] ;
		+ [<memberdata name="cprojectname_access" type="method" display="cProjectName_Access" />] ;
		+ [<memberdata name="oproject" type="property" display="oProject" />] ;
		+ [<memberdata name="oproject_access" type="method" display="oProject_Access" />] ;
		+ [</VFPData>]

	Dimension AddDatabase_COMATTRIB[ 5 ]
	AddDatabase_COMATTRIB[ 1 ] = 0
	AddDatabase_COMATTRIB[ 2 ] = 'Agrega una base de datos a la colección.'
	AddDatabase_COMATTRIB[ 3 ] = 'AddDatabase'
	AddDatabase_COMATTRIB[ 4 ] = 'Void'
	* AddDatabase_COMATTRIB[ 5 ] = 0

	* AddDatabase
	* Agrega una base de datos a la colección.
	Procedure AddDatabase ( toDataBase As oDataBase  ) As Void HelpString 'Agrega una base de datos a la colección.'

		Local lcKey As String, ;
			liIdx As Integer, ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

		#If .F.
			TEXT
				*:Help Documentation
				*:Topic:
				*:Description:
				Agrega una base de datos a la colección.
				*:Project:
				Sistemas Praxis
				*:Autor:
				Damián Eiff
				*:Date:
				Martes 29 de Mayo de 2007 (11:04:54)
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
				toDataBase As oDataBase Of 'Tools\DataDictionary\prg\oDataBase.prg'
				*:Remarks:
				*:Returns:
				Void
				*:Exceptions:
				*:SeeAlso:
				*:EndHelp
			ENDTEXT
		#Endif

		Try
			If Vartype ( m.toDataBase ) == 'O'
				lcKey = Lower ( m.toDataBase.Name )
				liIdx = This.GetKey ( m.lcKey )

				If Empty ( m.liIdx )
					toDataBase.oParent = This
					This.AddItem ( m.toDataBase, m.lcKey )

				Endif && Empty( m.liIdx )

			Endif && Vartype( toDataBase ) == 'O'

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toDataBase
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError = Null

		Endtry

	Endproc && AddDatabase

	Dimension New_COMATTRIB[ 5 ]
	New_COMATTRIB[ 1 ] = 0
	New_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de la clase oDataBase.'
	New_COMATTRIB[ 3 ] = 'New'
	New_COMATTRIB[ 4 ] = 'oDatabase'
	* New_COMATTRIB[ 5 ] = 0

	* New
	* Devuelve una nueva instancia de la clase oDataBase.
	Function New ( tcName As String ) As oDataBase Of 'Tools\DataDictionary\prg\oDatabase.prg' HelpString 'Devuelve una nueva instancia de la clase oDatabase.'

		Local loDataBase As oDataBase Of 'Tools\DataDictionary\prg\oDatabase.prg', ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

		#If .F.
			TEXT
				*:Help Documentation
				*:Topic:
				*:Description:
				Devuelve una nueva instancia de la clase oDatabase.
				*:Project:
				Sistemas Praxis
				*:Autor:
				Damián Eiff
				*:Date:
				Martes 29 de Mayo de 2007 (11:13:53)
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
				tcName As String
				*:Remarks:
				*:Returns:
				 oDataBase Of 'Tools\DataDictionary\prg\oDataBase.prg'
				*:Exceptions:
				*:SeeAlso:
				*:EndHelp
			ENDTEXT
		#Endif

		Try
			If ! Empty ( m.tcName )
				* loDataBase      = Newobject ( 'oDataBase', 'DataDictionary\prg\oDataBase.prg'  )
				loDataBase      = _NewObject ( 'oDataBase', 'Tools\DataDictionary\prg\oDataBase.prg'  )
				loDataBase.Name = Alltrim ( m.tcName )

				This.AddDatabase ( m.loDataBase )
			Else
				loDataBase = Null

			Endif && ! Empty( m.tcName )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcName
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError = Null

		Endtry

		Return m.loDataBase

	Endfunc && New

	*
	*
	Procedure GetTable( cTable As String,;
			dbId As Integer ) As Object
		Local lcCommand As String
		Local loColTables As oColArchivos Of "Clientes\Utiles\Prg\utRutina.prg", ;
			loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
			loDataBase As oDataBase Of 'Tools\DataDictionary\prg\oDataBase.prg'
			

		Try

			lcCommand = ""

			If Empty( dbId )
				dbId = 1
			Endif

			loDataBase 	= This.Item( dbId )
			loColTables = loDataBase.oColTables
			loTable 	= loColTables.GetItem( cTable )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loColTables = Null
			loDataBase 	= Null

		EndTry
		
		Return loTable

	Endproc && GetTable



Enddefine && oColDataBases
