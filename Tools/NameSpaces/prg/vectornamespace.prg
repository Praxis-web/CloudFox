#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
Endif

* VectorNameSpace
Define Class VectorNameSpace As Namespacebase Of 'Tools\namespaces\prg\objectnamespace.prg'
	#If .F.
		Local This As VectorNameSpace Of 'Tools\namespaces\prg\VectorNameSpace.prg'
	#Endif

	*-- XML Metadata for customizable properties
	Protected m._MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="aadd" type="method" display="AAdd" />] ;
		+ [<memberdata name="browse" type="method" display="Browse" />] ;
		+ [<memberdata name="procinfobrowse" type="method" display="ProcInfoBrowse" />] ;
		+ [<memberdata name="tocursor" type="method" display="ToCursor" />] ;
		+ [</VFPData>]

	Dimension m.AAdd_COMATTRIB[ 5 ]
	AAdd_COMATTRIB[ 1 ] = 0
	AAdd_COMATTRIB[ 2 ] = 'Devuelve el tamaño del array y agrega el nuevo elemento en la ultima posición del array.'
	AAdd_COMATTRIB[ 3 ] = 'AAdd'
	AAdd_COMATTRIB[ 4 ] = 'Integer'
	* AAdd_COMATTRIB[ 5 ] = 0

	* AAdd
	* Devuelve el tamaño del array y agrega el nuevo elemento en la ultima posición del array.
	Function  AAdd ( taArray As Variant @, tvValue As Variant ) As Integer HelpString 'Devuelve el tamaño del array y agrega el nuevo elemento en la ultima posición del array.'

		Local lnLen As Integer, ;
			loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Devuelve el tamaño del array y agrega el nuevo elemento en la ultima posición del array.
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Lunes 11 de Junio de 2007 (15:53:05)
			 *:ModiSummary:
			 R/0001 -
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 Alen
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		Try

			lnLen = Alen ( m.taArray )

			If m.lnLen == 1 And Vartype ( m.taArray[ 1 ] ) == 'L'  And m.taArray[ 1 ] == .F. And Vartype ( m.tvValue ) # 'L'
				* No Hacer Nada

			Else && m.lnLen == 1 And Vartype ( m.taArray[ 1 ] ) == 'L'  And m.taArray[ 1 ] == .F.  And Vartype ( m.tvValue ) # 'L'
				lnLen = m.lnLen + 1
				Dimension m.taArray[ m.lnLen ]

			Endif && m.lnLen == 1 And Vartype ( m.taArray[ 1 ] ) == 'L'  And m.taArray[ 1 ] == .F.  And Vartype ( m.tvValue ) # 'L'

			taArray[ m.lnLen ] = m.tvValue

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, taArray, tvValue
			THROW_EXCEPTION

		Endtry

		Return m.lnLen

	Endfunc && AAdd

	Dimension Browse_COMATTRIB[ 5 ]
	Browse_COMATTRIB[ 1 ] = 0
	Browse_COMATTRIB[ 2 ] = 'Devuelve la referencia de un objeto Grid asociado a un Browse que muestra el array convertido a cursor.'
	Browse_COMATTRIB[ 3 ] = 'Browse'
	Browse_COMATTRIB[ 4 ] = 'Object'
	* Browse_COMATTRIB[ 5 ] = 1

	* Browse
	* Devuelve la referencia de un objeto Grid asociado a un Browse que muestra el array convertido a cursor.
	* Convierte un array en cursor y lo muestra con una grilla.
	Function Browse ( taArray As Variant @, tcTitle As String ) As Grid HelpString 'Devuelve la referencia de un objeto Grid asociado a un Browse que muestra el array convertido a cursor.'

		Local lcTitle As String, ;
			loErr As Object, ;
			loGrid As Grid

		Try

			If Empty ( tcTitle )
				lcTitle = 'Vector Browse'

			Else
				lcTitle = tcTitle

			Endif && Empty( tcTitle )

			This.ToCursor ( @taArray, 'qArray' )
			Select qArray
			Locate
			Browse Name loGrid Nowait Title ( lcTitle )
			m.loGrid.AutoFit()

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, taArray
			THROW_EXCEPTION

		Endtry

		Return loGrid

	Endproc && Browse

	Dimension ProcInfoBrowse_COMATTRIB[ 5 ]
	ProcInfoBrowse_COMATTRIB[ 1 ] = 0
	ProcInfoBrowse_COMATTRIB[ 2 ] = 'Muestra la informacón de un archivo en una grilla.'
	ProcInfoBrowse_COMATTRIB[ 3 ] = 'ProcInfoBrowse'
	ProcInfoBrowse_COMATTRIB[ 4 ] = 'Void'
	* ProcInfoBrowse_COMATTRIB[ 5 ] = 0

	* ProcInfoBrowse
	* Muestra la informacón de un archivo en una grilla.
	Procedure ProcInfoBrowse ( tcFile As String, tnType As Number ) As VOID HelpString 'Muestra la informacón de un archivo en una grilla.'

		Local laProcInfo[1], ;
			loErr As Object

		Try
			If Pcount() == 1
				tnType=0

			Endif && Pcount() == 1

			If File ( m.tcFile )
				Aprocinfo ( laProcInfo, m.tcFile, m.tnType )
				This.Browse ( @laProcInfo )

			Endif && File ( m.tcFile )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFile, tnType
			THROW_EXCEPTION

		Endtry

	Endproc && ProcInfoBrowse

	Dimension ToCursor_COMATTRIB[ 5 ]
	ToCursor_COMATTRIB[ 1 ] = 0
	ToCursor_COMATTRIB[ 2 ] = 'Convierte un vector en un cursor.'
	ToCursor_COMATTRIB[ 3 ] = 'ToCursor'
	ToCursor_COMATTRIB[ 4 ] = 'Void'
	* ToCursor_COMATTRIB[ 5 ] = 1

	* ToCursor
	* Convierte un vector en un cursor.
	Procedure ToCursor ( taArray As Variant @, tcCursor As String ) As VOID HelpString 'Convierte un vector en un cursor.'

		Local laStru[1], ;
			lcAux As String, ;
			lcCol As String, ;
			lcRow As String, ;
			lnCols As Number, ;
			lnI As Number, ;
			lnJ As Number, ;
			lnLen As Number, ;
			lnRows As Number, ;
			lnSiz As Number, ;
			lnSize As Number, ;
			loErr As Object

		If Empty ( tcCursor )
			tcCursor = 'qArray'

		Endif && Empty ( tcCursor )

		Try

			* Calcula el tamaño del array.
			lnRows = Alen ( taArray, 1 )
			* Calcula la cantidad maxima de columnas
			lnCols = Max ( Alen ( taArray, 2 ), 1 )

			* Crea el array para poder crear la definición de la estructura del cursor.
			Dimension laStru ( m.lnCols, 5 )
			lcRow = ''

			* Recorre todas las columnas del array para conocer las estructuras de datos.
			For lnI = 1 To m.lnCols
				* Create structure array
				lcCol               = Transform ( m.lnI )
				laStru [ m.lnI, 1 ] = Vartype ( taArray [ 1, m.lnI ] ) + m.lcCol
				laStru [ m.lnI, 2 ] = 'C'
				lnSize              = 1
				For lnJ = 1 To lnRows
					* lnSize = Max ( m.lnSize, Len ( Transform ( taArray [ m.lnJ, m.lnI ] ) ) )
					lcAux  = Transform ( taArray [ m.lnJ, m.lnI ] )
					lnLen  = Len ( lcAux )
					lnSize = Max ( m.lnSize, lnLen )

				Endfor

				laStru [ m.lnI, 3 ] = m.lnSize
				laStru [ m.lnI, 4 ] = 0

				* Create "insert into" values

				If ! Empty ( m.lcRow )
					lcRow = m.lcRow + ', '

				Endif && ! Empty ( m.lcRow )

				lcRow = m.lcRow + 'Transform( taArray[ m.lnI, ' + m.lcCol + '] )'

			Next

			* Make a cursor with fields defined by laStru
			Create Cursor (m.tcCursor) From Array laStru

			* Add rows using a string of transform(taArray(lnI,1))...
			For lnI = 1 To m.lnRows
				Insert Into (m.tcCursor) Values ( &lcRow. )

			Next

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, taArray, tcCursor
			THROW_EXCEPTION

		Endtry

	Endproc && ToCursor

Enddefine && VectorNameSpace