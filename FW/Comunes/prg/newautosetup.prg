*!* ///////////////////////////////////////////////////////
*!* Begin Test
*!*

Set Asserts On

Try
    Local loForm As TestForm Of "fw\comunes\prg\newautosetup.prg"
    Local loAutosetup As NewAutoSetup Of "fw\comunes\prg\newautosetup.prg"
    Local loColObjects As Collection
    Local i As Integer

    loAutosetup = Createobject( "NewAutoSetup" )

    For i = 3 To 3
        loColObjects = loAutosetup.FillCollection( i )
        loAutosetup.Process( loColObjects )

        loForm = Createobject( "TestForm" )
        loForm.oColObjects = loColObjects
        loForm.AddControls()
        loForm.Show()
        Read Events
    Endfor

Catch To oErr
    Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

    loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
    loError.Process( oErr )

Finally
    loError = Null

Endtry


*!*
*!*  End Test
*!* ///////////////////////////////////////////////////////



*!* ///////////////////////////////////////////////////////
*!* Class.........: NewAutoSetup
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...:
*!* Date..........: Martes 28 de Abril de 2009 (08:15:44)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class NewAutoSetup As Session

    #If .F.
        Local This As NewAutoSetup Of "fw\comunes\prg\newautosetup.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="fillcollection" type="method" display="FillCollection" />] + ;
        [<memberdata name="process" type="method" display="Process" />] + ;
        [<memberdata name="dimensionarmatriz" type="method" display="DimensionarMatriz" />] + ;
        [<memberdata name="ubicarcontrolesencoordenadas" type="method" display="UbicarControlesEnCoordenadas" />] + ;
        [<memberdata name="calcularposicion" type="method" display="CalcularPosicion" />] + ;
        [<memberdata name="calcularmaximos" type="method" display="CalcularMaximos" />] + ;
        [</VFPData>]


    Procedure Process( toColObjects As Collection,;
            tnTopPadding As Integer,;
            tnLeftPadding As Integer,;
            tnRightPadding As Integer,;
            tnBottomPadding As Integer,;
            tnGap As Integer 	 )

        Set Asserts On

        Local loMatriz As Object

        Private All Like pn*

        pnTopPadding = IfEmpty( tnTopPadding, 0 )
        pnLeftPadding = IfEmpty( tnLeftPadding, 0 )
        pnLeftPadding = IfEmpty( tnLeftPadding, 0 )
        pnRightPadding = IfEmpty( tnRightPadding, 0 )
        pnBottomPadding = IfEmpty( tnBottomPadding, 0 )
        pnGap = IfEmpty( tnGap, 0 )
        Try

            * Dimensionar Matriz

            loMatriz = Createobject( "Empty" )
            AddProperty( loMatriz, "nMaxRow", 0 )
            AddProperty( loMatriz, "nMaxCol", 0 )

            This.DimensionarMatriz( @loMatriz, @toColObjects )

            Dimension laMatriz( loMatriz.nMaxRow, loMatriz.nMaxCol )

            * Ubicar controles en coordenadas

            This.UbicarControlesEnCoordenadas( @laMatriz, toColObjects, loMatriz )

            * Calcular Posición

            This.CalcularPosicion( @laMatriz, toColObjects, loMatriz  )


        Catch To oErr
            Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )

        Finally

        Endtry

    Endproc


    Procedure DimensionarMatriz( toMatriz As Object @, toColObjects As Collection @ ) As VOID

        Local lnMaxRow As Integer,;
            lnMaxCol As Integer

        Local lnRow As Integer,;
            lnCol As Integer

        Local loCtrl As ControlStandard Of "fw\comunes\prg\newautosetup.prg"

        * Set Step On

        Try

            lnMaxCol = 1
            lnMaxRow = 1

            lnCol = 0
            lnRow = 0

            For Each loCtrl In toColObjects

                If loCtrl.SameRowAsPrevious
                    lnCol = lnCol + loCtrl.nColSpan
                    lnMaxCol = Max( lnMaxCol, lnCol )
                Else
                    lnMaxCol = Max( lnMaxCol, lnCol )
                    lnCol = 1
                    lnRow = lnRow + loCtrl.nRowSpan
                Endif
            Endfor

            lnMaxRow = Max( lnMaxRow, lnRow )

            Assert  ! (lnMaxRow = 0 )
            Assert  ! (lnMaxCol = 0 )

            toMatriz.nMaxCol = lnMaxCol
            toMatriz.nMaxRow = lnMaxRow

        Catch To oErr
            Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

    Endproc

    Procedure UbicarControlesEnCoordenadas( laMatriz, toColObjects, loMatriz )

        Local loCtrl As ControlStandard Of "fw\comunes\prg\newautosetup.prg"
        Local lnRow As Integer,;
            lnCol As Integer

        Try

            lnCol = 0
            lnRow = 0
            * Set Step On
            For Each loCtrl In toColObjects


                * If loCtrl.lSameRowAsPrevious
                If loCtrl.SameRowAsPrevious
                    lnCol = lnCol + 1

                    *!*	                    Do While loMatriz.nMaxCol <= lnCol ;
                    *!*	                            And ! IsEmpty( laMatriz[ lnRow, lnCol ] )
                    Do While ! IsEmpty( laMatriz[ lnRow, lnCol ] )
                        lnCol = lnCol + 1
                    Enddo
                Else
                    lnCol = 1
                    lnRow = lnRow + 1
                    *!*	                    Do While loMatriz.nMaxRow <=lnRow ;
                    *!*	                            And ! IsEmpty( laMatriz[ lnRow, lnCol ] )
                    Do While ! IsEmpty( laMatriz[ lnRow, lnCol ] )
                        lnRow = lnRow + 1
                    Enddo
                Endif

                If Vartype( laMatriz[ lnRow, lnCol ] ) <> "O"

                    If loCtrl.nColSpan > 1 Or loCtrl.nRowSpan > 1
                        loCtrl.BackColor = Rgb(255,128,0)
                    Endif

                    For Y = lnRow To lnRow + loCtrl.nRowSpan - 1
                        For x = lnCol To lnCol + loCtrl.nColSpan - 1
                            laMatriz[ y, x ] = Createobject( "ControlSpan" )
                        Endfor
                    Endfor

                    laMatriz[ lnRow, lnCol ] = loCtrl
                    loCtrl.AutoSetup()

                    *!*						For i = 1 To loCtrl.nColSpan - 1
                    *!*							laMatriz[ lnRow, lnCol + i ] = Createobject( "ControlSpan" )
                    *!*						EndFor

                    *!*						For i = 1 To loCtrl.nRowSpan - 1
                    *!*							laMatriz[ lnRow + i, lnCol] = Createobject( "ControlSpan" )
                    *!*						EndFor

                Endif

            Endfor

            For nRow = 1 To loMatriz.nMaxRow
                For nCol = 1 To loMatriz.nMaxCol
                    If Vartype( laMatriz[ nRow, nCol ] ) <> "O"
                        laMatriz[ nRow, nCol ] = Createobject( "ControlSeparador" )
                    Endif

                    * laMatriz[ nRow, nCol ].lblLabel.Caption = "Ctrl " + Transform(nRow) + Transform(nCol)
                Endfor
            Endfor

        Catch To oErr
            Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

    Endproc


    Procedure CalcularPosicion( laMatriz, toColObjects, loMatriz  )

        Dimension laMaxRows( loMatriz.nMaxRow ),;
            laMaxCols( loMatriz.nMaxCol )

        Local loCtrl As ControlStandard Of "fw\comunes\prg\newautosetup.prg"
        Local loAnt  As ControlStandard Of "fw\comunes\prg\newautosetup.prg"
        Local lnRow As Integer,;
            lnCol As Integer
        Local lnLeft As Integer,;
            lnTop As Integer


        Try

            * Calcular Maximos
            This.CalcularMaximos( @laMatriz, @laMaxRows, @laMaxCols, loMatriz )

            * Calcular Posición

            lnLeft = 0
            lnTop = 0

            For lnRow = 1 To loMatriz.nMaxRow

                For lnCol = 1 To loMatriz.nMaxCol


                    loCtrl = laMatriz[ lnRow, lnCol ]

                    * loCtrl.Top 	= loCtrl.nGap + lnTop
                    loCtrl.Top 	= pnGap + lnTop
                    * loCtrl.Left = loCtrl.nGap + lnLeft
                    loCtrl.Left = pnGap + lnLeft

                    lnLeft = lnLeft + laMaxCols[ lnCol ]

                    If loCtrl.nColSpan > 1
                        * loCtrl.Width = ( loCtrl.Width * loCtrl.nColSpan ) + ( loCtrl.nGap * loCtrl.nColSpan ) - loCtrl.nGap
                        loCtrl.Width = ( loCtrl.Width * loCtrl.nColSpan ) + ( pnGap * loCtrl.nColSpan ) - pnGap
                    Endif

                    If loCtrl.nRowSpan > 1
                        * loCtrl.Height  = ( loCtrl.Height * loCtrl.nRowSpan ) + ( loCtrl.nGap * loCtrl.nRowSpan ) - loCtrl.nGap
                        loCtrl.Height  = ( loCtrl.Height * loCtrl.nRowSpan ) + ( pnGap * loCtrl.nRowSpan ) - pnGap
                    Endif

                Endfor

                lnTop = lnTop + laMaxRows[ lnRow ]
                lnLeft = 0

            Endfor



        Catch To oErr
            Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

    Endproc


    *!*		Procedure CalcularPosicion( laMatriz, toColObjects, loMatriz  )

    *!*			Dimension laMaxRows( loMatriz.nMaxRow ),;
    *!*				laMaxCols( loMatriz.nMaxCol )

    *!*			Local loCtrl As ControlStandard Of "fw\comunes\prg\newautosetup.prg"
    *!*			Local loAnt  As ControlStandard Of "fw\comunes\prg\newautosetup.prg"
    *!*			Local lnRow As Integer,;
    *!*				lnCol As Integer
    *!*			Local lnLeft As Integer,;
    *!*				lnTop As Integer


    *!*			Try

    *!*				* Calcular Maximos
    *!*				This.CalcularMaximos( @laMatriz, @laMaxRows, @laMaxCols, loMatriz )

    *!*				* Calcular Posición

    *!*				lnLeft = 0
    *!*				lnTop = 0

    *!*				For lnRow = 1 To loMatriz.nMaxRow


    *!*					For lnCol = 1 To loMatriz.nMaxCol
    *!*						loCtrl = laMatriz[ lnRow, lnCol ]

    *!*						loCtrl.Top = loCtrl.nGap + lnTop

    *!*						*!*						If !Empty( lnRow - 1 )
    *!*						*!*							*loAnt = laMatriz[ lnRow - 1, lnCol ]
    *!*						*!*							*loCtrl.Top 	= loAnt.Top + loAnt.Height + loAnt.nGap
    *!*						*!*							*loCtrl.Top 	= loAnt.Top + laMaxRows[ lnRow - 1 ] + loAnt.nGap
    *!*						*!*
    *!*						*!*							loCtrl.Top 	= lnTop


    *!*						*!*						Else
    *!*						*!*							loCtrl.Top = loCtrl.nGap + lnTop
    *!*						*!*							lnTop = lnTop + laMaxRows[ lnRow ]

    *!*						*!*						Endif


    *!*						loCtrl.Left = loCtrl.nGap + lnLeft
    *!*						lnLeft = lnLeft + laMaxCols[ lnCol ]

    *!*						*!*						If !Empty( lnCol - 1 )
    *!*						*!*							*loAnt = laMatriz[ lnRow, lnCol - 1 ]
    *!*						*!*							*loCtrl.Left = loAnt.Left + loAnt.Width + loAnt.nGap
    *!*						*!*							*loCtrl.Left = loAnt.Left + laMaxCols[ lnCol - 1 ] + loAnt.nGap
    *!*						*!*
    *!*						*!*							loCtrl.Left = lnLeft

    *!*						*!*						Else
    *!*						*!*							loCtrl.Left = loCtrl.nGap + lnLeft
    *!*						*!*							lnLeft = lnLeft + laMaxCols[ lnCol ]

    *!*						*!*						EndIf

    *!*						If loCtrl.nColSpan > 1
    *!*							loCtrl.Width = ( loCtrl.Width * loCtrl.nColSpan ) + ( loCtrl.nGap * loCtrl.nColSpan ) - loCtrl.nGap
    *!*						Endif

    *!*						If loCtrl.nRowSpan > 1
    *!*							loCtrl.Height  = ( loCtrl.Height * loCtrl.nRowSpan ) + ( loCtrl.nGap * loCtrl.nRowSpan ) - loCtrl.nGap
    *!*						Endif

    *!*					Endfor

    *!*					lnTop = lnTop + laMaxRows[ lnRow ]

    *!*				Endfor



    *!*			Catch To oErr
    *!*				Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

    *!*				loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
    *!*				loError.Process( oErr )
    *!*				Throw loError

    *!*			Finally

    *!*			Endtry

    *!*		Endproc

    Procedure CalcularMaximos( laMatriz, laMaxRows, laMaxCols, loMatriz )

        Local loCtrl As ControlStandard Of "fw\comunes\prg\newautosetup.prg"

        Local lnRow As Integer,;
            lnCol As Integer

        Try

            Store 0 To laMaxCols
            Store 0 To laMaxRows

            * Calcular Maximos
            For lnRow = 1 To loMatriz.nMaxRow
                For lnCol = 1 To loMatriz.nMaxCol
                    loCtrl =  laMatriz[ lnRow, lnCol ]
                    * laMaxCols[ lnCol ] = Max( laMaxCols[ lnCol ], loCtrl.Width + loCtrl.nGap )
                    laMaxCols[ lnCol ] = Max( laMaxCols[ lnCol ], loCtrl.Width + pnGap )
                    * laMaxRows[ lnRow ] = Max( laMaxRows[ lnRow ], loCtrl.Height + loCtrl.nGap )
                    laMaxRows[ lnRow ] = Max( laMaxRows[ lnRow ], loCtrl.Height + pnGap )
                Endfor
            Endfor

            *!*				* Aplicar Maximos
            *!*				For lnRow = 1 To loMatriz.nMaxRow
            *!*					For lnCol = 1 To loMatriz.nMaxCol
            *!*						loCtrl =  laMatriz[ lnRow, lnCol ]

            *!*						loCtrl.Width = laMaxCols[ lnCol ]
            *!*						loCtrl.Height = laMaxRows[ lnRow ]
            *!*					Endfor
            *!*				Endfor


        Catch To oErr
            Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally
            loCtrl = Null

        Endtry

    Endproc

    Procedure FillCollection( tnOption As Integer )

        Local loColObjects As Collection
        Local loControl As ControlStandard Of "fw\comunes\prg\newautosetup.prg"

        Try

            loColObjects = Createobject( "Collection" )

            Do Case
                Case tnOption = 1
                    * Un control en cada coordenada
                    For x = 1 To 4
                        For Y = 1 To 5
                            loControl = Createobject( "ControlStandard" )
                            loControl.Name = "Ctrl" + Str( x, 1 ) + Str( Y, 1 )

                            If Y > 1
                                * loControl.lSameRowAsPrevious = .T.
                                loControl.SameRowAsPrevious = .T.
                            Endif

                            loColObjects.Add( loControl, Lower(loControl.Name) )

                        Endfor
                    Endfor

                Case tnOption = 2
                    * Incorporar espacion en blanco

                    For x = 1 To 4
                        For Y = 1 To 5

                            Do Case
                                Case Y = 3 And x = 1 Or ;
                                        Y = 5 And x = 1 Or ;
                                        Y = 2 And x = 3 Or ;
                                        Y = 1 And x = 4
                                    loControl = Createobject( "ControlSeparador" )

                                Otherwise

                                    loControl = Createobject( "ControlStandard" )

                            Endcase

                            loControl.Name = "Ctrl" + Str( x, 1 ) + Str( Y, 1 )

                            If Y > 1
                                * loControl.lSameRowAsPrevious = .T.
                                loControl.SameRowAsPrevious = .T.
                            Endif

                            If Y = 5 And Lower( loControl.Class ) = Lower( "ControlSeparador" )
                                * En la última columna NO VA un separador

                            Else
                                loColObjects.Add( loControl, Lower(loControl.Name) )

                            Endif



                        Endfor
                    Endfor


                Case tnOption = 3
                    * A la opcion anterior, incorporar controles con span

                    Local llAdd As Boolean

                    For x = 1 To 4
                        For Y = 1 To 5

                            llAdd = .T.

                            Do Case
                                Case Y = 3 And x = 1 Or ;
                                        Y = 5 And x = 1 Or ;
                                        Y = 2 And x = 3 Or ;
                                        Y = 1 And x = 4
                                    loControl = Createobject( "ControlSeparador" )

                                Otherwise

                                    loControl = Createobject( "ControlStandard" )

                            Endcase

                            loControl.Name = "Ctrl" + Str( x, 1 ) + Str( Y, 1 )

                            If Y > 1
                                * loControl.lSameRowAsPrevious = .T.
                                loControl.SameRowAsPrevious = .T.
                            Endif


                            Do Case
                                Case Y = 5 And Lower( loControl.Class ) = Lower( "ControlSeparador" )
                                    * En la última columna NO VA un separador
                                    llAdd = .F.

                                Case Y = 1 And x = 2
                                    * Control con span
                                    loControl.nColSpan = 2

                                Case Y = 2 And x = 2
                                    * Ocupada por el span de y1,x2
                                    llAdd = .F.

                                Case Y = 3 And x = 3
                                    * Control con span
                                    loControl.nColSpan = 2
                                    loControl.nRowSpan = 2

                                Case Y = 4 And x = 3 Or ;
                                        y = 4 And x = 4 Or ;
                                        y = 3 And x = 4

                                    * Ocupada por el span de y3,x3
                                    llAdd = .F.


                                Otherwise

                            Endcase

                            If llAdd
                                loColObjects.Add( loControl, Lower(loControl.Name) )
                            Endif



                        Endfor
                    Endfor

                Case tnOption = 4

                Otherwise
                    Error "No definido"

            Endcase

        Catch To oErr
            Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )

        Finally

        Endtry

        Return loColObjects

    Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: NewAutoSetup
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ControlStandard
*!* ParentClass...: Container
*!* BaseClass.....: Container
*!* Description...: Control Standard
*!* Date..........: Martes 28 de Abril de 2009 (08:17:23)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ControlStandard As Container

    #If .F.
        Local This As ControlStandard Of "fw\comunes\prg\newautosetup.prg"
    #Endif

    *!*
    * lSameRowAsPrevious = .F.
    SameRowAsPrevious = .F.

    *!*
    nRowSpan = 1

    *!*
    nColSpan = 1

    Height = 27

    Width = 75

    *!*
    nGap = 5

    BackColor = Rgb(0,128,0)

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="nGap" type="property" display="nGap" />] + ;
        [<memberdata name="lsamerowasprevious" type="property" display="lSameRowAsPrevious" />] + ;
        [<memberdata name="nColSpan" type="property" display="nColSpan" />] + ;
        [<memberdata name="nRowSpan" type="property" display="nRowSpan" />] + ;
        [</VFPData>]

    Add Object lblLabel As Label With Visible = .T., BackStyle = 0
Procedure AutoSetup()
EndProc 
Enddefine
*!*
*!* END DEFINE
*!* Class.........: ControlStandard
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: ControlSeparador
*!* ParentClass...: ControlStandard Of 'fw\comunes\prg\newautosetup.prg'
*!* BaseClass.....: Container
*!* Description...: Control Separador
*!* Date..........: Martes 28 de Abril de 2009 (08:27:06)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ControlSeparador As ControlStandard Of 'fw\comunes\prg\newautosetup.prg'

    #If .F.
        Local This As ControlSeparador Of "fw\comunes\prg\newautosetup.prg"
    #Endif

    BackStyle = 0

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: ControlSeparador
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ControlSpan
*!* ParentClass...: ControlStandard Of 'fw\comunes\prg\newautosetup.prg'
*!* BaseClass.....: Container
*!* Description...: Control Separador
*!* Date..........: Martes 28 de Abril de 2009 (08:27:06)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ControlSpan As ControlStandard Of 'fw\comunes\prg\newautosetup.prg'

    #If .F.
        Local This As ControlSpan Of "fw\comunes\prg\newautosetup.prg"
    #Endif

    BackColor = Rgb(255,128,0)

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: ControlSpan
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: TestForm
*!* ParentClass...: Form
*!* BaseClass.....: Form
*!* Description...: Formulario de pruebas
*!* Date..........: Martes 28 de Abril de 2009 (08:34:01)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class TestForm As Form

    #If .F.
        Local This As TestForm Of "fw\comunes\prg\newautosetup.prg"
    #Endif

    *!* Coleccion de controles
    oColObjects = Null

    AutoCenter = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="ocolobjects" type="property" display="oColObjects" />] + ;
        [<memberdata name="addcontrols" type="method" display="AddControls" />] + ;
        [</VFPData>]


    Procedure AddControls

        Local loCtrl As ControlStandard Of "fw\comunes\prg\newautosetup.prg"
        Local lcCtrl As String

        Local lnMaxHeight As Integer,;
            lnMaxWidth As Integer

        Try


            lnMaxHeight = 0
            lnMaxWidth = 0

            For Each loCtrl In This.oColObjects
                This.AddObject( loCtrl.Name, "ControlStandard" )

                lcCtrl = loCtrl.Name

                Thisform.&lcCtrl..Top 		= loCtrl.Top
                Thisform.&lcCtrl..Left 		= loCtrl.Left
                Thisform.&lcCtrl..Height 	= loCtrl.Height
                Thisform.&lcCtrl..Width 	= loCtrl.Width


                Thisform.&lcCtrl..BackColor = loCtrl.BackColor
                Thisform.&lcCtrl..BackStyle = loCtrl.BackStyle
                Thisform.&lcCtrl..lblLabel.Caption  = loCtrl.lblLabel.Caption

                Thisform.&lcCtrl..Visible = .T.

                lnMaxHeight = Max( loCtrl.Top + loCtrl.Height + loCtrl.nGap, lnMaxHeight )
                lnMaxWidth  = Max( loCtrl.Left + loCtrl.Width + loCtrl.nGap, lnMaxWidth )

                *!*					Str = loCtrl.lblLabel.Caption + Chr(13) + ;
                *!*						"Top: " + Transform(loCtrl.Top) + Chr(13) + ;
                *!*						"Left: " + Transform(loCtrl.Left) + Chr(13) + ;
                *!*						"Clase: " + loCtrl.Class + Chr(13) + ;
                *!*						"Name: " + loCtrl.Name

                *!*					=Messagebox( Str )
            Endfor

            Thisform.Height = lnMaxHeight
            Thisform.Width  = lnMaxWidth

            Thisform.Refresh()

        Catch To oErr
            Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally
            loCtrl = Null

        Endtry


    Endproc


    Procedure Unload
        Clear Events
    Endproc



Enddefine
*!*
*!* END DEFINE
*!* Class.........: TestForm
*!*
*!* ///////////////////////////////////////////////////////