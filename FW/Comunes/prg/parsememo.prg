*!*	Local lcTexto As String,;
*!*		lcParsed As String
*!*	Local loLines As Collection
*!*	Local lnChars As Integer,;
*!*		lnLines As Integer,;
*!*		i As Integer

*!*	Try

*!*		lcTexto = MemoString()
*!*		lnChars = 70
*!*		lnLines = 10

*!*		loLines = ParseMemo( lcTexto,;
*!*			lnChars,;
*!*			.T. )

*!*		lcParsed = ""
*!*		For i = 1 To loLines.Count
*!*			lcParsed = lcParsed + loLines.Item( i ) + Chr(13)
*!*		Endfor

*!*		Messagebox( lcParsed )

*!*	Catch To oErr
*!*		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

*!*		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
*!*		loError.Process( oErr )


*!*	Finally

*!*	Endtry

*!*	Return


*
*
* ParseMemo(  )

Procedure ParseMemo( tcText As String,;
		tnChars As Integer,;
		tlPreserveEmptyLines As Boolean ) As Variant

	*!*	Lparameters tcText As String,;
	*!*		tnChars As Integer

	Local loLines As Collection
	Local loString As Collection
	Local Array laLines[ 1 ]
	Local lnLen As Integer,;
		i As Integer,;
		j As Integer

	Local lnTrim As Integer,;
		lnPreserveEmptyLines As Integer,;
		lnIncludeLast As Integer,;
		lnCaseInsensitive As Integer,;
		lnIncludeParsingCharacters As Integer,;
		lnFlags As Integer

	Try

		loLines = Createobject( "Collection" )


		lnTrim 						= 1
		lnIncludeLast 				= 2
		lnPreserveEmptyLines 		= 4
		lnCaseInsensitive 			= 8
		lnIncludeParsingCharacters 	= 16

		If .F. && (Default) Removes leading and trailing spaces from lines, or for Varbinary and Blob values, removes trailing zeroes (0) instead of spaces.
			lnTrim = 0
		Endif

		If .T. && Include the last element in the array even if the element is empty.
			lnIncludeLast = 0
		Endif

		If tlPreserveEmptyLines
			lnPreserveEmptyLines = 0
		Endif

		If .T. && Specifies case-insensitive parsing.
			lnCaseInsensitive = 0
		Endif

		If .T. && Include the parsing characters in the array.
			lnIncludeParsingCharacters = 0
		Endif

		lnFlags = lnTrim + lnIncludeLast + lnPreserveEmptyLines + lnCaseInsensitive + lnIncludeParsingCharacters

		lnLen = Alines( laLines, tcText, lnFlags )

		For i = 1 To lnLen
			loString = ParseString( laLines[ i ],;
				tnChars )

			If !Empty( loString.Count )
				For j = 1 To loString.Count
					loLines.Add( loString.Item( j ))
				Endfor

			Else
				loLines.Add( Space( tnChars ) )
				
			Endif

		Endfor

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return loLines
Endproc




*
*
Procedure ParseString( tcText As String,;
		tnChars As Integer ) As Variant

	Local loLines As Collection
	Local i As Integer,;
		lnFrom As Integer,;
		lnWordCount As Integer,;
		lnWordNum As Integer

	Local lcLine As String

	Try

		loLines = Createobject( "Collection" )
		lnFrom = 0
		lnWordCount = Getwordcount( tcText )
		lnWordNum = 0
		lcLine = ""

		Do While lnWordNum < lnWordCount

			lcLine = ""
			lnFrom = lnWordNum + 1

			Do While lnWordNum < lnWordCount And Len( lcLine ) <= tnChars
				lnWordNum = lnWordNum + 1
				lcLine = lcLine + Getwordnum( tcText, lnWordNum ) + " "
			Enddo

			If Len( lcLine ) > tnChars And lnFrom < lnWordNum
				lnWordNum = lnWordNum - 1

				lcLine = ""
				For i = lnFrom To lnWordNum
					lcLine = lcLine + Getwordnum( tcText, i ) + " "
				Endfor

			Endif

			loLines.Add( lcLine )

		Enddo




	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return loLines

Endproc && ParseString


*
*
Procedure MemoString(  ) As Void
	Local lcString As String
	Try

		TEXT To lcString NoShow TextMerge Pretext 03
Características del instalador:

Se baja desde este link. Esta siempre disponible para instalar en cualquier PC con S.O. Windows.

Se instala y reinstala aunque existan versiones anteriores sin generar conflictos.

Es autocontenido. No descarga achivos extras y no necesita runtimes o librerias preinstaladas. No muestra pantalla de presentación o licencia. Con un parámetro adicional puede ejecutarse en modo "silencioso"  desde la linea de comandos sin interacción.

Se instala automáticamante en la carpeta "Archivos de programas\SC\WSAFIPFE" junto con el runtime de NET 2.0 y el runtime de VB 6.

Es retrocompatible. Si se reinstala en una PC una versión mas reciente no es necesario recompilar la aplicación que usa una versión anterior.

En modo prueba u homologación puede usar sin limites de PC parar cualquier C.U.I.T. con todos los web services de AFIP.

Para usar en modo real o producción necesita comprar la activación del producto. La activación es automática. No necesita instaladores ni archivos adicionales, solo una cuenta de gmail.

Se desinstala fácilmente desde la entrada "WSAFIPFE" del panel de control.
		ENDTEXT




	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return lcString
Endproc && MemoString