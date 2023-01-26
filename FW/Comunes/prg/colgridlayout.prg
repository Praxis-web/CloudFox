*!* ///////////////////////////////////////////////////////
*!* Class.........: colGridLayout
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Colección de objetos que permiten personalizar el GRID
*!* Date..........: Viernes 6 de Julio de 2007 (14:01:17)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#INCLUDE "Fw\comunes\Include\Praxis.h"
#INCLUDE "FW\TierAdapter\Include\TA.h"


Define Class colGridLayout As PrxCollection Of "FW\Comunes\Prg\PrxBaseLibrary.prg"

    #If .F.
        Local This As colGridLayout Of "FW\Comunes\Prg\colGridLayout.prg"
    #Endif


    cClassName 			= "oGridLayout"
    cClassLibrary 		= "colGridLayout.prg"
    cClassLibraryFolder = FL_SOURCE

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="newfromfield" type="method" display="NewFromField" />] + ;
        [</VFPData>]

    Procedure Init()
        Local lcCommand As String

        Try

            lcCommand = ""
            *!*				loApp 					= NewApp()
            *!*				This.lUseNameSpaces 	= loApp.lUseNameSpaces

            * RA 2014-08-29(17:37:45)
            * Fuerzo a utilizar la nueva version
            * Si algo falla, volver para atras
            This.lUseNameSpaces	= .T.

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cRemark = lcCommand
            loError.Process( oErr )
            Throw loError

        Finally
            loApp = Null

        Endtry


        Return .T.
    Endproc



    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: NewFromField
    *!* Description...: Crea un nuevo elemento desde un oField
    *!* Date..........: Viernes 17 de Julio de 2009 (12:16:00)
    *!* Author........: Damian Eiff
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure NewFromField( toField,;
            tcName As String, ;
            tcBefore As String,;
            tlIsReference As Boolean,;
            lStr As Boolean ) As oColGridLayout;
            HELPSTRING "Crea un nuevo elemento desde un oField"

        Local loGridLayout As oGridLayout Of "Fw\Comunes\Prg\colGridLayout.prg"
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
        Local lnLength As Integer
        Local lcFieldType As String

        Local lcCommand As String

        Try

            lcCommand = ""
           
            loField = toField
            
            Do Case
            Case !Empty( loField.cGridColumnControlSource )
				tcName = loField.cGridColumnControlSource 
				
            Case lStr And loField.lStr
                tcName = "Str_" + tcName

            EndCase

            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )


            loError.cTraceLogin = 'Creando nuevo tcName: ' + Transform( tcName ) + ' tcBefore: ' + Transform( tcBefore )
            loGridLayout = This.New( tcName, tcBefore )
            loGridLayout.oField = loField
            loGridLayout.HeaderCaption = Iif( tlIsReference, loField.cReferenceCaption, loField.cHeaderCaption )

            loGridLayout.ColumnControlSource = tcName

            If !Empty( loField.oCurrentControl.Name )
                loGridLayout.oCurrentControl = loField.oCurrentControl
            Endif

            lcFieldType = Upper( loField.cFieldType )
            
            If loField.nGridAlignment = -1
            	loField.nGridAlignment = loField.nAlignment 
            EndIf 
            
            If loField.nGridAlignment = -1

                Do Case
                    Case Inlist( lcFieldType, "C", "V" )
                        loGridLayout.ColumnAlignment = ALIGN_LEFT

                    Case Inlist( lcFieldType, ;
                            "Y", ;
                            "F", ;
                            "B",;
                            "N" )
                        loGridLayout.ColumnAlignment = ALIGN_RIGHT

                    Case Inlist( lcFieldType, "D", "T" )
                        loGridLayout.ColumnAlignment = ALIGN_RIGHT

                    Case lcFieldType = "I"
                        If loField.lIsLogical
                            loGridLayout.ColumnAlignment = ALIGN_CENTER

                        Else
                            loGridLayout.ColumnAlignment = ALIGN_RIGHT

                        Endif

                    Case lcFieldType = "L"
                        loGridLayout.ColumnAlignment = ALIGN_CENTER

                    Otherwise
                        loGridLayout.ColumnAlignment = ALIGN_LEFT

                Endcase

            Else
                loGridLayout.ColumnAlignment = loField.nGridAlignment

            Endif

            lnLength = loField.nLength
            loGridLayout.lOrderByThis = loField.lOrderByThis

            If lcFieldType == "C" And !Empty( loField.nGridMaxLength )
                loGridLayout.nLength = Min( loField.nFieldWidth, loField.nGridMaxLength )

            Else
                loGridLayout.nLength = loField.nLength

            Endif

            If Empty( loGridLayout.nLength )

                Do Case
                    Case lcFieldType == "W"


                    Case lcFieldType == "C"
                        lnLength = loField.nFieldWidth

                    Case lcFieldType == "Y"
                        lnLength = Max( loField.nFieldWidth, Len( loField.cInputMask ) )

                    Case lcFieldType == "T"

                    Case lcFieldType == "D"

                    Case lcFieldType == "B"
                        lnLength = Max( loField.nFieldWidth, Len( loField.cInputMask ) )

                    Case lcFieldType == "G"

                    Case lcFieldType == "I"

                    Case lcFieldType == "L"

                    Case lcFieldType == "M"

                    Case lcFieldType == "N"
                        lnLength = Max( loField.nFieldWidth, Len( loField.cInputMask ) )

                    Case lcFieldType == "F"
                        lnLength = Max( loField.nFieldWidth, Len( loField.cInputMask ) )

                    Case lcFieldType == "Q"

                    Case lcFieldType == "V"
                        lnLength = loField.nFieldWidth

                    Otherwise

                Endcase

                loGridLayout.nLength = Max( lnLength, Len( loGridLayout.HeaderCaption ) )

            Endif

            loGridLayout.ColumnFormat 		= loField.cFormat
            loGridLayout.ColumnInputMask 	= loField.cInputMask
            loGridLayout.ColumnColumnOrder 	= loField.nGridOrder



        Catch To oErr

            If Vartype( loError ) # 'O'
                loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            Endif
            * DAE 2009-11-06(20:28:00)
            * loError = This.oError
            loError.Process( oErr )
            Throw loError

        Finally
            *!*	loError = This.oError
            *!*	loError.Remark = ''
            *!*	loError.TraceLogin = ''
            loError = Null

        Endtry

        Return loGridLayout

    Endproc && NewFromField

Enddefine && colGridLayout

*!* ///////////////////////////////////////////////////////
*!* Class.........: oGridLayout
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Objeto oGridLayout
*!* Date..........: Viernes 6 de Julio de 2007 (14:35:57)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

* Define Class oGridLayout As prxSession Of FW\Tieradapter\Comun\prxbaselibrary.prg
Define Class oGridLayout As prxCustom Of FW\Tieradapter\Comun\prxbaselibrary.prg

    #If .F.
        Local This As oGridLayout Of "Fw\comunes\Prg\colGridLayout.Prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="headeralignment" type="property" display="HeaderAlignment " />] + ;
        [<memberdata name="headerbackcolor" type="property" display="HeaderBackColor " />] + ;
        [<memberdata name="headercaption" type="property" display="HeaderCaption " />] + ;
        [<memberdata name="headerfontbold" type="property" display="HeaderFontBold" />] + ;
        [<memberdata name="headerfontitalic" type="property" display="HeaderFontItalic " />] + ;
        [<memberdata name="headerfontunderline" type="property" display="HeaderFontUnderline " />] + ;
        [<memberdata name="headerforecolor" type="property" display="HeaderForeColor " />] + ;
        [<memberdata name="headermouseicon" type="property" display="HeaderMouseIcon " />] + ;
        [<memberdata name="headermousepointer" type="property" display="HeaderMousePointer " />] + ;
        [<memberdata name="headerpicture" type="property" display="HeaderPicture " />] + ;
        [<memberdata name="headerstatusbartext" type="property" display="HeaderStatusBarText " />] + ;
        [<memberdata name="headertooltiptext" type="property" display="HeaderToolTipText " />] + ;
        [<memberdata name="headerwordwrap" type="property" display="HeaderWordWrap " />] + ;
        [<memberdata name="columnalignment" type="property" display="ColumnAlignment " />] + ;
        [<memberdata name="columnbackcolor" type="property" display="ColumnBackColor " />] + ;
        [<memberdata name="columnformat" type="property" display="ColumnFormat " />] + ;
        [<memberdata name="columninputmask" type="property" display="ColumnInputMask " />] + ;
        [<memberdata name="columnsparse" type="property" display="ColumnSparse " />] + ;
        [<memberdata name="columnstatusbartext" type="property" display="ColumnStatusBarText " />] + ;
        [<memberdata name="columnwidth" type="property" display="ColumnWidth " />] + ;
        [<memberdata name="columncontrolsource" type="property" display="ColumnControlSource " />] + ;
        [<memberdata name="columnname" type="property" display="ColumnName" />] + ;
        [<memberdata name="columnvisible" type="property" display="ColumnVisible" />] + ;
        [<memberdata name="lfitcolumn" type="property" display="lFitColumn" />] + ;
        [<memberdata name="nLength" type="property" display="nLength" />] + ;
        [<memberdata name="nLength_assign" type="method" display="nLength_Assign" />] + ;
        [<memberdata name="ocurrentcontrol" type="property" display="oCurrentControl" />] + ;
        [<memberdata name="columndynamicinputmask" type="property" display="ColumnDynamicInputMask " />] + ;
        [<memberdata name="columndynamicforecolor" type="property" display="ColumnDynamicForeColor " />] + ;
        [<memberdata name="columndynamicfontunderline" type="property" display="ColumnDynamicFontUnderline " />] + ;
        [<memberdata name="columndynamicfontstrikethru" type="property" display="ColumnDynamicFontStrikethru " />] + ;
        [<memberdata name="columndynamicfontsize" type="property" display="ColumnDynamicFontSize " />] + ;
        [<memberdata name="columndynamicfontname" type="property" display="ColumnDynamicFontName " />] + ;
        [<memberdata name="columndynamicfontitalic" type="property" display="ColumnDynamicFontItalic " />] + ;
        [<memberdata name="columndynamicfontbold" type="property" display="ColumnDynamicFontBold " />] + ;
        [<memberdata name="columndynamicbackcolor" type="property" display="ColumnDynamicBackColor" />] + ;
        [<memberdata name="columndynamicalignment" type="property" display="ColumnDynamicAlignment " />] + ;
        [<memberdata name="columnforecolor" type="property" display="ColumnForeColor " />] + ;
        [<memberdata name="columnfontunderline" type="property" display="ColumnFontUnderline " />] + ;
        [<memberdata name="columnfontstrikethru" type="property" display="ColumnFontStrikethru " />] + ;
        [<memberdata name="columnfontsize" type="property" display="ColumnFontSize " />] + ;
        [<memberdata name="columnfontname" type="property" display="ColumnFontName " />] + ;
        [<memberdata name="columnfontitalic" type="property" display="ColumnFontItalic " />] + ;
        [<memberdata name="columnfontbold" type="property" display="ColumnFontBold " />] + ;
        [<memberdata name="columnenabled" type="property" display="ColumnEnabled " />] + ;
        [<memberdata name="columntooltiptext" type="property" display="ColumnToolTipText " />] + ;
        [<memberdata name="columnresizable" type="property" display="ColumnResizable " />] + ;
        [<memberdata name="columncindexexpression" type="property" display="ColumncIndexExpression" />] + ;
        [<memberdata name="lorderbythis" type="property" display="lOrderByThis" />] + ;
        [<memberdata name="isnumeric" type="property" display="IsNumeric" />] + ;
        [<memberdata name="cFieldName" type="property" display="cFieldName" />] + ;
        [<memberdata name="cFieldName_access" type="method" display="cFieldName_Access" />] + ;
        [<memberdata name="ofield" type="property" display="oField" />] + ;
        [<memberdata name="destroy" type="method" display="Destroy" />] + ;
        [<memberdata name="columnreadonly" type="property" display="ColumnReadOnly" />] + ;
        [<memberdata name="columncolumnorder" type="property" display="ColumnColumnOrder" />] + ;
        [<memberdata name="columnmovable" type="property" display="ColumnMovable" />] + ;
        [</VFPData>]


    * Indica si el campo caracter se muestra como numérico
    IsNumeric = .F.

    * Nombre del Campo
    cFieldName = ""

    lFitColumn = .F.

    HeaderAlignment  = 2
    HeaderBackColor = Rgb(236,233,216)
    HeaderCaption  = "Header"
    HeaderFontBold = .F.
    HeaderFontItalic = .F.
    HeaderFontUnderline = .F.
    HeaderForeColor = Rgb( 0,0,0 )
    HeaderMouseIcon = ""
    HeaderMousePointer = 0
    HeaderPicture = ""
    HeaderStatusBarText = ""
    HeaderToolTipText = ""
    HeaderWordWrap = .F.

    ColumnAlignment = 0
    ColumnBackColor = Rgb(255,255,255)
    ColumnControlSource  = ""
    oCurrentControl = Null
    ColumnDynamicAlignment = ""
    ColumnDynamicBackColor = ""
    ColumnDynamicFontBold = ""
    ColumnDynamicFontItalic = ""
    ColumnDynamicFontName = ""
    ColumnDynamicFontSize = ""
    ColumnDynamicFontStrikethru = ""
    ColumnDynamicFontUnderline = ""
    ColumnDynamicForeColor = ""
    ColumnDynamicInputMask = ""
    ColumnEnabled = .T.
    ColumnFontBold = .F.
    ColumnFontItalic = .F.
    ColumnFontName = "Arial"

    * ColumnFontSize = 9
    ColumnFontSize = Iif( Vartype( _Screen.oApp ) == "O", 9 + _Screen.oApp.nUpdateFontSize, 9 )

    ColumnFontStrikethru = .F.
    ColumnFontUnderline = .F.
    ColumnForeColor = Rgb( 0, 0, 0 )
    ColumnFormat = ""
    ColumnInputMask = ""
    ColumnName = "Column"
    ColumnResizable = .T.
    ColumnMovable = .T.
    ColumnSparse = .T.
    ColumnStatusBarText = ""
    ColumnToolTipText = ""
    ColumnVisible = .T.
    ColumnWidth = 0
    ColumnReadOnly = .F.
    ColumnColumnOrder = 0

    * Expresión de indice por el que se ordena la columna
    ColumncIndexExpression = ""


    Width = 0
    Height = 0

    DataSession = SET_DEFAULT

    *!* Longitud del ancho de la columna expresado en caracteres
    nLength = 20

    *!* Indica si la grilla se mostrará ordenada por ésta columna
    lOrderByThis = .F.

    *!* Referencia al Field
    oField = Null

    Procedure Init()

        This.ColumnDynamicBackColor = TA_DynamicBackColor

        Return DoDefault()

    Endproc


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: nLength_Assign
    *!* Date..........: Miércoles 7 de Noviembre de 2007 (19:30:40)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure nLength_Assign( uNewValue )

        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
        Local loLbl As Label
        Local lnExtraLen As Integer
        Local lnExtraHeight As Integer
        Local loTP As Object
        Local loTxt As TextBox


        Try

            *!*				Assert ! Empty( uNewValue ) Message "Falta asignar el valor de nLength"

            This.nLength = uNewValue

            If !Empty( uNewValue )

                loTxt = Createobject( "TextBox" )

                *loTxt.InputMask = This.ColumnInputMask
                loTxt.InputMask = Replicate( "X", This.nLength )

                *!*					If Empty( loTxt.InputMask )
                *!*						loTxt.InputMask = Replicate( "X", This.nLength )
                *!*					Endif

                loTxt.Alignment = This.ColumnAlignment
                *!*					loTxt.FontBold =  .T. && This.ColumnFontBold
                loTxt.FontBold =  This.ColumnFontBold
                loTxt.FontItalic = This.ColumnFontItalic
                loTxt.FontName = This.ColumnFontName
                loTxt.FontSize = This.ColumnFontSize

                loTP = Newobject( "TextProperties", "txtProperties.prg" )

                lnExtraLen = 1.2 && 2
                lnExtraHeight = 1.2

                If !loTP.Process( loTxt, lnExtraLen, lnExtraHeight )
                    loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
                    * loError = This.oError
                    loError.Process( loTP.oError )

                Endif

                This.ColumnWidth = loTxt.Width
                This.Height = loTxt.Height

            Endif


        Catch To oErr
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            * DAE 2009-11-06(17:17:47)
            * loError = This.oError
            loError.Process( oErr )
            Throw loError

        Finally
            loLbl = Null
            loTP = Null
            loTxt = Null
            loError = Null

        Endtry

    Endproc && nLength_Assign

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: cFieldName_Access
    *!* Date..........: Viernes 6 de Febrero de 2009 (16:50:32)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure cFieldName_Access()
        With This As oGridLayout Of FW\comunes\prg\colGridLayout.prg
            If Empty( .cFieldName )
                .cFieldName = .ColumnControlSource

            Endif

        Endwith

        Return This.cFieldName

    Endproc && cFieldName_Access

    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: Name_Assign
    *!* Date..........: Viernes 6 de Febrero de 2009 (18:03:36)
    *!* Author........: Ricardo Aidelman
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure Name_Assign( uNewValue )

        This.Name = uNewValue
        This.ColumnName = uNewValue

    Endproc && Name_Assign


    *!* ///////////////////////////////////////////////////////
    *!* Procedure.....: Destroy
    *!* Description...:
    *!* Date..........: Viernes 17 de Julio de 2009 (12:11:56)
    *!* Author........: Damian Eiff
    *!* Project.......: Sistemas Praxis
    *!* -------------------------------------------------------
    *!* Modification Summary
    *!* R/0001  -
    *!*
    *!*

    Procedure Destroy(  ) As Void

        This.oField = Null
        DoDefault()

    Endproc &&  Destroy


Enddefine && oGridLayout
