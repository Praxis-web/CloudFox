Local lcCode As String
TEXT To lcCode NoShow
<<lcSpace>>Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
Try
<<lcSpace>>	loError = ThisForm.oError
<<lcSpace>>	loError.Remark = ''
<<lcSpace>>	loError.TraceLogin = ''
<<lcSpace>>
<<lcSpace>>	~
<<lcSpace>>
<<lcSpace>>Catch To oErr
<<lcSpace>>	loError = ThisForm.oError
<<lcSpace>>	ThisForm.cXMLoError = loError.Process( oErr )
<<lcSpace>>	Throw loError
<<lcSpace>>
<<lcSpace>>Finally
<<lcSpace>>	loError = ThisForm.oError
<<lcSpace>>	loError.Remark = ''
<<lcSpace>>	loError.TraceLogin = ''
<<lcSpace>>	loError = Null   
<<lcSpace>>
<<lcSpace>>EndTry
ENDTEXT
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And ABBREV == '_TRYF'
Insert Into UdpFoxCode ( Type, ABBREV, cmd, Data ) ;
    Values ( 'U', '_TRYF', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )