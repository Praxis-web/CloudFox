* Any2Char recibe un valor de cualquier tipo y devuelve el mismo
* transformado en un tipo Character

#INCLUDE "Fw\comunes\include\praxis.h"


Lparameters tuValue, cDelimiter
Local luValue As Variant,;
	lWithDelimiters As Boolean

Do Case
	Case Vartype( cDelimiter ) = "C"
		lWithDelimiters = .T.

	Case Vartype( cDelimiter ) = "L"
		lWithDelimiters = cDelimiter

	Otherwise
		lWithDelimiters = .F.

Endcase

Local lcOldSetCentury As String


Do Case
	Case Vartype(tuValue)=="X"
		luValue = ""

	Case Vartype(tuValue)=="T"
		lcOldSetCentury = Set("Century")
		lcOldSetDate = Set("Date")
		Set Century On
		Set Date To YMD
		luValue = Ttoc(tuValue)
		Set Century &lcOldSetCentury
		Set Date To &lcOldSetDate

	Case Vartype(tuValue)=="D"
		lcOldSetCentury = Set("Century")
		lcOldSetDate = Set("Date")
		Set Century On
		Set Date To YMD
		luValue = Dtoc(tuValue)
		Set Century &lcOldSetCentury
		Set Date To &lcOldSetDate

	Otherwise
		luValue = Transform(tuValue)

Endcase

If lWithDelimiters
	Do Case
		Case Vartype(tuValue)=="X"
			luValue = "Null"

		Case Vartype(tuValue)=="T"
			If Empty( tuValue )
				luValue = "{}"
			Else
				luValue = "{^" + luValue + "}"
			Endif

		Case Vartype(tuValue)=="D"
			If Empty( tuValue )
				luValue = "{}"
			Else
				luValue = "{^" + luValue + "}"
			Endif

		Case Vartype(tuValue)=="C"
			If Vartype( cDelimiter ) = "L"
				cDelimiter = "'"
			Endif
			luValue = Left( cDelimiter, 1) + luValue + Right( cDelimiter, 1)

		Otherwise

	Endcase

Endif

Return luValue