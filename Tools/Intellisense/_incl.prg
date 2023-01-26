Text To lcCode NoShow
#INCLUDE "Clipper\clComunes\Include\Clipper.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INCL'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INCL', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
