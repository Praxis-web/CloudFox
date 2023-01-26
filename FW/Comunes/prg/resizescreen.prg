#INCLUDE "FW\Comunes\Include\Praxis.h"

Lparameters tnRows As Integer, tnCols As Integer, oParam As Object

Local loForm As frmdisplaywindow Of "v:\clipper2fox\rutinas\vcx\clipper2fox.vcx",;
	loFont As Object

Local i As Integer,;
	lnTop As Integer,;
	lnGap As Integer

Local lcLabel23 As String,;
	lcLabel24 As String,;
	lclblFecha As String,;
	lclblTitulo As String,;
	lcLabel1 As String,;
	lcLblObservaciones As String,;
	lcLblNavegar As String

Try


	If Vartype( oParam ) # "O"
		oParam = Createobject( "Empty" )
	EndIf
	
	If Pemstatus( oParam, "oActiveForm", 5 ) And !IsNull( oParam.oActiveForm )
		loForm = oParam.oActiveForm
		
	Else 
		loForm = GetActiveForm()
		
	Endif


	If !Isnull( loForm ) And Pemstatus( loForm, "nRows", 5 )

		If !Pemstatus( oParam, "lMultiplesPantallas", 5 )
			AddProperty( oParam, "lMultiplesPantallas", .F. )
		Endif

		loForm.nRows = tnRows
		loForm.nCols = tnCols

		*!*			loForm.AutoSize()

		lnGap = 02

		If Pemstatus( _Screen, "oApp", 5 )
			If Pemstatus( _Screen.oApp, "oColFonts", 5 )
				loFont = _Screen.oApp.oColFonts.Item( "screen" )

				loForm.FontName = loFont.FontName
				loForm.FontSize = loFont.FontSize

			Else
				loForm.FontName = oApp.FontName
				loForm.FontSize = oApp.FontSize

			Endif

		Endif

		loForm.Width = loForm.TextWidth( Replicate( "X", loForm.nCols ))
		loForm.Height = loForm.TextHeight( "X" ) * loForm.nRows

		If _Screen.oApp.lFitToForm
			loForm.AutoCenter 	= .F.
			loForm.Left 		= 0
			loForm.Top 			= 0
			loForm.TitleBar 	= 0

			_Screen.Width 	= loForm.Width
			_Screen.Height 	= loForm.Height

		Else
			loForm.AutoCenter = .T.

			* Verificar que se encuentra dentro de _Screen
			If loForm.Left + loForm.Width > _Screen.Width
				loForm.Left = _Screen.Width - loForm.Width
			Endif

			If loForm.Left < 0
				loForm.Left = 0
				_Screen.Width = loForm.Width
			Endif

			If loForm.Top + loForm.Height + WINDOWTITLEHEIGHT > _Screen.Height
				loForm.Top = _Screen.Height - loForm.Height - WINDOWTITLEHEIGHT
			Endif

			If loForm.Top < 0
				loForm.Top = 0
				_Screen.Height = loForm.Height + WINDOWTITLEHEIGHT
			Endif


		Endif

		loForm.cntMessages.Label23.FontSize 	= loForm.FontSize
		loForm.cntMessages.Label24.FontSize 	= loForm.FontSize
		loForm.cntTitulo.lblFecha.FontSize 		= loForm.FontSize
		loForm.cntTitulo.lblTitulo.FontSize 	= loForm.FontSize
		loForm.cntTitulo.Label1.FontSize 		= loForm.FontSize
		loForm.cntTitulo.LblObservaciones.FontSize 	= loForm.FontSize

		loForm.cntMessages.Label23.Height 	= Int( loForm.TextHeight( "[Xp]" ) * 1.25 )
		loForm.cntMessages.Label24.Height 	= Int( loForm.TextHeight( "[Xp]" ) * 1.25 )
		loForm.cntTitulo.lblFecha.Height 	= Int( loForm.TextHeight( "[Xp]" ) * 1.15 )
		loForm.cntTitulo.lblTitulo.Height 	= Int( loForm.TextHeight( "[Xp]" ) * 1.15 )
		loForm.cntTitulo.Label1.Height 		= Int( loForm.TextHeight( "[Xp]" ) * 1.15 )
		loForm.cntTitulo.LblObservaciones.Height = Int( loForm.TextHeight( "[Xp]" ) * 1.15 )

		loForm.cntMessages.Height 	= ( lnGap * 3 ) + loForm.cntMessages.Label23.Height + loForm.cntMessages.Label24.Height
		loForm.cntTitulo.Height 	= loForm.cntTitulo.lblFecha.Height + 06

		loForm.cntMessages.Label23.Top = lnGap
		loForm.cntMessages.Label24.Top = loForm.cntMessages.Label23.Top + loForm.cntMessages.Label23.Height + lnGap

		loForm.cntMessages.Top	= loForm.Height - loForm.cntMessages.Height - 02
		loForm.cntTitulo.Top 	= 0

		loForm.cntMessages.Width 			= loForm.Width - 10
		loForm.cntMessages.Label23.Width 	= loForm.Width
		loForm.cntMessages.Label24.Width 	= loForm.Width

		loForm.cntTitulo.Width = loForm.Width

		loForm.cntMessages.Label23.Left = 0
		loForm.cntMessages.Label24.Left = 0
		loForm.cntTitulo.Left 			= 0
		loForm.cntMessages.Left 		= 05


		lcLabel23 			= loForm.cntMessages.Label23.Caption
		lcLabel24 			= loForm.cntMessages.Label24.Caption
		lclblFecha 			= loForm.cntTitulo.lblFecha.Caption
		lclblTitulo 		= loForm.cntTitulo.lblTitulo.Caption
		lcLabel1 			= loForm.cntTitulo.Label1.Caption
		lcLblObservaciones	= loForm.cntTitulo.LblObservaciones.Caption

		loForm.cntMessages.Label23.Caption 			= ""
		loForm.cntMessages.Label24.Caption 			= ""
		loForm.cntTitulo.lblFecha.Caption 			= ""
		loForm.cntTitulo.lblTitulo.Caption 			= ""
		loForm.cntTitulo.Label1.Caption 			= ""
		loForm.cntTitulo.LblObservaciones.Caption 	= ""

		loForm.cntTitulo.lblFecha.AutoSize 	= .T.
		loForm.cntTitulo.lblTitulo.AutoSize = .T.
		loForm.cntTitulo.Label1.AutoSize 	= .T.
		loForm.cntTitulo.LblObservaciones.AutoSize 	= .T.

		loForm.cntMessages.Label23.Caption 			= lcLabel23
		loForm.cntMessages.Label24.Caption 			= lcLabel24
		loForm.cntTitulo.lblFecha.Caption 			= lclblFecha
		loForm.cntTitulo.lblTitulo.Caption 			= lclblTitulo
		loForm.cntTitulo.Label1.Caption 			= lcLabel1
		loForm.cntTitulo.LblObservaciones.Caption 	= lcLblObservaciones

		loForm.cntTitulo.Label1.Left 			= 0
		loForm.cntTitulo.lblTitulo.Left 		= loForm.cntTitulo.Label1.Width
		loForm.cntTitulo.LblObservaciones.Left 	= loForm.cntTitulo.lblTitulo.Left + loForm.cntTitulo.lblTitulo.Width + 10
		loForm.cntTitulo.lblFecha.Left 			= loForm.Width - loForm.cntTitulo.lblFecha.Width - 05

		If oParam.lMultiplesPantallas
			loForm.cntMessages.lblNavegar.FontSize 	= loForm.FontSize
			loForm.cntMessages.lblNavegar.Height 	= Int( loForm.TextHeight( "[Xp]" ) * 1.25 )
			loForm.cntMessages.lblNavegar.Top 		= loForm.cntMessages.Label24.Top + loForm.cntMessages.Label24.Height + lnGap

			lcLblNavegar = loForm.cntMessages.lblNavegar.Caption
			loForm.cntMessages.lblNavegar.Caption = ""
			loForm.cntMessages.lblNavegar.Caption = lcLblNavegar

			loForm.cntMessages.Height 	= loForm.cntMessages.Height + lnGap + loForm.cntMessages.lblNavegar.Height
			loForm.cntMessages.Top 		= loForm.cntMessages.Top - lnGap - loForm.cntMessages.lblNavegar.Height

		Endif

		loForm.Refresh()

		* RA 07/06/2017(19:22:10)
		* Si no hago esto, que en realidad no se ve porque las coordenadas
		* estan ocultas por el titulo, no reconocia los cambios cuando se
		* redimensionaba la pantalla en el transcurso del mismo proceso
		Local i As Integer
		i = 0
		Keyboard '{ENTER}'
		@ 00, 00 Get i Picture "9"
		Read


	Endif

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loFont = Null
	loForm = Null

Endtry