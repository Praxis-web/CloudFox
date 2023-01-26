Lparameters tcSource As String, tp0 As Variant, tp1 As Variant, tp2 As Variant, ;
    tp3 As Variant, tp4 As Variant, tp5 As Variant, tp6 As Variant, tp7 As Variant, ;
    tp8 As Variant, tp9 As Variant, tp10 As Variant, tp11 As Variant, tp12 As Variant, ;
    tp13 As Variant, tp14 As Variant, tp15 As Variant

* ? printf("Width=%d, Height=%4d, Alignment=%s", 100, 200, "Center")

* %d, %i - integer
* %u - unsigned decimal
* %s - string
* %x, %X - unsigned hex value


* VFP Help: A maximum of 27 parameters can be passed
* from a calling program

Local lnIndex
Local lcDecl
Local lvValue
Local lcType
Local lcDecl
Local lnResult
Local lcTarget

If .F.
    Declare Integer wnsprintf In Shlwapi ;
        String @lpOut, ;
        Integer cchLimitIn, ;
        String pszFmt, ;
        Integer
Endif

lcDecl = ""
For lnIndex = 0 To 15
    * If lnIndex <= Parameters()-2
    If lnIndex <= Pcount() - 2
        lvValue = Eval( 'tp' + Transform( lnIndex ) )
        lcType = Type( 'lvValue' )
        Do Case
            Case lcType = 'C'
                lcDecl = lcDecl + ', STRING'
            Case lcType = 'N'
                lcDecl = lcDecl + ', INTEGER'
        Endcase
    Else
        lcDecl = lcDecl + ', INTEGER'
    Endif
Endfor

* every time this function has to be redeclared
* according to the parameters passed to it

lcDecl = "DECLARE INTEGER wnsprintf IN Shlwapi " ;
    + "STRING @lpOut, INTEGER cchLimitIn, STRING pszFmt" ;
    + lcDecl

&lcDecl


lcTarget = Space( 4096 )
lnResult = wnsprintf( @lcTarget, Len( lcTarget ), tcSource, ;
    tp0, tp1, tp2, tp3, tp4, tp5, tp6, tp7, tp8, tp9, ;
    tp10, tp11, tp12, tp13, tp14, tp15 )

* Clear Dlls wnsprintf

Return Left( lcTarget, lnResult )


