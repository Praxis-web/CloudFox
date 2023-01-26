* Devuelve la cantidad de dígitos de un campo numérico

Lparameters tnNumber As Number, tuDecimals As Variant

Local lnLenght As Number ,;
	lcNum As String ,;
	lnAt As Integer

lcNum = Any2Char( tnNumber )
If Pcount()>1
	lnAt = At( ".", lcNum )
	If !Empty(lnAt)
		lcNum = Substr( lcNum, lnAt + 1)
	Else
		lcNum = ""
	Endif
Endif
lnLenght = Len( lcNum )

Return lnLenght
