Text To lcCode NoShow
#INCLUDE "ERP\Comunes\Sistema\Include\Sistema.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INSA'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INSA', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
