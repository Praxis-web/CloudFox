* Pedido Cantidad de copias

Procedure PedirCopias
	Lparameters nCopias As Integer,;
	cLeyenda as String 
	

	Local lcCommand As String

	Try

		lcCommand = ""

		If Vartype( nCopias ) # "N"
			nCopias = 0
		Endif


		Do Form "Fw\Comunes\scx\pedircopias.scx" With nCopias,cLeyenda To nCopias

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally


	Endtry

	Return nCopias

Endproc