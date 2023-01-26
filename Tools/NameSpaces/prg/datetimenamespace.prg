#INCLUDE 'Tools\namespaces\Include\System.h'
#INCLUDE "FW\Comunes\Include\Praxis.h"

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
Endif

#Define PD_YEARS "<<yy>>"
#Define PD_MONTHS "<<mm>>"
#Define PD_DAYS "<<dd>>"

#Define MONTH_01 "Enero"
#Define MONTH_02 "Febrero"
#Define MONTH_03 "Marzo"
#Define MONTH_04 "Abril"
#Define MONTH_05 "Mayo"
#Define MONTH_06 "Junio"
#Define MONTH_07 "Julio"
#Define MONTH_08 "Agosto"
#Define MONTH_09 "Septiembre"
#Define MONTH_10 "Octubre"
#Define MONTH_11 "Noviembre"
#Define MONTH_12 "Diciembre"

#Define DOW_01 	"Domingo"
#Define DOW_02 	"Lunes"
#Define DOW_03 	"Martes"
#Define DOW_04 	"Miércoles"
#Define DOW_05 	"Jueves"
#Define DOW_06 	"Viernes"
#Define DOW_07 	"Sábado"

#Define GD_FIRST_CURRENT_MONTH	1
#Define GD_FIRST_LAST_MONTH		2
#Define GD_FIRST_NEXT_MONTH		3
#Define GD_LAST_CURRENT_MONTH	4
#Define GD_LAST_LAST_MONTH		5
#Define GD_LAST_NEXT_MONTH		6

* DateTimeNameSpace
Define Class DateTimeNameSpace As NameSpaceBase Of 'Tools\namespaces\prg\ObjectNamespace.prg' 

	#If .F.
		Local This As DateTimeNameSpace Of 'Tools\namespaces\prg\DateTimeNameSpace.prg'
	#Endif

	Hidden m.aDias[ 7 ]
	Dimension m.aDias[ 7 ]

	Hidden m.aMeses[ 12 ]
	Dimension m.aMeses[ 12 ]

	*-- XML Metadata for customizable properties
	Protected m._MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="adias" type="property" display="aDias"/>] ;
		+ [<memberdata name="bom" type="method" display="BoM"/>] ;
		+ [<memberdata name="dateadd" type="method" display="DateAdd"/>] ;
		+ [<memberdata name="datemask" type="method" display="DateMask"/>] ;
		+ [<memberdata name="day" type="method" display="Day"/>] ;
		+ [<memberdata name="month" type="method" display="Month"/>] ;
		+ [<memberdata name="ndom" type="method" display="nDoM"/>] ;
		+ [<memberdata name="eom" type="method" display="EoM"/>] ;
		+ [<memberdata name="eoq" type="method" display="EoQ"/>] ;
		+ [<memberdata name="lastdow" type="method" display="LastDow"/>] ;
		+ [<memberdata name="orddow" type="method" display="OrdDow"/>] ;
		+ [<memberdata name="parsedays" type="method" display="ParseDays"/>] ;
		+ [<memberdata name="stod" type="method" display="StoD"/>] ;
		+ [</VFPData>]

	Dimension m.BoM_COMATTRIB[ 5 ]
	BoM_COMATTRIB[ 1 ] = 0
	BoM_COMATTRIB[ 2 ] = 'Devuelve el principio del mes - primer día.'
	BoM_COMATTRIB[ 3 ] = 'BoM'
	BoM_COMATTRIB[ 4 ] = 'Date'
	* BoM_COMATTRIB[ 5 ] = 0

	* BoM
	* Devuelve el principio del mes - primer día (Begin Of Month).
	Function BoM ( tdFecha As Datetime) As Date HelpString 'Devuelve el principio del mes - primer día.'
		* http://www.portalfox.com/index.php?name=News&file=article&sid=2746


		Local ldRet As Date, ;
			loErr As Exception
		Try
			ldRet = Date ( Year ( m.tdFecha), Month ( m.tdFecha ), 1 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tdFecha
			THROW_EXCEPTION

		Endtry

		Return m.ldRet

	Endfunc && BoM

	Dimension DateAdd_COMATTRIB[ 5 ]
	DateAdd_COMATTRIB[ 1 ] = 0
	DateAdd_COMATTRIB[ 2 ] = 'Devuelve una fecha sumandole una cantidad dada en un cierto intervalo o tipo de unidad.'
	DateAdd_COMATTRIB[ 3 ] = 'DateAdd'
	DateAdd_COMATTRIB[ 4 ] = 'Datetime'
	* DateAdd_COMATTRIB[ 5 ] = 0

	* DateAdd
	* Devuelve una fecha sumandole una cantidad dada en un cierto intervalo o tipo de unidad.
	Function DateAdd ( tcInterval As String, tnNumber As Integer, tdDateValue As Datetime ) As Datetime HelpString 'Devuelve una fecha sumandole una cantidad dada en un cierto intervalo o tipo de unidad.'

		* DAE 2009-07-31(22:14:05)
		Local ldRet As Datetime, ;
			loErr As Exception


		Try
			tcInterval = Lower ( Left ( Alltrim ( m.tcInterval ), 1 ) )

			* If Inlist ( m.tcInterval, 'd', 'm', 'y' )
			If m.tcInterval $ 'dmy'

				If Vartype ( m.tnNumber ) == 'N'

					* If Inlist ( Vartype ( m.tdDateValue ), 'D', 'T' )
					If Vartype ( m.tdDateValue ) $ 'DT'

						Do Case
							Case m.tcInterval == 'd'
								ldRet = m.tdDateValue + m.tnNumber

							Case m.tcInterval == 'm'
								ldRet = Gomonth ( m.tdDateValue, m.tnNumber )

							Case m.tcInterval == 'y'
								ldRet = Gomonth ( m.tdDateValue, 12 * m.tnNumber )

						Endcase

					Else
						Error 'tdDateValue no es convertible en Date o Datetime.'

					Endif && Inlist( Vartype( m.tdDateValue ), 'D', 'T' )

				Else
					Error 'El intervalo no es válido.'

				Endif && Vartype( m.tnNumber ) == 'N'

			Else
				Error 'El intervalo no es válido.'

			Endif && Inlist( m.tcInterval, 'd', 'm', 'y' )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcInterval, tnNumber, tdDateValue
			THROW_EXCEPTION

		Endtry

		Return m.ldRet

	Endfunc && DateAdd

	Dimension DateMask_COMATTRIB[ 5 ]
	DateMask_COMATTRIB[ 1 ] = 0
	DateMask_COMATTRIB[ 2 ] = 'Devuelve una expresión Date o DateTime como una cadena.'
	DateMask_COMATTRIB[ 3 ] = 'DateMask'
	DateMask_COMATTRIB[ 4 ] = 'String'
	* DateMask_COMATTRIB[ 5 ] = 0

	* DateMask
	* Devuelve una expresión Date o DateTime como una cadena.
	Function DateMask ( tdDate As Datetime, tcDateMask As String ) As String HelpString 'Devuelve una expresión Date o DateTime como una cadena.'

		* SINTAXIS: DateMask( [m.tdDate, ][m.tcDateMask] )
		* m.tdDate Expresion de fecha
		* m.tcDateMask Expresión tipo Character con la máscara del formato para la
		* devolución
		*
		* Devuelve una expresión Date o DateTime como un string
		* Si el primer parámetro se saltea, devuelve la fecha del sistema
		* El parametro cDateFormat es el string que se desea devolver, haciendo
		* una substitución del día, mes, año y hora según el siguiente criterio
		*
		* Número:
		* d9 Si es un dígito, se muestra solo un dígito
		* d99 Se muestran siempres dos dígitos, o un espacio y un dígito
		*
		* Día:
		* dd día en minúsculas jueves
		* DD día en mayúsculas JUEVES
		* Dd Primer letra en mayúscula Jueves
		*
		* Mes:
		* mm mes en minúsculas enero
		* MM mes en mayúsculas ENERO
		* Mm Primer letra en mayúscula Enero
		*
		* Año:
		* yy año con 2 dígitos 03
		* yyyy año con cuatro dígitos 2003
		* ( no distingue mayusculas de minúsculas )
		*
		* Hora:
		* HH Hora ( 24 horas )
		* hh Hora ( 12 horas + am/pm )
		* nn Minutos
		* ss Segundos


		Local lcDate As String, ;
			lcDay As String, ;
			lcHour12 As String, ;
			lcHour24 As String, ;
			lcMin As String, ;
			lcMonth As String, ;
			lcNDay As String, ;
			lcSec As String, ;
			lcType As String, ;
			lcYear As String, ;
			ll12 As Boolean, ;
			lnHour As numeric, ;
			lnLen As Number, ;
			lnLen1 As Number, ;
			loErr As Exception, ;
			luAux As numeric

		Try
			lcType = Vartype ( m.tdDate )
			If m.lcType == T_CHARACTER
				luAux      = m.tcDateMask
				tcDateMask = m.tdDate
				tdDate     = m.luAux

			Endif

			If m.lcType == T_LOGICAL
				tdDate = Datetime()

			Endif && m.lcType == T_LOGICAL

			If m.lcType # T_DATE And m.lcType # T_DATETIME
				tdDate = Datetime()

			Endif && m.lcType # T_DATE AND m.lcType # T_DATETIME

			If Vartype ( m.tcDateMask ) # T_CHARACTER
				tcDateMask = 'Dd d9 de Mm de yyyy'

			Endif && Vartype( m.tcDateMask ) # T_CHARACTER

			If Vartype ( m.tdDate ) == T_DATE
				tdDate = Dtot ( m.tdDate )

			Endif && Vartype( m.tdDate ) == T_DATE

			lcDay    = This.Day ( m.tdDate )
			lcMonth  = This.Month ( m.tdDate )
			lcYear   = Str ( Year ( m.tdDate ), 4 )
			lcNDay   = Str ( Day ( m.tdDate ), 2 )
			lnHour   = Hour ( m.tdDate )
			lcHour24 = Str ( m.lnHour, 2 )
			If m.lnHour > 12
				lcHour12 = Str ( m.lnHour - 12, 2 ) + 'pm'

			Else
				lcHour12 = Str ( m.lnHour, 2 ) + 'am'

			Endif && m.lnHour > 12
			lcMin = Transform ( Minute ( m.tdDate ), '@L 99' )
			lcSec = Transform ( Sec ( m.tdDate ), '@L 99' )

			lcDate = m.tcDateMask

			*/ reemplazar el nümero del día
			lnLen  = Atcc ( 'd9', m.lcDate )
			lnLen1 = Atcc ( 'd99', m.lcDate )
			If ! Empty ( m.lnLen )
				If ! Empty ( m.lnLen1 )
					lcDate = Stuff ( m.lcDate, m.lnLen1, 3, m.lcNDay )

				Else
					lcDate = Stuff ( m.lcDate, m.lnLen, 2, Alltrim ( m.lcNDay ) )

				Endif && ! Empty( m.lnLen1 )

			Endif && ! Empty( m.lnLen )

			*/ reemplazar el nombre del día
			lnLen = Atcc ( 'dd', m.lcDate )
			If ! Empty ( m.lnLen )
				lnLen1 = At_c ( 'dd', m.lcDate )
				If ! Empty ( m.lnLen1 )
					lcDate = Stuff ( m.lcDate, m.lnLen1, 2, Lower ( m.lcDay ) )

				Else
					lnLen1 = At_c ( 'DD', m.lcDate )
					If ! Empty ( m.lnLen1 )
						lcDate = Stuff ( m.lcDate, m.lnLen1, 2, Upper ( m.lcDay ) )

					Else
						lcDate = Stuff ( m.lcDate, m.lnLen, 2, FirstUp ( m.lcDay ) )

					Endif && ! Empty( m.lnLen1 )

				Endif && ! Empty( m.lnLen1 )

			Endif && ! Empty( m.lnLen )

			*/ reemplazar el nombre del mes
			lnLen = Atcc ( 'mm', m.lcDate )
			If ! Empty ( m.lnLen )
				lnLen1 = At_c ( 'mm', m.lcDate )
				If ! Empty ( m.lnLen1 )
					lcDate = Stuff ( m.lcDate, m.lnLen1, 2, Lower ( m.lcMonth ) )
				Else
					lnLen1 = At_c ( 'MM', m.lcDate )
					If ! Empty ( m.lnLen1 )
						lcDate = Stuff ( m.lcDate, m.lnLen1, 2, Upper ( m.lcMonth ) )

					Else
						lcDate = Stuff ( m.lcDate, m.lnLen, 2, FirstUp ( m.lcMonth ) )

					Endif && ! Empty( m.lnLen1 )

				Endif && ! Empty( m.lnLen1 )

			Endif && ! Empty( m.lnLen )

			*/ reemplazar el año
			lnLen = Atcc ( 'yy', m.lcDate )
			If ! Empty ( m.lnLen )
				lnLen1 = Atcc ( 'yyyy', m.lcDate )
				If ! Empty ( m.lnLen1 )
					lcDate = Stuff ( m.lcDate, m.lnLen1, 4, m.lcYear )

				Else
					lcDate = Stuff ( m.lcDate, m.lnLen, 2, Right ( m.lcYear, 2 ) )

				Endif && ! Empty( m.lnLen1 )

			Endif && ! Empty( m.lnLen )

			ll12 = .F.
			*/ reemplazar la hora ( 12 )
			lnLen = At_c ( 'hh', m.lcDate )
			If ! Empty ( m.lnLen )
				lcDate = Stuff ( m.lcDate, m.lnLen, 2, m.lcHour12 )
				ll12   = .T.

			Endif && ! Empty( m.lnLen )

			*/ reemplazar la hora ( 24 )
			lnLen = At_c ( 'HH', m.lcDate )
			If ! Empty ( m.lnLen )
				lcDate = Stuff ( m.lcDate, m.lnLen, 2, m.lcHour24 )
				ll12   = .F.

			Endif && ! Empty( m.lnLen )

			If m.ll12
				If m.lnHour > 12
					lcMin = m.lcMin + 'pm'
					lcSec = m.lcSec + 'pm'

				Else
					lcMin = m.lcMin + 'am'
					lcSec = m.lcSec + 'am'

				Endif && m.lnHour>12

			Endif && m.ll12

			*/ reemplazar los minutos
			lnLen = Atcc ( 'nn', m.lcDate )
			If ! Empty ( m.lnLen )
				lcDate = Stuff ( m.lcDate, m.lnLen, 2, m.lcMin )
				If m.ll12
					lnLen  = At_c ( m.lcHour12, m.lcDate )
					lcDate = Stuff ( m.lcDate, m.lnLen, Len ( m.lcHour12 ), Substr ( m.lcHour12, 1, 2 ) )

				Endif && m.ll12

				*/ reemplazar los segundos
				lnLen = Atcc ( 'ss', m.lcDate )
				If ! Empty ( m.lnLen )
					lcDate = Stuff ( m.lcDate, m.lnLen, 2, m.lcSec )
					If m.ll12
						lnLen  = At_c ( m.lcMin, m.lcDate )
						lcDate = Stuff ( m.lcDate, m.lnLen, Len ( m.lcMin ), Substr ( m.lcMin, 1, 2 ) )

					Endif && m.ll12

				Endif && ! Empty( m.lnLen )

			Endif && ! Empty( m.lnLen )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tdDate, tcDateMask
			THROW_EXCEPTION

		Endtry

		Return m.lcDate

	Endfunc && DateMask

	Dimension Day_COMATTRIB[ 5 ]
	Day_COMATTRIB[ 1 ] = 0
	Day_COMATTRIB[ 2 ] = 'Devuelve el nombre del día.'
	Day_COMATTRIB[ 3 ] = 'Day'
	Day_COMATTRIB[ 4 ] = 'String'
	* Day_COMATTRIB[ 5 ] = 0

	* Day
	* Devuelve el nombre del día.
	Function Day ( tdDate As Datetime ) As String HelpString 'Devuelve el nombre del día.'

		Local lcRetValue As String, ;
			loErr As Exception

		Try
			lcRetValue = This.aDias[ DOW ( m.tdDate ) ]

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tdDate
			THROW_EXCEPTION

		Endtry

		Return m.lcRetValue

	Endfunc && Day

	* Destroy
	Protected Procedure Destroy()
		With This As DateTimeNameSpace Of 'Tools\namespaces\prg\DateTimeNameSpace.prg'
			Store .F. To .aDias
			Store .F. To .aMeses

		Endwith

	Endproc && Destroy

	Dimension EoM_COMATTRIB[ 5 ]
	EoM_COMATTRIB[ 1 ] = 0
	EoM_COMATTRIB[ 2 ] = 'Devuelve el ultimo día del mes.'
	EoM_COMATTRIB[ 3 ] = 'EoM'
	EoM_COMATTRIB[ 4 ] = 'Datetime'
	* EoM_COMATTRIB[ 5 ] = 0

	* EoM
	* Devuelve el ultimo día del mes (End Of Month).
	Function EoM ( tdFecha As Datetime ) As Datetime HelpString 'Devuelve el ultimo día del mes.'
		* http://www.portalfox.com/index.php?name=News&file=article&sid=2746

		Local ldDate As Date, ;
			ldNextMonth As Date, ;
			ldRet As Date, ;
			lnMonth As Number, ;
			lnYear As Number, ;
			loErr As Exception

		Try
			lnYear      = Year ( m.tdFecha )
			lnMonth     = Month ( m.tdFecha )
			ldDate      = Date ( lnYear, lnMonth, 1 )
			ldNextMonth = Gomonth ( ldDate, 1 )
			ldRet       = ldNextMonth - 1

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tdFecha
			THROW_EXCEPTION

		Endtry

		Return m.ldRet

	Endfunc && EoM

	Dimension EoQ_COMATTRIB[ 5 ]
	EoQ_COMATTRIB[ 1 ] = 0
	EoQ_COMATTRIB[ 2 ] = 'Devuelve el ultiimo día del cuatrimestre.'
	EoQ_COMATTRIB[ 3 ] = 'EoQ'
	EoQ_COMATTRIB[ 4 ] = 'String'
	* EoQ_COMATTRIB[ 5 ] = 0

	* EOQ
	* Devuelve el ultiimo día del cuatrimestre (End Of Quarter).
	Function EoQ ( tdFecha As Datetime ) As Datetime HelpString 'Devuelve el ultiimo día del cuatrimestre.'
		* http://www.portalfox.com/index.php?name=News&file=article&sid=2746
		Local ldDate As Date, ;
			ldRet As Date, ;
			lnMonth As Number, ;
			lnMonthAux As Number, ;
			lnNextMonth As Number, ;
			lnYear As Number, ;
			loErr As Exception

		Try
			* ldRet = Gomonth ( Date ( Year ( m.tdFecha ), Ceiling ( Month ( m.tdFecha ) / 3 ) * 3, 1 ), 1 ) - 1
			lnYear      = Year ( m.tdFecha )
			lnMonth     = Month ( m.tdFecha )
			lnMonthAux  = Ceiling (lnMonth / 3 ) * 3
			ldDate      = Date ( lnYear, lnMonthAux, 1 )
			lnNextMonth = Gomonth ( ldDate, 1 )
			ldRet       = lnNextMonth - 1


		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tdFecha
			THROW_EXCEPTION

		Endtry

		Return m.ldRet

	Endfunc && EOQ

	Dimension GetDate_COMATTRIB[ 5 ]
	GetDate_COMATTRIB[ 1 ] = 0
	GetDate_COMATTRIB[ 2 ] = 'Devuelve una fecha relativa a la recibida según la acción de modificación solicitada.'
	GetDate_COMATTRIB[ 3 ] = 'GetDate'
	GetDate_COMATTRIB[ 4 ] = 'Datetime'
	* GetDate_COMATTRIB[ 5 ] = 0

	* GetDate
	* Devuelve una fecha relativa a la recibida según la acción de modificación solicitada.
	Function GetDate ( tdDate As Date, tnAction As Integer ) As Datetime HelpString 'Devuelve una fecha relativa a la recibida según la acción de modificación solicitada.'

		Local lcDate As String, ;
			ldDate As Date, ;
			ldDateAux As Date, ;
			lnDay As Integer, ;
			lnMonth As Integer, ;
			lnYear As Integer, ;
			loErr As Exception

		Try

			If ! Empty ( tdDate )
				lnMonth = Month ( tdDate )
				lnYear  = Year ( tdDate )

				Do Case
					Case Inlist ( tnAction, GD_FIRST_LAST_MONTH, GD_LAST_LAST_MONTH )
						lnMonth = Iif ( lnMonth == 1, 12, lnMonth - 1 )
						lnYear  = Iif ( lnMonth == 1, lnYear - 1, lnYear )

					Case Inlist ( tnAction, GD_FIRST_CURRENT_MONTH, GD_LAST_CURRENT_MONTH )
						lnMonth = lnMonth
						lnYear  = lnYear

					Case Inlist ( tnAction, GD_FIRST_NEXT_MONTH, GD_LAST_NEXT_MONTH )
						lnMonth = Iif ( lnMonth == 12, 1, lnMonth + 1 )
						lnYear  = Iif ( lnMonth == 12, lnYear + 1, lnYear )

					Otherwise
						Error 'GetDate() - Parametro no definido: ' + Transform ( tnAction )

				Endcase

				TEXT To lcDate Noshow Textmerge Pretext 15
				{^<<lnYear>>/<<lnMonth>>/01}
				ENDTEXT

				ldDateAux = Evaluate ( lcDate )
				Do Case
					Case Inlist ( tnAction, GD_FIRST_CURRENT_MONTH, GD_FIRST_LAST_MONTH, GD_FIRST_NEXT_MONTH )
						ldDate = ldDateAux

					Case Inlist ( tnAction, GD_LAST_CURRENT_MONTH, GD_LAST_LAST_MONTH, GD_LAST_NEXT_MONTH )
						ldDate = This.GetDate ( ldDateAux, GD_FIRST_NEXT_MONTH ) - 1

					Otherwise
						Error 'GetDate() - Parametro no definido: ' + Transform ( tnAction )

				Endcase

			Else && ! Empty( tdDate )
				ldDate = tdDate

			Endif && ! Empty( tdDate )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tdDate, tnAction
			THROW_EXCEPTION

		Endtry

		Return ldDate

	Endfunc && GetDate

	* Init
	* Constructor.
	Protected Procedure Init() As VOID HelpString 'Constructor.'

		Local loErr As Exception
		Try
			With This As DateTimeNameSpace Of 'Tools\namespaces\prg\DateTimeNameSpace.prg'
				* Días
				.aDias[ 1 ] = DOW_01
				.aDias[ 2 ] = DOW_02
				.aDias[ 3 ] = DOW_03
				.aDias[ 4 ] = DOW_04
				.aDias[ 5 ] = DOW_05
				.aDias[ 6 ] = DOW_06
				.aDias[ 7 ] = DOW_07

				* Meses
				.aMeses[ 1 ]  = MONTH_01
				.aMeses[ 2 ]  = MONTH_02
				.aMeses[ 3 ]  = MONTH_03
				.aMeses[ 4 ]  = MONTH_04
				.aMeses[ 5 ]  = MONTH_05
				.aMeses[ 6 ]  = MONTH_06
				.aMeses[ 7 ]  = MONTH_07
				.aMeses[ 8 ]  = MONTH_08
				.aMeses[ 9 ]  = MONTH_09
				.aMeses[ 10 ] = MONTH_10
				.aMeses[ 11 ] = MONTH_11
				.aMeses[ 12 ] = MONTH_12

			Endwith
		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

	Endproc && Init

	Dimension LastDOW_COMATTRIB[ 5 ]
	LastDOW_COMATTRIB[ 1 ] = 0
	LastDOW_COMATTRIB[ 2 ] = 'Devuelve el ultimo día especifico del mes y año dados.'
	LastDOW_COMATTRIB[ 3 ] = 'LastDOW'
	LastDOW_COMATTRIB[ 4 ] = 'String'
	* LastDOW_COMATTRIB[ 5 ] = 0

	* LastDOW
	* Devuelve el ultimo día especifico del mes y año dados.
	Function LastDOW ( tnDow As Number, tnMonth As Number, tnYear As Number ) As Datetime HelpString 'Devuelve el ultimo día especifico del mes y año dados.'
		* http://www.portalfox.com/index.php?name=News&file=article&sid=2746
		* tnDow: 1=Domingo ... 7=Sabado
		* tnMonth: 1=Enero ... 12=Diciembre
		* tnYear: 1900 ... 9999
		Local ld As Date, ;
			ldFirstDay As Date, ;
			ldLastDay As Date, ;
			ldRet As Date, ;
			lnDow As Number, ;
			loErr As Exception

		Try

			ldFirstDay = Date ( m.tnYear, m.tnMonth, 1 )
			ldLastDay  = Gomonth ( ldFirstDay, 1 ) - 1
			lnDow      = Dow ( m.ldLastDay )
			ldRet      = m.ldLastDay - ( lnDow - m.tnDow ) % 7

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnDow, tnMonth, tnYear
			THROW_EXCEPTION

		Endtry

		Return m.ldRet

	Endfunc && LastDOW

	Dimension Month_COMATTRIB[ 5 ]
	Month_COMATTRIB[ 1 ] = 0
	Month_COMATTRIB[ 2 ] = 'Devuelve el nombre del mes correspondiente a la fecha dada.'
	Month_COMATTRIB[ 3 ] = 'Month'
	Month_COMATTRIB[ 4 ] = 'String'
	* Month_COMATTRIB[ 5 ] = 0

	* Month
	* Devuelve el nombre del mes correspondiente a la fecha dada.
	Function Month ( tdDate As Datetime ) As String HelpString 'Devuelve el nombre del mes correspondiente a la fecha dada.'

		Local lcRetValue As String, ;
			loErr As Exception

		Try
			lcRetValue = This.aMeses[ Month ( m.tdDate ) ]

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tdDate
			THROW_EXCEPTION

		Endtry

		Return m.lcRetValue

	Endfunc && Month

	Dimension nDoM_COMATTRIB[ 5 ]
	nDoM_COMATTRIB[ 1 ] = 0
	nDoM_COMATTRIB[ 2 ] = 'Devuelve la cantidad de días que tiene el mes.'
	nDoM_COMATTRIB[ 3 ] = 'nDoM'
	nDoM_COMATTRIB[ 4 ] = 'Number'
	* nDoM_COMATTRIB[ 5 ] = 0

	* nDoM
	* Devuelve la cantidad de días que tiene el mes.
	Function nDoM ( tdFecha As Datetime ) As Number HelpString 'Devuelve la cantidad de días que tiene el mes.'
		* http://www.portalfox.com/index.php?name=News&file=article&sid=2746

		Local ldDate As Date, ;
			ldMonthLastDay As Date, ;
			ldNextMonth As Date, ;
			lnMonth As Number, ;
			lnRet As Number, ;
			lnYear As Number, ;
			loErr As Exception
		Try
			* lnRet = Day ( Gomonth ( Date ( Year ( m.tdFecha ), Month ( m.tdFecha ), 1 ), 1 ) - 1 )
			lnYear         = Year ( m.tdFecha )
			lnMonth        = Month ( m.tdFecha )
			ldDate         = Date ( lnYear, lnMonth, 1 )
			ldNextMonth    = Gomonth ( ldDate, 1 )
			ldMonthLastDay = ldNextMonth - 1
			lnRet          = Day ( ldMonthLastDay )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tdFecha
			THROW_EXCEPTION

		Endtry

		Return m.lnRet

	Endfunc && nDoM

	Dimension OrdDOW_COMATTRIB[ 5 ]
	OrdDOW_COMATTRIB[ 1 ] = 0
	OrdDOW_COMATTRIB[ 2 ] = 'Devuelve la fecha para el ordinal solicitado del día especifico de la semana en el mes y año dados.'
	OrdDOW_COMATTRIB[ 3 ] = 'OrdDOW'
	OrdDOW_COMATTRIB[ 4 ] = 'Datetime'
	* OrdDOW_COMATTRIB[ 5 ] = 0

	* OrdDOW
	* Devuelve la fecha para el ordinal solicitado del día especifico de la semana en el mes y año dados.
	Function OrdDOW ( tnOrd As Number, tnDow As Number, tnMonth As Number, tnYear As Number ) As Datetime HelpString 'Devuelve la fecha para el ordinal solicitado del día especifico de la semana en el mes y año dados.'
		* http://www.portalfox.com/index.php?name=News&file=article&sid=2746
		* tnOrd: 1=Primero, 2=Segundo, 3=Tercero, ...
		* tnDow: 1=Domingo ... 7=Sabado
		* tnMonth: 1=Enero ... 12=Diciembre
		* tnYear: 1900 ... 9999

		Local ldAux As Date, ;
			ldRet As Date, ;
			lnAux As Number, ;
			lnDow As Number, ;
			loErr As Exception
		Try
			* ldRet = Date ( m.tnYear, m.tnMonth, 1 ) + m.tnOrd * 7 - Dow ( Date ( m.tnYear, m.tnMonth, 1 ) + m.tnOrd * 7 - 1, m.tnDow )
			ldAux = Date ( m.tnYear, m.tnMonth, 1 )
			lnAux = m.tnOrd * 7
			lnDow = Dow ( ldAux + lnAux - 1, m.tnDow )
			ldRet = ldAux + lnAux - lnDow

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnOrd, tnDow, tnMonth, tnYear
			THROW_EXCEPTION

		Endtry

		Return m.ldRet

	Endfunc && OrdDOW

	Dimension ParseDays_COMATTRIB[ 5 ]
	ParseDays_COMATTRIB[ 1 ] = 0
	ParseDays_COMATTRIB[ 2 ] = 'Devuelve un string con la cantidad de días parseada en Años, meses y días.'
	ParseDays_COMATTRIB[ 3 ] = 'ParseDays'
	ParseDays_COMATTRIB[ 4 ] = 'String'
	* ParseDays_COMATTRIB[ 5 ] = 0

	* ParseDays
	* Devuelve un string con la cantidad de días parseada en Años, meses y días.
	Function ParseDays ( tnDays As Integer, tcMask As String ) As String HelpString 'Devuelve un string con la cantidad de días parseada en Años, meses y días.'

		Local lcParseDate As String, ;
			liDays As Integer, ;
			liMonths As Integer, ;
			liYears As Integer, ;
			lnDays As Number, ;
			lnMonths As Number, ;
			lnYears As Number, ;
			loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Devuelve un string con la cantidad de días parseada en Años, meses y días.
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			Ricardo Aidelman
			 *:Date:
			 Miércoles 21 de Mayo de 2008 ( 13:43:22 )
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try

			If Empty ( m.tcMask )
				tcMask = PD_YEARS + 'a ' + PD_MONTHS + 'm ' + PD_DAYS + 'd'

			Endif && Empty( m.tcMask )

			lnDays = m.tnDays
			liDays = Int ( m.tnDays )

			lnYears = m.tnDays / 365.25
			liYears = Int ( m.lnYears )

			lnMonths = m.lnYears * 12
			liMonths = Int ( m.lnMonths )

			If ! Empty ( At ( PD_YEARS, m.tcMask ) )
				lnMonths = ( m.lnYears - m.liYears ) * 12
				liMonths = Int ( m.lnMonths )

			Else
				liYears = 0

			Endif && ! Empty( At( PD_YEARS, m.tcMask ) )


			If Empty ( At ( PD_MONTHS, m.tcMask ) )
				liMonths = 0

			Endif && Empty( At( PD_MONTHS, m.tcMask ) )

			liDays = m.lnDays - Round ( ( m.liYears * 365.25 ) + ( m.liMonths * ( 365.25 / 12 ) ), 0 )

			If ! Empty ( At ( PD_YEARS, m.tcMask ) )
				lcParseDate = Stuff ( m.tcMask, At ( PD_YEARS, m.tcMask ), Len ( PD_YEARS ), Transform ( m.liYears ) )
				tcMask      = lcParseDate

			Else
				lcParseDate = m.tcMask

			Endif && ! Empty( At( PD_YEARS, m.tcMask ) )

			If ! Empty ( At ( PD_MONTHS, m.tcMask ) )
				lcParseDate = Stuff ( m.tcMask, At ( PD_MONTHS, m.tcMask ), Len ( PD_MONTHS ), Transform ( m.liMonths ) )
				tcMask      = m.lcParseDate

			Else
				lcParseDate = m.tcMask

			Endif && ! Empty( At( PD_MONTHS, m.tcMask ) )

			If ! Empty ( At ( PD_DAYS, m.tcMask ) )
				lcParseDate = Stuff ( m.tcMask, At ( PD_DAYS, m.tcMask ), Len ( PD_DAYS ), Transform ( m.liDays ) )
				tcMask      = lcParseDate

			Else
				lcParseDate = m.tcMask

			Endif && ! Empty( At( PD_DAYS, m.tcMask ) )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnDays, tcMask
			THROW_EXCEPTION

		Endtry

		Return m.lcParseDate

	Endfunc && ParseDays

	Dimension StoD_COMATTRIB[ 5 ]
	StoD_COMATTRIB[ 1 ] = 0
	StoD_COMATTRIB[ 2 ] = 'Devuelve una fecha convirtiendo la cadena recibida segune el formato de fecha seteado.'
	StoD_COMATTRIB[ 3 ] = 'StoD'
	StoD_COMATTRIB[ 4 ] = 'Date'
	* StoD_COMATTRIB[ 5 ] = 0

	* StoD
	* Devuelve una fecha convirtiendo la cadena recibida segune el formato de fecha seteado.
	Function StoD ( tcDate As String ) As Date HelpString 'Devuelve una fecha convirtiendo la cadena recibida segune el formato de fecha seteado.'

		Local lcDD As String, ;
			lcDate As String, ;
			lcMM As String, ;
			lcYY As String, ;
			ldDate As Date, ;
			loErr As Exception

		Try

			lcYY = Substr ( lcDate, 1, 4 )
			lcMM = Substr ( lcDate, 5, 2 )
			lcDD = Substr ( lcDate, 7, 2 )

			lcDate = Set ( 'Date' )

			Do Case
				Case lcDate $ 'AMERICAN|USA|MDY'
					ldDate = Ctod ( lcMM + '/' + lcDD + '/' + lcYY )

				Case lcDate $ 'ANSI|JAPAN|TAIWAN|YMD'
					ldDate = Ctod ( lcYY + '/' + lcMM + '/' + lcDD )

				Otherwise
					ldDate = Ctod ( lcDD + '/' + lcMM + '/' + lcYY )

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcDate
			THROW_EXCEPTION

		Endtry

		Return ldDate

	Endfunc && StoD

Enddefine && DateTimeNameSpace