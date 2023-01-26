#INCLUDE "FW\TierAdapter\Include\TA.h"


*
* Indica si el cursor ha sido modificado
*!*	PROCEDURE DataHasChanges( cCursorName as string ) AS Boolean;
*!*	        HELPSTRING "Indica si el cursor ha sido modificado"

* cCursorName = Nombre de la tabla que se va a procesar
* lCheckAllTable = Indica si procesa toda la tabla o solamente el registro activo
* cExcludedFieldList = Lista de Campos que no deben considerarse para evaluar si hubo modificaciones
*	( El campo _RecordOrder no se considera nunca, por lo que no es necesario pasarlo )
Lparameters cCursorName,;
	lCheckAllTable As Boolean,;
	cExcludedFieldList As String

Local lcCommand As String

Local llDataHasChanges As Boolean
Local lcGetfldstate As String
Local lnRecno As Integer
Local llDone As Boolean,;
	lNoFire As Boolean

Try

	lcCommand = ""
	llDataHasChanges = .F.
	lNoFire = .T.

	If Empty( cExcludedFieldList )
		cExcludedFieldList = ""
	Endif

	If Used( cCursorName )

		If CursorGetProp( "Buffering", cCursorName ) = 5 

			If !Empty( Field( "_RecordOrder", cCursorName ) )
				cExcludedFieldList = cExcludedFieldList + ",_RecordOrder"
			Endif

			If lCheckAllTable
				Select Alias( cCursorName )
				lnRecno = Recno()
				Locate

				If Getnextmodified( 0, cCursorName, lNoFire ) # 0

					If !Empty( cExcludedFieldList )

						* Ver si es un registro que se acaba de agregar
						* o uno ya existente
						lcGetfldstate = Getfldstate( -1, cCursorName )

						* Setear los campos que no se evaluan como NO MODIFICADOS
						If ! Empty( At( Transform( GFS_APPENDED_MODIFIED ), lcGetfldstate ) )
							SetRecordState( GFS_APPENDED_NOT_MODIFIED, cCursorName, cExcludedFieldList )

						Else
							SetRecordState( GFS_NOT_MODIFIED, cCursorName, cExcludedFieldList )

						Endif

					Endif

					lcGetfldstate = Getfldstate( -1, cCursorName )
					If ! Empty( At( Transform( GFS_MODIFIED ), lcGetfldstate ) ) ;
							Or ! Empty( At( Transform( GFS_APPENDED_MODIFIED ), lcGetfldstate ) )
						llDataHasChanges = .T.
					Endif
				Endif

				If !Empty( lnRecno )
					Try
						Goto lnRecno

					Catch To oErr

					Finally

					Endtry

				Endif

			Else

				If !Empty( cExcludedFieldList )

					* Ver si es un registro que se acaba de agregar
					* o uno ya existente
					lcGetfldstate = Getfldstate( -1, cCursorName )

					* Setear los campos que no se evaluan como NO MODIFICADOS
					If ! Empty( At( Transform( GFS_APPENDED_MODIFIED ), lcGetfldstate ) )
						SetRecordState( GFS_APPENDED_NOT_MODIFIED, cCursorName, cExcludedFieldList )

					Else
						SetRecordState( GFS_NOT_MODIFIED, cCursorName, cExcludedFieldList )

					Endif

				Endif

				* Evaluar los campos que corresponde
				lcGetfldstate = Getfldstate( -1, cCursorName )
				If ! Empty( At( Transform( GFS_MODIFIED ), lcGetfldstate ) ) ;
						Or ! Empty( At( Transform( GFS_APPENDED_MODIFIED ), lcGetfldstate ) )
					llDataHasChanges = .T.
				Endif

			Endif

		Endif

	Endif

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.cRemark = lcCommand
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return llDataHasChanges

*!*	EndProc && DataHasChanges

External Procedure setRecordState.prg