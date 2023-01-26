#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

* oReport
* Representa un Reporte
Define Class oReport As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

	#If .F.
		Local This As oReport Of 'Tools\DataDictionary\prg\oReport.prg'
	#Endif

	* Colección de filtros
	oColFilter = Null

	* Colección de orden
	oColOrder = Null

	* Referencia al formulario
	oForm = Null

	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ocolfilter" type="property" display="oColFilter" />] + ;
		[<memberdata name="ocolorder" type="property" display="oColOrder" />] + ;
		[<memberdata name='oForm' type="property" display='oForm' />] + ;
		[</VFPData>]

	* oColFilter_Access
	Protected Function oColFilter_Access() As ColReportFilter Of 'Tools\DataDictionary\prg\ColReportFilter.prg'

		Local loErr As Exception, ;
			loError As ErrorHandler Of 'FW\ErrorHandler\ErrorHandler.prg'

		Try

			If Vartype ( This.oColFilter ) # 'O'
				This.oColFilter = _NewObject ( 'ColReportFilter', 'Tools\DataDictionary\prg\ColReportFilter.prg' )

			Endif && Vartype( .oColFilter ) # "O"

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError = Null

		Endtry
		Return This.oColFilter

	Endfunc && oColFilter_Access

	* oColOrder_Access
	Protected Function oColOrder_Access() As ColReportOrder Of 'Tools\DataDictionary\prg\ColReportOrder.prg'

		Local loErr As Exception, ;
			loError As ErrorHandler Of 'FW\ErrorHandler\ErrorHandler.prg'

		Try

			If Vartype ( This.oColOrder ) # 'O'
				This .oColOrder = _NewObject ( 'ColReportOrder', 'Tools\DataDictionary\prg\ColReportOrder.prg' )

			Endif && Vartype( This .oColOrder ) # '"O'

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			loError = Null

		Endtry

		Return This.oColOrder

	Endproc && oColOrder_Access

Enddefine && oReport