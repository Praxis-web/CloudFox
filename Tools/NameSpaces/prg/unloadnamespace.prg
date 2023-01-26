
* UnLoadNameSpace
Procedure UnLoadNameSpace() As VOID
	If Type( 'CacheManager' ) # 'U'

		If Vartype( m.CacheManager ) == 'O'
			m.CacheManager = Null

		Endif && VARTYPE( m.CacheManager ) == 'O'

		Release m.CacheManager

	Endif && TYPE( 'CacheManager' ) # 'U'

	If Type( 'Control' ) # 'U'

		If Vartype( m.Control ) == 'O'
			m.Control = Null

		Endif && VARTYPE( m.Control ) == 'O'

		Release m.Control

	Endif && TYPE( 'Control' ) # 'U'

	If Type( 'Cursor' ) # 'U'

		If Vartype( m.Cursor ) == 'O'
			m.Cursor = Null

		Endif && VARTYPE( m.Cursor ) == 'O'

		Release m.Cursor

	Endif && TYPE( 'Cursor' ) # 'U'

	If Type( 'Logical' ) # 'U'

		If Vartype( m.Logical ) == 'O'
			m.Logical = Null

		Endif && VARTYPE( m.Logical ) == 'O'

		Release m.Logical

	Endif && TYPE( 'Logical' ) # 'U'

	If Type( 'DateTime' ) # 'U'
		If Vartype( m.Datetime ) == 'O'
			m.Datetime = Null

		Endif && VARTYPE( m.DateTime ) == 'O'

		Release m.Datetime

	Endif && TYPE( 'DateTime' ) # 'U'

	If Type( 'GUI' ) # 'U'
		If Vartype( m.GUI ) == 'O'
			m.GUI = Null

		Endif && VARTYPE( m.GUI ) == 'O'

		Release m.GUI

	Endif && TYPE( 'GUI' ) # 'U'

	If Type( 'Number' ) # 'U'
		If Vartype( m.Number ) == 'O'
			m.Number = Null

		Endif && VARTYPE( m.Number ) == 'O'

		Release m.Number

	Endif && TYPE( 'Number' ) # 'U'

	If Type( 'Object' ) # 'U'
		If Vartype( m.Object ) == 'O'
			m.Object = Null

		Endif && VARTYPE( m.Object ) == 'O'

		Release m.Object

	Endif && TYPE( 'Object' ) # 'U'

	If Type( 'SQL' ) # 'U'
		If Vartype( m.Sql ) == 'O'
			m.Sql = Null

		Endif && VARTYPE( m.SQL ) == 'O'

		Release m.Sql

	Endif && TYPE( 'SQL' ) # 'U'

	If Type( 'String' ) # 'U'

		If Vartype( m.String ) == 'O'
			m.String = Null

		Endif && VARTYPE( m.String ) == 'O'

		Release m.String

	Endif && TYPE( 'String' ) # 'U'

	If Type( 'Vector' ) # 'U'

		If Vartype( m.Vector ) == 'O'
			m.Vector = Null

		Endif && VARTYPE( m.Vector ) == 'O'

		Release m.Vector

	Endif && TYPE( 'Vector' ) # 'U'

	If Type( 'XML' ) # 'U'

		If Vartype( m.XML ) == 'O'
			m.XML = Null

		Endif && VARTYPE( m.XML ) == 'O'

		Release m.XML

	Endif && TYPE( 'XML' ) # 'U'

	If Type( 'Environment' ) # 'U'

		If Vartype( m.Environment ) == 'O'
			m.Environment = Null

		Endif && VARTYPE( m.Environment ) == 'O'

		Release m.Environment

	Endif && TYPE( 'Environment' ) # 'U'


	If Type( 'IO' ) # 'U'

		If Vartype( m.IO) == 'O'
			m.IO = Null

		Endif && VARTYPE( m.IO ) == 'O'

		Release m.IO

	Endif && TYPE( 'IO' ) # 'U'


	If Type( 'Variant' ) # 'U'

		If Vartype( m.Variant ) == 'O'
			m.Variant = Null

		Endif && VARTYPE( m.Variant ) == 'O'

		Release m.Variant

	Endif && TYPE( 'Variant' ) # 'U'

	If Type( 'System' ) # 'U'

		If Vartype( m.System ) == 'O'
			m.System = Null

		Endif && VARTYPE( m.System ) == 'O'

		Release m.System

	Endif && TYPE( 'System' ) # 'U'

	If Type( 'Exception' ) # 'U'

		If Vartype( m.Exception ) == 'O'
			m.Exception = Null

		Endif && VARTYPE( m.Exception ) == 'O'

		Release m.Exception

	Endif && TYPE( 'Exception' ) # 'U'

Endproc && UnLoadNameSpace
