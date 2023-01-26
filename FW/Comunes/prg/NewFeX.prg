Lparameters llOnDestroy As Boolean

#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\FE\Include\FE.h" 

* RA 2015-07-23(11:49:24)
* Singleton para Factura Electrónica de Exportación

Local loFeX As prxWSFeXv1 Of "Tools\FE\Prg\prxWSFeXv1.prg"
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"
Local loFiscalErrors As Collection
Local loPrinterErrors As Collection
Local i As Integer
Local llExist As Boolean
Local lcAlias As String


Try

	llExist = .T.
	loGlobalSettings = NewGlobalSettings()
	loFeX = loGlobalSettings.oFeX

	If Vartype( loFeX ) # 'O'

		loFeX = Newobject( "prxWSFeXv1", "Tools\FE\Prg\prxWSFeXv1.prg" )

		lcAlias = Alias()

		llExist = Used( "AR0FEL" )
		If !llExist
			M_Use( 0, Trim( DRVA ) + "AR0FEL" )
		Endif

		loFeX.nModo 			= AR0FEL.MODO0
		loFeX.cCuitEmisor 		= Alltrim( AR0FEL.CUIT0 )
		loFeX.cCertificado 		= Alltrim( AR0FEL.CERT0 )
		loFeX.cLicencia 		= Alltrim( AR0FEL.LICE0 )
		loFeX.nPuntoDeVenta 	= AR0FEL.PVEN0
		
		If loFeX.nModo = 0 && Prueba
			*loFeX.nPuntoDeVenta = loFeX.nPuntoDeVenta + 50
		Endif
		
		loFeX.DefaultFolder 	= JustPath( loFeX.cCertificado )  
		loFeX.lImportesExpresadosSiempreEnPesos = .T. 
		
		loFeX.lResultado = loFeX.Preparada()
		
		loGlobalSettings.oFeX = loFeX
		
	Else 	
		If !loFeX.lResultado
			loFeX.lResultado = loFeX.Preparada()
		EndIf
		
	Endif && Vartype( loFeX ) # 'O'

Catch To oErr
	loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	loGlobalSettings = Null
	If !llExist
		Use In AR0FEL
	Endif

	If !Empty( lcAlias )
		Select Alias( lcAlias )
	Endif

Endtry

Return loFeX