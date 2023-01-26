Lparameters tuData as Variant,;
tcMsg as String,;
tcInputMask as String,; 
tcFormat as String,;
tcUDF_Valid as String 

Local luData as Variant 	
Try

	Do Form "fw\Comunes\scx\frmgetrequireddata.scx" with tuData, tcMsg, tcInputMask, tcFormat, tcUDF_Valid to tuData 

Catch To oErr
	Local loError as Errorhandler OF "Tools\ErrorHandler\Prg\ErrorHandler.prg"

	loError = NewObject( "Errorhandler", "Tools\ErrorHandler\Prg\ErrorHandler.prg" )
	loError.Process( oErr )
	Throw loError

Finally

EndTry

Return tuData