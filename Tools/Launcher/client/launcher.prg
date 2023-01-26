Lparameters tcProgram As String,;
	tcLocalFolder As String,;
	tcServerFolder As String,;
	tcConfigurationFileName As String,;
	tcKeyModule As String


#INCLUDE "FW\Comunes\Include\Praxis.h"

Local loMain As Launcher Of "Tools\Launcher\Client\Launcher.prg"

Try

	Set Procedure To "Rutinas\rutina.prg"

	*!*		tcConfigurationFileName = "LauncherCentral.cfg"

	*!*		Text To lcCommand NoShow TextMerge Pretext 03
	*!*		tcProgram (<<Vartype(tcProgram)>>) <<tcProgram>>
	*!*		tcLocalFolder (<<Vartype(tcLocalFolder)>>) <<tcLocalFolder>>
	*!*		tcServerFolder (<<Vartype(tcServerFolder)>>) <<tcServerFolder>>
	*!*		tcConfigurationFileName (<<Vartype(tcConfigurationFileName)>>) <<tcConfigurationFileName>>
	*!*		tcKeyModule (<<Vartype(tcKeyModule)>>) <<tcKeyModule>>
	*!*		EndText

	*!*		MessageBox( lcCommand )

	If Vartype( tcProgram ) # "C"
		tcProgram = ""
	Endif
	tcProgram = Strtran( tcProgram, ['], [] )

	If Vartype( tcLocalFolder ) # "C"
		tcLocalFolder = ""
	Endif
	tcLocalFolder = Strtran( tcLocalFolder, ['], [] )

	If Vartype( tcServerFolder ) # "C"
		tcServerFolder = ""
	Endif
	tcServerFolder = Strtran( tcServerFolder, ['], [] )

	If Vartype( tcConfigurationFileName ) # "C"
		tcConfigurationFileName = ""
	Endif
	tcConfigurationFileName = Strtran( tcConfigurationFileName, ['], [] )

	If Vartype( tcKeyModule ) # "C"
		tcKeyModule = ""
	Endif
	tcKeyModule = Strtran( tcKeyModule, ['], [] )

	loMain = Newobject( "Launcher",;
		"Tools\Launcher\Client\Launcher.prg",;
		"",;
		tcProgram,;
		tcLocalFolder,;
		tcServerFolder,;
		tcConfigurationFileName,;
		tcKeyModule   )

	loMain.Launch( tcConfigurationFileName )

Catch To loErr
	Try
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )

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

	Endtry



Finally
	loMain = Null

Endtry

Return

************************************************************************************************************


*!* ///////////////////////////////////////////////////////
*!* Class.........: Launcher
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Clase principal
*!* Date..........: Domingo 6 de Julio de 2008 (14:30:27)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class Launcher As Session

	#If .F.
		Local This As Launcher Of "Tools\Launcher\Client\Launcher.prg"
	#Endif

	*!* Nombre del ejecutable
	cProgram = ""

	*!* Carpeta local donde se encuentra el ejecutable
	cLocalFolder = ""

	*!* Carpeta en el servidor donde se encuentra el ejecutable principal
	cServerFolder = ""

	*!* Nombre del archivo xml de configuración
	cConfigurationFileName = ""

	*!* Clave de acceso al módulo a ejecutarse
	cKeyModule = ""

	* Nombre del Archivo de Setup
	cSetupFile = "Launcher.cfg"


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="csetupfile" type="property" display="cSetupFile" />] + ;
		[<memberdata name="ckeymodule" type="property" display="cKeyModule" />] + ;
		[<memberdata name="cconfigurationfilename" type="property" display="cConfigurationFileName" />] + ;
		[<memberdata name="cprogram" type="property" display="cProgram" />] + ;
		[<memberdata name="cserverfolder" type="property" display="cServerFolder" />] + ;
		[<memberdata name="clocalfolder" type="property" display="cLocalFolder" />] + ;
		[<memberdata name="launch" type="method" display="Launch" />] + ;
		[<memberdata name="setup" type="method" display="Setup" />] + ;
		[<memberdata name="execute" type="method" display="Execute" />] + ;
		[<memberdata name="readinifile" type="method" display="ReadIniFile" />] + ;
		[<memberdata name="synchronizeversions" type="method" display="SynchronizeVersions" />] + ;
		[<memberdata name="synchronizefile" type="method" display="SynchronizeFile" />] + ;
		[<memberdata name="readsetupfile" type="method" display="ReadSetupFile" />] + ;
		[<memberdata name="reinstalllocalfolder" type="method" display="ReinstallLocalFolder" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Function......: Initialize
	*!* Description...:
	*!* Date..........: Domingo 6 de Julio de 2008 (14:30:27)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Init( tcProgram As String,;
			tcLocalFolder As String ,;
			tcServerFolder As String,;
			tcConfigurationFileName As String,;
			tcKeyModule As String ) As Boolean

		Try

			Set Safety Off

			*!* Nombre del ejecutable
			If !Empty( tcProgram )
				This.cProgram = tcProgram
			Endif

			*!* Carpeta local donde se encuentra el ejecutable
			If !Empty( tcLocalFolder )
				This.cLocalFolder = Alltrim( tcLocalFolder )
			Endif

			*!* Carpeta en el servidor donde se encuentra el ejecutable principal
			If !Empty( tcServerFolder )
				This.cServerFolder = Alltrim( tcServerFolder )
			Endif

			*!* Nombre del archivo xml de configuración
			If !Empty( tcConfigurationFileName )
				This.cConfigurationFileName = Alltrim( tcConfigurationFileName )
			Endif

			*!* Clave de acceso al módulo a ejecutarse
			If !Empty( tcKeyModule )
				This.cKeyModule = Alltrim( tcKeyModule )
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally

		Endtry


	Endfunc
	*!*
	*!* END FUNCTION Initialize
	*!*
	*!* ///////////////////////////////////////////////////////


	*
	*
	Procedure Launch( tcSetupFile ) As Void
		Local lcCommand As String,;
			lcLocalFolder As String

		Local loXA As prxXMLAdapter Of "FW\TierAdapter\Comun\PrxXmlAdapter.prg"
		Local llDBF As Boolean

		Try

			lcCommand = ""
			llDBF = .F.

			*!* Nombre del archivo de configuración
			If !Empty( tcSetupFile )
				This.cSetupFile = tcSetupFile
			Endif

			* Leer el Archivo de Configuración

			This.ReadSetupFile( This.cSetupFile )

			lcLocalFolder 	= Alltrim( This.cLocalFolder )

			This.ReinstallLocalFolder()

			This.Setup()

			Close Databases All
			This.Execute()


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Launch


	*
	* Reinstala la Carpeta local
	Procedure ReinstallLocalFolder(  ) As Void;
			HELPSTRING "Reinstala la Carpeta local "
		Local lcCommand As String,;
			lcTimerFile As String,;
			lcLocalFolder As String,;
			lcSetUpFile As String,;
			lcTerminal As String

		Local llReinstall As Boolean
		Local laDir[1]
		Local loFSO As "Scripting.FileSystemObject"

		Try

			lcCommand 		= ""
			lcSetUpFile 	= ""
			lcTerminal 		= ""
			llReinstall 	= .F.
			lcLocalFolder 	= Alltrim( This.cLocalFolder )
			lcTimerFile 	= Addbs( lcLocalFolder )+ "Timer.Tag"

			If FileExist( lcTimerFile )
				Adir( laDir, lcTimerFile )
				llReinstall = ( Val( Dtos( Date() )) - Val( Dtos( laDir[1,3] ) ) ) > 1

			Else
				llReinstall = .T.

			Endif

			If llReinstall

				Try

					* Guardar el archivo de configuracion personalizado
					If FileExist( Addbs( lcLocalFolder ) + "SetUp.cfg" )
						lcSetUpFile =  Filetostr( Addbs( lcLocalFolder ) + "SetUp.cfg" )
					Endif


					If FileExist( Addbs( lcLocalFolder ) + "Terminal.json" )
						lcTerminal =  Filetostr( Addbs( lcLocalFolder ) + "Terminal.json" )
					Endif

					* Eliminar la carpeta
					loFSO = Createobject("Scripting.FileSystemObject")
					loFSO.DeleteFolder(  lcLocalFolder )

					* Crearla Nuevamente
					Md ( lcLocalFolder )

					If !Empty( lcSetUpFile )
						* Crear el  archivo de configuracion personalizado
						Strtofile( lcSetUpFile, Addbs( lcLocalFolder ) + "SetUp.cfg" )
					Endif

					If !Empty( lcTerminal )
						* Crear el  archivo de configuracion personalizado
						Strtofile( lcTerminal, Addbs( lcLocalFolder ) + "Terminal.json" )
					Endif

					* Crear el archivo de control
					Strtofile( Ttoc( Datetime() ), lcTimerFile )

				Catch To oErr

				Finally

				Endtry
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loFSO = Null

		Endtry

		Return llReinstall

	Endproc && ReinstallLocalFolder




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Setup
	*!* Description...: Lee el archivo de configuración
	*!* Date..........: Domingo 6 de Julio de 2008 (14:43:42)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Setup(  ) As Void;
			HELPSTRING "Lee el archivo de configuración"

		Try

			This.SynchronizeVersions( This.ReadIniFile())

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE Setup
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ReadIniFile
	*!* Description...: Lee el archivo de configuración para poder instanciar el objeto
	*!* Date..........: Domingo 2 de Marzo de 2008 (18:47:50)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure ReadIniFile( ) As String ;
			HELPSTRING "Lee el archivo de configuración para poder instanciar el objeto"


		Local loXA As prxXMLAdapter Of "FW\Comun\Prg\prxXMLAdapter.prg"
		Local lcAlias As String,;
			lcXML As String,;
			lcCfgAlias As String,;
			lcCommand As String

		Try

			lcCommand = ""
			lcAlias = "Cfg" + Sys(2015)
			lcCfgAlias = ""

			If File( Addbs( This.cServerFolder ) + This.cConfigurationFileName )

				loXA = Newobject("prxXMLAdapter","FW\Comun\Prg\prxXMLAdapter.prg")

				lcXML = Filetostr( Addbs( This.cServerFolder ) + This.cConfigurationFileName )

				loXA.LoadXML( lcXML )
				loXA.Tables(1).ToCursor()
				loXA = Null

				lcCfgAlias = Alias()

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Select *
					From <<lcCfgAlias>>
						Where Alltrim(Lower( <<lcCfgAlias>>.ModuleName )) == 'common'
						Or Alltrim(Lower( <<lcCfgAlias>>.ModuleName )) == Alltrim(Lower( '<<This.cKeyModule>>' ))
					Into Cursor <<lcAlias>>
				ENDTEXT

				&lcCommand
				lcCommand = ""

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand   
			loError.Process ( m.loErr )
			Throw loError

		Finally
			If Used( lcCfgAlias )
				Use In Alias( lcCfgAlias )
			Endif
			loXA = Null

		Endtry

		Return lcAlias

	Endproc
	*!*
	*!* END PROCEDURE ReadIniFile
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SynchronizeVersions
	*!* Description...:
	*!* Date..........: Miércoles 9 de Julio de 2008 (14:08:32)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure SynchronizeVersions( tcAlias As String ) As Void

Local lcCommand as String 

		Try
			lcCommand = ""
			If Used( tcAlias )
				Select Alias( tcAlias )

				If Empty( Field( "SkipIfExist" ))
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Select 	*,
							.F. as SkipIfExist
						From <<tcAlias>>
						Into Cursor <<tcAlias>>
					ENDTEXT

					&lcCommand
					lcCommand = ""

				Endif

				Select Alias( tcAlias )
				Locate

				Scan
					This.SynchronizeFile( Alltrim( FileName ),;
						Alltrim( FileExt ),;
						Alltrim( SourceFolder ),;
						Alltrim( TargetFolder ),;
						SkipIfExist )
				Endscan


			Else
				Error "No se encuentra el archivo de configuración " + Addbs( This.cServerFolder ) + This.cConfigurationFileName

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand 
			loError.Process ( m.loErr )
			Throw loError

		Finally
			If Used( tcAlias )
				Use In Alias( tcAlias )
			Endif

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE SynchronizeVersions
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SynchronizeFile
	*!* Description...:
	*!* Date..........: Miércoles 9 de Julio de 2008 (14:14:11)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure SynchronizeFile( tcFileName As String,;
			tcFileExt As String,;
			tcSourceFolder As String,;
			tcTargetFolder As String,;
			tlSkipIfExist As Boolean ) As Void


		Local lcSourceFile As String,;
			lcTargetFile As String,;
			lcFileName As String

		Local lcServerVersion As String,;
			lcLocalVersion As String

		Local llSynchronize As Boolean
		Local laFV[1], laDir[1]

		Local oErr As Exception

		Local lnCount As Integer
		Local i As Integer
		Local lcAux As String

		Local lcSourceFolder As String,;
			lcTargetFolder As String


		Try

			If Empty( tcFileExt )
				lcFileName = tcFileName

			Else
				lcFileName = tcFileName + "." + tcFileExt

			Endif

			* Verificar si tcSourceFolder y/o tcTargetFolder contienen el path o el nombre de
			* una variable de entorno que contiene el path

			If Empty( tcTargetFolder )
				tcTargetFolder = Getenv( "USERPROFILE" )
				lcTargetFolder = tcTargetFolder
			Endif

			If Empty( At( "%", tcSourceFolder ))
				lcSourceFile = Addbs( tcSourceFolder ) + lcFileName
				lcSourceFolder = tcSourceFolder

			Else
				lnCount = Getwordcount( tcSourceFolder, "%" )
				lcSourceFile = ""
				lcSourceFolder = ""

				For i = 1 To lnCount
					lcAux = Getenv( Getwordnum( tcSourceFolder, i, "%" ))
					If Empty( lcAux )
						lcAux = Getwordnum( tcSourceFolder, i, "%" )
					Endif
					lcSourceFile = lcSourceFile + lcAux
				Endfor

				lcSourceFolder = lcSourceFile
				lcSourceFile = Addbs( lcSourceFile ) + lcFileName

			Endif


			If Empty( At( "%", tcTargetFolder ))
				lcTargetFile = Addbs( tcTargetFolder ) + lcFileName
				lcTargetFolder = tcTargetFolder

			Else
				lnCount = Getwordcount( tcTargetFolder, "%" )
				lcTargetFile = ""

				For i = 1 To lnCount
					lcAux = Getenv( Getwordnum( tcTargetFolder, i, "%" ))
					If Empty( lcAux )
						lcAux = Getwordnum( tcTargetFolder, i, "%" )
					Endif
					lcTargetFile = lcTargetFile + lcAux
				Endfor

				lcTargetFolder = lcTargetFile
				lcTargetFile = Addbs( lcTargetFile ) + lcFileName

			Endif

			lcSourceFile 	= lcSourceFile
			lcTargetFile 	= lcTargetFile
			lcTargetFolder 	= lcTargetFolder

			Wait Window "Verificando Archivo" + Chr( 13 ) + lcSourceFile  Nowait

			If !File( lcSourceFile )
				Error "No se encuentra el archivo de origen " + lcSourceFile
			Endif

			llSynchronize = .T.

			If File( lcTargetFile )

				Try

					If tlSkipIfExist
						llSynchronize = .F.

					Else
						Adir( laDir, lcTargetFile )
						lcLocalVersion = Dtos( laDir[1,3] ) + Strtran( laDir[1,4], ":", "" )
						lcLocalVersion = Strtran( lcLocalVersion, " ", "0" )

						Adir( laDir, lcSourceFile )
						lcServerVersion = Dtos( laDir[1,3] ) + Strtran( laDir[1,4], ":", "" )
						lcServerVersion = Strtran( lcServerVersion, " ", "0" )

						llSynchronize = lcServerVersion # lcLocalVersion

					Endif

				Catch To oErr
					llSynchronize = .T.

				Finally

				Endtry

			Endif

			If llSynchronize

				Try

					Md ( lcTargetFolder )

				Catch To oErr

				Finally

				Endtry

				Erase ( lcTargetFile )
				Copy File ( lcSourceFile  ) To ( lcTargetFile )

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE SynchronizeFile
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Execute
	*!* Description...: Ejecuta el programa externo
	*!* Date..........: Domingo 6 de Julio de 2008 (14:44:46)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure Execute(  ) As Void;
			HELPSTRING "Ejecuta el programa externo"


		Local lcCommand As String
		Local lcProgram As String
		Try

			TEXT To lcCommand NoShow TextMerge Pretext 15
			ChDir "<<Alltrim( This.cLocalFolder )>>"
			ENDTEXT

			&lcCommand
			lcCommand = ""

			lcProgram = Alltrim( This.cProgram )
			lcProgram = Strtran( lcProgram, "'", "" )
			lcProgram = Strtran( lcProgram, '"', '' )
			lcProgram = Strtran( lcProgram, '[', '' )
			lcProgram = Strtran( lcProgram, ']', '' )


			*/ Atencion: El comando tiene que tener Comillas Dobles (NO FUNCIONA CON APOSTROFES)
			* RA 2011-03-11(11:30:38)

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Run /N "<<lcProgram>>"
			ENDTEXT

			&lcCommand
			lcCommand = ""

			* Strtofile( lcCommand, "LaunchExecute Ok.prg" )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand 
			loError.Process ( m.loErr )
			Strtofile( lcCommand, "Error_LaunchExecute.prg" )
			Throw loError

		Finally


		Endtry

	Endproc
	*!*
	*!* END PROCEDURE Execute
	*!*
	*!* ///////////////////////////////////////////////////////



	*
	* Lee el archivo de Setup
	Procedure ReadSetupFile( tcFileName As String ) As Void;
			HELPSTRING "Lee el archivo de Setup"

		Local lcAlias As String
		Local lcLocalFolder As String
		Local lnCount As Integer
		Local i As Integer
		Local lcAux As String

		Try


			If !File( tcFileName )
				Error tcFileName + " - Archivo de configuración No Existe"
			Endif

			lcAlias = "Cfg" + Sys(2015)

			loXA = Newobject("prxXMLAdapter","FW\Comun\Prg\prxXMLAdapter.prg")

			lcXML = Filetostr( tcFileName )

			loXA.LoadXML( lcXML )
			loXA.Tables(1).ToCursor( .F., lcAlias )
			loXA = Null

			Select Alias( lcAlias )
			Locate

			*!* Nombre del ejecutable
			If Empty( This.cProgram )
				This.cProgram = Alltrim( Evaluate( lcAlias + ".cProgram" ))
			Endif

			*!* Carpeta local donde se encuentra el ejecutable
			If Empty( This.cLocalFolder )
				This.cLocalFolder = Evaluate( lcAlias + ".cLocalFolder" )
			Endif

			*!* Carpeta en el servidor donde se encuentra el ejecutable principal
			If Empty( This.cServerFolder )
				This.cServerFolder = Evaluate( lcAlias + ".cServerFolder" )
			Endif

			*!* Nombre del archivo xml de configuración
			This.cConfigurationFileName = Evaluate( lcAlias + ".cConfigurationFileName" )

			*!* Clave de acceso al módulo a ejecutarse
			If Empty( This.cKeyModule )
				This.cKeyModule = Evaluate( lcAlias + ".cKeyModule" )
			Endif

			If !Empty( At( "%", This.cLocalFolder ))
				lnCount = Getwordcount( This.cLocalFolder, "%" )
				lcLocalFolder = ""

				For i = 1 To lnCount
					lcAux = Getenv( Getwordnum( This.cLocalFolder, i, "%" ))
					If Empty( lcAux )
						lcAux = Getwordnum( This.cLocalFolder, i, "%" )
					Endif
					lcLocalFolder = lcLocalFolder + lcAux
				Endfor

				This.cLocalFolder = lcLocalFolder

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally

		Endtry



	Endproc && ReadSetupFile



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Launcher
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: LauncherConfig
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Crea un XML de configuración
*!* Date..........: Martes 4 de Marzo de 2008 (11:29:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class LauncherConfig As Collection

	#If .F.
		Local This As LauncherConfig Of "Tools\Launcher\Client\launcher.prg"
	#Endif

	* Crea un archivo para usar en desarrollo
	lDesarrollo = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ldesarrollo" type="property" display="lDesarrollo" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="createxml" type="method" display="CreateXML" />] + ;
		[<memberdata name="createcursor" type="method" display="CreateCursor" />] + ;
		[<memberdata name="process" type="method" display="Process" />] + ;
		[<memberdata name="processcollection" type="method" display="ProcessCollection" />] + ;
		[<memberdata name="removefile" type="method" display="RemoveFile" />] + ;
		[<memberdata name="getfile" type="method" display="GetFile" />] + ;
		[<memberdata name="setup" type="method" display="Setup" />] + ;
		[</VFPData>]



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Setup
	*!* Description...:
	*!* Date..........: Martes 8 de Julio de 2008 (18:36:43)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Setup(  ) As Void

		Local loFile As Object


		Try

			loFile = This.New( "gdiplus",;
				"dll" )

			If This.lDesarrollo
				loFile.SourceFolder = "S:\Runtime"

			Else
				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Runtime"

			Endif


			loFile = This.New( "msvcr71",;
				"dll" )
			If This.lDesarrollo
				loFile.SourceFolder = "S:\Runtime"

			Else
				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Runtime"

			Endif

			loFile = This.New( "vfp9r",;
				"dll" )
			If This.lDesarrollo
				loFile.SourceFolder = "S:\Runtime"

			Else
				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Runtime"

			Endif

			loFile = This.New( "VFP9RENU",;
				"dll" )
			If This.lDesarrollo
				loFile.SourceFolder = "S:\Runtime"

			Else
				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Runtime"

			Endif


			loFile = This.New( "vfp9t",;
				"dll" )
			If This.lDesarrollo
				loFile.SourceFolder = "S:\Runtime"

			Else
				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Runtime"

			Endif


			loFile = This.New( "ReportBuilder",;
				"app" )
			If This.lDesarrollo
				loFile.SourceFolder = "S:\Runtime"

			Else
				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Runtime"

			Endif


			loFile = This.New( "ReportPreview",;
				"app" )
			If This.lDesarrollo
				loFile.SourceFolder = "S:\Runtime"

			Else
				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Runtime"

			Endif


			loFile = This.New( "ReportOutput",;
				"app" )
			If This.lDesarrollo
				loFile.SourceFolder = "S:\Runtime"

			Else
				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Runtime"

			Endif

			* Carpeta para archivos transitorios

			loFile = This.New( "Dummy",;
				"tag" )
			loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Dbf"
			loFile.TargetFolder= Addbs( loFile.TargetFolder ) + "Dbf"

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE Setup
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetFile
	*!* Description...: Devuelve un elemento de la coleccion
	*!* Date..........: Martes 29 de Abril de 2008 (09:17:18)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Getfile( tcFileName As String,;
			tcFileExt As String,;
			tcModuleName As String ) As Object;
			HELPSTRING "Devuelve un elemento de la coleccion"

		Local i As Integer
		Local loFile As Object
		Local lcKey As String

		Try

			loFile = Null

			If Empty( tcModuleName )
				tcModuleName = "Common"
			Endif

			lcKey = Strtran( Lower( tcModuleName + "_" + tcFileName + "_" + tcFileExt ), " ", "_" )

			i = This.GetKey( lcKey )

			If !Empty( i )
				loFile = This.Item( i )
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loFile
	Endproc
	*!*
	*!* END PROCEDURE GetFile
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: RemoveFile
	*!* Description...: Elimina un elemento de la coleccion
	*!* Date..........: Martes 29 de Abril de 2008 (09:16:49)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure RemoveFile( tcFileName As String,;
			tcFileExt As String,;
			tcModuleName As String ) As Void;
			HELPSTRING "Elimina un elemento de la coleccion"


		Local i As Integer
		Local lcKey As String

		Try

			If Empty( tcModuleName )
				tcModuleName = "Common"
			Endif

			lcKey = Strtran( Lower( tcModuleName + "_" + tcFileName + "_" + tcFileExt ), " ", "_" )

			i = This.GetKey( lcKey )


			If !Empty( i )
				This.Remove( i )
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE RemoveFile
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Process
	*!* Description...:
	*!* Date..........: Martes 4 de Marzo de 2008 (13:09:43)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Process(  ) As Void


		Try

			Local lcFileName As String

			This.Setup()

			lcFileName = Putfile( "", "LauncherCfg", "xml" )

			If !Empty( lcFileName )
				This.CreateXML( lcFileName )
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError


		Finally

		Endtry


	Endproc
	*!*
	*!* END PROCEDURE Process
	*!*
	*!* ///////////////////////////////////////////////////////


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateCursor
	*!* Description...: Crea el cursor
	*!* Date..........: Martes 4 de Marzo de 2008 (11:56:03)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure CreateCursor( tcCursorName As String ) As Boolean;
			HELPSTRING "Crea el cursor"


		Try

			Local lcCommand As String
			Local loTierRecord As Object
			Local llOk As Boolean

			llOk = .F.

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Cursor <<tcCursorName>> (
				ModuleName C(128),
				FileName C(128),
				FileExt C(10),
				SourceFolder C(128),
				TargetFolder C(128),
				SkipIfExist L )
			ENDTEXT

			&lcCommand

			This.ProcessCollection( This, tcCursorName )

			llOk = .T.

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError


		Finally

		Endtry

		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE CreateCursor
	*!*
	*!* ///////////////////////////////////////////////////////




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: ProcessCollection
	*!* Description...: Recorre la coleccion
	*!* Date..........: Lunes 14 de Abril de 2008 (13:40:54)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure ProcessCollection( toCol As Collection,;
			tcCursorName As String ) As Void;
			HELPSTRING "Recorre la coleccion"


		Try

			lcCommand = ""

			For Each loFileInfo In toCol

				If Empty( loFileInfo.ModuleName )
					Error " Falta indicar ModuleName "

				Endif

				If Empty( loFileInfo.FileName )
					Error " Falta indicar FileName "

				Endif

				If Empty( loFileInfo.SourceFolder )
					Error " Falta indicar SourceFolder "

				Endif

				If Empty( loFileInfo.TargetFolder )
					Error " Falta indicar TargetFolder "

				Endif

				TEXT To lcCommand NoShow TextMerge Pretext 15
					Insert into <<tcCursorName>> (
					ModuleName,
					FileName,
					FileExt,
					SourceFolder,
					TargetFolder,
					SkipIfExist ) values (
					'<<loFileInfo.ModuleName>>',
					'<<loFileInfo.FileName>>',
					'<<loFileInfo.FileExt>>',
					'<<loFileInfo.SourceFolder>>',
					'<<loFileInfo.TargetFolder>>',
					<<loFileInfo.SkipIfExist>> )
				ENDTEXT

				&lcCommand
				lcCommand = ""

			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

	Endproc
	*!*
	*!* END PROCEDURE ProcessCollection
	*!*
	*!* ///////////////////////////////////////////////////////



	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CreateXML
	*!* Description...: Genera el XML
	*!* Date..........: Martes 4 de Marzo de 2008 (11:52:40)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure CreateXML( tcFileName As String ) As Boolean;
			HELPSTRING "Genera el XML"


		Try
			Local llOk As Boolean
			Local loXA As Xmladapter
			Local lcAlias As String


			llOk = .F.
			lcAlias = Strtran( Juststem( tcFileName ), " ", "_" )

			If This.CreateCursor( lcAlias )
				If Lower( Justext( tcFileName )) <> "xml"
					tcFileName = Addbs( Justpath( tcFileName )) + Juststem( tcFileName ) + ".xml"
				Endif

				loXA = Createobject( "XMLAdapter" )
				loXA.AddTableSchema( lcAlias  )
				loXA.PreserveWhiteSpace = .T.
				loXA.ToXML( tcFileName,"", .T. )

			Endif

			llOk = .T.

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			If Used( lcAlias )
				Use In Alias( lcAlias )
			Endif
			loXA = Null

		Endtry

		Return llOk

	Endproc
	*!*
	*!* END PROCEDURE CreateXML
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Devuelve un objeto TierConfg
	*!* Date..........: Martes 4 de Marzo de 2008 (11:34:00)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure New( tcFileName As String,;
			tcFileExt As String,;
			tcModuleName As String ) As Object;
			HELPSTRING "Devuelve un objeto TierConfg"


		Try
			Local loFileInfo As Object
			Local loReturn As Object
			Local lcKey As String
			Local i As Integer

			lcKey = ""

			If Empty( tcFileName )
				Error "tcFileName No puede estar vacía"
			Endif

			If Empty( tcFileExt )
				tcFileExt = ""
			Endif

			If Empty( tcModuleName )
				tcModuleName = "Common"
			Endif


			lcKey = Strtran( Lower( tcModuleName + "_" + tcFileName + "_" + tcFileExt ), " ", "_" )
			i = This.GetKey( lcKey )

			If Empty( i )

				loFileInfo = Createobject( "Empty" )

				AddProperty( loFileInfo, "ModuleName", tcModuleName )
				AddProperty( loFileInfo, "FileName", tcFileName )
				AddProperty( loFileInfo, "FileExt", tcFileExt )
				AddProperty( loFileInfo, "SourceFolder", "" )
				AddProperty( loFileInfo, "TargetFolder", "" )
				AddProperty( loFileInfo, "ModuleId", 0 )
				AddProperty( loFileInfo, "SkipIfExist", .F. )

				This.Add( loFileInfo, lcKey )

			Else
				loFileInfo = This.Item( i )

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )

			loError.Remark = lcKey

			loError.Process( loErr )
			Throw loError


		Finally

		Endtry

		Return loFileInfo

	Endproc
	*!*
	*!* END PROCEDURE New
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: LauncherConfig
*!*
*!* ///////////////////////////////////////////////////////
