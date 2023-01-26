Local loDataTier As oDataTier2 Of "Fw\Tieradapter\Comun\Prxdatatier.prg"

Try

	loDataTier = Newobject( "oDataTier2", "Fw\Tieradapter\Comun\Prxdatatier.prg" ) 

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return loDataTier