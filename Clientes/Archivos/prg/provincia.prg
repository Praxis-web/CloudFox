#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure Provincia( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loProvincia As oProvincia Of "Clientes\Archivos\prg\Pais.prg",;
		loPais As oPais Of "Clientes\Archivos\prg\Pais.prg",;
		loFilterCriteria As CollectionBase Of "Tools\Namespaces\Prg\CollectionBase.Prg",;
		loParam As Object,;
		loFiltro As Object,;
		loReg As Object


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )
		loFilterCriteria = Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.Prg" )
		loPais = GetEntity( "Pais" )

		loFiltro = Createobject( "Empty" )
		AddProperty( loFiltro, "Nombre", loPais.cModelo  )
		AddProperty( loFiltro, "FieldName", Lower( loPais.cPKField ))
		AddProperty( loFiltro, "FieldRelation", "==" )
		AddProperty( loFiltro, "FieldValue", Transform( 1 ))

		loFilterCriteria.RemoveItem( Lower( loFiltro.Nombre ) )
		loFilterCriteria.Add( loFiltro, Lower( loFiltro.Nombre ))

		AddProperty( loParam, "oFilterCriteria", loFilterCriteria )

		loPais.GetByWhere( loParam )
		Select Alias( loPais.cMainCursorName )
		Scatter Name loReg

		loPais.LaunchEditForm( loReg )



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loProvincia = Null
		loPais = Null

	Endtry

Endproc && Pais



