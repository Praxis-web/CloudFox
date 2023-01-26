Note: Devuelve un juego de caracteres  que representa el Estilo de la Fuente

#INCLUDE "FW\Comunes\Include\Praxis.h"

Lparameters loRef As Object, tcFontStyle As String
Local lcFontStyle

If Empty( tcFontStyle )
	lcFontStyle	=	Space(0)
	If PemStatus( loRef, "FontBold", 5 )
		If loRef.FontBold
			lcFontStyle	=	lcFontStyle + FS_BOLD
		Endif
	Endif

	If PemStatus( loRef, "FontItalic", 5 )
		If loRef.FontItalic
			lcFontStyle	=	lcFontStyle + FS_ITALIC
		Endif
	Endif

	If PemStatus( loRef, "FontStrikeThru", 5 )
		If loRef.FontStrikethru
			lcFontStyle	=	lcFontStyle + FS_STRIKEOUT
		Endif
	Endif

	If PemStatus( loRef, "FontUnderline", 5 )
		If loRef.FontUnderline
			lcFontStyle	=	lcFontStyle + FS_UNDERLINE
		Endif
	Endif

	If Empty(lcFontStyle)
		lcFontStyle	=	FS_NORMAL
	Endif

Else
	lcFontStyle	= tcFontStyle	

	If PemStatus( loRef, "FontBold", 5 )
		If !Empty( At( FS_BOLD, lcFontStyle ) )
			loRef.FontBold = .T.
			
		Else	
			loRef.FontBold = .F.
			
		Endif
	Endif

	If PemStatus( loRef, "FontItalic", 5 )
		If !Empty( At( FS_ITALIC, lcFontStyle ) )
			loRef.FontItalic = .T.
			
		Else	
			loRef.FontItalic = .F.
			
		Endif
	Endif

	If PemStatus( loRef, "FontStrikeThru", 5 )
		If !Empty( At( FS_STRIKEOUT, lcFontStyle ) )
			loRef.FontStrikethru = .T.
			
		Else	
			loRef.FontStrikethru = .F.
			
		Endif
	Endif

	If PemStatus( loRef, "FontUnderline", 5 )
		If !Empty( At( FS_UNDERLINE, lcFontStyle ) )
			loRef.FontUnderline = .T.
			
		Else	
			loRef.FontUnderline = .F.
			
		Endif
	Endif

Endif

Return lcFontStyle