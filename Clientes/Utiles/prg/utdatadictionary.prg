#Include 'Tools\DataDictionary\Include\DataDictionary.h'
#INCLUDE "Tools\eMail\Include\eMail.h"
#INCLUDE "Clientes\Valores\Include\Valores.h"
#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\Tieradapter\Include\TA.h"


Local lcCommand As String

Try

    lcCommand = ""

Catch To loErr
    Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
    loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
    loError.cRemark = lcCommand
    loError.Process ( m.loErr )
    Throw loError

Finally


Endtry

*!* ///////////////////////////////////////////////////////
*!* Class.........: oDataDictionary
*!* Description...:
*!* Date..........: Martes 31 de Agosto de 2021 (08:59:39)
*!*
*!*


Define Class oDataDictionary As oDataBase Of 'Tools\DataDictionary\prg\oDataBase.prg'

    #If .F.
        Local This As oDataDictionary Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    cDataConfigurationKey = "Pymes"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    * Constructor
    Procedure Initialize( uParam As Variant ) As Void;
            HELPSTRING "Constructor"
        Local lcCommand As String
        Local loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg'

        Try

            lcCommand = ""
            Set DataSession To

            loColTables 		= This.oColTables

            * Modelos Abstractos


            loColTables.AddTable ( Createobject ( 'BaseModel' ) )
            loColTables.AddTable ( Createobject ( 'BaseMaestro' ) )
            loColTables.AddTable ( Createobject ( 'CoreMaestroBase' ) )
            loColTables.AddTable ( Createobject ( 'CoreMaestroCodigo' ) )
            loColTables.AddTable ( Createobject ( 'CoreMovimientoBase' ) )
            loColTables.AddTable ( Createobject ( 'BaseTablaAuxiliar' ) )
            loColTables.AddTable ( Createobject ( 'SistemaBase' ) )
            loColTables.AddTable ( Createobject ( 'BaseTelefono' ) )
            loColTables.AddTable ( Createobject ( 'BaseEMail' ) )
            loColTables.AddTable ( Createobject ( 'BaseDireccion' ) )
            
            loColTables.AddTable ( Createobject ( 'Comprobante_Header' ) )
            loColTables.AddTable ( Createobject ( 'Comprobante_Detail' ) )
            loColTables.AddTable ( Createobject ( 'Comprobante_Footer' ) )


            * Modelos Concretos
            loColTables.AddTable ( Createobject ( 'Usuario' ) )
            loColTables.AddTable ( Createobject ( 'Menu' ) )
            *loColTables.AddTable ( Createobject ( 'User' ) )

            loColTables.AddTable ( Createobject ( 'Modulo' ) )
            loColTables.AddTable ( Createobject ( 'Cliente_Praxis' ) )
            loColTables.AddTable ( Createobject ( 'Empresa' ) )
            loColTables.AddTable ( Createobject ( 'Sucursal' ) )
            loColTables.AddTable ( Createobject ( 'Sucursal_Telefono' ))
            loColTables.AddTable ( Createobject ( 'Sucursal_eMail' ))
            loColTables.AddTable ( Createobject ( 'Sucursal_Direccion' ))

            loColTables.AddTable ( Createobject ( 'Grupo' ) )
            loColTables.AddTable ( Createobject ( 'SubGrupo' ) )
            loColTables.AddTable ( Createobject ( 'Rubro_Cliente' ) )
            loColTables.AddTable ( Createobject ( 'Rubro_Proveedor' ) )
            loColTables.AddTable ( Createobject ( 'Marca' ) )
            loColTables.AddTable ( Createobject ( 'Zona' ) )
            loColTables.AddTable ( Createobject ( 'Lista_Precios_Venta' ) )
            loColTables.AddTable ( Createobject ( 'PreciosDeVenta' ) )
            loColTables.AddTable ( Createobject ( 'Condicion_Pago' ) )
            loColTables.AddTable ( Createobject ( 'Presentacion' ) )
            loColTables.AddTable ( Createobject ( 'Clasificacion_Tipo_Articulo' ) )
            loColTables.AddTable ( Createobject ( 'Tipo_Articulo' ) )
            loColTables.AddTable ( Createobject ( 'Unidad_Medida' ) )
            loColTables.AddTable ( Createobject ( 'Articulo' ) )
            loColTables.AddTable ( Createobject ( 'Articulo_Proveedor' ) )
            loColTables.AddTable ( Createobject ( 'Articulo_Venta' ) )

            loColTables.AddTable ( Createobject ( 'PreciosDeCosto' ) )

            loColTables.AddTable ( Createobject ( 'Talle' ) )
            loColTables.AddTable ( Createobject ( 'Curva_Talle_Cab' ) )
            loColTables.AddTable ( Createobject ( 'Curva_Talle_Det' ) )

            *            loColTables.AddTable ( Createobject ( 'Color' ) )

            loColTables.AddTable ( Createobject ( 'Organizacion' ) )
            loColTables.AddTable ( Createobject ( 'Organizacion_Cliente' ) )
            loColTables.AddTable ( Createobject ( 'Organizacion_Proveedor' ) )
            loColTables.AddTable ( Createobject ( 'Organizacion_Contacto' ) )
            loColTables.AddTable ( Createobject ( 'Organizacion_Contacto_Telefono' ) )
            loColTables.AddTable ( Createobject ( 'Organizacion_Contacto_EMail' ) )
            loColTables.AddTable ( Createobject ( 'Organizacion_Sucursal' ) )
            loColTables.AddTable ( Createobject ( 'Organizacion_Sucursal_Direccion' ) )


            loColTables.AddTable ( Createobject ( 'Vendedor' ) )

            loColTables.AddTable ( Createobject ( 'Numerador' ) )
            loColTables.AddTable ( Createobject ( 'Comprobante_Base' ) )
            loColTables.AddTable ( Createobject ( 'Tipo_Comprobante' ) )
            
            loColTables.AddTable ( Createobject ( 'Ventas_Header' ) )
            loColTables.AddTable ( Createobject ( 'Ventas_Detail' ) )
            loColTables.AddTable ( Createobject ( 'Ventas_Footer' ) )
            

            loColTables.AddTable ( Createobject ( 'Deuda' ) )
            loColTables.AddTable ( Createobject ( 'Aplicacion_Deuda' ) )

            * e-Commerce
            loColTables.AddTable ( Createobject ( 'ML_Settings' ) )
            loColTables.AddTable ( Createobject ( 'TN_Settings' ) )


            * Contable
            loColTables.AddTable ( Createobject ( 'Cuenta_Contable' ))
            loColTables.AddTable ( Createobject ( 'Asiento_Tipo' ))

            * Sistema Tablas Comunes
            loColTables.AddTable ( Createobject ( 'Condicion_iva' ))
            loColTables.AddTable ( Createobject ( 'Moneda' ))
            loColTables.AddTable ( Createobject ( 'Pais' ))
            loColTables.AddTable ( Createobject ( 'Provincia' ))
            loColTables.AddTable ( Createobject ( 'Tipo_Telefono' ))
            loColTables.AddTable ( Createobject ( 'Tipo_eMail' ))
            loColTables.AddTable ( Createobject ( 'Tipo_Direccion' ))

            * Sistema Tablas Afip
            loColTables.AddTable ( Createobject ( 'Afip_Comprobante' ))
            loColTables.AddTable ( Createobject ( 'Afip_Concepto' ))
            loColTables.AddTable ( Createobject ( 'Afip_Documento' ))
            loColTables.AddTable ( Createobject ( 'Afip_Alicuota_Iva' ))
            loColTables.AddTable ( Createobject ( 'Afip_Moneda' ))
            loColTables.AddTable ( Createobject ( 'Afip_Tributo' ))

            * Tablas Intermedia
            *loColTables.AddTable ( Createobject ( 'sistema_condicion_iva_documentos' ))


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry


    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oDataDictionary
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: BaseModel
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class BaseModel As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

    #If .F.
        Local This As BaseModel Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            i = 100

            loField = loColFields.New( "id", "I" )

            loField = loColFields.New( "ts", "T" )
            loField = loColFields.New( "uts", "T" )
            loField = loColFields.New( "borrado", "L" )

            loField = loColFields.New( "Tran_id", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Transacción"
                .lNull = .T.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: BaseModel
*!*
*!* ///////////////////////////////////////////////////////




*!* ///////////////////////////////////////////////////////
*!* Class.........: BaseMaestro
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:57:59)
*!*
*!*

Define Class BaseMaestro As BaseModel Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As BaseMaestro Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 150

            loColFields = This.oColFields

            loField = loColFields.New( "nombre", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                    .lFitColumn = .T.
                Endif

                .cCaption = "Nombre"
                .cToolTipText = "Ingrese el Nombre"
                .cCheck = "I_ValObl( Nombre )"
                .cErrorMessage = "El NOMBRE es Obligatorio"

                .lRequired = .T.
                .nLength = 30
                .lFitColumn = .T.

            Endwith

            loField = loColFields.New( "descripcion", "M" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Descripción"
                .cToolTipText = "Ingrese una descripción del registro"

            Endwith

            * Estos campos van en el extremo derecho
            i = 900

            loField = loColFields.New( "activo", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                i = i + 1
                .nGridOrder = i
                .Default = .T.
                .cCaption = "Activo"
                .nLength = 10

                *!*	                .oCurrentControl.Name	= 'ChkLogical'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"
                .cToolTipText = "Indica si el registro se muestra en todas las consultas"
            Endwith

            loField = loColFields.New( "orden", "N", 6, 0 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                i = i + 1
                .nGridOrder = i
                .cCaption = "Orden"
                .nLength = 10

                *!*	                .cCheck = "I_ValMay( Orden, 0 )"
                *!*	                .cErrorMessage = "El ORDEN debe ser Mayor que Cero"

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Ingrese el ORDEN en que
				quiere mostrar el Registro
                ENDTEXT

                .lRequired = .T.
                .Default = 500

                *!*	                .oCurrentControl.Name	= 'SpinnerBase'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"

            Endwith


            loField = loColFields.New( "es_sistema", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                i = i + 1
                .nGridOrder = i
                .Default = .F.
                .cCaption = "Registro de Sistema"
                .cHeaderCaption = "Sistema"
                .nLength = 10

                *!*	                .oCurrentControl.Name	= 'ChkLogical'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"

                TEXT To lcMsg NoShow TextMerge Pretext 03
				Indica si el registro es del sistema.
				Un registro del sistema NO PUEDE SER ELIMINADO.
                ENDTEXT

                .cToolTipText = lcMsg

            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: BaseMaestro
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: CoreMaestroBase
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:57:59)
*!*
*!*

Define Class CoreMaestroBase As BaseMaestro Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()

            DoDefault()

            loColFields = This.oColFields

            i = 100

            loField = loColFields.NewFK( "cliente_praxis", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cliente Praxis"
                *!*					.oCurrentControl.Name 	= "cboPraxis"
                *!*					.oCurrentControl.Class 	= "cboPraxis"
                *!*					.oCurrentControl.ClassLibrary 	= "Clientes\Archivos\Prg\Cliente_Praxis.prg"
                .Default = loGlobalSettings.nClientePraxis
                .lStr = .F.
                .lNull = .F.
            Endwith

            *!*				loField = loColFields.NewFK( "empresa", "I" )
            *!*				With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*					.lShowInGrid = .F.
            *!*					If .lShowInGrid
            *!*						i = i + 1

            *!*						.nGridOrder = i
            *!*					Endif

            *!*					.cCaption = "Empresa"
            *!*					.Default = 1
            *!*				Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: CoreMaestroBase
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: CoreMaestroCodigo
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:57:59)
*!*
*!*

Define Class CoreMaestroCodigo As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As CoreMaestroCodigo Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 90

            loColFields = This.oColFields

            loField = loColFields.New( "codigo", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .lCanUpdate = .F.
                .cCaption = "Código"
                .lRequired = .T.
                .cToolTipText = "Ingrese el CÓDIGO"
            Endwith



        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: CoreMaestroCodigo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: CoreMovimientoBase
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:57:59)
*!*
*!*

Define Class CoreMovimientoBase As BaseMaestro Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As CoreMovimientoBase Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()


            DoDefault()

            loColFields = This.oColFields

            i = 100

            loField = loColFields.New( "Fecha", "D" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            	.lShowInGrid = .T.
            	.nGridOrder = i
                .cCaption = "Fecha"
                .cToolTipText = "Ingrese la Fecha de Emisión"
                .nLength = 15
            EndWith
            
            loField = loColFields.New( "nombre", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Comprobante"
                .lFitColumn = .F.

            Endwith
            
            loField = loColFields.NewFK( "cliente_praxis", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cliente Praxis"
                .Default = loGlobalSettings.nClientePraxis
                .lStr = .F.
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "empresa", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Empresa"
                .Default = loGlobalSettings.nEmpresaActiva
                .cFK_Modelo = "Empresa"
                .nShowInFilter = 101
                .cFilterLookUpInclude = ["exact","in"]
                .lStr = .F.
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "sucursal", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Sucursal"
                .Default = loGlobalSettings.nEmpresaSucursalActiva
                .cFK_Modelo = "Sucursal"
                *!*	                .nShowInFilter = 101
                *!*	                .cFilterLookUpInclude = ["exact","in"]
                .lStr = .F.
                .lNull = .F.
            Endwith

            loField = loColFields.New( "punto_de_venta", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Punto De Venta"
                .nShowInFilter = 103
                .cFilterDataType = "N"	&& Fuerza un control Spinner
                .cFilterLookUpInclude = ["exact","in"]
            Endwith

            loField = loColFields.New( "numero", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Número"
            Endwith

            loField = loColFields.NewFK( "Tipo_Comprobante", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Tipo de Comprobante"
                .cFK_Modelo = "Tipo_Comprobante"
                .lNull = .F.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: CoreMovimientoBase
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Comprobante_Header
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:57:59)
*!*
*!*

Define Class Comprobante_Header As CoreMovimientoBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Comprobante_Header Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()


            DoDefault()

            loColFields = This.oColFields

            i = 100

            loField = loColFields.New( "Subtotal", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Subtotal"
                .lNull = .T.
            Endwith


            loField = loColFields.New( "Total", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Total"
                .lNull = .T.
            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Comprobante_Header
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Comprobante_Detail
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:57:59)
*!*
*!*

Define Class Comprobante_Detail As BaseModel Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Comprobante_Detail Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()


            DoDefault()

            loColFields = This.oColFields

            i = 100

            loField = loColFields.NewFK( "cabeza", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cabeza"
                .cFK_Modelo = "Header"
            Endwith

            loField = loColFields.New( "orden", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Orden"
            EndWith
            
            loField = loColFields.NewFK( "articulo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Artículo"
                .cFK_Modelo = "Producto"
            EndWith
            
            loField = loColFields.New( "cantidad", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Cantidad"
            EndWith
            
            loField = loColFields.New( "signo_stock", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Signo Stock"
            EndWith

            
            loField = loColFields.New( "precio_unitario", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Precio Unitario"
            Endwith


            loField = loColFields.New( "Importe", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Importe"
            Endwith


            loField = loColFields.New( "costo_unitario", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Costo Unitario"
            Endwith

            loField = loColFields.New( "signo_cuenta_corriente", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Signo Cuenta Corriente"
            EndWith

            loField = loColFields.New( "referencia", "M" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Referencia"
            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Comprobante_Detail
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Comprobante_Footer
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:57:59)
*!*
*!*

Define Class Comprobante_Footer As BaseModel Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Comprobante_Footer Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()


            DoDefault()

            loColFields = This.oColFields

            i = 100

            loField = loColFields.NewFK( "cabeza", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cabeza"
                .cFK_Modelo = "Header"
            Endwith

            loField = loColFields.New( "orden", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Orden"
            EndWith
            
			loField = loColFields.New( "descripcion", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "descripcion"
            Endwith            
            
            loField = loColFields.New( "signo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Signo"
                .Default = 1
            EndWith

            
            loField = loColFields.New( "base_imponible", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Base Imponible"
            Endwith


            loField = loColFields.New( "Importe", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Importe"
            Endwith


            loField = loColFields.New( "alicuota", "N", 06, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Alícuota"
            Endwith

            loField = loColFields.New( "signo_cuenta_corriente", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Signo Cuenta Corriente"
            EndWith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Comprobante_Footer
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Ventas_Header
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:57:59)
*!*
*!*

Define Class Ventas_Header As Comprobante_Header Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Ventas_Header Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    cBaseClass 		= "oComprobanteVenta"
    cBaseClassLib 	= "Clientes\Ventas\Prg\ComprobanteVenta.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()


            DoDefault()

            loColFields = This.oColFields

            i = 500

            loField = loColFields.NewFK( "cliente", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cliente"
                .cFK_Modelo = "Organizacion_Cliente"
            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Ventas_Header
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Ventas_Detail
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:57:59)
*!*
*!*

Define Class Ventas_Detail As Comprobante_Detail Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Ventas_Detail Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    cBaseClass 		= "oComprobanteVenta_Detail"
    cBaseClassLib 	= "Clientes\Ventas\Prg\ComprobanteVenta.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()


            DoDefault()

            loColFields = This.oColFields

            i = 100

            loField = loColFields.NewFK( "cabeza", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cabeza"
                .cFK_Modelo = "Ventas_Header"
            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Ventas_Detail
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Ventas_Footer
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:57:59)
*!*
*!*

Define Class Ventas_Footer As Comprobante_Footer Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Ventas_Footer Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    cBaseClass 		= "oComprobanteVenta_Footer"
    cBaseClassLib 	= "Clientes\Ventas\Prg\ComprobanteVenta.prg"


    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()


            DoDefault()

            loColFields = This.oColFields

            i = 100

            loField = loColFields.NewFK( "cabeza", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cabeza"
                .cFK_Modelo = "Ventas_Header"
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Ventas_Footer
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: BaseTablaAuxiliar
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class BaseTablaAuxiliar As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

    #If .F.
        Local This As BaseTablaAuxiliar Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            i = 100

            loField = loColFields.New( "id", "I" )

            loField = loColFields.NewFK( "cliente_praxis", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cliente Praxis"
                .Default = 1
                .lStr = .F.
                .lNull = .F.
            Endwith



            loField = loColFields.New( "ts", "T" )
            loField = loColFields.New( "uts", "T" )
            loField = loColFields.New( "borrado", "L" )

            loField = loColFields.New( "descripcion", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Descripción"
                .cToolTipText = "Ingrese la descripción"
                *!*	                .cCheck = "I_ValObl( Descripcion )"
                *!*	                .cErrorMessage = "La DESCRIPCIÓN es Obligatoria"

                .lRequired = .T.
                .nLength = 30

            Endwith


            * Estos campos van en el extremo derecho
            i = 900

            loField = loColFields.New( "activo", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .Default = .T.
                .cCaption = "Activo"
                .nGridOrder = i
                *!*	                .oCurrentControl.Name	= 'ChkLogical'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"
                .cToolTipText = "Indica si el registro se muestra en todas las consultas"
            Endwith

            loField = loColFields.New( "orden", "N", 6, 0 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Orden"
                *!*	                .cCheck = "I_ValMay( Orden, 0 )"
                *!*	                .cErrorMessage = "El ORDEN debe ser Mayor que Cero"

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Ingrese el ORDEN en que
				quiere mostrar el Registro
                ENDTEXT

                .lRequired = .T.
                .Default = 500

            Endwith



        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: BaseTablaAuxiliar
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: SistemaBase
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class SistemaBase As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As SistemaBase Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: SistemaBase
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: User
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class User As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

    #If .F.
        Local This As User Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            loField = loColFields.New( "id", "I" )
            loField = loColFields.New( "password", "C", 128 )
            loField = loColFields.New( "last_login", "T" )
            loField = loColFields.New( "is_superuser", "L" )
            loField = loColFields.New( "username", "C", 150 )
            loField = loColFields.New( "first_name", "C", 150 )
            loField = loColFields.New( "last_name", "C", 150 )
            loField = loColFields.New( "email", "C", 254 )

            loField = loColFields.New( "is_staff", "L" )
            loField = loColFields.New( "is_active", "L" )

            loField = loColFields.New( "date_joined", "T" )

            loField = loColFields.New( "imagen", "C", 254 )

            loField = loColFields.New( "allowed_sessions", "N", 1, 0 )
            loField = loColFields.NewFK( "cliente_praxis_id", "I" )


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: User
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Usuario
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Usuario As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

    #If .F.
        Local This As Usuario Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oUsuario"
    cBaseClassLib 	= "Clientes\Archivos\prg\Usuario.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            i = 100

            loField = loColFields.New( "id", "I" )

            loField = loColFields.New( "password", "C", 128 )
            loField = loColFields.New( "last_login", "T" )
            loField = loColFields.New( "date_joined", "T" )
            loField = loColFields.New( "is_superuser", "L" )
            loField = loColFields.New( "username", "C", 150 )
            loField = loColFields.New( "first_name", "C", 150 )

            loField = loColFields.New( "last_name", "C", 150 )
            loField = loColFields.New( "email", "C", 254 )
            loField = loColFields.New( "is_staff", "L" )
            loField = loColFields.New( "is_active", "L" )

            loField = loColFields.New( "allowed_sessions", "I" )
            loField = loColFields.New( "cliente_praxis_id", "I" )

            loField = loColFields.New( "modifica_activo", "L" )
            loField = loColFields.New( "modifica_orden", "L" )
            loField = loColFields.New( "modifica_es_sistema", "L" )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Usuario
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Menu
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Menu As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

    #If .F.
        Local This As Menu Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .T.
    cBaseClass 		= "oMenu"
    cBaseClassLib 	= "FrontEnd\Prg\DescargarMenu.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            loField = loColFields.New( "id", "I" )
            loField = loColFields.New( "nombre", "C", 100 )
            loField = loColFields.New( "descripcion", "M" )
            loField = loColFields.New( "orden", "I" )
            loField = loColFields.New( "file_name", "C", 150 )
            loField = loColFields.New( "folder", "C", 200 )
            loField = loColFields.New( "url", "C", 200 )
            loField = loColFields.New( "cliente_praxis", "I" )
            loField = loColFields.New( "modulo", "I" )

            loField = loColFields.New( "parent", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lNull = .T.
            Endwith

            loField = loColFields.New( "permisos", "I" )
            loField = loColFields.New( "acciones", "I" )
            loField = loColFields.New( "es_titulo", "L" )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Menu



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Usuario
*!*
*!* ///////////////////////////////////////////////////////



*!* ///////////////////////////////////////////////////////
*!* Class.........: Cliente_Praxis
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Cliente_Praxis As BaseMaestro Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Cliente_Praxis Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oPraxis"
    cBaseClassLib 	= "Clientes\Archivos\prg\Cliente_Praxis.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 150

            loColFields = This.oColFields

            loField = loColFields.New( "es_praxis", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .Default = .T.
                .cCaption = "Es Praxis"
                .nGridOrder = i
                *!*	                .oCurrentControl.Name	= 'ChkLogical'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Falso: Sólo accede su propia información.
				Verdadero: Puede acceder a la información de cualquier otro Cliente Praxis
                ENDTEXT


            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Cliente_Praxis
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Empresa
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Empresa As BaseMaestro Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Empresa Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oEmpresa"
    cBaseClassLib 	= "Clientes\Archivos\prg\Empresa.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()

            DoDefault()

            loColFields = This.oColFields

            i = 200

            loField = loColFields.NewFK( "Cliente_Praxis", "N", 4 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cliente Praxis"
                *!*					.oCurrentControl.Name 	= "cboPraxis"
                *!*					.oCurrentControl.Class 	= "cboPraxis"
                *!*					.oCurrentControl.ClassLibrary 	= "Clientes\Archivos\Prg\Cliente_Praxis.prg"
                .Default = loGlobalSettings.nClientePraxis
                .lStr = .F.
                .lNull = .F.
            Endwith


            loField = loColFields.New( "nombre", "C", 40 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Razón Social"
                .cToolTipText = "Ingrese la Razón Social"
                .lRequired = .T.
                .nGridMaxLength = 30
            Endwith


            loField = loColFields.New( "nombre_fantasia", "C", 40 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Nombre Fantasía"
                .cToolTipText = "Ingrese el Nombre Fantasía"
                .nGridMaxLength = 20

            Endwith

            *!*	            loField = loColFields.New( "descripcion", "M" )
            *!*	            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*	                .lShowInGrid = .F.
            *!*	                If .lShowInGrid
            *!*	                    i = i + 1

            *!*	                    .nGridOrder = i
            *!*	                Endif

            *!*	                .cCaption = "Descripción"
            *!*	                .cToolTipText = "Ingrese una descripción de la Empresa"

            *!*	            Endwith

            loField = loColFields.NewFk( "condicion_iva", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Condición Iva"
                .cReferences = "Condicion_Iva"
                *!*	                .oCurrentControl.Name	= "ComboBoxBase"
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"
            Endwith

            loField = loColFields.New( "tipo_documento", "N", 4 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Tipo de Documento"
                .cReferences = "Afip_Documento"
                *!*					.oCurrentControl.Name 	= "cboDocumento"
                *!*					.oCurrentControl.Class 	= "cboDocumento"
                *!*					.oCurrentControl.ClassLibrary 	= "Clientes\Archivos\Prg\DocumentoAfip.prg"
                .Default = 80
            Endwith

            loField = loColFields.New( "documento_numero", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Nº de Documento"
                *!*	                .cCheck = "I_ValObl( documento_numero )"
                *!*	                .cErrorMessage = "El Nº de Documento es Obligatorio"
                .cToolTipText = "Ingrese el Nº de Documento"

                .lRequired = .T.

            Endwith

            loField = loColFields.New( "ingresos_brutos", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "IIBB"
                *!*	                .cCheck = "I_ValObl( ingresos_brutos )"
                *!*	                .cErrorMessage = "El Nº de Ingresos Brutos es Obligatorio"
                .cToolTipText = "Ingrese el Nº de Ingresos Brutos "

                .lRequired = .T.

            Endwith

            loField = loColFields.New( "jubilacion", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Jubilacion"
                *!*	                .cCheck = "I_ValObl( jubilacion )"
                *!*	                .cErrorMessage = "El Nº de Jubilacion es Obligatorio"
                .cToolTipText = "Ingrese el Nº de Jubilacion "

                .lRequired = .T.

            Endwith

            loField = loColFields.New( "inicio_de_actividades", "D" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Inicio de Actividades"
                *!*	                .cCheck = "I_ValObl( Inicio_de_Actividades )"
                *!*	                .cErrorMessage = "El Inicio de Actividades es Obligatorio"
                .cToolTipText = "Ingrese el Inicio de Actividades"

                .lRequired = .T.

            Endwith



        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Empresa

*!* ///////////////////////////////////////////////////////
*!* Class.........: xxx_Empresa
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class xxx_Empresa As BaseMaestro Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Empresa Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oEmpresa"
    cBaseClassLib 	= "Clientes\Archivos\prg\Empresa.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
        Local loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg"

        Try

            lcCommand = ""
            loGlobalSettings = NewGlobalSettings()

            loColFields = This.oColFields

            i = 100

            loField = loColFields.New( "id", "I" )

            loField = loColFields.NewFK( "Cliente_Praxis", "N", 4 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cliente Praxis"
                *!*					.oCurrentControl.Name 	= "cboPraxis"
                *!*					.oCurrentControl.Class 	= "cboPraxis"
                *!*					.oCurrentControl.ClassLibrary 	= "Clientes\Archivos\Prg\Cliente_Praxis.prg"
                .Default = loGlobalSettings.nClientePraxis
                .lStr = .F.
                .lNull = .F.
            Endwith


            loField = loColFields.New( "nombre", "C", 40 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                    .lFitColumn = .T.
                Endif

                .cCaption = "Razón Social"
                *!*	                .cCheck = "I_ValObl( Nombre )"
                *!*	                .cErrorMessage = "La Razón Social es Obligatoria"
                .cToolTipText = "Ingrese la Razón Social"

                .lRequired = .T.

            Endwith


            loField = loColFields.New( "nombre_fantasia", "C", 40 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Nombre Fantasía"
                .cToolTipText = "Ingrese el Nombre Fantasía"

            Endwith

            loField = loColFields.New( "descripcion", "M" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Descripción"
                .cToolTipText = "Ingrese una descripción de la Empresa"

            Endwith

            loField = loColFields.NewFk( "condicion_iva", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Condición Iva"
                .cReferences = "Condicion_Iva"
                *!*	                .oCurrentControl.Name	= "ComboBoxBase"
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"
            Endwith

            loField = loColFields.New( "tipo_documento", "N", 4 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Tipo de Documento"
                .cReferences = "Afip_Documento"
                *!*					.oCurrentControl.Name 	= "cboDocumento"
                *!*					.oCurrentControl.Class 	= "cboDocumento"
                *!*					.oCurrentControl.ClassLibrary 	= "Clientes\Archivos\Prg\DocumentoAfip.prg"
                .Default = 80
            Endwith

            loField = loColFields.New( "documento_numero", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Nº de Documento"
                *!*	                .cCheck = "I_ValObl( documento_numero )"
                *!*	                .cErrorMessage = "El Nº de Documento es Obligatorio"
                .cToolTipText = "Ingrese el Nº de Documento"

                .lRequired = .T.

            Endwith

            loField = loColFields.New( "ingresos_brutos", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "IIBB"
                *!*	                .cCheck = "I_ValObl( ingresos_brutos )"
                *!*	                .cErrorMessage = "El Nº de Ingresos Brutos es Obligatorio"
                .cToolTipText = "Ingrese el Nº de Ingresos Brutos "

                .lRequired = .T.

            Endwith

            loField = loColFields.New( "jubilacion", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Jubilacion"
                *!*	                .cCheck = "I_ValObl( jubilacion )"
                *!*	                .cErrorMessage = "El Nº de Jubilacion es Obligatorio"
                .cToolTipText = "Ingrese el Nº de Jubilacion "

                .lRequired = .T.

            Endwith

            loField = loColFields.New( "inicio_de_actividades", "D" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Inicio de Actividades"
                *!*	                .cCheck = "I_ValObl( Inicio_de_Actividades )"
                *!*	                .cErrorMessage = "El Inicio de Actividades es Obligatorio"
                .cToolTipText = "Ingrese el Inicio de Actividades"

                .lRequired = .T.

            Endwith


            i = 900

            loField = loColFields.New( "activo", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                i = i + 1
                .nGridOrder = i

                .cCaption = "Activo"

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Indica si el registro se muestra siempre,
				o permanece oculto en la mayoría de los casos
                ENDTEXT

                .Default = .T.

                *!*	                .oCurrentControl.Name	= 'ChkLogical'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"

            Endwith

            loField = loColFields.New( "orden", "N", 6, 0 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                i = i + 1

                .nGridOrder = i

                .cCaption = "Orden"
                *!*	                .cCheck = "I_ValMay( Orden, 0 )"
                *!*	                .cErrorMessage = "El ORDEN debe ser Mayor que Cero"

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Ingrese el ORDEN en que
				quiere mostrar el Registro
                ENDTEXT

                .lRequired = .T.
                .Default = 500

            Endwith

            loField = loColFields.New( "es_sistema", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                i = i + 1
                .nGridOrder = i

                .Default = .T.
                .cCaption = "Registro de Sistema"

                TEXT To lcMsg NoShow TextMerge Pretext 03
				Indica si el registro es del sistema.
				Un registro del sistema NO PUEDE SER ELIMINADO.
                ENDTEXT

                .cToolTipText = lcMsg

            Endwith



        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: xxx_Empresa
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Sucursal
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Sucursal As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Sucursal Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oSucursal"
    cBaseClassLib 	= "Clientes\Archivos\prg\Sucursal.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

            loField = loColFields.NewFK( "empresa", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Empresa"
                .cFK_Modelo = "Empresa"
                .nShowInFilter = 101
                .cFilterLookUpInclude = ["exact","in"]

                .lCanUpdate = .F.
                .lStr = .F.
                .lNull = .F.
            Endwith

            loField = loColFields.New( "Alias", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Alias"
                .cToolTipText = "Nombre amigable de la sucursal"

                *!*	                .cCheck = "I_ValObl( Alias )"
                *!*	                .cErrorMessage = "La Razón Social es Obligatoria"

                .lRequired = .T.

            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Sucursal
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Tipo_Telefono
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Tipo_Telefono As BaseTablaAuxiliar Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Tipo_Telefono Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oTipo_Telefono"
    cBaseClassLib 	= "Clientes\Archivos\prg\Tipo_Telefono.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Tipo_Telefono
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Tipo_eMail
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Tipo_eMail As BaseTablaAuxiliar Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Tipo_eMail Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oTipo_eMail"
    cBaseClassLib 	= "Clientes\Archivos\prg\Tipo_eMail.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Tipo_eMail
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Tipo_Direccion
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Tipo_Direccion As BaseTablaAuxiliar Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Tipo_Direccion Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oTipo_Direccion"
    cBaseClassLib 	= "Clientes\Archivos\prg\Tipo_Direccion.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Tipo_Direccion
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Telefono
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class BaseTelefono As BaseTablaAuxiliar Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Telefono Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oTelefono"
    cBaseClassLib 	= "Clientes\Archivos\prg\Telefono.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            DoDefault()

            i = 200

            loField = loColFields.NewFK( "tipo_telefono", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Tipo de Teléfono"
            Endwith

            loField = loColFields.New( "prefijo_pais", "C", 6 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Prefijo del País"
                .cToolTipText = "Ingrese el Prefijo del País"
            Endwith

            loField = loColFields.New( "codigo_area", "C", 6 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Código de Area"
                .cToolTipText = "Ingrese el Prefijo del País"
            Endwith

            loField = loColFields.New( "numero", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Número"
                *!*	                .cCheck = "I_ValObl( numero_telefono )"
                *!*	                .cErrorMessage = "El Número es Obligatorio"
                .cToolTipText = "Ingrese el Número de Teléfono"

                .lRequired = .T.

            Endwith


            * RA 23/06/2022(11:08:48)
            * El Backend trae en este campo la representación
            * del Nº completo
            loField = loColFields.New( "telefono", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Teléfono"

                .lRequired = .F.

            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Telefono
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: eMail
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class BaseEMail As BaseTablaAuxiliar Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As BaseEMail Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oeMail"
    cBaseClassLib 	= "Clientes\Archivos\prg\eMail.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            DoDefault()

            i = 200

            loField = loColFields.New( "email", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "e-Mail"
                *!*	                .cCheck = "I_ValObl( email )"
                *!*	                .cErrorMessage = "La Dirección de eMail es Obligatoria"
                .cToolTipText = "Ingrese la Dirección de eMail"

                .lRequired = .T.

            Endwith

            loField = loColFields.NewFK( "tipo_eMail", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Tipo de eMail"
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: eMail
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Direccion
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class BaseDireccion As BaseTablaAuxiliar Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As BaseDireccion Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oDireccion"
    cBaseClassLib 	= "Clientes\Archivos\prg\Direccion.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            DoDefault()

            i = 200

            loField = loColFields.NewFK( "tipo_Direccion", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Tipo de Direccion"
            Endwith

            loField = loColFields.New( "calle", "C", 50 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Calle"
                *!*	                .cCheck = "I_ValObl( calle )"
                *!*	                .cErrorMessage = "La Calle es Obligatoria"
                .cToolTipText = "Ingrese el nombre de la Calle"

                .lRequired = .T.

            Endwith

            loField = loColFields.New( "numero", "C", 10 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Nº"
                .cToolTipText = "Ingrese el Nº de la Calle"

                .lRequired = .F.

            Endwith

            loField = loColFields.New( "piso", "C", 10 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Piso"
                .cToolTipText = "Ingrese el Piso"

                .lRequired = .F.

            Endwith

            loField = loColFields.New( "departamento", "C", 10 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Departamento"
                .cToolTipText = "Ingrese el Departamento"

                .lRequired = .F.

            Endwith

            loField = loColFields.New( "barrio", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Barrio"
                .cToolTipText = "Ingrese el Barrio"

                .lRequired = .F.

            Endwith

            loField = loColFields.New( "codigo_postal", "C", 8 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Código Postal"
                .cToolTipText = "Ingrese el Código Postal"

                .lRequired = .F.

            Endwith

            loField = loColFields.New( "localidad", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Localidad"
                *!*	                .cCheck = "I_ValObl( direccion_localidad )"
                *!*	                .cErrorMessage = "La Localidad es Obligatoria"
                .cToolTipText = "Ingrese la Localidad"

                .lRequired = .T.

            Endwith

            loField = loColFields.NewFK( "Pais", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "País"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "Provincia", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Provincia"
                .lNull = .F.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Direccion
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Sucursal_Telefono
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Sucursal_Telefono As BaseTelefono Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Sucursal_Telefono Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oTelefono"
    cBaseClassLib 	= "Clientes\Archivos\prg\Telefono.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            DoDefault()

            i = 90


            loField = loColFields.NewFK( "Sucursal", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Sucursal"
                *!*					.oCurrentControl.Name 	= "cboSucursal"
                *!*					.oCurrentControl.Class 	= "cboSucursal"
                *!*					.oCurrentControl.ClassLibrary 	= "Clientes\Archivos\Prg\Sucursal.prg"
                .lStr = .F.
                .lNull = .F.

            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Sucursal_Telefono
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Sucursal_eMail
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Sucursal_eMail As BaseeMail Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Sucursal_eMail Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oeMail"
    cBaseClassLib 	= "Clientes\Archivos\prg\eMail.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            DoDefault()

            i = 90


            loField = loColFields.NewFK( "Sucursal", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Sucursal"
                *!*					.oCurrentControl.Name 	= "cboSucursal"
                *!*					.oCurrentControl.Class 	= "cboSucursal"
                *!*					.oCurrentControl.ClassLibrary 	= "Clientes\Archivos\Prg\Sucursal.prg"

                .lStr = .F.
                .lNull = .F.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Sucursal_eMail
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Sucursal_Direccion
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Sucursal_Direccion As BaseDireccion Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Sucursal_Direccion Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oDireccion"
    cBaseClassLib 	= "Clientes\Archivos\prg\Direccion.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            DoDefault()

            i = 90


            loField = loColFields.NewFK( "Sucursal", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Sucursal"
                *!*					.oCurrentControl.Name 	= "cboSucursal"
                *!*					.oCurrentControl.Class 	= "cboSucursal"
                *!*					.oCurrentControl.ClassLibrary 	= "Clientes\Archivos\Prg\Sucursal.prg"
                .lStr = .F.
                .lNull = .F.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Sucursal_Direccion
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Afip_Base
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Afip_Base As SistemaBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As SistemaBase Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual = .T.
    cLookupField = "Id"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 90

            loColFields = This.oColFields

            loField = loColFields.New( "codigo_afip", "N", 6, 0 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .lCanUpdate = .F.
                .cCaption = "Código Afip"
                *!*	                .cCheck = "!Empty( Codigo )"
                *!*	                .cErrorMessage = "El CÓDIGO es obligatorio"
                .lRequired = .T.
                .cToolTipText = "Ingrese el CÓDIGO AFIP"
            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Afip_Base
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Condicion_iva
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (17:43:51)
*!*
*!*

Define Class Condicion_iva As SistemaBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Condicion_iva Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif


    lIsVirtual 		= .F.
    cBaseClass 		= "oCondicion_Iva"
    cBaseClassLib 	= "Clientes\Archivos\prg\CondicionIva.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields
            i = 200

            loField = loColFields.New( "nombre_abreviado", "C", 3 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Abrev."
                .cToolTipText = "Ingrese el nombre abreviado"
                *!*	                .cCheck = "!Empty( nombre_abreviado )"
                *!*	                .cErrorMessage = "El NOMBRE ABREVIADO es obligatorio"

            Endwith

            *!*				loField = loColFields.New( "letra", "C", 1 )
            *!*				With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*					.lShowInGrid = .T.
            *!*					If .lShowInGrid
            *!*						i = i + 1

            *!*						.nGridOrder = i
            *!*					Endif

            *!*					.cCaption = "Letra"
            *!*					.Default = ' '
            *!*					.cToolTipText = "Letra asociada al comprobante"
            *!*					.cInputMask = "!"
            *!*					nLength = 5

            *!*				EndWith

            loField = loColFields.NewM2M( "documentos" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                .cCaption = "Documentos Válidos"

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Lista de documentos válidos
				para el receptor del comprobante
				en función de su
				Condición Frente al Iva
                ENDTEXT

                .cReferences = "Afip_Documento"
            Endwith

            loField = loColFields.NewM2M( "comprobantes" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                .cCaption = "Comprobantes Válidos"

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Lista de comprobantes válidos
				para el receptor del comprobante
				en función de su
				Condición Frente al Iva
                ENDTEXT

                .cReferences = "Afip_Comprobante"
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Condicion_iva
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: Moneda
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (17:43:51)
*!*
*!*

Define Class Moneda As SistemaBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Moneda Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif


    lIsVirtual 		= .F.
    cBaseClass 		= "oMoneda"
    cBaseClassLib 	= "Clientes\Archivos\prg\Moneda.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields
            i = 200

            loField = loColFields.New( "signo", "C", 10 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Signo"
                .cToolTipText = "Ingrese el Signo Monetario"
                *!*	                .cCheck = "!Empty( nombre_abreviado )"
                *!*	                .cErrorMessage = "El SIGNO MONETARIO es obligatorio"

            Endwith

            loField = loColFields.New( "cotizacion", "N", 12, 5 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cotización"
                *!*	                .cCheck = "!Empty( cotizacion )"
                *!*	                .cErrorMessage = "La COTIZACIÓN es obligatorio"
                .cToolTipText = "Ingrese la COTIZACIÓN de la Moneda"
                .lRequired = .T.
                .Default = 1

            Endwith

            loField = loColFields.NewFK( "afip_moneda", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Código Afip"
                .cReferences = "afip_moneda"
                .lRequired = .T.
                .lNull = .F.

                *.Default = 2	&& Tiene que ir parametrizado

                *!*					.oCurrentControl.Name 	= "cboPresentacion"
                *!*					.oCurrentControl.Class 	= "cboPresentacion"
                *!*					.oCurrentControl.ClassLibrary 	= "Clientes\Archivos\Prg\Presentacion.prg"

            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Moneda
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Afip_Comprobante
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (17:43:51)
*!*
*!*

Define Class Afip_Comprobante As Afip_Base Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Afip_Comprobante Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif


    lIsVirtual = .F.
    cBaseClass 		= "oComprobante_Afip"
    cBaseClassLib 	= "Clientes\Archivos\prg\ComprobanteAfip.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200

            loColFields = This.oColFields

            loField = loColFields.New( "nombre", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .nGridMaxLength = 40
            Endwith

            loField = loColFields.New( "nombre_abreviado", "C", 6 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Abrev."
                *!*					.cCheck = "!Empty( nombre_abreviado )"
                *!*					.cErrorMessage = "El NOMBRE ABREVIADO es obligatorio"

            Endwith

            *!*				loField = loColFields.New( "letra", "C", 1 )
            *!*				With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*					.lShowInGrid = .T.
            *!*					If .lShowInGrid
            *!*						i = i + 1

            *!*						.nGridOrder = i
            *!*					Endif

            *!*					.cCaption = "Letra"
            *!*					.Default = ' '
            *!*					.cToolTipText = "Letra asociada al comprobante"
            *!*					.cInputMask = "!"
            *!*					nLength = 5

            *!*				Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Afip_Comprobante
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Afip_Concepto
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (17:43:51)
*!*
*!*

Define Class Afip_Concepto As Afip_Base Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Afip_Concepto Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif


    lIsVirtual = .F.
    cBaseClass 		= "oConcepto_Afip"
    cBaseClassLib 	= "Clientes\Archivos\prg\ConceptoAfip.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Afip_Concepto
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Afip_Documento
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (17:43:51)
*!*
*!*

Define Class Afip_Documento As Afip_Base Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Afip_Documento Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif


    lIsVirtual = .F.
    cBaseClass 		= "oDocumento_Afip"
    cBaseClassLib 	= "Clientes\Archivos\prg\DocumentoAfip.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Afip_Documento
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Afip_Alicuota_Iva
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (17:43:51)
*!*
*!*

Define Class Afip_Alicuota_Iva As Afip_Base Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Afip_Alicuota_Iva Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif


    lIsVirtual = .F.
    cBaseClass 		= "oIva_Afip"
    cBaseClassLib 	= "Clientes\Archivos\prg\IvaAfip.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200

            loColFields = This.oColFields

            loField = loColFields.New( "valor", "N", 6, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "%"
                .nLength = 10

            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Afip_Alicuota_Iva
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Afip_Moneda
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (17:43:51)
*!*
*!*

Define Class Afip_Moneda As Afip_Base Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Afip_Moneda Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif


    lIsVirtual = .F.
    cBaseClass 		= "oMoneda_Afip"
    cBaseClassLib 	= "Clientes\Archivos\prg\MonedaAfip.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200

            loColFields = This.oColFields

            loField = loColFields.New( "codigo_afip", "C", 3 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Código Afip"
                .cToolTipText = "Ingrese el Código definido por Afip para la Moneda"
                .lRequired = .T.
                .lCanUpdate = .F.
            Endwith

            loField = loColFields.New( "signo", "C", 6 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Signo"
                .Default = "$"
                *!*	                .cCheck = "!Empty( signo )"
                *!*	                .cErrorMessage = "El SIGNO MONETARIO es obligatorio"
                .cToolTipText = "Ingrese el Signo Monetario: Ej: U$S"
                .lRequired = .T.
            Endwith

            loField = loColFields.New( "cotizacion", "N", 12, 5 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cotización"
                *!*	                .cCheck = "!Empty( cotizacion )"
                *!*	                .cErrorMessage = "La COTIZACIÓN es obligatorio"
                .cToolTipText = "Ingrese la COTIZACIÓN de la Moneda"
                .lRequired = .T.
                .Default = 1

            Endwith

            loField = loColFields.New( "activo", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .Default = .F.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Afip_Moneda
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Afip_Tributo
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (17:43:51)
*!*
*!*

Define Class Afip_Tributo As Afip_Base Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Afip_Tributo Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif


    lIsVirtual = .F.
    cBaseClass 		= "oTributo_Afip"
    cBaseClassLib 	= "Clientes\Archivos\prg\TributoAfip.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Afip_Tributo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Pais
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (17:43:51)
*!*
*!*

Define Class Pais As SistemaBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Pais Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif


    lIsVirtual 		= .F.
    cBaseClass 		= "oPais"
    cBaseClassLib 	= "Clientes\Archivos\prg\Pais.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

            loField = loColFields.New( "cuit_juridica", "C", 11 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                *!*					If .lShowInGrid
                *!*						i = i + 1

                *!*						.nGridOrder = i
                *!*					Endif

                .cCaption = "CUIT Jurídica"
                .cToolTipText = "CUIT para otros países. Dejar en blanco para Argentina"
                .cInputMask = Replicate( "9", 11 )

            Endwith

            loField = loColFields.New( "cuit_fisica", "C", 11 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                *!*					If .lShowInGrid
                *!*						i = i + 1

                *!*						.nGridOrder = i
                *!*					Endif

                .cCaption = "CUIT Física"
                .cToolTipText = "CUIT para otros países. Dejar en blanco para Argentina"

            Endwith

            loField = loColFields.New( "cuit_otro", "C", 11 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                *!*					If .lShowInGrid
                *!*						i = i + 1

                *!*						.nGridOrder = i
                *!*					Endif

                .cCaption = "CUIT Otra"
                .cToolTipText = "CUIT para otros países. Dejar en blanco para Argentina"

            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Pais
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Modulo
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Modulo As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Modulo Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oModulo"
    cBaseClassLib 	= "Clientes\Archivos\prg\Modulo.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Modulo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Provincia
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (17:43:51)
*!*
*!*

Define Class Provincia As SistemaBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Pais Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif


    lIsVirtual 		= .F.
    cBaseClass 		= "oProvincia"
    cBaseClassLib 	= "Clientes\Archivos\prg\Pais.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

            loField = loColFields.New( "pais", "N", 3 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "País"
                *!*					.oCurrentControl.Name 	= "cboPais"
                *!*					.oCurrentControl.Class 	= "cboPais"
                *!*					.oCurrentControl.ClassLibrary 	= "Clientes\Archivos\Prg\Pais.prg"
                .Default = 1
            Endwith


            loField = loColFields.New( "jurisdiccion", "N", 3 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Jurisdicción"
                .cToolTipText 	= "Código de Jurisdicción de Afip"
                .cInputMask 	= Replicate( "9", 3 )
            Endwith

            loField = loColFields.New( "codigo_afip", "N", 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Código Afip"
                .cToolTipText 	= "Código Interno de Afip"
                .cInputMask 	= Replicate( "9", 2 )
            Endwith

            loField = loColFields.New( "denominacion", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Denominación"
                .cToolTipText 	= "En otros paises puede ser: Estado, Departamento, etc."
                .cInputMask 	= Replicate( "X", 20 )
                .Default 		= "Provincia"
            Endwith

            loField = loColFields.New( "percepcion_iibb", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Percepción"
                .cToolTipText 	= "Código contable para Percepciones de IIBB"
                .cInputMask 	= Replicate( "X", 20 )
            Endwith

            loField = loColFields.New( "retencion_iibb", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Retención"
                .cToolTipText 	= "Código contable para Retenciones de IIBB"
                .cInputMask 	= Replicate( "X", 20 )
            Endwith

            loField = loColFields.New( "alias", "C", 50 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Alias"
                .cToolTipText = "Ingrese un Alias único que identifique al Artículo"
                .lRequired = .T. 	&& No se admite blancos
                .lNull = .T.		&& Permite nulos o valores únicos
                .cToolTipText = "Ingrese el ALIAS"
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Provincia
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Grupo
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Grupo As CoreMaestroCodigo Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Grupo Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oGrupo"
    cBaseClassLib 	= "Clientes\Archivos\prg\Grupo.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            loField = loColFields.New( "codigo", "C", 05 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                .nGridMaxLength = 15
            Endwith

            i = 200

            loChoices = Createobject( "Collection" )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Grupo - Subgrupo - Artículo" )
            AddProperty( loItem, "Valor", 1 )
            loChoices.Add( loItem )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Artículo" )
            AddProperty( loItem, "Valor", 2 )
            loChoices.Add( loItem )


            loField = loColFields.New( "arma_descripcion", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Arma la Descripción"
                .Default = 1
                .oChoices = loChoices
            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Grupo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: SubGrupo
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class SubGrupo As CoreMaestroCodigo Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As SubGrupo Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oSubGrupo"
    cBaseClassLib 	= "Clientes\Archivos\prg\Grupo.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            loField = loColFields.New( "codigo", "C", 06 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                .nGridMaxLength = 15
            Endwith

            loField = loColFields.New( "Grupo", "N", 4 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.

                .cCaption = "Grupo"
                .cReferences = "Grupo"
                .lCanUpdate = .F.

                *!*					.oCurrentControl.Name 	= "cboGrupo"
                *!*					.oCurrentControl.Class 	= "cboGrupo"
                *!*					.oCurrentControl.ClassLibrary 	= "Clientes\Archivos\Prg\Grupo.prg"
                .Default = 1
            Endwith


            * Join con Grupo
            * Campos virtuales

            loField = loColFields.New( "grupo_id", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                .cCaption = "Grupo Id"
            Endwith

            loField = loColFields.New( "gupo_codigo", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                .cCaption = "Grupo Código"
            Endwith

            loField = loColFields.New( "grupo_nombre", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                .nGridOrder = 10
                .cCaption = "Grupo (Código)"
                .lCanUpdate = .F.
                .nLength = 30
            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

    *
    *
    * Recibe un Registro y valida los tipos de datos
    Procedure xxxValidateData( oReg As Object ) As Object
        Local lcCommand As String,;
            lcField As String,;
            lcDate As String,;
            lcCentury As String
        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
        Local i As Integer
        Local luValue As Variant,;
            luValid As Variant
        Local loReg As Object

        Try

            lcCommand = ""

            lcDate 		= Set("Date" )
            lcCentury 	= Set("Century" )

            Set Date YMD
            Set Century On

            loColFields = This.oColFields
            loReg = Createobject( "Empty" )

            For Each loField In loColFields

                Try

                    lcField = loField.Name
                    luValue = Evaluate( "oReg." + lcField )

                    If Vartype( luValue ) # "O"

                        TEXT To lcCommand NoShow TextMerge Pretext 15
						luValid = Cast( luValue as <<loField.cFieldType>>( <<loField.nFieldWidth>>, <<loField.nFieldPrecision>> ))
                        ENDTEXT

                        &lcCommand
                        lcCommand = ""

                        AddProperty( loReg, lcField, luValid )

                    Else
                        *AddProperty( loReg, lcField, luValue )
                        If Lower( lcField ) = "grupo"
                            lnId = Cast( oReg.Grupo.Id As I )
                            lcCodigo = Transform( oReg.Grupo.Codigo )
                            lcNombre = Transform( oReg.Grupo.Nombre )

                            lcNombre = lcNombre + " (" + lcCodigo + ")"

                            AddProperty( loReg, "Grupo_Nombre", lcNombre )
                        Endif

                    Endif

                Catch To oErr

                Finally

                Endtry


            Endfor

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            Set Date &lcDate
            Set Century &lcCentury


        Endtry

        Return loReg

    Endproc && ValidateData


Enddefine
*!*
*!* END DEFINE
*!* Class.........: SubGrupo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Rubro_Cliente
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Rubro_Cliente As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Rubro_Cliente Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oRubroCliente"
    cBaseClassLib 	= "Clientes\Archivos\prg\Rubro_Cliente.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Rubro_Cliente
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Rubro_Proveedor
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Rubro_Proveedor As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Rubro_Proveedor Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oRubroProveedor"
    cBaseClassLib 	= "Clientes\Archivos\prg\Rubro_Proveedor.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Rubro_Proveedor
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Talle
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Talle As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Talle Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oTalle"
    cBaseClassLib 	= "Clientes\Archivos\prg\Talle.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

            loField = loColFields.New( "Nombre", "C", 06 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Talle"
                .cToolTipText 	= "Ingrese el Talle"
                .cInputMask 	= Replicate( "!", 06 )
                .lRequired 		= .T.

            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Talle
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Curva_Talle_Cab
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Curva_Talle_Cab As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Curva_Talle_Cab Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oCurvaDeTalles_Cab"
    cBaseClassLib 	= "Clientes\Archivos\prg\CurvaDeTalles.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Curva_Talle_Cab
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Curva_Talle_Det
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Curva_Talle_Det As BaseMaestro Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Curva_Talle_Det Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oCurvaDeTalles_Det"
    cBaseClassLib 	= "Clientes\Archivos\prg\CurvaDeTalles.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

            loField = loColFields.NewFK( "Curva_Talle_Cab", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 	= "Curva de Talles"
                .cFK_Modelo = "Curva_Talle_Cab"
                .lCanUpdate = .F.
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "talle", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                i = i + 1
                .lShowInGrid = .T.
                .nGridOrder = i
                .cCaption = "Talle"
                .cFK_Modelo = "Talle"
                .lNull = .F.
            Endwith

            loField = loColFields.New( "Nombre", "C", 10 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Curva_Talle_Det
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Marca
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Marca As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Marca Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oMarca"
    cBaseClassLib 	= "Clientes\Archivos\prg\Marca.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Marca
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Zona
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Zona As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Zona Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oZona"
    cBaseClassLib 	= "Clientes\Archivos\prg\Zona.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Zona
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Lista_Precios_Venta
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Lista_Precios_Venta As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Lista_Precios_Venta Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oListaDePreciosVenta"
    cBaseClassLib 	= "Clientes\Archivos\prg\ListaDePreciosVenta.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loChoices As Collection

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

            loChoices = Createobject( "Collection" )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Ingreso Precio" )
            AddProperty( loItem, "Valor", 1 )
            loChoices.Add( loItem )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Se Calcula a partir del Costo" )
            AddProperty( loItem, "Valor", 2 )
            loChoices.Add( loItem )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Se Calcula a partir de otra Lista" )
            AddProperty( loItem, "Valor", 3 )
            loChoices.Add( loItem )

            loField = loColFields.New( "forma_de_calculo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Forma de Cálculo"
                .Default = 1
                .oChoices = loChoices

                *!*	                .oCurrentControl.Name	= "cboForma_de_Calculo"
                *!*	                .oCurrentControl.Class	= "Clientes\Archivos\prg\ListaDePreciosVenta.prg"
                .nGridMaxLength = 30

            Endwith


            loField = loColFields.NewFK( "lista_base", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Lista Base"
                *.Default = 1
                .lNull = .T.

                .cReferences = "Lista_Precios_Venta"

                *!*	                .oCurrentControl.Name	= "cboLista_Base"
                *!*	                .oCurrentControl.Class	= "Clientes\Archivos\prg\ListaDePreciosVenta.prg"
                .nGridMaxLength = 30

                .lStr = .F.


            Endwith

            loField = loColFields.New( "Porcentaje", "N", 4, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Recargo sobre Lista Base"
                .Default = 0

            Endwith

            loField = loColFields.NewVirtual( "producto", "I" )

            loField = loColFields.New( "incluye_iva", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                *.Default = .T.
                .cCaption = "Incluye IVA"
                .cToolTipText = "Indica si el precio incluye el IVA"
            Endwith

            loField = loColFields.New( "permite_modificar_precio", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                *.Default = .T.
                .cCaption = "Permite modificar el precio"
                .cToolTipText = "Indica si el precio puede ser modificado por el usuario final"
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Lista_Precios_Venta
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: PreciosDeVenta
*!* Description...:
*!* Date..........: Sábado 6 de Agosto de 2022 (11:45:28)
*!*
*!*
* RA 10/08/2022(12:30:25)
* Esta es una tabla transitoria, para poder mostrar el resultado de la
* consulta de los precios de Venta en la grilla de la solapa
* La API consumida es http://127.0.0.1:8000/archivos/apis/PrecioDeVenta/
Define Class PreciosDeVenta As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"
    #If .F.
        Local This As BaseModel Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    lIsVirtual 		= .F.
    cBaseClass 		= "xxx___oPrecioDeVenta"
    cBaseClassLib 	= "Clientes\Archivos\prg\Producto.prg"

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            i = 100

            loField = loColFields.New( "id", "I" )
            loField = loColFields.NewFK( "articulo", "I" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Artículo"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "lista_precios_venta", "I" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif
                .cCaption = "Lista de Precios"
                .lNull = .F.
            Endwith

            loField = loColFields.New( "lista_precios_venta_orden", "I" )

            loField = loColFields.New( "lista_base", "I" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Lista Base"
                .lNull = .T.
            Endwith


            loField = loColFields.NewVirtual( "forma_de_calculo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Forma de Cálculo"
                .Default = 1

                loChoices = Createobject( "Collection" )

                loItem = Createobject( "Empty" )
                AddProperty( loItem, "Descripcion", "Ingreso Precio" )
                AddProperty( loItem, "Valor", 1 )
                loChoices.Add( loItem )

                loItem = Createobject( "Empty" )
                AddProperty( loItem, "Descripcion", "Se Calcula a partir del Costo" )
                AddProperty( loItem, "Valor", 2 )
                loChoices.Add( loItem )

                loItem = Createobject( "Empty" )
                AddProperty( loItem, "Descripcion", "Se Calcula a partir de otra Lista" )
                AddProperty( loItem, "Valor", 3 )
                loChoices.Add( loItem )

                .oChoices = loChoices

                *!*	                .oCurrentControl.Name	= "cboForma_de_Calculo"
                *!*	                .oCurrentControl.Class	= "Clientes\Archivos\prg\ListaDePreciosVenta.prg"
                .nGridMaxLength = 30

            Endwith


            loField = loColFields.New( "id", "N", 6, 2 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Porcentaje"
            Endwith

            loField = loColFields.New( "margen", "N", 6, 2 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Margen"
            Endwith

            loField = loColFields.NewFK( "moneda", "I" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Moneda"
                .lNull = .F.
            Endwith

            loField = loColFields.New( "cotizacion", "N", 12, 6 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Cotización"
            Endwith

            loField = loColFields.New( "precio", "N", 12, 2 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Precio"
            Endwith

            loField = loColFields.New( "incluye_iva", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Incluye Iva"
            Endwith

            loField = loColFields.New( "alicuota_iva", "N", 6, 2 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Alícuota Iva"
            Endwith

            loField = loColFields.New( "descuento", "N", 6, 2 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Descuento"
            Endwith


            loField = loColFields.New( "coeficiente", "N", 8, 5 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Coeficiente"
            Endwith

            loField = loColFields.NewFK( "proveedor_activo", "I" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Proveedor activo"
                .lNull = .T.
            Endwith


            loField = loColFields.New( "costo_base", "N", 12, 2 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Costo Base"
                .lNull = .T.
            Endwith

            loField = loColFields.New( "costo_base_bonificacion", "N", 8, 5 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Bonificación"
                .lNull = .T.
            Endwith

            *!*	            loField = loColFields.New( "costo_base_bonificaciones", "C", 50 )
            *!*	            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
            *!*	                .cCaption = "Bonificaciones"
            *!*	            EndWith

            loField = loColFields.New( "costo_base_coeficiente", "N", 8, 5 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Costo Base Coeficiente"
                .lNull = .T.
            Endwith

            loField = loColFields.New( "costo_base_recargo", "N", 6, 2 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Costo Base Recargo"
                .lNull = .T.
            Endwith

            loField = loColFields.New( "costo_final", "N", 14, 3 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                .cCaption = "Costo Final"
                .nLength = 14
            Endwith

            loField = loColFields.New( "costo_en_moneda_corriente", "N", 14, 3 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Costo Final en Moneda Corriente"
            Endwith

            loField = loColFields.New( "precio_final", "N", 14, 3 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                .cCaption = "Precio Final"
            Endwith

            loField = loColFields.New( "precio_en_moneda_corriente", "N", 14, 3 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio Final en Moneda Corriente"
                .cHeaderCaption = "Precio"
                .nLength = 14
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: PreciosDeVenta
*!*
*!* ///////////////////////////////////////////////////////



*!* ///////////////////////////////////////////////////////
*!* Class.........: Condicion_Pago
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Condicion_Pago As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Condicion_Pago Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oCondicion_Pago"
    cBaseClassLib 	= "Clientes\Archivos\prg\Condicion_Pago.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Condicion_Pago
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: Presentacion
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Presentacion As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Presentacion Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oPresentacion"
    cBaseClassLib 	= "Clientes\Archivos\prg\Presentacion.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Presentacion
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Clasificacion_Tipo_Articulo
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Clasificacion_Tipo_Articulo As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Clasificacion_Tipo_Articulo Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oClasificacion_Tipo_Articulo"
    cBaseClassLib 	= "Clientes\Archivos\prg\Clasificacion_Tipo_Articulo.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Clasificacion_Tipo_Articulo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Tipo_Articulo
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Tipo_Articulo As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Tipo_Articulo Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oTipo_Articulo"
    cBaseClassLib 	= "Clientes\Archivos\prg\Tipo_Articulo.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields
            i = 200

            loField = loColFields.NewFk( "clasificacion_tipo_articulo", "N", 4 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Clasificación"
                .nLength 		= 20

                .cReferences 	= "Clasificacion_Tipo_Articulo"
                .cToolTipText 	= "Seleccione la Clasificación"
                .lNull 			= .T.
                .lRequired 		= .F.

                *.oCurrentControl.Name	= 'cboClasificacion_Tipo_Articulo'
                *!*	                .oCurrentControl.Name	= "ComboBoxBase"
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"

            Endwith

            loField = loColFields.New( "afecta_stock", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Afecta Stock"
                .cToolTipText 	= "Afecta Stock"
                .Default 		= .T.
                .nLength 		= 10

                *!*	                .oCurrentControl.Name	= 'ChkLogical'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"

            Endwith

            loField = loColFields.New( "afecta_estadistica", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Afecta Estadística"
                .cToolTipText 	= "Afecta Estadística"
                .Default 		= .T.
                .nLength 		= 10

                *!*	                .oCurrentControl.Name	= 'ChkLogical'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"


            Endwith

            loField = loColFields.New( "afecta_comision", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Afecta Comisión"
                .cToolTipText 	= "Afecta Comisión"
                .Default 		= .T.
                .nLength 		= 10

                *!*	                .oCurrentControl.Name	= 'ChkLogical'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"

            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Tipo_Articulo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Unidad_Medida
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Unidad_Medida As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Unidad_Medida Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oUnidad_Medida"
    cBaseClassLib 	= "Clientes\Archivos\prg\Unidad_Medida.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

            loField = loColFields.New( "abreviatura", "C", 5 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Abreviatura"
                .cHeaderCaption = "Abrev."
                .nLength 		= 08
                .cToolTipText 	= "Ingrese el nombre abreviado de la Unidad de Medida"
                .cCheck 		= "!Empty( abreviatura )"
                .cErrorMessage 	= "El NOMBRE ABREVIADO es obligatorio"

            Endwith

            loField = loColFields.New( "cantidad_enteros", "N", 1, 0 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Cantidad de Enteros"
                .cHeaderCaption = "Enteros"
                .nLength 		= 10

                .cCheck 		= "I_ValMay( cantidad_enteros, 0 )"
                .cErrorMessage 	= "La Cantidad de Enteros debe ser Mayor que Cero"

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Ingrese la cantidad de dígitos enteros
				que tiene la Unidad de Medida
                ENDTEXT

                .lRequired = .T.

                *!*	                .oCurrentControl.Name	= 'SpinnerBase'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"

            Endwith

            loField = loColFields.New( "cantidad_decimales", "N", 1, 0 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption 		= "Cantidad de Decimales"
                .cHeaderCaption = "Decimales"
                .nLength 		= 12

                .cCheck 		= "I_ValMoi( cantidad_decimales, 0 )"
                .cErrorMessage 	= "La Cantidad de Enteros debe ser Mayor o Igual que Cero"

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Ingrese la cantidad de decimales
				que tiene la Unidad de Medida
                ENDTEXT

                .lRequired = .F.

                *!*	                .oCurrentControl.Name	= 'SpinnerBase'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"

            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Unidad_Medida
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: Articulo
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Articulo As CoreMaestroCodigo Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Articulo Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oProducto"
    cBaseClassLib 	= "Clientes\Archivos\prg\Producto.prg"
    cModelo 		= "Producto"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            loField = loColFields.New( "codigo", "C", 50 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                .cToolTipText = "El CODIGO será generado automáticamente"
                .nGridMaxLength = 15
            Endwith

            loField = loColFields.New( "nombre", "C", 150 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .nGridMaxLength = 80
                .lStr = .T.
                .cToolTipText = "Ingrese el NOMBRE del artículo"
                .lFitColumn = .F.
            Endwith


            i = 200

            loField = loColFields.NewFK( "Grupo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Grupo"
                .cReferences = "Grupo"
                .lRequired = .T.
                .cToolTipText = "Seleccione el GRUPO"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "SubGrupo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Sub Grupo"
                .cReferences = "SubGrupo"
                .lRequired = .T.
                .lNull = .F.

                .cToolTipText = "Seleccione el SUBGRUPO"
            Endwith

            loField = loColFields.NewFK( "Marca", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Marca"
                .cReferences = "Marca"
                .lRequired = .F.
                .lNull = .T.

                .cToolTipText = "Seleccione la MARCA"
            Endwith

            loField = loColFields.NewFK( "Rubro_Cliente", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Rubro"
                .cReferences = "Rubro_Cliente"
                .lRequired = .F.
                .lNull = .T.

                .cToolTipText = "Seleccione el RUBRO"

            Endwith

            loField = loColFields.NewFK( "Presentacion", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Presentacion"
                .cReferences = "Presentacion"
                .lRequired = .F.
                .lNull = .T.


                .cToolTipText = "Seleccione la PRESENTACION"

            Endwith

            loField = loColFields.NewFK( "afip_alicuota_iva", "I")
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Alicuota Iva"
                .cReferences = "afip_alicuota_iva"
                .lRequired = .T.
                .lNull = .F.

                .cToolTipText = "Seleccione la ALICUOTA DEL IVA"

            Endwith

            loField = loColFields.New( "Nombre_Abreviado", "C", 50 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Nombre"
                .lRequired = .T.


                .cToolTipText = "Ingrese el NOMBRE ABREVIADO"
            Endwith

            loField = loColFields.New( "codigo_barra", "C", 13 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Código de Barras"
                .lRequired = .F. 	&& No se admite blancos
                .lNull = .T.		&& Permite nulos o valores únicos
                .cToolTipText = "Ingrese el CODIGO DE BARRAS"
            Endwith

            loField = loColFields.New( "alias", "C", 50 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Alias"
                .cToolTipText = "Ingrese un Alias único que identifique al Artículo"
                .lRequired = .T. 	&& No se admite blancos
                .lNull = .T.		&& Permite nulos o valores únicos
                .cToolTipText = "Ingrese el ALIAS"
            Endwith


            loField = loColFields.NewFK( "tipo_articulo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Tipo de Artículo"
                .cReferences = "tipo_articulo"
                .lRequired = .F.
                .lNull = .T.

                .cToolTipText = "Seleccione el TIPO DE ARTICULO"

            Endwith

            loField = loColFields.NewFK( "unidad_medida", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Unidad de Medida"
                .cReferences = "unidad_medida"
                .lRequired = .T.
                .lNull = .F.
                .cToolTipText = "Seleccione la UNIDAD DE MEDIDA"

            Endwith

            loField = loColFields.New( "stock_negativo", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .Default = .F.
                .cCaption = "Stock Negativo"
                .cToolTipText = "Indica si se permite Stock Negativo"
            Endwith

            loField = loColFields.New( "fecha_ultima_venta", "D" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Fecha Última Venta"
                .cToolTipText = "Fecha Última Venta"
                .lRequired = .F.
                .lCanUpdate = .F.
                .lNull = .T.

            Endwith

            loField = loColFields.New( "Fecha_Utima_Compra", "D" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Fecha"
                .cToolTipText = "Fecha Última Compra"
                .lRequired = .F.
                .lCanUpdate = .F.
                .lNull = .T.
            Endwith

            loField = loColFields.NewFK( "Proveedor_Ultima_Compra", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Proveedor"
                .cToolTipText = "Proveedor de Última Compra"
                .cReferences = "Organizacion_Proveedor"
                .lRequired = .F.
                .lNull = .T.
                .lReadOnly = .T.

            Endwith

            loField = loColFields.New( "precio_ultima_compra", "N", 14, 02 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio"
                .cToolTipText = "Precio de Última Compra"
                .lRequired = .F.
                .lCanUpdate = .F.
            Endwith

            loField = loColFields.New( "precio_ultima_compra_con_signo", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio"
                .cToolTipText = "Precio de Última Compra"
                .nGridAlignment = ALIGN_RIGHT
                .lReadOnly = .T.

            Endwith



            loField = loColFields.New( "precio_ultima_compra_en_pesos", "N", 14, 02 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio en $"
                .cToolTipText = "Precio de Última Compra en Pesos"
                .lRequired = .F.
                .lReadOnly = .T.
                .cFormat = "@Z "
            Endwith

            loField = loColFields.NewFK( "moneda_ultima_compra", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Moneda Última Compra"
                .cReferences = "Moneda"
                .lRequired = .F.
                .lNull = .T.

            Endwith

            loField = loColFields.New( "cotizacion_ultima_compra", "N", 12, 5 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Cotización Última Compra"
                .cToolTipText = ""
                .lRequired = .T.
                .Default = 1
            Endwith

            loField = loColFields.New( "cantidad_ultima_compra", "N", 14, 04 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cantidad"
                .cToolTipText = "Última Cantidad comprada"
                .lRequired = .F.
                .lCanUpdate = .F.
                .cFormat = "@Z "
            Endwith

            loField = loColFields.NewFK( "Proveedor_Activo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Proveedor Activo"
                .lRequired = .F.
                .lNull = .T.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

    Procedure xxxValidateData( oReg As Object ) As Object
        Local lcCommand As String
        Local loReg As Object

        Try

            lcCommand = ""

            If Pemstatus( oReg, "ABM", 5 )


                If oReg.ABM = ABM_ALTA
                    oReg.Nombre = Sys(2015)
                    oReg.Codigo = Sys(2015)
                    oReg.cliente_praxis = 1
                    oReg.empresa = 1
                    oReg.rubro = Null
                    oReg.marca = Null
                    oReg.presentacion = Null
                    oReg.afip_alicuota_iva = 3

                    oReg.activo=.T.
                    oReg.orden = 500
                Endif
            Endif

            loReg = DoDefault( oReg )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry

        Return loReg

    Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: Articulo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Articulo_Proveedor
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Articulo_Proveedor As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Articulo_Proveedor Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oPrecioDeCompra"
    cBaseClassLib 	= "Clientes\Archivos\prg\Producto.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields
            i = 200

            loField = loColFields.NewFK( "Proveedor", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Proveedor"
                .lRequired = .F.
                .lNull = .T.
            Endwith

            loField = loColFields.NewFK( "moneda", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Moneda"
                .lNull = .F.
                .nGridMaxLength = 8
                .cGridColumnControlSource = "str_Signo"
                .nGridAlignment = ALIGN_CENTER

            Endwith

            loField = loColFields.New( "Costo_Base", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio Base"
                .cToolTipText = "Ingrese el Costo Base"
                .nGridMaxLength = 15
            Endwith

            loField = loColFields.New( "Costo_Base_con_signo", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio Base"
                .cToolTipText = ""
                .nGridMaxLength = 20
                *.nAlignment = ALIGN_RIGHT
                .nGridAlignment = ALIGN_RIGHT
            Endwith


            loField = loColFields.New( "condiciones", "C", 30 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Condiciones"
                .cToolTipText = "ingrese dígitos y signos ( '+', '-' o '*' ) para aplicar al Precio Base"
                .nGridMaxLength = 20
                .lFitColumn = .T.

            Endwith

            *!*	            loField = loColFields.New( "bonificaciones", "C", 30 )
            *!*	            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*	                .lShowInGrid = .T.
            *!*	                If .lShowInGrid
            *!*	                    i = i + 1

            *!*	                    .nGridOrder = i
            *!*	                Endif

            *!*	                .cCaption = "Bonificaciones"
            *!*	                .cToolTipText = "ingrese dígitos y signos (+-*/) para aplicar al Costo Base"
            *!*	                .nGridMaxLength = 20
            *!*	                .lFitColumn = .T.

            *!*	            Endwith

            *!*	            loField = loColFields.New( "recargo", "N", 6, 2 )
            *!*	            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*	                .lShowInGrid = .T.
            *!*	                If .lShowInGrid
            *!*	                    i = i + 1

            *!*	                    .nGridOrder = i
            *!*	                Endif

            *!*	                .cCaption = "Costo Financiero"
            *!*	                .cToolTipText = "Ingrese el recargo por la financiación"
            *!*	                .nGridMaxLength = 10
            *!*	            Endwith

            *!*	            loField = loColFields.New( "coeficiente", "N", 8, 4 )
            *!*	            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*	                .lShowInGrid = .T.
            *!*	                If .lShowInGrid
            *!*	                    i = i + 1

            *!*	                    .nGridOrder = i
            *!*	                Endif

            *!*	                .cCaption = "Coeficiente"
            *!*	                .cToolTipText = "Coeficiente que se aplica para calcular el Costo Final"
            *!*	                .Default = 1
            *!*	                .nGridMaxLength = 10
            *!*	            Endwith


            * Costo Final
            * Campo calculado
            loField = loColFields.New( "Costo_Final_Calculado", "N", 14, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio"
                .cToolTipText = ""
                .lReadOnly = .T.
                *.nLength = 14
                .nGridMaxLength = 15
            Endwith

            loField = loColFields.New( "Costo_Final_con_signo", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio"
                .cToolTipText = ""
                .nGridMaxLength = 20
                .nGridAlignment = ALIGN_RIGHT
            Endwith


            * Costo En Moneda Corriente
            * Campo calculado
            loField = loColFields.New( "Costo_En_Moneda_Corriente", "N", 14, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio en Pesos"
                .cHeaderCaption = "Precio en Pesos"
                .cToolTipText = ""
                .lReadOnly = .T.
                .nGridMaxLength = 15
            Endwith

            ************************************************************

            loField = loColFields.New( "nombre", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                .cCheck = ""
                .cErrorMessage = ""
                .lRequired = .F.
            Endwith

            loField = loColFields.NewFK( "articulo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 		= "Artículo"
                .lNull 			= .F.
                .lRequired 		= .T.

            Endwith



            loField = loColFields.New( "codigo", "C", 30 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                .cCaption = "Código del Artículo para el Proveedor"
                .cToolTipText = "Ingrese el Código del Proveedor"
                .nGridMaxLength = 15
            Endwith


            *!*	            loField = loColFields.New( "cotizacion", "N", 12, 5 )
            *!*	            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*	                .cCaption = "Cotización"
            *!*	                *!*	                .cCheck = "!Empty( cotizacion )"
            *!*	                *!*	                .cErrorMessage = "La COTIZACIÓN es obligatorio"
            *!*	                .cToolTipText = "Ingrese la COTIZACIÓN de la Moneda al momento de la compra"
            *!*	                .lRequired = .T.
            *!*	                .Default = 1
            *!*	            Endwith




            * Bonificacion
            * No se muestra
            * se compone para reflejar el coeficiente
            * que representa al campo Bonificaciones
            *!*	            loField = loColFields.New( "bonificacion", "N", 8, 4 )
            *!*	            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*	                .cCaption = "Bonificación"
            *!*	                .cToolTipText = ""
            *!*	                .Default = 1
            *!*	            Endwith

            * No se muestra
            * se compone para reflejar el coeficiente
            * que representa al campo Condiciones
            loField = loColFields.New( "condiciones_coeficiente", "N", 8, 4 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "condiciones_coeficiente"
                .cToolTipText = ""
                .Default = 1
            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Articulo_Proveedor
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: PreciosDeCosto
*!* Description...:
*!* Date..........: Miércoles 14 de Septiembre de 2022 (11:37:57)
*!*
*!*
Define Class PreciosDeCosto As Articulo_Proveedor Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #If .F.
        Local This As Articulo_Venta Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .T.
    cBaseClass 		= "oPreciosDeCostoPorRango"
    cBaseClassLib 	= "Clientes\Ventas\Prg\PreciosPorRango.prg"
    cModelo			= "Precios_Costo"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields
            i = 200

            loField = loColFields.NewFK( "articulo__codigo", "C", 50 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 		= "Artículo"
                .cInputMask 	= "999-99-999"

                .nShowInFilter 			= 0
                .lFilterEsSistema 		= .F.
                .lFilterActivo 			= .F.
                .cFilterDataType 		= "C"
                .cFilterFieldName 		= "articulo__codigo"
                .cFilterLookUpInclude 	= ["exact","range"]
                *.cFilterLookUpExclude = ["startswith","endswith","range","gt","lt"]

            Endwith

            loField = loColFields.NewFK( "articulo__Grupo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Grupo"
                .cFK_Modelo = "Grupo"
                .lRequired = .T.

                .nShowInFilter 	= 2
                .lFilterEsSistema = .T.
                .lFilterActivo 			= .F.
                .cFilterDataType = "I"
                .cFilterFieldName = "articulo__grupo"
                .cFilterLookUpInclude = ["exact"]


            Endwith

            loField = loColFields.NewFK( "articulo__SubGrupo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Sub Grupo"
                .cFK_Modelo = "SubGrupo"

                .lRequired = .T.

                .nShowInFilter 	= 3
                .lFilterEsSistema = .T.
                .lFilterActivo 			= .F.
                .cFilterDataType = "I"
                .cFilterFieldName = "articulo__subgrupo"
                .cFilterLookUpInclude = ["exact"]

            Endwith


            loField = loColFields.NewFK( "proveedor", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Proveedor"
                .cFK_Modelo = "Organizacion_Proveedor"

                .nShowInFilter 	= 1
                .lFilterEsSistema = .T.
                .lFilterActivo 			= .T.
                .cFilterControl = 'selector'
                .cFilterDataType = "I"
                .cFilterFieldName = "proveedor"
                .cFilterLookUpInclude = ["exact"]

            Endwith

            loField = loColFields.NewFK( "moneda", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Moneda"
                .Default = 1

                .cFK_Modelo = "Moneda"

                .nShowInFilter 	= 5
                .lFilterEsSistema = .F.
                .lFilterActivo 			= .F.
                .cFilterDataType = "I"
                .cFilterFieldName = "moneda"
                .cFilterLookUpInclude = ["exact"]

            Endwith

            loField = loColFields.NewFK( "Marca", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Marca"
                .cReferences = "Marca"
                .lRequired = .F.
                .lNull = .T.

                .nShowInFilter 	= 4
                .lFilterEsSistema = .F.
                .lFilterActivo 			= .F.
                .cFilterDataType = "C"
                .cFilterFieldName = "marca"
                .cFilterLookUpInclude = ["exact"]

            Endwith


            loField = loColFields.New( "bonificaciones", "C", 30 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                .cCaption = "Bonificaciones"
                .cToolTipText = "ingrese dígitos y signos (+-*/) para aplicar al Costo Base"
                .nGridMaxLength = 50

                .nShowInFilter 	= 0
                .lFilterEsSistema = .F.
                .cFilterDataType = "C"
                .cFilterFieldName = "bonificaciones"
                .cFilterLookUpInclude = ["exact"]

            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

    *
    *
    Procedure CrearCursor( cAlias As String ) As String
        Local lcCommand As String
        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
        Local i As Integer,;
            lnFieldCount As Integer

        Try

            lcCommand = ""

            lcAlias = DoDefault( cAlias )

            TEXT To lcCommand NoShow TextMerge Pretext 15
            Select 	Space( 050 ) as str_codigo,
		            Space( 200 ) as str_articulo,
		            Space( 200 ) as str_grupo,
		            Space( 200 ) as str_subgrupo,
		            Space( 200 ) as str_marca,
		            id,
		            nombre,
		            Cast(0 as I ) as cliente_praxis_id,
		            Cast(0 as I ) as articulo_id,
		            uts,
		            recargo,
		            activo,
		            moneda,
		            cotizacion,
		            bonificaciones,
		            bonificacion,
		            costo_base
		    	From <<lcAlias>>
		    	Into Cursor <<lcAlias>> ReadWrite
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

        Endtry

        Return lcAlias

    Endproc && CrearCursor


Enddefine
*!*
*!* END DEFINE
*!* Class.........: PreciosDeCosto
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: Articulo_Venta
*!* Description...:
*!* Date..........: Jueves 21 de Julio de 2022 (10:25:37)
*!*
*!*

Define Class Articulo_Venta As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Articulo_Venta Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oPrecioDeVenta"
    cBaseClassLib 	= "Clientes\Archivos\prg\Producto.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields
            i = 200


            loField = loColFields.NewFK( "lista_precios_venta", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Lista de Precios"
                .lFitColumn = .T.
                .lNull = .F.

            Endwith

            loField = loColFields.NewFK( "moneda", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Moneda"
                .lNull = .F.
                .nGridMaxLength = 8
                .cGridColumnControlSource = "str_Signo"
                .nGridAlignment = ALIGN_CENTER
                .cToolTipText = "Seleccione la Moneda de Venta"

            Endwith

            loField = loColFields.NewFK( "moneda_precio_base", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Moneda Precio Base"
                .lNull = .F.
                .nGridMaxLength = 8
                .cToolTipText = "Moneda Precio Base"
            Endwith

            * Precio Base
            loField = loColFields.New( "Precio_Base_Calculado", "N", 14, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Neto Base"
                .cToolTipText = ""
                .lReadOnly = .T.
                .nGridMaxLength = 15
            Endwith

            loField = loColFields.New( "Precio_Base_con_signo", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Neto Base"
                .cToolTipText = ""
                .nGridMaxLength = 20
                .nAlignment = ALIGN_RIGHT
                .nGridAlignment = ALIGN_RIGHT
            Endwith


            *!*	            loField = loColFields.New( "margen", "N", 6, 2 )
            *!*	            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*	                            .lShowInGrid = .F.
            *!*	                If .lShowInGrid
            *!*	                    i = i + 1

            *!*	                    .nGridOrder = i
            *!*	                Endif

            *!*	                .cCaption = "Margen"
            *!*	                .cToolTipText = "Ingrese el Margen de ganancia"
            *!*	                .nGridMaxLength = 8
            *!*	            Endwith

            *!*	            loField = loColFields.New( "descuento", "N", 6, 2 )
            *!*	            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*	                            .lShowInGrid = .F.
            *!*	                If .lShowInGrid
            *!*	                    i = i + 1

            *!*	                    .nGridOrder = i
            *!*	                Endif

            *!*	                .cCaption = "Descuento"
            *!*	                .cToolTipText = "Ingrese el Descuento"
            *!*	                .nGridMaxLength = 8
            *!*	            Endwith

            *!*	            loField = loColFields.New( "coeficiente", "N", 8, 4 )
            *!*	            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*	                .lShowInGrid = .F.
            *!*	                If .lShowInGrid
            *!*	                    i = i + 1

            *!*	                    .nGridOrder = i
            *!*	                Endif

            *!*	                .cCaption = "Coeficiente"
            *!*	                .cToolTipText = "Coeficiente que se aplica para calcular el Costo Final"
            *!*	                .Default = 1
            *!*	                .nGridMaxLength = 8
            *!*	            EndWith

            loField = loColFields.New( "condiciones", "C", 30 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Condiciones"
                .cToolTipText = "ingrese dígitos y signos ( '+', '-' o '*' ) para aplicar al Precio Base"
                .nGridMaxLength = 20
                .lFitColumn = .T.

            Endwith


            * Precio Venta
            loField = loColFields.New( "Precio_Venta_Calculado", "N", 14, 3 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio"
                .cToolTipText = ""
                .lReadOnly = .F.
                .nGridMaxLength = 15
            Endwith

            loField = loColFields.New( "Precio_Venta_con_signo", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio"
                .cToolTipText = ""
                .nGridMaxLength = 20
                .nAlignment = ALIGN_RIGHT
                .nGridAlignment = ALIGN_RIGHT
            Endwith

            * Precio En Moneda Corriente
            * Campo calculado
            loField = loColFields.New( "Precio_Venta_En_Moneda_Corriente", "N", 14, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio en Pesos"
                *.cHeaderCaption = "Precio en Pesos"
                .cToolTipText = ""
                .lReadOnly = .T.
                .nGridMaxLength = 15
            Endwith


            ****************************************************************

            loField = loColFields.New( "nombre", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                .cCheck = ""
                .cErrorMessage = ""
                .lRequired = .F.
            Endwith

            loField = loColFields.NewFK( "articulo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 		= "Artículo"
                .lNull 			= .F.
                .lRequired 		= .T.
            Endwith

            loField = loColFields.NewFK( "lista_precios_base", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Lista de Precios Base"
                .lNull = .T.

            Endwith

            loField = loColFields.NewVirtual( "forma_de_calculo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Forma de Cálculo"
                .Default = 1

                loChoices = Createobject( "Collection" )

                loItem = Createobject( "Empty" )
                AddProperty( loItem, "Descripcion", "Ingreso Precio" )
                AddProperty( loItem, "Valor", 1 )
                loChoices.Add( loItem )

                loItem = Createobject( "Empty" )
                AddProperty( loItem, "Descripcion", "Se Calcula a partir del Costo" )
                AddProperty( loItem, "Valor", 2 )
                loChoices.Add( loItem )

                loItem = Createobject( "Empty" )
                AddProperty( loItem, "Descripcion", "Se Calcula a partir de otra Lista" )
                AddProperty( loItem, "Valor", 3 )
                loChoices.Add( loItem )

                .oChoices = loChoices

                *!*	                .oCurrentControl.Name	= "cboForma_de_Calculo"
                *!*	                .oCurrentControl.Class	= "Clientes\Archivos\prg\ListaDePreciosVenta.prg"
                .nGridMaxLength = 30

            Endwith

            loField = loColFields.NewVirtual( "lista_base", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Lista Base"
                *.Default = 1
                .lNull = .T.

                .cReferences = "Lista_Precios_Venta"

                *!*	                .oCurrentControl.Name	= "cboLista_Base"
                *!*	                .oCurrentControl.Class	= "Clientes\Archivos\prg\ListaDePreciosVenta.prg"
                .nGridMaxLength = 30

            Endwith




            loField = loColFields.NewVirtual( "cotizacion", "N", 12, 5 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Cotización"
            Endwith


            loField = loColFields.New( "Precio_Venta", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio"
                .cToolTipText = "Ingrese el Precio de Venta"
            Endwith


            loField = loColFields.New( "incluye_iva", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                *.Default = .T.
                .cCaption = "Incluye IVA"
                .cToolTipText = "Indica si el precio incluye el IVA"
                .lReadOnly = .T.
            Endwith

            loField = loColFields.New( "alicuota_iva", "N", 6, 2 )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                *.Default = .T.
                .cCaption = "Alícuota IVA"
                .cToolTipText = "Alícuota IVA"
                .lReadOnly = .T.
            Endwith

            * Costo Final
            loField = loColFields.New( "precio_costo", "N", 14, 3 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Costo Final"
                .cToolTipText = ""
                .lReadOnly = .T.
            Endwith

            * Costo En Moneda Corriente
            * Campo calculado
            loField = loColFields.New( "costo_en_moneda_corriente", "N", 14, 3 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Costo Final en Moneda Corriente"
                .cHeaderCaption = "Costo Final"
                .cToolTipText = ""
                .lReadOnly = .T.
            Endwith



            * Precio Calculado
            loField = loColFields.New( "Precio_Calculado", "N", 14, 3 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Precio Calculado"
                .cToolTipText = ""
                .lReadOnly = .T.
            Endwith


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

    *
    *
    Procedure xxx___Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields
            i = 200

            loField = loColFields.New( "nombre", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                *!*	                .cCheck = ""
                *!*	                .cErrorMessage = ""
                .lRequired = .F.
            Endwith

            loField = loColFields.NewFK( "articulo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 		= "Artículo"
                .lNull 			= .F.
                .lRequired 		= .T.
                .lStr 			= .F.
            Endwith

            loField = loColFields.NewVirtual( "str_articulo", "C", 100 )

            loField = loColFields.NewFK( "lista_precios_venta", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Lista de Precios"
                .lStr = .F.
                .lNull = .F.

                *!*	                .oCurrentControl.Name	= "cboTipo_Documento"
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"
                *!*	                .nGridMaxLength = 12


            Endwith

            loField = loColFields.NewVirtual( "str_lista_precios_venta", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif
                .cCaption = "Lista de Precios"
            Endwith
            loField = loColFields.NewVirtual( "forma_de_calculo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Forma de Cálculo"
                .Default = 1

                loChoices = Createobject( "Collection" )

                loItem = Createobject( "Empty" )
                AddProperty( loItem, "Descripcion", "Ingreso Precio" )
                AddProperty( loItem, "Valor", 1 )
                loChoices.Add( loItem )

                loItem = Createobject( "Empty" )
                AddProperty( loItem, "Descripcion", "Se Calcula a partir del Costo" )
                AddProperty( loItem, "Valor", 2 )
                loChoices.Add( loItem )

                loItem = Createobject( "Empty" )
                AddProperty( loItem, "Descripcion", "Se Calcula a partir de otra Lista" )
                AddProperty( loItem, "Valor", 3 )
                loChoices.Add( loItem )

                .oChoices = loChoices

                *!*	                .oCurrentControl.Name	= "cboForma_de_Calculo"
                *!*	                .oCurrentControl.Class	= "Clientes\Archivos\prg\ListaDePreciosVenta.prg"
                .nGridMaxLength = 30

            Endwith

            loField = loColFields.NewVirtual( "lista_base", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Lista Base"
                *.Default = 1
                .lNull = .T.

                .cReferences = "Lista_Precios_Venta"

                *!*	                .oCurrentControl.Name	= "cboLista_Base"
                *!*	                .oCurrentControl.Class	= "Clientes\Archivos\prg\ListaDePreciosVenta.prg"
                .nGridMaxLength = 30

                .lStr = .F.
            Endwith



            loField = loColFields.NewFK( "moneda", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Moneda de Venta"
                .Default = 1
            Endwith

            loField = loColFields.NewVirtual( "cotizacion", "N", 12, 5 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Cotización"
            Endwith

            loField = loColFields.New( "margen", "N", 6, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Margen"
                .cToolTipText = "Ingrese el Margen de ganancia"
            Endwith

            loField = loColFields.New( "descuento", "N", 6, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Descuento"
                .cToolTipText = "Ingrese el Descuento"
            Endwith

            loField = loColFields.New( "Precio", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio"
                .cToolTipText = "Ingrese el Precio de Venta"
            Endwith

            loField = loColFields.New( "coeficiente", "N", 8, 4 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Coeficiente"
                .cToolTipText = "Coeficiente que se aplica para calcular el Costo Final"
                .Default = 1
            Endwith

            loField = loColFields.New( "incluye_iva", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                *.Default = .T.
                .cCaption = "Incluye IVA"
                .cToolTipText = "Indica si el precio incluye el IVA"
            Endwith

            * Costo Final
            * Campo calculado
            loField = loColFields.New( "costo_final", "N", 14, 3 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Costo Final"
                .cToolTipText = ""
                .lReadOnly = .T.
            Endwith

            * Costo En Moneda Corriente
            * Campo calculado
            loField = loColFields.New( "costo_en_moneda_corriente", "N", 14, 3 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Costo Final en Moneda Corriente"
                .cHeaderCaption = "Costo Final"
                .cToolTipText = ""
                .lReadOnly = .T.
            Endwith


            * Precio Final
            * Campo calculado
            loField = loColFields.New( "Precio_Final", "N", 14, 3 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Precio Final"
                .cToolTipText = ""
                .lReadOnly = .T.
            Endwith

            * Precio En Moneda Corriente
            * Campo calculado
            loField = loColFields.New( "Precio_En_Moneda_Corriente", "N", 14, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Precio Final en Moneda Corriente"
                .cHeaderCaption = "Precio Final"
                .cToolTipText = ""
                .lReadOnly = .T.
                .nLength = 100
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && xxx___Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Articulo_Venta
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: Organizacion
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Organizacion As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Organizacion Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oOrganizacion"
    cBaseClassLib 	= "Clientes\Archivos\prg\Organizacion.prg"
    cModelo 		= "Organizacion"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200

            loColFields = This.oColFields

            loField = loColFields.New( "nombre", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Razón Social"
                .cToolTipText = "Ingrese la Razón Social"
                .lRequired = .T.
                .nLength = 30

            Endwith

            loField = loColFields.New( "alias_cliente", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Alias Cliente"
                .cToolTipText = "Ingrese el Alias del Cliente"

                .lNull = .T.
                .lRequired = .F.
                .nLength = 20

            Endwith

            loField = loColFields.New( "alias_proveedor", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Alias Proveedor"
                .cToolTipText = "Ingrese el Alias del Proveedor"

                .lNull = .T.
                .lRequired = .F.
                .nLength = 20

            Endwith

            loField = loColFields.New( "codigo", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Código Interno"
                .cToolTipText = "Ingrese el Código Interno"

                .lNull = .T.
                .lRequired = .F.
                .nGridMaxLength = 12

            Endwith

            loField = loColFields.New( "nombre_fantasia", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Nombre Fantasía"
                .cToolTipText = "Ingrese el Nombre Fantasía"
                .nGridMaxLength = 20

            Endwith

            loField = loColFields.NewFK( "tipo_documento", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Tipo de Documento"
                .lNull = .F.

                *!*	                .oCurrentControl.Name	= "ComboBoxBase"
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"
                .nGridMaxLength = 12


            Endwith

            loField = loColFields.New( "documento_numero", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Nº de Documento"
                .cToolTipText = "Ingrese el Número del Documento"
                .nGridMaxLength = 15

            Endwith


            loField = loColFields.NewFK( "Condicion_Iva", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Condición Iva"
                .lNull = .F.

                *!*	                .oCurrentControl.Name	= "ComboBoxBase"
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"
                .nGridMaxLength = 25

            Endwith

            loField = loColFields.New( "domicilio", "M" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Domicilio"
                .cToolTipText = "Ingrese el Domicilio"

            Endwith

            loField = loColFields.New( "codigo_postal", "C", 8 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Código Postal"
                .cToolTipText = "Ingrese el Código Postal"

                .lRequired = .F.

            Endwith


            loField = loColFields.NewFK( "Pais", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "País"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "Provincia", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Provincia"
                .lNull = .F.

                *!*	                .oCurrentControl.Name	= "ComboBoxBase"
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"
                .nGridMaxLength = 20

            Endwith

            loField = loColFields.New( "localidad", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Localidad"
                *!*	                .cCheck = "I_ValObl( direccion_localidad )"
                *!*	                .cErrorMessage = "La Localidad es Obligatoria"
                .cToolTipText = "Ingrese la Localidad"

                .lRequired = .T.
                .nGridMaxLength = 25

            Endwith


            loField = loColFields.New( "fecha_ingreso", "D" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Fecha de Ingreso"
                .cToolTipText = "Ingrese la Fecha de Ingreso"
            Endwith

            loField = loColFields.New( "pagina_web", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Página Web"
                .cToolTipText = "Ingrese la Página Web"

            Endwith

            loField = loColFields.New( "es_cliente", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .Default = .F.
                .cCaption = "Es Cliente"
            Endwith

            loField = loColFields.New( "es_proveedor", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .Default = .F.
                .cCaption = "Es Proveedor"
            Endwith

            loField = loColFields.NewVirtual( "Cliente_Id", "I" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i * -1
                Endif

                .lNull = .T.

            Endwith

            loField = loColFields.NewVirtual( "Proveedor_Id", "I" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i * -1
                Endif

                .lNull = .T.

            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Organizacion
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Organizacion_Cliente
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

*Define Class Organizacion_Cliente As BaseModel Of "Clientes\Utiles\prg\utDataDictionary.prg"
Define Class Organizacion_Cliente As Organizacion Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Organizacion_Cliente Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oCliente"
    cBaseClassLib 	= "Clientes\Archivos\prg\OrganizacionCliente.prg"
    cModelo 		= "Organizacion_Cliente"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200


            loColFields = This.oColFields


            loField = loColFields.NewFK( "organizacion", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Organización"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "rubro_cliente", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Rubro"
            Endwith

            loField = loColFields.NewFK( "vendedor", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Vendedor"
            Endwith

            loField = loColFields.NewFK( "lista_precios_venta", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Lista de Precios"
            Endwith

            loField = loColFields.NewFK( "condicion_pago", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Condición de Pago"
            Endwith

            loField = loColFields.New( "descuento", "N", 5, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Descuento"
                .Default = 1
            Endwith

            loField = loColFields.New( "descuento_adicional", "N", 5, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Descuento Adicional"
                .Default = 1
            Endwith

            loField = loColFields.New( "recargo", "N", 5, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Recargo"
                .Default = 1
            Endwith

            loField = loColFields.NewFK( "moneda", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Moneda"
                .lNull = .F.
            Endwith

            loField = loColFields.New( "credito_cta_cte", "N", 14, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Crédito en Cuenta Corriente"
                .Default = 1
            Endwith

            loField = loColFields.New( "credito_valores", "N", 14, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Crédito en Cuenta Corriente"
                .Default = 1
            Endwith

            loField = loColFields.NewFK( "cuenta_contable", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Cuenta Contable"
                .lNull = .F.
            Endwith

            loField = loColFields.New( "ultima_factura", "D" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Fecha de Última Factura"
                .cToolTipText = "Fecha de Última Factura"
            Endwith

            loField = loColFields.New( "clausula", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .Default = .F.
                .cCaption = "Cláusula Moneda Extranjera"
            Endwith

            loField = loColFields.New( "activo", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .Default = .T.
                .cCaption = "Activo"
                .nGridOrder = i
                *!*	                .oCurrentControl.Name	= 'ChkLogical'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"
                .cToolTipText = "Indica si el registro se muestra en todas las consultas"
            Endwith

            loField = loColFields.New( "observacion", "M" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Observación"
                .cToolTipText = "Ingrese una referencia del Cliente"
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Organizacion_Cliente
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Organizacion_Proveedor
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

*Define Class Organizacion_Proveedor As BaseModel Of "Clientes\Utiles\prg\utDataDictionary.prg"
Define Class Organizacion_Proveedor As Organizacion Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #If .F.
        Local This As Organizacion_Proveedor Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oProveedor"
    cBaseClassLib 	= "Clientes\Archivos\prg\OrganizacionProveedor.prg"
    cModelo 		= "Organizacion_Proveedor"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200


            loColFields = This.oColFields


            loField = loColFields.NewFK( "organizacion", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Organización"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "rubro", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Rubro"
            Endwith

            loField = loColFields.NewFK( "cuenta_contable", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Cuenta Contable"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "condicion_pago", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Condición de Pago"
            Endwith

            loField = loColFields.New( "ultima_factura", "D" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Fecha de Última Factura"
                .cToolTipText = "Fecha de Última Factura"
            Endwith

            loField = loColFields.New( "activo", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .Default = .T.
                .cCaption = "Activo"
                .nGridOrder = i
                *!*	                .oCurrentControl.Name	= 'ChkLogical'
                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"
                .cToolTipText = "Indica si el registro se muestra en todas las consultas"
            Endwith

            loField = loColFields.New( "observacion", "M" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Observación"
                .cToolTipText = "Ingrese una referencia del Cliente"
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize

    *
    *
    Procedure xxx___CrearCursor( cAlias As String ) As String
        Local lcCommand As String,;
            lcAlias As String

        Try

            lcCommand = ""

            lcAlias = DoDefault( cAlias )

            TEXT To lcCommand NoShow TextMerge Pretext 15
            Select 	*,
            		Space( 100 ) as Nombre
            	From <<lcAlias>>
            	Into Cursor <<lcAlias>> ReadWrite
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

        Endtry

        Return cAlias

    Endproc && CrearCursor



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Organizacion_Proveedor
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Organizacion_Contacto
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Organizacion_Contacto As BaseMaestro Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Organizacion_Contacto Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oContacto"
    cBaseClassLib 	= "Clientes\Archivos\prg\Organizacion.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200


            loColFields = This.oColFields


            loField = loColFields.NewFK( "organizacion", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Organización"
                .lNull = .F.
            Endwith

            *!*	            loField = loColFields.NewFK( "telefono", "I" )
            *!*	            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*	                .lShowInGrid = .T.
            *!*	                If .lShowInGrid
            *!*	                    i = i + 1

            *!*	                    .nGridOrder = i
            *!*	                Endif

            *!*	                .cCaption = "Teléfono"
            *!*	                .Default = 0
            *!*	                .lNull = .T.
            *!*	                .cReferences = "Organizacion_Contacto_Telefono"

            *!*	                *!*	                .oCurrentControl.Name	= "ComboBoxBase"
            *!*	                *!*	                .oCurrentControl.Class	= "Clientes\Utiles\prg\utDataDictionary.prg"
            *!*	                .lStr = .F.

            *!*	            Endwith

            loField = loColFields.New( "telefonos", "M" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .F.
                If .lShowInGrid
                    i = i + 1

                    .nGridOrder = i
                Endif

                .cCaption = "Teléfonos"
                .cToolTipText = "Ingrese los teléfonos"

            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Organizacion_Contacto
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Organizacion_Contacto_Telefono
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Organizacion_Contacto_Telefono As BaseTelefono Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Organizacion_Contacto_Telefono Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oContacto_Telefono"
    cBaseClassLib 	= "Clientes\Archivos\prg\Organizacion.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200


            loColFields = This.oColFields


            loField = loColFields.NewFK( "organizacion", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Organización"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "contacto", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Contacto"
                .lNull = .F.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Organizacion_Contacto
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Organizacion_Contacto_EMail
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Organizacion_Contacto_EMail As BaseEMail Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Organizacion_Contacto_EMail Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oOrganizacion_Contacto_EMail"
    cBaseClassLib 	= "Clientes\Archivos\prg\Organizacion_Contacto_EMail.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200


            loColFields = This.oColFields


            loField = loColFields.NewFK( "organizacion", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Organización"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "contacto", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Contacto"
                .lNull = .F.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Organizacion_Contacto_EMail
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Organizacion_Sucursal
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Organizacion_Sucursal As BaseMaestro Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Organizacion_Contacto Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oOrganizacion_Contacto"
    cBaseClassLib 	= "Clientes\Archivos\prg\Organizacion_Contacto.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200


            loColFields = This.oColFields


            loField = loColFields.NewFK( "organizacion", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Organización"
                .lNull = .F.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Organizacion_Sucursal
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Organizacion_Sucursal_Direccion
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Organizacion_Sucursal_Direccion As BaseDireccion Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Organizacion_Sucursal_Direccion Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oOrganizacion_Sucursal_Direccion"
    cBaseClassLib 	= "Clientes\Archivos\prg\Organizacion_Sucursal_Direccion.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200


            loColFields = This.oColFields


            loField = loColFields.NewFK( "organizacion", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Organización"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "sucursal", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Sucursal"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFK( "Trasporte", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Trasporte"
            Endwith

            loField = loColFields.NewFK( "Zona", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Zona"
            Endwith

            loField = loColFields.New( "observacion", "M" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Observación"
                .cToolTipText = "Ingrese una referencia del Cliente"
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Organizacion_Sucursal_Direccion
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Vendedor
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Vendedor As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Vendedor Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oVendedor"
    cBaseClassLib 	= "Clientes\Archivos\prg\Vendedor.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200


            loColFields = This.oColFields


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Vendedor
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Numerador
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Numerador As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Numerador Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oNumerador"
    cBaseClassLib 	= "Clientes\Archivos\prg\Numerador.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loChoices As Collection

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

            loField = loColFields.NewFK( "Empresa", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Empresa"
                .cFK_Modelo = "Empresa"
                .lNull = .F.
            Endwith

            loField = loColFields.New( "ultimo_numero", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Último Número"
                .nLength = 8
                .cCheck = "uValue >= 0"
                .cErrorMessage = "No acepta valores negativos"

            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Numerador
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: Comprobante_Base
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Comprobante_Base As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Comprobante_Base Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oComprobante_Base"
    cBaseClassLib 	= "Clientes\Archivos\prg\Comprobante_Base.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loChoices As Collection

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

            loField = loColFields.NewFK( "afip_comprobante", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Comprobante Afip"
                .cFK_Modelo = "Afip_Comprobante"
                *!*	                .cFK_ToField = "Codigo"
                .lNull = .T.
            Endwith

            loField = loColFields.NewFK( "modulo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .lShowInGrid = .T.
                If .lShowInGrid
                    i = i + 1

                    *.nGridOrder = i
                    .nGridOrder = 50
                Endif
                .cCaption = "Módulo"
                .cReferences = "Modulo"
                .cToolTipText = "Módulos del Sistema"
                .lNull = .T.
            Endwith

            loField = loColFields.New( "afecta_modulo", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 	= "Afecta Módulo"
            Endwith


            loField = loColFields.New( "abreviatura", "C", 10 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Abreviatura"
                .cToolTipText = "Ingrese la Abreviatura"
                .cCheck = "I_ValObl( Abreviatura )"
                .cErrorMessage = "La ABREVIATURA es Obligatoria"

                .lRequired = .T.
            Endwith

            * Signo
            loChoices = Createobject( "Collection" )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Positivo" )
            AddProperty( loItem, "Valor", 1 )
            loChoices.Add( loItem )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Negativo" )
            AddProperty( loItem, "Valor", -1 )
            loChoices.Add( loItem )

            loField = loColFields.New( "Signo", "N", 2, 0 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 	= "Signo"
                .cInputMask = "99"
                .oChoices 	= loChoices
                .Default 	= 1
            Endwith

            loField = loColFields.New( "signo_stock", "N", 2, 0 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 	= "Signo Stock"
                .cInputMask = "99"
                .oChoices 	= loChoices
                .Default 	= 1
            Endwith

            loField = loColFields.New( "signo_cuenta_corriente", "N", 2, 0 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 	= "Signo Cuenta Corriente"
                .cInputMask = "99"
                .oChoices 	= loChoices
                .Default 	= 1
            Endwith
            loChoices = Null

            loField = loColFields.New( "afecta_stock", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 	= "Afecta Stock"
            Endwith

            loField = loColFields.New( "es_transferencia", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 	= "Es Transferencia"
            Endwith

            loField = loColFields.New( "afecta_cuenta_corriente", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption 	= "Afecta Cuenta Corriente"
            Endwith

            loField = loColFields.NewFK( "asiento_tipo", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Asiento Tipo"
                .lNull = .T.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Comprobante_Base
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Tipo_Comprobante
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Tipo_Comprobante As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Tipo_Comprobante Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oTipo_Comprobante"
    cBaseClassLib 	= "Clientes\Archivos\prg\Tipo_Comprobante.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            loField = loColFields.NewFK( "Comprobante_Base", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Comprobante Base"
                .lCanUpdate = .F.
                .cFK_Modelo = "Comprobante_Base"
                .cReferences = "Comprobante_Base"
                .lNull = .F.
            Endwith

            loField = loColFields.New( "abreviatura", "C", 6 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Abrev."
                .cToolTipText = "Ingrese la abreviatura"
                *!*	                .cCheck = "!Empty( nombre_abreviado )"
                *!*	                .cErrorMessage = "El NOMBRE ABREVIADO es obligatorio"
            Endwith

            loChoices = Createobject( "Collection" )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Manual" )
            AddProperty( loItem, "Valor", TN_MANUAL )
            loChoices.Add( loItem )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Automática" )
            AddProperty( loItem, "Valor", TN_AUTOMATICA )
            loChoices.Add( loItem )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Factura Electrónica" )
            AddProperty( loItem, "Valor", TN_FACTURA_ELECTRONICA  )
            loChoices.Add( loItem )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Impresora Fiscal Hasar" )
            AddProperty( loItem, "Valor", TN_IMPRESORA_FISCAL_HASAR )
            loChoices.Add( loItem )

            loItem = Createobject( "Empty" )
            AddProperty( loItem, "Descripcion", "Impresora Fiscal Epson" )
            AddProperty( loItem, "Valor", TN_IMPRESORA_FISCAL_EPSON )
            loChoices.Add( loItem )

            loField = loColFields.New( "tipo_numeracion", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Tipo de Numeración"
                .Default = TN_MANUAL
                .oChoices = loChoices
            Endwith

            loField = loColFields.New( "punto_de_venta", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Punto de Venta"
                .Default = 1
            Endwith

            loField = loColFields.NewFK( "numerador", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Numerador"
                .cFK_Modelo = "numerador"
                *.cReferences = "numerador"
                .lNull = .T.
            Endwith

            loField = loColFields.NewFK( "sucursal", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Sucursal"
                .cFK_Modelo = "sucursal"
                *.cReferences = "sucursal"
                .lNull = .T.
            Endwith

            loField = loColFields.New( "pide_circuito", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Pide Circuito"
                .Default = .T.
            Endwith

            loField = loColFields.NewFK( "circuito", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Circuito"
                .lCanUpdate = .F.
                .cFK_Modelo = "circuito"
                .cReferences = "circuito"
                .lNull = .T.
            Endwith

            loField = loColFields.NewFK( "circuito_destino", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Circuito Destino"
                .lCanUpdate = .F.
                .cFK_Modelo = "circuito"
                .cReferences = "circuito"
                .lNull = .T.
            Endwith


            loField = loColFields.New( "pide_deposito_origen", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Pide Depósito Origen"
                .Default = .T.
            Endwith

            loField = loColFields.NewFK( "deposito_origen", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Depósito Origen"
                .lCanUpdate = .F.
                .cFK_Modelo = "deposito"
                .cReferences = "deposito"
            Endwith

            loField = loColFields.New( "pide_deposito_destino", "L" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Pide Depósito Destino"
                .Default = .T.
            Endwith

            loField = loColFields.NewFK( "deposito_Destino", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Depósito Destino"
                .lCanUpdate = .F.
                .cFK_Modelo = "deposito"
                .cReferences = "deposito"
            Endwith

            loField = loColFields.New( "Copias", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Copias"
                .Default = 1
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Tipo_Comprobante
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Cuenta_Contable
*!* Description...:
*!* Date..........: Viernes 13 de Enero de 2023 (15:51:16)
*!*
*!*

Define Class Cuenta_Contable As CoreMaestroCodigo Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Cuenta_Contable Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oCuentaContable"
    cBaseClassLib 	= "Clientes\Contable\prg\CuentaContable.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Cuenta_Contable
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Asiento_Tipo
*!* Description...:
*!* Date..........: Viernes 13 de Enero de 2023 (15:51:16)
*!*
*!*

Define Class Asiento_Tipo As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Asiento_Tipo Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oAsientoTipo"
    cBaseClassLib 	= "Clientes\Contable\prg\AsientoTipo.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Asiento_Tipo
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Deuda
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Deuda As CoreMovimientoBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Deuda Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oCttaCtte"
    cBaseClassLib 	= "Clientes\Ctta_Ctte\prg\CttaCtte.prg"
    cModelo 		= "CttaCtte"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            loField = loColFields.NewFk( "Tipo_Comprobante" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Tipo de Comprobante"
                .lCanUpdate = .T.
                .cFK_Modelo = "Tipo_Comprobante"
                .nShowInFilter = 5
                .lFilterEsSistema = .F.
                .cFilterLookUpInclude = ["exact","in"]
                .lNull = .F.
            Endwith

            loField = loColFields.NewFk( "Comprobante_Base" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Comprobante Base"
                .lCanUpdate = .F.
                .cFK_Modelo = "Comprobante_Base"
                .lNull = .F.
            Endwith

            loField = loColFields.NewFk( "Organizacion" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Organización"
                .cFK_Modelo = "Organizacion"
                .nShowInFilter = 1
                .lFilterEsSistema = .F.
                .cFilterDataType = "C"
                .cFilterFieldName = "organizacion__nombre"
                *.cFilterLookUpInclude = ["exact","range"]
                .cFilterLookUpExclude = ["startswith","endswith","range","gt","lt"]
                .lNull = .F.
            Endwith


            loField = loColFields.New( "Fecha_Vencimiento", "D" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Vencimiento"
                .cToolTipText = "Ingrese la Fecha de Vencimiento"
            Endwith

            loField = loColFields.New( "Importe", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Importe"
                .cToolTipText = "Ingrese el Importe Total"
            Endwith

            loField = loColFields.New( "Saldo", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Saldo"
                .cToolTipText = "Ingrese el Saldo"
            Endwith

            loField = loColFields.NewFk( "Vendedor" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Vendedor"
                .cFK_Modelo = "Vendedor"
                .nShowInFilter = 3
                .lFilterEsSistema = .F.
                .cFilterLookUpInclude = ["exact","in"]
            Endwith

            loField = loColFields.NewFk( "Provincia" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Provincia"
                .cFK_Modelo = "Provincia"
                .nShowInFilter = 4
                .lFilterEsSistema = .F.
                .cFilterLookUpInclude = ["exact","in"]
            Endwith

            loField = loColFields.New( "Es_Compra", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .cCaption = "Comprobante de Compra"
                .cToolTipText = "Indica si el Comprobante es de Compras"
                .nShowInFilter = 6
                .lFilterEsSistema = .F.
            Endwith

            * Campos virtuales

            loField = loColFields.New( "Saldo_Calculado", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Saldo"
                .lCanUpdate = .F.
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize


Enddefine
*!*
*!* END DEFINE
*!* Class.........: Deuda
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: Aplicacion_Deuda
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class Aplicacion_Deuda As BaseModel Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As Aplicacion_Deuda Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= ""
    cBaseClassLib 	= ""

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            i = 200


            loColFields = This.oColFields

            loField = loColFields.NewFk( "comprobante_debe" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Comprobante al Debe"
                .cFK_Modelo = "CttaCtte"
                .lNull = .F.
            Endwith


            loField = loColFields.NewFk( "comprobante_haber" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Comprobante al Haber"
                .cFK_Modelo = "CttaCtte"
                .lNull = .F.
            Endwith

            loField = loColFields.New( "Fecha", "D" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Fecha"
                .cToolTipText = "Ingrese la Fecha de Aplicación"
            Endwith

            loField = loColFields.New( "Importe", "N", 12, 2 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Importe"
                .cToolTipText = "Ingrese el Importe Aplicado"
            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: Aplicacion_Deuda
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: ML_Settings
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class ML_Settings As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As ML_Settings Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oMercadoLibre"
    cBaseClassLib 	= "Clientes\MercadoLibre\prg\MercadoLibre.prg"
    cModelo 		= "MercadoLibre"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

            loField = loColFields.New( "client_id", "C", 50 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Cliente Id"
                .cToolTipText = "Id de la Aplicación registrada en Mercado Libre"
                *!*	                .cCheck = "I_ValObl( client_id )"
                *!*	                .cErrorMessage = "El Cliente Id es Obligatorio"

                .lRequired = .T.

            Endwith



            loField = loColFields.New( "client_secret", "C", 50 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Clave Secreta"
                .cToolTipText = "Clave Secreta de la Aplicación registrada en Mercado Libre"
                *!*	                .cCheck = "I_ValObl( client_secret )"
                *!*	                .cErrorMessage = "La Clave Secreta es Obligatoria"

                .lRequired = .T.

            Endwith

            loField = loColFields.New( "redirect_uri", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "URL de Redirección"
                .cToolTipText = "Dirección URL de la API donde Mercado Libre se comunica"
                *!*	                .cCheck = "I_ValObl( redirect_uri )"
                *!*	                .cErrorMessage = "La URL de Redirección es Obligatoria"

                .lRequired = .T.

            Endwith

            loField = loColFields.New( "server_authorization_code", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Código de Autorización"
                .cToolTipText = "Código de Autorización enviado por Mercado Libre"
                .lCanUpdate = .F.
            Endwith

            loField = loColFields.New( "user_id", "N", 15 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Id de Usuario"
                .cToolTipText = "Id de Usuario enviado por Mercado Libre"
                .lCanUpdate = .F.
            Endwith

            loField = loColFields.New( "access_token", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Token de Acceso"
                .cToolTipText = "Token de Acceso enviado por Mercado Libre"
                .lCanUpdate = .F.
            Endwith

            loField = loColFields.New( "refresh_token", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Token de Refresco"
                .cToolTipText = "Token de Refresco enviado por Mercado Libre"
                .lCanUpdate = .F.
            Endwith

            loField = loColFields.New( "invalid_token", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .Default = .T.
                .cCaption = "Token Inválido"
                .nGridOrder = i

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Indica si el resultado de la última consulta
				devolvió que el Token de Acceso era inválido.
				Esto habilita el botón que permite
				volver a registrarse para obtener un
				token válido
                ENDTEXT


            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: ML_Settings
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: TN_Settings
*!* Description...:
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*

Define Class TN_Settings As CoreMaestroBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As TN_Settings Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oTiendaNube"
    cBaseClassLib 	= "Clientes\TiendaNube\prg\TiendaNube.prg"
    cModelo 		= "TiendaNube"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            DoDefault()

            loColFields = This.oColFields

            i = 200

            *!*				loField = loColFields.New( "client_id", "C", 50 )
            *!*				With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*					.cCaption = "Cliente Id"
            *!*					.cToolTipText = "Id de la Aplicación registrada en Tienda Nube"
            *!*					.cCheck = "I_ValObl( client_id )"
            *!*					.cErrorMessage = "El Cliente Id es Obligatorio"

            *!*					.lRequired = .T.

            *!*				EndWith

            loField = loColFields.New( "app_id", "I" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Id de la App"
                .cToolTipText = "Id de la Aplicación registrada en Tienda Nube"
                .lCanUpdate = .T.
                .lRequired = .T.

                *!*	                .cCheck = "I_ValObl( app_id )"
                *!*	                .cErrorMessage = "El Id de la Aplicación es Obligatorio"

            Endwith


            loField = loColFields.New( "client_secret", "C", 50 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Clave Secreta"
                .cToolTipText = "Clave Secreta de la Aplicación registrada en Tienda Nube"
                *!*	                .cCheck = "I_ValObl( client_secret )"
                *!*	                .cErrorMessage = "La Clave Secreta es Obligatoria"

                .lRequired = .T.

            Endwith

            loField = loColFields.New( "Alias", "C", 20 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Alias"
                .cToolTipText = "Nombre Unico de la Tienda (SIN ESPACIOS)"

                *!*	                .cCheck = "I_ValObl( Alias )"
                *!*	                .cErrorMessage = "El Alias es Obligatorio (SIN ESPACIOS)"

                .lRequired = .T.
            Endwith


            *!*				loField = loColFields.New( "redirect_uri", "C", 100 )
            *!*				With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
            *!*					.cCaption = "URL de Redirección"
            *!*					.cToolTipText = "Dirección URL de la API donde Tienda Nube se comunica"
            *!*					.cCheck = "I_ValObl( redirect_uri )"
            *!*					.cErrorMessage = "La URL de Redirección es Obligatoria"

            *!*					.lRequired = .T.

            *!*				Endwith

            loField = loColFields.New( "server_authorization_code", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Código de Autorización"
                .cToolTipText = "Código de Autorización enviado por Tienda Nube"
                .lCanUpdate = .F.
            Endwith

            loField = loColFields.New( "user_id", "N", 15 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Id de Usuario"
                .cToolTipText = "Id de Usuario enviado por Tienda Nube"
                .lCanUpdate = .F.
                .cInputMask = Replicate( "9", .nFieldWidth )
                .cFormat = "B"
            Endwith

            loField = loColFields.New( "access_token", "C", 100 )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Token de Acceso"
                .cToolTipText = "Token de Acceso enviado por Tienda Nube"
                .lCanUpdate = .F.
            Endwith

            loField = loColFields.New( "scope", "M" )
            With loField As oField Of 'Tools\DataDictionary\prg\oField.prg'
                .cCaption = "Alcance"

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Muestra los permisos de la Aplicación.
				Se pueden modificar solamente desde Tienda Nube.
                ENDTEXT

                .lCanUpdate = .F.
            Endwith

            loField = loColFields.New( "invalid_token", "L" )
            With loField As oField Of "Tools\DataDictionary\prg\oField.prg"
                .Default = .T.
                .cCaption = "Token Inválido"
                .nGridOrder = i

                TEXT To .cToolTipText NoShow TextMerge Pretext 03
				Indica si el resultado de la última consulta
				devolvió que el Token de Acceso era inválido.
				Esto habilita el botón que permite
				volver a registrarse para obtener un
				token válido
                ENDTEXT


            Endwith

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: TN_Settings
*!*
*!* ///////////////////////////////////////////////////////



*!* ///////////////////////////////////////////////////////
*!* Class.........: sistema_condicion_iva_documentos
*!* Description...: Tabla intermedia
*!* Date..........: Domingo 5 de Septiembre de 2021 (16:44:38)
*!*
*!*
*!*	Indica los Tipos de Documentos permitidos al emitir un comrobante
*!*	en función de la Condición del iva del receptor

Define Class yyyy___sistema_condicion_iva_documentos As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

    #If .F.
        Local This As sistema_condicion_iva_documentos Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    lIsVirtual 		= .F.
    cBaseClass 		= "oSistema_Condicion_Iva_Documentos"
    cBaseClassLib 	= "Clientes\Archivos\prg\CondicionIva.prg"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Initialize(  ) As Void
        Local lcCommand As String

        Local loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg', ;
            loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg', ;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg', ;
            loTable As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"

        Try

            lcCommand = ""

            loColFields = This.oColFields

            i = 100

            loField = loColFields.New( "id", "I" )
            loField = loColFields.New( "condicion_iva_id", "I" )
            loField = loColFields.New( "afip_documento_id", "I" )


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Initialize



Enddefine
*!*
*!* END DEFINE
*!* Class.........: sistema_condicion_iva_documentos
*!*
*!* ///////////////////////////////////////////////////////

* Controles Comunes

Define Class ChkNumeric As Checkbox

    #If .F.
        Local This As ChkNumeric Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif


    Value = 0
    Caption = ""
    Alignment = 2

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

Enddefine

Define Class ChkLogical As Checkbox

    #If .F.
        Local This As ChkLogical Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    Value = .F.
    Caption = ""
    Alignment = 2

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine

Define Class cboSignoSt As ComboBox

    #If .F.
        Local This As cboSignoSt Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    BoundColumn 	= 2
    BoundTo 		= .T.
    ColumnCount 	= 1
    RowSourceType 	= 0
    RowSource 		= ""
    Style			= 2
    Sorted 			= .F.


    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


    Procedure Init()
        Local lcCommand As String

        Try

            lcCommand = ""

            This.AddItem( "Entrada" )
            This.List( This.NewIndex, 2 ) = Transform( ST_ENTRADA )

            This.AddItem( "Salida" )
            This.List( This.NewIndex, 2 ) = Transform( ST_SALIDA )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry

    Endproc

Enddefine

Define Class cboSignoCo As ComboBox

    #If .F.
        Local This As cboSignoCo Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    BoundColumn 	= 2
    BoundTo 		= .T.
    ColumnCount 	= 1
    RowSourceType 	= 0
    RowSource 		= ""
    Style			= 2
    Sorted 			= .F.


    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


    Procedure Init()
        Local lcCommand As String

        Try

            lcCommand = ""

            This.AddItem( "Debe" )
            This.List( This.NewIndex, 2 ) = Transform( CO_DEBE )

            This.AddItem( "Haber" )
            This.List( This.NewIndex, 2 ) = Transform( CO_HABER )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc

Enddefine


*!* ///////////////////////////////////////////////////////
*!* Class.........: ComboBoxBase
*!* Description...:
*!* Date..........: Martes 7 de Junio de 2022 (17:09:35)
*!*
*!*

Define Class ComboBoxBase As _combobox Of v:\cloudfox\fw\comunes\vcx\_controles_base.vcx

    #If .F.
        Local This As ComboBoxBase Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    ReadOnly = .T.
    lLazyLoad = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="ofield" type="property" display="oField" />] + ;
        [<memberdata name="ofield_access" type="method" display="oField_Access" />] + ;
        [</VFPData>]

    *
    *
    Procedure Init(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""

            This.BoundColumn 	= 2
            This.BoundTo 		= .T.
            This.ColumnCount 	= 1
            This.RowSourceType 	= 0
            This.RowSource 		= ""
            This.Style			= 2
            *This.ControlSource 	=

            This.oFiltros 	= Newobject( "CollectionBase", "Tools\Namespaces\Prg\CollectionBase.Prg" )
            This.oLabel 	= Createobject( "Label" )

            If !This.lIsChild
                *This.CargarCombo()
            Endif

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            loError = Newobject( "ErrorHandler", "ErrorhandlerPrg\ErrorHandler.prg" )
            loError.Cremark = lcCommand
            loError.Process( oErr )
            Throw loError

        Finally

        Endtry

    Endproc && Init

    *
    * oField_Access
    Protected Procedure oField_Access()

        Local lcCommand As String
        Local loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg',;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loControl As _textbox Of fw\comunes\vcx\_controles_base.vcx

        Try

            lcCommand = ""

            If Isnull( This.oField )

                If Empty( This.cFieldName )
                    This.cFieldName = Substr( This.Name, 4 )
                Endif

                If !Empty( This.cTable )
                    loArchivo 	= GetTable( This.cTable )

                    If IsEmpty( loArchivo )
                        TEXT To lcMsg NoShow TextMerge Pretext 03
						No se pudo obtener la tabla asociada
						al control "<<This.Name>>"

						La propiedad "cTable" indica "<<This.cTable>>"
                        ENDTEXT

                        Stop( lcMsg, "Alerta al Desarrollador", -1 )

                    Endif

                    loColFields = loArchivo.oColFields
                    loField 	= loColFields.GetItem( This.cFieldName )
                    This.oField = loField

                    If IsEmpty( loField )
                        TEXT To lcMsg NoShow TextMerge Pretext 03
						No se pudo obtener el campo asociado
						al control "<<This.cFieldName>>"

						La propiedad "cTable" indica "<<This.cTable>>"
                        ENDTEXT

                        Stop( lcMsg, "Alerta al Desarrollador", -1 )

                    Else
                        If !Empty( loField.nGridMaxLength )
                            This.nWidth = loField.nGridMaxLength
                        Endif

                    Endif

                Endif

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loField 	= Null
            loColFields = Null
            loArchivo 	= Null

        Endtry

        Return This.oField

    Endproc && oField_Access


    *
    *
    Procedure CargarCombo( lForceLoad As Boolean ) As Void
        Local lcCommand As String,;
            lcAlias As String,;
            lcTo_Field As String
        Local loModelo As oModelo Of "FrontEnd\Prg\Modelo.prg",;
            loParent As oModelo Of "FrontEnd\Prg\Modelo.prg",;
            loParam As Object,;
            loFiltros As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loChoices As Object
        Local llCarga As Boolean

        Try

            lcCommand = ""
            llCarga = .T.

            loField = This.oField



            If IsEmpty( loField.oChoices )

                loModelo = This.oModelo

                If This.lIsChild
                    loParent = This.oParent
                    loModelo.oParent.nId = This.oParent.Value
                Endif

                If Empty( loField.cFK_ToField )
                    lcTo_Field = loModelo.cPKField

                Else
                    lcTo_Field = loField.cFK_ToField

                Endif


                If llCarga

                    If This.lLazyLoad And !lForceLoad
                        Try

                            * Si el formulario trajo la FK y el nombre de la FK
                            * los carga de allí

                            lcAlias = This.Parent.Parent.cCursorDeTrabajo

                            If Lower( Right( This.cFieldName, 3 )) == "_id"
                                lcStr_Field = Substr( This.cFieldName, 1, Len( This.cFieldName ) - 3 )

                            Else
                                lcStr_Field = This.cFieldName

                            Endif

                            This.AddItem( Alltrim( Evaluate( lcAlias + ".str_" + lcStr_Field )))
                            This.List( This.NewIndex, 2 ) = Transform( Evaluate( lcAlias + "." + lcStr_Field ) )

                            llCarga = .F.

                            lcAlias = ""

                        Catch To oErr

                        Finally

                        Endtry

                    Endif
                Endif

                If llCarga

                    This.Filtrar()

                    loFiltros = This.oFiltros

                    loParam = Createobject( "Empty" )
                    AddProperty( loParam, "oFilterCriteria", loFiltros )

                    lcAlias = loModelo.cMainCursorName + Sys(2015)
                    AddProperty( loParam, "cAlias", lcAlias )

                    loModelo.GetByWhere( loParam )

                    This.Clear()
                    Select Alias( lcAlias )

                    If loField.lNull
                        This.AddItem( "---------" )
                        This.List( This.NewIndex, 2 ) = Transform( 0 )
                    Endif

                    Locate
                    Scan
                        This.AddItem( Alltrim( Evaluate( lcAlias + "." + This.cDisplayFieldName )))
                        This.List( This.NewIndex, 2 ) = Transform( Evaluate( lcTo_Field ) )
                    Endscan
                Endif

            Else
                For Each loChoice In loField.oChoices
                    This.AddItem( Alltrim( loChoice.Descripcion ))
                    This.List( This.NewIndex, 2 ) = Transform( loChoice.Valor )
                Endfor

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loFiltro = Null
            loFiltros = Null
            loParam = Null
            loModelo = Null

            If !Empty( lcAlias )
                Use In Select( lcAlias )
            Endif
        Endtry
    Endproc && CargarCombo

    *
    *
    Procedure xxx___CargarCombo(  ) As Void
        Local lcCommand As String,;
            lcAlias As String,;
            lcTo_Field As String
        Local loModelo As oModelo Of "FrontEnd\Prg\Modelo.prg",;
            loParent As oModelo Of "FrontEnd\Prg\Modelo.prg",;
            loParam As Object,;
            loFiltros As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
            loField As oField Of 'Tools\DataDictionary\prg\oField.prg',;
            loChoices As Object

        Try

            lcCommand = ""

            loField = This.oField

            If IsEmpty( loField.oChoices )

                loModelo = This.oModelo

                If This.lIsChild
                    loParent = This.oParent
                    loModelo.oParent.nId = This.oParent.Value
                Endif

                If Empty( loField.cFK_ToField )
                    lcTo_Field = loModelo.cPKField

                Else
                    lcTo_Field = loField.cFK_ToField

                Endif

                This.Filtrar()

                loFiltros = This.oFiltros

                loParam = Createobject( "Empty" )
                AddProperty( loParam, "oFilterCriteria", loFiltros )

                lcAlias = loModelo.cMainCursorName + Sys(2015)
                AddProperty( loParam, "cAlias", lcAlias )

                loModelo.GetByWhere( loParam )

                This.Clear()
                Select Alias( lcAlias )

                If loField.lNull
                    This.AddItem( "---------" )
                    This.List( This.NewIndex, 2 ) = Transform( 0 )
                Endif

                Locate
                Scan
                    This.AddItem( Alltrim( Evaluate( lcAlias + "." + This.cDisplayFieldName )))
                    This.List( This.NewIndex, 2 ) = Transform( Evaluate( lcTo_Field ) )
                Endscan

            Else
                For Each loChoice In loField.oChoices
                    This.AddItem( Alltrim( loChoice.Descripcion ))
                    This.List( This.NewIndex, 2 ) = Transform( loChoice.Valor )
                Endfor

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loFiltro = Null
            loFiltros = Null
            loParam = Null
            loModelo = Null

            If !Empty( lcAlias )
                Use In Select( lcAlias )
            Endif
        Endtry
    Endproc && xxx___CargarCombo

Enddefine
*!*
*!* END DEFINE
*!* Class.........: ComboBoxBase
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: SpinnerBase
*!* Description...:
*!* Date..........: Domingo 28 de Agosto de 2022 (12:41:29)
*!*
*!*

Define Class SpinnerBase As _spinner Of v:\cloudfox\fw\comunes\vcx\_controles_base.vcx

    #If .F.
        Local This As SpinnerBase Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure Init(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""
            This.Format			= "K"

            This.lFontItalic 	= This.FontItalic
            This.cForecolor 	= This.ForeColor
            This.nAlignment 	= This.Alignment
            This.cFormat 		= This.Format
            This.cInputMask 	= This.InputMask
            This.lInitialized 	= .F.

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && Init



Enddefine
*!*
*!* END DEFINE
*!* Class.........: SpinnerBase
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: TextBoxBase
*!* Description...:
*!* Date..........: Martes 7 de Junio de 2022 (17:09:35)
*!*
*!*

Define Class TextBoxBase As _textbox Of v:\cloudfox\fw\comunes\vcx\_controles_base.vcx

    #If .F.
        Local This As TextBoxBase Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    ReadOnly = .T.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="ofield" type="property" display="oField" />] + ;
        [<memberdata name="ofield_access" type="method" display="oField_Access" />] + ;
        [</VFPData>]

    *
    *
    Procedure Init(  ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""

            *This.Format = "K"
            This.BorderStyle 	= 0

            This.lFontItalic 	= This.FontItalic
            This.cForecolor 	= This.ForeColor
            This.nAlignment 	= This.Alignment
            This.cFormat 		= This.Format
            This.cInputMask 	= This.InputMask
            This.nMaxLength 	= This.MaxLength
            This.lInitialized 	= .F.

        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
            loError = Newobject( "ErrorHandler", "ErrorhandlerPrg\ErrorHandler.prg" )
            loError.Cremark = lcCommand
            loError.Process( oErr )
            Throw loError

        Finally


        Endtry

    Endproc && Init

Enddefine
*!*
*!* END DEFINE
*!* Class.........: TextBoxBase
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: numTextBoxBase
*!* Description...:
*!* Date..........: Sábado 3 de Septiembre de 2022 (13:58:02)
*!*
*!*

Define Class numTextBoxBase As TextBoxBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As numTextBoxBase Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    Format = "K"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: numTextBoxBase
*!*
*!* ///////////////////////////////////////////////////////



*!* ///////////////////////////////////////////////////////
*!* Class.........: SpnCantidad_Enteros
*!* Description...:
*!* Date..........: Domingo 28 de Agosto de 2022 (12:48:13)
*!*
*!*

Define Class SpnCantidad_Enteros As SpinnerBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As SpnCantidad_Enteros Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    cTable 	= "Unidad_Medida"
    cModelo = "Unidad_Medida"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: SpnCantidad_Enteros
*!*
*!* ///////////////////////////////////////////////////////
*!* ///////////////////////////////////////////////////////
*!* Class.........: SpnCantidad_Decimales
*!* Description...:
*!* Date..........: Domingo 28 de Agosto de 2022 (12:48:13)
*!*
*!*

Define Class SpnCantidad_Decimales As SpinnerBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

    #If .F.
        Local This As SpnCantidad_Decimales Of "Clientes\Utiles\prg\utDataDictionary.prg"
    #Endif

    cTable 	= "Unidad_Medida"
    cModelo = "Unidad_Medida"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: SpnCantidad_Decimales
*!*
*!* ///////////////////////////////////////////////////////
