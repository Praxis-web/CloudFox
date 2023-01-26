Lparameters cExpression As String

Local lnLen As Integer
Local lAntrIsUpper As Boolean
Local lcExpression As String
Local lcRet As String
cExpression = ifEmpty( cExpression, '' )
lnLen = Len( cExpression )
cExpression = Chrtran( cExpression, '_', Space( 1 ) )
lcExpression = ''
For i = 1 To lnLen
    lcLetter = Substr( cExpression, i, 1 )
    lIsUpper = Isupper( lcLetter )
    If i > 1 And lIsUpper And ! lAntrIsUpper
        lcExpression = lcExpression + Space( 1 ) + lcLetter
    Else
        lcExpression = lcExpression + lcLetter
    Endif
    lAntrIsUpper = lIsUpper
Next
lcRet = Strtran( ProperCase( lcExpression ), Space( 2 ), Space( 1 ) )
Return lcRet
