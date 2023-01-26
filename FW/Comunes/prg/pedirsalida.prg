* Pedido Cantidad de copias

* Puede recibir comp parametro un objeto que puede tener alguna de las siguientes propiedades:
* 	oParam.cSalidas		Lista de opciones separadas por comas
* -------------- Tipo de Salida -------------------------
* #Define S_IMPRESORA					'0'
* #Define S_VISTA_PREVIA				'1'
* #Define S_HOJA_DE_CALCULO			'2'
* #Define S_PANTALLA					'3'
* #Define S_PDF						'4'
* #Define S_CSV						'5'
* #Define S_SDF						'6'
* #Define S_IMPRESORA_PREDETERMINADA	'7'
* #Define S_LISTADO_DOS				'99'

*	oParam.cDefault 	Salida por Default
*	oParam.nCopias		Cantidad de copias por default
*	oParam.ProgramId	Uso Futuro (1)
*	oParam.Userid		Uso Futuro (1)
*	oParam.TerminalId	Uso Futuro (1)
*		(1). 	Las opciones de salida se definen en la funcion GetOutputOptions()
*				a partir de los permisos 
	

Procedure PedirSalida
	Lparameters oParam As Object

	Local lcCommand As String
	Local loOutputOptions As Object,;
		loParam As Object

	Try

		lcCommand = ""

		If Vartype( oParam ) = "O"
			loParam = oParam
			 
		Else
			loParam = CreateObject( "Empty" ) 
			
		Endif

		loOutputOptions = GetOutputOptions( loParam )

		Do Form "Fw\Comunes\scx\PedirSalida.scx" With loOutputOptions To oExportar

	Catch To oErr
		Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
		loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally


	Endtry

	Return oExportar

Endproc