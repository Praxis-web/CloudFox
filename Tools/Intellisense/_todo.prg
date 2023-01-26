Local lcCode As String
TEXT To lcCode NoShow
    Lparameter oFoxcode As Object

    Local lcLine As String
	Local lcSpace As String
	Local lnPos As Number
	Local lcRet as String

	lcLine = oFoxcode.FullLine
	If oFoxcode.Location = 0 Or Getwordcount( lcLine ) # 1
	    Return oFoxcode.UserTyped
	Endif
	oFoxcode.valuetype = 'V'
    lnPos = Atc( Alltrim( oFoxcode.Abbrev ), lcLine )
	lcSpace = Substr( lcLine, 1, lnPos - 1 )

    lcCentury =  Set( 'Century' )
    Set Century On
	lcUser = iif( vartype( _USER ) = 'C', _USER + ' ', '' )
    lcDesc = InputBox( 'Ingrese la descripción' )
    lcRet = lcSpace + '* @TODO ' + lcUser + Transform( Year( Date() ) ) + '-' + Transform( Month( Date() ) , '@L 99' ) + '-' +  Transform( Day( Date() ) , '@L 99') + ' (' + Time() + ') ' + lcDesc
    lcCommand = 'Set Century ' + lcCentury
    &lcCommand

    Return lcRet
ENDTEXT

Use (_Foxcode) In 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And ABBREV = '_todo'
Insert Into UdpFoxCode ( Type, ABBREV, Data, Cmd )  Values ( 'U', '_todo', lcCode, "{}" )
Use In Select( 'UdpFoxCode' )
