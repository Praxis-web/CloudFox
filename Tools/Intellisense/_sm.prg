Local lcCode As String
TEXT To lcCode NoShow
Lparameters oFoxcode

Local lnCol as Integer 
Local lcStrFile	As String
Local lcCommand as String
Local lcRow as String,;
	lcCol as String,;
	lcVar As String,;
	lcPicture As String

Local lnFrom as Integer,;
	lnTo as Integer
Local lcClippText as String 	

Try

	oFoxcode.valuetype = "V"

	lnCol = oFoxcode.Location
	
	lcCommand = "_SM"
	
	lcClippText = _Cliptext
	
	If !Empty( At( "@", lcClippText )) And !Empty( At( "GET", Upper( lcClippText )))
		lcStrFile 	= lcClippText 
		
	Else
		lcStrFile 	= Inputbox( "Comando @ GET", "SayMask() ..." ) 

	EndIf 

	lcStrFile = Strtran( lcStrFile, " PICT ", " Picture ", 1, 1, 3 )
	lcStrFile = Strtran( lcStrFile, " PICTU ", " Picture ", 1, 1, 3 )
	lcStrFile = Strtran( lcStrFile, " PICTUR ", " Picture ", 1, 1, 3 )
	
	lcRow = GetWordNum( lcStrFile, 2, " ," )
	lcCol = GetWordNum( lcStrFile, 3, " ," )
	lcVar = GetWordNum( lcStrFile, 5, " ," )
	
	lnFrom = At( "PICTURE", Upper( lcStrFile ))  
	
	lcPicture = GetWordNum( Substr( lcStrFile, lnFrom ), 2, ["'] )
	If Substr( lcPicture, 1, 2 ) = "@S"
		lcPicture = [Replicate( "X", ] + Substr( lcPicture, 3 ) + " )" 
		
	Else
		lcPicture = ["] + lcPicture + ["] 
		
	EndIf
	

	lcCommand = "SayMask( " + lcRow + ", " + lcCol + ', ' + lcVar + ", " +  lcPicture + ", 0 )"

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError

Finally
	_Cliptext = ""

Endtry

Return lcCommand
Endtext
Use (_Foxcode) In 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And ABBREV == '_SM'
Insert Into UdpFoxCode ( Type, ABBREV, cmd, Data ) ;
	Values ( 'U', '_SM', '{}', lcCode )
Use In Select( 'UdpFoxCode' )
