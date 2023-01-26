#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'

If .F.
    Do 'Tools\DataDictionary\prg\oColBase.prg'

Endif

* oColReportOrder
* Colección de Reportes
Define Class oColReportOrder As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg' 

    #If .F.
        Local This As oColReportOrder Of 'Tools\DataDictionary\prg\oColReportOrder.prg'
    #Endif

    * Archivo de la libreria de clases
    cClassLibrary = 'oReportOrder.Prg'

    * Directorio de la libreria de clases
    cClassLibraryFolder = 'Tools\DataDictionary\prg'

    *!*	Nombre de la clase contenida
    cClassName = 'oReportOrder'

    * Nombre de la clase
    Name = 'oColReportOrder'

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [</VFPData>]

Enddefine && oColReportOrder