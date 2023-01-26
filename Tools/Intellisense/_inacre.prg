Text To lcCode NoShow
#INCLUDE "Clientes\Acreedores\Include\Acreedores.h"
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where TYPE = 'U' And ABBREV == '_INACRE'
insert into UdpFoxCode (TYPE, ABBREV, cmd, DATA)  Values ( 'U', '_INACRE', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )