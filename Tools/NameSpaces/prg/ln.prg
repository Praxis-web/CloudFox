#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

* Main
Local loErr As Exception
Try

	Wait Window NoWait "Cargando NameSpace ...."
	LoadNamespace()

Catch To loErr
	DEBUG_EXCEPTION
	Throw_EXCEPTION
	
Finally 	
	Wait CLEAR 
		
Endtry