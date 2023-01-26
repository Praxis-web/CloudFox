#INCLUDE "FW\Comunes\Include\Praxis.h"

*!*	#Define r3_Ingreso		1
*!*	#Define r3_Modificacion	2

*!*	#Define r3_Total		1
*!*	#Define r3_Modifica		2
*!*	#Define r3_Elimina		3
*!*	#Define r3_Consulta		4

* RA 2012-02-06(12:07:59)
* Rutina de ingreso, actualizacion y consulta de datos

Lparameters nAccion,;
	cNumProg,;
	nCantidadDatos,;
	lPideClave,;
	lConfirma,;
	lSigueProcesando,;
	cEliminaUDF,;
	nTipoActualizacion,;
	lAdmitePgDn,;
	lPoneLeyendaEnEliminacion,;
	cValidExpresion,;
	cLeyendaAlternativa

* Descripcion de parametros

* nAccion 					: 1. Ingreso, 2. Actualizacion y consulta
* cNumProg 					: Numero de programa
* nCantidadDatos 			: Cantidad de datos a actualizar
* lPideClave 				: .T. Pide clave, .F. No pide (ingreso)
* lConfirma 				: .T. Confirma, .F. No confirma (ingreso)
* lSigueProcesando 			: .T. Procesa n veces, .F. Procesa una vez (ingreso)
* cEliminaUDF 				: Nombre de la rutina (alternativa) a ejecutar en bajas (actualizacion)
* nTipoActualizacion 		: 1. Total, 2. Modificacion, 3. Eliminacion, 4. Consulta (actualizacion)
* lAdmitePgDn 				: .T. Admite PgDn, .F. No admite (actualizacion)
* lPoneLeyendaEnEliminacion	: .T. Pone leyenda linea 22 en eliminacion, .F. No pone (actualizacion)
* cValidExpresion			: Expresion a cumplir en todos los regitros
* cLeyendaAlternativa		: Leyenda alternativa


* Descripcion de rutinas externas

* CL: Pedido de la clave
* IN: Inicializacion de variables
* PA: Pantalla (Borrado)
* PE: Pedido de datos
* AC: Actualizacion
* RE: Muestro el registro

* Descripcion de variables

* lSigueProcesando: 	Continua dando de alta
* This.nKeyPress: 	Opcion de la actualizacion y consulta
* cMensaje: 	Mensaje de opciones validas de la linea 23

* Declaracion de parametros y variables de la rutina


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
	Wait Clear

Endtry

Return

*--------------------------------------

*!* ///////////////////////////////////////////////////////
*!* Class.........: prxIngreso
*!* ParentClass...: prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\PrxBaseLibrary.prg'
*!* BaseClass.....: Custom
*!* Description...:
*!* Date..........: Lunes 6 de Febrero de 2012 (12:10:17)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

*Define Class prxIngreso As prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\PrxBaseLibrary.prg'
Define Class prxIngreso As CustomBase Of Tools\namespaces\prg\CustomBase.prg

	#If .F.
		Local This As prxIngreso Of "Rutinas\Prg\prxIngreso.prg"
	#Endif


	* 1. Ingreso, 2. Actualizacion y consulta
	*!*	#Define r3_Ingreso		1
	*!*	#Define r3_Modificacion	2

	nAccion = r3_Ingreso

	* Leyenda alternativa en linea 23
	cLeyendaAlternativa = ""

	* Leyenda que se muestra en Pedido de Datos
	cLeyendaEnPedidos = ""


	* .T. Pide clave, .F. No pide (ingreso)
	lPideClave = .F.

	* .T. Confirma, .F. No confirma (ingreso)
	lConfirma = .F.

	* .T. Procesa n veces, .F. Procesa una vez (ingreso)
	lSigueProcesando = .F.

	* .T. Solo lo pide al principio, .F. Lo pide en cada iteración (ingreso)
	lTipoDeProcesoSoloAlPrincipio = .T.

	* 1. Total, 2. Modificacion, 3. Eliminacion, 4. Consulta (actualizacion)
	*!*	#Define r3_Total		1
	*!*	#Define r3_Modifica		2
	*!*	#Define r3_Elimina		3
	*!*	#Define r3_Consulta		4
	nTipoActualizacion = r3_Total

	* .T. Admite PgDn, .F. No admite (actualizacion)
	lAdmitePgDn = .F.

	* .T. Pone leyenda linea 22 en eliminacion, .F. No pone (actualizacion)
	lPoneLeyendaEnEliminacion = .F.

	* Expresion a cumplir en todos los regitros
	cValidExpresion = "( 1 > 0 )"

	* Opcion de la actualizacion y consulta
	nKeyPress = 0

	* Mensaje de opciones validas de la linea 23
	cMensaje = ""

	* Coleccion de Metodos
	oColMetodos = Null

	* Tipo de Proceso
	WCLAV = "A"

	* Continua dando de alta
	lIngresa = .F.

	* Contiene el nombre de la tabla principal
	cTablaPrincipal = ""

	* Contiene el nombre del cursor activo
	cAlias = ""

	* Nombre del cursor Transitorio asociado al r7Item
	* Se utiliza en combinacion con el r7Item
	* y es el nombre del cursor que ingresa items a una tabla
	cTransitorio = ""

	* Contiene el Título del programa
	cTituloDelPrograma = ""

	* Indica si la coleccion se filtra para dejar solo los metodos activos
	lFiltrarColeccion = .T.

	* Cantidad máxima de lineas por pantalla
	pnMaxRow = 25

	* Cantidad máxima de columnas por pantalla
	pnMaxCol = 80

	* Ejecuta el método ResizeScreen()
	lResizeScreen = .T.


	* Calcula pnMaxRow y pnMaxCol para que coincida con el alto y ancho de _Screen
	lFitToScreen = .F.

	* Indica si está asociado a un Winform
	lWinform = .F.

	* Referencia al objeto que contiene el registro
	oRegistro = Null

	* Verifica que, si existe, la misma esté seleccionada en los procesos en que interactua con la misma
	lSelectMainTable = .F.

	* Indica si se acaba de actualizar el registro
	lRecienActualizado = .F.

	* Indica si, despues de modificar el registro actual, trae el siguiente registro
	lBuscaSiguienteRegistro = .F.

	* Referencia al objeto r7Ite asociado al Ingreso
	o7Ite = Null

	* Id del pedido que se está pidiendo
	* Si un metodo lo modifica, puede alterar la secuencia del siguiente
	* PedirDato()
	nMetodoInd  = 0

	* Lista de teclas que llaman a funcion de usuario
	cTeclasDeUsuario = ""

	* Indica si está Editando o Navegando
	lEstaEditando = .F.

	* Indica el nMetodoInd por el que comienza a pedir datos
	nMetodoInicial = 1

	* Referencia al objeto Form que contiene al Objeto
	oForm = Null

	* Exportación
	cPrn_Salidas 		= S_IMPRESORA
	cPrn_Default 		= S_IMPRESORA
	nPrn_Copias 		= 1
	cPrn_Mensaje 		= ""
	cPrn_Picture 		= ""
	cPrn_MailTo			= ""
	nPrn_DefaultButton 	= 1
	lPrn_TitleBar 		= .F.
	cPrn_Caption 		= "Confirmar Impresión"
	oExporta 			= Null

	* Colección de Procesos que se pueden ejecutar con [Alt]+[F5]
	oColProcesos = Null

	* Indica si detecta los clicks del mouse
	lMouseDown = .F.

	* Backup del entorno al ejecutar un proceso externo
	oEnvironment = Null

	* Cantidad de Registros que trajo la consulta.
	* Generalmente lo usa r7Ite para inicializar la cantidad inicial
	nTally = 0

	* Se usa para inicializar lka linea que edita el r7Ite
	nLinea = 0

	* Referencia al objeto principal
	oMain = Null

	* Coleccion de Tablas que forman parte del proceso
	oColTables = Null

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="gettable" type="method" display="GetTable" />] + ;
		[<memberdata name="ocoltables" type="property" display="oColTables" />] + ;
		[<memberdata name="omain" type="property" display="oMain" />] + ;
		[<memberdata name="nlinea" type="property" display="nLinea" />] + ;
		[<memberdata name="ntally" type="property" display="nTally" />] + ;
		[<memberdata name="pnmaxrow" type="property" display="pnMaxRow" />] + ;
		[<memberdata name="pnmaxcol" type="property" display="pnMaxCol" />] + ;
		[<memberdata name="lresizescreen" type="property" display="lResizeScreen" />] + ;
		[<memberdata name="lfittoscreen" type="property" display="lFitToScreen" />] + ;
		[<memberdata name="fittoscreen" type="method" display="FitToScreen" />] + ;
		[<memberdata name="lingresa" type="property" display="lIngresa" />] + ;
		[<memberdata name="cmensaje" type="property" display="cMensaje" />] + ;
		[<memberdata name="cvalidexpresion" type="property" display="cValidExpresion" />] + ;
		[<memberdata name="lponeleyendaeneliminacion" type="property" display="lPoneLeyendaEnEliminacion" />] + ;
		[<memberdata name="ladmitepgdn" type="property" display="lAdmitePgDn" />] + ;
		[<memberdata name="ntipoactualizacion" type="property" display="nTipoActualizacion" />] + ;
		[<memberdata name="lsigueprocesando" type="property" display="lSigueProcesando" />] + ;
		[<memberdata name="ltipodeprocesosoloalprincipio" type="property" display="lTipoDeProcesoSoloAlPrincipio" />] + ;
		[<memberdata name="lconfirma" type="property" display="lConfirma" />] + ;
		[<memberdata name="lpideclave" type="property" display="lPideClave" />] + ;
		[<memberdata name="naccion" type="property" display="nAccion" />] + ;
		[<memberdata name="oregistro" type="property" display="oRegistro" />] + ;
		[<memberdata name="cleyendaalternativa" type="property" display="cLeyendaAlternativa" />] + ;
		[<memberdata name="cleyendaenpedidos" type="property" display="cLeyendaEnPedidos" />] + ;
		[<memberdata name="setup" type="method" display="SetUp" />] + ;
		[<memberdata name="process" type="method" display="Process" />] + ;
		[<memberdata name="pedido" type="method" display="Pedido" />] + ;
		[<memberdata name="confirmar" type="method" display="Confirmar" />] + ;
		[<memberdata name="actualizacion" type="method" display="Actualizacion" />] + ;
		[<memberdata name="eliminar" type="method" display="Eliminar" />] + ;
		[<memberdata name="modificar" type="method" display="Modificar" />] + ;
		[<memberdata name="siguiente" type="method" display="Siguiente" />] + ;
		[<memberdata name="ultimo" type="method" display="Ultimo" />] + ;
		[<memberdata name="traerultimoregistro" type="method" display="TraerUltimoRegistro" />] + ;
		[<memberdata name="anterior" type="method" display="Anterior" />] + ;
		[<memberdata name="primero" type="method" display="Primero" />] + ;
		[<memberdata name="traerprimerregistro" type="method" display="TraerPrimerRegistro" />] + ;
		[<memberdata name="keypress" type="method" display="KeyPress" />] + ;
		[<memberdata name="nkeypress" type="property" display="nKeyPress" />] + ;
		[<memberdata name="clave" type="method" display="Clave" />] + ;
		[<memberdata name="inicializar" type="method" display="Inicializar" />] + ;
		[<memberdata name="pantalla" type="method" display="Pantalla" />] + ;
		[<memberdata name="mostrarregistro" type="method" display="MostrarRegistro" />] + ;
		[<memberdata name="pedirdato" type="method" display="PedirDato" />] + ;
		[<memberdata name="ocolmetodos" type="property" display="oColMetodos" />] + ;
		[<memberdata name="filtrarcoleccion" type="method" display="FiltrarColeccion" />] + ;
		[<memberdata name="actualizar" type="method" display="Actualizar" />] + ;
		[<memberdata name="validar" type="method" display="Validar" />] + ;
		[<memberdata name="armarleyendas" type="method" display="ArmarLeyendas" />] + ;
		[<memberdata name="eliminarregistro" type="method" display="EliminarRegistro" />] + ;
		[<memberdata name="setactivo" type="method" display="SetActivo" />] + ;
		[<memberdata name="setorden" type="method" display="SetOrden" />] + ;
		[<memberdata name="tipodeproceso" type="method" display="TipoDeProceso" />] + ;
		[<memberdata name="abrirarchivos" type="method" display="AbrirArchivos" />] + ;
		[<memberdata name="traerregistrosiguiente" type="method" display="TraerRegistroSiguiente" />] + ;
		[<memberdata name="traerregistroanterior" type="method" display="TraerRegistroAnterior" />] + ;
		[<memberdata name="askdato" type="method" display="AskDato" />] + ;
		[<memberdata name="getdato" type="method" display="GetDato" />] + ;
		[<memberdata name="setdato" type="method" display="SetDato" />] + ;
		[<memberdata name="showdato" type="method" display="ShowDato" />] + ;
		[<memberdata name="ctablaprincipal" type="property" display="cTablaPrincipal" />] + ;
		[<memberdata name="calias" type="property" display="cAlias" />] + ;
		[<memberdata name="ctitulodelprograma" type="property" display="cTituloDelPrograma" />] + ;
		[<memberdata name="lfiltrarcoleccion" type="property" display="lFiltrarColeccion" />] + ;
		[<memberdata name="populateproperties" type="method" display="PopulateProperties" />] + ;
		[<memberdata name="lselectmaintable" type="property" display="lSelectMainTable" />] + ;
		[<memberdata name="ctransitorio" type="property" display="cTransitorio" />] + ;
		[<memberdata name="lbuscasiguienteregistro" type="property" display="lBuscaSiguienteRegistro" />] + ;
		[<memberdata name="lrecienactualizado" type="property" display="lRecienActualizado" />] + ;
		[<memberdata name="o7ite" type="property" display="o7Ite" />] + ;
		[<memberdata name="nmetodoind" type="property" display="nMetodoInd " />] + ;
		[<memberdata name="cteclasdeusuario" type="property" display="cTeclasDeUsuario" />] + ;
		[<memberdata name="funciondeusuario" type="method" display="FuncionDeUsuario" />] + ;
		[<memberdata name="ejecutarfunciondeusuario" type="method" display="EjecutarFuncionDeUsuario" />] + ;
		[<memberdata name="lestaeditando" type="property" display="lEstaEditando" />] + ;
		[<memberdata name="nmetodoinicial" type="property" display="nMetodoInicial" />] + ;
		[<memberdata name="oform" type="property" display="oForm" />] + ;
		[<memberdata name="confirmaimpresion" type="event" display="ConfirmaImpresion" />] + ;
		[<memberdata name="imprimir" type="event" display="Imprimir" />] + ;
		[<memberdata name="cprn_salidas" type="property" display="cPrn_Salidas" />] + ;
		[<memberdata name="cprn_default" type="property" display="cPrn_Default" />] + ;
		[<memberdata name="nprn_copias" type="property" display="nPrn_Copias" />] + ;
		[<memberdata name="cprn_mensaje" type="property" display="cPrn_Mensaje" />] + ;
		[<memberdata name="cprn_picture" type="property" display="cPrn_Picture" />] + ;
		[<memberdata name="cprn_mailto" type="property" display="cPrn_MailTo" />] + ;
		[<memberdata name="nprn_defaultbutton" type="property" display="nPrn_DefaultButton" />] + ;
		[<memberdata name="lprn_titlebar" type="property" display="lPrn_TitleBar" />] + ;
		[<memberdata name="cprn_caption" type="property" display="cPrn_Caption" />] + ;
		[<memberdata name="oexporta" type="property" display="oExporta" />] + ;
		[<memberdata name="inicializarexportacion" type="method" display="InicializarExportacion" />] + ;
		[<memberdata name="lmousedown" type="property" display="lMouseDown" />] + ;
		[<memberdata name="mousedown" type="method" display="MouseDown" />] + ;
		[<memberdata name="ocolprocesos" type="property" display="oColProcesos" />] + ;
		[<memberdata name="ejecutarprocesoexterno" type="method" display="EjecutarProcesoExterno" />] + ;
		[<memberdata name="oenvironment" type="property" display="oEnvironment" />] + ;
		[<memberdata name="restoreenvironment" type="method" display="RestoreEnvironment" />] + ;
		[<memberdata name="saveenvironment" type="method" display="SaveEnvironment" />] + ;
		[<memberdata name="showtransaction" type="method" display="ShowTransaction" />] + ;
		[<memberdata name="hookbeforeactualizar" type="method" display="HookBeforeActualizar" />] + ;
		[<memberdata name="hookbeforeinicializar" type="method" display="HookBeforeInicializar" />] + ;
		[</VFPData>]


	*
	*
	Procedure ArmarLeyendas(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""


			* Armado de la leyenda de opciones validas

			If This.nAccion = r3_Modificacion
				If Empty( This.cLeyendaAlternativa )
					Do Case
						Case This.nTipoActualizacion = r3_Total
							This.cMensaje = MSG1

						Case This.nTipoActualizacion = r3_Modifica
							*!*								This.cMensaje = '[2]:Modificar  [Enter]:Clave  [Arriba]:Clave Anterior  '+;
							*!*									'[Abajo]:Clave Siguiente  [Esc]:Fin'

							This.cMensaje = '[2]:Modificar  [Enter]:Clave  [Arriba]:Anterior  '+;
								'[Abajo]:Siguiente  [Esc]:Fin'

						Case This.nTipoActualizacion = r3_Elimina
							This.cMensaje = '[1]:Elimina  [Enter]:Clave  [Arriba]:Anterior  '+;
								'[Abajo]:Siguiente  [Esc]:Fin'

						Otherwise
							This.cMensaje = '[Enter]:Clave     [Arriba]:Anterior     [Abajo]:Siguiente     [Esc]:Fin'

					Endcase

				Else
					This.cMensaje = This.cLeyendaAlternativa

				Endif

				If Empty( This.cLeyendaEnPedidos )
					If This.lAdmitePgDn
						This.cLeyendaEnPedidos = MSG5

					Else
						This.cLeyendaEnPedidos = MSG17

					Endif
				Endif

			Else
				If Empty( This.cLeyendaEnPedidos )
					This.cLeyendaEnPedidos = MSG5
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

	Endproc && ArmarLeyendas

	*
	* Es llamado antes de SetUp para permitir al desarrollador personalizar la clase
	Procedure HookBeforeSetUp(  ) As Void;
			HELPSTRING "Es llamado antes de SetUp para permitir al desarrollador personalizar la clase"
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

	Endproc && HookBeforeSetUp

	*
	*
	Procedure Setup(  ) As Void

		Local lcCommand As String
		Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg",;
			loColProcesos As Procesos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg",;
			loProceso As Proceso Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"


		Try

			lcCommand = ""

			*!*				loColMetodos = This.oColMetodos

			*!*				loColMetodos.New( "FechaInicial" )
			*!*				loColMetodos.New( "FechaFinal" )
			*!*				loColMetodos.New( "Etcetera" )


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
	Procedure Process(  ) As Void
		Local Array laTables[ 1 ]
		Local lcCommand As String,;
			lcTituloDelPrograma As String,;
			lcAlias As String

		Local loParam As Object

		Try

			lcCommand = ""
			lcAlias = Alias()

			This.HookInicializarPropiedades()

			If Empty( This.cTituloDelPrograma )
				This.cTituloDelPrograma = Prompt()
			Endif

			lcTituloDelPrograma = This.cTituloDelPrograma

			If !This.lWinform
				If Vartype( pnMaxCol ) # "N"
					pnMaxCol = This.pnMaxCol
				Endif

				If Vartype( pnMaxRow ) # "N"
					pnMaxRow = This.pnMaxRow
				Endif

				If This.lFitToScreen
					This.FitToScreen()
				Endif

				If This.lResizeScreen && Or ( This.pnMaxCol # 80 Or This.pnMaxRow # 25 )
					S_Line25( "" )
					loParam = Createobject( "Empty" )

					If Pemstatus( This, "lMultiplesPantallas", 5 )
						AddProperty( loParam, "lMultiplesPantallas", This.lMultiplesPantallas )
					Endif

					AddProperty( loParam, "oActiveForm", This.oForm )

					ResizeScreen( This.pnMaxRow, This.pnMaxCol, loParam )

				Endif
			Endif

			This.cTituloDelPrograma = lcTituloDelPrograma

			* Inicializacion
			This.HookBeforeSetUp()

			This.Setup()

			This.ArmarLeyendas()

			* Seteo de Usuario
			This.HookAfterSetUp()

			* Filtrar los metodos activos y ordenar la coleccion
			This.FiltrarColeccion()

			* Inicializar las opciones de salida
			This.InicializarExportacion()

			* Cuerpo principal del programa

			This.lIngresa = .T.

			This.Pantalla()

			* Obtencion de WCLAV
			If This.TipoDeProceso()

				This.AbrirArchivos()
				This.HookAfterAbrirArchivos()

				If Empty( This.cTablaPrincipal )
					If !Empty( Aused( laTables ))
						This.cTablaPrincipal = laTables[ 1, 1 ]
						This.lSelectMainTable = .T.
					Endif

				Else
					This.lSelectMainTable = .T.

				Endif

				If This.lSelectMainTable
					Select Alias( This.cTablaPrincipal )
				Endif

				This.lRecienActualizado = .F.

				If This.nAccion = r3_Ingreso
					If This.lPideClave = .T.
						This.Clave()

					Endif

					Do While This.lIngresa

						If This.lSelectMainTable
							Select Alias( This.cTablaPrincipal )
						Endif

						This.HookBeforeInicializar()

						This.Inicializar()

						If This.lSelectMainTable
							Select Alias( This.cTablaPrincipal )
						Endif

						This.Pedido()
						If !This.lSigueProcesando Or ( &Aborta  And  !This.lPideClave )
							Exit
						Endif

						This.Pantalla()

						If This.lTipoDeProcesoSoloAlPrincipio Or This.TipoDeProceso()
							If This.lPideClave

								If This.lSelectMainTable
									Select Alias( This.cTablaPrincipal )
								Endif

								This.Clave()
							Endif

						Else
							Exit

						Endif

					Enddo

				Else

					Debugout Program(),Lineno(), "Process"

					This.Clave()

					If This.lSelectMainTable
						Select Alias( This.cTablaPrincipal )
					Endif

					If This.lIngresa
						If !This.lWinform
							Debugout Program(),Lineno(), "Mostrar Registro"

							This.MostrarRegistroBase()

						Else
							This.ActualizarControlSource()

						Endif

						If This.lSelectMainTable
							Select Alias( This.cTablaPrincipal )
						Endif

						This.Actualizacion()

					Else
						Debugout Program(),Lineno(), "Ingresa = .F."

					Endif

				Endif

			Else
				This.nKeyPress = Escape

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			If !Empty( lcAlias )
				Select Alias( lcAlias )
			Endif

			loParam = Null

		Endtry

		Return ( This.nKeyPress # Escape )

	Endproc && Process



	*
	* A personalizar por el programador
	Procedure HookInicializarPropiedades(  ) As Void
		Local lcCommand As String
		Local loForm As frmdisplaywindow Of v:\clipper2fox\rutinas\vcx\clipper2fox.vcx

		Try

			lcCommand = ""

			If This.lMouseDown
				loForm = GetActiveForm()
				Bindevent( loForm, "MouseDown", This, "MouseDown" )

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loForm = Null

		Endtry

	Endproc && HookInicializarPropiedades


	*
	* Pedido de IngTip() y obtencion de WCLAV
	Procedure TipoDeProceso(  ) As Void;
			HELPSTRING "Pedido de IngTip() y obtencion de WCLAV"
		Local lcCommand As String

		Try

			lcCommand = ""
			*!*				If CLAVE>0
			*!*					This.WCLAV=I_INGTIP(F9,F10,1,'[Enter]: Ingreso                [Esc]: Menu')

			*!*				Else
			*!*					This.WCLAV="A"

			*!*				Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return !&Aborta

	Endproc && TipoDeProceso


	*
	* Abre los archivos necesarios para el proceso
	Procedure AbrirArchivos(  ) As Void;
			HELPSTRING "Abre los archivos necesarios para el proceso"
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

	Endproc && AbrirArchivos


	*
	*
	Procedure HookAfterAbrirArchivos(  ) As Void
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

	Endproc && HookAfterAbrirArchivos


	*
	* Pedido de datos
	Protected Procedure Pedido(  ) As Void

		Local lcErrorStr As String,;
			lcJ As String

		Local i As Integer,;
			lnCantidadDatos As Integer,;
			lnCantidaDeActivos As Integer

		Local lcMethod As String,;
			lcAlias As String
		Local loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg"

		Local lcCommand As String

		Try

			lcCommand = ""

			lcAlias = Alias()
			S_LINE23( This.cLeyendaEnPedidos )

			* Vaciar buffer
			prxSetLastKey( -1 )
			prxLastkey()

			lnCantidadDatos = This.oColMetodos.Count
			lnCantidaDeActivos = 0

			For i = 1 To This.oColMetodos.Count
				loMetodo = This.oColMetodos.GetItem( i )
				If loMetodo.lActivo
					lnCantidaDeActivos = lnCantidaDeActivos + 1
				Endif
			Endfor

			If Empty( lnCantidaDeActivos )
				i = lnCantidadDatos + 1

			Else
				i = This.nMetodoInicial

			Endif

			Do While i <= lnCantidadDatos  And  !&Aborta

				If This.lSelectMainTable
					Select Alias( This.cTablaPrincipal )
				Endif

				i = This.PedirDato( i )

				prxLastkey()
				This.nKeyPress = prxGetLastkey()

				Do Case
					Case i < 0 And !&Aborta
						* RA 22/07/2017(12:47:45)
						* Si el ultimo metodo devuelve un valor negativo
						* está indicando el valor absoluto del siguiente
						* método a ejecutarse
						i = Abs( i )

					Case Inlist( This.nKeyPress, Enter, ABAJO, DERECHA, TabKey )
						i = i + 1

					Case Inlist( This.nKeyPress, PGUP, ARRIBA, IZQUIERDA, ShiftTab )
						If i <> 1
							i = i - 1
						Endif

					Case prxLastkeyPress( PGDN )
						* If This.nAccion = r3_Modificacion
						If This.lAdmitePgDn = .T.
							i = lnCantidadDatos
						Endif
						* Endif

					Case &Aborta

					Otherwise
						If .F. && !IsRuntime()

							loMetodo = This.oColMetodos.GetItem( i )
							lcMethod = loMetodo.Name

							TEXT To lcErrorStr NoShow TextMerge Pretext 3
							Proceso <<lcMethod>>()
							No se detectó la tecla presionada ( <<Transform( This.nKeyPress )>> )
							ENDTEXT

							Error lcErrorStr

						Else
							This.nKeyPress = Enter
							i = i + 1

						Endif
				Endcase

			Enddo

			Do Case
				Case !&Aborta  And  This.lConfirma = .T.
					This.Confirmar()

				Case !&Aborta
					S_LINE23("")
					S_LINE24("")

					If This.lSelectMainTable
						Select Alias( This.cTablaPrincipal )
					Endif

					If This.Validar()

						If This.lSelectMainTable
							Select Alias( This.cTablaPrincipal )
						EndIf
						
						This.HookBeforeActualizar()
						This.lRecienActualizado = This.Actualizar()

					Else
						This.nKeyPress = Escape

					Endif

			Endcase

			If This.lSigueProcesando And ( This.nAccion = r3_Modificacion )
				This.nKeyPress = 0
				prxSetLastKey( 0 )
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

	Endproc && Pedido

	*
	* Validación global implementada por el usuario
	Procedure Validar(  ) As Boolan;
			HELPSTRING "Validación global implementada por el usuario"
		Local lcCommand As String,;
			lcMsg As String
		Local llValid As Boolean

		Try

			lcCommand 	= ""
			lcMsg 		= ""
			llValid 	= .T.

			*----------------------

			* Reglas de Validacion

			*----------------------

			If !llValid
				Do Form ErrorMessage With lcMsg
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry


		Return llValid

	Endproc && Validar



	*
	* Confirmacion de un Ingreso
	Procedure Confirmar(  ) As Void;
			HELPSTRING "Confirmacion de un Ingreso"
		Local lcCommand As String
		Local lnKeyPress As Integer

		Try

			lcCommand = ""

			Set Curs Off
			S_LINE23(MSG6)
			S_LINE24(ACL1)
			S_Line25( "" )

			lnKeyPress = I_INKEY( Enter, Escape, Dos, 0,0,0,0,0,0,0 )

			Set Curs On

			S_LINE23( "" )
			S_LINE24( "" )

			Do Case
				Case lnKeyPress=Enter
					If This.Validar()

						If This.lSelectMainTable
							Select Alias( This.cTablaPrincipal )
						Endif

						This.HookBeforeActualizar()
						This.lRecienActualizado = This.Actualizar()

					Else
						This.Pedido()

					Endif


				Case lnKeyPress=Dos
					This.Pedido()

				Case lnKeyPress=Escape
					This.nKeyPress = Escape
					prxSetLastKey( Escape )

				Otherwise
					prxSetLastKey( 0 )

			Endcase



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

	Endproc && Confirmar


	*
	*
	Procedure HookBeforeActualizar(  ) As Void
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

	Endproc && HookBeforeActualizar



	*
	* Proceso de Actualizacion Y Consulta
	Procedure Actualizacion( ) As Void
		Local llReturn As Boolean
		Local lcCommand As String
		Local lnKeyPress As Integer

		Try

			lcCommand = ""
			llReturn = .F.

			S_LINE23( This.cMensaje )
			S_LINE24( ACL1 )

			If .T. && !This.lEstaEditando
				This.KeyPress()
			Endif

			Debugout Program(),Lineno(), "Actualizacion"

			*This.lEstaEditando = lEstaEditando

			Do While This.nKeyPress <> Escape And !llReturn

				This.lRecienActualizado = .F.
				lnKeyPress 				= This.nKeyPress

				Debugout Program(),Lineno(), Transform( lnKeyPress )

				If This.lSelectMainTable
					Select Alias( This.cTablaPrincipal )
				Endif

				Do Case
					Case This.EjecutarFuncionDeUsuario( This.nKeyPress )
						This.FuncionDeUsuario( This.nKeyPress )

					Case Inlist( This.nKeyPress, Enter )
						Debugout Program(),Lineno(), "This.nKeyPress = Enter"

						This.Pantalla()
						This.Clave()

						If !This.lIngresa
							llReturn = .T.
						Endif

						If This.lSelectMainTable
							Select Alias( This.cTablaPrincipal )
						Endif

						If !This.lWinform
							This.MostrarRegistroBase()

						Else
							This.ActualizarControlSource()

						Endif

					Case Inlist( This.nKeyPress, MAS, ABAJO )
						This.lEstaEditando = .F.
						This.Siguiente()

					Case Inlist( This.nKeyPress, MENOS, ARRIBA )
						This.lEstaEditando = .F.
						This.Anterior()

					Case Inlist( This.nKeyPress, UNO )
						This.lEstaEditando = .F.
						This.Eliminar()

					Case Inlist( This.nKeyPress, Dos )
						This.lEstaEditando = .T.
						This.Modificar()

					Case Inlist( This.nKeyPress, KEY_ALT_F5 )
						This.lEstaEditando = .F.
						This.EjecutarProcesoExterno()

				Endcase

				If !Inlist( This.nKeyPress, MAS, MENOS, ABAJO, ARRIBA  ) And !llReturn

					llReturn = ( This.nKeyPress = Escape )

					S_LINE23( This.cMensaje )
					S_LINE24( ACL1 )

				Endif

				If !llReturn
					If This.lSigueProcesando ;
							And This.lBuscaSiguienteRegistro ;
							And This.lRecienActualizado

						This.nKeyPress = lnKeyPress
						This.HookBeforeVolverAProcesar()

						If This.lSelectMainTable
							Select Alias( This.cTablaPrincipal )
						Endif

						If !This.lWinform
							This.MostrarRegistroBase()

						Else
							This.ActualizarControlSource()

						Endif

					Else
						This.KeyPress()

					Endif
				Else
					If This.lSigueProcesando ;
							And This.lBuscaSiguienteRegistro ;
							And This.lRecienActualizado

						llReturn = .F.
						This.nKeyPress = Enter
						prxSetLastKey( 0 )
						Inkey()

					Endif

				Endif
			Enddo

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry


		Return

	Endproc && Actualizacion

	*
	*
	Procedure HookBeforeVolverAProcesar(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If !This.TraerRegistroSiguiente()
				Wait Window "Se ha llegado al Final del archivo ..." Nowait

				This.nKeyPress = Escape
			Endif

			Inkey()


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && HookBeforeVolverAProcesar

	*
	* Proceso de eliminacion
	Protected Procedure Eliminar(  ) As Void;
			HELPSTRING "Proceso de eliminacion"


		Local lcCommand As String

		Try

			lcCommand = ""

			If This.lSelectMainTable
				Select Alias( This.cTablaPrincipal )
			Endif

			* Si se utiliza una rutina propia de
			* eliminacion, hacer que This.EliminarRegistro() devuelva .T.
			If !This.EliminarRegistro()
				If This.lSelectMainTable
					Select Alias( This.cTablaPrincipal )
				Endif

				Set Curs Off
				S_LINE23( '[F8]:Confirma eliminacion               '+;
					'[Esc]:No confirma' )

				S_LINE24( ACL1 )

				If I_INKEY(F8,Escape,0,0,0,0,0,0,0,0) = F8

					If GrabarNovedades( "B" )
						M_INIACT(2)
						Delete
						Unlock

						If This.lPoneLeyendaEnEliminacion=.T.
							S_LINE22(ERR5,.T.)
						Endif

					Else
						TEXT To lcMsg NoShow TextMerge Pretext 03
						No es posible eliminar el registro
						porque existen movimientos asociados
						ENDTEXT

						Stop( lcMsg, This.cTituloDelPrograma )

					Endif

				Endif
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Set Curs On

		Endtry


	Endproc && Eliminar


	*
	* Rutina de usuario para eliminar el registro
	* Si se utiliza, devolver .T. para que no se ejecute This.Eliminar()
	Procedure EliminarRegistro(  ) As Void;
			HELPSTRING "Rutina de usuario para eliminar el registro"
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

		Return .F.

	Endproc && EliminarRegistro



	*
	* Proceso de modificacion
	Protected Procedure Modificar(  ) As Void;
			HELPSTRING "Proceso de modificacion"
		Local lcCommand As String

		Try

			lcCommand = ""

			If This.lSelectMainTable
				Select Alias( This.cTablaPrincipal )
			Endif

			This.HookBeforeInicializar()
			This.Inicializar()
			This.Pedido()

			If &Aborta
				If !This.lWinform
					This.MostrarRegistroBase()

				Else
					This.ActualizarControlSource()

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

	Endproc && Modificar


	*
	* Muestra registro Siguiente
	Procedure Siguiente(  ) As Void;
			HELPSTRING "Muestra registro Siguiente"

		Local lcCommand As String

		Try

			lcCommand = ""
			If !This.TraerRegistroSiguiente()
				Wait Window "Se ha llegado al Final del archivo ..." Nowait
			Endif

			If !This.lWinform
				This.MostrarRegistroBase()

			Else
				This.ActualizarControlSource()

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
	*
	Procedure Ultimo(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If !This.TraerUltimoRegistro()
				Wait Window "Se ha llegado al Final del archivo ..." Nowait
			Endif

			If !This.lWinform
				This.MostrarRegistroBase()

			Else
				This.ActualizarControlSource()

			Endif



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

	Endproc && Ultimo




	*
	*
	Procedure TraerUltimoRegistro(  ) As Void
		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""

			llOk = .T.

			Select Alias( This.cTablaPrincipal )

			Go Bottom

			If Eof()
				llOk = .F.
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return llOk

	Endproc && TraerUltimoRegistro



	*
	*
	Procedure TraerRegistroSiguiente(  ) As Void
		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .F.

			Select Alias( This.cTablaPrincipal )

			If !Eof()
				Skip
			Endif

			If Eof()
				Go Bottom
				llOk = .F.

			Else
				If !Evaluate( This.cValidExpresion )
					Skip -1
					llOk = .F.

				Else
					llOk = .T.

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


		Return llOk

	Endproc && TraerRegistroSiguiente

	*
	* Muestra registro Anterior
	Procedure Anterior(  ) As Void;
			HELPSTRING "Muestra registro Anterior"

		Local lcCommand As String

		Try

			lcCommand = ""
			If !This.TraerRegistroAnterior()
				Wait Window "Se ha llegado al Principio del archivo ..." Nowait
			Endif
			If !This.lWinform
				This.MostrarRegistroBase()

			Else
				This.ActualizarControlSource()

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
	*
	Procedure Primero(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If !This.TraerPrimerRegistro()
				Wait Window "Se ha llegado al Comienzo del archivo ..." Nowait
			Endif

			If !This.lWinform
				This.MostrarRegistroBase()

			Else
				This.ActualizarControlSource()

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

	Endproc && Primero


	*
	*
	Procedure TraerRegistroAnterior(  ) As Void
		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""

			llOk = .F.

			Select Alias( This.cTablaPrincipal )

			If !Bof()
				Skip -1
			Endif

			If Bof()
				Locate
				llOk = .F.

			Else
				If !Evaluate( This.cValidExpresion )
					Skip
					llOk = .F.

				Else
					llOk = .T.

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
		Return llOk

	Endproc && TraerRegistroAnterior



	*
	*
	Procedure TraerPrimerRegistro(  ) As Void
		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""

			llOk = .T.

			Select Alias( This.cTablaPrincipal )

			Locate

			If Bof()
				llOk = .F.
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return llOk

	Endproc && TraerPrimerRegistro


	*
	* Pedido de opciones
	Procedure KeyPress(  ) As Void;
			HELPSTRING "Pedido de opciones"

		Local lcCommand As String,;
			lcCondicion As String
		Local lnKeyPress As Integer
		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .F.
			Inkey()

			Set Curs Off

			Do While !llOk
				lnKeyPress = Inkey( 0 )

				If AUDITORIA
					If lnKeyPress = KEY_ALT_F12
						This.ShowTransaction()
					Endif
				Endif

				Do Case
					Case This.EjecutarFuncionDeUsuario( lnKeyPress )
						llOk = .T.

					Case Inlist( lnKeyPress, ;
							Enter, Escape, MAS, MENOS, UNO, Dos, ABAJO, ARRIBA )

						Do Case
							Case This.nTipoActualizacion = r3_Total
								If Deleted() And Inlist( lnKeyPress, UNO, Dos )
									llOk = .F.

								Else
									llOk = .T.

								Endif

							Case This.nTipoActualizacion = r3_Modifica
								If lnKeyPress # UNO
									llOk = .T.
								Endif

							Case This.nTipoActualizacion = r3_Elimina
								If lnKeyPress # Dos
									llOk = .T.
								Endif

							Otherwise
								If !Inlist( lnKeyPress, UNO, Dos )
									llOk = .T.
								Endif

						Endcase

					Case Inlist( lnKeyPress, KEY_ALT_F5 )
						llOk = This.oColProcesos.Count > 0

					Otherwise

				Endcase
				If llOk
					This.nKeyPress = lnKeyPress
				Endif


			Enddo

			Set Curs On
			Inkey()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry


	Endproc && KeyPress

	*
	* Editar para personalizar
	Procedure ShowTransaction(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			If This.lSelectMainTable
				Select Alias( This.cTablaPrincipal )
			Endif
			ShowTransaction()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && ShowTransaction



	*
	* Pedido de la Clave para recuperar o crear un registro
	Procedure Clave(  ) As Void;
			HELPSTRING "Pedido de la Clave para recuperar o crear un registro"
		Local lcCommand As String

		Try

			lcCommand = ""

			This.lIngresa = .T.


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

	Endproc && Clave


	*
	*
	Procedure HookBeforeInicializar(  ) As Void
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

	Endproc && HookBeforeInicializar


	*
	* Inicializar los datos del registro
	Procedure Inicializar(  ) As Void;
			HELPSTRING "Inicializar los datos del registro"

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

	Endproc && Inicializar

	*
	* Dibuja la pantalla
	Procedure Pantalla(  ) As Void;
			HELPSTRING "Dibuja la pantalla"

		Local lcCommand As String

		Try

			lcCommand = ""

			*!*				S_CLEAR( 0,0, This.pnMaxRow, This.pnMaxCol )
			*!*				S_TITPRO( This.cTituloDelPrograma, FECHAHOY )


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
	* Proceso interno
	Procedure MostrarRegistroBase(  ) As Void;
			HELPSTRING "Proceso interno"
		Local lcCommand As String

		Try

			lcCommand = ""
			This.HookBeforeMostrarRegistro()

			If Deleted()
				This.Siguiente()
			Endif

			This.MostrarRegistro()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && MostrarRegistroBase


	*
	*
	Procedure HookBeforeMostrarRegistro(  ) As Void
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

	Endproc && HookBeforeMostrarRegistro


	*
	* Recupera el registro y lo muestra
	Procedure MostrarRegistro(  ) As Void;
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



	* Actualiza el objeto Registro que es el ControlSource de los controles en el Winform
	*
	Procedure ActualizarControlSource(  ) As Void
		Local lcCommand As String
		Local loRegistro As Object


		Try

			lcCommand = ""

			If This.nAccion = r3_Ingreso
				Scatter Blank Name loRegistro

			Else
				Scatter Name loRegistro

			Endif

			This.oRegistro = loRegistro


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

	Endproc && ActualizarControlSource


	*
	* Filtra y ordena la coleccion de metodos
	Procedure FiltrarColeccion(  ) As Void;
			HELPSTRING "Filtra y ordena la coleccion de metodos"

		Local i As Integer
		Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"
		Local loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg"

		Local lcCommand As String

		Try

			lcCommand = ""

			If This.lFiltrarColeccion

				loColMetodos = Newobject( "Metodos", "Rutinas\Prg\Prxingreso.prg" )

				* Filtrar los metodo activos
				For i = 1 To This.oColMetodos.Count
					loMetodo = This.oColMetodos.GetItem( i )
					If loMetodo.lActivo
						loColMetodos.Add( loMetodo, Lower( loMetodo.Name ) )
					Endif
				Endfor

				* Ordenar por la propiedad nOrden
				loColMetodos.IndexOn()

				This.oColMetodos.Clear()
				For i = 1 To loColMetodos.Count
					loMetodo = loColMetodos.GetItem( i )
					This.oColMetodos.Add( loMetodo, Lower( loMetodo.Name ) )
				Endfor

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			loColMetodos = Null
			loMetodo = Null

		Endtry

	Endproc && FiltrarColeccion


	*
	* Llama al Método que pide un dato
	Procedure PedirDato( tnPedidoId As Integer ) As Integer ;
			HELPSTRING "Llama al Método que pide un dato"

		Local lcMethod As String,;
			lcAlias As String
		Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"
		Local loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg"

		Local lcCommand As String

		Try

			lcCommand = ""

			This.nMetodoInd = tnPedidoId

			lcAlias = Alias()
			loMetodo = This.oColMetodos.GetItem( tnPedidoId )

			If loMetodo.lActivo
				lcMethod = loMetodo.Name
				This.&lcMethod.()
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			If Used( lcAlias )
				Select Alias( lcAlias )
			Endif

		Endtry

		Return This.nMetodoInd

	Endproc && PedirDato



	*
	* Actualiza los datos en el registro
	Procedure Actualizar(  ) As Void;
			HELPSTRING "Actualiza los datos en el registro"

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

	Endproc && Actualizar

	*
	* oColMetodos_Access
	Protected Procedure oColMetodos_Access()

		If Vartype( This.oColMetodos ) # "O"
			This.oColMetodos = Newobject( "Metodos", "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg" )
		Endif

		Return This.oColMetodos
	Endproc && oColMetodos_Access


	*
	* oColProcesos_Access
	Protected Procedure oColProcesos_Access()

		If Vartype( This.oColProcesos ) # "O"
			This.oColProcesos = Newobject( "Procesos", "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg" )
		Endif

		Return This.oColProcesos

	Endproc && oColProcesos_Access


	*
	* Setea la propiedad nOrden en un Metodo
	Procedure SetOrden( tcName As String,;
			tnOrden As Integer ) As Void

		Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"
		Local loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg"
		Local loItem As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg"
		Local lnOldOrden As Integer,;
			lnNewOrden As Integer

		Local lcCommand As String

		Try

			lcCommand = ""

			loColMetodos 	= This.oColMetodos
			loMetodo 		= loColMetodos.GetItem( tcName )
			lnNewOrden 		= tnOrden
			lnOldOrden 		= loMetodo.nOrden

			* Desplazar los items que se encuentran entre el
			* numero de orden anterior y el nuevo
			For Each loItem In loColMetodos
				If Between( loItem.nOrden, Min( lnOldOrden, lnNewOrden ), Max( lnOldOrden, lnNewOrden ) )
					If loItem.nOrden > lnOldOrden
						loItem.nOrden = loItem.nOrden - 1

					Else
						loItem.nOrden = loItem.nOrden + 1

					Endif

				Endif
			Endfor

			loMetodo.nOrden = lnNewOrden


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loColMetodos 	= Null
			loMetodo 		= Null

		Endtry

	Endproc && SetOrden


	*
	* Setea la propiedad lActivo en un Metodo
	Procedure SetActivo( tuItem As Variant,;
			tlActivo As Boolean ) As Void;
			HELPSTRING "Setea la propiedad lActivo en un Metodo"

		Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"
		Local loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg"


		Local lcCommand As String

		Try

			lcCommand = ""
			loColMetodos 		= This.oColMetodos
			loMetodo 			= loColMetodos.GetItem( tuItem )

			If Vartype( loMetodo ) = "O"
				loMetodo.lActivo = tlActivo
			Endif



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			loColMetodos 	= Null
			loMetodo 		= Null

		Endtry

	Endproc && SetActivo



	*
	* Devuelve el dato del cursor activo
	Procedure GetDato( cField As String, uDefault As Variant ) As Variant ;
			HELPSTRING "Pedido de datos en el cursor activo"

		Local lcCommand As String
		Local luDato As Variant

		Try

			lcCommand = ""

			Try

				If !Used( This.cAlias )
					luDato = Evaluate( "This.oRegistro." + cField )

				Else
					luDato = Evaluate( This.cAlias + "." + cField )

				Endif

			Catch To oErr
				* RA 19/08/2018(13:55:33)
				* Si el campo no está definido, no tira error
				* Devuelve el valor por default
				luDato = uDefault

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


		Return luDato

	Endproc && GetDato



	*
	* Pide el dato al usuario
	Procedure AskDato( ;
			cField As String,;
			nRow As Integer,;
			nCol As Integer,;
			cPicture As String,;
			cValidUDF As String,;
			nLen As Integer  ) As Boolean ;
			HELPSTRING "Pide el dato al usuario"

		Local lcCommand As String
		Local lcValidExpression As String
		Local lnCancel As Integer
		Local luValue As Variant
		Local llValid As Boolean

		Try

			lcCommand 	= ""
			llValid 	= .F.

			If !Used( This.cAlias )
				luValue = Evaluate( "This.oRegistro." + cField )

			Else
				luValue = Evaluate( This.cAlias + "." + cField )

			Endif

			TEXT To lcCommand NoShow TextMerge Pretext 15
			@ <<nRow>>, <<nCol>> Get luValue
			ENDTEXT

			If !Empty( cPicture )
				lcCommand = lcCommand + " Picture '" + cPicture + "'"
			Endif

			&lcCommand
			Read

			prxLastkey()

			If !&Aborta And !Empty( cValidUDF )

				lnCancel = 0

				TEXT To lcValidExpression NoShow TextMerge Pretext 15
				This.<<cValidUDF>>( luValue )
				ENDTEXT

				Do While !&Aborta And !Evaluate( lcValidExpression )
					Clear Typeahead

					&lcCommand
					Read

					prxLastkey()

					lnCancel = lnCancel + 1
					If lnCancel > 5
						prxSetLastKey( Escape )

						Wait Window Nowait "El ingreso de datos ha sido cancelado"

					Endif
				Enddo
			Endif


			If !&Aborta

				llValid = .T.

				If Empty( nLen )
					nLen = 0
				Endif

				This.SetDato( cField, luValue )

				This.ShowDato(  ;
					cField,;
					nRow,;
					nCol,;
					cPicture,;
					nLen )

				If Vartype( This.oRegistro ) = "O"
					If Pemstatus( This.oRegistro, cField, 5 )
						If Used( This.cAlias )
							TEXT To lcCommand NoShow TextMerge Pretext 15
							This.oRegistro.<<cField>> = <<This.cAlias>>.<<cField>>
							ENDTEXT

							&lcCommand
							lcCommand = ""

						Endif
					Endif
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

		Return llValid


	Endproc && AskDato

	*
	* Actualiza el campo en el cursor activo
	Procedure SetDato( cField As String,;
			uDato As Variant,;
			lSkip As Boolean ) As Void;
			HELPSTRING "Actualiza el campo en el cursor activo"
		Local lcCommand As String
		Local llExist As Boolean

		Try

			lcCommand = ""

			If Used( This.cAlias )

				If lSkip
					* Si no existe el campo, no actualiza
					* (Por defecto, tira error si no existe el campo )
					lSkip = Empty( Field( cField, This.cAlias ))
				Endif

				If !lSkip

					TEXT To lcCommand NoShow TextMerge Pretext 15
					Replace <<cField>> With uDato In <<This.cAlias>>
					ENDTEXT

					&lcCommand

				Endif
			Endif

			If Vartype( This.oRegistro ) = "O"
				If Pemstatus( This.oRegistro, cField, 5 )
					TEXT To lcCommand NoShow TextMerge Pretext 15
					This.oRegistro.<<cField>> = uDato
					ENDTEXT

					&lcCommand
					lcCommand = ""
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

	Endproc && SetDato



	*
	* Muestra el dato
	Procedure ShowDato( ;
			cField As String,;
			nRow As Integer,;
			nCol As Integer,;
			cPicture As String,;
			nLen As Integer ) As Void;
			HELPSTRING "Muestra el dato"
		Local lcCommand As String
		Local luValue As Variant

		Try

			lcCommand = ""

			If Empty( cPicture )
				cPicture = ""
			Endif

			If Empty( nLen )
				nLen = 0
			Endif

			If !Empty( cField )

				If !Used( This.cAlias )
					luValue = Evaluate( "This.oRegistro." + cField )

				Else
					luValue = Evaluate( This.cAlias + "." + cField )

				Endif

				TEXT To lcCommand NoShow TextMerge Pretext 15
				SayMask( <<nRow>>, <<nCol>>, luValue, cPicture, <<nLen>> )
				ENDTEXT

				&lcCommand
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

	Endproc && ShowDato


	*
	* cAlias_Access
	Protected Procedure cAlias_Access()

		If Empty( This.cAlias )
			This.cAlias = "c" + This.Name + Sys( 2015 )
		Endif

		Return This.cAlias

	Endproc && cAlias_Access




	*
	* Crea e inicializa las propiedades
	Procedure PopulateProperties(  ) As Void;
			HELPSTRING "Crea e inicializa las propiedades"
		Local lcCommand As String

		Try

			lcCommand = ""

			For Each oMetodo In This.oColMetodos
				This.AddProperty( oMetodo.Name )
			Endfor


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

	Endproc && PopulateProperties



	*
	* Calcula pnMaxRow y pnMaxCol para que coincida con el alto y ancho de _Screen
	Procedure FitToScreen(  ) As Void
		Local lcCommand As String
		Local loForm As frmdisplaywindow Of "v:\clipper2fox\rutinas\vcx\clipper2fox.vcx",;
			loFont As Object

		Local i As Integer,;
			lnTop As Integer,;
			lnGap As Integer,;
			lnRows As Integer,;
			lnCols As Integer,;
			lnWidth As Integer,;
			lnHeight As Integer

		Try

			lcCommand = ""

			loForm = GetActiveForm()

			If !Isnull( loForm ) And Pemstatus( loForm, "nRows", 5 )
				loForm.nRows 	= 28
				loForm.nCols 	= 80
				lnGap 			= 02
				lnHeight 		= _Screen.Height
				lnWidth 		= _Screen.Width

				If Pemstatus( _Screen, "oApp", 5 )
					If Pemstatus( _Screen.oApp, "oColFonts", 5 )
						loFont = _Screen.oApp.oColFonts.Item( "screen" )

						loForm.FontName = loFont.FontName
						loForm.FontSize = loFont.FontSize

					Else
						loForm.FontName = oApp.FontName
						loForm.FontSize = oApp.FontSize

					Endif

				Endif

				lnCols = Int( lnWidth / loForm.TextWidth( "X" ) )
				lnRows = Int( lnHeight / loForm.TextHeight( "X" ))

				This.pnMaxCol = lnCols
				This.pnMaxRow = lnRows

				pnMaxCol = lnCols
				pnMaxRow = lnRows

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loFont = Null
			loForm = Null

		Endtry

	Endproc && FitToScreen


	*
	* Indica si se debe ejecutar la funcion de usuario en funcion de la tecla presionada
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



	Procedure Destroy()
		Unbindevents( This )

		This.oColMetodos 	= Null
		This.oColProcesos 	= Null
		This.o7Ite 			= Null
		This.oExporta 		= Null
		This.oForm 			= Null
		This.oParent 		= Null
		This.oRegistro 		= Null

		DoDefault()
	Endproc


	*
	* o7Ite_Access
	Protected Procedure o7Ite_Access()

		Return This.o7Ite

	Endproc && o7Ite_Access




	*
	*
	Procedure ConfirmaImpresion(  ) As Boolean
		Local lcCommand As String

		Local llOk As Boolean
		Local loExporta As Object

		Try

			lcCommand = ""

			loExporta = Createobject( "Empty" )
			AddProperty( loExporta, "cSalidas", 		This.cPrn_Salidas )
			AddProperty( loExporta, "cDefault", 		This.cPrn_Default )
			AddProperty( loExporta, "nCopias", 			This.nPrn_Copias )
			AddProperty( loExporta, "cMensaje", 		This.cPrn_Mensaje )
			AddProperty( loExporta, "cPicture", 		This.cPrn_Picture )
			AddProperty( loExporta, "cMailTo", 			This.cPrn_MailTo )
			AddProperty( loExporta, "nDefaultButton", 	This.nPrn_DefaultButton )
			AddProperty( loExporta, "cCaption", 		This.cPrn_Caption )
			AddProperty( loExporta, "lTitleBar", 		This.lPrn_TitleBar )

			This.oExporta = ConfirmaImpresionEx( loExporta )
			llOk = ( This.oExporta.nStatus = 0 )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loExporta = Null

		Endtry

		Return llOk

	Endproc && ConfirmaImpresion

	*
	* Editar para personalizar
	Procedure InicializarExportacion(  ) As Void
		Local lcCommand As String,;
			lcPDF As String,;
			lcSalidas As String

		Try

			lcCommand = ""
			lcPDF 		= ""

			Try
				* Verificar que PDFCreator esté Instalado
				loPDF = Createobject("PDFCreator.clsPDFCreator")
				lcPDF =  S_PDF + ","

			Catch To oErr
				lcPDF = ""

			Finally


			Endtry

			TEXT To lcSalidas NoShow TextMerge Pretext 15
			<<S_IMPRESORA>>,
			<<S_VISTA_PREVIA>>,
			<<lcPDF>>
			<<S_HOJA_DE_CALCULO>>
			ENDTEXT

			* Sacar el asterisco para personalizar
			*This.cPrn_Salidas 	= lcSalidas
			*This.cPrn_Caption 	= This.cTituloDelPrograma
			*This.lPrn_TitleBar = .T.

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && InicializarExportacion

	*
	* Editar para personalizar
	Procedure Imprimir(  ) As Void
		Local lcCommand As String
		Local loPrintObj As ImprimirComprobante Of "V:\Clipper2fox\Rutinas\Prg\ImpComp.prg"
		Local loExporta As Object,;
			loSetup As Object,;
			loFields As Collection,;
			loField As Object


		Try

			lcCommand = ""
			loExporta = This.oExporta

			loPrintObj = Newobject( "ImprimirComprobante", "Rutinas\Prg\ImpComp.prg" )
			loPrintObj.cFrxFileName = Addbs( DRVFRX ) + "Articulos Por Proveedor.frx"

			Select cConsulta
			Locate

			Do Case
				Case loExporta.cSalida = S_IMPRESORA
					* Impresora

					loPrintObj.nOutput = _FRX_PRINTER
					loPrintObj.nCopias = loExporta.nCopias
					loPrintObj.PrintReport()

				Case loExporta.cSalida = S_VISTA_PREVIA
					* Vista Previa

					loPrintObj.nOutput = _FRX_PREVIEW
					loPrintObj.PrintReport()

				Case loExporta.cSalida = S_PDF
					loPrintObj.nOutput = _FRX_PDF
					loPrintObj.cPDFFileName = "Articulos Por Proveedor"
					loPrintObj.lConfirmaNombrePDF = .T.
					loPrintObj.PrintReport()

				Case loExporta.cSalida = S_HOJA_DE_CALCULO
					* Hoja de Cálculo

					* Totalizar Campos
					loSetup = Createobject( "Empty" )
					loFields = Createobject( "Collection" )

					loField = Createobject( "Empty" )
					AddProperty( loField, "Name", "Neto_Exento" )
					loFields.Add( loField, Lower( loField.Name ) )

					loField = Createobject( "Empty" )
					AddProperty( loField, "Name", "Neto_Gravado" )
					loFields.Add( loField, Lower( loField.Name ) )

					loField = Null

					For i = 1 To loFields.Count
						loField = loFields.Item( i )
						AddProperty( loField, "lSuma", .T. )
					Endfor

					AddProperty( loSetup, "oFields", loFields )


					Output2Xls( "cConsulta",;
						"Iva Ventas",;
						"",;
						"[r7Mov],[_RecordOrder]",;
						loSetup )


			Endcase

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loExporta = Null
			loPrintObj = Null


		Endtry

	Endproc && Imprimir


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
			loParam As Object,;
			loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg",;
			loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg"

		Local lnBarId As Integer,;
			lnCol As Integer,;
			lnRow As Integer,;
			lnPantalla As Integer

		Try

			lcCommand = ""

			If !This.lEstaEditando

				If Vartype( nXCoord ) # "N"
					* Llamado por Alt+F5
					lnCol = This.pnMaxCol / 2
					lnRow = This.pnMaxRow / 3

				Else
					* Llamado por RightClick()
					lnCol = Mcol()
					lnRow = Mrow()

				Endif

				loColMetodos 	= This.oColMetodos
				loColProcesos	= This.oColProcesos


				lnBarId 	= 0
				lcProcId 	= ""

				lcPopUpName = "Procesos"

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Define Popup <<lcPopUpName>> SHORTCUT Relative From <<lnRow>>, <<lnCol>>
				ENDTEXT

				&lcCommand
				lcCommand = ""

				For Each loMetodo In loColMetodos

					If loMetodo.lActivo
						lnBarId	= lnBarId + 1

						TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Bar <<lnBarId>> Of <<lcPopUpName>> Prompt "<<loMetodo.cLeyenda>>"
					<<Iif( ! Empty( loMetodo.cAccessKey ), [KEY Alt+] + loMetodo.cAccessKey + ', "[' + Upper( loMetodo.cAccessKey ) + ']"', "" )>>
					Message "<<loMetodo.cMessage>>"
						ENDTEXT

						&lcCommand
						lcCommand = ""

						TEXT To lcCommand NoShow TextMerge Pretext 15
						On Selection Bar <<lnBarId>> Of <<lcPopUpName>> lcProcId = "<<loMetodo.cPK>>"
						ENDTEXT

						&lcCommand
						lcCommand = ""

					Endif

				Endfor

				If lnBarId > 0

					lnBarId	= lnBarId + 1

					TEXT TO lcCommand TEXTMERGE NOSHOW PRETEXT 15
					Define Bar <<lnBarId>> Of <<lcPopUpName>> Prompt "\-"
					ENDTEXT

					&lcCommand
					lcCommand = ""
				Endif

				For Each loProceso In loColProcesos

					lnBarId	= lnBarId + 1

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

					*!*					TEXT To lcMsg NoShow TextMerge Pretext 03
					*!*					lcProcId: <<lcProcId>>
					*!*					lcExecute: <<lcExecute>>
					*!*					ENDTEXT

					*!*					Inform( lcMsg )

					If !Empty( lcExecute )

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

					Else

						lnBarId 	= 0
						lnPantalla 	= 0

						For Each loMetodo In loColMetodos

							If loMetodo.lActivo
								lnBarId = lnBarId + 1

								If lcProcId = loMetodo.cPK
									lnPantalla = lnBarId
								Endif

							Endif

						Endfor

						This.NavegarEntrePantallas( 0, lnPantalla )

					Endif

				Endif
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


	* Position of the mouse pointer within the form in the unit of measurement
	* 	specified by the ScaleMode property of the form.
	* 	nXCoord: Horizontal
	* 	nYCoord: Vertical
	Procedure xxxEjecutarProcesoExterno( nXCoord, nYCoord ) As Void
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
				lnCol = This.pnMaxCol / 2
				lnRow = This.pnMaxRow / 3

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

	Endproc && xxxEjecutarProcesoExterno

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
		Local loEnvironment As Object,;
			loScreen As Form

		Try

			lcCommand = ""
			loEnvironment = This.oEnvironment

			lcOutputWindow 	= loEnvironment.cOutputWindow

			Activate Window ( lcOutputWindow )

			If !Empty( loEnvironment.cAlias )
				Select Alias( loEnvironment.cAlias )
				GotoRecno( loEnvironment.nRecno )
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
	* Devuelve un objeto Table
	Procedure GetTable( cTable As String ) As Object ;
			HELPSTRING "Devuelve un objeto Table"
		Local lcCommand As String

		Local loColDataBases As oColDataBases Of "Tools\DataDictionary\prg\oColDataBases.prg"
		Local loDataBase As oDataBase Of "Tools\DataDictionary\prg\oDataBase.prg"
		Local loColTables As ColTables Of "FW\TierAdapter\Comun\colTables.prg"
		Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"



		Try

			lcCommand = ""
			If Isnull( This.oColTables )
				This.oColTables = Newobject( "oColTables", 'Tools\DataDictionary\prg\oColTables.prg' )
			Endif

			loColTables = This.oColTables
			loArchivo = loColTables.GetTable( cTable )

			If Isnull( loArchivo )
				loColDataBases 	= NewColDataBases()
				loDataBase 		= loColDataBases.Item( 1 )
				loColTables 	= loDataBase.oColTables
				loArchivo 		= loColTables.GetTable( cTable )
				
				loColTables = This.oColTables	
				loColTables.AddItem ( loArchivo, loArchivo.cKeyName )
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loColTables 	= Null
			loDataBase 		= Null
			loColDataBases 	= Null

		Endtry

		Return loArchivo

	Endproc && GetTable


Enddefine
*!*
*!* END DEFINE
*!* Class.........: prxIngreso
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: Metodos
*!* ParentClass...: prxCollection Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
*!* BaseClass.....: Collection
*!* Description...: Colección de metodos a ser llamados por la clase
*!* Date..........: Martes 7 de Febrero de 2012 (18:55:50)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

*Define Class Metodos As prxCollection Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\Prxbaselibrary.prg'
Define Class Metodos As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg'

	#If .F.
		Local This As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"
	#Endif

	cClassName 			= "Metodo"
	cClassLibraryFolder = "Rutinas\Prg\"
	cClassLibrary 		= "prxIngreso.prg"

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="insert" type="method" display="Insert" />] + ;
		[<memberdata name="insertafter" type="method" display="InsertAfter" />] + ;
		[<memberdata name="insertbefore" type="method" display="InsertBefore" />] + ;
		[</VFPData>]

	*
	* IndexOn
	Procedure IndexOn( tlSortDesc As Boolean ) As Void ;
			HELPSTRING "Ordena la colección"

		Local lcCommand As String

		Try

			lcCommand = ""
			DoDefault( "nOrden", tlSortDesc )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

	Endproc && IndexOn

	*
	* Crea un elemento y lo agrega a la coleccion
	Procedure New( tcName As String,;
			tcBefore As String,;
			tcKey As String ) As Object;
			HELPSTRING "Crea un elemento y lo agrega a la coleccion"

		Local loItem As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg"


		Local lcCommand As String

		Try

			lcCommand = ""
			tcName = Strtran( tcName, " ", "" )

			If Vartype( tcBefore ) = "C"
				tcBefore = Strtran( tcBefore, " ", "" )
			Endif

			If Empty( tcBefore )

				loItem = This.GetItem( tcName )

				If Vartype( loItem ) # "O"
					loItem = DoDefault( tcName )
					loItem.nOrden = This.Count
				Endif

			Else
				loItem = This.InsertBefore( tcName, tcBefore, tcKey )

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return loItem

	Endproc && New



	*
	* Inserta un objeto nuevo a antes o a continuación de uno existente
	Procedure Insert( tcName As String,;
			tcTarget As String,;
			tcKey As String,;
			tlBefore As Boolean ) As Object

		Local lcCommand As String,;
			lcTarget As String
		Local loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg"
		Local lnOrden As Integer,;
			i As Integer
		Local llFound As Boolean

		Try

			lcCommand = ""
			tcName = Strtran( tcName, " ", "" )

			If Vartype( tcTarget ) = "C"
				tcTarget = Strtran( tcTarget, " ", "" )
			Endif

			lcTarget = Lower( tcTarget )

			This.IndexOn()
			lnOrden  = 0
			llFound = .F.

			For i = 1 To This.Count

				If llFound
					If tlBefore
						loMetodo = This.Item( i )
						loMetodo.nOrden = loMetodo.nOrden + 1
					Endif
				Endif

				If This.GetKey( i ) = lcTarget
					If tlBefore
						lnOrden = i
						loMetodo = This.Item( i )
						loMetodo.nOrden = loMetodo.nOrden + 1

					Else
						lnOrden = i + 1

					Endif

					llFound = .T.

				Endif

				If llFound
					If !tlBefore
						loMetodo = This.Item( i )
						loMetodo.nOrden = loMetodo.nOrden + 1
					Endif
				Endif

			Endfor

			loMetodo = This.New( tcName )
			loMetodo.nOrden = lnOrden

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_CLASS_EXCEPTION
			*!* DEBUG_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally

		Endtry

		Return loMetodo

	Endproc && InsertAfter


	*
	*
	Procedure InsertAfter( tcName As String,;
			tcTarget As String,;
			tcKey As String ) As Object

		Return This.Insert( tcName,;
			tcTarget,;
			tcKey )

	Endproc && InsertAfter



	*
	*
	Procedure InsertBefore( tcName As String,;
			tcTarget As String,;
			tcKey As String ) As Void

		Return This.Insert( tcName,;
			tcTarget,;
			tcKey,;
			.T. )

	Endproc && InsertBefore

	*
	*
	Procedure GetKey( eIndex As Variant ) As Variant
		Local lcCommand As String
		Local luReturn As Variant

		Try

			lcCommand = ""

			If Vartype( eIndex ) = "C"
				eIndex = Lower( eIndex )
			Endif

			luReturn = DoDefault( eIndex )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return luReturn

	Endproc && GetKey


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Metodos
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: Metodo
*!* ParentClass...: prxCustom Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\PrxBaseLibrary.prg'
*!* BaseClass.....: Custom
*!* Description...:
*!* Date..........: Lunes 6 de Febrero de 2012 (12:10:17)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class Metodo As CustomBase Of Tools\namespaces\prg\CustomBase.prg

	* Coleccion con los metodos a llamar
	*	Nombre del Metodo
	*	Booleano que indica si se llama o no
	*	Nro de orden para el llamado
	*

	* Indica si el métoso está activo
	lActivo = .T.

	* Indica el Número de Orden de llamada del método
	nOrden = 0


	* Nombre del cursor asociado al control
	cCursorName = ""

	* Nombre del campo asociado al control
	cFieldName = ""

	* Valor de la propiedad ControlSource del control
	cControlSource = ""

	* Leyenda que acompaña al pedido del dato
	cLeyenda = ""

	* Fila en la que se muestra el SAY de la Leyenda
	nSRow = 0

	* Fila en la que se pide el GET del Dato
	nGRow = 0

	* Columna en la que se muestra el SAY de la Leyenda
	nSCol = 0

	* Columna en la que se pide el GET de Dato
	nGCol = 0

	* Campo asociado al objeto
	cField = ""

	* Leyenda en la linea 24
	cLine24 = "S_AclStr( 30 )"

	* Picture del dato que se pide
	cPicture = ""


	* Si NO es cero, indica la longitud máxima del dato que se muestra
	nLenDato = 0

	* Hot Key
	cAccessKey = " "

	* Mensaje aclaratorio
	cMessage = ""


	* Clave Unica de Identificación del Proceso
	cPK = ""

	#If .F.
		Local This As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lactivo" type="property" display="lActivo" />] + ;
		[<memberdata name="norden" type="property" display="nOrden" />] + ;
		[<memberdata name="ccursorname" type="property" display="cCursorName" />] + ;
		[<memberdata name="ccursorname_access" type="method" display="cCursorName_Access" />] + ;
		[<memberdata name="cfieldname" type="property" display="cFieldName" />] + ;
		[<memberdata name="ccontrolsource" type="property" display="cControlSource" />] + ;
		[<memberdata name="ccontrolsource_access" type="method" display="cControlSource_Access" />] + ;
		[<memberdata name="nsrow" type="property" display="nSRow" />] + ;
		[<memberdata name="ngrow" type="property" display="nGRow" />] + ;
		[<memberdata name="nscol" type="property" display="nSCol" />] + ;
		[<memberdata name="ngcol" type="property" display="nGCol" />] + ;
		[<memberdata name="cfield" type="property" display="cField" />] + ;
		[<memberdata name="cline24" type="property" display="cLine24" />] + ;
		[<memberdata name="cpicture" type="property" display="cPicture" />] + ;
		[<memberdata name="nlendato" type="property" display="nLenDato" />] + ;
		[<memberdata name="cleyenda" type="property" display="cLeyenda" />] + ;
		[<memberdata name="caccesskey" type="property" display="cAccessKey" />] + ;
		[<memberdata name="cmessage" type="property" display="cMessage" />] + ;
		[<memberdata name="cpk" type="property" display="cPK" />] + ;
		[</VFPData>]

	*
	* cCursorName_Access
	Protected Procedure cCursorName_Access()

		Return This.cCursorName

	Endproc && cCursorName_Access


	*
	* cControlSource_Access
	Protected Procedure cControlSource_Access()
		If Empty( This.cControlSource )
			This.cControlSource = This.cCursorName + "." + This.cFieldName
		Endif

		Return This.cControlSource

	Endproc && cControlSource_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Metodo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Procesos
*!* Description...:
*!* Date..........: Sábado 10 de Noviembre de 2018 (13:27:11)
*!*
*!*

Define Class Procesos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"

	#If .F.
		Local This As Procesos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"
	#Endif

	cClassName 			= "Proceso"
	cClassLibraryFolder = "Rutinas\Prg\"
	cClassLibrary 		= "prxIngreso.prg"

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
*!* Class.........: Proceso
*!* Description...:
*!* Date..........: Sábado 10 de Noviembre de 2018 (13:29:04)
*!*
*!*

Define Class Proceso As CustomBase Of Tools\namespaces\prg\CustomBase.prg

	#If .F.
		Local This As Proceso Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"
	#Endif

	* Indica si el Proceso está activo
	lActivo = .T.

	* Indica el Número de Orden en la lista de Procesos
	nOrden = 0

	* Descripción del Proceso
	cPrompt = ""

	* Hot Key
	cAccessKey = " "

	* Mensaje aclaratorio
	cMessage = ""

	* Separador de Menú
	lSeparator = .F.

	* Si es .F.: Llama a DisplayWindowForm pasando cCommand como parámetro.
	* Si es .T.: Ejecuta directamente
	lDoPrg = .F.

	* Clave Unica de Identificación del Proceso
	cPK = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="lactivo" type="property" display="lActivo" />] + ;
		[<memberdata name="norden" type="property" display="nOrden" />] + ;
		[<memberdata name="cprompt" type="property" display="cPrompt" />] + ;
		[<memberdata name="caccesskey" type="property" display="cAccessKey" />] + ;
		[<memberdata name="cmessage" type="property" display="cMessage" />] + ;
		[<memberdata name="ccommand" type="property" display="cCommand" />] + ;
		[<memberdata name="lseparator" type="property" display="lSeparator" />] + ;
		[<memberdata name="ldoprg" type="property" display="lDoPrg" />] + ;
		[<memberdata name="oparam" type="property" display="oParam" />] + ;
		[<memberdata name="cpk" type="property" display="cPK" />] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Proceso
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oIngresoConPaginas
*!* Description...:
*!* Date..........: Viernes 20 de Octubre de 2017 (16:14:18)
*!*
*!*

Define Class oIngresoConPaginas As prxIngreso Of "Rutinas\Prg\prxIngreso.prg"

	#If .F.
		Local This As oIngresoConPaginas Of "Rutinas\Prg\prxIngreso.prg"
	#Endif

	* Incorpora teclas especiales para navegar entre pantallas
	lMultiplesPantallas = .T.

	* Teclas configurables para navegar entre pantallas
	cTeclasDeNavegacionPorPantallas = ""

	* Nombre de la pantalla activa
	cNombreDePantalla = ""

	* Titulo de la Pantalla activa
	cTituloDePantalla = ""

	* Referencia a la Objeto Principal
	oMain = Null

	* Diferencia la Página Principal de las que se muestran
	lIsMain = .T.

	* Varia el comportmiento de Confirmar()
	lCambiandoDePagina = .F.

	nPaginaActual = 1

	lConfirmacionGeneral = .F.

	lKEY_ALT_F8 = .F.

	cLeyendaLinea25 = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cleyendalinea25" type="property" display="cLeyendaLinea25" />] + ;
		[<memberdata name="lkey_alt_f8" type="property" display="lKEY_ALT_F8" />] + ;
		[<memberdata name="lmultiplespantallas" type="property" display="lMultiplesPantallas" />] + ;
		[<memberdata name="cteclasdenavegacionporpantallas" type="property" display="cTeclasDeNavegacionPorPantallas" />] + ;
		[<memberdata name="cnombredepantalla" type="property" display="cNombreDePantalla" />] + ;
		[<memberdata name="ctitulodepantalla" type="property" display="cTituloDePantalla" />] + ;
		[<memberdata name="omain" type="property" display="oMain" />] + ;
		[<memberdata name="lismain" type="property" display="lIsMain" />] + ;
		[<memberdata name="lcambiandodepagina" type="property" display="lCambiandoDePagina" />] + ;
		[<memberdata name="lconfirmaciongeneral" type="property" display="lConfirmacionGeneral" />] + ;
		[<memberdata name="npaginaactual" type="property" display="nPaginaActual" />] + ;
		[<memberdata name="getpage" type="method" display="GetPage" />] + ;
		[<memberdata name="pagelauncher" type="method" display="PageLauncher" />] + ;
		[<memberdata name="ejecutarnavegarentrepantallas" type="method" display="EjecutarNavegarEntrePantallas" />] + ;
		[<memberdata name="navegarentrepantallas" type="method" display="NavegarEntrePantallas" />] + ;
		[</VFPData>]

	* Init
	Procedure Init()
		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .F.

			TEXT To lcTeclas NoShow TextMerge Pretext 03
			<<Transform( KEY_ALT_RIGHT )>>,
			<<Transform( KEY_ALT_F1 )>>,
			<<Transform( KEY_ALT_F5 )>>,
			<<Transform( KEY_ALT_LEFT )>>
			ENDTEXT

			This.cTeclasDeNavegacionPorPantallas = lcTeclas

			llOk = DoDefault()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return llOk

	Endproc && Init


	*
	*
	Procedure HookBeforeMostrarRegistro(  ) As Void
		Local lcCommand As String,;
			lcForeColor As String,;
			lcBackColor As String,;
			lcAnterior As String,;
			lcSiguiente As String

		Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg",;
			loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg",;
			loMain As prxIngreso Of "Rutinas\Prg\prxIngreso.prg"

		Local i As Integer,;
			lnLen As Integer,;
			lnAnterior As Integer,;
			lnSiguiente As Integer

		Try

			lcCommand = ""

			loMain = This.oMain

			loColMetodos = loMain.oColMetodos
			i = loColMetodos.GetKey( This.cNombreDePantalla )

			If This.nMetodoInd > 9999
				This.nMetodoInd = i
			Endif

			lnAnterior = i - 1
			lnSiguiente = i + 1

			If lnAnterior < 1
				lnAnterior = loColMetodos.Count
			Endif

			If lnSiguiente > loColMetodos.Count
				lnSiguiente = 1
			Endif

			loMetodo = loColMetodos.GetItem( lnAnterior )
			lcAnterior = loMetodo.cLeyenda

			loMetodo = loColMetodos.GetItem( lnSiguiente )
			lcSiguiente = loMetodo.cLeyenda


			*!*				TEXT To lcMsg NoShow TextMerge Pretext 03
			*!*				[Alt][ Izq ] <<lcAnterior>>     [Alt][F1]/[Mouse Click Der]: Opciones     [Alt][ Der ] <<lcSiguiente>>
			*!*				ENDTEXT

			If This.lEstaEditando
				TEXT To lcMsg NoShow TextMerge Pretext 03
				[Alt][ Izq ] <<lcAnterior>>          [Alt][F1]: Elegir Pantalla          [Alt][ Der ] <<lcSiguiente>>
				ENDTEXT

			Else
				TEXT To lcMsg NoShow TextMerge Pretext 03
				[Alt][ Izq ] <<lcAnterior>>  [Mouse Click Der]: Opciones    [Alt][ Der ] <<lcSiguiente>>
				ENDTEXT

			Endif

			S_Line25( lcMsg )

			TEXT To lcTeclas NoShow TextMerge Pretext 03
			<<Transform( KEY_ALT_RIGHT )>>,
			<<Transform( KEY_ALT_F1 )>>,
			<<Transform( KEY_ALT_F5 )>>,
			<<Transform( KEY_ALT_LEFT )>>
			ENDTEXT

			This.cTeclasDeNavegacionPorPantallas = lcTeclas


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && HookBeforeMostrarRegistro

	*
	* Devuelve una referencia al objeto Page solicitado
	Procedure GetPage( nPageId As Integer ) As Object;
			HELPSTRING "Devuelve una referencia al objeto Page solicitado"
		Local lcCommand As String
		Local loPage As oIngresoConPaginas Of "Rutinas\Prg\prxIngreso.prg"

		Try

			lcCommand = ""

			*!*				Do Case
			*!*					Case nPageId = PG_FISCALES
			*!*						loPage = Newobject( "oDatosFiscales", "Clientes\Archivos\prg\prActCli.prg" )

			*!*					Case nPageId = PG_COMERCIALES
			*!*						loPage = Newobject( "oDatosComerciales", "Clientes\Archivos\prg\prActCli.prg" )

			*!*					Case nPageId = PG_ENTREGA
			*!*						loPage = Newobject( "oDatosDeEntrega", "Clientes\Archivos\prg\prActCli.prg" )

			*!*					Case nPageId = PG_CREDITOS
			*!*						loPage = Newobject( "oCreditos", "Clientes\Archivos\prg\prActCli.prg" )

			*!*					Otherwise
			*!*						loPage = Newobject( "oDatosFiscales", "Clientes\Archivos\prg\prActCli.prg" )

			*!*				Endcase

			*!*				loPage.pnMaxCol = This.pnMaxCol
			*!*				loPage.pnMaxRow = This.pnMaxRow
			*!*				loPage.oColProcesos = This.oColProcesos



		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loPage

	Endproc && GetPage


	*
	* lanza las pantallas
	Procedure PageLauncher( nPageId As Integer ) As Void;
			HELPSTRING "lanza las pantallas"
		Local lcCommand As String

		Local loPage As oIngresoConPaginas Of "Rutinas\Prg\prxIngreso.prg",;
			loForm As frmdisplaywindow Of "v:\clipper2fox\rutinas\vcx\clipper2fox.vcx"

		Local lnTop As Integer,;
			lnLeft As Integer

		Try

			lcCommand = ""
			This.nPaginaActual = nPageId

			lnTop 	= -1
			lnLeft 	= -1
			loForm 	= GetActiveForm()

			If !Isnull( loForm )
				lnTop 	= loForm.Top
				lnLeft 	= loForm.Left
			Endif

			loPage = This.GetPage( nPageId )

			loPage.cAlias 				= This.cAlias
			loPage.oRegistro 			= This.oRegistro
			loPage.oMain 				= This
			loPage.cTablaPrincipal 		= This.cTablaPrincipal
			loPage.cTituloDelPrograma 	= This.cTituloDelPrograma




			loParam = Createobject( "Empty" )

			AddProperty( loParam, "Height", This.pnMaxRow )
			AddProperty( loParam, "Width", 	This.pnMaxCol )
			AddProperty( loParam, "Top", 	lnTop )
			AddProperty( loParam, "Left", 	lnLeft )
			AddProperty( loParam, "Plain", 	.F. )
			AddProperty( loParam, "oMain", 	loPage )

			ExecuteSaveScreen( "Process()", loParam )

			If This.lConfirmacionGeneral
				This.cNombreDePantalla = loPage.cNombreDePantalla
				This.oRegistro = ScatterReg( .F., This.cTablaPrincipal )
				This.Pantalla()
				This.MostrarRegistroBase()
				This.nMetodoInd = 999999

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loForm = Null

		Endtry


	Endproc && PageLauncher

	*
	* Confirmacion de un Ingreso
	Procedure Confirmar( nKeyPress As Integer ) As Void;
			HELPSTRING "Confirmacion de un Ingreso"
		Local lcCommand As String
		Local loMain As oIngresoConPaginas Of "Rutinas\Prg\prxIngreso.prg"
		Local lnKeyPress As Integer

		Try

			lcCommand = ""

			If Empty( nKeyPress )
				nKeyPress = 0
			Endif

			Do Case
				Case This.lCambiandoDePagina
					This.lCambiandoDePagina = .F.

				Case This.lConfirmacionGeneral
					This.lConfirmacionGeneral = .F.

				Otherwise
					Set Curs Off
					If This.lIsMain
						S_LINE23('[Enter]/[F8]:Confirmación General   [Esc]:No confirma   [2]:Modifica')

					Else
						S_LINE23('[Enter]:Siguiente   [F8]:Confirmación General   [Esc]:No confirma   [2]:Modifica')

					Endif

					S_LINE24(ACL1)
					S_Line25( "" )

					lnKeyPress = I_INKEY( Enter, Escape, Dos, KEY_F8,0,0,0,0,0,0 )

					S_LINE23( "" )
					S_LINE24( "" )

					Do Case
						Case Inlist( lnKeyPress, Enter, KEY_F8 )

							If ( lnKeyPress = KEY_F8 )
								loMain = This.oMain

							Else
								loMain = This

							Endif

							If loMain.Validar()

								If loMain.lSelectMainTable
									Select Alias( loMain.cTablaPrincipal )
								Endif

								loMain.lRecienActualizado = loMain.Actualizar()
								loMain.lConfirmacionGeneral = .T.

							Else
								This.Pedido()

							Endif

						Case lnKeyPress=Dos
							This.Pedido()

						Otherwise
							prxSetLastKey( 0 )

					Endcase
			Endcase

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loMain = Null


		Endtry

	Endproc && Confirmar

	*
	* Proceso especial definido por el usuario
	Procedure FuncionDeUsuario( nKeyPress As Integer ) As Void;
			HELPSTRING "Proceso especial definido por el usuario"
		Local lcCommand As String

		Try

			lcCommand = ""
			Do Case
				Case .T. && This.EjecutarNavegarEntrePantallas()
					This.NavegarEntrePantallas( nKeyPress )

				Otherwise

			Endcase

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
	* Indica si se debe ejecutar la funcion de usuario en funcion de la tecla presionada
	Procedure EjecutarFuncionDeUsuario( nKeyPress As Integer ) As Boolean ;
			HELPSTRING "Indica si se debe ejecutar la funcion de usuario en funcion de la tecla presionada"
		Local lcCommand As String
		Local llValid As Boolean

		Try

			lcCommand = ""
			llValid = .F.

			Do Case
				Case This.EjecutarNavegarEntrePantallas( nKeyPress )
					llValid = .T.

				Otherwise

			Endcase


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
	*
	Procedure EjecutarNavegarEntrePantallas( nKeyPress As Integer ) As Boolean
		Local lcCommand As String,;
			lcCondicion As String
		Local llValid As Boolean

		Try

			lcCommand = ""
			llValid = .F.

			lcCondicion = "InList( " + Transform( nKeyPress ) + ", " + This.cTeclasDeNavegacionPorPantallas + " )"

			TEXT To lcCommand NoShow TextMerge Pretext 15
			llValid = Evaluate( '<<lcCondicion>>' )
			ENDTEXT

			&lcCommand
			lcCommand = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llValid

	Endproc && EjecutarNavegarEntrePantallas



	*
	*
	Procedure NavegarEntrePantallas( nKeyPress As Integer, nPagina As Integer ) As Void
		Local lcCommand As String
		Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg",;
			loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg",;
			loParam As Object,;
			loPantallas As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg',;
			loPantalla As Object,;
			loMain As oIngresoConPaginas Of "Rutinas\Prg\prxIngreso.prg"


		Local i As Integer,;
			lnPantalla As Integer,;
			lnSelected As Integer,;
			lnLen As Integer

		Try

			lcCommand = ""

			loMain 			= This.oMain
			loColMetodos 	= loMain.oColMetodos
			lnLen 			= loColMetodos.Count
			loPantallas 	= Newobject( "oColBase", "Tools\DataDictionary\prg\oColBase.prg" )
			lnPantalla 		= 0
			lnSelected 		= 1
			i 				= 0

			For Each loMetodo In loColMetodos
				i = i + 1

				If loMetodo.lActivo
					loPantalla = Createobject( "Empty" )

					AddProperty( loPantalla, "Caption", loMetodo.cLeyenda )
					AddProperty( loPantalla, "Id", i )
					AddProperty( loPantalla, "Visible", .T. )
					AddProperty( loPantalla, "Order", i )
					AddProperty( loPantalla, "Metodo", loMetodo.Name )

					loPantallas.Add( loPantalla, Transform( i ) )

					loPantalla = Null

					If Upper( loMetodo.Name ) == Upper( This.cNombreDePantalla )
						lnSelected = i
					Endif

				Endif

			Endfor

			If Empty( nPagina )

				If This.lEstaEditando

					Do Case
						Case nKeyPress = KEY_ALT_RIGHT
							lnPantalla = lnSelected + 1

							If lnPantalla > lnLen
								lnPantalla = 1
							Endif

						Case nKeyPress = KEY_ALT_F1
							loParam = Createobject( "Empty" )
							AddProperty( loParam, "oColItems", loPantallas )
							AddProperty( loParam, "nTop", -1 )
							AddProperty( loParam, "nLeft", -1 )
							AddProperty( loParam, "nSelected", lnSelected )

							AddProperty( loParam,"TitleBar", 1 )
							AddProperty( loParam,"Caption", "Selecionar Pantalla" )
							AddProperty( loParam,"Closable", .F. )

							Do Form "Rutinas\Scx\frmAChoice" With "", loParam To lnPantalla

						Case nKeyPress = KEY_ALT_LEFT
							lnPantalla = lnSelected - 1

							If lnPantalla < 1
								lnPantalla = lnLen
							Endif

					Endcase


					If !Empty( lnPantalla )

						loPantalla = loPantallas.GetItem( Transform( Int( lnPantalla )))

						* Indica al objeto principal cual pantalla se ejecuta
						* ( Le pasa el valor en Negativo )
						loMain.nMetodoInd = loColMetodos.GetKey( loPantalla.Metodo ) * -1
						loMain.nPaginaActual = Abs( loMain.nMetodoInd )
						loMain.nMetodoInicial = loMain.nPaginaActual

						* Fuerza a salir del objeto actual
						This.nMetodoInd = ( This.oColMetodos.Count + 1 ) * -1

						Keyboard '{ENTER}'

					Endif

				Else
					lnSelected = Max( This.nMetodoInd, 1 )

					Do Case
						Case nKeyPress = KEY_ALT_RIGHT
							lnPantalla = lnSelected + 1

							If lnPantalla > lnLen
								lnPantalla = 1
							Endif

						Case nKeyPress = KEY_ALT_F1

							loParam = Createobject( "Empty" )
							AddProperty( loParam, "oColItems", loPantallas )
							AddProperty( loParam, "nTop", -1 )
							AddProperty( loParam, "nLeft", -1 )
							AddProperty( loParam, "nSelected", lnSelected )

							AddProperty( loParam,"TitleBar", 1 )
							AddProperty( loParam,"Caption", "Selecionar Pantalla" )
							AddProperty( loParam,"Closable", .F. )

							Do Form "Rutinas\Scx\frmAChoice" With "", loParam To lnPantalla

						Case nKeyPress = KEY_ALT_LEFT
							lnPantalla = lnSelected - 1

							If lnPantalla < 1
								lnPantalla = lnLen
							Endif

					Endcase

					If !Empty( lnPantalla )

						loPantalla = loPantallas.GetItem( Transform( Int( lnPantalla )))

						* Indica al objeto principal cual pantalla se ejecuta
						* ( Le pasa el valor en Positivo )
						loMain.nMetodoInd = loColMetodos.GetKey( loPantalla.Metodo )
						loMain.nPaginaActual = Abs( loMain.nMetodoInd )
						loMain.nMetodoInicial = loMain.nPaginaActual

						* Cambia de Pantalla y Muestra el registro
						This.Pantalla()
						This.MostrarRegistroBase()
					Endif

				Endif


			Else
				* Es llamado desde otro metodo

				If This.lEstaEditando
					loPantalla = loPantallas.GetItem( Transform( Int( nPagina )))

					* Indica al objeto principal cual pantalla se ejecuta
					* ( Le pasa el valor en Negativo )
					loMain.nMetodoInd = loColMetodos.GetKey( loPantalla.Metodo ) * -1
					loMain.nPaginaActual = Abs( loMain.nMetodoInd )
					loMain.nMetodoInicial = loMain.nPaginaActual

					* Fuerza a salir del objeto actual
					This.nMetodoInd = ( This.oColMetodos.Count + 1 ) * -1

					Keyboard '{ENTER}'


				Else
					loPantalla = loPantallas.GetItem( Transform( Int( nPagina )))

					* Indica al objeto principal cual pantalla se ejecuta
					* ( Le pasa el valor en Positivo )
					loMain.nMetodoInd = loColMetodos.GetKey( loPantalla.Metodo )
					loMain.nPaginaActual = Abs( loMain.nMetodoInd )
					loMain.nMetodoInicial = loMain.nPaginaActual

					* Cambia de Pantalla y Muestra el registro
					This.Pantalla()
					This.MostrarRegistroBase()

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

	Endproc && NavegarEntrePantallas

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oIngresoConPaginas
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: xxx_oIngresoConPaginas
*!* Description...:
*!* Date..........: Viernes 20 de Octubre de 2017 (16:14:18)
*!*
*!*

Define Class xxx_oIngresoConPaginas As prxIngreso Of "Rutinas\Prg\prxIngreso.prg"

	#If .F.
		Local This As oIngresoConPaginas Of "Rutinas\Prg\prxIngreso.prg"
	#Endif

	* Incorpora teclas especiales para navegar entre pantallas
	lMultiplesPantallas = .T.

	* Teclas configurables para navegar entre pantallas
	cTeclasDeNavegacionPorPantallas = ""

	* Nombre de la pantalla activa
	cNombreDePantalla = ""

	* Titulo de la Pantalla activa
	cTituloDePantalla = ""

	* Referencia a la Objeto Principal
	oMain = Null

	* Diferencia la Página Principal de las que se muestran
	lIsMain = .T.

	* Varia el comportmiento de Confirmar()
	lCambiandoDePagina = .F.

	nPaginaActual = 1

	lConfirmacionGeneral = .F.

	lKEY_ALT_F8 = .F.

	cLeyendaLinea25 = ""

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cleyendalinea25" type="property" display="cLeyendaLinea25" />] + ;
		[<memberdata name="lkey_alt_f8" type="property" display="lKEY_ALT_F8" />] + ;
		[<memberdata name="lmultiplespantallas" type="property" display="lMultiplesPantallas" />] + ;
		[<memberdata name="cteclasdenavegacionporpantallas" type="property" display="cTeclasDeNavegacionPorPantallas" />] + ;
		[<memberdata name="cnombredepantalla" type="property" display="cNombreDePantalla" />] + ;
		[<memberdata name="ctitulodepantalla" type="property" display="cTituloDePantalla" />] + ;
		[<memberdata name="omain" type="property" display="oMain" />] + ;
		[<memberdata name="lismain" type="property" display="lIsMain" />] + ;
		[<memberdata name="lcambiandodepagina" type="property" display="lCambiandoDePagina" />] + ;
		[<memberdata name="lconfirmaciongeneral" type="property" display="lConfirmacionGeneral" />] + ;
		[<memberdata name="npaginaactual" type="property" display="nPaginaActual" />] + ;
		[<memberdata name="getpage" type="method" display="GetPage" />] + ;
		[<memberdata name="pagelauncher" type="method" display="PageLauncher" />] + ;
		[<memberdata name="ejecutarnavegarentrepantallas" type="method" display="EjecutarNavegarEntrePantallas" />] + ;
		[<memberdata name="navegarentrepantallas" type="method" display="NavegarEntrePantallas" />] + ;
		[</VFPData>]

	* Init
	Procedure Init()
		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""
			llOk = .F.

			TEXT To lcTeclas NoShow TextMerge Pretext 03
			<<Transform( KEY_ALT_RIGHT )>>,
			<<Transform( KEY_ALT_F1 )>>,
			<<Transform( KEY_ALT_LEFT )>>
			ENDTEXT

			This.cTeclasDeNavegacionPorPantallas = lcTeclas

			llOk = DoDefault()

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally


		Endtry

		Return llOk

	Endproc && Init


	*
	*
	Procedure HookBeforeMostrarRegistro(  ) As Void
		Local lcCommand As String,;
			lcForeColor As String,;
			lcBackColor As String,;
			lcAnterior As String,;
			lcSiguiente As String

		Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg",;
			loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg",;
			loMain As prxIngreso Of "Rutinas\Prg\prxIngreso.prg"

		Local i As Integer,;
			lnLen As Integer,;
			lnAnterior As Integer,;
			lnSiguiente As Integer

		Try

			lcCommand = ""

			loMain = This.oMain

			loColMetodos = loMain.oColMetodos
			i = loColMetodos.GetKey( This.cNombreDePantalla )
			lnAnterior = i - 1
			lnSiguiente = i + 1

			If lnAnterior < 1
				lnAnterior = loColMetodos.Count
			Endif

			If lnSiguiente > loColMetodos.Count
				lnSiguiente = 1
			Endif

			loMetodo = loColMetodos.GetItem( lnAnterior )
			lcAnterior = loMetodo.cLeyenda

			loMetodo = loColMetodos.GetItem( lnSiguiente )
			lcSiguiente = loMetodo.cLeyenda

			*!*				TEXT To lcMsg NoShow TextMerge Pretext 03
			*!*				[Alt][ Izq ] <<lcAnterior>>          [Alt][F1]: Elegir Pantalla          [Alt][ Der ] <<lcSiguiente>>
			*!*				ENDTEXT

			TEXT To lcMsg NoShow TextMerge Pretext 03
			[Alt][ Izq ] <<lcAnterior>>          [Mouse Click Der]: Opciones          [Alt][ Der ] <<lcSiguiente>>
			ENDTEXT

			S_Line25( lcMsg )
			This.cLeyendaLinea25 = lcMsg

			TEXT To lcTeclas NoShow TextMerge Pretext 03
			<<Transform( KEY_ALT_RIGHT )>>,
			<<Transform( KEY_ALT_F1 )>>,
			<<Transform( KEY_ALT_LEFT )>>
			ENDTEXT

			This.cTeclasDeNavegacionPorPantallas = lcTeclas


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && HookBeforeMostrarRegistro

	*
	*
	Procedure Actualizacion( lEstaEditando As Boolean ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			DoDefault( This.lEstaEditando )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Actualizacion



	*
	*
	Procedure Pedido(  ) As Void
		Local lcCommand As String,;
			lcMsg As String

		Try

			lcCommand = ""

			lcMsg = Stuff( This.cLeyendaLinea25, ;
				At( "[Mouse", This.cLeyendaLinea25 ), ;
				Len( "[Mouse Click Der]: Opciones" ), ;
				"[Alt][F8]: Grabar Todo" )

			S_Line25( lcMsg )

			DoDefault()

			S_Line25( This.cLeyendaLinea25 )


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Pedido


	*
	* Devuelve una referencia al objeto Page solicitado
	Procedure GetPage( nPageId As Integer ) As Object;
			HELPSTRING "Devuelve una referencia al objeto Page solicitado"
		Local lcCommand As String
		Local loPage As oIngresoConPaginas Of "Rutinas\Prg\prxIngreso.prg"

		Try

			lcCommand = ""

			*!*				Do Case
			*!*					Case nPageId = PG_FISCALES
			*!*						loPage = Newobject( "oDatosFiscales", "Clientes\Archivos\prg\prActCli.prg" )

			*!*					Case nPageId = PG_COMERCIALES
			*!*						loPage = Newobject( "oDatosComerciales", "Clientes\Archivos\prg\prActCli.prg" )

			*!*					Case nPageId = PG_ENTREGA
			*!*						loPage = Newobject( "oDatosDeEntrega", "Clientes\Archivos\prg\prActCli.prg" )

			*!*					Case nPageId = PG_CREDITOS
			*!*						loPage = Newobject( "oCreditos", "Clientes\Archivos\prg\prActCli.prg" )

			*!*					Otherwise
			*!*						loPage = Newobject( "oDatosFiscales", "Clientes\Archivos\prg\prActCli.prg" )

			*!*				Endcase

			*!*				loPage.pnMaxCol 	= This.pnMaxCol
			*!*				loPage.pnMaxRow 	= This.pnMaxRow
			*!*				loPage.oColProcesos = This.oColProcesos
			*!*				loPage.lMouseDown 	= This.lMouseDown


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loPage

	Endproc && GetPage


	*
	* lanza las pantallas
	Procedure PageLauncher( nPageId As Integer ) As Void;
			HELPSTRING "lanza las pantallas"
		Local lcCommand As String

		Local loPage As oIngresoConPaginas Of "Rutinas\Prg\prxIngreso.prg",;
			loForm As frmdisplaywindow Of "v:\clipper2fox\rutinas\vcx\clipper2fox.vcx"

		Local lnTop As Integer,;
			lnLeft As Integer

		Try

			lcCommand = ""
			This.nPaginaActual = nPageId

			lnTop 	= -1
			lnLeft 	= -1
			loForm 	= GetActiveForm()

			If !Isnull( loForm )
				lnTop 	= loForm.Top
				lnLeft 	= loForm.Left
			Endif

			loPage = This.GetPage( nPageId )

			loPage.cAlias 				= This.cAlias
			loPage.oRegistro 			= This.oRegistro
			loPage.oMain 				= This
			loPage.cTablaPrincipal 		= This.cTablaPrincipal
			loPage.cTituloDelPrograma 	= This.cTituloDelPrograma
			loPage.nAccion 				= This.nAccion
			loPage.lEstaEditando 		= This.lEstaEditando
			loPage.nKeyPress 			= This.nKeyPress

			loParam = Createobject( "Empty" )

			AddProperty( loParam, "Height", This.pnMaxRow )
			AddProperty( loParam, "Width", 	This.pnMaxCol )
			AddProperty( loParam, "Top", 	lnTop )
			AddProperty( loParam, "Left", 	lnLeft )
			AddProperty( loParam, "Plain", 	.F. )
			AddProperty( loParam, "oMain", 	loPage )

			ExecuteSaveScreen( "Process()", loParam )

			If This.lConfirmacionGeneral
				This.nMetodoInd = 999999
			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loForm = Null

		Endtry


	Endproc && PageLauncher

	*
	* Confirmacion de un Ingreso
	Procedure Confirmar( nKeyPress As Integer ) As Void;
			HELPSTRING "Confirmacion de un Ingreso"
		Local lcCommand As String
		Local loMain As oIngresoConPaginas Of "Rutinas\Prg\prxIngreso.prg"
		Local lnKeyPress As Integer

		Try

			lcCommand = ""

			If Empty( nKeyPress )
				nKeyPress = 0
			Endif

			Do Case
				Case This.lCambiandoDePagina
					This.lCambiandoDePagina = .F.

				Case This.lConfirmacionGeneral
					This.lConfirmacionGeneral = .F.

				Otherwise
					Set Curs Off
					If This.lIsMain
						S_LINE23('[Enter]/[F8]:Confirmación General   [Esc]:No confirma   [2]:Modifica')

					Else
						S_LINE23('[Enter]:Siguiente   [F8]:Confirmación General   [Esc]:No confirma   [2]:Modifica')

					Endif

					S_LINE24(ACL1)
					S_Line25( "" )

					If ( nKeyPress = KEY_ALT_F8 ) Or ( This.lKEY_ALT_F8 )
						lnKeyPress = KEY_F8
						This.nMetodoInd = 99999

					Else
						lnKeyPress = I_INKEY( Enter, Escape, Dos, KEY_F8,0,0,0,0,0,0 )

					Endif

					Set Curs On

					S_LINE23( "" )
					S_LINE24( "" )

					Do Case
						Case Inlist( lnKeyPress, Enter, KEY_F8 )

							If ( lnKeyPress = KEY_F8 )
								loMain = This.oMain

							Else
								loMain = This

							Endif

							If loMain.Validar()

								If loMain.lSelectMainTable
									Select Alias( loMain.cTablaPrincipal )
								Endif

								If This.lKEY_ALT_F8 = .F.
									loMain.lRecienActualizado = loMain.Actualizar()
									loMain.lConfirmacionGeneral = .T.
									This.Pantalla()
									This.MostrarRegistro()
									S_Line25( This.cLeyendaLinea25 )

								Endif

								If nKeyPress = KEY_ALT_F8
									Keyboard '{ENTER}'
									This.lKEY_ALT_F8 = .T.

								Else
									This.lKEY_ALT_F8 = .F.

								Endif

							Else
								This.Pedido()

							Endif

						Case lnKeyPress=Dos
							This.Pedido()

						Otherwise
							prxSetLastKey( 0 )

					Endcase
			Endcase

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loMain = Null


		Endtry

	Endproc && Confirmar

	*
	* Proceso especial definido por el usuario
	Procedure FuncionDeUsuario( nKeyPress As Integer ) As Void;
			HELPSTRING "Proceso especial definido por el usuario"
		Local lcCommand As String

		Try

			lcCommand = ""
			Do Case
				Case nKeyPress = KEY_ALT_F8
					This.Confirmar( nKeyPress )

				Case .T. && This.EjecutarNavegarEntrePantallas()
					This.NavegarEntrePantallas( nKeyPress )

				Otherwise

			Endcase

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
	* Indica si se debe ejecutar la funcion de usuario en funcion de la tecla presionada
	Procedure EjecutarFuncionDeUsuario( nKeyPress As Integer ) As Boolean ;
			HELPSTRING "Indica si se debe ejecutar la funcion de usuario en funcion de la tecla presionada"
		Local lcCommand As String
		Local llValid As Boolean

		Try

			lcCommand = ""
			llValid = .F.

			Do Case
				Case nKeyPress = KEY_ALT_F8
					* Grabar Todo
					llValid = .T.

				Case This.EjecutarNavegarEntrePantallas( nKeyPress )
					llValid = .T.

				Otherwise

			Endcase


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
	*
	Procedure EjecutarNavegarEntrePantallas( nKeyPress As Integer ) As Boolean
		Local lcCommand As String,;
			lcCondicion As String
		Local llValid As Boolean

		Try

			lcCommand = ""
			llValid = .F.

			lcCondicion = "InList( " + Transform( nKeyPress ) + ", " + This.cTeclasDeNavegacionPorPantallas + " )"

			TEXT To lcCommand NoShow TextMerge Pretext 15
			llValid = Evaluate( '<<lcCondicion>>' )
			ENDTEXT

			&lcCommand
			lcCommand = ""


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return llValid

	Endproc && EjecutarNavegarEntrePantallas


	*
	*
	Procedure NavegarEntrePantallas( nKeyPress As Integer, nPagina As Integer ) As Void
		Local lcCommand As String
		Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg",;
			loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg",;
			loParam As Object,;
			loPantallas As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg',;
			loPantalla As Object,;
			loMain As oIngresoConPaginas Of "Rutinas\Prg\prxIngreso.prg"


		Local i As Integer,;
			lnPantalla As Integer,;
			lnSelected As Integer,;
			lnLen As Integer

		Try

			lcCommand = ""

			loMain 			= This.oMain
			loColMetodos 	= loMain.oColMetodos
			lnLen 			= loColMetodos.Count
			loPantallas 	= Newobject( "oColBase", "Tools\DataDictionary\prg\oColBase.prg" )
			lnPantalla 		= 0
			lnSelected 		= 1
			i 				= 0


			For Each loMetodo In loColMetodos
				i = i + 1

				If loMetodo.lActivo
					loPantalla = Createobject( "Empty" )

					AddProperty( loPantalla, "Caption", loMetodo.cLeyenda )
					AddProperty( loPantalla, "Id", i )
					AddProperty( loPantalla, "Visible", .T. )
					AddProperty( loPantalla, "Order", i )
					AddProperty( loPantalla, "Metodo", loMetodo.Name )

					loPantallas.Add( loPantalla, Transform( i ) )

					loPantalla = Null

					If Upper( loMetodo.Name ) == Upper( This.cNombreDePantalla )
						lnSelected = i
					Endif

				Endif

			Endfor

			If Empty( nPagina )

				If This.lEstaEditando

					Do Case
						Case nKeyPress = KEY_ALT_RIGHT
							lnPantalla = lnSelected + 1

							If lnPantalla > lnLen
								lnPantalla = 1
							Endif

						Case nKeyPress = KEY_ALT_F1
							loParam = Createobject( "Empty" )
							AddProperty( loParam, "oColItems", loPantallas )
							AddProperty( loParam, "nTop", -1 )
							AddProperty( loParam, "nLeft", -1 )
							AddProperty( loParam, "nSelected", lnSelected )

							AddProperty( loParam,"TitleBar", 1 )
							AddProperty( loParam,"Caption", "Selecionar Pantalla" )
							AddProperty( loParam,"Closable", .F. )

							Do Form "Rutinas\Scx\frmAChoice" With "", loParam To lnPantalla

						Case nKeyPress = KEY_ALT_LEFT
							lnPantalla = lnSelected - 1

							If lnPantalla < 1
								lnPantalla = lnLen
							Endif

					Endcase

					If !Empty( lnPantalla )

						loPantalla = loPantallas.GetItem( Transform( Int( lnPantalla )))

						* Indica al objeto principal cual pantalla se ejecuta
						* ( Le pasa el valor en Negativo )
						loMain.nMetodoInd = loColMetodos.GetKey( loPantalla.Metodo ) * -1
						loMain.nPaginaActual = Abs( loMain.nMetodoInd )
						loMain.nMetodoInicial = loMain.nPaginaActual

						* Fuerza a salir del objeto actual
						This.nMetodoInd = ( This.oColMetodos.Count + 1 ) * -1

						Keyboard '{ENTER}'

					Endif

				Else
					lnSelected = Max( This.nMetodoInd, 1 )

					Do Case
						Case nKeyPress = KEY_ALT_RIGHT
							lnPantalla = lnSelected + 1

							If lnPantalla > lnLen
								lnPantalla = 1
							Endif

						Case nKeyPress = KEY_ALT_F1

							loParam = Createobject( "Empty" )
							AddProperty( loParam, "oColItems", loPantallas )
							AddProperty( loParam, "nTop", -1 )
							AddProperty( loParam, "nLeft", -1 )
							AddProperty( loParam, "nSelected", lnSelected )

							AddProperty( loParam,"TitleBar", 1 )
							AddProperty( loParam,"Caption", "Selecionar Pantalla" )
							AddProperty( loParam,"Closable", .F. )

							Do Form "Rutinas\Scx\frmAChoice" With "", loParam To lnPantalla

						Case nKeyPress = KEY_ALT_LEFT
							lnPantalla = lnSelected - 1

							If lnPantalla < 1
								lnPantalla = lnLen
							Endif

					Endcase

					If !Empty( lnPantalla )

						loPantalla = loPantallas.GetItem( Transform( Int( lnPantalla )))

						* Indica al objeto principal cual pantalla se ejecuta
						* ( Le pasa el valor en Positivo )
						loMain.nMetodoInd = loColMetodos.GetKey( loPantalla.Metodo )
						loMain.nPaginaActual = Abs( loMain.nMetodoInd )
						loMain.nMetodoInicial = loMain.nPaginaActual

						* Cambia de Pantalla y Muestra el registro
						This.Pantalla()
						This.MostrarRegistroBase()
					Endif

				Endif


			Else
				* Es llamado desde otro metodo

				If This.lEstaEditando
					loPantalla = loPantallas.GetItem( Transform( Int( nPagina )))

					* Indica al objeto principal cual pantalla se ejecuta
					* ( Le pasa el valor en Negativo )
					loMain.nMetodoInd = loColMetodos.GetKey( loPantalla.Metodo ) * -1
					loMain.nPaginaActual = Abs( loMain.nMetodoInd )
					loMain.nMetodoInicial = loMain.nPaginaActual

					* Fuerza a salir del objeto actual
					This.nMetodoInd = ( This.oColMetodos.Count + 1 ) * -1

					Keyboard '{ENTER}'


				Else
					loPantalla = loPantallas.GetItem( Transform( Int( nPagina )))

					* Indica al objeto principal cual pantalla se ejecuta
					* ( Le pasa el valor en Positivo )
					loMain.nMetodoInd = loColMetodos.GetKey( loPantalla.Metodo )
					loMain.nPaginaActual = Abs( loMain.nMetodoInd )
					loMain.nMetodoInicial = loMain.nPaginaActual

					* Cambia de Pantalla y Muestra el registro
					This.Pantalla()
					This.MostrarRegistroBase()

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

	Endproc && NavegarEntrePantallas


	*
	*
	Procedure xxxNavegarEntrePantallas( nKeyPress As Integer ) As Void
		Local lcCommand As String
		Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg",;
			loMetodo As Metodo Of "V:\Clipper2fox\Rutinas\Prg\prxIngreso.prg",;
			loParam As Object,;
			loPantallas As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg',;
			loPantalla As Object,;
			loMain As oIngresoConPaginas Of "Rutinas\Prg\prxIngreso.prg"


		Local i As Integer,;
			lnPantalla As Integer,;
			lnSelected As Integer,;
			lnLen As Integer

		Try

			lcCommand = ""

			loMain 			= This.oMain
			loColMetodos 	= loMain.oColMetodos
			lnLen 			= loColMetodos.Count
			loPantallas 	= Newobject( "oColBase", "Tools\DataDictionary\prg\oColBase.prg" )
			lnPantalla 		= 0
			lnSelected 		= 1
			i 				= 0

			For Each loMetodo In loColMetodos
				i = i + 1

				If loMetodo.lActivo
					loPantalla = Createobject( "Empty" )

					AddProperty( loPantalla, "Caption", loMetodo.cLeyenda )
					AddProperty( loPantalla, "Id", i )
					AddProperty( loPantalla, "Visible", .T. )
					AddProperty( loPantalla, "Order", i )
					AddProperty( loPantalla, "Metodo", loMetodo.Name )

					loPantallas.Add( loPantalla, Transform( i ) )

					loPantalla = Null

					If Upper( loMetodo.Name ) == Upper( This.cNombreDePantalla )
						lnSelected = i
					Endif

				Endif

			Endfor

			If This.lEstaEditando

				Do Case
					Case nKeyPress = KEY_ALT_RIGHT
						lnPantalla = lnSelected + 1

						If lnPantalla > lnLen
							lnPantalla = 1
						Endif

					Case nKeyPress = KEY_ALT_F1
						loParam = Createobject( "Empty" )
						AddProperty( loParam, "oColItems", loPantallas )
						AddProperty( loParam, "nTop", -1 )
						AddProperty( loParam, "nLeft", -1 )
						AddProperty( loParam, "nSelected", lnSelected )

						AddProperty( loParam,"TitleBar", 1 )
						AddProperty( loParam,"Caption", "Selecionar Pantalla" )
						AddProperty( loParam,"Closable", .F. )

						Do Form "Rutinas\Scx\frmAChoice" With "", loParam To lnPantalla

					Case nKeyPress = KEY_ALT_LEFT
						lnPantalla = lnSelected - 1

						If lnPantalla < 1
							lnPantalla = lnLen
						Endif

				Endcase

				If !Empty( lnPantalla )

					loPantalla = loPantallas.GetItem( Transform( Int( lnPantalla )))

					* Indica al objeto principal cual pantalla se ejecuta
					* ( Le pasa el valor en Negativo )
					loMain.nMetodoInd = loColMetodos.GetKey( loPantalla.Metodo ) * -1
					loMain.nPaginaActual = Abs( loMain.nMetodoInd )
					loMain.nMetodoInicial = loMain.nPaginaActual

					* Fuerza a salir del objeto actual
					This.nMetodoInd = ( This.oColMetodos.Count + 1 ) * -1

					Keyboard '{ENTER}'

				Endif

			Else
				lnSelected = Max( This.nMetodoInd, 1 )

				Do Case
					Case nKeyPress = KEY_ALT_RIGHT
						lnPantalla = lnSelected + 1

						If lnPantalla > lnLen
							lnPantalla = 1
						Endif

					Case nKeyPress = KEY_ALT_F1

						loParam = Createobject( "Empty" )
						AddProperty( loParam, "oColItems", loPantallas )
						AddProperty( loParam, "nTop", -1 )
						AddProperty( loParam, "nLeft", -1 )
						AddProperty( loParam, "nSelected", lnSelected )

						AddProperty( loParam,"TitleBar", 1 )
						AddProperty( loParam,"Caption", "Selecionar Pantalla" )
						AddProperty( loParam,"Closable", .F. )

						Do Form "Rutinas\Scx\frmAChoice" With "", loParam To lnPantalla

					Case nKeyPress = KEY_ALT_LEFT
						lnPantalla = lnSelected - 1

						If lnPantalla < 1
							lnPantalla = lnLen
						Endif

				Endcase

				If !Empty( lnPantalla )

					loPantalla = loPantallas.GetItem( Transform( Int( lnPantalla )))

					* Indica al objeto principal cual pantalla se ejecuta
					* ( Le pasa el valor en Positivo )
					loMain.nMetodoInd = loColMetodos.GetKey( loPantalla.Metodo )
					loMain.nPaginaActual = Abs( loMain.nMetodoInd )
					loMain.nMetodoInicial = loMain.nPaginaActual

					* Cambia de Pantalla y Muestra el registro
					This.Pantalla()
					This.MostrarRegistroBase()
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

	Endproc && xxxNavegarEntrePantallas

Enddefine
*!*
*!* END DEFINE
*!* Class.........: xxx_oIngresoConPaginas
*!*
*!* ///////////////////////////////////////////////////////

