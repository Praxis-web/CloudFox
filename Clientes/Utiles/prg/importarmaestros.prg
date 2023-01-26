#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure ImportarMaestros( nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) As Void

	Local loBiz As oImportarMaestros Of "Clientes\Utiles\prg\ImportarMaestros.prg",;
		loParam As Object


	Try

		lcCommand = ""
		loParam = Createobject( "Empty" )

		AddProperty( loParam, "nPermisos", nPermisos )
		*!*			AddProperty( loParam, "cURL", cURL  )

		loBiz = Newobject( "oImportarMaestros", "Clientes\Utiles\prg\ImportarMaestros.prg" )

		AddProperty( loParam, "oBiz", loBiz )

		Do Form clientes\utiles\scx\importar_maestros ;
			With loParam To loReturn


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && ImportarMaestros

*!* ///////////////////////////////////////////////////////
*!* Class.........: oImportarMaestros
*!* Description...:
*!* Date..........: Lunes 15 de Noviembre de 2021 (16:45:34)
*!*
*!*

Define Class oImportarMaestros As SessionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"

	#If .F.
		Local This As oImportarMaestros Of "Clientes\Utiles\prg\ImportarMaestros.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="importar" type="method" display="Importar" />] + ;
		[<memberdata name="grupos" type="method" display="Grupos" />] + ;
		[<memberdata name="subgrupos" type="method" display="SubGrupos" />] + ;
		[<memberdata name="articulos" type="method" display="Articulos" />] + ;
		[</VFPData>]


	*
	*
	Procedure Importar( oParam As Object ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			*Inform( Program())

			If oParam.Grupo
				This.Grupos()
			Endif

			If oParam.SubGrupo
				This.SubGrupos()
			Endif

			Inform( "Proceso Terminado" )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Importar


	*
	*
	Procedure Grupos(  ) As Void
		Local lcCommand As String,;
			lcFilename As String

		Local loGrupo As oGrupo Of "Clientes\Archivos\prg\Grupo.prg"
		Local loColReg As Collection,;
			loReg As Object

		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .F.

			Close Databases All

			loGrupo = GetEntity( "Grupo" )
			loColReg = Createobject( "Collection" )

			AddProperty( loColReg, "ABM", ABM_ALTA )


			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Cursor cGrupos (
					id I,
					ts T,
					UTS T,
					borrado L,
					nombre C(50),
					descripcion M,
					activo L,
					orden I,
					es_sistema L,
					codigo C(50),
					cliente_praxis I,
					empresa I )
			ENDTEXT

			&lcCommand
			lcCommand = ""

			lcFilename = Getfile( 'txt' )

			If !Empty( lcFilename )

				TEXT To lcMsg NoShow TextMerge Pretext 03
				Importando Grupos
				ENDTEXT

				Wait Window Nowait Noclear lcMsg

				Select cGrupos
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Append From '<<lcFilename>>' DELIMITED WITH _ WITH CHARACTER '|'
				ENDTEXT

				&lcCommand
				lcCommand = ""

				Locate
				*Browse

				Scan

					Scatter Name loReg Memo

					loColReg.Add( loReg )

					If loColReg.Count >= 1000
						If loGrupo.Grabar( loColReg )
							loColReg = Createobject( "Collection" )
							AddProperty( loColReg, "ABM", ABM_ALTA )

							llOk = .T.

						Else
							llOk = .F.
							Exit

						Endif
					Endif


				Endscan

				If loColReg.Count > 0 And llOk = .T.
					loGrupo.Grabar( loColReg )
				Endif


			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Wait WINDOW NOCLEAR NOWAIT 
			loColReg = Null
			loGrupo = Null
			loReg = Null   


		Endtry

	Endproc && Grupos
	*
	*
	Procedure SubGrupos(  ) As Void
		Local lcCommand As String,;
			lcFilename As String
		Local loSubGrupo As oSubGrupo Of "Clientes\Archivos\prg\SubGrupo.prg"
		Local loColReg As Collection,;
			loReg As Object

		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .F.

			Close Databases All

			loSubGrupo = GetEntity( "SubGrupo" )
			loColReg = Createobject( "Collection" )

			AddProperty( loColReg, "ABM", ABM_ALTA )


			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Cursor cSubGrupos (
					id I,
					ts T,
					UTS T,
					borrado L,
					nombre C(50),
					descripcion M,
					activo L,
					orden I,
					es_sistema L,
					codigo C(50),
					cliente_praxis I,
					empresa I,
					grupo I )
			ENDTEXT

			&lcCommand
			lcCommand = ""

			lcFilename = Getfile( 'txt' )

			If !Empty( lcFilename )

				TEXT To lcMsg NoShow TextMerge Pretext 03
				Importando SubGrupos
				ENDTEXT

				Wait Window Nowait Noclear lcMsg

				Select cSubGrupos
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Append From '<<lcFilename>>' DELIMITED WITH _ WITH CHARACTER '|'
				ENDTEXT

				&lcCommand
				lcCommand = ""

				*Browse
				Locate

				Scan

					Scatter Name loReg Memo

					loColReg.Add( loReg )

					If loColReg.Count >= 1000
						If loSubGrupo.Grabar( loColReg )
							loColReg = Createobject( "Collection" )
							AddProperty( loColReg, "ABM", ABM_ALTA )

							llOk = .T.

						Else
							llOk = .F.
							Exit

						Endif
					Endif

				Endscan

				If loColReg.Count > 0 And llOk = .T.
					loSubGrupo.Grabar( loColReg )
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Wait WINDOW NOCLEAR NOWAIT 
			loColReg = Null
			loSubGrupo = Null
			loReg = Null   


		Endtry

	Endproc && SubGrupos


	*
	*
	Procedure Articulos(  ) As Void
		Local lcCommand As String,;
			lcFilename As String
		Local loArticulo As oArticulo Of "Clientes\Archivos\prg\Articulo.prg"
		Local loColReg As Collection,;
			loReg As Object

		Local llOk As Object

		Try

			lcCommand = ""
			llOk = .F.

			Close Databases All

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Cursor cArticulos (
					id I,
					ts T,
					UTS T,
					borrado L,
					nombre C(50),
					nombre_abreviado C(50),
					descripcion M,
					activo L,
					orden I,
					es_sistema L,
					codigo C(50),
					cliente_praxis I,
					empresa I,
					grupo I,
					subgrupo I,
					marca I Null,
					presentacion I Null,
					rubro I Null,
					codigo_barra C(13) Null,
					afip_alicuota_iva I,
					alias C(50) Null )

			ENDTEXT

			&lcCommand
			lcCommand = ""

			lcFilename = Getfile( 'txt,csv' )

			If !Empty( lcFilename )

				TEXT To lcMsg NoShow TextMerge Pretext 03
				Importando Artículos
				ENDTEXT

				Wait Window Nowait Noclear lcMsg

				Select cArticulos
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Append From '<<lcFilename>>' DELIMITED WITH _ WITH CHARACTER '|'
				ENDTEXT

				&lcCommand
				lcCommand = ""

				*Browse
				Locate

				Scan

					Scatter Name loReg Memo

					loColReg.Add( loReg )

					If loColReg.Count >= 1000
						If loArticulo.Grabar( loColReg )
							loColReg = Createobject( "Collection" )
							AddProperty( loColReg, "ABM", ABM_ALTA )

							llOk = .T.

						Else
							llOk = .F.
							Exit

						Endif
					Endif

				Endscan

				If loColReg.Count > 0 And llOk = .T.
					loArticulo.Grabar( loColReg )
				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Wait WINDOW NOCLEAR NOWAIT 
			loColReg = Null
			loArticulo = Null 
			loReg = Null   


		Endtry

	Endproc && Articulos



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oImportarMaestros
*!*
*!* ///////////////////////////////////////////////////////



