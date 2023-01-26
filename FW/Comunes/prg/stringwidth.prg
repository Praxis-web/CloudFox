* Genera una cadena representativa del tipo de dato, que se utiliza 
* Para calcular el ancho en pixeles del control
* tcTipo		=	Tipo de Dato
* tnLen			=	Longitud de la cadena
* tcFontName	=	Nombre de la Fuente
* tcFontSize	=	Tamaño de la Fuente
* tcFontStyle	=	Estilo de la Fuente

#INCLUDE "FW\Comunes\Include\Praxis.h" 

Lparameters tcTipo		,;
	tnLEN		,;
	tcFontName	,;
	tcFontSize	,;
	tcFontStyle

Local lcStr,lnWidth

Do Case
	Case tcTipo = T_CHARACTER
		lcStr	=	"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	Case tcTipo = T_NUMERIC
		lcStr	=	"0123456789"
	Case tcTipo = T_DATE
		lcStr	=	"99/99/9999"
Endcase

lnWidth	=	Fontmetric(TM_AVECHARWIDTH,;
	tcFontName,;
	tcFontSize,;
	tcFontStyle) * tnLEN

Return lnWidth