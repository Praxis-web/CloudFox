Text To lcCode NoShow
Local loDataTier As PrxDataTier Of "Fw\Tieradapter\Comun\Prxdatatier.prg"
<<lcSpace>>loDataTier = NewDT()
<<lcSpace>>~
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And lower( ABBREV ) == '_NewDT'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA) Values ( 'U', '_newdt', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
