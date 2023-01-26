#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'

If .F.
    Do 'ErrorHandler\Prg\ErrorHandler.prg'
    Do 'Tools\DataDictionary\prg\oColBase.prg'
    Do 'Tools\DataDictionary\prg\oStoreProcedure.prg'

Endif

* oColStoreProcedures
* Colección de stored procedures de la base de datos.
Define Class oColStoreProcedures As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg' 

    #If .F.
        Local This As oColStoreProcedures Of 'Tools\DataDictionary\prg\oColStoreProcedures.prg'
    #Endif

    #If .F.
        TEXT
		 *:Help Documentation
		 *:Description:
		 Colección de stored procedures de la base de datos.
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

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="new" type="method" display="New" />] ;
        + [</VFPData>]

    Dimension New_COMATTRIB[ 5 ]
    New_COMATTRIB[ 1 ] = 0
    New_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oStoreProcedure.'
    New_COMATTRIB[ 3 ] = 'New'
    New_COMATTRIB[ 4 ] = 'oStoreProcedure'
    * New_COMATTRIB[ 5 ] = 0

    * New
    * Devuelve una nueva instancia de oStoreProcedure.
    Procedure New ( tcName As String, tcCodigo As String ) As oStoreProcedure Of 'Tools\DataDictionary\prg\oStoreProcedure.prg' HelpString 'Devuelve una nueva instancia de oStoreProcedure .'

        Local lcKey As String, ;
            liIdx As Integer, ;
            loErr As Exception, ;
            loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
            loStoreProcedure As oStoreProcedure Of 'Tools\DataDictionary\prg\oStoreProcedure.prg'

        #If .F.
            TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve una nueva instancia de oStoreProcedure .
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

            If ! Empty ( m.tcName )
                lcKey = Lower ( Justfname ( m.tcName ) )
                liIdx = This.GetKey ( m.lcKey )
                If Empty ( m.liIdx )
                    * loStoreProcedure           = Newobject ( 'oStoreProcedure', 'DataDictionary\prg\oStoreProcedure.prg' )
                    loStoreProcedure           = _Newobject ( 'oStoreProcedure', 'Tools\DataDictionary\prg\oStoreProcedure.prg' )
                    loStoreProcedure.oParent   = This
                    loStoreProcedure.cFileName = m.tcName
                    loStoreProcedure.cCodigo   = m.Logical.IfEmpty ( m.tcCodigo, '' )
                    This.AddItem ( m.loStoreProcedure, m.lcKey )

                Else && Empty ( m.liIdx )
                    loStoreProcedure = Null

                Endif && Empty( m.liIdx )

            Else && ! Empty ( m.tcName )
                loStoreProcedure = Null

            Endif && ! Empty( m.tcName )

        Catch To loErr
            DEBUG_CLASS_EXCEPTION, tcName, tcCodigo
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            m.loError.Process ( m.loErr )
            THROW_EXCEPTION

        Finally
            loError = Null

        Endtry

        Return m.loStoreProcedure

    Endproc && New

Enddefine && oColStoreProcedures