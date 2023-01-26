Note: Llenar con ceros los espacios en blanco

Parameters nNumero, nAncho, nDecimales
Local lNegativo
lNegativo=.F.

nAncho		=	DefaultValue("nAncho",10)
nDecimales	=	DefaultValue("nDecimales",0)

If nNumero<0
	lNegativo=.T.
	nAncho=nAncho-1
	nNumero=nNumero*(-1)
Else	
	lNegativo=.F.
EndIf


Return  Iif(lNegativo,"-","") + Padl( Alltrim( Str( nNumero, nAncho, nDecimales )), nAncho, "0" )

