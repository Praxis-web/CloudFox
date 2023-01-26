Text To lcCode NoShow
<<lcSpace>>If Used( lcAlias )
<<lcSpace>><<lcSpace>>Select Alias( lcAlias )

<<lcSpace>>EndIf && Used( lcAlias )
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And Lower( ABBREV ) == 'ifua'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', 'ifua', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
