Local lcCommand As String
Local loRunExe As RunExe Of "V:\Cloudfox\Tools\Varios\Prg\RunExe.prg"

Try

	lcCommand = ""
	Set Procedure To "V:\Cloudfox\Rutinas\rutina.prg" Additive

	loRunExe = Createobject( "RunExe" )
	loRunExe.Process()

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError


Finally
	loRunExe = Null


Endtry



*!* ///////////////////////////////////////////////////////
*!* Class.........: RunExe
*!* ParentClass...: BuildProject Of 'V:\CloudFenix\Tools\Varios\Prg\BuildActiveProject.prg'
*!* BaseClass.....: Custom
*!* Description...: Ejecuta el programa principal en modo desarrollo
*!* Date..........: Viernes 24 de Enero de 2014 (08:00:29)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class RunExe As BuildProject Of 'V:\Cloudfox\Tools\Varios\Prg\BuildActiveProject.prg'

	#If .F.
		Local This As RunExe Of "V:\Cloudfox\Tools\Varios\Prg\RunExe.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="runexe" type="method" display="RunExe" />] + ;
		[</VFPData>]

	*
	* Proceso principal
	Procedure Process(  ) As Void;
			HELPSTRING "Proceso principal"

		Local lcCommand As String,;
			lcProjectName As String

		Local loBuilder As Builder Of "V:\Cloudfox\Tools\Builder\Prg\Builder.prg"

		Try

			lcCommand = ""

			loBuilder = This.GetBuilderObject()

			If Vartype( loBuilder ) = "O"
				lcProjectName = This.ElegirProyecto( loBuilder, .F., "Run Exe: " )

				If !Empty( lcProjectName )

					This.RunExe( loBuilder, lcProjectName )

				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

			*!*	            Try

			*!*	                loProject = _vfp.ActiveProject

			*!*	                If Vartype( loProject ) = "O"
			*!*	                    lcProject = loProject.Name
			*!*	                    loProject.Close()
			*!*	                    Modify Project ( lcProject )
			*!*	                    loProject = Null
			*!*	                EndIf
			*!*
			*!*	            Catch To oErr

			*!*	            Finally
			*!*	                loProject = Null
			*!*	                loFile = Null
			*!*	                loFiles = Null
			*!*	                loBuilder = Null

			*!*	            Endtry

		Endtry

	Endproc && Process



	*
	* Corre el Ejecutable
	Procedure RunExe( oBuilder As Object, cProjectName As String ) As Void;
			HELPSTRING "Corre el Ejecutable"

		Local lcCommand As String,;
			lcProjectName As String,;
			lcExeFile As String,;
			lcExeFolder As String,;
			lcDrive As String,;
			lcCurdir As String

		Local loBuilder As Builder Of "Tools\Builder\Prg\Builder.prg"
		Local loProject As VisualFoxpro.IFoxProject
		Local loProyecto As oProyecto Of "Tools\Builder\Prg\Builder.prg"
		Local loMain As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

		Try

			lcCommand 	= ""
			lcDrive 	= Set("Default")
			lcCurdir 	= Curdir()

			loBuilder 	= oBuilder
			loProyecto 	= loBuilder.GetItem( Lower( cProjectName ))

			lcExeFolder = loProyecto.cExeFolder
			lcExeFile 	= loProyecto.cExeName

			TEXT To lcCommand NoShow TextMerge Pretext 15
            Cd '<<lcExeFolder>>'
			ENDTEXT

			&lcCommand

			If Empty( Justext( lcExeFile ) )
				lcExeFile = lcExeFile + ".exe"
			Endif

			Do "Fw\Comunes\prg\RunShell.prg" With lcExeFile


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loBuilder = Null
			loProject = Null

			Try

				lcCommand = ""

				TEXT To lcCommand NoShow TextMerge Pretext 15
            	Cd '<<lcDrive>><<lcCurdir>>'
				ENDTEXT

				&lcCommand


			Catch To loErr
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = lcCommand
				loError.Process ( m.loErr )
				Throw loError

			Finally


			Endtry

		Endtry

	Endproc && RunExeProgram



Enddefine
*!*
*!* END DEFINE
*!* Class.........: RunExe
*!*
*!* ///////////////////////////////////////////////////////
