#INCLUDE "Tools\ErrorHandler\Include\eh.h"
#Include "Tools\ErrorHandler\Include\errordesc.h"
#Include "Tools\ErrorHandler\Include\Foxpro.h"

#Define DEBUG_EXCEPTION Debugout Time(0), Program(), Time( 0 ), Program(), m.loErr.Message, m.loErr.Details, m.loErr.ErrorNo, m.loErr.LineContents, m.loErr.StackLevel, This.Class + '.' + m.loErr.Procedure, This.ClassLibrary, m.loErr.Lineno

**************************************************
*-- Class: ErrorForm (v:\sistemaspraxisv3\ErrorHandler\vcx\temp_form.vcx)
*-- ParentClass: form
*-- BaseClass: form
*-- Time Stamp: 03/28/10 07:10:07 PM
*
Define Class ErrorForm As Form

	#If .F.
		Local This As ErrorForm Of ErrorHandler\prg\ErrorForm.prg
	#Endif

	Height = 297
	Width = 673
	DoCreate = .T.
	Caption = 'Se ha producido un error ....'
	MaxButton = .T.

	* Protected oColError
	oColError = .Null.
	nIndex = 1
	cId = Sys ( 2015 )

	* Protected oError
	oError = .Null.
	*-- XML Metadata for customizable properties
	* Protected _MemberData
	_MemberData = [<VFPData>] ;
		+ [<memberdata name='oerror' type='property' display='oError'/>] ;
		+ [</VFPData>]

	Name = 'ErrorForm'

	Add Object txaContenido As EditBox With ;
		FontSize = 9, ;
		Anchor = 15, ;
		Height = 176, ;
		Left = 12, ;
		ReadOnly = .T., ;
		TabIndex = 4, ;
		Top = 84, ;
		Width = 652, ;
		DisabledBackColor = Rgb(255, 255, 255), ;
		DisabledForeColor = Rgb(0, 0, 0), ;
		Name = 'txaContenido', ;
		FontName = 'Lucida Console'

	Add Object cmderrordescript As CommandButtonBase  With ;
		Top = 264, ;
		Left = 252, ;
		Height = 27, ;
		Width = 84, ;
		Anchor = 12, ;
		Caption = '\<Descripción', ;
		TabIndex = 7, ;
		SpecialEffect = 2, ;
		Name = 'cmdErrorDescript'

	Add Object cmdstack As CommandButtonBase  With ;
		Top = 264, ;
		Left = 336, ;
		Height = 27, ;
		Width = 84, ;
		Anchor = 12, ;
		Caption = 'Stac\<k', ;
		TabIndex = 8, ;
		SpecialEffect = 2, ;
		Name = 'cmdStack'

	Add Object cmdtables As CommandButtonBase  With ;
		Top = 264, ;
		Left = 420, ;
		Height = 27, ;
		Width = 84, ;
		Anchor = 12, ;
		Caption = '\<Tablas', ;
		TabIndex = 9, ;
		SpecialEffect = 2, ;
		Name = 'cmdTables'

	Add Object cmdsysinfo As CommandButtonBase  With ;
		Top = 264, ;
		Left = 504, ;
		Height = 27, ;
		Width = 84, ;
		Anchor = 12, ;
		Caption = '\<Sistema', ;
		TabIndex = 10, ;
		SpecialEffect = 2, ;
		Name = 'cmdSysInfo'

	Add Object imgIcon As Image With ;
		BackStyle = 0, ;
		Height = 32, ;
		Left = 20, ;
		Top = 13, ;
		Width = 32, ;
		Name = 'imgIcon'

	Add Object lblerrornoShadow As LabelBase With ;
		AutoSize = .T., ;
		FontBold = .T., ;
		FontSize = 24, ;
		Caption = 'Error N° 1234', ;
		Height = 39, ;
		Left = 69, ;
		Top = 8, ;
		Width = 197, ;
		ForeColor = Rgb ( 33, 33, 33), ;
		Name = 'lblerrornoShadow'

	Add Object lblerrorno As LabelBase With ;
		BackStyle = 0, ;
		AutoSize = .T., ;
		FontBold = .T., ;
		FontSize = 24, ;
		Caption = 'Error N° 1234', ;
		Height = 39, ;
		Left = 69, ;
		Top = 8, ;
		Width = 197, ;
		ForeColor = Rgb(0, 128, 0), ;
		Name = 'LblErrorNo'

	Add Object cmdCerrar As CommandButtonBase  With ;
		Top = 264, ;
		Left = 12, ;
		Height = 27, ;
		Width = 84, ;
		FontBold = .T., ;
		Anchor = 6, ;
		Cancel = .T., ;
		Caption = '\<Cerrar', ;
		TabIndex = 5, ;
		SpecialEffect = 2, ;
		ForeColor = Rgb(0, 0, 160), ;
		Name = 'cmdCerrar'

	Add Object lblCopiarTexto As LabelBase With ;
		AutoSize = .T., ;
		FontBold = .T., ;
		Anchor = 3, ;
		Caption = 'Copiar texto', ;
		Height = 17, ;
		Left = 12, ;
		Top = 60, ;
		Width = 71, ;
		TabIndex = 2, ;
		ForeColor = Rgb(0, 0, 128), ;
		Name = 'lblCopiarTexto'

	Add Object lblCopiarTodo As LabelBase With ;
		AutoSize = .T., ;
		FontBold = .T., ;
		Anchor = 9, ;
		Caption = 'Copiar todo', ;
		Height = 17, ;
		Left = 597, ;
		Top = 62, ;
		Width = 67, ;
		TabIndex = 3, ;
		ForeColor = Rgb(0, 0, 128), ;
		Name = 'lblCopiarTodo'

	Add Object cmdCancelar As CommandButtonBase  With ;
		Top = 264, ;
		Left = 97, ;
		Height = 27, ;
		Width = 84, ;
		FontBold = .T., ;
		Anchor = 6, ;
		Cancel = .T., ;
		Caption = 'Cancelar', ;
		TabIndex = 6, ;
		ToolTipText = 'Ejecuta el comando cancelar', ;
		SpecialEffect = 2, ;
		ForeColor = Rgb(255, 0, 0), ;
		Name = 'cmdCancelar'

	Add Object cmdVerDataEnv As CommandButtonBase  With ;
		Top = 264, ;
		Left = 186, ;
		Height = 27, ;
		Width = 50, ;
		Anchor = 6, ;
		Cancel = .T., ;
		Caption = '', ;
		TabIndex = 6, ;
		ToolTipText = 'Ver entorno de datos', ;
		SpecialEffect = 2, ;
		ForeColor = Rgb(255, 0, 0), ;
		Name = 'cmdVerDataEnv'
	* Picture = Locfile ('dataenvironment', 'bmp')

	Add Object cmdanterior As CommandButtonBase  With ;
		Top = 264, ;
		Left = 588, ;
		Height = 27, ;
		Width = 36, ;
		Anchor = 12, ;
		Caption = '<', ;
		Enabled = .F., ;
		TabIndex = 10, ;
		SpecialEffect = 2, ;
		Name = 'cmdAnterior'

	Add Object cmdsiguiente As CommandButtonBase  With ;
		Top = 264, ;
		Left = 624, ;
		Height = 27, ;
		Width = 36, ;
		Anchor = 12, ;
		Caption = '>', ;
		Enabled = .F., ;
		TabIndex = 10, ;
		SpecialEffect = 2, ;
		Name = 'cmdSiguiente'

	* RedirectOutput
	* Redirecciona la salida a la ventana de fox.
	Procedure RedirectOutput() As VOID HelpString 'Redirecciona la salida a la ventana de fox.'
		Woutput( _vfp.Name )
		Woutput( _Screen.Name )
		This.Cls()

	Endproc

	* Activate
	Procedure Activate() As VOID
		Thisform.RedirectOutput()

	Endproc

	* Deactivate
	Procedure Deactivate() As VOID
		Thisform.RedirectOutput()

	Endproc

	* ShowDescrip
	Procedure ShowDescrip() As VOID
		Local loErr As Exception
		Try
			This.txaContenido.Value = Thisform.oError.cErrorDescrip

			Thisform.RedirectOutput()

		Catch To loErr
			DEBUG_EXCEPTION

		Endtry

	Endproc

	* ShowStack
	Procedure ShowStack() As VOID

		Local loErr As Exception
		Try
			This.txaContenido.Value = Thisform.oError.cStack

			Thisform.RedirectOutput()

		Catch To loErr
			DEBUG_EXCEPTION

		Endtry

	Endproc


	* ShowTables
	Procedure ShowTables() As VOID

		Local loErr As Exception
		Try
			This.txaContenido.Value = Thisform.oError.cTables

			Thisform.RedirectOutput()

		Catch To loErr
			DEBUG_EXCEPTION

		Endtry

	Endproc

	* ShowSysInfo
	Procedure ShowSysInfo() As VOID

		Local loErr As Exception
		Try
			This.txaContenido.Value = Thisform.oError.cSysInfo

			Thisform.RedirectOutput()

		Catch To loErr
			DEBUG_EXCEPTION

		Endtry

	Endproc

	* AddError
	Procedure AddError ( toError As Object ) As VOID

		With This As ErrorForm Of ErrorHandler\prg\ErrorForm.prg
			If Vartype ( m.toError ) = 'O'
				.oColError.Add ( m.toError )
				.cmdanterior.Enabled = ( .nIndex > 1 )
				.cmdsiguiente.Enabled = ( .oColError.Count > 1 ) And ( .nIndex < .oColError.Count )
				.SetCaption()
				.Refresh()

			Endif

		Endwith

		Thisform.RedirectOutput()

	Endproc

	* oColError_Access
	Procedure oColError_Access

		If Vartype ( This.oColError ) # 'O'
			This.oColError = Createobject ( 'Collection' )

		Endif

		Return This.oColError

	Endproc

	* SetupError
	Procedure SetupError() As VOID
		Local loErr As Exception
		If Empty ( Atc ( 'ErrorHandler\Image\Ico', Set ('Path') ) )
			Set Path To 'ErrorHandler\Image\Ico' Additive

		Endif

		Try
			With This As ErrorForm Of ErrorHandler\prg\ErrorForm.prg
				.lblerrorno.Caption = 'Error N° ' + Transform ( .oError.ErrorNo )
				.lblerrornoShadow.Caption = .lblerrorno.Caption
				.lblerrornoShadow.Move ( .lblerrorno.Left + 1, .lblerrorno.Top + 1 )
				Do Case
					Case .oError.nErrorType == MB_ICONSTOP
						* .lblerrorno.Caption = 'Error N° ' + Transform( .oError.ErrorNo )
						.lblerrorno.ForeColor = Rgb ( 255, 0, 0 )
						.imgIcon.Picture = 'Stop.ico'

					Case .oError.nErrorType == MB_ICONEXCLAMATION
						* .lblerrorno.Caption = 'Error N° ' + Transform( .oError.ErrorNo )
						.lblerrorno.ForeColor = Rgb ( 255, 255, 000 )
						Thisform.imgIcon.Picture = 'Alert.ico'

					Case .oError.nErrorType == MB_ICONINFORMATION
						* .lblerrorno.Caption = 'Error N° ' + Transform( .oError.ErrorNo )
						.lblerrorno.ForeColor = Rgb ( 0, 0, 255  )
						.imgIcon.Picture = 'Informe.ico'

					Case .oError.nErrorType == MB_ICONQUESTION
						* .lblerrorno.Caption = 'Error N° ' + Transform( .oError.ErrorNo )
						.lblerrorno.ForeColor = Rgb ( 0, 0, 255 )
						.imgIcon.Picture = 'Quest.ico'

					Otherwise

						* .lblerrorno.Caption = 'Error N° ' + Transform( .oError.ErrorNo )
						.imgIcon.Picture = 'Alert.ico'

				Endcase

			Endwith

		Catch To loErr
			DEBUG_EXCEPTION

		Endtry

		This.SetCaption()

	Endproc

	* SetCaption
	Procedure SetCaption() As VOID
		Local loErr As Exception
		Try

			This.Caption = 'Se ha producido un error ....'
			If Thisform.oColError.Count > 1
				This.Caption = This.Caption + ' ( Error: ' + Transform ( This.nIndex ) + ' de ' + Transform ( Thisform.oColError.Count ) + ' )'

			Endif

			Thisform.RedirectOutput()

		Catch To loErr
			DEBUG_EXCEPTION

		Endtry

	Endproc

	* Release
	Procedure Release() As VOID

		Thisform.oColError.Remove ( -1 )
		Thisform.oColError = Null
		Thisform.oError = Null

		DoDefault()

	Endproc

	* Destroy
	Procedure Destroy()
		Local loErrorForm As Object
		m.loErrorForm = m.CacheManager.Get ( 'oErrorForm' )
		If ! Isnull ( m.loErrorForm ) And Vartype ( m.loErrorForm ) == 'O' And Pemstatus ( m.loErrorForm, 'cId', 5 ) And m.loErrorForm.cId == Thisform.cId
			m.CacheManager.Remove ( 'oErrorForm' )

		Endif

	Endproc

	* Init
	Procedure Init ( toError As Exception ) As VOID
		Local llRet As Boolean, ;
			loErr As Exception, ;
			loErrorForm As Form

		Try

			m.lcFile = Addbs ( Sys ( 2023 ) ) + 'dataenvironment.bmp'
			If ! File( m.lcFile )
				* dataenvironment.bmp
				TEXT to lcFileEnc NOSHOW PRETEXT 15
					Qk32AAAAAAAAAHYAAAAoAAAAEAAAABAAAAABAAQ
					AAAAAAIAAAAASCwAAEgsAAAAAAAAAAAAAAAAAAA
					AAgAAAgAAAAICAAIAAAACAAIAAgIAAAICAgADAw
					MAAAAD/AAD/AAAA//8A/wAAAP8A/wD//wAA////
					AP//////////////////8AD//wAAAAAA8P//D//
					///D0//8P////9ET//wAAAAD/////D///8PAAAA
					AAAADwAPQP7+/v4P/09A4A/v7w//RED+/v7+D//
					/8OAPAA8P///w/v4ODg////DgDwAPD///8P7+/v
					4P///wAAAAAA////
				ENDTEXT

				Strtofile( Strconv( m.lcFileEnc, 14 ), m.lcFile, 0 )

			Endif && ! File( m.lcFile )
			This.cmdVerDataEnv.Picture = m.lcFile

			m.loErrorForm = m.CacheManager.Get ( 'oErrorForm' )

			If ! Isnull ( m.loErrorForm )
				m.loErrorForm.AddError ( m.toError )
				m.loErrorForm.Show ( )
				Thisform.Visible = .F.
				Thisform.Release()

			Else

				Thisform.oError = m.toError
				Thisform.oColError.Add ( m.toError )
				This.nIndex = 1

				Thisform.cmdCancelar.Enabled = ! m.Logical.IsRunTime()
				Thisform.cmdCancelar.Visible = 	Thisform.cmdCancelar.Enabled

				Thisform.cmdVerDataEnv.Enabled = ! m.Logical.IsRunTime()
				Thisform.cmdVerDataEnv.Visible = 	Thisform.cmdVerDataEnv.Enabled

				This.SetupError()
				This.ShowDescrip()

				m.llRet = .T.

			Endif

		Catch To loErr
			DEBUG_EXCEPTION

		Endtry
		Return m.llRet

	Endproc

	Procedure Load()
		If Vartype( m.CacheManager ) # "O"
			Do LoadNamespace In Tools\Namespaces\prg\LoadNamespace.prg
		Endif
	Endproc

	* txaContenido.RightClick
	Procedure txaContenido.RightClick

		Local lnRet As Number
		m.lnRet = m.Control.xMenu ( 'Copiar texto;Copiar todo' )
		Do Case
			Case m.lnRet = 1
				Raiseevent ( This.Parent.lblCopiarTexto, 'Click' )

			Case m.lnRet = 2
				Raiseevent ( This.Parent.lblCopiarTodo, 'Click' )

			Otherwise

		Endcase

	Endproc

	* cmderrordescript.Click
	Procedure cmderrordescript.Click
		Thisform.ShowDescrip()

	Endproc

	* cmdstack.Click
	Procedure cmdstack.Click
		Thisform.ShowStack()

	Endproc

	* cmdtables.Click
	Procedure cmdtables.Click
		Thisform.ShowTables()

	Endproc

	* cmdsysinfo.Click
	Procedure cmdsysinfo.Click
		Thisform.ShowSysInfo()

	Endproc

	* cmdCerrar.Click
	Procedure cmdCerrar.Click
		Thisform.Release()

	Endproc

	* lblCopiarTexto.Click
	Procedure lblCopiarTexto.Click

		Thisform.txaContenido.SelStart = 0
		Thisform.txaContenido.SelLength = Len ( Thisform.txaContenido.Value )
		_Cliptext = Thisform.txaContenido.Value

	Endproc

	* lblCopiarTodo.Click
	Procedure lblCopiarTodo.Click

		*!*			Thisform.txaContenido.Value = Thisform.oError.cErrorDescrip + Chr( 13 ) + ;
		*!*				Thisform.oError.cStack + Chr( 13 ) + ;
		*!*				Thisform.oError.cTables + Chr( 13 ) + ;
		*!*				Thisform.oError.cSysInfo
		Local lcOld As String
		TEXT To m.lcOld Textmerge Noshow
<<Thisform.oError.cErrorDescrip>>
<<Thisform.oError.cStack>>
<<Thisform.oError.cTables>>
<<Thisform.oError.cSysInfo>>

		ENDTEXT

		* Thisform.txaContenido.SelStart = 0
		* Thisform.txaContenido.SelLength = Len( Thisform.txaContenido.Value )

		* _Cliptext = Thisform.txaContenido.Value
		_Cliptext = m.lcOld

	Endproc

	* cmdCancelar.Click
	Procedure cmdCancelar.Click

		If Messagebox ( '¿Desea cancelar la ejecución del programa?', 36) = 6
			Thisform.Hide()
			Thisform.Release()
			Cancel

		Endif

	Endproc

	* cmdVerDataEnv.Click
	Procedure cmdVerDataEnv.Click
		Try
			Thisform.Top = 0
			Thisform.Left = 0
			Set

		Catch
		Endtry

	Endproc

	* cmdanterior.Click
	Procedure cmdanterior.Click

		Thisform.nIndex = Thisform.nIndex - 1

		If Thisform.nIndex <= 1
			Thisform.nIndex = 1
			This.Enabled = .F.

		Endif

		If Thisform.oColError.Count > 1
			Thisform.cmdsiguiente.Enabled = .T.

		Endif

		Thisform.oError = Thisform.oColError.Item ( Thisform.nIndex )
		Thisform.SetupError()
		Thisform.ShowDescrip()

	Endproc

	* cmdsiguiente.Click
	Procedure cmdsiguiente.Click

		Thisform.nIndex = Thisform.nIndex + 1

		If Thisform.nIndex >= Thisform.oColError.Count
			Thisform.nIndex = Thisform.oColError.Count
			This.Enabled = .F.

		Endif

		If Thisform.oColError.Count > 1
			Thisform.cmdanterior.Enabled = .T.

		Endif

		Thisform.oError = Thisform.oColError.Item ( Thisform.nIndex )
		Thisform.SetupError()
		Thisform.ShowDescrip()

	Endproc

Enddefine && ErrorForm

* CommandButtonBase
Define Class CommandButtonBase As CommandButton

	Name = 'CommandButtonBase'

	Procedure MouseEnter ( nButton, nShift, nXCoord, nYCoord )
		This.MousePointer = 15

	Endproc && MouseEnter

	Procedure MouseLeave ( nButton, nShift, nXCoord, nYCoord )
		This.MousePointer = 0

	Endproc && MouseLeave

Enddefine && CommandButtonBase

* CommandButtonBase
Define Class LabelBase As Label

	Name = 'LabelBase'

	Procedure MouseEnter ( nButton, nShift, nXCoord, nYCoord )
		This.MousePointer = 15
		This.FontUnderline = .T.

	Endproc && MouseEnter

	Procedure MouseLeave ( nButton, nShift, nXCoord, nYCoord )
		This.MousePointer = 0
		This.FontUnderline = .F.

	Endproc && MouseLeave

Enddefine && CommandButtonBase


