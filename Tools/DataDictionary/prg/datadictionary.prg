*!*	#include 'Namespaces\include\foxpro.h'
*!*	#include 'Namespaces\include\system.h'

*!*	#Define FIELD_NAME_VALIDATION_RULE_IS_VIOLATED 1582

*!*	* ColBase
*!*	* Colección de Bases de Datos
*!*	Define Class ColBase As CollectionBase Of 'NameSpaces\Prg\ObjectNamespace.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		* _MemberData
*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
*!*			+ [<VFPData>] ;
*!*			+ [<memberdata name="populateproperties" type="method" display="PopulateProperties" />] ;
*!*			+ [<memberdata name="createdirifnotexists" type="method" display="CreateDirIfNotExists" />] ;
*!*			+ [</VFPData>]

*!*		Procedure PopulateProperties ( toParam As Object ) As Boolean HelpString 'Carga las propiedades del objeto desde un Objeto pasado como parametro'

*!*			Local lRet As Boolean, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loItem As Object, ;
*!*				loParam As Object


*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Carga las propiedades del objeto desde un Objeto pasado como parametro
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damian Eiff
*!*					*:Date:
*!*					Miércoles 11 de Marzo de 2009 (11:50:29)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					toParam As Object
*!*					*:Remarks:
*!*					*:Returns:
*!*					Boolean
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try

*!*				PopulateProperties ( This, m.toParam )

*!*				For Each m.loParam In m.toParam
*!*					loItem = This.New ( m.loParam.Name )
*!*					PopulateProperties ( m.loItem, m.loParam )

*!*				Endfor

*!*				lRet = .T.

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loItem  = Null
*!*				loParam = Null
*!*				loError = Null

*!*			Endtry

*!*			Return m.lRet

*!*		Endproc && PopulateProperties

*!*		Procedure CreateDirIfNotExists ( tcDir As String ) As Boolean

*!*			Local lcCommand As String, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'


*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Crea el directorio si este no existe
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damian Eiff
*!*					*:Date:
*!*					Viernes 20 de Marzo de 2009 (16:03:46)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					tcDir As String
*!*					*:Remarks:
*!*					*:Returns:
*!*					Boolean
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				If ! Directory ( m.tcDir, 1 )
*!*					Wait Window 'Creando directorio ' + m.tcDir + '....' Nowait
*!*					TEXT To m.lcCommand Noshow Textmerge Pretext 15
*!*						Mkdir '<<m.tcDir>>'
*!*					ENDTEXT
*!*					&lcCommand.

*!*				Endif && ! Directory( m.tcDir , 1 )

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*		Endproc && CreateDirIfNotExists

*!*		Procedure GetClon ( teIndex As Variant ) As Object HelpString 'Devuelve una copia de un elemento de la colección'

*!*			Local loClon As Object, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loItem As Object


*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Devuelve una copia de un elemento de la colección
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damian Eiff
*!*					*:Date:
*!*					Viernes 20 de Marzo de 2009 (16:03:46)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					teIndex As Variant
*!*					*:Remarks:
*!*					*:Returns:
*!*					Boolean
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				loItem = This.GetItem ( m.teIndex )
*!*				loClon = m.XML.XmlToObject ( m.XML.ObjectToXml ( m.loItem ) )

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.loClon

*!*		Endproc && GetClon

*!*	Enddefine && ColBase


*!*	* oBase
*!*	* Colección de Bases de Datos 
*!*	Define Class oBase As CustomBase Of 'NameSpaces\Prg\ObjectNamespace.prg' OlePublic

*!*		#If .F.
*!*			Local This As oBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Colección de Bases de Datos
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif




*!*		DataSession = SET_DEFAULT

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="populateproperties" type="method" display="PopulateProperties" />] + ;
*!*			[<memberdata name="createdirifnotexists" type="method" display="CreateDirIfNotExists" />] + ;
*!*			[<memberdata name="retrycommand" type="method" display="ReTryCommand" />] + ;
*!*			[</VFPData>]

*!*		* PopulateProperties
*!*		* Carga las propiedades del objeto desde un Objeto pasado como parametro 
*!*		Procedure PopulateProperties ( toParam As Object ) As Boolean HelpString 'Carga las propiedades del objeto desde un Objeto pasado como parametro'

*!*			Local lRet As Boolean, ;
*!*				laMembers[1] As String, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'


*!*			#If .F.
*!*				TEXT
*!*					 *:Help Documentation
*!*					 *:Description:
*!*					 Carga las propiedades del objeto desde un Objeto pasado como parametro
*!*					 *:Autor:
*!*					 Damian Eiff

*!*					 *:Date:
*!*					 Miércoles 11 de Marzo de 2009 (11:50:29)

*!*					 *:Parameters:
*!*					 *:Remarks:
*!*					 *:Returns:
*!*					 *:Example:
*!*					 *:SeeAlso:
*!*					 *:Events:
*!*					 *:KeyWords:
*!*					 *:Inherits:
*!*					 *:Exceptions:
*!*					 *:NameSpace:
*!*					 digitalizarte.com
*!*					 *:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try

*!*				m.Object.PopulateProperties ( This, m.toParam )
*!*				lRet = .T.

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.lRet

*!*		Endproc && PopulateProperties

*!*		* CreateDirIfNotExists
*!*		Procedure CreateDirIfNotExists ( tcDir As String ) As Boolean

*!*			Local lcCommand As String, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			#If .F.
*!*				TEXT
*!*						 *:Help Documentation
*!*						 *:Project:
*!*						 Sistemas Praxis

*!*						 *:Autor:
*!*						 Damian Eiff

*!*						 *:Date:
*!*						 Viernes 20 de Marzo de 2009 (16:03:46)

*!*						 *:Parameters:
*!*						 *:Remarks:
*!*						 *:Returns:
*!*						 *:Example:
*!*						 *:SeeAlso:
*!*						 *:Events:
*!*						 *:KeyWords:
*!*						 *:Inherits:
*!*						 *:Exceptions:
*!*						 *:NameSpace:
*!*						 digitalizarte.com
*!*						 *:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try
*!*				If ! Directory ( m.tcDir, 1 )
*!*					Wait Window 'Creando directorio ' + m.tcDir + '....' Nowait
*!*					TEXT To m.lcCommand Noshow Textmerge Pretext 15
*!*						Mkdir '<<tm.cDir>>'
*!*					ENDTEXT
*!*					&lcCommand.

*!*				Endif

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*		Endproc && CreateDirIfNotExists

*!*		Procedure ReTryCommand ( tcCommand As String, tnMaxIntentos As Integer, tnErrorNo As Integer, tlDoevents As Boolean ) As Void HelpString 'Executa un comando y si falla reintenta n veces'

*!*			Local lcCommand As String, ;
*!*				lnIntentos As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Executa un comando y si falla reintenta n veces
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damian Eiff
*!*					*:Date:
*!*					 Lunes 6 de Abril de 2009 (18:05:31)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					tcCommand As String
*!*					tnMaxIntentos As Integer
*!*					tnErrorNo As Integer
*!*					tlDoevents As Boolean
*!*					*:Remarks:
*!*					*:Returns:
*!*					Void
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )

*!*			If Empty ( m.tnMaxIntentos )
*!*				tnMaxIntentos = 10

*!*			Endif && Empty( m.tnMaxIntentos )

*!*			If Empty ( m.tnErrorNo )
*!*				tnErrorNo = 0

*!*			Endif && Empty( m.tnErrorNo )

*!*			lnIntentos = 0
*!*			Do While m.lnIntentos < m.tnMaxIntentos
*!*				Try

*!*					lnIntentos = m.lnIntentos + 1
*!*					&tcCommand.

*!*				Catch To loErr
*!*					Wait Window 'Reintentando ( ' + Transform ( m.lnIntentos ) + ' ) ' + m.tcCommand + '....' Nowait

*!*					If  m.oErr.ErrorNo == m.tnErrorNo
*!*						* m.lnIntentos = m.lnIntentos + 1
*!*						TEXT To m.lcCommand Noshow Textmerge Pretext 15
*!*			                    		<<m.lnIntentos>>: <<m.tcCommand>>
*!*						ENDTEXT
*!*						loError.Remark = 'Reintento Nº ' + m.lcCommand
*!*						m.loError.Process ( m.loErr, .F. )

*!*					Endif && m.oErr.ErrorNo == m.tnErrorNo

*!*					If m.tlDoevents
*!*						DoEvents

*!*					Endif && m.tlDoevents

*!*				Endtry

*!*			Enddo

*!*			Try
*!*				If m.lnIntentos # m.tnMaxIntentos + 1
*!*					Error 'Se alcanzo el maximo de intentos sin poder ejecutar satifactoriamente el comando ' + m.lcCommand

*!*				Endif &&  m.lnIntentos # m.tnMaxIntentos + 1

*!*			Catch To loErr
*!*				If Vartype ( m.loError ) # 'O'
*!*					loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )

*!*				Endif && Vartype( m.loError ) # 'O'

*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*		Endproc && ReTryCommand

*!*	Enddefine && oBase

*!*	* ColDataBases
*!*	* Colección de Bases de Datos 
*!*	Define Class ColDataBases As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColDataBases Of 'DataDictionary\prg\DataDictionary.prg'

*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Colección de Bases de Datos
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
*!*			+ [<VFPData>] ;
*!*			+ [<memberdata name="adddatabase" type="event" display="AddDataBase" />] ;
*!*			+ [<memberdata name="new" type="method" display="New" />] ;
*!*			+ [</VFPData>]

*!*		Procedure AddDataBase ( toDataBase As oDataBase Of 'DataDictionary\prg\DataDictionary.prg') As Void HelpString 'Agrega una Base de Datos a la colección ColDataBases'

*!*			Local lcKey As String, ;
*!*				liIdx As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Agrega una Base de Datos a la colección ColDataBases
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Martes 29 de Mayo de 2007 (11:04:54)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					toDataBase As oDataBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*					*:Remarks:
*!*					*:Returns:
*!*					Void
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try
*!*				If Vartype ( m.toDataBase ) == 'O'
*!*					lcKey = Lower ( m.toDataBase.Name )
*!*					liIdx = This.GetKey ( m.lcKey )

*!*					If Empty ( m.liIdx )
*!*						toDataBase.oParent = This
*!*						This.AddItem ( m.toDataBase, m.lcKey )

*!*					Endif && Empty( m.liIdx )

*!*				Endif && Vartype( toDataBase ) = 'O'


*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*		Endproc && AddDataBase

*!*		Procedure New ( tcName As String ) As oDataBase Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Obtiene un elemento oDataBase vacío'

*!*			Local loDataBase As oDataBase Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					 Obtiene un elemento oDataBase vacío
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Martes 29 de Mayo de 2007 (11:13:53)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					tcName As String
*!*					*:Remarks:
*!*					*:Returns:
*!*					 oDataBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				If ! Empty ( m.tcName )
*!*					loDataBase      = Newobject ( 'oDataBase', 'DataDictionary\prg\DataDictionary.prg'  )
*!*					loDataBase.Name = Alltrim ( m.tcName )

*!*					This.AddDataBase ( m.loDataBase )
*!*				Else
*!*					loDataBase = Null

*!*				Endif && ! Empty( m.tcName )

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.loDataBase

*!*		Endproc && New

*!*	Enddefine && ColDataBases

*!*	* oDataBase
*!*	* Clase Base de Datos 
*!*	Define Class oDataBase As oBase

*!*		#If .F.
*!*			Local This As oDataBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Clase Base de Datos
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 29 de Mayo de 2007 (11:00:34)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*			ENDTEXT
*!*		#Endif


*!*		* Colección Tables
*!*		oColTables = Null

*!*		* Carpeta donde se encuentra la Base de datos
*!*		Folder = ''

*!*		* Extensión del archivo de la Base de Datos
*!*		Ext = 'DBC'

*!*		* Nombre de la Base de datos en el archivo de configuración
*!*		cDataConfigurationKey = ''

*!*		* Nombre del archivo de inicialización
*!*		IniFileName = ''

*!*		DataSession = SET_DEFAULT

*!*		cProjectPath = ''

*!*		* Nombre del proyecto
*!*		cProjectName = ''

*!*		* Colección de Store Procedures
*!*		oColStoreProcedures = Null

*!*		* Coleccion de Formularios
*!*		oColForms = Null

*!*		* Indica si la Base de datos será excluída del Diccionario de Datos
*!*		lExcludeFromDataDictionary = .F.

*!*		* Indica si se realiza el procesamiento de la Base de Datos
*!*		lProcess = .T.

*!*		* Colección Entities
*!*		oColTiers = Null


*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="getselectsql" type="method" display="GetSelectSQL" />] + ;
*!*			[<memberdata name="lprocess" type="property" display="lProcess" />] + ;
*!*			[<memberdata name="lexcludefromdatadictionary" type="property" display="lExcludeFromDataDictionary" />] + ;
*!*			[<memberdata name="ocolforms" type="property" display="oColForms" />] + ;
*!*			[<memberdata name="ocolstoreprocedures" type="property" display="oColStoreProcedures" />] + ;
*!*			[<memberdata name="cDataConfigurationKey" type="property" display="cDataConfigurationKey" />] + ;
*!*			[<memberdata name="inifilename" type="property" display="IniFileName" />] + ;
*!*			[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
*!*			[<memberdata name="folder" type="property" display="Folder" />] + ;
*!*			[<memberdata name="ext" type="property" display="Ext" />] + ;
*!*			[<memberdata name="readinifile" type="method" display="ReadIniFile" />] + ;
*!*			[<memberdata name="initialize" type="method" display="Initialize" />] + ;
*!*			[<memberdata name="cprojectpath" type="propertie" display="cProjectPath" />] + ;
*!*			[<memberdata name="addentityproperty" type="method" display="AddEntityProperty" />] + ;
*!*			[<memberdata name="cprojectname" type="property" display="cProjectName" />] + ;
*!*			[<memberdata name="GetSetGridLayout" type="method" display="GetSetGridLayout" />] + ;
*!*			[<memberdata name="gethookafternew" type="method" display="GetHookAfterNew" />] + ;
*!*			[<memberdata name="getpopulatetable" type="method" display="GetPopulateTable" />] + ;
*!*			[<memberdata name="appendprocedures" type="method" display="AppendProcedures" />] + ;
*!*			[<memberdata name="merge" type="method" display="Merge" />] + ;
*!*			[<memberdata name="classafterinit" type="method" display="ClassAfterInit" />] + ;
*!*			[<memberdata name="ocoltiers" type="property" display="oColTiers" />] + ;
*!*			[</VFPData>]

*!*		Procedure Init ( tuProcess As Variant ) As Boolean

*!*			Local lcDBId As String, ;
*!*				lcDataBases As String, ;
*!*				llOk As Boolean, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Constructor de la base de datos
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Jueves 17 de Abril de 2008 (10:05:18)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					tuProcess As Variant
*!*					*:Remarks:
*!*					*:Returns:
*!*					Boolean
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try

*!*				llOk = .F.

*!*				With This As oDataBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*					lcDataBases = m.CacheManager.Get ( 'cDataBases' )
*!*					If Isnull ( m.lcDataBases ) Or Empty ( m.lcDataBases )
*!*						lcDataBases = ''
*!*						m.CacheManager.Add ( '', 'cDataBases' )

*!*					Endif
*!*					TEXT To m.lcDBId Textmerge Noshow Pretext 15
*!*						#<<.Name>>#,
*!*					ENDTEXT

*!*					If Empty ( Atc ( m.lcDBId, m.lcDataBases ) )
*!*						llOk = .T.

*!*						lcDataBases = m.lcDataBases + m.lcDBId


*!*						.lProcess = Empty ( m.tuProcess )
*!*						.ReadIniFile()
*!*						.Initialize()

*!*						If .lProcess
*!*							.ClassAfterInit()

*!*						Endif && .lProcess

*!*						m.CacheManager.Update ( m.lcDataBases, 'cDataBases' )

*!*					Endif && Empty( Atc( m.lcDBId, m.lcDataBases ) )

*!*				Endwith

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.llOk

*!*		Endproc && Init

*!*		Procedure Initialize() As Void
*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Template Method
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Jueves 17 de Abril de 2008 (10:05:18)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					*:Remarks:
*!*					*:Returns:
*!*					Void
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif
*!*		Endproc && Initialize

*!*		Protected Procedure ClassAfterInit() As Void

*!*			Local lcExp As String, ;
*!*				lcPadre As String, ;
*!*				liIdx As Integer, ;
*!*				lijQ As Integer, ;
*!*				liq As Integer, ;
*!*				llOk As Boolean, ;
*!*				loColData As CollectionBase Of 'NameSpaces\Prg\ObjectNamespace.prg', ;
*!*				loColTables As ColTables Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loField As oField Of Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loFldFK As oField Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loTable As oTable Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loTablePadre As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*			*:Global i, ;
*!*			iq, ;
*!*			jQ, ;
*!*			oErr as Exception

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Valida que las tablas en la base de datos esten correctamente configuradas, calcula y asigna el nivel de jerarquia de las tablas
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damian Eiff
*!*					*:Date:
*!*					Jueves 23 de Julio de 2009 (18:29:19)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					*:Remarks:
*!*					*:Returns:
*!*					Void
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try
*!*				loColTables = This.oColTables
*!*				For liq = 1 To m.loColTables.Count
*!*					loTable = m.loColTables.Item[ m.liq ]
*!*					lcPadre = Alltrim ( Lower ( m.loTable.Padre ) )
*!*					If ! Empty ( m.lcPadre )
*!*						loColData = Null
*!*						* Obtengo las FK a la tabla padre
*!*						lcExp     = ' Lower( Alltrim( References ) ) == "' + m.lcPadre + '" '
*!*						loColData = loTable.oColFields.Where ( m.lcExp )
*!*						Assert m.loColData.Count # 0 Message 'No existe la referencia'

*!*						If m.loColData.Count > 0
*!*							For lijQ = 1 To m.loColData.Count
*!*								loFldFK             = m.loColData.Item[ m.lijQ ]
*!*								loFldFK.nComboOrder = Iif ( Empty ( m.loFldFK.nComboOrder ), -1, m.loFldFK.nComboOrder )

*!*							Endfor
*!*							llOk = .F.

*!*							* Obtengo la referencia del padre
*!*							loTablePadre = m.loColTables.GetItem ( m.lcPadre )

*!*							If Vartype ( m.loTablePadre ) # 'O'
*!*								For liIdx = 1 To m.loColData.Count
*!*									loField = m.loColData.Item[ m.liIdx ]

*!*									If m.lcPadre == Lower ( m.loField.References )
*!*										If ! Empty ( m.loField.cParentKeyName )
*!*											loTablePadre = m.loColTables.GetItem ( m.loField.cParentKeyName )

*!*										Endif && ! Empty( m.loField.cParentKeyName )
*!*										llOk = ( Vartype ( m.loTablePadre ) == 'O' )
*!*										Exit

*!*									Endif && m.lcPadre = Lower( m.loField.References )

*!*								Endfor

*!*							Else && Vartype( m.loTablePadre ) # "O"
*!*								llOk = .T.

*!*							Endif && Vartype( m.loTablePadre ) # "O"

*!*							If ! m.llOk
*!*								Error 'No existe en la tabla ' + m.loTable.Name + ' ningun campo que haga referencia a la tabla ' + m.lcPadre

*!*							Endif && ! llOk

*!*							* Agrego la referencia de la tabla a la colección de tablas del padre
*!*							m.loTablePadre.oColTables.AddTable ( m.loTable, .T. )
*!*							* Obtengo la clave primaria del padre
*!*							loField            = m.loTablePadre.GetPrimaryKey()
*!*							loTable.ForeignKey = m.loField.Name

*!*						Else
*!*							Error 'No existe en la tabla ' + m.loTable.Name + ' ningun campo que haga referencia a la tabla ' + m.lcPadre

*!*						Endif && m.loColData.Count > 0

*!*					Endif && ! Empty( m.loTable.Padre )

*!*				Endfor

*!*				For liq = 1 To m.loColTables.Count
*!*					loTable = m.loColTables.Item[ m.liq ]
*!*					If Empty ( m.loTable.Padre )
*!*						* Calculo la Jerarquia de tablas
*!*						* nNivelJerarquiaTablas indica la cantidad máxima de niveles que cuelgan de una tabla
*!*						* dada, incluyéndose a si misma.
*!*						* En Padre-Hijo-Nieto, nNivelJerarquiaTablas para Padre = 3, Hijo = 2 y Nieto = 1
*!*						* El Nivel indica el lugar que ocupa dentro de la jeraquía: Padre = 1,
*!*						* Hijo = 2 y Nieto = 3
*!*						*
*!*						loTable.Nivel                 = 1
*!*						loTable.nNivelJerarquiaTablas = m.loTable.oColTables.AssignLevel ( m.loTable.oColTables, 2, 1 )

*!*						* Assigno el nivel de jerarquia a las tablas hijas
*!*						m.loTable.oColTables.AssignNivelJerarquiaTablas ( m.loTable.oColTables, m.loTable.nNivelJerarquiaTablas - 1 )

*!*						* Asigno la referencia al Main
*!*						m.loTable.oColTables.AssignMain ( m.loTable.oColTables, m.loTable )

*!*					Endif && Empty( m.loTable.Padre )

*!*				Endfor

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError      = Null
*!*				loTable      = Null
*!*				loTablePadre = Null
*!*				loColData    = Null
*!*				loField      = Null
*!*				loColTables  = Null
*!*				loFldFK      = Null

*!*			Endtry

*!*		Endproc && ClassAfterInit

*!*		Procedure ReadIniFile ( ) As Void HelpString 'Leer el archivo de inicialización'

*!*			Local lcAlias As String, ;
*!*				lcFolder As String, ;
*!*				lcName As String, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loXA As Xmladapter

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Leer el archivo de inicialización
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damian Eiff
*!*					*:Date:
*!*					Jueves 5 de Enero de 2006 (09:28:41)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					*:Remarks:
*!*					*:Returns:
*!*					Void
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try

*!*				lcAlias = ''
*!*				With This As oDataBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*					* Nombre del archivo de inicialización
*!*					.IniFileName = Addbs ( .cRootFolder ) + 'DataTier.xml'

*!*					loXA = m.XML.NewXMLAdapter()

*!*					m.loXA.LoadXML ( .IniFileName, .T. )
*!*					m.loXA.Tables[ 1 ].ToCursor()
*!*					loXA    = Null
*!*					lcAlias = Alias()

*!*					Locate For Alltrim ( Lower ( objName ) ) == Alltrim ( Lower ( .cDataConfigurationKey ) )
*!*					If Eof ( m.lcAlias )
*!*						Locate For Alltrim ( Lower ( objName ) ) == 'default'

*!*					Endif

*!*					lcFolder = Justpath ( Alltrim ( dbName ) )
*!*					lcName   = Juststem ( Alltrim ( dbName ) )

*!*					.Folder = Justpath ( Alltrim ( dbName ) )
*!*					.Name   = Juststem ( Alltrim ( dbName ) )
*!*					.Ext    = Justext ( Alltrim ( dbName ) )

*!*				Endwith

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null
*!*				loXA    = Null
*!*				Use In Select ( m.lcAlias )

*!*			Endtry

*!*		Endproc && ReadIniFile

*!*		*
*!*		* oColTables_Access
*!*		Protected Procedure oColTables_Access() As  ColTables Of 'DataDictionary\prg\DataDictionary.prg'
*!*			With This As oDataBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*				If Vartype ( .oColTables ) # 'O'
*!*					.oColTables         = Newobject ( 'ColTables', 'DataDictionary\prg\DataDictionary.prg' )
*!*					.oColTables.oParent = This

*!*				Endif && Vartype( This.oColTables ) # "O"
*!*			Endwith

*!*			Return This.oColTables

*!*		Endproc && oColTables_Access

*!*		*
*!*		* oColStoreProcedures_Access
*!*		Protected Procedure oColStoreProcedures_Access()
*!*			With This As oDataBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*				If Vartype ( .oColStoreProcedures ) # 'O'
*!*					.oColStoreProcedures = Newobject ( 'ColStoreProcedures', 'DataDictionary\prg\DataDictionary.prg' )

*!*				Endif && Vartype( .oColStoreProcedures ) # "O"

*!*			Endwith

*!*			Return This.oColStoreProcedures

*!*		Endproc && oColStoreProcedures_Access

*!*		Procedure Merge ( toDataBase As oDataBase ) As Boolean HelpString 'Combina 1 un objeto oDatabase con el actual'

*!*			Local lcKey As String, ;
*!*				liIdx As Integer, ;
*!*				lnIndex As Number, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loForm As Object, ;
*!*				loStoreProcedure As oStoreProcedure Of 'FW\Actual\Comunes\Prg\ColTables.prg', ;
*!*				loTable As oTable Of 'FW\Actual\Comunes\Prg\ColTables.prg', ;
*!*				loTiers As Object

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Combina 1 un objeto oDatabase con el actual
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damian Eiff
*!*					*:Date:
*!*					Viernes 26 de Junio de 2009 (10:30:13)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					toDataBase As oDataBase
*!*					*:Remarks:
*!*					*:Returns:
*!*					Boolean
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				With This As oDataBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*					If Vartype ( m.toDataBase ) == 'O'
*!*						* Copio las tablas
*!*						For liIdx = 1 To m.toDataBase.oColTables.Count
*!*							lcKey   = m.toDataBase.oColTables.GetKey (m.liIdx )
*!*							lnIndex = .oColTables.GetKey ( m.lcKey )
*!*							If Empty ( m.lnIndex )
*!*								loTable = m.toDataBase.oColTables.Item[ m.liIdx ]
*!*								.oColTables.AddTable ( m.loTable )

*!*							Endif && Empty( m.lnIndex )

*!*						Endfor

*!*						* Copio los Store Procedures
*!*						For liIdx = 1 To m.toDataBase.oColStoreProcedures.Count
*!*							lcKey   = m.toDataBase.oColStoreProcedures.GetKey ( m.liIdx )
*!*							lnIndex = .oColStoreProcedures.GetKey ( m.lcKey )
*!*							If Empty ( m.lnIndex )
*!*								loStoreProcedure = m.toDataBase.oColStoreProcedures.Item[ m.liIdx ]
*!*								.oColStoreProcedures.New ( m.loStoreProcedure.cFileName, m.loStoreProcedure.cCodigo )

*!*							Endif && Empty( m.lnIndex )

*!*						Endfor

*!*						* Copio los Formularios
*!*						For liIdx = 1 To m.toDataBase.oColForms.Count
*!*							lcKey   = m.toDataBase.oColForms.GetKey ( m.liIdx )
*!*							lnIndex = .oColForms.GetKey ( m.lcKey )
*!*							If Empty ( m.lnIndex )
*!*								loForm = toDataBase.oColForms.Item[ m.liIdx ]
*!*								.oColForms.AddItem ( m.loForm, m.lcKey )

*!*							Endif && Empty( m.lnIndex )

*!*						Endfor

*!*						* Copio las Tiers
*!*						For liIdx = 1 To m.toDataBase.oColTiers.Count
*!*							lcKey   = m.toDataBase.oColTiers.GetKey ( m.liIdx )
*!*							lnIndex = .oColTiers.GetKey ( m.lcKey )
*!*							If Empty ( m.lnIndex )
*!*								loTiers = m.toDataBase.oColTiers.Item[ m.liIdx ]
*!*								.oColTiers.AddItem ( m.loTiers, m.lcKey )

*!*							Endif && Empty( m.lnIndex )

*!*						Endfor

*!*					Endif && Vartype( m.toDataBase ) == 'O'

*!*				Endwith
*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError          = Null
*!*				loTable          = Null
*!*				loStoreProcedure = Null
*!*				loForm           = Null
*!*				loTiers          = Null

*!*			Endtry

*!*		Endproc && Merge

*!*		Procedure oColForms_Access
*!*			With This As oDataBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*				If Vartype ( .oColForms ) # 'O'
*!*					.oColForms         = Createobject ( 'ColForms' )
*!*					.oColForms.oParent = This

*!*				Endif && Vartype( .oColForms ) # "O"

*!*			Endwith

*!*			Return This.oColForms

*!*		Endproc &&  oColForms_Access

*!*		Procedure oColTiers_Access
*!*			With This As oDataBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*				If Vartype ( .oColTiers ) # 'O'
*!*					.oColTiers         = Createobject ( 'colBase' )
*!*					.oColTiers.oParent = This

*!*				Endif && Vartype( .oColTiers ) # "O"

*!*			Endwith
*!*			Return This.oColTiers

*!*		Endproc && oColForms_Access

*!*		*
*!*		* GetSelectSQL
*!*		Function GetSelectSQL ( toTable As Object, tcWhere As String, tlIncludeRelationships As Boolean ) As String HelpString 'Devuelve el select SQL para la tabla'

*!*			Local lcCampos As String, ;
*!*				lcCamposAux As String, ;
*!*				lcFieldsToSQL As String, ;
*!*				lcJoins As String, ;
*!*				lcReferencesFieldsToSQL As String, ;
*!*				lcSQLStat As String, ;
*!*				lcTableName As String, ;
*!*				liIdx As Integer, ;
*!*				loColRef As CollectionBase Of 'NameSpaces\Prg\ObjectNamespace.prg', ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loField As oField Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loFldPk As oField Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loTblRef As oTable Of 'DataDictionary\prg\DataDictionary.prg'

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Devuelve el select SQL para la tabla
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damian Eiff
*!*					*:Date:
*!*					Viernes 26 de Junio de 2009 (10:30:13)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					toTable As Object
*!*					tcWhere As String
*!*					tlIncludeRelationships As Boolean
*!*					*:Remarks:
*!*					*:Returns:
*!*					String
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			*
*!*			*

*!*			Try
*!*				* Plantilla para armar el string
*!*				TEXT To m.lcFieldsToSQL Noshow Textmerge Pretext 15
*!*					Iif( Empty( cDefaultSqlExp ),
*!*						Iif( lIsVirtual, [ Cast( ] + Iif( InList( Left( Lower( FieldType ) , 3 ), 'log', 'gen', 'cur', 'blo', 'dat', 'cha', 'var', 'mem' ), "''", '0' ) + [ As ] + FieldType
*!*							+ Iif( ! InList( Left( Lower( FieldType ) , 3 ), 'int', 'dat', 'mem' ), [( ] + Transform( FieldWidth )
*!*						    + Iif( ! InList( Left( Lower( FieldType ) , 3 ), 'var', 'int', 'dat', 'cha', 'mem', 'dat' ),
*!*								', ' + Transform( FieldPrecision ),
*!*								'' ) + [ ) ],
*!*							'' ) + [ ) As ] + Name, oParent.Name + [.] + Name ), cDefaultSqlExp )

*!*				ENDTEXT

*!*				TEXT To m.lcReferencesFieldsToSQL Noshow Textmerge Pretext 15
*!*						Iif( lIsVirtual, [ Cast( ] + Iif( InList( Left( Lower( FieldType ) , 3 ), 'log', 'gen', 'cur', 'blo', 'dat', 'cha', 'var', 'mem' ), "''", '0' ) + [ As ] + FieldType
*!*							+ Iif( ! InList( Left( Lower( FieldType ) , 3 ), 'int', 'dat', 'mem' ), [( ] + Transform( FieldWidth )
*!*						    + Iif( ! InList( Left( Lower( FieldType ) , 3 ), 'var', 'int', 'dat', 'cha', 'mem', 'dat' ),
*!*								', ' + Transform( FieldPrecision ),
*!*								'' ) + [ ) ],
*!*							'' ) + [ ) As ] + oParent.Name + Name, oParent.Name + [.] + Name + [ ] + oParent.Name + Name )

*!*				ENDTEXT

*!*				If ! Empty ( m.tcWhere )
*!*					lcCampos = m.toTable.oColFields.ToString ( m.lcFieldsToSQL, '', m.tcWhere )

*!*				Else && ! Empty( m.tcWhere )
*!*					lcCampos = m.toTable.oColFields.ToString ( m.lcFieldsToSQL )
*!*					tcWhere  = ' 1 = 1 '

*!*				Endif &&  ! Empty( tcWhere )

*!*				lcTableName = Lower ( Alltrim ( m.toTable.Name ) )
*!*				If m.tlIncludeRelationships
*!*					loColRef = toTable.oColFields.Where ( ' ( ' + m.tcWhere + ' ) And ! Empty( m.References ) ' )
*!*					lcJoins  = ''
*!*					* Incluir las relaciones con otras tablas
*!*					For liIdx = 1 To m.loColRef.Count
*!*						loField = m.loColRef.Item[ liIdx ]
*!*						* Si la tabla tiene una referencia ella misma no la agrego en los Join's
*!*						If m.lcTableName # Lower ( Alltrim ( m.loField.References ) )
*!*							loTblRef = This.oColTables.GetItem ( m.loField.References )
*!*							Assert Vartype ( m.loTblRef ) = 'O' Message 'No se encontro la tabla'

*!*							* m.lcCamposAux = m.loTblRef.oColFields.ToString( m.lcReferencesFieldsToSQL, '', ' nDefaultReference <> 0 ' )
*!*							lcCamposAux = m.loTblRef.oColFields.ToString ( m.lcReferencesFieldsToSQL, '', ' nDefaultReference # 0 ' )
*!*							If ! Empty ( m.lcCamposAux )
*!*								lcCampos = m.lcCampos + ',' + m.lcCamposAux

*!*							Endif && ! Empty( m.lcCamposAux )

*!*							loFldPk = m.loTblRef.GetPrimaryKey()

*!*							* m.lcJoins = m.lcJoins + ' Left Outer Join ' + m.loTblRef.Name + ' On ' + m.loTblRef.Name + '.' + m.loFldPk.Name + ' = ' + m.lcTableName + '.' + m.loField.Name
*!*							TEXT To m.lcJoins Noshow Textmerge Pretext 15 Additive
*!*								Left Outer Join <<m.loTblRef.Name>> On <<m.loTblRef.Name>>.<<m.loFldPk.Name>> = <<m.lcTableName>>.<<m.loField.Name>>
*!*							ENDTEXT

*!*						Endif && m.lcTableName # Lower( Alltrim( m.loField.References ) )

*!*					Endfor

*!*					TEXT To m.lcSQLStat Noshow Textmerge Pretext 15
*!*						Select  <<m.lcCampos>>
*!*							From <<Iif ( m.toTable.lIsVirtual, 'dual', m.lcTableName)>>
*!*								<<m.lcJoins>>

*!*					ENDTEXT

*!*				Else && m.tlIncludeRelationships
*!*					TEXT To m.lcSQLStat Noshow Textmerge Pretext 15
*!*						Select  <<m.lcCampos>>
*!*							From <<Iif ( m.toTable.lIsVirtual, 'dual', m.lcTableName )>>

*!*					ENDTEXT

*!*				Endif && m.tlIncludeRelationships

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )

*!*				Throw m.loError

*!*			Finally
*!*				loError  = Null
*!*				loColRef = Null
*!*				loField  = Null
*!*				loTblRef = Null
*!*				loFldPk  = Null

*!*			Endtry

*!*			Return m.lcSQLStat

*!*		Endfunc && GetSelectSQL

*!*	Enddefine && oDataBase

*!*	* ColTables
*!*	* Colección de Bases de Datos 
*!*	Define Class ColTables As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		Name                  = 'ColTables'
*!*		nNivelJerarquiaTablas = 0

*!*		#If .F.
*!*			Local This As ColTables Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Colección de Bases de Datos
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 29 de Mayo de 2007 (11:00:34)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*			ENDTEXT
*!*		#Endif


*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="addtable" type="event" display="AddTable" />] + ;
*!*			[<memberdata name="assignlevel" type="method" display="AssignLevel" />] + ;
*!*			[<memberdata name="assignmain" type="method" display="AssignMain" />] + ;
*!*			[<memberdata name="gettable" type="method" display="GetTable" />] + ;
*!*			[<memberdata name="nniveljerarquiatablas" type="property" display="nNivelJerarquiaTablas" />] + ;
*!*			[</VFPData>]

*!*		Procedure AddTable ( toTable As oTable Of 'DataDictionary\prg\DataDictionary.prg', tlNoSetParent As Boolean ) As Void HelpString 'Agrega una Tabla a la colección ColTables'

*!*			Local lcKey As String, ;
*!*				liIdx As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'
*!*			*:Global i as Integer, ;
*!*			oErr as Exception

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Agrega una Tabla a la colección ColTables
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Martes 29 de Mayo de 2007 (11:04:54)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					toTable As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*					tlNoSetParent As Boolean
*!*					*:Remarks:
*!*					*:Returns:
*!*					Object
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try

*!*				With This As ColTables Of 'DataDictionary\prg\DataDictionary.prg'
*!*					lcKey = Lower ( m.toTable.cKeyName )
*!*					liIdx = .GetKey ( m.lcKey )

*!*					If Empty ( m.liIdx )
*!*						If Empty ( m.toTable.LongTableName )
*!*							toTable.LongTableName = m.toTable.Name

*!*						Endif && Empty( m.toTable.LongTableName )

*!*						If ! m.tlNoSetParent
*!*							toTable.oParent = .oParent

*!*						Endif && ! tlNoSetParent
*!*						.AddItem ( m.toTable, m.lcKey )

*!*					Endif && Empty( m.i )

*!*				Endwith

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*		Endproc && AddTable

*!*		Procedure AssignMain ( toCol As collecton, toMain As Object ) As Void HelpString 'Asigna el principal a cada objeto oTable'

*!*			Local liIdx As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loField As oField Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loRefFieldMain As oField Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loTable As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*			*:Global i as Integer, ;
*!*			oErr as Exception

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Asigna el nivel a cada objeto oTable
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Lunes 6 de Febrero de 2006 (21:52:47)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					toCol As collecton
*!*					toMain As Object
*!*					*:Remarks:
*!*					*:Returns:
*!*					Object
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try

*!*				If m.toCol.Count > 0
*!*					loField        = m.toMain.GetPrimaryKey()
*!*					loRefFieldMain = This.oParent.oColFields.GetItem ( m.loField.Name )
*!*					If Vartype ( m.loRefFieldMain ) = 'O'
*!*						loRefFieldMain.nComboOrder      = Iif ( Empty ( m.loRefFieldMain.nComboOrder ), -1, m.loRefFieldMain.nComboOrder )
*!*						loRefFieldMain.nShowInKeyFinder = Iif ( Empty ( m.loRefFieldMain.nShowInKeyFinder ), -1, m.loRefFieldMain.nShowInKeyFinder )

*!*					Endif && Vartype( m.loRefFieldMain ) = 'O'

*!*					For liIdx = 1 To m.toCol.Count
*!*						loTable        = m.toCol.Item[ m.liIdx ]
*!*						loTable.MainID = m.loField.Name
*!*						This.AssignMain ( m.loTable.oColTables, m.toMain )

*!*					Endfor

*!*				Endif && m.toCol.Count > 0

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError        = Null
*!*				loRefFieldMain = Null
*!*				loTable        = Null
*!*				loField        = Null

*!*			Endtry

*!*		Endproc && AssignMain

*!*		Procedure AssignLevel ( toCol As collecton, tnNivel As Integer, tnNivelJerarquiaTablas As Integer ) As Void HelpString 'Asigna el nivel a cada objeto oTable'

*!*			Local liIdx As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loTable As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*			*:Global i as Integer, ;
*!*			oErr as Exception

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Asigna el nivel a cada objeto oTable
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Lunes 6 de Febrero de 2006 (21:52:47)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					toCol As collecton, tnNivel As Integer
*!*					tnNivelJerarquiaTablas As Integer
*!*					*:Remarks:
*!*					*:Returns:
*!*					Object
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				For liIdx = 1 To m.toCol.Count
*!*					loTable                = m.toCol.Item[ m.liIdx ]
*!*					loTable.Nivel          = m.tnNivel
*!*					tnNivelJerarquiaTablas = This.AssignLevel ( m.loTable.oColTables, m.tnNivel + 1, m.tnNivelJerarquiaTablas + 1 )

*!*				Endfor

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null
*!*				loTable = Null

*!*			Endtry

*!*			Return m.tnNivelJerarquiaTablas

*!*		Endproc && AssignLevel


*!*		Procedure AssignNivelJerarquiaTablas ( toCol As collecton, tnNivelJerarquiaTablas As Integer ) As Void HelpString 'Asigna el nivel de jerarquia a cada objeto oTable'

*!*			Local liIdx As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loTable As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*			*:Global i as Integer, ;
*!*			oErr as Exception

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Asigna el nivel de jerarquia a cada objeto oTable
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Lunes 6 de Febrero de 2006 (21:52:47)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					toCol As collecton
*!*					tnNivelJerarquiaTablas As Integer
*!*					*:Remarks:
*!*					*:Returns:
*!*					Object
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				For liIdx = 1 To m.toCol.Count
*!*					loTable                       = m.toCol.Item[ m.liIdx ]
*!*					loTable.nNivelJerarquiaTablas = m.tnNivelJerarquiaTablas
*!*					This.AssignNivelJerarquiaTablas ( m.loTable.oColTables, m.tnNivelJerarquiaTablas - 1 )

*!*				Endfor

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*		Endproc && AssignNivelJerarquiaTablas

*!*		* Devuelve una referencia a la tabla buscada
*!*		Procedure GetTable ( tcTableName As String ) As Object HelpString 'Devuelve una referencia a la tabla buscada'

*!*			Local liIdx As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loObj As oTable Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loTable As oTable Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loTableAux As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*			*:Global i as Integer, ;
*!*			oErr as Exception

*!*			#If .F.
*!*				TEXT
*!*				*:Help Documentation
*!*				*:Topic:
*!*				*:Description:
*!*				Devuelve una referencia a la tabla buscada
*!*				*:Project:
*!*				Sistemas Praxis
*!*				*:Autor:
*!*				Damián Eiff
*!*				*:Date:
*!*				Lunes 1 de Junio de 2009 (11:51:36)
*!*				*:ModiSummary:
*!*				*:Syntax:
*!*				*:Example:
*!*				*:Events:
*!*				*:NameSpace:
*!*				praxis.com
*!*				*:Keywords:
*!*				*:Implements:
*!*				*:Inherits:
*!*				*:Parameters:
*!*				tcTableName AS String
*!*				*:Remarks:
*!*				*:Returns:
*!*				Object
*!*				*:Exceptions:
*!*				*:SeeAlso:
*!*				*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try

*!*				With This As ColTables Of 'DataDictionary\prg\DataDictionary.prg'
*!*					* Pido la tabla con el nombre requerido
*!*					loTable = .GetItem ( m.tcTableName )
*!*					* Si no existe recorro la colección
*!*					liIdx = 1
*!*					Do While m.liIdx < .Count And Isnull ( m.loTable )
*!*						loTableAux = .Item[ m.liIdx ]
*!*						* Por cada tabla pido a su colección tables por la tabla buscada
*!*						loTable = m.loTableAux.oColTables.GetTable ( m.tcTableName )
*!*						liIdx   = m.liIdx + 1

*!*					Enddo

*!*				Endwith

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError    = Null
*!*				loTableAux = Null

*!*			Endtry

*!*			Return m.loTable

*!*		Endproc && GetTable

*!*	Enddefine && ColTables


*!*	* oTable
*!*	* Clase Table 
*!*	Define Class oTable As oBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Clase Table
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif


*!*		* Colección Fields
*!*		oColFields = Null

*!*		* Colección Forms
*!*		oColForms = Null

*!*		* Colección Entities
*!*		oColTiers = Null

*!*		* Colección Indices
*!*		oColIndexes = Null

*!*		* Colección de triggers para Update
*!*		oColUpdateTriggers = Null

*!*		* Colección de triggers para Delete
*!*		oColDeleteTriggers = Null

*!*		* Colección de triggers para Insert
*!*		oColInsertTriggers = Null

*!*		* Carpeta donde se encuentra la Tabla
*!*		Folder = ''

*!*		* Nombre largo de la tabla
*!*		LongTableName = ''

*!*		* Código de Página
*!*		Codepage = 1252

*!*		* Specifies the table validation rule.
*!*		* Must evaluate to a logical expression and can be a user-defined function
*!*		* or a stored procedure.
*!*		Check = ''

*!*		* Mensaje de error que se muestra si Check evalua a .F.
*!*		ErrorMessage = ''

*!*		* Extensión de la tabla
*!*		Ext = 'Dbf'

*!*		DataSession = SET_DEFAULT

*!*		* Indica si la entidad utiliza el campo Codigo, independientemente si lo tiene o no
*!*		lUseCodigo = .T.

*!*		* Indica si la entidad utiliza el campo CODIGO
*!*		lHasCodigo = .F.

*!*		* Indica si el campo CODIGO es numérico o alfanumérico
*!*		lCodigoIsNumeric = .F.

*!*		* Indica si la entidad utiliza el campo DESCRIPCION
*!*		lHasDescripcion = .F.

*!*		* Indica si la entidad utiliza el campo DEFAULT
*!*		lHasDefault = .F.

*!*		* Indica si la tabla implementa una extructura jerárquica
*!*		lIsHierarchical = .F.

*!*		cSetFirstFocus = ''

*!*		* Nombre de fantasía por el que se accede a la coleccion oDataDictionary
*!*		cKeyName = ''

*!*		* Tipo de clase CT_ARCHIVOS, CT_CHILD, CT_CHILDTREE
*!*		nClassType = CT_ARCHIVOS
*!*		Hidden nClassTypeDefault
*!*		nClassTypeDefault = CT_ARCHIVOS

*!*		* Clase de la cual hereda
*!*		cBaseClass = 'Archivos'
*!*		Hidden cBaseClassDefault
*!*		cBaseClassDefault = 'Archivos'

*!*		* Libreria de Clases de la cual hereda
*!*		cBaseClassLib = 'ERP\Archivos\'
*!*		Hidden cBaseClassLibDefault
*!*		cBaseClassLibDefault = 'ERP\Archivos\'

*!*		* Coleccion de propiedades
*!*		oColProperties = Null && As Collection

*!*		* Clase de la cual hereda el formulario
*!*		cFormClass = 'ABMGenericForm'
*!*		Hidden cFormClassDefault
*!*		cFormClassDefault = 'ABMGenericForm'

*!*		* Libreria de Clases del formulario
*!*		cFormClassLib = 'MainForm.vcx'

*!*		Hidden cFormClassLibDefault
*!*		cFormClassLibDefault = 'MainForm.vcx'

*!*		* Directorio de Libreria de Clases del formulario
*!*		cFormClassLibFolder = 'Core\vcx'

*!*		Hidden cFormClassLibFolderDefault
*!*		cFormClassLibFolderDefault = 'Core\vcx'

*!*		* Lista de Entidades asociadas
*!*		cChildList = ''

*!*		* Nombre del Formulario
*!*		cFormName = ''

*!*		* Directorio del Proyecto
*!*		cProjectPath = ''

*!*		* Las entidades y los formularios estan definidos en el Proyecto X
*!*		cIncludedInTheProject = ''

*!*		* Indica si se genera el metodo SetGridLayout
*!*		lGenerateSetGridLayaout = .T.


*!*		* Clave para identificar a la entidad
*!*		cDataConfigurationKey = ''

*!*		* Nombre del Cursor que representa a la tabla en las Tier
*!*		cCursorName = ''

*!*		* Colección de tablas
*!*		oColTables = Null

*!*		* Indica la cantidad de niveles de la entidad
*!*		nNivelJerarquiaTablas = 0

*!*		* Nombre de la tabla
*!*		Tabla = ''

*!*		* Nombre del cursor a generar.
*!*		*   Es la PK de la colección. No puede haber 2 elementos con la misma
*!*		*   propiedad CursorName
*!*		CursorName = ''

*!*		* En la tabla hija va el nombre de la tabla padre
*!*		Padre = ''

*!*		* en la tabla hija va el nombre del campo con el que se relaciona
*!*		* con la tabla padre (Foreign Key)
*!*		ForeignKeyeignKeyeignKeyeignKeyeignKeyeignKeyeignKeyeignKeyeignKeyeignKeyeignKeyeignKeyeignKeyeignKeyeignKeyeignKey = ''

*!*		* Referencia al nombre del campo que contiene el ID
*!*		* de la tabla de nivel 1 con la que está relacionada.
*!*		MainID = ''

*!*		* Para NEW y GETONE, se puede definir una sentencia SQL
*!*		SQLStat = ''

*!*		* SQL para los selectores
*!*		SQLStatSelector = ''

*!*		* Indica la clausula ORDER BY para el combo
*!*		cOrderBySelector = ''

*!*		* SQL para los combo
*!*		SQLStatCombo = ''

*!*		* Indica la clausula ORDER BY para el combo
*!*		cOrderByCombo = ''

*!*		* SQL para los KeyFinder
*!*		SQLStatKeyFinder = ''

*!*		* Nombre de la Primary Key de la tabla/nivel de la entidad
*!*		PKName = ''

*!*		* Indica si la PK es Updatable para incluirla o no en la UpdatableFieldList
*!*		PKUpdatable = .F.

*!*		* Guarda la última sentencia SQL utilzada para consulta
*!*		LastSQL = ''

*!*		* Nivel de profundidad de la tabla
*!*		Nivel = 0

*!*		*!*
*!*		UpdatableFieldList = ''

*!*		*!*
*!*		UpdateNameList = ''

*!*		* Obtiene la propiedad UpdateNameList de la sentencia SQL
*!*		GetFieldListFromSQLStat = .F.

*!*		*!*
*!*		oCursorAdapter = ''

*!*		* Numero de Registro Actual de la tabla
*!*		CurReg = 0

*!*		* Indica si la tabla es una tabla auxiliar
*!*		Auxiliary = .F.

*!*		* Indica la clausula ORDER BY para el GetAll(), en caso de Nivel 1, o las tablas Hijas, para los demás niveles
*!*		OrderBy = ''

*!*		* Utiliza SELECT * para generar la UpdatableFieldList. Si es .F., utiliza SQLStat
*!*		lGenericUpdatableFieldList = .T.

*!*		* Clausula WHERE para la tabla
*!*		WhereStatement = ''

*!*		* Nombre unico de la entidad en el archivo de configuracion
*!*		cDataConfigurationKey = ''

*!*		* Indica si la tabla implementa una extructura jerárquica
*!*		lIsHierarchical = .F.

*!*		* Colección de Reportes
*!*		oColReport = Null

*!*		* Clase base que utiliza la entidad
*!*		cBaseClass = 'Archivo'

*!*		* Indica si la entida tiene UT
*!*		lHasUserTier = .F.

*!*		* Indica si la entida tiene ST
*!*		lHasServiceTier = .F.

*!*		* Indica si la entida tiene BT
*!*		lHasBizTier = .F.

*!*		* Indica si la entida tiene DT
*!*		lHasDataTier = .F.

*!*		*!*
*!*		cClassLibFldUserTier = TA_USERTIER

*!*		*!*
*!*		cClassLibFldServiceTier = TA_SERVICETIER

*!*		*!*
*!*		cClassLibFldBizTier = TA_BIZTIER

*!*		*!*
*!*		cClassLibFldDataTier = TA_DATATIER

*!*		* Indica si la tabla implementa el modelo de relaciones
*!*		lSetRelations = .T.

*!*		* Indica si la tabla es _VIRTUAL y _NO pertenece a la base de datos
*!*		* Se genera un cursor en base a un SELECT SQL
*!*		lIsVirtual = .F.

*!*		* Indica si la tabla tiene una tabla donde se registren las modificaciones realizadas
*!*		lHasActivityLog = .F.

*!*		lCreateIfNotExist = .T.

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="lcreateifnotexist" type="property" display="lCreateIfNotExist" />] + ;
*!*			[<memberdata name="corderbyselector" type="property" display="cOrderBySelector" />] + ;
*!*			[<memberdata name="corderbycombo" type="property" display="cOrderByCombo" />] + ;
*!*			[<memberdata name="sqlstatselector" type="property" display="SQLStatSelector" />] + ;
*!*			[<memberdata name="sqlstatcombo" type="property" display="SQLStatCombo" />] + ;
*!*			[<memberdata name="sqlstatkeyfinder" type="property" display="SQLStatKeyFinder" />] + ;
*!*			[<memberdata name="lhasactivitylog" type="property" display="lHasActivityLog" />] + ;
*!*			[<memberdata name="lisvirtual" type="property" display="lIsVirtual" />] + ;
*!*			[<memberdata name="lsetrelations" type="property" display="lSetRelations" />] + ;
*!*			[<memberdata name="cclasslibfldusertier" type="property" display="cClassLibFldUserTier" />] + ;
*!*			[<memberdata name="cclasslibflddatatier" type="property" display="cClassLibFldDataTier" />] + ;
*!*			[<memberdata name="cclasslibfldbiztier" type="property" display="cClassLibFldBizTier" />] + ;
*!*			[<memberdata name="cclasslibfldservicetier" type="property" display="cClassLibFldServiceTier" />] + ;
*!*			[<memberdata name="lhasdatatier" type="property" display="lHasDataTier" />] + ;
*!*			[<memberdata name="lhasbiztier" type="property" display="lHasBizTier" />] + ;
*!*			[<memberdata name="lhasservicetier" type="property" display="lHasServiceTier" />] + ;
*!*			[<memberdata name="lhasusertier" type="property" display="lHasUserTier" />] + ;
*!*			[<memberdata name="cbaseclass" type="property" display="cBaseClass" />] + ;
*!*			[<memberdata name="ocolreport" type="property" display="oColReport" />] + ;
*!*			[<memberdata name="lusecodigo" type="property" display="lUseCodigo" />] + ;
*!*			[<memberdata name="ckeyname" type="property" display="cKeyName" />] + ;
*!*			[<memberdata name="nniveljerarquiatablas" type="property" display="nNivelJerarquiaTablas" />] + ;
*!*			[<memberdata name="ocolinserttriggers" type="property" display="oColInsertTriggers" />] + ;
*!*			[<memberdata name="ocoldeletetriggers" type="property" display="oColDeleteTriggers" />] + ;
*!*			[<memberdata name="ocolupdatetriggers" type="property" display="oColUpdateTriggers" />] + ;
*!*			[<memberdata name="ext" type="property" display="Ext" />] + ;
*!*			[<memberdata name="errormessage" type="property" display="ErrorMessage" />] + ;
*!*			[<memberdata name="check" type="property" display="Check" />] + ;
*!*			[<memberdata name="codepage" type="property" display="CodePage" />] + ;
*!*			[<memberdata name="longtablename" type="property" display="LongTableName" />] + ;
*!*			[<memberdata name="ocolfields" type="property" display="oColFields" />] + ;
*!*			[<memberdata name="folder" type="property" display="Folder" />] + ;
*!*			[<memberdata name="ocolindexes" type="property" display="oColIndexes" />] + ;
*!*			[<memberdata name="initialize" type="method" display="Initialize" />] + ;
*!*			[<memberdata name="classbeforeinitialize" type="method" display="ClassBeforeInitialize" />] + ;
*!*			[<memberdata name="addtreehierarchicalfields" type="method" display="AddTreeHierarchicalFields" />] + ;
*!*			[<memberdata name="addhierarchicalfields" type="method" display="AddHierarchicalFields" />] + ;
*!*			[<memberdata name="addcodigoydescripcion" type="method" display="AddCodigoYDescripcion" />] + ;
*!*			[<memberdata name="nclasstype" type="property" display="nClassType" />] + ;
*!*			[<memberdata name="cbaseclass" type="property" display="cBaseClass" />] + ;
*!*			[<memberdata name="cbaseclasslib" type="property" display="cBaseClassLib" />] + ;
*!*			[<memberdata name="ocolproperties" type="property" display="oColProperties" />] + ;
*!*			[<memberdata name="cformclass" type="property" display="cFormClass" />] + ;
*!*			[<memberdata name="cformclasslib" type="property" display="cFormClassLib" />] + ;
*!*			[<memberdata name="cformclasslibfolder" type="property" display="cFormClassLibFolder" />] + ;
*!*			[<memberdata name="cchildlist" type="property" display="cChildList" />] + ;
*!*			[<memberdata name="hookpopulateproperties" type="method" display="HookPopulateProperties" />] + ;
*!*			[<memberdata name="cformname" type="property" display="cFormName" />] + ;
*!*			[<memberdata name="cprojectpath" type="property" display="cProjectPath" />] + ;
*!*			[<memberdata name="cincludedintheproject" type="property" display="cIncludedInTheProject" />] + ;
*!*			[<memberdata name="getprimarykey" type="method" display="GetPrimaryKey" />] + ;
*!*			[<memberdata name="lgeneratesetgridlayaout" type="property" display="lGenerateSetGridLayaout" />] + ;
*!*			[<memberdata name="cdataconfigurationkey" type="property" display="cDataConfigurationKey" />] + ;
*!*			[<memberdata name="setasarchivo" type="method" display="SetAsArchivo" />] + ;
*!*			[<memberdata name="setaschild" type="method" display="SetAsChild" />] + ;
*!*			[<memberdata name="setaschildtree" type="method" display="SetAsChildTree" />] + ;
*!*			[<memberdata name="ccursorname" type="property" display="cCursorName" />] + ;
*!*			[<memberdata name="getprimarytagname" type="method" display="GetPrimaryTagName" />] + ;
*!*			[<memberdata name="lhasdefault" type="property" display="lHasDefault" />] + ;
*!*			[<memberdata name="lhasdescripcion" type="property" display="lHasDescripcion" />] + ;
*!*			[<memberdata name="lhascodigo" type="property" display="lHasCodigo" />] + ;
*!*			[<memberdata name="csetfirstfocus" type="property" display="cSetFirstFocus" />] + ;
*!*			[<memberdata name="ocolforms" type="property" display="oColForms" />] + ;
*!*			[<memberdata name="ocoltiers" type="property" display="oColTiers" />] + ;
*!*			[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
*!*			[<memberdata name="lishierarchical" type="property" display="lIsHierarchical" />] + ;
*!*			[<memberdata name="getfieldlistfromsqlstat" type="property" display="GetFieldListFromSQLStat" />] + ;
*!*			[<memberdata name="nivel" type="property" display="Nivel" />] + ;
*!*			[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
*!*			[<memberdata name="lastsql" type="property" display="LastSQL" />] + ;
*!*			[<memberdata name="pkupdatable" type="property" display="PKUpdatable" />] + ;
*!*			[<memberdata name="pkname" type="property" display="PKName" />] + ;
*!*			[<memberdata name="sqlstat" type="property" display="SQLStat" />] + ;
*!*			[<memberdata name="mainid" type="property" display="MainID" />] + ;
*!*			[<memberdata name="foreignkey" type="property" display="ForeignKey" />] + ;
*!*			[<memberdata name="padre" type="property" display="Padre" />] + ;
*!*			[<memberdata name="cursorname" type="property" display="CursorName" />] + ;
*!*			[<memberdata name="tabla" type="property" display="Tabla" />] + ;
*!*			[<memberdata name="updatablefieldlist" type="property" display="UpdatableFieldList" />] + ;
*!*			[<memberdata name="updatenamelist" type="property" display="UpdateNameList" />] + ;
*!*			[<memberdata name="ocursoradapter" type="property" display="oCursorAdapter" />] + ;
*!*			[<memberdata name="curreg" type="property" display="CurReg" />] + ;
*!*			[<memberdata name="auxiliary" type="property" display="Auxiliary" />] + ;
*!*			[<memberdata name="orderby" type="property" display="OrderBy" />] + ;
*!*			[<memberdata name="lgenericupdatablefieldlist" type="property" display="lGenericUpdatableFieldList" />] + ;
*!*			[<memberdata name="wherestatement" type="property" display="WhereStatement" />] + ;
*!*			[<memberdata name="cdataconfigurationkey" type="property" display="cDataConfigurationKey" />] + ;
*!*			[<memberdata name="lcodigoisnumeric" type="property" display="lCodigoIsNumeric" />] + ;
*!*			[</VFPData>]

*!*		* cDataConfigurationKey_Access
*!*		Protected Procedure cDataConfigurationKey_Access()

*!*			If Empty ( This.cDataConfigurationKey )
*!*				This.cDataConfigurationKey = This.Name  && Substr( This.CursorName, 2 )

*!*			Endif && Empty( This.cDataConfigurationKey )

*!*			Return This.cDataConfigurationKey

*!*		Endproc && cDataConfigurationKey_Access

*!*		* cDataConfigurationKey_Access
*!*		Procedure cDataConfigurationKey_Access()

*!*			Local lcTableName As String, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damian Eiff

*!*				 *:Date:
*!*				 Viernes 13 de Marzo de 2009 (17:22:26)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try

*!*				If Vartype ( This.cDataConfigurationKey ) # 'C' Or Empty ( This.cDataConfigurationKey )
*!*					lcTableName                = m.String.CamelProperCase ( Alltrim ( This.Name ) )
*!*					This.cDataConfigurationKey = Chrtran ( Chrtran ( lcTableName, ' ', '' ), '-', '_' )

*!*				Endif

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry
*!*			Return This.cDataConfigurationKey

*!*		Endproc  && cDataConfigurationKey_Access

*!*		* cFormName_Access
*!*		Procedure cFormName_Access()
*!*			Local loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'
*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damian Eiff

*!*				 *:Date:
*!*				 Miércoles 11 de Marzo de 2009 (14:21:49)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				If Vartype ( This.cFormName ) # 'C'  Or Empty ( This.cFormName )
*!*					This.cFormName = 'ABM' + Space ( 1 ) + This.Name

*!*				Endif

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return This.cFormName

*!*		Endproc  && cFormName_Access

*!*		* CursorName_Access
*!*		Protected Procedure CursorName_Access()
*!*			With This
*!*				If Empty ( .CursorName )
*!*					.CursorName = 'c' + .Name

*!*				Endif && Empty( .CursorName )

*!*			Endwith

*!*			Return This.CursorName

*!*		Endproc && CursorName_Access

*!*		* UpdatableFieldList_Access
*!*		Protected Procedure UpdatableFieldList_Access()
*!*			With This
*!*				If Empty ( .UpdatableFieldList )
*!*					.UpdatableFieldList = .oColFields.ToString ( 'Name', ',', 'Autoinc = .F. And lIsVirtual = .F.')

*!*				Endif &&  Empty( .UpdatableFieldList )

*!*			Endwith

*!*			Return This.UpdatableFieldList

*!*		Endproc && UpdatableFieldList_Access

*!*		* UpdateNameList_Access
*!*		Protected Procedure UpdateNameList_Access()
*!*			With This
*!*				If Empty ( .UpdateNameList )
*!*					.UpdateNameList = .oColFields.ToString ( "Name + ' " + .Name + ".' + Name", ',', 'lIsVirtual = .F.' )

*!*				Endif && Empty( .CursorName )
*!*			Endwith
*!*			Return This.UpdateNameList

*!*		Endproc && UpdateNameList_Access

*!*		* oColReport_Access
*!*		Procedure oColReport_Access()

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Jueves 6 de Agosto de 2009 (12:27:57)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			With This
*!*				If Vartype ( .oColReport ) # 'O'
*!*					.oColReport = Newobject ( 'ColReports', 'DataDictionary\prg\DataDictionary.prg' )

*!*				Endif && Vartype( .oColReport ) # "O"
*!*			Endwith
*!*			Return This.oColReport

*!*		Endproc && oColReport_Access

*!*		* Tabla_Access
*!*		Protected Procedure Tabla_Access()

*!*			If Empty ( This.Tabla )
*!*				This.Tabla = This.Name

*!*			Endif && Empty( This.Tabla )

*!*			Return This.Tabla

*!*		Endproc && CursorName_Access

*!*		* Init
*!*		Procedure Init () As Void

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 15 de Abril de 2008 (10:51:28)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			With This As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*				.oColTables = Createobject ( 'ColTables' )
*!*				* DAE 2009-11-11(14:43:43)
*!*				.oColTables.oParent = This
*!*				.ClassBeforeInitialize()
*!*				.Initialize()

*!*				.ClassAfterInitialize()

*!*			Endwith

*!*		Endproc && Init

*!*		* ClassBeforeInitialize
*!*		Procedure ClassBeforeInitialize ( ) As Void

*!*			Local lcField As String, ;
*!*				lcName As String, ;
*!*				loColFields As ColFields Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loColTiers As Object, ;
*!*				loEcfg As Object, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loField As oField Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loeEcfg As Object

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 15 de Abril de 2008 (10:51:09)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try

*!*				lcName = Strtran ( This.Name, 'sys_', '', -1, -1, 1 )

*!*				* PrimaryKey
*!*				loColFields              = This.oColFields
*!*				loField                  = m.loColFields.NewPK ( m.lcName + 'Id' )
*!*				loField.nGridOrder       = -1
*!*				loField.nComboOrder      = -1
*!*				loField.nSelectorOrder   = -1
*!*				loField.nShowInKeyFinder = -1

*!*				This.PKName = m.loField.Name

*!*				If This.lIsHierarchical
*!*					* ParentPK
*!*					lcField = 'Parent' + m.lcName + 'Id'
*!*					loField = m.loColFields.NewFK ( m.lcField )
*!*					With m.loField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*						.References                = This.Name
*!*						.lIsSystem                 = .T.
*!*						.TriggerConditionForInsert = '! Empty( ' + This.Name + '.' + m.lcField + ' )'
*!*						.TriggerConditionForUpdate = .TriggerConditionForInsert
*!*						.Check                     = ''
*!*						.ErrorMessage              = ''

*!*					Endwith

*!*					* tvwNivel
*!*					loField = m.loColFields.New ( 'tvwNivel', 'I' )
*!*					With loField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*						.lIsSystem = .T.

*!*					Endwith

*!*					* tvwSecuencia
*!*					loField = m.loColFields.NewRegular ( 'tvwSecuencia', 'V', 20 )
*!*					With m.loField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*						.lIsSystem = .T.

*!*					Endwith

*!*					* ParentUniqueCode
*!*					loField = m.loColFields.New ( 'ParentUniqueCode', 'character', 20 )
*!*					With m.loField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*						.lIsSystem = .T.

*!*					Endwith

*!*				Endif && This.lIsHierarchical

*!*				If This.lHasCodigo
*!*					* Codigo
*!*					If This.lCodigoIsNumeric
*!*						loField = m.loColFields.NewCandidate ( 'Codigo', 'Integer' )

*!*						With m.loField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*							.cSearchCondition  = '!#'
*!*							.cDefaultCondition = '!#'

*!*						Endwith

*!*					Else && This.lCodigoIsNumeric
*!*						loField = m.loColFields.NewCandidate ( 'Codigo', 'Character', 10)

*!*						With m.loField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*							.cSearchCondition  = 'like'
*!*							.cDefaultCondition = 'like'

*!*						Endwith

*!*					Endif && This.lCodigoIsNumeric

*!*					With m.loField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*						.Caption           = 'Código'
*!*						.cReferenceCaption = .oParent.Name + ' Código'
*!*						.lRequired         = .T.
*!*						.lShowInGrid       = .T.
*!*						.lShowInNavigator  = .T.
*!*						.nShowInKeyFinder  = 1
*!*						.lFastSearch       = .T.
*!*						.nGridOrder        = 1
*!*						.nComboOrder       = 1
*!*						.nSelectorOrder    = 1
*!*						.lIndexOnClient    = .T.
*!*						.nDefaultReference = 1

*!*					Endwith

*!*				Else
*!*					This.lUseCodigo = .F.

*!*				Endif && This.lHasCodigo

*!*				If This.lHasDescripcion
*!*					* Descripcion
*!*					loField = m.loColFields.NewRegular ( 'Descripcion', 'Character', 30 )

*!*					With m.loField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*						.CaseSensitive     = .F.
*!*						.Caption           = 'Descripción'
*!*						.ErrorMessage      = 'El Campo DESCRIPCION no puede estar vacío'
*!*						.lRequired         = .T.
*!*						.lShowInGrid       = .T.
*!*						.lShowInNavigator  = .T.
*!*						.lFastSearch       = .T.
*!*						.cSearchCondition  = '%'
*!*						.lFitColumn        = .T.
*!*						.cReferenceCaption = .oParent.Name

*!*						.nGridOrder  = 2
*!*						.nComboOrder = 2


*!*						If ! This.lHasCodigo
*!*							.nShowInKeyFinder  = 1
*!*							.nDefaultReference = 1
*!*							.nSelectorOrder    = 1

*!*						Else
*!*							.nShowInKeyFinder  = 2
*!*							.nDefaultReference = 2
*!*							.nSelectorOrder    = 2

*!*						Endif && ! This.lHasCodigo
*!*						.lIndexOnClient = .T.

*!*					Endwith

*!*				Endif && This.lHasDescripcion

*!*				If This.lHasDefault
*!*					* Default
*!*					loField = m.loColFields.New ( 'Default', 'logical' )

*!*					With m.loField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*						.Caption          = 'Predeterminada'
*!*						.nGridOrder       = -1
*!*						.nComboOrder      = -1
*!*						.nSelectorOrder   = -1
*!*						.nShowInKeyFinder = -1

*!*					Endwith

*!*				Endif && This.lHasDefault

*!*				* Time Stamp
*!*				loField = m.loColFields.New ( 'TS', 'DateTime' )
*!*				With m.loField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*					.Check        = ' ! Empty( TS )'
*!*					.ErrorMessage = 'El Campo TS no puede estar vacío'
*!*					.Caption      = 'Time Stamp'
*!*					* DAE 2009-09-22(15:54:38)
*!*					.Default   = 'DateTime()'
*!*					.lIsSystem = .T.

*!*				Endwith

*!*				* TransactionId
*!*				loField = m.loColFields.New ( 'TransactionId', 'Integer' )
*!*				With m.loField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*					.Check        = '!Empty( TransactionId )'
*!*					.ErrorMessage = 'El Campo TransactionId no puede estar vacío'
*!*					.Caption      = 'Transacción'
*!*					.lIsSystem    = .T.

*!*				Endwith

*!*				loColTiers = This.oColTiers

*!*				* User
*!*				loeEcfg = m.loColTiers.New ( 'User' )
*!*				If This.lHasUserTier
*!*					loeEcfg.cObjClass = 'ut' + m.lcName

*!*				Else
*!*					loeEcfg.cObjClass = 'ut' + This.cBaseClass

*!*				Endif && This.lHasUserTier
*!*				loeEcfg.cObjClassLibraryFolder = This.cClassLibFldUserTier
*!*				loeEcfg.cObjComponent          = COM_TA

*!*				* Service
*!*				loeEcfg = m.loColTiers.New ( 'Service' )
*!*				If This.lHasServiceTier
*!*					loeEcfg.cObjClass = 'st' + m.lcName

*!*				Else
*!*					loeEcfg.cObjClass = 'st' + This.cBaseClass

*!*				Endif && This.lHasServiceTier
*!*				loeEcfg.cObjClassLibraryFolder = This.cClassLibFldServiceTier
*!*				loeEcfg.cObjComponent          = COM_TA

*!*				*!*	* Wrapper
*!*				*!*	loeEcfg = loColTiers.New( "Wrapper" )
*!*				* If This.lHasWrapperTier
*!*				*!*		loeEcfg.cObjClass = "bt" + lcName + "Wrapper"
*!*				* Else
*!*				* 	loeEcfg.cObjClass = "bt" + This.cBaseClass + "Wrapper"
*!*				* Endif && This.lHasWrapperTier
*!*				* loeEcfg.cObjClassLibraryFolder = This.cClassLibFldWrapperTier
*!*				* loeEcfg.cObjComponent = COM_TA
*!*				* loeEcfg.lObjInComComponent = .T.

*!*				* Business
*!*				loeEcfg = m.loColTiers.New ( 'Business' )
*!*				If This.lHasBizTier
*!*					loeEcfg.cObjClass = 'bt' + m.lcName

*!*				Else
*!*					loeEcfg.cObjClass = 'bt' + This.cBaseClass

*!*				Endif && This.lHasBizTier
*!*				loeEcfg.cObjClassLibraryFolder = This.cClassLibFldBizTier
*!*				loeEcfg.cObjComponent          = COM_TA
*!*				loeEcfg.lObjInComComponent     = .T.

*!*				* Data
*!*				loeEcfg = loColTiers.New ( 'Data' )
*!*				If This.lHasDataTier
*!*					loeEcfg.cObjClass = 'dt' + m.lcName

*!*				Else
*!*					loeEcfg.cObjClass = 'dt' + This.cBaseClass

*!*				Endif && This.lHasDataTier
*!*				loeEcfg.cObjClassLibraryFolder = This.cClassLibFldDataTier
*!*				loeEcfg.cObjComponent          = COM_TA
*!*				loeEcfg.lObjInComComponent     = .T.

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError     = Null
*!*				loColTiers  = Null
*!*				loEcfg      = Null
*!*				loField     = Null
*!*				loColFields = Null

*!*			Endtry

*!*		Endproc && ClassBeforeInitialize

*!*		* Initialize
*!*		Procedure Initialize ( ) As Void
*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 15 de Abril de 2008 (10:49:20)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*		Endproc && Initialize

*!*		* ClassAfterInitialize
*!*		Procedure ClassAfterInitialize() As Void

*!*			Local liIdx As Integer, ;
*!*				loColFields As ColFields Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loField As oField Of 'DataDictionary\prg\DataDictionary.prg'

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 15 de Abril de 2008 (10:51:09)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try
*!*				With This As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*					loColFields = .oColFields
*!*					If ! Empty ( .cSetFirstFocus )
*!*						* loField = This.oColFields.GetItem( Lower( This.cSetFirstFocus ))
*!*						loField                = m.loColFields.GetItem ( .cSetFirstFocus )
*!*						loField.lGetFirstFocus = .T.

*!*					Endif && ! Empty( .cSetFirstFocus )

*!*					liIdx = m.loColFields.GetKey ( '_recordorder' )
*!*					If Empty ( m.liIdx )
*!*						loField           = m.loColFields.NewVirtual ( '_RecordOrder', 'Int' )
*!*						loField.lIsSystem = .T.

*!*					Else
*!*						loField = m.loColFields.Item[ i  ]

*!*					Endif && Empty( m.liIdx )

*!*					loField.nComboOrder    = -1
*!*					loField.nGridOrder     = -1
*!*					loField.nSelectorOrder = -1

*!*					liIdx = m.loColFields.GetKey ( 'selected' )
*!*					If Empty ( m.liIdx )
*!*						loField           = m.loColFields.NewVirtual ( 'Selected', 'Logical' )
*!*						loField.lIsSystem = .T.

*!*						If .lHasDefault
*!*							loField.cDefaultSqlExp = .Name + '.Default Selected'

*!*						Endif && .lHasDefault

*!*					Else
*!*						loField = m.loColFields.Item[ i  ]

*!*					Endif && Empty( m.i )

*!*					loField.nComboOrder    = -1
*!*					loField.nGridOrder     = -1
*!*					loField.nSelectorOrder = -1

*!*				Endwith

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loField     = Null
*!*				loError     = Null
*!*				loColFields = Null

*!*			Endtry

*!*		Endproc && ClassAfterInitialize

*!*		Procedure oColFields_Access
*!*			If Vartype ( This.oColFields ) # 'O'
*!*				This.oColFields         = Createobject ( 'ColFields' )
*!*				This.oColFields.oParent = This

*!*			Endif && Vartype( This.oColFields ) # "O"

*!*			Return This.oColFields

*!*		Endproc && oColFields_Access

*!*		Procedure oColForms_Access
*!*			If Vartype ( This.oColForms ) # 'O'
*!*				This.oColForms         = Createobject ( 'ColForms' )
*!*				This.oColForms.oParent = This

*!*			Endif && Vartype( This.oColForms ) # "O"

*!*			Return This.oColForms

*!*		Endproc && oColForms_Access

*!*		Procedure oColTiers_Access
*!*			If Vartype ( This.oColTiers ) # 'O'
*!*				This.oColTiers         = Createobject ( 'ColTiers' )
*!*				This.oColTiers.oParent = This

*!*			Endif

*!*			Return This.oColTiers

*!*		Endproc && oColForms_Access

*!*		Procedure oColIndexes_Access

*!*			If Vartype ( This.oColIndexes ) # 'O'
*!*				This.oColIndexes         = Createobject ( 'ColIndexes' )
*!*				This.oColIndexes.oParent = This

*!*			Endif && Vartype( This.oColIndexes ) # "O"

*!*			Return This.oColIndexes

*!*		Endproc && oColIndexes_Access

*!*		Procedure oColDeleteTriggers_Access
*!*			If Vartype ( This.oColDeleteTriggers ) # 'O'
*!*				This.oColDeleteTriggers         = Createobject ( 'ColDeleteTriggers' )
*!*				This.oColDeleteTriggers.oParent = This

*!*			Endif && Vartype( This.oColDeleteTriggers ) # "O"

*!*			Return This.oColDeleteTriggers

*!*		Endproc && oColDeleteTriggers_Access

*!*		Procedure oColInsertTriggers_Access
*!*			If Vartype ( This.oColInsertTriggers ) # 'O'
*!*				This.oColInsertTriggers         = Createobject ( 'ColInsertTriggers' )
*!*				This.oColInsertTriggers.oParent = This

*!*			Endif && Vartype( This.oColInsertTriggers ) # "O"

*!*			Return This.oColInsertTriggers

*!*		Endproc && oColInsertTriggers_Access

*!*		Procedure oColUpdateTriggers_Access
*!*			If Vartype ( This.oColUpdateTriggers ) # 'O'
*!*				This.oColUpdateTriggers         = Createobject ( 'ColUpdateTriggers' )
*!*				This.oColUpdateTriggers.oParent = This

*!*			Endif && Vartype( This.oColUpdateTriggers ) # "O"

*!*			Return This.oColUpdateTriggers

*!*		Endproc && oColUpdateTriggers_Access


*!*		* Comment_Assign
*!*		Procedure Comment_Assign ( tcComment As String ) As String

*!*			Local lcStr As String

*!*			#If .F.
*!*				TEXT
*!*					 *:Help Documentation
*!*					 *:Project:
*!*					 Sistemas Praxis

*!*					 *:Autor:
*!*					 Damián Eiff

*!*					 *:Date:
*!*					 Jueves 10 de Abril de 2008 (13:31:54)

*!*					 *:Parameters:
*!*					 *:Remarks:
*!*					 *:Returns:
*!*					 *:Example:
*!*					 *:SeeAlso:
*!*					 *:Events:
*!*					 *:KeyWords:
*!*					 *:Inherits:
*!*					 *:Exceptions:
*!*					 *:NameSpace:
*!*					 digitalizarte.com
*!*					 *:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			If Len ( tcComment ) > 253
*!*				lcStr = 'La Propiedad ' + This.LongTableName + '.Comment es demasiado largo(' + m.String.Any2Char ( Len ( tcComment ) ) + ')' + CR + CR
*!*				lcStr = lcStr + tcComment
*!*				Error lcStr

*!*			Else
*!*				This.Comment = tcComment

*!*			Endif

*!*			Return This.Comment

*!*		Endproc && Comment_Assign


*!*		* oColProperties_Access
*!*		Procedure oColProperties_Access()

*!*			#If .F.
*!*				TEXT
*!*			 *:Help Documentation
*!*			 *:Autor:
*!*			 Damian Eiff

*!*			 *:Date:
*!*			 Martes 10 de Marzo de 2009 (19:28:52)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			If Vartype ( This.oColProperties ) # 'O'
*!*				This.oColProperties = Createobject ( 'ColProperties' )
*!*				This.HookPopulateProperties()

*!*			Endif

*!*			Return This.oColProperties

*!*		Endproc && oColProperties_Access

*!*		* HookPopulateProperties
*!*		Procedure HookPopulateProperties () As Void HelpString 'Carga las popiedades iniciales que se definen para las Tier o los Form'

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Autor:
*!*				 Damian Eiff

*!*				 *:Date:
*!*				 Martes 10 de Marzo de 2009 (19:41:59)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*		Endproc && HookPopulateProperties

*!*		* GetPrimaryKey
*!*		* Devuelve el campo que representa a la clave primaria 
*!*		Procedure GetPrimaryKey() As oField Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Devuelve el campo que representa a la clave primaria'

*!*			Local loColData As Object, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loFieldRet As oField Of 'DataDictionary\prg\DataDictionary.prg'


*!*			#If .F.
*!*				TEXT
*!*					 *:Help Documentation
*!*					 *:Description:
*!*					 Devuelve el campo que representa a la clave primaria
*!*					 *:Project:
*!*					 Sistemas Praxis

*!*					 *:Autor:
*!*					 Damian Eiff

*!*					 *:Date:
*!*					 Viernes 13 de Marzo de 2009 (15:14:26)

*!*					 *:Parameters:
*!*					 *:Remarks:
*!*					 *:Returns:
*!*					 *:Example:
*!*					 *:SeeAlso:
*!*					 *:Events:
*!*					 *:KeyWords:
*!*					 *:Inherits:
*!*					 *:Exceptions:
*!*					 *:NameSpace:
*!*					 digitalizarte.com
*!*					 *:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try

*!*				*!*	For Each loField As oField Of 'DataDictionary\prg\DataDictionary.prg' In This.oColFields
*!*				*!*		If loField.IndexKey = IK_PRIMARY_KEY
*!*				*!*			loFieldRet = loField
*!*				*!*			Exit

*!*				*!*		Endif && loField.IndexKey = IK_PRIMARY_KEY

*!*				*!*	Endfor
*!*				*!*	If Vartype( loFieldRet ) = 'O' And loFieldRet.IndexKey # IK_PRIMARY_KEY
*!*				*!*		loFieldRet = Null

*!*				*!*	Endif
*!*				With This
*!*					loColData  = .oColFields.Where ( 'IndexKey == ' + Transform ( IK_PRIMARY_KEY ) )
*!*					loFieldRet = m.loColData.Item[ i ]

*!*				Endwith

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError   = Null
*!*				loColData = Null

*!*			Endtry

*!*			Return loFieldRet

*!*		Endproc && GetPrimaryKey

*!*		* GetPrimaryTagName
*!*		* Devuelve el TAG de la clave primaria 
*!*		Procedure GetPrimaryTagName ( ) As oField Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Devuelve el TAG de la clave primaria'

*!*			Local lcTagName As String, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loField As oField Of 'DataDictionary\prg\DataDictionary.prg'

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Devuelve el TAG de la clave primaria
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damian Eiff

*!*				 *:Date:
*!*				 Viernes 13 de Marzo de 2009 (15:14:26)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try

*!*				lcTagName = ''
*!*				loField   = This.GetPrimaryKey()
*!*				If ! Empty ( loField.TagName )
*!*					lcTagName = loField.TagName

*!*				Endif && ! Empty( loField.TagName )

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loField = Null
*!*				loError = Null

*!*			Endtry

*!*			Return lcTagName

*!*		Endproc  && GetPrimaryTagName

*!*		* cCursorName_Access
*!*		Procedure cCursorName_Access()

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damian Eiff

*!*				 *:Date:
*!*				 Sábado 21 de Marzo de 2009 (13:01:14)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			With This
*!*				If Vartype ( .cCursorName ) # 'C' Or Empty ( .cCursorName )
*!*					.cCursorName = 'c' + .Name

*!*				Endif && Vartype( .cCursorName ) # 'C' Or Empty( .cCursorName )

*!*			Endwith
*!*			Return This.cCursorName

*!*		Endproc && cCursorName_Access

*!*		*
*!*		* cKeyName_Access
*!*		Protected Procedure cKeyName_Access()
*!*			With This
*!*				If Empty ( .cKeyName )
*!*					.cKeyName = Strtran ( Lower ( .Name ), 'sys_', '' )
*!*				Endif
*!*			Endwith
*!*			Return This.cKeyName

*!*		Endproc && cKeyName_Access

*!*		*
*!*		* SQLStat_Access
*!*		Protected Procedure SQLStat_Access() As String

*!*			Local loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			Try
*!*				With This
*!*					* Assert ! Empty( This.SQLStat ) Message 'SQLStat'
*!*					If Empty ( .SQLStat ) Or Vartype ( .SQLStat ) # 'C'
*!*						.SQLStat = .oParent.GetSelectSQL ( This, '', .T. )

*!*					Endif && Empty( This.SQLStat )
*!*				Endwith
*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return This.SQLStat

*!*		Endproc && SQLStat_Access

*!*		*
*!*		* SQLStatCombo_Access
*!*		Protected Procedure SQLStatCombo_Access() As String

*!*			Local loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			Try
*!*				* Assert ! Empty( This.SQLStatCombo ) Message 'SQLStatCombo'
*!*				With This
*!*					If Empty ( .SQLStatCombo ) Or Vartype ( .SQLStatSelector ) # 'C'
*!*						.SQLStatCombo = .oParent.GetSelectSQL ( This, 'nComboOrder # 0' )

*!*					Endif && Empty( This.SQLStatCombo )
*!*				Endwith
*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return This.SQLStatCombo

*!*		Endproc && SQLStatCombo_Access

*!*		*
*!*		* SQLStatKeyFinder_Access
*!*		Protected Procedure SQLStatKeyFinder_Access() As String
*!*			Local loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			Try
*!*				* Assert ! Empty( This.SQLStatKeyFinder ) Message 'SQLStatKeyFinder'
*!*				With This
*!*					If Empty ( .SQLStatKeyFinder ) Or Vartype ( .SQLStatSelector ) # 'C'
*!*						.SQLStatKeyFinder = .oParent.GetSelectSQL ( This, 'nShowInKeyFinder # 0', .T. )

*!*					Endif && Empty( This.SQLStatKeyFinder )

*!*				Endwith

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return This.SQLStatKeyFinder

*!*		Endproc && SQLStatKeyFinder_Access

*!*		*
*!*		* SQLStatSelector_Access
*!*		Protected Procedure SQLStatSelector_Access() As String
*!*			Local loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			Try
*!*				* Assert ! Empty( This.SQLStatSelector ) Message 'SQLStatSelector'
*!*				With This
*!*					If Empty ( .SQLStatSelector ) Or Vartype ( .SQLStatSelector ) # 'C'
*!*						.SQLStatSelector = .oParent.GetSelectSQL ( This, 'nSelectorOrder # 0', .T. )

*!*					Endif && Empty( .SQLStatSelector ) Or Vartype( .SQLStatSelector ) # 'C'
*!*				Endwith
*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return This.SQLStatSelector

*!*		Endproc && SQLStatSelector_Access

*!*	Enddefine && oTable

*!*	* ColFields
*!*	* Colección de Bases de Datos
*!*	Define Class ColFields As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColFields Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Colección de Bases de Datos
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="addfield" type="event" display="AddField" />] + ;
*!*			[<memberdata name="new" type="method" display="New" />] + ;
*!*			[<memberdata name="newpk" type="method" display="NewPK" />] + ;
*!*			[<memberdata name="newfk" type="method" display="NewFK" />] + ;
*!*			[<memberdata name="newcandidate" type="method" display="NewCandidate" />] + ;
*!*			[<memberdata name="newregular" type="method" display="NewRegular" />] + ;
*!*			[</VFPData>]

*!*		Procedure AddField ( toField As oField Of 'DataDictionary\prg\DataDictionary.prg' ) As Boolean  HelpString 'Agrega un Campo a la colección ColFields'

*!*			Local lcKey As String, ;
*!*				liIdx As Integer, ;
*!*				llRet As Boolean, ;
*!*				loErr As Object
*!*			*:Global i as Integer

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					 Agrega un Campo a la colección ColFields
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Martes 29 de Mayo de 2007 (11:13:53)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					toField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*					*:Remarks:
*!*					*:Returns:
*!*					 Boolean
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				With This
*!*					lcKey = Lower ( m.toField.Name )
*!*					liIdx = .GetKey ( m.lcKey )
*!*					If Empty ( m.liIdx )
*!*						toField.oParent = .oParent
*!*						.AddItem ( m.toField, m.lcKey )
*!*						llRet = .T.

*!*					Endif && Empty( m.liIdx )

*!*				Endwith

*!*			Catch To loErr
*!*				loErr.Message = m.loErr.Message + m.toField.Name
*!*				Throw m.loErr

*!*			Finally

*!*			Endtry

*!*			Return m.llRet

*!*		Endproc && AddField

*!*		Procedure Comment_Assign ( tcNewVal As String ) As String

*!*			Local lcStr As String, ;
*!*				lnLen As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'


*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Martes 29 de Mayo de 2007 (11:13:53)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					toField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*					*:Remarks:
*!*					*:Returns:
*!*					 Boolean
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				lnLen = Len ( m.tcNewVal)
*!*				If m.lnLen > 253
*!*					TEXT To m.lcStr Textmerge Noshow Pretext 15
*!*					La Propiedad <<This.Name>>.Comment es demasiado largo(<<m.lnLen>>)
*!*					m.tcNewVal
*!*					ENDTEXT
*!*					lcStr = m.lcStr + CR + CR + m.tcNewVal
*!*					*!*	lcStr = "La Propiedad " + This.Name + ".Comment es demasiado largo(" + m.String.Any2Char(Len( cNewVal )) + ")"+ CR + CR
*!*					*!*	lcStr = lcStr + cNewVal
*!*					Error m.lcStr

*!*				Else
*!*					This.Comment = m.tcNewVal

*!*				Endif && Len( tcNewVal) > 253

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return This.Comment

*!*		Endproc && Comment_Assign

*!*		Procedure New ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Obtiene un elemento oField vacío'

*!*			Local loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loField As oField Of 'DataDictionary\prg\DataDictionary.prg'


*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Obtiene un elemento oField vacío
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Martes 29 de Mayo de 2007 (11:13:53)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					toField As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*					*:Remarks:
*!*					*:Returns:
*!*					 Boolean
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try

*!*				With This
*!*					loField = Newobject ( 'oField', 'DataDictionary\prg\DataDictionary.prg' )

*!*					If Vartype ( m.tcName ) == 'C'
*!*						loField.Name = m.tcName

*!*					Endif && Vartype( m.tcName ) == "C"

*!*					If .AddField ( m.loField )

*!*						If Vartype ( tm.nFieldWidth ) == 'N'
*!*							loField.FieldWidth = m.tnFieldWidth

*!*						Endif && Vartype( tm.nFieldWidth ) == "N"

*!*						If Vartype ( m.tnFieldPrecision ) == 'N'
*!*							loField.FieldPrecision = m.tnFieldPrecision

*!*						Endif && Vartype( m.tnFieldPrecision ) == "N"

*!*						loField.DisplayClassLibrary = IB_DISPLAYCLASSLIBRARY

*!*						If Vartype ( m.tcFieldType ) == 'C'
*!*							tcFieldType = Lower ( m.tcFieldType )
*!*							Do Case
*!*								Case Inlist ( m.tcFieldType, 'w', 'blob' )
*!*									loField.FieldType           = 'Blob'
*!*									loField.DisplayClass        = ''
*!*									loField.DisplayClassLibrary = ''
*!*									loField.nLength             = 50

*!*								Case Inlist ( m.tcFieldType, 'c', 'char', 'character' )
*!*									loField.FieldType    = 'Character'
*!*									loField.DisplayClass = IB_STRING
*!*									loField.InputMask    = Replicate ('X', loField.FieldWidth )
*!*									loField.Format       = 'RK'

*!*								Case Inlist ( m.tcFieldType, 'y', 'currency', 'money' )
*!*									loField.FieldType    = 'Currency'
*!*									loField.DisplayClass = IB_NUMERIC
*!*									loField.Format       = '$Z'
*!*									loField.InputMask    = m.Control.ConvertInputMask ( m.loField.FieldWidth, m.loField.FieldPrecision, '#', .T. )
*!*									loField.Format       = 'RK'

*!*								Case Inlist ( m.tcFieldType, 't', 'datetime' )
*!*									loField.FieldType    = 'DateTime'
*!*									loField.DisplayClass = IB_DATE

*!*								Case Inlist ( m.tcFieldType, 'd', 'date' )
*!*									loField.FieldType    = 'Date'
*!*									loField.DisplayClass = IB_DATE
*!*									loField.nLength      = 10

*!*								Case Inlist ( m.tcFieldType, 'g', 'general' )
*!*									loField.FieldType           = 'General'
*!*									loField.DisplayClass        = ''
*!*									loField.DisplayClassLibrary = ''

*!*								Case Inlist ( m.tcFieldType, 'i', 'int', 'integer', 'long' )
*!*									loField.FieldType    = 'Integer'
*!*									loField.DisplayClass = IB_NUMERIC
*!*									loField.nLength      = 6
*!*									loField.InputMask    = m.Control.ConvertInputMask ( m.loField.nLength, 0, '#', .F. )
*!*									loField.Format       = 'K'

*!*								Case Inlist ( m.tcFieldType, 'l', 'logical', 'boolean', 'bit' )
*!*									* Para futura escalabilidad a SQL Server, no se utilizan campos booleanos.
*!*									loField.lIsLogical   = .T.
*!*									loField.FieldType    = 'Integer'
*!*									loField.Default      = FALSE
*!*									loField.DisplayClass = IB_CHECKBOX
*!*									loField.nLength      = 1
*!*									loField.InputMask    = m.Control.ConvertInputMask ( m.loField.nLength, 0, '9', .F. )

*!*								Case Inlist ( m.tcFieldType, 'm', 'memo' )
*!*									loField.FieldType    = 'Memo'
*!*									loField.DisplayClass = IB_EDITBOX
*!*									loField.nLength      = 50

*!*								Case Inlist ( m.tcFieldType, 'n', 'num', 'numeric' )
*!*									loField.FieldType    = 'Numeric'
*!*									loField.DisplayClass = IB_NUMERIC
*!*									loField.InputMask    = m.Control.ConvertInputMask ( loField.FieldWidth, loField.FieldPrecision, '#', .T. )
*!*									loField.Format       = 'RK'

*!*								Case Inlist ( m.tcFieldType, 'f', 'float' )
*!*									* Included for compatibility, the Float data type is functionally equivalent to Numeric.
*!*									* Same as Numeric
*!*									loField.FieldType    = 'Float'
*!*									loField.DisplayClass = IB_NUMERIC
*!*									loField.InputMask    = m.Control.ConvertInputMask ( m.loField.FieldWidth, loField.FieldPrecision, '#', .T. )
*!*									loField.Format       = 'RK'

*!*								Case Inlist ( m.tcFieldType, 'q', 'varbinary' )
*!*									loField.FieldType           = 'VarBinary'
*!*									loField.DisplayClass        = ''
*!*									loField.DisplayClassLibrary = ''

*!*								Case Inlist ( m.tcFieldType, 'v', 'varchar' )
*!*									loField.FieldType    = 'VarChar'
*!*									loField.DisplayClass = IB_STRING

*!*								Case Inlist ( m.tcFieldType, 'b', 'double' )
*!*									loField.FieldType    = 'Double'
*!*									loField.DisplayClass = IB_NUMERIC
*!*									loField.InputMask    = m.Control.ConvertInputMask ( m.loField.FieldWidth, m.loField.FieldPrecision, '#', .T. )
*!*									loField.Format       = 'RK'

*!*								Otherwise

*!*							Endcase

*!*						Endif && Vartype( m.tcFieldType ) == "C"

*!*					Endif && This.AddField( m.loField )

*!*				Endwith

*!*			Catch To loErr
*!*				loField = Null
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.loField

*!*		Endproc && New

*!*		* NewPK
*!*		* Devuelve un campo integer autoinc 
*!*		Procedure NewPK ( tcName As String ) As oField Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Devuelve un campo integer autoinc'

*!*			Local loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loField As oField Of 'DataDictionary\prg\DataDictionary.prg'

*!*			#If .F.
*!*				TEXT
*!*					 *:Help Documentation
*!*					 *:Description:
*!*					 Devuelve un campo integer autoinc
*!*					 *:Project:
*!*					 Sistemas Praxis

*!*					 *:Autor:
*!*					 Damián Eiff

*!*					 *:Date:
*!*					 Viernes 1 de Junio de 2007 (09:46:10)

*!*					 *:Parameters:
*!*					 *:Remarks:
*!*					 *:Returns:
*!*					 *:Example:
*!*					 *:SeeAlso:
*!*					 *:Events:
*!*					 *:KeyWords:
*!*					 *:Inherits:
*!*					 *:Exceptions:
*!*					 *:NameSpace:
*!*					 digitalizarte.com
*!*					 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				If ! Empty ( m.tcName )
*!*					loField               = This.New ( m.tcName, 'I' )
*!*					loField.Autoinc       = .T.
*!*					loField.IndexKey      = IK_PRIMARY_KEY
*!*					loField.lIsSystem     = .T.
*!*					loField.lIsPrimaryKey = .T.
*!*					loField.Check         = ' ! Empty( ' + m.tcName + ' )'
*!*					loField.ErrorMessage  = 'El Campo ' + m.tcName + ' Es Obligatorio'
*!*					loField.TagName       = Substr ( 'PK' + m.loField.Name, 1, 10 )

*!*					If Lower ( Right ( m.tcName, 2 )) = 'id'
*!*						loField.Caption = Substr ( m.tcName, 1, Len ( m.tcName ) - 2 )

*!*					Endif &&  Lower( Right( m.tcName, 2 )) = "id"
*!*				Else
*!*					loField = Null

*!*				Endif && ! Empty( m.tcName )

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.loField

*!*		Endproc && NewPK

*!*		* NewFK
*!*		* Obtiene un elemento oField configurado como ForeignKey
*!*		Procedure NewFK ( tcName As String, ;
*!*				tcFieldType As String, ;
*!*				tnFieldWidth As Integer, ;
*!*				tnFieldPrecision As Integer ) As oField Of 'DataDictionary\prg\DataDictionary.prg' ;
*!*				HelpString 'Obtiene un elemento oField vacío'

*!*			Local loField As oField Of 'DataDictionary\prg\DataDictionary.prg'

*!*			#If .F.
*!*				TEXT
*!*					 *:Help Documentation
*!*					 *:Description:
*!*					 Obtiene un elemento oField configurado como ForeignKey
*!*					 *:Project:
*!*					 Sistemas Praxis

*!*					 *:Autor:
*!*					 Damián Eiff

*!*					 *:Date:
*!*					 Martes 29 de Mayo de 2007 (11:13:53)

*!*					 *:Parameters:
*!*					 *:Remarks:
*!*					 *:Returns:
*!*					 *:Example:
*!*					 *:SeeAlso:
*!*					 *:Events:
*!*					 *:KeyWords:
*!*					 *:Inherits:
*!*					 *:Exceptions:
*!*					 *:NameSpace:
*!*					 digitalizarte.com
*!*					 *:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			If Vartype ( tcFieldType ) # 'C'
*!*				tcFieldType = 'Integer'

*!*			Endif

*!*			loField = This.New ( tcName, ;
*!*				tcFieldType, ;
*!*				tnFieldWidth, ;
*!*				tnFieldPrecision )

*!*			loField.IndexKey = IK_FOREIGN_KEY
*!*			* loField.DisplayClassLibrary = Addbs( FL_LIBS ) + FK_CLASS_LIBRARY
*!*			loField.DisplayClass = IB_COMBO

*!*			If ! Empty ( tcName )
*!*				loField.Check        = '! Empty( ' + tcName + ' )'
*!*				loField.ErrorMessage = 'El Campo ' + tcName + ' Es Obligatorio'

*!*			Endif

*!*			loField.nLength = 25

*!*			Return loField

*!*		Endproc && NewFK

*!*		Procedure NewCandidate ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Obtiene un elemento oField vacío configurado como Candidate'

*!*			Local loField As oField Of 'DataDictionary\prg\DataDictionary.prg'

*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Obtiene un elemento oField configurado como Candidate
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Martes 29 de Mayo de 2007 (11:13:53)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					tcName As String
*!*					tcFieldType As String
*!*					tnFieldWidth As Integer
*!*					tnFieldPrecision As Integer
*!*					*:Remarks:
*!*					*:Returns:
*!*					 Boolean
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			With This
*!*				If ! Empty ( m.tcName )
*!*					loField              = This.New ( m.tcName, m.tcFieldType, m.tnFieldWidth, m.tnFieldPrecision )
*!*					loField.IndexKey     = IK_CANDIDATE_KEY
*!*					loField.Check        = ' ! Empty( ' + m.tcName + ' )'
*!*					loField.ErrorMessage = 'El Campo ' + m.tcName + ' Es Obligatorio'

*!*					If Inlist ( Lower ( m.tcFieldType ), 'c', 'char', 'character', 'v', 'varchar' )
*!*						loField.CaseSensitive = .F.

*!*					Endif && Inlist( Lower( m.tcFieldType ), "c", "char", "character", "v", "varchar" )

*!*				Else
*!*					loField = Null

*!*				Endif && ! Empty( m.tcName )

*!*			Endwith

*!*			Return m.loField

*!*		Endproc && NewCandidate

*!*		* NewRegular
*!*		* Obtiene un elemento oField configurado como Regular
*!*		Procedure NewRegular ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Obtiene un elemento oField vacío configurado como Regular'

*!*			Local loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loField As oField Of 'DataDictionary\prg\DataDictionary.prg'


*!*			#If .F.
*!*				TEXT
*!*					*:Help Documentation
*!*					*:Topic:
*!*					*:Description:
*!*					Obtiene un elemento oField configurado como Candidate
*!*					*:Project:
*!*					Sistemas Praxis
*!*					*:Autor:
*!*					Damián Eiff
*!*					*:Date:
*!*					Martes 29 de Mayo de 2007 (11:13:53)
*!*					*:ModiSummary:
*!*					*:Syntax:
*!*					*:Example:
*!*					*:Events:
*!*					*:NameSpace:
*!*					praxis.com
*!*					*:Keywords:
*!*					*:Implements:
*!*					*:Inherits:
*!*					*:Parameters:
*!*					tcName As String
*!*					tcFieldType As String
*!*					tnFieldWidth As Integer
*!*					tnFieldPrecision As Integer
*!*					*:Remarks:
*!*					*:Returns:
*!*					 Boolean
*!*					*:Exceptions:
*!*					*:SeeAlso:
*!*					*:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				loField          = This.New ( m.tcName, m.tcFieldType, m.tnFieldWidth, m.tnFieldPrecision )
*!*				loField.IndexKey = IK_REGULAR

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.loField

*!*		Endproc && NewRegular

*!*		* NewVirtual
*!*		* Obtiene un elemento oField vacío
*!*		Procedure NewVirtual ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Obtiene un elemento oField vacío'

*!*			Local loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loField As oField Of 'DataDictionary\prg\DataDictionary.prg'


*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Obtiene un elemento oField vacío
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damian Eiff

*!*				 *:Date:
*!*				 Lunes 17 de Agosto de 2009

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try
*!*				loField                 = This.New ( m.tcName, m.tcFieldType, m.tnFieldWidth, m.tnFieldPrecision )
*!*				loField.lIsVirtual      = .T.
*!*				loField.lSaveInDataBase = .F.

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.loField

*!*		Endproc && NewVirtual

*!*	Enddefine && ColFields

*!*	* oField
*!*	* Clase Base de Datos 
*!*	Define Class oField As oBase Of  'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oField Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Clase Base de Datos
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif


*!*		* Tipo de Dato
*!*		FieldType = ''
*!*		* Ancho del Campo
*!*		FieldWidth = 0
*!*		* Presición del Campo
*!*		FieldPrecision = 0
*!*		* Indica si permite valores nulos
*!*		Null = .F.
*!*		* Specifies the table validation rule for the field.
*!*		* Must evaluate to a logical expression and can be a user-defined function
*!*		* or a stored procedure.
*!*		Check = ''

*!*		* Mensaje de error que se muestra si Check evalua a .F.
*!*		ErrorMessage = ''
*!*		* Indica si el campo es autoincremental
*!*		Autoinc = .F.
*!*		* Si es mayor que 0, indica el siguiente número automático
*!*		Nextvalue = 0
*!*		*!*
*!*		StepValue = 1
*!*		* Valor por defecto
*!*		Default = Null
*!*		* Indica si incluye la clausula NOCPTRANS
*!*		NoCPTrans = .F.
*!*		* Indica si incluye la cláusula NOVALIDATE
*!*		Novalidate = .F.

*!*		DataSession = SET_DEFAULT

*!*		* Tipo de indice generado para este campo. (Constantes definidas en ta.h)
*!*		IndexKey = IK_NOKEY

*!*		*!*
*!*		Collate = 'SPANISH'

*!*		* Specifies the parent table to which a persistent relationship is established
*!*		References = ''

*!*		* Indica si la expresión de indice diferencia mayusculas de minusculas
*!*		CaseSensitive = .T.

*!*		* Specifies an index tag name for the parent table.
*!*		*!*	Index tag names can contain up to 10 characters.
*!*		*!*	If you omit the TAG clause, the relationship is established using the
*!*		*!*	primary index key of the parent table
*!*		TagName = ''

*!*		* Etiqueta de indices correspondiente a la tabla padre
*!*		ParentTagName = ''

*!*		* Contiene el valor de la propiedad Caption del control Label que mostrará el campo
*!*		Caption = ''

*!*		* Comentario que documenta el objeto
*!*		Comment = ''

*!*		* Name of the class used for field mapping.
*!*		DisplayClass = ''

*!*		* Path to the class library specified with the DisplayClass property
*!*		DisplayClassLibrary = ''

*!*		* The field display format
*!*		Formatmatmatmatmatmatmatmatmatmatmatmatmatmatmatmat = ''

*!*		* The field input format
*!*		InputMask = ''

*!*		* Condición a cumplir para que se dispare el trigger
*!*		TriggerConditionForInsert = '.T.'
*!*		* Condición a cumplir para que se dispare el trigger
*!*		TriggerConditionForUpdate = '.T.'
*!*		* Condición a cumplir para que se dispare el trigger
*!*		TriggerConditionForDelete = '.T.'

*!*		* Nombre de la clave de la tabla padre
*!*		ParentPk = ''

*!*		* Indica si el campo se muestra en la Grilla
*!*		lShowInGrid = .F.

*!*		* Posición dentro de la grilla
*!*		* nGridOrder = 0 Indica que no se utiliza el campo
*!*		* nGridOrder > 0 Posicion que ocupa en la grilla
*!*		* nGridOrder < 0 Es una columna que no se muestra
*!*		nGridOrder = 0

*!*		* Posición dentro de la grilla del Selector
*!*		* nSelectorOrder = 0 Indica que no se utiliza el campo
*!*		* nSelectorOrder > 0 Posicion que ocupa en la grilla
*!*		* nSelectorOrder < 0 Es una columna que no se muestra
*!*		nSelectorOrder = 0

*!*		* Indica si el campo se muestra en el navegador
*!*		lShowInNavigator = .F.

*!*		* Posición dentro del KeyFinder
*!*		* nShowInKeyFinder = 0 Indica que no se utiliza el campo en el KeyFinder
*!*		* nShowInKeyFinder > 0 Posicion que ocupa en el KeyFinder
*!*		* nShowInKeyFinder < 0 Es una columna que no se muestra en el KeyFinder pero se utiliza para las busquedas
*!*		nShowInKeyFinder = 0

*!*		* Posición dentro del Combo
*!*		* nComboOrder = 0 Indica que no se utiliza el campo en el Combo
*!*		* nComboOrder > 0 Posicion que ocupa en el Combo
*!*		* nComboOrder < 0 Es una columna que no se muestra en el Combo
*!*		nComboOrder = 0

*!*		* Indica si el campo está incluido en la búsqueda rápida del KeyFinder
*!*		lFastSearch = .F.

*!*		* Condición de Búsqueda
*!*		cSearchCondition = '!#'

*!*		* Indica si el campo es requerido
*!*		lRequired = .F.

*!*		* Nombre de fantasía por el que se accede a la coleccion oDataDictionary
*!*		cKeyName = ''

*!*		* Mensaje a mostrar cuando se pase el cursor sobre el control
*!*		cToolTipText = ''

*!*		* Mensaje a mostrar en la barra de estado
*!*		cStatusBarText = ''

*!*		* Longitud del control que muestra el campo. Prevalece sobre FieldWidth. (para los combos de las FK)

*!*		nLength = 0

*!*		lFitColumn   = .F.
*!*		lOrderByThis = .F.

*!*		* Indica si el campo es logico
*!*		lIsLogical = .F.

*!*		* Indica si el control asociado al campo es el que toma el foco
*!*		lGetFirstFocus = .F.

*!*		* Expresión que se ejecuta para asignarle un valor al campo
*!*		cDefaultValueExpression = ''

*!*		* Clave de acceso a la tabla externa de una FK
*!*		cParentKeyName = ''

*!*		* Indica si el campo es de sistema
*!*		lIsSystem = .F.

*!*		* Indica si es clave primaria
*!*		lIsPrimaryKey = .F.

*!*		* Condicion de búsqueda predeterminada
*!*		* Valores posibles:
*!*		* 					"E" 	->	Entre
*!*		* 					"like" 	->	Comienza con
*!*		* 					"%" 	->	Contiene
*!*		* 					"!#" 	->	Igual
*!*		* 					"#" 	->	Distinto
*!*		cDefaultCondition = '%'

*!*		* Indica si el campo es virtual
*!*		lIsVirtual = .F.

*!*		* Indica que el campo se graba en la base de datos
*!*		lSaveInDataBase = .T.

*!*		* Indica que la columna se indexa en el cliente
*!*		lIndexOnClient = .F.

*!*		* Nombre del Tag actual para el campo
*!*		CurrentTagName = ''

*!*		* Expresion para utilizar de forma predeterminada en las consultas SQL
*!*		cDefaultSqlExp = ''

*!*		* Indica que el campo se muestra como parte de otra tabla caundo existe un FK a la tabla
*!*		nDefaultReference = 0

*!*		* Caption de la columna que hace referencia a la FK
*!*		cReferenceCaption = ''

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="creferencecaption" type="property" display="cReferenceCaption" />] + ;
*!*			[<memberdata name="ndefaultreference" type="property" display="nDefaultReference" />] + ;
*!*			[<memberdata name="nselectororder" type="property" display="nSelectorOrder" />] + ;
*!*			[<memberdata name="ncomboorder" type="property" display="nComboOrder" />] + ;
*!*			[<memberdata name="cdefaultsqlexp" type="property" display="cDefaultSqlExp" />] + ;
*!*			[<memberdata name="currenttagname" type="property" display="CurrentTagName" />] + ;
*!*			[<memberdata name="currenttagname_access" type="method" display="CurrentTagName_Access" />] + ;
*!*			[<memberdata name="lindexonclient" type="property" display="lIndexOnClient" />] + ;
*!*			[<memberdata name="lsaveindatabase" type="property" display="lSaveInDataBase" />] + ;
*!*			[<memberdata name="lisvirtual" type="property" display="lIsVirtual" />] + ;
*!*			[<memberdata name="cdefaultcondition" type="property" display="cDefaultCondition" />] + ;
*!*			[<memberdata name="nshowinkeyfinder" type="property" display="nShowInKeyFinder" />] + ;
*!*			[<memberdata name="lfastsearch" type="property" display="lFastSearch" />] + ;
*!*			[<memberdata name="lisprimarykey" type="property" display="lIsPrimaryKey" />] + ;
*!*			[<memberdata name="cparentkeyname" type="property" display="cParentKeyName" />] + ;
*!*			[<memberdata name="cdefaultvalueexpression" type="property" display="cDefaultValueExpression" />] + ;
*!*			[<memberdata name="lgetfirstfocus" type="property" display="lGetFirstFocus" />] + ;
*!*			[<memberdata name="nlength" type="property" display="nLength" />] + ;
*!*			[<memberdata name="cstatusbartext" type="property" display="cStatusBarText" />] + ;
*!*			[<memberdata name="cstatusbartext_access" type="method" display="cStatusBarText_Access" />] + ;
*!*			[<memberdata name="ctooltiptext" type="property" display="cToolTipText" />] + ;
*!*			[<memberdata name="parenttagname" type="property" display="ParentTagName" />] + ;
*!*			[<memberdata name="casesensitive" type="property" display="CaseSensitive" />] + ;
*!*			[<memberdata name="indexkey" type="property" display="IndexKey" />] + ;
*!*			[<memberdata name="tagname" type="property" display="TagName" />] + ;
*!*			[<memberdata name="references" type="property" display="References" />] + ;
*!*			[<memberdata name="collate" type="property" display="Collate" />] + ;
*!*			[<memberdata name="novalidate" type="property" display="Novalidate" />] + ;
*!*			[<memberdata name="nocptrans" type="property" display="Nocptrans" />] + ;
*!*			[<memberdata name="default" type="property" display="Default" />] + ;
*!*			[<memberdata name="stepvalue" type="property" display="StepValue" />] + ;
*!*			[<memberdata name="nextvalue" type="property" display="NextValue " />] + ;
*!*			[<memberdata name="autoinc" type="property" display="Autoinc" />] + ;
*!*			[<memberdata name="errormessage" type="property" display="ErrorMessage" />] + ;
*!*			[<memberdata name="check" type="property" display="Check" />] + ;
*!*			[<memberdata name="null" type="property" display="Null" />] + ;
*!*			[<memberdata name="fieldprecision" type="property" display="FieldPrecision" />] + ;
*!*			[<memberdata name="fieldwidth" type="property" display="FieldWidth" />] + ;
*!*			[<memberdata name="fieldtype" type="property" display="FieldType" />] + ;
*!*			[<memberdata name="ruleexpression" type="property" display="RuleExpression" />] + ;
*!*			[<memberdata name="inputmask" type="property" display="InputMask" />] + ;
*!*			[<memberdata name="format" type="property" display="Format" />] + ;
*!*			[<memberdata name="displayclasslibrary" type="property" display="DisplayClassLibrary" />] + ;
*!*			[<memberdata name="displayclass" type="property" display="DisplayClass" />] + ;
*!*			[<memberdata name="comment" type="property" display="Comment" />] + ;
*!*			[<memberdata name="caption" type="property" display="Caption" />] + ;
*!*			[<memberdata name="triggerconditionforinsert" type="property" display="TriggerConditionForInsert" />] + ;
*!*			[<memberdata name="triggerconditionforupdate" type="property" display="TriggerConditionForUpdate" />] + ;
*!*			[<memberdata name="triggerconditionfordelete" type="property" display="TriggerConditionForDelete" />] + ;
*!*			[<memberdata name="print" type="method" display="Print" />] + ;
*!*			[<memberdata name="displayclasslibrary_assign" type="method" display="DisplayClassLibrary_Assign" />] + ;
*!*			[<memberdata name="parentpk" type="property" display="ParentPk" />] + ;
*!*			[<memberdata name="lshowingrid" type="property" display="lShowInGrid" />] + ;
*!*			[<memberdata name="lrequired" type="property" display="lRequired" />] + ;
*!*			[<memberdata name="ckeyname" type="property" display="cKeyName" />] + ;
*!*			[<memberdata name="ckeyname_access" type="method" display="cKeyName_Access" />] + ;
*!*			[<memberdata name="ngridorder" type="property" display="nGridOrder" />] + ;
*!*			[<memberdata name="lfitcolumn" type="property" display="lFitColumn" />] + ;
*!*			[<memberdata name="lorderbythis" type="property" display="lOrderByThis" />] + ;
*!*			[<memberdata name="lislogical" type="property" display="lIsLogical" />] + ;
*!*			[<memberdata name="lissystem" type="property" display="lIsSystem" />] + ;
*!*			[<memberdata name="lshowinnavigator" type="property" display="lShowInNavigator" />] + ;
*!*			[</VFPData>]

*!*		* CurrentTagName_Access
*!*		Protected Procedure CurrentTagName_Access()
*!*			With This
*!*				If Empty ( .CurrentTagName )
*!*					.CurrentTagName = Sys ( 2015 )

*!*				Endif && Empty( This.CurrentTagName )

*!*			Endwith

*!*			Return This.CurrentTagName

*!*		Endproc && CurrentTagName_Access

*!*		*
*!*		* cStatusBarText_Access
*!*		Protected Procedure cStatusBarText_Access()
*!*			With This
*!*				If Empty ( .cStatusBarText )
*!*					.cStatusBarText = .cToolTipText

*!*				Endif && .cStatusBarText

*!*			Endwith
*!*			Return This.cStatusBarText

*!*		Endproc && cStatusBarText_Access

*!*		* DisplayClassLibrary_Assign
*!*		Procedure DisplayClassLibrary_Assign ( tcNewValue As String )

*!*			#If .F.
*!*				TEXT
*!*			 *:Help Documentation
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Sábado 19 de Julio de 2008 (11:48:25)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			If m.Logical.IsRunTime()
*!*				tcNewValue = ''

*!*			Else
*!*				If ! Empty ( m.tcNewValue  )
*!*					If Upper ( Justext ( m.tcNewValue  ) ) # 'VCX'
*!*						tcNewValue = m.tcNewValue + '.vcx'

*!*					Endif && Upper( Justext( m.tcNewValue  ) ) # "VCX"

*!*				Endif && ! Empty( m.tcNewValue  )

*!*			Endif &&  IsRuntime()

*!*			This.DisplayClassLibrary = m.tcNewValue

*!*		Endproc && DisplayClassLibrary_Assign

*!*		*
*!*		* cKeyName_Access
*!*		Protected Procedure cKeyName_Access()

*!*			If Empty ( This.cKeyName )
*!*				This.cKeyName = This.Caption
*!*			Endif

*!*			Return This.cKeyName

*!*		Endproc && cKeyName_Access


*!*		*
*!*		* Caption_Access
*!*		Protected Procedure Caption_Access()

*!*			If Empty ( This.Caption )
*!*				This.Caption = This.Name
*!*			Endif

*!*			Return This.Caption

*!*		Endproc && Caption_Access

*!*		*
*!*		* cReferenceCaption_Access
*!*		Protected Procedure cReferenceCaption_Access()

*!*			If Empty ( This.cReferenceCaption )
*!*				This.cReferenceCaption = This.Caption
*!*			Endif

*!*			Return This.cReferenceCaption

*!*		Endproc && cReferenceCaption_Access

*!*		* Imprime la definición del campo 
*!*		Procedure Print ( cFileName As String ) As Void ;
*!*				HelpString 'Imprime la definición del campo'

*!*			Local llTag As Boolean, ;
*!*				loErr As Object, ;
*!*				loField As Object, ;
*!*				loTable As Object

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Imprime la definición del campo
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Viernes 11 de Abril de 2008 (14:15:13)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try

*!*				llTag = .F.

*!*				Strtofile ( CR + Padr ( This.Name, 40, ' '), cFileName, 1 )

*!*				Strtofile ( Tab + This.FieldType, cFileName, 1 )

*!*				If !Empty ( This.FieldWidth )
*!*					Strtofile ( ' (' + m.String.Any2Char ( This.FieldWidth ), cFileName, 1 )

*!*					If !Empty ( This.FieldPrecision )
*!*						Strtofile ( ', ' + m.String.Any2Char ( This.FieldPrecision ) + ')', cFileName, 1 )

*!*					Else
*!*						Strtofile ( ')', cFileName, 1 )

*!*					Endif

*!*				Endif

*!*				If Lower ( This.Caption ) # Lower ( This.Name )
*!*					Strtofile ( Tab + '[' + This.Caption + ']', cFileName, 1 )
*!*				Endif

*!*				If This.Autoinc
*!*					Strtofile ( Tab + 'Autoinc', cFileName, 1 )
*!*				Endif

*!*				If !Empty ( This.Check )
*!*					Strtofile ( CR + Tab + 'Check: ' + This.Check, cFileName, 1 )
*!*					llTag = .T.
*!*				Endif


*!*				If !Empty ( This.Format ) Or !Empty ( This.InputMask )
*!*					Strtofile ( CR + Tab, cFileName, 1 )
*!*					If !Empty ( This.Format )
*!*						Strtofile ( 'Format: ' + This.Format + ' ', cFileName, 1 )
*!*					Endif

*!*					If !Empty ( This.InputMask )
*!*						Strtofile ( 'InputMask: ' + This.InputMask, cFileName, 1 )
*!*					Endif

*!*					llTag = .T.
*!*				Endif

*!*				If ! Empty ( This.References )
*!*					Strtofile ( CR + Tab + 'References: ' + This.References, cFileName, 1 )
*!*					llTag = .T.

*!*				Endif && ! Empty( This.References )

*!*				If This.TriggerConditionForDelete # '.T.'
*!*					Strtofile ( CR + Tab + "Trigger Condition For Delete: '" + This.TriggerConditionForDelete + "'", cFileName, 1 )
*!*					llTag = .T.

*!*				Endif && This.TriggerConditionForDelete # ".T."

*!*				If This.TriggerConditionForInsert # '.T.'
*!*					Strtofile ( CR + Tab + "Trigger Condition For Insert: '" + This.TriggerConditionForInsert + "'", cFileName, 1 )
*!*					llTag = .T.

*!*				Endif && This.TriggerConditionForInsert # ".T."

*!*				If This.TriggerConditionForUpdate # '.T.'
*!*					Strtofile ( CR + Tab + "Trigger Condition For Update: '" + This.TriggerConditionForUpdate + "'", cFileName, 1 )
*!*					llTag = .T.

*!*				Endif && This.TriggerConditionForUpdate # ".T."

*!*				If ! Empty ( This.Comment )
*!*					Strtofile ( CR + Tab + 'Comment: ' + This.Comment, cFileName, 1 )
*!*					llTag = .T.

*!*				Endif && ! Empty( This.Comment )

*!*				Strtofile ( CR, cFileName, 1 )

*!*			Catch To loErr
*!*				Throw loErr

*!*			Finally
*!*				loTable = Null
*!*				loField = Null

*!*			Endtry

*!*		Endproc && Print

*!*		*
*!*		* References_Access
*!*		Protected Procedure References_Access()
*!*			Local loTable As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*			If Empty ( This.References )
*!*				If !Empty ( This.cParentKeyName )

*!*					loTable         = This.oParent.oParent.oColTables.GetItem ( This.cParentKeyName )
*!*					This.References = loTable.Name

*!*				Endif
*!*			Endif

*!*			Return This.References

*!*		Endproc && cParentKeyName_Access


*!*		*
*!*		* GetWhereStatement
*!*		* Devuelve la condición de búsqueda asociada al controls
*!*		Procedure GetWhereStatement ( tcValue As String )

*!*			Local lcFieldName As String, ;
*!*				lcTableName As String, ;
*!*				lcWhere As String, ;
*!*				llOk As Boolean, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			Try

*!*				llOk    = .T.
*!*				lcWhere = ''

*!*				If llOk
*!*					If ! Inlist ( This.FieldType, 'Character', 'Integer', 'Memo', 'Numeric', 'Float', 'VarChar', 'Double' )
*!*						Assert .F. Message 'No se reconoce el tipo ' + This.FieldType + ' para la búsqueda rápida'
*!*						llOk = .F.

*!*					Endif &&  ! Inlist( This.FieldType, "Character", "Integer", "Memo", "Numeric", "Float", "VarChar", "Double" )

*!*					If ! Inlist ( This.cSearchCondition, 'like', '%', '!#' )
*!*						Assert .F. Message 'No se reconoce la condicion de búsqueda ' + This.cSearchCondition + ' para la búsqueda rápida'
*!*						llOk = .F.

*!*					Endif && ! Inlist( This.cSearchCondition, "like", "%", "!#" )

*!*				Endif && llOk

*!*				If llOk
*!*					tcValue = Alltrim ( tcValue )
*!*					If Isalpha ( tcValue ) And  Inlist ( This.FieldType, 'Integer', 'Numeric', 'Float', 'Double' )
*!*						lcWhere = ' Or 1 = 0 '

*!*					Else
*!*						lcTableName = This.oParent.Name

*!*						If Inlist ( This.FieldType, 'Character', 'Memo', 'VarChar' )
*!*							lcFieldName = ' lower(' + lcTableName + '.' + This.Name + ')'
*!*							tcValue     = ['] + Lower ( tcValue ) + [']

*!*						Else
*!*							lcFieldName = lcTableName + '.'  + This.Name

*!*						Endif && Inlist( This.FieldType, "Character", "Memo", "VarChar" )

*!*						lcWhere = ' Or (' + lcFieldName

*!*						Do Case
*!*							Case This.cSearchCondition = 'like'
*!*								lcWhere = lcWhere + " like '" + Strtran ( tcValue, "'", '' ) + "%'"

*!*							Case This.cSearchCondition = '%'
*!*								lcWhere = lcWhere + " like '%" + Strtran ( tcValue, "'", '' ) + "%'"

*!*							Case This.cSearchCondition = '!#'
*!*								lcWhere = lcWhere + ' = ' + tcValue

*!*						Endcase

*!*						lcWhere = lcWhere + ')'

*!*					Endif && Isalpha( tcValue ) And  Inlist( This.FieldType, "Integer", "Numeric", "Float", "Double" )

*!*				Endif && llOk

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return lcWhere

*!*		Endproc && GetWhereStatement

*!*	Enddefine && oField

*!*	* ColIndexes
*!*	* Colección de Indices 
*!*	Define Class ColIndexes As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColIndexes Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Colección de Indices
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif


*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="addindex" type="event" display="AddIndex" />] + ;
*!*			[<memberdata name="new" type="method" display="New" />] + ;
*!*			[</VFPData>]

*!*		* AddIndex
*!*		* Agrega un Campo a la colección ColFields
*!*		Procedure AddIndex ( toIndex As oField Of 'DataDictionary\prg\DataDictionary.prg') As Void ;
*!*				HelpString 'Agrega un Indice a la colección ColIndexes'

*!*			Local lcKey As String, ;
*!*				liIdx As Integer

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Agrega un Campo a la colección ColFields
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 29 de Mayo de 2007 (11:04:54)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			toIndex.oParent = This.oParent

*!*			lcKey = Lower ( toIndex.Name )
*!*			liIdx = This.GetKey ( lcKey )

*!*			If Empty ( liIdx )
*!*				This.AddItem ( toIndex, lcKey )

*!*			Endif


*!*		Endproc && AddIndex

*!*		* New
*!*		* Obtiene un elemento oIndex vacío
*!*		Procedure New ( cName As String ) As oIndex Of 'DataDictionary\prg\DataDictionary.prg' ;
*!*				HelpString 'Obtiene un elemento oIndex vacío'

*!*			Local loIndex As Object

*!*			#If .F.
*!*				TEXT
*!*					 *:Help Documentation
*!*					 *:Description:
*!*					 Obtiene un elemento oIndex vacío
*!*					 *:Project:
*!*					 Sistemas Praxis

*!*					 *:Autor:
*!*					 Damián Eiff

*!*					 *:Date:
*!*					 Martes 29 de Mayo de 2007 (11:13:53)

*!*					 *:Parameters:
*!*					 *:Remarks:
*!*					 *:Returns:
*!*					 *:Example:
*!*					 *:SeeAlso:
*!*					 *:Events:
*!*					 *:KeyWords:
*!*					 *:Inherits:
*!*					 *:Exceptions:
*!*					 *:NameSpace:
*!*					 digitalizarte.com
*!*					 *:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			loIndex = Createobject ('oIndex')
*!*			If !Empty ( cName )
*!*				loIndex.TagName = Alltrim ( cName )
*!*				This.AddIndex ( loIndex )
*!*			Endif

*!*			Return loIndex

*!*		Endproc && New

*!*	Enddefine && ColIndexes

*!*	* oIndex
*!*	* Clase Indice 
*!*	Define Class oIndex As oBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oIndex Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Clase Indice
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif


*!*		DataSession = SET_DEFAULT

*!*		* Indica el tipo de Indice. (Definido en ta.h)
*!*		KeyType = IK_NOKEY

*!*		* Expresion para generar el indice
*!*		KeyExpression = ''

*!*		* Condicion de filtro
*!*		ForExpression = ''

*!*		* Nombre de la etiqueta de indice
*!*		TagName = ''

*!*		*!*
*!*		Collate = 'SPANISH'

*!*		* Referencia a la tabla padre
*!*		References = ''

*!*		* Etiqueta de indices correspondiente a la tabla padre
*!*		ParentTagName = ''

*!*		* Condición a cumplir para que se dispare el trigger
*!*		TriggerConditionForInsert = '.T.'

*!*		* Condición a cumplir para que se dispare el trigger
*!*		TriggerConditionForUpdate = '.T.'

*!*		* Condición a cumplir para que se dispare el trigger
*!*		TriggerConditionForDelete = '.T.'

*!*		* Nombre de la clave de la tabla padre
*!*		ParentPk = ''

*!*		* Clave de acceso a la tabla externa de una FK
*!*		cParentKeyName = ''

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="cparentkeyname" type="property" display="cParentKeyName" />] + ;
*!*			[<memberdata name="parenttagname" type="property" display="ParentTagName" />] + ;
*!*			[<memberdata name="references" type="property" display="References" />] + ;
*!*			[<memberdata name="collate" type="property" display="Collate" />] + ;
*!*			[<memberdata name="tagname" type="property" display="TagName" />] + ;
*!*			[<memberdata name="forexpression" type="property" display="ForExpression" />] + ;
*!*			[<memberdata name="keyexpression" type="property" display="KeyExpression" />] + ;
*!*			[<memberdata name="keytype" type="property" display="KeyType" />] + ;
*!*			[<memberdata name="triggerconditionforinsert" type="property" display="TriggerConditionForInsert" />] + ;
*!*			[<memberdata name="triggerconditionforupdate" type="property" display="TriggerConditionForUpdate" />] + ;
*!*			[<memberdata name="triggerconditionfordelete" type="property" display="TriggerConditionForDelete" />] + ;
*!*			[<memberdata name="parentpk" type="property" display="ParentPk" />] + ;
*!*			[</VFPData>]

*!*		*
*!*		* ParentTagName_Access
*!*		Procedure ParentTagName_Access()

*!*			Local loData As oDataBase Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loParentTable As oTable Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loTable As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*			*!*	Local loColTables As colTables Of 'DataDictionary\prg\DataDictionary.prg'
*!*			*!*	Local loColFields As ColFields Of 'DataDictionary\prg\DataDictionary.prg'

*!*			If Empty ( This.ParentTagName )

*!*				If !Empty ( This.References )
*!*					* loColFields = This.oParent
*!*					* loColTables = loColFields.oParent.oParent
*!*					* loParentTable = loColTables.GetItem( This.References )

*!*					loTable = This.oParent
*!*					loData  = loTable.oParent
*!*					Assert Vartype ( loData ) = 'O' Message 'loData no es un objeto'

*!*					*!*					loParentTable = loData.oColTables.GetItem( This.References )
*!*					loParentTable = loData.oColTables.GetItem ( This.cParentKeyName )

*!*					This.ParentTagName = loParentTable.GetPrimaryTagName()

*!*					If Upper ( Substr ( This.ParentTagName, 1, 2 ) ) # 'PK'
*!*						This.ParentTagName = ''
*!*					Endif

*!*				Endif

*!*			Endif

*!*			Return This.ParentTagName

*!*		Endproc && ParentTagName_Access

*!*		*
*!*		* cParentKeyName_Access
*!*		Protected Procedure cParentKeyName_Access()
*!*			If Empty ( This.cParentKeyName )
*!*				This.cParentKeyName = Strtran ( Lower ( This.References ), 'sys_', '' )
*!*			Endif

*!*			Return This.cParentKeyName

*!*		Endproc && cParentKeyName_Access


*!*	Enddefine && oIndex

*!*	* ColTriggers
*!*	* Colección de Indices 
*!*	Define Class ColTriggers As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColTriggers Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Colección de Indices
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif

*!*		* Nombre de la tabla
*!*		tablename = ''

*!*		* Nombre del SP de Integridad Referencial que se creará
*!*		IRName = ''

*!*		* Tipo de Trigger
*!*		TriggerType = ''

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="triggertype" type="property" display="TriggerType" />] + ;
*!*			[<memberdata name="irname" type="property" display="IRName" />] + ;
*!*			[<memberdata name="tablename" type="property" display="TableName" />] + ;
*!*			[<memberdata name="delete" type="method" display="Delete" />] + ;
*!*			[<memberdata name="new" type="method" display="New" />] + ;
*!*			[</VFPData>]

*!*		* AddTrigger
*!*		* Agrega un Campo a la colección ColFields
*!*		Procedure AddTrigger ( toTrigger As oTrigger Of 'DataDictionary\prg\DataDictionary.prg') As Void ;
*!*				HelpString 'Agrega un Trigger a la colección ColTriggers'


*!*			Local lcKey As String, ;
*!*				liIdx As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Agrega un Campo a la colección ColFields
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 29 de Mayo de 2007 (11:04:54)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try

*!*				toTrigger.oParent = This.oParent
*!*				lcKey             = Lower ( toTrigger.Name )
*!*				liIdx             = This.GetKey ( lcKey )

*!*				If Empty ( liIdx )
*!*					This.AddItem ( toTrigger, lcKey )

*!*				Endif

*!*			Catch To loErr

*!*				loError      = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				oErr.Message = loErr.Message + Chr(13) + Lower (toTrigger.Name)
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry
*!*		Endproc && AddTrigger

*!*		* New
*!*		* Obtiene un elemento oTrigger vacío.
*!*		Procedure New () As oTrigger Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Obtiene un elemento oTrigger vacío'
*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Obtiene un elemento oTrigger vacío
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 29 de Mayo de 2007 (11:13:53)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*		Endproc && New

*!*	Enddefine  && ColTriggers


*!*	* ColUpdateTriggers
*!*	* Colección de Indices
*!*	Define Class ColUpdateTriggers As ColTriggers Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColUpdateTriggers Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Colección de Indices
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif


*!*		TriggerType = 'Update'

*!*		Procedure New ( cName As String ) As oTrigger Of 'DataDictionary\prg\DataDictionary.prg' ;
*!*				HelpString 'Obtiene un elemento oTrigger vacío'

*!*			Local loTrigger As Object

*!*			loTrigger = Createobject ('oUpdateTrigger')

*!*			If !Empty ( cName )
*!*				loTrigger.Name = Alltrim ( cName )
*!*				This.AddTrigger ( loTrigger )
*!*			Endif

*!*			Return loTrigger

*!*		Endproc

*!*	Enddefine  && ColUpdateTriggers

*!*	* ColInsertTriggers
*!*	* Colección de Indices 
*!*	Define Class ColInsertTriggers As ColTriggers Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColInsertTriggers Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Colección de Indices
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif

*!*		TriggerType = 'Insert'

*!*		Procedure New ( cName As String ) As oTrigger Of 'DataDictionary\prg\DataDictionary.prg' ;
*!*				HelpString 'Obtiene un elemento oTrigger vacío'

*!*			Local loTrigger As Object

*!*			loTrigger = Createobject ('oInsertTrigger')
*!*			If !Empty ( cName )
*!*				loTrigger.Name = Alltrim ( cName )
*!*				This.AddTrigger ( loTrigger )
*!*			Endif

*!*			Return loTrigger

*!*		Endproc

*!*	Enddefine && ColInsertTriggers

*!*	* ColDeleteTriggers
*!*	* Colección de Indices 
*!*	Define Class ColDeleteTriggers As ColTriggers Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColDeleteTriggers Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Colección de Indices
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 29 de Mayo de 2007 (11:00:34)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*			ENDTEXT
*!*		#Endif

*!*		TriggerType = 'Delete'

*!*		Procedure New ( cName As String ) As oTrigger Of 'DataDictionary\prg\DataDictionary.prg' ;
*!*				HelpString 'Obtiene un elemento oTrigger vacío'

*!*			Local loTrigger As Object

*!*			loTrigger = Createobject ('oDeleteTrigger')
*!*			If !Empty ( cName )
*!*				loTrigger.Name = Alltrim ( cName )
*!*				This.AddTrigger ( loTrigger )
*!*			Endif

*!*			Return loTrigger

*!*		Endproc

*!*	Enddefine && ColDeleteTriggers

*!*	* oTrigger
*!*	* Clase Trigger 
*!*	Define Class oTrigger As oBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oTrigger Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Clase Trigger
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif

*!*		DataSession = SET_DEFAULT

*!*		* Nombre de la Tabla Padre
*!*		ParentTable = ''

*!*		* Nombre de tabla Hija
*!*		ChildTable = ''

*!*		* Expresion a cumplir
*!*		ChildKeyExpression = ''

*!*		* Nombre de la Primary Key de la tabla hija
*!*		ChildPK = ''
*!*		* Nombre de la Primary Key de la tabla Padre
*!*		ParentPk = ''

*!*		*!*
*!*		ChildForeignKey = ''

*!*		* Nombre de la etiqueta de indices de la tabla hija
*!*		ChildTagName = ''

*!*		* Nombre de la etiqueta de indices de la tabla padre
*!*		ParentTagName = ''

*!*		* Condición a cumplir para que se dispare el trigger
*!*		TriggerConditionForInsert = '.T.'

*!*		* Condición a cumplir para que se dispare el trigger
*!*		TriggerConditionForUpdate = '.T.'

*!*		* Condición a cumplir para que se dispare el trigger
*!*		TriggerConditionForDelete = '.T.'

*!*		* Clave de acceso a la tabla externa de una FK
*!*		cParentKeyName = ''

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="cparentkeyname" type="property" display="cParentKeyName" />] + ;
*!*			[<memberdata name="parenttagname" type="property" display="ParentTagName" />] + ;
*!*			[<memberdata name="childtagname" type="property" display="ChildTagName" />] + ;
*!*			[<memberdata name="childforeignkey" type="property" display="ChildForeignKey" />] + ;
*!*			[<memberdata name="parenttable" type="property" display="ParentTable" />] + ;
*!*			[<memberdata name="childkeyexpression" type="property" display="ChildKeyExpression" />] + ;
*!*			[<memberdata name="childtable" type="property" display="ChildTable" />] + ;
*!*			[<memberdata name="parentpk" type="property" display="ParentPK" />] + ;
*!*			[<memberdata name="childpk" type="property" display="ChildPK" />] + ;
*!*			[<memberdata name="triggerconditionforinsert" type="property" display="TriggerConditionForInsert" />] + ;
*!*			[<memberdata name="triggerconditionforupdate" type="property" display="TriggerConditionForUpdate" />] + ;
*!*			[<memberdata name="triggerconditionfordelete" type="property" display="TriggerConditionForDelete" />] + ;
*!*			[</VFPData>]

*!*		*
*!*		* ParentTagName_Access
*!*		Procedure ParentTagName_Access()

*!*			Local loData As oDataBase Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loParentTable As oTable Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loTable As oTable Of 'DataDictionary\prg\DataDictionary.prg'
*!*			*!*	Local loColTables As colTables Of 'DataDictionary\prg\DataDictionary.prg'
*!*			*!*	Local loColFields As ColFields Of 'DataDictionary\prg\DataDictionary.prg'

*!*			If Empty ( This.ParentTagName )

*!*				If !Empty ( This.References )

*!*					*!*	loColFields = This.oParent
*!*					*!*	loColTables = loColFields.oParent.oParent
*!*					*!*	loParentTable = loColTables.GetItem( This.References )

*!*					loTable = This.oParent
*!*					loData  = loTable.oParent
*!*					Assert Vartype ( loData ) = 'O' Message 'loData no es un objeto'

*!*					*!*					loParentTable = loData.oColTables.GetItem( This.References )
*!*					loParentTable = loData.oColTables.GetItem ( This.cParentKeyName )

*!*					This.ParentTagName = loParentTable.GetPrimaryTagName()

*!*					If Upper ( Substr ( This.ParentTagName, 1, 2 ) ) # 'PK'
*!*						This.ParentTagName = ''
*!*					Endif

*!*				Endif

*!*			Endif

*!*			Return This.ParentTagName

*!*		Endproc && ParentTagName_Access


*!*		*
*!*		* cParentKeyName_Access
*!*		Protected Procedure cParentKeyName_Access()
*!*			If Empty ( This.cParentKeyName )
*!*				This.cParentKeyName = Strtran ( Lower ( This.References ), 'sys_', '' )
*!*			Endif

*!*			Return This.cParentKeyName

*!*		Endproc && cParentKeyName_Access

*!*	Enddefine && oTrigger

*!*	* oUpdateTrigger
*!*	* Clase Trigger 
*!*	Define Class oUpdateTrigger As oTrigger Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oUpdateTrigger Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Clase Trigger
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif


*!*	Enddefine && oUpdateTrigger

*!*	* oInsertTrigger
*!*	* Clase Trigger 
*!*	Define Class oInsertTrigger As oTrigger Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oInsertTrigger Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Clase Trigger
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 29 de Mayo de 2007 (11:00:34)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*			ENDTEXT
*!*		#Endif

*!*	Enddefine && oInsertTrigger

*!*	* oDeleteTrigger
*!*	* Clase Trigger 
*!*	Define Class oDeleteTrigger As oTrigger Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oDeleteTrigger Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Clase Trigger
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif


*!*	Enddefine && oDeleteTrigger

*!*	* ColProperties
*!*	* Colección de Indices 
*!*	Define Class ColProperties As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColProperties Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Colección de Indices
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damian Eiff

*!*			 *:Date:
*!*			 Martes 10 de Febrero de 2009 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="new" type="method" display="New" />] + ;
*!*			[</VFPData>]

*!*		* New
*!*		* Obtiene un elemento oTrigger vacío.
*!*		Function New ( tcName As String ) As oProperty Of DataDictionary\prg\DataDictionary.prg' HelpString 'Obtiene un elemento Object vacío'

*!*			Local liIdx As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loObj As oProperty Of DataDictionary\prg\DataDictionary.prg

*!*			#If .F.
*!*				TEXT
*!*					 *:Help Documentation
*!*					 *:Description:
*!*					 Obtiene un elemento oTrigger vacío
*!*					 *:Project:
*!*					 Sistemas Praxis

*!*					 *:Autor:
*!*					 Damian Eiff

*!*					 *:Date:
*!*					 Martes 10 de Febrero de 2009 (11:13:53)

*!*					 *:Parameters:
*!*					 *:Remarks:
*!*					 *:Returns:
*!*					 *:Example:
*!*					 *:SeeAlso:
*!*					 *:Events:
*!*					 *:KeyWords:
*!*					 *:Inherits:
*!*					 *:Exceptions:
*!*					 *:NameSpace:
*!*					 digitalizarte.com
*!*					 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				With This
*!*					liIdx = .GetKey ( m.tcName )
*!*					If Empty ( m.liIdx )
*!*						tloObj     = Newobject ( 'oProperty', 'DataDictionary\prg\DataDictionary.prg' )
*!*						loObj.Name = m.tcName
*!*						.AddItem ( m.loObj, m.tcName )

*!*					Endif &&  Empty( m.liIdx )
*!*				Endwith

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.loObj

*!*		Endfunc && New

*!*	Enddefine && ColProperties

*!*	* oProperty
*!*	* Colección de Indices 
*!*	Define Class oProperty As oBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oProperty Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Colección de Indices
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damian Eiff

*!*			 *:Date:
*!*			 Martes 10 de Febrero de 2009 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif

*!*		* Valor de la propiedad
*!*		Value = ''
*!*		*!*
*!*		nTierLevel = 1

*!*		* Indica si hay que agregar comillas al valor de la propedad
*!*		lAddQuotes = .F.

*!*		* Indica si la propiedad se agrega como un comentario ( plantilla para el desarrollador)
*!*		lAddComment = .F.

*!*		* Agrega un retorno de carro al final de la definición de la propiedad @see ToString
*!*		lCarriageReturn = .T.

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="value" type="property" display="Value" />] + ;
*!*			[<memberdata name="ntierlevel" type="property" display="nTierLevel" />] + ;
*!*			[<memberdata name="laddquotes" type="property" display="lAddQuotes" />] + ;
*!*			[<memberdata name="laddcomment" type="property" display="lAddComment" />] + ;
*!*			[<memberdata name="tostring" type="method" display="ToString" />] + ;
*!*			[<memberdata name="lcarriagereturn" type="property" display="lCarriageReturn" />] + ;
*!*			[</VFPData>]

*!*		* ToString
*!*		* Genera el codigo de la propiedad
*!*		Function ToString() As String HelpString 'Genera el codigo de la propiedad'

*!*			Local lcReturnValue As String, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			#If .F.
*!*				TEXT
*!*					 *:Help Documentation
*!*					 *:Description:
*!*					 Genera el codigo de la propiedad
*!*					 *:Project:
*!*					 Sistemas Praxis

*!*					 *:Autor:
*!*					 Damian Eiff

*!*					 *:Date:
*!*					 Viernes 13 de Marzo de 2009 (15:41:31)

*!*					 *:Parameters:
*!*					 *:Remarks:
*!*					 *:Returns:
*!*					 *:Example:
*!*					 *:SeeAlso:
*!*					 *:Events:
*!*					 *:KeyWords:
*!*					 *:Inherits:
*!*					 *:Exceptions:
*!*					 *:NameSpace:
*!*					 digitalizarte.com
*!*					 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try

*!*				lcReturnValue = ''
*!*				With This As oProperty Of 'DataDictionary\prg\DataDictionary.prg'
*!*					If ! Empty ( .Comment )
*!*						lcReturnValue = m.lcReturnValue + '* ' + Alltrim ( .Comment ) + CR

*!*					Endif &&  ! Empty( .Comment )

*!*					If .lAddComment
*!*						lcReturnValue = m.lcReturnValue + '* '

*!*					Endif &&  .lAddComment

*!*					lcReturnValue = m.lcReturnValue + Alltrim ( .Name ) + ' = '
*!*					If .lAddQuotes
*!*						lcReturnValue = m.lcReturnValue + '"'

*!*					Endif && .lAddQuotes

*!*					lcReturnValue = m.lcReturnValue + Alltrim ( .Value )

*!*					If .lAddQuotes
*!*						lcReturnValue = m.lcReturnValue + '"'

*!*					Endif &&  .lAddQuotes

*!*					If .lCarriageReturn
*!*						lcReturnValue = m.lcReturnValue + CR

*!*					Endif && .lCarriageReturn

*!*				Endwith


*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.lcReturnValue

*!*		Endfunc && ToString

*!*	Enddefine && oProperty

*!*	* ColStoreProcedures
*!*	* Colección de Bases de Datos.
*!*	Define Class ColStoreProcedures As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColStoreProcedures Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*			 *:Help Documentation
*!*			 *:Description:
*!*			 Colección de Bases de Datos
*!*			 *:Project:
*!*			 Sistemas Praxis

*!*			 *:Autor:
*!*			 Damián Eiff

*!*			 *:Date:
*!*			 Martes 29 de Mayo de 2007 (11:00:34)

*!*			 *:Parameters:
*!*			 *:Remarks:
*!*			 *:Returns:
*!*			 *:Example:
*!*			 *:SeeAlso:
*!*			 *:Events:
*!*			 *:KeyWords:
*!*			 *:Inherits:
*!*			 *:Exceptions:
*!*			 *:NameSpace:
*!*			 digitalizarte.com
*!*			 *:EndHelp
*!*			ENDTEXT
*!*		#Endif

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[</VFPData>]

*!*		* New
*!*		* Obtiene un elemento oIndex vacío 
*!*		Procedure New ( tcName As String, tcCodigo As String ) As oStoreProcedure Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Obtiene un elemento oIndex vacío'

*!*			Local lcKey As String, ;
*!*				liIdx As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loStoreProcedure As oStoreProcedure Of 'DataDictionary\prg\DataDictionary.prg'

*!*			#If .F.
*!*				TEXT
*!*					 *:Help Documentation
*!*					 *:Description:
*!*					 Obtiene un elemento oIndex vacío
*!*					 *:Project:
*!*					 Sistemas Praxis

*!*					 *:Autor:
*!*					 Damián Eiff

*!*					 *:Date:
*!*					 Martes 29 de Mayo de 2007 (11:13:53)

*!*					 *:Parameters:
*!*					 *:Remarks:
*!*					 *:Returns:
*!*					 *:Example:
*!*					 *:SeeAlso:
*!*					 *:Events:
*!*					 *:KeyWords:
*!*					 *:Inherits:
*!*					 *:Exceptions:
*!*					 *:NameSpace:
*!*					 digitalizarte.com
*!*					 *:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try
*!*				With This As ColStoreProcedures Of 'DataDictionary\prg\DataDictionary.prg'
*!*					If ! Empty ( m.tcName )
*!*						lcKey = Lower ( Justfname ( m.tcName ) )
*!*						liIdx = This.GetKey ( m.lcKey )
*!*						If Empty ( m.liIdx )
*!*							loStoreProcedure           = Newobject ( 'oStoreProcedure', 'DataDictionary\prg\DataDictionary.prg' )
*!*							loStoreProcedure.oParent   = This
*!*							loStoreProcedure.cFileName = m.tcName
*!*							loStoreProcedure.cCodigo   = m.Logical.IfEmpty ( m.tcCodigo, '' )
*!*							This.AddItem ( m.loStoreProcedure, m.lcKey )

*!*						Else
*!*							loStoreProcedure = Null

*!*						Endif && Empty( m.liIdx )

*!*					Else
*!*						loStoreProcedure = Null

*!*					Endif && ! Empty( m.tcName )

*!*				Endwith

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				loError.Process ( loErr )
*!*				Throw loError

*!*			Finally
*!*				loError = Null

*!*			Endtry
*!*			Return m.loStoreProcedure

*!*		Endproc && New

*!*	Enddefine && ColStoreProcedures

*!*	* oStoreProcedure
*!*	* Clase Base de Datos 
*!*	Define Class oStoreProcedure As oBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oStoreProcedure Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Clase Base de Datos
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 29 de Mayo de 2007 (11:00:34)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*			ENDTEXT
*!*		#Endif

*!*		* Nombre del archivo que contiene el Store procedure
*!*		cFileName = ''

*!*		cCodigo   = ''

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="cfilename" type="property" display="cFileName" />] + ;
*!*			[<memberdata name="ccodigo" type="property" display="cCodigo" />] + ;
*!*			[</VFPData>]

*!*	Enddefine && oStoreProcedure

*!*	* ColForms
*!*	* Colección de Formularios
*!*	Define Class ColForms As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColForms Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		#If .F.
*!*			TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Colección de Formularios
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 29 de Mayo de 2007 (11:00:34)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*			ENDTEXT
*!*		#Endif


*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[</VFPData>]

*!*		* Obtiene un elemento oForm vacío 
*!*		Procedure New ( tcName As String, tcKeyName As String ) As oForm Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Obtiene un elemento oForm vacío'

*!*			Local lcKey As String, ;
*!*				liIdx As Integer, ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
*!*				loForm As oForm Of 'DataDictionary\prg\DataDictionary.prg'

*!*			#If .F.
*!*				TEXT
*!*				 *:Help Documentation
*!*				 *:Description:
*!*				 Obtiene un elemento oForm vacío
*!*				 *:Project:
*!*				 Sistemas Praxis

*!*				 *:Autor:
*!*				 Damián Eiff

*!*				 *:Date:
*!*				 Martes 29 de Mayo de 2007 (11:13:53)

*!*				 *:Parameters:
*!*				 *:Remarks:
*!*				 *:Returns:
*!*				 *:Example:
*!*				 *:SeeAlso:
*!*				 *:Events:
*!*				 *:KeyWords:
*!*				 *:Inherits:
*!*				 *:Exceptions:
*!*				 *:NameSpace:
*!*				 digitalizarte.com
*!*				 *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try

*!*				With This
*!*					If ! Empty ( m.tcName )
*!*						lcKey = Lower ( Justfname ( m.tcName ) )
*!*						liIdx = .GetKey ( m.lcKey )

*!*						If Empty (m.liIdx )
*!*							loForm         = Newobject ( 'oForm', 'DataDictionary\prg\DataDictionary.prg' )
*!*							loForm.oParent = .oParent
*!*							.AddItem ( m.loForm, m.lcKey )
*!*							If Empty ( m.tcKeyName )
*!*								tcKeyName = m.tcName

*!*							Endif && Empty( m.tcKeyName )

*!*							loForm.Name     = tcName
*!*							loForm.cKeyName = tcKeyName

*!*						Else && Empty(m.liIdx )
*!*							Error 'Ya existe el Formulario ' + m.tcName

*!*						Endif && Empty(m.liIdx )

*!*					Else
*!*						Error 'Falta definir el nombre del Formulario'

*!*					Endif && ! Empty( m.tcName )

*!*				Endwith

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.loForm

*!*		Endproc && New

*!*	Enddefine && ColForms

*!*	* oForm
*!*	* Representa un formulario
*!*	Define Class oForm As oBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oForm Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		* Nombre unico de fantasía del formulario
*!*		cKeyName = ''

*!*		* Carpeta donde se encuentra el formulario
*!*		cFolder = ''

*!*		* Extension del formulario
*!*		cExt = 'scx'

*!*		* Identificación del formulario
*!*		nFormId = -1

*!*		* @TODO: Agregar los permisos

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="ckeyname" type="property" display="cKeyName" />] + ;
*!*			[<memberdata name="cext" type="property" display="cExt" />] + ;
*!*			[<memberdata name="cfolder" type="property" display="cFolder" />] + ;
*!*			[<memberdata name="nformid" type="property" display="nFormId" />] + ;
*!*			[</VFPData>]

*!*	Enddefine && oForm

*!*	* ColTiers
*!*	* Colección de Capas
*!*	Define Class ColTiers As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColTiers Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
*!*			+ [<VFPData>] ;
*!*			+ [</VFPData>]

*!*		Procedure New ( tcTierLevel As String )  As oECFG Of 'DataDictionary\prg\DataDictionary.prg' HelpString 'Obtiene un elemento oECFG vacío'

*!*			Local lcKey As String, ;
*!*				loEcfg As oECFG Of 'DataDictionary\prg\DataDictionary.prg', ;
*!*				loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'
*!*			*:Global i as Number

*!*			#If .F.
*!*				TEXT
*!*			        *:Help Documentation
*!*			        *:Topic:
*!*			        *:Description:
*!*				   Obtiene un elemento oECFG vacío
*!*			        *:Project:
*!*			        Sistemas Praxis
*!*			        *:Autor:
*!*			        Damian Eiff
*!*			        *:Date:
*!*			        Miércoles 11 de Marzo de 2009 (11:50:29)
*!*			        *:ModiSummary:
*!*			        *:Syntax:
*!*			        *:Example:
*!*			        *:Events:
*!*			        *:NameSpace:
*!*			        praxis.com
*!*			        *:Keywords:
*!*			        *:Implements:
*!*			        *:Inherits:
*!*			        *:Parameters:
*!*				   tcTierLevel As String
*!*			        *:Remarks:
*!*			        *:Returns:
*!*			         oECFG Of 'DataDictionary\prg\DataDictionary.prg'
*!*			        *:Exceptions:
*!*			        *:SeeAlso:
*!*			        *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Try
*!*				If ! Empty ( m.tcTierLevel )
*!*					loEcfg = Createobject ( 'oECFG' )
*!*					lcKey  = Lower ( m.tcTierLevel )
*!*					m.liIdx = This.GetKey (m.lcKey )

*!*					If Empty ( m.liIdx )
*!*						loEcfg.oParent    = This.oParent
*!*						loEcfg.cTierLevel = m.tcTierLevel
*!*						This.AddItem ( m.loEcfg, m.lcKey )

*!*					Else
*!*						Error 'Ya existe la Tier ' + m.tcTierLevel

*!*					Endif &&  Empty( m.liIdx )

*!*				Else
*!*					Error 'Falta definir el nombre de la Tier'

*!*				Endif && ! Empty( m.tcTierLevel )

*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				m.loError.Process ( m.loErr )
*!*				Throw m.loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*			Return m.loEcfg

*!*		Endproc && New

*!*	Enddefine && ColTiers

*!*	* oECFG
*!*	Define Class oECFG As oBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oECFG Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		* Nombre del objeto
*!*		cObjectName = ''

*!*		* Nivel de la capa
*!*		cTierLevel = ''

*!*		* Clase
*!*		cObjClass = ''

*!*		* Libreria de clases
*!*		cObjClassLibrary = ''

*!*		* Carpeta de la libreria de clases
*!*		cObjClassLibraryFolder = ''

*!*		* Nombre del componente
*!*		cObjComponent = ''

*!*		* Es parte de un componente
*!*		lObjInComComponent = .F.

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="cobjectname" type="property" display="cObjectName" />] + ;
*!*			[<memberdata name="ctierlevel" type="property" display="cTierLevel" />] + ;
*!*			[<memberdata name="cobjclass" type="property" display="cObjClass" />] + ;
*!*			[<memberdata name="cobjclasslibrary" type="property" display="cObjClassLibrary" />] + ;
*!*			[<memberdata name="cobjclasslibraryfolder" type="property" display="cObjClassLibraryFolder" />] + ;
*!*			[<memberdata name="cobjcomponent" type="property" display="cObjComponent" />] + ;
*!*			[<memberdata name="lobjincomcomponent" type="property" display="lObjInComComponent" />] + ;
*!*			[</VFPData>]

*!*	Enddefine && oECFG

*!*	* ColValidations
*!*	* Colección de Validaciones
*!*	Define Class ColValidations As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColValidations Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		* Archivo de la libreria de clases
*!*		cClassLibrary = 'DataDictionary.Prg'

*!*		* Directorio de la libreria de clases
*!*		cClassLibraryFolder = 'DataDictionary\prg'

*!*		* Nombre de la clase contenida
*!*		cClassName = 'oValidationBase'

*!*		* Nombre de la clase
*!*		Name = 'ColValidations'

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[</VFPData>]

*!*	Enddefine && ColValidations

*!*	* oValidationBase
*!*	* Validación base
*!*	Define Class oValidationBase As oBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oValidationBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		* Referencia l campo que se va a validar
*!*		oField = Null

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
*!*			+ [<VFPData>] ;
*!*			+ [<memberdata name="execute" type="method" display="Execute" />] ;
*!*			+ [<memberdata name="ofield" type="property" display="oField" />] ;
*!*			+ [</VFPData>]

*!*		* This_Access
*!*		Protected Procedure This_Access ( tcMemberName As String ) As Object
*!*			Local loRet As Object
*!*			With This As oValidationBase Of 'DataDictionary\prg\DataDictionary.prg'
*!*				If ! Pemstatus ( This, m.tcMemberName, 5 )
*!*					If Vartype ( .oField ) = 'O' And Pemstatus ( .oField, m.tcMemberName, 5 )
*!*						loRet = .oField
*!*					Else
*!*						loRet = This

*!*					Endif && Vartype( This.oField ) = 'O' And Pemstatus( This.oField, m.tcMemberName, 5 )
*!*				Else
*!*					loRet = This

*!*				Endif && ! Pemstatus( This, m.tcMemberName, 5 )

*!*			Endwith

*!*			Return loRet

*!*		Endproc && This_Access

*!*		* Execute
*!*		Procedure Execute ( tcCursorName As String ) As Boolean
*!*			#If .F.
*!*				TEXT
*!*			        *:Help Documentation
*!*			        *:Topic:
*!*			        *:Description:
*!*			        Metodo que se ejecuta para la validación
*!*			        *:Project:
*!*			        Sistemas Praxis
*!*			        *:Autor:
*!*			        Damian Eiff
*!*			        *:Date:
*!*			        Miércoles 11 de Marzo de 2009 (11:50:29)
*!*			        *:ModiSummary:
*!*			        *:Syntax:
*!*			        *:Example:
*!*			        *:Events:
*!*			        *:NameSpace:
*!*			        praxis.com
*!*			        *:Keywords:
*!*			        *:Implements:
*!*			        *:Inherits:
*!*			        *:Parameters:
*!*			        toParam As Object
*!*			        *:Remarks:
*!*			        *:Returns:
*!*			        Boolean
*!*			        *:Exceptions:
*!*			        *:SeeAlso:
*!*			        *:EndHelp
*!*				ENDTEXT
*!*			#Endif

*!*			Return .T.

*!*		Endproc && Execute

*!*	Enddefine && oValidationBase

*!*	* ColReports
*!*	* Colección de Reportes
*!*	Define Class ColReports As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColReports Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		* Archivo de la libreria de clases
*!*		cClassLibrary = 'DataDictionary.Prg'

*!*		* Directorio de la libreria de clases
*!*		cClassLibraryFolder = 'DataDictionary\prg'

*!*		* Nombre de la clase contenida
*!*		cClassName = 'oReport'

*!*		* Nombre de la clase
*!*		Name = 'ColReports'

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
*!*			+ [<VFPData>] ;
*!*			+ [</VFPData>]

*!*		Function Initialize() As Boolean
*!*			#If .F.
*!*				TEXT
*!*			        *:Help Documentation
*!*			        *:Topic:
*!*			        *:Description:
*!*			        Template Method para iniciar el objeto
*!*			        *:Project:
*!*			        Sistemas Praxis
*!*			        *:Autor:
*!*			        Damian Eiff
*!*			        *:Date:
*!*			        Miércoles 11 de Marzo de 2009 (11:50:29)
*!*			        *:ModiSummary:
*!*			        *:Syntax:
*!*			        *:Example:
*!*			        *:Events:
*!*			        *:NameSpace:
*!*			        praxis.com
*!*			        *:Keywords:
*!*			        *:Implements:
*!*			        *:Inherits:
*!*			        *:Parameters:
*!*			        toParam As Object
*!*			        *:Remarks:
*!*			        *:Returns:
*!*			        Boolean
*!*			        *:Exceptions:
*!*			        *:SeeAlso:
*!*			        *:EndHelp
*!*				ENDTEXT
*!*			#Endif
*!*		Endfunc && Initialize

*!*	Enddefine && ColReports

*!*	* oReport
*!*	* Representa un Reporte
*!*	Define Class oReport As oBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oReport Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		* Colección de filtros
*!*		oColFilter = Null

*!*		* Colección de orden
*!*		oColOrder = Null

*!*		* Referencia al formulario
*!*		oForm = Null

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="ocolfilter" type="property" display="oColFilter" />] + ;
*!*			[<memberdata name="ocolorder" type="property" display="oColOrder" />] + ;
*!*			[<memberdata name='oForm' type="property" display='oForm' />] + ;
*!*			[</VFPData>]

*!*		* oColFilter_Access
*!*		Protected Procedure oColFilter_Access() As ColReportFilter Of 'DataDictionary\prg\DataDictionary.prg'
*!*			With This As oReport Of 'DataDictionary\prg\DataDictionary.prg'
*!*				If Vartype ( .oColFilter ) # 'O'
*!*					.oColFilter = Newobject ( 'ColReportFilter', 'DataDictionary\prg\DataDictionary.prg' )

*!*				Endif && Vartype( .oColFilter ) # "O"
*!*			Endwith
*!*			Return This.oColFilter

*!*		Endproc && oColFilter_Access

*!*		* oColOrder_Access
*!*		Protected Procedure oColOrder_Access() As ColReportOrder Of 'DataDictionary\prg\DataDictionary.prg'
*!*			With This As oReport Of 'DataDictionary\prg\DataDictionary.prg'
*!*				If Vartype ( .oColOrder ) # 'O'
*!*					.oColOrder = Newobject ( 'ColReportOrder', 'DataDictionary\prg\DataDictionary.prg' )

*!*				Endif && Vartype( .oColOrder ) # "O"

*!*			Endwith

*!*			Return This.oColOrder

*!*		Endproc && oColOrder_Access

*!*	Enddefine && oReport

*!*	* ColReportOrder
*!*	* Colección de Reportes
*!*	Define Class ColReportOrder As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColReportOrder Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		* Archivo de la libreria de clases
*!*		cClassLibrary = 'DataDictionary.Prg'

*!*		* Directorio de la libreria de clases
*!*		cClassLibraryFolder = 'DataDictionary\prg'

*!*		*!*	Nombre de la clase contenida
*!*		cClassName = 'oReportOrder'

*!*		* Nombre de la clase
*!*		Name = 'ColReportOrder'

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
*!*			+ [<VFPData>] ;
*!*			+ [</VFPData>]

*!*	Enddefine && ColReportOrder

*!*	* oReportOrder
*!*	* Criterio de Orden para un reporte
*!*	Define Class oReportOrder As oBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oReportOrder Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		oField = Null

*!*		* Número de orden del elemento
*!*		nTabIndex = 0

*!*		* Indica si el criterio esta visible
*!*		lVisible = .T.

*!*		* Indica si el objeto ha sido seleccionado
*!*		lSelected = .F.

*!*		* Contiene el nombre que se mostrará al usuario
*!*		cDisplayValue = ''

*!*		* Nombre del campo en la tabla de origen
*!*		cFieldName = ''

*!*		* Nombre de la tabla en el origen de datos
*!*		cTableName = ''

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="lselected" type="property" display="lSelected" />] + ;
*!*			[<memberdata name="lvisible" type="property" display="lVisible" />] + ;
*!*			[<memberdata name="ntabindex" type="property" display="nTabIndex" />] + ;
*!*			[<memberdata name="ntabindex_assign" type="method" display="nTabIndex_Assign" />] + ;
*!*			[<memberdata name="cdisplayvalue" type="property" display="cDisplayValue" />] + ;
*!*			[<memberdata name="cdisplayvalue_access" type="method" display="cDisplayValue_Access" />] + ;
*!*			[<memberdata name="ctablename" type="property" display="cTableName" />] + ;
*!*			[<memberdata name="cfieldname" type="property" display="cFieldName" />] + ;
*!*			[<memberdata name="ofield" type="property" display="oField" />] + ;
*!*			[</VFPData>]

*!*		* This_Access
*!*		Protected Procedure This_Access ( tcMemberName As String ) As Object
*!*			Local loRet As Object
*!*			With This
*!*				If ! Pemstatus ( This, m.tcMemberName, 5 )
*!*					If Vartype ( .oField ) = 'O' And Pemstatus ( .oField, m.tcMemberName, 5 )
*!*						loRet = .oField

*!*					Else
*!*						loRet = This

*!*					Endif && Vartype( .oField ) = 'O' And Pemstatus( .oField, m.tcMemberName, 5 )
*!*				Else
*!*					loRet = This

*!*				Endif && ! Pemstatus( This, m.tcMemberName, 5 )

*!*			Endwith

*!*			Return loRet

*!*		Endproc && This_Access

*!*		* cDisplayValue_Access
*!*		Protected Procedure cDisplayValue_Access() As String
*!*			With This
*!*				If Empty ( .cDisplayValue )
*!*					.cDisplayValue = .oField.Caption

*!*				Endif && Empty( This.cDisplayValue )

*!*			Endwith

*!*			Return This.cDisplayValue

*!*		Endproc && cDisplayValue_Access

*!*		* cTableName_Access
*!*		Protected Procedure cTableName_Access() As String
*!*			With This
*!*				If Empty ( .cTableName )
*!*					.cTableName = .oField.oParent.Name

*!*				Endif && Empty( .cTableName )

*!*			Endwith

*!*			Return This.cTableName

*!*		Endproc && cTableName_Access

*!*		* cFieldName_Access
*!*		Protected Procedure cFieldName_Access() As String
*!*			With This
*!*				If Empty ( .cFieldName )
*!*					.cFieldName = .oField.Name

*!*				Endif && Empty( .cFieldName )
*!*			Endwith
*!*			Return This.cFieldName

*!*		Endproc && cFieldName_Access

*!*		* nTabIndex_Assign
*!*		Protected Procedure nTabIndex_Assign ( tnNewValue As Integer )
*!*			Local loErr As Object, ;
*!*				loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

*!*			Try
*!*				With This
*!*					If Vartype ( m.tnNewValue ) # 'N'
*!*						Error 'Tipo de dato no válido en la propiedad nTabIndex de ' + .Name

*!*					Endif && Vartype( uNewValue ) # 'N'

*!*					If m.tnNewValue <= 0
*!*						Error 'Valor no válido en la propiedad nTabIndex de ' + .Name

*!*					Endif && uNewValue <= 0

*!*					.nTabIndex = m.tnNewValue

*!*				Endwith
*!*			Catch To loErr
*!*				loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
*!*				loError.Process ( loErr )
*!*				Throw loError

*!*			Finally
*!*				loError = Null

*!*			Endtry

*!*		Endproc && nTabIndex_Assign

*!*	Enddefine && oReportOrder

*!*	* ColReportFilter
*!*	* Colección de Reportes
*!*	Define Class ColReportFilter As ColBase Of 'DataDictionary\prg\DataDictionary.prg'  OlePublic

*!*		#If .F.
*!*			Local This As ColReportFilter Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		* Archivo de la libreria de clases
*!*		cClassLibrary = 'DataDictionary.Prg'

*!*		* Directorio de la libreria de clases
*!*		cClassLibraryFolder = 'DataDictionary\prg'

*!*		*!*	Nombre de la clase contenida
*!*		cClassName = 'oReportFilter'

*!*		* Nombre de la clase
*!*		Name = 'ColReportFilter'

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[</VFPData>]

*!*	Enddefine && ColReportFilter

*!*	* oReportFilter
*!*	* Filtro para un reporte
*!*	Define Class oReportFilter As oBase  Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oReportFilter Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		oField = Null

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[</VFPData>]

*!*		* This_Access
*!*		Protected Procedure This_Access ( tcMemberName As String ) As Object
*!*			Local loRet As Object
*!*			loRet = This
*!*			With This As oReportFilter Of 'DataDictionary\prg\DataDictionary.prg'
*!*				If ! Pemstatus ( This, m.tcMemberName, 5 )
*!*					If Vartype ( .oField ) = 'O' And Pemstatus ( .oField, m.tcMemberName, 5 )

*!*						loRet = .oField

*!*					Endif && Vartype( .oField ) = 'O' And Pemstatus( .oField, m.tcMemberName, 5 )

*!*				Endif && ! Pemstatus( This, m.tcMemberName, 5 )

*!*			Endwith

*!*			Return m.loRet

*!*		Endproc && This_Access


*!*	Enddefine && oReportFilter

*!*	* ColContainer
*!*	* Colección de Contenedores
*!*	Define Class ColContainer As ColBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As ColContainer Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		* Archivo de la libreria de clases
*!*		cClassLibrary = 'DataDictionary.Prg'

*!*		* Directorio de la libreria de clases
*!*		cClassLibraryFolder = 'DataDictionary\prg'

*!*		*!*	Nombre de la clase contenida
*!*		cClassName = 'oContainer'

*!*		* Nombre de la clase
*!*		Name = 'ColContainer'

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[</VFPData>]

*!*	Enddefine && ColContainer

*!*	* oContainer
*!*	* Contenedor de controles
*!*	Define Class oContainer As oBase Of 'DataDictionary\prg\DataDictionary.prg'  OlePublic

*!*		#If .F.
*!*			Local This As oContainer Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		Name = 'oContainer'

*!*		* Colección de Controles
*!*		oColControls = Null

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="ocolcontrols" type="property" display="oColControls" />] + ;
*!*			[<memberdata name="ocolcontrols_access" type="method" display="oColControls_Access" />] + ;
*!*			[</VFPData>]

*!*		* oColControls_Access
*!*		Protected Procedure oColControls_Access() As ColControls Of 'DataDictionary\prg\DataDictionary.prg'
*!*			With This As oContainer Of 'DataDictionary\prg\DataDictionary.prg'
*!*				If Vartype ( .oColControls ) # 'O'
*!*					.oColControls = Newobject ( 'ColControls', 'DataDictionary\prg\DataDictionary.prg' )

*!*				Endif && Vartype( .oColControls ) # 'O'

*!*			Endwith

*!*			Return This.oColControls

*!*		Endproc && oColControls_Access

*!*	Enddefine && oContainer

*!*	* ColControls
*!*	* Colección de Controles
*!*	Define Class ColControls As ColBase Of 'DataDictionary\prg\DataDictionary.prg'

*!*		#If .F.
*!*			Local This As ColControls Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		* Archivo de la libreria de clases
*!*		cClassLibrary = 'DataDictionary.Prg'

*!*		* Directorio de la libreria de clases
*!*		cClassLibraryFolder = 'DataDictionary\prg'

*!*		*!*	Nombre de la clase contenida
*!*		cClassName = 'oControl'

*!*		* Nombre de la clase
*!*		Name = 'ColControls'

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[</VFPData>]

*!*	Enddefine && ColControls

*!*	* oControl
*!*	* Clase que representa un control
*!*	Define Class oControl As oBase Of 'DataDictionary\prg\DataDictionary.prg' OlePublic

*!*		#If .F.
*!*			Local This As oControl Of 'DataDictionary\prg\DataDictionary.prg'
*!*		#Endif

*!*		oField = Null

*!*		oTable = Null

*!*		Name = 'oControl'

*!*		Protected m._MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="ofield" type="property" display="oField" />] + ;
*!*			[<memberdata name="otable" type="property" display="oTable" />] + ;
*!*			[</VFPData>]

*!*		* This_Access
*!*		Protected Procedure This_Access ( tcMemberName As String ) As Object
*!*			If ! Pemstatus ( This, m.tcMemberName, 5 )
*!*				If Vartype ( This.oField ) = 'O' And Pemstatus ( This.oField, m.tcMemberName, 5 )

*!*					Return This.oField

*!*				Endif && Vartype( This.oField ) = 'O' And Pemstatus( This.oField, m.tcMemberName, 5 )

*!*				If Vartype ( This.oTable ) = 'O' And Pemstatus ( This.oTable, m.tcMemberName, 5 )

*!*					Return This.oTable

*!*				Endif && Vartype( This.oTable ) = 'O' And Pemstatus( This.oTable, m.tcMemberName, 5 )

*!*			Endif && ! Pemstatus( This, m.tcMemberName, 5 )

*!*			Return This

*!*		Endproc && This_Access

*!*	Enddefine && oControl
