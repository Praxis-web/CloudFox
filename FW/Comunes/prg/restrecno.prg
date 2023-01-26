*------------------------------------------------------------------*
* Funcion.......: RestRecNo
* Devuelve......:
* Autor.........: Martin Salias - Modificada por Ruben Rovira
* Fecha.........: Mayo 1997 / Marzo 2004
* Version.......: 2.0
* Parametros....: tnRecno = Número de registro; tcAlias = Alias (opcional)
* Notas.........: Reemplazo seguro del GO ( en conjunto con SaveRecNo() )
*               :
* Relacionadas..: SaveRecNo
*
Lparameters tnRecno, tcAlias

If Empty( tcAlias )
	tcAlias = Alias()
Endif

If tnRecno # Recno( tcAlias )
	If tnRecno = 0
		Go Bottom In ( tcAlias )
		
	Else
		Try
			Go tnRecno In ( tcAlias )

		Catch To oErr
			Go Bottom In ( tcAlias )
			
		Finally

		Endtry

	Endif
Endif

Return
*------------------------------------------------------------------*
