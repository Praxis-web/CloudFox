#INCLUDE "FW\Comunes\Include\Praxis.h"

Lparameters tcDbf As String

Local lnRCnt As Integer,;
	i As Integer,;
	iQ As Integer,;
	lnLen As Integer

Local loMenu As Collection,;
	loParent As Collection,;
	loMAux As Collection

Local llAdd As Boolean
Local lcRet As String,;
	lcFolder As String,;
	lcParentKey As String,;
	lcKey As String,;
	lcLetra As String

Local loMenu As ColMenu Of fw\comunes\prg\menuloader.prg
Local loUser As Usuarios Of "Clientes\Archivos2\Prg\Usuarios.prg"
	Local lcGroupField As String,;
		lcUserField As String



Try

	lcRet = ""

	Use In Select( 'mnu' )
	Use (tcDbf) Shared Again In 0 Alias mnu


	* RA 2014-03-15(09:06:30)
	* Versión Nueva, con accesos personalizados por Grupo y Usuario

	loMenu = Createobject( 'ColMenu' )
	loUser = NewUser()

	lcUserField 	= "u" + StrZero( loUser.nId, 4 )
	lcGroupField 	= "g" + StrZero( loUser.nGroupId, 4 )

	* RA 2014-03-15(09:24:10)
	* Verificar la estrucrura del archivo para el Grup/Usuario logueado
	loMenu.UpsizeMnu( lcGroupField, lcUserField, tcDbf )

	TEXT To lcCommand NoShow TextMerge Pretext 15
		Select 	Id,
				Descrip,
				Nombre,
				Folder,
				Prm1,
				Prm2,
				Prm3,
				Prm4,
				Prm5,
				DoPrg,
				<<lcGroupField>>,
				<<lcUserField>>
			From mnu
			Where ( <<lcGroupField>> = 1 And <<lcUserField>> # 0 )
					Or <<lcUserField>> = 1
			Order By Id
			Into Cursor cMenu ReadWrite

	ENDTEXT

	&lcCommand

	loMenu.nNivel = 1
	* Preservar la "S" para "Sistema"
	loMenu.oColAccessKey.Add( "S", "S" )


	Select cMenu
	Locate

	Scan

		llAdd 	= .T.


		loItem 	= Createobject( 'ColMenu' )

		loItem.cNombre 		= Alltrim( cMenu.Descrip )
		loItem.cPrograma 	= Alltrim( cMenu.Nombre )
		loItem.cFolder 		= Alltrim( cMenu.Folder )

		*
		loItem.nParam1 	= cMenu.Prm1
		loItem.nParam2 	= cMenu.Prm2
		loItem.nParam3 	= cMenu.Prm3
		loItem.nParam4 	= cMenu.Prm4
		loItem.nParam5 	= cMenu.Prm5
		loItem.lDoPrg 	= cMenu.DoPrg


		* FormType
		Try

			loItem.nFormType = cMenu.FormType

		Catch To oErr
			loItem.nFormType = 0

		Finally

		Endtry

		lcKey	= Alltrim( cMenu.Id )
		loItem.cKeyName = lcKey

		Try

			lnLen = Len( lcKey )

			lcParentKey = Substr( lcKey, 1, lnLen - 1 )

			If Empty( lcParentKey )
				loParent = loMenu

			Else

				loParent = loMenu

				For i = 1 To lnLen - 1
					lcParentKey = Substr( lcKey, 1, i )
					loMAux = loParent.Item[ lcParentKey ]
					loParent = loMAux
				Endfor

			Endif


		Catch To oErr

			If oErr.ErrorNo = 2061 && Index or expression does not match an existing member of the collection.
				llAdd = .F.

			Else
				Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

				loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
				loError.Process( oErr )
				Throw loError

			Endif

		Finally

		Endtry

		If llAdd

			loItem.oParent = loParent
			loItem.nNivel = loParent.nNivel + 1
			loParent.Add( loItem, lcKey )

			llOk = .F.
			iQ = 1
			lnLen = Len( loItem.cNombre )

			Do While ! llOk And iQ < lnLen

				Try
					lcLetra = Substr( loItem.cNombre, iQ, 1 )
					If ! Empty( lcLetra )
						loParent.oColAccessKey.Add( lcLetra, Upper( lcLetra ) )
						loItem.cAccessKey = lcLetra
						loItem.nAccessKeyIndex = iQ
						llOk = .T.

					Else
						Error ''

					Endif &&  ! Empty( lcLetra )

				Catch To oErr
					iQ = iQ + 1

				Endtry

			Enddo

			loItem.nIndex = loParent.Count

		Endif

	Endscan


	lcRet = loMenu.Render()

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loError = Null
	Use In Select( 'mnu' )
	Use In Select( "cMenu" )

Endtry



Return lcRet




Define Class ColMenu As Collection
	#If .F.
		Local This As ColMenu Of fw\comunes\prg\menuloader.prg
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="upsizemnu" type="method" display="UpsizeMnu" />] + ;
		[</VFPData>]



	oColAccessKey = Null
	oParent = Null
	cNombre = ''
	cPrograma = ''
	nParam1 = 0
	nParam2 = 0
	nParam3 = 0
	nParam4 = 0
	nParam5 = 0
	lDoPrg	= .F.
	nFormType = 0

	nIndex = 0
	cID = ''
	cMnuName = ''
	cAccessKey = ''
	nAccessKeyIndex = 0
	cFolder = ""
	nNivel = 0
	cKeyName = ""

	Procedure Init() As VOID
		DoDefault()
		This.cID = Sys( 2015 )
		This.cMnuName = 'mnu' + This.cID
		This.oColAccessKey = Createobject( 'Collection' )

	Endproc

	Procedure Destroy() As VOID
		This.oParent = Null
		This.oColAccessKey = Null
		DoDefault()

	Endproc &&  Destroy

	Procedure Render()
		Local lcRet As String
		Local lcTraceLogin As String
		Local i As Integer
		Local loColMenu As ColMenu Of fw\comunes\prg\menuloader.prg

		Try

			lcTraceLogin = ""
			lcRet = ""

			For i = 1 To This.Count
				loColMenu = This.Item[ i ]

				Try
					lcRet = lcRet + loColMenu.DefinePad() + Chr( 13 )

				Catch To oErr
					lcTraceLogin = lcTraceLogin + Chr( 13 ) ;
						+ 'Item:' + Transform( i ) + Chr( 13 ) ;
						+ 'Nivel:' + Transform( loColMenu.nNivel )

					loError.Process( oErr )
					Throw loError

				Finally
				Endtry

			Endfor

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cTraceLogin = lcTraceLogin
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcRet

	Endproc

	Procedure DefinePad()

		Local lcCommand As String
		Local lcNombre As String
		Local lcRet As String
		Local lcCommandAction As String
		Local lcTraceLogin As String
		Local lcExecute As String
		Local i As Integer,;
			nFormType As Integer
		Local llDoPrg As Boolean

		Try

			lcTraceLogin = ""
			lcRet = ""
			lcExecute = ""
			llDoPrg = .F.
			nFormType = 0

			If ! Empty( This.cAccessKey )
				lcNombre = Strtran( This.cNombre, This.cAccessKey, '\<'  + This.cAccessKey, 1, 1, 2 )

			Else
				lcNombre = This.cNombre

			Endif

			If Empty( This.cPrograma )

				TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Pad pad<<This.cId>> Of _Msysmenu
					Prompt "<<lcNombre>>"
					Color Scheme 3
					<<Iif( ! Empty( This.cAccessKey ), [KEY Alt+] + This.cAccessKey + [, ""], "" )>>
					Message "<<This.cNombre>>"
				ENDTEXT

				lcRet = lcRet + lcCommand + Chr( 13 )
				lcTraceLogin = 'Ejecutando comando: ' + lcCommand
				&lcCommand

				TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					On Pad pad<<This.cId>> Of _Msysmenu Activate Popup pop<<This.cId>>
				ENDTEXT

				lcRet = lcRet + lcCommand + Chr( 13 )
				lcTraceLogin = 'Ejecutando comando: ' + lcCommand
				&lcCommand

				TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Popup pop<<This.cId>> Margin Relative Shadow Color Scheme 4
				ENDTEXT

				lcRet = lcRet + lcCommand + Chr( 13 )
				lcTraceLogin = 'Ejecutando comando: ' + lcCommand
				&lcCommand

				For i = 1 To This.Count
					loColMenu = This.Item[ i ]

					Try
						lcRet = lcRet + loColMenu.DefineBar() + Chr( 13 )

					Catch To oErr
						lcTraceLogin = lcTraceLogin + Chr( 13 ) ;
							+ 'Item:' + Transform( i ) + Chr( 13 ) ;
							+ 'Nivel:' + Transform( loColMenu.nNivel )

						loError.Process( oErr )
						Throw loError

					Finally
					Endtry

				Endfor

			Else

				TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Pad pad<<This.cId>> Of _Msysmenu
					Prompt "<<lcNombre>>"
					Color Scheme 3
					<<Iif( ! Empty( This.cAccessKey ), [KEY Alt+] + This.cAccessKey + [, ""], "" )>>
					Message "<<This.cNombre>>"
					Skip For !(IsRuntime() Or   FileExist( "<<Addbs(This.cFolder)>><<ForceExt( This.cPrograma, 'prg' )>>" ))
				ENDTEXT
				*					Skip For !  FileExist( "<<Addbs(This.cFolder)>><<ForceExt( This.cPrograma, 'prg' )>>" )
				lcRet = lcRet + lcCommand + Chr( 13 )
				lcTraceLogin = 'Ejecutando comando: ' + lcCommand
				&lcCommand

				lcExecute = This.DoExecute()
				TEXT TO lcCommandAction TEXTMERGE NOSHOW PRETEXT 15
					On Selection Pad pad<<This.cId>> Of _Msysmenu
					<<lcExecute>>
				ENDTEXT

				lcRet = lcRet + lcCommandAction + Chr( 13 )
				lcTraceLogin = 'Ejecutando comando: ' + lcCommandAction
				&lcCommandAction

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cTraceLogin = lcTraceLogin
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcRet

	Endproc

	Procedure DefineBar()

		Local lcCommand As String
		Local lcNombre As String
		Local lcRet As String
		Local lcCommandAction As String
		Local lcTraceLogin As String
		Local lcPopUpName As String
		Local lcExecute As String
		Local i As Integer

		Try

			lcTraceLogin = ""
			lcRet = ""
			lcPopUpName = ""
			lcExecute = ""


			If !IsRuntime()
				This.cAccessKey = ""
			Endif

			If ! Empty( This.cAccessKey )
				lcNombre = Strtran( This.cNombre, This.cAccessKey, '\<'  + This.cAccessKey, 1, 1, 2 )

			Else
				lcNombre = This.cNombre

			Endif

			If Empty( This.cPrograma )

				lcPopUpName = 'pop' + This.oParent.cID

				TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Bar <<This.nIndex>> Of <<lcPopUpName>> Prompt "<<lcNombre>>"
					<<Iif( ! Empty( This.cAccessKey ), [KEY Alt+] + This.cAccessKey + ', "[' + Upper( This.cAccessKey ) + ']"', "" )>>
					Message "<<This.cNombre>>"
				ENDTEXT


				*<<Iif( ! Empty( This.cAccessKey ), [KEY Alt+] + This.cAccessKey + [, "Alt+] + Upper( This.cAccessKey ) +["], "" )>>

				lcRet = lcRet + lcCommand + Chr( 13 )
				lcTraceLogin = 'Ejecutando comando: ' + lcCommand
				&lcCommand

				TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					On Bar <<This.nIndex>> Of pop<<This.oParent.cId>> Activate Popup pop<<This.cId>>
				ENDTEXT

				lcRet = lcRet + lcCommand + Chr( 13 )
				lcTraceLogin = 'Ejecutando comando: ' + lcCommand
				&lcCommand

				TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Popup pop<<This.cId>> Margin Relative Shadow Color Scheme 4
				ENDTEXT

				lcRet = lcRet + lcCommand + Chr( 13 )
				lcTraceLogin = 'Ejecutando comando: ' + lcCommand
				&lcCommand

				For i = 1 To This.Count
					loColMenu = This.Item[ i ]

					Try
						lcRet = lcRet + loColMenu.DefineBar() + Chr( 13 )

					Catch To oErr
						lcTraceLogin = lcTraceLogin + Chr( 13 ) ;
							+ 'Item:' + Transform( i ) + Chr( 13 ) ;
							+ 'Nivel:' + Transform( loColMenu.nNivel )

						loError.Process( oErr )
						Throw loError

					Finally
					Endtry

				Endfor

			Else
				lcPopUpName = 'pop' + This.oParent.cID
				TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Bar <<This.nIndex>> Of <<lcPopUpName>> Prompt "<<lcNombre>>"
					<<Iif( ! Empty( This.cAccessKey ), [KEY Alt+] + This.cAccessKey + ', "[' + Upper( This.cAccessKey ) + ']"', "" )>>
					Message "<<This.cNombre>>"
					Skip For !(IsRuntime() Or   FileExist( "<<Addbs(This.cFolder)>><<ForceExt( This.cPrograma, 'prg' )>>" ))
				ENDTEXT
				lcRet = lcRet + lcCommand + Chr( 13 )
				lcTraceLogin = 'Ejecutando comando: ' + lcCommand
				&lcCommand

				lcExecute = This.DoExecute()
				TEXT TO lcCommandAction TEXTMERGE NOSHOW PRETEXT 15
					On Selection Bar <<This.nIndex>> Of pop<<This.oParent.cId>>
					<<lcExecute>>
				ENDTEXT

				lcRet = lcRet + lcCommandAction + Chr( 13 )
				lcTraceLogin = 'Ejecutando comando: ' + lcCommandAction
				&lcCommandAction

			Endif

		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cTraceLogin = lcTraceLogin
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcRet

	Endproc

	Procedure DoExecute()
		Local lcCommandAction As String

		Try

			Do Case
				Case !Empty( This.nParam5 )
					TEXT To lcParam NoShow TextMerge Pretext 15
						With <<This.nParam1>>,<<This.nParam2>>,<<This.nParam3>>,<<This.nParam4>>,<<This.nParam5>>
					ENDTEXT

				Case !Empty( This.nParam4 )
					TEXT To lcParam NoShow TextMerge Pretext 15
						With <<This.nParam1>>,<<This.nParam2>>,<<This.nParam3>>,<<This.nParam4>>
					ENDTEXT

				Case !Empty( This.nParam3 )
					TEXT To lcParam NoShow TextMerge Pretext 15
						With <<This.nParam1>>,<<This.nParam2>>,<<This.nParam3>>
					ENDTEXT

				Case !Empty( This.nParam2 )
					TEXT To lcParam NoShow TextMerge Pretext 15
						With <<This.nParam1>>,<<This.nParam2>>
					ENDTEXT

				Case !Empty( This.nParam1 )
					TEXT To lcParam NoShow TextMerge Pretext 15
						With <<This.nParam1>>
					ENDTEXT

				Otherwise
					lcParam = ""

			Endcase

			TEXT TO lcCommandAction TEXTMERGE NOSHOW PRETEXT 15
				Do Execute With "'<<Addbs(This.cFolder)>><<This.cPrograma>>' <<lcParam>>", <<This.lDoPrg>>, <<This.nFormType>>
			ENDTEXT


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return lcCommandAction

	Endproc



	*
	* Agrega a la estructura del Menu con los campos del Usuario
	Procedure UpsizeMnu( cGroupField As String, cUserField As String, tcDbf As String ) As VOID;
			HELPSTRING "Agrega a la estructura del Menu con los campos del Usuario"
		Local lcCommand As String
		Local llGrupo As Boolean,;
			llUsuario As Boolean

		Try

			lcCommand = ""

			llGrupo = Upper( Field( cGroupField, 'mnu' ) ) = Upper( cGroupField )
			llUsuario = Upper( Field( cUserField, 'mnu' ) ) = Upper( cUserField )

			If !llGrupo Or !llUsuario
				Use In Select( 'mnu' )
				Use (tcDbf) Exclusive In 0 Alias mnu

			Endif

			If !llGrupo

				* RA 2014-03-15(09:25:00)
				* Agregar el grupo e inicializarlo con los permisos
				* del grupo USUARIOS
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Alter Table mnu
					Add Column <<cGroupField>> N(1)
				ENDTEXT

				&lcCommand

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update mnu Set
					<<cGroupField>> = g<<StrZero( GRP_USUARIO )>>
				ENDTEXT

				&lcCommand


			Endif

			If !llUsuario
				* RA 2014-03-15(09:25:48)
				* Agregar el Usuario e inicializarlo con los permisos
				* del grupo
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Alter Table mnu
					Add Column <<cUserField>> N(1)
				ENDTEXT

				&lcCommand

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Update mnu Set
					<<cUserField>> = 2
				ENDTEXT

				&lcCommand

			Endif

			If !llGrupo Or !llUsuario
				Use In Select( 'mnu' )
				Use (tcDbf) Shared Again In 0 Alias mnu
			Endif


		Catch To oErr
			Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && UpsizeMnu


Enddefine && ColMenu

#If .F.
	Do CreateObjParam
#Endif