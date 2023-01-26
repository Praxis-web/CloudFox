Lparameters  tcFormKeyName As String,;
	toParameters As Object,;
	tlReturn As Boolean

Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Try

	Launchform( tcFormKeyName, toParameters, tlReturn )

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )

Finally
	loError = Null
	
Endtry

Return 