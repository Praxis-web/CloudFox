Lparameters tcProject As String

Local loBuilder As FenixBuilder Of "Fw\Fenix\Builder.prg"


Try

	loBuilder = Newobject( "FenixBuilder", "Fw\Fenix\Builder.prg" )
	loBuilder.Setup()
	loBuilder.cExeFolder =  Set("Default") + Curdir() + "Fw\Fenix"

	If !Empty( tcProject )
		loProyecto = loBuilder.GetItem( tcProject )

		loBuilder.Clear()
		loBuilder.AddItem( loProyecto, Lower( tcProject ) )

	Endif

	loBuilder.Build()


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )


Finally
	loBuilder = Null


Endtry


*!* ///////////////////////////////////////////////////////
*!* Class.........: FenixBuilder
*!* ParentClass...: Builder Of 'V:\FoxCloud\Tools\Builder\Prg\Builder.prg'
*!* BaseClass.....: prxCollection
*!* Description...: Builder para Fenix
*!* Date..........: Lunes 9 de Enero de 2012 (12:25:58)
*!* Author........: Ricardo Aidelman
*!* Project.......: FoxCloud
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class FenixBuilder As Builder Of 'V:\FoxCloud\Tools\Builder\Prg\Builder.prg'

	#If .F.
		Local This As FenixBuilder Of "Fw\Fenix\Builder.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*
	*
	Procedure Setup(  ) As Void
		Local loProyecto As Object

		Try

			* Cargar Proyectos Fenix

			loProyecto = This.New( "Fenix" )
			loProyecto.cMenuFileName = ""
			loProyecto.cProjectFolder = "Fw\Fenix\"


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loProyecto = Null

		Endtry

	Endproc && SetUp

Enddefine
*!*
*!* END DEFINE
*!* Class.........: FenixBuilder
*!*
*!* ///////////////////////////////////////////////////////
