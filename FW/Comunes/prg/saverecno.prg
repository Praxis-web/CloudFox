*------------------------------------------------------------------*
* Funcion.......: SaveRecNo
* Devuelve......: El n�mero de registro actual ( 0 si es Eof() )
* Autor.........: Martin Salias - Modificada por Ruben Rovira
* Fecha.........: Mayo 1997 / Marzo 2004
* Version.......: 2.0
* Parametros....: tcAlias = Alias (opcional)
* Notas.........: Guarda el n�mero de registro actual antes de mover el puntero.
*               :
* Relacionadas..: RestRecNo()
*
Lparameters  tcAlias

If Empty( tcAlias )
	tcAlias = Alias()
Endif

Return Iif( Eof( tcAlias ), 0, Recno( tcAlias ) )
*------------------------------------------------------------------*
