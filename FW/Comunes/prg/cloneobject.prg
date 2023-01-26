*!*	*
*!*	*
*!*	Procedure CloneObject( oSourceObject As Object ) As Object
Lparameters oSourceObject As Object

Local lcCommand As String,;
	lcPropertyName As String

Local lnLen As Integer,;
	lnI As Integer

Local loNewObject As Object

Dimension laMember(1)

Try

	lcCommand = ""

	lnLen = Amembers( laMember, oSourceObject, 0 )
	
	If Pemstatus( oSourceObject, "Class", 5 )
		If Pemstatus( oSourceObject, "ClassLibrary", 5 )
			loNewObject = Newobject( oSourceObject.Class, oSourceObject.ClassLibrary )

		Else
			loNewObject = Createobject( oSourceObject.Class )

		Endif

	Else
		loNewObject = Createobject( "Empty" )

	Endif

	For lnI = 1 To lnLen
		lcPropertyName = laMember[lnI]

		Try

			AddProperty( loNewObject, lcPropertyName, oSourceObject.&lcPropertyName )

		Catch To oErr

		Finally

		Endtry

	Endfor


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally

Endtry

Return loNewObject

*!*	Endproc && CloneObject
