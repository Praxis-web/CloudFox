#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE Tools\JSON\Include\HTTP.h

*!* ///////////////////////////////////////////////////////
*!* Class.........: oBackEndSettings
*!* Description...:
*!* Date..........: Martes 7 de Septiembre de 2021 (18:38:40)
*!*
*!*

Define Class oBackEndSettings As Custom

    #If .F.
        Local This As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg"
    #Endif

    cBaseUrl 		= ""
    cAdmin 			= "admin/"
    cLogin 			= ""
    cLogout 		= "logout/"
    cTestConnection = "test/"
    cRefreshToken 	= "refresh-token/"

    * Token de Autorización
    cAuthToken 		= ""

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="cbaseurl" type="property" display="cBaseUrl" />] + ;
        [<memberdata name="cadmin" type="property" display="cAdmin" />] + ;
        [<memberdata name="clogin" type="property" display="cLogin" />] + ;
        [<memberdata name="clogout" type="property" display="cLogout" />] + ;
        [<memberdata name="ctestconnection" type="property" display="cTestConnection" />] + ;
        [<memberdata name="crefreshtoken" type="property" display="cRefreshToken" />] + ;
        [<memberdata name="cauthtoken" type="property" display="cAuthToken" />] + ;
        [</VFPData>]

    *
    * cBaseUrl_Access
    Protected Procedure cBaseUrl_Access()
        Local loJson As prxJSON Of "Tools\JSON\Prg\JSON.prg"
        Local lcCommand As String

        Try

            lcCommand = ""


            If Empty( This.cBaseUrl )
                loJson = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )

                If File( "Datos\Setup.json" )
                    loObj = loJson.JsonToVfp( Filetostr( "Datos\Setup.json" ))
                    This.cBaseUrl = loObj.cURL

                Else
                    TEXT To lcMsg NoShow TextMerge Pretext 03
					Falta el archivo de configuración
					Datos\Setup.json
                    ENDTEXT

                    Stop( lcMsg, "Error de Configuración", 10, .T. )

                Endif
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loJson = Null


        Endtry

        Return This.cBaseUrl

    Endproc && oXmlHttp_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oBackEndSettings
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ConsumirAPI
*!* Description...:
*!* Date..........: Miércoles 8 de Septiembre de 2021 (09:27:50)
*!*
*!*

Define Class ConsumirAPI As Custom

    #If .F.
        Local This As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg"
    #Endif

    oJsontoVfp	= Null
    oXmlHttp 	= Null
    oBackEnd 	= Null

    cURL 			= ""
    cErrorMessage 	= ""
    lSilence 		= .F.

    cAuthorization = "TOKEN"

    * Indica si trae solo la pagina o todo el conjunto de datos
    lGetAll = .F.

    * Indica si devuelve un objeto Vfp o un archivo Csv
    * Valores válidos: "Vfp","Csv"
    cReturnType = "Vfp"

    * Seguimiento de la llamada (Para debugging)
    cTrace = ""

    * Observaciones
    cRemark = ""

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="lsilence" type="property" display="lSilence" />] + ;
        [<memberdata name="curl" type="property" display="cUrl" />] + ;
        [<memberdata name="cerrormessage" type="property" display="cErrorMessage" />] + ;
        [<memberdata name="ojsontovfp" type="property" display="oJsontoVfp" />] + ;
        [<memberdata name="oxmlhttp" type="property" display="oXmlHttp" />] + ;
        [<memberdata name="obtenertoken" type="method" display="ObtenerToken" />] + ;
        [<memberdata name="getnewtoken" type="method" display="GetNewToken" />] + ;
        [<memberdata name="cauthorization" type="property" display="cAuthorization" />] + ;
        [<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
        [<memberdata name="ocoltables_access" type="method" display="oColTables_Access" />] + ;
        [<memberdata name="obackend" type="property" display="oBackEnd" />] + ;
        [<memberdata name="listar" type="method" display="Listar" />] + ;
        [<memberdata name="modificar" type="method" display="Modificar" />] + ;
        [<memberdata name="crear" type="method" display="Crear" />] + ;
        [<memberdata name="borrar" type="method" display="Borrar" />] + ;
        [<memberdata name="bulk_update" type="method" display="Bulk_Update" />] + ;
        [<memberdata name="bulk_create" type="method" display="Bulk_Create" />] + ;
        [<memberdata name="bulk_delete" type="method" display="Bulk_Delete" />] + ;
        [<memberdata name="traer" type="method" display="Traer" />] + ;
        [<memberdata name="getfieldlookup" type="method" display="GetFieldLookup" />] + ;
        [<memberdata name="lgetall" type="property" display="lGetAll" />] + ;
        [<memberdata name="creturntype" type="property" display="cReturnType" />] + ;
        [<memberdata name="login" type="method" display="Login" />] + ;
        [<memberdata name="ctrace" type="property" display="cTrace" />] + ;
        [<memberdata name="cremark" type="property" display="cRemark" />] + ;
        [</VFPData>]



    *
    *
    Procedure Init(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""
            *This.oJsontoVfp = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Init

    *
    *
    Procedure Listar( cURL As String,;
            oParametros As Collection,;
            cCursor As String,;
            cTitulo As String,;
            oBody As Object ) As Object

        Local lcCommand As String,;
            lcURL As String,;
            lcCursor As String,;
            lcAlias As String,;
            lcTitulo As String,;
            lcSetCursor As String,;
            lcCsv As String,;
            lcDate As String,;
            lcCentury As String,;
            lcHeader As String,;
            lcFieldList As String,;
            lcField As String

        Local loBackEnd As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg",;
            loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJson As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object,;
            loNextPage As Object,;
            loReg As Object,;
            loParametros As Collection,;
            loFiltro As Object,;
            loBody As Object

        Local loTherm As _thermometer Of "v:\cloudfox\fw\comunes\vcx\_therm.vcx"
        Local lnRegistros As Integer,;
            i As Integer,;
            j As Integer,;
            lnPercent As Integer,;
            lnRecno As Integer,;
            lnLen As Integer

        Local llAborta As Boolean,;
            llCursor As Boolean

        Local lnTiempo As Integer

        Try

            lcCommand 	= ""
            lcCsv 		= ""
            llCursor 	= .F.
            lcSetCursor = Set("Cursor")
            Set Cursor Off

            lcDate 		= Set("Date")
            lcCentury 	= Set("Century")
            loJSON		= Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )

            This.oXmlHttp = Null
            loXmlHttp 	= This.oXmlHttp


            Set Date YMD
            Set Century On

            lcAlias = Alias()

            loBackEnd = This.oBackEnd
            lcURL = loBackEnd.cBaseUrl + cURL

            If Vartype( oBody ) # "O"
                oBody = Null
            Endif

            loParametros = oParametros

            If Vartype( loParametros ) # "O"
                loParametros = Createobject( "Collection" )
            Endif

            If Upper( loParametros.BaseClass ) # Upper( "Collection" )
                loParametros = Createobject( "Collection" )
            Endif

            If Vartype( cCursor ) # "C"
                cCursor = ""
            Endif

            lcCursor = cCursor

            lcTitulo = cTitulo
            If Vartype( lcTitulo ) # "C" Or Empty( lcTitulo )
                lcTitulo = "Listado"
            Endif

            If !Empty( lcCursor )
                llCursor = Used( lcCursor )
            Endif

            If loParametros.Count > 0

                If !Empty( At( "/?", lcURL ))
                    i = 99

                Else
                    i = 0

                Endif

                For Each loFiltro In loParametros
                    i = i + 1
                    If i = 1
                        lcURL = lcURL + "?"

                    Else
                        lcURL = lcURL + "&"

                    Endif

                    lcURL = lcURL + Alltrim( loFiltro.FieldName )
                    lcURL = lcURL + This.GetFieldLookup( loFiltro.FieldRelation )
                    
                    If Alltrim( loFiltro.FieldName )=="search"
                    	lcURL = lcURL + "=" + Alltrim( loFiltro.FieldValue )

                    Else
                    	lcURL = lcURL + "=" + loXmlHttp.ValidateURL( Alltrim( loFiltro.FieldValue ))

                    Endif

                Endfor
            Endif

            If !Isnull( oBody )
                *!*	loXmlHttp.cBody = loJson.VfpToJson( oBody )

                *!*	XMLHttpRequest send() accepts an optional parameter which
                *!*	lets you specify the request's body;
                *!*	this is primarily used for requests such as PUT.
                *!*	If the request method is GET or HEAD,
                *!*	the body parameter is ignored and the request body
                *!*	is set to null.

                * RA 19/09/2022(15:19:59)
                * Se deben agregar los parámetros en la llamada a la URL

                Dimension laMember[1]
                lnLen = Amembers( laMember, oBody, 0 )

                If !Empty( At( "/?", lcURL ))
                    i = 99

                Else
                    i = 0

                Endif


                For j = 1 To lnLen
                    Try
                        lcPropertyName = laMember[j]
                        uValue = Evaluate( "oBody." + lcPropertyName )

                        i = i + 1
                        If i = 1
                            lcURL = lcURL + "?"

                        Else
                            lcURL = lcURL + "&"

                        Endif

                        * lcURL = lcURL + Alltrim( loFiltro.FieldName ) + "=" + Alltrim( loFiltro.FieldValue )
                        lcURL = lcURL + Lower( lcPropertyName )
                        *lcURL = lcURL + "=" + Alltrim( Transform( uValue ) )
                        lcURL = lcURL + "=" + loXmlHttp.ValidateURL( Alltrim( Transform( uValue ) ))

                    Catch To oErr

                    Finally

                    Endtry


                Endfor


            Endif

            loBackEnd = This.oBackEnd

            loXmlHttp.nStatus 		= 0
            loXmlHttp.cResponseText = ""
            loXmlHttp.cURL 			= lcURL
            loXmlHttp.cReturnType 	= This.cReturnType

            This.cErrorMessage 		= ""

            *loXmlHttp.lSilence = .T.

            loXmlHttp.Get()
            loReturn = loXmlHttp.oVFP

            If Isnull( loReturn )
                loReturn = Createobject( "Empty" )
                AddProperty( loReturn, "lOk", .F. )
                AddProperty( loReturn, "nStatus", loXmlHttp.nStatus )
                AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
            Endif

            TEXT To lcMsg NoShow TextMerge Pretext 03
				Status: <<loXmlHttp.nStatus>>
				<<loXmlHttp.cResponseText>>
				<<loXmlHttp.cErrorDetail>>
            ENDTEXT

            This.cErrorMessage = lcMsg

            If loReturn.lOk

                If llCursor
                    Select Alias( lcCursor )
                Endif

                loData = loReturn.Data
                *loReturn.Data = loData.Results
                *AddProperty( loReturn, "Count", loData.Count )

                * Si loData.Count > 100, viene paginado
                * Realizar todas las consultas e ir agregando los
                * items a la colección.
                * Si aparecen problemas de memoria, se podría armar crear un cursor

                llAborta = .F.
                
                If llCursor
                    For i = 1 To loData.Results.Count
                        loReg = loData.Results.Item( i )
                        Append Blank
                        Gather Name loReg Memo
                    Endfor
                Endif

                * Browse

                *lnTiempo = ( loReturn.nElapsedSend + loReturn.nElapsedJson2Vfp ) * loData.total_pages
                lnTiempo = ( loReturn.nElapsedSend * 2 ) * loData.total_pages

                Do Case
                    Case loXmlHttp.cReturnType = "Csv"
                        Strtofile( loXmlHttp.cCsv_Header, lcCursor + "_Header.txt", 0 )
                        Strtofile( loXmlHttp.cCsv_Body, lcCursor + ".txt", 0 )

                    Case lnTiempo > ( 1 * 60 ) And ( This.lGetAll = .T. )
                        TEXT To lcMsg NoShow TextMerge Pretext 03
						Cantidad de Registros a Listar: <<Transform( loData.Count )>>

						Tiempo estimado: <<Transform( Ceiling( lnTiempo / 60 ))>> minutos

						¿Confirma el Proceso?
                        ENDTEXT

                        llAborta = !Confirm( lcMsg, lcTitulo )

                        If !llAborta
                            loXmlHttp.cReturnType = "Csv"

                            lcCsv = loJSON.JsonToCsv( loXmlHttp.cResponseText,,.T. )
                            Strtofile( lcCsv, lcCursor + "_Header.txt", 0 )

                            lcCsv = loJSON.JsonToCsv( loXmlHttp.cResponseText )
                            Strtofile( lcCsv, lcCursor + ".txt", 0 )

                        Endif

                    Otherwise

                        If loData.total_pages > 1

                            * RA 19/03/2022(14:24:50)
                            * OJO: Los archivos de texto no toman en cuenta los campos memo

                            loXmlHttp.cReturnType = "Csv"

                            loJSON	= Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )

                            lcCsv = loJSON.JsonToCsv( loXmlHttp.cResponseText,,.T. )
                            Strtofile( lcCsv, lcCursor + "_Header.txt", 0 )

                            lcCsv = loJSON.JsonToCsv( loXmlHttp.cResponseText )
                            Strtofile( lcCsv, lcCursor + ".txt", 0 )

                        Endif


                Endcase

                loTherm = Newobject("_thermometer", "v:\cloudfox\fw\comunes\vcx\_therm.vcx", "", lcTitulo )
                loTherm.iLength = 6
                loTherm.iDecimalPlaces = 2
                loTherm.lblEscapeMessage.Caption = "[Esc]: Cancela"
                loTherm.Show()

                Inkey()

                Do While This.lGetAll And !IsEmpty( loData.Next ) And !llAborta

                    loXmlHttp.oVFP 			= Null
                    loXmlHttp.oXmlHttp 		= Null
                    loXmlHttp 				= Null

                    This.oXmlHttp.oVFP 		= Null
                    This.oXmlHttp.oXmlHttp 	= Null
                    This.oXmlHttp 			= Null

                    loXmlHttp = This.oXmlHttp

                    loXmlHttp.nStatus 		= 0
                    loXmlHttp.cResponseText = ""
                    loXmlHttp.cURL 			= loData.Next

                    loXmlHttp.lSilence = .T.

                    If !Empty( lcCsv )
                        loXmlHttp.cReturnType = "Csv"
                    Endif

                    loXmlHttp.Get()
                    loNextPage = loXmlHttp.oVFP

                    If Isnull( loNextPage )
                        loNextPage = Createobject( "Empty" )
                        AddProperty( loNextPage, "lOk", .F. )
                        AddProperty( loNextPage, "nStatus", loXmlHttp.nStatus )
                        AddProperty( loNextPage, "cErrorMessage", loXmlHttp.cErrorDetail )
                    Endif

                    TEXT To lcMsg NoShow TextMerge Pretext 03
					Status: <<loXmlHttp.nStatus>>
					<<loXmlHttp.cResponseText>>
					<<loXmlHttp.cErrorDetail>>
                    ENDTEXT

                    This.cErrorMessage = lcMsg

                    If loNextPage.lOk

                        loData = loNextPage.Data

                        lnPercent = loData.current_page / loData.total_pages * 100
                        lnTiempo = ( loNextPage.nElapsedSend + loNextPage.nElapsedJson2Vfp ) * ( loData.total_pages - loData.current_page )


                        Do Case
                            Case lnTiempo < 60
                                TEXT To lcMsg NoShow TextMerge Pretext 03
								Tiempo restante: <<Transform( Int( lnTiempo )))>> segundos
                                ENDTEXT

                            Case .F. && lnTiempo < 120
                                TEXT To lcMsg NoShow TextMerge Pretext 03
								Tiempo restante: <<Transform( Ceiling( lnTiempo / 60 ))>> minutos
                                ENDTEXT

                            Otherwise
                                TEXT To lcMsg NoShow TextMerge Pretext 03
								Tiempo restante: <<Transform( Ceiling( lnTiempo / 60 ))>> minutos
                                ENDTEXT

                        Endcase

                        loTherm.Update( lnPercent, lcMsg )

                        If loXmlHttp.cReturnType = "Csv"
                            *StrToFile( CRLF + loXmlHttp.cCsv, lcCursor + ".csv", 1 )
                            *Strtofile( loXmlHttp.cCsv, lcCursor + ".txt", 1 )

                        Else
                            For i = 1 To loData.Results.Count
                                loReg = loData.Results.Item( i )

                                If llCursor
                                    Append Blank
                                    Gather Name loReg Memo

                                Else
                                    loReturn.Data.Add( loReg )

                                Endif
                            Endfor

                        Endif


                    Else
                        loData = Createobject( "Empty" )
                        AddProperty( loData, "Next", "" )

                    Endif

                    Inkey()
                    prxLastkey()

                    llAborta = &Aborta

                Enddo

                loTherm.Hide()

                If llAborta
                    loReturn.lOk = .F.

                    TEXT To lcMsg NoShow TextMerge Pretext 03
					Proceso interrumpido por el usuario
                    ENDTEXT

                    loReturn.cErrorMessage = lcMsg
                    loReturn.nStatus = _HTTP_601_PROCESO_INTERRUMPIDO_POR_EL_CLIENTE

                Else
                    If llCursor
                        If loXmlHttp.cReturnType = "Csv"
                            * RA 02/06/2022(17:53:23)
                            * Armar el cursor con los campos en el mismo
                            * orden que el archivo de texto

                            lcHeader = Filetostr( lcCursor + "_Header.txt" )

                            lnLen = Getwordcount( lcHeader, Chr( 124 ) )
                            lcFieldList = ""

                            For i = 1 To lnLen
                                lcField = Strtran( Getwordnum( lcHeader, i, Chr( 124 ) ), ["], [] )
                                lcFieldList = lcFieldList + lcField + ","
                            Endfor

                            TEXT To lcCommand NoShow TextMerge Pretext 15
							Select
									<<lcFieldList>>
									Space( 1 ) as r7Mov,
									Cast( 0 as I ) as ABM,
									Cast( 0 as I ) as _RecordOrder
								From <<lcCursor>>
								Where .F.
								Into Cursor <<lcCursor>> ReadWrite
                            ENDTEXT

                            &lcCommand
                            lcCommand = ""

                            TEXT To lcCommand NoShow TextMerge Pretext 15
							Append From <<lcCursor>>.txt DELIMITED WITH CHARACTER |
                            ENDTEXT

                            AppendFromTxt( lcCursor + ".txt", lcCursor )

                            TEXT To lcCommand NoShow TextMerge Pretext 15
							Delete File <<lcCursor>>_Header.txt
                            ENDTEXT

                            &lcCommand
                            lcCommand = ""

                            TEXT To lcCommand NoShow TextMerge Pretext 15
							Delete File <<lcCursor>>.txt
                            ENDTEXT

                            &lcCommand
                            lcCommand = ""

                        Endif

                        Select Alias( lcCursor )
                        Replace All _RecordOrder With Recno()


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
            loBackEnd = Null

            loXmlHttp.oVFP = Null
            loXmlHttp.oXmlHttp = Null
            loXmlHttp = Null

            This.oXmlHttp.oVFP = Null
            This.oXmlHttp.oXmlHttp = Null
            This.oXmlHttp = Null

            loJson 		= Null
            loNextPage 	= Null
            loReg 		= Null

            If Vartype( loTherm ) = "O"
                loTherm.Release()
            Endif

            loTherm = Null

            Set Cursor &lcSetCursor
            Set Date &lcDate
            Set Century &lcCentury

            *!*				Select Alias( lcCursor )
            *!*				*Replace all Activo With .T.
            *!*				Browse
            *!*				Copy To "cTextFile.txt" DELIMITED WITH CHARACTER |

            If !Empty( lcAlias )
                Select Alias( lcAlias )
            Endif


        Endtry

        Return loReturn

    Endproc && Listar





    *
    * Devuelve el postfijo del campo para la compración pedida
    Procedure GetFieldLookup( cRelation As String ) As String;
            HELPSTRING "Devuelve el postfijo del campo para la compración pedida"
        Local lcCommand As String,;
            lcFieldLookup As String

        Try

            lcCommand = ""
            lcFieldLookup = ""

            Do Case
                Case cRelation == "=="
                    lcFieldLookup = ""

                Case cRelation == "in"
                    lcFieldLookup = "__in"

                Case cRelation == "!in"
                    lcFieldLookup = "__notin"

                Case cRelation == ">="
                    lcFieldLookup = "__gte"

                Case cRelation == "<="
                    lcFieldLookup = "__lte"

                Case cRelation == ">"
                    lcFieldLookup = "__gt"

                Case cRelation == "<"
                    lcFieldLookup = "__lt"

                Case cRelation == "like"
                    lcFieldLookup = "__icontains"

                Case cRelation == ""
                    lcFieldLookup = "__"

                Case cRelation == ""
                    lcFieldLookup = "__"

                Case cRelation == ""
                    lcFieldLookup = "__"
                Case cRelation == ""
                    lcFieldLookup = "__"

                Case cRelation == ""
                    lcFieldLookup = "__"

                Case cRelation == ""
                    lcFieldLookup = "__"

                Otherwise

            Endcase


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return lcFieldLookup

    Endproc && GetFieldLookup



    *
    *
    Procedure Traer( cURL As String,;
            nId As Integer,;
            oParametros As Collection ) As Object
        Local lcCommand As String,;
            lcURL As String
        Local loBackEnd As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg",;
            loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJson As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object,;
            loParametros As Collection
        Local llAgrega As Boolean

        Try

            lcCommand = ""

            loBackEnd = This.oBackEnd
            lcURL = loBackEnd.cBaseUrl + cURL
            lcURL = lcURL  + Transform( nId ) + "/"

            loJson = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
            This.oXmlHttp = Null
            loXmlHttp 	= This.oXmlHttp

            loParametros = oParametros

            If Vartype( loParametros ) # "O"
                loParametros = Createobject( "Collection" )
            Endif

            If Upper( loParametros.BaseClass ) # Upper( "Collection" )
                loParametros = Createobject( "Collection" )
            Endif

            If loParametros.Count > 0

                If !Empty( At( "/?", lcURL ))
                    i = 99

                Else
                    i = 0

                Endif

                For Each loFiltro In loParametros

                    llAgrega = Inlist( Lower( Alltrim( loFiltro.FieldName )), "combo" )

                    If llAgrega
                        i = i + 1
                        If i = 1
                            lcURL = lcURL + "?"

                        Else
                            lcURL = lcURL + "&"

                        Endif

                        lcURL = lcURL + Alltrim( loFiltro.FieldName )
                        lcURL = lcURL + This.GetFieldLookup( loFiltro.FieldRelation )
                        lcURL = lcURL + "=" + loXmlHttp.ValidateURL( Alltrim( Transform( loFiltro.FieldValue )))
                    Endif

                Endfor
            Endif

            loXmlHttp.nStatus 		= 0
            loXmlHttp.cResponseText = ""
            loXmlHttp.cURL 			= lcURL
            This.cErrorMessage 		= ""

            loXmlHttp.Get()
            loReturn = loXmlHttp.oVFP

            If Isnull( loReturn )
                loReturn = Createobject( "Empty" )
                AddProperty( loReturn, "lOk", .F. )
                AddProperty( loReturn, "nStatus", loXmlHttp.nStatus )
                AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
            Endif

            TEXT To lcMsg NoShow TextMerge Pretext 03
				Status: <<loXmlHttp.nStatus>>
				<<loXmlHttp.cResponseText>>
				<<loXmlHttp.cErrorDetail>>
            ENDTEXT

            This.cErrorMessage = lcMsg

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loBackEnd = Null
            loXmlHttp 	= Null
            loJson 		= Null
            This.oXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && Traer


    *
    *
    Procedure Modificar( cURL As String, nId As Integer, oReg As Object ) As Object
        Local lcCommand As String,;
            lcURL As String
        Local loBackEnd As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg",;
            loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJson As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object


        Try

            lcCommand = ""
            
            loBackEnd = This.oBackEnd
            lcURL = loBackEnd.cBaseUrl + cURL
            lcURL = lcURL + Transform( nId ) + "/"

            loJson = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
            This.oXmlHttp = Null
            loXmlHttp 	= This.oXmlHttp

            loXmlHttp.nStatus 		= 0
            loXmlHttp.cResponseText = ""
            loXmlHttp.cURL 			= lcURL

            loXmlHttp.cBody 		= loJson.VfpToJson( oReg )
            This.cErrorMessage 		= ""

            *loXmlHttp.Put()
            loXmlHttp.Patch()
            loReturn = loXmlHttp.oVFP

            If Isnull( loReturn )
                loReturn = Createobject( "Empty" )
                AddProperty( loReturn, "lOk", .F. )
                AddProperty( loReturn, "nStatus", loXmlHttp.nStatus )
                AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
            Endif

            TEXT To lcMsg NoShow TextMerge Pretext 03
				Status: <<loXmlHttp.nStatus>>
				<<loXmlHttp.cResponseText>>
				<<loXmlHttp.cErrorDetail>>
            ENDTEXT

            This.cErrorMessage = lcMsg

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loBackEnd = Null
            loXmlHttp 	= Null
            loJson 		= Null
            This.oXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && Modificar

    *
    *
    Procedure Borrar( cURL As String, nId As Integer ) As Object
        Local lcCommand As String,;
            lcURL As String
        Local loBackEnd As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg",;
            loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJson As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object

        Try

            lcCommand = ""

            loBackEnd = This.oBackEnd
            lcURL = loBackEnd.cBaseUrl + cURL
            lcURL = lcURL + Transform( nId ) + "/"

            loJson = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
            This.oXmlHttp = Null
            loXmlHttp 	= This.oXmlHttp

            loXmlHttp.nStatus 		= 0
            loXmlHttp.cResponseText = ""
            loXmlHttp.cURL 			= lcURL
            This.cErrorMessage 		= ""

            loXmlHttp.Delete()
            loReturn = loXmlHttp.oVFP

            If Isnull( loReturn )
                loReturn = Createobject( "Empty" )
                AddProperty( loReturn, "lOk", .F. )
                AddProperty( loReturn, "nStatus", loXmlHttp.nStatus )
                AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
            Endif

            TEXT To lcMsg NoShow TextMerge Pretext 03
				Status: <<loXmlHttp.nStatus>>
				<<loXmlHttp.cResponseText>>
				<<loXmlHttp.cErrorDetail>>
            ENDTEXT

            This.cErrorMessage = lcMsg

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loBackEnd = Null
            loXmlHttp 	= Null
            loJson 		= Null
            This.oXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && Borrar


    *
    *
    Procedure Crear( cURL As String, oReg As Object ) As Object
        Local lcCommand As String,;
            lcURL As String
        Local loBackEnd As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg",;
            loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJson As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object

        Try

            lcCommand = ""

            loBackEnd = This.oBackEnd
            lcURL = loBackEnd.cBaseUrl + cURL

            loJson = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
            This.oXmlHttp = Null
            loXmlHttp 	= This.oXmlHttp

            loXmlHttp.nStatus 		= 0
            loXmlHttp.cResponseText = ""
            loXmlHttp.cURL 			= lcURL
            loXmlHttp.cBody 		= loJson.VfpToJson( oReg )
            This.cErrorMessage 		= ""

            loXmlHttp.Post()
            loReturn = loXmlHttp.oVFP

            If Isnull( loReturn )
                loReturn = Createobject( "Empty" )
                AddProperty( loReturn, "lOk", .F. )
                AddProperty( loReturn, "nStatus", loXmlHttp.nStatus )
                AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
            Endif

            TEXT To lcMsg NoShow TextMerge Pretext 03
				Status: <<loXmlHttp.nStatus>>
				<<loXmlHttp.cResponseText>>
				<<loXmlHttp.cErrorDetail>>
            ENDTEXT

            This.cErrorMessage = lcMsg

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loBackEnd = Null
            loXmlHttp 	= Null
            loJson 		= Null

        Endtry

        Return loReturn

    Endproc && Crear


    *
    *
    Procedure Bulk_Update( cURL As String,; 
    	oRegistros As Collection ) As Object
        Local lcCommand As String,;
            lcURL As String
        Local loBackEnd As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg",;
            loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJson As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object


        Try

            lcCommand = ""

            loBackEnd = This.oBackEnd
            lcURL = loBackEnd.cBaseUrl + cURL
            *lcURL = lcURL + "bulkUpdate/"

            loJson = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
            This.oXmlHttp = Null
            loXmlHttp 	= This.oXmlHttp

            loXmlHttp.nStatus 		= 0
            loXmlHttp.cResponseText = ""
            loXmlHttp.cURL 			= lcURL + "?action=Update"

            loXmlHttp.cBody 		= loJson.VfpToJson( oRegistros )
            This.cErrorMessage 		= ""

            loXmlHttp.Patch()
            loReturn = loXmlHttp.oVFP

            If Isnull( loReturn )
                loReturn = Createobject( "Empty" )
                AddProperty( loReturn, "lOk", .F. )
                AddProperty( loReturn, "nStatus", loXmlHttp.nStatus )
                AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
            Endif

            TEXT To lcMsg NoShow TextMerge Pretext 03
				Status: <<loXmlHttp.nStatus>>
				<<loXmlHttp.cResponseText>>
				<<loXmlHttp.cErrorDetail>>
            ENDTEXT

            This.cErrorMessage = lcMsg

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loBackEnd = Null
            loXmlHttp 	= Null
            loJson 		= Null
            This.oXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && Bulk_Update

    *
    *
    Procedure Bulk_Create( cURL As String, oRegistros As Collection ) As Object
        Local lcCommand As String,;
            lcURL As String
        Local loBackEnd As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg",;
            loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJson As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object


        Try

            lcCommand = ""

            loBackEnd = This.oBackEnd
            lcURL = loBackEnd.cBaseUrl + cURL
            *lcURL = lcURL + "bulkCreate/"

            loJson = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
            This.oXmlHttp = Null
            loXmlHttp 	= This.oXmlHttp

            loXmlHttp.nStatus 		= 0
            loXmlHttp.cResponseText = ""
            loXmlHttp.cURL 			= lcURL

            loXmlHttp.cBody 		= loJson.VfpToJson( oRegistros )
            This.cErrorMessage 		= ""

            loXmlHttp.Post()
            loReturn = loXmlHttp.oVFP

            If Isnull( loReturn )
                loReturn = Createobject( "Empty" )
                AddProperty( loReturn, "lOk", .F. )
                AddProperty( loReturn, "nStatus", loXmlHttp.nStatus )
                AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
            Endif

            TEXT To lcMsg NoShow TextMerge Pretext 03
				Status: <<loXmlHttp.nStatus>>
				<<loXmlHttp.cResponseText>>
				<<loXmlHttp.cErrorDetail>>
            ENDTEXT

            This.cErrorMessage = lcMsg

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loBackEnd = Null
            loXmlHttp 	= Null
            loJson 		= Null
            This.oXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && Bulk_Create

    *
    *
    Procedure Bulk_Delete( cURL As String, oRegistros As Collection ) As Object
        Local lcCommand As String,;
            lcURL As String
        Local loBackEnd As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg",;
            loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJson As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object


        Try

            lcCommand = ""

            loBackEnd = This.oBackEnd
            lcURL = loBackEnd.cBaseUrl + cURL
            lcURL = lcURL + "bulkCreate/"

            loJson = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
            This.oXmlHttp = Null
            loXmlHttp 	= This.oXmlHttp

            loXmlHttp.nStatus 		= 0
            loXmlHttp.cResponseText = ""
            loXmlHttp.cURL 			= lcURL

            loXmlHttp.cBody 		= loJson.VfpToJson( oRegistros )
            This.cErrorMessage 		= ""

            loXmlHttp.Delete()
            loReturn = loXmlHttp.oVFP

            If Isnull( loReturn )
                loReturn = Createobject( "Empty" )
                AddProperty( loReturn, "lOk", .F. )
                AddProperty( loReturn, "nStatus", loXmlHttp.nStatus )
                AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
            Endif

            TEXT To lcMsg NoShow TextMerge Pretext 03
				Status: <<loXmlHttp.nStatus>>
				<<loXmlHttp.cResponseText>>
				<<loXmlHttp.cErrorDetail>>
            ENDTEXT

            This.cErrorMessage = lcMsg

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loBackEnd = Null
            loXmlHttp 	= Null
            loJson 		= Null
            This.oXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && Bulk_Delete

    *
    *
    Procedure Login( cUserName As String, cPassword As String ) As Boolean
        Local lcCommand As String,;
            lcURL As String
        Local loBackEnd As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg",;
            loReg As Object,;
            loRespuesta As Object

        Try

            lcCommand = ""

            This.cAuthorization = ""
            loBackEnd = This.oBackEnd
            lcURL = loBackEnd.cLogin

            loReg = Createobject( "Empty" )
            AddProperty( loReg, "password", cPassword )
            AddProperty( loReg, "username", cUserName )

            loRespuesta = This.Crear( lcURL, loReg )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loReg = Null
            loBackEnd = Null
            This.cAuthorization = "TOKEN"

        Endtry

        Return loRespuesta

    Endproc && Login


    *
    *
    Procedure ObtenerToken(  ) As String
        Local lcCommand As String,;
            lcToken As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"

        Try

            lcCommand = ""
            loUser = NewUser()
            lcToken = loUser.cToken

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loUser = Null

        Endtry

        Return lcToken

    Endproc && ObtenerToken



    *
    *
    Procedure GetNewToken(  ) As String
        Local lcCommand As String,;
            lcURL As String,;
            lcToken As String
        Local loBackEnd As oBackEndSettings Of "FW\Comunes\prg\BackEndSettings.prg",;
            loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg",;
            loReturn As Object

        Try

            lcCommand 	= ""
            lcToken 	= ""
            loBackEnd 	= This.oBackEnd
            lcURL 		= loBackEnd.cBaseUrl + loBackEnd.cRefreshToken + "?refresh=" + This.ObtenerToken()

            This.oXmlHttp = Null
            loXmlHttp 	= This.oXmlHttp

            loXmlHttp.nStatus 		= 0
            loXmlHttp.cResponseText = ""
            loXmlHttp.cURL 			= lcURL
            This.cErrorMessage 		= ""

            If loXmlHttp.Get()
                loReturn = loXmlHttp.oVFP
                lcToken = loReturn.Data.Refresh_Token
            Endif

            loUser = NewUser()
            loUser.cToken = lcToken

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loUser 		= Null
            loBackEnd 	= Null
            loReturn 	= Null

        Endtry

        Return lcToken

    Endproc && GetNewToken





    *
    * oXmlHttp_Access
    Protected Procedure oXmlHttp_Access()

        If Vartype( This.oXmlHttp ) # "O"
            This.oXmlHttp = Newobject( "prxXmlHttp", "Tools\JSON\Prg\XmlHttp.prg" )

            This.oXmlHttp.lDontBreak 		= .T.
            This.oXmlHttp.lDebug 			= FileExist( "lDebug.tag" )
            This.oXmlHttp.cAuthorization 	= This.cAuthorization

            This.oXmlHttp.cTrace 			= This.cTrace
            This.oXmlHttp.cRemark 			= This.cRemark

            If This.cAuthorization = "TOKEN"
                This.oXmlHttp.cAuthToken = This.ObtenerToken()
            Endif

        Endif

        This.oXmlHttp.lSilence	= This.lSilence

        Return This.oXmlHttp

    Endproc && oXmlHttp_Access

    *
    * oColTables_Access
    Protected Procedure oColTables_Access()

        If Isnull( This.oColTables )
            loColDataBases = NewColDataBases()
            loDataBase 	= loColDataBases.Item( 1 )
            This.oColTables = loDataBase.oColTables
        Endif

        Return This.oColTables

    Endproc && oColTables_Access

    *
    * oBackEnd_Access
    Protected Procedure oBackEnd_Access()
        If Isnull( This.oBackEnd )
            This.oBackEnd = NewBackEnd()
        Endif

        Return This.oBackEnd

    Endproc && oBackEnd_Access


    *
    * oJsontoVfp_Access
    Protected Procedure oJsontoVfp_Access()

        This.oJsontoVfp = Null
        This.oJsontoVfp = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )

        Return This.oJsontoVfp

    Endproc && oJsontoVfp_Access



Enddefine
*!*
*!* END DEFINE
*!* Class.........: ConsumirAPI
*!*
*!* ///////////////////////////////////////////////////////



