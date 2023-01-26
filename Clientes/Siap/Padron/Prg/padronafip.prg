*
* Consulta al Padrón de Contribuyentes
Procedure PadronAfip(  ) As Void;
		HELPSTRING "Consulta al Padrón de Contribuyentes"
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

Endproc && PadronAfip

*!* ///////////////////////////////////////////////////////
*!* Class.........: oWsPadron
*!* Description...:
*!* Date..........: Viernes 8 de Diciembre de 2017 (18:27:55)
*!*
*!*

Define Class oWsPadron As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg"

	#If .F.
		Local This As oWsPadron Of "Clientes\Siap\Padron\Prg\PadronAfip.prg"
	#Endif

	lSilence = .T.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="getpersona" type="method" display="GetPersona" />] + ;
		[</VFPData>]

	*
	*
	Procedure Inicializar(  ) As Void
		Try

			DoDefault()
			This.lSilence	= .T.

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Inicializar

	*
	* Inicializa el ocx
	Procedure Preparada() As Boolean;
			HELPSTRING "Inicializa el ocx"

		Local llOk As Boolean
		Local loFE As "WsAfipFe.factura"
		Local lcMsg As String,;
			lcWebService As String

		Local loForm As frmDisplayWindow Of Rutinas\Vcx\clipper2fox.Vcx

		Try

			This.ErrorStatus = 0
			llOk = .F.

			loFE = This.oFE

			llOk = loFE.Iniciar( This.nModo,;
				This.cCuitEmisor,;
				This.cCertificado,;
				This.cLicencia )

			If llOk
			
				Try

					* RA 15/07/2020(11:12:05)
					* [ Ultimo Numero Error: 3 ]
					* Anulada la solicitud: No se puede crear un canal seguro SSL/TLS.

					* Para corregir éste error es necesario instalar la version 92.20
					* Si el equipo no admite la instalación del runtime NET 4.6
					* es posible que ya no pueda conectar a los servidores de AFIP.

					* Se debe setear la propiedad TLS
					loFE.TLS = 12

				Catch To oErr

				Finally

				Endtry
			
				llOk = This.ObtenerTiquetAcceso()

			Else
				lcMsg = Iif( !Empty( loFE.UltimoMensajeError ), ;
					loFE.UltimoMensajeError, "Fallo al inicializar la Consulta al Padrón Afip" )


				If !This.lSilence
					Stop( lcMsg,;
						"Fallo al inicializar la Consulta al Padrón Afip" )
				Endif

				This.ErrorStatus = -1
				This.ErrorMessage = lcMsg

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loFE = Null
			Wait Clear
			loForm = Null

		Endtry

		Return llOk

	Endproc && Preparada

	Procedure ObtenerTiquetAcceso( ) As Boolean;
			HELPSTRING "Obtiene el tiquet de acceso"

		Local llOk As Boolean
		Local loFE As "WsAfipFe.factura"

		Try

			llOk = .F.
			loFE = This.oFE
			loFE.p1Version = 5

			If !loFE.p1TicketEsValido
				If FileExist( Addbs( This.DefaultFolder )+ This.CurrentTokenFileNameP1 )
					loFE.p1RestaurarTicketAcceso( Filetostr( Addbs( This.DefaultFolder )+ This.CurrentTokenFileNameP1 ) )
				Endif
			Endif

			If loFE.p1TicketEsValido
				llOk = .T.

			Else
				llOk = loFE.p1ObtenerTicketAcceso()
				If llOk
					Strtofile( loFE.p1GuardarTicketAcceso(), Addbs( This.DefaultFolder )+ This.CurrentTokenFileNameP1, 0 )

				Else
					If This.lSilence
						This.WSFEv1ErrorHandler()

					Else
						Stop( This.WSFEv1ErrorHandler(),;
							"Padrón AFIP. Fallo al obtener Ticket de Acceso" )
					Endif
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk


	Endproc && ObtenerTiquetAcceso


	*
	* Obtiene los datos del Padrón de Afip
	Procedure GetPersona( cCuit As String ) As Object;
			HELPSTRING "Obtiene los datos del Padrón de Afip"
		Local lcCommand As String,;
			lcErrorMessage As String,;
			lcPosicionIva As String

		Local loConsultasAFIP As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg",;
			loFE_Ocx As "WsAfipFe.factura",;
			loFE As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg",;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

		Local loPersona As Object,;
			loDatosGenerales As Object,;
			loDatosRegimenGeneral As Object,;
			loDatosMonotributo As Object,;
			loErrorConstancia As Object,;
			loErrorRegimenGeneral As Object,;
			loErrorMonotributo As Object,;
			loDomicilioFiscal As Object,;
			loDependencia As Object,;
			loActividad As Object,;
			loImpuesto As Object,;
			loImpuestoMonotributo As Object,;
			loCategoriaAutonomo As Object,;
			loRegimen As Object,;
			loMetaData As Object,;
			loActividadMonotributista As Object,;
			loCategoriaMonotributo As Object,;
			loComponente As Object,;
			loErrorRG As Object,;
			loErrorMT As Object

		Local loImpuestos As Collection,;
			loActividades As Collection,;
			loCategoriasAutonomo As Collection,;
			loRegimenes As Collection,;
			loImpuestosMonotributo As Collection,;
			loComponentesDeSociedad As Collection,;
			loErroresRegimenGeneral As Collection,;
			loErroresMonotributo As Collection

		Local llSilence As Boolean,;
			llUse_WS As Boolean
		Local i As Integer


		Try

			lcCommand = ""
			llUse_WS = .F.

			loFE_Ocx = This.oFE
			llUse_WS = Vartype( loFE_Ocx ) = "O"

			loPersona = Createobject( "Empty" )

			AddProperty( loPersona, "Success", .F. )
			AddProperty( loPersona, "lStatus", .F. )
			AddProperty( loPersona, "Error", Createobject( "Empty" ) )
			AddProperty( loPersona.Error, "Mensaje", "" )
			
			If llUse_WS

				loFE_Ocx.ArchivoXMLRecibido = Addbs( This.DefaultFolder ) ;
					+ "Consulta_Cuit_" + Alltrim( cCuit ) + "_WSFEv1_Recibido.xml"


				loFE_Ocx.ArchivoXMLEnviado = Addbs( This.DefaultFolder ) ;
					+ "Consulta_Cuit_" + Alltrim( cCuit ) + "_WSFEv1_Enviado.xml"


				Erase ( loFE_Ocx.ArchivoXMLEnviado )
				Erase ( loFE_Ocx.ArchivoXMLRecibido )
				
				Try

					If loFE_Ocx.p1GetPersona( cCuit ) ;
							And Empty( loFE_Ocx.UltimoMensajeError )

							loPersona.Success = .T.
							loPersona.lStatus = .T.

					Else
						loPersona.Error.Mensaje = loFE_Ocx.UltimoMensajeError

					Endif

				Catch To oErr
					If oErr.ErrorNo = 1426	&&  OLE error code 0x80020006: Unknown COM status code.
						llUse_WS = .F.
						
					Else
						Throw oErr

					Endif

				Finally

				EndTry
				
				If loPersona.Success

					lcErrorMessage = ""

					loDatosGenerales 		= Createobject( "Empty" )
					loDatosRegimenGeneral 	= Createobject( "Empty" )
					loDatosMonotributo  	= Createobject( "Empty" )
					loErrorConstancia 		= Createobject( "Empty" )
					loErrorRegimenGeneral 	= Createobject( "Empty" )
					loErrorMonotributo 		= Createobject( "Empty" )
					loMetaData   			= Createobject( "Empty" )

					loDomicilioFiscal 		= Createobject( "Empty" )
					loDependencia 			= Createobject( "Empty" )

					loActividadMonotributista 	= Createobject( "Empty" )
					loCategoriaMonotributo		= Createobject( "Empty" )


					loActividades 			= Createobject( "Collection" )
					loImpuestos 			= Createobject( "Collection" )
					loRegimenes 			= Createobject( "Collection" )
					loCategoriasAutonomo   	= Createobject( "Collection" )
					loImpuestosMonotributo 	= Createobject( "Collection" )
					loComponentesDeSociedad = Createobject( "Collection" )
					loErroresRegimenGeneral = Createobject( "Collection" )
					loErroresMonotributo 	= Createobject( "Collection" )

					AddProperty( loDatosRegimenGeneral, "Actividades", 			loActividades )
					AddProperty( loDatosRegimenGeneral, "Impuestos", 			loImpuestos )
					AddProperty( loDatosRegimenGeneral, "Regimenes", 			loRegimenes )
					AddProperty( loDatosRegimenGeneral, "CategoriasAutonomo", 	loCategoriasAutonomo )

					AddProperty( loDatosMonotributo, "ComponentesDeSociedad", 	loComponentesDeSociedad )
					AddProperty( loDatosMonotributo, "ActividadMonotributista", loActividadMonotributista )
					AddProperty( loDatosMonotributo, "CategoriaMonotributo", 	loCategoriaMonotributo )
					AddProperty( loDatosMonotributo, "Impuestos", 				loImpuestosMonotributo )


					AddProperty( loErrorRegimenGeneral, "ErroresRegimenGeneral", 	loErroresRegimenGeneral )
					AddProperty( loErrorMonotributo, 	"ErroresMonotributo", 		loErroresMonotributo )

					* Datos Generales
					AddProperty( loDatosGenerales, "CUIT", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.idPersona", "", 0, 0))

					* Valores: FISICA o JURIDICA
					AddProperty( loDatosGenerales, "TipoPersona", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.TipoPersona", "", 0, 0))

					* Valores: CUIT,CUIL o CDI
					AddProperty( loDatosGenerales, "TipoClave", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.TipoClave", "", 0, 0))

					* Valores: ACTIVO, INACTIVO
					AddProperty( loDatosGenerales, "EstadoClave", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.EstadoClave", "", 0, 0))

					AddProperty( loDatosGenerales, "Nombre", 				loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.Nombre", "", 0, 0))
					AddProperty( loDatosGenerales, "Apellido", 				loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.Apellido", "", 0, 0))
					AddProperty( loDatosGenerales, "RazonSocial", 			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.RazonSocial", "", 0, 0))
					AddProperty( loDatosGenerales, "MesCierre", 			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.MesCierre", "", 0, 0))
					AddProperty( loDatosGenerales, "FechaContratoSocial", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.FechaContratoSocial", "", 0, 0))


					* Domicilio
					AddProperty( loDomicilioFiscal, "Direccion", 			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.DomicilioFiscal.Direccion", "", 0, 0))
					AddProperty( loDomicilioFiscal, "CodPostal", 			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.DomicilioFiscal.CodPostal", "", 0, 0))
					AddProperty( loDomicilioFiscal, "DescripcionProvincia", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.DomicilioFiscal.DescripcionProvincia", "", 0, 0))
					AddProperty( loDomicilioFiscal, "idProvincia", 			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.DomicilioFiscal.idProvincia", "", 0, 0))
					AddProperty( loDomicilioFiscal, "Localidad", 			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.DomicilioFiscal.Localidad", "", 0, 0))
					AddProperty( loDomicilioFiscal, "TipoDomicilio", 		loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.DomicilioFiscal.TipoDomicilio", "", 0, 0))

					* Valores: FISCAL,LEGAL/REAL
					AddProperty( loDatosGenerales, "TipoDomicilio", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.TipoDomicilio", "", 0, 0))

					AddProperty( loDatosGenerales, "DomicilioFiscal", loDomicilioFiscal )


					* Dependencia
					AddProperty( loDependencia, "idDependencia", 			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.Dependencia.idDependencia", "", 0, 0))
					AddProperty( loDependencia, "DescripcionDependencia", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.Dependencia.descripcionDependencia", "", 0, 0))
					AddProperty( loDependencia, "Direccion", 				loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.Dependencia.Direccion", "", 0, 0))
					AddProperty( loDependencia, "CodPostal", 				loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.Dependencia.CodPostal", "", 0, 0))
					AddProperty( loDependencia, "DescripcionProvincia", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.Dependencia.DescripcionProvincia", "", 0, 0))
					AddProperty( loDependencia, "idProvincia", 				loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.Dependencia.idProvincia", "", 0, 0))
					AddProperty( loDependencia, "Localidad", 				loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosgenerales.Dependencia.Localidad", "", 0, 0))

					AddProperty( loDatosGenerales, "Dependencia", loDependencia )


					* Actividades

					i = 0
					Do While i < 50
						loActividad = Createobject( "Empty" )

						AddProperty( loActividad, "DescripcionActividad", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.actividad.descripcionActividad", "", i, 0 ))

						If Empty( loActividad.DescripcionActividad )
							Exit

						Else
							AddProperty( loActividad, "idActividad", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.actividad.idActividad", "", i, 0 ))
							AddProperty( loActividad, "nomenclador", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.actividad.nomenclador", "", i, 0 ))
							AddProperty( loActividad, "orden", 			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.actividad.orden", "", i, 0 ))
							AddProperty( loActividad, "periodo", 		loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.actividad.periodo", "", i, 0 ))

							loActividades.Add( loActividad )

						Endif

						i = i + 1

					Enddo


					* Impuestos
					i = 0
					Do While i < 50
						loImpuesto = Createobject( "Empty" )

						AddProperty( loImpuesto, "descripcionImpuesto", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.impuesto.descripcionImpuesto", "", i, 0 ))

						If Empty( loImpuesto.descripcionImpuesto )
							Exit

						Else
							AddProperty( loImpuesto, "idImpuesto", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.impuesto.idImpuesto", "", i, 0 ))
							AddProperty( loImpuesto, "periodo", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.impuesto.periodo", "", i, 0 ))

							loImpuestos.Add( loImpuesto )

						Endif

						i = i + 1

					Enddo

					* Regimenes
					i = 0
					Do While i < 50
						loRegimen = Createobject( "Empty" )

						AddProperty( loRegimen, "descripcionRegimen", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.Regimen.descripcionRegimen", "", i, 0 ))

						If Empty( loRegimen.descripcionRegimen )
							Exit

						Else
							AddProperty( loRegimen, "idRegimen", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.Regimen.idRegimen", "", i, 0 ))
							AddProperty( loRegimen, "IdImpuesto", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.Regimen.IdImpuesto", "", i, 0 ))
							AddProperty( loRegimen, "Periodo", 		loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.Regimen.Periodo", "", i, 0 ))
							AddProperty( loRegimen, "TipoRegimen", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.Regimen.TipoRegimen", "", i, 0 ))

							loRegimenes.Add( loRegimen )

						Endif

						i = i + 1

					Enddo

					* CategoriaAutonomo
					i = 0
					Do While i < 1
						loCategoriaAutonomo = Createobject( "Empty" )

						AddProperty( loCategoriaAutonomo, "descripcionCategoria", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.CategoriaAutonomo.descripcionCategoria", "", 0, 0 ))

						If Empty( loCategoriaAutonomo.descripcionCategoria )
							Exit

						Else
							AddProperty( loCategoriaAutonomo, "idCategoria", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.CategoriaAutonomo.idCategoria", "", 0, 0 ))
							AddProperty( loCategoriaAutonomo, "idImpuesto", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.CategoriaAutonomo.idImpuesto", "", 0, 0 ))
							AddProperty( loCategoriaAutonomo, "periodo", 		loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "datosRegimenGeneral.CategoriaAutonomo.periodo", "", 0, 0 ))

							loCategoriasAutonomo.Add( loCategoriaAutonomo )

							TEXT To lcMsg NoShow TextMerge Pretext 03
							<<i>>

							<<loCategoriaAutonomo.descripcionCategoria>>
							<<loCategoriaAutonomo.idCategoria>>
							<<loCategoriaAutonomo.idImpuesto>>
							<<loCategoriaAutonomo.periodo>>
							ENDTEXT

							*Messagebox( lcMsg )



						Endif

						i = i + 1

					Enddo


					* Datos Monotributo

					AddProperty( loActividadMonotributista, "DescripcionActividad",	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.actividadMonotributista.DescripcionActividad", "", 0, 0))
					AddProperty( loActividadMonotributista, "idActividad",			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.actividadMonotributista.DescripcionActividad", "", 0, 0))
					AddProperty( loActividadMonotributista, "Nomenclador",			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.actividadMonotributista.DescripcionActividad", "", 0, 0))
					AddProperty( loActividadMonotributista, "Orden",				loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.actividadMonotributista.DescripcionActividad", "", 0, 0))
					AddProperty( loActividadMonotributista, "Periodo",				loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.actividadMonotributista.DescripcionActividad", "", 0, 0))

					AddProperty( loCategoriaMonotributo, "DescripcionCategoria",	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.categoriaMonotributo.descripcionCategoria", "", 0, 0))
					AddProperty( loCategoriaMonotributo, "idCategoria", 			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.categoriaMonotributo.idCategoria", "", i, 0 ))
					AddProperty( loCategoriaMonotributo, "idImpuesto", 				loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.categoriaMonotributo.idImpuesto", "", i, 0 ))
					AddProperty( loCategoriaMonotributo, "Periodo", 				loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.categoriaMonotributo.periodo", "", i, 0 ))


					* Componentes De Sociedad
					i = 0
					Do While i < 50
						loComponente = Createobject( "Empty" )


						AddProperty( loComponente, "ApellidoPersonaAsociada", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.componenteDeSociedad.ApellidoPersonaAsociada", "", i, 0 ))

						If Empty( loComponente.ApellidoPersonaAsociada )
							Exit

						Else
							AddProperty( loComponente, "NombrePersonaAsociada",	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.componenteDeSociedad.NombrePersonaAsociada", "", i, 0 ))
							AddProperty( loComponente, "idPersonaAsociada", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.componenteDeSociedad.idPersonaAsociada", "", i, 0 ))
							AddProperty( loComponente, "ffRelacion", 			loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.componenteDeSociedad.ffRelacion", "", i, 0 ))
							AddProperty( loComponente, "TipoComponente", 		loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.componenteDeSociedad.TipoComponente", "", i, 0 ))

							loComponentesDeSociedad.Add( loComponente )


						Endif

						i = i + 1

					Enddo

					* Impuestos
					i = 0
					Do While i < 50
						loImpuesto = Createobject( "Empty" )

						AddProperty( loImpuesto, "descripcionImpuesto", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.impuesto.descripcionImpuesto", "", i, 0 ))

						If Empty( loImpuesto.descripcionImpuesto )
							Exit

						Else
							AddProperty( loImpuesto, "idImpuesto", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.impuesto.idImpuesto", "", i, 0 ))
							AddProperty( loImpuesto, "periodo", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "DatosMonotributo.impuesto.periodo", "", i, 0 ))

							loImpuestosMonotributo.Add( loImpuesto )

						Endif

						i = i + 1

					Enddo


					* Metadata
					AddProperty( loMetaData, "fechaHora", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "Metadata.fechaHora", "", 0, 0))
					AddProperty( loMetaData, "servidor", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "Metadata.servidor", "", 0, 0))
					

					* Errores
					* Error Constancia
					AddProperty( loErrorConstancia, "Cuit", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "ErrorConstancia.idPersona", "", 0, 0))
					AddProperty( loErrorConstancia, "Nombre", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "ErrorConstancia.Nombre", "", 0, 0))
					AddProperty( loErrorConstancia, "Apellido", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "ErrorConstancia.Apellido", "", 0, 0))
					AddProperty( loErrorConstancia, "Error", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "ErrorConstancia.Error", "", 0, 0))

					If !Empty( loErrorConstancia.Error )
						loPersona.Success = .F.
						TEXT To lcErrorMessage NoShow TextMerge Pretext 03 ADDITIVE 
						Cuit: <<Transform( loErrorConstancia.Cuit, "@R 99-99999999-9" )>>
						Apellido: <<loErrorConstancia.Apellido>>
						Nombre: <<loErrorConstancia.Nombre>>
						
						<<loErrorConstancia.Error>>

						ENDTEXT

					Endif

					* Error Regimen General
					AddProperty( loErrorRegimenGeneral, "Mensaje", 	loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "ErrorRegimenGeneral.Mensaje", "", 0, 0))

					i = 0
					Do While i < 50
						loErrorRG = Createobject( "Empty" )

						AddProperty( loErrorRG, "Error", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "ErrorRegimenGeneral.Error", "", i, 0 ))

						If Empty( loErrorRG.Error )
							Exit

						Else
							loErroresRegimenGeneral.Add( loErrorRG )
							loPersona.Success = .F.

							TEXT To lcErrorMessage NoShow TextMerge Pretext 03 ADDITIVE 
							<<loErrorRG.Error>>

							ENDTEXT


						Endif

						i = i + 1

					Enddo

					* Error Monotributo
					AddProperty( loErrorMonotributo, "Mensaje", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "ErrorMonotributo.Mensaje", "", 0, 0))

					i = 0
					Do While i < 50
						loErrorMT = Createobject( "Empty" )

						AddProperty( loErrorMT, "Error", loFE_Ocx.p1LeerPropiedad( "p1GetPersona", "ErrorMonotributo.Error", "", i, 0 ))

						If Empty( loErrorMT.Error )
							Exit

						Else
							loErroresMonotributo.Add( loErrorMT )
							loPersona.Success = .F.

							TEXT To lcErrorMessage NoShow TextMerge Pretext 03 ADDITIVE 
							<<loErrorMT.Error>>

							ENDTEXT


						Endif

						i = i + 1

					Enddo

					AddProperty( loPersona, "PosicionIva", "" )
					AddProperty( loPersona, "nInscripto", 0 )
					AddProperty( loPersona, "nImpuesto", 0 )
					AddProperty( loPersona, "cNombre", "" )

					If !Empty( loDatosGenerales.RazonSocial )
						loPersona.cNombre = loDatosGenerales.RazonSocial

					Else
						loPersona.cNombre = loDatosGenerales.Apellido + " " +  loDatosGenerales.Nombre

					Endif

					If loDatosMonotributo.Impuestos.Count > 0
						loImpuestos = loDatosMonotributo.Impuestos

					Else
						loImpuestos = loDatosRegimenGeneral.Impuestos

					Endif

					For Each loImpuesto In loImpuestos

						lnImpuesto 	= Val( loImpuesto.idImpuesto )
						llCondicion = Inlist( lnImpuesto, 20, 21, 22, 23, 24, 30, 32, 33, 34 )

						If llCondicion

							Do Case
								Case Inlist( lnImpuesto, 20, 21, 22, 23, 24 )
									loPersona.PosicionIva = "MONOTRIBUTO"
									loPersona.nInscripto = 7

								Case Inlist( lnImpuesto, 30 )
									loPersona.PosicionIva = "RESPONSABLE INSCRIPTO"
									loPersona.nInscripto = 1

								Case Inlist( lnImpuesto, 32 )
									loPersona.PosicionIva = "IVA EXENTO"
									loPersona.nInscripto = 5

								Case Inlist( lnImpuesto, 34 )
									loPersona.PosicionIva = "IVA NO ALCANZADO"
									loPersona.nInscripto = 3

								Case Inlist( lnImpuesto, 33 )
									loPersona.PosicionIva = "IVA RESPONSABLE NO INSCRIPTO"
									loPersona.nInscripto = 4

								Otherwise
									loPersona.PosicionIva = "NO INFORMADO"
									loPersona.nInscripto = 9

							Endcase

							loPersona.nImpuesto = lnImpuesto

							Exit

						Else
							loPersona.PosicionIva = "NO INFORMADO"
							loPersona.nInscripto = 9

						Endif

					Endfor

					AddProperty( loPersona, "oDatosGenerales", 		loDatosGenerales )
					AddProperty( loPersona, "oDatosRegimenGeneral", loDatosRegimenGeneral )
					AddProperty( loPersona, "oDatosMonotributo", 	loDatosMonotributo )
					AddProperty( loPersona, "oErrorConstancia", 	loErrorConstancia )
					AddProperty( loPersona, "oErrorRegimenGeneral", loErrorRegimenGeneral )
					AddProperty( loPersona, "oErrorMonotributo", 	loErrorMonotributo )
					AddProperty( loPersona, "oMetadata", 			loMetaData )
					
					If !loPersona.Success
						loPersona.Error.Mensaje = lcErrorMessage
					Endif

				Else
					loPersona.Error.Mensaje = Strtran( loPersona.Error.Mensaje, " id ", " CUIT ", -1, -1, 1 )
					loPersona.Error.Mensaje = Strtran( loPersona.Error.Mensaje, "id ", "CUIT ", -1, -1, 1 )
					loPersona.Error.Mensaje = Strtran( loPersona.Error.Mensaje, " id", " CUIT", -1, -1, 1 )
										
					StrToFile( loPersona.Error.Mensaje, loFE_Ocx.ArchivoXMLRecibido, 1 )

				Endif

			Else
				loGlobalSettings = NewGlobalSettings()
				loGlobalSettings.lConsultasAfip = .F.

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loConsultasAFIP 	= Null
			loFE_Ocx 			= Null
			loFE 				= Null
			loGlobalSettings 	= Null

		Endtry

		Return loPersona

	Endproc && GetPersona


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oWsPadron
*!*
*!* ///////////////////////////////////////////////////////

