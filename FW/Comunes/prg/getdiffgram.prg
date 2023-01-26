Lparameters tcCursor As String

Local loXA As prxXMLAdapter Of "FW\Comun\Prg\prxXMLAdapter.prg"
Local lcDiffGram As String
Local llOk As Boolean
Local i As Integer

llOk = .T.
lcDiffGram = ''

If Empty( tcCursor )
	tcCursor = ''
	llOk = .F.

Endif

If llOk
	loXA = Newobject( "prxXMLAdapter", "prxXMLAdapter.prg" )

Endif

For i = 1 To Getwordcount( tcCursor, ',' )
	lcCursor = Getwordnum( tcCursor, i, ',' )
	If Used( lcCursor )
		loXA.AddTableSchema( lcCursor )

	Endif

Endfor
If llOk
	lcDiffGram = loXA.GetDiffGram()

Endif

loXA = Null

Return lcDiffGram
