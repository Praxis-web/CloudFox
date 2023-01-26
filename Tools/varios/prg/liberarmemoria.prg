
Procedure LiberarMemoria( tlShowMessage As Boolean ) As void
	Local lnRet As Integer

	Try

		* DAE 2009-10-23(11:27:57)
		Declare Long GetCurrentProcess In WIN32API
		Declare Long SetProcessWorkingSetSize In WIN32API Long hProcess, ;
			Long dwMinimumWorkingSetSize, ;
			Long dwMaximumWorkingSetSize

		*!* Declare function to return system error code if an API call fails.
		Declare Integer GetLastError In win32api

		*!* Declare function to return text message from system error code.
		Declare Integer FormatMessage In kernel32.Dll ;
			Integer dwFlags, ;
			String @lpSource, ;
			Integer dwMessageId, ;
			Integer dwLanguageId, ;
			String @lpBuffer, ;
			Integer nSize, ;
			Integer Arguments

		lnRet = SetProcessWorkingSetSize( GetCurrentProcess(), -1, -1 )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loError = Null

		Clear Dlls GetCurrentProcess
		Clear Dlls SetProcessWorkingSetSize
		Clear Dlls GetLastError
		Clear Dlls FormatMessage

		If ! tlShowMessage
			Wait 'Memoria Liberada' Window Nowait

		Endif && ! tlShowMessage

	Endtry

Endproc && LiberarMemoria
