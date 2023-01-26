Lparameters tcMsg As String

Local loHasar As HASAR.Fiscal.1

Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Try
	loHasar = NewHasar()
	loHasar.Enviar( tcMsg )

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loError = Null
	loHasar = Null

Endtry