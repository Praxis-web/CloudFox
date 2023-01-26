
Local loPjx As ProjectHook
Local loFile As VisualFoxpro.IFoxPrjFile
Local loFiles As Collection
Local loBuilder As Builder Of "V:\CloudFox\Tools\Builder\Prg\Builder.prg"


Try

	loBuilder = Newobject( "Builder", "Tools\Builder\Prg\Builder.prg" )
	loBuilder.cExeFolder = Set("Default") + Curdir() + "Clientes\Pyme"
	loBuilder.cProjectFolder = loBuilder.cExeFolder

	loProyecto = loBuilder.New( "prGesVen", "prGesVen" )
	loProyecto = loBuilder.New( "prGesCom", "prGesCom" )
	loProyecto = loBuilder.New( "prCCDeud", "prCCDeud" )

	loBuilder.Build()


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError



Finally
	loBuilder = Null
	loProyecto = Null
Endtry

*******************************************************************************************************

*!* ///////////////////////////////////////////////////////
*!* Class.........: Builder
*!* ParentClass...: prxCustom Of 'V:\CloudFox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....: Custom
*!* Description...: Construye los ejecutables de la solucion
*!* Date..........: Miércoles 23 de Junio de 2010 (12:39:42)
*!* Author........: Ricardo Aidelman
*!* Project.......: CloudFox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

*!*	Define Class Builder As prxCustom Of 'V:\CloudFox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
Define Class Builder As prxCollection Of 'V:\CloudFox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'

	#If .F.
		Local This As Builder Of "V:\CloudFox\Tools\Builder\Prg\Builder.prg"
	#Endif

	* Carpeta donde se encuentra el proyecto
	cProjectFolder = ""

	* Carpeta donde se guarda el ejecutable
	cExeFolder = ""


	* Fuerza que se recompile el proyecto
	lRecompile = .F.

	*
	cScreenCaption = _Screen.Caption

	* Agrega al proyecto los .h
	lLoadIncludes = .T.

	* Coleccion de Archivos a incluir
	oIncludeCollection = Null

	* Specifies the icon displayed for a distributed .exe application.
	Icon = "fw\Comunes\Image\ico\Fenix.ico"

	* Archivo a ejecutar para establecer el entorno
	cSetEnvironment = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="icon" type="property" display="Icon" />] + ;
		[<memberdata name="cexefolder" type="property" display="cExeFolder" />] + ;
		[<memberdata name="cexefolder_assign" type="method" display="cExeFolder_Assign" />] + ;
		[<memberdata name="cprojectfolder" type="property" display="cProjectFolder" />] + ;
		[<memberdata name="lrecompile" type="property" display="lRecompile" />] + ;
		[<memberdata name="cscreencaption" type="property" display="cScreenCaption" />] + ;
		[<memberdata name="lloadincludes" type="property" display="lLoadIncludes" />] + ;
		[<memberdata name="oincludecollection" type="property" display="oIncludeCollection" />] + ;
		[<memberdata name="build" type="method" display="Build" />] + ;
		[<memberdata name="verifyproject" type="method" display="VerifyProject" />] + ;
		[<memberdata name="checkdates" type="method" display="CheckDates" />] + ;
		[<memberdata name="buildproject" type="method" display="BuildProject" />] + ;
		[<memberdata name="loadincludefiles" type="method" display="LoadIncludeFiles" />] + ;
		[<memberdata name="setup" type="method" display="SetUp" />] + ;
		[<memberdata name="setenvironment" type="method" display="SetEnvironment" />] + ;
		[<memberdata name="csetenvironment" type="property" display="cSetEnvironment" />] + ;
		[</VFPData>]

	*
	* Genera los ejecutables
	Procedure Build(  ) As Void;
			HELPSTRING "Genera los ejecutables"

		Local loProyecto As oProyecto Of "V:\CloudFox\Tools\Builder\Prg\Builder.prg"
		Local lnSeconds As Number

		Try

			lnSeconds = Seconds()

			Do Tools\Varios\prg\LiberarEntorno

			* Recorrer la coleccion
			For Each loProyecto In This

				* Seteo Global
				This.SetEnvironment()

				* Seteo específico del proyecto
				loProyecto.SetEnvironment()

				If !loProyecto.lBuild
					loProyecto.lBuild = This.lRecompile
				Endif

				Wait Window "Verificando " + loProyecto.cProjectName Nowait

				This.VerifyProject( loProyecto )

				If !loProyecto.lBuild
					This.CheckDates( loProyecto )
				Endif

				If loProyecto.lBuild
					This.BuildProject( loProyecto, This.lRecompile )
				Endif

				If _vfp.ActiveProject.Visible = .F.
					_vfp.ActiveProject.Close()
				Endif

			Endfor


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Wait Clear
			loProyecto = Null
			_Screen.Caption = This.cScreenCaption
			Do Tools\Varios\prg\LiberarEntorno
			Messagebox( "Proceso Terminado en " + Transform( Seconds() - lnSeconds ), 64, "Builder", 500 )


		Endtry

	Endproc && Build

	*
	* Realiza el Build del proyecto
	Procedure BuildProject( toItem As Object, tlRecompile As Boolean ) As Void;
			HELPSTRING "Realiza el Build del proyecto"

		Local lcProjectFolder As String
		Local lcExeFolder As String
		Local lcProjectName As String
		Local lcExeName As String
		Local lcExeFileName As String
		Local lcProjectFileName As String
		Local lopjHook As pjHook Of "tools\projecthook\vcx\projecthookvss.vcx"

		Try

			lcCommand = ""
			lcProjectFolder = toItem.cProjectFolder
			lcExeFolder 	= toItem.cExeFolder
			lcProjectName 	= toItem.cProjectName
			lcExeName 		= toItem.cExeName

			lcExeFileName 		= Addbs( lcExeFolder ) + lcExeName
			lcProjectFileName 	= Addbs( lcProjectFolder ) + lcProjectName

			If Empty( Justext( lcExeFileName ))
				lcExeFileName = lcExeFileName + ".exe"
			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Build Project '<<lcProjectFileName>>' <<Iif( tlRecompile, "Recompile", "" )>>
			ENDTEXT

			lopjHook = _vfp.ActiveProject.ProjectHook

			If Vartype( lopjHook ) # "O"
				lopjHook = Newobject( "pjHook", "Tools\ProjectHook\Vcx\ProjectHookVss.vcx" )
				_vfp.ActiveProject.ProjectHook = lopjHook
			Endif

			lopjHook.lSkipSetPath = .T.

			lopjHook.Icon = toItem.Icon
			lopjHook.cMessage = lcCommand
			lopjHook.cProjectPath = lcProjectFolder

			&lcCommand

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Build Exe '<<lcExeFileName>>' From '<<lcProjectFileName>>'
			ENDTEXT

			lopjHook.cMessage = lcCommand
			&lcCommand

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			lopjHook = Null

		Endtry

	Endproc && BuildProject

	*
	* Verifica la fecha de creacion del ejecutable y las fuentes
	Procedure CheckDates( toItem As Object ) As Void;
			HELPSTRING "Verifica la fecha de creacion del ejecutable y las fuentes"

		Local lcExeFolder As String
		Local lcExeName As String
		Local lcExeFileName As String
		Local lcExeVersion As String
		Local lcFileVersion As String
		Local lcFileName As String
		Local Array laDir( 1 )

		Try

			lcExeVersion	= ""
			lcExeFolder 	= toItem.cExeFolder
			lcExeName 		= toItem.cExeName

			lcExeFileName 	= Addbs( lcExeFolder ) + lcExeName

			If Empty( Justext( lcExeFileName ))
				lcExeFileName = lcExeFileName + ".exe"
			Endif


			* Obtener la version del ejecutable
			If File( lcExeFileName )

				Adir( laDir, lcExeFileName )

				Try
					lcExeVersion = Dtos( laDir[1,3] ) + Strtran( laDir[1,4], ":", "" )
					lcExeVersion = Strtran( lcExeVersion, " ", "0" )

				Catch To oErr
					toItem.lBuild = .T.

				Finally

				Endtry

			Else
				toItem.lBuild = .T.

			Endif

			This.oIncludeCollection = Createobject( "Collection" )

			If !toItem.lBuild

				* Recorrer el proyecto, obteniendo la version de cada elemento,
				* y comprrarla con la del ejecutable
				For Each loFile As VisualFoxpro.IFoxPrjFile In _vfp.ActiveProject.Files
					If !loFile.Exclude
						lcFileVersion = Ttoc( loFile.LastModified, 1 )

						If lcFileVersion > lcExeVersion
							toItem.lBuild = .T.
							If !This.lLoadIncludes
								Exit
							Endif
						Endif
					Endif

					* Crear una coleccion con los .h declarados en cada .prg
					If This.lLoadIncludes And loFile.Type = "P"
						This.LoadIncludeFiles( loFile )
					Endif
				Endfor
			Endif

			* Agregar al proyecto los .h
			If !Empty( This.oIncludeCollection.Count )
				For Each lcFileName In This.oIncludeCollection
					Try

						* Verificar si está Incluido en el Proyecto
						loFile = _vfp.ActiveProject.Files( Justfname( lcFileName ))

					Catch To oErr
						Try

							lcCommand = lcFileName

							If FileExist( lcFileName )
								_vfp.ActiveProject.Files.Add( lcFileName )
								toItem.lBuild = .T.

							Else
								lcFileName = Getfile( Justext( lcFileName ),;
									"",;
									"",;
									0,;
									"No se encuentra [" + lcFileName + "]" )

								If !Empty( lcFileName )
									_vfp.ActiveProject.Files.Add( lcFileName )
									toItem.lBuild = .T.

								Endif

							Endif


						Catch To loErr
							Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
							loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
							loError.cRemark = lcCommand
							loError.Process ( m.loErr )
							Throw loError

						Finally


						Endtry

					Finally

					Endtry

				Endfor
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && CheckDates

	*
	* Agrega al proyecto los archivos de cabecera .h
	Procedure LoadIncludeFiles( toFile As VisualFoxpro.IFoxPrjFile ) As Void;
			HELPSTRING "Agrega al proyecto los archivos de cabecera .h"

		Local lcLine As String,;
			lcKey As String
		Local i As Integer,;
			j As Integer


		Local lcCommand As String

		Try

			lcCommand = toFile.Name

			Alines( laLines, Filetostr( toFile.Name ), 1 + 4 )
			lcCommand = ""

			j = -1
			Do While .T.
				i = Ascan( laLines, '#Include', j, -1, -1, 5 )

				If !Empty( i )
					j = i + 1

					lcLine = Alltrim( Substr( laLines[ i ], 9 ) )
					lcLine = Chrtran( lcLine, ['"], "" )
					lcLine = Chrtran( lcLine, '[]', "" )

					lcKey = Lower( Justfname( lcLine ) )

					i = This.oIncludeCollection.GetKey( lcKey )

					If Empty( i )
						This.oIncludeCollection.Add( lcLine, lcKey )
					Endif

				Else
					Exit

				Endif
			Enddo

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry


	Endproc && LoadIncludeFiles

	*
	*
	Procedure VerifyProject( toItem As Object ) As Void

		Local loProject As pjHook Of "tools\projecthook\vcx\projecthookvss.vcx"

		Local lcMenuFileName As String,;
			lcProjectFolder As String,;
			lcExeFolder As String,;
			lcProjectName As String,;
			lcExeName As String,;
			lcCurdir As String,;
			lcFileName As String,;
			lcPrefijo As String

		Local llFound As Boolean,;
			llAlreadyOpen As Boolean,;
			llGetFile As Boolean

		Local Array laFields[ 1 ]

		Local loFile As VisualFoxpro.IFoxPrjFile

		Local loProject As ProjectHook

		Local lnVersion As Integer

		Try


			* Default Folder
			lcCommand = ""
			lcCurdir 		= Set("Default") + Curdir()

			lcMenuFileName 	= toItem.cMenuFileName
			lcProjectFolder = toItem.cProjectFolder
			lcExeFolder 	= toItem.cExeFolder
			lcProjectName 	= toItem.cProjectName
			lcExeName 		= toItem.cExeName

			lnVersion = 1


			* Abrir proyecto

			llAlreadyOpen = .F.
			For Each loProject In _vfp.Projects
				If Lower( loProject.Name ) = Lower( Addbs( lcProjectFolder ) + lcProjectName )
					llAlreadyOpen = .T.
					Exit
				Endif
			Endfor

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Modify Project '<<( Addbs( lcProjectFolder ) + lcProjectName )>>' Nowait <<Iif( llAlreadyOpen, "", "NoShow" )>>
			ENDTEXT

			&lcCommand

			loProject = _vfp.ActiveProject
			_Screen.Caption = "Procesando: " + _vfp.ActiveProject.Name

			If !Empty( lcMenuFileName )

				* Averiguar Prefijo ( M6 o M5 )
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Select *
				From ( "<<lcMenuFileName>>" )
				Where 1 = 0 Into Cursor cCursor
				ENDTEXT

				&lcCommand

				Afields( laFields, "cCursor" )

				lcPrefijo = Substr( laFields[ 1, 1 ], 1, 2 )

				If Upper( lcPrefijo ) = "ID"
					* Traer todos los programas del Menú
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Select 	Nombre as FileName,
							Folder as Folder
				    From ( "<<lcMenuFileName>>" )
					Where !Deleted() And !Empty( Nombre ) into cursor cCursor
					ENDTEXT

					lnVersion = 2

				Else
					* Traer todos los programas del Menú
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Select <<lcPrefijo>>Nom as FileName,
						<<lcPrefijo>>Folder as Folder
				    From ( "<<lcMenuFileName>>" )
					Where !Deleted() And !Empty( <<lcPrefijo>>Nom ) into cursor cCursor
					ENDTEXT

					lnVersion = 1

				Endif

				&lcCommand

				Locate

				* Recorrer el cursor
				Scan
					Try

						TEXT To lcFileName NoShow TextMerge Pretext 15
						<<Set("Default")>><<Curdir()>><<Addbs(Alltrim(Evaluate( "Folder" )))>><<Alltrim(Evaluate( "FileName" ))>>.prg
						ENDTEXT

						llFound = .T.

						* Verificar si está Incluido en el Proyecto
						loFile = _vfp.ActiveProject.Files( lcFileName )
						loFile.Exclude = .F.

					Catch To oErr
						If Lower( Juststem( lcFileName )) # "s_nohabi"
							llFound = .F.
						Endif

					Finally

					Endtry

					If !llFound
						lcOldName = Juststem( lcFileName )
						llGetFile = .F.

						If !File( lcFileName )
							lcFileName = Getfile( Justext( lcFileName ), "", "", 0, Justfname( lcFileName ) )
							llGetFile = .T.
						Endif

						If !Empty( lcFileName )
							_vfp.ActiveProject.Files.Add( lcFileName )

							If llGetFile
								lcProgram 	= Juststem( lcFileName )
								lcFolder 	= Justpath( lcFileName )
								lcDefault 	= Set("Default") + Curdir()
								lcFolder 	= Strtran( lcFolder, lcDefault, "", -1, -1, 1 )

								* Actualizar el Menú

								If lnVersion = 2
									TEXT To lcCommand NoShow TextMerge Pretext 15
									Update "<<lcMenuFileName>>"
										Set Nombre = '<<Proper(lcProgram)>>',
										    Folder = '<<Proper(lcFolder)>>'
										Where Lower(Nombre) = '<<Lower(lcOldName)>>'
									ENDTEXT

								Else
									TEXT To lcCommand NoShow TextMerge Pretext 15
									Update "<<lcMenuFileName>>"
										Set <<lcPrefijo>>Nom = '<<Proper(lcProgram)>>',
										    <<lcPrefijo>>Folder = '<<Proper(lcFolder)>>'
										Where Lower(<<lcPrefijo>>Nom) = '<<Lower(lcOldName)>>'
									ENDTEXT

								Endif

								&lcCommand

							Endif
						Endif

						toItem.lBuild = .T.

					Endif

				Endscan

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loProject = Null
			loFile = Null

		Endtry

	Endproc && VerifyProject



	*
	* Setea el entorno
	Procedure SetEnvironment(  ) As Void;
			HELPSTRING "Setea el entorno"
		Local lcCommand As String

		Try

			lcCommand = ""
			Do "Tools\Varios\prg\SetPath"

			If !Empty( This.cSetEnvironment )
				Execscript( This.cSetEnvironment )
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && SetEnvironment

	*
	* Devuelve un objeto donde cargar los datos de cada proyecto
	Procedure New( tcProjectName As String,;
			tcMenuFileName As String,;
			tcKey As String ) As Void;
			HELPSTRING "Devuelve un objeto donde cargar los datos de cada proyecto"

		Local loProyecto As oProyecto Of "V:\CloudFox\Tools\Builder\Prg\Builder.prg"
		Local lcKey As String

		Try

			If Empty( tcKey )
				lcKey = tcProjectName

			Else
				lcKey = tcKey

			Endif

			loProyecto = This.GetItem( Lower( lcKey ))

			If Isnull( loProyecto )

				If Empty( tcMenuFileName )
					tcMenuFileName = Addbs( This.cProjectFolder ) + Addbs( tcProjectName ) + tcProjectName
				Endif

				loProyecto = Newobject( "oProyecto", "Tools\Builder\Prg\Builder.prg" )

				loProyecto.cMenuFileName 	= tcMenuFileName
				loProyecto.cProjectFolder 	= Addbs( This.cProjectFolder + tcProjectName )
				loProyecto.cExeFolder 		= This.cExeFolder
				loProyecto.cProjectName 	= tcProjectName
				loProyecto.cModulo  		= tcProjectName
				loProyecto.cExeName 		= lcKey
				loProyecto.lBuild 			= .F.
				loProyecto.Icon 			= This.Icon


				This.Add( loProyecto, Lower( lcKey ) )

			Else
				If !Empty( tcMenuFileName )
					loProyecto.cMenuFileName = tcMenuFileName
				Endif

				loProyecto.cExeFolder = This.cExeFolder

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loProyecto

	Endproc && New

	*
	*
	Procedure Setup(  ) As Void
		Try


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && SetUp


	* cExeFolder_Assign

	Protected Procedure cExeFolder_Assign( uNewValue )
		Local loProject As Object
		Try


			If Vartype( uNewValue ) # "C"
				uNewValue = ""
			Endif

			If Empty( uNewValue )
				uNewValue = ""
			Endif

			For Each loProject In This
				loProject.cExeFolder = uNewValue
			Endfor


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			This.cExeFolder = uNewValue
			loProject = Null
		Endtry




	Endproc && cExeFolder_Assign

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Builder
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oProyecto
*!* ParentClass...: prxCustom Of 'V:\CloudFox\Fw\Tieradapter\Comun\prxBaseLibrary.prg'
*!* BaseClass.....: Custom
*!* Description...:
*!* Date..........: Martes 20 de Agosto de 2013 (13:07:06)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class oProyecto As prxCustom Of 'V:\CloudFox\Fw\Tieradapter\Comun\prxBaseLibrary.prg'

	#If .F.
		Local This As oProyecto Of "V:\CloudFox\Tools\Builder\Prg\Builder.prg"
	#Endif

	* Nombre del archivo de Menu
	cMenuFileName = ""

	* Carpeta del proyecto
	cProjectFolder = ""

	* Carpeta del ejecutable
	cExeFolder = ""

	* Nombre del Proyecto
	cProjectName = ""

	* Nombre del Ejecutable
	cExeName = ""

	*
	lBuild = .F.

	*
	Icon = ""

	* Archivo a ejecutar para establecer el entorno
	cSetEnvironment = ""

	* Nombre familiar del Módulo.
	* El default es cProjectName
	cModulo = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="icon" type="property" display="Icon" />] + ;
		[<memberdata name="lbuild" type="property" display="lBuild" />] + ;
		[<memberdata name="cexename" type="property" display="cExeName" />] + ;
		[<memberdata name="cprojectname" type="property" display="cProjectName" />] + ;
		[<memberdata name="cexefolder" type="property" display="cExeFolder" />] + ;
		[<memberdata name="cprojectfolder" type="property" display="cProjectFolder" />] + ;
		[<memberdata name="cmenufilename" type="property" display="cMenuFileName" />] + ;
		[<memberdata name="setenvironment" type="method" display="SetEnvironment" />] + ;
		[<memberdata name="csetenvironment" type="property" display="cSetEnvironment" />] + ;
		[<memberdata name="cmodulo" type="property" display="cModulo" />] + ;
		[</VFPData>]


	*
	* Setea el entorno
	Procedure SetEnvironment(  ) As Void;
			HELPSTRING "Setea el entorno"
		Local lcCommand As String

		Try

			lcCommand = ""

			If !Empty( This.cSetEnvironment )
				Execscript( This.cSetEnvironment )
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && SetEnvironment

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oProyecto
*!*
*!* ///////////////////////////////////////////////////////
