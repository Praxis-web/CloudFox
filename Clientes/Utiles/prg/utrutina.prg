#INCLUDE "FW\Comunes\Include\Praxis.h"
#Include 'Tools\DataDictionary\Include\DataDictionary.h'

*!* ///////////////////////////////////////////////////////
*!* Class.........: oColArchivos
*!* ParentClass...: oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'
*!* BaseClass.....: Collection
*!* Description...: Coleccion de archivos a los que se va a indexar
*!* Date..........: Lunes 3 de Marzo de 2014 (17:04:58)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

*Define Class oColArchivos As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'
Define Class oColArchivos As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg'

    #If .F.
        Local This As oColArchivos Of "Clientes\Utiles\Prg\utRutina.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]




Enddefine
*!*
*!* END DEFINE
*!* Class.........: oColArchivos
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Archivo
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:31:20)
*!*
*!*

Define Class Archivo As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

    #If .F.
        Local This As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
    #Endif

    * Nombre del Modelo asociado a la tabla
    cModelo = ""

    * Cuando el campo contiene una FK, indica si muestra la FK, o el
    * nombre de la FK apuntada
    lStr = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="crearcursor" type="method" display="CrearCursor" />] + ;
        [<memberdata name="validatedata" type="method" display="ValidateData" />] + ;
        [<memberdata name="setdefaults" type="method" display="SetDefaults" />] + ;
        [<memberdata name="cmodelo" type="property" display="cModelo" />] + ;
        [<memberdata name="cmodelo_access" type="method" display="cModelo_Access" />] + ;
        [<memberdata name="exportdata" type="method" display="ExportData" />] + ;
        [<memberdata name="lstr" type="property" display="lStr" />] + ;
        [</VFPData>]

    *
    *
    Procedure CrearCursor( cAlias As String ) As String
        Local lcCommand As String
        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
        Local i As Integer,;
            lnFieldCount As Integer

        Try

            lcCommand = ""
            If Empty( cAlias )
                cAlias = "c_" + This.Name + "_" + Sys(2015)
            Endif

            loColFields 	= This.oColFields
            lnFieldCount 	= loColFields.Count

            If This.lStr
                For Each loField In loColFields
                    If loField.lStr Or !Empty( loField.cGridColumnControlSource )
                        If !Empty( loField.cGridColumnControlSource )
                            lnFieldCount = lnFieldCount + 1
                        Endif
                        If loField.lStr
                            lnFieldCount = lnFieldCount + 1
                        Endif
                    Endif
                Endfor
            Endif

            Dimension laFields( lnFieldCount+10, 5 )

            i = 0
            For Each loField In loColFields

                i = i + 1

                laFields[ i, 1 ] = loField.Name
                laFields[ i, 2 ] = loField.cFieldType
                laFields[ i, 3 ] = loField.nFieldWidth
                laFields[ i, 4 ] = loField.nFieldPrecision
                laFields[ i, 5 ] = loField.lNull
                *laFields[ i, 5 ] = .F.
                
                If loField.lStr Or !Empty( loField.cGridColumnControlSource )

                    If !Empty( loField.cGridColumnControlSource )
                        i = i + 1

                        If Empty( loField.nGridMaxLength )
                            loField.nGridMaxLength = 100
                        Endif

                        laFields[ i, 1 ] = loField.cGridColumnControlSource
                        laFields[ i, 2 ] = "C"
                        laFields[ i, 3 ] = loField.nGridMaxLength
                        laFields[ i, 4 ] = 0
                        laFields[ i, 5 ] = loField.lNull

                    Endif

                    If This.lStr
                        i = i + 1

                        If Empty( loField.nGridMaxLength )
                            loField.nGridMaxLength = 100
                        Endif

                        laFields[ i, 1 ] = "Str_" + loField.Name
                        laFields[ i, 2 ] = "C"
                        laFields[ i, 3 ] = loField.nGridMaxLength
                        laFields[ i, 4 ] = 0
                        laFields[ i, 5 ] = loField.lNull

                    Endif

                Endif

            EndFor
            
            Dimension laFields( i, 5 )

            TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Cursor <<cAlias>> From Array laFields
            ENDTEXT

            &lcCommand
            lcCommand = ""

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return cAlias

    Endproc && CrearCursor


    *
    * Validar datos antes de exportarlos
    Procedure ExportData( oReg As Object ) As Object;
            HELPSTRING "Validar datos antes de exportarlos"

        *Parameters oReg As Object, oNewReg as Object

        Local lcCommand As String,;
            lcField As String,;
            lcDate As String,;
            lcCentury As String
        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
        Local i As Integer
        Local luValue As Variant,;
            luValid As Variant
        Local loReg As Object

        Try

            lcCommand = ""

            lcDate 		= Set("Date" )
            lcCentury 	= Set("Century" )

            Set Date YMD
            Set Century On

            loColFields = This.oColFields

            For Each loField In loColFields

                Try

                    lcField = loField.Name

                    luValue = Evaluate( "oReg." + lcField )

                    TEXT To lcCommand NoShow TextMerge Pretext 15
					luValid = Cast( luValue as <<loField.cFieldType>>( <<loField.nFieldWidth>>, <<loField.nFieldPrecision>> ))
                    ENDTEXT

                    &lcCommand
                    lcCommand = ""

                    Do Case
                        Case loField.cFieldType = "T"
                            luValid = Substr( luValid, 1, 19 )

                        Case Inlist( loField.cFieldType, "C", "V", "M" )
                            If loField.Ltrim
                                luValid = Alltrim( luValid )
                            Endif

                        Otherwise

                    Endcase

                    * La información se envía al Servidor
                    * Transforma los Empty en Nulls, si corresponde

                    If Empty( luValid ) And ( loField.lNull )

                        luValid = Null

                    Endif

                    TEXT To lcCommand NoShow TextMerge Pretext 15
					oReg.<<lcField>> = luValid
                    ENDTEXT

                    &lcCommand
                    lcCommand = ""

                Catch To oErr

                Finally

                Endtry

            Endfor

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry


    Endproc && ExportData


    *
    *
    * Recibe un Registro y valida los tipos de datos
    Procedure ValidateData( oReg As Object,;
            lcAlias As String ) As Object

        Local lcCommand As String,;
            lcDate As String,;
            lcCentury As String
        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
        Local i As Integer
        Local luValue As Variant,;
            luValid As Variant
        Local loReg As Object


        Local lcFieldName As String,;
            lcFieldType As String,;
            lnFieldWidth As Integer,;
            lnnFieldPrecision As Integer

        Try

            lcCommand = ""

            lcDate 		= Set("Date" )
            lcCentury 	= Set("Century" )

            Set Date YMD
            Set Century On

            loColFields = This.oColFields

            Select Alias( lcAlias )
            Append Blank
            Scatter Name loReg Memo

            For Each loField In loColFields

                Try

                    lcFieldName 		= loField.Name
                    lcFieldType 		= loField.cFieldType
                    lnFieldWidth 		= loField.nFieldWidth
                    lnFieldPrecision 	= loField.nFieldPrecision

                    If loField.lStr
                        If This.lStr
                            If Empty( loField.nGridMaxLength )
                                loField.nGridMaxLength = 100
                            Endif

                            lcFieldName 		= "Str_" + loField.Name
                            lcFieldType 		= "C"
                            lnFieldWidth 		= loField.nGridMaxLength
                            lnFieldPrecision 	= 0

                        Endif
                    Endif

                    luValue = Evaluate( "oReg." + lcFieldName )

                    If Vartype( luValue ) # "O"

                        If lcFieldType = "T"
                            luValue = Substr( luValue, 1, 19 )
                        Endif

                        TEXT To lcCommand NoShow TextMerge Pretext 15
						luValid = Cast( luValue as <<lcFieldType>>( <<lnFieldWidth>>, <<lnFieldPrecision>> ))
                        ENDTEXT

                        &lcCommand
                        lcCommand = ""

                        * La información llega del server
                        * Transforma los Nulls en Empty

                        If Isnull( luValid )
                            Do Case
                                Case Inlist( lcFieldType, "C", "V" )
                                    luValid = Space( lnFieldWidth )

                                Case Inlist( lcFieldType, "M" )
                                    luValid = ""

                                Case Inlist( lcFieldType, "D" )
                                    luValid = Ctod( "" )

                                Case Inlist( lcFieldType, "T" )
                                    luValid = Ctot( "" )

                                Case Inlist( lcFieldType, "I", "N" )
                                    luValid = 0

                                Case Inlist( lcFieldType, "L" )
                                    luValid = .F.

                                Otherwise

                            Endcase

                        Endif

                        TEXT To lcCommand NoShow TextMerge Pretext 15
						loReg.<<lcFieldName>> = luValid
                        ENDTEXT

                        &lcCommand
                        lcCommand = ""

                    Else
                        AddProperty( loReg, lcFieldName, luValue )

                    Endif

                Catch To oErr

                Finally

                Endtry

            Endfor

            If Pemstatus( oReg, "r7Mov", 5 )
                AddProperty( loReg, "r7Mov", oReg.r7Mov )
            Endif

            If Pemstatus( oReg, "ABM", 5 )
                AddProperty( loReg, "ABM", oReg.ABM )
            Endif

            If Pemstatus( oReg, "_RecordOrder", 5 )
                AddProperty( loReg, "_RecordOrder", oReg._RecordOrder )
            Endif

            Select Alias( lcAlias )
            Gather Name loReg Memo


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            Set Date &lcDate
            Set Century &lcCentury


        Endtry

        Return loReg

    Endproc && ValidateData


    *
    *
    Procedure SetDefaults( oReg As Object, loBiz As Object ) As Object
        Local lcCommand As String,;
            lcField As String,;
            lcParentFieldName As String,;
            lcDate As String,;
            lcCentury As String
        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loParent As oModelo Of "FrontEnd\Prg\Modelo.prg"
        Local i As Integer
        Local luValue As Variant,;
            luDefault As Variant,;
            luParentValue As Variant
        Local loReg As Object
        Local llAlta As Boolean

        Try

            lcCommand = ""

            llAlta = .F.
            loColFields = This.oColFields
            loReg = Createobject( "Empty" )
            lcParentFieldName = ""
            luParentValue = .F.

            If Pemstatus( loReg, "ABM", 5 )
                llAlta = ( loReg.ABM = ABM_ALTA )
            Endif

            If Vartype( loBiz ) == "O"
                If loBiz.lIsChild
                    loParent 			= loBiz.oParent
                    lcParentFieldName 	= loParent.cModelo
                    luParentValue 		= loParent.nId
                Endif
            Endif

            lcDate 		= Set("Date" )
            lcCentury 	= Set("Century" )

            Set Date YMD
            Set Century On

            For Each loField In loColFields

                Try

                    * RA 10/09/2021(12:40:16)
                    * Si el campo no existe en el registro recibido. no da error

                    lcField = loField.Name

                    If !Isnull( loField.Default )
                        luValue = loField.Default

                    Else
                        luValue = Evaluate( "oReg." + lcField )

                    Endif

                    If loBiz.lIsChild
                        Do Case
                            Case Lower( loField.cFK_Modelo ) = Lower( loParent.cModelo )
                                luValue = luParentValue

                            Case Lower( lcField ) == Lower( lcParentFieldName )
                                luValue = luParentValue

                        Endcase
                    Endif

                    If Lower( lcField ) == "cliente_praxis"
                        If Empty( luValue )
                            luValue = loBiz.nClientePraxis
                        Endif
                    Endif

                    TEXT To lcCommand NoShow TextMerge Pretext 15
					luDefault = Cast( luValue as <<loField.cFieldType>>( <<loField.nFieldWidth>>, <<loField.nFieldPrecision>> ))
                    ENDTEXT

                    &lcCommand
                    lcCommand = ""

                    AddProperty( loReg, lcField, luDefault )

                Catch To oErr

                Finally

                Endtry

            EndFor
            
            

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            Set Date &lcDate
            Set Century &lcCentury
            oReg = Null

        Endtry

        Return loReg

    Endproc && SetDefaults

    *
    * cModelo_Access
    Protected Procedure cModelo_Access()
        If Empty( This.cModelo )
            This.cModelo = This.Name
        Endif

        Return This.cModelo

    Endproc && cModelo_Access




Enddefine
*!*
*!* END DEFINE
*!* Class.........: Archivo
*!*
*!* ///////////////////////////////////////////////////////
