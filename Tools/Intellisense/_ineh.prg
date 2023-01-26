Text To lcCode NoShow
#INCLUDE "FW\ErrorHandler\EH.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INEH'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INEH', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
