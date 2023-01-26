*!* ///////////////////////////////////////////////////////
*!* Procedure.....: GetCursorStructure
*!* Description...: Devuelve un string con la estructura del cursor
*!* Date..........: Lunes 12 de Febrero de 2007 (14:40:06)
*!* Author........: Ricardo Aidelman
*!* Project.......: CMSI
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

#Define FieldName		1
#Define FieldType		2
#Define FieldWidth		3
#Define FieldDecimal	4
#Define FieldNull		5
#Define FieldCPTrans	6
#Define FieldDefault	9

Lparameters cCursorAlias As String,;
	cExtraFields As String,;
	tcExcludeFieldList As String

Local lnLen As Integer,;
	i As Integer
Local laFields[1]
Local lcAlias As String,;
	lcCursorStructure As String

Local llInList As Boolean

Try

	lcCursorStructure = ""
	If Empty( cExtraFields )
		cExtraFields = ""
	Else
		cExtraFields = "," + cExtraFields
	Endif

	If Empty( cCursorAlias )
		cCursorAlias = Alias()
	Endif

	If Empty( tcExcludeFieldList )
		tcExcludeFieldList = "_&$&_"
	Endif

	tcExcludeFieldList = Lower( tcExcludeFieldList )
	tcExcludeFieldList = Strtran( tcExcludeFieldList, "'", "" )
	tcExcludeFieldList = Strtran( tcExcludeFieldList, '"', "" )
	tcExcludeFieldList = Strtran( tcExcludeFieldList, "[", "" )
	tcExcludeFieldList = Strtran( tcExcludeFieldList, "]", "" )
	tcExcludeFieldList = Strtran( tcExcludeFieldList, " ", "" )

	tcExcludeFieldList = tcExcludeFieldList
	tcExcludeFieldList = Strtran( tcExcludeFieldList, ",", [','] )


	lcAlias = Alias()

	lnLen = Afields( laFields, cCursorAlias )

	Local lcFNames As String,;
		lcField As String

	lcFNames = ""

	For i=1 To lnLen

		TEXT To lcCommand NoShow TextMerge Pretext 15
		InList( '<<Lower( laFields[ i, 1 ] )>>', '<<tcExcludeFieldList>>' )
		ENDTEXT

		llInList = &lcCommand

		If !llInList
			lcField = GetFieldStructure( laFields[ i, FieldName ],;
				laFields[ i, FieldType ],;
				laFields[ i, FieldWidth ],;
				laFields[ i, FieldDecimal ],;
				laFields[ i, FieldNull ],;
				laFields[ i, FieldCPTrans ],;
				laFields[ i, FieldDefault ] )

			lcFNames = lcFNames + "," + lcField
		Endif
	Endfor

	lcCursorStructure = Substr(lcFNames,2) + cExtraFields

Catch To oErr
	Local loError As ErrorHandler Of "ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	If Used( lcAlias )
		Select Alias( lcAlias )
	Endif

Endtry

Return lcCursorStructure

Endproc
*!*
*!* END PROCEDURE GetCursorStructure
*!*
*!* ///////////////////////////////////////////////////////