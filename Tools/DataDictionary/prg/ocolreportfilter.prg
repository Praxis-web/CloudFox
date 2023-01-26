#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oColBase.prg'

Endif

* oColReportFilter
* Colección de filtros para los reportes.
Define Class oColReportFilter As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'  

    #If .F.
        Local This As oColReportFilter Of 'Tools\DataDictionary\prg\oColReportFilter.prg'
    #Endif

    * Archivo de la libreria de clases.
    cClassLibrary = 'oReportFilter.Prg'

    * Directorio de la libreria de clases.
    cClassLibraryFolder = 'Tools\DataDictionary\prg'

    * Nombre de la clase contenida.
    cClassName = 'oReportFilter'

    * Nombre de la clase.
    Name = 'oColReportFilter'

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="cclasslibrary" type="property" display="cClassLibrary" />] ;
        + [<memberdata name="cclasslibraryfolder" type="property" display="cClassLibraryFolder" />] ;
        + [<memberdata name="cclassname" type="property" display="cClassName" />] ;
        + [</VFPData>]

Enddefine && oColReportFilter