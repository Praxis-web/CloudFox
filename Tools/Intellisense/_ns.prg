Local lcCode As String
TEXT To lcCode NoShow
#If .F.
<<lcSpace>>	Local Variant As VariantNameSpace Of 'Tools\Namespaces\Prg\VariantNameSpace.prg'
<<lcSpace>>	Local CacheManager As CacheManager Of 'Tools\Namespaces\Prg\CacheManager.prg'
<<lcSpace>>	Local Control As ControlNameSpace Of 'Tools\Namespaces\Prg\ControlNameSpace.prg'
<<lcSpace>>	Local Cursor As CursorNameSpace Of 'Tools\Namespaces\Prg\CursorNameSpace.prg'
<<lcSpace>>	Local Logical As LogicalNameSpace Of 'Tools\Namespaces\Prg\LogicalNameSpace.prg'
<<lcSpace>>	Local Datetime As DateTimeNameSpace Of 'Tools\Namespaces\Prg\DateTimeNameSpace.prg'
<<lcSpace>>	Local GUI As GUINameSpace Of 'Tools\Namespaces\Prg\GUINameSpace.prg'
<<lcSpace>>	Local Number As NumberNameSpace Of 'Tools\Namespaces\Prg\NumberNameSpace.prg'
<<lcSpace>>	Local Object As ObjectNameSpace Of 'Tools\Namespaces\Prg\ObjectNameSpace.prg'
<<lcSpace>>	Local Sql As SQLNameSpace Of 'Tools\Namespaces\Prg\SQLNameSpace.prg'
<<lcSpace>>	Local String As StringNameSpace Of 'Tools\Namespaces\Prg\StringNameSpace.prg'
<<lcSpace>>	Local Vector As VectorNameSpace Of 'Tools\Namespaces\Prg\VectorNameSpace.prg'
<<lcSpace>>	Local XML As XMLNamespace Of 'Tools\Namespaces\Prg\XMLNamespace.prg'
<<lcSpace>>	Local Environment As EnvironmentNamespace Of 'Tools\Namespaces\Prg\EnvironmentNamespace.prg'
<<lcSpace>>	Local IO As IONameSpace Of 'Tools\Namespaces\Prg\IONameSpace.prg'
<<lcSpace>>	Local System As SystemNameSpace Of 'Tools\Namespaces\Prg\SystemNameSpace.prg'
<<lcSpace>>	Local Exception As ExceptionNameSpace Of 'Tools\Namespaces\Prg\ExceptionNameSpace.prg'
<<lcSpace>>#EndIf
EndText
Use (_FOXCODE) IN 0 Shared Again Alias 'UdpFoxCode'
Delete From UdpFoxCode Where Type = 'U' And ABBREV == '_NS'
Insert Into UdpFoxCode ( Type, ABBREV, cmd, Data ) ;
    Values ( 'U', '_NS', '{stmthandler}', lcCode )
Use In Select( 'UdpFoxCode' )
