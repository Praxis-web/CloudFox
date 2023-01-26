Text To lcCode NoShow
Local loXA As xmlAdapterBase Of 'Tools\NameSpaces\Prg\xmlAdapterBase.prg'
<<lcSpace>>m.loXA = _Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And lower( ABBREV ) == '_xa'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA) Values ( 'U', '_xa', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
