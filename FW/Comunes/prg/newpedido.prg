#INCLUDE "Clientes\Pedidos\Include\Pedidos.h"

Lparameters lnTipoDePedido As Integer

Local loPedido As oPedidos Of "Clientes\Pedidos\Prg\Perutina.prg"
Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

* Singleton del objeto Articulo

Try

	lcCommand = ""

	If Empty( lnTipoDePedido )
		lnTipoDePedido = PE_CLIENTE
	Endif
	loGlobalSettings 	= NewGlobalSettings()

	If lnTipoDePedido = PE_CLIENTE

		loPedido 			= loGlobalSettings.oPedidos

		If Vartype( loPedido ) # "O"

			* RA 2014-02-09(11:17:08)
			* Si se necesita subclasear Pedidos, debe inicializarse loGlobalSettings.oPedidos en xxGlobales()
			* que es llamada desde SetEnvironment(), o directamente en SetEnvironment()
			loPedido = Newobject( "oPedidos", "Clientes\Pedidos\Prg\Perutina.prg" )

			If Empty( lnTipoDePedido )
				lnTipoDePedido = PE_CLIENTE
			Endif

			loPedido.TipoDePedido = lnTipoDePedido

			loGlobalSettings.oPedidos = loPedido

		Endif

	Else
		loPedido 			= loGlobalSettings.oPedidosProveedores
		
		If Vartype( loPedido ) # "O"

			* RA 2014-02-09(11:17:08)
			* Si se necesita subclasear Pedidos Proveedores, debe inicializarse loGlobalSettings.oPedidosProveedores en xxGlobales()
			* que es llamada desde SetEnvironment(), o directamente en SetEnvironment()
			loPedido = Newobject( "oPedidosProveedores", "Clientes\Pedidos\Prg\Perutina.prg" )

			If Empty( lnTipoDePedido )
				lnTipoDePedido = PE_PROVEEDOR
			Endif

			loPedido.TipoDePedido = lnTipoDePedido

			loGlobalSettings.oPedidosProveedores = loPedido

		EndIf

	EndIf
	
Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.cRemark = lcCommand
	loError.Process( oErr )
	Throw loError

Finally
	loGlobalSettings 	= Null

Endtry

Return loPedido