*!* ///////////////////////////////////////////////////////
*!* Procedure.....: GetFieldStructure
*!* Description...: Devuelve un string con la estructura del campo
*!* Date..........: Lunes 12 de Febrero de 2007 (14:40:06)
*!* Author........: Ricardo Aidelman
*!* Project.......: CMSI
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Lparameters tcFieldName As String,;
	tcFieldType As String,;
	tnFieldWidth As Integer,;
	tnFieldDecimal As Integer,;
	tlFieldNull As Boolean,;
	tlFieldCPTrans As Boolean,;
	tuFieldDefault As Variant


Local lcFieldStructure As String

Try

	lcFieldStructure = ""


	lcFieldStructure = "[" + tcFieldName + "] " + tcFieldType

	If !Empty( tnFieldWidth ) And !InList( tcFieldType, "I", "W", "Y", "D", "T", "G", "L", "M" )
		lcFieldStructure = lcFieldStructure + "("+ Transform( tnFieldWidth )
	Endif

	If Empty( tnFieldDecimal )
		Do Case
		Case !Empty( tnFieldWidth ) And InList( tcFieldType, "N", "F" )
			lcFieldStructure = lcFieldStructure + ","+ Transform( tnFieldDecimal ) + ")"

		Case !Empty( tnFieldWidth ) And !InList( tcFieldType, "I", "W", "Y", "D", "T", "G", "L", "M" )
			lcFieldStructure = lcFieldStructure + ")"
			
		Otherwise

		EndCase

	Else
		If InList( tcFieldType, "B" )
			lcFieldStructure = lcFieldStructure + "("+ Transform( tnFieldDecimal ) + ")"
			
		Else
			lcFieldStructure = lcFieldStructure + ","+ Transform( tnFieldDecimal ) + ")"
			
		Endif
		
	Endif

	If tlFieldNull
		lcFieldStructure = lcFieldStructure + " NULL "

	Else
		lcFieldStructure = lcFieldStructure + " NOT NULL "

	Endif

	If !Empty( tuFieldDefault )
		lcFieldStructure = lcFieldStructure + " DEFAULT " + Transform( tuFieldDefault )
	Endif

	If tlFieldCPTrans
		lcFieldStructure = lcFieldStructure + " NOCPTRANS "
	Endif


Catch To oErr
	Local loError As ErrorHandler Of "ErrorHandler\Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return lcFieldStructure

Endproc
*!*
*!* END PROCEDURE GetFieldStructure
*!*
*!* ///////////////////////////////////////////////////////