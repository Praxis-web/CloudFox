* Definiciones para el módulo Factura Electrónica

#Define FE_PRUEBA		0
#Define FE_PRODUCCION	1

* Codigos Conceptos
#Define FE_PRODUCTOS				1
#Define FE_SERVICIOS				2
#Define FE_PRODUCTOS_Y_SERVICIOS	3

* Codigos Documentos
#Define FE_CUIT				80
#Define FE_CUIL				86
#Define FE_DNI				96
#Define FE_OTRO_DOCUMENTO	99
#Define FE_PASAPORTE		94
#Define FE_EXTRANJERA		91
#Define FE_LE				89
#Define FE_LC				90
#Define FE_EN_TRAMITE		92
#Define FE_MIGRACION		30
#Define FE_CBU_EMISOR		2101	
#Define FE_ALIAS_EMISOR		2102
#Define FE_ANULACION		22	
#Define FE_REFERENCIA		23	
#Define FE_SCA_ADC			27

* Codigos Iva
#Define FE_Iva_Cero			3
#Define FE_Iva_Reducido		4
#Define FE_Iva_Normal		5
#Define FE_Iva_Diferenciado	6

* Codigos Tributos
#Define FE_Tributo_Nacional		1	
#Define FE_Tributo_Provincial   2	
#Define FE_Tributo_Municipal    3	
#Define FE_Tributo_Internos     4	
#Define FE_Tributo_Otro        	99	

*	Codigo de Comprobantes
#Define FE_Factura_A						1
#Define FE_Nota_de_Debito_A					2
#Define FE_Nota_de_Credito_A				3
#Define FE_Factura_B						6
#Define FE_Nota_de_Debito_B					7
#Define FE_Nota_de_Credito_B				8
#Define FE_Recibos_A						4
#Define FE_Notas_de_Venta_al_contado_A		5
#Define FE_Recibos_B						9
#Define FE_Notas_de_Venta_al_contado_B		10
#Define FE_Liquidacion_A					63
#Define FE_Liquidacion_B					64
#Define FE_Factura_C						11
#Define FE_Nota_de_Debito_C					12
#Define FE_Nota_de_Credito_C				13
#Define FE_Recibo_C							15
#Define FE_Factura_M						51
#Define FE_Nota_de_Debito_M					52	
#Define FE_Nota_de_Credito_M				53
#Define FE_Recibo_M							54

#Define FE_FCE_Factura_A					201
#Define FE_FCE_Nota_de_Debito_A				202
#Define FE_FCE_Nota_de_Credito_A			203
#Define FE_FCE_Factura_B					206
#Define FE_FCE_Nota_de_Debito_B				207
#Define FE_FCE_Nota_de_Credito_B			208
#Define FE_FCE_Factura_C					211
#Define FE_FCE_Nota_de_Debito_C				212
#Define FE_FCE_Nota_de_Credito_C			213

* Sumar al Sucu7 para que no repita sucursal con la FE
#Define FE_FCE_OFFSET						50


*#Define FE_Cbtes. A del Anexo I, Apartado A,inc.f),R.G.Nro. 1415		34
*#Define FE_Cbtes. B del Anexo I,Apartado A,inc. f),R.G. Nro. 1415		35
*#Define FE_Otros comprobantes A que cumplan con R.G.Nro. 1415			39
*#Define FE_Otros comprobantes B que cumplan con R.G.Nro. 1415			40
*#Define FE_Cta_de_Vta y Liquido prod. A								60
*#Define FE_Cta_de_Vta y Liquido prod. B								61
*#Define FE_Comprobante_de_Compra_de_Bienes_Usados_a_Consumidor Final	49