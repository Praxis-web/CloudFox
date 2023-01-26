*
* Selecciona una Impresora de la Tabla de Impresoras

* RA 01/06/2019(12:43:11)
* cPrinterCodigo tiene prevalecia sobre cPrinterName, si NO está vacio.
* cPrinterName es el Campo Nombre de Impresoras.dbf, más facil de leer y más descriptivo
* cPrinterCodigo es el Campo Codigo de Impresoras.dbf, equivalente a un Alias, y es la Clave Candidata
* Se utiliza Impresoras.Nombre por compatibilidad hacia atras
* Se recomienda utilizar Impresoras.Codigo en las nuevas implementaciones

Procedure SelectPrinter( cPrinterName As String ) As String ;
		HELPSTRING "Selecciona una Impresora de la Tabla de Impresoras"
	Local lcCommand As String,;
		lcPrinter As String
	Local loImpresora As Impresora Of 'Fw\Comunes\Prg\Impresora.prg'

	Try

		lcCommand = ""
		lcPrinter = ""

		loImpresora = GetEntity( "Impresora" )
		lcPrinter = loImpresora.SelectPrinter( cPrinterName )

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally
		loImpresora = Null

	Endtry

	Return lcPrinter

Endproc && SelectPrinter