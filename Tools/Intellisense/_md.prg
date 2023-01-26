Lparameters oFoxcode As Object

Local lcRet As String
Local lcName As String
Local lcDisplay As String
Local lcType As String
Local llOk As Boolean
Local lcText As String
Local lcInitialValue As String
Local lcDescription As String
Local lcAccessMethod As String
Local lcAssignMethod As String

#Define CR Chr( 13 )

If oFoxcode.Location #1
    Return '_MD'
Endif

oFoxcode.valuetype = 'V'

Set Path To "v:\Praxis\Comun\prg\" Additive

lcName = Inputbox( "Nombre del miembro", "_MemberData" )
lcDisplay = Proper( lcName )
lcName = Lower( Strtran( lcName, " ", "" ) )

If Len( Getwordnum( lcDisplay, 1 ) ) = 1
    lcDisplay = Substr( lcName, 1, 1 ) + Substr( lcDisplay, 2 )
Endif

lcDisplay = Strtran( lcDisplay, " ", "" )

llOk = .F.
lcText = "P = PROPIEDAD" + CR ;
    + "E = EVENTO" + CR ;
    + "M = METODO"

Do While ! llOk
    Wait lcText Window Nowait Noreset

    lcType = Inputbox( "Type", "_MemberData" )
    lcType = Lower( Left( Trim( lcType ), 1 ) )
    llOk = .T.
    Do Case
        Case lcType = 'p'
            lcType = 'property'
        Case lcType = 'e'
            lcType = 'event'
        Case lcType = 'm' 
            lcType = 'method'
        Otherwise
            llOk = .F.
    Endcase
    If ! llOk
        = Messagebox( lcText, 16 )
    Endif
Enddo

lcDisplay = Inputbox( "Display", "_MemberData", lcDisplay )

If lcType = "property"
    lcInitialValue = Inputbox( "Valor Inicial", "_MemberData" )
    lcDescription = Inputbox( "Descripción", "_MemberData" )
    lcText = "T = TRUE" + CR + ;
        "F = FALSE" + CR

    llOk = .F.
    Do While !llOk

        Wait lcText Window Nowait

        lcAccessMethod = Inputbox( "Tiene Método Access", "_MemberData" )
        lcAccessMethod = Lower( Substr( lcAccessMethod , 1, 1 ) )
        llOk = .T.

        Do Case
            Case "t" = lcAccessMethod

            Case "f" = lcAccessMethod

            Case Empty( lcAccessMethod )
                lcAccessMethod = "f"

            Otherwise
                llOk = .F.

        Endcase

        If !llOk
            = Messagebox( lcText, 16 )
        Endif

    Enddo

    llOk = .F.
    Do While !llOk

        Wait lcText Window Nowait

        lcAssignMethod = Inputbox( "Tiene Método Assign", "_MemberData" )
        lcAssignMethod = Lower( Substr( lcAssignMethod , 1, 1 ) )
        llOk = .T.

        Do Case
            Case "t" = lcAssignMethod

            Case "f" = lcAssignMethod

            Case Empty( lcAssignMethod )
                lcAssignMethod = "f"

            Otherwise
                llOk = .F.

        Endcase

        If ! llOk
            = Messagebox( lcText, 16 )
        Endif
    Enddo

    TEXT TO myvar TEXTMERGE NOSHOW
* <<lcDescription>>
<<lcDisplay>> = <<lcInitialValue>>
* [<memberdata name = "<<lcName>>" type = "<<lcType>>" display = "<<lcDisplay>>" />] + ;
    ENDTEXT
    If lcAccessMethod = "t"
        TEXT To lcAccessMethod NoShow TextMerge
* [<memberdata name = "<<lcName>>_access" type = "method" display = "<<lcDisplay>>_Access" />] + ;

*
* <<lcDisplay>>_Access
Protected Procedure <<lcDisplay>>_Access( )
 Return This.<<lcDisplay>>
EndProc && <<lcDisplay>>_Access
        ENDTEXT
        lcAccessMethod = CR + CR + lcAccessMethod
    Else
        lcAccessMethod = ""
    Endif

    If lcAssignMethod = "t"
        TEXT To lcAssignMethod NoShow TextMerge
* [<memberdata name = "<<lcName>>_assign" type = "method" display = "<<lcDisplay>>_Assign" />] + ;
* <<lcDisplay>>_Assign
Protected Procedure <<lcDisplay>>_Assign( uNewValue )
 This.<<lcDisplay>> = uNewValue
EndProc && <<lcDisplay>>_Assign
        ENDTEXT
        lcAssignMethod = CR + CR + lcAssignMethod
    Else
        lcAssignMethod = ''
    Endif
    myvar = myvar + lcAccessMethod + lcAssignMethod

Else
    TEXT TO myvar TEXTMERGE NOSHOW
 [<memberdata name = "<<lcName>>" type = "<<lcType>>" display = "<<lcDisplay>>" />] + ;
    ENDTEXT
Endif

Return myvar
