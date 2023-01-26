#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure LogSelectCommand( cCommand As String,;
	lForce as Boolean ) As VOID 
	Local lcCommand As String,;
		lcMsg As String,;
		lcDebugSQL As String
	Local i As Integer

	Local Array laStack[ 1 ]

	Try

		lcCommand = ""
		lcMsg = "" 

		If FileExist( "lDebug.tag" ) Or lForce

			i = Astackinfo( laStack ) - 1
			
			Try
				TEXT To lcMsg NoShow TextMerge Pretext 03
				*<<Replicate( "-", 30 )>>
				*<<Datetime()>>

				*Programa: <<laStack[ i, 4 ]>>
				*Método:   <<laStack[ i, 3 ]>>
				*Linea:    <<laStack[ i, 5 ]>>

				*Set Date <<Set("Date")>>
				*Set Century <<Set("Century")>>
				*Set Deleted <<Set("Deleted")>>

				*<<Replicate( "-", 30 )>>
				ENDTEXT

			Catch To oErr

			Finally

			EndTry


			lcDebugSQL = Strtran( cCommand, ",", ",;" + CRLF )
			lcDebugSQL = Strtran( lcDebugSQL, " From ",  ";" + CRLF + "From ")
			lcDebugSQL = Strtran( lcDebugSQL, " Left ",  ";" + CRLF + "Left ")
			lcDebugSQL = Strtran( lcDebugSQL, " Right ", ";" + CRLF + "Right ")
			lcDebugSQL = Strtran( lcDebugSQL, " Inner ", ";" + CRLF + "Inner ")
			lcDebugSQL = Strtran( lcDebugSQL, " Where ", ";" + CRLF + "Where ")
			lcDebugSQL = Strtran( lcDebugSQL, " Order ", ";" + CRLF + "Order ")


			Strtofile( lcMsg + CRLF + lcDebugSQL + CRLF, "SelectCommand.prg", 1 )
			Strtofile( "*"+Replicate( "/", 60 ) + CRLF, "SelectCommand.prg", 1 )
		Endif


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry


Endproc && LogSelectCommand
