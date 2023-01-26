
Local loObjectFactory As ObjectFactory Of "Fw\TierAdapter\Comun\ObjectFactory.prg"
Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

* Singleton del objeto _Screen.oGlobalSettings

Try

	loObjectFactory = Null

	If Pemstatus( _Screen, "oObjectFactory", 5 )

		Do Case
			Case Vartype( _Screen.oObjectFactory ) = "O"
				loObjectFactory = _Screen.oObjectFactory

			Otherwise
				loObjectFactory = Newobject( 'ObjectFactory', 'Fw\TierAdapter\Comun\ObjectFactory.prg' )

		Endcase

	Else
		loObjectFactory = Newobject( 'ObjectFactory', 'Fw\TierAdapter\Comun\ObjectFactory.prg' )

	Endif

Catch To oErr
	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return loObjectFactory 