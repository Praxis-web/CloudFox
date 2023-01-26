#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'

If .F.
    Do 'Tools\DataDictionary\prg\oBase.prg'

Endif
* oStoreProcedure
* Clase base de datos.
Define Class oStoreProcedure As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

    #If .F.
        Local This As oStoreProcedure Of 'Tools\DataDictionary\prg\oStoreProcedure.prg'
    #Endif

    #If .F.
        TEXT
			 *:Help Documentation
			 *:Description:
			 Clase Base de Datos
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

    * Nombre del archivo que contiene el Store procedure
    cFileName = ''

    cCodigo   = ''

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
			    + [<VFPData>] ;
			    + [<memberdata name="cfilename" type="property" display="cFileName" />] ;
			    + [<memberdata name="ccodigo" type="property" display="cCodigo" />] ;
			    + [</VFPData>]

Enddefine && oStoreProcedure