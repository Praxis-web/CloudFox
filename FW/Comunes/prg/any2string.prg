#INCLUDE "Fw\comunes\include\praxis.h"


* Any2String recibe un valor de cualquier tipo y devuelve el mismo
* transformado en un tipo Character
Procedure Any2String( tuValue ) As String
	Local lcCommand As String,;
		lcValue As String,;
		lcCentury As String,;
		lcDate As String
	Local lnHours As Integer

	Try


		lcCommand 	= ""
		lcCentury 	= Set("Century")
		lcDate 		= Set("Date")
		lnHours 	= Set("Hours")

		Set Century On
		Set Date To YMD
		Set Hours To 24

		Do Case
			Case Vartype(tuValue)=="X"
				lcValue = "None"

			Case Vartype(tuValue)=="T"
				If Ttoc(tuValue,2) = "00:00:00"
					lcValue = Strtran( Dtoc(Ttod(tuValue)), "/", "-" )
					
				Else
					lcValue = Strtran( Ttoc(tuValue), "/", "-" )
					
				Endif

			Case Vartype(tuValue)=="D"
				lcValue = Strtran( Dtoc(tuValue), "/", "-" )

			Case Vartype(tuValue)=="L"
				lcValue = Iif( tuValue, "True", "False" )

			Otherwise
				lcValue = Transform(tuValue)

		Endcase


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Set Century &lcCentury
		Set Date To &lcDate

		If lnHours = 12
			Set Hours To 12

		Else
			Set Hours To 24

		Endif

	Endtry

	Return Alltrim( lcValue )

Endproc && Any2String

