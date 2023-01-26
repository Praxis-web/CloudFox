Lparameters tdFecha As Date
* Fecha2SQL
* DAE 2009-09-22
*

Local lcDate As String,;
	lcType As String,;
	lcOldDate as String,;
	lcOldCentury as String 

Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
Try
	
	lcOldDate = Set( "Date" )
	lcOldCentury = Set("Century")
	 
	Set Date To YMD
	Set Century On

	lcType = Vartype( tdFecha )
	Do Case
		Case lcType = 'D'
			lcDate = '<#' + Dtoc( tdFecha ) + '#>'

		Case lcType = 'T'
			lcDate = '<$' + Ttoc( tdFecha ) + '$>'

		Otherwise
			lcDate = '<##>'

	Endcase

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loError = Null
	Set Date to (lcOldDate)
	Set Century &lcOldCentury 

Endtry

Return lcDate