#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'

If .F.
    Do 'Tools\DataDictionary\prg\oBase.prg'

Endif

* oForm
* Representa un formulario
Define Class oForm As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

    #If .F.
        Local This As oForm Of 'Tools\DataDictionary\prg\oForm.prg'
    #Endif

    * Nombre unico de fantasía del formulario.
    cKeyName = ''

    * Carpeta donde se encuentra el formulario.
    cFolder = ''

    * Extension del formulario.
    cExt = 'scx'

    * Identificación del formulario.
    nFormId = -1

    * @TODO: Agregar los permisos

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
			    + [<VFPData>] ;
			    + [<memberdata name="ckeyname" type="property" display="cKeyName" />] ;
			    + [<memberdata name="cext" type="property" display="cExt" />] ;
			    + [<memberdata name="cfolder" type="property" display="cFolder" />] ;
			    + [<memberdata name="nformid" type="property" display="nFormId" />] ;
			    + [</VFPData>]

Enddefine && oForm