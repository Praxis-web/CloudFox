#INCLUDE "FW\Hasar\Include\Hasar.h"
#INCLUDE "FW\Comunes\Include\Praxis.h"

#Define COMP_FACTURA	1
#Define COMP_NDEBITO	2
#Define COMP_NCREDITO	3

*  HASAR.PRG
*  Ricardo - 08/12/2000
*  Funciones para la generacion de comandos para las impresoras de
*					 Compa¤¡a Hasar SAIC
*					  Impresoras modelos
*						  SMH/PJ-20F
*						  SMH/P-320F
*
*
*	  para uso con drivers para impresoras fiscales Hasar

*  La constante FS (Field Separetor) esta definida en GLOBALES.PRG


*  3. Descripci¢n de los comandos  18
*  3.1. Comandos de inicializaci¢n, baja y configuraci¢n   18
*  3.1.1. InitEpromFiscal - Inicializaci¢n 18
*  3.1.2. KillEpromFiscal - Baja de la memoria fiscal  19
*  3.1.3. ConfigureControllerByBlock - Configuraci¢n del controlador en bloque 20
*  3.1.4. GeneralConfiguration - Configuraci¢n general del controlador 22
*  3.1.5. ConfigureControllerByOne - Config. del controlador por par metros    26
*  3.1.6. ChangeIVA Responsability - Cambio de responsabilidad frente al IVA   28
*  3.1.7. StoreLogoData - Carga logotipo   29
*  3.1.8. ResetLogoData - Reset logotipo   30
*  3.1.9. SetComSpeed - Seteo de velocidad de comunicaci¢n 31
*  3.2. Comandos de diagn¢stico y consulta 32
*  3.2.1. StatusRequest - Consulta de estado   32
*  3.2.2. STATPRN - Consulta de estado intermedio  33
*  3.2.3. GetConfigurationData - Consulta de configuraci¢n 34
*  3.2.4. GetGeneralConfigurationData - Consulta de configuraci¢n general  35
*  3.2.5. GetInitData - Consulta de datos de inicializaci¢n    36
*  3.2.6. GetPrinterVersion - Consulta de versi¢n de controlador fiscal    37
*  3.3. Comandos de control fiscal 38
*  3.3.1. HistoryCapacity - Capacidad restante 38
*  3.3.2. DailyClose - Cierre de jornada fiscal    39
*  3.3.3. DailyCloseByDate - Reporte de auditoria por fechas   41
*  3.3.4. DailyCloseByNumber - Reporte de auditoria por número de Z    42
*  3.3.5. GetDailyReport - Reporte de registro diario  43
*  3.3.6. GetWorkingMemory - Consulta de memoria de trabajo    45
*  3.3.7. SendFirstIVA - Iniciar informaci¢n de IVA    47
*  3.3.8. NextIVATransmission - Continuar informaci¢n de IVA   49
*  3.4. Comandos de comprobante fiscal y nota de crédito   52
*  3.4.1. OpenFiscalReceipt - Abrir comprobante fiscal 52
*  3.4.2. PrintFiscalText - Imprimir texto fiscal  54
*  3.4.3. PrintLineItem - Imprimir ¡tem    55
*  3.4.4. LastItemDiscount - Descuento/Recargo sobre último ¡tem vendido   58
*  3.4.5. GeneralDiscount - Descuento general  60
*  3.4.6. ReturnRecharge - Devoluci¢n de envases, Bonificaciones y Recargos    62
*  3.4.7. ChargeNonRegisteredTax - Recargo IVA a Responsable no Inscripto  65
*  3.4.8. Perceptions - Percepciones   66
*  3.4.9. Subtotal 67
*  3.4.10. ReceiptText - Texto de l¡neas de recibos    68
*  3.4.11. TotalTender - Total 69
*  3.4.12. CloseFiscalReceipt - Cerrar comprobante fiscal  71
*  3.5. Comandos de comprobante no fiscal  73
*  3.5.1. OpenNonFiscalReceipt - Abrir comprobante no fiscal   73
*  3.5.2. OpenNonFiscalSlip - Abrir comprobante no fiscal en impresora slip    74
*  3.5.3. PrintNonFiscalText - Imprimir texto no fiscal    75
*  3.5.4. CloseNonFiscalReceipt - Cerrar comprobante no fiscal 76
*  3.6. Comandos de documentos no fiscales homologados 77
*  3.6.1. OpenDNFH - Abrir documento no fiscal homologado  77
*  3.6.2. PrintEmbarkItem - Imprimir item en remito u orden de salida  79
*  3.6.3. PrintAccountItem - Imprimir item en resumen de cuenta o en cargo a la
*  habitaci¢n  80
*  3.6.4. PrintQuotationItem - Imprimir item en cotizaci¢n 81
*  3.6.5. CloseDNFH - Cerrar documento no fiscal homologado    82
*  3.7. Comandos comunes a varios tipos de documentos  83
*  3.7.1. Cancel - Cancelaci¢n 83
*  3.7.2. Reprint - Reimpresi¢n del último documento emitido   84
*  3.7.3. BarCode - C¢digo de barras   85
*  3.8. Comandos de fecha, hora, encabezamiento y cola de documentos   87
*  3.8.1. SetDateTime - Ingresar fecha y hora  87
*  3.8.2. GetDateTime - Consultar fecha y hora 88
*  3.8.3. SetFantasyName - Programar texto del nombre de fantas¡a del
*  propietario 89
*  3.8.4. GetFantasyName - Reportar texto del nombre de fantas¡a del propietario   90
*  3.8.5. SetHeaderTrailer - Programar texto de encabezamiento y cola de
*  documentos  91
*  3.8.6. GetHeaderTrailer - Reportar texto de encabezamiento y cola de
*  documentos  93
*  3.8.7. SetCustomerData - Datos comprador factura    94
*  3.8.8. SetEmbarkNumber - Cargar informaci¢n remito / comprobante original   96
*  3.8.9. GetEmbarkNumber - Reportar informaci¢n remito / comprobante original 97
*  3.9. Comandos para uso de la DGI    98
*  3.9.1. DGICommandProcessor - Procesador de comandos DGI 98
*  3.9.2. DGIRequestByDate - Reporte de auditor¡a DGI por fechas   98
*  3.9.3. DGIRequestByZNumber - Reporte de auditoria DGI por Z 98
*  3.9.4. KillEprom - Comando de baja del controlador fiscal   98
*  4. Documentos   99
*  4.1. Facturas, Notas de débito y Notas de crédito   99
*  4.2. Recibos fiscales y Recibos X   99
*  4.3. Remitos y Ordenes de salida    99
*  4.4. Cotizaciones   99
*  4.5. Resúmenes de cuenta y Cargos a la habitaci¢n   99
*  4.6. Documentos no fiscales 100
*  4.7. Comandos que afectan a varios tipos de documentos  100
*  Apéndices   101
*  Apéndice 1: Tipo de letra.  101
*  Apéndice 2: Status fiscal   102
*  Apéndice 4: Status auxiliar 103
*  Apéndice 5: Status de documento 104
*  Apéndice 6: Manejo del IVA, impuestos internos  y percepciones  105
*  6.1. Estructura de la tabla de IVA  105
*  6.2. Estructura de la tabla de percepciones 105
*  6.3. Campo de % Base IVA    105
*  6.4. C lculo del monto del IVA en los recargos o descuentos generales   106
*  6.5. Impresi¢n de las l¡neas correspondientes a descuentos (o recargos) 106
*  6.5.1. Facturas A   106
*  6.5.2. Facturas B   107
*  Apéndice 7. Redondeo y ajustes de montos    108
*  7.1. Redondeo de decimales  108
*  7.1. Ajustes por redondeo   108
*


*****************************************************************************
*  3.2.1. StatusRequest - Consulta de estado
*
*  Sintaxis:
*  StatusRequest( nComp, cTipo )
*	   cTipo = A. Factura A
*			   B: Factura B o C
*			   a: Recibo A
*			   b: Recibo B o C
*			   D: Nota de Débito A
*			   E: Nota de Débito B o C
*
*  Responde, a través de la l¡nea serie, con el estado en que se encuentra el
*  controlador fisca, el hardware del impresor y los documentos emitidos.
*
*  Nota:
*  El significado de la respuesta de los campos Status de la impresora, Status fiscal,
*  Status auxiliar y Status de documento se describe en los Apéndices 2, 3, 4 y 5.
*
*  Comando
*  Longitud    Descripci¢n																   Tipo
*	   4	   * (ASCII 42)
*
*
*  Respuesta
*  Longitud    Descripci¢n									   Tipo
*	   4	   * (ASCII 42)
*	   1	   FS
*	   4	   Status de la impresora: datos en ASCII		   H
*	   1	   FS
*	   4	   Status fiscal: datos en ASCII				   H
*	   1	   FS
*	   8   3   N§ último documento B/C emitido (nnnnnnnn)	   N
*	   1	   FS
*	   8	   Status auxiliar: datos en ASCII				   H
*	   1	   FS
*	   8   5   N§ último documento A emitido (nnnnnnnn) 	   N
*	   1	   FS
*	   4	   Status documento: datos en ASCII 			   H
*	   1	   FS
*	   8   7   N§ última nota de crédito B/C emitida (nnnnnnnn)N
*	   1	   FS
*	   8   8   N§ último nota de crédito A emitida (nnnnnnnn)  N
*	   1	   FS
*	   8   9   N§ último remito emitido (nnnnnnnn)			   N

Function StatusRequest
	Private sComando

	sComando =  Chr( 42 )


	Return sComando


	*****************************************************************************
	* 3.2.6. GetPrinterVersion - Consulta de versi¢n de controlador fiscal
	* Responde, a través de la l¡nea serie, con el modelo y versi¢n del controlador fiscal.
	*
	* Comando
	* Longitud	  Descripci¢n																  Tipo
	*	  1 	  (ASCII 127)
	*
	* Respuesta
	* Longitud	  Descripci¢n																  Tipo
	*	  1 	  (ASCII 127)
	*	  1 	  FS
	*	  4 	  Status de la impresora: datos en ASCII						  H
	*	  1 	  FS
	*	  4 	  Status fiscal: datos en ASCII 										  H
	*	  1 	  FS
	*	  35	  Versi¢n																		  A
	* SMH/PJ-20F - Versi¢n n.nn - DD/MM/AA
	* SMH/P-320F - Versi¢n n.nn - DD/MM/AA
	*
	*
	*

Function GetPrinterVersion()
	Local loHasar As "Hasar.Fiscal.1"
	Local lcModelo As String
	Local lcComando As String

	Try

		lcModelo = ""

		If lHasar
			lcComando = Chr( 127 )
			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"


			llRetry = .T.

			Do While llRetry

				llRetry = .F.

				Try

					loHasar.cEjecutando = "Autodetectar Modelo"
					loHasar.AutodetectarModelo()


				Catch To oErr

					llRetry = RetryCommand( oErr, loHasar.cEjecutando )

					If !llRetry
						Throw oErr
					Endif

				Finally

				Endtry

			Enddo

			loHasar.cEjecutando = "Get Printer Version"
			loHasar.Enviar( lcComando )
			loHasar.cModelo = loHasar.Respuesta( 3 )
			lcModelo = loHasar.cModelo
		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null

	Endtry

	Return lcModelo



	*****************************************************************************
	*  3.3. Comandos de control fiscal 38
	*
	*  3.3.2. DailyClose - Cierre de jornada fiscal
	*  Chequea el estado de la memoria de trabajo y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde, según sea el contenido enviado en el byte número 5, con:
	*  a.  Byte numero 5: cualquier caracter excepto Z
	*  Impresi¢n de un Informe X. En ese caso los acumuladores correspondientes a
	*  reportes de lectura son puestos en cero, conserv ndose en memoria diaria los
	*  acumuladores correspondientes al comando de cierre diario.
	*  b.  Byte número 5: Z
	*  Cierre de jornada fiscal: volcado de acumuladores de memoria de trabajo a
	*  memoria fiscal, puesta a cero de los acumuladores en memoria de trabajo, e
	*  impresi¢n de informe Z de cierre de jornada fiscal.
	*  Una vez impreso el reporte, avanza y corta el papel e imprime la raz¢n social y el
	*  número de CUIT en el encabezamiento del siguiente ticket.
	*
	*  Comando
	*  Longitud    Descripci¢n												 Tipo
	*	   1	   9 (ASCII 57)
	*	   1	   FS
	*	   1	   Z: Cierre de jornada fiscal; otro caracter: Informe X	   A
	*
	*  Respuesta
	*  Longitud    Descripci¢n												 Tipo
	*	   1	   9 (ASCII 57)
	*	   1	   FS
	*	   4	   Status de la impresora: datos en ASCII					   H
	*	   1	   FS
	*	   4	   Status fiscal: datos en ASCII							   H
	*
	*	   1	   FS
	*	   4	   N§ de Z ¢ N§ de Informe X   (nnnn)						   N
	*	   1	   FS
	*	   5	   Cantidad de documentos fiscales cancelados	(nnnnn) 	   N
	*	   1	   FS
	*	   5	   Cantidad de doc. no fiscales homologados (nnnnn) 		   N
	*	   1	   FS
	*	   5	   Cantidad de documentos no fiscales (nnnnn)				   N
	*	   1	   FS
	*	   6	   Cantidad de documentos fiscales emitidos 				   N
	*	   1	   FS
	*	   1	   Reservado (siempre en 0) 								   N
	*	   1	   FS
	*	   8	   N§ último documento B/C emitido (nnnnnnnn)				   N
	*	   1	   FS
	*	   8	   N§ último documento A emitido (nnnnnnnn) 				   N
	*	   1	   FS
	*	   12	   Monto vendido en doc. fiscales (nnnnnnnnn.nn)			   N
	*	   1	   FS
	*	   12	   Monto IVA   en doc. fiscales (nnnnnnnnn.nn)				   N
	*	   1	   FS
	*	   12	   Monto Imp. Internos en doc. fiscales (nnnnnnnnn.nn)		   N
	*	   1	   FS
	*	   12	   Monto percepciones  en doc. fiscales (nnnnnnnnn.nn)		   N
	*	   1	   FS
	*	   12	   Monto IVA no inscripto  en doc. fisc. (nnnnnnnnn.nn) 	   N
	*	   1	   FS
	*	   8	   N§ última nota de crédito B/C emitida (nnnnnnnn) 		   N
	*	   1	   FS
	*	   8	   N§ última nota de crédito A emitida (nnnnnnnn)			   N
	*	   1	   FS
	*	   12	   Cred¡to en notas de crédito (nnnnnnnnn.nn)				   N
	*	   1	   FS
	*	   12	   Monto IVA   en notas de crédito (nnnnnnnnn.nn)			   N
	*	   1	   FS
	*	   12	   Monto Imp. Int. en notas de crédito (nnnnnnnnn.nn)		   N
	*	   1	   FS
	*	   12	   Monto percepciones  en notas de crédito (nnnnnnnnn.nn)	   N
	*	   1	   FS
	*	   12	   Monto IVA no insc. en notas de crédito (nnnnnnnnn.nn)	   N
	*	   1	   FS
	*	   8	   Nø último remito (nnnnnnnn)								   N


Function DailyClose
	Para cTipo
	Priv sComando

	cTipo	=  IfEmpty( cTipo, "Z"   )
	sComando =  Chr( 57 ) + FS + cTipo

	Return sComando

	*****************************************************************************

	*  3.3.3. DailyCloseByDate - Reporte de auditoria por fechas
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra
	*  Responde imprimiendo un reporte de auditor¡a entre fecha_inicial / fecha_final, que
	*  son seleccionadas de la siguiente manera. Se consultan los valores de los bytes 5-
	*  10 y 12-17. Si en la memoria fiscal existen registros correspondientes a tales
	*  fechas, se informan los datos entre ellas. Si una o ambas fechas no corresponden
	*  a registros existentes, se seleccionan la o las fechas m s cercanas a las solicitadas
	*  que s¡ cuenten con registros, siempre dentro del per¡odo solicitado. Los datos
	*  informados tienen las siguientes caracter¡sticas, según sea el contenido del byte
	*  número 19:
	*  a.  Byte número 19: T
	*  Imprime los datos globales del per¡odo.
	*  b.  Byte número 19: cualquier caracter excepto T
	*  Imprime los datos del per¡odo discriminados por jornada fiscal.
	*  En ambos casos, antes del reporte se imprimen las fechas del per¡odo solicitado,
	*  las del per¡odo auditado y los números de Z correspondientes a éste último.
	*  Una vez impreso el reporte, avanza y corta el papel e imprime la raz¢n social y el
	*  número de CUIT en el encabezamiento del siguiente ticket.
	*
	*  Nota:
	*  Los montos son informados sin centavos y son similares a los impresos en los
	*  Reportes Z, luego de redondearse los centavos (los valores iguales o mayores a
	*  0,5 son redondeados hacia arriba; los valores menores son redondeados hacia
	*  abajo).
	*
	*
	*  Comando
	*  Longitud    Descripci¢n													Tipo
	*	   1			   : (ASCII 58)
	*	   1			   FS
	*	   6			   Fecha inicial del per¡odo (formato AAMMDD)			 D
	*	   1			   FS
	*	   6			   Fecha final del per¡odo (formato AAMMDD) 			 D
	*	   1			   FS
	*	   1			   Tipo de datos										 A
	*						   T: datos globales; otro caracter: datos por Z
	*
	*
	*  Respuesta
	*
	*	   Longitud 	   Descripci¢n															   Tipo
	*	   1			   : (ASCII 58)
	*	   1			   FS
	*	   4			   Status de la impresora											   H
	*	   1			   FS
	*	   4			   Status Fiscal															   H
	*

Function CloseByDate
	Para cFecInicial,cFecFinal,cTipo
	Priv sComando

	cTipo	   =  IfEmpty( cTipo, "T"   )
	cFecInicial =  IfEmpty( cFecInicial, F_Feca( Date() ))
	cFecFinal   =  IfEmpty( cFecFinal, F_Feca( Date() ))

	If Vartype( cFecInicial ) =  "D"
		cFecInicial =  F_Feca( cFecInicial )
	Endif

	If Vartype( cFecFinal ) =  "D"
		cFecFinal =  F_Feca( cFecFinal )
	Endif

	sComando    =  Chr( 58 ) + FS + cFecInicial
	sComando    =  sComando + FS + cFecFinal
	sComando    =  sComando + FS + cTipo

	Return sComando

	*****************************************************************************
	*  3.3.4. DailyCloseByNumber - Reporte de auditoria por número de Z
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra
	*  Responde imprimiendo un reporte de auditor¡a entre entre Z_inicial / Z_final, que
	*  son seleccionadas de la siguiente manera. Se consultan los valores de los bytes 5-
	*  8 y 10-13. Si en la memoria fiscal existen registros correspondientes a tales
	*  números de Z, se informan los datos entre ellos. Si uno o ambos números de Z no
	*  corresponden a registros existentes, se seleccionan el o los números de Z m s
	*  cercanos a los solicitados que s¡ cuenten con registros, siempre dentro del rango
	*  solicitado. Los datos informados tienen las siguientes caracter¡sticas, según sea el
	*  contenido del byte número 15:
	*  a.  Byte número15: T
	*  Imprime los datos globales del per¡odo.
	*  b.  Byte número 15: cualquier caracter excepto T
	*  Imprime los datos del per¡odo discriminados por jornada fiscal.
	*  En ambos casos, antes del reporte se imprimen los número de Z del per¡odo
	*  solicitado, los del per¡odo auditado y las fechas correspondientes a éste último.
	*  Una vez impreso el reporte, avanza y corta el papel e imprime la raz¢n social y el
	*  número de CUIT en el encabezamiento del siguiente ticket.
	*
	*  Nota:
	*  Los montos son informados sin centavos y son similares a los impresos en los
	*  Reportes Z luego de redondearse los centavos (los valores iguales o mayores a 0,5
	*  son redondeados hacia arriba; los valores menores son redondeados hacia abajo).
	*
	*
	*  Comando
	*  Longitud    Descripci¢n											 Tipo
	*	   1			   ; (ASCII 59)
	*	   1			   FS
	*	   4			   Número de Z inicial del per¡odo				 N
	*	   1			   FS
	*	   4			   Número de Z final del per¡odo				 N
	*	   1			   FS
	*	   1   Tipo de datos											 A
	*					   T: datos globales; otro caracter: datos por Z
	*
	*  Respuesta
	*
	*	   Longitud 	   Descripci¢n															   Tipo
	*	   1			   ; (ASCII 59)
	*	   1			   FS
	*	   4			   Status de la impresora											   H
	*	   1			   FS
	*	   4			   Status Fiscal															   H
	*
	*
Function CloseByNumber
	Para nZInicial,nZFinal,cTipo
	Priv sComando

	cTipo	   =  IfEmpty( cTipo, "T"   )
	nZInicial   =  IfEmpty( nZInicial, 1 )
	nZFinal	   =  IfEmpty( nZFinal  , 9999 )

	sComando    =  Chr( 59 ) + FS + StrZero(nZInicial,4)
	sComando    =  sComando + FS + StrZero(nZFinal,4)
	sComando    =  sComando + FS + cTipo

	Return sComando

	*****************************************************************************
	*  3.3.5. GetDailyReport - Reporte de registro diario
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Env¡a por el canal serie los datos correspondientes a uno de los registros diarios
	*  almacenados en la memoria fiscal, de acuerdo con lo siguiente:
	*  a.  Si en los bytes 5-8 se ingresa un número de Z, env¡a los datos
	*  correspondientes al registro de dicha Z. El byte 11 debe llenarse con el
	*  caracter Z.
	*  b.  Si en los bytes 5-10 se ingresa una fecha (formato AAMMDD), env¡a los datos
	*  correspondientes al primer registro diario corespondiente a esa fecha. El byte
	*  11 debe llenarse con el caracter F.
	*
	*  Este comando es rechazado si se encuentra abierto un comprobante.
	*
	*  Nota:
	*  Los montos son informados sin centavos y coinciden con los montos impresos en
	*  los reportes de auditor¡a.
	*  Por otra parte, los montos informados son similares a los impresos en los Reportes
	*  Z luego de redondearse los centavos (los valores iguales o mayores a 0,5 son
	*  redondeados hacia arriba; los valores menores son redondeados hacia abajo).
	*
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   4	   < (ASCII 60)
	*	   1	   FS
	*	   6	   Número de Z o fecha (campo de longitud variable) 		   N / A
	*	   1	   FS
	*	   1	   Z: número de Z; F: fecha 											   A
	*
	*
	*	(Respuesta en p gina siguiente)
	*
	*  Respuesta
	*
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   < (ASCII 60)
	*	   1	   FS
	*	   4	   Status de la impresora													   H
	*	   1	   FS
	*	   4	   Status fiscal																	   H
	*
	*	   1	   FS
	*	   6	   Fecha del cierre reportado	(AAMMDD)							   N
	*	   1	   FS
	*	   4	   Número de Z del cierre reportado (nnnn)						   N
	*	   1	   FS
	*	   8	   N§ último documento fiscal B/C emitido (nnnnnnnn)		   N
	*	   1	   FS
	*	   8	   N§ último documento fiscal A emitido    (nnnnnnnn)			   N
	*	   1	   FS
	*	   9	   Monto vendido en documentos fiscales (nnnnnnnnn) 		   N
	*	   1	   FS
	*	   9	   IVA acumulado en documentos fiscales    (nnnnnnnnn)		   N
	*	   1	   FS
	*	   9	   Imp. internos acumulados en doc. fiscales (nnnnnnnnn)	   N
	*	   1	   FS
	*	   9	   Percepciones acumuladas en doc. fiscales (nnnnnnnn)	   N
	*	   1	   FS
	*	   9	   Monto IVA no inscripto en doc. fiscales (nnnnnnnnn)		   N
	*	   1	   FS
	*	   8	   N§ última nota de crédito B/C emitida (nnnnnnnn) 			   N
	*	   1	   FS
	*	   8	   N§ última nota de crédito A emitida (nnnnnnnn)				   N
	*	   1	   FS
	*	   9	   Monto vendido en notas de crédito (nnnnnnnnn)				   N
	*	   1	   FS
	*	   9	   IVA acumulado en notas de crédito (nnnnnnnnn)			   N
	*	   1	   FS
	*	   9	   Imp. internos acumulados en notas de créd. (nnnnnnnnn)  N
	*	   1	   FS
	*	   9	   Percepciones acumuladas en notas de créd. (nnnnnnnnn)   N
	*	   1	   FS
	*	   9	   Monto IVA no insc. en notas de crédito (nnnnnnnnn)		   N
	*	   1	   FS
	*	   8	   Número del último remito (nnnnnnnn)								   N

Function GetDailyReport
	Para cTipo,uValor,lShow
	Priv sComando,cReturn,cFecha,dFecha
	Priv cPant,cPant1,nI,nJ,nTop,nLeft,nBott,nRight
	Dimension aResp[17],aBytes[17],aPos[17]

	Try

		cReturn = ""

		If lHasar
			aResp[01]="Fecha del cierre reportado                  "
			aResp[02]="Número de Z del cierre reportado            "
			aResp[03]="Nº último documento fiscal B/C emitido      "
			aResp[04]="Nº último documento fiscal A emitido        "
			aResp[05]="Monto vendido en documentos fiscales        "
			aResp[06]="IVA acumulado en documentos fiscales        "
			aResp[07]="Imp. internos acumulados en doc. fiscales   "
			aResp[08]="Percepciones acumuladas en doc. fiscales    "
			aResp[09]="Monto IVA no inscripto en doc. fiscales     "
			aResp[10]="Nº última nota de crédito B/C emitida       "
			aResp[11]="Nº última nota de crédito A emitida         "
			aResp[12]="Monto vendido en notas de crédito           "
			aResp[13]="IVA acumulado en notas de crédito           "
			aResp[14]="Imp. internos acumulados en notas de créd.  "
			aResp[15]="Percepciones acumuladas en notas de créd.   "
			aResp[16]="Monto IVA no insc. en notas de crédito      "
			aResp[17]="Número del último remito                    "

			aBytes[01]=11
			aBytes[02]=4
			aBytes[03]=8
			aBytes[04]=8
			aBytes[05]=9
			aBytes[06]=9
			aBytes[07]=9
			aBytes[08]=9
			aBytes[09]=9
			aBytes[10]=8
			aBytes[11]=8
			aBytes[12]=9
			aBytes[13]=9
			aBytes[14]=9
			aBytes[15]=9
			aBytes[16]=9
			aBytes[17]=8

			For nI=1 To Len(aBytes)
				aPos[nI]=11
				For nJ=1 To nI-01
					aPos[nI] =  aPos[nI] +  aBytes[nJ] + 01
				Next
			Next


			For nI=1 To Len(aResp)
				aResp[nI]=Alltrim(aResp[nI])
				aResp[nI]=" "+aResp[nI]+Repl(".",50-Len(aResp[nI]))+": "
			Next

			*!*				lShow	   =  prxDefault( "lShow", .T. )
			cTipo       =  IfEmpty( cTipo, "T"   )

			If cTipo="T"
				uValor   =  IfEmpty( uValor, F_Feca( Date() ))
				If Type("uValor")="D"
					cValor   =  F_Feca( uValor )
				Else
					cValor   =  uValor
				Endif
			Else
				uValor   =  IfEmpty( uValor, 0 )
				cTipo    =  "Z"
				cValor   =  Alltrim( Str( uValor, 4 ))
			Endif

			sComando    =  Chr( 60 ) + FS + cValor
			sComando    =  sComando + FS + cTipo

			cReturn	   =  ""
			If Enviar( sComando )
				If lShow
					cFecha   =  Substr( cReturn, 11, 6)
					dFecha   =  F_Cafe( cFecha )
					Set Cent On
					cFecha   =  Dtoc( dFecha ) + " "
					Set Cent Off
					cReturn  =  Stuff( cReturn, 11, 6, cFecha)
					For nI=1 To Len( aResp )
						aResp[nI]	=  aResp[nI]   +  Substr( cReturn, aPos[nI], aBytes[nI] )
					Next

					nTop  =  Int( Max( 12 - ( Len( aResp ) / 2 ), 02 ))
					nBott =  Min( nTop + Len( aResp ) + 01, 22 )
					nLeft =  Int( ( 80 - Len( aResp[1]) ) / 2 ) - 01
					nRight=  nLeft + Len( aResp[1] ) + 01
					*!*				cPant1=  SaveScreen( 22, 00, 24, 79 )
					*!*				cPant =  SaveScreen( nTop, nLeft, nBott, nRight )
					*!*				S_Clear( 22, 00, 24, 79 )
					*!*				S_Clear( nTop, nLeft, nBott, nRight )
					*!*				S_Line23( Msg8 )
					*!*				@ nTop, nLeft To nBott, nRight Doub
					*!*				aChoice(nTop+01, nLeft+01, nBott-01, nRight-01, aResp)
					S_Opcion(nTop+01, nLeft+01, nBott-01, nRight-01, "aResp" )

					*!*				RestScreen( nTop, nLeft, nBott, nRight, cPant )
				Endif
			Endif
		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Retu cReturn

	*****************************************************************************

	*  3.3.6. GetWorkingMemory - Consulta de memoria de trabajo
	*  Responde, a través de la l¡nea serie, con los datos almacenados en memoria de
	*  trabajo durante la jornada fiscal.
	*
	*  Comando
	*  Longitud    Descripci¢n											 Tipo
	*	   1	   g (ASCII 103)
	*
	*  Respuesta
	*  Longitud    Descripci¢n											 Tipo
	*	   1	   g (ASCII 103)
	*	   1	   FS
	*	   4	   Status de la impresora: datos en ASCII				   H
	*	   1	   FS
	*	   4	   Status fiscal: datos en ASCII						   H
	*	   1	   FS
	*	   5	   Cantidad de documentos fiscales cancelados	(nnnnn)    N
	*	   1	   FS
	*	   5	   Cantidad de documentos no fiscales emitidos (nnnnn)	   N
	*	   1	   FS
	*	   5	   Cantidad de documentos fiscales emitidos 	(nnnnn)    N
	*	   1	   FS
	*	   8	   Ultimo documento B/C emitido (nnnnnnnn)				   N
	*	   1	   FS
	*	   8	   Ultimo documento A emitido (nnnnnnnn)				   N
	*	   1	   FS
	*	   8	   Monto vendido en documentos fiscales (nnnnnnnnn.nn)	   N
	*	   1	   FS
	*	   12	   IVA acumulado en documentos fiscales (nnnnnnnnn.nn)	   N
	*	   1	   FS
	*	   12	   Imp. int. acumulados en doc. fiscales (nnnnnnnnn.nn)    N
	*	   1	   FS
	*	   12	   Percepciones acumuladas en doc. fisc. (nnnnnnnnn.nn)    N
	*	   1	   FS
	*	   12	   IVA no incripto acumulado en doc. fisc. (nnnnnnnnn.nn)  N
	*	   1	   FS
	*	   8	   Ultima nota de crédito B/C emitida (nnnnnnnn)		   N
	*	   1	   FS
	*	   8	   Ultima nota de crédito A emitida (nnnnnnnn)			   N
	*	   1	   FS
	*	   12	   Crédito acumulado en notas de crédito (nnnnnnnnn.nn)    N
	*	   1	   FS
	*	   12	   IVA acumulado en notas de crédito (nnnnnnnnn.nn) 	   N
	*	   1	   FS
	*	   12	   Imp. int. acumulados en notas de crédito (nnnnnnnnn.nn) N
	*	   1	   FS
	*	   12	   Percep. acumulados en notas de créd. (nnnnnnnnn.nn)	   N
	*	   1	   FS
	*	   12	   IVA no incripto acumulado en doc. fisc. (nnnnnnnnn.nn)  N
	*	   1	   FS
	*	   8	   Ultimo remito emitido (nnnnnnnn) 					   N
	*
	*

Function GetWorkingMemory
	Para lShow
	Priv sComando,cReturn
	Priv cPant,cPant1,nI,nJ,nTop,nLeft,nBott,nRight
	Dimension aResp[18]
	Priv Resp,Origen,OffsetSep,cResp,nWide

	Try


		*!*			lShow	   =  prxDefault( "lShow", .T. )

		sComando    =  Chr( 103 )
		cReturn	   =  ""

		If lHasar

			If Enviar( sComando )
				If lShow
					aResp[01]="Cantidad de documentos fiscales cancelados  "
					aResp[02]="Cantidad de documentos no fiscales emitidos "
					aResp[03]="Cantidad de documentos fiscales emitidos    "
					aResp[04]="Ultimo documento B/C/T emitido              "
					aResp[05]="Ultimo documento A emitido                  "
					aResp[06]="Monto vendido en documentos fiscales        "
					aResp[07]="IVA acumulado en documentos fiscales        "
					aResp[08]="Imp. int. acumulados en doc. fiscales       "
					aResp[09]="Percepciones acumuladas en doc. fisc.       "
					aResp[10]="IVA no incripto acumulado en doc. fisc.     "
					aResp[11]="Ultima nota de crédito B/C emitida          "
					aResp[12]="Ultima nota de crédito A emitida            "
					aResp[13]="Crédito acumulado en notas de crédito       "
					aResp[14]="IVA acumulado en notas de crédito           "
					aResp[15]="Imp. int. acumulados en notas de crédito    "
					aResp[16]="Percep. acumulados en notas de créd.        "
					aResp[17]="IVA no incripto acumulado en doc. fisc.     "
					aResp[18]="Ultimo remito emitido                       "

					For nI=1 To Len(aResp)
						aResp[nI]=Alltrim(aResp[nI])
						aResp[nI]=" "+aResp[nI]+Repl(".",50-Len(aResp[nI]))+": "
					Next

					Origen = 0
					Resp	= cReturn
					For nI = 1 To 2
						Resp		= Substr( Resp, Origen )
						OffsetSep	= At ( FS, Resp )
						Origen		= OffsetSep + 1
					Next

					For nI = 1 To Len( aResp )
						Resp		= Substr( Resp, Origen )
						OffsetSep	= At ( FS, Resp )
						Origen		= OffsetSep + 1

						If nI < Len( aResp )
							cResp	   = Substr( Resp, 1, OffsetSep-1)
						Else
							cResp	   = Resp
						Endif

						aResp[nI]	= aResp[nI] + cResp + " "
					Next

					nWide =  0
					For nI=1 To Len(aResp)
						nWide =  Max( nWide, Len( aResp[nI] ))
					Next

					nTop  =  Int( Max( 12 - ( Len( aResp ) / 2 ), 02 ))
					nBott =  Min( nTop + Len( aResp ) + 01, 22 )
					nLeft =  Int( ( 80 - nWide ) / 2 ) - 01
					nRight=  nLeft + nWide + 01
					*!*				cPant1=  SaveScreen( 22, 00, 24, 79 )
					*!*				cPant =  SaveScreen( nTop, nLeft, nBott, nRight )
					*!*				S_Clear( 22, 00, 24, 79 )
					*!*				S_Clear( nTop, nLeft, nBott, nRight )
					*!*				S_Line23( Msg8 )
					*!*				@ nTop, nLeft To nBott, nRight Doub
					*!*				aChoice(nTop+01, nLeft+01, nBott-01, nRight-01, aResp)

					S_Opcion(nTop+01, nLeft+01, nBott-01, nRight-01, "aResp" )

					*!*				RestScreen( nTop, nLeft, nBott, nRight, cPant )

				Endif
			Endif
		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Retu cReturn


	*****************************************************************************

	*
	*  3.3.7. SendFirstIVA - Iniciar informaci¢n de IVA
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Inicia el env¡o, por el canal serie, de montos asociados a porcentajes de IVA,
	*  impuestos internos, y percepciones.
	*  a. Si se lo emite inmediatamente después de haber cerrado una factura, nota de
	*  débito, recibo o nota de crédito, informa los valores acumulados en este
	*  documento. En este caso, los montos correspondientes a las percepciones son
	*  informados percepci¢n por percepci¢n.
	*  b. Si se lo emite inmediatamente después de un reporte Z, informa los valores
	*  correspondientes a la jornada fiscal que se acaba de cerrar. En este caso, los
	*  montos correspondientes a las percepciones son los acumulados
	*  correspondientes a cada al¡cuota de IVA y a las percepciones generales.
	*  Este comando es complementado por el comando NextIVATransmission (ver
	*  3.4.8), de manera que ambos informan, para cada porcentaje, el monto del IVA, las
	*  percepciones y el monto neto de las ventas (realizadas con dicho porcentaje).
	*  El orden en que env¡an los datos es el mismo en el que los diferentes porcentajes
	*  ingresaron en la tabla de IVAs.
	*
	*  Este comando es rechazado si:
	*  a. se encuentra abierto un comprobante.	b. se lo emite inmediatamente después
	*  de cancelarse una factura, nota de débito, recibo o nota de crédito. c. se lo emite a
	*  continuaci¢n de los comandos de inicializaci¢n o formateo de memoria, o después
	*  de realizarse un reseteo de hard (MAC).
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   p (ASCII 112)
	*
	*
	*  Si el campo indicado como número de registro (byte 15) lleva el valor 1, el informe
	*  corresponde a facturas, recibos y notas de débito; si lleva el valor 3, corresponde a
	*  notas de crédito.
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   p (ASCII 112)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H
	*	   1	   FS
	*	   1	   Número de registro:													   N
	*					 1: datos de IVA de documentos fiscales
	*					 3: datos de IVA de notas de crédito
	*	   1	   FS
	*	   5	   Porcentaje de IVA del que se informa 							   N
	*	   1	   FS
	*	   12	   Monto de IVA acumulado en el ticket							   N
	*	   1	   FS
	*	   12	   Monto de impuestos internos acumulado en el ticket	   N
	*	   1	   FS
	*	   12	   Monto de IVA no inscripto acumulado en el ticket 		   N
	*	   1	   FS
	*	   12	   Venta neta (sin IVA) 													   N
	*
	*  Nota:
	*  El monto de impuestos internos informado es la suma de los impuestos internos
	*  fijos y porcentuales (en los modelos anteriores s¢lo se informaban los impuestos
	*  internos porcentuales).
	*

	*****************************************************************************

	*
	*  3.3.8. NextIVATransmission - Continuar informaci¢n de IVA
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Continúa el env¡o, por el canal serie, de montos asociados a porcentajes de IVA,
	*  Impuestos y percepciones.
	*  Este comando es complemento del comando SendFirstIVA (ver 3.4.7), de manera
	*  que ambos informan, para cada porcentaje, el monto del IVA, las percepciones y el
	*  monto neto de las ventas (realizadas con dicho porcentaje).
	*  El orden en que se env¡an los datos es el mismo en el que los diferentes
	*  porcentajes ingresaron en la tabla de IVAs.
	*  Este comando puede emitirse todas las veces seguidas que sea necesario. A cada
	*  nueva emisi¢n del comando se transmitir n los datos asociados con el siguiente
	*  porcentaje almacenado en la tabla de IVAs, evi ndolos en el mismo formato que el
	*  comando SendFirstIVA. Una vez que haya recorrido totalmente la tabla,
	*  informando sobre montos de IVA, de impuestos internos y de ventas, continúa
	*  enviando, para cada al¡cuota del IVA, el monto de las percepciones asociadas con
	*  dicha al¡cuota. En caso de no existir percepciones, o luego de informar sobre la
	*  última, se enviar  un campo en cero.
	*
	*  Nota: en los casos en que se informa de percepciones generales, el campo
	*  correspondiente a al¡cuota del IVA lleva los caracteres **.**.
	*
	*  Este comando es rechazado si no se ha emitido inmediatamente antes el comando
	*  SendFirstIVA o el propio comando NextIVATransmission.
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   q (ASCII 113)
	*
	*  Si aún hay datos en la tabla de IVAs referidos a montos, el formato de respuesta es
	*  similar al del comando SendFirstIVA.
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   q (ASCII 113)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   1	   Status fiscal																   H
	*	   1	   FS
	*
	*	   1	   Número de registro:													   N
	*  1: datos de IVA de documentos fiscales
	*  3: datos de IVA de notas de crédito
	*	   1	   FS
	*	   5	   Porcentaje de IVA del que se informa 							   N
	*	   1	   FS
	*	   12	   Monto de IVA acumulado en el ticket							   N
	*	   1	   FS
	*	   12	   Monto de impuestos internos acumulado en el ticket	   N
	*	   1	   FS
	*	   12	   Monto de IVA no inscripto acumulado en el ticket 		   N
	*	   1	   FS
	*	   12	   Venta neta (sin IVA) 													   N
	*
	*
	*  Nota:
	*  El monto de impuestos internos informado es la suma de los impuestos internos
	*  fijos y porcentuales (en los modelos anteriores s¢lo se informaban los impuestos
	*  internos porcentuales).
	*
	*
	*  (Continúa en la p gina siguiente)
	*
	*
	*
	*  A finalizar la tabla de IVAs se continúa informando los montos de las percepciones,
	*  recorriéndose nuevamente la tabla de IVAs.
	*  El valor 3 en el campo del registro (byte 15) indica que se est n informando montos
	*  de percepciones correspondientes a documentos fiscales (Facturas, recibos y
	*  notas de débito); el valor 4 indica que se est n informando montos
	*  correspondientes a notas de débito. Los asteriscos en los bytes 15-21 indica que se
	*  est n enviando percepciones generales. En caso de no existir percepciones, se
	*  saltea este informe, pas ndose directamente al informe de cierre.
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   q (ASCII 113)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   1	   Status fiscal																   H
	*	   1	   FS
	*
	*	   1	   Número de registro:													   N
	*	   2: percepciones de documentos fiscales
	*  4: percepciones de notas de crédito
	*	   1	   FS
	*	   5	   Al¡cuota de IVA/**.** de la que se informa					   N
	*	   1	   FS
	*	   12	   Monto de la percepci¢n acumulada en el ticket			   N
	*	   1	   FS
	*
	*
	*  A finalizar el informe de las percepciones se env¡a el informe de cierre.
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   q (ASCII 113)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   1	   Status fiscal																   H
	*	   1	   FS
	*	   1	   0: no quedan m s montos que informar 						   N
	*

	*****************************************************************************


	*  3.4. Comandos de comprobante fiscal y nota de crédito
	*
	*  3.4.1. OpenFiscalReceipt - Abrir comprobante fiscal
	*
	*  Sintaxis:
	*  OpenFiscalReceipt( cTipo )
	*	   cTipo = A. Factura A
	*			   B: Factura B o C
	*			   a: Recibo A
	*			   b: Recibo B o C
	*			   D: Nota de Débito A
	*			   E: Nota de Débito B o C
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde:
	*  a.  Abriendo un comprobante fiscal; b. Imprimiendo el encabezamiento; c. Borrando
	*  el comprobante provisorio que se encuentra en la memoria de trabajo, de manera
	*  que los acumuladores correspondientes queden dispuestos para iniciar un nuevo
	*  comprobante.
	*
	*  Opciones:
	*  Tipo de documento: Byte 5
	*  En este byte se declara el tipo de documento que se desea abrir: Factura A (A),
	*  Factura B/C (B), Recibo A (a), Recibo B/C (b), Nota de Débito A (D)	o Nota de
	*  Débito B/C (E).
	*  Previamente a la apertura del documento deben cargarse los datos del
	*  comprador mediante el comando CustomerData, excepto en el caso en que el
	*  comprador sea consumidor final.
	*  En los casos en que se abren facturas, notas de débito o notas de crédito, el
	*  valor del byte 5 debe ser compatible con la responsabilidad frente al IVA del
	*  propietario del controlador (ver comandos Init y ConfigureControllerByBlock) y
	*  del comprador (ver comando CustomerData). Las combinaciones admitidas
	*  son:
	*
	*	Propietario 						Comprador				   Byte 5
	*
	*	Resp. inscripto 					Resp. inscripto 			   A
	*	Resp. inscripto 					Resp. no inscripto			   A
	*	Resp. inscripto 					No responsable				   B
	*	Resp. inscripto 					Exento						   B
	*	Resp. inscripto 					Consumidor final			   B
	*	Resp. inscripto 					Venta de bienes de uso		   B
	*	Resp. inscripto 					Responsable monotributo 	   B
	*	Resp. inscripto 					No categorizado 			   B
	*	Resp. no inscripto					Cualquiera					   B*
	*	No responsable						Cualquiera					   B*
	*	Exento								Cualquiera					   B*
	*	Responsable monotributo 			Cualquiera					   B*
	*
	*  * Responde abriendo un comprobante C
	*
	*
	*  Este comando es rechazado si:
	*  a.  Ya se encuentra abierto un comprobante fiscal; b. La memoria fiscal est  llena;
	*  c. Se detecta un error en la memoria de trabajo o en la memoria fiscal; d. Se intenta
	*  abrir una factura, recibo fiscal o nota de débito de tipo A, o una nota de crédito de
	*  cualquier tipo, y previamente no se han cargado los datos del comprador con el
	*  comando CustomerData; e. El valor del byte 5 no respeta la tabla anterior.
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   @ (ASCII 64)
	*	   1	   FS
	*	   1	   Tipo de documento													   A
	*						A. Factura A
	*						B: Factura B o C
	*						a: Recibo A
	*						b: Recibo B o C
	*						D: Nota de Débito A
	*						E: Nota de Débito B o C
	*	   1	   FS
	*	   1	   T ¢ S (valor fijo)															   A (Opc)
	*

Function OpenFiscalReceipt
	Para cTipo
	Priv sComando

	Local llOk As Boolean
	Local loHasar As "Hasar.Fiscal.1"


	Try

		loHasar = NewHasar()
		loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
		loHasar.cEjecutando = "Abriendo Comprobante Fiscal"



		llOk = .F.
		*!*			cTipo	=  IfEmpty( cTipo, "B"   )
		sComando =  Chr( 64 ) + FS + cTipo + FS + "T"

		llOk = Enviar( sComando )

		If llOk
			If Upper( loHasar.DescripcionEstadoControlador ) = Upper( "No hay ningún comprobante abierto" )
				llOk = .F.
				Stop( "No Se Ha Podido Abrir El Comprobante", "Fallo al abrir el comprobante" )

			Else
				If !lNCR
					Wait Window "Se Ha Abierto El Siguiente Comprobante: " + loHasar.DescripcionDocumentoEnCurso Nowait
					loHasar.cRemark = loHasar.DescripcionDocumentoEnCurso
				Endif

			Endif

		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null

	Endtry

	Return llOk

	************************************************************************************


	*  3.4.2. PrintFiscalText - Imprimir texto fiscal
	*
	*  Sintaxis:
	*  PrintFiscalText( cTexto, lDobleAncho )
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra
	*  Responde imprimiendo un texto (t¡picamente, datos descriptivos de una venta) con
	*  una longitud m xima de 50 caracteres. En caso de que el documento abierto sea
	*  un recibo, el comando es aceptado pero no provoca ninguna acci¢n.
	*  Si el primer caracter del campo de la descripci¢n es F4H (244), la informaci¢n se imprime
	*  en doble ancho y la cantidad m xima de caracteres a ingresar debe ser 25.
	*  Este comando puede emitirse hasta un m ximo de cuatro veces seguidas, y s¢lo
	*  puede estar seguido por el comando 42H (66) (PrintLineItem).
	*
	*  Este comando es rechazado si no se encuentra abierto una factura o una nota de
	*  crédito.
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   A (ASCII 65)
	*	   1	   FS
	*	   50	   Hasta 50 caracteres de texto 										   A
	*	   1	   FS
	*	   1	   Par metro display   : 0, 1 o 2										   N (Opc)
	*	   (colocar cualquiera de los tres valores;
	*	   no tiene efecto en el presente modelo)
	*  P-615F (MAXIMO 28)

Function PrintFiscalText
	Para cTexto, lDobleAncho
	Priv sComando,nLen
	Local loHasar As "Hasar.Fiscal.1"


	Try

		
		If !lHasar
			StrToFile( cTexto + CRLF, "HasarPrint.txt", 1 )
		EndIf
		
		loHasar = NewHasar()
		loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"

		*!*			lDobleAncho =  prxDefault( "lDobleAncho", .F. )
		If lDobleAncho
			sComando =  Chr( 65 ) + FS + Chr( 244 )
		Else
			sComando =  Chr( 65 ) + FS
		Endif

		Do Case
			Case loHasar.nModelo = MODELO_615
				nLen = 28

			Case Inlist( loHasar.nModelo, MODELO_715, MODELO_715_201, MODELO_715_302, MODELO_715_403, MODELO_P441 )
				nLen = 28

			Otherwise
				nLen = 50

		Endcase


		If lDobleAncho
			nLen = nLen / 2
		Endif

		cTexto	=  IfEmpty( cTexto, Space( 50 ) )
		cTexto	=  Substr( cTexto , 1, nLen )

		sComando =  sComando + cTexto + FS + "0"

		*!*			TEXT To lcCommand NoShow TextMerge Pretext 03
		*!*			Imprimiendo:

		*!*			Texto: <<cTexto>>
		*!*			ENDTEXT

		*!*			Wait Window lcCommand Nowait
		TEXT To lcCommand NoShow TextMerge Pretext 03
		Imprimir texto fiscal: [ <<cTexto>> ]
		ENDTEXT

		loHasar.cEjecutando = lcCommand

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null
	Endtry

	Return sComando

	************************************************************************************

	*  3.4.3. PrintLineItem - Imprimir ¡tem
	*
	*  Sintaxis:
	*  PrintLineItem( sTexto,;			   && Max. 50 caracteres
	*				  nCantidad,;		   && (+/-nnn.nnnnnnnnnn)
	*				  nPrecioUnitario,;    && (nnnnnn.nnnn)
	*				  nAiva,;			   && (nn.nn)
	*				  nAImpInt,;		   && (nn.nn)
	*				  lIncluyeIva
	*				  nDecCant,;		   && Decimales cantidad
	*				  nDecPrec,;		   && Decimales precio
	*				  )
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde:
	*  a.  Imprimiendo una l¡nea dividida en varios campos.
	*  En facturas A y B los campos son: cantidad, descripci¢n del ¡tem, precio unitario,
	*  al¡cuota de IVA, porcentaje del precio base afectado por impuestos internos y
	*  precio neto. En facturas C los campos son: cantidad, descripci¢n del ¡tem, precio
	*  unitario e importe. En el caso de los recibos, este comando no provoca una
	*  acci¢n inmediata, pero el monto ingresado es guardado en memoria de trabajo.
	*  Cuando el recibo se imprime, la cantidad que figura como recibida es la suma de
	*  los montos acumuladas mediante este comando;
	*  b. Sumando los montos de venta e IVA a los acumulados en el comprobante
	*  provisorio.
	*  Opciones
	*  Cantidad: Bytes 56-70
	*  Si el valor acumulado en estos bytes es distinto a 1, el precio neto que se
	*  imprime surge de multiplicar este valor por el del precio unitario (bytes 72-83).
	*  Imputaci¢n: Byte 91
	*  Si se llena este byte con el caracter M, el monto es sumado al subtotal parcial
	*  del documento (es decir se trata de una venta normal).
	*  Si se lo llena con el caracter m, el monto es descontado de acuerdo con lo
	*  siguiente:
	*  a.  Si los bytes 85-89 (al¡cuota de IVA) tienen un valor numérico, el monto es
	*  recargado o descontado del subtotal parcial del ticket y el IVA es descontado
	*  del acumulado correspondiente.
	*  b.  Si los bytes 85-89 est n llenos con asteriscos, el monto es recargado o
	*  descontado del subtotal (según el valor del byte 91), calcul ndose qué
	*  porcentaje del subtotal significa el recargo o descuento. Cada uno de los IVAs
	*  acumulados hasta el momento en el ticket son recargados o descontados en
	*  un porcentaje similar (ver Apéndice 5.2). En este caso el controlador cambia
	*  de estado y s¢lo permite ejecutar las siguientes operaciones: adicionar
	*  percepciones (comandos IVAPerceptions y OtherPerceptions), pagar
	*  (comando TotalTender) o cerrar el ticket (comando CloseFiscalReceipt).
	*  Impuestos internos: Bytes 93-120 (ver Apéndice 5.2)
	*  Existen dos formas diferentes de ingresar el valor de los impuestos internos:
	*  como coeficiente o como valor directo. El programador debe optar por una de
	*  ellas. A su vez, cada forma se divide en dos tipos de impuestos: fijos y
	*  porcentuales. Los impuestos internos fijos no son afectados por recargos o
	*  descuentos posteriores. En cambio, los impuestos internos porcentuales s¡ son
	*  afectados por recargos o descuentos posteriores.
	*  a. Coeficiente:
	*  El valor almacenado en estos bytes debe estar entre tener 0 y 1; si el valor es
	*  cero, no se lo tiene en cuenta. Llamando k al coeficiente de impuestos
	*  internos, es k = 1 / (1 + Ii), donde Ii indica el monto del impuesto interno como
	*  fracci¢n del precio base, expresado en forma decimal.
	*  Si el valor del coeficiente k almacenado es diferente de cero y va precedido
	*  por el signo +, el monto del impuesto interno es fijo.
	*  Si el valor del coeficiente k almacenado es diferente de cero y no va
	*  precedido por un signo, el monto del impuesto interno es porcentual.
	*  Si el valor almacenado es cero, no existen impuestos internos.
	*  Si se realiza un descuento o recargo general (ver punto anterior) el valor de
	*  b. Valores directos:
	*  El valor almacenado en estos bytes puede ser:
	*  b.1. El monto directo del impuesto interno por unidad vendida. En este caso,
	*  el monto debe ir precedido por el signo $ y se considera que el impuesto
	*  interno es fijo.
	*  b.2. El valor porcentual (considerado sobre el precio neto unitario) del
	*  impuesto interno. En este caso, el valor debe ir precedido por el signo %,
	*  debe expresarse como porcentaje (por ejemplo, 12,34% debe ingresarse
	*  como %12.34) y se considera que el impuesto interno es porcentual.
	*  En todos los casos, si el valor almacenado es cero, no existen impuestos
	*  internos.
	*  Si se realiza un descuento o recargo general (ver Imputaci¢n m s arriba) el valor
	*  de este campo es ignorado y se considera que est  en cero.
	*
	*  Calificador de monto: Byte 91
	*  Si se llena este byte con el caracter B, se indica que el valor almacenado en el
	*  precio unitario (bytes 72-83) no incluye el IVA. Si se lo llena con otro caracter, el
	*  monto incluye el IVA e impuestos internos, es decir, es el precio total.
	*
	*  Este comando es rechazado si:
	*  a.  No se encuentra abierto una factura o una nota de crédito; b. Los montos
	*  acumulados fueran a causar un desborde en la capacidad del acumulador del total.
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   B (ASCII 66)
	*	   1	   FS
	*	   50	   Hasta 50 caracteres de texto descripci¢n 	A
	*	   1	   FS
	*	   15	   Cantidad (?nnn.nnnnnnnnnn)					N
	*	   1	   FS
	*	   10	   Precio unitario (?nnnnnn.nnnn)				N
	*	   1	   FS
	*	   5	   Porcentaje IVA (nn.nn)/(**.**)				N
	*	   1	   FS
	*	   1	   M: suma monto; m: resta monto				A
	*	   1	   FS
	*	   19	   Impuestos internos							N
	*				  Coeficiente k:
	*				  +0.nnnnnnnn: impuestos internos fijos
	*				  0.nnnnnnnn: impuestos internos porcentuales
	*				  Valores directos:
	*				  $nnnnnnnnn.nnnnnnnn: impuestos internos fijos
	*				  %nnnnnnnnn.nnnnnnnn: imp. internos porcentuales
	*	   1	   FS
	*	   1	   Par metro display: 0, 1 o 2					 N (Opc)
	*				   (colocar cualquiera de los tres valores;
	*				   no tiene efecto en el presente modelo)
	*	   1	   FS
	*	   1	   T: precio total; otro car cter: precio base	 A
	*

	*  P-615F (MAXIMO 20 CARACTERES)


Function Descuento
	Private sComando
	*	sComando=PrintLineItem() con nAiva=-9999
	Return sComando

Function Recargo
	Private sComando
	*	sComando=PrintLineItem() con nAiva=-9999
	Return sComando


Function PrintLineItem( sTexto,;
		nCantidad,;
		nPrecioUnitario,;
		nAiva,;
		nAImpInt,;
		lIncluyeIva,;
		nDecCant,;
		nDecPrec )

	Private sComando,cCant,cPreU,cAiva,cImpI,cDisc,cSuma
	Local loHasar As "Hasar.Fiscal.1"
	Local llOk As Integer
	Local lnSubtotal As Number,;
		lnImporteIva As Number,;
		lnImporte As Number
	Local loIva As Object
	Local loIvas As Collection


	Try

		If lHasar Or .T. && No hay problema que entre, sirve para debuging

			*StrToFile( "", "PrintLineItem.txt" )

			llOk = .F.
			lnSubtotal = 0

			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"

			loIvas 				= loHasar.oIvas

			cCant	=  Alltrim( Str( Abs( nCantidad ),	15, nDecCant ))
			cPreU	=  Alltrim( Str( nPrecioUnitario, 10, nDecPrec ))
			cAiva	=  Iif( nAiva<0, "**.**", Alltrim( Str( nAiva, 5, 2 )))
			cImpI	=  "%"+Alltrim( Str( nAImpInt, 5, 2 ))
			cDisc	=  Iif( lIncluyeIva, "T", "N")
			cSuma	=  Iif( nCantidad<0, "m", "M")


			Do Case
				Case CF_MODEL='NCR'
					cImpI    =  Subst( cImpI, 2 )
					sTexto   =  Subst( sTexto, 1, 20 )

					*StrToFile( "Modelo NCR" + CRLF, "PrintLineItem.txt", 1 )

				Case loHasar.nModelo = MODELO_615
					cImpI    =  Subst( cImpI, 2 )
					sTexto   =  Subst( sTexto, 1, 20 )

					*StrToFile( "Modelo 615" + CRLF, "PrintLineItem.txt", 1 )

				Case Inlist( loHasar.nModelo,;
						MODELO_715,;
						MODELO_715_201,;
						MODELO_715_302,;
						MODELO_715_403,;
						MODELO_P441 )
					cImpI    =  Subst( cImpI, 2 )
					sTexto   =  Subst( sTexto, 1, 20 )

					*StrToFile( "Otros Modelos" + CRLF, "PrintLineItem.txt", 1 )

				Case Inlist( loHasar.nModelo,;
						MODELO_P330,;
						MODELO_P330_201,;
						MODELO_P320,;
						MODELO_P330_202,;
						MODELO_P330_203 )

					cImpI    =  Subst( cImpI, 2 )
					sTexto   =  Subst( sTexto, 1, 50 )

				Otherwise
					If lHasar
						Local lcMessage As String,;
							lcDetalle As String

						TEXT To lcMessage NoShow TextMerge Pretext 15
						PrintLineItem: Modelo No Reconocido
						ENDTEXT


						TEXT To lcDetalle NoShow TextMerge Pretext 15
						Modelo: <<loHasar.nModelo>>
						ENDTEXT

						Logerror( lcMessage, 0, lcDetalle )

						Error "PrintLineItem: Modelo No Reconocido"
					Endif

			EndCase
			
			If !lHasar
				Text To lcMsg NoShow TextMerge Pretext 03
				<<sTexto>> <<cCant>> <<cPreU>> <<cAiva>> <<cImpI>>
				EndText

				StrToFile( lcMsg + CRLF, "HasarPrint.txt", 1 )
			EndIf
			

			sComando =  Chr( 66 ) + FS
			sComando =  sComando + sTexto + FS
			sComando =  sComando + cCant  + FS
			sComando =  sComando + cPreU  + FS
			sComando =  sComando + cAiva  + FS
			sComando =  sComando + cSuma  + FS
			sComando =  sComando + cImpI  + FS
			sComando =  sComando + "0"    + FS
			sComando =  sComando + cDisc

			*!*				loHasar.Subtotal( .F. )
			*!*				lnSubtotal = Val( loHasar.Respuesta( 3 ))

			TEXT To lcCommand NoShow TextMerge Pretext 03
			Imprimiendo Item:
			-  Cantidad: <<cCant>>
			-  Texto: <<sTexto>>
			-  Precio Unitario: <<cPreU>>
			-  Iva: <<cAiva>>
			-  Impuesto Interno: <<cImpI>>
			ENDTEXT

			* Wait Window lcCommand Nowait

			*StrToFile( "Ejecutando:" + CRLF, "PrintLineItem.txt", 1 )
			*StrToFile( lcCommand + CRLF, "PrintLineItem.txt", 1 )

			loHasar.cEjecutando = lcCommand

			llOk = Enviar( sComando )

			If llOk

				*StrToFile( "Enviar Devolvio True" + CRLF, "PrintLineItem.txt", 1 )
				*!*					loHasar.Subtotal( .F. )
				*!*					llOk = ( lnSubtotal # Val( loHasar.Respuesta( 3 )) )
				*!*					lnSubtotal = Val( loHasar.Respuesta( 3 ))


				* Acumular los distintos IVA para grabarlos por separado

				i = loIvas.GetKey( "_" + Strtran( cAiva, ".", "_" ))
				If Empty( i )
					loIva = Createobject( "Empty" )
					AddProperty( loIva, "Alicuota", nAiva )
					AddProperty( loIva, "Importe", 0.00 )

					loIvas.Add( loIva, "_" + Strtran( cAiva, ".", "_" ) )

				Else
					loIva = loIvas.Item( i )

				Endif

				lnImporte = Round( nCantidad * nPrecioUnitario, 2 )

				If lIncluyeIva
					lnImporte = Round( lnImporte / ( 1 + ( nAiva / 100 )), 2 )
				Endif

				lnImporteIva 	= Round( lnImporte * nAiva / 100, 2 )
				loIva.Importe 	= loIva.Importe + lnImporteIva

			Else
				*StrToFile( "Enviar Devolvio False" + CRLF, "PrintLineItem.txt", 1 )

			Endif

		Else
			llOk = .T.

		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loIva 	= Null
		loIvas 	= Null
		loHasar = Null

	Endtry

	Return llOk

	************************************************************************************


	*  3.4.4. LastItemDiscount - Descuento/Recargo sobre último ¡tem vendido
	*
	*  Sintaxis:
	*  LastItemDiscount( sTexto,;		   && Max. 50 caracteres
	*					 nMonto,;		   && (nnnnnn.nnnn)
	*					 lIncluyeIva,;
	*					 lDiscount,;
	*					 nDecCant ) 	   && Decimales cantidad
	*
	*  Responde:
	*  a. imprimiendo una l¡nea con la leyenda DESCUENTO  o RECARGO SOBRE
	*  ULTIMA VENTA, según sea el caso, seguida de otra l¡nea con la descripci¢n del
	*  descuento o recargo, monto del mismo, al¡cuota del IVA, porcentaje de la base
	*  afectada por impuestos internos y precio neto, en el caso de comprobantes A y
	*  B, o con la descripci¢n e importe en el caso de los comprobantes C. En el caso
	*  de los recibos, el monto ingresado es guardado en memoria de trabajo. Cuando
	*  el recibo se imprime, la cantidad que figura como recibida es la suma de los
	*  montos as¡ acumulados;
	*  b. restando o sumando en memoria el valor de los bytes 56-68 al valor del último
	*  ¡tem vendido.
	*
	*  Opciones:
	*  Imputaci¢n: Byte 70:
	*  Si el valor almacenado en este byte es el caracter M, el monto se suma (recargo;
	*  si es el caracter m, el monto se resta (descuento).
	*  Calificador de monto: Byte 74:
	*  Si se llena este byte con el caracter B, se indica que el valor almacenado en el
	*  monto (bytes 56-68) no incluye el IVA. Si se lo llena con otro caracter, el monto
	*  incluye el IVA, es decir, es el precio total.
	*
	*  Este comando es rechazado si:
	*  a. No se encuentra abierto una factura o una nota de crédito; b. No hubo una venta
	*  previa. c. Los montos acumulados (en el caso de recargo) fueran a causar un
	*  desborde en la capacidad del acumulador del total.
	*
	*  Comando
	*  Longitud    Descripci¢n												Tipo
	*	   1	   U (ASCII 85)
	*	   1	   FS
	*	   50	   Hasta 50 caracteres de texto descripci¢n 				 A
	*	   1	   FS
	*	   13	   Monto (?nnnnnnnnn.nn)									 N
	*	   1	   FS
	*	   1	   Imputaci¢n												 A
	*							M: suma
	*							m: resta
	*	   1	   FS
	*	   1	   Par metro display: 0, 1 o 2								 N (Opc)
	*							   (colocar cualquiera de los tres valores;
	*							   no tiene efecto en el presente modelo)
	*	   1	   FS
	*	   1	   Calificador de monto 									 A
	*						   T: precio total; otro caracter: precio base
	*

Function LastItemDiscount
	Para sTexto,;
		nMonto,;
		lIncluyeIva,;
		lDiscount,;
		nDecPrec

	Private sComando,cMonto,cSuma,cDisc

	*!*		sTexto		  =  IfEmpty( sTexto, Space(0) )
	*!*		nMonto		  =  IfEmpty( nMonto, 0 )
	*!*		*!*		lIncluyeIva	  =  prxDefault( "lIncluyeIva", .F. )
	*!*		*!*		lDiscount	  =  prxDefault( "lDiscount", .T. )
	*!*		nDecPrec 	  =  IfEmpty( nDecPrec, 2 )

	cMonto	=  Alltrim( Str( nMonto, 10, nDecPrec ))
	cDisc	=  If( lIncluyeIva, "T", "N")
	cSuma	=  If( lDiscount, "m", "M")

	sComando =  Chr( 85 ) + FS
	sComando =  sComando + sTexto + FS
	sComando =  sComando + cMonto + FS
	sComando =  sComando + cSuma  + FS
	sComando =  sComando + "0"    + FS
	sComando =  sComando + cDisc

	Return sComando


	************************************************************************************

	*  3.4.5. GeneralDiscount - Descuento general
	*
	*  Sintaxis:
	*  GeneralDiscount( sTexto,;		  && Max. 50 caracteres
	*					nMonto,;		  && (nnnnnn.nnnn)
	*					lIncluyeIva,;
	*					lDiscount,;
	*					nDecCant )		  && Decimales cantidad
	*
	*  Responde:
	*  a.  Imprimiendo una l¡nea con la leyenda DESCUENTO  o RECARGO GENERAL,
	*  según sea el caso, seguida de otra l¡nea con la descripci¢n del descuento o
	*  recargo, precio unitario del mismo, porcentaje de la base afectada por impuestos
	*  internos y precio neto, en el caso de comprobantes A y B, o con la descripci¢n e
	*  importe en el caso de los comprobantes C. En el caso de los recibos, el monto
	*  ingresado es guardado en memoria de trabajo. Cuando el recibo se imprime, la
	*  cantidad que figura como recibida es la suma de los montos as¡ acumulados;
	*  b. restando o sumando en memoria, en forma proporcional, el valor de los bytes 56-
	*  68 a todos los items vendidos.
	*
	*  Opciones:
	*  Imputaci¢n: Byte 70:
	*  Si el valor almacenado en este byte es el caracter M, el monto se suma (recargo)
	*  a la venta; si es el caracter m, el monto se resta (descuento).
	*  Calificador de monto: Byte 74:
	*  Si se llena este byte con el caracter B, se indica que el valor almacenado en el
	*  monto (bytes 56-68) no incluye el IVA. Si se lo llena con otro caracter, el monto
	*  incluye el IVA, es decir, es el precio total.
	*
	*  Una vez emitido este comando, no puede proseguirse con la venta, quedando
	*  solamente habilitados los comandos IVAPerceptions, OtherPerceptions,
	*  TotalTender y CloseFiscalReceipt.
	*
	*  Este comando es rechazado si:
	*  a. No se encuentra abierto una factura, nota de débito, recibo o nota de crédito; b.
	*  No hubo una venta previa. c. Los montos acumulados (en el caso de recargo)
	*  fueran a causar un desborde en la capacidad del acumulador del total.
	*
	*  Comando
	*  Longitud    Descripci¢n								   Tipo
	*	   1	   T (ASCII 84)
	*	   1	   FS
	*	   50	   Hasta 50 caracteres de texto descripci¢n    A
	*	   1	   FS
	*	   13	   Monto (?nnnnnnnnn.nn)					   N
	*	   1	   FS
	*	   1	   Imputaci¢n								   A
	*							  M: suma
	*							  m: resta
	*	   1	   FS
	*	   1	   Par metro display: 0, 1 o 2				   N (Opc)
	*							   (colocar cualquiera de los tres valores)
	*	   1	   FS
	*	   1	   T: precio total; otro car cter: precio base A
	*

Function GeneralDiscount
	Para sTexto,;
		nMonto,;
		lIncluyeIva,;
		lDiscount,;
		nDecPrec

	Private sComando,cMonto,cSuma,cDisc
	Local loHasar As "Hasar.Fiscal.1"

	Try

		loHasar = NewHasar()

		loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
		loHasar.cEjecutando = ""

		*!*			sTexto	=  IfEmpty( sTexto, Space(0) )
		*!*			nMonto	=  IfEmpty( nMonto, 0 )

		*!*			nDecPrec  =  IfEmpty( nDecPrec, 2 )

		cMonto	=  Alltrim( Str( nMonto, 10, nDecPrec ))
		cDisc	=  Iif( lIncluyeIva, "T", "N")

		Do Case
			Case loHasar.nModelo = MODELO_615
				cSuma    =  If( lDiscount, "m", "M")

			Case Inlist( loHasar.nModelo, MODELO_715, MODELO_715_201, MODELO_715_302, MODELO_715_403, MODELO_P441 )
				***cSuma	  =  If( lDiscount, "M", "m")
				cSuma    =  If( lDiscount, "m", "M")

			Otherwise
				cSuma    =  If( lDiscount, "m", "M")

		Endcase

		sComando =  Chr( 84 ) + FS
		sComando =  sComando + sTexto + FS
		sComando =  sComando + cMonto + FS
		sComando =  sComando + cSuma  + FS
		sComando =  sComando + "0"    + FS
		sComando =  sComando + cDisc

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Descuento General: [ <<sTexto>>: <<cMonto>> ]
		ENDTEXT

		loHasar.cEjecutando = lcCommand


	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null
	Endtry

	Return sComando


	************************************************************************************


	*  3.4.6. ReturnRecharge - Devoluci¢n de envases, Bonificaciones y Recargos
	*
	*  POR AHORA USAR GeneralDiscount()
	*
	*
	*  Responde:
	*  a. imprimiendo una l¡nea con la leyenda BONIFICACION, RECARGO o
	*  DEVOLUCION DE ENVASES, según sea el caso, seguida de otra l¡nea con la
	*  descripci¢n de la bonificaci¢n, recargo o envases devueltos, al¡cuota de IVA y
	*  precio neto, en el caso de comprobantes A y B, o con la descripci¢n e importe en
	*  el caso de los comprobantes C. En el caso de los recibos, el monto ingresado es
	*  guardado en memoria de trabajo. Cuando el recibo se imprime, la cantidad que
	*  figura como recibida es la suma de los montos as¡ acumulados;
	*  b. restando o sumando en memoria el monto al valor ya vendido con esa misma
	*  al¡cuota.
	*
	*  Opciones
	*  Imputaci¢n: Byte 76:
	*  Si el valor almacenado en este byte es el caracter M, el monto (bytes 56-74) se
	*  suma (recargo); si es el caracter m, el monto se resta (descuento).
	*  Impuestos internos: Bytes 78-95 (ver Apéndice 5.2)
	*  Existen dos formas diferentes de ingresar el valor de los impuestos internos:
	*  como coeficiente o como valor directo. El programador debe optar por una de
	*  ellas. A su vez, cada forma se divide en dos tipos de impuestos: fijos y
	*  porcentuales. Los impuestos internos fijos no son afectados por recargos o
	*  descuentos posteriores. En cambio, los impuestos internos porcentuales s¡ son
	*  afectados por recargos o descuentos posteriores.
	*  a. Coeficiente:
	*  El valor almacenado en estos bytes debe estar entre tener 0 y 1; si el valor es
	*  cero, no se lo tiene en cuenta. Llamando k al coeficiente de impuestos
	*  internos, es k = 1 / (1 + Ii), donde Ii indica el monto del impuesto interno como
	*  fracci¢n del precio base, expresado en forma decimal.
	*  Si el valor del coeficiente k almacenado es diferente de cero y va precedido
	*  por el signo +, el monto del impuesto interno es fijo.
	*  Si el valor del coeficiente k almacenado es diferente de cero y no va
	*  precedido por un signo, el monto del impuesto interno es porcentual.
	*  Si el valor almacenado es cero, no existen impuestos internos.
	*  Si se realiza un descuento o recargo general (ver punto anterior) el valor de
	*  b. Valores directos:
	*  b.1. El monto directo del impuesto interno por unidad vendida. En este caso,
	*  el monto debe ir precedido por el signo $ y se considera que el impuesto
	*  interno es fijo.
	*  b.2. El valor porcentual (considerado sobre el precio neto unitario) del
	*  impuesto interno. En este caso, el valor debe ir precedido por el signo %,
	*  debe expresarse como porcentaje (por ejemplo, 12,34% debe ingresarse
	*  como %12.34) y se considera que el impuesto interno es porcentual.
	*  En todos los casos, si el valor almacenado es cero, no existen impuestos
	*  internos.
	*  Si se realiza un descuento o recargo general (ver Imputaci¢n m s arriba) el valor
	*  de este campo es ignorado y se considera que est  en cero.
	*  Calificador de monto: Byte 92:
	*  Si se llena este byte con el caracter T, se indica que el valor almacenado en el
	*  monto (bytes 56-68) incluye IVA e Impuestos internos, es decir, es el precio total.
	*  Si se lo llena con otro caracter, el monto no incluye IVA e Impuestos internos, es
	*  decir, es el precio base.
	*
	*  Calificador de operaci¢n: Byte 94:
	*  Si se llena este byte con el valor B, el controlador interpreta que se trata de un
	*  recargo o descuento, según sea el monto positivo o negativo. En caso de
	*  tratarse de un recargo, la l¡nea predeterminada lleva el texto "RECARGO" ; en
	*  caso de tratarse de un descuento, lleva el texto "BONIFICACION".
	*  Si se llena este byte con otro caracter, el controlador interpreta que se trata de
	*  una devoluci¢n de envases. La l¡nea predeterminada lleva el texto
	*  "DEVOLUCION DE ENVASES" y el comando s¢lo es aceptado si el monto es
	*  negativo.
	*  Nota: Una vez ejecutado este comando, el controlador no permite seguir con las
	*  ventas, admitiendo solamente los comandos ReturnRecharge, GeneralDiscount,
	*  Perceptions, ChargeNonRegisteredTax, TotalTender y CloseFiscalReceipt.
	*
	*  Este comando es rechazado si:
	*  a. No se encuentra abierta una factura, nota de débito, recibo o nota de crédito; b.
	*  El subtotal del documento es cero. c. El monto del acumulador de la al¡cuota del
	*  IVA va a arrojar un resultado negativo. d. El monto del acumulador de los
	*  impuestos internos fijos o porcentuales va a arrojar un resultado negativo. e. El
	*  monto de una devoluci¢n de envases es positivo o cero.
	*
	*  Comando
	*
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   m (ASCII 109)
	*	   1	   FS
	*	   50	   Hasta 50 caracteres de texto descripci¢n 					   A
	*	   1	   FS
	*	   13	   Monto ([?]nnnnnnnnn.nn)											   N
	*	   1	   FS
	*	   5	   Porcentaje IVA (nn.nn)												   N
	*	   1	   FS
	*	   1	   Imputaci¢n																   A
	*  M: suma
	*  m: resta
	*	   1	   FS
	*	   19	   Impuestos internos													   N
	*  Coeficiente k:
	*  +0.nnnnnnnn: impuestos internos fijos
	*  0.nnnnnnnn: impuestos internos porcentuales
	*  Valores directos:
	*  $nnnnnnnnn.nnnnnnnn: impuestos internos fijos
	*  %nnnnnnnnn.nnnnnnnn: imp. internos porcentuales
	*	   1	   FS
	*	   1	   Par metro display: 0, 1 o 2										   N (Opc)
	*	   (colocar cualquiera de los tres valores;
	*	   no tiene efecto en el presente modelo)
	*	   1	   FS
	*	   1	   T: precio total; otro car cter: precio base					   A
	*	   1	   FS
	*	   1	   Calificador de operaci¢n 											   A
	*  B: Descuento/recargo
	*  Otro caracter: devoluci¢n de envases
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   m (ASCII 109)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   1	   Status fiscal																   H
	*
	*
	*
	*  ************************************************************************************
	*
	*
	*  3.4.7. ChargeNonRegisteredTax - Recargo IVA a Responsable no Inscripto
	*
	*  NO SE USA EN COMPROBANTES A CONSUMIDOR FINAL
	*
	*  Responde almacenando un monto que luego ser  adicionado a la factura o nota de
	*  crédito A en reemplazo del monto resultante de aplicar el porcentaje
	*  correspondiente a IVA Responsable no Inscripto ingresado mediante los comandos
	*  de configuraci¢n. En el caso de los recibos, el monto resultante es guardado en
	*  memoria de trabajo. Cuando el recibo se imprime, la cantidad que figura como
	*  recibida es la suma de los montos as¡ acumulados.
	*  Una vez emitido este comando no puede volver a repet¡rselo, quedando
	*  disponibles s¢lo los comandos Perceptions, TotalTender y CloseFiscalReceipt.
	*
	*  Este comando es rechazado si:
	*  a. No se encuentra abierta una factura, nota de débito, recibo o nota de crédito tipo
	*  A; b. La situaci¢n frente al IVA del comprador no es Responsable no Inscripto. c.
	*  No hubo una venta previa dentro del comprobante. d. Los montos acumulados
	*  fueran a causar un desborde en la capacidad del acumulador del total del
	*  comprobante.
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1			   a (ASCII 97)
	*	   1			   FS
	*	   10			   Monto ([+]nnnnnn.nn) 											   N
	*
	*
	*
	*	   Respuesta
	*
	*	   Longitud 	   Descripci¢n															   Tipo
	*	   1			   a (ASCII 97)
	*	   1			   FS
	*	   4			   Status de la impresora											   H
	*	   1			   FS
	*	   4			   Status Fiscal															   H
	*
	*************************************************************************************
	*
	*  3.4.8. Perceptions - Percepciones
	*
	*  NO SE USA EN COMPROBANTES A CONSUMIDOR FINAL
	*
	*  Responde:
	*  a. Almacenando en memoria (para imprimir luego al final del comprobante) los
	*  datos correspondientes a una percepci¢n: descripci¢n de la percepci¢n, al¡cuota
	*  del IVA correspondiente a los items sobre los que se aplicar  la percepci¢n, y
	*  monto a aplicar. En el caso de los recibos, el monto ingresado es guardado en
	*  memoria de trabajo. Cuando el recibo se imprime, la cantidad que figura como
	*  recibida es la suma de los montos as¡ acumulados; b. Sumando en memoria el
	*  monto resultante en un acumulador especial.
	*
	*  Opciones
	*  a. Si se llenan los bytes 5-9 con un valor numérico, éste representa al IVA
	*  correspondiente a los items a los que se aplica el monto de los bytes 32-43.
	*  b. Si  se llenan los bytes 5-9 con asteriscos, el monto de los bytes 32-43 se aplica
	*  sobre la totalidad de los items vendidos y se reparte proporcionalmente entre los
	*  items existentes en el comprobante. Una vez emitido el comando en estas
	*  condiciones, no puede volver a repet¡rselo, aunque s¡ puede procederse a la
	*  inversa, es decir, emitir primero el comando con un valor numérico en los bytes
	*  5-9 y a continuaci¢n emitirlo con asteriscos.
	*  Los documentos A admiten los dos tipos de percepciones; los documentos B s¢lo
	*  admiten las percepciones generales. Los documentos C no admiten ningún tipo de
	*  percepci¢n.
	*
	*  Este comando es rechazado si:
	*  a. No se encuentra abierta una factura, nota de débito, recibo o nota de crédito tipo
	*  A o B; b. No hubo una venta previa dentro del comprobante con la misma al¡cuota
	*  de IVA que la percepci¢n. c. Se ha intentado una percepci¢n referida a una al¡cuota
	*  de IVA en un documento B. d. El total del IVA y/o impuestos internos es negativo.
	*  d. Los montos acumulados fueran a causar un desborde en la capacidad del
	*  acumulador del total.
	*
	*  Una vez emitido este comando, no puede proseguirse con la venta, quedando
	*  solamente habilitados los comandos, ChargeNonRegisteredTax, TotalTender y
	*  CloseFiscalReceipt y la repetici¢n del comando Perceptions.
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1			   ï (ASCII 96)
	*	   1			   FS
	*	   5			   Al¡cuota de IVA (nn.nn / **.**)									   A
	*	   1			   FS
	*	   20			   Hasta 20 caracteres de texto descripci¢n 				   A
	*	   1			   FS
	*	   10			   Monto ([+]nnnnnn.nn) 											   N
	*
	*  Respuesta
	*
	*	   Longitud 	   Descripci¢n															   Tipo
	*	   1			   ï (ASCII 96)
	*	   1			   FS
	*	   4			   Status de la impresora											   H
	*	   1			   FS
	*	   4			   Status Fiscal															   H
	*
	*************************************************************************************
	*
	*  3.4.9. Subtotal
	*
	*  Sintaxis:
	*  Subtotal( nItems,;
	*			 nVentas,;
	*			 nIva,;
	*			 nPago,;
	*			 nIvaNoInscripto,;
	*			 lImprime,;
	*			 )
	*
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde calculando el subtotal del comprobante	abierto y envi ndolo a través de
	*  la l¡nea serie.
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1			   C (ASCII 67)
	*	   1			   FS
	*	   1			   Impresi¢n																   A
	*						   P: imprimir texto y monto; otro: no imprimir.
	*	   1			   FS
	*	   1			   Reservado (llenar con un caracter cualquiera)		   A
	*	   1			   FS
	*	   1			   Par metro display (s¢lo operativo en modelo
	*					   SMH/P-615F; en el resto de los modelos colocar
	*					   cualquiera de los tres valores)
	*						   0: No modifica
	*						   1: Escribe display
	*						   2: Aumenta subcampo repeticiones 					   N
	*
	*
	*  Respuesta
	*
	*	   Longitud 	   Descripci¢n															   Tipo
	*	   1			   C (ASCII 67)
	*	   1			   FS
	*	   4			   Status de la impresora											   H
	*	   1			   FS
	*	   4			   Status Fiscal															   H
	*	   1			   FS
	*	   6			   Cantidad de items vendidos									   N
	*	   1			   FS
	*	   13			   Monto ventas 														   N
	*	   1			   FS
	*	   13			   Monto IVA																   N
	*	   1			   FS
	*	   13			   Monto pagado (solo tras un pago parcial) 				   N
	*	   1			   FS
	*	   13			   IVA correspondiente a responsable no inscripto		   N
	*

Function Subtotal
	Lparameters  nItems, nVentas, nIva, nPago, nIvaNoInscripto, lImprime

	Local loHasar As "Hasar.Fiscal.1"
	Local llOk As Boolean
	Local lcErrorMsg as String 

	Private sComando, Result, OffsetSep, Origen, nI, Resp
	Try


		Result	=  ""
		llOk 	= .F.
		loHasar = NewHasar()
		loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
		loHasar.cEjecutando = "Subtotal"

		If lHasar

			If lImprime
				sComando =  Chr( 67 ) + FS + "P" + FS + "?" + FS + "0"

			Else
				sComando =  Chr( 67 ) + FS + "N" + FS + "?" + FS + "0"

			Endif

			llOk = Enviar( sComando )

			If llOk
				nItems 			= Val( loHasar.Respuesta( 3 ))
				nVentas 		= Val( loHasar.Respuesta( 4 ))
				nIva 			= Val( loHasar.Respuesta( 5 ))
				nPago 			= Val( loHasar.Respuesta( 6 ))
				nIvaNoInscripto = Val( loHasar.Respuesta( 7 ))

				loHasar.oComprobante.nItems 			= nItems
				loHasar.oComprobante.nVentas 			= nVentas
				loHasar.oComprobante.nIva 				= nIva
				loHasar.oComprobante.nPago 				= nPago
				loHasar.oComprobante.nIvaNoInscripto 	= nIvaNoInscripto
				
				If Empty( nVentas )
					* RA 18/07/2018(15:37:33)
					* Debugging
					
					lcErrorMsg = "" 
					
					loHasar.cRemark = "Subtotal Devuelve CERO"
					
			
					lcErrorMsg = lcErrorMsg + Replicate( '-', 40 ) + CRLF
					lcErrorMsg = lcErrorMsg + Transform( Datetime() ) + CRLF
					lcErrorMsg = lcErrorMsg + "Modelo: " + Alltrim( Transform( loHasar.cModelo )) + " ( " + Transform( loHasar.nModelo ) + " )" + CRLF
					lcErrorMsg = lcErrorMsg + "Punto de Venta: " + Transform( loHasar.nPuntoDeVenta ) + CRLF
					lcErrorMsg = lcErrorMsg + "Comando Ejecutado: " + Transform( sComando ) + CRLF
					lcErrorMsg = lcErrorMsg + "Trace: " + loHasar.cTraceLogin + CRLF
					lcErrorMsg = lcErrorMsg + "Remark: " + loHasar.cRemark + CRLF
					lcErrorMsg = lcErrorMsg + "Ejecutando: " + loHasar.cEjecutando + CRLF

					lTraceLogin = .T.

					lcErrorMsg = lcErrorMsg + VolcarDatos( loHasar.oCliente )
					lcErrorMsg = lcErrorMsg + VolcarDatos( loHasar.oComprobante )

					Strtofile( lcErrorMsg, "ErrorHasar.Txt", 1 )

					* Intentar grabar el ErrorLog.txt en el servidor, para poder acceder más facilmenmte
					If Vartype( DRVA ) = "C"
						Strtofile( lcErrorMsg, Addbs(Alltrim(DRVA))+"ErrorHasar.Txt", 1 )
					Endif



				EndIf

			Endif

		Endif


	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null

	Endtry

	Return Result



	*!*	Function Subtotal
	*!*		Para nItems, nVentas, nIva, nPago, nIvaNoInscripto, lImprime

	*!*		Private sComando, Result, OffsetSep, Origen, nI, Resp

	*!*		Result		   =  ""

	*!*		nItems		   =  prxDefault( "nItems", 0 )
	*!*		nVentas 	   =  prxDefault( "nVentas", 0 )
	*!*		nIva		   =  prxDefault( "nIva", 0 )
	*!*		nPago		   =  prxDefault( "nPago", 0 )
	*!*		nIvaNoInscripto=  prxDefault( "nIvaNoInscripto", 0 )
	*!*		lImprime	   =  prxDefault( "lImprime", .F. )

	*!*		If lImprime
	*!*			sComando =  Chr( 67 ) + FS + "P" + FS + "?" + FS + "0"
	*!*		Else
	*!*			sComando =  Chr( 67 ) + FS + "N" + FS + "?" + FS + "0"
	*!*		Endif


	*!*		Enviar( sComando )


	*!*		Origen = 0
	*!*		Resp   = Result
	*!*		For nI = 1 To 2
	*!*			Resp 	   = Substr( Resp, Origen )
	*!*			OffsetSep   = At ( FS, Resp )
	*!*			Origen	   = OffsetSep + 1
	*!*		Next

	*!*		For nI = 1 To 5
	*!*			Resp 	   = Substr( Resp, Origen )
	*!*			OffsetSep   = At ( FS, Resp )
	*!*			Origen	   = OffsetSep + 1


	*!*			Do Case
	*!*				Case nI = 1
	*!*					nItems		 =	Val( Resp )

	*!*					CasenI = 2
	*!*					nVentas		 =	Val( Resp )

	*!*				Case nI = 3
	*!*					nIva			 =	Val( Resp )

	*!*				Case nI = 4
	*!*					nPago 		 =	Val( Resp )

	*!*				Case nI = 5
	*!*					nIvaNoInscripto=	Val( Resp )

	*!*			Endcase

	*!*		Next

	*!*		Return Result




	************************************************************************************
	*
	*  3.4.10. ReceiptText - Texto de l¡neas de recibos
	*
	*  NO SE USA EN COMPROBANTES A CONSUMIDOR FINAL
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde almacenando en memoria una l¡nea con el texto ingresado con las
	*  siguientes caracter¡sticas:
	*  a. El comando puede ser usado tanto para Recibos A / B / C como para Recibos X.
	*  b. El texto ingresado corresponde al  rea del recibo que indica el bien o servicio
	*  recibido.
	*  c. El espacio destinado a este concepto es de nueve l¡neas, por lo que el comando
	*  podr  repetirse hasta nueve veces seguidas, debiendo ser seguido por el
	*  comando de cierre (o de un pedido de informes de IVA y percepciones).
	*  d. El texto ingresado luego ser  impreso mediante el comando de cierre
	*  CloseFiscalReceipt o CloseNFHD (según se trate de un Recibo A / B / C o de
	*  un Recibo X), precedido por la leyenda "En concepto de".,
	*  e. Este comando debe emitirse al menos una vez. En caso contrario, no se podr 
	*  cerrar el recibo.
	*
	*  Este comando es rechazado si no se encuentra abierto un comprobante fiscal
	*  Recibo o un documento no fiscal homologado Recibo de uso interno (Recibo X).
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   — (ASCII 151)
	*	   1	   FS
	*	   106	   Texto de hasta 106 caracteres									   A
	*
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   — (ASCII 151)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   1	   Status fiscal																   H
	*
	*
	***********************************************************************************
	*
	*  3.4.11. TotalTender - Total
	*
	*  Sintaxis:
	*	  TotalTender( sTexto ,;
	*				   nMonto )
	*
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra
	*  Responde calculando el total, registrando el monto pagado y calculando el vuelto.
	*  Este comando no es aceptado si el comprobante abierto es un recibo.
	*  Este comando s¢lo puede emitirse hasta un m ximo de cuatro veces seguidas.
	*
	*  Opciones
	*  Cancelaci¢n: Byte número 70: C
	*  El comando cancela el comprobante fiscal abierto. Esta opci¢n se incluye por
	*  compatibilidad con modelos anteriores. Se recomienda no utilizarla, usando en
	*  cambio el comando Cancel.
	*  Pago: Byte número 70: T
	*  El comando calcula el saldo a partir del monto pagado (bytes 56-68). Una vez
	*  saldado el monto total, s¢lo puede cerrarse el comprobante o programarse la
	*  cola del mismo.
	*  Pagos parciales:
	*  Si el monto almacenado en los bytes 56-68 es menor que el total del
	*  comprobante, el comando puede volver a emitirse hasta tres veces m s. En el
	*  estado de pago parcial, el comprobante no puede ser cancelado.
	*  Cancelaci¢n de pagos parciales:
	*  Si el monto ingresado en los bytes 56-68 es negativo, dicho valor se usa para
	*  cancelar pagos parciales.
	*
	*  Este comando es rechazado si:
	*  a. No se encuentra abierto una factura, nota de débito o nota de crédito; b. Si va a
	*  causar un desborde en los acumuladores; c. Si el total es cero; d. Si el total del
	*  monto y/o IVA y/o impuestos internos es negativo. e. Si se intenta cancelar el
	*  comprobante luego de haber realizado un pago parcial o total.
	*
	*  (Comando en la p gina siguiente)
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1			   D (ASCII 68)
	*	   1			   FS
	*	   30			   Texto de hasta 30 caracteres 						   .		   A
	*	   1			   FS
	*	   13			   Monto pagado (ñnnnnnnnnn.nn) 							   N
	*	   1			   FS
	*	   1			   Cancelaci¢n/vuelto												   A
	*						   C: cancela; T: vuelto
	*	   1			   FS
	*	   1			   Par metro display (s¢lo operativo en modelo
	*					   SMH/P-615F; en el resto de los modelos colocar
	*					   cualquiera de los tres valores)
	*						   0: No modifica
	*						   1: Escribe display
	*						   2: Aumenta subcampo repeticiones 					   N
	*
	*
	*  Respuesta
	*
	*	   Longitud 	   Descripci¢n															   Tipo
	*	   1			   D (ASCII 68)
	*	   1			   FS
	*	   4			   Status de la impresora											   H
	*	   1			   FS
	*	   4			   Status Fiscal															   H
	*	   1			   FS
	*	   13			   Vuelto o Monto faltante (?nnnnnnnnn.nn)				   N
	*								   (+: monto faltante; -: vuelto)
	*
Function TotalTender
	Para sTexto,;
		nMonto

	Private sComando,Cmont,nLen
	Local loHasar As "Hasar.Fiscal.1"

	Try




		loHasar = NewHasar()
		loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
		loHasar.cEjecutando = "Total"

		Cmont	=  Alltrim( Str( Abs( nMonto ),  15, 2 ))


		Do Case
			Case loHasar.nModelo = MODELO_615
				nLen = 24

			Case Inlist( loHasar.nModelo, MODELO_715, MODELO_715_201, MODELO_715_302, MODELO_715_403, MODELO_P441 )
				nLen = 24

			Otherwise
				nLen = 50

		Endcase



		sTexto	=  Alltrim( Substr( sTexto , 1, nLen ) )

		sComando =  Chr( 68 ) + FS
		sComando =  sComando + sTexto + FS
		sComando =  sComando + Cmont + FS + "T" + FS + "1"

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null
	Endtry

	Return sComando

	*********************************************************************************
	*
	*
	*  3.4.12. CloseFiscalReceipt - Cerrar comprobante fiscal
	*
	*  Sintaxis:
	*	  CloseFiscalReceipt()
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Si aún no se ha emitido el comando Total/Tender responde:
	*  a. En el caso de facturas, notas de débito y notas de crédito: calculando el total e
	*  imprimiéndolo, ingresando autom ticamente como monto pagado el total de lo
	*  vendido (esta operaciones es semejante a la que realiza el comando
	*  TotalTender en las facturas y notas de débito). Adem s, imprimiendo (según el
	*  tipo de documento abierto algunos de estos campos no aparecen) los montos
	*  correspondientes a subtotales de ventas discriminados por al¡cuotas de IVA, las
	*  al¡cuotas de IVA, los montos correspondientes a éstas, las percepciones, los
	*  impuestos internos y el monto total del documento. Finalmente, de haberse
	*  ingresado pagos mediante el comando TotalTender (s¢lo en facturas y notas de
	*  débito), imprimiendo estos, precedidos por una l¡nea con la leyenda
	*  "Recib¡(mos):"
	*  b. En el caso de recibos fiscales: calculando el total de lo recibido e imprimiendo
	*  dicho monto, precedido por una l¡nea con la leyenda "RECIBI(MOS) LA SUMA
	*  DE:" a continuaci¢n una l¡nea con la leyenda "EN CONCEPTO DE:" seguida por
	*  las l¡neas de texto del recibo. Adem s, imprimiendo (según el tipo de recibo
	*  abierto algunos de estos campos no aparecen) los montos correspondientes a
	*  subtotales de ventas discriminados por al¡cuotas de IVA, las al¡cuotas de IVA,
	*  los montos correspondientes a éstas, las percepciones y los impuestos internos.
	*  Finalmente, imprimiendo al final de la p gina dos l¡neas con las leyendas "Firma"
	*  y "Aclaraci¢n".
	*  c. Cerrando el comprobante;
	*  d. Acumulando los montos en la memoria de trabajo;
	*  e. Imprimiendo el trailer del comprobante;
	*  f.  En el caso de facturas, notas de débito y recibos: imprimiendo el logotipo fiscal y
	*  el número de registro del controlador fiscal y la fecha de vencimiento. Adem s, si
	*  el documento es del tipo A, imprimiendo el número de CAI.
	*  g. En el caso de notas de crédito: imprimiendo el número de registro del controlador
	*  fiscal y la númeraci¢n correspondiente al DNFH.
	*  h. Eyéctando la hoja de la impresora (o pasando a la hoja siguiente en caso de
	*  tratarse de formulario continuo).
	*
	*  Si ya se ha emitido el comando Total/Tender, responde:
	*  a. Cerrando el comprobante;
	*  b. Acumulando los montos en la memoria de trabajo;
	*  c. Imprimiendo el trailer del comprobante;
	*  d. En el caso de facturas, notas de débito y recibos: imprimiendo el logotipo fiscal y
	*  el número de registro del controlador fiscal y la fecha de vencimiento. Adem s, si
	*  el documento es del tipo A, imprimiendo el número de CAI.
	*  e. En el caso de notas de crédito: imprimiendo el número de registro del controlador
	*  fiscal y la númeraci¢n correspondiente al DNFH.
	*  f. Eyéctando la hoja de la impresora (o pasando a la hoja siguiente en caso de
	*  tratarse de formulario continuo).
	*
	*  Este comando es rechazado si:
	*  a. No se encuentra abierto un comprobante fiscal; b. Si va a causar un desborde en
	*  los acumuladores. c. Si el total del monto vendido es cero; d. Si el total del monto
	*  y/o IVA y/o impuestos internos es negativo.
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*  1			   E (ASCII 69)
	*
	*
	*  Respuesta
	*
	*	   Longitud 	   Descripci¢n															   Tipo
	*	   1			   E (ASCII 69)
	*	   1			   FS
	*	   4			   Status de la impresora											   H
	*	   1			   FS
	*	   4			   Status Fiscal															   H
	*	   1			   FS
	*	   8			   Número del comprobante fiscal recién emitido 		   N

Function CloseFiscalReceipt
	Priv sComando
	Local loHasar As "Hasar.Fiscal.1"

	Try

		loHasar = NewHasar()
		loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
		loHasar.cEjecutando = "Cerrar comprobante fiscal"

		If !lNCR
			*Wait Window "Cerrando " + loHasar.DescripcionDocumentoEnCurso Nowait
		Endif
		sComando =  Chr( 69 )

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return sComando


	*  3.5. Comandos de comprobante no fiscal
	*
	*  3.5.1. OpenNonFiscalReceipt - Abrir comprobante no fiscal
	*
	*  Nota: Este comando es similar a OpenNonFiscalSlip (se incluyen ambos por
	*  compatibilidad con otros modelos.)
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde:
	*  a.	Abriendo un comprobante no fiscal; b. Imprimiendo el encabezamiento que
	*  incluye la leyenda "NO FISCAL".
	*  Este comando es rechazado si ya se encuentra abierto un comprobante fiscal o no
	*  fiscal.
	*
	*  Comando
	*  Longitud	Descripci¢n																	Tipo
	*  	1				H (ASCII 72)
	*
	*
	*  Respuesta
	*
	*  	Longitud 	Descripci¢n																Tipo
	*  	1				H (ASCII 72)
	*  	1				FS
	*  	4				Status de la impresora												H
	*  	1				FS
	*  	4				Status Fiscal																H
	*


Function OpenNonFiscalReceipt
	Local sComando
	Local llOk As Boolean
	Local loHasar As "Hasar.Fiscal.1"

	Try

		loHasar = NewHasar()
		loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
		loHasar.cEjecutando = "Abrir comprobante no fiscal"

		llOk = .F.
		sComando =  Chr(72)

		llOk = Enviar( sComando )

		If llOk
			If Upper( loHasar.DescripcionEstadoControlador ) = Upper( "No hay ningún comprobante abierto" )
				llOk = .F.
				Stop( "No Se Ha Podido Abrir El Comprobante", "Fallo al abrir el comprobante" )

			Else
				If !lNCR
					Wait Window "Se Ha Abierto El Siguiente Comprobante: " + loHasar.DescripcionDocumentoEnCurso Nowait
				Endif

			Endif

		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null

	Endtry

	Return llOk


	*
	*  3.5.2. OpenNonFiscalSlip - Abrir comprobante no fiscal en impresora slip
	*
	*  Nota: Este comando es similar a OpenNonFiscalReceipt (se incluyen ambos por
	*  compatibilidad con otros modelos.)
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde:
	*  a.	Abriendo un comprobante no fiscal; b. Imprimiendo el encabezamiento que
	*  incluye la leyenda "NO FISCAL".
	*  Este comando es rechazado si ya se encuentra abierto un comprobante fiscal o no
	*  fiscal.
	*
	*  Comando
	*  Longitud	Descripci¢n																	Tipo
	*  	1				G (ASCII 71)
	*
	*
	*
	*  	Respuesta
	*
	*	   Longitud 	   Descripci¢n															   Tipo
	*	   1			   G (ASCII 71)
	*	   1			   FS
	*	   4			   Status de la impresora											   H
	*	   1			   FS
	*	   4			   Status Fiscal															   H
	*
	*
	*
	*
	*  3.5.3. PrintNonFiscalText - Imprimir texto no fiscal
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra
	*  Responde imprimiendo un texto con una longitud m xima de 120 caracteres.
	*  Este comando es rechazado si no se encuentra abierto un comprobante no fiscal.
	*  El comando se puede repetir cuantas veces se desee, pero cada cuatro l¡neas
	*  se intercalar  autom ticamente la leyenda "NO FISCAL".
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   I (ASCII 73)
	*	   1	   FS
	*	   120	   Hasta 120 caracteres de texto									   A
	*	   1	   FS
	*	   1	   Par metro display: 0, 1 o 2										   N (Opc)
	*	   (colocar cualquiera de los tres valores;
	*	   no tiene efecto en el presente modelo)
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   I (ASCII 73)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H
	*
Function PrintNonFiscalText
	Parameters sTexto

	Private sComando

	Local llOk As Boolean
	Local loHasar As "Hasar.Fiscal.1"

	Try

		llOk = .T.


		If lHasar

			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"

			If Vartype( sTexto ) # "C"
				sTexto = "."

			Else
				sTexto = Substr( sTexto, 1, 40 )

			Endif

			sComando =  Chr( 73 ) + FS
			sComando =  sComando + sTexto + FS + '0'

			TEXT To lcCommand NoShow TextMerge Pretext 03
			Imprimir texto no fiscal:
			-  Texto: <<sTexto>>
			ENDTEXT

			loHasar.cEjecutando = lcCommand

			llOk = Enviar( sComando )

		Endif


	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		llOk = .F.
		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return llOk


	*
	*  3.5.4. CloseNonFiscalReceipt - Cerrar comprobante no fiscal
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra
	*  Responde:
	*  a. Cerrando el comprobante no fiscal; b. Imprimiendo el trailer del comprobante
	*  (incluyendo la leyenda "NO FISCAL" cada 4 l¡neas). c. Ey‚ctando la hoja de la
	*  impresora (o pasando a la hoja siguiente en caso de tratarse de formulario
	*  continuo).
	*  Este comando es rechazado si no se encuentra abierto un comprobante no fiscal.
	*  Cambia el estado del controlador fiscal.
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   J (ASCII 74)
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   J (ASCII 74)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H
	*
Function CloseNonFiscalReceipt
	Priv sComando
	Local loHasar As "Hasar.Fiscal.1"

	Try

		loHasar = NewHasar()
		loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
		loHasar.cEjecutando = "Cerrar comprobante no fiscal"

		If !lNCR
			*Wait Window "Cerrando " + loHasar.DescripcionDocumentoEnCurso Nowait
		Endif

		sComando =  Chr( 74 )

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return sComando


	************************************************************************************

	*  3.6. Comandos de documentos no fiscales homologados
	*
	*  3.6.1. OpenDNFH - Abrir documento no fiscal homologado
	*
	*  Sintaxis:
	*	  OpenDNFH( cTipo )
	*	   cTipo = R: nota de crédito A
	*			   S: nota de crédito B o C
	*			   r: Remito
	*			   s: Orden de salida
	*			   t: Resumen de cuenta
	*			   U: Cargo a la habitaci¢n
	*			   u: Cotizaci¢n
	*			   x: Recibo X
	*
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde abriendo un documento no fiscal homologado e imprimiendo el
	*  encabezamiento, incluyendo las leyendas referentes a los documentos no fiscales
	*  homologados.
	*
	*  Opciones:
	*  Tipo de documento: Byte 5
	*  En este byte se declara el tipo de documento que se desea abrir: Nota de crédito
	*  A (R), Nota de crédito B/C (S), Remito (r), Orden de salida (s), Resumen de
	*  cuenta (t), Cargo a la habitaci¢n (U), Cotizaci¢n (u) o Recibo X de uso inteno (x).
	*  Identificaci¢n del documento: Bytes 9-28
	*  Si el documento a abrir es una Orden de salida, un Resumen de cuenta, una
	*  Cotizaci¢n o un Recibo X, este campo debe ser llenado obligatoriamente con un
	*  texto de hasta 20 caracteres que se imprime en el encabezamiento.
	*  Si el documento a  abrir es una Nota de crédito o un Remito, el controlador
	*  asigna autom ticamente el número identificatorio.
	*
	*  Este comando es rechazado:
	*  a. si ya se encuentra abierto otro documento;
	*  b. si se intenta abrir una Orden de salida, un Resumen de cuenta, una Cotizaci¢n o
	*  un Recibo X y no se ha llenado el campo correspondiente a identificaci¢n (bytes
	*  9-28).
	*
	*  Comando
	*
	*  Longitud    Descripci¢n										Tipo
	*	   1	   € (ASCII 128)
	*      1       FS
	*	   1	   Tipo de documento								A
	*						   R: nota de crédito A
	*						   S: nota de crédito B o C
	*						   r: Remito
	*						   s: Orden de salida
	*						   t: Resumen de cuenta
	*						   U: Cargo a la habitaci¢n
	*						   u: Cotizaci¢n
	*						   x: Recibo X
	*	   1	   FS
	*	   1	   T ¢ S (valor fijo)								A (Opc)
	*	   1	   FS
	*	   10	   Identificaci¢n o número del documento			A (Opc)
	*					   (Campo obligatorio para Orden de salida,
	*						Resumen de cuenta, Cotizaci¢n y Recibo X)
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   € (ASCII 128)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H


Function OpenDNFH
	Para cTipo
	Priv sComando

	Local llOk As Boolean
	Local loHasar As "Hasar.Fiscal.1"


	Try

		loHasar = NewHasar()
		loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
		loHasar.cEjecutando = "Abrir documento no fiscal homologado"

		llOk = .F.
		*!*			cTipo	=  IfEmpty( cTipo, "S" )
		sComando =  Chr(128) + FS + cTipo + FS + "T"

		llOk = Enviar( sComando )

		If llOk
			If Upper( loHasar.DescripcionEstadoControlador ) = Upper( "No hay ningún comprobante abierto" )
				llOk = .F.
				Stop( "No Se Ha Podido Abrir El Comprobante", "Fallo al abrir el comprobante" )

			Else
				If !lNCR
					Wait Window "Se Ha Abierto El Siguiente Comprobante: " + loHasar.DescripcionDocumentoEnCurso Nowait
				Endif

			Endif

		Endif


	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null

	Endtry

	Return llOk

	************************************************************************************
	*  3.6.2. PrintEmbarkItem - Imprimir item en remito u orden de salida
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde imprimiendo una l¡nea dividida en dos campos: descripci¢n y cantidad.
	*  Este comando es rechazado si no se encuentra abierto un documento no fiscal
	*  homologado Remito u Orden de salida.
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   4	   é (ASCII 130)
	*	   1	   FS
	*	   108	   Descripci¢n item (hasta 108 caracteres)						   A
	*	   1	   FS
	*	   8	   Cantidad (nnn.nnnn)													   N
	*	   1	   FS
	*	   1	   Par metro display: 0, 1 o 2										   N (Opc)
	*  (existente por compatibilidad
	*  con otros modelos)
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   4	   é (ASCII 130)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H
	*
	*

Function PrintEmbarkItem
	Para sTexto,;
		nCantidad,;
		nDecCant

	Private sComando,cCant
	Local llOk As Boolean
	Local loHasar As "Hasar.Fiscal.1"

	Try


		llOk = .T.

		If lHasar

			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"


			cCant	=  Alltrim( Str( Abs( nCantidad ),	8, nDecCant ))

			sComando =  Chr( 130 ) + FS
			sComando =  sComando + sTexto + FS
			sComando =  sComando + cCant  + FS
			sComando =  sComando + "0"

			TEXT To lcCommand NoShow TextMerge Pretext 03
			Imprimir item en remito u orden de salida:
			-  Texto: <<sTexto>>
			-  Cantidad: <<cCant>> ]
			ENDTEXT

			loHasar.cEjecutando = lcCommand

			llOk = Enviar( sComando )

		Endif


	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		llOk = .F.
		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return llOk


	*
	************************************************************************************

	*  3.6.5. CloseDNFH - Cerrar documento no fiscal homologado
	*
	*  Sintaxis:
	*	  CloseDNFH()
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*
	*  Responde:
	*  Cerrando el comprobante no fiscal homologado; adem s:
	*  a. Si se trata de una Nota de crédito: calculando el total e imprimiéndolo. Adem s,
	*  imprimiendo (según el tipo de nota de crédito abierta algunos de estos campos
	*  no aparecen) los montos correspondientes a subtotales de ventas discriminados
	*  por al¡cuotas de IVA, las al¡cuotas de IVA, los montos correspondientes a éstas,
	*  las percepciones, los impuestos internos y el monto total del documento.
	*  Finalmente, imprimiendo dos l¡neas con las leyendas "Firma" y "Aclaraci¢n".
	*  b. Si se trata de un Remito, de una Orden de salida o de una Cotizaci¢n:
	*  imprimiendo al pie dos l¡neas con las leyendas "Firma" y "Aclaraci¢n".
	*  c. Si se trata de un Resumen de cuenta: calculando el saldo e imprimiéndolo al pie
	*  de la p gina (un saldo positivo significa Debe y un saldo negativo significa
	*  Haber).
	*  d. Si se trata de un Recibo de uso interno (Recibo X ): calculando el total e
	*  imprimiéndolo al pie del documento, precedido por la leyenda "IMPORTE TOT.",
	*  seguido por dos l¡neas con las leyendas "Firma" y "Aclaraci¢n".
	*  e. Imprimiendo el trailer del comprobante, incluyendo los textos referidos a
	*  documento no fiscal homologado (excepto en el caso de la Nota de crédito) y el
	*  número correlativo.
	*  f. Eyéctando la hoja de la impresora (o pasando a la hoja siguiente en caso de
	*  tratarse de formulario continuo).
	*
	*  Este comando es rechazado si no se encuentra abierto un comprobante no fiscal
	*  homologado.
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	    (ASCII 129)
	*
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	    (ASCII 129)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H
	*	   1	   FS
	*	   8	   Número del DNFH recién emitido (nnnnnnnn)			   N
	*  (s¢lo v lido para Notas de Crédito o Remitos;
	*  en el resto, este campo ser  0)

Function CloseDNFH
	Priv sComando
	Local loHasar As "Hasar.Fiscal.1"

	Try

		If lHasar

			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
			loHasar.cEjecutando = "Cerrar documento no fiscal homologado"

			If !lNCR
				Wait Window "Cerrando " + loHasar.DescripcionDocumentoEnCurso Nowait
			Endif

		Endif
		sComando =  Chr( 129 )

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null

	Endtry

	Return sComando

	************************************************************************************
	*  3.8.1. SetDateTime - Ingresar fecha y hora
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra
	*  Pone en fecha y hora el reloj de tiempo real. La fecha y la hora del reloj de tiempo
	*  real son impresos en todos los documentos. La fecha es, adem s, grabada en los
	*  registros diarios cuando se realiza un cierre de jornada fiscal.
	*  Este comando es rechazado si:
	*  a.  El formato es incorrecto; b. Inmediatamente antes no se ha realizado un cierre
	*  de jornada fiscal (comando DailyClose).
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   X (ASCII 88)
	*	   1	   FS
	*	   6	   Fecha (formato AAMMDD)										   D
	*	   1	   FS
	*	   6	   Hora (formato HHMMSS)											   T
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   X (ASCII 88)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H
	*

Function SetDateTime( tcFecha As String, tcHora As String )
	Local sComando

	sComando =	Chr( 88 ) + FS
	sComando =	sComando + tcFecha + FS
	sComando =	sComando + tcHora

	Return Enviar( sComando )

	************************************************************************************
	*  3.8.2. GetDateTime - Consultar fecha y hora
	*
	*  Sintaxis:
	*	  GetDateTime( cPara )
	*		   cPara  =  "D"     -> Date
	*		   cPara  =  "T"     -> Time
	*
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra
	*  Responde con la fecha y la hora del reloj de tiempo real.
	*
	*  Comando
	*  Longitud    Descripci¢n							 Tipo
	*	   1	   Y (ASCII 89)
	*
	*  Respuesta
	*  Longitud    Descripci¢n							 Tipo
	*	   1	   Y (ASCII 89)
	*	   1	   FS
	*	   4	   Status de la impresora				   H
	*	   1	   FS
	*	   4	   Status fiscal						   H
	*	   1	   FS
	*	   6	   Fecha (Formato AAMMDD)				   D
	*	   1	   FS
	*	   6	   Hora (Formato HHMMSS)				   T

Function GetDateTime
	Para cPara
	Local loHasar As "Hasar.Fiscal.1"
	Local ldFecha As Date
	Local lcTime As String,;
		lcResp As String,;
		lcMsg As String,;
		lcOldDate As String,;
		lcOldCentury As String

	Local lnSeconds As Integer

	Try

		lcOldCentury = Set("Century")
		lcOldDate = Set("Date")

		If lHasar
			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
			loHasar.cEjecutando = ""


			llRetry = .T.

			Do While llRetry

				llRetry = .F.

				Try

					loHasar.cEjecutando = "Obtener Fecha y Hora Fiscal"
					loHasar.FechaHoraFiscal()

				Catch To oErr

					llRetry = RetryCommand( oErr, loHasar.cEjecutando )

					If !llRetry
						Throw oErr
					Endif

				Finally

				Endtry

			Enddo


			cPara =  IfEmpty( cPara, "T" )

			If cPara = "T"
				lcResp = loHasar.Respuesta( 4 )
				lcTime = Transform( lcResp, "@R 99:99:99" )

			Else
				lcResp 	= loHasar.Respuesta( 3 )
				ldFecha = F_Cafe( lcResp )

			Endif

		Else
			If cPara = "T"
				lcTime = Time()
				*!*					lcTime = Dec2Hms( Hms2Dec( Time() ) + ( 60*15 + 13 ))
				*!*					Inkey()
				*!*					MessageBox( lcTime )

			Else
				ldFecha = Date()

			Endif

		Endif

		If cPara = "D"
			*!*				If Vartype( FECHAHOY ) = "D"
			If ldFecha # Date()
				Set Century On
				TEXT To lcMsg NoShow TextMerge Pretext 03
					Error de Fecha:
					Fecha del Sistema: <<Dtoc( Date() )>>
					Fecha de la HASAR: <<Dtoc( ldFecha )>>
				ENDTEXT

				Wait Window Nowait Noclear lcMsg

				Warning( lcMsg, "Error de Fecha" )

				Logerror( lcMsg )

			Endif
			*!*				Endif

		Endif

		If cPara = "T"
			lnSeconds = Abs( Hms2Dec( Time() ) - Hms2Dec( lcTime ) )

			If lnSeconds > ( 60 * 15 ) && 15 minutos

				TEXT To lcMsg NoShow TextMerge Pretext 03
					Error de Hora:
					Hora del Sistema: <<Time()>>
					Hora de la HASAR: <<lcTime>>
				ENDTEXT

				Wait Window Nowait Noclear lcMsg

				Warning( lcMsg, "Error de Hora" )

				Logerror( lcMsg )

			Endif

		Endif


	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null
		Set Century &lcOldCentury
		Set Date &lcOldDate

	Endtry

	Return Iif( cPara = "T", lcTime, ldFecha )

	************************************************************************************
	*  3.8.3. SetFantasyName - Programar texto del nombre de fantas¡a del
	*  propietario
	*
	*  Sintaxis:
	*		 SetFantasyName( nLinea 		 , ;
	*						 sTexto 		 , ;   &&  C 50
	*						 )
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra
	*  Almacena en memoria de trabajo una l¡nea de texto de la estructura FANTASY. La
	*  estructura FANTASY consta de dos l¡neas que se imprimen autom ticamente en el
	*  encabezamiento de la factura, inmediatamente abajo del logotipo, y son usadas en
	*  los casos en los que el nombre con el que es conocida una empresa no es igual al
	*  nombre de la raz¢n social.
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   _ (ASCII 95)
	*	   1	   FS
	*	   1	   N§ de l¡nea del nombre de fantas¡a (1-2) 					   N
	*	   1	   FS
	*	   50	   Texto de hasta 50 caracteres 								   A
	*
	*  Para borrar una l¡nea del nombre de fantas¡a ya ingresada en memoria de trabajo,
	*  debe enviarse el comando con s¢lo el c¢digo ASCII 7fH (DEL) en el campo de
	*  texto.
	*  Si el primer caracter del texto es ASCII F4H, la l¡nea se imprime en doble ancho (y
	*  la cantidad m{axima de caracteres se reduce a 25).
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   _ (ASCII 95)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H
	*

Function SetFantasyName
	Para nLinea, sTexto
	Priv sComando, cLinea, nI, Ret
	Local loHasar As "Hasar.Fiscal.1"

	Try
		sComando	= ""

		If lHasar
			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
			loHasar.cEjecutando = ""
			Ret = ""
			sTexto		= IfEmpty( sTexto, Chr( 127 ) )
			*!*				nLinea		= IfEmpty( nLinea,  0 )

			If Empty( nLinea ) && Borra recursivamente las lineas de Fantasia
				For nI = 1 To 2

					TEXT To lcEjecutando NoShow TextMerge Pretext 15
					Borrando línea de fantasía <<nI>>
					ENDTEXT

					loHasar.cEjecutando = lcEjecutando

					Enviar( SetFantasyName( nI ) )
				Next

			Else
				cLinea   =  Alltrim( Str( nLinea ))

				If Inlist( loHasar.nModelo, MODELO_715, MODELO_715_201, MODELO_715_302, MODELO_715_403, MODELO_P441 )
					sTexto = Alltrim( Substr( sTexto, 1, 40 ))
				Endif

				sComando =  Chr( 95 ) + FS
				sComando =  sComando + cLinea + FS
				sComando =  sComando + sTexto

				TEXT To lcEjecutando NoShow TextMerge Pretext 03
				Seteando línea de Fantasía [ <<sTexto>> ]
				en la línea <<nLinea>>
				ENDTEXT

				loHasar.cEjecutando = lcEjecutando

			Endif
		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null

	Endtry

	Return sComando

	************************************************************************************
	*  3.8.5. SetHeaderTrailer - Programar texto de encabezamiento y cola de
	*  documentos
	*
	*  Sintaxis:
	*		 SetHeaderTrailer( nLinea		   , ;
	*						   sTexto		   , ;	 &&  C 50
	*						   )
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*
	*  Almacena una l¡nea de texto en la estructura HEADER o TRAILER, para ser
	*  impresa en el encabezamiento o la cola de un documento. El encabezamiento y
	*  cola de documentos no se imprime en los documentos no fiscales homologados.
	*
	*  La estructura HEADER (l¡neas 1 a 10) se usa para imprimir la direcci¢n y otros
	*  datos relativos al due¤o del controlador fiscal que se desee hacer figurar en el
	*  encabezamiento de una factura. En el presente modelo s¢lo se usan las l¡neas 1 a
	*  5 (las l¡neas restantes existen por compatibilidad con modelos anteriores).
	*   Las l¡neas 1 y 2 est n destinadas al domicilio fiscal y el domicilio comercial del
	*  propietario y se imprimen a continuaci¢n del logotipo y del nombre de fantas¡a.
	*   Las l¡neas 3 a 5 est n destinadas a leyendas de interés comercial y se
	*  imprimen
	*
	*  P-715F: Las lineas 1-4 estan reservadas para los datos del propietario.
	*	  Las lineas 5-10 se imprimen a continuaci¢n dela leyenda "A CONSUMIDOR FINAL"
	*	  cuando es ticket.
	*	  En un ticket factura, las lineas 9-10 se destinan al domicilio del comprador,
	*
	*
	*  La estructura TRAILER (l¡neas 11 a 20) se usa para imprimir el nombre del cajero,
	*  número de cheque, u otros datos que se desee hacer figurar en la cola del
	*  comprobante. En el presente modelo s¢lo se usan las l¡neas 11 a 14, que se
	*  imprimen en la cola del documento, arriba de la zona destinada al N§ de Registro y
	*  al logotipo fiscal (las l¡neas restantes existen por compatibilidad con modelos
	*  anteriores).
	*
	*  P-715F: En un ticket, se pueden utilizar las l¡neas 11-20, mientras que en
	*	  ticket factura, solo las lineas 11-14
	*
	*  Nota: Los datos que corresponden al encabezamiento y cola de un documento que
	*  se encuentran almacenados en memoria fiscal (Logotipo de la empresa, Raz¢n
	*  social, CUIT, N§ de Registro, N§ de PV), m s los números de comprobante fiscal,
	*  logotipo fiscal, etc., son impresos autom ticamente, sin intervenci¢n del presente
	*  comando.
	*
	*  Comando
	*  Longitud    Descripci¢n											   Tipo
	*	   1	   ] (ASCII 93)
	*	   1	   FS
	*	   2	   N§ de l¡nea de encabezamiento (1-5) o cola (11-14)	   N
	*	   1	   FS
	*	   50	   Texto de hasta 50 caracteres (ver nota)				   A
	*
	*  Para borrar una l¡nea de encabezamiento/cola ya ingresada en memoria de trabajo,
	*  debe enviarse un comando con s¢lo el c¢digo ASCII 7fH (DEL) en el campo de
	*  texto.
	*  Si el primer caracter del texto es ASCII F4H (244), la l¡nea se imprime en doble ancho (y
	*  la cantidad m xima de caracteres se reduce a 25).
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   ] (ASCII 93)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H
	*
	*
	*  ATENCION MODELO P-615F
	*  P-615F (MAXIMO 40 CARACTERES)
	*  S¢lo se usan las l¡neas 5 a 10
	*   Las l¡neas 1 a 4 est n destinadas al domicilio fiscal y el domicilio comercial del
	*  propietario y se imprimen a continuaci¢n del logotipo y del nombre de fantas¡a.
	*   Las l¡neas 5 a 10 est n destinadas a leyendas de interés comercial y se
	*  imprimen a continuaci¢n de la leyenda A CONSUMIDOR FINAL
	*  En el Ticket-Factura, las l¡neas 8 a 10 est n destinadas al domicilio del
	*  comprador


Function SetHeaderTrailer
	Para nLinea, sTexto, nLen
	Priv sComando, cLinea, nI,Ret
	Local loHasar As "Hasar.Fiscal.1"
	Local lcEjecutando As String

	Try

		sComando = ""

		If lHasar
			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"

			sTexto =  Iif( Vartype( sTexto ) # "C",  Chr( 127 ), sTexto )
			Ret=""

			Do Case
				Case Empty( nLinea ) && Borra recursivamente las cuatro lineas del Trailer

					For nI = 11 To 14
						TEXT To lcEjecutando NoShow TextMerge Pretext 15
						Borrando el Pié de Página - Línea <<nI>>
						ENDTEXT

						loHasar.cEjecutando = lcEjecutando

						Enviar( SetHeaderTrailer( nI ) )
					Next

				Case nLinea = -1 && Borra recursivamente todas las lineas del Header

					For nI = 1 To 10
						TEXT To lcEjecutando NoShow TextMerge Pretext 15
						Borrando el Encabezado - Línea <<nI>>
						ENDTEXT

						loHasar.cEjecutando = lcEjecutando

						Enviar( SetHeaderTrailer( nI ) )
					Next

				Case nLinea = -2 && Borra recursivamente todas las lineas del Trailer
					For nI = 11 To 20
						TEXT To lcEjecutando NoShow TextMerge Pretext 15
						Borrando el Pié de Página - Línea <<nI>>
						ENDTEXT

						loHasar.cEjecutando = lcEjecutando

						Enviar( SetHeaderTrailer( nI ) )
					Next

				Otherwise
					Do Case
						Case loHasar.nModelo = MODELO_615
							nLen = 40

						Case Inlist( loHasar.nModelo, MODELO_715, MODELO_715_201, MODELO_715_302, MODELO_715_403, MODELO_P441 )
							nLen = 40

						Otherwise
							nLen = 50

					Endcase

					sTexto   =  Substr( sTexto, 1, nLen )
					cLinea   =  Alltrim( Str( nLinea ))
					sComando =  Chr( 93 ) + FS
					sComando =  sComando + cLinea + FS
					sComando =  sComando + sTexto

					TEXT To lcEjecutando NoShow TextMerge Pretext 03
					Imprimiendo la leyenda [ <<sTexto>> ]
					en la línea <<nLinea>>
					ENDTEXT

					loHasar.cEjecutando = lcEjecutando


			Endcase

		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null

	Endtry

	Return sComando

	************************************************************************************
	*  3.8.7. SetCustomerData - Datos comprador factura
	*
	*  Sintaxis:
	*		 SetCustomerData( sRazonSocial	  , ;	&&	C 50
	*						  nCuit 		  , ;	&&	N 11 N§ Documento/Cuit
	*						  cInsc 		  , ;	&&	C 01 Resp. frente al IVA
	*						  cDocumento	  , ;	&&	C 01 Tipo de Documento
	*						  sDomComercial 	;	&&	C 50 Domicilio Comercial
	*						  )
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde
	*  a.  Almacenando el nombre, responsabilidad frente al IVA y número de
	*  CUIT/documento del comprador,
	*  b.  Verificando la consistencia interna del CUIT, en caso de ingres rselo,
	*  c.  Verificando la coherencia entre el valor del byte 68 (responsabilidad frente al
	*  IVA) y el del byte 70 (CUIT o documento), de acuerdo con la siguiente tabla
	*
	*			   Byte 68						   Byte 70 (valores admitidos)
	*
	*			   I / N / A / E / B / M   / T	   C
	*			   C							   C / 0 / 1 / 2 / 3 / 4 / <SP> (espacio en blanco)
	*
	*  Los datos ingresados son impresos mediante el comando de apertura de
	*  documento fiscal y son borrados de memoria una vez emitida éste.
	*
	*  Notas:
	*  Si una factura a consumidor final (byte 68: C) no supera el l¡mite (monto)
	*  programado mediante los comandos de	configuraci¢n (valor por defecto $1.000),
	*  los campos correspondientes a nombre, numero de CUIT o documento, calificador
	*  de documento y domicilio comercial son opcionales. Si la factura no es a
	*  consumidor final, estos campos son obligatorios.
	*  Este comando s¢lo es aceptado si no se encuentra abierto un comprobante (fiscal,
	*  no fiscal o no fiscal homologado).
	*
	*  No emitir este comando impide abrir los siguientes documentos:
	*   Factura A
	*   Nota de débito A
	*   Recibo fiscal A
	*   Nota de crédito
	*   Recibo X
	*  Sin embargo, pueden abrirse los siguientes documentos:
	*   Factura B y C
	*   Nota de débito B y C
	*   Recibo fiscal B y C
	*  En este caso, se considera que el comprador es Consumidor final y queda vigente
	*  el l¡mite de monto mencionado en la nota preliminar.
	*
	*  Nota:
	*  Este comando difiere del de modelos anteriores en que cuenta con un nuevo
	*  campo (el último), dedicado a la direcci¢n del comprador. Las l¡neas 9 y 10 de la
	*  estructura HEADER, en las que se ingresaba la direcci¢n del comprador en los
	*  modelos anteriores, no se usan en el mismo modelo
	*
	*  Comando
	*
	*  Longitud    Descripci¢n								  Tipo
	*	   1	   b (ASCII 98)
	*	   1	   FS
	*	   50	   Nombre (hasta 50 caracteres) 			  A (Opc)
	*	   1	   FS
	*	   11	   CUIT / N§ documento						  N (Opc)
	*	   1	   FS
	*	   1	   Responsabilidad frente al IVA			  A
	*						I. Responsable inscripto
	*						N: Responsable no inscripto
	*						E: Exento
	*						A: No responsable
	*						C: Consumidor final
	*						B: Resp. no inscripto, venta de bienes de uso
	*						M: Resp. monotributo
	*						T: No categorizado

	*						solo 715
	*						S: Monotributista Social
	*						V: Peque¤o Contribuyente Eventual
	*						W: Peque¤o Contribuyente Eventual Social
	*
	*	   1	   FS
	*	   1	   Tipo de documento						  A (Opc)
	*						C: CUIT
	*						 0: Libreta de enrolamiento
	*						 1: Libreta c¡vica
	*						 2: Documento Nacional de Identidad
	*						 3: Pasaporte
	*						 4: Cédula de identidad
	*						 (espacio en blanco): Sin calificador
	*						solo 715
	*						 L: CUIL
	*	   1	   FS
	*	   50	   Domicilio comercial (hasta 50 caracteres)

	*  ATENCION MODELO P-615F
	*  P-615F (MAXIMO 30 CARACTERES)
	*  NO se envia el Domicilio (Ver HeaderTrailer)

Function SetCustomerData
	Para sRazonSocial, nCuit, cInsc, cDocumento, sDomComercial
	Priv sComando, sCuit
	Local loHasar As "Hasar.Fiscal.1"
	Local llOk As Boolean

	Try

		llOk = .T.

		If lHasar
			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
			loHasar.cEjecutando = ""

			sCuit	=  StrZero( nCuit, 11 )

			If Inlist( Asc( cDocumento ), TIPO_CUIT, TIPO_CUIL  )
				llOk = Valcuit( Transform( nCuit, "99-99999999-9" ), 2, .F. )
			Endif

			If llOk

				Do Case
					Case CF_MODEL='NCR'
						sComando =  Chr( 98 ) + FS
						sComando =  sComando + Substr(sRazonSocial,1,30) + FS
						sComando =  sComando + sCuit + FS
						sComando =  sComando + cInsc + FS
						sComando =  sComando + cDocumento + FS
						sComando =  sComando + sDomComercial

					Case loHasar.nModelo = MODELO_615
						sComando =  Chr( 98 ) + FS
						sComando =  sComando + Substr(sRazonSocial,1,30) + FS
						sComando =  sComando + sCuit + FS
						sComando =  sComando + cInsc + FS
						sComando =  sComando + cDocumento

					Case Inlist( loHasar.nModelo, MODELO_715, MODELO_715_201, MODELO_715_302, MODELO_715_403, MODELO_P441 )
						sDomComercial  =	Alltrim( Substr( sDomComercial, 1, 40 ))
						sComando =  Chr( 98 ) + FS
						sComando =  sComando + Substr(sRazonSocial,1,30) + FS
						sComando =  sComando + sCuit + FS
						sComando =  sComando + cInsc + FS
						sComando =  sComando + cDocumento + FS
						sComando =  sComando + sDomComercial

					Otherwise
						sComando =  Chr( 98 ) + FS
						sComando =  sComando + sRazonSocial + FS
						sComando =  sComando + sCuit + FS
						sComando =  sComando + cInsc + FS
						sComando =  sComando + cDocumento + FS
						sComando =  sComando + sDomComercial

				Endcase


				TEXT To lcEjecutando NoShow TextMerge Pretext 03
				Imprimir Datos del Cliente
				-  Razón Social: <<sRazonSocial>>
				-  Cuit o Documento: <<sCuit>>
				-  Domicilio: <<sDomComercial>>
				ENDTEXT

				loHasar.cEjecutando = lcEjecutando

				llOk = Enviar( sComando )

			Else
				Inform( "El Cuit/Cuil ingresado NO ES VALIDO", "Verificando Datos del Cliente" )

			Endif
		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null

	Endtry

	Return llOk

	***************************************************************************

	*  3.8.8. SetEmbarkNumber - Cargar informaci¢n remito / comprobante original
	*
	*  Sintaxis:
	*		 SetEmbarkNumber( cLinea		  , ;	&&	C 01 1 ¢ 2
	*						  nNumero		  , ;	&&	N 08 N§ Comprobante Original
	*						  )
	*
	*	  Si no se pasan par metros, genera linea 1 vac¡a
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra
	*  Almacena en memoria de trabajo texto con la siguiente informaci¢n:
	*  a. Si el documento a abrir posteriormente es una factura, recibo o nota de débito:
	*  almacena la identificaci¢n de un remito.
	*  b. Si el documento a abrir posteriormente es una nota de crédito: almacena el
	*  número del documento fiscal que origina la nota de crédito. En este caso, la nota
	*  de crédito no podr  abrirse si antes no se ha emitido el presente comando.
	*  Los documento tienen espacio para dos l¡neas de números de remito /
	*  comprobante original, que se imprimen autom ticamente. En el caso de la nota de
	*  crédito, s¢lo es obligatorio cargar la primera l¡nea; la segunda l¡nea es opcional.
	*
	*
	*  Comando
	*  Longitud    Descripci¢n												 Tipo
	*	   1	   “ (ASCII 147)
	*	   1	   FS
	*	   6	   N§ de l¡nea de remito / comprobante original (1-2)		   N
	*	   1	   FS
	*	   20	   Texto de hasta 20 caracteres 							   A
	*
	*  Para borrar una l¡nea del nombre de fantas¡a ya ingresada en memoria de trabajo,
	*  debe enviarse el comando con s¢lo el c¢digo ASCII 7fH (DEL) en el campo de
	*  texto.
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   “ (ASCII 147)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H
	*

Function SetEmbarkNumber
	Para cLinea, nNumero
	Priv sComando, sNumero

	*!*		cLinea		  =  IfEmpty( cLinea, "1")
	*!*		nNumero		  =  IfEmpty( nNumero, .T. )

	If cLinea <> "1" .And. cLinea <> "2"
		cLinea = "1"
	Endif

	Do Case
		Case Empty( nNumero )
			sNumero  =  Chr( 255 )

		Case Type( "nNumero" ) =  "N"
			sNumero  =  Alltrim( StrZero( nNumero, 8 ))

		Case Type( "nNumero" ) =  "C"
			sNumero  =  Substr( nNumero, 1, 20)

		Otherwise
			sNumero  =  Chr( 255 )

	Endcase



	sComando =  Chr(147) + FS
	sComando =  sComando + cLinea + FS
	sComando =  sComando + sNumero

	Return sComando

	**************************************************************************


Function TranInsc
	Para nInsc
	Dimension  aTipos [ 08 ]

	If nInsc < 1 .Or. nInsc > 08
		nInsc = 2  && Fuerza Consumidor Final
	Endif

	aTipos[ 01 ] = "I"
	aTipos[ 02 ] = "C"
	aTipos[ 03 ] = "A"
	aTipos[ 04 ] = "N"
	aTipos[ 05 ] = "E"
	aTipos[ 06 ] = "B"
	aTipos[ 07 ] = "M"
	aTipos[ 08 ] = "T"

	Return aTipos[ nInsc ]

	*
	* Blanquea los datos del cliente
Procedure If_Inicializar(  ) As Void;
		HELPSTRING "Blanquea los datos del cliente"
	Local lcCommand As String
	Local loCliente As Object
	Local loComprobante As Object
	Local loHasar As "Hasar.Fiscal.1"

	Try

		lcCommand = ""

		loHasar = NewHasar()
		loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
		loHasar.cEjecutando = ""
		loHasar.cRemark 	= ""
		loHasar.cEjecutando	= ""

		loCliente 		= loHasar.oCliente
		loComprobante 	= loHasar.oComprobante

		loCliente.sRazonSocial 		= ""
		loCliente.nCuit 			= 0
		loCliente.nInsc 			= 0
		loCliente.cInsc 			= ""
		loCliente.cDocumento 		= ""
		loCliente.sDomComercial 	= ""
		loCliente.lIIBB901 			= GetValue( "PIIBB901", "ar0Imp", "N" ) = "S"
		loCliente.lIIBB902 			= GetValue( "PIIBB902", "ar0Imp", "N" ) = "S"
		loCliente.lIIBB177 			= GetValue( "PIIBB177", "ar0Imp", "N" ) = "S"

		loComprobante.nItems 			= 0
		loComprobante.nVentas 			= 0
		loComprobante.nIva 				= 0
		loComprobante.nPago 			= 0
		loComprobante.nIvaNoInscripto 	= 0
		loComprobante.nPercepciones		= 0
		loComprobante.nNumero 			= 0
		loComprobante.cTipoComprobante 	= ""
		loComprobante.nComp 			= 0
		loComprobante.nNumero1 			= 0
		loComprobante.nNumero2 			= 0

		loHasar.oIvas.Remove( -1 )



	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Remark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar 		= Null
		loCliente 		= Null
		loComprobante 	= Null

	Endtry

Endproc && If_Inicializar

************************************************************************************

*  4. Documentos
*  Los comandos disponible para cada tipo de documento son los siguientes:
*
*  4.1. Facturas, Notas de débito y Notas de crédito
*   Cargar datos comprador (previo a la apertura del documento)
*   Cargar números documento original asociados (obligatorio en notas de crédito -
*  previo a la apertura del documento)
*   Cargar informaci¢n números de remitos (en facturas y notas de débito - previo a la
*  apertura del documento)
*   Abrir documento fiscal (s¢lo facturas y notas de débito)
*   Abrir documento no fiscal homologado (s¢lo notas de crédito)
*   Imprimir texto fiscal


Function IF_Cabeza
	Parameters sRazonSocial	,;	  && C 50
	nCuit 					,;	  && N 11  Cuit o Documento
	nInsc 					,;	  && N 01
	cDocumento				,;	  && C 01  Tipo de Documento "C01234 "
	sDomComercial 			,;	  && C 50
	cTipoDoc				,;	  && C 01  "ABRT"
	nComp 					,;	  && N 02  1,2,3,18,20
	nNumero1				,;
		nNumero2				,;
		Result

	Local loHasar As "Hasar.Fiscal.1"

	Priv cTipoDoc, cInsc, nTipoDoc
	Priv lOk
	Dimension aTipoDoc[8]

	Local loComprobante As Object,;
		loCliente As Object

	Local llRetry As Boolean

	Try

		lOk = .T.
		If lHasar

			If_Inicializar()
			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
			loHasar.cEjecutando = ""

			loComprobante 	= loHasar.oComprobante
			loCliente 		= loHasar.oCliente

			llRetry = .T.

			Do While llRetry

				llRetry = .F.

				Try

					loHasar.cEjecutando = "Tratar De Cancelar Todo"
					loHasar.TratarDeCancelarTodo()

				Catch To oErr

					llRetry = RetryCommand( oErr, loHasar.cEjecutando )

					If !llRetry
						Throw oErr
					Endif

				Finally

				Endtry

			Enddo

			If loHasar.nModelo = MODELO_615
				sRazonSocial  =	Alltrim( Substr( sRazonSocial , 1, 30 ))

			Else
				sRazonSocial  =	Alltrim( Substr( sRazonSocial , 1, 50 ))

			Endif

			Do Case
				Case CF_MODEL='NCR'
					sDomComercial =	Alltrim( Substr( sDomComercial, 1, 30 ))

				Case loHasar.nModelo = MODELO_615
					sDomComercial =	Alltrim( Substr( sDomComercial, 1, 30 ))

				Case Inlist( loHasar.nModelo, MODELO_715, MODELO_715_201, MODELO_715_302, MODELO_715_403, MODELO_P441 )
					sDomComercial =	Alltrim( Substr( sDomComercial, 1, 40 ))

				Otherwise
					sDomComercial =	Alltrim( Substr( sDomComercial, 1, 50 ))

			Endcase

			cInsc		  =  TranInsc( nInsc )

			If Empty( sRazonSocial )
				sRazonSocial = '-'
			Endif

			If Empty( sDomComercial )
				sDomComercial = '-'
			Endif

			If !cDocumento$"CL01234 "
				cDocumento  =  " "
			Endif

			lOk 	 =	.F.

			aTipoDoc[ 1 ] = "A"           &&      Factura         "A"
			aTipoDoc[ 2 ] = "B"           &&      Factura         "B"
			aTipoDoc[ 3 ] = "R"           &&      Nota de Crédito "A"
			aTipoDoc[ 4 ] = "S"           &&      Nota de Crédito "B"
			aTipoDoc[ 5 ] = "D"           &&      Nota de Débito  "A"
			aTipoDoc[ 6 ] = "E"           &&      Nota de Débito  "B"
			aTipoDoc[ 7 ] = "r"           &&      Remito
			aTipoDoc[ 8 ] = "T"           &&      Ticket


			Do Case

				Case cTipoDoc =  "A"

					Do Case
						Case nComp =  1
							nTipoDoc =  1

						Case nComp =  2
							nTipoDoc =  5

						Case nComp =  3
							nTipoDoc =  3

						Otherwise
							nTipoDoc =  1
					Endcase

				Case cTipoDoc = "B"
					Do Case
						Case nComp =  1
							nTipoDoc =  2

						Case nComp =  2
							nTipoDoc =  6

						Case nComp =  3
							nTipoDoc =  4

						Otherwise
							nTipoDoc =  2
					Endcase

				Case cTipoDoc = "R"
					Do Case
						Case nComp =  18	&& Transferencia de Salida
							nTipoDoc =  7

						Case nComp =  20	&& Remito de Salida
							nTipoDoc =  7

						Otherwise
							nTipoDoc =  7
					Endcase


				Case cTipoDoc = "T"
					nTipoDoc =  8

				Otherwise		nTipoDoc =  2

			Endcase

			* Inicializar Datos del Cliente (para control)

			loCliente.sRazonSocial 		= sRazonSocial
			loCliente.nCuit 			= nCuit
			loCliente.nInsc 			= nInsc
			loCliente.cInsc 			= cInsc
			loCliente.cDocumento 		= cDocumento
			loCliente.sDomComercial 	= sDomComercial
			loCliente.lIIBB901 			= loCliente.lIIBB901 And ( cInsc = "I" )
			loCliente.lIIBB902 			= loCliente.lIIBB902 And ( cInsc = "I" )
			loCliente.lIIBB177 			= loCliente.lIIBB901 And ( cInsc = "M" )


			loComprobante.cTipoComprobante 	= cTipoDoc
			loComprobante.nComp 			= nComp
			loComprobante.nNumero1 			= nNumero1
			loComprobante.nNumero2 			= nNumero2
			loComprobante.nNumero 			= GetNumero( nComp,	cTipoDoc ) + 1


			cTipoDoc =	aTipoDoc[ nTipoDoc ]


			* Cargar datos comprador (previo a la apertura del documento)

			lOk = SetCustomerData( sRazonSocial	, ;
				nCuit			, ;
				cInsc			, ;
				cDocumento		, ;
				sDomComercial	)


			loHasar.cEjecutando = ""

			If lOk
				If cTipoDoc$"RSr"  && Nota de Credito / Remito

					* Pedir número del documento fiscal que origina la nota de crédito.

					If cTipoDoc$"RSr"  && Nota de Credito
						If loHasar.nModelo # MODELO_615
							lOk = Enviar ( SetEmbarkNumber( "1"             , ;
								nNumero1		) )
							If !Empty( nNumero2 )

								lOk = Enviar ( SetEmbarkNumber( "2"             , ;
									nNumero2 	   ) )

							Endif
						Else
							lOk = .T.
						Endif
					Endif

					If lOk

						* Abrir documento no fiscal homologado

						lOk   =  OpenDNFH( cTipoDoc )
					Endif

				Else
					* Abrir documento fiscal (s¢lo facturas, tickets	y notas de débito)


					If loHasar.nModelo # MODELO_615
						If !Empty( nNumero1 )

							lOk = Enviar ( SetEmbarkNumber( "1"             , ;
								nNumero1		  ))
						Endif
						If !Empty( nNumero2 )

							lOk = Enviar ( SetEmbarkNumber( "2"             , ;
								nNumero2		  ))
						Endif
					Endif

					lOk	 =	OpenFiscalReceipt( cTipoDoc )

				Endif
			Endif
		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		lOk = .F.

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )


	Finally
		If lHasar
			loHasar.cEjecutando = ""
			loHasar = Null
		Endif


	Endtry

	Return lOk

	*****************************************************************************

	*   Vender item
	*   Descuento / recargo último item vendido

Function IF_Items
	Para sUF
	Priv lOk

	Local lcCommand As String

	Try

		lcCommand = ""
		lOk = .F.

		loHasar = NewHasar()
		loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
		loHasar.cEjecutando = ""

		Do &sUF

		lOk = .T.

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Remark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally


	Endtry

	Return lOk


	*   Bonificaci¢n / recargo general - Devoluci¢n de envases
	*   Percepciones (s¢lo documentos A y B)
	*   Cargar IVA no inscripto (s¢lo documentos A a Responsable no inscripto)
	*   Subtotal
	*   Cargar c¢digo de barras
	*   Pagar
	*   Cerrar documento fiscal (s¢lo facturas y notas de débito)
	*   Cerrar documento no fiscal homologado (s¢lo notas de crédito)

Function IF_Pie

	Lparameters  sTexto,;
		nMonto,;
		lIncluyeIva,;
		lDiscount,;
		nDecCant,;
		lDF,;
		Result,;
		UDF_Pago,;
		lImprime,;
		oObj

	Local lOk, nKey
	Local sComando As String,;
		cAiva As String,;
		sTexto As String,;
		cMonto As String

	Local lnIIBB As Number,;
		lnNeto As Number

	Local loHasar As "Hasar.Fiscal.1"
	Local loIIBB As oIIBB Of "Clientes\Iibb\Prg\Arrutibr.prg"
	Local loIvas As Collection
	Local loIva As Object
	Local lnVentas As Number,;
		lnIva As Number,;
		K As Number,;
		lnIvaAcumulado As Number


	Try

		lOk         =  .T.

		If lHasar

			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
			loHasar.cEjecutando = ""

			loIvas =  loHasar.oIvas

			lnVentas 	= loHasar.oComprobante.nVentas
			lnIva 		= loHasar.oComprobante.nIva

			*  Bonificaci¢n / recargo general

			If !Empty( nMonto )
				lOk = Enviar( GeneralDiscount( sTexto,;
					nMonto,;
					lIncluyeIva,;
					lDiscount,;
					nDecCant ))
			Endif

			If lOk
				* Pago

				Store 0 To nItems,;
					nVentas,;
					nIva,;
					nPago,;
					nIvaNoInscripto

				Subtotal( @nItems,;
					@nVentas,;
					@nIva,;
					@nPago,;
					@nIvaNoInscripto,;
					lImprime  )

				* Si hubo Descuento / Recargo, recalcular los importes de IVA aplicandoles el descuento

				If lnVentas # loHasar.oComprobante.nVentas
					K = loHasar.oComprobante.nVentas / lnVentas
					lnIvaAcumulado = 0

					For i = 1 To loIvas.Count
						loIva = loIvas.Item( i )

						If i = loIvas.Count
							loIva.Importe = loHasar.oComprobante.nIva - lnIvaAcumulado

						Else
							loIva.Importe = Round( loIva.Importe * K, 2 )
							lnIvaAcumulado = lnIvaAcumulado + loIva.Importe

						Endif

					Endfor
				Endif

				* Opcion 3.4.8. Perceptions - Percepciones

				*  Comando
				*  Longitud    Descripción										   Tipo
				*	   1		(ASCII 96)
				*	   1		FS
				*	   5		Alícuota de IVA (nn.nn / **.**)						A
				*	   1		FS
				*	   20		Hasta 20 caracteres de texto descripci¢n 			A
				*	   1		FS
				*	   10		Monto ([+]nnnnnn.nn) 								N


				* RA 2012-06-09(15:18:41)
				* Se inicializa in If_Cabeza()
				If loHasar.oCliente.lIIBB901

					* Percepcion IIBB CABA

					loIIBB	= NewIIBB()

					If !Empty( loIIBB.oSujeto.nAlicuotaPercepcion901 )

						lnIIBB	= loIIBB.AlicuotaPercepcion( 901 )

						If !Empty( lnIIBB )

							cAiva 	= "**.**"
							sTexto 	= "IIBB CABA " + Str( loIIBB.oSujeto.nAlicuotaPercepcion901, 5, 2 ) + "%"

							lnNeto  = nVentas - nIva - nIvaNoInscripto

							loIIBB	= NewIIBB()
							lnIIBB 	= loIIBB.ImportePercepcion( 901, lnNeto )
							cMonto 	= Alltrim( Str( lnIIBB, 9, 2 ))

							sComando =  Chr( 96 ) + FS
							sComando =  sComando + cAiva  + FS
							sComando =  sComando + sTexto + FS
							sComando =  sComando + cMonto

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Imprimiendo: [ <<sTexto>> ]
							ENDTEXT

							loHasar.cEjecutando = lcCommand

							Enviar( sComando )

							loHasar.oComprobante.nPercepciones = loHasar.oComprobante.nPercepciones + lnIIBB

							* RA 2012-06-08(12:24:36)
							* Vuelve a calcular los totales, porque la percepcion
							* afectó el total

							Subtotal( @nItems, ;
								@nVentas, ;
								@nIva, ;
								@nPago, ;
								@nIvaNoInscripto, ;
								lImprime  )

						Endif
					Endif

				Endif

				* RA 2012-06-09(15:18:41)
				* Se inicializa in If_Cabeza()
				If loHasar.oCliente.lIIBB902

					* Percepcion IIBB Buenos Aires

					loIIBB	= NewIIBB()

					If !Empty( loIIBB.oSujeto.nAlicuotaPercepcion902 )

						lnIIBB	= loIIBB.AlicuotaPercepcion( 902 )

						If !Empty( lnIIBB )

							cAiva 	= "**.**"
							sTexto 	= "IIBB BsAs " + Str( loIIBB.oSujeto.nAlicuotaPercepcion902, 5, 2 ) + "%"

							lnNeto  = nVentas - nIva - nIvaNoInscripto

							loIIBB	= NewIIBB()
							lnIIBB 	= loIIBB.ImportePercepcion( 902, lnNeto )
							cMonto 	= Alltrim( Str( lnIIBB, 9, 2 ))

							sComando =  Chr( 96 ) + FS
							sComando =  sComando + cAiva  + FS
							sComando =  sComando + sTexto + FS
							sComando =  sComando + cMonto

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Imprimiendo: [ <<sTexto>> ]
							ENDTEXT

							loHasar.cEjecutando = lcCommand

							Enviar( sComando )

							loHasar.oComprobante.nPercepciones = loHasar.oComprobante.nPercepciones + lnIIBB

							* RA 2012-06-08(12:24:36)
							* Vuelve a calcular los totales, porque la percepcion
							* afectó el total

							Subtotal( @nItems, ;
								@nVentas, ;
								@nIva, ;
								@nPago, ;
								@nIvaNoInscripto, ;
								lImprime  )

						Endif
					Endif
				Endif

				* RA 2012-06-09(15:18:41)
				* Se inicializa in If_Cabeza()
				If loHasar.oCliente.lIIBB177

					* Percepcion IIBB Monotributistas (Resolucion Gral. 177 )

					loIIBB	= NewIIBB()

					If !Empty( loIIBB.oSujeto.nAlicuotaPercepcion177 )

						lnIIBB	= loIIBB.AlicuotaPercepcion( 177 )

						If !Empty( lnIIBB )

							cAiva 	= "**.**"
							sTexto 	= "RES. 177 " + Str( loIIBB.oSujeto.nAlicuotaPercepcion177, 5, 2 ) + "%"

							lnNeto  = nVentas - nIva - nIvaNoInscripto

							loIIBB	= NewIIBB()
							lnIIBB 	= loIIBB.ImportePercepcion( 177, lnNeto )
							cMonto 	= Alltrim( Str( lnIIBB, 9, 2 ))

							sComando =  Chr( 96 ) + FS
							sComando =  sComando + cAiva  + FS
							sComando =  sComando + sTexto + FS
							sComando =  sComando + cMonto

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Imprimiendo: [ <<sTexto>> ]
							ENDTEXT

							loHasar.cEjecutando = lcCommand

							Enviar( sComando )

							loHasar.oComprobante.nPercepciones = loHasar.oComprobante.nPercepciones + lnIIBB

							* RA 2012-06-08(12:24:36)
							* Vuelve a calcular los totales, porque la percepcion
							* afectó el total

							Subtotal( @nItems, ;
								@nVentas, ;
								@nIva, ;
								@nPago, ;
								@nIvaNoInscripto, ;
								lImprime  )


						Endif
					Endif
				Endif

				*******************************************************************************

				If !Empty( UDF_Pago )

					If Vartype( oObj ) = "O"
						TEXT To lcCommand NoShow TextMerge Pretext 15
						oObj.<<UDF_Pago>>( 	<<nItems>>,
											<<nVentas>>,
											<<nIva>>,
											<<nPago>>,
											<<nIvaNoInscripto>> )
						ENDTEXT

						&lcCommand
						lcCommand = ""


					Else
						Do &UDF_Pago With nItems, ;
							nVentas, ;
							nIva, ;
							nPago, ;
							nIvaNoInscripto

					Endif



				Endif


				If lDF
					* Cerrar documento fiscal (s¢lo facturas y notas de débito)
					lOk	=  Enviar( CloseFiscalReceipt())

				Else
					* Cerrar documento no fiscal homologado (s¢lo notas de crédito)
					lOk	=  Enviar( CloseDNFH())

				Endif

				Do While .F.
					nKey=S_ALERT("REIMPRESION DEL COMPROBANTE",;
						"[F8]: Reimprime      [Esc]: Continúa",;
						"I_INKEY(F8,ESCAPE,0,0,0,0,0,0,0,0)")
					If nKey=F8
						Reprint()
					Else
						Exit
					Endif
				Enddo
			Endif

		Else
			
			If !Empty( UDF_Pago )
				Store 0 To nItems,;
					nVentas,;
					nIva,;
					nPago,;
					nIvaNoInscripto

				Subtotal( @nItems,;
					@nVentas,;
					@nIva,;
					@nPago,;
					@nIvaNoInscripto,;
					lImprime  )

				If Vartype( oObj ) = "O"
					TEXT To lcCommand NoShow TextMerge Pretext 15
						oObj.<<UDF_Pago>>( 	<<nItems>>,
											<<nVentas>>,
											<<nIva>>,
											<<nPago>>,
											<<nIvaNoInscripto>> )
					ENDTEXT

					&lcCommand
					lcCommand = ""


				Else
					Do &UDF_Pago With nItems, ;
						nVentas, ;
						nIva, ;
						nPago, ;
						nIvaNoInscripto

				Endif

			Endif
		Endif


	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		lOk = .F.

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		oObj = Null
		If !lOk
			Try
				loHasar = NewHasar()
				loHasar.TratarDeCancelarTodo()

			Catch To oErr
				Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

				loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Process( oErr )
				Throw loError

			Finally

			Endtry


		Endif

		loIva 	= Null
		loIvas 	= Null

		loHasar = Null
		loIIBB = Null

		If FileExist( "TraceHasar.log" )
			GetErrors( "Trace Login" )
		Endif

	Endtry

	Return lOk

	*
	*
	*  ************************************************************************************
	*
	*
	*****
	* Funcion: Enviar
	*
	* Envia un comando al impresor fiscal y analiza la respuesta.
	*****


Function Enviar( tcString As String, tcResult As String, tcProgName As String, tnProgLine As Integer )

	Local loHasar As "Hasar.Fiscal.1"
	Local llShowError As Boolean,;
		llLogError As Boolean,;
		llOk As Boolean,;
		llRetry As Boolean

	Local lcCommand As String,;
		lcErrMsg As String,;
		lcMessage As String


	Try

		llOk=.T.
		lcCommand = ""

		If lHasar
			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ") Llamado desde " + Transform( Program( Program(-1)-1 ))

			*StrToFile( "Enviar: " + loHasar.cTraceLogin + CRLF, "PrintLineItem.txt", 1 )

			If Empty( loHasar.cEjecutando )
				loHasar.cEjecutando = Transform( Program( Program(-1)-1 ))
			Endif

			llRetry = .T.

			Do While llRetry

				llRetry = .F.

				Try

					*StrToFile( "Enviando " + tcString + CRLF, "PrintLineItem.txt", 1 )
					loHasar.Enviar( tcString )

				Catch To oErr

					*StrToFile( "Catch del Retry" + loHasar.cEjecutando + CRLF, "PrintLineItem.txt", 1 )
					llRetry = RetryCommand( oErr, loHasar.cEjecutando )

					If !llRetry
						*StrToFile( "llRetry = False. Se dispara el Throw" + CRLF, "PrintLineItem.txt", 1 )
						Throw oErr
					Endif

				Finally

				Endtry

			Enddo

			TEXT To lcCommand NoShow TextMerge Pretext 03
			HuboErrorFiscal: <<loHasar.HuboErrorFiscal>>
			HuboErrorMecanico: <<loHasar.HuboErrorMecanico>>
			HuboFaltaPapel: <<loHasar.HuboFaltaPapel>>
			ENDTEXT

			*StrToFile( lcCommand + CRLF, "PrintLineItem.txt", 1 )

			If loHasar.HuboErrorFiscal Or loHasar.HuboErrorMecanico Or loHasar.HuboFaltaPapel
				llOk = GetErrors( tcString )
			Endif

		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		*StrToFile( "Catch de Enviar()" + CRLF, "PrintLineItem.txt", 1 )

		llOk = .F.
		llShowError = .F.
		llLogError = .T.

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr,;
			llShowError,;
			llLogError )

		Throw loError

	Finally
		If lHasar
			loHasar.cEjecutando = ""
			loHasar = Null
		Endif

	Endtry

	Return llOk





	*
	* Captura errores de comunicacion e intenta repetir el comando
Procedure RetryCommand( oErr As Exception, cEjecutando As String ) As Void;
		HELPSTRING "Captura errores de comunicacion e intenta repetir el comando"

	Local lcCommand As String,;
		lcErrMsg As String,;
		lcProgram As String,;
		lcMessage As String,;
		lcDetails As String,;
		lcAppName As String,;
		lcHelpFile As String,;
		lcHelpId As String,;
		lcOLEExcNo As String,;
		lcEjecutando As String


	Local llRetry As Boolean

	Local loHasar As "Hasar.Fiscal.1"

	Local Array laError(1)

	Try

		lcCommand = ""
		If Empty( cEjecutando )
			cEjecutando = ""
		Endif

		llRetry = .F.

		Do Case
			Case Inlist( oErr.ErrorNo, 1429 )

				lcEjecutando = cEjecutando

				Aerror( laError )

				lcMessage 	= IfEmpty( laError[1,2], "" )
				lcDetails 	= IfEmpty( laError[1,3], "" )
				lcAppName 	= IfEmpty( laError[1,4], "" )
				lcHelpFile	= IfEmpty( laError[1,5], "" )
				lcHelpId 	= IfEmpty( laError[1,6], "" )
				lcOLEExcNo 	= IfEmpty( laError[1,7], "" )

				TEXT To lcErrMsg NoShow TextMerge Pretext 03
				Error de comunicación con el Controlador Fiscal

				La aplicación <<lcAppName>> informa:

				* Proceso:
				<<lcEjecutando>>

				* Error:
				<<lcDetails>>

				¿Reintenta Ejecutar el Proceso?

				______________________________________________________________

				- Si responde NO es muy probable que el comprobante que
				se está ejecutando no se grabe correctamente -

				- Si éste error se repite, verifique el estado de los cables y
				el correcto funcionamiento de los puertos de comunicación -
				ENDTEXT

				llRetry = Confirm( lcErrMsg, "Error de comunicación", .T., MB_ICONEXCLAMATION )

				If !llRetry

					Try

						TEXT To lcCommand NoShow TextMerge Pretext 03
						El usuario canceló el reintento
						de ejecutar el proceso que generó el error
						ENDTEXT

						lcErrorMsg = lcCommand

						Try

							loHasar = NewHasar()

							lcErrorMsg = lcErrorMsg + Replicate( '-', 40 ) + CRLF
							lcErrorMsg = lcErrorMsg + "Modelo: " + Alltrim( Transform( loHasar.cModelo )) + " ( " + Transform( loHasar.nModelo ) + " )" + CRLF
							lcErrorMsg = lcErrorMsg + "Punto de Venta: " + Transform( loHasar.nPuntoDeVenta ) + CRLF
							lcErrorMsg = lcErrorMsg + "Trace: " + loHasar.cTraceLogin + CRLF
							lcErrorMsg = lcErrorMsg + "Remark: " + loHasar.cRemark + CRLF
							lcErrorMsg = lcErrorMsg + "Ejecutando: " + loHasar.cEjecutando + CRLF

							lcErrorMsg = lcErrorMsg + VolcarDatos( loHasar.oCliente )
							lcErrorMsg = lcErrorMsg + VolcarDatos( loHasar.oComprobante )


						Catch To oErr

						Finally
							loHasar = Null

						Endtry

						Error lcErrorMsg


					Catch To oErr
						Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

						loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )

						llShowError = .F.
						llLogError = .T.

						loError.Remark = lcErrMsg
						loError.Process( oErr,;
							llShowError,;
							llLogError )

					Finally


					Endtry

				Endif

			Otherwise
				llRetry = .F.

		Endcase


	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Remark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null

	Endtry

	Return llRetry

Endproc && RetryCommand

****
* FUNCTION GetErrors
*
* Esta funcion levanta la respuesta del printer e imprime en
* el mensaje de error si es que existe.
****


Function GetErrors( tcString As String )

	Local llOk As Boolean
	Local loHasar As "Hasar.Fiscal.1"
	Local lnPrinterStatus As String
	Local lnFiscalStatus As String
	Local i As Integer
	Local lcErrorMessage As String,;
		lcErrorMsg As String
	Local lcStackInfo As String

	Local lTraceLogin As Boolean



	Try

		llOk = .T.
		lTraceLogin = .F.

		lcErrorMessage	= ""
		lcErrorMsg 		= ""
		lcStackInfo 	= GetStackInformation()

		If lHasar

			loHasar = NewHasar()

			lnPrinterStatus = HexaToInt( loHasar.Respuesta( 1 ) )
			lnFiscalStatus 	= HexaToInt( loHasar.Respuesta( 2 ) )


			For i = 1 To 16
				If Bittest( lnFiscalStatus, i - 1 )
					If !Inlist( i, 10, 11, 13, 14, 15, 16 )
						lcErrorMessage = lcErrorMessage + loHasar.FiscalErrors.Item[ i ] + CR
						llOk = .F.
					Endif
				Endif
			Endfor

			If !Empty( lcErrorMessage )
				lcErrorMsg = lcErrorMsg + Replicate( '-', 40 ) + CRLF
				lcErrorMsg = lcErrorMsg + Transform( Datetime() ) + CRLF
				lcErrorMsg = lcErrorMsg + "Modelo: " + Alltrim( Transform( loHasar.cModelo )) + " ( " + Transform( loHasar.nModelo ) + " )" + CRLF
				lcErrorMsg = lcErrorMsg + "Punto de Venta: " + Transform( loHasar.nPuntoDeVenta ) + CRLF
				lcErrorMsg = lcErrorMsg + "Comando Ejecutado: " + Transform( tcString ) + CRLF
				lcErrorMsg = lcErrorMsg + "Mensaje: " + lcErrorMessage + CRLF
				lcErrorMsg = lcErrorMsg + "Stack: " + lcStackInfo + CRLF
				lcErrorMsg = lcErrorMsg + "Trace: " + loHasar.cTraceLogin + CRLF
				lcErrorMsg = lcErrorMsg + "Remark: " + loHasar.cRemark + CRLF
				lcErrorMsg = lcErrorMsg + "Ejecutando: " + loHasar.cEjecutando + CRLF

				lTraceLogin = .T.

				lcErrorMsg = lcErrorMsg + VolcarDatos( loHasar.oCliente )
				lcErrorMsg = lcErrorMsg + VolcarDatos( loHasar.oComprobante )

				Strtofile( lcErrorMsg, "ErrorHasar.Txt", 1 )

				* Intentar grabar el ErrorLog.txt en el servidor, para poder acceder más facilmenmte
				If Vartype( DRVA ) = "C"
					Strtofile( lcErrorMsg, Addbs(Alltrim(DRVA))+"ErrorHasar.Txt", 1 )
					Strtofile( lcErrorMsg, Addbs(Alltrim(DRVA))+"ErrorLog.txt", 1 )
				Endif

				Messagebox( lcErrorMessage, 64, "ERROR DE ESTADO FISCAL" )
			Endif

			lcErrorMessage = ""

			For i = 1 To 16
				If Bittest( lnPrinterStatus, i - 1 )
					If Inlist( i, 3, 4, 5, 6, 7 )
						lcErrorMessage = lcErrorMessage + loHasar.PrinterErrors.Item[ i ] + CR
						llOk = .F.
					Endif
				Endif
			Endfor

			If !Empty( lcErrorMessage )
				lcErrorMsg = lcErrorMsg + Replicate( '-', 40 ) + CRLF
				lcErrorMsg = lcErrorMsg + Transform( Datetime() ) + CRLF
				lcErrorMsg = lcErrorMsg + "Modelo: " + Alltrim( Transform( loHasar.cModelo )) + " ( " + Transform( loHasar.nModelo ) + " )" + CRLF
				lcErrorMsg = lcErrorMsg + "Punto de Venta: " + Transform( loHasar.nPuntoDeVenta ) + CRLF
				lcErrorMsg = lcErrorMsg + "Comando Ejecutado: " + Transform( tcString ) + CRLF
				lcErrorMsg = lcErrorMsg + "Mensaje: " + lcErrorMessage + CRLF
				lcErrorMsg = lcErrorMsg + "Stack: " + lcStackInfo + CRLF

				If !lTraceLogin
					lcErrorMsg = lcErrorMsg + "Trace: " + loHasar.cTraceLogin + CRLF
					lcErrorMsg = lcErrorMsg + "Remark: " + loHasar.cRemark + CRLF
					lcErrorMsg = lcErrorMsg + "Ejecutando: " + loHasar.cEjecutando + CRLF

					lTraceLogin = .T.
				Endif

				lcErrorMsg = lcErrorMsg + VolcarDatos( loHasar.oCliente )
				lcErrorMsg = lcErrorMsg + VolcarDatos( loHasar.oComprobante )

				Strtofile( lcErrorMsg, "ErrorHasar.Txt", 1 )

				* Intentar grabar el ErrorLog.txt en el servidor, para poder acceder más facilmenmte
				If Vartype( DRVA ) = "C"
					Strtofile( lcErrorMsg, Addbs(Alltrim(DRVA))+"ErrorHasar.Txt", 1 )
					Strtofile( lcErrorMsg, Addbs(Alltrim(DRVA))+"ErrorLog.txt", 1 )
				Endif

				Messagebox( lcErrorMessage, 64, "ERROR DE ESTADO FISCAL" )
			Endif

		Else
			loHasar = NewHasar()
			lcErrorMsg = lcErrorMsg + Replicate( '-', 40 ) + CRLF
			lcErrorMsg = lcErrorMsg + Transform( Datetime() ) + CRLF
			lcErrorMsg = lcErrorMsg + "Modelo: " + Alltrim( Transform( loHasar.cModelo )) + " ( " + Transform( loHasar.nModelo ) + " )" + CRLF
			lcErrorMsg = lcErrorMsg + "Punto de Venta: " + Transform( loHasar.nPuntoDeVenta ) + CRLF
			lcErrorMsg = lcErrorMsg + "Comando Ejecutado: " + Transform( tcString ) + CRLF
			lcErrorMsg = lcErrorMsg + "Este es el mensaje de error." + CRLF
			lcErrorMsg = lcErrorMsg + "Stack: " + lcStackInfo + CRLF

			lcErrorMsg = lcErrorMsg + "Trace: " + loHasar.cTraceLogin + CRLF
			lcErrorMsg = lcErrorMsg + "Remark: " + loHasar.cRemark + CRLF
			lcErrorMsg = lcErrorMsg + "Ejecutando: " + loHasar.cEjecutando + CRLF

			lcErrorMsg = lcErrorMsg + VolcarDatos( loHasar.oCliente )
			lcErrorMsg = lcErrorMsg + VolcarDatos( loHasar.oComprobante )


			Strtofile( lcErrorMsg, "ErrorHasar.Txt", 1 )

			* Intentar grabar el ErrorLog.txt en el servidor, para poder acceder más facilmenmte
			If Vartype( DRVA ) = "C"
				Strtofile( lcErrorMsg, Addbs(Alltrim(DRVA))+"ErrorHasar.Txt", 1 )
				Strtofile( lcErrorMsg, Addbs(Alltrim(DRVA))+"ErrorLog.txt", 1 )
			Endif

		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		llOk = .F.

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )

	Finally
		loHasar = Null

	Endtry

	Return llOk



	*
	*
Procedure VolcarDatos( oObj As Object ) As String
	Local lcCommand As String
	Local lcStr As String,;
		lcProperty As String
	Local Array laProperties[ 1 ]

	Try

		lcCommand = ""
		lcStr = ""
		Amembers( laProperties, oObj )

		For Each lcProperty In laProperties
			lcStr = lcStr +  lcProperty + ": " + Transform( Evaluate( "oObj." + lcProperty  )) + CRLF
		Endfor

	Catch To oErr

	Finally

	Endtry

	Return lcStr

Endproc && VolcarDatos


*!*		****
*!*		* FUNCTION HexaToInt
*!*		*
*!*		* Esta funcion convierte un numero hexadecimal en su equivalente
*!*		* en binario.
*!*		****

Function HexaToInt

	Lparameters HexValue

	Local i As Integer
	Local s As Character
	Local lnStatus As Integer
	Local lnValue As Integer

	Try

		lnStatus = 0

		For i = 4 To 1 Step -1

			s = Substr(HexValue, i, 1)

			lnValue = Asc (s)

			Do Case
				Case ( lnValue >= Asc("A") .And. lnValue <= Asc("F") )

					lnValue = lnValue - Asc("A") + 10

				Case ( lnValue >= Asc("a") .And. lnValue <= Asc("f") )

					lnValue = lnValue - Asc("a") + 10

				Case ( lnValue >= Asc("0") .And. lnValue <= Asc("9") )

					lnValue = lnValue - Asc("0")

				Otherwise
					Error "ERROR AL VERIFICAR RESPUESTA DEL IMPRESOR" + CR + "HexValue: " + Transform( HexValue )

			Endcase

			lnStatus = lnStatus + lnValue * (16 ** ( 4 - i ))

		Next

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		lnStatus = -1

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )


	Finally

	Endtry

	Return lnStatus


	*  3.7.1. Cancel - Cancelaci¢n
	*
	*  Sintaxis:
	*		   Cancel()
	*
	*
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde cancelando el documento abierto. Se aplica a los siguientes
	*  documentos:
	*  Documentos fiscales: Factura, Nota de débito, Recibo oficial
	*  Documentos no fiscales homologados: Nota de crédito, Recibo X, Remito, Orden
	*  de salida, Resumen de cuenta, Cargo a la habitaci¢n, Cotizaci¢n
	*  Documentos no fiscales
	*
	*  Este comando es rechazado si:
	*  a. No se encuentra abierto un documento;
	*  b. Se encuentra abierto una factura, una nota de débito o una nota de crédito y ya
	*  se ha efectuado un pago (parcial o total)
	*
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   ˜ (ASCII 152)
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   ˜ (ASCII 152)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H
	*
	*

Function Cancel
	Priv sComando

	sComando =	Chr( 152 )

	Return sComando

	*************************************************************************************
	*  3.7.2. Reprint - Reimpresi¢n del último documento emitido
	*  Chequea el estado de la memoria de trabajo, y verifica si se puede ejecutar el
	*  comando en el estado fiscal en que se encuentra.
	*  Responde imprimiendo una copia del último documento emitido. Se aplica a los
	*  siguientes documentos:
	*   Documentos fiscales: Factura, Nota de débito, Recibo oficial, Reporte Z
	*   Documentos no fiscales homologados: Reporte X, Nota de crédito, Recibo X,
	*  Remito, Orden de salida, Resumen de cuenta, Cargo a la habitaci¢n,
	*  Cotizaci¢n
	*   Documentos no fiscales
	*  A su vez, los documentos se dividen en dos grupos de acuerdo con la cantidad
	*  m xima de copias que se puen emitir:
	*   Documentos con número limitado de copias (puede emitirse hasta la cantidad
	*  m xima de copias programada en los comandos de configuraci¢n): Facturas,
	*  Notas de débito, Recibos oficial y X, Nota de crédito, Remito.
	*   Documentos con número ilimitado de copias (puede emitirse la cantidad de
	*  copias que se desee): Reportes Z y X, Reporte de auditor¡a, Orden de salida,
	*  Resumen de cuenta, Cargo a la habitaci¢n, Cotizaci¢n, Documentos no
	*  fiscales.
	*
	*  Este comando es rechazado si:
	*  a. Se ha emitido otro comando luego de haberse impreso el documento original.
	*  b. Aún no se ha emitido ningún documento luego de inicializarse o resetearse la
	*  impresora por hard (MAC).
	*  Nota: este comando debe emitirse inmediatamente despúés del documento original
	*  y no se aplica a los reportes de auditor¡a
	*
	*
	*  Comando
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   ™ (ASCII 153)
	*
	*
	*  Respuesta
	*  Longitud    Descripci¢n																   Tipo
	*	   1	   ™ (ASCII 153)
	*	   1	   FS
	*	   4	   Status de la impresora												   H
	*	   1	   FS
	*	   4	   Status fiscal																   H
	*

Function Reprint
	Priv sComando,Ret

	sComando =	Chr( 153 )
	Ret=""

	Return Enviar( sComando )

	*************************************************************************************

	*  FUNCTION IF4DOC
	*
	*
	*  4. Documentos
	*  Los comandos disponible para cada tipo de documento son los siguientes:
	*
	*  4.1. Facturas, Notas de débito y Notas de crédito
	*
	*  SetCustomerData()
	*   Cargar datos comprador (previo a la apertura del documento)
	*
	*  SetEmbarkNumber()
	*   Cargar números documento original asociados (obligatorio en notas de crédito -
	*	 previo a la apertura del documento)
	*   Cargar informaci¢n números de remitos (en facturas y notas de débito - previo a la
	*	 apertura del documento)
	*
	*  OpenFiscalReceipt()
	*   Abrir documento fiscal (s¢lo facturas y notas de débito)
	*
	*  OpenDNFH()
	*   Abrir documento no fiscal homologado (s¢lo notas de crédito)
	*
	*  PrintFiscalText()
	*   Imprimir texto fiscal
	*
	*  PrintLineItem()
	*   Vender item
	*
	*  LastItemDiscount()
	*   Descuento / recargo último item vendido
	*
	*  GeneralDiscount()
	*   Bonificaci¢n / recargo general - Devoluci¢n de envases
	*
	*  Perceptions()
	*   Percepciones (s¢lo documentos A y B)
	*
	*  ChargeNonRegisteredTax()
	*   Cargar IVA no inscripto (s¢lo documentos A a Responsable no inscripto)
	*
	*  Subtotal()
	*   Subtotal
	*
	*  BarCode()
	*   Cargar c¢digo de barras
	*
	*  TotalTender()
	*   Pagar
	*
	*  CloseFiscalReceipt()
	*   Cerrar documento fiscal (s¢lo facturas y notas de débito)
	*
	*  CloseDNFH()
	*   Cerrar documento no fiscal homologado (s¢lo notas de crédito)

	Note: Impresion de Documentos en Impresora Fiscal

	* Descripcion de parametros

	* IF4PR1: Numero de programa

	* Descripcion de rutinas externas

	* PA: Pantalla
	* PE: Pedido de datos
	* RE: Muestro el registro

	* Descripcion de variables y vectores

	* R7OPC: Contiene la opcion del modulo de actualizacion y consulta
	* R7FIL: Indica el numero de fila donde me encuentro en la matriz
	* R7LIN: Indica el numero de linea en el cual me encuentro en pantalla
	* R7ING: Indica si continua ingresando datos
	* R7TIP: 1: alta, 2: Modificacion
	* R7REN: Contiene el numero de renglon a mostrar
	* R7PAR: Cantidad de parametros
	* R7MSG: Mensaje en linea 23
	* R7POS: Opciones posibles
	* R7REC: Numero de registro

	******************************************************

Function GetNumero
	* Devuelve el último número emitido
	Lparameters  tnComp, tcTipo
	Local loHasar As "Hasar.Fiscal.1"
	Local i As Integer
	Local lnNumero As Integer
	Local lcAlias As String,;
		lcMsg As String
	Local lnSucu As Integer
	Local llNoSoportado As Boolean

	Try

		lnNumero = -1
		llNoSoportado = .F.
		lcAlias = Alias()

		If lHasar

			loHasar = NewHasar()
			loHasar.cTraceLogin = Transform( Program() )+ " (" + Transform( Lineno() ) + ")"
			loHasar.cEjecutando = "Obtener último número emitido"

			lnSucu = loHasar.nPuntoDeVenta

			*!*		StatusImpresora 			= loHasar.Respuesta( 1 )
			*!*		StatusFiscal 				= loHasar.Respuesta( 2 )
			*!*		lnUltimoDocumentoFiscalBCT 	= loHasar.Respuesta( 3 )
			*!*		StatusAuxiliar 				= loHasar.Respuesta( 4 )
			*!*		lnUltimoDocumentoFiscalA  	= loHasar.Respuesta( 5 )
			*!*		StatusDocumento 			= loHasar.Respuesta( 6 )
			*!*		lnUltimaNotaCreditoBC 		= loHasar.Respuesta( 7 )
			*!*		lnUltimaNotaCreditoA 		= loHasar.Respuesta( 8 )
			*!*		lnUltimoRemito 				= loHasar.Respuesta( 9 )

			*!*				tnComp	 =	IfEmpty( tnComp, 1 )
			*!*				tcTipo	 =	IfEmpty( tcTipo, "B"  )

			i = 0

			If tcTipo = "R"
				i = 9

			Else

				If tnComp = COMP_NCREDITO
					Do Case
						Case tcTipo = "A"
							i = 8

						Case tcTipo = "B"
							i = 7

						Case tcTipo = "C"
							i = 7

						Case tcTipo = "T"
							i = 7

						Otherwise
							Error "Comprobante No Soportado: " + Transform( tcTipo ) + Transform( tnComp )


					Endcase

				Else

					Do Case
						Case tcTipo = "A"
							i = 5

						Case tcTipo = "B"
							i = 3

						Case tcTipo = "C"
							i = 3

						Case tcTipo = "T"
							i = 3

						Otherwise
							Error "Comprobante No Soportado: " + Transform( tcTipo ) + Transform( tnComp )

					Endcase

				Endif

			Endif

			llRetry = .T.

			Do While llRetry

				llRetry = .F.

				Try

					loHasar.PedidoDeStatus()

				Catch To oErr

					llRetry = RetryCommand( oErr )

					If !llRetry
						Throw oErr
					Endif

				Finally

				Endtry

			Enddo

			lnNumero = Val( loHasar.Respuesta( i ) )

		Else
			If Used( "ar7Ven" )
				Select ar7Ven
				Set Orde To 1
				Set Near On

				If Vartype( WSUCU ) = "N"
					lnSucu = WSUCU

				Else
					lnSucu = GetValue( "Sucu0", "ar0Est", 1 )

				Endif

				Seek Str( tnComp, 2 ) + tcTipo + Str( lnSucu, 2 ) + Str( 999999, 6 )
				Set Near Off
				Skip -1
				lnNumero = NUME7

			Endif

		Endif


		* RA 2013-04-28(16:01:01)
		* Verificar que el último comprobante quedó registrado

		If .F. && Used( "ar7Ven" ) And lnNumero > 0

			Select ar7Ven
			Go Bottom
			* INDEXSEEK( ) returns false (.F.) when you are attempting to find a value
			* in the most recently created record (created with INSERT INTO or APPEND BLANK)
			* until the record pointer is moved. You can execute a GO BOTTOM command
			* to cause INDEXSEEK( ) to find the most recently created record.

			If !Indexseek( Str( tnComp, 2 ) + tcTipo + Str( lnSucu, 2 ) + Str( lnNumero, 6 ), .F., "ar7Ven", 1 )
				TEXT To lcMsg NoShow TextMerge Pretext 03
				Atencion

				El Comprobante Número <<lnNumero>>
				no quedó registrado
				ENDTEXT

				Warning( lcMsg )
			Endif

		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally
		loHasar = Null
		If Used( lcAlias )
			Select Alias( lcAlias )
		Endif

	Endtry

	Return lnNumero

	*
	* Devuelve el numero a travez de metodos del OCX
Procedure ObtenerNumero() As Integer ;
		HELPSTRING "Devuelve el numero a travez de metodos del OCX"
	Local lcCommand As String
	Local loHasar As "Hasar.Fiscal.1"
	Local lnNumero As Integer

	Try

		lcCommand = ""
		lnNumero = 0
		loHasar = NewHasar()
		lnNumero = loHasar.PrimerNumeroDeDocumentoActual()

	Catch To loErr
		*!*			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		*!*			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		*!*			loError.cRemark = lcCommand
		*!*			loError.Process ( m.loErr )
		*!*			Throw loError

		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( loErr )
		Throw loError


	Finally
		loHasar = Null

	Endtry

	Return lnNumero

Endproc && ObtenerNumero


Note: Comprobantes originales que generaron la Nota de Credito

Proc COMPORIG
	Para WN1,WN2
	Priv WPANT
	*!*		WPANT=SAVESCREEN(10,00,13,79)
	S_CLEAR(10,20,14,60)
	@ 10,20 To 14,60
	@ 11,21 Say "Facturas originales:"
	Do While !&ABORTA
		@ 11,42 Get WN1 Pict "@Z 99999999" Valid I_VALMOI(WN1,0)
		Read
		If !Empty(WN1)
			@ 12,42 Get WN2 Pict "@Z 99999999" Valid VACOMPORIG()
			Read
		Else
			WN2=0
		Endif
		If V_CONFIR()
			Exit
		Endif
	Enddo
	*!*		RESTSCREEN(10,00,13,79,WPANT)
	S_CLEAR(10,20,14,60)
	Retu

Func VACOMPORIG
	If Empty(WN2)
		Retu I_VALMOI(WN2,0)
	Else
		Retu I_VALMAY(WN2,WN1)
	Endif



	*!*		****************************************
	*!*	Proc Logerror
	*!*		Para ErrMsg1,ErrMsg2,ErrMsg3,ErrMsg4
	*!*		Priv nHandle,FR

	*!*		ErrMsg1    =  IfEmpty( ErrMsg1, ""   )
	*!*		ErrMsg2    =  IfEmpty( ErrMsg2, ""   )
	*!*		ErrMsg3    =  IfEmpty( ErrMsg3, ""   )
	*!*		ErrMsg4    =  IfEmpty( ErrMsg4, ""   )

	*!*		FR=Chr(13)+Chr(10)	&& Marca de Fin de Registro (h0D0A)

	*!*		nHandle=Fopen("HASAR.LOG",2)
	*!*		If nHandle<0
	*!*			nHandle=Fcreate("HASAR.LOG")
	*!*		Endif
	*!*		If nHandle>=0
	*!*			Fseek(nHandle,0,2)
	*!*			Fwrite(nHandle,Replicate("-",50)+FR)
	*!*			Set Cent On
	*!*			Fwrite(nHandle,P_USER+" - "+Dtoc(Date())+" - "+Time()+FR)
	*!*			Set Cent Off

	*!*			If !Empty(ErrMsg1)
	*!*				Fwrite(nHandle,ErrMsg1+FR)
	*!*			Endif
	*!*			If !Empty(ErrMsg2)
	*!*				Fwrite(nHandle,ErrMsg2+FR)
	*!*			Endif
	*!*			If !Empty(ErrMsg3)
	*!*				Fwrite(nHandle,ErrMsg3+FR)
	*!*			Endif
	*!*			If !Empty(ErrMsg4)
	*!*				Fwrite(nHandle,ErrMsg4+FR)
	*!*			Endif


	*!*			Fclose(nHandle)
	*!*		Endif

	*!*		Retu

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetStackInformation
	*!* Description...: Obtiene un string parseado con toda la información del stack
	*!* Date..........: Miércoles 19 de Enero de 2005 (15:55:02)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Visual Praxis Beta 1.0
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

Procedure GetStackInformation( ) As Void ;
		HELPSTRING "Obtiene un string parseado con toda la información del stack"

	Local laStackInfo(1) As String,;
		lnRow As Integer,;
		lnLen As Integer,;
		lcStackInfo As String

	lcStackInfo = ""

	Astackinfo( laStackInfo )

	lnLen = Alen( laStackInfo, 1 )

	lnRow = lnLen - 3

	*	For lnRow = lnLen - 3 To 1 Step -1
	Try

		lcStackInfo = lcStackInfo + Any2Char(lnRow)+ ") "
		lcStackInfo = lcStackInfo + "[Módulo] " + ProperCase( Program( lnRow ), "." )

		lcStackInfo = lcStackInfo + "  [Línea] " + Any2Char(laStackInfo[lnRow, 5])
		lcStackInfo = lcStackInfo + "  [Contenido] " + Strtran( laStackInfo[lnRow, 6], Tab, "" ) + CR

	Catch To oErr

	Finally

	Endtry

	*	Endfor

	Return lcStackInfo


Endproc && GetStackInformation