Lparameters tv1 As variant, tv2 As variant, tv3 As variant, tv4 As variant, ;
	tv5 As variant, tv6 As variant, tv7 As variant, tv8 As variant, ;
	tv9 As variant, tv10 As variant, tv11 As variant, tv12 As variant, ;
	tv13 As variant, tv14 As variant, tv15 As variant, tv16 As variant, ;
	tv17 As variant, tv18 As variant, tv19 As variant, tv20 As variant, ;
	tv21 As variant, tv22 As variant, tv23 As variant, tv24 As variant, ;
	tv25 As variant, tv26 As variant


* DAE 2009-07-31(15:38:55) 
* Recibe los parametros de a paraes nombre de propiedad y valor
* CreateObjParam( "Boolean", .F. ) 
* CreateObjParam( "Numeric", 1 ) 
* CreateObjParam( "String", "Cadena de caracteres" )
*

Local loParam As Object
Local lcProp As String
Local lcPropName As String
Local lcValue As String
Local lvValue As variant
Local lnPcount As Number
Local lcMsg As String
Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

Try
	loParam = Createobject( 'Empty' )
	lnPcount = Pcount()
	If Mod( lnPcount, 2 ) = 0

		For i = 1 To lnPcount Step 2
			lcProp = 'tv' + Transform( i )
			lcPropName = &lcProp
			lcValue = 'tv' + Transform( i + 1 )
			lvValue = &lcValue
			AddProperty( loParam, lcPropName, lvValue )

		Endfor

	Else
		lcMsg = 'La cantidad de parametros pasados a la función (' + Transform( lnPcount ) + ') deberia ser par.' + Chr( 13 ) ;
			+ 'Ej:'+ Chr( 13 ) ;
			+ '     CreateObjParam( "Boolean", .F. )' + Chr( 13 ) ;
			+ '     CreateObjParam( "Numeric", 1 )' + Chr( 13 ) ;
			+ '     CreateObjParam( "String", "Cadena de caracteres" )'
		Error lcMsg

	Endif && Mod( Pcount(), 2 ) = 0

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )

	Throw loError

Finally
	loError = Null

Endtry

Return loParam