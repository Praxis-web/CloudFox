Local lcCode As String
TEXT To lcCode NoShow
Lparameters oFoxcode

#Define CRLF Chr(13)+Chr(10)
#Define Tab Chr(9)

Local lcStrFile	As String,;
	lcAlias  	As String

Local lnCol As Integer
Local lcSpaces  As String

Local lcCsrName As String
Local lcAlias As String
Local lcCommand As String
Local lcField as String

Local lnRec As Integer
Local lnActual As Integer
Local lnSelect As Integer

Try

	oFoxcode.valuetype = "V"

	lnCol = oFoxcode.Location

	lcSpaces = Tab + Tab
	lcCommand = "_CC"

	lcStrFile 	= Inputbox( "Nombre del Archivo de Estructura", "Create Cursor From ..." )
	lcAlias		= Inputbox( "Alias del Cursor", "Create Cursor From ..." )

	If ! Empty( lcStrFile )
		lcCsrName = 'TMP' + Sys( 2015 )
		If Empty( lcAlias )
			lcAlias = 'csr' + Sys( 2015 )

		Endif && Empty( lcAlias )


		If File( Forceext( lcStrFile, 'dbf' ) )
			Select * From (lcStrFile) Into Cursor (lcCsrName)
			lnRec = Reccount( lcCsrName )
			lnActual = 1
			Select (lcCsrName)
			Locate
			lcCommand = "Create Cursor (" + lcAlias + ") (;"

			lcCommand = lcCommand + Chr( 13 )

			Scan For ! Deleted()

				Do Case
					Case Inlist( Upper( Field_Type ), 'L', 'D', 'M', 'T', 'I' )
						lcField = Alltrim(  Upper( Field_name ) ) + Space( 1 ) + Upper( Field_Type )

					Case Upper( Field_Type ) = 'C'
						lcField = Alltrim(  Upper( Field_name ) ) + Space( 1 ) + Upper( Field_Type ) + " ( " + Transform( Field_Len ) + " )"

					Case Upper( Field_Type ) = 'N'
						lcField = Alltrim(  Upper( Field_name ) ) + Space( 1 ) + Upper( Field_Type ) + " ( " + Transform( Field_Len ) + ", " + Transform( Field_dec ) + " )"

					Otherwise
						Error 'Tipo de dato invalido [ ' + Upper( Field_Type ) + ' ]'

				Endcase

				lcCommand = lcCommand + Space( lnCol ) + lcSpaces + lcField

				If lnRec # lnActual
					lcCommand = lcCommand + ',;' + Chr( 13 )

				Endif && lnRec # lnActual


				lnActual = lnActual + 1

			Endscan


			If Right( lcCommand, 2 ) == ",;"

			EndIf

			lcCommand = lcCommand + Space( lnCol ) + lcSpaces + " )"

		Else
			Error 'No existe el archivo ' + Forceext( lcStrFile, 'dbf' )

		Endif && File( Forceext( lcStrFile, 'dbf' ) )

	Endif && ! Empty( lcStrFile )

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError

Finally


EndTry

Finally
	Use In Select( lcCsrName )
	Use In Select( Justfname( lcStrFile )  )

Endtry

Return lcCommand
ENDTEXT
Use (_Foxcode) In 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And ABBREV == '_CC'
Insert Into UdpFoxCode ( Type, ABBREV, cmd, Data ) ;
	Values ( 'U', '_CC', '{}', lcCode )
Use In Select( 'UdpFoxCode' )
