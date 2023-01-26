#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'

* oColTiers
* Colección de Capas
Define Class oColTiers As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg' 

	#If .F.
		Local This As oColTiers Of 'Tools\DataDictionary\prg\oColTiers.prg'
	#Endif

	Protected m._MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [</VFPData>]

	Function New ( tcTierLevel As String )  As oECFG Of 'Tools\DataDictionary\prg\DataDictionary.prg' HelpString 'Obtiene un elemento oECFG vacío'

		Local lcKey As String, ;
			loEcfg As oECFG Of 'Tools\DataDictionary\prg\DataDictionary.prg', ;
			loErr As Object, ;
			loError As ErrorHandler Of 'ErrorHandler\Prg\ErrorHandler.prg'

		#If .F.
			TEXT
		        *:Help Documentation
		        *:Topic:
		        *:Description:
			   Obtiene un elemento oECFG vacío
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
			   tcTierLevel As String
		        *:Remarks:
		        *:Returns:
		         oECFG Of 'Tools\DataDictionary\prg\DataDictionary.prg'
		        *:Exceptions:
		        *:SeeAlso:
		        *:EndHelp
			ENDTEXT
		#Endif

		Try
			If ! Empty ( m.tcTierLevel )
				loEcfg = Createobject ( 'oECFG' )
				lcKey  = Lower ( m.tcTierLevel )
				m.liIdx = This.GetKey (m.lcKey )

				If Empty ( m.liIdx )
					loEcfg.oParent    = This.oParent
					loEcfg.cTierLevel = m.tcTierLevel
					This.AddItem ( m.loEcfg, m.lcKey )

				Else
					Error 'Ya existe la Tier ' + m.tcTierLevel

				Endif &&  Empty( m.liIdx )

			Else
				Error 'Falta definir el nombre de la Tier'

			Endif && ! Empty( m.tcTierLevel )

		Catch To loErr
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			Throw m.loError

		Finally
			loError = Null

		Endtry

		Return m.loEcfg

	EndFunc && New

Enddefine && oColTiers