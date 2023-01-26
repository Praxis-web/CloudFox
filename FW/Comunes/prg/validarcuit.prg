*
* Valida la CUIT contra la AFIP
Procedure ValidarCuit( nCuit As Integer ) As Object;
		HELPSTRING "Valida la CUIT contra la AFIP"
	Local lcCommand As String,;
	lcAlias as String 
	
	Local loReturn As Object,;
		loValidarCuit As oValidarCuit Of "FW\Comunes\Prg\ValidarCuit.prg"

	Try

		lcCommand = ""
		lcAlias = Alias()
		 
		loValidarCuit = Createobject( "oValidarCuit" )
		loReturn = loValidarCuit.Procesar( nCuit )


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loValidarCuit = Null
		If !Empty( lcAlias ) 
			Select Alias( lcAlias ) 
		EndIf

	Endtry

	Return loReturn

Endproc && ValidarCuit

*
*
Procedure Test(  ) As Void
	Local lcCommand As String
	Local loReturn As Object

	Private drComun As String

	Try

		lcCommand = ""

		drComun = "s:\Fenix\dbf\DBF\"



		Dimension Provincias_Afip[ 25 ], Zonas[ 25 ]
		* RA 06/08/2016(13:28:22)
		* Es lo que devuelve 'https://soa.afip.gob.ar/parametros/v1/provincias'
		* en idProvincia + 1 (Porque es base 0 )

		Provincias_Afip[01]	= 01
		Provincias_Afip[02]	= 02
		Provincias_Afip[03]	= 03
		Provincias_Afip[04]	= 04
		Provincias_Afip[05]	= 05
		Provincias_Afip[06]	= 08
		Provincias_Afip[07]	= 10
		Provincias_Afip[08]	= 13
		Provincias_Afip[09]	= 12
		Provincias_Afip[10]	= 17
		Provincias_Afip[11]	= 18
		Provincias_Afip[12]	= 19
		Provincias_Afip[13]	= 21
		Provincias_Afip[14]	= 22
		Provincias_Afip[15]	= 24
		Provincias_Afip[16]	= 00
		Provincias_Afip[17]	= 06
		Provincias_Afip[18]	= 07
		Provincias_Afip[19]	= 09
		Provincias_Afip[20]	= 14
		Provincias_Afip[21]	= 15
		Provincias_Afip[22]	= 11
		Provincias_Afip[23]	= 16
		Provincias_Afip[24]	= 20
		Provincias_Afip[25]	= 23


		Zonas[01]	= 'Capital Federal    '
		Zonas[02]	= 'Buenos Aires       '
		Zonas[03]	= 'Catamarca          '
		Zonas[04]	= 'Cordoba            '
		Zonas[05]	= 'Corrientes         '
		Zonas[06]	= 'Chaco              '
		Zonas[07]	= 'Chubut             '
		Zonas[08]	= 'Entre Rios         '
		Zonas[09]	= 'Formosa            '
		Zonas[10]	= 'Jujuy              '
		Zonas[11]	= 'La Pampa           '
		Zonas[12]	= 'La Rioja           '
		Zonas[13]	= 'Mendoza            '
		Zonas[14]	= 'Misiones           '
		Zonas[15]	= 'Neuquen            '
		Zonas[16]	= 'Rio Negro          '
		Zonas[17]	= 'Salta              '
		Zonas[18]	= 'San Juan           '
		Zonas[19]	= 'San Luis           '
		Zonas[20]	= 'Santa Cruz         '
		Zonas[21]	= 'Santa Fe           '
		Zonas[22]	= 'Santiago del Estero'
		Zonas[23]	= 'Tierra del Fuego   '
		Zonas[24]	= 'Tucuman            '
		Zonas[25]	= 'Exterior           '


		loReturn = ValidarCuit( 27225032330 )

		If loReturn.lStatus = .T.

			If loReturn.lSuccess = .T.

				TEXT To lcMsg NoShow TextMerge Pretext 03
				Razón Social:  <<loReturn.oPersona.cNombre]>>
				Dirección:     <<loReturn.oPersona.cDireccion]>>
				Localidad:     <<loReturn.oPersona.cLocalidad]>>
				Provincia:     <<Zonas[ loReturn.oPersona.idProvincia ]>>
				Código Postal: <<loReturn.oPersona.cCodPostal>>
				Estado:        <<loReturn.oPersona.cEstado>>

				Impuestos:

				ENDTEXT

				For Each loImpuesto In loReturn.oPersona.oImpuestos
					TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
					<<loImpuesto.nImpuesto_Id>> - <<loImpuesto.cImpuesto_Desc>>

					ENDTEXT
				Endfor

				Inform( lcMsg, "Validar Cuit", -1 )


			Else
				Warning( loReturn.cErrorMessage, "Validar Cuit" )

			Endif

		Else
			Warning( loReturn.cErrorMessage, "Validar Cuit" )

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

		Messagebox( lcMsg, 16, "Error" )


	Finally


	Endtry

Endproc && Test



*!* ///////////////////////////////////////////////////////
*!* Class.........: oValidarCuit
*!* Description...:
*!* Date..........: Miércoles 16 de Agosto de 2017 (10:47:43)
*!*
*!*

Define Class oValidarCuit As CustomBase Of Tools\namespaces\prg\CustomBase.prg

	#If .F.
		Local This As oValidarCuit Of "FW\Comunes\Prg\ValidarCuit.prg"
	#Endif

	nCuit = 0
	oReturn = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ncuit" type="property" display="nCuit" />] + ;
		[<memberdata name="oreturn" type="property" display="oReturn" />] + ;
		[<memberdata name="procesar" type="method" display="Procesar" />] + ;
		[<memberdata name="validarparametros" type="method" display="ValidarParametros" />] + ;
		[<memberdata name="validarcuit" type="method" display="ValidarCuit" />] + ;
		[<memberdata name="creartablaimpuestos" type="method" display="CrearTablaImpuestos" />] + ;
		[</VFPData>]


	*
	*
	Procedure Procesar( nCuit As Integer ) As Object
		Local lcCommand As String
		Local loReturn As Object

		Try

			lcCommand = ""
			loReturn = Createobject( "Empty" )
			AddProperty( loReturn, "lStatus", .F. )
			AddProperty( loReturn, "lSuccess", .F. )
			AddProperty( loReturn, "lCuit_OK", .F. )
			AddProperty( loReturn, "cErrorMessage", "" )
			AddProperty( loReturn, "nCuit", 0 )

			This.oReturn = loReturn

			loReturn = This.ValidarParametros( nCuit )

			If loReturn.lStatus = .T.
				loReturn = This.ValidarCuit()

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loReturn

	Endproc && Procesar

	*
	*
	Procedure ValidarCuit(  ) As Void
		Local lcCommand As String,;
			lcImpuesto_Desc As String

		Local loPersona As Object,;
			loConsultasAFIP As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg",;
			loImpuestos As Collection,;
			loImpuesto As Object,;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loReturn As Object

		Local lnImpuesto_Id As Integer

		Try

			lcCommand = ""
			loReturn = This.oReturn


			loConsultasAFIP = Newobject( "oConsultasAFIP", "FW\Comunes\prg\ConsultasAFIP.prg" )
			loPersona = loConsultasAFIP.DatosPersonales( Transform( This.nCuit ))

			loReturn.lStatus = loPersona.lStatus

			If loPersona.lStatus = .T.

				loReturn.lSuccess = loPersona.Success

				If loPersona.Success
					AddProperty( loReturn, "oPersona", loPersona )

				Else
					loReturn.cErrorMessage = loPersona.Error.Mensaje

				Endif

			Else

				* RA 18/08/2017(11:13:10)
				* No se pudo conectar a la AFIP
				
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loReturn

	Endproc && ValidarCuit


	*
	*
	Procedure xxxValidarCuit(  ) As Void
		Local lcCommand As String,;
			lcImpuesto_Desc As String

		Local loPersona As Object,;
			loConsultasAFIP As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg",;
			loImpuestos As Collection,;
			loImpuesto As Object,;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
			loReturn As Object

		Local lnImpuesto_Id As Integer

		Try

			lcCommand = ""
			loReturn = This.oReturn


			loConsultasAFIP = Newobject( "oConsultasAFIP", "FW\Comunes\prg\ConsultasAFIP.prg" )
			loPersona = loConsultasAFIP.DatosPersonales( Transform( This.nCuit ))

			loReturn.lStatus = loPersona.lStatus

			If loPersona.lStatus = .T.

				loReturn.lSuccess = loPersona.Success

				If loPersona.Success
					AddProperty( loReturn, "oPersona", Createobject( "Empty" ) )


					AddProperty( loReturn.oPersona, "cNombre", 	   loPersona.Data.Nombre )
					AddProperty( loReturn.oPersona, "cDireccion",  loPersona.Data.DomicilioFiscal.Direccion )
					AddProperty( loReturn.oPersona, "cLocalidad",  loPersona.Data.DomicilioFiscal.Localidad )
					AddProperty( loReturn.oPersona, "idProvincia", Provincias_Afip[ loPersona.Data.DomicilioFiscal.idProvincia + 1 ] )
					AddProperty( loReturn.oPersona, "cCodPostal",  Transform( loPersona.Data.DomicilioFiscal.CodPostal ) )
					AddProperty( loReturn.oPersona, "cEstado",     loPersona.Data.EstadoClave )

					If Substr( loPersona.Data.EstadoClave, 1, 5 ) = "ACTIV"
						loReturn.lCuit_OK = .T.
					Endif

					loImpuestos = Createobject( "Collection" )

					This.CrearTablaImpuestos()

					For Each lnImpuesto_Id In loPersona.Data.Impuestos

						loImpuesto = Createobject( "Empty" )
						AddProperty( loImpuesto, "nImpuesto_Id", lnImpuesto_Id )


						lcImpuesto_Desc = ""
						lcCommand = drComun 

						If Used( "Impuestos_Afip" ) And Seek( lnImpuesto_Id, "Impuestos_Afip", "Id" )
							lcImpuesto_Desc = Alltrim( Impuestos_Afip.Nombre )

						Else
							lcImpuesto_Desc = "NO DEFINIDO"

							Do Case
								Case Inlist( lnImpuesto_Id, 20, 21, 22, 23, 24 )
									lcImpuesto_Desc = "MONOTRIBUTO"

								Case Inlist( lnImpuesto_Id, 30 )
									lcImpuesto_Desc = "RESPONSABLE INSCRIPTO"

								Case Inlist( lnImpuesto_Id, 32 )
									lcImpuesto_Desc = "IVA EXENTO"

								Case Inlist( lnImpuesto_Id, 34 )
									lcImpuesto_Desc = "IVA NO ALCANZADO"

								Case Inlist( lnImpuesto_Id, 33 )
									lcImpuesto_Desc = "IVA RESPONSABLE NO INSCRIPTO"

							Endcase

						Endif

						AddProperty( loImpuesto, "cImpuesto_Desc", lcImpuesto_Desc )
						loImpuestos.Add( loImpuesto )

						loImpuesto = Null

					Endfor

					AddProperty( loReturn.oPersona, "oImpuestos", loImpuestos )

				Else
					loReturn.cErrorMessage = loPersona.Error.Mensaje

				Endif

			Else

				* RA 18/08/2017(11:13:10)
				* No se pudo conectar a la AFIP
				
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loReturn

	Endproc && xxxValidarCuit




	*
	*
	Procedure CrearTablaImpuestos(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If !FileExist( Alltrim( drComun ) + "Impuestos_Afip.dbf" ) ;
				Or !FileExist( Alltrim( drComun ) + "Impuestos_Afip.cdx" ) 
				
				loConsultasAFIP = Newobject( "oConsultasAFIP", "FW\Comunes\prg\ConsultasAFIP.prg" )
				loConsultasAFIP.lSilence = .T.
				loImpuestos = loConsultasAFIP.Impuestos()

				If loImpuestos.lStatus = .T. And loImpuestos.Success
					Create Cursor cImpuestos ( Id i, Nombre C(100) )

					For Each loImpuesto In loImpuestos.Data

						Insert Into cImpuestos (;
							Id, Nombre ) Values (;
							loImpuesto.idimpuesto,;
							loImpuesto.Descimpuesto )

					Endfor

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Select *
						From cImpuestos
						Order By Nombre
						Into Table '<<Alltrim( DrComun ) + "Impuestos_Afip">>'
					ENDTEXT

					&lcCommand
					lcCommand = ""
					Index On Id Tag Id

					Use In Select( "Impuestos_Afip" )

				Endif

			Endif

			Try

				If !Used( "Impuestos_Afip" ) 
					Use ( Alltrim( drComun ) + "Impuestos_Afip" ) Shared In 0
				EndIf

			Catch To oErr

			Finally

			Endtry


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && CrearTablaImpuestos



	*
	*
	Procedure ValidarParametros( nCuit As Integer ) As Void
		Local lcCommand As String,;
			lcMsg As String

		Local loReturn As Object

		Try

			lcCommand = ""
			loReturn = This.oReturn

			Do Case
				Case IsEmpty( nCuit )
					TEXT To lcMsg NoShow TextMerge Pretext 03
					No se recibió la CUIT
					ENDTEXT

					loReturn.cErrorMessage = lcMsg

				Case Vartype( nCuit ) # "N"
					If Inlist( Vartype( nCuit ), "C" )
						This.nCuit = Val( Strtran( nCuit, "-", "" ))

						loReturn.nCuit = This.nCuit
						loReturn.lStatus = .T.


					Else
						TEXT To lcMsg NoShow TextMerge Pretext 03
						La CUIT debe ser numérica

						( Se recibió [ <<Vartype( nCuit )>> ] )
						ENDTEXT

						loReturn.cErrorMessage = lcMsg

					Endif

				Case Vartype( nCuit ) = "N"
					This.nCuit = nCuit

					loReturn.nCuit = This.nCuit
					loReturn.lStatus = .T.


			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loReturn

	Endproc && ValidarParametros


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oValidarCuit
*!*
*!* ///////////////////////////////////////////////////////

