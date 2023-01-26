
#Define _SOURCEFOLDER 	"S:\CloudFenix"
#Define _TARGETFOLDER 	"%USERPROFILE%\CloudFenix"

Local loMain As LauncherPyme Of "Clientes\Pyme\Comunes\Prg\Config Launcher.prg"

Try

	loMain = Newobject( "LauncherPyme", "Clientes\Pyme\Comunes\Prg\Config Launcher.prg" )
	loMain.Process()

Catch To oErr
	Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

	loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
	loError.Process( oErr )

Finally
	loMain = Null

Endtry



*!* ///////////////////////////////////////////////////////
*!* Class.........: LauncherPyme
*!* ParentClass...: LauncherConfig Of 'V:\Clipper2fox\Tools\Launcher\Client\Launcher.prg'
*!* BaseClass.....:
*!* Description...:
*!* Date..........: Jueves 8 de Abril de 2010 (17:14:24)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class LauncherPyme As LauncherConfig Of 'Tools\Launcher\Client\Launcher.prg'

	#If .F.
		Local This As LauncherPyme Of "Clientes\Pyme\Comunes\Prg\Config Launcher.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Setup
	*!* Description...:
	*!* Date..........: Martes 8 de Julio de 2008 (18:36:43)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Clipper2Fox
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Setup(  ) As Void

		Try
			Local loFile As Object
			
			DoDefault()
			
			* Ejecutables

			loFile = This.New( "Setup",;
				"Exe",;
				"CloudFenix" )
			loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	


*!*				loFile = This.New( "Launcher",;
*!*					"Exe",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	


*!*				loFile = This.New( "Contable",;
*!*					"Exe",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	


*!*				loFile = This.New( "Acreedores",;
*!*					"Exe",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	

*!*				loFile = This.New( "Deudores",;
*!*					"Exe",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	

*!*				loFile = This.New( "Compras",;
*!*					"Exe",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	

*!*				loFile = This.New( "Stock",;
*!*					"Exe",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	

*!*				loFile = This.New( "Valores",;
*!*					"Exe",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	

*!*				loFile = This.New( "Ventas",;
*!*					"Exe",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	
			
*!*				loFile = This.New( "Hasar",;
*!*					"Exe",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	

			loFile = This.New( "Archivos",;
				"Exe",;
				"CloudFenix" )
			loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	
			
			loFile = This.New( "Utiles",;
				"Exe",;
				"CloudFenix" )
			loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable"	


			* Configuración de Pantalla
			
			* Menues
*!*				loFile = This.New( "Acreedores",;
*!*					"Dbf",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Datos"	
*!*				loFile.TargetFolder = Addbs( loFile.TargetFolder ) + "Datos"	


*!*				loFile = This.New( "Deudores",;
*!*					"Dbf",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Datos"	
*!*				loFile.TargetFolder = Addbs( loFile.TargetFolder ) + "Datos"	

*!*				loFile = This.New( "Contable",;
*!*					"Dbf",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Datos"	
*!*				loFile.TargetFolder = Addbs( loFile.TargetFolder ) + "Datos"	


*!*				loFile = This.New( "Compras",;
*!*					"Dbf",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Datos"	
*!*				loFile.TargetFolder = Addbs( loFile.TargetFolder ) + "Datos"	

*!*				loFile = This.New( "Stock",;
*!*					"Dbf",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Datos"	
*!*				loFile.TargetFolder = Addbs( loFile.TargetFolder ) + "Datos"	

*!*				loFile = This.New( "Valores",;
*!*					"Dbf",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Datos"	
*!*				loFile.TargetFolder = Addbs( loFile.TargetFolder ) + "Datos"	

*!*				loFile = This.New( "Ventas",;
*!*					"Dbf",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Datos"	
*!*				loFile.TargetFolder = Addbs( loFile.TargetFolder ) + "Datos"	

			loFile = This.New( "Archivos",;
				"Dbf",;
				"CloudFenix" )
			loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Datos"	
			loFile.TargetFolder = Addbs( loFile.TargetFolder ) + "Datos"	

			loFile = This.New( "Utiles",;
				"Dbf",;
				"CloudFenix" )
			loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Datos"	
			loFile.TargetFolder = Addbs( loFile.TargetFolder ) + "Datos"	
			
*!*				loFile = This.New( "Hasar",;
*!*					"Dbf",;
*!*					"CloudFenix" )
*!*				loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Datos"	
*!*				loFile.TargetFolder = Addbs( loFile.TargetFolder ) + "Datos"	
			

			* Parametros
			loFile = This.New( "Setup",;
				"Json",;
				"CloudFenix" )
			loFile.SourceFolder = Addbs( loFile.SourceFolder ) + "Ejecutable\Datos"	
			loFile.TargetFolder = Addbs( loFile.TargetFolder ) + "Datos"	


		Catch To oErr
			Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

			loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc
	*!*
	*!* END PROCEDURE Setup
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Devuelve un objeto TierConfg
	*!* Date..........: Martes 4 de Marzo de 2008 (11:34:00)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Clipper2Fox
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure New( cFileName As String,;
			cFileExt As String,;
			cModuleName As String ) As Object;
			HELPSTRING "Devuelve un objeto TierConfg"

		Local loFile As Object
		Try

			loFile = DoDefault( cFileName,;
				cFileExt,;
				cModuleName )

			loFile.SourceFolder = _SOURCEFOLDER
			loFile.TargetFolder = _TARGETFOLDER


		Catch To oErr
			Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

			loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loFile

	Endproc
	*!*
	*!* END PROCEDURE New
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: LauncherPyme
*!*
*!* ///////////////////////////////////////////////////////




