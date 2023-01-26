Lparameters lcFileSkeleton As String,;
	lcUnit as Character 

Local lnSize as Integer 
Local Array laDir[ 1 ]

Try

	lnSize = 0
	If Empty( lcUnit ) 
		lcUnit = "M"
	EndIf
	
	lcUnit = Upper( lcUnit )
	
	If !InList( lcUnit, "B", "K", "M", "G", "T" )
		lcUnit = "M" 
	EndIf  
	
	If Adir( laDir, lcFileSkeleton ) = 1
		lnSize = laDir[ 1, 2 ]
		
		Do Case
		Case lcUnit = "B" 
		
		Case lcUnit = "K" 
			lnSize = lnSize / ( 2^10 )
		
		Case lcUnit = "M"
			lnSize = lnSize / ( 2^20 )   
		
		Case lcUnit = "G" 
			lnSize = lnSize / ( 2^30 )   
		
		Case lcUnit = "T" 
			lnSize = lnSize / ( 2^40 )   

		Otherwise

		EndCase
	EndIf
	
Catch To oErr
	Local loError As Errorhandler Of "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = Newobject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

Endtry

Return lnSize  