* Singleton del objeto oUser
Local loApp As Object,;
	loUser As Object

Try

	loApp 	= NewApp()
	If Vartype( loApp ) = "O"
		loUser	= loApp.oUser

	Else
		loUser = Newobject( "User", "Fw\TierAdapter\Comun\prxUser.prg" )

	Endif

Catch To loErr
	Local lnLevel As Integer
	Local llOnError As Boolean

	lnLevel 	= Program ( -1 )
	llOnError 	= .F.

	For i = lnLevel To 1 Step -1
		lcProgram = Upper(Program ( i ))
		If "GETSYSTEMINFORMATION"$Upper(Program ( i ))
			llOnError = .T.
			Exit
		Endif

	Endfor

	If !llOnError
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError
	Endif

Finally
	loApp = Null

Endtry

Return loUser
