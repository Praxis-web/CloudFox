Text To lcCode NoShow
#INCLUDE "ERP\Ventas\Include\Ventas.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INVE'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INVE', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
