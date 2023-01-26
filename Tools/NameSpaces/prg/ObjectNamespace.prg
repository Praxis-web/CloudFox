#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

#Define KEYASCENDING 2
#Define KEYDESCENDING 3
* #Define DEBUG_CLASS_EXCEPTION Debugout Time(0), Program(), Time( 0 ), Program(), m.loErr.Message, m.loErr.Details, m.loErr.ErrorNo, m.loErr.LineContents, m.loErr.StackLevel, This.Class + '.' + m.loErr.Procedure, This.ClassLibrary, m.loErr.Lineno
#Define SP Space ( 1 )
#Define SP2 SP + SP

External Array loCol

* NamespaceBase
Define Class NamespaceBase As Custom

	#If .F.
		Local This As NamespaceBase Of Tools\namespaces\prg\ObjectNamespace.prg
	#Endif

	Protected Comment
	Protected ControlCount
	Protected Controls
	Protected Height
	Protected HelpContextID
	Protected Left
*!*		Protected Name
	Protected Objects
	Protected Picture
	Protected Tag
	Protected Top
	Protected WhatsThisHelpID
	Protected Width
	* ShowWhatsThis
	Protected Function ShowWhatsThis () As VOID
	Endfunc && ShowWhatsThis

	* Destroy
	Protected Function Destroy() As VOID
		DoDefault()
	Endfunc && Destroy

	*!*		* Error
	*!*		Procedure Error(tnError As Number, tcMethod As String, tnLine As Number) As Void
	*!*			Local loErr As Exception
	*!*			Local lcMsg As String
	*!*			Try
	*!*				TEXT TO m.lcMsg TEXTMERGE NOSHOW PRETEXT 15
	*!*					Name: <<This.Name>> Class: <<This.Class>> ClassLibrary: <<This.ClassLibrary>> Method: <<m.tcMethod>> Error: <<m.tnError>> Line: <<m.tnLine>> Message: <<Message()>>
	*!*				ENDTEXT

	*!*				Comreturnerror( m.lcMsg, _vfp.ServerName )
	*!*				&& this line is never executed

	*!*			Catch To loErr
	*!*				If Version( 2 ) == 2
	*!*					? m.lcMsg + m.loErr.Message

	*!*				Endif

	*!*			Endtry

	*!*		Endproc && Error

Enddefine && NamespaceBase

* NamespaceBase2
Define Class NamespaceBase2 As Session

	#If .F.
		Local This As NamespaceBase2 Of Tools\namespaces\prg\ObjectNamespace.prg
	#Endif

	Protected Comment
	Protected ControlCount
	Protected Controls
	Protected Height
	Protected HelpContextID
	Protected Left
*!*		Protected Name
	Protected Objects
	Protected Picture
	Protected Tag
	Protected Top
	Protected WhatsThisHelpID
	Protected Width

	* ShowWhatsThis
	Protected Function ShowWhatsThis
	Endfunc && ShowWhatsThis

	* Destroy
	Protected Function Destroy
		DoDefault()
	Endfunc && Destroy


	*!*		* Error
	*!*		Procedure Error(tnError As Number, tcMethod As String, tnLine As Number) As Void
	*!*			Local loErr As Exception
	*!*			Local lcMsg As String
	*!*			Try
	*!*				TEXT TO m.lcMsg TEXTMERGE NOSHOW PRETEXT 15
	*!*					Name: <<This.Name>> Class: <<This.Class>> ClassLibrary: <<This.ClassLibrary>> Method: <<m.tcMethod>> Error: <<m.tnError>> Line: <<m.tnLine>> Message: <<Message()>>
	*!*				ENDTEXT

	*!*				Comreturnerror( m.lcMsg, _vfp.ServerName )
	*!*				&& this line is never executed

	*!*			Catch To loErr
	*!*				If Version( 2 ) == 2
	*!*					? m.lcMsg + m.loErr.Message

	*!*				Endif

	*!*			Endtry

	*!*		Endproc && Error

Enddefine && NamespaceBase2

* ObjectBase
Define Class ObjectBase As Custom &&  NamespaceBase Of NameSpaces\prg\ObjectNamespace.prg OlePublic

	#If .F.
		Local This As ObjectBase Of Tools\namespaces\prg\ObjectNamespace.prg
	#Endif

	* Protected Comment
	Protected ControlCount
	Protected Controls
	Protected Height
	Protected HelpContextID
	Protected Left
	*  Protected Name
	Protected Objects
	Protected Picture
	* Protected Tag
	Protected Top
	Protected WhatsThisHelpID
	Protected Width

	* ShowWhatsThis
	Protected Function ShowWhatsThis() As VOID
	Endfunc && ShowWhatsThis

	* Destroy
	Protected Function Destroy() As VOID
		DoDefault()
	Endfunc && Destroy

	*!*		* Error
	*!*		Procedure Error(tnError As Number, tcMethod As String, tnLine As Number) As Void
	*!*			Local loErr As Exception
	*!*			Local lcMsg As String
	*!*			Try
	*!*				TEXT TO m.lcMsg TEXTMERGE NOSHOW PRETEXT 15
	*!*					Name: <<This.Name>> Class: <<This.Class>> ClassLibrary: <<This.ClassLibrary>> Method: <<m.tcMethod>> Error: <<m.tnError>> Line: <<m.tnLine>> Message: <<Message()>>
	*!*				ENDTEXT

	*!*				Comreturnerror( m.lcMsg, _vfp.ServerName )
	*!*				&& this line is never executed

	*!*			Catch To loErr
	*!*				If Version( 2 ) == 2
	*!*					? m.lcMsg + m.loErr.Message

	*!*				Endif

	*!*			Endtry

	*!*		Endproc && Error

	BaseName = 'Object'

	* New
	Function New( tnDataSessionId As Number )  As Object
		Local loNewObject, lnLastDataSessionId

		lnLastDataSessionId=Set("DATASESSION")
		If Type( 'tnDataSessionId') == 'N' And tnDataSessionId >= 1
			Set DataSession To tnDataSessionId

		Endif && TYPE( 'tnDataSessionId') == 'N' AND tnDataSessionId>=1

		* loNewObject = Newobject( This.Class,This.ClassLibrary )
		loNewObject = NewObject( This.Class,This.ClassLibrary )

		Set DataSession To (lnLastDataSessionId)

		Return loNewObject

	Endfunc && New

	Function Help() As VOID

		Local lcURL As String
		lcURL = [http://msdn.microsoft.com/en-us/library/] + Juststem ( This.ClassLibrary ) + '.' + This.BaseName + [.aspx]
		ShellExecute ( 0, 'open', m.lcURL, '', '', 0 )

	Endfunc && Help

	* Equals
	Function Equals ( toObject1 As Object, toObject2 As Object) As Boolean
		Local llReturn As Boolean, ;
			lnPcount As Number
		lnPcount = Pcount ( )
		Do Case
			Case m.lnPcount = 1 And Vartype ( m.toObject1 ) == 'O'
				llReturn = ( This == m.toObject1 )

			Case m.lnPcount = 2
				llReturn = ( m.toObject1 == m.toObject2 )

			Otherwise
				llReturn = .F.

		Endcase

		Return m.llReturn

	Endfunc && Equals

	* GetHashCode
	Function GetHashCode ( toObject As Object ) As String
		#Define MEMBERDELIMITER "|"

		Local laryMembers[1, 1], ;
			lcCombined As String, ;
			lcHashCode As String, ;
			lcMemberName As String, ;
			lcType As String, ;
			lcValueToHash As String, ;
			lnCounter As Number, ;
			lnMax As Number

		If Vartype ( m.toObject ) # 'O'
			toObject = This

		Endif && VARTYPE( m.toObject ) != "O"

		* STORE "" TO m.lcValueToHash, m.lcHashCode
		lcValueToHash = ''
		lcHashCode    = ''
		lnMax         = Amembers ( laryMembers, m.toObject, 1 )

		For lnCounter = 1 To m.lnMax
			lcMemberName = laryMembers[ m.lnCounter, 1 ]
			lcType       = laryMembers[ m.lnCounter, 2 ]
			lcCombined   = m.lcMemberName + MEMBERDELIMITER + m.lcType
			Do Case
				Case m.lcType == 'Property'
					*!* Need a better way to handle these...
					If !Inlist ( Upper ( m.lcMemberName ), 'CONTROLS', 'OBJECTS', 'PARENT', 'BUTTONS', 'PAGES' )
						lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined + MEMBERDELIMITER + Transform ( Getpem ( m.toObject, laryMembers[ m.lnCounter, 1 ] ) )

					Else
						lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined

					Endif
				Case m.lcType == 'Object'
					lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined + MEMBERDELIMITER + This.GetHashCode ( Getpem ( m.toObject, laryMembers ( m.lnCounter, 1 ) ) )

				Otherwise && "Event" or "Method"
					lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined

			Endcase

		Endfor

		lcHashCode = Sys ( 2007, m.lcValueToHash, 0, 1 )

		Return m.lcHashCode

	Endfunc && GetHashCode

	* MemberwiseClone
	Function MemberwiseClone() As Object

		Local laEvents[1], ;
			laMembers[1], ;
			lcMember As String, ;
			lnCounter As Number, ;
			lnTotal As Number, ;
			loClone As Object

		*!* Something needs to be figured out for objects that receive init parameters
		If Vartype ( This.Class ) == 'C' And Vartype ( This.ClassLibrary ) == 'C'
			* loClone = Newobject ( This.Class, This.ClassLibrary )
			loClone = NewObject ( This.Class, This.ClassLibrary )

		Else
			loClone = Createobject ( 'EMPTY' )

		Endif && VARTYPE( This.Class ) = "C" AND VARTYPE( This.CLASSLIBRARY )= "C"

		lnTotal = Amembers ( laMembers, This, 0, 'G#' )
		For lnCounter = 1 To m.lnTotal
			If ! ( 'R' $ m.laMembers[ m.lnCounter, 2 ] )
				lcMember = m.laMembers[ m.lnCounter, 1 ]
				AddProperty ( m.loClone, m.lcMember, Getpem ( This, m.lcMember ) )

			Endif && !( "R" $ m.laMembers[ m.lnCounter, 2 ] )

		Endfor

		lnTotal = Aevents ( laEvents, This )
		For lnCounter = 1 To m.lnTotal
			If laEvents[ m.lnCounter, 1 ] && Is this the event Source?
				Bindevent ( laEvents[ m.lnCounter, 2 ], laEvents[ m.lnCounter, 3 ], m.loClone, laEvents[ m.lnCounter, 4 ], laEvents[ m.lnCounter, 5 ] )

			Else
				Bindevent ( m.loClone, laEvents[ m.lnCounter, 3 ], laEvents[ m.lnCounter, 2 ], laEvents[ m.lnCounter, 4 ], laEvents[ m.lnCounter, 5 ] )

			Endif && laEvents[ m.lnCounter, 1 ]

		Endfor

		Return m.loClone

	Endfunc && MemberwiseClone

	* ReferenceEquals
	Function ReferenceEquals ( toObject1, toObject2 ) As Boolean
		Local llReturn As Boolean, ;
			lnPcount As Number
		lnPcount = Pcount ( )
		Do Case
			Case m.lnPcount = 1 And Vartype ( m.toObject1 ) = 'O'
				llReturn = ( This == m.toObject1 )

			Case m.lnPcount = 2 And Vartype ( m.toObject1 ) = 'O' And Vartype ( m.toObject2 ) = 'O'
				llReturn = ( m.toObject1 == m.toObject2 )

			Otherwise
				llReturn = .F.

		Endcase

		Return m.llReturn

	Endfunc && ReferenceEquals

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [ <VFPData> ] + ;
		[ <memberdata name="new" type="method" display="New"/> ] + ;
		[ <memberdata name="memberwiseclone" type="method" display="MemberwiseClone"/> ] + ;
		[ <memberdata name="gethashcode" type="method" display="GetHashCode"/> ] + ;
		[ <memberdata name="equals" type="method" display="Equals"/> ] + ;
		[ <memberdata name="referenceequals" type="method" display="ReferenceEquals"/> ] + ;
		[ <memberdata name="basename" type="property" display="BaseName"/> ] + ;
		[ </VFPData> ]

Enddefine && ObjectBase

* ObjectBase2
Define Class ObjectBase2 As NamespaceBase2 Of Tools\namespaces\prg\ObjectNamespace.prg

	#If .F.
		Local This As ObjectBase2 Of Tools\namespaces\prg\ObjectNamespace.prg
	#Endif

	BaseName = 'Object'

	* New
	Function New( tnDataSessionId As Number )  As Object
		Local loNewObject, lnLastDataSessionId

		lnLastDataSessionId=Set("DATASESSION")
		If Type( 'tnDataSessionId') == 'N' And tnDataSessionId >= 1
			Set DataSession To tnDataSessionId

		Endif && TYPE( 'tnDataSessionId') == 'N' AND tnDataSessionId>=1

		* loNewObject = Newobject( This.Class,This.ClassLibrary )
		loNewObject = NewObject( This.Class,This.ClassLibrary )

		Set DataSession To (lnLastDataSessionId)

		Return loNewObject

	Endfunc && New

	* Help
	Function Help () As VOID

		Local lcURL As String

		Try

			lcURL = [http://msdn.microsoft.com/en-us/library/] + Juststem ( This.ClassLibrary ) + '.' + This.BaseName + [.aspx]
			ShellExecute ( 0, 'open', m.lcURL, '', '', 0 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

	Endfunc && Help

	* Equals
	Function Equals ( toObject1 As Object, toObject2 As Object) As Boolean

		Local llReturn As Boolean, ;
			lnPcount As Number

		Try

			lnPcount = Pcount ()
			Do Case
				Case m.lnPcount = 1 And Vartype ( m.toObject1 ) = 'O'
					llReturn = ( This == m.toObject1 )

				Case m.lnPcount = 2
					llReturn = ( m.toObject1 == m.toObject2 )

				Otherwise
					llReturn = .F.

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.llReturn

	Endfunc && Equals

	* GetHashCode
	Function GetHashCode ( toObject As Object ) As String
		#Define MEMBERDELIMITER "|"

		Local laryMembers[1, 1], ;
			lcCombined As String, ;
			lcHashCode As String, ;
			lcMemberName As String, ;
			lcType As String, ;
			lcValueToHash As String, ;
			lnCounter As Number, ;
			lnMax As Number

		Try

			If Vartype ( m.toObject ) # 'O'
				toObject = This

			Endif && VARTYPE( m.toObject ) != "O"

			* STORE "" TO m.lcValueToHash, m.lcHashCode
			lcValueToHash = ''
			lcHashCode    = ''
			lnMax         = Amembers ( laryMembers, m.toObject, 1 )

			For lnCounter = 1 To m.lnMax
				lcMemberName = laryMembers[ m.lnCounter, 1 ]
				lcType       = laryMembers[ m.lnCounter, 2 ]
				lcCombined   = m.lcMemberName + MEMBERDELIMITER + m.lcType
				Do Case
					Case m.lcType == 'Property'
						*!* Need a better way to handle these...
						If !Inlist ( Upper ( m.lcMemberName ), 'CONTROLS', 'OBJECTS', 'PARENT', 'BUTTONS', 'PAGES' )
							lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined + MEMBERDELIMITER + Transform ( Getpem ( m.toObject, laryMembers[ m.lnCounter, 1 ] ) )

						Else
							lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined

						Endif
					Case m.lcType == 'Object'
						lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined + MEMBERDELIMITER + This.GetHashCode ( Getpem ( m.toObject, laryMembers ( m.lnCounter, 1 ) ) )

					Otherwise && "Event" or "Method"
						lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined

				Endcase

			Endfor

			lcHashCode = Sys ( 2007, m.lcValueToHash, 0, 1 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.lcHashCode

	Endfunc && GetHashCode

	* MemberwiseClone
	Function MemberwiseClone() As Object

		Local laEvents[1], ;
			laMembers[1], ;
			lcMember As String, ;
			lnCounter As Number, ;
			lnTotal As Number, ;
			loClone As Object

		Try

			*!* Something needs to be figured out for objects that receive init parameters
			If Vartype ( This.Class ) == 'C' And Vartype ( This.ClassLibrary ) == 'C'
				* loClone = Newobject ( This.Class, This.ClassLibrary )
				loClone = NewObject ( This.Class, This.ClassLibrary )

			Else
				loClone = Createobject ( 'EMPTY' )

			Endif && VARTYPE( This.Class ) = "C" AND VARTYPE( This.CLASSLIBRARY )= "C"

			lnTotal = Amembers ( laMembers, This, 0, 'G#' )
			For lnCounter = 1 To m.lnTotal
				If ! ( 'R' $ m.laMembers[ m.lnCounter, 2 ] )
					lcMember = m.laMembers[ m.lnCounter, 1 ]
					AddProperty ( m.loClone, m.lcMember, Getpem ( This, m.lcMember ) )

				Endif && !( "R" $ m.laMembers[ m.lnCounter, 2 ] )

			Endfor

			lnTotal = Aevents ( laEvents, This )
			For lnCounter = 1 To m.lnTotal
				If laEvents[ m.lnCounter, 1 ] && Is this the event Source?
					Bindevent ( laEvents[ m.lnCounter, 2 ], laEvents[ m.lnCounter, 3 ], m.loClone, laEvents[ m.lnCounter, 4 ], laEvents[ m.lnCounter, 5 ] )

				Else
					Bindevent ( m.loClone, laEvents[ m.lnCounter, 3 ], laEvents[ m.lnCounter, 2 ], laEvents[ m.lnCounter, 4 ], laEvents[ m.lnCounter, 5 ] )

				Endif && laEvents[ m.lnCounter, 1 ]

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.loClone

	Endfunc && MemberwiseClone

	* ReferenceEquals
	Function ReferenceEquals ( toObject1, toObject2 ) As Boolean

		Local llReturn As Boolean, ;
			lnPcount As Number

		Try

			lnPcount = Pcount ()
			Do Case
				Case m.lnPcount = 1 And Vartype ( m.toObject1 ) = 'O'
					llReturn = ( This == m.toObject1 )

				Case m.lnPcount = 2 And Vartype ( m.toObject1 ) = 'O' And Vartype ( m.toObject2 ) = 'O'
					llReturn = ( m.toObject1 == m.toObject2 )

				Otherwise
					llReturn = .F.

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.llReturn

	Endfunc && ReferenceEquals

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [ <VFPData> ] + ;
		[ <memberdata name="new" type="method" display="New"/> ] + ;
		[ <memberdata name="memberwiseclone" type="method" display="MemberwiseClone"/> ] + ;
		[ <memberdata name="gethashcode" type="method" display="GetHashCode"/> ] + ;
		[ <memberdata name="equals" type="method" display="Equals"/> ] + ;
		[ <memberdata name="referenceequals" type="method" display="ReferenceEquals"/> ] + ;
		[ <memberdata name="basename" type="property" display="BaseName"/> ] + ;
		[ </VFPData> ]

Enddefine && ObjectBase2

* SessionBase
Define Class SessionBase As ObjectBase2 Of Tools\namespaces\prg\ObjectNamespace.prg

	#If .F.
		Local This As SessionBase Of Tools\namespaces\prg\ObjectNamespace.prg
	#Endif

	#If .F.
		TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Martes 3 de Febrero de 2009 (11:48:53)
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

	DataSession = 1

	* Referencia al objeto Parent
	oParent = Null

	_instanceId = Sys ( 2015 )

	* Valor de la DataSessionId original
	nOldDataSessionId = 0

	* Carpeta de inicio
	cRootFolder = ""

	* XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="oparent" type="property" display="oParent" />]  ;
		+ [<memberdata name="oparent_assign" type="method" display="oParent_Assign" />]  ;
		+ [<memberdata name="getmain" type="method" display="GetMain" />]  ;
		+ [<memberdata name="processclause" type="method" display="ProcessClause" />]  ;
		+ [<memberdata name="members" type="method" display="AMembers" />]  ;
		+ [<memberdata name="pemstatus" type="method" display="PemStatus" />]  ;
		+ [<memberdata name="londestroy" type="property" display="lOnDestroy" />]  ;
		+ [<memberdata name="nolddatasessionid" type="property" display="nOldDataSessionId" />]  ;
		+ [<memberdata name="crootfolder" type="property" display="cRootFolder" />];
		+ [</VFPData>]

	* Init
	Procedure Init() As Boolean

		This.nOldDataSessionId = This.DataSessionId

		Return .T.

	Endproc && Init

	* ClassBeforeInitialize
	Protected Function ClassBeforeInitialize ( tvParam As Variant )
		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Martes 3 de Febrero de 2009 (11:48:53)
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

		Return .T.

	Endfunc && ClassBeforeInitialize

	* HookBeforeInitialize
	Function HookBeforeInitialize ( tvParam As Variant )

		Return .T.

	Endfunc && HookBeforeInitialize

	* HookAfterInitialize
	Procedure HookAfterInitialize ( tvParam As Variant )

	Endproc && HookAfterInitialize

	* ClassAfterInitialize
	Protected Procedure ClassAfterInitialize ( tvParam As Variant )

	Endproc && ClassAfterInitialize

	* Initialize
	Function Initialize ( tvParam As Variant ) As Boolean

		Local loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Martes 3 de Febrero de 2009 (11:48:53)
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

			If This.ClassBeforeInitialize ( m.tvParam )
				If This.HookBeforeInitialize ( m.tvParam )
					This.HookAfterInitialize ( m.tvParam )
					This.ClassAfterInitialize ( m.tvParam )

				Endif && This.HookBeforeInitialize( m.tvParam )

			Endif && This.ClassBeforeInitialize( m.tvParam )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

	Endfunc && Initialize

	* oParent_Assign
	Protected Procedure oParent_Assign ( toParent As Object ) As VOID

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Martes 3 de Febrero de 2009 (11:52:35)
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

		If Vartype ( m.toParent ) # 'O'
			toParent = Null

		Endif && Vartype ( m.toParent ) # 'O'

		This.oParent = m.toParent

	Endproc && oParent_Assign

	* GetMain
	* Devuelve el objeto principal en la jerarquía de clases.
	Procedure GetMain() As Object HelpString 'Devuelve el objeto principal en la jerarquía de clases.'

		Local loErr As Exception, ;
			loMain As Object

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve el objeto principal en la jerarquía de clases
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Martes 3 de Febrero de 2009 (11:57:16)
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

			If Vartype ( This.oParent ) == 'O'
				loMain = This.oParent.GetMain()

			Else && Vartype ( This.oParent ) == 'O'
				loMain = This

			Endif && Vartype ( This.oParent ) == 'O'

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.loMain

	Endproc && GetMain

	* Destroy
	Protected Procedure Destroy() As VOID

		Local loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Martes 3 de Febrero de 2009 (13:22:51)
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

			If ! Empty ( This.nOldDataSessionId )
				This.DataSessionId = This.nOldDataSessionId

			Endif && ! Empty ( This.nOldDataSessionId )

			Unbindevents ( This )

			DoDefault()

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

	Endproc && Destroy

	*
	* cRootFolder_Access
	Protected Procedure cRootFolder_Access() As String

		Local lcProjectPath As String, ;
			loProject As PjHook Of 'Tools\ProjectHook\Vcx\ProjectHookVss.vcx'

		Try

			If Empty ( This.cRootFolder )
				If ! m.Logical.IsRuntime()

					Local lcCurdir As String

					lcCurdir = Set('DEFAULT') + Sys(2003)

					If FileExist( Addbs( lcCurdir ) + "WorkingFolder.Cfg" )
						loXA = Newobject( "xmlAdapterBase", "Tools\Namespaces\Prg\xmlAdapterBase.prg" )

						loXA.LoadXML( Addbs( lcCurdir ) + "WorkingFolder.Cfg", .T. )
						loXA.Tables(1).ToCursor()
						loXA = Null

						This.cRootFolder = Alltrim( WorkingFolder )

						Use In Alias()

					Else
						lcProjectPath = ''
						loProject     = _vfp.ActiveProject
						lcProjectPath = Justpath ( m.loProject.Name )

						This.cRootFolder = Addbs ( m.lcProjectPath )
						loProject        = Null

					Endif

				Endif && ! m.Logical.IsRuntime()

			Endif && Empty ( This.cRootFolder )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Finally
			loXA = Null

		Endtry

		Return This.cRootFolder

	Endproc && cRootFolder_Access


	*
	* cObjectFactoryFileName_Access
	Protected Procedure cObjectFactoryFileName_Access() As String

		If Empty ( This.cObjectFactoryFileName )
			This.cObjectFactoryFileName = Addbs ( This.cRootFolder ) + 'ObjectFactoryCfg.xml'

		Endif && Empty ( This.cObjectFactoryFileName )

		Return This.cObjectFactoryFileName

	Endproc && cObjectFactoryFileName_Access

	* ProcessClause
	Function ProcessClause ( tcClause As String, tvOrigen, tcReplace As String ) As String

		Local lAFields[1], ;
			laMembers[1], ;
			lcField As String, ;
			lcMember As String, ;
			lcRet As String, ;
			lcType As String, ;
			liIdx As Integer, ;
			lnMax As Number, ;
			loErr As Exception, ;
			loItem As Object

		Try
			lcRet  = SP + m.tcClause + SP
			lcType = Vartype ( m.tvOrigen )
			* If Inlist ( m.lcType, 'C', 'O' )
			If m.lcType $ 'CO'

				Do Case
					Case m.lcType == 'C' And Used ( m.tvOrigen )
						If Empty ( tcReplace )
							tcReplace = m.tvOrigen + '.'

						Endif && Empty( m.tcReplace )

						lnMax = Afields ( lAFields, m.tvOrigen )
						Asort ( lAFields, 1, -1, 1, 1 )
						For liIdx = 1 To lnMax
							lcField = Alltrim ( lAFields[ m.liIdx, 1 ] )
							lcRet   = Strtran ( m.lcRet, SP + m.lcField, SP + m.tcReplace + m.lcField, -1, -1, 1 )
							lcRet   = Strtran ( m.lcRet, '(' + m.lcField, '(' + m.tcReplace + m.lcField, -1, -1, 1 )

						Endfor

					Case m.lcType == 'O'
						If Empty ( m.tcReplace )
							tcReplace = 'loItem.'

						Endif && Empty( m.tcReplace )

						lnMax = Amembers ( laMembers, m.tvOrigen )
						Asort ( laMembers, 1, -1, 1, 1 )
						For liIdx = 1 To m.lnMax
							lcMember = Alltrim ( laMembers[ m.liIdx ] )
							lcRet    = Strtran ( m.lcRet, SP + m.lcMember, SP + m.tcReplace + m.lcMember, -1, -1, 1 )
							lcRet    = Strtran ( m.lcRet, '(' + m.lcMember, '(' + m.tcReplace + m.lcMember, -1, -1, 1 )

						Endfor

						If Pemstatus ( m.tvOrigen, 'Class', 5 )
							lnMax = Amembers ( laMembers, m.tvOrigen.Class )
							Asort ( laMembers, 1, -1, 1, 1 )
							For liIdx = 1 To m.lnMax
								lcMember = Alltrim ( laMembers[ m.liIdx ] )
								lcRet    = Strtran ( m.lcRet, SP + m.lcMember, SP + m.tcReplace + m.lcMember, -1, -1, 1 )
								lcRet    = Strtran ( m.lcRet, '(' + m.lcMember, '(' + m.tcReplace + m.lcMember, -1, -1, 1 )

							Endfor

						Endif && Pemstatus( m.tvOrigen, 'Class', 5 )

				Endcase

			Endif && Inlist( m.lcType, 'C', 'O' )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcClause, tvOrigen, tcReplace
			THROW_EXCEPTION

		Finally
			loItem = Null

		Endtry

		Return Alltrim ( m.lcRet )

	Endfunc && ProcessClause

	* Amembers
	Function Amembers ( tvAmembers As Variant @, tnArrayContentsId As Integer ) As Variant

		Local lnMax As Integer, ;
			loErr As Exception

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damian Eiff
				 *:Date:
				 Jueves 30 de Julio de 2009 (00:41:25)
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

			If Empty ( m.tnArrayContentsId )
				tnArrayContentsId = 0

			Endif && Empty( m.tnArrayContentsId )

			lnMax = Amembers ( m.tvAmembers, This, m.tnArrayContentsId )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvAmembers, tnArrayContentsId
			THROW_EXCEPTION

		Endtry

		Return m.lnMax

	Endfunc && AMembers

	* Pemstatus
	Function Pemstatus ( tcProperty As String, tnAttribute As Integer ) As Variant

		Local lvRet As Variant

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damian Eiff
			 *:Date:
			 Jueves 30 de Julio de 2009 (00:47:07)
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

			If ! Empty ( m.tcProperty )
				If Empty ( m.tnAttribute )
					tnAttribute = 5

				Endif && Empty( m.tnAttribute )
				lvRet = Pemstatus ( This, m.tcProperty, m.tnAttribute )

			Endif && ! Empty( m.tcProperty )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcProperty, tnAttribute
			THROW_EXCEPTION

		Endtry

		Return m.lvRet

	Endfunc && PemStatus

	* ToString
	Function ToString ( tcTemplate As String ) As String

		Local lcExpresion As String, ;
			lcString As String, ;
			loErr As Exception

		Try

			lcString = ''

			If Empty ( m.tcTemplate )
				lcString = This.Name

			Else && Empty ( m.tcTemplate )
				lcExpresion = This.ProcessClause ( m.tcTemplate, This, 'This.' )
				lcString    = Evaluate ( m.lcExpresion )

			Endif && Empty( m.tcTemplate )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcTemplate
			THROW_EXCEPTION

		Endtry

		Return m.lcString

	Endfunc && ToString

Enddefine && SessionBase

*!*	*!* ///////////////////////////////////////////////////////
*!*	*!* Class.........: CustomBase
*!*	*!* ParentClass...: Custom
*!*	*!* BaseClass.....: Custom
*!*	*!* Description...:
*!*	*!* Date..........: Lunes 26 de OCtubre de 2009
*!*	*!* Author........: Damian Eiff
*!*	*!* Project.......: Sistemas Praxis
*!*	*!* -------------------------------------------------------
*!*	*!* Modification Summary
*!*	*!* R/0001 -
*!*	*!*
*!*	*!*

*!*	Define Class CustomBase As ObjectBase Of NameSpaces\prg\ObjectNamespace.prg OlePublic

*!*		#If .F.
*!*			Local This As CustomBase Of NameSpaces\prg\ObjectNamespace.prg
*!*		#Endif

*!*		DataSession = 1

*!*		DataSessionId = Set ('Datasession')

*!*		*!* Referencia al objeto Parent
*!*		oParent = Null

*!*		_instanceId = Sys ( 2015 )

*!*		* Flag
*!*		lOnDestroy = .F.

*!*		* Valor de la DataSessionId original
*!*		nOldDataSessionId = 0

*!*		*-- XML Metadata for customizable properties
*!*		Protected _MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="oparent" type="property" display="oParent" />] + ;
*!*			[<memberdata name="oparent_assign" type="method" display="oParent_Assign" />] + ;
*!*			[<memberdata name="getmain" type="method" display="GetMain" />] + ;
*!*			[<memberdata name="processclause" type="method" display="ProcessClause" />] + ;
*!*			[<memberdata name="members" type="method" display="AMembers" />] + ;
*!*			[<memberdata name="pemstatus" type="method" display="PemStatus" />] + ;
*!*			[<memberdata name="londestroy" type="property" display="lOnDestroy" />] + ;
*!*			[<memberdata name="nolddatasessionid" type="property" display="nOldDataSessionId" />] + ;
*!*			[</VFPData>]

*!*		Procedure Init()
*!*			This.nOldDataSessionId = This.DataSessionId

*!*			Return .T.

*!*		Endproc

*!*		* ClassBeforeInitialize
*!*		Protected Function ClassBeforeInitialize ( tvParam As Variant )

*!*			Return .T.

*!*		Endfunc && ClassBeforeInitialize

*!*		* HookBeforeInitialize
*!*		Function HookBeforeInitialize ( tvParam As Variant )

*!*			Return .T.

*!*		Endfunc && HookBeforeInitialize

*!*		* HookAfterInitialize
*!*		Procedure HookAfterInitialize ( tvParam As Variant )

*!*		Endproc && HookAfterInitialize

*!*		* ClassAfterInitialize
*!*		Protected Procedure ClassAfterInitialize ( tvParam As Variant )

*!*		Endproc && ClassAfterInitialize

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Function......: Initialize
*!*		*!* Description...:
*!*		*!* Date..........: Martes 3 de Febrero de 2009 (11:48:53)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Function Initialize ( tvParam As Variant ) As Boolean

*!*			Local loErr As Exception
*!*			Try

*!*				If This.ClassBeforeInitialize ( m.tvParam )
*!*					If This.HookBeforeInitialize ( m.tvParam )
*!*						This.HookAfterInitialize ( m.tvParam )
*!*						This.ClassAfterInitialize ( m.tvParam )

*!*					Endif && This.HookBeforeInitialize( m.tvParam )

*!*				Endif && This.ClassBeforeInitialize( m.tvParam )

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*		Endfunc && Initialize

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: oParent_Assign
*!*		*!* Date..........: Martes 3 de Febrero de 2009 (11:52:35)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure oParent_Assign ( toParent As Object )

*!*			If Vartype ( m.toParent ) # 'O'
*!*				toParent = Null

*!*			Endif

*!*			This.oParent = m.toParent

*!*		Endproc && oParent_Assign


*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: GetMain
*!*		*!* Description...: Devuelve el objeto principal en la jerarquía de clases
*!*		*!* Date..........: Martes 3 de Febrero de 2009 (11:57:16)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure GetMain() As Object HelpString 'Devuelve el objeto principal en la jerarquía de clases'


*!*			Local loErr As Exception, ;
*!*				loMain As Object

*!*			Try

*!*				If Vartype ( This.oParent ) == 'O'
*!*					loMain = This.oParent.GetMain()

*!*				Else
*!*					loMain = This

*!*				Endif

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.loMain

*!*		Endproc && GetMain

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: Destroy
*!*		*!* Description...:
*!*		*!* Date..........: Martes 3 de Febrero de 2009 (13:22:51)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure Destroy() As Void

*!*			Local loErr As Exception
*!*			Try
*!*				If ! This.lOnDestroy
*!*					This.lOnDestroy = .T.
*!*					If !Empty ( This.nOldDataSessionId )
*!*						This.DataSessionId = This.nOldDataSessionId

*!*					Endif

*!*					Unbindevents ( This )

*!*					DoDefault()

*!*				Endif && ! This.lOnDestroy

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*		Endproc && Destroy

*!*		* ProcessClause
*!*		Procedure ProcessClause ( tcClause As String, tvOrigen As Variant, tcReplace As String ) As String

*!*			Return m.String.ProcessClause ( m.tcClause, m.tvOrigen, m.tcReplace )

*!*		Endproc && ProcessClause

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: AMembers
*!*		*!* Description...:
*!*		*!* Date..........: Jueves 30 de Julio de 2009 (00:41:25)
*!*		*!* Author........: Damian Eiff
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure Amembers ( tvAmembers As Variant @, tnArrayContentsId As Integer ) As Variant

*!*			Local lnMax As Integer, ;
*!*				loErr As Exception
*!*			Try
*!*				If Empty ( m.tnArrayContentsId )
*!*					tnArrayContentsId = 0

*!*				Endif && Empty( m.tnArrayContentsId )

*!*				lnMax = Amembers ( tvAmembers, This, m.tnArrayContentsId )

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.lnMax

*!*		Endproc && AMembers

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: PemStatus
*!*		*!* Description...:
*!*		*!* Date..........: Jueves 30 de Julio de 2009 (00:47:07)
*!*		*!* Author........: Damian Eiff
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure Pemstatus ( tcProperty As String, tnAttribute As Integer ) As Variant
*!*			Local lvRet As Variant

*!*			If ! Empty ( m.tcProperty )
*!*				If Empty ( m.tnAttribute )
*!*					tnAttribute = 5

*!*				Endif && Empty( m.tnAttribute )
*!*				lvRet = Pemstatus ( This, m.tcProperty, m.tnAttribute )

*!*			Endif && ! Empty( m.tcProperty )

*!*			Return m.lvRet

*!*		Endproc && PemStatus

*!*		* ToString
*!*		Procedure ToString ( tcTemplate As String ) As String

*!*			Local lcExpresion As String, ;
*!*				lcString As String, ;
*!*				loErr As Exception

*!*			Try

*!*				*!* Assert ( Lower( This.Name ) # '_recordorder' ) Message 'Es _recordorder'

*!*				lcString = ''

*!*				If Empty ( m.tcTemplate )
*!*					lcString = This.Name

*!*				Else
*!*					* m.lcExpresion = This.ProcessClause( m.tcTemplate, This, "This." )
*!*					lcExpresion = m.String.ProcessClause ( m.tcTemplate, This, 'This.' )
*!*					lcString    = Evaluate ( m.lcExpresion )

*!*				Endif && Empty( tcTemplate )

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.lcString

*!*		Endproc && ToString

*!*	Enddefine && CustomBase

*!*	*!* ///////////////////////////////////////////////////////
*!*	*!* Class.........: CollectionBase
*!*	*!* ParentClass...: collection
*!*	*!* BaseClass.....: collection
*!*	*!* Description...:
*!*	*!* Date..........: Domingo 16 de Abril de 2006 (20:55:34)
*!*	*!* Author........: Ricardo Aidelman
*!*	*!* Project.......: Tier Adapter
*!*	*!* -------------------------------------------------------
*!*	*!* Modification Summary
*!*	*!* R/0001  -
*!*	*!*
*!*	*!*

*!*	*!*	Define Class CollectionBase As SessionBase Of "V:\Sistemas Praxis\Fw\Actual\Comunes\Prg\ObjectNamespace.prg"
*!*	Define Class CollectionBase As Collection OlePublic

*!*		#If .F.
*!*			Local This As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg
*!*		#Endif

*!*		*!* Nombre de la clase de los elementos que forman la coleccion
*!*		cClassName = ''

*!*		*!* Nombre de la librería de clases
*!*		cClassLibrary = ''

*!*		*!* Carpeta donde se encuentra la librería de clases
*!*		cClassLibraryFolder = ''

*!*		*!* Referencia al objeto principal
*!*		oMainObject = Null

*!*		*!* Referencia al Parent
*!*		oParent = Null

*!*		* Clase de manejo de errores
*!*		* oError = Null

*!*		* Objeto error en XML
*!*		* cXMLoError = ""

*!*		*	Flag de estado
*!*		* lIsOk = .T.

*!*		DataSession = 0

*!*		DataSessionId = 0

*!*		* cTierLevel = 'USER'

*!*		*-- XML Metadata for customizable properties
*!*		Protected _MemberData
*!*		_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
*!*			[<VFPData>] + ;
*!*			[<memberdata name="cclasslibraryfolder" type="property" display="cClassLibraryFolder" />] + ;
*!*			[<memberdata name="cclasslibrary" type="property" display="cClassLibrary" />] + ;
*!*			[<memberdata name="cclassname" type="property" display="cClassName" />] + ;
*!*			[<memberdata name="lisok" type="property" display="lIsOk" />] + ;
*!*			[<memberdata name="omainobject" type="property" display="oMainObject" />] + ;
*!*			[<memberdata name="omainobject_access" type="method" display="oMainObject_Access" />] + ;
*!*			[<memberdata name="clear" type="method" display="Clear" />] + ;
*!*			[<memberdata name="new" type="method" display="New" />] + ;
*!*			[<memberdata name="getitem" type="method" display="GetItem" />] + ;
*!*			[<memberdata name="removeitem" type="method" display="RemoveItem" />] + ;
*!*			[<memberdata name="indexon" type="method" display="IndexOn" />] + ;
*!*			[<memberdata name="getmin" type="method" display="GetMin" />] + ;
*!*			[<memberdata name="getmain" type="method" display="GetMain" />] + ;
*!*			[<memberdata name="where" type="method" display="Where" />] + ;
*!*			[<memberdata name="distinct" type="method" display="Distinct" />] + ;
*!*			[<memberdata name="copyto" type="method" display="CopyTo" />] + ;
*!*			[<memberdata name="moveto" type="method" display="MoveTo" />] + ;
*!*			[<memberdata name="topquery" type="method" display="TopQuery" />] + ;
*!*			[<memberdata name="sortby" type="method" display="SortBy" />] + ;
*!*			[<memberdata name="select" type="method" display="Select" />] + ;
*!*			[<memberdata name="getmax" type="method" display="GetMax" />] + ;
*!*			[<memberdata name="bottomquery" type="method" display="BottomQuery" />] + ;
*!*			[<memberdata name="recursive" type="method" display="Recursive" />] + ;
*!*			[<memberdata name="tostring" type="method" display="ToString" />] + ;
*!*			[<memberdata name="reverse" type="method" display="Reverse" />] + ;
*!*			[</VFPData>]

*!*		Procedure AddItem ( teItem As Variant, tcKey As String, teBefore As Variant, teAfter As Variant )
*!*			Local lnCnt As Integer, ;
*!*				loErr As Exception

*!*			Try
*!*				lnCnt = Pcount()
*!*				Do Case
*!*					Case lnCnt = 1
*!*						This.Add ( m.teItem )

*!*					Case lnCnt = 2
*!*						This.Add ( m.teItem, Lower ( m.tcKey ) )

*!*					Case lnCnt = 3
*!*						This.Add ( m.teItem, Lower ( m.tcKey ), m.teBefore )

*!*					Case lnCnt = 4
*!*						This.Add ( m.teItem, Lower ( m.tcKey ), m.teBefore, m.teAfter )

*!*					Otherwise
*!*						This.Add ( m.teItem, Lower ( m.tcKey ), m.teBefore, m.teAfter )

*!*				Endcase

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*		Endproc

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: GetMain
*!*		*!* Description...: Devuelve el objeto principal en la jerarquía de clases
*!*		*!* Date..........: Martes 3 de Febrero de 2009 (11:57:16)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure GetMain() As Object HelpString 'Devuelve el objeto principal en la jerarquía de clases'

*!*			Return This.oMainObject.GetMain()

*!*		Endproc && GetMain

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: oMainObject_Access
*!*		*!* Date..........: Viernes 6 de Febrero de 2009 (13:32:47)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure oMainObject_Access()

*!*			If Vartype ( This.oMainObject ) # 'O'
*!*				This.oMainObject = Createobject ( 'SessionBase' )

*!*			Endif

*!*			Return This.oMainObject

*!*		Endproc && oMainObject_Access

*!*		* ValidateKeyOrIndex
*!*		Hidden Function ValidateKeyOrIndex ( tvIndex As Variant, tnIndexOut As Integer @ ) As Boolean
*!*			Local lcKey As String, ;
*!*				llRet As Boolean, ;
*!*				lnIdx As Number

*!*			Do Case
*!*				Case Vartype ( m.tvIndex ) == 'C'
*!*					lnIdx = This.GetKey ( Lower ( m.tvIndex ) )

*!*					If ! Empty ( m.lnIdx )
*!*						tnIndexOut = m.lnIdx
*!*						llRet      = .T.
*!*					Endif && ! Empty( m.i )

*!*				Case Vartype ( m.tvIndex ) == 'N'
*!*					lcKey =  This.GetKey ( m.tvIndex )

*!*					If ! Empty ( m.lcKey )
*!*						tnIndexOut = m.tvIndex
*!*						llRet      = .T.

*!*					Endif && ! Empty( m.lcKey )

*!*				Otherwise
*!*					Error 'Error de tipo de datos'

*!*			Endcase

*!*			Return m.llRet

*!*		Endfunc && ValidateKeyOrIndex

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: GetItem
*!*		*!* Description...: Devuelve un elemento de la colección
*!*		*!* Date..........: Martes 3 de Febrero de 2009 (12:57:58)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Function GetItem ( tvIndex As Variant ) As Object HelpString 'Devuelve un elemento de la colección'

*!*			Local lnIndexOut As Integer, ;
*!*				loErr As Exception, ;
*!*				loItem As Object
*!*			Try

*!*				loItem = Null

*!*				If This.ValidateKeyOrIndex ( m.tvIndex, @lnIndexOut )
*!*					loItem = This.Item ( m.lnIndexOut )

*!*				Endif && This.ValidateKeyOrIndex( m.tvIndex , @lnIndexOut )

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.loItem

*!*		Endfunc && GetItem

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: RemoveItem
*!*		*!* Description...: Elimina un elemento de la colección
*!*		*!* Date..........: Martes 3 de Febrero de 2009 (12:57:58)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Function RemoveItem ( tvIndex As Variant ) As Object HelpString 'Devuelve un elemento de la colección'

*!*			Local lnIndexOut As Integer, ;
*!*				loErr As Exception, ;
*!*				loItem As Object

*!*			Try

*!*				loItem = Null

*!*				If This.ValidateKeyOrIndex ( m.tvIndex, @lnIndexOut )
*!*					loItem = This.Remove ( m.lnIndexOut )

*!*				Endif && This.ValidateKeyOrIndex( m.tvIndex , @lnIndexOut )

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.loItem

*!*		Endfunc && RemoveItem

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: New
*!*		*!* Description...: Crea un elemento y lo agrega a la coleccion
*!*		*!* Date..........: Martes 3 de Febrero de 2009 (12:39:44)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Function New ( tcName As String, tcBefore As String ) As Object HelpString 'Crea un elemento y lo agrega a la coleccion'

*!*			Local lcKey As String, ;
*!*				loErr As Exception, ;
*!*				loItem As Object

*!*			Try

*!*				If Empty ( m.tcName ) Or Vartype ( m.tcName ) # 'C'
*!*					Error 'Error de tipo en el parámetro cName'

*!*				Endif && Empty( m.tcName ) Or Vartype( m.tcName ) # "C"

*!*				tcName = Alltrim ( m.tcName )

*!*				loItem = Newobject ( This.cClassName, Addbs ( This.cClassLibraryFolder ) + This.cClassLibrary )

*!*				loItem.Name    = Proper ( m.tcName )
*!*				loItem.oParent = This

*!*				lcKey = Lower ( m.tcName )

*!*				If Empty ( m.tcBefore )
*!*					This.AddItem ( m.loItem, m.lcKey )

*!*				Else && Empty( m.tcBefore )
*!*					This.AddItem ( m.loItem, m.lcKey, Lower ( m.tcBefore ) )

*!*				Endif && Empty( m.tcBefore )

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.loItem

*!*		Endfunc && New

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: Clear
*!*		*!* Description...: Vacía la colección
*!*		*!* Date..........: Martes 3 de Febrero de 2009 (13:11:14)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure Clear() As Void HelpString 'Vacía la colección'

*!*			This.Remove ( -1 )

*!*		Endproc && Clear

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: Destroy
*!*		*!* Description...:
*!*		*!* Date..........: Martes 3 de Febrero de 2009 (13:22:51)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure Destroy() As Void

*!*			Local loErr As Exception
*!*			Try
*!*				This.Remove ( - 1 )
*!*				This.oMainObject = Null
*!*				This.oParent     = Null
*!*				Unbindevents ( This )
*!*				DoDefault()

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*		Endproc && Destroy

*!*		*
*!*		* IndexOn
*!*		Procedure IndexOn ( tcIndexProperty As String, tlSortDesc As Boolean, tlSkipBackup As Boolean ) As Void ;

*!*			Local lcKey As String, ;
*!*				lcKeyOrder As String, ;
*!*				liIdx As Integer, ;
*!*				llAdd As Boolean, ;
*!*				llOk As Boolean, ;
*!*				lnIndex As Integer, ;
*!*				loBkUpCol As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg, ;
*!*				loColToSort As Collection, ;
*!*				loColWrapper As Collection, ;
*!*				loErr As Exception, ;
*!*				loItem As Object, ;
*!*				loObjWrapper As Object

*!*			Try

*!*				* If Empty( m.tcIndexProperty ) Or Vartype( m.tcIndexProperty ) # 'C'
*!*				If m.String.IsNullOrEmpty ( m.tcIndexProperty )
*!*					Error 'Error en el parametro "tcIndexProperty". Se esperaba un String no vacio'

*!*				Endif && Empty( tcIndexProperty )

*!*				loColToSort = Newobject ( 'Collection' )
*!*				* BackUp
*!*				If ! m.tlSkipBackup
*!*					loBkUpCol = Newobject ( This.Class, This.ClassLibrary )
*!*					This.CopyTo ( m.loBkUpCol )

*!*				Endif

*!*				For liIdx = 1 To This.Count
*!*					loItem       = This.Item[ m.liIdx ]
*!*					lcKey        = This.GetKey ( m.liIdx )
*!*					lcKeyOrder   = Lower ( Transform ( Getpem ( m.loItem, m.tcIndexProperty  ) ) )
*!*					loObjWrapper = CreateObjParam ( 'oItem', m.loItem, 'cKey', m.lcKey, 'nIndex', m.liIdx )

*!*					* Busco la colección Wrapper
*!*					lnIndex = m.loColToSort.GetKey ( m.lcKeyOrder )
*!*					If Empty ( m.lnIndex )
*!*						loColWrapper = Newobject ( 'Collection' )

*!*						* Agrego el elemento a la colección
*!*						m.loColWrapper.Add ( m.loObjWrapper )

*!*						* Agrego la colección wrapper en la colección
*!*						m.loColToSort.Add ( m.loColWrapper, m.lcKeyOrder )

*!*					Else
*!*						loColWrapper = m.loColToSort.Item[ m.lnIndex ]

*!*						* Agrego el elemento a la colección
*!*						m.loColWrapper.Add ( m.loObjWrapper )

*!*					Endif

*!*				Endfor

*!*				loColToSort.KeySort = Iif ( m.tlSortDesc, KEYDESCENDING, KEYASCENDING )
*!*				This.Clear()
*!*				For Each m.loColWrapper In m.loColToSort FoxObject
*!*					For liIdx = 1 To m.loColWrapper.Count
*!*						loObjWrapper = m.loColWrapper.Item[ m.liIdx ]
*!*						This.Add ( m.loObjWrapper.oItem, m.loObjWrapper.cKey )

*!*					Endfor

*!*				Endfor

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				If ! m.tlSkipBackup
*!*					m.loBkUpCol.MoveTo ( This, .T. )

*!*				Endif
*!*				THROW_EXCEPTION

*!*			Finally
*!*				loObjWrapper = Null
*!*				loItem       = Null

*!*				Try
*!*					If ! m.tlSkipBackup
*!*						m.loBkUpCol.Remove ( -1 )

*!*					Endif
*!*				Catch To loErr
*!*					DEBUG_CLASS_EXCEPTION

*!*				Endtry
*!*				Try
*!*					m.loColToSort.Remove ( -1 )
*!*				Catch To loErr
*!*					DEBUG_CLASS_EXCEPTION

*!*				Endtry
*!*				Try
*!*					m.loColWrapper.Remove ( -1 )
*!*				Catch To loErr
*!*					DEBUG_CLASS_EXCEPTION

*!*				Endtry

*!*				loColToSort  = Null
*!*				loColWrapper = Null
*!*				loBkUpCol    = Null

*!*			Endtry

*!*		Endproc && IndexOn

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: GetMax
*!*		*!* Description...: Devuelve el objeto cuyo valor de indice alternativo es el mayor
*!*		*!* Date..........: Lunes 6 de Julio de 2009
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*
*!*		* GetMax
*!*		Protected Procedure GetMax ( tcIndexProperty As String ) As Integer HelpString 'Devuelve el objeto cuyo valor de indice alternativo es el menor'

*!*			Local liIdx As Integer, ;
*!*				lnIndex As Integer, ;
*!*				loErr As Exception, ;
*!*				loObj As Object, ;
*!*				lvMaxValue As Variant, ;
*!*				lvValue As Variant

*!*			Try

*!*				If m.String.IsNullOrEmpty ( m.tcIndexProperty )
*!*					Error 'Error en el parametro "tcIndexProperty". Se esperaba un String no vacio'

*!*				Endif && m.String.IsNullOrEmpty( m.tcIndexProperty )

*!*				lnIndex = 0

*!*				If This.Count > 1
*!*					loObj   = This.Item[ 1 ]
*!*					lnIndex = 1
*!*					If Pemstatus ( m.loObj, m.tcIndexProperty, 5 )
*!*						* m.lvMaxValue = Evaluate( "loObj." + m.tcIndexProperty )
*!*						lvMaxValue = Getpem ( m.loObj, m.tcIndexProperty )

*!*					Endif && Pemstatus( loObj, tcIndexProperty, 5 )

*!*					For liIdx = 1 To This.Count
*!*						loObj = This.Item[ m.liIdx ]

*!*						If Pemstatus ( m.loObj, m.tcIndexProperty, 5 )
*!*							lvValue = Evaluate ( 'loObj.' + m.tcIndexProperty )
*!*							lvValue = Getpem ( m.loObj, m.tcIndexProperty )

*!*							If m.lvValue > m.lvMaxValue
*!*								lvMaxValue = m.lvValue
*!*								lnIndex    = m.liIdx

*!*							Endif && m.lvValue < m.lvMaxValue

*!*						Endif && Pemstatus( m.loObj, m.tcIndexProperty, 5 )

*!*					Endfor

*!*				Endif && This.Count > 1

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Finally
*!*				loObj = Null

*!*			Endtry

*!*			Return m.lnIndex

*!*		Endproc && GetMax

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: GetMin
*!*		*!* Description...: Devuelve el objeto cuyo valor de indice alternativo es el mayor
*!*		*!* Date..........: Lunes 6 de Julio de 2009
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Protected Procedure GetMin ( tcIndexProperty As String ) As Integer HelpString 'Devuelve el objeto cuyo valor de indice alternativo es el menor'

*!*			Local liIdx As Integer, ;
*!*				lnIndex As Integer, ;
*!*				loErr As Exception, ;
*!*				loObj As Object, ;
*!*				lvMinValue As Variant, ;
*!*				lvValue As Variant

*!*			Try

*!*				If m.String.IsNullOrEmpty ( m.tcIndexProperty )
*!*					Error 'Error en el parametro "tcIndexProperty". Se esperaba un String no vacio'

*!*				Endif && m.String.IsNullOrEmpty( m.tcIndexProperty )

*!*				lnIndex = 0

*!*				If This.Count > 1
*!*					loObj   = This.Item [ 1 ]
*!*					lnIndex = 1
*!*					If Pemstatus ( loObj, m.tcIndexProperty, 5 )
*!*						* m.lvMinValue = Evaluate( "loObj." + m.tcIndexProperty )
*!*						lvMinValue = Getpem ( m.loObj, m.tcIndexProperty )

*!*					Endif && Pemstatus( m.loObj, m.tcIndexProperty, 5 )

*!*					For liIdx = 1 To This.Count
*!*						loObj = This.Item [ m.liIdx ]

*!*						If Pemstatus ( m.loObj, m.tcIndexProperty, 5 )
*!*							* m.lvValue = Evaluate( "loObj." + m.tcIndexProperty )
*!*							lvValue = Getpem ( m.loObj, m.tcIndexProperty )

*!*							If m.lvValue < m.lvMinValue
*!*								lvMinValue = m.lvValue
*!*								lnIndex    = m.liIdx

*!*							Endif && m.lvValue < m.lvMinValue

*!*						Endif && Pemstatus( m.loObj, m.tcIndexProperty, 5 )

*!*					Endfor

*!*				Endif && This.Count > 1

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Finally
*!*				loObj = Null

*!*			Endtry

*!*			Return m.lnIndex

*!*		Endproc && GetMin

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: oParent_Assign
*!*		*!* Date..........: Martes 3 de Febrero de 2009 (11:52:35)
*!*		*!* Author........: Ricardo Aidelman
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure oParent_Assign ( toParent As Object )

*!*			If Vartype ( m.toParent ) # 'O'
*!*				toParent = Null

*!*			Endif && Vartype( m.toParent ) # "O"

*!*			This.oParent = m.toParent

*!*		Endproc && oParent_Assign

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: Where
*!*		*!* Description...: Devuelve un sub conjunto de la colección
*!*		*!* Date..........: Lunes 6 de Julio de 2009 (18:54:49)
*!*		*!* Author........: Damian Eiff
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Function Where ( tvColFilters As Variant, tlSetExact As Boolean ) As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg HelpString 'Devuelve un sub conjunto de la colección'

*!*			Local lcClassAnt As String, ;
*!*				lcExpr As String, ;
*!*				lcField As String, ;
*!*				lcKey As String, ;
*!*				lcOperator As String, ;
*!*				lcSetExact As String, ;
*!*				liIdx As Integer, ;
*!*				llIsString As Boolean, ;
*!*				llOk As Boolean, ;
*!*				loErr As Exception, ;
*!*				loFilter As oFilter Of, ;
*!*				loItem As Object, ;
*!*				loRet As Object

*!*			Try
*!*				lcSetExact = Set ( 'Exact' )
*!*				If m.tlSetExact
*!*					Set Exact On

*!*				Else
*!*					Set Exact Off

*!*				Endif && m.tlSetExact

*!*				loRet = Newobject ( This.Class, This.ClassLibrary )

*!*				llIsString = ( Vartype ( m.tvColFilters ) = 'C' )
*!*				If m.llIsString And ( This.Count > 0 )
*!*					loItem = This.Item ( 1 )
*!*					lcKey  = This.GetKey ( 1 )

*!*					lcExpr     = m.String.ProcessClause ( m.tvColFilters, m.loItem, 'loItem.' )
*!*					lcClassAnt = Lower ( m.loItem.Class )

*!*				Endif && llIsString and This.Count > 0

*!*				For liIdx = 1 To This.Count
*!*					loItem = This.Item [ m.liIdx ]
*!*					lcKey  = This.GetKey ( m.liIdx )

*!*					llOk = .T.
*!*					If m.llIsString

*!*						llOk = m.llOk And Evaluate ( m.lcExpr )

*!*					Else
*!*						For Each m.loFilter In m.tvColFilters
*!*							lcExpr = Strtran ( m.loFilter.cFieldExp, '<#FIELD#>', 'loItem.' + m.loFilter.cField ) + m.loFilter.cOperator + m.loFilter.cExpr
*!*							llOk   = m.llOk And Evaluate ( m.lcExpr )

*!*						Endfor

*!*					Endif && m.llIsString

*!*					If m.llOk
*!*						If Empty ( m.lcKey ) And Vartype ( m.loItem ) == 'O' And Pemstatus ( m.loItem, 'Name', 5 )
*!*							lcKey = Lower ( m.loItem.Name )

*!*						Endif && Empty( m.lcKey ) And Vartype( m.loItem ) == 'O' And Pemstatus( m.loItem, 'Name', 5 )

*!*						m.loRet.AddItem ( m.loItem, m.lcKey )

*!*					Endif && m.llOk

*!*				Endfor

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Finally
*!*				loItem = Null

*!*				Set Exact &lcSetExact

*!*			Endtry

*!*			Return m.loRet

*!*		Endproc && Where

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: Distinct
*!*		*!* Description...:
*!*		*!* Date..........: Viernes 17 de Julio de 2009 (16:36:26)
*!*		*!* Author........: Damian Eiff
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure Distinct ( tcProperty As String, tlSkipBackup As Boolean ) As Void

*!*			Local liIdx As Integer, ;
*!*				loBkUpCol As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg, ;
*!*				loCol As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg, ;
*!*				loColDuplicates As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg, ;
*!*				loErr As Exception, ;
*!*				loItem As Object

*!*			Try

*!*				If m.String.IsNullOrEmpty ( m.tcProperty )
*!*					Error 'Error en el parametro "tcProperty ". Se esperaba un String no vacio'

*!*				Endif && Empty( tcProperty )

*!*				loColDuplicates = Newobject ( 'CollectionBase', 'NameSpaces\prg\ObjectNamespace.prg' )
*!*				loCol           = Newobject ( 'CollectionBase', 'NameSpaces\prg\ObjectNamespace.prg' )
*!*				If ! m.tlSkipBackup
*!*					loBkUpCol = Newobject ( This.Class, This.ClassLibrary )
*!*					This.CopyTo ( m.loBkUpCol )

*!*				Endif && m.tlSkipBackup

*!*				For liIdx = 1 To This.Count
*!*					loItem = This.Item [ m.liIdx ]
*!*					Try
*!*						If Vartype ( m.loItem ) = 'O' And Pemstatus ( m.loItem, m.tcProperty, 5 )
*!*							m.loCol.AddItem ( Getpem ( m.loItem, m.tcProperty ), Getpem ( m.loItem, m.tcProperty ) )

*!*						Endif && Vartype( loItem ) = 'O' And Pemstatus( loItem, tcProperty, 5 )

*!*					Catch To loErr
*!*						DEBUG_CLASS_EXCEPTION
*!*						m.loColDuplicates.AddItem ( m.liIdx )

*!*					Endtry

*!*				Endfor

*!*				For liIdx = m.loColDuplicates.Count To 1 Step - 1
*!*					This.Remove ( m.loColDuplicates.Item [ m.liIdx ] )

*!*				Endfor

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				If ! m.tlSkipBackup
*!*					Try
*!*						m.loBkUpCol.MoveTo ( This, .T. )

*!*					Catch To loErr
*!*						DEBUG_CLASS_EXCEPTION

*!*					Endtry
*!*				Endif && ! m.tlSkipBackup
*!*				THROW_EXCEPTION

*!*			Finally
*!*				If ! m.tlSkipBackup
*!*					m.loBkUpCol.Remove ( - 1 )
*!*					loBkUpCol = Null
*!*				Endif && ! m.tlSkipBackup

*!*				m.loColDuplicates.Remove ( - 1 )
*!*				loColDuplicates = Null

*!*				m.loCol.Remove ( - 1 )
*!*				loCol = Null

*!*				loItem = Null

*!*			Endtry

*!*		Endproc && Distinct

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: CopyTo
*!*		*!* Description...: Copia la colección a la colección destino
*!*		*!* Date..........: Domingo 2 de Agosto de 2009 (16:24:30)
*!*		*!* Author........: Damian Eiff
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure CopyTo ( toCol As Object, tlCLearDest As Boolean, tlCLearOrig As Boolean ) As Void HelpString 'Copia la colección a la colección destino'

*!*			Local lcKey As String, ;
*!*				liIdx As Integer, ;
*!*				loErr As Exception, ;
*!*				loObj As Object

*!*			Try

*!*				If m.tlCLearDest
*!*					m.toCol.Remove ( - 1 )

*!*				Endif && m.tlCLear

*!*				For liIdx = 1 To This.Count
*!*					loObj = This.Item [ m.liIdx ]
*!*					lcKey = This.GetKey ( m.liIdx )
*!*					If Empty ( m.lcKey ) And Vartype ( m.loObj ) == 'O' And Pemstatus ( m.loObj, 'Name', 5 )
*!*						lcKey = Lower ( m.loObj.Name )

*!*					Endif && Empty( m.lcKey ) And Vartype( m.loObj ) == 'O' And Pemstatus( m.loObj, 'Name', 5 )

*!*					m.toCol.AddItem ( m.loObj, m.lcKey )

*!*				Endfor

*!*				If m.tlCLearOrig
*!*					This.Remove ( - 1 )

*!*				Endif

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*		Endproc && CopyTo

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: MoveTo
*!*		*!* Description...: Mueve los datos de la colección a la colección destino
*!*		*!* Date..........: Domingo 2 de Agosto de 2009 (16:24:30)
*!*		*!* Author........: Damian Eiff
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Procedure MoveTo ( toCol As Collection, tlCLearDest As Boolean ) As Void HelpString 'Copia la colección a la colección destino'

*!*			Local loErr As Exception
*!*			Try

*!*				This.CopyTo ( m.toCol, m.tlCLearDest, .T. )

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*		Endproc && MoveTo

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: TopQuery
*!*		*!* Description...:
*!*		*!* Date..........: Domingo 2 de Agosto de 2009 (16:58:40)
*!*		*!* Author........: Damian Eiff
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Function TopQuery ( tnTop As Number, tlPercent As Boolean, tlInvert As Boolean ) As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg

*!*			Local lnTop As Number, ;
*!*				loColRet As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg, ;
*!*				loErr As Exception

*!*			Try

*!*				If This.ValidateTop ( m.tnTop, m.tlPercent, @lnTop )

*!*					lnTop = Min ( m.lnTop, This.Count )

*!*					loColRet = This.GetTop ( 1, m.lnTop, 1 )

*!*					If m.tlInvert
*!*						loColRet = m.loColRet.Reverse()

*!*					Endif && m.tlInvert

*!*				Endif

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.loColRet

*!*		Endproc && TopQuery

*!*		* SkipQuery
*!*		Function SkipQuery ( tnTop As Number, tlPercent As Boolean, tlInvert As Boolean ) As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg

*!*			Local lnTop As Number, ;
*!*				loColRet As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg, ;
*!*				loErr As Exception

*!*			Try
*!*				If m.tlPercent
*!*					tnTop = Max ( 100 - m.tnTop, 0 )

*!*				Else
*!*					tnTop = Max ( This.Count - m.tnTop, 0 )

*!*				Endif && m.tlPercent

*!*				If This.ValidateTop ( m.tnTop, m.tlPercent, @lnTop )

*!*					lnTop = Min ( m.lnTop, This.Count )

*!*					loColRet = This.GetTop ( 1, m.lnTop, -1 )

*!*					If m.tlInvert
*!*						loColRet = m.loColRet.Reverse()

*!*					Endif && m.tlInvert

*!*				Endif

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.loColRet

*!*		Endproc && SkipQuery

*!*		Hidden Function GetTop ( tnStart As Integer, tnTop As Integer, tnStep As Integer )
*!*			Local lcKey As String, ;
*!*				liIdx As Integer, ;
*!*				loColRet As Object, ;
*!*				loObj As Object

*!*			loColRet = Newobject ( This.Class, This.ClassLibrary )
*!*			For liIdx = m.tnStart  To m.tnTop Step m.tnStep
*!*				loObj = This.Item [ m.liIdx ]
*!*				lcKey = This.GetKey ( m.liIdx )
*!*				If Empty ( m.M.lcKey ) And Vartype ( m.loObj ) = 'O' And Pemstatus ( m.loObj, 'Name', 5 )
*!*					lcKey = Lower ( m.loObj.Name )

*!*				Endif && Empty( m.lcKey ) And Pemstatus( m.loObj, 'Name', 5 )

*!*				m.loColRet.AddItem ( m.loObj, m.lcKey )

*!*			Endfor

*!*			Return m.loColRet

*!*		Endfunc

*!*		* ValidateTop
*!*		Hidden Function ValidateTop (tnTop As Number, tlPercent As Boolean, tnTopOut As Integer @ ) As Boolean
*!*			Local llRest As Boolean
*!*			llRest = .T.
*!*			Do Case
*!*				Case Vartype ( m.tnTop ) # 'N'
*!*					Error 9 && Data type mismatch

*!*				Case m.tnTop < 1
*!*					* tnTop = This.Count
*!*					Error 'Zero or negative used as argument.'

*!*				Otherwise
*!*					If m.tlPercent And m.tnTop > 100
*!*						Error 'Invalid TOP specification'

*!*					Endif && tlPercent And tnTop > 100

*!*			Endcase

*!*			If m.tlPercent
*!*				tnTopOut = m.tnTop * This.Count / 100

*!*			Else
*!*				tnTopOut = m.tnTop

*!*			Endif && m.tlPercent

*!*			Return m.llRest

*!*		Endfunc

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: Top
*!*		*!* Description...:
*!*		*!* Date..........: Domingo 12 de Agosto de 2009
*!*		*!* Author........: Damian Eiff
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Function BottomQuery ( tnTop As Number, tlPercent As Boolean, tlInvert As Boolean ) As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg

*!*			Local lnTop As Number, ;
*!*				loColRet As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg, ;
*!*				loErr As Exception

*!*			Try
*!*				If This.ValidateTop ( m.tnTop, m.tlPercent, @lnTop )

*!*					lnTop = Max ( Min ( m.lnTop, This.Count ), 1 )

*!*					loColRet = This.GetTop ( m.lnTop, 1, -1 )

*!*					If m.tlInvert
*!*						loColRet = m.loColRet.Reverse()

*!*					Endif && m.tlInvert

*!*				Endif

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.loColRet

*!*		Endproc && BottomQuery

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: SortBy
*!*		*!* Description...:
*!*		*!* Date..........: Domingo 2 de Agosto de 2009 (17:26:38)
*!*		*!* Author........: Damian Eiff
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Function SortBy ( tvSortBy As Variant ) As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg HelpString 'Devuelve una colección ordenada según los parametros'


*!*			Local lcExp As String, ;
*!*				lcExp2 As String, ;
*!*				liIdx As Integer, ;
*!*				llIsString As Boolean, ;
*!*				llSortDesc As Boolean, ;
*!*				lnOccurs As Integer, ;
*!*				loColRet As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg, ;
*!*				loErr As Exception

*!*			Try
*!*				llIsString = ( Vartype ( m.tvSortBy ) = 'C' )
*!*				loColRet   = Newobject ( This.Class, This.ClassLibrary )
*!*				This.CopyTo ( m.loColRet )

*!*				If m.llIsString
*!*					* tvSortBy = Alltrim( tvSortBy )
*!*					lnOccurs = Getwordcount ( m.tvSortBy, ',' )
*!*					For liIdx = m.lnOccurs To 1 Step - 1
*!*						llSortDesc = .F.
*!*						lcExp      = Getwordnum ( m.tvSortBy, m.liIdx, ',' )
*!*						If Getwordcount ( m.lcExp ) > 1
*!*							lcExp2     = Alltrim ( Getwordnum ( m.lcExp, 2) )
*!*							lcExp2     = Left ( Lower ( lcExp2 ), 3 )
*!*							llSortDesc = (  m.lcExp2 == 'des' )

*!*						Endif && Getwordcount( m.lcExp ) > 1

*!*						m.loColRet.IndexOn ( Getwordnum ( m.lcExp, 1 ), m.llSortDesc )

*!*					Endfor

*!*				Else
*!*					Error 'No implementado'

*!*				Endif && llIsString

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.loColRet

*!*		Endproc && SortBy

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: Select
*!*		*!* Description...: Devuelve una colección de objetos nuevos con propiedades
*!*		*!* 				selecionadas de los elementos de la colección
*!*		*!* Date..........: Domingo 2 de Agosto de 2009 (17:46:25)
*!*		*!* Author........: Damian Eiff
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Function Select ( tvSelect As Variant  ) As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg HelpString 'Devuelve una colección de objetos nuevos con propiedades selecionadas de los elementos de la colección'

*!*			Local lcExp As String, ;
*!*				lcExpProp As String, ;
*!*				lcKey As String, ;
*!*				lcProp As String, ;
*!*				lcPropAlias As String, ;
*!*				liIdx As Integer, ;
*!*				liIdx2 As Integer, ;
*!*				llIsString As Boolean, ;
*!*				loColRet As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg, ;
*!*				loErr As Exception, ;
*!*				loNewObj As Object, ;
*!*				loObj As Object

*!*			Try
*!*				loColRet = Newobject ( This.Class, This.ClassLibrary )
*!*				* Assert tvSelect Message 'No se recibio ningún parametro'
*!*				llIsString = ( Vartype ( m.tvSelect ) = 'C' ) Or Pcount() = 0

*!*				If m.llIsString
*!*					If Empty ( m.tvSelect )
*!*						tvSelect = '*'

*!*					Endif
*!*					tvSelect = Alltrim ( m.tvSelect )
*!*					If m.tvSelect = '*'
*!*						This.CopyTo ( m.loColRet )

*!*					Else

*!*						For liIdx = 1 To This.Count
*!*							loObj    = This.Item[ m.liIdx ]
*!*							lcKey    = This.GetKey ( m.liIdx )
*!*							loNewObj = Createobject ( 'Empty' )
*!*							For liIdx2 = 1 To Getwordcount ( m.tvSelect, ',' )
*!*								lcExp     = Getwordnum ( m.tvSelect, m.liIdx2, ',' )
*!*								lcExp     = Strtran ( m.lcExp, SP2, SP )
*!*								lcExp     = Strtran ( m.lcExp, '(' + SP, '(' )
*!*								lcExp     = Strtran ( m.lcExp, SP + ')', ')' )
*!*								lcProp    = Getwordnum ( m.lcExp, 1 )
*!*								lcExpProp = This.oMainObject.ProcessClause ( m.lcProp, @loObj, 'loObj.' )

*!*								If Getwordcount ( m.lcExp ) > 1
*!*									lcPropAlias = Alltrim ( Getwordnum ( m.lcExp, 2 )  )

*!*								Else
*!*									lcPropAlias = Alltrim ( m.lcProp )

*!*								Endif && GetWordCount( m.lcExp ) > 1

*!*								AddProperty ( m.loNewObj, m.lcPropAlias,	&lcExpProp. )

*!*							Endfor
*!*							If Empty ( m.lcKey ) And Vartype ( m.loObj ) = 'O' And Pemstatus ( m.loObj, 'Name', 5 )
*!*								lcKey = Lower ( m.loObj.Name )

*!*							Endif && Empty( m.lcKey ) And Pemstatus( m.loObj, 'Name', 5 )
*!*							m.loColRet.AddItem ( m.loNewObj, m.lcKey )

*!*						Endfor

*!*					Endif && m.tvSelect = '*'

*!*				Else
*!*					Error 'No implementado'

*!*				Endif && m.llIsString

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Finally
*!*				loObj    = Null
*!*				loNewObj = Null

*!*			Endtry

*!*			Return m.loColRet

*!*		Endfunc && Select

*!*		* @TODO Damian Eiff 2009-08-01 (01:30:17) Proc Query

*!*		*
*!*		* Query
*!*		Procedure Query ( tcDistinct As String, tnTop As Number, tlPercent As Boolean, tcSelect As String, tcWhere As String, tlSetExact As Boolean, tcSortBy As String ) As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg

*!*			Local loColRet As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg, ;
*!*				loErr As Exception
*!*			Try
*!*				If ! Empty ( m.tcWhere )
*!*					loColRet = This.Where ( m.tcWhere, m.tlSetExact )

*!*				Else
*!*					loColRet = This

*!*				Endif && ! Empty( m.tcWhere )

*!*				If ! Empty ( m.tcDistinct )
*!*					loColRet = m.loColRet.Distinct ( m.tcDistinct )

*!*				Endif && ! Empty( m.tcDistinct )

*!*				If ! Empty ( m.tcSortBy )
*!*					loColRet = m.loColRet.SortBy ( m.tcSortBy )

*!*				Endif && ! Empty( m.tcSortBy )

*!*				If ! Empty ( m.tnTop )
*!*					loColRet = m.loColRet.TopQuery ( m.tnTop, m.tlPercen )

*!*				Endif && ! Empty( m.tnTop )

*!*				If ! Empty ( m.tcSelect )
*!*					loColRet = m.loColRet.Select ( m.tcSelect )

*!*				Endif &&  ! Empty( m.tcSelect )

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.loColRet

*!*		Endproc && Query

*!*		Procedure ToString ( tcTemplate As String, tcSeparador As String, tcWhere As String ) As String

*!*			Local lcExp As String, ;
*!*				lcExpresion As String, ;
*!*				lcString As String, ;
*!*				liIdx As Integer, ;
*!*				lnCount As Integer, ;
*!*				loCol As Collection, ;
*!*				loErr As Exception, ;
*!*				loItem As Object

*!*			Try

*!*				lcString = ''

*!*				If Empty ( m.tcSeparador ) Or Vartype ( m.tcSeparador ) # 'C'
*!*					tcSeparador = ','

*!*				Endif

*!*				If Empty ( m.tcTemplate ) Or Vartype ( m.tcTemplate ) # 'C'
*!*					tcTemplate = ''

*!*				Endif

*!*				If Empty ( m.tcWhere )
*!*					loCol = This

*!*				Else
*!*					loCol = This.Where ( m.tcWhere )

*!*				Endif && m.tcWhere

*!*				lnCount = m.loCol.Count

*!*				For liIdx = 1 To m.lnCount
*!*					loItem = m.loCol.Item[ m.liIdx ]
*!*					If Vartype ( m.loItem ) = 'O'
*!*						If Pemstatus ( m.loItem, 'ToString', 5 )
*!*							lcString = m.lcString + m.loItem.ToString ( m.tcTemplate )

*!*						Else && Pemstatus( m.loItem, 'ToString', 5 )
*!*							lcExp = m.String.ProcessClause ( m.tcTemplate, m.loItem, 'loItem.' )
*!*							* m.loItem = m.loCol.Item[ m.i ]
*!*							* m.lcString = m.lcString + Evaluate( m.lcExp )
*!*							TEXT To m.lcString Noshow Textmerge Additive
*!*							<<Evaluate( m.lcExp )>>
*!*							ENDTEXT

*!*						Endif && Pemstatus( m.loItem, 'ToString', 5 )

*!*						If m.liIdx # m.lnCount
*!*							lcString = m.lcString + m.tcSeparador

*!*						Endif && m.i # m.lnCount

*!*					Endif &&  Vartype( m.loItem ) = 'O'

*!*				Endfor

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Finally
*!*				loCol  = Null
*!*				loItem = Null

*!*			Endtry

*!*			Return m.lcString

*!*		Endproc && ToString

*!*		*
*!*		* Recorre la colección ejecutando un comando para cada elemento
*!*		Procedure Recursive ( toCol As Collection, tcPropertieOrMethod As String, tcMethodToCall As String, 			tvParam As Variant, 			tcEndCondition As String, 			tcItemEndCondition As String, 			tlDescending As Boolean ) As Boolean 			HelpString 'Recorre la colección ejecutando un comando para cada elemento'

*!*			#If .F.
*!*				Local lcEndCondition As String, ;
*!*					lcItemEndCondition As String, ;
*!*					lnIdx As Number, ;
*!*					loErr As Exception, ;
*!*					loItem As Object


*!*				TEXT
*!*				*:Help Documentation
*!*				*:Topic:
*!*				*:Description:
*!*				Recorre la colección ejecutando un comando para cada elemento
*!*				*:Project:
*!*				Sistemas Praxis
*!*				*:Autor:
*!*				Damian Eiff
*!*				*:Date:
*!*				Miércoles 12 de Agosto de 2009
*!*				*:ModiSummary:
*!*				*:Syntax:
*!*				*:Example:
*!*				*:Events:
*!*				*:NameSpace:
*!*				praxis.com
*!*				*:Keywords:
*!*				*:Implements:
*!*				*:Inherits:
*!*				*:Parameters:
*!*				toCol As Collection
*!*				tcPropertieOrMethod As String
*!*				tcMethodToCall As String
*!*				tvParam As Variant
*!*				tcEndCondition As String
*!*				tcItemEndCondition As String
*!*				tlDescending As Boolean
*!*				*:Remarks:
*!*				*:Returns:
*!*				Boolean
*!*				*:Exceptions:
*!*				*:SeeAlso:
*!*				*:EndHelp
*!*				ENDTEXT
*!*			#Endif


*!*			Try

*!*				If Vartype ( m.toCol ) # 'O'
*!*					toCol = This

*!*				Endif && Vartype( m.toCol ) = "O"

*!*				If Empty ( m.tcEndCondition )
*!*					tcEndCondition = '.F.'

*!*				Endif && Empty( m.tcEndCondition )

*!*				If Empty ( m.tcItemEndCondition )
*!*					tcItemEndCondition = '.F.'

*!*				Endif && Empty( m.tcEndCondition )

*!*				If ! Empty ( m.tcPropertieOrMethod )

*!*					* m.lcEndCondition = This.ProcessClause( m.tcEndCondition, This, 'This.' )
*!*					lcEndCondition = m.String.ProcessClause ( m.tcEndCondition, This, 'This.' )

*!*					If ! Evaluate ( m.lcEndCondition )

*!*						If m.toCol.Count > 0
*!*							lnIdx = 1

*!*							loItem = toCol.Item [ 1 ]
*!*							* m.lcItemEndCondition = This.ProcessClause( m.tcItemEndCondition, m.loItem, 'loItem.' )
*!*							lcItemEndCondition = m.String.ProcessClause ( m.tcItemEndCondition, m.loItem, 'loItem.' )
*!*							Do While m.lnIdx <= m.toCol.Count And ! Evaluate ( m.lcItemEndCondition )
*!*								loItem = m.toCol.Item ( m.lnIdx )
*!*								* m.lcItemEndCondition = This.ProcessClause( m.tcItemEndCondition, m.loItem, 'loItem.' )
*!*								lcItemEndCondition = m.String.ProcessClause ( m.tcItemEndCondition, m.loItem, 'loItem.' )

*!*								If Vartype ( m.loItem ) == 'O'
*!*									If m.tlDescending
*!*										If Pemstatus ( m.loItem, m.tcPropertieOrMethod, 5 )
*!*											* This.Recursive( m.loItem.&tcPropertieOrMethod., m.tcPropertieOrMethod, m.tcMethodToCall, m.tvParam, m.tcEndCondition, m.tcItemEndCondition, m.tlDescending )
*!*											This.Recursive ( Getpem ( m.loItem, m.tcPropertieOrMethod ), m.tcPropertieOrMethod, m.tcMethodToCall, m.tvParam, m.tcEndCondition, m.tcItemEndCondition, m.tlDescending )

*!*										Endif && Pemstatus( m.loItem, m.tcPropertieOrMethod, 5 )

*!*									Endif && m.tlDescending

*!*									This.&tcMethodToCall. ( m.loItem, m.tvParam )

*!*									If ! m.tlDescending
*!*										If Pemstatus ( m.loItem, m.tcPropertieOrMethod, 5 )
*!*											* This.Recursive( m.loItem.&tcPropertieOrMethod., m.tcPropertieOrMethod, m.tcMethodToCall, m.tvParam, m.tcEndCondition, m.tcItemEndCondition, m.tlDescending )
*!*											This.Recursive ( Getpem ( m.loItem, m.tcPropertieOrMethod ), m.tcPropertieOrMethod, m.tcMethodToCall, m.tvParam, m.tcEndCondition, m.tcItemEndCondition, m.tlDescending )

*!*										Endif && Pemstatus( m.loItem, m.tcPropertieOrMethod, 5 )

*!*									Endif && ! m.tlDescending

*!*								Endif && Vartype( m.loItem ) = 'O'

*!*								lnIdx = m.lnIdx + 1

*!*							Enddo

*!*						Endif && m.toCol.Count > 0

*!*					Endif && ! Evaluate( m.lcEndCondition )

*!*				Endif && ! Empty( m.tcPropertieOrMethod )

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return .T.

*!*		Endproc && Recursive

*!*		*!* ///////////////////////////////////////////////////////
*!*		*!* Procedure.....: Reverse
*!*		*!* Description...:
*!*		*!* Date..........: Miercoles 12 de Agosto de 2009
*!*		*!* Author........: Damian Eiff
*!*		*!* Project.......: Sistemas Praxis
*!*		*!* -------------------------------------------------------
*!*		*!* Modification Summary
*!*		*!* R/0001  -
*!*		*!*
*!*		*!*

*!*		Function Reverse() As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg
*!*			Local loColRet As Collection, ;
*!*				loErr As Exception

*!*			Try

*!*				loColRet = This.GetTop ( This.Count, 1, -1 )

*!*			Catch To loErr
*!*				DEBUG_CLASS_EXCEPTION
*!*				THROW_EXCEPTION

*!*			Endtry

*!*			Return m.loColRet

*!*		Endproc && Reverse

*!*		*!*		* Error
*!*		*!*		Procedure Error(tnError As Number, tcMethod As String, tnLine As Number) As Void
*!*		*!*			Local loErr As Exception
*!*		*!*			Local lcMsg As String
*!*		*!*			Try
*!*		*!*				TEXT TO m.lcMsg TEXTMERGE NOSHOW PRETEXT 15
*!*		*!*					Name: <<This.Name>> Class: <<This.Class>> ClassLibrary: <<This.ClassLibrary>> Method: <<m.tcMethod>> Error: <<m.tnError>> Line: <<m.tnLine>> Message: <<Message()>>
*!*		*!*				ENDTEXT

*!*		*!*				Comreturnerror( m.lcMsg, _vfp.ServerName )
*!*		*!*				&& this line is never executed

*!*		*!*			Catch To loErr
*!*		*!*				If Version( 2 ) == 2
*!*		*!*					? m.lcMsg + m.loErr.Message

*!*		*!*				Endif

*!*		*!*			Endtry

*!*		*!*		Endproc && Error

*!*	Enddefine && CollectionBase

* ObjectNameSpace
Define Class ObjectNamespace As NamespaceBase Of Tools\namespaces\prg\ObjectNamespace.prg

	#If .F.
		Local This As ObjectNamespace Of Tools\namespaces\prg\ObjectNamespace.prg
	#Endif

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData=[<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="createObjParam" type="method" display="CreateObjParam" />] ;
		+ [<memberdata name="forcetype" type="method" display="ForceType" />] ;
		+ [<memberdata name="mergeObjParam" type="method" display="MergeObjParam" />] ;
		+ [<memberdata name="synchronizeobjects" type="method" display="SynchronizeObjects" />] ;
		+ [<memberdata name="getclasshierarchy" type="method" display="GetClassHierarchy" />] ;
		+ [<memberdata name="inclasshierarchy" type="method" display="InClassHierarchy" />] ;
		+ [</VFPData>]

	* CreateObjParam
	* Recibe los parametros de a paraes nombre de propiedad y valor
	Function CreateObjParam ( tv1 As Variant, tv2 As Variant, tv3 As Variant, tv4 As Variant, ;
			tv5 As Variant, tv6 As Variant, tv7 As Variant, tv8 As Variant, ;
			tv9 As Variant, tv10 As Variant, tv11 As Variant, tv12 As Variant, ;
			tv13 As Variant, tv14 As Variant, tv15 As Variant, tv16 As Variant, ;
			tv17 As Variant, tv18 As Variant, tv19 As Variant, tv20 As Variant, ;
			tv21 As Variant, tv22 As Variant, tv23 As Variant, tv24 As Variant, ;
			tv25 As Variant, tv26 As Variant ) As Object HelpString 'Recibe los parametros de a paraes nombre de propiedad y valor.'

		* DAE 2009-07-31(15:38:55)
		* Recibe los parametros de a paraes nombre de propiedad y valor
		* CreateObjParam( "Boolean", .F. )
		* CreateObjParam( "Numeric", 1 )
		* CreateObjParam( "String", "Cadena de caracteres" )
		*

		Local lcMsg As String, ;
			lcProp As String, ;
			lcPropName As String, ;
			lcValue As String, ;
			lnIdx As Number, ;
			lnPcount As Number, ;
			loErr As Exception, ;
			loParam As Object, ;
			lvValue As Variant

		Try
			loParam  = Createobject ( 'Empty' )
			lnPcount = Pcount()
			If Mod ( m.lnPcount, 2 ) = 0

				For lnIdx = 1 To m.lnPcount Step 2
					* Obtengo el nombre de la propiedad
					lcProp     = 'tv' + Transform ( m.lnIdx )
					lcPropName = &lcProp.

					* Obtengo el valor de la propiedad
					lcValue = 'tv' + Transform ( m.lnIdx + 1 )
					lvValue = &lcValue.

					* Agrego la propiedad
					AddProperty ( m.loParam, m.lcPropName, m.lvValue )

				Endfor

			Else
				lcMsg = 'La cantidad de parametros pasados a la función (' + Transform ( m.lnPcount ) + ') deberia ser par.' + CR ;
					+ 'Ej:'+ CR ;
					+ ' CreateObjParam( "Boolean", .F. )' + CR ;
					+ ' CreateObjParam( "Numeric", 1 )' + CR ;
					+ ' CreateObjParam( "String", "Cadena de caracteres" )'
				Error m.lcMsg

			Endif && Mod( m.lnPcount, 2 ) = 0

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.loParam

	Endfunc && CreateObjParam

	* ForceType
	* Recibe un valor de cualquier tipo y devuelve el mismo transformado en un tipo determinado
	Function ForceType ( tuValue As Variant, tcType As String ) As Variant HelpString 'Recibe un valor de cualquier tipo y devuelve el mismo transformado en un tipo determinado.'

		* ForceType recibe un valor de cualquier tipo y devuelve el mismo
		* transformado en un tipo determinado

		Local lcType As String, ;
			luValue As Variant

		Try
			lcType = Vartype ( m.tuValue )

			Do Case
				Case m.lcType == m.tcType
					*/ Si el tipo es igual, devolver el valor sin modificarlo
					luValue = m.tuValue

				Case m.lcType == T_CHARACTER
					*/ Transformar el valor al Tipo deseado
					luValue = m.String.Char2Any ( m.tuValue, m.M.tcType )

				Otherwise
					*/ Transformar el valor a Character
					luValue = m.String.Any2Char ( m.tuValue )
					*/ Ejecutar en forma recursiva hasta obtener el tipo
					luValue = This.ForceType ( m.luValue, m.M.tcType )

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tuValue, tcType
			THROW_EXCEPTION

		Endtry

		Return m.luValue

	Endfunc && ForceType

	* MergeObjParam
	Function MergeObjParam ( toObj As Object @, tlOverWrite As Boolean, ;
			tv1 As Variant, tv2 As Variant, tv3 As Variant, tv4 As Variant, ;
			tv5 As Variant, tv6 As Variant, tv7 As Variant, tv8 As Variant, ;
			tv9 As Variant, tv10 As Variant, tv11 As Variant, tv12 As Variant, ;
			tv13 As Variant, tv14 As Variant, tv15 As Variant, tv16 As Variant, ;
			tv17 As Variant, tv18 As Variant, tv19 As Variant, tv20 As Variant, ;
			tv21 As Variant, tv22 As Variant, tv23 As Variant, tv24 As Variant ) As Object HelpString 'Recibe los parametros de a paraes nombre de propiedad y valor'


		* DAE 2009-07-31(15:38:55)
		* Recibe los parametros de a paraes nombre de propiedad y valor
		* MergeObjParam( oObj, lOverWrite, "Boolean", .F. )
		* MergeObjParam( oObj, lOverWrite, "Numeric", 1 )
		* MergeObjParam( oObj, lOverWrite, "String", "Cadena de caracteres" )
		*

		Local lcMsg As String, ;
			lcProp As String, ;
			lcPropName As String, ;
			lcValue As String, ;
			lnIdx As Number, ;
			lnPcount As Number, ;
			loErr As Exception, ;
			loParam As Object, ;
			lvValue As Variant

		Try
			lnPcount = Pcount()
			If Mod ( m.lnPcount, 2 ) = 0 And Vartype ( m.toObj ) = 'O'
				If  m.lnPcount > 2
					For lnIdx = 2 To m.lnPcount Step 2
						* Obtengo el nombre de la propiedad
						lcProp     = 'tv' + Transform ( m.lnIdx )
						lcPropName = &lcProp

						* Obtengo el valor de la propiedad
						lcValue = 'tv' + Transform ( m.lnIdx + 1 )
						lvValue = &lcValue

						* Agrego la propiedad
						If Pemstatus ( m.toObj, m.lcPropName, 5 )
							If lOverWrite
								toObj.&lcPropName. = m.lvValue

							Endif && lOverWrite

						Else
							AddProperty ( m.toObj, m.lcPropName, m.lvValue )

						Endif && PemStatus( m.toObj, m.lcPropName, 5 )

					Endfor

				Else
					lcMsg = 'La cantidad de parametros pasados a la función (' + Transform ( m.lnPcount ) + ') deberia ser par.' + CR ;
						+ 'Ej:'+ CR ;
						+ ' MergeObjParam( oObj, lOverWrite, "Boolean", .F. )' + CR ;
						+ ' MergeObjParam( oObj, lOverWrite, "Numeric", 1 )' + CR ;
						+ ' MergeObjParam( oObj, lOverWrite, "String", "Cadena de caracteres" )'
					Error m.lcMsg

				Endif && m.lnPcount > 2

			Else
				lcMsg = 'La cantidad de parametros pasados a la función (' + Transform ( m.lnPcount ) + ') deberia ser par.' + CR ;
					+ 'Ej:'+ CR ;
					+ ' MergeObjParam( oObj, lOverWrite, "Boolean", .F. )' + CR ;
					+ ' MergeObjParam( oObj, lOverWrite, "Numeric", 1 )' + CR ;
					+ ' MergeObjParam( oObj, lOverWrite, "String", "Cadena de caracteres" )'
				Error m.lcMsg

			Endif && Mod( m.lnPcount - 1, 2 ) = 0 And Vartype( toObj ) = 'O'

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.toObj

	Endfunc && MergeObjParam

	* SynchronizeObjects
	* Sincroniza las propiedades de dos objetos.
	Procedure SynchronizeObjects ( m.toParent As Object, m.toChild As Object, tnFlag As Numeric, tcExcludedPropertiesList As String ) As VOID HelpString 'Sincroniza las propiedades de dos objetos.'

		Local laMember[1], ;
			lcPropertyName As String, ;
			lcVartype As String, ;
			lnIdx As Number, ;
			lnLen As Integer, ;
			lnLen2 As Integer, ;
			lnPos As Number, ;
			loErr As Exception, ;
			loObjDest As Object, ;
			loObjSrc As Object, ;
			lvValue

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Sincroniza las propiedades de dos objetos
				 *:Project:
				 OOReport Builder
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Miércoles 24 de Octubre de 2007 ( 16:24:29 )
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

			If Empty ( m.tnFlag )
				tnFlag = 1

			Endif && Empty( m.tnFlag )

			If m.tnFlag == 1
				loObjDest = m.toParent
				loObjSrc  = m.toChild

			Else && m.tnFlag == 1
				loObjDest = m.toChild
				loObjSrc  = m.toParent

			Endif && m.tnFlag == 1

			lnLen = Amembers ( laMember, m.loObjSrc, 0 )

			If ! Empty ( m.tcExcludedPropertiesList )
				lnLen2 = Getwordcount ( m.tcExcludedPropertiesList, ',' )
				For lnIdx = 1 To m.lnLen2
					lcPropertyName = Getwordnum ( m.tcExcludedPropertiesList, m.lnIdx, ',' )
					lnPos          = Ascan ( laMember, m.lcPropertyName, 1, 1, 1, 1 )
					If m.lnPos # 0
						Adel ( laMember, m.lnPos )
						lnLen = m.lnLen - 1

					Endif && m.lnPos > 0

				Next

			Endif && ! Empty( tcExcludedPropertiesList )

			For lnIdx = 1 To m.lnLen
				lcPropertyName = laMember[ m.lnIdx ]
				lvValue        = Getpem ( m.loObjSrc, m.lcPropertyName )
				lcVartype      = Vartype ( m.lvValue )

				Try

					Do Case
						Case m.lcVartype $ 'CDGLNQTYUX'
							loObjDest.&lcProperty. = m.lvValue

						Case m.lcVartype == 'O'
							* @TODO Damian Eiff 2010-02-16 (08:11:33) Chequear si la propiedad no tiene metodo Access
							If ! Isnull ( Getpem ( m.loObjDest, m.lcProperty ) )
								This.SynchronizeObjects ( m.loObjDest.&lcProperty., m.lvValue )

							Else && ! Isnull ( Getpem ( m.loObjDest, m.lcProperty ) )
								loObjDest.&lcProperty. = m.lvValue

							Endif && ! Isnull( Getpem( m.loObjDest, m.lcProperty ) )

					Endcase

				Catch To loErr
					DEBUG_CLASS_EXCEPTION

				Endtry

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Finally
			loObjDest = Null
			loObjSrc  = Null

		Endtry

	Endproc && SynchronizeObjects

	* PopulateProperties
	* Carga las propiedades del objeto desde un Objeto pasado como parametro 
	Function PopulateProperties ( toObjDest As Object, toParam As Object ) As Boolean HelpString 'Carga las propiedades del objeto desde un Objeto pasado como parametro.'

		Local laMembers[1] As String, ;
			lcProperty As String, ;
			lcVartype As String, ;
			llRet As Boolean, ;
			loErr As Exception, ;
			lvProperty As Variant, ;
			lvValue As Variant

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Carga las propiedades del objeto desde un Objeto pasado como parametro
				 *:Autor:
				 Damian Eiff
				 *:Date:
				 Miércoles 11 de Marzo de 2009 (11:50:29)
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

		llRet = .F.
		Try

			If Vartype ( m.toObjDest ) == 'O' And Vartype ( m.toParam ) == 'O'

				Amembers ( laMembers, m.toParam )

				For Each m.lcProperty In laMembers
					lvValue   = Getpem ( m.toParam, m.lcProperty )
					lcVartype = Vartype ( m.lvValue )

					Try

						Do Case
								* Case Inlist( Vartype( toParam.&lcProperty ), 'C', 'D', 'G', 'L', 'N', 'Q', 'T', 'Y' )
							Case m.lcVartype $ 'CDGLNQTYUX'
								* This.&lcProperty = toParam.&lcProperty
								toObjDest.&lcProperty. = m.lvValue

							Case m.lcVartype == 'O'
								lvProperty = Getpem ( m.toObjDest, m.lcProperty )
								If ! Isnull ( m.lvProperty ) And Pemstatus ( m.lvProperty, 'PopulateProperties', 5 )
									m.lvProperty.PopulateProperties ( m.lvValue )
									* toObjDest.&lcProperty..PopulateProperties( lvValue)

								Else
									* toObjDest.&lcProperty = lvValue
									toObjDest.&lcProperty. = m.lvValue

								Endif && ! Isnull( m.lvProperty ) And Pemstatus( m.lvProperty, 'PopulateProperties', 5 )

						Endcase

					Catch To loErr
						DEBUG_CLASS_EXCEPTION
						* No hago nada

					Endtry

				Endfor

			Endif && Vartype( m.toObjDest ) == "O" And Vartype( m.toParam ) == "O"

			llRet = .T.

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toObjDest, toParam
			THROW_EXCEPTION

		Endtry

		Return m.llRet

	Endfunc && PopulateProperties

	* GetClassHierarchy
	* Function to get class hierarchy
	* Devuelve la jerarquia de clases del objeto.
	Function GetClassHierarchy ( toObject As Object ) As String HelpString 'Devuelve la jerarquia de clases del objeto.'

		Local laClassHierarchy[1], ;
			lcClassHierarchy As String, ;
			liIdx As Integer, ;
			lnClassCount As Number, ;
			lsClassString

		Try
			lcClassHierarchy = ''
			If Type ( 'toObject' ) == 'O'
				lnClassCount = Aclass ( laClassHierarchy, toObject )
				For liIdx = 1 To nClassCount
					lcClassHierarchy = lcClassHierarchy + ['] + laClassHierarchy[ liIdx ]  + [',]

				Endfor

			Endif && TYPE( 'toObject' ) == 'O'


		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toObject
			THROW_EXCEPTION

		Endtry

		Return lcClassHierarchy

	Endfunc && GetClassHierarchy

	* InClassHierarchy
	Function InClassHierarchy ( toObject  As Object, tcClassName As String ) As Boolean
		Local laClassHierarchy[1], ;
			llRet As Boolean, ;
			lnElement As Number

		Try
			If Type ( 'toObject' ) == 'O'
				Aclass ( laClassHierarchy, toObject   )
				lnElement = Ascan ( laClassHierarchy, tcClassName, 1, -1, -1 )
				llRet     = lnElement > 0

			Endif  && Type( 'toObject' ) == 'O'

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toObject, tcClassName
			THROW_EXCEPTION

		Endtry

		Return llRet

	Endfunc && InClassHierarchy

Enddefine && ObjectNameSpace

* ShellExecute
* Ejecuta el comando o programa.
Function ShellExecute ( tnHWnd As Long, tcOperation As String, tcFile As String, tcParameters As String, tcDirectory As String, tnShowCmd As Long)
	Declare Long ShellExecute In shell32 As xShellExecute Long, String, String, String, String, Long

	Return xShellExecute ( m.tnHWnd, m.tcOperation, m.tcFile, m.tcParameters, m.tcDirectory, m.tnShowCmd )

Endfunc && ShellExecute
