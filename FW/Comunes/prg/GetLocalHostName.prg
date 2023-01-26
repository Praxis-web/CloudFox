*
* 
PROCEDURE GetLocalHostName(  ) AS Void
	Local lcCommand as String,;
	lcLocalHostName as String 
	Local o as "MSWinsock.Winsock"
	
	Try
	
		lcCommand = ""
		lcLocalHostName = ""
		o = Createobject( "MSWinsock.Winsock" )
		If Vartype(o)=="O"
			lcLocalHostName = o.LocalHostName 
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
	
	Return lcLocalHostName 

EndProc && GetLocalHostName

