Local lcCommand As String
Local loOpenProject As OpenProject Of "V:\Cloudfox\Tools\Varios\Prg\OpenProject.prg"

Try

	lcCommand = ""

	Set Procedure To "v:\Cloudfox\Rutinas\rutina.prg" Additive

	loOpenProject = Createobject( "OpenProject" )
	loOpenProject.Process()

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr, .T. )


Finally
	loOpenProject = Null

Endtry


*!* ///////////////////////////////////////////////////////
*!* Class.........: OpenProject
*!* ParentClass...: BuildProject Of 'V:\CloudFenix\Tools\Varios\Prg\BuildActiveProject.prg'
*!* BaseClass.....: Custom
*!* Description...: Permite elegir cual de los proyectos asociados al cliente se desea abrir
*!* Date..........: Viernes 24 de Enero de 2014 (08:00:29)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class OpenProject As BuildProject Of 'V:\Cloudfox\Tools\Varios\Prg\BuildActiveProject.prg'

	#If .F.
		Local This As OpenProject Of "V:\Cloudfox\Tools\Varios\Prg\OpenProject.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="openproject" type="method" display="OpenProject" />] + ;
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
				lcProjectName = This.ElegirProyecto( loBuilder, .F., "Open: " )

				If !Empty( lcProjectName )

					This.OpenProject( loBuilder, lcProjectName )

				Endif

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
			loFiles = Null


		Endtry

	Endproc && Process



	*
	* Corre el programa principal
	Procedure OpenProject( oBuilder As Object, cProjectName As String ) As Void;
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

			loBuilder = oBuilder

			loProyecto = loBuilder.GetItem( Lower( cProjectName ))

			Modify Project ( Addbs( loProyecto.cProjectFolder ) + loProyecto.cProjectName ) Nowait

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loBuilder = Null
			loProject = Null

		Endtry

	Endproc && OpenProject




Enddefine
*!*
*!* END DEFINE
*!* Class.........: OpenProject
*!*
*!* ///////////////////////////////////////////////////////