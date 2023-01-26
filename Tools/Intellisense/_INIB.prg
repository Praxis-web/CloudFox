Text To lcCode NoShow
#INCLUDE "Clientes\IIBB\Include\iibb.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INIB'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INIB', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
