*!* ///////////////////////////////////////////////////////
*!* Procedure.....: AAdd
*!* Description...: Agrega un elemento a un array
*!* Date..........: Lunes 11 de Junio de 2007 (15:53:05)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Procedure AAdd( taArray As Variant, txValue As Variant ) As Integer;
		HELPSTRING "Agrega un elemento a un array"

	Local lnLen As Integer


	lnLen = Alen( taArray )

	If lnLen = 1 And Vartype( taArray[ 1 ] ) = "L" ;
			And taArray[ 1 ] = .F. ;
			And Vartype( txValue ) <> "L"

		* No Hacer Nada

	Else
		lnLen = lnLen + 1
		Dimension taArray[ lnLen ]

	Endif



	taArray[ lnLen ] = txValue

	Return lnLen

Endproc
*!*
*!* END PROCEDURE AAdd
*!*
*!* ///////////////////////////////////////////////////////
