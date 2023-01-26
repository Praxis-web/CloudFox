*!* ///////////////////////////////////////////////////////
*!* Class.........: colFiltros
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

Define Class colFiltros as PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg" 

	#If .F.
		Local This As colFiltros Of "Fw\comunes\Prg\colFiltros.Prg"
	#Endif

	*!* Cantidad de objetos Page destinados a filtros
	PageCount = 1

	*!* Lista de nombres, separados por comas, de los objetos Page
	PagesNameList = "Generales"

	*!* Lista de los caption de los objetos Page
	PagesCaptionList = "Filtros Generales"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="newforeignkey" type="method" display="NewForeignKey" />] + ;
		[<memberdata name="newstring" type="method" display="NewString" />] + ;
		[<memberdata name="newnumeric" type="method" display="NewNumeric" />] + ;
		[<memberdata name="newdate" type="method" display="NewDate" />] + ;
		[<memberdata name="pagescaptionlist" type="property" display="PagesCaptionList" />] + ;
		[<memberdata name="pagesnamelist" type="property" display="PagesNameList" />] + ;
		[<memberdata name="pagecount" type="property" display="PageCount" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Obtiene un elemento oFiltro vacío
	*!* Date..........: Viernes 6 de Julio de 2007 (14:08:10)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure New( cName as String ) As Object;
			HELPSTRING "Obtiene un elemento oFiltro vacío"

		Local loFiltro As Object

		loFiltro = Createobject( "Empty" )

		AddProperty( loFiltro, "PageName", "Page1" )
		AddProperty( loFiltro, "FilterClass", "" )
		AddProperty( loFiltro, "FilterClassLibrary", "Filtros" )
		AddProperty( loFiltro, "FilterClassLibraryFolder", Addbs( FL_LIBS ) )
		AddProperty( loFiltro, "Caption", "" )
		AddProperty( loFiltro, "CursorName", "" )
		AddProperty( loFiltro, "FieldName", "" )
		AddProperty( loFiltro, "Name", IfEmpty( cName, "Filtro" + Any2Char( This.Count + 1 ) ))
		AddProperty( loFiltro, "cFieldExp", "" )
		
		
		This.AddItem( loFiltro, Lower( loFiltro.Name ) )

		Return loFiltro

	Endproc
	*!*
	*!* END PROCEDURE New
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: NewString
	*!* Description...: Devuelve un filtro para comparar campos tipo string
	*!* Date..........: Jueves 23 de Agosto de 2007 (18:14:00)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure NewString( cName as String ) As Object;
			HELPSTRING "Devuelve un filtro para comparar campos tipo string"

		Local loFiltro As Object

		loFiltro = This.New( cName )

		loFiltro.FilterClass = "FiltroFromToTxt"
		loFiltro.Caption = "Nombre"

		Return loFiltro

	Endproc
	*!*
	*!* END PROCEDURE NewString
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: NewNumeric
	*!* Description...: Devuelve un filtro para comparar campos tipo Numeric
	*!* Date..........: Jueves 23 de Agosto de 2007 (18:14:25)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure NewNumeric( cName as String ) As Object;
			HELPSTRING "Devuelve un filtro para comparar campos tipo Numeric"
		Local loFiltro As Object

		loFiltro = This.New( cName )

		loFiltro.FilterClass = "FiltroFromToNumeric"
		loFiltro.Caption = "Código"

		Return loFiltro


	Endproc
	*!*
	*!* END PROCEDURE NewNumeric
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: NewDate
	*!* Description...: Devuelve un filtro para comparar campos tipo Date
	*!* Date..........: Jueves 23 de Agosto de 2007 (18:14:45)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*


	Procedure NewDate( cName as String ) As Object;
			HELPSTRING "Devuelve un filtro para comparar campos tipo Date"

		Local loFiltro As Object

		loFiltro = This.New( cName )

		loFiltro.FilterClass = "FiltroFromToDate"
		loFiltro.Caption = "Fecha"

		Return loFiltro


	Endproc
	*!*
	*!* END PROCEDURE NewDate
	*!*
	*!* ///////////////////////////////////////////////////////

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: NewForeignKey
	*!* Description...: Devuelve un filtro para comparar una Foreign Key (Integer)
	*!* Date..........: Jueves 23 de Agosto de 2007 (18:17:17)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure NewForeignKey( cName as String ) As Object;
			HELPSTRING "Devuelve un filtro para comparar una Foreign Key (Integer)"

		Local loFiltro As Object

		loFiltro = This.New( cName )

		loFiltro.FilterClass = "FiltroForeignKey"
		loFiltro.Caption = "Foreign Key"

		Return loFiltro


	Endproc
	*!*
	*!* END PROCEDURE NewForeignKey
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: colFiltros
*!*
*!* ///////////////////////////////////////////////////////