Local lcCode As String
TEXT To lcCode NoShow
	Lparameter oFoxcode As Object

	Local lcLine As String
	Local lcSpace As String
	Local lnPos As Number
	Local lcCase As String
	Local lcData As String
	Local lcRet as String
	Private poFoxcode as Object
	
	poFoxcode = oFoxcode
	lcLine = oFoxcode.FullLine
	If oFoxcode.Location = 0 Or Getwordcount( lcLine ) # 1
	    Return oFoxcode.UserTyped
	Endif
	lnPos = Atc( Alltrim( oFoxcode.Abbrev ), lcLine )
	lcSpace = Substr( lcLine, 1, lnPos - 1 )
	oFoxcode.valuetype = 'V'

	* Get case
	lcCase = oFoxcode.Case
	If Empty( Alltrim( lcCase ) )
	    lcCase = oFoxcode.DefaultCase
	    If Empty( Alltrim( lcCase ) )
	        lcCase = 'M'
	    Endif
	Endif

	* Process and return expanded control statement
	lcData = AdjustCase( oFoxcode.Data, lcCase )
	lcRet = Textmerge( lcData )
	poFoxcode = Null
	Return lcRet
	
	
	Procedure AdjustCase( cItem, cCase )
	    * Adjusts case of keyword expanded to that specified in the _Foxcode script.
	    * Use Version record default if empty
	    Do Case
	        Case Upper( m.cCase ) = 'U'
	            Return Upper( m.cItem )
	        Case Upper( m.cCase ) = 'L'
	            Return Lower( m.cItem )
	        Case Upper( m.cCase ) = 'P'
	            Return Proper( m.cItem )
	        Otherwise
	            Return m.cItem
	    Endcase
	Endproc
ENDTEXT

Delete From (_Foxcode) Where Type = 'S' And ABBREV = 'stmthandler'
Insert Into (_Foxcode) (Type, ABBREV, Data)  Values ('S', 'stmthandler', lcCode )
