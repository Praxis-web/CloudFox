Lparameters lnColumnNro As Integer

* Devuelve el nombre de una columna de Excel, en funcion del numero de columna
* Excel tiene los siguientes rangos:
* A...Z			1 .... 26
* AA....AZ		27 .... 52
* BA....BZ		53 .... 78
* CA....CZ		79 .... 104

#Define XLS_CHARSET	26

Local lcColumn As String
Local lnCol1 As Integer
Local lnCol2 As Integer
Local lnOffset As Integer

Try


	lnCol1 = Int( ( lnColumnNro - 1 ) / XLS_CHARSET )
	lnCol2 = Mod( lnColumnNro, XLS_CHARSET )
	lnOffset = Asc( "A" ) - 1
	lcColumn = ""

	If !Empty( lnCol1 )
		lcColumn = Chr( lnCol1 + lnOffset )
	Endif

	If !Empty( lnCol2 )
		lcColumn = lcColumn + Chr( lnCol2 + lnOffset )
		
	Else
		lcColumn = lcColumn + Chr( XLS_CHARSET + lnOffset )
		
	Endif



Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return lcColumn