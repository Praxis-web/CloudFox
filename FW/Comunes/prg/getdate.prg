#INCLUDE "FW\Comunes\Include\Praxis.h"

Lparameters tdDate As Date, tnAction As Integer, tnPeriods as Integer 



*!*	#Define GD_FIRST_CURRENT_MONTH	1
*!*	#Define GD_FIRST_LAST_MONTH		2
*!*	#Define GD_FIRST_NEXT_MONTH		3
*!*	#Define GD_LAST_CURRENT_MONTH	4
*!*	#Define GD_LAST_LAST_MONTH		5
*!*	#Define GD_LAST_NEXT_MONTH		6
*!*	#Define GD_SAME_NEXT_YEAR		7
*!*	#Define GD_SAME_LAST_YEAR		8


Local lnDay As Integer,;
	lnMonth As Integer,;
	lnYear As Integer

Local ldDate As Date

Try

	If Empty( tnPeriods ) 
		tnPeriods = 1
	EndIf
	
	tnPeriods = Abs( tnPeriods )

	If !Empty( tdDate )

		Do Case
			Case Inlist( tnAction, GD_FIRST_LAST_MONTH, GD_LAST_LAST_MONTH )
				*lnMonth =  Iif( Month( tdDate ) = 1, 12, Month( tdDate ) - 1 )
				*lnYear = Iif( Month( tdDate ) = 1, Year( tdDate ) - 1, Year( tdDate ) ) 
				
				lnYear = Year( tdDate )  
				lnMonth = Month( tdDate ) - tnPeriods
				
				Do While lnMonth < 1 
					lnMonth = lnMonth + 12  
					lnYear = lnYear - 1
				EndDo
				
				
			Case Inlist( tnAction, GD_FIRST_CURRENT_MONTH, GD_LAST_CURRENT_MONTH )
				*lnMonth =  Month( tdDate )
				*lnYear = Year( tdDate )

				tnPeriods = tnPeriods - 1  
				lnYear = Year( tdDate )  
				lnMonth = Month( tdDate ) - tnPeriods
				
				Do While lnMonth < 1 
					lnMonth = lnMonth + 12  
					lnYear = lnYear - 1
				EndDo
				
					
			Case Inlist( tnAction, GD_FIRST_NEXT_MONTH, GD_LAST_NEXT_MONTH )
				*lnMonth =  Iif( Month( tdDate ) = 12, 1, Month( tdDate ) + 1 )
				*lnYear = Iif( Month( tdDate ) = 12, Year( tdDate ) + 1, Year( tdDate ) ) 
			
				lnYear = Year( tdDate )  
				lnMonth = Month( tdDate ) + tnPeriods
				
				Do While lnMonth > 12
					lnMonth = lnMonth - 12  
					lnYear = lnYear + 1
				EndDo
				
			
			Case tnAction = GD_SAME_NEXT_YEAR
				lnMonth =  Month( tdDate )
				lnYear = Year( tdDate ) + tnPeriods  
				lnDay = Day( tdDate )

			Case tnAction = GD_SAME_LAST_YEAR
				lnMonth =  Month( tdDate )
				lnYear = Year( tdDate ) - tnPeriods  
				lnDay = Day( tdDate )

			Case tnAction = GD_FIRST_CURRENT_YEAR
				tnPeriods = tnPeriods - 1
				lnMonth =  1
				lnYear = Year( tdDate ) - tnPeriods

			Otherwise
				Error "GetDate() - Parametro no definido: " + Transform( tnAction )
				
		EndCase
		
		Text To lcDate NoShow TextMerge Pretext 15
		{^<<lnYear>>/<<lnMonth>>/01}  
		EndText
		
		Do Case
		Case Inlist( tnAction, GD_FIRST_CURRENT_MONTH, GD_FIRST_LAST_MONTH, GD_FIRST_NEXT_MONTH, GD_FIRST_CURRENT_YEAR )
			ldDate = Evaluate( lcDate )
			 
		Case Inlist( tnAction, GD_LAST_CURRENT_MONTH, GD_LAST_LAST_MONTH, GD_LAST_NEXT_MONTH )

			ldDate = GetDate( Evaluate( lcDate ), GD_FIRST_NEXT_MONTH ) - 1  

		Case Inlist( tnAction, GD_SAME_NEXT_YEAR, GD_SAME_LAST_YEAR )
			Text To lcDate NoShow TextMerge Pretext 15
			{^<<lnYear>>/<<lnMonth>>/<<lnDay>>}  
			EndText
		
			ldDate = Evaluate( lcDate )

		Otherwise
			Error "GetDate() - Parametro no definido: " + Transform( tnAction )
			
		EndCase

	Else
		ldDate = tdDate

	Endif

Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

EndTry

Return ldDate  