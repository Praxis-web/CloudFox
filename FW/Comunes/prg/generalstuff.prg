*!* ///////////////////////////////////////////////////////
*!* Class.........: GeneralStuff
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Devuelve un XML con las tablas renombradas
*!* Date..........: Domingo 20 de Abril de 2008 (13:20:54)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class GeneralStuff As Session

	#If .F.
		Local This As GeneralStuff Of "V:\SistemasPraxisV2\Fw\comunes\Prg\GeneralStuff.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="renamecursors" type="method" display="RenameCursors" />] + ;
		[</VFPData>]




	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: RenameCursors
	*!* Description...: Devuelve un XML con los cursores renombrados
	*!* Date..........: Domingo 20 de Abril de 2008 (13:34:22)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!* cXML:		Un XML conteniendo tablas
	*!* cNewTablesNames: Una lista de nombres separados por comas que van a reemplazar los nombres actuales

	Procedure RenameCursors( cXML As String,;
			cNewTablesNames As String ) As String;
			HELPSTRING "Devuelve un XML con los cursores renombrados"


		Local lnLen As Integer
		Local loXA As prxXMLAdapter Of "FW\Comunes\Prg\prxXMLAdapter.prg"
		Local oTable As Xmltable
		Local laTables(1)
		Local lcRetVal As String


		Try

			lcRetVal = ""

			lnLen = Getwordcount( cNewTablesNames )
			Local laNames( lnLen ) As String

			* Crea una matriz con los nombres de las tablas as renombrar
			For i = 1 To lnLen
				laNames( i ) = Getwordnum( cNewTablesNames, i )
			Endfor

			* Creates an XmlAdapter
			loXA = Newobject("prxXMLAdapter","prxXMLAdapter.prg")

			loXA.LoadXML( cXML, .F. )

			For i = 1 To loXA.Tables.Count
				oTable = loXA.Tables.Item( i )

				* Extract each of the tables' cursor
				If lnLen < i
					oTable.ToCursor( .F. )

				Else
					* Renombra los cursores al extraerlos
					oTable.ToCursor( .F., laNames( i ) )

				Endif


			Endfor

			loXA = Null

			* Vuelve a generar el XML con los cursores renombrados
			lnLen = Aused( laTables )

			loXA = Newobject("prxXMLAdapter","prxXMLAdapter.prg")

			For i = 1 To lnLen
				loXA.AddTableSchema( laTables( i ) )
			Endfor

			loXA.ToXML( "lcRetVal" )

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process()
			Throw loError

		Finally
			* Cierra los cursores
			lnLen = Aused( laTables )

			For i = 1 To lnLen
				Use In Alias( laTables( i ) )
			Endfor

			laTables = Null
			laNames = Null
			oTable = Null

			loXA = Null

		Endtry

		Return lcRetVal

	Endproc
	*!*
	*!* END PROCEDURE RenameCursors
	*!*
	*!* ///////////////////////////////////////////////////////


Enddefine
*!*
*!* END DEFINE
*!* Class.........: GeneralStuff
*!*
*!* ///////////////////////////////////////////////////////