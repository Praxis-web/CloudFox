#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
Endif

* LogicalNameSpace
Define Class LogicalNameSpace As NameSpaceBase Of 'Tools\namespaces\prg\ObjectNamespace.prg' 

	#If .F.
		Local This As LogicalNameSpace Of 'Tools\namespaces\prg\LogicalNameSpace.prg'
	#Endif

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "biton" type = "method" display = "BitOn" />] ;
		+ [<memberdata name = "checktype" type = "method" display = "CheckType" />] ;
		+ [<memberdata name = "ifempty" type = "method" display = "IfEmpty" />] ;
		+ [<memberdata name = "isdebugmode" type = "method" display = "IsDebugMode" />] ;
		+ [<memberdata name = "isempty" type = "method" display = "IsEmpty" />] ;
		+ [<memberdata name = "isfalse" type = "method" display = "IsFalse" />] ;
		+ [<memberdata name = "isinlist" type = "method" display = "IsInList" />] ;
		+ [<memberdata name = "isruntime" type = "method" display = "IsRuntime" />] ;
		+ [<memberdata name = "IsTrue" type = "method" display = "IsTrue" />] ;
		+ [</VFPData>]

	Dimension BitOn_COMATTRIB[ 5 ]
	BitOn_COMATTRIB[ 1 ] = 0
	BitOn_COMATTRIB[ 2 ] = 'Devuelve .T. si el bit buscado esta prendido en el número dado.'
	BitOn_COMATTRIB[ 3 ] = 'BitOn'
	BitOn_COMATTRIB[ 4 ] = 'Boolean'
	* BitOn_COMATTRIB[ 5 ] = 0

	* BitOn
	* Devuelve .T. si el bit buscado esta prendido en el número dado.
	Function BitOn ( tnExp1 As Number, tnExp2 As Number ) As Boolean HelpString 'Devuelve .T. si el bit buscado esta prendido en el número dado.'

		Local llRet As Boolean, ;
			loErr As Exception

		Try
			llRet = ( Bitand ( m.tnExp1, m.tnExp2 ) == m.tnExp2 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnExp1, tnExp2
			THROW_EXCEPTION

		Endtry

		Return m.llRet

	Endfunc && BitOn

	Dimension CheckType_COMATTRIB[ 5 ]
	CheckType_COMATTRIB[ 1 ] = 0
	CheckType_COMATTRIB[ 2 ] = 'Devuelve .T. si Verifica que el tipo del dato contenido en tvValue se encuentre en la lista tcTypelist.'
	CheckType_COMATTRIB[ 3 ] = 'CheckType'
	CheckType_COMATTRIB[ 4 ] = 'Boolean'
	* CheckType_COMATTRIB[ 5 ] = 0

	* CheckType
	* Devuelve .T. si Verifica que el tipo del dato contenido en tvValue se encuentre en la lista tcTypelist.
	Function CheckType ( tvValue As Variant, tcTypeList As String ) As Boolean HelpString 'Devuelve .T. si Verifica que el tipo del dato contenido en tvValue se encuentre en la lista tcTypelist.'
		* CheckType verifica que el tipo del dato contenido en tvValue se
		* encuentre en la lista tcTypelist. Devuelve un valor Lógico

		Local lcType As String, ;
			llRet As Boolean, ;
			loErr As Exception

		Try
			lcType = Vartype ( m.tvValue )
			llRet  = m.lcType $ Upper ( m.tcTypeList )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvValue, tcTypeList
			THROW_EXCEPTION

		Endtry

		Return m.llRet

	Endfunc && CheckType

	Dimension IfEmpty_COMATTRIB[ 5 ]
	IfEmpty_COMATTRIB[ 1 ] = 0
	IfEmpty_COMATTRIB[ 2 ] = 'Devuelve el primer parametro si este no es vacio, si es vacio devuelve el segundo parametro.'
	IfEmpty_COMATTRIB[ 3 ] = 'IfEmpty'
	IfEmpty_COMATTRIB[ 4 ] = 'Variant'
	* IfEmpty_COMATTRIB[ 5 ] = 0

	* IfEmpty
	* Devuelve el primer parametro si este no es vacio, si es vacio devuelve el segundo parametro.
	* Parametros....: Value to evaluate, Value to return if empty
	* Returns the first parameter as is, or the second one if first is empty
	Function IfEmpty (  tvEvaluate As Variant, tvReturnIfEmpty As Variant ) As Variant HelpString 'Devuelve el primer parametro si este no es vacio, si es vacio devuelve el segundo parametro.'

		Return Iif ( This.IsEmpty ( m.tvEvaluate ), m.tvReturnIfEmpty, m.tvEvaluate )

	Endfunc && IfEmpty

	Dimension IsDebugMode_COMATTRIB[ 5 ]
	IsDebugMode_COMATTRIB[ 1 ] = 0
	IsDebugMode_COMATTRIB[ 2 ] = 'Devuelve .T. si se está ejecutando en el IDE.'
	IsDebugMode_COMATTRIB[ 3 ] = 'IsDebugMode'
	IsDebugMode_COMATTRIB[ 4 ] = 'Boolean'
	* IsDebugMode_COMATTRIB[ 5 ] = 0

	* IsDebugMode
	* Devuelve .T. si se está ejecutando en el IDE.
	Function IsDebugMode() As Boolean HelpString 'Devuelve .T. si se está ejecutando en el IDE.'

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve TRUE si se está en modo desarrollo.
				 *:Project:
				 Praxis
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Martes 27 de Septiembre de 2005 (18:21:10)
				 *:ModiSummary:
				 R/0001 -
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

		Return Version ( 2 ) == 2

	Endfunc && IsDebugMode

	Dimension IsEmpty_COMATTRIB[ 5 ]
	IsEmpty_COMATTRIB[ 1 ] = 0
	IsEmpty_COMATTRIB[ 2 ] = 'Al evaluar una variable de tipo objeto, se considera vacia si esta nula.'
	IsEmpty_COMATTRIB[ 3 ] = 'IsEmpty'
	IsEmpty_COMATTRIB[ 4 ] = 'Boolean'
	* IsEmpty_COMATTRIB[ 5 ] = 0

	* IsEmpty
	* Al evaluar una variable de tipo objeto, se considera vacia si esta nula.
	Function IsEmpty ( tvValue As Variant ) As Boolean HelpString 'Al evaluar una variable de tipo objeto, se considera vacia si esta nula.'

		Return Iif ( Vartype ( m.tvValue ) == 'O', Isnull ( m.tvValue ), Empty ( m.tvValue ) Or Isnull ( m.tvValue ) )

	Endfunc && IsEmpty

	Dimension IsFalse_COMATTRIB[ 5 ]
	IsFalse_COMATTRIB[ 1 ] = 0
	IsFalse_COMATTRIB[ 2 ] = 'Devuelve .T. si el valor dado es .F. o un equivalente.'
	IsFalse_COMATTRIB[ 3 ] = 'IsFalse'
	IsFalse_COMATTRIB[ 4 ] = 'Boolean'
	* IsFalse_COMATTRIB[ 5 ] = 0

	* IsFalse
	* Devuelve .T. si el valor dado es .F. o un equivalente.
	Function IsFalse ( tuValue As Variant ) As Boolean HelpString 'Devuelve .T. si el valor dado es .F. o un equivalente.'
		Local lcCommand As String, ;
			llFalse As Boolean, ;
			loErr As Exception

		Try

			llFalse = ! This.IsTrue ( m.tuValue )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tuValue
			THROW_EXCEPTION

		Endtry

		Return llFalse

	Endfunc && IsFalse

	Dimension IsInList_COMATTRIB[ 5 ]
	IsInList_COMATTRIB[ 1 ] = 0
	IsInList_COMATTRIB[ 2 ] = 'Devuelve .T. si la candena buscada se encuentra en la lista del tipo cadena armada con los valores y el separador dado.'
	IsInList_COMATTRIB[ 3 ] = 'IsInList'
	IsInList_COMATTRIB[ 4 ] = 'Boolean'
	* IsInList_COMATTRIB[ 5 ] = 0

	* IsInList
	* Devuelve .T. si la candena buscada se encuentra en la lista del tipo cadena armada con los valores y el separador dado.
	Function IsInList ( tcWordSerched As String, tcWordsList As String, tcDelimiter As Character ) As Boolean HelpString 'Devuelve .T. si la candena buscada se encuentra en la lista del tipo cadena armada con los valores y el separador dado.'

		Local lcCommand As String, ;
			lcStrList As String, ;
			liIdx As Integer, ;
			llInList As Boolean, ;
			loErr As Exception

		Try

			llInList  = .F.
			lcStrList = ''

			If ! Empty ( tcWordsList )

				If Empty ( tcDelimiter )
					tcDelimiter = ','

				Endif && Empty( tcDelimiter )

				For liIdx = 1 To Getwordcount ( tcWordsList, tcDelimiter )
					* lcStrList = lcStrList + ",'" + Alltrim ( Lower ( Getwordnum ( tcWordsList, liIdx, tcDelimiter ) ) ) + "'"
					TEXT to lcStrList ADDITIVE TEXTMERGE NOSHOW PRETEXT 15
						,'<<Alltrim ( Lower ( Getwordnum ( tcWordsList, liIdx, tcDelimiter ) ) )>>'

					ENDTEXT

				Endfor

				If Substr ( lcStrList, 1, 1 ) == tcDelimiter
					lcStrList = Substr ( lcStrList, 2 )

				Endif && Substr( lcStrList, 1, 1 ) == tcDelimiter

				TEXT To lcCommand Noshow Textmerge Pretext 15
					llInList = Inlist( '<<Lower( tcWordSerched )>>', <<lcStrList>>, '<<tcDelimiter>>' )

				ENDTEXT

				&lcCommand.

			Endif && ! Empty( tcWordsList )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcWordSerched, tcWordsList, tcDelimiter
			THROW_EXCEPTION

		Endtry

		Return llInList

	Endfunc && IsInList

	Dimension IsRuntime_COMATTRIB[ 5 ]
	IsRuntime_COMATTRIB[ 1 ] = 0
	IsRuntime_COMATTRIB[ 2 ] = 'Devuelve .T. si se está en tiempo de ejecución.'
	IsRuntime_COMATTRIB[ 3 ] = 'IsRuntime'
	IsRuntime_COMATTRIB[ 4 ] = 'Boolean'
	* IsRuntime_COMATTRIB[ 5 ] = 0

	* IsRuntime
	* Devuelve .T. si se está en tiempo de ejecución.
	Function IsRuntime() As Boolean HelpString 'Devuelve .T. si se está en tiempo de ejecución.'

		Return Version ( 2 ) == 0

	Endfunc && IsRuntime

	Dimension IsTrue_COMATTRIB[ 5 ]
	IsTrue_COMATTRIB[ 1 ] = 0
	IsTrue_COMATTRIB[ 2 ] = 'Devuelve .T. si el valor dado es .T. o un equivalente.'
	IsTrue_COMATTRIB[ 3 ] = 'IsTrue'
	IsTrue_COMATTRIB[ 4 ] = 'Boolean'
	* IsTrue_COMATTRIB[ 5 ] = 0

	* IsTrue
	* Devuelve .T. si el valor dado es .T. o un equivalente.
	Function IsTrue ( tuValue As Variant ) As Boolean HelpString 'Devuelve .T. si el valor dado es .T. o un equivalente.'

		Local llTrue As Boolean, ;
			loErr As Exception

		Try

			llTrue = Cast ( tuValue As Logical )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tuValue
			THROW_EXCEPTION

		Endtry

		Return llTrue

	Endfunc && IsTrue

Enddefine && LogicalNameSpace