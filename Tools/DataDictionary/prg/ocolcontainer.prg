#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
	Do 'Tools\DataDictionary\prg\oContainer.prg'
	DO 'Tools\DataDictionary\prg\oColBase.prg'
	
Endif

* oColContainer
* Colección de contenedores.
Define Class oColContainer As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg' 

	#If .F.
		Local This As oColContainer Of 'Tools\DataDictionary\prg\oColContainer.prg'
	#Endif

	* Archivo de la libreria de clases.
	cClassLibrary = 'oContainer.Prg'

	* Directorio de la libreria de clases.
	cClassLibraryFolder = 'Tools\DataDictionary\prg'

	* Nombre de la clase contenida.
	cClassName = 'oContainer'

	* Nombre de la clase.
	Name = 'oColContainer'

	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="cclasslibrary" type="property" display="cClassLibrary" />] ;
		+ [<memberdata name="cclasslibraryfolder" type="property" display="cClassLibraryFolder" />] ;
		+ [<memberdata name="cclassname" type="property" display="cClassName" />] ;
		+ [</VFPData>]

Enddefine && oColContainer