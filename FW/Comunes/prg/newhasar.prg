Lparameters llOnDestroy As Boolean

#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\Hasar\Include\Hasar.h"


Local loHasar As HASAR.Fiscal.1
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
Local loFiscalErrors As Collection
Local loPrinterErrors As Collection
Local loIvas As Collection
Local loIva As Object
Local loCliente As Object
Local loComprobante As Object
Local i As Integer
Local llExit As Boolean

* RA 2016-01-14(17:37:52)
* Si falla en detectar automáticamente, 
* se puede poner en Terminal.mem alguno de los siguientes valores:
* nHModelo 		= nn
* nHPtoVenta 	= n
* HasarCOM		= n

Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Try

	loGlobalSettings = NewGlobalSettings()
	loHasar = loGlobalSettings.oHasar

	If Vartype( lNCR ) = "U"
		Public lNCR
		lNCR = .F.
	EndIf
	
	If lHasar And !IsRuntime()
		lHasar = .F.
	Endif

	If Vartype( loHasar ) # 'O'
		llExit = .F.
		Local lnPuntoDeVenta As String

		loHasar = Newobject( 'HASAR.Fiscal.1' )
		loGlobalSettings.oHasar = loHasar
		lnPuntoDeVenta = -1

		AddProperty( loHasar, "nPuntoDeVenta", lnPuntoDeVenta )
		AddProperty( loHasar, "cModelo", "" )
		AddProperty( loHasar, "nModelo", 0 )

		If lHasar And !llOnDestroy
			If Vartype( nHModelo ) = "U"
				Public nHModelo
				nHModelo = 0

			Endif

			For i = 1 To 10
				Try

					loHasar.Puerto = i && Leer el puerto de un archivo de configuracion

					If Vartype( HasarCOM ) = "N"	&& Definido en Arparame.mem
						i = HasarCOM
						loHasar.Puerto = i
					Endif

					Wait "Buscando Controlador Fiscal en Puerto COM" + Transform( i ) Window Nowait


					Try
						If !lNCR
							loHasar.AutodetectarControlador()

							Try
								loHasar.AutodetectarModelo()
								loHasar.nModelo=loHasar.Modelo

								loHasar.Enviar( Chr( 127 ) ) && GetPrinterVersion()
								loHasar.cModelo = loHasar.Respuesta( 3 )

							Catch To oErr
								If Empty( loHasar.nModelo )
									* RA 2016-01-14(16:27:11)
									* Leerlo de TERMINAL.MEM
									If Vartype( nHModelo ) = "N"
										loHasar.nModelo = nHModelo

									Else
										loHasar.nModelo = MODELO_715

									Endif
								Endif

							Finally

							EndTry
							
							If Empty( loHasar.cModelo )
								loHasar.cModelo = Transform( loHasar.nModelo )
							EndIf

							Try

								loHasar.ObtenerDatosDeInicializacion()
								lnPuntoDeVenta = Val( loHasar.Respuesta( 7 ))

							Catch To oErr
								* RA 2016-01-14(16:27:11)
								* Leerlo de TERMINAL.MEM
								If Vartype( nHPtoVenta ) = "N"
									lnPuntoDeVenta = nHPtoVenta

								Else
									lnPuntoDeVenta = 1

								Endif

							Finally

							Endtry

							loHasar.nPuntoDeVenta = lnPuntoDeVenta

							If nHModelo=0
								nHasarsModelo=loHasar.Modelo
								loHasar.nModelo=loHasar.Modelo

							Else
								loHasar.nModelo=nHModelo

							Endif


							If !Inlist( loHasar.nModelo,;
									MODELO_615,;
									MODELO_715,;
									MODELO_715_201,;
									MODELO_715_302,;
									MODELO_715_403,;
									MODELO_P441,;
									MODELO_P330,;
									MODELO_P330_201,;
									MODELO_P320,;
									MODELO_P330_202,;
									MODELO_P330_203 )

								Local lcMessage As String,;
									lcDetalle As String

								llExit = .T.

								TEXT To lcMessage NoShow TextMerge Pretext 15
								NewHasar: Modelo No Reconocido
								ENDTEXT


								TEXT To lcDetalle NoShow TextMerge Pretext 15
								Modelo: <<loHasar.nModelo>>
								ENDTEXT

								Logerror( lcMessage, 0, lcDetalle )

								Stop( "NewHasar: Modelo No Reconocido",;
									"Inicializando HASAR" )

							Endif

						Else
							If nHModelo=0
								nHasarsModelo=loHasar.Modelo
								loHasar.nModelo=loHasar.Modelo
							Else
								loHasar.nModelo=nHModelo
							Endif

						Endif

					Catch To oErr
						Messagebox("NO SE PUDO DETECTAR LA IMPRESORA FISCAL, Causa probable, Modelo de Hasar",16)
						loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
						loError.Process( oErr )
						Throw loError

						lNCR = .T.

					Finally

					Endtry

					If lNCR
						loHasar.AutodetectarControlador()
						loHasar.cModelo = "NCR"
						loHasar.Enviar( Chr( 115 ) ) && ObtenerDatosDeInicializacion()
						lnPuntoDeVenta = Val( loHasar.Respuesta( 7 ))
						loHasar.nPuntoDeVenta = lnPuntoDeVenta
					Endif

					i = 9999

				Catch To oErr
					If i >= 2
						If Messagebox( "¿Sigue Buscando?",;
								MB_OKCANCEL + MB_ICONQUESTION,;
								"Controlador Fiscal NO ENCONTRADO en Puerto COM" + Transform( i ) ) = IDCANCEL

							i = 9999
							
						Else
							i = Val( InputBox( "", "Ingrese el Puerto", Transform( i ) ))
							
							If Empty( i )
								lHasar = .F.
							EndIf	
						Endif
					Endif

				Finally

				EndTry
				
				If !lHasar
					Exit 
				EndIf

			Endfor

		Endif

		If lHasar And lnPuntoDeVenta > 0

			loFiscalErrors = Createobject( "Collection" )

			loFiscalErrors.Add( "Error en chequeo de memoria fiscal" )
			loFiscalErrors.Add( "Error en chequeo de la memoria de trabajo" )
			loFiscalErrors.Add( "Carga de bateria baja" )
			loFiscalErrors.Add( "Comando desconocido" )
			loFiscalErrors.Add( "Datos no validos en un campo" )
			loFiscalErrors.Add( "Comando no valido para el estado fiscal actual" )
			loFiscalErrors.Add( "Desborde del total" )
			loFiscalErrors.Add( "Memoria fiscal llena" )
			loFiscalErrors.Add( "Memoria fiscal a punto de llenarse" )
			loFiscalErrors.Add( "" )
			loFiscalErrors.Add( "" )
			loFiscalErrors.Add( "Error en ingreso de fecha" )
			loFiscalErrors.Add( "Recibo fiscal abierto" )
			loFiscalErrors.Add( "Recibo abierto" )
			loFiscalErrors.Add( "Factura abierta" )
			loFiscalErrors.Add( "" )


			loPrinterErrors =  Createobject( "Collection" )

			loPrinterErrors.Add( "" )
			loPrinterErrors.Add( "" )
			loPrinterErrors.Add( "Error de Impresora" )
			loPrinterErrors.Add( "Impresora Offline" )
			loPrinterErrors.Add( "Falta papel del diario" )
			loPrinterErrors.Add( "Falta papel de tickets" )
			loPrinterErrors.Add( "Buffer de Impresora lleno" )
			loPrinterErrors.Add( "" )
			loPrinterErrors.Add( "" )
			loPrinterErrors.Add( "" )
			loPrinterErrors.Add( "" )
			loPrinterErrors.Add( "" )
			loPrinterErrors.Add( "" )
			loPrinterErrors.Add( "" )
			loPrinterErrors.Add( "" )
			loPrinterErrors.Add( "" )


		Else
			If !lHasar
				loHasar.nPuntoDeVenta = GetValue( "Sucu0", "ar0Est", 1 )

			Endif

		Endif

		loCliente = Createobject( "Empty" )

		AddProperty( loCliente, "sRazonSocial", "" )
		AddProperty( loCliente, "nCuit", 0 )
		AddProperty( loCliente, "nInsc", 0 )
		AddProperty( loCliente, "cInsc", "" )
		AddProperty( loCliente, "cDocumento", "" )
		AddProperty( loCliente, "sDomComercial", "" )
		AddProperty( loCliente, "lIIBB901", .F. )
		AddProperty( loCliente, "lIIBB902", .F. )
		AddProperty( loCliente, "lIIBB177", .F. )

		loComprobante = Createobject( "Empty" )

		AddProperty( loComprobante, "nItems", 0 )
		AddProperty( loComprobante, "nVentas", 0 )
		AddProperty( loComprobante, "nIva", 0 )
		AddProperty( loComprobante, "nPago", 0 )
		AddProperty( loComprobante, "nIvaNoInscripto", 0 )
		AddProperty( loComprobante, "nPercepciones", 0 )
		AddProperty( loComprobante, "nNumero", 0 )
		AddProperty( loComprobante, "cTipoComprobante", "" )
		AddProperty( loComprobante, "nComp", 0 )
		AddProperty( loComprobante, "nNumero1", 0 )
		AddProperty( loComprobante, "nNumero2", 0 )

		loIvas = Createobject( "Collection" )

		AddProperty( loHasar, "FiscalErrors", loFiscalErrors )
		AddProperty( loHasar, "PrinterErrors", loPrinterErrors )
		AddProperty( loHasar, "oCliente", loCliente )
		AddProperty( loHasar, "oComprobante", loComprobante )
		AddProperty( loHasar, "oIvas", loIvas )
		AddProperty( loHasar, "cTraceLogin", "" )
		AddProperty( loHasar, "cRemark", "" )
		AddProperty( loHasar, "cEjecutando", "" )

	Endif && Vartype( loHasar ) # 'O'

	If llExit
		Error "Imposible Inicializar"
	Endif


Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loError = Null
	loGlobalSettings = Null
	loPrinterErrors = Null
	loFiscalErrors = Null

Endtry

Return loHasar