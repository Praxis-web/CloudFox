Lparameters tcExpressionSearched As String,;
	tcTableName As String,;
	tcFieldList As String,;
	tcKeyFieldName As String,;
	tcFilterCriteria as String,;
	tcAlias as String 


*!*	Busca un conjunto de datos en el que el campo de busqueda contenga la expresion de busqueda
*!*	Si ésta se compone de más de una palabra, deberá tener todas las palabras, sin importar el orden

*!*	tcExpressionSearched:	Expresion de Búsqueda
*!*	tcTableName: 			Nombre de la tabla sobre la que se buscará
*!*	tcFieldList: 			Lista de Campos que se traerán en la vista
*!*	tcKeyFieldName:			Nombre del campo sobre el cual se efectuará la búsqueda
*!*	tcFilterCriteria 		Criterio de filtro adicional

Local lnLen As Integer,;
	i As Integer
Local lcCommand As String,;
	lcAuxCursor As String,;
	lcReturnCursor As String

Local loDataTier As PrxDataTier Of "Fw\Tieradapter\Comun\Prxdatatier.prg"

Try
	
	lcAuxCursor = Sys( 2015 )
	lcReturnCursor = Sys( 2015 )

	loDataTier = Newobject( "PrxDataTier", "Fw\Tieradapter\Comun\Prxdatatier.prg" )
	
	If Empty( tcFilterCriteria )
		tcFilterCriteria = " 1 > 0 "
	EndIf

	If Empty( tcAlias ) 
		tcAlias = "" 
	EndIf
	
	* Busca cuantas palabras hay
	lnLen = Getwordcount( tcExpressionSearched )

	If !Empty( tcExpressionSearched )
		Dimension laWords[ lnLen ]

		For i = 1 To lnLen
			laWords[ i ] = Lower( Getwordnum( tcExpressionSearched, i ))
		Endfor

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select 	<<tcFieldList>>
			From <<tcTableName>> <<tcAlias>>
			Where Lower( <<tcKeyFieldName>> ) Like '%<<laWords[ 1 ]>>%'
			And ( <<tcFilterCriteria>> )
			Order by <<tcKeyFieldName>>
		ENDTEXT

		loDataTier.SQLExecute( lcCommand, lcAuxCursor + "1" )

		For i = 2 To lnLen

			TEXT To lcCommand NoShow TextMerge Pretext 15
			Select 	<<tcFieldList>>
				From <<lcAuxCursor>><<i-1>> <<tcAlias>>
				Where Lower( <<tcKeyFieldName>> ) Like '%<<laWords[ i ]>>%'
				Order by <<tcKeyFieldName>>
				Into Cursor <<lcAuxCursor>><<i>>
			ENDTEXT

			&lcCommand

		Endfor

		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select *
			From <<lcAuxCursor>><<lnLen>>
			Into Cursor <<lcReturnCursor>> ReadWrite
		ENDTEXT

		&lcCommand

	Else
		TEXT To lcCommand NoShow TextMerge Pretext 15
		Select 	<<tcFieldList>>
			From <<tcTableName>> <<tcAlias>>
			Where <<tcFilterCriteria>> 
			Order by <<tcKeyFieldName>>
		ENDTEXT

		loDataTier.SQLExecute( lcCommand, lcReturnCursor )

	Endif


Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.cRemark = lcCommand   
	loError.Process( oErr )
	Throw loError

Finally
	
	loDataTier = Null
	
	For i = 1 To lnLen

		TEXT To lcCommand NoShow TextMerge Pretext 15
			Use in Select( '<<lcAuxCursor>><<i>>' )
		ENDTEXT

		&lcCommand

	Endfor

Endtry

Return lcReturnCursor