Local lcCode As String
TEXT To lcCode NoShow
Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
<<lcSpace>>loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
<<lcSpace>>loError.cRemark = lcCommand
<<lcSpace>>loError.Process( oErr )
<<lcSpace>>Throw loError

EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And ABBREV == '_EH'
Insert Into UdpFoxCode ( Type, ABBREV, cmd, Data ) ;
    Values ( 'U', '_EH', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
