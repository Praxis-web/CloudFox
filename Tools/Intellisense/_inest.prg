Text To lcCode NoShow
#INCLUDE "Clientes\Estadisticas\Include\Estadisticas.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INEST'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INEST', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
