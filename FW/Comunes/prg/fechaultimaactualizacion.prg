*
* Devuelve la fecha en formato DateTime
Procedure FechaUltimaActualizacion( cFileSkeleton As String ) As Datetime;
		HELPSTRING "Devuelve la fecha en formato DateTime"
	Local lcCommand As String,;
		lcTimeStamp As String,;
		lcLastTS As String

	Local ltUltimaActualizacion As Datetime

	Local lnLen As Integer,;
		i As Integer

	Try

		lcCommand = ""

		lcLastTS = ""

		lnLen = Adir( laDir, cFileSkeleton )

		If !Empty( lnLen )

			lcLastTS = Transform( Dtos( laDir[1,3] ), "@R 9999-99-99" ) + "T" + laDir[1,4]

			For i = 1 To lnLen

				lcTimeStamp = Transform( Dtos( laDir[i,3] ), "@R 9999-99-99" ) + "T" + laDir[i,4]

				If lcTimeStamp > lcLastTS
					lcLastTS =  lcTimeStamp
				Endif
			Endfor
		Endif

		ltUltimaActualizacion = Ctot( lcLastTS )


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return ltUltimaActualizacion

Endproc && FechaUltimaActualizacion

