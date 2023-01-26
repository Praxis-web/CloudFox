*!* ///////////////////////////////////////////////////////
*!* Class.........: colFields
*!* ParentClass...: Collection
*!* BaseClass.....: Collection
*!* Description...: Colección de objetos FIELD
*!* Date..........: Viernes 6 de Julio de 2007 (14:01:17)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*


#INCLUDE "Fw\comunes\Include\Praxis.h"

Define Class colFields As PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg" 

	#If .F.
		Local This As colFields Of "Fw\comunes\Prg\colFields.Prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="additem" type="method" display="AddItem" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oField vacío
	*!* Date..........: Viernes 6 de Julio de 2007 (14:08:10)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure New(  ) As Object;
			HELPSTRING "Obtiene un elemento oField vacío"

		Local loField As Object,;
			loHeader As Object

		loField = Createobject( "Empty" )
		loHeader = Createobject( "Empty" )

		AddProperty( loHeader, "Alignment" )
		AddProperty( loHeader, "BackColor" )
		AddProperty( loHeader, "BackStyle" )
		AddProperty( loHeader, "FontBold" )
		AddProperty( loHeader, "FontItalic" )
		AddProperty( loHeader, "FontName" )
		AddProperty( loHeader, "FontSize" )
		AddProperty( loHeader, "FontStrikethru" )
		AddProperty( loHeader, "FontUnderline" )
		AddProperty( loHeader, "ForeColor" )
		AddProperty( loHeader, "Caption" )
		AddProperty( loHeader, "Value" )
		

		AddProperty( loField, "Alignment" )
		AddProperty( loField, "BackColor" )
		AddProperty( loField, "BackStyle" )
		AddProperty( loField, "DisplayValue", "" )
		AddProperty( loField, "FontBold" )
		AddProperty( loField, "FontItalic" )
		AddProperty( loField, "FontName" )
		AddProperty( loField, "FontSize" )
		AddProperty( loField, "FontStrikethru" )
		AddProperty( loField, "FontUnderline" )
		AddProperty( loField, "ForeColor" )
		AddProperty( loField, "InputMask" )
		AddProperty( loField, "Name" )
		AddProperty( loField, "Selected", .T. )
		AddProperty( loField, "TabIndex" )
		AddProperty( loField, "Value" )

		AddProperty( loField, "oHeader", loHeader )
		AddProperty( loField, "oLinkedField" )


		Return loField

	Endproc
	*!*
	*!* END PROCEDURE New
	*!*
	*!* ///////////////////////////////////////////////////////




Enddefine
*!*
*!* END DEFINE
*!* Class.........: colFields
*!*
*!* ///////////////////////////////////////////////////////