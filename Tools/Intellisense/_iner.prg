Text To lcCode NoShow
#INCLUDE "ERP\Comunes\Include\Erp.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INER'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INER', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
