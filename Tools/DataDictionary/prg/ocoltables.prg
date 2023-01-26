#include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'
#Include 'Tools\DataDictionary\Include\DataDictionary.h'

* oColTables
* Colección de tablas de una base de datos.
Define Class oColTables As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'

	#If .F.
		Local This As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg'
	#Endif

	#If .F.
		TEXT
			 *:Help Documentation
			 *:Description:
			 Colección de tablas de una base de datos.
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

	Name                  = 'oColTables'

	nNivelJerarquiaTablas = 0

	* Nombre de la clase de los elementos que forman la coleccion.
	cClassName = 'oTable'

	* Indica si la coleccion es de tablas libres.
	*lIsFree = .T.
	lIsFree = .F.

	* Carpeta donde se encuentra la Tabla
	cFolder = ''


	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="lisfree" type="property" display="lIsFree" />] ;
		+ [<memberdata name="nniveljerarquiatablas" type="property" display="nNivelJerarquiaTablas" />] ;
		+ [<memberdata name="addtable" type="event" display="AddTable" />] ;
		+ [<memberdata name="assignlevel" type="method" display="AssignLevel" />] ;
		+ [<memberdata name="assignmain" type="method" display="AssignMain" />] ;
		+ [<memberdata name="assignniveljerarquiatablas" type="method" display="AssignNivelJerarquiaTablas" />] ;
		+ [<memberdata name="gettable" type="method" display="GetTable" />] ;
		+ [<memberdata name="removetable" type="method" display="RemoveTable" />] ;
		+ [<memberdata name="cfolder" type="property" display="cFolder" />] ;
		+ [</VFPData>]

	Dimension m.AddTable_COMATTRIB[ 5 ]
	AddTable_COMATTRIB[ 1 ] = 0
	AddTable_COMATTRIB[ 2 ] = 'Agrega una tabla a la colección.'
	AddTable_COMATTRIB[ 3 ] = 'AddTable'
	AddTable_COMATTRIB[ 4 ] = 'Void'
	* AddTable_COMATTRIB[ 5 ] = 0

	* AddTable
	* Agrega una tabla a la colección.
	Procedure AddTable ( toTable As oTable, tlNoSetParent As Boolean ) As Void HelpString 'Agrega una tabla a la colección.'

		Local lcKey As String, ;
			liIdx As Integer, ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'


		Try

			lcKey = Lower ( m.toTable.cKeyName )
			liIdx = This.GetKey ( m.lcKey )

			If Empty ( m.liIdx )
				If Empty ( m.toTable.cLongTableName )
					toTable.cLongTableName = m.toTable.Name

				Endif && Empty( m.toTable.cLongTableName )

				If ! m.tlNoSetParent
					*!*						toTable.oParent = m.This.oParent
					toTable.oParent = This

				Endif && ! tlNoSetParent

				This.AddItem ( m.toTable, m.lcKey )

			Endif && Empty( m.liIdx )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION,  toTable, tlNoSetParent
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally

		Endtry

	Endproc && AddTable

	Dimension AssignLevel_COMATTRIB[ 5 ]
	AssignLevel_COMATTRIB[ 1 ] = 0
	AssignLevel_COMATTRIB[ 2 ] = 'Asigna el nivel a cada objeto oTable.'
	AssignLevel_COMATTRIB[ 3 ] = 'AssignLevel'
	AssignLevel_COMATTRIB[ 4 ] = 'Void'
	* AssignLevel_COMATTRIB[ 5 ] = 0

	* AssignLevel
	* Asigna el nivel a cada objeto oTable.
	Procedure AssignLevel ( toCol As collecton, tnNivel As Integer, tnNivelJerarquiaTablas As Integer ) As Void HelpString 'Asigna el nivel a cada objeto oTable.'

		Local liIdx As Integer, ;
			loErr As Object, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

		Try
			For liIdx = 1 To m.toCol.Count
				loTable                = m.toCol.Item[ m.liIdx ]
				loTable.Nivel          = m.tnNivel
				tnNivelJerarquiaTablas = m.This.AssignLevel ( m.loTable.oColTables, m.tnNivel + 1, m.tnNivelJerarquiaTablas + 1 )

			Endfor

		Catch To loErr
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			Throw m.loError

		Finally
			loTable = Null

		Endtry

		Return m.tnNivelJerarquiaTablas

	Endproc && AssignLevel

	Dimension AssignMain_COMATTRIB[ 5 ]
	AssignMain_COMATTRIB[ 1 ] = 0
	AssignMain_COMATTRIB[ 2 ] = 'Asigna el principal a cada objeto oTable.'
	AssignMain_COMATTRIB[ 3 ] = 'AssignMain'
	AssignMain_COMATTRIB[ 4 ] = 'Void'
	* AssignMain_COMATTRIB[ 5 ] = 0

	* AssignMain
	* Asigna el principal a cada objeto oTable.
	Procedure AssignMain ( toCol As collecton, toMain As Object ) As Void HelpString 'Asigna el principal a cada objeto oTable'

		Local liIdx As Integer, ;
			loErr As Object, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
			loRefFieldMain As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
			loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'


		Try

			If m.toCol.Count > 0
				loField        = m.toMain.GetPrimaryKey()
				loRefFieldMain = m.This.oParent.oColFields.GetItem ( m.loField.Name )
				If Vartype ( m.loRefFieldMain ) == 'O'
					loRefFieldMain.nComboOrder      = Iif ( Empty ( m.loRefFieldMain.nComboOrder ), -1, m.loRefFieldMain.nComboOrder )
					loRefFieldMain.nShowInKeyFinder = Iif ( Empty ( m.loRefFieldMain.nShowInKeyFinder ), -1, m.loRefFieldMain.nShowInKeyFinder )

				Endif && Vartype( m.loRefFieldMain ) == 'O'

				For liIdx = 1 To m.toCol.Count
					loTable        = m.toCol.Item[ m.liIdx ]
					loTable.cMainId = m.loField.Name
					m.This.AssignMain ( m.loTable.oColTables, m.toMain )

				Endfor

			Endif && m.toCol.Count > 0

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toCol, toMain
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loRefFieldMain = Null
			loTable        = Null
			loField        = Null

		Endtry

	Endproc && AssignMain

	Dimension AssignNivelJerarquiaTablas_COMATTRIB[ 5 ]
	AssignNivelJerarquiaTablas_COMATTRIB[ 1 ] = 0
	AssignNivelJerarquiaTablas_COMATTRIB[ 2 ] = 'Asigna el nivel de jerarquia a cada objeto oTable.'
	AssignNivelJerarquiaTablas_COMATTRIB[ 3 ] = 'AssignNivelJerarquiaTablas'
	AssignNivelJerarquiaTablas_COMATTRIB[ 4 ] = 'Void'
	* AssignNivelJerarquiaTablas_COMATTRIB[ 5 ] = 0

	* AssignNivelJerarquiaTablas
	* Asigna el nivel de jerarquia a cada objeto oTable.
	Procedure AssignNivelJerarquiaTablas ( toCol As collecton, tnNivelJerarquiaTablas As Integer ) As Void HelpString 'Asigna el nivel de jerarquia a cada objeto oTable.'

		Local liIdx As Integer, ;
			loErr As Object, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

		Try
			For liIdx = 1 To m.toCol.Count
				loTable                       = m.toCol.Item[ m.liIdx ]
				loTable.nNivelJerarquiaTablas = m.tnNivelJerarquiaTablas
				This.AssignNivelJerarquiaTablas ( m.loTable.oColTables, m.tnNivelJerarquiaTablas - 1 )

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toCol, tnNivelJerarquiaTablas
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally

		Endtry

	Endproc && AssignNivelJerarquiaTablas

	Dimension GetTable_COMATTRIB[ 5 ]
	GetTable_COMATTRIB[ 1 ] = 0
	GetTable_COMATTRIB[ 2 ] = 'Devuelve una referencia a la tabla buscada.'
	GetTable_COMATTRIB[ 3 ] = 'GetTable'
	GetTable_COMATTRIB[ 4 ] = 'oTable'
	* GetTable_COMATTRIB[ 5 ] = 0

	* GetTable
	* Devuelve una referencia a la tabla buscada.
	Procedure GetTable ( tcTableName As String ) As oTable Of 'Tools\DataDictionary\prg\oTable.prg' HelpString 'Devuelve una referencia a la tabla buscada.'

		Local liIdx As Integer, ;
			loErr As Object, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
			loObj As oTable Of 'Tools\DataDictionary\prg\oTable.prg', ;
			loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg', ;
			loTableAux As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

		Try

			* Busca la tabla con el nombre requerido.
			loTable = This.GetItem ( m.tcTableName )
			* Si no existe recorro la colección
			liIdx = 1
			Do While m.liIdx < m.This.Count And Isnull ( m.loTable )
				loTableAux = m.This.Item[ m.liIdx ]
				* Por cada tabla pido a su colección tables por la tabla buscada
				loTable = m.loTableAux.oColTables.GetTable ( m.tcTableName )
				liIdx   = m.liIdx + 1

			Enddo

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcTableName
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loTableAux = Null

		Endtry

		Return m.loTable

	Endproc && GetTable



	*
	* Elimina una tabla de la colección
	Procedure RemoveTable( tcTableName As String ) As oTable ;
			Of 'Tools\DataDictionary\prg\oTable.prg' ;
			HelpString 'Devuelve una referencia a la tabla eliminada.'

		Local lcCommand As String
		Local loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

		Try

			lcCommand = ""
			loTable = This.GetTable( tcTableName )
			
			This.RemoveItem( tcTableName )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loTable 
		 
	Endproc && RemoveTable


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oTable vacío
	*!* Date..........: Martes 29 de Mayo de 2007 (11:13:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001 -
	*!*
	*!*

	Function New( tcName As String ) As oTable Of "Tools\DataDictionary\prg\oTable.prg" HelpString "Obtiene un elemento oTable vacío"

		Local loTable As oTable Of "Tools\DataDictionary\prg\oTable.prg"

		Try

			loTable = _NewObject( 'oTable', 'Tools\DataDictionary\prg\oTable.prg', '', This.lIsFree )

			If ! Empty( tcName )
				loTable.Name = Alltrim( tcName )
				loTable.lIsFree = This.lIsFree
				loTable.cFolder = This.cFolder

				This.AddTable( loTable )

			Endif && ! Empty( tcName )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcName
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Endtry

		Return loTable

	Endfunc && New

Enddefine && oColTables
