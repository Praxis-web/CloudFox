* Arma el código único de comprobante para un movimiento
Lparameters tcAbreviatura As String,;
    tcLetra As String,;
    tnPuntoDeVenta As Integer,;
    tnNumero As Integer

Local lcReturn As String
Local lcPuntoDeVenta As String
Local lcNumero As String

If Empty( tcAbreviatura ) Or IsNull( tcAbreviatura ) 
	tcAbreviatura = ''

EndIf

tcAbreviatura = Left( Cast(  Rtrim( Ltrim(  tcAbreviatura ) ) As VarChar( 6 ) ) + Space(6), 6 )

If Empty( tcLetra ) Or IsNull( tcLetra )
	tcLetra = ''

EndIf

tcLetra = Cast( tcLetra As VarChar( 1 ) )

If Empty( tnPuntoDeVenta ) Or IsNull( tnPuntoDeVenta )
	tnPuntoDeVenta = 0
	
EndIf
lcPuntoDeVenta = Right( '0000' + Cast( tnPuntoDeVenta As Varchar( 4 ) ), 4 )

If Empty( tnNumero ) Or IsNull( tnNumero )
	tnNumero = 0
	
EndIf
lcNumero = Right( '00000000' + Cast( tnNumero As Varchar( 8 ) ), 8 )

*!*	Text To lcReturn NoShow TextMerge Pretext 15
*!*	<<tcAbreviatura>> <<tcLetra>> <<lcPuntoDeVenta>>-<<lcNumero>><<Chr( 0 )>>
*!*	EndText

* DAE 2009-10-02(16:47:26) 
* lcReturn = tcAbreviatura + Space( 1 ) + tcLetra + Space( 1 ) + lcPuntoDeVenta + '-' + lcNumero + Chr( 0 )

lcReturn = Cast( tcAbreviatura + Space( 1 ) + tcLetra + Space( 1 ) + lcPuntoDeVenta + '-' + lcNumero  As Char( 22 ) )

Return lcReturn