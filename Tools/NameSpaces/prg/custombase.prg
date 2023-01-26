#include 'Tools\namespaces\include\foxpro.h'
#Include 'Tools\namespaces\include\system.h'

#If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
	Do 'Tools\namespaces\prg\StringNamespace.prg'
#Endif

* CustomBase
Define Class CustomBase As ObjectBase Of Tools\namespaces\prg\ObjectNamespace.prg

	#If .F.
		Local This As CustomBase Of Tools\namespaces\prg\CustomBase.prg
	#Endif

	#If .F.
		TEXT
		 *:Help Documentation
		 *:Project:
		 Sistemas Praxis
		 *:Autor:
		 Damian Eiff
		 *:Date:
		 Lunes 26 de OCtubre de 2009
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

	DataSessionId = Set ('Datasession')

	*!* Referencia al objeto Parent
	oParent = Null

	_instanceId = Sys ( 2015 )

	* Flag
	lOnDestroy = .F.

	* Valor de la DataSessionId original
	nOldDataSessionId = 0

	* Carpeta de inicio
	cRootFolder = ""

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="oparent" type="property" display="oParent" />] + ;
		[<memberdata name="oparent_assign" type="method" display="oParent_Assign" />] + ;
		[<memberdata name="londestroy" type="property" display="lOnDestroy" />] + ;
		[<memberdata name="nolddatasessionid" type="property" display="nOldDataSessionId" />] + ;
		[<memberdata name="amembers" type="method" display="Amembers" />] + ;
		[<memberdata name="classafterinitialize" type="method" display="ClassAfterInitialize" />] + ;
		[<memberdata name="classbeforeinitialize" type="method" display="ClassBeforeInitialize" />] + ;
		[<memberdata name="getmain" type="method" display="GetMain" />] + ;
		[<memberdata name="hookafterinitialize" type="method" display="HookAfterInitialize" />] + ;
		[<memberdata name="hookbeforeinitialize" type="method" display="HookBeforeInitialize" />] + ;
		[<memberdata name="initialize" type="method" display="Initialize" />] + ;
		[<memberdata name="processclause" type="method" display="ProcessClause" />] + ;
		[<memberdata name="pemstatus" type="method" display="PemStatus" />] + ;
		[<memberdata name="tostring" type="method" display="ToString" />] + ;
		[<memberdata name="crootfolder" type="property" display="cRootFolder" />] + ;
		[</VFPData>]

	Dimension Amembers_COMATTRIB[ 5 ]
	Amembers_COMATTRIB[ 1 ] = 0
	Amembers_COMATTRIB[ 2 ] = 'Devuelve la cantidad de elemento que tiene el array miembros solicitados devuelto por referencia.'
	Amembers_COMATTRIB[ 3 ] = 'Amembers'
	Amembers_COMATTRIB[ 4 ] = 'Integer'
	* Amembers_COMATTRIB[ 5 ] = 0

	* Amembers
	* Devuelve la cantidad de elemento que tiene el array miembros solicitados devuelto por referencia.
	Procedure Amembers ( tvAmembers As Variant @, tnArrayContentsId As Integer ) As Integer HelpString 'Devuelve la cantidad de elemento que tiene el array miembros solicitados devuelto por referencia.'

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

			lnMax = Amembers ( tvAmembers, This, m.tnArrayContentsId )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvAmembers, tnArrayContentsId
			THROW_EXCEPTION

		Endtry

		Return m.lnMax

	Endproc && AMembers

	* ClassAfterInitialize
	Protected Procedure ClassAfterInitialize ( tvParam As Variant )
	Endproc && ClassAfterInitialize

	* ClassBeforeInitialize
	Protected Function ClassBeforeInitialize ( tvParam As Variant )
		Return .T.
	Endfunc && ClassBeforeInitialize

	* Destroy
	Protected Procedure Destroy() As Void

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
			If ! This.lOnDestroy
				This.lOnDestroy = .T.
				If !Empty ( This.nOldDataSessionId )
					This.DataSessionId = This.nOldDataSessionId

				Endif

				Unbindevents ( This )

				DoDefault()

			Endif && ! This.lOnDestroy

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

	Endproc && Destroy

	Dimension GetMain_COMATTRIB[ 5 ]
	GetMain_COMATTRIB[ 1 ] = 0
	GetMain_COMATTRIB[ 2 ] = 'Devuelve el objeto principal en la jerarquía de clases.'
	GetMain_COMATTRIB[ 3 ] = 'GetMain'
	GetMain_COMATTRIB[ 4 ] = 'Object'
	* GetMain_COMATTRIB[ 5 ] = 0

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

			Else
				loMain = This

			Endif

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.loMain

	Endproc && GetMain

	* HookAfterInitialize
	Procedure HookAfterInitialize ( tvParam As Variant )
	Endproc && HookAfterInitialize

	* HookBeforeInitialize
	Function HookBeforeInitialize ( tvParam As Variant )
		Return .T.
	Endfunc && HookBeforeInitialize

	* Init
	Procedure Init()
		If DoDefault()
			This.nOldDataSessionId = This.DataSessionId
			Return .T.
		Else

			Return .F.
		Endif

	Endproc && Init

	Dimension Initialize_COMATTRIB[ 5 ]
	Initialize_COMATTRIB[ 1 ] = 0
	Initialize_COMATTRIB[ 2 ] = 'Devuelve .T. si el proceo de inicilizacion termino correctamente.'
	Initialize_COMATTRIB[ 3 ] = 'Initialize'
	Initialize_COMATTRIB[ 4 ] = 'Boolean '
	* Initialize_COMATTRIB[ 5 ] = 0

	* Initialize
	* Devuelve .T. si el proceo de inicilizacion termino correctamente.
	Function Initialize ( tvParam As Variant ) As Boolean HelpString 'Devuelve .T. si el proceo de inicilizacion termino correctamente.'

		Local loErr As Exception,;
			llRet As Boolean

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
			llRet = .F.
			If This.ClassBeforeInitialize ( m.tvParam )
				If This.HookBeforeInitialize ( m.tvParam )
					This.HookAfterInitialize ( m.tvParam )
					This.ClassAfterInitialize ( m.tvParam )
					llRet = .T.

				Endif && This.HookBeforeInitialize( m.tvParam )

			Endif && This.ClassBeforeInitialize( m.tvParam )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvParam
			THROW_EXCEPTION

		Endtry

		Return llRet

	Endfunc && Initialize

	*!*	* oParent_Assign
	*!*	Protected Procedure oParent_Assign ( toParent As Object )

	*!*		#If .F.
	*!*			TEXT
	*!*			 *:Help Documentation
	*!*			 *:Project:
	*!*			 Sistemas Praxis
	*!*			 *:Autor:
	*!*			 Ricardo Aidelman
	*!*			 *:Date:
	*!*			 Martes 3 de Febrero de 2009 (11:52:35)
	*!*			 *:ModiSummary:
	*!*			 R/0001 -
	*!*			 *:Parameters:
	*!*			 *:Remarks:
	*!*			 *:Returns:
	*!*			 *:Example:
	*!*			 *:SeeAlso:
	*!*			 *:Events:
	*!*			 *:KeyWords:
	*!*			 *:Inherits:
	*!*			 *:Exceptions:
	*!*			 *:NameSpace:
	*!*			 digitalizarte.com
	*!*			 *:EndHelp
	*!*			ENDTEXT
	*!*		#Endif

	*!*		If Vartype ( m.toParent ) # 'O'
	*!*			toParent = Null

	*!*		Endif && Vartype ( m.toParent ) # 'O'

	*!*		This.oParent = m.toParent

	*!*	Endproc && oParent_Assign

	Dimension Pemstatus_COMATTRIB[ 5 ]
	Pemstatus_COMATTRIB[ 1 ] = 0
	Pemstatus_COMATTRIB[ 2 ] = 'Devuelve la información solicitada para el estado de la propiedad dada.'
	Pemstatus_COMATTRIB[ 3 ] = 'Pemstatus'
	Pemstatus_COMATTRIB[ 4 ] = 'Variant'
	* Pemstatus_COMATTRIB[ 5 ] = 0

	* Pemstatus
	* Devuelve la información solicitada para el estado de la propiedad dada.
	Procedure Pemstatus ( tcProperty As String, tnAttribute As Integer ) As Variant HelpString 'Devuelve la información solicitada para el estado de la propiedad dada.'

		Local loErr As Object, ;
			lvRet As Variant

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

	Endproc && PemStatus

	Dimension ProcessClause_COMATTRIB[ 5 ]
	ProcessClause_COMATTRIB[ 1 ] = 0
	ProcessClause_COMATTRIB[ 2 ] = 'Devuelve una cadena con la clausula a evaluar procesada.'
	ProcessClause_COMATTRIB[ 3 ] = 'ProcessClause'
	ProcessClause_COMATTRIB[ 4 ] = 'String'
	* ProcessClause_COMATTRIB[ 5 ] = 0

	* ProcessClause
	* Devuelve una cadena con la clausula a evaluar procesada.
	Procedure ProcessClause ( tcClause As String, tvOrigen As Variant, tcReplace As String ) As String HelpString 'Devuelve una cadena con la clausula a evaluar procesada.'

		Return m.String.ProcessClause ( m.tcClause, m.tvOrigen, m.tcReplace )

	Endproc && ProcessClause

	Dimension ToString_COMATTRIB[ 5 ]
	ToString_COMATTRIB[ 1 ] = 0
	ToString_COMATTRIB[ 2 ] = 'Devuelve una cadena con la represnetración del objeto.'
	ToString_COMATTRIB[ 3 ] = 'ToString'
	ToString_COMATTRIB[ 4 ] = 'String'
	* ToString_COMATTRIB[ 5 ] = 0

	* ToString
	* Devuelve una cadena con la represnetración del objeto.
	Procedure ToString ( tcTemplate As String ) As String HelpString 'Devuelve una cadena con la represnetración del objeto.'

		Local lcExpresion As String, ;
			lcString As String, ;
			loErr As Exception

		Try

			lcString = ''
			If Empty ( m.tcTemplate )
				lcString = This.Name

			Else
				* m.lcExpresion = This.ProcessClause( m.tcTemplate, This, "This." )
				lcExpresion = m.String.ProcessClause ( m.tcTemplate, This, 'This.' )
				lcString    = Evaluate ( m.lcExpresion )

			Endif && Empty( tcTemplate )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcTemplate
			THROW_EXCEPTION

		Endtry

		Return m.lcString

	Endproc && ToString

Enddefine && CustomBase
