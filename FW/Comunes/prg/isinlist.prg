Lparameters cWordSerched As String, cWordsList As String, cDelimiter As Character

Local lcStrList As String, lcCommand As String
Local i As Integer
Local llInList As Boolean

Try

	llInList = .F.
	lcStrList = ""

	If !Empty( cWordsList )

		If Empty( cDelimiter )
			cDelimiter = ","
		Endif

		For i = 1 To Getwordcount( cWordsList, cDelimiter )
			lcStrList = lcStrList + ",'" + Alltrim( Lower( Getwordnum( cWordsList, i, cDelimiter ) ))+ "'"
		Endfor

		If  Substr( lcStrList, 1, 1 ) == cDelimiter
			lcStrList = Substr( lcStrList, 2 )
		Endif

		TEXT To lcCommand NoShow TextMerge Pretext 15
		llInList = Inlist( '<<Lower( cWordSerched )>>', <<lcStrList>>, '<<cDelimiter>>' )
		ENDTEXT

		&lcCommand
	Endif



Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return llInList