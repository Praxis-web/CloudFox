Text To lcCode NoShow
#INCLUDE "Clientes\Contable\Include\Contable.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INCO'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INCO', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
