*---------------------------------------------------------------------------*
* NAME: REPORTFILTER                                                        *
*---------------------------------------------------------------------------*
*                                                                           *
* Set and get the values selected in a filter control container.            *
*                                                                           *
*---------------------------------------------------------------------------*
* PARAMETERS:                                                               *
* ===========                                                               *
*  tnArrayPos: Array position to evaluate.                                  *
* tcCondition: Evaluated condicion (=,<>,<,>,etc)                           *
*      tuFrom: From value, the lower or only value                          *
*     tuUntil: Until value, the higher values if filter include a between.  *
*---------------------------------------------------------------------------*
*   Created: 18/11/2003                                                     *
* Last.Upd.: 02/06/2004                                                     *
*---------------------------------------------------------------------------*

Lparameters tnArrayPos As Integer	,;
	tcCondition As String	,;
	tuFrom As String		,;
	tuUntil As String

Local lcReturn As String	,;
	lcString As String
lcReturn = ""
lcString = ""

If Vartype( gaFilterReport ) = "U"
	Public Array gaFilterReport[ 100 ]
Endif

Do Case
	Case Pcount() = 0
		gaFilterReport = ""
	Case Pcount() = 1
		If Empty( tnArrayPos )
			lcReturn = gaFilterReport[ 1 ]
		Else
			lcReturn = gaFilterReport[ tnArrayPos ]
			If Empty( lcReturn )
				lcReturn = "Todos"
			Endif
		Endif
	Otherwise
		lcString = ""
		Do Case
			Case tcCondition = "E"
				lcString = This.GetLanguageWord( "#MSG_IsBetween" ) + Alltrim( This.XtoS( tuFrom ) ) + " y " + Alltrim( This.XtoS( tuUntil ) )
			Case tcCondition = "like"
				lcString = This.GetLanguageWord( "#MSG_BeginWith" ) + Alltrim( This.XtoS( tuFrom ) )
			Case tcCondition = "%"
				lcString = This.GetLanguageWord( "#MSG_ContainTheText" ) + Alltrim( This.XtoS( tuFrom ) )
			Otherwise
				lcString = "es "
				Do Case
					Case tcCondition == "="
						lcString = lcString + This.GetLanguageWord( "#MSG_Equal" )
					Case tcCondition == "<"
						lcString = lcString + This.GetLanguageWord( "#MSG_Lower" )
					Case tcCondition == "<="
						lcString = lcString + This.GetLanguageWord( "#MSG_LowerEqual" )
					Case tcCondition == ">"
						lcString = lcString + This.GetLanguageWord( "#MSG_Upper" )
					Case tcCondition == ">="
						lcString = lcString + This.GetLanguageWord( "#MSG_UpperEqual" )
					Case tcCondition == "<>"
						lcString = lcString + This.GetLanguageWord( "#MSG_Different" )
				Endcase
				lcString = lcString + " a " + Alltrim( This.XtoS( tuFrom ) )
		Endcase

		For niCount = 1 To 100
			If Empty( gaFilterReport[ niCount ] )
				gaFilterReport[ niCount ] = lcString
				Exit
			Endif
		Next
Endcase

Return ( lcReturn )
