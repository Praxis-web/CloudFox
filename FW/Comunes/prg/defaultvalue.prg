Note: Devolver un valor predeterminado

Lparameters lcVarName, luDefaultValue

Local luReturn As Variant

Try

	Do Case
		Case Type( lcVarName ) = "U"  Or ( Type( lcVarName ) # Vartype( luDefaultValue ) )
			luReturn = luDefaultValue

		Case Type( "lcVarName" ) = "C"
			luReturn = &lcVarName

		Otherwise
			luReturn = luDefaultValue

	Endcase


Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return luReturn