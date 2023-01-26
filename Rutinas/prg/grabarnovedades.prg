#INCLUDE "FW\Comunes\Include\Praxis.h"

Lparameters cAbm As Character,;
	cDestinationFolder As String,;
	lSilence As Boolean,;
	cAlias As String,;
	cReferencia As String,;
	oParam As Object

Local lcCommand As String

Local loGrabarNovedades As oGrabarNovedades Of "Rutinas\GrabarNovedades.prg",;
	loParametros As Object

Local llReturn As Boolean

Try

	lcCommand = ""
	llReturn = .T.

	If Vartype( cAbm ) # "C"
		cAbm = "M"
	Endif

	If Empty( cAbm )
		cAbm = "M"
	Endif

	If Vartype( cDestinationFolder ) # "C"
		cDestinationFolder = ""
	Endif

	If Empty( cDestinationFolder )
		cDestinationFolder = Justpath( CursorGetProp("SourceName", Alias() ) )
	Endif

	If Vartype( lSilence ) # "L"
		lSilence = .F.
	Endif

	If Vartype( cAlias ) # "C"
		cAlias = ""
	Endif

	If Vartype( cReferencia ) # "C"
		cReferencia = ""
	Endif

	loParametros = Createobject( "Empty" )
	AddProperty( loParametros, "cAbm", cAbm )
	AddProperty( loParametros, "cDestinationFolder", cDestinationFolder )
	AddProperty( loParametros, "lSilence", lSilence )
	AddProperty( loParametros, "cAlias", cAlias )
	AddProperty( loParametros, "cReferencia", cReferencia )
	AddProperty( loParametros, "oParam", oParam )

	loGrabarNovedades = NewGrabarNovedades()
	llReturn = loGrabarNovedades.Process( loParametros )

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally
	loGrabarNovedades = Null

Endtry

Return llReturn

*!* ///////////////////////////////////////////////////////
*!* Class.........: oGrabarNovedades
*!* Description...:
*!* Date..........: Viernes 17 de Enero de 2020 (10:38:14)
*!*
*!*

Define Class oGrabarNovedades As Custom

	#If .F.
		Local This As oGrabarNovedades Of "Rutinas\GrabarNovedades.prg"
	#Endif

	* Alias del archivo de novedades
	cAlias = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="calias" type="property" display="cAlias" />] + ;
		[<memberdata name="process" type="method" display="Process" />] + ;
		[<memberdata name="grabararchivodenovedades" type="method" display="GrabarArchivoDeNovedades" />] + ;
		[<memberdata name="sincronizarconlaweb" type="method" display="SincronizarConLaWeb" />] + ;
		[<memberdata name="obtenerapi" type="method" display="ObtenerAPI" />] + ;
		[</VFPData>]

	*
	*
	Procedure Process( oParametros ) As Void

		Local lcCommand As String,;
			lcAlias As String
		Local llReturn As Boolean
		Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

		Try

			lcCommand = ""
			This.cAlias = ""
			lcAlias = Alias()

			llReturn = This.GrabarArchivoDeNovedades( oParametros )

			loGlobalSettings = NewGlobalSettings()

			If loGlobalSettings.lIntegracionWeb
				llReturn = This.SincronizarConLaWeb( oParametros )
				If llReturn
					Select Alias( This.cAlias )
					M_IniAct( 52 )
					Replace EnNube With .T.
					Unlock

				Else
					Select Alias( This.cAlias )

					TEXT To lcMsg NoShow TextMerge Pretext 03
					<<Ttoc( TS )>>

					Fallo al Grabar en la Nube

					WinUser: <<WinUser>>
					Terminal: <<Terminal>>
					Modulo: <<Modulo>>
					Programa: <<Programa>>
					Metodo: <<Metodo>>
					Abm: <<Abm>>
					Sucursal: <<Sucursal>>
					Empresa: <<Empresa>>
					Referencia: <<Referencia>>
					UserId: <<UserId>>
					Usuario: <<Usuario>>
					Nivel: <<Nivel>>
					EnNube: <<EnNube>>

					ENDTEXT

					Logerror( lcMsg )

				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand

			* RA 08/04/2021(09:11:48)
			* No cortar el preoceso si la novedad no se puede grabar
			loError.Process ( m.loErr, .F., .T. )
			*Throw loError

		Finally
			loGlobalSettings = Null

			If !Empty( This.cAlias )
				Use In Select( This.cAlias )
			Endif

			If !Empty( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

		Return llReturn

	Endproc && Process



	*
	*
	Procedure GrabarArchivoDeNovedades( oParametros ) As Void

		Local lcCommand As String

		Local lcAlias As String,;
			lcFile As String,;
			lcFolder As String,;
			lcFullFileName As String,;
			lcEmpresa As String,;
			lcOldAlias As String

		Local loNovedad As Object,;
			loParam As Object

		Local lnSucursal As Integer

		Local lnAction As Integer

		Local oErr As Exception
		Local llReturn As Boolean


		Try

			lcCommand = ""
			llReturn = .T.
			This.cAlias = ""

			lcOldAlias 	= Alias()

			If Vartype( oParametros ) # "O"
				oParametros = Createobject( "Empty" )
			Endif

			If !Pemstatus( oParametros, "cAbm", 5 )
				AddProperty( oParametros, "cAbm", "M" )
			Endif

			If Empty( oParametros.cAbm )
				oParametros.cAbm = "M"
			Endif

			If !Pemstatus( oParametros, "cDestinationFolder", 5 )
				AddProperty( oParametros, "cDestinationFolder", "" )
			Endif

			If Empty( oParametros.cDestinationFolder )
				oParametros.cDestinationFolder = Justpath( CursorGetProp("SourceName", Alias() ) )
			Endif

			If !Pemstatus( oParametros, "lSilence", 5 )
				AddProperty( oParametros, "lSilence", .F. )
			Endif

			If !Pemstatus( oParametros, "cAlias", 5 )
				AddProperty( oParametros, "cAlias", "" )
			Endif

			If !Pemstatus( oParametros, "cReferencia", 5 )
				AddProperty( oParametros, "cReferencia", "" )
			Endif

			If !Empty( oParametros.cAlias )
				If Used( oParametros.cAlias )
					Select Alias( oParametros.cAlias )
				Endif
			Endif

			lcAlias = Juststem( CursorGetProp("SourceName", Alias() ) )

			If !Pemstatus( oParametros, "oParam", 5 )
				AddProperty( oParametros, "oParam", Createobject( "Empty" ) )
			Endif

			If Vartype( oParametros.oParam ) # "O"
				oParametros.oParam = Createobject( "Empty" )
			Endif

			loParam = oParametros.oParam

			If !Pemstatus( loParam, "Modulo", 5 )
				AddProperty( loParam, "Modulo", Program( 1 ) )
			Endif

			If !Pemstatus( loParam, "Programa", 5 )
				AddProperty( loParam, "Programa", Program( Iif( Program( -1 ) > 6, 6, 1 )) )
			Endif

			If !Pemstatus( loParam, "Metodo", 5 )
				AddProperty( loParam, "Metodo", Program( Program( -1 ) - 1 ) )
			Endif

			lnSucursal 	= GetValue( "Sucu0", "ar0Est", 0 )
			lcEmpresa	= GetValue( "Nomb0", "ar0Est", "" )

			If Empty( oParametros.cDestinationFolder )
				lcFolder 	= Justpath( CursorGetProp("SourceName", Alias() ) )

			Else
				lcFolder 	= Alltrim( oParametros.cDestinationFolder )

			Endif


			If Lower( Substr( lcAlias, 1, 2 )) = "ar"
				lcFile = "nv" + Substr( lcAlias, 3 )

			Else
				lcFile = "nv" + lcAlias

			Endif

			This.cAlias = lcFile

			lcFullFileName = Addbs( lcFolder ) + lcFile + ".dbf"

			Scatter Memo Name loNovedad

			If !FileExist( lcFullFileName )
				Afields( laFields )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Create Table '<<lcFullFileName>>' Free From Array laFields
				ENDTEXT

				&lcCommand

				Use In Select( lcFile )

				Do While !&Aborta
					Try

						TEXT To lcCommand NoShow TextMerge Pretext 15
						Use '<<lcFullFileName>>' Exclusive In 0
						ENDTEXT

						&lcCommand
						lcCommand = ""

						Exit

					Catch To oErr
						Inkey( 1 )
						prxLastkey()

					Finally

					Endtry
				Enddo

				If Used( lcFile )
					If Empty( Field( "TS", lcFile ))
						TEXT To lcCommand NoShow TextMerge Pretext 15
						Alter Table <<lcFile>>
							Add Column TS T
						ENDTEXT

						&lcCommand
						lcCommand = ""

					Endif
				Endif

			Else
				* RA 2014-08-02(14:33:26)
				* Sincronizar Tablas

				lnAction = Sync_Nuevos + Sync_Modificados + Sync_Confirma

				SynchronizeTables( lcFullFileName,;
					Alias(),;
					"",;
					lnAction,;
					oParametros.lSilence )

			Endif

			Use In Select( lcFile )


			TEXT To lcCommand NoShow TextMerge Pretext 15
			Use '<<lcFullFileName>>' Shared In 0
			ENDTEXT

			&lcCommand

			If FileSize( Forceext( lcFullFileName, "dbf" ), "M" ) > 1300
				TEXT To lcMsg NoShow TextMerge Pretext 03
				El archivo <<lcFile>> es demasiado grande

				Avise a Praxis
				ENDTEXT

				Do Form ErrorMessage With lcMsg

			Endif


			Select Alias( lcFile )

			Try

				Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"

				loUser = NewUser()

				M_IniAct( 51 )
				Gather Name loNovedad Memo
				Replace TS 		With Datetime(),;
					WinUser 	With Alltrim( Getwordnum( Sys(0), 2, "#" )),;
					Terminal 	With Alltrim( Getwordnum( Sys(0), 1, "#" )),;
					Modulo  	With loParam.Modulo,;
					Programa  	With loParam.Programa,;
					Metodo  	With loParam.Metodo,;
					Abm			With oParametros.cAbm,;
					Sucursal	With lnSucursal,;
					Empresa		With lcEmpresa,;
					Referencia	With oParametros.cReferencia,;
					UserId		With loUser.Id,;
					Usuario		With loUser.Nombre,;
					Nivel		With loUser.Clave,;
					EnNube		With .F.

				Unlock

			Catch To oErr
				Do Case
					Case oErr.ErrorNo = 12 && No se encuentra la variable
						Delete
						Use In Select( lcFile )

						Do While !&Aborta

							Try

								TEXT To lcCommand NoShow TextMerge Pretext 15
								Use '<<lcFullFileName>>' Exclusive In 0
								ENDTEXT

								&lcCommand

								Exit

							Catch To oErr
								Inkey( 1 )
								prxLastkey()

							Finally

							Endtry

						Enddo

						If Used( lcFile )



							Select Alias( lcFile )

							If Empty( Field( "TS", lcFile ))
								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column TS T
								ENDTEXT

								&lcCommand

							Endif

							If Empty( Field( "WinUser", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column WinUser C(20)
								ENDTEXT

								&lcCommand

							Endif

							If Empty( Field( "Terminal", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column Terminal C(20)
								ENDTEXT

								&lcCommand

							Endif

							If Empty( Field( "Modulo", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column Modulo C(20)
								ENDTEXT

								&lcCommand
							Endif

							If Empty( Field( "Programa", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column Programa C(20)
								ENDTEXT

								&lcCommand

							Endif

							If Empty( Field( "Metodo", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column Metodo C(20)
								ENDTEXT

								&lcCommand

							Endif

							If Empty( Field( "Abm", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column Abm C(1)
								ENDTEXT

								&lcCommand

							Endif

							If Empty( Field( "Sucursal", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column Sucursal I
								ENDTEXT

								&lcCommand

							Endif

							If Empty( Field( "Empresa", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column Empresa C(30)
								ENDTEXT

								&lcCommand
							Endif

							If Empty( Field( "Referencia", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column Referencia C(200)
								ENDTEXT

								&lcCommand
							Endif

							If Empty( Field( "Usuario", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column Usuario C(40)
								ENDTEXT

								&lcCommand

							Endif

							If Empty( Field( "UserId", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column UserId I
								ENDTEXT

								&lcCommand

							Endif

							If Empty( Field( "Nivel", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column Nivel I
								ENDTEXT

								&lcCommand

							Endif

							If Empty( Field( "EnNube", lcFile ))

								TEXT To lcCommand NoShow TextMerge Pretext 15
							Alter Table <<lcFile>>
								Add Column EnNube L
								ENDTEXT

								&lcCommand

							Endif

							Go Bottom

							M_IniAct( 51 )
							Gather Name loNovedad Memo
							Replace TS 		With Datetime(),;
								Usuario 	With Alltrim( Getwordnum( Sys(0), 2, "#" )),;
								Terminal 	With Alltrim( Getwordnum( Sys(0), 1, "#" )),;
								Modulo  	With loParam.Modulo,;
								Programa  	With loParam.Programa,;
								Metodo  	With loParam.Metodo,;
								Abm			With oParametros.cAbm,;
								Sucursal	With lnSucursal,;
								Empresa		With lcEmpresa,;
								Referencia	With oParametros.cReferencia,;
								UserId		With loUser.Id,;
								Usuario		With loUser.Nombre,;
								Nivel		With loUser.Clave,;
								EnNube		With .F.

						Endif

					Otherwise
						Throw oErr

				Endcase


			Catch To loErr
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = lcCommand
				loError.Process ( m.loErr )
				Throw loError

			Finally

			Endtry

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loNovedad = Null
			If Used( lcOldAlias )
				Select Alias( lcOldAlias )
			Endif

		Endtry

		Return llReturn

	Endproc && GrabarArchivoDeNovedades



	*
	*
	Procedure SincronizarConLaWeb( oParametros ) As Boolean

		Local lcCommand As String
		Local lcAlias As String,;
			lcAction As String,;
			lcOldAlias As String,;
			lcAPI As String

		Local loConsumirApi As ConsumirAPI Of "Tools\JSON\Prg\XmlHttp.prg",;
			loNovedad As Object,;
			loRespuesta  As Object,;
			loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

		Local lnId As Integer,;
			lnParent_Id As Integer

		Try

			lcCommand = ""

			lcOldAlias 	= Alias()
			loGlobalSettings = NewGlobalSettings()

			Do Case
				Case oParametros.cAbm = "A"
					lcAction = "CREATE"

				Case oParametros.cAbm = "B"
					lcAction = "DELETE"

				Case oParametros.cAbm = "M"
					lcAction = "UPDATE"

				Case oParametros.cAbm = "C"
					lcAction = "RETRIEVE"

			Endcase

			loRespuesta = Createobject( "Empty" )
			AddProperty( loRespuesta, "lOk", .T. )

			If !Empty( oParametros.cAlias )
				If Used( oParametros.cAlias )
					Select Alias( oParametros.cAlias )
				Endif
			Endif

			Scatter Memo Name loNovedad

			lcAlias = Juststem( CursorGetProp("SourceName", Alias() ) )
			If !Used( lcAlias )
				lcAlias = Alias()
			Endif

			lnId = 0
			loConsumirApi = NewConsumirApi()

			lcAPI 		= loConsumirApi.ObtenerAPI( lcAlias )

			If !Empty( lcAPI )

				loRespuesta = loConsumirApi.&lcAPI.( lcAction, loNovedad )

				If loRespuesta.lOk
					If lcAction # "DELETE"

						lnId = loRespuesta.Data.Id
						If Pemstatus( loRespuesta.Data, "parent_id", 5 )
							lnParent_Id = loRespuesta.Data.parent_id

						Else
							lnParent_Id = 0

						Endif
						lnParent_Id = Nvl( lnParent_Id, 0 )
						*!*						Endif

						*!*						If InList( lcAction, "CREATE", "UPDATE", "RETRIEVE" )
						Select Alias( lcAlias )
						If !Empty( lnId ) And !Empty( Field( "Web_Id" ))
							If Seek( loNovedad.Id, lcAlias, "Id" )
								M_IniAct( 52 )
								Replace Web_Id With lnId
								Unlock

								Select Alias( This.cAlias )
								M_IniAct( 52 )
								Replace Web_Id With lnId
								Unlock

							Endif
						Endif

						Select Alias( lcAlias )
						If !Empty( lnParent_Id ) And !Empty( Field( "Web_Parent" ))
							If Seek( loNovedad.Id, lcAlias, "Id" )
								M_IniAct( 52 )
								Replace Web_Parent With lnParent_Id
								Unlock

								Select Alias( This.cAlias )
								M_IniAct( 52 )
								Replace Web_Parent With lnParent_Id
								Unlock

							Endif
						Endif

					Endif

				Else
					TEXT To lcMsg NoShow TextMerge Pretext 03
					<<loRespuesta.cErrorMessage>>
					ENDTEXT

					Warning( lcMsg )

					Logerror( lcMsg )

					If Empty( loRespuesta.nStatus )
						loGlobalSettings.lIntegracionWeb = .F.
					Endif

				Endif
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			If Used( lcOldAlias )
				Select Alias( lcOldAlias )
			Endif

		Endtry

		Return loRespuesta.lOk

	Endproc && SincronizarConLaWeb

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oGrabarNovedades
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oDummy
*!* Description...:
*!* Date..........: Viernes 17 de Enero de 2020 (10:58:54)
*!*
*!*

Define Class oDummy As oGrabarNovedades Of "Rutinas\GrabarNovedades.prg"

	#If .F.
		Local This As oDummy Of "Rutinas\GrabarNovedades.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*
	*
	Procedure Process( oParametros ) As Void

		Local lcCommand As String

		Try

			lcCommand = ""
			* RA 17/01/2020(11:00:19)
			* No hace nada
			* Se utiliza para GetValue( "GrabNov0", "ar0var", "S" ) = "N"


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Process


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oDummy
*!*
*!* ///////////////////////////////////////////////////////

