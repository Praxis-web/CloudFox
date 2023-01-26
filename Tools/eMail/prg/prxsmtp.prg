#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\eMail\Include\eMail.h"

Local loMail As oEMail Of "Tools\Email\Prg\prxSmtp.prg"

Local lcCommand As String

Try

	lcCommand = ""

	loMail = Newobject( "oEMail", "Tools\Email\Prg\prxSmtp.prg" )

	With loMail As oEMail Of "Tools\Email\Prg\prxSmtp.prg"
		*!*		.cServer = "smtp.gmail.com"
		*!*		.nServerPort = 465
		*!*		.lUseSSL = .T.

		*!*		.nAuthenticate = cdoBasic
		*!*		.cUserName = "ricardo.aidelman@gmail.com"
		*!*		.cPassword = "rjma48244217" && "ra071056"

		*!*		* If From address doesn't match any of the registered identities,
		*!*		*	Gmail will replace it with your default Gmail address
		*!*
		*!*		.cFrom = "ricardo.aidelman@gmail.com"

		*!*		.cTo = "raidelman@gmail.com" && , somebodyelse@otherdomain.com"

		*!*		.cSubject = "CDO 2000 email through Gmail SMTP server"

		*!*		* Uncomment next lines to send HTML body
		*!*		*.cHtmlBody = "<html><body><b>This is an HTML body<br>" + ;
		*!*		*		"It'll be displayed by most email clients</b></body></html>"

		*!*		.cTextBody = "This is a text body." + Chr(13) + Chr(10) + ;
		*!*			"It'll be displayed if HTML body is not present or by text only email clients"

		*!*		* Attachments are optional
		*!*		* .cAttachment = "myreport.pdf, myspreadsheet.xls"


		*-----------------------------------------------------------------


		*!*			.cServer = "mail.distraltec.com.ar"
		*!*			.nServerPort = 25
		*!*			.lUseSSL = .F.

		*!*			.nAuthenticate = cdoBasic
		*!*			.cUserName = "facturacion@distraltec.com.ar"
		*!*			.cPassword = "dg64ff66"

		*!*			.cFrom = "facturacion@distraltec.com.ar"

		*!*			.cTo = "raidelman@gmail.com" && , somebodyelse@otherdomain.com"

		*!*			.cSubject = "CDO 2000 email through Gmail SMTP server"

		*!*			.cTextBody = "This is a text body." + Chr(13) + Chr(10) + ;
		*!*				"It'll be displayed if HTML body is not present or by text only email clients"

		* .cAttachment = "myreport.pdf, myspreadsheet.xls"

		*-------------------------------------------------------------

		Close Databases All

		Use s:\Fenix\Dbf\Dbf\MailAccounts.Dbf Shared In 0


		lcServer 		= Alltrim( MailAccounts.Server )
		lnServerPort 	= MailAccounts.ServerPort
		llUseSSL 		= ( MailAccounts.UseSSL = 1 )

		lnAuthenticate 	= MailAccounts.Authentica
		lcUserName 		= Alltrim( MailAccounts.UserName )
		lcPassword 		= Alltrim( MailAccounts.Password )
		lcCodigo		= Alltrim( MailAccounts.Codigo )

		lcFrom 			= Alltrim( MailAccounts.UserName )
		lcTo 			= "ricardo.aidelman@gmail.com" && , somebodyelse@otherdomain.com"
		lcSubject 		= "Prueba de Mail"

		TEXT To lcTextBody NoShow TextMerge Pretext 03
		Esta es una prueba de Mail.

		No responda al mismo
		ENDTEXT



		.cServer 		= lcServer
		.nServerPort 	= lnServerPort
		.lUseSSL 		= llUseSSL

		.nAuthenticate 	= lnAuthenticate
		.cUserName 		= lcUserName
		.cPassword 		= DesencriptarClave( lcPassword, lcUserName, lcCodigo )

		.cFrom 			= lcFrom
		.cTo 			= lcTo
		.cSubject 		= lcSubject
		.cTextBody 		= lcTextBody


	Endwith

	loMail.Send()

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )

Finally
	Close Databases All


Endtry
Return

*
*
Procedure DesencriptarClave( cClave As String,;
		cUserName As String,;
		cMascara As String ) As String

	Local lcCommand As String,;
		lcReturn As String

	Local loPaso1 As Object,;
		loPaso2 As Object

	Try

		lcCommand = ""

		loPaso1 = Ofuscar( cMascara, cUserName, .T. )
		loPaso2 = Ofuscar( cClave, loPaso1.Texto, .F. )

		lcReturn = loPaso2.Texto

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcReturn

Endproc && DesencriptarClave





*!* ///////////////////////////////////////////////////////
*!* Class.........: oEMail
*!* ParentClass...: Custom
*!* BaseClass.....: Custom
*!* Description...: Clase para enviar Mails
*!* Date..........: Miércoles 25 de Julio de 2012 (20:32:30)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class oEMail As Custom

	#If .F.
		Local This As oEMail Of "Tools\Email\Prg\prxSmtp.prg"
	#Endif

	Protected aErrors[1], nErrorCount, oMsg, oCfg, cXMailer

	nErrorCount = 0

	* Message attributes
	oMsg 		= Null

	cFrom 		= ""
	cReplyTo 	= ""
	cTo 		= ""
	cCC 		= ""
	cBCC 		= ""
	cAttachment = ""

	cSubject 	= ""
	cHtmlBody 	= ""
	cTextBody 	= ""
	cHtmlBodyUrl = ""

	cCharset 	= ""

	* Priority: Normal, High, Low or empty value (Default)
	cPriority 	= ""

	* Configuration object fields values
	oCfg 		= Null
	cServer 	= ""
	nServerPort = 25
	* Use SSL connection
	lUseSSL 	= .F.
	nConnectionTimeout = 30			&& Default 30 sec's
	nAuthenticate = cdoAnonymous
	cUserName 	= ""
	cPassword 	= ""
	* Do not use cache for cHtmlBodyUrl
	lURLGetLatestVersion = .T.

	* Pide confirmación de lectura
	lReadReceipt = .F.

	* Optional. Creates your own X-MAILER field in the header
	cXMailer 	= "VFP CDO 2000 mailer Ver 1.1.100 2010"

	* No muestra MessageBox()
	lSilence = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="nerrorcount" type="property" display="nErrorCount" />] + ;
		[<memberdata name="omsg" type="property" display="oMsg" />] + ;
		[<memberdata name="cfrom" type="property" display="cFrom" />] + ;
		[<memberdata name="creplyto" type="property" display="cReplyTo" />] + ;
		[<memberdata name="cto" type="property" display="cTo" />] + ;
		[<memberdata name="ccc" type="property" display="cCC" />] + ;
		[<memberdata name="cbcc" type="property" display="cBCC" />] + ;
		[<memberdata name="cattachment" type="property" display="cAttachment" />] + ;
		[<memberdata name="csubject" type="property" display="cSubject" />] + ;
		[<memberdata name="chtmlbody" type="property" display="cHtmlBody" />] + ;
		[<memberdata name="ctextbody" type="property" display="cTextBody" />] + ;
		[<memberdata name="chtmlbodyurl" type="property" display="cHtmlBodyUrl" />] + ;
		[<memberdata name="ccharset" type="property" display="cCharset" />] + ;
		[<memberdata name="cpriority" type="property" display="cPriority" />] + ;
		[<memberdata name="ocfg" type="property" display="oCfg" />] + ;
		[<memberdata name="cserver" type="property" display="cServer" />] + ;
		[<memberdata name="nserverport" type="property" display="nServerPort" />] + ;
		[<memberdata name="lusessl" type="property" display="lUseSSL" />] + ;
		[<memberdata name="nconnectiontimeout" type="property" display="nConnectionTimeout" />] + ;
		[<memberdata name="nauthenticate" type="property" display="nAuthenticate" />] + ;
		[<memberdata name="cusername" type="property" display="cUserName" />] + ;
		[<memberdata name="cpassword" type="property" display="cPassword" />] + ;
		[<memberdata name="lurlgetlatestversion" type="property" display="lURLGetLatestVersion" />] + ;
		[<memberdata name="cxmailer" type="property" display="cXMailer" />] + ;
		[<memberdata name="lreadreceipt" type="property" display="lReadReceipt" />] + ;
		[<memberdata name="lsilence" type="property" display="lSilence" />] + ;
		[<memberdata name="send" type="method" display="Send" />] + ;
		[<memberdata name="clearerrors" type="method" display="ClearErrors" />] + ;
		[<memberdata name="geterrorcount" type="method" display="GetErrorCount" />] + ;
		[<memberdata name="geterror" type="method" display="Geterror" />] + ;
		[<memberdata name="setconfiguration" type="method" display="SetConfiguration" />] + ;
		[<memberdata name="adderror" type="method" display="AddError" />] + ;
		[<memberdata name="addoneerror" type="method" display="AddOneError" />] + ;
		[<memberdata name="error" type="method" display="Error" />] + ;
		[<memberdata name="setheader" type="method" display="SetHeader" />] + ;
		[<memberdata name="cpriority_assign" type="method" display="cPriority_Assign" />] + ;
		[<memberdata name="showerrors" type="method" display="ShowErrors" />] + ;
		[<memberdata name="logsend" type="method" display="LogSend" />] + ;
		[<memberdata name="getsettingsparameters" type="method" display="GetSettingsParameters" />] + ;
		[</VFPData>]


	Protected Procedure Init
		This.ClearErrors()
	Endproc


	* Send message
	Procedure Send

		Local lcCommand As String,;
			lcMsg As String
		Local lnind, laList[1], loHeader, laDummy[1], lcMailHeader

		Try

			lcCommand = ""

			If Empty( This.GetErrorCount() )
				With This
					.ClearErrors()
					.oCfg = Createobject("CDO.Configuration")
					.oMsg = Createobject("CDO.Message")
					.oMsg.Configuration = This.oCfg
				Endwith
			Endif

			This.SetConfiguration()

			If Empty( This.GetErrorCount() )
				* Fill message attributes
				If Empty(This.cFrom)
					This.AddError("ERROR : From is empty.")
				Endif
				If Empty(This.cSubject)
					This.AddError("ERROR : Subject is empty.")
				Endif

				If Empty(This.cTo) And Empty(This.cCC) And Empty(This.cBCC)
					This.AddError("ERROR : To, CC and BCC are all empty.")
				Endif
			Endif

			If Empty( This.GetErrorCount() )

				This.SetHeader()

				With This.oMsg

					.From     = This.cFrom
					.ReplyTo  = This.cReplyTo

					.To       = This.cTo
					.CC       = This.cCC
					.BCC      = This.cBCC
					.Subject  = This.cSubject

					* Create HTML body from external HTML (file, URL)
					If Not Empty(This.cHtmlBodyUrl)
						.CreateMHTMLBody(This.cHtmlBodyUrl)
					Endif

					* Send HTML body. Creates TextBody as well
					If Not Empty(This.cHtmlBody)
						.HtmlBody = This.cHtmlBody
					Endif

					* Send Text body. Could be different from HtmlBody, if any
					If Not Empty(This.cTextBody)
						.TextBody = This.cTextBody
					Endif

					If Not Empty(This.cCharset)
						If Not Empty(.HtmlBody)
							.HtmlBodyPart.Charset = This.cCharset
						Endif

						If Not Empty(.TextBody)
							.TextBodyPart.Charset = This.cCharset
						Endif
					Endif

					* Process attachments
					If Not Empty(This.cAttachment)
						* Accepts comma or semicolon
						* VFP 7.0 and later
						*FOR lnind=1 TO ALINES(laList, This.cAttachment, [,], [;])
						* VFP 6.0 and later compatible
						For lnind=1 To Alines(laList, Chrtran(This.cAttachment, [,;], Chr(13) + Chr(13)))
							lcAttachment = Alltrim(laList[lnind])
							* Ignore empty values
							If Empty(laList[lnind])
								Loop
							Endif

							* Make sure that attachment exists
							If Adir(laDummy, lcAttachment) = 0
								This.AddError("ERROR: Attacment not Found - " + lcAttachment)
							Else
								* The full path is required.
								If 	Upper(lcAttachment) <> Upper(Fullpath(lcAttachment))
									lcAttachment = Fullpath(lcAttachment)
								Endif
								.AddAttachment(lcAttachment)
							Endif
						Endfor
					Endif

					If Not Empty(This.cCharset)
						.BodyPart.Charset = This.cCharset
					Endif

					* Priority
					If Not Empty(This.cPriority)
						lcMailHeader = "urn:schemas:mailheader:"
						.Fields(lcMailHeader + "Priority")   = Lower(This.cPriority)
						.Fields(lcMailHeader + "Importance") = Lower(This.cPriority)
						Do Case
							Case This.cPriority = "High"
								.Fields(lcMailHeader + "X-Priority") = 1 && 5=Low, 3=Normal, 1=High

							Case This.cPriority = "Normal"
								.Fields(lcMailHeader + "X-Priority") = 3 && 5=Low, 3=Normal, 1=High

							Case This.cPriority = "Low"
								.Fields(lcMailHeader + "X-Priority") = 5 && 5=Low, 3=Normal, 1=High

						Endcase

						.Fields.Update()

					Endif

					* http://support.microsoft.com/kb/302839
					If This.lReadReceipt
						.Fields("urn:schemas:mailheader:disposition-notification-to") = This.cTo
						.Fields("urn:schemas:mailheader:return-receipt-to") = This.cTo
						.Fields.Update()
					Endif

				Endwith
			Endif

			If Empty( This.GetErrorCount() )

				TEXT To lcMsg NoShow TextMerge Pretext 03
				Enviando correo ...
				Asunto: <<This.cSubject>>
				Destinatario: <<This.cTo>>
				ENDTEXT

				lcCommand = lcMsg + CRLF

				*!*					If This.lSilence
				*!*						This.oMsg.Send()

				*!*					Else
				*!*						Wait Windows Nowait Noclear lcMsg
				*!*						This.oMsg.Send()

				*!*						Wait Window Nowait "El Correo se Envió Correctamente ..."

				*!*						Inkey( 1 )

				*!*						Wait Clear

				*!*					EndIf

				If !This.lSilence
					Wait Windows Nowait Noclear lcMsg
				Endif

				This.oMsg.Send()

				If Empty( This.GetErrorCount() )
					If !This.lSilence
						Wait Window Nowait "El Correo se Envió Correctamente ..."

						Inkey( 1 )

						Wait Clear

					Endif

					This.LogSend()

				Else
					This.ShowErrors()

				Endif


			Else
				This.ShowErrors()

			Endif

		Catch To loErr

			If Empty( This.GetErrorCount() )
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = lcCommand
				loError.Process ( m.loErr )
				Throw loError

			Else
				This.ShowErrors()

			Endif

		Finally
			Wait Clear


		Endtry

		Return This.GetErrorCount()

	Endproc



	*
	*
	Procedure ShowErrors(  ) As Void
		Local lcCommand As String,;
			lcSMTP_Error As String,;
			lcErrorMsg As String,;
			lcLogFile As String

		Local i As Integer

		Try

			lcCommand = ""
			lcSMTP_Error = ""

			For i=1 To This.GetErrorCount()
				lcSMTP_Error = lcSMTP_Error + This.Geterror( i ) + CRLF
			Endfor

			If !Empty( lcSMTP_Error )

				TEXT To lcMsg NoShow TextMerge Pretext 03
				Asunto: <<This.cSubject>>
				Destinatario: <<This.cTo>>
				ENDTEXT

				lcSMTP_Error = "El Correo No Pudo Enviarse ..." + CRLF + lcMsg + CRLF + CRLF + lcSMTP_Error

				If !This.lSilence
					Stop( lcSMTP_Error, This.oMsg.Subject )
				Endif

				TEXT To lcSetup NoShow TextMerge Pretext 03
				[ cdoSendUsingMethod ] <<cdoSendUsingPort>>
				[ cdoSMTPServer ] <<This.cServer>>
				[ cdoSMTPServerPort ] <<This.nServerPort>>
				[ cdoSMTPConnectionTimeout ] <<This.nConnectionTimeout>>
				[ cdoSMTPAuthenticate ] <<This.nAuthenticate>>
				[ cdoSendUserName ] <<This.cUserName>>
				[ cdoSendPassword ] <<Replicate( "*", Len( This.cPassword ) )>>
				[ cdoURLGetLatestVersion ] <<This.lURLGetLatestVersion>>
				[ cdoSMTPUseSSL ] <<This.lUseSSL>>
				ENDTEXT

				*[ cdoSendPassword ] <<This.cPassword>>

				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = ""
				loError.Process ( Null, .F., .F. )

				lcErrorMsg  = Replicate( '-', 40 ) + CRLF
				lcErrorMsg = lcErrorMsg + Transform( Datetime() ) + CRLF

				lcErrorMsg = lcErrorMsg + lcSMTP_Error + CRLF + CRLF

				lcErrorMsg = lcErrorMsg + "Configuración de la Cuenta" + CRLF
				lcErrorMsg = lcErrorMsg + lcSetup + CRLF + CRLF

				lcErrorMsg = lcErrorMsg + "Tablas y cursores en uso" + CRLF
				lcErrorMsg = lcErrorMsg + "DatasessionId: " + Transform( Set("Datasession" )) + CRLF + CRLF
				lcErrorMsg = lcErrorMsg + loError.cTables + CRLF + CRLF

				lcErrorMsg = lcErrorMsg + "Pila de llamadas" + CRLF
				lcErrorMsg = lcErrorMsg + loError.cStack + CRLF + CRLF

				lcErrorMsg = lcErrorMsg + "Información del sistema" + CRLF
				lcErrorMsg = lcErrorMsg + loError.cSysInfo  + CRLF

				lcErrorMsg = lcErrorMsg + Replicate( "-.", 40 ) + CRLF + CRLF

				lcLogFile = 'ErrorSMTP_' + Dtoc( Datetime(), 1 ) + '.txt'

				Strtofile( lcErrorMsg, lcLogFile, 1 )

				* Intentar grabar el ErrorLog.txt en el servidor, para poder acceder más facilmenmte
				If Vartype( DRVA ) = "C"
					Strtofile( lcErrorMsg, Addbs(Alltrim(DRVA))+lcLogFile, 1 )
				Endif

			Endif

			* Clear errors
			*This.ClearErrors()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && ShowErrors


	* Clear errors collection
	Procedure ClearErrors()
		This.nErrorCount = 0
		Dimension This.aErrors[1]
		This.aErrors[1] = Null
		Return This.nErrorCount
	Endproc

	* Return # of errors in the error collection
	Procedure GetErrorCount
		Return This.nErrorCount
	Endproc

	* Return error by index
	Procedure Geterror
		Lparameters tnErrorno
		If	tnErrorno <= This.GetErrorCount()
			Return This.aErrors[tnErrorno]
		Else
			Return Null
		Endif
	Endproc

	* Populate configuration object
	Protected Procedure SetConfiguration

		Local lcCommand As String

		Try

			lcCommand = ""


			* Validate supplied configuration values
			If Empty(This.cServer)
				This.AddError("ERROR: SMTP Server isn't specified.")
			Endif

			If !Inlist(This.nAuthenticate, cdoAnonymous, cdoBasic)
				This.AddError("ERROR: Invalid Authentication protocol ")
			Endif

			If This.nAuthenticate = cdoBasic ;
					AND (Empty(This.cUserName) Or Empty(This.cPassword))
				This.AddError("ERROR: User name/Password is required for basic authentication")
			Endif

			If 	Empty( This.GetErrorCount() )
				With This.oCfg.Fields

					* Send using SMTP server
					.Item(cdoSendUsingMethod) 		= cdoSendUsingPort
					.Item(cdoSMTPServer) 			= This.cServer
					.Item(cdoSMTPServerPort) 		= This.nServerPort
					.Item(cdoSMTPConnectionTimeout) = This.nConnectionTimeout
					.Item(cdoSMTPAuthenticate) 		= This.nAuthenticate

					If This.nAuthenticate = cdoBasic
						.Item(cdoSendUserName) = This.cUserName
						.Item(cdoSendPassword) = This.cPassword
					Endif

					.Item(cdoURLGetLatestVersion) 	= This.lURLGetLatestVersion
					.Item(cdoSMTPUseSSL) 			= This.lUseSSL

					.Update()
				Endwith
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )

		Finally


		Endtry

		Return This.GetErrorCount()

	Endproc

	*----------------------------------------------------
	* Add message to the error collection
	Protected Procedure AddError
		Lparameters tcErrorMsg
		This.nErrorCount = This.nErrorCount + 1
		Dimension This.aErrors[This.nErrorCount]
		This.aErrors[This.nErrorCount] = tcErrorMsg
		Return This.nErrorCount
	Endproc

	*----------------------------------------------------
	* Format an error message and add to the error collection
	Protected Procedure AddOneError
		Lparameters tcPrefix, tnError, tcMethod, tnLine
		Local lcErrorMsg, laList[1]
		If Inlist(tnError, 1427,1429)
			Aerror(laList)
			lcErrorMsg = Transform(laList[7], "@0") + "  " + laList[3]
		Else
			lcErrorMsg = Message()
		Endif
		lcErrorMsg = Chrtran(lcErrorMsg, Chr(0), "")
		This.AddError(tcPrefix + ":" + Transform(tnError) + " # " + ;
			tcMethod + " # " + Transform(tnLine) + " # " + lcErrorMsg)
		Return This.nErrorCount
	Endproc

	*----------------------------------------------------
	* Simple Error handler. Adds VFP error to the objects error collection
	Protected Procedure Error
		Lparameters tnError, tcMethod, tnLine
		This.AddOneError("ERROR: ", tnError, tcMethod, tnLine )
		Return This.nErrorCount
	Endproc

	*-------------------------------------------------------
	* Set mail header fields, if necessary. For now sets X-MAILER, if specified
	Protected Procedure SetHeader
		Local loHeader

		Local lcCommand As String

		Try

			lcCommand = ""


			If Not Empty(This.cXMailer)
				loHeader = This.oMsg.Fields
				With loHeader
					.Item(cdoXMailer) =  This.cXMailer
					.Update()
				Endwith
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry
	Endproc

	*----------------------------------------------------
	*
	Protected Procedure cPriority_Assign(tvVal)
		* Check for incorrect values
		If Inlist("~" + Proper(tvVal) + "~", "~High~", "~Normal~", "~Low~") Or Empty(tvVal)
			This.cPriority = Proper(Alltrim(tvVal))
		Else
			This.AddError("ERROR: Invalid value for cPriority property.")
		Endif
	Endproc




	*
	* Devuelve on objeto con los parametros que pueden setearse
	Procedure GetSettingsParameters( lForceDefault As Boolean ) As Object;
			HELPSTRING "Devuelve on objeto con los parametros que pueden setearse"
		Local lcCommand As String
		Local loMailSettings As oMailSettings Of "Tools\Email\Prg\prxSmtp.prg",;
			loMailAccount As MailAccount Of 'Fw\Comunes\Prg\MailAccount.prg'

		Try

			lcCommand = ""
			loMailSettings = Createobject( "oMailSettings" )

			If lForceDefault And !Used( "cMailAccounts" )
				loMailAccount = GetEntity( "MailAccount" )
				loMailAccount.GetDefault()
			Endif

			If Used( "cMailAccounts" )
				loMailSettings.cServer 			= Alltrim( cMailAccounts.Server )
				loMailSettings.nServerPort 		= cMailAccounts.ServerPort
				loMailSettings.lUseSSL 			= cMailAccounts.UseSSL
				loMailSettings.nAuthenticate 	= cMailAccounts.Authentica
				loMailSettings.cUserName 		= Alltrim( cMailAccounts.UserName )
				loMailSettings.cPassword 		= Alltrim( cMailAccounts.Password )
				loMailSettings.cFrom 			= Alltrim( cMailAccounts.UserName )
				loMailSettings.cMostrar 		= Alltrim( cMailAccounts.Mostrar )
				loMailSettings.cReplyTo  		= Alltrim( cMailAccounts.ReplyTo )
				loMailSettings.lReadReceipt 	= ( cMailAccounts.ReadReceip = 1 )
				loMailSettings.nConnectionTimeout 	= cMailAccounts.ConTimeout
				loMailSettings.lMostrarEnEnviados 	= loMailSettings.lReadReceipt

				If !Empty( loMailSettings.cMostrar )
					loMailSettings.cFrom = loMailSettings.cMostrar + "<" + loMailSettings.cFrom + ">"
				Endif
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loMailAccount = Null

		Endtry

		Return loMailSettings

	Endproc && GetSettingsParameters

	*
	*
	Procedure LogSend(  ) As Void
		Local lcCommand As String,;
			lcLogSend As String,;
			lcLogFile As String

		Local i As Integer

		Try

			lcCommand = ""

			If GetValue( "LogSend", "ar0Mai", "N" ) = "S"


				lcLogSend = ""

				TEXT To lcLogSend NoShow TextMerge Pretext 03
				From     '<<This.cFrom>>'
				ReplyTo  '<<This.cReplyTo>>'

				To       '<<This.cTo>>'
				CC       '<<This.cCC>>'
				BCC      '<<This.cBCC>>'
				Subject  '<<This.cSubject>>'

				ENDTEXT

				* Create HTML body from external HTML (file, URL)
				If Not Empty(This.cHtmlBodyUrl)
					TEXT To lcLogSend NoShow TextMerge Pretext 03 ADDITIVE
					HtmlBodyUrl '<<This.cHtmlBodyUrl>>'

					ENDTEXT

				Endif

				* Send HTML body. Creates TextBody as well
				If Not Empty(This.cHtmlBody)
					TEXT To lcLogSend NoShow TextMerge Pretext 03 ADDITIVE
					HtmlBody '<<This.cHtmlBody>>'

					ENDTEXT

				Endif

				* Send Text body. Could be different from HtmlBody, if any
				If Not Empty(This.cTextBody)
					TEXT To lcLogSend NoShow TextMerge Pretext 03 ADDITIVE
					TextBody '<<This.cTextBody>>'

					ENDTEXT

				Endif

				* Process attachments
				If .F. && Not Empty(This.cAttachment)
					* Accepts comma or semicolon
					* VFP 7.0 and later
					*FOR lnind=1 TO ALINES(laList, This.cAttachment, [,], [;])
					* VFP 6.0 and later compatible
					For lnind=1 To Alines(laList, Chrtran(This.cAttachment, [,;], Chr(13) + Chr(13)))
						lcAttachment = Alltrim(laList[lnind])
						* Ignore empty values
						If Empty(laList[lnind])
							Loop
						Endif

						* Make sure that attachment exists
						If Adir(laDummy, lcAttachment) > 0
							* The full path is required.
							If 	Upper(lcAttachment) <> Upper(Fullpath(lcAttachment))
								lcAttachment = Fullpath(lcAttachment)
							Endif
							This.oMsg.AddAttachment(lcAttachment)

							TEXT To lcLogSend NoShow TextMerge Pretext 03 ADDITIVE
							AddAttachment '<<lcAttachment>>'

							ENDTEXT

						Endif
					Endfor
				Endif


				TEXT To lcSetup NoShow TextMerge Pretext 03
				[ cdoSendUsingMethod ] <<cdoSendUsingPort>>
				[ cdoSMTPServer ] <<This.cServer>>
				[ cdoSMTPServerPort ] <<This.nServerPort>>
				[ cdoSMTPConnectionTimeout ] <<This.nConnectionTimeout>>
				[ cdoSMTPAuthenticate ] <<This.nAuthenticate>>
				[ cdoSendUserName ] <<This.cUserName>>
				[ cdoSendPassword ] <<Replicate( "*", Len( This.cPassword ) )>>
				[ cdoURLGetLatestVersion ] <<This.lURLGetLatestVersion>>
				[ cdoSMTPUseSSL ] <<This.lUseSSL>>
				ENDTEXT

				*[ cdoSendPassword ] <<This.cPassword>>

				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = ""
				loError.Process ( Null, .F., .F. )

				lcErrorMsg  = Replicate( '-', 40 ) + CRLF
				lcErrorMsg = lcErrorMsg + Transform( Datetime() ) + CRLF

				lcErrorMsg = lcErrorMsg + lcLogSend + CRLF + CRLF

				lcErrorMsg = lcErrorMsg + "Configuración de la Cuenta" + CRLF
				lcErrorMsg = lcErrorMsg + lcSetup + CRLF + CRLF

				lcErrorMsg = lcErrorMsg + "Tablas y cursores en uso" + CRLF
				lcErrorMsg = lcErrorMsg + "DatasessionId: " + Transform( Set("Datasession" )) + CRLF + CRLF
				lcErrorMsg = lcErrorMsg + loError.cTables + CRLF + CRLF

				lcErrorMsg = lcErrorMsg + "Pila de llamadas" + CRLF
				lcErrorMsg = lcErrorMsg + loError.cStack + CRLF + CRLF

				lcErrorMsg = lcErrorMsg + "Información del sistema" + CRLF
				lcErrorMsg = lcErrorMsg + loError.cSysInfo  + CRLF

				lcErrorMsg = lcErrorMsg + Replicate( "-.", 40 ) + CRLF + CRLF

				lcLogFile = 'LogSend_' + Dtoc( Datetime(), 1 ) + '.txt'

				Strtofile( lcErrorMsg, lcLogFile, 1 )

				* Intentar grabar el ErrorLog.txt en el servidor, para poder acceder más facilmenmte
				If Vartype( DRVA ) = "C"
					Strtofile( lcErrorMsg, Addbs(Alltrim(DRVA))+lcLogFile, 1 )
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

	Endproc && LogSend

	*
	* Devuelve on objeto con los parametros que pueden setearse
	Procedure xxxGetSettingsParameters(  ) As Object;
			HELPSTRING "Devuelve on objeto con los parametros que pueden setearse"
		Local lcCommand As String
		Local loParam As Object

		Try

			lcCommand = ""
			loParam = Createobject( "Empty" )
			AddProperty( loParam, "cServer", "" )
			AddProperty( loParam, "nServerPort", 0 )
			AddProperty( loParam, "lUseSSL", .T. )
			AddProperty( loParam, "nAuthenticate", 0 )
			AddProperty( loParam, "cUserName", "" )
			AddProperty( loParam, "cPassword", "" )
			AddProperty( loParam, "cFrom", "" )
			AddProperty( loParam, "cTo", "" )
			AddProperty( loParam, "cSubject", "" )
			AddProperty( loParam, "cTextBody", Ttoc( Datetime()) )
			AddProperty( loParam, "cAttachment", "" )

			If Used( "cMailAccounts" )
				loParam.cServer 		= cMailAccounts.cServer
				loParam.nServerPort 	= cMailAccounts.nServerPort
				loParam.lUseSSL 		= cMailAccounts.lUseSSL
				loParam.nAuthenticate 	= cMailAccounts.nAuthenticate
				loParam.cUserName 		= cMailAccounts.cUserName
				loParam.cPassword 		= cMailAccounts.cPassword
				loParam.cFrom 			= cMailAccounts.cFrom
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loParam

	Endproc && xxxGetSettingsParameters

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oEMail
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oMailSettings
*!* Description...:
*!* Date..........: Domingo 13 de Septiembre de 2015 (12:50:24)
*!*
*!*

Define Class oMailSettings As Custom

	#If .F.
		Local This As oMailSettings Of "Tools\Email\Prg\prxSmtp.prg"
	#Endif

	* Datos de Envío
	cTo 		= ""
	cCC 		= ""
	cBCC 		= ""
	cAttachment = ""
	cSubject 	= ""
	cHtmlBody 	= ""
	cTextBody 	= ""
	cHtmlBodyUrl = ""
	cCharset 	= ""
	cPriority 	= ""

	* Datos de la Cuenta
	cFrom 		= ""
	cMostrar 	= ""
	cReplyTo 	= ""
	cServer 	= ""
	nServerPort = 25
	lUseSSL 	= .F.
	nConnectionTimeout = 30			&& Default 30 sec's
	nAuthenticate = cdoAnonymous
	cUserName 	= ""
	cPassword 	= ""
	lURLGetLatestVersion = .T.
	lReadReceipt = .F.

	* Otros
	cNombreFantasia = ""
	lMostrarEnEnviados = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cfrom" type="property" display="cFrom" />] + ;
		[<memberdata name="cmostrar" type="property" display="cMostrar" />] + ;
		[<memberdata name="creplyto" type="property" display="cReplyTo" />] + ;
		[<memberdata name="cto" type="property" display="cTo" />] + ;
		[<memberdata name="ccc" type="property" display="cCC" />] + ;
		[<memberdata name="cbcc" type="property" display="cBCC" />] + ;
		[<memberdata name="cattachment" type="property" display="cAttachment" />] + ;
		[<memberdata name="csubject" type="property" display="cSubject" />] + ;
		[<memberdata name="chtmlbody" type="property" display="cHtmlBody" />] + ;
		[<memberdata name="ctextbody" type="property" display="cTextBody" />] + ;
		[<memberdata name="chtmlbodyurl" type="property" display="cHtmlBodyUrl" />] + ;
		[<memberdata name="ccharset" type="property" display="cCharset" />] + ;
		[<memberdata name="cpriority" type="property" display="cPriority" />] + ;
		[<memberdata name="cserver" type="property" display="cServer" />] + ;
		[<memberdata name="nserverport" type="property" display="nServerPort" />] + ;
		[<memberdata name="lusessl" type="property" display="lUseSSL" />] + ;
		[<memberdata name="nconnectiontimeout" type="property" display="nConnectionTimeout" />] + ;
		[<memberdata name="nauthenticate" type="property" display="nAuthenticate" />] + ;
		[<memberdata name="cusername" type="property" display="cUserName" />] + ;
		[<memberdata name="cpassword" type="property" display="cPassword" />] + ;
		[<memberdata name="lurlgetlatestversion" type="property" display="lURLGetLatestVersion" />] + ;
		[<memberdata name="lreadreceipt" type="property" display="lReadReceipt" />] + ;
		[<memberdata name="cnombrefantasia" type="property" display="cNombreFantasia" />] + ;
		[<memberdata name="lmostrarenenviados" type="property" display="lMostrarEnEnviados" />] + ;
		[</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oMailSettings
*!*
*!* ///////////////////////////////////////////////////////



