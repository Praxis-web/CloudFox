
Lparameters tcHexa

Local i As Integer
Local lcChar As Character
Local lcHexa as String 
Local lnInt As Integer
Local lnValue As Integer
Local lnLen As Integer

Try

	lnInt = 0
	
	If Substr( Lower( tcHexa ), 1, 2 ) == "0x"
		lcHexa = Substr( tcHexa, 3 )
		
	Else
		lcHexa = tcHexa   
			
	EndIf

	lnLen = Len( lcHexa )

	For i = lnLen To 1 Step -1

		lcChar = Substr( lcHexa, i, 1 )

		lnValue = Asc( lcChar )

		Do Case
			Case ( lnValue >= Asc("A") .And. lnValue <= Asc("F") )

				lnValue = lnValue - Asc("A") + 10

			Case ( lnValue >= Asc("a") .And. lnValue <= Asc("f") )

				lnValue = lnValue - Asc("a") + 10

			Case ( lnValue >= Asc("0") .And. lnValue <= Asc("9") )

				lnValue = lnValue - Asc("0")

			Otherwise
				Error "Valor Hexa con dígitos no válidos: " + "0x" + Transform( tcHexa )

		Endcase

		lnInt = lnInt + lnValue * (16 ** ( lnLen - i ))

	Next

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	lnInt = -1

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )


Finally

Endtry

Return Int( lnInt )