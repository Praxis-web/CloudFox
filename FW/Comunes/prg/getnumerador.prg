	*
	* Devuelve el campo que contirnr el numerador del comprobante
Procedure GetNumerador( tnComp As Integer,;
		tcTipo As Character ) As String;
		HELPSTRING "Devuelve el campo que contirnr el numerador del comprobante"

	Local lcField As String,;
		lcTalonario As String

	Try

		Do Case
			Case tcTipo = "A"
				Do Case
					Case tnComp = 1
						lcTalonario = "NumFCA"

					Case tnComp = 2
						lcTalonario = "NumNDA"

					Case tnComp = 3
						lcTalonario = "NumNCA"

				Endcase

			Case tcTipo = "B"
				Do Case
					Case tnComp = 1
						lcTalonario = "NumFCB"

					Case tnComp = 2
						lcTalonario = "NumNDB"

					Case tnComp = 3
						lcTalonario = "NumNCB"

				Endcase

		Endcase

		lcField = GetValue( lcTalonario, "ar0Ven", "Numerador" )


	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return lcField

Endproc && GetNumerador