#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

* oECFG
Define Class oECFG As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

	#If .F.
		Local This As oECFG Of 'Tools\DataDictionary\prg\oECFG.prg'
	#Endif

	Dimension cObjectName_COMATTRIB[ 4 ]
	cObjectName_COMATTRIB[ 1 ] = 0
	cObjectName_COMATTRIB[ 2 ] = 'Nombre del objeto.'
	cObjectName_COMATTRIB[ 3 ] = 'cObjectName'
	cObjectName_COMATTRIB[ 4 ] = 'String'

	* Nombre del objeto.
	cObjectName = ''

	Dimension cTierLevel_COMATTRIB[ 4 ]
	cTierLevel_COMATTRIB[ 1 ] = 0
	cTierLevel_COMATTRIB[ 2 ] = 'Nivel de la capa.'
	cTierLevel_COMATTRIB[ 3 ] = 'cTierLevel'
	cTierLevel_COMATTRIB[ 4 ] = 'String'

	* Nivel de la capa.
	cTierLevel = ''

	Dimension cObjClass_COMATTRIB[ 4 ]
	cObjClass_COMATTRIB[ 1 ] = 0
	cObjClass_COMATTRIB[ 2 ] = 'Clase.'
	cObjClass_COMATTRIB[ 3 ] = 'cObjClass'
	cObjClass_COMATTRIB[ 4 ] = 'String'

	* Clase.
	cObjClass = ''

	Dimension cObjClassLibrary_COMATTRIB[ 4 ]
	cObjClassLibrary_COMATTRIB[ 1 ] = 0
	cObjClassLibrary_COMATTRIB[ 2 ] = 'Libreria de clases.'
	cObjClassLibrary_COMATTRIB[ 3 ] = 'cObjClassLibrary'
	cObjClassLibrary_COMATTRIB[ 4 ] = 'String'

	* Libreria de clases.
	cObjClassLibrary = ''

	Dimension cObjClassLibraryFolder_COMATTRIB[ 4 ]
	cObjClassLibraryFolder_COMATTRIB[ 1 ] = 0
	cObjClassLibraryFolder_COMATTRIB[ 2 ] = 'Carpeta de la libreria de clases.'
	cObjClassLibraryFolder_COMATTRIB[ 3 ] = 'cObjClassLibraryFolder'
	cObjClassLibraryFolder_COMATTRIB[ 4 ] = 'String'

	* Carpeta de la libreria de clases.
	cObjClassLibraryFolder = ''

	Dimension cObjComponent_COMATTRIB[ 4 ]
	cObjComponent_COMATTRIB[ 1 ] = 0
	cObjComponent_COMATTRIB[ 2 ] = 'Nombre del componente.'
	cObjComponent_COMATTRIB[ 3 ] = 'cObjComponent'
	cObjComponent_COMATTRIB[ 4 ] = 'String'

	* Nombre del componente.
	cObjComponent = ''

	Dimension lObjInComComponent_COMATTRIB[ 4 ]
	lObjInComComponent_COMATTRIB[ 1 ] = 0
	lObjInComComponent_COMATTRIB[ 2 ] = 'Es parte de un componente.'
	lObjInComComponent_COMATTRIB[ 3 ] = 'lObjInComComponent'
	lObjInComComponent_COMATTRIB[ 4 ] = 'Boolean'

	* Es parte de un componente.
	lObjInComComponent = .F.

	Protected m._MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cobjectname" type="property" display="cObjectName" />] + ;
		[<memberdata name="ctierlevel" type="property" display="cTierLevel" />] + ;
		[<memberdata name="cobjclass" type="property" display="cObjClass" />] + ;
		[<memberdata name="cobjclasslibrary" type="property" display="cObjClassLibrary" />] + ;
		[<memberdata name="cobjclasslibraryfolder" type="property" display="cObjClassLibraryFolder" />] + ;
		[<memberdata name="cobjcomponent" type="property" display="cObjComponent" />] + ;
		[<memberdata name="lobjincomcomponent" type="property" display="lObjInComComponent" />] + ;
		[</VFPData>]

Enddefine && oECFG