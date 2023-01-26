#Define cdoSendPassword "http://schemas.microsoft.com/cdo/configuration/sendpassword"
#Define cdoSendUserName "http://schemas.microsoft.com/cdo/configuration/sendusername"
#Define cdoSendUsingMethod "http://schemas.microsoft.com/cdo/configuration/sendusing"
#Define cdoSMTPAuthenticate "http://schemas.microsoft.com/cdo/configuration/smtpauthenticate"
#Define cdoSMTPConnectionTimeout "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout"
#Define cdoSMTPServer "http://schemas.microsoft.com/cdo/configuration/smtpserver"
#Define cdoSMTPServerPort "http://schemas.microsoft.com/cdo/configuration/smtpserverport"
#Define cdoSMTPUseSSL "http://schemas.microsoft.com/cdo/configuration/smtpusessl"
#Define cdoURLGetLatestVersion "http://schemas.microsoft.com/cdo/configuration/urlgetlatestversion"
#Define cdoXMailer "urn:schemas:mailheader:x-mailer"

* Authentication

#Define cdoAnonymous 		0	&& Perform no authentication (anonymous)
#Define cdoBasic 			1	&& Use the basic (clear text) authentication mechanism.
								* When using this option you have to provide the user name and password 
								* through the sendusername and sendpassword fields.
#Define cdoSendUsingPort 	2	&& Send the message using the SMTP protocol over the network.
								* The current process security context is used to authenticate with the service.
