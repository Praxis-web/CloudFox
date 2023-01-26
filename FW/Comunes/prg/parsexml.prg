* Parsea un XML y devuelve un string de acuerdo al parámetro pasado
* Parámetros....: 0 = Devuelve el XML
* 						1 = Devuelve el identificador en la forma "#<IDENTIFICADOR>#"
*						2 = Devuelve el comentario

*!* La estructura tiene que ser #<ERR>#<Este es el Comentario>#<ERR>#

Lparameters tcXML As String, tnAction As Number


Local lcReturn As String,;
	lcIdentifier As String,;
	lcComment As String,;
	lcXML As String,;
	lcAux As String,;
	lnLen As Number,;
	lnLen1 As Number

lcIdentifier 	= ""
lcComment 		= ""
lcXML 			= ""

If Vartype( tcXML ) == "C"
	If Empty( tnAction )
		tnAction = 0
	Endif

	*!* Obtener identificador

	If Substr( tcXML, 1, 2 ) = "#<"
		lnLen = At( ">#", tcXML )
		If !Empty( lnLen )
			lcIdentifier = Substr( tcXML, 1, lnLen + 1 )
		Endif
	Endif

	*!* Obtener comentario

	If !Empty( lcIdentifier )
		lnLen = Len( lcIdentifier )
		If Substr( tcXML, 1, lnLen + 1) == lcIdentifier + "<"
			lnLen1 = At( ">" + lcIdentifier, tcXML )
			If !Empty( lnLen1 )
				lcComment = Substr( tcXML, lnLen + 2, lnLen1 - lnLen - 2)
			Endif
		Endif
	Endif

	*!* Obtener XML

	If Empty( lcComment )
		lnLen = Len( lcIdentifier )

	Else
		lnLen = Len( lcComment + lcIdentifier + lcIdentifier ) + 2

	Endif

	If Empty( lnLen )
		lcXML = tcXML

	Else
		lcXML = Substr( tcXML, lnLen + 1 )

	Endif

	Do Case
		Case tnAction = 0
			lcReturn = lcXML

		Case tnAction = 1
			lcReturn = lcIdentifier

		Case tnAction = 2
			lcReturn = lcComment

		Otherwise

	Endcase

Else
	lcReturn = ""
Endif

Return lcReturn
