*
* Devuelve la lista de campos que se actualizan a partir de la estructura de la tabla
* Si tlAssign=.T., entonces genera la tupla "tcTableName.cFieldName = tcAlias.cFieldName"
Lparameters  tcTableName As String,;
	tcAlias As String,;
	tcExcludeFieldList As String,;
	tlAssign As Boolean,;
	tcValidateTable As String

Local lcCommand As String,;
	lcFieldList As String,;
	lcField As String

Local Array laFields[ 1 ]

Local lnLen As Integer,;
	i As Integer

Try

	lcCommand = ""
	lcFieldList = ""

	If Empty( tcAlias )
		tcAlias = ""
	Endif

	If !Empty( tcAlias )
		tcAlias = tcAlias + "."
	Endif

	If Empty( tcExcludeFieldList )
		tcExcludeFieldList = "_&$&_"
	Endif

	If Empty( tcValidateTable )
		tcValidateTable = ""
	Endif

	tcExcludeFieldList = Lower( tcExcludeFieldList )
	tcExcludeFieldList = Strtran( tcExcludeFieldList, "'", "" )
	tcExcludeFieldList = Strtran( tcExcludeFieldList, '"', "" )
	tcExcludeFieldList = Strtran( tcExcludeFieldList, "[", "" )
	tcExcludeFieldList = Strtran( tcExcludeFieldList, "]", "" )
	tcExcludeFieldList = Strtran( tcExcludeFieldList, " ", "" )

	tcExcludeFieldList = tcExcludeFieldList
	tcExcludeFieldList = Strtran( tcExcludeFieldList, ",", [','] )

	lnLen = Afields( laFields, tcTableName )

	For i = 1 To lnLen
		lcField = Lower( laFields[ i, 1 ] )

		TEXT To lcCommand NoShow TextMerge Pretext 15
			InList( '<<Lower( lcField )>>', '<<tcExcludeFieldList>>' )
		ENDTEXT

		llInList = &lcCommand

		If !llInList

			If Empty( tcValidateTable ) Or !Empty( Field( lcField, tcValidateTable ))
				If tlAssign
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
					,<<lcField>> = <<tcAlias>><<lcField>>
					ENDTEXT

				Else
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
					,<<tcAlias>><<lcField>>
					ENDTEXT

				Endif
			Endif

		Endif
	Endfor

	lcFieldList = Substr( lcFieldList, 2 )

Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.cRemark = lcCommand
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return lcFieldList