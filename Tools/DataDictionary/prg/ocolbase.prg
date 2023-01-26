#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

#If .F.
	Do 'Tools\DataDictionary\prg\oBase.prg'
#Endif

* ColBase
* Colección base para todas las colecciones del dicionario de datos.
Define Class oColBase As CollectionBase Of 'Tools\Namespaces\Prg\CollectionBase.prg' 

	#If .F.
		Local This As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'
	#Endif

	* _MemberData
	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="createdirifnotexists" type="method" display="CreateDirIfNotExists" />] ;
		+ [<memberdata name="getclon" type="method" display="GetClon" />] ;
		+ [<memberdata name="populateproperties" type="method" display="PopulateProperties" />] ;
		+ [</VFPData>]

	Dimension CreateDirIfNotExists_COMATTRIB[ 5 ]
	CreateDirIfNotExists_COMATTRIB[ 1 ] = 0
	CreateDirIfNotExists_COMATTRIB[ 2 ] = 'Crea el directorio si este no existe.'
	CreateDirIfNotExists_COMATTRIB[ 3 ] = 'CreateDirIfNotExists'
	CreateDirIfNotExists_COMATTRIB[ 4 ] = 'String'
	* CreateDirIfNotExists_COMATTRIB[ 5 ] = 0

	* CreateDirIfNotExists
	* Crea el directorio si este no existe.
	Procedure CreateDirIfNotExists ( tcDir As String ) As Void HelpString 'Crea el directorio si este no existe.'

		Local lcCommand As String, ;
			loErr As Object, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

		#If .F.
			TEXT
				*:Help Documentation
				*:Topic:
				*:Description:
				Crea el directorio si este no existe
				*:Project:
				Sistemas Praxis
				*:Autor:
				Damian Eiff
				*:Date:
				Viernes 20 de Marzo de 2009 (16:03:46)
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
				tcDir As String
				*:Remarks:
				*:Returns:
				Boolean
				*:Exceptions:
				*:SeeAlso:
				*:EndHelp
			ENDTEXT
		#Endif

		Try
			If ! Directory ( m.tcDir, 1 )
				Wait Window 'Creando directorio ' + m.tcDir + '....' Nowait
				TEXT To m.lcCommand Noshow Textmerge Pretext 15
					Mkdir '<<m.tcDir>>'
				ENDTEXT
				&lcCommand.

			Endif && ! Directory( m.tcDir , 1 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcDir
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError = Null

		Endtry

	Endproc && CreateDirIfNotExists

	Dimension GetClon_COMATTRIB[ 5 ]
	GetClon_COMATTRIB[ 1 ] = 0
	GetClon_COMATTRIB[ 2 ] = 'Devuelve una copia de un elemento de la colección.'
	GetClon_COMATTRIB[ 3 ] = 'GetClon'
	GetClon_COMATTRIB[ 4 ] = 'Object'
	* GetClon_COMATTRIB[ 5 ] = 0

	* GetClon
	* Devuelve una copia de un elemento de la colección.
	Procedure GetClon ( tuIndex As Variant ) As Object HelpString 'Devuelve una copia de un elemento de la colección.'

		Local loClon As Object, ;
			loErr As Object, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loItem As Object

		#If .F.
			TEXT
				*:Help Documentation
				*:Topic:
				*:Description:
				Devuelve una copia de un elemento de la colección
				*:Project:
				Sistemas Praxis
				*:Autor:
				Damian Eiff
				*:Date:
				Viernes 20 de Marzo de 2009 (16:03:46)
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
				teIndex As Variant
				*:Remarks:
				*:Returns:
				Boolean
				*:Exceptions:
				*:SeeAlso:
				*:EndHelp
			ENDTEXT
		#Endif

		Try
			loItem = This.GetItem ( m.tuIndex )
			lcXml = m.XML.ObjectToXml ( m.loItem )
			loClon = m.XML.XmlToObject ( m.lcXml )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tuIndex
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError = Null

		Endtry

		Return m.loClon

	Endproc && GetClon

	Dimension PopulateProperties_COMATTRIB[ 5 ]
	PopulateProperties_COMATTRIB[ 1 ] = 0
	PopulateProperties_COMATTRIB[ 2 ] = 'Devuelve .T. si se pudieron copiar las propiedades del objeto pasado como parametro.'
	PopulateProperties_COMATTRIB[ 3 ] = 'PopulateProperties'
	PopulateProperties_COMATTRIB[ 4 ] = 'Boolean'
	* PopulateProperties_COMATTRIB[ 5 ] = 0

	* PopulateProperties
	* Devuelve .T. si se pudieron copiar las propiedades del objeto pasado como parametro.
	* Carga las propiedades del objeto desde un Objeto pasado como parametro
	Procedure PopulateProperties ( toParam As Object ) As Boolean HelpString 'Devuelve .T. si se pudieron copiar las propiedades del objeto pasado como parametro.'

		Local lRet As Boolean, ;
			loErr As Object, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loItem As Object, ;
			loParam As Object

		#If .F.
			TEXT
				*:Help Documentation
				*:Topic:
				*:Description:
				Carga las propiedades del objeto desde un Objeto pasado como parametro
				*:Project:
				Sistemas Praxis
				*:Autor:
				Damian Eiff
				*:Date:
				Miércoles 11 de Marzo de 2009 (11:50:29)
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
				toParam As Object
				*:Remarks:
				*:Returns:
				Boolean
				*:Exceptions:
				*:SeeAlso:
				*:EndHelp
			ENDTEXT
		#Endif

		Try

			m.Object.PopulateProperties ( This, m.toParam )

			For Each m.loParam In m.toParam
				loItem = This.New ( m.loParam.Name )
				m.Object.PopulateProperties ( m.loItem, m.loParam )

			Endfor

			lRet = .T.

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loItem  = Null
			loParam = Null
			loError = Null

		Endtry

		Return m.lRet

	Endproc && PopulateProperties

Enddefine && oColBase