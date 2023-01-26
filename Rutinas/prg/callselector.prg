#INCLUDE "FW\Comunes\Include\Praxis.h"

*
* Llama al selector para seleccionar un registro
Procedure CallSelector( toColFields As Collection,;
		toColPictures As Collection,;
		toColHeaders As Collection,;
		toParametros As Object ) As Boolean;
		HELPSTRING "Llama al selector para seleccionar un registro"

	Local lnKeyPress As Integer
	Local loParam As Collection
	Local loActiveForm As Form
	Local lnTop As Integer,;
		lnLeft As Integer

	Try

		If Vartype( toParametros ) # "O"
			toParametros = Createobject( "Empty" )
		Endif

		loParam = Createobject( "Collection" )
		lnTop 	= 0
		lnLeft 	= 0

		lnKeyPress = KEY_ESCAPE

		*!*			If Pemstatus( _Screen, "ActiveForm", 5 ) And Type( "_Screen.ActiveForm" ) == "O"
		*!*				loActiveForm = _Screen.ActiveForm
		*!*				lnTop = loActiveForm.Top + ( loActiveForm.TextHeight( "X" ) * ( lnTop + 1 ))
		*!*				lnLeft = loActiveForm.Left + ( loActiveForm.TextWidth( "X" ) * lnLeft )
		*!*			Endif

		loActiveForm = GetActiveForm()
		lnTop = loActiveForm.Top + ( loActiveForm.TextHeight( "X" ) * ( lnTop + 1 ))
		lnLeft = loActiveForm.Left + ( loActiveForm.TextWidth( "X" ) * lnLeft )

		loParam.Add( toColFields, "Fields" )
		loParam.Add( toColPictures, "Pictures" )
		loParam.Add( toColHeaders, "Headers" )


		loParam.Add( lnTop, "nTop" )
		loParam.Add( lnLeft, "nLeft" )
		loParam.Add( toParametros, "oParametros" )

		Do Form "Rutinas\Scx\Selector" With loParam To lnKeyPress

		DoEvents

	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.Process ( m.loErr )
		Throw loError

	Finally

	Endtry

	Return lnKeyPress = 13

Endproc && CallSelector

