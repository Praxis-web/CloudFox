TEXT To lcCode NoShow
lcMessage = "~"
<<lcSpace>>luExpectedValue =
<<lcSpace>>luExpression =
<<lcSpace>>llNonCaseSensitive = .T.

<<lcSpace>>This.AssertNotEquals( lcMessage,;
<<lcSpace>>				luExpectedValue,;
<<lcSpace>>				luExpression,;
<<lcSpace>>				llNonCaseSensitive )

ENDTEXT
Use ( _Foxcode ) In 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And Lower( ABBREV ) == '_tne'
Insert Into UdpFoxCode ( Type, ABBREV, cmd, Data ) Values ( 'U', '_tne', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
