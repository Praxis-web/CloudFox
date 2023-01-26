Text To lcCode NoShow
#INCLUDE "Clientes\Ventas\Include\Comprobantes.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INCOMPRO'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INCOMPRO', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
