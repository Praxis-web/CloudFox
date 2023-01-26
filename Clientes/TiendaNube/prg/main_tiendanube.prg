#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\JSON\Include\HTTP.h"
#INCLUDE "Clientes\TiendaNube\Include\TiendaNube.h"

Lparameters tcAppName As String, ;
	tcVersion As String,;
	tcUser As String

Local loMain As oTiendaNube Of Clientes\TiendaNube\Prg\TiendaNube.Prg

Try
	Close Databases All

	If Empty( tcAppName )
		tcAppName = "Tienda_Nube"
	Endif

	If Empty( tcVersion )
		tcVersion = "1.0"
	Endif

	If Empty( tcUser )
		tcUser = ""
	Endif

	loMain = Createobject( "oTiendaNube",;
		tcAppName,;
		tcVersion,;
		tcUser )

	loMain.Start()

Catch To loErr

	Try
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError


	Catch To oErr
		ShowError( oErr )

	Finally

	Endtry


Finally
	_Screen.Picture = ""

	Try

		If Vartype(loMain)=="O"
			loMain.Destroy()
		Endif

	Catch To oErr

	Finally
		loMain = Null

	Endtry

Endtry

*/ ---------------------------------------------------------------------------

Define Class oTiendaNube As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

	#If .F.
		Local This As oTiendaNube Of Clientes\TiendaNube\Prg\Main_TiendaNube.Prg
	#Endif

	cParameFileName = "Clientes\TiendaNube\ArParame"
	cRootWorkFolder = "Clientes\TiendaNube\"
	cDBFMenu 		= "Clientes\TiendaNube\TiendaNube"
	cScreenIcon 	= "v:\CloudFox\fw\Comunes\Image\Modulos\TiendaNube.ico"
	cAppLogoSource 	= "v:\CloudFox\Fw\Comunes\Image\Modulos\TiendaNube.jpeg"

	nModuloId 		= MDL_TIENDA


	Procedure BuildMainMenu( tcMenu As String ) As VOID

		With This As prxApplication Of "fw\sysAdmin\prg\saMain.prg"

			Try

				If IsRuntime()
					This.cDBFMenu = "Datos\TiendaNube"
				EndIf
				
				MenuLoader( This.cDBFMenu, This.oUser.Clave )

			Catch To oErr
				Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

				loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Process( oErr )
				Throw loError

			Finally

			Endtry

		Endwith

	Endproc &&    BuildMainMenu


Enddefine


*
*
Procedure Dummy(  ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""
		External File "v:\CloudFox\FW\Comunes\image\Modulos\TiendaNube.jpeg",;
			"v:\CloudFox\FW\Comunes\image\Modulos\TiendaNube.ico"


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && Dummy



*!* ///////////////////////////////////////////////////////
*!* Class.........: oTienda
*!* Description...:
*!* Date..........: Domingo 10 de Mayo de 2020 (11:00:29)
*!*
*!* https://github.com/TiendaNube/api-docs

*!*	Praxis Tienda Nube

*!*	Client ID: 4024
*!*	Client Secret: GmBJ3UDNe2yand1DtDCwWeVWNI8FBNRlWLdJOoGssB3isu7c
*!*	https://www.tiendanube.com/apps/4024/authorize


Define Class oTienda As ConsumirApi Of "Tools\JSON\Prg\XmlHttp.prg"

	#If .F.
		Local This As oTienda Of "Clientes\TiendaNube\Prg\Main_TiendaNube.prg"
	#Endif

	* Indica si se acaba de refrescar el token
	lRefreshToken 	= .F.
	cAccessToken 	= ""
	cAuthorization 	= ""

	* Datos del Usuario de Tienda Nube
	oTiendaUser = Null

	* Objeto que se transforma a JSON para grabar en el Body
	oBody = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="getitems" type="method" display="GetItems" />] + ;
		[<memberdata name="caccesstoken" type="property" display="cAccessToken" />] + ;
		[<memberdata name="caccesstoken_access" type="method" display="cAccessToken_Access" />] + ;
		[<memberdata name="lrefreshtoken" type="property" display="lRefreshToken" />] + ;
		[<memberdata name="otiendauser" type="property" display="oTiendaUser" />] + ;
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

					Stop( lcMsg, "Tienda Nube" )

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
					loXmlHttp.cContent_Type = "application/json"
					If !IsEmpty( This.oBody )
						loXmlHttp.cBody = loJSON.VfpToJson( This.oBody )
					Endif

					loXmlHttp.Post()

				Case Upper( cMethod ) == "PUT"
					loXmlHttp.cAuthorization 	= "BEARER"
					loXmlHttp.cAuthToken 		= This.cAccessToken
					loXmlHttp.cContent_Type 	= "application/json"
					If !IsEmpty( This.oBody )
						loXmlHttp.cBody = loJSON.VfpToJson( This.oBody )
					Endif

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
	*
	Procedure GetRefreshToken(  ) As Void
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

	Endproc && GetRefreshToken



	*
	* https://github.com/tiendanube/api-docs/blob/master/resources/authentication.md
	*
	Procedure Registrarse(  ) As Boolean
		Local lcCommand As String,;
			lcState As String
		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .F.

			If !Empty( This.oTiendaUser.app_id )
				*https://www.tiendanube.com/apps/(app_id)/authorize
*!*					This.cURL = TN_AUTH_URL + Alltrim( This.oTiendaUser.client_id ) + "/authorize"
				This.cURL = TN_AUTH_URL + Transform( This.oTiendaUser.app_id ) + "/authorize"

				lcState = Strtran( Alltrim( This.oTiendaUser.Alias ), " ", "_" )
				This.cURL = This.cURL + "?state=" + lcState
				
*!*					loRespuesta = This.ConsumirApi( "GET" )

*!*					If loRespuesta.lOk
*!*						Inform( "Registrado en Tienda Nube", "Registrarse" )
*!*					
*!*					Else 
*!*						Stop( loRespuesta.cErrorMessage, "Registrarse" )
*!*						
*!*					Endif

				Text To lcCommandLine NoShow TextMerge Pretext 15
				Start Chrome /Incognito "<<This.cURL>>"
				EndText
				
				Text To lcCommand NoShow TextMerge Pretext 15
				Run <<lcCommandLine>>
				EndText
				
				&lcCommand
				lcCommand = ""


			Endif


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
					lcUser_Id = This.oTiendaUser.cUser_Id
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

						*https://api.TiendaNube.com/items?ids=MLA614989235,MLA614547517&attributes=id,title,price&access_token=APP_USR-4662122650988312-112312-b8525be8da490d9517153aececb20112-66926139
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

*!*		*
*!*		* cAccessToken_Access
*!*		Protected Procedure oTiendaUser_Access()

*!*			Local lcCommand As String,;
*!*				lcAlias As String

*!*			Local loE_Commerce As e_Commerce Of "Clientes\TiendaNube\Prg\Main_TiendaNube.prg",;
*!*				loReturn As Object,;
*!*				loSetting As Object,;
*!*				loReg As Object



*!*			Try

*!*				lcCommand = ""


*!*				If Isnull( This.oTiendaUser )
*!*					lcAlias = Alias()

*!*					M_USE( 0, Alltrim( DRVA ) + "ar0Tienda" )

*!*					Scatter Name loReg

*!*					loE_Commerce = Newobject( "e_Commerce", "Clientes\TiendaNube\Prg\Main_TiendaNube.prg" )

*!*					loE_Commerce.cUrlBase 	= Alltrim( loReg.URL_Base )
*!*					loE_Commerce.cUser 		= Alltrim( loReg.Usuario )
*!*					loE_Commerce.cPassword 	= Alltrim( loReg.Password )
*!*					loE_Commerce.cToken 	= Alltrim( loReg.ML_TKN_FNX )

*!*					loReturn = loE_Commerce.GetSetting( loReg.Setting_Id )

*!*					If loReturn.lOk
*!*						This.oTiendaUser = Createobject( "Empty" )

*!*						loSetting = loReturn.Data

*!*						AddProperty( This.oTiendaUser, "cApp_Id", loSetting.client_id )
*!*						AddProperty( This.oTiendaUser, "cSecret_Key", loSetting.client_secret )
*!*						AddProperty( This.oTiendaUser, "cRedirect_Uri", loSetting.redirect_uri )
*!*						AddProperty( This.oTiendaUser, "cCode", loSetting.server_authorization_code )
*!*						AddProperty( This.oTiendaUser, "cUser_Id", loSetting.user_id )
*!*						AddProperty( This.oTiendaUser, "cAccessToken", loSetting.access_token )
*!*						AddProperty( This.oTiendaUser, "cRefresh_Token", loSetting.refresh_token )

*!*					Endif

*!*				Endif

*!*			Catch To loErr
*!*				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
*!*				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
*!*				loError.cRemark = lcCommand
*!*				loError.Process ( m.loErr )
*!*				Throw loError

*!*			Finally
*!*				Use In Select( "ar0Tienda" )
*!*				If !Empty( lcAlias )
*!*					Select Alias( lcAlias )
*!*				Endif


*!*			Endtry


*!*			Return This.oTiendaUser

*!*		Endproc && oTiendaUser_Access



	*
	* cAccessToken_Access
	Protected Procedure cAccessToken_Access()

		Local lcCommand As String

		Try

			lcCommand = ""

			If Empty( This.cAccessToken )
				This.cAccessToken = This.oTiendaUser.cAccessToken
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
*!* Class.........: oTienda
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: e_Commerce
*!* Description...:
*!* Date..........: Martes 30 de Noviembre de 2021 (14:38:02)
*!*
*!*

Define Class e_Commerce As ConsumirApi Of "Tools\JSON\Prg\XmlHttp.prg"

	#If .F.
		Local This As e_Commerce Of "Clientes\TiendaNube\Prg\Main_TiendaNube.prg"
	#Endif

	cAuthorization 	= ""
	cUrlBase 		= ""
	cUser			= ""
	cPassword		= ""
	cToken 			= ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="getempresas" type="method" display="GetEmpresas" />] + ;
		[<memberdata name="curlbase" type="property" display="cUrlBase" />] + ;
		[<memberdata name="cuser" type="property" display="cUser" />] + ;
		[<memberdata name="cpassword" type="property" display="cPassword" />] + ;
		[<memberdata name="getsettings" type="method" display="GetSettings" />] + ;
		[<memberdata name="getsetting" type="method" display="GetSetting" />] + ;
		[<memberdata name="savesettings" type="method" display="SaveSettings" />] + ;
		[</VFPData>]


	*
	*
	Procedure GetEmpresas(  ) As Object
		Local lcCommand As String

		Try

			lcCommand = ""
			This.cUrl = This.cUrlBase + "comunes/apis/Praxis/"
			loRespuesta = This.GetAll()

			If !loRespuesta.lOk
				Stop( loRespuesta.cErrorMessage, "Cargar Empresas" )
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

	Endproc && GetEmpresas



	*
	* Trae las Empresas activas del Cliente Praxis
	Procedure GetSettings( nClientePraxis As Integer ) As Object ;
			HELPSTRING "Trae los parametros de la Empresa activa"
		Local lcCommand As String,;
			lcFilter As String

		Try

			lcCommand = ""
			This.cUrl = This.cUrlBase + "tienda_nube/apis/TiendaNube/"

			TEXT To lcFilter NoShow TextMerge Pretext 15
			cliente_praxis=<<nClientePraxis>>
			ENDTEXT

			loRespuesta = This.GetByWhere( lcFilter )

			If !loRespuesta.lOk
				Stop( loRespuesta.cErrorMessage, "Traer Empresas Activas" )
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

	Endproc && GetSettings

	*
	* Trae los parametros de la Empresa activa
	Procedure GetSetting( nSettingId As Integer ) As Object ;
			HELPSTRING "Trae los parametros de la Empresa activa"
		Local lcCommand As String,;
			loRespuesta As Object

		Try

			lcCommand = ""
			This.cUrl = This.cUrlBase + "tienda_nube/apis/TiendaNube/"

			loRespuesta = This.GetById( nSettingId )

			If !loRespuesta.lOk
				Stop( loRespuesta.cErrorMessage, "Obtener Parámetros" )
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

	Endproc && GetSetting




	*
	*
	Procedure SaveSettings( oData As Object, nSettingId As Integer ) As Object
		Local lcCommand As String
		Local loRespuesta As Object

		Try

			lcCommand = ""

			This.cUrl = This.cUrlBase + "tienda_nube/apis/TiendaNube/"

			loRespuesta = This.PatchById( oData, nSettingId )

			If !loRespuesta.lOk
				Stop( loRespuesta.cErrorMessage, "Guardar Parámetros" )
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

	Endproc && SaveSettings



Enddefine
*!*
*!* END DEFINE
*!* Class.........: eCommerce
*!*
*!* ///////////////////////////////////////////////////////
