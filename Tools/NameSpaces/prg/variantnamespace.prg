#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'

If .F.
	Do 'Tools\Namespaces\prg\ObjectNamespace.prg'
Endif

* VariantNameSpace
Define Class VariantNameSpace As ObjectNamespace Of Tools\NameSpaces\prg\ObjectNamespace.prg

	#If .F.
		Local This As VariantNameSpace Of 'Tools\Namespaces\Prg\VariantNameSpace.prg'
	#Endif

	*-- XML Metadata for customizable properties
	Protected m._MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="defaultvalue" type="method" display="DefaultValue" />] ;
		+ [<memberdata name="randomvalue" type="method" display="RandomValue" />] ;
		+ [</VFPData>]

	* DefaultValue
	Function DefaultValue ( tcVarName as String, tuDefaultValue As Variant ) As Variant HelpString 'Devuelve el valor de la variable o el valor predeterminado.'

		Local lcTypeVar As String, ;
			loErr As Exception, ;
			luReturn As Variant

		Note: Devolver un valor predeterminado

		Try
			lcTypeVar = Type ( m.tcVarName )
			Do Case
				Case m.lcTypeVar == 'U'  Or ( m.lcTypeVar # Vartype ( m.tuDefaultValue ) )
					luReturn = m.luDefaultValue

				Case Type ( 'tcVarName' ) = 'C'
					luReturn = &tcVarName.

				Otherwise
					luReturn = m.luDefaultValue

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcVarName, tuDefaultValue
			THROW_EXCEPTION

		Endtry

		Return luReturn

	EndFunc && DefaultValue 

	* RandomValue
	* Devuelve un valor aleatorio.
	Function RandomValue ( tcType As String, tuParam1 As Variant, tuParam2 As Variant, tuParam3 As Variant, tuParam4 As Variant, tuParam5 As Variant ) As Variant HelpString 'Devuelve un valor aleatorio.'

		Local lcOldSetDate As String, ;
			liIdx As Integer, ;
			liN As Integer, ;
			lnAscii As Integer, ;
			lnDecimal As Integer, ;
			lnHigh As Integer, ;
			lnHighValue As Number, ;
			lnInt As Integer, ;
			lnLen As Integer, ;
			lnLow As Integer, ;
			lnLowValue As Number, ;
			lnOffset As Integer, ;
			lnSetDecimal As Integer, ;
			lnWidth As Integer, ;
			loErr As Object, ;
			luHighValue As Variant, ;
			luLowValue As Variant, ;
			luValue As Variant

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

		Try
			Rand  ( Rand() * 1000 )

			Do Case
				Case tcType == 'X'
					luValue = Null

				Case tcType $ 'TD'
					luHighValue = tuParam1
					luLowValue  = tuParam2

					lcOldSetDate = Set ('Date')

					Set Date YMD

					* If Empty ( tuLowValue ) Or ! Inlist ( Vartype ( tuLowValue ), 'T', 'D' )
					If Empty ( luLowValue ) Or ! ( Vartype ( luLowValue ) $ 'TD' )
						lnLow = 0
						If tcType == 'T'
							luLowValue = Datetime()

						Else && tcType == 'T'
							luLowValue = Date()

						Endif && tcType == 'T'

					Else && Empty ( tuLowValue ) Or ! ( Vartype ( tuLowValue ) $ 'TD' )
						If tcType == 'T'
							lnLow = Ttod ( luLowValue ) - Date()

						Else && tcType == 'T'
							lnLow = luLowValue - Date()

						Endif && tcType == 'T'

					Endif && Empty ( tuLowValue ) Or ! ( Vartype ( tuLowValue ) $ 'TD' )

					* If Empty ( tuHighValue )Or !Inlist ( Vartype ( tuHighValue ), 'T', 'D' )
					If Empty ( luHighValue )Or ! ( Vartype ( luHighValue ) $ 'TD' )
						lnHigh = 365

						If tcType == 'T'
							luHighValue = Datetime() + ( 365 * 24 * 60 * 60 )

						Else && tcType == 'T'
							luHighValue = Date() + 365

						Endif && tcType == 'T'

					Else && Empty ( luHighValue )Or ! ( Vartype ( luHighValue ) $ 'TD' )
						lnHigh = luHighValue
						If tcType == 'T'
							lnHigh = Ttod ( luHighValue ) - Date()

						Else && tcType == 'T'
							lnHigh = luHighValue - Date()

						Endif && tcType == 'T'

					Endif && Empty ( luHighValue )Or ! ( Vartype ( luHighValue ) $ 'TD' )

					lnInt    = lnHigh - lnLow
					lnOffset =  Int ( Rand() * lnInt )

					If tcType == 'T'
						luValue = luLowValue + ( lnOffset * ( 24 * 60 * 60 ) )

					Else
						luValue = luLowValue + lnOffset

					Endif

					Set Date &lcOldSetDate.

					* Case Inlist ( tcType, 'C', 'V' )
				Case tcType $ 'CV'

					lnLen = tuParam1

					If Empty ( lnLen ) Or Vartype ( lnLen ) # 'N'
						lnLen = 10

					Endif && Empty ( lnLen ) Or Vartype ( lnLen ) # 'N'

					lnLen   = Min ( lnLen, 250 )
					luValue = ''

					* La primer letra no puede estar vacía
					liN = Int ( Rand() * 30 ) + 65

					If ! Between ( liN, 65, 90 )
						liN = Int ( Rand() * 20 ) + 65

					Endif

					luValue = luValue + Chr ( liN )

					For liIdx = 2 To lnLen
						liN = Int ( Rand() * 30 ) + 65

						If ! Between ( liN, 65, 90 )
							liN = 32

						Endif

						luValue = luValue + Chr ( liN )

					Endfor

				Case tcType == 'N'

					lnSetDecimal = Set ('Decimals')
					lnWidth      = tuParam1
					lnDecimal    = tuParam2
					lnHighValue  = tuParam3
					lnLowValue   = tuParam4

					If Empty ( lnDecimal ) Or Vartype ( lnDecimal ) # 'N'
						lnDecimal = 0

					Endif && Empty ( lnDecimal ) Or Vartype ( lnDecimal ) # 'N'

					If Empty ( lnWidth ) Or Vartype ( lnWidth ) # 'N'
						lnWidth   = 1
						lnDecimal = 0

					Else && Empty ( lnWidth ) Or Vartype ( lnWidth ) # 'N'
						If lnWidth - lnDecimal < 2 And !Empty ( lnDecimal )
							lnWidth = lnDecimal + 2

						Endif && lnWidth - lnDecimal < 2 And !Empty ( lnDecimal )

					Endif && && Empty ( lnWidth ) Or Vartype ( lnWidth ) # 'N'

					Set Decimals To lnDecimal


					If Empty ( lnLowValue ) Or Vartype ( lnLowValue ) # 'N'
						lnLowValue = 0

					Endif && Empty ( lnLowValue ) Or Vartype ( lnLowValue ) # 'N'

					If Empty ( lnDecimal )
						lnLen = lnWidth

					Else && Empty ( lnDecimal )
						lnLen = lnWidth - lnDecimal - 1

					Endif && Empty ( lnDecimal )

					If Empty ( lnHighValue ) Or Vartype ( lnHighValue ) # 'N'
						lnHighValue = Val ( Replicate ( '9', lnLen ) )

					Endif && Empty ( lnHighValue ) Or Vartype ( lnHighValue ) # 'N'

					If lnHighValue > Val ( Replicate ( '9', lnLen ) )
						lnHighValue = Val ( Replicate ( '9', lnLen ) )

					Endif && lnHighValue > Val ( Replicate ( '9', lnLen ) )

					luValue = lnLowValue + Int ( Rand() * ( lnHighValue - lnLowValue ) )

					If ! Empty ( lnDecimal )
						luValue = luValue + ( Int (Rand() * Val (Replicate ('9', lnDecimal))) / (Val (Replicate ('9', lnDecimal)) + 1 ))

					Endif && ! Empty ( lnDecimal )

					luValue = Val ( Str ( luValue, lnWidth, lnDecimal ))

					Set Decimals To lnSetDecimal

				Case tcType == 'I'

					lnHighValue = tuParam1
					lnLowValue  = tuParam2

					If Empty ( lnLowValue )
						lnLowValue = 0

					Endif && Empty ( lnLowValue )

					If Empty ( lnHighValue ) Or lnHighValue > INTEGER_LIMIT
						lnHighValue = INTEGER_LIMIT

					Endif && Empty ( lnHighValue ) Or lnHighValue > INTEGER_LIMIT

					lnWidth   = m.Number.LenNum ( lnHighValue )
					lnDecimal = 0
					luValue   = m.This.RandomValue ( 'N', lnWidth, lnDecimal, lnHighValue, lnLowValue )

				Case tcType == 'Y'
					lnWidth     = tuParam1
					lnDecimal   = tuParam2
					lnHighValue = tuParam3
					lnLowValue  = tuParam4

					If Empty ( lnDecimal ) Or Vartype ( lnDecimal ) # 'N'
						lnDecimal = Max ( Set ( 'Decimals' ), 2 )
						lnWidth   = lnWidth + lnDecimal + 1

					Endif && Empty ( lnDecimal ) Or Vartype ( lnDecimal ) # 'N'

					If Empty ( lnWidth ) Or Vartype ( lnWidth ) # 'N'
						lnWidth = lnDecimal + 4

					Endif && Empty ( lnWidth ) Or Vartype ( lnWidth ) # 'N'

					luValue = m.This.RandomValue ( 'N', lnWidth, lnDecimal, lnHighValue, lnLowValue )

				Case tcType == 'M'
					luValue = m.This.RandomValue ( 'C', 255 * 10 )

				Case tcType == 'L'
					luValue = Mod ( Int (Rand() * 9999), 2 ) = 0

				Otherwise
					luValue = Transform (tuValue)

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcType, tuParam1, tuParam2, tuParam3, tuParam4, tuParam5
			THROW_EXCEPTION

		Endtry

		Return luValue

	Endfunc && RandomValue

Enddefine && VariantNameSpace