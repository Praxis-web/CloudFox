Text To lcCode NoShow
#INCLUDE "Tools\FE\Include\FE.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INFE'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INFE', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
