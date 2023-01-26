Text To lcCode NoShow
Local loMyCA As CursorAdapterBase Of 'Tools\NameSpaces\Prg\CursorAdapterBase.prg'
<<lcSpace>>loMyCA = _NewObject("CursorAdapterBase",; 
<<lcSpace>><<lcSpace>>"Tools\NameSpaces\Prg\CursorAdapterBase.prg",;
<<lcSpace>><<lcSpace>>"",;
<<lcSpace>><<lcSpace>>This.cAccessType,;
<<lcSpace>><<lcSpace>>This.oConnection,;
<<lcSpace>><<lcSpace>>This.cBackEndEngine )
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And lower( ABBREV ) == '_ca'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA) Values ( 'U', '_ca', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
