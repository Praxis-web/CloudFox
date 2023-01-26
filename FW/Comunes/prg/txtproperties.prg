#Include "FW\Comunes\Include\Praxis.h"

*!* ///////////////////////////////////////////////////////
*!* Class.........: TextProperties
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Recibe un objeto y devuelve las dimensiones del texto en función del font
*!* Date..........: Viernes 14 de Octubre de 2005 ( 10:39:58 )
*!* Author........: Ricardo Aidelman
*!* Project.......: Tabs v. 1.0
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class TextProperties As Session

    #If .F.
        Local This As TextProperties Of "Comun\Prg\TxtProperties.prg"
    #Endif

    *!* Ancho del texto en pixels
    nTxtwidth = 0

    *!* Alto del texto en pixels
    nTxtHeight = 0

    *!* Ancho promedio en pixels
    nAverageCharacterWidth = 0

    *!* El proceso no tuvo errores
    lIsOk = .T.

    *!* Objeto Exception
    oError = Null

    _MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name = "nTxtwidth" type = "property" display = "nTxtwidth" />] + ;
        [<memberdata name = "oerror" type = "property" display = "oError" />] + ;
        [<memberdata name = "lIsOk" type = "property" display = "lIsOk" />] + ;
        [<memberdata name = "process" type = "method" display = "Process" />] + ;
        [<memberdata name = "fontstyle" type = "method" display = "FontStyle" />] + ;
        [<memberdata name = "toObj" type = "property" display = "toObj" />] + ;
        [<memberdata name = "nTxtHeight" type = "property" display = "nTxtHeight" />] + ;
        [<memberdata name = "nAverageCharacterWidth" type = "property" display = "nAverageCharacterWidth" />] + ;
        [</VFPData>]


    *!* ///////////////////////////////////////////////////////
    *!* Function......: Process
    *!* Description...: Recibe un objeto y calcula el ancho y el alto necesarios
    *!* Date..........: Miércoles 30 de Noviembre de 2005 ( 19:53:57 )
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Comprobantes v. 1.0
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001 -
    *!*
    *!* tnExtraLen: Ancho extra ( en cantidad de caracteres )
    *!* tnExtraHeight = Alto extra ( en porcentaje )

    Function Process( toObj As Object, ;
            tnExtraLen As Integer, ;
            tnExtraHeight as Integer ) As Boolean;
            HELPSTRING "Recibe un objeto y calcula el ancho y el alto necesarios"

        Local lcText As String
        Local lcFontName As String
        Local lcFontStyle As String
        Local lnFontSize As Number
        Local lnLen As Number
        Local lnExtraHeight As Integer
        Local llValue As Boolean
        Local lcOldCentury As String
        Local lcOldCentury As String

        Try
            With This As TextProperties Of fw\comunes\prg\txtproperties.prg
                If Vartype( toObj ) # "O"
                    .lIsOk = .F.
                    Assert .lIsOk Message "Se esperaba un Objeto"

                Endif && Vartype( toObj ) # "O"
                
                If .lIsOk
                    *!* Validar propiedad
                    llValue = .F.
                    tnExtraLen = IfEmpty( tnExtraLen, 0 )
                    tnExtraHeight = IfEmpty( tnExtraHeight, 1 )

                    lnLen = 0

                    Do Case
                        Case Pemstatus( toObj, "Caption", 5 ) And ! Empty( toObj.Caption )
                            lcText = toObj.Caption

                        Case Pemstatus( toObj, "InputMask", 5 ) And ! Empty( toObj.InputMask )
                        	
                        	lcText = toObj.InputMask 
*!*	                            lnLen = Len( toObj.InputMask )
*!*	                            lcText = Replicate( "X", lnLen )

                        Case Pemstatus( toObj, "nLength", 5 ) And ! Empty( toObj.nLength )
                            lnLen = toObj.nLength
                            lcText = Replicate( "X", lnLen )

                        Case Pemstatus( toObj, "MaxLength", 5 ) And ! Empty( toObj.MaxLength )
                            lnLen = toObj.MaxLength
                            lcText = Replicate( "X", lnLen )

                        Case Pemstatus( toObj, "Value", 5 )
                            llValue = .T.
                            Do Case
                                Case Vartype( toObj.Value ) == "C"
                                    lcText = toObj.Value

                                Case Vartype( toObj.Value ) == "D"
                                    lcOldCentury = "SET CENTURY " + Set( "Century" )
                                    Do Case
                                        Case toObj.Century = 0
                                            Set Century Off

                                        Case toObj.Century = 1
                                            Set Century On

                                    Endcase
                                    lcText = Dtoc( toObj.Value )
                                    &lcOldCentury

                                Case Vartype( toObj.Value ) == "T"
                                    lcOldCentury = "SET CENTURY " + Set( "Century" )
                                    Do Case
                                        Case toObj.Century = 0
                                            Set Century Off

                                        Case toObj.Century = 1
                                            Set Century On

                                    Endcase
                                    lcText = Ttoc( toObj.Value )
                                    &lcOldCentury

                                Otherwise
                                    This.lIsOk = .F.
                                    Assert .lIsOk Message "La propiedad VALUE no es de un tipo valido"

                            Endcase
                        Otherwise
                            *!* Fuerza un error para que lo atrape el Catch
                            Error "No es posible calcular las dimensiones del control " + toObj.Name

                    Endcase

                    If .lIsOk
                        lcFontName = toObj.FontName
                        lnFontSize = toObj.FontSize
                        lcFontStyle = .FontStyle( toObj )

                        lnLen = Max( Txtwidth( lcText, ;
                            lcFontName, ;
                            lnFontSize, ;
                            lcFontStyle ), lnLen )

                        .nAverageCharacterWidth = Fontmetric( TM_AVECHARWIDTH, ;
                            lcFontName, ;
                            lnFontSize, ;
                            lcFontStyle ) && * 1.1

                        .nTxtwidth = Ceiling( .nAverageCharacterWidth * ( lnLen + tnExtraLen ) )

                        .nTxtHeight = Ceiling( Fontmetric( TM_HEIGHT, ;
                            lcFontName, ;
                            lnFontSize, ;
                            lcFontStyle ) * tnExtraHeight )

                    Endif

                    toObj.Height = .nTxtHeight
                    toObj.Width = .nTxtwidth

                Endif
            Endwith
        Catch To oErr
            This.lIsOk = .F.
            This.oError = oErr
        Finally
            toObj = .F.
        Endtry

        Return This.lIsOk

    Endfunc && Process

    *!* ///////////////////////////////////////////////////////
    *!* Function......: FontStyle
    *!* Description...: Devuelve un juego de caracteres que representa el Estilo de la Fuente
    *!* Date..........: Viernes 14 de Octubre de 2005 ( 10:54:15 )
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Tabs v. 1.0
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001 -
    *!*
    *!*

    Function FontStyle( toRef As Object ) As String;
            HELPSTRING "Devuelve un juego de caracteres que representa el Estilo de la Fuente"

        Local lcFontStyle As String

        lcFontStyle = Space( 0 )
        If Type( "toRef.FontBold" ) = "L" And toRef.FontBold
            lcFontStyle = lcFontStyle + FS_BOLD

        Endif && Type( "toRef.FontBold" ) = "L" And toRef.FontBold

        If Type( "toRef.FontItalic" ) = "L" And toRef.FontItalic
            lcFontStyle = lcFontStyle + FS_ITALIC

        Endif && Type( "toRef.FontItalic" ) = "L" And toRef.FontItalic

        If Type( "toRef.FontStrikeThru" ) = "L" And toRef.FontStrikethru
            lcFontStyle = lcFontStyle + FS_STRIKEOUT

        Endif && Type( "toRef.FontStrikeThru" ) = "L" And toRef.FontStrikethru

        If Type( "toRef.FontUnderline" ) = "L" And toRef.FontUnderline
            lcFontStyle = lcFontStyle + FS_UNDERLINE

        Endif && Type( "toRef.FontUnderline" ) = "L" And toRef.FontUnderline

        If Empty( lcFontStyle )
            lcFontStyle = FS_NORMAL

        Endif && Empty( lcFontStyle )

        Return lcFontStyle

    Endfunc && FontStyle

Enddefine && TextProperties
