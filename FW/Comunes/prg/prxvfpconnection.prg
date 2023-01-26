#Define TYPE_TEXT 0
#Define TYPE_HEADER_IN 1
#Define TYPE_HEADER_OUT 2
#Define TYPE_DATA_IN 3
#Define TYPE_DATA_OUT 4
#Define TYPE_SSL_DATA_IN 5
#Define TYPE_SSL_DATA_OUT 6
#Define TYPE_END 7

#INCLUDE "FW\Comunes\Include\Praxis.h"


Local loVFPConn As PrxVFPConnection Of "V:\Clipper2fox\Fw\Comunes\Prg\Prxvfpconnection.prg"
Try

	Set Library To "fw\Comunes\Fll\VfpConnection.fll"

	*!*		loVFPConn = Newobject( "PrxVFPConnection", "Fw\Comunes\Prg\Prxvfpconnection.prg" )
	*!*		loVFPConn.cSourceURL = "http://dl.dropbox.com/u/6073176/Instaladores/Mac Address Changer.rar"
	*!*		loVFPConn.cDestination = "D:\Users\All Users\Downloads\Mac Address Changer.rar"

	*!*		loVFPConn.HTTPGet()

	lcDestination = "s:\Fenix\Ejecutable\Descarga\Pueba.Exe"

	loVFPConn = Newobject( "PrxVFPConnection", "Fw\Comunes\Prg\Prxvfpconnection.prg" )
	
	
	
	*loVFPConn.cSourceURL = "http://downloadwww21.adrive.com/public/view/7yt5Sn/prGesVen.exe"
	*loVFPConn.cSourceURL = "https://dl.dropboxusercontent.com/s/e47z3rxp05r8qc7/prGesVen.exe"
	*loVFPConn.cSourceURL = "http://dl.dropboxusercontent.com/u/9937378/Fenix/Ejecutables/prccacre.exe"
	loVFPConn.cSourceURL = "https://dl.dropboxusercontent.com/u/6073176/Pyme/Contable.exe"
	loVFPConn.cSourceURL = "https://dl.dropboxusercontent.com/s/e47z3rxp05r8qc7/Fenix/Ejecutables/prGesVen.exe"
	loVFPConn.cSourceURL = "https://www.dropbox.com/sh/2xw3q8zndbj6js0/AABpMJbAqIcJSFbM19r_m63ia"
	loVFPConn.cSourceURL = "http://dl.dropboxusercontent.com/s/7mqaldsez06uxc4/prTraArc.exe"

	
	
	
	*loVFPConn.cSourceURL = "http://dl.dropbox.com/u/9937378/Fenix/Ejecutables/prccacre.exe"
	*loVFPConn.cSourceURL = "http://dl.dropboxusercontent.com/u/9937378/Fenix/Ejecutables/prccacre.exe"

	loVFPConn.cDestination = lcDestination
	loVFPConn.cMessage = "Descargando Módulo Acreedores"
	
	Set Step On 

	llOk = loVFPConn.HTTPGet()

	If !llOk

		TEXT To lcMsg NoShow TextMerge Pretext 15
		No se pudo descargar el módulo Acreedores
		ENDTEXT

		Warning( lcMsg, "Descargando Archivos" )

	Endif



Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )

Finally
	loVFPConn = Null
	Set Library To

Endtry


*!* ///////////////////////////////////////////////////////
*!* Class.........: PrxVFPConnection
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...: Descarga archivos de una URL
*!* Date..........: Jueves 5 de Abril de 2012 (09:46:15)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class PrxVFPConnection As Session

	#If .F.
		Local This As PrxVFPConnection Of "V:\Clipper2fox\Fw\Comunes\Prg\Prxvfpconnection.prg"
	#Endif

	* The URL to the file you wish to download
	cSourceURL = ""

	* The full path and file name where you want the source file saved.
	cDestination = ""

	* Mensaje que se muestra en la barra de progreso
	cMessage = ""

	* Default es 10 segundos.
	* Cuanto mayor es este número, mayor es el tamaño del archivo que se puede subir o bajar
	nSetResponseTimeout = 60000

	* Guarda informacion de estado
	cTraceStatus = ""


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="httpget" type="method" display="HTTPGet" />] + ;
		[<memberdata name="cdestination" type="property" display="cDestination" />] + ;
		[<memberdata name="csourceurl" type="property" display="cSourceURL" />] + ;
		[<memberdata name="progressbar" type="method" display="ProgressBar" />] + ;
		[<memberdata name="tracestatus" type="method" display="TraceStatus" />] + ;
		[<memberdata name="cmessage" type="property" display="cMessage" />] + ;
		[<memberdata name="nsetresponsetimeout" type="property" display="nSetResponseTimeout" />] + ;
		[<memberdata name="ctracestatus" type="property" display="cTraceStatus" />] + ;
		[</VFPData>]

	*[<memberdata name="init" type="method" display="Init" />] + ;

	*
	*
	Procedure Init(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			If !Pemstatus( _Screen, "oVFPConnection", 5 )
				AddProperty( _Screen, "oVFPConnection", Null )
			Endif

			If Isnull( _Screen.oVFPConnection )
				_Screen.oVFPConnection = This
			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Init

	*
	*
	Procedure Destroy(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			If Pemstatus( _Screen, "oVFPConnection", 5 )
				AddProperty( _Screen, "oVFPConnection", Null )
				Removeproperty( _Screen, "oVFPConnection" )
			Endif

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && Destroy


	*
	*
	Procedure HTTPGet(  ) As Void
		Local lcCommand As String
		Local llOk As Boolean
		Local lcMensaje As String

		Try

			lcCommand = ""
			llOk = .F.

			=SetResponseTimeout( This.nSetResponseTimeout )

			This.cSourceURL = Strtran( This.cSourceURL, "https://", "http://" )

			TEXT To lcCommand NoShow TextMerge Pretext 15
			llOk = HTTPGet( '<<This.cSourceURL>>',
							'<<This.cDestination>>',
							'VFPConnProgressBar( "<<This.cMessage>>" )' )
			ENDTEXT

			&lcCommand


		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

		Return llOk

	Endproc && HTTPGet



	*
	* Callback from the FLL - can be used to track operation progress
	Procedure ProgressBar( tcMessage,;
			tnConnectBytesSoFar,;
			tnConnectTotalBytes ) As Void

		Local lcCommand As String

		Try

			lcCommand = ""
			
			lnPercent = Round( 100 * tnConnectBytesSoFar / tnConnectTotalBytes, 2 )
			
			*Wait WINDOW Nowait NoClear "Descargando " + tcMessage + " ( " + Transform( lnPercent, "999.99" ) + " )"

			* RA 2013-04-19(19:56:15)
			* Si se ejecuta desde un formulario, puede capturase esta informacion con:
			* BindEvent( loVFPConn, "ProgressBar", Thisform, "ProgressBar" )

		Catch To oErr
			Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

			loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
			loError.cRemark = lcCommand
			loError.Process( oErr )
			Throw loError

		Finally

		Endtry

	Endproc && ProgressBar



	*
	* Callback from the FLL - used to provide a detailed trace of the operation
	Procedure TraceStatus(  ) As Void
		Local lcCommand As String
		Local lcDataType As String

		Try

			lcCommand = ""

			Do Case
				Case m.nTraceDataType = TYPE_TEXT
					lcDataType = "STATUS:"

				Case m.nTraceDataType = TYPE_HEADER_IN
					lcDataType = "<Recieve Header: "

				Case m.nTraceDataType = TYPE_HEADER_OUT
					lcDataType = ">Send Header: "

				Case m.nTraceDataType = TYPE_DATA_IN
					lcDataType = "<Recieve Data: "

				Case m.nTraceDataType = TYPE_DATA_OUT
					lcDataType = ">SEND DATA: "

				Case m.nTraceDataType = TYPE_SSL_DATA_IN
					lcDataType = "<Recieve SSL Data: "

				Case m.nTraceDataType = TYPE_SSL_DATA_OUT
					lcDataType = ">Send SSL Data: "

				Case m.nTraceDataType = TYPE_END
					lcDataType = "End: "

				Otherwise
					lcDataType = "UNKNOWN: "

			Endcase

			This.cTraceStatus = This.cTraceStatus + lcDataType + m.cTraceData + CRLF

		Catch To oErr

		Finally

		Endtry

	Endproc && TraceStatus

Enddefine
*!*
*!* END DEFINE
*!* Class.........: PrxVFPConnection
*!*
*!* ///////////////////////////////////////////////////////




*
*
Procedure VFPConnProgressBar( tcMessage As String ) As Void
	Local lcCommand As String

	Local lnPercent As Number

	Try

		lcCommand = ""

		Raiseevent( _Screen.oVFPConnection,;
			"ProgressBar",;
			tcMessage,;
			m.nConnectBytesSoFar,;
			m.nConnectTotalBytes )

		*!*			_Screen.oVFPConnection.ProgressBar( tcMessage,;
		*!*				m.nConnectBytesSoFar,;
		*!*				m.nConnectTotalBytes )


	Catch To oErr

	Finally

	Endtry


Endproc && VFPConnProgressBar