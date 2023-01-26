*
* Autor: Rub�n O. Rovira
* Fecha: 08/03/2004
*
* Parametros:
*		1) tcWord		- Palabra a buscar
*		2) tcWordList	- Lista de palabras
*		3) tcDelimiter	- Delimitador de palabras (se usa COMA por default)
*
* Busca que la palabra tcWord exista con exactitud en la
* lista de palabras tcWordList separadas tcDelimiter.
*
* Retorna el n�mero de veces que se encontr� tcWord dentro de tcWordList
*

Lparameters tcWord, tcWordList, tcDelimiter

Local lcDelimiter As String, lnWords As Integer, lnRetVal As Boolean

lcDelimiter = IfEmpty( tcDelimiter, [,] )
lnWords = Getwordcount( tcWordList, lcDelimiter )
lnRetVal = 0

For i = 1 To lnWords
	If Alltrim( tcWord ) == Alltrim( Getwordnum( tcWordList, i, lcDelimiter ) )
		lnRetVal = lnRetVal + 1
	Endif
Endfor

Return lnRetVal
