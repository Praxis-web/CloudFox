
#Define ENV_CLAUDFOX 	1
#Define ENV_CLIPPER2FOX 2
#Define ENV_CLIPPER2FOX_MIN 3

*!*	On Error Do Logerror

*
* LiberarEntorno
*
*!*	Procedure LiberarEntorno( ) As void
Close Databases All
Clear Program
*!* Clear All
Release All


Local lcCommand as String

Try

	lcCommand = ""

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally


EndTry

Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
Local lcProcedure As String
Local lcClasslib As String
Local loFile As VisualFoxpro.IFoxPrjFile
Local lcproc As String

Local Array lAClasses[ 1 ]
Local loForm As Form
Local loProject As VisualFoxpro.IFoxProject In _vfp.Projects

*!*		On Error Do Logerror

Try

	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )

	Try

		RemoveProperty( _Screen, "nEnv" )

	Catch To oErr

	Finally

	EndTry
	
	lcDefault = Curdir()
	Do Case
	Case lcDefault = "\CLIPPER2FOX\"
		AddProperty( _Screen, "nEnv", ENV_CLIPPER2FOX )
	
	Case lcDefault = "\CLOUDFOX\"
		AddProperty( _Screen, "nEnv", ENV_CLAUDFOX )

	Otherwise
		AddProperty( _Screen, "nEnv", ENV_CLIPPER2FOX )

	EndCase
		

	* DAE 2009-10-23(11:29:21)
	* LiberarMemoria()
	Do LiberarMemoria In 'tools\varios\prg\LiberarMemoria.prg'


	* DAE 2009-10-04
	LiberarForms()

	lcProcedure = Set( 'Procedure' )
	For i = 1 To Occurs( ',', lcProcedure ) + 1
		lcproc = Alltrim( Getwordnum( lcProcedure, i, ',' ) )

		If Len( lcproc ) > 2
			Try
				TEXT To lcCommand NoShow TextMerge Pretext 15
						Release Procedure '<<lcproc>>'
				ENDTEXT
				&lcCommand

			Catch To oErr
				loError.Process( oErr, .F. )

			Endtry
		Endif
	Next

	Set Procedure To

	lcClasslib = Set( 'Classlib' )
	For i = 1 To Occurs( ',', lcClasslib ) + 1
		lcproc = Alltrim( Getwordnum( lcClasslib, i, ',' ) )
		If Len( Strextract( lcproc, 'ALIAS' ) ) > 0
			lcproc = Alltrim( Strextract( lcproc, '', 'ALIAS' ) )
		Endif

		If Len( lcproc ) > 2
			Try
				TEXT To lcCommand NoShow TextMerge Pretext 15
						Release Classlib '<<lcproc>>'
				ENDTEXT
				&lcCommand

			Catch To oErr
				loError.Process( oErr, .F. )

			Endtry
		Endif
	Next

	Set Classlib To
	Try

		* RA 2009-09-04(16:08:44)
		* Si no lo ejecuto primero, se cuelga el fox
		*			Clear Classlib "v:\sistemaspraxisv2\fw\comunes\vcx\buttons.vcx"

		For Each loProject As VisualFoxpro.IFoxProject In _vfp.Projects
			For Each loFile As VisualFoxpro.IFoxPrjFile In loProject.Files
				If loFile.Type == 'V'

					Try
						TEXT To lcCommand NoShow TextMerge Pretext 15
							Clear Classlib '<<loFile.Name>>'
						ENDTEXT

						&lcCommand

					Catch To oErr
						loError.Process( oErr, .F. )

					Endtry

					Try
						TEXT To lcCommand NoShow TextMerge Pretext 15
								Use '<<loFile.Name>>' In 0 Alias vcx Shared Again

						ENDTEXT

						&lcCommand

						TEXT To lcCommand NoShow TextMerge Pretext 15
								Select Alltrim( Cast( ObjName As Varchar( 254 ) ) ) Class
								From vcx
								Where Platform = 'WINDOWS'
								And ! Empty( ObjName )
								And Empty( Parent )
								And ! Deleted( 'vcx' )
								Into Array lAClasses

						ENDTEXT

						&lcCommand

						Use In Select( 'vcx' )

						For Each lcClass In lAClasses
							TEXT To lcCommand NoShow TextMerge Pretext 15
									Clear Class '<<lcClass>>'
							ENDTEXT

							Try
								&lcCommand

							Catch To oErr
							Endtry

						Endfor

					Catch To oErr
						loError.Process( oErr, .F. )

					Endtry
				Endif
			Endfor

			*!*					loProject.Refresh()

		Endfor

		Set Sysmenu To

		* DAE 2009-07-31(12:03:04)
		* Clear Memory

		For i = 1 To Asessions( laSessions )

			Set DataSession To laSessions[ i ]

			Do While Txnlevel() > 0
				Rollback

			Enddo

		Endfor

		* DAE 2009-10-04
		LiberarForms()

		If Pemstatus( _Screen, 'oApp', 5 )
			_Screen.oApp = Null
			Removeproperty( _Screen, 'oApp' )

		Endif && Pemstatus( _Screen, 'oApp', 5 )

		If Pemstatus( _Screen, 'oGlobalSettings', 5 )
			_Screen.oGlobalSettings = Null
			Removeproperty( _Screen, 'oGlobalSettings' )

		Endif && Pemstatus( _Screen, 'oGlobalSettings', 5 )

		If Pemstatus( _Screen, 'oObjectFactory', 5 )
			_Screen.oObjectFactory = Null
			Removeproperty( _Screen, 'oObjectFactory' )

		Endif && Pemstatus( _Screen, 'oObjectFactory', 5 )

	Catch To oErr
		loError.Process( oErr, .T. )

	Finally
		loError = Null
		loFile = Null


		Set Sysmenu To Default

		If !Pemstatus( _Screen, "nEnv", 5 )
			AddProperty( _Screen, "nEnv", ENV_CLAUDFOX )
		Endif

		Do Tools\Varios\prg\mnxpraxis With _Screen.nEnv

	Endtry

	If Pemstatus( _Screen, "oApp", 5 )
		Removeproperty( _Screen, "oApp" )

	Endif

	Try
		Compile 'Tools\ErrorHandler\Prg\ErrorHandler.prg'

	Catch To oErr
	Endtry

	Try
		Compile fw\tieradapter\comun\prxbaselibrary.prg
	Catch To oErr
	Endtry

	Try
		Compile Classlib "fw\comunes\vcx\prxbase.vcx"
	Catch To oErr
	Endtry

	_Screen.ResetToDefault( "Picture" )
	_Screen.ResetToDefault( "Icon" )
	
	lcDefault = Curdir()
	Do Case
	Case lcDefault = "\CLIPPER2FOX\"
		_Screen.Caption = "Clipper2Fox v 1.00 - Microsoft Visual FoxPro"

	
	Case lcDefault = "\CLOUDFOX\"
		_Screen.Caption = "CloudFox v 1.00 - FronEnd Visual FoxPro"

	Otherwise
		_Screen.Caption = "Clipper2Fox v 1.00 - Microsoft Visual FoxPro"

	EndCase
	
	Set Date Dmy
	Set Century On
	Set Deleted Off

	* Wait Window '' Nowait
	* Wait Window "Entorno Liberado" Nowait Timeout 5

Catch To oErr
	loError = Newobject( "ErrorHandler", 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process( oErr, .T. )
	* Throw loError

Finally
	loError = Null
	Store .F. To lAClasses
	loForm = Null

	*!*			_Screen.Top = 72
	*!*			_Screen.Left = 42


Endtry

* LiberarMemoria()
Do LiberarMemoria In 'tools\varios\prg\LiberarMemoria.prg'

FoxTabs()

Do "Tools\Varios\prg\Setpath.prg" With _Screen.nEnv

*Do Tools\NameSpaces\Prg\LoadNameSpace.prg

Try
	Wait Window "Entorno Liberado" Nowait
	Inkey(2)

Catch To oErr

Finally
	Wait Clear

Endtry


*Messagebox( Set( "Path" ) , 0, _vfp.Caption, 2000 )

Return


*!*	Endproc && liberarEntorno

Procedure LiberarForms() As void
	Local loForm As Form
	Try
		If _Screen.FormCount > 0
			For i = _Screen.FormCount To 1
				loForm = _Screen.Forms[ i ]
				If ! Inlist( Lower( loForm.Name ), ;
						'foxtabstoolbar', '_parentclassbrowser', 'frmpanemanager' )
					Try
						Try
							loForm.Release()

						Catch To oErr
						Endtry

						Try
							loForm.Destroy()

						Catch To oErr
						Endtry
					Catch To oErr
					Finally
						loForm = Null

					Endtry

				Endif

			Next

		Endif

	Catch To oErr
		loError = Newobject( "ErrorHandler", 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process( oErr )
		Throw loError

	Finally
		loError = Null
		loForm = Null

	Endtry

Endproc && LiberarForms

*!*	*
*!*	* LogError

