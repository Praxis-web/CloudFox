Text To lcCode NoShow
#INCLUDE "Clientes\Valores\Include\valores.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INVA'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INVA', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
