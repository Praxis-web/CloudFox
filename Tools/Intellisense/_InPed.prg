Text To lcCode NoShow
#INCLUDE "Clientes\Pedidos\Include\Pedidos.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INPED'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INPED', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
