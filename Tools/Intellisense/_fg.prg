Lparameters oFoxcode

If oFoxcode.Location #1
	Return "_FG"
Endif

oFoxcode.valuetype = "V"


LOCAL lcLine, lcSpace, lnPos, lcCase, lcData
lcLine = oFoxcode.FullLine
IF oFoxcode.Location=0 OR GETWORDCOUNT(lcLine)#1
   RETURN oFoxcode.UserTyped
ENDIF
lnPos = ATC(ALLTRIM(oFoxcode.Abbrev),lcLine)
lcSpace = SUBSTR(lcLine,1,lnPos-1)

Local lcClippText As String,;
	lcCommand As String

Local lcWord1 As String,;
	lcWord2 As String,;
	lcWord3 As String,;
	lcWord4 As String

Local lcVariable As String,;
	lcValid As String,;
	lcRow As String,;
	lcCol As String
	
Local lnLen As Integer

lcClippText = _Cliptext

If !Empty( At( "F_GET", Upper( lcClippText )))
	lcWord1 = Getwordnum( lcClippText, 1, "," )
	lcWord2 = Getwordnum( lcClippText, 2, "," )
	lcWord3 = Getwordnum( lcClippText, 3, "," )
	lcWord4 = Getwordnum( lcClippText, 4, "," )

	lcVariable = Substr( lcWord1, 7 )

	If Substr( Alltrim( lcVariable ), 1, 1 ) = "@"
		lcVariable = Substr( Alltrim( lcVariable ), 2 )
	Endif

	lcRow = StrZero( Val( lcWord2 ), 2 )
	lcCol = StrZero( Val( lcWord3 ), 2 )

	lnLen = At( lcWord4, lcClippText )
	lcValid = Alltrim( Substr( lcClippText, lnLen ))
	lnLen = Len( lcValid )

	If !Empty( lnLen )
		* Eliminar el ")" final
		lcValid = Alltrim( Substr( lcValid, 2, lnLen - 2 ))
		
		* Eliminar el ["] final
		lnLen = Len( lcValid )
		lcValid = Alltrim( Substr( lcValid, 1, lnLen - 1 ))
		
		lcValid = "Valid " + lcValid
	EndIf
	
TEXT TO lcCommand TEXTMERGE NOSHOW

<<lcSpace>>S_Line24(ACL6)
<<lcSpace>>@ <<lcRow>>, <<lcCol>> Get <<lcVariable>> Picture "@D" <<lcValid>>
<<lcSpace>>Read
<<lcSpace>>SayMask( <<lcRow>>, <<lcCol>>, <<lcVariable>>, "@D" )

ENDTEXT

Else
	lcCommand = ""
	
Endif

Return lcCommand