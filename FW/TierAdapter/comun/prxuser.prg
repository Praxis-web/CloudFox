#INCLUDE "FW\TierAdapter\Include\TA.h"

* RA 2013-01-20(13:21:17)
* Definido para poder tener compatibilidad con la vieja version de oUser creada con objParam()
* Hay muchas propiedades redundantes por ese motivo

Local lcCommand As String

Try

    lcCommand = ""

Catch To oErr
    Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"
    loError = Newobject( "ErrorHandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
    loError.Cremark = lcCommand
    loError.Process( oErr )


Finally


Endtry

*!* ///////////////////////////////////////////////////////
*!* Class.........: User
*!* ParentClass...: prxEntity Of 'V:\Clipper2fox\Fw\Tieradapter\Comun\prxEntity.prg'
*!* BaseClass.....: Session
*!* Description...:
*!* Date..........: Sábado 13 de Octubre de 2012 (13:37:30)
*!* Author........: Ricardo Aidelman
*!* Project.......: Clipper2Fox
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class User As prxEntity Of 'Fw\Tieradapter\Comun\prxEntity.prg'

    #If .F.
        Local This As User Of "Fw\TierAdapter\Comun\prxUser.prg"
    #Endif

    cMainTableName 	= "sys_Users"
    cMainCursorName = "cUser"


    * Indica la Empresa Activa para el Usuario
    nEmpresaActivaId = 0

    *
    nSucursalActivaId = 0



    * Indica la Ejercicio Activo para el Usuario
    nEjercicioActivoId = 0

    * Descripcion de la Empres Activa para el Usuario
    cDescripcionEmpresaActiva = ""

    * Descripcion de la Sucursal Activa para el Usuario
    cDescripcionSucursalActiva = ""

    *
    OrganizationId = 0

    *
    Id = 0

    *
    GroupId = 0

    * Nombre del Grupo
    Grupo = ""

    *
    Empresa_Activa = 0

    *
    LoginName = ""

    *
    Password = ""

    *
    IsSystem = .F.

    *
    IsAdmin = .F.

    *
    IsActive = .F.

    *
    CreationDate = Ctot( "" )

    *
    HasExpirationDate = .F.

    *
    ExpirationDate = Ctot("")

    *
    eMail = ""

    *
    Picture = ""

    *
    Descripcion = ""

    *
    Nombre = ""

    *
    Apellido = ""



    *
    IsGuest = .T.

    *
    IsImplementador = .F.

    *
    Clave = 0

    *
    Nivel = 0

    *
    Usuario = ""

    *
    lOk = .T.

    *
    Permiso = 0

    *
    VendedorId = 0

    *
    oAutorizador = Null

    * Cantidad de sesiones abiertas simultáneamente
    nAllowedSessions = 1
    *
    lIsSuperuser = .F.

    *
    lIsStaff = .F.

    *
    lIsActive = .T.

    *
    nClientePraxis = 0

    *
    cToken = ""

    lModificaActivo 	= .F.
    lModificaOrden 		= .F.
    lModificaEsSistema 	= .F.
    lShowEditInBrowse	= .F.

    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
        [<VFPData>] + ;
        [<memberdata name="nsucursalactivaid" type="property" display="nSucursalActivaId" />] + ;
        [<memberdata name="ctoken" type="property" display="cToken" />] + ;
        [<memberdata name="nclientepraxis" type="property" display="nClientePraxis" />] + ;
        [<memberdata name="lisactive" type="property" display="lIsActive" />] + ;
        [<memberdata name="lisstaff" type="property" display="lIsStaff" />] + ;
        [<memberdata name="lissuperuser" type="property" display="lIsSuperuser" />] + ;
        [<memberdata name="lmodificaactivo" type="property" display="lModificaActivo" />] + ;
        [<memberdata name="lmodificaorden" type="property" display="lModificaOrden" />] + ;
        [<memberdata name="lmodificaessistema" type="property" display="lModificaEsSistema" />] + ;
        [<memberdata name="lshoweditinbrowse" type="property" display="lShowEditInBrowse" />] + ;
        [<memberdata name="nallowedsessions" type="property" display="nAllowedSessions" />] + ;
        [<memberdata name="groupid" type="property" display="GroupId" />] + ;
        [<memberdata name="vendedorid" type="property" display="VendedorId" />] + ;
        [<memberdata name="grupo" type="property" display="Grupo" />] + ;
        [<memberdata name="id" type="property" display="Id" />] + ;
        [<memberdata name="lok" type="property" display="lOk" />] + ;
        [<memberdata name="permiso" type="property" display="Permiso" />] + ;
        [<memberdata name="descripcion" type="property" display="Descripcion" />] + ;
        [<memberdata name="usuario" type="property" display="Usuario" />] + ;
        [<memberdata name="organizationid" type="property" display="OrganizationId" />] + ;
        [<memberdata name="empresa_activa" type="property" display="Empresa_Activa" />] + ;
        [<memberdata name="loginname" type="property" display="LoginName" />] + ;
        [<memberdata name="password" type="property" display="Password" />] + ;
        [<memberdata name="issystem" type="property" display="IsSystem" />] + ;
        [<memberdata name="isadmin" type="property" display="IsAdmin" />] + ;
        [<memberdata name="isactive" type="property" display="IsActive" />] + ;
        [<memberdata name="nivel" type="property" display="Nivel" />] + ;
        [<memberdata name="clave" type="property" display="Clave" />] + ;
        [<memberdata name="isguest" type="property" display="IsGuest" />] + ;
        [<memberdata name="nombre" type="property" display="Nombre" />] + ;
        [<memberdata name="apellido" type="property" display="Apellido" />] + ;
        [<memberdata name="creationdate" type="property" display="CreationDate" />] + ;
        [<memberdata name="hasexpirationdate" type="property" display="HasExpirationDate" />] + ;
        [<memberdata name="expirationdate" type="property" display="ExpirationDate" />] + ;
        [<memberdata name="email" type="property" display="eMail" />] + ;
        [<memberdata name="picture" type="property" display="Picture" />] + ;
        [<memberdata name="nempresaactivaid" type="property" display="nEmpresaActivaId" />] + ;
        [<memberdata name="nejercicioactivoid" type="property" display="nEjercicioActivoId" />] + ;
        [<memberdata name="cdescripcionempresaactiva" type="property" display="cDescripcionEmpresaActiva" />] + ;
        [<memberdata name="getbyid" type="method" display="GetById" />] + ;
        [<memberdata name="isimplementador" type="property" display="IsImplementador" />] + ;
        [<memberdata name="oautorizador" type="property" display="oAutorizador" />] + ;
        [</VFPData>]

    *
    * Devuelve el objeto User correspondiente al Id requerido
    Procedure GetById( nId As Integer ) As Void;
            HELPSTRING "Devuelve el objeto User correspondiente al Id requerido"
        Local lcCommand As String
        Local loUser As User Of "Fw\TierAdapter\Comun\prxUser.prg"
        Local lnImplementa As Integer

        Try

            lcCommand = ""
            loUser = Createobject( "User" )
            loUser.lOk = .F.
            lnImplementa = 2

            TxnUse( Trim( DRCOMUN ) + "Usuarios" )
            TxnUse( Trim( DRCOMUN ) + "Grupos" )

            TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From Usuarios
				Where Id = <<Int( nId )>>
				Into Cursor <<This.cMainCursorName>>
            ENDTEXT

            &lcCommand

            If _Tally = 1
                Select Alias( This.cMainCursorName )
                Locate

                loUser.IsAdmin 			= ( Nivel = 5 )
                loUser.IsGuest 			= .F.
                loUser.Usuario 			= Usuario
                loUser.nEmpresaActivaId = 0
                loUser.Nivel			= Nivel
                loUser.Clave 			= Nivel
                loUser.Permiso			= Permiso
                loUser.GroupId			= GroupId
                loUser.Grupo			= ""
                loUser.Descripcion 		= Usuario
                loUser.Nombre 			= Nombre
                loUser.Id 				= nId
                loUser.lOk 				= .T.
                loUser.IsImplementador	= ( GroupId = GRP_IMPLEMENTADOR )

                If !Empty( Field( "Implementa", This.cMainCursorName ))
                    lnImplementa = Implementa

                Else
                    lnImplementa = 2

                Endif

                TEXT To lcCommand NoShow TextMerge Pretext 15
					Select *
						From Grupos g
						Where g.Id = <<loUser.GroupId>>
						Into Cursor cGrupo
                ENDTEXT

                &lcCommand

                If _Tally = 1
                    loUser.Grupo = cGrupo.Nombre

                    If !Empty( Field( "Implementa", "cGrupo" ))
                        lnImplementa = cGrupo.Implementa
                    Endif

                Else
                    loUser.Grupo = ""

                Endif

                If lnImplementa # 2
                    loUser.IsImplementador	= ( lnImplementa = 1 )
                Endif

            Endif


        Catch To oErr
            Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

            loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
            loError.Cremark = lcCommand
            loError.Process( oErr )
            Throw loError

        Finally
            Use In Select( "Usuarios" )
            Use In Select( "Grupos" )
            Use In Select( This.cMainCursorName )
            Use In Select( "cGrupo" )


        Endtry

        Return loUser

    Endproc && GetById


Enddefine
*!*
*!* END DEFINE
*!* Class.........: User
*!*
*!* ///////////////////////////////////////////////////////
