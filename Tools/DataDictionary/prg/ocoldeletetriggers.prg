#Include 'Tools\Namespaces\include\foxpro.h'
#Include 'Tools\Namespaces\include\system.h'
#Include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oColTriggers.prg'
    Do 'Tools\DataDictionary\prg\oTrigger.prg'
    Do 'ErrorHandler\prg\ErrorHandler.prg'

Endif

* oColDeleteTriggers
* Colección de triggers de delete.
Define Class oColDeleteTriggers As oColTriggers Of 'Tools\DataDictionary\prg\oColTriggers.prg' 

    #If .F.
        Local This As oColDeleteTriggers Of 'Tools\DataDictionary\prg\oColDeleteTriggers.prg'
    #Endif

    #If .F.
        TEXT
			 *:Help Documentation
			 *:Description:
			 Colección de Indices
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

    Protected _MemberData
    _MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
        + [<VFPData>] ;
        + [<memberdata name="ctriggertype" type="property" display="cTriggerType" />] ;
        + [<memberdata name="new" type="method" display="New" />] ;
        + [</VFPData>]

    cTriggerType = 'Delete'

    * New
    * Devuelve una instancia de oTrigger vacío.
    Function New ( tcName As String ) As oTrigger Of 'Tools\DataDictionary\prg\oTrigger.prg' HelpString 'Devuelve una instancia de oTrigger vacío.'

        Local loErr As Exception, ;
            loError As ErrorHandler Of 'ErrorHandler\prg\ErrorHandler.prg', ;
            loTrigger As oTrigger Of 'Tools\DataDictionary\prg\oTrigger.prg'

        Try

            loTrigger = Createobject ('oDeleteTrigger')
            If ! Empty ( tcName )
                loTrigger.Name = Alltrim ( tcName )
                This.AddTrigger ( loTrigger )

            Endif && ! Empty ( tcName )

        Catch To loErr
            DEBUG_CLASS_EXCEPTION, tcName
            loError = _NewObject ( 'ErrorHandler', 'FW\ErrorHandler\ErrorHandler.prg' )
            m.loError.Process ( m.loErr )
            THROW_EXCEPTION

        Finally

        Endtry

        Return loTrigger

    Endfunc && New

Enddefine && oColDeleteTriggers

Define Class oDeleteTrigger As oTrigger Of 'Tools\DataDictionary\prg\oTrigger.prg'

    #If .F.
        Local This As oDeleteTrigger Of 'Tools\DataDictionary\prg\oColDeleteTriggers.prg'
    #Endif

	Procedure Create( tcTriggerFile As String ) As Void;
			HELPSTRING "Crea un trigger para delete"

		Local lcCommand As String
		Local laTagInfo[1]
		Local i As Integer,;
			lnLen As Integer
		Local lcCmd As String
		
		Try

			lcCommand = ""
			
			* Abrir la tabla padre
			If Used( This.cParentTable )
				Use In Alias( This.cParentTable )
			EndIf
			
			TEXT To lccmd NoShow TextMerge Pretext 15
	            Use '<<Alltrim(This.cParentTable)>>' Exclusive In 0
			ENDTEXT
			This.ReTryCommand( lcCmd, 10, 1705 )

			If Empty( This.cParentPk )
				lnLen = Ataginfo( laTagInfo, This.cParentTable, This.cParentTable )

				For i = 1 To lnLen
					If Lower( laTagInfo[ i, 2 ] ) = Lower( "Primary" ) Or ;
							Lower( laTagInfo[ i, 2 ] ) = Lower( "Principal" )

						This.cParentPk = Proper( laTagInfo[ i, 3 ] )
					Endif
				Endfor
			Endif

			TEXT To lcCommand NoShow TextMerge


*!* ///////////////////////////////////////////////////////
*!* Procedure.....: <<This.Name>>
*!* Description...: Delete Trigger for <<This.cParentTable>>
*!* -------------------------------------------------------
*!*
*!*

Procedure <<This.Name>>

	Local llOk As Boolean
	Local lcAlias As String,;
		lcOldDeleted as String,;
		lcTblAlias as String
		
	Local Array lAFields[ 1 ]
	Local i as Integer
	Local luParentKey as Variant

	Local lcCommand as String

	Try

		lcCommand = ""

		lcOldDeleted = Set("Deleted")

		If <<This.cTriggerConditionForDelete>>

			luParentKey = <<This.cParentPk>>

			lcTblAlias = GetTableAlias( "<<This.cChildTable>>" )
			llOk = ! Indexseek( luParentKey, .F., lcTblAlias, "<<This.ChildTagName>>" )

		Else
			llOk = .T.

		EndIf

		If ! llOk
			If IsRuntime()
				Error "No es posible eliminar el registro" + Chr( 13 ) + ;
					"Proceso Cancelado"

			Else
				Error "No se permite Eliminar en Tabla <<This.cParentTable>> " +;
				"Existe una referencia en la tabla <<This.cChildTable>>"

			EndIf
		EndIf


	Catch To loErr
			llOk = .F.
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		DEBUG_EXCEPTION
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		
			If ! IsRuntime()
				If Used( '<<This.cParentTable>>' )
					loError.cTraceLogin = '<<This.cParentTable>>' + Chr( 13 )
					For i = 1 To AFields( lAFields, '<<This.cParentTable>>' )
						loError.cTraceLogin = loError.cTraceLogin + lAFields[ i, 1 ] + '(' + lAFields[ i, 2 ] + ')'
						Try
							loError.cTraceLogin = loError.cTraceLogin + Transform( Evaluate( '<<This.cParentTable>>.' + lAFields[ i, 1 ] ) )
						Catch To oErr
						EndTry
						loError.cTraceLogin = loError.cTraceLogin + Chr( 13 )

					EndFor
				EndIf
	    	EndIf
			pcXMLError = m.loError.Process ( m.loErr )
		
		THROW_EXCEPTION

	Finally
		Set Deleted &lcOldDeleted

	EndTry

	Return llOk

EndProc && <<This.Name>>

			ENDTEXT

			Strtofile( lcCommand + CR, tcTriggerFile, 1 )

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			DEBUG_EXCEPTION
			loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			m.loError.Process ( m.loErr )
			THROW_EXCEPTION

		Finally
			If Used( This.cChildTable )
				Use In Alias( This.cChildTable )
			Endif


			If Used( This.cParentTable )
				Use In Alias( This.cParentTable )
			Endif

		Endtry


	Endproc
	*!*
	*!* END PROCEDURE Create
	*!*
	*!* ///////////////////////////////////////////////////////

EndDefine && oDeleteTrigger