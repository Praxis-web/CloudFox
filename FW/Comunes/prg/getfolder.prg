*
*
Procedure GetFolder( cDirectory As String,;
		cCaption As String,;
		nFlags As Integer ) As Void

	Local lcCommand As String,;
		lcFolder As String,;
	lcCaption As String

	Local nFlags As Integer

	Try

		lcCommand = ""
		If Vartype( cDirectory ) # "C"
			cDirectory = Curdir()
		EndIf
		
		lcFolder = cDirectory 

		If Vartype( cCaption ) # "C"
			cCaption = "Seleccione la Carpeta"
		EndIf
		
		If Empty( nFlags )
			nFlags = 16+32+64+16384 
		EndIf

		lcFolder = Getdir( cDirectory, "", cCaption, nFlags )
		
	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcFolder

Endproc && GetFolder

