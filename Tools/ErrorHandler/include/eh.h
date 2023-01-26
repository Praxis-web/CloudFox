* #INCLUDE "FW\Comunes\Include\Praxis.h"

*---------------- File Locations ---------------
#DEFINE EH_DEFAULT		"FW\ErrorHandler"


#Define EH_ERR_1884 "Intento de ingresar una clave existente" + CR + "Proceso cancelado"

#Define EH_SHOWERROR	1
#Define EH_LOGERROR		2
#Define EH_QUIET		0

*---------- Nombre del cursor de errores --------------------------
#DEFINE EH_CURSORNAME		"ErrorEspecificationsFile"
* ----------- ErrorHandler() ------------------

*--- ParseXML Tags
#DEFINE ERROR_TAG		"#<ERR>#"
#DEFINE WARNING_TAG		"#<WARNING>#"
#DEFINE USER_TAG		"#<USER>#"
#DEFINE BIZ_TAG			"#<BIZ>#"

*-- Caracteres para insertar en un string
#DEFINE CRLF		CHR(13) + CHR(10)
#DEFINE CR			CHR(13)
#DEFINE TAB			CHR(9)
#DEFINE C_NULL		CHR(0)