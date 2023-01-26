Text To lcCode NoShow
#INCLUDE "FW\Comunes\Include\Globales.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INGL'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INGL', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )