#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure EnConstruccion( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String,;
	lcTextoDeAlerta as String,;
	lcMensajeAclaratorio as String,;
	lcKeyPressList as String,;
	lcPicture as String   


	Try

		lcCommand 				= ""
		lcTextoDeAlerta 		= ""
		lcMensajeAclaratorio 	= ""
		lcKeyPressList 			= "13"
		lcPicture 				= "v:\CloudFox\FW\Comunes\image\jpg\Ooops.jpg"

		TEXT To lcTextoDeAlerta NoShow TextMerge Pretext 03
		Lo sentimos

		La página a la que desea acceder todavía no está lista

		Disculpe las molestias
		EndText
		
		Text To lcMensajeAclaratorio NoShow TextMerge Pretext 15
		[Enter]: Continúa		
		EndText

		=UserKeyPress( lcTextoDeAlerta,;
			lcMensajeAclaratorio,;
			lcKeyPressList,;
			lcPicture )


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loEnConstruccion = Null

	Endtry

Endproc && EnConstruccion
