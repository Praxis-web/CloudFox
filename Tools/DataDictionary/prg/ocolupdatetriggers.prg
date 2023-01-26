#include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'
#Include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oColTriggers.prg'
    Do 'Tools\DataDictionary\prg\oTrigger.prg'
    Do 'Tools\DataDictionary\prg\oUpdateTrigger.prg'

Endif

* oColUpdateTriggers
* Colección de triggers del tipo update de la base de datos.
Define Class oColUpdateTriggers As oColTriggers Of 'Tools\DataDictionary\prg\oColTriggers.prg' 

    #If .F.
        Local This As oColUpdateTriggers Of 'Tools\DataDictionary\prg\oColUpdateTriggers.prg'
    #Endif

    #If .F.
        TEXT
		 *:Help Documentation
		 *:Description:
		 Colección de triggers del tipo update de la base de datos.
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

    cTriggerType = 'Update'

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>];
        + [<VFPData>] ;
        + [<memberdata name="ctriggertype" type="property" display="cTriggerType" />] ;
        + [<memberdata name="new" type="method" display="New" />] ;
        + [</VFPData>]

    Dimension m.New_COMATTRIB[ 5 ]
    New_COMATTRIB[ 1 ] = 0
    New_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oTrigger.'
    New_COMATTRIB[ 3 ] = 'New'
    New_COMATTRIB[ 4 ] = 'oTrigger'
    * New_COMATTRIB[ 5 ] = 0

    * New
    * Devuelve una nueva instancia de oTrigger.
    Function New ( tcName As String ) As oTrigger Of 'Tools\DataDictionary\prg\oTrigger.prg' HelpString 'Obtiene un elemento oTrigger vacío'

        Local loErr As Exception, ;
            loError As ErrorHandler Of 'ErrorHandler\prg\ErrorHandler.prg', ;
            loTrigger As oTrigger Of 'Tools\DataDictionary\prg\oTrigger.prg'

        Try

            loTrigger = _Newobject ( 'oUpdateTrigger', 'Tools\DataDictionary\prg\oUpdateTrigger.prg' )

            If ! Empty ( tcName )
                loTrigger.Name = Alltrim ( tcName  )
                This.AddTrigger ( loTrigger )

            Endif && ! Empty ( tcName )

        Catch To loErr
            DEBUG_CLASS_EXCEPTION, tcName
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            m.loError.Process ( m.loErr )
            THROW_EXCEPTION

        Finally

        Endtry

        Return loTrigger

    Endfunc && New

Enddefine  && oColUpdateTriggers