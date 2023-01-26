#include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'
#Include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oColBase.prg'
    Do 'ErrorHandler\prg\ErrorHandler.prg'
    Do 'Tools\DataDictionary\prg\oProperty.prg'

Endif

* oColProperties
* Colección de propiedades.
Define Class oColProperties As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg' 

    #If .F.
        Local This As oColProperties Of 'Tools\DataDictionary\prg\oColProperties.prg'
    #Endif

    #If .F.
        TEXT
		 *:Help Documentation
		 *:Description:
		 Colección de propiedades.
		 *:Project:
		 Sistemas Praxis
		 *:Autor:
		 Damian Eiff
		 *:Date:
		 Martes 10 de Febrero de 2009 (11:00:34)
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

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="new" type="method" display="New" />] ;
        + [</VFPData>]

    Dimension m.New_COMATTRIB[ 5 ]
    New_COMATTRIB[ 1 ] = 0
    New_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oProperty.'
    New_COMATTRIB[ 3 ] = 'New'
    New_COMATTRIB[ 4 ] = 'oProperty'
    * New_COMATTRIB[ 5 ] = 0

    * New
    * Devuelve una nueva instancia de oProperty.
    Function New ( tcName As String ) As oProperty Of 'Tools\DataDictionary\prg\oProperty.prg' HelpString 'Devuelve una nueva instancia de oProperty.'

        Local liIdx As Integer, ;
            loErr As Object, ;
            loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
            loObj As oProperty Of DataDictionary\prg\oProperty.prg

        #If .F.
            TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve una nueva instancia de oProperty.
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damian Eiff
				 *:Date:
				 Martes 10 de Febrero de 2009 (11:13:53)
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

            liIdx = This.GetKey ( m.tcName )
            If Empty ( m.liIdx )
                * loObj      = Newobject ( 'oProperty', 'DataDictionary\prg\oProperty.prg' )
                loObj      = _Newobject ( 'oProperty', 'Tools\DataDictionary\prg\oProperty.prg' )
                loObj.Name = m.tcName
                This.AddItem ( m.loObj, m.tcName )

            Endif &&  Empty( m.liIdx )

        Catch To loErr
            DEBUG_CLASS_EXCEPTION, tcName
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            m.loError.Process ( m.loErr )
            THROW_EXCEPTION

        Finally
            loError = Null

        Endtry

        Return m.loObj

    Endfunc && New

Enddefine && oColProperties