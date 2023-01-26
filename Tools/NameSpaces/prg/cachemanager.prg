
#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

External Array loCol

If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
	Do 'Tools\namespaces\prg\CollectionBase.prg'
Endif

* CacheManager
Define Class CacheManager As ObjectBase Of Tools\namespaces\prg\ObjectNamespace.prg 

	#If .F.
		Local This As CacheManager Of Tools\namespaces\prg\CacheManager.prg
	#Endif

	* AddObject
	Hidden Function AddObject
	Endfunc && AddObject

	* AddProperty
	Hidden Function AddProperty
	Endfunc && AddProperty

	* New
	Hidden Function New
	Endfunc && New

	* Newobject
	Hidden Function Newobject
	Endfunc && Newobject

	* ReadExpression
	Hidden Function ReadExpression
	Endfunc && ReadExpression

	* ReadMethod
	Hidden Function ReadMethod
	Endfunc && ReadMethod

	* RemoveObject
	Hidden Function RemoveObject
	Endfunc && RemoveObject

	* ResetToDefault
	Hidden Function ResetToDefault
	Endfunc && ResetToDefault

	* SaveAsClass
	Hidden Function SaveAsClass
	Endfunc && SaveAsClass

	* WriteExpression
	Hidden Function WriteExpression
	Endfunc && WriteExpression

	* WriteMethod
	Hidden Function WriteMethod
	Endfunc && WriteMethod

	*-- XML Metadata for customizable properties
	Protected _MemberData
	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] ;
		+ [<VFPData>] ;
		+ [<memberdata name="ocolobjects" type="property" display="oColObjects" />] ;
		+ [<memberdata name="get" type="method" display="Get" />] ;
		+ [<memberdata name="add" type="method" display="Add" />] ;
		+ [</VFPData>]

	Protected oColObjects
	oColObjects = Null

	Procedure Init
		Local loErr As Exception

		Try
			DoDefault()

			This.oColObjects  = _Newobject ( 'CollectionBase', 'Tools\namespaces\prg\CollectionBase.prg' )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION
			THROW_EXCEPTION

		Endtry
	Endproc

	*!*	* oColObjects_Access
	*!*	Protected Function oColObjects_Access() As CollectionBase Of NameSpaces\prg\ObjectNamespace.prg

	*!*		Local loErr As Exception

	*!*		Try
	*!*			* With This As CacheManager Of NameSpaces\prg\CacheManager.prg
	*!*				If Vartype ( This.oColObjects ) # 'O'
	*!*					This.oColObjects  = Newobject ( 'CollectionBase', 'NameSpaces\prg\CollectionBase.prg' )

	*!*				Endif && Vartype( .oColObjects ) # 'O'

	*!*			* Endwith

	*!*		Catch To loErr
	*!*			DEBUG_CLASS_EXCEPTION
	*!*			THROW_EXCEPTION

	*!*		Endtry

	*!*		Return This.oColObjects

	*!*	Endfunc && oColObjects_Access

	Dimension Add_COMATTRIB[ 5 ]
	Add_COMATTRIB[ 1 ] = 0
	Add_COMATTRIB[ 2 ] = 'Agrega un elemento al cache.'
	Add_COMATTRIB[ 3 ] = 'Add'
	Add_COMATTRIB[ 4 ] = 'Void'
	* Add_COMATTRIB[ 5 ] = 0

	* Add
	* Agrega un elemento al cache.
	Procedure Add ( toObject As Object, tcKey As String ) As Void HelpString 'Agrega un elemento al cache.'

		Local loBag As Object, ;
			loErr As Exception, ;
			loColObjects As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg

		Try

			loColObjects = This.oColObjects
			loBag = m.Object.CreateObjParam ( 'vValue', m.toObject, 'cKey', m.tcKey, 'Added', Datetime(), 'LastAccess', Datetime() )
			loColObjects.AddItem ( m.loBag, m.tcKey )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toObject, tcKey
			THROW_EXCEPTION

		Finally
			loColObjects = Null
			loBag = Null

		Endtry

	Endproc && Add

	Dimension Clean_COMATTRIB[ 5 ]
	Clean_COMATTRIB[ 1 ] = 0
	Clean_COMATTRIB[ 2 ] = 'Elimina todos los elementos del cache.'
	Clean_COMATTRIB[ 3 ] = 'Clean'
	Clean_COMATTRIB[ 4 ] = 'Void'
	* Clean_COMATTRIB[ 5 ] = 0

	* Clean
	* Elimina todos los elementos del cache.
	Procedure Clean() As Void HelpString 'Elimina todos los elementos del cache.'

		This.oColObjects.Clear()

	Endproc && Clean

	Dimension Exists_COMATTRIB[ 5 ]
	Exists_COMATTRIB[ 1 ] = 0
	Exists_COMATTRIB[ 2 ] = 'Devuelve .T. si existe el elemento en el cache con la clave dada.'
	Exists_COMATTRIB[ 3 ] = 'Exists'
	Exists_COMATTRIB[ 4 ] = 'Boolean'
	* Exists_COMATTRIB[ 5 ] = 0

	* Exists
	* Devuelve .T. si existe el elemento en el cache con la clave dada.
	Function Exists ( tcKey As String ) As Boolean HelpString 'Devuelve .T. si existe el elemento en el cache con la clave dada.'

		Local lcKey As String, ;
			llOk As Boolean, ;
			lnCnt As Number, ;
			lnIdx As Integer, ;
			loBag As Object, ;
			loCol As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg, ;
			loErr As Exception

		Try

			loCol = This.oColObjects
			lnCnt = m.loCol.Count
			lnIdx = 1
			If m.lnCnt > 0
				Do While ! m.llOk And m.lnIdx <= m.lnCnt
					lcKey = m.loCol.GetKey ( m.lnIdx )
					loBag = m.loCol[ m.lcKey ]
					llOk  = ( m.loBag.cKey == m.tcKey )
					lnIdx = m.lnIdx + 1

				Enddo

			Endif &&  m.lnCnt > 0

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcKey
			THROW_EXCEPTION

		Finally
			loCol = Null
			loBag = Null

		Endtry

		Return m.llOk

	Endfunc && Exists

	Dimension Get_COMATTRIB[ 5 ]
	Get_COMATTRIB[ 1 ] = 0
	Get_COMATTRIB[ 2 ] = 'Devuelve un elemento del cache.'
	Get_COMATTRIB[ 3 ] = 'Get'
	Get_COMATTRIB[ 4 ] = 'Object'
	* Get_COMATTRIB[ 5 ] = 0

	* Get
	* Devuelve un elemento del cache.
	Function Get ( tcKey As String ) As Object HelpString 'Devuelve un elemento del cache.'

		Local loBag As Object, ;
			loErr As Exception, ;
			loItem As Object, ;
			loColObjects As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg

		Try
			loItem = Null
			loColObjects = This.oColObjects
			loBag = loColObjects.GetItem ( m.tcKey )
			If ! Isnull ( m.loBag )
				loItem = m.loBag.vValue

			Endif && ! Isnull ( m.loBag )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcKey
			THROW_EXCEPTION

		Finally
			loColObjects = Null

		Endtry

		Return m.loItem

	Endfunc && Get

	Dimension Keys_COMATTRIB[ 5 ]
	Keys_COMATTRIB[ 1 ] = 0
	Keys_COMATTRIB[ 2 ] = 'Devuelve por refrerencia la lista de claves de los elementos almacenados en el cahce.'
	Keys_COMATTRIB[ 3 ] = 'Keys'
	Keys_COMATTRIB[ 4 ] = 'Void'
	* Keys_COMATTRIB[ 5 ] = 0

	* Keys
	* Devuelve por refrerencia la lista de claves de los elementos almacenados en el cahce.
	Procedure Keys ( taKeys As Variant @ ) As Void

		Local liCnt As Integer, ;
			lnIdx As Integer, ;
			loBag As Object, ;
			loCol As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg, ;
			loErr As Exception

		Try
			loCol = This.oColObjects
			liCnt = m.loCol.Count
			If m.liCnt > 0
				lnIdx = 1
				Dimension taKeys[ m.liCnt ] As String
				For Each m.loBag In m.loCol FoxObject
					= Ains ( taKeys, m.lnIdx )
					taKeys[ m.lnIdx ] = m.loBag.cKey
					lnIdx             = m.lnIdx + 1

				Endfor

			Endif && m.liCnt > 0

		Catch To loErr
			DEBUG_CLASS_EXCEPTION

		Finally
			loCol = Null
			loBag = Null

		Endtry

	Endproc && Keys

	Dimension Remove_COMATTRIB[ 5 ]
	Remove_COMATTRIB[ 1 ] = 0
	Remove_COMATTRIB[ 2 ] = 'Devuelve el elemento que se elimina del cache. Si el elemento no existe lanza un error.'
	Remove_COMATTRIB[ 3 ] = 'Remove'
	Remove_COMATTRIB[ 4 ] = 'Object'
	* Remove_COMATTRIB[ 5 ] = 0

	* Remove
	* Devuelve el elemento que se elimina del cache. Si el elemento no existe lanza un error.
	Function Remove ( tcKey As String ) As Object HelpString 'Devuelve el elemento que se elimina del cache. Si el elemento no existe lanza un error.'

		Local loErr As Exception, ;
			loItem As Object, ;
			loItemAux As Object, ;
			loColObjects  As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg

		Try

			loColObjects = This.oColObjects
			loItemAux = loColObjects.RemoveItem ( m.tcKey )
			If Vartype ( m.loItemAux ) == 'O' And ! Isnull ( m.loItemAux )
				loItem = m.loItemAux.vValue

			Else && Vartype ( m.loItemAux ) == 'O' And ! Isnull ( m.loItemAux )
				Error 'Invalid Key: ' + m.tcKey

			Endif && Vartype ( m.loItemAux ) == 'O' And ! Isnull ( m.loItemAux )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcKey
			THROW_EXCEPTION

		Finally
			loColObjects = Null

		Endtry

		Return m.loItem

	Endfunc && Remove

	Dimension RemoveSafe_COMATTRIB[ 5 ]
	RemoveSafe_COMATTRIB[ 1 ] = 0
	RemoveSafe_COMATTRIB[ 2 ] = 'Devuelve el elemento que se elimina del cache.'
	RemoveSafe_COMATTRIB[ 3 ] = 'RemoveSafe'
	RemoveSafe_COMATTRIB[ 4 ] = 'Object'
	* RemoveSafe_COMATTRIB[ 5 ] = 0

	* RemoveSafe
	* Devuelve el elemento que se elimina del cache.
	Function RemoveSafe ( tcKey As String ) As Object

		Local loErr As Exception, ;
			loItem As Object, ;
			loItemAux As Object, ;
			loColObjects As CollectionBase Of Tools\namespaces\prg\CollectionBase.prg

		Try

			loColObjects = This.oColObjects
			loItemAux = loColObjects.RemoveItem ( m.tcKey )
			If Vartype ( m.loItemAux ) == 'O' And ! Isnull ( m.loItemAux )
				loItem = m.loItemAux.vValue

			Endif && Vartype ( m.loItemAux ) == 'O' And ! Isnull ( m.loItemAux )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, tcKey
			THROW_EXCEPTION

		Finally
			loColObjects = Null

		Endtry

		Return m.loItem

	Endfunc && RemoveSafe

	Dimension Update_COMATTRIB[ 5 ]
	Update_COMATTRIB[ 1 ] = 0
	Update_COMATTRIB[ 2 ] = 'Actualiza un elemento del cache.'
	Update_COMATTRIB[ 3 ] = 'Update'
	Update_COMATTRIB[ 4 ] = 'Void'
	* Update_COMATTRIB[ 5 ] = 0

	* Update
	* Actualiza un elemento del cache.
	Procedure Update ( toObject As Object, tcKey As String ) As Void HelpString 'Actualiza un elemento del cache.'

		Local loBag As Object, ;
			loErr As Exception,;
			loColObjects As CollectionBase Of 'Tools\namespaces\prg\objectnamespace.prg'

		Try
			m.loColObjects = This.oColObjects
			loBag = m.loColObjects .GetItem ( m.tcKey )
			If ! Isnull ( m.loBag )
				loBag.vValue     = m.toObject
				loBag.LastAccess = Datetime()

			Else && ! Isnull ( m.loBag )
				Error 'Invalid Key: ' + m.tcKey

			Endif && ! Isnull ( m.loBag )

		Catch To loErr
			DEBUG_CLASS_EXCEPTION, toObject, tcKey
			THROW_EXCEPTION

		Finally
			m.loColObjects = Null

		Endtry

	Endproc && Update

	* Destroy
	Protected Procedure Destroy() As Void
		This.oColObjects = Null
		DoDefault()

	Endproc && Destroy

Enddefine && CacheManager