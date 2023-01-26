#Define DATAENTRY_FONTSIZE		8


*!* ///////////////////////////////////////////////////////
*!* Class.........: DataEntryColumn
*!* ParentClass...: Column
*!* BaseClass.....: Column
*!* Description...: Column del DataEntryGrid
*!* Date..........: Jueves 21 de Septiembre de 2006 (12:40:36)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class DataEntryColumn As Column

	#If .F.
		Local This As DataEntryColumn Of "DataEntry.prg"
	#Endif

	FontSize = DATAENTRY_FONTSIZE

	HeaderClass = "DataEntryHeader"
	HeaderClassLibrary = "DataEntry.prg"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Init
	*!* Description...:
	*!* Date..........: Jueves 21 de Septiembre de 2006 (12:40:36)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Init(  ) As Boolean

		Try

			If This.ControlCount >= 2
				* Setea el FontSize del TextBox asociado con la columna.
				* Atención: ControlCount es cero si los TextBox de cada una
				* de las columnas de la grilla se definen explicitamente ( Grid.ColumnCount # –1 )
				This.Controls[2].FontSize = This.FontSize
			Endif

		Catch To oErr
			Throw oErr

		Finally

		Endtry

	Endfunc
	*!*
	*!* END FUNCTION Init
	*!*
	*!* ///////////////////////////////////////////////////////

Enddefine
*!*
*!* END DEFINE
*!* Class.........: DataEntryColumn
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: DataEntryHeader
*!* ParentClass...: Header
*!* BaseClass.....: Header
*!* Description...: Header del DataEntryColumn
*!* Date..........: Jueves 21 de Septiembre de 2006 (12:44:36)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class DataEntryHeader As Header 

	#If .F.
		Local This As DataEntryHeader Of "DataEntryHeader.prg"
	#Endif

	Alignment = 2 && Middle Center
	FontSize = DATAENTRY_FONTSIZE

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: DataEntryHeader
*!*
*!* ///////////////////////////////////////////////////////



