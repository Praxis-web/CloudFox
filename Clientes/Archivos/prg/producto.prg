#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "Tools\JSON\Include\http.h"

#Define _COTIZACION 3
#Define _SIGNO		4

*
*
Procedure Producto( nPermisos As Integer,;
        nParam2 As Integer,;
        nParam3 As Integer,;
        nParam4 As Integer,;
        nParam5 As Integer,;
        cURL As String,;
        lDoPrg ) As Void

    Local lcCommand As String
    Local loProducto As oProducto Of "Clientes\Archivos\prg\Producto.prg",;
        loParam As Object


    Try

        lcCommand = ""
        loParam = Createobject( "Empty" )

        AddProperty( loParam, "nPermisos", nPermisos )
        AddProperty( loParam, "cURL", cURL  )

        loProducto = GetEntity( "Producto" )
        loProducto.Initialize( loParam )

        AddProperty( loParam, "oBiz", loProducto )

        Do Form (loProducto.cGrilla) ;
            With loParam To loReturn



    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally
        loProducto = Null

    Endtry

Endproc && Producto

*!* ///////////////////////////////////////////////////////
*!* Class.........: oProducto
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oProducto As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oProducto Of "Clientes\Archivos\prg\Producto.prg"
    #Endif

    lEditInBrowse 	= .F.
    cModelo 		= "Producto"
    cTabla 			= "Articulo"

    cFormIndividual = "Clientes\Archivos\Scx\Producto.scx"
    cGrilla 		= "Clientes\Archivos\Scx\Productos.scx"

    cTituloEnForm 	= "Artículo"
    cTituloEnGrilla = "Artículos"

    lIsChild 		= .T.
    cParent 		= "SubGrupo"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="getcondiciones" type="method" display="GetCondiciones" />] + ;
        [<memberdata name="getcondicionescoeficiente" type="method" display="GetCondicionesCoeficiente" />] + ;
        [</VFPData>]

    *
    *
    Procedure ObtenerPermisos( nPermisos As Integer ) As Void
        Local lcCommand As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"


        Try

            lcCommand = ""

            DoDefault( nPermisos )

            * RA 26/12/2022(11:19:39)
            * En Productos NO SE MUESTRA
            * (Jorge)
            This.lEditInBrowse 			= .F.
            This.lShowEditInBrowse 		= .F.
            This.lShowCamposEspeciales 	= .F.

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loUser = Null

        Endtry

    Endproc && ObtenerPermisos

    *
    *
    Procedure HookFilterCriteria( oFilterCriteria As Collection ) As Collection
        Local lcCommand As String

        Try

            lcCommand = ""
            If Lower( This.Name ) == "oproducto"
                * RA 06/08/2022(10:54:06)
                * Si el SubGrupo no está definido, trae todos
                * los registros

                oFilterCriteria.RemoveItem( Lower( "Empty" ) )
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return oFilterCriteria

    Endproc && HookFilterCriteria

    *
    * Llama al formulario para editar la entidad
    Procedure LaunchEditForm( oRegistro As Object ) As Boolean ;
            HELPSTRING "Llama al formulario para editar la entidad"
        Local lcCommand As String,;
            lcUrlNext As String,;
            lcUrlPrevious As String

        Local loStatus As Object,;
            loParam As Object
        Local lnTotalDeRegistros As Integer,;
            lnCurrentPage As Integer,;
            lnLastPage As Integer

        Local llReturn As Boolean

        Try

            lcCommand = ""

            If Lower( This.Name ) == "oproducto"

                loStatus = Null
                llReturn = .F.

                Inkey()

                lnTotalDeRegistros = This.nTotalDeRegistros
                lnCurrentPage = This.nCurrentPage
                lcUrlNext = This.cUrlNext
                lcUrlPrevious = This.cUrlPrevious
                lnLastPage = This.nLastPage

                oRegistro.Grupo = This.oParent.oParent.nId
                oRegistro.SubGrupo = This.oParent.nId

                This.oRegistro = oRegistro

                loParam = Createobject( "Empty" )
                AddProperty( loParam, "cModelo", This.cModelo )
                AddProperty( loParam, "oRegistro", oRegistro )
                AddProperty( loParam, "cABM", oRegistro.ABM )
                AddProperty( loParam, "uPK", Evaluate( "oRegistro." + This.cPKField ))
                AddProperty( loParam, "WCLAV", "A" )
                AddProperty( loParam, "oBiz", This )

                If oRegistro.ABM = ABM_ALTA
                    Do Form "Clientes\Archivos\Scx\Producto_Alta.scx" With loParam To loStatus

                    If Vartype( loStatus ) == "O"
                        llReturn = ( loStatus.lCancelar = .F. )

                        If llReturn
                            oRegistro.ABM = ABM_MODIFICACION
                            oRegistro.Id = This.nId

                            loParam = Createobject( "Empty" )
                            AddProperty( loParam, "cModelo", This.cModelo )
                            AddProperty( loParam, "oRegistro", oRegistro )
                            AddProperty( loParam, "cABM", oRegistro.ABM )
                            AddProperty( loParam, "uPK", Evaluate( "oRegistro." + This.cPKField ))
                            AddProperty( loParam, "WCLAV", "A" )
                            AddProperty( loParam, "oBiz", This )

                            Do Form (This.cFormIndividual) With loParam To loStatus

                        Endif
                    Endif

                Else
                    Do Form (This.cFormIndividual) With loParam To loStatus

                Endif

                If Vartype( loStatus ) == "O"
                    llReturn = ( loStatus.lCancelar = .F. )
                Endif

                If !llReturn
                    This.nTotalDeRegistros = lnTotalDeRegistros
                    This.nCurrentPage = lnCurrentPage
                    This.cUrlNext = lcUrlNext
                    This.cUrlPrevious = lcUrlPrevious
                    This.nLastPage = lnLastPage
                Endif

            Else
                llReturn = DoDefault( oRegistro )

            Endif


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return llReturn

    Endproc && LaunchEditForm


    *
    *
    Procedure GetCondiciones( cCondiciones As String ) As String
        Local lcCommand As String,;
            lcCondiciones As String,;
            lcTxt As String,;
            lcValoresProhibidos As String

        Local i As Integer,;
            lnLen As Integer

        Local x As Character

        Dimension laValoresPermitidos[4]

        Try

            lcCommand = ""
            
            lcTxt = Strtran( Alltrim( cCondiciones ), ",", "." )
            lcTxt = Strtran( lcTxt, " ", "" )

            laValoresPermitidos[ 1 ] = "+"
            laValoresPermitidos[ 2 ] = "-"
            laValoresPermitidos[ 3 ] = "*"
            laValoresPermitidos[ 4 ] = "."

            lcCondiciones 		= ""
            lcValoresProhibidos = ""
            lnLen = Len( lcTxt )

            For i = 1 To lnLen
                x = Substr( lcTxt, i, 1 )

                Do Case
                    Case Isdigit( x )
                        lcCondiciones = lcCondiciones + x

                    Case Ascan( laValoresPermitidos, x ) > 0
                        lcCondiciones = lcCondiciones + x

                    Otherwise
                        lcValoresProhibidos = lcValoresProhibidos + x

                Endcase

            Endfor

            If Len( lcValoresProhibidos ) > 0
                TEXT To lcMsg NoShow TextMerge Pretext 03
            	Sólo estan permitidos Dígitos y los signos [+], [-] y [*]
                ENDTEXT

                Warning( lcMsg, "Condiciones" )

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return lcCondiciones

    Endproc && GetCondiciones

    *
    *
    Procedure GetCondicionesCoeficiente( cCondiciones As String ) As Number
        Local lcCommand As String,;
            lcTxt As String,;
            lcAux As String
        Local lnCoeficiente As Number,;
            k As Number,;
            j As Number
        Local lnLen As Integer,;
            i As Integer

        Try

            lcCommand = ""

            lcTxt = Strtran( Alltrim( cCondiciones ), "+", "#+" )
            lcTxt = Strtran( lcTxt, "-", "#-" )
            lcTxt = Strtran( lcTxt, "*", "#*" )

            If Substr( lcTxt, 1, 1 ) # "#"
                lcTxt = "#+" + lcTxt
            Endif

            lnCoeficiente = 1

            lnLen = Getwordcount( lcTxt, "#" )
            For i = 1 To lnLen
                lcAux = Getwordnum( lcTxt, i, "#" )

                If Substr( lcAux, 1, 1 ) == "*"
                    k = Val( Substr( lcAux, 2 ))
                    lnCoeficiente = lnCoeficiente * k

                Else
                    j = Abs(Val( lcAux ) )
                    If Val( lcAux ) > 0
                        lnCoeficiente = lnCoeficiente * ( 1 + ( j / 100 ))

                    Else
                        lnCoeficiente = lnCoeficiente * ( 1 - ( j / 100 ))

                    Endif

                Endif

            Endfor

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return Round( lnCoeficiente, 4 )

    Endproc && GetCondicionesCoeficiente

    *
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( Alltrim( This.cURL ))
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

            This.cURL = "archivos/apis/Producto/"

        Endif

        Return This.cURL

    Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oProducto
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: oPrecioDeCompra
*!* Description...:
*!* Date..........: Lunes 2 de Enero de 2023 (15:50:02)
*!*
*!*

Define Class oPrecioDeCompra As oProducto Of "Clientes\Archivos\prg\Producto.prg"

    #If .F.
        Local This As oPrecioDeCompra Of "Clientes\Archivos\prg\Producto.prg"
    #Endif

    lEditInBrowse 	= .F.
    cModelo 		= "Articulo_Proveedor"
    cTabla 			= "Articulo_Proveedor"

    cFormIndividual = "Clientes\Archivos\Scx\Producto_Proveedor.scx"
    cGrilla 		= ""

    cURL 			= "archivos/apis/ProductoProveedor/"

    cTituloEnForm 	= "Lista de Precio"
    cTituloEnGrilla = "Listas de Precios"

    lIsChild 		= .T.
    cParent 		= "Producto"

    lFiltrarPorClientePraxis = .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="calcularprecios" type="method" display="CalcularPrecios" />] + ;
        [</VFPData>]

    *
    *
    Procedure CalcularPrecios( oRegistro As Object ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""

            oRegistro.condiciones = This.GetCondiciones(oRegistro.condiciones)
            oRegistro.condiciones_coeficiente = This.GetCondicionesCoeficiente( oRegistro.condiciones )
            oRegistro.Costo_Final_Calculado = Round( oRegistro.costo_base * oRegistro.condiciones_coeficiente, 2 )
            oRegistro.costo_en_moneda_corriente = Round( oRegistro.Costo_Final_Calculado * oRegistro.Cotizacion, 2 )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && CalcularPrecios

    *
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( Alltrim( This.cURL ))
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

            This.cURL = "archivos/apis/ProductoProveedor/"

        Endif

        Return This.cURL
    Endproc


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oPrecioDeCompra
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oPrecioDeVenta
*!* Description...:
*!* Date..........: Lunes 2 de Enero de 2023 (16:04:02)
*!*
*!*

Define Class oPrecioDeVenta As oProducto Of "Clientes\Archivos\prg\Producto.prg"

    #If .F.
        Local This As oPrecioDeVenta Of "Clientes\Archivos\prg\Producto.prg"
    #Endif

    lEditInBrowse 	= .F.
    cModelo 		= "PreciosDeVenta"
    cTabla 			= "Articulo_Venta"

    cFormIndividual = "Clientes\Archivos\Scx\Producto_Venta.scx"
    cGrilla 		= ""

    cURL 			= "archivos/apis/ProductoVenta/"

    cTituloEnForm 	= "Precio de Venta"
    cTituloEnGrilla = "Listas de Precio"

    lIsChild 		= .T.
    cParent 		= "Producto"

    lFiltrarPorClientePraxis = .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="calcularprecios" type="method" display="CalcularPrecios" />] + ;
        [</VFPData>]

    *
    *
    Procedure CalcularPrecios( oRegistro As Object,;
    	oMonedaBase as ComboBox,;
    	oMonedaVenta as ComboBox ) As Void
    	
        Local lcCommand As String
        Local lnPrecioVenta as Number,;
        lnPrecioBase as Number,;
        lnPrecioEnMonedaCorriente as Number,;
        lnCotizacionBase as Number,;
        lnCotizacionVenta as Number 
        
        Local loMoneda as ComboBox 

        Try

            lcCommand = ""
            
            oRegistro.condiciones = This.GetCondiciones(oRegistro.condiciones)
            oRegistro.coeficiente = This.GetCondicionesCoeficiente( oRegistro.condiciones )

			lnPrecioBase = oRegistro.Precio_Base_Calculado 
			lnPrecioVenta = lnPrecioBase * oRegistro.Coeficiente  
			
			If oRegistro.Incluye_Iva
				lnPrecioVenta = lnPrecioVenta * ( 1 + ( oRegistro.Alicuota_Iva / 100 ))   
			EndIf
			
			lnPrecioEnMonedaCorriente = lnPrecioVenta 
			
			If oRegistro.Moneda_Id # oRegistro.Moneda_Precio_Base
			    loMoneda 			= oMonedaBase 
				lnCotizacionBase 	= Val( loMoneda.List( loMoneda.ListItemId, _COTIZACION ))

			    loMoneda 			= oMonedaVenta 
				lnCotizacionVenta 	= Val( loMoneda.List( loMoneda.ListItemId, _COTIZACION ))

				lnPrecioEnMonedaCorriente = lnPrecioVenta * lnCotizacionBase / lnCotizacionVenta
				
			EndIf 
			
            oRegistro.Precio_Venta_Calculado = Round( lnPrecioVenta, 2 )
            oRegistro.Precio_Venta_En_Moneda_Corriente = Round( lnPrecioEnMonedaCorriente, 2 )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
        	loMoneda = Null 

        Endtry

    Endproc && CalcularPrecios

    *
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( Alltrim( This.cURL ))
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

            This.cURL = "archivos/apis/ProductoVenta/"

        Endif

        Return This.cURL
    Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oPrecioDeVenta
*!*
*!* ///////////////////////////////////////////////////////




***************
*   ANTERIOR  *
***************

*!* ///////////////////////////////////////////////////////
*!* Class.........: oPrecio
*!* Description...:
*!* Date..........: Jueves 21 de Julio de 2022 (10:14:43)
*!*
*!*

Define Class xxx___oPrecio As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oPrecio Of "Clientes\Archivos\prg\Producto.prg"
    #Endif

    lEditInBrowse 	= .F.
    cModelo 		= "Articulo_Venta"

    cFormIndividual = "Clientes\Archivos\Scx\Producto_Venta.scx"
    cGrilla 		= ""

    cURL 			= "archivos/apis/ProductoVenta/"

    cTituloEnForm 	= "Precio de Venta"
    cTituloEnGrilla = "Listas de Precio"

    lIsChild 		= .T.
    cParent 		= "Producto"

    lFiltrarPorClientePraxis = .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


    *
    *
    Procedure ObtenerPermisos( nPermisos As Integer ) As Void
        Local lcCommand As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"


        Try

            lcCommand = ""

            DoDefault( nPermisos )

            * RA 26/12/2022(11:19:39)
            * En Productos NO SE MUESTRA
            * (Jorge)
            This.lEditInBrowse 			= .F.
            This.lShowEditInBrowse 		= .F.
            This.lShowCamposEspeciales 	= .F.

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loUser = Null

        Endtry

    Endproc && ObtenerPermisos


    *
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( Alltrim( This.cURL ))
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

            This.cURL = "archivos/apis/ProductoVenta/"

        Endif

        Return This.cURL
    Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oPrecio
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oProveedor
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class XXX___oProveedor As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oProveedor Of "Clientes\Archivos\prg\Producto.prg"
    #Endif

    lEditInBrowse 	= .F.
    cModelo 		= "Articulo_Proveedor"

    cFormIndividual = "Clientes\Archivos\Scx\Producto_Proveedor.scx"
    cGrilla 		= ""

    cURL 			= "archivos/apis/ProductoProveedor/"

    cTituloEnForm 	= "Lista de Precio"
    cTituloEnGrilla = "Listas de Precios"

    lIsChild 		= .T.
    cParent 		= "Producto"

    lFiltrarPorClientePraxis = .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="calcularprecios" type="method" display="CalcularPrecios" />] + ;
        [<memberdata name="getcondiciones" type="method" display="GetCondiciones" />] + ;
        [<memberdata name="getcondicionescoeficiente" type="method" display="GetCondicionesCoeficiente" />] + ;
        [</VFPData>]


    *
    *
    Procedure ObtenerPermisos( nPermisos As Integer ) As Void
        Local lcCommand As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"


        Try

            lcCommand = ""

            DoDefault( nPermisos )

            * RA 26/12/2022(11:19:39)
            * En Productos NO SE MUESTRA
            * (Jorge)
            This.lEditInBrowse 			= .F.
            This.lShowEditInBrowse 		= .F.
            This.lShowCamposEspeciales 	= .F.

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loUser = Null

        Endtry

    Endproc && ObtenerPermisos



    *
    *
    Procedure CalcularPrecios( oRegistro As Object ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""

            oRegistro.condiciones = This.GetCondiciones(oRegistro.condiciones)
            oRegistro.condiciones_coeficiente = This.GetCondicionesCoeficiente( oRegistro.condiciones )
            oRegistro.Costo_Final_Calculado = Round( oRegistro.costo_base * oRegistro.condiciones_coeficiente, 2 )
            oRegistro.costo_en_moneda_corriente = Round( oRegistro.Costo_Final_Calculado * oRegistro.Cotizacion, 2 )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && CalcularPrecios



    *
    *
    Procedure GetCondiciones( cCondiciones As String ) As String
        Local lcCommand As String,;
            lcCondiciones As String,;
            lcTxt As String,;
            lcValoresProhibidos As String

        Local i As Integer,;
            lnLen As Integer

        Local x As Character

        Dimension laValoresPermitidos[4]

        Try

            lcCommand = ""

            lcTxt = Strtran( Alltrim( cCondiciones ), ",", "." )
            lcTxt = Strtran( lcTxt, " ", "" )

            laValoresPermitidos[ 1 ] = "+"
            laValoresPermitidos[ 2 ] = "-"
            laValoresPermitidos[ 3 ] = "*"
            laValoresPermitidos[ 4 ] = "."

            lcCondiciones 		= ""
            lcValoresProhibidos = ""
            lnLen = Len( lcTxt )

            For i = 1 To lnLen
                x = Substr( lcTxt, i, 1 )

                Do Case
                    Case Isdigit( x )
                        lcCondiciones = lcCondiciones + x

                    Case Ascan( laValoresPermitidos, x ) > 0
                        lcCondiciones = lcCondiciones + x

                    Otherwise
                        lcValoresProhibidos = lcValoresProhibidos + x

                Endcase

            Endfor

            If Len( lcValoresProhibidos ) > 0
                TEXT To lcMsg NoShow TextMerge Pretext 03
            	Sólo estan permitidos Dígitos y los signos [+], [-] y [*]
                ENDTEXT

                Warning( lcMsg, "Condiciones" )

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return lcCondiciones

    Endproc && GetCondiciones

    *
    *
    Procedure GetCondicionesCoeficiente( cCondiciones As String ) As Number
        Local lcCommand As String,;
            lcTxt As String,;
            lcAux As String
        Local lnCoeficiente As Number,;
            k As Number,;
            j As Number
        Local lnLen As Integer,;
            i As Integer

        Try

            lcCommand = ""

            lcTxt = Strtran( Alltrim( cCondiciones ), "+", "#+" )
            lcTxt = Strtran( lcTxt, "-", "#-" )
            lcTxt = Strtran( lcTxt, "*", "#*" )

            If Substr( lcTxt, 1, 1 ) # "#"
                lcTxt = "#+" + lcTxt
            Endif

            lnCoeficiente = 1

            lnLen = Getwordcount( lcTxt, "#" )
            For i = 1 To lnLen
                lcAux = Getwordnum( lcTxt, i, "#" )

                If Substr( lcAux, 1, 1 ) == "*"
                    k = Val( Substr( lcAux, 2 ))
                    lnCoeficiente = lnCoeficiente * k

                Else
                    j = Abs(Val( lcAux ) )
                    If Val( lcAux ) > 0
                        lnCoeficiente = lnCoeficiente * ( 1 + ( j / 100 ))

                    Else
                        lnCoeficiente = lnCoeficiente * ( 1 - ( j / 100 ))

                    Endif

                Endif

            Endfor

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return Round( lnCoeficiente, 4 )

    Endproc && GetCondicionesCoeficiente




    *
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( Alltrim( This.cURL ))
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

            This.cURL = "archivos/apis/ProductoProveedor/"

        Endif

        Return This.cURL
    Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oProveedor
*!*
*!* ///////////////////////////////////////////////////////


*!* ///////////////////////////////////////////////////////
*!* Class.........: oPrecioDeVenta
*!* Description...:
*!* Date..........: Sábado 6 de Agosto de 2022 (12:09:11)
*!*
*!*

Define Class xxx___oPrecioDeVenta As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oPrecioDeVenta Of "Clientes\Archivos\prg\Producto.prg"
    #Endif

    lEditInBrowse 	= .F.
    cModelo 		= "PreciosDeVenta"

    cFormIndividual = "Clientes\Archivos\Scx\Producto_Venta.scx"
    cGrilla 		= ""

    cURL 			= "archivos/apis/PrecioDeVenta/"

    cTituloEnForm 	= "Precio de Venta"
    cTituloEnGrilla = "Listas de Precio"

    lIsChild 		= .T.
    cParent 		= "Producto"

    lFiltrarPorClientePraxis = .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]

    *
    *
    Procedure ObtenerPermisos( nPermisos As Integer ) As Void
        Local lcCommand As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"


        Try

            lcCommand = ""

            DoDefault( nPermisos )

            * RA 26/12/2022(11:19:39)
            * En Productos NO SE MUESTRA
            * (Jorge)
            This.lEditInBrowse 			= .F.
            This.lShowEditInBrowse 		= .F.
            This.lShowCamposEspeciales 	= .F.

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loUser = Null

        Endtry

    Endproc && ObtenerPermisos

    *
    *
    Procedure CalcularPrecios( oRegistro As Object ) As Void
        Local lcCommand As String

        Try

            lcCommand = ""

            oRegistro.condiciones = This.GetCondiciones(oRegistro.condiciones)
            oRegistro.condiciones_coeficiente = This.GetCondicionesCoeficiente( oRegistro.condiciones )
            oRegistro.Costo_Final_Calculado = Round( oRegistro.costo_base * oRegistro.condiciones_coeficiente, 2 )
            oRegistro.costo_en_moneda_corriente = Round( oRegistro.Costo_Final_Calculado * oRegistro.Cotizacion, 2 )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

    Endproc && CalcularPrecios



    *
    *
    Procedure GetCondiciones( cCondiciones As String ) As String
        Local lcCommand As String,;
            lcCondiciones As String,;
            lcTxt As String,;
            lcValoresProhibidos As String

        Local i As Integer,;
            lnLen As Integer

        Local x As Character

        Dimension laValoresPermitidos[4]

        Try

            lcCommand = ""

            lcTxt = Strtran( Alltrim( cCondiciones ), ",", "." )
            lcTxt = Strtran( lcTxt, " ", "" )

            laValoresPermitidos[ 1 ] = "+"
            laValoresPermitidos[ 2 ] = "-"
            laValoresPermitidos[ 3 ] = "*"
            laValoresPermitidos[ 4 ] = "."

            lcCondiciones 		= ""
            lcValoresProhibidos = ""
            lnLen = Len( lcTxt )

            For i = 1 To lnLen
                x = Substr( lcTxt, i, 1 )

                Do Case
                    Case Isdigit( x )
                        lcCondiciones = lcCondiciones + x

                    Case Ascan( laValoresPermitidos, x ) > 0
                        lcCondiciones = lcCondiciones + x

                    Otherwise
                        lcValoresProhibidos = lcValoresProhibidos + x

                Endcase

            Endfor

            If Len( lcValoresProhibidos ) > 0
                TEXT To lcMsg NoShow TextMerge Pretext 03
            	Sólo estan permitidos Dígitos y los signos [+], [-] y [*]
                ENDTEXT

                Warning( lcMsg, "Condiciones" )

            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return lcCondiciones

    Endproc && GetCondiciones

    *
    *
    Procedure GetCondicionesCoeficiente( cCondiciones As String ) As Number
        Local lcCommand As String,;
            lcTxt As String,;
            lcAux As String
        Local lnCoeficiente As Number,;
            k As Number,;
            j As Number
        Local lnLen As Integer,;
            i As Integer

        Try

            lcCommand = ""

            lcTxt = Strtran( Alltrim( cCondiciones ), "+", "#+" )
            lcTxt = Strtran( lcTxt, "-", "#-" )
            lcTxt = Strtran( lcTxt, "*", "#*" )

            If Substr( lcTxt, 1, 1 ) # "#"
                lcTxt = "#+" + lcTxt
            Endif

            lnCoeficiente = 1

            lnLen = Getwordcount( lcTxt, "#" )
            For i = 1 To lnLen
                lcAux = Getwordnum( lcTxt, i, "#" )

                If Substr( lcAux, 1, 1 ) == "*"
                    k = Val( Substr( lcAux, 2 ))
                    lnCoeficiente = lnCoeficiente * k

                Else
                    j = Abs(Val( lcAux ) )
                    If Val( lcAux ) > 0
                        lnCoeficiente = lnCoeficiente * ( 1 + ( j / 100 ))

                    Else
                        lnCoeficiente = lnCoeficiente * ( 1 - ( j / 100 ))

                    Endif

                Endif

            Endfor

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return Round( lnCoeficiente, 4 )

    Endproc && GetCondicionesCoeficiente




    *
    *
    Procedure Traer( cURL As String, uValue As Variant, cAlias As String ) As Object
        Local lcCommand As String
        Local loReturn As Object

        Try

            lcCommand = ""
            cURL = "archivos/apis/ProductoVenta/"
            loReturn = DoDefault( cURL, uValue, cAlias )

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return loReturn

    Endproc && Traer

    *
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( Alltrim( This.cURL ))
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

            This.cURL = "archivos/apis/PrecioDeVenta/"

        Endif

        Return This.cURL
    Endproc

Enddefine
*!*
*!* END DEFINE
*!* Class.........: oPrecioDeVenta
*!*
*!* ///////////////////////////////////////////////////////



