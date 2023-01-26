Local loDespacho As oDespacho Of "Clientes\Stock\prg\stRutina.prg"

Try

	loDespacho = Newobject( "oDespacho", "Clientes\Stock\prg\stRutina.prg" )

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return loDespacho 