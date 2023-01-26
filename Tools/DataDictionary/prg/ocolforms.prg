#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oForm.prg'
    Do 'Tools\DataDictionary\prg\oColBase.prg'
    Do 'ErrorHandler\Prg\ErrorHandler.prg'

Endif

* oColForms
* Colección de formularios.
Define Class oColForms As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg' 

    #If .F.
        Local This As oColForms Of 'Tools\DataDictionary\prg\oColForms.prg'
    #Endif

    #If .F.
        TEXT
			 *:Help Documentation
			 *:Description:
			 Colección de formularios.
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
    New_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oForm.'
    New_COMATTRIB[ 3 ] = 'New'
    New_COMATTRIB[ 4 ] = 'oForm'
    * New_COMATTRIB[ 5 ] = 0

    * New
    * Devuelve una nueva instancia de oForm.
    Function New ( tcName As String, tcKeyName As String ) As oForm Of 'Tools\DataDictionary\prg\oForm.prg' HelpString 'Devuelve una nueva instancia de oForm .'

        Local lcKey As String, ;
            liIdx As Integer, ;
            loErr As Exception, ;
            loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg', ;
            loForm As oForm Of 'Tools\DataDictionary\prg\oForm.prg'

        #If .F.
            TEXT
			 *:Help Documentation
			 *:Description:
			 Devuelve una nueva instancia de oForm.
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

            With This
                If ! Empty ( m.tcName )
                    lcKey = Lower ( Justfname ( m.tcName ) )
                    liIdx = This.GetKey ( m.lcKey )

                    If Empty ( m.liIdx )
                        loForm         = _NewObject ( 'oForm', 'Tools\DataDictionary\prg\oForm.prg' )
                        loForm.oParent = .oParent
                        This.AddItem ( m.loForm, m.lcKey )
                        If Empty ( m.tcKeyName )
                            tcKeyName = m.tcName

                        Endif && Empty( m.tcKeyName )

                        loForm.Name     = tcName
                        loForm.cKeyName = tcKeyName

                    Else && Empty(m.liIdx )
                        Error 'Ya existe el Formulario ' + m.tcName

                    Endif && Empty(m.liIdx )

                Else && ! Empty ( m.tcName )
                    Error 'Falta definir el nombre del Formulario'

                Endif && ! Empty( m.tcName )

            Endwith

        Catch To loErr
            DEBUG_CLASS_EXCEPTION, tcName, tcKeyName
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            m.loError.Process ( m.loErr )
            THROW_EXCEPTION

        Finally
            loError = Null

        Endtry

        Return m.loForm

    Endfunc && New

Enddefine && oColForms