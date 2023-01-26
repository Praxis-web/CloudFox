Local lcCode As String
TEXT To lcCode NoShow
Local lcCommand as String

<<lcSpace>>Try

<<lcSpace>>	lcCommand = ""~

<<lcSpace>>Catch To loErr
<<lcSpace>>	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
<<lcSpace>>	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
<<lcSpace>>	loError.cRemark = lcCommand
<<lcSpace>>	loError.Process ( m.loErr )
<<lcSpace>>	Throw loError

<<lcSpace>>Finally
<<lcSpace>>
<<lcSpace>>
<<lcSpace>>EndTry
ENDTEXT
Use (_Foxcode) In 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And ABBREV == '_TRY'
Insert Into UdpFoxCode ( Type, ABBREV, cmd, Data ) ;
	Values ( 'U', '_TRY', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )