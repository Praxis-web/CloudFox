Lparameters tdFecha As Date

Local lcDate As String,;
	lcType As String,;
	lcOldDate As String,;
	lcOldCentury As String ,;
	lcOldHours as String ,;
	lcDateCommand As String

Local lcCommand As String

Try

	lcCommand = ""

	lcOldDate = Set( "Date" )
	lcOldCentury = Set("Century")

	Set Date To YMD
	Set Century On
	Set Hours To 24

	lcType = Vartype( tdFecha )
	Do Case
		Case lcType = 'D'
			lcDateCommand = "{^" + Transform( Dtos( tdFecha ), "@R 9999/99/99" ) + "}"

		Case lcType = 'T'
			lcDateCommand = [Ctot( "] + Ttoc( Datetime(), 3 ) + [" )]

		Otherwise
			lcDateCommand = "{^" + Transform( Dtos( Ctod("") ), "@R 9999/99/99" ) + "}"

	Endcase

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally
	Set Date To (lcOldDate)
	Set Century &lcOldCentury
	Set Hours To &lcOldHours  


Endtry

Return lcDateCommand 
