Lparameters tcSource As String

Local lcDigitoVerificador As Character
Local lnPares As Integer,;
	lnImpares As Integer,;
	lnMultiplo10 as Integer

Local i As Integer,;
	lnLen As Integer

Local lcChar As Character

Try

	tcSource = Alltrim( tcSource )
	lnLen = Len( tcSource )
	lnImpares = 0
	lnPares = 0


	* Suman las cifras ubicadas en las posiciones pares y las ubicadas en las posiciones impares
	For i = 1 To lnLen
		lcChar = Substr( tcSource, i, 1 )

		If EsImpar( i )
			lnImpares = lnImpares + Val( lcChar )

		Else
			lnPares = lnPares + Val( lcChar )
			
		Endif

	Endfor

	lnPares = Int( lnPares )  
	
	* Las impares se multiplican por el numero 3
	lnImpares = Int( lnImpares * 3 )  
	
	* Se calcula el primer n�mero multiplo de 10 superior a la suma de los valores obtenidos
	lnMultiplo10 = Ceiling( ( lnPares + lnImpares ) / 10 ) * 10  

	* La diferencia es el d�gito verificador
	lcDigitoVerificador = Transform( lnMultiplo10 - ( lnPares + lnImpares ))

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return lcDigitoVerificador

*!*	AFIP
*!*	ANEXO I RESOLUCION GENERAL N�1702
*!*	DATOS Y CARACTERISTICAS DEL SISTEMA DE IDENTIFICACION DE DATOS DENOMINADO "CODIGO DE BARRAS"

*!*	ser� el "C�digo Entrelazado 2 de 5 ( Interleaved 2 of 5 ITF)"

*!*	C) RUTINA PARA EL CALCULO DEL DIGITO VERIFICADOR
*!*	La rutina de obtenci�n del d�gito verificador ser� la del m�dulo 10
*!*	Se considera para efectuar el c�lculo el siguiente ejemplo:

*!*	01234567890

*!*	Etapa 1: Comenzar desde la izquierda, sumar todos los caracteres ubicados en las
*!*	posiciones impares.

*!*	0 + 2 + 4 + 6 + 8 + 0 = 20

*!*	Etapa 2: Multiplicar la suma obtenida en la etapa 1 por el n�mero 3.

*!*	20 x 3 = 60

*!*	Etapa 3: Comenzar desde la izquierda, sumar todos los caracteres que est�n
*!*	ubicados en las posiciones pares.

*!*	1 + 3 + 5+ 7 + 9 = 25

*!*	Etapa 4: Sumar los resultados obtenidos en las etapas 2 y 3.

*!*	60 + 25 = 85

*!*	Etapa 5: Buscar el menor n�mero que sumado al resultado obtenido en la etapa
*!*	4 d� un n�mero m�ltiplo de 10. Este ser� el valor del d�gito verificador del m�dulo 10.

*!*	85 + 5 = 90

*!*	De esta manera se llega a que el n�mero 5 es el d�gito verificador m�dulo 10 para el
*!*	c�digo 01234567890

*!*	Siendo el resultado final:

*!*	012345678905