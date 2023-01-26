#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oControl.prg'
    Do 'Tools\DataDictionary\prg\oColBase.prg'

Endif

* oColControls
* Colección de controles.
Define Class oColControls As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'

    #If .F.
        Local This As oColControls Of 'Tools\DataDictionary\prg\oColControls.prg'
    #Endif

    * Archivo de la libreria de clases.
    cClassLibrary = 'oControl.Prg'

    * Directorio de la libreria de clases.
    cClassLibraryFolder = 'Tools\DataDictionary\prg'

    * Nombre de la clase contenida.
    cClassName = 'oControl'

    * Nombre de la clase.
    Name = 'oColControls'

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="cclasslibrary" type="property" display="cClassLibrary" />] ;
        + [<memberdata name="cclasslibraryfolder" type="property" display="cClassLibraryFolder" />] ;
        + [<memberdata name="cclassname" type="property" display="cClassName" />] ;
        + [</VFPData>]

Enddefine && oColControls