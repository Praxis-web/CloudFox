*
*
Procedure MergeObjects( oMainObject As Object,;
		oSecondObject As Object  ) As Void
	Local lcCommand As String,;
	lcPropertyName As String

	Local lnLen As Integer,;
		i As Integer

	Dimension laMember(1)

	Try

		lcCommand = ""

		If Vartype( oSecondObject ) # "O"
			oSecondObject = Createobject( "Empty" )
		Endif

		If Vartype( oMainObject ) # "O"
			oMainObject = CloneObject( oSecondObject )

		Else
			lnLen = Amembers( laMember, oSecondObject, 0 )

			For i = 1 To lnLen
				lcPropertyName = laMember[ i ]

				Try

					 oMainObject.&lcPropertyName = oSecondObject.&lcPropertyName 

				Catch To oErr
					AddProperty( oMainObject, lcPropertyName, oSecondObject.&lcPropertyName  )

				Finally

				Endtry

			Endfor


		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return oMainObject

Endproc && MergeObjects
