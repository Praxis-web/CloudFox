Lparameters cProcedureFile As String, lAdditive As Boolean

Local lcCommand As String,;
	lcProcedures As String,;
	lcProcedure As String,;
	lcProcedureName As String

Local lnProceduresCount As Integer,;
	i As Integer

Try

	lcCommand = ""

	If lAdditive

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

	Endif


	TEXT To lcCommand NoShow TextMerge Pretext 15
	Set Procedure To "<<cProcedureFile>>" <<Iif( lAdditive, "ADDITIVE", "" )>>
	ENDTEXT

	&lcCommand


Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.cRemark = lcCommand
	loError.Process( oErr )


Finally

Endtry