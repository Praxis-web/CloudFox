#INCLUDE "FW\Comunes\Include\Praxis.h"

#Define inf__PreciosDeCosto				1

*
*
Procedure PreciosPorRango( nPermisos As Integer,;
        nParam2 As Integer,;
        nParam3 As Integer,;
        nParam4 As Integer,;
        nParam5 As Integer,;
        cURL As String,;
        lDoPrg ) As Void

    Local lcCommand As String
    Local loPrecios As oPreciosDeCostoPorRango Of "Clientes\Ventas\Prg\PreciosPorRango.prg"

    Try

        lcCommand = ""

        Do Case
            Case nParam2 = 1	&& Ventas
                loPrecios = GetEntity( "Precios_Venta" )

            Case nParam2 = 2	&& Compras
                loPrecios = GetEntity( "Precios_Costo" )
                loPrecios = Newobject("oPreciosDeCostoPorRango",  "Clientes\Ventas\Prg\PreciosPorRango.prg" )

            Otherwise

        Endcase

        loParam = Createobject( "Empty" )

        AddProperty( loParam, "oBiz", loPrecios )
        AddProperty( loParam, "cModelo", loPrecios.cModelo )

        Do Form ( loPrecios.cFormularioInformes ) ;
            With loParam To loReturn

    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally

    Endtry

Endproc && PreciosPorRango

*!* ///////////////////////////////////////////////////////
*!* Class.........: oPreciosPorRango
*!* Description...:
*!* Date..........: Martes 13 de Septiembre de 2022 (17:52:02)
*!*
*!*

Define Class oPreciosDeCostoPorRango As oMovimiento Of "FrontEnd\Prg\Movimiento.prg"

    #If .F.
        Local This As oPreciosDeCostoPorRango Of "Clientes\Ventas\Prg\PreciosPorRango.prg"
    #Endif

    cFormularioInformes = "Clientes\Ventas\Scx\PreciosDeCostoPorRango.scx"
    cTituloDelInforme 	= "Actualización de Precios de Costo por Rango"
    cGrilla = "Clientes\Ventas\Scx\PreciosDeCostoPorRango_Grilla.scx"

    cTabla 	= "PreciosDeCosto"
    cModelo	= "Precios_Costo"

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [</VFPData>]


    *
    *
    Procedure ParametrosVariables( oParametros As Object ) As Collection
        Local loFilterCriteria As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg,;
            loFiltro As cntFiltro_Adicional Of "FrontEnd\Vcx\informes.vcx",;
            loFilter As Object

        Local llFiltra As Boolean

        Try

            lcCommand = ""

            loFilterCriteria = DoDefault( oParametros )

            For Each loFiltro In oParametros.oFiltrosAdicionales

                If loFiltro.Visible = .T. And loFiltro.chkActivo.Value = .T.
                    loFilter = Createobject( "Empty" )
                    AddProperty( loFilter, "Nombre", Lower( loFiltro.Name ))
                    llFiltra = .T.

                    Do Case
                        Case loFiltro.Name = "Activo"
                            AddProperty( loFilter, "FieldName", "activo" )
                            AddProperty( loFilter, "FieldRelation", "==" )

                            Do Case
                                Case loFiltro.OptionGroup.Value = 1	&& Todos
                                    llFiltra = .F.

                                Case loFiltro.OptionGroup.Value = 2	&& Activos
                                    AddProperty( loFilter, "FieldValue", Any2String( .T. ))

                                Case loFiltro.OptionGroup.Value = 3	&& No Activos
                                    AddProperty( loFilter, "FieldValue", Any2String( .F. ))

                            Endcase

                    Endcase

                    If llFiltra
                        loFilterCriteria.Add( loFilter, Lower( loFilter.Nombre ))
                    Endif

                Endif

            Endfor

            AddProperty( loFilterCriteria, "oActualizar", oParametros.oActualizar )


        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally

        Endtry

        Return loFilterCriteria

    Endproc && ParametrosVariables

    *
    *
    Procedure Listar( cURL As String,;
            oFilterCriteria As Collection,;
            cAlias As String ) As Object
        Local lcCommand As String,;
            lcTitulo As String
        Local loTiposDeInforme As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg',;
            loInforme As Object,;
            loBody As Object

        Try

            lcCommand = ""

            lcTitulo = This.cTituloDelInforme

            loTiposDeInforme = This.oTiposDeInforme
            loInforme = loTiposDeInforme.GetItem( Transform( This.nInformeId ) )
            This.cTituloDelInforme = loInforme.Caption

            loBody = Createobject( "Empty" )

            For Each loItem In oFilterCriteria.oActualizar
                If loItem.chkActivo.Value = .T.
                    lcNombre = ""
                    lcValor = ""

                    Do Case
                        Case loItem.Name = "Costo_Base"
                            Do Case
                                Case loItem.OptionGroup.Value = 1
                                    lcNombre 	= "costo_base_valor"
                                    lcValor 	= Str( loItem.spnImporte.Value, 14, 2 )

                                Case loItem.OptionGroup.Value = 2
                                    lcNombre 	= "costo_base"
                                    lcValor 	= Str( loItem.spnPorcentaje.Value, 8, 2 )

                                Otherwise

                            Endcase

                        Case loItem.Name = "Bonificaciones"
                            lcNombre 	= "bonificaciones"
                            lcValor 	= loItem.txtBonificaciones.Value

                        Case loItem.Name = "Coeficiente"
                            lcNombre 	= "coeficiente"
                            lcValor 	= Str( loItem.spnCoeficiente.Value, 6, 2 )

                        Case loItem.Name = "Recargo"
                            lcNombre 	= "recargo"
                            lcValor 	= Str( loItem.spnRecargo.Value, 6, 2 )

                        Case loItem.Name = "Moneda"
                            lcNombre 	= "moneda"
                            lcValor 	= Transform( loItem.cboMoneda.Value )

                        Case loItem.Name = "Activo"
                            lcNombre 	= "activo"
                            lcValor 	= Any2String( loItem.chkSetActivo.Value )

                        Otherwise

                    EndCase
                    
                    If !Empty( lcNombre )
						AddProperty( loBody, "act_" + lcNombre, Alltrim( lcValor ))
                    EndIf

                Endif

            EndFor
            
            loReturn = DoDefault( cURL, oFilterCriteria, cAlias, loBody )

            If loReturn.lOk
                Select Alias( loReturn.cAlias )
                Locate
                *Browse
            Endif

            This.cTituloDelInforme 	= lcTitulo

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally
            loInforme = Null
            loTiposDeInforme = Null

        Endtry

        Return loReturn

    Endproc && Listar


    *
    * oSalidas_Access
    Protected Procedure oSalidas_Access()

        If Vartype( This.oSalidas ) # "O"
            Local loSalidas As Collection,;
                loSalida As Object

            loSalidas = Createobject( "Collection" )
            AddProperty( loSalidas, "Default", S_PROCESO )

            *!*	* -------------- Tipo de Salida -------------------------
            *!*	#Define S_IMPRESORA					'0'
            *!*	#Define S_VISTA_PREVIA				'1'
            *!*	#Define S_HOJA_DE_CALCULO			'2'
            *!*	#Define S_PANTALLA					'3'
            *!*	#Define S_PDF						'4'
            *!*	#Define S_CSV						'5'
            *!*	#Define S_SDF						'6'
            *!*	#Define S_IMPRESORA_PREDETERMINADA	'7'
            *!*	#Define S_TXT						'8'
            *!*	#Define S_MAIL						'9'
            *!*	#Define S_LISTADO_DOS				'99'



            loSalida = Createobject( "Empty" )
            AddProperty( loSalida, "Nombre", "Pantalla" )
            AddProperty( loSalida, "Id", S_PANTALLA )
            AddProperty( loSalida, "Activo", .T. )

            loSalidas.Add( loSalida, loSalida.Id )

            loSalida = Createobject( "Empty" )
            AddProperty( loSalida, "Nombre", "Ejecutar Proceso" )
            AddProperty( loSalida, "Id", S_PROCESO )
            AddProperty( loSalida, "Activo", .T. )

            loSalidas.Add( loSalida, loSalida.Id )

            This.oSalidas = loSalidas


        Endif

        Return This.oSalidas

    Endproc && oSalidas_Access


    *
    * oTiposDeInforme_Access
    Protected Procedure oTiposDeInforme_Access()
        Local lcCommand As String
        Local loTiposDeInforme As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg',;
            loInforme As Object


        Try

            lcCommand = ""
            If Isnull( This.oTiposDeInforme )
                loTiposDeInforme = Newobject( "oColBase", 'Tools\DataDictionary\prg\oColBase.prg' )

                loInforme = Createobject( "Empty" )

                AddProperty( loInforme, "Caption", "Precios de Costo" )
                AddProperty( loInforme, "Url", "ventas/apis/PreciosDeCostoList/" )
                AddProperty( loInforme, "Activo", .T. )
                AddProperty( loInforme, "Id", inf__PreciosDeCosto )

                loTiposDeInforme.Add( loInforme, Transform( inf__PreciosDeCosto ) )


                This.oTiposDeInforme = loTiposDeInforme
            Endif

        Catch To loErr
            Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
            loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
            loError.cRemark = lcCommand
            loError.Process ( m.loErr )
            Throw loError

        Finally


        Endtry


        Return This.oTiposDeInforme

    Endproc && oTiposDeInforme_Access


Enddefine
*!*
*!* END DEFINE
*!* Class.........: oPreciosPorRango
*!*
*!* ///////////////////////////////////////////////////////




