*
* 
PROCEDURE CambiarSucursalActiva() AS Void
	Local lcCommand as String
	Local loSucursal As oSucursal Of "Clientes\Archivos\prg\Sucursal.prg"
	
	Try
	
		lcCommand = ""
				
		loSucursal = GetEntity( "Sucursal" )
		loSucursal.CambiarSucursalActiva()  
		
	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError
		
		External Procedure Cliente_Praxis.prg

	Finally
		loSucursal = Null

	EndTry

EndProc && CambiarSucursalActiva



