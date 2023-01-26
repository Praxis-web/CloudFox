#INCLUDE "Fw\comunes\Include\Praxis.h"

* ForceType recibe un valor de cualquier tipo y devuelve el mismo 
* transformado en un tipo determinado

Lparameters tuValue,tcType
Local luValue,lcType
lcType = Vartype(tuValue)
Do Case
	Case lcType==tcType
		*/ Si el tipo es igual, devolver el valor sin modificarlo
		luValue=tuValue

	Case lcType==T_CHARACTER
		*/ Transformar el valor al Tipo deseado
		luValue = Char2Any(tuValue,tcType)

	Othe
		*/ Transformar el valor a Character
		luValue = Any2Char(tuValue)
		*/ Ejecutar en forma recursiva hasta obtener el tipo
		luValue=ForceType(luValue,tcType)

Endcase

Return luValue