#include 'Tools\namespaces\include\foxpro.h'
#include 'Tools\namespaces\include\system.h'

#If .F.
	Do 'Tools\namespaces\prg\ObjectNamespace.prg'
#Endif

* Dictionary (Class)
* Implementacion de un array asociativo
*
* Autor: Victor Espina
* Fecha: Abril 2012
*
* Uso:
* LOCAL oDict
* oDict = CREATE("Dictionary")
* oDict.Add("nombre","VICTOR")
* oDict.Add("apellido","ESPINA")
* ?oDict.Values["nombre"] --> "VICTOR"
*
* IF oDict.containsKey("apellido")
*  oDict.Values["apellido"] = "SARCOS"
* ENDIF
*
* FOR i = 1 TO oDict.Count
*  ?oDict.Keys[i], oDict.Values[i]
* ENDFOR
*
* oCopy = oDict.Clone()
* ?oCopy.Values["apellido"] --> "SARCOS"

* Dictionary 
Define Class Dictionary As NamespaceBase Of Tools\namespaces\prg\ObjectNamespace.prg

	#If .F.
		Local This As Dictionary Of 'Tools\namespaces\prg\objectnamespace.prg

	#Endif

	Dimension Values[ 1 ]
	Dimension Keys[ 1 ]
	Count = 0

	Protected Capacity
	Capacity = 1

	Protected InitCapacity
	InitCapacity = 1

	Protected LastIndex
	LastIndex = 1

	* Init
	Procedure Init ( tnCapacity As Number ) As Void
		If Pcount() == 0
			tnCapacity = 1

		Endif

		Dimension This.Values[ MAX ( 1, m.tnCapacity ) ]
		Dimension This.Keys[ MAX ( 1, m.tnCapacity ) ]

		This.Capacity     = m.tnCapacity
		This.InitCapacity = m.tnCapacity


	Endproc

	* Values_Access
	Function Values_Access ( tvIndex1 As Variant ) As Variant

		Local lnIdx As Number, ;
			lvRet

		If Vartype ( m.tvIndex1 ) == 'N'
			If Between ( m.tvIndex1, 1, This.Count )
				lnIdx = m.tvIndex1

			Else && Between ( m.tvIndex1, 1, This.Count )
				lnIdx = 0

			Endif && Between ( m.tvIndex1, 1, This.Count )

		Else && Vartype( m.tvIndex1 ) == 'N'
			lnIdx = This.GetKeyIndex ( m.tvIndex1 )

		Endif && Vartype( m.tvIndex1 ) == 'N'

		If m.lnIdx # 0
			lvRet = This.Values[ m.lnIdx ]

		Else && m.lnIdx # 0
			Error 11

		Endif && m.lnIdx # 0

		Return m.lvRet

	Endfunc

	* Values_Assign
	Procedure Values_Assign ( tcNewVal As Variant, tvIndex1 As Variant )

		Local lnIdx As Number

		If Vartype ( m.tvIndex1 ) == 'N'
			If Between ( m.tvIndex1, 1, This.Count )
				lnIdx = m.tvIndex1

			Else && Between ( m.tvIndex1, 1, This.Count )
				lnIdx = 0

			Endif && Between ( m.tvIndex1, 1, This.Count )

		Else && Vartype( m.tvIndex1 ) == 'N'
			lnIdx = This.GetKeyIndex ( m.tvIndex1 )

		Endif && Vartype( m.tvIndex1 ) == 'N'

		If m.lnIdx # 0
			This.Values[ m.lnIdx ] = m.tcNewVal

		Else && m.lnIdx # 0
			Error 11

		Endif && m.lnIdx # 0

	Endproc

	* GetKeyIndex
	Protected Function GetKeyIndex ( tcKey As String ) As Number

		Local llFound As Boolean, ;
			lnCnt As Number, ;
			lnIdx As Number

		llFound = .F.
		lnIdx   = 1
		lnCnt   = This.Count
		Do While ! m.llFound And m.lnIdx <= m.lnCnt
			llFound = ( This.Keys[ m.lnIdx ] == m.tcKey )
			If ! m.llFound
				lnIdx = m.lnIdx + 1

			Endif  && ! m.llFound

		Enddo && ! m.llResult And m.lnIdx <= m.lnCnt

		Return Iif ( m.llFound, m.lnIdx, 0 )

	Endfunc

	* Clear
	Procedure Clear()

		* Clear
		* Elimina el contenido de la clase
		*
		This.LastIndex = 1
		Dimension This.Values[ This.Capacity ]
		Dimension This.Keys [ This.Capacity ]
		This.Count = 0

	Endproc

	* Add
	Procedure Add ( tuValue As Variant, tcKey As String ) As Void

		* Add
		* Incluye un nuevo item en el diccionario

		If ! This.ContainsKey ( m.tcKey )

			* Verifica la capacidad de almacenamiento del Diccionario
			* Si se lleno incrementa la capacidad
			If This.LastIndex == This.Capacity
				* Duplica la capacidad dde alamacenamiento
				This.Capacity = This.Capacity * 2
				* Incrementa los arrays
				Dimension This.Values[ This.Capacity ]
				Dimension This.Keys[ This.Capacity ]

			Endif && This.LastIndex == This.Capacity

			* Incremento la cantidad de elementos
			This.Count = This.Count + 1
			* Asigno los valores
			This.Values[ This.LastIndex ] = m.tuValue
			This.Keys[ This.LastIndex ]   = m.tcKey

			This.LastIndex = This.LastIndex + 1

		Endif && ! This.ContainsKey( m.tcKey )

	Endproc

	* ContainsKey
	Function ContainsKey ( tcKey As String ) As Boolean
		* containsKey
		* Permite determinar si existe un item registrado
		* con la clase indicada
		*
		Local llResult As Boolean, ;
			lnCnt As Number, ;
			lnIdx As Number
		llResult = .F.
		lnIdx    = 1
		lnCnt    = This.Count
		Do While ! m.llResult And m.lnIdx <= m.lnCnt
			llResult = ( This.Keys[ m.lnIdx ] == m.tcKey )
			lnIdx    = m.lnIdx + 1

		Enddo && ! m.llResult And m.lnIdx <= m.lnCnt

		Return m.llResult

	Endproc

	* GetKeys
	Function GetKeys ( paTarget As Variant @ ) As Boolean
		* getKeys
		* Copia en un array la lista de claves registradas

		Local lnRet As Number

		If This.Count # 0

			Dimension paTarget[ This.Count ]
			Acopy ( This.Keys, paTarget, 1, This.Count, 1 )
			lnRet = This.Count

		Else && This.Count # 0
			lnRet = 0

		Endif && This.Count # 0

		Return m.lnRet

	Endfunc

	* GetCapacity
	Function GetCapacity() As Number
		Return This.Capacity

	Endfunc

	* GetInitCapacity
	Function GetInitCapacity () As Number
		Return This.InitCapacity

	Endfunc

	* Clone
	Function Clone() As Dictionary Of Tools\namespaces\prg\ObjectNamespace.prg

		* Clone
		* Devuelve una copia del diccionario con todo su contenido
		*
		Local lnIdx As Number, ;
			loClone As Dictionary Of Tools\namespaces\prg\ObjectNamespace.prg

		* loClone = Newobject ( This.Class, This.ClassLibrary )
		loClone = _Newobject ( This.Class, This.ClassLibrary )

		For lnIdx = 1 To This.Count
			m.loClone.Add (This.Keys[ m.lnIdx ], This.Values[ m.lnIdx ] )

		Endfor

		Return m.loClone

	Endfunc

EndDefine && Dictionary 