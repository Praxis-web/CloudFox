Lparameters lUseDBC as Boolean 

Local loDataTier As PrxDataTier Of "Fw\Tieradapter\Comun\Prxdatatier.prg"

Try

	loDataTier = Newobject( "PrxDataTier", "Fw\Tieradapter\Comun\Prxdatatier.prg" ) 
	loDataTier.lUseDBC = lUseDBC   

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return loDataTier