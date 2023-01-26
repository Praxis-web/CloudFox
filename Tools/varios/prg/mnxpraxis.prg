Lparameters tnEnv As Integer

#Define ENV_FRAMEWORK 1
#Define ENV_CLIPPER2FOX 2

If !Pemstatus( _Screen, "nEnv", 5 )
	AddProperty( _Screen, "nEnv" )
Endif


If Empty( tnEnv )

	tnEnv = _Screen.nEnv

	If Empty( tnEnv )
		tnEnv = ENV_FRAMEWORK
	Endif

Endif

Release Menus praxis
Set Sysmenu To

Set Sysmenu to DEFAULT 

Define Pad praxis Of _Msysmenu Prompt "Pra\<xis" Color Scheme 3 ;
	KEY Alt+X, ""
On Pad praxis Of _Msysmenu Activate Popup praxis

Define Popup praxis Margin Relative Shadow Color Scheme 4
Define Bar 1 Of praxis Prompt "\<Liberar entorno" Skip For !  FileExist( 'Tools\Varios\prg\LiberarEntorno.prg' )
Define Bar 2 Of praxis Prompt "\<Setear Empresa de Trabajo" Skip For !FileExist( 'Tools\Varios\prg\SetearEmpresa.prg' )
Define Bar 3 Of praxis Prompt "\<Build Active Project" 
Define Bar 4 Of praxis Prompt "Run \<Main Program"
Define Bar 5 Of praxis Prompt "\<Run Exe Program"
Define Bar 6 Of praxis Prompt "Abrir Pr\<oyecto de la Empresa Activa"
Define Bar 7 Of praxis Prompt "\<Configurar Entorno" Skip For !  FileExist( 'Tools\Varios\prg\SetPath.prg' )
Define Bar 8 Of praxis Prompt "Ver \<Path"
Define Bar 9 Of praxis Prompt "Or\<denar Menú"
Define Bar 10 Of praxis Prompt "\<Upsize Menú"
Define Bar 11 Of praxis Prompt "Cambiar \<Entorno"

On Selection Bar 1 Of praxis Do LimpiarTodo In "Tools\Varios\prg\mnxPraxis.prg"
On Selection Bar 2 Of praxis Do 'Tools\Varios\prg\SetearEmpresa.prg'
On Selection Bar 3 Of praxis Do 'Tools\Varios\prg\BuildActiveProject'
On Selection Bar 4 Of praxis Do 'Tools\Varios\prg\RunMainProgram.prg'
On Selection Bar 5 Of praxis Do 'Tools\Varios\prg\RunExe.prg'
On Selection Bar 6 Of praxis Do 'Tools\Varios\prg\OpenProject.prg'
On Selection Bar 8 Of praxis Do VerPath In "Tools\Varios\prg\mnxPraxis.prg"
On Selection Bar 9 Of praxis Do 'V:\Cloudfox\Ordenar Menu.prg'
On Selection Bar 10 Of praxis Do 'V:\Cloudfox\Tools\Accesos\prg\upsizemenu.prg'
On Selection Bar 11 Of praxis Do 'v:\Visual FoxPro 9\SetearEntorno.prg'

* Abrir Proyecto de Módulos
*!*	On Bar 6 Of praxis Activate Popup Modulos
*!*	Define Popup Modulos Margin Relative Shadow Color Scheme 4
*!*	Define Bar 1 Of Modulos Prompt "\<Pyme"
*!*	Define Bar 2 Of Modulos Prompt "\<Sanitarios"

* Pyme
*!*	On Bar 1 Of Modulos Activate Popup Pyme
*!*	Define Popup Pyme Margin Relative Shadow Color Scheme 4
*!*	Define Bar 01 Of Pyme Prompt "\<Acreedores" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Acreedores.ico" 
*!*	Define Bar 02 Of Pyme Prompt "A\<rchivos" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Archivos.ico"
*!*	Define Bar 03 Of Pyme Prompt "\<Compras" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Compras.ico"
*!*	Define Bar 04 Of Pyme Prompt "C\<ontable" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Contable.ico"
*!*	Define Bar 05 Of Pyme Prompt "\<Deudores" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Deudores.ico"
*!*	Define Bar 06 Of Pyme Prompt "\<Estadísticas" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Estadisticas.ico"
*!*	Define Bar 07 Of Pyme Prompt "\<Fenix" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Fenix.ico"
*!*	Define Bar 08 Of Pyme Prompt "\<Hasar" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Hasar.ico"
*!*	Define Bar 09 Of Pyme Prompt "\<Launcher" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Fenix.ico"
*!*	Define Bar 10 Of Pyme Prompt "\<Pedidos" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Pedidos.ico"
*!*	Define Bar 11 Of Pyme Prompt "\<Siap" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Siap.ico"
*!*	Define Bar 12 Of Pyme Prompt "Stoc\<k" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Stock.ico"
*!*	Define Bar 13 Of Pyme Prompt "\<Utiles" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Utiles.ico"
*!*	Define Bar 14 Of Pyme Prompt "\<Valores" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Valores.ico"
*!*	Define Bar 15 Of Pyme Prompt "Ve\<ntas" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Ventas.ico"

*!*	On Selection Bar 01 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\prCCAcre\prccacre.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 02 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\prTraArc\prtraarc.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 03 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\prGesCom\prgescom.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 04 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\Contable\contable.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 05 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\prCCDeud\prccdeud.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 06 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\prEstadi\prestadi.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 07 Of Pyme Do ModifyProject With "V:\CloudFenix\Fw\Fenix\Fenix.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 08 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\Hasar\hasar.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 09 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\Launcher\launcher.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 10 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\prPedido\prPedido.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 11 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Siap\prsiap.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 12 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\prGesSto\prgessto.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 13 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\prUtiles\prutiles.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 14 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\prGesVal\prgesval.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 15 Of Pyme Do ModifyProject With "V:\CloudFenix\Clientes\Pyme\prGesVen\prgesven.pjx" In "Tools\Varios\prg\mnxPraxis.prg"

* Sanitarios
*!*	On Bar 2 Of Modulos Activate Popup Sanitarios
*!*	Define Popup Sanitarios Margin Relative Shadow Color Scheme 4
*!*	Define Bar 01 Of Sanitarios Prompt "A\<rchivos" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Archivos.ico"
*!*	Define Bar 02 Of Sanitarios Prompt "\<Launcher" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Fenix.ico"
*!*	Define Bar 03 Of Sanitarios Prompt "Stoc\<k" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Stock.ico"
*!*	Define Bar 04 Of Sanitarios Prompt "\<Utiles" Picture "V:\CloudFenix\Fw\Comunes\Image\Modulos\Utiles.ico"

*!*	On Selection Bar 01 Of Sanitarios Do ModifyProject With "V:\CloudFenix\Clientes\Sanitarios\prTraArc\prtraarc.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 02 Of Sanitarios Do ModifyProject With "V:\CloudFenix\Clientes\Sanitarios\Launcher\Launcher.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 03 Of Sanitarios Do ModifyProject With "V:\CloudFenix\Clientes\Sanitarios\prGesSto\prgessto.pjx" In "Tools\Varios\prg\mnxPraxis.prg"
*!*	On Selection Bar 04 Of Sanitarios Do ModifyProject With "V:\CloudFenix\Clientes\Sanitarios\prUtiles\prutiles.pjx" In "Tools\Varios\prg\mnxPraxis.prg"

* Entorno
*!*	On Bar 6 Of praxis Activate Popup Entorno
*!*	Define Popup Entorno Margin Relative Shadow Color Scheme 4
*!*	Define Bar 1 Of Entorno Prompt "\<Framework"
*!*	Define Bar 2 Of Entorno Prompt "\<Clipper2Fox"

*!*	On Selection Bar 1 Of Entorno Do SetPath With ENV_FRAMEWORK In 'V:\FenixV2\Tools\Varios\prg\SetPath.prg'
*!*	On Selection Bar 2 Of Entorno Do SetPath With ENV_CLIPPER2FOX In 'V:\Cliper2Fox\Tools\Varios\prg\SetPath.prg'



Return


Procedure LimpiarTodo
	Clear All
	Do LiberarEntorno In 'Tools\Varios\prg\LiberarEntorno.prg'
EndProc

Procedure VerPath
	MessageBox( Set("Path") )
EndProc


Procedure ModifyProject( cProjectName )
	Modify Project ( cProjectName ) Nowait
EndProc 