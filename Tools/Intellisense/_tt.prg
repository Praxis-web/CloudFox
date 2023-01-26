Text To lcCode NoShow
lcMessage = "~"
<<lcSpace>>luExpression = 
	
<<lcSpace>>This.AssertTrue(lcMessage,;
<<lcSpace>>				luExpression)


EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And lower( ABBREV ) == '_tt'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA) Values ( 'U', '_tt', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
