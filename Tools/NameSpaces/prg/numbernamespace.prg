#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
Endif

* NumberNameSpace
Define Class NumberNameSpace As NameSpaceBase Of Tools\namespaces\prg\ObjectNameSpace.prg

	#If .F.
		Local This As NumberNameSpace Of 'Tools\namespaces\prg\NumberNameSpace.prg'
	#Endif

	*-- XML Metadata for customizable properties
	Protected m._MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name = "esimpar" type = "method" display = "EsImpar" />] ;
		+ [<memberdata name = "int2hex" type = "method" display = "Int2Hex" />] ;
		+ [<memberdata name = "lennum" type = "method" display = "LenNum" />] ;
		+ [</VFPData>]

	Hidden nAUp
	nAUp = Asc ( 'A' )

	Hidden n0
	n0 = Asc ( '0' )

	Dimension EsImpar_COMATTRIB[ 5 ]
	EsImpar_COMATTRIB[ 1 ] = 0
	EsImpar_COMATTRIB[ 2 ] = 'Devuelve un valor logico Si tnNumber es Impar, devuelve .T.'
	EsImpar_COMATTRIB[ 3 ] = 'EsImpar'
	EsImpar_COMATTRIB[ 4 ] = 'Boolean'
	* EsImpar_COMATTRIB[ 5 ] = 0

	* EsImpar
	* Devuelve un valor logico Si tnNumber es Impar, devuelve .T.
	Function EsImpar ( tnNumber As Number ) As Boolean HelpString 'Devuelve un valor logico Si tnNumber es Impar, devuelve .T.'


		Local llRet As Boolean, ;
			loErr As Exception
		Try

			llRet = ( ! Empty ( Mod ( tnNumber, 2 ) ) )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnNumber
			THROW_EXCEPTION

		Endtry

		Return llRet

	Endfunc && EsImpar

	Dimension Int2Hex_COMATTRIB[ 5 ]
	Int2Hex_COMATTRIB[ 1 ] = 0
	Int2Hex_COMATTRIB[ 2 ] = 'Devuelve la representación del número en formato hexa.'
	Int2Hex_COMATTRIB[ 3 ] = 'Int2Hex'
	Int2Hex_COMATTRIB[ 4 ] = 'String'
	* Int2Hex_COMATTRIB[ 5 ] = 0

	* Int2Hex
	* Devuelve la representación del número en formato hexa.
	Function Int2Hex ( tnInt As Integer ) As String HelpString 'Devuelve la representación del número en formato hexa.'

		Local lcHex As String, ;
			lnInt As Integer, ;
			lnMod As Integer, ;
			loErr As Exception

		Try

			lcHex = ''

			If tnInt < 16
				If tnInt < 10
					lcHex = Chr ( This.n0 + tnInt )

				Else && tnInt < 10
					lcHex = Chr ( This.nAUp + ( tnInt - 10 ) )

				Endif && tnInt < 10

			Else && tnInt < 16
				lnInt = Int ( tnInt / 16 )
				lnMod = Mod ( tnInt, 16 )

				If lnMod < 10
					lcHex = Chr ( This.n0 + lnMod )

				Else && lnMod < 10
					lcHex = Chr ( This.nAUp + ( lnMod - 10 ) )

				Endif && lnMod < 10

				lcHex = This.Int2Hex ( lnInt ) + lcHex

			Endif && tnInt < 16

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnInt
			THROW_EXCEPTION

		Endtry

		Return lcHex

	Endfunc && Int2Hex

	Dimension LenNum_COMATTRIB[ 5 ]
	LenNum_COMATTRIB[ 1 ] = 0
	LenNum_COMATTRIB[ 2 ] = 'Devuelve la cantidad de dígitos de un campo numérico.'
	LenNum_COMATTRIB[ 3 ] = 'LenNum'
	LenNum_COMATTRIB[ 4 ] = 'String'
	* LenNum_COMATTRIB[ 5 ] = 0

	* LenNum
	* Devuelve la cantidad de dígitos de un campo numérico
	Function LenNum ( tnNumber As Number, tuDecimals As Variant ) As Number HelpString 'Devuelve la cantidad de dígitos de un campo numérico.'

		Local lcNum As String, ;
			lnAt As Integer, ;
			lnLenght As Number, ;
			loErr As Exception

		Try

			lcNum = m.String.Any2Char ( m.tnNumber )
			If Pcount() > 1
				lnAt = At ( '.', m.lcNum )
				If ! Empty ( m.lnAt )
					lcNum = Substr ( m.lcNum, m.lnAt + 1)

				Else
					lcNum = ''

				Endif && ! Empty( m.lnAt )

			Endif && Pcount()>1

			lnLenght = Len ( m.lcNum )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnNumber, tuDecimals
			THROW_EXCEPTION

		Endtry

		Return m.lnLenght

	Endfunc && LenNum

Enddefine && NumberNameSpace