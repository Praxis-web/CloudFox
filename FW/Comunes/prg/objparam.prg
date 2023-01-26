*
* Crea un objeto para pasar como parametro

* Sintaxis:
*		Text To cPropertiesList NoShow TextMerge Pretext 15
*		FechaInicial=Date();
*		ValorMaximo = 25*15 + 350;
*		WhereCondition = "PrivinciaId = 324";
*		OrderBy = "Descripcion";
*		nNivel = 1
*		EndText

* La propiedad debe estar separada del valor por el signo "="
* Cada nueva propiedad debe estar separada por el signo ";"

* Se puede pasar un segundo parametro con un objeto, al que se le hace un merge con las propiedades
* pasadas por string

Procedure ObjParam( cPropertiesList As String,;
		oParam As Object ) As Object;
		HELPSTRING "Crea un objeto para pasar como parametro"
	Local lcCommand As String,;
		lcPropertyName As String,;
		lcTupla As String

	Local luValue As Variant

	Local loParametro As Object
	Local lnLen As Integer,;
		i As Integer,;
		j As Integer

	Try

		lcCommand = ""

		If Vartype( oParam ) == "O"
			loParametro = oParam

		Else
			loParametro = Createobject( "Empty" )

		Endif


		lnLen = Getwordcount( cPropertiesList, ";" )

		For i = 1 To lnLen
			lcTupla = Getwordnum( cPropertiesList, i, ";" )
			lcPropertyName = Alltrim( Getwordnum( lcTupla, 1, "=" ))

			j = At( "=", lcTupla, 1 )
			luValue = Alltrim( Substr( lcTupla, j + 1 ) )

			Try

				* RA 2013-07-08(12:57:42) 
				* Evaluate() soporta un máximo de 255 caracteres
				=Evaluate( luValue )

				If Pemstatus( loParametro, lcPropertyName, 5 )
					loParametro.&lcPropertyName = Evaluate( luValue )

				Else
					AddProperty( loParametro, lcPropertyName, Evaluate( luValue ) )

				Endif


			Catch To oErr
				* RA 2013-07-08(13:07:33)
				* Se supone que es un string demasiado largo.
				* Se le sacan las comillas y se iniciañliza la propiedad
				
				luValue = Substr( luValue, 2, Len( luValue ) - 2 )
				
				If Pemstatus( loParametro, lcPropertyName, 5 )
					loParametro.&lcPropertyName = luValue

				Else
					AddProperty( loParametro, lcPropertyName, luValue )

				Endif

			Finally

			Endtry

		Endfor

	Catch To oErr
		Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

		loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
		loError.cRemark = lcCommand
		loError.Process( oErr )
		Throw loError

	Finally

	Endtry

	Return loParametro

Endproc && ObjParam