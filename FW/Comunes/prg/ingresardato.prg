Lparameters uDeafultValue As Variant,;
	cLabelCaption As String,;
	cInputMask As String,;
	cTittle as String,;
	nRow As Integer,;
	nCol As Integer,;
	oParam As Object
	
* RA 2016-01-24(10:01:49)
* uDeafultValue As Variant: Valor que se muestra
*	Default: Space(30)

* cLabelCaption As String: 	Leyenda del Label
*	Default: "Ingresar Dato"

* cInputMask As String: 	Picture del TextBox
*	Default: Replicate("X",30)

* cTittle as String: 		Título principal del Form
*	Default: "Ingrese Dato"
	
* nRow As Integer: 			Fila en que se muestra
*	Default: -1	(Centrado en la Pantalla)

* nCol As Integer: 			Columna en que se muestra
*	Default: -1 (Centrado en la Pantalla)

* oParam As Object: 		Permite personalizar todos los objetos
* 	Tiene que tener la siguiente estructura:
*		oParam.oForm
*		oParam.oLabel
*		oParam.oText

Local lcCommand As String
Local loLabel As Label,;
	loText As TextBox,;
	loForm As Form,;
	loActiveForm As Form,;
	loParam As Object,;
	loReturn as Object 

Local lnTop As Integer,;
	lnLeft As Integer

Try

	lcCommand = ""
	
	loActiveForm = GetActiveForm()

	lnTop 	= loActiveForm.Top  + ( loActiveForm.TextHeight( "X" ) * ( nRow + 1 ))
	lnLeft 	= loActiveForm.Left + ( loActiveForm.TextWidth( "X" )  * nCol )

	If Vartype( nRow ) # "N"
		nRow = -1
	Endif

	If Vartype( nCol ) # "N"
		nCol = -1
	Endif

	If Vartype( cLabelCaption ) # "C"
		cLabelCaption = "Ingresar Dato"
	Endif

	If Empty( uDeafultValue )
		uDeafultValue = Space( 30 )
	Endif

	If Vartype( cInputMask ) # "C"
		cInputMask = Replicate( "X", 30 )
	Endif

	If Vartype( oParam ) # "O"
		oParam = Createobject( "Empty" )
	EndIf
	
	If Empty( cTittle ) 
		cTittle = "Ingrese Dato" 
	EndIf

	loForm 	= Createobject( "Empty" )
	loLabel = Createobject( "Empty" )
	loText 	= Createobject( "Empty" )

	If nRow < 0 Or nCol < 0
		AddProperty( loForm, "AutoCenter", .T. )

	Else
		AddProperty( loForm, "Top", lnTop )
		AddProperty( loForm, "Left", lnLeft )

	EndIf
	
	AddProperty( loForm, "Caption", cTittle )

	AddProperty( loLabel, "Caption", cLabelCaption )
	AddProperty( loLabel, "Width", 0 )

	AddProperty( loText, "Value", uDeafultValue )
	AddProperty( loText, "InputMask", cInputMask )
	AddProperty( loText, "Width", 0 )
	
	If !Pemstatus( oParam, "oForm", 5 )
		AddProperty( oParam, "oForm", loForm )
	Endif

	If !Pemstatus( oParam, "oLabel", 5 )
		AddProperty( oParam, "oLabel", loLabel )
	Endif

	If !Pemstatus( oParam, "oText", 5 )
		AddProperty( oParam, "oText", loText )
	EndIf
	
	loLabel.Width 	= loActiveForm.TextWidth( loLabel.Caption )
	loText.Width 	= loActiveForm.TextWidth( loText.InputMask )  
	
	Do Form "FW\Comunes\scx\Ingresar Dato.scx" With oParam To loReturn
	
	If Vartype( loReturn ) # "O"
		loReturn = CreateObject( "Empty" )
		AddProperty( loReturn, "nStatus", -1 )
	EndIf
	
Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	*Throw loError

Finally


EndTry

Return loReturn

