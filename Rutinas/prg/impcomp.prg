Local lcCommand As String,;
	lcTextBody As String

Local loMail As oEMail Of "Tools\Email\Prg\prxSmtp.prg",;
	loMailSettings As oMailSettings Of "Tools\Email\Prg\prxSmtp.prg",;
	loPrintObj As ImprimirComprobante Of "Rutinas\Prg\ImpComp.prg",;
	loComprobante As Object

Try

	lcCommand = ""

	loApp = NewApp()
	DRVA = "s:\Fenix\dbf\DBF\"
	DRCOMUN = DRVA
	DRVD = "z:\Fenix\xxx\"

	loComprobante = Createobject( "Empty" )
	AddProperty( loComprobante, "nComprobante", 1 )
	AddProperty( loComprobante, "cTipo", 		"A" )
	AddProperty( loComprobante, "nSucursal", 	2 )
	AddProperty( loComprobante, "nNumero", 		697 )
	AddProperty( loComprobante, "cMailTo", 		"raidelman@gmail.com" )
	AddProperty( loComprobante, "cMailCC", 		"ricardo.aidelman@mug.org.ar" )
	AddProperty( loComprobante, "lSendEMail",    .F. )

	lcTextBody = GetValue( "LeyendaFE", "ar0Lta", "" )

	loPrintObj = Newobject( "ImprimirComprobante", "Rutinas\Prg\ImpComp.prg" )
	loPrintObj.lSendEMail = .T.

	loMailSettings = loPrintObj.oMailSettings
	loMailSettings.cTo 	= Alltrim( loComprobante.cMailTo )
	loMailSettings.cCC 	= Alltrim( loComprobante.cMailCC )
	loMailSettings.cBCC = Alltrim( loMailSettings.cFrom )

	TEXT To loMailSettings.cTextBody NoShow TextMerge Pretext 03
	Enviado automáticamente desde LA TOALLERA ARGENTINA

	Buenos Aires,  <<DateMask()>> ( <<Time()>> )

	<<lcTextBody>>
	ENDTEXT

	TEXT To loMailSettings.cSubject NoShow TextMerge Pretext 15
	Comprobante Electrónico FCA 0002-00000697
	ENDTEXT


	loPrintObj.SendEMail( "" )


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )

Finally
	loComprobante 	= Null
	loMailSettings 	= Null
	loMail 			= Null
	loPrintObj 		= Null
	loApp 			= Null

Endtry


*!* ///////////////////////////////////////////////////////
*!* Class.........: ImprimirComprobante
*!* ParentClass...: prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....: Custom
*!* Description...: Genera los cursores para poder imprimir los comprobantes
*!* Date..........: Martes 14 de Septiembre de 2010 (11:02:45)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*



#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\eMail\Include\eMail.h"


Define Class ImprimirComprobante As prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\prxBaseLibrary.prg'

	#If .F.
		Local This As ImprimirComprobante Of "V:\Clipper2fox\Rutinas\Prg\ImpComp.prg"
	#Endif

	* Comando que se ejecuta para imprimir el reporte
	cPrintCommand = ""

	* Nombre del archivo Frx
	cFrxFileName = ""

	* Parametros de impresion
	cPrintParameters = ""

	* Cantidad de copias a imprimir
	nCopias = 1

	* Impresora de salida
	cPrinter = ""

	* Impresora predeterminada
	cDefaultPrinter = ""


	* Indica si envía el original a PDF
	lImprimePDF = .F.

	* Indica si mustra la ventana de dialogo para que confirme el nombre del pdf
	lConfirmaNombrePDF = .F.

	* Referencia  al objeto PDFCreator
	oPDF = Null

	* Semaforo
	lSetToPDFCreator = .F.

	* Carpeta donde se guardan los PDF
	cPDFFolder = ""

	* Carpeta donde se guardan los FRX
	cFRXFolder = ""

	* Nombre del archivo PDF que se va a crear
	cPDFFileName = ""

	* Indica si abre y muestra el archivo PDF despues de crearlo
	lAbrirPDF = .F.



	* Semaforo
	lOnDestroy = .F.

	* Código del proveedor
	nCodigo = 0

	* Indica si es reimpresion
	lReImpre = .F.

	* Cantidad de lineas del vector Zonas
	nZonas = 1

	* Cantidad de lineas del vector Ivas
	nIvas = 1

	* Vuelve a cargar DRVFRX por si cambia al cambiar de sucursal.

	*	DRVFRX=Alltrim( GetValue( "RUTAFRX", "ar0var", DRVFRX ) )




	* Selecciona la salida
	*!*	_FRX_PREVIEW			1
	*!*	_FRX_PRINTER			2
	*!*	_FRX_DEFAULT_PRINTER	3

	nOutput = _FRX_PREVIEW

	* Indica si cierra el trabajo luego de imprimir la ultima hoja
	lCloseJob = .T.


	* Indica si envía un eMail luego de generar el PDF
	lSendEMail = .F.

	* Parametros de Setup para enviar mails
	oMailSettings = Null


	* Parámetros del comprobante a imprimir (Opcional)
	* Si existe, prevalece por sobre los parámetros tradicionales
	oComprobante = Null


	* Para desarrollo
	lCrearXML = .F.

	WCLAV = " "

	* Flag que controla los pasos de la impresión
	lIsOk = .T.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lcrearxml" type="property" display="lCrearXML" />] + ;
		[<memberdata name="obtenerobjetocomprobante" type="method" display="ObtenerObjetoComprobante" />] + ;
		[<memberdata name="ocomprobante" type="property" display="oComprobante" />] + ;
		[<memberdata name="lclosejob" type="property" display="lCloseJob" />] + ;
		[<memberdata name="noutput" type="property" display="nOutput" />] + ;
		[<memberdata name="londestroy" type="property" display="lOnDestroy" />] + ;
		[<memberdata name="cpdffilename" type="property" display="cPDFFileName" />] + ;
		[<memberdata name="cpdffolder" type="property" display="cPDFFolder" />] + ;
		[<memberdata name="labrirpdf" type="property" display="lAbrirPDF" />] + ;
		[<memberdata name="cfrxfolder" type="property" display="cFRXFolder" />] + ;
		[<memberdata name="lsettopdfcreator" type="property" display="lSetToPDFCreator" />] + ;
		[<memberdata name="limprimepdf" type="property" display="lImprimePDF" />] + ;
		[<memberdata name="cprinter" type="property" display="cPrinter" />] + ;
		[<memberdata name="cprintparameters" type="property" display="cPrintParameters" />] + ;
		[<memberdata name="cprintcommand" type="property" display="cPrintCommand" />] + ;
		[<memberdata name="printreport" type="method" display="PrintReport" />] + ;
		[<memberdata name="hookbeforeprint" type="method" display="HookBeforePrint" />] + ;
		[<memberdata name="ncopias" type="property" display="nCopias" />] + ;
		[<memberdata name="hookbeforeimprimir" type="method" display="HookBeforeImprimir" />] + ;
		[<memberdata name="imprimir" type="method" display="Imprimir" />] + ;
		[<memberdata name="reportsetup" type="method" display="ReportSetup" />] + ;
		[<memberdata name="cfgfactura" type="method" display="CfgFactura" />] + ;
		[<memberdata name="cfgproforma" type="method" display="CfgProforma" />] + ;
		[<memberdata name="cfgpresupuesto" type="method" display="CfgPresupuesto" />] + ;
		[<memberdata name="cfgremito" type="method" display="CfgRemito" />] + ;
		[<memberdata name="datosempresa" type="method" display="DatosEmpresa" />] + ;
		[<memberdata name="crearxml" type="method" display="CrearXML" />] + ;
		[<memberdata name="generarxml" type="method" display="GenerarXML" />] + ;
		[<memberdata name="imprimirpdf" type="method" display="ImprimirPDF" />] + ;
		[<memberdata name="hookbeforeprintpdf" type="method" display="HookBeforePrintPdf" />] + ;
		[<memberdata name="opdf" type="property" display="oPDF" />] + ;
		[<memberdata name="opdf_access" type="method" display="oPDF_Access" />] + ;
		[<memberdata name="cfrxfilename" type="property" display="cFrxFileName" />] + ;
		[<memberdata name="cdefaultprinter" type="property" display="cDefaultPrinter" />] + ;
		[<memberdata name="ncodigo" type="property" display="nCodigo" />] + ;
		[<memberdata name="lreimpre" type="property" display="lReImpre" />] + ;
		[<memberdata name="nivas" type="property" display="nIvas" />] + ;
		[<memberdata name="nzonas" type="property" display="nZonas" />] + ;
		[<memberdata name="lconfirmanombrepdf" type="property" display="lConfirmaNombrePDF" />] + ;
		[<memberdata name="lsendemail" type="property" display="lSendEMail" />] + ;
		[<memberdata name="sendemail" type="method" display="SendEMail" />] + ;
		[<memberdata name="omailsettings" type="property" display="oMailSettings" />] + ;
		[<memberdata name="omailsettings_access" type="method" display="oMailSettings_Access" />] + ;
		[<memberdata name="newcomprobante" type="method" display="NewComprobante" />] + ;
		[<memberdata name="wclav" type="property" display="WCLAV" />] + ;
		[<memberdata name="lisok" type="property" display="lIsOk" />] + ;
		[</VFPData>]

	Procedure Init()
		If Vartype( DRVFRX ) # "C"
			DRVFRX = ""
		Endif

		This.cFRXFolder = Alltrim( GetValue( "RUTAFRX", "ar0var", DRVFRX ) )

		Return
	Endproc

	*
	*
	Procedure HookBeforeImprimir( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer,;
			tnCopias As Integer,;
			tnCodigo As Integer ) As Void

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

	Endproc && HookBeforeImprimir

	*
	* Imprime un comprobante
	Procedure Imprimir( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer,;
			tnCopias As Integer,;
			tnCodigo As Integer ) As Void;
			HELPSTRING "Imprime un comprobante"

		Local loForm As Form,;
			loFormAux As Form

		Local lcAlias As String

		Try


			This.nZonas = Alen( Zonas, 1 )
			This.nIvas = Alen( Ivas, 1 )

			This.HookBeforeImprimir( tnComprobanteId,;
				tnComprobante,;
				tcTipo,;
				tnPtoVenta,;
				tnNumero,;
				tnCopias,;
				tnCodigo )

			If This.lIsOk

				If Isnull( This.oComprobante )

					If Vartype( tnCopias ) # "N"
						tnCopias = This.nCopias
					Endif

					This.nCopias = tnCopias

					This.ReportSetup( tnComprobanteId,;
						tnComprobante,;
						tcTipo,;
						tnPtoVenta,;
						tnNumero,;
						tnCodigo )

					If This.lIsOk

						lcAlias = Alias()

						This.DatosEmpresa()

						If This.lCrearXML
							This.CrearXML() && Para desarrollo y poder ver como se crearon los cursores.
						Endif

						If Used( lcAlias )
							Select Alias( lcAlias )
						Endif

						This.PrintReport(tnComprobanteId,tnCopias)

					Endif

				Else
					This.nCopias = This.oComprobante.nCopias

					This.lImprimePDF 	= This.oComprobante.lImprimePDF
					This.cPDFFileName 	= This.oComprobante.cPDFFileName
					This.cPDFFolder 	= This.oComprobante.cPDFFolder
					This.lSendEMail 	= This.oComprobante.lSendEMail
					This.oMailSettings 	= This.oComprobante.oMailSettings

					If This.ReportSetup()

						lcAlias = Alias()
						This.DatosEmpresa()

						If This.lCrearXML
							This.CrearXML() && Para desarrollo y poder ver como se crearon los cursores.
						Endif

						If Used( lcAlias )
							Select Alias( lcAlias )
						Endif

						This.PrintReport(tnComprobanteId,tnCopias)

					Endif

				Endif
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Wait Clear

			Use In Select( "cDetalle" )

		Endtry

	Endproc && Imprimir



	*
	* Carga un cursor con los datos de la empresa
	Procedure DatosEmpresa() As Void;
			HELPSTRING "Carga un cursor con los datos de la empresa"

		Local lcAlias As String


		Try


			lcAlias = Alias()

			If !Used( "ar0Est" )
				Use ( DRVA + "ar0Est" ) Shared In 0
			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
				Select Alltrim( Est.Nomb0 ) as RazonSocial,
					Est.Domi0 as DomicilioComercial,
					Est.Loca0 as Localidad,
					Est.CPos0 as CodigoPostal,
					Zonas[ Est.Prov0 ] as Provincia,
					Est.Tele0 as Telefono,
					Ivas[ Est.Insc0 ] as CondicionFrenteAlIva,
					Est.Cuit0 as Cuit,
					Est.Brut0 as IngresosBrutos,
					Est.Jubi0 as Jubilacion,
					Est.Fech0 as InicioActividades
				From Ar0est Est
				Into Cursor cEmpresa ReadWrite
			ENDTEXT

			&lcCommand


			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Cursor cGlobal (
				CopiaNro C(30) )
			ENDTEXT

			&lcCommand

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Insert Into cGlobal (
				CopiaNro ) Value (
				"ORIGINAL" )
			ENDTEXT

			&lcCommand


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			If !Empty( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

	Endproc && DatosEmpresa



	*
	* Crea un XML para pruebas con ReportTest
	Procedure CrearXML( cFileName As String ) As Void;
			HELPSTRING "Crea un XML para pruebas con ReportTest"

		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"
		Local lcFileName As String


		Try

			If Empty( cFileName )
				cFileName = "xmlComprobante"
			Endif

			lcFileName = Putfile( "", cFileName, "Xml" )

			If !Empty( lcFileName )

				If !Used( "cEmpresa" )
					This.DatosEmpresa()
				Endif

				loXA = Newobject("prxXMLAdapter","prxXMLAdapter.prg")

				loXA.AddTableSchema( "cCabeza" )
				loXA.AddTableSchema( "cDetalle" )
				loXA.AddTableSchema( "cEmpresa" )
				loXA.AddTableSchema( "cGlobal" )


				loXA.PreserveWhiteSpace = .T.
				loXA.ToXML( lcFileName, "", .T. )

				Select Alias( "cCabeza" )
				Locate

				Select Alias( "cEmpresa" )
				Locate

				Select Alias( "cGlobal" )
				Locate

				Select Alias( "cDetalle" )
				Locate

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loXA = Null

		Endtry

	Endproc && CrearXML


	*
	* Configura el reporte
	Procedure ReportSetup( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer,;
			tnCodigo As Integer ) As Void;
			HELPSTRING "Configura el reporte"

		Local lcError As String,;
			lcCommand As String

		Local llOk As Boolean

		Try

			lcCommand 	= ""
			lcAlias 	= ""
			llOk 		= .F.

			If Isnull( This.oComprobante )

				llOk = .T.

				Do Case
					Case tnComprobanteId = FRX_FACTURA
						This.cFrxFileName = Addbs( This.cFRXFolder ) + "Factura.frx"
						This.CfgFactura( tnComprobanteId,;
							tnComprobante,;
							tcTipo,;
							tnPtoVenta,;
							tnNumero )

					Case tnComprobanteId = FRX_MEMO
						This.cFrxFileName = Addbs( This.cFRXFolder ) + "frxMemo.frx"
						This.CfgMemo( tnComprobanteId,;
							tnComprobante,;
							tcTipo,;
							tnPtoVenta,;
							tnNumero )

					Case tnComprobanteId = FRX_PROFORMA
						This.CfgProforma( tnComprobanteId,;
							tnComprobante,;
							tcTipo,;
							tnPtoVenta,;
							tnNumero )

					Case tnComprobanteId = FRX_PRESUPUESTO
						This.CfgPresupuesto( tnComprobanteId,;
							tnComprobante,;
							tcTipo,;
							tnPtoVenta,;
							tnNumero )

					Case tnComprobanteId = FRX_REMITO
						This.CfgRemito( tnComprobanteId,;
							tnComprobante,;
							tcTipo,;
							tnPtoVenta,;
							tnNumero )

					Case tnComprobanteId = FRX_FACTURA_ELECTRONICA

						Do Case
							Case tnComprobante=1
								lcPDFFileName = "FC"

							Case tnComprobante=2
								lcPDFFileName = "ND"

							Case tnComprobante=3
								lcPDFFileName = "NC"

						Endcase

						lcPDFFileName = lcPDFFileName + tcTipo
						lcPDFFileName = lcPDFFileName + " " + StrZero( tnPtoVenta, 4 )
						lcPDFFileName = lcPDFFileName + "-" + StrZero( tnNumero, 8 )





						This.CfgFacturaElectronica( tnComprobanteId,;
							tnComprobante,;
							tcTipo,;
							tnPtoVenta,;
							tnNumero )




					Case tnComprobanteId = FRX_ORDEN_DE_COMPRA
						This.CfgOrdenDeCompra( tnComprobanteId,;
							tnComprobante,;
							tcTipo,;
							tnPtoVenta,;
							tnNumero )

					Otherwise
						TEXT To lcError NoShow TextMerge Pretext 15
					Tipo de comprobante <<tnComprobanteId>> NO SOPORTADO
						ENDTEXT

						Error lcError

				Endcase

			Else


				TEXT To lcCommand NoShow TextMerge Pretext 15
				llOk = This.<<This.oComprobante.cMetodo>>()
				ENDTEXT

				&lcCommand
				lcCommand = ""

				If This.lReporte And llOk
					lcAlias = Alias()
					If Inlist( This.oComprobante.nOutput, _FRX_PRINTER, _FRX_DEFAULT_PRINTER )
						This.cPrinter 	= SelectPrinter( This.oComprobante.cPrinter )
					Endif

					This.nOutput 	= This.oComprobante.nOutput

				Endif


			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif


		Endtry

		Return llOk

	Endproc && ReportSetup


	*
	* configuracion Remito
	Procedure CfgRemito( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer ) As Void;
			HELPSTRING "configuracion Remito"
		Local lcKey As String
		Local lcCabeza As String
		Local lcItems As String
		Local lcFilterCriteria As String
		Local lcComprobante As String
		Local lcSigno As String
		Local lnCliente As Integer
		Local lcCommand As String
		Local llReimpre As Boolean

		Try

			Try

				lcCommand = ""
				llReimpre = This.lReImpre

				* Traer la Cabecera
				lcCabeza = Sys( 2015 )
				lcKey = Str( tnComprobante, 2) + tcTipo + Str( tnPtoVenta, 2 ) + Str( tnNumero, 6 )

				Select AR7Rem
				Set Order To 1
				Seek lcKey

				If !Found()
					Error "Comprobante NO ENCONTRADO ( " + lcKey + " )"
				Endif

				TEXT To lcFilterCriteria NoShow TextMerge Pretext 15
					( ar7rem.comp7 = <<tnComprobante>> )
					And ( ar7rem.tipo7 = '<<tcTipo>>' )
					And ( ar7rem.sucu7 = <<tnPtoVenta>> )
					And ( ar7rem.nume7 = <<tnNumero>> )
				ENDTEXT

				AppendFromCursor( "ar7rem",;
					lcCabeza,;
					lcFilterCriteria,;
					.T. )

				* Traer los items
				lnCliente = Evaluate( lcCabeza + ".Codi7" )

				* Traer los Items
				lcItems = Sys( 2015 )
				lcKey = Str( tnComprobante, 2) + tcTipo + Str( tnPtoVenta, 2 ) + Str( tnNumero, 6 ) + Str( lnCliente, gnCodi4 )

				Select ar9rem
				Set Order To 1
				Seek lcKey

				TEXT To lcFilterCriteria NoShow TextMerge Pretext 15
					( ar9rem.comp9 = <<tnComprobante>> )
					And ( ar9rem.tipo9 = '<<tcTipo>>' )
					And ( ar9rem.sucu9 = <<tnPtoVenta>> )
					And ( ar9rem.nume9 = <<tnNumero>> )
					And ( ar9rem.codi9 = <<lnCliente>> )
				ENDTEXT


				AppendFromCursor( "ar9rem",;
					lcItems,;
					lcFilterCriteria,;
					.T. )

				*!*	                AppendFromCursor( WARCH,;
				*!*	                    lcItems )

				* Armar cursor de impresion
				*!*	                Do Case
				*!*	                    Case tnComprobante = 1
				*!*	                        lcComprobante = "FACTURA"

				*!*	                    Case tnComprobante = 2
				*!*	                        lcComprobante = "N.DEBITO"

				*!*	                    Case tnComprobante = 3
				*!*	                        lcComprobante = "N.CREDITO"

				*!*	                    Otherwise
				*!*	                        lcComprobante = ""
				*!*	                Endcase
				lcComprobante = "REMITO"


				TEXT To lcCommand NoShow TextMerge Pretext 15
					Select Vta.Fech7 as Fecha,
						lcComprobante As Comprobante,
						Vta.Tipo7 as Tipo,
						Vta.Sucu7 as PuntoDeVenta,
						Vta.Nume7 as NumeroComprobante,
						Vta.Codi7 as ClienteCodigo,
						Vta.Nomb7 as ClienteNombre,
						Vta.Ocom7 as OrdenDeCompra,
						Vta.Domi7 as ClienteDomicilio,
						Vta.Zona7 as ClienteProvinciaCodigo,
						ZONAS[ Vta.Zona7 ] as ClienteProvinciaNombre,
						Cli.CPOS4 as ClienteCodigoPostal,
						Cli.LOCA4 as ClienteLocalidad,
						IVAS[ Vta.Insc7 ] as ClienteInscripcionIva,
						Vta.Cuit7 as ClienteCuit,
						Iif( llReimpre, Space(1), WNOMT ) As TransporteNombre,
						Iif( llReimpre, Space(1), WTCUI ) As TransporteCuit,
						Iif( llReimpre, Space(1), WDOMT ) As TransporteDomicilio,
						Iif( llReimpre, Space(1), ZONAS[ WZONT ] ) As TransporteProvincia,
						Iif( llReimpre, Space(1), Alltrim( WLOCT ) + " - " + Alltrim( ZONAS[WZONR] ) ) As TransporteLocalidad,
						Iif( llReimpre, Space(1), WBULT ) As Bultos,
						Iif( llReimpre, Space(1), WSEGU ) As ValorDeclarado
					From <<lcCabeza>> Vta
						Left Outer Join Ar4Var Cli
							On Cli.Tipo4 = '1' And Cli.Codi4 = Vta.Codi7
					Into Cursor cCabeza ReadWrite
				ENDTEXT

				&lcCommand

				TEXT To lcCommand NoShow TextMerge Pretext 15
					Select Ite.Arti9 as ArticuloCodigo,
						Ite.Desc9 as ArticuloDescripcion,
						Ite.Cant9 as Cantidad,
						Ite.Unid9 As Unidad,
						Ite.Lote9 as Lote1,
						Ite.Lot29 as Lote2,
						Ite.Desp9 as Despacho
					From <<lcItems>> Ite
					Into Cursor cDetalle ReadWrite
				ENDTEXT

				&lcCommand

				Select cDetalle
				Locate


			Catch To loErr
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = lcCommand
				loError.Process ( m.loErr )
				Throw loError

			Finally

			Endtry


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && CfgRemito

	*
	* Configuracion Presupuesto
	Procedure CfgPresupuesto( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer ) As Void;
			HELPSTRING "Configuracion Presupuesto"
		Try


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && CfgPresupuesto


	*
	* Configuracion Proforma
	Procedure CfgProforma( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer ) As Void;
			HELPSTRING "Configuracion Proforma"
		Try


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && CfgProforma

	*
	* Configuracion Factura
	Procedure CfgFactura( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer ) As Void;
			HELPSTRING "Configuracion Factura"

		Local lcKey As String
		Local lcCabeza As String
		Local lcItems As String
		Local lcFilterCriteria As String
		Local lcComprobante As String
		Local lcSigno As String
		Local lnCliente As Integer
		Local lcCommand As String
		Local lcCae As String
		Local ldVencEle As Date
		Local lnCompFE As Integer

		Try

			Try

				lcCommand = ""

				lcCae = ""
				ldVencEle = Ctod("")
				lnCompFE = 0

				* Traer la Cabecera
				lcCabeza = Sys( 2015 )
				lcKey = Str( tnComprobante, 2) + tcTipo + Str( tnPtoVenta, 2 ) + Str( tnNumero, 6 ) + Str( 0, 1 )

				Select AR7Ven
				Set Order To 1
				Seek lcKey

				If !Found()
					Error "Comprobante NO ENCONTRADO ( " + lcKey + " )"
				Endif

				TEXT To lcFilterCriteria NoShow TextMerge Pretext 15
					( ar7ven.comp7 = <<tnComprobante>> )
					And ( ar7ven.tipo7 = '<<tcTipo>>' )
					And ( ar7ven.sucu7 = <<tnPtoVenta>> )
					And ( ar7ven.nume7 = <<tnNumero>> )
					And ( ar7ven.vcto7 = 0 )
				ENDTEXT

				AppendFromCursor( "ar7ven",;
					lcCabeza,;
					lcFilterCriteria,;
					.T. )

				lnCliente = Evaluate( lcCabeza + ".Codi7" )

				* Traer los Items
				lcItems = Sys( 2015 )
				lcKey = Str( tnComprobante, 2) + tcTipo + Str( tnPtoVenta, 4 ) + Str( tnNumero, 8 ) + Str( lnCliente, gnCodi4 )

				Select ar9ite
				Set Order To 1
				Seek lcKey

				TEXT To lcFilterCriteria NoShow TextMerge Pretext 15
					( ar9ite.comp9 = <<tnComprobante>> )
					And ( ar9ite.tipo9 = '<<tcTipo>>' )
					And ( ar9ite.sucu9 = <<tnPtoVenta>> )
					And ( ar9ite.nume9 = <<tnNumero>> )
					And ( ar9ite.codi9 = <<lnCliente>> )
				ENDTEXT


				AppendFromCursor( "ar9ite",;
					lcItems,;
					lcFilterCriteria,;
					.T. )

				* Armar cursor de impresion
				Do Case
					Case tnComprobante = 1
						lcComprobante = "FACTURA"

					Case tnComprobante = 2
						lcComprobante = "N.DEBITO"

					Case tnComprobante = 3
						lcComprobante = "N.CREDITO"

					Otherwise
						lcComprobante = ""
				Endcase

				TEXT To lcCommand NoShow TextMerge Pretext 15
					Select Vta.Fech7 as Fecha,
						lcComprobante As  Comprobante,
						Vta.Tipo7 as Tipo,
						Vta.Sucu7 as PuntoDeVenta,
						Vta.Nume7 as NumeroComprobante,
						Vta.Venc7 as Vencimiento,
						Vta.Codi7 as ClienteCodigo,
						Vta.Nomb7 as ClienteNombre,
						Vta.Ocom7 as OrdenDeCompra,
						Vta.Domi7 as ClienteDomicilio,
						Vta.Zona7 as ClienteProvinciaCodigo,
						ZONAS[ Vta.Zona7 ] as ClienteProvinciaNombre,
						Cli.CPOS4 as ClienteCodigoPostal,
						Cli.LOCA4 as ClienteLocalidad,
						IVAS[ Vta.Insc7 ] as ClienteInscripcionIva,
						Vta.Cuit7 as ClienteCuit,
						Vta.Cond7 as CondicionVenta,
						Vta.Remi7 as NumeroRemito,
						Vta.Remc7 as ListaRemitos,
						Vta.Impo7 as Importe,
						Vta.Subt7 as Subtotal,
						Vta.Dcto7 as Descuento,
						Vta.Tdct7 as TasaDescuento,
						Vta.Neto7 as Neto,
						Vta.IIva7 as IvaInscripto,
						Vta.IIvn7 as IvaNoInscripto,
						Vta.TDct7 as PorcentajeDescuento,
						Vta.TIva7 as TasaIvaInscripto,
						Vta.TIvn7 as TasaIvaNoInscripto,
						Vta.Vend7 as VendedorCodigo,
						Ven.Nomb4 as VendedorNombre,
						Vta.Dola7 as MonedaCotizacion,
						Vta.Mone7 as MonedaCodigo,
						Mon.Nomb4 as MonedaNombre,
						Mon.Sign4 as MonedaSigno,
						lcCae As Cae,
						lnCompFE as CompFE,
						ldVencEle As CaeVenc,
						Vta.Dcto7 as DTOIMPORTE,
					From <<lcCabeza>> Vta
						Left Outer Join Ar4Var Cli
							On Cli.Tipo4 = '1' And Cli.Codi4 = Vta.Codi7
						Left Outer Join Ar4Var Ven
							On Ven.Tipo4 = '3' And Ven.Codi4 = Vta.Vend7
						Left Outer Join Ar4Var Mon
							On Mon.Tipo4 = 'M' And Mon.Codi4 = Vta.Mone7
					Into Cursor cCabeza ReadWrite
				ENDTEXT

				&lcCommand

				lcSigno = Evaluate( "cCabeza.MonedaSigno" )

				TEXT To lcCommand NoShow TextMerge Pretext 15
					Select Ite.Arti9 as ArticuloCodigo,
						Ite.Desc9 as ArticuloDescripcion,
						Ite.Cant9 as Cantidad,
						Ite.Unid9 as Unidad,
						Ite.Prec9 as PrecioUnitario,
						Ite.DtoI9 as DescuentoItem,
						Ite.Ocom9 as OrdenCompra,
						lcSigno   as MonedaSigno
					From <<lcItems>> Ite
					Into Cursor cDetalle ReadWrite
				ENDTEXT

				&lcCommand

				Select cDetalle
				Locate


			Catch To loErr
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = lcCommand
				loError.Process ( m.loErr )
				Throw loError

			Finally

			Endtry


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && CfgFactura

	*
	* Configuracion Factura Electronica
	Procedure CfgFacturaElectronica( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer ) As Void;
			HELPSTRING "Configuracion Factura"

		Local lcKey As String
		Local lcCabeza As String
		Local lcItems As String
		Local lcFilterCriteria As String
		Local lcComprobante As String
		Local lcSigno As String
		Local lnCliente As Integer
		Local lcCommand As String

		Try

			Try

				lcCommand = ""

				* Traer la Cabecera
				lcCabeza = Sys( 2015 )
				lcKey = Str( tnComprobante, 2) + tcTipo + Str( tnPtoVenta, 2 ) + Str( tnNumero, 6 ) + Str( 0, 1 )

				Select AR7Ven
				Set Order To 1
				Seek lcKey

				If !Found()
					Error "Comprobante NO ENCONTRADO ( " + lcKey + " )"
				Endif

				TEXT To lcFilterCriteria NoShow TextMerge Pretext 15
					( ar7ven.comp7 = <<tnComprobante>> )
					And ( ar7ven.tipo7 = '<<tcTipo>>' )
					And ( ar7ven.sucu7 = <<tnPtoVenta>> )
					And ( ar7ven.nume7 = <<tnNumero>> )
					And ( ar7ven.vcto7 = 0 )
				ENDTEXT

				AppendFromCursor( "ar7ven",;
					lcCabeza,;
					lcFilterCriteria,;
					.T. )

				lnCliente = Evaluate( lcCabeza + ".Codi7" )

				* Traer los Items
				lcItems = Sys( 2015 )
				lcKey = Str( tnComprobante, 2) + tcTipo + Str( tnPtoVenta, 4 ) + Str( tnNumero, 8 ) + Str( lnCliente, gnCodi4 )

				Select ar9ite
				Set Order To 1
				Seek lcKey

				TEXT To lcFilterCriteria NoShow TextMerge Pretext 15
					( ar9ite.comp9 = <<tnComprobante>> )
					And ( ar9ite.tipo9 = '<<tcTipo>>' )
					And ( ar9ite.sucu9 = <<tnPtoVenta>> )
					And ( ar9ite.nume9 = <<tnNumero>> )
					And ( ar9ite.codi9 = <<lnCliente>> )
				ENDTEXT


				AppendFromCursor( "ar9ite",;
					lcItems,;
					lcFilterCriteria,;
					.T. )

				* Armar cursor de impresion
				Do Case
					Case tnComprobante = 1
						lcComprobante = "FACTURA"

					Case tnComprobante = 2
						lcComprobante = "N.DEBITO"

					Case tnComprobante = 3
						lcComprobante = "N.CREDITO"

					Otherwise
						lcComprobante = ""
				Endcase


				* Cabecera
				TEXT To lcCommand NoShow TextMerge Pretext 15
		 		Select  Vta.Fech7 as Fecha,
				 		Vta.Tipo7 as LetraComp,
				 		Vta.CodigoComp as CodigoComp,
				 		lcComprobante as DescCompro,
				 		Vta.Sucu7 as PuntoVta,
				 		Vta.Nume7 as NumeroComp,
				 		"( " + Transform( Vta.Codi7 ) + " ) " + Alltrim( Vta.Nomf7 ) as CliRazonSo,
				 		Vta.Domi7 as CliDomici,
				 		Vta.CPos7 as ClicPos,
				 		Vta.Loca7 as CliLoca,
				 		ZONAS[ Vta.Zona7 ] as cliProv,
				 		IVAS[ Vta.Insc7 ] as CliInscIva,
				 		Iif( Vta.Insc7 = 2 , "DNI: ", "Cuit: " ) + Alltrim( Vta.Cuit7 ) as CliDocumen,
				 		Vta.Cond7 as CondVenta,
				 		Vta.Cae7 as CAE,
				 		Vta.VencCae as CaeVenc,
				 		Vta.Subt7 as Subtotal,
				 		Vta.TDct7 as DtoTasa,
				 		Vta.Dcto7 as DtoImporte,
				 		Vta.Neto7 as Neto,
				 		Vta.TIva7 as IvaTasa,
				 		Vta.IIva7 as IvaImporte,
				 		Vta.Impo7 as Total,
				 		StrToI2of5( Vta.CgoBarra ) as CgoBarra,
				 		Alltrim( Vta.Ley71 ) as Leyenda1,
				 		Alltrim( Vta.Ley72 ) as Leyenda2,
				 		Alltrim( Vta.Ley73 ) as Leyenda3,
				 		Vta.Dola7 as Cotizacion,
				 		Vta.Mone7 as Moneda,
				 		Vta.Ocom7 as OCompra,
				 		Iif( Empty( Vta.Remi7 ), Vta.Remc7, StrZero( Vta.Remi7, 8 )) as Remito
					From <<lcCabeza>> Vta
					Into Cursor cCabeza ReadWrite
				ENDTEXT

				&lcCommand

				Select cCabeza

				If Moneda > 1
					Replace Subtotal With Round( Subtotal / Cotizacion, 2 ),;
						DtoImporte With Round( DtoImporte / Cotizacion, 2 ),;
						Neto With Round( Neto / Cotizacion, 2 ),;
						IvaImporte With Round( IvaImporte / Cotizacion, 2 ),;
						Total With Round( Total / Cotizacion, 2 )
				Endif


				* Detalle
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Select  Ite.Arti9 as ARTICOD,
						Ite.Desc9 as ARTIDESCR,
						Ite.Cant9 as CANTIDAD,
						Ite.Unid9 as Unidad,
						Ite.PrFa9 as PRECIOUNIT,
						Ite.DtoI9 as DTOITEM,
						Round(PrFa9*CANT9*(1-DTOI9/100),2) as IMPORTE,
						Ite.Lote9 as Lote1,
						Ite.Lot29 as Lote2,
						Ite.Desp9 as Despacho
				From <<lcItems>> Ite
				Into Cursor cDetalle ReadWrite
				ENDTEXT

				&lcCommand


				TEXT To lcCommand NoShow TextMerge Pretext 15
				Create Cursor cGlobal (
					CopiaNro C(30) )
				ENDTEXT

				&lcCommand

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Insert Into cGlobal (
					CopiaNro ) Value (
					"ORIGINAL" )
				ENDTEXT

				&lcCommand

				Select cDetalle
				Locate


			Catch To loErr
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = lcCommand
				loError.Process ( m.loErr )
				Throw loError

			Finally

			Endtry


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && CfgFacturaElectronica

	Procedure CfgMemo( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer ) As Void;
			HELPSTRING "Configuracion Memo"

		Local lcKey As String
		Local lcCabeza As String
		Local lcItems As String
		Local lcFilterCriteria As String
		Local lcComprobante As String
		Local lcSigno As String
		Local lnCliente As Integer
		Local lcCommand As String
		Local lcCae As String
		Local ldVencEle As Date
		Local lnCompFE As Integer
		Local lcSele As String

		Try

			lcCommand = ""

			* Traer la Cabecera
			lcCabeza = Sys( 2015 )
			lcKey = Str( tnComprobante, 2) + tcTipo + Str( tnPtoVenta, 2 ) + Str( tnNumero, 6 ) + Str( 0, 1 )

			Select XX7VEN
			lcSele="XX7VEN"

			Set Order To 1
			Seek lcKey

			If !Found()
				Error "Comprobante NO ENCONTRADO ( " + lcKey + " )"
			Endif

			TEXT To lcFilterCriteria NoShow TextMerge Pretext 15
					( <<lcSele>>.comp7 = <<tnComprobante>> )
					And ( <<lcSele>>.tipo7 = '<<tcTipo>>' )
					And ( <<lcSele>>.sucu7 = <<tnPtoVenta>> )
					And ( <<lcSele>>.nume7 = <<tnNumero>> )
					And ( <<lcSele>>.vcto7 = 0 )
			ENDTEXT


			AppendFromCursor( lcSele,;
				lcCabeza,;
				lcFilterCriteria,;
				.T. )

			lnCliente = Evaluate( lcCabeza + ".Codi7" )

			* Traer los Items
			lcItems = Sys( 2015 )
			lcKey = Str( tnComprobante, 2) + tcTipo + Str( tnPtoVenta, 4 ) + Str( tnNumero, 8 ) + Str( lnCliente, gnCodi4 )

			Select xx9ite
			lcSele="xx9ite"

			Set Order To 1
			Seek lcKey

			TEXT To lcFilterCriteria NoShow TextMerge Pretext 15
					( <<lcSele>>.comp9 = <<tnComprobante>> )
					And ( <<lcSele>>.tipo9 = '<<tcTipo>>' )
					And ( <<lcSele>>.sucu9 = <<tnPtoVenta>> )
					And ( <<lcSele>>.nume9 = <<tnNumero>> )
					And ( <<lcSele>>.codi9 = <<lnCliente>> )
			ENDTEXT

			AppendFromCursor( lcSele,;
				lcItems,;
				lcFilterCriteria,;
				.T. )

			* Armar cursor de impresion

			Do Case
				Case tnComprobante = 1
					lcComprobante = "ENTREGA"

				Case tnComprobante = 2
					lcComprobante = "ENTERGA ND."

				Case tnComprobante = 3
					lcComprobante = "ENTREGA NC."

				Otherwise
					lcComprobante = ""
			Endcase


			TEXT To lcCommand NoShow TextMerge Pretext 15
					Select Vta.Fech7 as Fecha,
						lcComprobante As Comprobante,
						Vta.Tipo7 as Tipo,
						Vta.Tipo7 as LetraComp,
						Vta.Sucu7 as PuntoDeVenta,
						Vta.Nume7 as NumeroComprobante,
						Vta.Venc7 as Vencimiento,
						Vta.Codi7 as ClienteCodigo,
						Vta.Nomb7 as ClienteNombre,
						Vta.Ocom7 as OrdenDeCompra,
						Vta.Domi7 as ClienteDomicilio,
						Vta.Zona7 as ClienteProvinciaCodigo,
						ZONAS[ Vta.Zona7 ] as ClienteProvinciaNombre,
						Cli.CPOS4 as ClienteCodigoPostal,
						Cli.LOCA4 as ClienteLocalidad,
						IVAS[ Vta.Insc7 ] as ClienteInscripcionIva,
						Vta.Cuit7 as ClienteCuit,
						Vta.Cond7 as CondicionVenta,
						Vta.Remi7 as NumeroRemito,
						Vta.Remc7 as ListaRemitos,
						Vta.Impo7 as Importe,
						Vta.Subt7 as Subtotal,
						Vta.Dcto7 as Descuento,
						Vta.Neto7 as Neto,
						Vta.IIva7 as ImporteIvaInscripto,
						Vta.IIvn7 as IvaNoInscripto,
						Vta.TDct7 as PorcentajeDescuento,
						Vta.TIva7 as TasaIvaInscripto,
						Vta.TIvn7 as TasaIvaNoInscripto,
						Vta.Vend7 as VendedorCodigo,
						Ven.Nomb4 as VendedorNombre,
						Vta.Dola7 as MonedaCotizacion,
						Vta.Mone7 as MonedaCodigo,
						Mon.Nomb4 as MonedaNombre,
						Mon.Sign4 as MonedaSigno,
						vta.dcto7 as DTOIMPORTE,
						tnComprobante as codigocomp,
						vta.tdct7 as DTOTASA
					from <<lcCabeza>> Vta
						Left Outer Join Ar4Var Cli
							On Cli.Tipo4 = '1' And Cli.Codi4 = Vta.Codi7
						Left Outer Join Ar4Var Ven
							On Ven.Tipo4 = '3' And Ven.Codi4 = Vta.Vend7
						Left Outer Join Ar4Var Mon
							On Mon.Tipo4 = 'M' And Mon.Codi4 = Vta.Mone7
					Into Cursor cCabeza ReadWrite
			ENDTEXT

			&lcCommand

			lcSigno = Evaluate( "cCabeza.MonedaSigno" )

			TEXT To lcCommand NoShow TextMerge Pretext 15
					Select prxArmArt( Ite.Grup9, Ite.Arti9 ) as ArticuloCodigo,
						Alltrim(Ite.Desc9)+" "+Ite.Desp9 as ArticuloDescripcion,
						Ite.Cant9 as Cantidad,
						Ite.Unid9 as Unidad,
						Ite.Prec9 as PrecioUnitario,
						Ite.DtoI9 as DescuentoItem,
						Ite.Ocom9 as OrdenCompra,
						lcSigno   as MonedaSigno,
					    Val(ite.arti9) as nItem
					From <<lcItems>> Ite
					Into Cursor cDetalle ReadWrite order by nItem
			ENDTEXT

			&lcCommand

			Select cDetalle
			Locate


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry


	Endproc && CfgMemo

	*
	* Configuracion OrdenDeCompra
	Procedure CfgOrdenDeCompra( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer ) As Void;
			HELPSTRING "Configuracion OrdenDeCompra"
		Try


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && CfgOrdenDeCompra


	*
	* Imprime el reporte
	Procedure PrintReport( tnComprobanteId As Integer,tnCopias As Integer ) As Void;
			HELPSTRING "Imprime el reporte"

		Local lcPrintCommand As String,;
			lcCommand As String,;
			lcAlias As String

		Local lnCopias As Integer,;
			i As Integer,;
			lnFirstPage As Integer
		Local Array laCopias[ 4 ]

		Local loReport As "PreviewHelper" Of "Tools\FoxyPreviewer\Source\FoxyPreviewer.Prg"
		Local llFoxyPreviewer As Boolean

		Local loForm As Form,;
			loFormAux As Form

		Try


			loForm = GetActiveForm()

			lcCommand = ""

			If This.lIsOk

				If This.nOutput = _FRX_PDF
					This.lImprimePDF 	= .T.
					This.nCopias 		= 0


				Endif

				* RA 2014-11-16(11:56:02)
				* Para desarrollo
				If This.nCopias = 99
					This.nCopias = 1
					This.nOutput = _FRX_PREVIEW
				Endif

				If Empty( This.cDefaultPrinter )
					This.cDefaultPrinter = Set("Printer",2)
				Endif

				If Upper( This.cDefaultPrinter ) = "PDFCREATOR" And This.nCopias = 1
					* RA 2013-03-24(14:33:33)
					* Si mi impresora predeterminada es PdfCreator
					This.nOutput = _FRX_PREVIEW


				Endif

				* RA 2013-11-15(13:35:05)
				* Si esta en vista previa y elige imprimir en el PDFCreator,
				* no puede generar automaticamente el PDF porque el PDFCreator se Cuelga

				If This.nOutput = _FRX_PREVIEW
					*This.lImprimePDF = .F.
				Endif

				lnCopias = This.nCopias
				lcAlias = Alias()

				If lnCopias > 0

					laCopias[ 1 ] = "ORIGINAL"
					laCopias[ 2 ] = "DUPLICADO"
					laCopias[ 3 ] = "TRIPLICADO"
					laCopias[ 4 ] = "COPIA Nº "

					If .T. && Thisform.PageFrame.Page3.cntDatosImpresion.chkImprimeOriginal.Value = .T.
						lnFirstPage = 1

					Else
						lnFirstPage = 2

					Endif


					*!*	_FRX_PREVIEW			1
					*!*	_FRX_PRINTER			2
					*!*	_FRX_DEFAULT_PRINTER	3

					If This.nOutput = _FRX_PRINTER

						Clear Typeahead
						If Empty( This.cPrinter )
							This.cPrinter = Getprinter()
						Endif

						If !Empty( This.cPrinter )
							Try

								TEXT To lcCommand NoShow TextMerge Pretext 15
								Set Printer To Name "<<This.cPrinter>>"
								ENDTEXT

								&lcCommand


							Catch To oErr
								If oErr.ErrorNo = 1957
									TEXT To lcMsg NoShow TextMerge Pretext 03
									Error al acceder a la impresora
									<<This.cPrinter>>

									Por favor, seleccione otra impresora
									ENDTEXT

									Wait Window Nowait Noclear lcMsg

									This.cPrinter = Getprinter()


								Else
									Throw oErr

								Endif

							Finally

							Endtry


						Else
							lnCopias = 0

						Endif

					Endif

					For i = lnFirstPage To lnCopias

						Do Case
							Case i = 1
								Do Case
									Case This.nOutput = _FRX_PREVIEW
										lcPrintCommand = "Prompt Nodialog Preview"

									Case lnCopias > 1 Or !This.lCloseJob
										lcPrintCommand = "Nodialog NoPageEject NoConsole"

									Otherwise
										lcPrintCommand = "NoDialog NoConsole"

								Endcase


							Case Between( i, 2, lnCopias - 1 ) Or !This.lCloseJob
								lcPrintCommand = "NoPageEject NoDialog NoConsole"


							Otherwise
								lcPrintCommand = "NoDialog NoConsole"

						Endcase

						If Used( "cGlobal" )
							* Nº de Copia
							Select cGlobal
							Locate
							Replace CopiaNro With Iif( i > 4, laCopias[ 4 ] + Transform( i ), laCopias[ i ] )
						Endif

						This.HookBeforePrint( i )

						If Used( lcAlias )
							Select Alias( lcAlias )
							If Empty( Reccount( lcAlias ))
								* RA 30/09/2018(13:57:56)
								* Si no tiene ningun registro en el Detalle, no se imprime nada
								* Así, por lo menos, imprime la cabecera y el pie con el detalle vacío
								Append Blank
							Endif
							Locate
						Endif

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Report Form "<<This.cFrxFileName>>"
						To Printer <<lcPrintCommand>>
						ENDTEXT

						*Strtofile( lcCommand, "Print_Command.prg" )

						llFoxyPreviewer = .F.

						If llFoxyPreviewer And This.nOutput = _FRX_PREVIEW
							*!*							loReport = Newobject( "PreviewHelper", "Tools\FoxyPreviewer\Source\FoxyPreviewer.Prg" )
							*!*							loReport.AddReport( This.cFrxFileName, "", lcAlias )
							*!*							loReport.RunReport()

						Else
							&lcCommand

						Endif


					Endfor


					If This.lCloseJob
						TEXT To lcCommand NoShow TextMerge Pretext 15
						Set Printer To Name "<<This.cDefaultPrinter>>"
						ENDTEXT

						&lcCommand
					Endif

				Endif
			Endif

			If This.lImprimePDF And This.lIsOk



				If Used( lcAlias )
					Select Alias( lcAlias )
					Locate
				Endif

				This.ImprimirPDF(tnComprobanteId,tnCopias)
			Endif


		Catch To loErr

			Try

				If This.lCloseJob
					TEXT To lcCommand1 NoShow TextMerge Pretext 15
					Set Printer To Name "<<This.cDefaultPrinter>>"
					ENDTEXT

					&lcCommand1
				Endif

			Catch To loErr

			Finally

			Endtry

			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )

			Do Case
				Case oErr.ErrorNo = 1 And !Empty( At( This.cFrxFileName, lcCommand ))
					TEXT To lcCommand NoShow TextMerge Pretext 15
				<<This.cFrxFileName>>
					ENDTEXT

				Otherwise

			Endcase

			loError.Cremark = lcCommand
			loError.Process( loErr )
			Throw loError

		Finally
			loReport = Null

			Try

				If !Isnull( loForm ) And _Screen.Visible = .T.
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Activate Window <<loForm.Name>>
					ENDTEXT

					&lcCommand

				Endif

			Catch To oErr

			Finally
				loFormAux 	= Null
				loForm 		= Null

			Endtry


		Endtry

	Endproc && PrintReport



	*
	* El programador puede hacer ajustes de ultima hora
	Procedure HookBeforePrint( nCopiaNro As Integer ) As Void;
			HELPSTRING "El programador puede hacer ajustes de ultima hora"
		Local lcCommand As String

		Try

			lcCommand = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && HookBeforePrint



	*
	*
	Procedure GenerarXML(  ) As Void
		Try

			* Habilitar para debuggear
			If .F.

				lcFileName = Putfile( "", "xmlComprobante", "XML" )

				If !Empty( lcFileName )

					loXA = Newobject("prxXMLAdapter","prxXMLAdapter.prg")

					loXA.AddTableSchema( "cEmpresa" )
					loXA.AddTableSchema( "cCabeza" )
					loXA.AddTableSchema( "cDetalle" )

					loXA.PreserveWhiteSpace = .T.
					loXA.ToXML( lcFileName,"", .T. )

				Endif


			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loXA = Null

		Endtry



	Endproc && GenerarXML




	*
	*
	Procedure ImprimirPDF( tnComprobanteId As Integer,tnCopias As Integer  ) As Void

		Local lcPrintCommand As String,;
			lcCommand As String,;
			lcOldPrinter As String,;
			lcDefaultPrinter As String,;
			lcComp As String,;
			lcAlias As String,;
			lcDefault As String,;
			lcCurDir As String,;
			lcPdfDir As String,;
			lcFileName As String


		Local lnCopias As Integer,;
			i As Integer
		Local Array laCopias[ 4 ]

		Local loPDFCreator As PDFCreator.clsPDFCreator
		Local loOptions As PDFCreator.clsPDFCreatorOptions
		Local llOk As Boolean


		If Type("tnComprobanteid")<>"N"

			tnComprobanteId = 0

		Endif


		If Type("tnComprobanteid")<>"N"

			tnCopias = 1

		Endif



		Try

			lcCommand = ""
			lcFileName = ""
			llOk = .T.

			If Upper( This.cDefaultPrinter ) = "PDFCREATOR" ;
					And This.nOutput # _FRX_PDF ;
					And This.nCopias > 0

				* RA 2013-03-24(14:33:33)
				* Si mi impresora predeterminada es PdfCreator
				* Necesito esperar a que termine de imprimir antes de
				* generar el PDF, porque si no se cuelga
				llOk = Confirm( "¿Imprime PDF?" )
			Endif

			If llOk
				lcAlias = Alias()

				loPDFCreator = This.oPDF

				llOk = Vartype( loPDFCreator ) = "O"
			Endif

			If llOk

				laCopias[ 1 ] = "ORIGINAL"
				laCopias[ 2 ] = "DUPLICADO"
				laCopias[ 3 ] = "TRIPLICADO"
				laCopias[ 4 ] = "COPIA Nº "

				* Si PDFCreator no es la salida predeterminada, imprimir solo el original




				*				MessageBox(tnComprobanteId)
				*				MessageBox(tnCopias)

				If GetValue( "OPPDF", "ar0Val", "N") = "S" .And. tnComprobanteId = 6 &&  FRX_ORDENDEPAGO  #Define FRX_ORDENDEPAGO     	6

					** agrego para que salga la orden de pago automatica en PDF con original y duplicado
					lnCopias = tnCopias



				Else
					** asi estaba originalmente  03-07-2020
					lnCopias = 1

				Endif


				If Type("This.cPDFFileName") <> "C"

					This.cPDFFileName = ""


				Endif


				If Empty( This.cPDFFileName ) Or This.lConfirmaNombrePDF


					*					MessageBox(This.cPDFFileName)
					*					MessageBox(This.lConfirmaNombrePDF)


					This.cPDFFileName = Strtran( This.cPDFFileName, "/", "-" )

					lcDefault = Set("Default")
					lcCurDir = Curdir()

					lcPdfDir = GetValue( "RutaPDF", "ar0Var", Space(0) )

					If Empty( lcPdfDir )
						lcPdfDir = Getenv("HOMEDRIVE") + Getenv("HOMEPATH")
					Endif

					lcPdfDir = Addbs( Alltrim( lcPdfDir ))

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Cd '<<lcPdfDir>>'
					ENDTEXT

					Try
						&lcCommand

					Catch To oErr

					Finally

					Endtry

					Wait Clear

					lcFileName = Putfile( "", This.cPDFFileName, "Pdf" )

					This.cPDFFileName = Juststem( lcFileName )
					This.cPDFFolder = Addbs( Justpath( lcFileName ))

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Cd '<<lcDefault>><<lcCurDir>>'
					ENDTEXT

					&lcCommand

				Endif

				If !Empty( This.cPDFFileName )

					This.cPDFFileName = Strtran( This.cPDFFileName, "/", " " )

					* Detectar si ya se encuentra inicializado
					If This.lSetToPDFCreator = .F.
						This.oPDF.SetToPDFCreator()
						This.lSetToPDFCreator = .T.
					Endif

					If Empty( This.cPDFFolder )
						This.cPDFFolder = Addbs( GetValue( "RutaPdf", "ar0Var", "" ))
					Endif

					If !FileExist( This.cPDFFolder + "*.*" )
						Try

							Md ( This.cPDFFolder )

						Catch To oErr

						Finally

						Endtry

					Endif


					* Indicar Carpeta donde guardar los PDF
					This.oPDF.AutoSaveDirectory = Alltrim( This.cPDFFolder )

					* Armar nombre del archivo
					This.oPDF.AutoSaveFileName =  This.cPDFFileName
					This.oPDF.AutosaveStartStandardProgram = Iif( This.lAbrirPDF, 1, 0 )


					*/ Rutina de impresion

					For i = 1 To lnCopias

						Do Case
							Case Between( i, 1, lnCopias - 1 )
								lcPrintCommand = "NoPageEject NoDialog NoConsole"

							Otherwise
								lcPrintCommand = "NoDialog NoConsole"

						Endcase

						If Used( "cGlobal" )
							* Nº de Copia
							Select cGlobal
							Locate
							Replace CopiaNro With Iif( i > 4, laCopias[ 4 ] + Transform( i ), laCopias[ i ] )
						Endif

						This.HookBeforePrintPdf( i )

						If Used( lcAlias )
							Select Alias( lcAlias )
							Locate
						Endif

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Report Form "<<This.cFrxFileName>>"
						To Printer <<lcPrintCommand>>
						ENDTEXT

						&lcCommand



					Endfor

					*/ Cerrar Impresion

					This.oPDF.CloseJob()

					* Si la salida es por impresora, cancelar la salida a PDF
					This.oPDF.CancelPDFCreator()

				Endif

				This.lSetToPDFCreator = .F.

			Else
				This.lSetToPDFCreator = .F.

			Endif

			If This.lSendEMail And !Empty( This.cPDFFileName )
				lcFileName = Addbs( Alltrim( This.cPDFFolder )) + Alltrim( This.cPDFFileName )

				If Empty( Justext( lcFileName ) )
					lcFileName = lcFileName + ".PDF"
				Endif

				This.SendEMail( lcFileName )
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			If This.lSetToPDFCreator = .T.
				This.oPDF.CancelPDFCreator()
			Endif

			This.lSetToPDFCreator = .F.

			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry
	Endproc && ImprimirPDF



	*
	* El programador puede hacer ajustes de ultima hora
	Procedure HookBeforePrintPdf( nCopiaNro As Integer ) As Void;
			HELPSTRING "El programador puede hacer ajustes de ultima hora"
		Local lcCommand As String

		Try

			lcCommand = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && HookBeforePrintPdf


	*
	*
	Procedure SendEMail( cFileName As String ) As Void
		Local lcCommand As String,;
			lcTextBody As String,;
			lcAccount As String,;
			lcBCC As String

		Local loMail As oEMail Of "Tools\Email\Prg\prxSmtp.prg"
		Local loSettings As oMailSettings Of "Tools\Email\Prg\prxSmtp.prg"

		Try

			lcCommand = ""

			loMail = Newobject( "oEMail", "Tools\Email\Prg\prxSmtp.prg" )

			loSettings = This.oMailSettings

			* Datos de Envío
			loMail.cTo 				= Alltrim( loSettings.cTo )
			loMail.cCC 				= Alltrim( loSettings.cCC )
			loMail.cBCC 			= Alltrim( loSettings.cBCC )

			loMail.cSubject 		= Alltrim( loSettings.cSubject )
			loMail.cTextBody 		= Alltrim( loSettings.cTextBody )
			loMail.cAttachment 		= Alltrim( cFileName )

			loMail.cHtmlBody 		= Alltrim( loSettings.cHtmlBody )
			loMail.cHtmlBodyUrl 	= Alltrim( loSettings.cHtmlBodyUrl )
			loMail.cCharset 		= Alltrim( loSettings.cCharset )
			loMail.cPriority 		= Alltrim( loSettings.cPriority )

			* Datos de la Cuenta
			loMail.cFrom 			= Alltrim( loSettings.cFrom )
			loMail.cServer 			= Alltrim( loSettings.cServer )
			loMail.nServerPort 		= loSettings.nServerPort
			loMail.lUseSSL 			= loSettings.lUseSSL
			loMail.nAuthenticate 	= loSettings.nAuthenticate
			loMail.cUserName 		= Alltrim( loSettings.cUserName )
			loMail.cPassword 		= loSettings.cPassword
			loMail.cReplyTo 		= Alltrim( loSettings.cReplyTo )
			loMail.nServerPort 		= loSettings.nServerPort
			loMail.lUseSSL 			= loSettings.lUseSSL
			loMail.nConnectionTimeout 	= loSettings.nConnectionTimeout
			loMail.lURLGetLatestVersion = loSettings.lURLGetLatestVersion
			loMail.lReadReceipt 	= loSettings.lReadReceipt

			lcBCC = ""

			If loSettings.lMostrarEnEnviados

				If !Empty( loSettings.cNombreFantasia )
					lcBCC = loSettings.cNombreFantasia + "<" + loSettings.cUserName + ">"

				Else
					lcBCC = loSettings.cUserName

				Endif

			Endif

			loMail.Send()

			If !Empty( lcBCC )
				loMail.lSilence 	= .T.
				loMail.cTo 			= lcBCC
				loMail.cBCC 		= ""
				loMail.cCC 			= ""
				loMail.cFrom 		= lcBCC
				loMail.lReadReceipt = .F.

				loMail.Send()
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loMail = Null
			loSettings = Null

		Endtry

	Endproc && SendEMail


	*
	* oMailSettings_Access
	Protected Procedure oMailSettings_Access()
		Local lcCommand As String,;
			lcAccount As String,;
			lcAlias As String

		Local loMail As oEMail Of "Tools\Email\Prg\prxSmtp.prg"
		Local loMailAccount As MailAccount Of 'Fw\Comunes\Prg\MailAccount.prg'
		Local loMailSettings As oMailSettings Of "Tools\Email\Prg\prxSmtp.prg"


		Try

			lcCommand 	= ""
			lcAccount 	= ""
			lcAlias 	= Alias()

			If Vartype( This.oMailSettings ) # "O"
				loMail = Newobject( "oEMail", "Tools\Email\Prg\prxSmtp.prg" )
				loMailAccount = GetEntity( "MailAccount" )
				loMailAccount.GetDefault()
				lcAccount = Alias()

				This.oMailSettings = loMail.GetSettingsParameters()

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loMail = Null
			loMailAccount = Null
			Use In Select( lcAccount )

			If !Empty( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

		Return This.oMailSettings

	Endproc && oMailSettings_Access


	*
	* oPDF_Access
	Protected Procedure xxxoPDFAccess()

		Local loPDF As PrxPDFCreator Of "Tools\PDFCreator\Prg\prxPDFCreator.prg"
		Local lnVersion As Integer
		Local lcCommand As String

		Try

			lcCommand = ""

			If !This.lOnDestroy And Vartype( This.oPDF ) # "O"
				* Verifica que PDFCreator esté instalado

				lnVersion = 0

				Try

					loPDF = Createobject("PDFCreator.clsPDFCreator")
					lnVersion = 1

				Catch To loErr
					Try

						loPDF = Createobject("PDFCreatorBeta.PDFCreator")
						lnVersion = 2

					Catch To oErr

					Finally

					Endtry


				Finally

				Endtry
				loPDF = Createobject("PDFCreator.clsPDFCreator")
				loPDF = Createobject("PDFCreatorBeta.PDFCreator")

				This.oPDF = Newobject( "PrxPDFCreator", "Tools\PDFCreator\Prg\prxPDFCreator.prg" )
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			If oErr.ErrorNo = 1733
				Local lcErrorMessage As String

				TEXT To lcErrorMessage NoShow TextMerge Pretext 03
				Debe instalar PDFCreator para poder generar
				archivos con formato PDF en forma automática.
				Puede descargarlo de
				http://sourceforge.net/projects/pdfcreator/
				ENDTEXT

				Stop( lcErrorMessage )

			Else
				Local lcErrorMessage As String

				TEXT To lcErrorMessage NoShow TextMerge Pretext 03
				No se pudo abrir PDFCreator para generar
				el PDF en forma automática.

				Verifique que el mismo esté bien instalado

				Puede descargarlo de
				http://sourceforge.net/projects/pdfcreator/

				ENDTEXT

				Stop( lcErrorMessage )


			Endif

		Finally
			loPDF = Null

		Endtry

		Return This.oPDF


	Endproc && oPDF_Access

	*
	* oPDF_Access
	Protected Procedure oPDF_Access()

		Local loPDF As PrxPDFCreator Of "Tools\PDFCreator\Prg\prxPDFCreator.prg"
		Local lcCommand As String

		Try

			lcCommand = ""

			If !This.lOnDestroy And Vartype( This.oPDF ) # "O"

				This.oPDF = Newobject( "PrxPDFCreator", "Tools\PDFCreator\Prg\prxPDFCreator.prg" )

				If Isnull( This.oPDF.oPDF )
					This.oPDF = Null
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return This.oPDF


	Endproc && oPDF_Access

	*
	* oPDF_Access
	Protected Procedure yyyoPDF_Access()

		Local loPDF As PrxPDFCreator Of "Tools\PDFCreator\Prg\prxPDFCreator.prg"

		Try

			If !This.lOnDestroy And Vartype( This.oPDF ) # "O"
				* Verifica que PDFCreator esté instalado
				loPDF = Createobject("PDFCreator.clsPDFCreator")
				loPDF = Null

				This.oPDF = Newobject( "PrxPDFCreator", "Tools\PDFCreator\Prg\prxPDFCreator.prg" )
			Endif

		Catch To loErr

			If loErr.ErrorNo = 1733
				Local lcErrorMessage As String

				TEXT To lcErrorMessage NoShow TextMerge Pretext 03
				Debe instalar PDFCreator para poder generar
				archivos con formato PDF en forma automática.
				Puede descargarlo de
				http://sourceforge.net/projects/pdfcreator/
				ENDTEXT

				Stop( lcErrorMessage )

			Else
				Local lcErrorMessage As String

				TEXT To lcErrorMessage NoShow TextMerge Pretext 03
				No se pudo abrir PDFCreator para generar
				el PDF en forma automática.

				Verifique que el mismo esté bien instalado

				Puede descargarlo de
				http://sourceforge.net/projects/pdfcreator/

				ENDTEXT

				Stop( lcErrorMessage )


			Endif

		Finally
			loPDF = Null

		Endtry

		Return This.oPDF


	Endproc && xxxoPDF_Access

	Procedure Destroy
		DoDefault()
		This.lOnDestroy = .T.
		This.oPDF = Null
	Endproc



	*
	*
	Procedure ObtenerObjetoComprobante(  ) As Object
		Local lcCommand As String
		Local loComprobante As Object

		Try

			lcCommand = ""

			loComprobante = Createobject( "Empty" )
			AddProperty( loComprobante, "nId", 0 ) && Id del registro
			AddProperty( loComprobante, "cTabla", "" ) && Alias de la tabla que contiene el comprobante

			AddProperty( loComprobante, "nComprobanteId", 	0 )
			AddProperty( loComprobante, "nComprobante", 	00 )		&& Comp7
			AddProperty( loComprobante, "cTipo", 			" " )		&& Tipo7
			AddProperty( loComprobante, "nSucursal", 		0000 )		&& Sucu7
			AddProperty( loComprobante, "nNumero", 			00000000 )	&& Nume7
			AddProperty( loComprobante, "cRazonSocial", 	"" )		&& Nomb7
			AddProperty( loComprobante, "nTranId",    		0 )

			* Salida
			*!*	_FRX_PREVIEW			1
			*!*	_FRX_PRINTER			2
			*!*	_FRX_DEFAULT_PRINTER	3
			AddProperty( loComprobante, "nOutput", _FRX_PREVIEW )

			AddProperty( loComprobante, "nCopias", 1 )

			* Nombre de método que llama ReportSetup()
			AddProperty( loComprobante, "cMetodo", "cfgComprobante" )

			* Reporte que se ejecuta
			AddProperty( loComprobante, "cFRXFolder", Alltrim( GetValue( "RUTAFRX", "ar0var", DRVFRX )))
			AddProperty( loComprobante, "cFrxFileName", "" )
			AddProperty( loComprobante, "cPrinter", "" )
			AddProperty( loComprobante, "cDetalle", "" )

			AddProperty( loComprobante, "lImprimePDF", .F. )
			AddProperty( loComprobante, "cPDFFileName", "" )
			AddProperty( loComprobante, "cPDFFolder", "" )

			AddProperty( loComprobante, "lSendEMail", .F. )
			AddProperty( loComprobante, "oMailSettings", Null )
			AddProperty( loComprobante, "cMailTo", "" )
			AddProperty( loComprobante, "cMailCC", "" )

			* Parametros personalizados
			AddProperty( loComprobante, "oParametros", Null )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loComprobante

	Endproc && ObtenerObjetoComprobante

	*
	* Devuelve un objeto Comprobante
	* RA 15/11/2016(10:54:04) Por Compatibilidad - Usar ObtenerObjetoComprobante()
	Procedure NewComprobante(  ) As Void;
			HELPSTRING "Devuelve un objeto Comprobante"
		Local lcCommand As String
		Local loComprobante As Object

		Try

			lcCommand = ""
			loComprobante = This.ObtenerObjetoComprobante()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loComprobante

	Endproc && NewComprobante


	*
	*
	Procedure Comprobante( tnComp As Integer,;
			tcTipo As Character,;
			tnSucu As Integer,;
			tnNume As Integer ) As String

		Local lcComprobante As String

		Try


			Do Case
				Case tnComp = 1
					lcComprobante = "FC"

				Case tnComp = 2
					lcComprobante = "ND"

				Case tnComp = 3
					lcComprobante = "NC"

				Case tnComp = 4
					lcComprobante = "FC"

				Case tnComp = 5
					lcComprobante = "ND"

				Case tnComp = 6
					lcComprobante = "NC"

				Case tnComp = 7
					lcComprobante = "RC"

				Case tnComp = 8
					lcComprobante = "RC"

				Case tnComp = 12
					lcComprobante = "AD"

				Case tnComp = 13
					lcComprobante = "AH"

				Case Inlist( tnComp, 11, 14 )
					lcComprobante = "DTO"

				Case tnComp = 15
					lcComprobante = "AD"

				Case tnComp = 16
					lcComprobante = "AH"

				Otherwise
					lcComprobante = ""

			Endcase

			Do Case
				Case tcTipo = "T"
					lcComprobante = "TQT "

				Case Inlist( tnComp, 11, 14 )
					lcComprobante = lcComprobante + " "

				Otherwise
					lcComprobante = lcComprobante + tcTipo + " "

			Endcase

			lcComprobante = lcComprobante + StrZero( tnSucu, 4 ) + "-" + StrZero( tnNume, 8 )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lcComprobante

	Endproc && Comprobante






Enddefine
*!*
*!* END DEFINE
*!* Class.........: ImprimirComprobante
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oImp_Fe
*!* Description...:
*!* Date..........: Jueves 4 de Febrero de 2021 (10:10:37)
*!*
*!*

Define Class oImp_Fe As ImprimirComprobante Of "Rutinas\Prg\ImpComp.prg"

	#If .F.
		Local This As oImp_Fe Of "Rutinas\Prg\ImpComp.prg"
	#Endif

	* Imprime Código QR
	lQR 				= .F.
	lQR_Genera 			= .F.
	cQRFileName 		= ""
	cDefaultQRFileName 	= "Codigo_QR.jpg"
	oComprobante_QR 	= Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lqr" type="property" display="lQR" />] + ;
		[<memberdata name="lqr_genera" type="property" display="lQR_Genera" />] + ;
		[<memberdata name="cqrfilename" type="property" display="cQRFileName" />] + ;
		[<memberdata name="cdefaultqrfilename" type="property" display="cDefaultQRFileName" />] + ;
		[<memberdata name="ocomprobante_qr" type="property" display="oComprobante_QR" />] + ;
		[<memberdata name="ocomprobante_qr_access" type="method" display="oComprobante_QR_Access" />] + ;
		[<memberdata name="getqrfilename" type="method" display="GetQrFileName" />] + ;
		[<memberdata name="traerimagenqr" type="method" display="TraerImagenQR" />] + ;
		[</VFPData>]

	*
	*
	Procedure HookBeforeImprimir( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer,;
			tnCopias As Integer,;
			tnCodigo As Integer ) As Void

		Local lcCommand As String
		Local loFE As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg",;
			loComprobante As Object

		Try

			lcCommand = ""

			If Isnull( This.oComprobante )
				loComprobante 				= This.oComprobante_QR
				loComprobante.Tipo 			= tnComprobante
				loComprobante.Letra 		= tcTipo
				loComprobante.PuntoDeVenta 	= tnPtoVenta
				loComprobante.Numero 		= tnNumero

				loFE = NewFe()
				loComprobante.CodigoAfip 	= loFE.GetCodigoComprobante( loComprobante )

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loComprobante = Null
			loFE = Null

		Endtry

	Endproc && HookBeforeImprimir

	*
	*
	Procedure TraerImagenQR(  ) As Void
		Local lcCommand As String
		Local loFE As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg",;
			loComprobante As Object

		Try

			lcCommand = ""

			This.lQR_Genera = GetValue( "QR_Genera", "ar0FEL", "N" ) = "S"
			This.lQR 		= ( This.lQR And This.lQR_Genera )

			If This.lQR

				loFE = NewFe()

				Try

					loFE.oFE.f1detalleqrformato = 6
					This.lQR = .T.

				Catch To oErr
					This.lQR = .F.

				Finally

				Endtry

			Endif

			If This.lQR
				If Right( Juststem( This.cFrxFileName ), 3 ) # "_QR"
					This.cFrxFileName = Addbs( This.cFRXFolder ) ;
						+ Juststem( This.cFrxFileName ) ;
						+ "_QR.frx"
				Endif
			Endif

			If This.lQR

				loFE = NewFe()
				loComprobante = This.oComprobante_QR

				If !Isnull( This.oComprobante )
					loComprobante.Tipo			= This.oComprobante.nComprobante
					loComprobante.Letra 		= This.oComprobante.cTipo
					loComprobante.PuntoDeVenta 	= This.oComprobante.nSucursal
					loComprobante.Numero 		= This.oComprobante.nNumero
					loComprobante.CodigoAfip 	= loFE.GetCodigoComprobante( loComprobante )

				Endif

				If loComprobante.PuntoDeVenta > 50
					loComprobante.PuntoDeVenta = loComprobante.PuntoDeVenta - 50
					loComprobante.CodigoAfip = loComprobante.CodigoAfip + 200
				Endif

				This.cQRFileName 	= loFE.GetQrFileName( loComprobante )

				If FileExist( This.cQRFileName )
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Copy File '<<This.cQRFileName>>' To '<<Addbs( This.cFRXFolder )>><<This.cDefaultQRFileName>>'
					ENDTEXT

					&lcCommand
					lcCommand = ""

				Else
					* RA 04/02/2021(11:15:04)
					* Hacer una consulta para que se cree el Codigo QR
					loFE.ConsultarComprobante( loComprobante.PuntoDeVenta,;
						loComprobante.CodigoAfip,;
						loComprobante.Numero )

					If FileExist( This.cQRFileName )
						TEXT To lcCommand NoShow TextMerge Pretext 15
						Copy File '<<This.cQRFileName>>' To '<<Addbs( This.cFRXFolder )>><<This.cDefaultQRFileName>>'
						ENDTEXT

						&lcCommand
						lcCommand = ""

					Else
						This.lQR = .F.

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
			loFE = Null

		Endtry

	Endproc && TraerImagenQR


	*
	* El programador puede hacer ajustes de ultima hora
	Procedure HookBeforePrint( nCopiaNro As Integer ) As Void;
			HELPSTRING "El programador puede hacer ajustes de ultima hora"
		Local lcCommand As String

		Try

			lcCommand = ""

			This.TraerImagenQR()

			DoDefault( nCopiaNro )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && HookBeforePrint

	*
	* El programador puede hacer ajustes de ultima hora
	Procedure HookBeforePrintPdf( nCopiaNro As Integer ) As Void;
			HELPSTRING "El programador puede hacer ajustes de ultima hora"
		Local lcCommand As String

		Try

			lcCommand = ""

			This.TraerImagenQR()

			DoDefault( nCopiaNro )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && HookBeforePrintPdf

	*
	* oComprobante_QR_Access
	Protected Procedure oComprobante_QR_Access()

		Local lcCommand As String
		Local loFE As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg"

		Try

			lcCommand = ""
			If Vartype( This.oComprobante_QR ) # "O"
				loFE = NewFe()
				loFE.oComprobante = Null
				This.oComprobante_QR = loFE.oComprobante

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


		Return This.oComprobante_QR

	Endproc && oComprobante_QR_Access



	*
	*
	Procedure GetQrFileName( oComprobante As Object ) As String
		Local lcCommand As String,;
			lcFileName As String

		Local loFE As prxWSFEv1 Of "Tools\FE\Prg\prxWSFEv1.prg"

		Try

			lcCommand = ""
			loFE = NewFe()
			lcFileName = loFE.GetQrFileName( oComprobante )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loFE = Null

		Endtry

		Return lcFileName

	Endproc && GetQrFileName


	Procedure CfgFacturaElectronica( tnComprobanteId As Integer,;
			tnComprobante As Integer,;
			tcTipo As Character,;
			tnPtoVenta As Integer,;
			tnNumero As Integer ) As Void;
			HELPSTRING "Configuracion Factura"

		This.lQR = .T.
		DoDefault( tnComprobanteId,;
			tnComprobante,;
			tcTipo,;
			tnPtoVenta,;
			tnNumero )

	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oImp_Fe
*!*
*!* ///////////////////////////////////////////////////////



