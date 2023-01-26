*!* CodeParserSetup @  llAlreadyParsed @ .T.
*!* CodeParserSetup @  llParsePrivate @ .F.

* ULTIMO NUMERO DE VARIABLES PRIVADAS: 13

*  Funciones y procedimientos varios (V)
* 17 de Octubre de 1991
*----------------------------------------------------------------------------*

#INCLUDE "FW\Comunes\Include\Praxis.h"


* Asegurarse que se cargan en el proyecto
External Procedure Execute.prg,;
	Stop.prg,;
	Inform.prg,;
	Warning.prg,;
	Confirm.prg

External Form frmAChoice.scx


Note: Seteo de parametros iniciales

Procedure V_Seteo
	*!*		Set Cons Off
	*!*		Set Scor Off
	*!*		Set Date French
	*!*		Set Deleted On
	*!*		Set Confirm On
	*!*		Set Exclusive Off

	*!*		Do Case
	*!*			Case Type("CL_NORMAL")<>"U"
	*!*				SETCOLOR(CL_NORMAL)

	*!*		Endcase

	*!*		Do Case
	*!*			Case Type("WIN95")="C"
	*!*				Do Case
	*!*					Case Uppe(WIN95)="/W"

	*!*						WIN95=.T.
	*!*					Otherwise
	*!*						WIN95=.F.
	*!*				Endcase
	*!*			Case Type("WIN95")<>"L"
	*!*				WIN95=.F.
	*!*		Endcase

	*!*		Readexit(.T.)
	Return

	Note: Pausa

Procedure V_Pausa
	Para nDelay
	Do Case
		Case Type("nDelay")<>"N"
			nDelay=5
	Endcase
	Inkey(nDelay)
	Return

	Note: Confirmacion de un proceso
	Note Par: 1: Nombre del proceso a realizar si se confirma (Opcional)

Function V_Confir
	Parameters Prm01,cMsg
	Local lcAcl As String
	Private F031
	Store Null To F031

	lcAcl = Acl1
	If Vartype( cMsg ) # "C"
		cMsg = Msg2

	Else
		lcAcl = Msg2

	Endif

	Set Cursor Off
	Do S_Line23 With cMsg
	Do S_Line24 With lcAcl
	F031=I_Inkey(Enter,Escape,0,0,0,0,0,0,0,0)
	Set Cursor On

	If F031=Enter
		If Pcount()>0
			Do &Prm01
		Endif

		Retu .T.

	Else
		Return .F.

	Endif

	Note: Procedimiento nulo

Procedure V_Null
	Lparameters tnParam1, tnParam2, tnParam3
	Return

	Note: Borrado fisico de archivos
	Note Par: 1.Nombre del archivo a borrar con su extension

Procedure V_Blanquea
	Parameters Prm01,Prm02
	Private F001,F002,F003,F004,F005
	Store Null To F001,F002,F003,F004,F005
	F005=Subs(Prm02,1,2)
	Run &F005
	F005=Trim(Subs(Prm02,3,17))
	F005=Subs(F005,1,Len(F005)-1)
	Do Case
		Case !Empt(F005)
			Run Cd &F005
		Otherwise
			Run Cd\
	Endcase
	Rename &Prm01 To a
	F001=Fopen('A',2)
	F002=Fseek(F001,0,2)
	F003=Replicate(Chr(0),512)
	F004=Round(F002/512,0)
	F004=Iif(Round(F004*512,0)=F002,F004,F004+1)
	Fseek(F001,0)
	For wi=1 To F004
		Fwrite(F001,F003)
	Next
	Fclose(F001)
	Delete File a
	Return

	Note: Pasaje de numeros a letras
	Note Par: 1. Valor numerico
	Note Ret: Valor en letras

Function V_Numlet
	Parameters Prm01
	Do Case
		Case Prm01=0 .Or. Prm01>999999999.99
			Return (' ')
	Endcase

	Private F021,F022,F023,F024
	Store Null To F021,F022,F023,F024


	F021=Str(Int(Prm01),9)
	Do Case
		Case Val(F021)=0
			F023='Cero '
		Otherwise
			F022=10-Len(Ltrim(F021))
			F023=''
			For i=F022 To 9
				F024=Val(Subs(F021,i,1))
				Do Case
					Case !Empt(F023)
						Do Case
							Case i=4
								F023=F023+Iif(F023='un ','millon ','millones ')
							Case i=7 .And. Subs(F021,4,3)<>'000'
								F023=F023+'mil '
						Endcase
				Endcase
				Do Case
					Case F024<>0
						Do Case
							Case i=1 .Or. i=4 .Or. i=7
								Do Case
									Case F024=1
										Do Case
											Case Subs(F021,i+1,2)='00'
												F023=F023+'cien '
											Otherwise
												F023=F023+'ciento '
										Endcase
									Otherwise
										F023=F023+Cen[F024]
								Endcase
							Case i=2 .Or. i=5 .Or. i=8
								Do Case
									Case F024=1
										F023=F023+Uni[Val(Subs(F021,I,2))]
										i=i+1
									Case F024=2
										Do Case
											Case Subs(F021,i+1,1)='0'
												F023=F023+'veinte '
											Otherwise
												F023=F023+'veinti'
										Endcase
									Otherwise
										F023=F023+Dec[F024]
										Do Case
											Case Subs(F021,i+1,1)<>'0'
												F023=F023+'y '
										Endcase
								Endcase
							Otherwise
								F023=F023+Uni[F024]
						Endcase
				Endcase
			Next
	Endcase
	Do Case
		Case Subs(F023,Len(F023)-1,1)='n' .And. Val(F021)<>1000000 .And.;
				Subs(F021,7,3)<>'100'
			F023=Trim(F023)+'o '
	Endcase
	F025=Prm01-Int(Prm01)
	Do Case
		Case F025<>0
			F023=F023+'con '+Subs(Str(F025,4,2),3,2)+'/100'
		Otherwise
			F023=Trim(F023)
	Endcase
	Return(F023)

	* Funciones y procedimientos para pantallas (S)
	* 19 de Mayo de 1988
	*----------------------------------------------------------------------------*

	Note: Encabezado de la pantalla presentacion

Procedure S_Cabeza
	Private OLDCOLOR
	Store Null To OLDCOLOR

	Do S_Clear With 0,0,24,79
	Do Case
		Case K_ISCOLOR
			***Set Color to &CL_LINE00
			OLDCOLOR=SETCOLOR(CL_LINE00)
		Otherwise
			***Set Color to &CL_LINE23
			OLDCOLOR=SETCOLOR(CL_LINE23)
	Endcase
	@ 0,0 Say Space(80)
	@ 1,0 Say '          P  R  A  X  I  S    C o m p u t a c i o n    -   '+;
		'T. E.  4981-8139        '
	@ 2,0 Say Space(80)
	@ 0,0 To 0,79 Double
	@ 2,0 To 2,79 Double
	***Set color to &CL_NORMAL
	SETCOLOR(OLDCOLOR)
	Return

	Note: Aviso de opcion no habilitada
	Note Par: 1. 1:opcion no habilitada, 2:proceso cancelado

Procedure S_Nohabi
	Lparameters Prm01
	If Prm01=1
		Stop( 'OPCION NO HABILITADA' )

	Else
		Stop( 'PROCESO CANCELADO' )

	Endif

	Return

	Note: borrar un sector de la pantalla en Forma convergente a una linea.
	Note Par: 1. X inicial, 2. Y inicial, 3. X Final, 4. Y Final

Procedure xxxS_Clear
	Parameters Prm01,Prm02,Prm03,Prm04
	Private F041,F042,F043
	Store 0 To F041,F042,F043
	F041 = (Prm03 - Prm01) / 2
	F042 = Space(Prm04-Prm02+1)
	For F043 = 0 To F041
		@ Prm01+F043, Prm02 Say F042
		@ Prm03-F043, Prm02 Say F042
	Next
	Return

Procedure yyyS_Clear
	Lparameters tnTop, tnLeft, tnBott, tnRight
	Local i As Integer
	Local lnLen As Integer
	Local lcChar As Character

	tnBott = Min( tnBott, 24 )
	tnRight = Min( tnRight, 79 )

	lcChar = " "

	lnLen = ( tnRight - tnLeft ) + 1

	For i = tnTop To tnBott
		@ i, tnLeft Say Replicate( lcChar, lnLen )
	Endfor


	Return

Procedure S_Clear
	Lparameters tnTop, tnLeft, tnBott, tnRight

	Local lnLen As Integer
	Local i As Integer
	Local loForm As Form
	Try

		*!*			lnLen = tnRight - tnLeft

		*!*			tnTop 	= Max( tnTop, 0 )
		*!*			tnLeft 	= Max( tnLeft, 0 )
		*!*			tnBott 	= Min( tnBott, 24 )
		*!*			tnRight = Min( tnRight, 80 )

		tnTop 	= Max( tnTop, 0 )
		tnLeft 	= Max( tnLeft, 0 )
		tnBott 	= Max( tnBott, 0 )
		tnRight = Max( tnRight, 0 )

		lnLen = tnRight - tnLeft

		Try

			For i = tnTop To tnBott
				@ i, tnLeft Say Space( lnLen )
			Endfor

		Catch To oErr

		Finally

		Endtry

	Catch To loErr

		If !isRuntime()
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Endif

	Finally

	Endtry

	Return

	Note: Cartel titilante en linea 21
	Note Par: 1. Descripcion del Cartel

Procedure S_Line21
	Parameters Prm01,Prm02
	Private OLDCOLOR
	Store Null To OLDCOLOR

	Local loForm As Form

	Try

		Wait Window Prm01 Nowait

	Catch To loErr

		If !isRuntime()
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
		Endif

	Finally
		loForm = Null

	Endtry

	Return

	Note: Cartel titilante en linea 22
	Note Par: 1. Descripcion del Cartel

Procedure S_Line22
	Parameters Prm01, lWaitWindow, lNotSilence

	Private OLDCOLOR
	Store Null To OLDCOLOR

	Local loForm As Form
	Local lnDelay As Integer

	Try

		If Empty( lWaitWindow )
			lWaitWindow = .F.
		Endif

		If Vartype( lWaitWindow ) # "L"
			lWaitWindow = .F.
		Endif

		llOk = .T.

		If lWaitWindow Or "PROCESANDO"$Upper( Prm01 ) Or "IMPRIMIENDO"$Upper( Prm01 ) Or "BUSCANDO"$Upper( Prm01 ) Or "GRABANDO"$Upper( Prm01 )

			If lNotSilence And FileExist( Addbs( Drva ) + "Wav\Warning.Wav" )
				Set Bell To Addbs( Drva ) + "Wav\Warning.Wav"
				?? Chr( 7 )
			Endif

			Wait Window Prm01 Nowait

		Else
			If Type( "_Screen.oApp.cAppName" ) = "C"
				lcCaption = _Screen.oApp.cAppName

			Else
				lcCaption = "Error grave"

			Endif
			lnDelay = 2

			*Messagebox( Prm01, MB_ICONSTOP, lcCaption, lnDelay )
			Stop( Prm01, lcCaption, lnDelay )

		Endif

	Catch To loErr

		If !isRuntime()
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
		Endif

	Finally
		loForm = Null
		Set Bell To

	Endtry


	Return

	Note: Mensaje en linea 23
	Note Par: 1. Descripcion del Cartel

Procedure S_Line23
	Parameters Prm01
	Private OLDCOLOR

	Local loForm As Form
	Local i As Integer


	Try

		loForm = GetActiveForm()

		If Pemstatus( loForm, "cntMessages", 5 )
			loForm.cntMessages.Label23.Caption = Prm01
		Endif


	Catch To loErr

		If !isRuntime()
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
		Endif

	Finally
		loForm = Null

	Endtry

	Return

	Note: Mensaje en linea 24
	Note Par: 1. Descripcion del Cartel

Procedure S_Line24
	Parameters Prm01

	Private OLDCOLOR
	Store Null To OLDCOLOR

	Local loForm As Form

	Local i As Integer

	Try

		loForm = GetActiveForm()

		If Pemstatus( loForm, "cntMessages", 5 )
			loForm.cntMessages.Label24.Caption = Prm01
		Endif



	Catch To loErr

		If !isRuntime()
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
		Endif

	Finally
		loForm = Null

	Endtry

	Return

	* Mensaje en la Linea 25
	* Solo se Muestra si prxIngreso.lMultiplePantallas = .T.
	* Se usa para mostrar las teclas de Navegación entre pantallas
Procedure S_Line25( cMsg As String ) As Void
	Local lcCommand As String
	Local loForm As frmdisplaywindow Of "v:\clipper2fox\rutinas\vcx\clipper2fox.vcx"

	Try

		lcCommand = ""

		loForm = GetActiveForm()

		If Pemstatus( loForm, "cntMessages", 5 )
			loForm.cntMessages.LblNavegar.Caption = cMsg
		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loForm = Null

	Endtry

Endproc && s_Line25

Note: Titulo del programa
Note Par: 1. Titulo del programa, 2. Fecha en formato Date, 3. Nombre Empresa

Procedure S_Titpro( tcTitulo As String,;
		tdFecha As Date,;
		loForm As Form )

	Local lcEmpresa As String,;
		lcLastModified As String,;
		lcCommand As String
	Local loForm As frmdisplaywindow Of Rutinas\Vcx\clipper2fox.Vcx,;
		loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

	Try

		lcCommand = ""

		Try
			lcEmpresa = _Screen.oApp.cEmpresa
			*lcEmpresa = lcEmpresa + " - "

		Catch To oErr
			lcEmpresa = ""

		Finally

		Endtry

		If Vartype( loForm ) # "O"
			loForm = GetActiveForm()
		Endif

		If _Screen.oApp.nDrillDownLevel > 0
			tcTitulo = Alltrim( tcTitulo ) + " ( #" + Transform( _Screen.oApp.nDrillDownLevel ) + " )"
		Endif

		If Inlist( Upper( loForm.Caption ), "DISPLAY FORM", "FORM1" )
			loForm.Caption = lcEmpresa && + _Screen.Caption
		Endif

		loForm.cntTitulo.lblFecha.Caption = F_Today(tdFecha)
		loForm.cntTitulo.lblTitulo.Caption = tcTitulo

		If Asterisco And Vartype( WCLAV ) = "C"
			loForm.cntTitulo.Label1.Caption = ""

			Do Case
				Case WCLAV = "B"
					loForm.cntTitulo.Label1.Caption = "*"

				Case WCLAV = "M"
					loForm.cntTitulo.Label1.Caption = "**"

			Endcase

		Endif

		loForm.cntTitulo.Label1.Left 			= 0
		loForm.cntTitulo.lblTitulo.Left 		= loForm.cntTitulo.Label1.Width
		loForm.cntTitulo.lblObservaciones.Left 	= loForm.cntTitulo.lblTitulo.Left + loForm.cntTitulo.lblTitulo.Width + 10
		loForm.cntTitulo.lblFecha.Left 			= loForm.Width - loForm.cntTitulo.lblFecha.Width - 05

		If ( GetValue( "Integra", "ar0Web", "N" ) = "S" )

			If !Pemstatus( loForm, "lblBak", 5 )
				AddProperty( loForm, "lblBak", Createobject( "Empty" ) )

				AddProperty( loForm.lblBak, "BackColor" , loForm.cntTitulo.lblObservaciones.BackColor )
				AddProperty( loForm.lblBak, "ForeColor" , loForm.cntTitulo.lblObservaciones.ForeColor )
				AddProperty( loForm.lblBak, "Caption" 	, loForm.cntTitulo.lblObservaciones.Caption )
				AddProperty( loForm.lblBak, "BackStyle" 	, loForm.cntTitulo.lblObservaciones.BackStyle )

			Endif

			loGlobalSettings = NewGlobalSettings()
			If !loGlobalSettings.lIntegracionWeb
				loForm.cntTitulo.lblObservaciones.Caption 	= "DESCONECTADO DE LA WEB"
				loForm.cntTitulo.lblObservaciones.BackColor = Rgb(255,0,0) 		&& Rojo
				loForm.cntTitulo.lblObservaciones.ForeColor = Rgb(255,255,0) 	&& Amarillo
				loForm.cntTitulo.lblObservaciones.BackStyle = 1

			Else
				loForm.cntTitulo.lblObservaciones.Caption 	= loForm.lblBak.Caption
				loForm.cntTitulo.lblObservaciones.BackColor = loForm.lblBak.BackColor
				loForm.cntTitulo.lblObservaciones.ForeColor = loForm.lblBak.ForeColor
				loForm.cntTitulo.lblObservaciones.BackStyle = loForm.lblBak.BackStyle

			Endif
		Endif

		_Screen.Caption = _Screen.oApp.cScreenCaption + " - " + lcEmpresa + " - " + tcTitulo
		_Screen.oApp.cTitPro = tcTitulo

		If GetValue( "LastModi", "ar0Var", "N", "S:\Fenix\" ) = "S"
			lcLastModified = Ttoc( FechaUltimaActualizacion( Addbs( Alltrim( Drva )) + "*.dbf" ))
			_Screen.Caption = Alltrim( _Screen.Caption ) + " (" + lcLastModified + ")"
		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loForm = Null

	Endtry


	Return

	Note: Agregar al Titulo del programa
	Note Par: 1. String a Agregar

Procedure S_AddTitpro( tcAddTitulo As String )

	Local loForm As Form
	Local i As Integer
	Local lcTitulo As String

	Try

		*!*			loForm = _Screen.ActiveForm
		*!*			If !Inlist( Upper( loForm.Name ), "DISPLAYWINDOW", "DISPLAYFORM", "FRMSAVESCREEN" )
		*!*				For i = 1 To _Screen.FormCount
		*!*					loForm = _Screen.Forms( i )
		*!*					If Inlist( Upper( loForm.Name ), "DISPLAYWINDOW","DISPLAYFORM", "FRMSAVESCREEN" )
		*!*						Exit
		*!*					Endif
		*!*				Endfor
		*!*			EndIf

		loForm = GetActiveForm()

		If Vartype( tcAddTitulo ) # "C"
			tcAddTitulo = ""
		Endif

		lcTitulo = _Screen.oApp.cTitPro
		lcTitulo = lcTitulo + tcAddTitulo
		loForm.cntTitulo.lblTitulo.Caption = lcTitulo

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loForm = Null

	Endtry


	Return

Endproc


Note: Titulo de un Menu o submenu
Note Par: 1. Nombre del cliente, 2. Nombre del Sistema,
*         3. Fecha en formato date

Procedure S_Titmen
	Parameters Prm01,Prm02,Prm03

	Private OLDCOLOR
	Store Null To OLDCOLOR
	Try

		***SET COLO TO &CL_LINE00
		OLDCOLOR=SETCOLOR(CL_LINE00)
		S_Clear(00,00,02,79)
		@ 0,0 To 2,79 Double
		@ 0,13 To 2,13 Double
		@ 0,13 Say Chr(203)
		@ 2,13 Say Chr(202)
		@ 0,66 To 2,66 Double
		@ 0,66 Say Chr(203)
		@ 2,66 Say Chr(202)
		@ 1,2 Say C_Center(Prm01,10)
		@ 1,15 Say C_Center(Prm02,50)
		@ 1,69 Say Prm03
		***SET COLO TO &CL_NORMAL
		SETCOLOR(OLDCOLOR)

	Catch To loErr

		If !isRuntime()
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
		Endif

	Finally

	Endtry

	Return

	Note: Cartel aclaratorio Para ingreso de claves numericas
	Note Par: 1. Longitud de la clave

Procedure S_Aclcln
	Parameters Prm01
	Do S_Line24 With ('Ingrese hasta  '+Ltrim(Str(Prm01,2))+' '+;
		iif(Prm01>1,'digitos','digito')+' o cero para finalizar')
	Return

	Note: Cartel aclaratorio Para ingreso de claves alfanumericas
	Note Par: 1. Longitud de la clave

Procedure S_Aclclc
	Parameters Prm01
	Do S_Line24 With ('Ingrese hasta  '+Ltrim(Str(Prm01,2))+' '+Iif(Prm01>1,;
		'caracteres','caracter')+' o blancos para finalizar')
	Return

	Note: Cartel aclaratorio Para ingreso de datos numericos
	Note Par: 1. Longitud del dato

Procedure S_Aclnro
	Parameters Prm01,Prm02
	Do S_Line24 With ('Ingrese hasta  '+Ltrim(Str(Prm01,2))+' '+;
		iif(Prm01>1,'digitos','digito'))
	Return

	Note: Cartel aclaratorio Para ingreso de datos alfanumericos
	Note Par: Longitud del dato

Procedure S_Aclstr
	Parameters Prm01
	Do S_Line24 With ('Ingrese hasta '+Ltrim(Str(Prm01,Iif(Prm01>99,3,2)))+' '+;
		iif(Prm01>1,'caracteres','caracter'))
	Return

	Note: Cartel aclaratorio Para ingreso de datos numericos Y decimales
	Note Par: 1. Cantidad de enteros, 2. Cantidad de decimales

Procedure S_Acldec
	Parameters Prm01,Prm02
	Do S_Line24 With ('Ingrese hasta  '+Ltrim(Str(Prm01,2))+' '+Iif(Prm01>1,;
		'digitos enteros','digito entero')+' y '+;
		Ltrim(Str(Prm02,2))+' '+Iif(Prm01>1,'decimales','decimal'))
	Return

	Note: Pedido de datos con el achoice
	Note Par: 1.X, 2.Y, 3.X, 4.Y, 5.Nombre del vector, 6.Valor inicial,
	*         7..T.:despliega descripcion - .F.:no despliega descripcion
	*		  8. Nombre del vector paralelo
	Note Ret: Valor elegido

	*!*	Function S_Opcion
	*!*		Parameters Prm01,Prm02,Prm03,Prm04,Prm05,Prm06,Prm07,Prm08

	*!*		Local lnListItemId As Integer
	*!*		Local loParam As Object

	*!*		Local lnTop As Integer,;
	*!*			lnLeft As Integer,;
	*!*			lnBottom As Integer,;
	*!*			lnRight As Integer,;
	*!*			lnSelected As Integer
	*!*
	*!*		Local laArray
	*!*
	*!*		laArray = &Prm05

	*!*		lnListItemId = 0

	*!*		lnTop = Prow()
	*!*		lnLeft = Pcol()
	*!*		lnBottom = lnTop + 100
	*!*		lnRight = lnLeft + 50
	*!*		lnSelected = Prm06

	*!*		If Pcount()=6
	*!*			Prm07=.T.
	*!*		Endif

	*!*		Prm08 = prxDefault("Prm08","")
	*!*
	*!*		Define Popup popAchoice From nTop, nLeft


	*!*		If !Empty( lnListItemId )
	*!*			@ Prm01,Prm02 Say &Prm05[ lnListItemId ]
	*!*		Endif

	*!*		Return lnListItemId


Function S_Opcion
	Parameters tnTop, tnLeft, tnBottom, tnRight, tcAName, tnSelected, tlShow, tcCaption, toParam, tnCol

	Local lnListItemId As Integer
	Local loParam As Object
	Local lnMaxLen As Integer,;
		i As Integer

	Local lnTop As Integer,;
		lnLeft As Integer,;
		lnBottom As Integer,;
		lnRight As Integer,;
		lnSelected As Integer,;
		lnRow As Integer

	Local loForm As Form
	Local loCollection As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg

	lnListItemId = 0

	Local i As Integer

	Try

		loForm = GetActiveForm()

	Catch To oErr
		loForm = _Screen

	Finally


	Endtry

	lnRow = tnTop

	If tnTop >= 0
		If !Empty( tcCaption )
			tnTop = tnTop - 1
		Endif

		lnTop = loForm.Top + ( loForm.TextHeight( "X" ) * ( tnTop + 1 ))
		lnLeft = loForm.Left + ( loForm.TextWidth( "X" ) * tnLeft )

		lnBottom = lnTop + 100
		lnRight = lnLeft + 50

	Else
		lnTop = -1
		lnLeft = -1
		lnBottom = 0
		lnRight = 0

	Endif

	lnSelected = tnSelected

	loParam = Createobject( "Empty" )

	AddProperty( loParam,"nTop", lnTop )
	AddProperty( loParam,"nLeft", lnLeft )
	*AddProperty( loParam,"oColItems", .F. )
	AddProperty( loParam,"nSelected", lnSelected )

	If !Empty( tcCaption )
		AddProperty( loParam,"TitleBar", 1 )
		AddProperty( loParam,"Caption", tcCaption )
	Endif

	If Vartype( toParam ) == "O"
		Amembers( laMembers, toParam )
		For Each lcProperty In laMembers
			Try
				AddProperty( loParam, lcProperty, toParam.&lcProperty )

			Catch To oErr
				* No hago nada
			Finally
			Endtry
		Endfor
	Endif

	S_Line24( "" )

	Do Form "Rutinas\Scx\frmAChoice" With &tcAName, loParam, tnCol To lnListItemId

	If tlShow And !Empty( lnListItemId )
		lnMaxLen = 0

		If Pemstatus( loParam, "oColItems", 5 )
			loCollection = loParam.oColItems

			For Each loItem In loCollection
				lnMaxLen = Max( lnMaxLen, Len( loItem.Caption ))
			Endfor

			Try

				* RA 19/07/2016(16:19:17)
				* Primero se intenta traer el item por su PK ( loItem.Id )
				loItem = loCollection.GetItem( Transform( lnListItemId ))

			Catch To oErr
				* Luego por su hubicación
				loItem = loCollection.Item( lnListItemId )

			Finally

			Endtry

			lnListItemId = loItem.Id

			@ lnRow, tnLeft Say Space( lnMaxLen )
			SayMask( lnRow, tnLeft, loItem.Caption )

		Else
			For i = 1 To Alen( &tcAName, 1 )
				If Empty( tnCol )
					lnMaxLen = Max( lnMaxLen, Len( &tcAName[ i ] ) )

				Else
					lnMaxLen = Max( lnMaxLen, Len( &tcAName[ i, tnCol ] ) )

				Endif

			Endfor

			@ lnRow, tnLeft Say Space( lnMaxLen )
			If Empty( tnCol )
				SayMask( lnRow, tnLeft, &tcAName[ lnListItemId ] )

			Else
				SayMask( lnRow, tnLeft, &tcAName[ lnListItemId, tnCol ] )

			Endif

		Endif

	Else

	Endif

	Return lnListItemId

	*
	*
Procedure S_Fecha( tdDate, tnTop, tnLeft, tcCaption, lSilence, dInicial, dFinal ) As Date
	Local lcCommand As String,;
		lcMsg As String
	Local ldDate As Date

	Local lnTop As Integer,;
		lnLeft As Integer

	Local loForm As Form,;
		loFecha As Form

	Local loKeyCalMonthForm	As keycalmonthform Of "FW\Comunes\Vcx\taDatePicker.vcx",;
		loCalendar As CalDateMonthModal Of "FW\Comunes\Vcx\taDatePicker.vcx"


	Try

		lcCommand = ""

		Try

			loForm = GetActiveForm()

		Catch To oErr
			loForm = _Screen

		Finally

		Endtry

		If Empty( tdDate )
			tdDate = FECHAHOY
		Endif

		If Empty( dInicial )
			dInicial = GetValue( "Feca0", "ar0Est", {^2000/01/01} )
		Endif

		If Empty( dFinal )
			dFinal = LASTDATE
		Endif

		ldDate = tdDate

		If Vartype( tnTop ) # "N"
			tnTop = -1
		Endif

		If tnTop >= 0
			lnTop = tnTop

			If !Empty( tcCaption )
				lnTop = lnTop - 1
			Endif

			lnTop 	= loForm.Top  + ( loForm.TextHeight( "X" ) * ( lnTop + 1.5 ))
			lnLeft 	= loForm.Left + ( loForm.TextWidth( "X" )  * tnLeft )

		Else
			lnTop 	= -1
			lnLeft  = -1

		Endif

		loParam = Createobject( "Empty" )

		AddProperty( loParam,"nTop", lnTop )
		AddProperty( loParam,"nLeft", lnLeft )
		AddProperty( loParam,"dDate", ldDate )

		AddProperty( loParam,"FontName", loForm.FontName )
		AddProperty( loParam,"FontSize", loForm.FontSize )
		AddProperty( loParam,"dPrimerFechaValida", dInicial )
		AddProperty( loParam,"dUltimaFechaValida", dFinal )

		If !Empty( tcCaption )
			AddProperty( loParam,"TitleBar", 1 )
			AddProperty( loParam,"Caption", tcCaption )
		Endif

		TEXT To lcMsg NoShow TextMerge Pretext 03
		[ F4 ]: Despliega Calendario
		ENDTEXT

		S_Line24( lcMsg )

		Do Form "Rutinas\Scx\S_Fecha" With loParam To ldDate

		If !lSilence And tnTop >= 0
			SayMask( tnTop, tnLeft,  ldDate, "@D" )
		Endif

		Do Case
			Case dFinal = LASTDATE
				TEXT To lcMsg NoShow TextMerge Pretext 03
			La fecha debe ser mayor que <<dInicial>>
				ENDTEXT

			Otherwise
				TEXT To lcMsg NoShow TextMerge Pretext 03
			La fecha debe estar entre <<dInicial>> y <<dFinal>>
				ENDTEXT

		Endcase

		Do While !&Aborta And !I_Valida( Between( ldDate, dInicial, dFinal ), lcMsg )
			Do Form "Rutinas\Scx\S_Fecha" With loParam To ldDate

			If !lSilence And tnTop >= 0
				SayMask( tnTop, tnLeft,  ldDate, "@D" )
			Endif

		Enddo


		prxLastkey()

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loCalendar = Null
		loKeyCalMonthForm = Null
		loFecha = Null

	Endtry

	Return ldDate

Endproc && S_Fecha


*
*
Procedure xxxS_Fecha( tdDate, tnTop, tnLeft, tcCaption ) As Date
	Local lcCommand As String
	Local ldDate As Date

	Local lnTop As Integer,;
		lnLeft As Integer

	Local loForm As Form,;
		loFecha As Form

	Local loKeyCalMonthForm	As keycalmonthform Of "FW\Comunes\Vcx\taDatePicker.vcx",;
		loCalendar As CalDateMonthModal Of "FW\Comunes\Vcx\taDatePicker.vcx"


	Try

		lcCommand = ""

		Try

			loForm = GetActiveForm()

		Catch To oErr
			loForm = _Screen

		Finally


		Endtry

		If Empty( tdDate )
			tdDate = FECHAHOY
		Endif

		ldDate = tdDate

		If Vartype( tnTop ) # "N"
			tnTop = -1
		Endif

		If tnTop >= 0
			lnTop = loForm.Top + ( loForm.TextHeight( "X" ) * ( tnTop + 1 ))
			lnLeft = loForm.Left + ( loForm.TextWidth( "X" ) * tnLeft )

		Else
			lnTop = -1
			lnLeft = -1

		Endif

		loParam = Createobject( "Empty" )

		AddProperty( loParam,"nTop", lnTop )
		AddProperty( loParam,"nLeft", lnLeft )
		AddProperty( loParam,"dDate", ldDate )

		If !Empty( tcCaption )
			AddProperty( loParam,"TitleBar", 1 )
			AddProperty( loParam,"Caption", tcCaption )
		Endif

		*Do Form "Rutinas\Scx\S_Fecha" With loParam To ldDate
		Do Form "Rutinas\Scx\S_Fecha" Name loFecha Linked With loParam To ldDate

		*		loFecha.Visible = .T.

		*!*			loKeyCalMonthForm = loFecha.Fecha
		*!*			*loCalendar = Newobject( "CalDateMonthModal", "FW\Comunes\Vcx\taDatePicker.vcx" )
		*!*			loCalendar = Newobject( "CalDateMonthInTopLevelForm", "FW\Comunes\Vcx\taDatePicker.vcx" )

		*!*			loCalendar.Visible = .F.
		*!*			loKeyCalMonthForm.oCalendar = loCalendar
		*!*			With loCalendar.taCalendar
		*!*				.CurrentDayBackcolor 	= loKeyCalMonthForm.CalCurrentDayBackcolor
		*!*				.DayAndHeaderForecolor 	= loKeyCalMonthForm.CalDayAndHeaderForecolor
		*!*				.DefaultWindowColor 	= loKeyCalMonthForm.CalDefaultWindowcolor
		*!*				.ShortDay 				= loKeyCalMonthForm.CalShortDay
		*!*				.TodayForecolor 		= loKeyCalMonthForm.CalTodayForecolor
		*!*				.WeekdayHeaderForecolor = loKeyCalMonthForm.CalWeekdayHeaderForecolor
		*!*			Endwith

		*!*			loKeyCalMonthForm.lCalendarInstantiated = .T.

		*!*			Set Step On

		*!*			loKeyCalMonthForm.SetPosition()	&& Position the popup calendar
		*!*	*		loKeyCalMonthForm.Top = lnTop
		*!*	*		loKeyCalMonthForm.Left = lnLeft

		*!*			*!*				ldDate = Iif( Empty( .KeyDate.Value ), Date(), .KeyDate.Value )

		*!*			loCalendar.oParent = loKeyCalMonthForm.Parent	&& Topmost container ( Control )
		*!*			loCalendar.taCalendar.Date = ldDate		&& Load the current date
		*!*			loCalendar.Show()




		*loFecha.Fecha.cmdKeyDate.Click()


		*ldDate = loFecha.oParametros.dFecha



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loCalendar = Null
		loKeyCalMonthForm = Null
		loFecha = Null

	Endtry

	Return ldDate

Endproc && xxxS_Fecha

Note: Mensaje de Alerta

* Parametros: cTEXT = Texto  de alerta
*			  cMSG	= Mensaje aclaratorio
*			  cFUNC = Funcion de usuario
*			  cCHAR = Caracter que separa en hasta 5 lineas el texto de alerta
* Devuelve:   Codigo ASCII de la tecla presionada

*!*							nConfirm=S_ALERT("SE ACTUALIZARAN LOS SALDOS DE STOCK SEGUN LA CARGA ",;
*!*								"[F5]:  CONTINUA     [ESC]: CANCELA",;
*!*								"I_INKEY(F5,ESCAPE,0,0,0,0,0,0,0,0)" )


Func S_ALERT
	*	Para cTEXT,cMSG,cFUNC,cCHAR
	Lparameters tcMessageText As String, ;
		tnDialogBoxType As Integer, ;
		tcTitleBarText As String, ;
		tnTimeout As Integer, ;
		tcChar As Character

	Local lnKey As Integer

	Local lcTextoDeAlerta As String,;
		lcMensajeAclaratorio As String,;
		lcFuncionDeUsuario As String,;
		lcKeyPressList As String


	Try

		lnKey = 0

		If Vartype( tnDialogBoxType ) = "C"
			lcTextoDeAlerta 		= tcMessageText
			lcMensajeAclaratorio 	= tnDialogBoxType
			lcFuncionDeUsuario 		= tcTitleBarText
			lcKeyPressList 			= ""

			lnKey = UserKeyPress( lcTextoDeAlerta,;
				lcMensajeAclaratorio,;
				lcKeyPressList,;
				"",;
				lcFuncionDeUsuario )

		Else

			*MESSAGEBOX(eMessageText [, nDialogBoxType ][, cTitleBarText][, nTimeout])


			If Empty( tcChar )
				tcChar = ";"
			Endif

			If Empty( tnDialogBoxType )
				tnDialogBoxType = MB_ICONEXCLAMATION
			Endif

			If Empty( tcTitleBarText )
				Local loForm As Form

				loForm = GetActiveForm()
				tcTitleBarText = loForm.Caption
			Endif

			If Empty( tnTimeout )
				tnTimeout = 0
			Endif

			tcMessageText = Strtran( tcMessageText, tcChar, Chr( 13 ) )

			lnKey = Messagebox( tcMessageText, tnDialogBoxType, tcTitleBarText, tnTimeout )

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Retu lnKey



	*
	* Pide al usuario que presione una tecla

	*	TEXT To cTextoDeAlerta NoShow TextMerge Pretext 03
	*	El proceso ya está terminado.

	*	¿Qué quiere hacer ahora?
	*	ENDTEXT

	*	TEXT To cMensajeAclaratorio NoShow TextMerge Pretext 03
	*	[F5]: CONTINUA  [F8]: IMPRIME  [ENTER]: EXPORTA         [ESC]: CANCELA
	*	EndText

	*   No es necesario pasar KEY_ESCAPE
	*	Text To cKeyPressList NoShow TextMerge Pretext 15
	*	<<KEY_F5>>, <<KEY_F8>>, <<KEY_ENTER>>
	*	EndText


	*   Solo se usa por compatibilidad con S_Alert() antiguo
	*	Text To cFuncionDeUsuario NoShow TextMerge Pretext 15
	*	I_INKEY( KEY_F5, KEY_ESCAPE, 0, 0, 0, 0, 0, 0, 0, 0 )
	*	EndText

Procedure UserKeyPress( cTextoDeAlerta As String,;
		cMensajeAclaratorio As String,;
		cKeyPressList As String,;
		cPicture As String,;
		cFuncionDeUsuario As String,;
		oProperties As Object ) As Integer;
		HELPSTRING "Pide al usuario que presione una tecla"

	Local lcCommand As String
	Local lnKey As Integer

	Try

		lcCommand = ""

		Do Form "Rutinas\Scx\frmUserKeyPress.scx" With cTextoDeAlerta,;
			cMensajeAclaratorio,;
			cKeyPressList,;
			cPicture,;
			cFuncionDeUsuario,;
			oProperties  To lnKey


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnKey

Endproc && UserKeyPress


*
* Confirma con Tecla Especial
Procedure Confirmar( cMessageText As String,;
		nKey As Integer,;
		cMensajeAclaratorio As String,;
		cPicture As String ) As Boolean ;
		HELPSTRING "Confirma con Tecla Especial"

	Local lcCommand As String
	Local llOk As Boolean

	Local lcTextoDeAlerta As String,;
		lcMensajeAclaratorio As String,;
		lcKeyPressList As String,;
		lcPicture As String,;
		lcFuncionDeUsuario As String,;
		loProperties As Object,;
		lnKey As Integer

	Try

		lcCommand = ""

		TEXT To lcTextoDeAlerta NoShow TextMerge Pretext 03
		Confirmación General

		¿Confirma generación del Comprobante?
		ENDTEXT

		TEXT To lcMensajeAclaratorio NoShow TextMerge Pretext 03
		[F5]:  CONFIRMA                    [ESC]: CANCELA
		ENDTEXT

		TEXT To lcKeyPressList NoShow TextMerge Pretext 15
		<<KEY_F5>>
		ENDTEXT

		lcFuncionDeUsuario = ""
		lnKey = KEY_F5

		lcPicture = "FW\Comunes\image\jpg\atencion.jpg"

		loProperties = Null

		If !Empty( cMessageText )
			lcTextoDeAlerta = cMessageText
		Endif

		If !Empty( nKey )
			lnKey = nKey
			lcKeyPressList = Transform( nKey )
		Endif

		If !Empty( cMensajeAclaratorio )
			lcMensajeAclaratorio = cMensajeAclaratorio
		Endif

		If !Empty( cPicture )
			lcPicture = cPicture
		Endif

		llOk = ( UserKeyPress( lcTextoDeAlerta,;
			lcMensajeAclaratorio,;
			lcKeyPressList,;
			lcPicture,;
			lcFuncionDeUsuario ) = lnKey )


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return llOk

Endproc && Confirmar



* Funciones y procedimientos para manejo de fechas (F)
* 19 de Mayo de 1988
*----------------------------------------------------------------------------*

Note: Convertir una Fecha tipo <mm/dd/aa> al formato [mmm dd, aaaa].
Note Par: 1.Fecha en formato Date

Function F_Today
	Parameters Prm01
	Private F051,F052

	Prm01=F_Date(Prm01)
	Store Null To F051,F052
	F051 = 'ENEFEBMARABRMAYJUNJULAGOSEPOCTNOVDIC'
	F052 = Month(Prm01) * 3 - 2
	Return (Substr(F051,F052,3)+' '+Str(Day(Prm01),2)+', '+Str(Year(Prm01),4))

	Note: Convertir una Fecha Date a aammdd
	Note Par: 1.Fecha en formato Date
	Note Par: 2.si existe. la convierte a aaaammdd

Function F_Feca
	Parameters Prm01,Prm02
	Prm01=F_Date(Prm01)
	Do Case
		Case Pcount()=2
			Retu Dtos(Prm01)
		Otherwise
			Prm01=Dtoc(Prm01)
			Return (Subs(Prm01,7,2)+Subs(Prm01,4,2)+Subs(Prm01,1,2))
	Endcase

	Note: Convertir una Fecha aammdd a Date
	Note Par: 1.Fecha en formato aammdd
	Note Par: 2.si existe, recibe la Fecha en formato aaaammdd

Function xxxF_Cafe
	Parameters Prm01,Prm02
	Do Case
		Case Pcount()=2
			Return (Ctod(Subs(Prm01,7,2)+'/'+Subs(Prm01,5,2)+'/'+Subs(Prm01,1,4)))
		Otherwise
			Return (Ctod(Subs(Prm01,5,2)+'/'+Subs(Prm01,3,2)+'/'+Subs(Prm01,1,2)))
	Endcase


	*
	* Converit una fecha "aammdd" a Date
Procedure F_Cafe( cFecha As String, vDummy As Variant ) As Date ;
		HELPSTRING "Converit una fecha [aammdd] a Date"

	Local lcCommand As String,;
		lcFecha As String
	Local ldDate As Date
	Local lnLen As Integer

	Try

		lcCommand 	= ""
		cFecha 		= Alltrim(cFecha)

		lnLen = Len( cFecha )

		If !Inlist( lnLen, 6, 8 )
			Error "Error en la longitud de la fecha pasada a F_CaFe()"
		Endif

		If lnLen = 8
			lcFecha = cFecha

		Else
			If Val( Substr( cFecha, 1, 2 ) ) < 80
				lcFecha = "20" + cFecha

			Else
				lcFecha = "19" + cFecha

			Endif

		Endif

		ldDate = Evaluate( "{^" + Transform( lcFecha, "@R 9999/99/99" ) + "}" )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return ldDate

Endproc && F_CaFe


Note: Convertir una Fecha inferior a 1980 en siglo 21
Note Par: 1.Fecha en formato Date

Function F_Date
	Parameters Prm01
	Private PAux

	Local ldReturn As Date
	Local lcCentury As String

	Try

		lcCentury = Set("Century")

		Store Null To PAux
		Set Century On

		Do Case
			Case Empty(Prm01)
				ldReturn = Prm01

			Case Prm01<Ctod("01/01/1980")
				PAux=Dtos(Prm01)
				PAux=Stuff(PAux,1,2,"20")
				ldReturn = (Ctod(Subs(PAux,7,2)+'/'+Subs(PAux,5,2)+'/'+Subs(PAux,1,4)))

			Otherwise
				ldReturn = Prm01

		Endcase

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Set Century &lcCentury

	Endtry

	Return ldReturn


	Note: Ingresar una Fecha Y validarla Para siglo 21
	Note Par: 1.@Fecha
	*		  2.Fila
	*		  3.Columna
	*		  4.Condicion


Proc F_GET
	Para Prm01,Prm02,Prm03,Prm04
	Private F_001

	* RA 2011-11-12(13:43:59)
	* Si por algun motivo, alguna consulta cambia el seteo
	* de la fecha, aquí me aseguro de que se vuelva a poner como corresponde
	Set Date Dmy

	Store Null To F_001
	Do Case
		Case Pcount()=3
			Prm04=".T."
	Endcase

	S_Line24(ACL6)

	*!*		@ Prm02,Prm03 Get Prm01 Picture "@D" Valid &Prm04
	@ Prm02,Prm03 Get Prm01 Picture "@D" Valid Evaluate( Prm04 )
	Read

	SayMask( Prm02, Prm03, Prm01, "@D" )

	Retu



	Note: Reemplazar la funcion Ctod() Para validar a¤Os bisiestos

	Note Par: 1.Fecha

Func F_CTOF
	Para Pr1
	Do Case
		Case Empty(Pr1)
			Retu Ctod(Pr1)

		Case Empty(Substr(Pr1,1,2)) .And. ;
				EMPTY(Substr(Pr1,4,2)) .And. ;
				EMPTY(Substr(Pr1,7))

			Retu Ctod(Pr1)
	Endcase
	Do Case
		Case Val(Right(Pr1,2))<80
			Pr1=Substr(Pr1,1,6)+"20"+Right(Pr1,2)
		Otherwise
			Pr1=Substr(Pr1,1,6)+"19"+Right(Pr1,2)
	Endcase

	Retu Ctod(Pr1)



	* Funciones y procedimientos para manejo de datos alfanumericos (C)
	* 19 de Mayo de 1988
	*----------------------------------------------------------------------------*

	Note: Generar formato Compatible con claves alfabeticas
	Note Par: 1. clave

Function C_Alfkey
	Parameters Prm01
	Return (Upper(Trim(Prm01)))

	Note: Generar datos alfabeticos Para grabacion
	Note Par: 1. dato

Function C_Alfrpl
	Parameters Prm01
	Return (Ltrim(Prm01)+Space(Len(Prm01)-Len(Ltrim(Prm01))))

	Note: Centrar una sarta, dada una Longitud de texto, agregando blancos.
	Note Par: 1. texto,
	*		  2. Longitud,
	*		  3. Ubicacion: 0: Centrada, 1: Izquierda, 2: Derecha
	*
Function C_Center
	Parameters Prm01,Prm02,Prm03
	Private F061,F062
	Try

		Store Null To F061,F062
		Do Case
			Case Pcount()<3
				***Prm03=Default("Prm03",0)
				Prm03=0
		Endcase
		Do Case
			Case Prm03=0
				F061 = Int((Prm02-Len(Prm01))/2)
				F062 = F061
			Case Prm03=1
				F061 = 0
				F062 = Prm02-Len(Prm01)
			Otherwise
				F061 = Prm02-Len(Prm01)
				F062 = 0
		Endcase

		F061 = Max( F061, 9 )
		F062 = Max( F062, 9 )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return (Space(F061)+Prm01+Space(F062))




	Note: Edicion centrada
	Note Par: 1. Nro. de linea, 2. texto, 3. Longitud

Procedure C_Centro( nRow As Integer,;
		cTexto As String,;
		nLen As Integer )

	Try

		cTexto = Substr( cTexto, 1, nLen )
		@ nRow, Int(( nLen - Len( cTexto )) / 2 ) Say cTexto

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return

	Note: Dividir una sarta en Dos
	Note Par: @1. Variable, 2. Longitud de la sarta
	Note Ret: Devuelve la segunda linea Y carga en la Variable original la primera

Function C_Divido
	Parameters Prm01,Prm02
	Do Case
		Case Len(Prm01)<=Prm02
			Return(' ')
	Endcase
	Private F071,F072

	Store Null To F071,F072
	F071=Prm02
	Do While Subs(Prm01,F071,1)<>' ' .And. F071<>1
		F071=F071-1
	Enddo
	F072=Subs(Prm01,Iif(F071=1,Prm02,F071),Len(Prm01))
	Prm01=Subs(Prm01,1,Iif(F071=1,Prm02,F071))
	Return (F072)


	Note: Justificar una leyenda a la derecha
	Note: Par metros: nRow,cString,nRightCol
Procedure C_Derecha( nRow, cString, nRightCol, lNotTrimmed )
	Local lnLen, lnCol

	Local lcCommand As String

	Try

		lcCommand = ""

		If !lNotTrimmed
			cString  =  Alltrim( cString )
		Endif

		lnLen     =  Len( cString )
		lnCol     =  Min( nRightCol - lnLen + 1, nRightCol )

		If lnCol<0
			lnCol=0
		Endif

		@ nRow, lnCol   Say   cString

	Catch To loErr

		Do Case
			Case oErr.ErrorNo = 30
				Assert .F. Message "La posición de fila o de columna está fuera de la pantalla."

			Otherwise
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = lcCommand
				loError.Process ( m.loErr )

		Endcase

	Finally

	Endtry

	Retu


	Note: Devuelve la columna que utiliza C_Derecha
	Note: cString,nRightCol,nTrim
Procedure N_Derecha
	Para cString,nRightCol,nTrim
	Private nLen,nCol
	Store Null To nLen,nCol

	If !Empty( nTrim )
		cString = Alltrim( cString )
	Endif

	nLen     =  Len( cString )
	nCol     =  Min( nRightCol - nLen + 1, nRightCol )

	If nCol<0
		nCol=0
	Endif

	Return nCol


	* Funciones y procedimientos para ingreso, validacion y consistencia de datos (I)
	* 19 de Mayo de 1988
	*----------------------------------------------------------------------------*

	Note: Devolver Valor en Ascii de la tecla oprimida
	Note Par: 1,2,3,4,5,6,7,8,9,10. Valores permitidos

Function I_Inkey
	Parameters Prm01,Prm02,Prm03,Prm04,Prm05,Prm06,Prm07,Prm08,Prm09,Prm010
	Private F081
	Store Null To F081
	Set Cursor Off

	If Vartype( m.AUDITORIA ) # "L"
		m.AUDITORIA = .F.
	Endif

	Keyboard "" Plain Clear
	Inkey()
	Inkey()

	F081=9999

	Do While !Inlist( F081, Prm01, Prm02, Prm03, Prm04, Prm05, Prm06, Prm07, Prm08, Prm09, Prm010, KEY_CTRL_F10, KEY_CTRL_F12 )
		F081=Inkey( 0 )
		F081=Iif(F081<>0,F081,9999)

		If m.AUDITORIA
			If F081 = KEY_ALT_F12
				ShowTransaction()
			Endif
		Endif
	Enddo
	Set Cursor On

	If Inlist( F081, KEY_CTRL_F10, KEY_CTRL_F12 )
		*Keyboard Chr( F081 )
		F081 = Escape
	Endif

	prxSetLastKey( F081 )

	Return(F081)

	Note: Pedido de una clave en abm de archivos
	Note Par: 1. @Variable, 2. Picture, 3. Valor inicial, 4. (1):num (2):alf,
	*         5. (1):Alta (2)modif,6. X, 7. Y, 8. (1):modif.Clave Alfa (2):No
	*         9. Valor a adicionar en clave, .10. Longitud clave, 11. .T. Toma 999
	Note Ret: (1): Escape, (2): Empty, (3): Valor

Function I_Askey
	Parameters Prm01,Prm02,Prm03,Prm04,Prm05,Prm06,Prm07,Prm08,Prm09,Prm10,Prm11
	Private F091,F092,cPicCli

	Try

		Store Null To F091,F092
		Store Null To cPicCli

		If Type("K_PICCLI")#"C"
			K_PICCLI = Replicate( "9", gnCodi4 )
		Endif

		Do Case
			Case Pcount()=8
				Prm09=''
				Prm10=0
				Prm11=.F.

			Case Pcount()=9
				Prm10=0
				Prm11=.F.

			Case Pcount()=10
				Prm11=.F.
		Endcase

		Do Case
			Case Type("K_PICCLI")="C"
				cPicCli=K_PICCLI
			Otherwise
				cPicCli=Repl('9',Prm10)
		Endcase

		prxLastkey()

		F091=Prm03
		F092=Iif(Prm05=1,'Found()','!Found()')
		@ Prm06,Prm07 Get F091 Picture Prm02
		prxExecuteKeyboard()
		Read

		SayMask( Prm06, Prm07, F091, Prm02, Prm10 )
		prxLastkey()

		DoEvents

		If ( Prm04 = 1 ) ;
				And !Empty( F091 ) ;
				And Upper(Alias()) = "AR4VAR"

			=Seek( Prm09+Str(F091,gnCodi4), "ar4Var", "pk4Var" )

			loReg = Createobject( "Empty" )
			AddProperty( loReg, "Tipo4", Prm09 )
			AddProperty( loReg, "Codi4", F091 )

		Endif

		If !Empty( F091 ) ;
				And !&Aborta ;
				And !( Prm11 = .T. And F091 == Iif( Prm04 = 1, Val( cPicCli ), Replicate( 'X', Prm10 ) ))

			If Prm04=2
				If Prm08=1
					Seek Prm09+C_Alfkey(F091)

				Else
					Seek Prm09+F091

				Endif

			Else
				If Empt(Prm09)
					Seek F091

				Else
					If Upper(Alias()) = "AR4VAR"
						* RA 2013-05-01(12:03:09)
						* La cantidad de digitos de Codi4 está parametrizada en gnCodi4
						Seek Prm09+Str(F091,gnCodi4)

					Else
						Seek Prm09+Str(F091,Prm10)

					Endif

				Endif
			Endif
		Endif

		Do While &F092 ;
				And !Empty( F091 ) ;
				And !&Aborta ;
				And !( Prm11 = .T. And F091 == Iif( Prm04 = 1, Val( cPicCli ), Replicate( 'X', Prm10 ) ))

			Do S_Line22 With Iif(Prm05=1,Err4,Err3)
			Do Case
				Case Prm05=2
					Keyboard '{F1}'
			Endcase
			@ Prm06,Prm07 Get F091 Picture Prm02
			Read

			SayMask( Prm06, Prm07, F091, Prm02, Prm10 )

			prxLastkey()

			Do Case
				Case !Empty(F091)
					Do Case
						Case Prm04=2
							Do Case
								Case Prm08=1
									Seek Prm09+C_Alfkey(F091)
								Otherwise
									Seek Prm09+F091
							Endcase
						Otherwise
							Do Case
								Case Empt(Prm09)
									Seek F091
								Otherwise
									If Upper(Alias()) = "AR4VAR"
										* RA 2013-05-01(12:03:09)
										* La cantidad de digitos de Codi4 está parametrizada en gnCodi4
										Seek Prm09+Str(F091,gnCodi4)

									Else
										Seek Prm09+Str(F091,Prm10)

									Endif

							Endcase
					Endcase
			Endcase
		Enddo
		*!*			@ Prm06,Prm07 Say F091 Picture Prm02
		*!*			@ 22,0 Say Spaces
		Stor F091 To &Prm01


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry


	Return (Iif(&Aborta,1,Iif(Empty(F091),2,3)))
Endproc



Note: funcion de validacion parametrica
Note: 1. True o False

Function I_Valida
	Parameters Prm01,tcMsg
	Return(Prm01)

Function xxx___I_Valida
	Parameters Prm01,tcMsg


	Do Case
		Case Prm01
			*!*				@ 22,0
		Case !Empty( tcMsg )
			Warning( tcMsg, ERR2 )
			Clear Typeahead
			prxSetLastKey( 0 )

		Otherwise
			Do S_Line22 With ERR2
	Endcase
	Return(Prm01)

	Note: funcion de validacion de datos obligatorios
	Note Par: 1. Campo a validar

Function I_Valobl
	Parameters Prm01,tcMsg
	If Empty( tcMsg )
		tcMsg = "Dato Obligatorio"
	Endif
	Return(I_Valida(!Empt(Prm01).Or._Screen.oApp.nKeyCode=Arriba,tcMsg))

	Note: funcion de validacion de datos por mayor o igual a determ. Valor
	Note Par: 1. Campo a validar    2. Valor del rango

Function I_Valmoi
	Parameters Prm01,Prm02,tcMsg

	If Empty( tcMsg )
		tcMsg = ""
		TEXT To tcMsg NoShow TextMerge Pretext 03
		Dato inválido
		Debe ser MAYOR O IGUAL que: [ <<Prm02>> ]
		ENDTEXT
	Endif

	Return(I_Valida(Prm01>=Prm02,tcMsg))

	Note: funcion de validacion de datos por mayor a determ. Valor
	Note Par: 1. Campo a validar, 2. Valor del rango

Function I_Valmay
	Parameters Prm01,Prm02,tcMsg

	If Empty( tcMsg )
		tcMsg = ""
		TEXT To tcMsg NoShow TextMerge Pretext 03
		Dato inválido
		Debe ser MAYOR que: [ <<Prm02>> ]
		ENDTEXT
	Endif

	Return(I_Valida(Prm01>Prm02,tcMsg))

	Note: funcion de validacion de datos por menor a determ. Valor
	Note Par: 1. Campo a validar, 2. Valor del rango

Function I_Valmin
	Parameters Prm01,Prm02,tcMsg

	If Empty( tcMsg )
		tcMsg = ""
		TEXT To tcMsg NoShow TextMerge Pretext 03
		Dato inválido
		Debe ser MENOR que: [ <<Prm02>> ]
		ENDTEXT
	Endif

	Return(I_Valida(Prm01<Prm02,tcMsg))


	Note: funcion de validacion de datos por menor o igual a determ. Valor
	Note Par: 1. Campo a validar, 2. Valor del rango

Function I_ValMinIgu
	Parameters Prm01,Prm02,tcMsg

	If Empty( tcMsg )
		tcMsg = ""
		TEXT To tcMsg NoShow TextMerge Pretext 03
		Dato inválido
		Debe ser MENOR Ó IGUAL que: [ <<Prm02>> ]
		ENDTEXT
	Endif

	Return(I_Valida(Prm01<=Prm02,tcMsg))

	Note: funcion de validacion de existencia de registros en un archivo
	Note Par: 1. clave a validar, 2. Desea mostrar Campo, 3. X, 4. Y,
	*         5. Nombre del campo a mostrar, 6. Picture del campo a mostrar

Function I_Valexi
	Parameters Prm01,Prm02,Prm03,Prm04,Prm05,Prm06
	Private Wvali
	Store Null To Wvali
	Seek Prm01
	Do Case
		Case !Eof()
			Do Case
				Case Prm02 = 1
					*@ Prm03,Prm04 Say &Prm05 Picture Prm06
					SayMask( Prm03, Prm04, &Prm05, Prm06 )
			Endcase
			*!*				@ 22,0
			Return(True)
		Otherwise
			Do S_Line22 With Err3
			Return(False)
	Endcase


	Note: funcion de validacion de no existencia de registros en un archivo
	Note Par: 1. clave a validar

Function I_Valnoex
	Parameters Prm01
	Private Wvali
	Store Null To Wvali
	Seek Prm01
	Do Case
		Case Eof()
			*!*				@ 22,0
			Return(True)
		Otherwise
			Do S_Line22 With Err4
			Return(False)
	Endcase

	Note: funcion de validacion de datos dentro de un rango
	Note Par: 1. Campo a validar, 2. rango inferior, 3. rango superior

Function I_Valran
	Parameters Prm01,Prm02,Prm03,tcMsg

	If Empty( tcMsg )
		tcMsg = ""
		TEXT To tcMsg NoShow TextMerge Pretext 03
		Dato inválido
		Debe encontrarse ENTRE [ <<Prm02>> ] y [ <<Prm03>> ]
		ENDTEXT
	Endif

	*Return(I_Valida(Prm01>=Prm02 .And. Prm01<=Prm03,tcMsg))
	Return( I_Valida( Between( Prm01, Prm02, Prm03 ), tcMsg ) )

	Note: funcion de validacion de datos por igualdad a determ. Valor
	Note Par : 1: Campo a validar    2: Valor

Function I_Valigu
	Parameters Prm01,Prm02,tcMsg

	If Empty( tcMsg )
		tcMsg = ""
		TEXT To tcMsg NoShow TextMerge Pretext 03
		Dato inválido
		Debe ser IGUAL a: [ <<Prm02>> ]
		ENDTEXT
	Endif

	Return(I_Valida(Prm01=Prm02,tcMsg))

	Note: funcion de validacion de datos por desigualdad a determ. Valor
	Note Par : 1: Campo a validar    2: Valor

Function I_Valdis
	Parameters Prm01,Prm02,tcMsg

	If Empty( tcMsg )
		tcMsg = ""
		TEXT To tcMsg NoShow TextMerge Pretext 03
		Dato inválido
		Debe ser DISTINTO que: [ <<Prm02>> ]
		ENDTEXT
	Endif

	Return(I_Valida(Prm01<>Prm02,tcMsg))

	Note: funcion de validacion de pertenencia a una sarta
	Note Par: 1. Campo a validar, 2. sarta a comparar

Function I_Valstr
	Parameters Prm01,Prm02,tcMsg

	If Empty( tcMsg )
		tcMsg = ""
	Endif

	Return(I_Valida(Prm01$Prm02,tcMsg))

	Note: validacion de una formula de calculo
	Note Par: 1. formula a validar, 2. sarta de variables permitidas

Function I_Valfor
	Parameters Prm01,Prm02
	Private F141,F142,F143,F144
	Store Null To F141,F142,F143,F144
	Do Case
		Case !Empty(Prm01)
			F141=Trim(Prm01)
			F142=' '
			F143=0
			For wi=1 To Len(F141)
				F144=Subs(F141,wi,1)
				Do Case
					Case F144<>' '
						Do Case
							Case !(F144$' ()+-*/.0123456789' .Or. F144$Prm02)
								F143=1
								Exit
							Case F144$'0123456789' .And. !F142$' (+-*/.0123456789'
								F143=1
								Exit
							Case F144$Prm02 .And. !F142$' (+-*/'
								F143=1
								Exit
							Case F144$'+-*/' .And. !(F142$' 0123456789.' .Or. F142$Prm02;
									.Or. F142=')')
								F143=1
								Exit
							Case F144$'.' .And. !F142$' 0123456789'
								F143=1
								Exit
							Case F144$'('
								Do Case
									Case !F142$' +-*/('
										F143=1
										Exit
									Otherwise
										F143=F143+1
								Endcase
							Case F144$')'
								Do Case
									Case !(F142$' 0123456789.)' .Or. F142$Prm02)
										F143=1
										Exit
									Otherwise
										F143=F143-1
								Endcase
						Endcase
						F142=F144
				Endcase
			Next
			Do Case
				Case F143<>0
					Do S_Line22 With ERR2
					Return(False)
				Otherwise
					*!*						@ 22,0
					Return(True)
			Endcase
		Otherwise
			Return(True)
	Endcase

	Note: funcion de ingreso del tipo de comprobante o movimiento
	Note Par: 1. Valor Ascii de la primer tecla a oprimir
	*         2. Valor ASCII de la segunda tecla a oprimir
	*         3. 1: A y B , 2: A, B y M , 3: A
	*         4. Mensaje en linea 23
	*         5/10. Opciones (A)
	*         11. Nombre de la variable donde va la opcion elegida
	Note Ret: " ":Escape, "A", "B" o "M"

Function I_Ingtip
	Parameters Prm01,Prm02,Prm03,Prm04,Prm05,Prm06,Prm07,Prm08,Prm09,Prm10,Prm11
	Private F141,F142

	Local lcReturn As Character
	Local loForm As frmdisplaywindow Of Rutinas\Vcx\clipper2fox.Vcx
	Local i As Integer

	Try

		Store Null To F141,F142

		lcReturn = ' '

		loForm = GetActiveForm()

		If Asterisco And !Empty( Prm03 )
			loForm.cntTitulo.Label1.Caption = ""

			loForm.cntTitulo.Label1.Left 			= 0
			loForm.cntTitulo.lblTitulo.Left 		= 0
			loForm.cntTitulo.lblObservaciones.Left 	= loForm.cntTitulo.lblTitulo.Width + 10
			loForm.cntTitulo.lblFecha.Left 			= loForm.Width - loForm.cntTitulo.lblFecha.Width - 05
		Endif

		S_Line23( Prm04 )
		S_Line24( Acl1 )

		If Pcount()=4
			Store 0 To Prm05,Prm06,Prm07,Prm08,Prm09,Prm10
			Prm11=True
		Endif

		If Inlist( Prm03, Asc( "A" ), Asc( "B" ), Asc( "M" ) )
			* RA 09/08/2020(12:15:25)
			* Forzar devolución sin intervención del usuario
			Do Case
				Case Prm03 = Asc( "A" )
					If Asterisco And !Empty( Prm03 )
						loForm.cntTitulo.Label1.Caption = ""
					Endif

					lcReturn = 'A'


				Case Prm03 = Asc( "B" )

					Set Cons On
					Tone(100,2)
					Set Cons Off

					If Asterisco And !Empty( Prm03 )
						loForm.cntTitulo.Label1.Caption = "*"
					Endif

					lcReturn = 'B'

				Case Prm03 = Asc( "M" )
					Set Cons On
					Tone(100,2)
					Tone(100,2)
					Set Cons Off

					If Asterisco And !Empty( Prm03 )
						loForm.cntTitulo.Label1.Caption = "**"
					Endif

					lcReturn = 'M'

			Endcase

		Else

			F141=I_Inkey(Enter,Escape,Iif(Prm03<>3,Prm01,0),Iif(Prm03=2,Prm02,0),;
				Prm05,Prm06,Prm07,Prm08,Prm09,Prm10)

			If Pcount()<>4
				&Prm11=F141
			Endif

			Do Case
				Case F141=Prm05 .Or. F141=Prm06 .Or. F141=Prm07 .Or. F141=Prm08 .Or. ;
						F141=Prm09 .Or. F141=Prm10 .Or. F141=Enter

					If Asterisco And !Empty( Prm03 )
						loForm.cntTitulo.Label1.Caption = ""
					Endif

					lcReturn = 'A'

				Case F141=Escape
					prxSetLastKey( Escape )


				Otherwise
					F142=I_Inkey(Enter,Escape,Iif(F141=Prm02,Prm01,0),Iif(F141=Prm01,Prm02,0);
						,Prm05,Prm06,Prm07,Prm08,Prm09,Prm10)

					If Pcount()<>4
						&Prm11=F142
					Endif

					Do Case
						Case F142=Prm05 .Or. F142=Prm06 .Or. F142=Prm07 .Or. F142=Prm08 .Or. ;
								F142=Prm09 .Or. F142=Prm10 .Or. F142=Enter

							If Asterisco And !Empty( Prm03 )
								loForm.cntTitulo.Label1.Caption = ""
							Endif

							lcReturn = 'A'

						Case F142=Escape
							prxSetLastKey( Escape )

						Case F141=Prm01 .And. F142=Prm02
							Set Cons On
							Tone(100,2)
							Set Cons Off

							If Asterisco And !Empty( Prm03 )
								loForm.cntTitulo.Label1.Caption = "*"
							Endif

							lcReturn = 'B'

						Case F141=Prm02 .And. F142=Prm01
							Set Cons On
							Tone(100,2)
							Tone(100,2)
							Set Cons Off

							If Asterisco And !Empty( Prm03 )
								loForm.cntTitulo.Label1.Caption = "**"
							Endif

							lcReturn = 'M'

					Endcase
			Endcase
		Endif

		loForm.cntTitulo.Label1.Left 			= 0
		loForm.cntTitulo.lblTitulo.Left 		= loForm.cntTitulo.Label1.Width
		loForm.cntTitulo.lblObservaciones.Left 	= loForm.cntTitulo.lblTitulo.Left + loForm.cntTitulo.lblTitulo.Width + 10
		loForm.cntTitulo.lblFecha.Left 			= loForm.Width - loForm.cntTitulo.lblFecha.Width - 05


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loForm = Null

	Endtry

	Return lcReturn

Endproc


* Funciones y procedimientos para impresion y listados (L)
* 19 de Mayo de 1988
*----------------------------------------------------------------------------*

Note: Seteo inicial
Note Par: 1. Secuencia de Control

*!*	Procedure L_Setini
*!*		Parameters Prm01
*!*		Page=0
*!*		Line=70
*!*		Do Case
*!*			Case L_Control()
*!*				Set Device To Print
*!*				@ 0,0 Say Prm01
*!*		Endcase
*!*		Return

Note: Seteo Final

*!*	Procedure L_Setfin
*!*		Set Device To Print
*!*		*	@ PROW(),PCOL() Say Chr(12)
*!*		@ 0,0 Say Chr(27)+'@'
*!*		Set Printer To
*!*		Set Device To Screen
*!*		Return

Note: Impresion del Titulo de un listado
Note Par: 1. Nombre del cliente, 2. Titulo, 3. Ancho de la Impresion,
*         4. Fecha,5. Observaciones, 6. Nombre de la rutina de impresion,
*         7. Cantidad de renglones por linea, 8. Segunda Observacion (opcional)

Procedure L_Titlis( tcRazonSocial, tcTitulo, tnAncho, tdFecha, tcObservacion1, tcUDF, tnRenglones, tcObservacion2 )

	*!*	        Insert Into cGlobal ( RazonSocial,;
	*!*	    	Fecha,;
	*!*	    	Titulo,;
	*!*	    	Observacion1,;
	*!*	    	Observacion2 ) ;
	*!*	    	values ;
	*!*	    	( AR0EST.NOMB0,;
	*!*	    	FECHAHOY,;
	*!*	    	'LISTADO DE FACTURAS POR FECHA ' + Iif( WPROG = 1, 'DE VENCIMIENTO', 'CONTABLE' ),;
	*!*	    	WOBSE,;
	*!*	    	"" )

	Local lcAlias As String
	Try

		lcAlias = Alias()

		If Empty( tcObservacion1 )
			tcObservacion1 = ""
		Endif

		If Empty( tcObservacion2 )
			tcObservacion2 = ""
		Endif

		If Vartype( tcUDF ) <> "C"
			tcUDF = "V_NULL"
		Endif

		If Vartype( tnRenglones ) <> "N"
			tnRenglones = 0
		Endif

		If !Used( "cTitulo" )
			Create Cursor "cTitulo" ( RazonSocial C( 50 ),;
				Fecha D,;
				Titulo C( 60 ),;
				Observacion1 C( 80 ),;
				Observacion2 C( 80 )  )

			Append Blank

		Endif

		Replace RazonSocial With tcRazonSocial,;
			Fecha With tdFecha,;
			Titulo With tcTitulo,;
			Observacion1 With tcObservacion1,;
			Observacion2 With tcObservacion2 In cTitulo

		Page=Page+1
		@ 1,0 Say tcRazonSocial
		Do C_Centro With 1,tcTitulo,tnAncho
		@ 1,tnAncho-12 Say F_Today(tdFecha)
		Do C_Centro With 2,Replicate('=',Len(tcTitulo)),tnAncho
		@ 2,tnAncho-12 Say 'Hoja... '+Ltrim(Str(Page,5))
		@ 4,0 Say tcObservacion1
		Do Case
			Case Pcount()=8
				Do Case
					Case !Empty(tcObservacion2)
						@ 5,0 Say tcObservacion2
				Endcase
		Endcase
		@ Prow()+1,0 Say Replicate('-',tnAncho)
		Do &tcUDF
		If tnRenglones > 0
			@ Prow()+tnRenglones,0 Say Replicate('-',tnAncho)
		Endif
		Line=Prow()+1



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError

	Finally
		If Used( lcAlias )
			Select ( Alias( lcAlias ))
		Endif

	Endtry

	Return



	*
	*
Procedure ConfirmaImpresion( nDefaultButton As Integer,;
		cMensaje As String,;
		cPicture As String,;
		nCopias As Integer ) As Boolean

	Local lcCommand As String,;
		lcMsg As String,;
		lcPicture As String

	Local loParame As Object,;
		loReturn As Object,;
		loExporta As Object

	Local llReturn As Boolean

	Local lnCopias As Integer,;
		lnDefaultButton As Integer

	Try

		lcCommand = ""

		lcMsg 		= ""
		lcPicture 	= ""

		lnCopias 	= 0
		lnDefaultButton = 1

		llReturn 	= .F.

		If Vartype( nDefaultButton ) = "N"
			lnDefaultButton = nDefaultButton
		Endif

		If Vartype( nCopias ) = "N"
			lnCopias = nCopias
		Endif

		If Vartype( cMensaje ) = "C"
			lcMsg = cMensaje
		Endif

		If Vartype( cPicture ) = "C"
			lcPicture = cPicture
		Endif

		loExporta = Createobject( "Empty" )
		AddProperty( loExporta, "cSalidas", S_IMPRESORA )
		AddProperty( loExporta, "cDefault", S_IMPRESORA )
		AddProperty( loExporta, "nCopias", lnCopias )
		AddProperty( loExporta, "cMensaje", lcMsg )
		AddProperty( loExporta, "cPicture", lcPicture )
		AddProperty( loExporta, "nDefaultButton", lnDefaultButton )

		*		Do Form "Fw\Comunes\scx\ConfirmarImpresion.scx" With loParame To loReturn

		loReturn = ConfirmaImpresionEx( loExporta )

		llReturn = ( loReturn.nStatus = 0 )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loParame = Null
		loReturn = Null

	Endtry

	Return llReturn

Endproc && ConfirmaImpresion

*
*
Procedure ConfirmaImpresionEx( oExporta As Object ) As Object

	Local lcCommand As String,;
		lcMsg As String,;
		lcPicture As String

	Local lnCopias As Integer,;
		lnDefaultButton As Integer

	Local loReturn As Object

	Try

		lcCommand = ""

		lcMsg 		= ""
		lcPicture 	= ""

		lnCopias 	= 0
		lnDefaultButton = 1

		If Vartype( oExporta ) # "O"
			oExporta = Createobject( "Empty" )
		Endif

		If !Pemstatus( oExporta, "cSalidas", 5 )
			AddProperty( oExporta, "cSalidas", S_IMPRESORA )
		Endif

		If !Pemstatus( oExporta, "cDefault", 5 )
			AddProperty( oExporta, "cDefault", S_IMPRESORA )
		Endif

		If !Pemstatus( oExporta, "nCopias", 5 )
			AddProperty( oExporta, "nCopias", lnCopias )
		Endif

		If !Pemstatus( oExporta, "cMailTo", 5 )
			AddProperty( oExporta, "cMailTo", "" )
		Endif

		If !Pemstatus( oExporta, "cMensaje", 5 )
			AddProperty( oExporta, "cMensaje", lcMsg )
		Endif

		If !Pemstatus( oExporta, "cPicture", 5 )
			AddProperty( oExporta, "cPicture", lcPicture )
		Endif

		If !Pemstatus( oExporta, "nDefaultButton", 5 )
			AddProperty( oExporta, "nDefaultButton", lnDefaultButton )
		Endif

		If !Pemstatus( oExporta, "lTitleBar", 5 )
			AddProperty( oExporta, "lTitleBar", .F. )
		Endif

		If !Pemstatus( oExporta, "cCaption", 5 )
			AddProperty( oExporta, "cCaption", "Confirmar Impresión" )
		Endif

		Do Form "Fw\Comunes\scx\ConfirmarImpresion.scx" With oExporta To loReturn

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return loReturn

Endproc && ConfirmaImpresionEx


*
*
Procedure L_Confir( cExecute As String,;
		nLeyenda As Integer,;
		cLeyenda As String ) As Boolean

	Local lcCommand As String

	Local llReturn As Boolean

	Try

		lcCommand 	= ""

		llReturn = ConfirmaImpresion( 1,;
			cLeyenda )

		If llReturn
			If !Empty( cExecute )
				Do &cExecute
			Endif
		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return llReturn

Endproc && L_Confir

Note: Confirmacion de un listado
Note Par: 1: Nombre del proceso a realizar si se confirma (Opcional)
*         2: 1. Leyenda de confirma, 2. Leyenda de imprime
*		  3: Leyenda a mostrar (reemplaza a las preestablecidas)

Function xxxL_Confir
	Parameters Prm01,Prm02,Prm03
	Private F111,F112
	Store Null To F111,F112
	*S_Line22( Acl2, .T. )

	Local Msg2 As String
	Msg2 = '[Enter]:Confirma Impresión               [Esc]:Cancela'

	Do Case
		Case Pcount()<2
			Do S_Line23 With Msg2

		Otherwise
			Do Case
				Case Pcount()<3
					F112=Iif(Prm02=1,Msg2,'[Enter]:Imprime               [Esc]:No imprime')
				Otherwise
					F112=Prm03
			Endcase
			S_Line23(F112)
	Endcase

	Do S_Line24 With Acl1
	F111=I_Inkey(Enter,Escape,0,0,0,0,0,0,0,0)

	Do While F111=Enter .And. !Isprinter()
		Set Cons On
		Tone(100,2)
		Tone(100,2)
		Set Cons Off
		F111=I_Inkey(Enter,Escape,0,0,0,0,0,0,0,0)
	Enddo

	*!*		@ 22,0 Say Spaces
	F111=Iif(F111=Enter .And. Isprinter(),True,False)
	Wait Clear
	S_Line23("")

	Do Case
		Case F111=True
			Do S_Line23 With Msg12
	Endcase

	Do Case
		Case Pcount()<>0 .And. F111=True
			Do Case
				Case !Empt(Prm01)
					Do &Prm01
			Endcase
	Endcase

	Return (F111)

	Note: Impresion de una linea
	Note Par: 1. Nombre de la rutina de Impresion, 2. Cantidad de renglones

Procedure L_Linea
	Parameters Prm01,Prm02
	&Prm01(@Line)
	*Do &Prm01
	Skip
	Line=Line+Prm02
	Return

	Note: Pedido de rango numerico
	Note Par: 1. @rango inicial, 2. @rango Final, 3. Longitud,4. X inicial,
	*      5. y inicial, 6. x final, 7. y final, 8. @Observaciones

Function L_rangon
	Parameters Prm01,Prm02,Prm03,Prm04,Prm05,Prm06,Prm07,Prm08
	Private F101
	Store Null To F101
	Do S_Line23 With Msg10
	F101='@Z '+Replicate('9',Prm03)
	Do S_Line24 With Acl7
	@ Prm04,Prm05 Get Prm01 Picture F101
	Read

	SayMask( Prm04, Prm05, Prm01, F101, Prm03 )

	prxLastkey()

	*!*		@ Prm04,Prm05 Say Prm01 Picture F101
	Do Case
		Case &Aborta
			Return (False)
		Otherwise
			Do Case
				Case Prm01<>0
					Do S_Line24 With Acl8
					@ Prm06,Prm07 Get Prm02 Picture F101  Valid Prm02>=Prm01 .Or. Prm02=0
					Read

					SayMask( Prm06, Prm07, Prm02, F101, Prm03 )

					prxLastkey()

					*!*						@ Prm06,Prm07 Say Prm02 Picture F101
					Do Case
						Case &Aborta
							Return (False)
						Otherwise
							Do Case
								Case Prm02=0
									Prm02=Prm01
							Endcase
							Prm08='Listado desde '+Str(Prm01,Prm03)+' hasta '+Str(Prm02,Prm03)
					Endcase
				Otherwise
					Prm02=Val(Replicate('9',Prm03))
					Prm08='Listado total'
			Endcase
			Return (True)
	Endcase

	Note: Pedido de rango alfabetico
	Note Par: 1. @rango inicial, 2. @rango Final, 3. Longitud,4. X inicial,
	*      5. y inicial, 6. x final, 7. y final, 8. @Observaciones, 9. Picture
	*	  10. Si existe, no modifica clave

Function L_rangoa
	Parameters Prm01,Prm02,Prm03,Prm04,Prm05,Prm06,Prm07,Prm08,Prm09,Prm10
	Do S_Line23 With Msg10
	Do S_Line24 With Acl4

	* RA 2009-11-19(10:47:58)
	*!*		Do Case
	*!*		Case "@"$Prm09
	*!*			If "K"$Prm09

	*!*			Else
	*!*				Strtran( Prm09,"@","@K" )
	*!*			Endif

	*!*		Otherwise
	*!*			Prm02 = "@K " + Prm09

	*!*		EndCase

	@ Prm04,Prm05 Get Prm01 Picture Prm09
	Read

	SayMask( Prm04, Prm05, Prm01, Prm09, Prm03 )

	prxLastkey()

	*!*		@ Prm04,Prm05 Say Prm01 Picture Prm09
	Do Case
		Case &Aborta
			Return (False)
		Otherwise
			Do Case
				Case !Empty(Prm01)
					Do S_Line24 With Acl5
					@ Prm06,Prm07 Get Prm02 Picture Prm09  ;
						Valid Upper(Trim(Ltrim(Prm02)))>=Upper(Trim(Ltrim(Prm01))) .Or. Empty(Prm02)
					Read

					SayMask( Prm06, Prm07, Prm02, Prm09, Prm03 )

					prxLastkey()

					*!*						@ Prm06,Prm07 Say Prm02 Picture Prm09
					Do Case
						Case &Aborta
							Return (False)
						Otherwise
							Do Case
								Case Empty(Prm02)
									Prm02=Prm01
							Endcase
							Prm08='Listado desde '+Trim(Ltrim(Prm01))+' hasta '+Trim(Ltrim(Prm02))
					Endcase
				Otherwise
					Prm02=Replicate('z',Prm03)
					Prm08='Listado total'
			Endcase
			Do Case
				Case Prm10 = .F.
					Prm01=Upper(Trim(Ltrim(Prm01)))
					Prm02=Upper(Trim(Ltrim(Prm02)))
			Endcase
			Return (True)
	Endcase

	Note: Controla si la impresora esta en condiciones de imprimir
	Note Dev: .T. o .F.

Function L_Control
	Do Case
		Case !Isprinter()
			Do Whil !Isprinter() .And. !&Aborta
				Do S_Line23 With '[Enter]:Continua impresion               '+;
					'[Esc]:Interrumpe'
				Do S_Line24 With Acl1
				I_Inkey(Enter,Escape,0,0,0,0,0,0,0,0)
			Enddo
			Do Case
				Case !&Aborta
					Do S_Line23 With Msg12
					Do S_Line24 With Acl1
					Return(True)
				Otherwise
					Return(False)
			Endcase
		Otherwise
			Return(True)
	Endcase


	* Funciones y procedimientos para red (M)
	* 28 de Junio de 1991
	*----------------------------------------------------------------------------*

	Note: Intenta abrir un archivo en Forma exclusiva o compartida, o Agregar
	*     registros a un archivo compartido
	Note Dev: 1. Segundos a esperar o cero Para esperar ad eternum
	*         2. .T. Permite usar Escape para abortar la espera, .F. No permite
	*         3. .T. Muestra leyenda, .F.No muestra
	*         4. 'U':Use, 'A':Append Blank
	*         5. Nombre del archivo a abrir
	*         6. .T. Exclusivo, .F. Compartido
	*		  7. Alias
	*		  8. Cerrar si existe

Function M_FILE
	Parameters tnSegundos,tlEscape,tlMuestra,tcAction,tcFileName,tlExclusivo,tcAlias,tlClose

	Local lReturn As Boolean
	Local lQuit As Boolean
	Local lcCommand As String,;
		lcErrMsg As String,;
		lcMessage As String,;
		lcMsg As String

	Local llRetry As Boolean

	Local lcDevice As String,;
		lcAlias As String,;
		lcActual As String

	Local i As Integer,;
		lnContador As Integer,;
		lnTableValidate As Integer

	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
		loFiltro As Object,;
		loColFiltros As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg


	Try

		lQuit 			= .F.
		lReturn 		= .F.
		lcCommand 		= ""
		lcDevice 		= Set("Device")
		lnTableValidate = -1

		Set Device To Screen

		If Empty( tcAlias ) And tcAction = "U" And Vartype( tcFileName ) = "C"
			tcAlias = Juststem( tcFileName )
		Endif

		If Type("EXTENSION")="C"
			If Type("tcFileName")="C"
				tcFileName=Alltrim(tcFileName+"."+extension)
			Endif
		Endif

		lnContador=tnSegundos

		If tlEscape
			prxSetLastKey( 0 )
		Endif


		Try

			loGlobalSettings = NewGlobalSettings()
			loGlobalSettings.oAppTimer.nReset = Seconds()

			If Datetime() - loGlobalSettings.tFechaHoyChange > ( 3600 * 6 )
				* RA 02/11/2020(12:52:04)
				* Si la máquina queda encendida toda la noche, FECHAHOY queda
				* desactualizado.
				* En Personalizar se puede modificar FECHAHOY para poder trabajar
				* en otra fecha.
				* Esto permite abrir una ventana de 6 horas para permitir trabajar
				* con FECHAHOY personalizado, y que luego, vuelva a inicializarse
				* correctamente.

				FECHAHOY = Date()
				loGlobalSettings.tFechaHoyChange = Datetime()

			Endif

		Catch To oErr

		Finally

		Endtry

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Do While (<<tnSegundos>>=0 Or <<lnContador>>>0) And !( <<&Aborta>> And <<tlEscape>>=.T.)
		ENDTEXT

		Do While (tnSegundos=0 Or lnContador>0) ;
				And !( &Aborta And tlEscape=.T. )

			llRetry = .F.

			If tcAction='U'

				Try

					If Empty( tcAlias )
						tcAlias = ""
					Endif


					* RA 2013-11-27(17:39:08)
					* Si existe, cerrarlo primero

					If Used( tcAlias ) And tlClose
						Use In Select( tcAlias )
					Endif


					If !Used( tcAlias )
						If Empty(tcAlias)

							If tlExclusivo=.T.
								lcCommand =  [Use '&tcFileName' Exclusive]
								Use '&tcFileName' Exclusive

							Else
								lcCommand =  [Use '&tcFileName']
								Use '&tcFileName' Shared

							Endif

						Else
							If tlExclusivo=.T.
								lcCommand =  [Use '&tcFileName' Exclusive Alias &tcAlias]
								Use '&tcFileName' Exclusive Alias &tcAlias

							Else
								lcCommand =  [Use '&tcFileName' Shared Again Alias &tcAlias]
								Use '&tcFileName' Shared Again Alias &tcAlias

							Endif
						Endif

					Else
						Select Alias( tcAlias )

					Endif

					If FileSize( Forceext( tcFileName, "dbf" ), "M" ) > 1300
						TEXT To lcMsg NoShow TextMerge Pretext 03
						El archivo <<tcAlias>> es demasiado grande

						Avise a Praxis
						ENDTEXT

						Do Form ErrorMessage With lcMsg

					Endif

				Catch To loErr

					Do Case
						Case loErr.ErrorNo = 1707 && The structural index file associated with a table file could not be found.
							llRetry = .T.

						Case Inlist( loErr.ErrorNo, 3, 108, 1705 )

							*!*	3   	File is in use
							*!*	108  	File is in use by another user
							*!*	1705  	File access is denied

							If lnTableValidate = -1
								lnTableValidate = Set("TableValidate")
								Set TableValidate To 4
								llRetry = .T.
							Endif

							If !llRetry

								Do Case
									Case loErr.ErrorNo = 3
										lcMessage = "El archivo está en uso"

									Case loErr.ErrorNo = 108
										lcMessage = "El archivo está siendo usado por otro usuario"

									Case loErr.ErrorNo = 1705
										lcMessage = "No se permite acceder al archivo"

									Otherwise
										lcMessage = ""

								Endcase

								TEXT To lcErrMsg NoShow TextMerge Pretext 03
								Error al abrir un Archivo con el siguiente comando:
								<<lcCommand>>

								El error informado es:
								[ ERROR Nº ] <<loErr.ErrorNo>>
								[ DESCRIPCION DEL ERROR ] "<<lcMessage>>"

								¿Reintentar?
								( Si responde NO es probable que el proceso que
								se está ejecutando se cancele )
								ENDTEXT

								llRetry = Confirm( lcErrMsg, "Error al abrir un archivo", .T. )

								If !llRetry
									Throw loErr
								Endif
							Endif

						Case .F. && loErr.ErrorNo = 2091 && Tabla Corrupta

							*!*								Local loDbfRepair As DbfRepair Of "Tools\Dbfrepair\Prg\DbfRepair.prg"

							*!*								TEXT To lcErrMsg NoShow TextMerge Pretext 03
							*!*								La Tabla "<<tcFileName>>"
							*!*								está dañada y necesita ser reparada.

							*!*								Se está intentando repararla

							*!*								NO APAGUE EL EQUIPO
							*!*								ENDTEXT

							*!*								Wait Window Nowait Noclear lcErrMsg

							*!*								Logerror( lcErrMsg )

							*!*								loDbfRepair = Newobject( "DbfRepair", "Tools\Dbfrepair\Prg\DbfRepair.prg" )
							*!*								loDbfRepair.Process( Forceext( tcFileName, "dbf" ), .T. )
							*!*								llRetry = loDbfRepair.lDone

							*!*								Wait Clear

						Otherwise
							Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
							loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
							loError.cRemark = lcCommand
							loError.Process ( m.loErr )
							Throw loError

					Endcase

				Finally

				Endtry

			Else
				Append Blank

			Endif

			If llRetry
				Loop
			Endif

			Do Case
				Case !Neterr()
					If tcAction='U' .And. Demo .And. Lastrec()>100
						S_Nohabi(2)
						lQuit = .T.
					Endif

					If !lQuit
						lReturn = .T.
					Endif

				Case tlMuestra=.T.
					Do S_Line22 With 'Proceso momentaneamente interrumpido, por favor aguarde'+;
						iif(tlEscape=.T.,' o [Esc]:Menu',''), .T.

					If _Screen.oApp.lCancelProcess
						Error "Proceso Suspendido Por El Usuario"
						*!*							tlEscape = True
						*!*							prxSetLastKey( Escape )
					Endif

			Endcase

			If lQuit Or lReturn

				If tcAction='U'
					If Used( tcAlias )

						loGlobalSettings = NewGlobalSettings()
						loColFiltros = loGlobalSettings.oColFilters
						loFiltro = loColFiltros.GetItem( tcAlias )
						If Vartype( loFiltro ) = "O"
							TEXT To lcCommand NoShow TextMerge Pretext 15
							Set Filter To
							<<loFiltro.cFiltro>>
							In <<loFiltro.cTabla>>
							ENDTEXT

							Try

								&lcCommand

							Catch To oErr

							Finally

							Endtry

						Endif
					Endif
				Endif
				Exit

			Else
				Inkey(.5)
				lnContador=lnContador-.5

			Endif
		Enddo

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Set Device To &lcDevice

		If lnTableValidate > -1
			Set TableValidate To ( lnTableValidate )
		Endif

		loGlobalSettings = Null
		loFiltro = Null
		loColFiltros = Null


	Endtry

	If lQuit
		Quit

	Else
		Return lReturn

	Endif

	*
	*
Procedure SacarFiltros(  ) As Void
	Local lcCommand As String,;
		lcAlias As String
	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
		loFiltro As Object,;
		loColFiltros As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg

	Try

		lcCommand = ""
		lcAlias = Alias()
		loGlobalSettings = NewGlobalSettings()
		loColFiltros = loGlobalSettings.oColFilters

		For Each loFiltro In loColFiltros
			If Used( loFiltro.cTabla )

				Select Alias( loFiltro.cTabla )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Set Filter To In <<loFiltro.cTabla>>
				ENDTEXT

				&lcCommand
				lcCommand = ""

				Locate

			Endif
		Endfor

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loFiltro = Null
		loColFiltros = Null
		loGlobalSettings = Null

		If !Empty( lcAlias )
			Select Alias( lcAlias )
		Endif

	Endtry

Endproc && SacarFiltros

*
*
Procedure PonerFiltros(  ) As Void
	Local lcCommand As String,;
		lcAlias As String
	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
		loFiltro As Object,;
		loColFiltros As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg

	Try

		lcCommand = ""

		lcAlias = Alias()

		loGlobalSettings = NewGlobalSettings()
		loColFiltros = loGlobalSettings.oColFilters

		For Each loFiltro In loColFiltros
			If Used( loFiltro.cTabla )

				Try

					Select Alias( loFiltro.cTabla )

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Set Filter To
					<<loFiltro.cFiltro>>
					In <<loFiltro.cTabla>>
					ENDTEXT

					&lcCommand
					lcCommand = ""

					Locate


				Catch To oErr

				Finally

				Endtry

			Endif
		Endfor


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loFiltro = Null
		loColFiltros = Null
		loGlobalSettings = Null

		If !Empty( lcAlias )
			Select Alias( lcAlias )
		Endif

	Endtry

Endproc && PonerFiltros

Note: Intenta lockear un archivo o un registro compartido
Note Dev: 1. Segundos a esperar o cero Para esperar ad eternum
*         2. .T. Permite usar Escape para abortar la espera, .F. No permite
*         3. .T. Muestra leyenda, .F.No muestra
*         4. 'R':Registro, 'F':Archivo

Function M_Lock
	Parameters Prm01,Prm02,Prm03,Prm04
	Private F001,F002

	Local lReturn As Boolean
	Local lcDevice As String

	Try

		lcDevice 	= Set("Device")

		Set Device To Screen

		lReturn = .F.
		Store Null To F001,F002
		F001=Prm01
		F002=Prm04+'lock()'

		If Prm02
			prxSetLastKey( 0 )
		Endif

		Do While (Prm01=0 .Or. F001>0) .And. !(&Aborta .And. Prm02=True)
			Do Case
				Case &F002
					Do Case
						Case Prm03=True
							*!*								@ 22,0
					Endcase
					lReturn = .T.

				Case Prm03=True
					Do S_Line22 With 'Proceso momentaneamente interrumpido, por favor aguarde'+;
						iif(Prm02=True,' o [Esc]:Menu',''), .T.

					If _Screen.oApp.lCancelProcess
						Error "Proceso Suspendido Por El Usuario"
						*!*							Prm02 = True
						*!*							prxSetLastKey( Escape )
					Endif
			Endcase

			If lReturn
				Exit
			Endif

			Inkey(.5)
			F001=F001-.5

		Enddo

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Set Device To &lcDevice

	Endtry

	Return( lReturn )

	Note: Apertura de archivos compartidos / exclusivos
	Note Par: 1/3/5/7/9/11/13/15/17/19.  Nombres de archivos (Hasta 10)
	*		  2/4/6/8/10/12/14/16/18/20. Cantidad de indices (Hasta 15)
	Note Dev: .T. Puede abrirlos, .F. no Puede

Function M_Openfile
	Parameters Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Prm7,Prm8,Prm9,Prm10,;
		Prm11,Prm12,Prm13,Prm14,Prm15,Prm16,Prm17,Prm18,Prm19,Prm20,;
		Prm21,Prm22,Prm23,Prm24,Prm25,Prm26,Prm27,Prm28,Prm29,Prm30,;
		Prm31,Prm32,Prm33,Prm34,Prm35,Prm36,Prm37,Prm38,Prm39,Prm40
	Private F000,F012
	Store Null To F000,F012
	F000=.F.
	F012=Pcount()/2

	* FECHAHOY=Date()  && para que tome la fecha del dia para computadora que quedan encendidas durante la noche
	* SE Reinicializa en M_File()

	Return(M_Open())

Function M_Openexcl
	Parameters Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Prm7,Prm8,Prm9,Prm10,;
		Prm11,Prm12,Prm13,Prm14,Prm15,Prm16,Prm17,Prm18,Prm19,Prm20,;
		Prm21,Prm22,Prm23,Prm24,Prm25,Prm26,Prm27,Prm28,Prm29,Prm30,;
		Prm31,Prm32,Prm33,Prm34,Prm35,Prm36,Prm37,Prm38,Prm39,Prm40
	Private F000,F012
	Store Null To F000,F012
	F000=.T.
	F012=Pcount()/2
	Return(M_Open())

Function M_Open
	Private F001,F002,F003,F004,F005,F006,F007,F008,F009,F010,F011
	Private FF05,FF06,FF07,FF08,FF09,FF10,FF11,FF12
	Local lReturn As Boolean
	Local oErr As Exception
	Local lcCommand As String
	Local lcFile As String
	Local lnIndex As Integer


	Try


		Store Null To F001,F002,F003,F004,F005,F006,F007,F008,F009,F010,F011
		Store Null To FF05,FF06,FF07,FF08,FF09,FF10,FF11,FF12

		lReturn = .T.
		lcCommand = ""

		F001=1
		Do While F001<=F012
			F002=Iif(F001<10,Str(F001,1),Str(F001,2))
			F003=Ltrim(Str(F001*2-1,2))
			F004=Ltrim(Str(F001*2,2))

			Sele &F002
			* Cerrar cualquier archivo que se encuentre abierto en el area seleccionada
			Use

			Do Case
				Case M_FILE(25,.F.,.T.,'U',Prm&F003,F000)

					F005 = '[' + Prm&F003 + '1.Idx]'
					F006 = '[' + Prm&F003 + '2.Idx]'
					F007 = '[' + Prm&F003 + '3.Idx]'
					F008 = '[' + Prm&F003 + '4.Idx]'
					F009 = '[' + Prm&F003 + '5.Idx]'
					F010 = '[' + Prm&F003 + '6.Idx]'
					F011 = '[' + Prm&F003 + '7.Idx]'
					FF05 = '[' + Prm&F003 + '8.Idx]'
					FF06 = '[' + Prm&F003 + '9.Idx]'
					FF07 = '[' + Prm&F003 + 'A.Idx]'
					FF08 = '[' + Prm&F003 + 'B.Idx]'
					FF09 = '[' + Prm&F003 + 'C.Idx]'
					FF10 = '[' + Prm&F003 + 'D.Idx]'
					FF11 = '[' + Prm&F003 + 'E.Idx]'
					FF12 = '[' + Prm&F003 + 'F.Idx]'


					lcFile 	= Prm&F003
					lnIndex = Prm&F004

					If lnIndex < 0
						TEXT To lcCommand NoShow TextMerge Pretext 15
						lnIndex = Adir ( laDummy, '<<lcFile>>*.IDX' )
						ENDTEXT

						&lcCommand
					Endif

					TEXT To lcCommand NoShow TextMerge Pretext 03
					Archivo: <<lcFile>>
					Cantidad de Indices: <<lnIndex>>
					ENDTEXT

					Do Case
						Case lnIndex=1
							*lcCommand = "Set Index To &F005"
							Set Index To &F005

						Case lnIndex=2
							*lcCommand = "Set Index To &F005,&F006"
							Set Index To &F005,&F006

						Case lnIndex=3
							*lcCommand = "Set Index To &F005,&F006,&F007"
							Set Index To &F005,&F006,&F007

						Case lnIndex=4
							Set Index To &F005,&F006,&F007,&F008

						Case lnIndex=5
							Set Index To &F005,&F006,&F007,&F008,&F009

						Case lnIndex=6
							Set Index To &F005,&F006,&F007,&F008,&F009,&F010

						Case lnIndex=7
							Set Index To &F005,&F006,&F007,&F008,&F009,&F010,&F011

						Case lnIndex=8
							Set Index To &F005,&F006,&F007,&F008,&F009,&F010,&F011,;
								&FF05

						Case lnIndex=9
							Set Index To &F005,&F006,&F007,&F008,&F009,&F010,&F011,;
								&FF05,&FF06

						Case lnIndex=10
							Set Index To &F005,&F006,&F007,&F008,&F009,&F010,&F011,;
								&FF05,&FF06,&FF07

						Case lnIndex=11
							Set Index To &F005,&F006,&F007,&F008,&F009,&F010,&F011,;
								&FF05,&FF06,&FF07,&FF08

						Case lnIndex=12
							Set Index To &F005,&F006,&F007,&F008,&F009,&F010,&F011,;
								&FF05,&FF06,&FF07,&FF08,&FF09

						Case lnIndex=13
							Set Index To &F005,&F006,&F007,&F008,&F009,&F010,&F011,;
								&FF05,&FF06,&FF07,&FF08,&FF09,&FF10

						Case lnIndex=14
							Set Index To &F005,&F006,&F007,&F008,&F009,&F010,&F011,;
								&FF05,&FF06,&FF07,&FF08,&FF09,&FF10,&FF11

						Case lnIndex=15
							Set Index To &F005,&F006,&F007,&F008,&F009,&F010,&F011,;
								&FF05,&FF06,&FF07,&FF08,&FF09,&FF10,&FF11,&FF12

					Endcase

				Otherwise
					Do S_Nohabi With 2
					lReturn = .F.

			Endcase

			F001=F001+1

		Enddo


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )

		Do Case
			Case oErr.ErrorNo = 1
				*!*	File does not exist.

				loError.Ctracelogin = "No Existe Archivo de Indices"
				loError.Cremark = lcCommand

			Otherwise

		Endcase
		loError.Process( loErr )
		Throw loError

	Finally

	Endtry

	Return lReturn


	Note: abrir un archivo con sus indices en un area específica

	* nSELE  Area donde se abre el archivo
	* cFILE  Ruta+Nombre del archivo
	* nINDE  Cantidad de Indices del Archivo (Default = 0)
	* lEXCL  Exclusivo (Default = .F.)
	* cAlias Alias del Archivo (Default = Nombre del Archivo)
	* lClose Fuerza el cierre si es que el archivo ya está abierto
	* nBuffering	 Sets row and table buffering

Function M_Use
	Para nSELE,cFILE,nINDE,lEXCL,cAlias,lClose,nBuffering
	Private F001,F002,F003,F004,F005,F006,F007,F008,F009,F010,F011
	Private FF05,FF06,FF07,FF08,FF09,FF10,FF11,FF12
	Private lVALID

	Store Null To F001,F002,F003,F004,F005,F006,F007,F008,F009,F010,F011
	Store Null To FF05,FF06,FF07,FF08,FF09,FF10,FF11,FF12
	Store Null To lVALID

	Local lcCommand As String
	Local llAlreadyOpen As Boolean

	*!*		nINDE=prxDefault("nINDE",0)
	*!*		lEXCL=prxDefault("lEXCL",.F.)
	*!*		cAlias=prxDefault("cAlias",Juststem(cFILE))

	Try

		nINDE=IfEmpty( nINDE, 0 )
		lEXCL=IfEmpty( lEXCL, .F. )
		cAlias=IfEmpty( cAlias, Juststem( cFILE ))
		nBuffering = IfEmpty( nBuffering, 1 )

		If Vartype( nBuffering ) # "N"
			nBuffering = 1
		Endif

		lcCommand = ""
		llAlreadyOpen = .F.

		If nINDE < 0
			TEXT To lcCommand NoShow TextMerge Pretext 15
			nINDE = Adir ( laDummy, '<<cFile>>*.IDX' )
			ENDTEXT

			&lcCommand
		Endif


		Do Case
			Case Type("nSELE")="C"
				nSELE=Uppe(nSELE)
				nSELE=Asc(nSELE)-Asc("A")+1
		Endcase
		lVALID=.F.




		llAlreadyOpen = Used( cAlias )

		If llAlreadyOpen
			lVALID=.T.
			Select Alias( cAlias )

		Else
			Sele (nSELE)

			* Cerrar cualquier archivo que se encuentre abierto en el area seleccionada
			Use

			Do Case
				Case M_FILE(25,.F.,.T.,'U',cFILE,lEXCL,cAlias,lClose )
					lVALID=.T.

					F005=cFILE+'1'
					F006=cFILE+'2'
					F007=cFILE+'3'
					F008=cFILE+'4'
					F009=cFILE+'5'
					F010=cFILE+'6'
					F011=cFILE+'7'
					FF05=cFILE+'8'
					FF06=cFILE+'9'
					FF07=cFILE+'A'
					FF08=cFILE+'B'
					FF09=cFILE+'C'
					FF10=cFILE+'D'
					FF11=cFILE+'E'
					FF12=cFILE+'F'

					TEXT To lcCommand NoShow TextMerge Pretext 03
					Archivo: <<cFILE>>
					Cantidad de Indices: <<nINDE>>
					ENDTEXT

					Do Case
						Case nINDE=1
							*lcCommand =  [Set Index To '&F005']
							Set Index To '&F005'

						Case nINDE=2
							*lcCommand = [Set Index To '&F005','&F006']
							Set Index To '&F005','&F006'

						Case nINDE=3
							*lcCommand = [Set Index To '&F005','&F006','&F007']
							Set Index To '&F005','&F006','&F007'

						Case nINDE=4
							*lcCommand = [Set Index To '&F005','&F006','&F007','&F008']
							Set Index To '&F005','&F006','&F007','&F008'

						Case nINDE=5
							*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009']
							Set Index To '&F005','&F006','&F007','&F008','&F009'

						Case nINDE=6
							*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010']
							Set Index To '&F005','&F006','&F007','&F008','&F009','&F010'

						Case nINDE=7
							*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011']
							Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011'

						Case nINDE=8
							*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05']
							Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
								'&FF05'

						Case nINDE=9
							*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06']
							Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
								'&FF05','&FF06'

						Case nINDE=10
							*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07']
							Set Index To '&F005','&F006','&F007','&F008,'&F009','&F010','&F011',;
						'&FF05','&FF06','&FF07'

						Case nINDE=11
							*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07','&FF08']
							Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
								'&FF05','&FF06','&FF07','&FF08'

						Case nINDE=12
							*lcCommand = [Set Index To '&F005',&F006,'&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07','&FF08','&FF09']
							Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
								'&FF05','&FF06','&FF07','&FF08','&FF09'

						Case nINDE=13
							*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07','&FF08','&FF09','&FF10']
							Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
								'&FF05','&FF06','&FF07','&FF08','&FF09','&FF10'

						Case nINDE=14
							*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07','&FF08','&FF09','&FF10','&FF11']
							Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
								'&FF05','&FF06','&FF07','&FF08','&FF09','&FF10','&FF11'

						Case nINDE=15
							*lcCommand = [Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011','&FF05','&FF06','&FF07','&FF08','&FF09','&FF10','&FF11','&FF12']
							Set Index To '&F005','&F006','&F007','&F008','&F009','&F010','&F011',;
								'&FF05','&FF06','&FF07','&FF08','&FF09','&FF10','&FF11','&FF12'
					Endcase

				Otherwise
					Do S_Nohabi With 2
					lVALID=.F.
			Endcase

			If Empty( nINDE )
				If nBuffering > 1
					MakeTransactable( cAlias )
					CursorSetProp("Buffering", nBuffering, cAlias )
				Endif

				* RA 2012-03-18(14:18:35)
				* Para poder usar transacciones, no deben existir indices Idx abiertos
				* y la tabla debe ser transaccionable.
				* Si hay indices Idx abiertos y se la hace transaccionable con MakeTransactable(),
				* el comando Begin Transaction da un error 1548 (Table "alias" has one or more
				* non-structural indexes open. Please close them and retry the Begin Transaction (Error 1548))
				* Si la tabla tiene indices Idx abiertos, pero NO se la hizo transaccionable,
				* el comando Begin Transaction no da ningun error, pero la transaccion no puede
				* revertirse.
				* Resumiendo, si me aseguro al abrir la tabla que no haya ningún indice Idx abierto
				* para hacerla transaccionable, puedo codificar con la estructura Begin Transaction /
				* End Transaction / RollBack sin que esto genere error, aunque no cumpla su funcion
				* Para evitar transacciones incompletas y/o errores al ejecutar los comandos Begin Transaction,
				* utilizar las funciones TransactionBegin(), TransactionEnd() y TransactionRollBack(), del Rutina.prg,

			Endif
		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Retu lVALID



	*
	* Abre tablas que pueden ser usadas en una transacción
Procedure TxnUse( cFILE As String,;
		cAlias As String,;
		lEXCL As Boolean,;
		nSELE As Integer,;
		lClose As Boolean ) As Boolean;
		HELPSTRING "Abre tablas que pueden ser usadas en una transacción"

	Local lcCommand As String

	Local lnInde As Integer
	Local llOk As Boolean

	Try

		lcCommand = ""
		llOk = .F.

		If Empty( cAlias )
			cAlias = Juststem( cFILE )
		Endif

		If Empty( nSELE )
			nSELE = 0
		Endif

		lnInde = 0

		If !Used( cAlias )
			If M_Use( nSELE, cFILE, lnInde, lEXCL, cAlias, lClose )

				Try

					CursorSetProp( "Buffering", 5, cAlias )
					llOk = .T.

				Catch To oErr
					Do Case
						Case oErr.ErrorNo = 1589	&& El almacenamiento en búfer de tablas o de filas requiere que SET MULTILOCKS tenga el valor ON.
							Set Multilocks On
							CursorSetProp( "Buffering", 5, cAlias )
							llOk = .T.

						Otherwise
							llOk = .F.
							CursorSetProp( "Buffering", 0, cAlias )

					Endcase
				Finally

				Endtry

			Endif

		Else
			Select Alias( cAlias )
			llOk = .T.

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return llOk

Endproc && TxnUse



*
* Lockeo de Base de Datos
* Par: 1. Append Blank, 2. Replace/Delete/Recall, 3. Conjunto de registros
* Si nAction es 1 o 2, devuelve el Id del registro (si lDontLog = .F. )
* Si nAction es 3, devuelve un booleano
* cAlias contiene el nombre de la tabla (Si no se pasa, es la actual)
* lDontLog: Indica que NO grabe los campos de login
* 						( El Default es .F., es decir, SI se graba)
* Si se le suma 50 a nAction, implica que lDontLog = .T.
*	( m_IniAct( 52 ) es equivalente a m_IniAct( 2, "", .T. ) )

Procedure m_IniAct( nAction As Integer,;
		cAlias As String,;
		lDontLog As Boolean,;
		lForceLog As Boolean ) As Variant;
		HELPSTRING "Lockeo de Base de Datos"

	Local lcCommand As String,;
		lcMsg As String,;
		lcOldAlias As String,;
		lcFieldNames As String,;
		lcOrder As String

	Local llDone As Boolean
	Local oErr As Exception
	Local lnIntentos As Integer,;
		lnId As Integer,;
		i As Integer,;
		j As Integer

	Local ltDateTime As Datetime

	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"


	Local loReg As Object


	Try

		lcCommand 	= ""
		llDone 		= .F.
		lnId 		= 0

		Try

			loGlobalSettings = NewGlobalSettings()
			loGlobalSettings.oAppTimer.nReset = Seconds()

		Catch To oErr

		Finally

		Endtry

		If nAction > 50
			nAction = nAction - 50
			lDontLog = .T.
		Endif


		lcOldAlias = Alias()

		If Empty( cAlias )
			cAlias = Alias()
		Endif

		If !lDontLog
			If Empty( Field( "Id", cAlias ))
				lDontLog = .T.
			Endif
		Endif

		lnIntentos = 0

		If Inlist( nAction, 1, 2 ) And !lDontLog

			* RA 2015-01-25(11:26:12)
			* Información de Login

			Select Alias( cAlias )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Scatter Fields Like Id,
				TS, UTS, TranId, Equipo, WinUser, Usuario, Userid, Nivel
				<<Iif( nAction = 1, "Blank Name", "Name" )>> loReg
			ENDTEXT

			&lcCommand

			ltDateTime = Datetime()


			If Pemstatus( loReg, "Id", 5 )

				If nAction = 1
					loReg.Id = GetMaxId() + 1
				Endif

				lnId = loReg.Id

			Endif

			If ( nAction = 1 ) Or lForceLog

				If Pemstatus( loReg, "Equipo", 5 )
					loReg.Equipo = loGlobalSettings.oTransactionLog.Equipo
				Endif

				If Pemstatus( loReg, "WinUser", 5 )
					loReg.WinUser = loGlobalSettings.oTransactionLog.WinUser
				Endif

				If Pemstatus( loReg, "Usuario", 5 )
					loReg.Usuario = loGlobalSettings.oTransactionLog.Usuario
				Endif

				If Pemstatus( loReg, "Userid", 5 )
					loReg.Userid = loGlobalSettings.oTransactionLog.Userid
				Endif

				If Pemstatus( loReg, "Nivel", 5 )
					loReg.Nivel = loGlobalSettings.oTransactionLog.Nivel
				Endif

			Endif

			If Pemstatus( loReg, "TS", 5 ) And ( nAction = 1 )
				loReg.TS = ltDateTime
			Endif

			If Pemstatus( loReg, "UTS", 5 )
				loReg.UTS = ltDateTime
			Endif

		Endif

		Do While !llDone

			lnIntentos = lnIntentos + 1

			Do Case
				Case nAction = 1

					* Agrega un registro

					Try
						Select Alias( cAlias )
						lcOrder = Order()
						Set Order To
						Go Bottom

						Append Blank

						j = 0
						Do While !Rlock( cAlias ) And j < 10
							j = j + 1
							Inkey( 0.5 )
						Enddo

						If !lDontLog

							i = 0
							Do While !llDone

								i = i + 1

								Try

									Gather Name loReg
									Unlock

									j = 0
									Do While !Rlock( cAlias ) And j < 10
										j = j + 1
										Inkey( 0.5 )
									Enddo

									llDone = .T.

								Catch To oErr
									If oErr.ErrorNo = 1884 ;
											And "ID" == Alltrim( Upper( oErr.Details ))

										* RA 10/04/2016(13:04:16)
										* Intentar

										*!*											loReg.Id = loReg.Id + 1
										*!*											lnId 	 = loReg.Id

										*!*											If i > 100
										*!*												Throw oErr
										*!*											EndIf

										* RA 24/04/2019(12:50:36)
										* Reintentar

										Set Order To Tag Id
										Go Bottom
										loReg.Id = Id + 1
										lnId 	 = loReg.Id

										Set Order To
										Go Bottom

										If i > 100

											TEXT To lcMsg NoShow TextMerge Pretext 03
											Intento de Ingresar Id Repetida
					                    	--------------------------------------------------
					                    	Tabla: <<Alias()>>
					                    	Id: <<loReg.Id>>
					                    	--------------------------------------------------

											ENDTEXT

											Logerror( lcMsg )

											Throw oErr
										Endif



									Else
										Throw oErr

									Endif

								Finally

								Endtry

							Enddo

						Else
							llDone = .T.

						Endif

					Catch To loErr
						Do While Vartype ( loErr.UserValue ) == 'O'
							loErr = loErr.UserValue
						Enddo

						Do Case
							Case loErr.ErrorNo = 1884 && Uniqueness of index is violated.
								EliminarRegistrosVacios( cAlias )
								Append Blank

								j = 0
								Do While !Rlock( cAlias ) And j < 10
									j = j + 1
									Inkey( 0.5 )
								Enddo

								If !lDontLog
									TEXT To lcCommand NoShow TextMerge Pretext 03
									Gather Name loReg

									Alias = '<<cAlias>>'
									Id = <<loReg.Id>>
									TranId = <<loReg.TranId>>
									ENDTEXT

									Gather Name loReg
									Unlock
									j = 0
									Do While !Rlock( cAlias ) And j < 10
										j = j + 1
										Inkey( 0.5 )
									Enddo

								Endif

								llDone = .T.

							Otherwise
								Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
								loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
								loError.cRemark = lcCommand
								loError.Process ( m.loErr )
								Throw loError

						Endcase

					Finally
						If !Empty( lcOrder )
							Set Order To Tag ( lcOrder )
						Endif

					Endtry

				Case nAction = 2
					* Lockea un registro

					If !Eof( cAlias ) And !Bof( cAlias )
						llDone = Rlock( cAlias )

						j = 0
						Do While !llDone And j < 10
							j = j + 1
							Inkey( 0.5 )
							llDone = Rlock( cAlias )
						Enddo

						If llDone And !lDontLog
							Select Alias( cAlias )
							Gather Name loReg
						Endif

					Else
						llDone = .T.

					Endif


				Case nAction = 3
					* Lockea la Tabla

					llDone = Flock( cAlias )

				Otherwise

			Endcase

			If !llDone

				Do Case
					Case nAction = 2
						TEXT To lcMsg NoShow TextMerge Pretext 03
						Error al intentar bloquear
						un registro en la tabla <<cAlias>>

						Reintento Nº <<lnIntentos>>

						ENDTEXT

					Case nAction = 3
						TEXT To lcMsg NoShow TextMerge Pretext 03
						Error al intentar bloquear
						la tabla <<cAlias>>

						Reintento Nº <<lnIntentos>>

						ENDTEXT

					Otherwise

				Endcase

				If lnIntentos < 24	&& Cada reintento son 5 segundos
					Wait Window Nowait Noclear lcMsg

				Else

					TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
					*
					A T E N C I O N
					*

					Si Cancela, puede perder la información

					¿ Reintenta ?

					ENDTEXT

					llDone = !Confirm( lcMsg, "Error al actualizar un archivo", .T., MB_ICONEXCLAMATION )

					Wait Clear

					If !llDone
						lnIntentos = 0
						*!*							Wait Window NoWait NoClear "Último reintento ..."
						*!*							llDone = xxxM_Iniact( nAction )

					Else

						Astackinfo( laStack )
						i = Max( Alen( laStack, 1 ) - 1, 1 )

						TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
                    	--------------------------------------------------
                    	Llamado por:
                    	Programa: <<laStack[ i, 4 ]>>
                    	Linea: <<laStack[ i, 5 ]>>

                    	Tabla: <<cAlias>>
                    	Registro: <<Recno( cAlias )>>
                    	--------------------------------------------------

						ENDTEXT

						Logerror( lcMsg )

					Endif

				Endif

			Endif

		Enddo

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loGlobalSettings = Null

		If !Empty( lcOldAlias )
			Select Alias( lcOldAlias )
		Endif


	Endtry

	If nAction = 3
		Return llDone

	Else
		Return lnId

	Endif

Endproc && m_IniAct


*
* Repite el comando UNLOCK en determinados escenarios
Procedure M_Unlock( oReg As Object ) As Void
	Local lcCommand As String
	Local lnTimes As Integer
	Local llRetry As Boolean,;
		llDone As Boolean

	Try

		lcCommand = ""
		lnTimes = 0
		llDone = .F.

		Do While !llDone

			Try

				If ( Vartype( oReg ) = "O" )
					Gather Name oReg Memo
				Endif

				Unlock

				llDone = .T.

			Catch To oErr
				*Local oErr As Exception

				Do Case
					Case oErr.ErrorNo = 43 && There is not enough memory to complete this operation.
						lnTimes = lnTimes + 1
						Inkey( 1 )

						Wait Window Nowait Noclear oErr.Message + " ( " + Transform( lnTimes ) + " )"

						Aerror( laError )

						lcMaq = Sys ( 0 )
						lcUsu = lcMaq
						lcMaq = Proper ( Substr ( m.lcMaq, 1, At ( '#', m.lcMaq ) - 1 ) )
						lcUsu = Proper ( Substr ( m.lcUsu, At ( '#', m.lcUsu ) + 1 ) )

						loUser = NewUser()

						lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
						lcMsg = lcMsg + "[  ERROR    ] " + Transform(oErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
						lcMsg = lcMsg + "[  MENSAJE  ] " + oErr.Message + Chr( 13 ) + Chr( 10 )
						lcMsg = lcMsg + "[  DETALLE  ] " + oErr.Details + Chr( 13 ) + Chr( 10 )
						lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
						lcMsg = lcMsg + "[  REGISTRO ] " + Transform( Recno() ) + Chr( 13 ) + Chr( 10 )
						lcMsg = lcMsg + "[  Equipo   ] " + m.lcMaq + Chr( 13 ) + Chr( 10 )
						lcMsg = lcMsg + "[  Usuario Windows: ] " + m.lcUsu + Chr( 13 ) + Chr( 10 )
						lcMsg = lcMsg + "[  Usuario Fenix:   ] " + loUser.Nombre + Chr( 13 ) + Chr( 10 )
						lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )

						Strtofile( lcMsg, "Error_De_Memoria.txt", 1 )

						*!*							lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
						*!*							lcMsg = lcMsg + "[  METODO   ] " + loErr.Procedure + Chr( 13 ) + Chr( 10 )
						*!*							lcMsg = lcMsg + "[  LINEA Nº ] " + Transform(loErr.Lineno) + Chr( 13 ) + Chr( 10 )
						*!*							lcMsg = lcMsg + "[  COMANDO  ] " + loErr.LineContents + Chr( 13 ) + Chr( 10 )
						*!*							lcMsg = lcMsg + "[  ERROR    ] " + Transform(loErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
						*!*							lcMsg = lcMsg + "[  MENSAJE  ] " + loErr.Message + Chr( 13 ) + Chr( 10 )
						*!*							lcMsg = lcMsg + "[  DETALLE  ] " + loErr.Details + Chr( 13 ) + Chr( 10 )
						*!*							lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
						*!*							lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )


						If lnTimes > 10
							lnTimes = 0

							TEXT To lcErrMsg NoShow TextMerge Pretext 03
							Error al intentar grabar un Registro:

							"NO HAY SUFICIENTE MEMORIA PARA COMPLETAR ESTA OPERACION"

							Tabla: <<Alias()>>
							Registro: <<Recno()>>

							¿Reintentar?
							( Si responde NO es probable que el proceso que
							se está ejecutando se cancele )
							ENDTEXT

							llRetry = Confirm( lcErrMsg, "Error al Grabar un Registro", .T. )

							If !llRetry
								Wait Clear

								TEXT To lcCommand NoShow TextMerge Pretext 03
								"NO HAY SUFICIENTE MEMORIA PARA COMPLETAR ESTA OPERACION"

								Tabla: <<Alias()>>
								Registro: <<Recno()>>
								ENDTEXT


								Local loErr1 As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
								loErr1 = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
								loErr1.cRemark = lcCommand
								loErr1.Process ( m.oErr )
								Throw loErr1

							Endif

						Endif

					Otherwise
						Throw oErr

				Endcase

			Finally

			Endtry

		Enddo

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Wait Clear

	Endtry

Endproc && M_Unlock


*
*
Procedure m_Scatter( lBlank As Boolean ) As Object
	Local lcCommand As String
	Local loReg As Object

	Try

		lcCommand = ""
		*!*	SCATTER [FIELDS FieldNameList | FIELDS LIKE Skeleton
		*!*	   | FIELDS EXCEPT Skeleton] [MEMO] [BLANK]
		*!*	   TO ArrayName | TO ArrayName | MEMVAR
		*!*	   | NAME ObjectName [ADDITIVE]

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Scatter Memo <<Iif( lBlank, "Blank", "" )>>
			Name loReg
			Fields Except Id, TS, UTS, TranId,
			Equipo, WinUser, Usuario, Userid
		ENDTEXT

		&lcCommand


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return loReg

Endproc && m_Scatter

*
*
Procedure m_Gather( oReg As Object ) As Void
	Local lcCommand As String


	Try

		lcCommand = ""
		*!*	GATHER FROM ArrayName | MEMVAR | NAME ObjectName
		*!*	   [FIELDS FieldList | FIELDS LIKE Skeleton | FIELDS EXCEPT Skeleton]
		*!*	   [MEMO]

		Gather Name oReg Memo ;
			Fields Except Id, TS, UTS, TranId, ;
			Equipo, WinUser, Usuario, Userid

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		oReg = Null

	Endtry

Endproc && m_Gather



*
* Lockeo de Base de Datos
* Par: 1. Append Blank, 2. Replace/Delete/Recall, 3. Conjunto de registros
* lDontLog: Indica que NO se grabe el campo UTS
* 						( El Default es .F., es decir, el campo UTS SI se graba)
* Si nAction es 1 o 2, devuelve el Id del registro
* Si nAction es 3, devuelve un booleano
Procedure xxx_m_IniAct( nAction As Integer,;
		cAlias As String,;
		lDontLog As Boolean  ) As Variant;
		HELPSTRING "Lockeo de Base de Datos"

	Local lcCommand As String,;
		lcMsg As String,;
		lcOldAlias As String

	Local llDone As Boolean
	Local oErr As Exception
	Local lnIntentos As Integer,;
		lnId As Integer

	Try

		lcCommand 	= ""
		llDone 		= .F.
		lnId 		= 0

		lcOldAlias = Alias()

		If Empty( cAlias )
			cAlias = Alias()
		Endif

		lnIntentos = 0


		Do While !llDone

			lnIntentos = lnIntentos + 1

			Do Case
				Case nAction = 1
					* Agrega un registro
					Try
						Select Alias( cAlias )
						Append Blank
						llDone = .T.
						lnId = SaveNewId()

					Catch To loErr
						Do Case
							Case loErr.ErrorNo = 1884 && Uniqueness of index ARTPK is violated.
								EliminarRegistrosVacios( cAlias )
								Append Blank
								llDone = .T.
								lnId = SaveNewId()

							Otherwise
								Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
								loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
								loError.cRemark = lcCommand
								loError.Process ( m.loErr )
								Throw loError

						Endcase

					Finally

					Endtry

					Try

						ltDateTime = Datetime()
						If !Empty( Field( "TS", cAlias ))
							Replace TS With ltDateTime In ( cAlias )
						Endif

						If !Empty( Field( "UTS", cAlias ))
							Replace UTS With ltDateTime In ( cAlias )
						Endif

					Catch To oErr

					Finally

					Endtry


				Case nAction = 2
					* Lockea un registro

					If !Eof( cAlias ) And !Bof( cAlias )
						llDone = Rlock( cAlias )

						If !Empty( Field( "Id" ) )
							lnId = Evaluate( cAlias + ".Id" )
						Endif

						If llDone And !lDontLog
							Try

								Do Case
									Case !Empty( Field( "UTS", cAlias ))
										* Update Time Stamp
										Replace UTS With Datetime() In ( cAlias )

									Case !Empty( Field( "TS", cAlias ))
										Replace TS With Datetime() In ( cAlias )

								Endcase

							Catch To oErr

							Finally

							Endtry

						Endif


					Else
						llDone = .T.

					Endif


				Case nAction = 3
					* Lockea la Tabla

					llDone = Flock( cAlias )

				Otherwise

			Endcase

			If !llDone

				Do Case
					Case nAction = 2
						TEXT To lcMsg NoShow TextMerge Pretext 03
						Error al intentar bloquear
						un registro en la tabla <<cAlias>>

						Reintento Nº <<lnIntentos>>

						ENDTEXT

					Case nAction = 3
						TEXT To lcMsg NoShow TextMerge Pretext 03
						Error al intentar bloquear
						la tabla <<cAlias>>

						Reintento Nº <<lnIntentos>>

						ENDTEXT

					Otherwise

				Endcase

				If lnIntentos < 24	&& Cada reintento son 5 segundos
					Wait Window Nowait Noclear lcMsg

				Else

					TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
					*
					A T E N C I O N
					*

					Si Cancela, puede perder la información

					¿ Reintenta ?

					ENDTEXT

					llDone = !Confirm( lcMsg, "Error al actualizar un archivo", .T., MB_ICONEXCLAMATION )

					If !llDone
						lnIntentos = 0
						*!*							Wait Window NoWait NoClear "Último reintento ..."
						*!*							llDone = xxxM_Iniact( nAction )

					Else

						Astackinfo( laStack )
						i = Max( Alen( laStack, 1 ) - 1, 1 )

						TEXT To lcMsg NoShow TextMerge Pretext 03 ADDITIVE
                    	--------------------------------------------------
                    	Llamado por:
                    	Programa: <<laStack[ i, 4 ]>>
                    	Linea: <<laStack[ i, 5 ]>>

                    	Tabla: <<cAlias>>
                    	Registro: <<Recno( cAlias )>>
                    	--------------------------------------------------

						ENDTEXT

						Logerror( lcMsg )

					Endif

				Endif

			Endif

		Enddo

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Wait Clear
		If !Empty( lcOldAlias )
			Select Alias( lcOldAlias )
		Endif


	Endtry

	If nAction = 3
		Return llDone

	Else
		Return lnId

	Endif





Endproc && xxx_m_IniAct

*
* Elimina registros vacios que generan un Error 1884 en el Append Blank
Procedure EliminarRegistrosVacios( cAlias As String ) As Void;
		HELPSTRING "Elimina registros vacios que generan un Error 1884 en el Append Blank"
	Local lcCommand As String,;
		lcMsg As String

	Try

		lcCommand = ""
		TEXT To lcMsg NoShow TextMerge Pretext 03
		Se ha encontrado una clave repetida
		en la tabla '<<cAlias>>'

		El sistema está intentando corregirlo .....

		( El proceso puede tardar unos minutos
		no apague el equipo )

		ENDTEXT

		Logerror( lcMsg )

		Wait Window Nowait Noclear lcMsg


		Do Case
			Case Inlist( Upper( cAlias ), "AR7VEN", "XX7VEN", ;
					"AR7COM", "XX7COM", ;
					"AR7PRO", ;
					"AR7DES", ;
					"AR7REM", "XX7REM",;
					"AR7PED", "XX7PED",;
					"AR7PRESU"  )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Delete From <<cAlias>> Where Empty( Nume7 )
				ENDTEXT

				&lcCommand


			Case Upper( cAlias ) = "AR1ART"
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Delete From <<cAlias>> Where Empty( GRUP1 + NUME1 )
				ENDTEXT

				&lcCommand


			Case Upper( cAlias ) = "AR3LIN"
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Delete From <<cAlias>> Where Empty( RUBR3 ) And Empty( Codi3 )
				ENDTEXT

				&lcCommand


			Case Upper( cAlias ) = "AR4VAR"
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Delete From <<cAlias>> Where Empty( Tipo4 ) Or Empty( Codi4 )
				ENDTEXT

				&lcCommand


			Case Upper( cAlias ) = "AR4IIBB"
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Delete From <<cAlias>> Where Empty( Substr( CUIT4, 1, 2 ) )
				ENDTEXT

				&lcCommand


			Case Upper( cAlias ) = "AR2GRU"
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Delete From <<cAlias>> Where Empty( Codi2 )
				ENDTEXT

				&lcCommand


			Case Upper( cAlias ) = "AR10CAJ"
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Delete From <<cAlias>> Where Empty( Codi10 )
				ENDTEXT

				&lcCommand


			Case Upper( cAlias ) = "AR12CRG"
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Delete From <<cAlias>> Where Empty( Cert12 )
				ENDTEXT

				&lcCommand

			Case Inlist( Upper( cAlias ), "DATOSIIBB", "AR4IIBB" )
				TEXT To lcCommand NoShow TextMerge Pretext 15
				Delete From <<cAlias>> Where Empty( Cuit4 )
				ENDTEXT

				&lcCommand

			Otherwise

		Endcase

		Flush Force


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Wait Clear

	Endtry

Endproc && EliminarRegistrosVacios



Note: Actualizacion de una Base de datos (Fin)

Procedure M_Finact()
	Local lcCommand As String,;
		lcTable As String

	Local lnLen As Integer,;
		i As Integer

	Local Array laTables[ 1 ]
	Local llDone As Boolean

	Try

		lcCommand = ""

		Flush Force
		Unlock All

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry


Endproc

Note: Hace un Replace de todo el registro a otro archivo con igual estructura
Note Par: cAorig: Alias del archivo origen
*		  cAdest: Alias del archivo destino

Procedure xxxM_Reprec
	Parameters cAorig, cAdest

	Local cCampo, i, Wdef, nSELE

	nSELE = Select()

	If Empty( cAdest )
		cAdest = Alias()
	Endif

	For i = 1 To Afields( laFields, cAdest )

		cCampo = laFields[ i, 1 ]
		Sele Alias( cAorig )

		Sele Alias( cAdest )

		Try
			Replace &cCampo With Evaluate( cAorig + "." + cCampo )

		Catch To oErr

		Finally

		Endtry

	Next

	Sele (nSELE)
	Return



	*
	* Reemplaza un registro con otro
Procedure M_RepRec( cArchivoOrigen As String,;
		cArchivoDestino As String,;
		lClonar As Boolean ) As Void;
		HELPSTRING "Reemplaza un registro con otro"
	Local lcCommand As String,;
		lcAlias As String

	Local loRegistro As Object

	Try

		lcCommand = ""
		lcAlias = Alias()

		If Empty( cArchivoDestino )
			cArchivoDestino = lcAlias
		Endif

		Select Alias( cArchivoOrigen )

		If lClonar
			Scatter Memo Name loRegistro

		Else
			Scatter Memo Name loRegistro Fields Except ;
				Id, TS, UTS, TranId, ;
				Equipo, WinUser, Usuario, Userid

		Endif

		Select Alias( cArchivoDestino )
		Gather Name loRegistro Memo

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loRegistro = Null
		If Used( lcAlias )
			Select Alias( lcAlias )
		Endif

	Endtry

Endproc && M_RepRec


Note: Devuelve un Nombre de archivo valido
* cPATH: Ruta del archivo
* cPREF: Prefijo del Archivo
* nLEN : Longitud del Nombre
* cEXT : Extension

Function M_FNAME
	Para cPATH,cPREF,nLen,cEXT
	Private cFILE,nBAS1,nBAS2,ni,nPL
	Store Null To cFILE,nBAS1,nBAS2,ni,nPL

	*!*		cPATH=prxDefault("cPATH","")
	*!*		cPREF=prxDefault("cPREF","_")
	*!*		nLEN =prxDefault("nLEN" ,8)
	*!*		cEXT =prxDefault("cEXT" ,"DBF")
	cPATH=DefaultValue("cPATH","")
	cPREF=DefaultValue("cPREF","_")
	nLen =DefaultValue("nLEN" ,8)
	cEXT =DefaultValue("cEXT" ,"DBF")


	Do Case
		Case !Empty(cPATH)
			Do Case
				Case Right(cPATH,1)<>"\" .And. Right(cPATH,1)<>":"
					cPATH=cPATH+"\"
			Endcase
	Endcase

	cPREF=Alltrim(cPREF)
	nPL=Len(cPREF)

	Do While .T.
		cFILE=cPATH+cPREF
		For ni=1 To nLen-nPL
			nBAS1=Seconds()
			nBAS2=(nBAS1-Int(nBAS1))*100
			nBAS1=Mod(nBAS2+ni,30)
			nBAS2=Chr(Mod(Int(Exp(nBAS1)),20)+65)
			cFILE=cFILE+nBAS2
		Next
		cFILE=cFILE+".&cEXT"
		Do Case
			Case !File(cFILE)
				Exit
		Endcase
	Enddo

	Retu cFILE


	*!*		***********************************************************************
	*!*		Note: Devuelve SOLO el Nombre de un archivo valido (Sin la extension)
	*!*		* cFileName: Nombre completo del archivo

	*!*	Function Juststem
	*!*		Para cFileName
	*!*		Retu JustFile(cFileName,3)

	*!*		Note: Devuelve SOLO la Ruta de un archivo valido
	*!*		* cFileName: Nombre completo del archivo

	*!*	Function Justpath
	*!*		Para cFileName
	*!*		Retu JustFile(cFileName,2)

	*!*		Note: Devuelve SOLO el Nombre.Ext de un archivo valido
	*!*		* cFileName: Nombre completo del archivo

	*!*	Function Justfname
	*!*		Para cFileName
	*!*		Retu JustFile(cFileName,5)

	*!*		Note: Devuelve SOLO la extension de un archivo valido
	*!*		* cFileName: Nombre completo del archivo

	*!*	Function Justext
	*!*		Para cFileName
	*!*		Retu JustFile(cFileName,4)

	*!*		Note: Devuelve SOLO el Drive de un archivo valido
	*!*		* cFileName: Nombre completo del archivo

	*!*	Function Justdrive
	*!*		Para cFileName
	*!*		Retu JustFile(cFileName,1)

	*!*		Note: Descompone el Nombre completo de un archivo
	*!*		* cFileName:  Nombre del archivo
	*!*		* nAction: 1. Drive
	*!*		*		   2. Path
	*!*		*		   3. Archivo (Default)
	*!*		*		   4. Extension
	*!*		*		   5. Archivo+Extension

	*!*	Function JustFile
	*!*		Para cFileName,nAction
	*!*		Private cReturn,cDrive,cPATH,cFName,cEXT,cStem,cAux,nLEN
	*!*		Store Null To cReturn,cDrive,cPATH,cFName,cEXT,cStem,cAux,nLEN

	*!*		cFileName=DefaultValue("cFileName","")
	*!*		nAction=DefaultValue("nAction",3)

	*!*		cFileName=Alltrim(cFileName)

	*!*		cAux=Substr(cFileName,1,2)
	*!*		Do Case
	*!*			Case Right(cAux,1)=":"
	*!*				cDrive=cAux
	*!*				cFileName=Substr(cFileName,3)
	*!*			Otherwise
	*!*				cDrive=""
	*!*		Endcase

	*!*		cAux=cFileName
	*!*		nLEN=Rat("\",cAux)
	*!*		Do Case
	*!*			Case !Empty(nLEN)
	*!*				cPATH=Substr(cAux,1,nLEN)
	*!*				cFName=Substr(cFileName,nLEN+1)
	*!*			Otherwise
	*!*				cPATH=""
	*!*				cFName=cFileName
	*!*		Endcase

	*!*		cAux=cFName
	*!*		nLEN=At(".",cAux)
	*!*		Do Case
	*!*			Case !Empty(nLEN)
	*!*				cEXT=Substr(cAux,nLEN+1)
	*!*				cStem=Substr(cAux,1,nLEN-1)
	*!*			Otherwise
	*!*				cEXT=""
	*!*				cStem=cAux
	*!*		Endcase


	*!*		Do Case
	*!*			Case nAction=1
	*!*				cReturn=cDrive

	*!*			Case nAction=2
	*!*				cReturn=cPATH

	*!*			Case nAction=3
	*!*				cReturn=cStem

	*!*			Case nAction=4
	*!*				cReturn=cEXT

	*!*			Case nAction=5
	*!*				cReturn=cFName

	*!*		Endc
	*!*		Retu cReturn

	***********************************************************************
	* Funciones Varias

	Note: Devuelve el siguiente Valor de acuerdo al tipo de expresion
Function Nextval
	Para  uExpr
	Private cVal
	Store Null To  cVal
	Do Case
		Case Type( [uExpr] )	  =   "C"
			uExpr =   Alltrim( uExpr )
			Do Case
				Case Len( uExpr ) = 1
					Retu Chr( Asc( uExpr ) + 1 )
			Endcase
			cVal =   Right( uExpr, 1)
			cVal =   Chr( Asc( cVal ) + 1 )
			Retu Stuff( uExpr, Len( uExpr ), 1, cVal )
		Case Type( [uExpr])	 =	 "D"
			Retu uExpr + 1
		Case Type( [uExpr] ) =   "L"
			Retu Iif( uExpr, .F., .T. )
		Case Type( [uExpr] ) =   "N"
			Retu uExpr + 1
		Otherwise
			Retu ""
	Endcase


	Note: Definicion de variables publicas con los comandos de Impresion
	*  cPRINTER: Nombre del campo donde estan los comandos
	*  cARCH:	 Nombre del archivo con los comandos de impresion

Proc P_CFGPRN
	Para cPRINTER,cARCH

	Private nSELE,cNOMBRE,cAux
	Store Null To nSELE,cNOMBRE,cAux

	Do Case
		Case Type("DRCOMUN")<>"C"
			DRCOMUN=Drva
	Endcase
	Do Case
		Case Pcount()=1
			cARCH=Trim(DRCOMUN)+"PRINTER"
	Endcase
	nSELE=Select()

	*!*		Sele 0
	*!*		Use '&cARCH'
	M_Use( 0, cARCH, 0, .F., "Impresora" )
	Select Alias( "Impresora" )

	Do Case
		Case Empty(cPRINTER)
			cPRINTER=Field(2)
	Endcase
	Go Top
	Do While !Eof()
		cNOMBRE=Alltrim(NOMB0)
		Public &cNOMBRE
		cAux=Iif(Empty(&cPRINTER),"SPACE(0)",Alltrim(&cPRINTER))
		&cNOMBRE=&cAux
		Skip
	Enddo

	Use In Select( "Impresoras" )
	Sele (nSELE)

	Return

	************************************************************
	Note: Seteo inicial
	Note Par: 1. Secuencia de Control
	Note Par: 2. Port de Salida

Procedure P_Setini
	Parameters tcControlString As String,;
		tcOutPort As String

	Try

		If Vartype( _PrinterPort ) # "U"
			Release _PrinterPort
		Endif

		Public _PrinterPort As String

		If Vartype( _PrinterFile ) # "U"
			Release _PrinterFile
		Endif

		Public _PrinterFile As String


		_PrinterPort = tcOutPort

		tcOutPort = Sys(2015) + ".prn"

		_PrinterFile = tcOutPort

		Page=0

		If Vartype( P_LINE ) # "N"
			P_LINE = 100
		Endif

		Line = P_LINE + 1
		Do Case
			Case Pcount()=2
				*!*				Set Printer To &tcOutPort

				Try
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Set Printer To Name '<<tcOutPort>>'
					ENDTEXT

					&lcCommand

				Catch To loErr

					If !"\\"$tcOutPort
						Try

							Set Printer To &tcOutPort

						Catch To oErr
							Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
							loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
							loError.Process ( m.loErr )
							Throw loError

						Finally

						Endtry

					Else
						Throw oErr

					Endif


				Finally

				Endtry



		Endcase
		Do Case
			Case L_Control()
				Set Device To Print
				@ 0,0 Say P_RESET+P_FONT+tcControlString
		Endcase

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return

	Note: Seteo Final

Procedure P_Setfin( tcCursorName As String,;
		tcOutputFileName As String )

	Local lcCommand As String
	Local lcFileName As String

	Try

		lcCommand = ""
		If Empty( tcCursorName )
			tcCursorName = ""
		Endif

		If Empty( tcOutputFileName )
			tcOutputFileName  = ""
		Endif

		lcFileName = Addbs( Set("Default") + Curdir() ) + _PrinterFile

		Set Device To Print
		@ 0,0 Say P_RESET

		Set Printer To
		Set Device To Screen

		Strtofile( Ansii2Ascii( Filetostr( lcFileName ) ), lcFileName )
		*Strtofile( Filetostr( lcFileName ), lcFileName )

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Run Copy "<<lcFileName>>" "<<_PrinterPort>>"
		ENDTEXT

		&lcCommand

		Set Printer To
		Set Device To Screen


		Wait Clear

		*If "PANTALLA"$Upper( _PrinterPort )
		If Inlist( Upper( _PrinterPort ), Upper( "Pantalla" ), Upper( "VistaPrevia" ) )
			_Screen.oApp.oMemoEdit.cARCH = Filetostr( _PrinterPort )
			_Screen.oApp.oMemoEdit.lCanEdit = .F.
			Erase '&_PrinterPort'

			Do Case
				Case Upper( _PrinterPort ) = Upper( "Pantalla" )
					Do Form "Rutinas\Scx\frmmemoedit.scx" With _Screen.oApp.oMemoEdit, tcCursorName, tcOutputFileName

				Case Upper( _PrinterPort ) = Upper( "VistaPrevia" )
					Do Form "Rutinas\Scx\frmVistaPrevia.scx" With _Screen.oApp.oMemoEdit.cARCH

			Endcase



		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

		Set Printer To
		Set Device To Screen

		Erase '&lcFileName'

		If Vartype( _Screen.oApp.oMemoEdit.oReport ) == "O"
			_Screen.oApp.oMemoEdit.oReport.Destroy()
		Endif
		_Screen.oApp.oMemoEdit.oReport = Null


	Endtry

	Return



	***************************************************************
	* Funcion de pedido de codigo/descripcion de campo de una tabla

	*01: Alias de la tabla
	*02: funcion de tabla
	*03: variable del indice
	*04: longitud del codigo para el PICTURE
	*05: longitud de la descripcion
	*06: picture de la descripcion
	*07: variable del codigo (caracter)
	*08: PosY del codigo
	*09: PosX del codigo
	*10: @variable de la descripcion
	*11: PosY de la descripcion
	*12: PosX de la descripcion
	*13: nro. de indice inicial
	*14: Nombre del Campo del CODIGO
	*15: Nombre del Campo de la DESCRIPCION
	*16: Retorna a la base inicial
	*17: 0 : No permite ingreso vacio
	*	 1 : Permite ingreso vacio
	*	 2 : Permite ingreso 9999
	*18: Valor a adicionar en clave
	*19: Longitud clave


	***01:PED5TAB('AR5TAB'        ,; Alias de la tabla
	***02:		  'AR_TAB5'       ,; funcion de tabla
	***03:		  'WINDE'         ,; variable del indice
	***04:		  4 			  ,; longitud del codigo para el PICTURE
	***05:		  30			  ,; longitud de la descripcion
	***06:		  REPL("X",30)    ,; picture de la descripcion
	***07:		  'WCODI'         ,; variable del codigo (caracter)
	***08:		  15			  ,; PosY del codigo
	***09:		  09			  ,; PosX del codigo
	***10:		  'WNOMB'         ,; @variable de la descripcion
	***11:		  15			  ,; PosY de la descripcion
	***12:		  09			  ,; PosX de la descripcion
	***13:		  WORDE 		  ,; nro. de indice inicial
	***14:		  'CODI5'         ,; Nombre del Campo del CODIGO
	***15:		  'NOMB5'         ,; Nombre del Campo de la DESCRIPCION
	***16:		  .F.			  ,; Retorna a la base inicial
	***17:		  0 			  ,; 0 : No permite ingreso vacio, 1 : Permite ingreso vacio, 2 : Permite ingreso 9999
	***18:		  "C"             ,; Valor a adicionar en clave
	***19:		  4 			  )  Longitud clave


Proc PED5TAB
	Para Prm01,Prm02,Prm03,Prm04,Prm05,Prm06,Prm07,Prm08,Prm09,Prm10,Prm11,Prm12,Prm13,;
		Prm14,Prm15,Prm16,Prm17,Prm18,Prm19
	Private WAUX,nSELE,nORDE,nRECN
	Store Null To WAUX,nSELE,nORDE,nRECN


	nSELE=Select()
	nORDE=INDEXORD()
	nRECN=Recno()
	Sele &Prm01

	&Prm03=Prm13
	On Key Label F1 Do Tab5UDF
	WAUX=.F.
	Do Case
		Case Type("lTAG")="U"
			lTAG=.T.
	Endcase

	Do Case
		Case Type("PRM18")="U"
			Prm18=""
	Endcase

	Do Case
		Case Type("PRM19")="U"
			Prm19=0
	Endcase

	Do Whil True
		Set Orde To &Prm03
		Do Case
			Case &Prm03=1
				*!*					@ Prm11,Prm12 Say Spac(Prm05)

				SayMask( Prm11,Prm12, Spac(Prm05) )

				Do S_Line24 With MSG20+'   [F1]:Consulta'
				WPARA=I_Askey(Prm07				   ,;
					'@Z '+Repl('9',Prm04)  ,;
					&Prm07				   ,;
					1					   ,;
					2					   ,;
					Prm08				   ,;
					Prm09				   ,;
					1					   ,;
					Prm18				   ,;
					Prm19				   ,;
					Prm17=2)
			Otherwise
				Do Case
					Case Prm17<>1
						Do S_Line24 With MSG22+'   [F1]:Consulta'
					Otherwise
						S_Line24("Ingrese descripción       [F1]: Consulta")
				Endcase
				WPARA=I_Askey(Prm10	  ,;
					Prm06	  ,;
					&Prm10	  ,;
					2		  ,;
					2		  ,;
					Prm11	  ,;
					Prm12	  ,;
					1		  ,;
					Prm18	  ,;
					Prm19	  )

				Do Case
					Case WPARA=3.And.!lTAG
						Keyboard '{F1}'
						lTAG=.T.
						Loop
				Endcase
		Endcase
		Do Case
			Case WPARA=2
				Do Case
					Case Prm17=1
						Do Case
							Case &Prm03=1
								&Prm03=2
							Case &Prm03=3
								&Prm03=1
							Otherwise
								WAUX=.T.
								Exit
						Endcase
					Otherwise
						&Prm03=Iif(&Prm03=1,2,1)
				Endcase
			Otherwise
				Exit
		Endcase
Endd
On Key Label F1
Do Case
	Case !&Aborta
		Do Case
			Case !WAUX
				Do Case
					Case &Prm07<>Val(Repl("9",Prm04))
						&Prm07=&Prm14
						&Prm10=&Prm15
				Endcase
			Otherwise
				&Prm07=0
				&Prm10=Space(50)
		Endcase
		*!*			@ Prm08 ,Prm09  Say &Prm07 Pict '@Z '+Repl('9',Prm04)
		SayMask( Prm08 ,Prm09, &Prm07, '@Z '+Repl('9',Prm04))

		*!*			@ Prm11,Prm12 Say &Prm10 Pict Prm06
		SayMask( Prm11,Prm12, &Prm10, Prm06 )

Endcase
Do Case
	Case Prm16
		Sele (nSELE)
		Set Orde To nORDE
		Goto nRECN
Endcase
Retu

Proc Tab5UDF
	Do Case
		Case Empty(Prm18)
			***DO &PRM02
			Do AR_TAB5
		Otherwise
			Do AR_TAB5 With 0,Prm18,Prm19
			***do AR_TAB5 with 0,'C',4
	Endcase
	Retu
	*****************************************************************************

Proc PedTabla( tcAlias,;
		tnLenCodigo,;
		tnLenDesc,;
		tcDescPicture,;
		tcCodigoVarName,;
		tnCodRow,;
		tnCodCol,;
		tcDescVarName,;
		tnDescRow,;
		tnDescCol,;
		tnOrder,;
		tcCodiFieldName,;
		tcDescFieldName,;
		tnTipoDeIngreso,;
		tcUDF )

	* tnTipoDeIngreso
	* 	0 : No permite ingreso vacio
	*	1 : Permite ingreso vacio
	*	2 : Permite ingreso 9999

	Local lcCommand As String
	Local WPARA As Integer
	Local lnCodigo As Integer

	Try

		lcCommand = ""
		lnCodigo = 0

		Select Alias( tcAlias )

		If Empty( tcUDF )
			tcUDF = "AR_PedTabla"
		Endif

		If Empty( tnTipoDeIngreso )
			tnTipoDeIngreso = 0
		Endif

		TEXT To lcCommand NoShow TextMerge Pretext 15
		On Key Label F1
			Do <<tcUDF>>
			With '<<tcCodiFieldName>>', '<<tcDescFieldName>>', '<<'@Z '+Repl('9',tnLenCodigo)>>', '<<tcDescPicture>>'
		ENDTEXT

		&lcCommand


		Do While True
			Set Orde To ( tnOrder )

			If tnOrder = 1

				SayMask( tnDescRow, tnDescCol, Space( tnLenDesc) )

				S_Line24( MSG20 + '   [F1]:Consulta' )

				WPARA = I_Askey(tcCodigoVarName,;
					'@Z '+Repl('9',tnLenCodigo),;
					&tcCodigoVarName,;
					1,;
					2,;
					tnCodRow,;
					tnCodCol,;
					1,;
					"",;
					0,;
					tnTipoDeIngreso = 2 )

			Else
				If tnTipoDeIngreso <> 1 && 1 : Permite ingreso vacio
					S_Line24( MSG22 + '   [F1]:Consulta' )

				Else
					S_Line24( "Ingrese descripción       [F1]: Consulta" )

				Endif

				WPARA = I_Askey(tcDescVarName,;
					tcDescPicture,;
					&tcDescVarName,;
					2,;
					2,;
					tnDescRow,;
					tnDescCol,;
					1 )

			Endif

			If WPARA = 2 && Note Ret: (1): Escape, (2): Empty, (3): Valor

				If tnTipoDeIngreso = 1 && 1 : Permite ingreso vacio
					If tnOrder = 1
						tnOrder = 2

					Else
						Exit

					Endif

				Else
					tnOrder = Iif( tnOrder = 1, 2, 1 )

				Endif

			Else
				Exit

			Endif
		Enddo

		On Key Label F1

		If !&Aborta
			SayMask( tnCodRow, tnCodCol, Evaluate( tcAlias + "." + tcCodiFieldName ), '@Z ' + Replicate( '9', tnLenCodigo ))
			SayMask( tnDescRow, tnDescCol, Evaluate( tcAlias + "." + tcDescFieldName ), tcDescPicture )
		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Retu

Proc PedTablaUDF
	Do AR_PedTabla
	Retu


Proc AR_PedTabla( tcCodiFieldName As String,;
		tcDescFieldName As String,;
		tcCodiPicture As String,;
		tcDescPicture As String )

	Local lnOrder As Integer

	Try

		Dimension Campos[2],PictureS[2],Nombres[2]

		nLen =DefaultValue("nLen",4)
		Prm1 =DefaultValue("Prm1",0)

		Campos[1] = tcCodiFieldName
		Campos[2] = tcDescFieldName

		PictureS[1] = tcCodiPicture
		PictureS[2] = tcDescPicture

		Nombres[1] = 'Código'
		Nombres[2] = 'D e s c r i p c i ó n'

		lnOrder = INDEXORD()

		Set Near On
		If lnOrder = 1
			Seek F091

		Else
			Seek C_Alfkey( F091 )

		Endif
		Set Near Off

		If Eof()
			Go Bott
		Endif

		Dbedit(5,06,16,73,@Campos,'',@PictureS,@Nombres)

		If &Aborta
			prxSetLastKey( 0 )

		Else
			F091 = Iif( lnOrder = 1, Evaluate( Alias() + "." + tcCodiFieldName ), Evaluate( Alias() + "." + tcDescFieldName ))
			prxSetLastKey( Enter )
			Keyboard '{ENTER}'

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return




	*****************************************************************************

Proc PedTablaAlfa( tcAlias,;
		tnLenCodigo,;
		tnLenDesc,;
		tcCodiPicture,;
		tcDescPicture,;
		tcCodigoVarName,;
		tnCodRow,;
		tnCodCol,;
		tcDescVarName,;
		tnDescRow,;
		tnDescCol,;
		tnOrder,;
		tcCodiFieldName,;
		tcDescFieldName,;
		tnTipoDeIngreso,;
		tcUDF )

	* tnTipoDeIngreso
	* 	0 : No permite ingreso vacio
	*	1 : Permite ingreso vacio
	*	2 : Permite ingreso 9999

	Local lcCommand As String
	Local WPARA As Integer
	Local lnCodigo As Integer

	Try

		lcCommand = ""
		lnCodigo = 0

		Select Alias( tcAlias )

		If Empty( tcUDF )
			tcUDF = "AR_PedTablaAlfa"
		Endif

		If Empty( tnTipoDeIngreso )
			tnTipoDeIngreso = 0
		Endif

		TEXT To lcCommand NoShow TextMerge Pretext 15
		On Key Label F1
			Do <<tcUDF>>
			With '<<tcCodiFieldName>>', '<<tcDescFieldName>>', '<<tcCodiPicture>>', '<<tcDescPicture>>'
		ENDTEXT

		&lcCommand


		Do While True
			Set Orde To ( tnOrder )

			If tnOrder = 1

				SayMask( tnDescRow, tnDescCol, Space( tnLenDesc) )

				S_Line24( MSG20 + '   [F1]:Consulta' )

				WPARA = I_Askey(tcCodigoVarName,;
					tcCodiPicture,;
					&tcCodigoVarName,;
					2,;
					2,;
					tnCodRow,;
					tnCodCol,;
					1 )

			Else
				If !Empty( tcDescVarName )

					If tnTipoDeIngreso <> 1 && 1 : Permite ingreso vacio
						S_Line24( MSG22 + '   [F1]:Consulta' )

					Else
						S_Line24( "Ingrese descripción       [F1]: Consulta" )

					Endif

					WPARA = I_Askey(tcDescVarName,;
						tcDescPicture,;
						&tcDescVarName,;
						2,;
						2,;
						tnDescRow,;
						tnDescCol,;
						1 )

				Endif

			Endif

			If WPARA = 2 && Note Ret: (1): Escape, (2): Empty, (3): Valor

				If tnTipoDeIngreso = 1 && 1 : Permite ingreso vacio
					If tnOrder = 1
						tnOrder = 2

					Else
						Exit

					Endif

				Else
					tnOrder = Iif( tnOrder = 1, 2, 1 )

				Endif

			Else
				Exit

			Endif
		Enddo

		On Key Label F1

		If !&Aborta
			SayMask( tnCodRow, tnCodCol, Evaluate( tcAlias + "." + tcCodiFieldName ), tcDescPicture  )
			SayMask( tnDescRow, tnDescCol, Evaluate( tcAlias + "." + tcDescFieldName ), tcDescPicture )
		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Retu

Proc PedTablaAlfaUDF
	Do AR_PedTablaAlfa
	Retu


Proc AR_PedTablaAlfa( tcCodiFieldName As String,;
		tcDescFieldName As String,;
		tcCodiPicture As String,;
		tcDescPicture As String )

	Local lnOrder As Integer

	Try

		Dimension Campos[2],PictureS[2],Nombres[2]

		nLen =DefaultValue("nLen",4)
		Prm1 =DefaultValue("Prm1",0)

		Campos[1] = tcCodiFieldName
		Campos[2] = tcDescFieldName

		PictureS[1] = tcCodiPicture
		PictureS[2] = tcDescPicture

		Nombres[1] = 'Código'
		Nombres[2] = 'D e s c r i p c i ó n'

		lnOrder = INDEXORD()

		Set Near On
		If lnOrder = 1
			Seek F091

		Else
			Seek C_Alfkey( F091 )

		Endif
		Set Near Off

		If Eof()
			Go Bott
		Endif

		Dbedit(5,06,16,73,@Campos,'',@PictureS,@Nombres)

		If &Aborta
			prxSetLastKey( 0 )

		Else
			F091 = Iif( lnOrder = 1, Evaluate( Alias() + "." + tcCodiFieldName ), Evaluate( Alias() + "." + tcDescFieldName ))
			prxSetLastKey( Enter )
			Keyboard '{ENTER}'

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return




	************************************************************************
	NOTE mostrar estado del proceso

	* 1,2,3 = Coordenadas
	* 4 = Posicion
	* 5 = Total de registros
	* 6 = Caracter de relleno

Function ProcStat
	Para nRow, nLeft, nRight, nPosicion, nTotal, cBGr

	Private nCol			,;
		nPorcentaje	,;
		nDiferencia

	Store Null To  nCol			,;
		nPorcentaje	,;
		nDiferencia

	Do Case
		Case Type("cBGR")<>"C"
			cBGr="#"
	Endcase

	Do Case
		Case nTotal>0 .And. nPosicion<=nTotal
			nPorcentaje	 = Round( nPosicion / nTotal * 100, 2 )
		Otherwise
			nPorcentaje	 = 100
	Endcase
	nDiferencia   =  nRight - nLeft + 01

	nCol  =  Round( nDiferencia / 100 * nPorcentaje, 0 )

	Do Case
		Case nCol >= 0
			@ nRow, nLeft Say Replicate( cBGr, nCol )
	Endcase

	Return nPorcentaje
	*****************************************************************************

	Note: Definicion de variables publicas con los COLORES
	*  cCOLO:	 Nombre del campo donde estan los COLORES
	*  cARCH:	 Nombre del archivo con los COLORES

Proc C_CFGCLR
	Para cCOLO,cARCH

	Retu

	********************************************************

	Note: Devolver un Valor predeterminado

Function prxDefault
	Para PRM0001,PRM0002
	Return DefaultValue( PRM0001, PRM0002 )

	*****************************************
	Note: imprimir un caracter o grupo de caracteres  Hasta una columna especificada

Function C_REPLICATE
	Para cCHAR,nCOLI,nCOLF

	Private cLINE,ni,nJ
	Store Null To cLINE,ni,nJ

	cCHAR=DefaultValue("cCHAR","-")
	nCOLI=DefaultValue("nCOLI",00)
	nCOLF=DefaultValue("nCOLF",79)

	cLINE=""

	ni=nCOLI
	Do While ni <= nCOLF
		For nJ=1 To Len(cCHAR)
			Do Case
				Case ni<=nCOLF
					cLINE=cLINE+Substr(cCHAR,nJ,1)
					ni=ni+1
			Endcase
		Next
	Enddo
	Retu cLINE

	******************************************************************

	Note: Ingresa un Password de ocho caracteres
	Note Par: 1. clave a validar
	*		  2. Cantidad de caracteres de la clave

Func ___AR_CLAVE
	* No va mas. Se reemplazó por la funcion Autorizar()
	Para cCLAVE,nLen

	Private lVALID,cPASSWORD,nCHAR,nTOP,nLeft,nBOTT,nRight,cSCREE,;
		nRow,nCol,ni

	Store Null To lVALID,cPASSWORD,nCHAR,nTOP,nLeft,nBOTT,nRight,cSCREE,;
		nRow,nCol,ni
	Set Cursor Off
	Clear Gets

	lVALID=.F.
	ni=0
	nTOP=10
	nLeft=35
	nRight=nLeft+nLen+2
	nBOTT=nTOP+3
	nRow=nTOP+1

	prxSetLastKey( 0 )

	Do While !&Aborta .And. ni<3
		prxSetLastKey( 0 )
		cPASSWORD=""
		nCHAR=1
		nCol=nLeft+1
		S_Clear(nTOP,nLeft,nBOTT,nRight)
		@ nTOP,nLeft To nBOTT,nRight

		@ nRow,nCol Say Space(nLen)

		Do While !&Aborta .And. !&confirma .And. nCol<nLeft+nLen+1
			@ nRow,nCol Say Chr(45)
			nCHAR=Inkey(0)

			prxSetLastKey( nCHAR )

			If (Chr(nCHAR)>="A" .And. Chr(nCHAR)<="Z") .Or. ;
					(Chr(nCHAR)>="a" .And. Chr(nCHAR)<="z") .Or. ;
					(Chr(nCHAR)>="0" .And. Chr(nCHAR)<="9")

				cPASSWORD=cPASSWORD+Chr(nCHAR)
				@ nRow,nCol Say Chr(42)
				nCol=nCol+1
			Endif

		Enddo
		Set Exact On
		lVALID=Alltrim(cPASSWORD)=Alltrim(cCLAVE)
		Set Exact Off
		ni=ni+1
		Do Case
			Case lVALID
				Exit

			Otherwise
				S_Line22(ERR2)

		Endcase
	Enddo

	S_Clear(nTOP,nLeft,nBOTT,nRight)
	Set Cursor On

	Retu lVALID

	**************************************************************************
	Note: Transformar la oracion en mayúscula o Minúscula
	* SINTAXIS: C_STRFORMAT(sSTRING,nTIPO)

	* sSTRING	Oraci¢n
	* nTIPO=1	Tipo oracion
	* nTIPO=2	min£sculas
	* nTIPO=3	MAYéSCULAS
	* nTIPO=4	Tipo T¡tulo
	* nTIPO=5	tIPO iNVERSO


Func C_STRFORMAT
	Para sSTRING,nTIPO

	Private sRETU,cCHAR,ni,nLen,nJ,lMAY
	Store Null To sRETU,cCHAR,ni,nLen,nJ,lMAY

	sRETU=sSTRING
	sSTRING=DefaultValue("sSTRING","")
	nTIPO  =DefaultValue("nTIPO",0)
	nLen   =Len(sSTRING)
	Do Case
		Case nTIPO>5
			nTIPO=0
	Endcase
	Do Case
		Case !Empty(sSTRING)
			Do Case
				Case nTIPO=1 && Tipo oracion
					For ni=1 To nLen
						Do Case
							Case !Empty(Substr(sSTRING,ni,1))
								sRETU = Space(ni-1)+Uppe(Substr(sSTRING,ni,1))+Lower(Substr(sSTRING,ni+1))
								Exit
						Endcase
					Next

				Case nTIPO=2 && min£sculas
					sRETU = Lower(sSTRING)

				Case nTIPO=3 && MAYéSCULAS
					sRETU = Upper(sSTRING)

				Case nTIPO=4 && Tipo T¡tulo
					lMAY=.T.
					For ni=1 To nLen
						cCHAR=Substr(sSTRING,ni,1)
						Do Case
							Case !Empty(cCHAR)
								sSTRING=Stuff(sSTRING,ni,1,Iif(lMAY,Uppe(cCHAR),Lowe(cCHAR)))
								lMAY=.F.
							Otherwise
								lMAY=.T.
						Endcase
					Next
					sRETU=sSTRING

				Case nTIPO=5 && tIPO iNVERSO
					For ni=1 To nLen
						cCHAR=Substr(sSTRING,ni,1)
						Do Case
							Case !Empty(cCHAR)
								lMAY=Islower(cCHAR)
								sSTRING=Stuff(sSTRING,ni,1,Iif(lMAY,Uppe(cCHAR),Lowe(cCHAR)))
						Endcase
					Next
					sRETU=sSTRING

				Otherwise
					sRETU = Uppe(Substr(sSTRING,1,1))+Substr(sSTRING,2)
			Endcase
	Endcase
	Retu sRETU




	**************************************************************************

Proc AR_TAB5
	Para Prm1,cTipo,nLen
	Dimension Campos[2],PictureS[2],Nombres[2]
	Private pantalla
	Store Null To pantalla

	cTipo=DefaultValue("cTipo","")
	nLen =DefaultValue("nLen",4)
	Prm1 =DefaultValue("Prm1",0)
	Do Case
		Case Empty(cTipo)
			Campos[1]='CODI5'
			Campos[2]='Nomb5'
		Otherwise
			Campos[1]='iif(TIPO5=cTipo,CODI5,0)'
			Campos[2]='iif(TIPO5=cTipo,Nomb5,Space(30))'
	Endcase
	PictureS[1]="@Z "+Repl("9",nLen)
	PictureS[2]=Repl('X',30)
	Nombres[1]='Código'
	Nombres[2]='D e s c r i p c i ó n'
	Do Case
		Case Prm1=0
			prxSetLastKey( Enter )
			Read
			prxLastkey()

	Endcase
	Set Near On
	Do Case
		Case Empty(cTipo)
			Do Case
				Case WINDE=1
					Seek F091
				Otherwise
					Seek C_Alfkey(F091)
			Endcase
		Otherwise
			Do Case
				Case WINDE=1
					Seek cTipo+Str(F091,nLen)
				Otherwise
					Seek cTipo+C_Alfkey(F091)
			Endcase
	Endcase
	Set Near Off
	Do Case
		Case Eof()
			Go Bott
	Endcase
	*!*		pantalla=Savescreen(4,04,19,75)
	*!*		SETCOLOR(CL_LINE23)
	*!*		@ 4,04,19,04 Box Chr(176)
	*!*		@ 4,75,19,75 Box Chr(176)
	*!*		@ 4,05,19,74 Box Chr(176)
	*!*		@ 17,06 To 17,73 Double
	*!*		@ 17,28 Say Chr(207)
	*!*		@ 18,06 Say '         [Enter]    ['+Chr(24)+Chr(25)+']    ['+Chr(29)+']    [PgDn] '+;
	*!*			'   [PgUp]    [Esc]        '
	*!*		SETCOLOR(CL_CHOICE)
	Dbedit(5,06,16,73,@Campos,'',@PictureS,@Nombres)
	*!*		SETCOLOR(CL_NORMAL)
	*!*		Restscreen(4,04,19,75,pantalla)
	Do Case
		Case &Aborta
			prxSetLastKey( 0 )
		Otherwise
			F091=Iif(WINDE=1,CODI5,Nomb5)
			prxSetLastKey( Enter )
	Endcase
	Return



	*
	*
Procedure GenerarCuil( nRow, nCol ) As String
	Local lcCommand As String
	Local loConsultasAFIP As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg"
	Local lnDNI As Integer


	Try

		lcCommand = ""
		On Key Label F1
		loConsultasAFIP = Newobject( "oConsultasAFIP", "FW\Comunes\prg\ConsultasAFIP.prg" )

		lnDNI = Val( Strtran( pcCuit, "-", "" ))

		pcCuit = loConsultasAFIP.CalcularCuil( lnDNI, 0, .F., nRow, nCol )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loConsultasAFIP = Null
		On Key Label F1 Do GenerarCuil With 09, 61

	Endtry

	Return pcCuit

Endproc && GenerarCuil


*
*
Procedure ValidarCuil( cCuil As String,;
		nGenero As Integer ) As Boolean

	Local lcCommand As String
	Local llValid As Boolean
	Local loConsultasAFIP As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg"

	Try

		lcCommand = ""
		loConsultasAFIP = Newobject( "oConsultasAFIP", "FW\Comunes\prg\ConsultasAFIP.prg" )
		llValid = loConsultasAFIP.ValidarCuil( cCuil, nGenero )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loConsultasAFIP = Null

	Endtry

	Return llValid

Endproc && ValidarCuil



***************************************************************
*Function VALNCUIT.PRG***Valida Nro. de CUIT
*  cCuit: Numero de cuit, caracter, en formato "99-99999999-9"
*  mVacio:	0: Permite ingreso vacio
*			1: Permite ingreso vacio, pero advierte que est  vacio
*			2: No Permite ingreso vacio
*  lMessage: .T. : Emite Mensaje
*			 .F. : No emite mensage
*
*

Procedure ValCuit( cCuit As String,;
		nVacio As Integer,;
		lMessage As Boolean,;
		oPersona As Object,;
		nInscripto As Integer ) As Boolean

	Local lcCommand As String,;
		lcNewCuit As String,;
		lcFactor As String,;
		lcCategoria  As String,;
		lcImpuestosIVA As String,;
		lcAlias As String,;
		lcErrorMessage As String,;
		lcData As String

	Local lnSuma As Integer,;
		i As Integer,;
		lnResto As Integer,;
		lnDigito As Integer,;
		lnImpuesto As Integer,;
		lnKey As Integer

	Local llOk As Boolean,;
		llExistImpuestos_Afip_IVA As Boolean,;
		llCondicion As Boolean,;
		llConsulta As Boolean

	Local loConsultasAFIP As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg"

	Local loPersona As Object,;
		loDatosGenerales As Object,;
		loDatosRegimenGeneral As Object,;
		loDatosMonotributo As Object,;
		loErrorConstancia As Object,;
		loErrorRegimenGeneral As Object,;
		loErrorMonotributo As Object,;
		loDomicilioFiscal As Object,;
		loDependencia As Object,;
		loActividad As Object,;
		loImpuesto As Object,;
		loCategoriaAutonomo As Object,;
		loRegimen As Object,;
		loMetaData As Object,;
		loActividadMonotributista As Object,;
		loCategoriaMonotributo As Object,;
		loComponente As Object,;
		loErrorRG As Object,;
		loErrorMT As Object

	Local loImpuestos As Collection,;
		loActividades As Collection,;
		loCategoriasAutonomo As Collection,;
		loRegimenes As Collection,;
		loComponentesDeSociedad As Collection,;
		loErroresRegimenGeneral As Collection,;
		loErroresMonotributo As Collection

	Local loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg"

	Try

		lcCommand 		= ""
		lcErrorMessage 	= ""
		llOk 			= .F.

		Wait Clear

		lcAlias = Alias()

		nVacio		= Iif( Vartype( nVacio ) # "N", 0, nVacio )
		lMessage	= Iif( Pcount() >= 3, lMessage, .T. )
		oPersona	= Iif( Vartype( oPersona ) = "O", oPersona, Null )

		If Empty( nInscripto )
			If .F. && Vartype( WINSC ) = "N"
				nInscripto = WINSC

			Else
				nInscripto = 0

			Endif

		Endif

		If !Empty( nInscripto )
			If Vartype( nInscripto ) # "N"
				nInscripto = 1
			Endif
			If Isnull( oPersona )
				oPersona = Createobject( "Empty" )
			Endif
		Endif

		If !Inlist( nInscripto, 2, 9 )

			If Vartype( oPersona ) = "O"
				If !Pemstatus( oPersona, "lStatus", 5 )
					AddProperty( oPersona, "lStatus", .F. )
				Endif

				If !Pemstatus( oPersona, "lSuccess", 5 )
					AddProperty( oPersona, "lSuccess", .F. )
				Endif

				If !Pemstatus( oPersona, "cErrorMessage", 5 )
					AddProperty( oPersona, "cErrorMessage", "" )
				Endif

			Endif

			cCuit	= Transform( Substr( Alltrim( Strtran( cCuit, "-", "" )) + Space( 13 ), 1, 13 ), "@R XX-XXXXXXXX-X" )

			lcFactor = '54-32765432'
			lcNewCuit = Space( 13 )

			lnSuma = 0

			For i = 1 To 11
				lnSuma = lnSuma + Val( Subst( lcFactor, i, 1 )) * Val( Subst( cCuit, i, 1 ))
			Next

			lnResto = Mod( lnSuma, 11 )
			lnDigito = Iif( lnResto = 0, lnResto, 11 - lnResto)

			If Str(lnDigito,1)!=Right(cCuit,1)
				If Empty(cCuit) .Or. cCuit='  -        - '

					Do Case
						Case nVacio=0
							llOk=.T.

						Case nVacio=1
							lcErrorMessage = "El Número de CUIT o CUIL Está Vacío"
							If lMessage
								Warning( lcErrorMessage, "ATENCION", 1 )
							Endif


							llOk=.T.

						Case nVacio=2
							lcErrorMessage = '* Debe  cargar  un número de CUIT o CUIL *'
							If lMessage
								lnKey=S_ALERT( lcErrorMessage )
								prxSetLastKey(lnKey)
							Endif
							llOk=.F.
					Endcase

				Else
					If lnDigito<10
						lcNewCuit=Left(cCuit,11)+'-'+Str(lnDigito,1)

					Else
						Do Case
							Case Left(cCuit,2)=='20'
								lcNewCuit='23-'+Substr(cCuit,4,8)+'-9'

							Case Left(cCuit,2)=='27'
								lcNewCuit='23-'+Substr(cCuit,4,8)+'-4'

							Case Left(cCuit,2)=='30'
								lcNewCuit='33-'+Substr(cCuit,4,8)+'-9'

						Endcase
					Endif

					llOk=.F.

					TEXT To lcErrorMessage NoShow TextMerge Pretext 03
					El Nº de CUIT/CUIL [<<cCuit>>] es incorrecto

					** Nº probable [<<lcNewCuit>>] **
					ENDTEXT

					If lMessage

						Wait Window Nowait Noclear lcErrorMessage

					Endif
				Endif

			Else
				llOk = .T.

			Endif

			If llOk And Vartype( oPersona ) = "O" And !Empty( Strtran( cCuit, "-", "" ))
				If lMessage
					Wait Window Nowait Noclear "Validando CUIT contra servidor AFIP ..."
				Endif

				llConsulta = .T.
				If .F. && FileExist( Addbs( Alltrim( DRCOMUN )) + "Cuit.dbf" )
					If !Used( "Cuit" )
						M_Use( 0, Addbs( Alltrim( DRCOMUN )) + "Cuit" )
					Endif

					cCuit = Strtran( cCuit, "-", "" )

					If Seek( cCuit, "Cuit", "Cuit" )
						llConsulta = ( Cuit.Fecha < ( Date() - 30 ) ) Or ( Cuit.Status <= 0 )
					Endif

				Endif

				If llConsulta

					loConsultasAFIP = Newobject( "oConsultasAFIP", "FW\Comunes\prg\ConsultasAFIP.prg" )
					loPersona = loConsultasAFIP.DatosPersonales( cCuit )

					lcCategoria = "NO INFORMADO"

					If !Pemstatus( oPersona, "lStatus", 5 )
						AddProperty( oPersona, "lStatus", .F. )
					Endif

					oPersona.lStatus = loPersona.lStatus

					If loPersona.lStatus = .T.

						If !Pemstatus( oPersona, "lSuccess", 5 )
							AddProperty( oPersona, "lSuccess", .F. )
						Endif

						oPersona.lSuccess = loPersona.Success

						If loPersona.Success

							loDatosGenerales 		= loPersona.oDatosGenerales
							loDatosRegimenGeneral 	= loPersona.oDatosRegimenGeneral
							loDatosMonotributo 		= loPersona.oDatosMonotributo
							loDomicilioFiscal 		= loDatosGenerales.DomicilioFiscal

							If !Pemstatus( oPersona, "nInscripto", 5 )
								AddProperty( oPersona, "nInscripto", 0 )
							Endif

							If !Pemstatus( oPersona, "nImpuesto", 5 )
								AddProperty( oPersona, "nImpuesto", 0 )
							Endif

							If !Pemstatus( oPersona, "cImpuesto", 5 )
								AddProperty( oPersona, "cImpuesto", "" )
							Endif

							If !Pemstatus( oPersona, "cNombre", 5 )
								AddProperty( oPersona, "cNombre", "" )
							Endif

							If !Pemstatus( oPersona, "cDireccion", 5 )
								AddProperty( oPersona, "cDireccion", "" )
							Endif

							If !Pemstatus( oPersona, "cLocalidad", 5 )
								AddProperty( oPersona, "cLocalidad", "" )
							Endif

							If !Pemstatus( oPersona, "idProvincia", 5 )
								AddProperty( oPersona, "idProvincia", 0 )
							Endif

							If !Pemstatus( oPersona, "cCodPostal", 5 )
								AddProperty( oPersona, "cCodPostal", "" )
							Endif

							If Empty( loPersona.PosicionIva )
								loPersona.PosicionIva = "No registra impuestos activos"
							Endif

							oPersona.nInscripto = loPersona.nInscripto
							oPersona.cImpuesto 	= loPersona.PosicionIva
							oPersona.nImpuesto 	= loPersona.nImpuesto

							lcCategoria = oPersona.cImpuesto

							oPersona.cNOMBRE 		= loDatosGenerales.RazonSocial

							If Empty( loDatosGenerales.RazonSocial )
								oPersona.cNOMBRE = loDatosGenerales.Apellido + " " + loDatosGenerales.Nombre
							Endif

							oPersona.cDireccion 	= loDomicilioFiscal.Direccion
							oPersona.cLocalidad 	= loDomicilioFiscal.Localidad
							oPersona.idProvincia	= Provincias_Afip[ Val( loDomicilioFiscal.idProvincia ) + 1 ]
							oPersona.cCodPostal 	= loDomicilioFiscal.CodPostal

							If oPersona.idProvincia = 1
								oPersona.cLocalidad = loDomicilioFiscal.DescripcionProvincia
							Endif

							Do Case
								Case Substr( loDatosGenerales.EstadoClave, 1, 5 ) # "ACTIV"

									TEXT To lcMsg NoShow TextMerge Pretext 03
								Razón Social: <<oPersona.cNombre>>
								Dirección: <<oPersona.cDireccion>>
								Localidad: <<oPersona.cLocalidad>>
								Provincia: <<ZONAS[ oPersona.idProvincia ]>>
								Código Postal: <<oPersona.cCodPostal>>

								* * *     ATENCION    * * *
								Estado: <<loDatosGenerales.EstadoClave>>

								Avise a ADMINISTRACION
									ENDTEXT


									lcErrorMessage = "CUIT " + loDatosGenerales.EstadoClave
									If lMessage
										Warning( lcMsg, "CUIT " + loDatosGenerales.EstadoClave, -1 )
									Endif


								Case !Empty( nInscripto )
									If nInscripto # oPersona.nInscripto

										TEXT To lcMsg NoShow TextMerge Pretext 03
									Razón Social: <<oPersona.cNombre>>
									Dirección: <<oPersona.cDireccion>>
									Localidad: <<oPersona.cLocalidad>>
									Provincia: <<ZONAS[ oPersona.idProvincia ]>>
									Código Postal: <<oPersona.cCodPostal>>

									Categoría: <<lcCategoria>>

									* * *     ATENCION    * * *

									Usted lo tiene registrado como <<Upper( IVAS[ nInscripto ] )>>

									Avise a ADMINISTRACION
										ENDTEXT

										lcErrorMessage = "CATEGORIA EQUIVOCADA"
										If lMessage
											Warning( lcMsg, "CATEGORIA EQUIVOCADA", -1 )
										Endif

									Endif

								Otherwise

							Endcase

						Else

							lcErrorMessage = loPersona.Error.Mensaje

							oPersona.lStatus = Empty( lcErrorMessage )

							TEXT To lcMsg NoShow TextMerge Pretext 03
							El Padrón de AFIP informa lo siguiente:

							ENDTEXT

							lcErrorMessage = lcMsg + CRLF + lcErrorMessage + CRLF + CRLF

							If lMessage

								Warning( lcErrorMessage, "ATENCION", -1 )
							Endif

							oPersona.cErrorMessage = lcErrorMessage

						Endif
					Endif

					If .F. && FileExist( Addbs( Alltrim( DRCOMUN )) + "Cuit.dbf" )
						If !Used( "Cuit" )
							M_Use( 0, "Cuit" )
						Endif

						loJSON = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )

						lcData = loJSON.VfpToJson( oPersona )

						Select Cuit
						If Seek( cCuit, "Cuit", "Cuit" )
							m_IniAct( 2 )

						Else
							m_IniAct( 1 )

						Endif

						If !Pemstatus( oPersona, "cNombre", 5 )
							AddProperty( oPersona, "cNombre", "" )
						Endif

						Replace Cuit With cCuit,;
							Nombre With oPersona.cNOMBRE,;
							Fecha With Date(),;
							Status With Iif( llOk, 1, -1 ),;
							Data With lcData

						Unlock

					Endif

				Else
					loJSON = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
					lcData = Cuit.Data
					loPersona = loJSON.JsonToVfp( lcData )

					If !Pemstatus( oPersona, "lStatus", 5 )
						AddProperty( oPersona, "lStatus", .F. )
					Endif

					oPersona.lStatus = loPersona.lStatus

					If !Pemstatus( oPersona, "lSuccess", 5 )
						AddProperty( oPersona, "lSuccess", .F. )
					Endif

					oPersona.lSuccess = loPersona.lSuccess

					If loPersona.lSuccess

						If !Pemstatus( oPersona, "nInscripto", 5 )
							AddProperty( oPersona, "nInscripto", 0 )
						Endif

						If !Pemstatus( oPersona, "nImpuesto", 5 )
							AddProperty( oPersona, "nImpuesto", 0 )
						Endif

						If !Pemstatus( oPersona, "cImpuesto", 5 )
							AddProperty( oPersona, "cImpuesto", "" )
						Endif

						If !Pemstatus( oPersona, "cNombre", 5 )
							AddProperty( oPersona, "cNombre", "" )
						Endif

						If !Pemstatus( oPersona, "cDireccion", 5 )
							AddProperty( oPersona, "cDireccion", "" )
						Endif

						If !Pemstatus( oPersona, "cLocalidad", 5 )
							AddProperty( oPersona, "cLocalidad", "" )
						Endif

						If !Pemstatus( oPersona, "idProvincia", 5 )
							AddProperty( oPersona, "idProvincia", 0 )
						Endif

						If !Pemstatus( oPersona, "cCodPostal", 5 )
							AddProperty( oPersona, "cCodPostal", "" )
						Endif

						If Empty( loPersona.cImpuesto )
							loPersona.cImpuesto = "No registra impuestos activos"
						Endif

						oPersona.nInscripto 	= loPersona.nInscripto
						oPersona.cImpuesto 		= loPersona.cImpuesto
						oPersona.nImpuesto 		= loPersona.nImpuesto
						oPersona.cImpuesto		= loPersona.cImpuesto
						oPersona.cNOMBRE 		= loPersona.cNOMBRE
						oPersona.cDireccion 	= loPersona.cDireccion
						oPersona.cLocalidad 	= loPersona.cLocalidad
						oPersona.idProvincia	= loPersona.idProvincia
						oPersona.cCodPostal 	= loPersona.cCodPostal
						oPersona.cLocalidad 	= loPersona.cLocalidad

					Else
						oPersona.cErrorMessage 	= loPersona.cErrorMessage

					Endif

				Endif
			Endif

		Else
			llOk = .T.

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loJSON = Null
		Use In Select( "Impuestos_Afip_IVA" )
		Use In Select( "cIva" )

		If !Empty( lcAlias )
			Select Alias( lcAlias )
		Endif

		Wait Clear

	Endtry

	Return(llOk)

Endproc && ValCuit

Procedure xxxValCuit( cCuit As String,;
		nVacio As Integer,;
		lMessage As Boolean,;
		oPersona As Object,;
		nInscripto As Integer ) As Boolean

	Local lcCommand As String,;
		lcNewCuit As String,;
		lcFactor As String,;
		lcCategoria  As String,;
		lcImpuestosIVA As String,;
		lcAlias As String,;
		lcErrorMessage As String

	Local lnSuma As Integer,;
		i As Integer,;
		lnResto As Integer,;
		lnDigito As Integer,;
		lnImpuesto As Integer,;
		lnKey As Integer

	Local llOk As Boolean,;
		llExistImpuestos_Afip_IVA As Boolean,;
		llCondicion As Boolean

	Local loPersona As Object,;
		loConsultasAFIP As oConsultasAFIP Of "FW\Comunes\prg\ConsultasAFIP.prg",;
		loImpuestos As Collection,;
		loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

	Try

		lcCommand 		= ""
		lcErrorMessage 	= ""
		llOk 			= .F.

		lcAlias = Alias()

		nVacio		= Iif( Vartype( nVacio ) # "N", 0, nVacio )
		lMessage	= Iif( Pcount() >= 3, lMessage, .T. )
		oPersona	= Iif( Vartype( oPersona ) = "O", oPersona, Null )

		If Empty( nInscripto )
			If .F. && Vartype( WINSC ) = "N"
				nInscripto = WINSC

			Else
				nInscripto = 0

			Endif

		Endif

		If !Empty( nInscripto )
			If Vartype( nInscripto ) # "N"
				nInscripto = 1
			Endif
			If Isnull( oPersona )
				oPersona = Createobject( "Empty" )
			Endif
		Endif

		If !Inlist( nInscripto, 2, 9 )

			If Vartype( oPersona ) = "O"
				If !Pemstatus( oPersona, "lStatus", 5 )
					AddProperty( oPersona, "lStatus", .F. )
				Endif

				If !Pemstatus( oPersona, "lSuccess", 5 )
					AddProperty( oPersona, "lSuccess", .F. )
				Endif

				If !Pemstatus( oPersona, "cErrorMessage", 5 )
					AddProperty( oPersona, "cErrorMessage", "" )
				Endif

			Endif

			cCuit	= Transform( Substr( Alltrim( Strtran( cCuit, "-", "" )) + Space( 13 ), 1, 13 ), "@R XX-XXXXXXXX-X" )

			lcFactor = '54-32765432'
			lcNewCuit = Space( 13 )

			lnSuma = 0

			For i = 1 To 11
				lnSuma = lnSuma + Val( Subst( lcFactor, i, 1 )) * Val( Subst( cCuit, i, 1 ))
			Next

			lnResto = Mod( lnSuma, 11 )
			lnDigito = Iif( lnResto = 0, lnResto, 11 - lnResto)

			If Str(lnDigito,1)!=Right(cCuit,1)
				If Empty(cCuit) .Or. cCuit='  -        - '

					Do Case
						Case nVacio=0
							llOk=.T.

						Case nVacio=1
							lcErrorMessage = "El Número de CUIT o CUIL Está Vacío"
							If lMessage
								Warning( lcErrorMessage, "ATENCION", 1 )
							Endif


							llOk=.T.

						Case nVacio=2
							lcErrorMessage = '* Debe  cargar  un número de CUIT o CUIL *'
							If lMessage
								lnKey=S_ALERT( lcErrorMessage )
								prxSetLastKey(lnKey)
							Endif
							llOk=.F.
					Endcase

				Else
					If lnDigito<10
						lcNewCuit=Left(cCuit,11)+'-'+Str(lnDigito,1)

					Else
						Do Case
							Case Left(cCuit,2)=='20'
								lcNewCuit='23-'+Substr(cCuit,4,8)+'-9'

							Case Left(cCuit,2)=='27'
								lcNewCuit='23-'+Substr(cCuit,4,8)+'-4'

							Case Left(cCuit,2)=='30'
								lcNewCuit='33-'+Substr(cCuit,4,8)+'-9'

						Endcase
					Endif

					llOk=.F.

					TEXT To lcErrorMessage NoShow TextMerge Pretext 03
				El Nº de CUIT/CUIL [<<cCuit>>] es incorrecto

				** Nº probable [<<lcNewCuit>>] **
					ENDTEXT

					If lMessage

						Wait Window Nowait Noclear lcErrorMessage

					Endif
				Endif

			Else
				llOk = .T.

			Endif

			If llOk And Vartype( oPersona ) = "O" And ( !Empty( cCuit ) And cCuit # '  -        - ' )
				loConsultasAFIP = Newobject( "oConsultasAFIP", "FW\Comunes\prg\ConsultasAFIP.prg" )
				loPersona = loConsultasAFIP.DatosPersonales( cCuit )

				If !Pemstatus( oPersona, "lStatus", 5 )
					AddProperty( oPersona, "lStatus", .F. )
				Endif

				oPersona.lStatus = loPersona.lStatus

				If loPersona.lStatus = .T.

					If !Pemstatus( oPersona, "lSuccess", 5 )
						AddProperty( oPersona, "lSuccess", .F. )
					Endif

					oPersona.lSuccess = loPersona.Success

					If loPersona.Success
						loImpuestos = loPersona.Data.Impuestos

						If !Pemstatus( oPersona, "nInscripto", 5 )
							AddProperty( oPersona, "nInscripto", 0 )
						Endif

						If !Pemstatus( oPersona, "nImpuesto", 5 )
							AddProperty( oPersona, "nImpuesto", 0 )
						Endif

						If !Pemstatus( oPersona, "cImpuesto", 5 )
							AddProperty( oPersona, "cImpuesto", "" )
						Endif

						If !Pemstatus( oPersona, "cNombre", 5 )
							AddProperty( oPersona, "cNombre", "" )
						Endif

						If !Pemstatus( oPersona, "cDireccion", 5 )
							AddProperty( oPersona, "cDireccion", "" )
						Endif

						If !Pemstatus( oPersona, "cLocalidad", 5 )
							AddProperty( oPersona, "cLocalidad", "" )
						Endif

						If !Pemstatus( oPersona, "idProvincia", 5 )
							AddProperty( oPersona, "idProvincia", 0 )
						Endif

						If !Pemstatus( oPersona, "cCodPostal", 5 )
							AddProperty( oPersona, "cCodPostal", "" )
						Endif

						lcCategoria = "NO INFORMADO"
						oPersona.nInscripto = 9
						oPersona.cImpuesto = lcCategoria
						oPersona.nImpuesto = 0

						loGlobalSettings = NewGlobalSettings()
						lcImpuestosIVA = loGlobalSettings.cImpuestosIVA

						If FileExist( Alltrim( DRCOMUN ) + "Impuestos_Afip_IVA.dbf" )
							If !Used( "Impuestos_Afip_IVA" )
								M_Use( 0, Alltrim( DRCOMUN ) + "Impuestos_Afip_IVA" )
							Endif
							llExistImpuestos_Afip_IVA = .T.

						Else
							llExistImpuestos_Afip_IVA = .F.

						Endif

						For Each lnImpuesto In loImpuestos

							If llExistImpuestos_Afip_IVA
								llCondicion = Seek( lnImpuesto, "Impuestos_Afip_IVA", "Id" )

							Else
								llCondicion = Inlist( lnImpuesto, 20, 21, 22, 23, 24, 30, 32, 33, 34 )

							Endif

							If llCondicion

								Do Case
									Case Inlist( lnImpuesto, 20, 21, 22, 23, 24 )
										lcCategoria = "MONOTRIBUTO"
										oPersona.nInscripto = 7

									Case Inlist( lnImpuesto, 30 )
										lcCategoria = "RESPONSABLE INSCRIPTO"
										oPersona.nInscripto = 1

									Case Inlist( lnImpuesto, 32 )
										lcCategoria = "IVA EXENTO"
										oPersona.nInscripto = 5

									Case Inlist( lnImpuesto, 34 )
										lcCategoria = "IVA NO ALCANZADO"
										oPersona.nInscripto = 3

									Case Inlist( lnImpuesto, 33 )
										lcCategoria = "IVA RESPONSABLE NO INSCRIPTO"
										oPersona.nInscripto = 4

										*!*									Case Inlist( lnImpuesto, 34 )
										*!*										lcCategoria = "IVA NO ALCANZADO"
										*!*										oPersona.nInscripto = 8

									Otherwise
										lcCategoria = "NO INFORMADO"
										oPersona.nInscripto = 9

										If llExistImpuestos_Afip_IVA
											lcCategoria = Impuestos_Afip_IVA.Nombre
										Endif

								Endcase

								oPersona.nImpuesto = lnImpuesto
								oPersona.cImpuesto = lcCategoria

								Exit

							Endif

						Endfor

						oPersona.cNOMBRE 		= loPersona.Data.Nombre
						oPersona.cDireccion 	= loPersona.Data.DomicilioFiscal.Direccion
						oPersona.cLocalidad 	= loPersona.Data.DomicilioFiscal.Localidad
						oPersona.idProvincia 	= Provincias_Afip[ loPersona.Data.DomicilioFiscal.idProvincia + 1 ]
						oPersona.cCodPostal 	= Transform( loPersona.Data.DomicilioFiscal.CodPostal )

						Do Case
							Case Substr( loPersona.Data.EstadoClave, 1, 5 ) # "ACTIV"

								TEXT To lcMsg NoShow TextMerge Pretext 03
						Razón Social: <<oPersona.cNombre>>
						Dirección: <<oPersona.cDireccion>>
						Localidad: <<oPersona.cLocalidad>>
						Provincia: <<ZONAS[ oPersona.idProvincia ]>>
						Código Postal: <<oPersona.cCodPostal>>

						* * *     ATENCION    * * *
						Estado: <<loPersona.Data.EstadoClave>>

						Avise a ADMINISTRACION
								ENDTEXT


								lcErrorMessage = "CUIT " + loPersona.Data.EstadoClave
								If lMessage
									Warning( lcMsg, "CUIT " + loPersona.Data.EstadoClave, -1 )
								Endif


							Case !Empty( nInscripto )
								If nInscripto # oPersona.nInscripto
									TEXT To lcMsg NoShow TextMerge Pretext 03
							Razón Social: <<oPersona.cNombre>>
							Dirección: <<oPersona.cDireccion>>
							Localidad: <<oPersona.cLocalidad>>
							Provincia: <<ZONAS[ oPersona.idProvincia ]>>
							Código Postal: <<oPersona.cCodPostal>>

							Categoría: <<lcCategoria>>

							* * *     ATENCION    * * *

							Usted lo tiene registrado como <<Upper( IVAS[ nInscripto ] )>>

							Avise a ADMINISTRACION
									ENDTEXT

									lcErrorMessage = "CATEGORIA EQUIVOCADA"
									If lMessage
										Warning( lcMsg, "CATEGORIA EQUIVOCADA", -1 )
									Endif

								Endif

							Otherwise

						Endcase

					Else

						lcErrorMessage = loPersona.Error.Mensaje
						If lMessage
							Warning( lcErrorMessage, "ATENCION", -1 )
						Endif

						oPersona.cErrorMessage = lcErrorMessage

						llOk = .F.

					Endif
				Endif

			Else
				If Vartype( oPersona ) = "O"
					oPersona.cErrorMessage = lcErrorMessage
				Endif

			Endif

		Else
			llOk = .T.

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Use In Select( "Impuestos_Afip_IVA" )
		Use In Select( "cIva" )

		If !Empty( lcAlias )
			Select Alias( lcAlias )
		Endif

	Endtry

	Return(llOk)

Endproc && xxxValCuit


**********************************
Note : Busco el primer C¢digo de Libre en AR4VAR

*
*
Procedure Var_Libre( cTabla, nLAST, nFIRST ) As Void
	Local lcCommand As String,;
		lcAlias As String
	Local lnChoice As Integer,;
		lnCODI As Integer

	Dimension aOpcion[2]

	Try

		lcCommand = ""
		lcAlias = Alias()

		Select AR4VAR

		If Empty( nFIRST )
			nFIRST = 1
		Endif

		If Empty( nLAST )
			nLAST = Val( Replicate( "9", gnCodi4 ))
		Endif

		lnCODI  = 0

		aOpcion[1] = " 1 - Muestra el Siguiente Código     "
		aOpcion[2] = " 2 - Reutiliza Códigos dados de Baja "
		lnChoice = S_Opcion( -1, -1, 0, 0, "AOpcion", 1, .F. )

		Do Case
			Case lnChoice=1

				Set Orde To 1
				Set Near On
				Seek cTabla+Str(nLAST,gnCodi4)
				Set Near Off
				Skip -1

				Do Case
					Case !Bof().And.TIPO4=cTabla
						lnCODI=CODI4+1
						lnCODI = Max( lnCODI, nFIRST )

					Otherwise
						lnCODI=nFIRST
				Endcase

			Case lnChoice=2
				S_Line22("Buscando...", .T.)
				lnCODI = GetFirstFree( "Ar4Var", cTabla, "Codi4", "Tipo4", nFIRST, nLAST )

		Endcase


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		If !Empty( lcAlias )
			Select Alias( lcAlias )
		Endif


	Endtry

	Return lnCODI

Endproc && Var_Libre


*
*
Procedure xxxVar_Libre( cTabla, nLAST, nFIRST ) As Void
	Local lcCommand As String,;
		lcAlias As String
	Local lnChoice As Integer,;
		lnCODI As Integer

	Dimension aOpcion[2]

	Try

		lcCommand = ""
		lcAlias = Alias()

		Select AR4VAR

		If Empty( nFIRST )
			nFIRST = 1
		Endif

		If Empty( nLAST )
			nLAST = Val( Replicate( "9", gnCodi4 ))
		Endif

		lnCODI  = 0

		aOpcion[1] = " 1 - Muestra el Siguiente Código     "
		aOpcion[2] = " 2 - Reutiliza Códigos dados de Baja "
		lnChoice = S_Opcion( -1, -1, 0, 0, "AOpcion", 1, .F. )

		Do Case
			Case lnChoice=1

				Set Orde To 1
				Set Near On
				Seek cTabla+Str(nLAST,gnCodi4)
				Set Near Off
				Skip -1

				Do Case
					Case !Bof() And ( TIPO4 = cTabla )
						Do While !Bof() ;
								And ( TIPO4 = cTabla ) ;
								And Between( CODI4, 9900, 9999 )

							Skip -1

						Enddo

						If !Bof() And ( TIPO4 = cTabla )
							lnCODI=CODI4+1

							If Between( lnCODI, 9900, 9999 )
								lnCODI = 10001
							Endif
							lnCODI = Max( lnCODI, nFIRST )

						Else
							lnCODI=nFIRST

						Endif

					Otherwise
						lnCODI=nFIRST
				Endcase

			Case lnChoice=2
				S_Line22("Buscando...", .T.)
				lnCODI = GetFirstFree( "Ar4Var", cTabla, "Codi4", "Tipo4", nFIRST, nLAST )

		Endcase


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		If !Empty( lcAlias )
			Select Alias( lcAlias )
		Endif


	Endtry

	Return lnCODI

Endproc && xxxVar_Libre



Note: Controla si la impresora esta en condiciones de imprimir
Note Dev: .T. o .F.
Note Par: 1. Port de Salida

Function P_Control
	Para Prm01
	Do Case
		Case Pcount()=1
			Set Printer To &Prm01
	Endcase
	Do Case
		Case !Isprinter()
			Do Whil !Isprinter() .And. !&Aborta
				Do S_Line23 With '[Enter]:Continua impresion               '+;
					'[Esc]:Interrumpe'
				Do S_Line24 With Acl1
				I_Inkey(Enter,Escape,0,0,0,0,0,0,0,0)
			Enddo
			Do Case
				Case !&Aborta
					Do S_Line23 With Msg12
					Do S_Line24 With Acl1
					Return(True)
				Otherwise
					Return(False)
			Endcase
		Otherwise
			Return(True)
	Endcase

	*********************************************************************

Procedure prxScroll(tnTop,tnLeft,tnBott,tnRight,tnRows)

	Scroll tnTop, tnLeft, tnBott, tnRight, nRowsScrolled

Endproc


Procedure Commit()
	Flush Force
Endproc

Procedure SETCOLOR( tcColor As String,;
		tcForeColor As String,;
		tcBackColor As String )

	Local lcOldColor As String
	Local lcNewColor As String

	Local lcColorDeFondo As String

	Local lnColorScheme As Integer

	Try


		lcCommand = ""

		lnColorScheme = 1

		If Empty( tcColor ) Or Vartype( tcColor ) # "C"
			tcColor = CL_NORMAL
		Endif


		*!*	Local o as TextBox
		*!*	o.BackColor =
		*#Define CLR_Gris 		"212,208,200"

		lcColorDeFondo = gcBackColor

		If Empty( tcBackColor )
			tcBackColor = lcColorDeFondo
		Endif

		If Empty( tcForeColor )
			tcForeColor = gcForeColor
		Endif

		lcOldColor = Rgbscheme( lnColorScheme )

		Do Case
			Case tcColor == CL_NORMAL
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<tcForeColor>>,<<tcBackColor>> ), Rgb( <<gcGetForeColor>>,<<gcGetBackColor>> ),,, Rgb( <<CLR_Negro>>,<<CLR_Blanco>> )]
				ENDTEXT

				&lcCommand

			Case tcColor == CL_LINE22
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<CLR_Rojo>>,<<tcBackColor>> )]
				ENDTEXT

				&lcCommand

			Case tcColor == CL_SELECTED
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<CLR_Blanco>>,<<CLR_Azul>> )]
				ENDTEXT

				&lcCommand

			Case tcColor == CL_USUARIO
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<tcForeColor>>,<<tcBackColor>> )]
				ENDTEXT

				&lcCommand

			Otherwise
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<tcForeColor>>,<<tcBackColor>> ), Rgb( <<gcGetForeColor>>,<<gcGetBackColor>> ),,, Rgb( <<CLR_Negro>>,<<CLR_Blanco>> )]
				ENDTEXT

				&lcCommand

		Endcase


		If tcColor = CL_NORMAL
			Set Color To &lcNewColor
			Set Color Of Scheme (lnColorScheme) To &lcNewColor

		Else
			Set Color To &lcNewColor

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcOldColor

Endproc


Procedure xxxSETCOLOR( tcColor As String,;
		tcForeColor As String,;
		tcBackColor As String )

	Local lcOldColor As String
	Local lcNewColor As String

	Local lcColorDeFondo As String,;
		lcNegro As String,;
		lcRojo As String,;
		lcVerde As String,;
		lcAzul As String,;
		lcBlanco As String,;
		lcSelected As String,;
		lcGris As String,;
		lcAmarillo As String

	Local lnColorScheme As Integer

	Try


		lnColorScheme = 1

		If Empty( tcColor ) Or Vartype( tcColor ) # "C"
			tcColor = CL_NORMAL
		Endif

		*!*			If tcColor # "CL_RESALTAR"
		*!*				tcColor = CL_NORMAL  && OJO. Con ésto fuerzo a que siempre se ejecute el normal
		*!*				* RA 2010-05-14(15:56:38)
		*!*			Endif

		*!*			If InList( tcColor, CL_RESALT, CL_LINE00 )
		*!*				tcColor = CL_NORMAL
		*!*			Endif

		lcOldColor = tcColor

		lcGris 		= "212,208,200"
		lcNegro 	= "000,000,000"
		lcRojo 		= "255,000,000"
		lcVerde 	= "000,255,000"
		lcSelected  = "220,255,255"
		lcAzul		= "010,036,106"
		lcBlanco	= "255,255,255"
		lcAmarillo 	= "255,255,000"


		*!*	Local o as TextBox
		*!*	o.BackColor =


		If Vartype( K_BKCLR ) = "C"
			lcColorDeFondo = K_BKCLR

		Else
			lcColorDeFondo = lcGris

		Endif

		If Empty( tcBackColor )
			tcBackColor = lcColorDeFondo
		Endif

		If Empty( tcForeColor )
			tcForeColor = lcNegro
		Endif


		*!*			lcColorDeFondo = lcVerde

		lcOldColor = Rgbscheme( lnColorScheme )

		*!*			lcOldColor = Set("Color")

		Do Case
			Case tcColor == CL_NORMAL
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcNegro>>,<<lcColorDeFondo>> ), Rgb( <<lcNegro>>,<<lcBlanco>> ),,, Rgb( <<lcNegro>>,<<lcBlanco>> )]
				ENDTEXT

				*!*	lcNewColor = [Rgb( <<lcNegro>>,<<lcColorDeFondo>> ), Rgb( <<lcNegro>>,<<lcSelected>> ),,, Rgb( <<lcNegro>>,<<lcBlanco>> )]
				*!*	lcNewColor = [Rgb( <<lcNegro>>,<<lcColorDeFondo>> ), Rgb( <<lcNegro>>,<<lcBlanco>> ),,, Rgb( <<lcNegro>>,<<lcBlanco>> )]

				&lcCommand

			Case .F. && tcColor == CL_BORDER
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcNegro>>,<<lcColorDeFondo>> )]
				ENDTEXT

				&lcCommand

			Case .F. && tcColor == CL_CHOICE
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcNegro>>,<<lcColorDeFondo>> )]
				ENDTEXT

				&lcCommand

			Case .F. && tcColor == CL_LINE00
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcAzul>>,<<lcColorDeFondo>> )]
				ENDTEXT

				&lcCommand

			Case .F. && tcColor == CL_LINE01
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcNegro>>,<<lcColorDeFondo>> )]
				ENDTEXT

				&lcCommand

			Case .F. && tcColor == CL_LINE21
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcNegro>>,<<lcColorDeFondo>> )]
				ENDTEXT

				&lcCommand

			Case tcColor == CL_LINE22
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcRojo>>,<<lcColorDeFondo>> )]
				ENDTEXT

				&lcCommand

			Case .F. && tcColor == CL_LINE23
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcAzul>>,<<lcColorDeFondo>> )]
				ENDTEXT

				&lcCommand

			Case .F. && tcColor == CL_LINE24
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcNegro>>,<<lcColorDeFondo>> )]
				ENDTEXT

				&lcCommand

			Case .F. && tcColor == CL_RESALT
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcAzul>>,<<lcColorDeFondo>> )]
				ENDTEXT

				&lcCommand

			Case .F. && tcColor == CL_TITULO
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcVerde>>,<<lcColorDeFondo>> )]
				ENDTEXT

				&lcCommand

			Case tcColor == CL_SELECTED
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcBlanco>>,<<lcAzul>> )]
				ENDTEXT

				*!*	lcNewColor = [Rgb( <<lcNegro>>,<<lcSelected>> )]
				&lcCommand

			Case .F. && tcColor == CL_UNSELECTED
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcNegro>>,<<lcBlanco>> )]
				ENDTEXT

				&lcCommand

			Case tcColor == CL_USUARIO
				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<tcForeColor>>,<<tcBackColor>> )]
				ENDTEXT

				&lcCommand

			Otherwise
				*!*					lcNewColor = tcColor

				TEXT To lcCommand NoShow TextMerge Pretext 15
				lcNewColor = [Rgb( <<lcNegro>>,<<lcColorDeFondo>> ), Rgb( <<lcNegro>>,<<lcBlanco>> ),,, Rgb( <<lcNegro>>,<<lcBlanco>> )]
				ENDTEXT

				*!*	lcNewColor = [Rgb( <<lcNegro>>,<<lcColorDeFondo>> ), Rgb( <<lcNegro>>,<<lcSelected>> ),,, Rgb( <<lcNegro>>,<<lcBlanco>> )]
				*!*	lcNewColor = [Rgb( <<lcNegro>>,<<lcColorDeFondo>> ), Rgb( <<lcNegro>>,<<lcBlanco>> ),,, Rgb( <<lcNegro>>,<<lcBlanco>> )]

				&lcCommand

		Endcase


		If tcColor = CL_NORMAL
			Set Color To &lcNewColor
			Set Color Of Scheme (lnColorScheme) To &lcNewColor
			*!*				Set Color Of Scheme 4 To
			*!*				Set Color TO

		Else
			Set Color To &lcNewColor

		Endif



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcOldColor

Endproc && xxxSetColor

Procedure Savescreen( tnTop, tnLeft, tnBottom, tnRight, tcScreen )
	* Save Screen To tcScreen
	*	Return tcScreen
	Return  ""
Endproc

Procedure Restscreen( tnTop, tnLeft, tnBottom, tnRight, tcVarName )
	*Restore Screen From tcVarName
Endproc

Procedure INDEXORD()
	Local lnOrder As Integer
	Local lnCount  As Integer
	Local lcOrder As String

	lnOrder = 0
	lcOrder = Lower( Order() )

	If !Empty( lcOrder )
		For lnCount = 1 To Tagcount()
			If lcOrder == Lower( Tag( "", lnCount ) )
				lnOrder = lnCount
				Exit
			Endif
		Endfor
	Endif

	Return lnOrder
Endproc

Procedure AFILL( taArray, tuValue, tnFirst, tnElements )
	Local lnLen As Integer
	Local i As Integer
	Try

		lnLen = Alen( taArray, 1 )
		If Empty( tnFirst )
			tnFirst = 1
		Endif

		If Empty( tnElements )
			tnElements = lnLen
		Endif

		For i = tnFirst To Min( lnLen, tnFirst + tnElements )
			taArray[ i ] = tuValue
		Endfor


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc

*!*	Procedure StrZero( nNumero, nAncho, nDecimales )
*!*		nAncho		=	Default("nAncho",10)
*!*		nDecimales	=	Default("nDecimales",0)
*!*		Return Padl( Alltrim( Str( nNumero, nAncho, nDecimales )), nAncho, "0")
*!*	Endproc

Procedure NetName()
	Local lcMaq As String,;
		lcUsu As String

	lcMaq = Sys(0)
	lcUsu = lcMaq
	lcMaq = Proper( Substr( lcMaq, 1, At( "#", lcMaq ) - 1 ) )
	lcUsu = Proper( Substr( lcUsu, At( "#", lcUsu) + 1 ) )

	Return lcMaq

Endproc

Procedure Usuario()
	Local lcMaq As String,;
		lcUsu As String

	lcMaq = Sys(0)
	lcUsu = lcMaq
	lcMaq = Proper( Substr( lcMaq, 1, At( "#", lcMaq ) - 1 ) )
	lcUsu = Proper( Substr( lcUsu, At( "#", lcUsu) + 1 ) )

	Return lcUsu

Endproc

Procedure If( eExpression1, eExpression2, eExpression3 )
	Return Iif(eExpression1, eExpression2, eExpression3 )
Endproc


Procedure Lastrec()
	Local lnRecno As Integer
	Local lnLastRec As Integer

	Try

		If !Eof() And !Bof()
			lnRecno = Recno()

		Else
			lnRecno = -1

		Endif

		lnLastRec = Reccount()

		If lnRecno > 0
			Goto lnRecno
		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnLastRec
Endproc


Procedure Dbedit( tnTop, tnLeft, tnBottom, tnRight,;
		taFields, tcUDF, taPictures, taHeaders, ;
		taRowLines, taColumnLines, taRowFootings, taColFootings )

	Local i As Integer
	Local lnLen As Integer
	Local lcFormatFile As String
	Local lcFields As String
	Local lcField As String
	Local lnKeyPress As Integer
	Local loColFields As Collection
	Local loColPictures As Collection
	Local loColHeaders As Collection
	Local loParam As Collection
	Local loActiveForm As Form
	Local lnTop As Integer,;
		lnLeft As Integer

	Try

		loParam = Createobject( "Collection" )
		loColFields = Createobject( "Collection" )
		loColPictures = Createobject( "Collection" )

		loColHeaders = Createobject( "Collection" )

		For Each cField In taFields
			loColFields.Add( cField )
		Endfor

		For Each cPicture In taPictures
			loColPictures.Add( cPicture )
		Endfor

		For Each cHeader In taHeaders
			loColHeaders.Add( cHeader )
		Endfor

		lnKeyPress = Escape

		*!*			loActiveForm = _Screen.ActiveForm
		loActiveForm = GetActiveForm()

		lnTop = loActiveForm.Top + ( loActiveForm.TextHeight( "X" ) * ( tnTop + 1 ))
		lnLeft = loActiveForm.Left + ( loActiveForm.TextWidth( "X" ) * tnLeft )

		loParam.Add( loColFields, "Fields" )
		loParam.Add( loColPictures, "Pictures" )
		loParam.Add( loColHeaders, "Headers" )
		loParam.Add( lnTop, "nTop" )
		loParam.Add( lnLeft, "nLeft" )

		Do Form "Rutinas\Scx\Selector" With loParam To lnKeyPress

		DoEvents

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loActiveForm = Null

	Endtry

	Return lnKeyPress
Endproc

Procedure Neterr()
	Return .F.
Endproc

Procedure Tone( tn1, tn2)
Endproc

Procedure Readexit( tlParam )
Endproc

Procedure Isprinter()
	Return Printstatus()
Endproc

Procedure Dummy
Endproc



Procedure taArray( i )
Endproc

*
* IndexKey
Function IndexKey( tnIndexNumber As Integer ) As String
	If Empty( tnIndexNumber )
		tnIndexNumber = Val( Sys( 21 ) )

	Endif && Empty( tnIndexNumber )

	Return Sys(14, tnIndexNumber )

Endfunc && IndexKey


Procedure AR_OPCION()
	Local wi,WLEN,WTOP,WBOT,WIZQ,WDER,WOPCI
	Local loParam As Object, loForm As Form
	Dimension aPara[2]

	WOPCI = 1

	*!*		aPARA[01] = C_Center( ' A C T U A L ', 40, 0 )
	*!*		aPARA[02] = C_Center( ' H I S T O R I C A ', 40, 0 )

	*!*		WLEN=0
	*!*		For WI=1 To Alen(aPARA)
	*!*			WLEN=Max(WLEN,Len(aPARA[WI]))
	*!*		Next

	*!*		WTOP=10-Int(Alen(aPARA)/2)
	*!*		WBOT=WTOP+Alen(aPARA)+01
	*!*		WIZQ=Int(40-(WLEN/2))-01
	*!*		WDER=WIZQ+WLEN+01

	*!*		loForm = _Screen.ActiveForm

	*!*		loParam = Createobject( "Empty" )
	*!*		AddProperty( loParam, "FontName", loForm.FontName )
	*!*		AddProperty( loParam, "FontSize", loForm.FontSize )

	*!*		S_CLEAR(WTOP,WIZQ,WBOT,WDER)
	*!*		WOPCI = S_OPCION( WTOP, WIZQ, WBOT, WDER, "aPARA", 1, .F., "Tipo De Consulta", loParam )
	*!*		S_CLEAR(WTOP,WIZQ,WBOT,WDER)

	Return WOPCI

Endproc

Procedure AR_GetPrinter( tcPrinter As String )

	Local lcPrinter As String
	Local lcPort As String
	Local Array laPrinters[1,5]
	Local lnRows As Integer
	Local i As Integer

	Try

		On Key Label F1
		lcPrinter 	= ""
		lcPrinter 	= Getprinter()

		If !Empty( lcPrinter )
			tcPrinter = lcPrinter
		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	*Return lcPort
	Return tcPrinter

Endproc

Procedure prxLastkey()
	Local lnKeyCode As Integer


	If _Screen.oApp.lCheckLastKey = .T. Or Empty( _Screen.oApp.nKeyCode )
		lnKeyCode = Lastkey()
		_Screen.oApp.nKeyCode = lnKeyCode

	Else
		_Screen.oApp.lCheckLastKey = .T.
		lnKeyCode = _Screen.oApp.nKeyCode

	Endif


	_Screen.oApp.nShiftAltCtrl = 0

	Try

		* RA 27/11/2016(14:06:59)
		* Resetaea el Auto Shut Off
		*_Screen.oApp.oShutOffTimer.Reset()

	Catch To oErr

	Finally

	Endtry

	Return lnKeyCode

Endproc

Procedure prxLastkeyPress( tnKeyCode As Integer )
	Return _Screen.oApp.nKeyCode = tnKeyCode
Endproc

Procedure prxSetLastKey( tnKeyCode As Integer )
	_Screen.oApp.lCheckLastKey = .F.
	_Screen.oApp.nKeyCode = tnKeyCode
	_Screen.oApp.nShiftAltCtrl = 0

	*!*		Clear Typeahead

	*!*		Try

	*!*			Keyboard Chr( tnKeyCode ) Clear

	*!*		Catch To oErr

	*!*		Finally

	*!*		Endtry


Endproc


Procedure prxGetLastkey()
	Return _Screen.oApp.nKeyCode
Endproc

* Carga el Buffer con la tecla que quiere que se ejecute
Procedure prxLoadKeyboard( nKeyStroke As Integer )

	If Vartype( nKeyStroke ) # "N"
		nKeyStroke = 0
	Endif

	_Screen.oApp.nKeyStroke = nKeyStroke

Endproc


* Ejecuta el buffer del teclado, y lo limpia
Procedure prxExecuteKeyboard()
	Local lnKey As Integer

	lnKey = _Screen.oApp.nKeyStroke

	_Screen.oApp.nKeyStroke = 0

	If !Empty( lnKey )
		Do Case
			Case lnKey = F1
				Keyboard '{F1}'

			Case lnKey = F3
				Keyboard '{F3}'

			Otherwise

		Endcase

	Endif

Endproc

Procedure prxAborta()
	Local lnKeyCode As Integer,;
		lnShiftAltCtrl As Integer
	Local llReturn As Boolean

	If Pemstatus( _Screen, "oApp", 5 )
		lnKeyCode = _Screen.oApp.nKeyCode
		lnShiftAltCtrl = _Screen.oApp.nShiftAltCtrl
		llReturn = ( lnKeyCode = Escape And lnShiftAltCtrl = 0 ) Or _Screen.oApp.lCancelProcess

	Else
		llReturn = Lastkey() = Escape

	Endif

	Return llReturn

Endproc

Procedure prxConfirma()
	Local lnKeyCode As Integer,;
		lnShiftAltCtrl As Integer

	lnKeyCode = _Screen.oApp.nKeyCode
	lnShiftAltCtrl = _Screen.oApp.nShiftAltCtrl

	Return lnKeyCode = Enter And lnShiftAltCtrl = 0

Endproc

Procedure MemoRead( cARCH )
	Return Filetostr( cARCH )

Endproc

Procedure MemoEdit( cARCH, nCOORD1, nCOORD2, nCOORD3, nCOORD4, lCanEdit, cUSERPROC, nLen )
	Local loReturnObject As Object
	Local loParam As Object
	Local lcText As String
	Try
		lcText = ""
		loParam = Createobject( "Empty" )
		loReturnObject = Createobject( "Empty" )

		AddProperty( loParam, "cArch", cARCH )
		AddProperty( loParam, "lCanEdit", lCanEdit )
		AddProperty( loParam, "cFrxFolder", "" )
		AddProperty( loParam, "cFrxName", "" )
		AddProperty( loParam, "lLaunchFrx", .F. )

		** nBoton
		** 1: Aceptar
		** 2: Cancelar
		AddProperty( loReturnObject, "nBoton", 0 )
		AddProperty( loReturnObject, "cText", "" )

		Do Form "Rutinas\Scx\frmMemoEdit" With loParam To loReturnObject

		If loReturnObject.nBoton = 1
			lcText = loReturnObject.cTEXT

		Else
			lcText = cARCH

		Endif

		Keyboard Chr( 0 ) Clear


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loReturnObject = Null
		loParam = Null

	Endtry

	Return lcText
Endproc


*
*
Procedure prxMemoEdit( cTEXT As String,;
		cCaption As String,;
		lCanEdit As Boolean,;
		nTOP As Integer,;
		nLeft As Integer,;
		nHeight As Integer,;
		nWidth As Integer,;
		oParam As Object ) As String

	Local lcCommand As String
	Local loReturnObject As Object

	Try

		lcCommand = ""

		* Validar parametros


		If Vartype( cCaption ) # "C"
			cCaption = ""
		Endif

		If Empty( nTOP )
			nTOP = -1
		Endif

		If Empty( nLeft )
			nLeft = -1
		Endif

		If Empty( nHeight )
			nHeight = -1
		Endif

		If Empty( nWidth )
			nWidth = -1
		Endif

		If Vartype( oParam ) # "O"
			oParam = Createobject( "Empty" )
		Endif

		If nTOP >= 0
			AddProperty( oParam, "Top", nTOP )
		Endif

		If nLeft >= 0
			AddProperty( oParam, "Left", nLeft )
		Endif

		If nHeight >= 0
			AddProperty( oParam, "nHeight", nHeight )
		Endif

		If nWidth >= 0
			AddProperty( oParam, "nWidth", nWidth )
		Endif

		AddProperty( oParam, "Caption", cCaption )
		AddProperty( oParam, "lCanEdit", lCanEdit )
		AddProperty( oParam, "cText", cTEXT )
		AddProperty( oParam, "nBoton", 0 )

		Do Form "Rutinas\Scx\prxMemoEdit" With oParam To loReturnObject

		If loReturnObject.nBoton = 1
			cTEXT = loReturnObject.cTEXT
		Endif

		oParam.nBoton = loReturnObject.nBoton

		Keyboard Chr( 0 ) Clear


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return cTEXT

Endproc && prxMemoEdit

*
* Muestra un campo memo en la pantalla
Procedure MemoDisplay( nTOP As Integer,;
		nLeft As Integer,;
		nBottom As Integer,;
		nRight As Integer,;
		cTEXT As String ) As Void;
		HELPSTRING "Muestra un campo memo en la pantalla"

	Local lcCommand As String,;
		lcText As String

	Local lnMemowidth As Integer,;
		lnWidth As Integer,;
		lnRow As Integer

	Try

		lcCommand = ""
		lnMemowidth = Set("Memowidth")

		lnWidth = nRight - nLeft

		Set Memowidth To lnWidth

		_Mline = 0
		lnRow = nTOP

		Do While lnRow <= nBottom

			lcText = Mline( cTEXT, 1, _Mline )

			@ lnRow, nLeft Say Padr( lcText, lnWidth, " "  )

			lnRow = lnRow + 1

		Enddo

		Do While lnRow <= nBottom

			@ lnRow, nLeft Say Space( lnWidth )

			lnRow = lnRow + 1

		Enddo

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Set Memowidth To lnMemowidth

	Endtry

Endproc && MemoDisplay





Procedure SayMask( tnRow As Integer,;
		tnCol As Integer,;
		tvVar As Variant,;
		tcPicture As String,;
		tnLen As Integer )

	Local lcType As Character
	Local lnLen As Integer
	Local lnRow As Integer, lnCol As Integer
	Local lnMaxRow As Integer,;
		lnMaxCol As Integer

	Try

		If Vartype( pnMaxCol ) = "N"
			lnMaxCol = pnMaxCol

		Else
			lnMaxCol = 80

		Endif


		If Vartype( pnMaxRow ) = "N"
			lnMaxRow = pnMaxRow

		Else
			lnMaxRow = 25

		Endif

		If !Between( tnRow, 0, lnMaxRow )
			Set Step On
			*Error "Linea fuera del rango ( " + Transform( tnRow ) + " )"
		Endif

		If !Between( tnCol, 0, lnMaxCol )
			Set Step On
			*Error "Columna fuera del rango ( " + Transform( tnCol ) + " )"
		Endif

		If Empty( tcPicture )
			tcPicture = ""
		Endif

		If !Empty( tnLen )
			lnLen = tnLen + 2

		Else

			If Vartype( tvVar ) = "N"
				If Empty( tcPicture )
					lnLen = Len( Transform( tvVar )) + 2

				Else
					lnLen = Len( Transform( tvVar, tcPicture )) + 2

				Endif


			Else
				If Substr( Upper( tcPicture ), 1, 2 ) = "@S"
					lnLen = Val(Getwordnum( "@S27", 1, "@S" )) + 2

				Else
					lnLen = Len( Transform( tvVar, tcPicture )) + 2

				Endif

			Endif

		Endif

		lnRow = tnRow
		lnCol = Max( tnCol - 1, 0 )

		If lnCol + lnLen > lnMaxCol
			lnLen = lnMaxCol - lnCol
		Endif

		@ lnRow, lnCol Say Space( lnLen )

		If !Empty( tcPicture )
			@ lnRow, tnCol Say tvVar Picture tcPicture

		Else
			Do Case
				Case Vartype( tvVar ) = "C"
					@ lnRow, tnCol Say Substr( tvVar, 1, lnLen )

				Otherwise
					@ lnRow, tnCol Say tvVar

			Endcase


		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError


	Finally

	Endtry
	Return
Endproc


Procedure achoice
	Parameters tnTop As Integer,;
		tnLeft As Integer,;
		tnBott As Integer,;
		tnRight As Integer,;
		taChoice As Variant,;
		taShow As Variant

	Local lnSelected As Integer
	Local lnCol As Integer,;
		lnRow As Integer
	Local loForm As Form
	Local i As Integer
	Local lcPrompt As String
	Local llShow As Boolean
	Local lcCommand As String
	Local lnSelection As Integer

	Try

		lnSelection = 0

		Try

			Local i As Integer

			*!*				loForm = _Screen.ActiveForm
			*!*				If !Inlist( Upper( loForm.Name ), "DISPLAYWINDOW","DISPLAYFORM", "FRMSAVESCREEN" )
			*!*					For i = 1 To _Screen.FormCount
			*!*						loForm = _Screen.Forms( i )
			*!*						If Inlist( Upper( loForm.Name ), "DISPLAYWINDOW","DISPLAYFORM", "FRMSAVESCREEN" )
			*!*							Exit
			*!*						Endif
			*!*					Endfor
			*!*				Endif

			loForm = GetActiveForm()


			lnRow = loForm.TextWidth( Replicate( "X", tnLeft )) + loForm.Left
			lnCol = loForm.TextHeight( Replicate( "X", tnTop )) + loForm.Top


		Catch To oErr
			lnRow = Mrow()
			lnCol = Mcol()

		Finally

		Endtry

		Define Popup emergente SHORTCUT Relative From lnRow, lnCol

		For i = 1 To Alen( taChoice )
			lcPrompt = taChoice[ i ]

			Try
				llShow = Evaluate( Transform( taShow[ i ] ) )

			Catch To oErr
				llShow = .T.

			Finally

			Endtry

			TEXT To lcCommand NoShow TextMerge Pretext 15
		    Define Bar <<i>> Of Emergente Prompt "<<lcPrompt>>" Skip For <<!llShow>>
			ENDTEXT

			&lcCommand

			TEXT To lcCommand NoShow TextMerge Pretext 15
			On Selection Bar <<i>> Of Emergente lnSelection = <<i>>
			ENDTEXT

			&lcCommand

		Endfor

		Activate Popup emergente


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loForm = Null

	Endtry

	*!*		lnSelection = Bar()

	Return lnSelection
Endproc

Procedure GetFirstFree( tcTable As String,;
		tcTipo As Character,;
		tcFieldName As String,;
		tcFieldClave As String,;
		tnFirst As Integer,;
		tnLast As Integer  )

	Local lnCodigo As Integer
	Local lcCursor As String,;
		lcQuery As String

	Try

		lcQuery = ""
		lnCodigo = 0
		lcCursor = Sys(2015)
		If IsEmpty( tcTipo )
			tcTipo = ""
		Endif

		If Empty( tcFieldName )
			tcFieldName = "CODI4"
		Endif

		If Empty( tcFieldClave )
			tcFieldClave = "TIPO4"
		Endif

		If Empty( tnFirst )
			tnFirst = 1
		Endif

		If Empty( tnLast )
			tnLast = Val( Replicate( "9", gnCodi4 ) )
		Endif

		Wait "Buscando Primer Código Libre ..." Window Nowait

		If Empty( tcTipo )

			If Vartype( Evaluate( tcTable + "." + tcFieldName ))  = "C"
				TEXT To lcQuery NoShow TextMerge Pretext 15
				Select Top 1 <<tcFieldName>>1 + 1 as CodigoLibre
					From ( Select 	Val(t1.<<tcFieldName>>) as <<tcFieldName>>1,
									Val(t2.<<tcFieldName>>) as <<tcFieldName>>2
								From '<<tcTable>>' t1
								Left Outer Join ( Select <<tcFieldName>>
													From '<<tcTable>>' ) T2
									On Val( T2.<<tcFieldName>> ) = Val( T1.<<tcFieldName>> ) + 1 ) t3
					Where IsNull( <<tcFieldName>>2 )
					Order by <<tcFieldName>>1
					Into Cursor <<lcCursor>>

				ENDTEXT


			Else
				TEXT To lcQuery NoShow TextMerge Pretext 15
				Select Top 1 <<tcFieldName>>1 + 1 as CodigoLibre From (
						Select 	t1.<<tcFieldName>> as <<tcFieldName>>1,
								t2.<<tcFieldName>> as <<tcFieldName>>2
							From '<<tcTable>>' t1
							Left Outer Join
									( Select <<tcFieldName>> From '<<tcTable>>' ) T2
								On T2.<<tcFieldName>> = T1.<<tcFieldName>> + 1 ) t3
					Where IsNull( <<tcFieldName>>2 )
					Order by <<tcFieldName>>1
				Into Cursor <<lcCursor>>
				ENDTEXT


			Endif

		Else
			TEXT To lcQuery NoShow TextMerge Pretext 15
			Select Nvl( Min( T1.<<tcFieldName>> + 1 ), <<tnFirst>> ) As CodigoLibre
				From
					( Select <<tcFieldName>>,<<tcFieldClave>>
							from '<<tcTable>>'
							Where <<tcFieldClave>> = '<<tcTipo>>'
								And <<tcFieldName>> Between <<tnFirst>> And <<tnLast>> ) T1
				Left Outer Join
						( Select <<tcFieldName>>,<<tcFieldClave>> from '<<tcTable>>' Where <<tcFieldClave>> = '<<tcTipo>>' ) T2
					On T2.<<tcFieldName>> = T1.<<tcFieldName>> + 1
			Where T2.<<tcFieldName>> Is Null
			Into Cursor <<lcCursor>>
			ENDTEXT

		Endif


		LogSelectCommand( lcQuery )
		&lcQuery

		If !Empty( _Tally )
			lnCodigo = Nvl( Evaluate( lcCursor + ".CodigoLibre" ), tnFirst )
		Endif

		Wait Clear


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnCodigo

Endproc 	&& GetFirstFree()



Procedure xxxGetFirstFree( tcTable As String,;
		tcTipo As Character,;
		tcFieldName As String,;
		tcFieldClave As String,;
		tnFirst As Integer,;
		tnLast As Integer  )

	Local lnCodigo As Integer
	Local lcCursor As String,;
		lcQuery As String

	Try

		lcQuery = ""
		lnCodigo = 0
		lcCursor = Sys(2015)
		If IsEmpty( tcTipo )
			tcTipo = ""
		Endif

		If Empty( tcFieldName )
			tcFieldName = "CODI4"
		Endif

		If Empty( tcFieldClave )
			tcFieldClave = "TIPO4"
		Endif

		If Empty( tnFirst )
			tnFirst = 1
		Endif

		If Empty( tnLast )
			tnLast = Val( Replicate( "9", gnCodi4 ) )
		Endif

		Wait "Buscando Primer Código Libre ..." Window Nowait

		If Empty( tcTipo )

			If Vartype( Evaluate( tcTable + "." + tcFieldName ))  = "C"
				TEXT To lcQuery NoShow TextMerge Pretext 15
				Select Nvl( Min( Val( T1.<<tcFieldName>> ) + 1 ), <<tnFirst>> ) As CodigoLibre
					From
							( Select <<tcFieldName>>
									From '<<tcTable>>'
									Where Val( <<tcFieldName>> ) Between <<tnFirst>> And <<tnLast>> ) T1
					Left Outer Join
							( Select <<tcFieldName>> From '<<tcTable>>' ) T2
						On Val( T2.<<tcFieldName>> ) = Val( T1.<<tcFieldName>> ) + 1
				Where T2.<<tcFieldName>> Is Null
				Into Cursor <<lcCursor>>
				ENDTEXT

			Else
				*!*					TEXT To lcQuery NoShow TextMerge Pretext 15
				*!*					Select Select( Min( T1.<<tcFieldName>> + 1 ), <<tnFirst>> ) As CodigoLibre
				*!*						From
				*!*								( Select <<tcFieldName>>
				*!*										From '<<tcTable>>'
				*!*										Where <<tcFieldName>> Between <<tnFirst>> And <<tnLast>> ) T1
				*!*						Left Outer Join
				*!*								( Select <<tcFieldName>> From '<<tcTable>>' ) T2
				*!*							On T2.<<tcFieldName>> = T1.<<tcFieldName>> + 1
				*!*					Where T2.<<tcFieldName>> Is Null
				*!*					Into Cursor <<lcCursor>>
				*!*					EndText


				TEXT To lcQuery NoShow TextMerge Pretext 15
				Select Top 1 <<tcFieldName>>1 as CodigoLibre From (
						Select 	t1.<<tcFieldName>> as <<tcFieldName>>1,
								t2.<<tcFieldName>> as <<tcFieldName>>2
							From '<<tcTable>>' t1
							Left Outer Join
									( Select <<tcFieldName>> From '<<tcTable>>' ) T2
								On T2.<<tcFieldName>> = T1.<<tcFieldName>> + 1 ) t3
					Where IsNull( <<tcFieldName>>2 )
					Order by <<tcFieldName>>1
				Into Cursor <<lcCursor>>
				ENDTEXT


			Endif

		Else
			TEXT To lcQuery NoShow TextMerge Pretext 15
			Select Nvl( Min( T1.<<tcFieldName>> + 1 ), <<tnFirst>> ) As CodigoLibre
				From
					( Select <<tcFieldName>>,<<tcFieldClave>>
							from '<<tcTable>>'
							Where <<tcFieldClave>> = '<<tcTipo>>'
								And <<tcFieldName>> Between <<tnFirst>> And <<tnLast>> ) T1
				Left Outer Join
						( Select <<tcFieldName>>,<<tcFieldClave>> from '<<tcTable>>' Where <<tcFieldClave>> = '<<tcTipo>>' ) T2
					On T2.<<tcFieldName>> = T1.<<tcFieldName>> + 1
			Where T2.<<tcFieldName>> Is Null
			Into Cursor <<lcCursor>>
			ENDTEXT

		Endif


		LogSelectCommand( lcQuery )
		&lcQuery

		If !Empty( _Tally )
			lnCodigo = Nvl( Evaluate( lcCursor + ".CodigoLibre" ), tnFirst )
		Endif

		Wait Clear


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnCodigo

Endproc  && xxxGetFirstFree()


Procedure taChoice( uVariant )
Endproc

Procedure taShow( uVariant )
Endproc

Function S_OpcionSiNo
	Parameters tnTop, tnLeft, tnSelected, tlShow, tcCaption, toParam, lBlanc

	Local lnListItemId As Integer
	Local loParam As Object

	Local lnTop As Integer,;
		lnLeft As Integer,;
		lnBottom As Integer,;
		lnRight As Integer,;
		lnSelected As Integer,;
		lnRow As Integer

	Local lcAName As String

	Local loForm As Form
	Local i As Integer


	Try

		If lBlanc
			Dimension aOpcion[3]

			aOpcion[1] = "Si"
			aOpcion[2] = "No"
			aOpcion[3] = "  "


		Else
			Dimension aOpcion[2]

			aOpcion[1] = "Si"
			aOpcion[2] = "No"

		Endif

		S_Line24( "" )


		lnListItemId = 3

		loForm = GetActiveForm()

		lnRow = tnTop
		If !Empty( tcCaption )
			tnTop = tnTop - 1
		Endif

		lnTop = loForm.Top + ( loForm.TextHeight( "X" ) * ( tnTop + 1 ))
		lnLeft = loForm.Left + ( loForm.TextWidth( "X" ) * tnLeft )

		lnBottom = lnTop + 05
		lnRight = lnLeft + 10
		lnSelected = tnSelected

		loParam = Createobject( "Empty" )

		If tnTop < 0
			lnTop = tnTop
		Endif

		If tnLeft < 0
			lnLeft = tnLeft
		Endif

		AddProperty( loParam,"nTop", lnTop )
		AddProperty( loParam,"nLeft", lnLeft )
		*AddProperty( loParam,"oColItems", .F. )
		AddProperty( loParam,"nSelected", lnSelected )

		If !Empty( tcCaption )
			AddProperty( loParam,"TitleBar", 1 )
			AddProperty( loParam,"Caption", tcCaption )
		Endif

		If Vartype( toParam ) == "O"
			Amembers( laMembers, toParam )
			For Each lcProperty In laMembers
				Try
					AddProperty( loParam, lcProperty, toParam.&lcProperty )

				Catch To oErr
					* No hago nada
				Finally
				Endtry
			Endfor
		Endif

		Do While !&Aborta And lnListItemId = 3

			Do Form "Rutinas\Scx\frmAChoice" With aOpcion, loParam To lnListItemId

			If !Empty( lnListItemId )
				If tlShow
					SayMask( lnRow, tnLeft, aOpcion[ lnListItemId ] )
				Endif

				_Screen.oApp.nKeyCode = Enter

			Else
				_Screen.oApp.nKeyCode = Escape


			Endif
		Enddo


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnListItemId


	*
	* Devuelve "S" o "N"
Procedure c_OpcionSiNo( tnTop, tnLeft, tcSelected, tlShow, tcCaption, toParam, lBlanc ) As Character ;
		HELPSTRING 'Devuelve "S" o "N"'
	Local lcCommand As String
	Local lcReturn As Character
	Local lnOpcion As Integer

	Try

		lcCommand 	= ""
		lcReturn 	= " "

		If Vartype( tcSelected ) # "C"
			tcSelected = "S"
		Endif

		tcSelected = Upper( tcSelected )

		If !Inlist( tcSelected, "S", "N", " " )
			tcSelected = "S"
		Endif

		Do Case
			Case tcSelected = "S"
				lnOpcion = 1

			Case tcSelected = "N"
				lnOpcion = 2

			Otherwise
				If lBlanc
					lnOpcion = 3

				Else
					lnOpcion = 1

				Endif

		Endcase

		lnOpcion = S_OpcionSiNo( tnTop, tnLeft, lnOpcion, tlShow, tcCaption, toParam, lBlanc )


		Do Case
			Case lnOpcion = 1
				lcReturn = "S"

			Case lnOpcion = 2
				lcReturn = "N"

			Case lnOpcion = 3
				lcReturn = " "

		Endcase


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcReturn

Endproc && c_OpcionSiNo


*
* Devuelve .T. o .F.
Procedure l_OpcionSiNo( tnTop, tnLeft, tlSelected, tlShow, tcCaption, toParam, lBlanc ) As Boolean;
		HELPSTRING "Devuelve .T. o .F."
	Local lcCommand As String
	Local llReturn As Boolean
	Local lnOpcion As Integer

	Try

		lcCommand 	= ""
		llReturn 	= .F.

		If Vartype( tlSelected ) # "L"
			tlSelected = .T.
		Endif

		If lBlanc
			lnOpcion = 3

		Else
			If tlSelected = .T.
				lnOpcion = 1

			Else
				lnOpcion = 2

			Endif

		Endif

		lnOpcion = S_OpcionSiNo( tnTop, tnLeft, lnOpcion, tlShow, tcCaption, toParam, lBlanc )

		If lnOpcion = 1
			llReturn = .T.

		Else
			llReturn = .F.

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return llReturn

Endproc && l_OpcionSiNo


*
* Devuelve 1 o 0
Procedure n_OpcionSiNo( tnTop, tnLeft, tnSelected, tlShow, tcCaption, toParam, lBlanc ) As Boolean;
		HELPSTRING "Devuelve .T. o .F."
	Local lcCommand As String
	Local lnReturn As Integer
	Local lnOpcion As Integer

	Try

		lcCommand 	= ""
		lnReturn 	= 0

		If Vartype( tnSelected ) # "N"
			tnSelected = 0
		Endif

		If lBlanc
			lnOpcion = 3

		Else
			If tnSelected = 0
				lnOpcion = 2

			Else
				lnOpcion = 1

			Endif

		Endif

		lnOpcion = S_OpcionSiNo( tnTop, tnLeft, lnOpcion, tlShow, tcCaption, toParam, lBlanc )

		If lnOpcion = 1
			lnReturn = 1

		Else
			lnReturn = 0

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnReturn

Endproc && n_OpcionSiNo


Procedure MEMOLINE
	Parameters tcMemo,tnCharacters,tnLine

	Return Mline( tcMemo, tnLine, tnCharacters )



	NOTE:INICIALIZACION DE VARIABLES PARA EL APAREO DE INFORMACION

Procedure AR_INICIO
	Do Case
		Case WCLAV = 'A'
			WFEC1 = FECHAHOY
			WFEC2 = LASTDATE
		Case WCLAV = 'B'
			WFEC1 = LASTDATE
			WFEC2 = FECHAHOY
		Otherwise
			Store F_CTOF( '01/01/80' ) To WFEC1, WFEC2
	Endcase
	Return

	* Funcion de pedido de codigo/descripcion de campo del AR4VAR con tabla

	* 1: nro. de tabla (caracter)
	* 2: funcion de tabla
	* 3: variable del indice
	* 4: longitud del codigo para el PICTURE
	* 5: longitud de la descripcion
	* 6: picture de la descripcion
	* 7: variable del codigo (caracter)
	* 8: PosY del codigo
	* 9: PosX del codigo
	*10: @variable de la descripcion
	*11: PosY de la descripcion
	*12: PosX de la descripcion
	*13: nro. de indice inicial. Se le suma 50 si quiere que se ejecute F1 al iniciar
	*14: variable del registro actual
	*15: .T. : Obtiene nro. de registro actual en la variable en PRM14
	*16: .T. : Vuelve al registro guardado en PRM14
	*17: [.T.|1 ]: Permite ingreso vacio
	*	 [.F.|0] : No permite ingreso vacio
	*	 2		 : Permite ingreso 9999
	*18: longitud del codigo para el SEEK
	*19: Retorna a la base inicial
	*20: Pide Indice 3
	*21: @variable del Indice 3
	*22: PosY de la Indice 3
	*23: PosX de la Indice 3
	*24: longitud de la Indice 3
	*25: picture de la Indice 3


	***PED4VAR('1'             ,; &&  1: nro. de tabla (caracter)
	*** 	   'AR_TABLA'      ,; &&  2: funcion de tabla
	*** 	   'WINDE'         ,; &&  3: variable del indice
	*** 	   4			   ,; &&  4: longitud del codigo para el PICT
	*** 	   30			   ,; &&  5: longitud de la descripcion
	*** 	   REPL("X",30)    ,; &&  6: picture de la descripcion
	*** 	   'WCODI'         ,; &&  7: variable del codigo (caracter)
	*** 	   15			   ,; &&  8: PosY del codigo
	*** 	   09			   ,; &&  9: PosX del codigo
	*** 	   'WNOMB'         ,; && 10: @variable de la descripcion
	*** 	   15			   ,; && 11: PosY de la descripcion
	*** 	   09			   ,; && 12: PosX de la descripcion
	*** 	   WORDE		   ,; && 13: nro. de indice inicial. Se le su
	*** 	   'WREGI'         ,; && 14: variable del registro actual
	*** 	   .F.			   ,; && 15: .T. : Obtiene nro. de registro a
	*** 	   .F.			   ,; && 16: .T. : Vuelve al registro guardad
	*** 	   0			   ,; && 17: [.T.|1 ]: Permite ingreso vacio 2: permite 9999
	*** 	   4			   ,; && 18: longitud del codigo para el SEEK
	*** 	   .F.				) && 19: Retorna a la base inicial

	*** 	   .T.				,; *20: Pide Indice 3 (Si es numerico, indica el Nº de indice que pide)
	*** 	   'WFANT'          ,; *21: @variable del Indice 3
	*** 	   15				,; *22: PosY de la Indice 3
	*** 	   09				,; *23: PosX de la Indice 3
	*** 	   30				,; *24: longitud de la Indice 3
	*** 	   REPL("X",30)     )  *25: picture de la Indice 3
	***			"( .T. )"			*26. Condicion de filtro



Proc PED4VAR
	Para Prm1,Prm2,Prm3,Prm4,Prm5,Prm6,Prm7,Prm8,Prm9,Prm10,Prm11,Prm12,Prm13,;
		Prm14,Prm15,Prm16,Prm17,Prm18,Prm19,Prm20,Prm21,Prm22,Prm23,Prm24,Prm25,;
		Prm26

	Private lTAG

	Local WAUX,nSELE,nORDE,nRECNO,lnIndeFant


	Release gn4Var_Codi4

	lnIndeFant = 3

	lTAG = .F.

	Prm18 = gnCodi4

	If Vartype( KULPR )<>"N"
		KULPR= GetValue( "MaxPro", "ar0Com", 9999 )
	Endif

	If Vartype( Prm14 )<>"C"
		Prm14=''
	Endif

	If Vartype( Prm17 ) = "L"
		WAUX=Prm17
		Prm17=Iif(WAUX,1,0)
	Endif

	If Vartype( Prm17 )<>"N"
		Prm17=0
	Endif

	If Vartype( Prm18 )<>"N"
		Prm18=4
	Endif

	If Type( "&PRM10")<>"C"
		&Prm10=Space(Prm5)
	Endif

	If Prm15
		&Prm14= Iif( Eof( "AR4VAR" ), -1, Recno( "AR4VAR" ) )
	Endif

	If Vartype( FANTASIA )<>"C"
		FANTASIA = "N"
	Endif

	If Vartype( Prm20 ) = "N"
		lnIndeFant = Prm20
		Prm20 = .T.
	Endif

	If FANTASIA = "S"
		If Prm1="1" .Or. Prm1="2"
			Prm20=DefaultValue("PRM20",.T.)
			If Prm20
				WFANT=DefaultValue("WFANT",Space(30))
				Prm21=DefaultValue("PRM21","WFANT")
				Prm22=DefaultValue("PRM22",Prm11)
				Prm23=DefaultValue("PRM23",Prm12)
				Prm24=DefaultValue("PRM24",Prm5)
				Prm25=DefaultValue("PRM25",Prm6)
			Endif
		Endif
	Endif

	If Prm20
		If Type( "&PRM21")<>"C"
			&Prm21=Space(Prm24)
		Endif
	Endif

	nSELE	= Select()
	nORDE	= INDEXORD()

	Sele AR4VAR
	TABLA = Prm1
	&Prm3 = Prm13

	*	On Key Label F1 Do &Prm2

	If Prm13>50
		Prm13=Prm13-50
		Keyboard '{F1}'
	Endif

	If Empty( Prm26 )
		Prm26 = "( .T. )"
	Endif


	WAUX=.F.
	*	lTAG=DefaultValue("lTAG",.T.)

	Do Whil !&Aborta And True
		On Key Label F1 Do &Prm2
		Set Orde To &Prm3
		Rele nRECNO
		Do Case
			Case Evaluate( Prm3 ) = 1
				SayMask( Prm11,Prm12,Spac(Prm5))

				If Prm20
					SayMask( Prm22,Prm23,Spac(Prm24))
				Endif

				S_Line24( MSG20+'   [F1]:Consulta' )

				WPARA=I_Askey(Prm7,'@Z '+Repl('9',Prm4),&Prm7,1,2,;
					Prm8,Prm9,1,Prm1,Prm18,Iif(Prm17=2,.T.,.F.))

			Case &Prm3=2
				Do Case
					Case Prm17<>1
						Do S_Line24 With MSG22+'   [F1]:Consulta'
					Case Prm20
						S_Line24("Ingrese descripción       [F1]: Consulta")
					Otherwise
						S_Line24("Ingrese descripción       [F1]: Consulta")
				Endcase

				WPARA=I_Askey(Prm10,Prm6,&Prm10,2,2,Prm11,Prm12,1,Prm1,0)
				Do Case
					Case WPARA=3.And.!lTAG
						F091 = AR4VAR.Nomb4
						Keyboard '{F1}'
						lTAG=.T.
						Loop
				Endcase

			Otherwise

				S_Line24("Ingrese Nombre Fantasía o blancos para busqueda por codigo   [F1]: Consulta")
				WPARA=I_Askey(Prm21,Prm25,&Prm21,2,2,Prm22,Prm23,1,Prm1,0)
				Do Case
					Case WPARA=3.And.!lTAG
						F091 = AR4VAR.Fant4
						Keyboard '{F1}'
						lTAG=.T.
						Loop
				Endcase
		Endcase

		If Vartype( gn4Var_Codi4 ) = "N"
			* RA 2015-10-02(10:20:04)
			* Se inicializa en prxTabla, y sirve cuando existen
			* mas de un registro con la misma descripcion
			Set Order To 1
			Seek TABLA + Str( gn4Var_Codi4, gnCodi4 )

			Set Orde To &Prm3
			Release gn4Var_Codi4
		Endif

		Do Case
			Case WPARA=2
				Do Case
					Case Prm17=1
						Do Case
							Case &Prm3=lnIndeFant
								WAUX=.T.
								Exit

							Case &Prm3=2 And Prm20
								&Prm3=lnIndeFant

							Case &Prm3=2
								WAUX=.T.
								Exit

							Case &Prm3=1
								&Prm3=2

						Endcase


					Case Prm20
						Do Case
							Case &Prm3=1
								&Prm3=2
							Case &Prm3=2
								&Prm3=lnIndeFant
							Otherwise
								&Prm3=1
						Endcase
					Otherwise
						&Prm3=Iif(&Prm3=1,2,1)
				Endcase

			Case WPARA=3
				If Evaluate( Prm26 )
					If TABLA="2" And Type("WCLAV")="C" ;
							And  WCLAV="A" And KULPR<CODI4

						S_Line22(Err3)
						Keyboard '{F1}'

					Else
						Exit

					Endif

				Else
					S_Line22(Err3)
					Keyboard '{F1}'

				Endif


				*!*					Do Case
				*!*						Case TABLA="2" .And. Type("WCLAV")="C"
				*!*							Do Case
				*!*								Case WCLAV="A" .And. KULPR<CODI4
				*!*									S_Line22(Err3)
				*!*									Keyboard '{F1}'
				*!*									* Loop()
				*!*								Otherwise
				*!*									Exit
				*!*							Endcase
				*!*						Otherwise
				*!*							Exit
				*!*					Endcase

			Otherwise
				Exit

		Endcase
	Enddo

	On Key Label F1

	Do Case
		Case !&Aborta
			Do Case
				Case Type("nRECNO")="N"
					Goto nRECNO
			Endcase
			Do Case
				Case !WAUX
					Do Case
						Case &Prm7<>Val(Repl("9",Prm18))
							&Prm7=CODI4
							&Prm10=Nomb4
							Do Case
								Case Prm20
									&Prm21=Fant4
							Endcase
					Endcase
				Otherwise
					&Prm7=0
					&Prm10=Space(50)
					Do Case
						Case Prm20
							&Prm21=Space(50)
					Endcase
			Endcase
			*!*			@ Prm8 ,Prm9  Say &Prm7 Pict '@Z '+Repl('9',Prm4)
			SayMask( Prm8 ,Prm9, &Prm7, '@Z '+Repl('9',Prm4))

			*!*			@ Prm11,Prm12 Say &Prm10 Pict Prm6
			SayMask( Prm11,Prm12, &Prm10, Prm6 )

			Do Case
				Case Prm20
					*!*					@ Prm22,Prm23 Say &Prm21 Pict Prm25
					SayMask( Prm22,Prm23, &Prm21, Prm25 )
			Endcase
	Endcase
	Do Case
		Case Prm16
			Set Orde To Prm13
			If &Prm14 > 0
				*!*					Go &Prm14
				GotoRecno( &Prm14 )
			Endif
	Endcase
	Do Case
		Case Prm19
			Sele (nSELE)
			Set Orde To nORDE
	Endcase
	Retu


	NOTE:CONSULTA DE ARCHIVOS

	*!*	Procedure __AR_TABLA
	*!*		Store Null To OLDCOLOR
	*!*		OLDCOLOR = SETCOLOR( )
	*!*		lTAG = .T.
	*!*		Do Case
	*!*			Case WINDE = 3
	*!*				Do Case
	*!*					Case TABLA = "2" .And.Type( "WCLAV" ) = "C"
	*!*						Dimension Campos[ 3 ], PictureS[ 3 ], Nombres[ 3 ]
	*!*						Store Null To pantalla

	*!*						Nombres[ 2 ] = 'NOMBRE FANTASÍA'
	*!*						Nombres[ 3 ] = 'RAZÓN SOCIAL'
	*!*						PictureS[ 3 ] = Repl( 'X', 30 )
	*!*						PictureS[ 2 ] = Repl( 'X', 30 )
	*!*						Do Case
	*!*							Case WCLAV = "A"
	*!*								Campos[ 1 ] = 'IIF(TIPO4=TABLA.AND.CODI4<KULPR,CODI4,SPACE(4))'
	*!*								Campos[ 2 ] = 'IIF(TIPO4=TABLA.AND.CODI4<KULPR,SUBSTR(FANT4,1,30),SPACE(30))'
	*!*								Campos[ 3 ] = 'IIF(TIPO4=TABLA.AND.CODI4<KULPR,SUBSTR(NOMB4,1,30),SPACE(30))'
	*!*							Otherwise
	*!*								Campos[ 1 ] = 'IIF(TIPO4=TABLA,CODI4,SPACE(4))'
	*!*								Campos[ 2 ] = 'IIF(TIPO4=TABLA,SUBSTR(FANT4,1,30),SPACE(30))'
	*!*								Campos[ 3 ] = 'IIF(TIPO4=TABLA,SUBSTR(NOMB4,1,30),SPACE(30))'
	*!*						Endcase
	*!*					Otherwise
	*!*						Dimension Campos[ 3 ], PictureS[ 3 ], Nombres[ 3 ]
	*!*						Store Null To pantalla
	*!*						Campos[ 1 ] = 'IIF(TIPO4=TABLA,CODI4,SPACE(4))'
	*!*						Campos[ 2 ] = 'IIF(TIPO4=TABLA,SUBSTR(FANT4,1,30),SPACE(30))'
	*!*						Campos[ 3 ] = 'IIF(TIPO4=TABLA,SUBSTR(NOMB4,1,30),SPACE(30))'

	*!*						Nombres[ 2 ] = 'NOMBRE FANTASÍA'
	*!*						Nombres[ 3 ] = 'RAZÓN SOCIAL'
	*!*						PictureS[ 3 ] = Repl( 'X', 30 )
	*!*						PictureS[ 2 ] = Repl( 'X', 30 )
	*!*				Endcase
	*!*			Otherwise
	*!*				Dimension Campos[ 2 ], PictureS[ 2 ], Nombres[ 2 ]
	*!*				Store Null To pantalla
	*!*				Campos[ 1 ] = 'IIF(TIPO4=TABLA,CODI4,SPACE(4))'
	*!*				Campos[ 2 ] = 'IIF(TIPO4=TABLA,NOMB4,SPACE(30))'
	*!*				Nombres[ 2 ] = 'N  O  M  B  R  E'
	*!*				PictureS[ 2 ] = Repl( 'X', 30 )
	*!*		Endcase
	*!*		PictureS[ 1 ] = '@Z 9999'
	*!*		Nombres[ 1 ] = 'CODIGO'
	*!*		Set Order To WINDE
	*!*		Set Near On
	*!*		Seek TABLA + Iif( WINDE = 1, Str( F091, 4 ), C_Alfkey( F091 ) )
	*!*		Set Near Off
	*!*		Do Case
	*!*			Case !Eof( ) .And.TIPO4 = TABLA
	*!*				Do Case
	*!*					Case WINDE = 3
	*!*						lnKeyPress = Dbedit( 5, 02, 16, 77, @Campos, '', @PictureS, @Nombres )
	*!*					Otherwise
	*!*						lnKeyPress = Dbedit( 5, 20, 16, 60, @Campos, '', @PictureS, @Nombres )
	*!*				Endcase
	*!*				Do Case
	*!*					Case lnKeyPress = Escape .Or.TIPO4 <> TABLA
	*!*						prxSetLastKey( 0 )
	*!*					Otherwise
	*!*						Do Case
	*!*							Case WINDE = 1
	*!*								F091 = CODI4
	*!*							Case WINDE = 2
	*!*								F091 = NOMB4
	*!*							Otherwise
	*!*								F091 = FANT4
	*!*						Endcase
	*!*						prxSetLastKey( Enter )
	*!*						nRECNO = Iif( Eof(), -1, Recno() )
	*!*				Endcase
	*!*		Endcase
	*!*		Return





	* Selector de Clientes
Procedure AR_TABCLI
	Try



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return
Endproc

* Pedido de Proveedores
Procedure AR_TABPRO
	Try



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return
Endproc

Function S_OpcionSalida
	Parameters tnTop, tnLeft, tnSelected, tlShow, tcCaption, toParam


	* RA 2012-10-15(11:36:40)
	* Parametrizar el comportamiento de la version nueva
	* Crear el objeto oApp.oPrintOptions que contenga la opcion elegida

	* Devolver siempre "R" y capturar la opcion de oApp.oPrintOptions en P_SetFin()
	*#########################################

	Local lnListItemId As Integer
	Local loParam As Object

	Local lnTop As Integer,;
		lnLeft As Integer,;
		lnBottom As Integer,;
		lnRight As Integer,;
		lnSelected As Integer
	Local lcAName As String

	Local llPrintDOS As Boolean,;
		llPrintWIN As Boolean,;
		llDefaWin As Boolean

	Local loForm As Form

	Dimension aOpcion[2]

	Try

		llPrintDOS = ( GetValue( "PrintDOS", "ar0Var", "S" ) == "S" )
		llPrintWIN = ( GetValue( "PrintWIN", "ar0Var", "S" ) == "S" )
		llDefaWin  = ( GetValue( "PrintWin", "ar0Var", "S" ) = "S" )

		aOpcion[1] = "Listado"
		aOpcion[2] = "Reporte ( Impresora / Vista Previa / Exportar )"

		If llPrintDOS And llPrintWIN

			S_Line24( "" )


			lcAName = "aOpcion"

			lnListItemId = 0

			Local i As Integer

			*!*				loForm = _Screen.ActiveForm
			*!*				If !Inlist( Upper( loForm.Name ), "DISPLAYWINDOW", "DISPLAYFORM", "FRMSAVESCREEN" )
			*!*					For i = 1 To _Screen.FormCount
			*!*						loForm = _Screen.Forms( i )
			*!*						If Inlist( Upper( loForm.Name ), "DISPLAYWINDOW","DISPLAYFORM", "FRMSAVESCREEN" )
			*!*							Exit
			*!*						Endif
			*!*					Endfor
			*!*				EndIf

			loForm = GetActiveForm()

			lnTop = loForm.Top + ( loForm.TextHeight( "X" ) * ( tnTop + 1 ))
			lnLeft = loForm.Left + ( loForm.TextWidth( "X" ) * tnLeft )

			If Empty( tnSelected )
				* Setear el default
				*!*					AR_INIPRN( 1 )
				*!*					tnSelected = Iif( P_SALI = "I", 1, 2 )

				If llDefaWin
					tnSelected = 2

				Else
					tnSelected = 1

				Endif


			Endif

			lnBottom = lnTop + 5
			lnRight = lnLeft + 10
			lnSelected = tnSelected

			loParam = Createobject( "Empty" )

			AddProperty( loParam,"nTop", lnTop )
			AddProperty( loParam,"nLeft", lnLeft )
			*AddProperty( loParam,"oColItems", .F. )
			AddProperty( loParam,"nSelected", lnSelected )

			If !Empty( tcCaption )
				AddProperty( loParam,"TitleBar", 1 )
				AddProperty( loParam,"Caption", tcCaption )
			Endif

			If Vartype( toParam ) == "O"
				Amembers( laMembers, toParam )
				For Each lcProperty In laMembers
					Try
						AddProperty( loParam, lcProperty, toParam.&lcProperty )

					Catch To oErr
						* No hago nada
					Finally
					Endtry
				Endfor
			Endif

			S_Line24( "" )

			Do Form "Rutinas\Scx\frmAChoice" With aOpcion, loParam To lnListItemId

			If !Empty( lnListItemId )
				If tlShow
					If lnListItemId = 1
						SayMask( tnTop, tnLeft, "Listado" )

					Else
						SayMask( tnTop, tnLeft, "Reporte" )

					Endif

					*!*					SayMask( tnTop, tnLeft, aOpcion[ lnListItemId ] )
				Endif

				_Screen.oApp.nKeyCode = Enter

			Else
				_Screen.oApp.nKeyCode = Escape

			Endif

		Else
			If llPrintDOS
				lnListItemId = 1

			Else
				lnListItemId = 2

			Endif

			If tlShow
				If lnListItemId = 1
					SayMask( tnTop, tnLeft, "Listado" )

				Else
					SayMask( tnTop, tnLeft, "Reporte" )

				Endif

				*!*					SayMask( tnTop, tnLeft, aOpcion[ lnListItemId ] )

			Endif

			Keyboard '{ENTER}'

		Endif



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnListItemId
Endproc


* Opcion de salida parametrizado
* Si no se pasa cSalidas, toma todas las disponibles, menos S_LISTADO_DOS
* Si no se pasa cDefault, toma S_IMPRESORA
Procedure prxOpcionSalida( nRow As Integer,;
		nCol As Integer,;
		cSalidas As String,;
		cDefault As String,;
		lSilence As Boolean ) As Character

	*!*	#Define S_IMPRESORA			'0'
	*!*	#Define S_VISTA_PREVIA		'1'
	*!*	#Define S_HOJA_DE_CALCULO	'2'
	*!*	#Define S_PANTALLA			'3'
	*!*	#Define S_PDF				'4'
	*!*	#Define S_LISTADO_DOS		'99'
	*!*	#Define S_TXT				'8'
	*!*	#Define S_MAIL				'9'

	Local lcCommand As String,;
		lcMsg As String

	Local lcSalida As Character,;
		lcOpcion As Character

	Local i As Integer,;
		lnLen As Integer,;
		lnListItemId As Integer,;
		lnDefault As Integer,;
		lnTop As Integer,;
		lnLeft As Integer,;
		lnBottom As Integer,;
		lnRight As Integer

	Local loOutputOptions As Object

	Try

		lcCommand = ""

		If Empty( nRow )
			nRow = 0
		Endif

		If Empty( nCol )
			nCol = 0
		Endif

		If Empty( cSalidas )
			cSalidas = ""

		Else
			cSalidas = Chrtran( cSalidas, Chr(9) + "'[]" + ["] , "" )

		Endif

		lnLen = Len( cSalidas )

		If Vartype( cDefault ) = "L"
			* Backward Compatibility

			If cDefault
				TEXT To cSalidas NoShow TextMerge Pretext 15
				S_IMPRESORA,
				S_VISTA_PREVIA,
				S_HOJA_DE_CALCULO,
				S_PANTALLA
				ENDTEXT

			Else
				If lnLen = 1
					TEXT To cSalidas NoShow TextMerge Pretext 15
					S_IMPRESORA,
					S_VISTA_PREVIA,
					S_HOJA_DE_CALCULO
					ENDTEXT

				Else
					cSalidas = ""

				Endif

				cDefault = Substr( cSalidas, 1, 1 )

			Endif

		Endif

		If Empty( cSalidas )
			loOutputOptions = GetOutputOptions()

			cSalidas = loOutputOptions.cSalidas

			If Empty( cDefault )
				cDefault = loOutputOptions.cDefault
			Endif
		Endif


		cSalidas = Chrtran( cSalidas, Chr(9) + "'[]" + ["] , "" )

		If Empty( cDefault )
			cDefault = S_IMPRESORA
		Endif

		lcSalida = cDefault

		lnLen =  Getwordcount( cSalidas, "," )

		If lnLen > 1
			* Armar vector de opciones

			Local Array laSalidas[ lnLen ], laOpciones[ lnLen ]

			For i = 1 To lnLen
				lcOpcion = Alltrim( Getwordnum( cSalidas, i, "," ))

				laOpciones[ i ] = lcOpcion

				If lcOpcion = cDefault
					lnDefault = i
				Endif

				Do Case
					Case lcOpcion = S_IMPRESORA
						laSalidas[ i ] = "Impresora"

					Case lcOpcion = S_VISTA_PREVIA
						laSalidas[ i ] = "Vista Previa"

					Case lcOpcion = S_HOJA_DE_CALCULO
						laSalidas[ i ] = "Hoja de Cálculo"

					Case lcOpcion = S_PANTALLA
						laSalidas[ i ] = "Pantalla"

					Case lcOpcion = S_PDF
						laSalidas[ i ] = "Archivo PDF"

					Case lcOpcion = S_CSV
						laSalidas[ i ] = "Archivo de Texto (CSV)"

					Case lcOpcion = S_SDF
						laSalidas[ i ] = "Archivo de Texto (SDF)"

					Case lcOpcion = S_TXT
						laSalidas[ i ] = "Archivo de Texto (TXT)"

					Case lcOpcion = S_LISTADO_DOS
						laSalidas[ i ] = "Listado Tipo DOS"

					Case lcOpcion = S_MAIL
						laSalidas[ i ] = "Envía PDF por Mail"

					Otherwise
						TEXT To lcMsg NoShow TextMerge Pretext 15
						Opcion No reconocida '<<lcOpcion>>'
						ENDTEXT

						Error lcMsg

				Endcase

			Endfor

			lnListItemId = 0

			Try

				*!*					loForm = _Screen.ActiveForm
				*!*					If !Inlist( Upper( loForm.Name ), "DISPLAYWINDOW", "DISPLAYFORM", "FRMSAVESCREEN" )
				*!*						For i = 1 To _Screen.FormCount
				*!*							loForm = _Screen.Forms( i )
				*!*							If Inlist( Upper( loForm.Name ), "DISPLAYWINDOW","DISPLAYFORM", "FRMSAVESCREEN" )
				*!*								Exit
				*!*							Endif
				*!*						Endfor
				*!*					EndIf

				loForm = GetActiveForm()

			Catch To oErr
				* Inicializar variables fuera del entorno de trabajo

				loForm = _Screen

			Finally


			Endtry

			lnTop 		= loForm.Top + ( loForm.TextHeight( "X" ) * ( nRow + 1 ))
			lnLeft 		= loForm.Left + ( loForm.TextWidth( "X" ) * nCol )
			lnBottom 	= lnTop + 5
			lnRight 	= lnLeft + 10


			loParam = Createobject( "Empty" )

			AddProperty( loParam,"nTop", lnTop )
			AddProperty( loParam,"nLeft", lnLeft )
			*AddProperty( loParam,"oColItems", .F. )
			AddProperty( loParam,"nSelected", lnDefault )
			AddProperty( loParam,"TitleBar", 1 )
			AddProperty( loParam,"Caption", "Seleccionar Salida" )
			AddProperty( loParam,"Closable", .F. )
			AddProperty( loParam,"Width", 200 )

			If lSilence Or ( Empty( nRow ) And Empty( nCol ))
				AddProperty( loParam,"Autocenter", .T. )
				lSilence = .T.
			Endif

			If Vartype( toParam ) == "O"
				Amembers( laMembers, toParam )
				For Each lcProperty In laMembers
					Try
						AddProperty( loParam, lcProperty, toParam.&lcProperty )

					Catch To oErr
						* No hago nada
					Finally
					Endtry
				Endfor
			Endif

			Do Form "Rutinas\Scx\frmAChoice" With laSalidas, loParam To lnListItemId

			If !Empty( lnListItemId )
				If !lSilence
					SayMask( nRow, nCol, laSalidas[ lnListItemId ] )
				Endif

				_Screen.oApp.nKeyCode = Enter

				lcSalida = laOpciones[ lnListItemId ]

			Endif
		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcSalida

Endproc && prxOpcionSalida

Procedure prxOpcionSalidaOld( nRow As Integer,;
		nCol As Integer,;
		cSalida As Character,;
		lPantalla As Boolean ) As Character

	Local lcCommand As String,;
		lcMsg As String

	Local lcSalida As Character


	Try

		lcCommand = ""
		lcSalida = "0"

		If !Empty( cSalida )
			lcSalida = cSalida
		Endif

		@ nRow, nCol Say Spac(15)

		TEXT To lcMsg NoShow TextMerge Pretext 15
		[0]: Impresora    [1]: Vista Previa   [2]: Hoja de Cálculo    <<Iif( lPantalla, "[3]: Pantalla", "" )>>
		ENDTEXT

		S_Line24( lcMsg )
		@ nRow, nCol Get lcSalida Pict '9' Valid I_Valida( Inlist( cSalida, "0", "1", "2", Iif( lPantalla, "3", "0" )))
		Read
		Do Case
			Case !&Aborta
				Do Case
					Case lcSalida = "0"
						SayMask( nRow, nCol, "Impresora", "", 15 )

					Case lcSalida = "1"
						SayMask( nRow, nCol, "Vista Previa", "", 15 )

					Case lcSalida = "2"
						SayMask( nRow, nCol, "Hoja de Cálculo", "", 15 )

					Case lcSalida = "3"
						SayMask( nRow, nCol, "Pantalla", "", 15 )

				Endcase


		Endcase


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcSalida

Endproc && prxOpcionSalidaOld

* Selecciona un Impresora
* Si no se pasa cDefault, toma la predeterminada
Procedure prxOpcionImpresora( nRow As Integer,;
		nCol As Integer,;
		cDefault As String,;
		lSilence As Boolean,;
		cCaption As String ) As Character

	Local lcCommand As String,;
		lcMsg As String,;
		lcPrinter As String,;
		lcDefaultPrinter As String

	Local lcOpcion As Character

	Local i As Integer,;
		lnLen As Integer,;
		lnListItemId As Integer,;
		lnDefault As Integer,;
		lnTop As Integer,;
		lnLeft As Integer,;
		lnBottom As Integer,;
		lnRight As Integer

	Local Array laPrinters[ 1 ]

	Try

		lcCommand = ""

		If Empty( nRow )
			nRow = 0
		Endif

		If Empty( nCol )
			nCol = 0
		Endif

		lnDefault = 0

		If Empty( cDefault )
			lcDefaultPrinter = Upper( Set("Printer",2))

		Else
			lcDefaultPrinter = Upper( cDefault )

		Endif

		If Empty( cCaption )
			cCaption = "Seleccionar Impresora"
		Endif

		lnLen = Aprinters( laPrinters )
		Dimension paPrinters[ lnLen ]

		For i = 1 To lnLen

			paPrinters[ i ] = laPrinters[ i, 1 ]

			If Upper( laPrinters[ i, 1 ] ) = lcDefaultPrinter
				lnDefault = i
			Endif

		Endfor


		loForm = GetActiveForm()


		lnTop 		= loForm.Top + ( loForm.TextHeight( "X" ) * ( nRow + 1 ))
		lnLeft 		= loForm.Left + ( loForm.TextWidth( "X" ) * nCol )
		lnBottom 	= lnTop + 5
		lnRight 	= lnLeft + 10


		loParam = Createobject( "Empty" )

		AddProperty( loParam,"nTop", lnTop )
		AddProperty( loParam,"nLeft", lnLeft )
		*AddProperty( loParam,"oColItems", .F. )
		AddProperty( loParam,"nSelected", lnDefault )
		AddProperty( loParam,"TitleBar", 1 )
		AddProperty( loParam,"Caption", cCaption )
		AddProperty( loParam,"Closable", .F. )
		AddProperty( loParam,"Width", 200 )
		AddProperty( loParam,"nSelected", lnDefault )

		If Empty( nRow ) And Empty( nCol )
			AddProperty( loParam,"Autocenter", .T. )
		Endif

		Do Form "Rutinas\Scx\frmAChoice" With paPrinters, loParam To lnListItemId

		If !Empty( lnListItemId )
			If !lSilence
				SayMask( nRow, nCol, paPrinters[ lnListItemId ] )
			Endif

			_Screen.oApp.nKeyCode = Enter

			lcPrinter = paPrinters[ lnListItemId ]

		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcPrinter

Endproc && prxOpcionImpresora

*
*
Procedure GetLetraComprobante( nInsc As Integer ) As Character
	Local lcCommand As String
	Local lcLetra As Character

	Try

		lcCommand = ""

		Do Case
			Case Inlist( nInsc, 7 )
				If GetValue( "Mono_Fecha", "ar0Ven", {^2021/07/01} ) <= FECHAHOY
					lcLetra = "A"

				Else
					lcLetra = "B"

				Endif

			Case Inlist( nInsc, 1, 4, 6 )
				lcLetra = "A"

			Otherwise
				lcLetra = "B"

		Endcase


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcLetra

Endproc && GetLetraComprobante



*
* Muestra el tipo de tasa de iva
Procedure GetTasaIva( nTasaId As Integer,;
		cType As Character ) As Variant ;
		HELPSTRING "Muestra el tipo de tasa de iva"

	Local lcCommand As String
	Local lnIvaReducido As Number,;
		lnIvaNormal As Number,;
		lnIvaDiferenciado As Number,;
		lnIvaMediosGraficos9 As Number,;
		lnIvaMediosGraficos8 As Number

	Local luReturn As Variant
	Local lnId As Integer

	Local Array laIvas[ 6 ]

	Try

		lcCommand = ""

		If Empty( cType )
			cType = ""
		Endif

		lnIvaDiferenciado 		= Alicuotas[ IVA_DIFERENCIADO_ID ]
		lnIvaNormal 			= Alicuotas[ IVA_NORMAL_ID ]
		lnIvaReducido 			= Alicuotas[ IVA_REDUCIDO_ID ]
		lnIvaMediosGraficos8 	= Alicuotas[ IVA_MGRAF8_ID ]
		lnIvaMediosGraficos9 	= Alicuotas[ IVA_MGRAF9_ID ]

		Do Case
			Case nTasaId = IVA_CERO_ID
				lnId = 1

			Case nTasaId = IVA_REDUCIDO_ID
				lnId = 2

			Case nTasaId = IVA_NORMAL_ID
				lnId = 3

			Case nTasaId = IVA_DIFERENCIADO_ID
				lnId = 4

			Case nTasaId = IVA_MGRAF8_ID
				lnId = 5

			Case nTasaId = IVA_MGRAF9_ID
				lnId = 6

			Otherwise
				lnId = 3

		Endcase

		Do Case
			Case cType = 'C'
				laIvas[ 1 ] = "Iva 0,00%"
				laIvas[ 2 ] = "Iva Reducido (" + Transform( lnIvaReducido, "99.99" ) + "%)"
				laIvas[ 3 ] = "Iva Normal (" + Transform( lnIvaNormal, "99.99" ) + "%)"
				laIvas[ 4 ] = "Iva Diferenciado (" + Transform( lnIvaDiferenciado, "99.99" ) + "%)"
				laIvas[ 5 ] = "Iva Graficos (" + Transform( lnIvaMediosGraficos8, "99.99" ) + "%)"
				laIvas[ 6 ] = "Iva Graficos (" + Transform( lnIvaMediosGraficos9, "99.99" ) + "%)"

				lnMaxLen = 0
				For i = 1 To Alen( laIvas, 1 )
					lnMaxLen = Max( lnMaxLen, Len( laIvas[ i ] ) )
				Endfor

				For i = 1 To Alen( laIvas, 1 )
					laIvas[ i ] = Padr( laIvas[ i ], lnMaxLen, " " )
				Endfor

			Otherwise
				laIvas[ 1 ] = 0.00
				laIvas[ 2 ] = lnIvaReducido
				laIvas[ 3 ] = lnIvaNormal
				laIvas[ 4 ] = lnIvaDiferenciado
				laIvas[ 5 ] = lnIvaMediosGraficos8
				laIvas[ 6 ] = lnIvaMediosGraficos9

		Endcase

		luReturn = laIvas[ lnId ]


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return luReturn

Endproc && GetTasaIva

* Selecciona la Tasa de Iva
*
* nInputType: 0. Id; 1. Valor
* nOutputType: 0. Valor; 1. Id
* lSilence: True. PopUp centrado; False: Imprime la devolucion
* lcOpciones: No Habilitado

Procedure prxOpcionIva( nRow As Integer,;
		nCol As Integer,;
		nDefault As Integer,;
		nInputType As Integer,;
		nOutputType As Integer,;
		lSilence As Boolean,;
		lcOpciones As String,;
		nModulo As Integer ) As Number

	Local lcCommand As String

	Local i As Integer,;
		lnLen As Integer,;
		lnListItemId As Integer,;
		lnDefault As Integer,;
		lnTop As Integer,;
		lnLeft As Integer,;
		lnBottom As Integer,;
		lnRight As Integer,;
		lnMaxLen As Integer

	Local lnIvaReducido As Number,;
		lnIvaNormal As Number,;
		lnIvaDiferenciado As Number,;
		lnIvaMediosGraficos9 As Number,;
		lnIvaMediosGraficos8 As Number

	Local lnReturn As Number

	Local loOutputOptions As Object
	Local llUsaIvaCero As Boolean,;
		llUsaIvaDiferenciado As Boolean,;
		llUsaIvaGraficos1 As Boolean,;
		llUsaIvaGraficos2 As Boolean




	Try

		lcCommand = ""
		If Empty( nModulo )
			nModulo = 1
		Endif

		If nModulo = 1 && Ventas
			llUsaIvaCero 			= GetValue( "UsaIva_" + Transform( IVA_CERO_ID ), "ar0Ven", "S" ) = "S"
			llUsaIvaDiferenciado 	= GetValue( "UsaIva_" + Transform( IVA_DIFERENCIADO_ID ), "ar0Ven", "N" ) = "S"
			llUsaIvaGraficos1 		= GetValue( "UsaIva_" + Transform( IVA_MGRAF9_ID ), "ar0Ven", "N" ) = "S"
			llUsaIvaGraficos2 		= GetValue( "UsaIva_" + Transform( IVA_MGRAF8_ID ), "ar0Ven", "N" ) = "S"

		Else
			llUsaIvaGraficos1 		= GetValue( "UsaIva_" + Transform( IVA_MGRAF9_ID ), "ar0Com", "N" ) = "S"
			llUsaIvaGraficos2 		= GetValue( "UsaIva_" + Transform( IVA_MGRAF8_ID ), "ar0Com", "N" ) = "S"
			llUsaIvaCero 			= .T.
			llUsaIvaDiferenciado 	= .T.

		Endif

		lnLen = 2
		If llUsaIvaCero
			lnLen = lnLen + 1
		Endif
		If llUsaIvaDiferenciado
			lnLen = lnLen + 1
		Endif
		If llUsaIvaGraficos1
			lnLen = lnLen + 1
		Endif
		If llUsaIvaGraficos2
			lnLen = lnLen + 1
		Endif

		Local Array laIvas[ lnLen ], laOpciones[ lnLen ]

		lnDefault = 0

		If Empty( nRow )
			nRow = 0
		Endif

		If Empty( nCol )
			nCol = 0
		Endif

		If Empty( nDefault )
			nDefault = 0
		Endif

		If Empty( nInputType )
			nInputType = 0
			* 0: Id
			* 1: Valor
		Endif

		If Empty( nOutputType )
			nOutputType = 0
			* 0: Valor
			* 1: Id
		Endif

		lnIvaDiferenciado 		= GetValue( "IvaDife", "ar0Imp", 27.00 )
		lnIvaNormal 			= GetValue( "IvaNorm", "ar0Imp", 21.00 )
		lnIvaReducido 			= GetValue( "IvaRedu", "ar0Imp", 10.50 )
		lnIvaMediosGraficos9 	= GetValue( "IvaMGraf9", "ar0Imp", 2.50 )
		lnIvaMediosGraficos8 	= GetValue( "IvaMGraf8", "ar0Imp", 5.00 )


		i = 0

		If llUsaIvaCero
			i = i + 1
			laIvas[ i ] = "Iva 0,00%"

			If nInputType = 0
				If nDefault = IVA_CERO_ID
					lnDefault = i
				Endif

			Else
				If nDefault = 0
					lnDefault = i
				Endif

			Endif

			If nOutputType = 0
				* Valor
				laOpciones[ i ] = 0.00

			Else
				* Id
				laOpciones[ i ] = IVA_CERO_ID

			Endif

		Endif


		i = i + 1
		laIvas[ i ] = "Iva Reducido (" + Transform( lnIvaReducido, "99.99" ) + "%)"
		If nInputType = 0
			If nDefault = IVA_REDUCIDO_ID
				lnDefault = i
			Endif

		Else
			If nDefault = lnIvaReducido
				lnDefault = i
			Endif

		Endif
		If nOutputType = 0
			* Valor
			laOpciones[ i ] = lnIvaReducido

		Else
			* Id
			laOpciones[ i ] = IVA_REDUCIDO_ID

		Endif

		i = i + 1
		laIvas[ i ] = "Iva Normal (" + Transform( lnIvaNormal, "99.99" ) + "%)"
		If nInputType = 0
			If nDefault = IVA_NORMAL_ID
				lnDefault = i
			Endif

		Else
			If nDefault = lnIvaNormal
				lnDefault = i
			Endif

		Endif
		If nOutputType = 0
			* Valor
			laOpciones[ i ] = lnIvaNormal

		Else
			* Id
			laOpciones[ i ] = IVA_NORMAL_ID

		Endif

		If llUsaIvaDiferenciado
			i = i + 1
			laIvas[ i ] = "Iva Diferenciado (" + Transform( lnIvaDiferenciado, "99.99" ) + "%)"

			If nInputType = 0
				If nDefault = IVA_DIFERENCIADO_ID
					lnDefault = i
				Endif

			Else
				If nDefault = lnIvaDiferenciado
					lnDefault = i
				Endif

			Endif

			If nOutputType = 0
				* Valor
				laOpciones[ i ] = lnIvaDiferenciado

			Else
				* Id
				laOpciones[ i ] = IVA_DIFERENCIADO_ID

			Endif

		Endif

		If llUsaIvaGraficos1
			i = i + 1
			laIvas[ i ] = "Iva Graficos (" + Transform( lnIvaMediosGraficos9, "99.99" ) + "%)"

			If nInputType = 0
				If nDefault = IVA_MGRAF9_ID
					lnDefault = i
				Endif

			Else
				If nDefault = lnIvaMediosGraficos9
					lnDefault = i
				Endif

			Endif

			If nOutputType = 0
				* Valor
				laOpciones[ i ] = lnIvaMediosGraficos9

			Else
				* Id
				laOpciones[ i ] = IVA_MGRAF9_ID

			Endif

		Endif

		If llUsaIvaGraficos2
			i = i + 1
			laIvas[ i ] = "Iva Graficos (" + Transform( lnIvaMediosGraficos8, "99.99" ) + "%)"

			If nInputType = 0
				If nDefault = IVA_MGRAF8_ID
					lnDefault = i
				Endif

			Else
				If nDefault = lnIvaMediosGraficos8
					lnDefault = i
				Endif

			Endif

			If nOutputType = 0
				* Valor
				laOpciones[ i ] = lnIvaMediosGraficos8

			Else
				* Id
				laOpciones[ i ] = IVA_MGRAF8_ID

			Endif

		Endif

		lnListItemId = 0

		loForm = GetActiveForm()

		lnTop 		= loForm.Top + ( loForm.TextHeight( "X" ) * ( nRow + 1 ))
		lnLeft 		= loForm.Left + ( loForm.TextWidth( "X" ) * nCol )
		lnBottom 	= lnTop + 5
		lnRight 	= lnLeft + 10

		loParam = Createobject( "Empty" )

		AddProperty( loParam,"nTop", lnTop )
		AddProperty( loParam,"nLeft", lnLeft )

		AddProperty( loParam,"nSelected", lnDefault )
		AddProperty( loParam,"TitleBar", 1 )
		AddProperty( loParam,"Caption", "Seleccionar IVA" )
		AddProperty( loParam,"Closable", .F. )
		AddProperty( loParam,"Width", 200 )

		If lSilence
			lSilence = .T.
		Endif

		If Empty( nRow ) And Empty( nCol )
			AddProperty( loParam,"Autocenter", .T. )
		Endif

		If Vartype( toParam ) == "O"
			Amembers( laMembers, toParam )
			For Each lcProperty In laMembers
				Try
					AddProperty( loParam, lcProperty, toParam.&lcProperty )

				Catch To oErr
					* No hago nada
				Finally
				Endtry
			Endfor
		Endif

		Do Form "Rutinas\Scx\frmAChoice" With laIvas, loParam To lnListItemId

		If !Empty( lnListItemId )
			If !lSilence

				lnMaxLen = 0
				For i = 1 To Alen( laIvas, 1 )
					lnMaxLen = Max( lnMaxLen, Len( laIvas[ i ] ) )
				Endfor

				SayMask( nRow, nCol, Padr( laIvas[ lnListItemId ], lnMaxLen, " " ))

			Endif

			_Screen.oApp.nKeyCode = Enter

			lnReturn = laOpciones[ lnListItemId ]

		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnReturn

Endproc && prxOpcionIva


Procedure ChequeaSucCaja
	If Type("pnSUCE")='N'

		If Type("pnSUCEOrig")<>'N'
			pnSUCEOrig=0
		Endif

		If pnSUCE<>pnSUCEOrig
			Messagebox("Sucursal de Caja modificada de <"+Str(pnSUCEOrig,2)+">  a  <"+Str(pnSUCE,2)+"> ",0,"Atencion!!")
			Messagebox("Se Continua con la Sucursal de <"+Str(pnSUCE,2)+"> ",0,"Atencion!!")
		Endif


	Endif

	Retu

	*!*		* Leer la variable Pública TERMINAL, cuando esté declarada en un archivo externo
	*!*		* En caso contrario, tiene el valor TERMINAL=1
	*!*	Procedure SetSuce
	*!*		If  FileExist( "Terminal.Mem" )
	*!*			Restore From Terminal Additive
	*!*		Else
	*!*			pnSUCE=0
	*!*			pnSUCEOrig=0
	*!*		Endif


	*!*				If Type("pnSuce")="U"
	*!*					pnSuce=0
	*!*				Else
	*!*					If Type("pnSuce")<>"N"
	*!*						pnSuce=Val(pnSuce)
	*!*					EndIf
	*!*
	*!*				EndIf
	*!*
	*!*				If Type("pnSuceOrig")="U"
	*!*					pnSuceOrig=0
	*!*				Else
	*!*					If Type("pnSuceOrig")<>"N"
	*!*						pnSuceOrig=Val(pnSuceOrig)
	*!*					EndIf
	*!*
	*!*				EndIf
	*!*		Return




	*
	* devuelve un string con los datos del comprobante
Procedure MostrarComprobante( tnComp As Integer,;
		tcTipo As Character,;
		tnSucu As Integer,;
		tnNume As Integer,;
		tnFinal As Integer, ;
		tcMascara As String;
		) As String;
		HELPSTRING "devuelve un string con los datos del comprobante"

	Local lcComprobante As String
	Local lnLenSuc As Integer,;
		lnLenNum As Integer

	Try

		lcComprobante = ""

		If Empty( tcMascara )
			tcMascara = "SSSS-NNNNNNNN"
		Endif

		lnLenSuc = Len( Getwordnum( tcMascara, 1, "-" ))
		lnLenNum = Len( Getwordnum( tcMascara, 2, "-" ))

		If Vartype( tnComp ) # "N"
			tnComp = 0
		Endif

		If Empty( tnFinal )
			tnFinal = 0
		Endif

		Do Case
			Case tnComp = 1
				lcComprobante = "FC"

				If tcTipo = "X"
					* Remito
					lcComprobante = "RT"
				Endif

			Case tnComp = 2
				lcComprobante = "ND"

			Case tnComp = 3
				lcComprobante = "NC"

			Case tnComp = 4
				lcComprobante = "FC"

			Case tnComp = 5
				lcComprobante = "ND"

			Case tnComp = 6
				lcComprobante = "NC"

			Case tnComp = 7
				lcComprobante = "RC"

			Case tnComp = 8
				lcComprobante = "RC"

			Case tnComp = 9
				lcComprobante = "AJE "

			Case tnComp = 10
				lcComprobante = "AJS "

			Case tnComp = 12
				lcComprobante = "AD"
				If tnSucu = 99
					lcComprobante = "CHR "
				Endif

			Case tnComp = 13
				lcComprobante = "AH"

			Case tnComp = 15
				lcComprobante = "AD"

			Case tnComp = 16
				lcComprobante = "AH"

			Case tnComp = 17
				lcComprobante = "TRE "

			Case tnComp = 18
				lcComprobante = "TRS "

			Case tnComp = 19
				lcComprobante = "RT"

			Case tnComp = 20
				lcComprobante = "RT"

			Case tnComp = 20
				lcComprobante = "RT"

			Case tnComp = 21
				lcComprobante = "DEV "

			Case tnComp = 25
				lcComprobante = "DOT "

			Otherwise

		Endcase

		If !Empty( tnComp )
			If !Inlist( tnComp, 21, 22, 25, 9, 10, 17, 18 ) And tnSucu # 99
				lcComprobante = lcComprobante + tcTipo + " "
			Endif

			If tnSucu = 99
				lcComprobante = lcComprobante + Space( lnLenSuc + 1 )

			Else
				lcComprobante = lcComprobante + StrZero( tnSucu, lnLenSuc ) + "-"

			Endif

			lcComprobante = lcComprobante + StrZero( tnNume, lnLenNum )

			If tnFinal > tnNume
				lcComprobante = lcComprobante + "-" + StrZero( tnFinal, lnLenNum )
			Endif
		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally


	Endtry

	Return lcComprobante

Endproc && MosrarComprobante

*
*
Procedure ImporteDeCalculo( tnImporte As Number,;
		tnComprobante As Integer  ) As Void

	Local lnImporte As Number

	Try

		If Inlist( tnComprobante, 1, 2, 4, 5, 12, 16, 22, 25, 27 )
			lnImporte = tnImporte

		Else
			lnImporte = tnImporte * -1

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnImporte

Endproc && ImporteDeCalculo


*
* Devuelve el codigo del cliente cuyo cuit se recibe por parámetro
Procedure GetClienteByCuit( tcCuit As String  ) As Void;
		HELPSTRING "Devuelve el codigo del cliente cuyo cuit se recibe por parámetro"

	Local lnCodigo As Integer
	Try

		lnCodigo = GetByCuit( tcCuit, "1" )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnCodigo

Endproc && GetClienteByCuit

*
* Devuelve el codigo del Proveedor cuyo cuit se recibe por parámetro
Procedure GetProveedorByCuit( tcCuit As String ) As Void;
		HELPSTRING "Devuelve el codigo del Proveedor cuyo cuit se recibe por parámetro"
	Local lnCodigo As Integer
	Try

		lnCodigo = GetByCuit( tcCuit, "2" )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnCodigo

Endproc && GetProveedorByCuit

*
* Devuelve el codigo desde  ar4Var, cuyo cuit4 y Tipo4 se recibe por parámetro
Procedure GetByCuit( tcCuit As String,;
		tcTipo As Character ) As Void;
		HELPSTRING "Devuelve el codigo desde  ar4Var, cuyo cuit4 y Tipo4 se recibe por parámetro"

	Local lnCodigo As Integer
	Local lcCommand As String ,;
		lcAlias As String ,;
		lcCuit As String


	Try

		lcAlias = Sys( 2015 )
		lnCodigo = 0

		* Buscar primero con guiones
		lcCuit = Transform( Strtran( tcCuit, "-", "" ), "@R 99-99999999-9" )

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select
			Codi4
		From AR4VAR
		Where Tipo4 = '<<tcTipo>>' And Cuit4 = '<<lcCuit>>'
		Into Cursor ( lcAlias )
		ENDTEXT

		&lcCommand


		If !Empty( _Tally )
			Locate
			lnCodigo = Evaluate( lcAlias + ".Codi4" )

		Else
			* Buscar sin guiones
			lcCuit = Strtran( tcCuit, "-", "" )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select
				Codi4
			From AR4VAR
			Where Tipo4 = '<<tcTipo>>' And Cuit4 = '<<lcCuit>>'
			Into Cursor ( lcAlias )
			ENDTEXT

			&lcCommand

			If !Empty( _Tally )
				Locate
				lnCodigo = Evaluate( lcAlias + ".Codi4" )

			Else
				lnCodigo = 0

				TEXT To lcCommand NoShow TextMerge Pretext 15
				No se encontró el registro
				correspondiente al CUIT <<lcCuit>>
				ENDTEXT

				Warning( lcCommand, "Busqueda por CUIT" )

			Endif

		Endif

		If _Tally > 1
			TEXT To lcCommand NoShow TextMerge Pretext 15
			Existen <<_Tally>> registros con el Cuit <<lcCuit>>
			Se devuelve el registro correspondiente al primero encontrado
			ENDTEXT

			Warning( lcCommand, "Busqueda por CUIT" )

		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError


	Finally
		If Used( lcAlias )
			Use In Alias( lcAlias )
		Endif

	Endtry

	Return lnCodigo

Endproc && GetByCuit


*
*
Procedure ShowTransaction( tnTranId As Integer,;
		tnNexa As Number ) As Void

	Try

		TEXT To lcMsg NoShow TextMerge Pretext 03
		Mostrar la información
		de la Transaccion
		ENDTEXT

		Warning( lcMsg, "Falta Implementar" )


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && ShowTransaction


*
*
Procedure DescripcionComprobante( tnComp As Integer,;
		tcTipo As Character,;
		tnSucu As Integer,;
		tnNume As Integer ) As String

	Local lcComprobante As String

	Try

		If Vartype( tnComp ) = "C"
			lcComprobante = tnComp

		Else

			Do Case
				Case tnComp = 1
					lcComprobante = "FC"

				Case tnComp = 2
					lcComprobante = "ND"

				Case tnComp = 3
					lcComprobante = "NC"

				Case tnComp = 4
					lcComprobante = "FC"

				Case tnComp = 5
					lcComprobante = "ND"

				Case tnComp = 6
					lcComprobante = "NC"

				Case tnComp = 7
					lcComprobante = "RC"

				Case tnComp = 8
					lcComprobante = "RC"

				Case tnComp = 9
					lcComprobante = "VTO "

				Case tnComp = 12
					lcComprobante = "AD"

				Case tnComp = 13
					lcComprobante = "AH"

				Case tnComp = 15
					lcComprobante = "AD"

				Case tnComp = 16
					lcComprobante = "AH"

				Case tnComp = 22
					lcComprobante = "DOT"

				Case tnComp = 25
					lcComprobante = "DOT"

				Case tnComp = 54
					lcComprobante = "FC"

				Case tnComp = 58
					lcComprobante = "RE"

				Case tnComp = 75
					lcComprobante = "FC"

				Otherwise
					lcComprobante = ""

			Endcase

		Endif

		If tcTipo = "T"
			lcComprobante = "TQT "

		Else
			If !Inlist( tnComp, 22, 25 )
				lcComprobante = lcComprobante + tcTipo + " "
			Endif


		Endif

		lcComprobante = lcComprobante + StrZero( tnSucu, 4 ) + "-" + StrZero( tnNume, 8 )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcComprobante

Endproc && Comprobante

*
* ,
Procedure TipoComprobante( tnComp As Integer ) As Void
	Local lcCommand As String
	Local lcComprobante As String

	Try

		lcCommand = ""
		lcComprobante = Space( 30 )

		Do Case
			Case tnComp = 1
				lcComprobante = Padr( "FACTURAS", 30, " " )

			Case tnComp = 2
				lcComprobante = Padr( "NOTAS DE DEBITO", 30, " " )

			Case tnComp = 3
				lcComprobante = Padr( "NOTAS DE CREDITO", 30, " " )

			Case tnComp = 11
				lcComprobante = Padr( "DESCUENTOS", 30, " " )

		Endcase

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcComprobante
Endproc && TipoComprobante



*
* Incrementa/decrementa el nivel de profundidad de la consulta DrillDown
Procedure AddDrillDownLevel( tnAddLevel As Integer ) As Void;
		HELPSTRING "Setea el nivel de profundidad de la consulta DrillDown"
	Try

		_Screen.oApp.nDrillDownLevel = _Screen.oApp.nDrillDownLevel + tnAddLevel


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && AddDrillDownLevel

*
* Setea el nivel de profundidad de la consulta DrillDown
Procedure SetDrillDownLevel( tnLevel As Integer ) As Void;
		HELPSTRING "Setea el nivel de profundidad de la consulta DrillDown"
	Try

		_Screen.oApp.nDrillDownLevel = tnLevel

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && SetDrillDownLevel


*
*
Procedure TransactionBegin(  ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""
		Begin Transaction


	Catch To oErr

	Finally

	Endtry

Endproc && TransactionBegin

*
*
Procedure TransactionEnd(  ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""
		If !Empty( Txnlevel() )
			End Transaction
		Endif

	Catch To oErr

	Finally

	Endtry

Endproc && TransactionEnd

*
*
Procedure TransactionRollBack( lCloseAll As Boolean ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""
		If !Empty( Txnlevel() )
			Rollback
		Endif

		If lCloseAll
			Do While !Empty( Txnlevel() )
				Rollback
			Enddo
		Endif


	Catch To oErr

	Finally

	Endtry

Endproc && TransactionRollBack

Procedure Cen()
Endproc
Procedure Uni()
Endproc
Procedure Dec()
Endproc

*
*
Procedure CotizacionDolar(  ) As Number

	*Return Cotizacion( DOLAR_ID )
	Return 1

Endproc && CotizacionDolar


*
*
Procedure F1_Folder(  ) As Void
	Local lcCommand As String

	Try


		lcCommand = ""

		* RA 05/07/2017(11:59:46)
		* pcFolder debe estar declarada como Private en el método que llama
		pcFolder = GetFolder( pcFolder )
		Keyboard '{ENTER}'

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && F1_Folder

*
* Devuelve un los mails guardados en un campo MEMO en un solo string separados por ";"
* Si por algun motivo el primer parametro viene vacio, y el segundo contiene datos, se toma éste último
Procedure eMails( cMails As String, cEMAI4 As String ) As String;
		HELPSTRING "Verifica si existe un campo MEMO con los mails"
	Local lcCommand As String,;
		lcMails As String

	Local i As Integer,;
		j As Integer,;
		lnLen As Integer

	Try

		lcCommand = ""
		If IsEmpty( cMails )
			cMails = Space( 10 )
		Endif

		If IsEmpty( cEMAI4 )
			cEMAI4 = Space( 10 )
		Endif

		lcMails = cEMAI4

		lnLen = Alines( laMails, cMails, 1 + 4 )
		If !Empty( lnLen )
			lcMails = ""
			For i = 1 To lnLen
				For j = 1 To Getwordcount( laMails[ i ], ";" )
					lcMails = lcMails + ";" + Getwordnum( laMails[ i ], j, ";" )
				Endfor
			Endfor

			lcMails = Substr( lcMails, 2 )

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lcMails

Endproc && eMails

*
*
Procedure SucursalEstadistica(  ) As Integer
	Local lcCommand As String
	Local lnSucEstadistica As Integer

	Try

		lcCommand = ""
		lnSucEstadistica = 0

		If Vartype( pnSUCE ) = "N"
			lnSucEstadistica = pnSUCE

		Else
			If FileExist( Trim(Drva)+"SUCESTADISTICA.dbf" )
				M_Use(0,Trim(Drva)+"SUCESTADISTICA.dbf")
				Select Desc From sucestadistica Into Array aSUCE
				lnSucEstadistica = S_Opcion( 15, 40,0,0,"aSUCE", 1 )

			Endif

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Use In Select( "SUCESTADISTICA" )

	Endtry

	Return lnSucEstadistica

Endproc && SucursalEstadistica
