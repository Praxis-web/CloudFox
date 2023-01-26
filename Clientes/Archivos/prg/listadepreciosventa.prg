#INCLUDE "FW\Comunes\Include\Praxis.h"

*
*
Procedure ListaDePreciosVenta( nPermisos As Integer,;
        nParam2 As Integer,;
        nParam3 As Integer,;
        nParam4 As Integer,;
        nParam5 As Integer,;
        cURL As String,;
        lDoPrg ) As Void

    Local lcCommand As String
    Local loListaDePreciosVenta As oListaDePreciosVenta Of "Clientes\Archivos\prg\ListaDePreciosVenta.prg",;
        loParam As Object


    Try

        lcCommand = ""

        loParam = Createobject( "Empty" )

        AddProperty( loParam, "nPermisos", nPermisos )
        AddProperty( loParam, "cURL", cURL  )

        loListaDePreciosVenta = GetEntity( "Lista_Precios_Venta" )
        loListaDePreciosVenta.Initialize( loParam )

        AddProperty( loParam, "oBiz", loListaDePreciosVenta )

        Do Form (loListaDePreciosVenta.cGrilla) ;
            With loParam To loReturn



    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally
        loListaDePreciosVenta = Null

    Endtry

Endproc && ListaDePreciosVenta

*!* ///////////////////////////////////////////////////////
*!* Class.........: oListaDePreciosVenta
*!* Description...:
*!* Date..........: Sábado 11 de Septiembre de 2021 (12:42:50)
*!*
*!*

Define Class oListaDePreciosVenta As oModelo Of "FrontEnd\Prg\Modelo.prg"

    #If .F.
        Local This As oListaDePreciosVenta Of "Clientes\Archivos\prg\ListaDePreciosVenta.prg"
    #Endif

    lEditInBrowse 	= .F.
    cModelo 		= "Lista_Precios_Venta"

    cFormIndividual = "Clientes\Archivos\Scx\ListaDePreciosVenta.scx"
    cGrilla 		= "Clientes\Archivos\Scx\ListasDePreciosVentas.scx"

    cTituloEnForm 	= "Lista de Precios de Venta"
    cTituloEnGrilla = "Listas de Precios de Ventas"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="sincronizarlistadeprecios" type="method" display="SincronizarListaDePrecios" />] + ;
        [</VFPData>]

    *
    *
    Procedure ObtenerPermisos( nPermisos As Integer ) As Void
        Local lcCommand As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"


        Try

            lcCommand = ""

            DoDefault( nPermisos )

            If This.lShowCamposEspeciales
                This.lEditInBrowse 		= .F.
                This.lShowEditInBrowse 	= .T.
            Endif

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
    Procedure NoVa___SincronizarListaDePrecios( oListasDePrecio As Collection ) As Boolean
        Local lcCommand As String,;
        lcUrl as String 
        Local llOk As Boolean
        Local loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg",;
            loReturn As Object,;
            loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loRespuesta As Object,;
            loParam as Object,;
            loReg As Object


        Try

            lcCommand = ""
            lcUrl = "ventas/apis/PreciosVenta/AuditoriaDePreciosVenta/"
            
            loConsumirAPI = NewConsumirAPI()
            loConsumirAPI.cTrace 	= Program()
            loConsumirAPI.cRemark 	= "Sincronizar Listas de Precio"
            
            loParam = CreateObject( "Empty" )
            AddProperty( loParam, "listasDePrecio", oListasDePrecio )   
            
            lnSecoonds = Seconds()

            loRespuesta = loConsumirAPI.Listar( lcUrl )
            
            If loRespuesta.lOk
            	loData = loRespuesta.Data
            	llOk = .T.
            	
            	Text To lcMsg NoShow TextMerge Pretext 03
            	Registros Creados: <<loData.Count>>
            	
            	Tiempo transcurrido: <<loRespuesta.nElapsedSend>>            	
            	EndText
            	
            	Inform( lcMsg, loData.Proceso )
            
            Else
            	llOk = .F.
            	
                This.ManejarErrores( loRespuesta )
                This.MostrarErrores()
            	
            
            EndIf 

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return llOk

    Endproc && SincronizarListaDePrecios



    *
    *
    Procedure SincronizarListaDePrecios( oListasDePrecio As Collection ) As Boolean
        Local lcCommand As String,;
        lcUrl as String 
        Local llOk As Boolean
        Local loConsumirAPI As ConsumirAPI Of "FW\Comunes\prg\BackEndSettings.prg",;
            loReturn As Object,;
            loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
            loRespuesta As Object,;
            loParam as Object,;
            loReg As Object


        Try

            lcCommand = ""
            lcUrl = "archivos/apis/SincronizarListasDePrecios/"
            
            loConsumirAPI = NewConsumirAPI()
            loConsumirAPI.cTrace 	= Program()
            loConsumirAPI.cRemark 	= "Sincronizar Listas de Precio"
            
            loParam = CreateObject( "Empty" )
            AddProperty( loParam, "listasDePrecio", oListasDePrecio )   
            
            lnSecoonds = Seconds()

            loRespuesta = loConsumirAPI.Bulk_Create( lcUrl, loParam )
            
            If loRespuesta.lOk
            	loData = loRespuesta.Data
            	llOk = .T.
            	
            	Text To lcMsg NoShow TextMerge Pretext 03
            	Registros Creados: <<loData.Count>>
            	
            	Tiempo transcurrido: <<loRespuesta.nElapsedSend>>            	
            	EndText
            	
            	Inform( lcMsg, loData.Proceso )
            
            Else
            	llOk = .F.
            
            EndIf 

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return llOk

    Endproc && xxx___SincronizarListaDePrecios



    *
    * cUrl_Access
    Procedure cUrl_Access()

        If Empty( Alltrim( This.cURL ))
            * Inicializar la URL
            * Puede ponerse duro para cada modelo,
            * o leerse de un archivo de configuración local
            * para una personalización especial

            This.cURL = "archivos/apis/ListaDePreciosVenta/"

        Endif

        Return This.cURL

    Endproc && cUrl_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oListaDePreciosVenta
*!*
*!* ///////////////////////////////////////////////////////

*!*	Define Class cboForma_de_Calculo As ComboBox

*!*	    #If .F.
*!*	        Local This As cboForma_de_Calculo Of "Clientes\Archivos\prg\ListaDePreciosVenta.prg"
*!*	    #Endif

*!*	    BoundColumn 	= 2
*!*	    BoundTo 		= .T.
*!*	    ColumnCount 	= 1
*!*	    RowSourceType 	= 0
*!*	    RowSource 		= ""
*!*	    Style			= 2
*!*	    Sorted 			= .F.


*!*	    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*	        [<VFPData>] + ;
*!*	        [</VFPData>]


*!*	    Procedure Init()
*!*	        Local lcCommand As String

*!*	        Try

*!*	            lcCommand = ""

*!*	            This.AddItem( "Ingreso Precio" )
*!*	            This.List( This.NewIndex, 2 ) = Transform( 1 )

*!*	            This.AddItem( "Se Calcula a partir del Costo" )
*!*	            This.List( This.NewIndex, 2 ) = Transform( 2 )

*!*	            This.AddItem( "Se Calcula a partir de otra Lista" )
*!*	            This.List( This.NewIndex, 2 ) = Transform( 3 )

*!*	        Catch To loErr
*!*	            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
*!*	            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
*!*	            loError.cRemark = lcCommand
*!*	            loError.Process ( m.loErr )
*!*	            Throw loError

*!*	        Finally


*!*	        Endtry

*!*	    Endproc

*!*	Enddefine && cboForma_de_Calculo

*!*	Define Class cboLista_Base As ComboBoxBase Of "Clientes\Utiles\prg\utDataDictionary.prg"

*!*	    #If .F.
*!*	        Local This As cboLista_Base Of "Clientes\Archivos\prg\ListaDePreciosVenta.prg"
*!*	    #Endif


*!*	    cTable 	= "Lista_Precios_Venta"
*!*	    cModelo = "Lista_Precios_Venta"

*!*	    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*	        [<VFPData>] + ;
*!*	        [</VFPData>]

*!*	EndDefine && cboLista_Base

