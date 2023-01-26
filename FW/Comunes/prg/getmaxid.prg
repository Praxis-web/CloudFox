*
* Devuelve el máximo Id de la tabla
Procedure GetMaxId( cTableName As String,;
		cFieldName As String,;
		cForClause As String ) As Integer;
		HELPSTRING "Devuelve el último Id"

	Local lcCommand As String,;
		lcForClause As String,;
		lcAlias As String,;
		lcOrder As String,;
		lcDeleted as String 

	Local lnId As Integer,;
		lnMinId As Integer,;
		lnMaxId As Integer
		
	Local llVacio as Boolean 	

	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
	Local loErr As Exception

	Try

		lcCommand = ""
		
		llVacio = .F. 
		lcAlias = Alias()
		lcOrder = Order()
		lcDeleted = Set("Deleted")
		*Set Deleted Off 

		loGlobalSettings = NewGlobalSettings()

		If Empty( cTableName )
			cTableName = Alias()
		Endif

		If Empty( cFieldName )
			cFieldName = "Id"
		Endif

		If Empty( cForClause )
			lcForClause = ""

		Else
			TEXT To lcForClause NoShow TextMerge Pretext 15
			( <<cForClause>> ) And
			ENDTEXT

		Endif

		lnMinId = loGlobalSettings.nMinId
		lnMaxId = loGlobalSettings.nMaxId

		If Empty( lcForClause )
			Set Near On
			Select Alias( cTableName )

			Try

				Set Order To ( cFieldName )

				Go Bottom

				If Seek( lnMaxId, cTableName, cFieldName )
					* RA 2015-02-04(18:10:40)
					* Nunca debería entrar por aquí
					lnId = Evaluate( cTableName + "." + cFieldName )

				Else
					If Eof()
						Go Bottom
						
						If Eof()
							*GotoRecno( Reccount() )
							llVacio = .T. 
						EndIf

					Else
						Skip -1 In Alias( cTableName )

					EndIf
					
					If llVacio  
						lnId = 1

					Else
						lnId = Evaluate( cTableName + "." + cFieldName )

					Endif

				Endif

			Catch To loErr

				*loErr.ErrorNo = 26 	( Table has no index order set )
				*loErr.ErrorNo = 1683 	( Index tag is not found. )
				
				If InList( loErr.ErrorNo, 26, 1683 ) 
					TEXT To lcForClause NoShow TextMerge Pretext 15 ADDITIVE
					Between( <<cFieldName>>, <<lnMinId>>, <<lnMaxId>> )
					ENDTEXT

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Calculate Max( <<cFieldName>> ) For <<lcForClause>> To lnId In <<cTableName>>
					ENDTEXT

					&lcCommand

				Else
					Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
					loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
					loError.cRemark = lcCommand
					loError.Process ( m.loErr )
					Throw loError

				Endif



			Finally


			Endtry


		Else

			TEXT To lcForClause NoShow TextMerge Pretext 15 ADDITIVE
			( Between( <<cFieldName>>, <<lnMinId>>, <<lnMaxId>> ))
			ENDTEXT

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Calculate Max( <<cFieldName>> ) For <<lcForClause>> To lnId In <<cTableName>>
			ENDTEXT

			&lcCommand

		Endif

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally
		Set Deleted &lcDeleted 
		 
		loGlobalSettings = Null
		Set Near Off
		If !Empty( lcAlias )
			Select Alias( lcAlias )
			Set Order To ( lcOrder )
		Endif

	Endtry

	Return Max( lnId, lnMinId )

Endproc && GetMaxId