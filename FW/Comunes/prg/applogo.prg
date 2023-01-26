#INCLUDE "FW\Comunes\Include\Praxis.h" 

Define Class AppLogo As prxImage

	Picture = ""
	BackStyle = 0
	BorderStyle = 0
	Stretch = 2

	Procedure Init
		Local lnModulo as Integer 
		
		lnModulo = 24

		This.Width  = Int( Sysmetric(1) / 3 )
		This.Height = Int( Sysmetric(2) / 3 )


		This.Left   = _Screen.Width - This.Width - lnModulo
		This.Top    = _Screen.Height - This.Height - lnModulo
		This.Anchor = ANCHOR_Bottom_Absolute + ANCHOR_Right_Absolute

	Endproc

Enddefine

*------------------------------------------------------------------*

Define Class FenixLogo As AppLogo Of "fw\comunes\prg\AppLogo.prg"

	Picture = ""
	BackStyle = 0
	BorderStyle = 0
	Stretch = 2

	Procedure Init

		Local lnModulo as Integer 
		
		lnModulo = 24

		This.Width  = Int( Sysmetric(1) / 6 )
		This.Height = Int( Sysmetric(2) / 6 )

		This.Left   = lnModulo 
		This.Top    = lnModulo 
		This.Anchor = 0

	Endproc

Enddefine
