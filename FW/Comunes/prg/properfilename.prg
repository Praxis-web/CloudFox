Lparameters tcFileName

Local i As Integer, lnLen As Integer
Local lcWord As String,;
	lcFileName As String

lcFileName = ""
lnLen = Getwordcount( tcFileName, "\" )

For i = 1 To lnLen
	lcWord = Proper( Getwordnum( tcFileName, i, "\" ) )
	If i = 1
		lcFileName = lcWord

	Else
		lcFileName = Addbs( lcFileName ) + lcWord

	Endif

Endfor

Return lcFileName
