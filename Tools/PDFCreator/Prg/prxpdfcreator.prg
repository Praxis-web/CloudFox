* Ejemplo de uso

Local loPDF As PrxPDFCreator Of "Tools\PDFCreator\Prg\prxPDFCreator.prg"
Local Array laCopias[ 4 ]
Local lnCopias As Integer
Local loComp As Collection

Try

	Close Databases All

	lnCopias = 2

	Use V:\Clipper2Fox\Clientes\FE\Dbf\Cabeza Shared In 0
	Use V:\Clipper2Fox\Clientes\FE\Dbf\Detalle Shared In 0
	Xmltocursor( "C:\Fe\FEEmpresa.Cfg", "cEmpresa", 4 + 512 )

	Create Cursor cGlobal ( ;
		CopiaNro C(30) )

	Insert Into cGlobal ( CopiaNro ) Values ( Space( 30 ) )

	Select * From Cabeza Into Cursor cCabeza Readwrite

	loComp = Createobject( "Collection" )

	loComp.Add( "FCA", "1" )
	loComp.Add( "NDA", "2" )
	loComp.Add( "NCA", "3" )
	loComp.Add( "RCA", "4" )
	loComp.Add( "NVA", "5" )
	loComp.Add( "FCB", "6" )
	loComp.Add( "NDB", "7" )
	loComp.Add( "NCB", "8" )
	loComp.Add( "RCB", "9" )
	loComp.Add( "NVB", "10" )
	loComp.Add( "RG3419A", "39" )
	loComp.Add( "RG3419B", "40" )
	loComp.Add( "CVLA", "60" )
	loComp.Add( "CVLB", "61" )
	loComp.Add( "LIQA", "63" )
	loComp.Add( "LIQB", "64" )


	laCopias[ 1 ] = "ORIGINAL"
	laCopias[ 2 ] = "DUPLICADO"
	laCopias[ 3 ] = "TRIPLICADO"
	laCopias[ 4 ] = "COPIA Nº "

	loPDF = Newobject( "PrxPDFCreator", "Tools\PDFCreator\Prg\prxPDFCreator.prg" )

	If loPDF.SetToPDFCreator()

		* Indicar Carpeta donde guardar los PDF
		loPDF.AutoSaveDirectory = "V:\Clipper2Fox\Clientes\FE\Pdf\"

		Select cCabeza
		Locate

		Scan

			Try

				lcCodigoBarras = cEmpresa.Cuit
				lcCodigoBarras = lcCodigoBarras + StrZero( cCabeza.CodigoComp, 2 )
				lcCodigoBarras = lcCodigoBarras + StrZero( cCabeza.PuntoVta, 4 )
				lcCodigoBarras = lcCodigoBarras + cCabeza.CAE
				lcCodigoBarras = lcCodigoBarras + Dtos( cCabeza.CAEVenc )

				Replace CgoBarra With StrToI2of5( lcCodigoBarras ) In cCabeza

			Catch To oErr

			Finally

			Endtry

			Select * ;
				From Detalle ;
				Where Detalle.CompId = cCabeza.CompId ;
				Into Cursor cDetalle ;
				ReadWrite


			* Nombre del archivo a generar
			*loPDF.AutoSaveFileName = Alltrim( cCabeza.DescCompro ) + " " + cCabeza.LetraComp + " " + StrZero( cCabeza.PuntoVta, 4 ) + "-" + StrZero( cCabeza.NumeroComp, 8 )
			i = loComp.GetKey( Transform( cCabeza.CodigoComp ))
			lcComp = ""
			If !Empty( i )
				lcComp = loComp.Item( i ) + " "
			Endif
			loPDF.AutoSaveFileName =  lcComp + StrZero( cCabeza.PuntoVta, 4 ) + "-" + StrZero( cCabeza.NumeroComp, 8 )

			*/ Rutina de impresion

			For i = 1 To lnCopias

				Do Case
					Case Between( i, 1, lnCopias - 1 )
						lcPrintCommand = "NoPageEject NoDialog NoConsole"

					Otherwise
						lcPrintCommand = "NoDialog NoConsole"

				Endcase

				* Nº de Copia
				Select cGlobal
				Locate
				Replace CopiaNro With Iif( i > 4, laCopias[ 4 ] + Transform( i ), laCopias[ i ] )

				Select cDetalle
				Locate

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Report Form "V:\Clipper2Fox\Clientes\FE\Frx\frxFacturaElectronica.frx"
				To Printer <<lcPrintCommand>>
				ENDTEXT

				&lcCommand

			Endfor

			*/ Cerrar Impresion

			loPDF.CloseJob()

			Select cCabeza

		Endscan

		loPDF.CancelPDFCreator()

	Endif


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )
	Throw loError


Finally
	loPDF = Null
	Close Databases All

Endtry

*/ Fin del Ejemplo


*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxPDFCreator
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Wraper sobre el COM de PDFCreator
*!* Date..........: Martes 10 de Mayo de 2011 (19:11:15)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxPDFCreator As Session

	#If .F.
		Local This As PrxPDFCreator Of "Tools\PDFCreator\Prg\prxPDFCreator.prg"
	#Endif

	* Referencia al objeto COM
	oPDF = Null

	nUseAutoSave 					= 0
	nUseAutoSaveDirectory 			= 0
	nAutoSaveFormat 				= 0
	cDefaultPrinter 				= ""
	cAutoSaveDirectory 				= ""
	cAutoSaveFileName 				= ""
	AutoSaveDirectory 				= ""
	AutoSaveFileName 				= ""
	oEventHandler 					= Null
	lOnDestroy 						= .F.

	* Abre el archivo con el programa predeterminado
	AutosaveStartStandardProgram 	= 0
	nAutosaveStartStandardProgram 	= 0


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="nautosavestartstandardprogram" type="property" display="nAutosaveStartStandardProgram" />] + ;
		[<memberdata name="autosavestartstandardprogram_assign" type="method" display="AutosaveStartStandardProgram_Assign" />] + ;
		[<memberdata name="autosavestartstandardprogram" type="property" display="AutosaveStartStandardProgram" />] + ;
		[<memberdata name="nuseautosave" type="property" display="nUseAutoSave" />] + ;
		[<memberdata name="nuseautosavedirectory" type="property" display="nUseAutoSaveDirectory" />] + ;
		[<memberdata name="nautosaveformat" type="property" display="nAutoSaveFormat" />] + ;
		[<memberdata name="cdefaultprinter" type="property" display="cDefaultPrinter" />] + ;
		[<memberdata name="cautosavedirectory" type="property" display="cAutoSaveDirectory" />] + ;
		[<memberdata name="autosavedirectory" type="property" display="AutoSaveDirectory" />] + ;
		[<memberdata name="autosavedirectory_assign" type="method" display="AutosaveDirectory_Assign" />] + ;
		[<memberdata name="cautosavefilename" type="property" display="cAutoSaveFileName" />] + ;
		[<memberdata name="autosavefilename" type="property" display="AutoSaveFileName" />] + ;
		[<memberdata name="autosavefilename_assign" type="method" display="AutosaveFilename_Assign" />] + ;
		[<memberdata name="opdf" type="property" display="oPDF" />] + ;
		[<memberdata name="opdf_access" type="method" display="oPDF_Access" />] + ;
		[<memberdata name="settopdfcreator" type="method" display="SetToPDFCreator" />] + ;
		[<memberdata name="cancelpdfcreator" type="method" display="CancelPDFCreator" />] + ;
		[<memberdata name="saveenvironment" type="method" display="SaveEnvironment" />] + ;
		[<memberdata name="restoreenvironment" type="method" display="RestoreEnvironment" />] + ;
		[<memberdata name="oeventhandler" type="property" display="oEventHandler" />] + ;
		[<memberdata name="closejob" type="method" display="CloseJob" />] + ;
		[<memberdata name="londestroy" type="property" display="lOnDestroy" />] + ;
		[</VFPData>]



	*
	* Configura la Impresora hacia PDFCreator
	Procedure SetToPDFCreator(  ) As Boolean;
			HELPSTRING "Configura la Impresora hacia PDFCreator"

		Local llOk As Boolean
		Local loPDF As PDFCreator.clsPDFCreator
		Local loOptions As PDFCreator.clsPDFCreatorOptions

		Try

			llOk 	= .F.
			loPDF 	= This.oPDF

			*-- Syncronize process
			If !Isnull( loPDF ) And loPDF.cStart("/NoProcessingAtStartup")

				This.SaveEnvironment()

				loOptions 	= loPDF.cOptions

				*-- Set Autosave to True
				loOptions.UseAutosave = 1
				loOptions.UseAutosaveDirectory = 1

				*-- Set Format to PDF
				loOptions.AutosaveFormat = 0

				*-- Set Default Printer to PDFCreator
				loPDF.cDefaultPrinter = "PDFCreator"

				Set Printer To Name "PDFCreator"

				*-- Clear Cache
				loPDF.cClearcache()

				*-- Set Print Stop to True
				loPDF.cPrinterStop = .T.

				loPDF.cOptions = loOptions

				*-- Save the values
				loPDF.cSaveOptions()

				This.oEventHandler = Newobject( "prxPDFCreatorStatus", "Tools\Pdfcreator\Prg\Prxpdfcreator.prg" )

				Eventhandler( This.oPDF, This.oEventHandler )

				llOk = .T.

			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			llOk = .F.
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			loPDF 		= Null
			loOptions 	= Null

		Endtry

		Return llOk

	Endproc && SetToPDFCreator



	*
	* Cancela la Impresora PDFCreator
	Procedure CancelPDFCreator(  ) As Void;
			HELPSTRING "Cancela la Impresora PDFCreator"

		Local loPDF As PDFCreator.clsPDFCreator

		Try

			This.RestoreEnvironment()

			loPDF = This.oPDF

			*-- Clear Cache
			loPDF.cClearcache()
			*-- Set Printo Stop to False
			loPDF.cPrinterStop = .F.

			*-- Save the values
			loPDF.cSaveOptions()

			loPDF.cClose()

			* Desacoplar EventHandler
			Eventhandler( This.oPDF, This.oEventHandler, .T. )
			This.oEventHandler = Null


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loPDF = Null
			This.oEventHandler = Null
			This.oPDF = Null

		Endtry

	Endproc && CancelPDFCreator



	*
	* Cierra un trabajo enviado a la impresora
	Procedure CloseJob(  ) As Void;
			HELPSTRING "Cierra un trabajo enviado a la impresora"

		Local loPDF As PDFCreator.clsPDFCreator
		Local loEventHandler As prxPDFCreatorStatus Of "Tools\Pdfcreator\Prg\Prxpdfcreator.prg"
		Local i As Integer

		Try

			Wait Window Nowait "Generando '" + Addbs( This.AutoSaveDirectory ) + This.AutoSaveFileName + ".pdf' ...   "

			loPDF = This.oPDF
			loEventHandler = This.oEventHandler

			loPDF.cPrinterStop = .F.


			i = 0
			Do While ( loPDF.cCountOfPrintjobs <> 1 ) And i < 10
				Inkey(1)
				i = i + 1
			Enddo

			Try
				* RA 2012-11-11(07:59:40)
				* A veces da error de LOEVENTHANDLER is not an object.
				i = 0
				loEventHandler.ReadyState = 0
				Do While ( loEventHandler.ReadyState = 0 ) And i < 10
					Inkey(1)
					i = i + 1
				Enddo

			Catch To loErr
				Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
				loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
				loError.cRemark = lcCommand
				loError.Process ( m.loErr, .F., .T. )
				Throw loError

			Endtry

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loPDF = Null
			loEventHandler = Null
			Wait Clear

		Endtry

	Endproc && CloseJob


	*
	* Guarda el entorno actual
	Procedure SaveEnvironment(  ) As Void;
			HELPSTRING "Guarda el entorno actual"

		Local loPDF As PDFCreator.clsPDFCreator
		Local loOptions As PDFCreator.clsPDFCreatorOptions

		Try

			loPDF 		= This.oPDF
			loOptions 	= loPDF.cOptions

			This.nUseAutoSave          			= loOptions.UseAutosave
			This.nUseAutoSaveDirectory 			= loOptions.UseAutosaveDirectory
			This.nAutoSaveFormat       			= loOptions.AutosaveFormat
			This.cDefaultPrinter       			= Set("Printer",2)
			This.cAutoSaveDirectory    			= loOptions.AutoSaveDirectory
			This.cAutoSaveFileName     			= loOptions.AutoSaveFileName
			This.nAutosaveStartStandardProgram 	= loOptions.AutosaveStartStandardProgram

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loPDF 		= Null
			loOptions 	= Null

		Endtry

	Endproc && SaveEnvironment



	*
	* Restaura el entorno anterior
	Procedure RestoreEnvironment(  ) As Void;
			HELPSTRING "Restaura el entorno anterior"

		Local loPDF As PDFCreator.clsPDFCreator
		Local loOptions As PDFCreator.clsPDFCreatorOptions

		Try

			loPDF 		= This.oPDF
			loOptions 	= loPDF.cOptions

			loOptions.UseAutosave 			= This.nUseAutoSave
			loOptions.UseAutosaveDirectory 	= This.nUseAutoSaveDirectory
			loOptions.AutosaveFormat 		= This.nAutoSaveFormat

			loPDF.cDefaultPrinter  = This.cDefaultPrinter

			Set Printer To Name (This.cDefaultPrinter)

			loOptions.AutoSaveDirectory 			= This.cAutoSaveDirectory
			loOptions.AutoSaveFileName  			= This.cAutoSaveFileName
			loOptions.AutosaveStartStandardProgram 	= This.nAutosaveStartStandardProgram

			loPDF.cOptions = loOptions


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loPDF 		= Null
			loOptions 	= Null

		Endtry

	Endproc && RestoreEnvironment

	*
	* oPDF_Access
	Protected Procedure oPDF_Access()
		Local lnErrorNro As Integer

		Try

			If Vartype( This.oPDF ) # "O" And !This.lOnDestroy
				lnErrorNro = 0

				Try

					This.oPDF = Createobject("PDFCreator.clsPDFCreator")

				Catch To oErr
					lnErrorNro = oErr.ErrorNo
				Finally
				Endtry

				If Vartype( This.oPDF ) # "O"
					Try

						This.oPDF = Createobject("PDFCreatorBeta.PDFCreator")

					Catch To oErr
						lnErrorNro = oErr.ErrorNo
					Finally
					Endtry

				Endif

				If Vartype( This.oPDF ) # "O"
					If lnErrorNro = 1733
						Local lcErrorMessage As String

						TEXT To lcErrorMessage NoShow TextMerge Pretext 03
						Debe instalar PDFCreator para poder generar
						archivos con formato PDF en forma automática.
						Puede descargarlo de
						http://sourceforge.net/projects/pdfcreator/
						ENDTEXT

						Stop( lcErrorMessage )
					Endif

					This.oPDF = Null

				Endif

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry


		Return This.oPDF

	Endproc && oPDF_Access


	Procedure Destroy()
		Try

			This.lOnDestroy = .T.

			If Vartype( This.oPDF ) = "O"
				Try

					This.oPDF.cClose()

				Catch To oErr

				Finally

				Endtry


			Endif

			This.oEventHandler = Null
			This.oPDF = Null


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally

		Endtry

	Endproc

	* AutosaveDirectory_Assign

	Protected Procedure AutosaveDirectory_Assign( uNewValue )

		Local loPDF As PDFCreator.clsPDFCreator
		Local loOptions As PDFCreator.clsPDFCreatorOptions

		Try


			loPDF 		= This.oPDF
			loOptions 	= loPDF.cOptions

			This.AutoSaveDirectory 	= uNewValue
			loOptions.AutoSaveDirectory = uNewValue

			loPDF.cOptions = loOptions

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally
			loPDF 		= Null
			loOptions 	= Null

		Endtry

	Endproc && AutosaveDirectory_Assign


	* AutosaveFilename_Assign

	Protected Procedure AutosaveFilename_Assign( uNewValue )

		Local loPDF As PDFCreator.clsPDFCreator
		Local loOptions As PDFCreator.clsPDFCreatorOptions
		Try


			loPDF 		= This.oPDF
			loOptions 	= loPDF.cOptions

			This.AutoSaveFileName 		= uNewValue
			loOptions.AutoSaveFileName 	= uNewValue

			loPDF.cOptions = loOptions


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally
			loPDF 		= Null
			loOptions 	= Null

		Endtry


	Endproc && AutosaveFilename_Assign


	* AutosaveStartStandardProgram_Assign

	Protected Procedure AutosaveStartStandardProgram_Assign( uNewValue )

		Local loPDF As PDFCreator.clsPDFCreator
		Local loOptions As PDFCreator.clsPDFCreatorOptions

		Try


			loPDF 		= This.oPDF
			loOptions 	= loPDF.cOptions

			This.AutosaveStartStandardProgram 		= uNewValue
			loOptions.AutosaveStartStandardProgram 	= uNewValue

			loPDF.cOptions = loOptions


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )

		Finally
			loPDF 		= Null
			loOptions 	= Null

		Endtry

	Endproc && AutosaveStartStandardProgram_Assign

Enddefine
*!*
*!* END DEFINE
*!* Class.........: PrxPDFCreator
*!*
*!* ///////////////////////////////////////////////////////



*!* ///////////////////////////////////////////////////////
*!* Class.........: prxPDFCreatorStatus
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Event Handler
*!* Date..........: Martes 10 de Mayo de 2011 (19:38:37)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class prxPDFCreatorStatus As Session
	Implements __clsPDFCreator In "PDFCreator.clsPDFCreatorOptions"

	#If .F.
		Local This As prxPDFCreatorStatus Of "Tools\Pdfcreator\Prg\Prxpdfcreator.prg"
	#Endif

	* Indica el Estado
	ReadyState = 0


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="readystate" type="property" display="ReadyState" />] + ;
		[<memberdata name="__clspdfcreator_eready" type="method" display="__clsPDFCreator_eReady" />] + ;
		[<memberdata name="__clspdfcreator_eerror" type="method" display="__clsPDFCreator_eError" />] + ;
		[</VFPData>]


	*
	* Se dispara cuando PDFCreator terminó la tarea
	Procedure __clsPDFCreator_eReady(  ) As Void;
			HELPSTRING "Se dispara cuando PDFCreator terminó la tarea"
		Try

			This.ReadyState = 1

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && __clsPDFCreator_eReady


	*
	* Se produjo un error en el Objeto COM
	Procedure __clsPDFCreator_eError(  ) As Void;
			HELPSTRING "Se produjo un error en el Objeto COM"

		Try


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && __clsPDFCreator_eError

Enddefine
*!*
*!* END DEFINE
*!* Class.........: prxPDFCreatorStatus
*!*
*!* ///////////////////////////////////////////////////////
