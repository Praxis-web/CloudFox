#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\FE\Include\FE.h"


External Procedure "StrToI2of5.prg"

Local loFE As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg"

Try

	loFE = Newobject( "prxWSFEv1", "Tools\FE\Prg\prxWSFEv1.prg" )

	*!*		loFE.nModo          = FE_PRODUCCION 	&& FE_PRUEBA / FE_PRODUCCION
	*!*		loFE.cCuitEmisor 	= "30707992618"
	*!*		loFE.cCertificado 	= "V:\Clipper2Fox\Clientes\Polytemp\Fe\PolytempCBA.pfx"
	*!*		loFE.cLicencia 		= "V:\Clipper2Fox\Clientes\Polytemp\Fe\Licencia.lic"
	*!*		loFE.nPuntoDeVenta 	= 5

	Set Step On

	loFE.nModo          = FE_PRUEBA 	&& FE_PRUEBA / FE_PRODUCCION
	loFE.cCuitEmisor 	= "20119883610"
	loFE.cCertificado 	= "s:\Fe\praxis_2020.pfx"
	loFE.cLicencia 		= ""
	loFE.nPuntoDeVenta 	= 9

	If .F. && loFE.Test()
		Inform( loFE.ErrorMessage )
	Endif

	If loFE.Preparada()
		*!*			loFE.ExportarTabla( "comprobantes" )
		*!*			loFE.ExportarTabla( "conceptos" )
		*!*			loFE.ExportarTabla( "documentos" )
		*!*			loFE.ExportarTabla( "ivas" )
		*!*			loFE.ExportarTabla( "monedas" )
		loFE.ExportarTabla( "opcionales" )
		*!*			loFE.ExportarTabla( "tributos" )
	Endif

	If .F. && loFE.Preparada()

		loFE.oCliente 		= Null
		loFE.oComprobante 	= Null
		loFE.oIvas 			= Null
		loFE.oMoneda 		= Null

		* Ingresar Datos del Cliente
		loFE.oCliente.TipoDocumento	= FE_CUIT
		loFE.oCliente.NroDocumento 	= "30708855533"
		*loFE.oCliente.NroDocumento 	= "3070885553"

		* Ingresar Datos Comprobante
		loFE.oComprobante.Letra					= "C"
		loFE.oComprobante.Tipo 					= 7		&& ar7ven.Comp7

		loFE.oComprobante.CodigoAfip			= 0 && Opcional. Si NO es 0, prevalece sobre Letra y Tipo

		loFE.oComprobante.Concepto 				= FE_SERVICIOS  && FE_PRODUCTOS	/ FE_SERVICIOS / FE_PRODUCTOS_Y_SERVICIOS

		*!* Fecha del comprobante. Para un concepto de factura igual a 1,
		*	la fecha de emisión puede ser hasta 5 días posteriores a la de generación.
		*	Si el concepto es 2 o 3, puede ser hasta 10 días anteriores o posteriores a la fecha de generación.
		*	Al ser un dato opcional, si no se asigna fecha, por defecto se asignará la fecha del proceso.
		*	loFE.oComprobante.Fecha 				= Date() && Default: Date()

		*!*	Double. Importe total del comprobante,
		*	es igual a la suma de
		*			Importe Neto No Gravado (F1DetallImpTotalConc)
		*		+  	Importe Neto Gravado (F1DetalleImpNeto)
		*		+ 	Importe Exento (F1DetalleImpOpEx)
		*		+ 	Importes de Tributo (F1DetalleImpTrib)
		*		+ 	Importes de IVA (F1DetalleImpIVA).
		loFE.oComprobante.ImporteTotal 			= 184.05

		loFE.oComprobante.ImporteNetoNoGravado 	= 0
		loFE.oComprobante.ImporteNeto 			= 184.05
		loFE.oComprobante.ImporteExento 		= 0
		loFE.oComprobante.ImporteTotalTributos 	= 0
		loFE.oComprobante.ImporteTotalIva 		= 0

		*!*	Fecha de inicio del servicio a facturar.
		*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
		*	y debe ser igual o posterior a la fecha del proceso.
		*	loFE.oComprobante.FechaServicioDesde 	= Iif( Inlist( loFE.oComprobante.Concepto, 2, 3 ), Date(), Ctod("") )

		*!*	Fecha de fin del servicio a facturar.
		*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
		*	y debe ser igual o mayor a la fecha de inicio del servicio a facturar (F1DetalleFchServDesde).
		*	loFE.oComprobante.FechaServicioHasta 	= Iif( Inlist( loFE.oComprobante.Concepto, 2, 3 ), Date(), Ctod("") )

		*!*	Fecha de vencimiento del pago del servicio a facturar.
		*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
		*	y debe ser igual o posterior a la fecha del proceso.
		*	loFE.oComprobante.FechaVencimientoPago 	= Iif( Inlist( loFE.oComprobante.Concepto, 2, 3 ), Date(), Ctod("") )


		*	Moneda ( Default: PES )
		*   loFE.oMoneda.Id = "DOL"
		*   loFE.oMoneda.Cotizacion = 4.13

		*!*	#Define FE_Iva_Cero			3
		*!*	#Define FE_Iva_Reducido		4
		*!*	#Define FE_Iva_Normal		5
		*!*	#Define FE_Iva_Diferenciado	6

		If .F.

			loTributo = loFE.NewElement()

			loTributo.Id 			= FE_Tributo_Municipal
			loTributo.Descripcion 	= "Impuesto Municipal Matanza"
			loTributo.BaseImponible = 150
			loTributo.Alicuota 		= 5.2
			loTributo.Importe 		= 7.8
			loFE.oTributos.Add( loTributo )

			loIva = loFE.NewElement()

			loIva.Id 			= FE_Iva_Normal
			loIva.BaseImponible = 100
			loIva.Importe 		= 21
			loFE.oIvas.Add( loIva )


			loIva = loFE.NewElement()

			loIva.Id 			= FE_Iva_Reducido
			loIva.BaseImponible = 50
			loIva.Importe 		= 5.25
			loFE.oIvas.Add( loIva )

		Endif


		If loFE.Procesar()

			TEXT To lcMsg NoShow TextMerge Pretext 03
			<<Padr( "CAE" + ":", 30, " " )>> <<loFE.cCAE>>
			<<Padr( "Vencimiento CAE" + ":", 30, " " )>> <<loFE.dFechaVencimientoCAE>>
			<<Padr( "Fecha Comprobante" + ":", 30, " " )>> <<loFE.oComprobante.Fecha>>
			<<Padr( "Número" + ":", 30, " " )>> <<loFE.oComprobante.Numero>>
			ENDTEXT

			Inform( lcMsg, "Datos CAE" )


		Endif


	Endif

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError

Finally
	loFE = Null
	Inform( "Terminado" )

Endtry

Return

*/ --------------------------------------------------------

*!* ///////////////////////////////////////////////////////
*!* Class.........: prxWSFEv1
*!* ParentClass...: Custom
*!* BaseClass.....: Custom
*!* Description...: Definición de la clase Factura Electrónica
*!* Date..........: Miércoles 22 de Junio de 2011 (09:31:54)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*


Define Class prxWSFEv1 As Custom

	#If .F.
		Local This As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg"
	#Endif

	* Importe límite de comprobantes 'B' permitido sin nindicar el Nº de documento
	nTopeComprobantesB = 1000

	* Coleccion de Comprobantes Asociados
	oComprobantesAsociados = Null


	* Coleccion de Ivas
	oIvas = Null

	* Colección de Tributos
	oTributos = Null

	* Colección de Opcionales
	oOpcionales = Null

	* Contiene el mensaje de error devuelto por el Ocx
	ErrorMessage = ""

	* Numero del Error
	ErrorNo = 0

	* Indica si muestra mensages de error
	lSilence = .F.


	* Contiene un entero que permite determinar la gravedad del error y los pasos a seguir
	* 0: Todo Ok
	ErrorStatus = 0

	* Tabla de Tributos
	oTiposTributo = Null

	* Tabla de Opcionales
	oTiposOpcional = Null

	* Tabla de Documentos
	oTiposDocumento = Null

	* Tabla de Tipos de Iva
	oTiposIva = Null


	* Tabla de Tipos de Monedas
	oTiposMonedas = Null


	* Referencia a la Moneda de Emisión
	oMoneda = Null

	* Referencia al Comprobante
	oComprobante = Null



	* Referencia al Cliente
	oCliente = Null

	* 0: Prueba    1: Producción
	nModo = 0

	* Cuit emisor
	cCuitEmisor = ""


	* Nombre del archivo de certificado
	cCertificado = ""


	* Nombre del archivo de licencia
	cLicencia = ""

	* Nombre del archivo donse se guarda el Tiquet de Acceso
	CurrentTokenFileName = "WSFEv1Token.WSAA"

	* Nombre del archivo donse se guarda el Tiquet de Acceso
	CurrentTokenFileNameP1 = "WSFEv1TokenCuit.WSAA"


	* Colección de Tipos de Comprobantes
	oTiposComprobantes = Null

	* Colección de tipos de conceptos
	oTiposConceptos = Null


	*!*	 f1ParamGetTiposDoc	 FEParamGetTiposDoc    	Permite obtener los tipos de documentos aceptados en este WS.
	*!*	 f1ParamGetTiposIva	 FEParamGetTiposIVA    	Permite obtener los tipos de IVA en uso en este WS. Retorna el código y descripción.
	*!*	 f1ParamGetTiposMoneda	 FEParamGetTiposMonedas    	Permite obtener los tipos de monedas disponibles en este WS. Retorna el id y descripción.
	*!*	 f1ParamGetTiposOpcional	 FEParamGetTiposOpcional	Permite consultar los códigos y descripciones de los tipos de datos opcionales habilitados. Además otorga la fecha de vigencia de los mismos.
	*!*	 f1ParamGetTiposTributo	 FEParamGetTiposTributo    	Permite obtener los códigos, descripción, fecha de vigencia de los tributos disponibles para usar con el WS.
	*!*	 f1ParamGetPtosVenta	 FEParamGetPtosVenta	Permite consultar los puntos de venta para las autorizaciones CAE, CAEA gestionados por la cuit emisora.
	*!*	 f1ParamGetCotizacion	 FEParamGetCotizacion	Retorna la última cotización de la base de datos aduanera del código de la moneda ingresada.


	* Carpeta predeterminada
	DefaultFolder = ""


	* Punto de Venta
	nPuntoDeVenta = 0


	* Detalle concepto
	nDetalleConcepto = 1


	*!* Valor del CAE
	cCAE = ""

	*!* Identificador de la factura electrónica
	cIdentificador = ""

	*!* Objeto FE
	oFE = Null

	*!* Punto de Venta para la FE
	nPuntoDeVenta = 0

	*!* Resultado de cada proceso dentro de la emision de la factura electrónica
	lResultado = .F.

	*!* Numero Inicial
	nNumeroInicial = 0

	*!* Numero Final
	nNumeroFinal = 0

	*!* Código del comprobante de la factura electrónica
	nCodigo = 0

	* Fecha de Vencimiento del CAE
	dFechaVencimientoCAE = Ctod( "" )

	* Indica si en las facturas en moneda extranjera los importes
	* vienen expresados en PESOS (.T.) o en la moneda correspondiente (.F.)
	lImportesExpresadosSiempreEnPesos = .F.

	* Código de Barras
	cCodigoBarras = ""

	* Version del OCX
	cVersion = ""


	* Web Service al que se conecta
	cWS = "WSFEv1"

	* Factura de Credito Electronica ( Mi Pyme )
	lFCE = .F.

	* Motivo por el cual se emite una Nota de Credito FCE
	cFCERechazada = "N"

	* Si el tipo de comprobante que está autorizando es MiPyMEs (FCE), puede
	* identificar una o varias Referencias Comerciales según corresponda.
	* Informar bajo el código 23. Campo alfanumérico de 50 caracteres como máximo.
	cFCEReferencia = ""

	* Coleccion de Errores
	oErrores = Null
	* Colección de Observaciones
	oObservaciones = Null

	* Genera código QR
	lQR = .T.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lfce" type="property" display="lFCE" />] + ;
		[<memberdata name="cfcerechazada" type="property" display="cFCERechazada" />] + ;
		[<memberdata name="cfcereferencia" type="property" display="cFCEReferencia" />] + ;
		[<memberdata name="cuitvalido" type="method" display="CuitValido" />] + ;
		[<memberdata name="gettabla" type="method" display="GetTabla" />] + ;
		[<memberdata name="dataisvalid" type="method" display="DataIsValid" />] + ;
		[<memberdata name="inicializar" type="method" display="Inicializar" />] + ;
		[<memberdata name="consultarcomprobantefenix" type="method" display="ConsultarComprobanteFenix" />] + ;
		[<memberdata name="consultarcomprobante" type="method" display="ConsultarComprobante" />] + ;
		[<memberdata name="ccae" type="property" display="cCAE" />] + ;
		[<memberdata name="cidentificador" type="property" display="cIdentificador" />] + ;
		[<memberdata name="ofe" type="property" display="oFE" />] + ;
		[<memberdata name="npuntodeventa" type="property" display="nPuntoDeVenta" />] + ;
		[<memberdata name="lresultado" type="property" display="lResultado" />] + ;
		[<memberdata name="nnumeroinicial" type="property" display="nNumeroInicial" />] + ;
		[<memberdata name="nnumerofinal" type="property" display="nNumeroFinal" />] + ;
		[<memberdata name="registrar" type="method" display="Registrar" />] + ;
		[<memberdata name="ncodigo" type="property" display="nCodigo" />] + ;
		[<memberdata name="dfechavencimientocae" type="property" display="dFechaVencimientoCAE" />] + ;
		[<memberdata name="ndetalleconcepto" type="property" display="nDetalleConcepto" />] + ;
		[<memberdata name="ndetalleconcepto_assign" type="method" display="nDetalleConcepto_Assign" />] + ;
		[<memberdata name="npuntodeventa" type="property" display="nPuntoDeVenta" />] + ;
		[<memberdata name="npuntodeventa_access" type="method" display="nPuntoDeVenta_Access" />] + ;
		[<memberdata name="npuntodeventa_assign" type="method" display="nPuntoDeVenta_Assign" />] + ;
		[<memberdata name="exportartabla" type="method" display="ExportarTabla" />] + ;
		[<memberdata name="otiposcomprobantes" type="property" display="oTiposComprobantes" />] + ;
		[<memberdata name="defaultfolder" type="property" display="DefaultFolder" />] + ;
		[<memberdata name="otiposcomprobantes_access" type="method" display="oTiposComprobantes_Access" />] + ;
		[<memberdata name="obtenertiquetacceso" type="method" display="ObtenerTiquetAcceso" />] + ;
		[<memberdata name="currenttokenfilename" type="property" display="CurrentTokenFileName" />] + ;
		[<memberdata name="currenttokenfilenamep1" type="property" display="CurrentTokenFileNameP1" />] + ;
		[<memberdata name="nmodo" type="property" display="nModo" />] + ;
		[<memberdata name="ccuitemisor" type="property" display="cCuitEmisor" />] + ;
		[<memberdata name="ccertificado" type="property" display="cCertificado" />] + ;
		[<memberdata name="clicencia" type="property" display="cLicencia" />] + ;
		[<memberdata name="otiposconceptos" type="property" display="oTiposConceptos" />] + ;
		[<memberdata name="otiposconceptos_access" type="method" display="oTiposConceptos_Access" />] + ;
		[<memberdata name="preparada" type="method" display="Preparada" />] + ;
		[<memberdata name="ocliente" type="property" display="oCliente" />] + ;
		[<memberdata name="ocliente_access" type="method" display="oCliente_Access" />] + ;
		[<memberdata name="ocomprobante" type="property" display="oComprobante" />] + ;
		[<memberdata name="ocomprobante_access" type="method" display="oComprobante_Access" />] + ;
		[<memberdata name="omoneda" type="property" display="oMoneda" />] + ;
		[<memberdata name="omoneda_access" type="method" display="oMoneda_Access" />] + ;
		[<memberdata name="otiposmonedas" type="property" display="oTiposMonedas" />] + ;
		[<memberdata name="otiposmonedas_access" type="method" display="oTiposMonedas_Access" />] + ;
		[<memberdata name="otiposiva" type="property" display="oTiposIva" />] + ;
		[<memberdata name="otiposiva_access" type="method" display="oTiposIva_Access" />] + ;
		[<memberdata name="otiposdocumento" type="property" display="oTiposDocumento" />] + ;
		[<memberdata name="otiposdocumento_access" type="method" display="oTiposDocumento_Access" />] + ;
		[<memberdata name="otiposopcional" type="property" display="oTiposOpcional" />] + ;
		[<memberdata name="otiposopcional_access" type="method" display="oTiposOpcional_Access" />] + ;
		[<memberdata name="otipostributo" type="property" display="oTiposTributo" />] + ;
		[<memberdata name="otipostributo_access" type="method" display="oTiposTributo_Access" />] + ;
		[<memberdata name="procesar" type="method" display="Procesar" />] + ;
		[<memberdata name="wsfev1setup" type="method" display="WSFEv1Setup" />] + ;
		[<memberdata name="solicitarcae" type="method" display="SolicitarCAE" />] + ;
		[<memberdata name="wsfev1errorhandler" type="method" display="WSFEv1ErrorHandler" />] + ;
		[<memberdata name="errormessage" type="property" display="ErrorMessage" />] + ;
		[<memberdata name="errorno" type="property" display="ErrorNo" />] + ;
		[<memberdata name="lsilence" type="property" display="lSilence" />] + ;
		[<memberdata name="errorstatus" type="property" display="ErrorStatus" />] + ;
		[<memberdata name="getcodigocomprobante" type="method" display="GetCodigoComprobante" />] + ;
		[<memberdata name="oivas" type="property" display="oIvas" />] + ;
		[<memberdata name="oivas_access" type="method" display="oIvas_Access" />] + ;
		[<memberdata name="otributos" type="property" display="oTributos" />] + ;
		[<memberdata name="otributos_access" type="method" display="oTributos_Access" />] + ;
		[<memberdata name="oopcionales" type="property" display="oOpcionales" />] + ;
		[<memberdata name="oopcionales_access" type="method" display="oOpcionales_Access" />] + ;
		[<memberdata name="newelement" type="method" display="NewElement" />] + ;
		[<memberdata name="memorydump" type="method" display="MemoryDump" />] + ;
		[<memberdata name="test" type="method" display="Test" />] + ;
		[<memberdata name="ocomprobantesasociados" type="property" display="oComprobantesAsociados" />] + ;
		[<memberdata name="ocomprobantesasociados_access" type="method" display="oComprobantesAsociados_Access" />] + ;
		[<memberdata name="ntopecomprobantesb" type="property" display="nTopeComprobantesB" />] + ;
		[<memberdata name="verificarimportesenmonedaextranjera" type="method" display="VerificarImportesEnMonedaExtranjera" />] + ;
		[<memberdata name="limportesexpresadossiempreenpesos" type="property" display="lImportesExpresadosSiempreEnPesos" />] + ;
		[<memberdata name="ccodigobarras" type="property" display="cCodigoBarras" />] + ;
		[<memberdata name="ccodigobarras_access" type="method" display="cCodigoBarras_Access" />] + ;
		[<memberdata name="cversion" type="property" display="cVersion" />] + ;
		[<memberdata name="cversion_access" type="method" display="cVersion_Access" />] + ;
		[<memberdata name="cws" type="property" display="cWS" />] + ;
		[<memberdata name="llenarregistro" type="method" display="LlenarRegistro" />] + ;
		[<memberdata name="oerrores" type="property" display="oErrores" />] + ;
		[<memberdata name="oobservaciones" type="property" display="oObservaciones" />] + ;
		[<memberdata name="f1compultimoautorizado" type="method" display="F1CompUltimoAutorizado" />] + ;
		[<memberdata name="lqr" type="property" display="lQR" />] + ;
		[<memberdata name="getfilename" type="method" display="GetFileName" />] + ;
		[<memberdata name="getqrfilename" type="method" display="GetQrFileName" />] + ;
		[</VFPData>]


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

			Do Case
				Case This.cWS = "WSFEv1"
					lcWebService = "FACTURA ELECTRONICA"

				Case This.cWS = "WSFEX"
					lcWebService = "FACTURA ELECTRONICA DE EXPORTACION"

				Otherwise

			Endcase

			TEXT To lcMsg NoShow TextMerge Pretext 03
			Conectandose al Webservice de la Afip

			<<lcWebService>>
			Un momento por favor ....
			<<Iif( This.nModo = 0, "* * *   PRUEBA   * * *", "" )>>
			ENDTEXT

			If This.nModo = 0
				Try

					loForm = GetActiveForm()
					loForm.cntTitulo.lblObservaciones.Caption = ;
						loForm.cntTitulo.lblObservaciones.Caption + " ( *** FE PRUEBA *** )"

				Catch To oErr

				Finally

				Endtry

			Endif

			Wait Window Nowait lcMsg

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
					loFE.UltimoMensajeError, "Fallo al inicializar la Factura Electrónica" )


				If !This.lSilence
					Stop( lcMsg,;
						"Fallo al inicializar la Factura Electrónica" )
				Endif

				This.ErrorStatus = -1
				This.ErrorMessage = lcMsg

			Endif

			If llOk
				If This.lQR

					Try

						loFE.f1detalleqrformato = 6
						This.lQR = .T.

					Catch To oErr
						This.lQR = .F.

					Finally

					Endtry

				Endif

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



	*
	* Intenta conectarse con la Afip y obtener el CAE
	Procedure Procesar(  ) As Boolean;
			HELPSTRING "Intenta conectarse con la Afip y obtener el CAE"

		Local llOk As Boolean

		Try
			llOk = .F.
			This.ErrorMessage = ""
			This.ErrorStatus = 0

			If This.lImportesExpresadosSiempreEnPesos
				This.VerificarImportesEnMonedaExtranjera()
			Endif

			This.WSFEv1Setup()
			llOk = This.SolicitarCAE()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			llOk = .F.
			*Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && Procesar


	*
	*
	Procedure VerificarImportesEnMonedaExtranjera(  ) As Void

		Local lnCotizacion As Number
		Local i As Integer

		Try

			lnCotizacion = This.oMoneda.Cotizacion

			If lnCotizacion # 1

				* Pasar todos los importes expresados en PESOS a la moneda extranjera

				This.oComprobante.ImporteTotal 			= Round( This.oComprobante.ImporteTotal / lnCotizacion, 2 )
				This.oComprobante.ImporteNetoNoGravado 	= Round( This.oComprobante.ImporteNetoNoGravado / lnCotizacion, 2 )
				This.oComprobante.ImporteNeto 			= Round( This.oComprobante.ImporteNeto / lnCotizacion, 2 )
				This.oComprobante.ImporteExento 		= Round( This.oComprobante.ImporteExento / lnCotizacion, 2 )
				This.oComprobante.ImporteTotalTributos 	= Round( This.oComprobante.ImporteTotalTributos / lnCotizacion, 2 )
				This.oComprobante.ImporteTotalIva 		= Round( This.oComprobante.ImporteTotalIva / lnCotizacion, 2 )


				* Tributos

				For i = 1 To This.oTributos.Count
					loTributo = This.oTributos.Item( i )

					loTributo.BaseImponible	= Round( loTributo.BaseImponible / lnCotizacion, 2 )
					loTributo.Importe		= Round( loTributo.Importe / lnCotizacion, 2 )

				Endfor

				* Ivas

				For i = 1 To This.oIvas.Count
					loIva = This.oIvas.Item( i )

					loIva.BaseImponible	= Round( loIva.BaseImponible / lnCotizacion, 2 )
					loIva.Importe		= Round( loIva.Importe / lnCotizacion, 2 )

				Endfor

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && VerificarImportesEnMonedaExtranjera


	*
	*
	Procedure Inicializar(  ) As Void
		Try

			This.oCliente 				= Null
			This.oComprobante 			= Null
			This.oComprobantesAsociados = Null
			This.oIvas 					= Null
			This.oMoneda 				= Null
			This.oTributos 				= Null
			This.oOpcionales 			= Null
			This.lSilence 				= .F.
			This.nTopeComprobantesB 	= GetValue( "Tope0", "ar0Est", 5000 )
			This.lFCE 					= .F.

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Inicializar


	*
	* Devuelve el Último Número para el Comprobante
	Procedure F1CompUltimoAutorizado( nPuntoDeVenta As Integer, nCodigoComprobante As Integer ) As Void;
			HELPSTRING "Devuelve el Último Número para el Comprobante"
		Local lcCommand As String,;
			lcMsg As String
		Local lnUltimoNumero As Integer
		Local loFE As "WsAfipFe.factura"

		Try

			lcCommand = ""

			loFE = This.oFE

			lnUltimoNumero = loFE.F1CompUltimoAutorizado( nPuntoDeVenta, nCodigoComprobante )

			If Empty( lnUltimoNumero )
				TEXT To lcMsg NoShow TextMerge Pretext 03
			* * * A T E N C I O N * * *

			Verifique la correlatividad de la Numeración

			Es posible que haya fallado la conexión
			con AFIP
				ENDTEXT

				Warning( lcMsg, "Obteniendo Último Número" )

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loFE = Null

		Endtry

		Return lnUltimoNumero

	Endproc && F1CompUltimoAutorizado


	*
	*
	Procedure WSFEv1Setup(  ) As Void

		Local loFE As "WsAfipFe.factura"
		Local lnUltimoNumero As Integer,;
			lnNroDocumento As Integer,;
			lnCantidad As Integer
		Local lnImporte As Number,;
			lnCodigoAsociado As Integer

		Local lcCommand As String
		Local loCol As Collection

		Try

			lcCommand = ""

			loFE = This.oFE

			* Datos de Comprobante
			loFE.F1CabeceraCantReg 		= 1
			loFE.F1CabeceraPtoVta 		= This.nPuntoDeVenta
			loFE.F1CabeceraCbteTipo 	= This.GetCodigoComprobante()

			lnUltimoNumero 				= loFE.F1CompUltimoAutorizado( loFE.F1CabeceraPtoVta, loFE.F1CabeceraCbteTipo )

			lnNroDocumento				= Strtran( This.oCliente.NroDocumento, "-", "" )
			lnNroDocumento				= Strtran( lnNroDocumento, ".", "" )
			lnNroDocumento				= Strtran( lnNroDocumento, " ", "" )

			If Empty( lnNroDocumento )
				lnNroDocumento = "0"
				If This.oCliente.TipoDocumento	= FE_DNI
					This.oCliente.TipoDocumento	= FE_OTRO_DOCUMENTO
				Endif
			Endif

			loFE.f1Indice 				= 0
			loFE.F1DetalleConcepto 		= This.oComprobante.Concepto
			loFE.F1DetalleDocTipo 		= This.oCliente.TipoDocumento

			loFE.F1DetalleDocNro 		= lnNroDocumento

			loFE.F1DetalleCbteDesde 	= lnUltimoNumero + 1
			loFE.F1DetalleCbteHasta 	= loFE.F1DetalleCbteDesde
			loFE.F1DetalleCbteFch 		= Alltrim( Dtos( This.oComprobante.Fecha ))

			loFE.F1DetalleImpTotal 		= Round( Cast( This.oComprobante.ImporteTotal As Double ), 2 )
			loFE.F1DetalleImpTotalConc 	= Round( Cast( This.oComprobante.ImporteNetoNoGravado As Double ), 2 )
			loFE.F1DetalleImpNeto 		= Round( Cast( This.oComprobante.ImporteNeto As Double ), 2 )
			loFE.F1DetalleImpOpEx 		= Round( Cast( This.oComprobante.ImporteExento As Double ), 2 )
			loFE.F1DetalleImpTrib 		= Round( Cast( This.oComprobante.ImporteTotalTributos As Double ), 2 )
			loFE.F1DetalleImpIva 		= Round( Cast( This.oComprobante.ImporteTotalIva As Double ), 2 )

			* Concepto
			If Inlist( This.oComprobante.Concepto, FE_SERVICIOS, FE_PRODUCTOS_Y_SERVICIOS )
				*!*	Fecha de inicio del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o posterior a la fecha del proceso.
				If Empty( This.oComprobante.FechaServicioDesde )
					This.oComprobante.FechaServicioDesde = This.oComprobante.Fecha
				Endif

				*!*	Fecha de fin del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o mayor a la fecha de inicio del servicio a facturar (F1DetalleFchServDesde).
				If Empty( This.oComprobante.FechaServicioHasta )
					This.oComprobante.FechaServicioHasta = This.oComprobante.FechaServicioDesde
				Endif

				*!*	Fecha de vencimiento del pago del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o posterior a la fecha del proceso.
				If Empty( This.oComprobante.FechaVencimientoPago )
					This.oComprobante.FechaVencimientoPago = This.oComprobante.Fecha
				Endif

			Endif

			loFE.F1DetalleFchServDesde 	= Alltrim( Dtos( This.oComprobante.FechaServicioDesde ))
			loFE.F1DetalleFchServHasta 	= Alltrim( Dtos( This.oComprobante.FechaServicioHasta ))
			loFE.F1DetalleFchVtoPago 	= Alltrim( Dtos( This.oComprobante.FechaVencimientoPago ))

			loFE.F1DetalleMonId 		= This.oMoneda.Id
			loFE.F1DetalleMonCotiz 		= Cast( This.oMoneda.Cotizacion As Double )

			* Tributos
			loFE.F1DetalleTributoItemCantidad = This.oTributos.Count

			lnImporte = 0

			For i = 1 To loFE.F1DetalleTributoItemCantidad
				loTributo = This.oTributos.Item( i )

				loFE.f1IndiceItem 				= i - 1
				loFE.F1DetalleTributoId 		= loTributo.Id
				loFE.F1DetalleTributoDesc 		= loTributo.Descripcion
				loFE.F1DetalleTributoBaseImp 	= Round( Cast( loTributo.BaseImponible As Double ), 2 )
				loFE.F1DetalleTributoAlic 		= Cast( loTributo.Alicuota As Double )
				loFE.F1DetalleTributoImporte 	= Round( Cast( loTributo.Importe As Double ), 2 )

				lnImporte = lnImporte + loFE.F1DetalleTributoImporte

			Endfor

			loFE.F1DetalleImpTrib = Round( lnImporte, 2 )

			* Ivas
			If Empty( This.oIvas.Count ) ;
					And ( loFE.F1DetalleImpNeto > 0 ) ;
					And ( !Inlist( This.oComprobante.CodigoAfip,;
					FE_Factura_C,;
					FE_Nota_de_Debito_C,;
					FE_Nota_de_Credito_C,;
					FE_Factura_C 			+ 200,;
					FE_Nota_de_Debito_C 	+ 200,;
					FE_Nota_de_Credito_C 	+ 200,;
					FE_Recibo_C	) )

				* FE_Factura_C + 200: Factura de Crédito


				* RA 2012-12-19(14:17:03)
				* Para evitar error 10070
				* Si ImpNeto es mayor a 0 el objeto IVA es obligatorio.

				loIva = This.NewElement()

				loIva.Id 			= FE_Iva_Cero
				loIva.BaseImponible = loFE.F1DetalleImpNeto
				loIva.Importe 		= 0.00
				This.oIvas.Add( loIva )
			Endif

			loFE.F1DetalleIvaItemCantidad = This.oIvas.Count

			lnImporte = 0

			For i = 1 To loFE.F1DetalleIvaItemCantidad
				loIva = This.oIvas.Item( i )

				loFE.f1IndiceItem 			= i - 1
				loFE.F1DetalleIvaId 		= loIva.Id
				loFE.F1DetalleIvaBaseImp 	= Round( Cast( loIva.BaseImponible As Double ), 2 )
				loFE.F1DetalleIvaImporte 	= Round( Cast( loIva.Importe As Double ), 2 )

				lnImporte = lnImporte + loFE.F1DetalleIvaImporte

			Endfor

			loFE.F1DetalleImpIva = Round( lnImporte, 2 )

			*!*	[ Observacion N¦: 10153 ]
			*!*	Si es Factura de Credito, tipo de comprobante Debito o Credito,
			*!*	es oblitagorio informar Comprobantes Asociados.

			* Comprobante Asociado
			loFE.F1DetalleCbtesAsocItemCantidad = This.oComprobantesAsociados.Count

			For i = 1 To loFE.F1DetalleCbtesAsocItemCantidad
				* RA 31/10/2019(15:12:17)
				* Version wsAfipFe 58.40 o superior

				loComprobanteAsociado = This.oComprobantesAsociados.Item( i )

				loFE.f1IndiceItem 				= i - 1

				loFE.F1DetalleCbtesAsocNro 		= loComprobanteAsociado.Numero
				loFE.F1DetalleCbtesAsocPtoVta 	= loComprobanteAsociado.PuntoDeVenta
				loFE.F1DetalleCbtesAsocTipo 	= This.GetCodigoComprobante( loComprobanteAsociado )
				loFE.F1DetalleCbtesAsocCUIT 	= Val( Strtran( Transform( loComprobanteAsociado.CUIT ), "-", "" ))
				loFE.F1DetalleCbtesAsocFecha  	= Alltrim( Dtos( loComprobanteAsociado.Fecha ))

			Endfor

			If This.lFCE

				If Inlist( This.oComprobante.CodigoAfip,;
						FE_FCE_Factura_A,;
						FE_FCE_Factura_B,;
						FE_FCE_Factura_C )

					* Opcionales

					loCol = Createobject( "Collection" )

					loIte = Createobject( "Empty" )
					AddProperty( loIte, "F1DetalleOpcionalId", FE_CBU_EMISOR )
					AddProperty( loIte, "F1DetalleOpcionalValor", Substr( Strtran( GetValue( "CBU", "ar0Fel", "" ), "-", "" ), 1, 22 )) && "cbu del emisor donde al momento de pagar la factura se abonará el saldo en esa CBU "

					loCol.Add( loIte )


					loIte = Createobject( "Empty" )
					AddProperty( loIte, "F1DetalleOpcionalId", FE_ALIAS_EMISOR )
					AddProperty( loIte, "F1DetalleOpcionalValor", Alltrim( GetValue( "Alias_CBU", "ar0Fel", "" ))) && "alias del emisor"

					loCol.Add( loIte )

					If !Empty( GetValue( "SCA_ADC", "ar0Fel", Space( 3 ) ))

						* RA 06/02/2021(13:11:20)

						*!*	Para la modalidad de autorización CAE y CAEA, se
						*!*	adaptan los métodos públicos con el fin de incorporar
						*!*	mediante códigos Opcionales y solo para las facturas
						*!*	de crédito el identificar que representa si se transfiere
						*!*	al sistema de circulación abierta o al agente de
						*!*	depósito colectivo.
						*!*	Para CAE
						*!*	Se modifican los códigos 10169, 10170 y 10172
						*!*	Se dan de alta los códigos 10214, 10215 y 10216

						*!*	Si informa comprobante MiPyMEs (FCE) del tipo Factura,
						*!*	es obligatorio informar opcional por RG con ID 27 y su valor correspondiente.
						*!*	Valores esperados SCA = 'TRANSFERENCIA AL SISTEMA DE CIRCULACION ABIERTA'
						*!*	o ADC = 'AGENTE DE DEPOSITO COLECTIVO'


						loIte = Createobject( "Empty" )
						AddProperty( loIte, "F1DetalleOpcionalId", FE_SCA_ADC )
						AddProperty( loIte, "F1DetalleOpcionalValor", GetValue( "SCA_ADC", "ar0Fel", Space( 3 ) ) )

						loCol.Add( loIte )

					Endif

					If !Empty( This.cFCEReferencia )
						loIte = Createobject( "Empty" )
						AddProperty( loIte, "F1DetalleOpcionalId", FE_REFERENCIA )
						AddProperty( loIte, "F1DetalleOpcionalValor", Alltrim( This.cFCEReferencia ) )

						loCol.Add( loIte )

					Endif

					loFE.F1DetalleOpcionalItemCantidad = loCol.Count

					i = 0

					For Each loIte In loCol
						loFE.f1IndiceItem  			= i
						loFE.F1DetalleOpcionalId  	= loIte.F1DetalleOpcionalId
						loFE.F1DetalleOpcionalValor = loIte.F1DetalleOpcionalValor

						i = i + 1

					Endfor


				Else
					*!*	[ Observacion Nº: 10175 ]
					*!*	El campo FchVtoPago no debe informarse si NO es Factura de Credito.
					loFE.F1DetalleFchVtoPago	= ""


					* Opcionales

					loFE.F1DetalleOpcionalItemCantidad = 1

					loFE.f1IndiceItem 			= 0
					loFE.F1DetalleOpcionalId 	= FE_ANULACION
					loFE.F1DetalleOpcionalValor = This.cFCERechazada

				Endif

			Else

				If Inlist(This.oComprobante.CodigoAfip,;
						FE_Nota_de_Debito_A,;
						FE_Nota_de_Credito_A,;
						FE_Nota_de_Debito_B,;
						FE_Nota_de_Credito_B,;
						FE_Nota_de_Debito_C,;
						FE_Nota_de_Credito_C,;
						FE_Nota_de_Debito_M,;
						FE_Nota_de_Credito_M )



					If .F.
						* RA 05/04/2021(10:26:20)
						* No Funciona en producción
						* Esperar version superior a 94.80


						lcDesde 	= Alltrim( Dtos( GetDate( This.oComprobante.Fecha, GD_FIRST_CURRENT_MONTH )))
						lcHasta 	= Alltrim( Dtos( This.oComprobante.Fecha ))

						loFE.F1DetallePeriodoAsocFchDesde = lcDesde
						loFE.F1DetallePeriodoAsocFchHasta = lcHasta

					Else

						If Empty( This.oComprobantesAsociados.Count )
						
							Do Case
								Case Inlist(This.oComprobante.CodigoAfip,;
										FE_Nota_de_Debito_A,;
										FE_Nota_de_Credito_A )

									lnCodigoAsociado = FE_Factura_A

								Case Inlist(This.oComprobante.CodigoAfip,;
										FE_Nota_de_Debito_B,;
										FE_Nota_de_Credito_B )

									lnCodigoAsociado = FE_Factura_B

								Case Inlist(This.oComprobante.CodigoAfip,;
										FE_Nota_de_Debito_C,;
										FE_Nota_de_Credito_C )

									lnCodigoAsociado = FE_Factura_C

								Case Inlist(This.oComprobante.CodigoAfip,;
										FE_Nota_de_Debito_M,;
										FE_Nota_de_Credito_M )

									lnCodigoAsociado = FE_Factura_M

							Endcase

							* Comprobante Asociado
							loFE.F1DetalleCbtesAsocItemCantidad = 1
							loFE.f1IndiceItem 					= 0

							loFE.F1DetalleCbtesAsocNro 		= loFE.F1CompUltimoAutorizado( This.nPuntoDeVenta, lnCodigoAsociado )
							loFE.F1DetalleCbtesAsocPtoVta 	= This.nPuntoDeVenta
							loFE.F1DetalleCbtesAsocTipo 	= lnCodigoAsociado
							loFE.F1DetalleCbtesAsocCUIT 	= Padl( loFE.F1DetalleDocNro, 11, '1' )
							loFE.F1DetalleCbtesAsocFecha  	= Alltrim( Dtos( GetDate( This.oComprobante.Fecha, GD_FIRST_CURRENT_MONTH )))

						Endif
					Endif
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

	Endproc && WSFEv1Setup

	*
	*
	Procedure yyyWSFEv1Setup(  ) As Void

		Local loFE As "WsAfipFe.factura"
		Local lnUltimoNumero As Integer,;
			lnNroDocumento As Integer,;
			lnCantidad As Integer
		Local lnImporte As Number,;
			lnCodigoAsociado As Integer

		Local lcCommand As String
		Local loCol As Collection

		Try

			lcCommand = ""

			loFE = This.oFE

			* Datos de Comprobante
			loFE.F1CabeceraCantReg 		= 1
			loFE.F1CabeceraPtoVta 		= This.nPuntoDeVenta
			loFE.F1CabeceraCbteTipo 	= This.GetCodigoComprobante()

			lnUltimoNumero 				= loFE.F1CompUltimoAutorizado( loFE.F1CabeceraPtoVta, loFE.F1CabeceraCbteTipo )

			lnNroDocumento				= Strtran( This.oCliente.NroDocumento, "-", "" )
			lnNroDocumento				= Strtran( lnNroDocumento, ".", "" )
			lnNroDocumento				= Strtran( lnNroDocumento, " ", "" )

			If Empty( lnNroDocumento )
				lnNroDocumento = "0"
				If This.oCliente.TipoDocumento	= FE_DNI
					This.oCliente.TipoDocumento	= FE_OTRO_DOCUMENTO
				Endif
			Endif

			loFE.f1Indice 				= 0
			loFE.F1DetalleConcepto 		= This.oComprobante.Concepto
			loFE.F1DetalleDocTipo 		= This.oCliente.TipoDocumento

			loFE.F1DetalleDocNro 		= lnNroDocumento

			loFE.F1DetalleCbteDesde 	= lnUltimoNumero + 1
			loFE.F1DetalleCbteHasta 	= loFE.F1DetalleCbteDesde
			loFE.F1DetalleCbteFch 		= Alltrim( Dtos( This.oComprobante.Fecha ))

			loFE.F1DetalleImpTotal 		= Round( Cast( This.oComprobante.ImporteTotal As Double ), 2 )
			loFE.F1DetalleImpTotalConc 	= Round( Cast( This.oComprobante.ImporteNetoNoGravado As Double ), 2 )
			loFE.F1DetalleImpNeto 		= Round( Cast( This.oComprobante.ImporteNeto As Double ), 2 )
			loFE.F1DetalleImpOpEx 		= Round( Cast( This.oComprobante.ImporteExento As Double ), 2 )
			loFE.F1DetalleImpTrib 		= Round( Cast( This.oComprobante.ImporteTotalTributos As Double ), 2 )
			loFE.F1DetalleImpIva 		= Round( Cast( This.oComprobante.ImporteTotalIva As Double ), 2 )

			* Concepto
			If Inlist( This.oComprobante.Concepto, FE_SERVICIOS, FE_PRODUCTOS_Y_SERVICIOS )
				*!*	Fecha de inicio del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o posterior a la fecha del proceso.
				If Empty( This.oComprobante.FechaServicioDesde )
					This.oComprobante.FechaServicioDesde = This.oComprobante.Fecha
				Endif

				*!*	Fecha de fin del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o mayor a la fecha de inicio del servicio a facturar (F1DetalleFchServDesde).
				If Empty( This.oComprobante.FechaServicioHasta )
					This.oComprobante.FechaServicioHasta = This.oComprobante.FechaServicioDesde
				Endif

				*!*	Fecha de vencimiento del pago del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o posterior a la fecha del proceso.
				If Empty( This.oComprobante.FechaVencimientoPago )
					This.oComprobante.FechaVencimientoPago = This.oComprobante.Fecha
				Endif

			Endif

			loFE.F1DetalleFchServDesde 	= Alltrim( Dtos( This.oComprobante.FechaServicioDesde ))
			loFE.F1DetalleFchServHasta 	= Alltrim( Dtos( This.oComprobante.FechaServicioHasta ))
			loFE.F1DetalleFchVtoPago 	= Alltrim( Dtos( This.oComprobante.FechaVencimientoPago ))

			loFE.F1DetalleMonId 		= This.oMoneda.Id
			loFE.F1DetalleMonCotiz 		= Cast( This.oMoneda.Cotizacion As Double )

			* Tributos
			loFE.F1DetalleTributoItemCantidad = This.oTributos.Count

			lnImporte = 0

			For i = 1 To loFE.F1DetalleTributoItemCantidad
				loTributo = This.oTributos.Item( i )

				loFE.f1IndiceItem 				= i - 1
				loFE.F1DetalleTributoId 		= loTributo.Id
				loFE.F1DetalleTributoDesc 		= loTributo.Descripcion
				loFE.F1DetalleTributoBaseImp 	= Round( Cast( loTributo.BaseImponible As Double ), 2 )
				loFE.F1DetalleTributoAlic 		= Cast( loTributo.Alicuota As Double )
				loFE.F1DetalleTributoImporte 	= Round( Cast( loTributo.Importe As Double ), 2 )

				lnImporte = lnImporte + loFE.F1DetalleTributoImporte

			Endfor

			loFE.F1DetalleImpTrib = Round( lnImporte, 2 )

			* Ivas
			If Empty( This.oIvas.Count ) ;
					And ( loFE.F1DetalleImpNeto > 0 ) ;
					And ( !Inlist( This.oComprobante.CodigoAfip,;
					FE_Factura_C,;
					FE_Nota_de_Debito_C,;
					FE_Nota_de_Credito_C,;
					FE_Factura_C 			+ 200,;
					FE_Nota_de_Debito_C 	+ 200,;
					FE_Nota_de_Credito_C 	+ 200,;
					FE_Recibo_C	) )

				* FE_Factura_C + 200: Factura de Crédito


				* RA 2012-12-19(14:17:03)
				* Para evitar error 10070
				* Si ImpNeto es mayor a 0 el objeto IVA es obligatorio.

				loIva = This.NewElement()

				loIva.Id 			= FE_Iva_Cero
				loIva.BaseImponible = loFE.F1DetalleImpNeto
				loIva.Importe 		= 0.00
				This.oIvas.Add( loIva )
			Endif

			loFE.F1DetalleIvaItemCantidad = This.oIvas.Count

			lnImporte = 0

			For i = 1 To loFE.F1DetalleIvaItemCantidad
				loIva = This.oIvas.Item( i )

				loFE.f1IndiceItem 			= i - 1
				loFE.F1DetalleIvaId 		= loIva.Id
				loFE.F1DetalleIvaBaseImp 	= Round( Cast( loIva.BaseImponible As Double ), 2 )
				loFE.F1DetalleIvaImporte 	= Round( Cast( loIva.Importe As Double ), 2 )

				lnImporte = lnImporte + loFE.F1DetalleIvaImporte

			Endfor

			loFE.F1DetalleImpIva = Round( lnImporte, 2 )

			*!*	[ Observacion N¦: 10153 ]
			*!*	Si es Factura de Credito, tipo de comprobante Debito o Credito,
			*!*	es oblitagorio informar Comprobantes Asociados.

			* Comprobante Asociado
			loFE.F1DetalleCbtesAsocItemCantidad = This.oComprobantesAsociados.Count

			For i = 1 To loFE.F1DetalleCbtesAsocItemCantidad
				* RA 31/10/2019(15:12:17)
				* Version wsAfipFe 58.40 o superior

				loComprobanteAsociado = This.oComprobantesAsociados.Item( i )

				loFE.f1IndiceItem 				= i - 1

				loFE.F1DetalleCbtesAsocNro 		= loComprobanteAsociado.Numero
				loFE.F1DetalleCbtesAsocPtoVta 	= loComprobanteAsociado.PuntoDeVenta
				loFE.F1DetalleCbtesAsocTipo 	= This.GetCodigoComprobante( loComprobanteAsociado )
				loFE.F1DetalleCbtesAsocCUIT 	= Val( Strtran( Transform( loComprobanteAsociado.CUIT ), "-", "" ))
				loFE.F1DetalleCbtesAsocFecha  	= Alltrim( Dtos( loComprobanteAsociado.Fecha ))

			Endfor

			If This.lFCE

				If Inlist( This.oComprobante.CodigoAfip,;
						FE_FCE_Factura_A,;
						FE_FCE_Factura_B,;
						FE_FCE_Factura_C )

					* Opcionales

					loCol = Createobject( "Collection" )

					loIte = Createobject( "Empty" )
					AddProperty( loIte, "F1DetalleOpcionalId", FE_CBU_EMISOR )
					AddProperty( loIte, "F1DetalleOpcionalValor", Substr( Strtran( GetValue( "CBU", "ar0Fel", "" ), "-", "" ), 1, 22 )) && "cbu del emisor donde al momento de pagar la factura se abonará el saldo en esa CBU "

					loCol.Add( loIte )


					loIte = Createobject( "Empty" )
					AddProperty( loIte, "F1DetalleOpcionalId", FE_ALIAS_EMISOR )
					AddProperty( loIte, "F1DetalleOpcionalValor", Alltrim( GetValue( "Alias_CBU", "ar0Fel", "" ))) && "alias del emisor"

					loCol.Add( loIte )

					If !Empty( GetValue( "SCA_ADC", "ar0Fel", Space( 3 ) ))

						* RA 06/02/2021(13:11:20)

						*!*	Para la modalidad de autorización CAE y CAEA, se
						*!*	adaptan los métodos públicos con el fin de incorporar
						*!*	mediante códigos Opcionales y solo para las facturas
						*!*	de crédito el identificar que representa si se transfiere
						*!*	al sistema de circulación abierta o al agente de
						*!*	depósito colectivo.
						*!*	Para CAE
						*!*	Se modifican los códigos 10169, 10170 y 10172
						*!*	Se dan de alta los códigos 10214, 10215 y 10216

						*!*	Si informa comprobante MiPyMEs (FCE) del tipo Factura,
						*!*	es obligatorio informar opcional por RG con ID 27 y su valor correspondiente.
						*!*	Valores esperados SCA = 'TRANSFERENCIA AL SISTEMA DE CIRCULACION ABIERTA'
						*!*	o ADC = 'AGENTE DE DEPOSITO COLECTIVO'


						loIte = Createobject( "Empty" )
						AddProperty( loIte, "F1DetalleOpcionalId", FE_SCA_ADC )
						AddProperty( loIte, "F1DetalleOpcionalValor", GetValue( "SCA_ADC", "ar0Fel", Space( 3 ) ) )

						loCol.Add( loIte )

					Endif

					If !Empty( This.cFCEReferencia )
						loIte = Createobject( "Empty" )
						AddProperty( loIte, "F1DetalleOpcionalId", FE_REFERENCIA )
						AddProperty( loIte, "F1DetalleOpcionalValor", Alltrim( This.cFCEReferencia ) )

						loCol.Add( loIte )

					Endif

					loFE.F1DetalleOpcionalItemCantidad = loCol.Count

					i = 0

					For Each loIte In loCol
						loFE.f1IndiceItem  			= i
						loFE.F1DetalleOpcionalId  	= loIte.F1DetalleOpcionalId
						loFE.F1DetalleOpcionalValor = loIte.F1DetalleOpcionalValor

						i = i + 1

					Endfor


				Else
					*!*	[ Observacion Nº: 10175 ]
					*!*	El campo FchVtoPago no debe informarse si NO es Factura de Credito.
					loFE.F1DetalleFchVtoPago	= ""


					* Opcionales

					loFE.F1DetalleOpcionalItemCantidad = 1

					loFE.f1IndiceItem 			= 0
					loFE.F1DetalleOpcionalId 	= FE_ANULACION
					loFE.F1DetalleOpcionalValor = This.cFCERechazada

				Endif

			Else

				If Inlist(This.oComprobante.CodigoAfip,;
						FE_Nota_de_Debito_A,;
						FE_Nota_de_Credito_A,;
						FE_Nota_de_Debito_B,;
						FE_Nota_de_Credito_B,;
						FE_Nota_de_Debito_C,;
						FE_Nota_de_Credito_C,;
						FE_Nota_de_Debito_M,;
						FE_Nota_de_Credito_M )

					Try

						lcDesde 	= Alltrim( Dtos( GetDate( This.oComprobante.Fecha, GD_FIRST_CURRENT_MONTH )))
						lcHasta 	= Alltrim( Dtos( This.oComprobante.Fecha ))

						loFE.F1DetallePeriodoAsocFchDesde = lcDesde
						loFE.F1DetallePeriodoAsocFchHasta = lcHasta

					Catch To oErr

						Do Case
							Case Inlist(This.oComprobante.CodigoAfip,;
									FE_Nota_de_Debito_A,;
									FE_Nota_de_Credito_A )

								lnCodigoAsociado = FE_Factura_A

							Case Inlist(This.oComprobante.CodigoAfip,;
									FE_Nota_de_Debito_B,;
									FE_Nota_de_Credito_B )

								lnCodigoAsociado = FE_Factura_B

							Case Inlist(This.oComprobante.CodigoAfip,;
									FE_Nota_de_Debito_C,;
									FE_Nota_de_Credito_C )

								lnCodigoAsociado = FE_Factura_C

							Case Inlist(This.oComprobante.CodigoAfip,;
									FE_Nota_de_Debito_M,;
									FE_Nota_de_Credito_M )

								lnCodigoAsociado = FE_Factura_M

						Endcase

						WNUME = loFE.F1CompUltimoAutorizado( This.nPuntoDeVenta, lnCodigoAsociado )




					Finally

					Endtry

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

	Endproc && yyyWSFEv1Setup

	*
	*
	Procedure xxxWSFEv1Setup(  ) As Void

		Local loFE As "WsAfipFe.factura"
		Local lnUltimoNumero As Integer,;
			lnNroDocumento As Integer,;
			lnCantidad As Integer
		Local lnImporte As Number

		Local lcCommand As String

		Try

			lcCommand = ""

			loFE = This.oFE

			* Datos de Comprobante
			loFE.F1CabeceraCantReg 		= 1
			loFE.F1CabeceraPtoVta 		= This.nPuntoDeVenta
			loFE.F1CabeceraCbteTipo 	= This.GetCodigoComprobante()

			lnUltimoNumero 				= loFE.F1CompUltimoAutorizado( loFE.F1CabeceraPtoVta, loFE.F1CabeceraCbteTipo )

			lnNroDocumento				= Strtran( This.oCliente.NroDocumento, "-", "" )
			lnNroDocumento				= Strtran( lnNroDocumento, ".", "" )
			lnNroDocumento				= Strtran( lnNroDocumento, " ", "" )

			If Empty( lnNroDocumento )
				lnNroDocumento = "0"
				If This.oCliente.TipoDocumento	= FE_DNI
					This.oCliente.TipoDocumento	= FE_OTRO_DOCUMENTO
				Endif
			Endif

			loFE.f1Indice 				= 0
			loFE.F1DetalleConcepto 		= This.oComprobante.Concepto
			loFE.F1DetalleDocTipo 		= This.oCliente.TipoDocumento

			loFE.F1DetalleDocNro 		= lnNroDocumento

			loFE.F1DetalleCbteDesde 	= lnUltimoNumero + 1
			loFE.F1DetalleCbteHasta 	= loFE.F1DetalleCbteDesde
			loFE.F1DetalleCbteFch 		= Alltrim( Dtos( This.oComprobante.Fecha ))

			loFE.F1DetalleImpTotal 		= Round( Cast( This.oComprobante.ImporteTotal As Double ), 2 )
			loFE.F1DetalleImpTotalConc 	= Round( Cast( This.oComprobante.ImporteNetoNoGravado As Double ), 2 )
			loFE.F1DetalleImpNeto 		= Round( Cast( This.oComprobante.ImporteNeto As Double ), 2 )
			loFE.F1DetalleImpOpEx 		= Round( Cast( This.oComprobante.ImporteExento As Double ), 2 )
			loFE.F1DetalleImpTrib 		= Round( Cast( This.oComprobante.ImporteTotalTributos As Double ), 2 )
			loFE.F1DetalleImpIva 		= Round( Cast( This.oComprobante.ImporteTotalIva As Double ), 2 )

			* Concepto
			If Inlist( This.oComprobante.Concepto, FE_SERVICIOS, FE_PRODUCTOS_Y_SERVICIOS )
				*!*	Fecha de inicio del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o posterior a la fecha del proceso.
				If Empty( This.oComprobante.FechaServicioDesde )
					This.oComprobante.FechaServicioDesde = This.oComprobante.Fecha
				Endif

				*!*	Fecha de fin del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o mayor a la fecha de inicio del servicio a facturar (F1DetalleFchServDesde).
				If Empty( This.oComprobante.FechaServicioHasta )
					This.oComprobante.FechaServicioHasta = This.oComprobante.FechaServicioDesde
				Endif

				*!*	Fecha de vencimiento del pago del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o posterior a la fecha del proceso.
				If Empty( This.oComprobante.FechaVencimientoPago )
					This.oComprobante.FechaVencimientoPago = This.oComprobante.Fecha
				Endif

			Endif

			loFE.F1DetalleFchServDesde 	= Alltrim( Dtos( This.oComprobante.FechaServicioDesde ))
			loFE.F1DetalleFchServHasta 	= Alltrim( Dtos( This.oComprobante.FechaServicioHasta ))
			loFE.F1DetalleFchVtoPago 	= Alltrim( Dtos( This.oComprobante.FechaVencimientoPago ))

			loFE.F1DetalleMonId 		= This.oMoneda.Id
			loFE.F1DetalleMonCotiz 		= Cast( This.oMoneda.Cotizacion As Double )

			* Tributos
			loFE.F1DetalleTributoItemCantidad = This.oTributos.Count

			lnImporte = 0

			For i = 1 To loFE.F1DetalleTributoItemCantidad
				loTributo = This.oTributos.Item( i )

				loFE.f1IndiceItem 				= i - 1
				loFE.F1DetalleTributoId 		= loTributo.Id
				loFE.F1DetalleTributoDesc 		= loTributo.Descripcion
				loFE.F1DetalleTributoBaseImp 	= Round( Cast( loTributo.BaseImponible As Double ), 2 )
				loFE.F1DetalleTributoAlic 		= Cast( loTributo.Alicuota As Double )
				loFE.F1DetalleTributoImporte 	= Round( Cast( loTributo.Importe As Double ), 2 )

				lnImporte = lnImporte + loFE.F1DetalleTributoImporte

			Endfor

			loFE.F1DetalleImpTrib = Round( lnImporte, 2 )

			* Ivas
			If Empty( This.oIvas.Count ) ;
					And ( loFE.F1DetalleImpNeto > 0 ) ;
					And ( !Inlist( This.oComprobante.CodigoAfip,;
					FE_Factura_C,;
					FE_Nota_de_Debito_C,;
					FE_Nota_de_Credito_C,;
					FE_Factura_C 			+ 200,;
					FE_Nota_de_Debito_C 	+ 200,;
					FE_Nota_de_Credito_C 	+ 200,;
					FE_Recibo_C	) )

				* FE_Factura_C + 200: Factura de Crédito


				* RA 2012-12-19(14:17:03)
				* Para evitar error 10070
				* Si ImpNeto es mayor a 0 el objeto IVA es obligatorio.

				loIva = This.NewElement()

				loIva.Id 			= FE_Iva_Cero
				loIva.BaseImponible = loFE.F1DetalleImpNeto
				loIva.Importe 		= 0.00
				This.oIvas.Add( loIva )
			Endif

			loFE.F1DetalleIvaItemCantidad = This.oIvas.Count

			lnImporte = 0

			For i = 1 To loFE.F1DetalleIvaItemCantidad
				loIva = This.oIvas.Item( i )

				loFE.f1IndiceItem 			= i - 1
				loFE.F1DetalleIvaId 		= loIva.Id
				loFE.F1DetalleIvaBaseImp 	= Round( Cast( loIva.BaseImponible As Double ), 2 )
				loFE.F1DetalleIvaImporte 	= Round( Cast( loIva.Importe As Double ), 2 )

				lnImporte = lnImporte + loFE.F1DetalleIvaImporte

			Endfor

			loFE.F1DetalleImpIva = Round( lnImporte, 2 )

			*!*	[ Observacion N¦: 10153 ]
			*!*	Si es Factura de Credito, tipo de comprobante Debito o Credito,
			*!*	es oblitagorio informar Comprobantes Asociados.

			* Comprobante Asociado
			loFE.F1DetalleCbtesAsocItemCantidad = This.oComprobantesAsociados.Count

			For i = 1 To loFE.F1DetalleCbtesAsocItemCantidad
				* RA 31/10/2019(15:12:17)
				* Version wsAfipFe 58.40 o superior

				loComprobanteAsociado = This.oComprobantesAsociados.Item( i )

				loFE.f1IndiceItem 				= i - 1

				loFE.F1DetalleCbtesAsocNro 		= loComprobanteAsociado.Numero
				loFE.F1DetalleCbtesAsocPtoVta 	= loComprobanteAsociado.PuntoDeVenta
				loFE.F1DetalleCbtesAsocTipo 	= This.GetCodigoComprobante( loComprobanteAsociado )
				loFE.F1DetalleCbtesAsocCUIT 	= Val( Strtran( Transform( loComprobanteAsociado.CUIT ), "-", "" ))
				loFE.F1DetalleCbtesAsocFecha  	= Alltrim( Dtos( loComprobanteAsociado.Fecha ))

			Endfor

			If This.lFCE

				If Inlist( This.oComprobante.CodigoAfip,;
						FE_FCE_Factura_A,;
						FE_FCE_Factura_B,;
						FE_FCE_Factura_C )

					* Opcionales

					If Empty( This.cFCEReferencia )
						lnCantidad = 3

					Else
						lnCantidad = 4

					Endif

					loFE.F1DetalleOpcionalItemCantidad = lnCantidad

					loFE.f1IndiceItem 			= 0
					loFE.F1DetalleOpcionalId 	= FE_CBU_EMISOR
					loFE.F1DetalleOpcionalValor = Substr( Strtran( GetValue( "CBU", "ar0Fel", "" ), "-", "" ), 1, 22 ) && "cbu del emisor donde al momento de pagar la factura se abonará el saldo en esa CBU "

					loFE.f1IndiceItem  			= 1
					loFE.F1DetalleOpcionalId  	= FE_ALIAS_EMISOR
					loFE.F1DetalleOpcionalValor = Alltrim( GetValue( "Alias_CBU", "ar0Fel", "" )) && "alias del emisor"

					* RA 06/02/2021(13:11:20)

					*!*	Para la modalidad de autorización CAE y CAEA, se
					*!*	adaptan los métodos públicos con el fin de incorporar
					*!*	mediante códigos Opcionales y solo para las facturas
					*!*	de crédito el identificar que representa si se transfiere
					*!*	al sistema de circulación abierta o al agente de
					*!*	depósito colectivo.
					*!*	Para CAE
					*!*	Se modifican los códigos 10169, 10170 y 10172
					*!*	Se dan de alta los códigos 10214, 10215 y 10216

					*!*	Si informa comprobante MiPyMEs (FCE) del tipo Factura,
					*!*	es obligatorio informar opcional por RG con ID 27 y su valor correspondiente.
					*!*	Valores esperados SCA = 'TRANSFERENCIA AL SISTEMA DE CIRCULACION ABIERTA'
					*!*	o ADC = 'AGENTE DE DEPOSITO COLECTIVO'

					loFE.f1IndiceItem  			= 2
					loFE.F1DetalleOpcionalId  	= FE_SCA_ADC
					loFE.F1DetalleOpcionalValor = "SCA"

					If lnCantidad = 4
						loFE.f1IndiceItem  			= 3
						loFE.F1DetalleOpcionalId  	= FE_REFERENCIA
						loFE.F1DetalleOpcionalValor = Alltrim( This.cFCEReferencia )
					Endif


				Else
					*!*	[ Observacion Nº: 10175 ]
					*!*	El campo FchVtoPago no debe informarse si NO es Factura de Credito.
					loFE.F1DetalleFchVtoPago	= ""


					* Opcionales

					loFE.F1DetalleOpcionalItemCantidad = 1

					loFE.f1IndiceItem 			= 0
					loFE.F1DetalleOpcionalId 	= FE_ANULACION
					loFE.F1DetalleOpcionalValor = This.cFCERechazada

				Endif

			Else

				If Inlist(This.oComprobante.CodigoAfip,;
						FE_Nota_de_Debito_A,;
						FE_Nota_de_Credito_A,;
						FE_Nota_de_Debito_B,;
						FE_Nota_de_Credito_B,;
						FE_Nota_de_Debito_C,;
						FE_Nota_de_Credito_C,;
						FE_Nota_de_Debito_M,;
						FE_Nota_de_Credito_M )

					Try

						lcDesde 	= Alltrim( Dtos( GetDate( This.oComprobante.Fecha, GD_FIRST_CURRENT_MONTH )))
						lcHasta 	= Alltrim( Dtos( This.oComprobante.Fecha ))

						loFE.F1DetallePeriodoAsocFchDesde = lcDesde
						loFE.F1DetallePeriodoAsocFchHasta = lcHasta

					Catch To oErr

					Finally

					Endtry

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

	Endproc && xxxWSFEv1Setup

	*
	* Valida los datos antes de enviar la solicitud del CAE
	Procedure DataIsValid(  ) As Boolean;
			HELPSTRING "Valida los datos antes de enviar la solicitud del CAE"

		Local llValid As Boolean
		Local lcErrorMessage As String,;
			lcMsg As String
		Local lnStatus As Integer

		Local loFE As "WsAfipFe.factura",;
			loCliente As Object

		Try

			llValid 		= .T.
			lcErrorMessage 	= ""
			lnStatus 		= 0

			This.WSFEv1Setup()
			loFE = This.oFE

			* Validar Tipo de Comprobante

			If Inlist( loFE.F1CabeceraCbteTipo, 6, 7, 8 ) ;
					And loFE.F1DetalleDocTipo = FE_OTRO_DOCUMENTO

				If loFE.F1DetalleImpTotal >= This.nTopeComprobantesB

					TEXT To lcMsg NoShow TextMerge Pretext 15
					Para comprobantes B mayor o igual a $<<This.nTopeComprobantesB>>,
					el Tipo de Documento debe ser distinto a OTROS,
					y el Número del Documento deberá ser mayor a 0.
					ENDTEXT

					llValid 		= .F.
					lcErrorMessage  = lcErrorMessage + CRLF + lcMsg + CRLF
					lnStatus 		= -1

				Else

					loCliente = This.oCliente

					loFE.F1DetalleDocTipo 	= FE_DNI
					loCliente.TipoDocumento = FE_DNI

					If Empty( Val( loFE.F1DetalleDocNro ))
						loFE.F1DetalleDocNro 	= '1'
						loCliente.NroDocumento 	= '1'
					Endif

				Endif

			Endif

			* Validar que el Numero de Documento sea Mayor que 0
			If loFE.F1DetalleDocTipo # FE_OTRO_DOCUMENTO ;
					And Empty( Val( loFE.F1DetalleDocNro ))

				TEXT To lcMsg NoShow TextMerge Pretext 15
				El Número del Documento debe ser mayor a 0.
				ENDTEXT

				llValid 		= .F.
				lcErrorMessage  = lcErrorMessage + CRLF + lcMsg + CRLF
				lnStatus 		= -1

			Endif


			* Validar que el Cuit/Cuil sea Válido
			If Inlist( loFE.F1DetalleDocTipo, FE_CUIT, FE_CUIL ) ;
					And !This.CuitValido( loFE.F1DetalleDocNro )

				TEXT To lcMsg NoShow TextMerge Pretext 15
				El Número del Cuit/Cuil no es válido.
				ENDTEXT

				llValid 		= .F.
				lcErrorMessage  = lcErrorMessage + CRLF + lcMsg + CRLF
				lnStatus 		= -1

			Endif


			This.ErrorMessage 	= lcErrorMessage
			This.ErrorStatus 	= lnStatus

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loFE 		= Null
			loCliente 	= Null

		Endtry

		Return llValid

	Endproc && DataIsValid


	*
	*
	Procedure SolicitarCAE(  ) As Boolean
		Local llOk As Boolean
		Local loFE As "WsAfipFe.factura"
		Local llPasa As Boolean
		Local lcFileName As String

		Try
			loFE = This.oFE
			llPasa = .F.

			*!*				lcFileName = StrZero( This.oComprobante.CodigoAfip, 3 ) ;
			*!*					+ StrZero( This.nPuntoDeVenta, 4 ) ;
			*!*					+ StrZero( Val( Transform( loFE.F1DetalleCbteDesde )), 8 )

			This.oComprobante.Numero = Val( Transform( loFE.F1DetalleCbteDesde ))
			This.oComprobante.PuntoDeVenta = This.nPuntoDeVenta

			lcFileName = This.GetFileName( This.oComprobante )

			loFE.ArchivoXMLRecibido = Addbs( This.DefaultFolder ) ;
				+ lcFileName + "_WSFEv1_Recibido.xml"

			loFE.ArchivoXMLEnviado = Addbs( This.DefaultFolder ) ;
				+ lcFileName + "_WSFEv1_Enviado.xml"

			If This.lQR
				loFE.F1DetalleQRArchivo = This.GetQrFileName()
			Endif

			llOk = .F.

			If loFE.F1CAESolicitar()
				llOk = loFE.f1RespuestaResultado = "A" ;
					And loFE.f1RespuestaReproceso = "N" ;
					And loFE.f1RespuestaCantidadReg >= 1 ;
					And !Empty( loFE.f1RespuestaDetalleCAE )
			Endif

			If llOk
				This.cCAE 					= loFE.f1RespuestaDetalleCAE
				This.dFechaVencimientoCAE 	= Evaluate( "{^" + Transform( This.oFE.F1RespuestaDetalleCAEFchVto, "@R 9999/99/99" ) + "}"  )
				This.oComprobante.Fecha 	= Evaluate( "{^" + Transform( This.oFE.F1RespuestaDetalleCbteFch, "@R 9999/99/99" ) + "}"  )
				This.oComprobante.Numero 	= loFE.F1RespuestaDetalleCbteDesde

			Else
				If This.lSilence
					This.WSFEv1ErrorHandler()

				Else
					Stop( This.WSFEv1ErrorHandler(),;
						"Fallo al Solicitar CAE" )

				Endif


			Endif

			If FileExist( loFE.ArchivoXMLEnviado )
				lcLogMsg = Any2Char(Datetime()) + CRLF + CRLF
				lcLogMsg = lcLogMsg + Justfname( loFE.ArchivoXMLEnviado ) + CRLF + CRLF
				lcLogMsg = lcLogMsg + Filetostr( loFE.ArchivoXMLEnviado ) + CRLF + CRLF
				*Strtofile( lcLogMsg, Addbs( This.DefaultFolder ) + "WSFEv1_Log.txt", 1 )
				Strtofile( lcLogMsg, Addbs( This.DefaultFolder ) + "WSFEv1_Log_" + Dtoc( Datetime(), 1 ) + ".txt", 1 )
				llPasa = .T.
			Endif

			If FileExist( loFE.ArchivoXMLRecibido )
				lcLogMsg = Any2Char(Datetime()) + CRLF + CRLF
				lcLogMsg = lcLogMsg + Justfname( loFE.ArchivoXMLRecibido ) + CRLF + CRLF
				lcLogMsg = lcLogMsg + Filetostr( loFE.ArchivoXMLRecibido ) + CRLF + CRLF
				*Strtofile( lcLogMsg, Addbs( This.DefaultFolder ) + "WSFEv1_Log.txt", 1 )
				Strtofile( lcLogMsg, Addbs( This.DefaultFolder ) + "WSFEv1_Log_" + Dtoc( Datetime(), 1 ) + ".txt", 1 )
				llPasa = .T.
			Endif

			If llPasa = .T.
				Strtofile( Replicate("-.",40) + CRLF + CRLF, Addbs( This.DefaultFolder ) + "WSFEv1_Log.txt", 1 )
			Endif

			Erase ( loFE.ArchivoXMLEnviado )
			Erase ( loFE.ArchivoXMLRecibido )

			loFE.ArchivoXMLEnviado	= ""
			loFE.ArchivoXMLRecibido = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && SolicitarCAE


	*
	* Wraper personalizado
	Procedure ConsultarComprobanteFenix( oComprobante As Object,;
			oRegistro As Object ) As Boolean ;
			HELPSTRING "Wraper personalizado"
		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""

			llOk = This.ConsultarComprobante( oComprobante.PuntoDeVenta,;
				This.GetCodigoComprobante( oComprobante ),;
				oComprobante.Numero )

			If llOk
				This.LlenarRegistro( oRegistro )
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && ConsultarComprobanteFenix



	*
	* Permite consultar si un comprobante fue registrado o no, y los datos del mismo
	Procedure ConsultarComprobante( tnPuntoDeVenta As Integer,;
			tnTipoDeComprobante As Integer,;
			tnNumeroDeComprobante As Integer ) As Boolean;
			HELPSTRING "Permite consultar si un comprobante fue registrado o no, y los datos del mismo"

		Local llOk As Boolean
		Local loFE As "WsAfipFe.factura"
		Local lcFileName As String

		Try

			loFE = This.oFE

			If This.lQR

				This.oComprobante = Null

				This.oComprobante.CodigoAfip 	= tnTipoDeComprobante
				This.oComprobante.PuntoDeVenta 	= tnPuntoDeVenta
				This.oComprobante.Numero 		= tnNumeroDeComprobante

				This.GetCodigoComprobante()

				Try

					* RA 15/01/2021(15:37:26)
					* Hay un BUG que la primera vez que se quiere inicializar
					* la propiedad F1DetalleQRArchivo da error (no existe propiedad)
					* Despues de hacer la consulta por primera vez ya se la puede
					* usar.
					loFE.F1DetalleQRArchivo = This.GetQrFileName()

				Catch To oErr
					llOk = loFE.F1CompConsultar( tnPuntoDeVenta,;
						tnTipoDeComprobante,;
						tnNumeroDeComprobante )

					If llOk
						Try

							loFE.F1DetalleQRArchivo = This.GetQrFileName()

						Catch To oErr
							This.lQR = .F.

						Finally

						Endtry


					Endif
				Finally

				Endtry

			Endif

			llOk = loFE.F1CompConsultar( tnPuntoDeVenta,;
				tnTipoDeComprobante,;
				tnNumeroDeComprobante )

			If !llOk
				If This.lSilence
					This.WSFEv1ErrorHandler()

				Else
					Stop( This.WSFEv1ErrorHandler(),;
						"Fallo al Consultar Comprobante" )

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

	Endproc && ConsultarComprobante




	*
	*
	Procedure LlenarRegistro( oRegistro As Object ) As Void
		Local lcCommand As String,;
			lcCodigoBarras As String
		Local loReg As Object
		Local loFE As "WsAfipFe.factura"


		Try

			lcCommand = ""
			loFE = This.oFE

			loReg = Createobject( "Empty" )

			AddProperty( loReg, "Fech7", {} )
			AddProperty( loReg, "Impo7", 0 )
			AddProperty( loReg, "Neto7", 0 )
			AddProperty( loReg, "Iiva7", 0 )
			AddProperty( loReg, "Iivn7", 0 )
			AddProperty( loReg, "Tiva7", 0 )
			AddProperty( loReg, "Tivn7", 0 )
			AddProperty( loReg, "Insc7", 1 )
			AddProperty( loReg, "Cuit7", Space( 13 ) )
			AddProperty( loReg, "Tpib7", 0 )
			AddProperty( loReg, "Tpic7", 0 )
			AddProperty( loReg, "Pibb7", 0 )
			AddProperty( loReg, "Pibc7", 0 )
			AddProperty( loReg, "CodigoComp", 0 )
			AddProperty( loReg, "Afip_FCE", .F. )
			AddProperty( loReg, "Cae7", Space( 14 ) )
			AddProperty( loReg, "VencCae", {} )
			AddProperty( loReg, "CgoBarra", Space( 40 ) )
			AddProperty( loReg, "Tasa_Norma", Alicuotas[ IVA_NORMAL_ID ] )
			AddProperty( loReg, "Tasa_Reduc", Alicuotas[ IVA_REDUCIDO_ID ] )
			AddProperty( loReg, "Tasa_Difer", Alicuotas[ IVA_DIFERENCIADO_ID ] )
			AddProperty( loReg, "Tasa_Redu8", Alicuotas[ IVA_MGRAF8_ID ] )
			AddProperty( loReg, "Tasa_Redu9", Alicuotas[ IVA_MGRAF9_ID ] )
			AddProperty( loReg, "Neto_Norma", 0 )
			AddProperty( loReg, "Neto_Reduc", 0 )
			AddProperty( loReg, "Neto_Difer", 0 )
			AddProperty( loReg, "Neto_Exen",  0 )
			AddProperty( loReg, "Neto_Redu8", 0 )
			AddProperty( loReg, "Neto_Redu9", 0 )
			AddProperty( loReg, "Iva_Normal", 0 )
			AddProperty( loReg, "Iva_Reduci", 0 )
			AddProperty( loReg, "Iva_Difere", 0 )
			AddProperty( loReg, "Iva_Reduc8", 0 )
			AddProperty( loReg, "Iva_Reduc9", 0 )


			Do Case
				Case loFE.F1RespuestaDetalleDocTipo = FE_CUIT
					loReg.Cuit7 = Transform( loFE.F1RespuestaDetalleDocNro, "@R 99-99999999-9" )
					loReg.Insc7 = 1

				Case loFE.F1RespuestaDetalleDocTipo = FE_CUIL
					loReg.Cuit7 = Transform( loFE.F1RespuestaDetalleDocNro, "@R 99-99999999-9" )
					loReg.Insc7 = 2

				Case loFE.F1RespuestaDetalleDocTipo = FE_DNI
					loReg.Cuit7 = loFE.F1RespuestaDetalleDocNro
					loReg.Insc7 = 2

				Otherwise
					loReg.Cuit7 = loFE.F1RespuestaDetalleDocNro
					loReg.Insc7 = 2

			Endcase

			loReg.Impo7 = Round( loFE.F1DetalleImpTotal, 2 )
			loReg.Neto7 = Round( loFE.F1DetalleImpNeto, 2 )

			loReg.Neto_Exen = Round( loFE.F1DetalleImpTotalConc, 2 )
			loReg.Neto_Exen = loReg.Neto_Exen + Round( loFE.F1DetalleImpOpEx, 2 )

			loReg.Fech7 = Evaluate( "{^" + Transform( loFE.F1RespuestaDetalleCbteFch, "@R 9999/99/99" ) + "}"  )
			loReg.Cae7 = loFE.f1RespuestaDetalleCAE
			loReg.VencCae = Evaluate( "{^" + Transform( loFE.F1RespuestaDetalleCAEFchVto, "@R 9999/99/99" ) + "}"  )

			This.dFechaVencimientoCAE = loReg.VencCae
			This.cCAE = loReg.Cae7

			loReg.CgoBarra 		= This.cCodigoBarras
			loReg.CodigoComp	= This.oComprobante.CodigoAfip
			loReg.Afip_FCE		= loReg.CodigoComp >= 200



			If !Empty( loFE.F1DetalleIvaItemCantidad )
				For i = 1 To loFE.F1DetalleIvaItemCantidad

					loFE.f1IndiceItem = i - 1

					Do Case
						Case loFE.F1DetalleIvaId = IVA_CERO_ID
							loReg.Neto_Exen  = Round( loFE.F1DetalleIvaBaseImp, 2 )

						Case loFE.F1DetalleIvaId = IVA_REDUCIDO_ID
							loReg.Iva_Reduci = Round( loFE.F1DetalleImpIva, 2 )
							loReg.Neto_Reduc = Round( loFE.F1DetalleIvaBaseImp, 2 )

						Case loFE.F1DetalleIvaId = IVA_NORMAL_ID
							loReg.Iva_Normal = Round( loFE.F1DetalleImpIva, 2 )
							loReg.Neto_Norma = Round( loFE.F1DetalleIvaBaseImp, 2 )

						Case loFE.F1DetalleIvaId = IVA_DIFERENCIADO_ID
							loReg.Iva_Difere = Round( loFE.F1DetalleImpIva, 2 )
							loReg.Neto_Difer = Round( loFE.F1DetalleIvaBaseImp, 2 )

						Case loFE.F1DetalleIvaId = IVA_MGRAF8_ID
							loReg.Iva_Reduc8 = Round( loFE.F1DetalleImpIva, 2 )
							loReg.Neto_Redu8 = Round( loFE.F1DetalleIvaBaseImp, 2 )

						Case loFE.F1DetalleIvaId = IVA_MGRAF9_ID
							loReg.Iva_Reduc9 = Round( loFE.F1DetalleImpIva, 2 )
							loReg.Neto_Redu9 = Round( loFE.F1DetalleIvaBaseImp, 2 )

					Endcase

				Endfor

			Endif

			If !Empty( loFE.F1DetalleTributoItemCantidad )
				For i = 1 To loFE.F1DetalleTributoItemCantidad

					loFE.f1IndiceItem = i - 1

					Do Case
						Case loFE.F1DetalleTributoId = FE_Tributo_Nacional

						Case loFE.F1DetalleTributoId = FE_Tributo_Provincial
							Do Case
								Case "Brutos Buenos Aires" $ loFE.F1DetalleTributoDesc
									loReg.Pibb7 = Round( loFE.F1DetalleTributoImporte, 2 )
									loReg.Tpib7 = Round( loFE.F1DetalleTributoAlic, 2 )

								Case "Brutos Capital" $ loFE.F1DetalleTributoDesc
									loReg.Pibc7 = Round( loFE.F1DetalleTributoImporte, 2 )
									loReg.Tpic7 = Round( loFE.F1DetalleTributoAlic, 2 )

							Endcase


						Case loFE.F1DetalleTributoId = FE_Tributo_Municipal

						Case loFE.F1DetalleTributoId = FE_Tributo_Internos

						Case loFE.F1DetalleTributoId = FE_Tributo_Otro

					Endcase

				Endfor

			Endif

			loReg.Iiva7 = loReg.Iva_Normal
			loReg.Iivn7 = loReg.Iva_Reduci
			loReg.Tiva7 = loReg.Tasa_Norma
			loReg.Tivn7 = loReg.Tasa_Reduc

			MergeObjects( oRegistro, loReg )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && LlenarRegistro


	*
	*
	Procedure WSFEv1ErrorHandler( cPrograma As String ) As Void
		Local loFE As "WsAfipFe.factura"
		Local i As Integer,;
			lnErrors As Integer

		Local lcErrorMsg As String
		Local loItem As Object

		Try
			lcErrorMsg = ""
			This.ErrorMessage = ""
			This.ErrorStatus = -1
			This.ErrorNo = 0

			This.oErrores 		= Createobject( "Collection" )
			This.oObservaciones = Createobject( "Collection" )

			loFE = This.oFE

			Do Case
				Case loFE.f1RespuestaResultado = "R"
					lcErrorMsg = lcErrorMsg + "Comprobante Rechazado" + CRLF

				Case loFE.f1RespuestaResultado = "A"
					lcErrorMsg = lcErrorMsg + "Comprobante Aprobado" + CRLF

			Endcase

			If !Empty( loFE.UltimoNumeroError )
				lcErrorMsg = lcErrorMsg + "[ Ultimo Numero Error: " + Transform( loFE.UltimoNumeroError ) + " ]" + CRLF
			Endif

			If !Empty( loFE.UltimoMensajeError )
				lcErrorMsg = lcErrorMsg + Transform( loFE.UltimoMensajeError ) + CRLF
			Endif

			lnErrors = loFE.f1ErrorItemCantidad

			loItem = Createobject( "Empty" )

			For i = 0 To lnErrors - 1
				loFE.f1IndiceItem = i

				If Empty( This.ErrorNo )
					This.ErrorNo = loFE.f1ErrorCode
				Endif

				lcErrorMsg = lcErrorMsg + "[ Error Nº: " + Transform( loFE.f1ErrorCode ) + " ]" + CRLF
				lcErrorMsg = lcErrorMsg + loFE.f1ErrorMsg + CRLF
				lcErrorMsg = lcErrorMsg + Replicate( "-", 70 ) + CRLF + CRLF

				loItem = Createobject( "Empty" )
				AddProperty( loItem, "ErrorCode", loFE.f1ErrorCode )
				AddProperty( loItem, "ErrorMsg", loFE.f1ErrorMsg )

				This.oErrores.Add( loItem )

			Endfor

			Try
				lnErrors = Nvl( loFE.F1RespuestaDetalleObservacionItemCantidad, 0 )

			Catch To loErr
				lnErrors = 0

			Finally

			Endtry

			For i = 0 To lnErrors - 1
				loFE.f1IndiceItem = i

				lcErrorMsg = lcErrorMsg + "[ Observacion Nº: " + Transform( loFE.F1RespuestaDetalleObservacionCode ) + " ]" + CRLF
				lcErrorMsg = lcErrorMsg + loFE.F1RespuestaDetalleObservacionMsg + CRLF
				lcErrorMsg = lcErrorMsg + Replicate( "-", 70 ) + CRLF + CRLF

				loItem = Createobject( "Empty" )
				AddProperty( loItem, "ObsCode", loFE.F1RespuestaDetalleObservacionCode )
				AddProperty( loItem, "ObsMsg", loFE.F1RespuestaDetalleObservacionMsg )

				This.oObservaciones.Add( loItem )


			Endfor

			If !Empty( lcErrorMsg )
				lcErrorMsg = "Error en WSFEv1" + CRLF + lcErrorMsg
				This.ErrorMessage = lcErrorMsg

				lcErrorMsg = Any2Char(Datetime()) + CRLF + CRLF
				lcErrorMsg = lcErrorMsg + This.ErrorMessage + CRLF + CRLF

				lcErrorMsg = lcErrorMsg + Replicate("-.",40) + CRLF + CRLF

				Strtofile( lcErrorMsg, "ErrorLog_FE.txt", 1 )

				* Intentar grabar el ErrorLog.txt en el servidor, para poder acceder más facilmenmte
				If Vartype( DRVA ) = "C"
					Strtofile( lcErrorMsg, Addbs(Alltrim(DRVA))+"ErrorLog_FE.txt", 1 )
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcErrorMsg
			loError.Process( loErr, .F., .T. )

			TEXT To lcErrorMsg NoShow TextMerge Pretext 03 additive
			<<loError.ErrorDescrip>>
			ENDTEXT

			This.ErrorMessage = lcErrorMsg
			* Warning( This.ErrorMessage, "Webservice Afip" )

		Finally

		Endtry

		Return This.ErrorMessage


	Endproc && WSFEv1ErrorHandler

	*
	* Registrar la factura electrónica
	Procedure Registrar( dFecha As Date,;
			dVenc As Date,;
			nImpNeto As Number,;
			nImpTotal As Number,;
			cDocumento As String,;
			nComp As Integer,;
			cTipo As String,;
			nTipoDocumento As Integer ) As Void;
			HELPSTRING "Registrar la factura electrónica"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Registrar la factura electrónica
			*:Project:
			Clipper2Fox
			*:Autor:
			Danny Amerikaner
			*:Date:
			Lunes 27 de Septiembre de 2010 (10:04:06)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			dFecha AS Date
			dVenc AS Date
			nImpNeto AS Number
			nImpTotal AS Number
			cDocumento As String
			nComp AS Integer
			cTipo As String
			*:Remarks:
			*:Returns:
			Void
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local loFE As "WsAfipFe.factura"
		Local lnUltimo As Number
		Local llRetry As Boolean
		Local lnLen As Integer

		Local Array laMotivos[ 13 ]


		Try

			This.cCAE = ""
			This.cIdentificador = ""
			This.nCodigo = 0
			This.nNumeroInicial = 0
			This.nNumeroFinal = 0

			laMotivos[ 01 ] = "LA CUIT INFORMADA NO CORRESPONDE A UN RESPONSABLE INSCRIPTO EN EL IVA ACTIVO"
			laMotivos[ 02 ] = "LA CUIT INFORMADA NO SE ENCUENTRA AUTORIZADA A EMITIR COMPROBANTES ELECTRONICOS ORIGINALES" + Chr( 13 ) +"O EL PERIODO DE INICIO AUTORIZADO ES POSTERIOR AL DE LA GENERACION DE LA SOLICITUD"
			laMotivos[ 03 ] = "LA CUIT INFORMADA REGISTRA INCONVENIENTES CON EL DOMICILIO FISCAL"
			laMotivos[ 04 ] = "EL PUNTO DE VENTA INFORMADO NO SE ENCUENTRA DECLARADO PARA SER UTILIZADO EN EL PRESENTE REGIMEN"
			laMotivos[ 05 ] = "LA FECHA DEL COMPROBANTE INDICADA NO PUEDE SER ANTERIOR EN MAS DE CINCO DIAS, SI SE TRATA DE UNA VENTA," + Chr( 13 ) +" O ANTERIOR O POSTERIOR EN MAS DE DIEZ DIAS, SI SE TRATA DE UNA PRESTACION DE SERVICIOS," + Chr( 13 ) +"CONSECUTIVOS DE LA FECHA DE REMISION DEL ARCHIVO    Art. 22 de la RG N° 2177"
			laMotivos[ 06 ] = "LA CUIT INFORMADA NO SE ENCUENTRA AUTORIZADA A EMITIR COMPROBANTES CLASE 'A'"
			laMotivos[ 07 ] = "PARA LA CLASE DE COMPROBANTE SOLICITADO -COMPROBANTE CLASE A- " + Chr( 13 ) +"DEBERA CONSIGNAR EN EL CAMPO CODIGO DE DOCUMENTO IDENTIFICATORIO DEL COMPRADOR EL CODIGO '80'"
			laMotivos[ 08 ] = "LA CUIT INDICADA EN EL CAMPO N° DE IDENTIFICACION DEL COMPRADOR ES INVALIDA"
			laMotivos[ 09 ] = "LA CUIT INDICADA EN EL CAMPO N° DE IDENTIFICACION DEL COMPRADOR" + Chr( 13 ) +"NO EXISTE EN EL PADRON UNICO DE CONTRIBUYENTES"
			laMotivos[ 10 ] = "LA CUIT INDICADA EN EL CAMPO N° DE IDENTIFICACION DEL COMPRADOR" + Chr( 13 ) +"NO CORRESPONDE A UN RESPONSABLE INSCRIPTO EN EL IVA ACTIVO"
			laMotivos[ 11 ] = "EL N° DE COMPROBANTE DESDE INFORMADO NO ES CORRELATIVO AL" + Chr( 13 ) +"ULTIMO N° DE COMPROBANTE REGISTRADO/HASTA SOLICITADO PARA ESE TIPO DE COMPROBANTE Y PUNTO DE VENTA"
			laMotivos[ 12 ] = "EL RANGO INFORMADO SE ENCUENTRA AUTORIZADO CON ANTERIORIDAD" + Chr( 13 ) +"PARA LA MISMA CUIT, TIPO DE COMPROBANTE Y PUNTO DE VENTA"
			laMotivos[ 13 ] = "LA CUIT INDICADA SE ENCUENTRA COMPRENDIDA EN EL REGIMEN ESTABLECIDO POR LA" + Chr( 13 ) +"RESOLUCION General N° 2177 Y/O EN EL TITULO i DE LA RESOLUCION General N° 1361 ART. 24 DE LA RG N° 2177-"


			*!*				80 - CUIT
			*!*				86 - CUIL
			*!*				87 - CDI
			*!*				89 - LE
			*!*				90 - LC
			*!*				91 - CI extranjera
			*!*				92 - en trámite
			*!*				93 - Acta nacimiento
			*!*				95 - CI Bs. As. RNP
			*!*				96 - DNI
			*!*				94 - Pasaporte
			*!*				00 - CI Policía Federal
			*!*				01 - CI Buenos Aires
			*!*				07 - CI Mendoza
			*!*				08 - CI La Rioja
			*!*				09 - CI Salta
			*!*				10 - CI San Juan
			*!*				11 - CI San Luis
			*!*				12 - CI Santa Fe
			*!*				13 - CI Santiago del Estero
			*!*				14 - CI Tucumán
			*!*				16 - CI Chaco
			*!*				17 - CI Chubut
			*!*				18 - CI Formosa
			*!*				19 - CI Misiones
			*!*				20 - CI Neuquén


			This.lResultado = This.oFE.ObtenerTicketAcceso()

			If This.lResultado
				lnUltimo = Val( This.oFE.FEUltNroRequest())
				This.cIdentificador = Transform( lnUltimo + 1 )

				This.oFE.FECabeceraCantReg = 1
				This.oFE.FECabeceraPresta_serv = 0
				This.oFE.indice = 0

				This.oFE.FEDetalleFecha_serv_desde = Dtos( dFecha )
				This.oFE.FEDetalleFecha_serv_hasta = Dtos( dFecha )

				This.oFE.FEDetalleFecha_vence_pago = Dtos( dVenc )
				This.oFE.FEDetalleImp_neto = nImpNeto
				This.oFE.FEDetalleImp_total = nImpTotal
				This.oFE.FEDetalleFecha_cbte = Dtos( dFecha )

				This.oFE.FEDetallePunto_vta = This.nPuntoDeVenta

				If cTipo = "A" && Tipo "A"
					If Empty( nTipoDocumento )
						nTipoDocumento = 80
					Endif

					This.oFE.FEDetalleNro_doc = Strtran( cDocumento, "-", "" )
					This.oFE.FEDetalleTipo_doc = nTipoDocumento
					Do Case
						Case nComp = 1 && Factura
							This.oFE.FEDetalleTipo_cbte = 1
						Case nComp = 2 && Nota de Débito
							This.oFE.FEDetalleTipo_cbte = 2
						Otherwise && Nota de Crédito
							This.oFE.FEDetalleTipo_cbte = 3
					Endcase

				Else && Tipo "B"
					If Empty( nTipoDocumento )
						lnLen = Len( Alltrim( Strtran( cDocumento, "-", "" ) ))
						Do Case
							Case lnLen = 11
								nTipoDocumento = 80

							Case lnLen <= 8
								nTipoDocumento = 96

							Otherwise
								nTipoDocumento = 0

						Endcase

					Endif

					This.oFE.FEDetalleNro_doc = Strtran( cDocumento, "-", "" )
					This.oFE.FEDetalleTipo_doc = nTipoDocumento
					Do Case
						Case nComp = 1 && Factura
							This.oFE.FEDetalleTipo_cbte = 6
						Case nComp = 2 && Nota de Débito
							This.oFE.FEDetalleTipo_cbte = 7
						Otherwise && Nota de Crédito
							This.oFE.FEDetalleTipo_cbte = 8
					Endcase
				Endif

				This.lResultado = This.oFE.Registrar( This.nPuntoDeVenta, This.oFE.FEDetalleTipo_cbte, This.cIdentificador )

				If This.lResultado
					*!*	Después de llamar al método "registrar" se debe verificar:
					*!*	que devuelva vedadero.
					*!*	que la propiedad "FERespuestaReproceso" no contenga "S".
					*!*	que la propiedad "FERespuestaCantidadReg" sea mayor que cero.
					*!*	que la propiedad "FERespuestaResultado" contenga "A" o "P".

					This.lResultado = This.oFE.FERespuestaReproceso # "S" ;
						And This.oFE.FERespuestaCantidadReg > 0 ;
						And Inlist( This.oFE.FERespuestaResultado, "A", "P" )

				Else
					*!*	Además notar que si "registrar" devuelve falso puede ser posible que AFIP
					*!*	igualmente haya emitido un CAE (especialmente si las propiedades de resultado
					*!*	"FERespuestaResultado" FERespuestaMotivo, etc) contienen valores  nulos o espacios ya que
					*!*	puede tratarse de un error de conexión. En este último caso se debe re llamar usando
					*!*	el mismo "identificador" para confirmar si se produjo un reproceso.


					llRetry = Empty( Val( Transform( This.oFE.FERespuestaMotivo )))

					If llRetry
						Try

							llRetry = Empty( Val( This.oFE.FERespuestaDetalleMotivo ))

						Catch To loErr

						Finally

						Endtry
					Endif

					If llRetry
						llRetry = Empty( This.oFE.Permsg ) And Empty( This.oFE.UltimoMensajeError )
					Endif

					If llRetry
						If This.oFE.FERespuestaCantidadReg > 0
							If This.oFE.FERespuestaReproceso # 'S' And Inlist( This.oFE.FERespuestaResultado, 'A', 'P' )
								If !Empty( This.oFE.FERespuestaDetalleCae ) And !Empty( This.oFE.FERespuestaDetalleCbt_desde )
									llRetry = .F.
									This.lResultado = .T.
								Endif
							Endif
						Endif
					Endif

					If llRetry
						This.lResultado = This.oFE.Registrar( This.nPuntoDeVenta, This.oFE.FEDetalleTipo_cbte, This.cIdentificador )
					Endif

				Endif

				If This.lResultado Then
					This.cCAE = This.oFE.FERespuestaDetalleCae
					This.nNumeroInicial = This.oFE.FERespuestaDetalleCbt_desde
					This.nCodigo = This.oFE.FEDetalleTipo_cbte
					This.dFechaVencimientoCAE = Evaluate( "{^" + Transform( This.oFE.FERespuestaDetalleFecha_vto, "@R 9999/99/99" ) + "}"  )


					Try
						This.nNumeroFinal = This.oFE.FERespuestaDetalleCbt_hasta
					Catch To loErr
						This.nNumeroFinal = 0
					Finally

					Endtry

				Else
					This.lResultado = .F.

					lcErrorMessage = ""

					If This.oFE.FERespuestaResultado = 'R'
						lcErrorMessage = lcErrorMessage +  "Comprobante Rechazado" + Chr(13)
					Endif


					Try

						If Empty( Val( Transform( This.oFE.FERespuestaMotivo )))
							lcErrorMessage = lcErrorMessage +  "Motivo: " + This.oFE.FERespuestaDetalleMotivo + Chr(13)
						Endif


					Catch To loErr

					Finally

					Endtry


					If !Empty( Val( Transform( This.oFE.FERespuestaMotivo )))
						lcErrorMessage = lcErrorMessage +  "Error " + Transform( This.oFE.FERespuestaMotivo ) + Chr(13)
						lcErrorMessage = lcErrorMessage +  "Detalle: " + laMotivos[ Val( Transform( This.oFE.FERespuestaMotivo )) ] + Chr(13)

					Else
						lcErrorMessage = lcErrorMessage +  "Error " + This.oFE.Permsg + Chr(13)
						lcErrorMessage = lcErrorMessage +  "Detalle: " + This.oFE.UltimoMensajeError + Chr(13)

					Endif


					Error lcErrorMessage


				Endif
			Else
				This.lResultado = .F.
				lcErrorMessage = ""
				lcErrorMessage = lcErrorMessage + "Fallo al obtener autorización "+This.oFE.UltimoMensajeError
				Error lcErrorMessage
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally
			loError = Null

		Endtry

	Endproc && Registrar



	*
	* Carga las tablas dinamicas
	Procedure ExportarTabla( tcTabla As String ) As Void;
			HELPSTRING "Exporta una tabla dinámica"

		Local lcAlias As String

		Try

			lcAlias = This.GetTabla( tcTabla )
			Output2Xls( lcAlias, tcTabla )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Use In Alias( lcAlias )

		Endtry

	Endproc && ExportarTabla

	*
	* Obtener tabla dinamica
	Procedure GetTabla( tcTabla As String,;
			tcAlias As String ) As Void;
			HELPSTRING "Devuelve una tabla dinámica"

		Local loFE As "WsAfipFe.factura"
		Local loTabla As Object
		Local loItem As Object
		Local lcProperty As String,;
			lcAlias As String


		Try

			lcAlias = tcAlias
			If Vartype( lcAlias ) # "C"
				lcAlias = ""
			Endif

			If Empty( lcAlias )
				lcAlias = Sys( 2015 )
			Endif

			Do Case
				Case Lower( tcTabla ) = "cotizaciones"
					lcProperty = ""

				Case Lower( tcTabla ) = "puntosdeventa"
					lcProperty = ""

				Case Lower( tcTabla ) = "comprobantes"
					lcProperty = "oTiposComprobantes"

				Case Lower( tcTabla ) = "conceptos"
					lcProperty = "oTiposConceptos"

				Case Lower( tcTabla ) = "documentos"
					lcProperty = "oTiposDocumento"

				Case Lower( tcTabla ) = "ivas"
					lcProperty = "oTiposIva"

				Case Lower( tcTabla ) = "monedas"
					lcProperty = "oTiposMonedas"

				Case Lower( tcTabla ) = "opcionales"
					lcProperty = "oTiposOpcional"

				Case Lower( tcTabla ) = "tributos"
					lcProperty = "oTiposTributo"

				Otherwise
					Error "Tabla no definida"

			Endcase

			loTabla = Evaluate( "This." + lcProperty )

			Create Cursor ( lcAlias )(;
				Id C(10),;
				Descripcion C(80))

			For Each loItem In loTabla
				Insert Into ( lcAlias ) (;
					Id,;
					Descripcion ) Values ( ;
					Padl( Transform( loItem.Id ), 10, " " ),;
					Transform( loItem.Descripcion ))

			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lcAlias

	Endproc && GetTabla


	*
	* nDetalleConcepto_Assign
	Protected Procedure nDetalleConcepto_Assign( uNewValue )

		This.nDetalleConcepto = uNewValue
		This.oFE.F1DetalleConcepto = uNewValue

	Endproc && nDetalleConcepto_Assign

	*
	* nPuntoDeVenta_Access
	Protected Procedure nPuntoDeVenta_Access()
		Local lnPuntoDeVenta As Integer

		Try

			lnPuntoDeVenta = This.nPuntoDeVenta
			This.nPuntoDeVenta = This.oFE.F1CabeceraPtoVta

		Catch To loErr
			This.nPuntoDeVenta = lnPuntoDeVenta

		Finally

		Endtry

		Return This.nPuntoDeVenta

	Endproc && nPuntoDeVenta_Access

	*
	* nPuntoDeVenta_Assign
	Protected Procedure nPuntoDeVenta_Assign( uNewValue )

		This.nPuntoDeVenta = uNewValue
		This.oFE.F1CabeceraPtoVta = uNewValue

	Endproc && nPuntoDeVenta_Assign


	*
	* Obtiene el tiquet de acceso
	Procedure ObtenerTiquetAcceso( ) As Boolean;
			HELPSTRING "Obtiene el tiquet de acceso"

		Local llOk As Boolean
		Local loFE As "WsAfipFe.factura"

		Try

			llOk = .F.
			loFE = This.oFE

			If !loFE.f1TicketEsValido
				If FileExist( Addbs( This.DefaultFolder )+ This.CurrentTokenFileName )
					loFE.f1RestaurarTicketAcceso( Filetostr( Addbs( This.DefaultFolder )+ This.CurrentTokenFileName ) )
				Endif
			Endif

			If loFE.f1TicketEsValido
				llOk = .T.

			Else
				llOk = loFE.f1ObtenerTicketAcceso()
				If llOk
					Strtofile( loFE.f1GuardarTicketAcceso(), Addbs( This.DefaultFolder )+ This.CurrentTokenFileName, 0 )

				Else
					If This.lSilence
						This.WSFEv1ErrorHandler( Program() )

					Else
						Stop( This.WSFEv1ErrorHandler( Program() ),;
							"Fallo al obtener Ticket de Acceso" )
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
	* oFE_Access
	Protected Procedure oFE_Access()
		Local loFE As "WsAfipFe.factura"

		Try

			If Vartype( This.oFE ) # "O"
				This.oFE = Createobject( "WsAfipFe.factura" )
			Endif

		Catch To loErr

		Finally

		Endtry

		Return This.oFE

	Endproc && oFE_Access


	*
	* oTiposComprobantes_Access
	* Permite obtener los tipos de comprobantes habilitados en este WS.
	Protected Procedure oTiposComprobantes_Access()
		Local i As Integer
		Local loFE As "WsAfipFe.factura"

		Try

			If Vartype( This.oTiposComprobantes ) # "O"
				This.oTiposComprobantes = Createobject( "Collection" )
				loFE = This.oFE
				If This.ObtenerTiquetAcceso()
					loFE.f1ParamGetTiposCbte()

					For i = 0 To loFE.f1TiposCbteItemCantidad - 1
						loFE.f1IndiceItem = i

						loTipoComprobante = Createobject( "Empty" )
						AddProperty( loTipoComprobante, "Descripcion", loFE.f1TiposCbte_Desc )
						AddProperty( loTipoComprobante, "Desde", loFE.f1TiposCbte_fchDesde )
						AddProperty( loTipoComprobante, "Hasta", loFE.f1TiposCbte_fchHasta )
						AddProperty( loTipoComprobante, "Id", loFE.f1TiposCbte_Id )

						This.oTiposComprobantes.Add( loTipoComprobante, Transform( loFE.f1TiposCbte_Id ) )

					Endfor
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return This.oTiposComprobantes

	Endproc && oTiposComprobantes_Access


	*
	* oTiposMonedas_Access
	Protected Procedure oTiposMonedas_Access()
		Local i As Integer
		Local loFE As "WsAfipFe.factura"

		Try

			If Vartype( This.oTiposMonedas ) # "O"
				This.oTiposMonedas = Createobject( "Collection" )
				loFE = This.oFE

				If This.ObtenerTiquetAcceso()
					loFE.f1ParamGetTiposMoneda()

					For i = 0 To loFE.f1TiposMonedaItemCantidad - 1
						loFE.f1IndiceItem = i

						loTipoComprobante = Createobject( "Empty" )
						AddProperty( loTipoComprobante, "Descripcion", loFE.f1TiposMoneda_Desc )
						AddProperty( loTipoComprobante, "Desde", loFE.f1TiposMoneda_fchDesde )
						AddProperty( loTipoComprobante, "Hasta", loFE.f1TiposMoneda_fchHasta )
						AddProperty( loTipoComprobante, "Id", loFE.f1TiposMoneda_Id )

						This.oTiposMonedas.Add( loTipoComprobante, Transform( loFE.f1TiposMoneda_Id ) )

					Endfor
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return This.oTiposMonedas

	Endproc && oTiposMonedas_Access


	*
	* oTiposDocumento_Access
	Protected Procedure oTiposDocumento_Access()

		Local i As Integer
		Local loFE As "WsAfipFe.factura"

		Try

			If Vartype( This.oTiposDocumento ) # "O"
				This.oTiposDocumento = Createobject( "Collection" )
				loFE = This.oFE

				If This.ObtenerTiquetAcceso()
					loFE.f1ParamGetTiposDoc()

					For i = 0 To loFE.f1TiposDocItemCantidad - 1
						loFE.f1IndiceItem = i

						loTiposDocumento = Createobject( "Empty" )
						AddProperty( loTiposDocumento, "Descripcion", loFE.f1TiposDoc_Desc )
						AddProperty( loTiposDocumento, "Desde", loFE.f1TiposDoc_fchDesde )
						AddProperty( loTiposDocumento, "Hasta", loFE.f1TiposDoc_fchHasta )
						AddProperty( loTiposDocumento, "Id", loFE.f1TiposDoc_Id )

						This.oTiposDocumento.Add( loTiposDocumento, Transform( loFE.f1TiposDoc_Id ) )

					Endfor
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry


		Return This.oTiposDocumento

	Endproc && oTiposDocumento_Access



	*
	* oTiposConceptos_Access
	Protected Procedure oTiposConceptos_Access()
		Local i As Integer
		Local loFE As "WsAfipFe.factura"

		Try

			If Vartype( This.oTiposConceptos ) # "O"
				This.oTiposConceptos = Createobject( "Collection" )
				loFE = This.oFE

				If This.ObtenerTiquetAcceso()
					loFE.f1ParamGetTiposConcepto()

					For i = 0 To loFE.f1TiposConceptoItemCantidad - 1
						loFE.f1IndiceItem = i

						loTiposConceptos = Createobject( "Empty" )
						AddProperty( loTiposConceptos, "Descripcion", loFE.f1TiposConcepto_Desc )
						AddProperty( loTiposConceptos, "Desde", loFE.f1TiposConcepto_fchDesde )
						AddProperty( loTiposConceptos, "Hasta", loFE.f1TiposConcepto_fchHasta )
						AddProperty( loTiposConceptos, "Id", loFE.f1TiposConcepto_Id )

						This.oTiposConceptos.Add( loTiposConceptos, Transform( loFE.f1TiposConcepto_Id ) )

					Endfor
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return This.oTiposConceptos

	Endproc && oTiposConceptos_Access


	*!*	 f1ParamGetTiposConcepto	 FEParamGetTiposConcepto    	Permite obtener los tipos de conceptos posibles en este WS.

	*
	* oTiposIva_Access
	Protected Procedure oTiposIva_Access()
		Local i As Integer
		Local loFE As "WsAfipFe.factura"

		Try

			If Vartype( This.oTiposIva ) # "O"
				This.oTiposIva = Createobject( "Collection" )
				loFE = This.oFE

				If This.ObtenerTiquetAcceso()
					loFE.f1ParamGetTiposIva()

					For i = 0 To loFE.f1TiposIvaItemCantidad - 1
						loFE.f1IndiceItem = i

						loTiposIva = Createobject( "Empty" )
						AddProperty( loTiposIva, "Descripcion", loFE.f1TiposIva_Desc )
						AddProperty( loTiposIva, "Desde", loFE.f1TiposIva_fchDesde )
						AddProperty( loTiposIva, "Hasta", loFE.f1TiposIva_fchHasta )
						AddProperty( loTiposIva, "Id", loFE.f1TiposIva_Id )

						This.oTiposIva.Add( loTiposIva, Transform( loFE.f1TiposIva_Id ) )

					Endfor
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry


		Return This.oTiposIva

	Endproc && oTiposIva_Access


	*
	* oTiposOpcional_Access
	Protected Procedure oTiposOpcional_Access()
		Local i As Integer
		Local loFE As "WsAfipFe.factura"

		Try

			If Vartype( This.oTiposOpcional ) # "O"
				This.oTiposOpcional = Createobject( "Collection" )
				loFE = This.oFE

				If This.ObtenerTiquetAcceso()
					loFE.f1ParamGetTiposOpcional()

					For i = 0 To loFE.f1TiposOpcionalItemCantidad - 1
						loFE.f1IndiceItem = i

						loTiposOpcional = Createobject( "Empty" )
						AddProperty( loTiposOpcional, "Descripcion", loFE.f1TiposOpcional_Desc )
						AddProperty( loTiposOpcional, "Desde", loFE.f1TiposOpcional_fchDesde )
						AddProperty( loTiposOpcional, "Hasta", loFE.f1TiposOpcional_fchHasta )
						AddProperty( loTiposOpcional, "Id", loFE.f1TiposOpcional_Id )

						This.oTiposOpcional.Add( loTiposOpcional, Transform( loFE.f1TiposOpcional_Id ) )

					Endfor
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry


		Return This.oTiposOpcional

	Endproc && oTiposOpcional_Access


	*
	* oTiposTributo_Access
	Protected Procedure oTiposTributo_Access()
		Local i As Integer
		Local loFE As "WsAfipFe.factura"

		Try

			If Vartype( This.oTiposTributo ) # "O"
				This.oTiposTributo = Createobject( "Collection" )
				loFE = This.oFE

				If This.ObtenerTiquetAcceso()
					loFE.f1ParamGetTiposTributo()

					For i = 0 To loFE.f1TiposTributoItemCantidad - 1
						loFE.f1IndiceItem = i

						loTiposTributo = Createobject( "Empty" )
						AddProperty( loTiposTributo, "Descripcion", loFE.f1TiposTributo_Desc )
						AddProperty( loTiposTributo, "Desde", loFE.f1TiposTributo_fchDesde )
						AddProperty( loTiposTributo, "Hasta", loFE.f1TiposTributo_fchHasta )
						AddProperty( loTiposTributo, "Id", loFE.f1TiposTributo_Id )

						This.oTiposTributo.Add( loTiposTributo, Transform( loFE.f1TiposTributo_Id ) )

					Endfor
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return This.oTiposTributo

	Endproc && oTiposTributo_Access



	*
	* oCliente_Access
	Protected Procedure oCliente_Access()
		Local loCliente As Object

		Try

			If Vartype( This.oCliente ) # "O"
				loCliente = Createobject( "Empty" )

				AddProperty( loCliente, "TipoDocumento", 0 )
				AddProperty( loCliente, "NroDocumento", "" )
				AddProperty( loCliente, "lStatus", .F. )
				AddProperty( loCliente, "lSuccess", .F. )
				AddProperty( loCliente, "cErrorMessage", "" )

				AddProperty( loCliente, "nInscripto", 0 )
				AddProperty( loCliente, "nImpuesto", 0 )
				AddProperty( loCliente, "cImpuesto", "" )
				AddProperty( loCliente, "cNombre", "" )
				AddProperty( loCliente, "cDireccion", "" )
				AddProperty( loCliente, "cLocalidad", "" )
				AddProperty( loCliente, "idProvincia", 0 )
				AddProperty( loCliente, "cCodPostal", "" )

				This.oCliente = loCliente

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return This.oCliente

	Endproc && oCliente_Access

	*
	* oComprobante_Access
	Protected Procedure oComprobante_Access()
		Local loComprobante As Object

		Try

			If Vartype( This.oComprobante ) # "O"
				loComprobante = Createobject( "Empty" )

				AddProperty( loComprobante, "Letra", " " )
				AddProperty( loComprobante, "Tipo", 0 )	&& ar7ven.Comp7
				AddProperty( loComprobante, "CodigoAfip", 0 )&& Opcional. Si NO es 0, prevalece sobre Letra y Tipo

				*!*	Entero	Concepto del comprobante.  01-Productos, 02-Servicios, 03-Productos y Servicios
				AddProperty( loComprobante, "Concepto", FE_PRODUCTOS )

				AddProperty( loComprobante, "PuntoDeVenta", This.nPuntoDeVenta )

				*!*	Entero	Número de comprobante desde.
				AddProperty( loComprobante, "Numero", 0 )

				*!* Fecha del comprobante. Para un concepto de factura igual a 1,
				*	la fecha de emisión puede ser hasta 5 días posteriores a la de generación.
				*	Si el concepto es 2 o 3, puede ser hasta 10 días anteriores o posteriores a la fecha de generación.
				*	Al ser un dato opcional, si no se asigna fecha, por defecto se asignará la fecha del proceso.
				AddProperty( loComprobante, "Fecha", Date() )

				*!*	Double. Importe total del comprobante,
				*	es igual a la suma de
				*			Importe Neto No Gravado (F1DetallImpTotalConc)
				*		+  	Importe Neto Gravado (F1DetalleImpNeto)
				*		+ 	Importe Exento (F1DetalleImpOpEx)
				*		+ 	Importes de Tributo (F1DetalleImpTrib)
				*		+ 	Importes de IVA (F1DetalleImpIVA).
				AddProperty( loComprobante, "ImporteTotal", 0 )

				*!*	Double. Importe Neto No Gravado, debe ser mayor a cero y menor o igual al importe total (F1DetalleImpTotal).
				AddProperty( loComprobante, "ImporteNetoNoGravado", 0 )

				*!*	Double. Importe Neto Gravado, debe ser mayor a cero y menor o igual al importe total (F1DetalleImpTotal).
				AddProperty( loComprobante, "ImporteNeto", 0 )

				*!*	Double. Importe Exento, debe ser mayor a cero y menor o igual al importe total (F1DetalleImpTotal).
				AddProperty( loComprobante, "ImporteExento", 0 )

				*!* Double.	Suma de los importes del array de Tributos.
				AddProperty( loComprobante, "ImporteTotalTributos", 0 )

				*!*	Double. Suma de los importes del array de IVA.
				AddProperty( loComprobante, "ImporteTotalIva", 0 )

				*!*	Fecha de inicio del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o posterior a la fecha del proceso.
				AddProperty( loComprobante, "FechaServicioDesde", Ctod("") )

				*!*	Fecha de fin del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o mayor a la fecha de inicio del servicio a facturar (F1DetalleFchServDesde).
				AddProperty( loComprobante, "FechaServicioHasta", Ctod("") )

				*!*	Fecha de vencimiento del pago del servicio a facturar.
				*	El dato es obligatorio en caso de que el concepto sea 2 o 3 (Servicio / Productos y Servicio)
				*	y debe ser igual o posterior a la fecha del proceso.
				AddProperty( loComprobante, "FechaVencimientoPago", Ctod("") )


				This.oComprobante = loComprobante

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return This.oComprobante

	Endproc && oComprobante_Access





	*
	* oMoneda_Access
	Protected Procedure oMoneda_Access()

		Local loMoneda As Object

		Try

			If Vartype( This.oMoneda ) # "O"
				loMoneda = Createobject( "Empty" )

				AddProperty( loMoneda, "Id", "PES" )
				AddProperty( loMoneda, "Descripcion", "Pesos Argentinos" )
				AddProperty( loMoneda, "Cotizacion", 1 )

				This.oMoneda = loMoneda

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry


		Return This.oMoneda

	Endproc && oMoneda_Access


	*
	* oTributos_Access
	Protected Procedure oTributos_Access()
		If Vartype( This.oTributos ) # "O"
			This.oTributos = Createobject( "Collection" )
		Endif

		Return This.oTributos

	Endproc && oTributos_Access

	*
	* oOpcionales_Access
	Protected Procedure oOpcionales_Access()

		If Vartype( This.oOpcionales ) # "O"
			This.oOpcionales = Createobject( "Collection" )
		Endif

		Return This.oOpcionales

	Endproc && oOpcionales_Access

	*
	* oIvas_Access
	Protected Procedure oIvas_Access()
		If Vartype( This.oIvas ) # "O"
			This.oIvas = Createobject( "Collection" )
		Endif

		Return This.oIvas

	Endproc && oIvas_Access

	*
	* oComprobantesAsociados_Access
	Protected Procedure oComprobantesAsociados_Access()
		If Vartype( This.oComprobantesAsociados ) # "O"
			This.oComprobantesAsociados = Createobject( "Collection" )
		Endif

		Return This.oComprobantesAsociados

	Endproc && oComprobantesAsociados_Access


	*!*	 F1DetalleMonId / F1DetalleMonIdS	 String	Código de moneda del comprobante según la lista del método F1ParamGetTiposMonedas. "F!DetalleMonIdS" es equilvante pero en formato "string" de 3 caracteres para evitar errores de conexión.
	*!*	 F1DetalleMonCotiz	 Double	Cotización de la moneda. Para PES (pesos argentinos) deber ser el valor "1".
	*!*	 F1DetalleTributoItemCantidad	 Entero    	Cantidad de Tributos relacionados al comprobante. No aplica para lote de facturas, es decir donde F1DetalleCompDesdeS es distinto a F1DetalleCompHastaS. Los datos de cada tributo se cargan con las propiedades de la tabla 3B.
	*!*	 F1DetalleIvaItemCantidad	 Entero	Cantidad de Alícuotas de IVA relacionadas al comprobante(Tabla 3A). No aplica para lote de facturas, es decir donde F1DetalleCompDesdeS es distinto a F1DetalleCompHastaS. Los datos de cada alícuota se cargan con las propiedades de la tabla 3A.
	*!*	 F1DetalleCbtesAsocItemCantidad	 Entero    	Cantidad de comprobantes asociados. Los datos de los comprobantes se cargan con las propiedades de la tabla 3D.
	*!*	 F1DetalleOpcionalItemCantidad	 Entero	Cantidad de campos auxiliares. Los datos opcionales se cargan con las propiedades de la tabla 3C.
	*!*	 F1DetalleCAEA	 string	 solo para el método FECAEARegInformativo. Contiene el CAE anticipado usado para el comprobante y obtenido previamente con el método FECAEASolicitar.


	*
	* devuelve el código de comprobante otorgado por la Afip
	Procedure GetCodigoComprobante( toComprobante As Object ) As Integer;
			HELPSTRING "devuelve el código de comprobante otorgado por la Afip"

		Local lnCodigo As Integer
		Local loComprobante As Object

		Try

			If Vartype( toComprobante ) = "O"
				loComprobante = toComprobante

			Else
				loComprobante = This.oComprobante

			Endif

			lnCodigo = loComprobante.CodigoAfip

			If Empty( lnCodigo )

				Do Case
					Case loComprobante.Letra = "A"
						Do Case
							Case loComprobante.Tipo = 1
								lnCodigo = 1

							Case loComprobante.Tipo = 2
								lnCodigo = 2

							Case loComprobante.Tipo = 3
								lnCodigo = 3

						Endcase

					Case loComprobante.Letra = "B"
						Do Case
							Case loComprobante.Tipo = 1 Or loComprobante.Tipo = 23
								lnCodigo = 6

							Case loComprobante.Tipo = 2 Or loComprobante.Tipo = 24
								lnCodigo = 7

							Case loComprobante.Tipo = 3 Or loComprobante.Tipo = 25
								lnCodigo = 8

						Endcase

					Case loComprobante.Letra = "C"
						Do Case
							Case loComprobante.Tipo = 1
								lnCodigo = 11

							Case loComprobante.Tipo = 2
								lnCodigo = 12

							Case loComprobante.Tipo = 3
								lnCodigo = 13

							Case loComprobante.Tipo = 7
								lnCodigo = 15

						Endcase

					Case loComprobante.Letra = "M"
						Do Case
							Case loComprobante.Tipo = 1
								lnCodigo = 51

							Case loComprobante.Tipo = 2
								lnCodigo = 52

							Case loComprobante.Tipo = 3
								lnCodigo = 53

							Case loComprobante.Tipo = 7
								lnCodigo = 54

						Endcase

				Endcase

				If This.lFCE
					lnCodigo = lnCodigo + 200
				Endif

				loComprobante.CodigoAfip = lnCodigo

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lnCodigo

	Endproc && GetCodigoComprobante


	*
	*
	Procedure GetFileName( oComprobante As Object ) As String
		Local lcCommand As String,;
			lcFileName As String

		Try

			lcCommand = ""

			If Vartype( oComprobante ) # "O"
				oComprobante = This.oComprobante
			Endif

			lcFileName = StrZero( oComprobante.CodigoAfip, 3 ) ;
				+ StrZero( oComprobante.PuntoDeVenta, 4 ) ;
				+ StrZero( oComprobante.Numero, 8 )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			oComprobante = Null

		Endtry

		Return lcFileName

	Endproc && GetFileName



	*
	*
	Procedure GetQrFileName( oComprobante As Object ) As String
		Local lcCommand As String,;
			lcFileName As String

		Local loFE As "WsAfipFe.factura"

		Try

			lcCommand = ""
			loFE = This.oFE

			If Vartype( oComprobante ) # "O"
				oComprobante = This.oComprobante
			Endif

			lcFileName = This.GetFileName( oComprobante ) + "_QR.jpg"
			lcFileName = Addbs( GetValue( "QR_Folder", "ar0Fel", "" ) ) + lcFileName

			* Junto con la propiedad F1DetalleQRArchivo hay otras que sirven
			* Para configurar la imagen  generada (desde el instalador 94.00
			* en adelante):

			* f1DetalleQRformato	 el formato del archivo:
			* 							1 BMP (por defecto),
			*							2 EMF,
			*							3 EXIF,
			*							4 GIF,
			*							5 Icon,
			*							6 JPG (JPEG),
			*							7 MEM,
			*							8 PNG,
			*							9 TIFF,
			*							10 WMF.
			* Asegurarse que el formato usado coincida con  la extensión en
			* el nombre del archivo. Recomendado 6.

			* f1DetalleQRResolucion	 de 1 a 100 (20 por defecto)
			*	a mayor resolución mayor definición Y mayor tamaño de archivo
			* (20 equivale a una imagen de 400x400 piexeles aprox.).
			* Recomendado 4.

			* f1DetalleQRTolerencia	 0, 1, 2 (por defecto) o 3
			*	a mayor tolerancia (al Error) mayor tamaño de archivo
			*	Y más probabilidad que el lector lea el código si la tinta
			*	o el papel es deficiente.
			*	Recomendado 0.

			If This.lQR
				loFE.f1detalleqrformato = 6
				loFE.f1DetalleQRResolucion = 4
				loFE.F1DetalleQRTolerancia = 0

			Else
				lcFileName = ""

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			oComprobante = Null

		Endtry

		Return lcFileName

	Endproc && GetQrFileName





	*
	* Devuelve un elemento de la colección Ivas o Tributos
	Procedure NewElement(  ) As Object;
			HELPSTRING "Devuelve un elemento de la colección Ivas o Tributos"

		Local loElement As Object

		Try
			loElement = Createobject( "Empty" )
			AddProperty( loElement, "Id", 0 )
			AddProperty( loElement, "Descripcion", "" )
			AddProperty( loElement, "BaseImponible", 0 )
			AddProperty( loElement, "Alicuota", 0 )
			AddProperty( loElement, "Importe", 0 )

			* Comprobante Asociado
			AddProperty( loElement, "Letra", "" )
			AddProperty( loElement, "Tipo", 0 )
			AddProperty( loElement, "CodigoAfip", 0 )
			AddProperty( loElement, "PuntoDeVenta", 0 )
			AddProperty( loElement, "Numero", 0 )
			AddProperty( loElement, "CUIT", "" )
			AddProperty( loElement, "Fecha", "" )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loElement

	Endproc && NewElement



	*
	* Volcado de memoria
	Procedure MemoryDump(  ) As Void;
			HELPSTRING "Volcado de memoria"


		Local loFE As "WsAfipFe.factura"
		Local lnLen As Integer ,;
			i As Integer
		Local Array laProperties[ 1 ]
		Local lcProperty As String,;
			lcStr As String Y



		Try
			loFE = This.oFE
			lnLen = Amembers( laProperties, loFE, 3 )

			Strtofile( "", "WSFEv1MemoryDump.prg", 0 )

			For i = 1 To lnLen

				If Lower( laProperties[ i, 2 ] ) = "propertyget"

					lcProperty = laProperties[ i, 1 ]

					Try

						TEXT To lcStr NoShow TextMerge Pretext 15
						<<PadR( lcProperty + ":", 30, " " )>> <<Transform( Evaluate( "loFE." + lcProperty ))>>
						ENDTEXT

						Strtofile( lcStr+ CRLF, "WSFEv1MemoryDump.prg", 1 )

					Catch To loErr

					Finally

					Endtry

				Endif

			Endfor



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			*			Throw loError


		Finally
			loFE = Null

		Endtry

	Endproc && MemoryDump


	*
	* Chequea la conexion con el Webservice de la Afip
	Procedure Test(  ) As Boolean;
			HELPSTRING "Chequea la conexion con el Webservice de la Afip"

		Local loFE As "WsAfipFe.factura"
		Local llOk As Boolean
		Local lcURL As String,;
			lcAutenticado As String,;
			lcBaseDeDatos As String,;
			lcAplicaciones As String,;
			lcMsg As String

		Try

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Erase <<Addbs( This.DefaultFolder )+ This.CurrentTokenFileName>>
			ENDTEXT

			&lcCommand

			loFE = This.oFE
			llOk = loFE.f1Dummy()

			lcURL 			= IfEmpty( loFE.f1DireccionServicioURL, "No hay datos" )
			lcAutenticado 	= IfEmpty( loFE.f1RespuestaDummyAuthServer, "No hay datos" )
			lcBaseDeDatos 	= IfEmpty( loFE.f1RespuestaDummyDbServer, "No hay datos" )
			lcAplicaciones 	= IfEmpty( loFE.f1RespuetaDummyAppServer, "No hay datos" )

			TEXT To lcMsg NoShow TextMerge Pretext 03
			URL: <<lcURL>>
			Server de Autenticacion: <<lcAutenticado>>
			Server de Base de Datos: <<lcBaseDeDatos>>
			Server de Aplicaciones:  <<lcAplicaciones>>
			ENDTEXT

			llOk = loFE.Iniciar( This.nModo,;
				This.cCuitEmisor,;
				This.cCertificado,;
				This.cLicencia ) And llOk

			llOk = This.ObtenerTiquetAcceso() And llOk

			If llOk
				This.ErrorMessage = lcMsg

			Else
				This.ErrorMessage = This.ErrorMessage + CRLF + lcMsg

			Endif





			*!*				If llOk
			*!*					Inform( lcMsg, "Se obtuvo el Ticket de Acceso" )

			*!*				Else
			*!*					Warning( lcMsg, "NO pudo obtenerse el Ticket de Acceso" )

			*!*				Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loFE = Null

		Endtry

		Return llOk

	Endproc && Test

	Procedure Destroy()
		This.oCliente 				= Null
		This.oComprobante 			= Null
		This.oIvas 					= Null
		This.oMoneda 				= Null
		This.oComprobantesAsociados = Null
		This.oTiposComprobantes 	= Null
		This.oTiposConceptos 		= Null
		This.oTiposDocumento 		= Null
		This.oTiposIva 				= Null
		This.oTiposMonedas 			= Null
		This.oTiposOpcional 		= Null
		This.oTiposTributo 			= Null
		This.oTributos 				= Null
		This.oOpcionales 			= Null
		This.oFE 					= Null
	Endproc

	*
	* Valida el Numero del Cuit
	Procedure CuitValido( tcCuit As String ) As Boolean;
			HELPSTRING "Valida el Numero del Cuit"

		Local lnSuma As Integer,;
			lnR As Integer,;
			lnResto As Integer,;
			lnDigito As Integer,;
			lnKey As Integer,;
			lnImpuesto As Integer

		Local lcNewCuit As String,;
			lcFactor As String,;
			lcCategoria  As String,;
			lcImpuestosIVA As String,;
			lcAlias As String,;
			lcErrorMessage As String

		Local llOk As Boolean,;
			llExistImpuestos_Afip_IVA As Boolean,;
			llCondicion As Boolean

		Local loPersona As Object,;
			loCliente As Object,;
			loConsultasAFIP As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg",;
			loImpuestos As Collection,;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"


		Try

			tcCuit = Strtran( tcCuit, "-", "" )
			tcCuit = Substr( Padr( Alltrim( tcCuit ), 11, " " ), 1, 11 )

			Store 0 To lnSuma,lnR
			Store Iif(Type('mvacio')='N',mVacio,0) To mVacio
			Store Spac(13) To lcNewCuit
			Store .T. To llOk
			Store '5432765432' To lcFactor

			For lnR=1 To 11
				lnSuma = lnSuma + Val( Subst( lcFactor, lnR, 1 )) * Val( Subst( tcCuit, lnR, 1 ))
			Next

			lnResto		= Mod( lnSuma, 11 )
			lnDigito	= Iif( lnResto = 0, lnResto, 11 - lnResto )

			llOk = Str( lnDigito, 1 ) = Right( tcCuit, 1 )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loPersona 			= Null
			loCliente 			= Null
			loConsultasAFIP 	= Null
			loImpuestos 		= Null
			loGlobalSettings 	= Null

		Endtry

		Return llOk

	Endproc && CuitValido



	* (Habiltar cuando se instale la Consulta del Cuit a la Afip)
	* Valida el Numero del Cuit
	Procedure xxxCuitValido( tcCuit As String ) As Boolean;
			HELPSTRING "Valida el Numero del Cuit"

		Local lnSuma As Integer,;
			lnR As Integer,;
			lnResto As Integer,;
			lnDigito As Integer,;
			lnKey As Integer,;
			lnImpuesto As Integer

		Local lcNewCuit As String,;
			lcFactor As String,;
			lcCategoria  As String,;
			lcImpuestosIVA As String,;
			lcAlias As String,;
			lcErrorMessage As String

		Local llOk As Boolean,;
			llExistImpuestos_Afip_IVA As Boolean,;
			llCondicion As Boolean

		Local loPersona As Object,;
			loCliente As Object,;
			loConsultasAFIP As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg",;
			loImpuestos As Collection,;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"


		Try

			tcCuit = Strtran( tcCuit, "-", "" )
			tcCuit = Substr( Padr( Alltrim( tcCuit ), 11, " " ), 1, 11 )

			Store 0 To lnSuma,lnR
			Store Iif(Type('mvacio')='N',mVacio,0) To mVacio
			Store Spac(13) To lcNewCuit
			Store .T. To llOk
			Store '5432765432' To lcFactor

			For lnR=1 To 11
				lnSuma = lnSuma + Val( Subst( lcFactor, lnR, 1 )) * Val( Subst( tcCuit, lnR, 1 ))
			Next

			lnResto		= Mod( lnSuma, 11 )
			lnDigito	= Iif( lnResto = 0, lnResto, 11 - lnResto )

			llOk = Str( lnDigito, 1 ) = Right( tcCuit, 1 )

			If llOk

				loCliente = This.oCliente

				loPersona = This.GetPersona( tcCuit )

				loCliente.lStatus = loPersona.lStatus

				If loPersona.lStatus = .T.

					loCliente.lSuccess = loPersona.Success

					If loPersona.Success
						loImpuestos = loPersona.Data.Impuestos

						lcCategoria = "NO INFORMADO"
						loCliente.nInscripto = 9
						loCliente.cImpuesto = lcCategoria
						loCliente.nImpuesto = 0

						loGlobalSettings = NewGlobalSettings()
						lcImpuestosIVA = loGlobalSettings.cImpuestosIVA

						If FileExist( Alltrim( DRCOMUN ) + "Impuestos_Afip_IVA.dbf" )
							If !Used( "Impuestos_Afip_IVA" )
								M_Use( 0, Alltrim( DRCOMUN ) + "Impuestos_Afip_IVA" )
							Endif
							llExistImpuestos_Afip_IVA = .T.

						Else
							llExistImpuestos_Afip_IVA = .F.

						Endif

						For Each lnImpuesto In loImpuestos

							If llExistImpuestos_Afip_IVA
								llCondicion = Seek( lnImpuesto, "Impuestos_Afip_IVA", "Id" )

							Else
								llCondicion = Inlist( lnImpuesto, 20, 21, 22, 23, 24, 30, 32, 33, 34 )

							Endif

							If llCondicion

								Do Case
									Case Inlist( lnImpuesto, 20, 21, 22, 23, 24 )
										lcCategoria = "MONOTRIBUTO"
										loCliente.nInscripto = 7

									Case Inlist( lnImpuesto, 30 )
										lcCategoria = "RESPONSABLE INSCRIPTO"
										loCliente.nInscripto = 1

									Case Inlist( lnImpuesto, 32, 34 )
										lcCategoria = "IVA EXENTO"
										loCliente.nInscripto = 5

									Case Inlist( lnImpuesto, 33 )
										lcCategoria = "IVA RESPONSABLE NO INSCRIPTO"
										loCliente.nInscripto = 4

										*!*									Case Inlist( lnImpuesto, 34 )
										*!*										lcCategoria = "IVA NO ALCANZADO"
										*!*										loCliente.nInscripto = 8

									Otherwise
										lcCategoria = "NO INFORMADO"
										loCliente.nInscripto = 9

										If llExistImpuestos_Afip_IVA
											lcCategoria = Impuestos_Afip_IVA.nombre
										Endif

								Endcase

								loCliente.nImpuesto = lnImpuesto
								loCliente.cImpuesto = lcCategoria

								Exit

							Endif

						Endfor

						loCliente.cNOMBRE 		= loPersona.Data.nombre
						loCliente.cDireccion 	= loPersona.Data.DomicilioFiscal.Direccion
						loCliente.cLocalidad 	= loPersona.Data.DomicilioFiscal.Localidad
						loCliente.idProvincia 	= Provincias_Afip[ loPersona.Data.DomicilioFiscal.idProvincia + 1 ]
						loCliente.cCodPostal 	= Transform( loPersona.Data.DomicilioFiscal.CodPostal )

						If loPersona.Data.EstadoClave = "INACTIVA"

							TEXT To lcMsg NoShow TextMerge Pretext 03
							Razón Social: <<loCliente.cNombre>>
							Dirección: <<loCliente.cDireccion>>
							Localidad: <<loCliente.cLocalidad>>
							Provincia: <<ZONAS[ loCliente.idProvincia ]>>
							Código Postal: <<loCliente.cCodPostal>>

							Categoría: <<lcCategoria>>

							* * *     ATENCION    * * *
							*         INACTIVA        *
							ENDTEXT


							lcErrorMessage = "CUIT INACTIVO"
							If lMessage
								Warning( lcMsg, "CUIT INACTIVO", -1 )
							Endif


						Endif

					Else

						lcErrorMessage = loPersona.Error.Mensaje
						If lMessage
							Warning( lcErrorMessage, "ATENCION", -1 )
						Endif

						loCliente.cErrorMessage = lcErrorMessage

						llOk = .F.

					Endif
				Endif
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loPersona 			= Null
			loCliente 			= Null
			loConsultasAFIP 	= Null
			loImpuestos 		= Null
			loGlobalSettings 	= Null

		Endtry

		Return llOk

	Endproc && xxxCuitValido





	*
	* cCodigoBarras_Access
	Protected Procedure cCodigoBarras_Access()
		Local lcCodigoBarras As String
		Local lcCommand As String

		Local loFE As "WsAfipFe.factura"

		Try

			lcCommand = ""


			Try

				loFE = This.oFE
				This.cCodigoBarras = loFE.f1CodigoDeBarraAFIP


			Catch To oErr
				* RA 02/10/2019(10:45:24)
				* Versiones viejas no tienen la propiedad f1CodigoDeBarraAFIP

				If Empty( This.oComprobante.CodigoAfip )
					This.oComprobante.CodigoAfip = This.GetCodigoComprobante( This.oComprobante )
				Endif

				lcCodigoBarras = Padr( Alltrim( Strtran( This.cCuitEmisor, "-", "" )),11,"0" )
				lcCodigoBarras = lcCodigoBarras + StrZero( This.oComprobante.CodigoAfip, 2 )
				lcCodigoBarras = lcCodigoBarras + StrZero( This.nPuntoDeVenta, 4 )
				lcCodigoBarras = lcCodigoBarras + This.cCAE
				lcCodigoBarras = lcCodigoBarras + Dtos( This.dFechaVencimientoCAE )

				This.cCodigoBarras = lcCodigoBarras

			Finally

			Endtry



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loFE = Null


		Endtry


		Return This.cCodigoBarras

	Endproc && cCodigoBarras_Access

	*
	* cVersion_Access
	Protected Procedure cVersion_Access()
		Local lcCommand As String
		Local loFE As "WsAfipFe.factura"

		Try

			lcCommand = ""
			If Empty( This.cVersion )
				loFE = This.oFE
				This.cVersion = loFE.Revision
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loFE = Null

		Endtry

		Return This.cVersion

	Endproc && cVersion_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: prxWSFEv1
*!*
*!* ///////////////////////////////////////////////////////

