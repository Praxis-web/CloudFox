#INCLUDE "FW\TierAdapter\Include\TA.h"

*	Devuelve un objeto con los campos modificados, que puede ser usado
* 	en Gather Name
* *!*	PROCEDURE GetChangedFields( tcCursorName as string,;
*  tlReturnValues As Boolean ) AS Object

Lparameters tcCursorName As String,;
	tlReturnValues As Boolean

Local lcCommand As String

Local lcGetfldstate As String,;
	lcFieldName As String

Local lnRecno As Integer,;
	lnLen As Integer,;
	i As Integer

Local llDone As Boolean

Local Array laFields[ 1 ]
Local oFields As Object
Local oColFields As Collection
Local oField As Object



Try

	lcCommand = ""
	oFields = Createobject( "Empty" )
	oColFields = Createobject( "Collection" )

	If Used( tcCursorName )

		If CursorGetProp( "Buffering", tcCursorName ) = 5
			lcGetfldstate = Getfldstate( -1, tcCursorName )
			If ! Empty( At( Transform( GFS_MODIFIED ), lcGetfldstate ) ) ;
					Or ! Empty( At( Transform( GFS_APPENDED_MODIFIED ), lcGetfldstate ) )

				lnLen = Afields( laFields, tcCursorName )

				For i = 1 To lnLen
					lcFieldName = laFields[ i, 1 ]

					If Inlist( Getfldstate( i, tcCursorName ), GFS_MODIFIED, GFS_APPENDED_MODIFIED )
						AddProperty( oFields, lcFieldName, Evaluate( tcCursorName + "." + lcFieldName ) )

						oField = Createobject( "Empty" )
						AddProperty( oField, "TableName", tcCursorName )
						AddProperty( oField, "FieldName", lcFieldName )
						AddProperty( oField, "OldVal", Oldval( lcFieldName, tcCursorName ) )
						AddProperty( oField, "CurVal", Curval( lcFieldName, tcCursorName ) )

						oColFields.Add( oField )

					Endif

				Endfor

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

If tlReturnValues
	Return oColFields

Else
	Return oFields

Endif





*!*	EndProc && GetChangedFields