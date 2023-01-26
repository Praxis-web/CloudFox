*!* ///////////////////////////////////////////////////////
*!* Procedure.....: SetRecordState
*!* Description...: Setea todos los campos de un registro
*!* Date..........: Viernes 10 de Abril de 2009 (10:58:57)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*
* nFieldState = Estado a setear
* cTableAlias = Nombre de la tabla (Tabal actual si está vacío )
* cFieldsList = Lista de Campos (Todos si está vacía)
* lExcludeFieldsList = Indica si la lista de campos es la que procesa o la que excluye (Procesa por default)
Lparameters nFieldState As Integer,;
	cTableAlias As String,;
	cFieldsList As String,;
	lExcludeFieldsList As Boolean  )


Local lnFieldsLen As Integer,;
	i As Integer
Local lcOldAlias As String,;
	lcAlias As String


Try

	If Empty( cFieldsList )
		cFieldsList = ""
	Endif

	If Empty( lExcludeFieldsList )
		lExcludeFieldsList = .F.
	Endif

	lcOldAlias = Alias()
	If Empty( cTableAlias )
		lcAlias = Alias()

	Else
		lcAlias = cTableAlias

	Endif

	lnFieldsLen = Afields( laFields, lcAlias )
	For i = 1 To lnFieldsLen

		If lExcludeFieldsList
			* Verificar que el campo NO SE ENCUENTRE 
			* en la lista de excluidos
			If Empty( Atc( Field( i ), cFieldsList ))
				Setfldstate( i, nFieldState, lcAlias )
			Endif

		Else
			* Verificar que el campo SE ENCUENTRA
			* en la lista de campos, o que la lista está vacía

			If Empty( cFieldsList ) Or !Empty( Atc( Field( i ), cFieldsList ))
				Setfldstate( i, nFieldState, lcAlias )
			Endif

		Endif

	Endfor


Catch To oErr
	Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	If Used( lcOldAlias )
		Select Alias( lcOldAlias )
	Endif

Endtry

Endproc
*!*
*!* END PROCEDURE SetRecordState
*!*
*!* ///////////////////////////////////////////////////////