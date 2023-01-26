#INCLUDE "FW\TierAdapter\Include\TA.h"
#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\eMail\Include\eMail.h"

*
* Actualizacion de Cuentas de Mail
Procedure MailAccount(  ) As Void;
		HELPSTRING "Actualizacion de MailAccounts"

	Local lcCommand As String,;
		lcTitulo As String

	Local loReturn As Object
	Local loParam As Object
	Local loMailAccount As MailAccount Of 'Fw\Comunes\Prg\MailAccount.prg'

	Try

		lcCommand = ""

		loMailAccount = GetEntity( "MailAccount" )
		loMailAccount.GetAll( loParam )

		TEXT To lcTitulo NoShow TextMerge Pretext 15
		Terminal: [<<loMailAccount.cTerminal>>] - Usuario Windows: [<<loMailAccount.cWinUser>>]
		ENDTEXT

		loParam = Createobject( "Empty" )
		AddProperty( loParam, "cAlias", loMailAccount.cMainCursorName )
		AddProperty( loParam, "cTitulo", lcTitulo )
		AddProperty( loParam, "oBiz", loMailAccount )
		AddProperty( loParam, "cPKField", loMailAccount.cPKField )

		Do Form 'Fw\Comunes\scx\MailAccounts.scx' ;
			With loParam To loReturn

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally
		If Vartype( loParam ) = "O"
			If Pemstatus( loParam, "oBiz", 5 )
				loParam.oBiz	= Null
			Endif
		Endif

		loParam 		= Null
		oParam 			= Null
		loReturn 		= Null
		loMailAccount 	= Null

		Close Databases All

	Endtry

Endproc && MailAccount


Define Class MailAccount As Entidad Of "V:\Clipper2fox\Rutinas\Prg\prxEntidad.prg"

	#If .F.
		Local This As MailAccount Of 'Fw\Comunes\Prg\MailAccount.prg'
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="encriptarclave" type="method" display="EncriptarClave" />] + ;
		[<memberdata name="desencriptarclave" type="method" display="DesencriptarClave" />] + ;
		[<memberdata name="getdefault" type="method" display="GetDefault" />] + ;
		[<memberdata name="test" type="method" display="Test" />] + ;
		[</VFPData>]


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: HookBeforeInitialize
	*!* Description...:
	*!* Date..........: Domingo 7 de Julio de 2013 (16:34:20)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Clipper2Fox
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure HookBeforeInitialize( ) As Boolean

		Local lcCommand As String

		Try

			lcCommand = ""

			* Alias de la Tabla
			This.cMainTableName 	= "MailAccounts"

			* Alias del cursor transitorio
			This.cMainCursorName 	= "cMailAccounts"

			* Campo clave
			This.cPKField			= "Account_Id"

			* Carpeta donde se encuentra la Tabla
			This.cTableFolder 		= drComun

			* Nombre real de la tabla
			This.cRealTableName 	= "MailAccounts"

			* Cantidad de Indices IDX
			This.nIndices = 0



		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally


		Endtry


	Endproc
	*!*
	*!* END Procedure HookBeforeInitialize
	*!*
	*!* ///////////////////////////////////////////////////////

	*
	* Abre las tablas necesarias
	Procedure xxxAbrirTabla(  ) As Void;
			HELPSTRING "Abre las tablas necesarias"
		Local lcCommand As String,;
			lcAlterTable As String

		Local oErr As Exception

		Try

			lcCommand = ""

			If !Used( This.cMainTableName )
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Use <<Addbs( This.cTableFolder )>><<This.cRealTableName>> Shared In 0 Alias <<This.cMainTableName>>
				ENDTEXT

				Try

					&lcCommand

				Catch To oErr
					If oErr.ErrorNo = 1 && File 's:\fenix\dbf\dbf\MailAccounts.dbf' does not exist.

						TEXT To lcAlterTable NoShow TextMerge Pretext 15
						Create Table <<Addbs( This.cTableFolder )>><<This.cRealTableName>> Free (
							Account_Id I,
							Nombre C(40),
							UserName C(40),
							Password C(40),
							Server C(40),
							ServerPort I,
							UseSsl I,
							Default I,
							Authentica I,
							Codigo C(10) )
						ENDTEXT

						&lcAlterTable

						Index On Account_Id Tag Id Candidate
						Index On Upper( Nombre ) Tag Nombre

						Use In Select( This.cRealTableName )

						&lcCommand

					Else
						Throw oErr

					Endif

				Finally

				Endtry


			Endif


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && AbrirTabla



	*
	* Trae la cuenta predeterminada
	Procedure GetDefault( oParam As Object ) As Void;
			HELPSTRING "Trae la cuenta predeterminada"
		Local lcCommand As String,;
			lcFilterCriteria As String

		Local lnTally As Integer
		Local loParam As Object

		Try

			lcCommand = ""

			TEXT To lcCommand NoShow TextMerge Pretext 15
			cFilterCriteria = "Default = 1"
			ENDTEXT

			loParam = ObjParam( lcCommand, oParam )

			lnTally = This.GetByWhere( loParam )

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			oParam = Null
			loParam = Null

		Endtry

		Return lnTally

	Endproc && GetDefault


	*
	* Trae los elementos filttrados por alguna condicion
	* oParam.cFilterCriteria = Criterio de Filtro
	* oParam.cOrderBy = Clausula de Ordenamiento
	* oParam.cFieldList = Lista de Campos
	* oParam.cJoins = Joins
	* oParam.nLevel = Nivel de profundidad que trae
	* oParam.cAlias = Alias alternativo a This.cMainCursorName

	Procedure GetByWhere( oParam As Object ) As Integer;
			HELPSTRING "Trae los elementos filttrados por alguna condicion"

		Local lcCommand As String,;
			lcAlias As String,;
			lcFilterCriteria As String,;
			lcParentFilter As String,;
			lcOrderBy As String,;
			lcFieldList As String,;
			lcJoins As String

		Local lnLevel As Integer

		Local loParent As PrxEntity Of "Fw\TierAdapter\Comun\prxEntity.prg"
		Local lnTally As Integer

		Try

			lcCommand = ""

			If Vartype( oParam ) # "O"
				oParam = Createobject( "Empty" )
			Endif

			If !Pemstatus( oParam, "cOrderBy", 5 )
				AddProperty( oParam, "cOrderBy" )
			Endif

			oParam.cOrderBy = "Nombre"

			lnTally = DoDefault( oParam )

			If !Empty( lnTally )

				Locate
				Scan
					Replace Password With This.DesencriptarClave( Password, UserName, Codigo )
				Endscan

				Locate

			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			oParam = Null

		Endtry

		Return lnTally

	Endproc && GetByWhere

	*
	* Guarda las modificaciones realizadas a una entidad
	Procedure GuardarVarios( oParam As Object ) As Boolean ;
			HELPSTRING "Guarda las modificaciones realizadas a una entidad"
		Local lcCommand As String
		Local llOk As Boolean
		Local lnId As Integer
		Local loClave As Object

		Try

			lcCommand = ""
			llOk = .F.

			If Empty( This.nAction )
				This.nAction = TR_UPDATE
			Endif

			If IsEmpty( oParam )
				oParam = This.oRequery
			Endif

			If This.Validar()

				lnId = GetMaxId( This.cMainCursorName, This.cPKField )

				Select Alias( This.cMainCursorName )
				Locate

				Scan For Evaluate( This.cPKField ) < 1
					lnId = lnId + 1

					Replace ( This.cPKField ) With lnId

				Endscan

				Locate
				Scan
					loClave = This.EncriptarClave( Password,;
						UserName )

					Replace Password With loClave.Texto,;
						Codigo With loClave.Mascara

				Endscan

				TEXT To lcCommand NoShow TextMerge Pretext 15
				nEntidadId = <<This.nEntidadId>>
				ENDTEXT

				oParam = ObjParam( lcCommand, oParam )

				llOk = This.GrabarCambios( oParam )

				This.nAction = 0

			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			This.nAction = 0

		Endtry

		Return llOk

	Endproc && Guardar

	*
	*
	Procedure EncriptarClave( cClave As String,;
			cUserName As String ) As Object

		Local lcCommand As String,;
			lcMascara As String

		Local loReturn As Object,;
			loPaso1 As Object

		Try

			lcCommand 	= ""
			lcMascara 	= Sys(2015)

			loPaso1 	= Ofuscar( lcMascara, cUserName, .T. )
			loReturn 	= Ofuscar( cClave, loPaso1.Texto, .T. )

			loReturn.Mascara = lcMascara

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return loReturn

	Endproc && EncriptarClave



	*
	*
	Procedure DesencriptarClave( cClave As String,;
			cUserName As String,;
			cMascara As String ) As String

		Local lcCommand As String,;
			lcReturn As String

		Local loPaso1 As Object,;
			loPaso2 As Object

		Try

			lcCommand = ""

			loPaso1 = Ofuscar( cMascara, cUserName, .T. )
			loPaso2 = Ofuscar( cClave, loPaso1.Texto, .F. )

			lcReturn = loPaso2.Texto

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcReturn

	Endproc && DesencriptarClave



	*
	*
	Procedure Test( oReg As Object, cTo as String ) As Void
		Local lcCommand As String,;
			lcSubject As String,;
			lcTextBody As String

		Local lnServerPort As Integer,;
			lnAuthenticate As Integer

		Local llUseSSL As Boolean

		Local loMail As oEMail Of "Tools\Email\Prg\prxSmtp.prg"

		Try

			lcCommand = ""
			loMail = Newobject( "oEMail", "Tools\Email\Prg\prxSmtp.prg" )

			lcSubject	= "Prueba de Mail"

			TEXT To lcTextBody NoShow TextMerge Pretext 03
			Esta es una prueba de envío de Mail.

			No responda al mismo
			ENDTEXT

			loMail.cServer 			= Alltrim( oReg.Server )
			loMail.nServerPort 		= oReg.ServerPort
			loMail.lUseSSL 			= ( oReg.UseSSL = 1 )

			loMail.nAuthenticate 	= oReg.Authentica
			loMail.cUserName 		= Alltrim( oReg.UserName )
			loMail.cPassword 		= Alltrim( oReg.Password )

			loMail.cFrom 			= Alltrim( oReg.Mostrar ) + "<" + loMail.cUserName + ">"
			loMail.cTo 				= Alltrim( cTo )
			loMail.cReplyTo 		= oReg.ReplyTo
			loMail.lReadReceipt 	= ( oReg.ReadReceip = 1 )
			loMail.cSubject 		= lcSubject
			loMail.cTextBody 		= lcTextBody

			loMail.Send()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loMail = Null

		Endtry

	Endproc && Test

Enddefine




*!* ///////////////////////////////////////////////////////
*!* Class.........: CboMailAccounts
*!* ParentClass...: ComboBox
*!* BaseClass.....: ComboBox
*!* Description...: MailAccounts
*!* Date..........: Domingo 15 de Abril de 2012 (12:19:45)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class CboMailAccounts As ComboBox

	#If .F.
		Local This As CboMailAccounts Of 'Fw\Comunes\Prg\MailAccount.prg'
	#Endif

	BoundColumn 	= 2
	BoundTo 		= .T.
	ColumnCount 	= 1
	RowSourceType 	= 0
	RowSource 		= ""
	Style			= 2
	Sorted 			= .T.


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	Procedure Init()
		Local lcCommand As String

		Local loMailAccount As MailAccount Of 'Fw\Comunes\Prg\MailAccount.prg'

		Try

			lcCommand = ""
			loMailAccount = GetEntity( "MailAccount" )
			loMailAccount.GetAll()

			Select Alias( loMailAccount.cMainCursorName )
			Locate

			Scan
				This.AddItem( Evaluate( loMailAccount.cMainCursorName + ".Descripcion" ))
				This.List( This.NewIndex, 2 ) = Transform( Evaluate( loMailAccount.cMainCursorName + ".PrinterId" ))
			Endscan

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally
			loMailAccount = Null

		Endtry

	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: CboMailAccounts
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: cboAuthenticate
*!* ParentClass...: ComboBox
*!* BaseClass.....: ComboBox
*!* Description...: MailAccounts
*!* Date..........: Domingo 15 de Abril de 2012 (12:19:45)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class cboAuthenticate As ComboBox

	#If .F.
		Local This As cboAuthenticate Of 'Fw\Comunes\Prg\MailAccount.prg'
	#Endif

	BoundColumn 	= 2
	BoundTo 		= .T.
	ColumnCount 	= 1
	RowSourceType 	= 0
	RowSource 		= ""
	Style			= 2
	Sorted 			= .T.


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	Procedure Init()
		Local lcCommand As String

		Try

			lcCommand = ""

			* Authenticate
			* #Define cdoAnonymous 0	&& Perform no authentication (anonymous)
			* #Define cdoBasic 1	&& Use the basic (clear text) authentication mechanism.
			* #Define cdoSendUsingPort 2	&& Send the message using the SMTP protocol over the network.

			This.AddItem( "Anónimo" )
			This.List( This.NewIndex, 2 ) = "0"

			This.AddItem( "Básico" )
			This.List( This.NewIndex, 2 ) = "1"

			This.AddItem( "Usuario" )
			This.List( This.NewIndex, 2 ) = "3"


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
			loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: cboAuthenticate
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ChkDefault
*!* ParentClass...: CheckBox
*!* BaseClass.....: CheckBox
*!* Description...:
*!* Date..........: Viernes 16 de Agosto de 2013 (16:11:30)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ChkDefault As Checkbox

	#If .F.
		Local This As ChkDefault Of "V:\Clipper2fox\Fw\Comunes\Prg\MailAccount.prg"
	#Endif

	Caption = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: ChkDefault
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: ChkDefault
*!* ParentClass...: CheckBox
*!* BaseClass.....: CheckBox
*!* Description...:
*!* Date..........: Viernes 16 de Agosto de 2013 (16:11:30)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class chkPredeterminada As Checkbox

	#If .F.
		Local This As chkPredeterminada Of "V:\Clipper2fox\Fw\Comunes\Prg\MailAccount.prg"
	#Endif

	Caption = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*
	*
	Procedure InteractiveChange(  ) As Void
		Local lcCommand As String,;
			lcCursorName As String
		Local lnRecno As Integer

		Try

			lcCommand = ""

			If This.Value = 1
				lcCursorName = Thisform.Grid.cCursorDeTrabajo
				lnRecno = Recno( lcCursorName )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update <<lcCursorName>> Set
					Default = 0
				ENDTEXT

				&lcCommand

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Goto <<lnRecno>> In <<lcCursorName>>
				ENDTEXT

				&lcCommand

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Replace Default With 1 In <<lcCursorName>>
				ENDTEXT

				&lcCommand


			Else
				This.Value = 1

			Endif

			Thisform.Grid.Refresh()


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && InteractiveChange


Enddefine
*!*
*!* END DEFINE
*!* Class.........: chkPredeterminada
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: txtPassword
*!* ParentClass...: TextBox
*!* BaseClass.....: TextBox
*!* Description...: Ingreso de Password
*!* Date..........: Domingo 1 de Septiembre de 2013 (14:45:25)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class txtPassword As TextBox

	#If .F.
		Local This As txtPassword Of "V:\Clipper2fox\Fw\Comunes\Prg\MailAccount.prg"
	#Endif

	PasswordChar = '*'

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: txtPassword
*!*
*!* ///////////////////////////////////////////////////////