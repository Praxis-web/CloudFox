#INCLUDE "FW\Tieradapter\Include\TA.h"


*!* ///////////////////////////////////////////////////////
*!* Procedure.....: PrintReport
*!* Description...: Vista previa, impresión o exportación de un reporte
*!* Date..........: Lunes 31 de Julio de 2006 (20:26:54)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*
*!* tcReport......: 	Nombre del reporte
*!* tnMode........:	Modo
*!* tnCopies......:	Cantidad de copias
*!* tcAlias.......:	Alias
*!* tlForcePrinter:	TRUE para forzar una impresora específica (no pregunta)


Lparameters tcReport As String,;
	tnMode As Integer,;
	tnCopies As Integer,;
	tcAlias As String,;
	tlForcePrinter As Boolean

Local llDone As Boolean

tnMode   = Iif( Empty( tnMode   ), PR_PRINT, tnMode   )
tnCopies = Iif( Empty( tnCopies ), 1, tnCopies )
llDone 	= .F.

Try

	If tnMode = PR_EXPORT

		Local lcFileName As String, lcExtension As String

		lcFileName = Putfile( "Archivo", "C:\", "XLS;DBF;TXT" )

		If Empty( lcFileName )
			* Proceso Cancelado

		Else
			lcFileName = "'" + lcFileName + "'"

			lcExtension = Upper( Justext( lcFileName ) )

			Select ( Iif( Empty( tcAlias ), Alias(), tcAlias ) )

			Wait "Exportando..." Window Nowait

			Do Case
				Case lcExtension = "XLS"
					Copy To ( &lcFileName ) Type Xl5

				Case lcExtension = "DBF"
					Copy To ( &lcFileName ) Type Fox2x

				Otherwise
					Copy To ( &lcFileName ) Delimited

			Endcase

			Wait Clear

			llDone = .T.

		Endif

	Else
		Local lcPrinter
		lcPrinter = ""

		If tnMode <> PR_PRINT Or tlForcePrinter
			* Imprime directamente en la impresora predeterminada

		Else
			lcPrinter = "prompt"

		Endif

		If Empty( tcReport )
			Error "Falta definir el nombre del reporte"

		Else
			Local lcTarget As String,;
				lcAlias As String,;
				lcDirectory As String

			Local lnCopy As Integer

			* Esta variable privada puede usarse desde funciones externas
			Private pnCopy as Integer 

			lcTarget = Iif( tnMode=PR_PREVIEW, "preview", "to printer prompt" )
			lnCopy = 1
			lcAlias = Iif( Empty( tcAlias ), Alias(), tcAlias )


			For lnCopy = 1 To tnCopies

				pnCopy = lnCopy	

				lcDirectory = Sys(5)+Curdir()

				AddPath( lcDirectory )

				Select ( lcAlias )
				Report Form ( tcReport ) &lcTarget Noconsole Nodialog

				Cd ( lcDirectory )
			Next

			llDone = .T.

		EndIf
		
	Endif

Catch To oErr
	Local loError as ErrorHandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = NewObject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )

Finally
	loError = .F.

Endtry

Return llDone
*!*
*!* END PROCEDURE PrintReport
*!*
*!* ///////////////////////////////////////////////////////