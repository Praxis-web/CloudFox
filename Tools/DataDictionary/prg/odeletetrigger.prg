#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

* oDeleteTrigger
* Clase trigger para delete. 
Define Class oDeleteTrigger As oTrigger Of 'Tools\DataDictionary\prg\oTrigger.prg' 

	#If .F.
		Local This As oDeleteTrigger Of 'Tools\DataDictionary\prg\oDeleteTrigger.prg'
	#Endif

	#If .F.
		TEXT
		 *:Help Documentation
		 *:Description:
		 Clase trigger para delete.
		 *:Project:
		 Sistemas Praxis
		 *:Autor:
		 Damián Eiff
		 *:Date:
		 Martes 29 de Mayo de 2007 (11:00:34)
		 *:Parameters:
		 *:Remarks:
		 *:Returns:
		 *:Example:
		 *:SeeAlso:
		 *:Events:
		 *:KeyWords:
		 *:Inherits:
		 *:Exceptions:
		 *:NameSpace:
		 digitalizarte.com
		 *:EndHelp
		ENDTEXT
	#Endif

Enddefine && oDeleteTrigger