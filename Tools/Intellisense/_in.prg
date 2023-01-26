Text To lcCode NoShow
#INCLUDE "FW\Comunes\Include\Praxis.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_IN'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_IN', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )