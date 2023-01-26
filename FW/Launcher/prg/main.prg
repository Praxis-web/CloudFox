Try

	_Screen.Visible = .F.
	Do Form "FW\Launcher\Scx\Launch Form.scx"
	Read Events

Catch To oErr

	Try
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.Process( oErr )

	Catch To oErr
		Do While Vartype( oErr.UserValue ) == "O"
			oErr = oErr.UserValue

		Enddo

		lcText = "No se pudo ejecutar la Aplicación" + CR + CR
		lcText = lcText + "[  Método   ] " + oErr.Procedure + CR + ;
			"[  Línea N° ] " + Transform(oErr.Lineno) + CR + ;
			"[  Comando  ] " + oErr.LineContents + CR  + ;
			"[  Error    ] " + Transform(oErr.ErrorNo) + CR + ;
			"[  Mensaje  ] " + oErr.Message  + CR + ;
			"[  Detalle  ] " + oErr.Details

		= Messagebox( lcText, 16, "Error Grave" )

	Finally
		Clear Events

	Endtry


Finally
	_Screen.Visible = .F.
	
Endtry