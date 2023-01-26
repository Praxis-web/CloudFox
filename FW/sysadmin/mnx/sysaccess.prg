* #INCLUDE "ERP\Actual\SysAdmin\Include\SA.h"
#INCLUDE "FW\SysAdmin\Include\SA.h"
Local loError As ErrorHandler Of "fw\Actual\ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"
Local lcImage As String
Try

	Define Pad _2800pm5hz Of _Msysmenu Prompt "\<Implementación" Color Scheme 3 ;
		KEY Alt+I, "ALT+I"
	On Pad _2800pm5hz Of _Msysmenu Activate Popup implementa

	Define Popup implementa Margin Relative Shadow Color Scheme 4

	lcImage = Addbs( SA_IMG ) + "table.ico"
	Define Bar 1 Of implementa Prompt "\<Tablas" ;
		PICTURE lcImage

	If .F.
		Do "table.ico"
	Endif

	lcImage = Addbs( SA_IMG ) + "group.ico"
	Define Bar 2 Of implementa Prompt "\<Usuarios" ;
		PICTURE lcImage

	If .F.
		Do "group.ico"
	Endif

	On Bar 1 Of implementa Activate Popup tablas
	On Bar 2 Of implementa Activate Popup _2800pim4c

	Define Popup tablas Margin Relative Shadow Color Scheme 4

	lcImage = Addbs( SA_IMG ) + "form.bmp"
	Define Bar 1 Of tablas Prompt "\<Formularios" ;
		PICTURE lcImage

	If .F.
		Do "form.bmp"
	Endif
	* DAE 2009-07-01 (12:11:53)
	* On Selection Bar 1 Of tablas Launch( Addbs( SA_SCX ) + "ABM Formularios" )
	On Selection Bar 1 Of tablas Wait Window "ABM Formularios" Nowait
	If .F.
		* Asegurarse que el builder lo incluya en el proyecto
		Do Form "ABMFormulario"
	Endif

	Define Popup _2800pim4c Margin Relative Shadow Color Scheme 4

	lcImage = Addbs( SA_IMG ) + "group.ico"
	Define Bar 1 Of _2800pim4c Prompt "\<Organización" ;
		PICTURE lcImage

	lcImage = Addbs( SA_IMG ) + "group.ico"
	Define Bar 2 Of _2800pim4c Prompt "\<Modulos" ;
		PICTURE lcImage

	lcImage = Addbs( SA_IMG ) + "group.ico"
	Define Bar 3 Of _2800pim4c Prompt "\<Objetos" ;
		PICTURE lcImage

	lcImage = Addbs( SA_IMG ) + "group.ico"
	Define Bar 4 Of _2800pim4c Prompt "\<Grupos" ;
		PICTURE lcImage

	* On Selection Bar 1 Of _2800pim4c Launch( Addbs( SA_SCX ) + "ABM Organization" )
	On Selection Bar 1 Of _2800pim4c Wait Wind "ABM Organization" Nowait
	* On Selection Bar 2 Of _2800pim4c Launch( Addbs( SA_SCX ) + "ABM Modulos" )
	On Selection Bar 2 Of _2800pim4c Wait Wind "ABM Modulos" Nowait
	* On Selection Bar 3 Of _2800pim4c Launch( Addbs( SA_SCX ) + "ABM Objectos" )
	On Selection Bar 3 Of _2800pim4c Wait Wind "ABM Objectos" Nowait
	* On Selection Bar 4 Of _2800pim4c Launch( Addbs( SA_SCX ) + "ABM Grupos" )
	On Selection Bar 4 Of _2800pim4c Wait Wind "ABM Grupos" Nowait

	*!*	If .F.
	*!*		* Asegurarse que el builder lo incluya en el proyecto
	*!*		Do Form "ABM Organization"
	*!*		Do Form "ABM Menu"
	*!*		Do Form "ABM Modulos"
	*!*		Do Form "ABM Grupos"
	*!*		Do Form "ABM Objectos"
	*!*		Do utGrupo.prg
	*!*	Endif

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError
Finally

Endtry