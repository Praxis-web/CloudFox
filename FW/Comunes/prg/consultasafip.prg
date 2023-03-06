*!* ///////////////////////////////////////////////////////
*!* Class.........: oConsultasAFIP
*!* Description...:
*!* Date..........: Viernes 5 de Agosto de 2016 (13:54:00)
*!*
*!*

#INCLUDE "FW\Comunes\Include\Praxis.h"
#Define _VARON		1
#Define _MUJER		2
#Define _EMPRESA	3

Local lcCommand As String, lcMsg As String
Local loConsultasAFIP As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg"

Try

	lcCommand = ""
	Close Databases All
	loConsultasAFIP = Newobject( "oConsultasAFIP", "FW\Comunes\prg\ConsultasAFIP.prg" )

	lcCuil= "27-39462870-6"

	Inform( loConsultasAFIP.ValidarCuil( lcCuil ) )

	lnDNI = 39462870
	*Inform( loConsultasAFIP.GetCuil( lnDNI, 2, .T. ))


	*lcCuil = loConsultasAFIP.CalcularCuil("22503233",2,.T. )
	 

	Inform( lcCuil )


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



Define Class oConsultasAFIP As Custom

	#If .F.
		Local This As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg"
	#Endif

	lSilence = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lsilence" type="property" display="lSilence" />] + ;
		[<memberdata name="datospersonales_wsafipfe" type="method" display="DatosPersonales_wsAfipFe" />] + ;
		[<memberdata name="datospersonales_api_rest" type="method" display="DatosPersonales_Api_Rest" />] + ;
		[<memberdata name="datospersonales" type="method" display="DatosPersonales" />] + ;
		[<memberdata name="impuestos" type="method" display="Impuestos" />] + ;
		[<memberdata name="getcuil" type="method" display="GetCuil" />] + ;
		[<memberdata name="validarcuil" type="method" display="ValidarCuil" />] + ;
		[<memberdata name="calcularcuil" type="method" display="CalcularCuil" />] + ;
		[</VFPData>]

	*
	*
	Procedure DatosPersonales_wsAfipFe( cCuit As String ) As Objetc
		Local lcCommand As String
		Local loFE As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg",;
			loPersona As Object,;
			loDatosGenerales As Object,;
			loDomicilioFiscal As Object


		Try

			lcCommand = ""
			loFE = NewFE( .T. )
			
			loPersona = loFE.GetPersona( cCuit )

			*!*				If loPersona.Success
			*!*					* RA 09/12/2017(09:12:10)
			*!*					* Compatibilidad con la version DatosPersonales_Api_Rest()

			*!*					loDatosGenerales 	= loPersona.oDatosGenerales
			*!*					loDomicilioFiscal 	= loDatosGenerales.DomicilioFiscal


			*!*					If !Pemstatus( loPersona, "Data", 5 )
			*!*						AddProperty( loPersona, "Data", Createobject( "Empty" ) )
			*!*					Endif

			*!*					If !Pemstatus( loPersona.Data, "DomicilioFiscal", 5 )
			*!*						AddProperty( loPersona.Data, "DomicilioFiscal", loDomicilioFiscal )
			*!*					Endif

			*!*				Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loDatosGenerales 	= Null
			loDomicilioFiscal 	= Null

		Endtry

		Return loPersona

	Endproc && DatosPersonales_wsAfipFe


	*
	*
	* Se obtiene de la página 'https://soa.afip.gob.ar/sr-padron/v2/persona/'
	* Mediante MSXML2.XMLHTTP

	* RA 08/12/2017(19:06:17)
	* FUERA DE SERVICIO
	Procedure DatosPersonales_Api_Rest( cCuit As String ) As Objetc
		Local lcCommand As String,;
			lcCuit As String,;
			lcCUIT_URL As String,;
			lcJSON_Str As String

		Local loPadron As 'MSXML2.XMLHTTP',;
			loPersona As Object,;
			loErr As Exception,;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"


		Local lnStatus As Integer

		Try

			lcCommand 	= ""
			lnStatus 	= 0

			loGlobalSettings 	= NewGlobalSettings()
			loPersona 			= Createobject( "Empty" )
			AddProperty( loPersona, "lStatus", .F. )

			If .F. && loGlobalSettings.lConsultasAfip

				cCuit 		= Strtran( cCuit, "-", "" )
				cCuit 		= Strtran( cCuit, " ", "" )


				lcCuit 		= Strtran( cCuit, "-", "" )
				lcCUIT_URL 	= 'https://soa.afip.gob.ar/sr-padron/v2/persona/'
				loPadron 	= Createobject( 'MSXML2.XMLHTTP' )

				loPadron.Open('GET', lcCUIT_URL + lcCuit, .F.)
				loPadron.Send()
				lnStatus 	= loPadron.Status

				lcJSON_Str 	= loPadron.ResponseText()
				lnStatus 	= loPadron.Status

				If lnStatus = 200

					loJSON 		= Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
					loPersona 	= loJSON.JsonToVfp( lcJSON_Str )

					If !Empty( loJSON.cError_Msg )
						AddProperty( loPersona, "lStatus", .F. )

					Else

						AddProperty( loPersona, "lStatus", .T. )

						If loPersona.Success
							If !Pemstatus( loPersona.Data, "Impuestos", 5 )
								AddProperty( loPersona.Data, "Impuestos", Createobject( "Collection" ) )
							Endif

							If !Pemstatus( loPersona.Data, "DomicilioFiscal", 5 )
								AddProperty( loPersona.Data, "DomicilioFiscal", Createobject( "Empty" ) )
							Endif

							If !Pemstatus( loPersona.Data.DomicilioFiscal, "Localidad", 5 )
								AddProperty( loPersona.Data.DomicilioFiscal, "Localidad", "CABA" )
							Endif

							If !Pemstatus( loPersona.Data.DomicilioFiscal, "idProvincia", 5 )
								AddProperty( loPersona.Data.DomicilioFiscal, "idProvincia", 0 )
							Endif

							If !Pemstatus( loPersona.Data.DomicilioFiscal, "CodPostal", 5 )
								AddProperty( loPersona.Data.DomicilioFiscal, "CodPostal", Space( 8 ) )
							Endif

							If !Pemstatus( loPersona.Data.DomicilioFiscal, "Direccion", 5 )
								AddProperty( loPersona.Data.DomicilioFiscal, "Direccion", Space( 100 ) )
							Endif

						Else
							loPersona.Error.Mensaje = Strtran( loPersona.Error.Mensaje, " id ", " CUIT ", -1, -1, 1 )
							loPersona.Error.Mensaje = Strtran( loPersona.Error.Mensaje, "id ", "CUIT ", -1, -1, 1 )
							loPersona.Error.Mensaje = Strtran( loPersona.Error.Mensaje, " id", " CUIT", -1, -1, 1 )

						Endif
					Endif
				Else

					If !Empty( lnStatus )
						If lnStatus # 200
							TEXT To lcCommand NoShow TextMerge Pretext 03
								Error al conectarse a la AFIP
								Error Nº: <<lnStatus>>
							ENDTEXT

							Do Case
								Case lnStatus = 12007
									lcCommand = lcCommand + CRLF + "Verifique su conexión a Internet"

								Case lnStatus = 404
									lcCommand = lcCommand + CRLF + "La Página No Fue Encontrada"

								Otherwise

							Endcase
						Endif

						If !This.lSilence
							Wait Window Nowait Noclear lcCommand
						Endif

						If lnStatus # 200
							TEXT To lcMsg NoShow TextMerge Pretext 03
								Existen problemas para validar la CUIT
								en la página de la Afip

								Para agilizar la operatoria, puede cancelar
								la validación contra el WS de la Afip
								durante el transcurso de ésta sesión.

								¿Cancela durante ésta sesión?
							ENDTEXT

							If Confirm( lcMsg, "Validación de la CUIT" )
								loGlobalSettings.lConsultasAfip = .F.

								TEXT To lcMsg NoShow TextMerge Pretext 03
									Para volver a habilitar la consulta
									en línea al servidor de la AFIP, debe
									cerrar éste módulo y volver a abrirlo.
								ENDTEXT

								Inform( lcMsg, "Validación de la CUIT" )

							Endif

							Wait Clear

						Endif

					Endif


				Endif

			Endif

		Catch To loErr
			Do Case
				Case loErr.ErrorNo = 1733 && No se encuentra la definición de clase
					* No Hacer Nada

				Case loErr.ErrorNo = 1429 && Código de excepción OLE IDispatch
					* No Hacer Nada

					Try

						lnStatus = loPadron.Status

					Catch To oErr
						lnStatus = 0

					Finally
						If !Empty( lnStatus )
							If lnStatus # 200
								TEXT To lcCommand NoShow TextMerge Pretext 03
								Error al conectarse a la AFIP
								Error Nº: <<lnStatus>>
								ENDTEXT

								Do Case
									Case lnStatus = 12007
										lcCommand = lcCommand + CRLF + "Verifique su conexión a Internet"

									Otherwise

								Endcase
							Endif

							If !This.lSilence
								Wait Window Nowait Noclear lcCommand
							Endif

							If lnStatus # 200
								TEXT To lcMsg NoShow TextMerge Pretext 03
								Existen problemas para validar la CUIT
								en el WS de la Afip

								Para agilizar la operatoria, puede cancelar
								la validación contra el WS de la Afip
								durante el transcurso de ésta sesión.

								¿Cancela durante ésta sesión?
								ENDTEXT

								If Confirm( lcMsg, "Validación de la CUIT" )
									loGlobalSettings.lConsultasAfip = .F.

									TEXT To lcMsg NoShow TextMerge Pretext 03
									Para volver a habilitar la consulta
									en línea al servidor de la AFIP, debe
									cerrar éste módulo y volver a abrirlo.
									ENDTEXT

									Inform( lcMsg, "Validación de la CUIT" )

								Endif

								Wait Clear

							Endif

						Endif

					Endtry

				Otherwise
					Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
					loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )

					Try

						lnStatus = loPadron.Status

					Catch To oErr
						lnStatus = 0

					Finally
						If !Empty( lnStatus )
							If lnStatus # 200
								TEXT To lcCommand NoShow TextMerge Pretext 03
								Error al conectarse a la AFIP
								Error Nº: <<lnStatus>>
								ENDTEXT

								Do Case
									Case lnStatus = 12007
										lcCommand = lcCommand + CRLF + "Verifique su conexión a Internet"

									Otherwise

								Endcase
							Endif

						Endif

					Endtry

					loError.cRemark = lcCommand
					loError.Process ( m.loErr, .F. )
					Throw loError
			Endcase

		Finally
			loPadron = Null

		Endtry

		Return loPersona

	Endproc && DatosPersonales_Api_Rest


	*
	*
	Procedure DatosPersonales( cCuit As String ) As Objetc
		Local lcCommand As String
		Local llUse_WS As Boolean
		Local loPersona As Object
		Local loFE_Ocx As "WsAfipFe.factura",;
			loFE As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg",;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

		Try

			lcCommand = ""
			llUse_WS = .F.

			loGlobalSettings 	= NewGlobalSettings()
			loPersona 			= Createobject( "Empty" )
			AddProperty( loPersona, "lStatus", .F. )

			If loGlobalSettings.lConsultasAfip

				cCuit 		= Strtran( cCuit, "-", "" )
				cCuit 		= Strtran( cCuit, " ", "" )

				loFE = NewFE( .T. )
				llUse_WS = Vartype( loFE ) = "O"
				
				If llUse_WS
					loPersona = This.DatosPersonales_wsAfipFe( cCuit )
					*loGlobalSettings.lConsultasAfip = loPersona.Success

				Else
					loGlobalSettings.lConsultasAfip = .F.

				Endif
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loFE = Null

		Endtry

		Return loPersona

	Endproc && DatosPersonales


	*
	*
	Procedure Impuestos(  ) As Void
		Local lcCommand As String,;
			lcImpuestos_URL As String,;
			lcJSON_Str As String

		Local loPadron As 'MSXML2.XMLHTTP',;
			loImpuestos As Object,;
			loErr As Exception

		Local lnStatus As Integer


		Try

			lcCommand = ""
			lnStatus 	= 0
			loImpuestos 	= Createobject( "Empty" )
			AddProperty( loImpuestos, "lStatus", .F. )

			lcImpuestos_URL = 'https://soa.afip.gob.ar/parametros/v1/impuestos'
			loPadron 		= Createobject( 'MSXML2.XMLHTTP' )

			loPadron.Open('GET', lcImpuestos_URL, .F.)
			loPadron.Send()
			lnStatus 	= loPadron.Status

			lcJSON_Str 	= loPadron.ResponseText()

			*StrToFile( lcJSON_Str, "JSON_Str.txt" )
			lnStatus 	= loPadron.Status

			loJSON 		= Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
			loImpuestos = loJSON.JsonToVfp( lcJSON_Str )
			AddProperty( loImpuestos, "lStatus", .T. )


		Catch To loErr
			Do Case
				Case loErr.ErrorNo = 1733 && No se encuentra la definición de clase
					* No Hacer Nada

				Case loErr.ErrorNo = 1429 && Código de excepción OLE IDispatch
					* No Hacer Nada

					Try

						lnStatus = loPadron.Status

					Catch To oErr
						lnStatus = 0

					Finally
						If !Empty( lnStatus )
							If lnStatus # 200
								TEXT To lcCommand NoShow TextMerge Pretext 03
								Error al conectarse a la AFIP
								Error Nº: <<lnStatus>>
								ENDTEXT

								Do Case
									Case lnStatus = 12007
										lcCommand = lcCommand + CRLF + "Verifique su conexión a Internet"

									Otherwise

								Endcase
							Endif

							If !This.lSilence
								Wait Window Nowait Noclear lcCommand
							Endif

						Endif

					Endtry

				Otherwise
					Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
					loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )

					Try

						lnStatus = loPadron.Status

					Catch To oErr
						lnStatus = 0

					Finally
						If !Empty( lnStatus )
							If lnStatus # 200
								TEXT To lcCommand NoShow TextMerge Pretext 03
								Error al conectarse a la AFIP
								Error Nº: <<lnStatus>>
								ENDTEXT

								Do Case
									Case lnStatus = 12007
										lcCommand = lcCommand + CRLF + "Verifique su conexión a Internet"

									Otherwise

								Endcase
							Endif

						Endif

					Endtry

					loError.cRemark = lcCommand
					loError.Process ( m.loErr, .F. )
					Throw loError
			Endcase

		Finally
			loPadron = Null

		Endtry

		Return loImpuestos

	Endproc && Impuestos



	*
	*
	Procedure CalcularCuil( cDNI, nGenero, lPlain, nTop, nLeft, lSilence, cCaption ) As String
		Local lcCommand As String,;
			lcCuil As String

		Local lnTop As Integer,;
			lnLeft As Integer,;
			lnGenero As Integer,;
			lnDNI As Integer

		Local loForm As Form

		Try

			lcCommand = ""
			Try

				loForm = GetActiveForm()

			Catch To oErr
				loForm = _Screen

			Finally

			Endtry

			If Vartype( nTop ) # "N"
				nTop = -1
			Endif

			If nTop >= 0
				lnTop = nTop

				If !Empty( cCaption )
					lnTop = lnTop - 1
				Endif

				lnTop 	= loForm.Top  + ( loForm.TextHeight( "X" ) * ( lnTop + 1.5 ))
				lnLeft 	= loForm.Left + ( loForm.TextWidth( "X" )  * nLeft )

			Else
				lnTop 	= -1
				lnLeft  = -1

			Endif

			If Vartype( cDNI ) = "C"
				lnDNI = Val( cDNI )
			Endif

			If Vartype( cDNI ) = "N"
				lnDNI = cDNI
			Endif

			If Vartype( lnDNI ) # "N"
				lnDNI = 0
			EndIf
			
			If lnDNI > 99999999 
				lnDNI = Val( Substr( Transform( cDNI ), 3, 8 ))
			EndIf

			lnGenero = nGenero

			If Empty( lnGenero ) Or ( Vartype( lnGenero ) # "N"  )
				lnGenero = _VARON
			Endif

			If !Inlist( lnGenero, _VARON, _MUJER, _EMPRESA )
				lnGenero = _VARON
			Endif

			If Vartype( lPlain ) # "L"
				lPlain = .F.
			Endif


			loParam = Createobject( "Empty" )

			AddProperty( loParam,"nTop", 		lnTop )
			AddProperty( loParam,"nLeft", 		lnLeft )
			AddProperty( loParam,"nDNI", 		lnDNI )
			AddProperty( loParam,"nGenero", 	lnGenero )
			AddProperty( loParam,"lPlain", 	lPlain )
			AddProperty( loParam,"FontName", 	loForm.FontName )
			AddProperty( loParam,"FontSize", 	loForm.FontSize )

			If !Empty( cCaption )
				AddProperty( loParam,"TitleBar", 1 )
				AddProperty( loParam,"Caption", cCaption )
			Endif

			Do Form "v:\CloudFox\FW\Comunes\Scx\Obtener_Cuil" With loParam To lcCuil

			If !lSilence And nTop >= 0
				SayMask( nTop, nLeft,  lcCuil, "" )
			Endif

			prxLastkey()


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lcCuil

	Endproc && CalcularCuil


	*!*	Generando el CUIL CUIT
	*!*	CUIL / CUIT
	*!*	CUIL/T: Son 11 números en total:
	*!*	XY – 12345678 – Z
	*!*	XY: Indican el tipo (Masculino, Femenino o una empresa)
	*!*	12345678: Número de DNI
	*!*	Z: Código Verificador

	*!*	Algoritmo:
	*!*	Se determina XY con las siguientes reglas
	*!*	Masculino:20
	*!*	Femenio:27
	*!*	Empresa:30

	*!*	Se multiplica XY 12345678 por un número de forma separada:

	*!*	X * 5
	*!*	Y * 4
	*!*	1 * 3
	*!*	2 * 2
	*!*	3 * 7
	*!*	4 * 6
	*!*	5 * 5
	*!*	6 * 4
	*!*	7 * 3
	*!*	8 * 2

	*!*	Se suman dichos resultados. El resultado obtenido se divide por 11. De esa división se obtiene un Resto que determina Z
	*!*	Si el resto es 0= Entoces Z=0 Si el resto es 1= Entonces se aplica la siguiente regla:
	*!*	Si es hombre: Z=9 y XY pasa a ser 23
	*!* Si es mujer: Z=4 y XY pasa a ser 23
	*!*	Caso contrario Z pasa a ser (11- Resto).


	*
	* Recibe el Nº de DNI y devuelve el CUIL
	Procedure GetCuil( nDNI As Integer,;
			nGenero As Integer,;
			lPlain As Boolean ) As String;
			HELPSTRING "Recibe el Nº de DNI y devuelve el CUIL"
		Local lcCommand As String,;
			lcCuil As String,;
			lcDNI As String,;
			lcBase As String

		Local lnCUIL As Integer,;
			i As Integer,;
			r As Integer,;
			z As Integer

		Try

			lcCommand = ""
			lcDNI = Padl( Transform( nDNI ), 8, "0" )
			lcBase = "5432765432"
			lcCuil = ""
			lnCUIL = 0
			
			Do Case
				Case nGenero = _VARON
					lcDNI = "20" + lcDNI

				Case nGenero = _MUJER
					lcDNI = "27" + lcDNI

				Case nGenero = _EMPRESA
					lcDNI = "30" + lcDNI

				Otherwise

			Endcase

			For i = 1 To 10
				lnCUIL = lnCUIL + ( Val( Substr( lcDNI, i, 1 )) * Val( Substr( lcBase, i, 1 )))

			Endfor

			r = Mod( lnCUIL, 11 )

			Do Case
				Case Empty( r )
					z = 0

				Case r = 1
					Do Case
						Case nGenero = _VARON
							z = 9
							lcDNI = "23" + Substr( lcDNI, 3 )

						Case nGenero = _MUJER
							z = 4
							lcDNI = "23" + Substr( lcDNI, 3 )

						Otherwise
							z = 11 - r

					Endcase

				Otherwise
					z = 11 - r

			Endcase

			lcCuil = lcDNI + Transform( z )

			If !lPlain
				lcCuil = Transform( lcCuil, "@R 99-99999999-9" )
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lcCuil

	Endproc && GetCuil

	*
	*
	Procedure ValidarCuil( cCuil As String,;
			nGenero As Integer ) As Boolean

		Local lcCommand As String,;
			lcDNI As String,;
			lcPrefijo As String,;
			lcCuil As String,;
			lcCuil_Aux as String 

		Local lcDigito As Character
		Local llValid As Boolean

		Try

			lcCommand = ""
			llValid = .F.
			lcCuil = Strtran( cCuil, "-", "" )
			lcCuil = Alltrim( Strtran( lcCuil, " ", "" ) )

			If Len( lcCuil ) = 11
				lcDNI = Substr( lcCuil, 3, 8 )

				If Empty( nGenero ) Or !Inlist( nGenero, _VARON, _MUJER, _EMPRESA )
					lcCuil_Aux = This.GetCuil( Val( lcDNI ), _VARON, .T. )  
					llValid = ( lcCuil = lcCuil_Aux )

					If !llValid
						lcCuil_Aux = This.GetCuil( Val( lcDNI ), _MUJER, .T.  )  
						llValid = ( lcCuil = lcCuil_Aux )
					Endif

					If !llValid
						lcCuil_Aux = This.GetCuil( Val( lcDNI ), _EMPRESA, .T.  )  
						llValid = ( lcCuil = lcCuil_Aux )
					Endif

				Else
					llValid = ( This.GetCuil( Val( lcDNI ), nGenero, .T. ) = lcCuil )

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

		Return llValid

	Endproc && ValidarCuil



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oConsultasAFIP
*!*
*!* ///////////////////////////////////////////////////////
