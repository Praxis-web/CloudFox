Lparameters tcProject As String

Local loBuilder As PymeBuilder Of "v:\CloudFox\Clientes\Pyme\Builder.prg"



Try

	loBuilder = Newobject( "PymeBuilder", "Clientes\Pyme\Builder.prg" )
	loBuilder.Setup()
	loBuilder.cExeFolder =  Set("Default") + Curdir() + "Clientes\Pyme"

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
*!* Class.........: PymeBuilder
*!* ParentClass...: Builder Of 'V:\Clipper2fox\Tools\Builder\Prg\Builder.prg'
*!* BaseClass.....: prxCollection
*!* Description...: Builder para Pyme
*!* Date..........: Lunes 9 de Enero de 2012 (12:25:58)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PymeBuilder As Builder Of 'Tools\Builder\Prg\Builder.prg'

	#If .F.
		Local This As PymeBuilder Of "Clientes\Pyme\Builder.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*
	*
	Procedure Setup(  ) As Void
		Local loProyecto As Object

		Try

			* Cargar Proyectos Pyme

*!*				loProyecto = This.New( "Fenix" )
*!*				loProyecto.cMenuFileName = ""
*!*				loProyecto.cProjectFolder = "Fw\Fenix\"

*!*				loProyecto = This.New( "Launcher" )
*!*				loProyecto.cMenuFileName = ""
*!*				loProyecto.cProjectFolder = "Clientes\Pyme\Launcher"

			loProyecto = This.New( "Setup" )
			loProyecto.cMenuFileName = ""
			loProyecto.cProjectFolder = "Tools\Config\Setup\"
			loProyecto.Icon = "v:\CloudFox\FW\Comunes\image\ico\conectar.ico"


*!*				loProyecto = This.New( "Archivos" )
*!*				loProyecto.cMenuFileName = "Clientes\Pyme\Archivos\Archivos"
*!*				loProyecto.cProjectFolder = "Clientes\Pyme\Archivos"
*!*				loProyecto.Icon = "v:\CloudFox\fw\Comunes\Image\Modulos\Archivos.ico"
*!*				loProyecto.cModulo = "Archivos"

*!*				loProyecto = This.New( "Ctta_Ctte" )
*!*				loProyecto.cMenuFileName = "Clientes\Pyme\Ctta_Ctte\Ctta_Ctte"
*!*				loProyecto.cProjectFolder = "Clientes\Pyme\Ctta_Ctte"
*!*				loProyecto.Icon = "v:\CloudFox\fw\Comunes\Image\Modulos\Deudores.ico"
*!*				loProyecto.cModulo = "Cuentas Corrientes"

*!*				loProyecto = This.New( "Utiles" )
*!*				loProyecto.cMenuFileName = "Clientes\Pyme\Utiles\Utiles"
*!*				loProyecto.cProjectFolder = "Clientes\Pyme\Utiles"
*!*				loProyecto.Icon = "v:\CloudFox\fw\Comunes\Image\Modulos\Utiles.ico"
*!*				loProyecto.cModulo = "Utiles"

			* RA 25/02/2023(18:28:49)
			* El menú lo genera el BackEnd
			loProyecto = This.New( "Pyme" )
			*loProyecto.cMenuFileName = "Clientes\Pyme\Pyme\Pyme"
			loProyecto.cMenuFileName = ""
			loProyecto.cProjectFolder = "Clientes\Pyme\Pyme"
			loProyecto.Icon = "v:\CloudFox\FW\Comunes\image\ico\PraxisComputacion.ico"
			loProyecto.cModulo = "Gestión Comercial"


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loProyecto = Null

		Endtry

	Endproc && SetUp

	Procedure SetEnvironment()

		DoDefault()

		Set Path To "Clientes\Pyme\" Additive
		*		Set Path To "Clientes\Pyme\Comunes\prg\" Additive

		Return
	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: PymeBuilder
*!*
*!* ///////////////////////////////////////////////////////