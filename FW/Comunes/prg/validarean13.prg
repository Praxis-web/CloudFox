*
*
Procedure ValidarEan13( tcCodigoBarras ) As Integer
	Local lcCommand As String
	Local lnSuma, lnI, lnDigito, lnDigitoVerificador

	Try

		lcCommand = ""
		lnSuma = 0

		For lnI = Len(tcCodigoBarras) To 1 Step -1
			lnDigito = Val(Substr(tcCodigoBarras, lnI, 1))
			If (Mod(Len(tcCodigoBarras) - lnI + 1, 2)) <> 0 Then
				lnSuma = lnSuma + lnDigito * 3
			Else
				lnSuma = lnSuma + lnDigito
			Endif
		Endfor

		lnDigitoVerificador = Mod(10 - Mod(lnSuma, 10), 10)

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return (lnDigitoVerificador)

Endproc && ValidarEan13



Procedure dummy
	TEXT To lcCommand NoShow TextMerge Pretext 15

	Python 3
	EAN = "123456789041"

	def ean_checksum(code: str) -> int:
	    digits = [int(i) for i in reversed(code)]
	    return (10 - (3 * sum(digits[0::2]) + (sum(digits[1::2])))) % 10

	print(f"Dígito de control: {ean_checksum(EAN)}")

	ENDTEXT

Endproc

*!*	https://es.wikipedia.org/wiki/European_Article_Number

*!*	Estructura y partes
*!*	El código EAN más usual es EAN-13, constituido por trece (13) dígitos y con
*!*	una estructura dividida en cuatro partes:

*!*	Los primeros dígitos del código de barras EAN identifican el país que otorgó
*!*	el código, no el país de origen del producto.
*!*	Por ejemplo, en Chile se encarga de ello una empresa responsable
*!*	adscrita al sistema EAN y su código es el 780.
*!*	Argentina: 779

*!*	Composición del código:
*!*	Código del país: en donde radica la empresa, compuesto por tres (3) dígitos.

*!*	Código de empresa: es un número compuesto por cuatro o cinco dígitos,
*!*	que identifica al propietario de la marca.
*!*	Es asignado por la asociación de fabricantes y distribuidores (AECOC)

*!*	Código de producto: completa los doce primeros dígitos.

*!*	Dígito de control: para comprobar el dígito de control (por ejemplo,
*!*	inmediatamente después de leer un código de barras mediante un escáner),
*!*	numeramos los dígitos de derecha a izquierda.
*!*	A continuación se suman los dígitos de las posiciones impares, el resultado
*!*	se multiplica por 3, y se le suman los dígitos de las posiciones pares.
*!*	Se busca decena inmediatamente superior y se le resta el resultado obtenido.
*!*	El resultado final es el dígito de control.
*!*	Si el resultado es múltiplo de 10 el dígito de control será cero (0).
*!*	Por ejemplo, para 123456789041 el dígito de control será:

*!*	Numeramos de derecha a izquierda: 140987654321
*!*	Suma de los números en los lugares Impares: 1 + 0 + 8 + 6 + 4 + 2 = 21
*!*	Multiplicado (por 3): 21 × 3 = 63
*!*	Suma de los números en los lugares pares: 4 + 9 + 7 + 5 + 3 + 1 = 29
*!*	Suma total: 63 + 29 = 92
*!*	Decena inmediatamente superior: 100
*!*	Dígito de control: 100 - 92 = 8
*!*	El código quedará así: 1234567890418.

Procedure Test
	Local lcCommand As String, lcMsg As String

	Try

		lcCommand = ""
		Close Databases All

		lcCodigoBarras = "779"		&& Pais
		lcCodigoBarras = lcCodigoBarras + "0436"	&& Empresa
		lcCodigoBarras = lcCodigoBarras + "01235"	&& Producto

		Inform( ValidarEan13( lcCodigoBarras ) )

	Catch To loErr

		Do While Vartype( loErr.UserValue ) == "O"
			loErr = loErr.UserValue
		Enddo

		lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  METODO   ] " + loErr.Procedure + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  LINEA Nº ] " + Transform(loErr.Lineno) + Chr( 13 ) + Chr( 10 )
		If Substr( loErr.LineContents, 2 ) = "lcCommand"
			lcMsg = lcMsg + "[  COMANDO  ] " + lcCommand + Chr( 13 ) + Chr( 10 )
		Else
			lcMsg = lcMsg + "[  COMANDO  ] " + loErr.LineContents + Chr( 13 ) + Chr( 10 )
		Endif
		lcMsg = lcMsg + "[  ERROR    ] " + Transform(loErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  MENSAJE  ] " + loErr.Message + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  DETALLE  ] " + loErr.Details + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )

		Strtofile( lcMsg, "ErrorLog9.txt" )

		Messagebox( lcMsg, 16, "Error", -1 )


	Finally
		Close Databases All


	Endtry


Endproc
