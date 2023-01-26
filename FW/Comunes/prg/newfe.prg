Lparameters lConsultaPadron As Boolean

External Procedure PadronAfip.prg

#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\FE\Include\FE.h"


Local loFE As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg",;
	loFE_Ocx As "WsAfipFe.factura",;
	loWsPadron As oWsPadron Of "Clientes\Siap\Padron\Prg\PadronAfip.prg"

Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
Local loFiscalErrors As Collection
Local loPrinterErrors As Collection
Local i As Integer
Local llExist As Boolean
Local lcAlias As String,;
	lcArchivoCertificadoVto As String,;
	lcMsg As String

Local ldArchivoCertificadoVto As Date


Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Try

	llExist = .T.
	loGlobalSettings = NewGlobalSettings()
	loFE = Null

	If lConsultaPadron
		loFE = loGlobalSettings.oWsPadron

	Else
		loFE = loGlobalSettings.oFE

	EndIf
	
	If Vartype( loFE ) # 'O' Or ( loFe.lResultado = .F. )
	
		If lConsultaPadron
			loFE = Newobject( "oWsPadron", "Clientes\Siap\Padron\Prg\PadronAfip.prg" )

		Else
			loFE = Newobject( "prxWSFEv1", "Tools\FE\Prg\prxWSFEv1.prg" )

		Endif

		loFE_Ocx = loFE.oFE

		If Vartype( loFE_Ocx ) = "O"
			Try
				If lConsultaPadron
					loFE_Ocx.p1Version = 5
					=loFE_Ocx.p1GetPersona( "" )
				Endif

			Catch To oErr
				* RA 10/12/2017(12:01:50)
				* Para consltar el Padrón hay que instalar la última version de wsAfipFe
				loFE_Ocx = Null

			Finally

			Endtry

		Endif

		If Vartype( loFE_Ocx ) = "O"
		
			lcAlias = Alias()

			llExist = Used( "AR0FEL" )
			If !llExist
				M_Use( 0, Trim( DRVA ) + "AR0FEL" )
			Endif

			loFE.nModo 			= AR0FEL.MODO0
			loFE.cCuitEmisor 	= Alltrim( AR0FEL.CUIT0 )
			loFE.nPuntoDeVenta 	= AR0FEL.PVEN0

			loFE.cCertificado 	= Alltrim( AR0FEL.CERT0 )
			loFE.cLicencia 		= Alltrim( AR0FEL.LICE0 )

			If lConsultaPadron
				If !Empty( Field( "WSPUC_Cert", "ar0Fel" ))
					If !Empty( AR0FEL.WSPUC_Cert )
						loFE.cCertificado 	= Alltrim( AR0FEL.WSPUC_Cert )
					Endif
				Endif

				If !Empty( Field( "WSPUC_Lic", "ar0Fel" ))
					If !Empty( AR0FEL.WSPUC_Lic )
						loFE.cLicencia 		= Alltrim( AR0FEL.WSPUC_Lic )
					Endif
				Endif

				If loFE.cLicencia # Alltrim( AR0FEL.LICE0 )
					loFE.cCuitEmisor = "33527840029"
				Endif

				loFE.nModo = 1

			Endif

			If loFE.nModo = 0 && Prueba
				*loFE.nPuntoDeVenta = loFE.nPuntoDeVenta + 50
			Endif

			loFE.DefaultFolder 	= Justpath( loFE.cCertificado )
			loFE.lImportesExpresadosSiempreEnPesos = .T.

			loFE.lResultado = loFE.Preparada()

			If loFE.lResultado

				If lConsultaPadron
					loGlobalSettings.oWsPadron = loFE

					* Verificar que Puede Consultar al WS Padrón
					loWsPadron 	= loGlobalSettings.oWsPadron
					loPersona 	= loWsPadron.GetPersona( loFE.cCuitEmisor )
					loGlobalSettings.lConsultasAfip = loPersona.Success

				Else
					loGlobalSettings.oFE = loFE

				Endif

				ldArchivoCertificadoVto = {}

				Try

					lcArchivoCertificadoVto = loFE_Ocx.ArchivoCertificadoVto
					If Isnull( lcArchivoCertificadoVto )
						If FileExist( Addbs( loFE.DefaultFolder )+ "ArchivoCertificadoVto.txt" )
							lcArchivoCertificadoVto = Filetostr( Addbs( loFE.DefaultFolder )+ "ArchivoCertificadoVto.txt" )
							ldArchivoCertificadoVto = Ctod( Substr( lcArchivoCertificadoVto, 1, 10 ))
						Endif

					Else
						ldArchivoCertificadoVto = Ctod( Substr( lcArchivoCertificadoVto, 1, 10 ))
						Strtofile( lcArchivoCertificadoVto, Addbs( loFE.DefaultFolder )+ "ArchivoCertificadoVto.txt", 0 )

					Endif

				Catch To oErr

				Finally

				Endtry

				If !Empty( ldArchivoCertificadoVto )
					If ldArchivoCertificadoVto - Date() < 45

						TEXT To lcMsg NoShow TextMerge Pretext 03
					El Certificado está por vencer

					Fecha de vencimiento: <<lcArchivoCertificadoVto>>
						ENDTEXT

						Warning( lcMsg, "FACTURA ELECTRONICA", -1 )

					Endif

					If ldArchivoCertificadoVto - Date() < 15

						TEXT To lcMensajeAclaratorio NoShow TextMerge Pretext 03
					[F8]: Aceptar
						ENDTEXT

						TEXT To lcKeyPressList NoShow TextMerge Pretext 15
					<<KEY_F8>>
						ENDTEXT

						UserKeyPress( lcMsg,;
							lcMensajeAclaratorio,;
							lcKeyPressList )

					Endif


				Endif

			Else
				* loFE = Null

			Endif

		Else
			loGlobalSettings.lConsultasAfip = .F.

			If !lConsultaPadron
				TEXT To lcMsg NoShow TextMerge Pretext 03
				Debe instalar wsAfipFe
				para poder conectarse al
				Web Service de la AFIP
				ENDTEXT

				Warning( lcMsg, "Comuníquese con Praxis", -1 )

			Endif

		Endif

	Else
		If .F. && !loFE.lResultado
			loFE.lResultado = loFE.Preparada()
		Endif

	Endif && Vartype( loFE ) # 'O'

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

	loFE_Ocx 			= Null
	loWsPadron 			= Null
	loPersona 			= Null
	loGlobalSettings 	= Null

	If !llExist
		Use In AR0FEL
	Endif

	If !Empty( lcAlias )
		Select Alias( lcAlias )
	Endif

Endtry

Return loFE