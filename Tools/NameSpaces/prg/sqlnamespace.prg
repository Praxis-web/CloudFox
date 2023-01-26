#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
	Do 'Tools\namespaces\prg\EnvironmentNamespace.prg'
Endif

* SQLNameSpace
Define Class SQLNameSpace As Namespacebase Of 'Tools\namespaces\prg\objectnamespace.prg'

	#If .F.
		Local This As SQLNameSpace Of 'Tools\namespaces\prg\SQLNameSpace.prg'
	#Endif

	*-- XML Metadata for customizable properties
	Protected m._MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "fecha2sql" type = "method" display = "Fecha2Sql" />] ;
		+ [</VFPData>]

	* Fecha2Sql
	* Devuelve la fecha FOX enmascarada.
	Function Fecha2Sql ( tdFecha As Date ) As String HelpString 'Devuelve la fecha FOX enmascarada.'

		* DAE 2009-09-22

		Local lcDate As String, ;
			lcType As String, ;
			loErr As Exception, ;
			loSetDate As Object

		Try
			* lcOldDate = Set( "Date" )
			* Set Date To YMD
			loSetDate = m.Environment.SetDate ('YMD')

			lcType = Vartype ( m.tdFecha )
			Do Case
				Case m.lcType == 'D'
					lcDate = '<#' + Dtoc ( m.tdFecha ) + '#>'

				Case m.lcType == 'T'
					lcDate = '<$' + Ttoc ( m.tdFecha ) + '$>'

				Otherwise
					lcDate = '<##>'

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, m.tdFecha
			THROW_EXCEPTION

		Finally
			* Set Date to (lcOldDate)
			loSetDate = Null

		Endtry

		Return lcDate

	Endfunc && Fecha2Sql

Enddefine && SQLNameSpace