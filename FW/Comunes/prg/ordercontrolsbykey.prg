*!*	Esta funcion devuelve los objetos contenidos en un contenedor como una
*!*	colección ordenada por la propiedad TabIndex, o alguna otra propiedad
*!*	que se le indique por parámetros. (Debe ser numerica)
*!*	Filtra aquellos objetos que esten invisibles y no tengan una propiedad
*!*	lKeepPlace en .T.

Lparameters oCnt As Object,;
	cProperty As String

Local loCol As Collection
Local llOk As Boolean

Try

	loCol = NewObject( "PrxCollection", "PrxBaseLibrary.prg" )
	If Empty( cProperty )
		cProperty = "TabIndex"
	Endif

	Local lnObjsCount As Integer
	Local loObj As Object

	* Armar un Array ordenado por la propiedad cProperty
	lnObjsCount = oCnt.Objects.Count

	loObj = Null

	If !Empty( lnObjsCount )

		Local laObjs[ lnObjsCount ]

		For Each loObj In oCnt.Objects
			llOk = Iif( Pemstatus( loObj, "lAutoSetup", 5 ), loObj.lAutoSetup, .F. )
			If llOk
				llOk = loObj.Visible .Or. ;
					Iif( Pemstatus( loObj, "lKeepPlace", 5 ), loObj.lKeepPlace, .F. )
			Endif

			If llOk
				Try
					laObjs[ loObj.&cProperty ] = loObj
				Catch
				Endtry
			Endif

		Endfor

		loObj = Null

		For Each loObj In laObjs
			If !IsEmpty( loObj )
				loCol.AddItem( loObj )
			Endif
		Endfor
	Endif

Catch To oErr
	Throw oErr

Finally
	loObj = Null

Endtry

Return loCol

