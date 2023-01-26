*
* Devuelve una lista de tuplas para utilizar en el comando Update
Procedure GetUpdateFieldsValues( tcTableName As String,;
		tcFromAlias As String,;
		tcExcludeFieldList As String ) As String ;
		HELPSTRING "Devuelve una lista de tuplas para utilizar en el comando Update"

	Local lcCommand As String,;
		lcFieldList As String,;
		lcField As String

	Local llInList As Boolean
	Local i As Integer,;
		lnLen As Integer

	Local Array laFields[ 1 ]

	Try

		lcCommand = ""
		lcFieldList = ""

		If Empty( tcFromAlias )
			Error "Falta definir el alias en " + Program()
		Endif

		If Empty( tcExcludeFieldList )
			tcExcludeFieldList = ["_/-\_"]
		Endif

		tcExcludeFieldList = Lower( tcExcludeFieldList )

		lnLen = Afields( laFields, tcTableName )

		lcFieldList = ""

		For i = 1 To lnLen

			lcField = Lower( laFields[ i, 1 ] )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			InList( '<<lcField>>', <<tcExcludeFieldList>> )
			ENDTEXT

			llInList = &lcCommand

			If !llInList
			
				If !Empty( Field( lcField, tcFromAlias ))
					TEXT To lcFieldList NoShow TextMerge Pretext 15 ADDITIVE
					,<<lcField>> = <<tcFromAlias>>.<<lcField>>
					EndText
				EndIf

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

Endproc && GetUpdateFieldsValues