#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Clientes\Utiles\Include\Utiles.h"

Parameters cOpciones As String

If Empty( cOpciones ) Or Vartype( cOpciones ) # "C"
	cOpciones = ""
Endif
*
* Parametros de Implementacion
* RA 2011-03-11(09:06:30)



If Empty( cOpciones )

	cOpciones = "01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18"

Endif

Private oOpciones As Collection

If !Empty( cOpciones )
	Local lnLen As Integer,;
		i As Integer,;
		lnId As Integer

	Local loOpcion As Object

	oOpciones = Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.Prg" )
	lnLen = Getwordcount( cOpciones, "," )
	Dimension aPara[ lnLen ]

	For i = 1 To lnLen

		lnId = Val( Getwordnum( cOpciones, i, "," ))

		loOpcion = Createobject( "Empty" )
		AddProperty( loOpcion, "Id", lnId )

		Do Case
			Case lnId = PRM_Todos
				AddProperty( loOpcion, "Descripcion", "Todos" )

			Case lnId = PRM_Artículo
				AddProperty( loOpcion, "Descripcion", "Artículo" )

			Case lnId = PRM_Ventas
				AddProperty( loOpcion, "Descripcion", "Ventas" )

			Case lnId = PRM_Stock
				AddProperty( loOpcion, "Descripcion", "Stock" )

			Case lnId = PRM_Deudores
				AddProperty( loOpcion, "Descripcion", "Deudores" )

			Case lnId = PRM_Estadisticas
				AddProperty( loOpcion, "Descripcion", "Estadísticas" )

			Case lnId = PRM_Presupuestos
				AddProperty( loOpcion, "Descripcion", "Presupuestos" )

			Case lnId = PRM_Compras
				AddProperty( loOpcion, "Descripcion", "Compras" )

			Case lnId = PRM_Pedidos
				AddProperty( loOpcion, "Descripcion", "Pedidos" )

			Case lnId = PRM_Valores
				AddProperty( loOpcion, "Descripcion", "Valores" )

			Case lnId = PRM_Varios
				AddProperty( loOpcion, "Descripcion", "Globales" )

			Case lnId = PRM_Auditoria
				AddProperty( loOpcion, "Descripcion", "Auditoria" )

			Case lnId = PRM_Impuestos
				AddProperty( loOpcion, "Descripcion", "Impuestos" )

			Case lnId = PRM_Exportar
				AddProperty( loOpcion, "Descripcion", "Carpetas de Exportación" )

			Case lnId = PRM_Pasajes
				AddProperty( loOpcion, "Descripcion", "Pasajes" )

			Case lnId = PRM_FactEle
				AddProperty( loOpcion, "Descripcion", "Factura Electrónica" )

			Case lnId = PRM_Mails
				AddProperty( loOpcion, "Descripcion", "Envío de Mails" )

			Case lnId = PRM_IntegracionWeb
				AddProperty( loOpcion, "Descripcion", "Integración en la Nube" )

		Endcase

		oOpciones.Add( loOpcion, Transform( lnId ) )

	Endfor

Endif


Private  WCLAV,WSELE,WOPCI,WARCH,WITEM,WCOLU,WDATO,WORDE,F091,WLEN,WFECI,WLIN, nFieldWidth, nPrecision

Store .F. To  WCLAV,WSELE,WOPCI,WARCH,WITEM,WCOLU,WDATO,WORDE,F091,WLEN,WFECI,WLIN, nFieldWidth, nPrecision

*Dimension aPara[ PRM_Len ]

Private dFecha As Date
dFecha = Date()


Try
	WOPEN=.F.
	Panta00P()
	Clave00P()

	If WOPEN
		Do While !&ABORTA
			If Carga00P()
				R7ITEM( WITEM, 1, "00P", WITEM, "WITEM", "V_NULL", "V_NULL", 2, .F., 2, WARCH, WLEN )

				If !&ABORTA
					If .F.
						ExportarXML()
					Endif

					Actua00P()

				Else
					prxSetLastKey( 0 )

				Endif


			Endif


			Panta00P()
		Enddo

	Endif


Catch To oErr
	Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

	loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	oOpciones = Null

Endtry

Return  && ArParame


*
*
Procedure ExportarXML(  ) As Void
	Local lcCommand As String,;
		lcFielName As String

	Try

		lcCommand = ""

		Select Alias( WARCH )
		Locate For !Empty( TITUTR )
		lcFielName = Alltrim( TITUTR )

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select
				DESCTR As cDescripcion,
				DATNTR As nDatoNumber,
				DATITR As nDatoInteger,
				DATCTR As cDatoString,
				DATDTR As dDatoDate,
				DATTTR As dDatoDateTime,
				DATLTR As lDatoLogical,
				DATMTR As mDatoMemo,
				PICTTR As cPicture,
				CAMPTR As cFieldName,
				TIPOTR As cFieldType,
				WIDTTR As nFieldWidth,
				DECITR As nPrecision,
				LEYETR As cLeyenda,
				VALITR As cUDF_Validacion,
				PREFTR As cUDF_Before,
				POSFTR As cUDF_After,
				COLUTR As nColumn,
				SELETR As cFileName,
				FOLDTR As cFolder,
				ORDETR As nOrden,
				TITUTR As cTitulo,
				DEFATR As cDefault
			From <<WARCH>>
			Where !Empty( DESCTR )
			Into Cursor cParImp ReadWrite
		ENDTEXT

		&lcCommand
		lcCommand = ""

		Browse

		If Confirm()
			Cursortoxml( "cParImp", lcFielName + ".Xml", 1, 4+8+16+512, 0, "1" )
		Endif



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && Exportar


*/ ----------------------------------------------------------------


NOTE: PANTALLA

Procedure Panta00P
	S_CLEAR(0,0,23,79)
	S_TITPRO("PARAMETROS DE IMPLEMENTACION",FECHAHOY)
	S_LINE23( MSG8 )
	Return

	NOTE: TIPO DE INDEXACION


Procedure Clave00P
	Try

		If CLAVE=5
			WCLAV=I_INGTIP( F9, F10, 2, "[ENTER]:INGRESA DATOS              [ESC]:MENU" )

		Else
			WCLAV="A"

		Endif


		WOPCI=0

		WOPEN = .T.

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		WOPEN = .F.
		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry
	Return




	*
	* Crea archivo Transitorio
Procedure Archi00p(  ) As Void;
		HELPSTRING "Crea archivo Transitorio"
	Try
		WARCH = Sys(2015)

		Close Databases All

		Create Cursor (WARCH) (;
			DESCTR C ( 80 ),;
			DATNTR N ( 15, 5 ),;
			DATITR i ,;
			DATCTR C ( 80 ),;
			DATDTR D,;
			DATTTR T,;
			DATLTR L,;
			DATMTR M,;
			PICTTR C ( 250 ),;
			CAMPTR C ( 10 ),;
			TIPOTR C ( 1 ),;
			WIDTTR i ,;
			DECITR i ,;
			LEYETR C ( 200 ),;
			VALITR C ( 80 ),;
			PREFTR C ( 30 ),;
			POSFTR C ( 30 ),;
			COLUTR N ( 2, 0 ),;
			SELETR C ( 20 ),;
			FOLDTR C ( 8 ),;
			ORDETR N ( 3, 0 ),;
			TITUTR C ( 80 ),;
			DEFATR C ( 80 ),;
			DEFA_M M,;
			ACTUTR C ( 30 ),;
			R7MOV C ( 1 )  )


		* TIPOTR TIPO DE DATO "C","N","D","L"
		* CAMPTR NOMBRE DEL CAMPO
		* PICTTR PICTURE DEL DATO
		* DESCTR LEYENDA QUE SE MUESTRA
		* LEYETR LEYENDA ACLARATORIA EN LINEA 24
		* VALITR FUNCION DE VALIDACION
		* PREFTR FUNCION QUE SE EJECUTA AL PRINCIPIO ¦ SIRVEN PARA LIMPIAR LA PANTALLA
		* POSFTR FUNCION QUE SE EJECUTA AL FINAL     ¦ O IMPRIMIR ALGO EN FUNCION DEL DATO
		* COLUTR COLUMNA DONDE SE PIDE EL DATO
		* SELETR AREA DONDE SE LEE/ESCRIBE
		* ORDETR NUMERO DE ORDEN (SI EXISTE, ES DATO. SI NO, ES SEPARADOR)
		* TITUTR TITULO DEL BLOQUE


	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Archi00p

NOTE: CARGA DEL TRANSITORIO

Function Carga00P

	Local llReturn As Boolean
	Local lcCommand As String,;
		luDefault As String
	Local luValue As Variant

	Try

		lcCommand = ""

		WLEN=18
		WCOLU=40
		WORDE=00

		*WOPCI=Opcion00P(WOPCI)
		WOPCI=ElegirOpcion( oOpciones )

		If !&ABORTA

			Archi00p()

			If WOPCI=PRM_Artículo  Or  WOPCI=PRM_Todos
				* Artículo

				Articulos( oOpciones )
				Page00P()
			Endif

			If WOPCI=PRM_Ventas  Or  WOPCI=PRM_Todos
				* Ventas

				Ventas( oOpciones )
				Page00P()

			Endif

			If WOPCI=PRM_Stock  Or  WOPCI=PRM_Todos
				* Stock

				Stock( oOpciones )
				Page00P()

			Endif

			If WOPCI=PRM_Deudores  Or  WOPCI=PRM_Todos
				* Deudores

				Deudores( oOpciones )
				Page00P()

			Endif


			If WOPCI=PRM_Estadisticas Or  WOPCI=PRM_Todos
				* Estadisticas

				Estadisticas( oOpciones )
				Page00P()

			Endif


			If WOPCI=PRM_Presupuestos  Or  WOPCI=PRM_Todos
				* Presupuestos

				Presupuestos( oOpciones )
				Page00P()
			Endif


			If WOPCI=PRM_Compras  Or  WOPCI=PRM_Todos
				* Compras

				Compras( oOpciones )
				Page00P()

			Endif


			If WOPCI=PRM_Pedidos  Or  WOPCI=PRM_Todos
				* Pedidos

				Pedidos( oOpciones )
				*Do Pedidos In "Clientes\Pedidos\Prg\peParame.prg"
				Page00P()
			Endif



			If WOPCI=PRM_Valores  Or  WOPCI=PRM_Todos
				* Valores

				Valores( oOpciones )
				Page00P()

			Endif


			If WOPCI=PRM_Varios  Or  WOPCI=PRM_Todos
				* Varios

				Varios( oOpciones )
				Page00P()

			Endif


			If WOPCI=PRM_Exportar  Or  WOPCI=PRM_Todos
				* Exportar

				Exportar( oOpciones )
				Page00P()

			Endif


			If WOPCI=PRM_Auditoria  Or  WOPCI=PRM_Todos
				* Auditoria

				Auditoria( oOpciones )
				Page00P()

			Endif


			If WOPCI=PRM_Impuestos  Or  WOPCI=PRM_Todos
				* Impuestos

				Impuestos( oOpciones )
				Page00P()

			Endif

			If WOPCI=PRM_Pasajes  Or  WOPCI=PRM_Todos
				* Impuestos

				Pasajes( oOpciones )
				Page00P()

			Endif

			If WOPCI=PRM_FactEle  Or  WOPCI=PRM_Todos
				* Facturacion Electronica

				FacturaElectronica( oOpciones )
				Page00P()

			Endif

			If WOPCI=PRM_Mails Or  WOPCI=PRM_Todos
				* Envío de Mails

				Envío_de_Mails( oOpciones )
				Page00P()

			Endif

			If WOPCI=PRM_IntegracionWeb Or  WOPCI=PRM_Todos
				* Envío de Mails

				Integracion_Web( oOpciones )
				Page00P()

			Endif

			Select Alias( WARCH )
			Locate

			Scan


				If TIPOTR = "T"
					Set Step On
				Endif

				WTIPO=TIPOTR
				WCAMP=Alltrim(CAMPTR)
				WSELE=Alltrim(SELETR)
				WFOLD=Alltrim(FOLDTR)
				If Empty( WFOLD )
					WFOLD = "DRVA"
				Endif
				luDefault = Alltrim( DEFATR )

				If !Empty(ORDETR)


					lcWidth = ""

					Do Case
						Case Inlist( WTIPO, "C" )
							lcWidth = " ( " + Transform( WIDTTR ) + " ) "
							luValue = luDefault

						Case Inlist( WTIPO, "I" )
							luValue = Cast( luDefault As i )

						Case Inlist( WTIPO, "N" )
							lcWidth = " ( " + Transform( WIDTTR ) + "," + Transform( DECITR ) + " ) "
							TEXT To lcCommand NoShow TextMerge Pretext 15
							luValue = Cast( luDefault as N( <<WIDTTR>>, <<DECITR>> ))
							ENDTEXT

							&lcCommand

						Case Inlist( WTIPO, "D" )
							luValue = Cast( luDefault As D )

						Case Inlist( WTIPO, "T" )
							luValue = Cast( luDefault As T )

						Case Inlist( WTIPO, "M" )
							luValue = Cast( luDefault As M )
							If Empty( luValue )
								luValue = Alltrim( DEFA_M )
							Endif

						Otherwise
							Error "Tipo no contemplado: '" + WTIPO + [']

					Endcase

					If !Used( Alltrim(WSELE) )

						Try

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Use '<<Trim( Evaluate( WFOLD ) ) + Alltrim(WSELE)>>' In 0
							ENDTEXT

							&lcCommand


						Catch To oErr
							Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

							If oErr.ErrorNo = 1 && The file specified does not exist.

								TEXT To lcCommand NoShow TextMerge Pretext 15
								Create Table '<<Trim( Evaluate( WFOLD ) ) + Alltrim(WSELE)>>' Free
								( <<WCAMP>> <<WTIPO>> <<lcWidth>> )
								ENDTEXT

								&lcCommand

								Use In Alias( Alltrim(WSELE) )

								TEXT To lcCommand NoShow TextMerge Pretext 15
								Use '<<Trim( Evaluate( WFOLD ) ) + Alltrim(WSELE)>>' In 0
								ENDTEXT

								&lcCommand

								TEXT To lcCommand NoShow TextMerge Pretext 15
								Insert into <<Alltrim(WSELE)>> (
									<<WCAMP>> ) Values (
									luValue )
								ENDTEXT

								&lcCommand

								*Append Blank

							Else
								loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
								loError.Remark = lcCommand
								loError.Process( oErr )
								Throw loError

							Endif

						Finally

						Endtry


						Select Alias( WARCH )

					Endif

					Try

						*Repl DAT&WTIPO.TR With Evaluate( WSELE + "." + WCAMP )
						TEXT To lcCommand NoShow TextMerge Pretext 15
						Replace DAT<<WTIPO>>TR With Evaluate( '<<WSELE>>.<<WCAMP>>' )
						ENDTEXT

						&lcCommand
						lcCommand = ""

					Catch To oErr
						Set Step On
						Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
						If oErr.ErrorNo = 12 && The specified variable or field name could not be found.

							Use In Alias( Alltrim(WSELE) )

							Try

								TEXT To lcCommand NoShow TextMerge Pretext 15
								Alter Table '<<Trim( Evaluate( WFOLD ) ) + Alltrim(WSELE)>>'
								Add Column <<WCAMP>> <<WTIPO>> <<lcWidth>>
								ENDTEXT

								&lcCommand

								TEXT To lcCommand NoShow TextMerge Pretext 15
								Replace <<WCAMP>> With luValue in <<Alltrim(WSELE)>>
								ENDTEXT

								&lcCommand
								lcCommand = ""


								Use In Alias( Alltrim(WSELE) )

								M_USE( 0, Trim( Evaluate( WFOLD ) ) + Alltrim(WSELE) )

								Select Alias( WARCH )

								Repl DAT&WTIPO.TR With Evaluate( WSELE + "." + WCAMP )

							Catch To oErr
								loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
								loError.Remark = lcCommand
								loError.Process( oErr, .F. )

								Select Alias( WARCH )
								Delete

							Finally

							Endtry



						Else
							loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
							loError.Remark = lcCommand
							loError.Process( oErr )
							Throw loError


						Endif

					Finally

					Endtry

				Endif

			Endscan

			WITEM=LASTREC()

			@ Min(WITEM+02,20),00 To Min(WITEM+02,20),80

			llReturn = .T.

		Else
			llReturn = .F.

		Endif


	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Remark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return llReturn

	NOTE: FUNCIONES


Function PreSiNo

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(2)
	Return .T.

Function PosSiNo
	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO="S"
			SayMask( WLIN, lnCol, "SI", "", 2 )

		Case WDATO="N"
			SayMask( WLIN, lnCol, "NO", "", 2 )

		Otherwise
			SayMask( WLIN, lnCol, "  ", "", 2 )

	Endcase

	Return .T.

Function PreNumAlfa

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(20)
	Return .T.

Function PosNumAlfa
	Local lnCol As Integer
	Local lcMsg As String

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO = "A"
			lcMsg = "Alfanumérico"

		Otherwise
			lcMsg = "Numérico"

	Endcase

	SayMask( WLIN, lnCol, lcMsg, "", 20 )
	Return .T.


Function PreCodAtr

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(20)
	Return .T.

Function PosCodAtr
	Local lnCol As Integer
	Local lcMsg As String

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO = "A"
			lcMsg = "Atributo"

		Otherwise
			lcMsg = "Parte del Código"

	Endcase

	SayMask( WLIN, lnCol, lcMsg, "", 20 )

	Return .T.



Function PreMovAsi

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(20)
	Return .T.

Function PosMovAsi
	Local lnCol As Integer
	Local lcMsg As String

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO = "A"
			lcMsg = "Asiento Contable"

		Case WDATO = "M"
			lcMsg = "Movimiento de Caja"

		Case WDATO = "N"
			lcMsg = "Nada"

	Endcase

	SayMask( WLIN, lnCol, lcMsg, "", 20 )

	Return .T.


Function PreIngPProd

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(20)
	Return .T.

Function PosIngPProd
	Local lnCol As Integer
	Local lcMsg As String

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO = "I"
			lcMsg = "Ingreso"

		Otherwise
			lcMsg = "Parte de Producción"

	Endcase

	SayMask( WLIN, lnCol, lcMsg, "", 20 )

	Return .T.


Function PreTipoDescarga

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(20)
	Return .T.

Function PosTipoDescarga
	Local lnCol As Integer
	Local lcMsg As String

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO = "A"
			lcMsg = "Automático"

		Case WDATO = "M"
			lcMsg = "Manual"

		Otherwise
			lcMsg = "No descarga"

	Endcase

	SayMask( WLIN, lnCol, lcMsg, "", 20 )
	Return .T.

Function PreZona
	Private Wcol
	Store .F. To Wcol

	Do Case
		Case Empty(COLUTR)
			Wcol=WCOLU

		Otherwise
			Wcol=COLUTR

	Endcase


	@ WLIN,Wcol Say Space(20)
	On Key Label F1 Do fZonas
	Keyboard '{F1}'
	Return .T.

Procedure fZonas
	WDATO=S_OPCION(WLIN,Wcol,WLIN+Alen(ZONAS)+1,Wcol+Len(ZONAS[1])+1,"ZONAS",Iif(WDATO = 0,1, WDATO),.T.)
	Return

Function PosZona
	On Key Label F1
	Private Wcol
	Store .F. To Wcol

	Do Case
		Case Empty(COLUTR)
			Wcol=WCOLU

		Otherwise
			Wcol=COLUTR

	Endcase

	If Empty( WDATO )
		WDATO = 1
	Endif

	@ WLIN,Wcol Say ZONAS[WDATO]

	Return .T.


	Note: [F1] Selecciona Carpeta

Function PreF1Folder
	S_LINE24("Ingrese Carpeta    [F1]: Buscar")
	On Key Label F1 Do F1_Folder
	Return .T.

Procedure F1_Folder
	WDATO=Getdir( WDATO, "", "", 16+32+64+16384 )

	Return

Function PosF1Folder
	SayMask( WLIN, Wcol, WDATO, WPICT, 0 )
	On Key Label F1
	Return .T.

Function PreFiltVend

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(40)
	Return .T.



	Note: [F1] Selecciona Archivo

Function PreF1File
	S_LINE24("Ingrese Carpeta    [F1]: Buscar")
	On Key Label F1 Do F1_File
	Return .T.

Procedure F1_File
	WDATO=Getfile()

	Return

Function PosF1File
	SayMask( WLIN, Wcol, WDATO, WPICT, 0 )
	On Key Label F1
	Return .T.


Function PreMemoEdit
	WDATO = prxMemoEdit( WDATO, WLEYE, .T. )
	Return .T.


Function PosMemoEdit
	Local Array laLines[ 1 ]
	Alines( laLines, WDATO, 1 )
	lcStr = Substr( laLines[ 1 ], 1, 250 )
	SayMask( WLIN, Wcol, lcStr, WPICT, 0 )
	Return .T.


	*
	*
Procedure PreCuentaMail(  ) As Void
	Local lcCommand As String
	Local loMailAccount As MailAccount Of 'Fw\Comunes\Prg\MailAccount.prg'

	Try

		lcCommand = ""
		loMailAccount = GetEntity( "MailAccount" )
		WDATO = loMailAccount.SelectFromList( WLIN, Wcol, WDATO, .T., "", "Cuentas de Mail" )


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loMailAccount = Null
		Select Alias( WARCH )

	Endtry

Endproc && PreCuentaMail


*
*
Procedure PosCuentaMail(  ) As Void
	Local lcCommand As String,;
		lcCuenta As String,;
		lcAlias As String

	Local loMailAccount As MailAccount Of 'Fw\Comunes\Prg\MailAccount.prg'

	Try

		lcCommand = ""
		lcAlias = "Cuentas"

		loMailAccount = GetEntity( "MailAccount" )
		lcAlias = loMailAccount.cMainCursorName

		If !Empty( loMailAccount.GetOne( WDATO ) )
			lcCuenta = Evaluate( lcAlias + ".Nombre" )

		Else
			lcCuenta = Space( 30 )

		Endif

		SayMask( WLIN, Wcol, lcCuenta, "", 30 )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		Use In Select( lcAlias )
		loMailAccount = Null
		Select Alias( WARCH )

	Endtry

Endproc && PosCuentaMail


Function PreFiltVend

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(40)
	Return .T.

Function PosFiltVend
	Local lnCol As Integer
	Local lcMsg As String

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO = 1
			lcMsg = "El que figura en el comprobante"

		Case WDATO = 2
			lcMsg = "El asignado en el cliente"

	Endcase

	SayMask( WLIN, lnCol, lcMsg, "", 20 )
	Return .T.




Function PreCabeDeta

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(40)
	Return .T.

Function PosCabeDeta
	Local lnCol As Integer
	Local lcMsg As String

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO = 1
			lcMsg = "Recorre Cabecera"

		Case WDATO = 2
			lcMsg = "Recorre Detalle"

	Endcase

	SayMask( WLIN, lnCol, lcMsg, "", 20 )
	Return .T.


	*!*	Function PreIvasCant

	*!*		Local lnCol As Integer

	*!*		If Empty(COLUTR)
	*!*			lnCol=WCOLU
	*!*		Else
	*!*			lnCol=COLUTR
	*!*		Endif

	*!*		@ WLIN,lnCol Say Space(40)
	*!*		Return .T.

	*!*	Function PosIvasCant
	*!*		Local lnCol As Integer
	*!*		Local lcMsg As String

	*!*		If Empty(COLUTR)
	*!*			lnCol=WCOLU

	*!*		Else
	*!*			lnCol=COLUTR

	*!*		Endif

	*!*		Do Case
	*!*			Case WDATO = 1
	*!*				lcMsg = "Recorre Cabecera"

	*!*			Case WDATO = 2
	*!*				lcMsg = "Recorre Detalle"

	*!*		Endcase

	*!*		SayMask( WLIN, lnCol, lcMsg, "", 20 )
	*!*		Return .T.


Function PreDepositos
	Private Wcol
	Store .F. To Wcol

	Do Case
		Case Empty(COLUTR)
			Wcol=WCOLU

		Otherwise
			Wcol=COLUTR

	Endcase


	@ WLIN,Wcol Say Space(25)
	On Key Label F1 Do ElijeDepositos With DESCTR
	Keyboard '{F1}'
	Return .T.

Procedure ElijeDepositos( lcCaption )
	Local lcCommand As String
	Local loStock As oStock Of "Clientes\Stock\prg\stRutina.prg"


	Try

		lcCommand = ""
		loStock = NewStock()
		WDATO = loStock.ElegirDeposito( WLIN, Wcol, WDATO, .T., Alltrim( lcCaption) )

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		*!* DEBUG_CLASS_EXCEPTION
		DEBUG_EXCEPTION
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		m.loError.Process ( m.loErr )
		THROW_EXCEPTION

	Finally
		loStock = Null

	Endtry

	Return

Function PosDepositos

	Local lcCommand As String
	Local loStock As oStock Of "Clientes\Stock\prg\stRutina.prg"

	Try

		lcCommand = ""
		loStock = NewStock()

		On Key Label F1

		If Empty(COLUTR)
			Wcol=WCOLU

		Else
			Wcol=COLUTR

		Endif

		loDeposito 	= loStock.ObtenerDeposito( WDATO )
		If Vartype( loDeposito ) = "O"
			@ WLIN,Wcol Say Substr( Alltrim( loDeposito.Nombre ), 1 , 25 )

		Else
			@ WLIN,Wcol Say Space( 25 )

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		*!* DEBUG_CLASS_EXCEPTION
		DEBUG_EXCEPTION
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		m.loError.Process ( m.loErr )
		THROW_EXCEPTION

	Finally
		loStock = Null

	Endtry

	Return .T.

	*
	* Validacion del orden de pedido del articulo
Procedure ValOrdenGet( WDATO ) As Boolean;
		HELPSTRING "Validacion del orden de pedido del articulo"

	Local llValid As Boolean
	Local i As Integer
	Local lcChar As Character

	Try

		llValid = .T.
		For i = 1 To Len( Alltrim( WDATO ))
			lcChar = Substr( WDATO, i, 1 )
			*llValid = !Empty( At( lcChar, " CDAB" )) And llValid
			llValid = Inlist( lcChar, "C", "D", "A", "B" ) And llValid
		Endfor

		TEXT To lcMsg NoShow TextMerge Pretext 03
		Los valores admitidos son:
		[C], [D], [A], [B]
		ENDTEXT

		I_Valida( llValid, lcMsg )

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return llValid

Endproc && ValOrdenGet



NOTE: MOSTRAR REGISTROS

Procedure RE00P
	Para WLIN

	Private WTIPO,WPICT,Wcol
	Store .F. To WTIPO,WPICT,Wcol

	Try

		lcCommand = ""

		If Empty(ORDETR)
			@ WLIN,01
			C_CENTRO(WLIN,Alltrim(TITUTR),80)

		Else
			WTIPO=TIPOTR
			If Empty(COLUTR)
				Wcol=WCOLU

			Else
				Wcol=COLUTR

			Endif

			WPICT=Alltrim(PICTTR)

			@ WLIN,01
			@ WLIN,01 Say ORDETR Pict "999"
			@ WLIN,04 Say ")"
			@ WLIN,06 Say Alltrim(DESCTR)


			@ WLIN,Col() Say Repl(".", Max( Wcol - Col() - 2, 0 )) + ":"

			Replace COLUTR With Max( COLUTR, Col() + 1 )
			Wcol=COLUTR

			WDATO=DAT&WTIPO.TR

			If Empty(POSFTR)
				WPOS=".T."
				SayMask( WLIN, Wcol, DAT&WTIPO.TR, WPICT, 0 )

			Else
				WPOS=Alltrim(POSFTR)
				If &WPOS
				Endif

			Endif

		Endif


	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Remark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return
Procedure PE00P
	Para WLIN,WING,WTIP

	Private WTIPO,WPICT,WLEYE,WVALI,Wcol,WPRE,WPOS
	Store .F. To WTIPO,WPICT,WLEYE,WVALI,Wcol,WPRE,WPOS

	Try

		If Empty(ORDETR)
			Keyboard '{ENTER}'
			prxSetLastKey( Enter )

		Else
			WTIPO=TIPOTR
			WDAT&WTIPO=DAT&WTIPO.TR
			WDATO=DAT&WTIPO.TR
			WPICT=Alltrim(PICTTR)
			WVALI=Alltrim(VALITR)

			If Empty(LEYETR)
				WLEYE=".T."

			Else
				WLEYE=Alltrim(LEYETR)

			Endif

			If Empty(COLUTR)
				Wcol=WCOLU

			Else
				Wcol=COLUTR

			Endif

			If Empty(PREFTR)
				WPRE=".T."

			Else
				WPRE=Alltrim(PREFTR)

			Endif

			If Empty(POSFTR)
				WPOS=".T."

			Else
				WPOS=Alltrim(POSFTR)

			Endif

			S_LINE23(MSG18)

			Try
				If &WPRE
				Endif
			Catch To oErr
			Finally
			Endtry


			Try
				If &WLEYE
				Endif
			Catch To oErr
			Finally
			Endtry


			If Empty(WVALI)
				WVALI=".T."
			Endif


			Do Case
				Case WTIPO="D"
					If WVALI#".T."
						If !"@WDATO"$Upper( WVALI )
							WVALI = Strtran( Upper( WVALI ), "WDATO", "@WDATO" )
						Endif
					Endif

					S_LINE24(ACL6)
					@ WLIN, Wcol Get WDATO Picture "@D" Valid Evaluate( WVALI )
					Read
					@ WLIN, Wcol
					SayMask( WLIN, Wcol, WDATO, "@D" )

				Case WTIPO = "M"
					Local Array laLines[ 1 ]
					Alines( laLines, WDATO, 1 )
					lcStr = Substr( laLines[ 1 ], 1, 250 )
					@ WLIN, Wcol
					SayMask( WLIN, Wcol, lcStr, WPICT, 0 )

				Otherwise
					@ WLIN,Wcol Get WDATO Pict WPICT Valid Evaluate( WVALI )
					Read
					@ WLIN, Wcol
					SayMask( WLIN, Wcol, WDATO, WPICT, 0 )

			Endcase

			WDAT&WTIPO=WDATO

			Try
				If &WPOS
				Endif
			Catch To oErr
			Finally
			Endtry

			WING=Iif(!&ABORTA,.T.,.F.)

			If WING
				Repl DAT&WTIPO.TR With WDAT&WTIPO
			Endif

		Endif

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return



Procedure xxxPE00P
	Para WLIN,WING,WTIP

	Private WTIPO,WPICT,WLEYE,WVALI,Wcol,WPRE,WPOS
	Store .F. To WTIPO,WPICT,WLEYE,WVALI,Wcol,WPRE,WPOS

	Try

		If Empty(ORDETR)
			Keyboard '{ENTER}'
			prxSetLastKey( Enter )

		Else
			WTIPO=TIPOTR
			WDAT&WTIPO=DAT&WTIPO.TR
			WDATO=DAT&WTIPO.TR
			WPICT=Alltrim(PICTTR)
			WVALI=Alltrim(VALITR)

			If Empty(LEYETR)
				WLEYE=".T."

			Else
				WLEYE=Alltrim(LEYETR)

			Endif

			If Empty(COLUTR)
				Wcol=WCOLU

			Else
				Wcol=COLUTR

			Endif

			If Empty(PREFTR)
				WPRE=".T."

			Else
				WPRE=Alltrim(PREFTR)

			Endif

			If Empty(POSFTR)
				WPOS=".T."

			Else
				WPOS=Alltrim(POSFTR)

			Endif

			S_LINE23(MSG18)

			If &WPRE
			Endif

			If &WLEYE
			Endif

			If Empty(WVALI)
				WVALI=".T."
			Endif

			If WTIPO="D"
				If WVALI#".T."
					If !"@WDATO"$Upper( WVALI )
						WVALI = Strtran( Upper( WVALI ), "WDATO", "@WDATO" )
					Endif
				Endif

				F_GET(@WDATO,WLIN,Wcol,WVALI)

			Else
				@ WLIN,Wcol Get WDATO Pict WPICT Valid &WVALI
				Read
				SayMask( WLIN, Wcol, WDATO, WPICT, 0 )

			Endif

			WDAT&WTIPO=WDATO

			If &WPOS
			Endif

			WING=Iif(!&ABORTA,.T.,.F.)

			If WING
				Repl DAT&WTIPO.TR With WDAT&WTIPO
			Endif

		Endif

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return




	*
	* Validacion del Orden de Descarga desde otro comprobante
Procedure ValOrdenDesc( WDATO ) As Boolean;
		HELPSTRING "Validacion del Orden de Descarga desde otro comprobante"

	Local llValid As Boolean
	Local i As Integer
	Local lcChar As Character
	Local lcAux As String

	Try

		llValid = .T.
		lcAux = ""
		For i = 1 To Len( Alltrim( WDATO ))
			lcChar = Substr( WDATO, i, 1 )

			llValid = !Empty( At( lcChar, "PAN" )) And llValid And Empty( At( lcChar, lcAux ))
			lcAux = lcAux + Alltrim( lcChar )
		Endfor

		TEXT To lcMsg NoShow TextMerge Pretext 03
		Los valores admitidos son:
		[P], [A], [N]

		(Sin Repetir)
		ENDTEXT

		I_Valida( llValid, lcMsg )

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return llValid

Endproc && ValDefaDesc


Function PreDeDonde

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(20)
	Return .T.

Function PosDeDonde
	Local lnCol As Integer
	Local lcMsg As String

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO = "R"

			lcReservada = Alltrim( Proper( GetValue( "Reservada", "ar0Ped", "RESERVADA" ) ))
			TEXT To lcMsg NoShow TextMerge Pretext 15
			Cantidad <<lcReservada>>
			ENDTEXT

		Case WDATO = "P"
			lcMsg = "Saldo Pendiente"

	Endcase

	SayMask( WLIN, lnCol, lcMsg, "", 20 )
	Return .T.

Function PreAsientoResumen

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(35)
	Return .T.

Function PosAsientoResumen
	Local lnCol As Integer
	Local lcMsg As String

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO = "I"

			lcMsg = "Por cuenta de cada Item"

		Case WDATO = "T"
			lcMsg = "Por concepto del Importe Total"

	Endcase

	SayMask( WLIN, lnCol, lcMsg, "", 35 )
	Return .T.

Function PreOrdeAuto

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(20)
	Return .T.

Function PosOrdeAuto
	Local lnCol As Integer
	Local lcMsg As String

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO = 1
			lcMsg = "FIFO"

		Case WDATO = 2
			lcMsg = "LIFO"

	Endcase

	SayMask( WLIN, lnCol, lcMsg, "", 20 )
	Return .T.


Function PreFechaAuto

	Local lnCol As Integer

	If Empty(COLUTR)
		lnCol=WCOLU
	Else
		lnCol=COLUTR
	Endif

	@ WLIN,lnCol Say Space(20)
	Return .T.

Function PosFechaAuto
	Local lnCol As Integer
	Local lcMsg As String

	If Empty(COLUTR)
		lnCol=WCOLU

	Else
		lnCol=COLUTR

	Endif

	Do Case
		Case WDATO = 1
			lcMsg = "Fecha del Pedido"

		Case WDATO = 2
			lcMsg = "Fecha de Entrega"

	Endcase

	SayMask( WLIN, lnCol, lcMsg, "", 20 )
	Return .T.

Function PREModo
	Private  Wcol

	Store .F. To  Wcol

	Do Case
		Case Empty(COLUTR)
			Wcol=WCOLU
		Otherwise
			Wcol=COLUTR
	Endcase

	@ WLIN,Wcol Say Space(20)
	Return .T.

Function POSmodo
	Private  Wcol

	Store .F. To  Wcol

	Do Case
		Case Empty(COLUTR)
			Wcol=WCOLU
		Otherwise
			Wcol=COLUTR
	Endcase

	SayMask( WLIN, Wcol, Iif( WDATO=0,"Prueba      ","Produccion"), "", 0 )
	Return .T.

	Note: [F1] Busca Archivo de Certificado

Function PRECERT0
	S_LINE24("Ingrese Archivo de Certificado        [F1]: Buscar")
	On Key Label F1 Do F1CERT0
	Return .T.

Procedure F1CERT0
	WDATO=Getfile( "pfx","","",0, "Archivo de Certificado")

	Return

Function POSCERT0
	SayMask( WLIN, Wcol, WDATO, WPICT, 0 )
	On Key Label F1
	Return .T.

	Note: [F1] Busca Archivo de Licencia

Function PRELICE0
	S_LINE24("Ingrese Archivo de Licencia        [F1]: Buscar")
	On Key Label F1 Do F1LICE0
	Return .T.


Func prePidCuit
	Private Wcol
	Store Null To Wcol
	Do Case
		Case Empty( COLUTR )
			Wcol = WCOLU
		Otherwise
			Wcol = COLUTR
	Endcase
	@ WLIN, Wcol Say Space( 25 )
	Retu .T.


Func posPidCuit
	Private Wcol
	Store Null To Wcol
	Do Case
		Case Empty( COLUTR )
			Wcol = WCOLU
		Otherwise
			Wcol = COLUTR
	Endcase
	Do Case
		Case WDATO = 1
			@ WLIN, Wcol Say "EN FUNCIÓN DEL IMPORTE"
		Case WDATO = 2
			@ WLIN, Wcol Say "SIEMPRE"
		Otherwise
			@ WLIN, Wcol Say "NUNCA"
	Endcase
	Retu .T.

	NOTE:VALIDACION DE DIRECTORIOS CONTABLES

Func VALCUE00
	Para WRUTA
	Do Case
		Case  FileExist( Alltrim( WRUTA ) + "CUENTA.DBF" )
			*!*@ 22, 00
			Retu .T.
		Otherwise
			S_LINE22( "DIRECTORIO INEXISTENTE" )
			Retu .F.
	Endcase

	NOTE:[ F1 ] PARA CUENTAS

Func VACUE00
	S_LINE24( "INGRESE HASTA 8 DIGITOS        [F1]: CONSULTA" )
	* SET KEY 28 TO F1CUE00
	On Key Label F1 Do F1CUE00
	Retu .T.

Proc F1CUE00
	Private WINDE
	Store Null To WINDE
	WINDE = 1
	Sele CUENTA
	F091 = WDATO
	CO_TABCUE( )
	WDATO = F091
	Sele &WARCH2
	Retu

Func VACUE99
	@ WLIN, Wcol Say WDATO Pict WPICT
	* SET KEY 28 TO
	On Key Label F1
	Retu .T.

Func PRE00P3
	Private Wcol
	Store Null To Wcol
	Do Case
		Case Empty( COLUTR )
			Wcol = WCOLU
		Otherwise
			Wcol = COLUTR
	Endcase
	@ WLIN, Wcol Say Space( 10 )
	Retu .T.

Func POS00P3
	Private Wcol
	Store Null To Wcol
	Do Case
		Case Empty( COLUTR )
			Wcol = WCOLU
		Otherwise
			Wcol = COLUTR
	Endcase
	@ WLIN, Wcol Say Iif( WDATO = "S", "SUBDIARIO", "DIARIO   " )
	Retu .T.



Func PreOrdenaDeudores
	Private Wcol
	Store Null To Wcol
	Do Case
		Case Empty( COLUTR )
			Wcol = WCOLU
		Otherwise
			Wcol = COLUTR
	Endcase
	@ WLIN, Wcol Say Space( 20 )
	Retu .T.

Func PosOrdenaDeudores
	Private Wcol
	Store Null To Wcol
	Do Case
		Case Empty( COLUTR )
			Wcol = WCOLU
		Otherwise
			Wcol = COLUTR
	Endcase
	@ WLIN, Wcol Say Iif( WDATO = "V", "Vencimiento", "Emisión" )
	Retu .T.



Procedure F1LICE0
	WDATO=Getfile( "lic","","",0, "Archivo de Licencia")

	Return

Function POSLICE0
	SayMask( WLIN, Wcol, WDATO, WPICT, 0 )
	On Key Label F1
	Return .T.



Func VALFEAC
	Para WDATO
	LVALID = I_VALIGU( Mod( WDATO, 24 ), 0 )
	Retu LVALID


	NOTE:  ACTUALIZACION

Procedure Actua00P

	Local lcCommand As String

	Try

		lcCommand = ""

		Sele Alias( WARCH )
		Locate

		Scan For R7MOV = "M" && !Empty(ORDETR)

			WTIPO=TIPOTR
			WCAMP=Alltrim(CAMPTR)
			WSELE=Alltrim(SELETR)

			Sele Alias( WSELE )
			M_INIACT(2)

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Replace <<WCAMP>> With <<WARCH>>.DAT<<WTIPO>>TR
			ENDTEXT

			&lcCommand
			lcCommand = ""

			Unlock

			Sele Alias( WARCH )

			If !Empty( ACTUTR )
				=Evaluate( Alltrim( ACTUTR ))
			Endif

		Endscan

		* RA 18/05/2019(12:39:26)
		* Sincronizar con Parámetros de Implementación
		* y Actualizar variables Globales
		SincronizarCon_ArParame()



	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally


	Endtry

	Return


	*
	*
Procedure SincronizarCon_ArParame(  ) As Void
	Local lcCommand As String,;
		lcPictCant As String,;
		lcPictPrec As String

	Local lnAt As Integer

	Try

		lcCommand = ""

		lcPictCant = Strtran( Alltrim( GetValue( "PictCant", "ar0Art", "999" )), ",", "" )
		lcPictPrec = Strtran( Alltrim( GetValue( "PictPrec", "ar0Art", "999,999.99" )), ",", "" )

		lnAt = At( ".", lcPictCant )
		If Empty( lnAt )
			KDECU = 0
			KENCU = Len( lcPictCant )

		Else
			KDECU = Len( Substr( lcPictCant, lnAt + 1 ))
			KENCU = Len( Substr( lcPictCant, 1, lnAt - 1 ))

		Endif

		lnAt = At( ".", lcPictPrec )
		If Empty( lnAt )
			KDEPU = 0
			KENPU = Len( lcPictPrec )

		Else
			KDEPU = Len( Substr( lcPictPrec, lnAt + 1 ))
			KENPU = Len( Substr( lcPictPrec, 1, lnAt - 1 ))

		Endif

		M_USE( 0, Trim( DRVA ) + "ar0Est" )
		Select ar0Est
		M_INIACT( 52 )

		Try

			Replace DECU0 With KDECU,;
				DEPU0 With KDEPU,;
				ENCU0 With KENCU,;
				ENPU0 With KENPU

			Unlock

		Catch To oErr

		Finally

		Endtry

		* PICTURE CANTIDAD
		WPICC = ConvertInputMask( KENCU + Iif( Empty( KDECU ), 0, KDECU + 1 ), KDECU )
		WPICC_S = ConvertInputMask( KENCU + Iif( Empty( KDECU ), 0, KDECU + 1 ), KDECU, '#', .T. )

		If Empty( KDECU )
			TEXT To Msg_Cantidad NoShow TextMerge Pretext 15
			Ingrese hasta <<KENCU>> dígitos
			ENDTEXT

		Else
			TEXT To Msg_Cantidad NoShow TextMerge Pretext 15
			Ingrese hasta <<KENCU>> dígitos enteros y <<KDECU>> decimales
			ENDTEXT

		Endif

		* PICTURE PRECIO
		WPICP = ConvertInputMask( KENPU + Iif( Empty( KDEPU ), 0, KDEPU + 1 ), KDEPU )
		WPICP_S = ConvertInputMask( KENPU + Iif( Empty( KDEPU ), 0, KDEPU + 1 ), KDEPU, '#', .T.  )

		If Empty( KDEPU )
			TEXT To Msg_Precio NoShow TextMerge Pretext 15
			Ingrese hasta <<KENPU>> dígitos
			ENDTEXT

		Else
			TEXT To Msg_Precio NoShow TextMerge Pretext 15
			Ingrese hasta <<KENPU>> dígitos enteros y <<KDEPU>> decimales
			ENDTEXT

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && SincronizarCon_ArParame

NOTE: SEPARADOR POR PANTALLAS

Procedure Page00P
	Try

		Do While .T.
			If Empty(Mod(LASTREC(),WLEN))
				Exit
			Endif

			Appe Blan
		Enddo

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return

	NOTE: SELECCIONAR OPCION

	*
	*
Procedure ElegirOpcion( oOpciones As Collection ) As Void
	Local lcCommand As String
	Local loOpcion As Object
	Local i As Integer,;
		lnOpcion As Integer,;
		lnId As Integer


	Try

		lcCommand = ""
		lnId = 0

		For i = 1 To oOpciones.Count
			loOpcion = oOpciones.Item( i )
			aPara[ i ] = loOpcion.Descripcion
		Endfor

		lnOpcion = S_OPCION( -1, -1, 0, 0, "aPara", 1, .F., "Parámetros" )

		If !&ABORTA
			loOpcion = oOpciones.Item( lnOpcion )
			lnId = loOpcion.Id
		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnId

Endproc && ElegirOpcion



Function Opcion00P
	Para WOPCI
	Private WI,WLEN,WTOP,WBOT,WIZQ,WDER
	Store .F. To WI,WLEN,WTOP,WBOT,WIZQ,WDER

	Try

		aPara[ PRM_Todos ]			= "Todos"
		aPara[ PRM_Artículo ]		= "Artículo"
		aPara[ PRM_Ventas ]			= "Ventas"
		aPara[ PRM_Deudores ]		= "Deudores"
		aPara[ PRM_Estadisticas ]	= "Estadísticas"
		aPara[ PRM_Presupuestos ]	= "Presupuestos"
		aPara[ PRM_Compras ]		= "Compras"
		aPara[ PRM_Pedidos ]		= "Pedidos"
		aPara[ PRM_Valores ]		= "Valores"
		aPara[ PRM_Stock ]			= "Stock"
		aPara[ PRM_Varios ]			= "Varios"
		aPara[ PRM_Exportar ]		= "Carpetas y Listados"
		aPara[ PRM_Auditoria ]		= "Auditoria"
		aPara[ PRM_Impuestos ]		= "Impuestos"
		aPara[ PRM_Pasajes ]		= "Pasajes"
		aPara[ PRM_FactEle ]		= "Facturación Electrónica"

		WLEN=0
		For WI=1 To PRM_Len
			WLEN=Max(WLEN,Len(aPara[WI]))
		Next

		For WI=1 To PRM_Len
			WLEN=Max(WLEN,Len(aPara[WI]))
			aPara[WI]=Substr(aPara[WI]+Space(WLEN),1,WLEN)
			aPara[WI]=" "+Chr(64+WI)+" - "+aPara[WI]+" "
		Next

		WLEN=Len(aPara[1])
		WTOP=10-Int(PRM_Len/2)
		WBOT=WTOP+PRM_Len+01
		WIZQ=Int(40-(WLEN/2))-01
		WDER=WIZQ+WLEN+01

		S_CLEAR(WTOP,WIZQ,WBOT,WDER)
		WOPCI = S_OPCION( WTOP, WIZQ, WBOT, WDER, "aPara", 1 )
		S_CLEAR(WTOP,WIZQ,WBOT,WDER)

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return WOPCI
Endfunc

*
Procedure Articulos( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try
		* Artículo

		loOpcion = loOpciones.GetItem( PRM_Artículo )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "UsaGrupo",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Grupo?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Art",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"


		If GetValue( "UsaGrupo", "ar0Art", "S" ) == "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "GrupoAlfa",;
				PICTTR With "!",;
				DESCTR With "Grupo Numérico/AlfaNumérico",;
				LEYETR With "S_LINE24( '[N] Numérico    [A] Alfanumérico' )",;
				PREFTR With "PreNumAlfa()",;
				POSFTR With "PosNumAlfa()",;
				VALITR With "I_Valida( InList( WDATO, 'A', 'N' ))",;
				SELETR With "ar0Art",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "LenGrupo",;
				PICTTR With "9",;
				DESCTR With "Longitud Grupo",;
				LEYETR With "S_ACLNRO(1)",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "I_VALMAY( WDATO, 0 )",;
				SELETR With "ar0Art",;
				ORDETR With WORDE,;
				DEFATR With "3"

			If GetValue( "GrupoAlfa", "ar0Art", "N" ) == "N"
				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "GrupoCeros",;
					PICTTR With "!",;
					DESCTR With "¿Completa Grupo con CEROS a la izquierda?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Art",;
					ORDETR With WORDE ,;
					WIDTTR With 1,;
					DEFATR With "N"

			Else
				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "GRightJust",;
					PICTTR With "!",;
					DESCTR With "¿Justifica Grupo a la DERECHA?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Art",;
					ORDETR With WORDE ,;
					WIDTTR With 1,;
					DEFATR With "N"

			Endif

		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "UsaLinea",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Línea?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Art",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "N"


		If GetValue( "UsaLinea", "ar0Art", "S" ) == "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "LinCodAtr",;
				PICTTR With "!",;
				DESCTR With "La Línea es Atributo o parte del Código",;
				LEYETR With "S_LINE24( '[A] Atributo    [C] Código' )",;
				PREFTR With "PreCodAtr()",;
				POSFTR With "PosCodAtr()",;
				VALITR With "I_Valida( InList( WDATO, 'A', 'C' ))",;
				SELETR With "ar0Art",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "A"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "LineaAlfa",;
				PICTTR With "!",;
				DESCTR With "Línea Numérico/AlfaNumérico",;
				LEYETR With "S_LINE24( '[N] Numérico    [A] Alfanumérico' )",;
				PREFTR With "PreNumAlfa()",;
				POSFTR With "PosNumAlfa()",;
				VALITR With "I_Valida( InList( WDATO, 'A', 'N' ))",;
				SELETR With "ar0Art",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "LenLinea",;
				PICTTR With "9",;
				DESCTR With "Longitud Línea",;
				LEYETR With "S_ACLNRO(1)",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "I_VALMAY( WDATO, 0 )",;
				SELETR With "ar0Art",;
				ORDETR With WORDE,;
				DEFATR With "3"

			If GetValue( "LineaAlfa", "ar0Art", "N" ) == "N"
				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "LineaCeros",;
					PICTTR With "!",;
					DESCTR With "¿Completa Línea con CEROS a la izquierda?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Art",;
					ORDETR With WORDE ,;
					WIDTTR With 1,;
					DEFATR With "N"

			Else
				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "LRightJust",;
					PICTTR With "!",;
					DESCTR With "¿Justifica Linea a la DERECHA?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Art",;
					ORDETR With WORDE ,;
					WIDTTR With 1,;
					DEFATR With "N"

			Endif

		Endif


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ArtAlfa",;
			PICTTR With "!",;
			DESCTR With "Articulo Numérico/AlfaNumérico",;
			LEYETR With "S_LINE24( '[N] Numérico    [A] Alfanumérico' )",;
			PREFTR With "PreNumAlfa()",;
			POSFTR With "PosNumAlfa()",;
			VALITR With "I_Valida( InList( WDATO, 'A', 'N' ))",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "I",;
			CAMPTR With "LenArt",;
			PICTTR With "99",;
			DESCTR With "Longitud Articulo",;
			LEYETR With "S_ACLNRO(2)",;
			PREFTR With "",;
			POSFTR With "",;
			VALITR With "I_VALMAY( WDATO, 0 )",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			DEFATR With "8"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "PictArt",;
			PICTTR With Replicate( '!', 20 ),;
			DESCTR With "Picture Artículo",;
			LEYETR With "S_ACLSTR( 20 )",;
			PREFTR With "",;
			POSFTR With "",;
			VALITR With "I_ValObl( WDATO)",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 20,;
			DEFATR With "999-99999999"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "PictCant",;
			PICTTR With Replicate( '!', 20 ),;
			DESCTR With "Picture Cantidad",;
			LEYETR With "S_ACLSTR( 20 )",;
			PREFTR With "",;
			POSFTR With "",;
			VALITR With "I_ValObl( WDATO)",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 20,;
			DEFATR With "999"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "PictPrec",;
			PICTTR With Replicate( '!', 20 ),;
			DESCTR With "Picture Precio Unitario",;
			LEYETR With "S_ACLSTR( 20 )",;
			PREFTR With "",;
			POSFTR With "",;
			VALITR With "I_ValObl( WDATO)",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 20,;
			DEFATR With "999,999.99"

		If GetValue( "ArtAlfa", "ar0Art", "N" ) == "N"
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ArtCeros",;
				PICTTR With "!",;
				DESCTR With "¿Completa Artículo con CEROS a la izquierda?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Art",;
				ORDETR With WORDE ,;
				WIDTTR With 1,;
				DEFATR With "N"

		Else
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ARightJust",;
				PICTTR With "!",;
				DESCTR With "¿Justifica Artículo a la DERECHA?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Art",;
				ORDETR With WORDE ,;
				WIDTTR With 1,;
				DEFATR With "N"

		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "UsaAlias",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Alias?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "UsaBarras",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Código de Barras?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "OrdenGet",;
			PICTTR With "!!!!",;
			DESCTR With "Orden de pedido",;
			LEYETR With "S_LINE24( '[C] Código Artículo   [D] Descripción    [A] Alias    [B] Código de Barras' )",;
			PREFTR With "",;
			POSFTR With "",;
			VALITR With "ValOrdenGet( WDATO )",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 4,;
			DEFATR With "CD"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "CodStock",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Código de Stock?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "UsaTalle",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Talle?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "UsaColor",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Color?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"



		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "I",;
			CAMPTR With "Listas",;
			PICTTR With "99",;
			DESCTR With "Cantidad de Listas de Precio",;
			LEYETR With "S_ACLNRO(2)",;
			PREFTR With "",;
			POSFTR With "",;
			VALITR With "I_VALMAY( WDATO, 0 )",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			DEFATR With "1"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "Servicios",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Artículos para Productos y Servicios?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "AdvSearch",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Búsqueda Avanzada?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Art",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		If GetValue( "AdvSearch", "ar0Art", "S" ) == "S"
			If GetValue( "UsaGrupo", "ar0Art", "S" ) == "S"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "ASGrupo",;
					PICTTR With "!",;
					DESCTR With "¿Incluye el Grupo en Búsqueda Avanzada?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Art",;
					ORDETR With WORDE,;
					WIDTTR With 1,;
					DEFATR With "N"

				If GetValue( "UsaLinea", "ar0Art", "S" ) == "S"

					Appe Blan
					WORDE=WORDE+1
					Repl TIPOTR With "C",;
						CAMPTR With "ASLinea",;
						PICTTR With "!",;
						DESCTR With "¿Incluye la Línea en Búsqueda Avanzada?",;
						LEYETR With "S_LINE24(MSG24)",;
						PREFTR With "PreSiNo()",;
						POSFTR With "PosSiNo()",;
						VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
						SELETR With "ar0Art",;
						ORDETR With WORDE,;
						WIDTTR With 1,;
						DEFATR With "N"

				Endif

			Endif
		Endif


	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Articulos



*
*
Procedure Ventas( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void

	Local lcMsg As String

	Try

		loOpcion = loOpciones.GetItem( PRM_Ventas )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		*!*			Appe Blan
		*!*			WORDE=WORDE+1
		*!*			Repl TIPOTR With "C",;
		*!*				CAMPTR With "Monotrib_A",;
		*!*				PICTTR With "!",;
		*!*				DESCTR With "¿Genera comprobante 'A' a Monotributistas?",;
		*!*				LEYETR With "S_LINE24(MSG24)",;
		*!*				PREFTR With "PreSiNo()",;
		*!*				POSFTR With "PosSiNo()",;
		*!*				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
		*!*				SELETR With "ar0Ven",;
		*!*				ORDETR With WORDE,;
		*!*				WIDTTR With 1,;
		*!*				DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "D",;
			CAMPTR With "Mono_Fecha",;
			PICTTR With "",;
			DESCTR With "Fecha Inicio Factura [A] a Monotributistas",;
			VALITR With "I_VALMOI( WDATO, {^2021/07/01} )",;
			LEYETR With "",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Ven",;
			ORDETR With WORDE,;
			DEFATR With Dtoc( {^2021/07/01} )

		* If GetValue( "Monotrib_A", "ar0Ven", "N" ) == "S"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "M",;
			CAMPTR With "Mono_Leye",;
			PICTTR With Replicate( 'X', 35 ),;
			DESCTR With "Leyenda en Factura a Monotributista",;
			LEYETR With "Ingrese la leyenda de la Factura a Monotributistas",;
			PREFTR With "PreMemoEdit()",;
			POSFTR With "PosMemoEdit()",;
			VALITR With "",;
			SELETR With "ar0Ven",;
			ORDETR With WORDE,;
			DEFA_M With "El crédito fiscal discriminado en el presente comprobante, sólo podrá ser computado a efectos del Régimen de Sostenimiento e Inclusión Fiscal para Pequeños Contribuyentes de la Ley Nº 27.618"

		* Endif

		If Inlist( WCLAV, "B", "M" )
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "NumFacR",;
				PICTTR With "999999",;
				DESCTR With 'Último Número Comprobante "R"',;
				LEYETR With "S_ACLNRO(6)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 6,;
				DECITR With 0

		Endif

		If Inlist( WCLAV, "A", "M" )

			lcMsg = "¿Usa " + Alltrim( GetTasaIva( IVA_CERO_ID, "C" )) + "?"
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "UsaIva_3",;
				PICTTR With "!",;
				DESCTR With lcMsg,;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "S"


			lcMsg = "¿Usa " + Alltrim( GetTasaIva( IVA_DIFERENCIADO_ID, "C" )) + "?"
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "UsaIva_6",;
				PICTTR With "!",;
				DESCTR With lcMsg,;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"


			lcMsg = "¿Usa " + Alltrim( GetTasaIva( IVA_MGRAF9_ID, "C" )) + "?"
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "UsaIva_9",;
				PICTTR With "!",;
				DESCTR With lcMsg,;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			lcMsg = "¿Usa " + Alltrim( GetTasaIva( IVA_MGRAF8_ID, "C" )) + "?"
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "UsaIva_8",;
				PICTTR With "!",;
				DESCTR With lcMsg,;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "DiscriB",;
				PICTTR With "!",;
				DESCTR With "¿Discrimina Comprobantes 'B' en Iva Ventas?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "MinCli",;
				PICTTR With "999999",;
				DESCTR With 'Primer Cliente Válido',;
				LEYETR With "S_ACLNRO(6)",;
				VALITR With "I_VALMAY(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 6,;
				DECITR With 0

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "MaxCli",;
				PICTTR With "999999",;
				DESCTR With 'Último Cliente Válido',;
				LEYETR With "S_ACLNRO(6)",;
				VALITR With "I_VALMAY(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 6,;
				DECITR With 0

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "Cli9999",;
				PICTTR With Replicate("9", gnCodi4 ),;
				DESCTR With 'Cliente No Codificado',;
				LEYETR With "S_ACLNRO(gnCodi4)",;
				VALITR With "I_VALMAY(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With gnCodi4,;
				DECITR With 0,;
				DEFATR With "9999"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "UsaAlias",;
				PICTTR With "!",;
				DESCTR With "¿Utiliza Alias de Cliente?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "Usa_Cuil",;
				PICTTR With "!",;
				DESCTR With "¿Exije Cuil en Consumidor Final?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "Tope0",;
				PICTTR With "999999.99",;
				DESCTR With 'Tope Consumidor Final',;
				LEYETR With "S_Line24([Por encima de éste tope debe identificarse])",;
				VALITR With "I_VALMAY(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 9,;
				DECITR With 2,;
				DEFATR With "10000"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "TipoM",;
				PICTTR With "!",;
				DESCTR With "Utiliza Tipo 'M' en lugar de 'A'",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "FCE_PtoVta",;
				PICTTR With "9999",;
				DESCTR With "Punto de Venta FCE",;
				LEYETR With "",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "I_VALMOI(WDATO,0)",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				DEFATR With "0"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "PideJuri",;
				PICTTR With "!",;
				DESCTR With "¿Pide Jurisdicción?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "S"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "JuriDefa",;
				PICTTR With "999",;
				DESCTR With "Jurisdicción por Default",;
				LEYETR With "",;
				PREFTR With "PreZona()",;
				POSFTR With "PosZona()",;
				VALITR With "",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				DEFATR With "1"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ClauMone",;
				PICTTR With "!",;
				DESCTR With "¿Clausula Moneda Extranjera?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "PideDesp",;
				PICTTR With "!",;
				DESCTR With "¿Pide Despacho?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "PideLote",;
				PICTTR With "!",;
				DESCTR With "¿Pide Lote?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "PideOCom",;
				PICTTR With "!",;
				DESCTR With "¿Pide Orden de Compra general?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "OComItem",;
				PICTTR With "!",;
				DESCTR With "¿Pide Orden de Compra por Item?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "BonItem",;
				PICTTR With "!",;
				DESCTR With "¿Pide Bonificación por Item?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "S"

			If GetValue( "BonItem", "Ar0Ven", "N" ) = "S"
				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "N",;
					CAMPTR With "CantBoni",;
					PICTTR With "9",;
					DESCTR With 'Cantidad de Descuentos por Item ( 1 ... 3 )',;
					LEYETR With "S_ACLNRO(1)",;
					VALITR With "I_VALRAN(WDATO, 1, 3)",;
					PREFTR With "",;
					POSFTR With "",;
					SELETR With "ar0Ven",;
					ORDETR With WORDE,;
					WIDTTR With 1,;
					DECITR With 0
			Endif


			If GetValue( "UsaTalle", "ar0Art", "N" ) == "S" ;
					Or GetValue( "UsaColor", "ar0Art", "N" ) == "S"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "TalleColor",;
					PICTTR With "!",;
					DESCTR With "¿Maneja Talle y Color?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Ven",;
					ORDETR With WORDE,;
					WIDTTR With 1,;
					DEFATR With "N"
			Endif


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "EditDeta",;
				PICTTR With "!",;
				DESCTR With "¿Edita Descripción Detallada?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ModificaPU",;
				PICTTR With "!",;
				DESCTR With "¿Modifica Precio Unitario?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "S"

			If .F. && Solo lo usaba Sistec

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "AgregaMes",;
					PICTTR With "!",;
					DESCTR With "¿Agrega automáticamente el mes del servicio?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Ven",;
					ORDETR With WORDE,;
					WIDTTR With 1,;
					DEFATR With "N"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "I",;
					CAMPTR With "MesFactura",;
					PICTTR With "99",;
					DESCTR With "Mes Facturado",;
					LEYETR With "S_LINE24( '[0] Actual   [-n] Mes Anterior    [+n] Mes Posterior' )",;
					PREFTR With "",;
					POSFTR With "",;
					SELETR With "ar0Ven",;
					ORDETR With WORDE,;
					DEFATR With "-1"

			Endif

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "ItemsFact",;
				PICTTR With "999",;
				DESCTR With "Cantidad de Items en Factura",;
				LEYETR With "S_ACLNRO(3)",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "I_VALMAY( WDATO, 0 )",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				DEFATR With "999"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "Conc999",;
				PICTTR With "999",;
				DESCTR With "Código de Concepto para Articulos No Codificados",;
				LEYETR With "S_ACLNRO(3)",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "I_VALMAY( WDATO, 0 )",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				DEFATR With "0"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "AsiResu",;
				PICTTR With "!",;
				DESCTR With "Genera Asiento Resúmen",;
				LEYETR With "S_LINE24( '[I] Por Items    [T] Por Totales' )",;
				PREFTR With "PreAsientoResumen()",;
				POSFTR With "PosAsientoResumen()",;
				VALITR With "I_Valida( InList( WDATO, 'I', 'T' ))",;
				SELETR With "ar0Ven",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "I"



			If .F.	&& Ya no se usa

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "NumFcA",;
					PICTTR With "!!!!!",;
					DESCTR With "Numerador Facturas 'A'",;
					LEYETR With "S_LINE24('Nombre del Campo en el archivo de estado')",;
					PREFTR With "",;
					POSFTR With "",;
					VALITR With "",;
					SELETR With "ar0Ven",;
					ORDETR With WORDE,;
					WIDTTR With 5,;
					DEFATR With "FCA01"


				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "NumFcA",;
					PICTTR With "!!!!!",;
					DESCTR With "Numerador Facturas 'A'",;
					LEYETR With "S_LINE24('Nombre del Campo en el archivo de estado')",;
					PREFTR With "",;
					POSFTR With "",;
					VALITR With "",;
					SELETR With "ar0Ven",;
					ORDETR With WORDE,;
					WIDTTR With 5,;
					DEFATR With "FCA01"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "NumNcA",;
					PICTTR With "!!!!!",;
					DESCTR With "Numerador N. Crédito 'A'",;
					LEYETR With "S_LINE24('Nombre del Campo en el archivo de estado')",;
					PREFTR With "",;
					POSFTR With "",;
					VALITR With "",;
					SELETR With "ar0Ven",;
					ORDETR With WORDE,;
					WIDTTR With 5,;
					DEFATR With "NCA01"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "NumNdA",;
					PICTTR With "!!!!!",;
					DESCTR With "Numerador N. Débito 'A'",;
					LEYETR With "S_LINE24('Nombre del Campo en el archivo de estado')",;
					PREFTR With "",;
					POSFTR With "",;
					VALITR With "",;
					SELETR With "ar0Ven",;
					ORDETR With WORDE,;
					WIDTTR With 5,;
					DEFATR With "NDA01"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "NumFcB",;
					PICTTR With "!!!!!",;
					DESCTR With "Numerador Facturas 'B'",;
					LEYETR With "S_LINE24('Nombre del Campo en el archivo de estado')",;
					PREFTR With "",;
					POSFTR With "",;
					VALITR With "",;
					SELETR With "ar0Ven",;
					ORDETR With WORDE,;
					WIDTTR With 5,;
					DEFATR With "FCB01"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "NumNcB",;
					PICTTR With "!!!!!",;
					DESCTR With "Numerador N. Crédito 'B'",;
					LEYETR With "S_LINE24('Nombre del Campo en el archivo de estado')",;
					PREFTR With "",;
					POSFTR With "",;
					VALITR With "",;
					SELETR With "ar0Ven",;
					ORDETR With WORDE,;
					WIDTTR With 5,;
					DEFATR With "NCB01"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "NumNdB",;
					PICTTR With "!!!!!",;
					DESCTR With "Numerador N. Débito 'B'",;
					LEYETR With "S_LINE24('Nombre del Campo en el archivo de estado')",;
					PREFTR With "",;
					POSFTR With "",;
					VALITR With "",;
					SELETR With "ar0Ven",;
					ORDETR With WORDE,;
					WIDTTR With 5,;
					DEFATR With "NDB01"

			Endif

		Endif


	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Ventas


*
*
Procedure Deudores( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try

		loOpcion = loOpciones.GetItem( PRM_Deudores )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "VistaPrev",;
			PICTTR With "!",;
			DESCTR With "¿Vista previa de comprobantes en Resumen de Cuentas?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Deu",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "N"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "I",;
			CAMPTR With "FiltVend",;
			PICTTR With "9",;
			DESCTR With "Filtro por Vendedor",;
			LEYETR With "S_LINE24( '[1]: Del Comprobante     [2]: Asignado al Cliente' )",;
			PREFTR With "PreFiltVend()",;
			POSFTR With "PosFiltVend()",;
			SELETR With "ar0Deu",;
			ORDETR With WORDE,;
			DEFATR With "1"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "CtrlCred",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Control de Crédito al Facturar?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Deu",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "N"

		If ( GetValue( "CtrlCred", "ar0Deu", "N" ) = "S" )

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "crComSal",;
				PICTTR With "!",;
				DESCTR With "¿Incluye Deuda en Cuenta Corriente?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Deu",;
				ORDETR With WORDE ,;
				WIDTTR With 1,;
				DEFATR With "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "crValores",;
				PICTTR With "!",;
				DESCTR With "¿Incluye Valores de Terceros Posdatados?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Deu",;
				ORDETR With WORDE ,;
				WIDTTR With 1,;
				DEFATR With "S"

			If ( GetValue( "Pedidos", "ar0Ped", "N" ) == "S" )

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "crPedidos",;
					PICTTR With "!",;
					DESCTR With "¿Incluye Pedidos Sin Facturar?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Deu",;
					ORDETR With WORDE ,;
					WIDTTR With 1,;
					DEFATR With "S"

			Endif

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "crSiempre",;
				PICTTR With "!",;
				DESCTR With "¿Muestra aunque valide?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Deu",;
				ORDETR With WORDE ,;
				WIDTTR With 1,;
				DEFATR With "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "crNivel",;
				PICTTR With "9",;
				DESCTR With "Nivel de Autorización",;
				LEYETR With "S_LINE24( '[0]: No Necesita     [1 ... 5]: Nivel necesario' )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Deu",;
				ORDETR With WORDE,;
				DEFATR With "0"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "crDias",;
				PICTTR With "999",;
				DESCTR With "Antigüedad de la Deuda",;
				LEYETR With "S_LINE24( '[0]: No Necesita     [999]: Días de Antigüedad Permitidos' )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Deu",;
				ORDETR With WORDE,;
				DEFATR With "0"


		Endif



	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Deudores



*
*
Procedure Estadisticas( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try

		loOpcion = loOpciones.GetItem( PRM_Estadisticas )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "I",;
			CAMPTR With "CabeDeta",;
			PICTTR With "9",;
			DESCTR With "Estadística de Ventas",;
			LEYETR With "S_LINE24( '[1]: Recorre Cabecera     [2]: Recorre Detalle' )",;
			PREFTR With "PreCabeDeta()",;
			POSFTR With "PosCabeDeta()",;
			SELETR With "ar0Estadi",;
			ORDETR With WORDE,;
			DEFATR With "2"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "UsaJuri",;
			PICTTR With "!",;
			DESCTR With "¿Usa Jurisdicciones?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Estadi",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "UsaIndu",;
			PICTTR With "!",;
			DESCTR With "¿Usa Industrias?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Estadi",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "N"



	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Estadisticas


*
*
Procedure Compras( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try

		loOpcion = loOpciones.GetItem( PRM_Compras )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "NroInterno",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Número Interno?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Com",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "PideItems",;
			PICTTR With "!",;
			DESCTR With "¿Pide Items en Facturas?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Com",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "N"


		If GetValue( "PideItems", "ar0Com", "N" ) = "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "PregAntes",;
				PICTTR With "!",;
				DESCTR With "¿Pregunta Antes de Pedir Items?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Com",;
				ORDETR With WORDE ,;
				WIDTTR With 1,;
				DEFATR With "N"

		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "FechaVenc",;
			PICTTR With "!",;
			DESCTR With "¿Pide Fecha de Vencimiento en Facturas?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Com",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"


		lcMsg = "¿Usa " + Alltrim( GetTasaIva( IVA_MGRAF9_ID, "C" )) + "?"
		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "UsaIva_9",;
			PICTTR With "!",;
			DESCTR With lcMsg,;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Com",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		lcMsg = "¿Usa " + Alltrim( GetTasaIva( IVA_MGRAF8_ID, "C" )) + "?"
		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "UsaIva_8",;
			PICTTR With "!",;
			DESCTR With lcMsg,;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Com",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "I",;
			CAMPTR With "IvasCant",;
			PICTTR With "9",;
			DESCTR With "Cantidad de Alicuotas Diferentes",;
			LEYETR With "S_LINE24( '[3]     [5]' )",;
			PREFTR With "",;
			POSFTR With "",;
			VALITR With "I_Valida( InList( WDATO, 3, 5 ))",;
			SELETR With "ar0Com",;
			ORDETR With WORDE,;
			DEFATR With "3"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "PideConc",;
			PICTTR With "!",;
			DESCTR With "Pide Concepto en Facturas",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Com",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "DocuAdua",;
			PICTTR With "!",;
			DESCTR With "Usa Documento Aduanero",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Com",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "N",;
			CAMPTR With "MinPro",;
			PICTTR With "9999",;
			DESCTR With 'Primer Proveedor Válido',;
			LEYETR With "S_ACLNRO(6)",;
			VALITR With "I_VALMAY(WDATO, 0 )",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Com",;
			ORDETR With WORDE,;
			WIDTTR With 6,;
			DECITR With 0,;
			DEFATR With "1"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "N",;
			CAMPTR With "MaxPro",;
			PICTTR With "9999",;
			DESCTR With 'Último Proveedor Válido',;
			LEYETR With "S_ACLNRO(6)",;
			VALITR With "I_VALMAY(WDATO, 0 )",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Com",;
			ORDETR With WORDE,;
			WIDTTR With 6,;
			DECITR With 0,;
			DEFATR With "9999"

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Compras

*
*
Procedure Pedidos( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try

		loOpcion = loOpciones.GetItem( PRM_Pedidos )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "Pedidos",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Módulo de Pedidos?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			FOLDTR With "drvPed",;
			SELETR With "ar0Ped",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		If ( GetValue( "Pedidos", "ar0Ped", "N" ) == "S" )

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "NumPedido",;
				PICTTR With "99999999",;
				DESCTR With 'Último Número de Pedidos',;
				LEYETR With "S_ACLNRO(8)",;
				VALITR With "I_VALMOI(WDATO,0)",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 8,;
				DECITR With 0

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "SucPedido",;
				PICTTR With "9999",;
				DESCTR With 'Sucursal de Pedidos',;
				LEYETR With "S_ACLNRO(4)",;
				VALITR With "I_VALMOI(WDATO,0)",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 4,;
				DECITR With 0

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "Copias",;
				PICTTR With "9",;
				DESCTR With 'Cantidad de Copias',;
				LEYETR With "S_ACLNRO(1)",;
				VALITR With "I_VALMOI(WDATO,0)",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "DescPedido",;
				PICTTR With "!",;
				DESCTR With "¿Descarga de Otro Pedido?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "S"

			If ( GetValue( "UsaPresup", "ar0Presu", "N" ) == "S" )
				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "DescPresu",;
					PICTTR With "!",;
					DESCTR With "¿Descarga de Presupuesto?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Ped",;
					ORDETR With WORDE,;
					WIDTTR With 1,;
					DEFATR With "N"
			Endif


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "DatosEntr",;
				PICTTR With "!",;
				DESCTR With "¿Pide datos de entrega?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "FechEntr",;
				PICTTR With "!",;
				DESCTR With "¿Pide Fecha de Entrega por Item?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "OrdenGet",;
				PICTTR With "!!!",;
				DESCTR With "Tipo y Orden de Descarga desde Facturas",;
				LEYETR With "S_LINE24( '[P] Nº de Pedido   [A] Automático    [N] No Descarga' )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "ValOrdenGet( WDATO )",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 3,;
				DEFATR With "PAN"

			lcReservada = Alltrim( Proper( GetValue( "Reservada", "ar0Ped", "RESERVADA", drvPed ) ))
			TEXT To lcLeye NoShow TextMerge Pretext 15
			S_LINE24( '[R] Cantidad <<lcReservada>>    [P] Saldo Pendiente' )
			ENDTEXT

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "DeDonde",;
				PICTTR With "!",;
				DESCTR With "Descarga desde",;
				LEYETR With lcLeye,;
				PREFTR With "PreDeDonde()",;
				POSFTR With "PosDeDonde()",;
				VALITR With "I_Valida( InList( WDATO, 'R', 'P' ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "P"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "MultiPed",;
				PICTTR With "!",;
				DESCTR With "¿Descarga de varios Nº de Pedido?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"


			TEXT To lcDesc NoShow TextMerge Pretext 15
			Como denomina la cantidad [<<Upper(lcReservada)>>]
			ENDTEXT

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "Reservada",;
				PICTTR With Replicate( "!", 15 ),;
				DESCTR With lcDesc,;
				LEYETR With "S_AclStr( 15 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "I_ValObl( WDATO )",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 15,;
				DEFATR With "RESERVADA"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "OrdeAuto",;
				PICTTR With "9",;
				DESCTR With "Orden de Descarga Automática",;
				LEYETR With "S_LINE24( '[1] FIFO    [2] LIFO' )",;
				PREFTR With "PreOrdeAuto()",;
				POSFTR With "PosOrdeAuto()",;
				VALITR With "I_Valida( InList( WDATO, 1, 2 ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				DEFATR With "1"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "FechaAuto",;
				PICTTR With "9",;
				DESCTR With "Fecha de Descarga Automática",;
				LEYETR With "S_LINE24( '[1] Fecha del Pedido    [2] Fecha de Entrega' )",;
				PREFTR With "PreFechaAuto()",;
				POSFTR With "PosFechaAuto()",;
				VALITR With "I_Valida( InList( WDATO, 1, 2 ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				DEFATR With "1"


			* RA 2014-05-03(17:57:14)
			* Si la descarga FIFO no encuentra pedido de donde descargar
			* genera un pedido automático y descarga del mismo
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "GenPedido",;
				PICTTR With "!",;
				DESCTR With "¿Genera Pedido en Descarga Automática?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ItemRepe",;
				PICTTR With "!",;
				DESCTR With "¿Permite Items Repetidos?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			dFecha = GetValue( "Feca0", "ar0Est" )

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "D",;
				CAMPTR With "FechaIni",;
				PICTTR With "",;
				DESCTR With "Primer Fecha Válida",;
				VALITR With "I_VALMOI( WDATO, dFecha )",;
				LEYETR With "",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				DEFATR With Dtoc( dFecha )


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "Modifica",;
				PICTTR With "!",;
				DESCTR With "¿Permite Modificar Pedidos?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "CuitClie",;
				PICTTR With "!",;
				DESCTR With "¿Busca Pedido por Cuit del Cliente?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "NombFant",;
				PICTTR With "!",;
				DESCTR With "¿Busca Pedido por Nombre Fantasía?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "MultiEmpre",;
				PICTTR With "!",;
				DESCTR With "¿Maneja Multiempresas?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Ped",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DEFATR With "N"


			If GetValue( "UsaTalle", "ar0Art", "N" ) == "S" ;
					Or GetValue( "UsaColor", "ar0Art", "N" ) == "S"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "TalleColor",;
					PICTTR With "!",;
					DESCTR With "¿Maneja Talle y Color?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Ped",;
					ORDETR With WORDE,;
					WIDTTR With 1,;
					DEFATR With "N"

			Endif

		Endif

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Pedidos

*
*
Procedure Presupuestos( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try

		loOpcion = loOpciones.GetItem( PRM_Presupuestos )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "UsaPresup",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Presupuestos?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Presu",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		If ( GetValue( "UsaPresup", "ar0Presu", "N" ) == "S" )

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "NumPresu",;
				PICTTR With "99999999",;
				DESCTR With 'Último Número de Presupuesto',;
				LEYETR With "S_ACLNRO(8)",;
				VALITR With "I_VALMOI(WDATO,0)",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Presu",;
				ORDETR With WORDE,;
				WIDTTR With 8,;
				DECITR With 0

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "SucPresu",;
				PICTTR With "9999",;
				DESCTR With 'Sucursal de Presupuestos',;
				LEYETR With "S_ACLNRO(4)",;
				VALITR With "I_VALMOI(WDATO,0)",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Presu",;
				ORDETR With WORDE,;
				WIDTTR With 4,;
				DECITR With 0

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "Copias",;
				PICTTR With "9",;
				DESCTR With 'Cantidad de Copias',;
				LEYETR With "S_ACLNRO(1)",;
				VALITR With "I_VALMOI(WDATO,0)",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Presu",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0

			*!*				Appe Blan
			*!*				WORDE=WORDE+1
			*!*				Repl TIPOTR With "C",;
			*!*					CAMPTR With "TipoDesc",;
			*!*					PICTTR With "!",;
			*!*					DESCTR With "Tipo y Orden de Descarga desde Presupuesto",;
			*!*					LEYETR With "S_LINE24( '[S]: Sin Descargar      [D]: Descargados     [T]: Todos      [N]: No Descarga' )",;
			*!*					PREFTR With "",;
			*!*					POSFTR With "",;
			*!*					VALITR With "I_Valida( InList( WDATO, 'S', 'D', 'N', 'T' ))",;
			*!*					SELETR With "ar0Presu",;
			*!*					ORDETR With WORDE,;
			*!*					WIDTTR With 1,;
			*!*					DEFATR With "S"

			*!*				Appe Blan
			*!*				WORDE=WORDE+1
			*!*				Repl TIPOTR With "C",;
			*!*					CAMPTR With "DescPresu",;
			*!*					PICTTR With "!",;
			*!*					DESCTR With "¿Descarga de Presupuesto Anterior?",;
			*!*					LEYETR With "S_LINE24(MSG24)",;
			*!*					PREFTR With "PreSiNo()",;
			*!*					POSFTR With "PosSiNo()",;
			*!*					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			*!*					SELETR With "ar0Presu",;
			*!*					ORDETR With WORDE,;
			*!*					WIDTTR With 1,;
			*!*					DEFATR With "N"


		Endif

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Presupuestos

*
*
Procedure Valores( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try

		loOpcion = loOpciones.GetItem( PRM_Valores )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "Val_Elec",;
			PICTTR With "!",;
			DESCTR With "¿Usa Valores Electrónicos?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "CashFlow",;
			PICTTR With "!",;
			DESCTR With "¿Usa Cash Flow?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "MultCajas",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Múltiples Cajas?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"

		If GetValue( "MultCajas", "ar0Val", "N" ) = "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "CajaPred",;
				PICTTR With "999",;
				DESCTR With 'Caja Predeterminada',;
				LEYETR With "S_ACLNRO(3)",;
				VALITR With "I_VALMAY(WDATO,0)",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Val",;
				ORDETR With WORDE,;
				WIDTTR With 3,;
				DECITR With 0,;
				DEFATR With "1"

			If WCLAV # "A"
				Append Blank
				WORDE = WORDE + 1
				Repl TIPOTR With "C",;
					CAMPTR With "Efectivo_M",;
					PICTTR With "!", ;
					DESCTR With "*PERMITE MEZCLAR EFECTIVO*", ;
					LEYETR With "S_LINE24(MSG24)", ;
					PREFTR With "PreSiNo()", ;
					POSFTR With "PosSiNo()", ;
					SELETR With "AR0VAL", ;
					WIDTTR With 1,;
					DECITR With 0,;
					DEFATR With "N",;
					ORDETR With WORDE

			Endif

		Endif

		If WCLAV # "A"
			Append Blank
			WORDE = WORDE + 1
			Repl TIPOTR With "C",;
				CAMPTR With "Caja_Asi",;
				PICTTR With "!", ;
				DESCTR With "MOVIMIENTO DE CAJA GENERA ASIENTO", ;
				LEYETR With "S_LINE24(MSG24)", ;
				PREFTR With "PreSiNo()", ;
				POSFTR With "PosSiNo()", ;
				SELETR With "AR0VAL", ;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "N",;
				ORDETR With WORDE

		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "AplicaOP",;
			PICTTR With "!",;
			DESCTR With "¿Permite aplicaciones en Pagos?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "S"

		If GetValue( "AplicaOP", "ar0Val", "S" ) = "S"
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "MuesDebOP",;
				PICTTR With "!",;
				DESCTR With "¿Muestra Comprobantes al Debe en Pagos?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Val",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "N"

		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "AplicaCob",;
			PICTTR With "!",;
			DESCTR With "¿Permite aplicaciones en Cobranzas?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "S"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "NumEfe",;
			PICTTR With "!",;
			DESCTR With "¿Pide Número de Efectivo?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "MovAsiCob",;
			PICTTR With "!",;
			DESCTR With "Cobranza Genera",;
			LEYETR With "S_LINE24( '[M] Movimiento de Caja    [A] Asiento Contable    [N] Nada' )",;
			PREFTR With "PreMovAsi()",;
			POSFTR With "PosMovAsi()",;
			VALITR With "I_Valida( InList( WDATO, 'A', 'M', 'N' ))",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "A"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "MovAsiPag",;
			PICTTR With "!",;
			DESCTR With "Pagos Genera",;
			LEYETR With "S_LINE24( '[M] Movimiento de Caja    [A] Asiento Contable    [N] Nada' )",;
			PREFTR With "PreMovAsi()",;
			POSFTR With "PosMovAsi()",;
			VALITR With "I_Valida( InList( WDATO, 'A', 'M', 'N' ))",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "A"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "N",;
			CAMPTR With "MaxAjuste",;
			PICTTR With "99999.99",;
			DESCTR With 'Importe Máximo para Ajustes Automáticos',;
			LEYETR With "S_ACLNRO(3)",;
			VALITR With "I_VALMAY(WDATO,0)",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 8,;
			DECITR With 2,;
			DEFATR With "100"


		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", ;
			CAMPTR With "NREC0", ;
			PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "NUMERA AUTOMATIC. RECIBOS", ;
			LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0EST", ORDETR With WORDE

		Do Case
			Case WCLAV <> "A"
				*!*						Do Case
				*!*							Case Type( "AR0EST.NRER0" ) = "C"
				M_INIACT( 1 )
				WORDE = WORDE + 1
				Repl TIPOTR With "C", ;
					CAMPTR With "NRER0", ;
					PICTTR With "!", ;
					WIDTTR With 1,;
					DECITR With 0,;
					DEFATR With "N",;
					DESCTR With "NUMERA AUTOMATIC. RECIBOS (R)", LEYETR With "S_LINE24(MSG24)", ;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					SELETR With "AR0EST", ORDETR With WORDE
				*!*						Endcase
		Endcase


		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", ;
			CAMPTR With "NC070", ;
			PICTTR With "@Z 999999", ;
			WIDTTR With 6,;
			DECITR With 0,;
			DESCTR With 'ULTIMO NÚMERO DE RECIBO', ;
			LEYETR With "S_ACLNRO(6)", ;
			VALITR With "I_VALMOI(WDATO,0)", ;
			PREFTR With "", ;
			POSFTR With "", ;
			SELETR With "AR0EST", ;
			ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", ;
			CAMPTR With "TC070", ;
			PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DESCTR With 'LETRA DEL RECIBO', ;
			LEYETR With "S_ACLstr(1)", ;
			PREFTR With "", ;
			POSFTR With "", ;
			SELETR With "AR0VAL", ;
			ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", ;
			CAMPTR With "SC070", ;
			PICTTR With "@Z 99", ;
			WIDTTR With 2,;
			DECITR With 0,;
			DESCTR With 'SUCURSAL DE RECIBO', ;
			LEYETR With "S_ACLNRO(2)", ;
			VALITR With "I_VALMOI(WDATO,0)", ;
			PREFTR With "", ;
			POSFTR With "", ;
			SELETR With "AR0Val", ;
			ORDETR With WORDE

		Do Case
			Case WCLAV <> "A"
				M_INIACT( 1 )
				WORDE = WORDE + 1
				Repl TIPOTR With "N", ;
					CAMPTR With "NC570", ;
					PICTTR With "@Z 999999", ;
					WIDTTR With 6,;
					DECITR With 0,;
					DESCTR With 'ULTIMO NÚMERO DE RECIBO (R)', LEYETR With "S_ACLNRO(6)", VALITR With "I_VALMOI(WDATO,0)", PREFTR With "", POSFTR With "", SELETR With "AR0EST", ORDETR With WORDE
		Endcase

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "NINF0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "NUMERA INDEPENDIENTE ING. DE FONDOS", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0EST", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "NAIF0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "NUMERA AUTOMATIC. ING. DE FONDOS", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0EST", ORDETR With WORDE

		Do Case
			Case WCLAV <> "A"
				Do Case
					Case .T. && Type( "AR0EST.NAIFR0" ) = "C"
						M_INIACT( 1 )
						WORDE = WORDE + 1
						Repl TIPOTR With "C", CAMPTR With "NAIFR0",;
							PICTTR With "!", ;
							WIDTTR With 1,;
							DECITR With 0,;
							DEFATR With "N",;
							DESCTR With "NUMERA AUTOMATIC. ING. DE FONDOS (R)", LEYETR With "S_LINE24(MSG24)", ;
							PREFTR With "PreSiNo()",;
							POSFTR With "PosSiNo()",;
							SELETR With "AR0EST", ORDETR With WORDE
				Endcase
		Endcase



		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "NC170", PICTTR With "@Z 999999",;
			WIDTTR With 6,;
			DECITR With 0,;
			DESCTR With 'ULTIMO NÚMERO DE INGRESO DE FONDOS', LEYETR With "S_ACLNRO(6)", VALITR With "I_VALMOI(WDATO,0)", PREFTR With "", POSFTR With "", SELETR With "AR0EST", ORDETR With WORDE

		Do Case
			Case WCLAV <> "A"
				M_INIACT( 1 )
				WORDE = WORDE + 1
				Repl TIPOTR With "N", CAMPTR With "NC670", PICTTR With "@Z 999999", ;
					WIDTTR With 6,;
					DECITR With 0,;
					DESCTR With 'ULTIMO NÚMERO DE INGRESO DE FONDOS (R)', LEYETR With "S_ACLNRO(6)", VALITR With "I_VALMOI(WDATO,0)", PREFTR With "", POSFTR With "", SELETR With "AR0EST", ORDETR With WORDE

		Endcase

		Do Case
			Case .T. && Type( "AR0EST.PNIV0" ) = "C"
				M_INIACT( 1 )
				WORDE = WORDE + 1
				Repl TIPOTR With "C", CAMPTR With "PNIV0", PICTTR With "!", ;
					WIDTTR With 1,;
					DECITR With 0,;
					DEFATR With "N",;
					DESCTR With "LLEVA NUMERACIÓN INTERNA DE VALORES", LEYETR With "S_LINE24(MSG24)", ;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					SELETR With "AR0EST", ORDETR With WORDE
		Endcase


		If ( GetValue( "PNIV0", "ar0Est", "N" ) == "S" )

			M_INIACT( 1 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "NIVA0",;
				PICTTR With "@Z 999999",;
				WIDTTR With 6,;
				DECITR With 0,;
				DESCTR With 'Ultimo Nro. Interno de Valores',;
				LEYETR With "S_ACLNRO(1)",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "AR0EST",;
				ORDETR With WORDE

			If WCLAV="B"
				M_INIACT( 1 )
				WORDE=WORDE+1
				Repl TIPOTR With "N",;
					CAMPTR With "NIVX0",;
					PICTTR With "@Z 999999",;
					WIDTTR With 6,;
					DECITR With 0,;
					DESCTR With 'Ultimo Nro. Interno de Valores "R"',;
					LEYETR With "S_ACLNRO(1)",;
					PREFTR With "",;
					POSFTR With "",;
					SELETR With "AR0EST",;
					ORDETR With WORDE
			Endif

		Endif

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "DETI0", PICTTR With "@Z 9", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DESCTR With 'DETALLE ASIENTO DE INGRESO DE FONDOS', LEYETR With "S_LINE24('[1]: SÓLO EL Nº  [2]: SÓLO EL NOMBRE  [3]: AMBOS')", VALITR With "I_VALRAN(WDATO,1,3)", PREFTR With "", POSFTR With "", SELETR With "AR0EST", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "NUAU0", PICTTR With "!",;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "NUMERA O. DE PAGO AUTOMATICAMENTE", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0PRC", ORDETR With WORDE

		Do Case
			Case WCLAV <> "A"
				Do Case
					Case .T. && Type( "AR0PRC.NUAR0" ) = "C"
						M_INIACT( 1 )
						WORDE = WORDE + 1
						Repl TIPOTR With "C", CAMPTR With "NUAR0", PICTTR With "!",;
							WIDTTR With 1,;
							DECITR With 0,;
							DEFATR With "N",;
							DESCTR With "NUMERA O. DE PAGO AUTOMATICAMENTE (R)", LEYETR With "S_LINE24(MSG24)", ;
							PREFTR With "PreSiNo()",;
							POSFTR With "PosSiNo()",;
							SELETR With "AR0PRC", ORDETR With WORDE
				Endcase
		Endcase

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Replace TIPOTR With "N", ;
			CAMPTR With "NC080", ;
			PICTTR With "@Z 99999999",;
			WIDTTR With 8,;
			DECITR With 0,;
			DESCTR With 'ULTIMO NÚMERO DE ORDEN DE PAGO', ;
			LEYETR With "S_ACLNRO(6)", ;
			VALITR With "I_VALMOI(WDATO,0)", ;
			PREFTR With "", ;
			POSFTR With "", ;
			SELETR With "AR0PRC", ;
			ORDETR With WORDE

		Do Case
			Case WCLAV <> "A"
				M_INIACT( 1 )
				WORDE = WORDE + 1
				Repl TIPOTR With "N", CAMPTR With "NC580", PICTTR With "@Z 999999", ;
					WIDTTR With 6,;
					DECITR With 0,;
					DESCTR With 'ULTIMO NÚMERO DE ORDEN DE PAGO (R)', LEYETR With "S_ACLNRO(6)", VALITR With "I_VALMOI(WDATO,0)", PREFTR With "", POSFTR With "", SELETR With "AR0PRC", ORDETR With WORDE

		Endcase


		If .T. && Type("AR0EST.OPFC0")<>"U"

			M_INIACT( 1 )
			WORDE = WORDE + 1
			Repl TIPOTR With "C", ;
				CAMPTR With "OPFC0", ;
				PICTTR With "!", ;
				DESCTR With "O/P igual Nº que Factura Contado", ;
				LEYETR With "S_LINE24(MSG24)", ;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				SELETR With "AR0EST", ;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "N",;
				ORDETR With WORDE
		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "NIntDepo",;
			PICTTR With "!",;
			DESCTR With "¿Muestra Nº Interno en Depósitos?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"


		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "RGAN0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "PIDE RETENCION GANANCIAS EN COMPRAS", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0PRC", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "RVAR0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "PIDE RETENCIONES VARIAS EN COBRANZAS", ;
			LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0CON", ;
			ORDETR With WORDE

		If GetValue( "RVar0", "AR0CON", "N" ) = "S"
			M_INIACT( 1 )
			WORDE = WORDE + 1
			Replace TIPOTR With "C", ;
				CAMPTR With "RetVarias", ;
				PICTTR With "XXXXXXXX", ;
				WIDTTR With 8,;
				DECITR With 0,;
				DEFATR With "        ",;
				DESCTR With "Código Contable Retenciones Varias", ;
				LEYETR With "S_LINE24(MSG24)", ;
				PREFTR With "", ;
				POSFTR With "", ;
				SELETR With "AR0CON", ;
				ORDETR With WORDE

		Endif

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "RETG0", PICTTR With "@Z 999999.99",;
			WIDTTR With 9,;
			DECITR With 2,;
			DESCTR With "BASE MENSUAL NO IMPONIBLE", LEYETR With "S_ACLDEC(7,2)", PREFTR With "", POSFTR With "", SELETR With "AR0PRC", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "TGRI0", PICTTR With "@Z 99.99",;
			WIDTTR With 5,;
			DECITR With 2,;
			DESCTR With "TASA INSCRIPTOS", LEYETR With "S_ACLDEC(2,2)", PREFTR With "", POSFTR With "", SELETR With "AR0PRC", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "TGRN0", PICTTR With "@Z 99.99", ;
			WIDTTR With 5,;
			DECITR With 2,;
			DESCTR With "TASA NO INSCRIPTOS", LEYETR With "S_ACLDEC(2,2)", PREFTR With "", POSFTR With "", SELETR With "AR0PRC", ORDETR With WORDE

		Do Case
			Case .T. && Type( "AR0PRC.LGAN0" ) = "C"
				M_INIACT( 1 )
				WORDE = WORDE + 1
				Repl TIPOTR With "C", CAMPTR With "LGAN0", PICTTR With "!", ;
					WIDTTR With 1,;
					DECITR With 0,;
					DEFATR With "N",;
					DESCTR With "MUESTRA LEYENDA EN CERTIFICADO", LEYETR With "S_LINE24(MSG24)", ;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					SELETR With "AR0PRC", ORDETR With WORDE

		Endcase

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "NC350", PICTTR With "@Z 999999", ;
			WIDTTR With 6,;
			DECITR With 0,;
			DESCTR With 'ULTIMO NÚMERO DE DÉBITO/CRÉDITO BANCARIO', LEYETR With "S_ACLNRO(6)", VALITR With "I_VALMOI(WDATO,0)", PREFTR With "", POSFTR With "", SELETR With "AR0PRC", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "NEGF0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "NUMERA INDEPENDIENTE EGRESO DE FONDOS", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0PRC", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "NAEF0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "NUMERA AUTOMATIC. EGRESO DE FONDOS", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0PRC", ORDETR With WORDE

		Do Case
			Case WCLAV <> "A"
				Do Case
					Case .T. && Type( "AR0PRC.NAEFR0" ) = "C"
						M_INIACT( 1 )
						WORDE = WORDE + 1
						Repl TIPOTR With "C", CAMPTR With "NAEFR0", PICTTR With "!", ;
							WIDTTR With 1,;
							DECITR With 0,;
							DEFATR With "N",;
							DESCTR With "NUMERA AUTOMATIC. EGRESO DE FONDOS (R)", LEYETR With "S_LINE24(MSG24)", ;
							PREFTR With "PreSiNo()",;
							POSFTR With "PosSiNo()",;
							SELETR With "AR0PRC", ORDETR With WORDE
				Endcase
		Endcase

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "NC180", PICTTR With "@Z 999999", ;
			WIDTTR With 6,;
			DECITR With 0,;
			DESCTR With 'ULTIMO NÚMERO DE EGRESO DE FONDOS', LEYETR With "S_ACLNRO(6)", VALITR With "I_VALMOI(WDATO,0)", PREFTR With "", POSFTR With "", SELETR With "AR0PRC", ORDETR With WORDE

		Do Case
			Case WCLAV <> "A"
				M_INIACT( 1 )
				WORDE = WORDE + 1
				Replace TIPOTR With "N", ;
					CAMPTR With "NC680", ;
					PICTTR With "@Z 999999", ;
					DESCTR With 'ULTIMO NÚMERO DE EGRESO DE FONDOS (R)', ;
					LEYETR With "S_ACLNRO(6)", ;
					VALITR With "I_VALMOI(WDATO,0)", ;
					PREFTR With "", ;
					POSFTR With "", ;
					SELETR With "AR0PRC", ;
					ORDETR With WORDE,;
					WIDTTR With 6,;
					DECITR With 0,;
					DEFATR With '0'


		Endcase

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "DETE0", PICTTR With "@Z 9", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DESCTR With 'DETALLE ASIENTO DE EGRESO DE FONDOS', ;
			LEYETR With "S_LINE24('[1]: SÓLO EL Nº  [2]: SÓLO EL NOMBRE  [3]: AMBOS')", VALITR With "I_VALRAN(WDATO,1,3)", PREFTR With "", POSFTR With "", SELETR With "AR0PRC", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "NIBD0", PICTTR With "!",;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "NÚMERO INTERNO BOLETA DEPÓSITO", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0CON", ORDETR With WORDE


		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "NC300", PICTTR With "@Z 9999999999", ;
			WIDTTR With 10,;
			DECITR With 0,;
			DESCTR With "ULTIMO NÚMERO INTERNO BOLETA DEPÓSITO", LEYETR With "S_ACLNRO(10)", VALITR With "I_VALMOI(WDATO,0)", PREFTR With "", POSFTR With "", SELETR With "AR0CON", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "DCOP0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "DEP. EN CUSTODIA GENERA ORDEN DE PAGO", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0CON", ORDETR With WORDE


		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "NC320", PICTTR With "@Z 999999", ;
			WIDTTR With 6,;
			DECITR With 0,;
			DESCTR With "ULTIMO NÚMERO INTERNO DEPÓSITO CUSTODIA", LEYETR With "S_ACLNRO(6)", VALITR With "I_VALMOI(WDATO,0)", PREFTR With "", POSFTR With "", SELETR With "AR0CON", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "DISV0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "DISCRIMINA VALORES EN EL ASIENTO", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0CON", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", ;
			CAMPTR With "IMPC0", ;
			PICTTR With "!", ;
			DESCTR With "IMPRIME COBRANZAS", ;
			LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0EST", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", ;
			CAMPTR With "COPI0", ;
			PICTTR With "@Z 9", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DESCTR With "CANTIDAD DE COPIAS RECIBO DE COBRANZAS", ;
			LEYETR With "S_ACLNRO(1)", ;
			PREFTR With "", ;
			POSFTR With "", ;
			SELETR With "AR0EST", ;
			ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "CCHR0", PICTTR With "@Z 9999", ;
			WIDTTR With 4,;
			DECITR With 0,;
			DESCTR With 'CONCEPTO CHEQUE RECHAZADO', LEYETR With "S_ACLNRO(4)", VALITR With "I_VALMOI(WDATO,0)", PREFTR With "", POSFTR With "", SELETR With "AR0EST", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "AUTO0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "GENERA ASIENTO DE PAGOS AUTOMATICO", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0PRC", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "IMOP0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "IMPRIME ORDEN DE PAGO", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0PRC", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", ;
			CAMPTR With "COPI0", PICTTR With "@Z 9",;
			WIDTTR With 1,;
			DECITR With 0,;
			DESCTR With "CANTIDAD DE COPIAS ORDEN DE PAGO", ;
			LEYETR With "S_ACLNRO(1)", ;
			PREFTR With "", POSFTR With "", ;
			SELETR With "AR0PRC", ;
			ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "SALC0", PICTTR With "@Z 999999999.99",;
			WIDTTR With 12,;
			DECITR With 2,;
			DESCTR With "SALDO INICIAL DE CAJA", LEYETR With "S_ACLDEC(9,2)", PREFTR With "", POSFTR With "", SELETR With "AR0EST", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "TOPE0", PICTTR With "@Z 999999999.99", ;
			WIDTTR With 12,;
			DECITR With 2,;
			DESCTR With "MONTO PARA PEDIR CUIT EN VALORES", LEYETR With "S_ACLDEC(9,2)", VALITR With "I_VALMOI(WDATO,0)", PREFTR With "", POSFTR With "", SELETR With "AR0CON", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "PCUI0", PICTTR With "@Z 9",;
			WIDTTR With 1,;
			DECITR With 0,;
			DESCTR With "PIDE CUIT EN VALORES", ;
			LEYETR With "S_LINE24('[1]: POR IMPORTE  [2]: SIEMPRE  [3]: NUNCA')", ;
			VALITR With "I_VALRAN(WDATO,1,3)", ;
			PREFTR With "prePidCuit()", ;
			POSFTR With "posPidCuit()", ;
			SELETR With "AR0CON", ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "FEAC0", PICTTR With "@Z 999",;
			WIDTTR With 3,;
			DECITR With 0,;
			DESCTR With "HORAS DE ACREDITACIÓN", LEYETR With "S_ACLNRO(3)", VALITR With "VALFEAC(WDATO)", PREFTR With "", POSFTR With "", SELETR With "AR0CON", ORDETR With WORDE


		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "D", CAMPTR With "FECV0", ;
			DESCTR With "ULTIMA ACT. DE SALDOS DE VALORES DE 3°", PREFTR With "", POSFTR With "", SELETR With "AR0EST", ORDETR With WORDE



		*!*				Do Case
		*!*					Case Type( "AR0CON.PMON0" ) = "C"
		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "PMON0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "PREGUNTA MONEDA EN PEDIDO DE VALORES", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0CON", ORDETR With WORDE

		*!*				Endcase

		*!*				Do Case
		*!*					Case Type( "AR0CON.APLI0" ) = "C"
		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "APLI0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "INGRESO/EGRESO: APLICA MÁS DE UNA CUENTA", LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0CON", ORDETR With WORDE

		*!*				Endcase

		*!*				Do Case
		*!*					Case Type( "AR0CON.RDEP0" ) = "C"
		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "RDEP0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "S",;
			DESCTR With "DEPÓSITOS BANCARIOS GENERA ASIENTOS EN", ;
			LEYETR With "S_LINE24('[S]: SUBDIARIO       [D]: DIARIO')", ;
			PREFTR With "PRE00P3()", ;
			POSFTR With "POS00P3()", ;
			SELETR With "AR0CON", ;
			ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C", CAMPTR With "NEFE0", PICTTR With "!", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			DESCTR With "NUMERA EFECTIVO AUTOMATICAMENTE", ;
			LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0EST", ;
			ORDETR With WORDE

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "NumEfe",;
			PICTTR With "!",;
			DESCTR With "¿Pide Número de Efectivo?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ImpNCR_P",;
			PICTTR With "!",;
			DESCTR With "¿Imprime Notas de Crédito en Orden de Pago?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Val",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"



		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "EFPE0", PICTTR With "@Z 999999999.99", ;
			WIDTTR With 12,;
			DECITR With 2,;
			DESCTR With "SALDO INICIAL EFECTIVO PESOS", ;
			LEYETR With "S_ACLDEC(9,2)", ;
			PREFTR With "", ;
			POSFTR With "", ;
			SELETR With "AR0EST", ;
			ORDETR With WORDE

		*!*				Endcase

		*!*				Do Case
		*!*					Case Type( "AR0EST.EFUS0" ) = "N"
		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "EFUS0", PICTTR With "@Z 999999999.99", ;
			WIDTTR With 12,;
			DECITR With 2,;
			DESCTR With "SALDO INICIAL EFECTIVO U$S", LEYETR With "S_ACLDEC(9,2)", PREFTR With "", POSFTR With "", SELETR With "AR0EST", ORDETR With WORDE
		*!*				Endcase

		*!*				Do Case
		*!*					Case Type( "AR0EST.CHUS0" ) = "N"
		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "CHUS0", PICTTR With "@Z 999999999.99", ;
			WIDTTR With 12,;
			DECITR With 2,;
			DESCTR With "SALDO INICIAL CHEQUES U$S", LEYETR With "S_ACLDEC(9,2)", PREFTR With "", POSFTR With "", SELETR With "AR0EST", ORDETR With WORDE
		*!*				Endcase

		*!*				Do Case
		*!*					Case Type( "AR0EST.CHPE0" ) = "N"
		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "CHPE0", PICTTR With "@Z 999999999.99", ;
			WIDTTR With 12,;
			DECITR With 2,;
			DESCTR With "SALDO INICIAL CHEQUES PESOS", LEYETR With "S_ACLDEC(9,2)", PREFTR With "", POSFTR With "", SELETR With "AR0EST", ORDETR With WORDE
		*!*				Endcase


		*!*				Do Case
		*!*					Case Type( "AR0EST.DBCR0" ) = "N"
		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "N", CAMPTR With "DBCR0", PICTTR With "@Z 999999999.99", ;
			WIDTTR With 12,;
			DECITR With 2,;
			DESCTR With "SALDO INICIAL BANCOS", LEYETR With "S_ACLDEC(9,2)", PREFTR With "", POSFTR With "", SELETR With "AR0EST", ORDETR With WORDE
		*!*				Endcase


		M_INIACT( 1 )
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "OFCD0",;
			PICTTR With Replicate( "X", 30 ),;
			DESCTR With "Otra Forma de Cobranza (Descripción)",;
			LEYETR With "S_ACLSTR(30)",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "AR0CON",;
			ORDETR With WORDE

		M_INIACT( 1 )
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "OFCC0",;
			PICTTR With Repl("X",8),;
			DESCTR With "Otra Forma de Cobranza (Cuenta)",;
			PREFTR With "VACUE00()",;
			POSFTR With "VACUE99()",;
			SELETR With "AR0CON",;
			ORDETR With WORDE

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C",;
			CAMPTR With "MultCajas", ;
			PICTTR With "!", ;
			DESCTR With "UTILIZA MULTIPLES CAJAS", ;
			LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0VAL", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			ORDETR With WORDE




		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "OrdeDeud",;
			PICTTR With "!",;
			DESCTR With "Ordena Deuda por Fecha de",;
			LEYETR With "S_LINE24('[V]: Vencimiento      [E]: Emisión')", ;
			PREFTR With "PreOrdenaDeudores()", ;
			POSFTR With "PosOrdenaDeudores()", ;
			VALITR With "I_Valida( InList( WDATO, [V], [E] ))",;
			SELETR With "ar0Val",;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "V",;
			ORDETR With WORDE


		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C",;
			CAMPTR With "LoteCupon", ;
			PICTTR With "!", ;
			DESCTR With "Numera Lote/Cupón en Tarjetas", ;
			LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0VAL", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			ORDETR With WORDE

		If ( GetValue( "LoteCupon", "ar0Val", "N" ) = "S" )

			M_INIACT( 1 )
			WORDE = WORDE + 1
			Repl TIPOTR With "C",;
				CAMPTR With "PideLote", ;
				PICTTR With "!", ;
				DESCTR With "Pide Lote", ;
				LEYETR With "S_LINE24(MSG24)", ;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				SELETR With "AR0VAL", ;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "N",;
				ORDETR With WORDE

		Endif

		M_INIACT( 1 )
		WORDE = WORDE + 1
		Repl TIPOTR With "C",;
			CAMPTR With "M_Pagos", ;
			PICTTR With "!", ;
			DESCTR With "Utiliza Medios de Pagos Personalizado:", ;
			LEYETR With "S_LINE24(MSG24)", ;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			SELETR With "AR0VAL", ;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			ORDETR With WORDE

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Valores



*
*
Procedure Varios( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try


		loOpcion = loOpciones.GetItem( PRM_Varios )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "BuscaIntel",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Búsqueda Inteligente?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "S"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "PDFAuto",;
			PICTTR With "!",;
			DESCTR With "¿Genera PDF automáticamente?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "S"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "PrintDOS",;
			PICTTR With "!",;
			DESCTR With "¿Emite Listados DOS?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "S"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "PrintWin",;
			PICTTR With "!",;
			DESCTR With "¿Emite Reportes Windows?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "S"

		If GetValue( "PrintWin", "ar0Var", "N" ) = "S"
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "DefaWin",;
				PICTTR With "!",;
				DESCTR With "¿Predeterminado a Reporte Windows?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Var",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "S"
		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "I",;
			CAMPTR With "LenCodi4",;
			PICTTR With "9",;
			DESCTR With "Longitud Código ar4Var",;
			LEYETR With "S_ACLNRO(1)",;
			PREFTR With "",;
			POSFTR With "",;
			VALITR With "I_VALMAY( WDATO, 0 )",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			DEFATR With "4"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "T_Concepto",;
			PICTTR With "!",;
			DESCTR With "TIPO4 en tabla de CONCEPTOS",;
			LEYETR With "S_Aclstr( 1 )",;
			PREFTR With "",;
			POSFTR With "",;
			VALITR With "I_ValObl( WDATO )",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "6"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "T_Transpor",;
			PICTTR With "!",;
			DESCTR With "TIPO4 en tabla de TRANSPORTES",;
			LEYETR With "S_Aclstr( 1 )",;
			PREFTR With "",;
			POSFTR With "",;
			VALITR With "I_ValObl( WDATO )",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "W"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ImpComp",;
			PICTTR With Replicate( "X", 25 ),;
			DESCTR With "Nombre de la Rutina de Impresión",;
			LEYETR With "S_Aclstr( 25 )",;
			PREFTR With "",;
			POSFTR With "",;
			VALITR With "I_ValObl( WDATO )",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 25,;
			DECITR With 0,;
			DEFATR With "ImprimeComprobante"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "I",;
			CAMPTR With "MinId",;
			PICTTR With "99999999",;
			DESCTR With 'Valor Mínimo de Id',;
			LEYETR With "S_ACLNRO(8)",;
			VALITR With "I_VALMOI(WDATO, 0 )",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			DEFATR With "1"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "I",;
			CAMPTR With "MaxId",;
			PICTTR With "99999999",;
			DESCTR With 'Valor Máximo de Id',;
			LEYETR With "S_ACLNRO(8)",;
			VALITR With "I_VALMOI(WDATO, 0 )",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			DEFATR With "99999999"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "LastModi",;
			PICTTR With "!",;
			DESCTR With "¿Muestra Fecha Última Actualización?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"


		If Inlist( WCLAV, "B", "M" )
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "IngTipMax",;
				PICTTR With "9",;
				DESCTR With 'Valor Máximo en Ingtip',;
				LEYETR With "S_ACLNRO(1)",;
				VALITR With "I_VALRAN(WDATO, 1, 2 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Var",;
				ORDETR With WORDE,;
				DEFATR With "1"

		Endif

		lShutOff = GetValue( "lShutOff", "ar0Sys", .F. )

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "cShutOff",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Cierre Automático?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Sys",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With Iif( lShutOff, "S", "N" )

		If GetValue( "cShutOff", "ar0Sys", "N" ) = "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "Warning",;
				PICTTR With "99999999",;
				DESCTR With 'Lapso inactivo en segundos',;
				LEYETR With "S_ACLNRO(8)",;
				VALITR With "I_ValMay(WDATO, 30 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Sys",;
				ORDETR With WORDE,;
				DEFATR With "7200"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "ShutOff",;
				PICTTR With "99999999",;
				DESCTR With 'Duración de la Advertencia en segundos',;
				LEYETR With "S_ACLNRO(8)",;
				VALITR With "I_ValMay(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Sys",;
				ORDETR With WORDE,;
				DEFATR With "300"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "InitTime",;
				PICTTR With "99:99:99",;
				DESCTR With "No activo desde",;
				LEYETR With "S_LINE24('Indique desde qué hora NO ACTUA [hh:mm:ss]')",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "ValidarHora( WDATO )",;
				SELETR With "ar0Sys",;
				ORDETR With WORDE,;
				WIDTTR With 8,;
				DECITR With 0,;
				DEFATR With "08:00:00"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "EndTime",;
				PICTTR With "99:99:99",;
				DESCTR With "No activo hasta",;
				LEYETR With "S_LINE24('Indique hasta qué hora NO ACTUA [hh:mm:ss]')",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "ValidarHora( WDATO )",;
				SELETR With "ar0Sys",;
				ORDETR With WORDE,;
				WIDTTR With 8,;
				DECITR With 0,;
				DEFATR With "18:00:00"

		Endif

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Varios

*
*
Procedure Exportar( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Local loOpcion As Object

	Try


		loOpcion = loOpciones.GetItem( PRM_Exportar )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan


		If GetValue( "PDFAuto", "ar0Var", "N" ) = "S"
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "RutaPDF",;
				PICTTR With "@S27",;
				DESCTR With "Ruta de Exportación a PDF",;
				LEYETR With "",;
				PREFTR With "PreF1Folder()",;
				POSFTR With "PosF1Folder()",;
				SELETR With "ar0Var",;
				ORDETR With WORDE,;
				WIDTTR With 180


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "PDFRetIIBB",;
				PICTTR With "!",;
				DESCTR With "¿PDF Automático Retención IIBB?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Var",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "N"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "PDFRetGan",;
				PICTTR With "!",;
				DESCTR With "¿PDF Automático Retención Ganancias?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Var",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "N"


		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "RutaXls",;
			PICTTR With "@S27",;
			DESCTR With "Ruta de Exportación a Hoja de Cálculo",;
			LEYETR With "",;
			PREFTR With "PreF1Folder()",;
			POSFTR With "PosF1Folder()",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 180

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "RutaFrx",;
			PICTTR With "@S27",;
			DESCTR With "Ruta de Ubicación de los Frx",;
			LEYETR With "",;
			PREFTR With "PreF1Folder()",;
			POSFTR With "PosF1Folder()",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 180

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "RutaMenues",;
			PICTTR With "@S27",;
			DESCTR With "Ruta de Ubicación de los Menues",;
			LEYETR With "",;
			PREFTR With "PreF1Folder()",;
			POSFTR With "PosF1Folder()",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 180


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "RutaPadron",;
			PICTTR With "@S27",;
			DESCTR With "Ruta de Ubicación de los Padrones",;
			LEYETR With "",;
			PREFTR With "PreF1Folder()",;
			POSFTR With "PosF1Folder()",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 180

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "RutaSiap",;
			PICTTR With "@S27",;
			DESCTR With "Ruta de Exportación Archivos para el Siap",;
			LEYETR With "",;
			PREFTR With "PreF1Folder()",;
			POSFTR With "PosF1Folder()",;
			SELETR With "ar0Var",;
			ORDETR With WORDE,;
			WIDTTR With 180




	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Exportar


*
*
Procedure Pasajes( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try

		loOpcion = loOpciones.GetItem( PRM_Pasajes )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		If Inlist( WCLAV, "B", "M" )
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "FExportx",;
				PICTTR With "@S30",;
				DESCTR With "* Carpeta de Exportación de Novedades *",;
				LEYETR With "",;
				PREFTR With "PreF1Folder()",;
				POSFTR With "PosF1Folder()",;
				SELETR With "ar0Pas",;
				ORDETR With WORDE,;
				WIDTTR With 180

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "FImportx",;
				PICTTR With "@S30",;
				DESCTR With "* Carpeta de Importación de Novedades *",;
				LEYETR With "",;
				PREFTR With "PreF1Folder()",;
				POSFTR With "PosF1Folder()",;
				SELETR With "ar0Pas",;
				ORDETR With WORDE,;
				WIDTTR With 180

		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "FExporta",;
			PICTTR With "@S30",;
			DESCTR With "Carpeta de Exportación de Novedades",;
			LEYETR With "",;
			PREFTR With "PreF1Folder()",;
			POSFTR With "PosF1Folder()",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE,;
			WIDTTR With 180


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "FImporta",;
			PICTTR With "@S30",;
			DESCTR With "Carpeta de Importación de Novedades",;
			LEYETR With "",;
			PREFTR With "PreF1Folder()",;
			POSFTR With "PosF1Folder()",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE,;
			WIDTTR With 180

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ProcExtExp",;
			PICTTR With "@S30",;
			DESCTR With "Proceso Externo para Exportación",;
			LEYETR With "",;
			PREFTR With "PreF1File()",;
			POSFTR With "PosF1File()",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE,;
			WIDTTR With 180

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ProcExtImp",;
			PICTTR With "@S30",;
			DESCTR With "Proceso Externo para Importación",;
			LEYETR With "",;
			PREFTR With "PreF1File()",;
			POSFTR With "PosF1File()",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE,;
			WIDTTR With 180


		Appe Blan
		lcAlicuota = Str( 21, 5, 2 )
		WORDE=WORDE+1
		Repl TIPOTR With "I",;
			CAMPTR With "DiasPrev",;
			PICTTR With "999",;
			DESCTR With 'Cantidad de días previos',;
			LEYETR With "S_AclNro(3)",;
			VALITR With "I_VALMOI(WDATO, 0 )",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE,;
			WIDTTR With 3,;
			DECITR With 0,;
			DEFATR With "20"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ExVentas",;
			PICTTR With "!",;
			DESCTR With "Exporta Facturas de Ventas",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ExCompras",;
			PICTTR With "!",;
			DESCTR With "Exporta Facturas de Compras",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ExRemitos",;
			PICTTR With "!",;
			DESCTR With "Exporta Remitos",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ExValores",;
			PICTTR With "!",;
			DESCTR With "Exporta Valores",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ExAsientos",;
			PICTTR With "!",;
			DESCTR With "Exporta Asientos",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ExMaestros",;
			PICTTR With "!",;
			DESCTR With "Exporta Maestros",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ImVentas",;
			PICTTR With "!",;
			DESCTR With "Importa Facturas de Ventas",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ImCompras",;
			PICTTR With "!",;
			DESCTR With "Importa Facturas de Compras",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ImRemitos",;
			PICTTR With "!",;
			DESCTR With "Importa Remitos",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ImValores",;
			PICTTR With "!",;
			DESCTR With "Importa Valores",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ImAsientos",;
			PICTTR With "!",;
			DESCTR With "Importa Asientos",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "ImMaestros",;
			PICTTR With "!",;
			DESCTR With "Importa Maestros",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Pas",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "S"


	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Pasajes



*
*
Procedure Auditoria( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try

		loOpcion = loOpciones.GetItem( PRM_Auditoria )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "RutaAudit",;
			PICTTR With "@S27",;
			DESCTR With "Carpeta de Archivo de Auditoria",;
			LEYETR With "",;
			PREFTR With "PreF1Folder()",;
			POSFTR With "PosF1Folder()",;
			SELETR With "ar0Aud",;
			ORDETR With WORDE,;
			WIDTTR With 180,;
			DEFATR With Iif( Vartype( DRCOMUN )="C", DRCOMUN, "" )

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "Auditoria",;
			PICTTR With "!",;
			DESCTR With "¿Consulta Auditoría?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Aud",;
			ORDETR With WORDE ,;
			WIDTTR With 1,;
			DEFATR With "N"

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Auditoria


*
*
Procedure Stock( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try

		loOpcion = loOpciones.GetItem( PRM_Stock )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "Stock",;
			PICTTR With "!",;
			DESCTR With "¿Utiliza Módulo de Stock?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Stk",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "S"

		If ( GetValue( "Stock", "ar0Stk", "N" ) == "S" )

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "Valoriza",;
				PICTTR With "!",;
				DESCTR With "¿Muestra Stock Valorizado?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Stk",;
				ORDETR With WORDE ,;
				WIDTTR With 1,;
				DEFATR With "N"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "DepoPred",;
				PICTTR With "999",;
				DESCTR With 'Depósito Actual',;
				LEYETR With "S_ACLNRO(3)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "PreDepositos()",;
				POSFTR With "PosDepositos()",;
				SELETR With "ar0Stk",;
				ORDETR With WORDE,;
				WIDTTR With 3,;
				DECITR With 0,;
				DEFATR With "0"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "PideDepo",;
				PICTTR With "!",;
				DESCTR With "¿Pide Depósito en Consultas?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Stk",;
				ORDETR With WORDE ,;
				WIDTTR With 1,;
				DEFATR With "N"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "AlertaSt",;
				PICTTR With "!",;
				DESCTR With "¿Utiliza Alerta de Stock Insuficiente?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Stk",;
				ORDETR With WORDE ,;
				WIDTTR With 1,;
				DEFATR With "N"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "UsaFormula",;
				PICTTR With "!",;
				DESCTR With "¿Utiliza Fórmula de Producción?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Stk",;
				ORDETR With WORDE ,;
				WIDTTR With 1,;
				DEFATR With "N"

			If GetValue( "UsaTalle", "ar0Art", "N" ) == "S" ;
					Or GetValue( "UsaColor", "ar0Art", "N" ) == "S"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "TalleColor",;
					PICTTR With "!",;
					DESCTR With "¿Maneja Talle y Color?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Stk",;
					ORDETR With WORDE,;
					WIDTTR With 1,;
					DEFATR With "N"

			Endif

		Endif

	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Stock

*
*
Procedure Impuestos( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try

		loOpcion = loOpciones.GetItem( PRM_Impuestos )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		Appe Blan
		lcAlicuota = Str( 21, 5, 2 )
		WORDE=WORDE+1
		Repl TIPOTR With "N",;
			CAMPTR With "IvaNorm",;
			PICTTR With "99.99",;
			DESCTR With 'Alícuota Iva Normal',;
			LEYETR With "S_ACLDEC(2,2)",;
			VALITR With "I_VALMOI(WDATO, 0 )",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Imp",;
			ORDETR With WORDE,;
			WIDTTR With 5,;
			DECITR With 2,;
			DEFATR With lcAlicuota

		Appe Blan
		lcAlicuota = Str( 10.50, 5, 2 )
		WORDE=WORDE+1
		Repl TIPOTR With "N",;
			CAMPTR With "IvaRedu",;
			PICTTR With "99.99",;
			DESCTR With 'Alícuota Iva Reducido',;
			LEYETR With "S_ACLDEC(2,2)",;
			VALITR With "I_VALMOI(WDATO, 0 )",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Imp",;
			ORDETR With WORDE,;
			WIDTTR With 5,;
			DECITR With 2,;
			DEFATR With lcAlicuota

		Appe Blan
		lcAlicuota = Str( 27, 5, 2 )
		WORDE=WORDE+1
		Repl TIPOTR With "N",;
			CAMPTR With "IvaDife",;
			PICTTR With "99.99",;
			DESCTR With 'Alícuota Iva Diferenciado',;
			LEYETR With "S_ACLDEC(2,2)",;
			VALITR With "I_VALMOI(WDATO, 0 )",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Imp",;
			ORDETR With WORDE,;
			WIDTTR With 5,;
			DECITR With 2,;
			DEFATR With lcAlicuota


		Appe Blan
		lcAlicuota = Str( 2.50, 5, 2 )
		WORDE=WORDE+1
		Repl TIPOTR With "N",;
			CAMPTR With "IvaMGraf9",;
			PICTTR With "99.99",;
			DESCTR With 'Alícuota Iva Medios Graficos 1',;
			LEYETR With "S_ACLDEC(2,2)",;
			VALITR With "I_VALMOI(WDATO, 0 )",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Imp",;
			ORDETR With WORDE,;
			WIDTTR With 5,;
			DECITR With 2,;
			DEFATR With lcAlicuota

		Appe Blan
		lcAlicuota = Str( 5, 5, 2 )
		WORDE=WORDE+1
		Repl TIPOTR With "N",;
			CAMPTR With "IvaMGraf8",;
			PICTTR With "99.99",;
			DESCTR With 'Alícuota Iva Medios Graficos 2',;
			LEYETR With "S_ACLDEC(2,2)",;
			VALITR With "I_VALMOI(WDATO, 0 )",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "ar0Imp",;
			ORDETR With WORDE,;
			WIDTTR With 5,;
			DECITR With 2,;
			DEFATR With lcAlicuota

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "PIIBB901",;
			PICTTR With "!",;
			DESCTR With "¿Percibe IIBB Capital?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Imp",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "PIIBB902",;
			PICTTR With "!",;
			DESCTR With "¿Percibe IIBB Buenos Aires?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Imp",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"


		If GetValue( "PIIBB901", "ar0Imp", "N" ) == "S"
			Appe Blan
			lcAlicuota = Str( 2.00, 5, 2 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "TPIIBB901",;
				PICTTR With "99.99",;
				DESCTR With 'Tasa Percepcion IIBB (Capital)',;
				LEYETR With "S_ACLDEC(2,2)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 5,;
				DECITR With 2,;
				DEFATR With lcAlicuota

			Appe Blan
			lcImporte = Str( 100.00, 9, 2 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "NoPer901",;
				PICTTR With "999999.99",;
				DESCTR With 'Neto No Imponible Per. IIBB (Capital)',;
				LEYETR With "S_ACLDEC(6,2)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 9,;
				DECITR With 2,;
				DEFATR With lcImporte


		Endif

		If Inlist( "S", GetValue( "PIIBB901", "ar0Imp", "N" ), GetValue( "PIIBB902", "ar0Imp", "N" ) )

			* RA 2014-11-15(10:34:16)
			* Tambien Perciben los Exentos (Carulli)

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "PerIB05",;
				PICTTR With "!",;
				DESCTR With "¿Percibe IIBB a Exentos?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "PerIB07",;
				PICTTR With "!",;
				DESCTR With "¿Percibe IIBB a Monotributistas?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "N"

			If ( GetValue( "PIIBB901", "ar0Imp", "N" ) = "S" )

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "Usa_ARF",;
					PICTTR With "!",;
					DESCTR With "¿Utiliza el Padrón de Alto Riesgo Fiscal?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Imp",;
					ORDETR With WORDE,;
					WIDTTR With 1,;
					DECITR With 0,;
					DEFATR With "N"

			Endif

		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "RIIBB901",;
			PICTTR With "!",;
			DESCTR With "¿Retiene IIBB Capital?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Imp",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "RIIBB902",;
			PICTTR With "!",;
			DESCTR With "¿Retiene IIBB Buenos Aires?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Imp",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"


		If GetValue( "RIIBB901", "ar0Imp", "N" ) == "S"
			Appe Blan
			lcAlicuota = Str( 0.00, 5, 2 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "TRIIBB901",;
				PICTTR With "99.99",;
				DESCTR With 'Tasa Retención IIBB (Capital)',;
				LEYETR With "S_ACLDEC(2,2)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 5,;
				DECITR With 2,;
				DEFATR With lcAlicuota

			Appe Blan
			lcImporte = Str( 0.00, 9, 2 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "NoRet901",;
				PICTTR With "999999.99",;
				DESCTR With 'Neto No Imponible Ret. IIBB (Capital)',;
				LEYETR With "S_ACLDEC(6,2)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 9,;
				DECITR With 2,;
				DEFATR With lcImporte

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "NRetIb901",;
				PICTTR With "99999999",;
				DESCTR With 'Último Nº Certificado Ret. IIBB (Capital)',;
				LEYETR With "S_ACLNRO(8)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE

		Endif

		If GetValue( "PIIBB902", "ar0Imp", "N" ) == "S"
			Appe Blan
			lcAlicuota = Str( 6.00, 5, 2 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "TPIIBB902",;
				PICTTR With "99.99",;
				DESCTR With 'Tasa Percepcion IIBB (Buenos Aires)',;
				LEYETR With "S_ACLDEC(2,2)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 5,;
				DECITR With 2,;
				DEFATR With lcAlicuota

			Appe Blan
			lcImporte = Str( 50, 9, 2 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "NoPer902",;
				PICTTR With "999999.99",;
				DESCTR With 'Neto No Imponible Per. IIBB (Buenos Aires)',;
				LEYETR With "S_ACLDEC(6,2)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 9,;
				DECITR With 2,;
				DEFATR With lcImporte
		Endif



		If GetValue( "RIIBB902", "ar0Imp", "N" ) == "S"
			Appe Blan
			lcAlicuota = Str( 3.00, 5, 2 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "TRIIBB902",;
				PICTTR With "99.99",;
				DESCTR With 'Tasa Retención IIBB (Buenos Aires)',;
				LEYETR With "S_ACLDEC(2,2)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 5,;
				DECITR With 2,;
				DEFATR With lcAlicuota

			Appe Blan
			lcImporte = Str( 400.00, 9, 2 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "NoRet902",;
				PICTTR With "999999.99",;
				DESCTR With 'Neto No Imponible Ret. IIBB (Buenos Aires)',;
				LEYETR With "S_ACLDEC(6,2)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 9,;
				DECITR With 2,;
				DEFATR With lcImporte

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "NRetIb902",;
				PICTTR With "99999999",;
				DESCTR With 'Último Nº Certificado Ret. IIBB (Buenos Aires)',;
				LEYETR With "S_ACLNRO(8)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE

		Endif

		If Inlist( "S", GetValue( "RIIBB901", "ar0Imp", "N" ), GetValue( "RIIBB902", "ar0Imp", "N" ) )


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "RetIB05",;
				PICTTR With "!",;
				DESCTR With "¿Retiene IIBB a Exentos?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "RetIB07",;
				PICTTR With "!",;
				DESCTR With "¿Retiene IIBB a Monotributistas?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "S"

		Endif


		If Inlist( "S", GetValue( "PIIBB901", "ar0Imp", "N" ), GetValue( "PIIBB902", "ar0Imp", "N" ) )
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "RutaPadron",;
				PICTTR With "@S27",;
				DESCTR With "Ruta de Ubicación de los Padrones",;
				LEYETR With "",;
				PREFTR With "PreF1Folder()",;
				POSFTR With "PosF1Folder()",;
				SELETR With "ar0Var",;
				ORDETR With WORDE,;
				WIDTTR With 180

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "RutaSiap",;
				PICTTR With "@S27",;
				DESCTR With "Ruta de Exportación Archivos para el Siap",;
				LEYETR With "",;
				PREFTR With "PreF1Folder()",;
				POSFTR With "PosF1Folder()",;
				SELETR With "ar0Var",;
				ORDETR With WORDE,;
				WIDTTR With 180

		Endif


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "RGAN0",;
			PICTTR With "!",;
			DESCTR With "¿PIDE RETENCION GANANCIAS?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "AR0PRC",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "S"

		If GetValue( "RGAN0", "AR0PRC", "N" ) == "S"

			*!*				Appe Blan
			*!*				lcImporte = Str( 100000.00, 9, 2 )
			*!*				WORDE=WORDE+1
			*!*				Repl TIPOTR With "N",;
			*!*					CAMPTR With "NoRetGan",;
			*!*					PICTTR With "999999.99",;
			*!*					DESCTR With 'Neto No Imponible Ret. Ganancias',;
			*!*					LEYETR With "S_ACLDEC(6,2)",;
			*!*					VALITR With "I_VALMOI(WDATO, 0 )",;
			*!*					PREFTR With "",;
			*!*					POSFTR With "",;
			*!*					SELETR With "ar0Imp",;
			*!*					ORDETR With WORDE,;
			*!*					WIDTTR With 9,;
			*!*					DECITR With 2,;
			*!*					DEFATR With lcImporte

			Appe Blan
			lcImporte = Str( 100000.00, 9, 2 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "RetG0",;
				PICTTR With "999999.99",;
				DESCTR With 'Neto No Imponible Ret. Ganancias',;
				LEYETR With "S_ACLDEC(6,2)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Prc",;
				ORDETR With WORDE,;
				WIDTTR With 9,;
				DECITR With 2,;
				DEFATR With lcImporte

			Appe Blan
			lcImporte = Str( 150.00, 9, 2 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "Min_RetG",;
				PICTTR With "999999.99",;
				DESCTR With 'Mínima Ret. Ganancias a efectuar',;
				LEYETR With "S_ACLDEC(6,2)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE,;
				WIDTTR With 9,;
				DECITR With 2,;
				DEFATR With lcImporte


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "NRetGan",;
				PICTTR With "99999999",;
				DESCTR With 'Último Nº Certificado Ret. Ganancias',;
				LEYETR With "S_ACLNRO(8)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "ar0Imp",;
				ORDETR With WORDE

		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "IMPI0",;
			PICTTR With "!",;
			DESCTR With "¿PIDE IMPUESTOS INTERNOS?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "AR0PRC",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"


	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Impuestos


*
*
Procedure FacturaElectronica( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Local lcCommand As String

	Try

		lcCommand = ""

		loOpcion = loOpciones.GetItem( PRM_FactEle )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "FELE0",;
			PICTTR With "!",;
			DESCTR With "GENERA FACTURA ELECTRONICA",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "AR0FEL",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "N",;
			CAMPTR With "PVEN0",;
			PICTTR With "@Z 9999",;
			DESCTR With 'Punto de Venta',;
			LEYETR With "S_ACLNRO(4)",;
			VALITR With "I_VALMOI(WDATO,0)",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "AR0FEL",;
			ORDETR With WORDE,;
			WIDTTR With 4,;
			DECITR With 0,;
			DEFATR With "0"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "cFCE",;
			PICTTR With "!",;
			DESCTR With "GENERA FACTURA DE CREDITO ELECTRONICA",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "AR0FEL",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		If GetValue( "cFCE", "ar0FEL", "N" ) = "S"
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "CBU",;
				PICTTR With "99999999-99999999999999",;
				DESCTR With "CBU",;
				LEYETR With "S_LINE24( [Ingrese los 22 dígitos del CBU] )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "AR0FEL",;
				ORDETR With WORDE,;
				WIDTTR With 25,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "Alias_CBU",;
				PICTTR With Replicate( "!", 20 ),;
				DESCTR With "ALIAS CBU",;
				LEYETR With "S_LINE24( [Ingrese entre 6 y 20 caracteres] )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "AR0FEL",;
				ORDETR With WORDE,;
				WIDTTR With 25,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "M",;
				CAMPTR With "FCE_Leye",;
				PICTTR With Replicate( 'X', 39 ),;
				DESCTR With "Leyenda",;
				LEYETR With "Ingrese la leyenda de la Factura de Crédito Electrónica",;
				PREFTR With "PreMemoEdit()",;
				POSFTR With "PosMemoEdit()",;
				VALITR With "",;
				SELETR With "AR0FEL",;
				ORDETR With WORDE,;
				DEFATR With ""

			Appe Blan
			lcImporte = Str( 100000.00, 12, 2 )
			WORDE=WORDE+1
			Repl TIPOTR With "N",;
				CAMPTR With "nFCE_Impo",;
				PICTTR With "999999999.99",;
				DESCTR With 'Importe Mínimo para FCE',;
				LEYETR With "S_ACLDEC(12,2)",;
				VALITR With "I_VALMOI(WDATO, 0 )",;
				PREFTR With "",;
				POSFTR With "",;
				SELETR With "AR0FEL",;
				ORDETR With WORDE,;
				WIDTTR With 12,;
				DECITR With 2,;
				DEFATR With lcImporte

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "SCA_ADC",;
				PICTTR With Replicate( "!", 3 ),;
				DESCTR With "Transfiere a",;
				LEYETR With "S_LINE24( [SCA o ADC] )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "AR0FEL",;
				ORDETR With WORDE,;
				WIDTTR With 3,;
				DEFATR With "   "

		Endif


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "N",;
			CAMPTR With "MODO0",;
			PICTTR With "9",;
			DESCTR With 'Modo',;
			LEYETR With "S_LINE24([ 0: Prueba       1: Producción ])",;
			VALITR With "I_VALRAN(WDATO,0,1)",;
			PREFTR With "PREMODO()",;
			POSFTR With "POSMODO()",;
			SELETR With "AR0FEL",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "0"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "CUIT0",;
			PICTTR With "99999999999",;
			DESCTR With "Cuit Emisor",;
			LEYETR With "S_LINE24([Ingrese el Cuit sin guiones ni espacios])",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "AR0FEL",;
			ORDETR With WORDE,;
			WIDTTR With 11,;
			DECITR With 0,;
			DEFATR With "00000000000"

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "CERT0",;
			PICTTR With "@S27",;
			DESCTR With "Archivo de Certificado",;
			LEYETR With "",;
			PREFTR With "PRECERT0()",;
			POSFTR With "POSCERT0()",;
			SELETR With "AR0FEL",;
			ORDETR With WORDE,;
			WIDTTR With 200


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "LICE0",;
			PICTTR With "@S27",;
			DESCTR With "Archivo de Licencia",;
			LEYETR With "",;
			PREFTR With "PRELICE0()",;
			POSFTR With "POSLICE0()",;
			SELETR With "AR0FEL",;
			ORDETR With WORDE,;
			WIDTTR With 200

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "N",;
			CAMPTR With "CoFe0",;
			PICTTR With "9",;
			DESCTR With 'Cantida de Copias',;
			LEYETR With "S_ACLNRO(1)",;
			VALITR With "I_VALMOI(WDATO,0)",;
			PREFTR With "",;
			POSFTR With "",;
			SELETR With "AR0FEL",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "2"


		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "QR_Genera",;
			PICTTR With "!",;
			DESCTR With "Genera de Código QR",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "AR0FEL",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		If GetValue( "QR_Genera", "ar0FEL", "N" ) = "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "QR_Folder",;
				PICTTR With "@S37",;
				DESCTR With "Carpeta de Códigos QR",;
				LEYETR With "",;
				PREFTR With "PreF1Folder()",;
				POSFTR With "PosF1Folder()",;
				SELETR With "ar0Fel",;
				ORDETR With WORDE,;
				WIDTTR With 180,;
				DEFATR With "s:\Codigos_QR\"

		Endif

		If GetValue( "PDFAuto", "ar0Var", "N" ) = "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "PDFAuto",;
				PICTTR With "!",;
				DESCTR With "¿Genera PDF automáticamente?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Fel",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With GetValue( "PDFAuto", "ar0Var", "N" )

			If GetValue( "PDFAuto", "ar0Fel", "N" ) = "S"
				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "RutaPDF",;
					PICTTR With "@S27",;
					DESCTR With "Ruta de Exportación a PDF",;
					LEYETR With "",;
					PREFTR With "PreF1Folder()",;
					POSFTR With "PosF1Folder()",;
					SELETR With "ar0Fel",;
					ORDETR With WORDE,;
					WIDTTR With 180,;
					DEFATR With GetValue( "RutaPDF", "ar0Var", "" )

			Endif
		Endif

		If GetValue( "SendMail", "ar0Mai", "N" ) = "S"
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "SendMail",;
				PICTTR With "!",;
				DESCTR With "¿Envía E-Mail?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Fel",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "N"

			If GetValue( "SendMail", "ar0Fel", "N" ) = "S"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "I",;
					CAMPTR With "CuentaFE",;
					PICTTR With "999",;
					DESCTR With "Cuenta para Factura Electrónica",;
					LEYETR With "",;
					PREFTR With "PreCuentaMail()",;
					POSFTR With "PosCuentaMail()",;
					SELETR With "ar0Fel",;
					ORDETR With WORDE

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "M_Enviados",;
					PICTTR With "!",;
					DESCTR With "¿Copia a Enviados?",;
					LEYETR With "S_LINE24(MSG24)",;
					PREFTR With "PreSiNo()",;
					POSFTR With "PosSiNo()",;
					VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
					SELETR With "ar0Fel",;
					ORDETR With WORDE,;
					WIDTTR With 1,;
					DECITR With 0,;
					DEFATR With "N"

			Endif

		Endif

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "WSPUC",;
			PICTTR With "!",;
			DESCTR With "Utiliza el Padrón de Contribuyentes",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "AR0FEL",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DEFATR With "N"

		If GetValue( "WSPUC", "AR0FEL", "N" ) = "S"

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "WSPUC_Cert",;
				PICTTR With "@S27",;
				DESCTR With "Archivo de Certificado Padrón Cuit",;
				LEYETR With "",;
				PREFTR With "PRECERT0()",;
				POSFTR With "POSCERT0()",;
				SELETR With "AR0FEL",;
				ORDETR With WORDE,;
				WIDTTR With 200


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "WSPUC_Lic",;
				PICTTR With "@S27",;
				DESCTR With "Archivo de Licencia Padrón Cuit",;
				LEYETR With "",;
				PREFTR With "PRELICE0()",;
				POSFTR With "POSLICE0()",;
				SELETR With "AR0FEL",;
				ORDETR With WORDE,;
				WIDTTR With 200

		Endif




	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && FacturaElectronica

*
*
Procedure Envío_de_Mails( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Try

		loOpcion = loOpciones.GetItem( PRM_Mails )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "SendMail",;
			PICTTR With "!",;
			DESCTR With "¿Envía E-Mail?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Mai",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N"

		If GetValue( "SendMail", "ar0Mai", "N" ) = "S"
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "M_Enviados",;
				PICTTR With "!",;
				DESCTR With "¿Copia a Enviados?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Mai",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "N"


			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "I",;
				CAMPTR With "Default",;
				PICTTR With "999",;
				DESCTR With "Cuenta Predeterminada",;
				LEYETR With "",;
				PREFTR With "PreCuentaMail()",;
				POSFTR With "PosCuentaMail()",;
				SELETR With "ar0Mai",;
				ORDETR With WORDE

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "LogSend",;
				PICTTR With "!",;
				DESCTR With "¿Guarda Log de Enviados?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Mai",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "N"

		Endif


	Catch To oErr
		Local loError As PrxErrorHandler Of "fw\ErrorHandler\prxErrorHandler.prg"

		loError = Newobject( "PrxErrorHandler", "prxErrorHandler.prg" )
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

Endproc && Envío_de_Mails

*
*
Procedure Integracion_Web( loOpciones As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg ) As Void
	Local lcCommand As String,;
		lcAlias As String
	Local loConsumirApi As Ml_Consumir_Api Of "Tools\JSON\Prg\XmlHttp.prg",;
		loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
		loRespuesta As Object,;
		loReg As Object


	Try

		lcCommand = ""
		loOpcion = loOpciones.GetItem( PRM_IntegracionWeb )

		Appe Blan
		Repl TITUTR With loOpcion.Descripcion
		Appe Blan

		Appe Blan
		WORDE=WORDE+1
		Repl TIPOTR With "C",;
			CAMPTR With "Integra",;
			PICTTR With "!",;
			DESCTR With "¿Integra en la Nube?",;
			LEYETR With "S_LINE24(MSG24)",;
			PREFTR With "PreSiNo()",;
			POSFTR With "PosSiNo()",;
			VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
			SELETR With "ar0Web",;
			ORDETR With WORDE,;
			WIDTTR With 1,;
			DECITR With 0,;
			DEFATR With "N",;
			ACTUTR With "ACT_Integracion_Web()"

		If GetValue( "Integra", "ar0Web", "N" ) = "S"
			Appe Blan
			WORDE=WORDE+1

			Repl TIPOTR With "C",;
				CAMPTR With "Auth_Url",;
				PICTTR With "@S36",;
				DESCTR With "URL de Autenticación",;
				LEYETR With "S_ACLSTR( 200 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 200,;
				DECITR With 0,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1


			Repl TIPOTR With "C",;
				CAMPTR With "Base_Url",;
				PICTTR With "@S36",;
				DESCTR With "URL Base",;
				LEYETR With "S_ACLSTR( 200 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 200,;
				DECITR With 0,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1

			*!*				Repl TIPOTR With "C",;
			*!*					CAMPTR With "Sistema",;
			*!*					PICTTR With "@S36",;
			*!*					DESCTR With "URL Archivos de Sistema",;
			*!*					LEYETR With "S_ACLSTR( 200 )",;
			*!*					PREFTR With "",;
			*!*					POSFTR With "",;
			*!*					VALITR With "",;
			*!*					SELETR With "ar0Web",;
			*!*					ORDETR With WORDE,;
			*!*					WIDTTR With 200,;
			*!*					DECITR With 0,;
			*!*					DEFATR With ""

			*!*				Appe Blan
			*!*				WORDE=WORDE+1

			*!*				Repl TIPOTR With "C",;
			*!*					CAMPTR With "Maestros",;
			*!*					PICTTR With "@S36",;
			*!*					DESCTR With "URL Archivos Maestros",;
			*!*					LEYETR With "S_ACLSTR( 200 )",;
			*!*					PREFTR With "",;
			*!*					POSFTR With "",;
			*!*					VALITR With "",;
			*!*					SELETR With "ar0Web",;
			*!*					ORDETR With WORDE,;
			*!*					WIDTTR With 200,;
			*!*					DECITR With 0,;
			*!*					DEFATR With ""

			*!*				Appe Blan
			*!*				WORDE=WORDE+1

			*!*				Repl TIPOTR With "C",;
			*!*					CAMPTR With "Movimiento",;
			*!*					PICTTR With "@S36",;
			*!*					DESCTR With "URL Archivos de Movimientos",;
			*!*					LEYETR With "S_ACLSTR( 200 )",;
			*!*					PREFTR With "",;
			*!*					POSFTR With "",;
			*!*					VALITR With "",;
			*!*					SELETR With "ar0Web",;
			*!*					ORDETR With WORDE,;
			*!*					WIDTTR With 200,;
			*!*					DECITR With 0,;
			*!*					DEFATR With ""

			*!*				Appe Blan
			*!*				WORDE=WORDE+1

			Repl TIPOTR With "C",;
				CAMPTR With "Usuario",;
				PICTTR With Replicate( 'X', 30 ),;
				DESCTR With "Usuario",;
				LEYETR With "S_ACLSTR( 30 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 30,;
				DECITR With 0,;
				DEFATR With ""


			Appe Blan
			WORDE=WORDE+1

			Repl TIPOTR With "C",;
				CAMPTR With "Password",;
				PICTTR With Replicate( 'X', 30 ),;
				DESCTR With "Password",;
				LEYETR With "S_ACLSTR( 30 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 30,;
				DECITR With 0,;
				DEFATR With ""

			*!*				Appe Blan
			*!*				WORDE=WORDE+1

			*!*				Repl TIPOTR With "C",;
			*!*					CAMPTR With "Password1",;
			*!*					PICTTR With Replicate( 'X', 30 ),;
			*!*					DESCTR With "Confirmar Password",;
			*!*					LEYETR With "S_ACLSTR( 30 )",;
			*!*					PREFTR With "",;
			*!*					POSFTR With "",;
			*!*					VALITR With "",;
			*!*					SELETR With "ar0Web",;
			*!*					ORDETR With WORDE,;
			*!*					WIDTTR With 30,;
			*!*					DECITR With 0,;
			*!*					DEFATR With ""

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "Token",;
				PICTTR With "@S36",;
				DESCTR With "Token de Ingreso",;
				LEYETR With "S_ACLSTR( 40 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 40,;
				DECITR With 0,;
				DEFATR With ""


			*!*				Appe Blan
			*!*				WORDE=WORDE+1

			*!*				Repl TIPOTR With "D",;
			*!*					CAMPTR With "Token_ET",;
			*!*					PICTTR With "",;
			*!*					DESCTR With "Fecha de Expiración",;
			*!*					LEYETR With "",;
			*!*					PREFTR With "",;
			*!*					POSFTR With "",;
			*!*					VALITR With "",;
			*!*					SELETR With "ar0Web",;
			*!*					ORDETR With WORDE,;
			*!*					DEFATR With Dtoc( Date() + 1 )

			*!*				Repl TIPOTR With "T",;
			*!*					CAMPTR With "Token_TS",;
			*!*					PICTTR With "",;
			*!*					DESCTR With "Fecha de Expiración",;
			*!*					LEYETR With "",;
			*!*					PREFTR With "",;
			*!*					POSFTR With "",;
			*!*					VALITR With "",;
			*!*					SELETR With "ar0Web",;
			*!*					ORDETR With WORDE,;
			*!*					DEFATR With Ttoc( Datetime() )

		Endif


		If .F.
			* RA 11/07/2020(16:03:19)
			* Se parametriza en la aplicacion de Mercado Libre
			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "MLibre",;
				PICTTR With "!",;
				DESCTR With "¿Integra con Mercado Libre?",;
				LEYETR With "S_LINE24(MSG24)",;
				PREFTR With "PreSiNo()",;
				POSFTR With "PosSiNo()",;
				VALITR With "I_Valida( InList( WDATO, 'S', 'N' ))",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 1,;
				DECITR With 0,;
				DEFATR With "N"

		Endif

		If .F. && GetValue( "MLibre", "ar0Web", "N" ) = "S"
			* RA 11/07/2020(16:03:19)
			* Se parametriza en la aplicacion de Mercado Libre

			lcAlias = Alias()

			M_USE( 0, Alltrim( DRVA ) + "ar0Web" )

			If !Empty( Field( "ML_App_Id", "ar0Web" )) And !Empty( ar0Web.ML_App_Id )
				loReg = ScatterReg( .F., "ar0Web" )
				loConsumirApi 		= NewConsumirApi( "ML" )
				lcAPI 				= loConsumirApi.ObtenerAPI( "EMPRESA" )
				loRespuesta 		= loConsumirApi.&lcAPI.( "RETRIEVE", loReg )

				If loRespuesta.lOk
					Select ar0Web
					M_INIACT( 2 )
					Gather Name loRespuesta.Data Memo
					Unlock
				Endif

			Endif

			Select Alias( lcAlias )

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ML_Auth",;
				PICTTR With "@S36",;
				DESCTR With "URL de Autenticación",;
				LEYETR With "S_ACLSTR( 200 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 200,;
				DECITR With 0,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ML_Mae",;
				PICTTR With "@S36",;
				DESCTR With "URL Archivos Maestros",;
				LEYETR With "S_ACLSTR( 200 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 200,;
				DECITR With 0,;
				DEFATR With ""

			If GetValue( "Integra", "ar0Web", "N" ) = "N"

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "Usuario",;
					PICTTR With Replicate( 'X', 30 ),;
					DESCTR With "Usuario Fénix",;
					LEYETR With "S_ACLSTR( 30 )",;
					PREFTR With "",;
					POSFTR With "",;
					VALITR With "",;
					SELETR With "ar0Web",;
					ORDETR With WORDE,;
					WIDTTR With 30,;
					DECITR With 0,;
					DEFATR With ""

				Appe Blan
				WORDE=WORDE+1
				Repl TIPOTR With "C",;
					CAMPTR With "Password",;
					PICTTR With Replicate( 'X', 30 ),;
					DESCTR With "Password Fénix",;
					LEYETR With "S_ACLSTR( 30 )",;
					PREFTR With "",;
					POSFTR With "",;
					VALITR With "",;
					SELETR With "ar0Web",;
					ORDETR With WORDE,;
					WIDTTR With 30,;
					DECITR With 0,;
					DEFATR With ""

			Endif

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ML_Tkn_Fnx",;
				PICTTR With "@S36",;
				DESCTR With "Token de Ingreso Fénix",;
				LEYETR With "S_ACLSTR( 40 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 40,;
				DECITR With 0,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ML_App_Id",;
				PICTTR With Replicate( "X", 20 ),;
				DESCTR With "ID de la Aplicación",;
				LEYETR With "S_ACLSTR( 20 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 20,;
				DECITR With 0,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ML_Sec_Key",;
				PICTTR With Replicate( "X", 32 ),;
				DESCTR With "Clave Secreta",;
				LEYETR With "S_ACLSTR( 32 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 32,;
				DECITR With 0,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ML_Red_Url",;
				PICTTR With "@S36",;
				DESCTR With "URL de redireccionamiento",;
				LEYETR With "S_ACLSTR( 200 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 200,;
				DECITR With 0,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ML_User_Id",;
				PICTTR With Replicate( "9", 15 ),;
				DESCTR With "ID de Usuario",;
				LEYETR With "S_ACLNRO( 15 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 15,;
				DECITR With 0,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ML_Code",;
				PICTTR With "@S36",;
				DESCTR With "Código de Acceso",;
				LEYETR With "S_ACLSTR( 50 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 50,;
				DECITR With 0,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ML_Token",;
				PICTTR With "@S36",;
				DESCTR With "TOKEN de Acceso",;
				LEYETR With "S_ACLSTR( 100 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 100,;
				DECITR With 0,;
				DEFATR With ""

			Appe Blan
			WORDE=WORDE+1
			Repl TIPOTR With "C",;
				CAMPTR With "ML_Rfr_Tkn",;
				PICTTR With "@S36",;
				DESCTR With "TOKEN de Refresco",;
				LEYETR With "S_ACLSTR( 100 )",;
				PREFTR With "",;
				POSFTR With "",;
				VALITR With "",;
				SELETR With "ar0Web",;
				ORDETR With WORDE,;
				WIDTTR With 100,;
				DECITR With 0,;
				DEFATR With ""

		Endif

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

Endproc && Integracion_Web

*
*
Procedure ACT_Integracion_Web(  ) As Void
	Local lcCommand As String
	Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

	Try

		lcCommand = ""
		loGlobalSettings = NewGlobalSettings()
		loGlobalSettings.lIntegracionWeb = (GetValue( "Integra", "ar0Web", "N" ) = "S")

		*!*			TEXT To lcMsg NoShow TextMerge Pretext 03
		*!*			<<Program()>>
		*!*			lIntegracionWeb: <<loGlobalSettings.lIntegracionWeb>>
		*!*			ENDTEXT

		*!*			Inform( lcMsg )


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loGlobalSettings = Null

	Endtry

Endproc && ACT_Integracion_Web

