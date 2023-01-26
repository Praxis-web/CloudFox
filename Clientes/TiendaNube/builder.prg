Lparameters tcProject As String

Local loBuilder As TiendaNubeBuilder Of "V:\Clipper2fox\Clientes\TiendaNube\Builder.prg"



Try

	loBuilder = Newobject( "TiendaNubeBuilder", "Clientes\TiendaNube\Builder.prg" )
	loBuilder.Setup()
	loBuilder.cExeFolder =  Set("Default") + Curdir() + "Clientes\TiendaNube"

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

Define Class TiendaNubeBuilder As Builder Of 'Tools\Builder\Prg\Builder.prg'

	#If .F.
		Local This As TiendaNubeBuilder Of "Clientes\TiendaNube\Builder.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*
	*
	Procedure Setup(  ) As Void
		Local loProyecto As Object

		Try

			* Cargar Proyectos TiendaNube

			loProyecto = This.New( "Setup" )
			loProyecto.cMenuFileName = ""
			loProyecto.cProjectFolder = "Tools\Config\Setup\"
			loProyecto.Icon = "v:\CloudFox\FW\Comunes\image\ico\conectar.ico"


			loProyecto = This.New( "TiendaNube" )
			loProyecto.cMenuFileName = "Clientes\TiendaNube\TiendaNube"
			loProyecto.cProjectFolder = "Clientes\TiendaNube"
			loProyecto.Icon = "v:\CloudFox\FW\Comunes\Image\Modulos\TiendaNube.ico"
			loProyecto.cModulo = "Tienda Nube"


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

		Set Path To "Clientes\TiendaNube\" Additive
		*		Set Path To "Clientes\TiendaNube\Comunes\prg\" Additive

		Return
	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: TiendaNubeBuilder
*!*
*!* ///////////////////////////////////////////////////////
