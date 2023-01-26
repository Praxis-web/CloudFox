
*
* Devuelve la ruta a un archivo
Procedure Get_File( cFileExtensions As String,;
		cText As String,;
		cOpenButtonCaption As String,;
		nButtonType As Integer,;
		cTitleBarCaption As String,;
		cFolder As String ) As Void;
		HELPSTRING "Devuelve la ruta a un archivo"

	Local lcCommand As String,;
		lcCurDir As String,;
		lcFileName As String

	Try

		lcCommand = ""
		lcCurDir = Set("Default") + Curdir()
		
		If Empty( cFileExtensions )
			cFileExtensions = ""
		Endif

		If Empty( cText )
			cText = ""
		Endif

		If Empty( cOpenButtonCaption )
			cOpenButtonCaption = ""
		Endif

		If Empty( nButtonType )
			nButtonType = 0
		Endif

		If Empty( cTitleBarCaption )
			cTitleBarCaption = ""
		Endif

		If Empty( cFolder )
			cFolder = ""
		Endif

		If !Empty( cFolder )
			Try

				Cd "&cFolder"

			Catch To oErr

			Finally

			Endtry

		Endif

		lcFileName = Getfile( cFileExtensions,;
			cText,;
			cOpenButtonCaption,;
			nButtonType,;
			cTitleBarCaption )


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Cd "&lcCurDir"

	Endtry

	Return lcFileName

Endproc && Get_File