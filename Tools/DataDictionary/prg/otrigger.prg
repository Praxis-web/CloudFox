#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'

If .F.
    Do 'Tools\DataDictionary\prg\oBase.prg'
    Do 'ErrorHandler\Prg\ErrorHandler.prg'
    Do 'Tools\DataDictionary\prg\oTable.prg'

Endif

* oTrigger
* Clase trigger.
Define Class oTrigger As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

    #If .F.
        Local This As oTrigger Of 'Tools\DataDictionary\prg\oTrigger.prg'
    #Endif

    #If .F.
        TEXT
		 *:Help Documentation
		 *:Description:
		 Clase Trigger
		 *:Project:
		 Sistemas Praxis
		 *:Autor:
		 Damián Eiff
		 *:Date:
		 Martes 29 de Mayo de 2007 (11:00:34)
		 *:Parameters:
		 *:Remarks:
		 *:Returns:
		 *:Example:
		 *:SeeAlso:
		 *:Events:
		 *:KeyWords:
		 *:Inherits:
		 *:Exceptions:
		 *:NameSpace:
		 digitalizarte.com
		 *:EndHelp
        ENDTEXT
    #Endif

    DataSession = SET_DEFAULT

    * Nombre de la Tabla Padre
    cParentTable = ''

    * Nombre de tabla Hija
    cChildTable = ''

    * Expresion a cumplir
    cChildKeyExpression = ''

    * Nombre de la Primary Key de la tabla hija
    cChildPK = ''
    * Nombre de la Primary Key de la tabla Padre
    cParentPk = ''

    *
    cChildForeignKey = ''

    * Nombre de la etiqueta de indices de la tabla hija
    cChildTagName = ''

    * Nombre de la etiqueta de indices de la tabla padre
    cParentTagName = ''

    * Condición a cumplir para que se dispare el trigger
    cTriggerConditionForInsert = '.T.'

    * Condición a cumplir para que se dispare el trigger
    cTriggerConditionForUpdate = '.T.'

    * Condición a cumplir para que se dispare el trigger
    cTriggerConditionForDelete = '.T.'

    * Clave de acceso a la tabla externa de una FK
    cParentKeyName = ''

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="cparentkeyname" type="property" display="cParentKeyName" />] ;
        + [<memberdata name="cparenttagname" type="property" display="cParentTagName" />] ;
        + [<memberdata name="cchildtagname" type="property" display="cChildTagName" />] ;
        + [<memberdata name="cchildforeignkey" type="property" display="cChildForeignKey" />] ;
        + [<memberdata name="cparenttable" type="property" display="cParentTable" />] ;
        + [<memberdata name="cchildkeyexpression" type="property" display="cChildKeyExpression" />] ;
        + [<memberdata name="cchildtable" type="property" display="cChildTable" />] ;
        + [<memberdata name="cparentpk" type="property" display="cParentPK" />] ;
        + [<memberdata name="cchildpk" type="property" display="cChildPK" />] ;
        + [<memberdata name="ctriggerconditionforinsert" type="property" display="cTriggerConditionForInsert" />] ;
        + [<memberdata name="ctriggerconditionforupdate" type="property" display="cTriggerConditionForUpdate" />] ;
        + [<memberdata name="ctriggerconditionfordelete" type="property" display="cTriggerConditionForDelete" />] ;
        + [</VFPData>]

    * ParentTagName_Access
    Protected Function cParentTagName_Access()

        Local loData As oDataBase Of 'Tools\DataDictionary\prg\oDataBase.prg', ;
            loErr As Exception, ;
            loError As ErrorHandler Of 'FW\ErrorHandler\prg\ErrorHandler.prg', ;
            loParentTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg', ;
            loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

        Try

            If Empty ( This.cParentTagName )

                If ! Empty ( This.cReferences )

                    *!*	loColFields = This.oParent
                    *!*	loColTables = loColFields.oParent.oParent
                    *!*	loParentTable = loColTables.GetItem( This.References )

                    loTable = This.oParent
                    loData  = loTable.oParent
                    Assert Vartype ( loData ) = 'O' Message 'loData no es un objeto'

                    *!* loParentTable = loData.oColTables.GetItem( This.References )
                    loParentTable = loData.oColTables.GetItem ( This.cParentKeyName )

                    This.ParentTagName = loParentTable.GetPrimaryTagName()

                    If Upper ( Substr ( This.cParentTagName, 1, 2 ) ) # 'PK'
                        This.cParentTagName = ''

                    Endif && Upper ( Substr ( This.cParentTagName, 1, 2 ) ) # 'PK'

                Endif && ! Empty ( This.cReferences )

            Endif && Empty ( This.cParentTagName )

        Catch To loErr
            DEBUG_CLASS_EXCEPTION
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            m.loError.Process ( m.loErr )
            THROW_EXCEPTION

        Finally
            m.loError = Null

        Endtry

        Return This.cParentTagName

    Endfunc && cParentTagName_Access

    * cParentKeyName_Access
    Protected Function cParentKeyName_Access()

        Local loErr As Exception, ;
            loError As ErrorHandler Of 'FW\ErrorHandler\prg\ErrorHandler.prg'

        Try

            If Empty ( This.cParentKeyName )
                This.cParentKeyName = Strtran ( Lower ( This.cReferences ), 'sys_', '' )

            Endif && Empty ( This.cParentKeyName )

        Catch To loErr
            DEBUG_CLASS_EXCEPTION
            loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
            m.loError.Process ( m.loErr )
            THROW_EXCEPTION

        Finally
            m.loError = Null

        Endtry

        Return This.cParentKeyName

    Endfunc && cParentKeyName_Access

Enddefine && oTrigger