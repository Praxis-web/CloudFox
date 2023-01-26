
*#Define ENV_FRAMEWORK 1
#Define ENV_CLAUDFOX 	1
#Define ENV_CLIPPER2FOX 2
#Define ENV_CLIPPER2FOX_MIN 3

Procedure SetPath( tnEnvironment As Integer ) As VOID

	lcDefault = Curdir()
	Do Case
	Case lcDefault = "\CLIPPER2FOX\"
		tnEnvironment = ENV_CLIPPER2FOX 
	
	Case lcDefault = "\CLOUDFOX\"
		tnEnvironment = ENV_CLAUDFOX 

	Otherwise
		tnEnvironment = ENV_CLIPPER2FOX 

	EndCase

	If Empty( tnEnvironment )
		tnEnvironment = ENV_CLIPPER2FOX
	Endif

	If !Pemstatus( _Screen, "nEnv", 5 )
		AddProperty( _Screen, "nEnv" )
	Endif

	_Screen.nEnv = tnEnvironment

	Do Case

		Case tnEnvironment = ENV_CLIPPER2FOX
			Set Path To
			Set Default To 'V:\Clipper2Fox'
			Set Path To 'V:\Clipper2Fox' Additive

			Set Path To 'Rutinas' Additive
			Set Path To "Rutinas\Vcx" Additive
			Set Path To "Rutinas\Scx" Additive
			Set Path To "Rutinas\Prg" Additive

			Set Path To 'FW\COMUNES\PRG' Additive
			Set Path To 'FW\COMUNES\VCX' Additive
			Set Path To "FW\Comunes\Image\Jpg" Additive
			Set Path To "Fw\Comunes\Image\Modulos\" Additive
			Set Path To "FW\Comunes\Scx" Additive

			Set Path To 'FW\TIERADAPTER\COMUN' Additive
			*!*				Set Path To 'FW\TIERADAPTER\BIZTIER' Additive
			Set Path To 'FW\TIERADAPTER\DATATIER' Additive
			Set Path To 'FW\TIERADAPTER\USERTIER' Additive
*!*				Set Path To 'FW\TIERADAPTER\UNITTEST' Additive
			Set Path To 'FW\TIERADAPTER\SERVICETIER' Additive

			Set Path To 'FW\ERRORHANDLER' Additive

			Set Path To 'TOOLS\VARIOS\PRG' Additive
			Set Path To 'TOOLS\FOXUNIT' Additive
			Set Path To "Tools\DBFRepair\Prg" Additive

			Set Path To "FW\SysAdmin\Prg" Additive
			Set Path To "FW\SysAdmin\Mnx" Additive

			Set Path To "Clientes\Contable\Prg" Additive
			Set Path To "Clientes\Valores\Prg" Additive
			Set Path To "Clientes\Archivos\Prg" Additive
			Set Path To "Clientes\Stock\Prg" Additive
			Set Path To "Clientes\Estadisticas\Prg" Additive
			Set Path To "Clientes\Deudores\Prg" Additive
			Set Path To "Clientes\Utiles\Prg" Additive
			Set Path To "Clientes\Ventas\Prg" Additive
			Set Path To "Clientes\Compras\Prg" Additive
			Set Path To "Clientes\IIBB\Prg" Additive
			Set Path To "Clientes\Siap\Padron\Prg" Additive
			
			Set Path To "Clientes\Stock\Scx" Additive
			Set Path To "Clientes\Estadisticas\Scx" Additive
			Set Path To "Clientes\IIBB\Scx" Additive

			Set Path To "fw\RB\Common" Additive
			Set Path To "fw\RB\Base" Additive
			Set Path To "Tools\ReportBuilder\Source\Bands" Additive
			Set Path To "Tools\ReportBuilder\Source\Dal" Additive
			Set Path To "Tools\ReportBuilder\Source\Layout" Additive
			Set Path To "Tools\ReportBuilder\Source\Prg" Additive
			Set Path To "Tools\PDFCreator\Prg\" Additive

			Set Path To "fw\Ffc" Additive
			Set Path To "Tools\OpenOffice\Prg\" Additive
			Set Path To "Tools\Launcher\Client\" Additive
			Set Path To "fw\Launcher\Vcx\" Additive
			Set Path To "Tools\Sincronizador\" ADDITIVE 
			
			Set Path To "Tools\eMail\Prg\" ADDITIVE 
			Set Path To "Tools\FE\Prg\" ADDITIVE 
			
			Set Path To "Tools\NameSpaces\Prg\" ADDITIVE 
			Set Path To "Tools\DataDictionary\Prg\" ADDITIVE 
			Set Path To "Tools\ErrorHandler\Prg\" ADDITIVE
			Set Path To "Tools\Metadata\" ADDITIVE 
			Set Path To "Tools\DynamicForm\" ADDITIVE  
			Set Path To "Tools\JSON\Prg\" ADDITIVE 
			Set Path To "Tools\Accesos\prg\" ADDITIVE 
			
			
			* FoxyPreviewer
*!*				Set Path To "V:\CloudFenix\Tools\FoxyPreviewer" ADDITIVE
*!*				Set Path To "V:\CloudFenix\Tools\FoxyPreviewer\Source" ADDITIVE
*!*				Set Path To "V:\CloudFenix\Tools\FoxyPreviewer\Source\Images" ADDITIVE
			
			*MessageBox( Set("Path"))
			

			*!*				Set Path To "" Additive
			*!*				Set Path To "" Additive
			*!*				Set Path To "" Additive
			*!*				Set Path To "" Additive
			*!*				Set Path To "" Additive


			*!*				Messagebox( Set( "Path" ) , 0, _vfp.Caption, 2000 )
			
			ChDir 'V:\Clipper2Fox'

		Case tnEnvironment = ENV_CLAUDFOX
			Set Path To
			Set Default To 'v:\CloudFox'
			Set Path To 'V:\CloudFox' Additive

			Set Path To 'Rutinas' Additive
			Set Path To "Rutinas\Vcx" Additive
			Set Path To "Rutinas\Scx" Additive
			Set Path To "Rutinas\Prg" Additive

			Set Path To 'FW\COMUNES\PRG' Additive
			Set Path To 'FW\COMUNES\VCX' Additive
			Set Path To "FW\Comunes\Image\Jpg" Additive
			Set Path To "Fw\Comunes\Image\Modulos\" Additive
			Set Path To "FW\Comunes\Scx" Additive

			Set Path To 'FW\TIERADAPTER\COMUN' Additive
			Set Path To 'FW\TIERADAPTER\DATATIER' Additive
			Set Path To 'FW\TIERADAPTER\USERTIER' Additive
			Set Path To 'FW\TIERADAPTER\SERVICETIER' Additive

			Set Path To 'FW\ERRORHANDLER' Additive

			Set Path To 'TOOLS\VARIOS\PRG' Additive
			Set Path To 'TOOLS\FOXUNIT' Additive
			Set Path To "Tools\DBFRepair\Prg" Additive

			Set Path To "FW\SysAdmin\Prg" Additive
			Set Path To "FW\SysAdmin\Mnx" Additive

			Set Path To "Clientes\Acreedores\Prg" Additive
			Set Path To "Clientes\Archivos\Prg" Additive
			Set Path To "Clientes\Caja\Prg" Additive
			Set Path To "Clientes\Compras\Prg" Additive
			
			Set Path To "Clientes\Contabilidad\Prg" Additive
			Set Path To "Clientes\Deudores\Prg" Additive
			Set Path To "Clientes\Estadisticas\Prg" Additive
			Set Path To "Clientes\Hasar\Prg" Additive
			Set Path To "Clientes\Pedidos\Prg" Additive
			Set Path To "Clientes\Siap\Prg" Additive
			Set Path To "Clientes\Stock\Prg" Additive
			Set Path To "Clientes\Utiles\Prg" Additive
			Set Path To "Clientes\Valores\Prg" Additive
			Set Path To "Clientes\Ventas\Prg" Additive
			

			Set Path To "Tools\PDFCreator\Prg\" Additive
			Set Path To "fw\Ffc" Additive
			Set Path To "Tools\OpenOffice\Prg\" Additive
			Set Path To "Tools\Launcher\Client\" Additive
			Set Path To "fw\Launcher\Vcx\" Additive
			Set Path To "Tools\Sincronizador\" ADDITIVE 
			
			Set Path To "Tools\eMail\Prg\" ADDITIVE 
			Set Path To "Tools\FE\Prg\" ADDITIVE 
			
			Set Path To "Tools\NameSpaces\Prg\" ADDITIVE 
			Set Path To "Tools\DataDictionary\Prg\" ADDITIVE 
			Set Path To "Tools\ErrorHandler\Prg\" ADDITIVE
			Set Path To "Tools\JSON\Prg\" ADDITIVE 
			Set Path To "Tools\Accesos\prg\" ADDITIVE 
			
			Set Path To "Tools\JSONFox-master\src\" ADDITIVE
			
			ChDir 'V:\CloudFox'
			
		Case tnEnvironment = ENV_CLIPPER2FOX_MIN 
			Set Path To
			Set Default To 'V:\Clipper2Fox'
			Set Path To 'V:\Clipper2Fox' Additive

			Set Path To 'Rutinas' Additive

			Set Path To 'FW\COMUNES\PRG' Additive

			Set Path To 'FW\TIERADAPTER\COMUN' Additive
			Set Path To 'FW\TIERADAPTER\DATATIER' Additive

			Set Path To 'FW\ERRORHANDLER' Additive

			* Messagebox( Set( "Path" ) , 0, _vfp.Caption, 2000 )

		Case .F. && tnEnvironment = ENV_FRAMEWORK
			Set Path To
			Set Default To 'V:\SISTEMASPRAXISV2'
			Set Path To 'V:\SISTEMASPRAXISV2' Additive
			Set Path To 'FW\COMUNES\PRG' Additive
			Set Path To 'FW\COMUNES\VCX' Additive
			Set Path To 'FW\TIERADAPTER\COMUN' Additive
			Set Path To 'FW\TIERADAPTER\BIZTIER' Additive
			Set Path To 'FW\TIERADAPTER\DATATIER' Additive
			Set Path To 'FW\TIERADAPTER\USERTIER' Additive
			Set Path To 'FW\ERRORHANDLER' Additive
			Set Path To 'TOOLS\VARIOS\PRG' Additive
			Set Path To 'FW\TIERADAPTER\UNITTEST' Additive
			Set Path To 'FW\TIERADAPTER\SERVICETIER' Additive
			Set Path To 'TOOLS\FOXUNIT' Additive


			Set Path To
			Set Default To 'V:\Clipper2Fox'
			Set Path To 'V:\Clipper2Fox' Additive

			Set Path To 'FW\COMUNES\PRG' Additive
			Set Path To 'FW\COMUNES\VCX' Additive
			Set Path To "FW\Comunes\Image\Jpg" Additive
			Set Path To "FW\Comunes\Scx" Additive

			Set Path To 'FW\TIERADAPTER\COMUN' Additive
			*!*				Set Path To 'FW\TIERADAPTER\BIZTIER' Additive
			Set Path To 'FW\TIERADAPTER\DATATIER' Additive
			Set Path To 'FW\TIERADAPTER\USERTIER' Additive
*!*				Set Path To 'FW\TIERADAPTER\UNITTEST' Additive
			Set Path To 'FW\TIERADAPTER\SERVICETIER' Additive

			Set Path To 'FW\ERRORHANDLER' Additive

			Set Path To 'TOOLS\VARIOS\PRG' Additive
			Set Path To 'TOOLS\FOXUNIT' Additive

			Set Path To "FW\SysAdmin\Prg" Additive
			Set Path To "FW\SysAdmin\Mnx" Additive

			Set Path To "Clientes\Contable\Prg" Additive
			Set Path To "Clientes\Valores\Prg" Additive
			Set Path To "Clientes\Archivos\Prg" Additive
			Set Path To "Clientes\IIBB\Prg" Additive

			Set Path To "fw\RB\Common" Additive
			Set Path To "fw\RB\Base" Additive
			Set Path To "Tools\ReportBuilder\Source\Bands" Additive
			Set Path To "Tools\ReportBuilder\Source\Dal" Additive
			Set Path To "Tools\ReportBuilder\Source\Layout" Additive
			Set Path To "Tools\ReportBuilder\Source\Prg" Additive

			Set Path To "fw\Ffc" Additive
			Set Path To "Tools\OpenOffice\Prg\" Additive
			Set Path To "Tools\Launcher\Client\" Additive
			Set Path To "fw\Launcher\Vcx\" Additive
			Set Path To "Tools\Sincronizador\" ADDITIVE 
			
			
			* FoxyPreviewer
			Set Path To "v:\Clipper2Fox\Tools\FoxyPreviewer" ADDITIVE
			Set Path To "v:\Clipper2Fox\Tools\FoxyPreviewer\Source" ADDITIVE
			Set Path To "v:\Clipper2Fox\Tools\FoxyPreviewer\Source\Images" ADDITIVE
			
			*MessageBox( Set("Path"))
			

			*!*				Set Path To "" Additive
			*!*				Set Path To "" Additive
			*!*				Set Path To "" Additive
			*!*				Set Path To "" Additive
			*!*				Set Path To "" Additive


			*!*				Messagebox( Set( "Path" ) , 0, _vfp.Caption, 2000 )




	Endcase

	Do Tools\Varios\prg\mnxPraxis

Endproc && SetPath
