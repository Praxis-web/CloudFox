
*-- STRINGS.H

*--- Mansajes comunes
#DEFINE	S_TRANSACTION_OK 		"La Transacción se completó exitosamente"
#DEFINE	S_TRANSACTION_NOT_OK 	"La Transacción no pudo completarse"

#DEFINE S_NOACCESS 			"No tiene acceso a esta función"
#DEFINE S_NOTIMPLEMENTED 	"La opción aún no ha sido implementada"

#DEFINE S_CONFIRMDELETION 	"¿Borra este dato?"
#DEFINE S_DISCARDCHANGES 	"¿Abandona los cambios?"
#DEFINE S_EXITAPPLICATION 	"¿Abandona la aplicación?"
#DEFINE S_CLOSEFORM		 	"¿Cierra la Ventana?"

#DEFINE S_RANGE_NOT_FOUND	"No se han encontrado datos" + Chr(10) + Chr(13) + "en el rango especificado"

#DEFINE S_NOFILTERSELECTED "No se seleccionó ningún filtro"
#DEFINE S_FROMGREATERTHANTO 	"El campo DESDE es mayor que HASTA"
#DEFINE S_VALOBL				"El dato es obligatorio"


#Define S_BEGINWITH			"Comienza Con"
#Define S_CONTAINTHETEXT	"Contiene El Texto"
#Define S_EQUAL				"Es Igual A"
#Define S_DIFFERENT			"Es Diferente A"
#Define S_LOWER				"Es Menor Que"
#Define S_LOWEREQUAL		"Es Menor O Igual A"
#Define S_UPPER				"Es Mayor Que"
#Define S_UPPEREQUAL		"Es Mayor O Igual A"
#Define S_ISBETWEEN			"Se Encuentra Entre"

#DEFINE S_INPROCESS 		"Procesando ..."
#DEFINE S_DONE 				"Proceso Finalizado"

*------ Definicion de los nombres de días y meses en español

#DEFINE MONTH_01			"Enero"
#DEFINE MONTH_02			"Febrero"
#DEFINE MONTH_03			"Marzo"
#DEFINE MONTH_04			"Abril"
#DEFINE MONTH_05			"Mayo"
#DEFINE MONTH_06			"Junio"
#DEFINE MONTH_07			"Julio"
#DEFINE MONTH_08			"Agosto"
#DEFINE MONTH_09			"Septiembre"
#DEFINE MONTH_10			"Octubre"
#DEFINE MONTH_11			"Noviembre"
#DEFINE MONTH_12			"Diciembre"

#DEFINE DOW_01				"Domingo"
#DEFINE DOW_02				"Lunes"
#DEFINE DOW_03				"Martes"
#DEFINE DOW_04				"Miércoles"
#DEFINE DOW_05				"Jueves"
#DEFINE DOW_06				"Viernes"
#DEFINE DOW_07				"Sábado"

*---------- Formateo por defecto usado por F_Today()

#DEFINE DEFAULT_DATETIME_FORMAT		"Dd d9 de Mm de yyyy"

*---------- Mensajes de Error
#DEFINE ERR_1300			"Faltan cerrar paréntesis"
#DEFINE ERR_1304			"Faltan abrir paréntesis"
#DEFINE ERR_1307			"Chequear división por cero"
#DEFINE ERR_10				"Error de sintáxis"
#DEFINE ERR_152				"Error de expresión"
#DEFINE ERR_39				"Desborde en el resultado de la expresión"
#DEFINE ERR_1231			"Falta un operando"