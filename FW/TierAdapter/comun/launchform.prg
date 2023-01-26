Lparameters  tcFormKeyName As String,;
	toParameters As Object,;
	tlReturn As Boolean

Local lcParameters As String
Local lcCommand As String
Local lcToClause As String
Local lcFormName As String
Local lvReturn As Variant
Local loForm As oForm Of "Tools\Sincronizador\ColDataBases.prg"
Local loColForms As ColForms Of "Tools\Sincronizador\ColDataBases.prg"
Local i As Integer
Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

Try
	If Vartype( toParameters ) = 'O'
		lcParameters = "With toParameters"

	Else
		lcParameters = ""

	Endif && Vartype( toParameters ) = 'O'

	If tlReturn
		lcToClause = "To lvReturn"

	Else
		lcToClause = ""
		lvReturn = .F.

	Endif && tlReturn

	lcFormName = ""
	loColForms = NewColForms()

	loForm = loColForms.GetItem( tcFormKeyName ) 
	
	If Vartype( loForm ) = "O" 
		lcFormName = Addbs( loForm.cFolder ) + loForm.Name + "." + loForm.cExt
	EndIf
	
*!*		i = loColForms.GetKey( Lower( tcFormKeyName ) )

*!*		If ! Empty( i )
*!*			loForm = loColForms.Item( i )
*!*			lcFormName = Addbs( loForm.cFolder ) + loForm.Name + "." + loForm.cExt

*!*		Endif && ! Empty( i )


	If Empty( lcFormName )
		Error "Falta definir el Formulario " + tcFormKeyName

	Endif && Empty( lcFormName )

	TEXT To lcCommand NoShow TextMerge Pretext 15
		Do Form '<<lcFormName>>' <<lcParameters>> <<lcToClause>>
	ENDTEXT

	&lcCommand

Catch To oErr
	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loForm = Null
	loColForms = Null

Endtry

Return lvReturn