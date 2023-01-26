#include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'
#Include 'Tools\DataDictionary\Include\DataDictionary.h'

* oReportFilter
* Filtro para un reporte.
Define Class oReportFilter As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

	#If .F.
		Local This As oReportFilter Of 'Tools\DataDictionary\prg\oReportFilter.prg'
	#Endif

	oField = Null

	Protected m._MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [</VFPData>]

	* This_Access
	Protected Function This_Access ( tcMemberName As String ) As Object

		Local loField As Object, ;
			loRet As Object

		loRet = This

		If ! Pemstatus ( This, m.tcMemberName, 5 )
			loField = This.oField
			If Vartype ( loField ) == 'O' And Pemstatus ( loField, m.tcMemberName, 5 )
				loRet = loField

			Endif && Vartype( .oField ) = 'O' And Pemstatus( .oField, m.tcMemberName, 5 )

		Endif && ! Pemstatus( This, m.tcMemberName, 5 )

		Return m.loRet

	Endfunc && This_Access

Enddefine && oReportFilter