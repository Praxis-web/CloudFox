Text To lcCode NoShow
lcMessage = "~"
<<lcSpace>>luExpression = 
	
<<lcSpace>>This.AssertNotNull(lcMessage,;
<<lcSpace>>				luExpression)

EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And lower( ABBREV ) == '_tnn'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA) Values ( 'U', '_tnn', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
