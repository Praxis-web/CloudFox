* Convierte un string al modelo apropiado de Mayusculas/Minusculas
* aceptando un separador

Lparameters cExpression As String, ;
	cSepBefore As Character, ;
	cSepAfter As Character

Local lcString As String

If IsEmpty( cSepBefore )
	cSepBefore = " "
Endif

If IsEmpty( cSepAfter )
	cSepAfter = cSepBefore
Endif


lcString = Chrtran( cExpression, cSepBefore, " " )
lcString = Proper( lcString )
lcString = Chrtran( lcString, " ", cSepAfter )

Return lcString
