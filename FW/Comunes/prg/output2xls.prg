Lparameters tcAlias As String,;
	lcFName As String,;
	tcUDF as String,;
	tcExcludedFieldList as String,;
	toSetup as Object 
	
	
Local llDone as Boolean 	
Local loDT As PrxDataTier Of "V:\Clipper2fox\Fw\Tieradapter\Comun\Prxdatatier.prg"
Local lcFieldList as String,;
lcAlias as String,;
lcMsg as String,;
lcFileName as String 

Local lnRecount as Integer 

Try
	llDone = .F.
	lcAlias = Sys(2015) 
	Inkey()
	
	lcFileName = ""
	
	Wait Windows Nowait "Generando Hoja de Cálculo ...."
	
	If Empty( lcFName ) 
		lcFName = "" 
	EndIf
	 
	lcFName = Strtran( lcFName, "/", "-" )
	lcFName = Strtran( lcFName, ":", "" )
	lcFName = Strtran( lcFName, "*", "" )
	
	If !Empty( tcExcludedFieldList ) 
		loDT = NewDT()
		lcFieldList = loDT.GetUpdatableFieldListFromTable( tcAlias, tcExcludedFieldList )   
		
		Text To lcCommand NoShow TextMerge Pretext 15
		Select <<lcFieldList>>
			From <<tcAlias>>
			With ( Buffering = .T. ) 
			Into Cursor <<lcAlias>> ReadWrite
		EndText

		&lcCommand
		
		Use in Select( tcAlias )
		tcAlias = lcAlias   
 
	EndIf
	
	lnRecount = Reccount( tcAlias ) 
	
	If lnRecount > ( 2 ^ 16 )
		lcAlias = Sys(2015) 
		
		Text To lcCommand NoShow TextMerge Pretext 15
		Select *
		From <<tcAlias>>
		With ( Buffering = .T. ) 
		Into Cursor <<lcAlias>> ReadWrite
		Where Recno() < ( 2 ^ 16 )
		EndText

		&lcCommand

		Use in Select( tcAlias )
		tcAlias = lcAlias   
 
		Text To lcMsg NoShow TextMerge Pretext 03
		La cantidad de registros supera
		los <<( 2 ^ 16 )>>, cantidad máxima
		de filas permitida por la Hoja de Cálculo.
		EndText
		
		Warning( lcMsg, "Demasiados Registros" ) 


	EndIf
	   
	Try
		loExcel = Createobject("Excel.application")
		If Vartype( loExcel ) ="O"
			loExcel = Null
			llDone = .T.
			lcFileName = Dbf2Xls( tcAlias, lcFName, tcUDF, toSetup )
		Endif

	Catch To loErr
	
*!*			Local lcCommand as String, lcMsg as String 

*!*				lcCommand = ""


*!*				Do While Vartype( loErr.UserValue ) == "O"
*!*					loErr = loErr.UserValue
*!*				Enddo

*!*				lcMsg = Ttoc( Datetime()) + Chr( 13 ) + Chr( 10 )
*!*				lcMsg = lcMsg + "[  METODO   ] " + loErr.Procedure + Chr( 13 ) + Chr( 10 )
*!*				lcMsg = lcMsg + "[  LINEA Nº ] " + Transform(loErr.Lineno) + Chr( 13 ) + Chr( 10 )
*!*				lcMsg = lcMsg + "[  COMANDO  ] " + loErr.LineContents + Chr( 13 ) + Chr( 10 )
*!*				lcMsg = lcMsg + "[  ERROR    ] " + Transform(loErr.ErrorNo) + Chr( 13 ) + Chr( 10 )
*!*				lcMsg = lcMsg + "[  MENSAJE  ] " + loErr.Message + Chr( 13 ) + Chr( 10 )
*!*				lcMsg = lcMsg + "[  DETALLE  ] " + loErr.Details + Chr( 13 ) + Chr( 10 )
*!*				lcMsg = lcMsg + "[  ALIAS    ] " + Alias() + Chr( 13 ) + Chr( 10 )
*!*				lcMsg = lcMsg + Replicate( "-", 80 ) + Chr( 13 ) + Chr( 10 )

*!*				Messagebox( lcMsg, 16, "Error" )

		Try
			loOO = Newobject( "Calc", "Tools\Openoffice\Prg\OpenOffice.prg" )

			If Vartype( loOO ) = "O"
				loOO = Null
				llDone = .T.
				Dbf2Calc( tcAlias, lcFName, tcUDF, toSetup )
				
			Endif

		Catch To oErr

		Finally
			loOO = Null
			
		Endtry

	Finally
		loExcel = Null
		
	Endtry

	If !llDone  
		Text To lcCommand NoShow TextMerge Pretext 03
		No se encuentra instalada 
		ninguna planilla de cálculo
		EndText

		Stop( lcCommand )
		
	EndIf
	
Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally
	Wait Clear
	loDT = Null
	Use in Select( lcAlias ) 
	
Endtry

Return llDone  