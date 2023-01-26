#INCLUDE "FW\Comunes\Include\Praxis.h"

Local i As Integer

Local lcCommand As String,;
	lcJSON_Data As String

Local loJSON As prxJSON Of "Tools\JSON\Prg\JSON.prg"
Local loMainCol As Collection,;
	loObj As Object



Try

	lcCommand = ""
	*Set Step On


	loJSON = Newobject( "prxJSON", "Tools\JSON\Prg\JSON.prg" )
	loJSON.lDebug = .T.

	TEXT To lcMsg NoShow TextMerge Pretext 03
{
    "codigo": [
        "Ya existe un/a condicion_ iva con este/a codigo."
    ],
    "nombre": [
        "Este campo no puede estar en blanco."
    ],
    "nombre_abreviado": [
        "Asegúrese de que este campo no tenga más de 3 caracteres."
    ]
}
	ENDTEXT

	TEXT To lcMsg NoShow TextMerge Pretext 03
{
    "Errores": [
        "Exception Type: IntegrityError at /archivos/apis/Grupo/.",
        "Exception Value: llave duplicada viola restricción de unicidad «unique grupo»",
        "DETAIL:  Ya existe la llave (cliente_praxis_id, codigo)=(1, 301)."
    ]
}

	EndText
	
	Text To lcMsg NoShow TextMerge Pretext 03
	[{"id":101,"ts":"2021-11-18T13:53:18.235497-03:00","uts":"2021-11-18T13:53:18.235497-03:00","borrado":false,"nombre":"RIEGO","descripcion":"","activo":true,"orden":999,"es_sistema":false,"codigo":"104","cliente_praxis":1,"empresa":1},{"id":102,"ts":"2021-11-18T13:53:18.274563-03:00","uts":"2021-11-18T13:53:18.274563-03:00","borrado":false,"nombre":"MUEBLES PEARCE","descripcion":"","activo":true,"orden":105,"es_sistema":false,"codigo":"105","cliente_praxis":1,"empresa":1},{"id":103,"ts":"2021-11-18T13:53:18.312640-03:00","uts":"2021-11-18T13:53:18.312640-03:00","borrado":false,"nombre":"LATYNPERT","descripcion":"","activo":true,"orden":106,"es_sistema":false,"codigo":"106","cliente_praxis":1,"empresa":1},{"id":104,"ts":"2021-11-18T13:53:18.350701-03:00","uts":"2021-11-18T13:53:18.350701-03:00","borrado":false,"nombre":"CERAMICA ARTESANAL","descripcion":"","activo":true,"orden":107,"es_sistema":false,"codigo":"107","cliente_praxis":1,"empresa":1},{"id":105,"ts":"2021-11-18T13:53:18.388794-03:00","uts":"2021-11-18T13:53:18.388794-03:00","borrado":false,"nombre":"TRANSPAR","descripcion":"","activo":true,"orden":108,"es_sistema":false,"codigo":"108","cliente_praxis":1,"empresa":1},{"id":106,"ts":"2021-11-18T13:53:18.426871-03:00","uts":"2021-11-18T13:53:18.426871-03:00","borrado":false,"nombre":"REAL BORDES SRL","descripcion":"","activo":true,"orden":109,"es_sistema":false,"codigo":"109","cliente_praxis":1,"empresa":1},{"id":107,"ts":"2021-11-18T13:53:18.465911-03:00","uts":"2021-11-18T13:53:18.465911-03:00","borrado":false,"nombre":"PIAZZA","descripcion":"","activo":true,"orden":110,"es_sistema":false,"codigo":"110","cliente_praxis":1,"empresa":1},{"id":108,"ts":"2021-11-18T13:53:18.503030-03:00","uts":"2021-11-18T13:53:18.503990-03:00","borrado":false,"nombre":"FUSION","descripcion":"","activo":true,"orden":111,"es_sistema":false,"codigo":"111","cliente_praxis":1,"empresa":1},{"id":109,"ts":"2021-11-18T13:53:18.540125-03:00","uts":"2021-11-18T13:53:18.540125-03:00","borrado":false,"nombre":"MATERIAL","descripcion":"","activo":true,"orden":200,"es_sistema":false,"codigo":"200","cliente_praxis":1,"empresa":1},{"id":110,"ts":"2021-11-18T13:53:18.581129-03:00","uts":"2021-11-18T13:53:18.581129-03:00","borrado":false,"nombre":"NOVUM","descripcion":"","activo":true,"orden":150,"es_sistema":false,"codigo":"150","cliente_praxis":1,"empresa":1}]	
	EndText


	lcJSON_Data = lcMsg

	Set Step On
	loErrores = loJSON.JsonToVfp( Alltrim( lcJSON_Data ) )

	lnLen = Amembers( laErrores, loErrores )
	For i = 1 To lnLen

		lcProperty = laErrores[ i ]
		*loColErrors = loErrores.&lcProperty

		loColErrors = Evaluate( "loErrores." + lcProperty )

		If Vartype( loColErrors ) = "O"
			If loColErrors.Class = "Collection"
				For Each lcStr In loColErrors
					TEXT To lcMsg NoShow TextMerge Pretext 03
					<<lcProperty>>: <<lcStr>>
					ENDTEXT

					Warning( lcMsg )

				Endfor

			Endif

		Endif

		*<<Evaluate( loErrores + "." + <<laErrores[ i ]>>


	Endfor



Catch To loErr

	Do While Vartype( loErr.UserValue ) == "O"
		loErr = loErr.UserValue
	Enddo

	lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  METODO   ] " + loErr.Procedure + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  LINEA Nº ] " + Transform(loErr.Lineno) + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  COMANDO  ] " + loErr.LineContents + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  ERROR    ] " + Transform(loErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  MENSAJE  ] " + loErr.Message + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  DETALLE  ] " + loErr.Details + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
	lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )

	Messagebox( lcMsg, 16, "Error", 0 )

	Strtofile( lcMsg, "Error_Json.txt" )


Finally

	loJSON = Null

	Messagebox( "Terminado" )

Endtry

*!* ///////////////////////////////////////////////////////
*!* Class.........: prxJSON
*!* Description...:
*!* Date..........: Jueves 28 de Julio de 2016 (09:45:10)
*!*
*!*

Define Class prxJSON As Custom

	#If .F.
		Local This As prxJSON Of "Tools\JSON\Prg\JSON.prg"
	#Endif

	cError_Msg 	= ""
	lDebug 		= .F.
	*lDebug 		= .T.
	
	* 
lDone = .F.

	_MemberData = [<?xml version="1.0" encoding="Windows-1252" standalone="yes"?>] + ;
		[<VFPData>] + ;
		[<memberdata name="ldebug" type="property" display="lDebug" />] + ;
		[<memberdata name="jsontovfp" type="method" display="JsonToVfp" />] + ;
		[<memberdata name="validateinput" type="method" display="ValidateInput" />] + ;
		[<memberdata name="vfptojson" type="method" display="VfpToJson" />] + ;
		[<memberdata name="collectiontojson" type="method" display="CollectionToJson" />] + ;
		[<memberdata name="valuetojson" type="method" display="ValueToJson" />] + ;
		[<memberdata name="getnewobject" type="method" display="GetNewObject" />] + ;
		[<memberdata name="addnewproperty" type="method" display="AddNewProperty" />] + ;
		[<memberdata name="getvalue" type="method" display="GetValue" />] + ;
		[<memberdata name="insertescapechar" type="method" display="InsertEscapeChar" />] + ;
		[<memberdata name="getcollectionitems" type="method" display="GetCollectionItems" />] + ;
		[<memberdata name="cerror_msg" type="property" display="cError_Msg" />] + ;
		[<memberdata name="forcedate" type="method" display="ForceDate" />] + ;
		[<memberdata name="ldone" type="property" display="lDone" />] + ;
		[</VFPData>]


	*
	*
	Procedure JsonToVfp( cJson_Str As String,;
			lSilence As Boolean ) As Void
		Local lcCommand As String,;
			lcJSON_Str As String,;
			lcExact As String,;
			lcDate As String,;
			lcCentury As String,;
			lcMsg As String

		Local loVfp_Obj As Object
		Local lcToken As Character
		Local llDone As Boolean

		Dimension aEscChar[ 8, 3 ]

		Try

			lcCommand = ""

			lcExact = Set("Exact")
			lcDate = Set("Date")
			lcCentury = Set("Century")

			Set Exact On
			Set Date YMD
			Set Century On

			aEscChar[ 1, 1 ] = "<#<" + StrZero( Asc( ["] ), 3 ) + ">#>"
			aEscChar[ 1, 2 ] = ["]
			aEscChar[ 1, 3 ] = [\"]

			aEscChar[ 2, 1 ] = "<#<" + StrZero( Asc( ['] ), 3 ) + ">#>"
			aEscChar[ 2, 2 ] = [']
			aEscChar[ 2, 3 ] = [\']

			aEscChar[ 3, 1 ] = "<#<" + StrZero( Asc( Tab ), 3 ) + ">#>"
			aEscChar[ 3, 2 ] = Tab
			aEscChar[ 3, 3 ] = [\t]

			aEscChar[ 4, 1 ] = "<#<" + StrZero( Asc( LF ), 3 ) + ">#>"
			aEscChar[ 4, 2 ] = LF
			aEscChar[ 4, 3 ] = [\n]

			aEscChar[ 5, 1 ] = "<#<" + StrZero( Asc( CR ), 3 ) + ">#>"
			aEscChar[ 5, 2 ] = CR
			aEscChar[ 5, 3 ] = [\r]

			aEscChar[ 6, 1 ] = "<#<" + StrZero( Asc( FF ), 3 ) + ">#>"
			aEscChar[ 6, 2 ] = FF
			aEscChar[ 6, 3 ] = [\f]

			aEscChar[ 7, 1 ] = "<#<" + StrZero( Asc( [\] ), 3 ) + ">#>"
			aEscChar[ 7, 2 ] = [\]
			aEscChar[ 7, 3 ] = [\\]

			aEscChar[ 8, 1 ] = "<#<" + StrZero( Asc( BS ), 3 ) + ">#>"
			aEscChar[ 8, 2 ] = BS
			aEscChar[ 8, 3 ] = [\b]


			lcJSON_Str = This.ValidateInput( cJson_Str )

			lcToken = Substr( lcJSON_Str, 1, 1 )

			loVfp_Obj = Createobject( "Empty" )
			AddProperty( loVfp_Obj, "cJson_Str", lcJSON_Str )

			If Inlist( lcToken, "{", "[" )
				loVfp_Obj = This.GetNewObject( lcJSON_Str, loVfp_Obj, .T. )

			Else
				TEXT To lcMsg NoShow TextMerge Pretext 03
				Debia recibir ( { ) o ( [ ) y recibi ( <<lcToken>> )
				ENDTEXT

				This.cError_Msg = lcMsg

				lcCommand = lcMsg + CRLF + CRLF + loVfp_Obj.cJson_Str
				Error Program() + " - Caracter No Válido"

			Endif

		Catch To loErr

			If This.lDebug
				Set Step On
			Endif

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr, .F. )
			*Throw loError

			If !Pemstatus( loVfp_Obj, "cErrorDescription", 5 )
				AddProperty( loVfp_Obj, "cErrorDescription", "" )
			Endif

			loVfp_Obj.cErrorDescription = loError.cErrorDescrip

		Finally
			Set Exact &lcExact
			Set Date &lcDate
			Set Century &lcCentury

			AddProperty( loVfp_Obj, "l_oVfp_Ok", .F. )

			If !Pemstatus( loVfp_Obj, "cErrorDescription", 5 )
				loVfp_Obj.l_oVfp_Ok = .T.
			Endif


		Endtry

		Return loVfp_Obj

	Endproc && JsonToVfp




	*
	*
	Procedure ValidateInput( cJson_Str As String ) As String
		Local lcCommand As String,;
			lcJSON_Str As String

		Local i As Integer

		Try

			lcCommand = ""
			lcJSON_Str = Alltrim( cJson_Str )
			lcJSON_Str = Strtran( lcJSON_Str, CR, "" )
			lcJSON_Str = Strtran( lcJSON_Str, LF, "" )

			* Escape Char

			For i = 1 To Alen( aEscChar, 1 )
				lcJSON_Str = Strtran( lcJSON_Str, aEscChar[ i, 3 ], aEscChar[ i, 1 ] )
			Endfor

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lcJSON_Str

	Endproc && ValidateInput



	*
	* Recibe un objeto VFP y lo devuelve  en JSON
	Procedure VfpToJson( oObj As Object ) As String ;
			HELPSTRING "Recibe un objeto VFP y lo devuelve  en JSON"
		Local lcCommand As String,;
			lcJSON_Str As String,;
			lcName As String,;
			lcExact As String,;
			lcDate As String,;
			lcCentury As String

		Local lnLen As Integer,;
			i As Integer

		Local luValue As Variant
		Local loObj As Object
		Local lcVarType As Character

		Local Array laProperties[ 1 ]

		Try

			lcCommand = ""

			lcExact = Set("Exact")
			lcDate = Set("Date")
			lcCentury = Set("Century")

			Set Exact On
			Set Date YMD
			Set Century On

			If Vartype( oObj ) # "O"
				Error "No se recibió un Objeto"
			Endif

			If Pemstatus( oObj, "BaseClass", 5 ) ;
					And Upper( oObj.BaseClass ) = "COLLECTION"

				lcJSON_Str = This.CollectionToJson( oObj )

			Else
				lcJSON_Str = "{"

				lnLen = Amembers( laProperties, oObj, 0 )

				For i = 1 To lnLen

					If i > 1
						lcJSON_Str = lcJSON_Str + ","
					Endif

					lcName = Lower( laProperties[ i ] )
					luValue = Evaluate( "oObj." + lcName )

					lcJSON_Str = lcJSON_Str + ["] + lcName + [":] + This.ValueToJson( luValue )

				Endfor

				lcJSON_Str = lcJSON_Str + "}"

			Endif


		Catch To loErr

			If This.lDebug
				Set Step On
			Endif

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Set Exact &lcExact
			Set Date &lcDate
			Set Century &lcCentury

		Endtry

		Return lcJSON_Str

	Endproc && VfpToJson


	*
	*
	Procedure CollectionToJson( oCollection As Collection ) As Void
		Local lcCommand As String,;
			lcJSON_Str As String

		Local lnLen As Integer,;
			i As Integer

		Local luValue As Variant
		Local loObj As Object
		Local lcVarType As Character


		Try

			lcCommand = ""
			lcJSON_Str = "["

			lnLen = oCollection.Count

			For i = 1 To lnLen

				If i > 1
					lcJSON_Str = lcJSON_Str + ","
				Endif

				luValue = oCollection.Item( i )

				lcJSON_Str = lcJSON_Str + This.ValueToJson( luValue )

			Endfor

			lcJSON_Str = lcJSON_Str + "]"


		Catch To loErr

			If This.lDebug
				Set Step On
			Endif

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lcJSON_Str

	Endproc && CollectionToJson



	*
	*
	Procedure ValueToJson( uValue As Variant ) As String
		Local lcCommand As String,;
			lcStr As String,;
			lcVarType As String

		Try

			lcCommand = ""

			lcVarType = Vartype( uValue )

			If lcVarType = "O"
				loObj = uValue

				If Pemstatus( loObj, "BaseClass", 5 ) ;
						And Upper( loObj.BaseClass ) = "COLLECTION"

					lcStr = This.CollectionToJson( loObj )

				Else
					lcStr = This.VfpToJson( loObj )

				Endif

			Else
				Do Case
					Case Inlist( lcVarType, "C", "M", "G", "Q" )
						lcStr = ["] + Strtran( uValue, ["], ['] ) + ["]

					Case Inlist( lcVarType, "D" )
						lcStr = ["] + Transform( Dtos( uValue ), "@R 9999-99-99" ) + ["]

					Case Inlist( lcVarType, "T" )
						lcStr = ["] + Transform( Ttoc( uValue,3 )) + ["]

					Case Inlist( lcVarType, "L" )
						lcStr = Iif( uValue, "true", "false" )

					Case Inlist( lcVarType, "N", "Y" )
						lcStr = Transform( uValue )

					Otherwise
						lcStr = "null"

				Endcase

			Endif


		Catch To loErr

			If This.lDebug
				Set Step On
			Endif

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return lcStr

	Endproc && ValueToJson

	*
	*
	Procedure GetNewObject( cJson_Str As String,;
			oVfp_Obj As Object,;
			lRemoveJson_Str As Boolean ) As Object

		Local lcCommand As String,;
			lcJSON_Str As String

		Local lcToken As Character

		Local loObj As Object

		Try

			lcCommand = ""

			loObj = oVfp_Obj
			lcJSON_Str = Alltrim( cJson_Str )
			lcToken = Substr( lcJSON_Str, 1, 1 )

			If Inlist( lcToken, "{", "[" )

				Do Case
					Case lcToken = "{"

						lcJSON_Str = Alltrim( Substr( cJson_Str, 2 ) )
						lcToken = Substr( lcJSON_Str, 1, 1 )

						If lcToken # "}"
							loObj = Createobject( "Empty" )
							AddProperty( loObj, "cJson_Str", lcJSON_Str )
							
							This.lDone = .F.
							Do While !This.lDone 
							 	loObj = This.AddNewProperty( lcJSON_Str, loObj )
							 	lcJSON_Str = loObj.cJson_Str
							EndDo
							
							oVfp_Obj.cJson_Str = loObj.cJson_Str

							If lRemoveJson_Str
								Removeproperty( loObj, "cJson_Str" )
							Endif

						Else
							loObj = Createobject( "Empty" )

							lcJSON_Str = Alltrim( Substr( cJson_Str, 3 ) )
							oVfp_Obj.cJson_Str = lcJSON_Str

						Endif

					Case lcToken = "["

						* Begin Collection

						lcJSON_Str = Alltrim( cJson_Str )

						loObj = This.GetCollectionItems( lcJSON_Str, oVfp_Obj )
						oVfp_Obj.cJson_Str = loObj.cJson_Str

				Endcase

			Else
				TEXT To lcMsg NoShow TextMerge Pretext 03
				Debia recibir ( { ) o ( [ ) y recibi ( <<lcToken>> )
				ENDTEXT

				lcCommand = lcMsg + CRLF + CRLF + oVfp_Obj.cJson_Str

				Error "Caracter No Válido"

			Endif

		Catch To loErr

			If This.lDebug
				Set Step On
			Endif

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr, .F. )
			Throw loError

		Finally

		Endtry

		Return loObj

	Endproc && GetNewObject

	*
	*
	Procedure xxxGetNewObject( cJson_Str As String,;
			oVfp_Obj As Object,;
			lRemoveJson_Str As Boolean ) As Object

		Local lcCommand As String,;
			lcJSON_Str As String

		Local lcToken As Character

		Local loObj As Object

		Try

			lcCommand = ""

			loObj = oVfp_Obj
			lcJSON_Str = Alltrim( cJson_Str )
			lcToken = Substr( lcJSON_Str, 1, 1 )

			If Inlist( lcToken, "{", "[" )

				Do Case
					Case lcToken = "{"

						lcJSON_Str = Alltrim( Substr( cJson_Str, 2 ) )
						lcToken = Substr( lcJSON_Str, 1, 1 )

						If lcToken # "}"
							loObj = Createobject( "Empty" )
							AddProperty( loObj, "cJson_Str", lcJSON_Str )

							loObj = This.AddNewProperty( lcJSON_Str, loObj )
							oVfp_Obj.cJson_Str = loObj.cJson_Str

							If lRemoveJson_Str
								Removeproperty( loObj, "cJson_Str" )
							Endif

						Else
							loObj = Createobject( "Empty" )

							lcJSON_Str = Alltrim( Substr( cJson_Str, 3 ) )
							oVfp_Obj.cJson_Str = lcJSON_Str

						Endif

					Case lcToken = "["

						* Begin Collection

						lcJSON_Str = Alltrim( cJson_Str )

						loObj = This.GetCollectionItems( lcJSON_Str, oVfp_Obj )
						oVfp_Obj.cJson_Str = loObj.cJson_Str

				Endcase

			Else
				TEXT To lcMsg NoShow TextMerge Pretext 03
				Debia recibir ( { ) o ( [ ) y recibi ( <<lcToken>> )
				ENDTEXT

				lcCommand = lcMsg + CRLF + CRLF + oVfp_Obj.cJson_Str

				Error "Caracter No Válido"

			Endif

		Catch To loErr

			If This.lDebug
				Set Step On
			Endif

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr, .F. )
			Throw loError

		Finally

		Endtry

		Return loObj

	Endproc && xxxGetNewObject


	*
	*
	Procedure AddNewProperty( cJson_Str As String,;
			oVfp_Obj As Object ) As Object
		Local lcCommand As String,;
			lcJSON_Str As String,;
			lcPropertyName As String

		Local lcToken As Character
		Local lvValue As Variant

		Local loObj As Object
		Local llDone As Boolean

		Try

			lcCommand = ""
			
			This.lDone = .T.

			lcJSON_Str = Alltrim( cJson_Str )
			
			If Substr( lcJSON_Str, 1, 2 ) == [",] 
				lcJSON_Str = Alltrim( Substr( lcJSON_Str, 2 ))
			EndIf
			
			If Substr( lcJSON_Str, 1, 2 ) == ["}] 
				lcJSON_Str = Alltrim( Substr( lcJSON_Str, 2 ))
				Set Step On 
			EndIf			
			
			lcToken = Substr( lcJSON_Str, 1, 1 )

			If lcToken = ","
				lcJSON_Str = Alltrim( Substr( lcJSON_Str, 2 ))
				lcToken = Substr( lcJSON_Str, 1, 1 )
			Endif

			If lcToken = '"'

				loObj = oVfp_Obj
				lcPropertyName = Getwordnum( lcJSON_Str, 1, ["] )
				lcPropertyName = Strtran( lcPropertyName, "-", "_" )

				lcJSON_Str = Substr( Ltrim( cJson_Str ), At( ":", cJson_Str ) )
				
				lvValue = This.GetValue( lcJSON_Str, loObj )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				AddProperty( loObj, '<<lcPropertyName>>', lvValue )
				ENDTEXT

				Try

					AddProperty( loObj, lcPropertyName, lvValue )	

				Catch To oErr
					Set Step On 
					Throw oErr

				Finally

				EndTry

				lcJSON_Str = loObj.cJson_Str

				If Inlist( Substr( lcJSON_Str, 1, 1 ), '}' )
					loObj.cJson_Str = Substr( lcJSON_Str, 2 )

				Else
					***This.AddNewProperty( lcJSON_Str, loObj )
					This.lDone = .F.

				Endif

			Else
				loObj = oVfp_Obj
				loObj.cJson_Str = lcJSON_Str

			Endif

		Catch To loErr

			If This.lDebug
				Set Step On
			Endif

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr, .F. )
			Throw loError

		Finally


		Endtry

		Return loObj

	Endproc && AddNewProperty


	*
	*
	Procedure xxxAddNewProperty( cJson_Str As String,;
			oVfp_Obj As Object ) As Object
		Local lcCommand As String,;
			lcJSON_Str As String,;
			lcPropertyName As String

		Local lcToken As Character
		Local lvValue As Variant

		Local loObj As Object
		Local llDone As Boolean

		Try

			lcCommand = ""

			lcJSON_Str = Alltrim( cJson_Str )
			
			If Substr( lcJSON_Str, 1, 2 ) == [",] 
				lcJSON_Str = Alltrim( Substr( lcJSON_Str, 2 ))
			EndIf
			
			lcToken = Substr( lcJSON_Str, 1, 1 )

			If lcToken = ","
				lcJSON_Str = Alltrim( Substr( lcJSON_Str, 2 ))
				lcToken = Substr( lcJSON_Str, 1, 1 )
			Endif

			If lcToken = '"'

				loObj = oVfp_Obj
				lcPropertyName = Getwordnum( lcJSON_Str, 1, ["] )
				lcPropertyName = Strtran( lcPropertyName, "-", "_" )

				lcJSON_Str = Substr( Ltrim( cJson_Str ), At( ":", cJson_Str ) )
				lvValue = This.GetValue( lcJSON_Str, loObj )

				TEXT To lcCommand NoShow TextMerge Pretext 15
				AddProperty( loObj, '<<lcPropertyName>>', lvValue )
				ENDTEXT

				AddProperty( loObj, lcPropertyName, lvValue )

				lcJSON_Str = loObj.cJson_Str

				If Inlist( Substr( lcJSON_Str, 1, 1 ), '}' )
					loObj.cJson_Str = Substr( lcJSON_Str, 2 )

				Else
					This.AddNewProperty( lcJSON_Str, loObj )

				Endif

			Else
				loObj = oVfp_Obj

			Endif

		Catch To loErr

			If This.lDebug
				Set Step On
			Endif

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr, .F. )
			Throw loError

		Finally


		Endtry

		Return loObj

	Endproc && xxxAddNewProperty



	*
	*
	Procedure GetValue( cJson_Str As String,;
			oVfp_Obj As Object  ) As Variant
		Local lcCommand As String,;
			lcJSON_Str As String,;
			lcValue As String,;
			lcDate As String,;
			lcFin as String 

		Local lcToken As Character,;
			lcChar As Character
		Local lvValue As Variant
		Local i As Integer,;
			lnLen As Integer


		Local loObj As Object

		Local llIsDigit As Boolean,;
			llIsChar As Boolean

		Try

			lcCommand = ""

			lcToken = Substr( Ltrim( cJson_Str ), 1, 1 )

			If lcToken = ":"
			
				lcJSON_Str 	= Alltrim(Substr( Ltrim( cJson_Str ), 2 ))
				lcToken 	= Substr( lcJSON_Str, 1, 1 )

				Do Case

					Case Inlist( lcToken, "}", "]" )
						TEXT To lcMsg NoShow TextMerge Pretext 03
						Token no permitido ( <<lcToken>> )
						ENDTEXT

						This.cError_Msg = lcMsg

						lcCommand = lcMsg + CRLF + CRLF + oVfp_Obj.cJson_Str
						Error Program() + " - Caracter No Válido"


					Case lcToken = "{"
						Set Step On 
						lvValue = This.GetNewObject( lcJSON_Str, oVfp_Obj, .T. )

					Case lcToken = "["
						* Begin Collection
						*Set Step On
						lvValue = This.GetCollectionItems( lcJSON_Str, oVfp_Obj )
						oVfp_Obj.cJson_Str = lvValue.cJson_Str

					Otherwise

						Do Case
							Case Upper( Substr( lcJSON_Str, 1, 4 )) = "TRUE"
								lvValue = .T.
								lcJSON_Str = Substr( lcJSON_Str, 5 )

							Case Upper( Substr( lcJSON_Str, 1, 5 )) = "FALSE"
								lvValue = .F.
								lcJSON_Str = Substr( lcJSON_Str, 6 )

							Case Inlist( Upper( Substr( lcJSON_Str, 1, 4 )), "NULL", "NILL" )
								lvValue = Null
								lcJSON_Str = Substr( lcJSON_Str, 5 )

							Otherwise

								If lcToken = ["]
									llIsChar = .T.

									If lcToken = Substr( lcJSON_Str, 2, 1 )
										lcValue = ""
										lcJSON_Str 	= Substr( lcJSON_Str, 3 )

									Else
										lcValue 	= Getwordnum( lcJSON_Str, 1, lcToken )
										lcJSON_Str 	= Substr( lcJSON_Str, Len( lcValue ) + 2 )

									Endif

								Else
									llIsChar = .F.
									lcFin = Getwordnum( lcJSON_Str, 1, "}" )
									*lcValue 	= Getwordnum( lcJSON_Str, 1, "," )
									lcValue 	= Getwordnum( lcJSON_Str, 1, ["] )
									
									If Len( lcFin ) < Len( lcValue ) 
										lcValue = lcFin 
									EndIf
									lcJSON_Str 	= Substr( lcJSON_Str, Len( lcValue ) )

								Endif


								lcChar 	= Substr( lcJSON_Str, 1, 1 )

*!*									Do While !Inlist( lcChar, '}', ']', ',', '' )
*!*										lcJSON_Str 	= Substr( lcJSON_Str, 2 )
*!*										lcChar 		= Substr( lcJSON_Str, 1, 1 )
*!*									Enddo

								Do While !Inlist( lcChar, '}', ']', '"', '' )
									lcJSON_Str 	= Substr( lcJSON_Str, 2 )
									lcChar 		= Substr( lcJSON_Str, 1, 1 )
								Enddo

								lcValue = Strtran( lcValue, "}", "" )
								lcValue = Strtran( lcValue, "]", "" )

								lnLen = Len( lcValue )
								llIsDigit = !Empty( lcValue ) And !llIsChar

								If llIsDigit
									For i = 1 To lnLen
										lcChar = Substr( lcValue, i, 1 )
										If !Inlist( lcChar, ".", "," )
											If !Isdigit( lcChar )
												llIsDigit = .F.
												Exit
											Endif
										Endif
									Endfor
								Endif

								If llIsDigit
									If !Empty( At( ".", lcValue ))
										lnWidth = Len( lcValue )
										lnDecimal = Len( lcValue ) - Rat( ".", lcValue )

										TEXT To lcCommand NoShow TextMerge Pretext 15
										lvValue = Cast( lcValue as N( <<lnWidth>>, <<lnDecimal>> ))
										ENDTEXT

										&lcCommand
										lcCommand = ""

									Else
										lvValue = Int( Val( lcValue ))

									Endif

								Else
									lcValue = Strtran( lcValue, '"', '' )
									lvValue = lcValue

									* RA 04/01/2020(15:31:47)
									* Puede haber un string "   1-   1-    1" que es string,
									* y no debe ser convertido a fecha
									*!*	lvValue = Ctod( lcValue )

									*!*	If Empty( lvValue )
									*!*		lvValue = lcValue
									*!*	Endif

								Endif

						Endcase

						oVfp_Obj.cJson_Str = lcJSON_Str

				Endcase

				If llIsChar
					lvValue = This.InsertEscapeChar( lvValue )
				Endif

			Else
				TEXT To lcMsg NoShow TextMerge Pretext 03
				Debia recibir ( { ) y recibi ( <<lcToken>> )
				ENDTEXT

				This.cError_Msg = lcMsg

				lcCommand = lcMsg + CRLF + CRLF + oVfp_Obj.cJson_Str
				Error Program() + " - Caracter No Válido"

			Endif

		Catch To loErr

			If This.lDebug
				Set Step On
			Endif

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr, .F. )
			Throw loError

		Finally

		Endtry

		Return lvValue

	Endproc && GetValue



	*
	*
	Procedure InsertEscapeChar( vValue As Variant ) As Variant
		Local lcCommand As String
		Local lnAt As Integer

		Try

			lcCommand = ""

			If Inlist( Vartype( vValue ), "C", "M", "G", "Q" )
				lnAt = At( "<#<", vValue )
				If !Empty( lnAt )

					For i = 1 To Alen( aEscChar, 1 )
						lnAt = At( "<#<", vValue )
						If Empty( lnAt )
							Exit

						Else
							lnAt = At( aEscChar[ i, 1 ], vValue )
							Do While !Empty( lnAt )
								vValue = Stuff( vValue, lnAt, Len( aEscChar[ i, 1 ] ), aEscChar[ i, 2 ] )
								lnAt = At( aEscChar[ i, 1 ], vValue )
							Enddo

						Endif

					Endfor

				Endif
			Endif


		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally

		Endtry

		Return vValue

	Endproc && InsertEscapeChar

	*
	*
	Procedure GetCollectionItems( cJson_Str As String,;
			oVfp_Obj As Object  ) As Object
		Local lcCommand As String,;
			lcJSON_Str As String,;
			lcValues As String,;
			lcValue As String,;
			lcObjStr As String

		Local lcToken As Character,;
			lcContiene As String,;
			lcNoContiene As String

		Local loCol As Collection,;
			loObj As Object
		Local lnWordCount As Integer,;
			i As Integer,;
			lnLen As Integer

		Local lvValue As Variant
		Local llContieneColecciones As Boolean

		Try

			lcCommand = ""

			loCol = Createobject( "Collection" )
			AddProperty( loCol, "cJson_Str", cJson_Str )

			lcJSON_Str = Alltrim( cJson_Str )
			lcToken = Substr( lcJSON_Str, 1, 1 )

			If lcToken = '['
				Do While .T.
					Do Case
						Case Substr( Alltrim( Substr( lcJSON_Str, 1 ) ), 1, 1 ) = "]"
							Exit

						Case Substr( Alltrim( Substr( lcJSON_Str, 2 ) ), 1, 1 ) # "]"
							lcContiene 		= Getwordnum( Substr( lcJSON_Str, 2 ), 1, "[" )
							lcNoContiene 	= Getwordnum( Substr( lcJSON_Str, 2 ), 1, "]" )

							If ( Len( lcContiene ) > 1 ) ;
									And ( Len( lcContiene ) < Len( lcNoContiene ))

								llContieneColecciones = .T.
								lcValues = lcContiene

							Else
								llContieneColecciones = .F.
								lcValues = lcNoContiene

							Endif

							lnLen = Len( lcValues )

							If lnLen <= 1
								Exit
							Endif

							If Substr( Alltrim( lcValues ), 1, 1 ) = '{'

								lcValue = Alltrim( Substr( lcJSON_Str, 2 ) )

								loObj = Createobject( "Empty" )
								AddProperty( loObj, "cJson_Str", lcValue )
								loObj = This.GetNewObject( lcValue, loObj, .F. )
								loCol.cJson_Str = loObj.cJson_Str

								Removeproperty( loObj, "cJson_Str" )

								loCol.Add( loObj )

							Else
								*lnWordCount = Getwordcount( lcValues, "," )
								lnWordCount = Getwordcount( lcValues, ["] )

								For i = 1 To lnWordCount
									*lcValue = ":" + Getwordnum( lcValues, i, "," ) + ","
									lcValue = ":" + Getwordnum( lcValues, i, ["] ) + ","

									If !Inlist( lcValue, ":,,", ": ]," )
										lvValue = This.GetValue( lcValue, oVfp_Obj )
										loCol.Add( lvValue )
									Endif
								Endfor

								lnLen = At( "]", loCol.cJson_Str )

								loCol.cJson_Str = Substr( loCol.cJson_Str, lnLen )

								Exit

							Endif

							*loCol.cJson_Str = Strtran( cJson_Str, lcValues, "" )
							loCol.cJson_Str = Alltrim( loCol.cJson_Str )
							lcJSON_Str = loCol.cJson_Str

						Otherwise
							Exit

					Endcase

				Enddo

				Do While Inlist( Substr( loCol.cJson_Str, 1, 1 ), '[', ']' )
					*Do While InList( Substr( loCol.cJson_Str, 1, 1 ), '[' )
					loCol.cJson_Str = Alltrim( Substr( loCol.cJson_Str, 2 ))
				Enddo

			Else
				TEXT To lcMsg NoShow TextMerge Pretext 03
				Debia recibir ( [ ) y recibi ( <<lcToken>> )
				ENDTEXT

				This.cError_Msg = lcMsg

				lcCommand = lcMsg + CRLF + CRLF + oVfp_Obj.cJson_Str
				Error Program() + " - Caracter No Válido"

			Endif


		Catch To loErr

			If This.lDebug
				Set Step On
			Endif

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr, .F. )
			Throw loError

		Finally

		Endtry

		Return loCol

	Endproc && GetCollectionItems


	*
	*
	Procedure xxxGetCollectionItems( cJson_Str As String,;
			oVfp_Obj As Object  ) As Object
		Local lcCommand As String,;
			lcJSON_Str As String,;
			lcValues As String,;
			lcValue As String,;
			lcObjStr As String

		Local lcToken As Character,;
			lcContiene As String,;
			lcNoContiene As String

		Local loCol As Collection,;
			loObj As Object
		Local lnWordCount As Integer,;
			i As Integer,;
			lnLen As Integer

		Local lvValue As Variant
		Local llContieneColecciones As Boolean

		Try

			lcCommand = ""

			loCol = Createobject( "Collection" )
			AddProperty( loCol, "cJson_Str", cJson_Str )

			lcJSON_Str = Alltrim( cJson_Str )
			lcToken = Substr( lcJSON_Str, 1, 1 )

			If lcToken = '['
				Do While .T.
					Do Case
						Case Substr( Alltrim( Substr( lcJSON_Str, 1 ) ), 1, 1 ) = "]"
							Exit

						Case Substr( Alltrim( Substr( lcJSON_Str, 2 ) ), 1, 1 ) # "]"
							lcContiene 		= Getwordnum( Substr( lcJSON_Str, 2 ), 1, "[" )
							lcNoContiene 	= Getwordnum( Substr( lcJSON_Str, 2 ), 1, "]" )

							If ( Len( lcContiene ) > 1 ) ;
									And ( Len( lcContiene ) < Len( lcNoContiene ))

								llContieneColecciones = .T.
								lcValues = lcContiene

							Else
								llContieneColecciones = .F.
								lcValues = lcNoContiene

							Endif

							lnLen = Len( lcValues )

							If lnLen <= 1
								Exit
							Endif

							If Substr( Alltrim( lcValues ), 1, 1 ) = '{'

								lcValue = Alltrim( Substr( lcJSON_Str, 2 ) )

								loObj = Createobject( "Empty" )
								AddProperty( loObj, "cJson_Str", lcValue )
								loObj = This.GetNewObject( lcValue, loObj, .F. )
								loCol.cJson_Str = loObj.cJson_Str

								Removeproperty( loObj, "cJson_Str" )

								loCol.Add( loObj )


							Else
								lnWordCount = Getwordcount( lcValues, "," )

								For i = 1 To lnWordCount
									lcValue = ":" + Getwordnum( lcValues, i, "," ) + ","
									lvValue = This.GetValue( lcValue, oVfp_Obj )

									loCol.Add( lvValue )
								Endfor

								lnLen = At( "]", loCol.cJson_Str )

								loCol.cJson_Str = Substr( loCol.cJson_Str, lnLen )

								Exit

							Endif

							*loCol.cJson_Str = Strtran( cJson_Str, lcValues, "" )
							loCol.cJson_Str = Alltrim( loCol.cJson_Str )
							lcJSON_Str = loCol.cJson_Str

						Otherwise
							Exit

					Endcase

				Enddo

				Do While Inlist( Substr( loCol.cJson_Str, 1, 1 ), '[', ']' )
					*Do While InList( Substr( loCol.cJson_Str, 1, 1 ), '[' )
					loCol.cJson_Str = Alltrim( Substr( loCol.cJson_Str, 2 ))
				Enddo

			Else
				TEXT To lcMsg NoShow TextMerge Pretext 03
				Debia recibir ( [ ) y recibi ( <<lcToken>> )
				ENDTEXT

				This.cError_Msg = lcMsg

				lcCommand = lcMsg + CRLF + CRLF + oVfp_Obj.cJson_Str
				Error Program() + " - Caracter No Válido"

			Endif


		Catch To loErr

			If This.lDebug
				Set Step On
			Endif

			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr, .F. )
			Throw loError

		Finally

		Endtry

		Return loCol

	Endproc && xxxGetCollectionItems

	*
	*
	Procedure ForceDate( uValue As Variant ) As Date
		Local lcCommand As String,;
			lcDate As String,;
			lcCentury As String

		Local ldValue As Date

		Try

			lcCommand = ""

			lcDate = Set("Date")
			lcCentury = Set("Century")

			Set Date YMD
			Set Century On

			Do Case
				Case Inlist( Vartype( uValue ), "D", "T" )
					ldValue = uValue

				Case Vartype( uValue ) = "C"
					If Len( uValue ) > 10
						ldValue = Ctot( uValue )

					Else
						ldValue = Ctod( uValue )

					Endif

				Otherwise
					ldValue = Cast( uValue As D )

			Endcase

		Catch To loErr
			Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
			loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
			loError.cRemark = lcCommand
			loError.Process ( m.loErr )
			Throw loError

		Finally
			Set Date &lcDate
			Set Century &lcCentury

		Endtry

		Return ldValue

	Endproc && ForceDate



Enddefine
*!*
*!* END DEFINE
*!* Class.........: prxJSON
*!*
*!* ///////////////////////////////////////////////////////

