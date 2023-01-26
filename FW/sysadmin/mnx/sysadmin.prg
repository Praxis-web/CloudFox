#INCLUDE "FW\SysAdmin\Include\SA.h"

Try


	Local lcImage As String

	Define Pad _2800pm5hz Of _Msysmenu Prompt "\<Implementación" Color Scheme 3 ;
		KEY Alt+I, "ALT+I"
	On Pad _2800pm5hz Of _Msysmenu Activate Popup implementa

	Define Popup implementa Margin Relative Shadow Color Scheme 4

	lcImage = Addbs( SA_IMG ) + "table.ico"
	Define Bar 1 Of implementa Prompt "\<Tablas" ;
		PICTURE lcImage
		
	If .F.
 		Do "table.ico"
	EndIf	

	lcImage = Addbs( SA_IMG ) + "group.ico"
	Define Bar 2 Of implementa Prompt "\<Usuarios" ;
		PICTURE lcImage
		
	If .F.
 		Do "group.ico"
	EndIf	
		
	On Bar 1 Of implementa Activate Popup tablas
	On Bar 2 Of implementa Activate Popup _2800pim4c

	Define Popup tablas Margin Relative Shadow Color Scheme 4

	lcImage = Addbs( SA_IMG ) + "form.bmp"
	Define Bar 1 Of tablas Prompt "\<Formularios" ;
		PICTURE lcImage
		
	If .F.
 		Do "form.bmp"
	EndIf	
		
	*!*		Define Bar 2 Of tablas Prompt "\<Procesos"
	*!*		Define Bar 3 Of tablas Prompt "\<Tipo de Procesos"

	*!*		lcImage = Addbs( SA_IMG ) + "table.ico"
	*!*		Define Bar 4 Of tablas Prompt "T\<ablas del Sistema" ;
	*!*			PICTURE lcImage

*!*		On Selection Bar 1 Of tablas Launch( Addbs( SA_SCX ) + "ABM Formulario" )
	On Selection Bar 1 Of tablas LaunchForm( "ABM Formulario" )
	
	If .F.
		* Asegurarse que el builder lo incluya en el proyecto
		Do Form "ABMFORMULARIO"
	Endif

	*!*		On Selection Bar 2 Of tablas Launch( Addbs( SA_SCX ) + "ABM Procesos" )
	*!*		On Selection Bar 3 Of tablas Launch( Addbs( SA_SCX ) + "ABM Tipo de Proceso" )
	*!*		On Selection Bar 4 Of tablas Launch( Addbs( SA_SCX ) + "ABM Tablas" )

	Define Popup _2800pim4c Margin Relative Shadow Color Scheme 4

	lcImage = Addbs( SA_IMG ) + "group.ico"
	Define Bar 1 Of _2800pim4c Prompt "\<Group" ;
		PICTURE lcImage

	lcImage = Addbs( SA_IMG ) + "user.ico"
	Define Bar 2 Of _2800pim4c Prompt "\<Usuario" ;
		PICTURE lcImage
		
	If .F.
 		Do "user.ico"
	EndIf	

	* On Selection Bar 1 Of _2800pim4c Launch( Addbs( SA_SCX ) + On Selection Bar 4 Of _2800pim4c Wait Wind "ABM Grupos" Nowait
	*"ABM Grupos" )
	
	If .F.
		* Asegurarse que el builder lo incluya en el proyecto
		* Do Form "ABM Grupos"
		* Do utGrupo.prg
	Endif


	* On Selection Bar 2 Of _2800pim4c Launch( Addbs( SA_SCX ) + "ABM Usuarios" )
	* On Selection Bar 4 Of _2800pim4c Wait Wind "ABM Usuarios" Nowait
	
	If .F.
		* Asegurarse que el builder lo incluya en el proyecto
		* Do Form "ABM Usuarios"
	Endif


Catch To oErr
	Local loError As ErrorHandler Of "fw\Actual\ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError


Finally

Endtry