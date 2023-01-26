Text To lcCode NoShow
#INCLUDE "ERP\Compras\Include\Compras.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INCOMP'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INCOMP', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
