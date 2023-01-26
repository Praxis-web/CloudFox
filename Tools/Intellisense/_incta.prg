*!*	LPARAMETERS oFoxcode

*!*	oFoxcode.valuetype = "V"

*!*	TEXT TO myvar TEXTMERGE NOSHOW
*!*	#INCLUDE "ERP\CuentasCorrientes\Include\CtaCte.h"
*!*	ENDTEXT

*!*	RETURN myvar


TEXT To lcCode NoShow
#INCLUDE "ERP\CuentasCorrientes\Include\CtaCte.h"
ENDTEXT
Use (_Foxcode) In 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And Upper( ABBREV ) == '_INCTA'
Insert Into UdpFoxCode (Type, ABBREV, cmd, Data)  Values ( 'U', '_INCTA', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
