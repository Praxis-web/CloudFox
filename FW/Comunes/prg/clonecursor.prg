*
*
Procedure CloneCursor( cOrigen As String,;
        cDestino As String,;
        lOnlySruct As Boolean ) As Integer
        
    Local lcCommand As String,;
        lcAlias As String
        
        Local lnLen as Integer 

    Try

        lcCommand = ""
        lcAlias = Alias()
        
        Use in Select( cDestino )

        Afields( laFields, cOrigen )
        Select 0
        Create Cursor ( cDestino ) From Array laFields
        
        lnLen = 0 
        
        If !lOnlySruct
        	Select Alias( cOrigen )
        	Locate 
        	
        	Scan         	
				Select Alias( cDestino )
				Append Blank 
				M_RepRec( cOrigen )
        		Select Alias( cOrigen )	
        		
        		lnLen = lnLen + 1  

        	EndScan


        EndIf


    Catch To loErr
        Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
        loError = Newobject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
        loError.cRemark = lcCommand
        loError.Process ( m.loErr )
        Throw loError

    Finally
        If !Empty( lcAlias )
            Select Alias( lcAlias )
        Endif

    EndTry
    
    Return lnLen  

Endproc && CloneCursor

