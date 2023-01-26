Local lcCode As String
TEXT To lcCode NoShow
    <<lcSpace>>Error 1740 && is a read-only property 
ENDTEXT
Delete From (_Foxcode) Where Type = 'U' And ABBREV = '_PRRO'
Insert Into (_Foxcode) ( Type, ABBREV, cmd, Data ) ;
    Values ( 'U', '_PRRO', '{stmthandler}', lcCode )
