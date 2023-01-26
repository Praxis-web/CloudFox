Lparameters tcString as String

*------------------------------------------------------
* FUNCTION _StrToI2of5(tcString) * INTERLEAVED 2 OF 5
*------------------------------------------------------
* Convierte un string para ser impreso con
* fuente True Type "PF Interleaved 2 of 5"
* ó "PF Interleaved 2 of 5 Wide"
* ó "PF Interleavev 2 of 5 Text"
* Solo caracteres numéricos
* USO: _StrToI2of5('1234567890')
* RETORNA: Caracter
*------------------------------------------------------

*!*	Fuente True Type			Archivo				Tamaño

*!*	PF Interleaved 2 of 5		PF_I2OF5.ttf		36 ó 48
*!*	PF Interleaved 2 of 5 Wide	PF_I2OF5_W.ttf		28 ó 36
*!*	PF Interleavev 2 of 5 Text	PF_I2OF5_Text.ttf	28 ó 36



Local lcStart, lcStop, lcRet, lcCheck, ;
	lcCar, lnLong, lnI, lnSum, lnAux

Try
	
	lcStart = Chr(40)
	lcStop = Chr(41)
	lcRet = Alltrim(tcString)
	*--- Genero dígito de control
	lnLong = Len(lcRet)
	lnSum = 0
	lnCount = 1
	
	For lnI = lnLong To 1 Step -1
		lnSum = lnSum + Val(Substr(lcRet,lnI,1)) * ;
			IIF(Mod(lnCount,2) = 0,1,3)
		lnCount = lnCount + 1
	EndFor
	
	lnAux = Mod(lnSum,10)
	lcRet = lcRet + Alltrim(Str(Iif(lnAux = 0,0,10 - lnAux)))
	lnLong = Len(lcRet)
	*--- La longitud debe ser par
	If Mod(lnLong,2) # 0
		lcRet = '0' + lcRet
		lnLong = Len(lcRet)
	Endif
	*--- Convierto los pares a caracteres
	lcCar = ''
	For lnI = 1 To lnLong Step 2
		If Val(Subs(lcRet,lnI,2)) < 50
			lcCar = lcCar + Chr(Val(Subs(lcRet,lnI,2)) + 48)
		Else
			lcCar = lcCar + Chr(Val(Subs(lcRet,lnI,2)) + 142)
		Endif
	Endfor
	*--- Armo código
	lcRet = lcStart + lcCar + lcStop

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

EndTry

Return lcRet