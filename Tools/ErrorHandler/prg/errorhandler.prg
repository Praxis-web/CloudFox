#Include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'
#Include "Tools\ErrorHandler\Include\eh.h"
#Include "Tools\ErrorHandler\Include\errordesc.h"

* #Define DEBUG_EXCEPTION Debugout Time(0), Program(), Time( 0 ), Program(), m.loErr.Message, m.loErr.Details, m.loErr.ErrorNo, m.loErr.LineContents, m.loErr.StackLevel, This.Class + '.' + m.loErr.Procedure, This.ClassLibrary, m.loErr.Lineno

If .F.
	Do Tools\ErrorHandler\prg\ErrorForm.prg
	Do Tools\Namespaces\prg\stringnamespace.prg
	Do Tools\Namespaces\prg\logicalnamespace.prg
	Do Tools\Namespaces\prg\Cursornamespace.prg
Endif

* Errorhandler
* Manejo de Errores
Define Class ErrorHandler As Exception

	#If .F.
		Local This As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	#Endif

	#If .F.
		TEXT
			 *:Help Documentation
			 *:Description:
			 Manejo de Errores
			 *:Project:
			 Visual Praxis Beta 1.0
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Lunes 17 de Enero de 2005 ( 18:13:25 )
			 *:ModiSummary:
			 R/0001 -
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
		ENDTEXT
	#Endif

	* Magnitud del Error
	nErrorType = MB_ICONSTOP

	* Nombre de la capa que se está ejecutando
	cTierLevel = ''

	* Sección del Método que se está corriendo
	cTraceLogin = ''

	* Mensaje aclaratorio
	cRemark = ''

	* Botones que se muestran
	nDialogBoxType = MB_OK

	* Tiempo de espera. 0= Espera que se presione un boton
	* 5 Minutos. Para que funciones el AutoShutOff del sistema no puede ser infinito
	*nTimeout = 300 * 1000
	nTimeout = 0

	cTitleBarText = 'Ha ocurrido un error'

	* Número de área donde se produjo el error
	nWorkarea = 0

	* Nombre de la aplicación
	cAppName = ''

	* El estado SQL de ODBC actual.
	cSQLState = ''

	* Falló un desencadenante:
	* 	0: No falló ningún desencadenante
	* 	1: Error del desencadenante Insert
	*	2: Error del desencadenante Update
	*	3: Error del desencadenante Delete
	nTriggerState = 0

	* Contiene el nombre del archivo de Ayuda de la aplicación,
	* donde hay más información acerca del error
	cHelpFile = ''

	* Contiene el Id. de contexto de la Ayuda para el tema de
	* Ayuda si hay información disponible en la aplicación
	cHelpId = ''

	* El texto del mensaje de error ODBC.
	cODBCErrorMsg = ''

	* El número de error desde el origen de datos ODBC.
	nODBCErrorNo = 0

	* El controlador de conexión ODBC.
	nODBCConn = 0

	* Un número de excepción de OLE 2.0.
	nOLEExcNo = 0

	* String con la descripción del error ( parseado con CR )
	cErrorDescrip = ''

	* String con todas las tablas e indices abiertos ( parseado con CR )
	cTables = ''

	* String con toda la información del Stack
	cStack = ''

	* Nombre del usuario conectado.
	cUserName  = ''

	* Nombre de la terminal del usuario.
	cTerminal = ''

	* DateTime() de cuando se produjo el error.
	dTimestamp  = Datetime()

	* Información del sistema
	cSysInfo  = ''

	* Mensaje simplificado al usuario.
	cUserMessage = ''

	* Valor seleccionado por el Usuario:
	* 	IDOK OK button pressed
	*	IDCANCEL Cancel button pressed
	* 	IDABORT Abort button pressed
	*	IDRETRY Retry button pressed
	*	IDIGNORE Ignore button pressed
	*	IDYES Yes button pressed
	*	IDNO No button pressed
	nReturnValue  = -1

	* Nombre del cursor a crear.
	cCursorName = EH_CursorName

	* Carpeta donde escribe el archivo de log.
	cLogFolder = ''

	* Indica si loguea el error y/o si lo muestra:
	* 	EH_SHOWERROR 1
	* 	EH_LOGERROR 2
	* 	EH_QUIET 0
	TierBehavior = EH_SHOWERROR + EH_LOGERROR

	* Indica si muestra el error.
	lShowError = .F.

	* Indica si loguea el error.
	lLogError = .F.

	* Indica si el error ya fue mostrado.
	lAlreadyShown = .F.

	* Indica si el error ya fue logueado.
	lAlreadyLogged = .F.

	* Log4Fox.
	oLogger = Null

	Dimension aLocalError[ 1 ]

	Dimension aLocalStackinfo [ 1 ]

	lSkipIsRunTimeCheck = .F.

	lDebug = .F.

	lDailyLog = .T.

	nStackinfoLen = 0

	cVersion = '1.0.0.0'

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="alocalerror" type="property" display="aLocalError" />] ;
		+ [<memberdata name="lskipisruntimecheck" type="property" display="lSkipIsRunTimeCheck" />] ;
		+ [<memberdata name="alocalstackinfo " type="property" display="aLocalStackinfo " />] ;
		+ [<memberdata name="resettodefault" type="method" display="ResetToDefault" />] ;
		+ [<memberdata name="lalreadylogged" type="property" display="lAlreadyLogged" />] ;
		+ [<memberdata name="lalreadyshown" type="property" display="lAlreadyShown" />] ;
		+ [<memberdata name="llogerror" type="property" display="lLogError " />] ;
		+ [<memberdata name="lshowerror" type="property" display="lShowError" />] ;
		+ [<memberdata name="clogfolder" type="property" display="cLogFolder" />] ;
		+ [<memberdata name="cusermessage" type="property" display="cUserMessage" />] ;
		+ [<memberdata name="csysinfo " type="property" display="cSysInfo " />] ;
		+ [<memberdata name="dtimestamp " type="property" display="dTimestamp " />] ;
		+ [<memberdata name="cusername " type="property" display="cUserName " />] ;
		+ [<memberdata name="cerrordescrip" type="property" display="cErrorDescrip" />] ;
		+ [<memberdata name="ctables" type="property" display="cTables" />] ;
		+ [<memberdata name="cstack" type="property" display="cStack" />] ;
		+ [<memberdata name="nerrortype" type="property" display="nErrorType" />] ;
		+ [<memberdata name="ctierlevel" type="property" display="cTierLevel" />] ;
		+ [<memberdata name="ctracelogin" type="property" display="cTraceLogin" />] ;
		+ [<memberdata name="cremark" type="property" display="cRemark" />] ;
		+ [<memberdata name="ndialogboxtype" type="property" display="nDialogBoxType" />] ;
		+ [<memberdata name="ntimeout" type="property" display="nTimeout" />] ;
		+ [<memberdata name="nworkarea" type="property" display="nWorkarea" />] ;
		+ [<memberdata name="cappname" type="property" display="cAppName" />] ;
		+ [<memberdata name="csqlstate" type="property" display="cSQLState" />] ;
		+ [<memberdata name="ntriggerstate" type="property" display="nTriggerState" />] ;
		+ [<memberdata name="chelpfile" type="property" display="cHelpFile" />] ;
		+ [<memberdata name="chelpid" type="property" display="cHelpId" />] ;
		+ [<memberdata name="codbcerrormsg" type="property" display="cODBCErrorMsg" />] ;
		+ [<memberdata name="nodbcerrorno" type="property" display="nODBCErrorNo" />] ;
		+ [<memberdata name="nodbcconn" type="property" display="nODBCConn" />] ;
		+ [<memberdata name="noleexcno" type="property" display="nOLEExcNo" />] ;
		+ [<memberdata name="ctitlebartext" type="property" display="cTitleBarText" />] ;
		+ [<memberdata name="nreturnvalue " type="property" display="nReturnValue " />] ;
		+ [<memberdata name="cterminal" type="property" display="cTerminal" />] ;
		+ [<memberdata name="ccursorname" type="property" display="cCursorName" />] ;
		+ [<memberdata name="fillerror" type="method" display="FillError" />] ;
		+ [<memberdata name="showerror" type="method" display="ShowError" />] ;
		+ [<memberdata name="cloneerror" type="method" display="CloneError" />] ;
		+ [<memberdata name="logerror" type="method" display="LogError" />] ;
		+ [<memberdata name="geterrorinformation" type="method" display="GetErrorInformation" />] ;
		+ [<memberdata name="gettablesinformation" type="method" display="GetTablesInformation" />] ;
		+ [<memberdata name="getstackinformation" type="method" display="GetStackInformation" />] ;
		+ [<memberdata name="getsysteminformation" type="method" display="GetSystemInformation" />] ;
		+ [<memberdata name="errortoxml" type="method" display="ErrorToXml" />] ;
		+ [<memberdata name="xmltoerror" type="method" display="XmlToError" />] ;
		+ [<memberdata name="process" type="event" display="Process" />] ;
		+ [<memberdata name="tierbehavior" type="property" display="TierBehavior" />] ;
		+ [<memberdata name="clogfolder" type="property" display="cLogFolder" />] ;
		+ [<memberdata name="geterrorform" type="method" display="GetErrorForm" />] ;
		+ [<memberdata name="cterminal" type="property" display="cTerminal" />] ;
		+ [<memberdata name="getlogfile" type="method" display="GetLogFile" />] ;
		+ [<memberdata name="ldailylog" type="property" display="lDailyLog" />] ;
		+ [</VFPData>]

	* GetLogFile
	Function GetLogFile( cErrorLogFileName as String ) As String

		Local lcLogFile As String, ;
			lcLogFolder As String
			
			
		If Empty( cErrorLogFileName ) 
			cErrorLogFileName = "ErrorLog" 
		EndIf
		
		lcLogFolder = Addbs ( Alltrim ( This.cLogFolder ) )
		If This.lDailyLog
			*!*	TEXT To m.lcLogFile Textmerge Noshow Pretext 15
			*!*	<<m.lcLogFolder>>ErrorLog<<Dtoc( Datetime(), 1 )>>.txt
			*!*	EndText
			m.lcLogFile = m.lcLogFolder + cErrorLogFileName + Dtoc( Datetime(), 1 ) + '.txt'

		Else && This.lDailyLog
			*!*	TEXT To m.lcLogFile Textmerge Noshow Pretext 15
			*!*	<<m.lcLogFolder>>ErrorLog.txt
			*!*	ENDTEXT
			m.lcLogFile = m.lcLogFolder + cErrorLogFileName 

		Endif && This.lDailyLog

		Return m.lcLogFile

	Endfunc && GetLogFile

	* Init
	Procedure Init () As VOID
		Local i As Integer,;
			lnLevel As Integer

		Dimension This.aLocalStackinfo[1]

		Aerror ( This.aLocalError )
		Astackinfo ( This.aLocalStackinfo )

		This.nStackinfoLen = 0

		lnLevel = Program ( -1 )

		For i = lnLevel To 1 Step -1
			If !"ERRORHANDLER"$Upper(Program ( i ))
				This.nStackinfoLen = i
				Exit
			Endif

		Endfor

		This.nStackinfoLen = Max( This.nStackinfoLen - 1, 1 )

	Endproc

	* Process
	* Recibe un objeto Error y lo procesa en forma automáutica 
	Procedure Process ( tvExp As Variant, tlShowError As Boolean, tlLogError As Boolean ) As VOID HelpString 'Recibe un Error y lo procesa en forma automáutica'
		Local lcXML As String, ;
			loErr As Exception
		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Recibe un objeto Error y lo procesa en forma automáutica
				 *:Project:
				 Visual Praxis Beta 1.0
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Lunes 21 de Marzo de 2005 ( 18:43:21 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		#If .F.
			Local Variant As VariantNameSpace Of 'Tools\Namespaces\Prg\VariantNameSpace.prg'
			Local CacheManager As CacheManager Of 'Tools\Namespaces\Prg\CacheManager.prg'
			Local Control As ControlNameSpace Of 'Tools\Namespaces\Prg\ControlNameSpace.prg'
			Local Cursor As Cursornamespace Of 'Tools\Namespaces\Prg\CursorNameSpace.prg'
			Local Logical As logicalnamespace Of 'Tools\Namespaces\Prg\LogicalNameSpace.prg'
			Local Datetime As DateTimeNameSpace Of 'Tools\Namespaces\Prg\DateTimeNameSpace.prg'
			Local GUI As GUINameSpace Of 'Tools\Namespaces\Prg\GUINameSpace.prg'
			Local Number As NumberNameSpace Of 'Tools\Namespaces\Prg\NumberNameSpace.prg'
			Local Object As ObjectNameSpace Of 'Tools\Namespaces\Prg\ObjectNameSpace.prg'
			Local Sql As SQLNameSpace Of 'Tools\Namespaces\Prg\SQLNameSpace.prg'
			Local String As stringnamespace Of 'Tools\Namespaces\Prg\StringNameSpace.prg'
			Local Vector As VectorNameSpace Of 'Tools\Namespaces\Prg\VectorNameSpace.prg'
			Local XML As XMLNamespace Of 'Tools\Namespaces\Prg\XMLNamespace.prg'
			Local Environment As EnvironmentNamespace Of 'Tools\Namespaces\Prg\EnvironmentNamespace.prg'
			Local IO As IONameSpace Of 'Tools\Namespaces\Prg\IONameSpace.prg'
			Local System As SystemNameSpace Of 'Tools\Namespaces\Prg\SystemNameSpace.prg'
			Local Exception As ExceptionNameSpace Of 'Tools\Namespaces\Prg\ExceptionNameSpace.prg'
		#Endif

		With This As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'

			Try

				* RA 2014-04-25(18:57:30)
				* Si se corre fuera del entorno, verificar
				* que estan en scope los namespaces
				llDummy = m.Logical.IsEmpty( 15 )

			Catch To oErr
				Do LoadNameSpace In "Tools\NameSpaces\Prg\LoadNameSpace.prg"

			Finally

			Endtry


			Do Case
				Case Pcount() = 2
					.lShowError	= Iif ( Vartype ( m.tlShowError ) == 'L', m.tlShowError, Bitand ( .TierBehavior, EH_SHOWERROR ) == EH_SHOWERROR )
					.lLogError	= Bitand ( .TierBehavior, EH_LOGERROR ) = EH_LOGERROR

				Case Pcount() = 3
					.lShowError	= Iif ( Vartype ( m.tlShowError ) == 'L', m.tlShowError, Bitand ( .TierBehavior, EH_SHOWERROR ) == EH_SHOWERROR )
					.lLogError	= Iif ( Vartype ( m.tlLogError ) == 'L', m.tlLogError, Bitand ( .TierBehavior, EH_LOGERROR ) == EH_LOGERROR )

				Otherwise
					.lShowError	= Bitand ( .TierBehavior, EH_SHOWERROR ) == EH_SHOWERROR
					.lLogError	= Bitand ( .TierBehavior, EH_LOGERROR ) == EH_LOGERROR

			Endcase

			Do Case
				Case Vartype ( m.tvExp ) == 'O' And Lower ( m.tvExp.BaseClass ) == 'exception'
					loErr = m.tvExp
					.FillError ( m.loErr )

				Otherwise
					.FillError ( .F. )

			Endcase

			If .lShowError And !.lAlreadyShown

				If Vartype( tvExp ) == 'O'
					If !Pemstatus( tvExp, 'lAlreadyShown', 5 )
						AddProperty( tvExp, 'lAlreadyShown', .F. )
					Endif

					.lAlreadyShown = tvExp.lAlreadyShown

				Endif

				If !.lAlreadyShown
					.ShowError()
					.lAlreadyShown = .T.

					If Vartype( tvExp ) == 'O'
						tvExp.lAlreadyShown = .T.
					Endif
				Endif

			Endif && .lShowError And ! .lAlreadyShown

			If .lLogError And !.lAlreadyLogged

				If Vartype( tvExp ) == 'O'
					If !Pemstatus( tvExp, 'lAlreadyLogged', 5 )
						AddProperty( tvExp, 'lAlreadyLogged', .F. )
					Endif

					.lAlreadyLogged = tvExp.lAlreadyLogged

				Endif

				If !.lAlreadyLogged
					.Logerror()
					.lAlreadyLogged = .T.

					If Vartype( tvExp ) == 'O'
						tvExp.lAlreadyLogged = .T.
					Endif
				Endif


			Endif && .lLogError And ! .lAlreadyLogged

		Endwith

	Endproc && Process

	* FillError
	* Carga las propiedades del objeto con información 
	Procedure FillError ( toErr As Exception ) As VOID HelpString 'Carga las propiedades del objeto con información'

		Local lcAnt As String, ;
			lcField As String, ;
			lcProgram As String, ;
			lcTable As String, ;
			lcText As String, ;
			llAlreadyProcessed As Boolean, ;
			lnBegin As Integer, ;
			lnEnd As Integer, ;
			loErr As Exception
		*:Global i

		#If .F.

			TEXT
				 *:Help Documentation
				 *:Description:
				 Carga las propiedades del objeto con información
				 *:Project:
				 Visual Praxis Beta 1.0
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Jueves 13 de Enero de 2005 ( 19:12:46 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		Try
			llAlreadyProcessed = .F.
			
			With This

				If Vartype ( m.toErr ) == 'O' And Lower ( m.toErr.BaseClass ) == 'exception'
					* Si la propiedad UserValue contiene un objeto, significa que esta excepción
					* ha sido Thrown desde otro proceso, por lo tanto, lo único que tengo que
					* hacer es clonar las propiedades base y devolverlo

					If Vartype ( m.toErr.UserValue ) == 'O'

						llAlreadyProcessed = .T.
						loErr			 = m.toErr.UserValue

						Do While Vartype ( m.loErr.UserValue ) == 'O'
							loErr = m.loErr.UserValue

						Enddo

						* Solo se muestra en la capa de usuario
						*.lShowError = Bitand ( This.TierBehavior, EH_SHOWERROR ) == EH_SHOWERROR

						* Solo se muestra la primera vez que se produce el error
						.lShowError = .F.

						* Solo se loguea la primera vez que se produce el error
						.lLogError = .F.

					Else
						loErr = m.toErr

					Endif && Vartype( m.toErr.UserValue ) == "O"

					.CloneError ( m.loErr )

				Else && Vartype( m.toErr ) == "O" And Lower( m.toErr.BaseClass ) == "exception"

					toErr = Createobject( "Exception" )
					.cRemark = 'ADVERTENCIA: Se capturo el ultimo error, no una excepción' + CR + m.Logical.IfEmpty ( .cRemark, '' )
					m.toErr.AddProperty( 'cRemark' )
					toErr.cRemark = .cRemark

					.ErrorNo	  = m.Logical.IfEmpty ( This.aLocalError[ 1, 1 ], 0 )
					toErr.ErrorNo = .ErrorNo

					.Message	  = m.Logical.IfEmpty ( This.aLocalError[ 1, 2 ], '' )
					toErr.Message = .Message

					.Details	  = m.Logical.IfEmpty ( This.aLocalError[ 1, 3 ], '' )
					toErr.Details = .Details

					.Procedure		= Program ( Program ( -1 ) - 2 )
					toErr.Procedure	= .Procedure

				Endif && Vartype( m.toErr ) == "O" And Lower( m.toErr.BaseClass ) == "exception"

				AddProperty( m.toErr, 'lShowError', .lShowError )
				AddProperty( m.toErr, 'lLogError', .lLogError )

				If ! m.llAlreadyProcessed
					Do Case
						Case .ErrorNo = 1427 && OLE IDispatch exception code "name" ( Error 1427 )
							.Message	  = m.Logical.IfEmpty ( This.aLocalError[ 1, 2 ], '' )
							toErr.Message = .Message

							.Details	  = m.Logical.IfEmpty ( This.aLocalError[ 1, 3 ], '' )
							toErr.Details = .Details

							.cAppName = m.Logical.IfEmpty ( This.aLocalError[ 1, 4 ], '' )
							AddProperty( m.toErr, 'cAppName', .cAppName )

							.cHelpFile = m.Logical.IfEmpty ( This.aLocalError[ 1, 5 ], '' )
							AddProperty( m.toErr, 'cHelpFile', .cHelpFile )

							.cHelpId = m.Logical.IfEmpty ( This.aLocalError[ 1, 6 ], '' )
							AddProperty( m.toErr, 'cHelpId', .cHelpId )

							.nOLEExcNo = m.Logical.IfEmpty ( This.aLocalError[ 1, 7 ], '' )
							AddProperty( m.toErr, 'nOLEExcNo', .nOLEExcNo )


						Case .ErrorNo = 1429 && "OLE error" ( Error 1429 )
							.Message = m.Logical.IfEmpty ( This.aLocalError[ 1, 2 ], '' )
							.Details = m.Logical.IfEmpty ( This.aLocalError[ 1, 3 ], '' )
							.cAppName  = m.Logical.IfEmpty ( This.aLocalError[ 1, 4 ], '' )
							.cHelpFile = m.Logical.IfEmpty ( This.aLocalError[ 1, 5 ], '' )
							.cHelpId = m.Logical.IfEmpty ( This.aLocalError[ 1, 6 ], '' )
							.nOLEExcNo = m.Logical.IfEmpty ( This.aLocalError[ 1, 7 ], '' )
							AddProperty( m.toErr, 'nOLEExcNo', .nOLEExcNo )

						Case .ErrorNo = 1526 && Connectivity error: "name" ( Error 1526 )
							.Message	  = m.Logical.IfEmpty ( This.aLocalError[ 1, 2 ], '' )
							toErr.Message = .Message

							.cODBCErrorMsg = m.Logical.IfEmpty ( This.aLocalError[ 1, 3 ], '' )
							AddProperty( m.toErr, 'cODBCErrorMsg', .cODBCErrorMsg )

							.cSQLState = m.Logical.IfEmpty ( This.aLocalError[ 1, 4 ], '' )
							AddProperty( m.toErr, 'cSQLState', .cSQLState )

							.nODBCErrorNo = m.Logical.IfEmpty ( This.aLocalError[ 1, 5 ], '' )
							AddProperty( m.toErr, 'nOLEExcNo', .nOLEExcNo )

							.nODBCConn = m.Logical.IfEmpty ( This.aLocalError[ 1, 6 ], '' )
							AddProperty( m.toErr, 'nODBCConn', .nODBCConn)

						Case .ErrorNo = 1884 && The uniqueness of primary or candidate key is violated.

							lcField = Alltrim ( .Details )
*!*								.Message = .Message + CR ;
*!*									+ 'Ha intentado ingresar un valor ya existente' + CR ;
*!*									+ 'en ' + Upper ( Right ( m.lcField, Len ( m.lcField ) ) ) + '.' + CR ;
*!*									+ CR + 'Los datos no han sido guardados.'
								
							Try
								lcExpresion = "Expresion: " + Key()

							Catch To oErr
								lcExpresion = ""

							Finally

							EndTry
	
							Text To lcMsg NoShow TextMerge Pretext 03
							Ha intentado ingresar un valor ya existente en <<Upper ( Right ( m.lcField, Len ( m.lcField ) ) )>>.
							<<lcExpresion>>
							
							Los datos no han sido guardados.
							EndText
							
							.Message = .Message + CR + CR + lcMsg 

							toErr.Message = .Message + CR 
							
						Case .ErrorNo = 1839 && SQL: Operation was canceled. 
							Text To lcMsg NoShow TextMerge Pretext 03
							La Operación Fue Cancelada Por El Usuario .....
							EndText
							
							.Message = lcMsg 

							toErr.Message = .Message + CR 
							

						Case [Microsoft OLE DB Provider for SQL Server : Cannot insert duplicate key row in object] $ .Message And [with unique index] $ .Message
							lnBegin	= Atc ( ['], loError.Details, 1 ) + 1
							lnEnd	= Atc ( ['], loError.Details, 2 )
							lcTable	= Substr ( m.loError.Details, m.lnBegin, m.lnEnd - m.lnBegin )
							.Message = .Message + CR ;
								+ 'Ha intentado ingresar un valor ya existente' + CR ;
								+ 'en la tabla ' + Upper ( m.lcTable ) + '.' + CR ;
								+ CR + 'Los datos no han sido guardados.'
							toErr.Message = .Message

							*!*	Case [Multiple-step operation generated error] $ .Message

							*!*		.Message = [ MULTIPLE-STEP OPERATION GENERATED ERROR ] + CR + CR ;
							*!*			+ [ This error means that one or more fields you are inserting/updating ] + CR ;
							*!*			+ [ contain an invalid value. Some of the possible scenarios are: ] + CR + CR ;
							*!*			+ [ 1. A string value is being inserted into a numeric field. ] + CR ;
							*!*			+ [ 2. An invalid date expression is being inserted into a date field. ] + CR ;
							*!*			+ [ 3. A string value being inserted is longer than the size of the string field. ] + CR ;
							*!*			+ [ 4. A null value is being inserted into a field that does not allow nulls. ]

						Case [La operación en varios pasos generó errores] $ .Message Or [Multiple - step operation generated error] $ .Message
							.Message = [ LA OPERACIÓN EN VARIOS PASOS GENERÓ ERRORES ] + CR + CR ;
								+ [ Este error significa que uno o más campos que se están insertando o actualizando ] + CR ;
								+ [ contienen un valor no válido. Algunas de las posibles causas son: ] + CR + CR ;
								+ [ 1. Un valor tipo Char se ha intentado insertar en un campo numérico. ] + CR ;
								+ [ 2. Una expresión inválida de fecha se ha tratado de insertar en un campo Date. ] + CR ;
								+ [ 3. Un valor tipo Char que se ha tratado de insertar es más largo que el campo de la tabla. ] + CR ;
								+ [ 4. Se ha tratado de insertar un valor Null en un campo que no lo permite. ]
							toErr.Message = .Message

						Otherwise
							.nWorkarea = m.Logical.IfEmpty ( This.aLocalError[ 1, 4 ], '' )
							AddProperty( m.toErr, 'nWorkarea', .nWorkarea )

							.nTriggerState = m.Logical.IfEmpty ( This.aLocalError[ 1, 5 ], '' )
							AddProperty( m.toErr, 'nTriggerState', .nTriggerState )

					Endcase

					.cHelpId = Transform ( .cHelpId )
					AddProperty( m.toErr, 'cHelpId', .cHelpId )

					.nOLEExcNo = Transform ( .nOLEExcNo )
					AddProperty( m.toErr, 'nOLEExcNo', .nOLEExcNo )

					.nODBCErrorNo = Transform ( .nODBCErrorNo )
					AddProperty( m.toErr, 'nODBCErrorNo', .nODBCErrorNo )

					.nODBCConn = Transform ( .nODBCConn )
					AddProperty( m.toErr, 'nODBCConn', .nODBCConn )

				Endif
				If Empty ( .cErrorDescrip )
					.dTimestamp  = Datetime()
					AddProperty( m.toErr, 'dTimestamp', .dTimestamp )

					.GetErrorInformation()
					.GetStackInformation()
					.GetTablesInformation()
					.GetSystemInformation()

				Endif && Empty ( .cErrorDescrip )

				If ! m.Logical.IsEmpty ( .cTierLevel )
					lcProgram = ''

					For i = 1 To Program ( -1 )
						lcProgram = Program ( Program ( -1 ) - i )

						If ! Lower ( This.Name ) $ Lower ( m.lcProgram )
							Exit

						Endif && ! Lower( This.Name ) $ Lower( m.lcProgram )

					Endfor

					If ! Empty ( m.lcProgram )
						This.cErrorDescrip = 'Disparado por: ' + Proper ( m.lcProgram ) + CR + CR + .cErrorDescrip

					Endif && ! Empty( m.lcProgram )

					This.cErrorDescrip = 'Procesando capa: ' + Proper ( .cTierLevel ) + CR + .cErrorDescrip

				Endif

				AddProperty( m.toErr, 'cErrorDescrip', This.cErrorDescrip )

			Endwith

		Catch To loErr
			If This.lDebug
				DEBUG_EXCEPTION

			Endif && This.lDebug

			Do While Vartype ( m.loErr.UserValue ) == 'O'
				loErr = m.loErr.UserValue

			Enddo

			lcText = 'No se pudo Manejar el error' + CR + CR
			lcText = m.lcText + '[ Método ] ' + m.loErr.Procedure + CR + ;
				'[ Línea N° ] ' + Transform ( m.loErr.Lineno ) + CR + ;
				'[ Comando ] ' + m.loErr.LineContents + CR + ;
				'[ Error ] ' + Transform ( m.loErr.ErrorNo ) + CR + ;
				'[ Mensaje ] ' + m.loErr.Message + CR + ;
				'[ Detalle ] ' + m.loErr.Details + CR + CR

			lcAnt = 'El Error Original fue '
			lcAnt = m.lcAnt + '[ Método ] ' + This.Procedure + CR + ;
				'[ Línea N° ] ' + Transform ( This.Lineno ) + CR + ;
				'[ Comando ] ' + This.LineContents + CR + ;
				'[ Error ] ' + Transform ( This.ErrorNo ) + CR + ;
				'[ Mensaje ] ' + This.Message + CR + ;
				'[ Detalle ] ' + This.Details

			= Messagebox ( m.lcText + m.lcAnt, 16, 'Error Grave' )

			Strtofile ( m.lcText + m.lcAnt, This.GetLogFile(), 1 )

		Endtry

	Endproc && FillError

	* ShowError
	* Muestra el error ( Solo debe ser llamado en la UI ) 
	Procedure ShowError() As Numeric HelpString 'Muestra el error'
		Local lnReturn As Number, ;
			loErr As Exception, ;
			loForm As Form
			
		Local loApp As prxApplication Of "Fw\SysAdmin\Prg\saMain.prg"

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Muestra el error ( Solo debe ser llamado en la UI )
				 *:Project:
				 Visual Praxis Beta 1.0
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Martes 11 de Enero de 2005 ( 16:45:00 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		#If .F.
			Do Tools\ErrorHandler\prg\ErrorForm.prg
		#Endif

		With This
			.lAlreadyShown = .T.
			lnReturn	 = 0

			If m.Logical.IsRunTime() And ! This.lSkipIsRunTimeCheck
				Try
					loApp = NewApp() 
					If loApp.lExit  
						This.nTimeout = 10
					EndIf

				Catch To oErrAux

				Finally
					loApp = Null 

				EndTry

				Messagebox ( .cUserMessage, .nDialogBoxType + .nErrorType, .cTitleBarText, .nTimeout )

			Else && Develop
				lnReturn = -1
				Try

					loForm = .GetErrorForm()
					If Vartype ( m.loForm ) # 'O'
						loForm = NewObject ( 'ErrorForm', 'Tools\ErrorHandler\Prg\ErrorForm.prg', '', This )

						If m.CacheManager.Exists ( 'oErrorForm' )
							m.CacheManager.Update ( m.loForm, 'oErrorForm' )

						Else
							m.CacheManager.Add ( m.loForm, 'oErrorForm' )

						Endif
						m.loForm.Show()

					Else
						m.loForm.AddError ( This )

					Endif

				Catch To loErr
					If This.lDebug
						DEBUG_EXCEPTION

					Endif && This.lDebug
					lnReturn = Messagebox ( .cErrorDescrip + CR + m.loErr.Message, .nDialogBoxType, .cTitleBarText )

				Finally
					loForm = Null

				Endtry

			Endif && Version( 2 ) = 0 && RunTime

		Endwith

		Return m.lnReturn

	Endproc && ShowError

	* CloneError
	* Copia las propiedades de un objeto exception generado por un error 
	Procedure CloneError ( toErr As Exception ) As VOID HelpString 'Copia las propiedades de un objeto exception generado por un error'

		Local laMember[1], ;
			lcPropertyName As String, ;
			lcTierLevel As String, ;
			llLogError As Boolean, ;
			llShowError As Boolean, ;
			lnI As Integer, ;
			lnLen As Integer, ;
			loErr As Object

		#If .F.

			TEXT
			 *:Help Documentation
			 *:Description:
			 Copia las propiedades de un objeto exception generado por un error
			 *:Project:
			 Visual Praxis Beta 1.0
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Miércoles 19 de Enero de 2005 ( 14:46:27 )
			 *:ModiSummary:
			 R/0001 -
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		With This As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			* Resguarda los valores
			lcTierLevel	= .cTierLevel
			llShowError	= .lShowError
			llLogError	= .lLogError
			lnLen		= Amembers ( laMember, m.toErr, 0 )

			For lnI = 1 To m.lnLen
				Try
					lcPropertyName	 = laMember[ m.lnI ]
					.&lcPropertyName = Getpem ( m.toErr, m.lcPropertyName )

				Catch To loErr
					If This.lDebug
						DEBUG_EXCEPTION

					Endif && This.lDebug

				Endtry

			Endfor

			.cTierLevel	= m.lcTierLevel
			.lShowError	= m.llShowError
			.lLogError	= m.llLogError

		Endwith

	Endproc && CloneError

	* GetErrorInformation
	* Obtiene un string parseado con toda la información del error 
	Procedure GetErrorInformation() As VOID HelpString 'Obtiene un string parseado con toda la información del error'
		Local lcErrorStr As String

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Obtiene un string parseado con toda la información del error
			 *:Project:
			 Visual Praxis Beta 1.0
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Miércoles 19 de Enero de 2005 ( 15:50:26 )
			 *:ModiSummary:
			 R/0001 -
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		With This

			lcErrorStr	  = ''
			.cUserMessage = ''

			*!* If ! m.Logical.IsEmpty( .cTierLevel )
			*!* .cUserMessage = .cUserMessage + .cTierLevel + CR
			*!* Endif

			If ! Empty ( .cTraceLogin )
				.cUserMessage = .cUserMessage + .cTraceLogin + CR

			Endif && ! Empty( .cTraceLogin )

			If ! Empty ( .cRemark )
				.cUserMessage = .cUserMessage + .cRemark + CR

			Endif && ! Empty( .cRemark )

			Do Case
				Case .ErrorNo = 1884
					.cUserMessage = .cUserMessage + EH_ERR_1884

				Otherwise
					.cUserMessage = .cUserMessage + .Message

			Endcase

			If ! Empty ( .cUserMessage )
				lcErrorStr = .cUserMessage + CR

			Endif && ! Empty( .cUserMessage )

			lcErrorStr = m.lcErrorStr + '[ Error N° ] ' + Transform ( .ErrorNo ) + CR

			If ! Empty ( .Message )
				lcErrorStr = m.lcErrorStr + '[ Message ] ' + .Message + CR

			Endif && ! Empty( .Message )

			If ! Empty ( .Details )
				lcErrorStr = m.lcErrorStr + '[ Details ] ' + .Details + CR

			Endif && ! Empty( .Details )

			If ! m.Logical.IsEmpty ( .Procedure )
				lcErrorStr = lcErrorStr + '[ Procedure ] ' + .Procedure + CR
			Endif

			If ! Empty ( .Lineno )
				lcErrorStr = m.lcErrorStr + '[ Line N° ] ' + Transform ( .Lineno ) + CR

			Endif && ! Empty( .Lineno )

			If ! Empty ( .LineContents ) And !m.Logical.IsRunTime()
				* RA 2013-10-07(11:43:17)
				* Cuando es Runtime no trae la información correcta
				* ARREGLAR

				lcErrorStr = m.lcErrorStr + '[ Line Contents ] ' + .LineContents + CR

			Endif && ! Empty( .LineContents )

			If ! Empty ( .cAppName )
				lcErrorStr = m.lcErrorStr + '[ Application Name ] ' + .cAppName + CR

			Endif && ! Empty( .cAppName )

			If ! Empty ( .cHelpFile )
				lcErrorStr = m.lcErrorStr + '[ Help File ] ' + .cHelpFile + CR

			Endif && ! Empty( .cHelpFile )

			If ! m.Logical.IsEmpty ( .cHelpId )
				lcErrorStr = lcErrorStr + '[ Help Context ID ] ' + .cHelpId + CR
			Endif

			If ! Empty ( .nOLEExcNo )
				lcErrorStr = m.lcErrorStr + '[ OLE 2.0 Exception N° ] ' + Transform ( .nOLEExcNo ) + CR
			Endif && ! Empty( .nOLEExcNo )

			If ! Empty ( .nODBCErrorNo )
				lcErrorStr = m.lcErrorStr + '[ ODBC Error N° ] ' + Transform ( .nODBCErrorNo ) + CR

			Endif && ! Empty( .nODBCErrorNo )

			If ! Empty ( .cODBCErrorMsg )
				lcErrorStr = m.lcErrorStr + '[ ODBC Error Message ] ' + .cODBCErrorMsg + CR

			Endif && ! Empty( .cODBCErrorMsg )

			If ! Empty ( .cSQLState )
				lcErrorStr = m.lcErrorStr + '[ ODBC SQL State ] ' + .cSQLState + CR

			Endif && ! Empty( .cSQLState )

			If ! Empty ( .nODBCConn )
				lcErrorStr = m.lcErrorStr + '[ ODBC Connection Handle ] ' + Transform ( .nODBCConn ) + CR

			Endif && ! Empty( .nODBCConn )

			lcErrorStr = m.lcErrorStr + '[ Datasession ] ' + Transform ( Set ( 'Datasession' ), '@L 999' ) + CR
			lcErrorStr = m.lcErrorStr + '[ TxnLevel ] ' + Transform ( Txnlevel() ) + CR

			.cErrorDescrip = m.lcErrorStr

		Endwith

	Endproc && GetErrorInformation

	* GetTablesInformation
	* Obtiene un string parseado con toda la información de las tablas abiertas al momento del error 
	Procedure GetTablesInformation() As VOID HelpString 'Obtiene un string parseado con toda la información de las tablas abiertas al momento del error'

		Local laTables[1], ;
			lcOldAlias As String, ;
			lcPropName As String, ;
			lcStr As String, ;
			lcTables As String, ;
			lnAlias As Integer, ;
			lnIdx As Number

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Obtiene un string parseado con toda la información de las tablas abiertas al momento del error
			 *:Project:
			 Visual Praxis Beta 1.0
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Miércoles 19 de Enero de 2005 ( 15:52:27 )
			 *:ModiSummary:
			 R/0001 -
			 *:Parameters:
			 *:Remarks:
			 *:Returns:
			 *:Example:
			 *:SeeAlso:
			 *:Events:
			 *:KeyWords:
			 *:Inherits:
			 *:Exceptions:
			 *:NameSpace:
			 digitalizarte.com
			 *:EndHelp
			ENDTEXT
		#Endif

		lcOldAlias = Alias()
		lcTables = ''

		If ! Empty ( m.lcOldAlias )
			lcTables = 'Current Area: ' + m.lcOldAlias + CR

		Endif && ! Empty( m.lcOldAlias )

		lcTables = m.lcTables + 'Area Alias' + CR

		For lnIdx = 1 To Aused ( laTables )
			lnAlias	 = laTables[ m.lnIdx, 1 ]
			lcTables = m.lcTables + Transform ( laTables[ m.lnIdx, 2 ] ) + ' ) '
			lcTables = m.lcTables + Transform ( m.lnAlias ) + CR

			Select ( m.lnAlias )
			lcTables = m.lcTables + ' - Record: ' + Transform ( Recno ( m.lnAlias ) ) + CR
			lcStr	 = Order ( m.lnAlias )
			If ! Empty ( m.lcStr )
				lcTables = m.lcTables + ' - Order: ' + m.lcStr + CR

			Endif && ! Empty( m.lcStr )

			lcTables = m.lcTables + ' - Is Transactable: ' + Transform ( IsTransactable ( m.lnAlias ) ) + CR

			lcRelation = Set ( 'Relation' )
			If ! Empty ( m.lcRelation )
				lcTables = m.lcTables + ' - Relation: ' + m.lcRelation + CR

			Endif && ! Empty( m.lcStr )

			lcKeyFieldList = m.Cursor.GetProp( 'KeyFieldList', m.lnAlias )
			If ! Empty ( m.lcKeyFieldList )
				lcTables = m.lcTables + ' - KeyFieldList: ' + m.lcKeyFieldList + CR

			Endif && ! Empty( m.lcStr )

			lcBuffering = m.Cursor.GetProp( 'Buffering', m.lnAlias )
			If ! Empty ( m.lcBuffering )
				lcTables = m.lcTables + ' - Buffering: ' + Transform( m.lcBuffering ) + CR

			Endif && ! Empty( m.lcStr )

			lcDatabase = m.Cursor.GetProp( 'Database', m.lnAlias )
			If ! Empty ( m.lcDatabase )
				lcTables = m.lcTables + ' - Database: ' + m.lcDatabase + CR

			Endif && ! Empty( m.lcStr )

			lcSQL = m.Cursor.GetProp( 'SQL', m.lnAlias )
			If ! Empty ( m.lcSQL )
				lcTables = m.lcTables + ' - SQL: ' + m.lcSQL + CR

			Endif && ! Empty( m.lcSQL )

			lcUpdatableFieldList = m.Cursor.GetProp( 'UpdatableFieldList', m.lnAlias )
			If ! Empty ( m.lcUpdatableFieldList )
				lcTables = m.lcTables + ' - UpdatableFieldList: ' + m.lcUpdatableFieldList + CR

			Endif && ! Empty( m.lcUpdatableFieldList )

			lcUpdateNameList = m.Cursor.GetProp( 'UpdateNameList', m.lnAlias )
			If ! Empty ( m.lcUpdateNameList )
				lcTables = m.lcTables + ' - UpdateNameList: ' + m.lcUpdateNameList + CR

			Endif && ! Empty( m.lcUpdateNameList )

			lcSourceName = m.Cursor.GetProp( 'SourceName', m.lnAlias )
			If ! Empty ( m.lcSourceName )
				lcTables = m.lcTables + ' - SourceName: ' + m.lcSourceName + CR

			Endif && ! Empty( m.lcSourceName )

			lcSourceType = m.Cursor.GetProp( 'SourceType', m.lnAlias )
			If ! Empty ( m.lcSourceType )
				lcTables = m.lcTables + ' - SourceType: ' + Transform( m.lcSourceType ) + CR

			Endif && ! Empty( m.lcSourceType )

		Endfor

		This.cTables = m.lcTables

		If ! Empty ( m.lcOldAlias )
			Select Alias ( m.lcOldAlias )

		Endif && ! Empty( m.lcOldAlias )

	Endproc && GetTablesInformation

	* GetStackInformation
	* Obtiene un string parseado con toda la información del stack 
	Procedure GetStackInformation() As VOID HelpString 'Obtiene un string parseado con toda la información del stack'

		Local lcErroStr As String, ;
			lcFormat As String, ;
			lnLen As Integer, ;
			lnRow As Integer

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Obtiene un string parseado con toda la información del stack
				 *:Project:
				 Visual Praxis Beta 1.0
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Miércoles 19 de Enero de 2005 ( 15:55:02 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		lcErroStr = ''

		* Astackinfo ( This.aLocalStackinfo )

		*!*			lnLen = Program ( -1 ) - 2

		*!*	m.lcErroStr = m.lcErroStr + Transform ( This.StackLevel ) + ' ) '
		*!*	m.lcErroStr = m.lcErroStr + '[ Módulo ] ' + m.String.ProperCase ( This.aLocalStackinfo[ m.lnLen, 3 ], '.' )
		*!*	m.lcErroStr = m.lcErroStr + ' [ Línea ] ' + Transform ( This.Lineno ) + CR

		lcFormat = '{1}) [ Módulo ] {2} [ Línea ] {3}' + CR
		* m.lcErroStr = m.String.StringBuilder( m.lcFormat, This.StackLevel, m.String.ProperCase ( This.aLocalStackinfo[ m.lnLen, 3 ], '.' ), This.Lineno )
		lcErroStr = ''
		For lnRow = This.nStackinfoLen To 1 Step - 1
			*!*	m.lcErroStr = m.lcErroStr + Transform ( This.aLocalStackinfo[ m.lnRow, 1 ] ) + ' ) '
			*!*	m.lcErroStr = m.lcErroStr + '[ Módulo ] ' + m.String.ProperCase ( This.aLocalStackinfo[ m.lnRow, 3 ], '.' )
			*!*	m.lcErroStr = m.lcErroStr + ' [ Línea ] ' + Transform ( This.aLocalStackinfo[ m.lnRow, 5 ] ) + CR

			Try
				lcErroStr = m.lcErroStr + m.String.StringBuilder( m.lcFormat,;
					This.aLocalStackinfo[ m.lnRow, 1 ],;
					m.String.ProperCase ( This.aLocalStackinfo[ m.lnRow, 3 ], '.' ), ;
					This.aLocalStackinfo[ m.lnRow, 5 ] )



			Catch To oErr
				TEXT To lcCommand NoShow TextMerge Pretext 15
				This.aLocalStackinfo[ <<m.lnRow>>, 1 ],
				m.String.ProperCase ( This.aLocalStackinfo[ <<m.lnRow>>, 3 ], '.' ),
				This.aLocalStackinfo[ <<m.lnRow>>, 5 ] )
				ENDTEXT

				Strtofile( lcCommand, "GetStackInformation.txt" )

				*Throw oErr

			Finally

			Endtry

		Endfor

		This.cStack = m.lcErroStr

	Endproc && GetStackInformation

	* GetSystemInformation
	* Obtiene un string parseado con toda la información del Sistema al momento del error 
	Procedure GetSystemInformation() As VOID HelpString 'Obtiene un string parseado con toda la información del Sistema al momento del error'

		Local laVersion[3] As String, ;
			lalines[1], ;
			lcAux As String, ;
			lcIdioma As String, ;
			lcIdioma00 As String, ;
			lcIdioma33 As String, ;
			lcIdioma34 As String, ;
			lcIdioma39 As String, ;
			lcIdioma42 As String, ;
			lcIdioma48 As String, ;
			lcIdioma49 As String, ;
			lcIdioma55 As String, ;
			lcIdioma82 As String, ;
			lcIdioma86 As String, ;
			lcIdioma88 As String, ;
			lcMaq As String, ;
			lcStrError As String, ;
			lcUsu As String, ;
			liCnt As Integer, ;
			liIdx As Integer

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Obtiene un string parseado con toda la información del Sistema al momento del error
				 *:Project:
				 Visual Praxis Beta 1.0

				 *:Autor:
				 Ricardo Aidelman

				 *:Date:
				 Miércoles 26 de Enero de 2005 ( 18:02:53 )

				 *:ModiSummary:

				 R/0001 -

				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		laVersion[ 1 ] = 'Versión de tiempo de ejecución'
		laVersion[ 2 ] = 'Edición estándar'
		laVersion[ 3 ] = 'Edición profesional'

		lcIdioma00 = 'Inglés'
		lcIdioma33 = 'Francés'
		lcIdioma34 = 'Español'
		lcIdioma39 = 'Italiano'
		lcIdioma42 = 'Checo'
		lcIdioma48 = 'Polaco'
		lcIdioma49 = 'Alemán'
		lcIdioma55 = 'Portugués'
		lcIdioma82 = 'Coreano'
		lcIdioma86 = 'Chino simplificado'
		lcIdioma88 = 'Chino tradicional'
		lcIdioma = ''

		lcStrError = ''
		lcStrError = m.lcStrError + 'Fecha: ' + Ttoc ( Datetime() ) + CR
		lcStrError = m.lcStrError + 'Sistema Operativo: ' + Os() + ' - ' + Os ( 7 ) + CR

		lcAux = Version ( 3 )
		If Vartype ( lcIdioma&lcAux. ) == 'C'
			lcIdioma= m.lcIdioma&lcAux.

		Endif && Vartype ( lcIdioma&lcAux. ) == 'C'

		lcStrError = m.lcStrError + 'Version: ' + Version() + ' - ' + laVersion[ Version ( 2 ) + 1 ] + ' - ' + m.lcIdioma + CR

		lcMaq = Sys ( 0 )
		lcUsu = lcMaq
		lcMaq = Proper ( Substr ( m.lcMaq, 1, At ( '#', m.lcMaq ) - 1 ) )
		lcUsu = Proper ( Substr ( m.lcUsu, At ( '#', m.lcUsu ) + 1 ) )

		This.cTerminal = m.lcMaq
		This.cUserName = m.lcUsu

		lcStrError = m.lcStrError + 'Equipo: ' + m.lcMaq + CR
		lcStrError = m.lcStrError + 'Usuario Windows: ' + m.lcUsu + CR

		Try

			loUser = NewUser()

			lcStrError = lcStrError + "Usuario Fenix: " + loUser.Nombre + CR
			lcStrError = lcStrError + "Grupo: " + loUser.Grupo + CR
			lcStrError = lcStrError + "Nivel: " + Transform( loUser.Nivel ) + CR
			lcStrError = lcStrError + "Permiso (CLAVE): " + Transform( loUser.Clave ) + CR

		Catch To oErr

		Finally
			loUser = Null

		Endtry


		lcStrError = m.lcStrError + 'Unidad: ' + Lower ( Sys ( 5 ) ) + CR
		lcStrError = m.lcStrError + 'Carpeta: ' + [ " ] + Proper ( Sys ( 2003 ) ) + [ " ] + CR
		lcStrError = m.lcStrError + 'Espacio Libre en Disco: ' + Alltrim ( Str ( Round ( Diskspace() / 1000000, 0 ) ) ) + 'Mb' + CR
		lcStrError = m.lcStrError + 'Impresora: ' + Proper ( Sys ( 6 ) ) + CR
		lcStrError = m.lcStrError + 'Estado de la Impresora: ' + Sys ( 13 ) + CR
		lcStrError = m.lcStrError + 'Archivo de Formato: ' + Sys ( 7 ) + CR
		lcStrError = m.lcStrError + 'Numero de Serie: ' + Sys ( 8 ) + CR
		lcStrError = m.lcStrError + 'Procesador: ' + Sys ( 17 ) + CR
		lcStrError = m.lcStrError + 'Memoria de Visual FoxPro: ' + Sys ( 1001 ) + CR
		lcStrError = m.lcStrError + 'Tarjeta Grafica: ' + Sys ( 2006 ) + CR + CR
		* m.lcStrError = m.lcStrError + 'Path: ' + Set ( 'Path' ) + CR + CR

		lcStrError = m.lcStrError + 'Path: ' + CR + CR
		liCnt	 = Alines( lalines, Set ( 'Path' ), 1 + 4, ';' )
		Asort( lalines )
		For liIdx = 1 To m.liCnt
			lcStrError = m.lcStrError + Tab + lalines[ m.liIdx ] + CR

		Next

		* m.lcStrError = m.lcStrError + 'ClassLib: ' + Set ( 'Classlib' ) + CR + CR
		lcStrError = m.lcStrError + 'ClassLib: ' + CR + CR

		liCnt = Alines( lalines, Set ( 'Classlib' ), 1 + 4, ';' )
		Asort( lalines )
		For liIdx = 1 To m.liCnt
			lcStrError = m.lcStrError + Tab + lalines[ m.liIdx ] + CR

		Next

		lcStrError = m.lcStrError + 'Procedure: ' + CR + CR
		liCnt = Alines( lalines, Set ( 'Procedure' ), 1 + 4, ';' )
		Asort( lalines )
		For liIdx = 1 To m.liCnt
			lcStrError = m.lcStrError + Tab + lalines[ m.liIdx ] + CR

		Next

		lcStrError = m.lcStrError + 'Curdir: ' + Set ( 'Default' ) + Curdir() + CR + CR

		This.cSysInfo  = m.lcStrError

	Endproc && GetSystemInformation

	* ErrorToXml
	* Transforma el objeto Exception en un XML 
	Procedure ErrorToXml ( tcComment As String ) As String
		Local lcErrorStr As String, ;
			lcRet As String, ;
			lcXML As String, ;
			loErr As Object, ;
			loXA As XMLNamespace Of 'Tools\Namespaces\prg\XMLNameSpace.prg'

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Transforma el objeto Exception en un XML
				 *:Project:
				 Visual Praxis Beta 1.0

				 *:Autor:
				 Ricardo Aidelman

				 *:Date:
				 Jueves 20 de Enero de 2005 ( 14:59:33 )

				 *:ModiSummary:

				 R/0001 -


				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		* DAE 2009-05-22

		Try
			tcComment = m.Logical.IfEmpty ( m.tcComment, '' )
			lcXML	  = ''
			loXA	  = m.XML.NewXMLAdapter()
			m.loXA.LoadObj ( This )
			m.loXA.ToXML ( 'lcXML' )

			If Empty ( m.tcComment )
				tcComment = '#<ERR>#'

			Else
				tcComment = '#<ERR>#<' + Alltrim ( m.tcComment ) + '>#<ERR>#'

			Endif

		Catch To loErr
			If This.lDebug
				DEBUG_EXCEPTION

			Endif && This.lDebug
			lcErrorStr = Transform ( Datetime() ) + CRLF + CRLF
			lcErrorStr = m.lcErrorStr + '[ Error N° ] ' + Transform ( m.loErr.ErrorNo ) + CRLF
			If ! m.Logical.IsEmpty ( .Message )
				lcErrorStr = m.lcErrorStr + '[ Message ] ' + m.loErr.Message + CRLF

			Endif && ! m.Logical.IsEmpty( .Message )

			If ! m.Logical.IsEmpty ( .Details )
				lcErrorStr = m.lcErrorStr + '[ Details ] ' + m.loErr.Details + CRLF

			Endif && ! m.Logical.IsEmpty( .Details )

			If ! m.Logical.IsEmpty ( .Procedure )
				lcErrorStr = m.lcErrorStr + '[ Procedure ] ' + m.loErr.Procedure + CRLF
			Endif

			If ! m.Logical.IsEmpty ( .Lineno )
				lcErrorStr = m.lcErrorStr + '[ Line N° ] ' + Transform ( m.loErr.Lineno ) + CRLF

			Endif && ! m.Logical.IsEmpty( .Lineno )

			If ! m.Logical.IsEmpty ( .LineContents )
				lcErrorStr = m.lcErrorStr + '[ Line Contents ] ' + m.loErr.LineContents + CRLF + CRLF + CRLF

			Endif && ! m.Logical.IsEmpty( .LineContents )

			Strtofile ( m.lcErrorStr, This.GetLogFile(), 1 )


		Finally
			loXA = Null
			Try
				lcRet = m.tcComment + m.lcXML

			Catch To loErr
				lcRet = m.tcComment

			Endtry

		Endtry

		Return m.lcRet

	Endproc && ErrorToXml

	* XmlToError
	* Actualiza las propiedades de un objeto Error con información recibida de un XML 
	Procedure XmlToError ( tcXML As String ) As Boolean HelpString 'Actualiza las propiedades de un objeto Error con información recibida de un XML'

		Local loErr As Object, ;
			loError As ErrorHandler Of 'Tools\ErrorHandler\prg\ErrorHandler.prg', ;
			loXA As XMLAdapterBase Of 'Tools\Namespaces\prg\XMLNameSpace.prg'
		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Actualiza las propiedades de un objeto Error con información recibida de un XML
				 *:Project:
				 Visual Praxis Beta 1.0

				 *:Autor:
				 Ricardo Aidelman

				 *:Date:
				 Viernes 21 de Enero de 2005 ( 17:30:39 )

				 *:ModiSummary:

				 R/0001 -


				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		Try

			*!* Eliminar cualquier comentario que traiga insertado el XML
			tcXML = m.XML.ParseXML ( m.tcXML )

			loXA = m.XML.NewXMLAdapter()
			m.loXA.LoadXML ( m.tcXML )

			loError = m.loXA.ToObject()

			This.FillError ( m.loError )

		Catch To loErr
			If This.lDebug
				DEBUG_EXCEPTION

			Endif && This.lDebug

		Finally
			loXA = Null

		Endtry

		Return m.loError

	Endproc && XmlToError

	* LogError
	Procedure Logerror( cErrorLogFileName ) HelpString 'Actualiza el LogFile con el error actual'

		Local lcStr As String, ;
			lcFileName as String,;
			loErr As Exception

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Actualiza el LogFile con el error actual
				 *:Project:
				 Visual Praxis Beta 1.0
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Martes 1 de Febrero de 2005 ( 17:46:17 )
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif


		Try

			This.lAlreadyLogged = .T.

			m.lcStr = Ttoc( Datetime() ) + CRLF + CRLF
			m.lcStr = m.lcStr + "Descripción del error" + CRLF
			m.lcStr = m.lcStr + This.cErrorDescrip + CRLF + CRLF

			m.lcStr = m.lcStr + "Tablas y cursores en uso" + CRLF
			m.lcStr = m.lcStr + "DatasessionId: " + Transform( Set("Datasession" )) + CRLF + CRLF
			m.lcStr = m.lcStr + This.cTables + CRLF + CRLF

			m.lcStr = m.lcStr + "Pila de llamadas" + CRLF
			m.lcStr = m.lcStr + This.cStack + CRLF + CRLF

			m.lcStr = m.lcStr + "Información del sistema" + CRLF
			m.lcStr = m.lcStr + This.cSysInfo  + CRLF

			m.lcStr = m.lcStr + Replicate( "-.", 40 ) + CRLF + CRLF

			*!*				TEXT To m.lcStr Textmerge Noshow
			*!*	<<Dtoc( Datetime(), 1 )>> v.<<This.cVersion>>
			*!*	Descripción del Error
			*!*	<<This.cErrorDescrip>>

			*!*	Pila de llamadas
			*!*	<<This.cStack>>

			*!*	Tablas y Cursores en uso
			*!*	<<This.cTables>>

			*!*	Información del Sistema
			*!*	<<This.cSysInfo>>


			*!*	<<Replicate( "-.", 40 )>>

			*!*				ENDTEXT
			
			lcFileName = This.GetLogFile( cErrorLogFileName )

			Strtofile ( m.lcStr, lcFileName, 1 )

			* Intentar grabar el ErrorLog.txt en el servidor, 
			* para poder acceder más facilmenmte
			If Vartype( DRVA ) = "C"
				lcFileName = JustFname( lcFileName )  
				Strtofile( lcStr, Addbs(Alltrim(DRVA))+lcFileName, 1 )
			Endif


		Catch To loErr
			If This.lDebug
				DEBUG_EXCEPTION

			Endif && This.lDebug
			*-- Si se produce un error, no hace nada

		Endtry

	Endproc && SaveError

	* GetErrorForm
	* Devuelve una referencia al formulario para mostrar los errores si este esta abierto 
	Protected Procedure GetErrorForm() As Form HelpString 'Devuelve una referencia al formulario para mostrar los errores si este esta abierto'

		Local llOk As Boolean, ;
			lnFormCount As Integer, ;
			lnIdx As Number, ;
			loErr As Exception, ;
			loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg', ;
			loForm As Form

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve una referencia al formulario para mostrar los errores si este esta abierto
				 *:Project:
				 Sistemas Praxis

				 *:Autor:
				 Damian Eiff

				 *:Date:
				 Miércoles 1 de Julio de 2009 ( 17:01:30 )

				 *:ModiSummary:

				 R/0001 -


				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		Try
			loForm = m.CacheManager.Get ( 'oErrorForm' )
			If Isnull ( m.loForm )
				lnIdx		= 1
				lnFormCount	= _Screen.FormCount
				Do While ! m.llOk And m.lnIdx <= m.lnFormCount
					loForm = _Screen.Forms ( m.lnIdx )
					If Lower ( m.loForm.BaseClass ) == 'form' And Lower ( m.loForm.Name ) == 'errorform'
						llOk = .T.

					Else
						lnIdx = m.lnIdx + 1

					Endif && Lower( m.loForm.BaseClass ) == 'form' And Lower( m.loForm.Name ) == 'errorform'

				Enddo
				If ! m.llOk
					loForm = Null

				Endif && ! m.llOk

			Endif

		Catch To loErr
			If This.lDebug
				DEBUG_EXCEPTION

			Endif && This.lDebug
			m.loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\prg\ErrorHandler.prg' )
			m.loError.Process ( m.loErr )
			Throw m.loError

		Finally
			loError = Null

		Endtry

		Return m.loForm

	Endproc && GetErrorForm

	* Reset
	* Reinicia una propiedad o todas 
	Procedure Reset() As VOID HelpString 'Reinicia una propiedad o todas'
		Local lcAnt As String, ;
			lcText As String, ;
			loErr As Exception

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Reinicia una propiedad o todas
				 *:Project:
				 Sistemas Praxis

				 *:Autor:
				 Damian Eiff

				 *:Date:
				 Viernes 21 de Agosto de 2009 ( 14:03:37 )

				 *:ModiSummary:

				 R/0001 -


				 *:Parameters:
				 *:Remarks:
				 *:Returns:
				 *:Example:
				 *:SeeAlso:
				 *:Events:
				 *:KeyWords:
				 *:Inherits:
				 *:Exceptions:
				 *:NameSpace:
				 digitalizarte.com
				 *:EndHelp
			ENDTEXT
		#Endif

		Try

			With This As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				.nErrorType		= MB_ICONSTOP
				.cTierLevel		= ''
				.cTraceLogin	= ''
				.cRemark		= ''
				.nDialogBoxType	= MB_OK
				*.nTimeout		= 300 * 1000
				.nTimeout		= 0
				.nWorkarea		= 0
				.cAppName		= ''
				.cSQLState		= ''
				.nTriggerState	= 0
				.cHelpFile		= ''
				.cHelpId		= ''
				.cODBCErrorMsg	= ''
				.nODBCErrorNo	= 0
				.nODBCConn		= 0
				.nOLEExcNo		= 0
				.cErrorDescrip	= ''
				.cTables		= ''
				.cStack			= ''
				.dTimestamp		= Datetime()
				.cSysInfo		= ''
				.cUserMessage	= ''
				.nReturnValue	= -1
				.cCursorName	= EH_CursorName
				.lAlreadyShown	= .F.
				.lAlreadyLogged	= .F.

			Endwith

		Catch To loErr
			If This.lDebug
				DEBUG_EXCEPTION

			Endif && This.lDebug
			Do While Vartype ( m.loErr.UserValue ) == 'O'
				loErr = m.loErr.UserValue

			Enddo

			lcText = 'No se pudo Manejar el error' + CR + CR
			lcText = m.lcText + '[ Método ] ' + m.loErr.Procedure + CR + ;
				'[ Línea N° ] ' + Transform ( m.loErr.Lineno ) + CR + ;
				'[ Comando ] ' + m.loErr.LineContents + CR + ;
				'[ Error ] ' + Transform ( m.loErr.ErrorNo ) + CR + ;
				'[ Mensaje ] ' + m.loErr.Message + CR + ;
				'[ Detalle ] ' + m.loErr.Details + CR + CR

			lcAnt = 'El Error Original fue '
			lcAnt = m.lcAnt + '[ Método ] ' + This.Procedure + CR + ;
				'[ Línea N° ] ' + Transform ( This.Lineno ) + CR + ;
				'[ Comando ] ' + This.LineContents + CR + ;
				'[ Error ] ' + Transform ( This.ErrorNo ) + CR + ;
				'[ Mensaje ] ' + This.Message + CR + ;
				'[ Detalle ] ' + This.Details

			= Messagebox ( m.lcText + m.lcAnt, 16, 'Error Grave' )

			Strtofile ( m.lcText + m.lcAnt, This.GetLogFile(), 1 )

		Endtry

	Endproc && ResetToDefault

Enddefine && ErrorHandler
