#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\Hasar\Include\Hasar.h"

*
* Parámetros para la Impredora Fiscal HASAR
Procedure ifParame(  ) As Void;
		HELPSTRING "Parámetros para la Impredora Fiscal HASAR"
	Local lcCommand As String
	Local loParame As oParame Of "FW\Hasar\Prg\ifParame.prg"

	Try

		lcCommand = ""
		loParame = NewObject( "oParame", "FW\Hasar\Prg\ifParame.prg" ) 
		loParame.Process() 


	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		loParame = Null 

	Endtry

Endproc && ifParame

*!* ///////////////////////////////////////////////////////
*!* Class.........: oParame
*!* Description...:
*!* Date..........: Jueves 19 de Julio de 2018 (16:58:35)
*!*
*!*

Define Class oParame As prxIngreso Of "Rutinas\Prg\prxIngreso.prg"

	#If .F.
		Local This As oParame Of "FW\Hasar\Prg\ifParame.prg"
	#Endif
	
	lConfirma 	= .T.
	nId 		= 0

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="creararchivo" type="method" display="CrearArchivo" />] + ;
		[<memberdata name="puntodeventa" type="method" display="PuntoDeVenta" />] + ;
		[<memberdata name="modelo" type="method" display="Modelo" />] + ;
		[<memberdata name="puerto" type="method" display="Puerto" />] + ;
		[<memberdata name="nid" type="property" display="nId" />] + ;
		[</VFPData>]

	*
	*
	Procedure Setup(  ) As Void

		Local lcCommand As String
		Local loColMetodos As Metodos Of "V:\Clipper2fox\Rutinas\Prg\Prxingreso.prg"

		Try

			lcCommand = ""

			loColMetodos = This.oColMetodos

			loColMetodos.New( "PuntoDeVenta" )
			loColMetodos.New( "Modelo" )
			loColMetodos.New( "Puerto" )
			
		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError


		Finally
			loColMetodos = Null

		Endtry


		Return

	Endproc && SetUp


	*
	* Abre los archivos necesarios para el proceso
	Procedure AbrirArchivos(  ) As Void;
			HELPSTRING "Abre los archivos necesarios para el proceso"
		Local lcCommand As String

		Try

			lcCommand = ""

			If !FileExist( Addbs( Alltrim( drComun )) + "ar0Hasar.dbf" )
				This.CrearArchivo()
			Endif

			M_Use( 0, Addbs( Alltrim( drComun )) + "ar0Hasar" )


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
	Procedure CrearArchivo(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Create Table <<Addbs( Alltrim( drComun ))>>ar0Hasar Free (
				Id 			I,
				Terminal 	C(30),
				PtoVta 		I,
				Modelo 		I,
				Puerto 		I,
				TS 			T,
				UTS 		T )

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
			Use In Select( "ar0Hasar" )

		Endtry

	Endproc && CrearArchivo



	*
	* Inicializar los datos del registro
	Procedure Inicializar(  ) As Void;
			HELPSTRING "Inicializar los datos del registro"

		Local lcCommand As String,;
			lcTerminal As String

		Local loHasar As HASAR.Fiscal.1


		Try

			lcCommand = ""
			lcTerminal = Upper( Alltrim( Getwordnum( Sys(0), 1, "#" )))

			Locate For Upper( Alltrim( Terminal )) == lcTerminal

			If !Found()
				
				loHasar = NewHasar()

				M_IniAct( 1 )
				Replace Terminal With lcTerminal,;
					PtoVta With loHasar.nPuntoDeVenta,;
					Modelo With loHasar.nModelo,;
					Puerto With loHasar.Puerto
					
				Unlock 	

			Endif

			This.oRegistro = ScatterReg( .F. )

			@ 05, 26 Say This.oRegistro.Terminal
			@ 06, 26 Say This.oRegistro.PtoVta Picture "9999"
			@ 07, 26 Say This.oRegistro.Modelo Picture "9999"
			@ 08, 26 Say This.oRegistro.Puerto Picture "9999"
			
			This.nId = ar0Hasar.Id


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			loHasar = Null 


		Endtry

	Endproc && Inicializar

	*
	* Dibuja la pantalla
	Procedure Pantalla(  ) As Void;
			HELPSTRING "Dibuja la pantalla"

		Local lcCommand As String

		Try

			lcCommand = ""
			S_Clear( 00, 00, This.pnMaxRow, This.pnMaxCol )

			S_TitPro( This.cTituloDelPrograma, FECHAHOY )

			@ 05, 10 Say "Terminal......:"
			@ 06, 10 Say "Punto de Venta:"
			@ 07, 10 Say "Modelo........:"
			@ 08, 10 Say "Puerto........:"

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
	*
	Procedure PuntoDeVenta(  ) As Void
		Local lcCommand As String
		Local lnPtoVta as Integer 

		Try

			lcCommand = ""
			
			lnPtoVta = This.oRegistro.PtoVta  
			
			S_AclNro( 4 )
			@ 06, 26 Get lnPtoVta Picture "9999" Valid I_ValMay( lnPtoVta, 0 )
			Read 
			
			SayMask( 06, 26, lnPtoVta, "9999", 0 ) 

			This.oRegistro.PtoVta = lnPtoVta  
			

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && PuntoDeVenta

	*
	*
	Procedure Modelo(  ) As Void
		Local lcCommand As String
		Local lnModelo as Integer 

		Try

			lcCommand = ""
			
			lnModelo = This.oRegistro.Modelo
			
			S_AclNro( 4 )
			@ 07, 26 Get lnModelo Picture "9999" Valid I_ValMay( lnModelo, 0 )
			Read 
			
			SayMask( 07, 26, lnModelo, "9999", 0 ) 

			This.oRegistro.Modelo = lnModelo

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Modelo

	*
	*
	Procedure Puerto(  ) As Void
		Local lcCommand As String
		Local lnPuerto as Integer 

		Try

			lcCommand = ""
			
			lnPuerto = This.oRegistro.Puerto  
			
			S_AclNro( 4 )
			@ 08, 26 Get lnPuerto Picture "9999" Valid I_ValMay( lnPuerto, 0 )
			Read 
			
			SayMask( 08, 26, lnPuerto, "9999", 0 ) 

			This.oRegistro.Puerto = lnPuerto  

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Puerto

	*
	* Actualiza los datos en el registro
	Procedure Actualizar(  ) As Void;
			HELPSTRING "Actualiza los datos en el registro"

		Local lcCommand As String
		Local llOk As Boolean

		Try

			lcCommand = ""
			
			Select ar0Hasar
			Locate for Id = This.nId
			
			If Found()
				M_IniAct( 2 )
				Gather Name This.oRegistro Memo
				Unlock 
			EndIf

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


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oParame
*!*
*!* ///////////////////////////////////////////////////////

