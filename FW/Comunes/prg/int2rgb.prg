*
* Convierte un valor Entero en un string con formato RGB
PROCEDURE Int2RGB( nIntValue as Integer ) AS String ;
        HELPSTRING "Convierte un valor Entero en un string con formato RGB"
	Local lcCommand as String
	Local lcHexValue as String,;
	lcRGB as String 
	Local lnRed as Integer,;
	lnGreen as Integer,;
	lnBlue as Integer 
	
	Try
	
		lcCommand = ""
		lcHexValue = Padl( Int2Hex( nIntValue ), 6, "0" )
		
		lnRed 	= Hex2Int( Substr( lcHexValue, 5, 2 ))
		lnGreen = Hex2Int( Substr( lcHexValue, 3, 2 ))
		lnBlue  = Hex2Int( Substr( lcHexValue, 1, 2 ))
		
		lcRGB = StrZero( lnRed, 3 )  
		
		Text To lcRGB NoShow TextMerge Pretext 15
		<<StrZero( lnRed, 3 )>>,<<StrZero( lnGreen, 3 )>>,<<StrZero( lnBlue, 3 )>>
		EndText
		
	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	EndTry
	
	Return lcRGB  

EndProc && Int2RGB
