#INCLUDE "FW\Comunes\Include\Praxis.h"

Local lcCommand As String
Local loForm As Form

Try

	lcCommand = ""
	Close Databases All

	*!*		Create Cursor cCursor ( Acti1 C (1), Acti2 C (1) )
	*!*		Insert Into cCursor ( Acti1, Acti2 ) Values ( "S", "N" )

	*!*		Create Cursor cCursor ( Acti1 L, Acti2 L )
	*!*		Insert Into cCursor ( Acti1, Acti2 ) Values ( .T., .F. )

	Create Cursor cCursor ( Acti1 I, Acti2 I )
	Insert Into cCursor ( Acti1, Acti2 ) Values ( 1, 0 )

	loForm = Createobject( "oForm" )
	loForm.Show()
	Read Events


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError


Finally

	loForm = Null
	Close Databases All

Endtry


Define Class oForm As Form

	AutoCenter = .T.


	Procedure Init
		*!*			This.AddObject( "chk1", "chkSiNoChar" )
		*!*			This.AddObject( "chk2", "chkSiNoChar" )

		This.AddObject( "chk1", "chkSiNoLogical" )
		This.AddObject( "chk2", "chkSiNoLogical" )



		With This.chk1 As Checkbox
			.Caption = "Uno"
			.Top = 10
			.Left = 10
			.Visible = .T.
			.ControlSource = "cCursor.Acti1"

		Endwith

		With This.chk2 As Checkbox
			.Caption = "Dos"
			.Top = 10
			.Left = 200
			.Visible = .T.
			.ControlSource = "cCursor.Acti2"

		Endwith



	Endproc

	Procedure DblClick()
		Select cCursor
	Endproc

	Procedure Unload
		Clear Events
	Endproc


Enddefine

*!* ///////////////////////////////////////////////////////
*!* Class.........: ComboBoxBase
*!* ParentClass...: ComboBox
*!* BaseClass.....: ComboBox
*!* Description...:
*!* Date..........: Lunes 21 de Octubre de 2013 (12:34:57)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class ComboBoxBase As ComboBox

	#If .F.
		Local This As ComboBoxBase Of "Tools\Datadictionary\Prg\Controles.prg"
	#Endif

	BoundColumn 	= 2
	BoundTo 		= .T.
	ColumnCount 	= 1
	RowSourceType 	= 0
	RowSource 		= ""
	Style			= 2
	Sorted 			= .T.
	nWidth 			= 0

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="nwidth" type="property" display="nWidth" />] + ;
		[<memberdata name="nwidth_access" type="method" display="nWidth_Access" />] + ;
		[</VFPData>]

	*
	*
	Procedure Init(  ) As Void
		Local lcCommand As String

		Try

			lcCommand = ""
			* RA 2013-10-21(12:37:52)
			* Se ingresa la descripcion de la columna que se muestra
			*!*				This.AddItem( "Nacional" )

			* Se ingresa el Id en formato character
			*!*				This.List( This.NewIndex, 2 ) = "1"


			*!*				This.AddItem( "Extranjero" )
			*!*				This.List( This.NewIndex, 2 ) = "2"

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Init



	*
	*
	Procedure InteractiveChange(  ) As Void
		Local lcCommand As String,;
			lcAlias As String

		Try

			lcCommand = ""
			If Vartype( This.Parent ) = "O"

				If Lower( This.Parent.BaseClass ) = "column"

					lcAlias = Getwordnum( This.Parent.ControlSource, 1, "." )

					If Upper( Field( "ABM", lcAlias ) ) = "ABM"
						If Evaluate( lcAlias + ".ABM" ) = 0
							* Si hubo un Alta, una Baja o una Recuperación, ya
							* viene marcado el campo
							* Si está vacío, es que solo hubo modificación

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Replace ABM With <<ABM_MODIFICACION>> in <<lcAlias>>
							ENDTEXT

							&lcCommand

						Endif

					Endif
				Endif
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && InteractiveChange

	*
	* nWidth_Access
	Protected Procedure nWidth_Access()

		If Empty( This.nWidth )
			Local loCB As ComboBox
			loCB = Createobject( "ComboBox" )
			This.nWidth = loCB.Width
			loCB = Null
		Endif

		Return This.nWidth

	Endproc && nWidth_Access

Enddefine
*!*
*!* END DEFINE
*!* Class.........: ComboBoxBase
*!*
*!* ///////////////////////////////////////////////////////

Define Class CboProvincia As ComboBoxBase Of "Tools\Datadictionary\Prg\Controles.prg"

	#If .F.
		Local This As CboProvincia Of "Tools\Datadictionary\Prg\Controles.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*
	*
	Procedure Init(  ) As Void
		Local lcCommand As String
		Local I As Integer

		Try

			lcCommand = ""

			For I = 1 To Alen( Zonas )
				This.AddItem( Zonas[ i ] )
				This.List( This.NewIndex, 2 ) = Transform( I )
			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Init

Enddefine && CboProvincia


Define Class CboInscripto As ComboBoxBase Of "Tools\Datadictionary\Prg\Controles.prg"

	#If .F.
		Local This As CboInscripto Of "Tools\Datadictionary\Prg\Controles.prg"
	#Endif

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*
	*
	Procedure Init(  ) As Void
		Local lcCommand As String
		Local I As Integer

		Try

			lcCommand = ""

			For I = 1 To Alen( Ivas )
				This.AddItem( Ivas[ i ] )
				This.List( This.NewIndex, 2 ) = Transform( I )
			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && Init

Enddefine && CboInscripto


*!* ///////////////////////////////////////////////////////
*!* Class.........: CheckBoxBase
*!* ParentClass...: CheckBox
*!* BaseClass.....: CheckBox
*!* Description...:
*!* Date..........: Lunes 21 de Octubre de 2013 (12:31:28)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class CheckBoxBase As Checkbox

	#If .F.
		Local This As CheckBoxBase Of "Tools\Datadictionary\Prg\Controles.prg"
	#Endif


	Value 		= 0
	Caption 	= ""
	Alignment 	= 2
	BackStyle 	= 0
	Centered 	= .T.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


	*
	*
	Procedure InteractiveChange(  ) As Void
		Local lcCommand As String,;
			lcAlias As String

		Try

			lcCommand = ""
			If Vartype( This.Parent ) = "O"

				If Lower( This.Parent.BaseClass ) = "column"

					lcAlias = Getwordnum( This.Parent.ControlSource, 1, "." )

					If Upper( Field( "ABM", lcAlias ) ) = "ABM"
						If Evaluate( lcAlias + ".ABM" ) = 0
							* Si hubo un Alta, una Baja o una Recuperación, ya
							* viene marcado el campo
							* Si está vacío, es que solo hubo modificación

							TEXT To lcCommand NoShow TextMerge Pretext 15
							Replace ABM With <<ABM_MODIFICACION>> in <<lcAlias>>
							ENDTEXT

							&lcCommand

						Endif

					Endif
				Endif
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

	Endproc && InteractiveChange


Enddefine
*!*
*!* END DEFINE
*!* Class.........: CheckBoxBase
*!*
*!* ///////////////////////////////////////////////////////



*!* ///////////////////////////////////////////////////////
*!* Class.........: chkSiNoChar
*!* ParentClass...: CheckBox
*!* BaseClass.....: CheckBox
*!* Description...:
*!* Date..........: Lunes 21 de Octubre de 2013 (12:31:28)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class chkSiNoChar As chkSiNoLogical Of "Tools\Datadictionary\Prg\Controles.prg"

	#If .F.
		Local This As chkSiNoChar Of "Tools\Datadictionary\Prg\Controles.prg"
	#Endif

	*
	cControlSource = ""

	*
	nValue = 0


	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ccontrolsource_assign" type="method" display="cControlSource_Assign" />] + ;
		[<memberdata name="ccontrolsource" type="property" display="cControlSource" />] + ;
		[<memberdata name="ccontrolsource_access" type="method" display="cControlSource_Access" />] + ;
		[<memberdata name="nvalue" type="property" display="nValue" />] + ;
		[<memberdata name="nvalue_access" type="method" display="nValue_Access" />] + ;
		[<memberdata name="nvalue_assign" type="method" display="nValue_Assign" />] + ;
		[</VFPData>]


	*
	* nValue_Access
	Protected Procedure nValue_Access()

		Return This.nValue

	Endproc && nValue_Access


	* nValue_Assign

	Protected Procedure nValue_Assign( uNewValue )

		If Evaluate( This.cControlSource ) = "S"
			This.nValue = 1

		Else
			This.nValue = 0

		Endif

		*!*			This.nValue = uNewValue

	Endproc && nValue_Assign


	*
	* ControlSource_Access
	Protected Procedure ControlSource_Access()

		Return This.ControlSource

	Endproc && ControlSource_Access


	* ControlSource_Assign

	Protected Procedure ControlSource_Assign( uNewValue )

		This.cControlSource = uNewValue
		This.ControlSource = "This.nValue"

	Endproc && ControlSource_Assign




	*
	* cControlSource_Access
	Protected Procedure cControlSource_Access()

		Return This.cControlSource

	Endproc && cControlSource_Access


	* cControlSource_Assign

	Protected Procedure cControlSource_Assign( uNewValue )

		This.cControlSource = uNewValue

	Endproc && cControlSource_Assign


Enddefine
*!*
*!* END DEFINE
*!* Class.........: chkSiNoChar
*!*
*!* ///////////////////////////////////////////////////////

*!* ///////////////////////////////////////////////////////
*!* Class.........: chkSiNoLogical
*!* ParentClass...: CheckBox
*!* BaseClass.....: CheckBox
*!* Description...:
*!* Date..........: Lunes 21 de Octubre de 2013 (12:31:28)
*!* Author........:
*!* Project.......:
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class chkSiNoLogical As Checkbox

	#If .F.
		Local This As chkSiNoLogical Of "Tools\Datadictionary\Prg\Controles.prg"
	#Endif


	Value 		= 0
	Caption 	= ""
	Alignment 	= 2
	BackStyle 	= 0
	Centered 	= .T.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[</VFPData>]


Enddefine
*!*
*!* END DEFINE
*!* Class.........: chkSiNoLogical
*!*
*!* ///////////////////////////////////////////////////////
