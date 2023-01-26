#INCLUDE "FW\Comunes\Include\Praxis.h"

*
* Loguea un mensage de usuario
Procedure Logerror( cErrorMessage As String,;
		nLine As Integer,;
		cDetalle As String,;
		cErrorLogFileName as String ) As String

	Local lcCommand As String,;
	lcProgram as String 
	
	Local lnLine As Integer
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'

	Try

		lcCommand 	= ""
		lcLine 		= ""
		
		If !Empty( cErrorMessage )

			lcProgram = Program( Program(-1) -1 )

			If Empty( nLine ) Or Vartype( nLine ) # "N"
				nLine = 0
			Endif

			lnLine = nLine
			
			If Empty( cDetalle )
				cDetalle = ""
			EndIf

			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )

			loError.cRemark 	= "Generado por LogError"
			loError.Message 	= cErrorMessage
			loError.Procedure 	= lcProgram
			loError.Details 	= cDetalle
			loError.ErrorNo 	= 1098
			loError.Lineno 		= lnLine
			
			loError.GetErrorInformation()
			loError.GetStackInformation()
			loError.GetSystemInformation()
			loError.GetTablesInformation()
			
			loError.Logerror( cErrorLogFileName )

		Endif


	Catch To oErr

	Finally
		loError = Null

	Endtry

Endproc && LogError
