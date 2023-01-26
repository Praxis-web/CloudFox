Text To lcCode NoShow
#INCLUDE "ERP\Compras\Include\Compras.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INPR'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INPR', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
