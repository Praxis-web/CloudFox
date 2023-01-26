#INCLUDE "FW\Comunes\Include\Praxis.h"


*
* Mensaje en pantalla
* Equivalente a Wait Window Nowait Noclear pero personalizable
Procedure Mensaje( cMensaje As String, cTitle As String, cWindowsName As String, oParam As Object ) As Void;
		HELPSTRING "Mensaje en pantalla"
	Local lcCommand As String
	Local loMensaje As oMensaje Of "FW\Comunes\prg\Mensaje.prg"

	Try

		lcCommand = ""
		loMensaje = Newobject( "oMensaje", "FW\Comunes\prg\Mensaje.prg" )
		loMensaje.Process( cMensaje, cTitle, cWindowsName, oParam )


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loMensaje = Null

	Endtry

Endproc && Mensaje

*!* ///////////////////////////////////////////////////////
*!* Class.........: oMensaje
*!* Description...:
*!* Date..........: Viernes 4 de Enero de 2019 (06:58:28)
*!*
*!*

Define Class oMensaje As CustomBase Of Tools\namespaces\prg\CustomBase.prg

	#If .F.
		Local This As oMensaje Of "FW\Comunes\prg\Mensaje.prg"
	#Endif

	* Mensaje a mostrar o Comando a Ejecutar
	cMensaje = ""

	* Nombre de la Venta
	cWindowsName = ""

	* Parametrizacion
	oParam = Null

	nTop 	= 0
	nLeft 	= 0
	nBottom = 0
	nRight 	= 0
	nHeight = 0
	nWidth 	= 0

	cFontName 		= "Lucida Console"
	nFontSize 		= 10
	nFontCharSet 	= 0
	cFontStyle 		= ""
	cTitleText 		= ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="nright" type="property" display="nRight" />] + ;
		[<memberdata name="nbottom" type="property" display="nBottom" />] + ;
		[<memberdata name="nleft" type="property" display="nLeft" />] + ;
		[<memberdata name="ntop" type="property" display="nTop" />] + ;
		[<memberdata name="nwidth" type="property" display="nWidth" />] + ;
		[<memberdata name="nheight" type="property" display="nHeight" />] + ;
		[<memberdata name="cfontstyle" type="property" display="cFontStyle" />] + ;
		[<memberdata name="nfontcharset" type="property" display="nFontCharSet" />] + ;
		[<memberdata name="nfontsize" type="property" display="nFontSize" />] + ;
		[<memberdata name="cfontname" type="property" display="cFontName" />] + ;
		[<memberdata name="ctitletext" type="property" display="cTitleText" />] + ;
		[<memberdata name="cmensaje" type="property" display="cMensaje" />] + ;
		[<memberdata name="oparam" type="property" display="oParam" />] + ;
		[<memberdata name="cwindowsname" type="property" display="cWindowsName" />] + ;
		[<memberdata name="process" type="method" display="Process" />] + ;
		[<memberdata name="populateproperties" type="method" display="PopulateProperties" />] + ;
		[<memberdata name="definewindow" type="method" display="DefineWindow" />] + ;
		[<memberdata name="activate" type="method" display="Activate" />] + ;
		[<memberdata name="show" type="method" display="Show" />] + ;
		[<memberdata name="deactivate" type="method" display="Deactivate" />] + ;
		[<memberdata name="hide" type="method" display="Hide" />] + ;
		[<memberdata name="clear" type="method" display="Clear" />] + ;
		[<memberdata name="release" type="method" display="Release" />] + ;
		[</VFPData>]

	*
	*
	Procedure Process( cMensaje As String, cTitle As String, cWindowsName As String, oParam As Object ) As Void
		Local lcCommand As String,;
			lcMensaje As String

		Try

			lcCommand = ""
			lcMensaje = Alltrim( Upper( cMensaje ))

			If !Empty( cMensaje )
				This.cMensaje = cMensaje
			Endif

			If !Empty( cTitle )
				This.cTitleText = cTitle 
			Endif

			If !Empty( cWindowsName )
				This.cWindowsName = cWindowsName

			Else
				This.cWindowsName = "wMensaje"

			Endif

			Do Case
				Case lcMensaje == "ACTIVATE"
					This.Activate()

				Case lcMensaje == "SHOW"
					This.Show()

				Case lcMensaje == "DEACTIVATE"
					This.Deactivate()

				Case lcMensaje == "HIDE"
					This.Hide()

				Case lcMensaje == "CLEAR"
					This.Clear()

				Case lcMensaje == "RELEASE"
					This.Release()
				
				Case lcMensaje == "TEST"	
					Inform( Program() )
					
				Otherwise
					This.Initialize()
					If !IsEmpty( oParam )
						This.oParam = oParam
					Endif
					This.PopulateProperties( This.oParam )
					
					This.DefineWindow()
					*This.Activate()
					This.Show()

			Endcase

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Process


	*
	* Default Values
	Procedure Initialize(  ) As Void
		Local lcCommand As String,;
			lcMensaje As String

		Local Array laLines[ 1 ]

		Local lnLen As Integer,;
			i As Integer,;
			lnMaxLen As Integer

		Try

			lcCommand = ""
			lcMensaje = This.cMensaje

			lnLen = Alines( laLines, lcMensaje, 1+2 )
			lnMaxLen = 0
			For i = 1 To lnLen
				lnMaxLen = Max( lnMaxLen, Len( laLines[ i ] ))
			Endfor

			This.nTop 		= 1 && _Screen.TextHeight( "X" ) * 2
			*This.nLeft 		= Int( _Screen.Width / _Screen.TextWidth( "X" ) ) - ( lnMaxLen + 10 )
			This.nLeft 		= Wcols( "" ) - ( lnMaxLen + 10 )
			This.nHeight 	= lnLen + 2
			This.nWidth 	= lnMaxLen + 5
			
*!*				Text To lcMsg NoShow TextMerge Pretext 03
*!*				Int( _Screen.Width / _Screen.TextWidth( "X" ) ): <<Int( _Screen.Width / _Screen.TextWidth( "X" ) )>>
*!*				Wcols(): <<Wcols()>>
*!*				Wcols(""): <<Wcols("")>>
*!*				--------------------------------------------
*!*				
*!*				
*!*				EndText
*!*				
*!*				StrToFile( lcMsg, "Mensaje.txt", 1 )

		

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Initialize


	*
	*
	Procedure PopulateProperties( oParam As Object ) As Void
		Local lcCommand As String
		Local laMembers[ 1 ] As String
		Local lcProperty As String

		Try

			lcCommand = ""
			If Vartype( oParam ) == "O"
				Amembers( laMembers, oParam )
				For Each lcProperty In laMembers
					Try
						This.&lcProperty = oParam.&lcProperty
					Catch To oErr
						* No hago nada
					Finally
					Endtry
				Endfor
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && PopulateProperties



	*
	*
	Procedure DefineWindow(  ) As Void
		Local lcCommand As String,;
		lcTitle as String 
		Local loEditBox As oEditBox Of "FW\Comunes\prg\Mensaje.prg",;
			loForm As Form

		Try

			lcCommand = ""
			
			lcTitle  = ""
			
*!*				Inform( Woutput() )
*!*				
*!*				Text To lcMsg NoShow TextMerge Pretext 03
*!*				Woutput(): '<<Woutput()>>'
*!*				Wchild(): '<<Wchild()>>'
*!*				Wparent(): '<<Wparent()>>'
*!*				Wontop(): '<<Wontop()>>'
*!*				EndText

*!*				Inform( lcMsg )
*!*				StrToFile( lcMsg, "Windows.txt" )

			
			This.Release()

			If !Empty( This.cTitleText )
				Text To lcTitle NoShow TextMerge Pretext 15  
				Title '<<This.cTitleText>>'				
				EndText
			EndIf

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Define Window <<This.cWindowsName>>
				At <<This.nTop>>, <<This.nLeft>>
				Size <<This.nHeight>>, <<This.nWidth>>
				Font '<<This.cFontName>>', <<This.nFontSize>>
				<<lcTitle>>
				Name lo<<This.cWindowsName>>
			EndText
			
			&lcCommand
			lcCommand = ""

			TEXT To lcCommand NoShow TextMerge Pretext 15
			loForm = lo<<This.cWindowsName>>
			ENDTEXT

			&lcCommand
			lcCommand = ""

			loForm.BorderStyle = 0
			loForm.AddObject( "EditBox", "oEditBox" )

			loEditBox = loForm.EditBox

			loForm.EditBox.Top 		= 0
			loForm.EditBox.Left 	= 0
			loForm.EditBox.Height 	= loForm.Height
			loForm.EditBox.Width 	= loForm.Width
			loForm.EditBox.Value 	= This.cMensaje 

			loForm.EditBox.FontName 	= loForm.FontName
			loForm.EditBox.FontSize 	= loForm.FontSize
			loForm.EditBox.ScrollBars 	= 0
			loForm.EditBox.Margin 		= 10
			loForm.EditBox.Anchor 		= 15

			loForm.EditBox.Visible 	= .T.


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loEditBox 	= Null
			loForm 		= Null

		Endtry

	Endproc && DefineWindow



	*
	*
	Procedure Activate(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			
			Text To lcCommand NoShow TextMerge Pretext 15
			Activate Window <<This.cWindowsName>> Top
			EndText

			&lcCommand
			lcCommand = ""
			
			Activate Window 'DISPLAYWINDOW' Same


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Activate


	*
	*
	Procedure Show(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			
			Text To lcCommand NoShow TextMerge Pretext 15
			Show Window <<This.cWindowsName>>
			EndText

			&lcCommand
			lcCommand = ""
			
			Activate Window 'DISPLAYWINDOW' Same


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Show



	*
	*
	Procedure Deactivate(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			
			Text To lcCommand NoShow TextMerge Pretext 15
			Deactivate Window <<This.cWindowsName>>			
			EndText

			&lcCommand
			lcCommand = ""
			
			Activate Window 'DISPLAYWINDOW'



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Deactivate





	*
	*
	Procedure Hide(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			
			Text To lcCommand NoShow TextMerge Pretext 15
			Hide Window <<This.cWindowsName>>			
			EndText

			&lcCommand
			lcCommand = ""
			
			Activate Window 'DISPLAYWINDOW'



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Hide


	*
	*
	Procedure Clear(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			
			Clear Windows  
			
			Activate Window 'DISPLAYWINDOW'

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Clear



	*
	*
	Procedure Release(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			
			Text To lcCommand NoShow TextMerge Pretext 15
			Release Windows <<This.cWindowsName>>
			EndText

			&lcCommand
			lcCommand = ""
			
			Activate Window 'DISPLAYWINDOW'


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Release



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oMensaje
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oEditBox
*!* Description...:
*!* Date..........: Viernes 4 de Enero de 2019 (08:44:36)
*!*
*!*

Define Class oEditBox As EditBox

	#If .F.
		Local This As oEditBox Of "FW\Comunes\prg\Mensaje.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]



Enddefine
*!*
*!* END DEFINE
*!* Class.........: oEditBox
*!*
*!* ///////////////////////////////////////////////////////

