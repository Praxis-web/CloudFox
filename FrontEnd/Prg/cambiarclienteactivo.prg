*
* 
PROCEDURE CambiarClienteActivo( nNewId as Integer ) AS Void
	Local lcCommand as String
	Local loPraxis As oPraxis Of "Clientes\Archivos\prg\Cliente_Praxis.prg",;
	loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"	
	
	Try
	
		lcCommand = ""
		
		If Empty( nNewId ) 
			loUser = NewUser()
			nNewId = loUser.nClientePraxis 
		EndIf
		
		loPraxis = GetEntity( "Cliente_Praxis" )
		loPraxis.CambiarClienteActivo( nNewId )  
		
	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError
		
		External Procedure Cliente_Praxis.prg

	Finally
		loPraxis = Null
		loUser   = Null

	EndTry

EndProc && CambiarClienteActivo



