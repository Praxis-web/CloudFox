#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'

External Procedure VariantNameSpace.prg,;
	CacheManager.prg,;
	ControlNameSpace.prg,;
	CursorNameSpace.prg,;
	LogicalNameSpace.prg,;
	DateTimeNameSpace.prg,;
	GUINameSpace.prg,;
	NumberNameSpace.prg,;
	ObjectNameSpace.prg,;
	SQLNameSpace.prg,;
	StringNameSpace.prg,;
	VectorNameSpace.prg,;
	XMLNamespace.prg,;
	EnvironmentNamespace.prg,;
	IONameSpace.prg,;
	SystemNameSpace.prg,;
	ExceptionNameSpace.prg,;
	ExceptionNameSpace.prg

* LoadNameSpace
Procedure LoadNameSpace() As VOID

	DEBUG_PROGRAM
	
	If Type( 'Variant' ) == 'U'
		Public Variant As VariantNameSpace Of 'Tools\Namespaces\Prg\VariantNameSpace.prg'

	Endif && TYPE( 'Variant' ) == 'U'

	If Vartype( m.Variant ) # 'O'
		m.Variant = NewObject( 'VariantNameSpace', 'Tools\Namespaces\Prg\VariantNameSpace.prg' )

	Endif && VARTYPE( m.Variant ) # 'O'

	If Type( 'CacheManager' ) == 'U'
		Public CacheManager As CacheManager Of 'Tools\Namespaces\Prg\CacheManager.prg'

	Endif && TYPE( 'CacheManager' ) == 'U'

	If Vartype( m.CacheManager ) # 'O'
		m.CacheManager = NewObject( 'CacheManager', 'Tools\Namespaces\Prg\CacheManager.prg' )

	Endif && VARTYPE( m.CacheManager ) # 'O'

	If Type( 'Control' ) == 'U'
		Public Control As ControlNameSpace Of 'Tools\Namespaces\Prg\ControlNameSpace.prg'

	Endif && TYPE( 'Control' ) == 'U'

	If Vartype( m.Control ) # 'O'
		m.Control = NewObject( 'ControlNameSpace', 'Tools\Namespaces\Prg\ControlNameSpace.prg' )

	Endif && VARTYPE( m.Control ) # 'O'

	If Type( 'Cursor' ) == 'U'
		Public Cursor As CursorNameSpace Of 'Tools\Namespaces\Prg\CursorNameSpace.prg'

	Endif && TYPE( 'Cursor' ) == 'U'

	If Vartype( m.Cursor ) # 'O'
		m.Cursor = NewObject( 'CursorNameSpace', 'Tools\Namespaces\Prg\CursorNameSpace.prg' )

	Endif && VARTYPE( m.Cursor ) # 'O'

	If Type( 'Logical' ) == 'U'
		Public Logical As LogicalNameSpace Of 'Tools\Namespaces\Prg\LogicalNameSpace.prg'

	Endif && TYPE( 'Logical' ) == 'U'

	If Vartype( m.Logical ) # 'O'
		m.Logical = NewObject( 'LogicalNameSpace', 'Tools\Namespaces\Prg\LogicalNameSpace.prg' )

	Endif && VARTYPE( m.Logical ) # 'O'

	If Type( 'DateTime' ) == 'U'
		Public Datetime As DateTimeNameSpace Of 'Tools\Namespaces\Prg\DateTimeNameSpace.prg'

	Endif && TYPE( 'DateTime' ) == 'U'

	If Vartype( m.Datetime ) # 'O'
		m.Datetime = NewObject( 'DateTimeNameSpace', 'Tools\Namespaces\Prg\DateTimeNameSpace.prg' )

	Endif && VARTYPE( m.DateTime ) # 'O'

	If Type( 'GUI' ) == 'U'
		Public GUI As GUINameSpace Of 'Tools\Namespaces\Prg\GUINameSpace.prg'

	Endif && TYPE( 'GUI' ) == 'U'

	If Vartype( m.GUI ) # 'O'
		m.GUI = NewObject( 'GUINameSpace', 'Tools\Namespaces\Prg\GUINameSpace.prg' )

	Endif && VARTYPE( m.GUI ) # 'O'

	If Type( 'Number' ) == 'U'
		Public Number As NumberNameSpace Of 'Tools\Namespaces\Prg\NumberNameSpace.prg'

	Endif && TYPE( 'Number' ) == 'U'

	If Vartype( m.Number ) # 'O'
		m.Number = NewObject( 'NumberNameSpace', 'Tools\Namespaces\Prg\NumberNameSpace.prg' )

	Endif && VARTYPE( m.Number ) # 'O'

	If Type( 'Object' ) == 'U'
		Public Object As ObjectNameSpace Of 'Tools\Namespaces\Prg\ObjectNameSpace.prg'

	Endif && TYPE( 'Object' ) == 'U'

	If Vartype( m.Object ) # 'O'
		m.Object = NewObject( 'ObjectNameSpace', 'Tools\Namespaces\Prg\ObjectNameSpace.prg' )

	Endif && VARTYPE( m.Object ) # 'O'

	If Type( 'SQL' ) == 'U'
		Public Sql As SQLNameSpace Of 'Tools\Namespaces\Prg\SQLNameSpace.prg'

	Endif && TYPE( 'SQL' ) == 'U'

	If Vartype( m.Sql ) # 'O'
		m.Sql = NewObject( 'SQLNameSpace', 'Tools\Namespaces\Prg\SQLNameSpace.prg' )

	Endif && VARTYPE( m.SQL ) # 'O'

	If Type( 'String' ) == 'U'
		Public String As StringNameSpace Of 'Tools\Namespaces\Prg\StringNameSpace.prg'

	Endif && TYPE( 'String' ) == 'U'

	If Vartype( m.String ) # 'O'
		m.String = NewObject( 'StringNameSpace', 'Tools\Namespaces\Prg\StringNameSpace.prg' )

	Endif && VARTYPE( m.String ) # 'O'

	If Type( 'Vector' ) == 'U'
		Public Vector As VectorNameSpace Of 'Tools\Namespaces\Prg\VectorNameSpace.prg'

	Endif && TYPE( 'Vector' ) == 'U'

	If Vartype( m.Vector ) # 'O'
		m.Vector = NewObject( 'VectorNameSpace', 'Tools\Namespaces\Prg\VectorNameSpace.prg' )

	Endif && VARTYPE( m.Vector ) # 'O'

	If Type( 'XML' ) == 'U'
		Public XML As XMLNamespace Of 'Tools\Namespaces\Prg\XMLNamespace.prg'

	Endif && TYPE( 'XML' ) == 'U'

	If Vartype( m.XML ) # 'O'
		m.XML = NewObject( 'XMLNameSpace', 'Tools\Namespaces\Prg\XMLNameSpace.prg' )

	Endif && VARTYPE( m.XML ) # 'O'

	If Type( 'Environment' ) == 'U'
		Public Environment As EnvironmentNamespace Of 'Tools\Namespaces\Prg\EnvironmentNamespace.prg'

	Endif && TYPE( 'Environment' ) == 'U'

	If Vartype( m.Environment ) # 'O'
		m.Environment = NewObject( 'EnvironmentNameSpace', 'Tools\Namespaces\Prg\EnvironmentNameSpace.prg' )

	Endif && VARTYPE( m.Environment ) # 'O'

	If Type( 'IO' ) == 'U'
		Public IO As IONameSpace Of 'Tools\Namespaces\Prg\IONameSpace.prg'

	Endif && TYPE( 'Environment' ) == 'U'

	If Vartype( m.IO ) # 'O'
		m.IO = NewObject( 'IONameSpace', 'Tools\Namespaces\Prg\IONameSpace.prg' )

	Endif && VARTYPE( m.IO ) # 'O'

	If Type( 'System' ) == 'U'
		Public System As SystemNameSpace Of 'Tools\Namespaces\Prg\SystemNameSpace.prg'

	Endif && TYPE( 'Environment' ) == 'U'

	If Vartype( m.System ) # 'O'
		m.System = NewObject( 'SystemNameSpace', 'Tools\Namespaces\Prg\SystemNameSpace.prg' )

	Endif && VARTYPE( m.System ) # 'O'

	If Type( 'Exception' ) == 'U'
		Public Exception As ExceptionNameSpace Of 'Tools\Namespaces\Prg\ExceptionNameSpace.prg'

	Endif && TYPE( 'Environment' ) == 'U'

	If Vartype( m.Exception ) # 'O'
		m.Exception = NewObject( 'ExceptionNameSpace', 'Tools\Namespaces\Prg\ExceptionNameSpace.prg' )

	Endif && VARTYPE( m.Exception ) # 'O'

Endproc && LoadNameSpace
