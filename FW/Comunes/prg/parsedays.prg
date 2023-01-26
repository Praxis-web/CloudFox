*!* ///////////////////////////////////////////////////////
*!* Procedure.....: ParseDays
*!* Description...: Devuelve un string con la cantidad de días parseada en Años, meses y días
*!* Date..........: Miércoles 21 de Mayo de 2008 (13:43:22)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#Define PD_YEARS	"<<yy>>"
#Define PD_MONTHS	"<<mm>>"
#Define PD_DAYS		"<<dd>>"

Lparameters nDays As Integer, cMask As String

Local lnDays As Number
Local lnYears As Number
Local lnMonths As Number

Local liDays As Integer
Local liYears As Integer
Local liMonths As Integer

Try

	If Empty( cMask )
		cMask = PD_YEARS + "a " + PD_MONTHS + "m " + PD_DAYS + "d"
	Endif

	lnDays = nDays
	liDays = Int( nDays )

	lnYears = nDays / 365.25
	liYears = Int( lnYears )

	lnMonths = lnYears * 12
	liMonths = Int( lnMonths )

	If !Empty( At( PD_YEARS, cMask ))
		lnMonths = ( lnYears - liYears ) * 12
		liMonths = Int( lnMonths )

	Else
		liYears = 0

	Endif


	If Empty( At( PD_MONTHS, cMask ))
		liMonths = 0

	Endif

	liDays = lnDays - Round( ( liYears * 365.25 ) + ( liMonths * ( 365.25 / 12 )), 0 )


	If !Empty( At( PD_YEARS, cMask ))
		lcParseDate = Stuff( cMask, At( PD_YEARS, cMask ), Len( PD_YEARS ), Any2Char( liYears ) )
		cMask = lcParseDate

	Else
		lcParseDate = cMask

	Endif

	If !Empty( At( PD_MONTHS, cMask ))
		lcParseDate = Stuff( cMask, At( PD_MONTHS, cMask ), Len( PD_MONTHS ), Any2Char( liMonths ) )
		cMask = lcParseDate

	Else
		lcParseDate = cMask

	Endif


	If !Empty( At( PD_DAYS, cMask ))
		lcParseDate = Stuff( cMask, At( PD_DAYS, cMask ), Len( PD_DAYS ), Any2Char( liDays ) )
		cMask = lcParseDate

	Else
		lcParseDate = cMask

	Endif

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return lcParseDate

*!*
*!* END PROCEDURE ParseDays
*!*
*!* ///////////////////////////////////////////////////////