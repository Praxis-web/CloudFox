#INCLUDE "FW\Comunes\Include\Praxis.h"



Parameters dDate,cDateMask

External Procedure FirstUp.prg,;
	Dia.prg,;
	Mes.prg,;
	StrZero.prg



* SINTAXIS: DateMask([dDate,][cDateMask])
* dDate		Expresion de fecha
* cDateMask	Expresi�n tipo Character con la m�scara del formato para la
*           devoluci�n
*
* Devuelve una expresi�n Date o DateTime como un string
* Si el primer par�metro se saltea, devuelve la fecha del sistema
* El parametro cDateFormat es el string que se desea devolver, haciendo
* una substituci�n del d�a, mes, a�o y hora seg�n el siguiente criterio
*
* N�mero:
* 	d9  Si es un d�gito, se muestra solo un d�gito
* 	d99 Se muestran siempres dos d�gitos, o un espacio y un d�gito
*
* D�a:
* 	dd	d�a en min�sculas 			jueves
* 	DD	d�a en may�sculas			JUEVES
* 	Dd	Primer letra en may�scula	Jueves
*
* Mes:
* 	mm	mes en min�sculas 			enero
* 	MM	mes en may�sculas			ENERO
* 	Mm	Primer letra en may�scula	Enero
*
* A�o:
* 	yy	 a�o con 2 d�gitos			03
* 	yyyy a�o con cuatro d�gitos		2003
* 	(no distingue mayusculas de min�sculas)
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

		*/ reemplazar el n�mero del d�a
		lnLen	= Atcc("d9",lcDate)
		lnLen1	= Atcc("d99",lcDate)
		If !Empty(lnLen)
			If !Empty(lnLen1)
				lcDate = Stuff(lcDate,lnLen1,3,lcNDay)
			Else
				lcDate = Stuff(lcDate,lnLen,2,Alltrim(lcNDay))
			Endif
		Endif

		*/ reemplazar el nombre del d�a
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

		*/ reemplazar el a�o
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