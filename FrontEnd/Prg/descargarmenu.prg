*
*
Procedure DescargarMenu(  ) As Void
    Local lcCommand As String

    Try

        lcCommand = ""


    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally

    Endtry

Endproc && DescargarMenu

*!* ///////////////////////////////////////////////////////
*!* Class.........: oMenu
*!* Description...:
*!* Date..........: Martes 7 de Febrero de 2023 (17:25:56)
*!*
*!*

Define Class oMenu As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oMenu Of "FrontEnd\Prg\DescargarMenu.prg"
    #Endif

    cModelo	= "Menu"

    cURL 	= "comunes/apis/Menu/"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="menuloader" type="method" display="MenuLoader" />] + ;
        [<memberdata name="processitem" type="method" display="ProcessItem" />] + ;
        [</VFPData>]

    *
    *
    Procedure MenuLoader( oItemsMenu As Collection ) As Void
        Local lcCommand As String,;
            lcMenuName As String,;
            lcMainMenu As String

        Local loParam As Object,;
            loFiltro As Object,;
            loFiltros As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
            loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loReg As Object,;
            loReturn As Object,;
            loMenu As oColMenu Of "FrontEnd\Prg\DescargarMenu.prg"

        Local llOk As Boolean

        Try

            lcCommand = ""
            llOk = .F.
            lcMenuName = "Menu" + Sys(2015)
            lcMainMenu = Sys(2015)
            
            If IsEmpty( oItemsMenu )

                loParam = Createobject( "Empty" )
                loFiltros = Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.Prg" )

                loFiltro = Createobject( "Empty" )
                AddProperty( loFiltro, "Nombre", "Activos" )
                AddProperty( loFiltro, "FieldName", "activo" )
                AddProperty( loFiltro, "FieldRelation", "==" )
                AddProperty( loFiltro, "FieldValue", "True" )

                loFiltros.AddItem( loFiltro, loFiltro.Nombre )

                loFiltro = Createobject( "Empty" )
                AddProperty( loFiltro, "Nombre", "SetPageSize" )
                AddProperty( loFiltro, "FieldName", "current_size" )
                AddProperty( loFiltro, "FieldRelation", "=" )
                AddProperty( loFiltro, "FieldValue", Transform( 1000 ) )

                loFiltros.AddItem( loFiltro, loFiltro.Nombre )

                AddProperty( loParam, "oFilterCriteria", loFiltros )

                loReturn = This.GetByWhere( loParam )

                If loReturn.lOk

                    lcMainMenu = loReturn.cAlias

                    loMenu = Newobject( "oColMenu", "FrontEnd\Prg\DescargarMenu.prg" )
                    loMenu.oColAccessKey.Add( "S", "S" )

                    Select Alias( lcMainMenu )

                    TEXT To lcCommand NoShow TextMerge Pretext 15
	            	Select *
	            		From <<Alias( lcMainMenu )>>
	            		Where IsEmpty( Parent )
	            		Order By Orden
	            		Into Cursor <<lcMenuName>> ReadWrite
                    ENDTEXT

                    &lcCommand
                    lcCommand = ""
                    
                    llOk = .T.

                Endif

            Else
                
                loArchivo = This.GetTable( This.cTabla )
                
                lcMainMenu = This.cMainCursorName 
                This.CrearCursor( lcMainMenu )
                Select Alias( lcMainMenu )

                For Each loReg In oItemsMenu
                	loArchivo.ValidateData( loReg, lcMainMenu )
                EndFor
                
                loMenu = Newobject( "oColMenu", "FrontEnd\Prg\DescargarMenu.prg" )
                loMenu.oColAccessKey.Add( "S", "S" )

                TEXT To lcCommand NoShow TextMerge Pretext 15
            	Select *
            		From <<Alias( lcMainMenu )>>
            		Where IsEmpty( Parent )
            		Order By Orden
            		Into Cursor <<lcMenuName>> ReadWrite
                ENDTEXT

                &lcCommand
                lcCommand = ""
                
                llOk = .T. 

            Endif

            If llOk

                Locate
                Scan
                    Scatter Memo Name loReg
                    This.ProcessItem( loMenu, loReg, lcMenuName, lcMainMenu )
                Endscan

                lcRet = loMenu.Render()

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loReg = Null
            Use In Select( lcMenuName )
            Use In Select( lcMainMenu )

        Endtry

    Endproc && MenuLoader


    *
    *
    Procedure xxx___MenuLoader( oMenu As Collection ) As Void
        Local lcCommand As String,;
            lcMenuName As String,;
            lcMainMenu As String

        Local loParam As Object,;
            loFiltro As Object,;
            loFiltros As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
            loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loReg As Object,;
            loReturn As Object

        Local loMenu As oColMenu Of "FrontEnd\Prg\DescargarMenu.prg"

        Try

            lcCommand = ""
            lcMenuName = "Menu" + Sys(2015)
            lcMainMenu = Sys(2015)

            loParam = Createobject( "Empty" )
            loFiltros = Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.Prg" )

            loFiltro = Createobject( "Empty" )
            AddProperty( loFiltro, "Nombre", "Activos" )
            AddProperty( loFiltro, "FieldName", "activo" )
            AddProperty( loFiltro, "FieldRelation", "==" )
            AddProperty( loFiltro, "FieldValue", "True" )

            loFiltros.AddItem( loFiltro, loFiltro.Nombre )

            loFiltro = Createobject( "Empty" )
            AddProperty( loFiltro, "Nombre", "SetPageSize" )
            AddProperty( loFiltro, "FieldName", "current_size" )
            AddProperty( loFiltro, "FieldRelation", "=" )
            AddProperty( loFiltro, "FieldValue", Transform( 1000 ) )

            loFiltros.AddItem( loFiltro, loFiltro.Nombre )

            AddProperty( loParam, "oFilterCriteria", loFiltros )

            loReturn = This.GetByWhere( loParam )

            If loReturn.lOk

                lcMainMenu = loReturn.cAlias

                loMenu = Newobject( "oColMenu", "FrontEnd\Prg\DescargarMenu.prg" )
                loMenu.oColAccessKey.Add( "S", "S" )

                Select Alias( lcMainMenu )

                TEXT To lcCommand NoShow TextMerge Pretext 15
            	Select *
            		From <<Alias( lcMainMenu )>>
            		Where IsEmpty( Parent )
            		Order By Orden
            		Into Cursor <<lcMenuName>> ReadWrite
                ENDTEXT

                &lcCommand
                lcCommand = ""

                Locate
                Scan
                    Scatter Memo Name loReg
                    This.ProcessItem( loMenu, loReg, lcMenuName, lcMainMenu )
                Endscan

                lcRet = loMenu.Render()

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loReg = Null
            Use In Select( lcMenuName )
            Use In Select( lcMainMenu )

        Endtry

    Endproc && xxx_MenuLoader


    *
    *
    Procedure ProcessItem( oMenu, oReg, cCurrent, cMainMenu ) As Void
        Local lcCommand As String,;
            lcKey As String,;
            lcMenuPopUp As String,;
            lcMenuName As String

        Local loItem As oColMenu Of "FrontEnd\Prg\DescargarMenu.prg",;
            loReg As Object
        Local lnLen As Integer

        Local llAdd As Boolean

        Try

            lcCommand 	= ""
            lcMenuPopUp = "PopUp"+ Sys(2015)
            lcMenuName 	= "Menu" + Sys(2015)

            loItem 	= Newobject( "oColMenu", "FrontEnd\Prg\DescargarMenu.prg" )

            loItem.cNombre 		= Alltrim( oReg.Nombre )
            loItem.cPrograma 	= Alltrim( oReg.File_Name )
            loItem.cFolder 		= Alltrim( oReg.Folder )
            loItem.cURL 		= Alltrim( oReg.URL )

            *
            loItem.nPermisos 	= oReg.Permisos
            loItem.nAcciones 	= oReg.Acciones
            loItem.nParam3 		= 0
            loItem.nParam4 		= 0
            loItem.nParam5 		= 0
            loItem.lDoPrg 		= .T.

            lcKey	= "__" + Transform( oReg.Id ) + "__"

            loParent = oMenu
            loItem.oParent = loParent
            loParent.Add( loItem, lcKey )

            llOk = .F.
            i = 1
            lnLen = Len( loItem.cNombre )

            Do While ! llOk And i < lnLen

                Try
                    lcLetra = Substr( loItem.cNombre, i, 1 )
                    If ! Empty( lcLetra ) ;
                            And Between( Asc( Upper( lcLetra )), Asc("A"), Asc("Z") )

                        loParent.oColAccessKey.Add( lcLetra, Upper( lcLetra ) )
                        loItem.cAccessKey = lcLetra
                        llOk = .T.

                    Else
                        Error ''

                    Endif &&  ! Empty( lcLetra )

                Catch To oErr
                    i = i + 1

                Endtry

            Enddo

            If !llOk
                For i = Asc("A") To Asc("Z")
                    Try

                        lcLetra = Chr( i )
                        loParent.oColAccessKey.Add( lcLetra, Upper( lcLetra ) )
                        loItem.cAccessKey = lcLetra
                        llOk = .T.

                    Catch To oErr
                        i = i + 1

                    Finally

                    Endtry

                    If llOk
                        loItem.cNombre = loItem.cNombre + " (" +lcLetra + ")"
                        Exit
                    Endif

                Endfor
            Endif

            loItem.nIndex = loParent.Count

            TEXT To lcCommand NoShow TextMerge Pretext 15
        	Select *
        		From <<Alias( cMainMenu )>>
        		Where Parent = <<oReg.Id>>
        		Order By Orden
        		Into Cursor <<lcMenuName>> ReadWrite
            ENDTEXT

            &lcCommand
            lcCommand = ""

            Locate
            Scan
                Scatter Memo Name loReg
                This.ProcessItem( loItem, loReg, lcMenuName, cMainMenu )
            Endscan

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            Use In Select( lcMenuPopUp )

        Endtry

    Endproc && ProcessItem


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oMenu
*!*
*!* ///////////////////////////////////////////////////////

Define Class oColMenu As Collection
    #If .F.
        Local This As oColMenu Of "FrontEnd\Prg\DescargarMenu.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]



    oColAccessKey = Null
    oParent = Null
    cNombre = ''
    cPrograma = ''
    nPermisos = 0
    nAcciones = 0
    nParam3 = 0
    nParam4 = 0
    nParam5 = 0
    lDoPrg	= .F.

    nIndex 			= 0
    cID 			= ''
    cAccessKey 		= ''
    cFolder 		= ""
    cURL 			= ""

    Procedure Init() As VOID
        This.cID = Sys( 2015 )
        This.oColAccessKey = Createobject( 'Collection' )

    Endproc

    Procedure Destroy() As VOID
        This.oParent = Null
        This.oColAccessKey = Null
    Endproc &&  Destroy

    Procedure Render()
        Local lcRet As String
        Local lcTraceLogin As String
        Local i As Integer
        Local loColMenu As oColMenu Of fw\comunes\prg\menuloader.prg

        Try

            Release Pad All Of _Msysmenu

            Sistema()

            lcTraceLogin = ""
            lcRet = ""

            For i = 1 To This.Count
                loColMenu = This.Item[ i ]

                Try
                    lcRet = lcRet + loColMenu.DefinePad() + Chr( 13 )

                Catch To oErr
                    lcTraceLogin = lcTraceLogin + Chr( 13 ) ;
                        + 'Item:' + Transform( i ) + Chr( 13 )

                    loError.Process( oErr )
                    Throw loError

                Finally
                Endtry

            Endfor

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cTraceLogin = lcTraceLogin
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

        Return lcRet

    Endproc

    Procedure DefinePad()

        Local lcCommand As String
        Local lcNombre As String
        Local lcRet As String
        Local lcCommandAction As String
        Local lcTraceLogin As String
        Local lcExecute As String
        Local i As Integer
        Local llDoPrg As Boolean

        Try

            lcTraceLogin = ""
            lcRet = ""
            lcExecute = ""
            llDoPrg = .F.

            If ! Empty( This.cAccessKey )
                lcNombre = Strtran( This.cNombre, This.cAccessKey, '\<'  + This.cAccessKey, 1, 1, 2 )

            Else
                lcNombre = This.cNombre

            Endif

            If Empty( This.cPrograma )

                TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Pad pad<<This.cId>> Of _Msysmenu
					Prompt "<<lcNombre>>"
					Color Scheme 3
					<<Iif( ! Empty( This.cAccessKey ), [KEY Alt+] + This.cAccessKey + [, ""], "" )>>
					Message "<<This.cNombre>>"
                ENDTEXT

                lcRet = lcRet + lcCommand + Chr( 13 )
                lcTraceLogin = 'Ejecutando comando: ' + lcCommand
                &lcCommand

                TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					On Pad pad<<This.cId>> Of _Msysmenu Activate Popup pop<<This.cId>>
                ENDTEXT

                lcRet = lcRet + lcCommand + Chr( 13 )
                lcTraceLogin = 'Ejecutando comando: ' + lcCommand
                &lcCommand

                TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Popup pop<<This.cId>> Margin Relative Shadow Color Scheme 4
                ENDTEXT

                lcRet = lcRet + lcCommand + Chr( 13 )
                lcTraceLogin = 'Ejecutando comando: ' + lcCommand
                &lcCommand

                For i = 1 To This.Count
                    loColMenu = This.Item[ i ]

                    Try
                        lcRet = lcRet + loColMenu.DefineBar() + Chr( 13 )

                    Catch To oErr
                        lcTraceLogin = lcTraceLogin + Chr( 13 ) ;
                            + 'Item:' + Transform( i ) + Chr( 13 )

                        loError.Process( oErr )
                        Throw loError

                    Finally
                    Endtry

                Endfor

            Else

                TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Pad pad<<This.cId>> Of _Msysmenu
					Prompt "<<lcNombre>>"
					Color Scheme 3
					<<Iif( ! Empty( This.cAccessKey ), [KEY Alt+] + This.cAccessKey + [, ""], "" )>>
					Message "<<This.cNombre>>"
                ENDTEXT
                *					Skip For !  FileExist( "<<Addbs(This.cFolder)>><<ForceExt( This.cPrograma, 'prg' )>>" )
                lcRet = lcRet + lcCommand + Chr( 13 )
                lcTraceLogin = 'Ejecutando comando: ' + lcCommand
                &lcCommand

                lcExecute = This.DoExecute()
                TEXT TO lcCommandAction TEXTMERGE NOSHOW PRETEXT 15
					On Selection Pad pad<<This.cId>> Of _Msysmenu
					<<lcExecute>>
                ENDTEXT

                lcRet = lcRet + lcCommandAction + Chr( 13 )
                lcTraceLogin = 'Ejecutando comando: ' + lcCommandAction
                &lcCommandAction

            Endif

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cTraceLogin = lcTraceLogin
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

        Return lcRet

    Endproc

    Procedure DefineBar()

        Local lcCommand As String
        Local lcNombre As String
        Local lcRet As String
        Local lcCommandAction As String
        Local lcTraceLogin As String
        Local lcPopUpName As String
        Local lcExecute As String
        Local i As Integer

        Try

            lcTraceLogin = ""
            lcRet = ""
            lcPopUpName = ""
            lcExecute = ""


            If !IsRuntime()
                This.cAccessKey = ""
            Endif

            If ! Empty( This.cAccessKey )
                lcNombre = Strtran( This.cNombre, This.cAccessKey, '\<'  + This.cAccessKey, 1, 1, 2 )

            Else
                lcNombre = This.cNombre

            Endif

            If Empty( This.cPrograma )

                lcPopUpName = 'pop' + This.oParent.cID

                TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Bar <<This.nIndex>> Of <<lcPopUpName>> Prompt "<<lcNombre>>"
					<<Iif( ! Empty( This.cAccessKey ), [KEY Alt+] + This.cAccessKey + ', "[' + Upper( This.cAccessKey ) + ']"', "" )>>
					Message "<<This.cNombre>>"
                ENDTEXT


                *<<Iif( ! Empty( This.cAccessKey ), [KEY Alt+] + This.cAccessKey + [, "Alt+] + Upper( This.cAccessKey ) +["], "" )>>

                lcRet = lcRet + lcCommand + Chr( 13 )
                lcTraceLogin = 'Ejecutando comando: ' + lcCommand
                &lcCommand

                TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					On Bar <<This.nIndex>> Of pop<<This.oParent.cId>> Activate Popup pop<<This.cId>>
                ENDTEXT

                lcRet = lcRet + lcCommand + Chr( 13 )
                lcTraceLogin = 'Ejecutando comando: ' + lcCommand
                &lcCommand

                TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Popup pop<<This.cId>> Margin Relative Shadow Color Scheme 4
                ENDTEXT

                lcRet = lcRet + lcCommand + Chr( 13 )
                lcTraceLogin = 'Ejecutando comando: ' + lcCommand
                &lcCommand

                For i = 1 To This.Count
                    loColMenu = This.Item[ i ]

                    Try
                        lcRet = lcRet + loColMenu.DefineBar() + Chr( 13 )

                    Catch To oErr
                        lcTraceLogin = lcTraceLogin + Chr( 13 ) ;
                            + 'Item:' + Transform( i ) + Chr( 13 )

                        loError.Process( oErr )
                        Throw loError

                    Finally
                    Endtry

                Endfor

            Else
                lcPopUpName = 'pop' + This.oParent.cID
                TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Bar <<This.nIndex>> Of <<lcPopUpName>> Prompt "<<lcNombre>>"
					<<Iif( ! Empty( This.cAccessKey ), [KEY Alt+] + This.cAccessKey + ', "[' + Upper( This.cAccessKey ) + ']"', "" )>>
					Message "<<This.cNombre>>"
                ENDTEXT

                *Skip For !(IsRuntime() Or   FileExist( "<<Addbs(This.cFolder)>><<ForceExt( This.cPrograma, 'prg' )>>" ))

                lcRet = lcRet + lcCommand + Chr( 13 )
                lcTraceLogin = 'Ejecutando comando: ' + lcCommand
                &lcCommand

                lcExecute = This.DoExecute()
                TEXT TO lcCommandAction TEXTMERGE NOSHOW PRETEXT 15
					On Selection Bar <<This.nIndex>> Of pop<<This.oParent.cId>>
					<<lcExecute>>
                ENDTEXT

                lcRet = lcRet + lcCommandAction + Chr( 13 )
                lcTraceLogin = 'Ejecutando comando: ' + lcCommandAction
                &lcCommandAction

            Endif

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.cTraceLogin = lcTraceLogin
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

        Return lcRet

    Endproc

    Procedure DoExecute()
        Local lcCommandAction As String

        Try

            TEXT To lcParam NoShow TextMerge Pretext 15
			With <<This.nPermisos>>,<<This.nAcciones>>,<<This.nParam3>>,<<This.nParam4>>,<<This.nParam5>>,'<<This.cURL>>'
            ENDTEXT

            If This.lDoPrg
                TEXT To lcParam NoShow TextMerge Pretext 15 ADDITIVE
				,<<This.lDoPrg>>
                ENDTEXT
            Endif

            TEXT TO lcCommandAction TEXTMERGE NOSHOW PRETEXT 15
			Do Execute With "'<<Addbs(This.cFolder)>><<This.cPrograma>>' <<lcParam>>", <<This.lDoPrg>>
            ENDTEXT


        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

        Return lcCommandAction

    Endproc

Enddefine && oColMenu
