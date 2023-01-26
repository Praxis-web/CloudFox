*---------------- File Locations ---------------
#DEFINE TA_DEFAULT		"FW\TierAdapter"
#DEFINE TA_USERTIER		TA_DEFAULT + "\UserTier"
#DEFINE TA_SERVICETIER	TA_DEFAULT + "\ServiceTier"
#DEFINE TA_BIZTIER		TA_DEFAULT + "\BizTier"
#DEFINE TA_DATATIER		TA_DEFAULT + "\DataTier"
#DEFINE TA_LOCALDATA	TA_DEFAULT + "\Data\Local"
#DEFINE TA_SERVERDATA	TA_DEFAULT + "\Data\Server"
#DEFINE TA_IMAGES    	TA_DEFAULT + "\Images"
#DEFINE TA_COMUN		TA_DEFAULT + "\Comun"

*----- STATUS
#DEFINE IS_IDLE		0
#DEFINE IS_EDITING	1
#DEFINE IS_READING	2

#DEFINE IS_ENABLED	1
#DEFINE IS_VISIBLE	2


*Valores LógicoS compatibles con SQL Server
#DEFINE IS_TRUE			1
#DEFINE IS_FALSE			0

*Valores de la propiedad IndexKey de la clase Fields
#DEFINE IK_NOKEY				0
#DEFINE IK_PRIMARY_KEY		1
#DEFINE IK_CANDIDATE_KEY	2
#DEFINE IK_UNIQUE_KEY		2
#DEFINE IK_REGULAR			3
#DEFINE IK_FOREIGN_KEY		4


*-- Parametros para print Report
#DEFINE PR_GRID  			0
#DEFINE PR_PREVIEW			1
#DEFINE PR_PRINT			2
#DEFINE PR_EXPORT  			4


*--- DataSessions
#DEFINE SET_DEFAULT	1
#DEFINE SET_PRIVATE	2

*---- ResultStatus
#DEFINE RESULT_OK			0
#DEFINE RESULT_ERROR		-1
#DEFINE RESULT_WARNINGS		1
#DEFINE RESULT_BIZ_ERROR	2
#DEFINE RESULT_USER_TAG		3

*---------------- Valores ---------------
*/ Valor absoluto máximo acceptado por un campo tipo INTEGER
#DEFINE INTEGER_LIMIT		2147483647		

*/ Acción a Cumplir

#DEFINE CAN_CREATE	1		&&	0001 binario
#DEFINE CAN_UPDATE	2		&&	0010 binario
#DEFINE CAN_READ	4		&&	0100 binario
#DEFINE CAN_DELETE	8		&&	1000 binario
#DEFINE CAN_LIST 	16
#DEFINE CAN_EXPORT 	32

*/ Accion realizada durante una transacción

#DEFINE TR_NEW				1
#DEFINE TR_UPDATE			2
#DEFINE TR_DELETE			4
#DEFINE TR_QUERY			8
#DEFINE TR_EXPORT			16
#DEFINE TR_IMPORT			32
#DEFINE TR_PREVIEW			64
#DEFINE TR_PRINT		   	128

*/ Tiempo de espera antes de desbloquear una transaccion
#DEFINE TR_SECONDS			30

* --- GETFLDSTATE ---------------

#DEFINE GFS_CAMPO_NOMODIF			1	
#DEFINE GFS_CAMPO_MODIF				2 	
#DEFINE GFS_REG_NOMODIF				3 	
#DEFINE GFS_REG_MODIF				4	

* ---- SETFLDSTATE -------------------

#DEFINE SFS_CAMPO_NOMODIF			1	
#DEFINE SFS_CAMPO_MODIF				2 	
#DEFINE SFS_REG_NOMODIF				3 	
#DEFINE SFS_REG_MODIF				4	

* ----  COLORES DE GRILLA -------------

#DEFINE TA_DynamicBackColor "Iif(Mod(_RecordOrder,2)=1,Rgb(255,255,255),Rgb(220,240,220))"
#DEFINE TA_HeaderBackColor Rgb(220,220,200)

* ----- INPUTBOX.VCX ----------------
#DEFINE IB_DISPLAYCLASSLIBRARY	"Fw\Comunes\Vcx\Abm_Form.vcx"
#DEFINE IB_CHECKBOX				"crud_checkbox"
#DEFINE IB_COMBO				"cbo_base"
#DEFINE IB_DATE					"crud_date"
#DEFINE IB_EDITBOX				""
#DEFINE IB_LISTBOX				""
#DEFINE IB_NUMERIC				"crud_numerico"
#DEFINE IB_OPTION				""
#DEFINE IB_STRING				"crud_texto"

*------ Paginas de la clase Comprobante
#Define PG_Cabecera	1
#Define PG_Detalle	2
#Define PG_Pie		3

*------ GetFieldState() returns

#Define GFS_NOT_MODIFIED			1
#Define GFS_MODIFIED				2
#Define GFS_APPENDED_NOT_MODIFIED	3
#Define GFS_APPENDED_MODIFIED		4


*----------- ALIGN  (En Praxis.h)

***#Define 	ALIGN_LEFT				0
***#Define 	ALIGN_RIGHT				1
***#Define 	ALIGN_CENTER			2	
***#Define 	ALIGN_AUTOMATIC			3


*----------- SQL Stat
#DEFINE SQL_STAT_DEFAULT  	   1
#DEFINE SQL_STAT_SELECTOR      2
#DEFINE SQL_STAT_COMBO          3
#DEFINE SQL_STAT_KEYFINDER     4

