#INCLUDE "FW\TierAdapter\Include\TA.h" 
*
* Devuelve un valor aleatorio
*!*	PROCEDURE RandomValue( tcType AS String,;
*!*				tuLowValue AS Variant,;
*!*				tuHighValue AS Variant ) AS Variant;
*!*	        HELPSTRING "Devuelve un valor aleatorio"

#INCLUDE "FW\TierAdapter\Include\TA.h"

Lparameters tcType As String,;
	tuParam1 As Variant,;
	tuParam2 As Variant,;
	tuParam3 As Variant,;
	tuParam4 As Variant,;
	tuParam5 As Variant

#If .F.
	TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Devuelve un valor aleatorio
			*:Project:
			Sistemas Praxis
			*:Autor:
			Ricardo Aidelman
			*:Date:
			Viernes 12 de Junio de 2009 (09:28:07)
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			tcType AS String
			tuLowValue AS Variant
			tuHighValue AS Variant
			*:Remarks:
			*:Returns:
			Variant
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
	ENDTEXT
#Endif

Local luValue As Variant
Local i As Integer

Rand(Rand()*1000)

Do Case
	Case tcType == "X"
		luValue = Null

	Case Inlist( tcType, "T", "D" )
		Local lcOldSetDate As String
		Local lnOffset As Integer
		Local lnInt As Integer
		Local lnLow As Integer
		Local lnHigh As Integer
		Local tuLowValue As Date
		Local tuHighValue As Date

		tuHighValue = tuParam1
		tuLowValue = tuParam2

		lcOldSetDate = Set("Date")

		Set Date YMD

		If Empty( tuLowValue ) Or !Inlist( Vartype( tuLowValue ), "T", "D" )
			lnLow = 0
			If tcType = "T"
				tuLowValue = Datetime()

			Else
				tuLowValue = Date()

			Endif

		Else
			If tcType = "T"
				lnLow = Ttod( tuLowValue ) - Date()

			Else
				lnLow = tuLowValue - Date()

			Endif

		Endif

		If Empty( tuHighValue )Or !Inlist( Vartype( tuHighValue ), "T", "D" )
			lnHigh = 365

			If tcType = "T"
				tuHighValue = Datetime() + ( 365 * 24 * 60 * 60 )

			Else
				tuHighValue = Date() + 365

			Endif

		Else
			lnHigh = tuHighValue
			If tcType = "T"
				lnHigh = Ttod( tuHighValue ) - Date()

			Else
				lnHigh = tuHighValue - Date()

			Endif

		Endif

		lnInt = lnHigh - lnLow

		lnOffset =  Int( Rand() * lnInt )


		If tcType = "T"
			luValue = tuLowValue + ( lnOffset * ( 24 * 60 * 60 ) )

		Else
			luValue = tuLowValue + lnOffset

		Endif

		Set Date &lcOldSetDate

	Case Inlist( tcType, "C", "V" )
		Local lnLen As Integer
		Local lnAscii As Integer
		Local N As Integer

		lnLen = tuParam1

		If Empty( lnLen ) Or Vartype( lnLen ) # "N"
			lnLen = 10
		Endif

		lnLen = Min( lnLen, 250 )

		luValue = ""

		* La primer letra no puede estar vacía
		N = Int( Rand()*30 ) + 65

		If !Between( N, 65, 90 )
			N = Int( Rand()*20 ) + 65
		Endif

		luValue = luValue + Chr( N )

		For i = 2 To lnLen
			N = Int( Rand()*30 ) + 65

			If !Between( N, 65, 90 )
				N = 32
			Endif

			luValue = luValue + Chr( N )

		Endfor

	Case tcType == "N"
		Local lnWidth As Integer
		Local lnDecimal As Integer
		Local lnLowValue As Number
		Local lnHighValue As Number
		Local lnLen As Integer
		Local lnSetDecimal As Integer


		lnSetDecimal = Set("Decimals")

		lnWidth = tuParam1
		lnDecimal = tuParam2

		lnHighValue = tuParam3
		lnLowValue = tuParam4

		If Empty( lnDecimal ) Or Vartype( lnDecimal ) # "N"
			lnDecimal = 0
		Endif

		If Empty( lnWidth ) Or Vartype( lnWidth ) # "N"
			lnWidth = 1
			lnDecimal = 0

		Else
			If lnWidth - lnDecimal < 2 And !Empty( lnDecimal )
				lnWidth = lnDecimal + 2
			Endif

		Endif

		Set Decimals To lnDecimal


		If Empty( lnLowValue ) Or Vartype( lnLowValue ) # "N"
			lnLowValue = 0
		Endif


		If Empty( lnDecimal )
			lnLen = lnWidth

		Else
			lnLen = lnWidth - lnDecimal - 1

		Endif

		If Empty( lnHighValue ) Or Vartype( lnHighValue ) # "N"
			lnHighValue = Val( Replicate( "9", lnLen ) )
		Endif

		If lnHighValue > Val( Replicate( "9", lnLen ) )
			lnHighValue = Val( Replicate( "9", lnLen ) )
		Endif

		luValue = lnLowValue + Int( Rand() * ( lnHighValue - lnLowValue ) )

		If !Empty( lnDecimal )
			luValue = luValue + ( Int(Rand()*Val(Replicate("9",lnDecimal))) / (Val(Replicate("9",lnDecimal))+1 ))
		Endif

		luValue = Val( Str( luValue, lnWidth, lnDecimal ))

		Set Decimals To lnSetDecimal

	Case tcType == "I"
		Local lnWidth As Integer
		Local lnDecimal As Integer
		Local lnLowValue As Number
		Local lnHighValue As Number
		Local lnLen As Integer
		Local lnSetDecimal As Integer

		lnHighValue = tuParam1
		lnLowValue = tuParam2

		If Empty( lnLowValue ) 
			lnLowValue = 0
		Endif

		If Empty( lnHighValue ) Or lnHighValue > INTEGER_LIMIT
			lnHighValue = INTEGER_LIMIT
		Endif

		lnWidth = LenNum( lnHighValue )
		lnDecimal = 0

		luValue = RandomValue( "N", lnWidth, lnDecimal, lnHighValue, lnLowValue )

	Case tcType == "Y"
		lnWidth = tuParam1
		lnDecimal = tuParam2

		lnHighValue = tuParam3
		lnLowValue = tuParam4

		If Empty( lnDecimal ) Or Vartype( lnDecimal ) # "N"
			lnDecimal = Max(Set("Decimals"), 2 )
			lnWidth = lnWidth + lnDecimal + 1
		Endif

		If Empty( lnWidth ) Or Vartype( lnWidth ) # "N"
			lnWidth = lnDecimal + 4
		Endif

		luValue = RandomValue( "N", lnWidth, lnDecimal, lnHighValue, lnLowValue )

	Case tcType == "M"

		luValue = RandomValue( "C", 255 * 10 )

	Case tcType == "L"

		luValue = Mod( Int(Rand() * 9999), 2 ) = 0

	Otherwise
		luValue = Transform(tuValue)

Endcase

Return luValue

