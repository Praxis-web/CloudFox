#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oField.prg'
    Do 'Tools\DataDictionary\prg\oColBase.prg'
    Do 'ErrorHandler\Prg\ErrorHandler.prg'

Endif

* oColFields
* Colección de capos de una tabla.
Define Class oColFields As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'

    #If .F.
        Local This As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg'
    #Endif


    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="addfield" type="method" display="AddField" />] ;
        + [<memberdata name="new" type="method" display="New" />] ;
        + [<memberdata name="newcandidate" type="method" display="NewCandidate" />] ;
        + [<memberdata name="newfk" type="method" display="NewFK" />] ;
        + [<memberdata name="newpk" type="method" display="NewPK" />] ;
        + [<memberdata name="newm2m" type="method" display="NewM2M" />] ;
        + [<memberdata name="newregular" type="method" display="NewRegular" />] ;
        + [<memberdata name="newvirtual" type="method" display="NewVirtual" />] ;
        + [<memberdata name="newwebfield" type="method" display="NewWebField" />] ;
        + [<memberdata name="newbinary" type="method" display="NewBinary" />] ;
        + [</VFPData>]

    Dimension AddField_COMATTRIB[ 5 ]
    AddField_COMATTRIB[ 1 ] = 0
    AddField_COMATTRIB[ 2 ] = 'Devuelve .T. si se agrego el campo a la colección de campos.'
    AddField_COMATTRIB[ 3 ] = 'AddField'
    AddField_COMATTRIB[ 4 ] = 'Boolean'
    * AddField_COMATTRIB[ 5 ] = 0

    * AddField
    * Devuelve .T. si se agrego el campo a la colección de campos.
    Function AddField ( toField As oField Of 'Tools\DataDictionary\prg\oField.prg' ) As Boolean HelpString 'Devuelve .T. si se agrego el campo a la colección de campos.'

        Local lcKey As String, ;
            liIdx As Integer, ;
            llRet As Boolean, ;
            loErr As Exception


        Local lcCommand As String

        Try

            lcCommand = ""
            lcKey = Lower ( m.toField.Name )
            liIdx = This.GetKey ( m.lcKey )
            If Empty ( m.liIdx )
                toField.oParent = This.oParent
                * This.AddItem ( m.toField, m.lcKey )
                This.Add( m.toField, m.lcKey )
                llRet = .T.
            Endif && Empty( m.liIdx )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return m.llRet

    Endfunc && AddField

    * Comment_Assign
    Protected Function Comment_Assign ( tcComment As String ) As String

        Local lcStr As String, ;
            lnLen As Integer

        Local lcCommand As String

        Try

            lcCommand = ""
            lnLen = Len ( m.tcComment )
            If m.lnLen > 253
                TEXT To m.lcStr Textmerge Noshow Pretext 15
				La Propiedad <<This.Name>>.Comment es demasiado largo(<<m.lnLen>>)
				m.tcComment
                ENDTEXT
                lcStr = m.lcStr + CR + CR + m.tcComment
                Error m.lcStr

            Else
                This.Comment = m.tcComment

            Endif && Len( tcNewVal) > 253


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry

        Return This.Comment

    Endfunc && Comment_Assign

    Dimension New_COMATTRIB[ 5 ]
    New_COMATTRIB[ 1 ] = 0
    New_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oField.'
    New_COMATTRIB[ 3 ] = 'New'
    New_COMATTRIB[ 4 ] = 'oField'
    * New_COMATTRIB[ 5 ] = 0

    * New
    * Devuelve una nueva instancia de oField.
    Function New ( tcName As String,;
            tcFieldType As String,;
            tnFieldWidth As Integer,;
            tnFieldPrecision As Integer,;
            tlIsWebField As Boolean ) As oField  ;
            HelpString 'Devuelve una nueva instancia de oField.'

        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'

        Local lcCommand As String

        Try

            lcCommand = ""

            lcKey = Lower (  m.tcName )
            liIdx = This.GetKey ( m.lcKey )
            If Empty ( m.liIdx )
                loField = _NewObject ( 'oField', 'Tools\DataDictionary\prg\oField.prg', '' )
                If Vartype ( m.tcName ) == 'C'
                    loField.Name = m.tcName

                Endif && Vartype( m.tcName ) == "C"
                loField.oParent = This.oParent

                If !tlIsWebField
                    This.Add( m.loField, m.lcKey )
                Endif

            Else
                m.loField = This.GetItem( m.liIdx )
                * RA 31/10/2018(11:51:17)
                * Conservar lo existente, salvo que venga modificado por parámetros
                *!*					loField.nFieldWidth 		 = 0
                *!*					loField.nFieldPrecision 	 = 0
                *!*					loField.cFieldType           = ''
                *!*					loField.cDisplayClass        = ''
                *!*					loField.cDisplayClassLibrary = ''

            Endif && This.AddField( m.loField )

            If Vartype ( m.tnFieldWidth ) == 'N'
                loField.nFieldWidth = m.tnFieldWidth

            Endif && Vartype( m.tnFieldWidth ) == "N"

            If Vartype ( m.tnFieldPrecision ) == 'N'
                loField.nFieldPrecision = m.tnFieldPrecision

            Endif && Vartype( m.tnFieldPrecision ) == "N"

            *loField.cDisplayClassLibrary = IB_DISPLAYCLASSLIBRARY

            If Vartype ( m.tcFieldType ) == 'C'

                tcFieldType = Lower ( m.tcFieldType )

                Do Case
                    Case Inlist ( m.tcFieldType, 'c', 'char', 'character' )
                        loField.cFieldType    	= 'C'
                        *loField.cDisplayClass 	= IB_STRING
                        loField.cInputMask    	= Replicate ('X', loField.nFieldWidth )
                        loField.nLength			= 30

                        loField.oCurrentControl.Name			= 'txt' + loField.Name
                        loField.oCurrentControl.Class			= "TextBoxBase"
                        loField.oCurrentControl.ClassLibrary	= "Clientes\Utiles\prg\utDataDictionary.prg"

                    Case Inlist ( m.tcFieldType, 'v', 'varchar' )
                        loField.cFieldType    	= 'V'
                        *loField.cDisplayClass 	= IB_STRING
                        loField.nLength	= 		30

                        loField.oCurrentControl.Name			= 'txt' + loField.Name
                        loField.oCurrentControl.Class			= "TextBoxBase"
                        loField.oCurrentControl.ClassLibrary	= "Clientes\Utiles\prg\utDataDictionary.prg"

                    Case Inlist ( m.tcFieldType, 't', 'datetime' )
                        loField.cFieldType    	= 'T'
                        *loField.cDisplayClass = IB_DATE
                        loField.lNull 			= .T.

                    Case Inlist ( m.tcFieldType, 'd', 'date' )
                        loField.cFieldType    	= 'D'
                        *loField.cDisplayClass = IB_DATE
                        loField.nLength      	= 10
                        loField.lNull 			= .T.

                    Case Inlist ( m.tcFieldType, 'i', 'int', 'integer', 'long' )
                        loField.cFieldType    = 'I'
                        *loField.cDisplayClass = IB_NUMERIC
                        loField.nLength      	= 6
                        loField.nFieldPrecision = 0 
                        loField.cInputMask    	= m.Control.ConvertInputMask ( m.loField.nLength, 0, '9', .F. )
                        loField.cFormat       	= 'RK'

                        loField.oCurrentControl.Name			= 'num' + loField.Name
                        loField.oCurrentControl.Class			= "numTextBoxBase"
                        loField.oCurrentControl.ClassLibrary	= "Clientes\Utiles\prg\utDataDictionary.prg"

                    Case Inlist ( m.tcFieldType, 'n', 'num', 'numeric' )
                        loField.cFieldType    = 'N'
                        *loField.cDisplayClass = IB_NUMERIC
                        loField.cInputMask    = m.Control.ConvertInputMask ( loField.nFieldWidth, loField.nFieldPrecision, '9', .T. )
                        loField.cFormat       = 'RK'
                        
                        loField.nMaxValue 	= Val(Replicate("9", loField.nFieldWidth ))
                        If loField.nFieldPrecision > 0
							loField.nMaxValue = Int( loField.nMaxValue / ( 10 * ( loField.nFieldPrecision + 1 )))
                        EndIf
                        loField.nLowValue  	= 0

                        loField.oCurrentControl.Name			= 'num' + loField.Name
                        loField.oCurrentControl.Class			= "numTextBoxBase"
                        loField.oCurrentControl.ClassLibrary	= "Clientes\Utiles\prg\utDataDictionary.prg"

                    Case Inlist ( m.tcFieldType, 'm', 'memo' )
                        loField.cFieldType    = 'M'
                        *loField.cDisplayClass = IB_EDITBOX
                        loField.nLength      = 50

                    Case Inlist ( m.tcFieldType, 'l', 'logical', 'boolean', 'bit' )
                        loField.lIsLogical   = .T.
                        loField.cFieldType    = 'L'
                        loField.Default      = FALSE
                        *loField.cDisplayClass = IB_CHECKBOX
                        *!*								loField.nLength      = 1
                        *!*								loField.cInputMask    = m.Control.ConvertInputMask ( m.loField.nLength, 0, '9', .F. )
                        loField.oCurrentControl.Name			= 'chk' + loField.Name
                        loField.oCurrentControl.Class			= "ChkLogical"
                        loField.oCurrentControl.ClassLibrary	= "Clientes\Utiles\prg\utDataDictionary.prg"


                    Case Inlist ( m.tcFieldType, 'w', 'blob' )
                        loField.cFieldType           = 'W'
                        *loField.cDisplayClass        = ''
                        *loField.cDisplayClassLibrary = ''
                        loField.nLength             = 50

                    Case Inlist ( m.tcFieldType, 'y', 'currency', 'money' )
                        loField.cFieldType    = 'Y'
                        *loField.cDisplayClass = IB_NUMERIC
                        loField.cFormat       = '$Z'
                        loField.cInputMask    = m.Control.ConvertInputMask ( m.loField.nFieldWidth, m.loField.nFieldPrecision, '9', .T. )
                        loField.cFormat       = 'RK'

                        loField.oCurrentControl.Name			= 'num' + loField.Name
                        loField.oCurrentControl.Class			= "numTextBoxBase"
                        loField.oCurrentControl.ClassLibrary	= "Clientes\Utiles\prg\utDataDictionary.prg"


                    Case Inlist ( m.tcFieldType, 'g', 'general' )
                        loField.cFieldType           = 'G'
                        *loField.cDisplayClass        = ''
                        *loField.cDisplayClassLibrary = ''

                    Case Inlist ( m.tcFieldType, 'q', 'varbinary' )
                        loField.cFieldType           = 'Q'
                        *loField.cDisplayClass        = ''
                        *loField.cDisplayClassLibrary = ''

                    Case Inlist ( m.tcFieldType, 'f', 'float' )
                        * Included for compatibility, the Float data type is functionally equivalent to Numeric.
                        * Same as Numeric
                        loField.cFieldType    = 'F'
                        *loField.cDisplayClass = IB_NUMERIC
                        *loField.cInputMask    = m.Control.ConvertInputMask ( m.loField.nFieldWidth, loField.nFieldPrecision, '#', .T. )
                        *!*								loField.cFormat       = 'RK'
                        loField.oCurrentControl.Name			= 'bum' + loField.Name
                        loField.oCurrentControl.Class			= "numTextBoxBase"
                        loField.oCurrentControl.ClassLibrary	= "Clientes\Utiles\prg\utDataDictionary.prg"


                    Case Inlist ( m.tcFieldType, 'b', 'double' )
                        loField.cFieldType    = 'B'
                        *loField.cDisplayClass = IB_NUMERIC
                        loField.cInputMask    = m.Control.ConvertInputMask ( m.loField.nFieldWidth, m.loField.nFieldPrecision, '9', .T. )
                        loField.cFormat       = 'RK'

                        loField.oCurrentControl.Name			= 'num' + loField.Name
                        loField.oCurrentControl.Class			= "numTextBoxBase"
                        loField.oCurrentControl.ClassLibrary	= "Clientes\Utiles\prg\utDataDictionary.prg"

                    Case Inlist ( m.tcFieldType, 'm2m' )
                        loField.cFieldType    	= 'O'
                        *loField.cDisplayClass 	= IB_LISTBOX
                        loField.nLength			= 25

                    Otherwise

                Endcase

            Endif && Vartype( m.tcFieldType ) == "C"

            loField.cFilterDataType 	= loField.cFieldType
            loField.cFilterFieldName 	= loField.Name

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry


        Return m.loField

    Endfunc && New

    Dimension NewCandidate_COMATTRIB[ 5 ]
    NewCandidate_COMATTRIB[ 1 ] = 0
    NewCandidate_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oField vacío configurado como Candidate.'
    NewCandidate_COMATTRIB[ 3 ] = 'NewCandidate'
    NewCandidate_COMATTRIB[ 4 ] = 'oField'
    * NewCandidate_COMATTRIB[ 5 ] = 0

    * NewCandidate
    * Devuelve una nueva instancia de oField vacío configurado como Candidate.
    Function NewCandidate ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'Tools\DataDictionary\prg\oField.prg' HelpString 'Devuelve una nueva instancia de oField vacío configurado como Candidate.'

        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
        Local lcCommand As String

        Try

            lcCommand = ""


            With This

                If Vartype( tcFieldType ) # 'C'
                    tcFieldType = 'I'
                Endif && Vartype( tcFieldType ) # 'C'

                If ! Empty ( m.tcName )
                    loField              = This.New ( m.tcName, m.tcFieldType, m.tnFieldWidth, m.tnFieldPrecision )
                    *loField.nIndexKey     = IK_CANDIDATE_KEY
                    *!*						loField.cCheck        = ' ! Empty( ' + m.tcName + ' )'
                    *!*						loField.cErrorMessage = 'El Campo ' + m.tcName + ' es obligatorio.'

                    If Inlist ( Lower ( m.tcFieldType ), 'c', 'char', 'character', 'v', 'varchar' )
                        loField.lCaseSensitive = .F.

                    Endif && Inlist( Lower( m.tcFieldType ), "c", "char", "character", "v", "varchar" )

                Else && ! Empty ( m.tcName )
                    loField = Null

                Endif && ! Empty( m.tcName )

            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry
        Return m.loField

    Endfunc && NewCandidate

    Dimension NewFK_COMATTRIB[ 5 ]
    NewFK_COMATTRIB[ 1 ] = 0
    NewFK_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oField configurado como ForeignKey.'
    NewFK_COMATTRIB[ 3 ] = 'NewFK'
    NewFK_COMATTRIB[ 4 ] = 'oField'
    * NewFK_COMATTRIB[ 5 ] = 0

    * NewFK
    * Devuelve una nueva instancia de oField configurado como ForeignKey.
    Function NewFK ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'Tools\DataDictionary\prg\oField.prg' HelpString 'Devuelve una nueva instancia de oField configurado como ForeignKey.'

        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'

        Local lcCommand As String

        Try

            lcCommand = ""


            If Vartype ( tcFieldType ) # 'C'
                tcFieldType = 'Integer'

            Endif && Vartype ( tcFieldType ) # 'C'

            loField = This.New ( tcName, tcFieldType,  tnFieldWidth, tnFieldPrecision )

            *loField.nIndexKey = IK_FOREIGN_KEY
            *loField.cDisplayClass = IB_COMBO

            If ! Empty ( tcName )
                *!*					loField.cCheck        = '! Empty( ' + tcName + ' )'
                *!*					loField.cErrorMessage = 'El campo ' + tcName + ' es obligatorio.'

            Endif

            loField.nLength = 25
            loField.lStr 	= .T.
            loField.lNull 	= .T. 

            loField.oCurrentControl.Name			= 'cbo' + loField.Name
            loField.oCurrentControl.Class			= "ComboBoxBase"
            loField.oCurrentControl.ClassLibrary	= "Clientes\Utiles\prg\utDataDictionary.prg"


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry

        Return loField

    Endfunc && NewFK


    Dimension NewBinary_COMATTRIB[ 5 ]
    NewFK_COMATTRIB[ 1 ] = 0
    NewFK_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oField configurado como Binario.'
    NewFK_COMATTRIB[ 3 ] = 'NewBinary'
    NewFK_COMATTRIB[ 4 ] = 'oField'
    * NewFK_COMATTRIB[ 5 ] = 0

    * NewBinary
    * Devuelve una nueva instancia de oField configurado como Binario.
    Function NewBinary ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'Tools\DataDictionary\prg\oField.prg' HelpString 'Devuelve una nueva instancia de oField configurado como ForeignKey.'

        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'

        Local lcCommand As String

        Try

            lcCommand = ""

            If Vartype ( tcFieldType ) # 'C'
                tcFieldType = 'Logical'

            Endif && Vartype ( tcFieldType ) # 'C'

            loField = This.New ( tcName, tcFieldType,  tnFieldWidth, tnFieldPrecision )

            *loField.nIndexKey 		= IK_BINARY_KEY
            *loField.cForExpression 	= ""
            *loField.cCollate 		= ""
            loField.lNull 			= .F.
            *loField.cDisplayClass 	= IB_CHECKBOX

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry

        Return loField

    Endfunc && NewBinary

    Dimension NewPK_COMATTRIB[ 5 ]
    NewPK_COMATTRIB[ 1 ] = 0
    NewPK_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oField configurado con el tipo de dato integer autoinc.'
    NewPK_COMATTRIB[ 3 ] = 'NewPK'
    NewPK_COMATTRIB[ 4 ] = 'oField'
    * NewPK_COMATTRIB[ 5 ] = 0

    * NewPK
    * Devuelve una nueva instancia de oField configurado con el tipo de dato integer autoinc.
    Function NewPK ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'Tools\DataDictionary\prg\oField.prg' HelpString 'Devuelve una nueva instancia de oField configurado con el tipo de dato integer autoinc.'

        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
        Local lcCommand As String

        Try

            lcCommand = ""

            If .F. && This.oParent.lIsFree
                loField = This.NewCandidate( tcName, tcFieldType, tnFieldWidth, tnFieldPrecision )

            Else && This.oParent.lIsFree
                If Vartype( tcFieldType ) # 'C'
                    loField = This.New( tcName, 'I' )
                    *!*						loField.lAutoinc = .T.
                    loField.lAutoinc = !This.oParent.lIsFree

                Else && Vartype( tcFieldType ) # 'C'
                    loField = This.New( m.tcName, m.tcFieldType, m.tnFieldWidth, m.tnFieldPrecision )

                Endif && Vartype( tcFieldType ) # 'C'

                *loField.nIndexKey      = IK_PRIMARY_KEY
                loField.lIsSystem     = .T.
                loField.lIsPrimaryKey = .T.
                If ! Empty ( m.tcName )
                    *!*						loField.cCheck         = ' ! Empty( ' + m.tcName + ' )'
                    *!*						loField.cErrorMessage  = 'El Campo ' + m.tcName + ' es obligatorio.'
                    *!*						loField.cTagName       = Substr ( 'PK' + m.loField.Name, 1, 10 )
                    *loField.cTagName       = Substr ( m.loField.Name, 1, 10 )

                    If Lower ( Right ( m.tcName, 2 )) == 'id'
                        loField.cCaption = Substr ( m.tcName, 1, Len ( m.tcName ) - 2 )

                    Endif &&  Lower( Right( m.tcName, 2 )) == 'id'
                Else
                    loField = Null

                Endif && ! Empty( m.tcName )

            Endif && This.oParent.lIsFree


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry

        Return m.loField

    Endfunc && NewPK

    Dimension NewRegular_COMATTRIB[ 5 ]
    NewRegular_COMATTRIB[ 1 ] = 0
    NewRegular_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oField configurado con un indice del tipo regular.'
    NewRegular_COMATTRIB[ 3 ] = 'NewRegular'
    NewRegular_COMATTRIB[ 4 ] = 'oField'
    * NewRegular_COMATTRIB[ 5 ] = 0

    * NewRegular
    * Devuelve una nueva instancia de oField configurado con un indice del tipo regular.
    Procedure NewRegular ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'Tools\DataDictionary\prg\oField.prg' HelpString 'Devuelve una nueva instancia de oField configurado con un indice del tipo regular.'

        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
        Local lcCommand As String

        Try

            lcCommand = ""

            loField          = This.New ( m.tcName, m.tcFieldType, m.tnFieldWidth, m.tnFieldPrecision )
            *loField.nIndexKey = IK_REGULAR


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry

        Return m.loField

    Endproc && NewRegular

    Dimension NewVirtual_COMATTRIB[ 5 ]
    NewVirtual_COMATTRIB[ 1 ] = 0
    NewVirtual_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oField configurado como campo virtual.'
    NewVirtual_COMATTRIB[ 3 ] = 'NewVirtual'
    NewVirtual_COMATTRIB[ 4 ] = 'oField'
    * NewVirtual_COMATTRIB[ 5 ] = 0

    * NewVirtual
    * Devuelve una nueva instancia de oField configurado como campo virtual.
    * Este elemento no se persiste en la base de datos.
    Function NewVirtual ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'Tools\DataDictionary\prg\oField.prg' HelpString 'Devuelve una nueva instancia de oField configurado como campo virtual.'

        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
        Local lcCommand As String

        Try

            lcCommand = ""


            loField                 = This.New ( m.tcName, m.tcFieldType, m.tnFieldWidth, m.tnFieldPrecision )
            loField.lIsVirtual      = .T.
            *loField.lSaveInDataBase = .F.


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry
        Return m.loField

    Endfunc && NewVirtual

    * NewWebField
    * Devuelve una nueva instancia de oField configurado como campo de la Web.
    * Este elemento no se persiste en la base de datos.
    Function NewWebField ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'Tools\DataDictionary\prg\oField.prg' HelpString 'Devuelve una nueva instancia de oField configurado como campo virtual.'

        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
        Local lcCommand As String

        Try

            lcCommand = ""
            loField = This.New ( m.tcName, m.tcFieldType, m.tnFieldWidth, m.tnFieldPrecision, .T. )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry
        Return m.loField

    Endfunc && NewWebField


    Dimension NewM2M_COMATTRIB[ 5 ]
    NewM2M_COMATTRIB[ 1 ] = 0
    NewM2M_COMATTRIB[ 2 ] = 'Devuelve una nueva instancia de oField configurado como ForeignKey.'
    NewM2M_COMATTRIB[ 3 ] = 'NewM2M'
    NewM2M_COMATTRIB[ 4 ] = 'oField'
    * NewM2M_COMATTRIB[ 5 ] = 0

    * NewM2M
    * Devuelve una nueva instancia de oField configurado como ForeignKey.
    Function NewM2M ( tcName As String, tcFieldType As String, tnFieldWidth As Integer, tnFieldPrecision As Integer ) As oField Of 'Tools\DataDictionary\prg\oField.prg' HelpString 'Devuelve una nueva instancia de oField configurado como ForeignKey.'

        Local loField As oField Of 'Tools\DataDictionary\prg\oField.prg'

        Local lcCommand As String

        Try

            lcCommand = ""

            tcFieldType 			= 'm2m'
            loField                 = This.New ( m.tcName, m.tcFieldType, m.tnFieldWidth, m.tnFieldPrecision )
            loField.lIsVirtual      = .T.
            *loField.lSaveInDataBase = .F.

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry

        Return loField

    Endfunc && NewM2M


    * GetItem
    * Devuelve un elemento de la colección.
    Function GetItem ( tvIndex As Variant ) As Object HelpString 'Devuelve un elemento de la colección.'

        Local lnIndexOut As Integer, ;
            loErr As Exception, ;
            loItem As Object

        Local lcFieldName As String

        Local lcCommand As String

        Try

            lcCommand = ""

            loItem = Null

            If This.ValidateKeyOrIndex ( m.tvIndex, @lnIndexOut )
                loItem = This.Item ( m.lnIndexOut )

            Endif && This.ValidateKeyOrIndex( m.tvIndex , @lnIndexOut )

            If Isnull( loItem ) And Vartype( tvIndex ) = "C"
                If Lower( Right( tvIndex, 3 )) == "_id"
                    lcFieldName =Substr( tvIndex, 1, Len( tvIndex ) - 3 )
                    If This.ValidateKeyOrIndex ( lcFieldName, @lnIndexOut )
                        loItem = This.Item ( m.lnIndexOut )

                    Endif && This.ValidateKeyOrIndex( m.tvIndex , @lnIndexOut )

                Endif
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry


        Return m.loItem

    Endfunc && GetItem

Enddefine && oColFields
