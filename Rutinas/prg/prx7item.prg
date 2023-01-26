#INCLUDE "FW\Comunes\Include\Praxis.h"

Note: Pedido de items en Forma tabular
Lparameters lnCantidadInicial,;
	lnPrimeraFila,;
	lcNumProg,;
	lnCantMaxima,;
	lcVarNameCantidad,;
	lcEliminaUDF,;
	lcRecuperaUDF,;
	lnAccion,;
	llAgregaDirecto,;
	lnConfirma,;
	lcAlias,;
	lnItemsPorPantalla

* Descripcion de parametros

* lnCantidadInicial: 	Cantidad inicial de registros del archivo
* lnPrimeraFila: 			Numero de la primer fila de la pantalla
* lcNumProg: 			Numero de programa
* lnCantMaxima: 		Cantidad maxima de registros del archivo
* lcVarNameCantidad: 	Nombre de la variable donde tengo la cantidad actual de registros
* lcEliminaUDF: 		Nombre de la rutina(alternativa) a ejecutar en eliminacion
*        					Pasa como parametros la linea y la fila actuales
* lcRecuperaUDF: 		Nombre de la rutina(alternativa) a ejecutar en recuperacion
*        					Pasa como parametros la linea y la fila actuales
* lnAccion: 			1. Total, 2. Modifica, 3. Elimina, 4. Consulta, 5. Agrega y modifica
* llAgregaDirecto: 		.T. En modificacion va directo a agregar, .F. Va a opciones
* lnConfirma: 			0. No confirma, 1.Confirma con 0, 2. Confirma con F8,;
*		  				3. Confirma con ambos, 4. Confirma con F5 y F8,;
*		  				5. Confirma con [Enter], cancela con [Esc]
* lcAlias: 				Letra identificatoria del area del archivo transitorio
* lnItemsPorPantalla: 	Cantidad de items por pantalla (Default = 10)

Local lo7item As Prx7item Of "V:\Clipper2fox\Rutinas\Prg\Prx7item.prg"

Local lcCommand As String

Try

	lcCommand = ""

	lo7item = Newobject( "Prx7item", "V:\Clipper2fox\Rutinas\Prg\Prx7item.prg" )

	lo7item.nCantidadDeRegistros 	= lnCantidadInicial
	lo7item.nPrimeraFila 			= lnPrimeraFila
	lo7item.cNumProg 				= lcNumProg
	lo7item.nCantMaxima 			= lnCantMaxima
	lo7item.nAccion 				= lnAccion
	lo7item.lAgregaDirecto 			= llAgregaDirecto
	lo7item.nConfirma 				= lnConfirma
	lo7item.cAlias 					= lcAlias

	If !Empty( lcEliminaUDF )
		lo7item.cUdfEliminacion 	= lcEliminaUDF
	Endif

	If !Empty( lcRecuperaUDF )
		lo7item.cUdfRecuperacion 	= lcRecuperaUDF
	Endif


	If !Empty( lnItemsPorPantalla )
		lo7item.nItemsPorPantalla 	= lnItemsPorPantalla
	Endif

	lo7item.Process()

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally
	lo7item = Null

Endtry

Return





*!* ///////////////////////////////////////////////////////
*!* Class.........: Prx7item
*!* ParentClass...: prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....: Custom
*!* Description...: Ingreso y Consulta de Datos a una tabla
*!* Date..........: Viernes 20 de Enero de 2012 (10:26:52)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class Prx7item As prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'

	#If .F.
		Local This As Prx7item Of "V:\Clipper2fox\Rutinas\Prg\Prx7item.prg"
	#Endif


	* Lista de teclas válidas
	cTeclasValidas = ""

	* Contiene la opcion del modulo de actualizacion y consulta
	nKeyPress = 0

	* Indica el numero de linea en el cual me encuentro en pantalla
	nLinea = 0

	* Indica el numero de fila donde me encuentro en la matriz
	nFila = 0

	* Indica si continua ingresando datos
	lIngresa = .F.

	* 1: alta, 2: Modificacion
	*!*	#Define r7_Alta			1
	*!*	#Define r7_Modificacion	2
	nTipo = 0

	* Contiene el numero de renglon a mostrar
	nRenglon = 0

	* Mensaje en linea 23
	cMensaje = ""

	* Numero de registro
	nRecNo = 0

	* Máximo número de columnas
	nMaxCol = 80

	* Nombre de la rutina(alternativa) a ejecutar en eliminacion
	cUdfEliminacion = "V_Null"

	* Nombre de la rutina(alternativa) a ejecutar en recuperacion
	cUdfRecuperacion = "V_Null"

	* Alias de la tabla
	cAlias = ""

	* 1. Total, 2. Modifica, 3. Elimina, 4. Consulta, 5. Agrega y modifica
	*!*	#Define r7_Total			1
	*!*	#Define r7_Modifica			2
	*!*	#Define r7_Elimina			3
	*!*	#Define r7_Consulta			4
	*!*	#Define r7_AgregaYModifica 	5
	*!*	#Define r7_ConsultaPorItem	6
	nAccion = 1

	* 0. No confirma, 1.Confirma con 0, 2. Confirma con F8,;
	* 3. Confirma con ambos, 4. Confirma con F5 y F8,;
	* 5. Confirma con [Enter], cancela con [Esc]
	*!*	#Define r7_NoConfirma			0
	*!*	#Define r7_ConfirmaCon_0		1
	*!*	#Define r7_ConfirmaCon_F8		2
	*!*	#Define r7_ConfirmaConAmbos		3
	*!*	#Define r7_ConfirmaCon_F5_y_F8	4
	*!*	#Define r7_ConfirmaCon_Enter_CancelaCon_Esc	5
	nConfirma = 0

	* Cantidad de Items por Pantalla
	nItemsPorPantalla = 10

	* .T. En modificacion va directo a agregar, .F. Va a opciones
	lAgregaDirecto = .F.

	*
	nCantidadDeRegistros = 0

	* Numero de la primer fila de la pantalla
	nPrimeraFila = 0

	* Numero de Programa
	cNumProg = ""

	* Cantidad maxima de registros del archivo
	nCantMaxima = 999999

	* Indica que elimina físicamente el registro, en vez de marcarlo como borrado
	lEliminacionFisica = .F.

	* Colección de Procesos que se pueden ejecutar con [Alt]+[F5]
	oColProcesos = Null

	* Indica si detecta los clicks del mouse
	lMouseDown = .F.

	* Backup del entorno al ejecutar un proceso externo
	oEnvironment = Null


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ncantmaxima" type="property" display="nCantMaxima" />] + ;
		[<memberdata name="cnumprog" type="property" display="cNumProg" />] + ;
		[<memberdata name="nprimerafila" type="property" display="nPrimeraFila" />] + ;
		[<memberdata name="ncantidadderegistros" type="property" display="nCantidadDeRegistros" />] + ;
		[<memberdata name="lagregadirecto" type="property" display="lAgregaDirecto" />] + ;
		[<memberdata name="nitemsporpantalla" type="property" display="nItemsPorPantalla" />] + ;
		[<memberdata name="nconfirma" type="property" display="nConfirma" />] + ;
		[<memberdata name="naccion" type="property" display="nAccion" />] + ;
		[<memberdata name="calias" type="property" display="cAlias" />] + ;
		[<memberdata name="cudfrecuperacion" type="property" display="cUdfRecuperacion" />] + ;
		[<memberdata name="cudfeliminacion" type="property" display="cUdfEliminacion" />] + ;
		[<memberdata name="nmaxcol" type="property" display="nMaxCol" />] + ;
		[<memberdata name="cteclasvalidas" type="property" display="cTeclasValidas" />] + ;
		[<memberdata name="nrecno" type="property" display="nRecNo" />] + ;
		[<memberdata name="cmensaje" type="property" display="cMensaje" />] + ;
		[<memberdata name="nrenglon" type="property" display="nRenglon" />] + ;
		[<memberdata name="ntipo" type="property" display="nTipo" />] + ;
		[<memberdata name="lingresa" type="property" display="lIngresa" />] + ;
		[<memberdata name="nfila" type="property" display="nFila" />] + ;
		[<memberdata name="nlinea" type="property" display="nLinea" />] + ;
		[<memberdata name="nkeypress" type="property" display="nKeyPress" />] + ;
		[<memberdata name="setup" type="method" display="SetUp" />] + ;
		[<memberdata name="inicio" type="method" display="Inicio" />] + ;
		[<memberdata name="ingreso" type="method" display="Ingreso" />] + ;
		[<memberdata name="muestra" type="method" display="Muestra" />] + ;
		[<memberdata name="consulta" type="method" display="Consulta" />] + ;
		[<memberdata name="posicionarse" type="method" display="Posicionarse" />] + ;
		[<memberdata name="goto" type="method" display="GoTo" />] + ;
		[<memberdata name="recno" type="method" display="Recno" />] + ;
		[<memberdata name="siguiente" type="method" display="Siguiente" />] + ;
		[<memberdata name="anterior" type="method" display="Anterior" />] + ;
		[<memberdata name="paginasiguiente" type="method" display="PaginaSiguiente" />] + ;
		[<memberdata name="paginaanterior" type="method" display="PaginaAnterior" />] + ;
		[<memberdata name="ultima" type="method" display="Ultima" />] + ;
		[<memberdata name="primera" type="method" display="Primera" />] + ;
		[<memberdata name="elimina" type="method" display="Elimina" />] + ;
		[<memberdata name="modifica" type="method" display="Modifica" />] + ;
		[<memberdata name="recupera" type="method" display="Recupera" />] + ;
		[<memberdata name="borra" type="method" display="Borra" />] + ;
		[<memberdata name="flecha" type="method" display="Flecha" />] + ;
		[<memberdata name="blanco" type="method" display="Blanco" />] + ;
		[<memberdata name="linea" type="method" display="Linea" />] + ;
		[<memberdata name="keypress" type="method" display="KeyPress" />] + ;
		[<memberdata name="process" type="method" display="Process" />] + ;
		[<memberdata name="hookaftersetup" type="method" display="HookAfterSetUp" />] + ;
		[<memberdata name="funciondeusuario" type="method" display="FuncionDeUsuario" />] + ;
		[<memberdata name="ejecutarfunciondeusuario" type="method" display="EjecutarFuncionDeUsuario" />] + ;
		[<memberdata name="leliminacionfisica" type="property" display="lEliminacionFisica" />] + ;
		[</VFPData>]

	*
	*
	Procedure Setup(  ) As Void

		Local lcCommand As String

		Try

			lcCommand = ""


			*!*				If Vartype( pnMaxCol ) = "N"
			*!*					This.nMaxCol = pnMaxCol
			*!*				Endif

			* Armado de la leyenda de opciones

			Do Case
				Case This.nAccion=r7_Total
					This.cMensaje=MSG7
					If This.nConfirma=r7_ConfirmaCon_Enter_CancelaCon_Esc
						This.cMensaje='[1]:Elimina [2]:Modifica [3]:Agrega [4]:Recupera [Esc]:Fin'
					Endif

				Case This.nAccion=r7_Modifica
					This.cMensaje='[2]:Modifica               [Esc]:Fin'

				Case This.nAccion=r7_Elimina
					This.cMensaje='[1]:Elimina          [4]:Recupera          [Esc]:Fin'

				Case InList( This.nAccion, r7_Consulta, r7_ConsultaPorItem )
					This.cMensaje='[Esc]:Fin'

				Case This.nAccion=r7_AgregaYModifica
					This.cMensaje='[2]:Modifica          [3]:Agrega          [Esc]:Fin'
				
				Case This.nAccion=r7_EliminaYModifica
					This.cMensaje='[1]:Elimina [2]:Modifica [4]:Recupera [Esc]:Fin'

			Endcase

			Do Case
				Case This.nConfirma=r7_ConfirmaCon_0
					This.cMensaje='[0]:Confirma '+This.cMensaje

				Case This.nConfirma=r7_ConfirmaCon_F8
					This.cMensaje='[F8]:Confirma '+This.cMensaje

				Case This.nConfirma=r7_ConfirmaConAmbos
					This.cMensaje='[0/F8]:Confirma '+This.cMensaje

				Case This.nConfirma=r7_ConfirmaCon_F5_y_F8
					This.cMensaje='[F8/F5]:Confirma '+This.cMensaje

				Case This.nConfirma=r7_ConfirmaCon_Enter_CancelaCon_Esc
					This.cMensaje='[Enter]:Confirma '+This.cMensaje

			Endcase

			* Armado de la variable de opciones

			Do Case
				Case This.nAccion=r7_Total
					This.cTeclasValidas='!InList( This.nKeyPress, UNO, DOS, TRES, CUATRO )'


				Case This.nAccion=r7_Modifica
					This.cTeclasValidas='!InList( This.nKeyPress, DOS )'

				Case This.nAccion=r7_Elimina
					This.cTeclasValidas='!InList( This.nKeyPress, UNO, CUATRO )'

				Case InList( This.nAccion, r7_Consulta, r7_ConsultaPorItem )
					This.cTeclasValidas='.T.'
					
				Case This.nAccion=r7_AgregaYModifica
					This.cTeclasValidas='!InList( This.nKeyPress, DOS, TRES )'
					
				Case This.nAccion=r7_EliminaYModifica
					This.cTeclasValidas='!InList( This.nKeyPress, UNO, DOS, CUATRO )'
					
			Endcase

			Do Case
				Case This.nConfirma=r7_ConfirmaCon_0
					This.cTeclasValidas=This.cTeclasValidas+' .AND. This.nKeyPress<>CERO'

				Case This.nConfirma=r7_ConfirmaCon_F8
					This.cTeclasValidas=This.cTeclasValidas+' .AND. This.nKeyPress<>F8'

				Case This.nConfirma=r7_ConfirmaConAmbos
					This.cTeclasValidas=This.cTeclasValidas+' .AND. This.nKeyPress<>F8 .AND. This.nKeyPress<>CERO'

				Case This.nConfirma=r7_ConfirmaCon_F5_y_F8
					This.cTeclasValidas=This.cTeclasValidas+' .AND. This.nKeyPress<>F8 .AND. This.nKeyPress<>F5'

				Case This.nConfirma=r7_ConfirmaCon_Enter_CancelaCon_Esc
					This.cTeclasValidas=This.cTeclasValidas+' .AND. This.nKeyPress<>ENTER'

			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry


		Return

	Endproc && SetUp



	*
	* Es llamado por SetUp para permitir al desarrollador personalizar la clase
	Procedure HookAfterSetUp(  ) As Void;
			HELPSTRING "Es llamado por SetUp para permitir al desarrollador personalizar la clase"
		Local lcCommand As String

		Try

			lcCommand = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && HookAfterSetUp


	*
	*
	Procedure Process(  ) As Boolean
		Local lcCommand As String

		Try

			lcCommand = ""


			* Inicializacion
			This.Setup()

			* Seteo de Usuario
			This.HookAfterSetUp()

			* RA 01/01/2019(11:35:01)
			* Solo la versión o7Item
			This.DefinirProcesosExternos()

			* Cuerpo principal del programa
			This.Inicio()

			Do Case
				Case This.nCantidadDeRegistros =0  ;
						And ( This.nAccion=r7_Total  Or  This.nAccion=r7_AgregaYModifica )

					This.Ingreso()                      && Ingreso datos a la tabla vacia
					This.lAgregaDirecto=.F.

				Case This.nCantidadDeRegistros <>0
					This.Muestra()                      && Muestro primeros registros

			Endcase

			This.Consulta()          && Act.y consulto la tabla


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return ( This.nKeyPress # Escape )

	Endproc && Process

	*
	* Inicializacion
	Procedure Inicio(  ) As Void;
			HELPSTRING "Inicializacion"
		Local lcCommand As String

		Try

			lcCommand = ""


			Select Alias( This.cAlias )
			Locate

			This.nKeyPress=0
			This.nLinea=1

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Inicio


	*
	* Ingreso o agregado de datos a la matriz
	Procedure Ingreso(  ) As Void;
			HELPSTRING "Ingreso o agregado de datos a la matriz"

		Local lcNumProg As String

		Local lcCommand As String

		Try

			lcCommand = ""


			lcNumProg 		= This.cNumProg
			This.lIngresa	= .T.
			This.nTipo		= r7_Alta

			Do Whil This.lIngresa  And  This.nCantidadDeRegistros<This.nCantMaxima

				This.Posicionarse()         && Me posiciono en la fila donde comienzo a ingresar
				Try
					Do PE&lcNumProg With This.nLinea+This.nPrimeraFila,This.lIngresa,This.nTipo

				Catch To loErr
					Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
					loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
					loError.cRemark = lcCommand
					loError.Process ( m.loErr )


					This.lIngresa = .F.

				Finally

				Endtry

				If This.lIngresa
					This.nCantidadDeRegistros = This.nCantidadDeRegistros + 1
					Select Alias( This.cAlias )
					Replace R7MOV With 'A'

				Else
					Do PA&lcNumProg With This.nLinea+This.nPrimeraFila

					Select Alias( This.cAlias )
					If This.nCantidadDeRegistros=0
						prxSetLastKey( 0 )
						This.lIngresa=.F.
					Endif
				Endif

			Enddo

			If This.nCantidadDeRegistros>=This.nCantMaxima
				Warning( 'No es posible ingresar informacion adicional' )

			Else
				If This.nCantidadDeRegistros > 0
					Try
						This.Primera()
						This.Ultima()

					Catch To loErr
						Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
						loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
						loError.cRemark = lcCommand
						loError.Process ( m.loErr )


					Finally

					Endtry

				Endif
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Ingreso




	*
	* Mostrado de los primeras filas de la matriz
	Procedure Muestra(  ) As Void;
			HELPSTRING "Mostrado de los primeras filas de la matriz"
		Local lcCommand As String

		Try

			lcCommand = ""


			Select Alias( This.cAlias )
			Locate

			This.nLinea=1

			Do While !Eof() ;
					And This.nLinea	<= This.nItemsPorPantalla  ;
					And This.nLinea	<= This.nCantidadDeRegistros

				This.Linea()
				This.nLinea = This.nLinea+1

				Select Alias( This.cAlias )
				Skip

			Enddo

			If This.nAccion<>r7_Consulta
				Locate
				This.nLinea=1
				This.Flecha()
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Muestra



	*
	* Procedimiento de consulta y actualizacion de los datos de la matriz
	Procedure Consulta() As Void;
			HELPSTRING "Procedimiento de consulta y actualizacion de los datos de la matriz"

		Local llExit As Boolean

		Local lcCommand As String

		Try

			lcCommand = ""


			If This.lAgregaDirecto=.F.
				S_Line23( This.cMensaje )
				S_Line24( Iif(!InList( This.nAccion, r7_Consulta, r7_ConsultaPorItem ),MSG3,'[PgDn]:Pant.Siguiente   '+;
					'[PgUp]:Pant.Anterior   [F9]:Inicio   [F10]:Final') )

				This.KeyPress()

			Else
				This.nKeyPress=TRES

			Endif

			llExit = .F.

			Do While !Inlist( This.nKeyPress, F8, CERO, F5 )
				Try

					Do Case
						Case This.EjecutarFuncionDeUsuario( This.nKeyPress )
							This.FuncionDeUsuario( This.nKeyPress )

						Case Inlist( This.nKeyPress, KEY_CTRL_F10, KEY_CTRL_F12 )
							prxSetLastKey( Escape )
							This.nKeyPress = Escape
							llExit = .T.

						Case This.nKeyPress=F3  ;
								And This.nAccion=r7_Total  ;
								And This.nConfirma<>r7_ConfirmaCon_Enter_CancelaCon_Esc

							prxSetLastKey( Escape )
							This.nKeyPress = Escape
							llExit = .T.

						Case This.nKeyPress=Escape  
								* And  ( This.nAccion<>r7_Total Or This.nConfirma=r7_ConfirmaCon_Enter_CancelaCon_Esc )

							llExit = .T.

						Case This.nKeyPress=Enter  ;
								And  This.nConfirma=r7_ConfirmaCon_Enter_CancelaCon_Esc

							llExit = .T.

						Case This.nKeyPress=Enter  Or  This.nKeyPress=ABAJO
							This.Siguiente()   && Se posiciona en el registro siguiente

						Case This.nKeyPress=Back  Or  This.nKeyPress=ARRIBA
							This.Anterior()  && Se posiciona en el registro anterior

						Case This.nKeyPress=MAS  Or  This.nKeyPress=PGDN
							This.PaginaSiguiente()  && Se posiciona en la pantalla siguiente

						Case This.nKeyPress=MENOS  Or  This.nKeyPress=PGUP
							This.PaginaAnterior()  && Se posiciona en la pantalla anterior

						Case This.nKeyPress=F10
							This.Ultima()  && Se posiciona en la ultima pantalla

						Case This.nKeyPress=F9
							This.Primera()  && Se posiciona en la primer pantalla

						Case This.nKeyPress=UNO
							This.Elimina()  && Elimina el registro

						Case This.nKeyPress=Dos
							This.Modifica()  && Modifica el registro

						Case This.nKeyPress=TRES
							This.Ingreso()

						Case This.nKeyPress=CUATRO
							This.Recupera()  && Recupera el registro

					Endcase

				Catch To loErr
					Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
					loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
					loError.cRemark = lcCommand
					loError.Process ( m.loErr )


				Finally


				Endtry


				If llExit
					Exit
				Endif

				If This.nKeyPress=Dos  Or  This.nKeyPress=TRES
					S_Line23( This.cMensaje )
					S_Line24( Iif( !InList( This.nAccion, r7_Consulta, r7_ConsultaPorItem ),MSG3,'[PgDn]:Pant.Siguiente   '+;
						'[PgUp]:Pant.Anterior   [F9]:Inicio   [F10]:Final') )
				Endif

				This.KeyPress()

			Enddo

			This.Blanco()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Consulta



	*
	* Se posiciona en la linea donde se ingresaran datos
	Procedure Posicionarse(  ) As Void;
			HELPSTRING "Se posiciona en la linea donde se ingresaran datos"
		Local lcCommand As String

		Try

			lcCommand = ""


			Select Alias( This.cAlias )

			Do Case
				Case This.nCantidadDeRegistros=0
					This.nLinea=1

				Case (Int(( This.Recno() + ( This.nItemsPorPantalla - 1 ) ) / This.nItemsPorPantalla ) * This.nItemsPorPantalla ) < This.nCantidadDeRegistros
					This.Blanco()
					This.nLinea=1

					Select Alias( This.cAlias )


					This.Goto( (Int(( This.nCantidadDeRegistros ) / This.nItemsPorPantalla ) * This.nItemsPorPantalla ) + 1 )

					Do Whil !Eof() ;
							And This.nLinea <= This.nItemsPorPantalla ;
							And This.Recno()<=This.nCantidadDeRegistros

						This.Linea()
						This.nLinea = This.nLinea + 1
						Select Alias( This.cAlias )
						Skip
					Enddo

					This.Borra()

				Othe
					This.Blanco()
					This.nLinea=Mod(This.nCantidadDeRegistros,This.nItemsPorPantalla) + 1

					If This.nLinea = 1
						This.Borra()
					Endif

			Endcase

			This.Flecha()

			Select Alias( This.cAlias )

			Try

				This.Goto( This.nCantidadDeRegistros+1 )

			Catch To oErr

			Finally

			Endtry


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Posicionarse



	*
	* Se posiciona en un registro
	Procedure Goto( nRegistro As Integer ) As Void;
			HELPSTRING "Se posiciona en un registro"
		Local lcCommand As String

		Try

			lcCommand = ""

			Select Alias( This.cAlias )
			Goto nRegistro

		Catch To loErr
			This.nCantidadDeRegistros = Reccount()
			Go Bottom

		Finally

		Endtry

	Endproc && GoTo



	*
	* Devuelve el registro sobre el que está posicionado
	Procedure Recno() As Integer;
			HELPSTRING "Devuelve el registro sobre el que está posicionado"
		Local lcCommand As String
		Local lnRecno As Integer

		Try

			lcCommand = ""
			lnRecno = Recno()


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lnRecno

	Endproc && Recno


	*
	* Se posiciona en la linea siguiente a la actual
	Procedure Siguiente(  ) As Void;
			HELPSTRING "Se posiciona en la linea siguiente a la actual"

		Local lnLine As Integer

		Local lcCommand As String

		Try

			lcCommand = ""


			If !Eof() And ( This.Recno() <> This.nCantidadDeRegistros ) And !Empty( This.nCantidadDeRegistros )
				This.Blanco()

				Select Alias( This.cAlias )
				Skip

				If This.nLinea=This.nItemsPorPantalla
					If !Eof()
						lnLine = This.Recno()

					Else
						lnLine = -1

					Endif

					This.nLinea=1
					Do Whil !Eof() And This.nLinea<=This.nItemsPorPantalla And This.Recno()<=This.nCantidadDeRegistros
						This.Linea()
						This.nLinea=This.nLinea+1
						Select Alias( This.cAlias )
						Skip
					Enddo
					*!*							Skip -This.nLinea+1
					If lnLine > 0
						This.Goto( lnLine )

					Else
						Go Bottom

					Endif

					This.Borra()
					This.nLinea=1

				Else
					This.nLinea=This.nLinea+1

				Endif

				This.Flecha()
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Siguiente



	*
	* Se posiciona en la linea anterior a la actual
	Procedure Anterior(  ) As Void;
			HELPSTRING "Se posiciona en la linea anterior a la actual"
		Local lcCommand As String

		Try

			lcCommand = ""


			Select Alias( This.cAlias )

			If This.Recno()>1
				This.Blanco()

				If This.nLinea=1
					Select Alias( This.cAlias )

					Try

						Skip -This.nItemsPorPantalla
						This.nLinea=1
						Do Whil !Eof() And This.nLinea<=This.nItemsPorPantalla
							This.Linea()
							Select Alias( This.cAlias )
							Skip
							This.nLinea=This.nLinea+1
						Enddo

						This.nLinea=This.nItemsPorPantalla

					Catch To loErr
						Locate
						This.nLinea=1
						Do Whil !Eof() And This.nLinea<=This.nItemsPorPantalla
							This.Linea()
							Select Alias( This.cAlias )
							Skip
							This.nLinea=This.nLinea+1
						Enddo

					Finally

					Endtry

				Else
					This.nLinea=This.nLinea-1
					Select Alias( This.cAlias )

				Endif

				Skip -1
				This.Flecha()
			Endif



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Anterior



	*
	* Se posiciona en la pantalla siguiente a la actual
	Procedure PaginaSiguiente(  ) As Void;
			HELPSTRING "Se posiciona en la pantalla siguiente a la actual"
		Local lcCommand As String

		Try

			lcCommand = ""


			Do Case
				Case This.nAccion<>r7_Consulta  And  Int((This.Recno()+(This.nItemsPorPantalla-1))/This.nItemsPorPantalla)*This.nItemsPorPantalla<This.nCantidadDeRegistros
					This.Blanco()

					Select Alias( This.cAlias )
					This.Goto( Int((This.Recno()+(This.nItemsPorPantalla-1))/This.nItemsPorPantalla)*This.nItemsPorPantalla+1 )
					This.nLinea=1

					Do Whil !Eof() And This.nLinea<=This.nItemsPorPantalla And This.Recno()<=This.nCantidadDeRegistros
						This.Linea()
						This.nLinea=This.nLinea+1
						Select Alias( This.cAlias )
						Skip
					Enddo

					Skip -This.nLinea+1

					This.Borra()
					This.nLinea=1
					This.Flecha()

				Case This.nAccion=r7_Consulta  And  !Eof()
					Select Alias( This.cAlias )
					This.nLinea=1

					Do Whil !Eof() And This.nLinea<=This.nItemsPorPantalla
						This.Linea()
						This.nLinea=This.nLinea+1
						Select Alias( This.cAlias )
						Skip
					Enddo

					This.Borra()
			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && PaginaSiguiente




	*
	* Se posiciona en la pantalla anterior a la actual
	Procedure PaginaAnterior(  ) As Void;
			HELPSTRING "Se posiciona en la pantalla anterior a la actual"
		Local lcCommand As String

		Try

			lcCommand = ""


			Do Case
				Case This.nAccion<>r7_Consulta  And  Int(This.Recno()/This.nItemsPorPantalla)<>0
					This.Blanco()

					Select Alias( This.cAlias )
					This.Goto( Int((This.Recno()-(This.nItemsPorPantalla+1))/This.nItemsPorPantalla)*This.nItemsPorPantalla+1 )

					This.nLinea=1

					Do Whil !Eof() And This.nLinea<=This.nItemsPorPantalla
						This.Linea()
						This.nLinea=This.nLinea+1
						Select Alias( This.cAlias )
						Skip
					Enddo

					Skip -This.nItemsPorPantalla
					This.nLinea=1
					This.Flecha()

				Case This.nAccion=r7_Consulta
					Select Alias( This.cAlias )
					If Eof() Or Bof()
						This.nRecNo = -1

					Else
						This.nRecNo = This.Recno()

					Endif

					Try

						Skip -This.nLinea

					Catch To loErr
					Finally

					Endtry

					If !Bof()
						Skip -(This.nItemsPorPantalla-1)
						This.nLinea=1

						Do Whil !Eof() And This.nLinea<=This.nItemsPorPantalla
							This.Linea()
							This.nLinea=This.nLinea+1
							Select Alias( This.cAlias )
							Skip
						Enddo

					Else
						If This.nRecNo > 0
							This.Goto( This.nRecNo )

						Else
							Go Top

						Endif

					Endif
			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && PaginaAnterior



	*
	* Se posiciona en la Ultima pantalla
	Procedure Ultima(  ) As Void;
			HELPSTRING "Se posiciona en la Ultima pantalla"

		Local lnRecno As Integer
		Local lcCommand As String
		Local lnCant As Integer

		Try

			lnRecno = 0
			lcCommand = ""

			Do Case
				Case This.nAccion<>r7_Consulta  &&  And  Recno()<>This.nCantidadDeRegistros
					This.Blanco()

					If Int((This.Recno()+(This.nItemsPorPantalla-1))/This.nItemsPorPantalla)*This.nItemsPorPantalla<This.nCantidadDeRegistros
						Select Alias( This.cAlias )

						lnRecno = ( Int(( This.nCantidadDeRegistros) / This.nItemsPorPantalla ) * This.nItemsPorPantalla ) + 1
						lnCant = This.nCantidadDeRegistros

						TEXT To lcCommand NoShow TextMerge Pretext 15
						<<lnRecno>> = ( Int(( <<lnCant>> ) / <<This.nItemsPorPantalla>> ) * <<This.nItemsPorPantalla>> ) + 1
						ENDTEXT

						If lnRecno > lnCant
							lnRecno = lnRecno - This.nItemsPorPantalla
						Endif

						This.Goto( lnRecno )

						This.nLinea=1
						Do Whil !Eof() And This.nLinea<=This.nItemsPorPantalla And This.Recno()<=This.nCantidadDeRegistros
							This.Linea()
							This.nLinea=This.nLinea+1
							Select Alias( This.cAlias )
							Skip
						Enddo

						This.Borra()
						This.nLinea=This.nLinea-1

					Else
						R7AUX= Mod( This.nCantidadDeRegistros, This.nItemsPorPantalla )
						This.nLinea=Iif(R7AUX<>0,R7AUX,This.nItemsPorPantalla)

					Endif

					Select Alias( This.cAlias )
					This.Goto( This.nCantidadDeRegistros )
					This.Flecha()

				Case This.nAccion=r7_Consulta  And  !Eof()
					Select Alias( This.cAlias )

					If Eof()
						This.nRecNo = -1

					Else
						This.nRecNo = This.Recno()

					Endif

					Skip This.nItemsPorPantalla
					Do Whil !Eof()
						This.nRecNo=This.Recno()
						Skip This.nItemsPorPantalla
					Enddo

					If This.nRecNo > 0
						This.Goto( This.nRecNo )
					Endif

					This.nLinea=1
					Do Whil !Eof() And This.nLinea<=This.nItemsPorPantalla
						This.Linea()
						This.nLinea=This.nLinea+1
						Select Alias( This.cAlias )
						Skip
					Enddo
					This.Borra()

			Endcase

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand

			If loErr.ErrorNo = 5
				loError.Cremark = lcCommand
			Endif

			loError.Process( oErr )
			Throw loError

		Finally

		Endtry



	Endproc && Ultima



	*
	* Se posiciona en la primer pantalla
	Procedure Primera(  ) As Void;
			HELPSTRING "Se posiciona en la primer pantalla"

		Local lcCommand As String

		Try

			lcCommand = ""


			Do Case
				Case This.nAccion<>r7_Consulta  &&  And  Recno()<>1
					This.Blanco()

					Select Alias( This.cAlias )
					Go Top

					This.nLinea=1
					Do Whil !Eof() And This.nLinea<=This.nItemsPorPantalla
						This.Linea()
						This.nLinea=This.nLinea+1
						Select Alias( This.cAlias )
						Skip
					Enddo

					This.nLinea=1
					Select Alias( This.cAlias )
					Go Top

					This.Flecha()

				Case This.nAccion=r7_Consulta
					Select Alias( This.cAlias )

					If Eof() Or Bof()
						This.nRecNo = -1

					Else
						This.nRecNo = This.Recno()

					Endif

					Try

						Skip -(This.nLinea)

					Catch To loErr
					Finally
					Endtry

					If !Bof()
						Go Top
						This.nLinea=1

						Do Whil !Eof() And This.nLinea<=This.nItemsPorPantalla
							This.Linea()
							This.nLinea=This.nLinea+1
							Select Alias( This.cAlias )
							Skip
						Enddo

					Else
						If This.nRecNo > 0
							This.Goto( This.nRecNo )

						Else
							Go Top

						Endif
					Endif
			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Primera


	*
	* Elimina el registro correspondiente a la linea
	Procedure Elimina(  ) As Void;
			HELPSTRING "Elimina el registro correspondiente a la linea"

		Local lcNumProg As String,;
			lcUdfEliminacion As String

		Local lnRecno As Integer,;
			lnLinea As Integer

		Local lcCommand As String

		Try

			lcCommand = ""


			If R7MOV<>'E'

				lcNumProg = This.cNumProg
				lcUdfEliminacion = This.cUdfEliminacion

				If This.lEliminacionFisica
					Select Alias( This.cAlias )
					lnRecno = This.Recno()
					lnLinea = This.nLinea
					Delete

					PackCursor()

					This.nCantidadDeRegistros = This.nCantidadDeRegistros - 1

					If lnRecno>This.nCantidadDeRegistros
						lnRecno = lnRecno - 1
						lnLinea = lnLinea - 1
					Endif

					If lnLinea < 1 And This.nCantidadDeRegistros > 0
						This.Primera()
						This.Ultima()

					Else

						If lnRecno > 1
							GotoRecno( lnRecno )

						Else
							Locate

						Endif

						If lnLinea < 1
							lnLinea = 1
						Endif

						This.nLinea=lnLinea

						Do Whil !Eof() ;
								And !Bof() ;
								And This.nLinea<=This.nItemsPorPantalla ;
								And This.Recno()<=This.nCantidadDeRegistros

							This.Linea()
							This.nLinea=This.nLinea+1
							Select Alias( This.cAlias )
							Skip

						Enddo

						This.Borra()

						GotoRecno( lnRecno )
						This.nLinea=lnLinea
						This.Flecha()

					Endif

				Else
					SETCOLOR(CL_LINE22)
					Do RE&lcNumProg With This.nLinea+This.nPrimeraFila
					SETCOLOR( CL_NORMAL )

					Select Alias( This.cAlias )
					Replace R7MOV With 'E'

				Endif

				Do &lcUdfEliminacion With This.nLinea+This.nPrimeraFila

			Else
				Warning( 'El registro ya ha sido eliminado' )

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Elimina



	*
	* Modifica el registro correspondiente a la linea
	Procedure Modifica(  ) As Void;
			HELPSTRING "Modifica el registro correspondiente a la linea"

		Local lcNumProg As String

		Local lcCommand As String

		Try

			lcCommand = ""


			If R7MOV<>'E'
				This.lIngresa	= .T.
				This.nTipo		= r7_Modificacion
				lcNumProg 		= This.cNumProg

				Do PE&lcNumProg With This.nLinea+This.nPrimeraFila,This.lIngresa,This.nTipo

				prxLastkey()
				This.Flecha()

				If &ABORTA
					Select Alias( This.cAlias )
					Do RE&lcNumProg With This.nLinea+This.nPrimeraFila

				Else
					Select Alias( This.cAlias )
					Replace R7MOV With 'M'

				Endif

			Else
				Warning( 'El registro ha sido eliminado' )

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Modifica



	*
	* Recupera el registro correspondiente a la linea
	Procedure Recupera(  ) As Void;
			HELPSTRING "Recupera el registro correspondiente a la linea"

		Local lcNumProg As String,;
			lcUdfRecuperacion As String

		Local lcCommand As String

		Try

			lcCommand = ""


			If R7MOV='E'
				lcNumProg = This.cNumProg
				lcUdfRecuperacion = This.cUdfRecuperacion

				Do RE&lcNumProg With This.nLinea+This.nPrimeraFila
				Select Alias( This.cAlias )
				Replace R7MOV With 'M'
				Do &lcUdfRecuperacion With This.nLinea+This.nPrimeraFila

			Else
				Warning( 'El registro no esta eliminado' )

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Recupera



	*
	* Borra las lineas de la matriz por debajo de la actual
	Procedure Borra(  ) As Void;
			HELPSTRING "Borra las lineas de la matriz por debajo de la actual"
		Local lcCommand As String

		Try

			lcCommand = ""

			If This.nLinea<>(This.nItemsPorPantalla+1)
				@ This.nLinea+This.nPrimeraFila,0 Clea To This.nItemsPorPantalla+This.nPrimeraFila+1,This.nMaxCol
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Borra



	*
	* Dibuja un caracter tipo flecha en la primer columna
	Procedure Flecha(  ) As Void;
			HELPSTRING "Dibuja un caracter tipo flecha en la primer columna"
		Local lcCommand As String

		Try

			lcCommand = ""

			@ This.nLinea+This.nPrimeraFila,0 Say Chr(187)

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Flecha

	*
	* Dibuja un caracter blanco en la primer columna
	Procedure Blanco(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""


			@ This.nLinea+This.nPrimeraFila,0 Say ' '

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Blanco



	*
	* Llama a la rutina que muestra la fila de la tabla
	Procedure Linea(  ) As Void;
			HELPSTRING "Llama a la rutina que muestra la fila de la tabla"

		Local lcNumProg As String

		Local lcCommand As String

		Try

			lcCommand = ""


			lcNumProg = This.cNumProg

			If R7MOV='E'
				SETCOLOR( CL_LINE22 )
				Do RE&lcNumProg With This.nLinea+This.nPrimeraFila
				SETCOLOR( CL_NORMAL )

			Else
				Do RE&lcNumProg With This.nLinea+This.nPrimeraFila

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Linea


	*
	* Devuelve la tecla elegida
	Procedure KeyPress(  ) As Void;
			HELPSTRING "Devuelve la tecla elegida"

		Local llSigue As Boolean

		Local lcCommand As String

		Try

			lcCommand = ""


			If Vartype( AUDITORIA ) == "U"
				AUDITORIA = .F.
			Endif

			Set Cursor Off
			Select Alias( This.cAlias )
			This.nKeyPress=0

			If This.nAccion<>r7_Consulta

				llSigue = Evaluate( This.cTeclasValidas ) And ( !Inlist( This.nKeyPress,;
					F3,;
					Enter,;
					Back, ;
					MAS,;
					MENOS,;
					F10,;
					F9, ;
					ABAJO,;
					ARRIBA,;
					PGUP,;
					PGDN,;
					Escape,;
					KEY_CTRL_F10,;
					KEY_CTRL_F12  ) Or ( This.nKeyPress = Dos And lastrec() = 0 ))

				Do While llSigue And !This.EjecutarFuncionDeUsuario( This.nKeyPress )

					Clear Typeahead
					Inkey()
					This.nKeyPress=Inkey( 0 )

					If AUDITORIA
						If This.nKeyPress = KEY_ALT_F12
							Select Alias( This.cAlias )
							ShowTransaction()
						Endif
					Endif


					llSigue = Evaluate( This.cTeclasValidas ) And ( !Inlist( This.nKeyPress,;
						F3,;
						Enter,;
						Back, ;
						MAS,;
						MENOS,;
						F10,;
						F9, ;
						ABAJO,;
						ARRIBA,;
						PGUP,;
						PGDN,;
						Escape,;
						KEY_CTRL_F10,;
						KEY_CTRL_F12  ) Or ( This.nKeyPress = Dos And lastrec() = 0 ))

				Enddo

			Else
				llSigue = Evaluate( This.cTeclasValidas ) And ( !Inlist( This.nKeyPress,;
					F3,;
					MAS,;
					MENOS,;
					F10,;
					F9, ;
					PGUP,;
					PGDN,;
					Escape,;
					KEY_CTRL_F10,;
					KEY_CTRL_F12  ) Or ( This.nKeyPress = Dos And lastrec() = 0 ))

				Do While llSigue And !This.EjecutarFuncionDeUsuario( This.nKeyPress )

					Clear Typeahead
					Inkey()
					This.nKeyPress=Inkey( 0 )

					If AUDITORIA
						If This.nKeyPress = KEY_ALT_F12
							Select Alias( This.cAlias )
							ShowTransaction()
						Endif
					Endif

					llSigue = Evaluate( This.cTeclasValidas ) And ( !Inlist( This.nKeyPress,;
						F3,;
						MAS,;
						MENOS,;
						F10,;
						F9, ;
						PGUP,;
						PGDN,;
						Escape,;
						KEY_CTRL_F10,;
						KEY_CTRL_F12  ) Or ( This.nKeyPress = Dos And lastrec() = 0 ))

				Enddo
			Endif

			prxSetLastKey( This.nKeyPress )

			Set Cursor On

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'

			This.nKeyPress = 0

			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			Set Cursor On
			Clear Typeahead
			Inkey()

		Endtry

		Return

	Endproc && KeyPress



	*
	* Indica si se debe ejecutar la funcion de usuario en funcion de la tecla presionada
	* Debe indicarse la lista de teclas que llaman a la funcion de usuario en
	* la propiedad This.cTeclasValidas en el metodo HookAfterSetUp()
	Procedure EjecutarFuncionDeUsuario( nKeyPress As Integer ) As Boolean ;
			HELPSTRING "Indica si se debe ejecutar la funcion de usuario en funcion de la tecla presionada"
		Local lcCommand As String
		Local llValid As Boolean

		Try

			lcCommand = ""
			llValid = .F.


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llValid

	Endproc && EjecutarFuncionDeUsuario


	*
	* Proceso especial definido por el usuario
	Procedure FuncionDeUsuario( nKeyPress As Integer ) As Void;
			HELPSTRING "Proceso especial definido por el usuario"
		Local lcCommand As String

		Try

			lcCommand = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && FuncionDeUsuario



	*
	*
	Procedure DefinirProcesosExternos(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && DefinirProcesosExternos


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Prx7item
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: o7Item
*!* ParentClass...: prx7Item Of 'V:\Clipper2fox\Rutinas\Prg\Prx7item.prg'
*!* BaseClass.....: Custom
*!* Description...: Version totalmente OOP del prx7Item
*!* Date..........: Domingo 18 de Marzo de 2012 (19:50:45)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class o7Item As Prx7item Of 'V:\Clipper2fox\Rutinas\Prg\Prx7item.prg'

	#If .F.
		Local This As o7Item Of "Rutinas\Prg\Prx7item.prg"
	#Endif

	* Referencia al objeto Ingreso que lo contiene
	oIngreso = Null

	* Referencia al objeto Ingreso que ingresará items a la tabla
	oIngresarItems = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="oingreso" type="property" display="oIngreso" />] + ;
		[<memberdata name="oingresaritems" type="property" display="oIngresarItems" />] + ;
		[<memberdata name="oingresaritems_access" type="method" display="oIngresarItems_Access" />] + ;
		[<memberdata name="pedidodedatos" type="method" display="PedidoDeDatos" />] + ;
		[<memberdata name="mostrarregistro" type="method" display="MostrarRegistro" />] + ;
		[<memberdata name="pantalla" type="method" display="Pantalla" />] + ;
		[<memberdata name="udfeliminacion" type="method" display="UdfEliminacion" />] + ;
		[<memberdata name="udfrecuperacion" type="method" display="UdfRecuperacion" />] + ;
		[<memberdata name="lmousedown" type="property" display="lMouseDown" />] + ;
		[<memberdata name="mousedown" type="method" display="MouseDown" />] + ;
		[<memberdata name="ocolprocesos" type="property" display="oColProcesos" />] + ;
		[<memberdata name="ejecutarprocesoexterno" type="method" display="EjecutarProcesoExterno" />] + ;
		[<memberdata name="hoockcomandoaejecutar" type="method" display="HoockComandoAEjecutar" />] + ;
		[<memberdata name="oenvironment" type="property" display="oEnvironment" />] + ;
		[<memberdata name="definirprocesosexternos" type="method" display="DefinirProcesosExternos" />] + ;
		[<memberdata name="restoreenvironment" type="method" display="RestoreEnvironment" />] + ;
		[<memberdata name="saveenvironment" type="method" display="SaveEnvironment" />] + ;
		[</VFPData>]



	*
	*
	Procedure DefinirProcesosExternos(  ) As Void
		Local lcCommand As String
		Local loColProcesos As Procesos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg",;
			loProceso As Proceso Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"


		Try

			lcCommand = ""


			*!*				loColProcesos = This.oColProcesos

			*!*				* El proceso al que se llama debe estar preparado
			*!*				* para recibir un objeto como primer parametro ( en JSON ),
			*!*				* en lugar de un entero, como lo hace usualmente
			*!*				* si es que se quiere personalizar el comportamiento

			*!*				loProceso = loColProcesos.New( "ResumenDeCuentas" )
			*!*				loProceso.cPrompt = "Resúmen de Cuentas"
			*!*				loProceso.cAccessKey = "R"
			*!*				loProceso.cMessage = "Muestra el Resúmen de Cuentas del Cliente"
			*!*				loProceso.cPK = "Res_Cue"

			*!*				loProceso = loColProcesos.New( "ComposicionDeSaldo" )
			*!*				loProceso.cPrompt = "Composición de Saldo"
			*!*				loProceso.cAccessKey = "C"
			*!*				loProceso.cMessage = "Muestra la Composición de Saldo del Cliente"

			*!*				en This.HoockComandoAEjecutar() se personaliza el comando a ejecutar
			*!*				loProceso.cPK = "Com_Sal"


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			loColMetodos 	= Null
			loProceso 		= Null
			loColProcesos 	= Null

		Endtry

	Endproc && DefinirProcesosExternos

	*
	* Inicializacion
	Procedure Inicio(  ) As Void;
			HELPSTRING "Inicializacion"
		Local lcCommand As String

		Try

			lcCommand = ""


			Update Alias( This.cAlias ) Set	_RecordOrder = Recno()

			DoDefault()


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Inicio


	*
	* Ingreso o agregado de datos a la matriz
	Procedure Ingreso(  ) As Void;
			HELPSTRING "Ingreso o agregado de datos a la matriz"

		Local lcCommand As String

		Try

			lcCommand = ""

			This.lIngresa	= .T.
			This.nTipo		= r7_Alta

			Do Whil This.lIngresa  And  This.nCantidadDeRegistros<This.nCantMaxima

				This.Posicionarse()         && Me posiciono en la fila donde comienzo a ingresar
				Try
					This.PedidoDeDatos( This.nLinea+This.nPrimeraFila )
					Select Alias( This.cAlias )
					*This.MostrarRegistro( This.nLinea+This.nPrimeraFila )

				Catch To loErr
					Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
					loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
					loError.cRemark = lcCommand
					loError.Process ( m.loErr )

					This.lIngresa = .F.

				Finally

				Endtry

				If This.lIngresa
					This.nCantidadDeRegistros = This.nCantidadDeRegistros + 1
					Select Alias( This.cAlias )
					If Eof()
						Go Bottom
					Endif
					Replace R7MOV With 'A',;
						_RecordOrder With This.nCantidadDeRegistros
					
					This.MostrarRegistro( This.nLinea+This.nPrimeraFila )	

				Else
					This.Pantalla( This.nLinea+This.nPrimeraFila )

					Select Alias( This.cAlias )
					If This.nCantidadDeRegistros=0
						prxSetLastKey( 0 )
						This.lIngresa=.F.
					Endif
				Endif

			Enddo

			If This.nCantidadDeRegistros>=This.nCantMaxima
				Warning( 'No es posible ingresar informacion adicional' )

			Else
				If This.nCantidadDeRegistros > 0
					Try
						This.Primera()
						This.Ultima()

					Catch To loErr
						Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
						loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
						loError.cRemark = lcCommand
						loError.Process ( m.loErr )

					Finally

					Endtry

				Endif
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Ingreso

	*
	* Elimina el registro correspondiente a la linea
	Procedure Elimina( ) As Boolean ;
			HELPSTRING "Elimina el registro correspondiente a la linea"

		Local lcCommand As String

		Try

			lcCommand = ""

			Select Alias( This.cAlias )

			If !InList( R7MOV, 'E', '#' )

				Replace R7MOV With 'E'

				SETCOLOR(CL_LINE22)
				This.MostrarRegistro( This.nLinea+This.nPrimeraFila )
				SETCOLOR( CL_NORMAL )

				Select Alias( This.cAlias )
				This.Flecha()

				If !This.UdfEliminacion( This.nLinea+This.nPrimeraFila )

					Select Alias( This.cAlias )
					Replace R7MOV With 'M'

					This.MostrarRegistro( This.nLinea+This.nPrimeraFila )
					
					Select Alias( This.cAlias )
					This.Flecha()

				Endif


			Else
				Do Case
				Case R7mOV = 'E'
					Warning( 'El registro ha sido eliminado' )
					
				Case R7mOV = '#'	
					Text To lcMsg NoShow TextMerge Pretext 03
					El registro ya ha sido procesado
					No Puede Modificarse
					EndText

					Warning( lcMsg )
					
				EndCase

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Elimina

	*
	* Modifica el registro correspondiente a la linea
	Procedure Modifica(  ) As Void;
			HELPSTRING "Modifica el registro correspondiente a la linea"

		Local lcCommand As String

		Try

			lcCommand = ""


			If !InList( R7MOV, 'E', '#' )
				This.lIngresa	= .T.
				This.nTipo		= r7_Modificacion

				This.PedidoDeDatos( This.nLinea+This.nPrimeraFila )

				prxLastkey()
				This.Flecha()

				If &ABORTA
					Select Alias( This.cAlias )
					This.MostrarRegistro( This.nLinea+This.nPrimeraFila )

				Else
					Select Alias( This.cAlias )

					If Inlist( CursorGetProp( "Buffering" ), 3, 5 )
						Try

							Setfldstate('_RecordOrder', 1)
							Setfldstate('r7Mov', 1)

						Catch To loErr

						Finally

						Endtry

						If DataHasChanges( This.cAlias )
							Replace R7MOV With 'M'
						Endif

					Else
						Replace R7MOV With 'M'

					Endif

				Endif

			Else
				Do Case
				Case R7mOV = 'E'
					Warning( 'El registro ha sido eliminado' )
					
				Case R7mOV = '#'	
					Text To lcMsg NoShow TextMerge Pretext 03
					El registro ya ha sido procesado
					No Puede Modificarse
					EndText

					Warning( lcMsg )
					
				EndCase
				

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Modifica

	*
	* Recupera el registro correspondiente a la linea
	Procedure Recupera(  ) As Void;
			HELPSTRING "Recupera el registro correspondiente a la linea"

		Local lcCommand As String

		Try

			lcCommand = ""


			Select Alias( This.cAlias )

			If R7MOV='E'

				Replace R7MOV With 'M'

				This.MostrarRegistro( This.nLinea+This.nPrimeraFila )

				Select Alias( This.cAlias )
				This.Flecha()


				If !This.UdfRecuperacion( This.nLinea+This.nPrimeraFila )
					Replace R7MOV With 'E'

					SETCOLOR(CL_LINE22)
					This.MostrarRegistro( This.nLinea+This.nPrimeraFila )
					SETCOLOR( CL_NORMAL )

					Select Alias( This.cAlias )
					This.Flecha()

				Endif

			Else
				Warning( 'El registro no esta eliminado' )

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Recupera


	*
	* Llama a la rutina que muestra la fila de la tabla
	Procedure Linea(  ) As Void;
			HELPSTRING "Llama a la rutina que muestra la fila de la tabla"

		Local lcCommand As String

		Try

			lcCommand = ""


			Select Alias( This.cAlias )
			
			Do Case
			Case R7MOV='E'
				SETCOLOR( CL_LINE22 )
				This.MostrarRegistro( This.nLinea+This.nPrimeraFila )
				SETCOLOR( CL_NORMAL )

			Case R7MOV='#'
				SETCOLOR( CL_SELECTED )
				This.MostrarRegistro( This.nLinea+This.nPrimeraFila )
				SETCOLOR( CL_NORMAL )
				S_Line24( "Registro Procesado" )

			Otherwise
				This.MostrarRegistro( This.nLinea+This.nPrimeraFila )
				
			EndCase

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Linea

	*
	* Llama a la rutina que muestra la fila de la tabla
	Procedure xxxLinea(  ) As Void;
			HELPSTRING "Llama a la rutina que muestra la fila de la tabla"

		Local lcCommand As String

		Try

			lcCommand = ""


			Select Alias( This.cAlias )

			If R7MOV='E'
				SETCOLOR( CL_LINE22 )
				This.MostrarRegistro( This.nLinea+This.nPrimeraFila )
				SETCOLOR( CL_NORMAL )

			Else
				This.MostrarRegistro( This.nLinea+This.nPrimeraFila )

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && xxxLinea


	*
	* Pedido de datos a una fila
	Procedure PedidoDeDatos( tnLinea As Integer  ) As Void;
			HELPSTRING "Pedido de datos a una fila"
		Local lcCommand As String

		Try

			lcCommand = ""

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry


	Endproc && PedidoDeDatos


	*
	* Recupera el registro y lo muestra
	Procedure MostrarRegistro( tnLinea As Integer ) As Void;
			HELPSTRING "Recupera el registro y lo muestra"
		Local lcCommand As String

		Try

			lcCommand = ""



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && MostrarRegistro

	*
	* Dibuja la pantalla (Por defecto, borra la línea donde está posicionado )
	Procedure Pantalla( tnLinea As Integer ) As Void;
			HELPSTRING "Dibuja la pantalla"
		Local lcCommand As String

		Try

			lcCommand = ""


			@ tnLinea, 0

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Pantalla



	*
	* Rutina de Eliminación definida por el usuario, que se ejecuta despues de This.Elimina
	* Si devuelve .F., no se elimina
	Procedure UdfEliminacion( tnLinea As Integer ) As Boolean ;
			HELPSTRING "Rutina de Eliminación definida por el usuario, que se ejecuta despues de This.Elimina"
		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .T.


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError
		Finally

		Endtry

		Return llOk

	Endproc && UdfEliminacion



	*
	* Rutina de Recuperación definida por el usuario, que se ejecuta despues de This.Recupera
	* Si devuelve .F., no se recupera
	Procedure UdfRecuperacion( tnLinea As Integer ) As Boolean ;
			HELPSTRING "Rutina de Recuperación definida por el usuario, que se ejecuta despues de This.Recupera"
		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .T.

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && UdfRecuperacion


	*
	* Se posiciona en un registro
	Procedure Goto( nRegistro As Integer ) As Void;
			HELPSTRING "Se posiciona en un registro"
		Local lcCommand As String

		Try

			lcCommand = ""

			If Vartype( nRegistro ) # "N"
				nRegistro = 0
			Endif

			Select Alias( This.cAlias )
			Locate For _RecordOrder = nRegistro

			If !Found()
				Go Bottom
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && GoTo



	*
	* Devuelve el registro sobre el que está posicionado
	Procedure Recno() As Integer ;
			HELPSTRING "Devuelve el registro sobre el que está posicionado"
		Local lcCommand As String
		Local lnRecno As Integer

		Try

			lcCommand = ""
			lnRecno = Evaluate( This.cAlias + "._RecordOrder" )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lnRecno

	Endproc && Recno

	*
	* oIngresarItems_Access
	Protected Procedure oIngresarItems_Access()

		* RA 2015-12-23(12:43:38)
		* Debe crearse cada vez para no guardar estado.
		*!*			This.oIngresarItems = NewObject( cClassName, cClassLibrary )
		*!*			This.oIngresarItems.lResizeScreen = .F.

		Return This.oIngresarItems

	Endproc && oIngresarItems_Access

	Procedure Destroy()
		Unbindevents( This )

		DoDefault()

		This.oIngreso = Null
		This.oIngresarItems = Null
	Endproc


	* Position of the mouse pointer within the form in the unit of measurement
	* 	specified by the ScaleMode property of the form.
	* 	nXCoord: Horizontal
	* 	nYCoord: Vertical
	Procedure EjecutarProcesoExterno( nXCoord, nYCoord ) As Void
		Local lcCommand As String,;
			lcPopUpName As String,;
			lcExecute As String,;
			lcProcId As String

		Local loColProcesos As Procesos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg",;
			loProceso As Proceso Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg",;
			loParam As Object

		Local lnBarId As Integer,;
			i As Integer,;
			lnCol As Integer,;
			lnRow As Integer

		Try

			lcCommand = ""

			If Vartype( nXCoord ) # "N"
				* Llamado por Alt+F5
				lnCol = This.nMaxCol / 2
				lnRow = This.oIngreso.pnMaxRow / 3

			Else
				* Llamado por RightClick()
				lnCol = Mcol()
				lnRow = Mrow()

			Endif

			loColProcesos = This.oColProcesos

			lnBarId 	= 0
			lcProcId 	= ""

			lcPopUpName = "Procesos"

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Define Popup <<lcPopUpName>> SHORTCUT Relative From <<lnRow>>, <<lnCol>>
			ENDTEXT

			&lcCommand
			lcCommand = ""

			For i = 1 To loColProcesos.Count

				lnBarId 	= lnBarId + 1

				loProceso = loColProcesos.Item( i )

				If loProceso.lSeparator
					TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Bar <<lnBarId>> Of <<lcPopUpName>> Prompt "\-"
					ENDTEXT

					&lcCommand
					lcCommand = ""

				Else
					TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Bar <<lnBarId>> Of <<lcPopUpName>> Prompt "<<loProceso.cPrompt>>"
					<<Iif( ! Empty( loProceso.cAccessKey ), [KEY Alt+] + loProceso.cAccessKey + ', "[' + Upper( loProceso.cAccessKey ) + ']"', "" )>>
					Message "<<loProceso.cMessage>>"
					ENDTEXT

					&lcCommand
					lcCommand = ""

					TEXT To lcCommand NoShow TextMerge Pretext 15
					On Selection Bar <<lnBarId>> Of <<lcPopUpName>> lcProcId = "<<loProceso.cPK>>"
					ENDTEXT

					&lcCommand
					lcCommand = ""

				Endif

			Endfor

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Activate Popup <<lcPopUpName>>
			ENDTEXT

			&lcCommand
			lcCommand = ""

			If !Empty( lcProcId )

				lcExecute = This.HoockComandoAEjecutar( lcProcId )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				<<lcExecute>>
				ENDTEXT

				LogSelectCommand( lcCommand )

				This.SaveEnvironment()

				AddDrillDownLevel( 1 )

				&lcCommand
				lcCommand = ""

				AddDrillDownLevel( - 1 )

				This.RestoreEnvironment()

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loParam = Null
			loProceso = Null
			loColProcesos = Null

		Endtry

	Endproc && EjecutarProcesoExterno

	*
	*
	Procedure SaveEnvironment(  ) As Void
		Local lcCommand As String
		Local loEnvironment As Object

		Try

			lcCommand = ""
			loEnvironment = Createobject( "Empty" )
			AddProperty( loEnvironment, "cAlias", Alias() )
			AddProperty( loEnvironment, "nRecno", Recno() )
			AddProperty( loEnvironment, "cTag", Tag() )
			AddProperty( loEnvironment, "cOutputWindow", Woutput() )

			This.oEnvironment = loEnvironment


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loEnvironment = Null

		Endtry

	Endproc && SaveEnvironment



	*
	*
	Procedure RestoreEnvironment(  ) As Void
		Local lcCommand As String
		Local loEnvironment As Object

		Try

			lcCommand 		= ""
			loEnvironment 	= This.oEnvironment
			lcOutputWindow 	= loEnvironment.cOutputWindow
			
			Activate Window ( lcOutputWindow )

			If !Empty( loEnvironment.cAlias )
				Select Alias( loEnvironment.cAlias )
				GotoRecno( loEnvironment.nRecNo )
				If !Empty( loEnvironment.cTag )
					Set Order To Tag ( loEnvironment.cTag )
				Endif

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && RestoreEnvironment





	*
	* Debe ser presonalizado
	* Recibe el Id del proceso y devuelve el comando a ejecutarse
	* en tiempo de ejecución
	Procedure HoockComandoAEjecutar( cProcesoId As String ) As String;
			HELPSTRING "Debe ser presonalizado"
		Local lcCommand As String,;
			lcParametros As String

		Local loParam As Object,;
			loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg"


		Try

			lcCommand = ""

			loJSON = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )

			Do Case
				Case cProcesoId = "Res_Cue"

					*!*					loParam = CreateObject( "Empty" )
					*!*					AddProperty( loParam, "nCodigoCliente", This.oRegistro.Codi4 )
					*!*					AddProperty( loParam, "dFechaInicial", FECHAHOY - 90 )
					*!*					AddProperty( loParam, "dFechaFinal", FECHAHOY )
					*!*
					*!*					lcParametros = loJSON.VfpToJson( loParam )
					*!*					RA 30/12/2018(10:00:06)
					*!*					loJSON.VfpToJson() utiliza ["] para los identificadores
					*!*					Utilizar siempre '[' y ']' como delimitadores y NO utilizarlos en ninguna
					*!*					propiedad de loParam
					*!*
					*!*					Text To lcCommand NoShow TextMerge Pretext 15
					*!*					Do Execute With ['Clientes\Deudores\prg\arResCue.prg' With '<<lcParametros>>'], .F., 0, .T.
					*!*					EndText

				Case cProcesoId = "Com_Sal"

					*!*					loParam = CreateObject( "Empty" )
					*!*					AddProperty( loParam, "nCodigoCliente", This.oRegistro.Codi4 )
					*!*
					*!*					lcParametros = loJSON.VfpToJson( loParam )
					*!*
					*!*					Text To lcCommand NoShow TextMerge Pretext 15
					*!*					Do Execute With ['Clientes\Deudores\prg\arComSal.prg' With '<<lcParametros>>'], .F., 0, .T.
					*!*					EndText

				Otherwise

			Endcase


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loParam = Null
			loJSON 	= Null

		Endtry

		Return lcCommand

	Endproc && HoockComandoAEjecutar



	*
	* nButton: 1 (left), 2 (right), or 4 (middle).
	* nShift: 1 (SHIFT), 2 (CTRL), 4 (ALT)
	* Position of the mouse pointer within the form in the unit of measurement
	* 	specified by the ScaleMode property of the form.
	* 	nXCoord: Horizontal
	* 	nYCoord: Vertical
	Procedure MouseDown( nButton, nShift, nXCoord, nYCoord ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			Do Case
				Case nButton = 2
					Do Case
						Case nShift = 0
							* Rigth Click
							This.EjecutarProcesoExterno( nXCoord, nYCoord )

						Otherwise

					Endcase

				Otherwise

			Endcase

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && MouseDown


	*
	* oColProcesos_Access
	Protected Procedure oColProcesos_Access()

		If Vartype( This.oColProcesos ) # "O"
			This.oColProcesos = Newobject( "Procesos", "Rutinas\Prg\Prx7Item.prg" )
		Endif

		Return This.oColProcesos

	Endproc && oColProcesos_Access



	* lMouseDown_Assign

	Protected Procedure lMouseDown_Assign( uNewValue )

		If uNewValue = .T.
			loForm = GetActiveForm()
			Bindevent( loForm, "MouseDown", This, "MouseDown" )

		Else
			Unbindevents( This )

		Endif

		This.lMouseDown = uNewValue

	Endproc && lMouseDown_Assign



Enddefine
*!*
*!* END DEFINE
*!* Class.........: o7Item
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: Procesos7
*!* Description...:
*!* Date..........: Sábado 10 de Noviembre de 2018 (13:27:11)
*!*
*!*

Define Class Procesos7 As Procesos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"

	#If .F.
		Local This As Procesos Of "Rutinas\Prg\Prx7item.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Procesos
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Proceso7
*!* Description...:
*!* Date..........: Sábado 10 de Noviembre de 2018 (13:29:04)
*!*
*!*

Define Class Proceso7 As Proceso Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"

	#If .F.
		Local This As Proceso7 Of "Rutinas\Prg\Prx7item.prg"
	#Endif


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Proceso7
*!*
*!* ///////////////////////////////////////////////////////