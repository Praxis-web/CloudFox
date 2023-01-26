Lparameters lcFileSkeleton As String

Local llExist As Boolean
Local Array laDir[ 1 ]

Try

	llExist = !Empty( Adir( laDir, lcFileSkeleton ))


Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return llExist