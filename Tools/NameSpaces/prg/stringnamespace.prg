#INCLUDE "FW\Comunes\Include\Praxis.h"

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
	Do 'Tools\namespaces\prg\EnvironmentNamespace.prg'
Endif


#Define _Ascii 	1
#Define _ANSI 	2

* StringNameSpace
Define Class StringNameSpace As Namespacebase Of 'Tools\namespaces\prg\objectnamespace.prg'

	#If .F.
		Local This As StringNameSpace Of 'Tools\namespaces\prg\StringNameSpace.prg'
	#Endif

	oSQL = Null

	oCache = Null

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="ansii2ascii" type="method" display="Ansii2Ascii"/>] ;
		+ [<memberdata name="any2char" type="method" display="Any2Char"/>] ;
		+ [<memberdata name="camelpropercase" type="method" display="CamelProperCase"/>] ;
		+ [<memberdata name="char2any" type="method" display="Char2Any"/>] ;
		+ [<memberdata name="cleanstring" type="method" display="CleanString"/>] ;
		+ [<memberdata name="firstup" type="method" display="FirstUp"/>] ;
		+ [<memberdata name="propercase" type="method" display="ProperCase"/>] ;
		+ [<memberdata name="properfilename" type="method" display="ProperFileName"/>] ;
		+ [<memberdata name="stringbuilder" type="method" display="StringBuilder"/>] ;
		+ [<memberdata name="stringformat" type="method" display="StringFormat"/>] ;
		+ [<memberdata name="stringwidth" type="method" display="StringWidth"/>] ;
		+ [<memberdata name="stringzero" type="method" display="StringZero"/>] ;
		+ [<memberdata name="stringzero2" type="method" display="StringZero2"/>] ;
		+ [<memberdata name="osql" type="property" display="oSQL"/>] ;
		+ [<memberdata name="hex2int" type="method" display="Hex2Int"/>] ;
		+ [<memberdata name="nodelimiters" type="method" display="NoDelimiters"/>] ;
		+ [<memberdata name="parsememo" type="method" display="ParseMemo"/>] ;
		+ [<memberdata name="parsestring" type="method" display="ParseString"/>] ;
		+ [<memberdata name="printf" type="method" display="Printf"/>] ;
		+ [<memberdata name="strformat" type="method" display="StrFormat"/>] ;
		+ [<memberdata name="strtoi2of5" type="method" display="StrToI2Of5"/>] ;
		+ [<memberdata name="validatecuit" type="method" display="ValidateCuit"/>] ;
		+ [</VFPData>]

	Hidden m.cAnsiChars
	cAnsiChars = ''

	Hidden m.cAsciiChars
	cAsciiChars = ''

	Hidden m.nAUp
	nAUp = Asc ( 'A' )

	Hidden m.nFUp
	nFUp = Asc ( 'F' )

	Hidden m.nALow
	nALow = Asc ( 'a' )

	Hidden m.nFLow
	nFLow = Asc ( 'f' )

	Hidden m.n0
	n0 = Asc ( '0' )

	Hidden m.n9
	n9 = Asc ( '9' )

	* Init
	Procedure Init() As VOID

		Local laAnsi2Ascii[36, 2], ;
			liIdx As Integer, ;
			lnLen As Integer

		DoDefault()

		This.oCache = Createobject( 'Collection' )

		laAnsi2Ascii[ 01, _ANSI ]   = Chr ( 225 )
		laAnsi2Ascii[ 01, _Ascii  ] = Chr ( 160 )		&& á

		laAnsi2Ascii[ 02, _ANSI ]   = Chr ( 233 )
		laAnsi2Ascii[ 02, _Ascii  ] = Chr ( 130 )		&& é

		laAnsi2Ascii[ 03, _ANSI ]   = Chr ( 237 )
		laAnsi2Ascii[ 03, _Ascii  ] = Chr ( 161 )		&& í

		laAnsi2Ascii[ 04, _ANSI ]   = Chr ( 243 )
		laAnsi2Ascii[ 04, _Ascii  ] = Chr ( 162 )		&& ó

		laAnsi2Ascii[ 05, _ANSI ]   = Chr ( 250 )
		laAnsi2Ascii[ 05, _Ascii  ] = Chr ( 163 )		&& ú

		*----------------------------------------------------

		laAnsi2Ascii[ 06, _ANSI ]   = Chr ( 228 )
		laAnsi2Ascii[ 06, _Ascii  ] = Chr ( 132 )		&& ä

		laAnsi2Ascii[ 07, _ANSI ]   = Chr ( 235 )
		laAnsi2Ascii[ 07, _Ascii  ] = Chr ( 137 )		&& ë

		laAnsi2Ascii[ 08, _ANSI ]   = Chr ( 239 )
		laAnsi2Ascii[ 08, _Ascii  ] = Chr ( 139 )		&& ï

		laAnsi2Ascii[ 09, _ANSI ]   = Chr ( 246 )
		laAnsi2Ascii[ 09, _Ascii  ] = Chr ( 148 )		&& ö

		laAnsi2Ascii[ 10, _ANSI ]   = Chr ( 252 )
		laAnsi2Ascii[ 10, _Ascii  ] = Chr ( 129 )		&& ü


		*-----------------------------------------------

		laAnsi2Ascii[ 11, _ANSI ]   = Chr ( 193 )
		laAnsi2Ascii[ 11, _Ascii  ] = Chr ( 181 )		&& Á

		laAnsi2Ascii[ 12, _ANSI ]   = Chr ( 201 )
		laAnsi2Ascii[ 12, _Ascii  ] = Chr ( 141 )		&& É

		laAnsi2Ascii[ 13, _ANSI ]   = Chr ( 205 )
		laAnsi2Ascii[ 13, _Ascii  ] = Chr ( 214 )		&& Í

		laAnsi2Ascii[ 14, _ANSI ]   = Chr ( 211 )
		laAnsi2Ascii[ 14, _Ascii  ] = Chr ( 224 )		&& Ó

		laAnsi2Ascii[ 15, _ANSI ]   = Chr ( 218 )
		laAnsi2Ascii[ 15, _Ascii  ] = Chr ( 233 )		&& Ú

		*----------------------------------------------------

		laAnsi2Ascii[ 16, _ANSI ]   = Chr ( 224 )
		laAnsi2Ascii[ 16, _Ascii  ] = Chr ( 133 )		&& à

		laAnsi2Ascii[ 17, _ANSI ]   = Chr ( 232 )
		laAnsi2Ascii[ 17, _Ascii  ] = Chr ( 138 )		&& è

		laAnsi2Ascii[ 18, _ANSI ]   = Chr ( 236 )
		laAnsi2Ascii[ 18, _Ascii  ] = Chr ( 141 )		&& ì

		laAnsi2Ascii[ 19, _ANSI ]   = Chr ( 242 )
		laAnsi2Ascii[ 19, _Ascii  ] = Chr ( 149 )		&& ò

		laAnsi2Ascii[ 20, _ANSI ]   = Chr ( 249 )
		laAnsi2Ascii[ 20, _Ascii  ] = Chr ( 151 )		&& ù

		*-----------------------------------------------

		laAnsi2Ascii[ 21, _ANSI ]   = Chr ( 196 )
		laAnsi2Ascii[ 21, _Ascii  ] = Chr ( 142 )		&& Ä

		laAnsi2Ascii[ 22, _ANSI ]   = Chr ( 203 )
		laAnsi2Ascii[ 22, _Ascii  ] = Chr ( 211 )		&& Ë

		laAnsi2Ascii[ 23, _ANSI ]   = Chr ( 207 )
		laAnsi2Ascii[ 23, _Ascii  ] = Chr ( 216 )		&& Ï

		laAnsi2Ascii[ 24, _ANSI ]   = Chr ( 214 )
		laAnsi2Ascii[ 24, _Ascii  ] = Chr ( 153 )		&& Ö

		laAnsi2Ascii[ 25, _ANSI ]   = Chr ( 220 )
		laAnsi2Ascii[ 25, _Ascii  ] = Chr ( 154 )		&& Ü

		*----------------------------------------------------

		laAnsi2Ascii[ 26, _ANSI ]   = Chr ( 192 )
		laAnsi2Ascii[ 26, _Ascii  ] = Chr ( 183 )		&& À

		laAnsi2Ascii[ 27, _ANSI ]   = Chr ( 200 )
		laAnsi2Ascii[ 27, _Ascii  ] = Chr ( 212 )		&& È

		laAnsi2Ascii[ 28, _ANSI ]   = Chr ( 204 )
		laAnsi2Ascii[ 28, _Ascii  ] = Chr ( 222 )		&& Ì

		laAnsi2Ascii[ 29, _ANSI ]   = Chr ( 210 )
		laAnsi2Ascii[ 29, _Ascii  ] = Chr ( 227 )		&& Ò

		laAnsi2Ascii[ 30, _ANSI ]   = Chr ( 217 )
		laAnsi2Ascii[ 30, _Ascii  ] = Chr ( 235 )		&& Ù

		*--------------------------------------------------

		laAnsi2Ascii[ 31, _ANSI ]   = Chr ( 241 )
		laAnsi2Ascii[ 31, _Ascii  ] = Chr ( 164 )		&& ñ

		laAnsi2Ascii[ 32, _ANSI ]   = Chr ( 209 )
		laAnsi2Ascii[ 32, _Ascii  ] = Chr ( 165 )		&& Ñ

		laAnsi2Ascii[ 33, _ANSI ]   = Chr ( 186 )
		laAnsi2Ascii[ 33, _Ascii  ] = Chr ( 167 )		&& º

		*--------------------------------------------------

		laAnsi2Ascii[ 34, _ANSI ]   = Chr ( 189 )
		laAnsi2Ascii[ 34, _Ascii  ] = Chr ( 171 )		&& ½

		laAnsi2Ascii[ 35, _ANSI ]   = Chr ( 188 )
		laAnsi2Ascii[ 35, _Ascii  ] = Chr ( 172 )		&& ¼

		laAnsi2Ascii[ 36, _ANSI ]   = Chr ( 190 )
		laAnsi2Ascii[ 36, _Ascii  ] = Chr ( 243 )		&& ¾

		For liIdx = 1 To 36
			This.cAnsiChars  = m.This.cAnsiChars + laAnsi2Ascii[ liIdx, _ANSI  ]
			This.cAsciiChars = m.This.cAsciiChars + laAnsi2Ascii[ liIdx, _Ascii ]

		Endfor

	Endproc && Init

	* Destroy
	Procedure Destroy () As VOID

		This.oSQL = Null
		DoDefault()

	Endproc && Destroy

	* Ansii2Ascii
	* Devuelve una cadena convirtiendo los caracteres de ANSII a ASCII.
	Function Ansii2Ascii ( tcString As String, tlInversa As Boolean ) As String HelpString 'Devuelve una cadena convirtiendo los caracteres de ANSII a ASCII.'

		Local lcReturn As String, ;
			loErr As Object

		Try

			If Empty ( m.tlInversa )
				tlInversa = .F.

			Endif && Empty ( m.tlInversa )

			If Empty ( m.tcString )
				tcString = ''

			Endif && Empty ( m.tcString )

			lcReturn = ''

			If m.tlInversa
				lcReturn = Chrtran ( m.tcString, m.This.cAnsiChars, m.This.cAsciiChars )

			Else && m.tlInversa
				lcReturn = Chrtran ( m.tcString, m.This.cAsciiChars, m.This.cAnsiChars )

			Endif && m.tlInversa

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcString, tlInversa
			THROW_EXCEPTION

		Endtry

		Return m.lcReturn

	Endfunc

	* Any2Char
	* Devuelve una cadena conviertiendo el tipo recibido a cadena.
	Function Any2Char ( tvValue As Variant, tcDelimiter As String ) As String HelpString 'Devuelve una cadena conviertiendo el tipo recibido a cadena.'
		* Any2Char recibe un valor de cualquier tipo y devuelve el mismo transformado en un tipo Character

		Local lWithDelimiters As Boolean, ;
			lcCommand As String, ;
			lcDelimiterType As String, ;
			lcOldSetCentury As String, ;
			lcOldSetDate As String, ;
			lcRetValue As String, ;
			lcValueType As String, ;
			loErr As Exception

		Try
			lcOldSetCentury = Set ( 'Century' )
			lcOldSetDate    = Set ( 'Date' )
			Set Century On
			Set Date To YMD
			lcDelimiterType = Vartype ( m.tcDelimiter )
			Do Case
				Case m.lcDelimiterType == 'C'
					lWithDelimiters = .T.

				Case m.lcDelimiterType == 'L'
					lWithDelimiters = m.tcDelimiter

				Otherwise
					lWithDelimiters = .F.

			Endcase

			lcValueType = Vartype ( m.tvValue )
			Do Case
				Case m.lcValueType == 'X'
					lcRetValue = ''

				Case m.lcValueType == 'T'
					lcRetValue = Ttoc ( m.tvValue )

				Case m.lcValueType == 'D'
					lcRetValue = Dtoc ( m.tvValue )

				Otherwise
					lcRetValue = Transform ( m.tvValue )

			Endcase

			If m.lWithDelimiters
				Do Case
					Case m.lcValueType == 'X'
						lcRetValue = 'Null'

					Case m.lcValueType == 'C'
						If m.lcDelimiterType == 'L'
							tcDelimiter = "'"

						Endif && m.lcDelimiterType == 'L'

						lcRetValue = Left ( m.tcDelimiter, 1 ) + m.lcRetValue + Right ( m.tcDelimiter, 1 )

					Case m.lcValueType $ 'TD'
						If Empty ( m.tvValue )
							lcRetValue = '{}'

						Else
							lcRetValue = '{^' + m.lcRetValue + '}'

						Endif && Empty( m.tvValue )


					Otherwise

				Endcase

			Endif

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvValue, tcDelimiter
			THROW_EXCEPTION

		Finally
			TEXT To m.lcCommand Textmerge Noshow Pretext 15
    			Set Century <<m.lcOldSetCentury>>
			ENDTEXT
			&lcCommand

			TEXT To m.lcCommand Textmerge Noshow Pretext 15
    			Set Date To <<m.lcOldSetDate>>
			ENDTEXT
			&lcCommand

		Endtry

		Return m.lcRetValue

	Endfunc && Any2Char

	* CamelProperCase
	* Devuelve la cadena con la sintaxis CamelCase.
	Function CamelProperCase ( tcExpression As String ) As String HelpString 'Devuelve la cadena con la sintaxis CamelCase.'

		Local lAntrIsUpper As Boolean, ;
			lIsUpper As Integer, ;
			lcExpression As String, ;
			lcLetter As String, ;
			lcRetValue As String, ;
			lnIdx As Number, ;
			lnLen As Integer, ;
			loErr As Exception

		Try

			tcExpression = m.Logical.IfEmpty ( m.tcExpression, '' )
			lnLen        = Len ( m.tcExpression )
			tcExpression = Chrtran ( m.tcExpression, '_', Space ( 1 ) )
			lcExpression = ''
			For lnIdx = 1 To m.lnLen
				lcLetter = Substr ( m.tcExpression, lnIdx, 1 )
				lIsUpper = Isupper ( m.lcLetter )
				If m.lnIdx > 1 And m.lIsUpper And ! m.lAntrIsUpper
					lcExpression = m.lcExpression + Space ( 1 ) + m.lcLetter

				Else
					lcExpression = m.lcExpression + m.lcLetter

				Endif && m.lnIdx > 1 And m.lIsUpper And ! m.lAntrIsUpper

				lAntrIsUpper = m.lIsUpper

			Next
			lcRetValue = Strtran ( This.ProperCase ( m.lcExpression ), Space ( 2 ), Space ( 1 ) )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcExpression
			THROW_EXCEPTION

		Endtry

		Return m.lcRetValue

	Endfunc && CamelProperCase

	* Char2Any
	* Devuelve un variant transformando la cadena recibida al tipo dado.
	Function Char2Any ( tuValue As Variant, tcType As String ) As Variant HelpString 'Devuelve un variant transformando la cadena recibida al tipo dado.'
		* Char2Any recibe un valor tipo Character y devuelve el mismo transformado
		* en un tipo determinado

		Local loErr As Exception, ;
			luValue As Variant

		Try

			Do Case
				Case m.tcType == T_NUMERIC
					luValue = Val ( tuValue )

				Case m.tcType == T_DATE
					luValue = Ctod ( tuValue )

				Case m.tcType == T_DATETIME
					luValue = Ctot ( tuValue )

				Case m.tcType == T_MEMO
					*/ No hace nada

				Case m.tcType == T_LOGICAL
					If tuValue $ 'SYV'
						luValue = .T.

					Else
						luValue = .F.

					Endif && tuValue $ "SYV"

				Otherwise
					* mbNoPrevista( Lineno( ), "El tipo &m.tcType. no es válido" )
					Error 'El tipo ' + m.tcType + ' no es válido'
					luValue = tuValue

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tuValue, tcType
			THROW_EXCEPTION

		Endtry

		Return m.luValue

	Endfunc && Char2Any

	* CleanString
	* Remueve de una cadena los caracteres no imprimibles
	Function CleanString ( tcValue As String ) As String HelpString 'Remueve de una cadena los caracteres no imprimibles'


		Local lcRetValue As String, ;
			loErr As Exception

		Try
			lcRetValue = m.tcValue
			lcRetValue = Strtran ( m.lcRetValue, CR, Space ( 1 ), -1, -1 )
			lcRetValue = Strtran ( m.lcRetValue, LF, Space ( 0 ), -1, -1 )
			lcRetValue = Strtran ( m.lcRetValue, Tab, Space ( 1 ), -1, -1 )
			lcRetValue = Strtran ( m.lcRetValue, Space ( 2 ), Space ( 1 ), -1, -1 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcValue
			THROW_EXCEPTION

		Endtry

		Return m.lcRetValue

	Endfunc && CleanString

	* FirstUp
	Function FirstUp ( tcString As String) As String
		*!* Devuelve un string con la primer letra en mayúsculas y el resto en minusculas

		Return Upper ( Substr ( m.tcString, 1, 1 ) ) + Lower ( Substr ( m.tcString, 2 ) )

	Endfunc && FirstUp

	* ProcessClause
	Function ProcessClause ( tcClause As String, tvOrigen As Variant, tcReplace As String ) As String

		Local lAFields[1], ;
			laMembers[1], ;
			lcField As String, ;
			lcMember As String, ;
			lcRet As String, ;
			lcType As String, ;
			lnIdx As Number, ;
			lnMax As Number, ;
			loErr As Exception, ;
			loItem As Object

		Try

			lcKey = Transform( tcClause ) + Transform( tvOrigen ) + Transform( tcReplace )
			If This.oCache.GetKey( lcKey ) == 0

				lcRet  = Space ( 1 ) + m.tcClause + Space ( 1 )
				lcType = Vartype ( m.tvOrigen )
				If Inlist ( m.lcType, 'C', 'O' )

					Do Case
						Case m.lcType = 'C' And Used ( m.tvOrigen )
							If Empty ( m.tcReplace )
								tcReplace = m.tvOrigen + '.'

							Endif && Empty( m.tcReplace )

							lnMax = Afields ( m.lAFields, m.tvOrigen )
							Asort ( lAFields, 1, -1, 1, 1 )
							For lnIdx = 1 To m.lnMax
								lcField = Alltrim ( lAFields[ lnIdx, 1 ] )
								lcRet   = Strtran ( m.lcRet, Space ( 1 ) + m.lcField, Space ( 1 ) + m.tcReplace + m.lcField, -1, -1, 1 )
								lcRet   = Strtran ( m.lcRet, '(' + m.lcField, '(' + m.tcReplace + m.lcField, -1, -1, 1 )

							Endfor

						Case m.lcType = 'O'
							If Empty ( m.tcReplace )
								tcReplace = 'loItem.'

							Endif && Empty( m.tcReplace )

							lnMax = Amembers ( laMembers, m.tvOrigen )
							Asort ( laMembers, 1, -1, 1, 1 )
							For lnIdx = 1 To m.lnMax
								lcMember = Alltrim ( laMembers[ m.lnIdx ] )
								If ! Inlist ( Lower ( m.lcMember ), 'left', 'height', 'top', 'width' )
									lcRet = Strtran ( lcRet, Space ( 1 ) + lcMember, Space ( 1 ) + tcReplace + lcMember, -1, -1, 1 )
									lcRet = Strtran ( m.lcRet, '(' + m.lcMember, '(' + m.tcReplace + m.lcMember, -1, -1, 1 )

								Endif && ! Inlist( Lower( m.lcMember ), "left", "height", "top", "width" )

							Endfor

							If Pemstatus ( m.tvOrigen, 'Class', 5 )
								lnMax = Amembers ( laMembers, m.tvOrigen.Class )
								Asort ( laMembers, 1, -1, 1, 1 )
								For lnIdx = 1 To m.lnMax
									lcMember = Alltrim ( laMembers[ m.lnIdx ] )

									If ! Inlist ( Lower ( m.lcMember ), 'left', 'height', 'top', 'width' )
										lcRet = Strtran ( lcRet, Space ( 1 ) + m.lcMember, Space ( 1 ) + m.tcReplace + m.lcMember, -1, -1, 1 )
										lcRet = Strtran ( lcRet, '(' + m.lcMember, '(' + m.tcReplace + m.lcMember, -1, -1, 1 )

									Endif && ! Inlist( Lower( m.lcMember ), "left", "height", "top", "width" )

								Endfor

							Endif && Pemstatus( m.tvOrigen, 'Class', 5 )

					Endcase

				Endif && Inlist( m.lcType, 'C', 'O' )

				m.lcRet = Alltrim ( m.lcRet )
				This.oCache.Add( m.lcRet, lcKey )

			Else

				m.lcRet = This.oCache.Item( lcKey )

			Endif

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcClause, tvOrigen, tcReplace
			THROW_EXCEPTION

		Finally
			loItem = Null

		Endtry

		Return m.lcRet

	Endfunc && ProcessClause


	* ProperCase
	Function ProperCase ( tcExpression As String, tcSepBefore As Character, tcSepAfter As Character ) As String  HelpString 'Convierte un string al modelo apropiado de Mayusculas/Minusculas aceptando un separador'
		* Convierte un string al modelo apropiado de Mayusculas/Minusculas
		* aceptando un separador

		Local lcString As String, ;
			loErr As Object
		Try

			If m.Logical.IsEmpty ( m.tcSepBefore )
				tcSepBefore = Space ( 1 )

			Endif && m.Logical.IsEmpty( m.tcSepBefore )

			If m.Logical.IsEmpty ( m.tcSepAfter )
				tcSepAfter = m.tcSepBefore

			Endif && m.Logical.IsEmpty( tcSepAfter )

			lcString = Chrtran ( m.tcExpression, m.tcSepBefore, Space ( 1 ) )
			lcString = Proper ( m.lcString )
			lcString = Chrtran ( m.lcString, Space ( 1 ), m.tcSepAfter )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.lcString

	Endfunc && ProperCase

	* properfilename.prg
	Function ProperFileName ( tcFileName As String ) As String

		Local lcFileName As String, ;
			lcWord As String, ;
			lnIdx As Number, ;
			lnLen As Integer, ;
			loErr As Exception

		Try
			lcFileName = ''
			lnLen      = Getwordcount ( m.tcFileName, '\' )

			For lnIdx = 1 To m.lnLen
				* lcWord = Proper( Getwordnum( tcFileName, lnIdx, '\' ) )
				lcWord = Getwordnum ( m.tcFileName, lnIdx, '\' )
				lcWord = Proper ( m.lcWord )
				If m.lnIdx = 1
					lcFileName = m.lcWord

				Else
					lcFileName = Addbs ( m.lcFileName ) + m.lcWord

				Endif && m.lnIdx = 1

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFileName
			THROW_EXCEPTION

		Endtry

		Return lcFileName

	Endfunc && ProperFileName

	* StringBuilder
	Function StringBuilder ( tcString As String, tv1 As Variant, tv2 As Variant, tv3 As Variant, tv4 As Variant, ;
			tv5 As Variant, tv6 As Variant, tv7 As Variant, tv8 As Variant, ;
			tv9 As Variant, tv10 As Variant, tv11 As Variant, tv12 As Variant, ;
			tv13 As Variant, tv14 As Variant, tv15 As Variant, tv16 As Variant, ;
			tv17 As Variant, tv18 As Variant, tv19 As Variant, tv20 As Variant, ;
			tv21 As Variant, tv22 As Variant, tv23 As Variant, tv24 As Variant, ;
			tv25 As Variant ) As String

		Local lcCount As String, ;
			lcFormat As String, ;
			lcReturn As String, ;
			lcSearch As String, ;
			lnCount As Number, ;
			loErr As Object

		* StringBuilder
		Try
			lcReturn = m.tcString
			For lnCount = 1 To Occurs ( '{', m.tcString )
				lcSearch = Strextract ( m.tcString, '{', '}', m.lnCount, 4 )
				lcFormat = Strextract ( m.lcSearch, ':', '}' )
				lcCount  = Chrtran ( Strtran ( m.lcSearch, m.lcFormat, '' ), '{:}', '' )
				If Empty ( m.lcFormat )
					lcReturn = Strtran ( m.lcReturn, m.lcSearch, Transform ( Evaluate ( 'tv' + m.lcCount ) ) )

				Else
					lcReturn = Strtran ( m.lcReturn, m.lcSearch, Transform ( Evaluate ( 'tv' + m.lcCount ), m.lcFormat ) )

				Endif && Empty( m.lcFormat )

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcString, tv1, tv2, tv3, tv4, tv5, tv6, tv7, tv8, tv9, tv10, tv11, tv12, tv13, tv14, tv15, tv16, tv17, tv18, tv19, tv20, tv21, tv22, tv23, tv24, tv25
			THROW_EXCEPTION

		Endtry
		Return m.lcReturn

	Endfunc && StringBuilder


	* StringFormat
	Function StringFormat ( tcStringing As String, tnTipo As Number ) As String
		* Transformar la oracion en may£scula o Min£scula
		* SINTAXIS: StringFormat( m.tcStringing, m.tnTipo )
		* m.tcStringing Oración
		* m.tnTipo = 1	 Tipo oracion
		* m.tnTipo = 2	 minúsculas
		* m.tnTipo = 3	 MAYÚSCULAS
		* m.tnTipo = 4	 Tipo T¡tulo
		* m.tnTipo = 5	 tIPO iNVERSO

		Local lToMay As Boolean, ;
			lcChar As Character, ;
			lcRet As String, ;
			lnIdx As Number, ;
			lnLen As Number, ;
			loErr As Exception

		Try

			lcRet       = m.tcStringing
			tcStringing = m.Logical.IfEmpty ( m.tcStringing, '' )
			tnTipo      = m.Logical.IfEmpty ( m.tnTipo, 0 )
			lnLen       = Len ( m.tcStringing )
			If m.tnTipo > 5
				tnTipo = 0

			Endif && m.tnTipo > 5

			If ! Empty ( m.tcStringing )
				Do Case
					Case m.tnTipo = 1 && Tipo oracion
						For lnIdx = 1 To m.lnLen
							If ! Empty ( Substr ( m.tcStringing, m.lnIdx, 1 ) )
								lcRet  =  Space ( lnIdx - 1 ) + Upper ( Substr ( m.tcStringing, m.lnIdx, 1 ) ) + Lower ( Substr ( m.tcStringing, m.lnIdx + 1 ) )
								Exit

							Endif

						Next

					Case m.tnTipo = 2 && minúsculas
						lcRet  =  Lower ( m.tcStringing )

					Case m.tnTipo = 3 && MAYÚSCULAS
						lcRet  =  Upper ( m.tcStringing )

					Case m.tnTipo = 4 && Tipo T¡tulo
						lcRet = Proper ( m.tcStringing )

					Case m.tnTipo = 5 && tIPO iNVERSO
						For lnIdx = 1 To m.lnLen
							lcChar = Substr ( m.tcStringing, m.lnIdx, 1 )
							If ! Empty ( m.lcChar )
								lToMay      = Islower ( m.lcChar )
								tcStringing = Stuff ( m.tcStringing, m.lnIdx, 1, Iif ( m.lToMay, Upper ( m.lcChar ), Lower ( m.lcChar ) ) )

							Endif &&  ! Empty( m.lcChar )

						Next
						lcRet = m.tcStringing

					Otherwise
						lcRet  =  Upper ( Substr ( m.tcStringing, 1, 1 ) ) + Substr ( m.tcStringing, 2 )

				Endcase

			Endif && ! Empty( m.tcStringing )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcStringing, tnTipo
			THROW_EXCEPTION

		Endtry

		Return m.lcRet

	Endfunc && StringFormat

	* StringWidth
	Function StringWidth ( tcTipo As String, tnLen As Number, tcFontName As String, tcFontSize As String, tcFontStyle As String )
		* Genera una cadena representativa del tipo de dato, que se utiliza
		* Para calcular el ancho en pixeles del control
		* tcTipo = Tipo de Dato
		* tnLen = Longitud de la cadena
		* tcFontName = Nombre de la Fuente
		* tcFontSize = Tamaño de la Fuente
		* tcFontStyle = Estilo de la Fuente

		Local lnWidth As Number, ;
			loErr As Object

		* Local lcStr as string
		* Do Case
		*   Case tcTipo = T_CHARACTER
		*       lcStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		*   Case tcTipo = T_NUMERIC
		*       lcStr = "0123456789"
		*   Case tcTipo = T_DATE
		*       lcStr = "99/99/9999"
		* Endcase

		Try

			If Empty ( m.tcFontName )
				tcFontName = _Screen.FontName

			Endif && Empty( m.tcFontName )

			If Empty ( m.tcFontSize )
				tcFontSize = _Screen.FontSize

			Endif && Empty( m.tcFontSize )

			If Empty ( m.tcFontStyle )
				tcFontStyle = Wfont ( 3, _Screen.Name )

			Endif && Empty( m.tcFontStyle )

			If Empty ( m.tnLen )
				tnLen = 1

			Endif && EMPTY( m.tnLen )

			lnWidth = Fontmetric ( TM_AVECHARWIDTH, m.tcFontName, m.tcFontSize, m.tcFontStyle ) * m.tnLen

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcTipo, tnLen, tcFontName, tcFontSize, tcFontStyle
			THROW_EXCEPTION

		Endtry

		Return m.lnWidth

	Endfunc && StringWidth

	* StringZero
	* Devuelve una cadena rellenad con ceros en los espacios en blanco
	Function StringZero ( tnNumero As Number, tnAncho As Number, tnDecimales As Number ) As String HelpString 'Devuelve una cadena rellenad con ceros en los espacios en blanco.'

		Local lcRet As String, ;
			loErr As Object
		Try

			If Empty ( m.tnAncho )
				tnAncho = 10

			Endif && Empty( m.tnAncho )

			If Empty ( m.tnDecimales )
				tnDecimales = 0

			Endif && Empty( m.tnDecimales )

			lcRet = Padl ( Alltrim ( Str ( m.tnNumero, m.tnAncho, m.tnDecimales ) ), m.tnAncho, '0' )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnNumero, tnAncho, tnDecimales
			THROW_EXCEPTION

		Endtry

		Return lcRet

	Endfunc && StringZero

	* StringZero2
	* Devuelve una cadena rellenad con ceros en los espacios en blanco.
	Function StringZero2 ( tnNumero As Number, tnAncho As Number, tnDecimales As Number ) As String HelpString  'Devuelve una cadena rellenad con ceros en los espacios en blanco.'

		Local lcFormatCode As String, ;
			lcRet As String, ;
			lnParteEntera As Number, ;
			loErr As Object

		Try

			If Empty ( m.tnAncho )
				tnAncho = 10

			Endif && Empty( m.tnAncho )

			If Empty ( tnDecimales )
				tnDecimales = 0

			Endif && Empty( tnDecimales )

			lnParteEntera = m.tnAncho - m.tnDecimales
			lcFormatCode  = '@L ' + Left ( Replicate ( '9', m.lnParteEntera ) + Iif ( m.tnDecimales > 0, '.' + Replicate ( '9', m.tnDecimales ), '' ), m.tnAncho )

			lcRet = Transform ( m.tnNumero, m.lcFormatCode )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnNumero, tnAncho, tnDecimales
			THROW_EXCEPTION

		Endtry

		Return lcRet

	Endfunc && StringZero2

	Function oSQL_Access() As SQLNameSpaces
		With m.This As StringNameSpace Of 'Tools\namespaces\prg\StringNameSpace.prg'
			If Vartype ( .oSQL ) # 'O'
				* .oSQL = Newobject( 'SQLNameSpace', 'Core\prg\SQLNameSpace.prg' )
				.oSQL = m.Sql

			Endif && Vartype( .oSQL ) # 'O'

		Endwith

		Return m.This.oSQL

	Endfunc && oSQL

	* IsNullOrEmpty
	* Devuelve True si la cadena esta vacia o es null.
	Function IsNullOrEmpty ( tcString As String ) As Boolean HelpString 'Devuelve True si la cadena esta vacia o es null.'

		Local lcRet As String, ;
			loErr As Object
		Try

			lcRet = Vartype ( m.tcString ) # 'C' Or ( Vartype ( m.tcString ) == 'C' And Empty ( m.tcString ) ) Or Isnull ( m.tcString )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcString
			THROW_EXCEPTION

		Endtry

		Return lcRet

	Endfunc && IsNullOrEmpty

	* IsIn
	* Devuelve la cantidad de veces que se encontro la palabra en la lista de palabras.
	Function IsIn ( tcWord As String, tcWordList As String, tcDelimiter As String ) As Integer HelpString 'Devuelve la cantidad de veces que se encontro la palabra en la lista de palabras.'
		*
		* Autor: Rubén O. Rovira
		* Fecha: 08/03/2004
		*
		* Parametros:
		*		1) tcWord		- Palabra a buscar
		*		2) tcWordList	- Lista de palabras
		*		3) tcDelimiter	- Delimitador de palabras (se usa COMA por default)
		*
		* Busca que la palabra tcWord exista con exactitud en la
		* lista de palabras tcWordList separadas tcDelimiter.
		*
		* Retorna el número de veces que se encontró tcWord dentro de tcWordList
		*

		Local lcDelimiter As String, ;
			liIdx As Integer, ;
			lnRetVal As Boolean, ;
			lnWords As Integer, ;
			loErr As Object

		Try

			lcDelimiter = IfEmpty ( tcDelimiter, [,] )
			lnWords     = Getwordcount ( tcWordList, lcDelimiter )
			lnRetVal    = 0

			For liIdx = 1 To m.lnWords
				If Alltrim ( m.tcWord ) == Alltrim ( Getwordnum ( m.tcWordList, m.liIdx, m.lcDelimiter ) )
					lnRetVal = m.lnRetVal + 1

				Endif && Alltrim ( m.tcWord ) == Alltrim ( Getwordnum ( m.tcWordList, m.liIdx, m.lcDelimiter ) )

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcWord, tcWordList, tcDelimiter
			THROW_EXCEPTION

		Endtry

		Return  lnRetVal

	Endfunc && IsIn

	* DigitoVerificador10
	* Devuelve el digito verificador para los codigos de barra - Código Entrelazado 2 de 5.
	Function DigitoVerificador10 ( tcSource As String ) As String HelpString 'Devuelve el digito verificador para los codigos de barra - Código Entrelazado 2 de 5.'

		Local lcChar As Character, ;
			lcDigitoVerificador As Character, ;
			liIdx As Integer, ;
			lnImpares As Integer, ;
			lnLen As Integer, ;
			lnMultiplo10 As Integer, ;
			lnPares As Integer, ;
			loErr As Exception

		#If .F.
			TEXT
				AFIP
				ANEXO I RESOLUCION GENERAL N°1702
				DATOS Y CARACTERISTICAS DEL SISTEMA DE IDENTIFICACION DE DATOS DENOMINADO "CODIGO DE BARRAS"

				será el "Código Entrelazado 2 de 5 ( Interleaved 2 of 5 ITF)"

				C) RUTINA PARA EL CALCULO DEL DIGITO VERIFICADOR
				La rutina de obtención del dígito verificador será la del módulo 10
				Se considera para efectuar el cálculo el siguiente ejemplo:
				01234567890

				Etapa 1: Comenzar desde la izquierda, sumar todos los caracteres ubicados en las
				posiciones impares.

				0 + 2 + 4 + 6 + 8 + 0 = 20

				Etapa 2: Multiplicar la suma obtenida en la etapa 1 por el número 3.

				20 x 3 = 60

				Etapa 3: Comenzar desde la izquierda, sumar todos los caracteres que están
				ubicados en las posiciones pares.

				1 + 3 + 5+ 7 + 9 = 25

				Etapa 4: Sumar los resultados obtenidos en las etapas 2 y 3.

				60 + 25 = 85

				Etapa 5: Buscar el menor número que sumado al resultado obtenido en la etapa
				4 dé un número múltiplo de 10. Este será el valor del dígito verificador del módulo 10.

				85 + 5 = 90

				De esta manera se llega a que el número 5 es el dígito verificador módulo 10 para el
				código 01234567890

				Siendo el resultado final:
				012345678905

			ENDTEXT

		#Endif

		Try

			tcSource  = Alltrim ( m.tcSource )
			lnLen     = Len ( tcSource )
			lnImpares = 0
			lnPares   = 0

			* Suman las cifras ubicadas en las posiciones pares y las ubicadas en las posiciones impares
			For liIdx = 1 To m.lnLen
				lcChar = Substr ( m.tcSource, m.liIdx, 1 )

				If m.Number.EsImpar ( m.liIdx )
					lnImpares = m.lnImpares + Val ( m.lcChar )

				Else
					lnPares = m.lnPares + Val ( m.lcChar )

				Endif && m.Number.EsImpar ( liIdx )

			Endfor

			lnPares = Int ( m.lnPares )

			* Las impares se multiplican por el numero 3
			lnImpares = Int ( m.lnImpares * 3 )

			* Se calcula el primer número multiplo de 10 superior a la suma de los valores obtenidos
			lnMultiplo10 = Ceiling ( ( m.lnPares + m.lnImpares ) / 10 ) * 10

			* La diferencia es el dígito verificador
			lcDigitoVerificador = Transform ( m.lnMultiplo10 - ( m.lnPares + m.lnImpares ))

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, m.tcSource
			THROW_EXCEPTION

		Endtry

		Return m.lcDigitoVerificador

	Endfunc && DigitoVerificador10

	* Hex2Int
	* Devuelve el valor entero del número expresado como Hex dado.
	Function Hex2Int ( tcHexa As String ) As Integer HelpString 'Devuelve el valor entero del número expresado como Hex dado.'

		Local lcChar As Character, ;
			lcHexa As String, ;
			liIdx As Integer, ;
			lnInt As Integer, ;
			lnLen As Integer, ;
			lnValue As Integer, ;
			loErr As Object

		Try

			lnInt = 0

			If Substr ( Lower ( tcHexa ), 1, 2 ) == '0x'
				lcHexa = Substr ( tcHexa, 3 )

			Else
				lcHexa = tcHexa

			Endif

			lnLen = Len ( lcHexa )

			For liIdx = lnLen To 1 Step - 1
				lcChar  = Substr ( lcHexa, liIdx, 1 )
				lnValue = Asc ( lcChar )

				Do Case
						* Case ( lnValue >= Asc("A") And lnValue <= Asc("F") )
					Case Between ( lnValue, m.This.nAUp, m.This.nFUp )
						* lnValue = lnValue - Asc("A") + 10
						lnValue = lnValue - m.This.nAUp + 10

						* Case ( lnValue >= Asc("a") .And. lnValue <= Asc("f") )
					Case Between ( lnValue, m.This.nALow, m.This.nFLow )
						* lnValue = lnValue - Asc("a") + 10
						lnValue = lnValue - m.This.nALow + 10

						* Case ( lnValue >= Asc("0") .And. lnValue <= Asc("9") )
					Case Between ( lnValue, m.This.n0, m.This.n9 )
						* lnValue = lnValue - Asc("0")
						lnValue = lnValue - m.This.n0

					Otherwise
						Error 'Valor Hexa con dígitos no válidos: 0x' + Transform ( tcHexa )

				Endcase

				lnInt = lnInt + lnValue * (16 ** ( lnLen - liIdx ))

			Next

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, m.tcHexa
			THROW_EXCEPTION

		Endtry

		Return Int ( lnInt )

	Endfunc

	* NoDelimiters
	* Devuelve la cadena sin los delimitadores.
	Function NoDelimiters ( tcValue As String ) As String HelpString 'Devuelve la cadena sin los delimitadores.'

		Local lcFirstChar As String, ;
			lcRet As String, ;
			loErr As Object

		Try

			If Vartype ( tcValue ) # 'C'
				tcValue = ''

			Endif && Vartype( tcValue ) # 'C'

			lcRet       = tcValue
			lcFirstChar = Substr ( tcValue, 1, 1 )
			If Inlist ( lcFirstChar, ['], ["], '[' ) And lcFirstChar == Right ( tcValue, 1 )
				lcRet = Substr ( tcValue, 2, Len ( tcValue ) - 2 )

			Endif && Inlist( lcFirstChar, ['], ["], '[' ) And lcFirstChar == Right( tcValue, 1 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, m.tcValue
			THROW_EXCEPTION

		Endtry

		Return lcRet

	Endfunc

	* ParseMemo
	Function ParseMemo ( tcText As String, tnChars As Integer, tlPreserveEmptyLines As Boolean ) As Collection


		Local laLines[1], ;
			liIdx As Integer, ;
			liJdx As Integer, ;
			lnCaseInsensitive As Integer, ;
			lnFlags As Integer, ;
			lnIncludeLast As Integer, ;
			lnIncludeParsingCharacters As Integer, ;
			lnLen As Integer, ;
			lnPreserveEmptyLines As Integer, ;
			lnTrim As Integer, ;
			loErr As Object, ;
			loLines As Collection, ;
			loString As Collection

		Try

			loLines                    = Createobject ( 'Collection' )
			lnTrim                     = 1
			lnIncludeLast              = 2
			lnPreserveEmptyLines       = 4
			lnCaseInsensitive          = 8
			lnIncludeParsingCharacters = 16

			If .F. && (Default) Removes leading and trailing spaces from lines, or for Varbinary and Blob values, removes trailing zeroes (0) instead of spaces.
				lnTrim = 0

			Endif

			If .T. && Include the last element in the array even if the element is empty.
				lnIncludeLast = 0

			Endif

			If tlPreserveEmptyLines
				lnPreserveEmptyLines = 0

			Endif

			If .T. && Specifies case-insensitive parsing.
				lnCaseInsensitive = 0

			Endif

			If .T. && Include the parsing characters in the array.
				lnIncludeParsingCharacters = 0

			Endif

			lnFlags = lnTrim + lnIncludeLast + lnPreserveEmptyLines + lnCaseInsensitive + lnIncludeParsingCharacters
			lnLen   = Alines ( laLines, tcText, lnFlags )

			For liIdx = 1 To lnLen
				loString = m.This.ParseString ( laLines[ liIdx ], tnChars )
				If ! Empty ( loString.Count )
					For liJdx = 1 To loString.Count
						loLines.Add ( loString.Item ( liJdx ))

					Endfor

				Else
					loLines.Add ( Space ( tnChars ) )

				Endif

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcText, tnChars, tlPreserveEmptyLines
			THROW_EXCEPTION

		Endtry

		Return loLines

	Endfunc && ParseMemo

	* ParseString
	Function ParseString ( tcText As String, tnChars As Integer ) As Collection

		Local lcLine As String, ;
			liIdx As Integer, ;
			lnFrom As Integer, ;
			lnWordCount As Integer, ;
			lnWordNum As Integer, ;
			loErr As Object, ;
			loLines As Collection

		Try

			loLines     = Createobject ( 'Collection' )
			lnFrom      = 0
			lnWordCount = Getwordcount ( tcText )
			lnWordNum   = 0
			lcLine      = ''

			Do While lnWordNum < lnWordCount

				lcLine = ''
				lnFrom = lnWordNum + 1

				Do While lnWordNum < lnWordCount And Len ( lcLine ) <= tnChars
					lnWordNum = lnWordNum + 1
					lcLine    = lcLine + Getwordnum ( tcText, lnWordNum ) + Space ( 1 )

				Enddo

				If Len ( lcLine ) > tnChars And lnFrom < lnWordNum
					lnWordNum = lnWordNum - 1
					lcLine    = ''
					For liIdx = lnFrom To lnWordNum
						lcLine = lcLine + Getwordnum ( tcText, liIdx ) + Space ( 1 )

					Endfor

				Endif

				loLines.Add ( lcLine )

			Enddo

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcText, tnChars
			THROW_EXCEPTION

		Endtry

		Return loLines

	Endfunc && ParseString

	* Printf
	Function Printf ( tcSource As String, tp0 As Variant, tp1 As Variant, tp2 As Variant, ;
			tp3 As Variant, tp4 As Variant, tp5 As Variant, tp6 As Variant, tp7 As Variant, ;
			tp8 As Variant, tp9 As Variant, tp10 As Variant, tp11 As Variant, tp12 As Variant, ;
			tp13 As Variant, tp14 As Variant, tp15 As Variant, tp16 As Variant, tp17 As Variant, ;
			tp18 As Variant, tp19 As Variant, tp20 As Variant, tp21 As Variant, tp22 As Variant, ;
			tp23 As Variant )

		* ? printf("Width=%d, Height=%4d, Alignment=%s", 100, 200, "Center")

		* %d, %i - integer
		* %u - unsigned decimal
		* %s - string
		* %x, %X - unsigned hex value

		* VFP Help: A maximum of 27 parameters can be passed from a calling program

		Local lcDecl As String, ;
			lcTarget As String, ;
			lcType As String, ;
			lnIndex As Number, ;
			lnResult As Number, ;
			loErr As Object, ;
			lvValue

		Try
			If .F.
				Declare Integer wnsprintf In Shlwapi ;
					String @lpOut, ;
					Integer cchLimitIn, ;
					String pszFmt, ;
					Integer
			Endif

			lcDecl = ''
			For lnIndex = 0 To 23
				* If lnIndex <= Parameters()-2
				If lnIndex <= Pcount() - 2
					lvValue = Eval ( 'tp' + Transform ( lnIndex ) )
					lcType  = Type ( 'lvValue' )
					Do Case
						Case lcType = 'C'
							lcDecl = lcDecl + ', STRING'

						Case lcType = 'N'
							lcDecl = lcDecl + ', INTEGER'

					Endcase
				Else
					lcDecl = lcDecl + ', INTEGER'

				Endif

			Endfor

			* every time this function has to be redeclared
			* according to the parameters passed to it
			lcDecl = 'DECLARE INTEGER wnsprintf IN Shlwapi STRING @lpOut, INTEGER cchLimitIn, STRING pszFmt' + lcDecl

			&lcDecl.

			lcTarget = Space ( 4096 )
			lnResult = wnsprintf ( @lcTarget, Len ( lcTarget ), tcSource, ;
				tp0, tp1, tp2, tp3, tp4, tp5, tp6, tp7, tp8, tp9, ;
				tp10, tp11, tp12, tp13, tp14, tp15, tp16, tp17, ;
				tp18, tp19, tp20, tp21, tp22, tp23 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcSource, tp0, tp1, tp2, tp3, tp4, tp5, tp6, tp7, tp8, tp9, tp10, tp11, tp12, tp13, tp14, tp15, tp16, tp17, tp18, tp19, tp20, tp21, tp22, tp23
			THROW_EXCEPTION

		Finally
			* Clear Dlls wnsprintf

		Endtry

		Return Left ( lcTarget, lnResult )

	Endfunc && Printf

	* StrFormat
	* Transformar la oracion en mayúscula o Minúscula
	Function StrFormat ( tcCadena As String, tnTipo As Number ) HelpString 'Transformar la oracion en mayúscula o Minúscula'

		Local lMAY, ;
			lcAux As String, ;
			lcChar As String, ;
			lcRetu As String, ;
			liIdx As Integer, ;
			lnLen As Number, ;
			lnTIPO As Number, ;
			loErr As Exception

		Note: Transformar la oracion en mayúscula o Minúscula
		* SINTAXIS: STRFORMAT(sSTRING,nTIPO)

		* sSTRING	Oraci¢n
		* nTIPO=1	Tipo oracion
		* nTIPO=2	min£sculas
		* nTIPO=3	MAYéSCULAS
		* nTIPO=4	Tipo T¡tulo
		* nTIPO=5	tIPO iNVERSO

		Try
			lcRetu   = tcCadena
			tcCadena = Default ( 'tcCadena', '' )
			lnTIPO   = Default ( 'tnTipo', 0 )
			lnLen    = Len (tcCadena)
			If lnTIPO > 5
				lnTIPO = 0

			Endif && lnTIPO > 5

			If ! Empty ( tcCadena )
				Do Case
					Case lnTIPO == 1 && Tipo oracion
						For liIdx = 1 To nLEN
							lcAux = Substr ( tcCadena, liIdx, 1 )
							If ! Empty ( lcAux )
								lcRetu = Space ( liIdx - 1 ) + Upper ( lcAux ) + Lower ( Substr ( tcCadena, liIdx + 1 ) )
								Exit

							Endif && ! Empty ( lcAux )

						Next

					Case lnTIPO == 2 && min£sculas
						lcRetu = Lower ( tcCadena )

					Case lnTIPO == 3 && MAYéSCULAS
						lcRetu = Upper ( tcCadena )

					Case lnTIPO == 4 && Tipo T¡tulo
						lcRetu = Proper ( tcCadena )

					Case lnTIPO == 5 && tIPO iNVERSO
						For liIdx = 1 To lnLen
							lcChar = Substr ( tcCadena, lnTIPO, 1 )
							If ! Empty ( lcChar )
								lMAY     = Islower ( lcChar )
								tcCadena = Stuff ( tcCadena, liIdx, 1, Iif ( lMAY, Upper ( lcChar ), Lower ( lcChar ) ) )

							Endif && ! Empty( lcChar )

						Next
						lcRetu = tcCadena

					Otherwise
						lcRetu = Upper ( Substr ( tcCadena, 1, 1 ) ) + Substr ( tcCadena, 2 )

				Endcase

			Endif && ! Empty( tcCadena )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCadena, tnTipo
			THROW_EXCEPTION

		Endtry

		Return lcRetu

	Endfunc

	* StrToI2Of5
	Function StrToI2Of5 ( tcCadena As String ) As String

		*------------------------------------------------------
		* FUNCTION _StrToI2of5(tcString) * INTERLEAVED 2 OF 5
		*------------------------------------------------------
		* Convierte un string para ser impreso con
		* fuente True Type "PF Interleaved 2 of 5"
		* ó "PF Interleaved 2 of 5 Wide"
		* ó "PF Interleavev 2 of 5 Text"
		* Solo caracteres numéricos
		* USO: _StrToI2of5('1234567890')
		* RETORNA: Caracter
		*------------------------------------------------------

		*!*	Fuente True Type			Archivo				Tamaño

		*!*	PF Interleaved 2 of 5		PF_I2OF5.ttf		36 ó 48
		*!*	PF Interleaved 2 of 5 Wide	PF_I2OF5_W.ttf		28 ó 36
		*!*	PF Interleavev 2 of 5 Text	PF_I2OF5_Text.ttf	28 ó 36

		Local lcCar As String, ;
			lcCheck As String, ;
			lcRet As String, ;
			lcStart As String, ;
			lcStop As String, ;
			lnAux As Number, ;
			lnCount As Number, ;
			lnI As Number, ;
			lnLong As Number, ;
			lnSum As Number, ;
			loErr As Exception

		Try

			lcStart = Chr(40)
			lcStop  = Chr(41)
			lcRet   = Alltrim ( tcCadena )
			*--- Genero dígito de control
			lnLong  = Len (lcRet)
			lnSum   = 0
			lnCount = 1

			For lnI = lnLong To 1 Step - 1
				lnSum   = lnSum + Val ( Substr ( lcRet, lnI, 1 ) ) * Iif ( Mod ( lnCount, 2 ) == 0, 1, 3 )
				lnCount = lnCount + 1

			Endfor

			lnAux  = Mod ( lnSum, 10 )
			lcRet  = lcRet + Alltrim ( Str ( Iif ( lnAux == 0, 0, 10 - lnAux ) ) )
			lnLong = Len (lcRet)
			*--- La longitud debe ser par
			If Mod ( lnLong, 2 ) # 0
				lcRet  = '0' + lcRet
				lnLong = Len ( lcRet )

			Endif
			*--- Convierto los pares a caracteres
			lcCar = ''
			For lnI = 1 To lnLong Step 2
				lnAux = Val ( Substr ( lcRet, lnI, 2 ) )
				If lnAux < 50
					lcCar = lcCar + Chr ( lnAux + 48 )

				Else && lnAux < 50
					lcCar = lcCar + Chr ( lnAux + 142 )

				Endif && lnAux < 50

			Endfor
			*--- Armo código
			lcRet = lcStart + lcCar + lcStop

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCadena
			THROW_EXCEPTION

		Endtry

		Return lcRet

	Endfunc && StrToI2Of5

	* ValidateCuit
	* Devuelve .T. si es valido el número de CUIT.
	Function ValidateCuit ( tcCuit As String, tnvacio As Number, tlMessage As Boolean ) As Boolean HelpString 'Devuelve .T. si es valido el número de CUIT.'
		***************************************************************
		*Function VALNCUIT.PRG***Valida Nro. de CUIT
		*  cCuit: Numero de cuit, caracter, en formato "99-99999999-9"
		*  mVacio:	0: Permite ingreso vacio
		*			1: Permite ingreso vacio, pero advierte que est  vacio
		*			2: No Permite ingreso vacio
		*  lMessage: .T. : Emite Mensaje
		*			 .F. : No emite mensage


		Local lOk As Object, ;
			lcCuit As String, ;
			lcFactor As String, ;
			lcMsg As String, ;
			lcNewCuit As String, ;
			llOk As Boolean, ;
			lnDigito As Number, ;
			lnResto As Number, ;
			lnSuma As Number, ;
			lnr As Number, ;
			loErr As Exception

		Try

			If Pcount() < 3
				tlMessage = .T.

			Endif && Pcount() < 3

			If Empty ( tnvacio  )
				tnvacio = 0

			Endif && Empty ( tnvacio  )

			lcCuit = Strtran ( tcCuit, '-', '' )
			tcCuit = Transform ( lcCuit, '@R 99-99999999-9' )

			tcCuit=Substr ( Alltrim ( tcCuit ) + Space ( 13 ), 1, 13 )

			Store 0 To lnSuma, lnr
			Store Space ( 13 ) To lcNewCuit
			Store .T. To llOk
			Store '54-32765432' To lcFactor
			For lnr = 1 To 11
				lnSuma = lnSuma + Val ( Subst ( lcFactor, lnr, 1 ) ) * Val ( Subst ( lcCuit, lnr, 1 ) )

			Next
			lnResto  = Mod ( lnSuma, 11 )
			lnDigito = Iif ( lnResto == 0, lnResto, 11 - lnResto )

			If Str ( lnDigito, 1 ) # Right ( lcCuit, 1 )
				Do Case
					Case Empty ( lcCuit ) Or lcCuit = '  -        - '
						Do Case
							Case lnVacio == 0
								llOk = .T.

							Case lnVacio == 1
								If tlMessage
									*!* nKey=S_ALERT('* Debe  cargar  un número de CUIT o CUIL *')
									*!* Keyb Chr(nKey)
									m.GUI.Warning ( 'Debe  cargar  un número de CUIT o CUIL.' )

								Endif && tlMessage
								llOk = .T.

							Case lnVacio == 2
								If tlMessage
									*!* nKey=S_ALERT('* Debe  cargar  un número de CUIT o CUIL *')
									*!* Keyb Chr(nKey)
									m.GUI.Warning ( 'Debe  cargar  un número de CUIT o CUIL' )

								Endif && tlMessage
								llOk = .F.

						Endcase

					Otherwise
						If lnDigito < 10
							lcNewCuit = Left ( lcCuit, 11 ) + '-' + Str ( lnDigito, 1 )

						Else && lnDigito < 10
							Do Case
								Case Left ( lcCuit, 2 ) == '20'
									lcNewCuit = '23-' + Substr ( lcCuit, 4, 8 ) + '-9'

								Case Left ( lcCuit, 2 ) == '27'
									lcNewCuit = '23-' + Substr ( lcCuit, 4, 8 ) + '-4'

								Case Left ( lcCuit, 2 ) == '30'
									lcNewCuit = '33-' + Substr ( lcCuit, 4, 8 ) + '-9'

							Endcase

						Endif && lnDigito < 10

						llOk = .F.
						If lMessage
							*!* nKey=S_ALERT('El Nº de CUIT/CUIL es incorrecto'+Iif(!Empty(cNewCuit),'; ** Nº probable '+cNewCuit+" **",''))
							TEXT To lcMsg Noshow Textmerge Pretext 03
								El Nº de CUIT/CUIL es incorrecto
								<<Iif(!Empty( lcNewCuit ),'** Nº probable '+ lcNewCuit +" **",'')>>
							ENDTEXT

							m.GUI.Warning ( lcMsg )

						Endif && lMessage

				Endcase

			Endif

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcCuit, tnvacio, tlMessage
			THROW_EXCEPTION

		Endtry

		Return llOk

	Endfunc && ValidateCuit

Enddefine && StringNameSpace