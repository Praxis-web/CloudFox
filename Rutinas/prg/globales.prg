#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Clientes\Valores\Include\valores.h"

* GLOBALES.PRG
* Jorge - 23/09/88
* Definicion de variables publicas

* Definicion e inicializacion de variables globales

*!*	If Type("ugDEF")="U"
*!*		Public ugDEF
*!*		ugDEF=.T.
*!*	Else
*!*		Retu
*!*	EndIf

Public DEMO
DEMO = .F.

Note: Vectores

* Tipos de iva

Public Array Ivas[9],Insc[9],Alicuotas[9], Tipo_Feriado[ 5 ]
Ivas[1]	= 'Resp. inscrip.'
Ivas[2]	= 'A Cons. Final '
*Ivas[3]	= 'No Alcanzado'
* RA 04/11/2019(14:27:18) (Lili LTA )

Ivas[3]	= 'No Informado'
Ivas[4]	= 'Resp. no insc.'
Ivas[5]	= 'Exento        '
Ivas[6]	= 'No Ins. B. Uso'
Ivas[7]	= 'Res. Monotrib.'
Ivas[8]	= 'Res. No Categ.'
Ivas[9]	= 'Otra          '

Insc[1]	= 'RI'
Insc[2]	= 'CF'
*Insc[3]	= 'NA'
Insc[3]	= 'Ni'
Insc[4]	= 'NI'
Insc[5]	= 'EX'
Insc[6]	= "BU"
Insc[7]	= 'RM'
Insc[8]	= 'NC'
Insc[9]	= '  '

Alicuotas[1] = 00.00
Alicuotas[2] = 00.00
Alicuotas[3] = 00.00
Alicuotas[4] = GetValue( "IvaRedu", "ar0Imp", 10.50 )
Alicuotas[5] = GetValue( "IvaNorm", "ar0Imp", 21.00 )
Alicuotas[6] = GetValue( "IvaDife", "ar0Imp", 27.00 )
Alicuotas[7] = 00.00
Alicuotas[8] = GetValue( "IvaMGraf8", "ar0Imp", 5.00 )
Alicuotas[9] = GetValue( "IvaMGraf9", "ar0Imp", 2.50 )

Tipo_Feriado[ FER_INAMOVIBLE  ] = "Inamovible"
Tipo_Feriado[ FER_TRASLADABLE ] = "Trasladable"
Tipo_Feriado[ FER_NOLABORABLE ] = "No Laborable"
Tipo_Feriado[ FER_PUENTE      ] = "Feriado Puente"
Tipo_Feriado[ FER_OTRO        ] = "Otros"

* Meses

Public Array Meses[12]
Meses[01]	= 'Enero     '
Meses[02]	= 'Febrero   '
Meses[03]	= 'Marzo     '
Meses[04]	= 'Abril     '
Meses[05]	= 'Mayo      '
Meses[06]	= 'Junio     '
Meses[07]	= 'Julio     '
Meses[08]	= 'Agosto    '
Meses[09]	= 'Septiembre'
Meses[10]	= 'Octubre   '
Meses[11]	= 'Noviembre '
Meses[12]	= 'Diciembre '

* Dias

Public Array Dias[7]
Dias[01]	= 'Domingo  '
Dias[02]	= 'Lunes    '
Dias[03]	= 'Martes   '
Dias[04]	= 'Miércoles'
Dias[05]	= 'Jueves   '
Dias[06]	= 'Viernes  '
Dias[07]	= 'Sábado   '

* Provincias

Public EXTERIOR
EXTERIOR = 25


Public Array Zonas[ EXTERIOR ]
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
Zonas[ EXTERIOR ]	= 'Exterior           '


Public Array Provincias_Afip[ 25 ]
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

Public Array Provincias_COT[ 24 ]

Provincias_COT[01]	= "C"
Provincias_COT[02]	= "B"
Provincias_COT[03]	= "K"
Provincias_COT[04]	= "X"
Provincias_COT[05]	= "W"
Provincias_COT[06]	= "H"
Provincias_COT[07]	= "U"
Provincias_COT[08]	= "E"
Provincias_COT[09]	= "P"
Provincias_COT[10]	= "Y"
Provincias_COT[11]	= "L"
Provincias_COT[12]	= "F"
Provincias_COT[13]	= "M"
Provincias_COT[14]	= "N"
Provincias_COT[15]	= "Q"
Provincias_COT[16]	= "R"
Provincias_COT[17]	= "A"
Provincias_COT[18]	= "J"
Provincias_COT[19]	= "D"
Provincias_COT[20]	= "Z"
Provincias_COT[21]	= "S"
Provincias_COT[22]	= "G"
Provincias_COT[23]	= "V"
Provincias_COT[24]	= "T"



Note: Pasaje de numeros a letras

Public Array Uni[19],Dec[9],Cen[9]
Uni[01]	= 'un '
Uni[02]	= 'dos '
Uni[03]	= 'tres '
Uni[04]	= 'cuatro '
Uni[05]	= 'cinco '
Uni[06]	= 'seis '
Uni[07]	= 'siete '
Uni[08]	= 'ocho '
Uni[09]	= 'nueve '
Uni[10]	= 'diez '
Uni[11]	= 'once '
Uni[12]	= 'doce '
Uni[13]	= 'trece '
Uni[14]	= 'catorce '
Uni[15]	= 'quince '
Uni[16]	= 'dieciseis '
Uni[17]	= 'diecisiete '
Uni[18]	= 'dieciocho '
Uni[19]	= 'diecinueve '
Dec[03]	= 'treinta '
Dec[04]	= 'cuarenta '
Dec[05]	= 'cincuenta '
Dec[06]	= 'sesenta '
Dec[07]	= 'setenta '
Dec[08]	= 'ochenta '
Dec[09]	= 'noventa '
Cen[02]	= 'doscientos '
Cen[03]	= 'trescientos '
Cen[04]	= 'cuatrocientos '
Cen[05]	= 'quinientos '
Cen[06]	= 'seiscientos '
Cen[07]	= 'setecientos '
Cen[08]	= 'ochocientos '
Cen[09]	= 'novecientos '

* Medios de Pago

Public Array aPAGO[4],aPAGOt[4]

aPAGO[01]	= "Pide Código Contable      "
aPAGO[02]	= "Código Contable -> MONEDA "
aPAGO[03]	= "Código Contable -> BANCO  "
aPAGO[04]	= "Código Contable -> TARJETA"

* AR4VAR->TIPO4 para cada pago

aPAGOt[01]	= " "
aPAGOt[02]	= "M"
aPAGOt[03]	= "5"
aPAGOt[04]	= "T"

Note: Expresiones

Public Aborta,Confirma

Aborta		= 'prxAborta()'
Confirma	= 'prxConfirma()'

* Tipo de Pago

Local lcCommand As String

Try

	lcCommand = ""
	Use In Select( "Medios_De_Pago" )
	Use ( Alltrim( DRCOMUN ) + "Medios_De_Pago"  ) Shared In 0
	
	Select Medios_De_Pago
	Locate
	
	If !Empty( Field( "DigiNume" ))
		Scan for Empty( DigiNume )
			M_IniAct( 52 )
			Replace DigiNume With 10, Picture With Replicate( "9", 10 )
			Unlock 
		EndScan
	EndIf

	TEXT To lcCommand NoShow TextMerge Pretext 15
	Select *
		From Medios_De_Pago
		Where Tipo In ( "C", "A" )
		Order By Orden, Nombre
		Into Cursor cMedios_De_Pago ReadWrite
	ENDTEXT

	&lcCommand
	lcCommand = ""
	
	Public Array gaTPAG[ _Tally ], gaTPAG_Cod[ _Tally ]
	
	Select cMedios_De_Pago 
	Locate 
	
	Scan 	
	
		gaTPAG[ Recno() ] = Alltrim( Nombre )
		gaTPAG_Cod[ Recno() ] = Codigo

	EndScan

Catch To loErr
	Public Array gaTPAG[6], gaTPAG_Cod[6]

	gaTPAG[ TP_EFECTIVO ] 			= "EFECTIVO"
	gaTPAG[ TP_TARJETA_DE_CREDITO ] = "TARJETA DE CREDITO"
	gaTPAG[ TP_TARJETA_DE_DEBITO ] 	= "TARJETA DE DEBITO"
	gaTPAG[ TP_CREDITO_PERSONAL ] 	= "CREDITO PERSONAL"
	gaTPAG[ TP_CHEQUE ] 			= "CHEQUE"
	gaTPAG[ TP_CREDITO_BANCARIO ] 	= "CREDITO BANCARIO"

	gaTPAG_Cod[ TP_EFECTIVO ] 			= VA_EFECTIVO_TERCEROS
	gaTPAG_Cod[ TP_TARJETA_DE_CREDITO ] = VA_TARJETA_CREDITO
	gaTPAG_Cod[ TP_TARJETA_DE_DEBITO ] 	= VA_TARJETA_DEBITO
	gaTPAG_Cod[ TP_CREDITO_PERSONAL ] 	= VA_CREDITO_PERSONAL
	gaTPAG_Cod[ TP_CHEQUE ] 			= VA_CHEQUES_TERCEROS
	gaTPAG_Cod[ TP_CREDITO_BANCARIO ] 	= VA_CREDITO_BANCARIO

Finally
	Use In Select( "Medios_De_Pago" )
	Use In Select( "cMedios_De_Pago" )


Endtry

Public Array gaConceptos[3]

gaConceptos[1] = "Compras"
gaConceptos[2] = "Gastos"
gaConceptos[3] = "Bienes de Uso"


Note: Generacion de variables memotecnicas

Public False,True,Spaces,Page,Line,Null,Lastdate

False	= .F.
True	= .T.
Spaces	= Space(80)
Page	= 0
Line	= 0
Null	= ''

Set Date French
Lastdate={^2079/12/31}

Note: Asignacion de valores Ascii

Public Cero,Uno,Dos,Tres,Cuatro,Mas,Menos,Enter,Escape,PgUp,PgDn,CtrlPgUp,;
	CtrlPgDn,Space,Back,Abajo,Arriba,Fin,Hogar,F2,F3,F4,F5,F6,F7,F8,F9,F10,;
	Izquierda,Cinco,F1,F11,F12,Derecha,ShiftTab,TabKey

Cero		= 48
Uno			= 49
Dos			= 50
Tres		= 51
Cuatro		= 52
Cinco		= 53

Mas			= 43
Menos		= 45

Enter		= 13
Escape		= 27
PgUp		= 18
PgDn		= 03
CtrlPgUp	= 31
CtrlPgDn	= 30
Space		= 32
Back		= 08
Abajo		= 24
Arriba		= 05
Fin			= 06
Hogar		= 01
F1			= 28
F2			=-01
F3			=-02
F4			=-03
F5			=-04
F6			=-05
F7			=-06
F8			=-07
F9			=-08
F10			=-09
F11			=133
F12			=134
Izquierda	= 19
Derecha		= 04
TabKey		= 09
ShiftTab	= 15

Note: Generacion de mensajes de opciones

Public Msg1,Msg2,Msg3,Msg4,Msg5,Msg6,Msg7,Msg8,Msg9,Msg10,Msg10,Msg11,Msg12,;
	Msg13,Msg14,Msg15,Msg16,Msg17,Msg18,Msg19,Msg20,Msg21,Msg21,Msg22,;
	Msg23,Msg24,Msg25,Msg26,Msg27,Msg28,Msg29,Msg30

Msg1	='[1]:Elimina [2]:Modifica [Enter]:Clave [Arriba]:Cla Ant [Abajo]:Cla Sig [Esc]'
Msg2	='[Enter]:Confirma               [Esc]:No confirma'
Msg3	='[Abajo]:Sig [Arriba]:Ant [PgDn]:Pan.Sig [PgUp]:Pan.Ant [F9]:Inicio [F10]:Final'
Msg4	='[Enter]:Siguiente dato    [Pg Up]:Anterior    [Pg Dn]:Ultimo    [Esc]:Opciones'
Msg5	='[Enter]:Dato siguiente        [Arriba]:Dato anterior        [Esc]:Interrumpe'
Msg6	='[Enter]:Confirma          [Esc]:No confirma          [2]:Modifica'
Msg7	='[1]:Elimina [2]:Modifica [3]:Agrega [4]:Recupera [F3]:Cancelar'
Msg8	='[Esc]:Menu'
Msg9	='[1]:Por Clave                  [2]:Alfabetico'
Msg10	='[Enter]:Confirma dato               [Esc]:Menu'
Msg11	='[Abajo]: Item siguiente      [Arriba]: Item anterior      [Enter]: Item elegido'
Msg12	='[Esc]:Interrumpe impresion'
Msg13	='[Esc]:Fin'
Msg14	='Procesando'
Msg15	='[Enter]:Confirma dato'
Msg16	='[Enter]:Sig [Retr]:Ant [PgDn]:Pan.Sig [PgUp]:Pan.Ant [^PgDn]:Fin [^PgUp]:Inicio'
Msg17	='[Enter]:Dato siguiente   [Arriba]:Anterior   [Pg Dn]:Ultimo   [Esc]:Interrumpe'
Msg18	='[Enter]:Confirma dato               [Esc]:Opciones'
Msg19	='[Enter]:Confirma e imprime   [F10]:Confirma y no imprime   [Esc]:No confirma'
Msg20	='Ingrese el codigo o blancos para busqueda alfabetica'
Msg21	='Ingrese el nombre o blancos para busqueda por codigo'
Msg22	='Ingrese la descripcion o blancos para busqueda por codigo'
Msg23	='[+]:Siguiente        [-]:Anterior        [F9]:Inicio         [F10]:Final'
Msg24	='[S]:Si               [N]:No'
Msg25	='[Enter]:Clave         [-]:Cla Ant         [+]:Cla Sig         [Esc]:Fin'
Msg26	='[Enter]:Dato siguiente        [Arriba]:Dato anterior        [Esc]:Interrumpe'
Msg27	='[Enter]:Modifica [Flechas] [PgUp] [PgDn] [Home] [End] [^PgUp] [^PgDn] [Esc]:Fin'
Msg28	='[1]:Elimina [2]:Modifica [0]:Est [Enter]:Clave [-]:C. Ant [+]:C. Sig [Esc]:Fin'
Msg29	='[Enter]:Mod.[Flechas] [PgUp] [PgDn] [Home] [End] [^PgUp] [^PgDn] [0]:Est [Esc]'
Msg30	='[Enter]:Ingresa comprobante                    [Esc]:Menu'


Note: Generacion de mensajes aclaratorios

Public Acl1,Acl2,Acl3,Acl4,Acl5,Acl6,Acl7,Acl8,Acl9,Acl10,Acl11,Acl12,Acl13

Acl1	= 'Oprima la tecla correspondiente a su opcion'
Acl2	= 'Verifique que la impresora se encuentre ENCENDIDA y ON LINE'
Acl3	= 'Digite el numero correspondiente a su opcion o Esc para finalizar'
Acl4	= 'Ingrese clave inicial o blancos para listar todo el archivo'
Acl5	= 'Ingrese clave final o blancos para repetir clave inicial'
Acl6	= 'Ingrese la fecha en formato DD/MM/AA'
Acl7	= 'Ingrese clave inicial o cero para listar todo el archivo'
Acl8	= 'Ingrese clave final o cero para repetir clave inicial'
Acl9	= 'Digite su opcion o Esc para volver al Menu del sistema'
Acl10	= 'Digite la letra correspondiente a su opcion o Esc para finalizar'
Acl11	= '[1]:Inscripto    [2]:Consumidor Final    [3]:Exento    [4]:No Responsable'
Acl12	= '[1]:Resp.Inscripto  [2]:Cons.Final  [3]:No Respons.  [4]:Respons. No Insc'
Acl13	= '[1]:Resp.Inscr. [2]:Cons.Final  [3]:No Resp.  [4]:Resp. No Insc  [5]:Exento'

Note: Generacion de mensajes de Error

Public Err1,Err2,Err3,Err4,Err5,Err6

Err1	= 'Codigo ya ingresado'
Err2	= 'Dato invalido, ingreselo nuevamente'
Err3	= 'Codigo inexistente, ingreselo nuevamente'
Err4	= 'Codigo existente, ingreselo nuevamente'
Err5	= 'Codigo dado de baja'

Text To Err6 NoShow TextMerge Pretext 03
No existen registros
para el rango especificado
EndText

*!*	* Colores
Public CL_NORMAL, CL_BORDER, CL_CHOICE, CL_LINE00, CL_LINE01, CL_LINE21, CL_LINE22, CL_LINE23, CL_LINE24, CL_RESALT, CL_TITULO,;
	CL_SELECTED, CL_UNSELECTED, CL_USUARIO

CL_NORMAL 		= "CL_NORMAL"
CL_BORDER 		= "CL_BORDER"
CL_CHOICE 		= "CL_CHOICE"
CL_LINE00 		= "CL_LINE00"
CL_LINE01 		= "CL_LINE01"
CL_LINE21 		= "CL_LINE21"
CL_LINE22 		= "CL_LINE22"
CL_LINE23 		= "CL_LINE23"
CL_LINE24 		= "CL_LINE24"
CL_RESALT 		= "CL_RESALT"
CL_TITULO 		= "CL_TITULO"
CL_SELECTED 	= "CL_SELECTED"
CL_UNSELECTED 	= "CL_UNSELECTED"
CL_USUARIO		= "CL_USUARIO"

Public gcBackColor, gcForeColor, gcGetBackColor, gcGetForeColor
gcBackColor 	= CLR_BackColor
gcForeColor 	= CLR_ForeColor
gcGetBackColor 	= CLR_GetBackColor
gcGetForeColor 	= CLR_GetForeColor

Public 	DEMO, ASTERISCO

DEMO		= .F.
ASTERISCO	= .T.


Public P_LINE, P_PORT, P_PAPE, P_TIPO, P_USER, P_SALI, CONDICION


Public K_COSTOS, K_SPONSOR, K_PROYECTO
K_COSTOS	= .F.
K_SPONSOR	= .F.
K_PROYECTO	= .F.

Public CLAVE, NivelDeAcceso
CLAVE	= 0
NivelDeAcceso = 0

Public FechaHoy
FechaHoy 	= Date()

* Si se quiere forzar a que la cola de impresion se personalice por usuario,
* definir lUsuario = .T. en arParame.mem
* de lo contrario, se personaliza por terminal

If Vartype( lUsuario ) = "L" And lUsuario = .T.
	P_USER	= Usuario()
Endif

P_USER	= NETNAME()
If Empty( P_USER )
	P_USER	= Usuario()
	If Empty( P_USER )
		P_USER	= Alltrim( TERMINAL )
	Endif
Endif

P_USER	= Substr( P_USER + Space( 10 ), 1, 10 )

FechaHoy = Date()

Public gnCodi4, gcClieMask, gnMaxCodi4
gnCodi4 = GetValue( "LenCodi4", "ar0Var", 4 )

If Empty( gnCodi4 )
	gnCodi4 = 4
Endif

gcClieMask = Replicate( "9", gnCodi4 )
gnMaxCodi4 = Int( Val( Replicate( "9", gnCodi4 )))

Do LoadNamespace In Tools\Namespaces\prg\LoadNamespace.prg


Return
