* Char2Any recibe un valor tipo Character y devuelve el mismo transformado 
* en un tipo determinado

#INCLUDE "FW\Comunes\Include\Praxis.h" 

Lparameters tuValue,tcType
Local luValue

Do Case
	Case tcType == T_NUMERIC
		luValue = Val(tuValue)

	Case tcType== T_DATE
		luValue = Ctod(tuValue)

	Case tcType== T_DATETIME
		luValue = Ctot(tuValue)

	Case tcType== T_MEMO
		*/ No hace nada

	Case tcType== T_LOGICAL
		If  tuValue$"SYV"
			luValue = .T.
		Else
			luValue = .F.
		Endif
	Othe
		mbNoPrevista( Lineno(), "El tipo &tcType. no es válido")
		luValue=tuValue
Endcase

Return luValue