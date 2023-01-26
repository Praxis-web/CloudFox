#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oColBase.prg'

Endif

* oColReports
* Colección de reportes.
Define Class oColReports As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg' 

    #If .F.
        Local This As oColReports Of 'Tools\DataDictionary\prg\oColReports.prg'
    #Endif

    * Archivo de la libreria de clases.
    cClassLibrary = 'oReport.prg'

    * Directorio de la libreria de clases.
    cClassLibraryFolder = 'Tools\DataDictionary\prg'

    * Nombre de la clase contenida.
    cClassName = 'oReport'

    * Nombre de la clase.
    Name = 'oColReports'

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="cclasslibrary" type="property" display="cClassLibrary" />] ;
        + [<memberdata name="cclasslibraryfolder" type="property" display="cClassLibraryFolder" />] ;
        + [<memberdata name="cclassname" type="property" display="cClassName" />] ;
        + [<memberdata name="initialize" type="method" display="Initialize" />] ;
        + [</VFPData>]

    Dimension Initialize_COMATTRIB[ 5 ]
    Initialize_COMATTRIB[ 1 ] = 0
    Initialize_COMATTRIB[ 2 ] = 'Devuelve .T. si el objeto se inicializo correctamente.'
    Initialize_COMATTRIB[ 3 ] = 'Initialize'
    Initialize_COMATTRIB[ 4 ] = 'Boolean'
    * Initialize_COMATTRIB[ 5 ] = 0

    * Initialize
    * Devuelve .T. si el objeto se inicializo correctamente.
    * Template Method para iniciar el objeto.
    Function Initialize( uParam As Variant ) As Boolean HelpString 'Devuelve .T. si el objeto se inicializo correctamente. Template Method para iniciar el objeto.'
    Endfunc && Initialize

Enddefine && oColReports