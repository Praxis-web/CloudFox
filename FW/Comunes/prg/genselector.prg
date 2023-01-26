#INCLUDE "FW\Comunes\Include\Praxis.h" 

Lparameters lcFormName as String

Local lcClassLibrary as String,;
	lcClass as String,;
	lcCommand as String 
	
lcClass= "vpSelector"
lcClassLibrary = "vpBase"

Try

	Set Path To Addbs(FL_SOURCE) additive
		
	Text To lcCommand NoShow TextMerge
	Create Form <<"'"+Addbs(VP_SCX)+lcFormName+"'">>
	as <<lcClass>>
	FROM <<"'"+Addbs(VP_VCX)+lcClassLibrary+"'">>
	EndText
	
	lcCommand = CleanString( lcCommand )  
	
	&lcCommand

Catch To oErr
	Local loError as ErrorHandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"
	loError = NewObject( "ErrorHandler", Addbs( EH_PRG ) + "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	
	loError.Process( oErr )
	
Finally

EndTry