#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure SubGrupo( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local lcCommand As String
	Local loSubGrupo As oSubGrupo Of "Clientes\Archivos\prg\Grupo.prg",;
		loGrupo As oGrupo Of "Clientes\Archivos\prg\Grupo.prg",;
		loFilterCriteria As CollectionBase Of "Tools\Namespaces\Prg\CollectionBase.Prg",;
		loParam As Object,;
		loFiltro As Object,;
		loReg as Object 


	Try

		lcCommand = ""

		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		AddProperty( loParam, "cURL", cURL  )

		loSubGrupo = GetEntity( "SubGrupo" )
		loSubGrupo.Initialize( loParam )
		
		* RA 09/11/2021(14:53:19)
		* Esto permite mostrar una entidad hija sin filtro
		* por el padre
		loSubGrupo.lIsChild = .F. 

		AddProperty( loParam, "oBiz", loSubGrupo )

		Do Form (loSubGrupo.cGrilla) ;
			With loParam To loReturn


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loSubGrupo = Null
		loSubGrupo = Null 

	Endtry

Endproc && Grupo



