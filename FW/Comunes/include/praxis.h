*-- (c) Praxis Computacion 2004


*-- Common include file
#INCLUDE "FW\Comunes\Include\FoxPro.h"
#INCLUDE "FW\Comunes\Include\Strings.h"

#INCLUDE "Tools\Namespaces\Include\System.h"

*---------------- Acciones -----------------------
#DEFINE DO_CREATE 	16
#DEFINE DO_READ  	8
#DEFINE DO_UPDATE 	4
#DEFINE DO_DELETE 	2
#DEFINE DO_LIST  	1

*---------------- Permisos -----------------------
#DEFINE CAN_CREATE 	16
#DEFINE CAN_READ  	8
#DEFINE CAN_UPDATE 	4
#DEFINE CAN_DELETE 	2
#DEFINE CAN_LIST  	1

*---------------- Tipo de Numeracion -----------------------
#DEFINE TN_MANUAL 					1
#DEFINE TN_AUTOMATICA  				2
#DEFINE TN_FACTURA_ELECTRONICA 		3
#DEFINE TN_IMPRESORA_FISCAL_HASAR 	4
#DEFINE TN_IMPRESORA_FISCAL_EPSON 	5

*---------------- Id Modulos -----------------------
#DEFINE MDL_SISTEMA			00
#DEFINE MDL_ACREEDORES		01
#DEFINE MDL_ARCHIVOS		02
#DEFINE MDL_COMPRAS			03
#DEFINE MDL_CONTABLE		04
#DEFINE MDL_DEUDORES		05
#DEFINE MDL_ESTADISTICAS	06
#DEFINE MDL_HASAR			07
#DEFINE MDL_SIAP			08
#DEFINE MDL_STOCK			09
#DEFINE MDL_UTILES			10	
#DEFINE MDL_VALORES			11
#DEFINE MDL_VENTAS			12
#DEFINE MDL_CAJAS			13
#DEFINE MDL_PEDIDOS			14
#DEFINE MDL_MELI			15
#DEFINE MDL_TIENDA			16


*---------------- Id Procesos -----------------------
#DEFINE CRUD_EMPRESAS		0001
#DEFINE CRUD_USERGROUPS		0002
#DEFINE CRUD_USUARIOS		0003
#DEFINE REORDENAR			( MDL_UTILES * 100 ) + 01

*---------------- File Locations ---------------

*-- Ubicacion de los archivos comunes
#DEFINE FL_DEFAULT	"FW"
#DEFINE FL_COMUN	FL_DEFAULT+"\Comunes"
#DEFINE FL_INCLUDE	FL_COMUN + "\Include"
#DEFINE FL_SOURCE	FL_COMUN + "\Prg"
#DEFINE FL_LIBS 	FL_COMUN + "\Vcx"
#DEFINE FL_IMAGE	FL_COMUN + "\Image"
#DEFINE FL_MEDIA 	FL_COMUN + "\Media"
#DEFINE FL_SCX 		FL_COMUN + "\Scx"

*-- Ubicacion de los archivos de la clase ErrorHandler
#DEFINE FL_ERRORHANDLER	FL_DEFAULT+"\ErrorHandler"
#DEFINE EH_VCX			FL_ERRORHANDLER
#DEFINE EH_SCX			FL_ERRORHANDLER
#DEFINE EH_PRG			FL_ERRORHANDLER
#DEFINE EH_IMG			FL_ERRORHANDLER


*-- Ubicacion de los archivos de la clase Menus
#DEFINE FL_MENUS		FL_DEFAULT+"\Menus"
#DEFINE MN_VCX			FL_MENUS + "\Vcx"
#DEFINE MN_SCX			FL_MENUS + "\Scx"
#DEFINE MN_PRG			FL_MENUS + "\Prg"
#DEFINE MN_IMG			FL_MENUS + "\Img"


*-- Caracteres para insertar en un string
#DEFINE CR			CHR(13)
#DEFINE LF			CHR(10)
#DEFINE CRLF		CR + LF
#DEFINE TAB			CHR(9)
#DEFINE C_NULL		CHR(0)
#DEFINE BS			CHR(8)
#DEFINE FF			CHR(12)

*/ Datos de Diseño
#DEFINE SCROLLBARS_WIDTH	Sysmetric( SYSMETRIC_VSCROLLBARWIDTH ) + 5  
#DEFINE SCROLLBARS_HEIGHT	Sysmetric( SYSMETRIC_HSCROLLBARHEIGHT )  
#DEFINE WINDOWTITLEHEIGHT 	Sysmetric( SYSMETRIC_WINDOWTITLEHEIGHT )
#DEFINE TABS_HEIGHT			28
* Si pageframe.taborientation es 0 ó 1, 
* entonces tabheight = pageframe.height - pageframe.pageheight

* Si pageframe.taborientation es 3 ó 3, 
* entonces tabwidth = pageframe.width - pageframe.pagewidth

* Si el tab esta seleccionado, al valor que te da le restas 2. 
* Si no esta seleccionado, el tab es menos alto, le restas 4.


*----------- ALIGN

#Define 	ALIGN_LEFT				0
#Define 	ALIGN_RIGHT				1
#Define 	ALIGN_CENTER			2	
#Define 	ALIGN_AUTOMATIC			3


*/ Carácter Estilo de fuente

#DEFINE FS_BOLD 			"B"
#DEFINE FS_ITALIC			"I"
#DEFINE FS_NORMAL			"N"
#DEFINE FS_OUTLINE		    "O"
#DEFINE FS_OPAQUE			"Q"
#DEFINE FS_SHADOW			"S"
#DEFINE FS_STRIKEOUT		"-"
#DEFINE FS_UNDERLINE		"U"
#DEFINE FS_TRANSPARENT	    "T"


*/ Control TreeView

*/ TreeView.Nodes.Add()
*/ Los valores válidos para relación son:
*/ 		Constante 		Valor
#DEFINE tvw_First 		0
#DEFINE tvw_Last 		1
#DEFINE tvw_Next 		2
#DEFINE tvw_Previous 	3
#DEFINE tvw_Child 		4
*/Configuracion del texto del Nodo
#DEFINE tvw_label_desc          0
#DEFINE tvw_label_cod           1
#DEFINE tvw_label_desc_cod      2
#DEFINE tvw_label_cod_desc      3


*/ TreeView.Nodes.LabelEdit
#DEFINE tvw_Automatic 	0
#DEFINE tvw_Manual 		1

*/ ListView Control
#DEFINE lvwIcon			0
#DEFINE lvwSmallIcon	1
#DEFINE lvwList			2
#DEFINE lvwReport		3

*/ Valores ASCII devueltos por Inkey()

#DEFINE KEY_F1 					 28
#DEFINE KEY_F2 					 -1
#DEFINE KEY_F3 					 -2
#DEFINE KEY_F4 					 -3
#DEFINE KEY_F5 					 -4
#DEFINE KEY_F6 					 -5
#DEFINE KEY_F7 					 -6
#DEFINE KEY_F8 					 -7
#DEFINE KEY_F9 					 -8
#DEFINE KEY_F10 				 -9
#DEFINE KEY_F11 				 133
#DEFINE KEY_F12 				 134
#DEFINE KEY_INS 			 	 22
#DEFINE KEY_INICIO 				 1
#DEFINE KEY_SUPR	 			 7
#DEFINE KEY_FIN 				 6
#DEFINE KEY_RE_PAG 				 18
#DEFINE KEY_AV_PAG 				 3
#DEFINE KEY_FLECHA_ARRIBA 		 5
#DEFINE KEY_FLECHA_ABAJO 		 24
#DEFINE KEY_FLECHA_DERECHA 	     4
#DEFINE KEY_FLECHA_IZQUIERDA 	 19
#DEFINE KEY_ESCAPE 				 27
#DEFINE KEY_ENTER 				 13
#DEFINE KEY_RETROCESO  			 127
#DEFINE KEY_TAB 				 9
#DEFINE KEY_BARRA_ESPACIADORA    32
#DEFINE KEY_LEFT_ARROW           155
#DEFINE KEY_ASTERISCO            42
#DEFINE KEY_MAS					 43
#DEFINE KEY_MENOS				 45

#DEFINE KEY_ALT_F1 			 	 104
#DEFINE KEY_ALT_F5 			 	 108
#DEFINE KEY_ALT_F8 			 	 111
#DEFINE KEY_ALT_F10 			 113
#DEFINE KEY_ALT_F12				 140
#DEFINE KEY_ALT_UP			 	 152
#DEFINE KEY_ALT_DOWN			 160
#DEFINE KEY_ALT_LEFT			 155
#DEFINE KEY_ALT_RIGHT			 157



#DEFINE KEY_CTRL_A				1
#DEFINE KEY_CTRL_B				2
#DEFINE KEY_CTRL_C				3
#DEFINE KEY_CTRL_D				4
#DEFINE KEY_CTRL_E				5
#DEFINE KEY_CTRL_F				6
#DEFINE KEY_CTRL_G				7	
#DEFINE KEY_CTRL_H				127
#DEFINE KEY_CTRL_I				9
#DEFINE KEY_CTRL_J				10
#DEFINE KEY_CTRL_K				11
#DEFINE KEY_CTRL_L				12
#DEFINE KEY_CTRL_M				13
#DEFINE KEY_CTRL_N				14
#DEFINE KEY_CTRL_O				15
#DEFINE KEY_CTRL_P				16
#DEFINE KEY_CTRL_Q				17
#DEFINE KEY_CTRL_R				18
#DEFINE KEY_CTRL_S				19
#DEFINE KEY_CTRL_T				20
#DEFINE KEY_CTRL_U				21
#DEFINE KEY_CTRL_V				22
#DEFINE KEY_CTRL_W				23
#DEFINE KEY_CTRL_X				24
#DEFINE KEY_CTRL_Y				25
#DEFINE KEY_CTRL_Z				26

#DEFINE KEY_CTRL_F1			 	094
#DEFINE KEY_CTRL_F2			 	095
#DEFINE KEY_CTRL_F3			 	096
#DEFINE KEY_CTRL_F4			 	097
#DEFINE KEY_CTRL_F5			 	098
#DEFINE KEY_CTRL_F6			 	099
#DEFINE KEY_CTRL_F7			 	100
#DEFINE KEY_CTRL_F8			 	101
#DEFINE KEY_CTRL_F9			 	102
#DEFINE KEY_CTRL_F10			103
#DEFINE KEY_CTRL_F12			138
#DEFINE KEY_CTRL_RE_PAG 		31
#DEFINE KEY_CTRL_AV_PAG 		30
#DEFINE KEY_CTRL_FLECHA_ARRIBA 	141
#DEFINE KEY_CTRL_DOWN			2
#DEFINE KEY_CTRL_ENTER			10

#DEFINE KEY_SHIFT_DOWN			1
#DEFINE KEY_SHIFT_LEFT			52



*/ Valores ANSI utilizados por Visual Basic

#DEFINE VBKEY_F1 					112
#DEFINE VBKEY_F2 					113
#DEFINE VBKEY_F3 					114
#DEFINE VBKEY_F4 					115
#DEFINE VBKEY_F5 					116
#DEFINE VBKEY_F6 					117
#DEFINE VBKEY_F7 					118
#DEFINE VBKEY_F8 					119
#DEFINE VBKEY_F9 					120
#DEFINE VBKEY_F10 				 	121
#DEFINE VBKEY_F11 					122
#DEFINE VBKEY_F12 					123
#DEFINE VBKEY_INS 			 	 	045
#DEFINE VBKEY_INICIO 				036
#DEFINE VBKEY_SUPR 				  	046
#DEFINE VBKEY_FIN 				  	035
#DEFINE VBKEY_RE_PÁG 				033
#DEFINE VBKEY_AV_PÁG 				034
#DEFINE VBKEY_FLECHA_ARRIBA 		038
#DEFINE VBKEY_FLECHA_ABAJO 			040
#DEFINE VBKEY_FLECHA_DERECHA 		039
#DEFINE VBKEY_FLECHA_IZQUIERDA 		037
#DEFINE VBKEY_ESCAPE 				027
#DEFINE VBKEY_ENTRAR 				013
#DEFINE VBKEY_RETROCESO  			008
#DEFINE VBKEY_TAB 				  	009
#DEFINE VBKEY_BARRA_ESPACIADORA 	032
#DEFINE VBKEY_PRINT_SCREEN			044
#DEFINE VBKEY_BLOQ_DESPL			145
#DEFINE VBKEY_PAUSA					019


* ----------- dbObjType() ------------------
#DEFINE DB_CONNECTION 	0
#DEFINE DB_DATABASE 	1
#DEFINE DB_FIELD 		2
#DEFINE DB_TABLE 		4
#DEFINE DB_VIEW 		8
#DEFINE DB_PARENTID		1
#DEFINE DB_NOTFOUND		-1

#DEFINE DB_OBJCONNECTION 	"Connection"
#DEFINE DB_OBJDATABASE 		"Database"
#DEFINE DB_OBJFIELD 		"Field"
#DEFINE DB_OBJTABLE 		"Table"
#DEFINE DB_OBJVIEW 			"View"

* ------------ mbPlayWav -----------------------------
* Archivos de sonido
#DEFINE PW_ERROR			"Error.wav"
#DEFINE PW_EXCLAM			"Info.wav"
#DEFINE PW_INFO			"Info.wav"
#DEFINE PW_DEFAULT		"Predet.wav"
#DEFINE PW_PREGUNTA		"Pregunta.wav"
#DEFINE PW_RECICLAR		"Reciclar.wav"
#DEFINE PW_STOP			"Stop.wav"


* ------------ Anchor -----------------------------
* Valores de la propiedad Anchor

#DEFINE ANCHOR_Top_Left 				000
#DEFINE ANCHOR_Top_Absolute 			001
#DEFINE ANCHOR_Left_Absolute 			002
#DEFINE ANCHOR_Bottom_Absolute 			004
#DEFINE ANCHOR_Right_Absolute 			008
#DEFINE ANCHOR_Top_Relative 			016
#DEFINE ANCHOR_Left_Relative 			032
#DEFINE ANCHOR_Bottom_Relative 			064
#DEFINE ANCHOR_Right_Relative 			128
#DEFINE ANCHOR_Horizontal_Fixed_Size 	256
#DEFINE ANCHOR_Vertical_Fixed_Size 		512

*/ --------------- Fit Mode -------------------

#define FIT_WIDTH 		5
#define FIT_HEIGHT 		10
#define FIT_BOTH 		15
#define FULL_FIT 		15

#define FIT_LEFT        1
#define FIT_TOP         2
#define FIT_RIGHT       4
#define FIT_BOTTOM      8


*/ --------------- Signo de movimientos -------------------
#DEFINE MTO_ENTRADA	1
#DEFINE MTO_SALIDA	2

*/ --------------- Sexo --------------------------

#DEFINE MASCULINO 1
#DEFINE FEMENINO  2

*/ --------------- Marca de Actualizacion (ABM) --------------------------

#DEFINE ABM_ALTA 			1
#DEFINE ABM_BAJA  			2
#DEFINE ABM_MODIFICACION  	3
#DEFINE ABM_CONSULTA  		4
#DEFINE ABM_PROCESADO  		5


*/ --------------- ParentType ---------------------
*/ Valor del campo ParentType para las tablas de uso comun:
*/		Direcciones
*/		Telefonos

#DEFINE PT_CLIENTE		1
#DEFINE PT_PROVEEDOR	2
#DEFINE PT_VENDEDOR		3
#DEFINE PT_CONTACTO		4


*------------- Impresion de Comprobantes ---------------------
#Define FRX_FACTURA				1
#Define FRX_PROFORMA			2
#Define FRX_PRESUPUESTO			3
#Define FRX_REMITO				4
#Define FRX_RECIBO				5
#Define FRX_ORDENDEPAGO     	6
#Define FRX_EGRESODEVALOR   	7
#Define FRX_MEMO		  		8
#Define FRX_FACTURA_ELECTRONICA	9
#Define FRX_ORDEN_DE_COMPRA		10
#Define FRX_BOLETA_DEPOSITO		11
#Define FRX_INGRESO_DE_FONDOS   12

* Salida del reporte
#Define _FRX_PREVIEW			1
#Define _FRX_PRINTER			2
#Define _FRX_DEFAULT_PRINTER	3
#Define _FRX_PDF				4

* -------------- Tipo de Salida -------------------------
#Define S_IMPRESORA					'00'
#Define S_VISTA_PREVIA				'01'
#Define S_HOJA_DE_CALCULO			'02'
#Define S_PANTALLA					'03'
#Define S_PDF						'04'
#Define S_CSV						'05'
#Define S_SDF						'06'
#Define S_IMPRESORA_PREDETERMINADA	'07'
#Define S_TXT						'08'
#Define S_MAIL						'09'
#Define S_PROCESO					'10'
#Define S_LISTADO_DOS				'99'

* -------------- Funcion GetDate() ----------------------
#Define GD_FIRST_CURRENT_MONTH	1
#Define GD_FIRST_LAST_MONTH		2
#Define GD_FIRST_NEXT_MONTH		3
#Define GD_LAST_CURRENT_MONTH	4
#Define GD_LAST_LAST_MONTH		5
#Define GD_LAST_NEXT_MONTH		6
#Define GD_SAME_NEXT_YEAR		7
#Define GD_SAME_LAST_YEAR		8
#Define GD_FIRST_CURRENT_YEAR	9

* -------------- Funcion DateMak() ----------------------
****#Define DEFAULT_DATETIME_FORMAT	'Dd d9 de Mm de yyyy'

*/ -------------------- ExitWindows --------------------
*/ CONSTANTES Y DECLARACIONES PARA SALIR DE WINDOWS

*/ Cerrar todos los programas e iniciar la sesión como
*/ un usuario distinto
#Define EWX_LOGOFF 		0

*/ Apagar el equipo
#Define EWX_SHUTDOWN 	1

*/ Reiniciar el equipo
#Define EWX_REBOOT 		2

*/ Forzar el apagado. Los ficheros abiertos se pueden perder. Las
*/ aplicaciones no preguntarán si se quieren guardar las modificaciones
#Define EWX_FORCE 		4

*/ ---------------- SynchronizeTables ---------------------
#Define Sync_Interactiva	1
#Define Sync_Nuevos			2
#Define Sync_Modificados	4
#Define Sync_Bajas			8
#Define Sync_Confirma		16

* -------------- prxIngreso ----------------------
#Define r3_Ingreso		1
#Define r3_Modificacion	2

#Define r3_Total		1
#Define r3_Modifica		2
#Define r3_Elimina		3
#Define r3_Consulta		4

*--------------- prx7Item ---------------------------

#Define r7_Total			1
#Define r7_Modifica			2
#Define r7_Elimina			3
#Define r7_Consulta			4
#Define r7_AgregaYModifica 	5
#Define r7_ConsultaPorItem	6
#Define r7_EliminaYModifica 7

#Define r7_NoConfirma			0
#Define r7_ConfirmaCon_0		1
#Define r7_ConfirmaCon_F8		2
#Define r7_ConfirmaConAmbos		3
#Define r7_ConfirmaCon_F5_y_F8	4
#Define r7_ConfirmaCon_Enter_CancelaCon_Esc	5

#Define r7_Alta			1
#Define r7_Modificacion	2

*---------------- I_Askey ---------------------------
#Define ST_ESCAPE	1
#Define ST_VACIO	2
#Define ST_VALOR	3


*------------------- Id de Iva ----------------------
#Define IVA_CERO_ID				3
#Define IVA_REDUCIDO_ID			4
#Define IVA_NORMAL_ID			5
#Define IVA_DIFERENCIADO_ID		6

* Iva a Medios Graficos
#Define IVA_MGRAF8_ID			8
#Define IVA_MGRAF9_ID			9

*------------------- Id de Monedas ----------------------
#Define PESOS_ID	1
#Define DOLAR_ID	2

*----------------- Id de Grupos Predeterminados ----------------------------
#Define GRP_ADMIN				1
#Define GRP_USUARIO				2
#Define GRP_IMPLEMENTADOR		3


*---------------- Estados ----------------------
#Define STT_IDLE		0
#Define STT_EDITANDO	1
#Define STT_CREANDO		2
#Define STT_NAVEGANDO	3


* _Controles_Base
#Define _CB_BACKCOLOR			Rgb( 255, 255, 255 )
#Define _CB_FORECOLOR			Rgb( 0, 0, 0 )
#Define _CB_ONFOCUS_BACKCOLOR	Rgb( 220, 255, 255 )
#Define _CB_ONFOCUS_FORECOLOR	Rgb( 0, 0, 0 )
#Define _CB_NOTVALID_BACKCOLOR	Rgb( 255, 200, 200 )

*---------------- Feriados -----------------------
#DEFINE FER_INAMOVIBLE 		01
#DEFINE FER_TRASLADABLE 	02
#DEFINE FER_NOLABORABLE 	03
#DEFINE FER_PUENTE			04
#DEFINE FER_OTRO			05

#DEFINE FER_URL			    "http://nolaborables.com.ar/api/v2/feriados/"


*---------------- Colores -------------------------------

#Define CLR_Blanco		"255,255,255"
#Define CLR_Negro 		"000,000,000"
#Define CLR_Gris 		"212,208,200"
*#Define CLR_Gris 		"222,222,222"

#Define CLR_Rojo 		"255,000,000"
#Define CLR_Azul		"010,036,106"
#Define CLR_Amarillo 	"255,255,000"

#Define CLR_Verde 		"210,255,210"
#Define CLR_Naranja 	"255,128,000"
#Define CLR_Violeta 	"128,000,255"

#Define CLR_Marron 		"128,064,000"

#Define CLR_Selected 		"220,255,255"
#Define CLR_BackColor		CLR_Gris
#Define CLR_ForeColor		CLR_Negro
#Define CLR_GetBackColor 	CLR_Blanco
#Define CLR_GetForeColor 	CLR_Negro

*#Define CLR_ForeColor		CLR_Azul
*#Define CLR_GetBackColor 	"220,255,255"
*#Define CLR_GetForeColor 	CLR_Azul


*------------------- WScript.Shell ---------------------
#define WSS_WINDOWSTYLE_HIDE	0	&& Hides the window and activates another window.
#define WSS_WINDOWSTYLE_DISPLAY	1	&& Activates and displays a window. If the window is minimized or maximized, the system restores it to its original size and position. An application should specify this flag when displaying the window for the first time.
#define WSS_WINDOWSTYLE_MINIMIZED	2	&& Activates the window and displays it as a minimized window.
#define WSS_WINDOWSTYLE_MAXIMIZED 	3	&&	Activates the window and displays it as a maximized window.
