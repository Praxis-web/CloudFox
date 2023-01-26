#INCLUDE "FW\Comunes\Include\Praxis.h"

Local lcCommand As String, lcMsg As String

Try

	lcCommand = ""
	Consulta()

	Messagebox( "Terminado" )

Catch To loErr

	Do While Vartype( loErr.UserValue ) == "O"
		loErr = loErr.UserValue
	Enddo

	lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  METODO   ] " + loErr.Procedure + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  LINEA Nº ] " + Transform(loErr.Lineno) + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  COMANDO  ] " + loErr.LineContents + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  ERROR    ] " + Transform(loErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  MENSAJE  ] " + loErr.Message + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  DETALLE  ] " + loErr.Details + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )

	Messagebox( lcMsg, 16, "Error" )


Finally


Endtry

*
*
Procedure Consulta(  ) As Void
	Local lcCommand As String, lcMsg As String
	Local loTL  As TraceLog Of "FW\Comunes\prg\TraceLog.prg"

	Try

		lcCommand = ""
		loTL = Newobject( "TraceLog", "FW\Comunes\prg\TraceLog.prg" )
		loTL.Start()

		For i = 1 To 10

			Inkey( .3 )

			TEXT To lcMsg NoShow TextMerge Pretext 03
			Log Nº <<Transform( i )>>
			ENDTEXT

			Wait Window Nowait Noclear lcMsg

			loTL.Update( lcMsg )

		Endfor

		loTL.Stop()

	Catch To loErr

		Do While Vartype( loErr.UserValue ) == "O"
			loErr = loErr.UserValue
		Enddo

		lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  METODO   ] " + loErr.Procedure + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  LINEA Nº ] " + Transform(loErr.Lineno) + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  COMANDO  ] " + loErr.LineContents + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  ERROR    ] " + Transform(loErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  MENSAJE  ] " + loErr.Message + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  DETALLE  ] " + loErr.Details + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
		lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )

		Messagebox( lcMsg, 16, "Error" )


	Finally
		loTL = Null
		Wait Clear


	Endtry

Endproc && Consulta




*!* ///////////////////////////////////////////////////////
*!* Class.........: TraceLog
*!* Description...:
*!* Date..........: Martes 19 de Diciembre de 2017 (15:07:30)
*!*
*!*

Define Class TraceLog As Custom

	#If .F.
		Local This As TraceLog Of "FW\Comunes\prg\TraceLog.prg"
	#Endif

	* Nombre del archivo de log
	cFileName = "Trace.Log"

	* Guarda la hora en miliisegundos
	nStart = 0

	* Hora en milisegundos de la última vez
	nLastLog = 0


	lActivo = .T.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cfilename" type="property" display="cFileName" />] + ;
		[<memberdata name="nstart" type="property" display="nStart" />] + ;
		[<memberdata name="nlastlog" type="property" display="nLastLog" />] + ;
		[<memberdata name="start" type="method" display="Start" />] + ;
		[<memberdata name="update" type="method" display="Update" />] + ;
		[<memberdata name="stop" type="method" display="Stop" />] + ;
		[<memberdata name="lactivo" type="property" display="lActivo" />] + ;
		[</VFPData>]


	*
	*
	Procedure Start( cMsg As String, lAppend As Boolean  ) As Void
		Local lcCommand As String,;
			lcMsg As String

		Try

			lcCommand = ""

			If This.lActivo

				If Empty( cMsg )
					cMsg = ""
				Endif

				TEXT To lcMsg NoShow TextMerge Pretext 03
				<<Datetime()>>
				TraceLog <<Program( Program( -1 ) - 1 )>>
				<<cMsg>>

				ENDTEXT

				This.nStart 	= Seconds()
				This.nLastLog 	= 0

				Strtofile( lcMsg, This.cFileName, Iif( lAppend, 1, 0 ) )

				Try

					Strtofile( lcMsg, Alltrim( DRVA ) + This.cFileName, Iif( lAppend, 1, 0 ) )

				Catch To oErr

				Finally

				Endtry

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Start



	*
	*
	Procedure Update( cMsg As String ) As Void
		Local lcCommand As String,;
			lcMsg As String
		Local lnSeconds As Number,;
			lnLapse As Number

		Try

			lcCommand = ""

			If This.lActivo

				If Empty( cMsg )
					cMsg = ""
				Endif

				lnSeconds = Seconds() - This.nStart
				lnLapse = lnSeconds - This.nLastLog
				This.nLastLog = lnSeconds

				TEXT To lcMsg NoShow TextMerge Pretext 03
				<<lnSeconds>> <<lnLapse>> <<cMsg>>

				ENDTEXT

				Strtofile( lcMsg, This.cFileName, 1 )
				
				Try

					Strtofile( lcMsg, Alltrim( DRVA ) + This.cFileName, 1 )

				Catch To oErr

				Finally

				Endtry


			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Update



	*
	*
	Procedure Stop( cMsg As String ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If This.lActivo

				If Empty( cMsg )
					cMsg = "Stop"
				Endif


				This.Update( cMsg )

				TEXT To lcMsg NoShow TextMerge Pretext 03
				TraceLog <<Program( Program( -1 ) - 1 )>>
				<<Datetime()>>
				---------------------------------------------------------------

				ENDTEXT

				This.nStart 	= 0
				This.nLastLog 	= 0

				Strtofile( lcMsg, This.cFileName, 1 )
				
				Try

					Strtofile( lcMsg, Alltrim( DRVA ) + This.cFileName, 1 )

				Catch To oErr

				Finally

				Endtry
				

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Stop



Enddefine
*!*
*!* END DEFINE
*!* Class.........: TraceLog
*!*
*!* ///////////////////////////////////////////////////////

