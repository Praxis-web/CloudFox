*!* ///////////////////////////////////////////////////////
*!* Class.........: colOrderBy
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Colección de objetos FILTRO
*!* Date..........: Viernes 6 de Julio de 2007 (14:01:17)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*


#INCLUDE "Fw\comunes\Include\Praxis.h"

Define Class colOrderBy As Collection

	#If .F.
		Local This As colOrderBy Of "Fw\comunes\Prg\colOrderBy.Prg"
	#Endif


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oOrderBy vacío
	*!* Date..........: Viernes 6 de Julio de 2007 (14:08:10)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure New(  ) As Object;
			HELPSTRING "Obtiene un elemento oOrderBy vacío"

		Local loOrderBy As Object

		loOrderBy = Createobject( "Empty" )

		AddProperty( loOrderBy, "DisplayValue", "" )
		AddProperty( loOrderBy, "FieldName", "" )
		AddProperty( loOrderBy, "CursorName", "" )

		Return loOrderBy

	Endproc
	*!*
	*!* END PROCEDURE New
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: colOrderBy
*!*
*!* ///////////////////////////////////////////////////////