*
* Cambio de Sucursal
Procedure arChgDrv( cFile As String ) As String
	Local lcCommand As String,;
		lcRuta As String,;
		lcFieldList As String,;
		lcOrderBy As String,;
		lcNombre As String

	Local lnLen As Integer,;
		lnOpcion As Integer,;
		lnSelected As Integer

	Local loApp As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"
	
	Local llExist as Boolean 

	Try

		lcCommand 	= ""
		lcRuta 		= ""
		lcOrderBy 	= ""
		lcNombre 	= ""

		If Vartype( cFile ) # "C"
			cFile = Addbs( Alltrim( _Screen.oApp.cRootWorkFolder )) + "SUCURSAL"
		EndIf

		If FileExist( cFile + ".Dbf" )
			M_Use( 0, cFile, 0, .F., "Sucursales" )

			TEXT To lcFieldList NoShow TextMerge Pretext 15
			Recno() as nRecno
			ENDTEXT

			If Empty( Field( "Id" ))
				lcFieldList = lcFieldList + ", Cast( 0 as I ) as Id"
			Endif

			If Empty( Field( "Orden" ))
				lcFieldList = lcFieldList + ", Cast( 0 as I ) as Orden"

			Else
				lcOrderBy = "Order By Orden"

			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select  *,
					<<lcFieldList>>
				From Sucursales
				Where !Deleted()
				Into Cursor cSucursales ReadWrite
			ENDTEXT

			&lcCommand
			lcCommand = ""

			lnLen = _Tally

			Replace All ;
				Id With Recno(),;
				Orden With Recno()

			Dimension aSucursales[ lnLen ]

			lnSelected = 0
			lnOpcion = 0

			Locate

			Scan
				aSucursales[ Id ] = Alltrim( Nombre )
				If Activo
					lnSelected = Id
				Endif

			Endscan

			lnOpcion = S_Opcion( -1, -1, 0, 0, "aSucursales", lnSelected, .F., "CAMBIO DE SUCURSAL" )

			If !Empty( lnOpcion )
				Locate For Id = lnOpcion

				If Found()
				
					Replace All Activo With .F.
					Locate For Id = lnOpcion
					Replace Activo With .T.

					lcRuta 		= Addbs( Alltrim( Ruta ))
					lcNombre 	= Alltrim( Nombre )
					Release DRVC,DRVB,DRCUE,DRCOMUN,DRVPED,DRF9,DRVD,DRVFRX,DRVA
					Public DRVC,DRVB,DRCUE,DRCOMUN,DRVPED,DRF9,DRVD,DRVFRX,DRVA
					
					TEXT To lcCommand NoShow TextMerge Pretext 15
					Restore From <<lcRuta>>arParame ADDITIVE
					ENDTEXT

					&lcCommand
					lcCommand = ""
					
					
					* Carpetas Por Default
					If Vartype( DRVC ) # "C"
						Release DRVC
						Public DRVC

						DRVC = "Dbf\"
					Endif

					If Type( "DRVB" ) <> "C"
						Release DRVB
						Public DRVB

						DRVB = DRVA
					Endif


					If Type( "DRCUE" ) <> "C"
						Release DRCUE
						Public DRCUE

						DRCUE = DRVA
					Endif

					If Type( "DRCOMUN" ) <> "C"
						Release DRCOMUN
						Public DRCOMUN
						DRCOMUN	= DRCUE
					Endif

					If Type( "DRVPED" ) <> "C"
						Release DRVPED
						Public DRVPED
						DRVPED	= DRVA
					Endif

					If Type( "DRF9" ) <> "L"
						Release DRF9
						Public DRF9
						DRF9 = .F.
					Endif

					If Vartype( DRVD ) # "C"
						Release DRVD
						Public DRVD

						DRVD = ""
					Endif

					* Ruta a ubicacion de Frx
					lcAux = GetValue( "RutaFrx", "ar0Var", "" )

					If Vartype( DRVFRX ) # "C"
						Release DRVFRX
						Public DRVFRX

						DRVFRX = Addbs( Getwordnum( DRVA, 1, "\" )) + Addbs( Getwordnum( DRVA, 2, "\" )) + "Frx\"
					Endif

					* La parametrizacion en ar0Var predomina sobre el arParame
					If !Empty( lcAux )
						DRVFRX = lcAux
					Endif


					Use In Sucursales

					M_Use( 0, Alltrim( DRVA ) + "ar0Est" )


					TEXT To lcFieldList NoShow TextMerge Pretext 15
					Nombre,
					Ruta,
					Activo,
					Orden
					ENDTEXT


					TEXT To lcCommand NoShow TextMerge Pretext 15
					Select <<lcFieldList>>
						From cSucursales
						Order By Orden
						Into Table '<<cFile>>'
					ENDTEXT

					&lcCommand
					lcCommand = ""

					Try

						lcNombre = Alltrim( ar0Est.Nomb0 ) + " (" + lcNombre + " )"
						_Screen.oApp.cEmpresa = lcNombre
						_Screen.oScreenLog.lblEmpresa.Caption = lcNombre

					Catch To oErr

					Finally

					Endtry


				Endif

			Endif

		Else
			
			Text To lcMsg NoShow TextMerge Pretext 03
			No Existe el Archivo de Sucursales: '<<cFile>>.Dbf'
			EndText
			
			Warning( lcMsg, "Cambio de Sucursal" )

		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Close Databases All

	Endtry

	Return lcRuta

Endproc && arChgDrv


*!*	*--------------------------------------------------------------------------------------
*!*	Procedure Dummy

*!*		Para cFile

*!*		Try

*!*			Private cRUTA,WLEN,wi,WTOP,WBOT,WIZQ,WDER,WOPCI,WACTI

*!*			Store Null To cRUTA,WLEN,wi,WTOP,WBOT,WIZQ,WDER,WOPCI,WACTI


*!*			S_TITPRO( 'CAMBIO DE SUCURSAL', FECHAHOY )

*!*			cRUTA=""
*!*			WOPCI=0
*!*			WACTI=0

*!*			Do Case
*!*				Case Type("cFILE")<>"C"
*!*					cFile= _Screen.oApp.cRootWorkFolder + "SUCURSAL"
*!*			Endcase

*!*			Do Case
*!*				Case  FileExist("&cFILE..DBF")

*!*					Sele 0
*!*					Use '&cFILE' Alias sucursal
*!*					WLEN=Lastrec()
*!*					Do Case
*!*						Case !Empty(WLEN)
*!*							Dimension aSUCU[WLEN]
*!*							For wi=1 To WLEN
*!*								Goto wi
*!*								aSUCU[WI]=Nombre
*!*								Do Case
*!*									Case Activo
*!*										WOPCI=wi
*!*										WACTI=wi
*!*								Endcase
*!*							Next

*!*							WOPCI = ChgDrvOPCION( @aSUCU, WOPCI )

*!*							Do Case
*!*								Case !Empty(WOPCI)
*!*									Try
*!*										_Screen.oApp.cEmpresa = ""

*!*									Catch To oErr

*!*									Finally

*!*									Endtry

*!*									Sele sucursal
*!*									M_Iniact(3)
*!*									Goto WACTI
*!*									Repl Activo With .F.
*!*									Goto WOPCI
*!*									Repl Activo With .T.
*!*									Unlock
*!*									cRUTA=Alltrim(Ruta)
*!*									DRCOMUN=.F.
*!*									Rest From '&cRUTA.ARPARAME' AddI
*!*									Do Case
*!*										Case Type("DRCOMUN")<>"C"
*!*											DRCOMUN=DRVA
*!*									Endcase
*!*									Sele 0
*!*									*							Use '&DRVA.Ar0est'
*!*									M_Use( 0, Trim(DRVA)+'ar0Est' )
*!*									Do Case
*!*										Case Type("M4CLI")="C"
*!*											M4CLI=Clie0
*!*									Endcase
*!*									Do Case
*!*										Case Type("M5CLI")="C"
*!*											M5CLI=Clie0
*!*									Endcase
*!*									Do Case
*!*										Case Type("M6CLI")="C"
*!*											M6CLI=Clie0
*!*									Endcase



*!*									Try
*!*										lcDummy= _Screen.oApp.cEmpresa

*!*									Catch To oErr

*!*									Finally

*!*									Endtry

*!*							Endcase
*!*					Endcase

*!*				Otherwise
*!*					Warning( "No Existe el Archivo de Sucursales" )

*!*			Endcase
*!*			Clos Data

*!*			Do Case
*!*				Case FileExist(Trim(DRVA)+"PS.PRX")
*!*					cARCHCLA=Trim(DRVA)+"PS.PRX"
*!*					Rest From  '&cARCHCLA' AddI

*!*				Otherwise
*!*					K_PSW="PRAXIS"

*!*			Endcase



*!*		Catch To oErr
*!*			Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

*!*			loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
*!*			loError.Process( oErr )
*!*			Throw loError

*!*		Finally
*!*			Close Databases All

*!*		Endtry

*!*		Retu cRUTA


*!*		******************************************

*!*	Function ChgDrvOPCION
*!*		Para aPara, WOPCI
*!*		Store .F. To wi,WLEN,WTOP,WBOT,WIZQ,WDER


*!*		WLEN=0
*!*		For wi=1 To Alen(aPara)
*!*			WLEN=Max(WLEN,Len(aPara[WI]))
*!*		Next

*!*		For wi=1 To Alen(aPara)
*!*			WLEN=Max(WLEN,Len(aPara[WI]))
*!*			aPara[WI]=Substr(aPara[WI]+Space(WLEN),1,WLEN)
*!*			aPara[WI]=" "+Chr(64+wi)+" - "+aPara[WI]+" "
*!*		Next

*!*		WLEN=Len(aPara[1])
*!*		WTOP=10-Int(Alen(aPara)/2)
*!*		WBOT=WTOP+Alen(aPara)+01
*!*		WIZQ=Int(40-(WLEN/2))-01
*!*		WDER=WIZQ+WLEN+01


*!*		loParam = Createobject( "Empty" )
*!*		AddProperty( loParam, "Height", 180 )


*!*		WOPCI = S_Opcion( WTOP, WIZQ, 0, 0, "APARA", WOPCI, .F., "", loParam )


*!*		Return WOPCI

*!*		*********************************************

*!*	Procedure aPara
*!*		Return
*!*	Endproc
