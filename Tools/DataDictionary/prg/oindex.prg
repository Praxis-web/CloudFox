#include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'
#Include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'ErrorHandler\prg\ErrorHandler.prg'
    Do 'Tools\DataDictionary\prg\oBase.prg'
    Do 'Tools\DataDictionary\prg\oDataBase.prg'
    Do 'Tools\DataDictionary\prg\oTable.prg'

Endif

* oIndex
* Clase indice.
Define Class oIndex As oBase Of 'Tools\DataDictionary\prg\oBase.prg' 

    #If .F.
        Local This As oIndex Of 'Tools\DataDictionary\prg\oIndex.prg'
    #Endif

    #If .F.
        TEXT
		 *:Help Documentation
		 *:Description:
		 Clase Indice
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

    * Indica el tipo de Indice. (Definido en ta.h)
    nKeyType = IK_NOKEY

    * Expresion para generar el indice
    cKeyExpression = ''

    * Condicion de filtro
    cForExpression = ''

    * Nombre de la etiqueta de indice
    cTagName = ''

    *
    cCollate = 'SPANISH'

    * Referencia a la tabla padre
    cReferences = ''

    * Etiqueta de indices correspondiente a la tabla padre
    cParentTagName = ''

    * Condición a cumplir para que se dispare el trigger
    cTriggerConditionForInsert = '.T.'

    * Condición a cumplir para que se dispare el trigger
    cTriggerConditionForUpdate = '.T.'

    * Condición a cumplir para que se dispare el trigger
    cTriggerConditionForDelete = '.T.'

    * Nombre de la clave de la tabla padre
    cParentPk = ''

    * Clave de acceso a la tabla externa de una FK
    cParentKeyName = ''

    * Comando a ejecutar para crear el índice
    cCommand = ''

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="ccommand" type="property" display="cCommand" />] ;
        + [<memberdata name="cparentkeyname" type="property" display="cParentKeyName" />] ;
        + [<memberdata name="cparenttagname" type="property" display="cParentTagName" />] ;
        + [<memberdata name="creferences" type="property" display="cReferences" />] ;
        + [<memberdata name="ccollate" type="property" display="cCollate" />] ;
        + [<memberdata name="ctagname" type="property" display="cTagName" />] ;
        + [<memberdata name="cforexpression" type="property" display="cForExpression" />] ;
        + [<memberdata name="ckeyexpression" type="property" display="cKeyExpression" />] ;
        + [<memberdata name="nkeytype" type="property" display="nKeyType" />] ;
        + [<memberdata name="ctriggerconditionforinsert" type="property" display="cTriggerConditionForInsert" />] ;
        + [<memberdata name="ctriggerconditionforupdate" type="property" display="cTriggerConditionForUpdate" />] ;
        + [<memberdata name="ctriggerconditionfordelete" type="property" display="cTriggerConditionForDelete" />] ;
        + [<memberdata name="cparentpk" type="property" display="cParentPk" />] ;
        + [</VFPData>]

    *
    * cParentTagName_Access
    Protected Function cParentTagName_Access() As String

        Local loData As oDataBase Of 'Tools\DataDictionary\prg\oDataBase.prg', ;
            loErr As Exception, ;
            loError As ErrorHandler Of 'ErrorHandler\prg\ErrorHandler.prg', ;
            loParentTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg', ;
            loTable As oTable Of 'Tools\DataDictionary\prg\oTable.prg'

        Try

            If Empty ( This.cParentTagName )

                If ! Empty ( This.cReferences )
                
                    loTable = This.oParent
                    loData  = loTable.oParent
                    Assert Vartype ( loData ) = 'O' Message 'loData no es un objeto'

                    *!* loParentTable = loData.oColTables.GetItem( This.cReferences )
                    loParentTable = loData.oColTables.GetItem ( This.cParentKeyName )

                    This.cParentTagName = loParentTable.GetPrimaryTagName()

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
            loError = Null

        Endtry


        Return This.cParentTagName

    Endfunc  && cParentTagName_Access

    * cParentKeyName_Access
    Protected Function cParentKeyName_Access() As String

        Local loErr As Exception, ;
            loError As ErrorHandler Of 'FW\ErrorHandler\ErrorHandler.prg'

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
            loError = Null

        Endtry

        Return This.cParentKeyName

    Endfunc && cParentKeyName_Access

Enddefine && oIndex