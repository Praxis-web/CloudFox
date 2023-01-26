Local lcCommand As String
Local loRunMain As RunMain Of "V:\Cloudfox\Tools\Varios\Prg\RunMainProgram.prg"

Try

	lcCommand = ""
	Set Procedure To "V:\Cloudfox\Rutinas\rutina.prg" Additive

	loRunMain = Createobject( "RunMain" )
	loRunMain.Process()

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError


Finally
	loRunMain = Null


Endtry



*!* ///////////////////////////////////////////////////////
*!* Class.........: RunMain
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

Define Class RunMain As BuildProject Of 'V:\Cloudfox\Tools\Varios\Prg\BuildActiveProject.prg'

	#If .F.
		Local This As RunMain Of "V:\Cloudfox\Tools\Varios\Prg\RunMainProgram.prg"
	#Endif

	cProjectName 	= ""
	cProjectFolder 	= ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cprojectname" type="property" display="cProjectName" />] + ;
		[<memberdata name="cprojectfolder" type="property" display="cProjectFolder" />] + ;
		[<memberdata name="runmainprogram" type="method" display="RunMainProgram" />] + ;
		[<memberdata name="getmainprogram" type="method" display="GetMainProgram" />] + ;
		[<memberdata name="getmainobject" type="method" display="GetMainObject" />] + ;
		[</VFPData>]

	*
	* Proceso principal
	Procedure Process(  ) As Void;
			HELPSTRING "Proceso principal"

		Local lcCommand As String

		Local loBuilder As Builder Of "V:\Cloudfox\Tools\Builder\Prg\Builder.prg"

		Try

			lcCommand = ""
			This.cProjectName 	= ""
			This.cProjectFolder	= ""

			loBuilder = This.GetBuilderObject()

			If Vartype( loBuilder ) = "O"
				This.cProjectName = This.ElegirProyecto( loBuilder, .F., "Run Main: " )

				If !Empty( This.cProjectName )

					This.RunMainProgram( loBuilder, This.cProjectName )

				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

			Try

				loProject = _vfp.ActiveProject

				If Vartype( loProject ) = "O"
					lcProject = loProject.Name
					loProject.Close()
					Modify Project ( lcProject )
					loProject = Null
				Endif

			Catch To oErr

			Finally
				loProject = Null
				loFile = Null
				loFiles = Null

			Endtry

		Endtry

	Endproc && Process



	*
	* Corre el programa principal
	Procedure RunMainProgram( oBuilder As Object, cProjectName As String ) As Void;
			HELPSTRING "Corre el programa principal"

		Local lcCommand As String,;
			lcProjectName As String,;
			lcMainFile As String

		Local loBuilder As Builder Of "V:\Cloudfox\Tools\Builder\Prg\Builder.prg"
		Local loProject As VisualFoxpro.IFoxProject
		Local loProyecto As oProyecto Of "V:\Cloudfox\Tools\Builder\Prg\Builder.prg"
		Local loMain As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

		Try

			lcCommand = ""

			lcMainFile = This.GetMainProgram( oBuilder, cProjectName )

			If !Empty( lcMainFile )
				loMain = This.GetMainObject( lcMainFile )
				If Vartype( loMain ) = "O"
					loMain.Start()
				Endif

				If !Empty( This.cProjectName )
					Modify Project ( Addbs( This.cProjectFolder ) + This.cProjectName ) Nowait
				Endif
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loBuilder = Null
			loProject = Null
			Do "V:\Cloudfox\Tools\Varios\prg\setpath.prg" With 3
			Do "V:\Cloudfox\Tools\Varios\prg\liberarentorno.prg"


		Endtry

	Endproc && RunMainProgram



	*
	* Devuelve el nombre del programa principal
	Procedure GetMainProgram( oBuilder As Object, cProjectName As String ) As String;
			HELPSTRING "Devuelve el nombre del programa principal"

		Local lcCommand As String,;
			lcProjectName As String,;
			lcMainFile As String

		Local loBuilder As Builder Of "V:\Cloudfox\Tools\Builder\Prg\Builder.prg"
		Local loProject As VisualFoxpro.IFoxProject
		Local loProyecto As oProyecto Of "V:\Cloudfox\Tools\Builder\Prg\Builder.prg"

		Try

			lcCommand = ""
			lcMainFile = ""

			loBuilder = oBuilder

			loProyecto = loBuilder.GetItem( Lower( cProjectName ))

			Modify Project ( Addbs( loProyecto.cProjectFolder ) + loProyecto.cProjectName ) Nowait

			If Vartype( _vfp.ActiveProject ) = 'O'

				loProject = _vfp.ActiveProject

				If Vartype( loProject ) = 'O'

					lcMainFile 		= loProject.MainFile
					lcProjectName 	=  _vfp.ActiveProject.Name

					If  !FileExist( lcMainFile )
						Stop( "No se encontro el archivo " + lcMainFile, "Run Main Program" )

					Else
						This.cProjectFolder = loProyecto.cProjectFolder
						This.cProjectName 	= loProyecto.cProjectName
						loProject.Close()

					Endif

				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loProject 	= Null
			loProyecto 	= Null
			loBuilder 	= Null

		Endtry

		Return lcMainFile

	Endproc && GetMainProgram

	*
	* Obtiene el objeto Application
	Procedure GetMainObject( cMainFile As String ) As Object ;
			HELPSTRING "Obtiene el objeto Application"

		Local lcCommand As String
		Local loMain As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"
		Local loBlackBox As oBlackBox Of "V:\Cloudfox\Tools\Varios\Prg\RunMainProgram.prg"

		Try

			lcCommand 	= "Prueba"

			loBlackBox 	= Createobject( "oBlackBox" )
			loMain 		= loBlackBox.GetMainObject( cMainFile )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loMain


	Endproc && GetMainObject



Enddefine
*!*
*!* END DEFINE
*!* Class.........: RunMain
*!*
*!* ///////////////////////////////////////////////////////


Define Class oBlackBox As Session

	#If .F.
		Local This As oBlackBox Of "V:\Cloudfox\Tools\Varios\Prg\RunMainProgram.prg"
	#Endif

	* Sesion privada
	*DataSession = 2

	* Default DataSession
	DataSession = 1

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="getmainobject" type="method" display="GetMainObject" />] + ;
		[</VFPData>]

	*
	* Obtiene el objeto Application
	Procedure GetMainObject( cMainFile As String ) As Object ;
			HELPSTRING "Obtiene el objeto Application"
		Local lcCommand As String,;
			lcLine As String,;
			lcClassName As String,;
			lcAppName As String
		Local Array laMain[ 1 ]
		Local lnLen As Integer
		Local loMain As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

		Try

			lcCommand = ""
			lcAppName = ""
			This.DataSessionId = 1

			loMain = Null

			lnLen = Alines( laMain, Filetostr( cMainFile ), 1 + 4 )

			For i = 1 To lnLen
				lcLine = Upper( laMain[ i ] )

				If Like( "*TCAPPNAME*", lcLine ) And Like( "*=*", lcLine )
					Strtran( lcLine, "=", " = " )
					lcAppName = Getwordnum( lcLine, 2, ["] )
					lcAppName = ["]+Strtran( lcAppName, " ", "_" )+["]
				Endif

				If !Empty( At( "DEFINE CLASS", lcLine ) )
					lcClassName = Getwordnum( lcLine, 3 )

					TEXT To lcCommand NoShow TextMerge Pretext 15
					loMain = NewObject( '<<lcClassName>>', '<<cMainFile>>', "", <<lcAppName>> )
					ENDTEXT

					&lcCommand

					Exit

				Endif
			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loMain


	Endproc && GetMainObject

Enddefine


**##############################################################################
Procedure dummy

	Local loProject As VisualFoxpro.IFoxProject
	Local lcCommand As String,;
		lcProjectName As String,;
		lcMainFile As String

	Try

		lcCommand 		= ""
		lcProjectName 	= ""

		If Vartype( _vfp.ActiveProject ) = 'O'

			loProject = _vfp.ActiveProject

			If Vartype( loProject ) = 'O'
				lcMainFile 		= loProject.MainFile
				lcProjectName 	=  _vfp.ActiveProject.Name

				If  FileExist( lcMainFile )
					TEXT To lcCommand NoShow TextMerge Pretext 15
				Do '<<lcMainFile>>'
					ENDTEXT

				Else
					Stop( "No se encontro el archivo " + lcMainFile, "Run Main Program" )

				Endif

			Endif

		Endif

		If !Empty( lcCommand )
			Do "V:\Cloudfox\Tools\Varios\prg\setpath.prg"

			&lcCommand

			If Vartype( lcProjectName ) == "C"
				Modify Project ( lcProjectName ) Nowait
			Endif

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError


	Finally
		loProject = Null
		Do "V:\Cloudfox\Tools\Varios\prg\setpath.prg" With 3
		Do "V:\Cloudfox\Tools\Varios\prg\liberarentorno.prg"

	Endtry
