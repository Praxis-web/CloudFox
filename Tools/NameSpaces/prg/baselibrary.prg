#INCLUDE "FW\Comunes\Include\Praxis.h"
#INCLUDE "FW\TierAdapter\Include\TA.h"
#INCLUDE "Tools\ErrorHandler\Include\EH.h"
#INCLUDE "Tools\NameSpaces\Include\system.h"


#Define KEYASCENDING 2
#Define KEYDESCENDING 3

Define Class NamespaceBase As Custom

	#If .F.
		Local This As NamespaceBase Of Tools\NameSpaces\Prg\baselibrary.Prg
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

	Protected Function ShowWhatsThis
	Endfunc

	Protected Function Destroy
		DoDefault()
	EndFunc


	* Error
	Procedure xxxError(tnError As Number, tcMethod As String, tnLine As Number) As Void
		Local lcMsg As String

		TEXT TO m.lcMsg TEXTMERGE NOSHOW PRETEXT 15
			Name: <<This.Name>> Class: <<This.Class>> ClassLibrary: <<This.ClassLibrary>> Method: <<m.tcMethod>> Error: <<m.tnError>> Line: <<m.tnLine>> Message: <<Message()>>
		ENDTEXT

		Comreturnerror( m.lcMsg , _vfp.ServerName )
		&& this line is never executed
	Endproc && Error

Enddefine

Define Class NamespaceBase2 As Session

	#If .F.
		Local This As NamespaceBase2 Of Tools\NameSpaces\Prg\baselibrary.Prg
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

	Protected Function ShowWhatsThis
	Endfunc

	Protected Function Destroy
		DoDefault()
	Endfunc

	* Error
	Procedure xxxError(tnError As Number, tcMethod As String, tnLine As Number) As Void
		Local lcMsg As String

		TEXT TO m.lcMsg TEXTMERGE NOSHOW PRETEXT 15
			Name: <<This.Name>> Class: <<This.Class>> ClassLibrary: <<This.ClassLibrary>> Method: <<m.tcMethod>> Error: <<m.tnError>> Line: <<m.tnLine>> Message: <<Message()>>
		ENDTEXT

		Comreturnerror( m.lcMsg , _vfp.ServerName )
		&& this line is never executed
	Endproc && Error

Enddefine

Define Class ObjectBase As NamespaceBase Of v:\Clipper2Fox\Tools\NameSpaces\Prg\baselibrary.Prg

	#If .F.
		Local This As ObjectBase Of Tools\NameSpaces\Prg\baselibrary.Prg
	#Endif

	BaseName = "Object"	

	Function New() As Object
		Return _NewObject( This.Class, This.ClassLibrary )

	Endfunc && New

	Function Help( ) As Void

		Local lcURL As String
		m.lcURL = [ http://msdn.microsoft.com/en-us/library/ ]+Juststem( This.ClassLibrary ) + "." + This.BaseName+[ .aspx ]
		ShellExecute( 0, "open", m.lcURL, "", "", 0 )

	Endfunc && Help

	Function Equals( toObject1 As Object, toObject2 As Object) As Boolean
		Local lnPcount As Number
		Local llReturn As Boolean
		m.lnPcount = Pcount( )
		Do Case
			Case m.lnPcount = 1 And Vartype( m.toObject1 ) = "O"
				m.llReturn = ( This == m.toObject1 )

			Case m.lnPcount = 2
				m.llReturn = ( m.toObject1 == m.toObject2 )

			Otherwise
				m.llReturn = .F.

		Endcase

		Return m.llReturn

	Endfunc && Equals

	Function GetHashCode( toObject As Object ) As String
		#Define MEMBERDELIMITER "|"
		Local lnMax As Number
		Local lnCounter As Number
		Local lcMemberName As String
		Local lcType As String
		Local lcCombined As String
		Local lcValueToHash As String
		Local lcHashCode As String
		Local Array laryMembers[ 1, 1 ]

		If Vartype( m.toObject ) # "O"
			m.toObject = This

		Endif && VARTYPE( m.toObject ) != "O"

		* STORE "" TO m.lcValueToHash, m.lcHashCode
		m.lcValueToHash = ''
		m.lcHashCode = ''
		m.lnMax = Amembers( laryMembers, m.toObject, 1 )

		For m.lnCounter = 1 To m.lnMax
			m.lcMemberName = laryMembers[ m.lnCounter, 1 ]
			m.lcType = laryMembers[ m.lnCounter, 2 ]
			m.lcCombined = m.lcMemberName + MEMBERDELIMITER + m.lcType
			Do Case
				Case m.lcType == "Property"
					*!* Need a better way to handle these...
					If !Inlist( Upper( m.lcMemberName ), "CONTROLS", "OBJECTS", "PARENT", "BUTTONS", "PAGES" )
						m.lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined + MEMBERDELIMITER + Transform( Getpem( m.toObject, laryMembers[ m.lnCounter, 1 ] ) )

					Else
						m.lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined

					Endif
				Case m.lcType == "Object"
					m.lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined + MEMBERDELIMITER + This.GetHashCode( Getpem( m.toObject, laryMembers( m.lnCounter, 1 ) ) )

				Otherwise && "Event" or "Method"
					m.lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined

			Endcase
		Endfor
		m.lcHashCode = Sys( 2007, m.lcValueToHash, 0, 1 )

		Return m.lcHashCode

	Endfunc && GetHashCode

	Function MemberwiseClone() As Object

		Local loClone As Object
		Local lnTotal As Number
		Local lnCounter As Number
		Local lcMember As String
		Local Array laMembers[ 1 ]
		Local Array laEvents[ 1 ]

		*!* Something needs to be figured out for objects that receive init parameters
		If Vartype( This.Class ) = "C" And Vartype( This.ClassLibrary )= "C"
			m.loClone = _NewObject( This.Class, This.ClassLibrary )

		Else
			m.loClone = Createobject( "EMPTY" )

		Endif && VARTYPE( This.Class ) = "C" AND VARTYPE( This.CLASSLIBRARY )= "C"

		m.lnTotal = Amembers( laMembers, This, 0, "G#" )
		For m.lnCounter = 1 To m.lnTotal
			If !( "R" $ m.laMembers[ m.lnCounter, 2 ] )
				m.lcMember = m.laMembers[ m.lnCounter, 1 ]
				AddProperty( m.loClone, m.lcMember, Getpem( This, m.lcMember ) )

			Endif && !( "R" $ m.laMembers[ m.lnCounter, 2 ] )

		Endfor

		m.lnTotal = Aevents( laEvents, This )
		For lnCounter = 1 To m.lnTotal
			If laEvents[ m.lnCounter, 1 ] && Is this the event Source?
				Bindevent( laEvents[ m.lnCounter, 2 ], laEvents[ m.lnCounter, 3 ], m.loClone, laEvents[ m.lnCounter, 4 ], laEvents[ m.lnCounter, 5 ] )

			Else
				Bindevent( m.loClone, laEvents[ m.lnCounter, 3 ], laEvents[ m.lnCounter, 2 ], laEvents[ m.lnCounter, 4 ], laEvents[ m.lnCounter, 5 ] )

			Endif && laEvents[ m.lnCounter, 1 ]

		Endfor

		Return m.loClone

	Endfunc && MemberwiseClone

	Function ReferenceEquals( toObject1, toObject2 ) As Boolean
		Local lnPcount, llReturn
		m.lnPcount = Pcount( )
		Do Case
			Case m.lnPcount = 1 And Vartype( m.toObject1 ) = "O"
				m.llReturn = ( This == m.toObject1 )

			Case m.lnPcount = 2 And Vartype( m.toObject1 ) = "O" And Vartype( m.toObject2 ) = "O"
				m.llReturn = ( m.toObject1 == m.toObject2 )

			Otherwise
				m.llReturn = .F.

		Endcase

		Return m.llReturn

	Endfunc && ReferenceEquals

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [ <VFPData> ]+;
		[ <memberdata name="new" type="method" display="New"/> ]+;
		[ <memberdata name="memberwiseclone" type="method" display="MemberwiseClone"/> ]+;
		[ <memberdata name="gethashcode" type="method" display="GetHashCode"/> ]+;
		[ <memberdata name="equals" type="method" display="Equals"/> ]+;
		[ <memberdata name="referenceequals" type="method" display="ReferenceEquals"/> ]+;
		[ <memberdata name="basename" type="property" display="BaseName"/> ]+;
		[ </VFPData> ]

Enddefine && ObjectBase

Define Class ObjectBase2 As NamespaceBase2 Of "Tools\Namespaces\Prg\BaseLibrary.prg"

	#If .F.
		Local This As ObjectBase2 Of Tools\NameSpaces\Prg\baselibrary.Prg
	#Endif

	BaseName = "Object"
	
	Function New() As Object
		Return _NewObject( This.Class, This.ClassLibrary )

	Endfunc && New

	Function Help( ) As Void

		Local lcURL As String
		m.lcURL = [ http://msdn.microsoft.com/en-us/library/ ]+Juststem( This.ClassLibrary ) + "." + This.BaseName+[ .aspx ]
		ShellExecute( 0, "open", m.lcURL, "", "", 0 )

	Endfunc && Help

	Function Equals( toObject1 As Object, toObject2 As Object) As Boolean
		Local lnPcount As Number
		Local llReturn As Boolean
		m.lnPcount = Pcount( )
		Do Case
			Case m.lnPcount = 1 And Vartype( m.toObject1 ) = "O"
				m.llReturn = ( This == m.toObject1 )

			Case m.lnPcount = 2
				m.llReturn = ( m.toObject1 == m.toObject2 )

			Otherwise
				m.llReturn = .F.

		Endcase

		Return m.llReturn

	Endfunc && Equals

	Function GetHashCode( toObject As Object ) As String
		#Define MEMBERDELIMITER "|"
		Local lnMax As Number
		Local lnCounter As Number
		Local lcMemberName As String
		Local lcType As String
		Local lcCombined As String
		Local lcValueToHash As String
		Local lcHashCode As String
		Local Array laryMembers[ 1, 1 ]

		If Vartype( m.toObject ) # "O"
			m.toObject = This

		Endif && VARTYPE( m.toObject ) != "O"

		* STORE "" TO m.lcValueToHash, m.lcHashCode
		m.lcValueToHash = ''
		m.lcHashCode = ''
		m.lnMax = Amembers( laryMembers, m.toObject, 1 )

		For m.lnCounter = 1 To m.lnMax
			m.lcMemberName = laryMembers[ m.lnCounter, 1 ]
			m.lcType = laryMembers[ m.lnCounter, 2 ]
			m.lcCombined = m.lcMemberName + MEMBERDELIMITER + m.lcType
			Do Case
				Case m.lcType == "Property"
					*!* Need a better way to handle these...
					If !Inlist( Upper( m.lcMemberName ), "CONTROLS", "OBJECTS", "PARENT", "BUTTONS", "PAGES" )
						m.lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined + MEMBERDELIMITER + Transform( Getpem( m.toObject, laryMembers[ m.lnCounter, 1 ] ) )

					Else
						m.lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined

					Endif
				Case m.lcType == "Object"
					m.lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined + MEMBERDELIMITER + This.GetHashCode( Getpem( m.toObject, laryMembers( m.lnCounter, 1 ) ) )

				Otherwise && "Event" or "Method"
					m.lcValueToHash = m.lcValueToHash + MEMBERDELIMITER + m.lcCombined

			Endcase
		Endfor
		m.lcHashCode = Sys( 2007, m.lcValueToHash, 0, 1 )

		Return m.lcHashCode

	Endfunc && GetHashCode

	Function MemberwiseClone() As Object

		Local loClone As Object
		Local lnTotal As Number
		Local lnCounter As Number
		Local lcMember As String
		Local Array laMembers[ 1 ]
		Local Array laEvents[ 1 ]

		*!* Something needs to be figured out for objects that receive init parameters
		If Vartype( This.Class ) = "C" And Vartype( This.ClassLibrary )= "C"
			m.loClone = _NewObject( This.Class, This.ClassLibrary )

		Else
			m.loClone = Createobject( "EMPTY" )

		Endif && VARTYPE( This.Class ) = "C" AND VARTYPE( This.CLASSLIBRARY )= "C"

		m.lnTotal = Amembers( laMembers, This, 0, "G#" )
		For m.lnCounter = 1 To m.lnTotal
			If !( "R" $ m.laMembers[ m.lnCounter, 2 ] )
				m.lcMember = m.laMembers[ m.lnCounter, 1 ]
				AddProperty( m.loClone, m.lcMember, Getpem( This, m.lcMember ) )

			Endif && !( "R" $ m.laMembers[ m.lnCounter, 2 ] )

		Endfor

		m.lnTotal = Aevents( laEvents, This )
		For lnCounter = 1 To m.lnTotal
			If laEvents[ m.lnCounter, 1 ] && Is this the event Source?
				Bindevent( laEvents[ m.lnCounter, 2 ], laEvents[ m.lnCounter, 3 ], m.loClone, laEvents[ m.lnCounter, 4 ], laEvents[ m.lnCounter, 5 ] )

			Else
				Bindevent( m.loClone, laEvents[ m.lnCounter, 3 ], laEvents[ m.lnCounter, 2 ], laEvents[ m.lnCounter, 4 ], laEvents[ m.lnCounter, 5 ] )

			Endif && laEvents[ m.lnCounter, 1 ]

		Endfor

		Return m.loClone

	Endfunc && MemberwiseClone

	Function ReferenceEquals( toObject1, toObject2 ) As Boolean
		Local lnPcount, llReturn
		m.lnPcount = Pcount( )
		Do Case
			Case m.lnPcount = 1 And Vartype( m.toObject1 ) = "O"
				m.llReturn = ( This == m.toObject1 )

			Case m.lnPcount = 2 And Vartype( m.toObject1 ) = "O" And Vartype( m.toObject2 ) = "O"
				m.llReturn = ( m.toObject1 == m.toObject2 )

			Otherwise
				m.llReturn = .F.

		Endcase

		Return m.llReturn

	Endfunc && ReferenceEquals

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [ <VFPData> ]+;
		[ <memberdata name="new" type="method" display="New"/> ]+;
		[ <memberdata name="memberwiseclone" type="method" display="MemberwiseClone"/> ]+;
		[ <memberdata name="gethashcode" type="method" display="GetHashCode"/> ]+;
		[ <memberdata name="equals" type="method" display="Equals"/> ]+;
		[ <memberdata name="referenceequals" type="method" display="ReferenceEquals"/> ]+;
		[ <memberdata name="basename" type="property" display="BaseName"/> ]+;
		[ </VFPData> ]

Enddefine && ObjectBase2

*!* ///////////////////////////////////////////////////////
*!* Class.........: SessionBase
*!* ParentClass...: Session
*!* BaseClass.....: Session
*!* Description...:
*!* Date..........: Martes 3 de Febrero de 2009 (11:48:53)
*!* Author........: Ricardo Aidelman
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*

Define Class SessionBase As ObjectBase2 Of "Tools\Namespaces\Prg\BaseLibrary.prg"

	#If .F.
		Local This As SessionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"
	#Endif

	*	DataSession = SET_DEFAULT

	*!* Referencia al objeto Parent
	oParent = Null

	_instanceId = Sys( 2015 )

	* Valor de la DataSessionId original
	nOldDataSessionId = 0
	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[<memberdata name="oparent_assign" type="method" display="oParent_Assign" />] + ;
		[<memberdata name="getmain" type="method" display="GetMain" />] + ;
		[<memberdata name="processclause" type="method" display="ProcessClause" />] + ;
		[<memberdata name="members" type="method" display="AMembers" />] + ;
		[<memberdata name="pemstatus" type="method" display="PemStatus" />] + ;
		[<memberdata name="londestroy" type="property" display="lOnDestroy" />] + ;
		[<memberdata name="nolddatasessionid" type="property" display="nOldDataSessionId" />] + ;
		[</VFPData>]

	Procedure Init()
	
		If !IsRuntime()
			Set Datasession To 
		EndIf
		
		This.nOldDataSessionId = This.DataSessionId

		Return .T.

	Endproc && Init

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Initialize
	*!* Description...:
	*!* Date..........: Martes 3 de Febrero de 2009 (11:48:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*
	* ClassBeforeInitialize
	Protected Function ClassBeforeInitialize( tvParam As Variant )

		Return .T.

	Endfunc && ClassBeforeInitialize

	* HookBeforeInitialize
	Function HookBeforeInitialize( tvParam As Variant )

		Return .T.

	Endfunc && HookBeforeInitialize

	* HookAfterInitialize
	Procedure HookAfterInitialize( tvParam As Variant )

	Endproc && HookAfterInitialize

	* ClassAfterInitialize
	Protected Procedure ClassAfterInitialize( tvParam As Variant )

	Endproc && ClassAfterInitialize

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Initialize
	*!* Description...:
	*!* Date..........: Martes 3 de Febrero de 2009 (11:48:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Initialize( tvParam As Variant ) As Boolean

		Try

			If This.ClassBeforeInitialize( m.tvParam )
				If This.HookBeforeInitialize( m.tvParam )
					This.HookAfterInitialize( m.tvParam )
					This.ClassAfterInitialize( m.tvParam )

				Endif && This.HookBeforeInitialize( m.tvParam )

			Endif && This.ClassBeforeInitialize( m.tvParam )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

	Endfunc && Initialize

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oParent_Assign
	*!* Date..........: Martes 3 de Febrero de 2009 (11:52:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oParent_Assign( toParent As Object )

		If Vartype( m.toParent ) # "O"
			m.toParent = Null

		Endif

		This.oParent = m.toParent

	Endproc && oParent_Assign


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetMain
	*!* Description...: Devuelve el objeto principal en la jerarquía de clases
	*!* Date..........: Martes 3 de Febrero de 2009 (11:57:16)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetMain( ) As Object;
			HELPSTRING "Devuelve el objeto principal en la jerarquía de clases"


		Local loMain As Object

		Try

			If Vartype( This.oParent ) == "O"
				m.loMain = This.oParent.GetMain()

			Else
				m.loMain = This

			Endif

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.loMain

	Endproc && GetMain

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Martes 3 de Febrero de 2009 (13:22:51)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy( ) As Void
		Try

			If !Empty( This.nOldDataSessionId )
				This.DataSessionId = This.nOldDataSessionId

			Endif

			Unbindevents( This )

			DoDefault()

		Catch To loErr
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
	Protected Procedure cObjectFactoryFileName_Access()

		If Empty( This.cObjectFactoryFileName )
			This.cObjectFactoryFileName = Addbs( This.cRootFolder ) + "ObjectFactoryCfg.xml"

		Endif

		Return This.cObjectFactoryFileName

	Endproc && cObjectFactoryFileName_Access

	Function ProcessClause ( tcClause As String, tvOrigen, tcReplace As String  ) As String
		Local i As Integer
		Local lcRet As String
		Local lcMember As String
		Local Array laMembers[ 1 ]
		Local Array lAFields[ 1 ]
		Local lnMax As Number
		Local lcType As String

		Try
			m.lcRet = Space( 1 ) + m.tcClause + Space( 1 )
			m.lcType = Vartype( m.tvOrigen )
			If Inlist( m.lcType, 'C', 'O' )

				Do Case
					Case m.lcType = 'C' And Used( m.tvOrigen )
						If Empty( tcReplace )
							m.tcReplace = m.tvOrigen + '.'

						Endif && Empty( m.tcReplace )

						m.lnMax = Afields( lAFields, m.tvOrigen )
						Asort( lAFields, 1, -1, 1, 1 )
						For m.i = 1 To lnMax
							m.lcField = Alltrim( lAFields[ m.i, 1 ] )
							m.lcRet = Strtran( m.lcRet, Space( 1 ) + m.lcField, Space( 1 ) + m.tcReplace + m.lcField, -1, -1, 1 )
							m.lcRet = Strtran( m.lcRet, "(" + m.lcField, "(" + m.tcReplace + m.lcField, -1, -1, 1 )

						Endfor

					Case m.lcType = 'O'
						If Empty( m.tcReplace )
							m.tcReplace = 'loItem.'

						Endif && Empty( m.tcReplace )

						m.lnMax = Amembers( laMembers, m.tvOrigen )
						Asort( laMembers, 1, -1, 1, 1 )
						For m.i = 1 To m.lnMax
							m.lcMember = Alltrim( laMembers[ m.i ] )
							m.lcRet = Strtran( m.lcRet, Space( 1 ) + m.lcMember, Space( 1 ) + m.tcReplace + m.lcMember, -1, -1, 1 )
							m.lcRet = Strtran( m.lcRet, "(" + m.lcMember, "(" + m.tcReplace + m.lcMember, -1, -1, 1 )

						Endfor

						If Pemstatus( m.tvOrigen, 'Class', 5 )
							m.lnMax = Amembers( laMembers, m.tvOrigen.Class )
							Asort( laMembers, 1, -1, 1, 1 )
							For m.i = 1 To m.lnMax
								m.lcMember = Alltrim( laMembers[ m.i ] )
								m.lcRet = Strtran( m.lcRet, Space( 1 ) + m.lcMember, Space( 1 ) + m.tcReplace + m.lcMember, -1, -1, 1 )
								m.lcRet = Strtran( m.lcRet, "(" + m.lcMember, "(" + m.tcReplace + m.lcMember, -1, -1, 1 )

							Endfor

						Endif && Pemstatus( m.tvOrigen, 'Class', 5 )

				Endcase

			Endif && Inlist( m.lcType, 'C', 'O' )

		Catch To loErr
			THROW_EXCEPTION

		Finally
			m.loItem = Null

		Endtry

		Return Alltrim( m.lcRet )

	Endfunc && ProcessClause

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AMembers
	*!* Description...:
	*!* Date..........: Jueves 30 de Julio de 2009 (00:41:25)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Amembers( tvAmembers As Variant @, tnArrayContentsId As Integer ) As Variant

		Local lnMax As Integer

		Try

			If Empty( m.tnArrayContentsId )
				m.tnArrayContentsId = 0

			Endif && Empty( m.tnArrayContentsId )

			m.lnMax = Amembers( m.tvAmembers, This, m.tnArrayContentsId )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.lnMax

	Endproc && AMembers

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: PemStatus
	*!* Description...:
	*!* Date..........: Jueves 30 de Julio de 2009 (00:47:07)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Pemstatus( tcProperty As String, tnAttribute As Integer ) As Variant
		Local lvRet As Variant

		If ! Empty( m.tcProperty )
			If Empty( m.tnAttribute )
				m.tnAttribute = 5

			Endif && Empty( m.tnAttribute )
			m.lvRet = Pemstatus( This, m.tcProperty, m.tnAttribute )

		Endif && ! Empty( m.tcProperty )

		Return m.lvRet

	Endproc && PemStatus

	* ToString
	Procedure ToString( tcTemplate As String ) As String

		Local lcString As String
		Local lcExpresion As String

		Try

			m.lcString = ""

			If Empty( m.tcTemplate )
				m.lcString = This.Name

			Else
				m.lcExpresion = This.ProcessClause( m.tcTemplate, This, "This." )
				m.lcString = Evaluate( m.lcExpresion )

			Endif && Empty( m.tcTemplate )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.lcString

	Endproc && ToString

Enddefine && SessionBase

*!* ///////////////////////////////////////////////////////
*!* Class.........: CustomBase
*!* ParentClass...: Custom
*!* BaseClass.....: Custom
*!* Description...:
*!* Date..........: Lunes 26 de OCtubre de 2009
*!* Author........: Damian Eiff
*!* Project.......: Sistemas Praxis
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001 -
*!*
*!*

Define Class CustomBase As ObjectBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"

	#If .F.
		Local This As CustomBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"
	#Endif

	DataSession = SET_DEFAULT

	DataSessionId = Set("Datasession")

	*!* Referencia al objeto Parent
	oParent = Null

	_instanceId = Sys( 2015 )

	* Flag
	lOnDestroy = .F.

	* Valor de la DataSessionId original
	nOldDataSessionId = 0

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[<memberdata name="oparent_assign" type="method" display="oParent_Assign" />] + ;
		[<memberdata name="getmain" type="method" display="GetMain" />] + ;
		[<memberdata name="processclause" type="method" display="ProcessClause" />] + ;
		[<memberdata name="members" type="method" display="AMembers" />] + ;
		[<memberdata name="pemstatus" type="method" display="PemStatus" />] + ;
		[<memberdata name="londestroy" type="property" display="lOnDestroy" />] + ;
		[<memberdata name="nolddatasessionid" type="property" display="nOldDataSessionId" />] + ;
		[</VFPData>]

	Procedure Init()
		This.nOldDataSessionId = This.DataSessionId

		Return .T.

	Endproc

	* ClassBeforeInitialize
	Protected Function ClassBeforeInitialize( tvParam As Variant )

		Return .T.

	Endfunc && ClassBeforeInitialize

	* HookBeforeInitialize
	Function HookBeforeInitialize( tvParam As Variant )

		Return .T.

	Endfunc && HookBeforeInitialize

	* HookAfterInitialize
	Procedure HookAfterInitialize( tvParam As Variant )

	Endproc && HookAfterInitialize

	* ClassAfterInitialize
	Protected Procedure ClassAfterInitialize( tvParam As Variant )

	Endproc && ClassAfterInitialize

	*!* ///////////////////////////////////////////////////////
	*!* Function......: Initialize
	*!* Description...:
	*!* Date..........: Martes 3 de Febrero de 2009 (11:48:53)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Initialize( tvParam As Variant ) As Boolean

		Try

			If This.ClassBeforeInitialize( m.tvParam )
				If This.HookBeforeInitialize( m.tvParam )
					This.HookAfterInitialize( m.tvParam )
					This.ClassAfterInitialize( m.tvParam )

				Endif && This.HookBeforeInitialize( m.tvParam )

			Endif && This.ClassBeforeInitialize( m.tvParam )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

	Endfunc && Initialize

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oParent_Assign
	*!* Date..........: Martes 3 de Febrero de 2009 (11:52:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oParent_Assign( toParent As Object )

		If Vartype( m.toParent ) # "O"
			m.toParent = Null

		Endif

		This.oParent = m.toParent

	Endproc && oParent_Assign


	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetMain
	*!* Description...: Devuelve el objeto principal en la jerarquía de clases
	*!* Date..........: Martes 3 de Febrero de 2009 (11:57:16)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetMain( ) As Object HelpString "Devuelve el objeto principal en la jerarquía de clases"


		Local loMain As Object

		Try

			If Vartype( This.oParent ) == "O"
				m.loMain = This.oParent.GetMain()

			Else
				m.loMain = This

			Endif

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.loMain

	Endproc && GetMain

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Martes 3 de Febrero de 2009 (13:22:51)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy( ) As Void

		Try
			If ! This.lOnDestroy
				This.lOnDestroy = .T.
				If !Empty( This.nOldDataSessionId )
					This.DataSessionId = This.nOldDataSessionId

				Endif

				Unbindevents( This )

				DoDefault()

			Endif && ! This.lOnDestroy

		Catch To loErr
			THROW_EXCEPTION

		Endtry

	Endproc && Destroy

	* ProcessClause
	Procedure ProcessClause ( tcClause As String, tvOrigen As Variant, tcReplace As String ) As String

		Return m.String.ProcessClause( m.tcClause, m.tvOrigen, m.tcReplace )

	Endproc && ProcessClause

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: AMembers
	*!* Description...:
	*!* Date..........: Jueves 30 de Julio de 2009 (00:41:25)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Amembers( tvAmembers As Variant @, tnArrayContentsId As Integer ) As Variant

		Local lnMax As Integer
		Try
			loError = _NewObject( "ErrorHandler", "ErrorHandler\Prg\ErrorHandler.prg" )
			* Remark: ''
			* TraceLogin: ''

			If Empty( m.tnArrayContentsId )
				m.tnArrayContentsId = 0

			Endif && Empty( m.tnArrayContentsId )

			m.lnMax = Amembers( tvAmembers, This, m.tnArrayContentsId )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.lnMax

	Endproc && AMembers

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: PemStatus
	*!* Description...:
	*!* Date..........: Jueves 30 de Julio de 2009 (00:47:07)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Pemstatus( tcProperty As String, tnAttribute As Integer ) As Variant
		Local lvRet As Variant

		If ! Empty( m.tcProperty )
			If Empty( m.tnAttribute )
				m.tnAttribute = 5

			Endif && Empty( m.tnAttribute )
			m.lvRet = Pemstatus( This, m.tcProperty, m.tnAttribute )

		Endif && ! Empty( m.tcProperty )

		Return m.lvRet

	Endproc && PemStatus

	* ToString
	Procedure ToString( tcTemplate As String ) As String

		Local lcString As String
		Local lcExpresion As String

		Try

			*!* Assert ( Lower( This.Name ) # '_recordorder' ) Message 'Es _recordorder'

			m.lcString = ""

			If Empty( m.tcTemplate )
				m.lcString = This.Name

			Else
				* m.lcExpresion = This.ProcessClause( m.tcTemplate, This, "This." )
				m.lcExpresion = m.String.ProcessClause( m.tcTemplate, This, "This." )
				m.lcString = Evaluate( m.lcExpresion )

			Endif && Empty( tcTemplate )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.lcString

	Endproc && ToString

Enddefine && CustomBase

*!* ///////////////////////////////////////////////////////
*!* Class.........: CollectionBase
*!* ParentClass...: collection
*!* BaseClass.....: collection
*!* Description...:
*!* Date..........: Domingo 16 de Abril de 2006 (20:55:34)
*!* Author........: Ricardo Aidelman
*!* Project.......: Tier Adapter
*!* -------------------------------------------------------
*!* Modification Summary
*!* R/0001  -
*!*
*!*


*!*	Define Class CollectionBase As SessionBase Of "V:\Sistemas Praxis\Fw\Actual\Comunes\Prg\Prxbaselibrary.prg"
Define Class xxxCollectionBase As Collection
* RA 2014-08-30(12:16:03)
* Se utiliza Tools\DataDictionary\prg\CollectionBase.prg

	#If .F.
		Local This As CollectionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"
	#Endif


	*!* Nombre de la clase de los elementos que forman la coleccion
	cClassName = ""

	*!* Nombre de la librería de clases
	cClassLibrary = ""

	*!* Carpeta donde se encuentra la librería de clases
	cClassLibraryFolder = ""

	*!* Referencia al objeto principal
	oMainObject = Null

	*!* Referencia al Parent
	oParent = Null

	* Clase de manejo de errores
	* oError = Null

	* Objeto error en XML
	* cXMLoError = ""

	*	Flag de estado
	* lIsOk = .T.

	DataSession = 0

	DataSessionId = 0

	* cTierLevel = 'USER'

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="cclasslibraryfolder" type="property" display="cClassLibraryFolder" />] + ;
		[<memberdata name="cclasslibrary" type="property" display="cClassLibrary" />] + ;
		[<memberdata name="cclassname" type="property" display="cClassName" />] + ;
		[<memberdata name="lisok" type="property" display="lIsOk" />] + ;
		[<memberdata name="omainobject" type="property" display="oMainObject" />] + ;
		[<memberdata name="omainobject_access" type="method" display="oMainObject_Access" />] + ;
		[<memberdata name="clear" type="method" display="Clear" />] + ;
		[<memberdata name="new" type="method" display="New" />] + ;
		[<memberdata name="getitem" type="method" display="GetItem" />] + ;
		[<memberdata name="removeitem" type="method" display="RemoveItem" />] + ;
		[<memberdata name="indexon" type="method" display="IndexOn" />] + ;
		[<memberdata name="getmin" type="method" display="GetMin" />] + ;
		[<memberdata name="getmain" type="method" display="GetMain" />] + ;
		[<memberdata name="where" type="method" display="Where" />] + ;
		[<memberdata name="distinct" type="method" display="Distinct" />] + ;
		[<memberdata name="copyto" type="method" display="CopyTo" />] + ;
		[<memberdata name="moveto" type="method" display="MoveTo" />] + ;
		[<memberdata name="topquery" type="method" display="TopQuery" />] + ;
		[<memberdata name="sortby" type="method" display="SortBy" />] + ;
		[<memberdata name="select" type="method" display="Select" />] + ;
		[<memberdata name="getmax" type="method" display="GetMax" />] + ;
		[<memberdata name="bottomquery" type="method" display="BottomQuery" />] + ;
		[<memberdata name="recursive" type="method" display="Recursive" />] + ;
		[<memberdata name="tostring" type="method" display="ToString" />] + ;
		[<memberdata name="reverse" type="method" display="Reverse" />] + ;
		[</VFPData>]

	Procedure AddItem( teItem As Variant, tcKey As String, teBefore As Variant, teAfter As Variant )
		Local lnCnt As Integer

		Try
			lnCnt = Pcount()
			Do Case
				Case lnCnt = 1
					This.Add( m.teItem )

				Case lnCnt = 2
					This.Add( m.teItem, Lower( m.tcKey ))

				Case lnCnt = 3
					This.Add( m.teItem, Lower( m.tcKey ), m.teBefore )

				Case lnCnt = 4
					This.Add( m.teItem, Lower( m.tcKey ), m.teBefore, m.teAfter )

				Otherwise
					This.Add( m.teItem, Lower( m.tcKey ), m.teBefore, m.teAfter )

			Endcase

		Catch To loErr
			THROW_EXCEPTION

		Endtry

	Endproc

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetMain
	*!* Description...: Devuelve el objeto principal en la jerarquía de clases
	*!* Date..........: Martes 3 de Febrero de 2009 (11:57:16)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure GetMain( ) As Object HelpString "Devuelve el objeto principal en la jerarquía de clases"

		Return This.oMainObject.GetMain()

	Endproc && GetMain

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oMainObject_Access
	*!* Date..........: Viernes 6 de Febrero de 2009 (13:32:47)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oMainObject_Access()

		If Vartype( This.oMainObject ) # "O"
			This.oMainObject = Createobject( "SessionBase" )

		Endif

		Return This.oMainObject

	Endproc && oMainObject_Access

	* ValidateKeyOrIndex
	Hidden Function ValidateKeyOrIndex( tvIndex As Variant, tnIndexOut As Integer @ ) As Boolean
		Local lcKey As String
		Local i As Integer
		Local llRet As Boolean
		m.llRet = .T.
		Do Case
			Case Vartype( m.tvIndex ) == "C"
				m.i = This.GetKey( Lower( m.tvIndex ) )

				If ! Empty( m.i )
					m.tnIndexOut = m.i

				Endif && ! Empty( m.i )

			Case Vartype( m.tvIndex ) == "N"
				m.lcKey =  This.GetKey( m.tvIndex )

				If ! Empty( m.lcKey )
					m.tnIndexOut = m.tvIndex

				Endif && ! Empty( m.lcKey )

			Otherwise
				Error "Error de tipo de datos"

		Endcase

		Return m.llRet

	Endfunc && ValidateKeyOrIndex

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetItem
	*!* Description...: Devuelve un elemento de la colección
	*!* Date..........: Martes 3 de Febrero de 2009 (12:57:58)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function GetItem( tvIndex As Variant ) As Object HelpString "Devuelve un elemento de la colección"

		Local loItem As Object
		Local lnIndexOut As Integer
		Try

			m.loItem = Null

			*!*	Do Case
			*!*		Case Vartype( m.tvIndex ) == "C"
			*!*			m.i = This.GetKey( Lower( m.tvIndex ) )

			*!*			If ! Empty( m.i )
			*!*	*!*				m.loItem = This.Item( m.i )

			*!*			Endif && ! Empty( m.i )

			*!*		Case Vartype( m.tvIndex ) == "N"
			*!*			m.lcKey =  This.GetKey( m.tvIndex )

			*!*			If ! Empty( m.lcKey )
			*!*				m.loItem = This.Item( m.tvIndex )

			*!*			Endif && ! Empty( m.lcKey )

			*!*		Otherwise
			*!*			Error "Error de tipo de datos"

			*!*	Endcase

			If This.ValidateKeyOrIndex( m.tvIndex , @lnIndexOut )
				m.loItem = This.Item( m.lnIndexOut )

			Endif && This.ValidateKeyOrIndex( m.tvIndex , @lnIndexOut )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.loItem

	Endfunc && GetItem

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: RemoveItem
	*!* Description...: Elimina un elemento de la colección
	*!* Date..........: Martes 3 de Febrero de 2009 (12:57:58)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function RemoveItem( tvIndex As Variant ) As Object HelpString "Devuelve un elemento de la colección"

		Local loItem As Object
		Local lnIndexOut As Integer
		*!*	Local i As Integer
		*!*	Local lcKey As String

		Try

			m.loItem = Null

			*!*	Do Case
			*!*		Case Vartype( m.tvIndex ) == "C"
			*!*			m.i = This.GetKey( Lower( m.tvIndex  ) )

			*!*			If ! Empty( m.i )
			*!*				m.loItem = This.Remove( m.i )

			*!*			Endif && ! Empty( m.i )

			*!*		Case Vartype( m.tvIndex  ) == "N"
			*!*			m.lcKey =  This.GetKey( m.tvIndex  )

			*!*			If ! Empty( m.lcKey )
			*!*				m.loItem = This.Remove( m.tvIndex  )

			*!*			Endif && ! Empty( m.lcKey )

			*!*		Otherwise
			*!*			Error "Error de tipo de datos"

			*!*	ENDCASE

			If This.ValidateKeyOrIndex( m.tvIndex , @lnIndexOut )
				m.loItem = This.Remove( m.lnIndexOut )

			Endif && This.ValidateKeyOrIndex( m.tvIndex , @lnIndexOut )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.loItem

	Endfunc && RemoveItem

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: New
	*!* Description...: Crea un elemento y lo agrega a la coleccion
	*!* Date..........: Martes 3 de Febrero de 2009 (12:39:44)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function New( tcName As String, tcBefore As String ) As Object HelpString "Crea un elemento y lo agrega a la coleccion"

		Local loItem As Object
		Local lcKey As String

		Try

			If Empty( m.tcName ) Or Vartype( m.tcName ) # "C"
				Error "Error de tipo en el parámetro cName"

			Endif && Empty( m.tcName ) Or Vartype( m.tcName ) # "C"

			m.tcName = Alltrim( m.tcName )

			m.loItem = _NewObject( This.cClassName, Addbs( This.cClassLibraryFolder ) + This.cClassLibrary )

			m.loItem.Name = Proper( m.tcName )
			m.loItem.oParent = This

			m.lcKey = Lower( m.tcName )
			If Empty( m.tcBefore )
				This.AddItem( m.loItem, m.lcKey )

			Else && Empty( m.tcBefore )
				This.AddItem( m.loItem, m.lcKey, Lower( m.tcBefore ) )

			Endif && Empty( m.tcBefore )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.loItem

	Endfunc && New

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Clear
	*!* Description...: Vacía la colección
	*!* Date..........: Martes 3 de Febrero de 2009 (13:11:14)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Clear( ) As Void HelpString "Vacía la colección"

		This.Remove( -1 )

	Endproc && Clear

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Destroy
	*!* Description...:
	*!* Date..........: Martes 3 de Febrero de 2009 (13:22:51)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Destroy( ) As Void

		Try
			This.Remove( - 1 )
			This.oMainObject = Null
			This.oParent = Null
			Unbindevents( This )
			DoDefault()

		Catch To loErr
			THROW_EXCEPTION

		Endtry

	Endproc && Destroy

	*
	* IndexOn
	Procedure IndexOn( tcIndexProperty As String, tlSortDesc As Boolean, tlSkipBackup As Boolean ) As Void;

		Local loColToSort As Collection
		Local loColWrapper As Collection
		Local loBkUpCol As CollectionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"

		Local loObjWrapper As Object
		Local loItem As Object
		*
		Local i As Integer
		Local lnIndex As Integer
		*
		Local lcKey As String
		*
		Local llOk As Boolean
		Local llAdd As Boolean

		Try

			* If Empty( m.tcIndexProperty ) Or Vartype( m.tcIndexProperty ) # 'C'
			If m.String.IsNullOrEmpty( m.tcIndexProperty )
				Error 'Error en el parametro "tcIndexProperty". Se esperaba un String no vacio'

			Endif && Empty( tcIndexProperty )

			m.loColToSort = _NewObject( 'Collection' )
			* BackUp
			If ! m.tlSkipBackup
				m.loBkUpCol = _NewObject( This.Class, This.ClassLibrary )
				This.CopyTo( m.loBkUpCol )

			Endif

			For m.i = 1 To This.Count
				m.loItem = This.Item[ m.i ]
				m.lcKey = This.GetKey( m.i )
				m.lcKeyOrder = Lower( Transform( Getpem( m.loItem,m.tcIndexProperty  ) ) )
				m.loObjWrapper = CreateObjParam( 'oItem', m.loItem, 'cKey', m.lcKey, 'nIndex', m.i )

				* Busco la colección Wrapper
				m.lnIndex = m.loColToSort.GetKey( m.lcKeyOrder )
				If Empty( m.lnIndex )
					m.loColWrapper = _NewObject( 'Collection' )

					* Agrego el elemento a la colección
					m.loColWrapper.Add( m.loObjWrapper )

					* Agrego la colección wrapper en la colección
					m.loColToSort.Add( m.loColWrapper, m.lcKeyOrder )

				Else
					m.loColWrapper = m.loColToSort.Item[ m.lnIndex ]

					* Agrego el elemento a la colección
					m.loColWrapper.Add( m.loObjWrapper )

				Endif

			Endfor

			m.loColToSort.KeySort = Iif( m.tlSortDesc, KEYDESCENDING, KEYASCENDING )
			This.Clear()
			For Each m.loColWrapper In m.loColToSort
				For m.i = 1 To m.loColWrapper.Count
					m.loObjWrapper = m.loColWrapper.Item[ i ]
					This.Add( m.loObjWrapper.oItem, m.loObjWrapper.cKey )

				Endfor

			Endfor

		Catch To loErr
			If ! m.tlSkipBackup
				m.loBkUpCol.MoveTo( This, .T. )
			Endif
			THROW_EXCEPTION

		Finally
			m.loObjWrapper = Null
			m.loItem = Null

			Try
				If ! m.tlSkipBackup
					m.loBkUpCol.Remove( -1 )
				Endif
			Catch To loErr
			Endtry
			Try
				m.loColToSort.Remove( -1 )
			Catch To loErr
			Endtry
			Try
				m.loColWrapper.Remove( -1 )
			Catch To loErr
			Endtry

			m.loColToSort = Null
			m.loColWrapper= Null
			m.loBkUpCol = Null

		Endtry

	Endproc && IndexOn

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetMax
	*!* Description...: Devuelve el objeto cuyo valor de indice alternativo es el mayor
	*!* Date..........: Lunes 6 de Julio de 2009
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*
	* GetMax
	Protected Procedure GetMax( tcIndexProperty As String ) As Integer HelpString "Devuelve el objeto cuyo valor de indice alternativo es el menor"

		Local lnIndex As Integer
		Local lvMaxValue As Variant
		Local lvValue As Variant
		Local i As Integer
		Local loObj As Object

		Try

			If m.String.IsNullOrEmpty( m.tcIndexProperty )
				Error 'Error en el parametro "tcIndexProperty". Se esperaba un String no vacio'

			Endif && m.String.IsNullOrEmpty( m.tcIndexProperty )

			m.lnIndex = 0

			If This.Count > 1
				m.loObj = This.Item( 1 )
				m.lnIndex = 1
				If Pemstatus( m.loObj, m.tcIndexProperty, 5 )
					* m.lvMaxValue = Evaluate( "loObj." + m.tcIndexProperty )
					m.lvMaxValue = Getpem( m.loObj, m.tcIndexProperty )

				Endif && Pemstatus( loObj, tcIndexProperty, 5 )

				For m.i = 1 To This.Count
					m.loObj = This.Item( m.i )

					If Pemstatus( m.loObj, m.tcIndexProperty, 5 )
						m.lvValue = Evaluate( "loObj." + m.tcIndexProperty )
						m.lvValue = Getpem( m.loObj, m.tcIndexProperty )

						If m.lvValue > m.lvMaxValue
							m.lvMaxValue = m.lvValue
							m.lnIndex = m.i

						Endif && m.lvValue < m.lvMaxValue

					Endif && Pemstatus( m.loObj, m.tcIndexProperty, 5 )

				Endfor

			Endif && This.Count > 1

		Catch To loErr
			THROW_EXCEPTION

		Finally
			m.loObj = Null

		Endtry

		Return m.lnIndex

	Endproc && GetMax

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: GetMin
	*!* Description...: Devuelve el objeto cuyo valor de indice alternativo es el mayor
	*!* Date..........: Lunes 6 de Julio de 2009
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Protected Procedure GetMin( tcIndexProperty As String ) As Integer HelpString "Devuelve el objeto cuyo valor de indice alternativo es el menor"

		Local lnIndex As Integer
		Local lvMinValue As Variant
		Local lvValue As Variant
		Local i As Integer
		Local loObj As Object

		Try

			If m.String.IsNullOrEmpty( m.tcIndexProperty )
				Error 'Error en el parametro "tcIndexProperty". Se esperaba un String no vacio'

			Endif && m.String.IsNullOrEmpty( m.tcIndexProperty )

			m.lnIndex = 0

			If This.Count > 1
				m.loObj = This.Item( 1 )
				m.lnIndex = 1
				If Pemstatus( loObj, m.tcIndexProperty, 5 )
					* m.lvMinValue = Evaluate( "loObj." + m.tcIndexProperty )
					m.lvMinValue = Getpem( m.loObj, m.tcIndexProperty )

				Endif && Pemstatus( m.loObj, m.tcIndexProperty, 5 )

				For m.i = 1 To This.Count
					m.loObj = This.Item( m.i )

					If Pemstatus( m.loObj, m.tcIndexProperty, 5 )
						* m.lvValue = Evaluate( "loObj." + m.tcIndexProperty )
						m.lvValue = Getpem( m.loObj, m.tcIndexProperty )

						If m.lvValue < m.lvMinValue
							m.lvMinValue = m.lvValue
							m.lnIndex = m.i

						Endif && m.lvValue < m.lvMinValue

					Endif && Pemstatus( m.loObj, m.tcIndexProperty, 5 )

				Endfor

			Endif && This.Count > 1

		Catch To loErr
			THROW_EXCEPTION

		Finally
			m.loObj = Null

		Endtry

		Return m.lnIndex

	Endproc && GetMin

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: oParent_Assign
	*!* Date..........: Martes 3 de Febrero de 2009 (11:52:35)
	*!* Author........: Ricardo Aidelman
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure oParent_Assign( toParent As Object )

		If Vartype( m.toParent ) # "O"
			m.toParent = Null

		Endif && Vartype( m.toParent ) # "O"

		This.oParent = m.toParent

	Endproc && oParent_Assign

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Where
	*!* Description...: Devuelve un sub conjunto de la colección
	*!* Date..........: Lunes 6 de Julio de 2009 (18:54:49)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Where( tvColFilters As Variant, tlSetExact As Boolean ) As CollectionBase Of Tools\NameSpaces\Prg\baselibrary.Prg HelpString "Devuelve un sub conjunto de la colección"

		Local loRet As Object
		Local loItem As Object
		Local llOk As Boolean
		Local loFilter As oFilter Of
		Local lcKey As String
		Local lcField As String
		Local lcOperator As String
		Local lcExpr As String
		Local lcSetExact As String
		Local llIsString As Boolean
		Local lcClassAnt As String
		* Local loMainObject As SessionBase Of "NameSpaces\Prg\BaseLibrary.prg"

		Try
			m.lcSetExact = Set( "Exact" )
			If m.tlSetExact
				Set Exact On

			Else
				Set Exact Off

			Endif && m.tlSetExact

			*!*	loMainObject = This.oMainObject
			m.loRet = _NewObject( This.Class, This.ClassLibrary )

			m.llIsString = ( Vartype( m.tvColFilters ) = 'C' )
			If m.llIsString And ( This.Count > 0 )
				m.loItem = This.Item( 1 )
				m.lcKey = This.GetKey( 1 )
				* m.lcExpr =  loMainObject.ProcessClause( m.tvColFilters, m.loItem, 'loItem.' )
				m.lcExpr = m.String.ProcessClause( m.tvColFilters, m.loItem, 'loItem.' )
				m.lcClassAnt = Lower( m.loItem.Class )
				*!*	If .F. && DAE 2009-10-22
				*!*		loError.TraceLogin = 'Evaluando ' + lcKey + Chr( 13 ) ;
				*!*			+ m.String.StringBuilder( 'item: {1} class: {2} exp: {3}', loItem.Name, loItem.Class, lcExpr )
				*!*		* + printf( 'item: %s class: %s exp: %s', loItem.Name, loItem.Class, lcExpr )

				*!*	Endif && .F. && DAE 2009-10-22
			Endif && llIsString and This.Count > 0
			For m.i = 1 To This.Count
				m.loItem = This.Item( m.i )
				m.lcKey = This.GetKey( m.i )
				* loError.TraceLogin = 'Evaluando ' + lcKey
				m.llOk = .T.
				If m.llIsString
					*!*	If .F. && DAE 2009-10-22
					*!*		If lcClassAnt # Lower( loItem.Class )
					*!*			lcExpr = loMainObject.ProcessClause( tvColFilters, loItem, 'loItem.' )
					*!*			lcClassAnt = Lower( loItem.Class )
					*!*			loError.TraceLogin = loError.TraceLogin + Chr( 13 ) ;
					*!*				+ m.String.StringBuilder( 'item: {1} class: {2} exp: {3}', loItem.Name, loItem.Class, lcExpr )
					*!*			* + printf( 'item: %s class: %s exp: %s', loItem.Name, loItem.Class, lcExpr )


					*!*		Endif && lcClassAnt # Lower( loItem.Class )
					*!*	Endif && .F. && DAE 2009-10-22
					m.llOk = m.llOk And Evaluate( m.lcExpr )

				Else
					For Each m.loFilter In m.tvColFilters
						* lcExpr = [loItem.] + loFilter.cField + loFilter.cOperator + loFilter.cExpr
						m.lcExpr = Strtran( m.loFilter.cFieldExp, '<#FIELD#>', 'loItem.' + m.loFilter.cField ) + m.loFilter.cOperator + m.loFilter.cExpr
						*!*	loError.TraceLogin = loError.TraceLogin + Chr( 13 ) + lcExpr
						m.llOk = m.llOk And Evaluate( m.lcExpr )

					Endfor

				Endif && m.llIsString
				If m.llOk
					If Empty( m.lcKey ) And Vartype( m.loItem ) == 'O' And Pemstatus( m.loItem, 'Name', 5 )
						m.lcKey = Lower( m.loItem.Name )

					Endif && Empty( m.lcKey ) And Vartype( m.loItem ) == 'O' And Pemstatus( m.loItem, 'Name', 5 )

					m.loRet.AddItem( m.loItem, m.lcKey )

				Endif && m.llOk

			Endfor

		Catch To loErr
			THROW_EXCEPTION

		Finally
			m.loItem = Null

			Set Exact &lcSetExact

		Endtry

		Return m.loRet

	Endproc && Where

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Distinct
	*!* Description...:
	*!* Date..........: Viernes 17 de Julio de 2009 (16:36:26)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure Distinct( tcProperty As String, tlSkipBackup As Boolean ) As Void

		Local loBkUpCol As CollectionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"
		Local loColDuplicates As CollectionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"
		Local loCol As CollectionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"
		Local loItem As Object

		Try

			If m.String.IsNullOrEmpty( m.tcProperty )
				Error 'Error en el parametro "tcProperty ". Se esperaba un String no vacio'

			Endif && Empty( tcProperty )

			m.loColDuplicates = _NewObject( "CollectionBase", "PrxBaseLibrary.prg" )
			m.loCol = _NewObject( "CollectionBase", "PrxBaseLibrary.prg" )
			If ! m.tlSkipBackup
				m.loBkUpCol = _NewObject( This.Class, This.ClassLibrary )
				This.CopyTo( m.loBkUpCol )
			Endif && m.tlSkipBackup

			For m.i = 1 To This.Count
				m.loItem = This.Item( m.i )
				Try
					If Vartype( m.loItem ) = 'O' And Pemstatus( m.loItem, m.tcProperty, 5 )
						m.loCol.AddItem( Getpem( m.loItem, m.tcProperty ), Getpem( m.loItem, m.tcProperty ) )

					Endif && Vartype( loItem ) = 'O' And Pemstatus( loItem, tcProperty, 5 )

				Catch To loErr
					m.loColDuplicates.AddItem( m.i )

				Endtry

			Endfor

			For m.i = m.loColDuplicates.Count To 1 Step - 1
				This.Remove( m.loColDuplicates.Item ( m.i ) )

			Endfor

		Catch To loErr
			If ! m.tlSkipBackup
				Try
					m.loBkUpCol.MoveTo( This, .T. )
				Catch To loErr
				Endtry
			Endif && ! m.tlSkipBackup
			THROW_EXCEPTION

		Finally
			If ! m.tlSkipBackup
				m.loBkUpCol.Remove( - 1 )
				m.loBkUpCol = Null
			Endif && ! m.tlSkipBackup

			m.loColDuplicates.Remove( - 1 )
			m.loColDuplicates = Null

			m.loCol.Remove( - 1 )
			m.loCol = Null

			m.loItem = Null

		Endtry

	Endproc && Distinct

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: CopyTo
	*!* Description...: Copia la colección a la colección destino
	*!* Date..........: Domingo 2 de Agosto de 2009 (16:24:30)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure CopyTo( toCol As Object, tlCLearDest As Boolean, tlCLearOrig As Boolean ) As Void HelpString "Copia la colección a la colección destino"

		Try

			If m.tlCLearDest
				m.toCol.Remove( - 1 )

			Endif && m.tlCLear

			For m.i = 1 To This.Count
				m.loObj = This.Item( m.i )
				m.lcKey = This.GetKey( m.i )
				If Empty( m.lcKey ) And Vartype( m.loObj ) == 'O' And Pemstatus( m.loObj, 'Name', 5 )
					m.lcKey = Lower( m.loObj.Name )

				Endif && Empty( m.lcKey ) And Vartype( m.loObj ) == 'O' And Pemstatus( m.loObj, 'Name', 5 )

				m.toCol.AddItem( m.loObj, m.lcKey )

			Endfor

			If m.tlCLearOrig
				This.Remove( - 1 )

			Endif

		Catch To loErr
			THROW_EXCEPTION

		Endtry

	Endproc && CopyTo

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: MoveTo
	*!* Description...: Mueve los datos de la colección a la colección destino
	*!* Date..........: Domingo 2 de Agosto de 2009 (16:24:30)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Procedure MoveTo( toCol As Collection, tlCLearDest As Boolean ) As Void HelpString "Copia la colección a la colección destino"

		Try

			This.CopyTo( m.toCol, m.tlCLearDest, .T. )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

	Endproc && MoveTo

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: TopQuery
	*!* Description...:
	*!* Date..........: Domingo 2 de Agosto de 2009 (16:58:40)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function TopQuery( tnTop As Number, tlPercent As Boolean, tlInvert As Boolean ) As CollectionBase Of Tools\NameSpaces\Prg\baselibrary.Prg

		Local loColRet As CollectionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"
		Local lnTop As Number

		Try

			If This.ValidateTop( m.tnTop, m.tlPercent, @lnTop )

				m.lnTop = Min( m.lnTop, This.Count )

				m.loColRet = This.GetTop( 1, m.lnTop, 1 )

				If m.tlInvert
					m.loColRet = m.loColRet.Reverse()

				Endif && m.tlInvert

			Endif

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endproc && TopQuery

	* SkipQuery
	Function SkipQuery( tnTop As Number, tlPercent As Boolean, tlInvert As Boolean ) As CollectionBase Of Tools\NameSpaces\Prg\baselibrary.Prg

		Local loColRet As CollectionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"
		Local lnTop As Number

		Try
			If m.tlPercent
				m.tnTop = Max( 100 - m.tnTop, 0 )

			Else
				m.tnTop = Max( This.Count - m.tnTop, 0 )

			Endif && m.tlPercent

			If This.ValidateTop( m.tnTop, m.tlPercent, @lnTop )

				m.lnTop = Min( m.lnTop, This.Count )

				m.loColRet = This.GetTop( 1, m.lnTop, -1 )

				If m.tlInvert
					m.loColRet = m.loColRet.Reverse()

				Endif && m.tlInvert

			Endif

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endproc && SkipQuery

	Hidden Function GetTop( tnStart As Integer, tnTop As Integer, tnStep As Integer )
		Local loObj As Object
		Local lcKey As String
		Local i As Integer

		m.loColRet = _NewObject( This.Class, This.ClassLibrary )
		For m.i = m.tnStart  To m.tnTop Step m.tnStep
			m.loObj = This.Item( m.i )
			m.lcKey = This.GetKey( m.i )
			If Empty( m.m.lcKey ) And Vartype( m.loObj ) = 'O' And Pemstatus( m.loObj, 'Name', 5 )
				m.lcKey = Lower( m.loObj.Name )

			Endif && Empty( m.lcKey ) And Pemstatus( m.loObj, 'Name', 5 )

			m.loColRet.AddItem( m.loObj, m.lcKey )

		Endfor

		Return m.loColRet

	Endfunc

	* ValidateTop
	Hidden Function ValidateTop(tnTop As Number, tlPercent As Boolean, tnTopOut As Integer @ ) As Boolean
		Local llRest As Boolean
		m.llRest = .T.
		Do Case
			Case Vartype( m.tnTop ) # 'N'
				Error 9 && Data type mismatch

			Case m.tnTop < 1
				* tnTop = This.Count
				Error 'Zero or negative used as argument.'

			Otherwise
				If m.tlPercent And m.tnTop > 100
					Error 'Invalid TOP specification'

				Endif && tlPercent And tnTop > 100

		Endcase

		If m.tlPercent
			m.tnTopOut = m.tnTop * This.Count / 100

		Else
			m.tnTopOut = m.tnTop

		Endif && m.tlPercent

		Return m.llRest

	Endfunc

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Top
	*!* Description...:
	*!* Date..........: Domingo 12 de Agosto de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function BottomQuery( tnTop As Number, tlPercent As Boolean, tlInvert As Boolean ) As CollectionBase Of Tools\NameSpaces\Prg\baselibrary.Prg

		Local loColRet As CollectionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"
		Local lnTop As Number

		Try
			If This.ValidateTop( m.tnTop, m.tlPercent, @lnTop )

				m.lnTop = Max( Min( m.lnTop, This.Count ), 1 )

				m.loColRet = This.GetTop( m.lnTop, 1, -1 )

				If m.tlInvert
					m.loColRet = m.loColRet.Reverse()

				Endif && m.tlInvert

			Endif

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endproc && BottomQuery

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: SortBy
	*!* Description...:
	*!* Date..........: Domingo 2 de Agosto de 2009 (17:26:38)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function SortBy( tvSortBy As Variant ) As CollectionBase Of Tools\NameSpaces\Prg\baselibrary.Prg HelpString "Devuelve una colección ordenada según los parametros"


		Local llIsString As Boolean
		Local lcExp As String
		Local lcExp2 As String
		Local lnOccurs As Integer
		Local llSortDesc As Boolean
		Local loColRet As CollectionBase Of Tools\NameSpaces\Prg\baselibrary.Prg
		Local i As Integer

		Try
			m.llIsString = ( Vartype( m.tvSortBy ) = 'C' )
			m.loColRet = _NewObject( This.Class, This.ClassLibrary )
			This.CopyTo( m.loColRet )

			If m.llIsString
				* tvSortBy = Alltrim( tvSortBy )
				m.lnOccurs = Getwordcount( m.tvSortBy, ',' )
				For m.i = m.lnOccurs To 1 Step -1
					m.llSortDesc = .F.
					m.lcExp = Getwordnum( m.tvSortBy, i, ',' )
					If Getwordcount( m.lcExp ) > 1
						m.lcExp2 = Alltrim( Getwordnum( m.lcExp, 2) )
						m.lcExp2 = Left( Lower( lcExp2 ), 3 )
						m.llSortDesc = (  m.lcExp2 == 'des' )

					Endif && Getwordcount( m.lcExp ) > 1

					m.loColRet.IndexOn( Getwordnum( m.lcExp, 1 ), m.llSortDesc )

				Endfor
			Else
				Error 'No implementado'

			Endif && llIsString

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endproc && SortBy

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Select
	*!* Description...: Devuelve una colección de objetos nuevos con propiedades
	*!* 				selecionadas de los elementos de la colección
	*!* Date..........: Domingo 2 de Agosto de 2009 (17:46:25)
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Select( tvSelect As Variant  ) As CollectionBase Of Tools\NameSpaces\Prg\baselibrary.Prg HelpString "Devuelve una colección de objetos nuevos con propiedades selecionadas de los elementos de la colección"

		Local llIsString As Boolean
		Local loColRet As CollectionBase Of Tools\NameSpaces\Prg\baselibrary.Prg
		Local loObj As Object
		Local lcKey As String
		Local loNewObj As Object
		Local lcExp As String

		Try
			m.loColRet = _NewObject( This.Class, This.ClassLibrary )
			* Assert tvSelect Message 'No se recibio ningún parametro'
			m.llIsString = ( Vartype( m.tvSelect ) = 'C' ) Or Pcount() = 0

			If m.llIsString
				If Empty( m.tvSelect )
					m.tvSelect = '*'

				Endif
				m.tvSelect = Alltrim( m.tvSelect )
				If m.tvSelect = '*'
					This.CopyTo( m.loColRet )

				Else

					For m.i = 1 To This.Count
						m.loObj = This.Item( m.i )
						m.lcKey = This.GetKey( m.i )
						m.loNewObj = Createobject( 'Empty' )
						For m.j = 1 To Getwordcount( m.tvSelect, ',' )
							m.lcExp = Getwordnum( m.tvSelect, j, ',' )
							m.lcExp = Strtran( m.lcExp, Space( 2 ), Space( 1 ) )
							m.lcExp = Strtran( m.lcExp, '(' + Space( 1 ), '(' )
							m.lcExp = Strtran( m.lcExp, Space( 1 ) + ')', ')' )
							m.lcProp = Getwordnum( m.lcExp, 1 )
							m.lcExpProp = This.oMainObject.ProcessClause( m.lcProp, @loObj, 'loObj.' )

							If Getwordcount( m.lcExp ) > 1
								m.lcPropAlias = Alltrim( Getwordnum( m.lcExp, 2 )  )

							Else
								m.lcPropAlias = Alltrim( m.lcProp )

							Endif && GetWordCount( m.lcExp ) > 1

							AddProperty( m.loNewObj, m.lcPropAlias,	&lcExpProp. )

						Endfor
						If Empty( m.lcKey ) And Vartype( m.loObj ) = 'O' And Pemstatus( m.loObj, 'Name', 5 )
							m.lcKey = Lower( m.loObj.Name )

						Endif && Empty( m.lcKey ) And Pemstatus( m.loObj, 'Name', 5 )
						m.loColRet.AddItem( m.loNewObj, m.lcKey )

					Endfor

				Endif && m.tvSelect = '*'

			Else
				Error 'No implementado'

			Endif && m.llIsString

		Catch To loErr
			THROW_EXCEPTION

		Finally
			m.loObj = Null
			m.loNewObj = Null

		Endtry

		Return m.loColRet

	Endfunc && Select

	* @TODO Damian Eiff 2009-08-01 (01:30:17) Proc Query

	*
	* Query
	Procedure Query( tcDistinct As String, tnTop As Number, tlPercent As Boolean, tcSelect As String, tcWhere As String, tlSetExact As Boolean, tcSortBy As String ) As CollectionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"

		Local loColRet As CollectionBase Of "Tools\Namespaces\Prg\BaseLibrary.prg"
		Try
			If ! Empty( m.tcWhere )
				m.loColRet = This.Where( m.tcWhere, m.tlSetExact )

			Else
				m.loColRet = This

			Endif && ! Empty( m.tcWhere )

			If ! Empty( m.tcDistinct )
				m.loColRet = m.loColRet.Distinct( m.tcDistinct )

			Endif && ! Empty( m.tcDistinct )

			If ! Empty( m.tcSortBy )
				m.loColRet = m.loColRet.SortBy( m.tcSortBy )

			Endif && ! Empty( m.tcSortBy )

			If ! Empty( m.tnTop )
				m.loColRet = m.loColRet.TopQuery( m.tnTop, m.tlPercen )

			Endif && ! Empty( m.tnTop )

			If ! Empty( m.tcSelect )
				m.loColRet = m.loColRet.Select( m.tcSelect )

			Endif &&  ! Empty( m.tcSelect )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endproc && Query

	Procedure ToString( tcTemplate As String, tcSeparador As String, tcWhere As String ) As String

		Local i As Integer
		Local lnCount As Integer
		*
		Local lcString As String
		Local lcExpresion As String
		Local lcExp As String
		*
		Local loItem As Object

		Try

			m.lcString = ""

			If Empty( m.tcSeparador ) Or Vartype( m.tcSeparador ) # "C"
				m.tcSeparador = ","

			Endif

			If Empty( m.tcTemplate ) Or Vartype( m.tcTemplate ) # "C"
				m.tcTemplate = ""

			Endif

			If Empty( m.tcWhere )
				m.loCol = This

			Else
				m.loCol = This.Where( m.tcWhere )

			Endif && m.tcWhere

			m.lnCount = m.loCol.Count

			For m.i = 1 To m.lnCount
				* loItem = loCol.Item( i )
				m.loItem = m.loCol.Item[ m.i ]
				If Vartype( m.loItem ) = 'O'
					If Pemstatus( m.loItem, 'ToString', 5 )
						m.lcString = m.lcString + m.loItem.ToString( m.tcTemplate )

					Else && Pemstatus( m.loItem, 'ToString', 5 )
						m.lcExp = m.String.ProcessClause( m.tcTemplate, m.loItem, 'loItem.' )
						m.loItem = m.loCol.Item[ m.i ]
						* m.lcString = m.lcString + Evaluate( m.lcExp )
						TEXT To m.lcString NoShow TextMerge Additive
						<<Evaluate( m.lcExp )>>
						ENDTEXT

					Endif && Pemstatus( m.loItem, 'ToString', 5 )

					If m.i # m.lnCount
						m.lcString = m.lcString + m.tcSeparador

					Endif && m.i # m.lnCount

				Endif &&  Vartype( m.loItem ) = 'O'

			Endfor

		Catch To loErr
			THROW_EXCEPTION

		Finally
			m.loCol = Null
			m.loItem = Null

		Endtry

		Return m.lcString

	Endproc && ToString

	*
	* Recorre la colección ejecutando un comando para cada elemento
	Procedure Recursive( toCol As Collection, tcPropertieOrMethod As String, tcMethodToCall As String, 			tvParam As Variant, 			tcEndCondition As String, 			tcItemEndCondition As String, 			tlDescending As Boolean ) As Boolean 			HelpString "Recorre la colección ejecutando un comando para cada elemento"

		#If .F.
			TEXT
			*:Help Documentation
			*:Topic:
			*:Description:
			Recorre la colección ejecutando un comando para cada elemento
			*:Project:
			Sistemas Praxis
			*:Autor:
			Damian Eiff
			*:Date:
			Miércoles 12 de Agosto de 2009
			*:ModiSummary:
			*:Syntax:
			*:Example:
			*:Events:
			*:NameSpace:
			praxis.com
			*:Keywords:
			*:Implements:
			*:Inherits:
			*:Parameters:
			toCol As Collection
			tcPropertieOrMethod As String
			tcMethodToCall As String
			tvParam As Variant
			tcEndCondition As String
			tcItemEndCondition As String
			tlDescending As Boolean
			*:Remarks:
			*:Returns:
			Boolean
			*:Exceptions:
			*:SeeAlso:
			*:EndHelp
			ENDTEXT
		#Endif

		Local loItem As Object
		Local i As Integer
		Local lcEndCondition As String
		Local lcItemEndCondition As String

		Try

			If Vartype( m.toCol ) # "O"
				m.toCol = This

			Endif && Vartype( m.toCol ) = "O"

			If Empty( m.tcEndCondition )
				m.tcEndCondition = '.F.'

			Endif && Empty( m.tcEndCondition )

			If Empty( m.tcItemEndCondition )
				m.tcItemEndCondition = '.F.'

			Endif && Empty( m.tcEndCondition )

			If ! Empty( m.tcPropertieOrMethod )

				* m.lcEndCondition = This.ProcessClause( m.tcEndCondition, This, 'This.' )
				m.lcEndCondition = m.String.ProcessClause( m.tcEndCondition, This, 'This.' )

				If ! Evaluate( m.lcEndCondition )

					If m.toCol.Count > 0
						m.i = 1

						m.loItem = toCol.Item( 1 )
						* m.lcItemEndCondition = This.ProcessClause( m.tcItemEndCondition, m.loItem, 'loItem.' )
						m.lcItemEndCondition = m.String.ProcessClause( m.tcItemEndCondition, m.loItem, 'loItem.' )
						Do While m.i <= m.toCol.Count And ! Evaluate( m.lcItemEndCondition )
							m.loItem = m.toCol.Item( m.i )
							* m.lcItemEndCondition = This.ProcessClause( m.tcItemEndCondition, m.loItem, 'loItem.' )
							m.lcItemEndCondition = m.String.ProcessClause( m.tcItemEndCondition, m.loItem, 'loItem.' )

							If Vartype( m.loItem ) == 'O'
								If m.tlDescending
									If Pemstatus( m.loItem, m.tcPropertieOrMethod, 5 )
										* This.Recursive( m.loItem.&tcPropertieOrMethod., m.tcPropertieOrMethod, m.tcMethodToCall, m.tvParam, m.tcEndCondition, m.tcItemEndCondition, m.tlDescending )
										This.Recursive( Getpem( m.loItem, m.tcPropertieOrMethod ), m.tcPropertieOrMethod, m.tcMethodToCall, m.tvParam, m.tcEndCondition, m.tcItemEndCondition, m.tlDescending )

									Endif && Pemstatus( m.loItem, m.tcPropertieOrMethod, 5 )

								Endif && m.tlDescending

								This.&tcMethodToCall.( m.loItem, m.tvParam )

								If ! m.tlDescending
									If Pemstatus( m.loItem, m.tcPropertieOrMethod, 5 )
										* This.Recursive( m.loItem.&tcPropertieOrMethod., m.tcPropertieOrMethod, m.tcMethodToCall, m.tvParam, m.tcEndCondition, m.tcItemEndCondition, m.tlDescending )
										This.Recursive( Getpem( m.loItem, m.tcPropertieOrMethod ), m.tcPropertieOrMethod, m.tcMethodToCall, m.tvParam, m.tcEndCondition, m.tcItemEndCondition, m.tlDescending )

									Endif && Pemstatus( m.loItem, m.tcPropertieOrMethod, 5 )

								Endif && ! m.tlDescending

							Endif && Vartype( m.loItem ) = 'O'

							m.i = m.i + 1

						Enddo

					Endif && m.toCol.Count > 0

				Endif && ! Evaluate( m.lcEndCondition )

			Endif && ! Empty( m.tcPropertieOrMethod )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return .T.

	Endproc && Recursive

	*!* ///////////////////////////////////////////////////////
	*!* Procedure.....: Reverse
	*!* Description...:
	*!* Date..........: Miercoles 12 de Agosto de 2009
	*!* Author........: Damian Eiff
	*!* Project.......: Sistemas Praxis
	*!* -------------------------------------------------------
	*!* Modification Summary
	*!* R/0001  -
	*!*
	*!*

	Function Reverse() As CollectionBase Of Tools\NameSpaces\Prg\baselibrary.Prg
		Local loColRet As Collection

		Try

			m.loColRet = This.GetTop( This.Count, 1, -1 )

		Catch To loErr
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endproc && Reverse

	* Error
	Procedure xxxError(tnError As Number, tcMethod As String, tnLine As Number) As Void
		Local lcMsg As String

		TEXT TO m.lcMsg TEXTMERGE NOSHOW PRETEXT 15
			Name: <<This.Name>> Class: <<This.Class>> ClassLibrary: <<This.ClassLibrary>> Method: <<m.tcMethod>> Error: <<m.tnError>> Line: <<m.tnLine>> Message: <<Message()>>
		ENDTEXT

		Comreturnerror( m.lcMsg , _vfp.ServerName )
		&& this line is never executed

	Endproc && Error

Enddefine && CollectionBase
