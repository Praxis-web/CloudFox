#INCLUDE "FW\Comunes\Include\Praxis.h"



Parameters dDate,cDateMask

External Procedure FirstUp.prg,;
	Dia.prg,;
	Mes.prg,;
	StrZero.prg



* SINTAXIS: DateMask([dDate,][cDateMask])
* dDate		Expresion de fecha
* cDateMask	Expresión tipo Character con la máscara del formato para la
*           devolución
*
* Devuelve una expresión Date o DateTime como un string
* Si el primer parámetro se saltea, devuelve la fecha del sistema
* El parametro cDateFormat es el string que se desea devolver, haciendo
* una substitución del día, mes, año y hora según el siguiente criterio
*
* Número:
* 	d9  Si es un dígito, se muestra solo un dígito
* 	d99 Se muestran siempres dos dígitos, o un espacio y un dígito
*
* Día:
* 	dd	día en minúsculas 			jueves
* 	DD	día en mayúsculas			JUEVES
* 	Dd	Primer letra en mayúscula	Jueves
*
* Mes:
* 	mm	mes en minúsculas 			enero
* 	MM	mes en mayúsculas			ENERO
* 	Mm	Primer letra en mayúscula	Enero
*
* Año:
* 	yy	 año con 2 dígitos			03
* 	yyyy año con cuatro dígitos		2003
* 	(no distingue mayusculas de minúsculas)
*
* Hora:
* 	HH	Hora (24 horas)
* 	hh  Hora (12 horas + am/pm)
* 	nn  Minutos
* 	ss	Segundos


Local lcDate,lcDay,lcMonth,lcYear,lcNDay,lcHour12,lcHour24,lcMin,lcSec
Local lnHour,luAux,ll12

Local lcCommand As String

Try

	lcCommand 	= ""
	lcDate 		= ""

	If Type("dDate")==T_CHARACTER
		luAux 		= cDateMask
		cDateMask 	= dDate
		dDate 		= luAux
	Endif

	If Type("dDate")==T_LOGICAL
		dDate = Datetime()
	Endif

	If Type("dDate")<>T_DATE .And. Type("dDate")<>T_DATETIME
		dDate = Datetime()
	Endif

	If Type("cDateMask")<>T_CHARACTER
		cDateMask = 'Dd d9 de Mm de yyyy'
	Endif

	If Type("dDate")==T_DATE
		dDate = Dtot(dDate)
	Endif

	If !Empty( dDate )

		lcDay 		= DIA(dDate)
		lcMonth 	= MES(dDate)
		lcYear 		= Str(Year(dDate),4)
		lcNDay 		= Str(Day(dDate),2)
		lnHour 		= Hour(dDate)
		lcHour24 	= Str(lnHour,2)

		If lnHour>12
			lcHour12 = Str(lnHour-12,2)+"pm"
		Else
			lcHour12 = Str(lnHour,2)+"am"
		Endif

		lcMin 	= StrZero(Minute(dDate),2)
		lcSec 	= StrZero(Sec(dDate),2)


		lcDate 	= cDateMask

		*/ reemplazar el nümero del día
		lnLen	= Atcc("d9",lcDate)
		lnLen1	= Atcc("d99",lcDate)
		If !Empty(lnLen)
			If !Empty(lnLen1)
				lcDate = Stuff(lcDate,lnLen1,3,lcNDay)
			Else
				lcDate = Stuff(lcDate,lnLen,2,Alltrim(lcNDay))
			Endif
		Endif

		*/ reemplazar el nombre del día
		lnLen= Atcc("dd",lcDate)
		If !Empty(lnLen)
			lnLen1 = At_c("dd",lcDate)
			If !Empty(lnLen1)
				lcDate = Stuff(lcDate,lnLen1,2,Lower(lcDay))
			Else
				lnLen1 = At_c("DD",lcDate)
				If !Empty(lnLen1)
					lcDate = Stuff(lcDate,lnLen1,2,Upper(lcDay))
				Else
					lcDate = Stuff(lcDate,lnLen,2,FirstUp(lcDay))
				Endif
			Endif
		Endif

		*/ reemplazar el nombre del mes
		lnLen = Atcc("mm",lcDate)
		If !Empty(lnLen)
			lnLen1 = At_c("mm",lcDate)
			If !Empty(lnLen1)
				lcDate = Stuff(lcDate,lnLen1,2,Lower(lcMonth))
			Else
				lnLen1 = At_c("MM",lcDate)
				If !Empty(lnLen1)
					lcDate = Stuff(lcDate,lnLen1,2,Upper(lcMonth))
				Else
					lcDate = Stuff(lcDate,lnLen,2,FirstUp(lcMonth))
				Endif
			Endif
		Endif

		*/ reemplazar el año
		lnLen = Atcc("yy",lcDate)
		If !Empty(lnLen)
			lnLen1 = Atcc("yyyy",lcDate)
			If !Empty(lnLen1)
				lcDate = Stuff(lcDate,lnLen1,4,lcYear)
			Else
				lcDate = Stuff(lcDate,lnLen,2,Right(lcYear,2))
			Endif
		Endif

		ll12=.F.
		*/ reemplazar la hora (12)
		lnLen = At_c("hh",lcDate)
		If !Empty(lnLen)
			lcDate = Stuff(lcDate,lnLen,2,lcHour12)
			ll12=.T.
		Endif

		*/ reemplazar la hora (24)
		lnLen = At_c("HH",lcDate)
		If !Empty(lnLen)
			lcDate = Stuff(lcDate,lnLen,2,lcHour24)
			ll12=.F.
		Endif

		If ll12
			If lnHour>12
				lcMin 	= lcMin + "pm"
				lcSec 	= lcSec + "pm"
			Else
				lcMin 	= lcMin + "am"
				lcSec 	= lcSec + "am"
			Endif
		Endif

		*/ reemplazar los minutos
		lnLen = Atcc("nn",lcDate)
		If !Empty(lnLen)
			lcDate = Stuff(lcDate,lnLen,2,lcMin)
			If ll12
				lnLen = At_c(lcHour12,lcDate)
				lcDate = Stuff(lcDate,lnLen,Len(lcHour12),Substr(lcHour12,1,2))
			Endif

			*/ reemplazar los segundos
			lnLen = Atcc("ss",lcDate)
			If !Empty(lnLen)
				lcDate = Stuff(lcDate,lnLen,2,lcSec)
				If ll12
					lnLen = At_c(lcMin,lcDate)
					lcDate = Stuff(lcDate,lnLen,Len(lcMin),Substr(lcMin,1,2))
				Endif
			Endif

		Endif
	Endif

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.cRemark = lcCommand
	loError.Process( oErr )
	Throw loError

Finally


Endtry

Return lcDate