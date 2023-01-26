Local lcCode As String
TEXT To lcCode NoShow
	Lparameter oFoxcode As Object

    Try
    	oFoxcode.ValueType = 'V'
    	EnsureInclude()

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError

    Finally
	    loError = Null

    EndTry

    Return ''

ENDTEXT

Use (_Foxcode) In 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And Lower( ABBREV ) == '_ei'
Insert Into UdpFoxCode (Type, ABBREV, cmd, Data)  Values ( 'U', '_ei', '{}', lcCode )
Use In Select( 'UdpFoxCode' )
