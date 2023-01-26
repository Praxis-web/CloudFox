#Include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'

If .F.
    Do 'Tools\DataDictionary\prg\oBase.prg'

Endif

* oControl
* Clase que representa un control
Define Class oControl As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

    #If .F.
        Local This As oControl Of 'Tools\DataDictionary\prg\oControl.prg'
    #Endif

    oField = Null

    oTable = Null

    Name = 'oControl'

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="ofield" type="property" display="oField" />] ;
        + [<memberdata name="otable" type="property" display="oTable" />] ;
        + [</VFPData>]

    * This_Access
    Protected Function This_Access ( tcMemberName As String ) As Object

        Local loRet As Object

        llIsMember = Pemstatus ( This, m.tcMemberName, 5 )
        If ! llIsMember
            loField = This.oField
            If ! llIsMember And Vartype ( loField ) == 'O' And Pemstatus ( loField, m.tcMemberName, 5 )
                loRet = loField

            Else
                loTable = This.oTable
                If ! llIsMember And Vartype ( loTable ) == 'O' And Pemstatus ( loTable, m.tcMemberName, 5 )
                    loRet = loTable

                Else
                    loRet = This

                Endif

            Endif

        Else
            loRet = This

        Endif

        Return loRet

    Endfunc && This_Access

Enddefine && oControl