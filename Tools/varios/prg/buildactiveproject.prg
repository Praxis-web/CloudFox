Local lcCommand As String
Local loBuildProject As BuildProject Of "V:\Cloudfox\Tools\Varios\Prg\BuildActiveProject.prg"

Try

	lcCommand = ""
	Set Procedure To "V:\Cloudfox\Rutinas\rutina.prg" Additive

	loBuildProject = Createobject( "BuildProject" )
	loBuildProject.Process()
 

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError


Finally
	loBuildProject = Null


Endtry


*!* ///////////////////////////////////////////////////////
*!* Class.........: BuildProject
*!* ParentClass...: prxCustom Of 'V:\CloudFenix\Fw\Tieradapter\Comun\PrxBaseLibrary.prg'
*!* BaseClass.....: Custom
*!* Description...:
*!* Date..........: Domingo 19 de Enero de 2014 (12:09:50)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class BuildProject As prxCustom Of 'V:\Cloudfox\Fw\Tieradapter\Comun\PrxBaseLibrary.prg'

	#If .F.
		Local This As BuildProject Of "V:\Cloudfox\Tools\Varios\Prg\BuildActiveProject.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="process" type="method" display="Process" />] + ;
		[<memberdata name="getbuilderobject" type="method" display="GetBuilderObject" />] + ;
		[<memberdata name="elegirproyecto" type="method" display="ElegirProyecto" />] + ;
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
				lcProjectName = This.ElegirProyecto( loBuilder, .T., "Build: " )

				If !Empty( lcProjectName ) Or loBuilder.lAllProjects
					If loBuilder.lAllProjects

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Do '<<loBuilder.BuilderFileName>>'
						ENDTEXT

					Else
						TEXT To lcCommand NoShow TextMerge Pretext 15
						Do '<<loBuilder.BuilderFileName>>' With '<<lcProjectName>>'
						ENDTEXT

					Endif

					&lcCommand

					If !Empty( loBuilder.ActiveProject )
						Modify Project ( loBuilder.ActiveProject ) Nowait
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
			loProject = Null
			loFile = Null
			loFiles = Null


		Endtry

	Endproc && Process

	*
	* Devuelve el objeto Builder asociado al proyecto
	Procedure GetBuilderObject(  ) As Object;
			HELPSTRING "Devuelve el objeto Builder asociado al proyecto"

		Local loProject As VisualFoxpro.IFoxProject
		Local loFile As VisualFoxpro.IFoxPrjFile
		Local loFiles As VisualFoxpro.IFoxPrjFiles
		Local loBuilder As Builder Of "V:\Cloudfox\Tools\Builder\Prg\Builder.prg"
		Local loXA As Xmladapter

		Local lcBuilder As String,;
			lcCommand As String,;
			lcProjectName As String,;
			lcLine As String,;
			lcEmpresa As String,;
			lcWorkingFolder As String,;
			lcUser As String,;
			lcMachine As String

		Local lnLen As Integer,;
			i As Integer

		Local Array laBuilder[ 1 ]


		Try

			lcCommand 		= ""
			lcBuilder 		= ""
			lcProjectName 	= ""
			lcWorkingFolder = ""
			
			lcMachine 	= Sys(0)
			lcUser 		= lcMachine
			lcMachine	= Alltrim( Upper( Substr( lcMachine, 1, At( "#", lcMachine ) - 1 ) ))
			lcUser 		= Alltrim( Upper( Substr( lcUser , At( "#", lcUser ) + 1 ) ) )


			loBuilder = Null

			Use In Select( "cWorkingFolder" )

			If !FileExist( "WorkingFolder.Cfg" )
				Do 'Tools\Varios\prg\SetearEmpresa.prg'
			Endif

			loXA = Newobject("prxXMLAdapter",;
				"Fw\TierAdapter\Comun\prxxmladapter.prg" )

			loXA.LoadXML( "WorkingFolder.Cfg", .T. )
			loXA.Tables(1).ToCursor()

			loXA = Null

			Select cWorkingFolder
			Locate For Alltrim( Upper( Machine ) ) = lcMachine ;
				And  Alltrim( Upper( User ) ) = lcUser

			If !Found()
				Do 'Tools\Varios\prg\SetearEmpresa.prg'

				loXA = Newobject("prxXMLAdapter",;
					"Fw\TierAdapter\Comun\prxxmladapter.prg" )

				loXA.LoadXML( "WorkingFolder.Cfg", .T. )
				loXA.Tables(1).ToCursor()

				loXA = Null

				Select cWorkingFolder
				Locate For Alltrim( Upper( Machine ) ) = lcMachine ;
					And  Alltrim( Upper( User ) ) = lcUser

				If !Found()
					Locate
				Endif

			Endif

			lcBuilder = Alltrim( cWorkingFolder.WorkingFolder ) + "Builder.prg"
			lcWorkingFolder = Alltrim( cWorkingFolder.WorkingFolder )
			
			If !Empty( lcBuilder )

				If Type( "_vfp.ActiveProject" ) = 'O'
					lcProjectName =  _vfp.ActiveProject.Name
				Endif

				lcEmpresa = Getwordnum( cWorkingFolder.WorkingFolder, Getwordcount( cWorkingFolder.WorkingFolder, "\" ), "\" )

				lnLen = Alines( laBuilder, Filetostr( lcBuilder ), 1 + 4 )

				For i = 1 To lnLen
					lcLine = Upper( laBuilder[ i ] )

					If Like( "*NEWOBJECT*", lcLine ) And Like( "*BUILDER.PRG*", lcLine )

						TEXT To lcCommand NoShow TextMerge Pretext 15
						loBuilder = <<Substr( lcLine,  At( "NEWOBJECT", lcLine ) )>>
						EndText
						
						*StrToFile( lcCommand, "Builder_Command.prg" )

						&lcCommand

						AddProperty( loBuilder, "ActiveProject", lcProjectName )
						AddProperty( loBuilder, "lAllProjects", .F. )
						AddProperty( loBuilder, "BuilderFileName", lcBuilder )
						AddProperty( loBuilder, "Empresa", lcEmpresa )

						If Empty( loBuilder.cExeFolder )
							loBuilder.cExeFolder = lcWorkingFolder
						Endif

						Exit

					Endif
				Endfor

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Use In Select( "cWorkingFolder" )

		Endtry

		Return loBuilder

	Endproc && GetBuilderObject


	*
	* Selecciona el Proyecto a compilar
	Procedure ElegirProyecto( ) As Void;
			HELPSTRING "Selecciona el Proyecto a compilar"

		Lparameters loBuilder As Object,;
			llIncludeAll As Boolean,;
			lcAction As String,;
			lcMsg As String

		Local lcCommand As String,;
			lcProjectName As String

		Local lnLen As Integer,;
			i As Integer,;
			lnSelected As Integer

		Local loParam As Object

		Local loProyecto As oProyecto Of "V:\Cloudfox\Tools\Builder\Prg\Builder.prg"
		Local loBuilderAux As Builder Of "V:\Cloudfox\Tools\Builder\Prg\Builder.prg"
		Local loColProyectos As Collection
		Local loItem As Object

		Try

			lcCommand = ""
			lcProjectName = ""

			loBuilder.Setup()
			
			loBuilderAux = loBuilder.SortBy( "cModulo" )

			lnLen = loBuilder.Count + Iif( llIncludeAll, 1, 0 )
			i = 0

			loColProyectos = Createobject( "Collection" )

			AddProperty( loColProyectos, "cCaption",  lcAction + loBuilder.Empresa )
			AddProperty( loColProyectos, "nColumnCount", 2 )
			AddProperty( loColProyectos, "cColumnWidths", "200, 000" )
			AddProperty( loColProyectos, "lBoundTo", .T. )
			AddProperty( loColProyectos, "nBoundColumn", 2 )
			AddProperty( loColProyectos, "nWidth", 200 )
			AddProperty( loColProyectos, "nHeight", 30 * 12	 )
			AddProperty( loColProyectos, "lMultiSelect", .F. )


			i = 0
			If llIncludeAll
				i = i + 1

				loItem = Null
				loItem = Createobject( "Empty" )
				AddProperty( loItem, "cCaption", "Todos los Módulos" )
				AddProperty( loItem, "nId", i )
				AddProperty( loItem, "lVisible", .T. )
				AddProperty( loItem, "nOrder", i )
				AddProperty( loItem, "cPicture", "Fw\Comunes\Image\bmp\ok.bmp" )
				AddProperty( loItem, "cProjectName", "" )

				loColProyectos.Add( loItem, Transform( i ) )

				i = i + 1

				loItem = Null
				loItem = Createobject( "Empty" )
				AddProperty( loItem, "cCaption", "\-" )
				AddProperty( loItem, "nId", i )
				AddProperty( loItem, "lVisible", .T. )
				AddProperty( loItem, "nOrder", i )
				AddProperty( loItem, "cPicture", "" )
				AddProperty( loItem, "cProjectName", "" )

				loColProyectos.Add( loItem, Transform( i ) )

			Endif


			For Each loProyecto In loBuilderAux
				i = i + 1

				loItem = Null
				loItem = Createobject( "Empty" )
				AddProperty( loItem, "cCaption", loProyecto.cModulo )
				AddProperty( loItem, "nId", i )
				AddProperty( loItem, "lVisible", .T. )
				AddProperty( loItem, "nOrder", i )
				AddProperty( loItem, "cPicture", loProyecto.Icon )
				AddProperty( loItem, "cProjectName", loProyecto.cProjectName )

				If Lower( Alltrim( Juststem( loBuilder.ActiveProject ) )) = Lower( Alltrim( loProyecto.cProjectName ))
					AddProperty( loColProyectos, "nSelected", i )
				Endif

				loColProyectos.Add( loItem, Transform( i ) )

			Endfor

			Do Form "Fw\Comunes\scx\ListBoxSelector.scx" With loColProyectos To i

			If !Empty( i )
				loItem = loColProyectos.Item( i )
				lcProjectName = loItem.cProjectName

				If llIncludeAll
					loBuilder.lAllProjects = ( i = 1 )

					If loBuilder.lAllProjects
						TEXT To lcMsg NoShow TextMerge Pretext 03
						Seguro que quiere compilar
						TODOS los módulos
						ENDTEXT

						If !Confirm( lcMsg, lcAction + loBuilder.Empresa, .F. )
							loBuilder.lAllProjects = .F.
							i = 0
							lcProjectName = ""
						Endif

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
			loProyecto = Null
			loParam = Null

		Endtry

		Return lcProjectName

	Endproc && ElegirProyecto


Enddefine
*!*
*!* END DEFINE
*!* Class.........: BuildProject
*!*
*!* ///////////////////////////////////////////////////////