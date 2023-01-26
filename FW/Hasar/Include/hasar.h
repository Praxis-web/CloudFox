* Modelos de Impresora
#define MODELO_614			1
#define MODELO_615			2
#define MODELO_PR4			3
#define MODELO_950			4
#define MODELO_951			5
#define MODELO_262			6
#define MODELO_PJ20			7
#define MODELO_P320			8
#define MODELO_715			9
#define MODELO_PR5			10		
#define MODELO_272			11
#define MODELO_PPL8			12
#define MODELO_P321			13
#define MODELO_P322			14
#define MODELO_P425			15
#define MODELO_P425_201		16
#define MODELO_PPL8_201		17
#define MODELO_P322_201		18
#define MODELO_P330			19
#define MODELO_P435			20
#define MODELO_P330_201		21
#define MODELO_PPL9			22
#define MODELO_P330_202		23
#define MODELO_P435_101		24
#define MODELO_715_201		25
#define MODELO_PR5_201		26
#define MODELO_P435_102		27
#define MODELO_PPL23		28
#define MODELO_715_302		29
#define MODELO_715_403		30
#define MODELO_P330_203		31
#define MODELO_P441			32	
#define MODELO_PPL23_101	33
#define MODELO_P435_203		34
#define MODELO_P1120		35


* Tipos de Documento para Clientes
#define TIPO_NINGUNO 		32
#define TIPO_LE 			48 
#define TIPO_LC 			49 
#define TIPO_DNI 			50 
#define TIPO_PASAPORTE 		51 
#define TIPO_CI 			52 
#define TIPO_CUIT 			67 
#define TIPO_CUIL 			76

* Tipos de Responsabilidad IVA del Cliente
#define NO_RESPONSABLE 				65 
#define BIENES_DE_USO 				66 
#define CONSUMIDOR_FINAL 			67 
#define RESPONSABLE_EXENTO 			69 
#define RESPONSABLE_INSCRIPTO 		73 
#define MONOTRIBUTO 				77 
#define RESPONSABLE_NO_INSCRIPTO	78 
#define MONOTRIBUTO_SOCIAL  		83 
#define NO_CATEGORIZADO 			84 
#define EVENTUAL  					86 
#define EVENTUAL_SOCIAL  			87 


* Tipos de Responsabilidad IVA del Controlador
#define CLASE_RESPONSABLE_INSCRIPTO 	73
#define CLASE_RESPONSABLE_NO_INSCRIPTO 	78
#define CLASE_RESPONSABLE_EXENTO 		69
#define CLASE_NO_RESPONSABLE 			65
#define CLASE_MONOTRIBUTO 				77


* Tipos de Documentos Fiscales
#define TICKET_C 			84
#define TICKET_FACTURA_A 	65
#define TICKET_FACTURA_B 	66
#define FACTURA_A 			48
#define FACTURA_B 			49
#define RECIBO_A 			97
#define RECIBO_B 			98
#define NOTA_DEBITO_A 		68
#define NOTA_DEBITO_B 		69


* Tipos de Documentos No-Fiscales
#define NOTA_CREDITO_A 		82
#define NOTA_CREDITO_B 		83
#define REMITO 				114
#define ORDEN_SALIDA 		115
#define RESUMEN_CUENTA 		116
#define CARGO_HABITACION 	85
#define COTIZACION 			117
#define RECIBO_X 			120


* Tipos de display
#define LINEA_SUPERIOR = 76
#define LINEA_INFERIOR = 75
#define SECCION_DE_REPETICION = 78

* Tipos de Papel
#define PAPEL_TICKET 			0
#define PAPEL_DIARIO 			1
#define PAPEL_TICKET_Y_DIARIO 	2

* Tipos de Códigos de Barra
#define CODIGO_TIPO_EAN_13 	49
#define CODIGO_TIPO_EAN_8 	50
#define CODIGO_TIPO_UPCA 	51
#define CODIGO_TIPO_ITS 	52

* Tipos de vouchers
#define VOUCHER_DE_COMPRA 					67
#define VOUCHER_DE_CANCELACION_COMPRA 		86
#define VOUCHER_DE_DEVOLUCION 				68
#define VOUCHER_DE_CANCELACION_DEVOLUCION 	65


* Tipos de Tarjetas para vouchers
#define TARJETA_CREDITO 	67
#define TARJETA_DEBITO 		68

* Tipo de ingreso de tarjetas para vouchers
#define INGRESO_DE_TARJETA_MANUAL 			42
#define INGRESO_DE_TARJETA_AUTOMATIZADO 	32

* Tipo de operación de tarjeta
#define OPERACION_TARJETA_ONLINE 	78
#define OPERACION_TARJETA_OFFLINE 	70

* Tipos de Devoluciones
#define DESCUENTO_RECARGO 		66
#define DEVOLUCION_DE_ENVASES 	69

* Parámentros de configuración
#define IMPRESION_CAMBIO 		52
#define IMPRESION_LEYENDAS 		53
#define CORTE_PAPEL 			54
#define IMPRESION_MARCO 		55
#define REIMPRESION_CANCELADOS 	56
#define COPIAS_DOCUMENTOS 		57
#define PAGO_SALDO 				58
#define SONIDO 					59

* Número de Copias de Documentos
#define NO_COPIAS 		48
#define ORIGINAL 		49
#define DUPLICADO 		50
#define TRIPLICADO 		51
#define CUADRUPLICADO 	52

* Tipos de Corte de Papel
#define CORTE_TOTAL 	70
#define CORTE_PARCIAL 	80
#define NO_CORTE 		78

* Bits de estado del controlador
#define F_FISCAL_MEMORY_FAIL 			1
#define F_WORKING_MEMORY_FAIL 			2
#define F_ALWAYS_ZERO 					4
#define F_UNRECOGNIZED_COMMAND 			8
#define F_INVALID_FIELD_DATA 			16
#define F_INVALID_COMMAND 				32
#define F_TOTAL_OVERFLOW 				64
#define F_FISCAL_MEMORY_FULL 			128
#define F_FISCAL_MEMORY_NEAR_FULL 		256
#define F_FISCAL_TERMINAL_CERTIFIED 	512
#define F_FISCAL_TERMINAL_FISCALIZED 	1024
#define F_DATE_SET_FAIL 				2048
#define F_RECEIPT_SLIP_OPEN 			4096
#define F_RECEIPT_OPEN 					8192
#define F_INVOICE_OPEN 					16384
#define F_LOGIC_OR_0_8 					32768

* Bits de estado del controlador
#define P_ALWAYS_ZERO_1 		1
#define P_ALWAYS_ZERO_2 		2
#define P_PRINTER_ERROR 		4
#define P_OFFLINE 				8
#define P_JOURNAL_PAPER_LOW 	16
#define P_RECEIPT_PAPER_LOW 	32
#define P_BUFFER_FULL 			64
#define P_BUFFER_EMPTY 			128
#define P_SLIP_PLATEN_OPEN 		256
#define P_ALWAYS_ZERO_3 		512
#define P_ALWAYS_ZERO_4 		1024
#define P_ALWAYS_ZERO_5 		2048
#define P_ALWAYS_ZERO_6 		4096
#define P_ALWAYS_ZERO_7 		8192
#define P_DRAWER_CLOSED 		16384
#define P_LOGIC_OR_2_3_4_5_8_14 32768

* Bits de estado del controlador
#define S_NONFORMATTED_MEMORY 		0
#define S_NONINITIALIZED_MEMORY 	1
#define S_RECEIPT_NOT_OPENED 		2
#define S_FISCAL_RECEIPT_OPENED 	3
#define S_FISCAL_TEXT_ISSUED 		4
#define S_NONFISCAL_RECEIPT_OPENED 	5
#define S_TENDER 					6
#define S_TENDER_CLEARED 			7
#define S_PERCEPTION 				8
#define S_KILLED 					9
#define S_RETURN_RECHARGE 			10
#define S_DISCOUNT_CHARGE 			11
#define S_RECEIPT_CONCEPT 			12
#define S_CREDIT_NOTE 				13
#define S_CREDIT_NOTE_DISCOUNT 		14
#define S_CREDIT_NOTE_RETURN 		15
#define S_CREDIT_NOTE_PERCEPTION 	16
#define S_CREDIT_NOTE_TEXT 			17
#define S_INTERNAL_USE_RECEIPT 		18
#define S_QUOTATION 				19
#define S_EMBARK 					20
#define S_ACCOUNT 					21
#define S_BLOCKED 					22
#define S_NONE 						255

* Errores Fiscales
#define H_ERR_GENERIC 			-2147220991
#define H_ERR_HANDLER 			-2147220990
#define H_ERR_ATOMIC 			-2147220989
#define H_ERR_TIMEOUT 			-2147220988
#define H_ERR_ALREADYOPEN 		-2147220987
#define H_ERR_NOMEM 			-2147220986
#define H_ERR_NOTOPENYET 		-2147220985
#define H_ERR_INVALIDPTR 		-2147220984
#define H_ERR_STATPRN 			-2147220983
#define H_ERR_ABORT 			-2147220982
#define H_ERR_FIELD_NOT_FOUND 	-2147220942
#define H_ERR_INVALID_BUFFER 	-2147220941
#define H_ERR_INVALID_BIT 		-2147220940
#define H_ERR_PRINTER_NOT_FOUND -2147220939
#define H_ERR_NOT_SUPPORTED 	-2147220938
#define H_ERR_NOT_OPENED 		-2147220937
#define H_ERR_INVALID_PORT 		-2147220936
#define H_ERR_FILENAME 			-2147220935
#define H_ERR_FIELD_OPTIONAL 	-2147220934
#define H_ERR_FIELD_INVALID 	-2147220933


* Memoria de Trabajo
#define W_ULTIMO_Z			20


