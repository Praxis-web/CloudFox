Use (_Foxcode) In 0 Shared Again Alias 'UdpFoxCode'

* TierAdapter
TEXT To lcCode NoShow
TierAdapter Of "FW\TierAdapter\Comun\TierAdapter.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'tieradapter' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* UserTierAdapter
TEXT To lcCode NoShow
UserTierAdapter OF "FW\TierAdapter\UserTier\UserTierAdapter.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'usertieradapter' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* utArchivo
TEXT To lcCode NoShow
utArchivo OF "FW\TierAdapter\UserTier\utArchivo.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'utarchivo' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )


* Servicetier
TEXT To lcCode NoShow
ServiceTier Of "Fw\Tieradapter\Servicetier\Servicetier.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'servicetier' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* stArchivo
TEXT To lcCode NoShow
stArchivo Of "Fw\Tieradapter\Servicetier\stArchivo.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'starchivo' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* GlobalSettings
TEXT To lcCode NoShow
GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'globalsettings' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* BizTierAdapter
TEXT To lcCode NoShow
BizTierAdapter Of "FW\Tieradapter\BizTier\BizTierAdapter.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'biztieradapter' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* btArchivo
TEXT To lcCode NoShow
btArchivo Of "FW\Tieradapter\BizTier\btArchivo.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'btarchivo' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* prxCollection
TEXT To lcCode NoShow
PrxCollection Of "Fw\TierAdapter\Comun\PrxBaseLibrary.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'prxcollection' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* PrxSession
TEXT To lcCode NoShow
PrxSession Of "Fw\TierAdapter\Comun\Prxbaselibrary.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'prxsession' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColBase
TEXT To lcCode NoShow
ColBase Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colbase' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* SessionBase
TEXT To lcCode NoShow
SessionBase Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'sessionbase' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColDataBases
TEXT To lcCode NoShow
ColDataBases Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'coldatabases' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oDataBase
TEXT To lcCode NoShow
oDataBase Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'odatabase' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColTables
TEXT To lcCode NoShow
ColTables Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'coltables' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oTable
TEXT To lcCode NoShow
oTable Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'otable' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColFields
TEXT To lcCode NoShow
ColFields Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colfields' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oField
TEXT To lcCode NoShow
oField Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'ofield' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColIndexes
TEXT To lcCode NoShow
ColIndexes Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colindexes' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oIndex
TEXT To lcCode NoShow
oIndex Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'oindex' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColTriggers
TEXT To lcCode NoShow
ColTriggers Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'coltriggers' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColUpdateTriggers
TEXT To lcCode NoShow
ColUpdateTriggers Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colupdatetriggers' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColInsertTriggers
TEXT To lcCode NoShow
ColInsertTriggers Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colinserttriggers' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColDeleteTriggers
TEXT To lcCode NoShow
ColDeleteTriggers Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'coldeletetriggers' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oTrigger
TEXT To lcCode NoShow
oTrigger Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'otrigger' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oUpdateTrigger
TEXT To lcCode NoShow
oUpdateTrigger Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'oupdatetrigger' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oInsertTrigger
TEXT To lcCode NoShow
oInsertTrigger Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'oinserttrigger' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oDeleteTrigger
TEXT To lcCode NoShow
oDeleteTrigger Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'odeletetrigger' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColProperties
TEXT To lcCode NoShow
ColProperties Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colproperties' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oProperty
TEXT To lcCode NoShow
oProperty Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'oproperty' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColStoreProcedures
TEXT To lcCode NoShow
ColStoreProcedures Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colstoreprocedures' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oStoreProcedure
TEXT To lcCode NoShow
oStoreProcedure Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'ostoreprocedure' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColForms
TEXT To lcCode NoShow
ColForms Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colforms' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oForm
TEXT To lcCode NoShow
oForm Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'oform' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColValidations
TEXT To lcCode NoShow
ColValidations Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colvalidations' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oValidationBase
TEXT To lcCode NoShow
oValidationBase Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'ovalidationbase' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColReports
TEXT To lcCode NoShow
ColReports Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colreports' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oReport
TEXT To lcCode NoShow
oReport Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'oreport' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColReportOrder
TEXT To lcCode NoShow
ColReportOrder Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colreportorder' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oReportOrder
TEXT To lcCode NoShow
oReportOrder Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'oreportorder' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColReportFilter
TEXT To lcCode NoShow
ColReportFilter Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colreportfilter' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oReportFilter
TEXT To lcCode NoShow
oReportFilter Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'oreportfilter' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColContainer
TEXT To lcCode NoShow
ColContainer Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colcontainer' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oContainer
TEXT To lcCode NoShow
oContainer Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'ocontainer' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ColControls
TEXT To lcCode NoShow
ColControls Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'colcontrols' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* oControl
TEXT To lcCode NoShow
oControl Of "Tools\Sincronizador\colDataBases.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'ocontrol' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

* ObjectFactory
TEXT To lcCode NoShow
ObjectFactory Of "Fw\TierAdapter\Comun\ObjectFactory.prg"
ENDTEXT

Delete From UdpFoxCode Where Type = 'T' And 'objectfactory' $ Lower( Data )
Insert Into UdpFoxCode (Type, Data)  Values ( 'T', lcCode )

Use In Select( 'UdpFoxCode' )
