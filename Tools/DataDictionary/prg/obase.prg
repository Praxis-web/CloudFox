#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\Namespaces\Prg\CustomBase.prg'
    Do 'ErrorHandler\Prg\ErrorHandler.prg'

Endif

* oBase
* Clase para los objetos del diccionario de datos.
Define Class oBase As CustomBase Of 'Tools\Namespaces\Prg\CustomBase.prg' 

	#If .F.
		Local This As oBase Of 'Tools\DataDictionary\prg\oBase.prg'
	#Endif
	

	#If .F.
		TEXT
		 *:Help Documentation
		 *:Description:
		 Clase para los objetos del diccionario de datos.
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

	DataSession = SET_DEFAULT
	
*!*		Name = 'oBase'

	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="createdirifnotexists" type="method" display="CreateDirIfNotExists" />] ;
		+ [<memberdata name="populateproperties" type="method" display="PopulateProperties" />] ;
		+ [<memberdata name="retrycommand" type="method" display="ReTryCommand" />] ;
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
			loErr As Exception, ;
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
			loErr As Exception, ;
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

	Dimension ReTryCommand_COMATTRIB[ 5 ]
	ReTryCommand_COMATTRIB[ 1 ] = 0
	ReTryCommand_COMATTRIB[ 2 ] = 'Executa un comando y si falla reintenta n veces.'
	ReTryCommand_COMATTRIB[ 3 ] = 'ReTryCommand'
	ReTryCommand_COMATTRIB[ 4 ] = 'Void'
	* ReTryCommand_COMATTRIB[ 5 ] = 0

	* ReTryCommand
	* Executa un comando y si falla reintenta n veces.
	Procedure ReTryCommand ( tcCommand As String, tnMaxIntentos As Integer, tnErrorNo As Integer, tlDoevents As Boolean ) As Void HelpString 'Executa un comando y si falla reintenta n veces.'

		Local lcCommand As String, ;
			lnIntentos As Integer, ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'
			
		Local llDone as Boolean 	

		#If .F.
			TEXT
				*:Help Documentation
				*:Topic:
				*:Description:
				Executa un comando y si falla reintenta n veces,
				*:Project:
				Sistemas Praxis
				*:Autor:
				Damian Eiff
				*:Date:
				 Lunes 6 de Abril de 2009 (18:05:31)
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
				tcCommand As String
				tnMaxIntentos As Integer
				tnErrorNo As Integer
				tlDoevents As Boolean
				*:Remarks:
				*:Returns:
				Void
				*:Exceptions:
				*:SeeAlso:
				*:EndHelp
			ENDTEXT
		#Endif
		
		llDone = .F. 

		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )

		If Empty ( m.tnMaxIntentos )
			tnMaxIntentos = 10

		Endif && Empty( m.tnMaxIntentos )

		If Empty ( m.tnErrorNo )
			tnErrorNo = 0

		Endif && Empty( m.tnErrorNo )

		lnIntentos = 0
		Do While !llDone And m.lnIntentos < m.tnMaxIntentos
			Try

				lnIntentos = m.lnIntentos + 1
				&tcCommand
				
				llDone = .T. 
				
			Catch To loErr
				Wait Window 'Reintentando ( ' + Transform ( m.lnIntentos ) + ' ) ' + m.tcCommand + '....' Nowait

				If  m.loErr.ErrorNo == m.tnErrorNo
					* m.lnIntentos = m.lnIntentos + 1
					TEXT To m.lcCommand Noshow Textmerge Pretext 15
						<<m.lnIntentos>>: <<m.tcCommand>>
					ENDTEXT
					loError.Cremark = 'Reintento Nº ' + m.lcCommand
					m.loError.Process ( m.loErr, .F. )

				Endif && m.oErr.ErrorNo == m.tnErrorNo

				If m.tlDoevents
					DoEvents

				Endif && m.tlDoevents

			Endtry

		EndDo && While m.lnIntentos < m.tnMaxIntentos

		Try
			If !llDone && m.lnIntentos # m.tnMaxIntentos + 1
				Error 'Se alcanzo el maximo de intentos sin poder ejecutar satifactoriamente el comando ' + m.lcCommand

			Endif &&  m.lnIntentos # m.tnMaxIntentos + 1

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCommand, tnMaxIntentos, tnErrorNo, tlDoevents
			If Vartype ( m.loError ) # 'O'
				loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )

			Endif && Vartype( m.loError ) # 'O'

			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally

		Endtry

	Endproc && ReTryCommand

Enddefine && oBase