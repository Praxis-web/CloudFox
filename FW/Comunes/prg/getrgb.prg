Lparameters nRGB As Integer, cC As Character

Local lnBlue As Integer,;
	lnGreen As Integer,;
	lnRed As Integer,;
	lnMod As Integer,;
	lnReturn As Integer

If !Inlist( Upper( cC ), "R", "G", "B" ) ;
		or nRGB < 0 ;
		or nRGB > ( 255 * 256 * 256 )
		
	lnReturn = -1
Else

	lnBlue = Int( nRGB  / 65536 )

	lnMod = Mod( nRGB, 65536 )

	lnGreen = Int( lnMod / 256 )

	lnRed = Mod( lnMod, 256 )

	Do Case
		Case Upper( cC ) = "R"
			lnReturn = lnRed

		Case Upper( cC ) = "G"
			lnReturn = lnGreen

		Case Upper( cC ) = "B"
			lnReturn = lnBlue

	Endcase

Endif

Return lnReturn
