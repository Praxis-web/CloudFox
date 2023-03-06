*!* ///////////////////////////////////////////////////////
*!* Class.........: ControlesBase
*!* Description...:
*!* Date..........: Viernes 22 de Octubre de 2021 (11:54:54)
*!*
*!*

Define Class ControlesBase As SessionBase Of Tools\namespaces\prg\ObjectNamespace.prg
    *Define Class ControlesBase As CustomBase Of Tools\namespaces\prg\CustomBase.prg

    #If .F.
        Local This As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    * Referencia al Control
    oControl = Null

    * Referencia al Campo asociado
    oField = Null

    * Valor en pixeles del módulo base
    nMod = 12

    * Referencia al Label
    oLabel = Null

    * Ancho de la columna virtual en pixeles
    nColumna = 0

    * Padding
    TopPadding 		= 0
    RightPadding 	= 1
    BottomPadding 	= 0
    LeftPadding 	= 1

    * Referencia al formulario principal
    oThisForm = Null

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="olabel" type="property" display="oLabel" />] + ;
        [<memberdata name="ocontrol" type="property" display="oControl" />] + ;
        [<memberdata name="ofield" type="property" display="oField" />] + ;
        [<memberdata name="ofield_access" type="method" display="oField_Access" />] + ;
        [<memberdata name="initialize" type="method" display="Initialize" />] + ;
        [<memberdata name="validardatos" type="method" display="ValidarDatos" />] + ;
        [<memberdata name="autosize" type="method" display="Autosize" />] + ;
        [<memberdata name="nmod" type="property" display="nMod" />] + ;
        [<memberdata name="tabindexcursor" type="method" display="TabIndexCursor" />] + ;
        [<memberdata name="inicializar" type="method" display="Inicializar" />] + ;
        [<memberdata name="inicializarfilas" type="method" display="InicializarFilas" />] + ;
        [<memberdata name="crearlabel" type="method" display="CrearLabel" />] + ;
        [<memberdata name="ajustaranchodelcontainer" type="method" display="AjustarAnchoDelContainer" />] + ;
        [<memberdata name="ncolumna" type="property" display="nColumna" />] + ;
        [<memberdata name="toppadding" type="property" display="TopPadding" />] + ;
        [<memberdata name="rightpadding" type="property" display="RightPadding" />] + ;
        [<memberdata name="bottompadding" type="property" display="BottomPadding" />] + ;
        [<memberdata name="leftpadding" type="property" display="LeftPadding" />] + ;
        [<memberdata name="othisform" type="property" display="oThisForm" />] + ;
        [</VFPData>]


    *
    * Inicializa el control
    Procedure Initialize(  ) As Void;
            HELPSTRING "Inicializa el control"

        Local lcCommand As String,;
            lcLabelName As String
        Local loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loLabel As _label Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container

        Try

            lcCommand = ""
            loControl = This.oControl

            If loControl.lAutomaticDisplay And This.oThisForm.lAutomaticDisplay

                This.ValidarDatos()

                This.AjustarAnchoDelContainer()
                This.Inicializar()
                This.CrearLabel()
                This.AutoSize()
                This.TabIndexCursor()

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



    *
    *
    Procedure ValidarDatos(  ) As Void
        Local lcCommand As String
        Local loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loLabel As _label Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container

        Local llValid As Boolean


        Try

            lcCommand = ""
            llValid = .T.

            loControl = This.oControl

            TEXT To lcMsg NoShow TextMerge Pretext 03
			Control "<<loControl.Name>>"
			Ubicado en "<<loControl.Parent.Name>>"

            ENDTEXT


            If Empty( loControl.cTable )
                TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
				La propiedad "cTable" está vacía.

                ENDTEXT

                llValid = .F.

            Endif

            If loControl.nColumnsSpan > 12
                TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
				La propiedad nColumnsSpan es mayor que 12

                ENDTEXT

                llValid = .F.

            Endif

            If Pemstatus( loControl, "nLabelSpan", 5 )
                If loControl.nLabelSpan > 12
                    TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
					La propiedad nLabelSpan es mayor que 12

                    ENDTEXT

                    llValid = .F.

                Endif

                If !Between( loControl.nLabelPosition, 0, 11 )
                    TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
					La propiedad nLabelPosition
					debe estar en el rango 0...12

                    ENDTEXT

                    llValid = .F.

                Endif

            Endif

            If !Between( loControl.nLeftColumn, 1, 12 )
                TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
				La propiedad nLeftColumn
				debe estar en el rango 1...12

                ENDTEXT

                llValid = .F.

            Endif


            If llValid = .F.
                Stop( lcMsg, "Alerta al Desarrollador", -1 )
                Logerror( lcMsg, Lineno(), "Alerta al Desarrollador" )
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && ValidarDatos



    *
    *
    Procedure Inicializar(  ) As Void
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx

        Try

            lcCommand = ""
            loField 	= This.oField
            loControl 	= This.oControl

            loControl.cCueText 		= loField.cToolTipText
            loControl.ToolTipText 	= loField.cToolTipText
            loControl.Format 		= loField.cFormat
            loControl.InputMask 	= loField.cInputMask
            loControl.Enabled 		= loField.lCanUpdate
            loControl.Height 		= ( This.nMod * 2 ) * ( loControl.nRowSpan )

            loControl.Height = loControl.Height - This.TopPadding - This.BottomPadding

            If loField.lStr
                If Inlist( loField.cFieldType, "I", "N" ) ;
                        And Lower( loControl.Class ) = "_textbox"

                    loControl.InputMask = Replicate( "X", 100 )

                Endif
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField = Null
            loControl = Null

        Endtry

    Endproc && Inicializar

    *
    *
    Procedure CrearLabel(  ) As Void
        Local lcCommand As String,;
            lcLabelName As String
        Local loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loLabel As _label Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container

        Local lnColumna As Integer

        Try

            lcCommand = ""

            loControl = This.oControl


            lcLabelName = "lbl" + Substr( loControl.Name, 4 ) + "_" + Sys(2015)
            loParent = loControl.Parent
            loParent.Newobject( lcLabelName, "_label", "fw\comunes\vcx\_controles_base.vcx" )

            * Vincular con el objeto Label
            TEXT To lcCommand NoShow TextMerge Pretext 15
				loLabel = loParent.<<lcLabelName>>
            ENDTEXT

            &lcCommand
            lcCommand = ""

            loField = This.oField

            If loControl.nLabelSpan > 0
                loLabel.Caption		= Alltrim( loField.cCaption )
                loLabel.AutoSize 	= .F.
                loLabel.Width 		= loControl.nLabelSpan * This.nColumna
                loLabel.Visible 	= .T.

            Else
                loLabel.Caption		= ""
                loLabel.AutoSize 	= .F.
                loLabel.Width 		= 0
                loLabel.Visible 	= .F.

            Endif

            loLabel.oControl = loControl
            loControl.oLabel = loLabel
            This.oLabel = loLabel

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loParent = Null
            loControl = Null
            loLabel = Null

        Endtry

    Endproc && CrearLabel


    *
    *
    Procedure AjustarAnchoDelContainer(  ) As Void
        Local lcCommand As String
        Local loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container

        Local lnColumna As Integer

        Try

            lcCommand = ""
            loControl = This.oControl
            loParent = loControl.Parent

            If loParent.BaseClass = "Page"
                loParent = loParent.Parent
            Endif

            If !Pemstatus( loParent, "nLeft", 5 )
                AddProperty( loParent, "nLeft", 0 )
            Endif

            If !Pemstatus( loParent, "nColumna", 5 )
                AddProperty( loParent, "nColumna", 0 )
            Endif

            If !Pemstatus( loParent, "lAlreadyFit", 5 )
                AddProperty( loParent, "lAlreadyFit", .F. )
            Endif

            If !loParent.lAlreadyFit

                If !Empty( Mod( loParent.Width, This.nMod ))
                    loParent.Width = Round( loParent.Width / This.nMod, 0 ) * This.nMod
                Endif

                lnColumna = Round( loParent.Width / 12, 0 )

                If !Empty( Mod( lnColumna, This.nMod ))
                    lnColumna = Round( lnColumna / This.nMod, 0 ) * This.nMod
                Endif

                loParent.Width = lnColumna * 12

                * Dejar un módulo a cada lado
                loParent.Width = loParent.Width + ( This.nMod * 2 )
                loParent.nLeft = This.nMod

                * Si hay un Shape, agregar un módulo a cada lado
                If Pemstatus( loParent, "Crud_Shape", 5 ) ;
                        Or Pemstatus( loControl.Parent, "Crud_Shape", 5 )

                    loParent.Width = loParent.Width + ( This.nMod * 2 )
                    loParent.nLeft = loParent.nLeft + This.nMod
                Endif


                loParent.nColumna 	= lnColumna
                This.nColumna 		= lnColumna

                loParent.lAlreadyFit = .T.

            Else
                This.nColumna 		= loParent.nColumna

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loParent = Null
            loControl = Null

        Endtry

    Endproc && AjustarAnchoDelContainer


    *
    *
    Procedure AutoSize(  ) As Void
        Local lcCommand As String,;
            lcCursorFilas As String
        Local loLabel As _label Of fw\comunes\vcx\_controles_base.vcx,;
            loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container

        Local lnLeft As Integer,;
            i As Integer

        Local llIsPage As Boolean


        Try

            lcCommand 	= ""
            loControl 	= This.oControl
            loParent 	= loControl.Parent

            If loParent.BaseClass = "Page"
                llIsPage = .T.
            Endif

            If llIsPage = .T.
                lnLeft 	= ((loControl.nLeftColumn - 1 ) * This.nColumna ) + loParent.Parent.nLeft

            Else
                lnLeft 	= ((loControl.nLeftColumn - 1 ) * This.nColumna ) + loParent.nLeft

            Endif

            loLabel 	= This.oLabel
            loLabel.Width 	= loControl.nLabelSpan * This.nColumna

            Do Case
                Case Inlist( loControl.nLabelPosition, 0, 1, 2 )
                    loControl.Left = lnLeft + loLabel.Width
                    loControl.Width = ( This.nColumna * loControl.nColumnsSpan ) - loLabel.Width

                Case Inlist( loControl.nLabelPosition, 3, 4, 5 )
                    loControl.Left = lnLeft
                    loControl.Width = ( This.nColumna * loControl.nColumnsSpan ) - loLabel.Width

                Otherwise
                    loControl.Left = lnLeft
                    loControl.Width = This.nColumna * loControl.nColumnsSpan

            Endcase

            loControl.Left 	= loControl.Left + This.LeftPadding
            loControl.Width = loControl.Width - This.LeftPadding - This.RightPadding

            If llIsPage
                lcCursorFilas = "cRows_" + loParent.Parent.Name + "_" + loParent.Name

            Else
                lcCursorFilas = "cRows_" + loParent.Name

            Endif

            If !Used( lcCursorFilas )

                TEXT To lcCommand NoShow TextMerge Pretext 15
				Create Cursor <<lcCursorFilas>> (
					Top I,
					Height I )
                ENDTEXT

                &lcCommand
                lcCommand = ""

                For i = 1 To 21
                    TEXT To lcCommand NoShow TextMerge Pretext 15
					Insert Into <<lcCursorFilas>> ( Top, Height )
						Values ( 0, <<This.nMod>> * 2 )
                    ENDTEXT

                    &lcCommand
                    lcCommand = ""

                Endfor

            Endif

            Select Alias( lcCursorFilas )

            If GotoRecno( loControl.nTopRow )
                If loControl.nLabelPosition > 5
                    Replace Height With This.nMod * 3
                Endif
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loControl 	= Null
            loLabel 	= Null

        Endtry

    Endproc && Autosize

    *
    *
    Procedure InicializarFilas(  ) As Void
        Local lcCommand As String,;
            lcCursorFilas As String

        Local loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loLabel As _label Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container
        Local lnTop As Integer,;
            lnLeft As Integer,;
            lnHeight As Integer

        Local llIsPage As Boolean

        Try

            lcCommand = ""
            llIsPage = .F.

            loControl 	= This.oControl

            If loControl.lAutomaticDisplay And This.oThisForm.lAutomaticDisplay

                loLabel 	= This.oLabel

                If Vartype( loLabel) # "O"
                    loLabel = loControl.oLabel
                Endif

                loParent 	= loControl.Parent

                If loParent.BaseClass = "Page"
                    llIsPage = .T.
                Endif

                If llIsPage
                    lcCursorFilas = "cRows_" + loParent.Parent.Name + "_" + loParent.Name
                    lnLeft 	= ((loControl.nLeftColumn - 1 ) * This.nColumna ) + loParent.Parent.nLeft

                Else
                    lcCursorFilas = "cRows_" + loParent.Name
                    lnLeft 	= ((loControl.nLeftColumn - 1 ) * This.nColumna ) + loParent.nLeft

                Endif

                If Used( lcCursorFilas )
                    Select Alias( lcCursorFilas )
                    Locate
                    If Empty( Top )
                        lnTop = 0

                        If Pemstatus( loParent, "Crud_Shape", 5 ) ;
                                Or Pemstatus( loControl.Parent, "Crud_Shape", 5 )

                            lnTop = loParent.Crud_Shape.Top + This.nMod

                        Else
                            lnTop = This.nMod

                        Endif

                        Scan

                            Replace Top With lnTop

                            lnTop = lnTop + Height

                        Endscan

                    Endif

                    If GotoRecno( loControl.nTopRow )

                        lnTop 		= Top
                        lnHeight 	= Height

                        If lnHeight > This.nMod * 2
                            If loControl.nVerticalAlignment = 0
                                lnTop = lnTop + ( This.nMod * 1 )
                            Endif
                        Endif

                        loControl.Top = lnTop

                        loControl.Top = loControl.Top + This.TopPadding

                        Do Case
                            Case loControl.nLabelPosition = 0
                                *!*	0 	The Label appears to the left of the TextBox.
                                *!*		The Label aligns with the top of the TextBox.
                                loLabel.Alignment	= 1
                                loLabel.Left 		= lnLeft - 06
                                loLabel.Top 		= loControl.Top

                            Case loControl.nLabelPosition = 1
                                *!*	1 	The Label appears to the left of the TextBox.
                                *!*		The Label is centered relative to the TextBox.
                                loLabel.Alignment 	= 1
                                loLabel.Left 		= lnLeft - 06
                                loLabel.Top 		= loControl.Top + ( loControl.Height / 2 ) - ( loLabel.Height / 2 )

                            Case loControl.nLabelPosition = 2
                                *!*	2	The Label appears to the left of the TextBox.
                                *!*		The Label aligns with the bottom of the TextBox.
                                loLabel.Alignment 	= 1
                                loLabel.Left 		= lnLeft - 06
                                loLabel.Top 		= loControl.Top + loControl.Height - loLabel.Height

                            Case loControl.nLabelPosition = 3
                                *!*	3	The Label appears to the right of the TextBox.
                                *!*		The Label aligns with top of the TextBox.
                                loLabel.Alignment	= 0
                                loLabel.Left 		= loControl.Left + loControl.Width + 06
                                loLabel.Top 		= loControl.Top


                            Case loControl.nLabelPosition = 4
                                *!*	4 	The Label appears to the right of the TextBox.
                                *!*		The Label is centered relative to the TextBox.
                                loLabel.Alignment	= 0
                                loLabel.Left 		= loControl.Left + loControl.Width + 06
                                loLabel.Top 		= loControl.Top + ( loControl.Height / 2 ) - ( loLabel.Height / 2 )


                            Case loControl.nLabelPosition = 5
                                *!*	5 	The Label appears to the right of the TextBox.
                                *!*		The Label aligns with the bottom of the TextBox.
                                loLabel.Alignment	= 0
                                loLabel.Left 		= loControl.Left + loControl.Width + 06
                                loLabel.Top 		= loControl.Top + loControl.Height - loLabel.Height

                            Case loControl.nLabelPosition = 6
                                *!*	6	The Label appears above the TextBox.
                                *!*		The Label aligns with the left edge of the TextBox.
                                loLabel.Alignment	= 0
                                loLabel.Width 		= loControl.Width
                                loLabel.Left 		= loControl.Left
                                loLabel.Top 		= loControl.Top - loLabel.Height + 03

                            Case loControl.nLabelPosition = 7
                                *!*	7	The Label appears above the TextBox.
                                *!*		The Label is centered above the TextBox.
                                loLabel.Alignment	= 2
                                loLabel.Width 		= loControl.Width
                                loLabel.Left 		= loControl.Left
                                loLabel.Top 		= loControl.Top - loLabel.Height + 03


                            Case loControl.nLabelPosition = 8
                                *!*	8	The Label appears above the TextBox.
                                *!*		The Label aligns with the right edge of the TextBox.
                                loLabel.Alignment	= 1
                                loLabel.Width 		= loControl.Width
                                loLabel.Left 		= loControl.Left
                                loLabel.Top 		= loControl.Top - loLabel.Height + 03

                            Case loControl.nLabelPosition = 9
                                *!*	9	The Label appears below the TextBox.
                                *!*		The Label aligns with the left edge of the TextBox.
                                loLabel.Alignment	= 0
                                loLabel.Width 		= loControl.Width
                                loLabel.Left 		= loControl.Left
                                loLabel.Top 		= loControl.Top
                                loControl.Top 		= loControl.Top - loLabel.Height - 06


                            Case loControl.nLabelPosition = 10
                                *!*	10	The Label appears below the TextBox.
                                *!*		The Label is centered below the TextBox.
                                loLabel.Alignment	= 2
                                loLabel.Width 		= loControl.Width
                                loLabel.Left 		= loControl.Left
                                loLabel.Top 		= loControl.Top
                                loControl.Top 		= loControl.Top - loLabel.Height - 06


                            Case loControl.nLabelPosition = 11
                                *!*	11	The Label appears below the TextBox.
                                *!*		The Label aligns with the right edge of the TextBox.
                                loLabel.Alignment	= 1
                                loLabel.Width 		= loControl.Width
                                loLabel.Left 		= loControl.Left
                                loLabel.Top 		= loControl.Top
                                loControl.Top 		= loControl.Top - loLabel.Height - 06

                            Otherwise

                        Endcase

                    Endif
                Endif

                If Pemstatus( loParent, "nCalculatedHeight", 5 )
                    If Inlist( loControl.nLabelPosition, 9, 10, 11 )
                        lnHeight = loLabel.Top + loLabel.Height

                    Else
                        lnHeight = loControl.Top + loControl.Height

                    Endif

                    If lnHeight > loParent.nCalculatedHeight
                        loParent.nCalculatedHeight = lnHeight
                    Endif

                    If llIsPage
                        If lnHeight > loParent.Parent.nCalculatedHeight
                            loParent.Parent.nCalculatedHeight = lnHeight
                        Endif

                    Endif

                Endif
            Endif


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && InicializarFilas


    *
    * oField_Access
    Protected Procedure oField_Access()

        Local lcCommand As String
        Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg',;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loThisForm As _Form Of fw\comunes\vcx\_controles_base.vcx

        Try

            lcCommand = ""

            If Isnull( This.oField )

                loThisForm 	= This.oThisForm

                loControl 	= This.oControl
                If Empty( loControl.cFieldName )
                    loControl.cFieldName = Substr( loControl.Name, 4 )
                Endif


                If !Empty( loControl.cTable )
                    loArchivo 	= loThisForm.GetTable( loControl.cTable )

                    If IsEmpty( loArchivo )

                        TEXT To lcMsg NoShow TextMerge Pretext 03
						No se pudo obtener la tabla asociada
						al control "<<loControl.Name>>"
						ubicado en "<<loControl.Parent.Name>>"

						La propiedad "cTable" indica "<<loControl.cTable>>"
                        ENDTEXT

                        Stop( lcMsg, "Alerta al Desarrollador", -1 )
                        Logerror( lcMsg, Lineno(), "Alerta al Desarrollador" )

                    Endif

                    loColFields = loArchivo.oColFields
                    loField 	= loColFields.GetItem( loControl.cFieldName )
                    This.oField = loField
                    loControl.oField = loField

                    If IsEmpty( loField )

                        TEXT To lcMsg NoShow TextMerge Pretext 03
						No se pudo obtener el campo asociado
						al control "<<loControl.cFieldName>>"
						ubicado en "<<loControl.Parent.Name>>"

						La propiedad "cTable" indica "<<loControl.cTable>>"
                        ENDTEXT

                        Stop( lcMsg, "Alerta al Desarrollador", -1 )
                        Logerror( lcMsg, Lineno(), "Alerta al Desarrollador" )

                    Else
                        * RA 17/07/2022(13:45:48)
                        * loField.lReadOnly tiene preeminencia sobre loField.lCanUpdate
                        If loField.lReadOnly = .T.
                            loField.lCanUpdate = .F.
                        Endif

                        If loControl.lReadOnly
                            loField.lReadOnly = .T.
                            loField.lCanUpdate = .F.
                        Endif

                    Endif


                Endif

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField 	= Null
            loColFields = Null
            loArchivo 	= Null
            loThisForm 	= Null

        Endtry

        Return This.oField

    Endproc && oField_Access

    *
    *
    Procedure TabIndexCursor(  ) As Void
        Local lcCommand As String,;
            lcCursorName As String

        Local loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container

        Try

            lcCommand 	= ""
            loControl 	= This.oControl
            loParent 	= loControl.Parent

            lcCursorName = "cControles_" + loParent.Name

            If !Used( lcCursorName )

                TEXT To lcCommand NoShow TextMerge Pretext 15
				Create Cursor <<lcCursorName>> (
					Row I,
					Column I,
					Name C(100) )
                ENDTEXT

                &lcCommand
                lcCommand = ""

            Endif

            Select Alias( lcCursorName )
            Append Blank
            Replace Row With loControl.nTopRow,;
                Column With loControl.nLeftColumn,;
                Name With Lower( loControl.Name )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && TabIndexCursor


    *
    *
    Procedure Destroy(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""

            This.oParent = Null
            This.oControl = Null
            This.oField = Null
            This.oLabel = Null

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            DoDefault()

        Endtry

    Endproc && Destroy



Enddefine
*!*
*!* END DEFINE
*!* Class.........: ControlesBase
*!*
*!* ///////////////////////////////////////////////////////


*cGridForm

*!* ///////////////////////////////////////////////////////
*!* Class.........: cGridForm
*!* Description...:
*!* Date..........: Lunes 25 de Octubre de 2021 (12:20:58)
*!*
*!*

Define Class cGridForm As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As cGridForm Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    * Inicializa el control
    Procedure Initialize(  ) As Void;
            HELPSTRING "Inicializa el control"

        Local lcCommand As String,;
            lcLabelName As String
        Local loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container

        Try

            lcCommand = ""
            loControl = This.oControl

            If loControl.lAutomaticDisplay And This.oThisForm.lAutomaticDisplay

                This.ValidarDatos()

                This.AjustarAnchoDelContainer()
                This.AutoSize()
                This.TabIndexCursor()

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

    *
    *
    Procedure AutoSize(  ) As Void
        Local lcCommand As String,;
            lcCursorFilas As String
        Local loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container

        Local lnLeft As Integer,;
            i As Integer


        Try

            lcCommand 	= ""
            loControl 	= This.oControl
            loParent 	= loControl.Parent
            lnLeft 		= ((loControl.nLeftColumn - 1 ) * This.nColumna ) + loParent.nLeft

            loControl.Left 		= lnLeft
            loControl.Width 	= This.nColumna * loControl.nColumnsSpan
            loControl.Height	= ( This.nMod * 2 ) * ( loControl.nRowSpan )

            If loControl.Height < ( This.nMod * 15 )
                loControl.Height = ( This.nMod * 15 )
            Endif

            loControl.Left = loControl.Left + This.LeftPadding
            loControl.Width = loControl.Width - This.LeftPadding - This.RightPadding
            loControl.Height = loControl.Height - This.TopPadding - This.BottomPadding

            lcCursorFilas = "cRows_" + loParent.Name

            If !Used( lcCursorFilas )

                TEXT To lcCommand NoShow TextMerge Pretext 15
				Create Cursor <<lcCursorFilas>> (
					Top I,
					Height I )
                ENDTEXT

                &lcCommand
                lcCommand = ""

                For i = 1 To 21
                    TEXT To lcCommand NoShow TextMerge Pretext 15
					Insert Into <<lcCursorFilas>> ( Top, Height )
						Values ( 0, <<This.nMod>> * 2 )
                    ENDTEXT

                    &lcCommand
                    lcCommand = ""

                Endfor

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loControl 	= Null

        Endtry

    Endproc && Autosize

    *
    *
    Procedure InicializarFilas(  ) As Void
        Local lcCommand As String,;
            lcCursorFilas As String

        Local loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loLabel As _label Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container
        Local lnTop As Integer,;
            lnLeft As Integer,;
            lnHeight As Integer

        Try

            lcCommand = ""

            loControl 	= This.oControl

            If loControl.lAutomaticDisplay And This.oThisForm.lAutomaticDisplay

                loLabel 	= This.oLabel
                loParent 	= loControl.Parent

                lnLeft 		= ((loControl.nLeftColumn - 1 ) * This.nColumna ) + loParent.nLeft

                lcCursorFilas = "cRows_" + loParent.Name
                If Used( lcCursorFilas )
                    Select Alias( lcCursorFilas )
                    Locate
                    If Empty( Top )
                        lnTop = 0

                        If Pemstatus( loParent, "Crud_Shape", 5 ) ;
                                Or Pemstatus( loControl.Parent, "Crud_Shape", 5 )

                            lnTop = loParent.Crud_Shape.Top + This.nMod

                        Else
                            lnTop = This.nMod

                        Endif

                        Scan

                            Replace Top With lnTop

                            lnTop = lnTop + Height

                        Endscan

                    Endif

                    If GotoRecno( loControl.nTopRow )

                        lnTop 		= Top
                        lnHeight 	= Height

                        loControl.Top = lnTop

                        loControl.Top = loControl.Top + This.TopPadding

                    Endif
                Endif

                If Pemstatus( loParent, "nCalculatedHeight", 5 )
                    lnHeight = loControl.Top + loControl.Height

                    If lnHeight > loParent.nCalculatedHeight
                        loParent.nCalculatedHeight = lnHeight
                    Endif

                Endif

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && InicializarFilas


Enddefine
*!*
*!* END DEFINE
*!* Class.........: cGridForm
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCB_CheckBox
*!* Description...:
*!* Date..........: Lunes 25 de Octubre de 2021 (15:02:08)
*!*
*!*

Define Class oCB_CheckBox As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As oCB_CheckBox Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Inicializar(  ) As Void
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _CheckBox Of fw\comunes\vcx\_controles_base.vcx

        Try

            lcCommand = ""
            loField 	= This.oField
            loControl 	= This.oControl

            loControl.ToolTipText 	= loField.cToolTipText
            *loControl.Format 		= loField.cFormat
            *loControl.InputMask 	= loField.cInputMask
            loControl.Caption 		= ""
            loControl.Enabled 		= loField.lCanUpdate
            loControl.Height 		= ( This.nMod * 2 ) * ( loControl.nRowSpan )

            loControl.Height = loControl.Height - This.TopPadding - This.BottomPadding

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField = Null
            loControl = Null

        Endtry

    Endproc && Inicializar



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCB_CheckBox
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCB_Spinner
*!* Description...:
*!* Date..........: Lunes 25 de Octubre de 2021 (15:02:08)
*!*
*!*

Define Class oCB_Spinner As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As oCB_Spinner Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


    *
    *
    Procedure Inicializar(  ) As Void
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _spinner Of fw\comunes\vcx\_controles_base.vcx

        Try

            lcCommand = ""
            loField 	= This.oField
            loControl 	= This.oControl

            loControl.ToolTipText 	= loField.cToolTipText
            loControl.Format 		= loField.cFormat
            loControl.InputMask 	= loField.cInputMask
            loControl.Enabled 		= loField.lCanUpdate
            loControl.Height 		= ( This.nMod * 2 ) * ( loControl.nRowSpan )

            loControl.Height = loControl.Height - This.TopPadding - This.BottomPadding
            
            loControl.KeyboardHighValue = loField.nMaxValue 
            loControl.KeyboardLowValue 	= loField.nLowValue 
            loControl.SpinnerHighValue 	= loField.nMaxValue 
            loControl.SpinnerLowValue  	= loField.nLowValue 
           
            

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField = Null
            loControl = Null

        Endtry

    Endproc && Inicializar

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCB_Spinner
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCB_OptionGroup
*!* Description...:
*!* Date..........: Lunes 25 de Octubre de 2021 (15:02:08)
*!*
*!*

Define Class oCB_OptionGroup As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As oCB_OptionGroup Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCB_OptionGroup
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCB_EditBox
*!* Description...:
*!* Date..........: Lunes 25 de Octubre de 2021 (15:02:08)
*!*
*!*

Define Class oCB_EditBox As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As oCB_EditBox Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Inicializar(  ) As Void
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _editbox Of fw\comunes\vcx\_controles_base.vcx

        Try

            lcCommand = ""
            loField 	= This.oField
            loControl 	= This.oControl

            loControl.cCueText 		= loField.cToolTipText
            loControl.ToolTipText 	= loField.cToolTipText
            loControl.Format 		= loField.cFormat
            *loControl.InputMask 	= loField.cInputMask
            loControl.Enabled 		= loField.lCanUpdate
            loControl.Height 		= ( This.nMod * 2 ) * ( loControl.nRowSpan )

            loControl.Height = loControl.Height - This.TopPadding - This.BottomPadding


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField = Null
            loControl = Null

        Endtry

    Endproc && Inicializar


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCB_EditBox
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCB_Date
*!* Description...:
*!* Date..........: Lunes 25 de Octubre de 2021 (15:02:08)
*!*
*!*

Define Class oCB_Date As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As oCB_Date Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Inicializar(  ) As Void
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _date Of fw\comunes\vcx\_controles_base.vcx

        Try

            lcCommand = ""
            loField 	= This.oField
            loControl 	= This.oControl

            loControl.ToolTipText 	= loField.cToolTipText
            *loControl.Format 		= loField.cFormat
            *loControl.InputMask 	= loField.cInputMask
            loControl.Enabled 		= loField.lCanUpdate
            loControl.Height 		= ( This.nMod * 2 ) && * ( loControl.nRowSpan )

            loControl.Height = loControl.Height - This.TopPadding - This.BottomPadding

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField = Null
            loControl = Null

        Endtry

    Endproc && Inicializar

    *
    *
    Procedure AutoSize(  ) As Void
        Local lcCommand As String,;
            lcCursorFilas As String
        Local loLabel As _label Of fw\comunes\vcx\_controles_base.vcx,;
            loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container

        Local lnLeft As Integer,;
            i As Integer,;
            lnMinWidth As Integer,;
            lnWidth As Integer


        Try

            lcCommand 	= ""
            loControl 	= This.oControl
            loParent 	= loControl.Parent
            lnLeft 		= ((loControl.nLeftColumn - 1 ) * This.nColumna ) + loParent.nLeft

            loLabel 	= This.oLabel
            loLabel.Width 	= loControl.nLabelSpan * This.nColumna

            lnMinWidth = 100

            Do Case
                Case Inlist( loControl.nLabelPosition, 0, 1, 2 )
                    loControl.Left = lnLeft + loLabel.Width
                    lnWidth = ( This.nColumna * loControl.nColumnsSpan ) - loLabel.Width

                Case Inlist( loControl.nLabelPosition, 3, 4, 5 )
                    loControl.Left = lnLeft
                    lnWidth = ( This.nColumna * loControl.nColumnsSpan ) - loLabel.Width

                Otherwise
                    loControl.Left = lnLeft
                    lnWidth = This.nColumna * loControl.nColumnsSpan

            Endcase

            If lnWidth < lnMinWidth
                lnWidth = lnMinWidth
            Endif

            loControl.Width = lnWidth

            loControl.Left = loControl.Left + This.LeftPadding
            loControl.Width = loControl.Width - This.LeftPadding - This.RightPadding


            lcCursorFilas = "cRows_" + loParent.Name

            If !Used( lcCursorFilas )

                TEXT To lcCommand NoShow TextMerge Pretext 15
				Create Cursor <<lcCursorFilas>> (
					Top I,
					Height I )
                ENDTEXT

                &lcCommand
                lcCommand = ""

                For i = 1 To 21
                    TEXT To lcCommand NoShow TextMerge Pretext 15
					Insert Into <<lcCursorFilas>> ( Top, Height )
						Values ( 0, <<This.nMod>> * 2 )
                    ENDTEXT

                    &lcCommand
                    lcCommand = ""

                Endfor

            Endif

            Select Alias( lcCursorFilas )

            If GotoRecno( loControl.nTopRow )
                If loControl.nLabelPosition > 5
                    Replace Height With This.nMod * 3
                Endif
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loControl 	= Null
            loLabel 	= Null

        Endtry

    Endproc && Autosize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCB_Date
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCB_ComboBox
*!* Description...:
*!* Date..........: Lunes 25 de Octubre de 2021 (15:02:08)
*!*
*!*

Define Class oCB_ComboBox As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As oCB_ComboBox Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Inicializar(  ) As Void
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _ComboBox Of fw\comunes\vcx\_controles_base.vcx

        Try

            lcCommand = ""
            loField 	= This.oField
            loControl 	= This.oControl

            loControl.ToolTipText 	= loField.cToolTipText
            loControl.Format 		= loField.cFormat
            loControl.InputMask 	= loField.cInputMask
            loControl.Enabled 		= loField.lCanUpdate
            loControl.Height 		= ( This.nMod * 2 ) * ( loControl.nRowSpan )

            loControl.Height = loControl.Height - This.TopPadding - This.BottomPadding

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField = Null
            loControl = Null

        Endtry

    Endproc && Inicializar



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCB_ComboBox
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCB_ListBox
*!* Description...:
*!* Date..........: Lunes 25 de Octubre de 2021 (15:02:08)
*!*
*!*

Define Class oCB_ListBox As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As oCB_ListBox Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Inicializar(  ) As Void
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _ListBox Of fw\comunes\vcx\_controles_base.vcx

        Try

            lcCommand = ""
            loField 	= This.oField
            loControl 	= This.oControl

            loControl.ToolTipText 	= loField.cToolTipText
            loControl.Enabled 		= loField.lCanUpdate
            loControl.Height 		= ( This.nMod * 2 ) * ( loControl.nRowSpan )

            If Empty( loControl.cModelo )
                loControl.cModelo 	= loField.cReferences
            Endif

            loControl.Height = loControl.Height - This.TopPadding - This.BottomPadding

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField = Null
            loControl = Null

        Endtry

    Endproc && Inicializar



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCB_ListBox
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCB_Container
*!* Description...:
*!* Date..........: Lunes 25 de Octubre de 2021 (15:02:08)
*!*
*!*

Define Class oCB_Container As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As oCB_Container Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Inicializar(  ) As Void
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _Container Of fw\comunes\vcx\_controles_base.vcx

        Try

            lcCommand = ""
            loField 	= This.oField
            loControl 	= This.oControl

            loControl.ToolTipText 	= loField.cToolTipText
            loControl.Enabled 		= loField.lCanUpdate
            loControl.Height 		= ( This.nMod * 2 ) * ( loControl.nRowSpan )

            If Empty( loControl.cModelo )
                loControl.cModelo 	= loField.cReferences
            Endif

            loControl.Height = loControl.Height - This.TopPadding - This.BottomPadding

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField = Null
            loControl = Null

        Endtry

    Endproc && Inicializar



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCB_Container
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCB_MoverList
*!* Description...:
*!* Date..........: Lunes 25 de Octubre de 2021 (15:02:08)
*!*
*!*

Define Class oCB_MoverList As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As oCB_MoverList Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""
            DoDefault()


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

    *
    *
    Procedure Inicializar(  ) As Void
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _moverlist Of fw\comunes\vcx\_controles_base.vcx,;
            loAvailable As _ListBox Of fw\comunes\vcx\_controles_base.vcx,;
            loSelected As _ListBox Of fw\comunes\vcx\_controles_base.vcx
        Local loFiltros As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
            loFiltro As Object

        Try

            lcCommand = ""

            loField 	= This.oField
            loControl 	= This.oControl

            loControl.ToolTipText 	= loField.cToolTipText
            loControl.Enabled 		= loField.lCanUpdate
            loControl.Height 		= ( This.nMod * 2 ) * ( loControl.nRowSpan )

            If Empty( loControl.cModelo )
                loControl.cModelo 	= loField.cReferences
            Endif

            loAvailable = loControl.lstAvailable
            loAvailable.cModelo = loControl.cModelo

            loSelected = loControl.lstSelected
            loSelected.cModelo = loControl.cModelo

            loControl.Height = loControl.Height - This.TopPadding - This.BottomPadding


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField = Null
            loControl = Null

        Endtry

    Endproc && Inicializar


    *
    *
    Procedure AutoSize(  ) As Void
        Local lcCommand As String
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _moverlist Of fw\comunes\vcx\_controles_base.vcx,;
            loAvailable As _ListBox Of fw\comunes\vcx\_controles_base.vcx,;
            loSelected As _ListBox Of fw\comunes\vcx\_controles_base.vcx
        Local loFiltros As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
            loFiltro As Object

        Try

            lcCommand = ""
            DoDefault()

            loControl 	= This.oControl
            loAvailable = loControl.lstAvailable
            loSelected  = loControl.LstSelected

            loAvailable.Left = 0
            loAvailable.Width = ( loControl.Width / 2 ) - ( loControl.btnAddAll.Width / 2 )
            loAvailable.Height = loControl.Height - 24

            loControl.btnAddAll.Left = loAvailable.Width + 1
            loControl.btnAddOne.Left = loAvailable.Width + 1
            loControl.btnRemoveAll.Left  = loAvailable.Width + 1
            loControl.btnRemoveOne.Left  = loAvailable.Width + 1


            loSelected.Width = loAvailable.Width
            loSelected.Left = loAvailable.Width + loControl.btnAddAll.Width + 2
            loSelected.Height = loAvailable.Height
            loControl.lblSelected.Left = loSelected.Left


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Autosize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCB_MoverList
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oCB_SearchBox
*!* Description...:
*!* Date..........: Sábado 24 de Septiembre de 2022 (11:35:03)
*!*
*!*

Define Class oCB_SearchBox As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As oCB_SearchBox Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    oSearchField = Null

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="osearchfield" type="property" display="oSearchField" />] + ;
        [<memberdata name="osearchfield_access" type="method" display="oSearchField_Access" />] + ;
        [</VFPData>]

    *
    *
    Procedure Inicializar(  ) As Void
        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _txtsearch Of fw\comunes\vcx\_controles_base.vcx

        Try

            lcCommand = ""
            loField 	= This.oSearchField
            loControl 	= This.oControl

            loControl.cCueText 		= "Ingrese la condición de búsqueda"
            loControl.ToolTipText 	= "Ingrese la condición de búsqueda"
            loControl.Format 		= loField.cFormat
            loControl.InputMask 	= loField.cInputMask
            *!*	            loControl.Enabled 		= loField.lCanUpdate
            loControl.Height 		= ( This.nMod * 2 ) * ( loControl.nRowSpan )

            loControl.Height = loControl.Height - This.TopPadding - This.BottomPadding

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField = Null
            loControl = Null

        Endtry

    Endproc && Inicializar

    *
    * oSearchField_Access
    Protected Procedure oSearchField_Access()
        Local lcCommand As String

        Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg',;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _txtsearch Of fw\comunes\vcx\_controles_base.vcx,;
            loThisForm As _Form Of fw\comunes\vcx\_controles_base.vcx,;
            loModelo As oModelo Of "FrontEnd\Prg\Modelo.prg"

        Try

            lcCommand = ""

            If Isnull( This.oSearchField )

                loThisForm 	= This.oThisForm

                loControl 	= This.oControl
                If Empty( loControl.cSearchFieldName )
                    TEXT To lcMsg NoShow TextMerge Pretext 03
                    <<loControl.Name>>
                    Falta definir la propiedad "cSearchFieldName"
                    ENDTEXT

                    Error lcMsg

                Endif

                If Empty( loControl.cModelo )
                    TEXT To lcMsg NoShow TextMerge Pretext 03
                    <<loControl.Name>>
                    Falta definir la propiedad "cModelo"
                    ENDTEXT

                    Error lcMsg

                Endif

                loModelo = loControl.oModelo

                If !Empty( loModelo.cTabla )
                    loArchivo 	= loThisForm.GetTable( loModelo.cTabla )

                    If IsEmpty( loArchivo )
                        TEXT To lcMsg NoShow TextMerge Pretext 03
						No se pudo obtener la tabla asociada
						al control "<<loControl.Name>>"
						ubicado en "<<loControl.Parent.Name>>"

						La propiedad "cTabla" indica "<<loModelo.cTabla>>"
                        ENDTEXT

                        Stop( lcMsg, "Alerta al Desarrollador", -1 )
                        Logerror( lcMsg, Lineno(), "Alerta al Desarrollador" )

                    Endif

                    loColFields = loArchivo.oColFields
                    loField 	= loColFields.GetItem( loControl.cSearchFieldName )
                    This.oSearchField = loField

                    If IsEmpty( loField )
                        TEXT To lcMsg NoShow TextMerge Pretext 03
						No se pudo obtener el campo asociado
						al control "<<loControl.cSearchFieldName>>"
						ubicado en "<<loControl.Parent.Name>>"

						La propiedad "cTabla" indica "<<loModelo.cTabla>>"
                        ENDTEXT

                        Stop( lcMsg, "Alerta al Desarrollador", -1 )
                        Logerror( lcMsg, Lineno(), "Alerta al Desarrollador" )

                    Else
                        * RA 17/07/2022(13:45:48)
                        * loField.lReadOnly tiene preeminencia sobre loField.lCanUpdate
                        If loField.lReadOnly = .T.
                            loField.lCanUpdate = .F.
                        Endif

                        If loControl.lReadOnly
                            loField.lReadOnly = .T.
                            loField.lCanUpdate = .F.
                        Endif

                    Endif
                Endif

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField 	= Null
            loColFields = Null
            loArchivo 	= Null
            loThisForm 	= Null

        Endtry


        Return This.oSearchField

    Endproc && oSearchField_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCB_SearchBox
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oCb_Titulo
*!* Description...:
*!* Date..........: Miércoles 4 de Enero de 2023 (13:02:51)
*!*
*!*

Define Class oCb_Titulo As ControlesBase Of "FW\Comunes\vcx\_Controles_Base.prg"

    #If .F.
        Local This As oCb_Titulo Of "FW\Comunes\vcx\_Controles_Base.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    * Inicializa el control
    Procedure Initialize(  ) As Void;
            HELPSTRING "Inicializa el control"

        Local lcCommand As String,;
            lcLabelName As String
        Local loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loLabel As _label Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container

        Try

            lcCommand = ""
            loControl = This.oControl
            
            If loControl.lAutomaticDisplay And This.oThisForm.lAutomaticDisplay

                *This.ValidarDatos()

                This.AjustarAnchoDelContainer()
                *This.Inicializar()
                *This.CrearLabel()
                This.AutoSize()
                *This.TabIndexCursor()

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

    *
    *
    Procedure AutoSize(  ) As Void
        Local lcCommand As String,;
            lcCursorFilas As String
        Local loLabel As _label Of fw\comunes\vcx\_controles_base.vcx,;
            loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container

        Local lnLeft As Integer,;
            i As Integer

        Local llIsPage As Boolean


        Try

            lcCommand 	= ""
            loControl 	= This.oControl
            loParent 	= loControl.Parent

            If loParent.BaseClass = "Page"
                llIsPage = .T.
            Endif

            If llIsPage = .T.
                lnLeft 	= ((loControl.nLeftColumn - 1 ) * This.nColumna ) + loParent.Parent.nLeft

            Else
                lnLeft 	= ((loControl.nLeftColumn - 1 ) * This.nColumna ) + loParent.nLeft

            Endif

            loControl.Left 	= lnLeft
            *loControl.Width = This.nColumna * loControl.nColumnsSpan

            loControl.Left 	= loControl.Left + This.LeftPadding
            loControl.Width = loControl.Width - This.LeftPadding - This.RightPadding

            If llIsPage
                lcCursorFilas = "cRows_" + loParent.Parent.Name + "_" + loParent.Name

            Else
                lcCursorFilas = "cRows_" + loParent.Name

            Endif

            If !Used( lcCursorFilas )

                TEXT To lcCommand NoShow TextMerge Pretext 15
				Create Cursor <<lcCursorFilas>> (
					Top I,
					Height I )
                ENDTEXT

                &lcCommand
                lcCommand = ""

                For i = 1 To 21
                    TEXT To lcCommand NoShow TextMerge Pretext 15
					Insert Into <<lcCursorFilas>> ( Top, Height )
						Values ( 0, <<This.nMod>> * 2 )
                    ENDTEXT

                    &lcCommand
                    lcCommand = ""

                Endfor

            Endif

            Select Alias( lcCursorFilas )

            If GotoRecno( loControl.nTopRow )
                If .F. && loControl.nLabelPosition > 5
                    Replace Height With This.nMod * 3
                Endif
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loControl 	= Null
            loLabel 	= Null

        Endtry

    Endproc && Autosize

    *
    *
    Procedure InicializarFilas(  ) As Void
        Local lcCommand As String,;
            lcCursorFilas As String

        Local loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx,;
            loLabel As _label Of fw\comunes\vcx\_controles_base.vcx,;
            loParent As Container
        Local lnTop As Integer,;
            lnLeft As Integer,;
            lnHeight As Integer

        Local llIsPage As Boolean

        Try

            lcCommand = ""
            llIsPage = .F.

            loControl 	= This.oControl

            If loControl.lAutomaticDisplay And This.oThisForm.lAutomaticDisplay

                loParent 	= loControl.Parent

                If loParent.BaseClass = "Page"
                    llIsPage = .T.
                Endif

                If llIsPage
                    lcCursorFilas = "cRows_" + loParent.Parent.Name + "_" + loParent.Name
                    lnLeft 	= ((loControl.nLeftColumn - 1 ) * This.nColumna ) + loParent.Parent.nLeft

                Else
                    lcCursorFilas = "cRows_" + loParent.Name
                    lnLeft 	= ((loControl.nLeftColumn - 1 ) * This.nColumna ) + loParent.nLeft

                Endif

                If Used( lcCursorFilas )
                    Select Alias( lcCursorFilas )
                    Locate
                    If Empty( Top )
                        lnTop = 0

                        If Pemstatus( loParent, "Crud_Shape", 5 ) ;
                                Or Pemstatus( loControl.Parent, "Crud_Shape", 5 )

                            lnTop = loParent.Crud_Shape.Top + This.nMod

                        Else
                            lnTop = This.nMod

                        Endif

                        Scan

                            Replace Top With lnTop

                            lnTop = lnTop + Height

                        Endscan

                    Endif

                    If GotoRecno( loControl.nTopRow )

                        lnTop 		= Top
                        lnHeight 	= Height

                        If lnHeight > This.nMod * 2
                            If loControl.nVerticalAlignment = 0
                                lnTop = lnTop + ( This.nMod * 1 )
                            Endif
                        Endif

                        loControl.Top = lnTop

                        loControl.Top = loControl.Top + This.TopPadding

                    Endif
                Endif

                If Pemstatus( loParent, "nCalculatedHeight", 5 )
                    lnHeight = loControl.Top + loControl.Height

                    If lnHeight > loParent.nCalculatedHeight
                        loParent.nCalculatedHeight = lnHeight
                    Endif

                    If llIsPage
                        If lnHeight > loParent.Parent.nCalculatedHeight
                            loParent.Parent.nCalculatedHeight = lnHeight
                        Endif

                    Endif

                Endif
            Endif


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && InicializarFilas

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oCb_Titulo
*!*
*!* ///////////////////////////////////////////////////////

