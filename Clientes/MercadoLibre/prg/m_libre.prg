#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\JSON\Include\HTTP.h"
#INCLUDE "Clientes\MercadoLibre\Include\M_Libre.h"



*!* ///////////////////////////////////////////////////////
*!* Class.........: oMeLi
*!* Description...:
*!* Date..........: Domingo 10 de Mayo de 2020 (11:00:29)
*!*
*!*

Define Class oMeLi As ConsumirApi Of "Tools\JSON\Prg\XmlHttp.prg"

	#If .F.
		Local This As oMeLi Of "Clientes\MercadoLibre\Prg\M_Libre.prg"
	#Endif

	* Indica si se acaba de refrescar el token
	lRefreshToken 	= .F.
	cAccessToken 	= ""
	cAuthorization 	= ""

	* Datos del Usuario de Mercado Libre
	oMlUser = Null

	* Objeto que se transforma a JSON para grabar en el Body
	oBody = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="getitems" type="method" display="GetItems" />] + ;
		[<memberdata name="caccesstoken" type="property" display="cAccessToken" />] + ;
		[<memberdata name="caccesstoken_access" type="method" display="cAccessToken_Access" />] + ;
		[<memberdata name="lrefreshtoken" type="property" display="lRefreshToken" />] + ;
		[<memberdata name="omluser" type="property" display="oMlUser" />] + ;
		[<memberdata name="process" type="method" display="Process" />] + ;
		[<memberdata name="registrarse" type="method" display="Registrarse" />] + ;
		[<memberdata name="testme" type="method" display="TestMe" />] + ;
		[<memberdata name="getrefreshtoken" type="method" display="GetRefreshToken" />] + ;
		[<memberdata name="consumirapi" type="method" display="ConsumirApi" />] + ;
		[<memberdata name="getvfpobject" type="method" display="GetVfpObject" />] + ;
		[<memberdata name="obody" type="property" display="oBody" />] + ;
		[</VFPData>]



	*
	*
	Procedure Process( oParam As Object ) As Boolean
		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .F.

			Do Case
				Case oParam.cAccion = "REGISTRARSE"
					llOk = This.Registrarse( oParam )

				Case oParam.cAccion = "TEST_ME"
					llOk = This.TestMe( oParam )

				Case oParam.cAccion = "TEST_ITEMS"
					llOk = This.TestMe( oParam )

				Case oParam.cAccion = "TEST_ORDERS"
					llOk = This.TestMe( oParam )

				Otherwise
					TEXT To lcMsg NoShow TextMerge Pretext 03
					Acción No Definida
					'<<oParam.cAccion>>'
					ENDTEXT

					Stop( lcMsg, "Mercado Libre" )

			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && Process


	*
	* Devuelve Items por Condicion
	Procedure GetItems( oParam As Object ) As Json;
			HELPSTRING "Devuelve Items por Condicion"
		Local lcCommand As String,;
			lcReturn As String

		Local llOk As Boolean
		Local loEdtBox As EditBox,;
			loConsumirApi As Ml_Consumir_Api Of "Tools\JSON\Prg\XmlHttp.prg",;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loRespuesta As Object,;
			loObj As Object


		Try

			lcCommand = ""
			lcReturn = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lcReturn

	Endproc && GetItems




	*
	*
	Procedure ConsumirApi( cMethod As String ) As Void
		Local lcCommand As String
		Local loXmlHttp  As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg",;
			loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg",;
			loReturn As Object,;
			loObj As Object

		Try

			lcCommand = ""
			This.cAuthorization = ""
			This.lRefreshToken 	= .F.

			This.oXmlHttp = Null

			loJSON 		= This.oJsontoVfp
			loXmlHttp 	= This.oXmlHttp

			loXmlHttp.nStatus 			= 0
			loXmlHttp.cResponseText 	= ""
			loXmlHttp.cURL 				= This.cURL
			loXmlHttp.cAuthorization  	= ""
			This.cErrorMessage 			= ""

			Do Case
				Case Upper( cMethod ) == "POST"
					loXmlHttp.cAccept 		= "application/json"
					loXmlHttp.cContent_Type = "application/x-www-form-urlencoded"
					If !IsEmpty( This.oBody )
						loXmlHttp.cBody = loJSON.VfpToJson( This.oBody )
					EndIf

					loXmlHttp.Post()

				Case Upper( cMethod ) == "PUT"
					loXmlHttp.cAuthorization 	= "BEARER"
					loXmlHttp.cAuthToken 		= This.cAccessToken
					loXmlHttp.cAccept 			= "application/json"
					loXmlHttp.cContent_Type 	= "application/json"
					If !IsEmpty( This.oBody )
						loXmlHttp.cBody = loJSON.VfpToJson( This.oBody )
					EndIf
					


					loXmlHttp.Put()

				Case Upper( cMethod ) == "GET"
					loXmlHttp.Get()

				Otherwise

			Endcase

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

			If Inlist( loReturn.nStatus, _HTTP_401_UNAUTHORIZED )
				loObj = This.GetVfpObject( loReturn.cResponseText )
				If loObj.lOk
					If Inlist( Upper( loObj.oData.Message ),;
							"INVALID_TOKEN",;
							"INVALID TOKEN",;
							"EXPIRED_TOKEN" )

						This.GetRefreshToken()
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
			loObj 		= Null
			loJSON 		= Null
			loXmlHttp 	= Null

		Endtry

		Return loReturn

	Endproc && ConsumirApi

	*
	* RA 27/09/2021(14:37:46)
	* Ahora los parametros van el el body
	* https://developers.mercadolibre.com.ar/es_ar/autenticacion-y-autorizacion
	*
	Procedure GetRefreshToken(  ) As Void
		Local lcCommand As String,;
			lcAlias As String

		Local loRespuesta As Object,;
			loConsumirApi As Ml_Consumir_Api Of "Tools\JSON\Prg\XmlHttp.prg",;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loData As Object,;
			loE_Commerce As e_Commerce Of "Clientes\Mercado Libre\Prg\M_Libre.prg",;
			loReturn As Object


		Try

			lcCommand = ""
			lcAlias = Alias()
			Wait Window Nowait Noclear "Refrescando Token ... "

			This.cURL = ML_OAUTH_URL

			loBody = Createobject( "Empty" )
			AddProperty( loBody, "grant_type", "refresh_token" )
			AddProperty( loBody, "client_id", This.oMlUser.cApp_Id )
			AddProperty( loBody, "client_secret", This.oMlUser.cSecret_Key )
			AddProperty( loBody, "refresh_token", This.oMlUser.cRefresh_Token )

			This.oBody = loBody

			loRespuesta = This.ConsumirApi( "POST" )

			If loRespuesta.lOk
				This.lRefreshToken = .T.

				M_USE( 0, Alltrim( DRVA ) + "ar0MLib" )

				Scatter Name loReg

				loE_Commerce = Newobject( "e_Commerce", "Clientes\Mercado Libre\Prg\M_Libre.prg" )

				loE_Commerce.cUrlBase 	= Alltrim( loReg.URL_Base )
				loE_Commerce.cUser 		= Alltrim( loReg.Usuario )
				loE_Commerce.cPassword 	= Alltrim( loReg.Password )
				loE_Commerce.cToken 	= Alltrim( loReg.ML_TKN_FNX )

				loData = Createobject( "Empty" )

				AddProperty( loData, "access_token", loRespuesta.Data.access_token )
				AddProperty( loData, "refresh_token", loRespuesta.Data.refresh_token )

				loReturn = loE_Commerce.SaveSettings( loData, loReg.Setting_Id )

				If loReturn.lOk
					This.oMlUser 		= Null
					This.cAccessToken 	= ""
				Endif

			Else
				TEXT To lcMsg NoShow TextMerge Pretext 03
				No se pudo obtener el Token de Acceso

				<<loRespuesta.cErrorMessage>>
				ENDTEXT

				Stop( lcMsg, "Mercado Libre" )

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Wait Clear
			Use In Select( "ar0MLib" )
			If !Empty( lcAlias )
				Select Alias( lcAlias )
			Endif

			This.oBody = Null

		Endtry

	Endproc && GetRefreshToken


	*
	*
	Procedure Registrarse(  ) As Boolean
		Local lcCommand As String,;
		lcFileName As String,; 
		lcCommandLine As String,;
		lcSistemFolder as String 
		Local llOk As Boolean,;
		llWaitForCompletion as Boolean 

		Try

			lcCommand = ""
			llOk = .F. 
			
			If !Empty( This.oMlUser.client_id )
				This.cURL = ML_AUTH_URL + "?response_type=code"
				This.cURL = This.cURL + "&client_id=" + Alltrim( This.oMlUser.client_id )
				This.cURL = This.cURL + "&redirect_uri=" + Alltrim( This.oMlUser.redirect_uri )
				This.cURL = This.cURL + "&state=" + Alltrim( This.oMlUser.client_id )
				
*!*					Text To lcCommandLine NoShow TextMerge Pretext 15
*!*					Start Chrome /Incognito "<<This.cURL>>"
*!*					EndText
				
				Text To lcCommandLine NoShow TextMerge Pretext 15
				Start Chrome "<<This.cURL>>"
				EndText

				Text To lcCommand NoShow TextMerge Pretext 15
				Run <<lcCommandLine>>
				EndText
				
				&lcCommand
				lcCommand = ""

			EndIf


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && Registrarse


	*
	*
	* RA 27/09/2021(14:37:46)
	* Ahora los parametros van el el body
	* https://developers.mercadolibre.com.ar/es_ar/autenticacion-y-autorizacion
	*
	Procedure xxxRegistrarse( oParam As Object ) As Void
		Local lcCommand As String
		Local llOk As Boolean
		Local loEdtBox As EditBox,;
			loConsumirApi As Ml_Consumir_Api Of "Tools\JSON\Prg\XmlHttp.prg",;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loRespuesta As Object,;
			loObj As Object,;
			loReg As Object,;
			loBody As Object


		Try

			lcCommand = ""


			loEdtBox = oParam.oForm.Edit
			loEdtBox.Value = ""

			If Empty( This.oMlUser.cUser_Id )

				This.cURL = ML_AUTH_URL + "?response_type=code"
				This.cURL = This.cURL + "&client_id=" + This.oMlUser.cApp_Id
				This.cURL = This.cURL + "&redirect_uri=" + This.oMlUser.cRedirect_Uri

				TEXT To loEdtBox.Value NoShow TextMerge Pretext 03

				Pegue el siguiente link en su navegador para obtener
				el User_Id y permitir que la aplicación Web grabe el Código de Acceso

				<<This.cUrl>>

				Luego que se generó correctamente el Código de Acceso
				vuelva a ejecutar éste proceso para que se generen
				los Token de Acceso y de Refresco

				ENDTEXT

			Else

				This.cURL = ML_OAUTH_URL

				loBody = Createobject( "Empty" )
				AddProperty( loBody, "grant_type", "authorization_code" )
				AddProperty( loBody, "client_id", This.oMlUser.cApp_Id )
				AddProperty( loBody, "client_secret", This.oMlUser.cSecret_Key )
				AddProperty( loBody, "code", This.oMlUser.cCode )
				AddProperty( loBody, "redirect_uri", This.oMlUser.cRedirect_Uri )

				This.oBody = loBody

				loRespuesta = This.ConsumirApi( "POST" )

				If loRespuesta.lOk

					loObj = loRespuesta.Data
					loReg = Createobject( "Empty" )

					AddProperty( loReg, "ml_Token", loObj.access_token )
					AddProperty( loReg, "ml_Rfr_Tkn", loObj.refresh_token )

					M_USE( 0, Alltrim( DRVA ) + "ar0MLib" )
					M_IniAct( 2 )
					Gather Name loReg Memo
					Unlock

					TEXT To lcMsg NoShow TextMerge Pretext 03
					Access Token: <<loObj.access_token>>
					Token Type: <<loObj.token_type>>
					Expires at: <<Datetime() + Val( Transform( loObj.expires_in ))>>
					Scope: <<loObj.scope>>
					User Id: <<loObj.user_id>>
					Refresh Token: <<loObj.refresh_token>>
					ENDTEXT

					loEdtBox.Value = lcMsg

					Exit

				Else
					loEdtBox.Value = loRespuesta.cErrorMessage + CRLF + CRLF

					loEdtBox.Value = loEdtBox.Value + Replicate( "-", 50 ) + CRLF + CRLF

					This.cURL = ML_OAUTH_URL

					loBody = Createobject( "Empty" )
					AddProperty( loBody, "grant_type", "refresh_token" )
					AddProperty( loBody, "client_id", This.oMlUser.cApp_Id )
					AddProperty( loBody, "client_secret", This.oMlUser.cSecret_Key )
					AddProperty( loBody, "refresh_token", This.oMlUser.cRefresh_Token )

					This.oBody = loBody

					loRespuesta = This.ConsumirApi( "POST" )

					If loRespuesta.lOk

						loObj = loRespuesta.Data

						TEXT To lcMsg NoShow TextMerge Pretext 03
						Access Token: <<loObj.access_token>>
						Token Type: <<loObj.token_type>>
						Expires at: <<Datetime() + Val( Transform( loObj.expires_in ))>>
						Scope: <<loObj.scope>>
						User Id: <<loObj.user_id>>
						Refresh Token: <<loObj.refresh_token>>
						ENDTEXT

						loEdtBox.Value = loEdtBox.Value + lcMsg

						Exit

					Else
						loEdtBox.Value = loRespuesta.cErrorMessage + CRLF + CRLF

						loEdtBox.Value = loEdtBox.Value + Replicate( "-", 50 ) + CRLF + CRLF



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
			This.oBody = Null

		Endtry

		Return llOk

	Endproc && Registrarse


	*
	*
	Procedure TestMe( oParam As Object ) As Void
		Local lcCommand As String,;
			lcUrl As String,;
			lcUser_Id As String,;
			lcIds As String,;
			lcAtributes As String
		Local llOk As Boolean
		Local loEdtBox As EditBox,;
			loConsumirApi As Ml_Consumir_Api Of "Tools\JSON\Prg\XmlHttp.prg",;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loRespuesta As Object,;
			loObj As Object

		Local lnPageOffset As Integer,;
			lnPageLimit As Integer,;
			lnTimes As Integer


		Try

			lcCommand = ""
			loEdtBox = oParam.oForm.Edit
			loEdtBox.Value = ""

			Do Case
				Case oParam.cAccion = "TEST_ITEMS"
					lcUser_Id = This.oMlUser.cUser_Id
					lnPageLimit = 20
					lnPageOffset = 0

					TEXT To lcUrl NoShow TextMerge Pretext 15
					<<ML_API_ROOT_URL>>/users/<<lcUser_Id>>/items/search?status=active&access_token=<<This.cAccessToken>>
					ENDTEXT

					TEXT To lcUrl NoShow TextMerge Pretext 15 ADDITIVE
					&offset=<<lnPageOffset>>&limit=<<lnPageLimit>>
					ENDTEXT

					This.cURL = lcUrl

					loRespuesta = This.ConsumirApi( "GET" )

					If !loRespuesta.lOk
						If This.lRefreshToken
							This.cURL = lcUrl
							loRespuesta = This.ConsumirApi( "GET" )
						Endif
					Endif

					If loRespuesta.lOk
						TEXT To lcCommand NoShow TextMerge Pretext 15
						Create Cursor cItems (
							id C(20),
							title C(100),
							category_id C(20),
							price N(12,2),
							seller_custom_field C(20) )
						ENDTEXT

						&lcCommand
						lcCommand = ""

						Index On Id Tag Id Candidate

						loObj = loRespuesta.Data

						*Inform( "Ok" )
						TEXT To lcMsg NoShow TextMerge Pretext 03
						Total: <<loObj.paging.total>> Items por Página: <<loObj.paging.limit>> Página Nº <<loObj.paging.offset>>
						ENDTEXT

						loEdtBox.Value = lcMsg

						loItems = loObj.results
						lcIds = ""
						For Each cItem_Id In loItems
							Append Blank
							Replace Id With cItem_Id
							lcIds = lcIds + "," + cItem_Id
						Endfor

						*https://api.mercadolibre.com/items?ids=MLA614989235,MLA614547517&attributes=id,title,price&access_token=APP_USR-4662122650988312-112312-b8525be8da490d9517153aececb20112-66926139
						lcIds = Substr( lcIds, 2 )

						* Atributos
						lnLen = Afields( laFields, "cItems" )
						lcAtributes = ""
						For i = 1 To lnLen
							lcAtributes = lcAtributes + "," + laFields[i,1]
						Endfor
						lcAtributes = Lower( Substr( lcAtributes, 2 ))


						TEXT To lcUrl NoShow TextMerge Pretext 15
						<<ML_API_ROOT_URL>>/items?ids=<<lcIds>>&attributes=<<lcAtributes>>&access_token=<<This.cAccessToken>>
						ENDTEXT

						This.cURL = lcUrl

						loRespuesta = This.ConsumirApi( "GET" )

						If loRespuesta.lOk

							loItems = loRespuesta.Data

							For Each loItem In loRespuesta.Data
								If loItem.Code = 200
									If Seek( loItem.Body.Id, "cItems", "Id" )
										Replace Title With Nvl(loItem.Body.Title,""),;
											category_id With Nvl(loItem.Body.category_id,""),;
											price With Nvl(loItem.Body.price,0),;
											seller_custom_field With Nvl(loItem.Body.seller_custom_field,"")
									Endif

								Endif
							Endfor

							Locate

							Browse

						Else
							loEdtBox.Value = loRespuesta.cErrorMessage

						Endif

					Else
						loEdtBox.Value = loRespuesta.cErrorMessage

					Endif

				Case oParam.cAccion = "TEST_ME"

					This.cURL = ML_API_ROOT_URL + "/users/me?access_token=" + This.cAccessToken

					loRespuesta = This.ConsumirApi( "GET" )

					If !loRespuesta.lOk
						If This.lRefreshToken
							This.cURL = ML_API_ROOT_URL + "/users/me?access_token=" + This.cAccessToken
							loRespuesta = This.ConsumirApi( "GET" )
						Endif
					Endif

					If loRespuesta.lOk

						loObj = loRespuesta.Data

						TEXT To lcMsg NoShow TextMerge Pretext 03
						Id: <<loObj.id>>
						Usuario: <<loObj.nickname>>
						Inicio: <<loObj.registration_date>>
						Nombre:	<<loObj.first_name>>
						Apellido: <<loObj.last_name>>
						Id del País: <<loObj.country_id>>
						eMail: <<loObj.email>>
						Documento: <<loObj.identification.type>> <<loObj.identification.number>>
						Direccion:
						Provincia: <<loObj.address.state>>
						Ciudad: <<loObj.address.city>>
						Calle y Número: <<loObj.address.address>>
						Código Postal: <<loObj.address.zip_code>>
						Teléfono:
						Código de Area: <<loObj.phone.area_code>>
						Número: <<loObj.phone.number>>
						Extensión: <<loObj.phone.extension>>
						Verificado: <<loObj.phone.verified>>
						ENDTEXT

						loEdtBox.Value = lcMsg

						Exit

					Else
						loEdtBox.Value = loRespuesta.cErrorMessage

					Endif

			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && TestMe


	*
	*
	Procedure GetVfpObject( cJSON As String  ) As Object
		Local lcCommand As String,;
			lcToken As String

		Local loRespuesta As Object,;
			loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg"

		Try

			lcCommand = ""
			loRespuesta = Createobject( "Empty" )
			AddProperty( loRespuesta, "lOk", .F. )
			lcToken = Substr( cJSON, 1, 1 )

			Do Case
				Case Inlist( lcToken, "{", "[" )
					loJSON 		= Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
					AddProperty( loRespuesta, "oData", loJSON.JsonToVfp( cJSON ))
					loRespuesta.lOk = .T.

				Otherwise

			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loJSON = Null

		Endtry

		Return loRespuesta

	Endproc && GetVfpObject


	*
	* oXmlHttp_Access
	Protected Procedure oXmlHttp_Access()

		If Vartype( This.oXmlHttp ) # "O"
			This.oXmlHttp = Newobject( "prxXmlHttp", "Tools\JSON\Prg\XmlHttp.prg" )

			This.oXmlHttp.lDontBreak 		= .T.
			This.oXmlHttp.lDebug 			= FileExist( "lDebug.tag" )
			This.oXmlHttp.cAuthorization 	= ""
		Endif

		This.oXmlHttp.lSilence	= This.lSilence

		Return This.oXmlHttp

	Endproc && oXmlHttp_Access

	*
	* cAccessToken_Access
	Protected Procedure oMlUser_Access()

		Local lcCommand As String,;
			lcAlias As String

		Local loE_Commerce As e_Commerce Of "Clientes\Mercado Libre\Prg\M_Libre.prg",;
			loReturn As Object,;
			loSetting As Object,;
			loReg As Object



		Try

			lcCommand = ""


			If Isnull( This.oMlUser )
				lcAlias = Alias()

				M_USE( 0, Alltrim( DRVA ) + "ar0MLib" )

				Scatter Name loReg

				loE_Commerce = Newobject( "e_Commerce", "Clientes\Mercado Libre\Prg\M_Libre.prg" )

				loE_Commerce.cUrlBase 	= Alltrim( loReg.URL_Base )
				loE_Commerce.cUser 		= Alltrim( loReg.Usuario )
				loE_Commerce.cPassword 	= Alltrim( loReg.Password )
				loE_Commerce.cToken 	= Alltrim( loReg.ML_TKN_FNX )

				loReturn = loE_Commerce.GetSetting( loReg.Setting_Id )

				If loReturn.lOk
					This.oMlUser = Createobject( "Empty" )

					loSetting = loReturn.Data

					AddProperty( This.oMlUser, "cApp_Id", loSetting.client_id )
					AddProperty( This.oMlUser, "cSecret_Key", loSetting.client_secret )
					AddProperty( This.oMlUser, "cRedirect_Uri", loSetting.redirect_uri )
					AddProperty( This.oMlUser, "cCode", loSetting.server_authorization_code )
					AddProperty( This.oMlUser, "cUser_Id", loSetting.user_id )
					AddProperty( This.oMlUser, "cAccessToken", loSetting.access_token )
					AddProperty( This.oMlUser, "cRefresh_Token", loSetting.refresh_token )

				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Use In Select( "ar0MLib" )
			If !Empty( lcAlias )
				Select Alias( lcAlias )
			Endif


		Endtry


		Return This.oMlUser

	Endproc && oMlUser_Access



	*
	* cAccessToken_Access
	Protected Procedure cAccessToken_Access()

		Local lcCommand As String

		Try

			lcCommand = ""

			If Empty( This.cAccessToken )
				This.cAccessToken = This.oMlUser.cAccessToken
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry


		Return This.cAccessToken

	Endproc && cAccessToken_Access



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oMeLi
*!*
*!* ///////////////////////////////////////////////////////
