*
* 
PROCEDURE CambiarEmpresaActiva() AS Void
	Local lcCommand as String
	Local loEmpresa As oEmpresa Of "Clientes\Archivos\prg\Empresa.prg"
	
	Try
	
		lcCommand = ""
				
		loEmpresa = GetEntity( "Empresa" )
		loEmpresa .CambiarEmpresaActiva()  
		
	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError
		
	Finally
		loEmpresa = Null

	EndTry

EndProc && CambiarEmpresaActiva



