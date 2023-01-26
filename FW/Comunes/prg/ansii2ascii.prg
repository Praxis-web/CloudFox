Lparameters tcString As String, tlInversa As Boolean

#Define _Ascii 	1
#Define _ANSI 	2

Local lcSearchExpresion As String, lcReplacementExpression As String
Local lnLen As Integer
Local i As Integer
Local lcReturn As String

lnLen = 36

Local Array laAnsi2Ascii[ lnLen, 2 ]

Try

	If Empty( tlInversa )
		tlInversa = .F.
	Endif

	If Empty( tcString )
		tcString = ""
	Endif

	lcReturn = ""

	laAnsi2Ascii[ 01, _ANSI ] = Chr( 225 )
	laAnsi2Ascii[ 01, _Ascii  ] = Chr( 160 )		&& �

	laAnsi2Ascii[ 02, _ANSI ] = Chr( 233 )
	laAnsi2Ascii[ 02, _Ascii  ] = Chr( 130 )		&& �

	laAnsi2Ascii[ 03, _ANSI ] = Chr( 237 )
	laAnsi2Ascii[ 03, _Ascii  ] = Chr( 161 )		&& �

	laAnsi2Ascii[ 04, _ANSI ] = Chr( 243 )
	laAnsi2Ascii[ 04, _Ascii  ] = Chr( 162 )		&& �

	laAnsi2Ascii[ 05, _ANSI ] = Chr( 250 )
	laAnsi2Ascii[ 05, _Ascii  ] = Chr( 163 )		&& �

	*----------------------------------------------------

	laAnsi2Ascii[ 06, _ANSI ] = Chr( 228 )
	laAnsi2Ascii[ 06, _Ascii  ] = Chr( 132 )		&& �

	laAnsi2Ascii[ 07, _ANSI ] = Chr( 235 )
	laAnsi2Ascii[ 07, _Ascii  ] = Chr( 137 )		&& �

	laAnsi2Ascii[ 08, _ANSI ] = Chr( 239 )
	laAnsi2Ascii[ 08, _Ascii  ] = Chr( 139 )		&& �

	laAnsi2Ascii[ 09, _ANSI ] = Chr( 246 )
	laAnsi2Ascii[ 09, _Ascii  ] = Chr( 148 )		&& �

	laAnsi2Ascii[ 10, _ANSI ] = Chr( 252 )
	laAnsi2Ascii[ 10, _Ascii  ] = Chr( 129 )		&& �


	*-----------------------------------------------

	laAnsi2Ascii[ 11, _ANSI ] = Chr( 193 )
	laAnsi2Ascii[ 11, _Ascii  ] = Chr( 181 )		&& �

	laAnsi2Ascii[ 12, _ANSI ] = Chr( 201 )
	laAnsi2Ascii[ 12, _Ascii  ] = Chr( 141 )		&& �

	laAnsi2Ascii[ 13, _ANSI ] = Chr( 205 )
	laAnsi2Ascii[ 13, _Ascii  ] = Chr( 214 )		&& �

	laAnsi2Ascii[ 14, _ANSI ] = Chr( 211 )
	laAnsi2Ascii[ 14, _Ascii  ] = Chr( 224 )		&& �

	laAnsi2Ascii[ 15, _ANSI ] = Chr( 218 )
	laAnsi2Ascii[ 15, _Ascii  ] = Chr( 233 )		&& �

	*----------------------------------------------------

	laAnsi2Ascii[ 16, _ANSI ] = Chr( 224 )
	laAnsi2Ascii[ 16, _Ascii  ] = Chr( 133 )		&& �

	laAnsi2Ascii[ 17, _ANSI ] = Chr( 232 )
	laAnsi2Ascii[ 17, _Ascii  ] = Chr( 138 )		&& �

	laAnsi2Ascii[ 18, _ANSI ] = Chr( 236 )
	laAnsi2Ascii[ 18, _Ascii  ] = Chr( 141 )		&& �

	laAnsi2Ascii[ 19, _ANSI ] = Chr( 242 )
	laAnsi2Ascii[ 19, _Ascii  ] = Chr( 149 )		&& �

	laAnsi2Ascii[ 20, _ANSI ] = Chr( 249 )
	laAnsi2Ascii[ 20, _Ascii  ] = Chr( 151 )		&& �

	*-----------------------------------------------

	laAnsi2Ascii[ 21, _ANSI ] = Chr( 196 )
	laAnsi2Ascii[ 21, _Ascii  ] = Chr( 142 )		&& �

	laAnsi2Ascii[ 22, _ANSI ] = Chr( 203 )
	laAnsi2Ascii[ 22, _Ascii  ] = Chr( 211 )		&& �

	laAnsi2Ascii[ 23, _ANSI ] = Chr( 207 )
	laAnsi2Ascii[ 23, _Ascii  ] = Chr( 216 )		&& �

	laAnsi2Ascii[ 24, _ANSI ] = Chr( 214 )
	laAnsi2Ascii[ 24, _Ascii  ] = Chr( 153 )		&& �

	laAnsi2Ascii[ 25, _ANSI ] = Chr( 220 )
	laAnsi2Ascii[ 25, _Ascii  ] = Chr( 154 )		&& �

	*----------------------------------------------------

	laAnsi2Ascii[ 26, _ANSI ] = Chr( 192 )
	laAnsi2Ascii[ 26, _Ascii  ] = Chr( 183 )		&& �

	laAnsi2Ascii[ 27, _ANSI ] = Chr( 200 )
	laAnsi2Ascii[ 27, _Ascii  ] = Chr( 212 )		&& �

	laAnsi2Ascii[ 28, _ANSI ] = Chr( 204 )
	laAnsi2Ascii[ 28, _Ascii  ] = Chr( 222 )		&& �

	laAnsi2Ascii[ 29, _ANSI ] = Chr( 210 )
	laAnsi2Ascii[ 29, _Ascii  ] = Chr( 227 )		&& �

	laAnsi2Ascii[ 30, _ANSI ] = Chr( 217 )
	laAnsi2Ascii[ 30, _Ascii  ] = Chr( 235 )		&& �

	*--------------------------------------------------

	laAnsi2Ascii[ 31, _ANSI ] = Chr( 241 )
	laAnsi2Ascii[ 31, _Ascii  ] = Chr( 164 )		&& �

	laAnsi2Ascii[ 32, _ANSI ] = Chr( 209 )
	laAnsi2Ascii[ 32, _Ascii  ] = Chr( 165 )		&& �

	laAnsi2Ascii[ 33, _ANSI ] = Chr( 186 )
	laAnsi2Ascii[ 33, _Ascii  ] = Chr( 167 )		&& �

	*--------------------------------------------------

	laAnsi2Ascii[ 34, _ANSI ] = Chr( 189 )
	laAnsi2Ascii[ 34, _Ascii  ] = Chr( 171 )		&& �

	laAnsi2Ascii[ 35, _ANSI ] = Chr( 188 )
	laAnsi2Ascii[ 35, _Ascii  ] = Chr( 172 )		&& �

	laAnsi2Ascii[ 36, _ANSI ] = Chr( 190 )
	laAnsi2Ascii[ 36, _Ascii  ] = Chr( 243 )		&& �





	lcSearchExpresion = ""
	lcReplacementExpression = ""

	For i = 1 To lnLen
		lcSearchExpresion 		= lcSearchExpresion 		+ laAnsi2Ascii[ i, _ANSI  ]
		lcReplacementExpression = lcReplacementExpression 	+ laAnsi2Ascii[ i, _Ascii ]
	Endfor

	If tlInversa  
		lcReturn = Chrtran( tcString, lcReplacementExpression, lcSearchExpresion )
		
	Else
		lcReturn = Chrtran( tcString, lcSearchExpresion, lcReplacementExpression )

	EndIf
	

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )


Finally

Endtry

Return lcReturn