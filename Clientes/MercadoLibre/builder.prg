Lparameters tcProject As String

Local loBuilder As MercadoLibreBuilder Of "V:\Clipper2fox\Clientes\MercadoLibre\Builder.prg"



Try

	loBuilder = Newobject( "MercadoLibreBuilder", "Clientes\MercadoLibre\Builder.prg" )
	loBuilder.Setup()
	loBuilder.cExeFolder =  Set("Default") + Curdir() + "Clientes\MercadoLibre"

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

Define Class MercadoLibreBuilder As Builder Of 'Tools\Builder\Prg\Builder.prg'

	#If .F.
		Local This As MercadoLibreBuilder Of "Clientes\MercadoLibre\Builder.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*
	*
	Procedure Setup(  ) As Void
		Local loProyecto As Object

		Try

			* Cargar Proyectos MercadoLibre

			loProyecto = This.New( "Setup" )
			loProyecto.cMenuFileName = ""
			loProyecto.cProjectFolder = "Tools\Config\Setup\"
			loProyecto.Icon = "v:\CloudFox\FW\Comunes\image\ico\conectar.ico"


			loProyecto = This.New( "MercadoLibre" )
			loProyecto.cMenuFileName = "Clientes\MercadoLibre\MercadoLibre"
			loProyecto.cProjectFolder = "Clientes\MercadoLibre"
			loProyecto.Icon = "v:\CloudFox\FW\Comunes\image\Modulos\Mercado Libre.ico"
			loProyecto.cModulo = "Mercado Libre"


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

		Set Path To "Clientes\MercadoLibre\" Additive
		*		Set Path To "Clientes\MercadoLibre\Comunes\prg\" Additive

		Return
	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: MercadoLibreBuilder
*!*
*!* ///////////////////////////////////////////////////////
