*
* Utiliza las Tablas:
* CPA_8
* CPA_Alturas
* CPA_Calles
* CPA_Caminos
* CPA_Codigos
* CPA_Localidades
* CPA_Parajes
* CPA_Provincias
*
* Tienen que estar en drComun
*
* Tener en cuenta que los Id de Provincia:
* 	Buenos Aires 	= 1
*	CABA			= 2
*	Resto = Zonas[]
*
* Devuelce loReturn
*	Si loReturn.lConfirma = .T.
*		La info vuelve en las propiedades
*			loReturn.nProvincia_Id
*			loReturn.cProvincia
*			loReturn.nAltura
*			loReturn.cCalle
*			loReturn.cParaje
*			loReturn.cLocalidad
*			loReturn.cCPA

Procedure ObtenerCPA( oParametro As Object ) As Void
	Local lcCommand As String
	Local loReturn As Object

	Try

		lcCommand = ""

		If Vartype( oParametro ) # "O"
			oParametro = Createobject( "Empty" )
		Endif

		If !Pemstatus( oParametro, "nProvincia_Id", 5 )
			AddProperty( oParametro, "nProvincia_Id", 1 )
		Endif

		If !Pemstatus( oParametro, "nAltura", 5 )
			AddProperty( oParametro, "nAltura", 0 )
		Endif

		If !Pemstatus( oParametro, "cCalle", 5 )
			AddProperty( oParametro, "cCalle", "" )
		Endif

		If !Pemstatus( oParametro, "cParaje", 5 )
			AddProperty( oParametro, "cParaje", "" )
		Endif

		If !Pemstatus( oParametro, "cLocalidad", 5 )
			AddProperty( oParametro, "cLocalidad", "" )
		Endif

		If !Pemstatus( oParametro, "cCPA", 5 )
			AddProperty( oParametro, "cCPA", Space( 8 ) )
		Endif


		oParametro.cParaje 		= Upper( Alltrim( oParametro.cParaje ))
		oParametro.cLocalidad 	= Upper( Alltrim( oParametro.cLocalidad ))
		oParametro.cCalle 		= Upper( Alltrim( oParametro.cCalle ))
		
		DO FORM "Tools\Cpa\Scx\Cpa.scx" With oParametro To loReturn  


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return loReturn

Endproc && ObtenerCPA


