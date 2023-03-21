#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE Tools\JSON\Include\HTTP.h

Local lcCommand As String, lcMsg As String
Local loXmlHttp As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg"

Try

    lcCommand = ""
    Close Databases All

    loXmlHttp = Newobject( "prxXmlHttp", "Tools\JSON\Prg\XmlHttp.prg" )
    loXmlHttp.cURL = "https://www.dropbox.com/s/yqf5ai4onvslavf/PadronRGS012019.zip?dl=0"

    If loXmlHttp.Get()
        Messagebox( loXmlHttp.cResponseText )

    Endif

Catch To loErr

    Do While Vartype( loErr.UserValue ) == "O"
        loErr = loErr.UserValue
    Enddo

    lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
    lcMsg = lcMsg + "[  METODO   ] " + loErr.Procedure + Chr( 13 ) + Chr( 10 )
    lcMsg = lcMsg + "[  LINEA Nº ] " + Transform(loErr.Lineno) + Chr( 13 ) + Chr( 10 )
    lcMsg = lcMsg + "[  COMANDO  ] " + loErr.LineContents + Chr( 13 ) + Chr( 10 )
    lcMsg = lcMsg + "[  ERROR    ] " + Transform(loErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
    lcMsg = lcMsg + "[  MENSAJE  ] " + loErr.Message + Chr( 13 ) + Chr( 10 )
    lcMsg = lcMsg + "[  DETALLE  ] " + loErr.Details + Chr( 13 ) + Chr( 10 )
    lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
    lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )

    Strtofile( lcMsg, "ErrorLog9.txt" )

    Messagebox( lcMsg, 16, "Error", -1 )


Finally
    Close Databases All


Endtry


*!* ///////////////////////////////////////////////////////
*!* Class.........: prxXmlHttp
*!* Description...: Wrapper para el Objeto MSXML2.ServerXMLHTTP
*!* Date..........: Jueves 20 de Diciembre de 2018 (18:21:13)
*!*
*!*

Define Class prxXmlHttp As Custom

    #If .F.
        Local This As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg"
    #Endif

    * Referencia al objeto XmlHttp
    oXmlHttp 	= Null
    cURL 		= ""
    lOk 		= .F.
    cJSON 		= ""
    oVFP 		= Null
    lSilence 	= .F.

    * Indica si devuelve un objeto Vfp o un archivo Csv
    * Valores válidos: "Vfp","Csv"
    cReturnType = "Vfp"
    * Contiene el texto en formato Csv
    cCsv_Body 	= ""
    cCsv_Header = ""

    * Devuelve lOk en .F., pero no hace un Throw del error
    * El cliente lo debe manejar
    lDontBreak = .F.
    cErrorDetail = ""	&& Contiene el mensaje de error del sistema


    * Contine el string con el tipo y la clave
    * "Basic AmericaBB:g08%6vEm"
    * "Bearer " + lcAuthToken
    cAuthorization = ""

    * Token de Autorización
    cAuthToken = ""

    cContent_Type = "application/json" 	&& Default

    * It is a request type header.
    * The Accept header is used to inform the server by the client
    * that which content type is understandable by the client expressed
    * as MIME-types.
    cAccept = ""

    *
    cMethod = "GET"


    nStatus 		= 0
    cResponseText 	= ""
    cBody 			= ""
    lAsync 			= .F.
    cUser			= ""
    cPassword		= ""

    lDebug 			= .F.

    * Tiempo transcurrido en procesar le comando Send
    nElapsedSend = 0

    * Tiempo transcurrido en transformar el Json en un objeto Vfp
    nElapsedJson2Vfp = 0

    * Seguimiento de la llamada (Para debugging)
    cTrace = ""

    * Observaciones
    cRemark = ""

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="lok" type="property" display="lOk" />] + ;
        [<memberdata name="ldontbreak" type="property" display="lDontBreak" />] + ;
        [<memberdata name="cerrordetail" type="property" display="cErrorDetail" />] + ;
        [<memberdata name="lasync" type="property" display="lAsync" />] + ;
        [<memberdata name="cbody" type="property" display="cBody" />] + ;
        [<memberdata name="cuser" type="property" display="cUser" />] + ;
        [<memberdata name="cpassword" type="property" display="cPassword" />] + ;
        [<memberdata name="oxmlhttp" type="property" display="oXmlHttp" />] + ;
        [<memberdata name="oxmlhttp_access" type="method" display="oXmlHttp_Access" />] + ;
        [<memberdata name="curl" type="property" display="cURL" />] + ;
        [<memberdata name="curl_assign" type="method" display="cURL_Assign" />] + ;
        [<memberdata name="send" type="method" display="Send" />] + ;
        [<memberdata name="refreshtoken" type="method" display="RefreshToken" />] + ;
        [<memberdata name="cmethod" type="property" display="cMethod" />] + ;
        [<memberdata name="get" type="method" display="Get" />] + ;
        [<memberdata name="put" type="method" display="Put" />] + ;
        [<memberdata name="patch" type="method" display="Patch" />] + ;
        [<memberdata name="post" type="method" display="Post" />] + ;
        [<memberdata name="delete" type="method" display="Delete" />] + ;
        [<memberdata name="nstatus" type="property" display="nStatus" />] + ;
        [<memberdata name="cresponsetext" type="property" display="cResponseText" />] + ;
        [<memberdata name="cjson" type="property" display="cJSON" />] + ;
        [<memberdata name="ovfp" type="property" display="oVFP" />] + ;
        [<memberdata name="lsilence" type="property" display="lSilence" />] + ;
        [<memberdata name="open" type="method" display="Open" />] + ;
        [<memberdata name="cauthorization" type="property" display="cAuthorization" />] + ;
        [<memberdata name="cauthtoken" type="property" display="cAuthToken" />] + ;
        [<memberdata name="ccontent_type" type="property" display="cContent_Type" />] + ;
        [<memberdata name="caccept" type="property" display="cAccept" />] + ;
        [<memberdata name="ldebug" type="property" display="lDebug" />] + ;
        [<memberdata name="extractexceptiontype" type="method" display="ExtractExceptionType" />] + ;
        [<memberdata name="nelapsedsend" type="property" display="nElapsedSend" />] + ;
        [<memberdata name="nelapsedjson2vfp" type="property" display="nElapsedJson2Vfp" />] + ;
        [<memberdata name="creturntype" type="property" display="cReturnType" />] + ;
        [<memberdata name="getqueryinfo" type="method" display="GetQueryInfo" />] + ;
        [<memberdata name="ccsv_body" type="property" display="cCsv_Body" />] + ;
        [<memberdata name="ccsv_header" type="property" display="cCsv_Header" />] + ;
        [<memberdata name="ctrace" type="property" display="cTrace" />] + ;
        [<memberdata name="cremark" type="property" display="cRemark" />] + ;
        [<memberdata name="validateurl" type="method" display="ValidateURL" />] + ;
        [</VFPData>]


    *
    * oXmlHttp_Access
    Protected Procedure oXmlHttp_Access()

        If Vartype( This.oXmlHttp ) # "O"
            *This.oXmlHttp = Createobject( "MSXML2.ServerXMLHTTP" )
            * RA 04/08/2021(16:58:36)
            * En Casa Eduardo daba error con la version ServerXMLHTTP
            * [  COMANDO  ] loXmlHttp.Send( '' )
            * [  ERROR    ] 1429
            * [  MENSAJE  ] OLE IDispatch exception code 0 from msxml3.dll: La conexión con el servidor finalizó anormalmente

            * Se corrigió usando XMLHTTP.6.0
            This.oXmlHttp = Createobject( "MSXML2.XMLHTTP.6.0" )
        Endif

        Return This.oXmlHttp

    Endproc && oXmlHttp_Access

    *
    *
    Procedure Open(  ) As Void
        Local lcCommand As String
        Local loXmlHttp As 'MSXML2.XMLHTTP'
        Local llOk As Boolean

        Try

            lcCommand 			= ""
            This.lOk 			= .F.
            llOk 				= .F.
            This.oXmlHttp 		= Null
            This.oVFP 			= Null
            This.cErrorDetail 	= ""
            This.cCsv_Body 		= ""
            This.cCsv_Header 	= "" 

            loXmlHttp = This.oXmlHttp
            
            loXmlHttp.Open( This.cMethod, This.cURL, This.lAsync, This.cUser, This.cPassword )

            If !Empty( This.cAccept )
                loXmlHttp.SetRequestHeader( "Accept", This.cAccept )
            Endif

            If !Empty( This.cContent_Type )
                loXmlHttp.SetRequestHeader( "Content-Type", This.cContent_Type )
            Endif


            If !Empty( This.cAuthorization )
                This.cAuthorization = Alltrim( Upper( This.cAuthorization ))

                Do Case
                    Case This.cAuthorization = "BASIC"
                        lcToken = Strconv( This.cUser + ":" + This.cPassword ,13 )
                        This.cAuthorization = "BASIC " + lcToken

                    Case This.cAuthorization = "TOKEN"
                        This.cAuthorization = "TOKEN " + This.cAuthToken

                    Otherwise

                Endcase

                loXmlHttp.SetRequestHeader( "Authorization", This.cAuthorization )
            Endif

            llOk = .T.

        Catch To loErr

            Try

                TEXT To lcOpenStr NoShow TextMerge Pretext 03
				Method   		= '<<This.cMethod>>'
				Url      		= '<<This.cURL>>'
				Async    		= '<<This.lAsync>>'
				User     		= '<<This.cUser>>'
				Password 		= '<<This.cPassword>>'
				Authorization 	= '<<This.cAuthorization>>'
				Content-Type 	= '<<This.cContent_Type>>'
				Body			= '<<This.cBody>>'
				Status			= '<<This.nStatus>>'
				ResponseText	= '<<This.cResponseText>>'
                ENDTEXT

                Strtofile( lcOpenStr, "Api_Url_Open.txt" )

            Catch To oErr

            Finally

            Endtry

            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr, !This.lDontBreak )

            If !This.lDontBreak
                Throw loError

            Else
                This.cErrorDetail = loErr.Details

            Endif


        Finally

        Endtry

        Return llOk


    Endproc && Open

    *
    *
    Procedure Get(  ) As Boolean
        Local lcCommand As String

        Try

            lcCommand = ""

            This.cMethod = "GET"

            If This.Open()
                If !This.Send()
                    This.RefreshToken()
                Endif
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr, !This.lDontBreak )

            If !This.lDontBreak
                Throw loError

            Else
                This.cErrorDetail = loErr.Details

            Endif

        Finally


        Endtry

        Return This.lOk

    Endproc && Get


    *
    *
    Procedure Put(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""

            This.cMethod = "PUT"

            If This.Open()
                If !This.Send()
                    This.RefreshToken()
                Endif
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr, !This.lDontBreak )

            If !This.lDontBreak
                Throw loError

            Else
                This.cErrorDetail = loErr.Details

            Endif

        Finally

        Endtry

        Return This.lOk

    Endproc && Put

    *
    *
    Procedure Patch(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""

            This.cMethod = "PATCH"

            If This.Open()
                If !This.Send()
                    This.RefreshToken()
                Endif
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr, !This.lDontBreak )

            If !This.lDontBreak
                Throw loError

            Else
                This.cErrorDetail = loErr.Details

            Endif

        Finally

        Endtry

        Return This.lOk

    Endproc && Patch

    *
    *
    Procedure Post(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""
            This.cMethod = "POST"
            *This.cURL = Addbs( Alltrim( This.cURL ))

            If This.Open()
                If !This.Send()
                    This.RefreshToken()
                Endif
            Endif


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr, !This.lDontBreak )

            If !This.lDontBreak
                Throw loError

            Else
                This.cErrorDetail = loErr.Details

            Endif

        Finally

        Endtry

        Return This.lOk

    Endproc && Post

    *
    *
    Procedure Delete(  ) As Boolean
        Local lcCommand As String

        Try

            lcCommand = ""

            This.cMethod = "DELETE"

            If This.Open()
                If !This.Send()
                    This.RefreshToken()
                Endif
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr, !This.lDontBreak )

            If !This.lDontBreak
                Throw loError

            Else
                This.cErrorDetail = loErr.Details

            Endif

        Finally

        Endtry

        Return This.lOk

    Endproc && Delete


    *
    *
    Procedure Send(  ) As Void
        Local lcCommand As String,;
            lcToken As String,;
            lcLogFileName As String,;
            lcCount As String,;
            lcTrace As String,;
            lcQueryInfo As String

        Local loXmlHttp As 'MSXML2.XMLHTTP',;
            loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loVfp As Object,;
            loRespuesta As Object

        Local llErrorNoManejado As Boolean
        Local lnStart As Number
        Local lnCount As Integer

        Try

            lcCommand = ""
            lcQueryInfo 			= ""
            lnStart 				= Seconds()
            This.nElapsedSend 		= 0
            This.nElapsedJson2Vfp 	= 0
            This.lOk 				= .F.
            llErrorNoManejado 		= .F.
            lnCount 				= 0

            loXmlHttp = This.oXmlHttp

            TEXT To lcMsg NoShow TextMerge Pretext 03
			Conectando con la Web ...
			<<This.cMethod>>
			<<This.cURL>>
            ENDTEXT

            If !This.lSilence
                Try

                    Wait Window Nowait Noclear lcMsg

                Catch To oErr
                    TEXT To lcMsg NoShow TextMerge Pretext 03
					Conectando con la Web ...
					<<This.cMethod>>
                    ENDTEXT

                    Wait Window Nowait Noclear lcMsg

                Finally

                Endtry

            Endif

            Try

                lcCommand = ""

                lnStart = Seconds()
                loXmlHttp.Send( This.cBody )
                This.nElapsedSend = Seconds() - lnStart

                This.nStatus 		= loXmlHttp.Status
                This.cResponseText 	= loXmlHttp.ResponseText

                If At( "DOCTYPE", This.cResponseText ) > 0
                    *This.cResponseText 	= loXmlHttp.statusText
                    This.cResponseText 	= This.ExtractExceptionType( loXmlHttp )
                Endif


            Catch To loErr

                If loErr.ErrorNo = 1429
                    This.nStatus 		= loXmlHttp.Status
                    This.cResponseText 	= loXmlHttp.ResponseText

                    If Empty( This.nStatus )
                        This.nStatus = 503
                    Endif
                    If Empty( loXmlHttp.ResponseText )
                        This.cResponseText = "El servidor no está listo para manejar la petición"
                    Endif

                Else
                    llErrorNoManejado = .T.

                    Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
                    loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
                    loError.cRemark = lcCommand

                    loError.Process ( m.loErr )
                    Throw loError

                Endif


            Finally
                If !This.lSilence
                    Wait Clear
                Endif

            Endtry

            If llErrorNoManejado = .F.

                This.lOk = Inlist( This.nStatus, ;
                    _HTTP_200_OK, ;
                    _HTTP_201_CREATED,;
                    _HTTP_204_NO_CONTENT )

                Try

                    This.oVFP 			= Null
                    This.cCsv_Body 		= ""
                    This.cCsv_Header 	= ""
                    
                    lcToken = Substr( loXmlHttp.ResponseText, 1, 1 )

                    lnStart = Seconds()
                    This.nElapsedJson2Vfp = 0

                    Do Case
                        Case This.nStatus = _HTTP_409_CONFLICT ;
                                And Inlist( Substr( This.cResponseText, 1, 1 ), "{", "[" )

                            loJSON 		= Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
                            loRespuesta = loJSON.JsonToVfp( This.cResponseText )
                            This.nElapsedJson2Vfp = Seconds()  - lnStart

                        Case This.nStatus = _HTTP_204_NO_CONTENT
                            loRespuesta = Createobject( "Empty" )
                            AddProperty( loRespuesta, "l_oVfp_Ok", .T. )
                            AddProperty( loRespuesta, "detail", "Null" )

                        Case !Inlist( lcToken, "{", "[" )
                            loRespuesta = Createobject( "Empty" )
                            AddProperty( loRespuesta, "l_oVfp_Ok", .F. )
                            AddProperty( loRespuesta, "detail", "Null" )

                            Do Case
                                Case This.nStatus >= _http_500_internal_server_error
                                    lcMsg = "Error al Conectarse al Servidor"

                                    Do Case
                                        Case This.nStatus = _HTTP_501_NOT_IMPLEMENTED
                                            TEXT To This.cResponseText NoShow TextMerge Pretext 03
											<<lcMsg>>

											Servicio No Implementado

                                            ENDTEXT

                                        Case This.nStatus = _HTTP_503_SERVICE_UNAVAILABLE
                                            TEXT To This.cResponseText NoShow TextMerge Pretext 03
											<<lcMsg>>

											Servicio No Disponible

                                            ENDTEXT

                                        Otherwise
                                            TEXT To This.cResponseText NoShow TextMerge Pretext 03
											<<lcMsg>>

											Error Interno

                                            ENDTEXT

                                    Endcase



                                Otherwise

                            Endcase

                        Otherwise
                            loJSON	= Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
                            
                            Do Case
                                Case This.cReturnType = "Vfp"
                                    loRespuesta = loJSON.JsonToVfp( loXmlHttp.ResponseText )

                                Case This.cReturnType = "Csv"
                                    lcQueryInfo 		= This.GetQueryInfo( loXmlHttp.ResponseText )
                                    loRespuesta 		= loJSON.JsonToVfp( lcQueryInfo )
                                    This.cCsv_Body 		= loJSON.JsonToCsv( loXmlHttp.ResponseText )
                                    This.cCsv_Header 	= loJSON.JsonToCsv( loXmlHttp.ResponseText,, .T. )

                                Otherwise
                                    Error "This.cReturnType: '" + This.cReturnType + "' NO RECONOCIDO"

                            Endcase
                            This.nElapsedJson2Vfp = Seconds()  - lnStart

                    Endcase

                    If loRespuesta.l_oVfp_Ok = .T.
                        Removeproperty( loRespuesta, "l_oVfp_Ok" )
                        loVfp = Createobject( "Empty" )
                        AddProperty( loVfp, "lOk", This.lOk )
                        AddProperty( loVfp, "nStatus", This.nStatus )
                        AddProperty( loVfp, "cResponseText", This.cResponseText )
                        AddProperty( loVfp, "cErrorMessage", "" )
                        AddProperty( loVfp, "Data", loRespuesta )

                        If !This.lOk

                            TEXT To loVfp.cErrorMessage NoShow TextMerge Pretext 03
							Status: <<This.nStatus>>
							<<This.cResponseText>>
                            ENDTEXT

                        Endif

                        This.oVFP = loVfp

                    Else

                        loRespuesta = Createobject( "Empty" )
                        *AddProperty( loRespuesta, "lOk", .F. )
                        AddProperty( loRespuesta, "lOk", This.lOk )
                        AddProperty( loRespuesta, "nStatus", This.nStatus )
                        AddProperty( loRespuesta, "cResponseText", This.cResponseText )

                        If !Inlist( lcToken, "{", "[" )
                            AddProperty( loRespuesta, "cErrorMessage", This.cResponseText )

                        Else
                            AddProperty( loRespuesta, "cErrorMessage", "Error al convertir JSON a oVfp" )

                        Endif
                        *AddProperty( loRespuesta, "Data", loRespuesta )

                        This.oVFP = loRespuesta

                    Endif

                Catch To oErr

                Finally

                    If !This.lOk
                        If This.lDebug

                            TEXT To lcMsg NoShow TextMerge Pretext 03
							loXmlHttp.Open( '<<This.cMethod>>', '<<This.cURL>>', <<This.lAsync>>, '<<This.cUser>>', '<<This.cPassword>>' )

							loXmlHttp.Send( '<<This.cBody>>' )
                            ENDTEXT

                            Logerror( lcMsg )

                        Endif
                    Endif

                Endtry


            Endif


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'

            If !This.lSilence
                Wait Clear
            Endif

            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr, !This.lDontBreak )

            If !This.lDontBreak
                Throw loError

            Else
                This.cErrorDetail = loErr.Details

            Endif

        Finally
            Try

                lcCount = ""
                lcTrace = ""
                Try

                    AddProperty( This.oVFP, "nElapsedSend", This.nElapsedSend )
                    AddProperty( This.oVFP, "nElapsedJson2Vfp", This.nElapsedJson2Vfp )

                    If This.lOk
                        loData = This.oVFP.Data
                        TEXT To lcCount NoShow TextMerge Pretext 03
						Count           = <<Transform( loData.Count )>>
						Total Páginas   = <<Transform( loData.total_pages )>>
						Página          = <<Transform( loData.current_page )>>
                        ENDTEXT

                    Endif

                    If !Empty( This.cTrace ) Or !Empty( This.cRemark )
                        TEXT To lcTrace NoShow TextMerge Pretext 03
						Trace           = <<This.cTrace>>

						Observaciones   = <<This.cRemark>>
                        ENDTEXT
                    Endif

                Catch To oErr

                Finally

                Endtry


                TEXT To lcCommand NoShow TextMerge Pretext 03
				<<Ttoc( Datetime() )>>

				Method   		= '<<This.cMethod>>'
				Url      		= '<<This.cURL>>'
				Async    		= '<<This.lAsync>>'
				User     		= '<<This.cUser>>'
				Password 		= '<<This.cPassword>>'
				Authorization 	= '<<This.cAuthorization>>'
				Accept          = '<<This.cAccept>>'
				Content-Type 	= '<<This.cContent_Type>>'
				Body			= '<<This.cBody>>'
				Status			= '<<This.nStatus>>'
				ResponseText	= '<<This.cResponseText>>'

				<<lcCount>>
				Send            = <<Transform( This.nElapsedSend )>>
				Json to Vfp     = <<Transform( This.nElapsedJson2Vfp )>>

				<<lcTrace>>
                ENDTEXT

                lcLogFileName = "Api_Url_" + Dtos( Date() ) + ".txt"

                Strtofile( lcCommand + CRLF + CRLF, lcLogFileName, Iif( This.lDebug, 1, 0 ) )

                If !This.lOk And !Inlist( This.nStatus, _HTTP_404_NOT_FOUND, _HTTP_401_UNAUTHORIZED )
                    *Logerror( lcCommand, 0, loXmlHttp.ResponseText )
                    Logerror( lcCommand, 0, This.cResponseText )
                Endif

            Catch To oErr

            Finally

            Endtry

        Endtry

        Return This.lOk

    Endproc && Send


    *
    *
    Procedure RefreshToken(  ) As Void
        Local lcCommand As String,;
            lcToken As String
        Local loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg",;
            loReturn As Object,;
            loErrorMsg as Object 

        Try

            lcCommand = ""
            If This.nStatus = _HTTP_401_UNAUTHORIZED
            
                loReturn 	= This.oVFP
                loErrorMsg 	= loReturn.Data.errors.Item(1)
                
                If loErrorMsg.Code = "TOKEN_VENCIDO"

                    loConsumirAPI = Newobject( "ConsumirAPI", "FW\Comunes\prg\BackEndSettings.prg" )
                    lcToken = loConsumirAPI.GetNewToken()
                    This.cAuthToken = lcToken

                    * Repetir la consulta
                    If This.Open()
                        This.Send()
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
            loConsumirAPI 	= Null
            loReturn 		= Null

        Endtry

    Endproc && RefreshToken

    *
    *
    Procedure xxx___RefreshToken(  ) As Void
        Local lcCommand As String,;
            lcToken As String
        Local loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg",;
            loReturn As Object

        Try

            lcCommand = ""
            If This.nStatus = _HTTP_401_UNAUTHORIZED
            
                loReturn = This.oVFP
                If loReturn.Data.Error = "Token Vencido."

                    loConsumirAPI = Newobject( "ConsumirAPI", "FW\Comunes\prg\BackEndSettings.prg" )
                    lcToken = loConsumirAPI.GetNewToken()
                    This.cAuthToken = lcToken

                    * Repetir la consulta
                    If This.Open()
                        This.Send()
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
            loConsumirAPI 	= Null
            loReturn 		= Null

        Endtry

    Endproc && xxx___RefreshToken


    *
    *
    Procedure ExtractExceptionType( oXmlHttp As Object ) As String
        Local lcCommand As String,;
            lcErrorMsg As String
        Local loXmlHttp As 'MSXML2.XMLHTTP',;
            loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
            loColHtmlErrors As oColHtmlErrors Of "Tools\ErrorHandler\prg\HtmlErrors.prg",;
            loError As Object
        Local lnLen As Integer,;
            i As Integer

        Try

            lcCommand = ""
            loXmlHttp = oXmlHttp
            lcErrorMsg = loXmlHttp.statusText

            lnLen = Alines( aErrors, loXmlHttp.responseText,1+4+8, CR, LF )
            If lnLen > 0

                lnLen = Ascan( aErrors, "Exception Type: ",-1,-1,1,1 )
                If lnLen > 0
                    lcErrorMsg = '{"Error":['
                    For i = lnLen To lnLen + 2
                        lcErrorMsg = lcErrorMsg + '"' + aErrors[i] + '",'
                    Endfor

                    lcErrorMsg = Substr( lcErrorMsg, 1, Len( lcErrorMsg ) -1 ) + ']}'
                    *lcErrorMsg = Strtran( lcErrorMsg, "&#x27;", ['] )

                    loGlobalSettings = NewGlobalSettings()
                    loColHtmlErrors = loGlobalSettings.oHtmlErrors
                    For Each loError In loColHtmlErrors
                        lcErrorMsg = Strtran( lcErrorMsg, loError.Html, loError.Char )
                    Endfor

                    This.nStatus = _HTTP_409_CONFLICT
                Endif

            Endif


        Catch To loErr
            *!*			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            *!*			loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            *!*			loError.cRemark = lcCommand
            *!*			loError.Process ( m.loErr )
            *!*			Throw loError

        Finally
            loXmlHttp 			= Null
            oXmlHttp  			= Null
            loError 			= Null
            loColHtmlErrors 	= Null
            loGlobalSettings 	= Null

        Endtry

        Return lcErrorMsg

    Endproc && ExtractExceptionType

    *
    * Devuelve el encabezado con la información de la consulta
    Procedure GetQueryInfo( cResponseText As String ) As String;
            HELPSTRING "Devuelve el encabezado con la información de la consulta"
        Local lcCommand As String,;
            lcReturn As String

        Try

            lcCommand = ""
            lcReturn = Substr( cResponseText, 1, At( ',"results":', cResponseText )) + '"results":[]}'


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return lcReturn

    Endproc && GetQueryInfo


    *
    * https://www.urlencoder.io/learn/#:~:text=A%20URL%20is%20composed%20from,%22%20%2C%20%22~%22%20).
    * Verificar que no vayan caracteres prohibidos
    Procedure ValidateURL( cURL As String ) As String
        Local lcCommand As String,;
            lcURL As String

        Local lnLen As Integer,;
            i As Integer

        Try

            lcCommand = ""
            lnLen = 20

            Dimension aChars[ lnLen, 2 ]

            aChars[01,1] = "%"
            *aChars[17,2] = "%"
            aChars[01,2] = "%25"

*!*	            aChars[01,1] = " "
*!*	            aChars[01,2] = "%20"

            aChars[02,1] = "!"
            aChars[02,2] = "%21"

            aChars[03,1] = "*"
            aChars[03,2] = "%2A"

            aChars[04,1] = "'"
            aChars[04,2] = "%27"

            aChars[05,1] = "("
            aChars[05,2] = "%28"

            aChars[06,1] = ")"
            aChars[06,2] = "%29"

            aChars[07,1] = ";"
            aChars[07,2] = "%3B"

            aChars[08,1] = ":"
            aChars[08,2] = "%3A"

            aChars[09,1] = "@"
            aChars[09,2] = "%40"

            aChars[10,1] = "&"
            aChars[10,2] = "%26"

            aChars[11,1] = "="
            aChars[11,2] = "%3D"

            aChars[12,1] = "+"
            aChars[12,2] = "%2B"

            aChars[13,1] = "$"
            aChars[13,2] = "%24"

            aChars[14,1] = ","
            aChars[14,2] = "%2C"

            aChars[15,1] = "/"
            aChars[15,2] = "%2F"
            
            aChars[16,1] = "?"
            aChars[16,2] = "%3f"

            aChars[17,1] = " "
            aChars[17,2] = "%20"

*!*	            aChars[17,1] = "%"
*!*	            *aChars[17,2] = "%"
*!*	            aChars[17,2] = "%25"

            aChars[18,1] = "#"
            aChars[18,2] = "%23"

            aChars[19,1] = "["
            aChars[19,2] = "%5B"

            aChars[20,1] = "]"
            aChars[20,2] = "%5D"

            lcURL = cURL
            For i = 1 To lnLen
                lcURL = Strtran( lcURL, aChars[ i, 1 ], aChars[ i, 2 ] )
            Endfor

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return lcURL

    Endproc && ValidateURL


Enddefine
*!*
*!* END DEFINE
*!* Class.........: prxXmlHttp
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: ConsumirAPI
*!* Description...:
*!* Date..........: Miércoles 8 de Enero de 2020 (20:40:00)
*!*
*!*

Define Class ConsumirAPI As Custom

    #If .F.
        Local This As ConsumirAPI Of "Tools\JSON\Prg\XmlHttp.prg"
    #Endif

    oJsontoVfp 		= Null
    oXmlHttp 		= Null
    cURL 			= ""
    cErrorMessage 	= ""
    lSilence 		= .F.

    * Contine el string con el tipo y la clave
    * "Basic AmericaBB:g08%6vEm"
    * "Bearer " + lcAuthToken
    cAuthorization = "TOKEN"

    * Token de Autorización
    cAuthToken = ""

    * Colección de Tablas
    oColTables 		= Null

    * Nombre del campo que contiene el Token
    cToken = "TOKEN"

    * Nombre del campo que contiene la URL de Autorización
    cAuth_Url = "Auth_Url"

    * Archivo de Configuracion
    cIniFile = "ar0Web"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="lsilence" type="property" display="lSilence" />] + ;
        [<memberdata name="curl" type="property" display="cUrl" />] + ;
        [<memberdata name="cerrormessage" type="property" display="cErrorMessage" />] + ;
        [<memberdata name="ojsontovfp" type="property" display="oJsontoVfp" />] + ;
        [<memberdata name="oxmlhttp" type="property" display="oXmlHttp" />] + ;
        [<memberdata name="exportar" type="method" display="Exportar" />] + ;
        [<memberdata name="getall" type="method" display="GetAll" />] + ;
        [<memberdata name="getbyid" type="method" display="GetById" />] + ;
        [<memberdata name="getbycodigo" type="method" display="GetByCodigo" />] + ;
        [<memberdata name="getbywhere" type="method" display="GetByWhere" />] + ;
        [<memberdata name="putbyid" type="method" display="PutById" />] + ;
        [<memberdata name="patchbyid" type="method" display="PatchById" />] + ;
        [<memberdata name="patchbycodigo" type="method" display="PatchByCodigo" />] + ;
        [<memberdata name="post" type="method" display="Post" />] + ;
        [<memberdata name="deletebyid" type="method" display="DeleteById" />] + ;
        [<memberdata name="deletebycodigo" type="method" display="DeleteByCodigo" />] + ;
        [<memberdata name="createorupdate" type="method" display="CreateOrUpdate" />] + ;
        [<memberdata name="registrossoniguales" type="method" display="RegistrosSonIguales" />] + ;
        [<memberdata name="obtenertoken" type="method" display="ObtenerToken" />] + ;
        [<memberdata name="cauthorization" type="property" display="cAuthorization" />] + ;
        [<memberdata name="cauthtoken" type="property" display="cAuthToken" />] + ;
        [<memberdata name="articulos" type="method" display="Articulos" />] + ;
        [<memberdata name="grupos" type="method" display="Grupos" />] + ;
        [<memberdata name="lineas" type="method" display="Lineas" />] + ;
        [<memberdata name="varios" type="method" display="Varios" />] + ;
        [<memberdata name="proveedores" type="method" display="Proveedores" />] + ;
        [<memberdata name="jurisdicciones" type="method" display="Jurisdicciones" />] + ;
        [<memberdata name="monedas" type="method" display="Monedas" />] + ;
        [<memberdata name="ctoken" type="property" display="cToken" />] + ;
        [<memberdata name="cauth_url" type="property" display="cAuth_Url" />] + ;
        [<memberdata name="obtenerapi" type="method" display="ObtenerAPI" />] + ;
        [<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
        [<memberdata name="ocoltables_access" type="method" display="oColTables_Access" />] + ;
        [<memberdata name="cinifile" type="property" display="cIniFile" />] + ;
        [</VFPData>]

    *
    *
    Procedure Init(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""
            This.oJsontoVfp = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )

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
    Procedure GetAll( cFilter As String ) As Object
        Local lcCommand As String
        Local loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object,;
            loNextPage As Object,;
            loReg As Object

        Try

            lcCommand = ""

            loReturn = This.ObtenerToken()

            If loReturn.lOk

                loXmlHttp 	= This.oXmlHttp

                loXmlHttp.nStatus 		= 0
                loXmlHttp.cResponseText = ""
                loXmlHttp.cURL 			= ""
                This.cErrorMessage 		= ""

                If Empty( cFilter )
                    loXmlHttp.cURL = This.cURL

                Else
                    loXmlHttp.cURL = This.cURL + "?" + cFilter

                Endif

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

                    loData = loReturn.Data
                    loReturn.Data = loData.Results
                    AddProperty( loReturn, "Count", loData.Count )

                    * Si loData.Count > 100, viene paginado
                    * Realizar todas las consultas e ir agregando los
                    * items a la colección.
                    * Si aparecen problemas de memoria, se podría armar crear un cursor

                    Do While !IsEmpty( loData.Next )

                        loXmlHttp.nStatus 		= 0
                        loXmlHttp.cResponseText = ""
                        loXmlHttp.cURL 			= loData.Next

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

                            For Each loReg In loData.Results

                                loReturn.Data.Add( loReg )

                            Endfor

                            pepe = 1

                        Else
                            loData = Createobject( "Empty" )
                            AddProperty( loData, "Next", "" )

                        Endif

                    Enddo
                Endif
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loXmlHttp 	= Null
            loJSON 		= Null
            loNextPage 	= Null
            loReg 		= Null

        Endtry

        Return loReturn

    Endproc && GetAll



    *
    *
    Procedure GetById( nId As Integer ) As Object
        Local lcCommand As String
        Local loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object

        Try

            lcCommand = ""
            loReturn = This.ObtenerToken()

            If loReturn.lOk

                loXmlHttp 	= This.oXmlHttp

                loXmlHttp.nStatus 		= 0
                loXmlHttp.cResponseText = ""
                loXmlHttp.cURL 			= ""
                This.cErrorMessage 		= ""
                loXmlHttp.cURL 			= This.cURL + Transform( nId ) + "/"

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
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loXmlHttp = Null

        Endtry

        Return loReturn


    Endproc && GetById


    *
    *
    Procedure GetByCodigo( cCodigo As String ) As Object
        Local lcCommand As String
        Local loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object

        Try

            lcCommand = ""
            loReturn = This.ObtenerToken()

            If loReturn.lOk
                loXmlHttp 	= This.oXmlHttp

                loXmlHttp.nStatus 		= 0
                loXmlHttp.cResponseText = ""
                loXmlHttp.cURL 			= ""
                This.cErrorMessage 		= ""
                loXmlHttp.cURL 			= This.cURL + Transform( Alltrim( cCodigo )) + "/"

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
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loXmlHttp = Null

        Endtry

        Return loReturn


    Endproc && GetByCodigo


    *
    *
    Procedure GetByWhere( cFilter As String ) As Object
        Local lcCommand As String
        Local loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object

        Try

            lcCommand = ""
            loReturn = This.ObtenerToken()
            If loReturn.lOk
                loXmlHttp 	= This.oXmlHttp

                loXmlHttp.nStatus 		= 0
                loXmlHttp.cResponseText = ""
                loXmlHttp.cURL 			= ""
                This.cErrorMessage 		= ""

                If Empty( cFilter )
                    loXmlHttp.cURL = This.cURL

                Else
                    loXmlHttp.cURL = This.cURL + "?" + cFilter

                Endif

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
            Endif
        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && GetByWhere



    *
    *
    Procedure PutById( oModelo As Object, uId As Variant ) As Object
        Local lcCommand As String

        Try

            lcCommand = ""
            loReturn = This.ObtenerToken()
            If loReturn.lOk
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && PutById



    *
    *
    Procedure PatchById( oModelo As Object, nId As Integer ) As Object
        Local loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object

        Try

            lcCommand = ""
            loReturn = This.ObtenerToken()
            If loReturn.lOk
                loJSON 		= This.oJsontoVfp
                loXmlHttp 	= This.oXmlHttp

                loXmlHttp.nStatus 		= 0
                loXmlHttp.cResponseText = ""
                loXmlHttp.cURL 			= ""
                This.cErrorMessage 		= ""
                loXmlHttp.cURL 			= This.cURL + Transform( nId ) + "/"
                loXmlHttp.cBody 		= loJSON.VfpToJson( oModelo )

                loXmlHttp.Patch()
                loReturn = loXmlHttp.oVFP

                If Isnull( loReturn )
                    loReturn = Createobject( "Empty" )
                    AddProperty( loReturn, "lOk", .F. )
                    AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
                Endif

                TEXT To lcMsg NoShow TextMerge Pretext 03
			Status: <<loXmlHttp.nStatus>>
			<<loXmlHttp.cResponseText>>
			<<loXmlHttp.cErrorDetail>>
                ENDTEXT

                This.cErrorMessage = lcMsg
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && PatchById


    *
    *
    Procedure PatchByCodigo( oModelo As Object, cCodigo As Variant ) As Object
        Local loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object

        Try

            lcCommand = ""
            loReturn = This.ObtenerToken()
            If loReturn.lOk
                loJSON 		= This.oJsontoVfp
                loXmlHttp 	= This.oXmlHttp

                loXmlHttp.nStatus 		= 0
                loXmlHttp.cResponseText = ""
                loXmlHttp.cURL 			= ""
                This.cErrorMessage 		= ""
                loXmlHttp.cURL 			= This.cURL + Transform( Alltrim( cCodigo )) + "/"
                loXmlHttp.cBody 		= loJSON.VfpToJson( oModelo )

                loXmlHttp.Patch()
                loReturn = loXmlHttp.oVFP

                If Isnull( loReturn )
                    loReturn = Createobject( "Empty" )
                    AddProperty( loReturn, "lOk", .F. )
                    AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
                Endif

                TEXT To lcMsg NoShow TextMerge Pretext 03
			Status: <<loXmlHttp.nStatus>>
			<<loXmlHttp.cResponseText>>
			<<loXmlHttp.cErrorDetail>>
                ENDTEXT

                This.cErrorMessage = lcMsg

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && PatchByCodigo


    *
    *
    Procedure Post( oModelo As Object) As Object
        Local loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object

        Try

            lcCommand = ""
            loReturn = This.ObtenerToken()
            If loReturn.lOk
                loJSON 		= This.oJsontoVfp
                loXmlHttp 	= This.oXmlHttp

                loXmlHttp.nStatus 		= 0
                loXmlHttp.cResponseText = ""
                loXmlHttp.cURL 			= ""
                This.cErrorMessage 		= ""
                loXmlHttp.cURL 			= This.cURL
                loXmlHttp.cBody 		= loJSON.VfpToJson( oModelo )

                loXmlHttp.Post()
                loReturn = loXmlHttp.oVFP

                If Isnull( loReturn )
                    loReturn = Createobject( "Empty" )
                    AddProperty( loReturn, "lOk", .F. )
                    AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
                Endif

                TEXT To lcMsg NoShow TextMerge Pretext 03
			Status: <<loXmlHttp.nStatus>>
			<<loXmlHttp.cResponseText>>
			<<loXmlHttp.cErrorDetail>>
                ENDTEXT

                This.cErrorMessage = lcMsg
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && Post

    *
    *
    Procedure CreateOrUpdate( oModelo As Object,;
            uId As Variant,;
            lCodigo As Boolean ) As Object

        Local lcCommand As String
        Local loRespuesta As Object
        Local llById As Boolean

        Try

            lcCommand = ""
            loReturn = This.ObtenerToken()
            If loReturn.lOk
                If lCodigo
                    llById = .F.

                Else
                    llById = Inlist( Vartype( uId ), "I", "N" )

                Endif

                If llById
                    loRespuesta = This.GetById( uId )

                Else
                    loRespuesta = This.GetByCodigo( uId )

                Endif

                If loRespuesta.lOk
                    If !This.RegistrosSonIguales( oModelo, loRespuesta.Data )
                        If llById
                            loRespuesta = This.PatchById( oModelo, uId )

                        Else
                            loRespuesta = This.PatchByCodigo( oModelo, uId )

                        Endif

                    Endif

                Else
                    If loRespuesta.nStatus = _HTTP_404_NOT_FOUND
                        loRespuesta = This.Post( oModelo )
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

        Return loRespuesta

    Endproc && CreateOrUpdate

    *
    *
    Procedure DeleteById( nId As Integer ) As Object
        Local lcCommand As String
        Local loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object

        Try

            lcCommand = ""
            loReturn = This.ObtenerToken()
            If loReturn.lOk
                loXmlHttp 	= This.oXmlHttp

                loXmlHttp.nStatus 		= 0
                loXmlHttp.cResponseText = ""
                This.cErrorMessage 		= ""
                loXmlHttp.cURL 			= This.cURL + Transform( nId ) + "/"

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
            Endif
        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && DeleteById

    *
    *
    Procedure DeleteByCodigo( cCodigo As String ) As Object
        Local lcCommand As String
        Local loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object

        Try

            lcCommand = ""
            loReturn = This.ObtenerToken()
            If loReturn.lOk
                loXmlHttp 	= This.oXmlHttp

                loXmlHttp.nStatus 		= 0
                loXmlHttp.cResponseText = ""
                This.cErrorMessage 		= ""
                loXmlHttp.cURL 			= This.cURL + Transform( Alltrim( cCodigo )) + "/"

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
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && DeleteByCodigo


    *
    *
    Procedure RegistrosSonIguales( oNuevo, oActual ) As Boolean
        Local lcCommand As String,;
            lcProperty As String
        Local llOk As Boolean
        Local luNuevo As Variant,;
            luActual As Variant

        Try

            lcCommand = ""
            llOk = .T.

            Amembers( laProperties, oNuevo )

            For Each lcProperty In laProperties
                Try

                    luNuevo 	= Evaluate( "oNuevo." + lcProperty )
                    luActual 	= Evaluate( "oActual." + lcProperty )

                    If Isnull( luActual )
                        Do Case
                            Case Vartype( luNuevo ) = "D"
                                luActual = {}

                            Otherwise

                        Endcase
                    Endif

                    Do Case
                        Case Vartype( luNuevo ) = "C"
                            luActual 	= Alltrim( luActual )
                            luNuevo 	= Alltrim( luNuevo )

                        Otherwise

                    Endcase

                    llOk = ( luNuevo == luActual )

                Catch To oErr
                    llOk = .F.

                Finally

                Endtry

                If !llOk
                    *!*						Text To lcMsg NoShow TextMerge Pretext 03
                    *!*						<<lcProperty>>
                    *!*							Actual: <<luActual>>
                    *!*							Nuevo: <<luNuevo>>
                    *!*						EndText

                    *!*						Inform( lcMsg )

                    Exit
                Endif

            Endfor

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return llOk

    Endproc && RegistrosSonIguales

    *
    *
    Procedure ObtenerToken(  ) As Void
        Local lcCommand As String,;
            lcUser As String,;
            lcPassword As String,;
            lcToken As String,;
            lcAutorization As String,;
            lcAuthToken As String

        Local ldExpirationDate As Date
        Local llGetNewToken As Boolean,;
            llOk As Boolean
        Local loReg As Object,;
            loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
            loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
            loReturn As Object

        Try

            lcCommand = ""

            If This.cAuthorization = "TOKEN"

                ldExpirationDate = GetValue( "Token_ET", This.cIniFile, {} )
                lcAuthToken = Alltrim( GetValue( This.cToken, This.cIniFile, "" ))
                llGetNewToken = .F.

                If ldExpirationDate < Date()
                    llGetNewToken = .T.
                    lcAuthToken = ""

                Else
                    If Empty( lcAuthToken )
                        llGetNewToken = .T.
                        lcAuthToken = ""
                    Endif
                Endif

                If llGetNewToken
                    loXmlHttp 	= Newobject( "prxXmlHttp", "Tools\JSON\Prg\XmlHttp.prg" )

                    loReg = Createobject( "Empty" )
                    AddProperty( loReg, "username", Alltrim( GetValue( "Usuario", This.cIniFile, "" )))
                    AddProperty( loReg, "password", Alltrim( GetValue( "Password", This.cIniFile, "" )))

                    *---------------------------------------------------------------

                    loJSON 		= This.oJsontoVfp

                    loXmlHttp.lDontBreak = .T.
                    loXmlHttp.lDebug = FileExist( "lDebug.tag" )
                    loXmlHttp.cAuthorization = ""

                    loXmlHttp.nStatus 		= 0
                    loXmlHttp.cResponseText = ""
                    This.cErrorMessage 		= ""
                    loXmlHttp.cURL 			= Alltrim( GetValue( This.cAuth_Url, This.cIniFile, "" ))
                    loXmlHttp.cBody 		= loJSON.VfpToJson( loReg )

                    loXmlHttp.Post()
                    loReturn = loXmlHttp.oVFP

                    If Isnull( loReturn )
                        loReturn = Createobject( "Empty" )
                        AddProperty( loReturn, "lOk", .F. )
                        AddProperty( loReturn, "cErrorMessage", loXmlHttp.cErrorDetail )
                    Endif

                    TEXT To lcMsg NoShow TextMerge Pretext 03
					Status: <<loXmlHttp.nStatus>>
					<<loXmlHttp.cResponseText>>
					<<loXmlHttp.cErrorDetail>>
                    ENDTEXT

                    This.cErrorMessage = lcMsg

                    *---------------------------------------------------------------

                    If loReturn.lOk
                        loReg = loReturn.Data
                        lcAuthToken = Alltrim( loReg.Token )

                        M_Use( 0, Alltrim( DRVA ) + This.cIniFile )
                        M_IniAct( 2 )

                        TEXT To lcCommand NoShow TextMerge Pretext 15
						Replace <<This.cToken>> With '<<lcAuthToken>>',
							Token_ET With Date()
                        ENDTEXT

                        &lcCommand
                        lcCommand = ""

                        Unlock
                        Use In Select( This.cIniFile )

                    Else
                        Stop( lcMsg, "Error al Obtener Autorzación", -1 )

                    Endif

                    loXmlHttp = Null

                Else
                    loReturn = Createobject( "Empty" )
                    AddProperty( loReturn, "lOk", .T. )
                    AddProperty( loReturn, "cErrorMessage", "" )

                Endif

                loXmlHttp = This.oXmlHttp
                loXmlHttp.cAuthToken = lcAuthToken
            Else
                loReturn = Createobject( "Empty" )
                AddProperty( loReturn, "lOk", .T. )
                AddProperty( loReturn, "cErrorMessage", "" )

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loReg = Null
            loXmlHttp = Null

        Endtry

        Return loReturn

    Endproc && ObtenerToken


    *
    * oXmlHttp_Access
    Protected Procedure oXmlHttp_Access()

        If Vartype( This.oXmlHttp ) # "O"
            This.oXmlHttp = Newobject( "prxXmlHttp", "Tools\JSON\Prg\XmlHttp.prg" )

            This.oXmlHttp.lDontBreak 		= .T.
            This.oXmlHttp.lDebug 			= FileExist( "lDebug.tag" )
            This.oXmlHttp.cAuthorization 	= "TOKEN"
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




Enddefine
*!*
*!* END DEFINE
*!* Class.........: ConsumirAPI
*!*
*!* ///////////////////////////////////////////////////////
