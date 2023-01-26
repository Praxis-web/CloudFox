

*!* ///////////////////////////////////////////////////////
*!* Class.........: oColHtmlErrors
*!* Description...:
*!* Date..........: Sábado 20 de Agosto de 2022 (12:28:00)
*!*
*!*

*Define Class oColHtmlErrors As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg
Define Class oColHtmlErrors as Collection 

    #If .F.
        Local This As oColHtmlErrors Of "Tools\ErrorHandler\prg\HtmlErrors.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Init(  ) As Void
        Local lcCommand As String
        Local loError as Object 

        Try

            lcCommand = ""
            
            loError = CreateObject( "Empty" )
            AddProperty( loError, "Html", "&quot;" ) 
            AddProperty( loError, "Char", '"' )
            This.Add( loError, loError.Html )
            
            loError = CreateObject( "Empty" )
            AddProperty( loError, "Html", "&#x27;" ) 
            AddProperty( loError, "Char", "'" )
            This.Add( loError, loError.Html )

            loError = CreateObject( "Empty" )
            AddProperty( loError, "Html", "&lt;" ) 
            AddProperty( loError, "Char", "<" )
            This.Add( loError, loError.Html )

            loError = CreateObject( "Empty" )
            AddProperty( loError, "Html", "&gt;" ) 
            AddProperty( loError, "Char", ">" )
            This.Add( loError, loError.Html )
            
            loError = CreateObject( "Empty" )
            AddProperty( loError, "Html", ',"</textarea>"]}' ) 
            AddProperty( loError, "Char", ']}' )
            This.Add( loError, loError.Html )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Init


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oColHtmlErrors
*!*
*!* ///////////////////////////////////////////////////////

