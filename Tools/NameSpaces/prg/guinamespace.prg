#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
Endif

#Define MAX_COLORS 255 * 256 * 256

* GUINameSpace
Define Class GUINameSpace As ObjectNameSpace Of 'Tools\namespaces\prg\ObjectNamespace.prg' 

	#If .F.
		Local This As GUINameSpace Of 'Tools\namespaces\prg\GUINameSpace.prg'
	#Endif

	* XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version = "1.0" encoding = "Windows-1252" standalone = "yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="billboard" type="method" display="Billboard" />] ;
		+ [<memberdata name="confirm" type="method" display="Confirm" />] ;
		+ [<memberdata name="getoutputoptions" type="method" display="GetOutputOptions" />] ;
		+ [<memberdata name="getrgb" type="method" display="GetRGB" />] ;
		+ [<memberdata name="inform" type="method" display="Inform" />] ;
		+ [<memberdata name="launchform" type="method" display="LaunchForm" />] ;
		+ [<memberdata name="nohabilitada" type="method" display="NoHabilitada" />] ;
		+ [<memberdata name="printreport" type="method" display="PrintReport" />] ;
		+ [<memberdata name="resizewindow" type="method" display="ResizeWindow" />] ;
		+ [<memberdata name="stop" type="method" display="Stop" />] ;
		+ [<memberdata name="trylaunchform" type="method" display="TryLaunchForm" />] ;
		+ [<memberdata name="warning" type="method" display="Warning" />] ;
		+ [</VFPData>]

	Dimension Billboard_COMATTRIB[ 5 ]
	Billboard_COMATTRIB[ 1 ] = 0
	Billboard_COMATTRIB[ 2 ] = 'A big centered wait window.'
	Billboard_COMATTRIB[ 3 ] = 'Billboard'
	Billboard_COMATTRIB[ 4 ] = 'Void'
	* Billboard_COMATTRIB[ 5 ] = 0

	* Billboard
	* A big centered wait window.
	Procedure Billboard ( tcText As String ) As void HelpString 'A big centered wait window.'
		*!* Program: Billboard
		*!* Author: MS
		*!* Date: 05 / 30 / 03 02:31:42 PM
		*!* Copyright: 2003, MS
		*!* Description: A big centered wait window
		*!* Revision Information:

		Local lcLine As String, ;
			lcText As String, ;
			lnCntLines As Number, ;
			lnLen As Number, ;
			lnMaxLen As Number, ;
			lnSaveMemoWidth As Integer, ;
			lnX As Integer, ;
			lnY As Integer, ;
			loErr As Exception

		Try
			If Empty ( m.tcText )
				Wait Clear

			Else && Empty ( m.tcText )
				* Saves memo width
				lnSaveMemoWidth = Set ( 'MemoWidth', 1 )

				* Fixed width
				lnX    = 100
				lcText = ''
				Set Memowidth To m.lnX - 40
				lnMaxLen = 0

				lnCntLines = Memlines ( m.tcText )
				If m.lnCntLines > 0
					* Parse the string line by line
					For lnY = 1 To m.lnCntLines

						* Takes each text line
						lcLine = Alltrim ( Mline ( m.tcText, m.lnY ) )

						* Centers the text in a fixed width
						lcText = m.lcText + Padc ( m.lcLine, m.lnX )

						lnLen = Len ( Alltrim ( m.lcLine ) )

						If m.lnMaxLen < m.lnLen
							lnMaxLen = m.lnLen

						Endif && m.lnMaxLen < m.lnLen

					Next

				Else && m.lnCntLines > 0
					lnMaxLen = Len ( Alltrim ( m.tcText ) )

				Endif && m.lnCntLines > 0

				* Adds blank lines above and bellow
				lcText = Chr ( 13 ) + m.lcText + Chr ( 13 )

				* Restores memo width
				Set Memowidth To m.lnSaveMemoWidth

				* Calculate X and Y positions
				lnY = ( Srows() / 2 ) - ( m.lnY / 2 )
				* lnX = ( Scols() / 2 ) - ( lnX / 2 )
				lnX = ( Scols() - m.lnMaxLen ) / 2

				Clear Typeahead
				Wait Clear

				* Slight offsets included to improve visual centering
				Wait Window m.lcText Nowait At m.lnY - 2, m.lnX + 10

			Endif && Empty( m.tcText )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcText
			THROW_EXCEPTION

		Endtry

	Endproc && Billboard

	Dimension Confirm_COMATTRIB[ 5 ]
	Confirm_COMATTRIB[ 1 ] = 0
	Confirm_COMATTRIB[ 2 ] = 'Devuelve un número con el resultado de la consulta al usuario con un messagebox.'
	Confirm_COMATTRIB[ 3 ] = 'Confirm'
	Confirm_COMATTRIB[ 4 ] = 'String'
	* Confirm_COMATTRIB[ 5 ] = 0

	* Confirm
	* Devuelve un número con el resultado de la consulta al usuario con un messagebox.
	* Encapsulates a confirmation messagebox.
	Function Confirm ( tcText As String, tcCaption As String, tcWavFile As String ) As Number HelpString 'Devuelve un número con el resultado de la consulta al usuario con un messagebox.'
		*!* Program: Confirm
		*!* Author: M.Salías
		*!* Date: 05/28/03 11:01:22 AM
		*!* Copyright:
		*!* Description: Encapsulates a confirmation messagebox
		*!* Revision Information:

		Local lLRet As Boolean, ;
			lcCaption As String, ;
			lnRet As Number, ;
			loErr As Exception

		Try
			If Empty ( m.tcCaption )
				If Type ( '_Screen.oApp.cAppName' ) == 'C'
					lcCaption = _Screen.oApp.cAppName

				Else
					lcCaption = 'Confirme'

				Endif && Type( '_Screen.oApp.cAppName' ) == 'C'

			Else
				lcCaption = m.tcCaption

			Endif && Empty( m.tcCaption )

			Wait Clear
			lnRet = Messagebox ( m.tcText, MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2, m.lcCaption, 10 * 1000 )
			lLRet = ( m.lnRet = IDYES )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcText, tcCaption, tcWavFile
			THROW_EXCEPTION

		Endtry

		Return m.lLRet

	Endfunc && Confirm

	Dimension GetOutputOptions_COMATTRIB[ 5 ]
	GetOutputOptions_COMATTRIB[ 1 ] = 0
	GetOutputOptions_COMATTRIB[ 2 ] = 'Devuelve un objeto con las opciones por default para la salida de un reporte.'
	GetOutputOptions_COMATTRIB[ 3 ] = 'GetOutputOptions'
	GetOutputOptions_COMATTRIB[ 4 ] = 'Object'
	* GetOutputOptions_COMATTRIB[ 5 ] = 0

	* GetOutputOptions
	* Devuelve un objeto con las opciones por default para la salida de un reporte.
	Function GetOutputOptions ( toParam As Object @ ) As Object HelpString 'Devuelve un objeto con las opciones por default para la salida de un reporte.'

		Local lcCommand As String, ;
			lcDefault As String, ;
			lcPDF As String, ;
			lcSalidas As String, ;
			llPDF As Boolean, ;
			lnCopias As Integer, ;
			lnProgramId As Integer, ;
			lnTerminalId As Integer, ;
			lnUserId As Integer, ;
			loErr As Exception, ;
			loOutputOptions As Object, ;
			loPDF As 'PDFCreator.clsPDFCreator'

		Try

			lcCommand = ''
			lcSalidas = ''
			lcDefault = ''
			lnCopias  = 1

			If Vartype ( m.toParam  ) # 'O'
				toParam = Createobject ( 'Empty' )

			Endif && Vartype( m.toParam  ) # 'O'

			Try
				* Verificar que PDFCreator esté Instalado
				loPDF = Createobject ( 'PDFCreator.clsPDFCreator' )
				llPDF = .T.
				lcPDF =  S_PDF + ','

			Catch To loErr
				llPDF = .F.
				lcPDF = ''

			Endtry

			* Opciones por Default
			*!*		TEXT To lcSalidas NoShow TextMerge Pretext 15
			*!*		<<S_IMPRESORA>>,
			*!*		<<S_VISTA_PREVIA>>,
			*!*		<<S_HOJA_DE_CALCULO>>,
			*!*		<<lcPDF>>
			*!*		<<S_PANTALLA>>,
			*!*		<<S_CSV>>,
			*!*		<<S_SDF>>
			*!*		ENDTEXT

			TEXT To lcSalidas Noshow Textmerge Pretext 15
			<<S_IMPRESORA>>,
			<<S_VISTA_PREVIA>>,
			<<lcPDF>>
			<<S_HOJA_DE_CALCULO>>
			ENDTEXT

			If Pemstatus ( toParam, 'cSalidas', 5 )
				lcSalidas = toParam.cSalidas

			Endif && Pemstatus ( toParam, 'cSalidas', 5 )

			If Pemstatus ( toParam, 'cDefault', 5 )
				lcDefault = toParam.cDefault

			Endif && Pemstatus ( toParam, 'cDefault', 5 )

			If Pemstatus ( toParam, 'nCopias', 5 )
				lnCopias = toParam.nCopias

			Endif && Pemstatus ( toParam, 'nCopias', 5 )

			loOutputOptions = Createobject ( 'Empty' )
			AddProperty ( loOutputOptions, 'cSalidas', lcSalidas )
			AddProperty ( loOutputOptions, 'cDefault', lcDefault )
			AddProperty ( loOutputOptions, 'nCopias', lnCopias )
			AddProperty ( loOutputOptions, 'nStatus', 0 )

			If Pemstatus ( toParam, 'ProgarmId', 5 )
				lnProgramId = toParam.ProgarmId

			Endif && Pemstatus ( toParam, 'ProgarmId', 5 )

			If Pemstatus ( toParam, 'UserId', 5 )
				lnUserId = toParam.Userid

			Endif && Pemstatus ( toParam, 'UserId', 5 )

			If Pemstatus ( toParam, 'TerminalId', 5 )
				lnTerminalId = toParam.TerminalId

			Endif && Pemstatus ( toParam, 'TerminalId', 5 )

			* RA 2012-11-10(13:11:02)
			* Acá se obtienen las opciones de salida
			* desde los parametros de listados
			* para un programa determinado y un Usuario/Terminal

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toParam
			THROW_EXCEPTION

		Finally
			loPDF = Null

		Endtry

		Return loOutputOptions

	Endfunc && GetOutputOptions

	Dimension GetRGB_COMATTRIB[ 5 ]
	GetRGB_COMATTRIB[ 1 ] = 0
	GetRGB_COMATTRIB[ 2 ] = 'Devuelve el valor númerico de la componente de color del color dado.'
	GetRGB_COMATTRIB[ 3 ] = 'GetRGB'
	GetRGB_COMATTRIB[ 4 ] = 'Integer'
	* GetRGB_COMATTRIB[ 5 ] = 0

	* GetRGB
	* Devuelve el valor númerico de la componente de color del color dado.
	Function GetRGB ( tnRGB As Integer, tcC As Character ) As Integer HelpString 'Devuelve el valor númerico de la componente de color del color dado.'

		Local lnMod As Integer, ;
			lnReturn As Integer, ;
			loErr As Exception

		Try

			tcC = Upper ( tcC )
			* If ! Inlist( Upper( tcC ), "R", "G", "B" )  Or tnRGB < 0  Or tnRGB > ( 255 * 256 * 256 )
			If ! tcC $ 'RGB' Or tnRGB < 0  Or tnRGB > MAX_COLORS
				lnReturn = -1

			Else
				* lnBlue = Int( tnRGB  / 65536 )
				lnMod = Mod ( tnRGB, 65536 )
				* lnGreen = Int( lnMod / 256 )
				* lnRed = Mod( lnMod, 256 )

				Do Case
					Case tcC == 'R'
						* lnReturn = lnRed
						lnReturn = Mod ( lnMod, 256 )

					Case tcC == 'G'
						* lnReturn = lnGreen
						lnReturn = Int ( lnMod / 256 )

					Case tcC == 'B'
						* lnReturn = lnBlue
						lnReturn = Int ( tnRGB  / 65536 )

				Endcase

			Endif && ! tcC $ 'RGB' Or tnRGB < 0  Or tnRGB > MAX_COLORS

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnRGB, tcC
			THROW_EXCEPTION

		Endtry
		Return lnReturn

	Endfunc && GetRGB

	Dimension Inform_COMATTRIB[ 5 ]
	Inform_COMATTRIB[ 1 ] = 0
	Inform_COMATTRIB[ 2 ] = 'Encapsula un mensaje al usuario.'
	Inform_COMATTRIB[ 3 ] = 'Inform'
	Inform_COMATTRIB[ 4 ] = 'Void'
	* Inform_COMATTRIB[ 5 ] = 0

	* Inform
	* Encapsula un mensaje al usuario.
	Procedure Inform ( tcText As String, tcCaption As String, tnSeconds As Integer ) As void HelpString 'Encapsula un mensaje al usuario.'
		Local lcCaption As String, ;
			loErr As Exception

		Try
			If Empty ( m.tcCaption )
				If Type ( '_Screen.oApp.cAppName' ) == 'C'
					lcCaption = _Screen.oApp.cAppName

				Else
					lcCaption = 'Información'

				Endif && Type( '_Screen.oApp.cAppName' ) == 'C'

			Else
				lcCaption = m.tcCaption

			Endif && Empty( m.tcCaption )

			If Empty ( m.tnSeconds )
				tnSeconds = 0

			Endif && Empty( m.tnSeconds )

			Do Case
				Case m.tnSeconds < 0
					tnSeconds = 0

				Case m.tnSeconds = 0
					tnSeconds = 10

				Otherwise

			Endcase

			Wait Clear
			Messagebox ( m.tcText, MB_ICONINFORMATION, m.lcCaption, m.tnSeconds * 1000 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcText, tcCaption, tnSeconds
			THROW_EXCEPTION

		Endtry

	Endproc && Inform

	Dimension LaunchForm_COMATTRIB[ 5 ]
	LaunchForm_COMATTRIB[ 1 ] = 0
	LaunchForm_COMATTRIB[ 2 ] = 'Devuele el valor de retorno del formulario.'
	LaunchForm_COMATTRIB[ 3 ] = 'LaunchForm'
	LaunchForm_COMATTRIB[ 4 ] = 'Variant'
	* LaunchForm_COMATTRIB[ 5 ] = 0

	* LaunchForm
	* Devuele el valor de retorno del formulario.
	Function LaunchForm ( tcFormKeyName As String, toParameters As Object, tlReturn As Boolean ) As Variant HelpString 'Devuele el valor de retorno del formulario.'

		Local lcCommand As String, ;
			lcFormName As String, ;
			lcParameters As String, ;
			lcToClause As String, ;
			loErr As Exception, ;
			loForm As Object, ;
			lvReturn As Variant

		Try
			If Vartype ( toParameters ) == 'O'
				lcParameters = 'With toParameters'

			Else && Vartype( toParameters ) == 'O'
				lcParameters = ''

			Endif && Vartype( toParameters ) == 'O'

			If tlReturn
				lcToClause = 'To lvReturn'

			Else && tlReturn
				lcToClause = ''
				lvReturn   = .F.

			Endif && tlReturn

			* lcFormName = ''
			lcFormName = tcFormKeyName
			* TODO: DAE 2013-07-09(19:12:34) No esta definido la coleccion de formularios a nivel FW.
			*!*	loColForms = NewColForms()
			*!*	loForm = loColForms.GetItem( tcFormKeyName )
			*!*	If Vartype( loForm ) == 'O'
			*!*		lcFormName = Addbs( loForm.cFolder ) + loForm.Name + '.' + loForm.cExt

			*!*	Endif

			*!* i = loColForms.GetKey( Lower( tcFormKeyName ) )

			*!* If ! Empty( i )
			*!* 	loForm = loColForms.Item( i )
			*!*		lcFormName = Addbs( loForm.cFolder ) + loForm.Name + "." + loForm.cExt

			*!* Endif && ! Empty( i )

			If Empty ( lcFormName )
				Error 'Falta definir el Formulario ' + tcFormKeyName

			Endif && Empty( lcFormName )

			TEXT To lcCommand Noshow Textmerge Pretext 15
				Do Form '<<lcFormName>>' <<lcParameters>> <<lcToClause>>

			ENDTEXT

			&lcCommand.

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFormKeyName, toParameters, tlReturn
			THROW_EXCEPTION

		Finally
			loForm     = Null
			loColForms = Null

		Endtry

		Return lvReturn

	Endfunc && LaunchForm

	Dimension NoHabilitada_COMATTRIB[ 5 ]
	NoHabilitada_COMATTRIB[ 1 ] = 0
	NoHabilitada_COMATTRIB[ 2 ] = 'Muestra al usuario un mensaje con la leyenda "Opción no habilitada."'
	NoHabilitada_COMATTRIB[ 3 ] = 'NoHabilitada'
	NoHabilitada_COMATTRIB[ 4 ] = 'Void'
	* NoHabilitada_COMATTRIB[ 5 ] = 0

	* NoHabilitada
	* Muestra al usuario un mensaje con la leyenda "Opción no habilitada."
	Procedure NoHabilitada() As void HelpString 'Muestra al usuario un mensaje con la leyenda "Opción no habilitada."'

		This.Warning ( 'Opción no habilitada.' )

	Endproc && NoHabilitada

	Dimension PrintReport_COMATTRIB[ 5 ]
	PrintReport_COMATTRIB[ 1 ] = 0
	PrintReport_COMATTRIB[ 2 ] = 'Lanza un reporte y lo exporta, imprime o muestra por pantalla.'
	PrintReport_COMATTRIB[ 3 ] = 'PrintReport'
	PrintReport_COMATTRIB[ 4 ] = 'Boolean'
	* PrintReport_COMATTRIB[ 5 ] = 0

	* PrintReport
	* Lanza un reporte y lo exporta, imprime o muestra por pantalla.
	Function PrintReport ( tcReport As String, tnMode As Integer, tnCopies As Integer, tcAlias As String, tlForcePrinter As Boolean ) As Boolean HelpString 'Lanza un reporte y lo exporta, imprime o muestra por pantalla.'

		Local lcAlias As String, ;
			lcDirectory As String, ;
			lcExtension As String, ;
			lcFileName As String, ;
			lcPrinter As String, ;
			lcTarget As String, ;
			llDone As Boolean, ;
			lnCopy As Integer, ;
			loErr As Object

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Vista previa, impresión o exportación de un reporte
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Lunes 31 de Julio de 2006 (20:26:54)
				 *:ModiSummary:
				 R/0001 -
				 *:Parameters:
				 tcReport		Nombre del reporte
				 tnMode			Modo
				 tnCopies		Cantidad de copias
				 tcAlias		Alias
				 tlForcePrinter	TRUE para forzar una impresora específica (no pregunta)
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


		tnMode   = Iif ( Empty ( tnMode   ), PR_PRINT, tnMode   )
		tnCopies = Iif ( Empty ( tnCopies ), 1, tnCopies )
		llDone   = .F.

		Try

			If tnMode == PR_EXPORT
				lcFileName = Putfile ( 'Archivo', 'C:\', 'XLS;DBF;TXT' )

				If Empty ( lcFileName )
					* Proceso Cancelado

				Else && Empty ( lcFileName )
					lcFileName = "'" + lcFileName + "'"

					lcExtension = Upper ( Justext ( lcFileName ) )

					Select ( Iif ( Empty ( tcAlias ), Alias(), tcAlias ) )

					Wait 'Exportando...' Window Nowait

					Do Case
						Case lcExtension == 'XLS'
							Copy To ( &lcFileName ) Type Xl5

						Case lcExtension == 'DBF'
							Copy To ( &lcFileName. ) Type Fox2x

						Otherwise
							Copy To ( &lcFileName. ) Delimited

					Endcase

					Wait Clear

					llDone = .T.

				Endif && Empty ( lcFileName )

			Else && tnMode == PR_EXPORT
				lcPrinter = ''

				If tnMode # PR_PRINT Or tlForcePrinter
					* Imprime directamente en la impresora predeterminada

				Else
					lcPrinter = 'prompt'

				Endif

				If Empty ( tcReport )
					Error 'Falta definir el nombre del reporte'

				Else
					* Esta variable privada puede usarse desde funciones externas
					Private pnCopy As Integer

					lcTarget = Iif ( tnMode = PR_PREVIEW, 'preview', 'to printer prompt' )
					lnCopy   = 1
					lcAlias  = Iif ( Empty ( tcAlias ), Alias(), tcAlias )

					For lnCopy = 1 To tnCopies
						pnCopy      = lnCopy
						lcDirectory = Sys(5) + Curdir()
						m.Io.AddPath ( lcDirectory )

						Select ( lcAlias )
						Report Form ( tcReport ) &lcTarget Noconsole Nodialog

						Cd ( lcDirectory )

					Next

					llDone = .T.

				Endif

			Endif && tnMode == PR_EXPORT

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcReport, tnMode, tnCopies, tcAlias, tlForcePrinter
			THROW_EXCEPTION

		Endtry

		Return llDone

	Endfunc && PrintReport

	Dimension ResizeWindow_COMATTRIB[ 5 ]
	ResizeWindow_COMATTRIB[ 1 ] = 0
	ResizeWindow_COMATTRIB[ 2 ] = 'Cambia las dimensiones de una pantalla.'
	ResizeWindow_COMATTRIB[ 3 ] = 'ResizeWindow'
	ResizeWindow_COMATTRIB[ 4 ] = 'Void '
	* ResizeWindow_COMATTRIB[ 5 ] = 0

	* ResizeWindow
	* Cambia las dimensiones de una pantalla.
	Procedure ResizeWindow ( tnRows As Integer, tnCols As Integer ) As void HelpString 'Cambia las dimensiones de una pantalla.'

		Local liIdx As Integer, ;
			loErr As Object, ;
			loForm As Form

		Try

*!*				loForm = _Screen.ActiveForm
*!*				If ! Inlist ( Upper ( loForm.Name ), 'DISPLAYWINDOW', 'DISPLAYFORM', 'FRMSAVESCREEN' )
*!*					For liIdx = 1 To _Screen.FormCount
*!*						loForm = _Screen.Forms[ liIdx ]
*!*						If Inlist ( Upper ( loForm.Name ), 'DISPLAYWINDOW', 'DISPLAYFORM', 'FRMSAVESCREEN' )
*!*							Exit

*!*						Endif

*!*					Endfor

*!*				EndIf
			
			loForm = GetActiveForm() 

			loForm.nRows = tnRows
			loForm.nCols = tnCols

			loForm.AutoSize()

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnRows, tnCols
			THROW_EXCEPTION

		Finally
			loForm = Null

		Endtry

	Endproc && ResizeWindow

	Dimension Stop_COMATTRIB[ 5 ]
	Stop_COMATTRIB[ 1 ] = 0
	Stop_COMATTRIB[ 2 ] = 'Muestra un mensaje de advertencia al usuario.'
	Stop_COMATTRIB[ 3 ] = 'Stop'
	Stop_COMATTRIB[ 4 ] = 'Void'
	* Stop_COMATTRIB[ 5 ] = 0

	* Stop
	* Muestra un mensaje de advertencia al usuario.
	* Encapsulates a stop messagebox.
	Procedure Stop ( tcText As String, tcCaption As String  ) As void HelpString 'Muestra un mensaje de advertencia al usuario.'
		*!* Program: Stop
		*!* Author: R.Rovira
		*!* Date: 06/22/03  6:06:22 PM
		*!* Copyright:
		*!* Description: Encapsulates a stop messagebox
		*!* Revision Information:

		Local lcCaption As String, ;
			lnDelay As Integer, ;
			loErr As Exception

		Try
			If Empty ( m.tcCaption )
				If Type ( '_Screen.oApp.cAppName' ) == 'C'
					lcCaption = _Screen.oApp.cAppName

				Else && Type( '_Screen.oApp.cAppName' ) == 'C'
					lcCaption = 'Error grave'

				Endif && Type( '_Screen.oApp.cAppName' ) == 'C'

			Else
				lcCaption = m.tcCaption

			Endif && Empty( m.tcCaption )

			If Type ( '_Screen.oApp.lDebugMode' ) == 'L' And _Screen.oApp.lDebugMode
				lnDelay = 0

			Else
				lnDelay = 15 * 1000

			Endif && Type( '_Screen.oApp.lDebugMode' ) == 'L' And _Screen.oApp.lDebugMode

			Wait Clear

			Messagebox ( m.tcText, MB_ICONSTOP, m.lcCaption, m.lnDelay )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcText, tcCaption
			THROW_EXCEPTION

		Endtry

	Endproc && Stop

	Dimension TryLaunchForm_COMATTRIB[ 5 ]
	TryLaunchForm_COMATTRIB[ 1 ] = 0
	TryLaunchForm_COMATTRIB[ 2 ] = 'Intenta lanzar un formulario.'
	TryLaunchForm_COMATTRIB[ 3 ] = 'TryLaunchForm'
	TryLaunchForm_COMATTRIB[ 4 ] = 'Void'
	* TryLaunchForm_COMATTRIB[ 5 ] = 0

	* TryLaunchForm
	* Intenta lanzar un formulario.
	Procedure TryLaunchForm ( tcFormKeyName As String, toParameters As Object, tlReturn As Boolean ) As void HelpString 'Intenta lanzar un formulario.'

		Local loErr As Object
		Try

			This.LaunchForm ( tcFormKeyName, toParameters, tlReturn )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcFormKeyName, toParameters, tlReturn

		Endtry

	Endproc && TryLaunchForm

	Dimension Warning_COMATTRIB[ 5 ]
	Warning_COMATTRIB[ 1 ] = 0
	Warning_COMATTRIB[ 2 ] = 'Muestra un mensaje de advertencia al usuario.'
	Warning_COMATTRIB[ 3 ] = 'Warning'
	Warning_COMATTRIB[ 4 ] = 'Void'
	* Warning_COMATTRIB[ 5 ] = 0

	* Warning
	* Muestra un mensaje de advertencia al usuario.
	* Encapsulates a warning messagebox
	Procedure Warning ( tcText As String, tcCaption As String, tnSeconds As Integer ) As void HelpString 'Muestra un mensaje de advertencia al usuario.'

		*!* Program: Warning
		*!* Author: M.Salías
		*!* Date: 05/28/03 10:49:22 AM
		*!* Copyright:
		*!* Description: Encapsulates a warning messagebox
		*!* Revision Information:

		Local lcCaption As String, ;
			loErr As Exception

		Try

			If Empty ( m.tcCaption )
				If Type ( '_Screen.oApp.cAppName' ) == 'C'
					lcCaption = _Screen.oApp.cAppName

				Else
					lcCaption = 'Advertencia'

				Endif && Type( '_Screen.oApp.cAppName' ) == 'C'

			Else
				lcCaption = m.tcCaption

			Endif && Empty( m.tcCaption )

			If Empty ( m.tnSeconds )
				tnSeconds = 0

			Endif && Empty( m.tnSeconds )

			Do Case
				Case m.tnSeconds < 0
					tnSeconds = 0

				Case m.tnSeconds = 0
					tnSeconds = 10

				Otherwise

			Endcase

			Wait Clear
			Messagebox ( m.tcText, MB_ICONEXCLAMATION, m.lcCaption, m.tnSeconds * 1000 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcText, tcCaption, tnSeconds
			THROW_EXCEPTION

		Endtry

	Endproc && Warning

Enddefine && GUINameSpace