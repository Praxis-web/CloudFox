#include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'

* oValidationBase
* Validación base
Define Class oValidationBase As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

	#If .F.
		Local This As oValidationBase Of 'Tools\DataDictionary\prg\oValidationBase.prg'
	#Endif

	* Referencia l campo que se va a validar
	oField = Null

	Protected m._MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="execute" type="method" display="Execute" />] ;
		+ [<memberdata name="ofield" type="property" display="oField" />] ;
		+ [<memberdata name="this_access" type="method" display="This_Access" />] ;
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

			Endif && Vartype ( loField ) == 'O' And Pemstatus ( loField, m.tcMemberName, 5 )

		Endif && ! Pemstatus( This, m.tcMemberName, 5 )

		Return loRet

	Endfunc && This_Access

	* Execute
	Procedure Execute ( tcCursorName As String ) As Boolean
		#If .F.
			Text
		        *:Help Documentation
		        *:Topic:
		        *:Description:
		        Metodo que se ejecuta para la validación
		        *:Project:
		        Sistemas Praxis
		        *:Autor:
		        Damian Eiff
		        *:Date:
		        Miércoles 11 de Marzo de 2009 (11:50:29)
		        *:ModiSummary:
		        *:Syntax:
		        *:Example:
		        *:Events:
		        *:NameSpace:
		        praxis.com
		        *:Keywords:
		        *:Implements:
		        *:Inherits:
		        *:Parameters:
		        toParam As Object
		        *:Remarks:
		        *:Returns:
		        Boolean
		        *:Exceptions:
		        *:SeeAlso:
		        *:EndHelp
			Endtext
		#Endif

		Return .T.

	Endproc && Execute

Enddefine && oValidationBase