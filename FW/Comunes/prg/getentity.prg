

*
*
Procedure GetEntity( tcEntityName As String, lStateFull As Boolean ) As Object;
        HELPSTRING "Devuelve un Objeto de la colección Entities"

    Local lcCommand As String

    Local loEntity As oModelo Of "FrontEnd\Prg\Modelo.prg",;
        loGlobalSettings As GlobalSettings Of "FW\Comunes\Prg\GlobalSettings.prg",;
        loColEntities As oColBase Of 'Tools\DataDictionary\prg\oColBase.prg',;
        loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg",;
        loColTables As oColTables Of 'Tools\DataDictionary\prg\oColTables.prg',;
        loArchivo As Archivo Of "Clientes\Utiles\Prg\utRutina.prg"


    Try

        lcCommand = ""

        loEntity = Null
        loGlobalSettings = NewGlobalSettings()
        loColEntities = loGlobalSettings.oColEntities
        
        loEntity = loColEntities.GetItem( tcEntityName )

        If Isnull( loEntity )
            loColTables = NewColTables()
            For Each loArchivo In loColTables
                If .T. && !loArchivo.lIsVirtual
                    Try

                        loEntity = Newobject( loArchivo.cBaseClass, loArchivo.cBaseClassLib )
                        loColEntities.AddItem( loEntity, loArchivo.cModelo )

                    Catch To oErr

                    Finally

                    Endtry
                Endif
            Endfor

            loEntity = loColEntities.GetItem( tcEntityName )

        Endif

        If !Isnull( loEntity ) And !lStateFull
        	* RA 09/08/2022(16:41:29)
        	* Por defecto, las entidades NO GUARDAN ESTADO, por lo tano,
        	* se genera una nueva entidad
        	
            loColTables = NewColTables()
            
            loArchivo = loColTables.GetTable( loEntity.cTabla )
            loColEntities.RemoveItem( loArchivo.cModelo )
            loEntity = Null
            loEntity = Newobject( loArchivo.cBaseClass, loArchivo.cBaseClassLib )
            loColEntities.AddItem( loEntity, loArchivo.cModelo )

        Endif

    Catch To oErr
        Local loError As ErrorHandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

        loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
        loError.cRemark = lcCommand
        loError.Process( oErr )
        Throw loError

    Finally
        loArchivo 			= Null
        loColEntities 		= Null
        loGlobalSettings 	= Null

    Endtry

    Return loEntity

Endproc && GetEntity
