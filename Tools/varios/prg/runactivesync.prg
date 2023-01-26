
Procedure RunActiveSync()
	Local loProject As VisualFoxpro.IFoxProject
	Try

		If Type( '_vfp.ActiveProject' ) = 'O'
			loProject = _vfp.ActiveProject
			If Vartype( loProject ) = 'O'
				lcFile = Forceext( Addbs( Justpath( loProject.Name ) ) + "Prg\Sync_" + Juststem( loProject.Name ), 'prg' )
				If  FileExist( lcFile )
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Do '<<lcFile>>'

					ENDTEXT

					&lcCommand

					liberarEntorno()
				Else
					Error 'No se encontro el archivo ' + lcFile

				Endif

			Endif

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loError = Null
		loProject = Null

	Endtry

Endproc
