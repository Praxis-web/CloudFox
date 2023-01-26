#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oColBase.prg'
    Do 'Tools\DataDictionary\prg\oTrigger.prg'
    Do 'ErrorHandler\Prg\ErrorHandler.prg'

Endif

* oColTriggers
* Colección de triggers de la base de datos.
Define Class oColTriggers As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg' 

    #If .F.
        Local This As oColTriggers Of 'Tools\DataDictionary\prg\oColTriggers.prg'
    #Endif

    #If .F.
        TEXT
		 *:Help Documentation
		 *:Description:
		 Colección de triggers de la base de datos.
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

    * Nombre de la tabla
    cTableName = ''

    * Nombre del SP de Integridad Referencial que se creará
    IrName = ''

    * Tipo de Trigger
    cTriggerType = ''

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>];
        + [<VFPData>] ;
        + [<memberdata name="ctriggertype" type="property" display="cTriggerType" />] ;
        + [<memberdata name="irname" type="property" display="IrName" />] ;
        + [<memberdata name="ctablename" type="property" display="cTableName" />] ;
        + [<memberdata name="addtrigger" type="method" display="AddTrigger" />] ;
        + [<memberdata name="new" type="method" display="New" />] ;
        + [</VFPData>]

    Dimension AddTrigger_COMATTRIB[ 5 ]
    AddTrigger_COMATTRIB[ 1 ] = 0
    AddTrigger_COMATTRIB[ 2 ] = 'Agrega un Trigger a la colección.'
    AddTrigger_COMATTRIB[ 3 ] = 'AddTrigger'
    AddTrigger_COMATTRIB[ 4 ] = 'Void'
    * AddTrigger_COMATTRIB[ 5 ] = 0

    * AddTrigger
    * Agrega un Trigger a la colección.
    Procedure AddTrigger ( toTrigger As oTrigger Of 'Tools\DataDictionary\prg\oTrigger.prg' ) As Void HelpString 'Agrega un Trigger a la colección.'

        Local lcKey As String, ;
            liIdx As Integer, ;
            loErr As Exception, ;
            loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

        #If .F.
            TEXT
			 *:Help Documentation
			 *:Description:
			 Agrega un Trigger a la colección.
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

            toTrigger.oParent = This.oParent
            lcKey             = Lower ( toTrigger.Name )
            liIdx             = This.GetKey ( lcKey )

            If Empty ( liIdx )
                This.AddItem ( toTrigger, lcKey )

            Endif && Empty ( liIdx )

        Catch To loErr
            DEBUG_CLASS_EXCEPTION, toTrigger
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loErr.Message = loErr.Message + CR + Lower ( toTrigger.Name )
            m.loError.Process ( m.loErr )
            THROW_EXCEPTION

        Finally
            loError = Null

        Endtry

    Endproc && AddTrigger

    Dimension New_COMATTRIB[ 5 ]
    New_COMATTRIB[ 1 ] = 0
    New_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oTrigger.'
    New_COMATTRIB[ 3 ] = 'New'
    New_COMATTRIB[ 4 ] = 'oTrigger'
    * New_COMATTRIB[ 5 ] = 0

    * New
    * Devuelve una nueva instancia de oTrigger.
    Function New () As oTrigger Of 'Tools\DataDictionary\prg\oTrigger.prg' HelpString 'Devuelve una nueva instancia de oTrigger.'
        Return Null

    Endfunc && New

Enddefine  && oColTriggers