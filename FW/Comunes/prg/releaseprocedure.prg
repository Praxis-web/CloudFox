Lparameters cProcedureFile As String

Local lcCommand As String,;
	lcProcedures As String,;
	lcProcedure As String,;
	lcProcedureName As String

Local lnProceduresCount As Integer,;
	i As Integer

Try

	lcCommand = ""

	lcProcedures = Set("Procedure")
	lcProcedureName = Upper( Juststem( cProcedureFile ) )
	lnProceduresCount = Getwordcount( lcProcedures, "," )

	For i=1 To lnProceduresCount

		lcProcedure = Getwordnum( lcProcedures, i, "," )

		If Upper( Juststem( lcProcedure )) = lcProcedureName
			TEXT To lcCommand NoShow TextMerge Pretext 15
				Release Procedure "<<lcProcedure>>"
			ENDTEXT

			&lcCommand

			Exit

		Endif

	Endfor

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally


EndTry
