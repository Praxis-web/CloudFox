*!*	#Include 'Tools\namespaces\Include\FoxPro.h'
*!*	#Include 'Tools\namespaces\Include\System.h'
#INCLUDE "FW\Comunes\Include\Praxis.h"


If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
	Do 'Tools\namespaces\prg\LogicalNamespace.prg'
Endif

* ControlNameSpace
Define Class ControlNameSpace As ObjectNamespace Of Tools\namespaces\prg\ObjectNamespace.prg

	#If .F.
		Local This As ControlNameSpace Of 'Tools\namespaces\prg\ControlNameSpace.prg'
	#Endif

	nAverageCharacterWidth  = 0
	nTxtwidth 				= 0
	nTxtHeight 				= 0

	Protected oCache
	oCache = Null

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="convert2any" type="method" display="Convert2Any" />] ;
		+ [<memberdata name="convertinputmask" type="method" display="ConvertInputMask" />] ;
		+ [<memberdata name="fontstyle" type="method" display="FontStyle" />] ;
		+ [<memberdata name="getchoice" type="method" display="GetChoice" />] ;
		+ [<memberdata name="textproperties" type="method" display="TextProperties" />] ;
		+ [<memberdata name="viewproperties" type="method" display="ViewProperties" />] ;
		+ [<memberdata name="viewproperty" type="method" display="ViewProperty" />] ;
		+ [<memberdata name="xmenu" type="method" display="XMenu" />] ;
		+ [<memberdata name="ntxtheight" type="property" display="nTxtHeight" />] ;
		+ [<memberdata name="ntxtwidth" type="property" display="nTxtwidth" />] ;
		+ [<memberdata name="naveragecharacterwidth" type="property" display="nAverageCharacterWidth " />] ;
		+ [</VFPData>]

	* Init
	Procedure Init
		DoDefault()
		This.oCache = Createobject( 'Collection' )

	Endproc && Init

	* Destroy
	Procedure Destroy
		This.oCache = Null
		DoDefault()

	Endproc && Destroy

	Dimension Convert2Any_COMATTRIB[ 5 ]
	Convert2Any_COMATTRIB[ 1 ] = 0
	Convert2Any_COMATTRIB[ 2 ] = 'Devuelve el valor en una unidad convertido a otra unidad medida.'
	Convert2Any_COMATTRIB[ 3 ] = 'Convert2Any'
	Convert2Any_COMATTRIB[ 4 ] = 'Number'
	* Convert2Any_COMATTRIB[ 5 ] = 0

	* Convert2Any
	* Devuelve el valor en una unidad convertido a otra unidad medida.
	Procedure Convert2Any ( tnValue As Number, tnInput As Integer, tnOutput As Integer ) As Number HelpString 'Devuelve el valor en una unidad convertido a otra unidad medida.'

		Local lnFruPerInch As Number, ;
			lnMilimetersPerInch As Number, ;
			lnPixelsPerInch As Number, ;
			lnPointsPerInch As Number, ;
			lnReturn As Number, ;
			loErr As Exception

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Convierte un valor en una unidad de medida a otra
				 *:Project:
				 OOReport Builder
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Viernes 21 de Septiembre de 2007 (10:39:11)
				 *:ModiSummary:
				 R/0001 -
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

		Try
			m.lnFruPerInch = FRX_FRU_PER_INCH
			m.lnPointsPerInch = FRX_POINTS_PER_INCH
			m.lnPixelsPerInch = FRX_PIXELS_PER_INCH
			m.lnMilimetersPerInch = FRX_MILIMETERS_PER_INCH

			Do Case
				Case m.tnInput == FRX_FRU
					Do Case
						Case m.tnOutput == FRX_FRU
							m.lnReturn = m.tnValue

						Case m.tnOutput == FRX_INCHES
							m.lnReturn = m.tnValue / m.lnFruPerInch

						Case m.tnOutput == FRX_MILIMETERS
							m.lnReturn = m.tnValue / m.lnFruPerInch * m.lnMilimetersPerInch

						Case m.tnOutput == FRX_PIXELS
							m.lnReturn = m.tnValue / m.lnFruPerInch * m.lnPixelsPerInch

						Otherwise
							Error 'Output value not suported.'

					Endcase

				Case m.tnInput == FRX_INCHES
					Do Case
						Case m.tnOutput == FRX_FRU
							m.lnReturn = m.tnValue * m.lnFruPerInch

						Case m.tnOutput == FRX_INCHES
							m.lnReturn = m.tnValue

						Case m.tnOutput == FRX_MILIMETERS
							m.lnReturn = m.tnValue * m.lnMilimetersPerInch

						Case m.tnOutput == FRX_PIXELS
							m.lnReturn = m.tnValue * m.lnPixelsPerInch

						Otherwise
							Error 'Output value not suported.'

					Endcase

				Case m.tnInput == FRX_MILIMETERS
					Do Case
						Case m.tnOutput == FRX_FRU
							m.lnReturn = m.tnValue * m.lnFruPerInch / m.lnMilimetersPerInch

						Case m.tnOutput == FRX_INCHES
							m.lnReturn = m.tnValue / m.lnMilimetersPerInch

						Case m.tnOutput == FRX_MILIMETERS
							m.lnReturn = m.tnValue

						Case m.tnOutput == FRX_PIXELS
							m.lnReturn = m.tnValue * m.lnPixelsPerInch / m.lnMilimetersPerInch

						Otherwise
							Error 'Output value not suported.'

					Endcase

				Case m.tnInput == FRX_PIXELS
					Do Case
						Case m.tnOutput == FRX_FRU
							m.lnReturn = m.tnValue * m.lnFruPerInch / m.lnPixelsPerInch

						Case m.tnOutput == FRX_INCHES
							m.lnReturn = m.tnValue / m.lnPixelsPerInch

						Case m.tnOutput == FRX_MILIMETERS
							m.lnReturn = m.tnValue * m.lnMilimetersPerInch / m.lnPixelsPerInch

						Case m.tnOutput == FRX_PIXELS
							m.lnReturn = m.tnValue

						Otherwise
							Error 'Output value not suported.'

					Endcase

				Otherwise
					Error 'Input value not suported.'

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnValue, tnInput, tnOutput
			THROW_EXCEPTION

		Endtry

		Return Round ( m.lnReturn, 3 )

	Endproc && Convert2Any

	Dimension ConvertInputMask_COMATTRIB[ 5 ]
	ConvertInputMask_COMATTRIB[ 1 ] = 0
	ConvertInputMask_COMATTRIB[ 2 ] = 'Devuelve un string que permite configurar la propiedad InputMask'
	ConvertInputMask_COMATTRIB[ 3 ] = 'ConvertInputMask'
	ConvertInputMask_COMATTRIB[ 4 ] = 'String'
	* ConvertInputMask_COMATTRIB[ 5 ] = 4

	*
	* ConvertInputMask
	* Devuelve un string que permite configurar la propiedad InputMask
	Function ConvertInputMask ( tnFieldWidth As Integer, tnFieldPrecision As Integer, tcMaskChar As Character, tlShowSeparator As Boolean ) As String HelpString 'Devuelve un string que permite configurar la propiedad InputMask'

		Local lcReturnMask As String, ;
			liIdx As Integer, ;
			loErr As Exception

		Try

			lcKey = Transform( tnFieldWidth ) + Transform( tnFieldPrecision ) + Transform( tcMaskChar ) + Transform( tlShowSeparator )
			If This.oCache.GetKey ( lcKey ) == 0
				m.lcReturnMask = ''

				If Vartype ( m.tnFieldWidth ) # 'N'
					m.tnFieldWidth = 12

				Endif && Vartype( m.tnFieldWidth ) # 'N'

				If Vartype ( m.tnFieldPrecision ) # 'N'
					m.tnFieldPrecision = 2

				Endif && Vartype( m.tnFieldPrecision ) # 'N'

				If Empty ( m.tcMaskChar ) Or Vartype ( m.tcMaskChar ) # 'C'
					m.tcMaskChar = '#'

				Endif && Empty( m.tcMaskChar ) Or Vartype( m.tcMaskChar ) # 'C'

				m.tcMaskChar = Substr ( m.tcMaskChar, 1, 1 )

				If Vartype ( m.tlShowSeparator ) # 'L'
					m.tlShowSeparator = .F.

				Endif && Vartype( m.tlShowSeparator ) # 'L'

				For m.liIdx = 1 To m.tnFieldWidth
					m.lcReturnMask = m.tcMaskChar + m.lcReturnMask

					If m.liIdx == m.tnFieldPrecision
						m.lcReturnMask = '.' + m.lcReturnMask

					Endif && m.liIdx == m.tnFieldPrecision

					* If m.tlShowSeparator And m.liIdx > m.tnFieldPrecision And m.liIdx < m.tnFieldWidth And Empty ( Mod ( m.liIdx - m.tnFieldPrecision, 3 ) )
					If m.tlShowSeparator And m.liIdx > m.tnFieldPrecision And m.liIdx < m.tnFieldWidth And Mod ( m.liIdx - m.tnFieldPrecision, 3 ) == 0
						m.lcReturnMask = ',' + m.lcReturnMask

					Endif && m.tlShowSeparator And m.liIdx > m.tnFieldPrecision And m.liIdx < m.tnFieldWidth And Mod ( m.liIdx - m.tnFieldPrecision, 3 ) == 0

				Next

				This.oCache.Add( m.lcReturnMask, lcKey )

			Else
				m.lcReturnMask = This.oCache.Item ( lcKey )

			Endif

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnFieldWidth, tnFieldPrecision, tcMaskChar, tlShowSeparator
			THROW_EXCEPTION

		Endtry

		Return m.lcReturnMask

	Endfunc && ConvertInputMask

	Dimension FontStyle_COMATTRIB[ 5 ]
	FontStyle_COMATTRIB[ 1 ] = 0
	FontStyle_COMATTRIB[ 2 ] = 'Devuelve un caracteres que representa el estilo de la fuente o aplica el estilo de fuente al objeto.'
	FontStyle_COMATTRIB[ 3 ] = 'FontStyle'
	FontStyle_COMATTRIB[ 4 ] = 'String'
	* FontStyle_COMATTRIB[ 5 ] = 1

	* FontStyle
	* Devuelve o aplica el estilo de fuente al objeto.
	Function FontStyle ( toRef As Object @, tcFontStyle As String ) As String HelpString 'Devuelve un caracteres que representa el estilo de la fuente o aplica el estilo de fuente al objeto.'

		Local lcFontStyle As String

		Note: Devuelve un caracteres que representa el estilo de la fuente o aplica el estilo de fuente al objeto.

		Try
			If Vartype( m.toRef ) # 'O'
				Error 'ArgumentNullException: toRef'

			Endif && Vartype( m.toRef ) # 'O'

			If Empty ( m.tcFontStyle )
				m.lcFontStyle = Space( 0 )
				If Pemstatus ( m.toRef, 'FontBold', 5 ) And m.toRef.FontBold
					m.lcFontStyle = m.lcFontStyle + FS_BOLD

				Endif && Pemstatus ( m.toRef, 'FontBold', 5 ) And m.toRef.FontBold

				If Pemstatus ( m.toRef, 'FontItalic', 5 ) And m.toRef.FontItalic
					m.lcFontStyle = m.lcFontStyle + FS_ITALIC

				Endif && Pemstatus ( m.toRef, 'FontItalic', 5 ) ANd m.toRef.FontItalic

				If Pemstatus ( m.toRef, 'FontStrikeThru', 5 ) And m.toRef.FontStrikethru
					m.lcFontStyle = m.lcFontStyle + FS_STRIKEOUT

				Endif && Pemstatus ( m.toRef, 'FontStrikeThru', 5 ) and m.toRef.FontStrikethru

				If Pemstatus ( m.toRef, 'FontUnderline', 5 ) And m.toRef.FontUnderline
					m.lcFontStyle = m.lcFontStyle + FS_UNDERLINE

				Endif && Pemstatus ( m.toRef, 'FontUnderline', 5 ) and m.toRef.FontUnderline

				If Empty ( m.lcFontStyle )
					m.lcFontStyle = FS_NORMAL

				Endif && Empty(m.lcFontStyle)

			Else
				m.lcFontStyle = m.tcFontStyle

				If Pemstatus ( m.toRef, 'FontBold', 5 )
					If ! Empty ( At ( FS_BOLD, m.lcFontStyle ) )
						m.toRef.FontBold = .T.

					Else
						m.toRef.FontBold = .F.

					Endif && ! Empty( At( FS_BOLD, m.lcFontStyle ) )

				Endif && PemStatus( m.toRef, 'FontBold', 5 )

				If Pemstatus ( m.toRef, 'FontItalic', 5 )
					If ! Empty ( At ( FS_ITALIC, m.lcFontStyle ) )
						m.toRef.FontItalic = .T.

					Else
						m.toRef.FontItalic = .F.

					Endif && ! Empty( At( FS_ITALIC, m.lcFontStyle ) )

				Endif && PemStatus( m.toRef, 'FontItalic', 5 )

				If Pemstatus ( m.toRef, 'FontStrikeThru', 5 )
					If ! Empty ( At ( FS_STRIKEOUT, m.lcFontStyle ) )
						m.toRef.FontStrikethru = .T.

					Else
						m.toRef.FontStrikethru = .F.

					Endif && ! Empty( At( FS_STRIKEOUT, m.lcFontStyle ) )

				Endif && PemStatus( m.toRef, 'FontStrikeThru', 5 )

				If Pemstatus ( m.toRef, 'FontUnderline', 5 )
					If ! Empty ( At ( FS_UNDERLINE, m.lcFontStyle ) )
						m.toRef.FontUnderline = .T.

					Else
						m.toRef.FontUnderline = .F.

					Endif && ! Empty( At( FS_UNDERLINE, m.lcFontStyle ) )

				Endif && PemStatus( m.toRef, 'FontUnderline', 5 )

			Endif && Empty( m.tcFontStyle )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toRef, tcFontStyle
			THROW_EXCEPTION

		Endtry

		Return m.lcFontStyle

	Endfunc && FontStyle

	Dimension GetChoice_COMATTRIB[ 5 ]
	GetChoice_COMATTRIB[ 1 ] = 0
	GetChoice_COMATTRIB[ 2 ] = 'Devuelve el valor de la opción selecionada del popup dado.'
	GetChoice_COMATTRIB[ 3 ] = 'GetChoice'
	GetChoice_COMATTRIB[ 4 ] = 'String'
	* GetChoice_COMATTRIB[ 5 ] = 4

	* GetChoice
	* Devuelve el valor de la opción selecionada del popup.
	Procedure GetChoice ( tcPopMenu As String, tnSelect As Number @ ) As Number HelpString 'Devuelve el valor de la opción selecionada del popup dado.'
		Local loErr As Exception
		Try

			m.tnSelect = Bar()
			Deactivate Popup ( m.tcPopMenu )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcPopMenu, tnSelect
			THROW_EXCEPTION

		Endtry

	Endproc && GetChoice

	Dimension TextProperties_COMATTRIB[ 5 ]
	TextProperties_COMATTRIB[ 1 ] = 0
	TextProperties_COMATTRIB[ 2 ] = 'Calcula el ancho y alto necesarios para mostrar corectamente el control y los aplica al mismo.'
	TextProperties_COMATTRIB[ 3 ] = 'TextProperties'
	TextProperties_COMATTRIB[ 4 ] = 'String'
	* TextProperties_COMATTRIB[ 5 ] = 4

	* TextProperties
	* Calcula el ancho y alto necesarios para mostrar corectamente el control y los aplica al mismo.
	Function TextProperties ( toObj As Object, tnExtraLen As Integer, tnExtraHeight As Integer ) As Void HelpString 'Calcula el ancho y alto necesarios para mostrar corectamente el control y los aplica al mismo.'

		Local lcFontName As String, ;
			lcFontStyle As String, ;
			lcOldCentury As String, ;
			lcText As String, ;
			lcVartype As String, ;
			llValue As Boolean, ;
			lnExtraHeight As Integer, ;
			lnFontSize As Number, ;
			lnLen As Number, ;
			loErr As Exception, ;
			loSetCentury As Object

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Recibe un objeto y calcula el ancho y el alto necesarios
				 *:Project:
				 Comprobantes v. 1.0
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Miércoles 30 de Noviembre de 2005 ( 19:53:57 )
				 *:ModiSummary:
				  R/0001 -
				 *:Parameters:
				  m.tnExtraLen: Ancho extra ( en cantidad de caracteres )
				 m.tnExtraHeight = Alto extra ( en porcentaje )
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

		Try

			m.loSetCentury = m.Environment.Setcentury ( Set ( 'Century' ) )

			If Vartype ( m.toObj ) # 'O'
				Error 'Se esperaba un Objeto.'

			Endif && Vartype( m.toObj ) # 'O'

			*!* Validar propiedad
			m.llValue = .F.
			m.tnExtraLen = m.Logical.IfEmpty ( m.tnExtraLen, 0 )
			m.tnExtraHeight = m.Logical.IfEmpty ( m.tnExtraHeight, 1 )
			m.lnLen = 0

			Do Case
				Case Pemstatus ( m.toObj, 'Caption', 5 ) && And ! Empty ( m.toObj.Caption )
					m.lcText = m.toObj.Caption

				Case Pemstatus ( m.toObj, 'InputMask', 5 ) And ! Empty ( m.toObj.InputMask )
					m.lcText = m.toObj.InputMask

				Case Pemstatus ( m.toObj, 'nLength', 5 ) And ! Empty ( m.toObj.nLength )
					m.lnLen = m.toObj.nLength
					m.lcText = Replicate ( 'X', m.lnLen )

				Case Pemstatus ( m.toObj, 'Value', 5 )
					m.llValue = .T.
					m.lcVartype = Vartype ( m.toObj.Value )
					Do Case
						Case m.lcVartype == 'C'
							m.lcText = m.toObj.Value

						Case m.lcVartype == 'D'
							Do Case
								Case m.toObj.Century == 0
									Set Century Off

								Case m.toObj.Century == 1
									Set Century On

							Endcase
							m.lcText = Dtoc ( m.toObj.Value )

						Case m.lcVartype == 'T'
							Do Case
								Case m.toObj.Century == 0
									Set Century Off

								Case m.toObj.Century == 1
									Set Century On

							Endcase

							m.lcText = Ttoc ( m.toObj.Value )

						Otherwise
							Assert .F. Message 'La propiedad VALUE no es de un tipo valido'

					Endcase

				Otherwise
					*!* Fuerza un error para que lo atrape el Catch
					Error 'No es posible calcular las dimensiones del control ' + m.toObj.Name

			Endcase

			m.lcFontName = m.toObj.FontName
			m.lnFontSize = m.toObj.FontSize
			m.lcFontStyle = This.FontStyle ( m.toObj )
			m.lnLen = Max ( Txtwidth ( m.lcText, m.lcFontName, m.lnFontSize, m.lcFontStyle ), m.lnLen )
			This.nAverageCharacterWidth = Fontmetric ( TM_AVECHARWIDTH, m.lcFontName, m.lnFontSize, m.lcFontStyle )
			This.nTxtwidth = Ceiling ( This.nAverageCharacterWidth * ( m.lnLen + m.tnExtraLen ) )
			This.nTxtHeight = Ceiling ( Fontmetric ( TM_HEIGHT, m.lcFontName, m.lnFontSize, m.lcFontStyle ) * m.tnExtraHeight )

			m.toObj.Height = This.nTxtHeight
			m.toObj.Width = This.nTxtwidth

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toObj, tnExtraLen, tnExtraHeight
			THROW_EXCEPTION

		Endtry

	Endproc && TextProperties

	Dimension ViewProperties_COMATTRIB[ 5 ]
	ViewProperties_COMATTRIB[ 1 ] = 0
	ViewProperties_COMATTRIB[ 2 ] = 'Devuelve una cadena con los valores de todas las propiedades del objeto dado y todos los objetos que lo compongan.'
	ViewProperties_COMATTRIB[ 3 ] = 'ViewProperties'
	ViewProperties_COMATTRIB[ 4 ] = 'String'
	* ViewProperties_COMATTRIB[ 5 ] = 1

	* ViewProperties
	* Devuelve una cadena con los valores de todas las propiedades del objeto dado y todos los objetos que lo compongan.
	Function ViewProperties ( toParam As Object, tnLevel As Number, tlNativas As Boolean ) As String HelpString 'Devuelve una cadena con los valores de todas las propiedades del objeto dado y todos los objetos que lo compongan.'

		Local lcRet As String, ;
			loControl As Control, ;
			loErr As Exception, ;
			loPage As Page

		Try
			If Empty ( m.tnLevel )
				m.tnLevel = 1

			Endif && Empty( m.tnLevel )
			m.lcRet = ''

			If Vartype ( m.toParam ) == 'O'
				lcBaseClass = Lower ( m.toParam.BaseClass )

				Do Case
					Case m.lcBaseClass == 'form'
						m.lcRet = This.ViewProperty ( m.toParam, m.tnLevel, m.tlNativas )
						For Each m.loControl As Control In m.toParam.Objects FoxObject
							m.lcRet = m.lcRet + This.ViewProperties ( m.loControl, m.tnLevel + 1, m.tlNativas ) + CR

						Next

					Case m.lcBaseClass == 'pageframe'
						m.lcRet = This.ViewProperty ( m.toParam, m.tnLevel, m.tlNativas )
						For Each m.loPage As Page In m.toParam.Pages FoxObject
							m.lcRet = m.lcRet + This.ViewProperties ( m.loControl, m.tnLevel + 1, m.tlNativas ) + CR

						Next

					Case m.lcBaseClass == 'page'
						m.lcRet = This.ViewProperty ( m.toParam, m.tnLevel, m.tlNativas )
						For Each m.loControl As Control In m.toParam.Objects FoxObject
							m.lcRet = m.lcRet + This.ViewProperties ( m.loControl, m.tnLevel + 1, m.tlNativas ) + CR

						Next

					Case m.lcBaseClass == 'container'
						m.lcRet = This.ViewProperty ( m.toParam, m.tnLevel, m.tlNativas )
						For Each m.loControl As Control In m.toParam.Objects FoxObject
							m.lcRet = m.lcRet + This.ViewProperties ( m.loControl, m.tnLevel + 1, m.tlNativas ) + CR

						Next

					Otherwise
						m.lcRet = This.ViewProperty ( m.toParam, m.tnLevel, m.tlNativas )

				Endcase

			Endif && Vartype( m.toParam ) = 'O'

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toParam, tnLevel, tlNativas
			If m.tnLevel # 1
				THROW_EXCEPTION

			Endif && m.tnLevel # 1

		Finally
			loControl = Null
			loPage = Null

		Endtry

		Return m.lcRet

	Endfunc && ViewProperties

	Dimension ViewProperty_COMATTRIB[ 5 ]
	ViewProperty_COMATTRIB[ 1 ] = 0
	ViewProperty_COMATTRIB[ 2 ] = 'Devuelve una cadena con los valores de todas las propiedades del objeto dado.'
	ViewProperty_COMATTRIB[ 3 ] = 'ViewProperty'
	ViewProperty_COMATTRIB[ 4 ] = 'String'
	* ViewProperty_COMATTRIB[ 5 ] = 0

	* ViewProperty
	* Devuelve una cadena con los valores de todas las propiedades del objeto dado.
	Function ViewProperty ( toParam As Object, tnLevel As Number, tlNativas As Boolean ) As String HelpString 'Devuelve una cadena con los valores de todas las propiedades del objeto dado.'
		Local laMembers[1], ;
			lcProp As String, ;
			lcRet As String, ;
			lcVartype As String, ;
			lnCnt As Number, ;
			loErr As Exception, ;
			lvValue As Variant

		If m.tlNativas And Pemstatus ( m.toParam, 'Class', 5 )
			m.lnCnt = Amembers ( laMembers, m.toParam.BaseClass )

		Else && m.tlNativas And Pemstatus ( m.toParam, 'Class', 5 )
			m.lnCnt = Amembers ( laMembers, m.toParam )

		Endif && m.tlNativas And Pemstatus( m.toParam, 'Class', 5 )

		m.lcRet = Space ( m.tnLevel ) + m.toParam.Name + Chr ( 13 )

		For liIdx = 1 To m.lnCnt
			lcProp = m.laMembers[ m.liIdx ]
			Try
				lvValue = Getpem ( m.toParam, m.lcProp )
				lcVartype = Vartype ( m.lvValue )

			Catch To loErr
				DEBUG_CLASS_EXCEPTION, toParam , tnLevel, tlNativas, m.lcProp
				lcVartype = Type ( 'm.toParam.' + m.lcProp )

			Endtry

			lcRet = m.lcRet + Space ( m.tnLevel + 4 ) + Proper ( m.lcProp ) + ': (' + m.lcVartype + ') '
			Try
				Do Case
					Case Inlist ( m.lcVartype, 'C', 'N', 'D', 'T', 'L', 'Y' )
						lcRet = m.lcRet + Transform ( m.lvValue )

					Otherwise

				Endcase
			Catch To loErr
				DEBUG_CLASS_EXCEPTION, toParam , tnLevel, tlNativas
				lcRet = m.lcRet + ' ( ' + m.loErr.Message + ' ) '

			Endtry

			lcRet = m.lcRet + Chr ( 13 )

		Endfor

		Return m.lcRet

	Endfunc && ViewProperty

	Dimension XMenu_COMATTRIB[ 5 ]
	XMenu_COMATTRIB[ 1 ] = 0
	XMenu_COMATTRIB[ 2 ] = 'Muestra un Menu PopUp y devuelve el valor de la opción selecionada.'
	XMenu_COMATTRIB[ 3 ] = 'XMenu'
	XMenu_COMATTRIB[ 4 ] = 'String'
	* XMenu_COMATTRIB[ 5 ] = 4

	* xMenu
	* Muestra un Menu PopUp y devuelve el valor de la opción selecionada.
	Function XMenu ( tcItems As String, tnBar As Number ) As Number HelpString 'Muestra un Menu PopUp y devuelve el valor de la opción selecionada.'

		Local laItems[1], ;
			lcColor As String, ;
			lcPopMenu As String, ;
			lcTitle As String, ;
			liIdx As Integer, ;
			lnAuxCol As Number, ;
			lnAuxRow As Number, ;
			lnAuxSRow As Number, ;
			lnCol As Number, ;
			lnItemCnt As Number, ;
			lnLastpos As Number, ;
			lnRet As Number, ;
			lnRow As Number, ;
			lnSelect As Number, ;
			loErr As Exception

		*-------------------------------------------
		* Function...: Xmenu
		* Author.....: Martin Salias
		* Date.......: 04/06/1997
		* Notes......: Basado en una idea de Steve Zimmelman para FoxPro 2.x
		* Parameters.: tcItems = String con los items separados por punto y coma
		* ...........: tnBar = Número de item seleccionado incialmente ( default = 1 )
		* Returns....: El número de item seleccionado
		* See Also...: PROMPT() [Nativo de FoxPro]
		*

		Push Key Clear

		* Pasan al procedimiento interno GetChoice
		Try
			If Pcount() < 2
				tnBar = 1

			Endif && Pcount()

			* Parsea cad uno de los items
			m.lnItemCnt = Occurs ( ';', m.tcItems ) + 1
			Dimension m.laItems[ m.lnItemCnt ]
			m.lnLastpos = 1

			For liIdx = 1 To m.lnItemCnt

				If m.liIdx < m.lnItemCnt
					laItems[ m.liIdx ] = Substr ( m.tcItems, m.lnLastpos, ( At ( ';', m.tcItems, m.liIdx ) - 1 ) - m.lnLastpos + 1 )

				Else && m.liIdx < m.lnItemCnt
					laItems[ m.liIdx ] = Substr ( m.tcItems, m.lnLastpos, ( Len ( m.tcItems ) - m.lnLastpos ) + 1 )

				Endif && m.i < m.lnItemCnt
				If m.laItems[ m.liIdx ] # '\-'
					laItems[ m.liIdx ] = Alltrim ( m.laItems[ m.liIdx ] )

				Endif && laItems[ m.i ] # '\-'

				lnLastpos = At ( ';', m.tcItems, m.liIdx ) + 1

			Next

			Activate Screen

			* Calcula la posición en base al puntero del mouse
			m.lnAuxCol = Mcol()
			m.lnAuxRow = Mrow()
			m.lnAuxSRow = Srow()
			m.lnRow = Iif ( m.lnAuxRow + m.lnItemCnt < m.lnAuxSRow, m.lnAuxRow - 1, m.lnAuxSRow - m.lnItemCnt )
			m.lnCol = Iif ( m.lnAuxCol + 10 < Scol(), m.lnAuxCol - 3, m.lnAuxCol - 13 )

			* Nombre único para el pop-up
			lcPopMenu = 'popup' + Sys ( 2015 )

			Define Popup ( m.lcPopMenu ) shortcut Relative From m.lnRow, m.lnCol

			For m.liIdx = 1 To m.lnItemCnt
				Define Bar m.liIdx Of ( m.lcPopMenu ) Prompt m.laItems[ m.liIdx ]

			Next

			lnSelect = 0

			Clear Type

			On Selection Popup ( m.lcPopMenu ) m.Control.GetChoice ( m.lcPopMenu, @m.lnSelect )

			Activate Popup ( m.lcPopMenu ) Bar m.tnBar

			Pop Key
			Release Popup ( m.lcPopMenu )

			m.lnRet = Iif ( Lastkey() == 27, 0, m.lnSelect )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcItems, tnBar
			THROW_EXCEPTION

		Endtry

		Return  m.lnRet

	Endfunc && xMenu

Enddefine && ControlNameSpace
