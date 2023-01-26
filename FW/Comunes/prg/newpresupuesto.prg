#INCLUDE "Clientes\Pedidos\Include\Pedidos.h"

Lparameters lnTipoDePresupuesto As Integer

Local loPresupuesto As oPresupuestos Of "Clientes\Pedidos\Prg\prRutPre.prg"
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

* Singleton del objeto Articulo

Try

	lcCommand = ""
	loGlobalSettings 	= NewGlobalSettings()
	loPresupuesto 		= loGlobalSettings.oPresupuestos

	If Vartype( loPresupuesto ) # "O"

		* RA 16/02/2017(11:12:17) 
		* Si se necesita subclasear Presupuestos, debe inicializarse loGlobalSettings.oPresupuestos en xxGlobales()
		* que es llamada desde SetEnvironment(), o directamente en SetEnvironment()
		loPresupuesto = Newobject( "oPresupuestos", "Clientes\Pedidos\Prg\prRutPre.prg" )
		
		If Empty( lnTipoDePresupuesto ) 
			lnTipoDePresupuesto = PE_CLIENTE  
		EndIf
		
		loPresupuesto.TipoDePedido = lnTipoDePresupuesto
		
		loGlobalSettings.oPresupuestos = loPresupuesto

	Endif

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.cRemark = lcCommand
	loError.Process( oErr )
	Throw loError

Finally
	loGlobalSettings 	= Null

Endtry

Return loPresupuesto