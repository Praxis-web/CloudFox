*
* 
PROCEDURE GetLocalIP(  ) AS Void
	Local lcCommand as String,;
	lcLocalIP as String 
	Local o as "MSWinsock.Winsock"
	
	Try
	
		lcCommand = ""
		lcLocalIP = ""
		o = Createobject( "MSWinsock.Winsock" )
		If Vartype(o)=="O"
			lcLocalIP = o.LocalIP
		Endif
		
		
	Catch To loErr
		Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
		loError = NewObject ( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
		loError.cRemark = lcCommand
		loError.Process ( m.loErr )
		Throw loError

	Finally
		o = Null

	EndTry
	
	Return lcLocalIP  

EndProc && GetLocalIP

