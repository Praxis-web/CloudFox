#include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'
#Include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
	Do 'ErrorHandler\prg\ErrorHandler.prg'
	Do 'Tools\DataDictionary\prg\oColBase.prg'
	Do 'Tools\DataDictionary\prg\oField.prg'
	Do 'Tools\DataDictionary\prg\oIndex.prg'

Endif

* oColIndexes
* Colección de indices.
Define Class oColIndexes As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'

	#If .F.
		Local This As oColIndexes Of 'Tools\DataDictionary\prg\oColIndexes.prg'
	#Endif

	#If .F.
		TEXT
		 *:Help Documentation
		 *:Description:
		 Colección de indices.
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

	Protected m._MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="addindex" type="method" display="AddIndex" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[</VFPData>]

	Dimension AddIndex_COMATTRIB[ 5 ]
	AddIndex_COMATTRIB[ 1 ] = 0
	AddIndex_COMATTRIB[ 2 ] = 'Agrega un indice a la colección de indices.'
	AddIndex_COMATTRIB[ 3 ] = 'AddIndex'
	AddIndex_COMATTRIB[ 4 ] = 'Void'
	* AddIndex_COMATTRIB[ 5 ] = 0

	* AddIndex
	* Agrega un indice a la colección de indices.
	Procedure AddIndex ( toIndex As oIndex Of 'Tools\DataDictionary\prg\oIndex.prg') As Void HelpString 'Agrega un indice a la colección de indices.'

		Local lcKey As String, ;
			liIdx As Integer, ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\prg\ErrorHandler.prg'

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Agrega un indice a la colección de indices.
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damián Eiff
			 *:Date:
			 Martes 29 de Mayo de 2007 (11:04:54)
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


		Try

			If Vartype( toIndex ) # 'O'
				Error 'Argumento invalido: toIndex'

			Endif && Vartype( toIndex ) # 'O'

			toIndex.oParent = This.oParent

			lcKey = Lower ( toIndex.cTagName )
			liIdx = This.GetKey ( lcKey )

			If Empty ( liIdx )
				This.AddItem ( toIndex, lcKey )
			Endif && Empty ( liIdx )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, oIndex
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError = Null

		Endtry

	Endproc && AddIndex

	Dimension New_COMATTRIB[ 5 ]
	New_COMATTRIB[ 1 ] = 0
	New_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oIndex.'
	New_COMATTRIB[ 3 ] = 'New'
	New_COMATTRIB[ 4 ] = 'oIndex'
	* New_COMATTRIB[ 5 ] = 0

	* New
	* Devuelve una nueva instancia de oIndex.
	Function New ( cName As String ) As oIndex Of 'Tools\DataDictionary\prg\oIndex.prg' HelpString 'Devuelve una nueva instancia de oIndex.'

		Local loErr As Exception, ;
			loError As ErrorHandler Of 'ErrorHandler\prg\ErrorHandler.prg', ;
			loIndex As oIndex Of 'Tools\DataDictionary\prg\oIndex.prg'

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve una nueva instancia de oIndex.
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damián Eiff
				 *:Date:
				 Martes 29 de Mayo de 2007 (11:13:53)
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

		Try

*!*				loIndex = _NewObject ( 'oIndex', 'Tools\DataDictionary\prg\oIndex.prg' )
*!*				If ! Empty ( cName )
*!*					loIndex.cTagName = Alltrim ( cName )
*!*					This.AddIndex ( loIndex )

*!*				Endif && ! Empty ( cName )

			If Empty ( cName )
				loIndex = _NewObject ( 'oIndex', 'Tools\DataDictionary\prg\oIndex.prg' )

			Else
				lcKey = Lower (  Alltrim( m.cName ))
				liIdx = This.GetKey ( m.lcKey )
				If Empty ( m.liIdx )
					loIndex = _NewObject ( 'oIndex', 'Tools\DataDictionary\prg\oIndex.prg' )
					loIndex.cTagName = Alltrim ( cName )
					This.AddIndex ( loIndex )

				Else
					loIndex = This.GetItem( m.liIdx )

				Endif && This.AddField( m.loField )

			Endif


		Catch To loErr
			DEBUG_CLASS_EXCEPTION, cName
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError = Null

		Endtry

		Return loIndex

	Endfunc && New

Enddefine && oColIndexes
