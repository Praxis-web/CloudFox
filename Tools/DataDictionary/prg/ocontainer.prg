#include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'
#Include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oBase.prg'
    Do 'ErrorHandler\prg\ErrorHandler.prg'
    Do 'Tools\DataDictionary\prg\oColControls.prg'

Endif

* oContainer
* Contenedor de controles
Define Class oContainer As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

    #If .F.
        Local This As oContainer Of 'Tools\DataDictionary\prg\oContainer.prg'
    #Endif

    Name = 'oContainer'

    Dimension oColControls_COMATTRIB[ 4 ]
    oColControls_COMATTRIB[ 1 ] = 0
    oColControls_COMATTRIB[ 2 ] = 'Colección de controles.'
    oColControls_COMATTRIB[ 3 ] = 'oColControls'
    oColControls_COMATTRIB[ 4 ] = 'oColControls'

    * Colección de controles.
    oColControls = Null

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="ocolcontrols" type="property" display="oColControls" />] ;
        + [<memberdata name="ocolcontrols_access" type="method" display="oColControls_Access" />] ;
        + [</VFPData>]

    * oColControls_Access
    Protected Function oColControls_Access() As oColControls Of 'Tools\DataDictionary\prg\oColControls.prg'

        Local loErr As Exception, ;
            loError As ErrorHandler Of 'ErrorHandler\prg\ErrorHandler.prg'

        Try

            If Vartype ( This.oColControls ) # 'O'
                * This.oColControls = Newobject ( 'oColControls', 'DataDictionary\prg\oColControls.prg' )
                This.oColControls = _Newobject ( 'oColControls', 'Tools\DataDictionary\prg\oColControls.prg' )

            Endif && Vartype( This.oColControls ) # 'O'

        Catch To loErr
            DEBUG_CLASS_EXCEPTION
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            m.loError.Process ( m.loErr )
            THROW_EXCEPTION

        Finally
            loError = Null

        Endtry

        Return This.oColControls

    Endfunc && oColControls_Access

Enddefine && oContainer