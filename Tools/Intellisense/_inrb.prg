Text To lcCode NoShow
#INCLUDE "Tools\ReportBuilder\Include\oOReportBuilder.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INRB'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INRB', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
