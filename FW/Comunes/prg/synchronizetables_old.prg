Lparameters tcTableName As String,;
    tcSource As String,;
    tcTarget As String

Local lnLenSource As Integer
Local lnLenTarget As Integer
Local Array laSource[ 1 ], laTarget[ 1 ]
Local i As Integer,;
    j As Integer,;
    k As Integer

Local llAlert As Boolean,;
    llConfirm As Boolean,;
    llBackUp As Boolean,;
    llModify As Boolean

Local lcPrecision As String,;
    lcTexto As String
Local lcDatoActual As String,;
    lcDatoNuevo As String
Local lcCommand As String
Local lcOldDeleted As String

Try

    lcOldDeleted = Set("Deleted")

    Set Deleted Off

    Wait Window Nowait "Sincronizando Tabla " + tcTableName

    If Empty( tcSource )
        tcSource = 'cSource'
    Endif

    If Empty( tcTarget )
        tcTarget = 'fTarget'
    Endif

    llBackUp = .F.
    llModify = .F.

    lnLenSource = Afields( laSource, tcSource )
    lnLenTarget = Afields( laTarget, tcTarget )

    lcCommand = ""

    For i = 1 To lnLenSource
        k = Ascan( laTarget, laSource[ i, 1 ], -1, -1, 1, 15 )

        If Empty( k )
            * ADD COLUMN
            llModify = .T.

        Else

            * ALTER COLUMN
            If Inlist( laSource[ i, 2 ], "D", "T", "I", "L", "M" ) Or ;
                    ( laSource[ i, 2 ] = laTarget[ k, 2 ] ;
                    And laSource[ i, 3 ] = laTarget[ k, 3 ] ;
                    And laSource[ i, 4 ] = laTarget[ k, 4 ] )

                * Todo Ok
            Else

                Do Case
                    Case Inlist( laSource[ i, 2 ], "D", "T", "I", "L", "M" )
                        lcPrecision = ""

                    Case Inlist( laSource[ i, 2 ], "C" )
                        lcPrecision = "(" + Transform( laSource[ i, 3 ] ) + ")"

                    Case Inlist( laSource[ i, 2 ], "N" )
                        lcPrecision = "(" + Transform( laSource[ i, 3 ] ) + "," + Transform( laSource[ i, 4 ] ) + ")"

                    Otherwise

                        lcPrecision = "(" + Transform( laSource[ i, 3 ] )

                        If Empty( laSource[ i, 4 ] )
                            lcPrecision = lcPrecision + ")"

                        Else
                            lcPrecision = lcPrecision + "," + Transform( laSource[ i, 4 ] ) + ")"

                        Endif

                Endcase

                llAlert = .F.


                If Inlist( laTarget[ k, 2 ], "N", "C" ) And laTarget[ k, 2 ] # laSource[ i, 2 ]
                    llAlert = .T.
                Endif

                If !llAlert

                    If Inlist( laTarget[ k, 2 ], "N", "C" )

                        If laTarget[ k, 3 ] > laSource[ i, 3 ]
                            llAlert = .T.
                        Endif

                        If laTarget[ k, 4 ] > laSource[ i, 4 ]
                            llAlert = .T.
                        Endif
                    Endif

                Endif

                llConfirm = .T.

                If llAlert

                    lcDatoNuevo = laSource[ i, 2 ] + lcPrecision

                    Do Case
                        Case Inlist( laTarget[ k, 2 ], "D", "T", "I", "L", "M" )
                            lcDatoActual = ""

                        Case Inlist( laTarget[ k, 2 ], "C" )
                            lcDatoActual = "(" + Transform( laTarget[ k, 3 ] ) + ")"

                        Case Inlist( laTarget[ k, 2 ], "N" )
                            lcDatoActual = "(" + Transform( laTarget[ k, 3 ] ) + "," + Transform( laTarget[ k, 4 ] ) + ")"

                        Otherwise

                            lcDatoActual = "(" + Transform( laTarget[ k, 3 ] )

                            If Empty( laTarget[ k, 4 ] )
                                lcDatoActual = lcDatoActual + ")"

                            Else
                                lcDatoActual = lcDatoActual + "," + Transform( laTarget[ k, 4 ] ) + ")"

                            Endif

                    Endcase

                    lcDatoActual = laTarget[ k, 2 ] + lcDatoActual


                    TEXT To lcTexto NoShow TextMerge Pretext 03
					ATENCION
					TABLA: '<<tcTableName>>'
					CAMPO: <<laSource[ i, 1 ]>>
					TIPO ACTUAL: <<lcDatoActual>>
					TIPO NUEVO :  <<lcDatoNuevo>>

					EXISTE RIESGO DE PERDER INFORMACION

					¿CONFIRMA?
                    ENDTEXT

                    llConfirm = Confirm( lcTexto, "Sincronizando Tablas", .F. )

                Else
                    lcDatoNuevo = laSource[ i, 2 ] + lcPrecision
                Endif

                If llAlert Or llConfirm
                    llModify = .T.

                    If !llBackUp
                        BackUp( tcTableName, tcTarget )
                        llBackUp = .T.
                    Endif

                    If llConfirm
                        TEXT To lcCommand NoShow TextMerge Pretext 15
						ALTER TABLE '<<tcSource>>' ALTER COLUMN <<laSource[ i, 1 ]>> <<lcDatoNuevo>>
                        ENDTEXT

                        &lcCommand
                    Endif
                Endif

            Endif

        Endif

    Endfor


    For j = 1 To lnLenTarget

        k = Ascan( laSource, laTarget[ j, 1 ], -1, -1, 1, 15 )

        If Empty( k )

            * DROP COLUMN

            TEXT To lcTexto NoShow TextMerge Pretext 03
			¿Elimina el campo <<laTarget[ j, 1 ]>>
			de la tabla '<<tcTableName>>'?
            ENDTEXT

            If Confirm( lcTexto, "Sincronizando Tablas", .F. )

                llModify = .T.

                If !llBackUp
                    BackUp( tcTableName, tcTarget )
                    llBackUp = .T.
                Endif

            Else

                *!*					TEXT To lcCommand NoShow TextMerge Pretext 15
                *!*					ALTER TABLE '<<tcTableName>>' DROP COLUMN <<laTarget[ j, 1 ]>>
                *!*					ENDTEXT

                *!*					&lcCommand

                Do Case
                    Case Inlist( laTarget[ j, 2 ], "D", "T", "I", "L", "M" )
                        lcPrecision = ""

                    Case Inlist( laTarget[ j, 2 ], "C" )
                        lcPrecision = "(" + Transform( laTarget[ j, 3 ] ) + ")"

                    Case Inlist( laTarget[ j, 2 ], "N" )
                        lcPrecision = "(" + Transform( laTarget[ j, 3 ] ) + "," + Transform( laTarget[ j, 4 ] ) + ")"

                    Otherwise

                        lcPrecision = "(" + Transform( laTarget[ j, 3 ] )

                        If Empty( laTarget[ j, 4 ] )
                            lcPrecision = lcPrecision + ")"

                        Else
                            lcPrecision = lcPrecision + "," + Transform( laTarget[ j, 4 ] ) + ")"

                        Endif

                Endcase

                TEXT To lcCommand NoShow TextMerge Pretext 15
				ALTER TABLE '<<tcSource>>' ADD COLUMN <<laTarget[ j, 1 ]>> <<laTarget[ j, 2 ]>><<lcPrecision>>
                ENDTEXT

                &lcCommand

            Endif

        Endif

    Endfor

    If llModify
        Local lcFileName As String

        Use In Select( tcTarget )

        lcFileName = Addbs(Justpath( tcTableName )) + Sys(2015)

        Select Alias( tcSource )
        Copy Structure To (lcFileName)

        Use (lcFileName) Exclusive In 0
        Select Alias( Juststem( lcFileName ))

        TEXT To lcCommand NoShow TextMerge Pretext 15
		Append From "<<tcTableName>>" for !Deleted()
        ENDTEXT

        &lcCommand

        Close Databases All

        Erase ( tcTableName + ".DBF" )
        Erase ( tcTableName + ".DBT" )
        Erase ( tcTableName + ".FPT" )

        Rename ( lcFileName + ".DBF" ) To ( tcTableName + ".DBF" )

        If File( lcFileName + ".FPT" )
            Rename ( lcFileName + ".FPT" ) To ( tcTableName + ".FPT" )
        Endif

        Use '&tcTableName.' Exclusive Alias &tcTarget

    Endif

Catch To oErr
    Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

    loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
    loError.cRemark = lcCommand
    loError.Process( oErr )
    Throw loError

Finally
    Set Deleted &lcOldDeleted

    If Used( tcTarget )
        Select Alias( tcTarget )
    Endif


Endtry


*
*
Procedure BackUp( tcFileName As String, tcTarget As String ) As Void

    Local i As Integer
    Local lcBackUp As String,;
        lcFolder As String,;
        lcCommand As String

    Try
        i = 1
        lcFolder = Addbs( Justpath( tcFileName ) )
        lcBackUp = lcFolder + Proper( Juststem( tcFileName )) + "_" + Transform(i) + ".bk" + Transform(i)
        Do While File( lcBackUp )
            i = i + 1
            lcBackUp = lcFolder + Proper( Juststem( tcFileName )) + "_" + Transform(i) + ".bk" + Transform(i)
        Enddo

        Wait Window Nowait "Haciendo Backup de " + Juststem( tcFileName )

        Select Alias( tcTarget )

        TEXT To lcCommand NoShow TextMerge Pretext 15
		Copy To '<<lcBackUp>>' Type Foxplus
        ENDTEXT

        &lcCommand

    Catch To oErr
        Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

        loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
        loError.Process( oErr )
        Throw loError

    Finally
        Wait Window Nowait "Sincronizando Tabla " + tcFileName

    Endtry

Endproc && BackUp