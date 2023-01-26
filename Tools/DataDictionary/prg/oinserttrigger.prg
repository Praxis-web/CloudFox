#include 'Tools\Namespaces\include\foxpro.h'
#include 'Tools\Namespaces\include\system.h'
#include 'Tools\DataDictionary\Include\DataDictionary.h'

If .F.
    Do 'Tools\DataDictionary\prg\oTrigger.prg'

Endif

* oInsertTrigger
* Clase trigger.
Define Class oInsertTrigger As oTrigger Of 'Tools\DataDictionary\prg\oTrigger.prg' 

    #If .F.
        Local This As oInsertTrigger Of 'Tools\DataDictionary\prg\oInsertTrigger.prg'
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


	Procedure Create( tcTriggerFile As String ) As Void;
			HELPSTRING "Crea un trigger para Insert"

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
*!* Description...: Insert Trigger for <<This.cParentTable>>
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
	Local luForeignKey as Variant

	Local lcCommand as String

	Try

		lcCommand = ""

		lcOldDeleted = Set("Deleted")

		If <<This.cTriggerConditionForInsert>>

			luForeignKey = <<This.cChildForeignKey>>

			lcTblAlias = GetTableAlias( "<<This.cParentTable>>" )
			llOk = ! Indexseek( luForeignKey, .F., lcTblAlias, "<<This.cParentTagName>>" )

		Else
			llOk = .T.

		EndIf

		If ! llOk
			If IsRuntime()
				Error "No es posible agregar el registro" + Chr( 13 ) + ;
					"Proceso Cancelado"

			Else
				Error "Error al Insertar en Tabla <<This.cChildTable>> " +;
				"No existe la referencia en la tabla <<This.cParentTable>>"

			EndIf
		EndIf


	Catch To loErr
		llOk = .F.
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		DEBUG_EXCEPTION
		loError = _NewObject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		
		If ! IsRuntime()
			If Used( '<<This.cChildTable>>' )
				loError.cTraceLogin = '<<This.cChildTable>>' + Chr( 13 )
				For i = 1 To AFields( lAFields, '<<This.cChildTable>>' )
					loError.cTraceLogin = loError.cTraceLogin + lAFields[ i, 1 ] + '(' + lAFields[ i, 2 ] + ')'
					Try
						loError.cTraceLogin = loError.cTraceLogin + Transform( Evaluate( '<<This.cChildTable>>.' + lAFields[ i, 1 ] ) )
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


Enddefine && oInsertTrigger