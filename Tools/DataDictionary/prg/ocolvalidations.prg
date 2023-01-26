#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oColBase.prg'
    Do 'Tools\DataDictionary\prg\oValidationBase.prg'

Endif

* oColValidations
* Colección de validadores para un campo.
Define Class oColValidations As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg' 

    #If .F.
        Local This As oColValidations Of 'Tools\DataDictionary\prg\oColValidations.prg'
    #Endif

    * Archivo de la libreria de clases.
    cClassLibrary = 'oValidationBase.Prg'

    * Directorio de la libreria de clases.
    cClassLibraryFolder = 'Tools\DataDictionary\prg'

    * Nombre de la clase contenida.
    cClassName = 'oValidationBase'

    * Nombre de la clase.
    Name = 'oColValidations'

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="cclasslibrary" type="property" display="cClassLibrary" />] ;
        + [<memberdata name="cclasslibraryfolder" type="property" display="cClassLibraryFolder" />] ;
        + [<memberdata name="cclassname" type="property" display="cClassName" />] ;
        + [</VFPData>]

Enddefine && oColValidations