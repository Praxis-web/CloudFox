Lparameters toErr As Exception,;
	tcRem As String,;
	tcCaption As String

Local lcText As String
Local Array laError[ 1 ]

Try

	lcText = "No se ha podido procesar el Error .... "

	If Empty( tcRem )
		tcRem = ""
	Endif

	If Empty( tcCaption )
		tcCaption = "Ha Ocurrido Un Error"
	Endif

	If Vartype( toErr ) == "O" And Lower( toErr.BaseClass ) = "exception"

		Do While Vartype( toErr.UserValue ) == "O"
			toErr = toErr.UserValue
		Enddo

		TEXT To lcText NoShow TextMerge Pretext 03
			<<tcRem>>
			[  METODO   ] <<toErr.Procedure>>
			[  LINEA Nº ] <<Transform(toErr.Lineno)>>
			[  COMANDO  ] <<toErr.LineContents>>
			[  ERROR    ] <<Transform(toErr.ErrorNo)>>
			[  MENSAJE  ] <<toErr.Message>>
			[  DETALLE  ] <<toErr.Details>>
		ENDTEXT

	Else
		Aerror( laError )

		tcRem = "ADVERTENCIA: Se capturo la ultima excepción" + Chr( 13 ) + tcRem

		TEXT To lcText NoShow TextMerge Pretext 03
			<<tcRem>>
			[  METODO   ] <<Program( Program( -1 ) - 1 )>>
			[  ERROR    ] <<Transform( IfEmpty( laError[1,1], 0  ))>>
			[  MENSAJE  ] <<IfEmpty( laError[1,2], "" )>>
			[  DETALLE  ] <<IfEmpty( laError[1,3], "" )>>
			[  AppName  ] <<IfEmpty( laError[1,4], "" )>>
			[  HelpFile ] <<IfEmpty( laError[1,5], "" )>>
			[  HelpId   ] <<IfEmpty( laError[1,6], "" )>>
			[  OLEExcNo ] <<IfEmpty( laError[1,7], "" )>>
		ENDTEXT

	Endif

	Stop( lcText, tcCaption )
	
	Try

		StrToFile( lcText, "ShowError.txt" )

	Catch To oErr

	Finally

	EndTry



Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry