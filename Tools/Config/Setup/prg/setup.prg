PROCEDURE Setup(  nPermisos As Integer,;
		nParam2 As Integer,;
		nParam3 As Integer,;
		nParam4 As Integer,;
		nParam5 As Integer,;
		cURL As String,;
		lDoPrg ) AS Void
	Local lcCommand as String

	Try

		lcCommand = ""
		If !FileExist( "Urls.dbf" )
			Create Table Urls Free ( Id I, Alias C(30),Url C(200), Orden I )
			Index On Id Tag Id Candidate
			Index On Upper( Alias ) Tag Alias Candidate
			Use In Urls
		Endif

		Do Form "v:\CloudFox\Tools\Config\Setup\scx\Setup.scx"

		Read EVENTS


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && Setup

*!* ///////////////////////////////////////////////////////
*!* Class.........: oSetup
*!* Description...:
*!* Date..........: Martes 7 de Septiembre de 2021 (13:04:25)
*!*
*!*

Define Class oSetup As Custom

	#If .F.
		Local This As oSetup Of "Tools\Config\Setup\prg\Setup.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="loadsetup" type="method" display="LoadSetup" />] + ;
		[<memberdata name="probar" type="method" display="Probar" />] + ;
		[<memberdata name="grabar" type="method" display="Grabar" />] + ;
		[<memberdata name="editar" type="method" display="Editar" />] + ;
		[</VFPData>]



	*
	*
	Procedure LoadSetup(  ) As Object
		Local lcCommand As String
		Local loObj As Object
		Local loJson As prxJSON Of "Tools\JSON\Prg\JSON.prg"

		Try

			lcCommand = ""
			loJson = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )

			If File( "Datos\Setup.json" )
				loObj = loJson.JsonToVfp( Filetostr( "Datos\Setup.json" ))

			Else
				loObj = Createobject( "Empty" )
				AddProperty( loObj, "cURL", Space( 10 ) )

				Strtofile( loJson.VfpToJson( loObj ), "Datos\Setup.json" )

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loJson = Null

		Endtry

		Return loObj

	Endproc && LoadSetup


	*
	*
	Procedure Probar( oObj As Object ) As Void
		Local lcCommand As String
		Local loObj As Object
		Local loXmlHttp As prxXmlHttp Of "Tools\JSON\Prg\XmlHttp.prg"

		Try

			lcCommand = ""
			loXmlHttp = Newobject( "prxXmlHttp", "Tools\JSON\Prg\XmlHttp.prg" )
			loXmlHttp.cURL = Alltrim( oObj.cURL ) +  "test/"

			If loXmlHttp.Get()
				loObj = loXmlHttp.oVFP.Data
				Inform( loObj.Mensaje, loXmlHttp.cURL )

			Else
				TEXT To lcMsg NoShow TextMerge Pretext 03
				Status: <<loXmlHttp.nStatus>>

				<<loXmlHttp.cResponseText>>
				ENDTEXT

				Stop( lcMsg, "Error al Conectarse" )

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr, .T. )
			*Throw loError

		Finally
			loXmlHttp = Null

		Endtry

	Endproc && Probar

	*
	*
	Procedure Grabar( oObj As Object ) As Void
		Local lcCommand As String
		Local loObj As Object
		Local loJson As prxJSON Of "Tools\JSON\Prg\JSON.prg"

		Try

			lcCommand = ""
			loJson = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )

			Strtofile( loJson.VfpToJson( oObj ), "Datos\Setup.json" )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loJson = Null

		Endtry

	Endproc && Grabar




	*
	*
	Procedure Editar(  ) As Void
		Local lcCommand As String
		Local loStatus As Object,;
			loParam As Object,;
			loUrl As oUrl Of "Tools\Config\Setup\prg\Setup.prg"
		Local llReturn As Boolean

		Try

			lcCommand = ""
			*Stop(Program())

			loStatus = Null
			llReturn = .F.
			loUrl = Newobject( "oUrl", "Tools\Config\Setup\prg\Setup.prg" )

			Inkey()

			loParam = Createobject( "Empty" )
			AddProperty( loParam, "oBiz", loUrl )


			Do Form v:\CloudFox\Tools\Config\Setup\scx\urls.SCX With loParam To loStatus
			llReturn = ( loStatus.lCancelar = .F. )

			If llReturn
				Inform( "Ok" )

			Else
				Stop( "Cancelado" )

			Endif



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Editar





Enddefine
*!*
*!* END DEFINE
*!* Class.........: oSetup
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oUrl
*!* Description...:
*!* Date..........: Sábado 6 de Noviembre de 2021 (09:59:33)
*!*
*!*

Define Class oUrl As Entidad Of "Rutinas\Prg\prxEntidad.prg"

	#If .F.
		Local This As oUrl Of "Tools\Config\Setup\prg\Setup.prg"
	#Endif

	cMainCursorName = "cUrls"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*
	*
	Procedure AbrirTabla(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			M_Use( 0, "Urls" )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && AbrirTabla

	*
	* Repite la última consulta
	Procedure Requery( oParam As Object ) As Void;
			HELPSTRING "Repite la última consulta"
		Local lcCommand As String

		Local lnTally As Integer
		Local loReturn As Object

		Try

			lcCommand = ""
			If Vartype( oParam ) = "O"
				This.oRequery = oParam
			Endif

			loReturn 	= This.GetByWhere( This.oRequery )
			lnTally 	= loReturn.nTally

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return lnTally

	Endproc && Requery



	*
	*
	Procedure GetByWhere( oParam As Object ) As Object
		Local lcCommand As String,;
			lcAlias As String

		Local loReturn As Object

		Try

			lcCommand = ""

			loReturn = Createobject( "Empty" )
			AddProperty( loReturn, "nTally", 0 )
			AddProperty( loReturn, "oRegistro", Null )
			AddProperty( loReturn, "oData", Null )
			AddProperty( loReturn, "cAlias", "" )

			lcAlias = This.cMainCursorName


			M_Use( 0, "Urls" )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select 	*,
					Space( 1 ) as r7Mov,
					Cast( 0 as I ) as ABM,
					Cast( Recno() as I ) as _RecordOrder
				From Urls
				Where !Deleted()
				Order By Orden,Alias
				Into Cursor <<lcAlias>> ReadWrite
			ENDTEXT

			&lcCommand
			lcCommand = ""

			loReturn.nTally = _Tally
			loReturn.cAlias = lcAlias

			CursorSetProp( "Buffering", 5, lcAlias )



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		EndTry

		Return loReturn

	Endproc && GetByWhere


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oUrl
*!*
*!* ///////////////////////////////////////////////////////

