#INCLUDE "FW\Comunes\Include\Praxis.h"

*!*	*
*!*	* Consulta de Archivos al ar4Var
*!*	Procedure Prx_Tabla( tcTabla As Character,;
*!*			tcFieldName As String,;
*!*			tuKey As Variant,;
*!*			tcFilter As String ) As Void;
*!*			HELPSTRING "Consulta de Archivos al ar4Var"


*
* Consulta de Archivos al ar4Var
Lparameters tcTabla As Character,;
	tcFieldName As String,;
	tuKey As Variant,;
	tcFilter As String,;
	tcJoin As String,;
	tcFieldList As String,;
		lcOrder as String 

Set Procedure To rutinas\prg\CallSelector.prg Additive


Local lcErrMsg As String

Local lcWhere As String,;
	lcOrderBy As String,;
	lcFieldName As String,;
	lcFields As String,;
	lcFilter As String,;
	lcCommand As String,;
	lcJoin As String,;
	lcFieldList As String

Local lcTabla As Character

Local luKey As Variant

*!*	Local loDataTier As PrxDataTier Of "Fw\Tieradapter\Comun\Prxdatatier.prg"

Local loColFields As Collection
Local loColPictures As Collection
Local loColHeaders As Collection

Local lcAlias As String

Local lnStart As Number,;
	lnLapso As Number
	
Local llVersionNueva as Boolean 

Try


	lcCommand 	= ""
	
	* RA 14/08/2018(17:38:09)
	* Hace un Seek() y un Scan en vez de un Select
	llVersionNueva = .T. 

	Release gn4Var_Codi4

	lcAlias		= Alias()
	lcOrder 	= Order( "ar4Var" ) 

	lcTabla 	= tcTabla
	lcFieldName = tcFieldName
	lcFilter 	= tcFilter
	luKey 		= tuKey
	lcJoin 		= tcJoin
	lcFieldList = tcFieldList

	If Empty( lcFilter )
		lcFilter = Filter( "ar4Var" )
	Endif

	If Empty( lcFilter )
		lcFilter = "( 1 > 0 )"
	Endif

	If Empty( lcJoin )
		lcJoin = ""
	Endif

	If Empty( lcFieldList )
		lcFieldList = ""
	Else
		lcFieldList = "," + lcFieldList
	Endif

	* Compatibilidad con AR_TABLA

	If Vartype( lcTabla ) # "C" Or Empty( lcTabla )
		If Vartype( TABLA ) = "C"
			lcTabla = TABLA

		Else
			TEXT To lcErrMsg NoShow TextMerge Pretext 03
				Prx_Tabla
				Falta definir la Tabla asociada
			ENDTEXT

			Error lcErrMsg

		Endif
	Endif

	If Vartype( WINDE ) # "N"
		WINDE = 1
	Endif

	If Vartype( lcFieldName ) # "C"
		If Empty( WINDE )
			lcFieldName = "CODI4"

		Else
			Do Case
				Case WINDE = 1
					lcFieldName = "CODI4"

				Case WINDE = 2
					lcFieldName = "NOMB4"

				Case WINDE = 3
					lcFieldName = "FANT4"

				Case WINDE = 6
					lcFieldName = "ALIA4"

				Case WINDE = 7
					lcFieldName = "CUIT4"

				Case WINDE = 8
					lcFieldName = "TELE4"

				Otherwise
					lcFieldName = "CODI4"

			Endcase
		Endif
	Endif

	If Vartype( F091 ) = "U"
		If WINDE=1
			F091 = 0

		Else
			F091 = ""

		Endif
	Endif

	If Empty( luKey )
		luKey = F091
	Endif

	lcFieldName = Upper( lcFieldName )
	
	TEXT To lcWhere NoShow TextMerge Pretext 15
		( v4.TIPO4 = '<<lcTabla>>' )
	ENDTEXT

	TEXT To lcOrderBy NoShow TextMerge Pretext 15
		Order By v4.<<lcFieldName>>
	ENDTEXT


	loColFields = Createobject( "Collection" )
	loColPictures = Createobject( "Collection" )
	loColHeaders = Createobject( "Collection" )

	*!*		loDataTier = Newobject( "PrxDataTier", "Fw\Tieradapter\Comun\Prxdatatier.prg" )

	*!*		TEXT To lcCommand NoShow TextMerge Pretext 15
	*!*			Select * From ar4Var Where 1 = 0
	*!*		ENDTEXT

	*!*		loDataTier.SQLExecute( lcCommand, "cTabla" )

	TEXT To lcCommand NoShow TextMerge Pretext 15
	Select * From ar4Var Where 1 = 0
	Into cursor cTabla
	ENDTEXT

	&lcCommand
	lcCommand = ""


	Do Case
		Case Inlist( lcFieldName, "CODI4", "NOMB4" )
			TEXT To lcFields NoShow TextMerge Pretext 15
					v4.Codi4,
					v4.Nomb4
			ENDTEXT

			loColFields.Add( "CODI4" )
			loColPictures.Add( Replicate( "9", gnCodi4 ))
			loColHeaders.Add( "CODIGO" )

			loColFields.Add( "NOMB4" )
			loColPictures.Add( Replicate( "X", Fsize( "NOMB4", "cTabla" )))
			loColHeaders.Add( "N O M B R E" )


		Otherwise
			TEXT To lcFields NoShow TextMerge Pretext 15
					v4.Codi4,
					v4.<<lcFieldName>>,
					v4.Nomb4
			ENDTEXT

			loColFields.Add( "CODI4" )
			loColPictures.Add( Replicate( "9", gnCodi4 ))
			loColHeaders.Add( "CODIGO" )

			loColFields.Add( lcFieldName )
			loColPictures.Add( Replicate( "X", Fsize( lcFieldName, "cTabla" )))

			Do Case
				Case lcFieldName = "ALIA4"
					loColHeaders.Add( "ALIAS" )

				Case lcFieldName = "FANT4"
					loColHeaders.Add( "NOMBRE FANTASIA" )

				Case lcFieldName = "CUIT4"
					loColHeaders.Add( "CUIT / DNI" )

				Case lcFieldName = "DOMI4"
					loColHeaders.Add( "DOMICILIO" )

			Endcase


			loColFields.Add( "NOMB4" )
			loColPictures.Add( Replicate( "X", Fsize( "NOMB4", "cTabla" )))
			loColHeaders.Add( "N O M B R E" )

	Endcase


	*If Inlist( WINDE, 2, 3, 4 ) && And .F.
	If Inlist( lcFieldName, "NOMB4", "FANT4", "ALIA4", "TELE4", "DOMI4" ) ;
		And ( GetValue( 'BuscaIntel', "ar0Var", "S" ) = "S" )
		* RA 2012-11-23(18:58:32)
		* Testeo de Busqueda avanzada

		tcExpressionSearched	= luKey		&&	Expresion de Búsqueda
		tcKeyFieldName			= lcFieldName	&& Nombre del campo sobre el cual se efectuará la búsqueda
		tcFilterCriteria		= lcWhere

		TEXT To tcFieldList NoShow TextMerge Pretext 15
			<<lcFields>>
			<<lcFieldList>>
		ENDTEXT

		lcTableName = prxAdvancedSearch( tcExpressionSearched,;
			"ar4Var",;
			tcFieldList,;
			tcKeyFieldName,;
			tcFilterCriteria,;
			"v4" )

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select *
			From <<lcTableName>>
			Into cursor cTabla
		ENDTEXT

		&lcCommand

		Use In Select( lcTableName )

	Else

		lnStart = Seconds()
		lnLapso = lnStart

		If llVersionNueva  
		
			* RA 14/08/2018(17:03:41)
			* En algunas redes con máquinas lentas, el Select
			* con muchos archivos abiertos tarda demasiado
			
			lcFields 	= Strtran( lcFields, "v4.", "" ) 
			lcFieldList = Strtran( lcFieldList, "v4.", "" ) 
			lcJoin 		= Strtran( lcJoin, "v4.", "" ) 
			lcOrderBy 	= Strtran( lcOrderBy, "v4.", "" ) 
			lcFilter 	= Strtran( lcFilter, "v4.", "" ) 
			lcWhere 	= Strtran( lcWhere, "v4.", "" ) 
			
			
			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select
				<<lcFields>>
				<<lcFieldList>>
			From ar4Var 
			Where ( 1 = 0 )
			Into cursor cTabla ReadWrite
			ENDTEXT

			&lcCommand
			lcCommand = ""

			Select ar4Var
			Set Order To Tag Tipo4
			Seek lcTabla

			Scan Rest While Tipo4 = lcTabla

				TEXT To lcCommand NoShow TextMerge Pretext 15
				Scatter Fields
					<<lcFields>>
					<<lcFieldList>>
					Name loReg Memo
				ENDTEXT

				&lcCommand
				lcCommand = ""

				Select cTabla
				Append Blank
				Gather Name loReg Memo

				Select ar4Var

			Endscan

			Select cTabla

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select *
				From cTabla
				<<lcJoin>>
				Where <<lcFilter>>
				<<lcOrderBy>>
				Into cursor cTabla
			ENDTEXT

			&lcCommand
			*lcCommand = ""
			
		Else
			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select
				<<lcFields>>
				<<lcFieldList>>
			From ar4Var v4
			<<lcJoin>>
			Where <<lcWhere>> And <<lcFilter>>
			<<lcOrderBy>>
			Into cursor cTabla
			ENDTEXT

			&lcCommand
			*lcCommand = ""

		Endif

		lnLapso = Seconds() - lnStart

		If !Empty( Set("Coverage"))
			TEXT To lcMsg NoShow TextMerge Pretext 03
					---------------------------------------------
					<<Datetime()>> prx_Tabla
					Lapso: <<lnLapso>>

					<<lcCommand>>
			ENDTEXT

			Strtofile( lcMsg + CRLF + CRLF, Alltrim( DRVA ) + "prx_Tabla.Log", 1 )

		Endif

		lcCommand = ""


	Endif


	If Empty( _Tally )
		TEXT To lcErrMsg NoShow TextMerge Pretext 15
			No se encontraron registros
			para la consulta solicitada
		ENDTEXT

		Warning( lcErrMsg, "Consulta de tablas" )

	Else

		Select cTabla
		*Browse 

		Afields( laFields, "cTabla" )

		lnLen = Alen( laFields, 1 )

		For i = 1 To lnLen
			lcField = laFields[ i, 1 ]
			If !Inlist( Upper( lcField ), "CODI4", "NOMB4", "FANT4", "ALIA4", "CUIT4", "DOMI4" )
				loColFields.Add( lcField )
				loColPictures.Add( Replicate( "X", Fsize( lcField, "cTabla" )))
				loColHeaders.Add( Proper( lcField ))
			Endif
		Endfor


		If Vartype( luKey ) = "C"
			TEXT To lcCommand NoShow TextMerge Pretext 15
				Locate For Upper( <<lcFieldName>> ) >= Upper( luKey )
			ENDTEXT

		Else
			TEXT To lcCommand NoShow TextMerge Pretext 15
				Locate For <<lcFieldName>> >= luKey
			ENDTEXT

		Endif

		&lcCommand


		If Eof()
			Go Bottom

		Endif

		If CallSelector( loColFields,;
				loColPictures,;
				loColHeaders )

			luKey = Evaluate( "cTabla." + lcFieldName )

			Public gn4Var_Codi4
			gn4Var_Codi4 = cTabla.Codi4

			Keyboard '{ENTER}'
			prxSetLastKey( Enter )

			* Compatibilidad con AR_TABLA
			F091 = luKey

		Else
			prxSetLastKey( 0 )

		Endif

	Endif


Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = _NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.cRemark = lcCommand
	loError.Process ( m.loErr )
	Throw loError

Finally
	*!*		loDataTier = Null
	loColFields = Null
	loColPictures = Null
	loColHeaders = Null

	Use In "cTabla"
	
	Set Order To Tag &lcOrder In ar4Var

	If Used( lcAlias )
		Select Alias( lcAlias )
	Endif

Endtry

Return luKey

Endproc && Prx_Tabla


