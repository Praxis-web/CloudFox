*!*	Procedure ExecuteSaveScreen( tcCommand as String, toParam as Object )
Lparameters tcCommand as String, toParam as Object 

Try

	Do Form "Rutinas\Scx\SaveScreenform" With tcCommand, toParam 

Catch To loErr
	Local loError As ErrorHandler Of 'Tools\ErrorHandler\Prg\ErrorHandler.prg'
	loError = NewObject( 'ErrorHandler', 'Tools\ErrorHandler\Prg\ErrorHandler.prg' )
	loError.Process ( m.loErr )


Finally


Endtry


