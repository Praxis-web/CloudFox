Text To lcCode NoShow
#INCLUDE "Clientes\Stock\Include\Stock.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INST'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INST', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
