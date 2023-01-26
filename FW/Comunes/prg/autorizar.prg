Lparameters tnNivel As Integer,;
	loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg",;
	tlForce as Boolean 

Local loAutorizador As User Of "Fw\TierAdapter\Comun\prxUser.prg"
Local lnNivel As Integer
Local llValid As Boolean
Local lcSysmenu As String

Try

	llValid = .F.
	
	If IsEmpty( loUser )
		loUser = NewUser() 
	EndIf
	
	loUser.oAutorizador = Null 

	lcSysmenu = Set("Sysmenu")

	If Empty( tnNivel )
		tnNivel = 5
	Endif

	If loUser.Nivel < tnNivel Or tlForce

		Do Form "FW\Comunes\Scx\frmLogin" To loAutorizador

		If !loAutorizador.Cancela
			If loAutorizador.lOk
				llValid = loAutorizador.Nivel >= tnNivel

				If !llValid
					Stop( "Nivel de Acceso Insuficiente" + Chr(13) +  "Acceso Denegado" )
					
				Else 
					loUser.oAutorizador = loAutorizador 
					  	
				Endif
			Endif

		Else
			prxSetLastKey( Escape )

		EndIf
		
	Else
		llValid = .T.
		loUser.oAutorizador = loUser   
			
	Endif

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	Set Sysmenu &lcSysmenu
	loAutorizador = Null
	loUser = Null  

Endtry

Return llValid