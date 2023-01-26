#INCLUDE "FW\Comunes\Include\Praxis.h" 
*
*
Procedure ImportarOrganizaciones( nPermisos As Integer,;
        nParam2 As Integer,;
        nParam3 As Integer,;
        nParam4 As Integer,;
        nParam5 As Integer,;
        cURL As String,;
        lDoPrg ) As Void

    Local lcCommand As String
    Local lnOrg_Id As Integer,;
        lnCliente As Integer,;
        lnProveedor As Integer

    Try

        lcCommand = ""
        Use "w:\Pasaje\Fenix\Luque\Dbf\Central\Dbf\ar4Var" Shared In 0
        Use "w:\Pasaje\ExportarTablas\Organizaciones_Base" Shared In 0
        
        Set Step On 

        Select Organizaciones_Base
        Set Order To Tag "Id"
        Locate
        Scan

            TEXT To lcMsg NoShow TextMerge Pretext 03
			(<<Transform( Id )>>)
			Cliente: <<Transform( Cliente )>>
			<<Alltrim( Nombre )>>
            ENDTEXT

            Wait Window Nowait Noclear lcMsg
            Inkey()

            If Lastkey()=27
                If Confirm( "Cancela?" )
                    Exit
                Endif
            Endif

            lnOrg_Id 	= Organizaciones_Base.Id
            lnCliente 	= Organizaciones_Base.Cliente
            lnProveedor = Organizaciones_Base.Proveedor

            If !CrearCliente_o_Proveedor( lnOrg_Id, lnCliente, lnProveedor )
                If Confirm( "Cancela?" )
                    Exit
                Endif
            Endif

        Endscan

        Wait Clear


    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally

    Endtry

Endproc && ImportarOrganizaciones

*
*
Procedure CrearCliente_o_Proveedor( nOrg_Id As Integer,;
        nCliente As Integer, ;
        nProveedor As Integer ) As Boolean
    Local lcCommand As String
    Local llDone As Boolean

    Try

        lcCommand = ""
        llDone = .T.

        If !Empty( nCliente )
            llDone = CrearCliente( nOrg_Id, nCliente )
        Endif

        If !Empty( nCliente ) And llDone
            llDone = CrearProveedor( nOrg_Id, nCliente )
        Endif


    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally


    Endtry

    Return llDone

Endproc && CrearCliente_o_Proveedor

*
*
Procedure CrearCliente( nOrg_Id As Integer,;
        nCliente As Integer ) As Boolean

    Local lcCommand As String,;
		lcAlias as String 
    Local llDone As Boolean
    Local loCliente As oCliente Of "Clientes\Archivos\prg\OrganizacionCliente.prg",;
        loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
        loColFields As oColFields Of 'Tools\DataDictionary\prg\oColFields.prg',;
        loRegistro as Object 

    Try

        lcCommand = ""
        If Seek( '1' + Str( nCliente, 5 ), "ar4Var", "pk4Var" )
            loCliente = Newobject( "oCliente", "Clientes\Archivos\prg\OrganizacionCliente.prg" )
            loArchivo = GetTable( "Organizacion_Cliente" )
            lcAlias = loArchivo.CrearCursor() 
            Select Alias( lcAlias ) 
            Scatter Memo Blank Name loRegistro
            AddProperty( loRegistro, "ABM", ABM_ALTA )
            llDone = loCliente.Grabar( loRegistro ) 

        Endif


    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally

    Endtry

    Return llDone

Endproc && CrearCliente


*
*
Procedure CrearProveedor( nOrg_Id As Integer,;
        nProveedor As Integer ) As Boolean

    Local lcCommand As String
    Local llDone As Boolean

    Try

        lcCommand = ""


    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally

    Endtry

    Return llDone

Endproc && CrearProveedor







