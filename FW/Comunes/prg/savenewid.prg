*
* Graba el siguiente Id de la tabla

* Debe estar posicionado en el registro donde se quiere grabar la siguiente Id
* El campo correspondiente al Id debe estar vacío
* Devuelve el Id asignado
Procedure SaveNewId( cTableName As String,;
		cFieldName As String,;
		nStep As Integer,;
		cForClause As String ) As Integer;
		HELPSTRING "Devuelve el último Id"

	Local lcCommand As String
	Local lnId As Integer,;
		lnRecno As Integer,;
		lnIdActual As Integer

	Try

		lcCommand 	= ""
		lnId 		= 0
		lnIdActual 	= 0

		If Empty( cTableName )
			cTableName = Alias()
		Endif

		If Empty( cFieldName )
			cFieldName = "Id"
		Endif

		If Empty( nStep ) Or Vartype( nStep ) # "N"
			nStep = 1
		Endif

		If !Empty( Field( cFieldName, cTableName ))

			Try


					* RA 2015-01-22(19:52:50)
					* M_IniAct( 1 ) graba tambien el Id
					* Si estoy parado sobre el registro que acaba de agregarse
					* y M_IniAct( 1 ) ya grabó el Id, devuelvo ese valor.
					* Es por compatibilidad hacia atras

					lnRecno 	= Recno( cTableName )
					lnIdActual 	= Evaluate( cTableName + "." + cFieldName )

					lnId = GetMaxId( cTableName, cFieldName, cForClause )

					Goto lnRecno In ( cTableName )

					If Empty( lnIdActual )
						lnId = lnId + nStep

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Replace <<cFieldName>> With <<lnId>> In <<cTableName>>
						ENDTEXT

						&lcCommand

					Else
						If lnId # lnIdActual
							lnId = 0
						Endif

					Endif

			Catch To oErr
				TEXT To lcCommand NoShow TextMerge Pretext 15
				SaveNewId() -> <<cTableName>>.<<cFieldName>> = <<lnId>>
				ENDTEXT

				Logerror( oErr.Message,;
					Lineno(1),;
					lcCommand  )

				lnId = 0

			Finally

			Endtry

		Endif

	Catch To oErr
		lnId = 0

	Finally

	Endtry

	Return lnId

Endproc && SaveNewId

