*
* Convierte un valor etero a Horas:Minutos:Segundos
Procedure Dec2Hms( nInteger As Integer ) As Void;
		HELPSTRING "Convierte un valor etero a Horas:Minutos:Segundos"
	Local lcCommand As String,;
		lcReturn As String,;
		lcHoras As String,;
		lcMinutos As String,;
		lcSegundos As String

	Local lnResto As Integer,;
		lnSegundos As Integer,;
		lnMinutos As Integer,;
		lnHoras As Integer

	Try

		lcCommand = ""

		If Vartype( nInteger ) # "N"
			Error 107
		Endif

		lnHoras 	= Int( nInteger / ( 60 * 60 ))

		lnResto 	= nInteger - ( lnHoras * ( 60 * 60 ))

		lnMinutos 	= Int( lnResto / 60 )

		lnSegundos 	= Int( lnResto - ( lnMinutos * 60 ))

		lcReturn 	= Transform( lnHoras ) + ":" ;
			+ Padl( lnMinutos, 2, "0" ) + ":" ;
			+ Padl( lnSegundos, 2, "0" )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcReturn

Endproc && Dec2Hms
