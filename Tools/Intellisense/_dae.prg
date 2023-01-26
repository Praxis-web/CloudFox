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
	lnPos = Atc( Alltrim( oFoxcode.Abbrev ), lcLine )
	lcSpace = Substr( lcLine, 1, lnPos - 1 )
	oFoxcode.valuetype = 'V'
    lcCentury =  Set( 'Century' )
    Set Century On
    lcRet = lcSpace + '* DAE ' + Transform( Year( Date() ) ) + '-' + Transform( Month( Date() ) , '@L 99' ) + '-' +  Transform( Day( Date() ) , '@L 99') + '(' + Time() + ')'

	lcCommand =  'Set Century ' + lcCentury
	&lcCommand

	Return lcRet
ENDTEXT

*!*	Delete From (_Foxcode) Where Type = 'U' And ABBREV = '_DAE'
*!*	Insert Into (_Foxcode) ( Type, ABBREV, Data )  Values ( 'U', '_DAE', lcCode )
Use In Select( 'UdpFoxCode' )
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And ABBREV = '_dae'
insert into UdpFoxCode ( Type, ABBREV, cmd, Data )  Values ( 'U', '_dae', '{}', lcCode )
Use In Select( 'UdpFoxCode' )
