#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

#Define KEYASCENDING 2
#Define KEYDESCENDING 3

* CollectionBase
Define Class CollectionBase As Collection

	#If .F.
		Local This As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg
	#Endif

	#If .F.
		TEXT
		 *:Help Documentation
		 *:Project:
		 Tier Adapter
		 *:Autor:
		 Ricardo Aidelman
		 *:Date:
		 Domingo 16 de Abril de 2006 (20:55:34)
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

	* Nombre de la clase de los elementos que forman la coleccion
	cClassName = ''

	* Nombre de la librería de clases
	cClassLibrary = ''

	* Carpeta donde se encuentra la librería de clases
	cClassLibraryFolder = ''

	*!* Referencia al objeto principal
	oMainObject = Null

	*!* Referencia al Parent
	oParent = Null

	* DataSession
	DataSession = 0

	* DataSessionId
	DataSessionId = 0

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="cclasslibraryfolder" type="property" display="cClassLibraryFolder" />] ;
		+ [<memberdata name="cclasslibrary" type="property" display="cClassLibrary" />];
		+ [<memberdata name="cclassname" type="property" display="cClassName" />] ;
		+ [<memberdata name="omainobject" type="property" display="oMainObject" />] ;
		+ [<memberdata name="omainobject_access" type="method" display="oMainObject_Access" />] ;
		+ [<memberdata name="oparent" type="property" display="oParent" />] ;
		+ [<memberdata name="clear" type="method" display="Clear" />] ;
		+ [<memberdata name="new" type="method" display="New" />] ;
		+ [<memberdata name="getitem" type="method" display="GetItem" />] ;
		+ [<memberdata name="getitemproperty" type="method" display="GetItemProperty" />] ;
		+ [<memberdata name="getcloneditem" type="method" display="GetClonedItem" />] ;
		+ [<memberdata name="removeitem" type="method" display="RemoveItem" />] ;
		+ [<memberdata name="indexon" type="method" display="IndexOn" />] ;
		+ [<memberdata name="getmin" type="method" display="GetMin" />] ;
		+ [<memberdata name="getmain" type="method" display="GetMain" />] ;
		+ [<memberdata name="where" type="method" display="Where" />] ;
		+ [<memberdata name="distinct" type="method" display="Distinct" />] ;
		+ [<memberdata name="copyto" type="method" display="CopyTo" />] ;
		+ [<memberdata name="moveto" type="method" display="MoveTo" />] ;
		+ [<memberdata name="topquery" type="method" display="TopQuery" />] ;
		+ [<memberdata name="sortby" type="method" display="SortBy" />] ;
		+ [<memberdata name="select" type="method" display="Select" />] ;
		+ [<memberdata name="getmax" type="method" display="GetMax" />] ;
		+ [<memberdata name="bottomquery" type="method" display="BottomQuery" />] ;
		+ [<memberdata name="recursive" type="method" display="Recursive" />] ;
		+ [<memberdata name="tostring" type="method" display="ToString" />] ;
		+ [<memberdata name="reverse" type="method" display="Reverse" />] ;
		+ [<memberdata name="getbylist" type="method" display="GetByList" />] ;
		+ [</VFPData>]

	* AddItem
	Procedure AddItem ( teItem As Variant, tcKey As String, teBefore As Variant, teAfter As Variant ) As Void

		Local lnCnt As Integer, ;
			loErr As Exception

		Local leItem As Variant

		Try
			lnCnt = Pcount()

			leItem = Null

			If lnCnt > 1
				leItem = This.GetItem( tcKey )
			Endif

			If Isnull( leItem  )

				Do Case
					Case lnCnt == 1
						This.Add ( m.teItem )

					Case lnCnt == 2
						This.Add ( m.teItem, Lower ( m.tcKey ) )

					Case lnCnt == 3
						This.Add ( m.teItem, Lower ( m.tcKey ), m.teBefore )

					Case lnCnt == 4
						This.Add ( m.teItem, Lower ( m.tcKey ), m.teBefore, m.teAfter )

					Otherwise
						This.Add ( m.teItem, Lower ( m.tcKey ), m.teBefore, m.teAfter )

				Endcase

			Else
				leItem = m.teItem 

			Endif

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, teItem, tcKey, teBefore, teAfter
			THROW_EXCEPTION

		Endtry

	Endproc && AddItem

	* GetMain
	Procedure GetMain() As Object HelpString 'Devuelve el objeto principal en la jerarquía de clases'

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

		Return This.oMainObject.GetMain()

	Endproc && GetMain

	* oMainObject_Access
	Procedure oMainObject_Access()

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Project:
				 Sistemas Praxis
				  *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Viernes 6 de Febrero de 2009 (13:32:47)
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

		If Vartype ( This.oMainObject ) # 'O'
			This.oMainObject = Createobject ( 'SessionBase' )

		Endif && Vartype ( This.oMainObject ) # 'O'

		Return This.oMainObject

	Endproc && oMainObject_Access

	* ValidateKeyOrIndex
	* Hidden Function ValidateKeyOrIndex ( tvIndex As Variant, tnIndexOut As Integer @ ) As Boolean
	Function ValidateKeyOrIndex ( tvIndex As Variant, tnIndexOut As Integer @ ) As Boolean

		Local lcKey As String, ;
			llRet As Boolean, ;
			lnIdx As Number, ;
			lcIndexType As String

		Try

			lcIndexType = Vartype ( m.tvIndex )
			Do Case
				Case lcIndexType == 'C'
					lnIdx = This.GetKey ( Lower ( m.tvIndex ) )

					If ! Empty ( m.lnIdx )
						tnIndexOut = m.lnIdx
						llRet      = .T.

					Endif && ! Empty( m.i )

				Case lcIndexType == 'N'
					lcKey =  This.GetKey ( m.tvIndex )

					If ! Empty ( m.lcKey )
						tnIndexOut = m.tvIndex
						llRet      = .T.

					Endif && ! Empty( m.lcKey )

				Otherwise
					Error 'Error de tipo de datos'

			Endcase

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvIndex, tnIndexOut
			THROW_EXCEPTION

		Endtry

		Return m.llRet

	Endfunc && ValidateKeyOrIndex

	* GetItem
	* Devuelve un elemento de la colección.
	Function GetItem ( tvIndex As Variant ) As Object HelpString 'Devuelve un elemento de la colección.'

		Local lnIndexOut As Integer, ;
			loErr As Exception, ;
			loItem As Object

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve un elemento de la colección
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Martes 3 de Febrero de 2009 (12:57:58)
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

			loItem = Null

			If This.ValidateKeyOrIndex ( m.tvIndex, @lnIndexOut )
				loItem = This.Item ( m.lnIndexOut )

			Endif && This.ValidateKeyOrIndex( m.tvIndex , @lnIndexOut )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvIndex
			THROW_EXCEPTION

		Endtry

		Return m.loItem

	Endfunc && GetItem

	*
	* Devuelve el contenida de la propiedad de un determinado elemento
	Procedure GetItemProperty( tvIndex As Variant, tcProperty As String ) As Variant
		Local lcCommand As String
		Local luValue As Variant
		Local loItem As Object

		Try

			lcCommand = ""
			loItem = This.GetItem( tvIndex )

			If Vartype( loItem ) = "O"

				Try

					luValue = Evaluate( "loItem." + tcProperty )

				Catch To oErr

				Finally

				Endtry

			Endif

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return luValue

	Endproc && GetItemProperty



	* GetClonedItem
	* Devuelve un elemento clonado de la colección.
	* Pertmite modificar las propiedades del elemento,
	* sin que afecte al elemento original
	Function GetClonedItem ( tvIndex As Variant ) As Object HelpString 'Devuelve un elemento de la colección.'

		Local lnIndexOut As Integer, ;
			loErr As Exception,;
			loClonedItem As Object

		Local loItem As ObjectBase Of Tools\Namespaces\Prg\baselibrary.Prg

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve un elemento de la colección
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Martes 3 de Febrero de 2009 (12:57:58)
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

			loItem = This.GetItem( tvIndex )

			If Pemstatus( loItem, "MemberwiseClone", 5 )
				loClonedItem = loItem.MemberwiseClone()

			Else
				loClonedItem = loItem

			Endif

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvIndex
			THROW_EXCEPTION

		Finally
			loItem = Null

		Endtry

		Return m.loClonedItem

	Endfunc && GetClonedItem



	*
	* Devuelve una coleccion de elementos definidos en una lista
	Procedure GetByList( cItemsList As String, lCloned As Boolean ) As Void;
			HELPSTRING "Devuelve una coleccion de elementos definidos en una lista"
		Local lcCommand As String,;
			lcKeyName As String
		Local lnLen As Integer,;
			i As Integer

		Local loItem As ObjectBase Of Tools\Namespaces\Prg\baselibrary.Prg
		Local loCollection As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg

		Try

			lcCommand = ""

			loCollection = Newobject( This.Name, This.ClassLibrary )
			lnLen = Getwordcount( cItemsList, "," )

			For i = 1 To lnLen
				lcKeyName = Alltrim( Getwordnum( cItemsList, i, "," ))

				If lCloned
					loItem = This.GetClonedItem( lcKeyName )

				Else
					loItem = This.GetItem( lcKeyName )

				Endif

				If !Isnull( loItem )
					loCollection.AddItem( loItem, lcKeyName )
				Endif

			Endfor


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return loCollection

	Endproc && GetByList

	* RemoveItem
	* Devuelve el elemento eleminado de la colección.
	Function RemoveItem ( tvIndex As Variant ) As Object HelpString 'Devuelve el elemento eleminado de la colección.'

		Local lnIndexOut As Integer, ;
			loErr As Exception, ;
			loItem As Object

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Elimina un elemento de la colección
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Martes 3 de Febrero de 2009 (12:57:58)
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

			loItem = This.GetItem( m.tvIndex )

			If This.ValidateKeyOrIndex ( m.tvIndex, @lnIndexOut )
				This.Remove ( m.lnIndexOut )

			Endif && This.ValidateKeyOrIndex( m.tvIndex, @lnIndexOut )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvIndex
			THROW_EXCEPTION

		Endtry

		Return m.loItem

	Endfunc && RemoveItem

	* New
	* Devuelve un elemento nuevo y lo agrega a la colección.
	Function New ( tcName As String, tcBefore As String ) As Object HelpString 'Devuelve un elemento nuevo y lo agrega a la colección.'

		Local lcKey As String, ;
			loErr As Exception, ;
			loItem As Object

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Crea un elemento y lo agrega a la coleccion
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Martes 3 de Febrero de 2009 (12:39:44)
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

			If Empty ( m.tcName ) Or Vartype ( m.tcName ) # 'C'
				Error 'Error de tipo en el parámetro cName'

			Endif && Empty( m.tcName ) Or Vartype( m.tcName ) # "C"

			tcName = Alltrim ( m.tcName )
			loItem = Newobject ( This.cClassName, Addbs ( This.cClassLibraryFolder ) + This.cClassLibrary )
			loItem.Name    = Proper ( m.tcName )
			loItem.oParent = This
			lcKey = Lower ( m.tcName )

			If Empty ( m.tcBefore )
				This.AddItem ( m.loItem, m.lcKey )

			Else && Empty( m.tcBefore )
				This.AddItem ( m.loItem, m.lcKey, Lower ( m.tcBefore ) )

			Endif && Empty( m.tcBefore )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.loItem

	Endfunc && New

	* Clear
	* Vacía la colección
	Procedure Clear() As Void HelpString 'Vacía la colección'

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Vacía la colección
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Ricardo Aidelman
			 *:Date:
			 Martes 3 de Febrero de 2009 (13:11:14)
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

		This.Remove ( -1 )

	Endproc && Clear

	* Destroy
	Procedure Destroy() As Void

		Local loErr As Exception

		Try
			This.Remove ( - 1 )
			This.oMainObject = Null
			This.oParent     = Null
			Unbindevents ( This )
			DoDefault()

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

	Endproc && Destroy

	* IndexOn
	* Reordena los elementos de la colección por el valor de la propiedad dada.
	Procedure IndexOn ( tcIndexProperty As String, ;
			tlSortDesc As Boolean, ;
			tlSkipBackup As Boolean ) As Void HelpString 'Reordena los elementos de la colección por el valor de la propiedad dada.'

		Local lcKey As String, ;
			lcKeyOrder As String, ;
			liIdx As Integer, ;
			llAdd As Boolean, ;
			llOk As Boolean, ;
			lnIndex As Integer, ;
			loBkUpCol As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg, ;
			loColToSort As Collection, ;
			loColWrapper As Collection, ;
			loErr As Exception, ;
			loItem As Object, ;
			loObjWrapper As Object

		Try

			If m.String.IsNullOrEmpty ( m.tcIndexProperty )
				Error 'Error en el parametro "tcIndexProperty". Se esperaba un String no vacio'

			Endif && Empty( tcIndexProperty )

			loColToSort = Createobject ( 'Collection' )

			* BackUp
			If ! m.tlSkipBackup
				loBkUpCol = Newobject ( This.Class, This.ClassLibrary )
				This.CopyTo ( m.loBkUpCol )

			Endif && ! m.tlSkipBackup

			* Creo un coleccion ordenada por tcIndexProperty

			For liIdx = 1 To This.Count
				loItem       = This.Item[ m.liIdx ]
				lcKey        = This.GetKey ( m.liIdx )
				lcKeyOrder   = Lower ( Transform ( Getpem ( m.loItem, m.tcIndexProperty  ) ) )

				If Isdigit( lcKeyOrder )
					lcKeyOrder = StrZero( Val( lcKeyOrder ), 8 )
				Endif

				loObjWrapper = CreateObjParam ( 'oItem', m.loItem, ;
					'cKey', m.lcKey, ;
					'nIndex', m.liIdx )

				* Agrego la colección wrapper en la colección
				m.loColToSort.Add ( m.loObjWrapper, m.lcKeyOrder )

			Endfor

			loColToSort.KeySort = Iif ( m.tlSortDesc, KEYDESCENDING, KEYASCENDING )
			This.Clear()

			For Each m.loObjWrapper In m.loColToSort
				This.Add ( m.loObjWrapper.oItem, m.loObjWrapper.cKey )
			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcIndexProperty, tlSortDesc, tlSkipBackup
			If ! m.tlSkipBackup
				m.loBkUpCol.MoveTo ( This, .T. )

			Endif && ! m.tlSkipBackup
			THROW_EXCEPTION

		Finally
			loObjWrapper = Null
			loItem       = Null

			Try
				If ! m.tlSkipBackup
					m.loBkUpCol.Remove ( -1 )

				Endif
			Catch To loErr
				DEBUG_CLASS_EXCEPTION

			Endtry
			Try
				m.loColToSort.Remove ( -1 )
			Catch To loErr
				DEBUG_CLASS_EXCEPTION

			Endtry
			Try
				m.loColWrapper.Remove ( -1 )
			Catch To loErr
				DEBUG_CLASS_EXCEPTION

			Endtry

			loColToSort  = Null
			loColWrapper = Null
			loBkUpCol    = Null

		Endtry

	Endproc && IndexOn

	* IndexOn
	* Reordena los elementos de la colección por el valor de la propiedad dada.
	Procedure xxx_IndexOn ( tcIndexProperty As String, tlSortDesc As Boolean, tlSkipBackup As Boolean ) As Void HelpString 'Reordena los elementos de la colección por el valor de la propiedad dada.'

		Local lcKey As String, ;
			lcKeyOrder As String, ;
			liIdx As Integer, ;
			llAdd As Boolean, ;
			llOk As Boolean, ;
			lnIndex As Integer, ;
			loBkUpCol As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg, ;
			loColToSort As Collection, ;
			loColWrapper As Collection, ;
			loErr As Exception, ;
			loItem As Object, ;
			loObjWrapper As Object

		Try

			If m.String.IsNullOrEmpty ( m.tcIndexProperty )
				Error 'Error en el parametro "tcIndexProperty". Se esperaba un String no vacio'

			Endif && Empty( tcIndexProperty )

			loColToSort = Createobject ( 'Collection' )

			* BackUp
			If ! m.tlSkipBackup
				loBkUpCol = Newobject ( This.Class, This.ClassLibrary )
				This.CopyTo ( m.loBkUpCol )

			Endif && ! m.tlSkipBackup

			For liIdx = 1 To This.Count
				loItem       = This.Item[ m.liIdx ]
				lcKey        = This.GetKey ( m.liIdx )
				lcKeyOrder   = Lower ( Transform ( Getpem ( m.loItem, m.tcIndexProperty  ) ) )
				loObjWrapper = CreateObjParam ( 'oItem', m.loItem, 'cKey', m.lcKey, 'nIndex', m.liIdx )

				* Busco la colección Wrapper
				lnIndex = m.loColToSort.GetKey ( m.lcKeyOrder )
				If Empty ( m.lnIndex )
					loColWrapper = Createobject ( 'Collection' )

					* Agrego el elemento a la colección
					m.loColWrapper.Add ( m.loObjWrapper )

					* Agrego la colección wrapper en la colección
					m.loColToSort.Add ( m.loColWrapper, m.lcKeyOrder )

				Else &&  Empty ( m.lnIndex )
					loColWrapper = m.loColToSort.Item[ m.lnIndex ]

					* Agrego el elemento a la colección
					m.loColWrapper.Add ( m.loObjWrapper )

				Endif &&  Empty ( m.lnIndex )

			Endfor

			loColToSort.KeySort = Iif ( m.tlSortDesc, KEYDESCENDING, KEYASCENDING )
			This.Clear()
			For Each m.loColWrapper In m.loColToSort FoxObject
				For liIdx = 1 To m.loColWrapper.Count
					loObjWrapper = m.loColWrapper.Item[ m.liIdx ]
					This.Add ( m.loObjWrapper.oItem, m.loObjWrapper.cKey )

				Endfor

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcIndexProperty, tlSortDesc, tlSkipBackup
			If ! m.tlSkipBackup
				m.loBkUpCol.MoveTo ( This, .T. )

			Endif && ! m.tlSkipBackup
			THROW_EXCEPTION

		Finally
			loObjWrapper = Null
			loItem       = Null

			Try
				If ! m.tlSkipBackup
					m.loBkUpCol.Remove ( -1 )

				Endif
			Catch To loErr
				DEBUG_CLASS_EXCEPTION

			Endtry
			Try
				m.loColToSort.Remove ( -1 )
			Catch To loErr
				DEBUG_CLASS_EXCEPTION

			Endtry
			Try
				m.loColWrapper.Remove ( -1 )
			Catch To loErr
				DEBUG_CLASS_EXCEPTION

			Endtry

			loColToSort  = Null
			loColWrapper = Null
			loBkUpCol    = Null

		Endtry

	Endproc && xxx_IndexOn

	* GetMax
	* Devuelve el objeto cuyo valor de indice alternativo es el mayor 
	Protected Procedure GetMax ( tcIndexProperty As String ) As Integer HelpString 'Devuelve el objeto cuyo valor de indice alternativo es el menor'

		Local liIdx As Integer, ;
			lnIndex As Integer, ;
			loErr As Exception, ;
			loObj As Object, ;
			lvMaxValue As Variant, ;
			lvValue As Variant

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve el objeto cuyo valor de indice alternativo es el mayor
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Lunes 6 de Julio de 2009
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

			If m.String.IsNullOrEmpty ( m.tcIndexProperty )
				Error 'Error en el parametro "tcIndexProperty". Se esperaba un String no vacio'

			Endif && m.String.IsNullOrEmpty( m.tcIndexProperty )

			lnIndex = 0

			If This.Count > 1
				loObj   = This.Item[ 1 ]
				lnIndex = 1
				If Pemstatus ( m.loObj, m.tcIndexProperty, 5 )
					* m.lvMaxValue = Evaluate( "loObj." + m.tcIndexProperty )
					lvMaxValue = Getpem ( m.loObj, m.tcIndexProperty )

				Endif && Pemstatus( loObj, tcIndexProperty, 5 )

				For liIdx = 1 To This.Count
					loObj = This.Item[ m.liIdx ]

					If Pemstatus ( m.loObj, m.tcIndexProperty, 5 )
						lvValue = Evaluate ( 'loObj.' + m.tcIndexProperty )
						lvValue = Getpem ( m.loObj, m.tcIndexProperty )

						If m.lvValue > m.lvMaxValue
							lvMaxValue = m.lvValue
							lnIndex    = m.liIdx

						Endif && m.lvValue < m.lvMaxValue

					Endif && Pemstatus( m.loObj, m.tcIndexProperty, 5 )

				Endfor

			Endif && This.Count > 1

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcIndexProperty
			THROW_EXCEPTION

		Finally
			loObj = Null

		Endtry

		Return m.lnIndex

	Endproc && GetMax

	* GetMin
	* Devuelve el objeto cuyo valor de indice alternativo es el menor.
	Protected Procedure GetMin ( tcIndexProperty As String ) As Integer HelpString 'Devuelve el objeto cuyo valor de indice alternativo es el menor.'

		Local liIdx As Integer, ;
			lnIndex As Integer, ;
			loErr As Exception, ;
			loObj As Object, ;
			lvMinValue As Variant, ;
			lvValue As Variant

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve el objeto cuyo valor de indice alternativo es el mayor
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Ricardo Aidelman
				 *:Date:
				 Lunes 6 de Julio de 2009
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

			If m.String.IsNullOrEmpty ( m.tcIndexProperty )
				Error 'Error en el parametro "tcIndexProperty". Se esperaba un String no vacio'

			Endif && m.String.IsNullOrEmpty( m.tcIndexProperty )

			lnIndex = 0

			If This.Count > 1
				loObj   = This.Item [ 1 ]
				lnIndex = 1
				If Pemstatus ( loObj, m.tcIndexProperty, 5 )
					* m.lvMinValue = Evaluate( "loObj." + m.tcIndexProperty )
					lvMinValue = Getpem ( m.loObj, m.tcIndexProperty )

				Endif && Pemstatus( m.loObj, m.tcIndexProperty, 5 )

				For liIdx = 1 To This.Count
					loObj = This.Item [ m.liIdx ]

					If Pemstatus ( m.loObj, m.tcIndexProperty, 5 )
						* m.lvValue = Evaluate( "loObj." + m.tcIndexProperty )
						lvValue = Getpem ( m.loObj, m.tcIndexProperty )

						If m.lvValue < m.lvMinValue
							lvMinValue = m.lvValue
							lnIndex    = m.liIdx

						Endif && m.lvValue < m.lvMinValue

					Endif && Pemstatus( m.loObj, m.tcIndexProperty, 5 )

				Endfor

			Endif && This.Count > 1

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcIndexProperty
			THROW_EXCEPTION

		Finally
			loObj = Null

		Endtry

		Return m.lnIndex

	Endproc && GetMin

	*!*	* oParent_Assign
	*!*	Protected Procedure oParent_Assign ( toParent As Object ) As Void
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

	*!*		Endif && Vartype( m.toParent ) # "O"

	*!*		This.oParent = m.toParent

	*!*	Endproc && oParent_Assign

	* Where
	* Devuelve el sub-conjunto de elementos de la colección que cumplen con las condiciones dadas.
	Function Where ( tvColFilters As Variant, tlSetExact As Boolean ) As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg HelpString 'Devuelve el sub-conjunto de elementos de la colección que cumplen con las condiciones dadas.'

		Local lcClassAnt As String, ;
			lcExpr As String, ;
			lcField As String, ;
			lcKey As String, ;
			lcOperator As String, ;
			lcSetExact As String, ;
			liIdx As Integer, ;
			llIsString As Boolean, ;
			llOk As Boolean, ;
			loErr As Exception, ;
			loFilter As oFilter Of, ;
			loItem As Object, ;
			loRet As Object

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve el sub-conjunto de elementos de la colección que cumplen con las condiciones dadas.
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damian Eiff
				 *:Date:
				 Lunes 6 de Julio de 2009 (18:54:49)
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
			lcSetExact = Set ( 'Exact' )
			If m.tlSetExact
				Set Exact On

			Else && m.tlSetExact
				Set Exact Off

			Endif && m.tlSetExact

			loRet = Newobject ( This.Class, This.ClassLibrary )

			llIsString = ( Vartype ( m.tvColFilters ) = 'C' )
			If m.llIsString And ( This.Count > 0 )
				loItem = This.Item ( 1 )
				lcKey  = This.GetKey ( 1 )

				lcExpr     = m.String.ProcessClause ( m.tvColFilters, m.loItem, 'loItem.' )
				lcClassAnt = Lower ( m.loItem.Class )

			Endif && llIsString and This.Count > 0

			For liIdx = 1 To This.Count
				loItem = This.Item [ m.liIdx ]
				lcKey  = This.GetKey ( m.liIdx )

				llOk = .T.
				If m.llIsString
					llOk = m.llOk And Evaluate ( m.lcExpr )

				Else
					For Each m.loFilter In m.tvColFilters
						lcExpr = Strtran ( m.loFilter.cFieldExp, '<#FIELD#>', 'loItem.' + m.loFilter.cField ) + m.loFilter.cOperator + m.loFilter.cExpr
						llOk   = m.llOk And Evaluate ( m.lcExpr )

					Endfor

				Endif && m.llIsString

				If m.llOk
					If Empty ( m.lcKey ) And Vartype ( m.loItem ) == 'O' And Pemstatus ( m.loItem, 'Name', 5 )
						lcKey = Lower ( m.loItem.Name )

					Endif && Empty( m.lcKey ) And Vartype( m.loItem ) == 'O' And Pemstatus( m.loItem, 'Name', 5 )

					m.loRet.AddItem ( m.loItem, m.lcKey )

				Endif && m.llOk

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvColFilters, tlSetExact
			THROW_EXCEPTION

		Finally
			loItem = Null

			Set Exact &lcSetExact

		Endtry

		Return m.loRet

	Endproc && Where

	* Distinct
	* Filtra los elementos únicos de la colección por el valor de la propiedad dada.
	Procedure Distinct ( tcProperty As String, tlSkipBackup As Boolean ) As Void

		Local liIdx As Integer, ;
			loBkUpCol As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg, ;
			loCol As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg, ;
			loColDuplicates As CollectionBase Of Tools\Namespaces\Prg\CollectionBase.Prg, ;
			loErr As Exception, ;
			loItem As Object

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damian Eiff
				 *:Date:
				 Viernes 17 de Julio de 2009 (16:36:26)
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

			If m.String.IsNullOrEmpty ( m.tcProperty )
				Error 'Error en el parametro "tcProperty ". Se esperaba un String no vacio'

			Endif && Empty( tcProperty )

			loColDuplicates = Newobject ( 'CollectionBase', 'Tools\namespaces\prg\CollectionBase.prg' )
			loCol           = Newobject ( 'CollectionBase', 'Tools\namespaces\prg\CollectionBase.prg' )
			If ! m.tlSkipBackup
				loBkUpCol = Newobject ( This.Class, This.ClassLibrary )
				This.CopyTo ( m.loBkUpCol )

			Endif && m.tlSkipBackup

			For liIdx = 1 To This.Count
				loItem = This.Item [ m.liIdx ]
				Try
					If Vartype ( m.loItem ) = 'O' And Pemstatus ( m.loItem, m.tcProperty, 5 )
						m.loCol.AddItem ( Getpem ( m.loItem, m.tcProperty ), Getpem ( m.loItem, m.tcProperty ) )

					Endif && Vartype( loItem ) = 'O' And Pemstatus( loItem, tcProperty, 5 )

				Catch To loErr
					DEBUG_CLASS_EXCEPTION
					m.loColDuplicates.AddItem ( m.liIdx )

				Endtry

			Endfor

			For liIdx = m.loColDuplicates.Count To 1 Step - 1
				This.Remove ( m.loColDuplicates.Item [ m.liIdx ] )

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcProperty, tlSkipBackup
			If ! m.tlSkipBackup
				Try
					m.loBkUpCol.MoveTo ( This, .T. )

				Catch To loErr
					DEBUG_CLASS_EXCEPTION

				Endtry
			Endif && ! m.tlSkipBackup
			THROW_EXCEPTION

		Finally
			If ! m.tlSkipBackup
				m.loBkUpCol.Remove ( - 1 )
				loBkUpCol = Null
			Endif && ! m.tlSkipBackup

			m.loColDuplicates.Remove ( - 1 )
			loColDuplicates = Null

			m.loCol.Remove ( - 1 )
			loCol = Null

			loItem = Null

		Endtry

	Endproc && Distinct

	* CopyTo
	* Copia la colección a la colección destino. 
	Procedure CopyTo ( toCol As Object, tlCLearDest As Boolean, tlCLearOrig As Boolean ) As Void HelpString 'Copia la colección a la colección destino.'

		Local lcKey As String, ;
			liIdx As Integer, ;
			loErr As Exception, ;
			loObj As Object

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Copia la colección a la colección destino.
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damian Eiff
				 *:Date:
				 Domingo 2 de Agosto de 2009 (16:24:30)
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

			If m.tlCLearDest
				m.toCol.Remove ( - 1 )

			Endif && m.tlCLear

			For liIdx = 1 To This.Count
				loObj = This.Item [ m.liIdx ]
				lcKey = This.GetKey ( m.liIdx )
				If Empty ( m.lcKey ) And Vartype ( m.loObj ) == 'O' And Pemstatus ( m.loObj, 'Name', 5 )
					lcKey = Lower ( m.loObj.Name )

				Endif && Empty( m.lcKey ) And Vartype( m.loObj ) == 'O' And Pemstatus( m.loObj, 'Name', 5 )

				m.toCol.AddItem ( m.loObj, m.lcKey )

			Endfor

			If m.tlCLearOrig
				This.Remove ( - 1 )

			Endif

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toCol, tlCLearDest, tlCLearOrig
			THROW_EXCEPTION

		Endtry

	Endproc && CopyTo

	* MoveTo
	* Mueve los datos de la colección a la colección destino.
	Procedure MoveTo ( toCol As Collection, tlCLearDest As Boolean ) As Void HelpString 'Copia la colección a la colección destino.'

		Local loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Description:
			 Mueve los datos de la colección a la colección destino
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damian Eiff
			 *:Date:
			 Domingo 2 de Agosto de 2009 (16:24:30)
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

			This.CopyTo ( m.toCol, m.tlCLearDest, .T. )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toCol, tlCLearDest
			THROW_EXCEPTION

		Endtry

	Endproc && MoveTo

	* TopQuery
	Function TopQuery ( tnTop As Number, tlPercent As Boolean, tlInvert As Boolean ) As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg

		Local lnTop As Number, ;
			loColRet As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg, ;
			loErr As Exception

		#If .F.
			TEXT
			 *:Help Documentation
			 *:Project:
			 Sistemas Praxis
			 *:Autor:
			 Damian Eiff
			 *:Date:
			 Domingo 2 de Agosto de 2009 (16:58:40)
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

			If This.ValidateTop ( m.tnTop, m.tlPercent, @lnTop )
				lnTop = Min ( m.lnTop, This.Count )
				loColRet = This.GetTop ( 1, m.lnTop, 1 )

				If m.tlInvert
					loColRet = m.loColRet.Reverse()

				Endif && m.tlInvert

			Endif && This.ValidateTop ( m.tnTop, m.tlPercent, @lnTop )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnTop, tlPercent, tlInvert
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endproc && TopQuery

	* SkipQuery
	Function SkipQuery ( tnTop As Number, tlPercent As Boolean, tlInvert As Boolean ) As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg

		Local lnTop As Number, ;
			loColRet As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg, ;
			loErr As Exception

		Try
			If m.tlPercent
				tnTop = Max ( 100 - m.tnTop, 0 )

			Else
				tnTop = Max ( This.Count - m.tnTop, 0 )

			Endif && m.tlPercent

			If This.ValidateTop ( m.tnTop, m.tlPercent, @lnTop )

				lnTop = Min ( m.lnTop, This.Count )

				loColRet = This.GetTop ( 1, m.lnTop, -1 )

				If m.tlInvert
					loColRet = m.loColRet.Reverse()

				Endif && m.tlInvert

			Endif

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endproc && SkipQuery

	* GetTop
	Hidden Function GetTop ( tnStart As Integer, tnTop As Integer, tnStep As Integer )

		Local lcKey As String, ;
			liIdx As Integer, ;
			loColRet As Object, ;
			loObj As Object

		loColRet = Newobject ( This.Class, This.ClassLibrary )
		For liIdx = m.tnStart  To m.tnTop Step m.tnStep
			loObj = This.Item [ m.liIdx ]
			lcKey = This.GetKey ( m.liIdx )
			If Empty ( m.M.lcKey ) And Vartype ( m.loObj ) = 'O' And Pemstatus ( m.loObj, 'Name', 5 )
				lcKey = Lower ( m.loObj.Name )

			Endif && Empty( m.lcKey ) And Pemstatus( m.loObj, 'Name', 5 )

			m.loColRet.AddItem ( m.loObj, m.lcKey )

		Endfor

		Return m.loColRet

	Endfunc && GetTop

	* ValidateTop
	Hidden Function ValidateTop ( tnTop As Number, tlPercent As Boolean, tnTopOut As Integer @ ) As Boolean

		Local llRest As Boolean

		Try
			llRest = .T.
			Do Case
				Case Vartype ( m.tnTop ) # 'N'
					Error 9 && Data type mismatch

				Case m.tnTop < 1
					* tnTop = This.Count
					Error 'Zero or negative used as argument.'

				Otherwise
					If m.tlPercent And m.tnTop > 100
						Error 'Invalid TOP specification.'

					Endif && tlPercent And tnTop > 100

			Endcase

			If m.tlPercent
				tnTopOut = m.tnTop * This.Count / 100

			Else &&  m.tlPercent
				tnTopOut = m.tnTop

			Endif && m.tlPercent

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnTop, tlPercent, tnTopOut
			THROW_EXCEPTION

		Endtry

		Return m.llRest

	Endfunc && ValidateTop

	* BottomQuery
	Function BottomQuery ( tnTop As Number, tlPercent As Boolean, tlInvert As Boolean ) As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg

		Local lnTop As Number, ;
			loColRet As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg, ;
			loErr As Exception

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damian Eiff
				 *:Date:
				 Domingo 12 de Agosto de 2009
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
			If This.ValidateTop ( m.tnTop, m.tlPercent, @lnTop )

				lnTop = Max ( Min ( m.lnTop, This.Count ), 1 )

				loColRet = This.GetTop ( m.lnTop, 1, -1 )

				If m.tlInvert
					loColRet = m.loColRet.Reverse()

				Endif && m.tlInvert

			Endif && This.ValidateTop ( m.tnTop, m.tlPercent, @lnTop )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tnTop, tlPercent, tlInvert
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endproc && BottomQuery

	* SortBy
	Function SortBy ( tvSortBy As Variant ) As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg HelpString 'Devuelve una colección ordenada según los parametros'


		Local lcExp As String, ;
			lcExp2 As String, ;
			liIdx As Integer, ;
			llIsString As Boolean, ;
			llSortDesc As Boolean, ;
			lnOccurs As Integer, ;
			loColRet As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg, ;
			loErr As Exception

		#If .F.
			TEXT
					 *:Help Documentation
					 *:Project:
					 Sistemas Praxis
					 *:Autor:
					 Damian Eiff
					 *:Date:
					 Domingo 2 de Agosto de 2009 (17:26:38)
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

			llIsString = ( Vartype ( m.tvSortBy ) = 'C' )
			loColRet   = Newobject ( This.Class, This.ClassLibrary )
			This.CopyTo ( m.loColRet )

			If m.llIsString
				* tvSortBy = Alltrim( tvSortBy )
				lnOccurs = Getwordcount ( m.tvSortBy, ',' )
				For liIdx = m.lnOccurs To 1 Step - 1
					llSortDesc = .F.
					lcExp      = Getwordnum ( m.tvSortBy, m.liIdx, ',' )
					If Getwordcount ( m.lcExp ) > 1
						lcExp2     = Alltrim ( Getwordnum ( m.lcExp, 2) )
						lcExp2     = Left ( Lower ( lcExp2 ), 3 )
						llSortDesc = (  m.lcExp2 == 'des' )

					Endif && Getwordcount( m.lcExp ) > 1

					m.loColRet.IndexOn ( Getwordnum ( m.lcExp, 1 ), m.llSortDesc )

				Endfor

			Else && m.llIsString
				Error 'No implementado'

			Endif && llIsString

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvSortBy
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endproc && SortBy

	* Select
	* Devuelve una colección de objetos nuevos con propiedades .
	Function Select ( tvSelect As Variant  ) As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg HelpString 'Devuelve una colección de objetos nuevos con propiedades selecionadas de los elementos de la colección'

		Local lcExp As String, ;
			lcExpProp As String, ;
			lcKey As String, ;
			lcProp As String, ;
			lcPropAlias As String, ;
			liIdx As Integer, ;
			liIdx2 As Integer, ;
			llIsString As Boolean, ;
			loColRet As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg, ;
			loErr As Exception, ;
			loNewObj As Object, ;
			loObj As Object

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Description:
				 Devuelve una colección de objetos nuevos con propiedades
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damian Eiff
				 *:Date:
				 Domingo 2 de Agosto de 2009 (17:46:25)
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
			loColRet = Newobject ( This.Class, This.ClassLibrary )
			* Assert tvSelect Message 'No se recibio ningún parametro'
			llIsString = ( Vartype ( m.tvSelect ) = 'C' ) Or Pcount() = 0

			If m.llIsString
				If Empty ( m.tvSelect )
					tvSelect = '*'

				Endif
				tvSelect = Alltrim ( m.tvSelect )
				If m.tvSelect == '*'
					This.CopyTo ( m.loColRet )

				Else && m.tvSelect == '*'

					For liIdx = 1 To This.Count
						loObj    = This.Item[ m.liIdx ]
						lcKey    = This.GetKey ( m.liIdx )
						loNewObj = Createobject ( 'Empty' )
						For liIdx2 = 1 To Getwordcount ( m.tvSelect, ',' )
							lcExp     = Getwordnum ( m.tvSelect, m.liIdx2, ',' )
							lcExp     = Strtran ( m.lcExp, SP2, SP )
							lcExp     = Strtran ( m.lcExp, '(' + SP, '(' )
							lcExp     = Strtran ( m.lcExp, SP + ')', ')' )
							lcProp    = Getwordnum ( m.lcExp, 1 )
							lcExpProp = This.oMainObject.ProcessClause ( m.lcProp, @loObj, 'loObj.' )

							If Getwordcount ( m.lcExp ) > 1
								lcPropAlias = Alltrim ( Getwordnum ( m.lcExp, 2 )  )

							Else &&  Getwordcount ( m.lcExp ) > 1
								lcPropAlias = Alltrim ( m.lcProp )

							Endif && GetWordCount( m.lcExp ) > 1

							AddProperty ( m.loNewObj, m.lcPropAlias,	&lcExpProp. )

						Endfor

						If Empty ( m.lcKey ) And Vartype ( m.loObj ) == 'O' And Pemstatus ( m.loObj, 'Name', 5 )
							lcKey = Lower ( m.loObj.Name )

						Endif && Empty ( m.lcKey ) And Vartype ( m.loObj ) == 'O' And Pemstatus ( m.loObj, 'Name', 5 )
						m.loColRet.AddItem ( m.loNewObj, m.lcKey )

					Endfor

				Endif && m.tvSelect = '*'

			Else && m.llIsString
				Error 'No implementado'

			Endif && m.llIsString

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tvSelect
			THROW_EXCEPTION

		Finally
			loObj    = Null
			loNewObj = Null

		Endtry

		Return m.loColRet

	Endfunc && Select

	* Query
	* @TODO Damian Eiff 2009-08-01 (01:30:17) Proc Query
	Function Query ( tcDistinct As String, tnTop As Number, tlPercent As Boolean, tcSelect As String, tcWhere As String, tlSetExact As Boolean, tcSortBy As String ) As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg

		Local loColRet As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg, ;
			loErr As Exception

		Try
			If ! Empty ( m.tcWhere )
				loColRet = This.Where ( m.tcWhere, m.tlSetExact )

			Else
				loColRet = This

			Endif && ! Empty( m.tcWhere )

			If ! Empty ( m.tcDistinct )
				loColRet = m.loColRet.Distinct ( m.tcDistinct )

			Endif && ! Empty( m.tcDistinct )

			If ! Empty ( m.tcSortBy )
				loColRet = m.loColRet.SortBy ( m.tcSortBy )

			Endif && ! Empty( m.tcSortBy )

			If ! Empty ( m.tnTop )
				loColRet = m.loColRet.TopQuery ( m.tnTop, m.tlPercen )

			Endif && ! Empty( m.tnTop )

			If ! Empty ( m.tcSelect )
				loColRet = m.loColRet.Select ( m.tcSelect )

			Endif &&  ! Empty( m.tcSelect )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcDistinct, tnTop, tlPercent, tcSelect, tcWhere, tlSetExact, tcSortBy
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endfunc  && Query

	* ToString
	* Devuelve una cadena que representa los elementos que contiene la colección.
	Function ToString ( tcTemplate As String, tcSeparador As String, tcWhere As String ) As String HelpString 'Devuelve una cadena que representa los elementos que contiene la colección.'

		Local lcExp As String, ;
			lcExpresion As String, ;
			lcString As String, ;
			liIdx As Integer, ;
			lnCount As Integer, ;
			loCol As Collection, ;
			loErr As Exception, ;
			loItem As Object

		Try

			lcString = ''

			If Empty ( m.tcSeparador ) Or Vartype ( m.tcSeparador ) # 'C'
				tcSeparador = ','

			Endif && Empty ( m.tcSeparador ) Or Vartype ( m.tcSeparador ) # 'C'

			If Empty ( m.tcTemplate ) Or Vartype ( m.tcTemplate ) # 'C'
				tcTemplate = ''

			Endif && Empty ( m.tcTemplate ) Or Vartype ( m.tcTemplate ) # 'C'

			If Empty ( m.tcWhere )
				loCol = This

			Else && Empty ( m.tcWhere )
				loCol = This.Where ( m.tcWhere )

			Endif && Empty ( m.tcWhere )

			lnCount = m.loCol.Count

			For liIdx = 1 To m.lnCount
				loItem = m.loCol.Item[ m.liIdx ]
				If Vartype ( m.loItem ) = 'O'
					If Pemstatus ( m.loItem, 'ToString', 5 )
						lcString = m.lcString + m.loItem.ToString ( m.tcTemplate )

					Else && Pemstatus( m.loItem, 'ToString', 5 )
						lcExp = m.String.ProcessClause ( m.tcTemplate, m.loItem, 'loItem.' )
						* m.loItem = m.loCol.Item[ m.i ]
						* m.lcString = m.lcString + Evaluate( m.lcExp )
						TEXT To m.lcString Noshow Textmerge Additive
						<<Evaluate( m.lcExp )>>
						ENDTEXT

					Endif && Pemstatus( m.loItem, 'ToString', 5 )

					If m.liIdx # m.lnCount
						lcString = m.lcString + m.tcSeparador

					Endif && m.i # m.lnCount

				Endif &&  Vartype( m.loItem ) = 'O'

			Endfor

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcTemplate, tcSeparador, tcWhere
			THROW_EXCEPTION

		Finally
			loCol  = Null
			loItem = Null

		Endtry

		Return m.lcString

	Endfunc && ToString

	* Recursive
	* Recorre la colección ejecutando un comando para cada elemento
	Function Recursive ( toCol As Collection, tcPropertieOrMethod As String, tcMethodToCall As String, tvParam As Variant, tcEndCondition As String, tcItemEndCondition As String, tlDescending As Boolean ) As Boolean HelpString 'Recorre la colección ejecutando un comando para cada elemento'

		Local lcEndCondition As String, ;
			lcItemEndCondition As String, ;
			lnIdx As Number, ;
			loErr As Exception, ;
			loItem As Object

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


		Try

			If Vartype ( m.toCol ) # 'O'
				toCol = This

			Endif && Vartype( m.toCol ) = "O"

			If Empty ( m.tcEndCondition )
				tcEndCondition = '.F.'

			Endif && Empty( m.tcEndCondition )

			If Empty ( m.tcItemEndCondition )
				tcItemEndCondition = '.F.'

			Endif && Empty( m.tcEndCondition )

			If ! Empty ( m.tcPropertieOrMethod )
				lcEndCondition = m.String.ProcessClause ( m.tcEndCondition, This, 'This.' )

				If ! Evaluate ( m.lcEndCondition )
					If m.toCol.Count > 0
						lnIdx = 1

						loItem = toCol.Item [ 1 ]
						lcItemEndCondition = m.String.ProcessClause ( m.tcItemEndCondition, m.loItem, 'loItem.' )
						Do While m.lnIdx <= m.toCol.Count And ! Evaluate ( m.lcItemEndCondition )
							loItem = m.toCol.Item [ m.lnIdx ]
							lcItemEndCondition = m.String.ProcessClause ( m.tcItemEndCondition, m.loItem, 'loItem.' )

							If Vartype ( m.loItem ) == 'O'
								If m.tlDescending And Pemstatus ( m.loItem, m.tcPropertieOrMethod, 5 )
									This.Recursive ( Getpem ( m.loItem, m.tcPropertieOrMethod ), m.tcPropertieOrMethod, m.tcMethodToCall, m.tvParam, m.tcEndCondition, m.tcItemEndCondition, m.tlDescending )

								Endif && m.tlDescending And Pemstatus ( m.loItem, m.tcPropertieOrMethod, 5 )

								This.&tcMethodToCall. ( m.loItem, m.tvParam )

								If ! m.tlDescending And Pemstatus ( m.loItem, m.tcPropertieOrMethod, 5 )
									This.Recursive ( Getpem ( m.loItem, m.tcPropertieOrMethod ), m.tcPropertieOrMethod, m.tcMethodToCall, m.tvParam, m.tcEndCondition, m.tcItemEndCondition, m.tlDescending )

								Endif && ! m.tlDescending And Pemstatus ( m.loItem, m.tcPropertieOrMethod, 5 )

							Endif && Vartype( m.loItem ) = 'O'

							lnIdx = m.lnIdx + 1

						Enddo

					Endif && m.toCol.Count > 0

				Endif && ! Evaluate( m.lcEndCondition )

			Endif && ! Empty( m.tcPropertieOrMethod )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toCol, tcPropertieOrMethod, tcMethodToCall, tvParam, tcEndCondition, tcItemEndCondition, tlDescending
			THROW_EXCEPTION

		Endtry

		Return .T.

	Endfunc && Recursive

	* Reverse
	* Devuelve la colección ordenada en forma inversa.
	Function Reverse() As CollectionBase Of Tools\Namespaces\Prg\ObjectNamespace.Prg HelpString 'Devuelve la colección ordenada en forma inversa.'

		Local loColRet As Collection, ;
			loErr As Exception

		#If .F.
			TEXT
				 *:Help Documentation
				 *:Project:
				 Sistemas Praxis
				 *:Autor:
				 Damian Eiff
				 *:Date:
				 Miercoles 12 de Agosto de 2009
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

			loColRet = This.GetTop ( This.Count, 1, -1 )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry

		Return m.loColRet

	Endproc && Reverse

Enddefine && CollectionBase
