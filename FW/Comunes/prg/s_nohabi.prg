*
* Alerta de Programa No Habilitado
Procedure S_NoHabi( nPar1 As Integer,;
		nPar2 As Integer,;
		nPar3 As Integer,;
		nPar4 As Integer,;
		nPar5 As Integer ) As Void;
		HELPSTRING "Alerta de Programa No Habilitado"
	Local lcCommand As String

	Try

		lcCommand = ""
		
		Text To lcMsg NoShow TextMerge Pretext 03
		NO HABILITADO 
		
		<<nPar1>>
		<<nPar2>>
		<<nPar3>>
		<<nPar4>>
		<<nPar5>> 		
		EndText

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && S_NoHabi

