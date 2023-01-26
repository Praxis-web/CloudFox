Text To lcCode NoShow
#INCLUDE "Clipper\clContabilidad\Include\Contab.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INCLCO'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INCLCO', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
