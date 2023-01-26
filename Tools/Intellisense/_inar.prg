Text To lcCode NoShow
#INCLUDE "ERP\ArchivosYTablas\Include\Archivos.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INAR'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INAR', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
