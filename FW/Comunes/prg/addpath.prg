*
*
Procedure AddPath( cPath As String ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""

		If Vartype( cPath ) = "C" And !Empty( cPath )
			TEXT To lcCommand NoShow TextMerge Pretext 15
			Set Path To 'cPath' ADDITIVE
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

	Endtry

Endproc && AddPath