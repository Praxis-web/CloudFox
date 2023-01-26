Text To lcCode NoShow
#INCLUDE "FW\TierAdapter\Include\TA.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INTA'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INTA', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
